#Region FormEvents

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControll();
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocPhysicalInventoryServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocPhysicalInventoryServer.OnReadAtServer(Object, ThisObject, CurrentObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocPhysicalInventoryClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocPhysicalInventoryServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

#EndRegion

&AtClient
Procedure InputTypeOnChange(Item)
	DocPhysicalInventoryClient.InputTypeOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	DocPhysicalInventoryClient.ItemListOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListOnStartEdit(Item, NewRow, Clone)
	If Clone Then
		Item.CurrentData.Key = New UUID();
	EndIf;
EndProcedure

&AtClient
Procedure ItemListItemOnChange(Item)
	DocPhysicalInventoryClient.ItemListItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListItemKeyOnChange(Item)
	CurrentRow = Items.ItemList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	CalculationSettings = New Structure();
	CalculationSettings.Insert("UpdateUnit");
	CalculationStringsClientServer.CalculateItemsRow(Object,
		CurrentRow,
		CalculationSettings);
EndProcedure

&AtClient
Procedure OpenPickupItems(Command)
	DocPhysicalInventoryClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocPhysicalInventoryClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocPhysicalInventoryClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure StoreOnChange(Item)
	DocPhysicalInventoryClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocPhysicalInventoryClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure


#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocPhysicalInventoryClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLalelClick(Item)
	DocPhysicalInventoryClient.DecorationGroupTitleCollapsedLalelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocPhysicalInventoryClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLalelClick(Item)
	DocPhysicalInventoryClient.DecorationGroupTitleUncollapsedLalelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

&AtClient
Procedure SearchByBarcode(Command)
	DocPhysicalInventoryClient.SearchByBarcode(Command, Object, ThisObject);
EndProcedure

&AtClient
Procedure ItemListPhysCountOnChange(Item)
	CurrentRow = Items.ItemList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	CurrentRow.Difference = CurrentRow.PhysCount - CurrentRow.ExpCount;
EndProcedure

&AtClient
Procedure FillExpCount(Command)
	DocPhysicalInventoryClient.FillExpCount(Object, ThisObject);
EndProcedure

&AtClient
Procedure ItemListBeforeDeleteRow(Item, Cancel)
	CurrentData = Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If CurrentData.Locked Then
		Cancel = True;
	EndIf;
EndProcedure

&AtClient
Procedure UpdateExpCount(Command)
	DocPhysicalInventoryClient.UpdateExpCount(Object, ThisObject);
	UpdatePhysicalCountsByLocations();
EndProcedure

&AtClient
Procedure UpdatePhysCount(Command)
	DocPhysicalInventoryClient.UpdatePhysCount(Object, ThisObject);
	UpdatePhysicalCountsByLocations();
EndProcedure

&AtServer
Procedure UpdatePhysicalCountsByLocations()
	DocPhysicalInventoryServer.UpdatePhysicalCountByLocations(Object, ThisObject);
EndProcedure

&AtClient
Procedure ItemListSelection(Item, RowSelected, Field, StandardProcessing)
	If Upper(Field.Name) = Upper("ItemListPhysicalCountByLocationPresentation") Then
		CurrentData = Items.ItemList.CurrentData;
		If CurrentData  = Undefined Then
			Return;
		EndIf;
		StandardProcessing = False;
		If ValueIsFilled(CurrentData.PhysicalCountByLocation) Then
			OpenForm("Document.PhysicalCountByLocation.ObjectForm", 
					New Structure("Key", CurrentData.PhysicalCountByLocation), 
					ThisObject);
		EndIf;
	EndIf;
EndProcedure


&AtClient
Procedure SetResponsiblePerson(Command)
	SelectedRows = Items.ItemList.SelectedRows;
	If Not SelectedRows.Count() Then
		Return;
	EndIf;
	
	Filter = New Structure("Employee", True);
	
	OpenFormParameters = New Structure("ChoiceMode, CloseOnChoice, Filter", True, True, Filter);
	
	OnChoiseNotify = New NotifyDescription("OnChoiceResponsiblePerson", ThisObject, 
	New Structure("SelectedRows", SelectedRows));
	
	OpenForm("Catalog.Partners.ChoiceForm", OpenFormParameters,ThisObject,,,,OnChoiseNotify);
EndProcedure

&AtClient
Procedure OnChoiceResponsiblePerson(Result, AdditionalsParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	For Each RowID In AdditionalsParameters.SelectedRows Do
		Row = Object.ItemList.FindByID(RowID);
		If Not ValueIsFilled(Row.ResponsiblePerson) Then
			Row.ResponsiblePerson = Result;
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure GeneratePhysicalCountByLocation(Command = Undefined) Export
	If Not ValueIsFilled(Object.Ref) Or ThisObject.Modified Then
		Notify = New NotifyDescription("GeneratePhysicalCountByLocationDoWrite", ThisObject);
		ShowQueryBox(Notify, R().QuestionToUser_001, QuestionDialogMode.YesNo);
	Else
		GeneratePhysicalCountByLocationAtServer();
	EndIf;
EndProcedure

&AtClient
Procedure GeneratePhysicalCountByLocationDoWrite(Result, AdditionalsParameters) Export
	If Result = DialogReturnCode.Yes And Write() Then
		GeneratePhysicalCountByLocationAtServer();
	EndIf;
EndProcedure

&AtServer
Procedure GeneratePhysicalCountByLocationAtServer() Export
	GenerateParameters = New Structure();
	GenerateParameters.Insert("PhysicalInventory", Object.Ref);
	GenerateParameters.Insert("Store", Object.Store);
	GenerateParameters.Insert("ArrayOfInstance", GetArrayOfInstance(Object.Ref));
	Documents.PhysicalCountByLocation.GeneratePhysicalCountByLocation(GenerateParameters);
	DocPhysicalInventoryServer.UpdatePhysicalCountByLocations(Object, ThisObject);
EndProcedure

&AtServer
Function GetArrayOfInstance(PhysicalInventoryRef)
	Query = New Query();
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
	Result = New Array();
	While QuerySelection.Next() Do
		Instance = New Structure("ResponsiblePerson, ItemList", QuerySelection.ResponsiblePerson, New Array());
		QuerySelectionDetails = QuerySelection.Select();
		While QuerySelectionDetails.Next() Do
			ItemListRow = New Structure();
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
	Return Result;
EndFunction

&AtClient
Procedure PhysicalCountByLocationListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure DecorationStatusHistoryClick(Item)
	ObjectStatusesClient.OpenHistoryByStatus(Object.Ref, ThisObject);
EndProcedure

&AtClient
Procedure PhysicalCountByLocationListOnChange(Item)
	UpdatePhysicalCountsByLocations();
EndProcedure

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControll()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

#EndRegion
