#Region FormEvents

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	SetVisibilityAvailability(CurrentObject, ThisObject);
	DocStockAdjustmentAsSurplusServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;

	DocStockAdjustmentAsSurplusServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocStockAdjustmentAsSurplusClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	DocStockAdjustmentAsSurplusClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
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
Procedure OnReadAtServer(CurrentObject)
	DocStockAdjustmentAsSurplusServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(CurrentObject, ThisObject);
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

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

#EndRegion

&AtClient
Procedure ItemListBeforeDeleteRow(Item, Cancel)
	DocStockAdjustmentAsSurplusClient.ItemListBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	Return;
	//DocStockAdjustmentAsSurplusClient.ItemListOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListSelection(Item, RowSelected, Field, StandardProcessing)
	DocStockAdjustmentAsSurplusClient.ItemListSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListOnStartEdit(Item, NewRow, Clone)
	Return;
	//DocStockAdjustmentAsSurplusClient.ItemListOnStartEdit(Object, ThisObject, Item, NewRow, Clone);
EndProcedure

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocStockAdjustmentAsSurplusClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
	LockLinkedRows();
EndProcedure

&AtClient
Procedure ItemListItemOnChange(Item)
	DocStockAdjustmentAsSurplusClient.ItemListItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocStockAdjustmentAsSurplusClient.ItemListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder,
		Parameter);
EndProcedure

&AtClient
Procedure ItemListItemKeyOnChange(Item)
	DocStockAdjustmentAsSurplusClient.ItemListItemKeyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListQuantityOnChange(Item)
	DocStockAdjustmentAsSurplusClient.ItemListQuantityOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListUnitOnChange(Item)
	DocStockAdjustmentAsSurplusClient.ItemListUnitOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListSerialLotNumbersPresentationStartChoice(Item, ChoiceData, StandardProcessing, AddInfo = Undefined) Export
	DocStockAdjustmentAsSurplusClient.ItemListSerialLotNumbersPresentationStartChoice(Object, ThisObject, Item,
		ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListSerialLotNumbersPresentationClearing(Item, StandardProcessing)
	DocStockAdjustmentAsSurplusClient.ItemListSerialLotNumbersPresentationClearing(Object, ThisObject, Item,
		StandardProcessing);
EndProcedure

&AtClient
Procedure OpenPickupItems(Command)
	DocStockAdjustmentAsSurplusClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocStockAdjustmentAsSurplusClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocStockAdjustmentAsSurplusClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListRevenueTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocStockAdjustmentAsSurplusClient.ItemListRevenueTypeStartChoice(Object, ThisObject, Item, ChoiceData,
		StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListRevenueTypeEditTextChange(Item, Text, StandardProcessing)
	DocStockAdjustmentAsSurplusClient.ItemListRevenueTypeEditTextChange(Object, ThisObject, Item, Text,
		StandardProcessing);
EndProcedure

#Region ItemCompany

&AtClient
Procedure CompanyOnChange(Item)
	DocStockAdjustmentAsSurplusClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocStockAdjustmentAsSurplusClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocStockAdjustmentAsSurplusClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

&AtClient
Procedure StoreOnChange(Item)
	DocStockAdjustmentAsSurplusClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocStockAdjustmentAsSurplusClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocStockAdjustmentAsSurplusClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocStockAdjustmentAsSurplusClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocStockAdjustmentAsSurplusClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocStockAdjustmentAsSurplusClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	DocStockAdjustmentAsSurplusClient.SearchByBarcode(Barcode, Object, ThisObject);
EndProcedure

&AtClient
Procedure OpenScanForm(Command)
	DocumentsClient.OpenScanForm(Object, ThisObject, Command);
EndProcedure

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

#Region LinkedDocuments

&AtClient
Procedure LinkUnlinkBasisDocuments(Command)
	FormParameters = New Structure();
	FormParameters.Insert("Filter", RowIDInfoClientServer.GetLinkedDocumentsFilter_StockAdjustmentAsSurplus(Object));
	FormParameters.Insert("SelectedRowInfo", RowIDInfoClient.GetSelectedRowInfo(Items.ItemList.CurrentData));
	FormParameters.Insert("TablesInfo", RowIDInfoClient.GetTablesInfo(Object));
	OpenForm("CommonForm.LinkUnlinkDocumentRows", FormParameters, , , , ,
		New NotifyDescription("AddOrLinkUnlinkDocumentRowsContinue", ThisObject), FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure AddBasisDocuments(Command)
	FormParameters = New Structure();
	FormParameters.Insert("Filter", RowIDInfoClientServer.GetLinkedDocumentsFilter_StockAdjustmentAsSurplus(Object));
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

#Region Service

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocStockAdjustmentAsSurplusClient);
	Str.Insert("Server", DocStockAdjustmentAsSurplusServer);
	Return Str;
EndFunction

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

#EndRegion
