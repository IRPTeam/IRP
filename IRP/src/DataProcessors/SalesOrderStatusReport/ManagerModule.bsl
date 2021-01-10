Function GenerateReport(Params, AddInfo = Undefined) Export

	QueryInfo = GetReportData(Params);
	Data = QueryInfo[4].Unload(QueryResultIteration.ByGroups);
	StockBalance = QueryInfo[5].Unload();
	StockInPeriod = StockBalance.Copy();
	StockBalance.GroupBy("Period, ItemKey", "QuantityBalance");
	StockBalance.Sort("Period");
	StockBalance.Indexes.Add("ItemKey");
	For Each Order In Data.Rows Do
		For Each ItemInfo In Order.Rows Do
			ItemInfo.ItemName = String(ItemInfo.ItemKey.Item) + " (" + ItemInfo.ItemKey + ")";
			FreeStock = ItemInfo.FreeStock;
			For Each ItemInfoDetail In ItemInfo.Rows Do
				ItemInfoDetail.ItemName = ItemInfo.ItemName;
				If ItemInfoDetail.ProcurementMethod = Enums.ProcurementMethods.Stock Then
					If FreeStock - ItemInfoDetail.Quantity >= 0 Then
						ItemInfoDetail.CanBeReserved = ItemInfoDetail.Quantity;
						If ItemInfoDetail.DeliveryDate = Date(1, 1, 1) Then
							ItemInfoDetail.MaxDeliveryDate = CurrentDate();
						Else
							ItemInfoDetail.MaxDeliveryDate = ItemInfoDetail.DeliveryDate;
						EndIf;
						
					Else
						ItemInfoDetail.CanBeReserved = FreeStock;
						ItemInfoDetail.NeedsToBeProcured = ItemInfoDetail.Quantity - FreeStock;
					EndIf;
					FreeStock = FreeStock - ItemInfoDetail.CanBeReserved;
				EndIf;
			EndDo;

			For Each ItemInfoDetail In ItemInfo.Rows Do
						// if we have to wait some income
				If Not ItemInfoDetail.NeedsToBeProcured > 0 Then
					Continue;
				EndIf;
				TotalBalance = 	StockBalance.FindRows(New Structure("ItemKey", ItemInfoDetail.ItemKey));				
					
					// if nothing wait for Item key, just interrupt
				If Not TotalBalance.Count() Then
					Break;
				EndIf;
					
					// check - if we got smth at the end of the period, if nothing - just say maximum and break
				If TotalBalance[TotalBalance.Count() - 1].QuantityBalance < ItemInfoDetail.NeedsToBeProcured Then
					ItemInfoDetail.WaitForIncome = TotalBalance[TotalBalance.Count() - 1].QuantityBalance;
					Break;
				EndIf;
				isSet = False;
				For Each Row In TotalBalance Do
					If Row.QuantityBalance >= ItemInfoDetail.NeedsToBeProcured And Not isSet Then
						ItemInfoDetail.WaitForIncome = ItemInfoDetail.NeedsToBeProcured;
						Row.QuantityBalance = Row.QuantityBalance - ItemInfoDetail.NeedsToBeProcured;
						ItemInfoDetail.MaxDeliveryDate = Row.Period;
						isSet = True;
					ElsIf isSet Then // when we already say that we reserved smth - we have to minus it from other period
						Row.QuantityBalance = Row.QuantityBalance - ItemInfoDetail.NeedsToBeProcured;
					Else
						Continue;
					EndIf;
				EndDo;
			EndDo;
			
			CalculateMaxDate(ItemInfo, "MaxDeliveryDate");
			CalculateMaxDate(ItemInfo, "DeliveryDate");
		EndDo;
		CalculateMaxDate(Order, "MaxDeliveryDate");
		CalculateMaxDate(Order, "DeliveryDate");
	EndDo;
	TabDoc = New SpreadsheetDocument;
	Template = DataProcessors.SalesOrderStatusReport.GetTemplate("ReportTemplate");

	TabDoc.Put(Template.GetArea("Splash"));

	TabDoc.Put(GenerateTabDoc(Data, Template));
	
	TabDoc.Put(Template.GetArea("Splash"));

	GeneratePeriodInfo(TabDoc, Params);
	
	Return TabDoc;
EndFunction

