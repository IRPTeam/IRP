#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocRetailReturnReceiptServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocRetailReturnReceiptServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
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
	DocRetailReturnReceiptServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocRetailReturnReceiptClient.OnOpen(Object, ThisObject, Cancel);
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
	DocRetailReturnReceiptClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
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

#EndRegion

#Region _DATE

&AtClient
Procedure DateOnChange(Item)
	DocRetailReturnReceiptClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocRetailReturnReceiptClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocRetailReturnReceiptClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocRetailReturnReceiptClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region PARTNER

&AtClient
Procedure PartnerOnChange(Item)
	DocRetailReturnReceiptClient.PartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocRetailReturnReceiptClient.PartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PartnerEditTextChange(Item, Text, StandardProcessing)
	DocRetailReturnReceiptClient.PartnerTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region LEGAL_NAME

&AtClient
Procedure LegalNameOnChange(Item)
	DocRetailReturnReceiptClient.LegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure LegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocRetailReturnReceiptClient.LegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure LegalNameEditTextChange(Item, Text, StandardProcessing)
	DocRetailReturnReceiptClient.LegalNameTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region AGREEMENT

&AtClient
Procedure AgreementOnChange(Item)
	DocRetailReturnReceiptClient.AgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocRetailReturnReceiptClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AgreementEditTextChange(Item, Text, StandardProcessing)
	DocRetailReturnReceiptClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region CURRENCY

&AtClient
Procedure CurrencyOnChange(Item)
	DocRetailReturnReceiptClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region STORE

&AtClient
Procedure StoreOnChange(Item)
	DocRetailReturnReceiptClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region RETAIL_CUSTOMER

&AtClient
Procedure RetailCustomerOnChange(Item)
	DocRetailReturnReceiptClient.RetailCustomerOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region LEGAL_NAME_CONTRACT

&AtClient
Procedure LegalNameContractOnChange(Item)
	DocRetailReturnReceiptClient.LegalNameContractOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PRICE_INCLUDE_TAX

&AtClient
Procedure PriceIncludeTaxOnChange(Item)
	DocRetailReturnReceiptClient.PriceIncludeTaxOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ITEM_LIST

&AtClient
Procedure ItemListSelection(Item, RowSelected, Field, StandardProcessing)
	DocRetailReturnReceiptClient.ItemListSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocRetailReturnReceiptClient.ItemListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure ItemListBeforeDeleteRow(Item, Cancel)
	DocRetailReturnReceiptClient.ItemListBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocRetailReturnReceiptClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
	LockLinkedRows();
EndProcedure

#Region ITEM_LIST_COLUMNS

#Region _ITEM

&AtClient
Procedure ItemListItemOnChange(Item)
	DocRetailReturnReceiptClient.ItemListItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocRetailReturnReceiptClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocRetailReturnReceiptClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ITEM_KEY

&AtClient
Procedure ItemListItemKeyOnChange(Item)
	DocRetailReturnReceiptClient.ItemListItemKeyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region UNIT

&AtClient
Procedure ItemListUnitOnChange(Item)
	DocRetailReturnReceiptClient.ItemListUnitOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region QUANTITY

&AtClient
Procedure ItemListQuantityOnChange(Item)
	DocRetailReturnReceiptClient.ItemListQuantityOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PRICE

&AtClient
Procedure ItemListPriceOnChange(Item)
	DocRetailReturnReceiptClient.ItemListPriceOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TOTAL_AMOUNT

&AtClient
Procedure ItemListTotalAmountOnChange(Item) 
	DocRetailReturnReceiptClient.ItemListTotalAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TAX_AMOUNT

&AtClient
Procedure ItemListTaxAmountOnChange(Item)
	DocRetailReturnReceiptClient.ItemListTaxAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region DONT_CALCULATE_ROW

&AtClient
Procedure ItemListDontCalculateRowOnChange(Item)
	DocRetailReturnReceiptClient.ItemListDontCalculateRowOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region STORE

&AtClient
Procedure ItemListStoreOnChange(Item)
	DocRetailReturnReceiptClient.ItemListStoreOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TAX_RATE

&AtClient
Procedure TaxValueOnChange(Item) Export
	DocRetailReturnReceiptClient.ItemListTaxValueOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region SERIAL_LOT_NUMBERS

&AtClient
Procedure ItemListSerialLotNumbersPresentationStartChoice(Item, ChoiceData, StandardProcessing, AddInfo = Undefined) Export
	SerialLotNumberClient.PresentationStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListSerialLotNumbersPresentationClearing(Item, StandardProcessing)
	SerialLotNumberClient.PresentationClearing(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region REVENUE_TYPE

&AtClient
Procedure ItemListRevenueTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocRetailReturnReceiptClient.ItemListRevenueTypeStartChoice(Object, ThisObject, Item, ChoiceData,
		StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListRevenueTypeEditTextChange(Item, Text, StandardProcessing)
	DocRetailReturnReceiptClient.ItemListRevenueTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
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
	Str.Insert("Client", DocRetailReturnReceiptClient);
	Str.Insert("Server", DocRetailReturnReceiptServer);
	Return Str;
EndFunction

#Region DESCRIPTION

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocumentsClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region TITLE_DECORATIONS

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocRetailReturnReceiptClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocRetailReturnReceiptClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocRetailReturnReceiptClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocRetailReturnReceiptClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
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

#Region EXTERNAL_COMMANDS

#EndRegion

#Region COMMANDS

&AtClient
Procedure OpenPickupItems(Command)
	DocRetailReturnReceiptClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	DocRetailReturnReceiptClient.SearchByBarcode(Barcode, Object, ThisObject);
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
	FormParameters.Insert("Filter", RowIDInfoClientServer.GetLinkedDocumentsFilter_RRR(Object));
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
	FormParameters.Insert("Filter", RowIDInfoClientServer.GetLinkedDocumentsFilter_RRR(Object));
	FormParameters.Insert("TablesInfo", RowIDInfoClient.GetTablesInfo(Object));
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", ThisObject);
	OpenForm("CommonForm.AddLinkedDocumentRows", FormParameters, , , , ,
		New NotifyDescription("AddOrLinkUnlinkDocumentRowsContinue", ThisObject, NotifyParameters), 
			FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure AddOrLinkUnlinkDocumentRowsContinue(Result, AdditionalParameters) Export
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
