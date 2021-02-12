#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("OrderBalance"                          , PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("OrderReservation"                      , PostingServer.CreateTable(AccReg.OrderReservation));
	Tables.Insert("StockReservation"                      , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("InventoryBalance"                      , PostingServer.CreateTable(AccReg.InventoryBalance));
	Tables.Insert("SalesTurnovers"                        , PostingServer.CreateTable(AccReg.SalesTurnovers));
	Tables.Insert("GoodsInTransitOutgoing"                , PostingServer.CreateTable(AccReg.GoodsInTransitOutgoing));
	Tables.Insert("StockBalance"                          , PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("ShipmentOrders"                        , PostingServer.CreateTable(AccReg.ShipmentOrders));
	Tables.Insert("PartnerArTransactions"                 , PostingServer.CreateTable(AccReg.PartnerArTransactions));
	Tables.Insert("AdvanceFromCustomers_Lock"             , PostingServer.CreateTable(AccReg.AdvanceFromCustomers));
	Tables.Insert("PartnerArTransactions_OffsetOfAdvance" , PostingServer.CreateTable(AccReg.AdvanceFromCustomers));
	Tables.Insert("ShipmentConfirmationSchedule_Expense"  , PostingServer.CreateTable(AccReg.ShipmentConfirmationSchedule));
	Tables.Insert("ShipmentConfirmationSchedule_Receipt"  , PostingServer.CreateTable(AccReg.ShipmentConfirmationSchedule));
	Tables.Insert("ReconciliationStatement"               , PostingServer.CreateTable(AccReg.ReconciliationStatement));
	Tables.Insert("TaxesTurnovers"                        , PostingServer.CreateTable(AccReg.TaxesTurnovers));
	Tables.Insert("RevenuesTurnovers"                     , PostingServer.CreateTable(AccReg.RevenuesTurnovers));
	Tables.Insert("Aging_Receipt"                         , PostingServer.CreateTable(AccReg.Aging));
	Tables.Insert("Aging_Expense"                         , PostingServer.CreateTable(AccReg.Aging));
	
	Tables.Insert("OrderBalance_Exists"           , PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("GoodsInTransitOutgoing_Exists" , PostingServer.CreateTable(AccReg.GoodsInTransitOutgoing));
	Tables.Insert("ShipmentOrders_Exists"         , PostingServer.CreateTable(AccReg.ShipmentOrders));
	
	Tables.Insert("StockReservation_Exists" , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockBalance_Exists"     , PostingServer.CreateTable(AccReg.StockBalance));
		
	Tables.OrderBalance_Exists =
	AccumulationRegisters.OrderBalance.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo);
	
	Tables.GoodsInTransitOutgoing_Exists =
	AccumulationRegisters.GoodsInTransitOutgoing.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Tables.ShipmentOrders_Exists =
	AccumulationRegisters.ShipmentOrders.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo); 
	
	Tables.StockReservation_Exists = 
	AccumulationRegisters.StockReservation.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo);
	
	Tables.StockBalance_Exists = 
	AccumulationRegisters.StockBalance.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo);
	
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
	
	QueryAging = New Query();
	QueryAging.Text = GetQueryTextSalesInvoiceAging();
	QueryAging.SetParameter("Ref", Ref);
	QueryResultAging = QueryAging.Execute();
	QueryTableAging = QueryResultAging.Unload();
	
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
	Tables.Aging_Receipt  = QueryTableAging;
	
#Region NewRegistersPosting	
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParamenters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	
	Tables.Insert("CustomersTransactions", 
	PostingServer.GetQueryTableByName("CustomersTransactions", Parameters));	
#EndRegion	
		
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
		|	SalesOrderItemList.Key AS Key,
		|	SalesOrderItemList.ProcurementMethod AS ProcurementMethod
		|INTO SalesOrderItemList
		|FROM
		|	Document.SalesInvoice.ItemList AS SalesInvoiceItemList
		|		INNER JOIN Document.SalesOrder.ItemList AS SalesOrderItemList
		|		ON SalesInvoiceItemList.SalesOrder = SalesOrderItemList.Ref
		|		AND SalesInvoiceItemList.Key = SalesOrderItemList.Key
		|		AND SalesInvoiceItemList.Ref = &Ref
		|GROUP BY
		|	SalesOrderItemList.Key,
		|	SalesOrderItemList.ProcurementMethod
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
		|	NOT SalesInvoiceItemList.SalesOrder.Ref IS NULL AS UseSalesOrder,
		|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Stock) AS ProcMeth_Stock,
		|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Purchase) AS ProcMeth_Purchase,
		|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.NoReserve) AS ProcMeth_NoReserve,
		|	SalesInvoiceItemList.Ref AS ShipmentBasis,
		|	SalesInvoiceItemList.Ref AS SalesInvoice,
		|	SalesInvoiceItemList.Key AS RowKeyUUID,
		|	SalesInvoiceItemList.DeliveryDate AS DeliveryDate,
		|	SalesInvoiceItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
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
		|		LEFT JOIN SalesOrderItemList AS SalesOrderItemList
		|		ON SalesInvoiceItemList.Key = SalesOrderItemList.Key
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

