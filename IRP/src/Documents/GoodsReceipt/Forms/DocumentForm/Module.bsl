#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocGoodsReceiptServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
	DocGoodsReceiptServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	SetVisibilityAvailability(Object, ThisObject);
	DocGoodsReceiptServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocGoodsReceiptClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
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
	DocGoodsReceiptClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	Form.Items.AddBasisDocuments.Enabled = Not Form.ReadOnly;
	Form.Items.LinkUnlinkBasisDocuments.Enabled = Not Form.ReadOnly;

	PartnerVisible = (Object.TransactionType = PredefinedValue("Enum.GoodsReceiptTransactionTypes.ReturnFromCustomer")
		Or Object.TransactionType = PredefinedValue("Enum.GoodsReceiptTransactionTypes.Purchase")
		Or Object.TransactionType = PredefinedValue("Enum.GoodsReceiptTransactionTypes.ReceiptFromConsignor")
		Or Object.TransactionType = PredefinedValue("Enum.GoodsReceiptTransactionTypes.ReturnFromTradeAgent"));
		
	Form.Items.LegalName.Enabled = PartnerVisible And ValueIsFilled(Object.Partner);
	Form.Items.Partner.Visible   = PartnerVisible;
	Form.Items.LegalName.Visible = PartnerVisible;
	For Each Row In Object.ItemList Do
		If ValueIsFilled(Row.ReceiptBasis) Then
			Row.ReceiptBasisCurrency = ServiceSystemServer.GetCompositeObjectAttribute(Row.ReceiptBasis, "Currency");
		Else
			Row.ReceiptBasisCurrency = Undefined;
		EndIf;
	EndDo;

	_QuantityIsFixed = False;
	For Each Row In Object.ItemList Do
		If Row.QuantityIsFixed Then
			_QuantityIsFixed = True;
			Break;
		EndIf;
	EndDo;
	Form.Items.ItemListQuantityIsFixed.Visible = _QuantityIsFixed;
	Form.Items.ItemListQuantityInBaseUnit.Visible = _QuantityIsFixed;
	Form.Items.EditQuantityInBaseUnit.Enabled = Not _QuantityIsFixed;
	
	ArrayOfOrders = New Array();
	For Each Row In Object.ItemList Do
		If ValueIsFilled(Row.PurchaseOrder) Then
			ArrayOfOrders.Add(New Structure("Key, DocOrder", Row.Key, Row.PurchaseOrder));
		EndIf;
	EndDo;
	ClosedRowKeys = DocOrderClosingServer.GetIsClosedPurchaseOrderInItemList(ArrayOfOrders);
	For Each Row In Form.Object.ItemList Do
			Row.IsClosedOrder = ClosedRowKeys.Find(Row.Key) <> Undefined;
	EndDo;
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

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocGoodsReceiptClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocGoodsReceiptClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocGoodsReceiptClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region PARTNER

&AtClient
Procedure PartnerOnChange(Item)
	DocGoodsReceiptClient.PartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocGoodsReceiptClient.PartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PartnerEditTextChange(Item, Text, StandardProcessing)
	DocGoodsReceiptClient.PartnerTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region LEGAL_NAME

&AtClient
Procedure LegalNameOnChange(Item)
	DocGoodsReceiptClient.LegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure LegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocGoodsReceiptClient.LegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure LegalNameEditTextChange(Item, Text, StandardProcessing)
	DocGoodsReceiptClient.LegalNameTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region STORE

&AtClient
Procedure StoreOnChange(Item)
	DocGoodsReceiptClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TRANSACTION_TYPE

&AtClient
Procedure TransactionTypeOnChange(Item)
	DocGoodsReceiptClient.TransactionTypeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ITEM_LIST

&AtClient
Procedure ItemListSelection(Item, RowSelected, Field, StandardProcessing)
	DocGoodsReceiptClient.ItemListSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocGoodsReceiptClient.ItemListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure ItemListBeforeDeleteRow(Item, Cancel)
	DocGoodsReceiptClient.ItemListBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocGoodsReceiptClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
	LockLinkedRows();
EndProcedure

