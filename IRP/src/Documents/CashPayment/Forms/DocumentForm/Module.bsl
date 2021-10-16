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
	DocCashPaymentClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
	DocCashPaymentServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocCashPaymentServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters, AddInfo = Undefined) Export
	DocCashPaymentServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form) Export
	ArrayAll = New Array();
	ArrayByType = New Array();
	DocCashPaymentServer.FillAttributesByType(Object.TransactionType, ArrayAll, ArrayByType);
	DocumentsClientServer.SetVisibilityItemsByArray(Form.Items, ArrayAll, ArrayByType);

	If Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CurrencyExchange")
		Or Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CashTransferOrder") Then
		BasedOnCashTransferOrder = False;
		BasedOnCashTransferOrder = False;
		For Each Row In Object.PaymentList Do
			If TypeOf(Row.PlaningTransactionBasis) = Type("DocumentRef.CashTransferOrder") And ValueIsFilled(
				Row.PlaningTransactionBasis) Then
				BasedOnCashTransferOrder = True;
				Break;
			EndIf;
		EndDo;
		Form.Items.CashAccount.ReadOnly = BasedOnCashTransferOrder And ValueIsFilled(Object.CashAccount);
		Form.Items.Company.ReadOnly = BasedOnCashTransferOrder And ValueIsFilled(Object.Company);
		Form.Items.Currency.ReadOnly = BasedOnCashTransferOrder And ValueIsFilled(Object.Currency);

		ArrayTypes = New Array();
		ArrayTypes.Add(Type("DocumentRef.CashTransferOrder"));
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
	DocCashPaymentClient.PaymentListOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListBasisDocumentStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashPaymentClient.PaymentListBasisDocumentStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListBasisDocumentOnChange(Item, AddInfo = Undefined) Export
	DocCashPaymentClient.PaymentListBasisDocumentOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListAmountOnChange(Item, AddInfo = Undefined) Export
	DocumentsClient.CalculateTotalAmount(Object, ThisObject);
EndProcedure

&AtClient
Procedure PaymentListPlaningTransactionBasisOnChange(Item, AddInfo = Undefined) Export
	DocCashPaymentClient.PaymentListPlaningTransactionBasisOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPlaningTransactionBasisStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashPaymentClient.TransactionBasisStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListOnActivateCell(Item, AddInfo = Undefined)
	DocCashPaymentClient.OnActiveCell(Object, ThisObject, Item);
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
Procedure PaymentListBeforeRowChange(Item, Cancel)
	DocCashPaymentClient.OnActiveCell(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure PaymentListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocCashPaymentClient.PaymentListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashPaymentClient.PaymentListFinancialMovementTypeStartChoice(Object, ThisObject, Item, ChoiceData,
		StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeEditTextChange(Item, Text, StandardProcessing)
	DocCashPaymentClient.PaymentListFinancialMovementTypeEditTextChange(Object, ThisObject, Item, Text,
		StandardProcessing);
EndProcedure

#Region Partner

&AtClient
Procedure PaymentListPartnerOnChange(Item, AddInfo = Undefined) Export
	DocCashPaymentClient.PaymentListPartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashPaymentClient.PaymentListPartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListPartnerEditTextChange(Item, Text, StandardProcessing)
	DocCashPaymentClient.PaymentListPartnerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region Payee
&AtClient
Procedure PaymentListPayeeEditTextChange(Item, Text, StandardProcessing)
	DocCashPaymentClient.PaymentListPayeeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListPayeeOnChange(Item, AddInfo = Undefined) Export
	DocCashPaymentClient.PaymentListPayeeOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPayeeStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashPaymentClient.PaymentListPayeeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

#EndRegion

#Region Agreement

&AtClient
Procedure PaymentListAgreementOnChange(Item, AddInfo = Undefined) Export
	DocCashPaymentClient.PaymentListAgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashPaymentClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListAgreementEditTextChange(Item, Text, StandardProcessing)
	DocCashPaymentClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#EndRegion

#Region ItemCompany

&AtClient
Procedure CompanyOnChange(Item, AddInfo = Undefined) Export
	DocCashPaymentClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashPaymentClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocCashPaymentClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemDate

&AtClient
Procedure DateOnChange(Item, AddInfo = Undefined) Export
	DocCashPaymentClient.DateOnChange(Object, ThisObject, Item);
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
	DocCashPaymentClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CurrencyOnChangeContinue(Answer, AdditionalParameters) Export
	If Answer = DialogReturnCode.Yes Then
		// delete rows with cash transfers
		ClearCashTransferOrders(Object.Currency);
		CurrentCurrency = Object.Currency;
		DocCashPaymentClient.CurrencyOnChange(Object, ThisObject, Items.Currency);
	Else
		Object.Currency = CurrentCurrency;
	EndIf;
EndProcedure
#EndRegion

#Region ItemAccount

&AtClient
Procedure AccountOnChange(Item, AddInfo = Undefined) Export
	AccountCurrency = ServiceSystemServer.GetObjectAttribute(Object.CashAccount, "Currency");
	If CashTransferOrdersInPaymentList(AccountCurrency) And AccountCurrency <> CurrentCurrency Then
		ShowQueryBox(New NotifyDescription("AccountOnChangeContinue", ThisObject), R().QuestionToUser_008,
			QuestionDialogMode.YesNoCancel);
		Return;
	EndIf;
	DocCashPaymentClient.AccountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AccountOnChangeContinue(Answer, AdditionalParameters) Export
	If Answer = DialogReturnCode.Yes Then
		CurrentAccount = Object.CashAccount;
		DocCashPaymentClient.AccountOnChange(Object, ThisObject, Items.Currency);
		ClearCashTransferOrders(Object.Currency);
	Else
		Object.CashAccount = CurrentAccount;
	EndIf;
EndProcedure

&AtClient
Procedure AccountStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashPaymentClient.AccountStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CashAccountEditTextChange(Item, Text, StandardProcessing)
	DocCashPaymentClient.AccountEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemTransactionTypeOnChange

&AtClient
Procedure TransactionTypeOnChange(Item, AddInfo = Undefined) Export
	SetVisibilityAvailability(Object, ThisObject);
	DocCashPaymentClient.TransactionTypeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ItemDescription

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocCashPaymentClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocCashPaymentClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocCashPaymentClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocCashPaymentClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocCashPaymentClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
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
			"SendCurrency") <> CashTransferOrderCurrency Then
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
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , ,Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure
