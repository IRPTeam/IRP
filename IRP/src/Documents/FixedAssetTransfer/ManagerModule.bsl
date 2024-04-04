#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;
	Parameters.IsReposting = False;
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	
	AccountingServer.CreateAccountingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo);
	
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
	Tables.R8510B_BookValueOfFixedAsset.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map;
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region CheckAfterWrite

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
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
	StrParams.Insert("Company"                 , Ref.Company);
	StrParams.Insert("BranchSender"            , Ref.Branch);
	StrParams.Insert("BranchReceiver"          , Ref.BranchReceiver);
	StrParams.Insert("ProfitLossCenterSender"  , Ref.ProfitLossCenterSender);
	StrParams.Insert("ProfitLossCenterReceiver", Ref.ProfitLossCenterReceiver);
	StrParams.Insert("ResponsiblePersonSender" , Ref.ResponsiblePersonSender);
	StrParams.Insert("FixedAsset"    , Ref.FixedAsset);
	If ValueIsFilled(Ref) Then
		StrParams.Insert("BalancePeriod" , New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	Else
		StrParams.Insert("BalancePeriod" , Undefined);
	EndIf;
	StrParams.Insert("Period", Ref.Date);
	
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(BookValueOfFixedAsset());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(T8515S_FixedAssetsLocation());
	QueryArray.Add(R8510B_BookValueOfFixedAsset());
	QueryArray.Add(T1040T_AccountingAmounts());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function BookValueOfFixedAsset()
	Return
		"SELECT
		|	&Period AS Period,
		|	R8510B_BookValueOfFixedAssetBalance.Company,
		|	R8510B_BookValueOfFixedAssetBalance.Branch,
		|	R8510B_BookValueOfFixedAssetBalance.ProfitLossCenter,
		|	R8510B_BookValueOfFixedAssetBalance.FixedAsset,
		|	R8510B_BookValueOfFixedAssetBalance.LedgerType,
		|	R8510B_BookValueOfFixedAssetBalance.Schedule,
		|	R8510B_BookValueOfFixedAssetBalance.Currency,
		|	R8510B_BookValueOfFixedAssetBalance.AmountBalance AS Amount
		|INTO _BookValueOfFixedAsset
		|FROM
		|	AccumulationRegister.R8510B_BookValueOfFixedAsset.Balance(&BalancePeriod, 
		|	FixedAsset = &FixedAsset
		|	AND Company = &Company
		|	AND Branch = &BranchSender
		|	AND ProfitLossCenter = &ProfitLossCenterSender
		|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
		|		R8510B_BookValueOfFixedAssetBalance";
EndFunction
	
#EndRegion

#Region Posting_MainTables

Function T8515S_FixedAssetsLocation()
	Return
		"SELECT
		|	&Period AS Period,
		|	T8515S_FixedAssetsLocationSliceLast.Company,
		|	T8515S_FixedAssetsLocationSliceLast.Branch,
		|	T8515S_FixedAssetsLocationSliceLast.ProfitLossCenter,
		|	T8515S_FixedAssetsLocationSliceLast.FixedAsset,
		|	T8515S_FixedAssetsLocationSliceLast.ResponsiblePerson,
		|	FALSE AS IsActive
		|INTO T8515S_FixedAssetsLocation
		|FROM
		|	InformationRegister.T8515S_FixedAssetsLocation.SliceLast(&BalancePeriod, Company = &Company
		|	AND Branch = &BranchSender
		|	AND ProfitLossCenter = &ProfitLossCenterSender
		|	AND FixedAsset = &FixedAsset
		|	AND ResponsiblePerson = &ResponsiblePersonSender) AS T8515S_FixedAssetsLocationSliceLast
		|WHERE
		|	T8515S_FixedAssetsLocationSliceLast.IsActive
		|
		|UNION ALL
		|
		|SELECT
		|	FixedAssetTransfer.Date,
		|	FixedAssetTransfer.Company,
		|	FixedAssetTransfer.BranchReceiver,
		|	FixedAssetTransfer.ProfitLossCenterReceiver,
		|	FixedAssetTransfer.FixedAsset,
		|	FixedAssetTransfer.ResponsiblePersonReceiver,
		|	TRUE
		|FROM
		|	Document.FixedAssetTransfer AS FixedAssetTransfer
		|WHERE
		|	FixedAssetTransfer.Ref = &Ref";
EndFunction

Function R8510B_BookValueOfFixedAsset()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	_BookValueOfFixedAsset.Period,
		|	_BookValueOfFixedAsset.Company,
		|	_BookValueOfFixedAsset.Branch,
		|	_BookValueOfFixedAsset.ProfitLossCenter,
		|	_BookValueOfFixedAsset.FixedAsset,
		|	_BookValueOfFixedAsset.LedgerType,
		|	_BookValueOfFixedAsset.Schedule,
		|	_BookValueOfFixedAsset.Currency,
		|	_BookValueOfFixedAsset.Amount
		|INTO R8510B_BookValueOfFixedAsset
		|FROM
		|	_BookValueOfFixedAsset AS _BookValueOfFixedAsset
		|WHERE
		|	TRUE
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	_BookValueOfFixedAsset.Period,
		|	_BookValueOfFixedAsset.Company,
		|	&BranchReceiver,
		|	&ProfitLossCenterReceiver,
		|	_BookValueOfFixedAsset.FixedAsset,
		|	_BookValueOfFixedAsset.LedgerType,
		|	_BookValueOfFixedAsset.Schedule,
		|	_BookValueOfFixedAsset.Currency,
		|	_BookValueOfFixedAsset.Amount
		|FROM
		|	_BookValueOfFixedAsset AS _BookValueOfFixedAsset
		|WHERE
		|	TRUE";
EndFunction

#EndRegion

#Region AccessObject

// Get access key.
// 
// Parameters:
//  Obj - DocumentObject.FixedAssetTransfer -
// 
// Returns:
//  Map
Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	AccessKeyMap.Insert("Company", Obj.Company);
	AccessKeyMap.Insert("Branch", Obj.Branch);
	Return AccessKeyMap;
EndFunction

#EndRegion

#Region Accounting

Function T1040T_AccountingAmounts()
	Return 
		"SELECT
		|	_BookValueOfFixedAsset.Period,
		|	"""" AS RowKey,
		|	_BookValueOfFixedAsset.Currency,
		|	_BookValueOfFixedAsset.Amount,
		|	VALUE(Catalog.AccountingOperations.FixedAssetTransfer_DR_R8510B_BookValueOfFixedAsset_CR_R8510B_BookValueOfFixedAsset) AS
		|		Operation,
		|	UNDEFINED AS AdvancesClosing
		|INTO T1040T_AccountingAmounts
		|FROM
		|	_BookValueOfFixedAsset AS _BookValueOfFixedAsset
		|WHERE
		|	TRUE";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	Operations = Catalogs.AccountingOperations;
	If Parameters.Operation = Operations.FixedAssetTransfer_DR_R8510B_BookValueOfFixedAsset_CR_R8510B_BookValueOfFixedAsset Then
		 
		Return GetAnalytics_BookValue_BookValue(Parameters); // Book value - Book value
		
	EndIf;
	Return Undefined;
EndFunction

#Region Accounting_Analytics

// Book value - Book value
Function GetAnalytics_BookValue_BookValue(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9015S_AccountsFixedAsset(AccountParameters, Parameters.ObjectData.FixedAsset);
	AccountingAnalytics.Debit = Debit.Account;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9015S_AccountsFixedAsset(AccountParameters, Parameters.ObjectData.FixedAsset);
	AccountingAnalytics.Credit = Credit.Account;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value) Export
	If Parameters.Operation = Catalogs.AccountingOperations.FixedAssetTransfer_DR_R8510B_BookValueOfFixedAsset_CR_R8510B_BookValueOfFixedAsset
		And ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.BusinessUnits")) <> Undefined Then
		Return Parameters.ObjectData.ProfitLossCenterReceiver;
	EndIf;
	Return Value;
EndFunction

Function GetHintCreditExtDimension(Parameters, ExtDimensionType, Value) Export
	If Parameters.Operation = Catalogs.AccountingOperations.FixedAssetTransfer_DR_R8510B_BookValueOfFixedAsset_CR_R8510B_BookValueOfFixedAsset
		And ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.BusinessUnits")) <> Undefined Then
		Return Parameters.ObjectData.ProfitLossCenterSender;
	EndIf;
	Return Value;
EndFunction

#EndRegion

#EndRegion