Procedure CalculateMaxDate(TreeRow, ColumnName)
	Var MaxDate;
	MaxDate = Date(1, 1, 1);
	For Each ItemInfoDetail In TreeRow.Rows Do
		If ItemInfoDetail[ColumnName] = Date(1, 1, 1) Then
			MaxDate = Date(1, 1, 1);
			Break;
		ElsIf ItemInfoDetail[ColumnName] > MaxDate Then
			MaxDate = ItemInfoDetail[ColumnName];
		EndIf;
	EndDo;
	TreeRow[ColumnName] = MaxDate;
EndProcedure

Function GenerateTabDoc(Data, Template)
	TabDoc = New SpreadsheetDocument;	
	Title = Template.GetArea("Title");
	TabDoc.Put(Title);

	For Each Order In Data.Rows Do
		OrderRow = Template.GetArea("OrderRow");
		OrderRow.Parameters.Fill(Order);
		
		ColorDate(OrderRow.Area("OrderRow|DeliveryDateOrder"), Order);
		
		TabDoc.Put(OrderRow);
		TabDoc.StartRowGroup();
		For Each ItemInfo In Order.Rows Do
			ItemInfoRow = Template.GetArea("ItemInfoRow");
			ItemInfoRow.Parameters.Fill(ItemInfo);
			
			ColorDate(ItemInfoRow.Area("ItemInfoRow|ItemRowDeliveryDate"), ItemInfo);
			
			ItemInfoRow.StartRowGroup();
			For Each ItemInfoDetail In ItemInfo.Rows Do
				ItemInfoDetailRow = Template.GetArea("ItemInfoDetail");
				ItemInfoDetailRow.Parameters.Fill(ItemInfoDetail);
				ColorDate(ItemInfoDetailRow.Area("ItemInfoDetail|ItemInfoDetailDeliveryDate"), ItemInfoDetail);
				ItemInfoRow.Put(ItemInfoDetailRow, 2);
			EndDo;
			ItemInfoRow.EndRowGroup();
			TabDoc.Put(ItemInfoRow, 1);
		EndDo;
		TabDoc.EndRowGroup();
	EndDo;
	TabDoc.ShowRowGroupLevel(1);
	Return TabDoc;
EndFunction

Function GeneratePeriodInfo(TabDoc, Params)
	//TabDoc = New SpreadsheetDocument();
    DataCompositionSchema = DataProcessors.SalesOrderStatusReport.GetTemplate("TemplateStock");
	SettingsComposer = New DataCompositionSettingsComposer();
    SettingsComposer.Initialize(New DataCompositionAvailableSettingsSource(DataCompositionSchema));
    SettingsComposer.LoadSettings(DataCompositionSchema.DefaultSettings);
    Settings = SettingsComposer.Settings;
    Settings.DataParameters.SetParameterValue("SalesOrderArray",         Params.SalesOrders);
	Settings.DataParameters.SetParameterValue("EndOfTheDate",         Params.EndOfTheDate);
	Settings.DataParameters.SetParameterValue("CurrentDate", BegOfDay(CurrentSessionDate()));

    DetailsData = New DataCompositionDetailsData;
    TemplateComposer = New DataCompositionTemplateComposer;
    CompTemplate = TemplateComposer.Execute(DataCompositionSchema, Settings, DetailsData);
    DataCompositionProcessor = New DataCompositionProcessor;
    DataCompositionProcessor.Initialize(CompTemplate, , DetailsData);
    
    OutputProcessor = New DataCompositionResultSpreadsheetDocumentOutputProcessor;
    OutputProcessor.SetDocument(TabDoc);

    OutputProcessor.Output(DataCompositionProcessor);
	
	Return TabDoc;
EndFunction

Procedure ColorDate(TabRow, ItemInfoDetail)
	If ItemInfoDetail.MaxDeliveryDate = Date(1, 1, 1) Then
		TabRow.BackColor = WebColors.MistyRose;
	ElsIf ItemInfoDetail.MaxDeliveryDate > ItemInfoDetail.DeliveryDate Then
		TabRow.BackColor = WebColors.Cyan;
	Else
		TabRow.BackColor = WebColors.GreenYellow;
	EndIf;
EndProcedure

