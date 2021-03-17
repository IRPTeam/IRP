#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("ExpensesTurnovers"         , PostingServer.CreateTable(AccReg.ExpensesTurnovers));
	Tables.Insert("StockAdjustmentAsWriteOff" , PostingServer.CreateTable(AccReg.StockAdjustmentAsWriteOff));
	
	QueryItemList = New Query();
	QueryItemList.Text = GetQueryTextInventoryWriteOffItemList();
	QueryItemList.SetParameter("Ref", Ref);
	QueryResultsItemList = QueryItemList.Execute();
	QueryTableItemList = QueryResultsItemList.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTableItemList);
	
	Query = New Query();
	Query.Text = GetQueryTextQueryTable();
	Query.SetParameter("QueryTable", QueryTableItemList);
	QueryResults = Query.ExecuteBatch();
		
	Tables.ExpensesTurnovers = QueryResults[1].Unload();
	Tables.StockAdjustmentAsWriteOff = QueryResults[2].Unload();
	
	Parameters.IsReposting = False;
	
#Region NewRegistersPosting		
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion	

	Return Tables;
EndFunction
	
Function GetQueryTextInventoryWriteOffItemList()
	Return
		"SELECT
		|	StockAdjustmentAsWriteOffItemList.Ref.Company AS Company,
		|	StockAdjustmentAsWriteOffItemList.Ref.Store AS Store,
		|	StockAdjustmentAsWriteOffItemList.ItemKey AS ItemKey,
		|	StockAdjustmentAsWriteOffItemList.Quantity AS Quantity,
		|	StockAdjustmentAsWriteOffItemList.BusinessUnit AS BusinessUnit,
		|	StockAdjustmentAsWriteOffItemList.ExpenseType AS ExpenseType,
		|	StockAdjustmentAsWriteOffItemList.Ref.Date AS Period,
		|	0 AS BasisQuantity,
		|	StockAdjustmentAsWriteOffItemList.Unit,
		|	StockAdjustmentAsWriteOffItemList.ItemKey.Item.Unit AS ItemUnit,
		|	StockAdjustmentAsWriteOffItemList.ItemKey.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	StockAdjustmentAsWriteOffItemList.ItemKey.Item AS Item,
		|	NOT StockAdjustmentAsWriteOffItemList.BasisDocument.Date IS NULL AS HaveBasisDocument,
		|	StockAdjustmentAsWriteOffItemList.BasisDocument AS BasisDocument
		|FROM
		|	Document.StockAdjustmentAsWriteOff.ItemList AS StockAdjustmentAsWriteOffItemList
		|WHERE
		|	StockAdjustmentAsWriteOffItemList.Ref = &Ref";
EndFunction

Function GetQueryTextQueryTable()
	Return
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Store AS Store,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BusinessUnit AS BusinessUnit,
		|	QueryTable.ExpenseType AS ExpenseType,
		|	QueryTable.Period AS Period,
		|	QueryTable.HaveBasisDocument AS HaveBasisDocument,
		|	QueryTable.BasisDocument AS BasisDocument
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|//[1]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BusinessUnit AS BusinessUnit,
		|	tmp.ExpenseType AS ExpenseType,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.BusinessUnit,
		|	tmp.ExpenseType,
		|	tmp.ItemKey,
		|	tmp.Period;
		|//[2]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store AS Store,
		|	tmp.BasisDocument AS BasisDocument,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.HaveBasisDocument
		|GROUP BY
		|	tmp.Store,
		|	tmp.BasisDocument,
		|	tmp.ItemKey,
		|	tmp.Period;
		|";
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
#Region NewRegisterPosting
	Tables = Parameters.DocumentDataTables;	
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
		
	// ExpensesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ExpensesTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.ExpensesTurnovers));
	
	// StockAdjustmentAsWriteOff
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockAdjustmentAsWriteOff,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.StockAdjustmentAsWriteOff));
			
#Region NewRegistersPosting
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
#EndRegion	
			
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
#Region NewRegistersPosting
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region CheckAfterWrite

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
	Parameters.Insert("RecordType", AccumulationRecordType.Expense);
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.StockAdjustmentAsWriteOff.ItemList", AddInfo);
EndProcedure

#EndRegion

#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion


#Region NewRegistersPosting

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
	QueryArray.Add(SerialLotNumbers());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4014B_SerialLotNumber());	
	Return QueryArray;
EndFunction

Function ItemList()
	Return
		"SELECT
		|	ItemList.Ref.Date AS Period,
		|	ItemList.Ref.Company AS Company,
		|	ItemList.Ref.Store AS Store,
		|	ItemList.ItemKey AS ItemKey,
		|	NOT ItemList.PhysicalInventory.Ref IS NULL AS PhysicalInventoryExists,
		|	ItemList.PhysicalInventory AS PhysicalInventory,
		|	ItemList.QuantityInBaseUnit AS Quantity
		|INTO ItemList
		|FROM
		|	Document.StockAdjustmentAsWriteOff.ItemList AS ItemList
		|WHERE
		|	ItemList.Ref = &Ref";
EndFunction

Function SerialLotNumbers()
	Return
		"SELECT
		|	SerialLotNumbers.Ref.Date AS Period,
		|	SerialLotNumbers.Ref.Company AS Company,
		|	SerialLotNumbers.Key,
		|	SerialLotNumbers.SerialLotNumber,
		|	SerialLotNumbers.Quantity,
		|	ItemList.ItemKey AS ItemKey
		|INTO SerialLotNumbers
		|FROM
		|	Document.StockAdjustmentAsWriteOff.SerialLotNumbers AS SerialLotNumbers
		|		LEFT JOIN Document.StockAdjustmentAsWriteOff.ItemList AS ItemList
		|		ON SerialLotNumbers.Key = ItemList.Key
		|		AND ItemList.Ref = &Ref
		|WHERE
		|	SerialLotNumbers.Ref = &Ref";	
EndFunction	

Function R4014B_SerialLotNumber()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	*
		|INTO R4014B_SerialLotNumber
		|FROM
		|	SerialLotNumbers AS QueryTable
		|WHERE 
		|	TRUE";

EndFunction

Function R4011B_FreeStocks()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	*
		|INTO R4011B_FreeStocks
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.PhysicalInventoryExists";
EndFunction

Function R4010B_ActualStocks()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	*
		|INTO R4010B_ActualStocks
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.PhysicalInventoryExists";
EndFunction

#EndRegion