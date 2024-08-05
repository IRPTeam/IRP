#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);

	AccountingServer.CreateAccountingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo);

	Tables = New Structure;	
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);

	Tables.T1040T_AccountingAmounts.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.T1050T_AccountingQuantities.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map;
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region Posting_Info

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure;
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(Records());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(T1040T_AccountingAmounts());
	QueryArray.Add(T1050T_AccountingQuantities());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function Records()
	Return
		"SELECT
		|	DocRecords.Period,
		|	DocRecords.Key,
		|	DocRecords.Currency,
		|	DocRecords.Amount,
		|	DocRecords.CurrencyDr AS DrCurrency,
		|	DocRecords.AmountCurrencyDr AS DrCurrencyAmount,
		|	DocRecords.CurrencyCr AS CrCurrency,
		|	DocRecords.AmountCurrencyCr AS CrCurrencyAmount,
		|	CASE
		|		WHEN DocRecords.QuantityDr <> 0
		|			THEN DocRecords.QuantityDr
		|		ELSE DocRecords.QuantityCr
		|	END AS Quantity
		|INTO Records
		|FROM
		|	Document.ExternalAccountingOperation.Records AS DocRecords
		|WHERE
		|	DocRecords.Ref = &Ref";	
EndFunction

#EndRegion

#Region Posting_MainTables

#EndRegion

#Region AccessObject

// Get access key.
// 
// Parameters:
//  Obj - DocumentObjectDocumentName -
// 
// Returns:
//  Map
Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	AccessKeyMap.Insert("Company", Obj.Company);
	Return AccessKeyMap;
EndFunction

#EndRegion

#Region Accounting

Function T1040T_AccountingAmounts()
	Return
		"SELECT
		|	Records.Period,
		|	Records.Key AS RowKey,
		|	Records.Key AS Key,
		|	Records.Currency,
		|	Records.Amount,
		|	Records.DrCurrency,
		|	Records.DrCurrencyAmount,
		|	Records.CrCurrency,
		|	Records.CrCurrencyAmount,
		|	VALUE(Catalog.AccountingOperations.ExternalAccountingOperation) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|INTO T1040T_AccountingAmounts
		|FROM
		|	Records AS Records
		|WHERE
		|	TRUE";
EndFunction

Function T1050T_AccountingQuantities()
	Return 
		"SELECT
		|	Records.Period,
		|	Records.Key AS RowKey,
		|	VALUE(Catalog.AccountingOperations.ExternalAccountingOperation) AS Operation,
		|	Records.Quantity
		|INTO T1050T_AccountingQuantities
		|FROM
		|	Records AS Records
		|WHERE
		|	Records.Quantity <> 0";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	AO = Catalogs.AccountingOperations;
	
	If Parameters.Operation = AO.ExternalAccountingOperation Then
		Return GetAnalytics_ExternalAccountingOperation(Parameters);
	EndIf;
	
	Return Undefined;
EndFunction

#Region Accounting_Analytics

Function GetAnalytics_ExternalAccountingOperation(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	AccountingAnalytics.Debit = Parameters.RowData.AccountDr;
	
	AdditionalAnalyticsDr = New Structure();
	AdditionalAnalyticsDr.Insert("ExtDimDr1", Parameters.RowData.InternalExtDimensionValueDr1);
	AdditionalAnalyticsDr.Insert("ExtDimDr2", Parameters.RowData.InternalExtDimensionValueDr2);
	AdditionalAnalyticsDr.Insert("ExtDimDr3", Parameters.RowData.InternalExtDimensionValueDr3);
				                                               
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsDr);

	// Credit
	AccountingAnalytics.Credit = Parameters.RowData.AccountCr;
	
	AdditionalAnalyticsCr = New Structure();
	AdditionalAnalyticsCr.Insert("ExtDimCr1", Parameters.RowData.InternalExtDimensionValueCr1);
	AdditionalAnalyticsCr.Insert("ExtDimCr2", Parameters.RowData.InternalExtDimensionValueCr2);
	AdditionalAnalyticsCr.Insert("ExtDimCr3", Parameters.RowData.InternalExtDimensionValueCr3);
	
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsCr);
	
	If ValueIsFilled(AccountingAnalytics.LedgerType.SourceLedgerType) Then
		Return MatchAnalytics(Parameters, AccountingAnalytics, AccountingAnalytics.LedgerType.SourceLedgerType);
	EndIf;
	
	Return AccountingAnalytics;
EndFunction

Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value, AdditionalAnalytics, Number) Export
	Return Value;
EndFunction

Function GetHintCreditExtDimension(Parameters, ExtDimensionType, Value, AdditionalAnalytics, Number) Export
	Return Value;
