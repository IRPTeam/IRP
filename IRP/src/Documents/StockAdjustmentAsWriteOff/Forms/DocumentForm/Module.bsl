#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocStockAdjustmentAsWriteOffServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocStockAdjustmentAsWriteOffServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	SetVisibilityAvailability(CurrentObject, ThisObject);
	DocStockAdjustmentAsWriteOffServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocStockAdjustmentAsWriteOffClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;

	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
	
	If EventName = "LockLinkedRows" Then
		If Source <> ThisObject Then
			LockLinkedRows();
		EndIf;
	EndIf;
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	DocStockAdjustmentAsWriteOffClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	Form.Items.AddBasisDocuments.Enabled = Not Form.ReadOnly;
	Form.Items.LinkUnlinkBasisDocuments.Enabled = Not Form.ReadOnly;
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocStockAdjustmentAsWriteOffClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocStockAdjustmentAsWriteOffClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocStockAdjustmentAsWriteOffClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region STORE

&AtClient
Procedure StoreOnChange(Item)
	DocStockAdjustmentAsWriteOffClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ITEM_LIST

&AtClient
Procedure ItemListSelection(Item, RowSelected, Field, StandardProcessing)
	DocStockAdjustmentAsWriteOffClient.ItemListSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocStockAdjustmentAsWriteOffClient.ItemListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure ItemListBeforeDeleteRow(Item, Cancel)
	DocStockAdjustmentAsWriteOffClient.ItemListBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocStockAdjustmentAsWriteOffClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
	LockLinkedRows();
EndProcedure

#Region ITEM_LIST_COLUMNS

#Region _ITEM

&AtClient
Procedure ItemListItemOnChange(Item)
	DocStockAdjustmentAsWriteOffClient.ItemListItemOnChange(Object, ThisObject);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocStockAdjustmentAsWriteOffClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocStockAdjustmentAsWriteOffClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ITEM_KEY

&AtClient
Procedure ItemListItemKeyOnChange(Item)
	DocStockAdjustmentAsWriteOffClient.ItemListItemKeyOnChange(Object, ThisObject);
EndProcedure

#EndRegion

#Region QUANTITY

&AtClient
Procedure ItemListQuantityOnChange(Item)
	DocStockAdjustmentAsWriteOffClient.ItemListQuantityOnChange(Object, ThisObject);
EndProcedure

#EndRegion

#Region UNIT

&AtClient
Procedure ItemListUnitOnChange(Item)
	DocStockAdjustmentAsWriteOffClient.ItemListUnitOnChange(Object, ThisObject);
EndProcedure

#EndRegion

#Region SERIAL_LOT_NUMBERS

&AtClient
Procedure ItemListSerialLotNumbersPresentationStartChoice(Item, ChoiceData, StandardProcessing) Export
	SerialLotNumberClient.PresentationStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListSerialLotNumbersPresentationClearing(Item, StandardProcessing)
	SerialLotNumberClient.PresentationClearing(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region EXPENSE_TYPE

&AtClient
Procedure ItemListExpenseTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocStockAdjustmentAsWriteOffClient.ItemListExpenseTypeStartChoice(Object, ThisObject, Item, ChoiceData,
		StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListExpenseTypeEditTextChange(Item, Text, StandardProcessing)
	DocStockAdjustmentAsWriteOffClient.ItemListExpenseTypeEditTextChange(Object, ThisObject, Item, Text,
		StandardProcessing);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region SERVICE

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocStockAdjustmentAsWriteOffClient);
	Str.Insert("Server", DocStockAdjustmentAsWriteOffServer);
	Return Str;
EndFunction

#Region DESCRIPTION

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	CommonFormActions.EditMultilineText(ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region TITLE_DECORATIONS

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

#EndRegion

#Region ADD_ATTRIBUTES

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

#EndRegion

#Region EXTERNAL_COMMANDS

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

#Region COMMANDS

&AtClient
Procedure OpenPickupItems(Command)
	DocumentsClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	DocumentsClient.SearchByBarcode(Barcode, Object, ThisObject);
EndProcedure

&AtClient
Procedure OpenScanForm(Command)
	DocumentsClient.OpenScanForm(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

#EndRegion

#Region LINKED_DOCUMENTS

&AtClient
Procedure LinkUnlinkBasisDocuments(Command)
	FormParameters = New Structure();
	FormParameters.Insert("Filter", RowIDInfoClientServer.GetLinkedDocumentsFilter_StockAdjustmentAsWriteOff(Object));
	FormParameters.Insert("SelectedRowInfo", RowIDInfoClient.GetSelectedRowInfo(Items.ItemList.CurrentData));
	FormParameters.Insert("TablesInfo", RowIDInfoClient.GetTablesInfo(Object));
	OpenForm("CommonForm.LinkUnlinkDocumentRows", FormParameters, , , , ,
		New NotifyDescription("AddOrLinkUnlinkDocumentRowsContinue", ThisObject), FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure AddBasisDocuments(Command)
	FormParameters = New Structure();
	FormParameters.Insert("Filter", RowIDInfoClientServer.GetLinkedDocumentsFilter_StockAdjustmentAsWriteOff(Object));
	FormParameters.Insert("TablesInfo", RowIDInfoClient.GetTablesInfo(Object));
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", ThisObject);
	OpenForm("CommonForm.AddLinkedDocumentRows", FormParameters, , , , ,
		New NotifyDescription("AddOrLinkUnlinkDocumentRowsContinue", ThisObject, NotifyParameters), 
			FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure AddOrLinkUnlinkDocumentRowsContinue(Result, NotifyParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	ThisObject.Modified = True;
	AddOrLinkUnlinkDocumentRowsContinueAtServer(Result);
EndProcedure

&AtServer
Function AddOrLinkUnlinkDocumentRowsContinueAtServer(Result)
	ExtractedData = Undefined;
	If Result.Operation = "LinkUnlinkDocumentRows" Then
		RowIDInfoServer.LinkUnlinkDocumentRows(Object, Result.FillingValues);
	ElsIf Result.Operation = "AddLinkedDocumentRows" Then
		LinkedResult = RowIDInfoServer.AddLinkedDocumentRows(Object, Result.FillingValues);
		ExtractedData = ControllerClientServer_V2.AddLinkedDocumentRows(Object, ThisObject, LinkedResult, "ItemList");
	EndIf;
	LockLinkedRows();
	Return ExtractedData;
EndFunction

&AtServer
Procedure LockLinkedRows()
	RowIDInfoServer.LockLinkedRows(Object, ThisObject);
	RowIDInfoServer.SetAppearance(Object, ThisObject);
EndProcedure

&AtServer
Procedure UnlockLockLinkedRows()
	RowIDInfoServer.UnlockLinkedRows(Object, ThisObject);
EndProcedure

&AtClient
Procedure FromUnlockLinkedRows(Command)
	Items.FormUnlockLinkedRows.Check = Not Items.FormUnlockLinkedRows.Check;
	If Items.FormUnlockLinkedRows.Check Then
		UnlockLockLinkedRows();
	Else
		LockLinkedRows();
	EndIf;
EndProcedure

#EndRegion

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

#EndRegion
