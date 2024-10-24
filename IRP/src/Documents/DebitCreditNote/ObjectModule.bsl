Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
		
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
	
	If CurrenciesServer.NeedUpdateCurrenciesTable(ThisObject) Then
		
		CurrenciesClientServer.DeleteUnusedRowsFromCurrenciesTable(ThisObject.Currencies, TotalTable);
		
		Parameters = CurrenciesClientServer.GetParameters_V7(ThisObject, ThisObject.SendUUID, ThisObject.SendCurrency, 
			ThisObject.SendAmount, ThisObject.SendAgreement);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, ThisObject.SendUUID);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
		
		AmountsInfo = CurrenciesClientServer.GetLocalTotalAountsInfo();	
		AmountsInfo.TotalAmount.Value = ThisObject.SendAmount;
		AmountsInfo.TotalAmount.Name  = "SendLocalTotalAmount";
		AmountsInfo.LocalRate.Name    = "SendLocalRate";
		TotalAmounts = CurrenciesServer.GetLocalTotalAmounts(ThisObject, Parameters, AmountsInfo);
		CurrenciesServer.UpdateLocalTotalAmounts(ThisObject, TotalAmounts, AmountsInfo);
		
		Parameters = CurrenciesClientServer.GetParameters_V7(ThisObject, ThisObject.ReceiveUUID, ThisObject.ReceiveCurrency, 
			ThisObject.ReceiveAmount, ThisObject.ReceiveAgreement);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, ThisObject.ReceiveUUID);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
		
		AmountsInfo = CurrenciesClientServer.GetLocalTotalAountsInfo();	
		AmountsInfo.TotalAmount.Value = ThisObject.ReceiveAmount;
		AmountsInfo.TotalAmount.Name  = "ReceiveLocalTotalAmount";
		AmountsInfo.LocalRate.Name    = "ReceiveLocalRate";
		TotalAmounts = CurrenciesServer.GetLocalTotalAmounts(ThisObject, Parameters, AmountsInfo);
		CurrenciesServer.UpdateLocalTotalAmounts(ThisObject, TotalAmounts, AmountsInfo);
					
		Parameters = CurrenciesClientServer.GetParameters_V7(ThisObject, ThisObject.TransitUUID, ThisObject.Currency, ThisObject.SendAmount);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, ThisObject.TransitUUID);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
			
	EndIf;
	
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
	
	If ThisObject.SendCurrency = ThisObject.ReceiveCurrency
		And ThisObject.SendAmount <> ThisObject.ReceiveAmount Then
			CommonFunctionsClientServer.ShowUsersMessage(R().Error_148, "SendAmount", ThisObject);
			CommonFunctionsClientServer.ShowUsersMessage(R().Error_148, "ReceiveAmount", ThisObject);
		Cancel = True;
	EndIf;

	If 	   (ThisObject.SendDebtType = Enums.DebtTypes.AdvanceCustomer     And ThisObject.ReceiveDebtType = Enums.DebtTypes.TransactionVendor)
   		Or (ThisObject.SendDebtType = Enums.DebtTypes.TransactionCustomer And ThisObject.ReceiveDebtType = Enums.DebtTypes.AdvanceCustomer)
   		Or (ThisObject.SendDebtType = Enums.DebtTypes.AdvanceVendor       And ThisObject.ReceiveDebtType = Enums.DebtTypes.AdvanceCustomer)
   		Or (ThisObject.SendDebtType = Enums.DebtTypes.AdvanceVendor       And ThisObject.ReceiveDebtType = Enums.DebtTypes.TransactionCustomer)
   		Or (ThisObject.SendDebtType = Enums.DebtTypes.TransactionVendor   And ThisObject.ReceiveDebtType = Enums.DebtTypes.AdvanceVendor) Then
   
   		CommonFunctionsClientServer.ShowUsersMessage(R().Error_142, "SendDebtType", ThisObject);
   		Cancel = True;
   EndIf;
	
	If ThisObject.SendPartner = ThisObject.ReceivePartner And ThisObject.SendLegalName = ThisObject.ReceiveLegalName Then
				
		If (ThisObject.SendDebtType = Enums.DebtTypes.AdvanceCustomer        And ThisObject.ReceiveDebtType = Enums.DebtTypes.AdvanceVendor)
	   		Or (ThisObject.SendDebtType = Enums.DebtTypes.TransactionCustomer And ThisObject.ReceiveDebtType = Enums.DebtTypes.TransactionVendor) Then
	   			   
	   		CommonFunctionsClientServer.ShowUsersMessage(R().Error_142, "SendDebtType", ThisObject);
	   		Cancel = True;
		EndIf;
	Else
				
	EndIf;

EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	Return;
EndProcedure
