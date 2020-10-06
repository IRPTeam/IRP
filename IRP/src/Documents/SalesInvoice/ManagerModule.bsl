#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("OrderBalance"                         , PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("OrderReservation"                     , PostingServer.CreateTable(AccReg.OrderReservation));
	Tables.Insert("StockReservation"                     , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("InventoryBalance"                     , PostingServer.CreateTable(AccReg.InventoryBalance));
	Tables.Insert("SalesTurnovers"                       , PostingServer.CreateTable(AccReg.SalesTurnovers));
	Tables.Insert("GoodsInTransitOutgoing"               , PostingServer.CreateTable(AccReg.GoodsInTransitOutgoing));
	Tables.Insert("StockBalance"                         , PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("ShipmentOrders"                       , PostingServer.CreateTable(AccReg.ShipmentOrders));
	Tables.Insert("PartnerArTransactions"                , PostingServer.CreateTable(AccReg.PartnerArTransactions));
	Tables.Insert("AdvanceFromCustomers_Lock"            , PostingServer.CreateTable(AccReg.AdvanceFromCustomers));
	Tables.Insert("AdvanceFromCustomers_Registrations"   , PostingServer.CreateTable(AccReg.AdvanceFromCustomers));
	Tables.Insert("ShipmentConfirmationSchedule_Expense" , PostingServer.CreateTable(AccReg.ShipmentConfirmationSchedule));
	Tables.Insert("ShipmentConfirmationSchedule_Receipt" , PostingServer.CreateTable(AccReg.ShipmentConfirmationSchedule));
	Tables.Insert("ReconciliationStatement"              , PostingServer.CreateTable(AccReg.ReconciliationStatement));
	Tables.Insert("TaxesTurnovers"                       , PostingServer.CreateTable(AccReg.TaxesTurnovers));
	Tables.Insert("RevenuesTurnovers"                    , PostingServer.CreateTable(AccReg.RevenuesTurnovers));
	
	Tables.Insert("OrderBalance_Exists"           , PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("GoodsInTransitOutgoing_Exists" , PostingServer.CreateTable(AccReg.GoodsInTransitOutgoing));
	Tables.Insert("ShipmentOrders_Exists"         , PostingServer.CreateTable(AccReg.ShipmentOrders));
	
	Tables.OrderBalance_Exists           = AccReg.OrderBalance.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo);
	Tables.GoodsInTransitOutgoing_Exists = AccReg.GoodsInTransitOutgoing.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	Tables.ShipmentOrders_Exists         = AccReg.ShipmentOrders.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo); 
	
	QueryItemList = New Query();
	QueryItemList.Text = GetQueryTextSalesInvoiceItemList();
	QueryItemList.SetParameter("Ref", Ref);
	QueryResultItemList = QueryItemList.Execute();
	QueryTableItemList = QueryResultItemList.Unload();
	PostingServer.CalculateQuantityByUnit(QueryTableItemList);
	PostingServer.UUIDToString(QueryTableItemList);
	
	QueryTaxList = New Query();
	QueryTaxList.Text = GetQueryTextSalesInvoiceTaxList();
	QueryTaxList.SetParameter("Ref", Ref);
	QueryResultTaxList = QueryTaxList.Execute();
	QueryTableTaxList = QueryResultTaxList.Unload();
	PostingServer.UUIDToString(QueryTableTaxList);
	
	QuerySalesTurnovers = New Query();
	QuerySalesTurnovers.Text = GetQueryTextSalesInvoiceSalesTurnovers();
	QuerySalesTurnovers.SetParameter("Ref", Ref);
	QueryResultSalesTurnovers = QuerySalesTurnovers.Execute();
	QueryTableSalesTurnovers = QueryResultSalesTurnovers.Unload();
	
	Query = New Query();
	Query.Text = GetQueryTextQueryTable();
	Query.SetParameter("QueryTable", QueryTableItemList);
	QueryResult = Query.ExecuteBatch();
	
	Tables.OrderBalance                         = QueryResult[1].Unload();
	Tables.OrderReservation                     = QueryResult[2].Unload();
	Tables.StockReservation                     = QueryResult[3].Unload();
	Tables.InventoryBalance                     = QueryResult[4].Unload();
	Tables.GoodsInTransitOutgoing               = QueryResult[5].Unload();
	Tables.StockBalance                         = QueryResult[6].Unload();
	Tables.ShipmentOrders                       = QueryResult[7].Unload();
	Tables.PartnerArTransactions                = QueryResult[8].Unload();
	Tables.AdvanceFromCustomers_Lock            = QueryResult[9].Unload();
	Tables.ShipmentConfirmationSchedule_Expense = QueryResult[10].Unload();
	Tables.ShipmentConfirmationSchedule_Receipt = QueryResult[11].Unload();
	Tables.ReconciliationStatement              = QueryResult[12].Unload();
	Tables.RevenuesTurnovers                    = QueryResult[13].Unload();
	
	Tables.TaxesTurnovers = QueryTableTaxList;
	Tables.SalesTurnovers = QueryTableSalesTurnovers;
		
	Return Tables;
EndFunction

Function GetQueryTextSalesInvoiceSalesTurnovers()
	Return "SELECT
	|	SalesInvoiceItemList.Ref.Company AS Company,
	|	SalesInvoiceItemList.Ref.Currency AS Currency,
	|	SalesInvoiceItemList.ItemKey AS ItemKey,
	|	SUM(SalesInvoiceItemList.Quantity) AS Quantity,
	|	SUM(ISNULL(SalesInvoiceSerialLotNumbers.Quantity, 0)) AS QuantityBySerialLtNumbers,
	|	SalesInvoiceItemList.Ref.Date AS Period,
	|	SalesInvoiceItemList.Ref AS SalesInvoice,
	|	SUM(SalesInvoiceItemList.TotalAmount) AS Amount,
	|	SUM(SalesInvoiceItemList.NetAmount) AS NetAmount,
	|	SUM(SalesInvoiceItemList.OffersAmount) AS OffersAmount,
	|	SalesInvoiceItemList.Key AS RowKey,
	|	SalesInvoiceSerialLotNumbers.SerialLotNumber AS SerialLotNumber
	|INTO tmp
	|FROM
	|	Document.SalesInvoice.ItemList AS SalesInvoiceItemList
	|		LEFT JOIN Document.SalesInvoice.SerialLotNumbers AS SalesInvoiceSerialLotNumbers
	|		ON SalesInvoiceItemList.Key = SalesInvoiceSerialLotNumbers.Key
	|		AND SalesInvoiceItemList.Ref = SalesInvoiceSerialLotNumbers.Ref
	|		AND SalesInvoiceItemList.Ref = &Ref
	|		AND SalesInvoiceSerialLotNumbers.Ref = &Ref
	|WHERE
	|	SalesInvoiceItemList.Ref = &Ref
	|GROUP BY
	|	SalesInvoiceItemList.Ref.Company,
	|	SalesInvoiceItemList.Ref.Currency,
	|	SalesInvoiceItemList.ItemKey,
	|	SalesInvoiceItemList.Ref.Date,
	|	SalesInvoiceItemList.Ref,
	|	SalesInvoiceItemList.Key,
	|	SalesInvoiceSerialLotNumbers.SerialLotNumber
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Company AS Company,
	|	tmp.Currency AS Currency,
	|	tmp.ItemKey AS ItemKey,
	|	CASE
	|		WHEN tmp.QuantityBySerialLtNumbers = 0
	|			THEN tmp.Quantity
	|		ELSE tmp.QuantityBySerialLtNumbers
	|	END AS Quantity,
	|	tmp.Period AS Period,
	|	tmp.SalesInvoice AS SalesInvoice,
	|	tmp.RowKey AS RowKey,
	|	tmp.SerialLotNumber AS SerialLotNumber,
	|	CASE
	|		WHEN tmp.QuantityBySerialLtNumbers <> 0
	|			THEN CASE
	|				WHEN tmp.Quantity = 0
	|					THEN 0
	|				ELSE tmp.Amount / tmp.Quantity * tmp.QuantityBySerialLtNumbers
	|			END
	|		ELSE tmp.Amount
	|	END AS Amount,
	|	CASE
	|		WHEN tmp.QuantityBySerialLtNumbers <> 0
	|			THEN CASE
	|				WHEN tmp.Quantity = 0
	|					THEN 0
	|				ELSE tmp.NetAmount / tmp.Quantity * tmp.QuantityBySerialLtNumbers
	|			END
	|		ELSE tmp.NetAmount
	|	END AS NetAmount,
	|	CASE
	|		WHEN tmp.QuantityBySerialLtNumbers <> 0
	|			THEN CASE
	|				WHEN tmp.Quantity = 0
	|					THEN 0
	|				ELSE tmp.OffersAmount / tmp.Quantity * tmp.QuantityBySerialLtNumbers
	|			END
	|		ELSE tmp.OffersAmount
	|	END AS OffersAmount
	|FROM
	|	tmp AS tmp";
	
EndFunction

Function GetQueryTextSalesInvoiceItemList()
	Return
		"SELECT
		|	MAX(CASE
		|		WHEN ShipmentConfirmations.ShipmentConfirmation IS NULL
		|			THEN FALSE
		|		ELSE TRUE
		|	END) AS ShipmentConfirmationBeforeSalesInvoice,
		|	SalesInvoiceItemList.Ref AS Ref,
		|	SalesInvoiceItemList.Key AS Key
		|INTO tmp_ShipmentConfirmations
		|FROM
		|	Document.SalesInvoice.ItemList AS SalesInvoiceItemList
		|		LEFT JOIN Document.SalesInvoice.ShipmentConfirmations AS ShipmentConfirmations
		|		ON SalesInvoiceItemList.Ref = ShipmentConfirmations.Ref
		|		AND SalesInvoiceItemList.Key = ShipmentConfirmations.Key
		|		AND SalesInvoiceItemList.Ref = &Ref
		|		AND ShipmentConfirmations.Ref = &Ref
		|WHERE
		|	SalesInvoiceItemList.Ref = &Ref
		|GROUP BY
		|	SalesInvoiceItemList.Ref,
		|	SalesInvoiceItemList.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SalesInvoiceItemList.Ref.Company AS Company,
		|	SalesInvoiceItemList.Store AS Store,
		|	ShipmentConfirmations.ShipmentConfirmationBeforeSalesInvoice AS ShipmentConfirmationBeforeSalesInvoice,
		|	SalesInvoiceItemList.Store.UseShipmentConfirmation AS UseShipmentConfirmation,
		|	SalesInvoiceItemList.ItemKey AS ItemKey,
		|	SalesInvoiceItemList.Quantity AS Quantity,
		|	SalesInvoiceItemList.TotalAmount AS TotalAmount,
		|	SalesInvoiceItemList.Ref.Partner AS Partner,
		|	SalesInvoiceItemList.Ref.LegalName AS LegalName,
		|	CASE
		|		WHEN SalesInvoiceItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND SalesInvoiceItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN SalesInvoiceItemList.Ref.Agreement.StandardAgreement
		|		ELSE SalesInvoiceItemList.Ref.Agreement
		|	END AS Agreement,
		|	SalesInvoiceItemList.Ref.Currency AS Currency,
		|	0 AS BasisQuantity,
		|	SalesInvoiceItemList.Unit AS Unit,
		|	SalesInvoiceItemList.ItemKey.Item.Unit AS ItemUnit,
		|	SalesInvoiceItemList.ItemKey.Unit AS ItemKeyUnit,
		|	SalesInvoiceItemList.ItemKey.Item AS Item,
		|	SalesInvoiceItemList.Ref.Date AS Period,
		|	SalesInvoiceItemList.SalesOrder AS SalesOrder,
		|	CASE
		|		WHEN SalesInvoiceItemList.SalesOrder.Date IS NULL
		|			THEN FALSE
		|		ELSE TRUE
		|	END AS UseSalesOrder,
		|	SalesInvoiceItemList.Ref AS ShipmentBasis,
		|	SalesInvoiceItemList.Ref AS SalesInvoice,
		|	SalesInvoiceItemList.Key AS RowKeyUUID,
		|	SalesInvoiceItemList.Ref.IsOpeningEntry AS IsOpeningEntry,
		|	SalesInvoiceItemList.DeliveryDate AS DeliveryDate,
		|	CASE
		|		WHEN SalesInvoiceItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service)
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsService,
		|	SalesInvoiceItemList.BusinessUnit AS BusinessUnit,
		|	SalesInvoiceItemList.RevenueType AS RevenueType,
		|	SalesInvoiceItemList.AdditionalAnalytic AS AdditionalAnalytic,
		|	CASE
		|		WHEN SalesInvoiceItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN SalesInvoiceItemList.Ref
		|		ELSE UNDEFINED
		|	END AS BasisDocument,
		|	SalesInvoiceItemList.NetAmount AS NetAmount,
		|	SalesInvoiceItemList.OffersAmount AS OffersAmount
		|FROM
		|	Document.SalesInvoice.ItemList AS SalesInvoiceItemList
		|		LEFT JOIN tmp_ShipmentConfirmations AS ShipmentConfirmations
		|		ON SalesInvoiceItemList.Ref = ShipmentConfirmations.Ref
		|		AND SalesInvoiceItemList.Key = ShipmentConfirmations.Key
		|		AND SalesInvoiceItemList.Ref = &Ref
		|		AND ShipmentConfirmations.Ref = &Ref
		|WHERE
		|	SalesInvoiceItemList.Ref = &Ref";
