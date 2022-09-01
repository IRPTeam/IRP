Procedure OnCreateAtServer(Cancel, StandardProcessing, Form, Parameters) Export
	If Parameters.Property("FormTitle") Then
		Form.Title = Parameters.FormTitle;
		Form.AutoTitle = False;
	EndIf;
EndProcedure

Function GetCashAccountInfo(CashAccount) Export
	Return Catalogs.CashAccounts.GetCashAccountInfo(CashAccount);
EndFunction

Procedure RemoveUnusedAccountTypes(Form, FormAttributeName) Export
	ArrayForDelete = New Array();
	
	If Not FOServer.IsUseBankDocuments() Then
		For Each ListItem In Form.Items[FormAttributeName].ChoiceList Do
			
			If Not ValueIsFilled(ListItem.Value) 
				Or ListItem.Value = Enums.CashAccountTypes.Cash
				Or ListItem.Value = Enums.CashAccountTypes.POS 
				Or ListItem.Value = Enums.CashAccountTypes.POSCashAccount Then
				Continue;
			EndIf;
			
			ArrayForDelete.Add(ListItem);
			
		EndDo;
	EndIf;
	
	If Not FOServer.IsUseConsolidatedRetailSales() Then
		For Each ListItem In Form.Items[FormAttributeName].ChoiceList Do
			If ListItem.Value = Enums.CashAccountTypes.POSCashAccount Then
				ArrayForDelete.Add(ListItem);
			EndIf;
		EndDo;
	EndIf;
	
	For Each ArrayItem In ArrayForDelete Do
		Form.Items[FormAttributeName].ChoiceList.Delete(ArrayItem);
	EndDo;	
EndProcedure