EndFunction

Function MatchAnalytics(Parameters, SourceAnalytics, SourceLedgerType)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	AccountingAnalytics.Debit = MatchAccount(SourceAnalytics.Debit, 
											 SourceAnalytics.DebitExtDimensions,
											 SourceLedgerType, 
											 SourceAnalytics.LedgerType);
	
	AdditionalAnalyticsDr = New Structure();
	AdditionalAnalyticsDr.Insert("ExtDimDr1", Parameters.RowData.InternalExtDimensionValueDr1);
	AdditionalAnalyticsDr.Insert("ExtDimDr2", Parameters.RowData.InternalExtDimensionValueDr2);
	AdditionalAnalyticsDr.Insert("ExtDimDr3", Parameters.RowData.InternalExtDimensionValueDr3);
				                                               
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsDr);

	// Credit
	AccountingAnalytics.Credit = MatchAccount(SourceAnalytics.Credit, 
											  SourceAnalytics.CreditExtDimensions,
											  SourceLedgerType, 
											  SourceAnalytics.LedgerType); 

	AdditionalAnalyticsCr = New Structure();
	AdditionalAnalyticsCr.Insert("ExtDimCr1", Parameters.RowData.InternalExtDimensionValueCr1);
	AdditionalAnalyticsCr.Insert("ExtDimCr2", Parameters.RowData.InternalExtDimensionValueCr2);
	AdditionalAnalyticsCr.Insert("ExtDimCr3", Parameters.RowData.InternalExtDimensionValueCr3);
	
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsCr);
	
	Return AccountingAnalytics;	
EndFunction

Function MatchAccount(SourceAccount, ExtDimensions, SourceLedgerType, TargetLedgerType)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Reg.TargetAccount
	|FROM
	|	InformationRegister.T9068S_AccountingMappingAccountsMatching AS Reg
	|WHERE
	|	Reg.SourceLedgerType = &SourceLedgerType
	|	AND Reg.TargetLedgerType = &TargetLedgerType
	|	AND Reg.SourceAccount = &SourceAccount
	|	AND (CASE
	|		WHEN Reg.AllExtDimensionValues1
	|			THEN TRUE
	|		ELSE Reg.ExtDimensionValue1 = &ExtDimensionValue1
	|	END
	|	AND CASE
	|		WHEN Reg.AllExtDimensionValues2
	|			THEN TRUE
	|		ELSE Reg.ExtDimensionValue2 = &ExtDimensionValue2
	|	END
	|	AND CASE
	|		WHEN Reg.AllExtDimensionValues3
	|			THEN TRUE
	|		ELSE Reg.ExtDimensionValue3 = &ExtDimensionValue3
	|	END)";
	
	Query.SetParameter("SourceLedgerType", SourceLedgerType);
	Query.SetParameter("TargetLedgerType", TargetLedgerType);
	Query.SetParameter("SourceAccount", SourceAccount);
	
	ExtDimensionType1 = AccountingServer.GetExtDimType_ByNumber(1, SourceAccount);
	ExtDimensionValue1 = Undefined;
	If ValueIsFilled(ExtDimensionType1) Then
		ExtDimensionValue1 = GetExtDimensionValue(ExtDimensionType1, ExtDimensions);
	EndIf;
	Query.SetParameter("ExtDimensionValue1", ExtDimensionValue1);
	
	ExtDimensionType2 = AccountingServer.GetExtDimType_ByNumber(2, SourceAccount);
	ExtDimensionValue2 = Undefined;
	If ValueIsFilled(ExtDimensionType2) Then
		ExtDimensionValue2 = GetExtDimensionValue(ExtDimensionType2, ExtDimensions);
	EndIf;
	Query.SetParameter("ExtDimensionValue2", ExtDimensionValue2);
	
	ExtDimensionType3 = AccountingServer.GetExtDimType_ByNumber(3, SourceAccount);
	ExtDimensionValue3 = Undefined;
	If ValueIsFilled(ExtDimensionType3) Then
		ExtDimensionValue3 = GetExtDimensionValue(ExtDimensionType3, ExtDimensions);
	EndIf;
	Query.SetParameter("ExtDimensionValue3", ExtDimensionValue3);
		
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	If QuerySelection.Next() Then
		Return QuerySelection.TargetAccount;
	EndIf;
	
	Return Undefined;
EndFunction

Function GetExtDimensionValue(ExtDimensionType, ExtDimensions)
	For Each Row In ExtDimensions Do
		If Row.ExtDimensionType = ExtDimensionType Then
			Return Row.ExtDimension;
		EndIf;
	EndDo;
	Return Undefined;
EndFunction

#EndRegion

#EndRegion















