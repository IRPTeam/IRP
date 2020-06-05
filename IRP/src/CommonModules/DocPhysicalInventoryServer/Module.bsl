#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		DocumentsServer.FillItemList(Object, Form);
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
		UpdatePhysicalCountByLocations(Object, Form);
	EndIf;
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsServer.FillItemList(Object, Form);
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	UpdatePhysicalCountByLocations(Object, Form);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	DocumentsServer.FillItemList(Object, Form);
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	UpdatePhysicalCountByLocations(Object, Form);
EndProcedure

#EndRegion

Procedure UpdatePhysicalCountByLocations(Object, Form) Export
	Form.PhysicalCountByLocationList.Parameters.SetParameterValue("PhysicalInventoryRef" ,Object.Ref);
	LinkedPhisiaclCountByLocation = Documents.PhysicalCountByLocation.GetLinkedPhysicalCountByLocation(Object.Ref);
	
	For Each Row In Object.ItemList Do
		Row.PhysicalCountByLocation = Undefined;
		Row.PhysicalCountByLocationPresentation = Undefined;
		Row.Locked = False;
	EndDo;
	
	For Each Row in LinkedPhisiaclCountByLocation Do
		For Each LinkedRow In Object.ItemList.FindRows(New Structure("Key", Row.Key)) Do
			LinkedRow.PhysicalCountByLocation = Row.Ref;
			LinkedRow.PhysicalCountByLocationPresentation = StrTemplate(R().InfoMessage_007, Row.Number, Row.Date);
			LinkedRow.Locked = True;
		EndDo;
	EndDo;
	
	Form.Items.GroupPhysicalCountByLocation.Visible = LinkedPhisiaclCountByLocation.Count() > 0;
	Form.Items.ItemListPhysicalCountByLocationPresentation.Visible = LinkedPhisiaclCountByLocation.Count() > 0;
EndProcedure

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array;
	AttributesArray.Add("Store");
	AttributesArray.Add("Status");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Atr In AttributesArray Do
		Form.GroupItems.Add(Atr, ?(ValueIsFilled(Form.Items[Atr].Title),
				Form.Items[Atr].Title,
				Object.Ref.Metadata().Attributes[Atr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion

Function GetItemListWithFillingExpCount(Ref, Store, ItemList = Undefined) Export
	Result = Documents.PhysicalInventory.GetItemListWithFillingExpCount(Ref, Store, ItemList);
	ArrayOfResult = New Array();
	For Each Row In Result Do
		NewRow = New Structure("Key, Store, Item, ItemKey, Unit, ExpCount, PhysCount, ResponsiblePerson");
		FillPropertyValues(NewRow, Row);
		ArrayOfResult.Add(NewRow);
	EndDo;
	Return ArrayOfResult;
EndFunction

Function GetItemListWithFillingPhysCount(Ref, ItemList) Export
	Result = Documents.PhysicalInventory.GetItemListWithFillingPhysCount(Ref, ItemList);
	ArrayOfResult = New Array();
	For Each Row In Result Do
		NewRow = New Structure("Key, ItemKey, PhysCount");
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

#Region ListFormEvents

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region ChoiceFormEvents

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion