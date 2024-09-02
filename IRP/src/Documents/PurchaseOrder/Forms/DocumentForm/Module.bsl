
#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocPurchaseOrderServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	ThisObject.ClosingOrder = DocOrderClosingServer.GetClosingByPurchaseOrder(Object.Ref);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocPurchaseOrderServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	CurrenciesServer.BeforeWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocPurchaseOrderServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocPurchaseOrderClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;

	If EventName = "LockLinkedRows" Then
		If Source <> ThisObject Then
			LockLinkedRows();
		EndIf;
	EndIf;
	
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;

	If Not Source = ThisObject Then
		Return;
	EndIf;
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	DocPurchaseOrderClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
	UpdateTotalAmounts();
EndProcedure

&AtClient
Procedure API_Callback(TableName, ArrayOfDataPaths) Export
	API_CallbackAtServer(TableName, ArrayOfDataPaths);
EndProcedure

&AtServer
Procedure API_CallbackAtServer(TableName, ArrayOfDataPaths)
	ViewServer_V2.API_CallbackAtServer(Object, ThisObject, TableName, ArrayOfDataPaths);
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	IsTransactionType_Purchase = Object.TransactionType = PredefinedValue("Enum.PurchaseTransactionTypes.Purchase");
	Form.Items.GroupAging.Visible = IsTransactionType_Purchase;
	
	Form.Items.AddBasisDocuments.Enabled = Not Form.ReadOnly;
	Form.Items.LinkUnlinkBasisDocuments.Enabled = Not Form.ReadOnly;

	Form.Items.LegalName.Enabled = ValueIsFilled(Object.Partner);
	If Not Form.ClosingOrder.IsEmpty() Then
		Form.ReadOnly = True;
	EndIf;
	Form.Items.GroupHead.Visible = Not Form.ClosingOrder.IsEmpty();
	Form.Items.EditCurrencies.Enabled = Not Form.ReadOnly;
	DocumentsClientServer.SetReadOnlyPaymentTermsCanBePaid(Object, Form);
	
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
	
	Form.Items.VendorPrice.Visible = Form.Items.ShowVendorPrice.Check;
	
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

&AtClient
Procedure UpdateTotalAmounts() Export
	ThisObject.TotalNetAmount = 0;
	ThisObject.TotalTotalAmount = 0;
	ThisObject.TotalTaxAmount = 0;
	ThisObject.TotalOffersAmount = 0;
	For Each Row In Object.ItemList Do
		If Row.Cancel Then
			Continue;
		EndIf;
		ThisObject.TotalNetAmount = ThisObject.TotalNetAmount + Row.NetAmount;
		ThisObject.TotalTotalAmount = ThisObject.TotalTotalAmount + Row.TotalAmount;

		ThisObject.TotalTaxAmount = ThisObject.TotalTaxAmount + Row.TaxAmount;

		ArrayOfOffersRows = Object.SpecialOffers.FindRows(New Structure("Key", Row.Key));
		For Each RowOffer In ArrayOfOffersRows Do
			ThisObject.TotalOffersAmount = ThisObject.TotalOffersAmount + RowOffer.Amount;
		EndDo;
	EndDo;
EndProcedure

#EndRegion

#Region _DATE

&AtClient
Procedure DateOnChange(Item)
	DocPurchaseOrderClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocPurchaseOrderClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocPurchaseOrderClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocPurchaseOrderClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region TRANSACTION_TYPE

&AtClient
Procedure TransactionTypeOnChange(Item)
	DocPurchaseOrderClient.TransactionTypeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PARTNER

&AtClient
Procedure PartnerOnChange(Item)
	DocPurchaseOrderClient.PartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocPurchaseOrderClient.PartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PartnerEditTextChange(Item, Text, StandardProcessing)
	DocPurchaseOrderClient.PartnerTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region LEGAL_NAME

&AtClient
Procedure LegalNameOnChange(Item)
	DocPurchaseOrderClient.LegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure LegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocPurchaseOrderClient.LegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure LegalNameEditTextChange(Item, Text, StandardProcessing)
	DocPurchaseOrderClient.LegalNameTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region AGREEMENT

&AtClient
Procedure AgreementOnChange(Item)
	DocPurchaseOrderClient.AgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocPurchaseOrderClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AgreementEditTextChange(Item, Text, StandardProcessing)
	DocPurchaseOrderClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region CURRENCY

&AtClient
Procedure CurrencyOnChange(Item)
	DocPurchaseOrderClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region STORE

&AtClient
Procedure StoreOnChange(Item)
	DocPurchaseOrderClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region DELIVERY_DATE

&AtClient
Procedure DeliveryDateOnChange(Item)
	DocPurchaseOrderClient.DeliveryDateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region STATUS