Function GetQueryTextSalesInvoiceAging()
	Return 
	"SELECT
	|	SalesInvoicePaymentTerms.Date AS PaymentDate,
	|	SalesInvoicePaymentTerms.Ref.Date AS Period,
	|	SUM(SalesInvoicePaymentTerms.Amount) AS Amount,
	|	SalesInvoicePaymentTerms.Ref.Company AS Company,
	|	SalesInvoicePaymentTerms.Ref.Partner AS Partner,
	|	SalesInvoicePaymentTerms.Ref.Agreement AS Agreement,
	|	SalesInvoicePaymentTerms.Ref.Currency AS Currency,
	|	SalesInvoicePaymentTerms.Ref AS Invoice
	|FROM
	|	Document.SalesInvoice.PaymentTerms AS SalesInvoicePaymentTerms
	|WHERE
	|	SalesInvoicePaymentTerms.Ref = &Ref
	|GROUP BY
	|	SalesInvoicePaymentTerms.Date,
	|	SalesInvoicePaymentTerms.Ref.Company,
	|	SalesInvoicePaymentTerms.Ref.Partner,
	|	SalesInvoicePaymentTerms.Ref.Agreement,
	|	SalesInvoicePaymentTerms.Ref.Currency,
	|	SalesInvoicePaymentTerms.Ref.Date,
	|	SalesInvoicePaymentTerms.Ref";
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
		|	QueryTable.DeliveryDate AS DeliveryDate,
		|	QueryTable.BusinessUnit AS BusinessUnit,
		|	QueryTable.RevenueType AS RevenueType,
		|	QueryTable.AdditionalAnalytic AS AdditionalAnalytic,
		|	QueryTable.NetAmount AS NetAmount,
		|	QueryTable.OffersAmount AS OffersAmount,
		|	QueryTable.IsService AS IsService,
		|	QueryTable.BasisDocument AS BasisDocument,
		|	QueryTable.RowKeyUUID AS RowKeyUUID,
		|	QueryTable.ProcMeth_Stock,
		|	QueryTable.ProcMeth_Purchase,
		|	QueryTable.ProcMeth_NoReserve
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
		|	(NOT tmp.UseSalesOrder OR tmp.ProcMeth_NoReserve)
		|	AND
		|	NOT tmp.ShipmentConfirmationBeforeSalesInvoice
		|	AND 
		|	NOT tmp.IsService
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
	Tables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
#Region NewRegistersPosting
	PostingServer.SetLockDataSource(DataMapWithLockFields, 
		AccumulationRegisters.R2020B_AdvancesFromCustomers, 
		Tables.CustomersTransactions);
#EndRegion	
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
#Region NewRegisterPosting
	Tables = Parameters.DocumentDataTables;
	
	OffsetOfPartnersServer.Customers_OnTransaction(Parameters);
	
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion
	
	// Advance from customers
	Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance =
		AccumulationRegisters.AdvanceFromCustomers.GetTableAdvanceFromCustomers_OffsetOfAdvance(Parameters.Object.RegisterRecords
			, Parameters.PointInTime
			, Parameters.DocumentDataTables.AdvanceFromCustomers_Lock);
	
	// Aging expense
	Parameters.DocumentDataTables.Aging_Expense = 
		AccumulationRegisters.Aging.GetTableAging_Expense_OnSalesInvoice(
		Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance,
		Parameters.DocumentDataTables.Aging_Receipt);
	
    If Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance.Count() Then
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
    	Query.SetParameter("QueryTable", Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance);
    	Query.SetParameter("PointInTime", Parameters.PointInTime);
    	Query.SetParameter("Period", Parameters.Object.Date);
    	Parameters.DocumentDataTables.Insert("PartnerArTransactions_OffsetOfAdvance_AccountStatement",
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
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.StockReservation,
			True));
	
	
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
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.StockBalance,
			True));
	
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
	
	Table2 = Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance.Copy();
	Table2.Columns.Amount.Name = "TransactionAR";
	PostingServer.AddColumnsToAccountsStatementTable(Table2);
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	Table3 = Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance.Copy();
	Table3.Columns.Amount.Name = "AdvanceFromCustomers";
	PostingServer.AddColumnsToAccountsStatementTable(Table3);
	Table3.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table3);
		
	If Parameters.DocumentDataTables.Property("PartnerArTransactions_OffsetOfAdvance_AccountStatement") Then
		Table4 = Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance_AccountStatement.Copy();
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
	// PartnerArTransactions_OffsetOfAdvance [Expense]
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.PartnerArTransactions.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PartnerArTransactions,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, BasisDocument, Partner, 
				|LegalName, Agreement, Currency, Amount"),
				True));
	
	// AdvanceFromCustomers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AdvanceFromCustomers,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance));
	
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
	
	// Aging
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.Aging_Receipt.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.Aging_Expense.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.Aging,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, Partner, Agreement, Invoice, PaymentDate, Currency, Amount"),
			Parameters.IsReposting));
	
