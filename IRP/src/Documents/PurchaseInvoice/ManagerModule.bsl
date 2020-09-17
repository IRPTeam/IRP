#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("OrderBalance", PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("InventoryBalance", PostingServer.CreateTable(AccReg.InventoryBalance));
	Tables.Insert("GoodsInTransitIncoming", PostingServer.CreateTable(AccReg.GoodsInTransitIncoming));
	Tables.Insert("StockBalance", PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("StockReservation_Receipt", PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockReservation_Expense", PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("PartnerApTransactions", PostingServer.CreateTable(AccReg.PartnerApTransactions));
	Tables.Insert("PurchaseTurnovers", PostingServer.CreateTable(AccReg.PurchaseTurnovers));
	Tables.Insert("AdvanceToSuppliers_Lock", PostingServer.CreateTable(AccReg.AdvanceToSuppliers));
	Tables.Insert("AdvanceToSuppliers_Registrations", PostingServer.CreateTable(AccReg.AdvanceToSuppliers));
	Tables.Insert("ReceiptOrders", PostingServer.CreateTable(AccReg.ReceiptOrders));
	Tables.Insert("ExpensesTurnovers", PostingServer.CreateTable(AccReg.ExpensesTurnovers));
	Tables.Insert("GoodsReceiptSchedule_Expense", PostingServer.CreateTable(AccReg.GoodsReceiptSchedule));
	Tables.Insert("GoodsReceiptSchedule_Receipt", PostingServer.CreateTable(AccReg.GoodsReceiptSchedule));
	Tables.Insert("OrderProcurement", PostingServer.CreateTable(AccReg.OrderProcurement));
	Tables.Insert("ReconciliationStatement", PostingServer.CreateTable(AccReg.ReconciliationStatement));
	Tables.Insert("TaxesTurnovers", PostingServer.CreateTable(AccReg.TaxesTurnovers));
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	PurchaseInvoiceItemList.Ref.Company AS Company,
		|	PurchaseInvoiceItemList.Store AS Store,
		|	PurchaseInvoiceItemList.Store.UseGoodsReceipt AS UseGoodsReceipt,
		|	PurchaseInvoiceItemList.Store.UseShipmentConfirmation AS UseShipmentConfirmation,
		|	CASE
		|		WHEN MAX(GoodsReceipts.Key) IS NULL
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
		|	SUM(PurchaseInvoiceItemList.Quantity) AS Quantity,
		|	SUM(PurchaseInvoiceItemList.TotalAmount) AS TotalAmount,
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
		|	PurchaseInvoiceItemList.Ref.IsOpeningEntry AS IsOpeningEntry,
		|	PurchaseInvoiceItemList.BusinessUnit AS BusinessUnit,
		|	PurchaseInvoiceItemList.ExpenseType AS ExpenseType,
		|	CASE
		|		WHEN PurchaseInvoiceItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service)
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsService,
		|	PurchaseInvoiceItemList.DeliveryDate AS DeliveryDate,
		|	SUM(PurchaseInvoiceItemList.NetAmount) AS NetAmount
		|FROM
		|	Document.PurchaseInvoice.ItemList AS PurchaseInvoiceItemList
		|		LEFT JOIN Document.PurchaseInvoice.GoodsReceipts AS GoodsReceipts
		|		ON PurchaseInvoiceItemList.Ref = GoodsReceipts.Ref
		|		AND PurchaseInvoiceItemList.Key = GoodsReceipts.Key
		|		AND PurchaseInvoiceItemList.Ref = &Ref
		|		AND GoodsReceipts.Ref = &Ref
		|WHERE
		|	PurchaseInvoiceItemList.Ref = &Ref
		|GROUP BY
		|	PurchaseInvoiceItemList.Ref.Company,
		|	PurchaseInvoiceItemList.Store,
		|	PurchaseInvoiceItemList.Store.UseGoodsReceipt,
		|	PurchaseInvoiceItemList.Store.UseShipmentConfirmation,
		|	PurchaseInvoiceItemList.GoodsReceipt,
		|	CASE
		|		WHEN PurchaseInvoiceItemList.GoodsReceipt.Date IS NULL
		|			THEN FALSE
		|		ELSE TRUE
		|	END
		|	OR CASE
		|		WHEN PurchaseInvoiceItemList.PurchaseOrder.Date IS NULL
		|			THEN FALSE
		|		ELSE PurchaseInvoiceItemList.PurchaseOrder.GoodsReceiptBeforePurchaseInvoice
		|	END,
		|	CASE
		|		WHEN PurchaseInvoiceItemList.PurchaseOrder.Date IS NULL
		|			THEN FALSE
		|		ELSE TRUE
		|	END,
		|	CASE
		|		WHEN PurchaseInvoiceItemList.SalesOrder.Date IS NULL
		|			THEN FALSE
		|		ELSE TRUE
		|	END,
		|	CASE
		|		WHEN NOT PurchaseInvoiceItemList.SalesOrder.Date IS NULL
		|			THEN PurchaseInvoiceItemList.SalesOrder.ShipmentConfirmationsBeforeSalesInvoice
		|		ELSE FALSE
		|	END,
		|	PurchaseInvoiceItemList.ItemKey,
		|	PurchaseInvoiceItemList.Ref.Partner,
		|	PurchaseInvoiceItemList.Ref.LegalName,
		|	CASE
		|		WHEN PurchaseInvoiceItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND PurchaseInvoiceItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN PurchaseInvoiceItemList.Ref.Agreement.StandardAgreement
		|		ELSE PurchaseInvoiceItemList.Ref.Agreement
		|	END,
		|	ISNULL(PurchaseInvoiceItemList.Ref.Currency, VALUE(Catalog.Currencies.EmptyRef)),
		|	PurchaseInvoiceItemList.PurchaseOrder,
		|	PurchaseInvoiceItemList.SalesOrder,
		|	PurchaseInvoiceItemList.Ref,
		|	PurchaseInvoiceItemList.Unit,
		|	PurchaseInvoiceItemList.ItemKey.Item.Unit,
		|	PurchaseInvoiceItemList.ItemKey.Unit,
		|	PurchaseInvoiceItemList.ItemKey.Item,
		|	PurchaseInvoiceItemList.Ref.Date,
		|	PurchaseInvoiceItemList.Key,
		|	PurchaseInvoiceItemList.AdditionalAnalytic,
		|	PurchaseInvoiceItemList.Ref.IsOpeningEntry,
		|	PurchaseInvoiceItemList.BusinessUnit,
		|	PurchaseInvoiceItemList.ExpenseType,
		|	CASE
		|		WHEN PurchaseInvoiceItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service)
		|			THEN TRUE
		|		ELSE FALSE
		|	END,
		|	PurchaseInvoiceItemList.DeliveryDate,
		|	VALUE(Catalog.Units.EmptyRef)";
	
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.Execute();
	
	QueryTable = QueryResults.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTable);
	
	// UUID to String
	QueryTable.Columns.Add("RowKey", Metadata.AccumulationRegisters.GoodsReceiptSchedule.Dimensions.RowKey.Type);
	For Each Row In QueryTable Do
		Row.RowKey = String(Row.RowKeyUUID);
	EndDo;
	
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
	// UUID to String
	QueryTableTaxList.Columns.Add("RowKey", Metadata.AccumulationRegisters.TaxesTurnovers.Dimensions.RowKey.Type);
	For Each Row In QueryTableTaxList Do
		Row.RowKey = String(Row.RowKeyUUID);
	EndDo;
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
		|	QueryTable.IsOpeningEntry AS IsOpeningEntry,
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
	
	GetTables_Common(Tables, TempManager, "tmp");
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM tmp AS tmp
		|WHERE
		|    NOT tmp.UsePurchaseOrder
		|AND NOT tmp.UseSalesOrder
		|AND NOT tmp.UseGoodsReceiptBeforeInvoice
		|AND NOT tmp.IsOpeningEntry";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_1").GetData().IsEmpty() Then
		GetTables_NotUsePurchaseOrder_NotUseSalesOrder_NotUseGoodsReceiptBeforeInvoice(Tables, 
		                                                                               TempManager, 
		                                                                               "tmp_1");
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_2 FROM tmp AS tmp
		|WHERE
		|        tmp.UsePurchaseOrder
		|AND NOT tmp.UseSalesOrder
		|AND NOT tmp.UseGoodsReceiptBeforeInvoice
		|AND NOT tmp.IsOpeningEntry";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_2").GetData().IsEmpty() Then
		GetTables_UsePurchaseOrder_NotUseSalesOrder_NotUseGoodsReceiptBeforeInvoice(Tables, 
		                                                                            TempManager, 
		                                                                            "tmp_2");
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM tmp AS tmp
		|WHERE
		|        tmp.UsePurchaseOrder
		|AND NOT tmp.UseSalesOrder
		|AND     tmp.UseGoodsReceiptBeforeInvoice
		|AND NOT tmp.IsOpeningEntry";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_3").GetData().IsEmpty() Then
		GetTables_UsePurchaseOrder_NotUseSalesOrder_UseGoodsReceiptBeforeInvoice(Tables, 
		                                                                         TempManager, 
		                                                                         "tmp_3");
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_4 FROM tmp AS tmp
		|WHERE
		|        tmp.UsePurchaseOrder
		|AND     tmp.UseSalesOrder
		|AND NOT tmp.UseGoodsReceiptBeforeInvoice
		|AND NOT tmp.UseShipmentBeforeInvoice
		|AND NOT tmp.IsOpeningEntry";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_4").GetData().IsEmpty() Then
		GetTables_UsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_NotShipmentBeforeInvoice(Tables, 
		                                                                                               TempManager, 
		                                                                                               "tmp_4");
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_5 FROM tmp AS tmp
		|WHERE
		|    NOT tmp.UsePurchaseOrder
		|AND     tmp.UseSalesOrder
		|AND NOT tmp.UseGoodsReceiptBeforeInvoice
		|AND NOT tmp.UseShipmentBeforeInvoice
		|AND NOT tmp.IsOpeningEntry";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_5").GetData().IsEmpty() Then
		GetTables_NotUsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_NotShipmentBeforeInvoice(Tables, 
		                                                                                                  TempManager, 
		                                                                                                  "tmp_5");
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_6 FROM tmp AS tmp
		|WHERE
		|        tmp.UsePurchaseOrder
		|AND     tmp.UseSalesOrder
		|AND     tmp.UseGoodsReceiptBeforeInvoice
		|AND NOT tmp.UseShipmentBeforeInvoice
		|AND NOT tmp.IsOpeningEntry";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_6").GetData().IsEmpty() Then
		GetTables_UsePurchaseOrder_UseSalesOrder_GoodsReceiptBeforeInvoice_NotShipmentBeforeInvoice(Tables, 
		                                                                                            TempManager, 
		                                                                                            "tmp_6");
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_7 FROM tmp AS tmp
		|WHERE
		|        tmp.UsePurchaseOrder
		|AND     tmp.UseSalesOrder
		|AND NOT tmp.UseGoodsReceiptBeforeInvoice
		|AND     tmp.UseShipmentBeforeInvoice
		|AND NOT tmp.IsOpeningEntry";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_7").GetData().IsEmpty() Then
		GetTables_UsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_ShipmentBeforeInvoice(Tables, 
		                                                                                            TempManager, 
		                                                                                            "tmp_7");
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_8 FROM tmp AS tmp
		|WHERE
		|    NOT tmp.UsePurchaseOrder
		|AND     tmp.UseSalesOrder
		|AND NOT tmp.UseGoodsReceiptBeforeInvoice
		|AND     tmp.UseShipmentBeforeInvoice
		|AND NOT tmp.IsOpeningEntry";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_8").GetData().IsEmpty() Then
		GetTables_NotUsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_ShipmentBeforeInvoice(Tables, 
		                                                                                               TempManager, 
		                                                                                               "tmp_8");
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_9 FROM tmp AS tmp
		|WHERE
		|        tmp.UsePurchaseOrder
		|AND     tmp.UseSalesOrder
		|AND     tmp.UseGoodsReceiptBeforeInvoice
		|AND     tmp.UseShipmentBeforeInvoice
		|AND NOT tmp.IsOpeningEntry";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_9").GetData().IsEmpty() Then
		GetTables_UsePurchaseOrder_UseSalesOrder_GoodsReceiptBeforeInvoice_ShipmentBeforeInvoice(Tables, 
		                                                                                         TempManager, 
		                                                                                         "tmp_9");
	EndIf;
	
	Parameters.IsReposting = False;	
	Return Tables;
