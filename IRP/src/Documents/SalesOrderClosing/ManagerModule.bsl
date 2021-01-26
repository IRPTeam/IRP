#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	Parameters.IsReposting = False;
	
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParamenters(Ref));
	;
	PostingServer.ExequteQuery(Ref, QueryArray, Parameters);
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();

	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;	
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
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
	PostingServer.GetLockDataSource(DataMapWithLockFields, DocumentDataTables);
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
	
	Return;

EndProcedure

#EndRegion

#Region NewRegistersPosting

Function GetAdditionalQueryParamenters(Ref)
	
	StrParams = New Structure();
	StrParams.Insert("SalesOrder", Ref.SalesOrder);
	StrParams.Insert("Period", Ref.Date);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	Return QueryArray;	
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R2010T_SalesOrders());
	QueryArray.Add(R2011B_SalesOrdersShipment());
	QueryArray.Add(R2012B_SalesOrdersInvoiceClosing());
	QueryArray.Add(R2013T_SalesOrdersProcurement());
	QueryArray.Add(R2014T_CanceledSalesOrders());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4012B_StockReservation());
	QueryArray.Add(R4013B_StockReservationPlanning());
	QueryArray.Add(R4034B_GoodsShipmentSchedule());
	Return QueryArray;	
EndFunction	

Function ItemList()

	Return
		"SELECT
		|	SalesOrderItemList.Ref.Company AS Company,
		|	SalesOrderItemList.Ref.ShipmentConfirmationsBeforeSalesInvoice AS ShipmentConfirmationsBeforeSalesInvoice,
		|	SalesOrderItemList.Store AS Store,
		|	SalesOrderItemList.Store.UseShipmentConfirmation AS UseShipmentConfirmation,
		|	SalesOrderItemList.ItemKey AS ItemKey,
		|	SalesOrderItemList.Ref.SalesOrder AS Order,
		|	SalesOrderItemList.Unit,
		|	SalesOrderItemList.ItemKey.Item AS Item,
		|	SalesOrderItemList.Key AS RowKey,
		|	SalesOrderItemList.DeliveryDate AS DeliveryDate,
		|	SalesOrderItemList.ProcurementMethod,
		|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Stock) AS IsProcurementMethod_Stock,
		|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Purchase) AS IsProcurementMethod_Purchase,
		|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.NoReserve) AS IsProcurementMethod_NonReserve,
		|	SalesOrderItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
		|	SalesOrderItemList.Ref.Currency AS Currency,
		|	SalesOrderItemList.Cancel AS IsCanceled,
		|	SalesOrderItemList.CancelReason,
		|	SalesOrderItemList.Ref.UseItemsShipmentScheduling AS UseItemsShipmentScheduling,
		|	SalesOrderItemList.Quantity AS UnitQuantity,
		|	SalesOrderItemList.QuantityInBaseUnit AS Quantity,
		|	SalesOrderItemList.OffersAmount,
		|	SalesOrderItemList.NetAmount,
		|	SalesOrderItemList.TotalAmount AS Amount
		|	INTO ItemListTmp
		|FROM
		|	Document.SalesOrderClosing.ItemList AS SalesOrderItemList
		|WHERE
		|	SalesOrderItemList.Ref = &Ref
		|
		|UNION ALL
		|
		|SELECT
		|	SalesOrderItemList.Ref.Company AS Company,
		|	SalesOrderItemList.Ref.ShipmentConfirmationsBeforeSalesInvoice AS ShipmentConfirmationsBeforeSalesInvoice,
		|	SalesOrderItemList.Store AS Store,
		|	SalesOrderItemList.Store.UseShipmentConfirmation AS UseShipmentConfirmation,
		|	SalesOrderItemList.ItemKey AS ItemKey,
		|	SalesOrderItemList.Ref AS Order,
		|	SalesOrderItemList.Unit,
		|	SalesOrderItemList.ItemKey.Item AS Item,
		|	SalesOrderItemList.Key AS RowKey,
		|	SalesOrderItemList.DeliveryDate AS DeliveryDate,
		|	SalesOrderItemList.ProcurementMethod,
		|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Stock) AS IsProcurementMethod_Stock,
		|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Purchase) AS IsProcurementMethod_Purchase,
		|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.NoReserve) AS IsProcurementMethod_NonReserve,
		|	SalesOrderItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
		|	SalesOrderItemList.Ref.Currency AS Currency,
		|	SalesOrderItemList.Cancel AS IsCanceled,
		|	SalesOrderItemList.CancelReason,
		|	SalesOrderItemList.Ref.UseItemsShipmentScheduling AS UseItemsShipmentScheduling,
		|	-SalesOrderItemList.Quantity AS UnitQuantity,
		|	-SalesOrderItemList.QuantityInBaseUnit AS Quantity,
		|	-SalesOrderItemList.OffersAmount,
		|	-SalesOrderItemList.NetAmount,
		|	-SalesOrderItemList.TotalAmount AS Amount
		|	FROM
		|	Document.SalesOrder.ItemList AS SalesOrderItemList
		|WHERE
		|	SalesOrderItemList.Ref = &SalesOrder AND SalesOrderItemList.Key IN (Select Key From Document.SalesOrderClosing.ItemList Where Ref = &Ref)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ItemListTmp.Company,
		|	ItemListTmp.ShipmentConfirmationsBeforeSalesInvoice,
		|	ItemListTmp.Store,
		|	ItemListTmp.UseShipmentConfirmation,
		|	ItemListTmp.ItemKey,
		|	ItemListTmp.Order,
		|	ItemListTmp.Unit,
		|	ItemListTmp.Item,
		|	ItemListTmp.RowKey,
		|	ItemListTmp.DeliveryDate,
		|	ItemListTmp.ProcurementMethod,
		|	ItemListTmp.IsProcurementMethod_Stock,
		|	ItemListTmp.IsProcurementMethod_Purchase,
		|	ItemListTmp.IsProcurementMethod_NonReserve,
		|	ItemListTmp.IsService,
		|	ItemListTmp.Currency,
		|	ItemListTmp.IsCanceled,
		|	ItemListTmp.CancelReason,
		|	ItemListTmp.UseItemsShipmentScheduling,
		|	SUM(ItemListTmp.UnitQuantity) AS UnitQuantity,
		|	SUM(ItemListTmp.Quantity) AS Quantity,
		|	SUM(ItemListTmp.OffersAmount) AS OffersAmount,
		|	SUM(ItemListTmp.NetAmount) AS NetAmount,
		|	SUM(ItemListTmp.Amount) AS Amount,
		|	&Period AS Period
		|INTO ItemList
		|FROM
		|	ItemListTmp AS ItemListTmp
		|GROUP BY
		|	ItemListTmp.Company,
		|	ItemListTmp.ShipmentConfirmationsBeforeSalesInvoice,
		|	ItemListTmp.Store,
		|	ItemListTmp.UseShipmentConfirmation,
		|	ItemListTmp.ItemKey,
		|	ItemListTmp.Order,
		|	ItemListTmp.Unit,
		|	ItemListTmp.Item,
		|	ItemListTmp.RowKey,
		|	ItemListTmp.DeliveryDate,
		|	ItemListTmp.ProcurementMethod,
		|	ItemListTmp.IsProcurementMethod_Stock,
		|	ItemListTmp.IsProcurementMethod_Purchase,
		|	ItemListTmp.IsProcurementMethod_NonReserve,
		|	ItemListTmp.IsService,
		|	ItemListTmp.Currency,
		|	ItemListTmp.IsCanceled,
		|	ItemListTmp.CancelReason,
		|	ItemListTmp.UseItemsShipmentScheduling";