#Region NewRegistersPosting
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
#EndRegion			
	
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
	
	If Not Cancel And Ref.Agreement.UseCreditLimit Then
		CheckCreditLimits(Ref, Cancel, Parameters, AddInfo);
	EndIf;
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
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
	AccReg = AccumulationRegisters;
	
	Parameters.Insert("RecordType", AccumulationRecordType.Expense);
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.SalesInvoice.ItemList", AddInfo);
		
	LineNumberAndRowKeyFromItemList = PostingServer.GetLineNumberAndRowKeyFromItemList(Ref, "Document.SalesInvoice.ItemList");
	If Not Cancel And Not AccReg.GoodsInTransitOutgoing.CheckBalance(Ref, LineNumberAndRowKeyFromItemList,
	                                                                 Parameters.DocumentDataTables.GoodsInTransitOutgoing,
	                                                                 Parameters.DocumentDataTables.GoodsInTransitOutgoing_Exists,
	                                                                 AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
	
	If Not Cancel And Not AccReg.OrderBalance.CheckBalance(Ref, LineNumberAndRowKeyFromItemList,
	                                                       Parameters.DocumentDataTables.OrderBalance,
	                                                       Parameters.DocumentDataTables.OrderBalance_Exists,
	                                                       AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
	
	If Not Cancel And Not AccReg.ShipmentOrders.CheckBalance(Ref, LineNumberAndRowKeyFromItemList,
	                                                         Parameters.DocumentDataTables.ShipmentOrders,
	                                                         Parameters.DocumentDataTables.ShipmentOrders_Exists,
	                                                         AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure CheckCreditLimits(Ref, Cancel, Parameters, AddInfo)
	Query = New Query();
	Query.TempTablesManager = New TempTablesManager();
	Query.Text = 
	"SELECT
	|	PartnerArTransactions.Company,
	|	PartnerArTransactions.Partner,
	|	PartnerArTransactions.Agreement,
	|	&CurrencyMovementType AS CurrencyMovementType
	|INTO PartnerArTransactions
	|FROM
	|	&PartnerArTransactions AS PartnerArTransactions
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AccRegPartnerArTransactions.Company,
	|	AccRegPartnerArTransactions.Partner,
	|	AccRegPartnerArTransactions.Agreement,
	|	AccRegPartnerArTransactions.CurrencyMovementType,
	|	AccRegPartnerArTransactions.Amount
	|INTO AccRegAccRegPartnerArTransactions
	|FROM
	|	AccumulationRegister.PartnerArTransactions AS AccRegPartnerArTransactions
	|		INNER JOIN PartnerArTransactions AS PartnerArTransactions
	|		ON AccRegPartnerArTransactions.Company = PartnerArTransactions.Company
	|		AND AccRegPartnerArTransactions.Partner = PartnerArTransactions.Partner
	|		AND AccRegPartnerArTransactions.Agreement = PartnerArTransactions.Agreement
	|		AND AccRegPartnerArTransactions.CurrencyMovementType = PartnerArTransactions.CurrencyMovementType
	|		AND AccRegPartnerArTransactions.Recorder = &Ref
	|		AND AccRegPartnerArTransactions.RecordType = VALUE(AccumulationRecordType.Receipt)
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	PartnerArTransactionsBalance.Company AS Company,
	|	PartnerArTransactionsBalance.Partner AS Partner,
	|	PartnerArTransactionsBalance.Agreement AS Agreement,
	|	PartnerArTransactionsBalance.CurrencyMovementType AS CurrencyMovementType,
	|	PartnerArTransactionsBalance.Currency AS Currency,
	|	PartnerArTransactionsBalance.AmountBalance AS AmountBalance,
	|	PartnerArTransactionsBalance.Agreement.CreditLimitAmount AS CreditLimitAmount,
	|	AccRegAccRegPartnerArTransactions.Amount AS TransactionAmount
	|FROM
	|	AccumulationRegister.PartnerArTransactions.Balance(&BoundaryIncluding, (Company, Partner, Agreement,
	|		CurrencyMovementType) IN
	|		(SELECT
	|			PartnerArTransactions.Company,
	|			PartnerArTransactions.Partner,
	|			PartnerArTransactions.Agreement,
	|			&CurrencyMovementType
	|		FROM
	|			PartnerArTransactions AS PartnerArTransactions)) AS PartnerArTransactionsBalance
	|		LEFT JOIN PartnerArTransactions AS PartnerArTransactions
	|		ON PartnerArTransactionsBalance.Company = PartnerArTransactions.Company
	|		AND PartnerArTransactionsBalance.Partner = PartnerArTransactions.Partner
	|		AND PartnerArTransactionsBalance.Agreement = PartnerArTransactions.Agreement
	|		AND PartnerArTransactionsBalance.CurrencyMovementType = PartnerArTransactions.CurrencyMovementType
	|		LEFT JOIN AccRegAccRegPartnerArTransactions AS AccRegAccRegPartnerArTransactions
	|		ON PartnerArTransactionsBalance.Company = AccRegAccRegPartnerArTransactions.Company
	|		AND PartnerArTransactionsBalance.Partner = AccRegAccRegPartnerArTransactions.Partner
	|		AND PartnerArTransactionsBalance.Agreement = AccRegAccRegPartnerArTransactions.Agreement
	|		AND PartnerArTransactionsBalance.CurrencyMovementType = AccRegAccRegPartnerArTransactions.CurrencyMovementType
	|WHERE
	|	PartnerArTransactionsBalance.AmountBalance > PartnerArTransactionsBalance.Agreement.CreditLimitAmount";
	Query.SetParameter("BoundaryIncluding"     , New Boundary(Parameters.PointInTime, BoundaryType.Including));
	Query.SetParameter("CurrencyMovementType"  , Ref.Agreement.CurrencyMovementType);
	Query.SetParameter("PartnerArTransactions" , Parameters.DocumentDataTables.PartnerArTransactions);
	Query.SetParameter("Ref"                   , Ref);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		Cancel = True;
		CommonFunctionsClientServer.ShowUsersMessage(
		StrTemplate(R().Error_085, 
		Format(QuerySelection.CreditLimitAmount, "NFD=2;"), 
		Format(QuerySelection.CreditLimitAmount - QuerySelection.AmountBalance + QuerySelection.TransactionAmount, "NFD=2;"), 
		Format(QuerySelection.TransactionAmount, "NFD=2;"), 
		Format(QuerySelection.AmountBalance - QuerySelection.CreditLimitAmount, "NFD=2;"),
		QuerySelection.Currency));
	EndDo;
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
	If Ref.isEmpty() Then
		StrParams.Insert("BalancePeriod", Ref.Date);
	Else
		StrParams.Insert("BalancePeriod", New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	EndIf;
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(OffersInfo());
	QueryArray.Add(ShipmentConfirmationsInfo());
	QueryArray.Add(Taxes());
	QueryArray.Add(CustomersTransactions());
	QueryArray.Add(Aging());
	QueryArray.Add(SerialLotNumbers());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R2001T_Sales());	
	QueryArray.Add(R2005T_SalesSpecialOffers());
	QueryArray.Add(R2011B_SalesOrdersShipment());
	QueryArray.Add(R2012B_SalesOrdersInvoiceClosing());
	QueryArray.Add(R2013T_SalesOrdersProcurement());
	QueryArray.Add(R2031B_ShipmentInvoicing());
	QueryArray.Add(R2040B_TaxesIncoming());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4012B_StockReservation());
	QueryArray.Add(R4014B_SerialLotNumber());
	QueryArray.Add(R4034B_GoodsShipmentSchedule());
	QueryArray.Add(R4050B_StockInventory());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(R5011B_PartnersAging());
	QueryArray.Add(R5010B_ReconciliationStatement());
	Return QueryArray;
EndFunction

Function ItemList()
	Return
		"SELECT
		|	ShipmentConfirmations.Key AS Key
		|INTO ShipmentConfirmations
		|FROM
		|	Document.SalesInvoice.ShipmentConfirmations AS ShipmentConfirmations
		|WHERE
		|	ShipmentConfirmations.Ref = &Ref
		|GROUP BY
		|	ShipmentConfirmations.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SalesInvoiceItemList.Ref.Company AS Company,
		|	SalesInvoiceItemList.Store AS Store,
		|	NOT ShipmentConfirmations.Key IS NULL AS ShipmentConfirmationExists,
		|	SalesInvoiceItemList.Ref AS Invoice,
		|	SalesInvoiceItemList.ItemKey AS ItemKey,
		|	SalesInvoiceItemList.Quantity AS UnitQuantity,
		|	SalesInvoiceItemList.QuantityInBaseUnit AS Quantity,
		|	SalesInvoiceItemList.TotalAmount AS Amount,
		|	SalesInvoiceItemList.Ref.Partner AS Partner,
		|	SalesInvoiceItemList.Ref.LegalName AS LegalName,
		|	CASE
		|		WHEN SalesInvoiceItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND SalesInvoiceItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN SalesInvoiceItemList.Ref.Agreement.StandardAgreement
		|		ELSE SalesInvoiceItemList.Ref.Agreement
		|	END AS Agreement,
		|	SalesInvoiceItemList.Ref.Currency AS Currency,
		|	SalesInvoiceItemList.Unit AS Unit,
		|	SalesInvoiceItemList.Ref.Date AS Period,
		|	SalesInvoiceItemList.SalesOrder AS SalesOrder,
		|	NOT SalesInvoiceItemList.SalesOrder.Ref IS NULL AS SalesOrderExists,
		|	SalesInvoiceItemList.Key AS RowKey,
		|	SalesInvoiceItemList.DeliveryDate AS DeliveryDate,
		|	SalesInvoiceItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
		|	SalesInvoiceItemList.BusinessUnit AS BusinessUnit,
		|	SalesInvoiceItemList.RevenueType AS RevenueType,
		|	SalesInvoiceItemList.AdditionalAnalytic AS AdditionalAnalytic,
		|	CASE
		|		WHEN SalesInvoiceItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN SalesInvoiceItemList.Ref
		|		ELSE UNDEFINED
		|	END AS BasisDocument,
		|	SalesInvoiceItemList.NetAmount AS NetAmount,
		|	SalesInvoiceItemList.OffersAmount AS OffersAmount,
		|	SalesInvoiceItemList.UseShipmentConfirmation AS UseShipmentConfirmation
		|INTO ItemList
		|FROM
		|	Document.SalesInvoice.ItemList AS SalesInvoiceItemList
		|		LEFT JOIN ShipmentConfirmations AS ShipmentConfirmations
		|		ON SalesInvoiceItemList.Key = ShipmentConfirmations.Key
		|WHERE
		|	SalesInvoiceItemList.Ref = &Ref";
EndFunction

Function OffersInfo()
	Return
		"SELECT
		|	SalesInvoiceItemList.Ref.Date AS Period,
		|	SalesInvoiceItemList.Ref AS Invoice,
		|	SalesInvoiceItemList.Key AS RowKey,
		|	SalesInvoiceItemList.ItemKey,
		|	SalesInvoiceItemList.Ref.Company AS Company,
		|	SalesInvoiceItemList.Ref.Currency,
		|	SalesInvoiceSpecialOffers.Offer AS SpecialOffer,
		|	SalesInvoiceSpecialOffers.Amount AS OffersAmount,
		|	SalesInvoiceItemList.TotalAmount AS SalesAmount,
		|	SalesInvoiceItemList.NetAmount
		|INTO OffersInfo
		|FROM
		|	Document.SalesInvoice.ItemList AS SalesInvoiceItemList
		|		INNER JOIN Document.SalesInvoice.SpecialOffers AS SalesInvoiceSpecialOffers
		|		ON SalesInvoiceItemList.Key = SalesInvoiceSpecialOffers.Key
		|		AND SalesInvoiceItemList.Ref = &Ref
		|		AND SalesInvoiceSpecialOffers.Ref = &Ref";
EndFunction

Function ShipmentConfirmationsInfo()
	Return
		"SELECT
		|	SalesInvoiceShipmentConfirmations.Key,
		|	SalesInvoiceShipmentConfirmations.ShipmentConfirmation,
		|	SalesInvoiceShipmentConfirmations.Quantity,
		|	SalesInvoiceShipmentConfirmations.QuantityInShipmentConfirmation
		|INTO ShipmentConfirmationsInfo
		|FROM
		|	Document.SalesInvoice.ShipmentConfirmations AS SalesInvoiceShipmentConfirmations
		|WHERE
		|	SalesInvoiceShipmentConfirmations.Ref = &Ref";
EndFunction

Function Taxes()
	Return
		"SELECT
		|	SalesInvoiceTaxList.Ref.Date AS Period,
		|	SalesInvoiceTaxList.Ref.Company AS Company,
		|	SalesInvoiceTaxList.Tax AS Tax,
		|	SalesInvoiceTaxList.TaxRate AS TaxRate,
		|	CASE
		|		WHEN SalesInvoiceTaxList.ManualAmount = 0
		|			THEN SalesInvoiceTaxList.Amount
		|		ELSE SalesInvoiceTaxList.ManualAmount
		|	END AS TaxAmount,
		|	SalesInvoiceItemList.NetAmount AS TaxableAmount
		|INTO Taxes
		|FROM
		|	Document.SalesInvoice.ItemList AS SalesInvoiceItemList
		|		INNER JOIN Document.SalesInvoice.TaxList AS SalesInvoiceTaxList
		|		ON SalesInvoiceItemList.Key = SalesInvoiceTaxList.Key
		|		AND SalesInvoiceItemList.Ref = &Ref
		|		AND SalesInvoiceTaxList.Ref = &Ref";
EndFunction

Function CustomersTransactions()
	Return
		"SELECT
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Currency,
		|	ItemList.LegalName,
		|	ItemList.Partner,
		|	ItemList.BasisDocument AS TransactionDocument,
		|	ItemList.Agreement,
		|	SUM(ItemList.Amount) AS DocumentAmount
		|INTO CustomersTransactions
		|FROM
		|	ItemList AS ItemList
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.LegalName,
		|	ItemList.Partner,
		|	ItemList.BasisDocument,
		|	ItemList.Agreement,
		|	ItemList.Currency";
EndFunction

Function Aging()
	Return
		"SELECT
		|	SalesInvoicePaymentTerms.Date AS PaymentDate,
		|	SalesInvoicePaymentTerms.Ref.Date AS Period,
		|	SUM(SalesInvoicePaymentTerms.Amount) AS Amount,
		|	SalesInvoicePaymentTerms.Ref.Company AS Company,
		|	SalesInvoicePaymentTerms.Ref.Partner AS Partner,
		|	SalesInvoicePaymentTerms.Ref.Agreement AS Agreement,
		|	SalesInvoicePaymentTerms.Ref.Currency AS Currency,
		|	SalesInvoicePaymentTerms.Ref AS Invoice
		|INTO Aging
		|FROM
		|	Document.SalesInvoice.PaymentTerms AS SalesInvoicePaymentTerms
		|WHERE
		|	SalesInvoicePaymentTerms.Ref = &Ref
		|GROUP BY
		|	SalesInvoicePaymentTerms.Date,
		|	SalesInvoicePaymentTerms.Ref.Company,
		|	SalesInvoicePaymentTerms.Ref.Partner,
		|	SalesInvoicePaymentTerms.Ref.Agreement,
		|	SalesInvoicePaymentTerms.Ref.Currency,
		|	SalesInvoicePaymentTerms.Ref.Date,
		|	SalesInvoicePaymentTerms.Ref";	
EndFunction	

Function SerialLotNumbers()
	Return
		"SELECT
		|	SerialLotNumbers.Ref.Date AS Period,
		|	SerialLotNumbers.Ref.Company AS Company,
		|	SerialLotNumbers.Key,
		|	SerialLotNumbers.SerialLotNumber,
		|	SerialLotNumbers.Quantity,
		|	ItemList.ItemKey AS ItemKey
		|INTO SerialLotNumbers
		|FROM
		|	Document.SalesInvoice.SerialLotNumbers AS SerialLotNumbers
		|		LEFT JOIN Document.SalesInvoice.ItemList AS ItemList
		|		ON SerialLotNumbers.Key = ItemList.Key
		|WHERE
		|	SerialLotNumbers.Ref = &Ref";	
EndFunction	

Function R2001T_Sales()
	Return
		"SELECT *
		|INTO R2001T_Sales
		|FROM
		|	ItemList AS ItemList
		|WHERE TRUE";

EndFunction

Function R2005T_SalesSpecialOffers()
	Return
		"SELECT *
		|INTO R2005T_SalesSpecialOffers
		|FROM
		|	OffersInfo AS OffersInfo
		|WHERE TRUE";

EndFunction

Function R2011B_SalesOrdersShipment()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.SalesOrder AS Order,
		|	*
		|INTO R2011B_SalesOrdersShipment
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|	AND NOT ItemList.UseShipmentConfirmation
		|	AND ItemList.SalesOrderExists";

EndFunction

Function R2012B_SalesOrdersInvoiceClosing()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.SalesOrder AS Order,
		|	*
		|INTO R2012B_SalesOrdersInvoiceClosing
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.SalesOrderExists";

EndFunction

Function R2013T_SalesOrdersProcurement()
	Return
		"SELECT
		|	ItemList.Quantity AS SalesQuantity,
		|	ItemList.SalesOrder AS Order,
		|	*
		|INTO R2013T_SalesOrdersProcurement
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|	AND ItemList.SalesOrderExists";

EndFunction

Function R2031B_ShipmentInvoicing()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Invoice AS Basis,
		|	ItemList.Quantity AS Quantity,
		|	ItemList.Company,
		|	ItemList.Period,
		|	ItemList.ItemKey,
		|	ItemList.Store
		|INTO R2031B_ShipmentInvoicing
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.UseShipmentConfirmation
		|	AND NOT ItemList.ShipmentConfirmationExists
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	ShipmentConfirmations.ShipmentConfirmation,
		|	ShipmentConfirmations.Quantity,
		|	ItemList.Company,
		|	ItemList.Period,
		|	ItemList.ItemKey,
		|	ItemList.Store
		|FROM
		|	ItemList AS ItemList
		|		INNER JOIN ShipmentConfirmationsInfo AS ShipmentConfirmations
		|		ON ItemList.RowKey = ShipmentConfirmations.Key
		|WHERE
		|	TRUE";

EndFunction

Function R2040B_TaxesIncoming()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|*
		|INTO R2040B_TaxesIncoming
		|FROM
		|	Taxes AS Taxes
		|WHERE TRUE";

EndFunction

Function R4010B_ActualStocks()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	ItemList.Quantity
		|INTO R4010B_ActualStocks
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|	AND NOT ItemList.UseShipmentConfirmation";
EndFunction

Function R4011B_FreeStocks()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemListGroup.Period,
		|	ItemListGroup.Store,
		|	ItemListGroup.ItemKey,
		|	ItemListGroup.Quantity - ISNULL(StockReservation.QuantityBalance, 0) AS Quantity
		|INTO R4011B_FreeStocks
		|FROM
		|	(SELECT
		|		ItemList.Period,
		|		ItemList.Store,
		|		ItemList.ItemKey,
		|		ItemList.SalesOrder,
		|		SUM(ItemList.Quantity) AS Quantity
		|	FROM
		|		ItemList AS ItemList
		|	Where
		|		NOT ItemList.IsService
		|	GROUP BY
		|		ItemList.Period,
		|		ItemList.Store,
		|		ItemList.ItemKey,
		|		ItemList.SalesOrder) AS ItemListGroup
		|		LEFT JOIN AccumulationRegister.R4012B_StockReservation.Balance(&BalancePeriod, (Store, ItemKey, Order) IN
		|			(SELECT
		|				ItemList.Store,
		|				ItemList.ItemKey,
		|				ItemList.SalesOrder
		|			FROM
		|				ItemList AS ItemList)) AS StockReservation
		|		ON ItemListGroup.SalesOrder = StockReservation.Order
		|		AND ItemListGroup.ItemKey = StockReservation.ItemKey
		|		AND ItemListGroup.Store = StockReservation.Store
		|WHERE
		|	(ItemListGroup.Quantity - ISNULL(StockReservation.QuantityBalance, 0)) <> 0";
EndFunction

Function R4012B_StockReservation()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemListGroup.Period AS Period,
		|	ItemListGroup.SalesOrder AS Order,
		|	ItemListGroup.ItemKey AS ItemKey,
		|	ItemListGroup.Store AS Store,
		|	CASE
		|		WHEN StockReservation.QuantityBalance > ItemListGroup.Quantity
		|			THEN ItemListGroup.Quantity
		|		ELSE StockReservation.QuantityBalance
		|	END AS Quantity
		|INTO R4012B_StockReservation
		|FROM
		|	(SELECT
		|		ItemList.Period,
		|		ItemList.Store,
		|		ItemList.ItemKey,
		|		ItemList.SalesOrder,
		|		SUM(ItemList.Quantity) AS Quantity
		|	FROM
		|		ItemList AS ItemList
		|	WHERE
		|		NOT ItemList.IsService
		|		AND ItemList.UseShipmentConfirmation
		|	GROUP BY
		|		ItemList.Period,
		|		ItemList.Store,
		|		ItemList.ItemKey,
		|		ItemList.SalesOrder) AS ItemListGroup
		|		INNER JOIN AccumulationRegister.R4012B_StockReservation.Balance(&BalancePeriod, (Store, ItemKey, Order) IN
		|			(SELECT
		|				ItemList.Store,
		|				ItemList.ItemKey,
		|				ItemList.SalesOrder
		|			FROM
		|				ItemList AS ItemList)) AS StockReservation
		|		ON ItemListGroup.SalesOrder = StockReservation.Order
		|		AND ItemListGroup.ItemKey = StockReservation.ItemKey
		|		AND ItemListGroup.Store = StockReservation.Store";
EndFunction

Function R4014B_SerialLotNumber()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|*
		|INTO R4014B_SerialLotNumber
		|FROM
		|	SerialLotNumbers AS SerialLotNumbers
		|WHERE 
		|	TRUE";

EndFunction

Function R4034B_GoodsShipmentSchedule()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.SalesOrder AS Basis,
		|	*
		|INTO R4034B_GoodsShipmentSchedule
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|	AND NOT ItemList.UseShipmentConfirmation
		|	AND ItemList.SalesOrderExists
		|	AND ItemList.SalesOrder.UseItemsShipmentScheduling";

EndFunction

Function R4050B_StockInventory()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	*
		|INTO R4050B_StockInventory
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService";

EndFunction

Function R2020B_AdvancesFromCustomers()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	OffsetOfAdvance.Period,
		|	OffsetOfAdvance.Company,
		|	OffsetOfAdvance.Currency,
		|	OffsetOfAdvance.LegalName,
		|	OffsetOfAdvance.Partner,
		|	OffsetOfAdvance.AdvancesDocument AS Basis,
		|	SUM(OffsetOfAdvance.Amount)
		|INTO R2020B_AdvancesFromCustomers
		|FROM
		|	OffsetOfAdvance AS OffsetOfAdvance
		|GROUP BY
		|	OffsetOfAdvance.Period,
		|	OffsetOfAdvance.Company,
		|	OffsetOfAdvance.Currency,
		|	OffsetOfAdvance.LegalName,
		|	OffsetOfAdvance.Partner,
		|	OffsetOfAdvance.AdvancesDocument,
		|	VALUE(AccumulationRecordType.Expense)";
EndFunction

Function R2021B_CustomersTransactions()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	CustomersTransactions.Period,
		|	CustomersTransactions.Company,
		|	CustomersTransactions.Currency,
		|	CustomersTransactions.LegalName,
		|	CustomersTransactions.Partner,
		|	CustomersTransactions.Agreement,
		|	CustomersTransactions.TransactionDocument AS Basis,
		|	SUM(CustomersTransactions.DocumentAmount) AS Amount
		|INTO R2021B_CustomersTransactions
		|FROM
		|	CustomersTransactions AS CustomersTransactions
		|GROUP BY
		|	CustomersTransactions.Period,
		|	CustomersTransactions.Company,
		|	CustomersTransactions.Currency,
		|	CustomersTransactions.LegalName,
		|	CustomersTransactions.Partner,
		|	CustomersTransactions.Agreement,
		|	CustomersTransactions.TransactionDocument,
		|	VALUE(AccumulationRecordType.Receipt)
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	OffsetOfAdvance.Period,
		|	OffsetOfAdvance.Company,
		|	OffsetOfAdvance.Currency,
		|	OffsetOfAdvance.LegalName,
		|	OffsetOfAdvance.Partner,
		|	OffsetOfAdvance.Agreement,
		|	OffsetOfAdvance.TransactionDocument,
		|	SUM(OffsetOfAdvance.Amount)
		|FROM
		|	OffsetOfAdvance AS OffsetOfAdvance
		|GROUP BY
		|	OffsetOfAdvance.Period,
		|	OffsetOfAdvance.Company,
		|	OffsetOfAdvance.Currency,
		|	OffsetOfAdvance.LegalName,
		|	OffsetOfAdvance.Partner,
		|	OffsetOfAdvance.Agreement,
		|	OffsetOfAdvance.TransactionDocument,
		|	VALUE(AccumulationRecordType.Expense)";
EndFunction

Function R5011B_PartnersAging()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	Aging.Period,
		|	Aging.Company,
		|	Aging.Currency,
		|	Aging.Agreement,
		|	Aging.Partner,
		|	Aging.Invoice,
		|	Aging.PaymentDate,
		|	Aging.Amount
		|INTO R5011B_PartnersAging
		|FROM
		|	Aging AS Aging
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	OffsetOfAging.Period,
		|	OffsetOfAging.Company,
		|	OffsetOfAging.Currency,
		|	OffsetOfAging.Agreement,
		|	OffsetOfAging.Partner,
		|	OffsetOfAging.Invoice,
		|	OffsetOfAging.PaymentDate,
		|	OffsetOfAging.Amount
		|FROM
		|	OffsetOfAging AS OffsetOfAging";
EndFunction

Function R5010B_ReconciliationStatement()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Company,
		|	ItemList.LegalName,
		|	ItemList.Currency,
		|	SUM(ItemList.Amount) AS Amount,
		|	ItemList.Period
		|INTO R5010B_ReconciliationStatement
		|FROM
		|	ItemList AS ItemList
		|GROUP BY
		|	ItemList.Company,
		|	ItemList.LegalName,
		|	ItemList.Currency,
		|	ItemList.Period";
EndFunction

#EndRegion