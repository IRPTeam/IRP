
#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocPhysicalCountByLocationServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocPhysicalCountByLocationServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	SetVisibilityAvailability(CurrentObject, ThisObject);
	DocPhysicalCountByLocationServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	DocPhysicalCountByLocationClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocPhysicalCountByLocationClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
	
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
	
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	Form.Items.ItemListSerialLotNumber.Visible = Object.UseSerialLot;
EndProcedure

&AtClient
Procedure _IdeHandler()
	ViewClient_V2.ViewIdleHandler(ThisObject, Object);
EndProcedure

&AtClient
Procedure _AttachIdleHandler() Export
	AttachIdleHandler("_IdeHandler", 1);
EndProcedure

&AtClient 
Procedure _DetachIdleHandler() Export
	DetachIdleHandler("_IdeHandler");
EndProcedure

#EndRegion

#Region STORE

&AtClient
Procedure StoreOnChange(Item)
	DocPhysicalCountByLocationClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TRANSACTION_TYPE

&AtClient
Procedure TransactionTypeOnChange(Item)
	DocPhysicalCountByLocationClient.TransactionTypeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region USE_SERIAL_LOT_NUMBERS

&AtClient
Procedure UseSerialLotOnChange(Item)
	If Object.ItemList.Count() Then
		Object.UseSerialLot = Not Object.UseSerialLot;
	EndIf;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

#EndRegion

#Region ITEM_LIST

&AtClient
Procedure ItemListSelection(Item, RowSelected, Field, StandardProcessing)
	DocPhysicalCountByLocationClient.ItemListSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocPhysicalCountByLocationClient.ItemListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);	
EndProcedure

&AtClient
Procedure ItemListBeforeDeleteRow(Item, Cancel)
	CurrentData = Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	DocPhysicalCountByLocationClient.ItemListBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocPhysicalCountByLocationClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

#Region ITEM_LIST_COLUMNS

#Region _ITEM

&AtClient
Procedure ItemListItemOnChange(Item)
	DocPhysicalCountByLocationClient.ItemListItemOnChange(Object, ThisObject);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocPhysicalCountByLocationClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocPhysicalCountByLocationClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region SERIAL_LOT_NUMBERS
&AtClient
Procedure ItemListSerialLotNumberStartChoice(Item, ChoiceData, StandardProcessing) Export
	SerialLotNumberClient.StartChoiceSingle(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListSerialLotNumberEditTextChange(Item, Text, StandardProcessing)
	FormParameters = New Structure();
	FormParameters.Insert("ItemType", Undefined);
	FormParameters.Insert("Item", Items.ItemList.CurrentData.Item);
	FormParameters.Insert("ItemKey", Items.ItemList.CurrentData.ItemKey);

	SerialLotNumberClient.EditTextChange(Item, Text, StandardProcessing, ThisObject, FormParameters);
EndProcedure

&AtClient
Procedure SerialLotNumbersSerialLotNumberCreating(Item, StandardProcessing)
	
	StandardProcessing = False;
	
	FormParameters = New Structure();
	FormParameters.Insert("ItemType", Undefined);
	FormParameters.Insert("Item", Items.ItemList.CurrentData.Item);
	FormParameters.Insert("ItemKey", Items.ItemList.CurrentData.ItemKey);
	FormParameters.Insert("Description", Item.EditText);
	
	OpenForm("Catalog.SerialLotNumbers.ObjectForm", FormParameters, ThisObject);
EndProcedure

#EndRegion

#Region ITEM_KEY

&AtClient
Procedure ItemListItemKeyOnChange(Item)
	DocPhysicalCountByLocationClient.ItemListItemKeyOnChange(Object, ThisObject);
EndProcedure

#EndRegion

#Region PHYS_COUNT

&AtClient
Procedure ItemListPhysCountOnChange(Item)
	DocPhysicalCountByLocationClient.ItemListPhysCountOnChange(Object, ThisObject);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region SERVICE

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

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
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

#Region COPY_PASTE

//@skip-check module-unused-method
&AtClient
Procedure CopyToClipboard(Command)
	CopyPasteClient.CopyToClipboard(Object, ThisObject);
EndProcedure

&AtClient
Procedure CopyToClipboardAfterSetSettings(CopySettings, AddInfo) Export
	If CopySettings = Undefined Then
		Return;
	EndIf;
	
	CopyPasteResult = CopyToClipboardServer(CopySettings);
	CopyPasteClient.AfterCopy(CopyPasteResult);
EndProcedure

&AtServer
Function CopyToClipboardServer(CopySettings)
	Return CopyPasteServer.CopyToClipboard(Object, ThisObject, CopySettings);
EndFunction

//@skip-check module-unused-method
&AtClient
Procedure PasteFromClipboard(Command)
	CopyPasteClient.PasteFromClipboard(Object, ThisObject);
EndProcedure

&AtClient
Procedure PasteFromClipboardAfterSetSettings(PasteSettings, AddInfo) Export
	If PasteSettings = Undefined Then
		Return;
	EndIf;
	
	CopyPasteResult = PasteFromClipboardServer(PasteSettings);
	CopyPasteClient.AfterPaste(Object, ThisObject,CopyPasteResult);
EndProcedure

&AtServer
Function PasteFromClipboardServer(CopySettings)
	Return CopyPasteServer.PasteFromClipboard(Object, ThisObject, CopySettings);
EndFunction

#EndRegion

#Region COMMANDS

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Procedure DecorationStatusHistoryClick(Item)
	ObjectStatusesClient.OpenHistoryByStatus(Object.Ref, ThisObject);
EndProcedure

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	Settings = BarcodeClient.GetBarcodeSettings();
	Settings.Filter.DisableIfIsService = True;
	DocumentsClient.SearchByBarcode(Barcode, Object, ThisObject, , , Settings);
EndProcedure

&AtClient
Procedure OpenPickupItems(Command)
	DocumentsClient.OpenPickupItems(Object, ThisObject);
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

#EndRegion

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

#EndRegion
