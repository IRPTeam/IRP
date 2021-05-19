#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("OrderBalance"                          , PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("SalesTurnovers"                        , PostingServer.CreateTable(AccReg.SalesTurnovers));
	Tables.Insert("ShipmentOrders"                        , PostingServer.CreateTable(AccReg.ShipmentOrders));
	Tables.Insert("ShipmentConfirmationSchedule_Expense"  , PostingServer.CreateTable(AccReg.ShipmentConfirmationSchedule));
	Tables.Insert("ShipmentConfirmationSchedule_Receipt"  , PostingServer.CreateTable(AccReg.ShipmentConfirmationSchedule));
	Tables.Insert("TaxesTurnovers"                        , PostingServer.CreateTable(AccReg.TaxesTurnovers));
	Tables.Insert("RevenuesTurnovers"                     , PostingServer.CreateTable(AccReg.RevenuesTurnovers));
	Tables.Insert("OrderBalance_Exists"           , PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("ShipmentOrders_Exists"         , PostingServer.CreateTable(AccReg.ShipmentOrders));
	
	Tables.OrderBalance_Exists =
	AccumulationRegisters.OrderBalance.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo);
		
	Tables.ShipmentOrders_Exists =
	AccumulationRegisters.ShipmentOrders.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo); 
	
	QueryItemList = New Query();
	QueryItemList.Text = GetQueryTextSalesInvoiceItemList();
	QueryItemList.SetParameter("Ref", Ref);
	QueryResultItemList = QueryItemList.Execute();
	QueryTableItemList = QueryResultItemList.Unload();
	PostingServer.CalculateQuantityByUnit(QueryTableItemList);
	
	QueryTaxList = New Query();
	QueryTaxList.Text = GetQueryTextSalesInvoiceTaxList();
	QueryTaxList.SetParameter("Ref", Ref);
	QueryResultTaxList = QueryTaxList.Execute();
	QueryTableTaxList = QueryResultTaxList.Unload();
	
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
	Tables.ShipmentOrders                       = QueryResult[2].Unload();
	Tables.ShipmentConfirmationSchedule_Expense = QueryResult[3].Unload();
	Tables.ShipmentConfirmationSchedule_Receipt = QueryResult[4].Unload();
	Tables.RevenuesTurnovers                    = QueryResult[5].Unload();
	
	Tables.TaxesTurnovers = QueryTableTaxList;
	Tables.SalesTurnovers = QueryTableSalesTurnovers;
	
#Region NewRegistersPosting	
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParamenters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	
	Tables.Insert("CustomersTransactions", 
	PostingServer.GetQueryTableByName("CustomersTransactions", Parameters));	
#EndRegion	
		
	Return Tables;
EndFunction

Function GetQueryTextSalesInvoiceItemList()
	Return
		"SELECT
		|	RowIDInfo.Ref AS Ref,
		|	RowIDInfo.Key AS Key,
		|	MAX(RowIDInfo.RowID) AS RowID
		|INTO RowIDInfo
		|FROM
		|	Document.SalesInvoice.RowIDInfo AS RowIDInfo
		|WHERE
		|	RowIDInfo.Ref = &Ref
		|GROUP BY
		|	RowIDInfo.Ref,
		|	RowIDInfo.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
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
		|	RowIDInfo.RowID AS RowKey,
		|	SalesInvoiceItemList.Key AS Key,
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
		|		LEFT JOIN RowIDInfo AS RowIDInfo
		|		ON SalesInvoiceItemList.Key = RowIDInfo.Key
		|WHERE
		|	SalesInvoiceItemList.Ref = &Ref";
EndFunction

