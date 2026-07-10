
#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocSalesInvoiceServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	ThisObject.DocStorno = DocStornoServer.IsDocumentWithStorno(Object.Ref);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocSalesInvoiceServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
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
	DocSalesInvoiceServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocSalesInvoiceClient.OnOpen(Object, ThisObject, Cancel);
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
	DocSalesInvoiceClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
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
	IsTransactionType_Sales = 
		Object.TransactionType = PredefinedValue("Enum.SalesTransactionTypes.Sales");
		
	IsTransactionType_CurrencyRevaluationCustomer = 
		Object.TransactionType = PredefinedValue("Enum.SalesTransactionTypes.CurrencyRevaluationCustomer");
		
	IsTransactionType_CurrencyRevaluationVendor = 
		Object.TransactionType = PredefinedValue("Enum.SalesTransactionTypes.CurrencyRevaluationVendor");
	
	Form.Items.AddBasisDocuments.Enabled = Not Form.ReadOnly;
	Form.Items.LinkUnlinkBasisDocuments.Enabled = Not Form.ReadOnly;
	Form.Items.LegalName.Enabled = ValueIsFilled(Object.Partner);
	Form.Items.GroupAging.Visible = IsTransactionType_Sales;
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
	
	ArrayOfOrders = New Array();
	For Each Row In Object.ItemList Do
		If ValueIsFilled(Row.SalesOrder) Then
			ArrayOfOrders.Add(New Structure("Key, DocOrder", Row.Key, Row.SalesOrder));
		EndIf;
	EndDo;
	ClosedRowKeys = DocOrderClosingServer.GetIsClosedSalesOrderInItemList(ArrayOfOrders);
	For Each Row In Form.Object.ItemList Do
			Row.IsClosedOrder = ClosedRowKeys.Find(Row.Key) <> Undefined;
	EndDo;
	
	If IsTransactionType_CurrencyRevaluationCustomer Then
		Form.Items.CurrencyRevaluationInvoice.TypeRestriction = New TypeDescription("DocumentRef.SalesInvoice");
	ElsIf IsTransactionType_CurrencyRevaluationVendor Then
		Form.Items.CurrencyRevaluationInvoice.TypeRestriction = New TypeDescription("DocumentRef.PurchaseInvoice");
	EndIf;
	
	ExternalOffers = GetExternalOffers(Object);
	For Each Row In Form.Object.SpecialOffers Do
		Row.ExternalOffer = False;
		For Each ExternalOfferKey In ExternalOffers Do
			If Row.Key = ExternalOfferKey Then
				Row.ExternalOffer = True;
			EndIf;
		EndDo;
	EndDo;
	
	If Not Form.ReadOnly Then
		Form.ReadOnly = ValueIsFilled(Form.DocStorno);
	EndIf;
	Form.Items.GroupHeadStorno.Visible = ValueIsFilled(Form.DocStorno);

	ArrayOfClosingOrders = DocOrderClosingServer.GetArrayOfClosingOrders(Object.Ref);
	Form.Items.Date.ReadOnly = (ArrayOfClosingOrders.Count() > 0);
	Form.Items.EditDate.Visible = (ArrayOfClosingOrders.Count() > 0);
EndProcedure

&AtServerNoContext
Function GetExternalOffers(val _Object)
	ArrayOfKeys = New Array();
	For Each Row_SpecialOffer In _Object.SpecialOffers Do               
		Rows_RowIDInfo = _Object.RowIDInfo.FindRows(New Structure("Key", Row_SpecialOffer.Key));
		For Each Row_RowIDInfo In Rows_RowIDInfo Do
			If ValueIsFilled(Row_RowIDInfo.BasisKey)
				And ValueIsFilled(Row_RowIDInfo.Basis)
				And (TypeOf(Row_RowIDInfo.Basis) = Type("DocumentRef.SalesOrder") 
					Or TypeOf(Row_RowIDInfo.Basis) = Type("DocumentRef.PurchaseOrder")) Then
				OrderRows = Row_RowIDInfo.Basis.SpecialOffers.FindRows(New Structure("Key", Row_RowIDInfo.BasisKey));
				For Each OrderRow In OrderRows Do
					If OrderRow.Offer = Row_SpecialOffer.Offer And ArrayOfKeys.Find(Row_SpecialOffer.Key) = Undefined Then
						ArrayOfKeys.Add(Row_SpecialOffer.Key);
					EndIf;
				EndDo; 
			EndIf;
		EndDo;
	EndDo;
	Return ArrayOfKeys;
EndFunction

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
	DocSalesInvoiceClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocSalesInvoiceClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesInvoiceClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocSalesInvoiceClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ACCOUNT
	
