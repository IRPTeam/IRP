
#Region Variables

&AtClient 
Var AmountFractionDigitsCount, AmountDotIsActive, AmountFractionDigitsMaxCount, AmountWholeDigitsMaxCount;

#EndRegion

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)		
	Object.Amount = Parameters.Parameters.Amount;
	Object.Branch = Parameters.Parameters.Branch;
	Object.Workstation = Parameters.Parameters.Workstation;
	FillPaymentTypes();	
EndProcedure

&AtServer
Procedure FillCheckProcessingAtServer(Cancel, CheckedAttributes)
	ErrorMessages = New Array;
	
	If PaymentsAmountTotal < Object.Amount Then
		ErrorMessages.Add(R().POS_s1);
	EndIf;
	
	PaymentsValue = FormAttributeToValue("Payments");
	CashPaymentFilter = New Structure();
	CashPaymentFilter.Insert("PaymentTypeEnum", Enums.PaymentTypes.Cash);
	CashAmounts = PaymentsValue.Copy(CashPaymentFilter, "Amount");
	CashAmount = CashAmounts.Total("Amount");
	CardPaymentFilter = New Structure();
	CardPaymentFilter.Insert("PaymentTypeEnum", Enums.PaymentTypes.Card);
	CardAmounts = PaymentsValue.Copy(CardPaymentFilter, "Amount");
	CardAmount = CardAmounts.Total("Amount");
	If CardAmount > Object.Amount Then
		ErrorMessages.Add(R().POS_s2);
	EndIf;
	If CardAmount = Object.Amount
		And CashAmount Then
		ErrorMessages.Add(R().POS_s3);
	EndIf;
		
	If Not ErrorMessages.Count()
		And PaymentsAmountTotal <> (Object.Amount + Object.Cashback) Then
		ErrorMessages.Add(R().POS_s4);		
	EndIf;
	
	If ErrorMessages.Count() Then
		Cancel = True;
		For Each ErrorMessage In ErrorMessages Do
			CommonFunctionsClientServer.ShowUsersMessage(ErrorMessage);
		EndDo;
	EndIf;
	
EndProcedure

#EndRegion

#Region FormTableItemsEventHandlers

&AtClient
Procedure PaymentsOnChange(Item)
	CalculatePaymentsAmountTotal();
	FormatPaymentsAmountStringRows();
EndProcedure

&AtClient
Procedure PaymentsOnActivateRow(Item)
	CurrentData = Items.Payments.CurrentData;
	If CurrentData <> Undefined Then
		CurrentData.Edited = False;
		CurrentData.AmountString = GetAmountString(CurrentData.Amount);
	EndIf;
EndProcedure
	
#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure Enter(Command)
	If Not Payments.Count()
		And CashPaymentTypes.Count() Then
		Result = 0;
		AdditionalParameters = New Structure;
		CashChoiceEnd(Result, AdditionalParameters);
	EndIf;
	If Not CheckFilling() Then
		Return;
	EndIf;		
	If Object.Cashback Then
		Row = Payments.Add();
		Row.PaymentType = CashPaymentTypes[0].PaymentType;
		Row.PaymentTypeEnum = PredefinedValue("Enum.PaymentTypes.Cash");
		Row.Account = CashPaymentTypes[0].Account;
		Row.Amount = - Object.Cashback;
	EndIf;
	ReturnValue = New Structure;
	ReturnValue.Insert("Payments", Payments);
	Close(ReturnValue);
EndProcedure

&AtClient
Procedure CloseButton(Command)
	Close();
EndProcedure

&AtClient
Procedure Cash(Command)
	If CashPaymentTypes.Count() > 1 Then
		NotifyParameters = New Structure;
		NotifyDescription = New NotifyDescription("CashChoiceEnd", ThisObject, NotifyParameters);
		PayButtons = New ValueList();
		For Each CollectionItem In CashPaymentTypes Do
			PayButtons.Add("Button" + Format(CashPaymentTypes.IndexOf(CollectionItem), "NZ=0; NLZ=0; NG=0;"), CollectionItem.Description);
		EndDo;
		OpeningFormParameters = New Structure;
		OpeningFormParameters.Insert("PayButtons", PayButtons);
		OpenForm("DataProcessor.PointOfSale.Form.PaymentTypes"
					, OpeningFormParameters
					, ThisObject
					, UUID
					, 
					, 
					, NotifyDescription
					, FormWindowOpeningMode.LockWholeInterface);
	Else
		ChoiceEndResult = 0;
		ChoiceEndAdditionalParameters = New Structure;
		CashChoiceEnd(ChoiceEndResult, ChoiceEndAdditionalParameters);
	EndIf;
