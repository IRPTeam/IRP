#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("OrderBalance"                          , PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("InventoryBalance"                      , PostingServer.CreateTable(AccReg.InventoryBalance));
	Tables.Insert("GoodsInTransitIncoming"                , PostingServer.CreateTable(AccReg.GoodsInTransitIncoming));
	Tables.Insert("StockBalance"                          , PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("StockReservation_Receipt"              , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockReservation_Expense"              , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("PartnerApTransactions"                 , PostingServer.CreateTable(AccReg.PartnerApTransactions));
	Tables.Insert("PurchaseTurnovers"                     , PostingServer.CreateTable(AccReg.PurchaseTurnovers));
	Tables.Insert("AdvanceToSuppliers_Lock"               , PostingServer.CreateTable(AccReg.AdvanceToSuppliers));
	Tables.Insert("PartnerApTransactions_OffsetOfAdvance" , PostingServer.CreateTable(AccReg.AdvanceToSuppliers));
	Tables.Insert("ReceiptOrders"                         , PostingServer.CreateTable(AccReg.ReceiptOrders));
	Tables.Insert("ExpensesTurnovers"                     , PostingServer.CreateTable(AccReg.ExpensesTurnovers));
	Tables.Insert("GoodsReceiptSchedule_Expense"          , PostingServer.CreateTable(AccReg.GoodsReceiptSchedule));
	Tables.Insert("GoodsReceiptSchedule_Receipt"          , PostingServer.CreateTable(AccReg.GoodsReceiptSchedule));
	Tables.Insert("OrderProcurement"                      , PostingServer.CreateTable(AccReg.OrderProcurement));
	Tables.Insert("ReconciliationStatement"               , PostingServer.CreateTable(AccReg.ReconciliationStatement));
	Tables.Insert("TaxesTurnovers"                        , PostingServer.CreateTable(AccReg.TaxesTurnovers));
	Tables.Insert("R4035_IncommingStocks"                 , PostingServer.CreateTable(AccReg.R4035_IncommingStocks));
	Tables.Insert("R4036_IncommingStocksRequested"        , PostingServer.CreateTable(AccReg.R4036_IncommingStocksRequested));
	
	Tables.Insert("OrderBalance_Exists"           , PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("GoodsInTransitIncoming_Exists" , PostingServer.CreateTable(AccReg.GoodsInTransitIncoming));
	Tables.Insert("OrderProcurement_Exists"       , PostingServer.CreateTable(AccReg.OrderProcurement));
	Tables.Insert("ReceiptOrders_Exists"          , PostingServer.CreateTable(AccReg.ReceiptOrders));
	
	Tables.Insert("StockReservation_Exists" , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockBalance_Exists"     , PostingServer.CreateTable(AccReg.StockBalance));
	
	Tables.OrderBalance_Exists
	= AccumulationRegisters.OrderBalance.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo);
	
	Tables.GoodsInTransitIncoming_Exists
	= AccumulationRegisters.GoodsInTransitIncoming.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Tables.OrderProcurement_Exists
	= AccumulationRegisters.OrderProcurement.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo);
	
	Tables.ReceiptOrders_Exists
	= AccumulationRegisters.ReceiptOrders.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo);
	
	Tables.StockReservation_Exists = 
	AccumulationRegisters.StockReservation.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Tables.StockBalance_Exists = 
	AccumulationRegisters.StockBalance.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	GoodsReceipts.Key
		|INTO GoodsReceipts
		|FROM
		|	Document.PurchaseInvoice.GoodsReceipts AS GoodsReceipts
		|WHERE
		|	GoodsReceipts.Ref = &Ref
		|GROUP BY
		|	GoodsReceipts.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	PurchaseInvoiceItemList.Ref.Company AS Company,
		|	PurchaseInvoiceItemList.Store AS Store,
		|	PurchaseInvoiceItemList.Store.UseGoodsReceipt AS UseGoodsReceipt,
		|	PurchaseInvoiceItemList.Store.UseShipmentConfirmation AS UseShipmentConfirmation,
		|	CASE
		|		WHEN GoodsReceipts.Key IS NULL
		|			THEN FALSE
		|		ELSE TRUE
		|	END
		|	OR CASE
		|		WHEN PurchaseInvoiceItemList.PurchaseOrder.Date IS NULL
		|			THEN FALSE
		|		ELSE PurchaseInvoiceItemList.PurchaseOrder.GoodsReceiptBeforePurchaseInvoice
		|	END AS UseGoodsReceiptBeforeInvoice,
		|	CASE
		|		WHEN PurchaseInvoiceItemList.PurchaseOrder.Date IS NULL
		|			THEN FALSE
		|		ELSE TRUE
		|	END AS UsePurchaseOrder,
		|	CASE
		|		WHEN PurchaseInvoiceItemList.SalesOrder.Date IS NULL
		|			THEN FALSE
		|		ELSE TRUE
		|	END AS UseSalesOrder,
		|	CASE
		|		WHEN NOT PurchaseInvoiceItemList.SalesOrder.Date IS NULL
		|			THEN PurchaseInvoiceItemList.SalesOrder.ShipmentConfirmationsBeforeSalesInvoice
		|		ELSE FALSE
		|	END AS UseShipmentBeforeInvoice,
		|	PurchaseInvoiceItemList.ItemKey AS ItemKey,
		|	PurchaseInvoiceItemList.PurchaseOrder AS PurchaseOrder,
		|	PurchaseInvoiceItemList.SalesOrder AS SalesOrder,
		|	PurchaseInvoiceItemList.Ref AS ReceiptBasis,
		|	PurchaseInvoiceItemList.Ref AS PurchaseInvoice,
		|	PurchaseInvoiceItemList.Quantity AS Quantity,
		|	PurchaseInvoiceItemList.TotalAmount AS TotalAmount,
		|	PurchaseInvoiceItemList.Ref.Partner AS Partner,
		|	PurchaseInvoiceItemList.Ref.LegalName AS LegalName,
		|	CASE
		|		WHEN PurchaseInvoiceItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND PurchaseInvoiceItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN PurchaseInvoiceItemList.Ref.Agreement.StandardAgreement
		|		ELSE PurchaseInvoiceItemList.Ref.Agreement
		|	END AS Agreement,
		|	ISNULL(PurchaseInvoiceItemList.Ref.Currency, VALUE(Catalog.Currencies.EmptyRef)) AS Currency,
		|	0 AS BasisQuantity,
		|	PurchaseInvoiceItemList.Unit AS Unit,
		|	PurchaseInvoiceItemList.ItemKey.Item.Unit AS ItemUnit,
		|	PurchaseInvoiceItemList.ItemKey.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	PurchaseInvoiceItemList.ItemKey.Item AS Item,
		|	PurchaseInvoiceItemList.Ref.Date AS Period,
		|	PurchaseInvoiceItemList.Key AS RowKeyUUID,
		|	PurchaseInvoiceItemList.AdditionalAnalytic AS AdditionalAnalytic,
		|	PurchaseInvoiceItemList.BusinessUnit AS BusinessUnit,
		|	PurchaseInvoiceItemList.ExpenseType AS ExpenseType,
		|	CASE
		|		WHEN PurchaseInvoiceItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service)
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsService,
		|	PurchaseInvoiceItemList.DeliveryDate AS DeliveryDate,
		|	PurchaseInvoiceItemList.NetAmount AS NetAmount
		|FROM
		|	Document.PurchaseInvoice.ItemList AS PurchaseInvoiceItemList
		|		LEFT JOIN GoodsReceipts AS GoodsReceipts
		|		ON PurchaseInvoiceItemList.Key = GoodsReceipts.Key
		|WHERE
		|	PurchaseInvoiceItemList.Ref = &Ref";
	
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.Execute();
	QueryTable = QueryResults.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTable);
	PostingServer.UUIDToString(QueryTable);
	
	QueryTaxList = New Query();
	QueryTaxList.Text =
		"SELECT
		|	PurchaseInvoiceTaxList.Ref AS Document,
		|	PurchaseInvoiceTaxList.Ref.Date AS Period,
		|	PurchaseInvoiceTaxList.Key AS RowKeyUUID,
		|	PurchaseInvoiceTaxList.Tax AS Tax,
		|	PurchaseInvoiceTaxList.Analytics AS Analytics,
		|	PurchaseInvoiceTaxList.TaxRate AS TaxRate,
		|	PurchaseInvoiceTaxList.Amount AS Amount,
		|	PurchaseInvoiceTaxList.IncludeToTotalAmount AS IncludeToTotalAmount,
		|	PurchaseInvoiceTaxList.ManualAmount AS ManualAmount,
		|	PurchaseInvoiceItemList.NetAmount AS NetAmount,
		|	PurchaseInvoiceItemList.Ref.Currency AS Currency
		|FROM
		|	Document.PurchaseInvoice.TaxList AS PurchaseInvoiceTaxList
		|		INNER JOIN Document.PurchaseInvoice.ItemList AS PurchaseInvoiceItemList
		|		ON PurchaseInvoiceTaxList.Ref = PurchaseInvoiceItemList.Ref
		|		AND PurchaseInvoiceItemList.Ref = &Ref
		|		AND PurchaseInvoiceTaxList.Ref = &Ref
		|		AND PurchaseInvoiceItemList.Key = PurchaseInvoiceTaxList.Key
		|WHERE
		|	PurchaseInvoiceTaxList.Ref = &Ref";
	
	QueryTaxList.SetParameter("Ref", Ref);
	QueryResultTaxList = QueryTaxList.Execute();
	QueryTableTaxList = QueryResultTaxList.Unload();
	PostingServer.UUIDToString(QueryTableTaxList);
	Tables.TaxesTurnovers = QueryTableTaxList;
	
	TempManager = New TempTablesManager();
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
	"SELECT
	|	PurchaseInvoiceGoodsReceipts.Ref,
	|	PurchaseInvoiceGoodsReceipts.Key AS RowKeyUUID,
	|	PurchaseInvoiceGoodsReceipts.GoodsReceipt,
	|	PurchaseInvoiceGoodsReceipts.Quantity
	|INTO GoodsReceipts
	|FROM
	|	Document.PurchaseInvoice.GoodsReceipts AS PurchaseInvoiceGoodsReceipts
	|WHERE
	|	PurchaseInvoiceGoodsReceipts.Ref = &Ref";
	Query.SetParameter("Ref", Ref);
	Query.Execute();
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Partner AS Partner,
		|	QueryTable.LegalName AS LegalName,
		|	QueryTable.Agreement AS Agreement,
		|	QueryTable.Currency AS Currency,
		|	QueryTable.AdditionalAnalytic AS AdditionalAnalytic,
		|	QueryTable.TotalAmount AS Amount,
		|	QueryTable.NetAmount AS NetAmount,
		|	QueryTable.Store AS Store,
		|	QueryTable.UseGoodsReceipt AS UseGoodsReceipt,
		|   QueryTable.UseShipmentConfirmation AS UseShipmentConfirmation,
		|	QueryTable.UseGoodsReceiptBeforeInvoice AS UseGoodsReceiptBeforeInvoice,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.PurchaseOrder AS Order,
		|	QueryTable.ReceiptBasis AS ReceiptBasis,
		|	QueryTable.PurchaseInvoice AS PurchaseInvoice,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BasisUnit AS Unit,
		|	QueryTable.Period AS Period,
		|	QueryTable.RowKey AS RowKey,
		|	QueryTable.RowKeyUUID AS RowKeyUUID,
		|	QueryTable.BusinessUnit AS BusinessUnit,
		|	QueryTable.ExpenseType,
		|	QueryTable.IsService AS IsService,
		|	QueryTable.DeliveryDate AS DeliveryDate,
		|	QueryTable.UsePurchaseOrder,
		|	QueryTable.UseSalesOrder,
		|   QueryTable.UseShipmentBeforeInvoice,
		|	QueryTable.SalesOrder
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable";
	Query.SetParameter("QueryTable", QueryTable);
	Query.Execute();
	
	GetTables_Common(Tables, TempManager, "tmp", Parameters);
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM tmp AS tmp
		|WHERE
		|    NOT tmp.UsePurchaseOrder
		|AND NOT tmp.UseSalesOrder
		|AND NOT tmp.UseGoodsReceiptBeforeInvoice";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_1").GetData().IsEmpty() Then
		GetTables_NotUsePO_NotUseSO_NotUseGRBeforeInvoice(Tables, TempManager, "tmp_1", Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_2 FROM tmp AS tmp
		|WHERE
		|        tmp.UsePurchaseOrder
		|AND NOT tmp.UseSalesOrder
		|AND NOT tmp.UseGoodsReceiptBeforeInvoice";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_2").GetData().IsEmpty() Then
		GetTables_UsePO_NotUseSO_NotUseGRBeforeInvoice(Tables, TempManager, "tmp_2", Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM tmp AS tmp
		|WHERE
		|        tmp.UsePurchaseOrder
		|AND NOT tmp.UseSalesOrder
		|AND     tmp.UseGoodsReceiptBeforeInvoice";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_3").GetData().IsEmpty() Then
		GetTables_UsePO_NotUseSO_UseGRBeforeInvoice(Tables, TempManager, "tmp_3", Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_4 FROM tmp AS tmp
		|WHERE
		|        tmp.UsePurchaseOrder
		|AND     tmp.UseSalesOrder
		|AND NOT tmp.UseGoodsReceiptBeforeInvoice
		|AND NOT tmp.UseShipmentBeforeInvoice";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_4").GetData().IsEmpty() Then
		GetTables_UsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice(Tables, TempManager, "tmp_4", Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_5 FROM tmp AS tmp
		|WHERE
		|    NOT tmp.UsePurchaseOrder
		|AND     tmp.UseSalesOrder
		|AND NOT tmp.UseGoodsReceiptBeforeInvoice
		|AND NOT tmp.UseShipmentBeforeInvoice";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_5").GetData().IsEmpty() Then
		GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice(Tables, TempManager, "tmp_5", Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_6 FROM tmp AS tmp
		|WHERE
		|        tmp.UsePurchaseOrder
		|AND     tmp.UseSalesOrder
		|AND     tmp.UseGoodsReceiptBeforeInvoice
		|AND NOT tmp.UseShipmentBeforeInvoice";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_6").GetData().IsEmpty() Then
		GetTables_UsePO_UseSO_GRBeforeInvoice_NotSCBeforeInvoice(Tables, TempManager, "tmp_6", Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_7 FROM tmp AS tmp
		|WHERE
		|        tmp.UsePurchaseOrder
		|AND     tmp.UseSalesOrder
		|AND NOT tmp.UseGoodsReceiptBeforeInvoice
		|AND     tmp.UseShipmentBeforeInvoice";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_7").GetData().IsEmpty() Then
		GetTables_UsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice(Tables, TempManager, "tmp_7", Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_8 FROM tmp AS tmp
		|WHERE
		|    NOT tmp.UsePurchaseOrder
		|AND     tmp.UseSalesOrder
		|AND NOT tmp.UseGoodsReceiptBeforeInvoice
		|AND     tmp.UseShipmentBeforeInvoice";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_8").GetData().IsEmpty() Then
		GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice(Tables, TempManager, "tmp_8", Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_9 FROM tmp AS tmp
		|WHERE
		|        tmp.UsePurchaseOrder
		|AND     tmp.UseSalesOrder
		|AND     tmp.UseGoodsReceiptBeforeInvoice
		|AND     tmp.UseShipmentBeforeInvoice";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_9").GetData().IsEmpty() Then
		GetTables_UsePO_UseSO_GRBeforeInvoice_SCBeforeInvoice(Tables, TempManager, "tmp_9", Parameters);
	EndIf;
	
	Parameters.IsReposting = False;	
	Return Tables;
