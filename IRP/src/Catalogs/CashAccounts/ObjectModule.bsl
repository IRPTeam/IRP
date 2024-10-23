Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	If Not ThisObject.IsFolder Then
		IsBankAccount    = Type = PredefinedValue("Enum.CashAccountTypes.Bank");
		IsPOSAccount     = Type = PredefinedValue("Enum.CashAccountTypes.POS");		
		IsPOSCashAccount = Type = PredefinedValue("Enum.CashAccountTypes.POSCashAccount");
		
		If Not IsBankAccount And Not IsPOSAccount Then
			ThisObject.BankName = "";
			ThisObject.Number = "";
		EndIf;
		If Not IsBankAccount Then
			ThisObject.TransitAccount = Undefined;
		EndIf;
		If Not IsPOSAccount Then
			ThisObject.ReceiptingAccount = Undefined;
			ThisObject.Acquiring = Undefined;
		EndIf;
		If Not IsPOSCashAccount Then
			ThisObject.CashAccount = Undefined;
			ThisObject.FinancialMovementType = Undefined;
		EndIf;
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If TypeOf(FillingData) = Type("Structure") Then
		FillPropertyValues(ThisObject, FillingData);
	EndIf;
	If Not ValueIsFilled(Type) And Not ThisObject.IsFolder Then
		Type = Enums.CashAccountTypes.Cash;
	EndIf;
EndProcedure

Procedure OnCopy(CopiedObject)
	If Not ThisObject.IsFolder Then
		Acquiring = Catalogs.Hardware.EmptyRef();
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	CommonFunctionsServer.CheckUniqueDescriptions_PrivilegedCall(Cancel, ThisObject);
EndProcedure

