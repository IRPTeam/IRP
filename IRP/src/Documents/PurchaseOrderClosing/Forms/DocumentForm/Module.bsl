#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocPurchaseOrderClosingServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	//Taxes_CreateFormControls();
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocPurchaseOrderClosingServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
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
	DocPurchaseOrderClosingServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocPurchaseOrderClosingClient.OnOpen(Object, ThisObject, Cancel);
	//UpdateTotalAmounts();
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
	
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;

	If Not Source = ThisObject Then
		Return;
	EndIf;

//	DocPurchaseOrderClosingClient.NotificationProcessing(Object, ThisObject, EventName, Parameter, Source);
//	
//	If Upper(EventName) = Upper("CalculationStringsComplete") Then
//		UpdateTotalAmounts();
//	EndIf;
EndProcedure

//&AtClient
//Procedure BeforeWrite(Cancel, WriteParameters)
//	Return;
//EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
//	DocPurchaseOrderClosingClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
//	Notify("WriteProcurementOrder", , ThisObject);
	NotifyChanged(Object.PurchaseOrder);
	UpdateTotalAmounts();
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
	Form.Items.LegalName.Enabled = ValueIsFilled(Object.Partner);
	Form.Items.EditCurrencies.Enabled = Not Form.ReadOnly;
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

		ArrayOfTaxesRows = Object.TaxList.FindRows(New Structure("Key", Row.Key));
		For Each RowTax In ArrayOfTaxesRows Do
			ThisObject.TotalTaxAmount = ThisObject.TotalTaxAmount + ?(RowTax.IncludeToTotalAmount, RowTax.ManualAmount,
				0);
		EndDo;

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
	DocPurchaseOrderClosingClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocPurchaseOrderClosingClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocPurchaseOrderClosingClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocPurchaseOrderClosingClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region PARTNER

&AtClient
Procedure PartnerOnChange(Item)
	DocPurchaseOrderClosingClient.PartnerOnChange(Object, ThisObject, Item);
	//SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure PartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocPurchaseOrderClosingClient.PartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PartnerEditTextChange(Item, Text, StandardProcessing)
	DocPurchaseOrderClosingClient.PartnerTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region LEGAL_NAME

&AtClient
Procedure LegalNameOnChange(Item)
	DocPurchaseOrderClosingClient.LegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure LegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocPurchaseOrderClosingClient.LegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure LegalNameEditTextChange(Item, Text, StandardProcessing)
	DocPurchaseOrderClosingClient.LegalNameTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region AGREEMENT

&AtClient
Procedure AgreementOnChange(Item)
	DocPurchaseOrderClosingClient.AgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocPurchaseOrderClosingClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AgreementEditTextChange(Item, Text, StandardProcessing)
	DocPurchaseOrderClosingClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region CURRENCY

&AtClient
Procedure CurrencyOnChange(Item)
	DocPurchaseOrderClosingClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region STORE

&AtClient
Procedure StoreOnChange(Item)
	DocPurchaseOrderClosingClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region DELIVERY_DATE

&AtClient
Procedure DeliveryDateOnChange(Item)
	DocumentsClient.DeliveryDateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PRICE_INCLUDE_TAX

&AtClient
Procedure PriceIncludeTaxOnChange(Item)
	DocPurchaseOrderClosingClient.PriceIncludeTaxOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region _NUMBER

&AtClient
Procedure NumberOnChange(Item)
	DocPurchaseOrderClosingClient.NumberOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ITEM_LIST

&AtClient
Procedure ItemListSelection(Item, RowSelected, Field, StandardProcessing)
	DocPurchaseOrderClosingClient.ItemListSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocPurchaseOrderClosingClient.ItemListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure ItemListBeforeDeleteRow(Item, Cancel)
	DocPurchaseOrderClosingClient.ItemListBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocPurchaseOrderClosingClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
	//UpdateTotalAmounts();
EndProcedure

#Region ITEM_LIST_COLUMNS