&AtClient
Procedure StatusOnChange(Item)
	DocPurchaseOrderClient.StatusOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PRICE_INCLUDE_TAX

&AtClient
Procedure PriceIncludeTaxOnChange(Item)
	DocPurchaseOrderClient.PriceIncludeTaxOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region _NUMBER

&AtClient
Procedure NumberOnChange(Item)
	DocPurchaseOrderClient.NumberOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ITEM_LIST

&AtClient
Procedure ItemListSelection(Item, RowSelected, Field, StandardProcessing)
	DocPurchaseOrderClient.ItemListSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocPurchaseOrderClient.ItemListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure ItemListBeforeDeleteRow(Item, Cancel)
	DocPurchaseOrderClient.ItemListBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocPurchaseOrderClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
	LockLinkedRows();
EndProcedure

#Region ITEM_LIST_COLUMNS

#Region PARTNER_ITEM

&AtClient
Procedure ItemListPartnerItemOnChange(Item)
	DocPurchaseOrderClient.ItemListPartnerItemOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region _ITEM

&AtClient
Procedure ItemListItemOnChange(Item)
	DocPurchaseOrderClient.ItemListItemOnChange(Object, ThisObject, Item);
	ItemListItemKeyOnChangeAtServer();
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocPurchaseOrderClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocPurchaseOrderClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ITEM_KEY

&AtClient
Procedure ItemListItemKeyOnChange(Item)
	DocPurchaseOrderClient.ItemListItemKeyOnChange(Object, ThisObject, Item);
	ItemListItemKeyOnChangeAtServer();
EndProcedure

&AtServer
Procedure ItemListItemKeyOnChangeAtServer()
	GetItemInfo.FillVendorPricesInObject(Object);
EndProcedure

#EndRegion

#Region PRICE_TYPE

&AtClient
Procedure ItemListPriceTypeOnChange(Item)
	DocPurchaseOrderClient.ItemListPriceTypeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region UNIT

&AtClient
Procedure ItemListUnitOnChange(Item)
	DocPurchaseOrderClient.ItemListUnitOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region QUANTITY

&AtClient
Procedure ItemListQuantityOnChange(Item)
	DocPurchaseOrderClient.ItemListQuantityOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region QUANTITY_IN_BASE_UNIT

&AtClient
Procedure ItemListQuantityInBaseUnitOnChange(Item)
	DocPurchaseOrderClient.ItemListQuantityInBaseUnitOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region QUANTITY_IS_FIXED

&AtClient
Procedure ItemListQuantityIsFixedOnChange(Item)
	DocPurchaseOrderClient.ItemListQuantityIsFixedOnChange(Object, ThisObject, Item);	
EndProcedure

#EndRegion

#Region PRICE

&AtClient
Procedure ItemListPriceOnChange(Item)
	DocPurchaseOrderClient.ItemListPriceOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region NET_AMOUNT

&AtClient
Procedure ItemListNetAmountOnChange(Item)
	DocPurchaseOrderClient.ItemListNetAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TOTAL_AMOUNT

&AtClient
Procedure ItemListTotalAmountOnChange(Item)
	DocPurchaseOrderClient.ItemListTotalAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TAX_AMOUNT

&AtClient
Procedure ItemListTaxAmountOnChange(Item)
	DocPurchaseOrderClient.ItemListTaxAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region DONT_CALCULATE_ROW

&AtClient
Procedure ItemListDontCalculateRowOnChange(Item)
	DocPurchaseOrderClient.ItemListDontCalculateRowOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region STORE

&AtClient
Procedure ItemListStoreOnChange(Item)
	DocPurchaseOrderClient.ItemListStoreOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region VAT_RATE

&AtClient
Procedure ItemListVatRateOnChange(Item) Export
	DocPurchaseOrderClient.ItemListVatRateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region EXPENSE_TYPE

&AtClient
Procedure ItemListExpenseTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocPurchaseOrderClient.ItemListExpenseTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListExpenseTypeEditTextChange(Item, Text, StandardProcessing)
	DocPurchaseOrderClient.ItemListExpenseTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region CANCEL

&AtClient
Procedure ItemListCancelOnChange(Item)
	DocPurchaseOrderClient.ItemListCancelOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region PAYMENT_TERMS

&AtClient
Procedure PaymentTermsDateOnChange(Item)
	DocPurchaseOrderClient.PaymentTermsDateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentTermsOnChange(Item)
	DocPurchaseOrderClient.PaymentTermsOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region SPECIAL_OFFERS

#Region FOR_DOCUMENT

&AtClient
Procedure SetSpecialOffers(Command)
	OffersClient.OpenFormPickupSpecialOffers_ForDocument(Object, ThisObject, "SpecialOffersEditFinish_ForDocument");
