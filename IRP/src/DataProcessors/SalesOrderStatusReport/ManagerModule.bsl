
Function GenerateReport(Params, AddInfo = Undefined) Export
	Template = DataProcessors.SalesOrderStatusReport.GetTemplate("ReportTemplate");
	TabDoc = New SpreadsheetDocument;
	
	Data = GetReportData(Params);
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
			ItemInfoRow.Parameters.ItemInfo = String(ItemInfo.ItemKey.Item) + " (" + ItemInfo.ItemKey + ")";
			ItemInfoRow.Parameters.QuantityPurchase = "" + ItemInfo.QuantityForPurchase + " / " + ItemInfo.QuantityPurchased;
			ItemInfoRow.Parameters.QuantityReserve = "" + ItemInfo.QuantityReservedOnStock + " / " + ItemInfo.QuantityShippedFromStock;
			
			Quantity = 0; 
			If ItemInfo.Rows.Count() > 1 Then
				ItemInfoRow.StartRowGroup();	
				For Each ItemInfoDetail In ItemInfo.Rows Do
					ItemInfoDetailRow = Template.GetArea("ItemInfoDetail");
					ItemInfoDetailRow.Parameters.Fill(ItemInfoDetail);
					ItemInfoDetailRow.Parameters.ItemInfo = String(ItemInfoDetail.ItemKey.Item) + " (" + ItemInfoDetail.ItemKey + ")";
					ItemInfoDetailRow.Parameters.QuantityPurchase = "" + ItemInfoDetail.QuantityForPurchase + " / " + ItemInfoDetail.QuantityPurchased;
					ItemInfoDetailRow.Parameters.QuantityReserve = "" + ItemInfoDetail.QuantityReservedOnStock + " / " + ItemInfoDetail.QuantityShippedFromStock;
					ItemInfoRow.Put(ItemInfoDetailRow, 2);
					UnitFactor = Catalogs.Units.GetUnitFactor(ItemInfoDetail.Unit, ItemInfoDetail.ItemKey.Unit);
					Quantity = Quantity + UnitFactor * ItemInfoDetailRow.Parameters.Quantity;
				EndDo;			
				ItemInfoRow.EndRowGroup();
			Else
				UnitFactor = Catalogs.Units.GetUnitFactor(ItemInfo.Rows[0].Unit, ItemInfo.Rows[0].ItemKey.Unit);
				Quantity = ItemInfo.Rows[0].Quantity * UnitFactor;
			EndIf;
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

	Query.Text =
		"SELECT
		|	SalesOrderItemList.Ref AS SalesOrder,
		|	SalesOrderItemList.Key AS RowKeyUUID,
		|	SalesOrderItemList.Cancel,
		|	SalesOrderItemList.ItemKey AS ItemKey,
		|	SalesOrderItemList.Quantity AS Quantity,
		|	SalesOrderItemList.Unit,
		|	SalesOrderItemList.DeliveryDate,
		|	SalesOrderItemList.Store,
		|	SalesOrderItemList.ProcurementMethod
		|FROM
		|	Document.SalesOrder.ItemList AS SalesOrderItemList
		|WHERE
		|	SalesOrderItemList.Ref IN (&SalesOrderArray)";
	Query.SetParameter("SalesOrderArray", Params.SalesOrders);
	SalesOrderItemList = Query.Execute().Unload();
	
	PostingServer.UUIDToString(SalesOrderItemList);
	
	Query = New Query;
	Query.TempTablesManager = New TempTablesManager();
	Query.SetParameter("SalesOrderItemList", SalesOrderItemList);
	
	Query.Text =
		"SELECT
		|	SalesOrderItemList.SalesOrder,
		|	SalesOrderItemList.RowKeyUUID,
		|	SalesOrderItemList.RowKey,
		|	SalesOrderItemList.Cancel,
		|	SalesOrderItemList.ItemKey,
		|	SalesOrderItemList.Quantity,
		|	SalesOrderItemList.Unit,
		|	SalesOrderItemList.DeliveryDate,
		|	SalesOrderItemList.Store,
		|	SalesOrderItemList.ProcurementMethod
		|INTO ItemsData
		|FROM
		|	&SalesOrderItemList AS SalesOrderItemList
		|
		|INDEX BY
		|	ItemKey,
		|	SalesOrder,
		|	RowKey
		|;
		|
		|
		|
		|
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
		|		-StockReservationBalance.QuantityBalance
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
		|
		|
		|
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ItemsData.SalesOrder,
		|	ItemsData.RowKey,
		|	ItemsData.Cancel,
		|	ItemsData.ItemKey,
		|	ItemsData.Quantity,
		|	ItemsData.Unit,
		|	ItemsData.DeliveryDate,
		|	ItemsData.Store,
		|	ItemsData.ProcurementMethod,
		|	CASE
		|		WHEN OrderProcurement.RecordType = VALUE(AccumulationRecordType.Receipt)
		|			THEN OrderProcurement.Quantity
		|		ELSE 0
		|	END AS QuantityForPurchase,
		|	CASE
		|		WHEN OrderProcurement.RecordType = VALUE(AccumulationRecordType.Expense)
		|			THEN OrderProcurement.Quantity
		|		ELSE 0
		|	END AS QuantityPurchased,
		|	CASE
		|		WHEN OrderBalance.RecordType = VALUE(AccumulationRecordType.Receipt)
		|			THEN OrderBalance.Quantity
		|		ELSE 0
		|	END AS QuantityReservedOnStock,
		|	CASE
		|		WHEN OrderBalance.RecordType = VALUE(AccumulationRecordType.Expense)
		|			THEN OrderBalance.Quantity
		|		ELSE 0
		|	END AS QuantityShippedFromStock,
		|	StockInfo.QuantityStock,
		|	StockInfo.QuantityStockReservation,
		|	StockInfo.QuantityStock - StockInfo.QuantityStockReservation AS QuantityStockFree
		|INTO ItemsWithReserve
		|FROM
		|	ItemsData AS ItemsData
		|		LEFT JOIN AccumulationRegister.OrderProcurement AS OrderProcurement
		|		ON ItemsData.SalesOrder = OrderProcurement.Order
		|		AND ItemsData.RowKey = OrderProcurement.RowKey
		|		LEFT JOIN AccumulationRegister.OrderBalance AS OrderBalance
		|		ON ItemsData.SalesOrder = OrderBalance.Order
		|		AND ItemsData.RowKey = OrderBalance.RowKey
		|		LEFT JOIN StockInfo AS StockInfo
		|		ON ItemsData.ItemKey = StockInfo.ItemKey
		|;
		|
		|
		|
		|
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ItemsWithReserve.SalesOrder AS SalesOrder,
		|	ItemsWithReserve.RowKey,
		|	ItemsWithReserve.Cancel,
		|	ItemsWithReserve.ItemKey AS ItemKey,
		|	ItemsWithReserve.Quantity AS Quantity,
		|	ItemsWithReserve.Unit,
		|	ItemsWithReserve.DeliveryDate,
		|	ItemsWithReserve.Store,
		|	ItemsWithReserve.ProcurementMethod,
		|	ItemsWithReserve.QuantityForPurchase AS QuantityForPurchase,
		|	ItemsWithReserve.QuantityPurchased AS QuantityPurchased,
		|	ItemsWithReserve.QuantityReservedOnStock AS QuantityReservedOnStock,
		|	ItemsWithReserve.QuantityShippedFromStock AS QuantityShippedFromStock,
		|	ItemsWithReserve.QuantityStock AS QuantityStock,
		|	ItemsWithReserve.QuantityStockReservation AS QuantityStockReservation,
		|	ItemsWithReserve.QuantityStockFree AS QuantityStockFree
		|FROM
		|	ItemsWithReserve AS ItemsWithReserve
		|TOTALS
		|	MAX(QuantityStock) AS QuantityStock,
		|	MAX(QuantityStockReservation) AS QuantityStockReservation,
		|	MAX(QuantityStockFree) AS QuantityStockFree,
		|	MAX(QuantityForPurchase) AS QuantityForPurchase,
		|	MAX(QuantityPurchased) AS QuantityPurchased,
		|	MAX(QuantityReservedOnStock) AS QuantityReservedOnStock,
		|	MAX(QuantityShippedFromStock) AS QuantityShippedFromStock
		|BY
		|	SalesOrder,
		|	ItemKey";
	

	QueryResult = Query.Execute().Unload(QueryResultIteration.ByGroups);
		
	Return QueryResult;
EndFunction