EndFunction

Function R2010T_SalesOrders()
	Return
		"SELECT *
		|INTO R2010T_SalesOrders
		|FROM
		|	ItemList AS QueryTable
		|WHERE NOT QueryTable.isCanceled";

EndFunction

Function R2011B_SalesOrdersShipment()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R2011B_SalesOrdersShipment
		|FROM
		|	ItemList AS QueryTable
		|WHERE NOT QueryTable.isCanceled
		|	AND NOT QueryTable.IsService";

EndFunction

Function R2012B_SalesOrdersInvoiceClosing()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R2012B_SalesOrdersInvoiceClosing
		|FROM
		|	ItemList AS QueryTable
		|WHERE NOT QueryTable.isCanceled";

EndFunction

Function R2013T_SalesOrdersProcurement()
	Return
		"SELECT 
		|QueryTable.Quantity AS OrderedQuantity,
		|*
		|INTO R2013T_SalesOrdersProcurement
		|FROM
		|	ItemList AS QueryTable
		|WHERE NOT QueryTable.isCanceled AND NOT QueryTable.IsService
		|	AND QueryTable.IsProcurementMethod_Purchase";

EndFunction

Function R2014T_CanceledSalesOrders()
	Return
		"SELECT *
		|INTO R2014T_CanceledSalesOrders
		|FROM
		|	ItemList AS QueryTable
		|WHERE QueryTable.isCanceled";

EndFunction

Function R4011B_FreeStocks()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	*
		|INTO R4011B_FreeStocks
		|FROM
		|	ItemList AS QueryTable
		|WHERE NOT QueryTable.isCanceled AND NOT QueryTable.IsService
		|	AND QueryTable.IsProcurementMethod_Stock";

EndFunction

Function R4012B_StockReservation()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R4012B_StockReservation
		|FROM
		|	ItemList AS QueryTable
		|WHERE  NOT QueryTable.isCanceled AND NOT QueryTable.IsService
		|	AND QueryTable.IsProcurementMethod_Stock";

EndFunction

Function R4013B_StockReservationPlanning()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R4013B_StockReservationPlanning
		|FROM
		|	ItemList AS QueryTable
		|WHERE FALSE";

EndFunction

Function R4034B_GoodsShipmentSchedule()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	CASE WHEN QueryTable.DeliveryDate = DATETIME(1, 1, 1) THEN
		|		QueryTable.Period
		|	ELSE
		|		QueryTable.DeliveryDate
		|	END AS Period,
		|	QueryTable.Order AS Basis,
		|	*
		|
		|INTO R4034B_GoodsShipmentSchedule
		|FROM
		|	ItemList AS QueryTable
		|WHERE NOT QueryTable.isCanceled 
		|	AND NOT QueryTable.IsService
		|	AND QueryTable.IsProcurementMethod_Stock
		|	AND QueryTable.UseItemsShipmentScheduling";

EndFunction

#EndRegion
