
Function GenerateReport(Params, AddInfo = Undefined) Export
	Template = DataProcessors.SalesOrderStatusReport.GetTemplate("ReportTemplate");
	TabDoc = New SpreadsheetDocument;
	QueryInfo = GetReportData(Params);
	Data = QueryInfo[4].Unload(QueryResultIteration.ByGroups);

	Params = New Structure;
	Params.Insert("StockInfo", QueryInfo[8].Unload(QueryResultIteration.ByGroups));
		
	Title = Template.GetArea("Title");
	TabDoc.Put(Title);
	
	For Each Order In Data.Rows Do
		OrderRow = Template.GetArea("OrderRow");
		OrderRow.Parameters.SalesOrder = Order.SalesOrder;
		TabDoc.Put(OrderRow);	
		TabDoc.StartRowGroup();	
		For Each ItemInfo In Order.Rows Do
			ItemInfoRow = Template.GetArea("ItemInfoRow");
			ItemInfoRow.Parameters.Fill(ItemInfo);
			ItemName = String(ItemInfo.ItemKey.Item) + " (" + ItemInfo.ItemKey + ")";
			ItemInfoRow.Parameters.ItemInfo = ItemName;
			ItemInfoRow.Parameters.QuantityStockFree = ItemInfo.QuantityStock - ItemInfo.QuantityStockReservation + ItemInfo.QuantityStockWaitIncome;

			Quantity = 0; 
			ItemInfoRow.StartRowGroup();	
			For Each ItemInfoDetail In ItemInfo.Rows Do
				ItemInfoDetailRow = Template.GetArea("ItemInfoDetail");
				ItemInfoDetailRow.Parameters.Fill(ItemInfoDetail);
				ItemInfoDetailRow.Parameters.ItemInfo = ItemName;
				ItemInfoDetailRow.StartRowGroup();					
				CalculateReserve(ItemInfoDetail, ItemInfoDetailRow, Params, Quantity, Template);
				ItemInfoDetailRow.EndRowGroup();
				ItemInfoRow.Put(ItemInfoDetailRow, 2);
			EndDo;			
			ItemInfoRow.EndRowGroup();

			ItemInfoRow.Parameters.Quantity = Quantity;
			ItemInfoRow.Parameters.Unit = ItemInfo.ItemKey.Item.Unit;
			TabDoc.Put(ItemInfoRow, 1);
		EndDo;
		TabDoc.EndRowGroup();
	EndDo;

	TabDoc.ShowRowGroupLevel(1);
	Return TabDoc;
EndFunction

