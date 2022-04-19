Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export
	DocumentsClient.SetTextOfDescriptionAtForm(Object, Form);
EndProcedure

Procedure AfterWriteAtClient(Object, Form, WriteParameters, AddInfo = Undefined) Export
	RowIDInfoClient.AfterWriteAtClient(Object, Form, WriteParameters, AddInfo);
EndProcedure

Procedure ItemListBeforeDeleteRow(Object, Form, Item, Cancel, AddInfo = Undefined) Export
	RowIDInfoClient.ItemListBeforeDeleteRow(Object, Form, Item, Cancel, AddInfo);	
EndProcedure

Procedure ItemListOnChange(Object, Form, Item = Undefined, CurrentRowData = Undefined) Export
	DocumentsClient.FillRowIDInItemList(Object);
	RowIDInfoClient.UpdateQuantity(Object, Form);
EndProcedure

Procedure ItemListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing, AddInfo = Undefined) Export
	If Upper(Field.Name) = Upper("ItemListPhysicalCountByLocationPresentation") Then
		CurrentData = Form.Items.ItemList.CurrentData;
		If CurrentData = Undefined Then
			Return;
		EndIf;
		StandardProcessing = False;
		If ValueIsFilled(CurrentData.PhysicalCountByLocation) Then
			OpenForm("Document.PhysicalCountByLocation.ObjectForm", New Structure("Key",
				CurrentData.PhysicalCountByLocation), Form);
		EndIf;
	EndIf;
	
	RowIDInfoClient.ItemListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing, AddInfo);
EndProcedure

Procedure ItemListOnStartEdit(Object, Form, Item, NewRow, Clone, AddInfo = Undefined) Export
	CurrentData = Item.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If Clone Then
		CurrentData.Key = New UUID();
	EndIf;
	RowIDInfoClient.ItemListOnStartEdit(Object, Form, Item, NewRow, Clone, AddInfo);
EndProcedure

Procedure ItemListAfterDeleteRow(Object, Form, Item) Export
	DocumentsClient.ItemListAfterDeleteRow(Object, Form, Item);
EndProcedure

Procedure ItemListItemOnChange(Object, Form, Item = Undefined) Export
	CurrentRow = Form.Items.ItemList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	CurrentRow.ItemKey = CatItemsServer.GetItemKeyByItem(CurrentRow.Item);
	If ValueIsFilled(CurrentRow.ItemKey) And ServiceSystemServer.GetObjectAttribute(CurrentRow.ItemKey, "Item")
		<> CurrentRow.Item Then
		CurrentRow.ItemKey = Undefined;
	EndIf;

	CalculationSettings = New Structure();
	CalculationSettings.Insert("UpdateUnit");
	CalculationStringsClientServer.CalculateItemsRow(Object, CurrentRow, CalculationSettings);
EndProcedure

Procedure ItemListItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsForSelectItemWithoutServiceFilter();
	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ItemListItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = DocumentsClient.GetArrayOfFiltersForSelectItemWithoutServiceFilter();
	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

Procedure StoreOnChange(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

#Region CreatePhysicalCount
Procedure CreatePhysicalCount(ObjectRef) Export
	CountDocsToCreate = 0;
	AddInfo =  New Structure("ObjectRef", ObjectRef);
	UseResponsiblePersonByRow = CommonFunctionsServer.GetRefAttribute(ObjectRef, "UseResponsiblePersonByRow");
	AddInfo.Insert("UseResponsiblePersonByRow", UseResponsiblePersonByRow);
	AddInfo.Insert("CountDocsToCreate", CountDocsToCreate);

	If UseResponsiblePersonByRow Then
		DocPhysicalInventoryServer.CreatePhysicalCount(AddInfo.ObjectRef, AddInfo);
		Notify("CreatedPhysicalCountByLocations", , ObjectRef);
	Else
		NotifyDescription = New NotifyDescription("CreatePhysicalCountEnd", ThisObject, AddInfo);
		ShowInputNumber(NotifyDescription, CountDocsToCreate, R().QuestionToUser_017, 2, 0);
	EndIf;
EndProcedure

Procedure CreatePhysicalCountEnd(CountDocsToCreate, AdditionalParameters) Export

	If ValueIsFilled(CountDocsToCreate) Then
		AdditionalParameters.Insert("CountDocsToCreate", CountDocsToCreate);
		DocPhysicalInventoryServer.CreatePhysicalCount(AdditionalParameters.ObjectRef, AdditionalParameters);
		Notify("CreatedPhysicalCountByLocations", , AdditionalParameters.ObjectRef);
	EndIf;

EndProcedure
#EndRegion

Procedure FillExpCount(Object, Form) Export

	If DocPhysicalInventoryServer.HavePhysicalCountByLocation(Object.Ref) Then
		ShowMessageBox(Undefined, R().InfoMessage_006);
		Return;
	EndIf;

	FillItemList(Object, Form, DocPhysicalInventoryServer.GetItemListWithFillingExpCount(Object.Ref, Object.Store));
EndProcedure

Procedure UpdateExpCount(Object, Form) Export
	ItemList = New Array();
	For Each Row In Object.ItemList Do
		NewRow = New Structure("Key, LineNumber, Store, ItemKey, Unit, PhysCount, ResponsiblePerson");
		FillPropertyValues(NewRow, Row);
		NewRow.Store = Object.Store;
		ItemList.Add(NewRow);
	EndDo;
	FillItemList(Object, Form, DocPhysicalInventoryServer.GetItemListWithFillingExpCount(Object.Ref, Object.Store,
		ItemList));
EndProcedure

Procedure UpdatePhysCount(Object, Form) Export
	UpdateItemList(Object, Form, DocPhysicalInventoryServer.GetItemListWithFillingPhysCount(Object.Ref));
EndProcedure

Procedure FillItemList(Object, Form, Result)
	Object.ItemList.Clear();
	For Each Row In Result Do
		NewRow = Object.ItemList.Add();
		FillPropertyValues(NewRow, Row);
		NewRow.Difference = NewRow.PhysCount - NewRow.ExpCount;
	EndDo;
EndProcedure

Procedure UpdateItemList(Object, Form, Result)
	For Each ItemListRow In Object.ItemList Do
		ItemListRow.PhysCount = 0;
		ItemListRow.Difference = ItemListRow.PhysCount - ItemListRow.ExpCount;
	EndDo;

	For Each Row In Result Do
		ItemListFoundRows = Object.ItemList.FindRows(New Structure("Unit, ItemKey", Row.Unit, Row.ItemKey));
		If ItemListFoundRows.Count() Then
			ItemListRow = ItemListFoundRows[0];
		Else
			ItemListRow = Object.ItemList.Add();
		EndIf;
		FillPropertyValues(ItemListRow, Row);
		ItemListRow.Difference = ItemListRow.PhysCount - ItemListRow.ExpCount;
	EndDo;
EndProcedure