&AtClient
Procedure AccountOnChange(Item)
	DocSalesInvoiceClient.AccountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AccountStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	DocSalesInvoiceClient.AccountStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AccountEditTextChange(Item, Text, StandardProcessing)
	DocSalesInvoiceClient.AccountEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region TRANSACTION_TYPE

&AtClient
Procedure TransactionTypeOnChange(Item)
	DocSalesInvoiceClient.TransactionTypeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PARTNER

&AtClient
Procedure PartnerOnChange(Item)
	DocSalesInvoiceClient.PartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesInvoiceClient.PartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PartnerEditTextChange(Item, Text, StandardProcessing)
	DocSalesInvoiceClient.PartnerTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region LEGAL_NAME

&AtClient
Procedure LegalNameOnChange(Item)
	DocSalesInvoiceClient.LegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure LegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesInvoiceClient.LegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure LegalNameEditTextChange(Item, Text, StandardProcessing)
	DocSalesInvoiceClient.LegalNameTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region AGREEMENT

&AtClient
Procedure AgreementOnChange(Item)
	DocSalesInvoiceClient.AgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesInvoiceClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AgreementEditTextChange(Item, Text, StandardProcessing)
	DocSalesInvoiceClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region CURRENCY

&AtClient
Procedure CurrencyOnChange(Item)
	DocSalesInvoiceClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure
	
#EndRegion

#Region STORE

&AtClient
Procedure StoreOnChange(Item)
	DocSalesInvoiceClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region DELIVERY_DATE

&AtClient
Procedure DeliveryDateOnChange(Item)
	DocSalesInvoiceClient.DeliveryDateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region LEGAL_NAME_CONTRACT

&AtClient
Procedure LegalNameContractOnChange(Item)
	DocSalesInvoiceClient.LegalNameContractOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PRICE_INCLUDE_TAX

&AtClient
Procedure PriceIncludeTaxOnChange(Item)
	DocSalesInvoiceClient.PriceIncludeTaxOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ITEM_LIST

&AtClient
Procedure ItemListSelection(Item, RowSelected, Field, StandardProcessing)
	DocSalesInvoiceClient.ItemListSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocSalesInvoiceClient.ItemListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter)
EndProcedure

&AtClient
Procedure ItemListBeforeDeleteRow(Item, Cancel)
	DocSalesInvoiceClient.ItemListBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocSalesInvoiceClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
	LockLinkedRows();
EndProcedure

#Region ITEM_LIST_COLUMNS

#Region _ITEM

&AtClient
Procedure ItemListItemOnChange(Item)
	DocSalesInvoiceClient.ItemListItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesInvoiceClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocSalesInvoiceClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ITEM_KEY

&AtClient
Procedure ItemListItemKeyOnChange(Item)
	DocSalesInvoiceClient.ItemListItemKeyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PRICE_TYPE

&AtClient
Procedure ItemListPriceTypeOnChange(Item)
	DocSalesInvoiceClient.ItemListPriceTypeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region UNIT

&AtClient
Procedure ItemListUnitOnChange(Item)
	DocSalesInvoiceClient.ItemListUnitOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region QUANTITY

&AtClient
Procedure ItemListQuantityOnChange(Item)
	DocSalesInvoiceClient.ItemListQuantityOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region QUANTITY_IN_BASE_UNIT

&AtClient
Procedure ItemListQuantityInBaseUnitOnChange(Item)
	DocSalesInvoiceClient.ItemListQuantityInBaseUnitOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region QUANTITY_IS_FIXED

&AtClient
Procedure ItemListQuantityIsFixedOnChange(Item)
	DocSalesInvoiceClient.ItemListQuantityIsFixedOnChange(Object, ThisObject, Item);	
EndProcedure

#EndRegion

#Region PRICE

&AtClient
Procedure ItemListPriceOnChange(Item)
	DocSalesInvoiceClient.ItemListPriceOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TOTAL_AMOUNT

&AtClient
Procedure ItemListTotalAmountOnChange(Item)
	DocSalesInvoiceClient.ItemListTotalAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TAX_AMOUNT

&AtClient
Procedure ItemListTaxAmountOnChange(Item)
	DocSalesInvoiceClient.ItemListTaxAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region MANUAL_OFFER

&AtClient
Procedure ItemListManualOfferTypeOnChange(Item)
	DocSalesInvoiceClient.ItemListManualOfferTypeOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListManualOfferPercentOnChange(Item)
	DocSalesInvoiceClient.ItemListManualOfferPercentOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListManualOfferAmountOnChange(Item)
	DocSalesInvoiceClient.ItemListManualOfferAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region DONT_CALCULATE_ROW

