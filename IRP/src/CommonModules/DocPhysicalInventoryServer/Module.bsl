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
		DocumentsServer.FillItemList(Object, Form);
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
		Form.PhysicalCountByLocationList.Parameters.SetParameterValue("PhysicalInventoryRef", Object.Ref);
	EndIf;
	
	RowIDInfoServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	ViewServer_V2.OnCreateAtServer(Object, Form, "ItemList");
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsServer.FillItemList(Object, Form);
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	RowIDInfoServer.AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters);
	Form.PhysicalCountByLocationList.Parameters.SetParameterValue("PhysicalInventoryRef", Object.Ref);
	SerialLotNumbersServer.FillSerialLotNumbersUse(Object);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	DocumentsServer.FillItemList(Object, Form);
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	RowIDInfoServer.OnReadAtServer(Object, Form, CurrentObject);
	Form.PhysicalCountByLocationList.Parameters.SetParameterValue("PhysicalInventoryRef", Object.Ref);
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
	ItemCounts = GetRefilledItemTable(Object);

	If Not ItemCounts.Count() Then
		Return;
	EndIf;
	
	Object.RowIDInfo.Clear();
	Object.ItemList.Clear();

	ArrayOfFillingRows = New Array();
	For Each Row In ItemCounts Do
		NewRow = Object.ItemList.Add();
		FillPropertyValues(NewRow, Row);
		ArrayOfFillingRows.Add(NewRow);
	EndDo;
	
	ArrayOfFillingColumns = New Array();
	ArrayOfFillingColumns.Add("ItemList.ItemKey");
	If UpdateExpCount Then
		ArrayOfFillingColumns.Add("ItemList.ExpCount");
	Else
		ArrayOfFillingColumns.Add("ItemList.PhysCount");
	EndIf;
	ArrayOfFillingColumns.Add("ItemList.Difference");
	RecalculateItemList(Object, ArrayOfFillingRows, ArrayOfFillingColumns);
EndProcedure	

Function GetRefilledItemTable(Object)
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	ItemList.Key,
		|	ItemList.Item AS Item,
		|	ItemList.ItemKey,
		|	ItemList.UseSerialLotNumber,
		|	ItemList.SerialLotNumber,
		|	ItemList.Unit,
		|	ItemList.ExpCount,
		|	ItemList.PhysCount,
		|	ItemList.ManualFixedCount,
		|	ItemList.Difference,
		|	ItemList.Description
		|INTO ItemList
		|FROM
		|	&ItemList AS ItemList
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ItemList.Key,
		|	ItemList.Item,
		|	ItemList.ItemKey,
		|	ItemList.UseSerialLotNumber,
		|	ItemList.SerialLotNumber,
		|	ItemList.Unit,
		|	ItemList.ExpCount,
		|	ItemList.PhysCount,
		|	ItemList.ManualFixedCount,
		|	ItemList.Difference,
		|	ItemList.Description,
		|	R4010B_ActualStocksBalance.QuantityBalance
		|FROM
		|	ItemList AS ItemList
		|		LEFT JOIN AccumulationRegister.R4010B_ActualStocks.Balance(, Store = &Store) AS R4010B_ActualStocksBalance
		|		ON ItemList.ItemKey = R4010B_ActualStocksBalance.ItemKey
		|		AND ItemList.SerialLotNumber = R4010B_ActualStocksBalance.SerialLotNumber";
	Query.SetParameter("Store", Object.Store);
	Query.SetParameter("ItemList", Object.ItemList.Unload());
	QueryResult = Query.Execute();
	
	Table = QueryResult.Unload();
	
	Return Table;
	
EndFunction

Procedure RecalculateItemList(Object, ArrayOfFillingRows, ArrayOfFillingColumns)
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
	For Each RowItemList In Object.ItemList Do
			RowItemList.UseSerialLotNumber = 
				Parameters.ExtractedData.ItemKeysWithSerialLotNumbers.Find(RowItemList.ItemKey) <> Undefined;
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
	ArrayOfInstance = DocPhysicalInventoryServer.GetArrayOfInstance(GenerateParameters);
	GenerateParameters.Insert("ArrayOfInstance", ArrayOfInstance);
	Documents.PhysicalCountByLocation.GeneratePhysicalCountByLocation(GenerateParameters);
EndProcedure

#EndRegion
