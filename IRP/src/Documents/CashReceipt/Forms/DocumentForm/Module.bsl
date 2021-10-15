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

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocCashReceiptServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability();
	EndIf;
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocCashReceiptServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability();
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters, AddInfo = Undefined) Export
	DocCashReceiptServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability();
EndProcedure

&AtClient
Procedure OnOpen(Cancel, AddInfo = Undefined) Export
	DocCashReceiptClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtServer
Procedure SetVisibilityAvailability() Export
	ArrayAll = New Array();
	ArrayByType = New Array();
	DocCashReceiptServer.FillAttributesByType(Object.TransactionType, ArrayAll, ArrayByType);
	DocumentsClientServer.SetVisibilityItemsByArray(ThisObject.Items, ArrayAll, ArrayByType);

	If Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CurrencyExchange")
		Or Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CashTransferOrder") Then
		BasedOnCashTransferOrder = False;
		For Each Row In Object.PaymentList Do
			If TypeOf(Row.PlaningTransactionBasis) = Type("DocumentRef.CashTransferOrder") And ValueIsFilled(
				Row.PlaningTransactionBasis) Then
				BasedOnCashTransferOrder = True;
				Break;
			EndIf;
		EndDo;
		ThisObject.Items.CurrencyExchange.ReadOnly = BasedOnCashTransferOrder And ValueIsFilled(Object.CurrencyExchange);
		ThisObject.Items.CashAccount.ReadOnly = BasedOnCashTransferOrder And ValueIsFilled(Object.CashAccount);
		ThisObject.Items.Company.ReadOnly 	= BasedOnCashTransferOrder And ValueIsFilled(Object.Company);
		ThisObject.Items.Currency.ReadOnly 	= BasedOnCashTransferOrder And ValueIsFilled(Object.Currency);

		ArrayTypes = New Array();
		ArrayTypes.Add(Type("DocumentRef.CashTransferOrder"));
		ThisObject.Items.PaymentListPlaningTransactionBasis.TypeRestriction = New TypeDescription(ArrayTypes);
	Else
		ArrayTypes = New Array();
		ArrayTypes.Add(Type("DocumentRef.CashTransferOrder"));
		ArrayTypes.Add(Type("DocumentRef.IncomingPaymentOrder"));
		ArrayTypes.Add(Type("DocumentRef.OutgoingPaymentOrder"));
		ThisObject.Items.PaymentListPlaningTransactionBasis.TypeRestriction = New TypeDescription(ArrayTypes);
	EndIf;
EndProcedure

#EndRegion

#Region ItemPaymentList

&AtClient
Procedure PaymentListOnChange(Item)
	DocCashReceiptClient.PaymentListOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListOnActivateRow(Item, AddInfo = Undefined) Export
	Return;
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
	DocCashReceiptClient.PaymentListBasisDocumentStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListBasisDocumentOnChange(Item, AddInfo = Undefined) Export
	DocCashReceiptClient.PaymentListBasisDocumentOnChange(Object, ThisObject, Item);
EndProcedure
&AtClient
Procedure PaymentListAmountOnChange(Item, AddInfo = Undefined) Export
	DocumentsClient.CalculateTotalAmount(Object, ThisObject);
EndProcedure

&AtClient
Procedure PaymentListPlaningTransactionBasisOnChange(Item, AddInfo = Undefined) Export
	DocCashReceiptClient.PaymentListPlaningTransactionBasisOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPlaningTransactionBasisStartChoice(Item, ChoiceData, StandardProcessing, AddInfo = Undefined)
	DocCashReceiptClient.TransactionBasisStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListOnActivateCell(Item, AddInfo = Undefined) Export
	DocCashReceiptClient.OnActiveCell(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListBeforeRowChange(Item, Cancel)
	DocCashReceiptClient.OnActiveCell(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure PaymentListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocCashReceiptClient.PaymentListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashReceiptClient.PaymentListMovementTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeEditTextChange(Item, Text, StandardProcessing)
	DocCashReceiptClient.PaymentListMovementTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#Region Partner

&AtClient
Procedure PaymentListPartnerOnChange(Item, AddInfo = Undefined) Export
	DocCashReceiptClient.PaymentListPartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashReceiptClient.PaymentListPartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListPartnerEditTextChange(Item, Text, StandardProcessing)
	DocCashReceiptClient.PaymentListPartnerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region Payer

&AtClient
Procedure PaymentListPayerOnChange(Item, AddInfo = Undefined) Export
	DocCashReceiptClient.PaymentListPayerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPayerStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashReceiptClient.PaymentListPayerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListPayerEditTextChange(Item, Text, StandardProcessing)
	DocCashReceiptClient.PaymentListPayerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region Agreement

&AtClient
Procedure PaymentListAgreementOnChange(Item, AddInfo = Undefined) Export
	DocCashReceiptClient.PaymentListAgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashReceiptClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListAgreementEditTextChange(Item, Text, StandardProcessing)
	DocCashReceiptClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#EndRegion

#Region ItemCompany

&AtClient
Procedure CompanyOnChange(Item, AddInfo = Undefined) Export
	DocCashReceiptClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashReceiptClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocCashReceiptClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemDate

&AtClient
Procedure DateOnChange(Item, AddInfo = Undefined) Export
	DocCashReceiptClient.DateOnChange(Object, ThisObject, Item);
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
	DocCashReceiptClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CurrencyOnChangeContinue(Answer, AdditionalParameters) Export
	If Answer = DialogReturnCode.Yes Then
		// delete rows with cash transfers
		ClearCashTransferOrders(Object.Currency);
		CurrentCurrency = Object.Currency;
		DocCashReceiptClient.CurrencyOnChange(Object, ThisObject, Items.Currency);
		Notify("CallbackHandler", Undefined, ThisObject);
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
	DocCashReceiptClient.AccountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AccountOnChangeContinue(Answer, AdditionalParameters) Export
	If Answer = DialogReturnCode.Yes Then
		CurrentAccount = Object.CashAccount;
		DocCashReceiptClient.AccountOnChange(Object, ThisObject, Items.Currency);
		ClearCashTransferOrders(Object.Currency);
		Notify("CallbackHandler", Undefined, ThisObject);
	Else
		Object.CashAccount = CurrentAccount;
	EndIf;
EndProcedure

&AtClient
Procedure AccountStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashReceiptClient.AccountStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CashAccountEditTextChange(Item, Text, StandardProcessing)
	DocCashReceiptClient.AccountEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemTransactionTypeOnChange

&AtClient
Procedure TransactionTypeOnChange(Item, AddInfo = Undefined) Export
	SetVisibilityAvailability();
	DocCashReceiptClient.TransactionTypeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ItemDescription

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocCashReceiptClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocCashReceiptClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocCashReceiptClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocCashReceiptClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocCashReceiptClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
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