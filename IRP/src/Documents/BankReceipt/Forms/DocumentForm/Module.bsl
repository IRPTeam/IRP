#Region FormEvents

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel, AddInfo = Undefined) Export
	DocBankReceiptClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
	DocBankReceiptServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocBankReceiptServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters, AddInfo = Undefined) Export
	DocBankReceiptServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	ArrayAll = New Array();
	ArrayByType = New Array();
	DocBankReceiptServer.FillAttributesByType(Object.TransactionType, ArrayAll, ArrayByType);
	DocumentsClientServer.SetVisibilityItemsByArray(Form.Items, ArrayAll, ArrayByType);

	If Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CurrencyExchange")
		Or Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CashTransferOrder")
		Or Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.TransferFromPOS") Then
		BasedOnCashTransferOrder = False;
		For Each Row In Object.PaymentList Do
			If TypeOf(Row.PlaningTransactionBasis) = Type("DocumentRef.CashTransferOrder") And ValueIsFilled(
				Row.PlaningTransactionBasis) Then
				BasedOnCashTransferOrder = True;
				Break;
			EndIf;
		EndDo;
		Form.Items.CurrencyExchange.ReadOnly = BasedOnCashTransferOrder And ValueIsFilled(Object.CurrencyExchange);
		Form.Items.Account.ReadOnly = BasedOnCashTransferOrder And ValueIsFilled(Object.Account);
		Form.Items.Company.ReadOnly = BasedOnCashTransferOrder And ValueIsFilled(Object.Company);
		Form.Items.Currency.ReadOnly = BasedOnCashTransferOrder And ValueIsFilled(Object.Currency);

		ArrayTypes = New Array();
		If Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.TransferFromPOS") Then
			ArrayTypes.Add(Type("DocumentRef.CashStatement"));
		Else
			ArrayTypes.Add(Type("DocumentRef.CashTransferOrder"));
		EndIf;
		Form.Items.PaymentListPlaningTransactionBasis.TypeRestriction = New TypeDescription(ArrayTypes);
	Else
		ArrayTypes = New Array();
		ArrayTypes.Add(Type("DocumentRef.CashTransferOrder"));
		ArrayTypes.Add(Type("DocumentRef.IncomingPaymentOrder"));
		ArrayTypes.Add(Type("DocumentRef.OutgoingPaymentOrder"));
		Form.Items.PaymentListPlaningTransactionBasis.TypeRestriction = New TypeDescription(ArrayTypes);
	EndIf;
	Form.Items.EditCurrencies.Enabled = Not Form.ReadOnly;
EndProcedure

#EndRegion

#Region ItemPaymentList

&AtClient
Procedure PaymentListOnChange(Item)
	DocBankReceiptClient.PaymentListOnChange(Object, ThisObject, Item);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure PaymentListOnActivateRow(Item, AddInfo = Undefined) Export
	DocBankReceiptClient.PaymentListOnActivateRow(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListOnStartEdit(Item, NewRow, Clone, AddInfo = Undefined) Export
	DocumentsClient.PaymentListOnStartEdit(Object, ThisObject, Item, NewRow, Clone);
EndProcedure

&AtClient
Procedure PaymentListAfterDeleteRow(Item)
	DocumentsClient.CalculateTotalAmount(Object, ThisObject);
EndProcedure

&AtClient
Procedure PaymentListBasisDocumentStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.PaymentListBasisDocumentStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListBasisDocumentOnChange(Item, AddInfo = Undefined) Export
	DocBankReceiptClient.PaymentListBasisDocumentOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListAmountOnChange(Item, AddInfo = Undefined) Export
	DocumentsClient.CalculateTotalAmount(Object, ThisObject);
EndProcedure

&AtClient
Procedure PaymentListPlaningTransactionBasisOnChange(Item, AddInfo = Undefined) Export
	DocBankReceiptClient.PaymentListPlaningTransactionBasisOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPlaningTransactionBasisStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.TransactionBasisStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListOnActivateCell(Item, AddInfo = Undefined) Export
	DocBankReceiptClient.OnActiveCell(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListBeforeRowChange(Item, Cancel)
	DocBankReceiptClient.OnActiveCell(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure PaymentListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocBankReceiptClient.PaymentListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure PaymentListExpenseTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.PaymentListExpenseTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListExpenseTypeEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.PaymentListExpenseTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.PaymentListFinancialMovementTypeStartChoice(Object, ThisObject, Item, ChoiceData,
		StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.PaymentListFinancialMovementTypeEditTextChange(Object, ThisObject, Item, Text,
		StandardProcessing);
EndProcedure

#Region ItemPartner

&AtClient
Procedure PaymentListPartnerOnChange(Item, AddInfo = Undefined) Export
	DocBankReceiptClient.PaymentListPartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.PaymentListPartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListPartnerEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.PaymentListPartnerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region Payer

&AtClient
Procedure PaymentListPayerOnChange(Item, AddInfo = Undefined) Export
	DocBankReceiptClient.PaymentListPayerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPayerStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.PaymentListPayerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListPayerEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.PaymentListPayerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region Agreement

&AtClient
Procedure PaymentListAgreementOnChange(Item, AddInfo = Undefined) Export
	DocBankReceiptClient.PaymentListAgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListAgreementEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#EndRegion

#Region ItemCompany

&AtClient
Procedure CompanyOnChange(Item, AddInfo = Undefined) Export
	DocBankReceiptClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemDate

&AtClient
Procedure DateOnChange(Item, AddInfo = Undefined) Export
	DocBankReceiptClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ItemCurrency

&AtClient
Procedure CurrencyOnChange(Item, AddInfo = Undefined) Export
	If CashTransferOrdersInPaymentList(Object.Currency) And Object.Currency <> CurrentCurrency Then
		ShowQueryBox(New NotifyDescription("CurrencyOnChangeContinue", ThisObject), R().QuestionToUser_008,
			QuestionDialogMode.YesNoCancel);
		Return;
	EndIf;
	DocBankReceiptClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CurrencyOnChangeContinue(Answer, AdditionalParameters) Export
	If Answer = DialogReturnCode.Yes Then
		// delete rows with cash transfers
		ClearCashTransferOrders(Object.Currency);
		CurrentCurrency = Object.Currency;
		DocBankReceiptClient.CurrencyOnChange(Object, ThisObject, Items.Currency);
		Notify("CalculationStrngsComplete", Undefined, ThisObject);
	Else
		Object.Currency = CurrentCurrency;
	EndIf;
EndProcedure

#EndRegion

#Region ItemAccount

&AtClient
Procedure AccountOnChange(Item, AddInfo = Undefined) Export
	AccountCurrency = ServiceSystemServer.GetObjectAttribute(Object.Account, "Currency");
	If CashTransferOrdersInPaymentList(AccountCurrency) And AccountCurrency <> CurrentCurrency Then
		ShowQueryBox(New NotifyDescription("AccountOnChangeContinue", ThisObject), R().QuestionToUser_008,
			QuestionDialogMode.YesNoCancel);
		Return;
	EndIf;
	DocBankReceiptClient.AccountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AccountOnChangeContinue(Answer, AdditionalParameters) Export
	If Answer = DialogReturnCode.Yes Then
		CurrentAccount = Object.Account;
		DocBankReceiptClient.AccountOnChange(Object, ThisObject, Items.Currency);
		ClearCashTransferOrders(Object.Currency);
		Notify("CalculationStrngsComplete", Undefined, ThisObject);
	Else
		Object.Account = CurrentAccount;
	EndIf;
EndProcedure

&AtClient
Procedure AccountStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.AccountStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AccountEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.AccountEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemTransitAccount
&AtClient
Procedure TransitAccountStartChoice(Item, ChoiceData, StandardProcessing)
	StandardProcessing = False;
	DefaultStartChoiceParameters = New Structure("Company", Object.Company);
	StartChoiceParameters = CatCashAccountsClient.GetDefaultStartChoiceParameters(DefaultStartChoiceParameters);
	StartChoiceParameters.CustomParameters.Filters.Add(DocumentsClientServer.CreateFilterItem("Type", PredefinedValue(
		"Enum.CashAccountTypes.Transit"), , DataCompositionComparisonType.Equal));
	StartChoiceParameters.FillingData.Insert("Type", PredefinedValue("Enum.CashAccountTypes.Transit"));
	OpenForm(StartChoiceParameters.FormName, StartChoiceParameters, Item, ThisObject.UUID, , ThisObject.URL);
EndProcedure

&AtClient
Procedure TransitAccountEditTextChange(Item, Text, StandardProcessing)
	DefaultEditTextParameters = New Structure("Company", Object.Company);
	EditTextParameters = CatCashAccountsClient.GetDefaultEditTextParameters(DefaultEditTextParameters);
	EditTextParameters.Filters.Add(DocumentsClientServer.CreateFilterItem("Type", PredefinedValue(
		"Enum.CashAccountTypes.Transit"), ComparisonType.Equal));
	Item.ChoiceParameters = CatCashAccountsClient.FixedArrayOfChoiceParameters(EditTextParameters);
EndProcedure

#EndRegion

#Region ItemTransactionTypeOnChange

&AtClient
Procedure TransactionTypeOnChange(Item)
	DocBankReceiptClient.TransactionTypeOnChange(Object, ThisObject, Item);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

#EndRegion

#Region ItemDescription

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocBankReceiptClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocBankReceiptClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocBankReceiptClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocBankReceiptClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocBankReceiptClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

#Region Common

&AtClient
Procedure ClearCashTransferOrders(Val CashTransferOrderCurrency) Export
	For Each Row In Object.PaymentList Do
		If ValueIsFilled(Row.PlaningTransactionBasis) And TypeOf(Row.PlaningTransactionBasis) = Type(
			"DocumentRef.CashTransferOrder") And ServiceSystemServer.GetObjectAttribute(Row.PlaningTransactionBasis,
			"ReceiveCurrency") <> CashTransferOrderCurrency Then
			Row.PlaningTransactionBasis = Undefined;
		EndIf;
	EndDo;
EndProcedure

&AtClient
Function CashTransferOrdersInPaymentList(Val CashTransferOrderCurrency)
	Answer = False;
	For Each Row In Object.PaymentList Do
		If ValueIsFilled(Row.PlaningTransactionBasis) And TypeOf(Row.PlaningTransactionBasis) = Type(
			"DocumentRef.CashTransferOrder") And ServiceSystemServer.GetObjectAttribute(Row.PlaningTransactionBasis,
			"ReceiveCurrency") <> CashTransferOrderCurrency Then
			Answer = True;
			Break;
		EndIf;
	EndDo;
	Return Answer;
EndFunction

#EndRegion

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

&AtClient
Procedure EditCurrencies(Command)
	CurrentData = ThisObject.Items.PaymentList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V1(Object, CurrentData);
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
