#Region FormEvents

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
	If EventName = "CreatedPhysicalCountByLocations" AND Source = Object.Ref Then
		UpdatePhysicalCountByLocationsAtServer();
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
	UpdateResponsibleView();
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

#Region ItemsFormEvents

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	DocPhysicalInventoryClient.ItemListOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocPhysicalInventoryClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
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

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	DocPhysicalInventoryClient.SearchByBarcode(Barcode, Object, ThisObject);
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
	
	OnChoiceNotify = New NotifyDescription("OnChoiceResponsiblePerson", ThisObject, 
	New Structure("SelectedRows", SelectedRows));
	
	OpenForm("Catalog.Partners.ChoiceForm", OpenFormParameters, ThisObject, , , , OnChoiceNotify);
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

&AtServer
Procedure UpdatePhysicalCountByLocationsAtServer()
	DocPhysicalInventoryServer.UpdatePhysicalCountByLocations(Object, ThisObject);
EndProcedure

&AtClient
Procedure UseResponsiblePersonByRowOnChange(Item)

	UpdateResponsibleView();

EndProcedure

#EndRegion

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocPhysicalInventoryClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocPhysicalInventoryClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocPhysicalInventoryClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocPhysicalInventoryClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region Privat

&AtClient
Procedure UpdateResponsibleView()
	Items.SetResponsiblePerson.Visible = Object.UseResponsiblePersonByRow;
	Items.ItemListResponsiblePerson.Visible = Object.UseResponsiblePersonByRow;
EndProcedure

&AtServer
Procedure UpdatePhysicalCountsByLocations()
	DocPhysicalInventoryServer.UpdatePhysicalCountByLocations(Object, ThisObject);
EndProcedure

#EndRegion

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

#EndRegion

#Region ExternalCommands

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);	
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

#EndRegion

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

