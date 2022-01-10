
Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	ThisObject.RegisterRecords.R6010A_Master.Clear();
	For Each Row In ThisObject.Basis.AccountingRowAnalytics Do
		If Row.LadgerType <> ThisObject.LadgerType Then
			Continue;
		EndIf;
		
		Record = ThisObject.RegisterRecords.R6010A_Master.Add();
		Record.Period     = ThisObject.Date;
		Record.Company    = ThisObject.Company;
		Record.LadgerType = Row.LadgerType;
		
		Filter = New Structure();
		Filter.Insert("Key"          , Row.Key);
		Filter.Insert("AnalyticType" , Enums.AccountingAnalyticTypes.EmptyRef());
		
		// Debit analytics
		Record.AccountDr = Row.AccountDebit;
		Filter.AnalyticType = Enums.AccountingAnalyticTypes.Debit;
		AccountingExtDimensionRows = ThisObject.Basis.AccountingExtDimensions.FindRows(Filter);
		For Each ExtDim In AccountingExtDimensionRows Do
			Record.ExtDimensionsDr.Insert(ExtDim.ExtDimensionType, ExtDim.ExtDimension);
		EndDo;
		
		// Credit analytics
		Record.AccountCr = Row.AccountCredit;
		Filter.AnalyticType = Enums.AccountingAnalyticTypes.Credit;
		AccountingExtDimensionRows = ThisObject.Basis.AccountingExtDimensions.FindRows(Filter);
		For Each ExtDim In AccountingExtDimensionRows Do
			Record.ExtDimensionsCr.Insert(ExtDim.ExtDimensionType, ExtDim.ExtDimension);
		EndDo;
		
		DataByAnalytics = AccountingClientServer.GetDataByAccountingAnalytics(ThisObject.Basis, Row);
		
		// Debit currency
		If Row.AccountDebit.Currency Then
			Record.CurrencyDr       = DataByAnalytics.CurrencyDr;
			Record.CurrencyAmountDr = DataByAnalytics.CurrencyAmountDr;
		EndIf;
		
		// Credit currency
		If Row.AccountCredit.Currency Then
			Record.CurrencyCr       = DataByAnalytics.CurrencyCr;
			Record.CurrencyAmountCr = DataByAnalytics.CurrencyAmountCr;
		EndIf;
		
		// Debit quantity
		If Row.AccountDebit.Quantity Then
			Record.QuantityDr = DataByAnalytics.QuantityDr;
		EndIf;
		
		// Credit quantity
		If Row.AccountCredit.Quantity Then
			Record.QuantityCr = DataByAnalytics.QuantityCr;
		EndIf;
		
		Record.Amount = DataByAnalytics.Amount;
	EndDo;
	ThisObject.RegisterRecords.R6010A_Master.SetActive(True);
	ThisObject.RegisterRecords.R6010A_Master.Write();
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure
