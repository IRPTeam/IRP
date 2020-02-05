#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("StockReservation_Expense", PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockReservation_Receipt", PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockBalance_Expense", PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("StockBalance_Receipt", PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("StockAdjustmentAsWriteOff", PostingServer.CreateTable(AccReg.StockAdjustmentAsWriteOff));
	Tables.Insert("StockAdjustmentAsSurplus", PostingServer.CreateTable(AccReg.StockAdjustmentAsSurplus));
	
	QueryItemList = New Query();
	QueryItemList.Text = GetQueryTextPhysicalInventoryItemList();
	QueryItemList.SetParameter("Ref", Ref);
	QueryResultsItemList = QueryItemList.Execute();
	QueryTableItemList = QueryResultsItemList.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTableItemList);

	Query = New Query();
	Query.Text = GetQueryTextQueryTable();
	Query.SetParameter("QueryTable", QueryTableItemList);
	QueryResults = Query.ExecuteBatch();
		
	Tables.StockReservation_Expense = QueryResults[1].Unload();
	Tables.StockReservation_Receipt = QueryResults[2].Unload();
	Tables.StockBalance_Expense = QueryResults[3].Unload();
	Tables.StockBalance_Receipt = QueryResults[4].Unload();
	Tables.StockAdjustmentAsWriteOff = QueryResults[5].Unload();
	Tables.StockAdjustmentAsSurplus = QueryResults[6].Unload();
	
	Parameters.IsReposting = False;
	
	Return Tables;
EndFunction
	
Function GetQueryTextPhysicalInventoryItemList()
	Return
		"SELECT
		|	PhysicalInventoryItemList.Ref AS BasisDocument,
		|	PhysicalInventoryItemList.Ref.Store AS Store,
		|	PhysicalInventoryItemList.ItemKey AS ItemKey,
		|	PhysicalInventoryItemList.Difference AS Quantity,
		|	PhysicalInventoryItemList.Ref.Date AS Period,
		|	0 AS BasisQuantity,
		|	PhysicalInventoryItemList.Unit,
		|	PhysicalInventoryItemList.ItemKey.Item.Unit AS ItemUnit,
		|	PhysicalInventoryItemList.ItemKey.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	PhysicalInventoryItemList.ItemKey.Item AS Item
		|FROM
		|	Document.PhysicalInventory.ItemList AS PhysicalInventoryItemList
		|WHERE
		|	PhysicalInventoryItemList.Ref = &Ref
		|	AND PhysicalInventoryItemList.Difference <> 0";
EndFunction

Function GetQueryTextQueryTable()
	Return
		"SELECT
		|	QueryTable.BasisDocument AS BasisDocument,
		|	QueryTable.Store AS Store,
		|	QueryTable.ItemKey AS ItemKey,
		|	CASE
		|		WHEN QueryTable.BasisQuantity > 0
		|			THEN QueryTable.BasisQuantity
		|		ELSE 0
		|	END AS SurplusQuantity,
		|	-CASE
		|		WHEN QueryTable.BasisQuantity < 0
		|			THEN QueryTable.BasisQuantity
		|		ELSE 0
		|	END AS WriteOffQuantity,
		|	QueryTable.Period AS Period
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|//[1]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.WriteOffQuantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|HAVING
		|	SUM(tmp.WriteOffQuantity) <> 0
		|;
		|
		|//[2]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.SurplusQuantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|HAVING
		|	SUM(tmp.SurplusQuantity) <> 0
		|;
		|
		|//[3]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.WriteOffQuantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|HAVING
		|	SUM(tmp.WriteOffQuantity) <> 0
		|;
		|
		|//[4]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.SurplusQuantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|HAVING
		|	SUM(tmp.SurplusQuantity) <> 0
		|;
		|
		|//[5]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.BasisDocument AS BasisDocument,
		|	SUM(tmp.WriteOffQuantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.BasisDocument,
		|	tmp.Period
		|HAVING
		|	SUM(tmp.WriteOffQuantity) <> 0
		|;
		|
		|//[6]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.BasisDocument AS BasisDocument,
		|	SUM(tmp.SurplusQuantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.BasisDocument,
		|	tmp.Period
		|HAVING
		|	SUM(tmp.SurplusQuantity) <> 0";
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// StockReservation
	StockReservation = 
	AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.StockReservation_Expense);
	DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
	
	// StockBalance
	StockBalance = 
	AccumulationRegisters.StockBalance.GetLockFields(DocumentDataTables.StockBalance_Expense);
	DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
	
	// StockAdjustmentAsWriteOff
	StockAdjustmentAsWriteOff = 
	AccumulationRegisters.StockAdjustmentAsWriteOff.GetLockFields(DocumentDataTables.StockAdjustmentAsWriteOff);
	DataMapWithLockFields.Insert(StockAdjustmentAsWriteOff.RegisterName, StockAdjustmentAsWriteOff.LockInfo);
	
	// StockAdjustmentAsSurplus
	StockAdjustmentAsSurplus = 
	AccumulationRegisters.StockAdjustmentAsSurplus.GetLockFields(DocumentDataTables.StockAdjustmentAsSurplus);
	DataMapWithLockFields.Insert(StockAdjustmentAsSurplus.RegisterName, StockAdjustmentAsSurplus.LockInfo);
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure


Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// StockReservation
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.StockReservation_Expense.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.StockReservation_Receipt.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Store, ItemKey, Quantity"),
			Parameters.IsReposting));
	
	// StockBalance
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.StockBalance_Expense.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.StockBalance_Receipt.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Store, ItemKey, Quantity"),
			Parameters.IsReposting));
	
	// StockAdjustmentAsWriteOff
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockAdjustmentAsWriteOff,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.StockAdjustmentAsWriteOff));
	
	// StockAdjustmentAsSurplus
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockAdjustmentAsSurplus,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.StockAdjustmentAsSurplus));
	
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

Function GetItemListWithFillingExpCount(Ref, Store, ItemList = Undefined)
	Query = New Query();
	 
	If ItemList = Undefined Then
		Query.Text = GetQueryTextFillExpCount();
	Else
		Query.Text = GetQueryTextFillExpCount_BytItemList();
		
		AccReg = Metadata.AccumulationRegisters.StockBalance;
		
		ItemListTyped = New ValueTable();
		ItemListTyped.Columns.Add("Store", AccReg.Dimensions.Store.Type);
		ItemListTyped.Columns.Add("ItemKey", AccReg.Dimensions.ItemKey.Type);
		For Each Row In ItemList Do
			NewRow = ItemListTyped.Add();
			NewRow.Store = Store;
			NewRow.ItemKey = Row.ItemKey;
		EndDo;
		
		Query.SetParameter("ItemList", ItemList);
	EndIf;
	
	If ValueIsFilled(Ref) Then
		Query.SetParameter("Period", New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	Else
		Query.SetParameter("Period", Undefined);
	EndIf;
	
	Query.SetParameter("Store", Store);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

Function GetQueryTextFillExpCount()
	Return 
	"SELECT
	|	StockBalanceBalance.Store,
	|	StockBalanceBalance.ItemKey,
	|	CASE
	|		WHEN StockBalanceBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
	|			THEN StockBalanceBalance.ItemKey.Unit
	|		ELSE StockBalanceBalance.ItemKey.Item.Unit
	|	END AS Unit,
	|	StockBalanceBalance.QuantityBalance
	|FROM
	|	AccumulationRegister.StockBalance.Balance(&Period, Store = &Store) AS StockBalanceBalance";
EndFunction

Function GetQueryTextFillExpCount_BytItemList()
	Return 
	"";
EndFunction