EndFunction

Procedure GetTables_Common(Tables, TempManager, TableName)
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
		|	SUM(tmp.Quantity) AS Quantity,
		|	SUM(tmp.Amount) AS Amount,
		|	SUM(tmp.NetAmount) AS NetAmount,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.PurchaseInvoice,
		|	tmp.Currency,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.RowKey
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
	
	Tables.PartnerApTransactions = QueryResults[0].Unload();
	Tables.PurchaseTurnovers = QueryResults[1].Unload();
	Tables.AdvanceToSuppliers_Lock = QueryResults[2].Unload();
	Tables.AdvanceToSuppliers_Registrations = New ValueTable();
	Tables.ReconciliationStatement = QueryResults[3].Unload();
EndProcedure

#Region Table_tmp_1

Procedure GetTables_NotUsePurchaseOrder_NotUseSalesOrder_NotUseGoodsReceiptBeforeInvoice(Tables, 
                                                                                         TempManager, 
                                                                                         TableName)
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
		GetTables_NotUsePurchaseOrder_NotUseSalesOrder_NotUseGoodsReceiptBeforeInvoice_NotUseGoodsReceipt_IsProduct(Tables, 
		                                                                                                            TempManager, 
		                                                                                                            NewTableName);
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
		GetTables_NotUsePurchaseOrder_NotUseSalesOrder_NotUseGoodsReceiptBeforeInvoice_UseGoodsReceipt_IsProduct(Tables, 
		                                                                                                         TempManager, 
		                                                                                                         NewTableName);
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
		GetTables_NotUsePurchaseOrder_NotUseSalesOrder_NotUseGoodsReceiptBeforeInvoice_IsService(Tables, 
		                                                                                         TempManager, 
		                                                                                         NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_NotUsePurchaseOrder_NotUseSalesOrder_NotUseGoodsReceiptBeforeInvoice_NotUseGoodsReceipt_IsProduct(Tables, 
                                                                                                                      TempManager, 
                                                                                                                      TableName)
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
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|GROUP BY
		|	tmp.Company,
		|	tmp.PurchaseInvoice,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period
		|;
		|
		|//[4] GoodsReceiptSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.PurchaseInvoice AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	 tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|GROUP BY
		|	tmp.Company,
		|	tmp.PurchaseInvoice,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.InventoryBalance, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Receipt, QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense, QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Receipt, QueryResults[4].Unload());