EndFunction

Procedure GetTables_Common(Tables, TempManager, TableName, Parameters)
	// tmp
	Query = New Query();
	Query.TempTablesManager = TempManager;
	#Region QueryText
	Query.Text =
		// [0]
		"SELECT
		|	tmp.Company AS Company,
		|	CASE
		|		WHEN tmp.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN tmp.PurchaseInvoice
		|		ELSE UNDEFINED
		|	END AS BasisDocument,
		|	tmp.Partner AS Partner,
		|	tmp.LegalName AS LegalName,
		|	tmp.Agreement AS Agreement,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	CASE
		|		WHEN tmp.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN tmp.PurchaseInvoice
		|		ELSE UNDEFINED
		|	END,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Agreement,
		|	tmp.Currency,
		|	tmp.Period
		|;
		|
		|//[1]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.PurchaseInvoice,
		|	tmp.Currency,
		|	tmp.ItemKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Amount AS Amount,
		|	tmp.NetAmount AS NetAmount,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|
		|//[2]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	CASE
		|		WHEN tmp.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN tmp.PurchaseInvoice
		|		ELSE UNDEFINED
		|	END AS BasisDocument,
		|	tmp.Partner AS Partner,
		|	tmp.LegalName AS LegalName,
		|	tmp.Agreement AS Agreement,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS DocumentAmount,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	CASE
		|		WHEN tmp.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN tmp.PurchaseInvoice
		|		ELSE UNDEFINED
		|	END,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Agreement,
		|	tmp.Currency,
		|	tmp.Period
		|;
		|
		|//[3]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.LegalName AS LegalName,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.Period";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	Tables.PartnerApTransactions                 = QueryResults[0].Unload();
	Tables.PurchaseTurnovers                     = QueryResults[1].Unload();
	Tables.AdvanceToSuppliers_Lock               = QueryResults[2].Unload();
	Tables.PartnerApTransactions_OffsetOfAdvance = New ValueTable();
	Tables.ReconciliationStatement               = QueryResults[3].Unload();
