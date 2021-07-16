#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();	
	Parameters.IsReposting = False;	
#Region NewRegistersPosting	
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	Tables.Insert("VendorsTransactions", 
	PostingServer.GetQueryTableByName("VendorsTransactions", Parameters));	
#EndRegion			
	
	Return Tables;
EndFunction

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
	
	Parameters.Insert("ConsiderStocksRequested", True);
	IncomingStocksServer.ClosureIncomingStocks(Parameters);
	
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
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
	IncomingStocksServer.ClosureIncomingStocks_Unposting(Parameters);
	
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
	
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.PurchaseInvoice.ItemList", AddInfo);
	
	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref, "Document.PurchaseInvoice.ItemList");
	If Not Cancel And Not AccReg.R4035B_IncomingStocks.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
	                                                                PostingServer.GetQueryTableByName("R4035B_IncomingStocks", Parameters),
	                                                                PostingServer.GetQueryTableByName("Exists_R4035B_IncomingStocks", Parameters),
	                                                                AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
	
	If Not Cancel And Not AccReg.R4036B_IncomingStocksRequested.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
	                                                                PostingServer.GetQueryTableByName("R4036B_IncomingStocksRequested", Parameters),
	                                                                PostingServer.GetQueryTableByName("Exists_R4036B_IncomingStocksRequested", Parameters),
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
	QueryArray.Add(SerialLotNumbers());
	QueryArray.Add(IncomingStocksReal());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	QueryArray.Add(Exists_R4035B_IncomingStocks());
	QueryArray.Add(Exists_R4036B_IncomingStocksRequested());
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
	QueryArray.Add(R5012B_VendorsAging());
	QueryArray.Add(R1031B_ReceiptInvoicing());
	QueryArray.Add(R1040B_TaxesOutgoing());
	QueryArray.Add(R2013T_SalesOrdersProcurement());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4012B_StockReservation());
	QueryArray.Add(R4014B_SerialLotNumber());
	QueryArray.Add(R4017B_InternalSupplyRequestProcurement());
	QueryArray.Add(R4031B_GoodsInTransitIncoming());
	QueryArray.Add(R4033B_GoodsReceiptSchedule());
	QueryArray.Add(R4050B_StockInventory());
	QueryArray.Add(R4035B_IncomingStocks());
	QueryArray.Add(R4036B_IncomingStocksRequested());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R1022B_VendorsPaymentPlanning());
	QueryArray.Add(T1001I_PartnerTransactions());
	QueryArray.Add(R5022T_Expenses());
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
	|	Document.PurchaseInvoice.RowIDInfo AS RowIDInfo
	|WHERE
	|	RowIDInfo.Ref = &Ref
	|GROUP BY
	|	RowIDInfo.Ref,
	|	RowIDInfo.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
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
	|	TableRowIDInfo.RowID AS RowKey,
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
	|		INNER JOIN TableRowIDInfo AS TableRowIDInfo
	|		ON PurchaseInvoiceItemList.Key = TableRowIDInfo.Key
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
	|	TableRowIDInfo.RowID AS RowKey,
	|	PurchaseInvoiceItemList.AdditionalAnalytic AS AdditionalAnalytic,
	|	PurchaseInvoiceItemList.BusinessUnit AS BusinessUnit,
	|	PurchaseInvoiceItemList.ExpenseType AS ExpenseType,
	|	PurchaseInvoiceItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
	|	PurchaseInvoiceItemList.DeliveryDate AS DeliveryDate,
	|	PurchaseInvoiceItemList.NetAmount AS NetAmount,
	|	PurchaseInvoiceItemList.Ref.IgnoreAdvances AS IgnoreAdvances,
	|	PurchaseInvoiceItemList.Key
	|INTO ItemList
	|FROM
	|	Document.PurchaseInvoice.ItemList AS PurchaseInvoiceItemList
	|		LEFT JOIN GoodsReceipts AS GoodsReceipts
	|		ON PurchaseInvoiceItemList.Key = GoodsReceipts.Key
	|		LEFT JOIN TableRowIDInfo AS TableRowIDInfo
	|		ON PurchaseInvoiceItemList.Key = TableRowIDInfo.Key
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
		|		AND ItemList.Ref = &Ref
		|WHERE
		|	SerialLotNumbers.Ref = &Ref";	
EndFunction	

Function IncomingStocksReal()
	Return	
		"SELECT
		|	ItemList.Period,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	ItemList.PurchaseOrder AS Order,
		|	ItemList.Quantity
		|INTO IncomingStocksReal
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|	AND NOT ItemList.UseGoodsReceipt
		|	AND NOT ItemList.GoodsReceiptExists";
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
		|	OffsetOfAdvances.AdvancesDocument AS Basis,
		|	OffsetOfAdvances.Recorder AS VendorsAdvancesClosing,
		|	*
		|INTO R1020B_AdvancesToVendors
		|FROM
		|	InformationRegister.T1000I_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref";
EndFunction

Function R1021B_VendorsTransactions()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Currency,
		|	ItemList.LegalName,
		|	ItemList.Partner,
		|	ItemList.Agreement,
		|	ItemList.BasisDocument AS Basis,
		|	SUM(ItemList.Amount) AS Amount,
		|	UNDEFINED AS VendorsAdvancesClosing
		|INTO R1021B_VendorsTransactions
		|FROM
		|	ItemList AS ItemList
		|GROUP BY
		|	ItemList.Agreement,
		|	ItemList.BasisDocument,
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

