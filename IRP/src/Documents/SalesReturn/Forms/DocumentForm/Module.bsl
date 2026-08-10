
#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocSalesReturnServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	ThisObject.DocStorno = DocStornoServer.IsDocumentWithStorno(Object.Ref);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocSalesReturnServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	AccountingServer.BeforeWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
	CurrenciesServer.BeforeWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocSalesReturnServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocSalesReturnClient.OnOpen(Object, ThisObject, Cancel);
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

	If EventName = "Storno" Then
		ThisObject.DocStorno = DocStornoServer.IsDocumentWithStorno(Object.Ref);
		SetVisibilityAvailability(Object, ThisObject);
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
	DocSalesReturnClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
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
Procedure FormUpdateFormAttributes(Direction) Export
	UpdateFormAttributes(Object, ThisObject, Direction);
EndProcedure

&AtClientAtServerNoContext
Procedure UpdateFormAttributes(Object, Form, Direction)
	Return;
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	Form.Items.AddBasisDocuments.Enabled = Not Form.ReadOnly;
	Form.Items.LinkUnlinkBasisDocuments.Enabled = Not Form.ReadOnly;
	Form.Items.LegalName.Enabled = ValueIsFilled(Object.Partner);
	Form.Items.EditCurrencies.Enabled = Not Form.ReadOnly;
	Form.Items.EditAccounting.Enabled = Not Form.ReadOnly;
	
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
	
	If Not Form.ReadOnly Then
		Form.ReadOnly = ValueIsFilled(Form.DocStorno);
	EndIf;
	Form.Items.GroupHeadStorno.Visible = ValueIsFilled(Form.DocStorno);
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

#Region _DATE

&AtClient
Procedure DateOnChange(Item)
	DocSalesReturnClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocSalesReturnClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesReturnClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocSalesReturnClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region TRANSACTION_TYPE

&AtClient
Procedure TransactionTypeOnChange(Item)
	DocSalesReturnClient.TransactionTypeOnChange(Object, ThisObject, Item);	
EndProcedure

#EndRegion

#Region PARTNER

&AtClient
Procedure PartnerOnChange(Item)
	DocSalesReturnClient.PartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesReturnClient.PartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PartnerEditTextChange(Item, Text, StandardProcessing)
	DocSalesReturnClient.PartnerTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region LEGAL_NAME

&AtClient
Procedure LegalNameOnChange(Item)
	DocSalesReturnClient.LegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure LegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesReturnClient.LegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure LegalNameEditTextChange(Item, Text, StandardProcessing)
	DocSalesReturnClient.LegalNameTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region AGREEMENT

&AtClient
Procedure AgreementOnChange(Item)
	DocSalesReturnClient.AgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesReturnClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AgreementEditTextChange(Item, Text, StandardProcessing)
	DocSalesReturnClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region CURRENCY

&AtClient
Procedure CurrencyOnChange(Item)
	DocSalesReturnClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region STORE

&AtClient
Procedure StoreOnChange(Item)
	DocSalesReturnClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region LEGAL_NAME_CONTRACT

&AtClient
Procedure LegalNameContractOnChange(Item)
	DocSalesReturnClient.LegalNameContractOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PRICE_INCLUDE_TAX

&AtClient
Procedure PriceIncludeTaxOnChange(Item)
	DocSalesReturnClient.PriceIncludeTaxOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ITEM_LIST

&AtClient
Procedure ItemListSelection(Item, RowSelected, Field, StandardProcessing)
	DocSalesReturnClient.ItemListSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocSalesReturnClient.ItemListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure ItemListBeforeDeleteRow(Item, Cancel)
	DocSalesReturnClient.ItemListBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocSalesReturnClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
	LockLinkedRows();
EndProcedure

#Region ITEM_LIST_COLUMNS

#Region _ITEM