EndProcedure

#Region Table_tmp_1

Procedure GetTables_NotUsePO_NotUseSO_NotUseGRBeforeInvoice(Tables, TempManager, TableName, Parameters)
	// tmp_1
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM source AS tmp
		|WHERE 
		|	 NOT tmp.UseGoodsReceipt
		|AND NOT tmp.IsService";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUsePO_NotUseSO_NotUseGRBeforeInvoice_NotUseGR_IsProduct(Tables, TempManager, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_2 FROM source AS tmp
		|WHERE 
		|	     tmp.UseGoodsReceipt
		|AND NOT tmp.IsService";
	NewTableName = StrReplace("tmp_2", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_2", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUsePO_NotUseSO_NotUseGRBeforeInvoice_UseGR_IsProduct(Tables, TempManager, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM source AS tmp
		|WHERE 
		|	tmp.IsService";
	NewTableName = StrReplace("tmp_3", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_3", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUsePO_NotUseSO_NotUseGRBeforeInvoice_IsService(Tables, TempManager, NewTableName, Parameters);
	EndIf;
EndProcedure

Procedure GetTables_NotUsePO_NotUseSO_NotUseGRBeforeInvoice_NotUseGR_IsProduct(Tables, TempManager, TableName, Parameters)
	// tmp_1_1
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		"//[0] InventoryBalance
		|SELECT
		|	tmp.Company,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|   tmp.ItemKey,
		|	tmp.Period
		|;
		|//[1] StockBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|//[2] StockReservation_Receipt
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|//[3] GoodsReceiptSchedule_Expense
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.PurchaseInvoice AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|;
		|
		|//[4] GoodsReceiptSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.PurchaseInvoice AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	 tmp.DeliveryDate <> DATETIME(1, 1, 1)";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.InventoryBalance             , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance                 , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Receipt     , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense , QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Receipt , QueryResults[4].Unload());
EndProcedure

Procedure GetTables_NotUsePO_NotUseSO_NotUseGRBeforeInvoice_UseGR_IsProduct(Tables, TempManager, TableName, Parameters)
	// tmp_1_2
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		// [0] InventoryBalance
		"SELECT
		|	tmp.Company,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|//[1] GoodsInTransitIncoming
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|//[2] GoodsReceiptSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.PurchaseInvoice AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.InventoryBalance             , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsInTransitIncoming       , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Receipt , QueryResults[2].Unload());
EndProcedure

Procedure GetTables_NotUsePO_NotUseSO_NotUseGRBeforeInvoice_IsService(Tables, TempManager, TableName, Parameters)
	// tmp_1_3
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		// [0] ExpensesTurnovers
		"SELECT
		|	tmp.Company AS Company,
		|	tmp.BusinessUnit AS BusinessUnit,
		|	tmp.ExpenseType AS ExpenseType,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.Currency AS Currency,
		|	tmp.AdditionalAnalytic AS AdditionalAnalytic,
		|	tmp.Period AS Period,
		|	SUM(tmp.Amount) AS Amount
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.BusinessUnit,
		|	tmp.ExpenseType,
		|	tmp.ItemKey,
		|	tmp.Currency,
		|	tmp.AdditionalAnalytic,
		|	tmp.Period
		|;
		|
		|//[1] GoodsReceiptSchedule_Expense
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.PurchaseInvoice AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|;
		|
		|//[2] GoodsReceiptSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.PurchaseInvoice AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.ExpensesTurnovers            , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Receipt , QueryResults[2].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_2

Procedure GetTables_UsePO_NotUseSO_NotUseGRBeforeInvoice(Tables, TempManager, TableName, Parameters)
	// tmp_2
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM source AS tmp
		|WHERE 
		|	 NOT tmp.UseGoodsReceipt
		|AND NOT tmp.IsService";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UsePO_NotUseSO_NotUseGRBeforeInvoice_NotUseGR_IsProduct(Tables, TempManager, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_2 FROM source AS tmp
		|WHERE 
		|	     tmp.UseGoodsReceipt
		|AND NOT tmp.IsService";
	NewTableName = StrReplace("tmp_2", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_2", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UsePO_NotUseSO_NotUseGRBeforeInvoice_UseGR_IsProduct(Tables, TempManager, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM source AS tmp
		|WHERE 
		|	tmp.IsService";
	NewTableName = StrReplace("tmp_3", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_3", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UsePO_NotUseSO_NotUseGRBeforeInvoice_IsService(Tables, TempManager, NewTableName, Parameters);
	EndIf;
EndProcedure

Procedure GetTables_UsePO_NotUseSO_NotUseGRBeforeInvoice_NotUseGR_IsProduct(Tables, TempManager, TableName, Parameters)
	// tmp_2_1
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		"//[0] InventoryBalance
		|SELECT
		|	tmp.Company,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|   tmp.ItemKey,
		|	tmp.Period
		|;
		|//[1] StockBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|//[2] StockReservation_Receipt
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|//[3] GoodsReceiptSchedule_Expense
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.GoodsReceiptSchedule AS GoodsReceiptSchedule
		|		ON GoodsReceiptSchedule.Recorder = tmp.Order
		|		AND GoodsReceiptSchedule.RowKey = tmp.RowKey
		|		AND GoodsReceiptSchedule.Company = tmp.Company
		|		AND GoodsReceiptSchedule.Store = tmp.Store
		|		AND GoodsReceiptSchedule.ItemKey = tmp.ItemKey
		|		AND GoodsReceiptSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|;
		|
		|//[4] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|//[5] R4035_IncommingStocks
		|SELECT
		|	tmp.Period,
		|	IncomingStocks.Store AS Store,
		|	IncomingStocks.ItemKey,
		|	IncomingStocks.Order,
		|	CASE WHEN tmp.Quantity < IncomingStocks.QuantityBalance THEN
		|	tmp.Quantity ELSE IncomingStocks.QuantityBalance END AS Quantity
		|FROM
		|	AccumulationRegister.R4035_IncommingStocks.Balance(&Period,(Store, ItemKey, Order) IN
		|		(SELECT
		|			tmp.Store,
		|			tmp.ItemKey,
		|			tmp.Order
		|		FROM
		|			tmp AS tmp)) AS IncomingStocks
		|		INNER JOIN tmp AS tmp
		|		ON IncomingStocks.Store = tmp.Store
		|		AND IncomingStocks.ItemKey = tmp.ItemKey
		|		AND IncomingStocks.Order = tmp.Order
		|		AND tmp.UsePurchaseOrder
		|;
		|//[6] R4036_IncommingStocksRequested
		|SELECT
		|	tmp.Period,
		|	IncomingStocksRequested.IncommingStore,
		|	IncomingStocksRequested.RequesterStore,
		|	IncomingStocksRequested.ItemKey,
		|	IncomingStocksRequested.Order,
		|	IncomingStocksRequested.Requester AS Requester,
		|	CASE WHEN tmp.Quantity < IncomingStocksRequested.QuantityBalance THEN tmp.Quantity
		|	ELSE IncomingStocksRequested.QuantityBalance END AS Quantity
		|FROM
		|	AccumulationRegister.R4036_IncommingStocksRequested.Balance(&Period,(IncommingStore, ItemKey, Order) IN
		|		(SELECT
		|			tmp.Store,
		|			tmp.ItemKey,
		|			tmp.Order
		|		FROM
		|			tmp AS tmp)) AS IncomingStocksRequested
		|		INNER JOIN tmp AS tmp
		|		ON IncomingStocksRequested.IncommingStore = tmp.Store
		|		AND IncomingStocksRequested.ItemKey = tmp.ItemKey
		|		AND IncomingStocksRequested.Order = tmp.Order
		|		AND tmp.UsePurchaseOrder
		|;
		|//[7] StockReservation_Expense
		|SELECT
		|	tmp.Period,
		|	IncomingStocksRequested.IncommingStore AS Store,
		|	IncomingStocksRequested.ItemKey,
		|	CASE WHEN tmp.Quantity < IncomingStocksRequested.QuantityBalance THEN tmp.Quantity
		|	ELSE IncomingStocksRequested.QuantityBalance END AS Quantity
		|FROM
		|	AccumulationRegister.R4036_IncommingStocksRequested.Balance(&Period, (IncommingStore, ItemKey, Order) IN
		|		(SELECT
		|			tmp.Store,
		|			tmp.ItemKey,
		|			tmp.Order
		|		FROM
		|			tmp AS tmp)) AS IncomingStocksRequested
		|		INNER JOIN tmp AS tmp
		|		ON IncomingStocksRequested.IncommingStore = tmp.Store
		|		AND IncomingStocksRequested.ItemKey = tmp.ItemKey
		|		AND IncomingStocksRequested.Order = tmp.Order
		|		AND tmp.UsePurchaseOrder";
	
	Query.SetParameter("Period", New Boundary(Parameters.Object.Ref.PointInTime(), BoundaryType.Excluding));	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.InventoryBalance               , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance                   , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Receipt       , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense   , QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.OrderBalance                   , QueryResults[4].Unload());
	PostingServer.MergeTables(Tables.R4035_IncommingStocks          , QueryResults[5].Unload());
	PostingServer.MergeTables(Tables.R4036_IncommingStocksRequested , QueryResults[6].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Expense       , QueryResults[7].Unload());
	
EndProcedure

Procedure GetTables_UsePO_NotUseSO_NotUseGRBeforeInvoice_UseGR_IsProduct(Tables, TempManager, TableName, Parameters)
	// tmp_2_2
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		// [0] InventoryBalance
		"SELECT
		|	tmp.Company,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|//[1] GoodsInTransitIncoming
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|//[2] GoodsReceiptSchedule_Expense
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	GoodsReceiptSchedule.DeliveryDate AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.GoodsReceiptSchedule AS GoodsReceiptSchedule
		|		ON GoodsReceiptSchedule.Recorder = tmp.Order
		|		AND GoodsReceiptSchedule.RowKey = tmp.RowKey
		|		AND GoodsReceiptSchedule.Company = tmp.Company
		|		AND GoodsReceiptSchedule.Store = tmp.Store
		|		AND GoodsReceiptSchedule.ItemKey = tmp.ItemKey
		|		AND GoodsReceiptSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|;
		|//[3] GoodsReceiptSchedule_Receipt 
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.GoodsReceiptSchedule AS GoodsReceiptSchedule
		|		ON GoodsReceiptSchedule.Recorder = tmp.Order
		|		AND GoodsReceiptSchedule.RowKey = tmp.RowKey
		|		AND GoodsReceiptSchedule.Company = tmp.Company
		|		AND GoodsReceiptSchedule.Store = tmp.Store
		|		AND GoodsReceiptSchedule.ItemKey = tmp.ItemKey
		|		AND GoodsReceiptSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|;
		|//[4] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.InventoryBalance             , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsInTransitIncoming       , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Receipt , QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.OrderBalance                 , QueryResults[4].Unload());
EndProcedure

Procedure GetTables_UsePO_NotUseSO_NotUseGRBeforeInvoice_IsService(Tables, TempManager, TableName, Parameters)
	// tmp_2_3
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		// [0] ExpensesTurnovers
		"SELECT
		|	tmp.Company AS Company,
		|	tmp.BusinessUnit AS BusinessUnit,
		|	tmp.ExpenseType AS ExpenseType,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.Currency AS Currency,
		|	tmp.AdditionalAnalytic AS AdditionalAnalytic,
		|	tmp.Period AS Period,
		|	SUM(tmp.Amount) AS Amount
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.BusinessUnit,
		|	tmp.ExpenseType,
		|	tmp.ItemKey,
		|	tmp.Currency,
		|	tmp.AdditionalAnalytic,
		|	tmp.Period
		|;
		|
		|//[1] GoodsReceiptSchedule_Expense
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.GoodsReceiptSchedule AS GoodsReceiptSchedule
		|		ON GoodsReceiptSchedule.Recorder = tmp.Order
		|		AND GoodsReceiptSchedule.RowKey = tmp.RowKey
		|		AND GoodsReceiptSchedule.Company = tmp.Company
		|		AND GoodsReceiptSchedule.Store = tmp.Store
		|		AND GoodsReceiptSchedule.ItemKey = tmp.ItemKey
		|		AND GoodsReceiptSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|;
		|
		|//[2] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.ExpensesTurnovers            , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.OrderBalance                 , QueryResults[2].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_3

Procedure GetTables_UsePO_NotUseSO_UseGRBeforeInvoice(Tables, TempManager, TableName, Parameters)
	// tmp_3
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM source AS tmp
		|WHERE 
		|	 NOT tmp.UseGoodsReceipt
		|AND NOT tmp.IsService";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UsePO_NotUseSO_UseGRBeforeInvoice_NotUseGR_IsProduct(Tables, TempManager, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_2 FROM source AS tmp
		|WHERE 
		|	     tmp.UseGoodsReceipt
		|AND NOT tmp.IsService";
	NewTableName = StrReplace("tmp_2", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_2", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UsePO_NotUseSO_UseGRBeforeInvoice_UseGR_IsProduct(Tables, TempManager, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM source AS tmp
		|WHERE 
		|	tmp.IsService";
	NewTableName = StrReplace("tmp_3", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_3", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UsePO_NotUseSO_UseGRBeforeInvoice_IsService(Tables, TempManager, NewTableName, Parameters);
	EndIf;
EndProcedure

Procedure GetTables_UsePO_NotUseSO_UseGRBeforeInvoice_NotUseGR_IsProduct(Tables, TempManager, TableName, Parameters)
	// tmp_3_1
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		// [0] ReceiptOrders
		"SELECT
		|	tmp.Order AS Order,
		|	GoodsReceipts.GoodsReceipt AS GoodsReceipt,
		|	ISNULL(GoodsReceipts.Quantity, 0) AS Quantity,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|		LEFT JOIN GoodsReceipts AS GoodsReceipts
		|		ON tmp.RowKeyUUID = GoodsReceipts.RowKeyUUID
		|;
		|
		|//[1] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.ReceiptOrders , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderBalance  , QueryResults[1].Unload());
EndProcedure

Procedure GetTables_UsePO_NotUseSO_UseGRBeforeInvoice_UseGR_IsProduct(Tables, TempManager, TableName, Parameters)
	// tmp_3_2
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		// [0] ReceiptOrders
		"SELECT
		|	tmp.Order AS Order,
		|	GoodsReceipts.GoodsReceipt AS GoodsReceipt,
		|	ISNULL(GoodsReceipts.Quantity, 0) AS Quantity,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|		LEFT JOIN GoodsReceipts AS GoodsReceipts
		|		ON tmp.RowKeyUUID = GoodsReceipts.RowKeyUUID
		|;
		|
		|//[1] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.ReceiptOrders , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderBalance  , QueryResults[1].Unload());
EndProcedure

Procedure GetTables_UsePO_NotUseSO_UseGRBeforeInvoice_IsService(Tables, TempManager, TableName, Parameters)
	// tmp_3_3
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		// [0] ExpensesTurnovers
		"SELECT
		|	tmp.Company AS Company,
		|	tmp.BusinessUnit AS BusinessUnit,
		|	tmp.ExpenseType AS ExpenseType,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.Currency AS Currency,
		|	tmp.AdditionalAnalytic AS AdditionalAnalytic,
		|	tmp.Period AS Period,
		|	SUM(tmp.Amount) AS Amount
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.BusinessUnit,
		|	tmp.ExpenseType,
		|	tmp.ItemKey,
		|	tmp.Currency,
		|	tmp.AdditionalAnalytic,
		|	tmp.Period
		|;
		|
		|//[1] GoodsReceiptSchedule_Expense
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.GoodsReceiptSchedule AS GoodsReceiptSchedule
		|		ON GoodsReceiptSchedule.Recorder = tmp.Order
		|		AND GoodsReceiptSchedule.RowKey = tmp.RowKey
		|		AND GoodsReceiptSchedule.Company = tmp.Company
		|		AND GoodsReceiptSchedule.Store = tmp.Store
		|		AND GoodsReceiptSchedule.ItemKey = tmp.ItemKey
		|		AND GoodsReceiptSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|;
		|
		|//[2] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.ExpensesTurnovers            , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.OrderBalance                 , QueryResults[2].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_4

Procedure GetTables_UsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice(Tables, TempManager, TableName, Parameters)
	// tmp_4
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM source AS tmp
		|WHERE 
		|	 NOT tmp.UseGoodsReceipt
		|AND NOT tmp.IsService";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice_NotUseGR_IsProduct(Tables, TempManager, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_2 FROM source AS tmp
		|WHERE 
		|	     tmp.UseGoodsReceipt
		|AND NOT tmp.IsService";
	NewTableName = StrReplace("tmp_2", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_2", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice_UseGR_IsProduct(Tables, TempManager, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM source AS tmp
		|WHERE 
		|	tmp.IsService";
	NewTableName = StrReplace("tmp_3", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_3", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice_IsService(Tables, TempManager, NewTableName, Parameters);
	EndIf;
EndProcedure

Procedure GetTables_UsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice_NotUseGR_IsProduct(Tables, TempManager, TableName, Parameters)
	// tmp_4_1
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		"//[0] InventoryBalance
		|SELECT
		|	tmp.Company,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|   tmp.ItemKey,
		|	tmp.Period
		|;
		|//[1] StockBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|//[2] StockReservation_Receipt
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|//[3] StockReservation_Expense
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|//[4] GoodsReceiptSchedule_Expense
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.GoodsReceiptSchedule AS GoodsReceiptSchedule
		|		ON GoodsReceiptSchedule.Recorder = tmp.Order
		|		AND GoodsReceiptSchedule.RowKey = tmp.RowKey
		|		AND GoodsReceiptSchedule.Company = tmp.Company
		|		AND GoodsReceiptSchedule.Store = tmp.Store
		|		AND GoodsReceiptSchedule.ItemKey = tmp.ItemKey
		|		AND GoodsReceiptSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|;
		|
		|//[5] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.InventoryBalance             , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance                 , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Receipt     , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Expense     , QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense , QueryResults[4].Unload());
	PostingServer.MergeTables(Tables.OrderBalance                 , QueryResults[5].Unload());
EndProcedure

Procedure GetTables_UsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice_UseGR_IsProduct(Tables, TempManager, TableName, Parameters)
	// tmp_4_2
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		// [0] InventoryBalance
		"SELECT
		|	tmp.Company,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|//[1] GoodsInTransitIncoming
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|//[2] GoodsReceiptSchedule_Expense
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	GoodsReceiptSchedule.DeliveryDate AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.GoodsReceiptSchedule AS GoodsReceiptSchedule
		|		ON GoodsReceiptSchedule.Recorder = tmp.Order
		|		AND GoodsReceiptSchedule.RowKey = tmp.RowKey
		|		AND GoodsReceiptSchedule.Company = tmp.Company
		|		AND GoodsReceiptSchedule.Store = tmp.Store
		|		AND GoodsReceiptSchedule.ItemKey = tmp.ItemKey
		|		AND GoodsReceiptSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|;
		|//[3] GoodsReceiptSchedule_Receipt 
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.GoodsReceiptSchedule AS GoodsReceiptSchedule
		|		ON GoodsReceiptSchedule.Recorder = tmp.Order
		|		AND GoodsReceiptSchedule.RowKey = tmp.RowKey
		|		AND GoodsReceiptSchedule.Company = tmp.Company
		|		AND GoodsReceiptSchedule.Store = tmp.Store
		|		AND GoodsReceiptSchedule.ItemKey = tmp.ItemKey
		|		AND GoodsReceiptSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|;
		|//[4] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.InventoryBalance             , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsInTransitIncoming       , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Receipt , QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.OrderBalance                 , QueryResults[4].Unload());
EndProcedure

Procedure GetTables_UsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice_IsService(Tables, TempManager, TableName, Parameters)
	// tmp_4_3
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		// [0] ExpensesTurnovers
		"SELECT
		|	tmp.Company AS Company,
		|	tmp.BusinessUnit AS BusinessUnit,
		|	tmp.ExpenseType AS ExpenseType,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.Currency AS Currency,
		|	tmp.AdditionalAnalytic AS AdditionalAnalytic,
		|	tmp.Period AS Period,
		|	SUM(tmp.Amount) AS Amount
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.BusinessUnit,
		|	tmp.ExpenseType,
		|	tmp.ItemKey,
		|	tmp.Currency,
		|	tmp.AdditionalAnalytic,
		|	tmp.Period
		|;
		|
		|// [1] GoodsReceiptSchedule_Expense
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.GoodsReceiptSchedule AS GoodsReceiptSchedule
		|		ON GoodsReceiptSchedule.Recorder = tmp.Order
		|		AND GoodsReceiptSchedule.RowKey = tmp.RowKey
		|		AND GoodsReceiptSchedule.Company = tmp.Company
		|		AND GoodsReceiptSchedule.Store = tmp.Store
		|		AND GoodsReceiptSchedule.ItemKey = tmp.ItemKey
		|		AND GoodsReceiptSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|;
		|
		|//[2] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.ExpensesTurnovers            , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.OrderBalance                 , QueryResults[2].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_5

Procedure GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice(Tables, TempManager, TableName, Parameters)
	// tmp_5
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM source AS tmp
		|WHERE 
		|	 NOT tmp.UseGoodsReceipt
		|AND NOT tmp.IsService";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice_NotUseGR_IsProduct(Tables, TempManager, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_2 FROM source AS tmp
		|WHERE 
		|	     tmp.UseGoodsReceipt
		|AND NOT tmp.IsService";
	NewTableName = StrReplace("tmp_2", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_2", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice_UseGR_IsProduct(Tables, TempManager, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM source AS tmp
		|WHERE 
		|	tmp.IsService";
	NewTableName = StrReplace("tmp_3", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_3", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice_IsService(Tables, TempManager, NewTableName, Parameters);
	EndIf;
EndProcedure

Procedure GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice_NotUseGR_IsProduct(Tables, TempManager, TableName, Parameters)
	// tmp_5_1
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		"//[0] InventoryBalance
		|SELECT
		|	tmp.Company,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|   tmp.ItemKey,
		|	tmp.Period
		|;
		|//[1] StockBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|//[2] StockReservation_Receipt
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|//[3] StocReservation_Expense
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|//[4] GoodsReceiptSchedule_Expense
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.PurchaseInvoice AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|;
		|
		|//[5] GoodsReceiptSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.PurchaseInvoice AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	 tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|;
		|//[6] OrderProcurement
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.SalesOrder AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.InventoryBalance             , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance                 , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Receipt     , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Expense     , QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense , QueryResults[4].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Receipt , QueryResults[5].Unload());
	PostingServer.MergeTables(Tables.OrderProcurement             , QueryResults[6].Unload());
EndProcedure

Procedure GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice_UseGR_IsProduct(Tables, TempManager, TableName, Parameters)
	// tmp_5_2
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		// [0] InventoryBalance
		"SELECT
		|	tmp.Company,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|//[1] GoodsInTransitIncoming
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|//[2] GoodsReceiptSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.PurchaseInvoice AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.InventoryBalance             , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsInTransitIncoming       , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Receipt , QueryResults[2].Unload());
EndProcedure

Procedure GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice_IsService(Tables, TempManager, TableName, Parameters)
	// tmp_5_3
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		// [0] ExpensesTurnovers
		"SELECT
		|	tmp.Company AS Company,
		|	tmp.BusinessUnit AS BusinessUnit,
		|	tmp.ExpenseType AS ExpenseType,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.Currency AS Currency,
		|	tmp.AdditionalAnalytic AS AdditionalAnalytic,
		|	tmp.Period AS Period,
		|	SUM(tmp.Amount) AS Amount
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.BusinessUnit,
		|	tmp.ExpenseType,
		|	tmp.ItemKey,
		|	tmp.Currency,
		|	tmp.AdditionalAnalytic,
		|	tmp.Period
		|;
		|
		|//[1] GoodsReceiptSchedule_Expense
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.PurchaseInvoice AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|;
		|
		|//[2] GoodsReceiptSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.PurchaseInvoice AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.ExpensesTurnovers            , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Receipt , QueryResults[2].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_6

Procedure GetTables_UsePO_UseSO_GRBeforeInvoice_NotSCBeforeInvoice(Tables, TempManager, TableName, Parameters)
	// tmp_6
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM source AS tmp
		|WHERE 
		|	 NOT tmp.UseGoodsReceipt
		|AND NOT tmp.IsService";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UsePO_UseSO_GRBeforeInvoice_NotSCBeforeInvoice_NotUseGR_IsProduct(Tables, TempManager, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_2 FROM source AS tmp
		|WHERE 
		|	     tmp.UseGoodsReceipt
		|AND NOT tmp.IsService";
	NewTableName = StrReplace("tmp_2", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_2", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UsePO_UseSO_GRBeforeInvoice_NotSCBeforeInvoice_UseGR_IsProduct(Tables, TempManager, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM source AS tmp
		|WHERE 
		|	tmp.IsService";
	NewTableName = StrReplace("tmp_3", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_3", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UsePO_UseSO_GRBeforeInvoice_NotSCBeforeInvoice_IsService(Tables, TempManager, NewTableName, Parameters);
	EndIf;
EndProcedure

Procedure GetTables_UsePO_UseSO_GRBeforeInvoice_NotSCBeforeInvoice_NotUseGR_IsProduct(Tables, TempManager, TableName, Parameters)
	// tmp_6_1
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		// [0] ReceiptOrders
		"SELECT
		|	tmp.Order AS Order,
		|	GoodsReceipts.GoodsReceipt AS GoodsReceipt,
		|	ISNULL(GoodsReceipts.Quantity, 0) AS Quantity,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|		LEFT JOIN GoodsReceipts AS GoodsReceipts
		|		ON tmp.RowKeyUUID = GoodsReceipts.RowKeyUUID
		|;
		|
		|//[1] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.ReceiptOrders , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderBalance  , QueryResults[1].Unload());
EndProcedure

Procedure GetTables_UsePO_UseSO_GRBeforeInvoice_NotSCBeforeInvoice_UseGR_IsProduct(Tables, TempManager, TableName, Parameters)
	// tmp_6_2
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		// [0] ReceiptOrders
		"SELECT
		|	tmp.Order AS Order,
		|	GoodsReceipts.GoodsReceipt AS GoodsReceipt,
		|	ISNULL(GoodsReceipts.Quantity, 0) AS Quantity,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|		LEFT JOIN GoodsReceipts AS GoodsReceipts
		|		ON tmp.RowKeyUUID = GoodsReceipts.RowKeyUUID
		|;
		|
		|//[1] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.ReceiptOrders , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderBalance  , QueryResults[1].Unload());
EndProcedure

Procedure GetTables_UsePO_UseSO_GRBeforeInvoice_NotSCBeforeInvoice_IsService(Tables, TempManager, TableName, Parameters)
	// tmp_6_3
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		// [0] ExpensesTurnovers
		"SELECT
		|	tmp.Company AS Company,
		|	tmp.BusinessUnit AS BusinessUnit,
		|	tmp.ExpenseType AS ExpenseType,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.Currency AS Currency,
		|	tmp.AdditionalAnalytic AS AdditionalAnalytic,
		|	tmp.Period AS Period,
		|	SUM(tmp.Amount) AS Amount
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.BusinessUnit,
		|	tmp.ExpenseType,
		|	tmp.ItemKey,
		|	tmp.Currency,
		|	tmp.AdditionalAnalytic,
		|	tmp.Period
		|;
		|
		|//[1] GoodsReceiptSchedule_Expense
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.GoodsReceiptSchedule AS GoodsReceiptSchedule
		|		ON GoodsReceiptSchedule.Recorder = tmp.Order
		|		AND GoodsReceiptSchedule.RowKey = tmp.RowKey
		|		AND GoodsReceiptSchedule.Company = tmp.Company
		|		AND GoodsReceiptSchedule.Store = tmp.Store
		|		AND GoodsReceiptSchedule.ItemKey = tmp.ItemKey
		|		AND GoodsReceiptSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|;
		|
		|//[2] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.ExpensesTurnovers            , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.OrderBalance                 , QueryResults[2].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_7

Procedure GetTables_UsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice(Tables, TempManager, TableName, Parameters)
	// tmp_7
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM source AS tmp
		|WHERE 
		|	 NOT tmp.UseGoodsReceipt
		|AND NOT tmp.IsService";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice_NotUseGR_IsProduct(Tables, TempManager, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_2 FROM source AS tmp
		|WHERE 
		|	     tmp.UseGoodsReceipt
		|AND NOT tmp.IsService";
	NewTableName = StrReplace("tmp_2", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_2", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice_UseGR_IsProduct(Tables, TempManager, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM source AS tmp
		|WHERE 
		|	tmp.IsService";
	NewTableName = StrReplace("tmp_3", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_3", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice_IsService(Tables, TempManager, NewTableName, Parameters);
	EndIf;
EndProcedure

Procedure GetTables_UsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice_NotUseGR_IsProduct(Tables, TempManager, TableName, Parameters)
	Return;
EndProcedure

Procedure GetTables_UsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice_UseGR_IsProduct(Tables, TempManager, TableName, Parameters)
	// tmp_2_2
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		// [0] InventoryBalance
		"SELECT
		|	tmp.Company,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|//[1] GoodsInTransitIncoming
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|//[2] GoodsReceiptSchedule_Expense
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	GoodsReceiptSchedule.DeliveryDate AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.GoodsReceiptSchedule AS GoodsReceiptSchedule
		|		ON GoodsReceiptSchedule.Recorder = tmp.Order
		|		AND GoodsReceiptSchedule.RowKey = tmp.RowKey
		|		AND GoodsReceiptSchedule.Company = tmp.Company
		|		AND GoodsReceiptSchedule.Store = tmp.Store
		|		AND GoodsReceiptSchedule.ItemKey = tmp.ItemKey
		|		AND GoodsReceiptSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|;
		|//[3] GoodsReceiptSchedule_Receipt 
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.GoodsReceiptSchedule AS GoodsReceiptSchedule
		|		ON GoodsReceiptSchedule.Recorder = tmp.Order
		|		AND GoodsReceiptSchedule.RowKey = tmp.RowKey
		|		AND GoodsReceiptSchedule.Company = tmp.Company
		|		AND GoodsReceiptSchedule.Store = tmp.Store
		|		AND GoodsReceiptSchedule.ItemKey = tmp.ItemKey
		|		AND GoodsReceiptSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|;
		|//[4] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.InventoryBalance             , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsInTransitIncoming       , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Receipt , QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.OrderBalance                 , QueryResults[4].Unload());
	
	Return;
EndProcedure

Procedure GetTables_UsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice_IsService(Tables, TempManager, TableName, Parameters)
	Return;
EndProcedure

#EndRegion

#Region Table_tmp_8

Procedure GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice(Tables, TempManager, TableName, Parameters)
	// tmp_8
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM source AS tmp
		|WHERE 
		|	 NOT tmp.UseGoodsReceipt
		|AND NOT tmp.IsService";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice_NotUseGR_IsProduct(Tables, TempManager, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_2 FROM source AS tmp
		|WHERE 
		|	     tmp.UseGoodsReceipt
		|AND     tmp.UseShipmentConfirmation
		|AND NOT tmp.IsService";
	NewTableName = StrReplace("tmp_2", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_2", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice_UseGR_UseSC_IsProduct(Tables, TempManager, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM source AS tmp
		|WHERE 
		|	tmp.IsService";
	NewTableName = StrReplace("tmp_3", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_3", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice_IsService(Tables, TempManager, NewTableName, Parameters);
	EndIf;
EndProcedure

Procedure GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice_NotUseGR_IsProduct(Tables, TempManager, TableName, Parameters)
	Return;	
EndProcedure

Procedure GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice_UseGR_UseSC_IsProduct(Tables, TempManager, TableName, Parameters)
	// tmp_8_2
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		// [0] InventoryBalance
		"SELECT
		|	tmp.Company,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|//[1] GoodsInTransitIncoming
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|//[2] GoodsReceiptSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.PurchaseInvoice AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|;
		|//[3] OrderProcurement
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.SalesOrder AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.InventoryBalance             , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsInTransitIncoming       , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Receipt , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.OrderProcurement             , QueryResults[3].Unload());
EndProcedure

Procedure GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice_IsService(Tables, TempManager, TableName, Parameters)
	// tmp_8_3
	Return;
EndProcedure

#EndRegion

#Region Table_tmp_9

Procedure GetTables_UsePO_UseSO_GRBeforeInvoice_SCBeforeInvoice(Tables, TempManager, TableName, Parameters)
	// tmp_9
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM source AS tmp
		|WHERE 
		|	 NOT tmp.UseGoodsReceipt
		|AND NOT tmp.IsService";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UsePO_UseSO_GRBeforeInvoice_SCBeforeInvoice_NotUseGR_IsProduct(Tables, TempManager, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_2 FROM source AS tmp
		|WHERE 
		|	     tmp.UseGoodsReceipt
		|AND NOT tmp.IsService";
	NewTableName = StrReplace("tmp_2", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_2", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UsePO_UseSO_GRBeforeInvoice_SCBeforeInvoice_UseGR_IsProduct(Tables, TempManager, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM source AS tmp
		|WHERE 
		|	tmp.IsService";
	NewTableName = StrReplace("tmp_3", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_3", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UsePO_UseSO_GRBeforeInvoice_SCBeforeInvoice_IsService(Tables, TempManager, NewTableName, Parameters);
	EndIf;
EndProcedure

Procedure GetTables_UsePO_UseSO_GRBeforeInvoice_SCBeforeInvoice_NotUseGR_IsProduct(Tables, TempManager, TableName, Parameters)
	// tmp_9_1
	Return;
EndProcedure

Procedure GetTables_UsePO_UseSO_GRBeforeInvoice_SCBeforeInvoice_UseGR_IsProduct(Tables, TempManager, TableName, Parameters)
	// tmp_9_2
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		// [0] ReceiptOrders
		"SELECT
		|	tmp.Order AS Order,
		|	GoodsReceipts.GoodsReceipt AS GoodsReceipt,
		|	ISNULL(GoodsReceipts.Quantity, 0) AS Quantity,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|		LEFT JOIN GoodsReceipts AS GoodsReceipts
		|		ON tmp.RowKeyUUID = GoodsReceipts.RowKeyUUID
		|;
		|
		|//[1] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.ReceiptOrders , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderBalance  , QueryResults[1].Unload());
EndProcedure

Procedure GetTables_UsePO_UseSO_GRBeforeInvoice_SCBeforeInvoice_IsService(Tables, TempManager, TableName, Parameters)
	// tmp_9_3
	Return;	
EndProcedure

#EndRegion

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// OrderBalance
	OrderBalance = AccumulationRegisters.OrderBalance.GetLockFields(DocumentDataTables.OrderBalance);
	DataMapWithLockFields.Insert(OrderBalance.RegisterName, OrderBalance.LockInfo);
	
	// InventoryBalance
	InventoryBalance = AccumulationRegisters.InventoryBalance.GetLockFields(DocumentDataTables.InventoryBalance);
	DataMapWithLockFields.Insert(InventoryBalance.RegisterName, InventoryBalance.LockInfo);
	
	// PurchaseTurnovers
	PurchaseTurnovers = AccumulationRegisters.PurchaseTurnovers.GetLockFields(DocumentDataTables.PurchaseTurnovers);
	DataMapWithLockFields.Insert(PurchaseTurnovers.RegisterName, PurchaseTurnovers.LockInfo);
	
	// GoodsInTransitIncoming
	GoodsInTransitIncoming = AccumulationRegisters.GoodsInTransitIncoming.GetLockFields(DocumentDataTables.GoodsInTransitIncoming);
	DataMapWithLockFields.Insert(GoodsInTransitIncoming.RegisterName, GoodsInTransitIncoming.LockInfo);
	
	// StockBalance
	StockBalance = AccumulationRegisters.StockBalance.GetLockFields(DocumentDataTables.StockBalance);
	DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
	
	// StockReservation
	StockReservation = AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.StockReservation_Expense);
	DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
	
	// PartnerApTransactions
	PartnerApTransactions = AccumulationRegisters.PartnerApTransactions.GetLockFields(DocumentDataTables.PartnerApTransactions);
	DataMapWithLockFields.Insert(PartnerApTransactions.RegisterName, PartnerApTransactions.LockInfo);
	
	// AdvanceToSuppliers (Lock use In PostingCheckBeforeWrite)
	AdvanceToSuppliers = AccumulationRegisters.AdvanceToSuppliers.GetLockFields(DocumentDataTables.AdvanceToSuppliers_Lock);
	DataMapWithLockFields.Insert(AdvanceToSuppliers.RegisterName, AdvanceToSuppliers.LockInfo);
	
	// ReceiptOrders
	ReceiptOrders = AccumulationRegisters.ReceiptOrders.GetLockFields(DocumentDataTables.ReceiptOrders);
	DataMapWithLockFields.Insert(ReceiptOrders.RegisterName, ReceiptOrders.LockInfo);
	
	// ExpensesTurnovers
	ExpensesTurnovers = AccumulationRegisters.ExpensesTurnovers.GetLockFields(DocumentDataTables.ExpensesTurnovers);
	DataMapWithLockFields.Insert(ExpensesTurnovers.RegisterName, ExpensesTurnovers.LockInfo);
	
	// OrderProcurement
	OrderProcurement = AccumulationRegisters.OrderProcurement.GetLockFields(DocumentDataTables.OrderProcurement);
	DataMapWithLockFields.Insert(OrderProcurement.RegisterName, OrderProcurement.LockInfo);
	
	// ReconciliationStatement
	ReconciliationStatement = AccumulationRegisters.ReconciliationStatement.GetLockFields(DocumentDataTables.ReconciliationStatement);
	DataMapWithLockFields.Insert(ReconciliationStatement.RegisterName, ReconciliationStatement.LockInfo);
	
	// TaxesTurnovers
	TaxesTurnovers = AccumulationRegisters.TaxesTurnovers.GetLockFields(DocumentDataTables.TaxesTurnovers);
	DataMapWithLockFields.Insert(TaxesTurnovers.RegisterName, TaxesTurnovers.LockInfo);
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	// Advance to suppliers
	Parameters.DocumentDataTables.PartnerApTransactions_OffsetOfAdvance =
		AccumulationRegisters.AdvanceToSuppliers.GetTableAdvanceToSuppliers_OffsetOfAdvance(Parameters.Object.RegisterRecords
			, Parameters.PointInTime
			, Parameters.DocumentDataTables.AdvanceToSuppliers_Lock);
			
	If Parameters.DocumentDataTables.PartnerApTransactions_OffsetOfAdvance.Count() Then
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
    	|	AccountsStatementBalance.AdvanceFromCustomersBalance AS AdvanceFromCustomersBalance,
    	|	-tmp.Amount AS AdvanceFromCustomers
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
    	Query.SetParameter("QueryTable", Parameters.DocumentDataTables.PartnerApTransactions_OffsetOfAdvance);
    	Query.SetParameter("PointInTime", Parameters.PointInTime);
    	Query.SetParameter("Period", Parameters.Object.Date);
    	Parameters.DocumentDataTables.Insert("PartnerApTransactions_OffsetOfAdvance_AccountStatement",
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
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.InventoryBalance,
			Parameters.IsReposting));
	
	// PurchaseTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PurchaseTurnovers,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.PurchaseTurnovers,
			Parameters.IsReposting));
	
	// GoodsInTransitIncoming
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitIncoming,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.GoodsInTransitIncoming,
			True));
	
	// StockBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.StockBalance,
			True));
	
	// StockReservation	
	// StockReservation_Receipt [Receipt]  
	// StockReservation_Expense [Expense]
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.StockReservation_Receipt.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.StockReservation_Expense.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
			"RecordType, Period, Store, ItemKey, Quantity"),
			True));

	// AccountsStatement
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.PartnerApTransactions.Copy();
	Table1.Columns.Amount.Name = "TransactionAP";
	PostingServer.AddColumnsToAccountsStatementTable(Table1);
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.PartnerApTransactions_OffsetOfAdvance.Copy();
	Table2.Columns.Amount.Name = "TransactionAP";
	PostingServer.AddColumnsToAccountsStatementTable(Table2);
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	Table3 = Parameters.DocumentDataTables.PartnerApTransactions_OffsetOfAdvance.Copy();
	Table3.Columns.Amount.Name = "AdvanceToSuppliers";
	PostingServer.AddColumnsToAccountsStatementTable(Table3);
	Table3.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table3);
	
	If Parameters.DocumentDataTables.Property("PartnerApTransactions_OffsetOfAdvance_AccountStatement") Then
		Table4 = Parameters.DocumentDataTables.PartnerApTransactions_OffsetOfAdvance_AccountStatement.Copy();
		PostingServer.AddColumnsToAccountsStatementTable(Table4);
		Table4.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(Table4);
	EndIf;
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AccountsStatement,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, Partner, LegalName, BasisDocument, Currency,
				| TransactionAP, AdvanceToSuppliers,
				| TransactionAR, AdvanceFromCustomers"),
			Parameters.IsReposting));	
	
	// PartnerApTransactions
	// PartnerApTransactions [Receipt]  
	// PartnerApTransactions_OffsetOfAdvance [Expense]
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.PartnerApTransactions.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.PartnerApTransactions_OffsetOfAdvance.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PartnerApTransactions,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, BasisDocument, Partner, 
				|LegalName, Agreement, Currency, Amount"),
			Parameters.IsReposting));
	
	// AdvanceToSuppliers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AdvanceToSuppliers,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.PartnerApTransactions_OffsetOfAdvance));
	
	// ReceiptOrders
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ReceiptOrders,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.ReceiptOrders,
			True));
	
	// ExpensesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ExpensesTurnovers,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.ExpensesTurnovers,
			Parameters.IsReposting));
	
	// GoodsReceiptSchedule
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.GoodsReceiptSchedule_Expense.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.GoodsReceiptSchedule_Receipt.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsReceiptSchedule,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, Order, Store, ItemKey, RowKey, Quantity, DeliveryDate"),
			Parameters.IsReposting));
	
	// OrderProcurement
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderProcurement,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.OrderProcurement,
			True));
	
	// ReconciliationStatement
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ReconciliationStatement,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.ReconciliationStatement));
	
	// TaxesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.TaxesTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.TaxesTurnovers));
		
	// R4035_IncommingStocks
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.R4035_IncommingStocks,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.R4035_IncommingStocks));
	
	// R4036_IncomingStockRequested
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.R4036_IncommingStocksRequested,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.R4036_IncommingStocksRequested));
		
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
	
	// GoodsInTransitIncoming
	GoodsInTransitIncoming = AccumulationRegisters.GoodsInTransitIncoming.GetLockFields(DocumentDataTables.GoodsInTransitIncoming_Exists);
	DataMapWithLockFields.Insert(GoodsInTransitIncoming.RegisterName, GoodsInTransitIncoming.LockInfo);
	
	// ReceiptOrders
	ReceiptOrders = AccumulationRegisters.ReceiptOrders.GetLockFields(DocumentDataTables.ReceiptOrders_Exists);
	DataMapWithLockFields.Insert(ReceiptOrders.RegisterName, ReceiptOrders.LockInfo);
	
	// OrderProcurement
	OrderProcurement = AccumulationRegisters.OrderProcurement.GetLockFields(DocumentDataTables.OrderProcurement_Exists);
	DataMapWithLockFields.Insert(OrderProcurement.RegisterName, OrderProcurement.LockInfo);
	
	// StockReservation
	StockReservation = AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.StockReservation_Exists);
	DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
	
	// StockBalance
	StockBalance = AccumulationRegisters.StockBalance.GetLockFields(DocumentDataTables.StockBalance_Exists);
	DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
	
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
	
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.PurchaseInvoice.ItemList", AddInfo);
		
	LineNumberAndRowKeyFromItemList = PostingServer.GetLineNumberAndRowKeyFromItemList(Ref, "Document.PurchaseInvoice.ItemList");
	If Not Cancel And Not AccReg.OrderBalance.CheckBalance(Ref, LineNumberAndRowKeyFromItemList,
	                                                       Parameters.DocumentDataTables.OrderBalance,
	                                                       Parameters.DocumentDataTables.OrderBalance_Exists,
	                                                       AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
	
	If Not Cancel And Not AccReg.GoodsInTransitIncoming.CheckBalance(Ref, LineNumberAndRowKeyFromItemList,
	                                                                 Parameters.DocumentDataTables.GoodsInTransitIncoming,
	                                                                 Parameters.DocumentDataTables.GoodsInTransitIncoming_Exists,
	                                                                 AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
	
	If Not Cancel And Not AccReg.OrderProcurement.CheckBalance(Ref, LineNumberAndRowKeyFromItemList,
	                                                           Parameters.DocumentDataTables.OrderProcurement,
	                                                           Parameters.DocumentDataTables.OrderProcurement_Exists,
	                                                           AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
	
	If Not Cancel And Not AccReg.ReceiptOrders.CheckBalance(Ref, LineNumberAndRowKeyFromItemList,
	                                                        Parameters.DocumentDataTables.ReceiptOrders,
	                                                        Parameters.DocumentDataTables.ReceiptOrders_Exists,
	                                                        AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

#EndRegion

