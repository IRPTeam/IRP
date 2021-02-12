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
		|INTO _GoodsReceipts
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
		|		LEFT JOIN _GoodsReceipts AS GoodsReceipts
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
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
	"SELECT
	|	PurchaseInvoiceGoodsReceipts.Ref,
	|	PurchaseInvoiceGoodsReceipts.Key AS RowKeyUUID,
	|	PurchaseInvoiceGoodsReceipts.GoodsReceipt,
	|	PurchaseInvoiceGoodsReceipts.Quantity
	|INTO _GoodsReceipts
	|FROM
	|	Document.PurchaseInvoice.GoodsReceipts AS PurchaseInvoiceGoodsReceipts
	|WHERE
	|	PurchaseInvoiceGoodsReceipts.Ref = &Ref";
	Query.SetParameter("Ref", Ref);
	Query.Execute();
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
	
	GetTables_Common(Tables, "tmp", Parameters);
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM tmp AS tmp
		|WHERE
		|    NOT tmp.UsePurchaseOrder
		|AND NOT tmp.UseSalesOrder
		|AND NOT tmp.UseGoodsReceiptBeforeInvoice";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_1").GetData().IsEmpty() Then
		GetTables_NotUsePO_NotUseSO_NotUseGRBeforeInvoice(Tables, "tmp_1", Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_2 FROM tmp AS tmp
		|WHERE
		|        tmp.UsePurchaseOrder
		|AND NOT tmp.UseSalesOrder
		|AND NOT tmp.UseGoodsReceiptBeforeInvoice";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_2").GetData().IsEmpty() Then
		GetTables_UsePO_NotUseSO_NotUseGRBeforeInvoice(Tables, "tmp_2", Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM tmp AS tmp
		|WHERE
		|        tmp.UsePurchaseOrder
		|AND NOT tmp.UseSalesOrder
		|AND     tmp.UseGoodsReceiptBeforeInvoice";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_3").GetData().IsEmpty() Then
		GetTables_UsePO_NotUseSO_UseGRBeforeInvoice(Tables, "tmp_3", Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_4 FROM tmp AS tmp
		|WHERE
		|        tmp.UsePurchaseOrder
		|AND     tmp.UseSalesOrder
		|AND NOT tmp.UseGoodsReceiptBeforeInvoice
		|AND NOT tmp.UseShipmentBeforeInvoice";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_4").GetData().IsEmpty() Then
		GetTables_UsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice(Tables, "tmp_4", Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_5 FROM tmp AS tmp
		|WHERE
		|    NOT tmp.UsePurchaseOrder
		|AND     tmp.UseSalesOrder
		|AND NOT tmp.UseGoodsReceiptBeforeInvoice
		|AND NOT tmp.UseShipmentBeforeInvoice";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_5").GetData().IsEmpty() Then
		GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice(Tables, "tmp_5", Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_6 FROM tmp AS tmp
		|WHERE
		|        tmp.UsePurchaseOrder
		|AND     tmp.UseSalesOrder
		|AND     tmp.UseGoodsReceiptBeforeInvoice
		|AND NOT tmp.UseShipmentBeforeInvoice";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_6").GetData().IsEmpty() Then
		GetTables_UsePO_UseSO_GRBeforeInvoice_NotSCBeforeInvoice(Tables, "tmp_6", Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_7 FROM tmp AS tmp
		|WHERE
		|        tmp.UsePurchaseOrder
		|AND     tmp.UseSalesOrder
		|AND NOT tmp.UseGoodsReceiptBeforeInvoice
		|AND     tmp.UseShipmentBeforeInvoice";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_7").GetData().IsEmpty() Then
		GetTables_UsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice(Tables, "tmp_7", Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_8 FROM tmp AS tmp
		|WHERE
		|    NOT tmp.UsePurchaseOrder
		|AND     tmp.UseSalesOrder
		|AND NOT tmp.UseGoodsReceiptBeforeInvoice
		|AND     tmp.UseShipmentBeforeInvoice";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_8").GetData().IsEmpty() Then
		GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice(Tables, "tmp_8", Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_9 FROM tmp AS tmp
		|WHERE
		|        tmp.UsePurchaseOrder
		|AND     tmp.UseSalesOrder
		|AND     tmp.UseGoodsReceiptBeforeInvoice
		|AND     tmp.UseShipmentBeforeInvoice";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_9").GetData().IsEmpty() Then
		GetTables_UsePO_UseSO_GRBeforeInvoice_SCBeforeInvoice(Tables, "tmp_9", Parameters);
	EndIf;
	
	Parameters.IsReposting = False;	
	
	// legacy code fix
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	If Not PostingServer.QueryTableIsExists("IncomingStocks", Parameters) Then
		Query.Text = Query.Text + "SELECT UNDEFINED INTO IncomingStocks WHERE FALSE; ";
	EndIf;	
	If Not PostingServer.QueryTableIsExists("IncomingStocksRequested", Parameters) Then
		Query.Text = Query.Text + 
		"SELECT 
		|	UNDEFINED AS RecordType,
		|	UNDEFINED AS Period,
		|	UNDEFINED AS IncomingStore,
		|	UNDEFINED AS RequesterStore,
		|	UNDEFINED AS ItemKey,
		|	UNDEFINED AS Order,
		|	UNDEFINED AS Requester,
		|	UNDEFINED AS Quantity
		|INTO IncomingStocksRequested 
		|WHERE FALSE; ";		
	EndIf;	
	If Not PostingServer.QueryTableIsExists("FreeStocks", Parameters) Then
		Query.Text = Query.Text + 
		"SELECT 
		|	UNDEFINED AS RecordType, 
		|	UNDEFINED AS Period, 
		|	UNDEFINED AS Store, 
		|	UNDEFINED AS ItemKey, 
		|	UNDEFINED AS Quantity
		|INTO FreeStocks 
		|WHERE FALSE; ";
	EndIf;	
	If ValueIsFilled(Query.Text) Then
		Query.Execute();
	EndIf;
	
