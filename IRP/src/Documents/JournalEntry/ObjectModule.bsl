
Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	If ValueIsFilled(ThisObject.Basis) Then
		ThisObject.Date = ThisObject.Basis.Date;
	EndIf;
	
	If Not ThisObject.DeletionMark And Not ThisObject.UserDefined Then
		FillRegisterRecords();
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	WriteOnForm = CommonFunctionsClientServer.GetFromAddInfo(ThisObject.AdditionalProperties, "WriteOnForm", False);
	
	If Not WriteOnForm Then
		ThisObject.RegisterRecords.Basic.Read();
	EndIf;
			
	For Each Record In ThisObject.RegisterRecords.Basic Do
		Record.Company = ThisObject.Company;
		Record.LedgerType = ThisObject.LedgerType;
	EndDo;
	
	ThisObject.RegisterRecords.Basic.SetActive(Not ThisObject.DeletionMark);
	ThisObject.RegisterRecords.Basic.Write();
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If TypeOf(FillingData) = Type("Structure") Then
		If FillingData.Property("Basis") Then
			ThisObject.Basis      = FillingData.Basis;
			If CommonFunctionsClientServer.ObjectHasProperty(FillingData.Basis, "Company") Then
				ThisObject.Company = FillingData.Basis.Company;
			EndIf;
		EndIf;
		
		If FillingData.Property("LedgerType") Then
			ThisObject.LedgerType = FillingData.LedgerType;
		EndIf;
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	
	SetObjectAndFormAttributeConformity(ThisObject, "Object");
	
	If Not ThisObject.UserDefined Then
		CheckedAttributes.Add("Basis");
	EndIf;
	
	Index = 0;
	For Each Row In ThisObject.RegisterRecords.Basic Do 
		If Not ValueIsFilled(Row.Period) Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(R().AccountingError_04, "RegisterRecords.Basic["+ Index +"].Period", ThisObject);
		EndIf;
		
		If Not ValueIsFilled(Row.AccountDr) Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(
				R().AccountingError_02, "RegisterRecords.Basic["+ Index +"].AccountDr", ThisObject);
		Else
			If Row.AccountDr.NotUsedForRecords Then
				Cancel = True;
				CommonFunctionsClientServer.ShowUsersMessage(
					StrTemplate(R().AccountingError_01, Row.AccountDr), "RegisterRecords.Basic["+ Index +"].AccountDr", ThisObject);
			EndIf;
		EndIf;
		
		If Not ValueIsFilled(Row.AccountCr) Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(
				R().AccountingError_03, "RegisterRecords.Basic["+ Index +"].AccountCr", ThisObject);
		Else
			If Row.AccountCr.NotUsedForRecords Then
				Cancel = True;
				CommonFunctionsClientServer.ShowUsersMessage(
					StrTemplate(R().AccountingError_01, Row.AccountCr), "RegisterRecords.Basic["+ Index +"].AccountCr", ThisObject);
			EndIf;
		EndIf;
		
		Index = Index + 1;
	EndDo;
	
EndProcedure

Procedure FillRegisterRecords()
	TotalsTable = New ValueTable();
	TotalsTable.Columns.Add("ChartOfAccountDr");
	TotalsTable.Columns.Add("ChartOfAccountCr");
	TotalsTable.Columns.Add("Amount", Metadata.AccountingRegisters.Basic.Resources.Amount.Type);
	
	RecordSet = InformationRegisters.T9050S_AccountingRowAnalytics.CreateRecordSet();
	RecordSet.Filter.Document.Set(ThisObject.Basis);
	RecordSet.Read();
	_AccountingRowAnalytics = RecordSet.Unload();
	
	RecordSet = InformationRegisters.T9051S_AccountingExtDimensions.CreateRecordSet();
	RecordSet.Filter.Document.Set(ThisObject.Basis);
	RecordSet.Read();
	_AccountingExtDimensions = RecordSet.Unload();

	ArrayOfCharts = New Array();
	
	ThisObject.Errors.Clear();
	
	ThisObject.RegisterRecords.Basic.Clear();
		
	For Each Row In _AccountingRowAnalytics Do
		If Row.LedgerType <> ThisObject.LedgerType Then
			Continue;
		EndIf;
		
		DataByAnalytics = AccountingServer.GetDataByAccountingAnalytics(ThisObject.Basis, Row);
		
		If Not ValueIsFilled(DataByAnalytics.Amount) Then
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
		AccountingExtDimensionRows = _AccountingExtDimensions.FindRows(Filter);
		For Each ExtDim In AccountingExtDimensionRows Do
			Record.ExtDimensionsDr[ExtDim.ExtDimensionType] = ExtDim.ExtDimension;
		EndDo;
		
		// Credit analytics
		Record.AccountCr = Row.AccountCredit;
		
		Filter.AnalyticType = Enums.AccountingAnalyticTypes.Credit;
		AccountingExtDimensionRows = _AccountingExtDimensions.FindRows(Filter);
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