#Region _ITEM

&AtClient
Procedure ItemListItemOnChange(Item)
	DocPurchaseOrderClosingClient.ItemListItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocPurchaseOrderClosingClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocPurchaseOrderClosingClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ITEM_KEY

&AtClient
Procedure ItemListItemKeyOnChange(Item)
	DocPurchaseOrderClosingClient.ItemListItemKeyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PRICE_TYPE

&AtClient
Procedure ItemListPriceTypeOnChange(Item)
	DocPurchaseOrderClosingClient.ItemListPriceTypeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region UNIT

&AtClient
Procedure ItemListUnitOnChange(Item)
	DocPurchaseOrderClosingClient.ItemListUnitOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region QUANTITY

&AtClient
Procedure ItemListQuantityOnChange(Item)
	DocPurchaseOrderClosingClient.ItemListQuantityOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PRICE

&AtClient
Procedure ItemListPriceOnChange(Item)
	DocPurchaseOrderClosingClient.ItemListPriceOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region NET_AMOUNT

&AtClient
Procedure ItemListNetAmountOnChange(Item)
	DocPurchaseOrderClosingClient.ItemListNetAmountOnChange(Object, ThisObject, Item);
	//UpdateTotalAmounts();
EndProcedure

#EndRegion

#Region TOTAL_AMOUNT

&AtClient
Procedure ItemListTotalAmountOnChange(Item)
	DocPurchaseOrderClosingClient.ItemListTotalAmountOnChange(Object, ThisObject, Item);
//	CurrentData = Items.ItemList.CurrentData;
//	If CurrentData <> Undefined And CurrentData.DontCalculateRow Then
//		UpdateTotalAmounts();
//	EndIf;
EndProcedure

#EndRegion

#Region TAX_AMOUNT

&AtClient
Procedure ItemListTaxAmountOnChange(Item)
	DocPurchaseOrderClosingClient.ItemListTaxAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region DONT_CALCULATE_ROW

&AtClient
Procedure ItemListDontCalculateRowOnChange(Item)
	DocPurchaseOrderClosingClient.ItemListDontCalculateRowOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region STORE

&AtClient
Procedure ItemListStoreOnChange(Item)
	DocPurchaseOrderClosingClient.ItemListStoreOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TAX_RATE

&AtClient
Procedure TaxValueOnChange(Item) Export
	DocPurchaseOrderClosingClient.ItemListTaxValueOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region EXPENSE_TYPE

&AtClient
Procedure ItemListExpenseTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocPurchaseOrderClosingClient.ItemListExpenseTypeStartChoice(Object, ThisObject, Item, ChoiceData,
		StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListExpenseTypeEditTextChange(Item, Text, StandardProcessing)
	DocPurchaseOrderClosingClient.ItemListExpenseTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region CANCEL

&AtClient
Procedure ItemListCancelOnChange(Item)
	DocPurchaseOrderClosingClient.ItemListCancelOnChange(Object, ThisObject, Item);
	//UpdateTotalAmounts();
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
	//SpecialOffersEditFinishAtServer_ForDocument(Result, AdditionalParameters);
EndProcedure

//&AtServer
//Procedure SpecialOffersEditFinishAtServer_ForDocument(Result, AdditionalParameters) Export
//	DocumentsServer.FillItemList(Object);
//EndProcedure

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
	Str.Insert("Client", DocPurchaseOrderClosingClient);
	Str.Insert("Server", DocPurchaseOrderClosingServer);
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
	DocPurchaseOrderClosingClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocPurchaseOrderClosingClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocPurchaseOrderClosingClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocPurchaseOrderClosingClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
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
Procedure DecorationStatusHistoryClick(Item)
	ObjectStatusesClient.OpenHistoryByStatus(Object.Ref, ThisObject);
EndProcedure

&AtClient
Procedure OpenPickupItems(Command)
	DocPurchaseOrderClosingClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	DocPurchaseOrderClosingClient.SearchByBarcode(Barcode, Object, ThisObject);
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

