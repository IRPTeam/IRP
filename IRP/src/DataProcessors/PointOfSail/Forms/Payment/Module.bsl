
&AtClient
Procedure Cash(Command)
	PaymentFilter = New Structure;
	PaymentFilter.Insert("PaymentType", PredefinedValue("Enum.PaymentTypes.Cash"));
	FoundPayment = Payments.FindRows(PaymentFilter);
	FoundPayment[0].Amount = Object.Amount;
	ReturnValue = New Structure;
	ReturnValue.Insert("Payments", Payments);
	Close(ReturnValue);
EndProcedure

&AtClient
Procedure Card(Command)
	PaymentFilter = New Structure;
	PaymentFilter.Insert("PaymentType", PredefinedValue("Enum.PaymentTypes.Card"));
	FoundPayment = Payments.FindRows(PaymentFilter);
	FoundPayment[0].Amount = Object.Amount;
	ReturnValue = New Structure;
	ReturnValue.Insert("Payments", Payments);
	Close(ReturnValue);
EndProcedure

&AtClient
Procedure CloseButton(Command)
	ReturnValue = New Structure;
	ReturnValue.Insert("Payments", Payments);
	Close(ReturnValue);
EndProcedure

&AtClient
Procedure CustomerCashOnChange(Item)
	CustomerCashString = Format(Object.CustomerCash, "NG=0");
	RecalculateCashback();
EndProcedure

&AtClient
Procedure NumPress(Команда)
	ButtonValue = ThisObject.CurrentItem.Title;
	NumButtonPress(ButtonValue);
	RecalculateCashback();
EndProcedure

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
	If ButtonValue = "C" Then
		Object.CustomerCash = 0;
		CustomerCashString = Format(Object.CustomerCash, "NG=0");
		Goto ~Return;
	EndIf;
	If ButtonValue = "."
		And StrOccurrenceCount(CustomerCashString, LocalDotPresentation) Then
		Goto ~Return;
	EndIf;
	If ButtonValue = "0"
		And Not StrOccurrenceCount(CustomerCashString, LocalDotPresentation) Then
		Goto ~Return;
	EndIf;
	CustomerCashString = CustomerCashString + ButtonValue;
	Object.CustomerCash = Number(CustomerCashString);
	CustomerCashString = Format(Object.CustomerCash, "NG=0");
	~Return:
	Return;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	Object.Amount = Parameters.Parameters.Amount;
	Object.CustomerCash = Parameters.Parameters.Amount;
	
	CustomerCashString = Format(Object.CustomerCash, "NG=0");
	
	//Demo
	NewRow = POSTerminals.Add();
	NewRow.Terminal = "Ziraat Bank";
	NewRow.ConfirmTransaction = True;
	NewRow = POSTerminals.Add();
	NewRow.Terminal = "Garanti Bank";
	NewRow.ConfirmTransaction = False;
	
	NewRow = Payments.Add();
	NewRow.PaymentType = Enums.PaymentTypes.Cash;
	For Each POSTerminal In POSTerminals Do
		NewRow = Payments.Add();
		NewRow.PaymentType = Enums.PaymentTypes.Card;
		NewRow.Terminal = POSTerminal.Terminal;
	EndDo;	
	NewRow = Payments.Add();
	NewRow.PaymentType = Enums.PaymentTypes.LoyalityPoint;
	
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	RecalculateCashback();
EndProcedure


