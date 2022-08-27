#Region FormEvents

Procedure BeforeWrite(Object, Form, Cancel, WriteParameters) Export
	If Object.Type <> PredefinedValue("Enum.CashAccountTypes.Bank") Then
		Object.BankName = "";
		Object.Number = "";
	EndIf;
EndProcedure

Procedure TypeOnChange(Object, Form, Item) Export
	If Object.Type = PredefinedValue("Enum.CashAccountTypes.Bank") Then
		Form.CurrencyType = "Fixed";
	Else
		Form.CurrencyType = "Multi";
		Object.TransitAccount = PredefinedValue("Catalog.CashAccounts.EmptyRef");
		Object.Number = "";
		Object.BankName = "";
	EndIf;
EndProcedure

#EndRegion
