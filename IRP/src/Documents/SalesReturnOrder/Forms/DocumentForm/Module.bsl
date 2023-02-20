
#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocSalesReturnOrderServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocSalesReturnOrderServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
	SetConditionalAppearance();
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocSalesReturnOrderServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocSalesReturnOrderClient.OnOpen(Object, ThisObject, Cancel);
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
	DocSalesReturnOrderClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
EndProcedure

&AtClient
Procedure API_Callback(TableName, ArrayOfDataPaths) Export
	API_CallbackAtServer(TableName, ArrayOfDataPaths);
EndProcedure

&AtServer
Procedure API_CallbackAtServer(TableName, ArrayOfDataPaths)
	ViewServer_V2.API_CallbackAtServer(Object, ThisObject, TableName, ArrayOfDataPaths);
EndProcedure

&AtServer
Function Taxes_CreateFormControls() Export
	Return TaxesServer.CreateFormControls_ItemList(Object, ThisObject);
EndFunction

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
EndProcedure

&AtServer
Procedure SetConditionalAppearance()
	AppearanceElement = ConditionalAppearance.Items.Add();
	AppearanceElement.Appearance.SetParameterValue("MarkIncomplete", True);
EndProcedure

#EndRegion

#Region _DATE

&AtClient
Procedure DateOnChange(Item)
	DocSalesReturnOrderClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnOrderClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesReturnOrderClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocSalesReturnOrderClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region TRANSACTION_TYPE

&AtClient
Procedure TransactionTypeOnChange(Item)
	DocSalesReturnOrderClient.TransactionTypeOnChange(Object, ThisObject, Item);	
EndProcedure

#EndRegion

#Region PARTNER

&AtClient
Procedure PartnerOnChange(Item)
	DocSalesReturnOrderClient.PartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesReturnOrderClient.PartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PartnerEditTextChange(Item, Text, StandardProcessing)
	DocSalesReturnOrderClient.PartnerTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region LEGAL_NAME

&AtClient
Procedure LegalNameOnChange(Item)
	DocSalesReturnOrderClient.LegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure LegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesReturnOrderClient.LegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure LegalNameEditTextChange(Item, Text, StandardProcessing)
	DocSalesReturnOrderClient.LegalNameTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region AGREEMENT

&AtClient
Procedure AgreementOnChange(Item)
	DocSalesReturnOrderClient.AgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesReturnOrderClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AgreementEditTextChange(Item, Text, StandardProcessing)
	DocSalesReturnOrderClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region CURRENCY

&AtClient
Procedure CurrencyOnChange(Item)
	DocSalesReturnOrderClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region STORE

&AtClient
Procedure StoreOnChange(Item)
	DocSalesReturnOrderClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region STATUS

&AtClient
Procedure StatusOnChange(Item)
	DocSalesReturnOrderClient.StatusOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PRICE_INCLUDE_TAX

&AtClient
Procedure PriceIncludeTaxOnChange(Item)
	DocSalesReturnOrderClient.PriceIncludeTaxOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ITEM_LIST

&AtClient
Procedure ItemListSelection(Item, RowSelected, Field, StandardProcessing)
	DocSalesReturnOrderClient.ItemListSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocSalesReturnOrderClient.ItemListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure ItemListBeforeDeleteRow(Item, Cancel)
	DocSalesReturnOrderClient.ItemListBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocSalesReturnOrderClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
	LockLinkedRows();
EndProcedure

#Region ITEM_LIST_COLUMNS

#Region _ITEM

&AtClient
Procedure ItemListItemOnChange(Item)
	DocSalesReturnOrderClient.ItemListItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesReturnOrderClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocSalesReturnOrderClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ITEM_KEY

&AtClient
Procedure ItemListItemKeyOnChange(Item)
	DocSalesReturnOrderClient.ItemListItemKeyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region UNIT

&AtClient
Procedure ItemListUnitOnChange(Item)
	DocSalesReturnOrderClient.ItemListUnitOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region QUANTITY

&AtClient
Procedure ItemListQuantityOnChange(Item)
	DocSalesReturnOrderClient.ItemListQuantityOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PRICE

&AtClient
Procedure ItemListPriceOnChange(Item)
	DocSalesReturnOrderClient.ItemListPriceOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TOTAL_AMOUNT

&AtClient
Procedure ItemListTotalAmountOnChange(Item)
	DocSalesReturnOrderClient.ItemListTotalAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TAX_AMOUNT

&AtClient
Procedure ItemListTaxAmountOnChange(Item)
	DocSalesReturnOrderClient.ItemListTaxAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region DONT_CALCULATE_ROW

&AtClient
Procedure ItemListDontCalculateRowOnChange(Item)
	DocSalesReturnOrderClient.ItemListDontCalculateRowOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region STORE

&AtClient
Procedure ItemListStoreOnChange(Item)
	DocSalesReturnOrderClient.ItemListStoreOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TAX_RATE

&AtClient
Procedure TaxValueOnChange(Item) Export
	DocSalesReturnOrderClient.ItemListTaxValueOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region REVENUE_TYPE

&AtClient
Procedure ItemListRevenueTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesReturnOrderClient.ItemListRevenueTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListRevenueTypeEditTextChange(Item, Text, StandardProcessing)
	DocSalesReturnOrderClient.ItemListRevenueTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
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
	OffersClient.SpecialOffersEditFinish_ForDocument(Result, Object, ThisObject, AdditionalParameters);
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
	OffersClient.SpecialOffersEditFinish_ForRow(Result, Object, ThisObject, AdditionalParameters);
EndProcedure

#EndRegion

#EndRegion

#Region SERVICE

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocSalesReturnOrderClient);
	Str.Insert("Server", DocSalesReturnOrderServer);
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

#Region COPY_PASTE

&AtClient
Procedure CopyToClipboard(Command) Export
	
	CopySettings = CopyPasteClient.CopyToClipboard(Object, ThisObject);
	
	CopyPasteResult = CopyToClipboardServer(CopySettings);
	CopyPasteClient.AfterCopy(CopyPasteResult);
	
EndProcedure

&AtServer
Function CopyToClipboardServer(CopySettings) Export
	Return CopyPasteServer.CopyToClipboard(Object, ThisObject, CopySettings);
EndFunction

&AtClient
Procedure PasteFromClipboard(Command) Export
	PasteSettings = CopyPasteClient.PasteFromClipboard(Object, ThisObject);
	CopyPasteResult = PasteFromClipboardServer(PasteSettings);
	CopyPasteClient.AfterPaste(Object, ThisObject,CopyPasteResult);
EndProcedure

&AtServer
Function PasteFromClipboardServer(CopySettings) Export
	Return CopyPasteServer.PasteFromClipboard(Object, ThisObject, CopySettings);
EndFunction

#EndRegion

#Region COMMANDS

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
Procedure DecorationStatusHistoryClick(Item)
	ObjectStatusesClient.OpenHistoryByStatus(Object.Ref, ThisObject);
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
	FormParameters.Insert("Filter", RowIDInfoClientServer.GetLinkedDocumentsFilter_SRO(Object));
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
	FormParameters.Insert("Filter", RowIDInfoClientServer.GetLinkedDocumentsFilter_SRO(Object));
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
EndProcedure

&AtServer
Function AddOrLinkUnlinkDocumentRowsContinueAtServer(Result)
	ExtractedData = Undefined;
	If Result.Operation = "LinkUnlinkDocumentRows" Then
		LinkedResult = RowIDInfoServer.LinkUnlinkDocumentRows(Object, Result.FillingValues);
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

#EndRegion
