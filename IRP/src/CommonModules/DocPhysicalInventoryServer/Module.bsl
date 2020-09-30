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

#Region Public 
&AtServer
Function GetArrayOfInstance(PhysicalInventoryRef) Export
	Result = New Array();
	If PhysicalInventoryRef.UseResponsiblePersonByRow Then
		Query = New Query;
		Query.Text =
		"SELECT
		|	PhysicalInventoryItemList.Key AS Key,
		|	PhysicalInventoryItemList.ItemKey AS ItemKey,
		|	PhysicalInventoryItemList.Unit AS Unit,
		|	PhysicalInventoryItemList.ExpCount AS ExpCount,
		|	PhysicalInventoryItemList.PhysCount AS PhysCount,
		|	PhysicalInventoryItemList.Difference AS Difference,
		|	PhysicalInventoryItemList.ResponsiblePerson AS ResponsiblePerson
		|FROM
		|	Document.PhysicalInventory.ItemList AS PhysicalInventoryItemList
		|		LEFT JOIN Document.PhysicalCountByLocation.ItemList AS PhysicalCountByLocationItemList
		|		ON PhysicalCountByLocationItemList.Ref.PhysicalInventory = PhysicalInventoryItemList.Ref
		|		AND PhysicalCountByLocationItemList.Key = PhysicalInventoryItemList.Key
		|		AND PhysicalCountByLocationItemList.ItemKey = PhysicalInventoryItemList.ItemKey
		|		AND
		|		NOT PhysicalCountByLocationItemList.Ref.DeletionMark
		|WHERE
		|	PhysicalInventoryItemList.Ref = &PhysicalInventoryRef
		|	AND PhysicalInventoryItemList.ResponsiblePerson <> VALUE(Catalog.Partners.EmptyRef)
		|	AND PhysicalCountByLocationItemList.Key IS NULL
		|TOTALS
		|BY
		|	ResponsiblePerson";
		Query.SetParameter("PhysicalInventoryRef", PhysicalInventoryRef);
		QueryResult = Query.Execute();
		QuerySelection  = QueryResult.Select(QueryResultIteration.ByGroups);

		While QuerySelection.Next() Do
			Instance = New Structure("ResponsiblePerson, ItemList", QuerySelection.ResponsiblePerson, New Array);
			QuerySelectionDetails = QuerySelection.Select();
			While QuerySelectionDetails.Next() Do
				ItemListRow = New Structure;
				ItemListRow.Insert("Key", QuerySelectionDetails.Key);
				ItemListRow.Insert("ItemKey", QuerySelectionDetails.ItemKey);
				ItemListRow.Insert("Unit", QuerySelectionDetails.Unit);
				ItemListRow.Insert("ExpCount", QuerySelectionDetails.ExpCount);
				ItemListRow.Insert("PhysCount", QuerySelectionDetails.PhysCount);
				ItemListRow.Insert("Difference", QuerySelectionDetails.Difference);
				Instance.ItemList.Add(ItemListRow);
			EndDo;
			Result.Add(Instance);
		EndDo;
	Else
		Instance = New Structure("ResponsiblePerson, ItemList", Undefined, New Array);
		Result.Add(Instance);
	EndIf;
	
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
#EndRegion

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