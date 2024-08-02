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
	
	Return AccountingAnalytics;
EndFunction

Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value) Export
	Return Value;
EndFunction

Function GetHintCreditExtDimension(Parameters, ExtDimensionType, Value) Export
	Return Value;
EndFunction

#EndRegion

#EndRegion