Procedure OnCreateAtServer(Cancel, StandardProcessing, Form, Parameters) Export
	If Parameters.Property("FormTitle") Then
		Form.Title = Parameters.FormTitle;
		Form.AutoTitle = False;
	EndIf;
EndProcedure

Function GetCashAccountInfo(CashAccount) Export
	Return Catalogs.CashAccounts.GetCashAccountInfo(CashAccount);
EndFunction