&AtClient
Procedure ItemListItemOnChange(Item)
	DocSalesReturnClient.ItemListItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesReturnClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocSalesReturnClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ITEM_KEY

&AtClient
Procedure ItemListItemKeyOnChange(Item)
	DocSalesReturnClient.ItemListItemKeyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region UNIT

&AtClient
Procedure ItemListUnitOnChange(Item)
	DocSalesReturnClient.ItemListUnitOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region QUANTITY

&AtClient
Procedure ItemListQuantityOnChange(Item)
	DocSalesReturnClient.ItemListQuantityOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region QUANTITY_IN_BASE_UNIT

&AtClient
Procedure ItemListQuantityInBaseUnitOnChange(Item)
	DocSalesReturnClient.ItemListQuantityInBaseUnitOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region QUANTITY_IS_FIXED

&AtClient
Procedure ItemListQuantityIsFixedOnChange(Item)
	DocSalesReturnClient.ItemListQuantityIsFixedOnChange(Object, ThisObject, Item);	
EndProcedure

#EndRegion

#Region PRICE

&AtClient
Procedure ItemListPriceOnChange(Item)
	DocSalesReturnClient.ItemListPriceOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TOTAL_AMOUNT

&AtClient
Procedure ItemListTotalAmountOnChange(Item)
	DocSalesReturnClient.ItemListTotalAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TAX_AMOUNT

&AtClient
Procedure ItemListTaxAmountOnChange(Item)
	DocSalesReturnClient.ItemListTaxAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region MANUAL_OFFER

&AtClient
Procedure ItemListManualOfferTypeOnChange(Item)
	DocSalesReturnClient.ItemListManualOfferTypeOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListManualOfferPercentOnChange(Item)
	DocSalesReturnClient.ItemListManualOfferPercentOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListManualOfferAmountOnChange(Item)
	DocSalesReturnClient.ItemListManualOfferAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region DONT_CALCULATE_ROW

&AtClient
Procedure ItemListDontCalculateRowOnChange(Item)
	DocSalesReturnClient.ItemListDontCalculateRowOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region STORE

&AtClient
Procedure ItemListStoreOnChange(Item)
	DocSalesReturnClient.ItemListStoreOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region VAT_RATE

&AtClient
Procedure ItemListVatRateOnChange(Item) Export
	DocSalesReturnClient.ItemListVatRateOnChange(Object, ThisObject, Item);
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

#Region SOURCE_OF_ORIGINS