Function GetReportData(Params)

	Query = New Query;
	Query.SetParameter("SalesOrderArray", Params.SalesOrders);
	Query.SetParameter("CurrentDate", BegOfDay(CurrentSessionDate()));

	Query.Text =
		"SELECT
		|	SalesOrderItemList.Ref AS SalesOrder,
		|	SalesOrderItemList.Key AS RowKey,
		|	SalesOrderItemList.Cancel,
		|	SalesOrderItemList.ItemKey AS ItemKey,
		|	SalesOrderItemList.Quantity AS Quantity,
		|	SalesOrderItemList.Unit,
		|	SalesOrderItemList.DeliveryDate,
		|	SalesOrderItemList.Store,
		|	SalesOrderItemList.ProcurementMethod
		|Into SalesOrderItemList
		|FROM
		|	Document.SalesOrder.ItemList AS SalesOrderItemList
		|WHERE
		|	SalesOrderItemList.Ref IN (&SalesOrderArray)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SalesOrderItemList.SalesOrder AS SalesOrder,
		|	SalesOrderItemList.RowKey AS RowKey,
		|	SalesOrderItemList.Cancel AS Cancel,
		|	SalesOrderItemList.ItemKey AS ItemKey,
		|	SalesOrderItemList.Quantity AS Quantity,
		|	SalesOrderItemList.Unit AS Unit,
		|	SalesOrderItemList.DeliveryDate AS DeliveryDate,
		|	SalesOrderItemList.Store AS Store,
		|	SalesOrderItemList.ProcurementMethod AS ProcurementMethod
		|INTO ItemsData
		|FROM
		|	SalesOrderItemList AS SalesOrderItemList
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	NestedSelect.ItemKey AS ItemKey,
		|	SUM(NestedSelect.QuantityStock) AS QuantityStock,
		|	SUM(NestedSelect.QuantityStockReservation) AS QuantityStockReservation
		|INTO StockInfo
		|FROM
		|	(SELECT
		|		StockBalance.ItemKey AS ItemKey,
		|		StockBalance.QuantityBalance AS QuantityStock,
		|		0 AS QuantityStockReservation
		|	FROM
		|		AccumulationRegister.StockBalance.Balance(, ItemKey IN
		|			(SELECT
		|				ItemsData.ItemKey
		|			FROM
		|				ItemsData AS ItemsData)) AS StockBalance
		|
		|	UNION ALL
		|
		|	SELECT
		|		StockReservationBalance.ItemKey,
		|		0,
		|		StockReservationBalance.QuantityBalance
		|	FROM
		|		AccumulationRegister.StockReservation.Balance(, ItemKey IN
		|			(SELECT
		|				ItemsData.ItemKey
		|			FROM
		|				ItemsData AS ItemsData)) AS StockReservationBalance) AS NestedSelect
		|GROUP BY
		|	NestedSelect.ItemKey
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ItemsData.SalesOrder AS SalesOrder,
		|	ItemsData.RowKey AS RowKey,
		|	ItemsData.Cancel AS Cancel,
		|	ItemsData.ItemKey AS ItemKey,
		|	ItemsData.Quantity AS Quantity,
		|	ItemsData.Unit AS Unit,
		|	ItemsData.DeliveryDate AS DeliveryDate,
		|	ItemsData.Store AS Store,
		|	ItemsData.ProcurementMethod AS ProcurementMethod,
		|	StockInfo.QuantityStock AS QuantityStock,
		|	StockInfo.QuantityStockReservation AS QuantityStockReservation,
		|	0 AS QuantityStockFree
		|INTO ItemsWithReserve
		|FROM
		|	ItemsData AS ItemsData
		|		LEFT JOIN StockInfo AS StockInfo
		|		ON ItemsData.ItemKey = StockInfo.ItemKey
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ItemsWithReserve.SalesOrder AS SalesOrder,
		|	ItemsWithReserve.RowKey AS RowKey,
		|	ItemsWithReserve.Cancel AS Cancel,
		|	ItemsWithReserve.ItemKey AS ItemKey,
		|	ItemsWithReserve.Quantity AS Quantity,
		|	ItemsWithReserve.Unit AS Unit,
		|	ItemsWithReserve.DeliveryDate AS DeliveryDate,
		|	ItemsWithReserve.Store AS Store,
		|	ItemsWithReserve.ProcurementMethod AS ProcurementMethod,
		|	ISNULL(ItemsWithReserve.QuantityStock, 0) AS QuantityStock,
		|	ISNULL(CASE
		|		WHEN ItemsWithReserve.QuantityStockReservation < 0
		|			THEN -ItemsWithReserve.QuantityStockReservation
		|		ELSE 0
		|	END, 0) AS QuantityStockReservation,
		|	ISNULL(ItemsWithReserve.QuantityStockFree, 0) AS QuantityStockFree,
		|	ISNULL(CASE
		|		WHEN ItemsWithReserve.QuantityStockReservation > 0
		|			THEN ItemsWithReserve.QuantityStockReservation
		|		ELSE 0
		|	END, 0) AS QuantityStockWaitIncome
		|FROM
		|	ItemsWithReserve AS ItemsWithReserve
		|ORDER BY
		|	DeliveryDate
		|TOTALS
		|	MAX(QuantityStock) AS QuantityStock,
		|	MAX(QuantityStockReservation),
		|	MAX(QuantityStockFree),
		|	MAX(QuantityStockWaitIncome) AS QuantityStockWaitIncome
		|BY
		|	SalesOrder,
		|	ItemKey
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	StockBalance.Store AS Store,
		|	StockBalance.ItemKey AS ItemKey,
		|	StockBalance.Period AS Period,
		|	StockBalance.QuantityClosingBalance AS Quantity
		|INTO VTStockBalance
		|FROM
		|	AccumulationRegister.StockBalance.BalanceAndTurnovers(&CurrentDate,, Day,, ItemKey IN
		|		(SELECT
		|			ItemsData.ItemKey
		|		FROM
		|			ItemsData AS ItemsData)) AS StockBalance
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	StockReservation.Store AS Store,
		|	StockReservation.ItemKey AS ItemKey,
		|	StockReservation.Period AS Period,
		|	StockReservation.QuantityClosingBalance AS Quantity
		|INTO VTStockReservationBalance
		|FROM
		|	AccumulationRegister.StockReservation.BalanceAndTurnovers(&CurrentDate,, Day,, ItemKey IN
		|		(SELECT
		|			ItemsData.ItemKey
		|		FROM
		|			ItemsData AS ItemsData)) AS StockReservation
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	GoodsReceiptSchedule.Store AS Store,
		|	GoodsReceiptSchedule.ItemKey AS ItemKey,
		|	GoodsReceiptSchedule.Period AS Period,
		|	-GoodsReceiptSchedule.QuantityClosingBalance AS Quantity
		|INTO VTGoodsReceiptSchedule
		|FROM
		|	AccumulationRegister.GoodsReceiptSchedule.BalanceAndTurnovers(&CurrentDate,, Day,, ItemKey IN
		|		(SELECT
		|			ItemsData.ItemKey
		|		FROM
		|			ItemsData AS ItemsData)) AS GoodsReceiptSchedule
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	NestedSelect.Store AS Store,
		|	NestedSelect.ItemKey AS ItemKey,
		|	NestedSelect.Period AS Period,
		|	SUM(NestedSelect.QuantityGoodsReceiptSchedule) AS QuantityGoodsReceiptSchedule,
		|	SUM(NestedSelect.QuantityStockBalance) AS QuantityStockBalance,
		|	SUM(NestedSelect.QuantityStockReserved) AS QuantityStockReserved
		|FROM
		|	(SELECT
		|		VTGoodsReceiptSchedule.Store AS Store,
		|		VTGoodsReceiptSchedule.ItemKey AS ItemKey,
		|		VTGoodsReceiptSchedule.Period AS Period,
		|		VTGoodsReceiptSchedule.Quantity AS QuantityGoodsReceiptSchedule,
		|		0 AS QuantityStockBalance,
		|		0 AS QuantityStockReserved
		|	FROM
		|		VTGoodsReceiptSchedule AS VTGoodsReceiptSchedule
		|
		|	UNION ALL
		|
		|	SELECT
		|		VTStockBalance.Store,
		|		VTStockBalance.ItemKey,
		|		VTStockBalance.Period,
		|		0,
		|		VTStockBalance.Quantity,
		|		0
		|	FROM
		|		VTStockBalance AS VTStockBalance
		|
		|	UNION ALL
		|
		|	SELECT
		|		VTStockReservationBalance.Store,
		|		VTStockReservationBalance.ItemKey,
		|		VTStockReservationBalance.Period,
		|		0,
		|		0,
		|		VTStockReservationBalance.Quantity
		|	FROM
		|		VTStockReservationBalance AS VTStockReservationBalance) AS NestedSelect
		|GROUP BY
		|	NestedSelect.Store,
		|	NestedSelect.ItemKey,
		|	NestedSelect.Period
		|ORDER BY
		|	ItemKey,
		|	Period
		|TOTALS
		|	SUM(QuantityGoodsReceiptSchedule),
		|	SUM(QuantityStockBalance),
		|	SUM(QuantityStockReserved)
		|BY
		|	ItemKey,
		|	Period";
	
	QueryResult = Query.ExecuteBatch();
		
	Return QueryResult;