Function GetQueryTextSalesInvoiceSalesTurnovers()
	Return 
	"SELECT
	|	RowIDInfo.Ref AS Ref,
	|	RowIDInfo.Key AS Key,
	|	MAX(RowIDInfo.RowID) AS RowID
	|INTO RowIDInfo
	|FROM
	|	Document.SalesInvoice.RowIDInfo AS RowIDInfo
	|WHERE
	|	RowIDInfo.Ref = &Ref
	|GROUP BY
	|	RowIDInfo.Ref,
	|	RowIDInfo.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SalesInvoiceItemList.Ref.Company AS Company,
	|	SalesInvoiceItemList.Ref.Currency AS Currency,
	|	SalesInvoiceItemList.ItemKey AS ItemKey,
	|	SUM(SalesInvoiceItemList.QuantityInBaseUnit) AS Quantity,
	|	SUM(ISNULL(SalesInvoiceSerialLotNumbers.Quantity, 0)) AS QuantityBySerialLtNumbers,
	|	SalesInvoiceItemList.Ref.Date AS Period,
	|	SalesInvoiceItemList.Ref AS SalesInvoice,
	|	SUM(SalesInvoiceItemList.TotalAmount) AS Amount,
	|	SUM(SalesInvoiceItemList.NetAmount) AS NetAmount,
	|	SUM(SalesInvoiceItemList.OffersAmount) AS OffersAmount,
	|	RowIDInfo.RowID AS RowKey,
	|	SalesInvoiceSerialLotNumbers.SerialLotNumber AS SerialLotNumber
	|INTO tmp
	|FROM
	|	Document.SalesInvoice.ItemList AS SalesInvoiceItemList
	|		LEFT JOIN Document.SalesInvoice.SerialLotNumbers AS SalesInvoiceSerialLotNumbers
	|		ON SalesInvoiceItemList.Key = SalesInvoiceSerialLotNumbers.Key
	|		AND SalesInvoiceItemList.Ref = SalesInvoiceSerialLotNumbers.Ref
	|		AND SalesInvoiceItemList.Ref = &Ref
	|		AND SalesInvoiceSerialLotNumbers.Ref = &Ref
	|		LEFT JOIN RowIDInfo AS RowIDInfo
	|		ON SalesInvoiceItemList.Key = RowIDInfo.Key
	|WHERE
	|	SalesInvoiceItemList.Ref = &Ref
	|GROUP BY
	|	SalesInvoiceItemList.Ref.Company,
	|	SalesInvoiceItemList.Ref.Currency,
	|	SalesInvoiceItemList.ItemKey,
	|	SalesInvoiceItemList.Ref.Date,
	|	SalesInvoiceItemList.Ref,
	|	RowIDInfo.RowID,
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

Function GetQueryTextSalesInvoiceTaxList()
	Return
	"SELECT
	|	RowIDInfo.Ref AS Ref,
	|	RowIDInfo.Key AS Key,
	|	MAX(RowIDInfo.RowID) AS RowID
	|INTO RowIDInfo
	|FROM
	|	Document.SalesInvoice.RowIDInfo AS RowIDInfo
	|WHERE
	|	RowIDInfo.Ref = &Ref
	|GROUP BY
	|	RowIDInfo.Ref,
	|	RowIDInfo.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SalesInvoiceTaxList.Ref AS Document,
	|	SalesInvoiceTaxList.Ref.Date AS Period,
	|	SalesInvoiceTaxList.Ref.Currency AS Currency,
	|	RowIDInfo.RowID AS RowKey,
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
	|		LEFT JOIN RowIDInfo AS RowIDInfo
	|		ON SalesInvoiceItemList.Key = RowIDInfo.Key
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
		|	QueryTable.DeliveryDate AS DeliveryDate,
		|	QueryTable.BusinessUnit AS BusinessUnit,
		|	QueryTable.RevenueType AS RevenueType,
		|	QueryTable.AdditionalAnalytic AS AdditionalAnalytic,
		|	QueryTable.NetAmount AS NetAmount,
		|	QueryTable.OffersAmount AS OffersAmount,
		|	QueryTable.IsService AS IsService,
		|	QueryTable.BasisDocument AS BasisDocument,
		|	QueryTable.Key AS Key,
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
		|	tmp.SalesOrder AS Order,
		|	ISNULL(ShipmentConfirmations.ShipmentConfirmation, VALUE(Document.ShipmentConfirmation.EmptyRef)) AS ShipmentConfirmation,
		|	tmp.ItemKey AS ItemKey,
		|	ISNULL(ShipmentConfirmations.Quantity, 0) AS Quantity,
		|	tmp.Period AS Period,
		|	tmp.RowKey AS RowKey
		|FROM
		|	tmp AS tmp
		|	LEFT JOIN Document.SalesInvoice.ShipmentConfirmations AS ShipmentConfirmations
		|	ON tmp.Key = ShipmentConfirmations.Key
		|	AND tmp.SalesInvoice = ShipmentConfirmations.Ref
		|WHERE
		|	tmp.ShipmentConfirmationBeforeSalesInvoice
		|	AND tmp.UseSalesOrder
		|;
		|
		|//[3]//////////////////////////////////////////////////////////////////////////////
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
		|//[4]//////////////////////////////////////////////////////////////////////////////
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
		|//[5]//////////////////////////////////////////////////////////////////////////////
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
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
#Region NewRegisterPosting
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion	
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// OrderBalance 
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction", 
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.OrderBalance,
			True));
	
	// SalesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.SalesTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.SalesTurnovers));
			
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
	
	
	// TaxesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.TaxesTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.TaxesTurnovers));
	