#Region ITEM_LIST_COLUMNS

#Region _ITEM

&AtClient
Procedure ItemListItemOnChange(Item)
	DocGoodsReceiptClient.ItemListItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocGoodsReceiptClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocGoodsReceiptClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ITEM_KEY

&AtClient
Procedure ItemListItemKeyOnChange(Item)
	DocGoodsReceiptClient.ItemListItemKeyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region QUANTITY

&AtClient
Procedure ItemListQuantityOnChange(Item)
	DocGoodsReceiptClient.ItemListQuantityOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region QUANTITY_IN_BASE_UNIT

&AtClient
Procedure ItemListQuantityInBaseUnitOnChange(Item)
	DocGoodsReceiptClient.ItemListQuantityInBaseUnitOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region QUANTITY_IS_FIXED

&AtClient
Procedure ItemListQuantityIsFixedOnChange(Item)
	DocGoodsReceiptClient.ItemListQuantityIsFixedOnChange(Object, ThisObject, Item);	
EndProcedure

#EndRegion

#Region UNIT

&AtClient
Procedure ItemListUnitOnChange(Item)
	DocGoodsReceiptClient.ItemListUnitOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region STORE

&AtClient
Procedure ItemListStoreOnChange(Item)
	DocGoodsReceiptClient.ItemListStoreOnChange(Object, ThisObject, Item);
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

#EndRegion

#EndRegion

#Region SERVICE

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocGoodsReceiptClient);
	Str.Insert("Server", DocGoodsReceiptServer);
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

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

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
Procedure SearchByBarcode(Command, Barcode = "")
	DocumentsClient.SearchByBarcode(Barcode, Object, ThisObject);
EndProcedure

&AtClient
Procedure OpenScanForm(Command)
	DocumentsClient.OpenScanForm(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure OpenPickupItems(Command)
	DocumentsClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

//@skip-check module-unused-method
&AtClient
Procedure OpenSerialLotNumbersTree(Command)
	SerialLotNumberClient.OpenSerialLotNumbersTree(Object, ThisObject);
EndProcedure

#EndRegion

#Region LINKED_DOCUMENTS

&AtClient
Procedure LinkUnlinkBasisDocuments(Command)
	FormParameters = New Structure();
	FormParameters.Insert("Filter", RowIDInfoClientServer.GetLinkedDocumentsFilter_GR(Object));
	FormParameters.Insert("SelectedRowInfo", RowIDInfoClient.GetSelectedRowInfo(Items.ItemList.CurrentData));
	FormParameters.Insert("TablesInfo", RowIDInfoClient.GetTablesInfo(Object));
	OpenForm("CommonForm.LinkUnlinkDocumentRows", FormParameters, , , , ,
		New NotifyDescription("AddOrLinkUnlinkDocumentRowsContinue", ThisObject), FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure AddBasisDocuments(Command)
	FormParameters = New Structure();
	FormParameters.Insert("Filter", RowIDInfoClientServer.GetLinkedDocumentsFilter_GR(Object));
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
	ExtractedData = AddOrLinkUnlinkDocumentRowsContinueAtServer(Result);
	If ExtractedData <> Undefined Then
		ViewClient_V2.OnAddOrLinkUnlinkDocumentRows(ExtractedData, Object, ThisObject, "ItemList");
	EndIf;
	SourceOfOriginClientServer.UpdateSourceOfOriginsQuantity(Object);
	SourceOfOriginClient.UpdateSourceOfOriginsPresentation(Object);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Function AddOrLinkUnlinkDocumentRowsContinueAtServer(Result)
	ExtractedData = Undefined;
	If Result.Operation = "LinkUnlinkDocumentRows" Then
		RowIDInfoServer.LinkUnlinkDocumentRows(Object, Result.FillingValues, Result.CalculateRows);
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
Procedure EditQuantityInBaseUnit(Command)
	Items.ItemListQuantityInBaseUnit.Visible = Not Items.ItemListQuantityInBaseUnit.Visible;
	Items.ItemListQuantityIsFixed.Visible = Not Items.ItemListQuantityIsFixed.Visible;	 	
EndProcedure

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

#EndRegion