EndProcedure

&AtClient
Procedure Card(Command)	
	If BankPaymentTypes.Count() > 1 Then
		NotifyParameters = New Structure;
		NotifyDescription = New NotifyDescription("CardChoiceEnd", ThisObject, NotifyParameters);
		PayButtons = New ValueList();
		For Each CollectionItem In BankPaymentTypes Do
			PayButtons.Add("Button" + Format(BankPaymentTypes.IndexOf(CollectionItem), "NZ=0; NLZ=0; NG=0;"), CollectionItem.Description);
		EndDo;
		OpeningFormParameters = New Structure;
		OpeningFormParameters.Insert("PayButtons", PayButtons);
		OpenForm("DataProcessor.PointOfSale.Form.PaymentTypes"
					, OpeningFormParameters
					, ThisObject
					, UUID
					, 
					, 
					, NotifyDescription
					, FormWindowOpeningMode.LockWholeInterface);
	Else
		ChoiceEndResult = 0;
		ChoiceEndAdditionalParameters = New Structure;
		CardChoiceEnd(ChoiceEndResult, ChoiceEndAdditionalParameters);
	EndIf;
EndProcedure

&AtClient
Procedure Certificate(Command)
	Return;
EndProcedure

&AtClient
Procedure NumPress(Command)
	If Not Payments.Count()
		And CashPaymentTypes.Count() Then
		Result = 0;
		AdditionalParameters = New Structure;
		CashChoiceEnd(Result, AdditionalParameters);
	EndIf;
	NumButtonPress(Command.Name);
	CurrentItem = Items.Enter;
EndProcedure

#EndRegion

#Region Private

&AtClient
Procedure CalculatePaymentsAmountTotal()
	PaymentsAmountTotal = Payments.Total("Amount");
	CashFilter = New Structure;
	CashFilter.Insert("PaymentTypeEnum", PredefinedValue("Enum.PaymentTypes.Cash"));
	CashRows = Payments.FindRows(CashFilter);
	PaymentCashAmount = 0;
	For Each CashRow In CashRows Do
		PaymentCashAmount = PaymentCashAmount + CashRow.Amount;
	EndDo;
	If PaymentsAmountTotal > Object.Amount
		And PaymentsAmountTotal - Object.Amount <= PaymentCashAmount Then
			CashbackValue = PaymentsAmountTotal - Object.Amount;
	Else
		CashbackValue = 0;
	EndIf;
	Object.Cashback = CashbackValue;
EndProcedure

&AtClient
Procedure FormatPaymentsAmountStringRows()
	For Each Row In Payments Do
		Row.AmountString = GetAmountString(Row.Amount);
	EndDo;
EndProcedure
	
&AtClient
Procedure NumButtonPress(CommandName)
	CurrentData = Items.Payments.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If Not CurrentData.Edited Then
		CurrentData.Amount = 0;
		CurrentData.Edited = True;
		AmountDotIsActive = False;
		AmountFractionDigitsCount = 0;
	EndIf;
	
	ButtonValue = StrReplace(CommandName, "Numpad", "");
	
	If ButtonValue = "Dot" Then
		ProcessDotButtonPress(CurrentData);
	ElsIf ButtonValue = "0" Then
		ProcessZeroButtonPress(CurrentData);
	ElsIf ButtonValue = "Backspace" Then
		ProcessBackspaceButtonPress(CurrentData);
	ElsIf ButtonValue = "Clear" Then
		ProcessClearButtonPress(CurrentData);
	Else
		ProcessDigitButtonPress(CurrentData, ButtonValue);
	EndIf;
	
	If AmountDotIsActive Then
		If AmountFractionDigitsCount Then
			NFDValue = "NFD=" + String(AmountFractionDigitsCount) + ";";
			AmountString = Format(CurrentData.Amount, NFDValue);
		Else
			AmountString = String(CurrentData.Amount) + Mid(String(0.1), 2, 1);
		EndIf;
	Else
		AmountString = String(CurrentData.Amount);
	EndIf;
	CurrentData.AmountString = AmountString;
	CalculatePaymentsAmountTotal();	
