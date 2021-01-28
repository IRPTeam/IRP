
// Parameters:
// 
// -->Input tables:
// 
// IncomingStocksReal
//	*Period
//	*Store
//	*ItemKey
//	*Order
//	*Quantity
//
// <--Output tables:
//
// IncomingStocks
//  *RecordType
//  *Period
//  *Store
//  *ItemKey
//  *Order
//  *Quantity
//
// IncomingStocksRequested
//  *RecordType
//  *Period
//  *IncomingStore
//  *RequestedStore
//  *ItemKey
//  *Order
//  *Requester
//  *Quantity
//  
// FreeStocks
//  *RecordType
//  *Period
//  *Store
//  *ItemKey
//  *Quantity
Procedure ClosureIncomingStocks(Parameters) Export
	Parameters.Object.RegisterRecords.R4036B_IncomingStocksRequested.LockForUpdate = True;
	Parameters.Object.RegisterRecords.R4036B_IncomingStocksRequested.Clear();
	Parameters.Object.RegisterRecords.R4036B_IncomingStocksRequested.Write();
	
	Parameters.Object.RegisterRecords.R4035B_IncomingStocks.LockForUpdate = True;
	Parameters.Object.RegisterRecords.R4035B_IncomingStocks.Clear();
	Parameters.Object.RegisterRecords.R4035B_IncomingStocks.Write();
		
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT
	|	IncomingStocksReal.Period,
	|	IncomingStocksRequested.IncomingStore,
	|	IncomingStocksRequested.RequesterStore,
	|	IncomingStocksRequested.ItemKey,
	|	IncomingStocksRequested.Requester,
	|	IncomingStocksRequested.Order,
	|	SUM(IncomingStocksRequested.QuantityBalance) AS RequestedQuantity,
	|	IncomingStocksReal.Quantity AS RealIncomingQuantity
	|INTO ClosureIncoming
	|FROM
	|	AccumulationRegister.R4036B_IncomingStocksRequested.Balance(, (IncomingStore, ItemKey, Order) IN
	|		(SELECT
	|			IncomingStocksReal.Store,
	|			IncomingStocksReal.ItemKey,
	|			IncomingStocksReal.Order
	|		FROM
	|			IncomingStocksReal AS IncomingStocksReal)) AS IncomingStocksRequested
	|		INNER JOIN IncomingStocksReal AS IncomingStocksReal
	|		ON IncomingStocksRequested.IncomingStore = IncomingStocksReal.Store
	|		AND IncomingStocksRequested.ItemKey = IncomingStocksReal.ItemKey
	|		AND IncomingStocksRequested.Order = IncomingStocksReal.Order
	|GROUP BY GROUPING SETS
	|(
	|	(IncomingStocksReal.Period,
	|	IncomingStocksRequested.IncomingStore,
	|	IncomingStocksRequested.RequesterStore,
	|	IncomingStocksRequested.ItemKey,
	|	IncomingStocksRequested.Requester,
	|	IncomingStocksRequested.Order),
	|	(IncomingStocksReal.Period,
	|	IncomingStocksRequested.IncomingStore,
	|	IncomingStocksRequested.ItemKey,
	|	IncomingStocksRequested.Order,
	|	IncomingStocksReal.Quantity)
	|)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	IncomingStocksReal.Period,
	|	IncomingStocksReal.Store,
	|	IncomingStocksReal.ItemKey,
	|	IncomingStocksReal.Order
	|INTO UnusedIncomingStocks
	|FROM
	|	IncomingStocksReal AS IncomingStocksReal
	|		LEFT JOIN ClosureIncoming AS ClosureIncoming
	|		ON IncomingStocksReal.Store = ClosureIncoming.IncomingStore
	|		AND IncomingStocksReal.ItemKey = ClosureIncoming.ItemKey
	|		AND IncomingStocksReal.Order = ClosureIncoming.Order
	|WHERE
	|	ClosureIncoming.ItemKey IS NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	ClosureIncoming.Period,
	|	ClosureIncoming.IncomingStore AS Store,
	|	ClosureIncoming.ItemKey,
	|	ClosureIncoming.Order,
	|	ClosureIncoming.RealIncomingQuantity - ClosureIncoming.RequestedQuantity AS Quantity
	|INTO IncomingStocks
	|FROM
	|	ClosureIncoming AS ClosureIncoming
	|WHERE
	|	ClosureIncoming.Requester IS NULL
	|	AND ClosureIncoming.RealIncomingQuantity - ClosureIncoming.RequestedQuantity > 0
	|
	|UNION ALL
	|
	|SELECT
	|	VALUE(AccumulationRecordType.Expense),
	|	UnusedIncomingStocks.Period,
	|	UnusedIncomingStocks.Store,
	|	UnusedIncomingStocks.ItemKey,
	|	UnusedIncomingStocks.Order,
	|	IncomingStocksBalance.QuantityBalance
	|FROM
	|	UnusedIncomingStocks AS UnusedIncomingStocks
	|		INNER JOIN AccumulationRegister.R4035B_IncomingStocks.Balance(, (Store, ItemKey, Order) IN
	|			(SELECT
	|				tmp.Store,
	|				tmp.ItemKey,
	|				tmp.Order
	|			FROM
	|				UnusedIncomingStocks AS tmp)) AS IncomingStocksBalance
	|		ON UnusedIncomingStocks.Store = IncomingStocksBalance.Store
	|		AND UnusedIncomingStocks.ItemKey = IncomingStocksBalance.ItemKey
	|		AND UnusedIncomingStocks.Order = IncomingStocksBalance.Order
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ClosureIncoming.Period,
	|	ClosureIncoming.IncomingStore,
	|	ClosureIncoming.RequesterStore,
	|	ClosureIncoming.ItemKey,
	|	ClosureIncoming.Requester,
	|	ClosureIncoming.Order,
	|	ClosureIncoming.RequestedQuantity,
	|	ClosureIncoming.Requester.Date AS RequesterDate,
	|	0 AS Quantity
	|INTO ClosureIncomingStocksRequested
	|FROM
	|	ClosureIncoming AS ClosureIncoming
	|WHERE
	|	NOT ClosureIncoming.Requester IS NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ClosureIncoming.IncomingStore,
	|	ClosureIncoming.ItemKey,
	|	ClosureIncoming.Order,
	|	ClosureIncoming.RealIncomingQuantity
	|INTO ClosureIncomingStocks
	|FROM
	|	ClosureIncoming AS ClosureIncoming
	|WHERE
	|	ClosureIncoming.Requester IS NULL";
	
	Query.Execute();
	
	ClosureIncomingStocksRequested = PostingServer.GetQueryTableByName("ClosureIncomingStocksRequested", Parameters);
	ClosureIncomingStocks = PostingServer.GetQueryTableByName("ClosureIncomingStocks", Parameters);
	
	ClosureIncomingStocksRequested.Sort("RequesterDate");
	
	For Each Row In ClosureIncomingStocks Do
		Filter = New Structure("IncomingStore, ItemKey, Order");
		FillPropertyValues(Filter, Row);
		ArrayOfRows = ClosureIncomingStocksRequested.FindRows(Filter);
		NeedWriteOff = Row.RealIncomingQuantity;
		For Each ItemOfArray In ArrayOfRows Do
			If NeedWriteOff <= 0 Then
				Break;
			EndIf;
			CanWriteOff = Min(NeedWriteOff, ItemOfArray.RequestedQuantity);
			NeedWriteOff = NeedWriteOff - CanWriteOff;
			ItemOfArray.Quantity = CanWriteOff;
		EndDo;
	EndDo;
	
	Query.Text = 
	"SELECT
	|	*
	|INTO ResultTable
	|FROM
	|	&IncomingStocksRequested AS ResultTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	*
	|INTO IncomingStocksRequested
	|FROM
	|	ResultTable AS ResultTable
	|WHERE
	|	ResultTable.Quantity > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	ResultTable.IncomingStore AS Store,
	|	*
	|INTO FreeStocks
	|FROM
	|	ResultTable AS ResultTable
	|WHERE
	|	ResultTable.Quantity > 0";
	Query.SetParameter("IncomingStocksRequested", ClosureIncomingStocksRequested);
	Query.Execute();
EndProcedure