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
	StrParams.Insert("Company"       , Ref.Company);
	StrParams.Insert("BusinessUnitSender"  , Ref.BusinessUnitSender);
	StrParams.Insert("BusinessUnitReceiver", Ref.BusinessUnitReceiver);
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
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(T8515S_FixedAssetsLocation());
	QueryArray.Add(R8510B_BookValueOfFixedAsset());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

#EndRegion

#Region Posting_MainTables

Function T8515S_FixedAssetsLocation()
	Return
		"SELECT
		|	&Period AS Period,
		|	T8515S_FixedAssetsLocationSliceLast.Company,
		|	T8515S_FixedAssetsLocationSliceLast.FixedAsset,
		|	T8515S_FixedAssetsLocationSliceLast.ResponsiblePerson,
		|	T8515S_FixedAssetsLocationSliceLast.Branch,
		|	FALSE AS IsActive
		|INTO T8515S_FixedAssetsLocation
		|FROM
		|	InformationRegister.T8515S_FixedAssetsLocation.SliceLast(&BalancePeriod, Company = &Company
		|	AND FixedAsset = &FixedAsset
		|	AND Branch = &BusinessUnitSender) AS T8515S_FixedAssetsLocationSliceLast
		|WHERE
		|	T8515S_FixedAssetsLocationSliceLast.IsActive
		|
		|UNION ALL
		|
		|SELECT
		|	FixedAssetTransfer.Date,
		|	FixedAssetTransfer.Company,
		|	FixedAssetTransfer.FixedAsset,
		|	FixedAssetTransfer.ResponsiblePersonReceiver,
		|	FixedAssetTransfer.BusinessUnitReceiver,
		|	TRUE
		|FROM
		|	Document.FixedAssetTransfer AS FixedAssetTransfer
		|WHERE
		|	FixedAssetTransfer.Ref = &Ref";
EndFunction

Function R8510B_BookValueOfFixedAsset()
	Return
		"SELECT
		|	&Period AS Period,
		|	R8510B_BookValueOfFixedAssetBalance.Company,
		|	R8510B_BookValueOfFixedAssetBalance.FixedAsset,
		|	R8510B_BookValueOfFixedAssetBalance.LedgerType,
		|	R8510B_BookValueOfFixedAssetBalance.Schedule,
		|	R8510B_BookValueOfFixedAssetBalance.Currency,
		|	R8510B_BookValueOfFixedAssetBalance.AmountBalance AS Amount
		|INTO _BookValueOfFixedAsset
		|FROM
		|	AccumulationRegister.R8510B_BookValueOfFixedAsset.Balance(&BalancePeriod, FixedAsset = &FixedAsset
		|	AND Branch = &BusinessUnitSender
		|	AND Company = &Company
		|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
		|		R8510B_BookValueOfFixedAssetBalance
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	_BookValueOfFixedAsset.Period,
		|	_BookValueOfFixedAsset.Company,
		|	&BusinessUnitSender AS Branch,
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
		|	&BusinessUnitReceiver,
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