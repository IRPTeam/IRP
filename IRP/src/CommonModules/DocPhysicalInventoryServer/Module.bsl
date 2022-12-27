#Region FORM

// On create at server.
// 
// Parameters:
//  Object - See Document.PhysicalInventory.Form.DocumentForm.Object
//  Form  - See Document.PhysicalInventory.Form.DocumentForm
//  Cancel - Boolean - Cancel
//  StandardProcessing - Boolean - Standard processing
Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
		Form.PhysicalCountByLocationList.Parameters.SetParameterValue("PhysicalInventoryRef", Object.Ref);
	EndIf;
	
	RowIDInfoServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	ViewServer_V2.OnCreateAtServer(Object, Form, "ItemList");
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	RowIDInfoServer.AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters);
	Form.PhysicalCountByLocationList.Parameters.SetParameterValue("PhysicalInventoryRef", Object.Ref);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	RowIDInfoServer.OnReadAtServer(Object, Form, CurrentObject);
	Form.PhysicalCountByLocationList.Parameters.SetParameterValue("PhysicalInventoryRef", Object.Ref);
	LockDataModificationPrivileged.LockFormIfObjectIsLocked(Form, CurrentObject);
EndProcedure

#EndRegion

#Region TITLE_DECORATIONS

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Store");
	AttributesArray.Add("Status");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Attr In AttributesArray Do
		Form.GroupItems.Add(Attr, ?(ValueIsFilled(Form.Items[Attr].Title), Form.Items[Attr].Title,
			Object.Ref.Metadata().Attributes[Attr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion

#Region LIST_FORM

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region CHOICE_FORM

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region FillItemList
// Fill Item list
// 
// Parameters:
//  Object - See Document.PhysicalInventory.Form.DocumentForm.Object
//  UpdateExpCount - Boolean
Procedure FillItemList(Object, UpdateExpCount) Export
	ItemTables = GetRefilledItemTable(Object);

	// Have no any phys count by location
	If Not UpdateExpCount And ItemTables.PhysicalCount.Count() = 0 Then
		Return;
	EndIf;

	ArrayOfFillingRows = New Array();
	
	CountName = ?(UpdateExpCount, "ExpCount", "PhysCount");
	SearchTable = ?(UpdateExpCount, ItemTables.ActualStock, ItemTables.PhysicalCount);
	
	For Each Row In Object.ItemList Do
		Row[CountName] = 0;
	EndDo;
	
	If Object.UseSerialLot Then
		StrFilter = New Structure("ItemKey, SerialLotNumber, Unit");
	Else
		StrFilter = New Structure("ItemKey, Unit");
	EndIf;
	
	For Each Row In SearchTable Do
		FillPropertyValues(StrFilter, Row);
		FindRow = Object.ItemList.FindRows(StrFilter);	
		NewRow = Undefined;
		If FindRow.Count() Then
			NewRow = FindRow[0];
			NewRow[CountName] = NewRow[CountName] + Row[CountName];
		Else
			NewRow = Object.ItemList.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.Key = New UUID;
		EndIf;
		
		OldRows = ItemTables.ItemList.FindRows(New Structure("Key", NewRow.Key));
		If OldRows.Count() = 0 OR OldRows.Count() AND OldRows[0][CountName] <> NewRow[CountName] Then
			ArrayOfFillingRows.Add(NewRow);
		EndIf;
	EndDo;
	OldRows = Object.ItemList.FindRows(New Structure(CountName, 0));
	For Each OldRow In OldRows Do
		ArrayOfFillingRows.Add(OldRow);
	EndDo;
			
	ArrayOfFillingColumns = New Array();
	ArrayOfFillingColumns.Add("ItemList.ItemKey");
	If UpdateExpCount Then
		ArrayOfFillingColumns.Add("ItemList.ExpCount");
	Else
		ArrayOfFillingColumns.Add("ItemList.PhysCount");
	EndIf;
	RecalculateItemList(Object, ArrayOfFillingRows, ArrayOfFillingColumns);
EndProcedure	

// Get refilled item table.
// 
// Parameters:
//  Object - See Document.PhysicalInventory.Form.DocumentForm.Object
// 
// Returns:
//  Structure - Get refilled item table:
// * ItemList - ValueTable, ValueTree - 
// * ActualStock - ValueTable, ValueTree - 
// * PhysicalCount - ValueTable, ValueTree - 
Function GetRefilledItemTable(Object)
	
	Query = New Query;
	Query.TempTablesManager = New TempTablesManager();
	Query.Text =
		"SELECT
		|	ItemList.Key,
		|	ItemList.Item AS Item,
		|	ItemList.ItemKey,
		|	ItemList.UseSerialLotNumber,
		|	ItemList.SerialLotNumber,
		|	ItemList.Unit,
		|	ItemList.PhysCount AS PhysCount,
		|	ItemList.ExpCount AS ExpCount,
		|	ItemList.ManualFixedCount AS ManualFixedCount,
		|	ItemList.Difference,
		|	ItemList.Description
		|INTO ItemList
		|FROM
		|	&ItemList AS ItemList
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	"""" AS Key,
		|	ActualStocksBalance.ItemKey.Item AS Item,
		|	ActualStocksBalance.ItemKey,
		|	ActualStocksBalance.ItemKey.Item.ItemType.UseSerialLotNumber AS UseSerialLotNumber,
		|	ActualStocksBalance.SerialLotNumber,
		|	CASE
		|		WHEN ActualStocksBalance.ItemKey.Unit.Ref IS NULL
		|			THEN ActualStocksBalance.ItemKey.Item.Unit
		|		ELSE ActualStocksBalance.ItemKey.Unit
		|	END AS Unit,
		|	0 AS PhysCount,
		|	ActualStocksBalance.QuantityBalance AS ExpCount,
		|	0 AS ManualFixedCount,
		|	0 AS Difference,
		|	"""" AS Description
		|INTO ActualStock
		|FROM
		|	AccumulationRegister.R4010B_ActualStocks.Balance(&Period, Store = &Store) AS ActualStocksBalance
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	PhysicalCountByLocationItemList.Key,
		|	PhysicalCountByLocationItemList.ItemKey.Item AS Item,
		|	PhysicalCountByLocationItemList.ItemKey,
		|	PhysicalCountByLocationItemList.ItemKey.Item.ItemType.UseSerialLotNumber AS UseSerialLotNumber,
		|	PhysicalCountByLocationItemList.SerialLotNumber,
		|	PhysicalCountByLocationItemList.Unit,
		|	PhysicalCountByLocationItemList.PhysCount,
		|	PhysicalCountByLocationItemList.ExpCount,
		|	0 AS ManualFixedCount,
		|	PhysicalCountByLocationItemList.Difference,
		|	"""" AS Description
		|INTO PhysicalCount
		|FROM
		|	Document.PhysicalCountByLocation.ItemList AS PhysicalCountByLocationItemList
		|WHERE
		|	PhysicalCountByLocationItemList.Ref.Status.Posting
		|	AND NOT PhysicalCountByLocationItemList.Ref.DeletionMark
		|	AND PhysicalCountByLocationItemList.Ref.PhysicalInventory = &PhysicalInventory";
	Query.SetParameter("Store", Object.Store);
	Query.SetParameter("PhysicalInventory", Object.Ref);
	Query.SetParameter("Period", CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(Object.Ref, Object.Date));
	Query.SetParameter("ItemList", Object.ItemList.Unload());
	Query.Execute();
	
	Tables = New Structure;
	ItemList = Query.TempTablesManager.Tables.Find("ItemList").GetData().Unload(); // ValueTable
	Tables.Insert("ItemList", ItemList);
	
	ActualStock = Query.TempTablesManager.Tables.Find("ActualStock").GetData().Unload(); // ValueTable
	Tables.Insert("ActualStock", ActualStock);
	
	PhysicalCount = Query.TempTablesManager.Tables.Find("PhysicalCount").GetData().Unload(); // ValueTable
	Tables.Insert("PhysicalCount", PhysicalCount);
	
	Return Tables;
	
EndFunction

Procedure RecalculateItemList(Object, ArrayOfFillingRows, ArrayOfFillingColumns)
	
	If ArrayOfFillingRows.Count() = 0 Then
		Return;
	EndIf;		
	
	ServerParameters = ControllerClientServer_V2.GetServerParameters(Object);
	ServerParameters.TableName = "ItemList";
	ServerParameters.IsBasedOn = True;
	ServerParameters.ReadOnlyProperties = StrConcat(ArrayOfFillingColumns, ",");
	ServerParameters.Rows = ArrayOfFillingRows;
		
	Parameters = ControllerClientServer_V2.GetParameters(ServerParameters);
	For Each PropertyName In StrSplit(ServerParameters.ReadOnlyProperties, ",") Do
		Property = New Structure("DataPath", TrimAll(PropertyName));
		ControllerClientServer_V2.API_SetProperty(Parameters, Property, Undefined);
	EndDo;

EndProcedure

#EndRegion

#Region CreatePhysicalCount

Function GetArrayOfInstance(GenerateParameters) Export
	Result = New Array();
	
	Instance = New Structure("ItemList", New Array());
	For Index = 1 To GenerateParameters.CountDocsToCreate Do
		Result.Add(Instance);
	EndDo;

	Return Result;
EndFunction

Procedure CreatePhysicalCount(ObjectRef, GenerateParameters) Export
	GenerateParameters.Insert("PhysicalInventory", ObjectRef);
	GenerateParameters.Insert("Store", ObjectRef.Store);
	ArrayOfInstance = GetArrayOfInstance(GenerateParameters);
	GenerateParameters.Insert("ArrayOfInstance", ArrayOfInstance);
	Documents.PhysicalCountByLocation.GeneratePhysicalCountByLocation(GenerateParameters);
EndProcedure

#EndRegion
