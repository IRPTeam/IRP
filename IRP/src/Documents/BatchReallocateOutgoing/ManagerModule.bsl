#Region POSTING

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;
	QueryArray = GetQueryTextsSecondaryTables();
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

#Region UNDOPOSTING

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

#EndRegion

#Region Posting_MainTables

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R4050B_StockInventory());
	QueryArray.Add(T6020S_BatchKeysInfo());
	Return QueryArray;
EndFunction

Function R4050B_StockInventory()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Store,
		   |	ItemList.ItemKey,
		   |	SUM(ItemList.Quantity) AS Quantity
		   |INTO R4050B_StockInventory
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Receipt),
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Store,
		   |	ItemList.ItemKey,
		   |	VALUE(AccumulationRecordType.Expense)";
EndFunction

Function T6020S_BatchKeysInfo()
	Return "SELECT
		   |	ItemList.ItemKey,
		   |	ItemList.Store,
		   |	ItemList.Company,
		   |	SUM(ItemList.Quantity) AS Quantity,
		   |	ItemList.Period,
		   |	VALUE(Enum.BatchDirection.Expense) AS Direction
		   |INTO T6020S_BatchKeysInfo
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	ItemList.ItemKey,
		   |	ItemList.Store,
		   |	ItemList.Company,
		   |	ItemList.Period,
		   |	VALUE(Enum.BatchDirection.Expense)";
EndFunction

#EndRegion

#Region Posting_SourceTable

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	Return QueryArray;
EndFunction

Function ItemList()
	Return "SELECT
		   |	ItemList.Ref,
		   |	ItemList.Ref.Date AS Period,
		   |	ItemList.Ref.Company,
		   |	ItemList.ItemKey,
		   |	ItemList.Store,
		   |	SUM(ItemList.Quantity) AS Quantity
		   |INTO ItemList
		   |FROM
		   |	Document.BatchReallocateOutgoing.ItemList AS ItemList
		   |WHERE
		   |	ItemList.Ref = &Ref
		   |GROUP BY
		   |	ItemList.Ref.Date,
		   |	ItemList.Ref.Company,
		   |	ItemList.ItemKey,
		   |	ItemList.Store,
		   |	ItemList.Ref";
EndFunction

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
	AccessKeyMap.Insert("Branch", Obj.Branch);
	Return AccessKeyMap;
EndFunction

#EndRegion