EndProcedure

&AtClient
Procedure ProcessDotButtonPress(CurrentData)
	If Not AmountDotIsActive Then
		AmountDotIsActive = True;
		AmountFractionDigitsCount = 0;
	EndIf;
EndProcedure

&AtClient
Procedure ProcessZeroButtonPress(CurrentData)
	Ten = 10;
	If AmountDotIsActive Then
		If (AmountFractionDigitsCount + 1) < AmountFractionDigitsMaxCount Then
			AmountFractionDigitsCount = AmountFractionDigitsCount + 1;
		EndIf;
	Else
		CurrentData.Amount = CurrentData.Amount * Ten;
	EndIf;
EndProcedure

&AtClient
Procedure ProcessBackspaceButtonPress(CurrentData)
	Ten = 10;
	If AmountDotIsActive Then
		If AmountFractionDigitsCount Then
			AmountFractionDigitsCount = AmountFractionDigitsCount - 1;
			AmountFractionDigits = CurrentData.Amount - Int(CurrentData.Amount);
			AmountValue = Int(AmountFractionDigits * Pow(Ten, AmountFractionDigitsCount)) / Pow(Ten, AmountFractionDigitsCount);
			CurrentData.Amount = Int(CurrentData.Amount) + AmountValue;
		Else
			AmountDotIsActive = False;
		EndIf;
	Else
		If Int(CurrentData.Amount / Ten) Then
			CurrentData.Amount = Int(CurrentData.Amount / Ten);
		Else
			CurrentData.Amount = 0;
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure ProcessClearButtonPress(CurrentData)
	CurrentData.Amount = 0;
	CurrentData.Edited = False;
	AmountDotIsActive = False;
	AmountFractionDigitsCount = 0;
EndProcedure

&AtClient
Procedure ProcessDigitButtonPress(CurrentData, Val ButtonValue)
	Ten = 10;
	CurrentAmountValue = CurrentData.Amount;
	If AmountDotIsActive Then
		If AmountFractionDigitsCount < AmountFractionDigitsMaxCount Then
			CurrentData.Amount = CurrentData.Amount + Number(ButtonValue) / Pow(Ten, AmountFractionDigitsCount + 1);
			AmountFractionDigitsCount = AmountFractionDigitsCount + 1;
		EndIf;
	Else
		CurrentData.Amount = CurrentData.Amount * Ten + Number(ButtonValue);
		If (CurrentAmountValue * Ten + Number(ButtonValue)) <> CurrentData.Amount Then
			CurrentData.Amount = CurrentAmountValue;
		EndIf;
	EndIf;
EndProcedure

&AtServer
Procedure FillPaymentTypes()
	FillPaymentsAtServer();
EndProcedure

&AtServer
Procedure FillPaymentsAtServer()
	Query = New Query;
	Query.Text = "SELECT
	|	PaymentTypes.Ref AS PaymentType,
	|	PaymentTypes.Description_en AS Description,
	|	&CashAccount AS Account
	|FROM
	|	Catalog.PaymentTypes AS PaymentTypes
	|WHERE
	|	PaymentTypes.Type = VALUE(Enum.PaymentTypes.Cash)
	|	AND NOT PaymentTypes.DeletionMark";
	Query.SetParameter("CashAccount", Object.Workstation.CashAccount);
	CashPaymentTypesValue = Query.Execute().Unload();
	ValueToFormAttribute(CashPaymentTypesValue, "CashPaymentTypes");
	
	Query = New Query;
	Query.Text = "SELECT
	|	BranchBankTerms.BankTerm
	|FROM
	|	InformationRegister.BranchBankTerms AS BranchBankTerms
	|WHERE
	|	BranchBankTerms.Branch = &Branch";
	Query.SetParameter("Branch", Object.Branch);
	QueryUnload = Query.Execute().Unload();
	BankTerms = QueryUnload.UnloadColumn("BankTerm");
	
	Query = New Query;
	Query.Text = "SELECT
	|	PaymentTypes.PaymentType,
	|	PaymentTypes.PaymentType.Description_en AS Description,
	|	PaymentTypes.Ref AS BankTerm,
	|	PaymentTypes.Account,
	|	PaymentTypes.Percent
	|FROM
	|	Catalog.BankTerms.PaymentTypes AS PaymentTypes
	|WHERE
	|	PaymentTypes.Ref In (&BankTerms)";
	Query.SetParameter("BankTerms", BankTerms);
	BankPaymentTypesValue = Query.Execute().Unload();
	ValueToFormAttribute(BankPaymentTypesValue, "BankPaymentTypes");
	
	Items.Cash.Enabled = CashPaymentTypes.Count();
	Items.Card.Enabled = BankPaymentTypes.Count();
	
EndProcedure

&AtClient
Procedure CardChoiceEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	PaymentFilter = New Structure;
	PaymentFilter.Insert("PaymentType", BankPaymentTypes.Get(Result).PaymentType);
	PaymentFilter.Insert("BankTerm", BankPaymentTypes.Get(Result).BankTerm);
	FoundPayment = Payments.FindRows(PaymentFilter);
	If FoundPayment.Count() Then
		Row = FoundPayment[0];
		Row.Amount = 0;
	Else
		Row = Payments.Add();
		Row.PaymentType = PaymentFilter.PaymentType;
		Row.BankTerm = PaymentFilter.BankTerm;		
		Row.PaymentTypeEnum = PredefinedValue("Enum.PaymentTypes.Card");
		Row.Account = BankPaymentTypes.Get(Result).Account;
		Row.Percent = BankPaymentTypes.Get(Result).Percent;
	EndIf;
	If (Object.Amount - Payments.Total("Amount")) <= 0 Then
		RemainingAmount = 0;
	Else
		RemainingAmount = Object.Amount - Payments.Total("Amount");
	EndIf;
	Row.Amount = RemainingAmount;
	Items.Payments.CurrentRow = Row.GetID();
	Items.Payments.CurrentData.Edited = False;
	CurrentItem = Items.Enter;
	CalculatePaymentsAmountTotal();
	FormatPaymentsAmountStringRows();
EndProcedure

&AtClient
Procedure CashChoiceEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	PaymentFilter = New Structure;
	PaymentFilter.Insert("PaymentType", CashPaymentTypes.Get(Result).PaymentType);
	FoundPayment = Payments.FindRows(PaymentFilter);
	If FoundPayment.Count() Then
		Row = FoundPayment[0];
		Row.Amount = 0;
	Else
		Row = Payments.Add();
		Row.PaymentType = PaymentFilter.PaymentType;
		Row.PaymentTypeEnum = PredefinedValue("Enum.PaymentTypes.Cash");
		Row.Account = CashPaymentTypes.Get(Result).Account;
	EndIf;
	If (Object.Amount - Payments.Total("Amount")) <= 0 Then
		RemainingAmount = 0;
	Else
		RemainingAmount = Object.Amount - Payments.Total("Amount");
	EndIf;
	Row.Amount = RemainingAmount;
	Row.AmountString = GetAmountString(Row.Amount);
	Items.Payments.CurrentRow = Row.GetID();
	Items.Payments.CurrentData.Edited = False;
	CurrentItem = Items.Enter;
	CalculatePaymentsAmountTotal();
	FormatPaymentsAmountStringRows();
EndProcedure

&AtClient
Function GetAmountString(Val AmountValue)
	Return Format(AmountValue, "NFD=" + Format(AmountFractionDigitsMaxCount, "NG=0;"));
EndFunction

&AtClient
Procedure OnOpen(Cancel)
	FillVars();
EndProcedure

&AtClient
Procedure FillVars()
	AmountFractionDigitsCount = 0;
	AmountDotIsActive = False;
	AmountFractionDigitsMaxCount = GetFractionDigitsMaxCount();
	AmountWholeDigitsMaxCount = GetWholeDigitsMaxCount();
EndProcedure

&AtServerNoContext
Function GetFractionDigitsMaxCount()
	Return Metadata.DefinedTypes.typeAmount.Type.NumberQualifiers.FractionDigits;
EndFunction

&AtServerNoContext
Function GetWholeDigitsMaxCount()
	Return Metadata.DefinedTypes.typeAmount.Type.NumberQualifiers.Digits - Metadata.DefinedTypes.typeAmount.Type.NumberQualifiers.FractionDigits;
EndFunction

#EndRegion

