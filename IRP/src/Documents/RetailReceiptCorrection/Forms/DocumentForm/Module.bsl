
#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocRetailReceiptCorrectionServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocRetailReceiptCorrectionServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
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
	DocRetailReceiptCorrectionServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocRetailReceiptCorrectionClient.OnOpen(Object, ThisObject, Cancel);
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
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	DocRetailReceiptCorrectionClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
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
	If Form.UnlockForm Then
		Form.ReadOnly = False;
	Else
		Form.ReadOnly = DocConsolidatedRetailSalesServer.IsClosedRetailDocument(Object.Ref);
	EndIf;
	
	Form.Items.LegalName.Enabled = ValueIsFilled(Object.Partner);
	
	UseConsolidatedRetailSales = DocConsolidatedRetailSalesServer.UseConsolidatedRetailSales(Object.Branch);
	
	Form.Items.ConsolidatedRetailSales.ReadOnly = Not UseConsolidatedRetailSales;
	
	Form.Items.ConsolidatedRetailSales.MarkIncomplete = 
		Not ValueIsFilled(Object.ConsolidatedRetailSales)
		And UseConsolidatedRetailSales;
	
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
	Form.Items.GroupCorrectionData.Visible = Not TypeOf(Object.BasisDocument) = Type("DocumentRef.RetailReceiptCorrection");
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
Procedure UnlockForm(Command)
	UnlockForm = Not UnlockForm;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

#EndRegion

#Region _DATE

&AtClient
Procedure DateOnChange(Item)
	DocRetailReceiptCorrectionClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocRetailReceiptCorrectionClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocRetailReceiptCorrectionClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocRetailReceiptCorrectionClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region PARTNER

&AtClient
Procedure PartnerOnChange(Item)
	DocRetailReceiptCorrectionClient.PartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocRetailReceiptCorrectionClient.PartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PartnerEditTextChange(Item, Text, StandardProcessing)
	DocRetailReceiptCorrectionClient.PartnerTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region LEGAL_NAME

&AtClient
Procedure LegalNameOnChange(Item)
	DocRetailReceiptCorrectionClient.LegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure LegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocRetailReceiptCorrectionClient.LegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure LegalNameEditTextChange(Item, Text, StandardProcessing)
	DocRetailReceiptCorrectionClient.LegalNameTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region AGREEMENT

&AtClient
Procedure AgreementOnChange(Item)
	DocRetailReceiptCorrectionClient.AgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocRetailReceiptCorrectionClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AgreementEditTextChange(Item, Text, StandardProcessing)
	DocRetailReceiptCorrectionClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region CURRENCY

&AtClient
Procedure CurrencyOnChange(Item)
	DocRetailReceiptCorrectionClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region STORE

&AtClient
Procedure StoreOnChange(Item)
	DocRetailReceiptCorrectionClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region LEGAL_NAME_CONTRACT

&AtClient
Procedure LegalNameContractOnChange(Item)
	DocRetailReceiptCorrectionClient.LegalNameContractOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PRICE_INCLUDE_TAX

&AtClient
Procedure PriceIncludeTaxOnChange(Item)
	DocRetailReceiptCorrectionClient.PriceIncludeTaxOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region RETAIL_CUSTOMER

&AtClient
Procedure RetailCustomerOnChange(Item)
	DocRetailReceiptCorrectionClient.RetailCustomerOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region CONSOLIDATED_RETAIL_SALES

&AtClient
Procedure ConsolidatedRetailSalesOnChange(Item)
	DocRetailReceiptCorrectionClient.ConsolidatedRetailSalesOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region WORKSTATION

&AtClient
Procedure WorkstationOnChange(Item)
	DocRetailReceiptCorrectionClient.WorkstationOnChange(Object, ThisObject, Item);	
EndProcedure

#EndRegion

#Region BRANCH

&AtClient
Procedure BranchOnChange(Item)
	DocRetailReceiptCorrectionClient.BranchOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region BASIS_DOCUMENT
&AtClient
Procedure BasisDocumentOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);
	If TypeOf(Object.BasisDocument) = Type("DocumentRef.RetailReceiptCorrection") Then
		Object.CorrectionDescription = "";
		Object.CorrectionType = 0;
		Object.NumberTaxAuthorityPrescription = "";
		Object.BasisDocumentFiscalNumber = "";
	EndIf; 
EndProcedure
#EndRegion

#Region ITEM_LIST

&AtClient
Procedure ItemListSelection(Item, RowSelected, Field, StandardProcessing)
	DocRetailReceiptCorrectionClient.ItemListSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocRetailReceiptCorrectionClient.ItemListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);	
EndProcedure

&AtClient
Procedure ItemListBeforeDeleteRow(Item, Cancel)
	DocRetailReceiptCorrectionClient.ItemListBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocRetailReceiptCorrectionClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListOnStartEdit(Item, NewRow, Clone)
	If Item.CurrentItem.Name = "ItemListControlCodeStringState" Then
		ItemListControlCodeStringStateClick();
	EndIf;
EndProcedure

#Region ITEM_LIST_COLUMNS

#Region _ITEM

&AtClient
Procedure ItemListItemOnChange(Item)
	DocRetailReceiptCorrectionClient.ItemListItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocRetailReceiptCorrectionClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocRetailReceiptCorrectionClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ITEM_KEY

&AtClient
Procedure ItemListItemKeyOnChange(Item)
	DocRetailReceiptCorrectionClient.ItemListItemKeyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PRICE_TYPE