Function R5012B_VendorsAging()
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
		|	SUM(PaymentTerms.Amount) AS Amount,
		|	UNDEFINED AS AgingClosing
		|INTO R5012B_VendorsAging
		|FROM
		|	Document.PurchaseInvoice.PaymentTerms AS PaymentTerms
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
		|	VALUE(AccumulationRecordType.Receipt)
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
		|	OffsetOfAging.Amount,
		|	OffsetOfAging.Recorder
		|FROM
		|	InformationRegister.T1003I_OffsetOfAging AS OffsetOfAging
		|WHERE
		|	OffsetOfAging.Document = &Ref";
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
		|	ItemList.BasisDocument AS TransactionDocument,
		|	TRUE AS IsVendorTransaction,
		|	SUM(ItemList.Amount) AS Amount,
		|	ItemList.Key
		|INTO T1001I_PartnerTransactions
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IgnoreAdvances
		|GROUP BY
		|	ItemList.Agreement,
		|	ItemList.BasisDocument,
		|	ItemList.Company,
		|	ItemList.Currency,
		|	ItemList.Key,
		|	ItemList.LegalName,
		|	ItemList.Partner,
		|	ItemList.Period";
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
		|	AND NOT ItemList.IsService
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
		|		ON ItemList.Key = GoodsReceipts.Key
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
		|	FreeStocks AS FreeStocks
		|WHERE
		|	TRUE";

EndFunction

Function R4012B_StockReservation()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	IncomingStocksRequested.Period,
		|	IncomingStocksRequested.IncomingStore AS Store,
		|	IncomingStocksRequested.ItemKey,
		|	IncomingStocksRequested.Requester AS Order,
		|	IncomingStocksRequested.Quantity
		|INTO R4012B_StockReservation
		|FROM
		|	IncomingStocksRequested
		|WHERE
		|	TRUE";
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

Function R4031B_GoodsInTransitIncoming()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	CASE
		|		WHEN ItemList.GoodsReceiptExists
		|			Then GoodsReceipts.GoodsReceipt
		|		Else ItemList.Invoice
		|	End AS Basis,
		|	CASE 
		|		WHEN ItemList.GoodsReceiptExists
		|			Then GoodsReceipts.Quantity
		|		Else ItemList.Quantity
		|	End AS Quantity,
		|	*
		|INTO R4031B_GoodsInTransitIncoming
		|FROM
		|	ItemList AS ItemList
		|		LEFT JOIN GoodReceiptInfo AS GoodsReceipts
		|		ON ItemList.Key = GoodsReceipts.Key
		|WHERE
		|	NOT ItemList.IsService
		|	AND (ItemList.UseGoodsReceipt
		|		OR ItemList.GoodsReceiptExists)";

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

Function Exists_R4035B_IncomingStocks()
	Return
		"SELECT *
		|	INTO Exists_R4035B_IncomingStocks
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

Function R1022B_VendorsPaymentPlanning()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PurchaseInvoicePaymentTerms.Ref.Date AS Period,
		|	PurchaseInvoicePaymentTerms.Ref.Company AS Company,
		|	PurchaseInvoicePaymentTerms.Ref AS Basis,
		|	PurchaseInvoicePaymentTerms.Ref.LegalName AS LegalName,
		|	PurchaseInvoicePaymentTerms.Ref.Partner AS Partner,
		|	PurchaseInvoicePaymentTerms.Ref.Agreement AS Agreement,
		|	SUM(PurchaseInvoicePaymentTerms.Amount) AS Amount
		|INTO R1022B_VendorsPaymentPlanning
		|FROM
		|	Document.PurchaseInvoice.PaymentTerms AS PurchaseInvoicePaymentTerms
		|WHERE
		|	PurchaseInvoicePaymentTerms.Ref = &Ref
		|	AND PurchaseInvoicePaymentTerms.CalculationType = VALUE(Enum.CalculationTypes.PostShipmentCredit)
		|GROUP BY
		|	PurchaseInvoicePaymentTerms.Ref.Date,
		|	PurchaseInvoicePaymentTerms.Ref.Company,
		|	PurchaseInvoicePaymentTerms.Ref,
		|	PurchaseInvoicePaymentTerms.Ref.LegalName,
		|	PurchaseInvoicePaymentTerms.Ref.Partner,
		|	PurchaseInvoicePaymentTerms.Ref.Agreement,
		|	VALUE(AccumulationRecordType.Receipt)";
EndFunction

Function Exists_R4036B_IncomingStocksRequested()
	Return
		"SELECT
		|	*
		|INTO Exists_R4036B_IncomingStocksRequested
		|FROM
		|	AccumulationRegister.R4036B_IncomingStocksRequested AS R4036B_IncomingStocksRequested
		|WHERE
		|	R4036B_IncomingStocksRequested.Recorder = &Ref";
EndFunction

Function R5022T_Expenses()
	Return
		"SELECT
		|	*,
		|	ItemList.NetAmount AS Amount
		|INTO R5022T_Expenses
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsService";
EndFunction

#EndRegion