#Region NewRegistersPosting
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
#EndRegion			
	
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
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
#Region NewRegisterPosting
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion
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
	
	If Not Unposting And Ref.Agreement.UseCreditLimit Then
		OffsetOfPartnersServer.CheckCreditLimit(Ref, Cancel);
	EndIf;
	
	If Cancel Then
		Return;
	EndIf;
	
	Parameters.Insert("RecordType", AccumulationRecordType.Expense);
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.SalesInvoice.ItemList", AddInfo);
		
	LineNumberAndRowKeyFromItemList = PostingServer.GetLineNumberAndRowKeyFromItemList(Ref, "Document.SalesInvoice.ItemList");
	
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
	If ValueIsFilled(Ref) Then
		StrParams.Insert("BalancePeriod", New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	Else
		StrParams.Insert("BalancePeriod", Undefined);
	EndIf;
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(OffersInfo());
	QueryArray.Add(Taxes());
	QueryArray.Add(SerialLotNumbers());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
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
	QueryArray.Add(R4032B_GoodsInTransitOutgoing());
	QueryArray.Add(R4034B_GoodsShipmentSchedule());
	QueryArray.Add(R4050B_StockInventory());
	QueryArray.Add(R2021B_CustomersTransactions());//**1
	QueryArray.Add(R2020B_AdvancesFromCustomers());//**2
	QueryArray.Add(R5011B_PartnersAging());//**3
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(T1001I_PartnerTransactions());
	Return QueryArray;
EndFunction

Function ItemList()
	Return
	"SELECT
	|	RowIDInfo.Ref AS Ref,
	|	RowIDInfo.Key AS Key,
	|	MAX(RowIDInfo.RowID) AS RowID
	|INTO TableRowIDInfo
	|FROM
	|	Document.SalesInvoice.RowIDInfo AS RowIDInfo
	|WHERE
	|	RowIDInfo.Ref = &Ref
	|GROUP BY
	|	RowIDInfo.Ref,
	|	RowIDInfo.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
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
	|	TableRowIDInfo.RowID AS RowKey,
	|	SalesInvoiceItemList.DeliveryDate AS DeliveryDate,
	|	SalesInvoiceItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
	|	SalesInvoiceItemList.BusinessUnit AS BusinessUnit,
	|	SalesInvoiceItemList.RevenueType AS RevenueType,
	|	SalesInvoiceItemList.AdditionalAnalytic AS AdditionalAnalytic,
	|	CASE
	|		WHEN SalesInvoiceItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
	|			THEN SalesInvoiceItemList.Ref
	|		ELSE UNDEFINED
	|	END AS Basis,
	|	SalesInvoiceItemList.NetAmount AS NetAmount,
	|	SalesInvoiceItemList.OffersAmount AS OffersAmount,
	|	SalesInvoiceItemList.UseShipmentConfirmation AS UseShipmentConfirmation,
	|	SalesInvoiceItemList.Ref.IgnoreAdvances AS IgnoreAdvances,
	|	SalesInvoiceItemList.Key
	|INTO ItemList
	|FROM
	|	Document.SalesInvoice.ItemList AS SalesInvoiceItemList
	|		LEFT JOIN ShipmentConfirmations AS ShipmentConfirmations
	|		ON SalesInvoiceItemList.Key = ShipmentConfirmations.Key
	|		LEFT JOIN TableRowIDInfo AS TableRowIDInfo
	|		ON SalesInvoiceItemList.Key = TableRowIDInfo.Key
	|WHERE
	|	SalesInvoiceItemList.Ref = &Ref
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SalesInvoiceShipmentConfirmations.Key,
	|	SalesInvoiceShipmentConfirmations.ShipmentConfirmation,
	|	SalesInvoiceShipmentConfirmations.Quantity
	|INTO ShipmentConfirmationsInfo
	|FROM
	|	Document.SalesInvoice.ShipmentConfirmations AS SalesInvoiceShipmentConfirmations
	|WHERE
	|	SalesInvoiceShipmentConfirmations.Ref = &Ref
	|";
EndFunction

Function OffersInfo()
	Return
		"SELECT
		|	SalesInvoiceItemList.Ref.Date AS Period,
		|	SalesInvoiceItemList.Ref AS Invoice,
		|	TableRowIDInfo.RowID AS RowKey,
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
		|		AND SalesInvoiceSpecialOffers.Ref = &Ref
		|		INNER JOIN TableRowIDInfo AS TableRowIDInfo
		|		ON SalesInvoiceItemList.Key = TableRowIDInfo.Key";
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
		|		AND ItemList.Ref = &Ref
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
		|	AND ItemList.SalesOrderExists
		|	AND NOT ItemList.ShipmentConfirmationExists";

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
		|		ON ItemList.Key = ShipmentConfirmations.Key
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

#Region Stock

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
		|	AND NOT ItemList.UseShipmentConfirmation
		|	AND NOT ItemList.ShipmentConfirmationExists";
EndFunction

Function R4011B_FreeStocks()
	
	Return
		
		"SELECT
		|	ItemList.Period AS Period,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.SalesOrder AS SalesOrder,
		|	ItemList.SalesOrderExists AS SalesOrderExists,
		|	SUM(ItemList.Quantity) AS Quantity
		|INTO ItemListGroup
		|FROM
		|	ItemList AS ItemList
		|Where
		|	NOT ItemList.IsService
		|	AND NOT ItemList.UseShipmentConfirmation
		|	AND NOT ItemList.ShipmentConfirmationExists
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	ItemList.SalesOrder,
		|	ItemList.SalesOrderExists
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	StockReservation.Store AS Store,
		|	StockReservation.Order AS Basis,
		|	StockReservation.ItemKey AS ItemKey,
		|	StockReservation.QuantityBalance AS Quantity
		|INTO TmpStockReservation
		|FROM
		|	AccumulationRegister.R4012B_StockReservation.Balance(&BalancePeriod, (Store, ItemKey, Order) IN
		|		(SELECT
		|			ItemList.Store,
		|			ItemList.ItemKey,
		|			ItemList.SalesOrder
		|		FROM
		|			ItemList AS ItemList)) AS StockReservation
		|WHERE
		|	StockReservation.QuantityBalance > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemListGroup.Period AS Period,
		|	ItemListGroup.Store AS Store,
		|	ItemListGroup.ItemKey AS ItemKey,
		|	ItemListGroup.Quantity - ISNULL(TmpStockReservation.Quantity, 0) AS Quantity
		|INTO R4011B_FreeStocks
		|FROM
		|	ItemListGroup AS ItemListGroup
		|		LEFT JOIN TmpStockReservation AS TmpStockReservation
		|		ON (ItemListGroup.Store = TmpStockReservation.Store)
		|		AND (ItemListGroup.ItemKey = TmpStockReservation.ItemKey)
		|		AND TmpStockReservation.Basis = ItemListGroup.SalesOrder
		|WHERE
		|	ItemListGroup.Quantity > ISNULL(TmpStockReservation.Quantity, 0)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|DROP ItemListGroup
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|DROP TmpStockReservation";
EndFunction

Function R4012B_StockReservation()
	Return
		"SELECT
		|	ItemList.Period AS Period,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.SalesOrder AS SalesOrder,
		|	SUM(ItemList.Quantity) AS Quantity,
		|	ItemList.UseShipmentConfirmation AS UseShipmentConfirmation,
		|	ItemList.ShipmentConfirmationExists AS ShipmentConfirmationExists
		|INTO TmpItemListGroup
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|	AND NOT ItemList.UseShipmentConfirmation
		|	AND NOT ItemList.ShipmentConfirmationExists
		|	AND ItemList.SalesOrderExists
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	ItemList.SalesOrder,
		|	ItemList.UseShipmentConfirmation,
		|	ItemList.ShipmentConfirmationExists
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	R4012B_StockReservationBalance.Store AS Store,
		|	R4012B_StockReservationBalance.ItemKey AS ItemKey,
		|	R4012B_StockReservationBalance.Order AS Order,
		|	R4012B_StockReservationBalance.QuantityBalance AS QuantityBalance
		|INTO TmpStockReservation
		|FROM
		|	AccumulationRegister.R4012B_StockReservation.Balance(&BalancePeriod, (Store, ItemKey, Order) IN
		|		(SELECT
		|			ItemList.Store,
		|			ItemList.ItemKey,
		|			ItemList.SalesOrder
		|		FROM
		|			TmpItemListGroup AS ItemList)) AS R4012B_StockReservationBalance
		|WHERE
		|	R4012B_StockReservationBalance.QuantityBalance > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
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
		|	TmpItemListGroup AS ItemListGroup
		|		INNER JOIN TmpStockReservation AS StockReservation
		|		ON ItemListGroup.SalesOrder = StockReservation.Order
		|		AND ItemListGroup.ItemKey = StockReservation.ItemKey
		|		AND ItemListGroup.Store = StockReservation.Store
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|DROP TmpItemListGroup
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|DROP TmpStockReservation";
EndFunction

Function R4032B_GoodsInTransitOutgoing()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	CASE
		|		WHEN ItemList.ShipmentConfirmationExists
		|			Then ShipmentConfirmations.ShipmentConfirmation
		|		Else ItemList.Invoice
		|	End AS Basis,
		|	CASE 
		|		WHEN ItemList.ShipmentConfirmationExists
		|			Then ShipmentConfirmations.Quantity
		|		Else ItemList.Quantity
		|	End AS Quantity,
		|	*
		|INTO R4032B_GoodsInTransitOutgoing
		|FROM
		|	ItemList AS ItemList
		|		LEFT JOIN ShipmentConfirmationsInfo AS ShipmentConfirmations
		|		ON ItemList.Key = ShipmentConfirmations.Key
		|WHERE
		|	NOT ItemList.IsService
		|	AND (ItemList.UseShipmentConfirmation
		|		OR ItemList.ShipmentConfirmationExists)";

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

#EndRegion

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

Function R2020B_AdvancesFromCustomers()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	OffsetOfAdvances.AdvancesDocument AS Basis,
		|	OffsetOfAdvances.Recorder AS CustomersAdvancesClosing,
		|	*
		|INTO R2020B_AdvancesFromCustomers
		|FROM
		|	InformationRegister.T1000I_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref";
EndFunction

Function R2021B_CustomersTransactions()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Currency,
		|	ItemList.LegalName,
		|	ItemList.Partner,
		|	ItemList.Agreement,
		|	ItemList.Basis,
		|	SUM(ItemList.Amount) AS Amount,
		|	UNDEFINED AS CustomersAdvancesClosing
		|INTO R2021B_CustomersTransactions
		|FROM
		|	ItemList AS ItemList
		|GROUP BY
		|	ItemList.Agreement,
		|	ItemList.Basis,
		|	ItemList.Company,
		|	ItemList.Currency,
		|	ItemList.LegalName,
		|	ItemList.Partner,
		|	ItemList.Period,
		|	VALUE(AccumulationRecordType.Receipt)
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.Agreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T1000I_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref";
EndFunction

Function T1001I_PartnerTransactions()
	Return
		"SELECT
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Currency,
		|	ItemList.LegalName,
		|	ItemList.Partner,
		|	ItemList.Agreement,
		|	ItemList.Basis AS TransactionDocument,
		|	TRUE AS IsCustomerTransaction,
		|	SUM(ItemList.Amount) AS Amount,
		|	ItemList.Key
		|INTO T1001I_PartnerTransactions
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IgnoreAdvances
		|GROUP BY
		|	ItemList.Agreement,
		|	ItemList.Basis,
		|	ItemList.Company,
		|	ItemList.Currency,
		|	ItemList.Key,
		|	ItemList.LegalName,
		|	ItemList.Partner,
		|	ItemList.Period";
EndFunction		

Function R5011B_PartnersAging()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentTerms.Ref.Date AS Period,
		|	PaymentTerms.Ref.Company AS Company,
		|	PaymentTerms.Ref.Currency AS Currency,
		|	PaymentTerms.Ref.Agreement AS Agreement,
		|	PaymentTerms.Ref.Partner AS Partner,
		|	PaymentTerms.Ref AS Invoice,
		|	PaymentTerms.Date AS PaymentDate,
		|	SUM(PaymentTerms.Amount) AS Amount
		|INTO R5011B_PartnersAging
		|FROM
		|	Document.SalesInvoice.PaymentTerms AS PaymentTerms
		|WHERE
		|	PaymentTerms.Ref = &Ref
		|GROUP BY
		|	PaymentTerms.Date,
		|	PaymentTerms.Ref,
		|	PaymentTerms.Ref.Agreement,
		|	PaymentTerms.Ref.Company,
		|	PaymentTerms.Ref.Currency,
		|	PaymentTerms.Ref.Date,
		|	PaymentTerms.Ref.Partner,
		|	VALUE(AccumulationRecordType.Receipt)";
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