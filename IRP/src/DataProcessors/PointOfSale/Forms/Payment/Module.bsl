
#Region Events

#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	FillPaymentTypes();
	ChangeEnabledDigitButtons();
	
	Object.Amount = Parameters.Parameters.Amount;
	
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	
EndProcedure

&AtClient
Procedure PaymentsAfterDeleteRow(Item)
	ChangeEnabledDigitButtons();
EndProcedure

&AtClient
Procedure PaymentsOnChange(Item)
	CalculatePaymentsAmountTotal();
EndProcedure

&AtClient
Procedure PaymentsOnActivateRow(Item)
	CurrentData = Items.Payments.CurrentData;
	If CurrentData <> Undefined Then
		CurrentData.Edited = False;
	EndIf;
EndProcedure
	
#EndRegion

#Region Commands

&AtClient
Procedure Enter(Command)
	If PaymentsAmountTotal <> (Object.Amount + Object.Cashback) Then
		Return;
	EndIf;
	ReturnValue = New Structure;
	ReturnValue.Insert("Payments", Payments);
	Close(ReturnValue);
EndProcedure

&AtClient
Procedure CloseButton(Command)
	Payments.Clear();
	ReturnValue = New Structure;
	ReturnValue.Insert("Payments", Payments);
	Close(ReturnValue);
EndProcedure

&AtClient
Procedure Cash(Command)
	If CashPaymentTypes.Count() > 1 Then
		NotifyParameters = New Structure;
		NotifyDescription = New NotifyDescription("CashChoiceEnd", ThisObject, NotifyParameters, , );
		PayButtons = New ValueList();
		For Each CollectionItem In CashPaymentTypes Do
			PayButtons.Add("Button" + Format(CashPaymentTypes.IndexOf(CollectionItem), "NG=0;"), CollectionItem.Description);
		EndDo;
		OpeningFormParameters = New Structure;
		OpeningFormParameters.Insert("PayButtons", PayButtons);
		OpenForm("DataProcessor.PointOfSale.Form.PaymentTypes", , ThisObject, UUID, , , NotifyDescription, FormWindowOpeningMode.LockWholeInterface);
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
		NotifyDescription = New NotifyDescription("CardChoiceEnd", ThisObject, NotifyParameters, , );
		PayButtons = New ValueList();
		For Each CollectionItem In BankPaymentTypes Do
			PayButtons.Add("Button" + Format(BankPaymentTypes.IndexOf(CollectionItem), "NG=0;"), CollectionItem.Description);
		EndDo;
		OpeningFormParameters = New Structure;
		OpeningFormParameters.Insert("PayButtons", PayButtons);
		OpenForm("DataProcessor.PointOfSale.Form.PaymentTypes", , ThisObject, UUID, , , NotifyDescription, FormWindowOpeningMode.LockWholeInterface);
	Else
		ChoiceEndResult = 0;
		ChoiceEndAdditionalParameters = New Structure;
		CardChoiceEnd(ChoiceEndResult, ChoiceEndAdditionalParameters);
	EndIf;
EndProcedure

&AtClient
Procedure LoyalityPoints(Command)
	If (Object.Amount - Payments.Total("Amount")) <= 0 Then
		RemainingAmount = 0;
	Else
		RemainingAmount = Object.Amount - Payments.Total("Amount");
	EndIf;
	PaymentFilter = New Structure;
	PaymentFilter.Insert("PaymentType", PredefinedValue("Enum.PaymentTypes.LoyalityPoint"));
	FoundPayment = Payments.FindRows(PaymentFilter);
	If FoundPayment.Count() Then
		Row = FoundPayment[0];
	Else
		Row = Payments.Add();
		Row.PaymentType = PredefinedValue("Enum.PaymentTypes.LoyalityPoint");
	EndIf;
	Row.AmountString = Format(RemainingAmount, "NG=0;");
	Row.Amount = RemainingAmount;
	Items.Payments.CurrentRow = Row.GetID();
	ChangeEnabledDigitButtons();
	CalculatePaymentsAmountTotal();
EndProcedure

&AtClient
Procedure Certificate(Command)
	Return;
EndProcedure

&AtClient
Procedure NumPress(Command)
	ButtonValue = ThisObject.CurrentItem.Title;
	NumButtonPress(ButtonValue);
EndProcedure

#EndRegion

#EndRegion

#Region Internal

&AtServer
Procedure ChangeEnabledDigitButtons()
	If Payments.Count() Then
		Enabled = True;
	Else
		Enabled = False;
	EndIf;
	Items.__0.Enabled = Enabled;
	Items.__1.Enabled = Enabled;
	Items.__2.Enabled = Enabled;
	Items.__3.Enabled = Enabled;
	Items.__4.Enabled = Enabled;
	Items.__5.Enabled = Enabled;
	Items.__6.Enabled = Enabled;
	Items.__7.Enabled = Enabled;
	Items.__8.Enabled = Enabled;
	Items.__9.Enabled = Enabled;
	Items.__Dot.Enabled = Enabled;
	Items.__C.Enabled = Enabled;