EndFunction

Function GetQueryTextSalesInvoiceTaxList()
	Return
			"SELECT
		|	SalesInvoiceTaxList.Ref AS Document,
		|	SalesInvoiceTaxList.Ref.Date AS Period,
		|	SalesInvoiceTaxList.Ref.Currency AS Currency,
		|	SalesInvoiceTaxList.Key AS RowKeyUUID,
		|	SalesInvoiceTaxList.Tax AS Tax,
		|	SalesInvoiceTaxList.Analytics AS Analytics,
		|	SalesInvoiceTaxList.TaxRate AS TaxRate,
		|	SalesInvoiceTaxList.Amount AS Amount,
		|	SalesInvoiceTaxList.IncludeToTotalAmount AS IncludeToTotalAmount,
		|	SalesInvoiceTaxList.ManualAmount AS ManualAmount,
		|	SalesInvoiceItemList.NetAmount AS NetAmount
		|FROM
		|	Document.SalesInvoice.TaxList AS SalesInvoiceTaxList
		|		INNER JOIN Document.SalesInvoice.ItemList AS SalesInvoiceItemList
		|		ON SalesInvoiceTaxList.Ref = SalesInvoiceItemList.Ref
		|		AND SalesInvoiceItemList.Ref = &Ref
		|		AND SalesInvoiceTaxList.Ref = &Ref
		|		AND SalesInvoiceItemList.Key = SalesInvoiceTaxList.Key
		|WHERE
		|	SalesInvoiceTaxList.Ref = &Ref";