Function GetReportData(Params)

	Query = New Query;
	Query.SetParameter("SalesOrderArray", Params.SalesOrders);
	Query.SetParameter("EndOfTheDate", Params.EndOfTheDate);

	Query.SetParameter("CurrentDate", BegOfDay(CurrentSessionDate()));

	Query.Text =
	"SELECT
	|	SalesOrderItemList.Ref AS SalesOrder,
	|	SalesOrderItemList.Key AS RowKey,
	|	SalesOrderItemList.Cancel AS Cancel,
	|	SalesOrderItemList.ItemKey AS ItemKey,
	|	SalesOrderItemList.Quantity AS QuantityInUnit,
	|	SalesOrderItemList.Unit AS Unit,
	|	SalesOrderItemList.DeliveryDate AS DeliveryDate,
	|	SalesOrderItemList.Store AS Store,
	|	SalesOrderItemList.ProcurementMethod AS ProcurementMethod,
	|	SalesOrderItemList.QuantityInBaseUnit AS Quantity
	|INTO SalesOrderItemList
	|FROM
	|	Document.SalesOrder.ItemList AS SalesOrderItemList
	|WHERE
	|	SalesOrderItemList.Ref IN(&SalesOrderArray)
	|	AND NOT SalesOrderItemList.Cancel
	|	AND NOT SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Purchase)
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
	|	SalesOrderItemList.ProcurementMethod AS ProcurementMethod,
	|	SalesOrderItemList.QuantityInUnit AS QuantityInUnit
	|INTO ItemsData
	|FROM
	|	SalesOrderItemList AS SalesOrderItemList
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	NestedSelect.ItemKey AS ItemKey,
	|	ISNULL(SUM(NestedSelect.ActualStock), 0) AS ActualStock,
	|	ISNULL(SUM(NestedSelect.FreeStock), 0) AS FreeStock
	|INTO StockInfo
	|FROM
	|	(SELECT
	|		R4010B_ActualStocksBalance.ItemKey AS ItemKey,
	|		R4010B_ActualStocksBalance.QuantityBalance AS ActualStock,
	|		0 AS FreeStock
	|	FROM
	|		AccumulationRegister.R4010B_ActualStocks.Balance(&EndOfTheDate, ) AS R4010B_ActualStocksBalance
	|	
	|	UNION ALL
	|	
	|	SELECT
	|		R4011B_FreeStocksBalance.ItemKey,
	|		0,
	|		R4011B_FreeStocksBalance.QuantityBalance
	|	FROM
	|		AccumulationRegister.R4011B_FreeStocks.Balance(&EndOfTheDate, ) AS R4011B_FreeStocksBalance) AS NestedSelect
	|
	|GROUP BY
	|	NestedSelect.ItemKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R2013T_SalesOrdersProcurementTurnovers.ItemKey AS ItemKey,
	|	SUM(R2013T_SalesOrdersProcurementTurnovers.OrderedQuantityTurnover) AS OrderedQuantityTurnover,
	|	SUM(R2013T_SalesOrdersProcurementTurnovers.ReOrderedQuantityTurnover) AS ReOrderedQuantityTurnover,
	|	SUM(R2013T_SalesOrdersProcurementTurnovers.PurchaseQuantityTurnover) AS PurchaseQuantityTurnover
	|INTO SalesOrdersProcurement
	|FROM
	|	AccumulationRegister.R2013T_SalesOrdersProcurement.Turnovers(, , , Order IN (&SalesOrderArray)) AS R2013T_SalesOrdersProcurementTurnovers
	|
	|GROUP BY
	|	R2013T_SalesOrdersProcurementTurnovers.ItemKey
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
	|	CAST("""" AS STRING(250)) AS ItemName,
	|	ItemsData.QuantityInUnit AS QuantityInUnit,
	|	ISNULL(StockInfo.ActualStock, 0) AS ActualStock,
	|	ISNULL(StockInfo.FreeStock, 0) AS FreeStock,
	|	0 AS CanBeReserved,
	|	0 AS NeedsToBeProcured,
	|	0 AS WaitForIncome,
	|	ItemsData.ProcurementMethod AS ProcurementMethod,
	|	DATETIME(1, 1, 1) AS MaxDeliveryDate,
	|	SalesOrdersProcurement.OrderedQuantityTurnover AS OrderedQuantity,
	|	SalesOrdersProcurement.ReOrderedQuantityTurnover AS ReOrderedQuantity,
	|	SalesOrdersProcurement.PurchaseQuantityTurnover AS PurchaseQuantity
	|FROM
	|	ItemsData AS ItemsData
	|		LEFT JOIN StockInfo AS StockInfo
	|		ON ItemsData.ItemKey = StockInfo.ItemKey
	|		LEFT JOIN SalesOrdersProcurement AS SalesOrdersProcurement
	|		ON ItemsData.ItemKey = SalesOrdersProcurement.ItemKey
	|
	|ORDER BY
	|	DeliveryDate,
	|	OrderedQuantity,
	|	ReOrderedQuantity,
	|	PurchaseQuantity
	|TOTALS
	|	SUM(Quantity),
	|	MAX(ActualStock),
	|	MAX(FreeStock),
	|	MAX(OrderedQuantity),
	|	MAX(ReOrderedQuantity),
	|	MAX(PurchaseQuantity)
	|BY
	|	SalesOrder,
	|	ItemKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	NestedSelect.ItemKey AS ItemKey,
	|	NestedSelect.Period AS Period,
	|	NestedSelect.Store AS Store,
	|	ISNULL(SUM(NestedSelect.QuantityBalance), 0) AS QuantityBalance,
	|	ISNULL(SUM(NestedSelect.QuantityActualStocks), 0) AS QuantityActualStocks,
	|	ISNULL(SUM(NestedSelect.QuantityShipment), 0) AS QuantityShipment,
	|	ISNULL(SUM(NestedSelect.QuantityReceipt), 0) AS QuantityReceipt
	|FROM
	|	(SELECT
	|		R4010B_ActualStocksBalanceAndTurnovers.ItemKey AS ItemKey,
	|		R4010B_ActualStocksBalanceAndTurnovers.Store AS Store,
	|		R4010B_ActualStocksBalanceAndTurnovers.Period AS Period,
	|		0 AS QuantityBalance,
	|		R4010B_ActualStocksBalanceAndTurnovers.QuantityClosingBalance AS QuantityActualStocks,
	|		0 AS QuantityShipment,
	|		0 AS QuantityReceipt
	|	FROM
	|		AccumulationRegister.R4010B_ActualStocks.BalanceAndTurnovers(
	|				&CurrentDate,
	|				&EndOfTheDate,
	|				Day,
	|				,
	|				ItemKey IN
	|					(SELECT
	|						T.ItemKey
	|					FROM
	|						ItemsData AS T)) AS R4010B_ActualStocksBalanceAndTurnovers
	|	
	|	UNION ALL
	|	
	|	SELECT
	|		R4034B_GoodsShipmentSchedule.ItemKey,
	|		R4034B_GoodsShipmentSchedule.Store,
	|		R4034B_GoodsShipmentSchedule.Period,
	|		-R4034B_GoodsShipmentSchedule.QuantityClosingBalance,
	|		0,
	|		R4034B_GoodsShipmentSchedule.QuantityClosingBalance,
	|		0
	|	FROM
	|		AccumulationRegister.R4034B_GoodsShipmentSchedule.BalanceAndTurnovers(
	|				&CurrentDate,
	|				&EndOfTheDate,
	|				Day,
	|				,
	|				ItemKey IN
	|					(SELECT
	|						T.ItemKey
	|					FROM
	|						ItemsData AS T)) AS R4034B_GoodsShipmentSchedule
	|	
	|	UNION ALL
	|	
	|	SELECT
	|		R4033B_GoodsReceiptScheduleBalanceAndTurnovers.ItemKey,
	|		R4033B_GoodsReceiptScheduleBalanceAndTurnovers.Store,
	|		R4033B_GoodsReceiptScheduleBalanceAndTurnovers.Period,
	|		R4033B_GoodsReceiptScheduleBalanceAndTurnovers.QuantityClosingBalance,
	|		0,
	|		0,
	|		R4033B_GoodsReceiptScheduleBalanceAndTurnovers.QuantityClosingBalance
	|	FROM
	|		AccumulationRegister.R4033B_GoodsReceiptSchedule.BalanceAndTurnovers(
	|				&CurrentDate,
	|				&EndOfTheDate,
	|				Day,
	|				,
	|				ItemKey IN
	|					(SELECT
	|						T.ItemKey
	|					FROM
	|						ItemsData AS T)) AS R4033B_GoodsReceiptScheduleBalanceAndTurnovers) AS NestedSelect
	|
	|GROUP BY
	|	NestedSelect.Period,
	|	NestedSelect.ItemKey,
	|	NestedSelect.Store
	|
	|ORDER BY
	|	ItemKey,
	|	Period";

	QueryResult = Query.ExecuteBatch();

	Return QueryResult;
EndFunction