#Region NewRegistersPosting	
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	Tables.Insert("VendorsTransactions", 
	PostingServer.GetQueryTableByName("VendorsTransactions", Parameters));	
#EndRegion			
	
	Return Tables;
EndFunction

Procedure GetTables_Common(Tables, TableName, Parameters)
	// tmp
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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

Procedure GetTables_NotUsePO_NotUseSO_NotUseGRBeforeInvoice(Tables, TableName, Parameters)
	// tmp_1
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
		GetTables_NotUsePO_NotUseSO_NotUseGRBeforeInvoice_NotUseGR_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
		GetTables_NotUsePO_NotUseSO_NotUseGRBeforeInvoice_UseGR_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM source AS tmp
		|WHERE 
		|	tmp.IsService";
	NewTableName = StrReplace("tmp_3", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_3", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUsePO_NotUseSO_NotUseGRBeforeInvoice_IsService(Tables, NewTableName, Parameters);
	EndIf;
EndProcedure

Procedure GetTables_NotUsePO_NotUseSO_NotUseGRBeforeInvoice_NotUseGR_IsProduct(Tables, TableName, Parameters)
	// tmp_1_1
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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

Procedure GetTables_NotUsePO_NotUseSO_NotUseGRBeforeInvoice_UseGR_IsProduct(Tables, TableName, Parameters)
	// tmp_1_2
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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

Procedure GetTables_NotUsePO_NotUseSO_NotUseGRBeforeInvoice_IsService(Tables, TableName, Parameters)
	// tmp_1_3
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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

Procedure GetTables_UsePO_NotUseSO_NotUseGRBeforeInvoice(Tables, TableName, Parameters)
	// tmp_2
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
		GetTables_UsePO_NotUseSO_NotUseGRBeforeInvoice_NotUseGR_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
		GetTables_UsePO_NotUseSO_NotUseGRBeforeInvoice_UseGR_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM source AS tmp
		|WHERE 
		|	tmp.IsService";
	NewTableName = StrReplace("tmp_3", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_3", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UsePO_NotUseSO_NotUseGRBeforeInvoice_IsService(Tables, NewTableName, Parameters);
	EndIf;
EndProcedure

Procedure GetTables_UsePO_NotUseSO_NotUseGRBeforeInvoice_NotUseGR_IsProduct(Tables, TableName, Parameters)
	// tmp_2_1
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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
		|
		|//[IncomingStocksReal]
		|SELECT
		|	tmp.Period,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Quantity
		|INTO IncomingStocksReal
		|FROM tmp AS tmp
		|";
		
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.InventoryBalance               , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance                   , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Receipt       , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense   , QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.OrderBalance                   , QueryResults[4].Unload());
	
	Parameters.Insert("ConsiderStocksRequested", True);
	IncomingStocksServer.ClosureIncomingStocks(Parameters);
	
	PostingServer.MergeTables(Tables.StockReservation_Expense, 
	PostingServer.GetQueryTableByName("FreeStocks", Parameters));	
EndProcedure

Procedure GetTables_UsePO_NotUseSO_NotUseGRBeforeInvoice_UseGR_IsProduct(Tables, TableName, Parameters)
	// tmp_2_2
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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

Procedure GetTables_UsePO_NotUseSO_NotUseGRBeforeInvoice_IsService(Tables, TableName, Parameters)
	// tmp_2_3
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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

Procedure GetTables_UsePO_NotUseSO_UseGRBeforeInvoice(Tables, TableName, Parameters)
	// tmp_3
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
		GetTables_UsePO_NotUseSO_UseGRBeforeInvoice_NotUseGR_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
		GetTables_UsePO_NotUseSO_UseGRBeforeInvoice_UseGR_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM source AS tmp
		|WHERE 
		|	tmp.IsService";
	NewTableName = StrReplace("tmp_3", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_3", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UsePO_NotUseSO_UseGRBeforeInvoice_IsService(Tables, NewTableName, Parameters);
	EndIf;
EndProcedure

Procedure GetTables_UsePO_NotUseSO_UseGRBeforeInvoice_NotUseGR_IsProduct(Tables, TableName, Parameters)
	// tmp_3_1
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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
		|		LEFT JOIN _GoodsReceipts AS GoodsReceipts
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

Procedure GetTables_UsePO_NotUseSO_UseGRBeforeInvoice_UseGR_IsProduct(Tables, TableName, Parameters)
	// tmp_3_2
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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
		|		LEFT JOIN _GoodsReceipts AS GoodsReceipts
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

Procedure GetTables_UsePO_NotUseSO_UseGRBeforeInvoice_IsService(Tables, TableName, Parameters)
	// tmp_3_3
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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

Procedure GetTables_UsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice(Tables, TableName, Parameters)
	// tmp_4
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
		GetTables_UsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice_NotUseGR_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
		GetTables_UsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice_UseGR_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM source AS tmp
		|WHERE 
		|	tmp.IsService";
	NewTableName = StrReplace("tmp_3", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_3", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice_IsService(Tables, NewTableName, Parameters);
	EndIf;
EndProcedure

Procedure GetTables_UsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice_NotUseGR_IsProduct(Tables, TableName, Parameters)
	// tmp_4_1
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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

Procedure GetTables_UsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice_UseGR_IsProduct(Tables, TableName, Parameters)
	// tmp_4_2
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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

Procedure GetTables_UsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice_IsService(Tables, TableName, Parameters)
	// tmp_4_3
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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

Procedure GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice(Tables, TableName, Parameters)
	// tmp_5
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
		GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice_NotUseGR_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
		GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice_UseGR_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM source AS tmp
		|WHERE 
		|	tmp.IsService";
	NewTableName = StrReplace("tmp_3", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_3", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice_IsService(Tables, NewTableName, Parameters);
	EndIf;
EndProcedure

Procedure GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice_NotUseGR_IsProduct(Tables, TableName, Parameters)
	// tmp_5_1
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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

Procedure GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice_UseGR_IsProduct(Tables, TableName, Parameters)
	// tmp_5_2
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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

Procedure GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_NotSCBeforeInvoice_IsService(Tables, TableName, Parameters)
	// tmp_5_3
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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

Procedure GetTables_UsePO_UseSO_GRBeforeInvoice_NotSCBeforeInvoice(Tables, TableName, Parameters)
	// tmp_6
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
		GetTables_UsePO_UseSO_GRBeforeInvoice_NotSCBeforeInvoice_NotUseGR_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
		GetTables_UsePO_UseSO_GRBeforeInvoice_NotSCBeforeInvoice_UseGR_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM source AS tmp
		|WHERE 
		|	tmp.IsService";
	NewTableName = StrReplace("tmp_3", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_3", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UsePO_UseSO_GRBeforeInvoice_NotSCBeforeInvoice_IsService(Tables, NewTableName, Parameters);
	EndIf;
EndProcedure

Procedure GetTables_UsePO_UseSO_GRBeforeInvoice_NotSCBeforeInvoice_NotUseGR_IsProduct(Tables, TableName, Parameters)
	// tmp_6_1
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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
		|		LEFT JOIN _GoodsReceipts AS GoodsReceipts
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

Procedure GetTables_UsePO_UseSO_GRBeforeInvoice_NotSCBeforeInvoice_UseGR_IsProduct(Tables, TableName, Parameters)
	// tmp_6_2
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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
		|		LEFT JOIN _GoodsReceipts AS GoodsReceipts
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

Procedure GetTables_UsePO_UseSO_GRBeforeInvoice_NotSCBeforeInvoice_IsService(Tables, TableName, Parameters)
	// tmp_6_3
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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

Procedure GetTables_UsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice(Tables, TableName, Parameters)
	// tmp_7
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
		GetTables_UsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice_NotUseGR_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
		GetTables_UsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice_UseGR_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM source AS tmp
		|WHERE 
		|	tmp.IsService";
	NewTableName = StrReplace("tmp_3", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_3", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice_IsService(Tables, NewTableName, Parameters);
	EndIf;
EndProcedure

Procedure GetTables_UsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice_NotUseGR_IsProduct(Tables, TableName, Parameters)
	Return;
EndProcedure

Procedure GetTables_UsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice_UseGR_IsProduct(Tables, TableName, Parameters)
	// tmp_2_2
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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

Procedure GetTables_UsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice_IsService(Tables, TableName, Parameters)
	Return;
EndProcedure

#EndRegion

#Region Table_tmp_8

Procedure GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice(Tables, TableName, Parameters)
	// tmp_8
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
		GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice_NotUseGR_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
		GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice_UseGR_UseSC_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM source AS tmp
		|WHERE 
		|	tmp.IsService";
	NewTableName = StrReplace("tmp_3", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_3", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice_IsService(Tables, NewTableName, Parameters);
	EndIf;
EndProcedure

Procedure GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice_NotUseGR_IsProduct(Tables, TableName, Parameters)
	Return;	
EndProcedure

Procedure GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice_UseGR_UseSC_IsProduct(Tables, TableName, Parameters)
	// tmp_8_2
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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

Procedure GetTables_NotUsePO_UseSO_NotGRBeforeInvoice_SCBeforeInvoice_IsService(Tables, TableName, Parameters)
	// tmp_8_3
	Return;
EndProcedure

#EndRegion

#Region Table_tmp_9

Procedure GetTables_UsePO_UseSO_GRBeforeInvoice_SCBeforeInvoice(Tables, TableName, Parameters)
	// tmp_9
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
		GetTables_UsePO_UseSO_GRBeforeInvoice_SCBeforeInvoice_NotUseGR_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
		GetTables_UsePO_UseSO_GRBeforeInvoice_SCBeforeInvoice_UseGR_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM source AS tmp
		|WHERE 
		|	tmp.IsService";
	NewTableName = StrReplace("tmp_3", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_3", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UsePO_UseSO_GRBeforeInvoice_SCBeforeInvoice_IsService(Tables, NewTableName, Parameters);
	EndIf;
EndProcedure

Procedure GetTables_UsePO_UseSO_GRBeforeInvoice_SCBeforeInvoice_NotUseGR_IsProduct(Tables, TableName, Parameters)
	// tmp_9_1
	Return;
EndProcedure

Procedure GetTables_UsePO_UseSO_GRBeforeInvoice_SCBeforeInvoice_UseGR_IsProduct(Tables, TableName, Parameters)
	// tmp_9_2
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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
		|		LEFT JOIN _GoodsReceipts AS GoodsReceipts
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

Procedure GetTables_UsePO_UseSO_GRBeforeInvoice_SCBeforeInvoice_IsService(Tables, TableName, Parameters)
	// tmp_9_3
	Return;	
EndProcedure

#EndRegion

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
#Region NewRegistersPosting
	PostingServer.SetLockDataSource(DataMapWithLockFields, 
		AccumulationRegisters.R1020B_AdvancesToVendors, 
		DocumentDataTables.VendorsTransactions);
#EndRegion	

	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
#Region NewRegisterPosting
	Tables = Parameters.DocumentDataTables;
	
	OffsetOfPartnersServer.Vendors_OnTransaction(Parameters);
	
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion
	
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
	Tables = PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
#Region NewRegistersPosting
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion	
	Return Tables;
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
	
	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref, "Document.PurchaseInvoice.ItemList");
	If Not Cancel And Not AccReg.R4035B_IncomingStocks.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
	                                                                PostingServer.GetQueryTableByName("R4035B_IncomingStocks", Parameters),
	                                                                PostingServer.GetQueryTableByName("R4035B_IncomingStocks_Exists", Parameters),
	                                                                AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
	
	If Not Cancel And Not AccReg.R4036B_IncomingStocksRequested.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
	                                                                PostingServer.GetQueryTableByName("R4036B_IncomingStocksRequested", Parameters),
	                                                                PostingServer.GetQueryTableByName("R4036B_IncomingStocksRequested_Exists", Parameters),
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
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(VendorsTransactions());
	QueryArray.Add(SerialLotNumbers());
	QueryArray.Add(R4035B_IncomingStocks_Exists());
	QueryArray.Add(R4036B_IncomingStocksRequested_Exists());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R1001T_Purchases());
	QueryArray.Add(R1005T_PurchaseSpecialOffers());
	QueryArray.Add(R1011B_PurchaseOrdersReceipt());
	QueryArray.Add(R1012B_PurchaseOrdersInvoiceClosing());
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R1031B_ReceiptInvoicing());
	QueryArray.Add(R1040B_TaxesOutgoing());
	QueryArray.Add(R2013T_SalesOrdersProcurement());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4014B_SerialLotNumber());
	QueryArray.Add(R4017B_InternalSupplyRequestProcurement());
	QueryArray.Add(R4033B_GoodsReceiptSchedule());
	QueryArray.Add(R4050B_StockInventory());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R4035B_IncomingStocks());
	QueryArray.Add(R4036B_IncomingStocksRequested());
	QueryArray.Add(R4012B_StockReservation());
	Return QueryArray;
EndFunction

Function ItemList()
	Return
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
		|	PurchaseInvoiceItemList.Ref.Date AS Period,
		|	PurchaseInvoiceItemList.Ref AS Invoice,
		|	PurchaseInvoiceItemList.Key AS RowKey,
		|	PurchaseInvoiceItemList.ItemKey,
		|	PurchaseInvoiceItemList.Ref.Company AS Company,
		|	PurchaseInvoiceItemList.Ref.Currency,
		|	PurchaseInvoiceSpecialOffers.Offer AS SpecialOffer,
		|	PurchaseInvoiceSpecialOffers.Amount AS OffersAmount
		|INTO OffersInfo
		|FROM
		|	Document.PurchaseInvoice.ItemList AS PurchaseInvoiceItemList
		|		INNER JOIN Document.PurchaseInvoice.SpecialOffers AS PurchaseInvoiceSpecialOffers
		|		ON PurchaseInvoiceItemList.Key = PurchaseInvoiceSpecialOffers.Key
		|WHERE
		|	PurchaseInvoiceItemList.Ref = &Ref
		|	AND PurchaseInvoiceSpecialOffers.Ref = &Ref
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	PurchaseInvoiceItemList.Ref.Company AS Company,
		|	PurchaseInvoiceItemList.Store AS Store,
		|	PurchaseInvoiceItemList.UseGoodsReceipt AS UseGoodsReceipt,
		|	NOT PurchaseInvoiceItemList.PurchaseOrder = VALUE(Document.PurchaseOrder.EmptyRef) AS PurchaseOrderExists,
		|	NOT PurchaseInvoiceItemList.SalesOrder = VALUE(Document.SalesOrder.EmptyRef) AS SalesOrderExists,
		|	NOT PurchaseInvoiceItemList.InternalSupplyRequest = VALUE(Document.InternalSupplyRequest.EmptyRef) AS
		|		InternalSupplyRequestExists,
		|	NOT GoodsReceipts.Key IS NULL AS GoodsReceiptExists,
		|	PurchaseInvoiceItemList.ItemKey AS ItemKey,
		|	PurchaseInvoiceItemList.PurchaseOrder AS PurchaseOrder,
		|	PurchaseInvoiceItemList.SalesOrder AS SalesOrder,
		|	PurchaseInvoiceItemList.InternalSupplyRequest,
		|	PurchaseInvoiceItemList.Ref AS Invoice,
		|	PurchaseInvoiceItemList.Quantity AS UnitQuantity,
		|	PurchaseInvoiceItemList.QuantityInBaseUnit AS Quantity,
		|	PurchaseInvoiceItemList.TotalAmount AS Amount,
		|	PurchaseInvoiceItemList.Ref.Partner AS Partner,
		|	PurchaseInvoiceItemList.Ref.LegalName AS LegalName,
		|	CASE
		|		WHEN PurchaseInvoiceItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND PurchaseInvoiceItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN PurchaseInvoiceItemList.Ref.Agreement.StandardAgreement
		|		ELSE PurchaseInvoiceItemList.Ref.Agreement
		|	END AS Agreement,
		|	CASE
		|		WHEN PurchaseInvoiceItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN PurchaseInvoiceItemList.Ref
		|		ELSE UNDEFINED
		|	END AS BasisDocument,
		|	ISNULL(PurchaseInvoiceItemList.Ref.Currency, VALUE(Catalog.Currencies.EmptyRef)) AS Currency,
		|	PurchaseInvoiceItemList.Unit AS Unit,
		|	PurchaseInvoiceItemList.ItemKey.Item AS Item,
		|	PurchaseInvoiceItemList.Ref.Date AS Period,
		|	PurchaseInvoiceItemList.Key AS RowKey,
		|	PurchaseInvoiceItemList.AdditionalAnalytic AS AdditionalAnalytic,
		|	PurchaseInvoiceItemList.BusinessUnit AS BusinessUnit,
		|	PurchaseInvoiceItemList.ExpenseType AS ExpenseType,
		|	PurchaseInvoiceItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
		|	PurchaseInvoiceItemList.DeliveryDate AS DeliveryDate,
		|	PurchaseInvoiceItemList.NetAmount AS NetAmount
		|INTO ItemList
		|FROM
		|	Document.PurchaseInvoice.ItemList AS PurchaseInvoiceItemList
		|		LEFT JOIN GoodsReceipts AS GoodsReceipts
		|		ON PurchaseInvoiceItemList.Key = GoodsReceipts.Key
		|WHERE
		|	PurchaseInvoiceItemList.Ref = &Ref
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	PurchaseInvoiceGoodsReceipts.Key,
		|	PurchaseInvoiceGoodsReceipts.GoodsReceipt,
		|	PurchaseInvoiceGoodsReceipts.Quantity
		|INTO GoodReceiptInfo
		|FROM
		|	Document.PurchaseInvoice.GoodsReceipts AS PurchaseInvoiceGoodsReceipts
		|WHERE
		|	PurchaseInvoiceGoodsReceipts.Ref = &Ref
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	PurchaseInvoiceTaxList.Ref.Date AS Period,
		|	PurchaseInvoiceTaxList.Ref.Company AS Company,
		|	PurchaseInvoiceTaxList.Tax AS Tax,
		|	PurchaseInvoiceTaxList.TaxRate AS TaxRate,
		|	CASE
		|		WHEN PurchaseInvoiceTaxList.ManualAmount = 0
		|			THEN PurchaseInvoiceTaxList.Amount
		|		ELSE PurchaseInvoiceTaxList.ManualAmount
		|	END AS TaxAmount,
		|	PurchaseInvoiceItemList.NetAmount AS TaxableAmount
		|INTO Taxes
		|FROM
		|	Document.PurchaseInvoice.ItemList AS PurchaseInvoiceItemList
		|		LEFT JOIN Document.PurchaseInvoice.TaxList AS PurchaseInvoiceTaxList
		|		ON PurchaseInvoiceItemList.Key = PurchaseInvoiceTaxList.Key
		|WHERE
		|	PurchaseInvoiceItemList.Ref = &Ref
		|	AND PurchaseInvoiceTaxList.Ref = &Ref";
EndFunction

Function VendorsTransactions()
	Return
		"SELECT
		|	ItemList.Period,
		|	ItemList.Company AS Company,
		|	ItemList.Currency AS Currency,
		|	ItemList.LegalName AS LegalName,
		|	ItemList.Partner AS Partner,
		|	ItemList.BasisDocument TransactionDocument,
		|	ItemList.Agreement AS Agreement,
		|	SUM(ItemList.Amount) AS DocumentAmount
		|INTO VendorsTransactions
		|FROM
		|	ItemList AS ItemList
		|GROUP BY
		|	ItemList.Company,
		|	ItemList.BasisDocument,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.Currency,
		|	ItemList.Period";
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
		|	Document.PurchaseInvoice.SerialLotNumbers AS SerialLotNumbers
		|		LEFT JOIN Document.PurchaseInvoice.ItemList AS ItemList
		|		ON SerialLotNumbers.Key = ItemList.Key
		|WHERE
		|	SerialLotNumbers.Ref = &Ref";	
EndFunction	

Function R1001T_Purchases()
	Return
		"SELECT *
		|INTO R1001T_Purchases
		|FROM
		|	ItemList AS ItemList
		|WHERE TRUE";

EndFunction

Function R1005T_PurchaseSpecialOffers()
	Return
		"SELECT *
		|INTO R1005T_PurchaseSpecialOffers
		|FROM
		|	OffersInfo AS OffersInfo
		|WHERE TRUE";

EndFunction

Function R1011B_PurchaseOrdersReceipt()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.PurchaseOrder AS Order,
		|	*
		|INTO R1011B_PurchaseOrdersReceipt
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.UseGoodsReceipt
		|	AND ItemList.PurchaseOrderExists
		|	AND NOT ItemList.IsService";

EndFunction

Function R1012B_PurchaseOrdersInvoiceClosing()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.PurchaseOrder AS Order,
		|	*
		|INTO R1012B_PurchaseOrdersInvoiceClosing
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.PurchaseOrderExists";

EndFunction

Function R1020B_AdvancesToVendors()
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
		|INTO R1020B_AdvancesToVendors
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

Function R1021B_VendorsTransactions()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	VendorsTransactions.Period,
		|	VendorsTransactions.Company,
		|	VendorsTransactions.Currency,
		|	VendorsTransactions.LegalName,
		|	VendorsTransactions.Partner,
		|	VendorsTransactions.Agreement,
		|	VendorsTransactions.TransactionDocument AS Basis,
		|	SUM(VendorsTransactions.DocumentAmount) AS Amount
		|INTO R1021B_VendorsTransactions
		|FROM
		|	VendorsTransactions AS VendorsTransactions
		|GROUP BY
		|	VendorsTransactions.Period,
		|	VendorsTransactions.Company,
		|	VendorsTransactions.Currency,
		|	VendorsTransactions.LegalName,
		|	VendorsTransactions.Partner,
		|	VendorsTransactions.Agreement,
		|	VendorsTransactions.TransactionDocument,
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

Function R1031B_ReceiptInvoicing()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Invoice AS Basis,
		|	ItemList.Quantity AS Quantity,
		|	ItemList.Company,
		|	ItemList.Period,
		|	ItemList.ItemKey,
		|	ItemList.Store
		|INTO R1031B_ReceiptInvoicing
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.UseGoodsReceipt
		|	AND NOT ItemList.GoodsReceiptExists
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	GoodsReceipts.GoodsReceipt,
		|	GoodsReceipts.Quantity,
		|	ItemList.Company,
		|	ItemList.Period,
		|	ItemList.ItemKey,
		|	ItemList.Store
		|FROM
		|	ItemList AS ItemList
		|		INNER JOIN GoodReceiptInfo AS GoodsReceipts
		|		ON ItemList.RowKey = GoodsReceipts.Key
		|WHERE
		|	TRUE";

EndFunction

Function R1040B_TaxesOutgoing()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R1040B_TaxesOutgoing
		|FROM
		|	Taxes AS Taxes
		|WHERE TRUE";

EndFunction

Function R2013T_SalesOrdersProcurement()
	Return
		"SELECT
		|	ItemList.Quantity AS PurchaseQuantity,
		|	ItemList.SalesOrder AS Order,
		|	*
		|INTO R2013T_SalesOrdersProcurement
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|	AND ItemList.SalesOrderExists";

EndFunction

Function R4010B_ActualStocks()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R4010B_ActualStocks
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|	AND NOT ItemList.UseGoodsReceipt
		|	AND NOT ItemList.GoodsReceiptExists";

EndFunction

Function R4011B_FreeStocks()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period AS Period,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.Quantity AS Quantity
		|INTO R4011B_FreeStocks
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|	AND NOT ItemList.UseGoodsReceipt
		|	AND NOT ItemList.GoodsReceiptExists
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	FreeStocks.Period,
		|	FreeStocks.Store,
		|	FreeStocks.ItemKey,
		|	FreeStocks.Quantity
		|FROM
		|	FreeStocks AS FreeStocks";

EndFunction

Function R4014B_SerialLotNumber()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R4014B_SerialLotNumber
		|FROM
		|	SerialLotNumbers AS SerialLotNumbers
		|WHERE
		|	TRUE";

EndFunction

Function R4017B_InternalSupplyRequestProcurement()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	*
		|INTO R4017B_InternalSupplyRequestProcurement
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|	AND ItemList.InternalSupplyRequestExists
		|	AND NOT ItemList.UseGoodsReceipt";

EndFunction

Function R4033B_GoodsReceiptSchedule()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.PurchaseOrder AS Basis,
		|	*
		|INTO R4033B_GoodsReceiptSchedule
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|	AND NOT ItemList.UseGoodsReceipt
		|	AND ItemList.PurchaseOrderExists
		|	AND ItemList.PurchaseOrder.UseItemsReceiptScheduling";

EndFunction

Function R4050B_StockInventory()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R4050B_StockInventory
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService";

EndFunction

Function R5010B_ReconciliationStatement()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Company AS Company,
		|	ItemList.LegalName AS LegalName,
		|	ItemList.Currency AS Currency,
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

Function R4035B_IncomingStocks()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	*
		|INTO R4035B_IncomingStocks
		|FROM
		|	IncomingStocks AS IncomingStocks
		|WHERE
		|	TRUE";
EndFunction

Function R4035B_IncomingStocks_Exists()
	Return
		"SELECT *
		|	INTO R4035B_IncomingStocks_Exists
		|FROM
		|	AccumulationRegister.R4035B_IncomingStocks AS R4035B_IncomingStocks
		|WHERE
		|	R4035B_IncomingStocks.Recorder = &Ref";
EndFunction

Function R4036B_IncomingStocksRequested()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	*
		|INTO R4036B_IncomingStocksRequested
		|FROM
		|	IncomingStocksRequested AS IncomingStocksRequested
		|WHERE
		|	TRUE";
EndFunction	

Function R4036B_IncomingStocksRequested_Exists()
	Return
		"SELECT
		|	*
		|INTO R4036B_IncomingStocksRequested_Exists
		|FROM
		|	AccumulationRegister.R4036B_IncomingStocksRequested AS R4036B_IncomingStocksRequested
		|WHERE
		|	R4036B_IncomingStocksRequested.Recorder = &Ref";
EndFunction

Function R4012B_StockReservation()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	IncomingStocksRequested.IncomingStore AS Store,
		|	IncomingStocksRequested.Requester AS Order,
		|*
		|INTO R4012B_StockReservation
		|FROM 
		|	IncomingStocksRequested AS IncomingStocksRequested";	
EndFunction
	
#EndRegion