EndFunction

Function GetQueryTextQueryTable()
	Return
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Store AS Store,
		|	QueryTable.ShipmentConfirmationBeforeSalesInvoice AS ShipmentConfirmationBeforeSalesInvoice,
		|	QueryTable.UseShipmentConfirmation AS UseShipmentConfirmation,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.TotalAmount AS Amount,
		|	QueryTable.Partner AS Partner,
		|	QueryTable.LegalName AS LegalName,
		|	QueryTable.Agreement AS Agreement,
		|	QueryTable.Currency AS Currency,
		|	QueryTable.Period AS Period,
		|	QueryTable.SalesOrder AS SalesOrder,
		|	QueryTable.UseSalesOrder AS UseSalesOrder,
		|	QueryTable.ShipmentBasis AS ShipmentBasis,
		|	QueryTable.SalesInvoice AS SalesInvoice,
		|	QueryTable.RowKey AS RowKey,
		|	QueryTable.IsOpeningEntry AS IsOpeningEntry,
		|	QueryTable.DeliveryDate AS DeliveryDate,
		|	QueryTable.BusinessUnit AS BusinessUnit,
		|	QueryTable.RevenueType AS RevenueType,
		|	QueryTable.AdditionalAnalytic AS AdditionalAnalytic,
		|	QueryTable.NetAmount AS NetAmount,
		|	QueryTable.OffersAmount AS OffersAmount,
		|	QueryTable.IsService AS IsService,
		|	QueryTable.BasisDocument AS BasisDocument,
		|	QueryTable.RowKeyUUID AS RowKeyUUID
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|//[1]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period AS Period,
		|	tmp.SalesOrder AS Order,
		|	tmp.RowKey AS RowKey
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.SalesOrder <> VALUE(Document.SalesOrder.EmptyRef)
		|	AND
		|	NOT tmp.IsOpeningEntry
		|;
		|
		|//[2]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period AS Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.SalesOrder <> VALUE(Document.SalesOrder.EmptyRef)
		|	AND
		|	NOT tmp.IsOpeningEntry
		|	AND
		|	NOT tmp.IsService
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|//[3]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period AS Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.UseSalesOrder
		|	AND
		|	NOT tmp.IsOpeningEntry
		|	AND
		|	NOT tmp.ShipmentConfirmationBeforeSalesInvoice
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|//[4]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period AS Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	(NOT tmp.ShipmentConfirmationBeforeSalesInvoice OR NOT tmp.UseSalesOrder)
		|	AND
		|	NOT tmp.IsOpeningEntry
		|	AND
		|	NOT tmp.IsService
		|GROUP BY
		|	tmp.Period,
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey
		|;
		|
		|
		|//[5]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	ISNULL(ShipmentConfirmations.Quantity, tmp.Quantity) AS Quantity,
		|	tmp.Period AS Period,
		|	CASE
		|		WHEN tmp.ShipmentConfirmationBeforeSalesInvoice
		|		AND
		|		NOT tmp.UseSalesOrder
		|			THEN ISNULL(ShipmentConfirmations.ShipmentConfirmation, VALUE(Document.ShipmentConfirmation.EmptyRef))
		|		ELSE tmp.ShipmentBasis
		|	END AS ShipmentBasis,
		|	tmp.RowKey AS RowKey
		|FROM
		|	tmp AS tmp
		|	LEFT JOIN Document.SalesInvoice.ShipmentConfirmations AS ShipmentConfirmations
		|	ON tmp.RowKeyUUID = ShipmentConfirmations.Key
		|	AND tmp.SalesInvoice = ShipmentConfirmations.Ref
		|WHERE
		|	tmp.UseShipmentConfirmation
		|	AND (NOT tmp.ShipmentConfirmationBeforeSalesInvoice
		|	OR
		|	NOT tmp.UseSalesOrder)
		|	AND
		|	NOT tmp.IsService
		|;
		|
		|//[6]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period AS Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.UseShipmentConfirmation
		|	AND
		|	NOT tmp.ShipmentConfirmationBeforeSalesInvoice
		|	AND
		|	NOT tmp.IsOpeningEntry
		|	AND
		|	NOT tmp.IsService
		|GROUP BY
		|	tmp.Period,
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey
		|;
		|//[7]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.SalesOrder AS Order,
		|	ISNULL(ShipmentConfirmations.ShipmentConfirmation, VALUE(Document.ShipmentConfirmation.EmptyRef)) AS ShipmentConfirmation,
		|	tmp.ItemKey AS ItemKey,
		|	ISNULL(ShipmentConfirmations.Quantity, 0) AS Quantity,
		|	tmp.Period AS Period,
		|	tmp.RowKey AS RowKey
		|FROM
		|	tmp AS tmp
		|	LEFT JOIN Document.SalesInvoice.ShipmentConfirmations AS ShipmentConfirmations
		|	ON tmp.RowKeyUUID = ShipmentConfirmations.Key
		|	AND tmp.SalesInvoice = ShipmentConfirmations.Ref
		|WHERE
		|	tmp.ShipmentConfirmationBeforeSalesInvoice
		|	AND
		|	NOT tmp.IsOpeningEntry
		|	AND tmp.UseSalesOrder
		|;
		|
		|//[8]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BasisDocument AS BasisDocument,
		|	tmp.Partner AS Partner,
		|	tmp.LegalName AS LegalName,
		|	tmp.Agreement AS Agreement,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
		|	tmp.Period AS Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.IsOpeningEntry
		|GROUP BY
		|	tmp.Company,
		|	tmp.BasisDocument,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Agreement,
		|	tmp.Currency,
		|	tmp.Period
		|;
		|
		|//[9]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BasisDocument AS BasisDocument,
		|	tmp.Partner AS Partner,
		|	tmp.LegalName AS LegalName,
		|	tmp.Agreement AS Agreement,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS DocumentAmount,
		|	tmp.Period AS Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.IsOpeningEntry
		|GROUP BY
		|	tmp.Company,
		|	tmp.BasisDocument,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Agreement,
		|	tmp.Currency,
		|	tmp.Period
		|;
		|
		|//[10]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.SalesOrder AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period AS Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.ShipmentConfirmationSchedule AS ShipmentConfirmationSchedule
		|		ON ShipmentConfirmationSchedule.Recorder = tmp.SalesOrder
		|		AND ShipmentConfirmationSchedule.RowKey = tmp.RowKey
		|		AND ShipmentConfirmationSchedule.Company = tmp.Company
		|		AND ShipmentConfirmationSchedule.Store = tmp.Store
		|		AND ShipmentConfirmationSchedule.ItemKey = tmp.ItemKey
		|		AND
		|		NOT tmp.UseShipmentConfirmation
		|		AND
		|		NOT tmp.ShipmentConfirmationBeforeSalesInvoice
		|		AND
		|		NOT tmp.IsOpeningEntry
		|		AND ShipmentConfirmationSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|
		|UNION ALL
		|
		|SELECT
		|	tmp.Company,
		|	tmp.SalesOrder,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Quantity,
		|	tmp.Period,
		|	ShipmentConfirmationSchedule.DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.ShipmentConfirmationSchedule AS ShipmentConfirmationSchedule
		|		ON ShipmentConfirmationSchedule.Recorder = tmp.SalesOrder
		|		AND ShipmentConfirmationSchedule.RowKey = tmp.RowKey
		|		AND ShipmentConfirmationSchedule.Company = tmp.Company
		|		AND ShipmentConfirmationSchedule.Store = tmp.Store
		|		AND ShipmentConfirmationSchedule.ItemKey = tmp.ItemKey
		|		AND tmp.UseShipmentConfirmation
		|		AND
		|		NOT tmp.ShipmentConfirmationBeforeSalesInvoice
		|		AND
		|		NOT tmp.IsOpeningEntry
		|		AND ShipmentConfirmationSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|
		|UNION ALL
		|
		|SELECT
		|	tmp.Company,
		|	tmp.SalesInvoice,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Quantity,
		|	tmp.Period,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.UseShipmentConfirmation
		|	AND
		|	NOT tmp.ShipmentConfirmationBeforeSalesInvoice
		|	AND
		|	NOT tmp.IsOpeningEntry
		|	AND
		|	NOT tmp.UseSalesOrder
		|	AND tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|;
		|
		|//[11]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.SalesInvoice AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period AS Period,
		|	tmp.DeliveryDate AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.ShipmentConfirmationBeforeSalesInvoice
		|	AND
		|	NOT tmp.IsOpeningEntry
		|	AND
		|	NOT tmp.UseSalesOrder
		|	AND tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|
		|UNION ALL
		|
		|SELECT
		|	tmp.Company,
		|	tmp.SalesOrder,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.ShipmentConfirmationSchedule AS ShipmentConfirmationSchedule
		|		ON ShipmentConfirmationSchedule.Recorder = tmp.SalesOrder
		|		AND ShipmentConfirmationSchedule.RowKey = tmp.RowKey
		|		AND ShipmentConfirmationSchedule.Company = tmp.Company
		|		AND ShipmentConfirmationSchedule.Store = tmp.Store
		|		AND ShipmentConfirmationSchedule.ItemKey = tmp.ItemKey
		|		AND tmp.UseShipmentConfirmation
		|		AND
		|		NOT tmp.ShipmentConfirmationBeforeSalesInvoice
		|		AND
		|		NOT tmp.IsOpeningEntry
		|		AND ShipmentConfirmationSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|;
		|
		|//[12]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.LegalName AS LegalName,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
		|	tmp.Period AS Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.IsOpeningEntry
		|GROUP BY
		|	tmp.Company,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.Period
		|;
		|
		|//[13]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Period AS Period,
		|	tmp.Company AS Company,
		|	tmp.BusinessUnit AS BusinessUnit,
		|	tmp.RevenueType AS RevenueType,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.Currency AS Currency,
		|	tmp.AdditionalAnalytic AS AdditionalAnalytic,
		|	SUM(tmp.NetAmount) AS Amount
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Period,
		|	tmp.Company,
		|	tmp.BusinessUnit,
		|	tmp.RevenueType,
		|	tmp.Currency,
		|	tmp.AdditionalAnalytic,
		|	tmp.ItemKey";
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// OrderBalance
	OrderBalance = AccumulationRegisters.OrderBalance.GetLockFields(DocumentDataTables.OrderBalance);
	DataMapWithLockFields.Insert(OrderBalance.RegisterName, OrderBalance.LockInfo);
	
	// InventoryBalance
	InventoryBalance = AccumulationRegisters.InventoryBalance.GetLockFields(DocumentDataTables.InventoryBalance);
	DataMapWithLockFields.Insert(InventoryBalance.RegisterName, InventoryBalance.LockInfo);
	
	// OrderReservation
	OrderReservation = AccumulationRegisters.OrderReservation.GetLockFields(DocumentDataTables.OrderReservation);
	DataMapWithLockFields.Insert(OrderReservation.RegisterName, OrderReservation.LockInfo);
	
	// StockReservation 
	StockReservation = AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.StockReservation);
	DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
	
	// SalesTurnovers
	SalesTurnovers = AccumulationRegisters.SalesTurnovers.GetLockFields(DocumentDataTables.SalesTurnovers);
	DataMapWithLockFields.Insert(SalesTurnovers.RegisterName, SalesTurnovers.LockInfo);
	
	// GoodsInTransitOutgoing 
	GoodsInTransitOutgoing = 
		AccumulationRegisters.GoodsInTransitOutgoing.GetLockFields(DocumentDataTables.GoodsInTransitOutgoing);
	DataMapWithLockFields.Insert(GoodsInTransitOutgoing.RegisterName, GoodsInTransitOutgoing.LockInfo);
	
	// StockBalance 
	StockBalance = AccumulationRegisters.StockBalance.GetLockFields(DocumentDataTables.StockBalance);
	DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
	
	// ShipmentOrders
	ShipmentOrders = AccumulationRegisters.ShipmentOrders.GetLockFields(DocumentDataTables.ShipmentOrders);
	DataMapWithLockFields.Insert(ShipmentOrders.RegisterName, ShipmentOrders.LockInfo);
	
	// PartnerArTransactions
	PartnerArTransactions = AccumulationRegisters.PartnerArTransactions.GetLockFields(DocumentDataTables.PartnerArTransactions);
	DataMapWithLockFields.Insert(PartnerArTransactions.RegisterName, PartnerArTransactions.LockInfo);
	
	// AdvanceFromCustomers (Lock use In PostingCheckBeforeWrite)
	AdvanceFromCustomers = AccumulationRegisters.AdvanceFromCustomers.GetLockFields(DocumentDataTables.AdvanceFromCustomers_Lock);
	DataMapWithLockFields.Insert(AdvanceFromCustomers.RegisterName, AdvanceFromCustomers.LockInfo);
	
	// ReconciliationStatement
	ReconciliationStatement = AccumulationRegisters.ReconciliationStatement.GetLockFields(DocumentDataTables.ReconciliationStatement);
	DataMapWithLockFields.Insert(ReconciliationStatement.RegisterName, ReconciliationStatement.LockInfo);
	
	// TaxesTurnovers
	TaxesTurnovers = AccumulationRegisters.TaxesTurnovers.GetLockFields(DocumentDataTables.TaxesTurnovers);
	DataMapWithLockFields.Insert(TaxesTurnovers.RegisterName, TaxesTurnovers.LockInfo);
	
	// RevenuesTurnovers
	RevenuesTurnovers = AccumulationRegisters.RevenuesTurnovers.GetLockFields(DocumentDataTables.RevenuesTurnovers);
	DataMapWithLockFields.Insert(RevenuesTurnovers.RegisterName, RevenuesTurnovers.LockInfo);
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	// Advance from customers
	Parameters.DocumentDataTables.AdvanceFromCustomers_Registrations =
		AccumulationRegisters.AdvanceFromCustomers.GetTableExpenceAdvance(Parameters.Object.RegisterRecords
			, Parameters.PointInTime
			, Parameters.DocumentDataTables.AdvanceFromCustomers_Lock);
			
    If Parameters.DocumentDataTables.AdvanceFromCustomers_Registrations.Count() Then
    	Query = New Query();
    	Query.Text = 
    	"SELECT
    	|	tmp.Company,
    	|	tmp.Partner,
    	|	tmp.LegalName,
    	|	tmp.BasisDocument,
    	|	tmp.Currency,
    	|	tmp.Amount
    	|INTO tmp
    	|FROM
    	|	&QueryTable AS tmp
    	|;
    	|////////////////////////////////////////////////////////////////////////////////
    	|SELECT
    	|	AccountsStatementBalance.Company,
    	|	AccountsStatementBalance.Partner,
    	|	AccountsStatementBalance.LegalName,
    	|	AccountsStatementBalance.Currency,
    	|	&Period AS Period,
    	|	AccountsStatementBalance.AdvanceToSuppliersBalance AS AdvanceToSuppliersBalance,
    	|	-tmp.Amount AS AdvanceToSuppliers
    	|FROM
    	|	AccumulationRegister.AccountsStatement.Balance(&PointInTime, (Company, Partner, LegalName, Currency) IN
    	|		(SELECT
    	|			tmp.Company,
    	|			tmp.Partner,
    	|			tmp.LegalName,
    	|			tmp.Currency
    	|		FROM
    	|			tmp AS tmp)) AS AccountsStatementBalance
    	|		INNER JOIN tmp AS tmp
    	|		ON AccountsStatementBalance.Company = tmp.Company
    	|		AND AccountsStatementBalance.Partner = tmp.Partner
    	|		AND AccountsStatementBalance.LegalName = tmp.LegalName
    	|		AND AccountsStatementBalance.Currency = tmp.Currency";
    	Query.SetParameter("QueryTable", Parameters.DocumentDataTables.AdvanceFromCustomers_Registrations);
    	Query.SetParameter("PointInTime", Parameters.PointInTime);
    	Query.SetParameter("Period", Parameters.Object.Date);
    	Parameters.DocumentDataTables.Insert("AdvanceFromCustomers_Registrations_AccountStatement",
    	Query.Execute().Unload());
    EndIf;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// OrderBalance 
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction", 
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.OrderBalance,
			True));
	
	// InventoryBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.InventoryBalance,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.InventoryBalance));
	
	// OrderReservation
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderReservation,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.OrderReservation));
	
	// StockReservation	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.StockReservation));
	
	
	// SalesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.SalesTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.SalesTurnovers));
	
	// GoodsInTransitOutgoing
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitOutgoing,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.GoodsInTransitOutgoing,
			True));
	
	// StockBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.StockBalance));
	
	// ShipmentOrders
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ShipmentOrders,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.ShipmentOrders,
			True));
	
	// RevenuesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.RevenuesTurnovers,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.RevenuesTurnovers,
			Parameters.IsReposting));
	
	// AccountsStatement
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.PartnerArTransactions.Copy();
	Table1.Columns.Amount.Name = "TransactionAR";
	PostingServer.AddColumnsToAccountsStatementTable(Table1);
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.AdvanceFromCustomers_Registrations.Copy();
	Table2.Columns.Amount.Name = "TransactionAR";
	PostingServer.AddColumnsToAccountsStatementTable(Table2);
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	Table3 = Parameters.DocumentDataTables.AdvanceFromCustomers_Registrations.Copy();
	Table3.Columns.Amount.Name = "AdvanceFromCustomers";
	PostingServer.AddColumnsToAccountsStatementTable(Table3);
	Table3.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table3);
		
	If Parameters.DocumentDataTables.Property("AdvanceFromCustomers_Registrations_AccountStatement") Then
		Table4 = Parameters.DocumentDataTables.AdvanceFromCustomers_Registrations_AccountStatement.Copy();
		PostingServer.AddColumnsToAccountsStatementTable(Table4);
		Table4.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(Table4);
	EndIf;
		
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AccountsStatement,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, Partner, LegalName, BasisDocument, Currency, 
				|TransactionAR, AdvanceFromCustomers,
				|TransactionAP, AdvanceToSuppliers"),
			Parameters.IsReposting));	
		
	// PartnerArTransactions
	// PartnerArTransactions [Receipt]  
	// AdvanceFromCustomers_Registrations [Expense]
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.PartnerArTransactions.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.AdvanceFromCustomers_Registrations.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PartnerArTransactions,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, BasisDocument, Partner, 
				|LegalName, Agreement, Currency, Amount"),
				Parameters.IsReposting));
	
	// AdvanceFromCustomers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AdvanceFromCustomers,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.AdvanceFromCustomers_Registrations));
	
	// ShipmentConfirmationSchedule
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.ShipmentConfirmationSchedule_Expense.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.ShipmentConfirmationSchedule_Receipt.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ShipmentConfirmationSchedule,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, Order, Store, ItemKey, RowKey, Quantity, DeliveryDate"),
			Parameters.IsReposting));
	
	// ReconciliationStatement
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ReconciliationStatement,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.ReconciliationStatement));
	
	// TaxesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.TaxesTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.TaxesTurnovers));
	
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
	
	// OrderBalance
	OrderBalance = AccumulationRegisters.OrderBalance.GetLockFields(DocumentDataTables.OrderBalance_Exists);
	DataMapWithLockFields.Insert(OrderBalance.RegisterName, OrderBalance.LockInfo);
	
	// GoodsInTransitOutgoing
	GoodsInTransitOutgoing = AccumulationRegisters.GoodsInTransitOutgoing.GetLockFields(DocumentDataTables.GoodsInTransitOutgoing_Exists);
	DataMapWithLockFields.Insert(GoodsInTransitOutgoing.RegisterName, GoodsInTransitOutgoing.LockInfo);
	
	// ShipmentOrders
	ShipmentOrders = AccumulationRegisters.ShipmentOrders.GetLockFields(DocumentDataTables.ShipmentOrders_Exists);
	DataMapWithLockFields.Insert(ShipmentOrders.RegisterName, ShipmentOrders.LockInfo);
	
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
	Unposting = ?(Parameters.Property("Unposting"), Parameters.Unposting, False);
	LineNumberAndRowKeyFromItemList = PostingServer.GetLineNumberAndRowKeyFromItemList(Ref, "Document.SalesInvoice.ItemList");
	
	If Not Cancel And Not AccumulationRegisters.GoodsInTransitOutgoing.CheckBalance(Ref, 
	                                                                 LineNumberAndRowKeyFromItemList,
	                                                                 Parameters.DocumentDataTables.GoodsInTransitOutgoing,
	                                                                 Parameters.DocumentDataTables.GoodsInTransitOutgoing_Exists,
	                                                                 AccumulationRecordType.Receipt,
	                                                                 Unposting,
	                                                                 AddInfo) Then
		Cancel = True;
	EndIf;
	
	If Not Cancel And Not AccumulationRegisters.OrderBalance.CheckBalance(Ref, 
	                                                                 LineNumberAndRowKeyFromItemList,
	                                                                 Parameters.DocumentDataTables.OrderBalance,
	                                                                 Parameters.DocumentDataTables.OrderBalance_Exists,
	                                                                 AccumulationRecordType.Expense,
	                                                                 Unposting,
	                                                                 AddInfo) Then
		Cancel = True;
	EndIf;
	
	If Not Cancel And Not AccumulationRegisters.ShipmentOrders.CheckBalance(Ref, 
	                                                                 LineNumberAndRowKeyFromItemList,
	                                                                 Parameters.DocumentDataTables.ShipmentOrders,
	                                                                 Parameters.DocumentDataTables.ShipmentOrders_Exists,
	                                                                 AccumulationRecordType.Expense,
	                                                                 Unposting,
	                                                                 AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

#EndRegion