EndProcedure

Procedure GetTables_NotUsePurchaseOrder_NotUseSalesOrder_NotUseGoodsReceiptBeforeInvoice_UseGoodsReceipt_IsProduct(Tables, 
                                                                                                                   TempManager, 
                                                                                                                   TableName)
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
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|//[2] GoodsReceiptSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.PurchaseInvoice AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|GROUP BY
		|	tmp.Company,
		|	tmp.PurchaseInvoice,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.InventoryBalance, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsInTransitIncoming, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Receipt, QueryResults[2].Unload());
EndProcedure

Procedure GetTables_NotUsePurchaseOrder_NotUseSalesOrder_NotUseGoodsReceiptBeforeInvoice_IsService(Tables, 
                                                                                                   TempManager, 
                                                                                                   TableName)
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
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|GROUP BY
		|	tmp.Company,
		|	tmp.PurchaseInvoice,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|;
		|
		|//[2] GoodsReceiptSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.PurchaseInvoice AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|GROUP BY
		|	tmp.Company,
		|	tmp.PurchaseInvoice,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.ExpensesTurnovers, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Receipt, QueryResults[2].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_2

Procedure GetTables_UsePurchaseOrder_NotUseSalesOrder_NotUseGoodsReceiptBeforeInvoice(Tables, 
                                                                                      TempManager, 
                                                                                      TableName)
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
		GetTables_UsePurchaseOrder_NotUseSalesOrder_NotUseGoodsReceiptBeforeInvoice_NotUseGoodsReceipt_IsProduct(Tables, 
		                                                                                                         TempManager, 
		                                                                                                         NewTableName);
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
		GetTables_UsePurchaseOrder_NotUseSalesOrder_NotUseGoodsReceiptBeforeInvoice_UseGoodsReceipt_IsProduct(Tables, 
		                                                                                                      TempManager, 
		                                                                                                      NewTableName);
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
		GetTables_UsePurchaseOrder_NotUseSalesOrder_NotUseGoodsReceiptBeforeInvoice_IsService(Tables, 
		                                                                                      TempManager, 
		                                                                                      NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_UsePurchaseOrder_NotUseSalesOrder_NotUseGoodsReceiptBeforeInvoice_NotUseGoodsReceipt_IsProduct(Tables, 
                                                                                                                   TempManager, 
                                                                                                                   TableName)
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
		|	SUM(tmp.Quantity) AS Quantity,
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
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period
		|;
		|
		|//[4] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|	tmp.RowKey";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.InventoryBalance, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Receipt, QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense, QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.OrderBalance, QueryResults[4].Unload());
EndProcedure

Procedure GetTables_UsePurchaseOrder_NotUseSalesOrder_NotUseGoodsReceiptBeforeInvoice_UseGoodsReceipt_IsProduct(Tables, 
                                                                                                                TempManager, 
                                                                                                                TableName)
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
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|//[2] GoodsReceiptSchedule_Expense
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
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
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	GoodsReceiptSchedule.DeliveryDate
		|;
		|//[3] GoodsReceiptSchedule_Receipt 
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
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
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|;
		|//[4] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|	tmp.RowKey";
	
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.InventoryBalance, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsInTransitIncoming, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense, QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Receipt, QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.OrderBalance, QueryResults[4].Unload());
EndProcedure