&AtClient
Procedure ItemListSourceOfOriginsPresentationStartChoice(Item, ChoiceData, StandardProcessing)
	SourceOfOriginClient.PresentationStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListSourceOfOriginsPresentationClearing(Item, StandardProcessing)
	SourceOfOriginClient.PresentationClearing(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region REVENUE_TYPE

&AtClient
Procedure ItemListRevenueTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesReturnClient.ItemListRevenueTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListRevenueTypeEditTextChange(Item, Text, StandardProcessing)
	DocSalesReturnClient.ItemListRevenueTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region SALES_INVOICE

&AtClient
Procedure ItemListSalesInvoiceOnChange(Item)
	DocSalesReturnClient.ItemListSalesInvoiceOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#EndRegion

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
	If Items.ItemList.SelectedRows.Count() > 1 Then 
		ArrayOfRowKeys = New Array();
		For Each ItemOfArray In Items.ItemList.SelectedRows Do  
			ArrayOfRowKeys.Add(Object.ItemList.FindByID(ItemOfArray).Key);
		EndDo;
		OffersClient.OpenFormPickupSpecialOffers_ForSelectedRows(Object, ArrayOfRowKeys, ThisObject, "SpecialOffersEditFinish_ForSelectedRows");
	Else	
		OffersClient.OpenFormPickupSpecialOffers_ForRow(Object, Items.ItemList.CurrentData, ThisObject, "SpecialOffersEditFinish_ForRow");
	EndIf;
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

&AtClient
Procedure SpecialOffersEditFinish_ForSelectedRows(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	CalculateAndLoadOffers_ForSelectedRows(Result);
	OffersClient.SpecialOffersEditFinish_ForSelectedRows(Result, Object, ThisObject, AdditionalParameters);
EndProcedure

&AtServer
Procedure CalculateAndLoadOffers_ForSelectedRows(Result)
	OffersServer.CalculateAndLoadOffers_ForSelectedRows(Object, Result.OffersAddress, Result.ArrayOfRowKeys);
EndProcedure

#EndRegion

#Region MANUAL_OFFERS

&AtClient
Procedure SetManualOffers(Command)
	
	ArrayOfRows = New Array();
	For Each ItemOfArray In Items.ItemList.SelectedRows Do
		ItemListRow = Object.ItemList.FindByID(ItemOfArray);
		ArrayOfRows.Add(New Structure("Key, Quantity, Price, ManualOfferAmount, ManualOfferPercent, ManualOfferType", 
			ItemListRow.Key, 
			ItemListRow.Quantity, 
			ItemListRow.Price, 
			ItemListRow.ManualOfferAmount, 
			ItemListRow.ManualOfferPercent,
			ItemListRow.ManualOfferType));
	EndDo;
	
	If ArrayOfRows.Count() = 0 Then
		Return;
	EndIf;
	FormParameters = New Structure();
	FormParameters.Insert("ManualOfferAmount" , 0);
	FormParameters.Insert("ManualOfferPercent", 0);
	FormParameters.Insert("ManualOfferType"   , Undefined);
	FormParameters.Insert("ItemList"          , ArrayOfRows);
	
	If ArrayOfRows.Count() = 1 Then
		FormParameters.ManualOfferAmount = ArrayOfRows[0].ManualOfferAmount;
		FormParameters.ManualOfferPercent = ArrayOfRows[0].ManualOfferPercent;
		FormParameters.ManualOfferType = ArrayOfRows[0].ManualOfferType;
	EndIf;
		
	Callback = New CallbackDescription("SetManualOffersFinish", ThisObject);
	OpenForm("CommonForm.EditManualOffers", FormParameters, ThisObject,,,, Callback, FormWindowOpeningMode.LockOwnerWindow);	
EndProcedure

&AtClient
Procedure SetManualOffersFinish(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	For Each Row In Result.ItemList Do
		ItemListRow = Object.ItemList.FindRows(New Structure("Key", Row.Key))[0];
		ViewClient_V2.SetItemListManualOfferType(Object, ThisObject, ItemListRow, Row.ManualOfferType);
		If Row.ManualOfferType = PredefinedValue("Enum.ManualOfferTypes.Percent") Then
			ViewClient_V2.SetItemListManualOfferPercent(Object, ThisObject, ItemListRow, Row.ManualOfferPercent);
		Else
			ViewClient_V2.SetItemListManualOfferAmount(Object, ThisObject, ItemListRow, Row.ManualOfferAmount);
		EndIf;
	EndDo;	
EndProcedure

#EndRegion

#EndRegion

#Region LINKED_DOCUMENTS

&AtClient
Procedure LinkedDocuments_GoodsReceipts(Command)
	DocumentsClient.OpenLinkedDocuments(Object, ThisObject, "GoodsReceipts", "GoodsReceipt", "QuantityInGoodsReceipt");
EndProcedure

#EndRegion

#Region SERVICE

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocSalesReturnClient);
	Str.Insert("Server", DocSalesReturnServer);
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
Procedure OpenPickupItems(Command)
	DocumentsClient.OpenPickupItems(Object, ThisObject);
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

//@skip-check module-unused-method
&AtClient
Procedure OpenSerialLotNumbersTree(Command)
	SerialLotNumberClient.OpenSerialLotNumbersTree(Object, ThisObject);
EndProcedure

#EndRegion

#Region LINKED_DOCUMENTS

&AtClient
Procedure LinkUnlinkBasisDocuments(Command)
	CurrentData = Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	ArrayOfFilterExcludeFields = New Array();
	ArrayOfFilterExcludeFields.Add("Store");
	FormParameters = New Structure();
	FormParameters.Insert("Filter", RowIDInfoClientServer.GetLinkedDocumentsFilter_SR(Object));
	FormParameters.Insert("SelectedRowInfo", RowIDInfoClient.GetSelectedRowInfo(CurrentData, ArrayOfFilterExcludeFields));
	FormParameters.Insert("TablesInfo", RowIDInfoClient.GetTablesInfo(Object));
	RowIDInfoClient.OpenForm_LinkUnlinkDocumentRows(Object, ThisObject, FormParameters);
EndProcedure

&AtClient
Procedure AddBasisDocuments(Command)
	FormParameters = New Structure();
	FormParameters.Insert("Filter", RowIDInfoClientServer.GetLinkedDocumentsFilter_SR(Object));
	FormParameters.Insert("TablesInfo", RowIDInfoClient.GetTablesInfo(Object));
	RowIDInfoClient.OpenForm_AddLinkedDocumentRows(Object, ThisObject, FormParameters);
EndProcedure

&AtClient
Procedure AddOrLinkUnlinkDocumentRowsContinue(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	ThisObject.Modified = True;
	AddOrLinkUnlinkDocumentRowsContinueAtServer(Result);
	ViewClient_V2.OnAddOrLinkUnlinkDocumentRows(Object, ThisObject, "ItemList");
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure AddOrLinkUnlinkDocumentRowsContinueAtServer(Result)
	If Result.Operation = "LinkUnlinkDocumentRows" Then
		LinkedResult = RowIDInfoServer.LinkUnlinkDocumentRows(Object, Result.FillingValues, Result.CalculateRows);
	ElsIf Result.Operation = "AddLinkedDocumentRows" Then
		LinkedResult = RowIDInfoServer.AddLinkedDocumentRows(Object, Result.FillingValues);
	Else
		Raise StrTemplate(R().UnsupportedOperation, Result.Operation);
	EndIf;
	ControllerClientServer_V2.AddLinkedDocumentRows(Object, ThisObject, LinkedResult, "ItemList");
	LockLinkedRows();
EndProcedure

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
	Notify = New CallbackDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure EditQuantityInBaseUnit(Command)
	Items.ItemListQuantityInBaseUnit.Visible = Not Items.ItemListQuantityInBaseUnit.Visible;
	Items.ItemListQuantityIsFixed.Visible = Not Items.ItemListQuantityIsFixed.Visible;	 	
EndProcedure

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

&AtClient
Procedure EditAccounting(Command)
	CurrentData = ThisObject.Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	UpdateAccountingData();
	AccountingClient.OpenFormEditAccounting(Object, ThisObject, CurrentData, "ItemList");
EndProcedure

&AtServer
Procedure UpdateAccountingData()
	_AccountingRowAnalytics = ThisObject.AccountingRowAnalytics.Unload();
	_AccountingExtDimensions = ThisObject.AccountingExtDimensions.Unload();
	AccountingClientServer.UpdateAccountingTables(Object, 
			                                      _AccountingRowAnalytics, 
		                                          _AccountingExtDimensions, "ItemList");
	ThisObject.AccountingRowAnalytics.Load(_AccountingRowAnalytics);
	ThisObject.AccountingExtDimensions.Load(_AccountingExtDimensions);
EndProcedure

&AtClient
Procedure SetNewNumber(Command)
	SetNewNumberAtServer();
EndProcedure

&AtServer
Procedure SetNewNumberAtServer()
	If Object.NumeratorRules.IsEmpty() Then
		Object.NumeratorRules = 
			NumberingRulesServer.GetNumeratorGroupForDocument(Object.Ref.Metadata().FullName(), Object);
	EndIf;
	NumberingRulesServer.SetSourceNewNumber(Object);
EndProcedure

#EndRegion

