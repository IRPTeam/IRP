#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("InventoryBalance"          , PostingServer.CreateTable(AccReg.InventoryBalance));
	Tables.Insert("StockReservation"          , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockBalance"              , PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("ExpensesTurnovers"         , PostingServer.CreateTable(AccReg.ExpensesTurnovers));
	Tables.Insert("StockAdjustmentAsWriteOff" , PostingServer.CreateTable(AccReg.StockAdjustmentAsWriteOff));
	
	Tables.Insert("StockReservation_Exists" , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockBalance_Exists"     , PostingServer.CreateTable(AccReg.StockBalance));
	
	Tables.StockReservation_Exists = 
	AccumulationRegisters.StockReservation.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo);
	
	Tables.StockBalance_Exists = 
	AccumulationRegisters.StockBalance.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo);
	
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
		
	Tables.InventoryBalance = QueryResults[1].Unload();
	Tables.StockReservation = QueryResults[2].Unload();
	Tables.StockBalance = QueryResults[3].Unload();
	Tables.ExpensesTurnovers = QueryResults[4].Unload();
	Tables.StockAdjustmentAsWriteOff = QueryResults[5].Unload();
	
	Parameters.IsReposting = False;
	
#Region NewRegistersPosting		
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExequteQuery(Ref, QueryArray, Parameters);
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
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|//[2]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.HaveBasisDocument
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|//[3]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.HaveBasisDocument
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|//[4]//////////////////////////////////////////////////////////////////////////////
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
		|//[5]//////////////////////////////////////////////////////////////////////////////
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
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// InventoryBalance
	InventoryBalance = 
	AccumulationRegisters.InventoryBalance.GetLockFields(DocumentDataTables.InventoryBalance);
	DataMapWithLockFields.Insert(InventoryBalance.RegisterName, InventoryBalance.LockInfo);
	
	// StockReservation
	StockReservation = 
	AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.StockReservation);
	DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
	
	// StockBalance
	StockBalance = 
	AccumulationRegisters.StockBalance.GetLockFields(DocumentDataTables.StockBalance);
	DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
	
	// StockAdjustmentAsWriteOff
	StockAdjustmentAsWriteOff = 
	AccumulationRegisters.StockAdjustmentAsWriteOff.GetLockFields(DocumentDataTables.StockAdjustmentAsWriteOff);
	DataMapWithLockFields.Insert(StockAdjustmentAsWriteOff.RegisterName, StockAdjustmentAsWriteOff.LockInfo);

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
	
	// InventoryBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.InventoryBalance,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.InventoryBalance));
	
	// StockReservation
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.StockReservation,
			True));
	
	// StockBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.StockBalance,
			True));
	
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
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// StockReservation
	StockReservation = AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.StockReservation_Exists);
	DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
	
	// StockBalance
	StockBalance = AccumulationRegisters.StockBalance.GetLockFields(DocumentDataTables.StockBalance_Exists);
	DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
	
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
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

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R4014B_SerialLotNumber());	
	Return QueryArray;
EndFunction

Function ItemList()
	Return
		"SELECT
		|	OpeningEntryInventory.Ref,
		|	OpeningEntryInventory.Key,
		|	OpeningEntryInventory.ItemKey,
		|	OpeningEntryInventory.Store,
		|	OpeningEntryInventory.Quantity,
		|	NOT OpeningEntryInventory.SerialLotNumber = VALUE(Catalog.SerialLotNumbers.EmptyRef) AS isSerialLotNumberSet,
		|	OpeningEntryInventory.SerialLotNumber,
		|	OpeningEntryInventory.Ref.Date AS Period,
		|	OpeningEntryInventory.Ref.Company AS Company
		|INTO ItemList
		|FROM
		|	Document.OpeningEntry.Inventory AS OpeningEntryInventory
		|WHERE
		|	OpeningEntryInventory.Ref = &Ref";
EndFunction

Function R4014B_SerialLotNumber()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R4014B_SerialLotNumber
		|FROM
		|	ItemList AS QueryTable
		|WHERE 
		|	QueryTable.isSerialLotNumberSet";

EndFunction

#EndRegion