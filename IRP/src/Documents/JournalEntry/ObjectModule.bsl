
Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	If ThisObject.UserDefined Then
		ThisObject.RegisterRecords.Basic.Write();
		Return;
	EndIf;
	
	ThisObject.RegisterRecords.Basic.Clear();
	For Each Row In ThisObject.Basis.AccountingRowAnalytics Do
		If Row.LedgerType <> ThisObject.LedgerType Then
			Continue;
		EndIf;
		
		DataByAnalytics = AccountingServer.GetDataByAccountingAnalytics(ThisObject.Basis, Row);
		
		If Not ValueIsFilled(DataByAnalytics.Amount) Then
			Continue;
		EndIf;
		
		Record = ThisObject.RegisterRecords.Basic.Add();
		Record.Period     = ThisObject.Date;
		Record.Company    = ThisObject.Company;
		Record.LedgerType = Row.LedgerType;
		Record.Operation  = Row.Operation;
		Record.IsFixed    = Row.IsFixed;
		Record.IsByRow    = ValueIsFilled(Row.Key);
		Record.Key        = Row.Key;
		
		Filter = New Structure();
		Filter.Insert("Key"          , Row.Key);
		Filter.Insert("Operation"    , Row.Operation);
		Filter.Insert("LedgerType"   , Row.LedgerType);
		Filter.Insert("AnalyticType" , Enums.AccountingAnalyticTypes.EmptyRef());
		
		// Debit analytics
		Record.AccountDr = Row.AccountDebit;
		Filter.AnalyticType = Enums.AccountingAnalyticTypes.Debit;
		AccountingExtDimensionRows = ThisObject.Basis.AccountingExtDimensions.FindRows(Filter);
		For Each ExtDim In AccountingExtDimensionRows Do
			Record.ExtDimensionsDr[ExtDim.ExtDimensionType] = ExtDim.ExtDimension;
		EndDo;
		
		// Credit analytics
		Record.AccountCr = Row.AccountCredit;
		Filter.AnalyticType = Enums.AccountingAnalyticTypes.Credit;
		AccountingExtDimensionRows = ThisObject.Basis.AccountingExtDimensions.FindRows(Filter);
		For Each ExtDim In AccountingExtDimensionRows Do
			Record.ExtDimensionsCr[ExtDim.ExtDimensionType] = ExtDim.ExtDimension;
		EndDo;
				
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
	ThisObject.RegisterRecords.Basic.SetActive(True);
	ThisObject.RegisterRecords.Basic.Write();
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If TypeOf(FillingData) = Type("Structure") Then
		ThisObject.Basis      = FillingData.Basis;
		ThisObject.LedgerType = FillingData.LedgerType;
		If CommonFunctionsClientServer.ObjectHasProperty(FillingData.Basis, "Company") Then
			ThisObject.Company = FillingData.Basis.Company;
		EndIf;
	EndIf;
EndProcedure


