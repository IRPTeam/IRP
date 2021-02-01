#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	Tables = New Structure();
	AccReg = Metadata.AccumulationRegisters;
	Tables.Insert("OrderBalance", PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("SalesTurnovers", PostingServer.CreateTable(AccReg.SalesTurnovers));
	
	ObjectStatusesServer.WriteStatusToRegister(Ref, Ref.Status);
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	If Not StatusInfo.Posting Then
		Return Tables;
	EndIf;
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	SalesReturnOrderItemList.Ref.Company AS Company,
		|	SalesReturnOrderItemList.Store AS Store,
		|	SalesReturnOrderItemList.Ref AS Order,
		|	SalesReturnOrderItemList.ItemKey.Item AS Item,
		|	SalesReturnOrderItemList.ItemKey AS ItemKey,
		|	SUM(SalesReturnOrderItemList.Quantity) AS Quantity,
		|	SalesReturnOrderItemList.Unit,
		|	SalesReturnOrderItemList.ItemKey.Item.Unit AS ItemUnit,
		|	SalesReturnOrderItemList.ItemKey.Unit AS ItemKeyUnit,
		|	0 AS BasisQuantity,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	&Period AS Period,
		|	SalesReturnOrderItemList.SalesInvoice AS SalesInvoice,
		|	ISNULL(SalesReturnOrderItemList.Ref.Currency, VALUE(Catalog.Currencies.EmptyRef)) AS Currency,
		|	SUM(SalesReturnOrderItemList.TotalAmount) AS TotalAmount,
		|	SalesReturnOrderItemList.Key AS RowKey
		|FROM
		|	Document.SalesReturnOrder.ItemList AS SalesReturnOrderItemList
		|WHERE
		|	SalesReturnOrderItemList.Ref = &Ref
		|GROUP BY
		|	SalesReturnOrderItemList.Ref.Company,
		|	SalesReturnOrderItemList.Store,
		|	SalesReturnOrderItemList.ItemKey,
		|	SalesReturnOrderItemList.Unit,
		|	SalesReturnOrderItemList.ItemKey.Item.Unit,
		|	SalesReturnOrderItemList.ItemKey.Unit,
		|	SalesReturnOrderItemList.ItemKey.Item,
		|	VALUE(Catalog.Units.EmptyRef),
		|	SalesReturnOrderItemList.Ref,
		|	SalesReturnOrderItemList.SalesInvoice,
		|	ISNULL(SalesReturnOrderItemList.Ref.Currency, VALUE(Catalog.Currencies.EmptyRef)),
		|	SalesReturnOrderItemList.Key
		|HAVING
		|	SUM(SalesReturnOrderItemList.Quantity) <> 0";
	
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("Period", StatusInfo.Period);
	
	QueryResults = Query.Execute();
	
	QueryTable = QueryResults.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTable);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Store AS Store,
		|	QueryTable.Order AS Order,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BasisUnit AS Unit,
		|	QueryTable.Period AS Period,
		|	QueryTable.SalesInvoice AS SalesInvoice,
		|	QueryTable.Currency AS Currency,
		|	QueryTable.TotalAmount AS Amount,
		|	QueryTable.RowKey AS RowKey
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.Order,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.Order,
		|	tmp.ItemKey,
		|	tmp.Unit,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Currency,
		|	tmp.ItemKey,
		|	-SUM(tmp.Quantity) AS Quantity,
		|	-SUM(tmp.Amount) AS Amount,
		|	tmp.Period,
		|	tmp.SalesInvoice,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Currency,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.SalesInvoice,
		|	tmp.RowKey";
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResults = Query.ExecuteBatch();
	
	Tables.OrderBalance = QueryResults[1].Unload();
	Tables.SalesTurnovers = QueryResults[2].Unload();
	
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// OrderBalance
	OrderBalance = AccumulationRegisters.OrderBalance.GetLockFields(DocumentDataTables.OrderBalance);
	DataMapWithLockFields.Insert(OrderBalance.RegisterName, OrderBalance.LockInfo);
	
	// SalesTurnovers
	SalesTurnovers = AccumulationRegisters.SalesTurnovers.GetLockFields(DocumentDataTables.SalesTurnovers);
	DataMapWithLockFields.Insert(SalesTurnovers.RegisterName, SalesTurnovers.LockInfo);
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// OrderBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.OrderBalance,
			Parameters.IsReposting));
	
	// SalesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.SalesTurnovers,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.SalesTurnovers,
			Parameters.IsReposting));
	
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

	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;

	Return QueryArray;
EndFunction

#EndRegion