&AtClient
Procedure ItemListDontCalculateRowOnChange(Item)
	DocSalesInvoiceClient.ItemListDontCalculateRowOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region STORE

&AtClient
Procedure ItemListStoreOnChange(Item)
	DocSalesInvoiceClient.ItemListStoreOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region DELIVERY_DATE

&AtClient
Procedure ItemListDeliveryDateOnChange(Item)
	DocSalesInvoiceClient.ItemListDeliveryDateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region VAT_RATE

&AtClient
Procedure ItemListVatRateOnChange(Item) Export
	DocSalesInvoiceClient.ItemListVatRateOnChange(Object, ThisObject, Item);
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
	DocSalesInvoiceClient.ItemListRevenueTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListRevenueTypeEditTextChange(Item, Text, StandardProcessing)
	DocSalesInvoiceClient.ItemListRevenueTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region PAYMENT_TERMS

&AtClient
Procedure PaymentTermsDateOnChange(Item)
	DocSalesInvoiceClient.PaymentTermsDateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentTermsOnChange(Item)
	DocSalesInvoiceClient.PaymentTermsOnChange(Object, ThisObject, Item);
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
Procedure LinkedDocuments_ShipmentConfirmations(Command)
	DocumentsClient.OpenLinkedDocuments(Object, ThisObject, "ShipmentConfirmations", "ShipmentConfirmation", "QuantityInShipmentConfirmation");
EndProcedure

&AtClient
Procedure LinkedDocuments_ShipmentPlaningOrders(Command)
	DocumentsClient.OpenLinkedDocuments(Object, ThisObject, "ShipmentPlaningOrders", "ShipmentPlaningOrder", "QuantityInShipmentPlaningOrder");
EndProcedure

&AtClient
Procedure LinkedDocuments_WorkSheets(Command)
	DocumentsClient.OpenLinkedDocuments(Object, ThisObject, "WorkSheets", "WorkSheet", "QuantityInWorkSheet");
EndProcedure

#EndRegion

#Region SERVICE

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocSalesInvoiceClient);
	Str.Insert("Server", DocSalesInvoiceServer);
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

//@skip-check module-unused-method
&AtClient
Async Procedure PasteFromClipboardValues(Command)
	ClipBoardText = Await CopyPasteClient.TextFromClipBoard(ClipboardDataStandardFormat.Text);		
	CopyPasteClient.RecalculateRowsByNewValues(Object, ThisObject, ClipBoardText);	
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

&AtClient
Async Procedure SplitRow(Command)
	NewRow = Await DocSalesInvoiceClient.ItemListSplitRow(Object, ThisObject);
	If NewRow <> Undefined Then
		SplitRowAtServer();
	EndIf;
EndProcedure

&AtServer
Procedure SplitRowAtServer()
	RowIDInfoServer.LockLinkedRows(Object, ThisObject);
EndProcedure

#EndRegion

#Region LINKED_DOCUMENTS

&AtClient
Procedure LinkUnlinkBasisDocuments(Command)
	FormParameters = New Structure();
	FormParameters.Insert("Filter", RowIDInfoClientServer.GetLinkedDocumentsFilter_SI(Object));
	FormParameters.Insert("SelectedRowInfo", RowIDInfoClient.GetSelectedRowInfo(Items.ItemList.CurrentData));
	FormParameters.Insert("TablesInfo", RowIDInfoClient.GetTablesInfo(Object));
	RowIDInfoClient.OpenForm_LinkUnlinkDocumentRows(Object, ThisObject, FormParameters);
EndProcedure

&AtClient
Procedure AddBasisDocuments(Command)
	FormParameters = New Structure();
	FormParameters.Insert("Filter", RowIDInfoClientServer.GetLinkedDocumentsFilter_SI(Object));
	FormParameters.Insert("TablesInfo", RowIDInfoClient.GetTablesInfo(Object));
	RowIDInfoClient.OpenForm_AddLinkedDocumentRows(Object, ThisObject, FormParameters);
EndProcedure

&AtClient
Procedure AddOrLinkUnlinkDocumentRowsContinue(Result, NotifyParameters) Export
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
			NumberingRulesServer.GetNumeratorGroupForDocument(Object.Ref.Metadata().FullName(), Object.Date);
	EndIf;
	NumberingRulesServer.SetSourceNewNumber(Object);
EndProcedure

&AtClient
Procedure EditDateClick(Item)
	Callback = New CallbackDescription("EditDateClickEnd", ThisObject);
	OpenForm("CommonForm.EditOrderClosingDate", New Structure("DocRef", Object.Ref), 
		ThisObject,,,,Callback, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure EditDateClickEnd(Result, Params) Export
	If Result <> Undefined And Result.Success Then
		ThisObject.Read();
	EndIf;	
EndProcedure

#EndRegion
