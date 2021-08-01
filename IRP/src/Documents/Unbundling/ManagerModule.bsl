#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export	
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
		
	Return New Structure();
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;	
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref, True);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters, True);
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
	DataMapWithLockFields = New Map();
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
	If Not (Parameters.Property("Unposting") And Parameters.Unposting) Then
		// is posting
		FreeStocksTable   =  PostingServer.GetQueryTableByName("R4011B_FreeStocks", Parameters, True);
		ActualStocksTable =  PostingServer.GetQueryTableByName("R4010B_ActualStocks", Parameters, True);
		Exists_FreeStocksTable   =  PostingServer.GetQueryTableByName("Exists_R4011B_FreeStocks", Parameters, True);
		Exists_ActualStocksTable =  PostingServer.GetQueryTableByName("Exists_R4010B_ActualStocks", Parameters, True);
		
		Filter = New Structure("RecordType", AccumulationRecordType.Expense);
		
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4011B_FreeStocks"          , FreeStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4010B_ActualStocks"        , ActualStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4011B_FreeStocks"   , Exists_FreeStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4010B_ActualStocks" , Exists_ActualStocksTable.Copy(Filter));
		
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ErrorQuantityField", "Object.Quantity");
		Parameters.Insert("RecordType", Filter.RecordType);
		PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.Unbundling.ItemList", AddInfo);
		
		
		Filter = New Structure("RecordType", AccumulationRecordType.Receipt);

		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4011B_FreeStocks"          , FreeStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4010B_ActualStocks"        , ActualStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4011B_FreeStocks"   , Exists_FreeStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4010B_ActualStocks" , Exists_ActualStocksTable.Copy(Filter));
		
		Parameters.Insert("RecordType", Filter.RecordType);
		PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.Unbundling.ItemList", AddInfo);
	Else
		// is unposting
		PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.Unbundling.ItemList", AddInfo);
	EndIf;
EndProcedure

#EndRegion


Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParamenters", GetAdditionalQueryParamenters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParamenters(Ref)
	StrParams = New Structure();
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(Header());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4010B_ActualStocks());
	Return QueryArray;
EndFunction

Function ItemList()
	Return
	"SELECT
	|	UnbundlingItemList.Ref.Date AS Period,
	|	UnbundlingItemList.Ref.Company AS Company,
	|	UnbundlingItemList.Ref.Store AS Store,
	|	UnbundlingItemList.ItemKey AS ItemKey,
	|	UnbundlingItemList.QuantityInBaseUnit * UnbundlingItemList.Ref.QuantityInBaseUnit AS Quantity,
	|	UnbundlingItemList.Ref
	|INTO ItemLIst
	|FROM
	|	Document.Unbundling.ItemList AS UnbundlingItemList
	|WHERE
	|	UnbundlingItemList.Ref = &Ref";
EndFunction

Function Header()
	Return
	"SELECT
	|	Unbundling.Date AS Period,
	|	Unbundling.Company,
	|	Unbundling.Store,
	|	Unbundling.ItemKeyBundle AS ItemKey,
	|	Unbundling.QuantityInBaseUnit AS Quantity,
	|	Unbundling.Ref
	|INTO Header
	|FROM
	|	Document.Unbundling AS Unbundling
	|WHERE
	|	Unbundling.Ref = &Ref";
EndFunction
	
Function R4011B_FreeStocks()
	Return
	"SELECT
	|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
	|	ItemList.Period,
	|	ItemList.Store,
	|	ItemList.ItemKey,
	|	ItemList.Quantity
	|INTO R4011B_FreeStocks
	|FROM
	|	ItemList AS ItemList
	|WHERE
	|	TRUE
	|
	|UNION ALL
	|
	|SELECT
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	Header.Period,
	|	Header.Store,
	|	Header.ItemKey,
	|	Header.Quantity
	|FROM
	|	Header AS Header
	|WHERE
	|	TRUE";
EndFunction
		
Function R4010B_ActualStocks()
	Return
	"SELECT
	|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
	|	ItemList.Period,
	|	ItemList.Store,
	|	ItemList.ItemKey,
	|	ItemList.Quantity
	|INTO R4010B_ActualStocks
	|FROM
	|	ItemList AS ItemList
	|WHERE
	|	TRUE
	|
	|UNION ALL
	|
	|SELECT
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	Header.Period,
	|	Header.Store,
	|	Header.ItemKey,
	|	Header.Quantity
	|FROM
	|	Header AS Header
	|WHERE
	|	TRUE";
EndFunction

