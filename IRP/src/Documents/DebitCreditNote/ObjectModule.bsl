Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	
//	Parameters = CurrenciesClientServer.GetParameters_V7(ThisObject, "", ThisObject.Currency, ThisObject.Amount);
//	CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies);
//	CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	
	If Not ValueIsFilled(ThisObject.SendUUID) Then
		ThisObject.SendUUID = New UUID();
	EndIf;
	
	If Not ValueIsFilled(ThisObject.ReceiveUUID) Then
		ThisObject.ReceiveUUID = New UUID();
	EndIf;

	If Not ValueIsFilled(ThisObject.TransitUUID) Then
		ThisObject.TransitUUID = New UUID();
	EndIf;
	
	TotalTable = New ValueTable();
	TotalTable.Columns.Add("Key");
	TotalTable.Add().Key = ThisObject.SendUUID;
	TotalTable.Add().Key = ThisObject.ReceiveUUID;
	TotalTable.Add().Key = ThisObject.TransitUUID;
	
	CurrenciesClientServer.DeleteUnusedRowsFromCurrenciesTable(ThisObject.Currencies, TotalTable);
	
	Parameters = CurrenciesClientServer.GetParameters_V7(ThisObject, ThisObject.SendUUID, ThisObject.SendCurrency, ThisObject.SendAmount);
	CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, ThisObject.SendUUID);
	CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	
	Parameters = CurrenciesClientServer.GetParameters_V7(ThisObject, ThisObject.ReceiveUUID, ThisObject.ReceiveCurrency, ThisObject.ReceiveAmount);
	CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, ThisObject.ReceiveUUID);
	CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
				
	Parameters = CurrenciesClientServer.GetParameters_V7(ThisObject, ThisObject.TransitUUID, ThisObject.Currency, ThisObject.SendAmount);
	CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, ThisObject.TransitUUID);
	CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
			
	ThisObject.AdditionalProperties.Insert("WriteMode", WriteMode);
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	WriteMode = CommonFunctionsClientServer.GetFromAddInfo(ThisObject.AdditionalProperties, "WriteMode");
	If FOServer.IsUseAccounting() And WriteMode = DocumentWriteMode.Posting Then
		AccountingServer.OnWrite(ThisObject, Cancel);
	EndIf;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	
	If ThisObject.SendPartner = ThisObject.ReceivePartner And ThisObject.SendLegalName = ThisObject.ReceiveLegalName Then
				
		If (ThisObject.SendDebtType = Enums.DebtTypes.AdvanceCustomer        And ThisObject.ReceiveDebtType = Enums.DebtTypes.AdvanceVendor)
	   		Or (ThisObject.SendDebtType = Enums.DebtTypes.AdvanceCustomer     And ThisObject.ReceiveDebtType = Enums.DebtTypes.TransactionVendor)
	   		Or (ThisObject.SendDebtType = Enums.DebtTypes.TransactionCustomer And ThisObject.ReceiveDebtType = Enums.DebtTypes.AdvanceCustomer)
	   		Or (ThisObject.SendDebtType = Enums.DebtTypes.TransactionCustomer And ThisObject.ReceiveDebtType = Enums.DebtTypes.TransactionVendor)
	   		Or (ThisObject.SendDebtType = Enums.DebtTypes.AdvanceVendor       And ThisObject.ReceiveDebtType = Enums.DebtTypes.AdvanceCustomer)
	   		Or (ThisObject.SendDebtType = Enums.DebtTypes.AdvanceVendor       And ThisObject.ReceiveDebtType = Enums.DebtTypes.TransactionCustomer)
	   		Or (ThisObject.SendDebtType = Enums.DebtTypes.TransactionVendor   And ThisObject.ReceiveDebtType = Enums.DebtTypes.AdvanceVendor) Then
	   			   
	   		CommonFunctionsClientServer.ShowUsersMessage(R().Error_142, "SendDebtType", ThisObject);
	   		Cancel = True;
		EndIf;
	Else
				
		If 	(ThisObject.SendDebtType = Enums.DebtTypes.AdvanceCustomer     And ThisObject.ReceiveDebtType = Enums.DebtTypes.TransactionVendor)
	   		Or (ThisObject.SendDebtType = Enums.DebtTypes.TransactionCustomer And ThisObject.ReceiveDebtType = Enums.DebtTypes.AdvanceCustomer)
	   		Or (ThisObject.SendDebtType = Enums.DebtTypes.AdvanceVendor       And ThisObject.ReceiveDebtType = Enums.DebtTypes.AdvanceCustomer)
	   		Or (ThisObject.SendDebtType = Enums.DebtTypes.AdvanceVendor       And ThisObject.ReceiveDebtType = Enums.DebtTypes.TransactionCustomer)
	   		Or (ThisObject.SendDebtType = Enums.DebtTypes.TransactionVendor   And ThisObject.ReceiveDebtType = Enums.DebtTypes.AdvanceVendor) Then
	   
	   		CommonFunctionsClientServer.ShowUsersMessage(R().Error_142, "SendDebtType", ThisObject);
	   		Cancel = True;
	   EndIf;
	EndIf;

EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	Return;
EndProcedure
