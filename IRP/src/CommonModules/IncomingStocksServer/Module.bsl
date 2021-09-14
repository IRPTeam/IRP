
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
//  *RequesterStore
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
	IncomingStocks = GetIncomingStocks_ConsiderStocksRequested(Parameters);
	IncomingStocksRequested = GetIncomingStocksRequested_ConsiderStocksRequested(Parameters);

	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.SetParameter("IncomingStocks", IncomingStocks);
	Query.SetParameter("IncomingStocksRequested", IncomingStocksRequested);
	Query.Text =
	"SELECT
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	tmp.Period,
	|	tmp.Store,
	|	tmp.ItemKey,
	|	tmp.Order,
	|	tmp.Quantity
	|INTO IncomingStocks
	|FROM
	|	&IncomingStocks AS tmp
	|WHERE
	|	tmp.Quantity <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	tmp.Period,
	|	tmp.IncomingStore,
	|	tmp.RequesterStore,
	|	tmp.ItemKey,
	|	tmp.Order,
	|	tmp.Requester,
	|	tmp.Quantity
	|INTO IncomingStocksRequested
	|FROM
	|	&IncomingStocksRequested AS tmp
	|WHERE
	|	tmp.Quantity <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	tmp.Period,
	|	tmp.IncomingStore AS Store,
	|	tmp.ItemKey,
	|	tmp.Quantity
	|INTO FreeStocks
	|FROM
	|	&IncomingStocksRequested AS tmp
	|WHERE
	|	tmp.Quantity <> 0";
	Query.Execute();
EndProcedure

Procedure ClosureIncomingStocks_Unposting(Parameters) Export
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
	"SELECT
	|	Table.Period,
	|	Table.Store,
	|	Table.ItemKey,
	|	Table.Order,
	|	Table.Quantity
	|INTO IncomingStocks
	|FROM
	|	AccumulationRegister.R4035B_IncomingStocks AS Table
	|WHERE
	|	FALSE
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Table.Period,
	|	Table.IncomingStore,
	|	Table.RequesterStore,
	|	Table.ItemKey,
	|	Table.Order,
	|	Table.Requester,
	|	Table.Quantity
	|INTO IncomingStocksRequested
	|FROM
	|	AccumulationRegister.R4036B_IncomingStocksRequested AS Table
	|WHERE
	|	FALSE
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Table.Period,
	|	Table.Store,
	|	Table.ItemKey,
	|	Table.Quantity
	|INTO FreeStocks
	|FROM
	|	AccumulationRegister.R4011B_FreeStocks AS Table
	|WHERE
	|	FALSE";
	Query.Execute();
EndProcedure

Function GetIncomingStocks_ConsiderStocksRequested(Parameters)
	Query = New Query();
	Query.SetParameter("BalancePeriod", New Boundary(Parameters.PointInTime, BoundaryType.Excluding));
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
	"SELECT
	|	IncomingStocksReal.Period,
	|	R4035B_IncomingStocksBalance.Store,
	|	R4035B_IncomingStocksBalance.ItemKey,
	|	R4035B_IncomingStocksBalance.Order,
	|	CASE
	|		WHEN R4035B_IncomingStocksBalance.QuantityBalance < IncomingStocksReal.Quantity
	|			THEN R4035B_IncomingStocksBalance.QuantityBalance
	|		ELSE IncomingStocksReal.Quantity
	|	END AS Quantity,
	|	IncomingStocksReal.Quantity AS RealIncomingQuntity
	|INTO IncomingBalance
	|FROM
	|	AccumulationRegister.R4035B_IncomingStocks.Balance(&BalancePeriod, (Store, ItemKey, Order) IN
	|		(SELECT
	|			IncomingStocksReal.Store,
	|			IncomingStocksReal.ItemKey,
	|			IncomingStocksReal.Order
	|		FROM
	|			IncomingStocksReal AS IncomingStocksReal)) AS R4035B_IncomingStocksBalance
	|		INNER JOIN IncomingStocksReal AS IncomingStocksReal
	|		ON R4035B_IncomingStocksBalance.Store = IncomingStocksReal.Store
	|		AND R4035B_IncomingStocksBalance.ItemKey = IncomingStocksReal.ItemKey
	|		AND R4035B_IncomingStocksBalance.Order = IncomingStocksReal.Order
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R4036B_IncomingStocksRequested.IncomingStore AS Store,
	|	R4036B_IncomingStocksRequested.ItemKey,
	|	R4036B_IncomingStocksRequested.Order,
	|	R4036B_IncomingStocksRequested.QuantityBalance AS Quantity
	|INTO RequestedBalance
	|FROM
	|	AccumulationRegister.R4036B_IncomingStocksRequested.Balance(&BalancePeriod, (IncomingStore, ItemKey, Order) IN
	|		(SELECT
	|			IncomingStocksReal.Store,
	|			IncomingStocksReal.ItemKey,
	|			IncomingStocksReal.Order
	|		FROM
	|			IncomingStocksReal AS IncomingStocksReal)) AS R4036B_IncomingStocksRequested
	|		INNER JOIN IncomingStocksReal AS IncomingStocksReal
	|		ON R4036B_IncomingStocksRequested.IncomingStore = IncomingStocksReal.Store
	|		AND R4036B_IncomingStocksRequested.ItemKey = IncomingStocksReal.ItemKey
	|		AND R4036B_IncomingStocksRequested.Order = IncomingStocksReal.Order
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	IncomingBalance.Period,
	|	IncomingBalance.Store,
	|	IncomingBalance.ItemKey,
	|	IncomingBalance.Order,
	|	SUM(CASE
	|		WHEN IncomingBalance.RealIncomingQuntity > ISNULL(RequestedBalance.Quantity, 0)
	|			THEN CASE
	|				WHEN IncomingBalance.RealIncomingQuntity - ISNULL(RequestedBalance.Quantity, 0) < IncomingBalance.Quantity
	|					THEN IncomingBalance.RealIncomingQuntity - ISNULL(RequestedBalance.Quantity, 0)
	|				ELSE IncomingBalance.Quantity
	|			END
	|		ELSE 0
	|	END) AS Quantity
	|INTO StockForWriteOff
	|FROM
	|	IncomingBalance AS IncomingBalance
	|		LEFT JOIN RequestedBalance AS RequestedBalance
	|		ON IncomingBalance.Store = RequestedBalance.Store
	|		AND IncomingBalance.ItemKey = RequestedBalance.ItemKey
	|		AND IncomingBalance.Order = RequestedBalance.Order
	|GROUP BY
	|	IncomingBalance.Period,
	|	IncomingBalance.Store,
	|	IncomingBalance.ItemKey,
	|	IncomingBalance.Order
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	StockForWriteOff.Period,
	|	StockForWriteOff.Store,
	|	StockForWriteOff.ItemKey,
	|	StockForWriteOff.Order,
	|	StockForWriteOff.Quantity AS Quantity
	|WHERE
	|	StockForWriteOff.Quantity > 0";
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