EndFunction

Procedure CalculateReserve(ItemInfoDetail, ItemInfoDetailRow, Params, Quantity, Template)
	UnitFactor = Catalogs.Units.GetUnitFactor(ItemInfoDetail.Unit, ItemInfoDetail.ItemKey.Unit);
	CurrentQuantity = UnitFactor * ItemInfoDetail.Quantity;
	
	StockInfo = Params.StockInfo.Rows.FindRows(New Structure("ItemKey", ItemInfoDetail.ItemKey));
	If StockInfo.Count() = 0 Then
		ItemInfoDetailRow.Parameters.CanBeReservedDate = R().SOR_1;
	Else
		QuantityAfterReserv = 
			StockInfo[0].QuantityGoodsReceiptSchedule + StockInfo[0].QuantityStockBalance + StockInfo[0].QuantityStockReserved 
			- (CurrentQuantity + Quantity);
	
		If QuantityAfterReserv < 0 Then
			ItemInfoDetailRow.Parameters.CanBeReservedDate = R().SOR_1;
		Else
			QuantityAfterReserv = 0;
			
			For Each Row In StockInfo[0].Rows Do
				QuantityAfterReserv = QuantityAfterReserv + 
					Row.QuantityGoodsReceiptSchedule + Row.QuantityStockBalance 
						+ Row.QuantityStockReserved	- (CurrentQuantity + Quantity);
				
				Dates = Template.GetArea("Dates");
				Dates.Parameters.Fill(Row);
				Dates.Parameters.CanBeReservedDate = Row.Period;
				ItemInfoDetailRow.Put(Dates, 2);
 	
			EndDo;
		EndIf;
	EndIf;
	
	Quantity = Quantity + CurrentQuantity;
EndProcedure