Procedure GetTables_UsePurchaseOrder_NotUseSalesOrder_NotUseGoodsReceiptBeforeInvoice_IsService(Tables, 
                                                                                                TempManager, 
                                                                                                TableName)
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
		|	SUM(tmp.Quantity) AS Quantity,
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
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period
		|;
		|
		|//[2] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|	tmp.RowKey";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.ExpensesTurnovers, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.OrderBalance, QueryResults[2].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_3

Procedure GetTables_UsePurchaseOrder_NotUseSalesOrder_UseGoodsReceiptBeforeInvoice(Tables, 
                                                                                   TempManager, 
                                                                                   TableName)
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
		GetTables_UsePurchaseOrder_NotUseSalesOrder_UseGoodsReceiptBeforeInvoice_NotUseGoodsReceipt_IsProduct(Tables, 
		                                                                                                      TempManager, 
		                                                                                                      NewTableName);
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
		GetTables_UsePurchaseOrder_NotUseSalesOrder_UseGoodsReceiptBeforeInvoice_UseGoodsReceipt_IsProduct(Tables, 
		                                                                                                   TempManager, 
		                                                                                                   NewTableName);
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
		GetTables_UsePurchaseOrder_NotUseSalesOrder_UseGoodsReceiptBeforeInvoice_IsService(Tables, 
		                                                                                   TempManager, 
		                                                                                   NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_UsePurchaseOrder_NotUseSalesOrder_UseGoodsReceiptBeforeInvoice_NotUseGoodsReceipt_IsProduct(Tables, 
                                                                                                                TempManager, 
                                                                                                                TableName)
	// tmp_3_1
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		// [0] ReceiptOrders
		"SELECT
		|	tmp.Order AS Order,
		|	GoodsReceipts.GoodsReceipt AS GoodsReceipt,
		|	SUM(ISNULL(GoodsReceipts.Quantity, 0)) AS Quantity,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|		LEFT JOIN GoodsReceipts AS GoodsReceipts
		|		ON tmp.RowKeyUUID = GoodsReceipts.RowKeyUUID
		|GROUP BY
		|	tmp.Order,
		|	tmp.Period,
		|	GoodsReceipts.GoodsReceipt,
		|	tmp.ItemKey,
		|	tmp.RowKey
		|;
		|
		|//[1] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|	tmp.RowKey";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.ReceiptOrders, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderBalance, QueryResults[1].Unload());
EndProcedure

Procedure GetTables_UsePurchaseOrder_NotUseSalesOrder_UseGoodsReceiptBeforeInvoice_UseGoodsReceipt_IsProduct(Tables, 
                                                                                                             TempManager, 
                                                                                                             TableName)
	// tmp_3_2
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		// [0] ReceiptOrders
		"SELECT
		|	tmp.Order AS Order,
		|	GoodsReceipts.GoodsReceipt AS GoodsReceipt,
		|	SUM(ISNULL(GoodsReceipts.Quantity, 0)) AS Quantity,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|		LEFT JOIN GoodsReceipts AS GoodsReceipts
		|		ON tmp.RowKeyUUID = GoodsReceipts.RowKeyUUID
		|GROUP BY
		|	tmp.Order,
		|	tmp.Period,
		|	GoodsReceipts.GoodsReceipt,
		|	tmp.ItemKey,
		|	tmp.RowKey
		|;
		|
		|//[1] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|	tmp.RowKey";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.ReceiptOrders, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderBalance, QueryResults[1].Unload());
EndProcedure

Procedure GetTables_UsePurchaseOrder_NotUseSalesOrder_UseGoodsReceiptBeforeInvoice_IsService(Tables, 
                                                                                             TempManager, 
                                                                                             TableName)
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
		|	SUM(tmp.Quantity) AS Quantity,
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
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period
		|;
		|
		|//[2] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|	tmp.RowKey";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.ExpensesTurnovers, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.OrderBalance, QueryResults[2].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_4

Procedure GetTables_UsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_NotShipmentBeforeInvoice(Tables, 
                                                                                                         TempManager, 
                                                                                                         TableName)
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
		GetTables_UsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_NotShipmentBeforeInvoice_NotUseGoodsReceipt_IsProduct(Tables, 
		                                                                                                                            TempManager, 
		                                                                                                                            NewTableName);
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
		GetTables_UsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_NotShipmentBeforeInvoice_UseGoodsReceipt_IsProduct(Tables, 
		                                                                                                                         TempManager, 
		                                                                                                                         NewTableName);
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
		GetTables_UsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_NotShipmentBeforeInvoice_IsService(Tables, 
		                                                                                                         TempManager, 
		                                                                                                         NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_UsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_NotShipmentBeforeInvoice_NotUseGoodsReceipt_IsProduct(Tables, 
                                                                                                                                      TempManager, 
                                                                                                                                      TableName)
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
		|	SUM(tmp.Quantity) AS Quantity,
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
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period
		|;
		|
		|//[5] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|	tmp.RowKey";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.InventoryBalance, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Receipt, QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Expense, QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense, QueryResults[4].Unload());
	PostingServer.MergeTables(Tables.OrderBalance, QueryResults[5].Unload());
EndProcedure

Procedure GetTables_UsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_NotShipmentBeforeInvoice_UseGoodsReceipt_IsProduct(Tables, 
                                                                                                                                   TempManager, 
                                                                                                                                   TableName)
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
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|//[2] GoodsReceiptSchedule_Expense
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
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
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	GoodsReceiptSchedule.DeliveryDate
		|;
		|//[3] GoodsReceiptSchedule_Receipt 
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
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
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|;
		|//[4] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|	tmp.RowKey";
	
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.InventoryBalance, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsInTransitIncoming, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense, QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Receipt, QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.OrderBalance, QueryResults[4].Unload());
EndProcedure

Procedure GetTables_UsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_NotShipmentBeforeInvoice_IsService(Tables, 
                                                                                                                   TempManager, 
                                                                                                                   TableName)
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
		|	SUM(tmp.Quantity) AS Quantity,
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
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period
		|;
		|
		|//[2] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|	tmp.RowKey";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.ExpensesTurnovers, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.OrderBalance, QueryResults[2].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_5

Procedure GetTables_NotUsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_NotShipmentBeforeInvoice(Tables, 
                                                                                                            TempManager, 
                                                                                                            TableName)
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
		GetTables_NotUsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_NotShipmentBeforeInvoice_NotUseGoodsReceipt_IsProduct(Tables, 
		                                                                                                                               TempManager, 
		                                                                                                                               NewTableName);
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
		GetTables_NotUsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_NotShipmentBeforeInvoice_UseGoodsReceipt_IsProduct(Tables, 
		                                                                                                                            TempManager, 
		                                                                                                                            NewTableName);
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
		GetTables_NotUsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_NotShipmentBeforeInvoice_IsService(Tables,
		                                                                                                            TempManager, 
		                                                                                                            NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_NotUsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_NotShipmentBeforeInvoice_NotUseGoodsReceipt_IsProduct(Tables, 
                                                                                                                                         TempManager, 
                                                                                                                                         TableName)
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
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|GROUP BY
		|	tmp.Company,
		|	tmp.PurchaseInvoice,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period
		|;
		|
		|//[5] GoodsReceiptSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.PurchaseInvoice AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	 tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|GROUP BY
		|	tmp.Company,
		|	tmp.PurchaseInvoice,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|;
		|//[6] OrderProcurement
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.SalesOrder AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|   tmp.SalesOrder,
		|   tmp.Store,
		|   tmp.ItemKey,
		|   tmp.RowKey,
		|   tmp.Period";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.InventoryBalance, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Receipt, QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Expense, QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense, QueryResults[4].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Receipt, QueryResults[5].Unload());
	PostingServer.MergeTables(Tables.OrderProcurement, QueryResults[6].Unload());
EndProcedure

Procedure GetTables_NotUsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_NotShipmentBeforeInvoice_UseGoodsReceipt_IsProduct(Tables, 
                                                                                                                                      TempManager, 
                                                                                                                                      TableName)
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
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|//[2] GoodsReceiptSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.PurchaseInvoice AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|GROUP BY
		|	tmp.Company,
		|	tmp.PurchaseInvoice,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.InventoryBalance, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsInTransitIncoming, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Receipt, QueryResults[2].Unload());
EndProcedure

Procedure GetTables_NotUsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_NotShipmentBeforeInvoice_IsService(Tables, 
                                                                                                                      TempManager, 
                                                                                                                      TableName)
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
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|GROUP BY
		|	tmp.Company,
		|	tmp.PurchaseInvoice,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|;
		|
		|//[2] GoodsReceiptSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.PurchaseInvoice AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|GROUP BY
		|	tmp.Company,
		|	tmp.PurchaseInvoice,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.ExpensesTurnovers, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Receipt, QueryResults[2].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_6

Procedure GetTables_UsePurchaseOrder_UseSalesOrder_GoodsReceiptBeforeInvoice_NotShipmentBeforeInvoice(Tables, 
                                                                                                      TempManager, 
                                                                                                      TableName)
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
		GetTables_UsePurchaseOrder_UseSalesOrder_GoodsReceiptBeforeInvoice_NotShipmentBeforeInvoice_NotUseGoodsReceipt_IsProduct(Tables, 
		                                                                                                                         TempManager, 
		                                                                                                                         NewTableName);
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
		GetTables_UsePurchaseOrder_UseSalesOrder_GoodsReceiptBeforeInvoice_NotShipmentBeforeInvoice_UseGoodsReceipt_IsProduct(Tables, 
		                                                                                                                      TempManager, 
		                                                                                                                      NewTableName);
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
		GetTables_UsePurchaseOrder_UseSalesOrder_GoodsReceiptBeforeInvoice_NotShipmentBeforeInvoice_IsService(Tables, 
		                                                                                                      TempManager, 
		                                                                                                      NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_UsePurchaseOrder_UseSalesOrder_GoodsReceiptBeforeInvoice_NotShipmentBeforeInvoice_NotUseGoodsReceipt_IsProduct(Tables, 
                                                                                                                                   TempManager, 
                                                                                                                                   TableName)
	// tmp_6_1
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		// [0] ReceiptOrders
		"SELECT
		|	tmp.Order AS Order,
		|	GoodsReceipts.GoodsReceipt AS GoodsReceipt,
		|	SUM(ISNULL(GoodsReceipts.Quantity, 0)) AS Quantity,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|		LEFT JOIN GoodsReceipts AS GoodsReceipts
		|		ON tmp.RowKeyUUID = GoodsReceipts.RowKeyUUID
		|GROUP BY
		|	tmp.Order,
		|	tmp.Period,
		|	GoodsReceipts.GoodsReceipt,
		|	tmp.ItemKey,
		|	tmp.RowKey
		|;
		|
		|//[1] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|	tmp.RowKey";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.ReceiptOrders, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderBalance, QueryResults[1].Unload());
EndProcedure

Procedure GetTables_UsePurchaseOrder_UseSalesOrder_GoodsReceiptBeforeInvoice_NotShipmentBeforeInvoice_UseGoodsReceipt_IsProduct(Tables, 
                                                                                                                                TempManager, 
                                                                                                                                TableName)
	// tmp_6_2
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		// [0] ReceiptOrders
		"SELECT
		|	tmp.Order AS Order,
		|	GoodsReceipts.GoodsReceipt AS GoodsReceipt,
		|	SUM(ISNULL(GoodsReceipts.Quantity, 0)) AS Quantity,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|		LEFT JOIN GoodsReceipts AS GoodsReceipts
		|		ON tmp.RowKeyUUID = GoodsReceipts.RowKeyUUID
		|GROUP BY
		|	tmp.Order,
		|	tmp.Period,
		|	GoodsReceipts.GoodsReceipt,
		|	tmp.ItemKey,
		|	tmp.RowKey
		|;
		|
		|//[1] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|	tmp.RowKey";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.ReceiptOrders, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderBalance, QueryResults[1].Unload());
EndProcedure

Procedure GetTables_UsePurchaseOrder_UseSalesOrder_GoodsReceiptBeforeInvoice_NotShipmentBeforeInvoice_IsService(Tables, 
                                                                                                                TempManager, 
                                                                                                                TableName)
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
		|	SUM(tmp.Quantity) AS Quantity,
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
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period
		|;
		|
		|//[2] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|	tmp.RowKey";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.ExpensesTurnovers, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.OrderBalance, QueryResults[2].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_7

Procedure GetTables_UsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_ShipmentBeforeInvoice(Tables, 
                                                                                                      TempManager, 
                                                                                                      TableName)
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
		GetTables_UsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_ShipmentBeforeInvoice_NotUseGoodsReceipt_IsProduct(Tables, 
		                                                                                                                         TempManager, 
		                                                                                                                         NewTableName);
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
		GetTables_UsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_ShipmentBeforeInvoice_UseGoodsReceipt_IsProduct(Tables, 
		                                                                                                                      TempManager, 
		                                                                                                                      NewTableName);
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
		GetTables_UsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_ShipmentBeforeInvoice_IsService(Tables, 
		                                                                                                      TempManager, 
		                                                                                                      NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_UsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_ShipmentBeforeInvoice_NotUseGoodsReceipt_IsProduct(Tables, 
                                                                                                                                   TempManager, 
                                                                                                                                   TableName)
	Return;
EndProcedure

Procedure GetTables_UsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_ShipmentBeforeInvoice_UseGoodsReceipt_IsProduct(Tables, 
                                                                                                                                TempManager, 
                                                                                                                                TableName)
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
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|//[2] GoodsReceiptSchedule_Expense
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
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
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	GoodsReceiptSchedule.DeliveryDate
		|;
		|//[3] GoodsReceiptSchedule_Receipt 
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
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
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|;
		|//[4] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|	tmp.RowKey";
	
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.InventoryBalance, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsInTransitIncoming, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Expense, QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Receipt, QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.OrderBalance, QueryResults[4].Unload());
	
	Return;
EndProcedure

Procedure GetTables_UsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_ShipmentBeforeInvoice_IsService(Tables, 
                                                                                                                TempManager, 
                                                                                                                TableName)
	Return;
EndProcedure

#EndRegion

#Region Table_tmp_8

Procedure GetTables_NotUsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_ShipmentBeforeInvoice(Tables, 
                                                                                                         TempManager, 
                                                                                                         TableName)
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
		GetTables_NotUsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_ShipmentBeforeInvoice_NotUseGoodsReceipt_IsProduct(Tables, 
		                                                                                                                            TempManager, 
		                                                                                                                            NewTableName);
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
		GetTables_NotUsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_ShipmentBeforeInvoice_UseGoodsReceipt_UseShipmentConfirmation_IsProduct(Tables, 
		                                                                                                                                                 TempManager, 
		                                                                                                                                                 NewTableName);
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
		GetTables_NotUsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_ShipmentBeforeInvoice_IsService(Tables, 
		                                                                                                         TempManager, 
		                                                                                                         NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_NotUsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_ShipmentBeforeInvoice_NotUseGoodsReceipt_IsProduct(Tables, 
                                                                                                                                      TempManager, 
                                                                                                                                      TableName)
	Return;	
EndProcedure

Procedure GetTables_NotUsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_ShipmentBeforeInvoice_UseGoodsReceipt_UseShipmentConfirmation_IsProduct(Tables, 
                                                                                                                                                           TempManager, 
                                                                                                                                                           TableName)
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
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|//[2] GoodsReceiptSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.PurchaseInvoice AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|GROUP BY
		|	tmp.Company,
		|	tmp.PurchaseInvoice,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|;
		|//[3] OrderProcurement
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.SalesOrder AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|   tmp.SalesOrder,
		|   tmp.Store,
		|   tmp.ItemKey,
		|   tmp.RowKey,
		|   tmp.Period";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.InventoryBalance, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsInTransitIncoming, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule_Receipt, QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.OrderProcurement, QueryResults[3].Unload());
EndProcedure

Procedure GetTables_NotUsePurchaseOrder_UseSalesOrder_NotGoodsReceiptBeforeInvoice_ShipmentBeforeInvoice_IsService(Tables, 
                                                                                                                   TempManager, 
                                                                                                                   TableName)
	// tmp_8_3
	Return;
EndProcedure

#EndRegion

#Region Table_tmp_9

Procedure GetTables_UsePurchaseOrder_UseSalesOrder_GoodsReceiptBeforeInvoice_ShipmentBeforeInvoice(Tables, 
                                                                                                   TempManager, 
                                                                                                   TableName)
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
		GetTables_UsePurchaseOrder_UseSalesOrder_GoodsReceiptBeforeInvoice_ShipmentBeforeInvoice_NotUseGoodsReceipt_IsProduct(Tables, 
		                                                                                                                      TempManager, 
		                                                                                                                      NewTableName);
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
		GetTables_UsePurchaseOrder_UseSalesOrder_GoodsReceiptBeforeInvoice_ShipmentBeforeInvoice_UseGoodsReceipt_IsProduct(Tables, 
		                                                                                                                   TempManager, 
		                                                                                                                   NewTableName);
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
		GetTables_UsePurchaseOrder_UseSalesOrder_GoodsReceiptBeforeInvoice_ShipmentBeforeInvoice_IsService(Tables, 
		                                                                                                   TempManager, 
		                                                                                                   NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_UsePurchaseOrder_UseSalesOrder_GoodsReceiptBeforeInvoice_ShipmentBeforeInvoice_NotUseGoodsReceipt_IsProduct(Tables, 
                                                                                                                                TempManager, 
                                                                                                                                TableName)
	// tmp_9_1
	Return;
EndProcedure

Procedure GetTables_UsePurchaseOrder_UseSalesOrder_GoodsReceiptBeforeInvoice_ShipmentBeforeInvoice_UseGoodsReceipt_IsProduct(Tables, 
                                                                                                                             TempManager, 
                                                                                                                             TableName)
	// tmp_9_2
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		// [0] ReceiptOrders
		"SELECT
		|	tmp.Order AS Order,
		|	GoodsReceipts.GoodsReceipt AS GoodsReceipt,
		|	SUM(ISNULL(GoodsReceipts.Quantity, 0)) AS Quantity,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|		LEFT JOIN GoodsReceipts AS GoodsReceipts
		|		ON tmp.RowKeyUUID = GoodsReceipts.RowKeyUUID
		|GROUP BY
		|	tmp.Order,
		|	tmp.Period,
		|	GoodsReceipts.GoodsReceipt,
		|	tmp.ItemKey,
		|	tmp.RowKey
		|;
		|
		|//[1] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|	tmp.RowKey";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.ReceiptOrders, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderBalance, QueryResults[1].Unload());
EndProcedure

Procedure GetTables_UsePurchaseOrder_UseSalesOrder_GoodsReceiptBeforeInvoice_ShipmentBeforeInvoice_IsService(Tables, 
                                                                                                             TempManager, 
                                                                                                             TableName)
	// tmp_9_3
	Return;	
EndProcedure

#EndRegion

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// OrderBalance
	Fields = New Map();
	Fields.Insert("Store", "Store");
	Fields.Insert("Order", "Order");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.OrderBalance",
		New Structure("Fields, Data", Fields, DocumentDataTables.OrderBalance));
	
	// InventoryBalance
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.InventoryBalance",
		New Structure("Fields, Data", Fields, DocumentDataTables.InventoryBalance));
	
	// PurchaseTurnovers
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("PurchaseInvoice", "PurchaseInvoice");
	Fields.Insert("Currency", "Currency");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.PurchaseTurnovers",
		New Structure("Fields, Data", Fields, DocumentDataTables.PurchaseTurnovers));
	
	// GoodsInTransitIncoming	
	Fields = New Map();
	Fields.Insert("Store", "Store");
	Fields.Insert("ReceiptBasis", "ReceiptBasis");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.GoodsInTransitIncoming",
		New Structure("Fields, Data", Fields, DocumentDataTables.GoodsInTransitIncoming));
	
	// StockBalance	
	Fields = New Map();
	Fields.Insert("Store", "Store");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.StockBalance",
		New Structure("Fields, Data", Fields, DocumentDataTables.StockBalance));
	
	// StockReservation	
	Fields = New Map();
	Fields.Insert("Store", "Store");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.StockReservation",
		New Structure("Fields, Data", Fields, DocumentDataTables.StockReservation_Expense));
	
	// PartnerApTransactions
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("BasisDocument", "BasisDocument");
	Fields.Insert("Partner", "Partner");
	Fields.Insert("LegalName", "LegalName");
	Fields.Insert("Agreement", "Agreement");
	Fields.Insert("Currency", "Currency");
	DataMapWithLockFields.Insert("AccumulationRegister.PartnerApTransactions",
		New Structure("Fields, Data", Fields, DocumentDataTables.PartnerApTransactions));
	
	// AdvanceToSuppliers (Lock use In PostingCheckBeforeWrite)
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("Partner", "Partner");
	Fields.Insert("LegalName", "LegalName");
	Fields.Insert("Currency", "Currency");
	DataMapWithLockFields.Insert("AccumulationRegister.AdvanceToSuppliers",
		New Structure("Fields, Data", Fields, DocumentDataTables.AdvanceToSuppliers_Lock));
	
	// ReceiptOrders
	Fields = New Map();
	Fields.Insert("Order", "Order");
	Fields.Insert("GoodsReceipt", "GoodsReceipt");
	Fields.Insert("ItemKey", "ItemKey");
	DataMapWithLockFields.Insert("AccumulationRegister.ReceiptOrders",
		New Structure("Fields, Data", Fields, DocumentDataTables.ReceiptOrders));
	
	// ExpensesTurnovers
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("BusinessUnit", "BusinessUnit");
	Fields.Insert("ExpenseType", "ExpenseType");
	Fields.Insert("ItemKey", "ItemKey");
	Fields.Insert("Currency", "Currency");
	
	DataMapWithLockFields.Insert("AccumulationRegister.ExpensesTurnovers",
		New Structure("Fields, Data", Fields, DocumentDataTables.ExpensesTurnovers));
	
	// OrderProcurement
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("Order", "Order");
	Fields.Insert("Store", "Store");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.OrderProcurement",
		New Structure("Fields, Data", Fields, DocumentDataTables.OrderProcurement));
	
	// ReconciliationStatement
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("LegalName", "LegalName");
	Fields.Insert("Currency", "Currency");
	DataMapWithLockFields.Insert("AccumulationRegister.ReconciliationStatement",
		New Structure("Fields, Data", Fields, DocumentDataTables.ReconciliationStatement));
	
	// TaxesTurnovers
	Fields = New Map();
	Fields.Insert("Document", "Document");
	Fields.Insert("Tax", "Tax");
	Fields.Insert("Analytics", "Analytics");
	Fields.Insert("TaxRate", "TaxRate");
	Fields.Insert("IncludeToTotalAmount", "IncludeToTotalAmount");
	Fields.Insert("RowKey", "RowKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.TaxesTurnovers",
		New Structure("Fields, Data", Fields, DocumentDataTables.TaxesTurnovers));
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	// Advance to suppliers
	Parameters.DocumentDataTables.AdvanceToSuppliers_Registrations =
		AccumulationRegisters.AdvanceToSuppliers.GetTableExpenceAdvance(Parameters.Object.RegisterRecords
			, Parameters.PointInTime
			, Parameters.DocumentDataTables.AdvanceToSuppliers_Lock);
			
	If Parameters.DocumentDataTables.AdvanceToSuppliers_Registrations.Count() Then
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
    	Query.SetParameter("QueryTable", Parameters.DocumentDataTables.AdvanceToSuppliers_Registrations);
    	Query.SetParameter("PointInTime", Parameters.PointInTime);
    	Query.SetParameter("Period", Parameters.Object.Date);
    	Parameters.DocumentDataTables.Insert("AdvanceToSuppliers_Registrations_AccountStatement",
    	Query.Execute().Unload());
    EndIf;