Function GetIncomingStocksRequested_ConsiderStocksRequested(Parameters)
	Query = New Query();
	Query.SetParameter("BalancePeriod", New Boundary(Parameters.PointInTime, BoundaryType.Excluding));
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
	"SELECT
	|	R4036B_IncomingStocksRequested.IncomingStore,
	|	R4036B_IncomingStocksRequested.ItemKey,
	|	R4036B_IncomingStocksRequested.Order,
	|	CASE
	|		WHEN R4036B_IncomingStocksRequested.QuantityBalance < IncomingStocksReal.Quantity
	|			THEN R4036B_IncomingStocksRequested.QuantityBalance
	|		ELSE IncomingStocksReal.Quantity
	|	END AS Quantity
	|FROM
	|	AccumulationRegister.R4036B_IncomingStocksRequested.Balance(&BalancePeriod, (IncomingStore, ItemKey, Order) IN
	|		(SELECT
	|			IncomingStocksReal.Store,
	|			IncomingStocksReal.ItemKey,
	|			IncomingStocksReal.Order
	|		FROM
	|			IncomingStocksReal AS IncomingStocksReal)) AS R4036B_IncomingStocksRequested
	|		INNER JOIN IncomingStocksReal AS IncomingStocksReal
	|		ON R4036B_IncomingStocksRequested.IncomingStore = IncomingStocksReal.Store
	|		AND R4036B_IncomingStocksRequested.ItemKey = IncomingStocksReal.ItemKey
	|		AND R4036B_IncomingStocksRequested.Order = IncomingStocksReal.Order
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	IncomingStocksReal.Period,
	|	R4036B_IncomingStocksRequested.IncomingStore,
	|	R4036B_IncomingStocksRequested.RequesterStore,
	|	R4036B_IncomingStocksRequested.ItemKey,
	|	R4036B_IncomingStocksRequested.Order,
	|	R4036B_IncomingStocksRequested.Requester,
	|	R4036B_IncomingStocksRequested.Requester.Date AS RequesterDate,
	|	SUM(R4036B_IncomingStocksRequested.QuantityBalance) AS RequestedQuantity,
	|	0 AS Quantity
	|FROM
	|	AccumulationRegister.R4036B_IncomingStocksRequested.Balance(&BalancePeriod, (IncomingStore, ItemKey, Order) IN
	|		(SELECT
	|			IncomingStocksReal.Store,
	|			IncomingStocksReal.ItemKey,
	|			IncomingStocksReal.Order
	|		FROM
	|			IncomingStocksReal AS IncomingStocksReal)) AS R4036B_IncomingStocksRequested
	|		INNER JOIN IncomingStocksReal AS IncomingStocksReal
	|		ON R4036B_IncomingStocksRequested.IncomingStore = IncomingStocksReal.Store
	|		AND R4036B_IncomingStocksRequested.ItemKey = IncomingStocksReal.ItemKey
	|		AND R4036B_IncomingStocksRequested.Order = IncomingStocksReal.Order
	|GROUP BY
	|	IncomingStocksReal.Period,
	|	R4036B_IncomingStocksRequested.IncomingStore,
	|	R4036B_IncomingStocksRequested.RequesterStore,
	|	R4036B_IncomingStocksRequested.ItemKey,
	|	R4036B_IncomingStocksRequested.Order,
	|	R4036B_IncomingStocksRequested.Requester,
	|	R4036B_IncomingStocksRequested.Requester.Date";

	QueryResults = Query.ExecuteBatch();
	IncomingStocks = QueryResults[0].Unload();
	IncomingStocksRequested = QueryResults[1].Unload();

	IncomingStocksRequested.Sort("RequesterDate");

	For Each Row In IncomingStocks Do
		Filter = New Structure("IncomingStore, ItemKey, Order");
		FillPropertyValues(Filter, Row);
		ArrayOfRows = IncomingStocksRequested.FindRows(Filter);
		NeedWriteOff = Row.Quantity;
		For Each ItemOfArray In ArrayOfRows Do
			If NeedWriteOff <= 0 Then
				Break;
			EndIf;
			CanWriteOff = Min(NeedWriteOff, ItemOfArray.RequestedQuantity);
			NeedWriteOff = NeedWriteOff - CanWriteOff;
			ItemOfArray.Quantity = CanWriteOff;
		EndDo;
	EndDo;

	Return IncomingStocksRequested;
EndFunction