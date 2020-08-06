
#Region Events

#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	ChangeEnabledDigitButtons();
	
	Object.Amount = Parameters.Parameters.Amount;
	Object.CustomerCash = Parameters.Parameters.Amount;
	
	CustomerAmountString = Format(Object.CustomerCash, "NG=0");
	
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	RecalculateCashback();
EndProcedure

&AtClient
Procedure CustomerCashOnChange(Item)
	CustomerAmountString = Format(Object.CustomerCash, "NG=0");
	RecalculateCashback();
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
		CurrentData.AmountString = "0";
		CurrentData.Amount = 0;
	EndIf;
EndProcedure
	
#EndRegion

#Region Commands

&AtClient
Procedure Enter(Command)
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
	If (Object.Amount - Payments.Total("Amount")) <= 0 Then
		RemainingAmount = 0;
	Else
		RemainingAmount = Object.Amount - Payments.Total("Amount");
	EndIf;
	PaymentFilter = New Structure;
	PaymentFilter.Insert("PaymentType", PredefinedValue("Enum.PaymentTypes.Cash"));
	FoundPayment = Payments.FindRows(PaymentFilter);
	If FoundPayment.Count() Then
		Row = FoundPayment[0];
	Else
		Row = Payments.Add();
		Row.PaymentType = PredefinedValue("Enum.PaymentTypes.Cash");
		Row.Amount = RemainingAmount;
	EndIf;
	Row.AmountString = "0";
	Items.Payments.CurrentRow = Row.GetID();
	ChangeEnabledDigitButtons();
	CalculatePaymentsAmountTotal();
EndProcedure

&AtClient
Procedure Card(Command)
	If (Object.Amount - Payments.Total("Amount")) <= 0 Then
		RemainingAmount = 0;
	Else
		RemainingAmount = Object.Amount - Payments.Total("Amount");
	EndIf;
	PaymentFilter = New Structure;
	PaymentFilter.Insert("PaymentType", PredefinedValue("Enum.PaymentTypes.Card"));
	FoundPayment = Payments.FindRows(PaymentFilter);
	If FoundPayment.Count() Then
		Row = FoundPayment[0];
	Else
		Row = Payments.Add();
		Row.PaymentType = PredefinedValue("Enum.PaymentTypes.Card");
		Row.Amount = RemainingAmount;
	EndIf;
	Row.AmountString = "0";
	Items.Payments.CurrentRow = Row.GetID();
	ChangeEnabledDigitButtons();
	CalculatePaymentsAmountTotal();	
EndProcedure

&AtClient
Procedure Loyality(Command)
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
		Row.Amount = RemainingAmount;
	EndIf;
	Row.AmountString = "0";
	Items.Payments.CurrentRow = Row.GetID();
	ChangeEnabledDigitButtons();
	CalculatePaymentsAmountTotal();
EndProcedure

&AtClient
Procedure Certificate(Command)
	//TODO: Insert the handler content
EndProcedure

&AtClient
Procedure NumPress(Команда)
	ButtonValue = ThisObject.CurrentItem.Title;
	NumButtonPress(ButtonValue);
	RecalculateCashback();
EndProcedure

#EndRegion

#EndRegion

&AtClient
Procedure RecalculateCashback()
	If Object.CustomerCash > Object.Amount Then
		Object.Cashback = Object.CustomerCash - Object.Amount;
	Else
		Object.Cashback = 0;
	EndIf;
EndProcedure
	
&AtClient
Procedure NumButtonPress(ButtonValue)
	LocalDotPresentation = ".";
	CurrentData = Items.Payments.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If ButtonValue = "."
		And StrOccurrenceCount(CurrentData.AmountString, LocalDotPresentation) Then
		Return;
	EndIf;
	If ButtonValue = "0"
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

#Region Internal

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
EndProcedure

#EndRegion

