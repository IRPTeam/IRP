
Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	If ValueIsFilled(ThisObject.Basis) Then
		ThisObject.Date = ThisObject.Basis.Date;
	EndIf;
	FillRegisterRecords();
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	If ThisObject.UserDefined Then
		ThisObject.RegisterRecords.Basic.Write();
		Return;
	EndIf;
		
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

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If ThisObject.UserDefined Then
		CheckedAttributes.Delete(CheckedAttributes.Find("Basis"));
	EndIf;
EndProcedure

Procedure FillRegisterRecords()
	TotalsTable = New ValueTable();
	TotalsTable.Columns.Add("ChartOfAccountDr");
	TotalsTable.Columns.Add("ChartOfAccountCr");
	TotalsTable.Columns.Add("Amount", Metadata.AccountingRegisters.Basic.Resources.Amount.Type);
	
	ArrayOfCharts = New Array();
	
	ThisObject.Errors.Clear();
	
	ThisObject.RegisterRecords.Basic.Clear();
	For Each Row In ThisObject.Basis.AccountingRowAnalytics Do
		If Row.LedgerType <> ThisObject.LedgerType Then
			Continue;
		EndIf;
		
		If Not ValueIsFilled(Row.AccountDebit) Then
			NewRowError = ThisObject.Errors.Add();
			NewRowError.Key = Row.Key;
			NewRowError.Operation = Row.Operation;
			NewRowError.ErrorDescription = "empty Debit";
		EndIf;
		If Not ValueIsFilled(Row.AccountCredit) Then
			NewRowError = ThisObject.Errors.Add();
			NewRowError.Key = Row.Key;
			NewRowError.Operation = Row.Operation;
			NewRowError.ErrorDescription = "empty Credit";
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
		
		// Totals
		NewTotalDr = TotalsTable.Add();
		NewTotalDr.ChartOfAccountDr = Record.AccountDr;
		NewTotalDr.Amount           = Record.Amount;
		
		NewTotalCr = TotalsTable.Add();
		NewTotalCr.ChartOfAccountCr = Record.AccountCr;
		NewTotalCr.Amount           = Record.Amount;
		
		If ArrayOfCharts.Find(Record.AccountDr) = Undefined Then
			ArrayOfCharts.Add(Record.AccountDr);
		EndIf;
		
		If ArrayOfCharts.Find(Record.AccountCr) = Undefined Then
			ArrayOfCharts.Add(Record.AccountCr);
		EndIf;
		
	EndDo;	
	
	ThisObject.Totals.Clear();
	For Each Chart In ArrayOfCharts Do
		RowsDr = TotalsTable.FindRows(New Structure("ChartOfAccountDr", Chart));
		TotalAmountDr = 0;
		For Each RowDr In RowsDr Do
			TotalAmountDr = TotalAmountDr + RowDr.Amount;
		EndDo;
		
		RowsCr = TotalsTable.FindRows(New Structure("ChartOfAccountCr", Chart));
		TotalAmountCr = 0;
		For Each RowCr In RowsCr Do
			TotalAmountCr = TotalAmountCr + RowCr.Amount;
		EndDo;
		NewRowTotals = ThisObject.Totals.Add();
		NewRowTotals.ChartOfAccount = Chart;
		NewRowTotals.AmountDr = TotalAmountDr;
		NewRowTotals.AmountCr = TotalAmountCr;
	EndDo;
EndProcedure