EndProcedure

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
			CashbackValue = PaymentCashAmount - (PaymentsAmountTotal - Object.Amount);
	Else
		CashbackValue = 0;
	EndIf;
	Object.Cashback = CashbackValue;
EndProcedure
	
&AtClient
Procedure NumButtonPress(ButtonValue)
	LocalDotPresentation = ".";
	CurrentData = Items.Payments.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If Not CurrentData.Edited Then
		CurrentData.Amount = 0;
		CurrentData.AmountString = "";
		CurrentData.Edited = True;
	EndIf;
	If ButtonValue = "."
		And StrOccurrenceCount(CurrentData.AmountString, LocalDotPresentation) Then
		Return;
	EndIf;
	If ButtonValue = "0"
		And Left(CurrentData.AmountString, 1) = "0"
		And Not StrOccurrenceCount(CurrentData.AmountString, LocalDotPresentation) Then
		Return;
	EndIf;
	If ButtonValue = "C" Then
		CurrentData.AmountString = "0";		
	Else
		If Left(CurrentData.AmountString, 1) = "0"
			And Not StrOccurrenceCount(CurrentData.AmountString, LocalDotPresentation)
			And Not ButtonValue = "." Then
			CurrentData.AmountString = "";
		EndIf;		
		CurrentData.AmountString = CurrentData.AmountString + ButtonValue;
	EndIf;
	CurrentData.Amount = Number(CurrentData.AmountString);
	CalculatePaymentsAmountTotal();	
EndProcedure

&AtClient
Procedure FillPaymentTypes()
	FillPaymentsAtServer();
EndProcedure

&AtServer
Procedure FillPaymentsAtServer()
	Query = New Query;
	Query.Text = "SELECT
	|	PaymentTypes.Ref AS PaymentType,
	|	PaymentTypes.Description_en AS Description
	|FROM
	|	Catalog.PaymentTypes AS PaymentTypes
	|WHERE
	|	PaymentTypes.Type = VALUE(Enum.PaymentTypes.Cash)
	|	AND NOT PaymentTypes.DeletionMark";
	CashPaymentTypesValue = Query.Execute().Unload();
	ValueToFormAttribute(CashPaymentTypesValue, "CashPaymentTypes");
	
	Query = New Query;
	Query.Text = "SELECT
	|	StoreBankTerms.BankTerm
	|INTO StoreBankTerms
	|FROM
	|	InformationRegister.StoreBankTerms AS StoreBankTerms
	|WHERE
	|	StoreBankTerms.Store = &Store
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	PaymentTypes.PaymentType,
	|	PaymentTypes.Description_en AS Description,
	|	PaymentTypes.Ref AS BankTerm,
	|	PaymentTypes.Ref.Account,
	|	PaymentTypes.Ref.Percent
	|FROM
	|	PaymentTypes AS PaymentTypes";
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
	If (Object.Amount - Payments.Total("Amount")) <= 0 Then
		RemainingAmount = 0;
	Else
		RemainingAmount = Object.Amount - Payments.Total("Amount");
	EndIf;
	PaymentFilter = New Structure;
	PaymentFilter.Insert("PaymentType", BankPaymentTypes.Get(Result).PaymentType);
	PaymentFilter.Insert("BankTerm", BankPaymentTypes.Get(Result).BankTerm);
	FoundPayment = Payments.FindRows(PaymentFilter);
	If FoundPayment.Count() Then
		Row = FoundPayment[0];
	Else
		Row = Payments.Add();
		Row.PaymentType = PaymentFilter.PaymentType;
		Row.BankTerm = PaymentFilter.BankTerm;		
		Row.PaymentTypeEnum = PredefinedValue("Enum.PaymentTypes.Card");
	EndIf;
	Row.AmountString = Format(RemainingAmount, "NG=0;");
	Row.Amount = RemainingAmount;
	Items.Payments.CurrentRow = Row.GetID();
	ChangeEnabledDigitButtons();
	CalculatePaymentsAmountTotal();
EndProcedure

&AtClient
Procedure CashChoiceEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	If (Object.Amount - Payments.Total("Amount")) <= 0 Then
		RemainingAmount = 0;
	Else
		RemainingAmount = Object.Amount - Payments.Total("Amount");
	EndIf;
	PaymentFilter = New Structure;
	PaymentFilter.Insert("PaymentType", CashPaymentTypes.Get(Result).PaymentType);
	FoundPayment = Payments.FindRows(PaymentFilter);
	If FoundPayment.Count() Then
		Row = FoundPayment[0];
	Else
		Row = Payments.Add();
		Row.PaymentType = PaymentFilter.PaymentType;
		Row.PaymentTypeEnum = PredefinedValue("Enum.PaymentTypes.Cash");
	EndIf;
	Row.AmountString = Format(RemainingAmount, "NG=0;");
	Row.Amount = RemainingAmount;
	Items.Payments.CurrentRow = Row.GetID();
	ChangeEnabledDigitButtons();
	CalculatePaymentsAmountTotal();
EndProcedure

#EndRegion

