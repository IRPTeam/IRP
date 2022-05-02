#Region FORM

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		DocumentsServer.FillItemList(Object, Form);
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
		UpdatePhysicalCountByLocations(Object, Form);
	EndIf;
	RowIDInfoServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	ViewServer_V2.OnCreateAtServer(Object, Form, "ItemList");
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsServer.FillItemList(Object, Form);
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	RowIDInfoServer.AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters);
	UpdatePhysicalCountByLocations(Object, Form);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	DocumentsServer.FillItemList(Object, Form);
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	RowIDInfoServer.OnReadAtServer(Object, Form, CurrentObject);
	UpdatePhysicalCountByLocations(Object, Form);
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

Procedure UpdatePhysicalCountByLocations(Object, Form) Export
	Form.PhysicalCountByLocationList.Parameters.SetParameterValue("PhysicalInventoryRef", Object.Ref);
	LinkedPhysicalCountByLocation = Documents.PhysicalCountByLocation.GetLinkedPhysicalCountByLocation(Object.Ref);

	For Each Row In Object.ItemList Do
		Row.PhysicalCountByLocation = Undefined;
		Row.PhysicalCountByLocationPresentation = Undefined;
		Row.Locked = False;
	EndDo;

	For Each Row In LinkedPhysicalCountByLocation Do
		For Each LinkedRow In Object.ItemList.FindRows(New Structure("Key", Row.Key)) Do
			LinkedRow.PhysicalCountByLocation = Row.Ref;
			LinkedRow.PhysicalCountByLocationPresentation = StrTemplate(R().InfoMessage_007, Row.Number, Row.Date);
			LinkedRow.Locked = True;
		EndDo;
	EndDo;

	Form.Items.GroupPhysicalCountByLocation.Visible = LinkedPhysicalCountByLocation.Count() > 0;
	Form.Items.ItemListPhysicalCountByLocationPresentation.Visible = LinkedPhysicalCountByLocation.Count() > 0;
EndProcedure

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
		NewRow = New Structure("Key, Store, Item, ItemKey, Unit, ExpCount, PhysCount");
		FillPropertyValues(NewRow, Row);
		ArrayOfResult.Add(NewRow);
	EndDo;
	Return ArrayOfResult;
EndFunction

Function GetItemListWithFillingPhysCount(Ref) Export
	Result = Documents.PhysicalInventory.GetItemListWithFillingPhysCount(Ref);
	ArrayOfResult = New Array();
	For Each Row In Result Do
		NewRow = New Structure("Item, ItemKey, Unit, PhysCount, ExpCount");
		FillPropertyValues(NewRow, Row);
		ArrayOfResult.Add(NewRow);
	EndDo;
	Return ArrayOfResult;
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