&AtClient
Procedure ItemListPriceTypeOnChange(Item)
	DocRetailReceiptCorrectionClient.ItemListPriceTypeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region UNIT

&AtClient
Procedure ItemListUnitOnChange(Item)
	DocRetailReceiptCorrectionClient.ItemListUnitOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region QUANTITY

&AtClient
Procedure ItemListQuantityOnChange(Item, AddInfo = Undefined) Export
	DocRetailReceiptCorrectionClient.ItemListQuantityOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region QUANTITY_IN_BASE_UNIT

&AtClient
Procedure ItemListQuantityInBaseUnitOnChange(Item)
	DocRetailReceiptCorrectionClient.ItemListQuantityInBaseUnitOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region QUANTITY_IS_FIXED

&AtClient
Procedure ItemListQuantityIsFixedOnChange(Item)
	DocRetailReceiptCorrectionClient.ItemListQuantityIsFixedOnChange(Object, ThisObject, Item);	
EndProcedure

#EndRegion

#Region PRICE

&AtClient
Procedure ItemListPriceOnChange(Item, AddInfo = Undefined) Export
	DocRetailReceiptCorrectionClient.ItemListPriceOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TOTAL_AMOUNT

&AtClient
Procedure ItemListTotalAmountOnChange(Item)
	DocRetailReceiptCorrectionClient.ItemListTotalAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TAX_AMOUNT

&AtClient
Procedure ItemListTaxAmountOnChange(Item)
	DocRetailReceiptCorrectionClient.ItemListTaxAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region DONT_CALCULATE_ROW

&AtClient
Procedure ItemListDontCalculateRowOnChange(Item)
	DocRetailReceiptCorrectionClient.ItemListDontCalculateRowOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region STORE

&AtClient
Procedure ItemListStoreOnChange(Item)
	DocRetailReceiptCorrectionClient.ItemListStoreOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region VAT_RATE

&AtClient
Procedure ItemListVatRateOnChange(Item) Export
	DocRetailReceiptCorrectionClient.ItemListVatRateOnChange(Object, ThisObject, Item);
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
	DocRetailReceiptCorrectionClient.ItemListRevenueTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListRevenueTypeEditTextChange(Item, Text, StandardProcessing)
	DocRetailReceiptCorrectionClient.ItemListRevenueTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
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
	OffersClient.OpenFormPickupSpecialOffers_ForRow(Object, Items.ItemList.CurrentData, ThisObject, "SpecialOffersEditFinish_ForRow");
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

#Region PAYMENT_TYPE

&AtClient
Procedure PaymentsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocRetailReceiptCorrectionClient.PaymentsBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure PaymentsPaymentTypeOnChange(Item)
	DocRetailReceiptCorrectionClient.PaymentsPaymentTypeOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentsBankTermOnChange(Item)
	DocRetailReceiptCorrectionClient.PaymentsBankTermOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentsAmountOnChange(Item)
	DocRetailReceiptCorrectionClient.PaymentsAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentsPercentOnChange(Item)
	DocRetailReceiptCorrectionClient.PaymentsPercentOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentsCommissionOnChange(Item)
	DocRetailReceiptCorrectionClient.PaymentsCommissionOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentsAccountOnChange(Item)
	DocRetailReceiptCorrectionClient.PaymentsAccountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region SERVICE

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocRetailReceiptCorrectionClient);
	Str.Insert("Server", DocRetailReceiptCorrectionServer);
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
Procedure EditQuantityInBaseUnit(Command)
	Items.ItemListQuantityInBaseUnit.Visible = Not Items.ItemListQuantityInBaseUnit.Visible;
	Items.ItemListQuantityIsFixed.Visible = Not Items.ItemListQuantityIsFixed.Visible;	 	
EndProcedure

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

#EndRegion

#Region CONTROL_STRINGS

&AtClient
Procedure ItemListControlCodeStringStateClick() Export
	
	CurrentData = Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If Not CurrentData.isControlCodeString Then
		Return;
	EndIf;
	
	Params = New Structure;
	Params.Insert("Hardware", CommonFunctionsServer.GetRefAttribute(Object.ConsolidatedRetailSales, "FiscalPrinter"));
	Params.Insert("RowKey", CurrentData.Key);
	Params.Insert("Item", CurrentData.Item);
	Params.Insert("ItemKey", CurrentData.ItemKey);
	//@skip-check unknown-method-property
	Params.Insert("LineNumber", CurrentData.LineNumber);
	Params.Insert("isReturn", False);
	Notify = New NotifyDescription("ItemListControlCodeStringStateOpeningEnd", ThisObject, Params);
	
	OpenForm("CommonForm.CodeStringCheck", Params, ThisObject, , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure ItemListControlCodeStringStateOpeningEnd(Result, AddInfo) Export
	
	If Result = Undefined Then
		Return;
	EndIf;
	
	Array = New Array;
	Str = New Structure;
	Str.Insert("Key", AddInfo.RowKey);
	Array.Add(Str);
	ControlCodeStringsClient.ClearAllByRow(Object, Array);
	If Result.WithoutScan Then
		CurrentRow = Object.ItemList.FindByID(Items.ItemList.CurrentRow);
		CurrentRow.isControlCodeString = False;
	Else
		For Each Row In Result.Scaned Do
			FillPropertyValues(Object.ControlCodeStrings.Add(), Row);
		EndDo;
	EndIf;
	
	ControlCodeStringsClient.UpdateState(Object);
	Modified = True;
EndProcedure

#EndRegion