EndProcedure

&AtClient
Procedure SpecialOffersEditFinish_ForDocument(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	CalculateOffersAfterSet(Result);
	OffersClient.SpecialOffersEditFinish_ForDocument(Object, ThisObject, AdditionalParameters);
EndProcedure

&AtServer
Procedure CalculateOffersAfterSet(Result)
	OffersServer.CalculateOffersAfterSet(Result, Object);
EndProcedure

#EndRegion

#Region FOR_ROW

&AtClient
Procedure SetSpecialOffersAtRow(Command)
	OffersClient.OpenFormPickupSpecialOffers_ForRow(Object, Items.ItemList.CurrentData, ThisObject,
		"SpecialOffersEditFinish_ForRow");
EndProcedure

&AtClient
Procedure SpecialOffersEditFinish_ForRow(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	CalculateAndLoadOffers_ForRow(Result);
	OffersClient.SpecialOffersEditFinish_ForRow(Result, Object, ThisObject, AdditionalParameters);
EndProcedure

&AtServer
Procedure CalculateAndLoadOffers_ForRow(Result)
	OffersServer.CalculateAndLoadOffers_ForRow(Object, Result.OffersAddress, Result.ItemListRowKey);
EndProcedure

#EndRegion

#EndRegion

#Region SERVICE

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocPurchaseOrderClient);
	Str.Insert("Server", DocPurchaseOrderServer);
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

//@skip-check module-unused-method
&AtClient
Async Procedure PasteFromClipboardValues(Command)
	ClipBoardText = Await CopyPasteClient.TextFromClipBoard(ClipboardDataStandardFormat.Text);		
	CopyPasteClient.RecalculateRowsByNewValues(Object, ThisObject, ClipBoardText);	
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
Procedure DecorationStatusHistoryClick(Item)
	ObjectStatusesClient.OpenHistoryByStatus(Object.Ref, ThisObject);
EndProcedure

&AtClient
Procedure OpenPickupItems(Command)
	DocumentsClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	DocumentsClient.SearchByBarcodeWithPriceType(Barcode, Object, ThisObject);
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
	FormParameters.Insert("Filter", RowIDInfoClientServer.GetLinkedDocumentsFilter_PO(Object));
	FormParameters.Insert("SelectedRowInfo", RowIDInfoClient.GetSelectedRowInfo(Items.ItemList.CurrentData));
	FormParameters.Insert("TablesInfo", RowIDInfoClient.GetTablesInfo(Object));
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", ThisObject);
	OpenForm("CommonForm.LinkUnlinkDocumentRows", FormParameters, , , , ,
		New NotifyDescription("AddOrLinkUnlinkDocumentRowsContinue", ThisObject, NotifyParameters), 
			FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure AddBasisDocuments(Command)
	FormParameters = New Structure();
	FormParameters.Insert("Filter", RowIDInfoClientServer.GetLinkedDocumentsFilter_PO(Object));
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
EndProcedure

&AtServer
Function AddOrLinkUnlinkDocumentRowsContinueAtServer(Result)
	ExtractedData = Undefined;
	If Result.Operation = "LinkUnlinkDocumentRows" Then
		LinkedResult = RowIDInfoServer.LinkUnlinkDocumentRows(Object, Result.FillingValues, Result.CalculateRows);
	ElsIf Result.Operation = "AddLinkedDocumentRows" Then
		LinkedResult = RowIDInfoServer.AddLinkedDocumentRows(Object, Result.FillingValues);
	EndIf;
	ExtractedData = ControllerClientServer_V2.AddLinkedDocumentRows(Object, ThisObject, LinkedResult, "ItemList");
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
Procedure EditCurrencies(Command)
	FormParameters = CurrenciesClientServer.GetParameters_V3(Object);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

&AtClient
Procedure EditQuantityInBaseUnit(Command)
	Items.ItemListQuantityInBaseUnit.Visible = Not Items.ItemListQuantityInBaseUnit.Visible;
	Items.ItemListQuantityIsFixed.Visible = Not Items.ItemListQuantityIsFixed.Visible;	 	
EndProcedure

&AtClient
Procedure ShowVendorPrice(Command)
	Items.ShowVendorPrice.Check = Not Items.ShowVendorPrice.Check;

	ShowVendorPriceVisibleOnServer(Items.ShowVendorPrice.Check);
	If Items.ShowVendorPrice.Check Then
		Items.ItemList.CurrentItem = Items.ItemListLastVendorPrice;
	EndIf;
EndProcedure

&AtServer
Procedure ShowVendorPriceVisibleOnServer(Visible)
	Items.VendorPrice.Visible = Visible;
EndProcedure

#EndRegion
