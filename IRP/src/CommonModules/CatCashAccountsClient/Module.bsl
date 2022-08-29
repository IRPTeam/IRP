#Region FormEvents

Procedure BeforeWrite(Object, Form, Cancel, WriteParameters) Export
	If Object.Type <> PredefinedValue("Enum.CashAccountTypes.Bank") Then
		Object.BankName = "";
		Object.Number = "";
	EndIf;
EndProcedure

#EndRegion