EndProcedure

// Return data contains document only or tables locked In PostingGetLockDataSource(), do Not use query to other tables!!!
Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// OrderBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.OrderBalance,
			Parameters.IsReposting));
	
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
			Parameters.IsReposting));
	
	// StockBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.StockBalance,
			Parameters.IsReposting));
	
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
			Parameters.IsReposting));

	// AccountsStatement
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.PartnerApTransactions.Copy();
	Table1.Columns.Amount.Name = "TransactionAP";
	PostingServer.AddColumnsToAccountsStatementTable(Table1);
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.AdvanceToSuppliers_Registrations.Copy();
	Table2.Columns.Amount.Name = "TransactionAP";
	PostingServer.AddColumnsToAccountsStatementTable(Table2);
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	Table3 = Parameters.DocumentDataTables.AdvanceToSuppliers_Registrations.Copy();
	Table3.Columns.Amount.Name = "AdvanceToSuppliers";
	PostingServer.AddColumnsToAccountsStatementTable(Table3);
	Table3.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table3);
	
	If Parameters.DocumentDataTables.Property("AdvanceToSuppliers_Registrations_AccountStatement") Then
		Table4 = Parameters.DocumentDataTables.AdvanceToSuppliers_Registrations_AccountStatement.Copy();
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
	// AdvanceToSuppliers_Registrations [Expense]
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.PartnerApTransactions.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.AdvanceToSuppliers_Registrations.Copy();
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
			Parameters.DocumentDataTables.AdvanceToSuppliers_Registrations));
	
	// ReceiptOrders
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ReceiptOrders,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.ReceiptOrders));
	
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
			Parameters.IsReposting));
	
	// ReconciliationStatement
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ReconciliationStatement,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.ReconciliationStatement));
	
	// TaxesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.TaxesTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.TaxesTurnovers));
	
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion