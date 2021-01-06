
Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	Tables = New Structure();
	
	Parameters.IsReposting = False;	
	
#Region NewRegistersPosting	
	PostingServer.SetRegisters(Tables, Ref);
	QueryArray = GetQueryTexts();
	PostingServer.FillPostingTables(Tables, Ref, QueryArray);
#EndRegion		
	
	Return Tables;
EndFunction

#Region NewRegistersPosting

Function GetQueryTexts()
	QueryArray = New Array;
	QueryArray.Add(SetItemListVT());
	QueryArray.Add(SetPostingTables_R1001T_Purchases());
	QueryArray.Add(SetPostingTables_R1005T_PurchaseSpecialOffers());
	QueryArray.Add(SetPostingTables_R1011B_PurchaseOrdersReceipt());
	QueryArray.Add(SetPostingTables_R1012B_PurchaseOrdersInvoiceClosing());
	QueryArray.Add(SetPostingTables_R1020B_AdvancesToVendors());
	QueryArray.Add(SetPostingTables_R1021B_VendorsTransactions());
	QueryArray.Add(SetPostingTables_R1031B_ReceiptInvoicing());
	QueryArray.Add(SetPostingTables_R1040B_TaxesOutgoing());
	QueryArray.Add(SetPostingTables_R2013T_SalesOrdersProcurement());
	QueryArray.Add(SetPostingTables_R4010B_ActualStocks());
	QueryArray.Add(SetPostingTables_R4011B_FreeStocks());
	QueryArray.Add(SetPostingTables_R4017B_InternalSupplyRequestProcurement());
	QueryArray.Add(SetPostingTables_R4033B_GoodsReceiptSchedule());
	QueryArray.Add(SetPostingTables_R4050B_StockInventory());
	Return QueryArray;
EndFunction

Function SetItemListVT()

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
		|	NOT PurchaseInvoiceItemList.PurchaseOrder = Value(Document.PurchaseOrder.EmptyRef) AS UsePurchaseOrder,
		|	NOT PurchaseInvoiceItemList.SalesOrder = Value(Document.SalesOrder.EmptyRef) AS UseSalesOrder,
		| 	NOT PurchaseInvoiceItemList.InternalSupplyRequest = Value(Document.InternalSupplyRequest.EmptyRef) AS UseInternalSupplyRequest,
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
		|INTO DocData
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
		|	PurchaseInvoiceTaxList.Amount + PurchaseInvoiceTaxList.ManualAmount AS TaxAmount,
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

Function SetPostingTables_R1001T_Purchases()
	Return
		"SELECT *
		|INTO R1001T_Purchases
		|FROM
		|	DocData AS QueryTable
		|WHERE TRUE";

EndFunction

Function SetPostingTables_R1005T_PurchaseSpecialOffers()
	Return
		"SELECT *
		|INTO R1005T_PurchaseSpecialOffers
		|FROM
		|	OffersInfo AS QueryTable
		|WHERE TRUE";

EndFunction

Function SetPostingTables_R1011B_PurchaseOrdersReceipt()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	QueryTable.PurchaseOrder AS Order,
		|	*
		|INTO R1011B_PurchaseOrdersReceipt
		|FROM
		|	DocData AS QueryTable
		|WHERE NOT QueryTable.UseGoodsReceipt AND QueryTable.UsePurchaseOrder";

EndFunction

Function SetPostingTables_R1012B_PurchaseOrdersInvoiceClosing()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	QueryTable.PurchaseOrder AS Order,
		|	*
		|INTO R1012B_PurchaseOrdersInvoiceClosing
		|FROM
		|	DocData AS QueryTable
		|WHERE QueryTable.UsePurchaseOrder";

EndFunction

Function SetPostingTables_R1020B_AdvancesToVendors()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	*
		|INTO R1020B_AdvancesToVendors
		|FROM
		|	DocData AS QueryTable
		|WHERE FALSE";

EndFunction

Function SetPostingTables_R1021B_VendorsTransactions()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R1021B_VendorsTransactions
		|FROM
		|	DocData AS QueryTable
		|WHERE FALSE";

EndFunction

Function SetPostingTables_R1031B_ReceiptInvoicing()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	QueryTable.Invoice AS Basis,
		|	QueryTable.Quantity AS Quantity,
		|	QueryTable.Company,
		|	QueryTable.Period,
		|	QueryTable.ItemKey
		|INTO R1031B_ReceiptInvoicing
		|FROM
		|	DocData AS QueryTable
		|WHERE QueryTable.UseGoodsReceipt AND NOT QueryTable.GoodsReceiptExists
		|
		|UNION ALL
		|
		|SELECT 
		|	VALUE(AccumulationRecordType.Expense),
		|	GoodsReceipts.GoodsReceipt,
		|	GoodsReceipts.Quantity,
		|	QueryTable.Company,
		|	QueryTable.Period,
		|	QueryTable.ItemKey
		|FROM
		|	DocData AS QueryTable
		|		INNER JOIN GoodReceiptInfo AS GoodsReceipts
		|		ON QueryTable.RowKey = GoodsReceipts.Key
		|WHERE TRUE";

EndFunction

Function SetPostingTables_R1040B_TaxesOutgoing()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R1040B_TaxesOutgoing
		|FROM
		|	Taxes AS QueryTable
		|WHERE TRUE";

EndFunction

Function SetPostingTables_R2013T_SalesOrdersProcurement()
	Return
		"SELECT
		|	QueryTable.Quantity AS PurchaseQuantity,
		|	QueryTable.SalesOrder AS Order,
		|	*
		|INTO R2013T_SalesOrdersProcurement
		|FROM
		|	DocData AS QueryTable
		|WHERE
		|	NOT QueryTable.IsService
		|	AND NOT QueryTable.SalesOrder = Value(Document.SalesOrder.EmptyRef)";

EndFunction

Function SetPostingTables_R4010B_ActualStocks()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R4010B_ActualStocks
		|FROM
		|	DocData AS QueryTable
		|WHERE NOT QueryTable.IsService AND NOT QueryTable.UseGoodsReceipt";

EndFunction

Function SetPostingTables_R4011B_FreeStocks()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R4011B_FreeStocks
		|FROM
		|	DocData AS QueryTable
		|WHERE  NOT QueryTable.IsService AND NOT QueryTable.UseGoodsReceipt";

EndFunction

Function SetPostingTables_R4017B_InternalSupplyRequestProcurement()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	*
		|INTO R4017B_InternalSupplyRequestProcurement
		|FROM
		|	DocData AS QueryTable
		|WHERE NOT QueryTable.IsService
		|	AND NOT QueryTable.InternalSupplyRequest = Value(Document.InternalSupplyRequest.EmptyRef)";

EndFunction

Function SetPostingTables_R4033B_GoodsReceiptSchedule()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	QueryTable.PurchaseOrder AS Basis,
		|*
		|
		|INTO R4033B_GoodsReceiptSchedule
		|FROM
		|	DocData AS QueryTable
		|WHERE NOT QueryTable.IsService
		|	AND NOT QueryTable.UseGoodsReceipt AND QueryTable.UsePurchaseOrder";

EndFunction

Function SetPostingTables_R4050B_StockInventory()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType, 
		|	*
		|INTO R4050B_StockInventory
		|FROM
		|	DocData AS QueryTable
		|WHERE NOT QueryTable.IsService";

EndFunction

#EndRegion