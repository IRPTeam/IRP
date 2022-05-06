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

Function GetItemListWithFillingExpCount(Ref, Store, ItemList = Undefined) Export
	Result = Documents.PhysicalInventory.GetItemListWithFillingExpCount(Ref, Store, ItemList);
	ArrayOfResult = New Array();
	For Each Row In Result Do
		NewRow = New Structure("Key, Store, Item, ItemKey, SerialLotNumber, Unit, ExpCount, PhysCount");
		FillPropertyValues(NewRow, Row);
		ArrayOfResult.Add(NewRow);
	EndDo;
	Return ArrayOfResult;
EndFunction

// Get item list with filling phys count.
// 
// Parameters:
//  Ref - DocumentRef.PhysicalInventory - Ref
// 
// Returns:
//  Array of See GetItemRowWithFillingPhysCount - Get item list with filling phys count
Function GetItemListWithFillingPhysCount(Ref) Export
	Result = Documents.PhysicalInventory.GetItemListWithFillingPhysCount(Ref);
	ArrayOfResult = New Array();
	For Each Row In Result Do
		NewRow = GetItemRowWithFillingPhysCount();
		FillPropertyValues(NewRow, Row);
		ArrayOfResult.Add(NewRow);
	EndDo;
	Return ArrayOfResult;
EndFunction

// Get item row with filling phys count.
// 
// Returns:
//  Structure - Get item row with filling phys count:
// * Key - String
// * Item - CatalogRef.Items -
// * ItemKey - CatalogRef.ItemKeys -
// * SerialLotNumber - CatalogRef.SerialLotNumbers -
// * Unit - CatalogRef.Units -
// * PhysCount - Number -
// * ExpCount - Number -
Function GetItemRowWithFillingPhysCount() Export
	
	Structure = New Structure;
	Structure.Insert("Key", "");
	Structure.Insert("Item", Catalogs.Items.EmptyRef());
	Structure.Insert("ItemKey", Catalogs.ItemKeys.EmptyRef());
	Structure.Insert("SerialLotNumber", Catalogs.SerialLotNumbers.EmptyRef());
	Structure.Insert("Unit", Catalogs.Units.EmptyRef());
	Structure.Insert("PhysCount", 0);
	Structure.Insert("ExpCount", 0);
	
	Return Structure;
	
EndFunction

Function HavePhysicalCountByLocation(PhysicalInventoryRef) Export
	If Not ValueIsFilled(PhysicalInventoryRef) Then
		Return False;
	EndIf;
	Query = New Query();
	Query.Text =
	"SELECT TOP 1
	|	PhysicalCountByLocation.Ref
	|FROM
	|	Document.PhysicalCountByLocation AS PhysicalCountByLocation
	|WHERE
	|	PhysicalCountByLocation.PhysicalInventory = &PhysicalInventoryRef
	|	AND
	|	NOT PhysicalCountByLocation.DeletionMark";
	Query.SetParameter("PhysicalInventoryRef", PhysicalInventoryRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Return QuerySelection.Next();
EndFunction
