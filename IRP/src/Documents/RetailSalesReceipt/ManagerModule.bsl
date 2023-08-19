#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);

//#2093
//	Query = New Query;
//	Query.Text =
//	"SELECT
//	|	ItemList.Key AS Key,
//	|	ItemList.InventoryOrigin AS InventoryOrigin,
//	|	ItemList.Ref.Company AS Company,
//	|	ItemList.ItemKey AS ItemKey,
//	|	ItemList.Store AS Store,
//	|	ItemList.QuantityInBaseUnit AS Quantity
//	|INTO tmpItemList
//	|FROM
//	|	Document.RetailSalesReceipt.ItemList AS ItemList
//	|WHERE
//	|	ItemList.Ref = &Ref
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|SELECT
//	|	SerialLotNumbers.Key,
//	|	SerialLotNumbers.SerialLotNumber,
//	|	SerialLotNumbers.Quantity
//	|INTO tmpSerialLotNumbers
//	|FROM
//	|	Document.RetailSalesReceipt.SerialLotNumbers AS SerialLotNumbers
//	|WHERE
//	|	SerialLotNumbers.Ref = &Ref
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|SELECT
//	|	SourceOfOrigins.Key,
//	|	SourceOfOrigins.SerialLotNumber,
//	|	SourceOfOrigins.SourceOfOrigin,
//	|	SourceOfOrigins.Quantity
//	|INTO tmpSourceOfOrigins
//	|FROM
//	|	Document.RetailSalesReceipt.SourceOfOrigins AS SourceOfOrigins
//	|WHERE
//	|	SourceOfOrigins.Ref = &Ref
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|SELECT
//	|	tmpItemList.Key,
//	|	tmpItemList.InventoryOrigin,
//	|	tmpItemList.Company,
//	|	tmpItemList.ItemKey,
//	|	tmpItemList.Store,
//	|	CASE
//	|		WHEN tmpSerialLotNumbers.SerialLotNumber.Ref IS NULL
//	|			THEN tmpItemList.Quantity
//	|		ELSE tmpSerialLotNumbers.Quantity
//	|	END AS Quantity,
//	|	ISNULL(tmpSerialLotNumbers.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber
//	|INTO tmpItemList_1
//	|FROM
//	|	tmpItemList AS tmpItemList
//	|		LEFT JOIN tmpSerialLotNumbers AS tmpSerialLotNumbers
//	|		ON tmpItemList.Key = tmpSerialLotNumbers.Key
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|SELECT
//	|	tmpItemList_1.Key,
//	|	tmpItemList_1.InventoryOrigin,
//	|	tmpItemList_1.Company,
//	|	tmpItemList_1.ItemKey,
//	|	tmpItemList_1.Store,
//	|	tmpItemList_1.SerialLotNumber,
//	|	CASE
//	|		WHEN ISNULL(tmpSourceOfOrigins.Quantity, 0) <> 0
//	|			THEN ISNULL(tmpSourceOfOrigins.Quantity, 0)
//	|		ELSE tmpItemList_1.Quantity
//	|	END AS Quantity,
//	|	ISNULL(tmpSourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)) AS SourceOfOrigin
//	|FROM
//	|	tmpItemList_1 AS tmpItemList_1
//	|		LEFT JOIN tmpSourceOfOrigins AS tmpSourceOfOrigins
//	|		ON tmpItemList_1.Key = tmpSourceOfOrigins.Key
//	|		AND tmpItemList_1.SerialLotNumber = tmpSourceOfOrigins.SerialLotNumber";
//
//	Query.SetParameter("Ref", Ref);
//	QueryResult = Query.Execute();
//	ItemListTable = QueryResult.Unload();

//#2093
//	Query = New Query;
//	Query.Text =
//	"SELECT
//	|	ConsignorBatches.Key,
//	|	ConsignorBatches.ItemKey,
//	|	ConsignorBatches.SerialLotNumber,
//	|	ConsignorBatches.SourceOfOrigin,
//	|	ConsignorBatches.Store,
//	|	ConsignorBatches.Batch,
//	|	ConsignorBatches.Quantity
//	|FROM
//	|	Document.RetailSalesReceipt.ConsignorBatches AS ConsignorBatches
//	|WHERE
//	|	ConsignorBatches.Ref = &Ref";
//	Query.SetParameter("Ref", Ref);
//	QueryResult = Query.Execute();
//	ConsignorBatches = QueryResult.Unload();
//
//	ConsignorBatches = CommissionTradeServer.GetRegistrateConsignorBatches(Parameters.Object, ItemListTable,
//		ConsignorBatches);
//
//	Query = New Query;
//	Query.TempTablesManager = Parameters.TempTablesManager;
//	Query.Text = "SELECT * INTO ConsignorBatches FROM &T1 AS T1";
//	Query.SetParameter("T1", ConsignorBatches);
//	Query.Execute();

	BatchKeysInfoMetadata = Parameters.Object.RegisterRecords.T6020S_BatchKeysInfo.Metadata();
	If Parameters.Property("MultiCurrencyExcludePostingDataTables") Then
		Parameters.MultiCurrencyExcludePostingDataTables.Add(BatchKeysInfoMetadata);
	Else
		ArrayOfMultiCurrencyExcludePostingDataTables = New Array;
		ArrayOfMultiCurrencyExcludePostingDataTables.Add(BatchKeysInfoMetadata);
		Parameters.Insert("MultiCurrencyExcludePostingDataTables", ArrayOfMultiCurrencyExcludePostingDataTables);
	EndIf;

	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map;
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
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
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
	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref,
		"Document.RetailSalesReceipt.ItemList");

	CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo);

	If Not Cancel And Not AccReg.R4014B_SerialLotNumber.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R4014B_SerialLotNumber", Parameters), PostingServer.GetQueryTableByName(
		"Exists_R4014B_SerialLotNumber", Parameters), AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("RecordType", AccumulationRecordType.Expense);
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.RetailSalesReceipt.ItemList", AddInfo);
EndProcedure

#EndRegion

#Region Posting_Info

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure;
	StrParams.Insert("Ref", Ref);
	If ValueIsFilled(Ref) Then
		StrParams.Insert("BalancePeriod", New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	Else
		StrParams.Insert("BalancePeriod", Undefined);
	EndIf;
	Return StrParams;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(Payments());
	QueryArray.Add(RetailSales());
	QueryArray.Add(OffersInfo());
	QueryArray.Add(SerialLotNumbers());
	QueryArray.Add(SourceOfOrigins());
	QueryArray.Add(PaymentAgent());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	QueryArray.Add(PostingServer.Exists_R4014B_SerialLotNumber());
	Return QueryArray;
EndFunction

Function ItemList()
	Return "SELECT
		   |	RowIDInfo.Ref AS Ref,
		   |	RowIDInfo.Key AS Key,
		   |	MAX(RowIDInfo.RowID) AS RowID
		   |INTO TableRowIDInfo
		   |FROM
		   |	Document.RetailSalesReceipt.RowIDInfo AS RowIDInfo
		   |WHERE
		   |	RowIDInfo.Ref = &Ref
		   |GROUP BY
		   |	RowIDInfo.Ref,
		   |	RowIDInfo.Key
		   |;
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	ShipmentConfirmations.Key AS Key
		   |INTO ShipmentConfirmations
		   |FROM
		   |	Document.RetailSalesReceipt.ShipmentConfirmations AS ShipmentConfirmations
		   |WHERE
		   |	ShipmentConfirmations.Ref = &Ref
		   |GROUP BY
		   |	ShipmentConfirmations.Key
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	ItemList.Ref.Company AS Company,
		   |	ItemList.Store AS Store,
		   |	NOT ShipmentConfirmations.Key IS NULL AS ShipmentConfirmationExists,
		   |	ItemList.ItemKey AS ItemKey,
		   |	ItemList.QuantityInBaseUnit AS Quantity,
		   |	ItemList.TotalAmount AS TotalAmount,
		   |	ItemList.Ref.Partner AS Partner,
		   |	ItemList.Ref.LegalName AS LegalName,
		   |	CASE
		   |		WHEN ItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		   |		AND ItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		   |			THEN ItemList.Ref.Agreement.StandardAgreement
		   |		ELSE ItemList.Ref.Agreement
		   |	END AS Agreement,
		   |	ItemList.Ref.Currency AS Currency,
		   |	ItemList.Ref.Date AS Period,
		   |	ItemList.Ref AS RetailSalesReceipt,
		   |	ItemList.IsService AS IsService,
		   |	ItemList.ProfitLossCenter AS ProfitLossCenter,
		   |	ItemList.RevenueType AS RevenueType,
		   |	ItemList.AdditionalAnalytic AS AdditionalAnalytic,
		   |	CASE
		   |		WHEN ItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		   |			THEN ItemList.Ref
		   |		ELSE UNDEFINED
		   |	END AS BasisDocument,
		   |	ItemList.NetAmount AS NetAmount,
		   |	ItemList.OffersAmount AS OffersAmount,
		   |	ItemList.Ref AS Invoice,
		   |	ItemList.SalesOrder AS SalesOrder,
		   |	NOT ItemList.SalesOrder.Ref IS NULL AS SalesOrderExists,
		   |	ItemList.Key AS RowKey,
		   |	ItemList.Ref.UsePartnerTransactions AS UsePartnerTransactions,
		   |	ItemList.Ref.Branch AS Branch,
		   |	ItemList.Ref.LegalNameContract AS LegalNameContract,
		   |	ItemList.SalesPerson,
		   |	ItemList.Key,
		   |	ItemList.Unit,
		   |	ItemList.Price,
		   |	ItemList.PriceType,
		   |	ItemList.Ref.PriceIncludeTax AS PriceIncludeTax,
		   |	ItemList.InventoryOrigin = VALUE(Enum.InventoryOriginTypes.OwnStocks) AS IsOwnStocks,
		   |	ItemList.InventoryOrigin = VALUE(Enum.InventoryOriginTypes.ConsignorStocks) AS IsConsignorStocks,
		   |	ItemList.InventoryOrigin AS InventoryOrigin,
		   |	TableRowIDInfo.RowID AS RowID
		   |INTO ItemList
		   |FROM
		   |	Document.RetailSalesReceipt.ItemList AS ItemList
		   |		LEFT JOIN ShipmentConfirmations AS ShipmentConfirmations
		   |		ON ItemList.Key = ShipmentConfirmations.Key 
		   |		LEFT JOIN TableRowIDInfo AS TableRowIDInfo
		   |		ON ItemList.Key = TableRowIDInfo.Key
		   |WHERE
		   |	ItemList.Ref = &Ref
		   |;
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	ShipmentConfirmations.Key,
		   |	ShipmentConfirmations.ShipmentConfirmation,
		   |	ShipmentConfirmations.Quantity
		   |INTO ShipmentConfirmationsInfo
		   |FROM
		   |	Document.RetailSalesReceipt.ShipmentConfirmations AS ShipmentConfirmations
		   |WHERE
		   |	ShipmentConfirmations.Ref = &Ref";
EndFunction

Function Payments()
	Return "SELECT
		   |	Payments.Ref.Date AS Period,
		   |	Payments.Ref.Company AS Company,
		   |	Payments.Ref.Branch AS Branch,
		   |	Payments.Ref.RetailCustomer AS RetailCustomer,
		   |	Payments.Account AS Account,
		   |	Payments.Ref.Currency AS Currency,
		   |	Payments.Amount AS Amount,
		   |	Payments.PaymentType AS PaymentType,
		   |	Payments.FinancialMovementType AS FinancialMovementType,
		   |	Payments.PaymentTerminal AS PaymentTerminal,
		   |	Payments.BankTerm AS BankTerm,
		   |	Payments.Percent AS Percent,
		   |	Payments.Commission AS Commission,
		   |	Payments.PaymentType.Type = VALUE(Enum.PaymentTypes.Advance) AS IsAdvance,
		   |	Payments.PaymentType.Type = VALUE(Enum.PaymentTypes.PaymentAgent) AS IsPaymentAgent
		   |INTO Payments
		   |FROM
		   |	Document.RetailSalesReceipt.Payments AS Payments
		   |WHERE
		   |	Payments.Ref = &Ref";
EndFunction

Function RetailSales()
	Return "SELECT
		   |	RetailSalesReceiptItemList.Ref.Company AS Company,
		   |	RetailSalesReceiptItemList.Ref.Branch AS Branch,
		   |	RetailSalesReceiptItemList.ItemKey AS ItemKey,
		   |	SUM(RetailSalesReceiptItemList.QuantityInBaseUnit) AS Quantity,
		   |	SUM(ISNULL(RetailSalesReceiptSerialLotNumbers.Quantity, 0)) AS QuantityBySerialLtNumbers,
		   |	RetailSalesReceiptItemList.Ref.Date AS Period,
		   |	RetailSalesReceiptItemList.Ref AS RetailSalesReceipt,
		   |	SUM(RetailSalesReceiptItemList.TotalAmount) AS Amount,
		   |	SUM(RetailSalesReceiptItemList.NetAmount) AS NetAmount,
		   |	SUM(RetailSalesReceiptItemList.OffersAmount) AS OffersAmount,
		   |	RetailSalesReceiptItemList.Key AS RowKey,
		   |	RetailSalesReceiptSerialLotNumbers.SerialLotNumber AS SerialLotNumber,
		   |	RetailSalesReceiptItemList.Store,
		   |	RetailSalesReceiptItemList.SalesPerson
		   |INTO tmpRetailSales
		   |FROM
		   |	Document.RetailSalesReceipt.ItemList AS RetailSalesReceiptItemList
		   |		LEFT JOIN Document.RetailSalesReceipt.SerialLotNumbers AS RetailSalesReceiptSerialLotNumbers
		   |		ON RetailSalesReceiptItemList.Key = RetailSalesReceiptSerialLotNumbers.Key
		   |		AND RetailSalesReceiptItemList.Ref = RetailSalesReceiptSerialLotNumbers.Ref
		   |		AND RetailSalesReceiptItemList.Ref = &Ref
		   |		AND RetailSalesReceiptSerialLotNumbers.Ref = &Ref
		   |WHERE
		   |	RetailSalesReceiptItemList.Ref = &Ref
		   |GROUP BY
		   |	RetailSalesReceiptItemList.Ref.Company,
		   |	RetailSalesReceiptItemList.Ref.Branch,
		   |	RetailSalesReceiptItemList.ItemKey,
		   |	RetailSalesReceiptItemList.Ref.Date,
		   |	RetailSalesReceiptItemList.Ref,
		   |	RetailSalesReceiptItemList.Key,
		   |	RetailSalesReceiptSerialLotNumbers.SerialLotNumber,
		   |	RetailSalesReceiptItemList.Store,
		   |	RetailSalesReceiptItemList.SalesPerson
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	tmpRetailSales.Company AS Company,
		   |	tmpRetailSales.Branch AS Branch,
		   |	tmpRetailSales.ItemKey AS ItemKey,
		   |	CASE
		   |		WHEN tmpRetailSales.QuantityBySerialLtNumbers = 0
		   |			THEN tmpRetailSales.Quantity
		   |		ELSE tmpRetailSales.QuantityBySerialLtNumbers
		   |	END AS Quantity,
		   |	tmpRetailSales.Period AS Period,
		   |	tmpRetailSales.RetailSalesReceipt AS RetailSalesReceipt,
		   |	tmpRetailSales.RowKey AS RowKey,
		   |	tmpRetailSales.SerialLotNumber AS SerialLotNumber,
		   |	CASE
		   |		WHEN tmpRetailSales.QuantityBySerialLtNumbers <> 0
		   |			THEN CASE
		   |				WHEN tmpRetailSales.Quantity = 0
		   |					THEN 0
		   |				ELSE tmpRetailSales.Amount / tmpRetailSales.Quantity * tmpRetailSales.QuantityBySerialLtNumbers
		   |			END
		   |		ELSE tmpRetailSales.Amount
		   |	END AS Amount,
		   |	CASE
		   |		WHEN tmpRetailSales.QuantityBySerialLtNumbers <> 0
		   |			THEN CASE
		   |				WHEN tmpRetailSales.Quantity = 0
		   |					THEN 0
		   |				ELSE tmpRetailSales.NetAmount / tmpRetailSales.Quantity * tmpRetailSales.QuantityBySerialLtNumbers
		   |			END
		   |		ELSE tmpRetailSales.NetAmount
		   |	END AS NetAmount,
		   |	CASE
		   |		WHEN tmpRetailSales.QuantityBySerialLtNumbers <> 0
		   |			THEN CASE
		   |				WHEN tmpRetailSales.Quantity = 0
		   |					THEN 0
		   |				ELSE tmpRetailSales.OffersAmount / tmpRetailSales.Quantity * tmpRetailSales.QuantityBySerialLtNumbers
		   |			END
		   |		ELSE tmpRetailSales.OffersAmount
		   |	END AS OffersAmount,
		   |	tmpRetailSales.Store,
		   |	tmpRetailSales.SalesPerson
		   |INTO RetailSales
		   |FROM
		   |	tmpRetailSales AS tmpRetailSales";
EndFunction

Function OffersInfo()
	Return "SELECT
		   |	RetailSalesReceiptItemList.Ref.Date AS Period,
		   |	RetailSalesReceiptItemList.Ref AS Invoice,
		   |	TableRowIDInfo.RowID AS RowKey,
		   |	RetailSalesReceiptItemList.ItemKey,
		   |	RetailSalesReceiptItemList.Ref.Company AS Company,
		   |	RetailSalesReceiptItemList.Ref.Currency,
		   |	RetailSalesReceiptSpecialOffers.Offer AS SpecialOffer,
		   |	RetailSalesReceiptSpecialOffers.Amount AS OffersAmount,
		   |	RetailSalesReceiptSpecialOffers.Bonus AS OffersBonus,
		   |	RetailSalesReceiptSpecialOffers.AddInfo AS OffersAddInfo,
		   |	RetailSalesReceiptItemList.TotalAmount AS SalesAmount,
		   |	RetailSalesReceiptItemList.NetAmount AS NetAmount,
		   |	RetailSalesReceiptItemList.Ref.Branch AS Branch
		   |INTO OffersInfo
		   |FROM
		   |	Document.RetailSalesReceipt.ItemList AS RetailSalesReceiptItemList
		   |		INNER JOIN Document.RetailSalesReceipt.SpecialOffers AS RetailSalesReceiptSpecialOffers
		   |		ON RetailSalesReceiptItemList.Key = RetailSalesReceiptSpecialOffers.Key
		   |		AND RetailSalesReceiptItemList.Ref = &Ref
		   |		AND RetailSalesReceiptSpecialOffers.Ref = &Ref
		   |		INNER JOIN TableRowIDInfo AS TableRowIDInfo
		   |		ON RetailSalesReceiptItemList.Key = TableRowIDInfo.Key";
EndFunction

Function SerialLotNumbers()
	Return "SELECT
		   |	SerialLotNumbers.Ref.Date AS Period,
		   |	SerialLotNumbers.Ref.Company AS Company,
		   |	SerialLotNumbers.Ref.Branch AS Branch,
		   |	SerialLotNumbers.Key,
		   |	SerialLotNumbers.SerialLotNumber,
		   |	SerialLotNumbers.SerialLotNumber.StockBalanceDetail AS StockBalanceDetail,
		   |	SerialLotNumbers.Quantity,
		   |	ItemList.ItemKey AS ItemKey
		   |INTO SerialLotNumbers
		   |FROM
		   |	Document.RetailSalesReceipt.SerialLotNumbers AS SerialLotNumbers
		   |		LEFT JOIN Document.RetailSalesReceipt.ItemList AS ItemList
		   |		ON SerialLotNumbers.Key = ItemList.Key
		   |		AND ItemList.Ref = &Ref
		   |WHERE
		   |	SerialLotNumbers.Ref = &Ref";
EndFunction

Function SourceOfOrigins()
	Return "SELECT
		   |	SourceOfOrigins.Key AS Key,
		   |	CASE
		   |		WHEN SourceOfOrigins.SerialLotNumber.BatchBalanceDetail
		   |			THEN SourceOfOrigins.SerialLotNumber
		   |		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		   |	END AS SerialLotNumber,
		   |	CASE
		   |		WHEN SourceOfOrigins.SourceOfOrigin.BatchBalanceDetail
		   |			THEN SourceOfOrigins.SourceOfOrigin
		   |		ELSE VALUE(Catalog.SourceOfOrigins.EmptyRef)
		   |	END AS SourceOfOrigin,
		   |	SourceOfOrigins.SourceOfOrigin AS SourceOfOriginStock,
		   |	SourceOfOrigins.SerialLotNumber AS SerialLotNumberStock,
		   |	SUM(SourceOfOrigins.Quantity) AS Quantity
		   |INTO SourceOfOrigins
		   |FROM
		   |	Document.RetailSalesReceipt.SourceOfOrigins AS SourceOfOrigins
		   |WHERE
		   |	SourceOfOrigins.Ref = &Ref
		   |GROUP BY
		   |	SourceOfOrigins.Key,
		   |	CASE
		   |		WHEN SourceOfOrigins.SerialLotNumber.BatchBalanceDetail
		   |			THEN SourceOfOrigins.SerialLotNumber
		   |		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		   |	END,
		   |	CASE
		   |		WHEN SourceOfOrigins.SourceOfOrigin.BatchBalanceDetail
		   |			THEN SourceOfOrigins.SourceOfOrigin
		   |		ELSE VALUE(Catalog.SourceOfOrigins.EmptyRef)
		   |	END,
		   |	SourceOfOrigins.SourceOfOrigin,
		   |	SourceOfOrigins.SerialLotNumber";
EndFunction

Function PaymentAgent()
	Return "SELECT
		   |	Payments.Ref.Date AS Period,
		   |	Payments.Ref.Company AS Company,
		   |	Payments.Ref.Branch AS Branch,
		   |	Payments.Ref.Currency AS Currency,
		   |	Payments.PaymentAgentLegalName AS LegalName,
		   |	Payments.PaymentAgentPartner AS Partner,
		   |	Payments.PaymentAgentPartnerTerms AS Agreement,
		   |	CASE
		   |		WHEN Payments.PaymentAgentPartnerTerms.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		   |			THEN Payments.Ref
		   |		ELSE UNDEFINED
		   |	END AS Basis,
		   |	UNDEFINED AS Order,
		   |	Payments.Amount AS Amount,
		   |	UNDEFINED AS CustomersAdvancesClosing,
		   |	Payments.PaymentAgentLegalNameContract AS LegalNameContract
		   |INTO PaymentAgent
		   |FROM
		   |	Document.RetailSalesReceipt.Payments AS Payments
		   |WHERE
		   |	Payments.PaymentType.Type = VALUE(Enum.PaymentTypes.PaymentAgent)
		   |	AND Payments.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R2001T_Sales());
	QueryArray.Add(R2005T_SalesSpecialOffers());
	QueryArray.Add(R2012B_SalesOrdersInvoiceClosing());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R2023B_AdvancesFromRetailCustomers());
	QueryArray.Add(R2050T_RetailSales());
	QueryArray.Add(R3010B_CashOnHand());
	QueryArray.Add(R3011T_CashFlow());
	QueryArray.Add(R3050T_PosCashBalances());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4012B_StockReservation());
	QueryArray.Add(R4014B_SerialLotNumber());
	QueryArray.Add(R4032B_GoodsInTransitOutgoing());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5021T_Revenues());
	//#2093
	//QueryArray.Add(R8012B_ConsignorInventory());
	//#2093
	//QueryArray.Add(R8013B_ConsignorBatchWiseBalance());
	//#2093 ???????
	//QueryArray.Add(R8014T_ConsignorSales());
	QueryArray.Add(R9010B_SourceOfOriginStock());
	QueryArray.Add(T1050T_AccountingQuantities());
	QueryArray.Add(T2015S_TransactionsInfo());
	QueryArray.Add(T3010S_RowIDInfo());
	QueryArray.Add(T6020S_BatchKeysInfo());
	QueryArray.Add(R5015B_OtherPartnersTransactions());
	Return QueryArray;
EndFunction

Function R2023B_AdvancesFromRetailCustomers()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	Payments.Period,
		   |	Payments.Company,
		   |	Payments.Branch,
		   |	Payments.RetailCustomer,
		   |	SUM(Payments.Amount) AS Amount
		   |INTO R2023B_AdvancesFromRetailCustomers
		   |FROM
		   |	Payments AS Payments
		   |WHERE
		   |	Payments.IsAdvance
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Expense),
		   |	Payments.Period,
		   |	Payments.Company,
		   |	Payments.Branch,
		   |	Payments.RetailCustomer";
EndFunction

Function R9010B_SourceOfOriginStock()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.Store,
		   |	ItemList.ItemKey,
		   |	SourceOfOrigins.SourceOfOriginStock AS SourceOfOrigin,
		   |	SourceOfOrigins.SerialLotNumber,
		   |	SUM(SourceOfOrigins.Quantity) AS Quantity
		   |INTO R9010B_SourceOfOriginStock
		   |FROM
		   |	ItemList AS ItemList
		   |		INNER JOIN SourceOfOrigins AS SourceOfOrigins
		   |		ON ItemList.Key = SourceOfOrigins.Key
		   |		AND NOT SourceOfOrigins.SourceOfOriginStock.Ref IS NULL
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Expense),
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.Store,
		   |	ItemList.ItemKey,
		   |	SourceOfOrigins.SourceOfOriginStock,
		   |	SourceOfOrigins.SerialLotNumber";
EndFunction

Function R4014B_SerialLotNumber()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	*
		   |INTO R4014B_SerialLotNumber
		   |FROM
		   |	SerialLotNumbers AS SerialLotNumbers
		   |WHERE
		   |	TRUE";
EndFunction

Function R3010B_CashOnHand()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	Payments.Period,
		   |	Payments.Company,
		   |	Payments.Branch,
		   |	Payments.Account,
		   |	Payments.Currency,
		   |	Payments.Amount
		   |INTO R3010B_CashOnHand
		   |FROM
		   |	Payments AS Payments
		   |WHERE
		   |	NOT (Payments.IsAdvance
		   |	OR Payments.IsPaymentAgent)";
EndFunction

Function R3011T_CashFlow()
	Return "SELECT
		   |	Payments.Period,
		   |	Payments.Company,
		   |	Payments.Branch,
		   |	Payments.Account,
		   |	VALUE(Enum.CashFlowDirections.Incoming) AS Direction,
		   |	Payments.FinancialMovementType,
		   |	Payments.Currency,
		   |	Payments.Amount
		   |INTO R3011T_CashFlow
		   |FROM
		   |	Payments AS Payments
		   |WHERE
		   |	NOT (Payments.IsAdvance
		   |	OR Payments.IsPaymentAgent)";
EndFunction

Function R4011B_FreeStocks()
	Return "SELECT
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
		   |
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
	Return "SELECT
		   |	ItemList.Period AS Period,
		   |	ItemList.Store AS Store,
		   |	ItemList.ItemKey AS ItemKey,
		   |	ItemList.SalesOrder AS SalesOrder,
		   |	SUM(ItemList.Quantity) AS Quantity,
		   |	ItemList.ShipmentConfirmationExists AS ShipmentConfirmationExists
		   |INTO TmpItemListGroup
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.IsService
		   |	AND NOT ItemList.ShipmentConfirmationExists
		   |	AND ItemList.SalesOrderExists
		   |GROUP BY
		   |	ItemList.Period,
		   |	ItemList.Store,
		   |	ItemList.ItemKey,
		   |	ItemList.SalesOrder,
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
	Return "SELECT
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
		   |	AND ItemList.ShipmentConfirmationExists";
EndFunction

Function R4010B_ActualStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.Period,
		   |	ItemList.Store,
		   |	ItemList.ItemKey,
		   |	CASE
		   |		WHEN SerialLotNumbers.StockBalanceDetail
		   |			THEN SerialLotNumbers.SerialLotNumber
		   |		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		   |	END AS SerialLotNumber,
		   |	SUM(CASE
		   |		WHEN SerialLotNumbers.SerialLotNumber IS NULL
		   |			THEN ItemList.Quantity
		   |		ELSE SerialLotNumbers.Quantity
		   |	END) AS Quantity
		   |INTO R4010B_ActualStocks
		   |FROM
		   |	ItemList AS ItemList
		   |		LEFT JOIN SerialLotNumbers AS SerialLotNumbers
		   |		ON ItemList.Key = SerialLotNumbers.Key
		   |WHERE
		   |	NOT ItemList.IsService
		   |	AND NOT ItemList.ShipmentConfirmationExists
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Expense),
		   |	ItemList.Period,
		   |	ItemList.Store,
		   |	ItemList.ItemKey,
		   |	CASE
		   |		WHEN SerialLotNumbers.StockBalanceDetail
		   |			THEN SerialLotNumbers.SerialLotNumber
		   |		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		   |	END";
EndFunction

Function R3050T_PosCashBalances()
	Return "SELECT
		   |	*
		   |INTO R3050T_PosCashBalances
		   |FROM
		   |	Payments AS Payments
		   |WHERE
		   |	NOT (Payments.IsAdvance
		   |	OR Payments.IsPaymentAgent)";
EndFunction

Function R2050T_RetailSales()
	Return "SELECT
		   |	*
		   |INTO R2050T_RetailSales
		   |FROM
		   |	RetailSales AS RetailSales
		   |WHERE
		   |	TRUE";
EndFunction

Function R5021T_Revenues()
	Return "SELECT
		   |	*,
		   |	ItemList.NetAmount AS Amount,
		   |	ItemList.TotalAmount AS AmountWithTaxes
		   |INTO R5021T_Revenues
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE";
EndFunction

Function R2001T_Sales()
	Return "SELECT
		   |	*,
		   |	ItemList.TotalAmount AS Amount
		   |INTO R2001T_Sales
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE";
EndFunction

Function R2005T_SalesSpecialOffers()
	Return "SELECT *
		   |INTO R2005T_SalesSpecialOffers
		   |FROM
		   |	OffersInfo AS OffersInfo
		   |WHERE TRUE";

EndFunction

Function R2021B_CustomersTransactions()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.Currency,
		   |	ItemList.LegalName,
		   |	ItemList.Partner,
		   |	ItemList.Agreement,
		   |	ItemList.BasisDocument AS Basis,
		   |	UNDEFINED AS Order,
		   |	SUM(ItemList.TotalAmount) AS Amount,
		   |	UNDEFINED AS CustomersAdvancesClosing
		   |INTO R2021B_CustomersTransactions
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.UsePartnerTransactions
		   |GROUP BY
		   |	ItemList.Agreement,
		   |	ItemList.BasisDocument,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.Currency,
		   |	ItemList.LegalName,
		   |	ItemList.Partner,
		   |	ItemList.Period,
		   |	VALUE(AccumulationRecordType.Receipt)
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense),
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.Currency,
		   |	ItemList.LegalName,
		   |	ItemList.Partner,
		   |	ItemList.Agreement,
		   |	ItemList.BasisDocument,
		   |	UNDEFINED,
		   |	SUM(ItemList.TotalAmount),
		   |	UNDEFINED
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.UsePartnerTransactions
		   |GROUP BY
		   |	ItemList.Agreement,
		   |	ItemList.BasisDocument,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.Currency,
		   |	ItemList.LegalName,
		   |	ItemList.Partner,
		   |	ItemList.Period,
		   |	VALUE(AccumulationRecordType.Expense)
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	OffsetOfAdvances.Period,
		   |	OffsetOfAdvances.Company,
		   |	OffsetOfAdvances.Branch,
		   |	OffsetOfAdvances.Currency,
		   |	OffsetOfAdvances.LegalName,
		   |	OffsetOfAdvances.Partner,
		   |	OffsetOfAdvances.Agreement,
		   |	OffsetOfAdvances.TransactionDocument,
		   |	OffsetOfAdvances.TransactionOrder,
		   |	OffsetOfAdvances.Amount,
		   |	OffsetOfAdvances.Recorder
		   |FROM
		   |	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		   |WHERE
		   |	OffsetOfAdvances.Document = &Ref";
EndFunction

Function R5015B_OtherPartnersTransactions()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	PaymentAgent.Period,
		   |	PaymentAgent.Company,
		   |	PaymentAgent.Branch,
		   |	PaymentAgent.Currency,
		   |	PaymentAgent.LegalName,
		   |	PaymentAgent.Partner,
		   |	PaymentAgent.Agreement,
		   |	PaymentAgent.Basis,
		   |	PaymentAgent.Order,
		   |	SUM(PaymentAgent.Amount) AS Amount,
		   |	PaymentAgent.CustomersAdvancesClosing
		   |INTO R5015B_OtherPartnersTransactions
		   |FROM
		   |	PaymentAgent AS PaymentAgent
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Receipt),
		   |	PaymentAgent.Period,
		   |	PaymentAgent.Company,
		   |	PaymentAgent.Branch,
		   |	PaymentAgent.Currency,
		   |	PaymentAgent.LegalName,
		   |	PaymentAgent.Partner,
		   |	PaymentAgent.Agreement,
		   |	PaymentAgent.Basis,
		   |	PaymentAgent.Order,
		   |	PaymentAgent.CustomersAdvancesClosing";
EndFunction

Function R5010B_ReconciliationStatement()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.LegalName,
		   |	ItemList.LegalNameContract,
		   |	ItemList.Currency,
		   |	SUM(ItemList.TotalAmount) AS Amount,
		   |	ItemList.Period
		   |INTO R5010B_ReconciliationStatement
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.UsePartnerTransactions
		   |GROUP BY
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.LegalName,
		   |	ItemList.LegalNameContract,
		   |	ItemList.Currency,
		   |	ItemList.Period,
		   |	VALUE(AccumulationRecordType.Receipt)
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense),
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.LegalName,
		   |	ItemList.LegalNameContract,
		   |	ItemList.Currency,
		   |	SUM(ItemList.TotalAmount),
		   |	ItemList.Period
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.UsePartnerTransactions
		   |GROUP BY
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.LegalName,
		   |	ItemList.LegalNameContract,
		   |	ItemList.Currency,
		   |	ItemList.Period,
		   |	VALUE(AccumulationRecordType.Expense)
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	PaymentAgent.Company,
		   |	PaymentAgent.Branch,
		   |	PaymentAgent.LegalName,
		   |	PaymentAgent.LegalNameContract,
		   |	PaymentAgent.Currency,
		   |	SUM(PaymentAgent.Amount) AS Amount,
		   |	PaymentAgent.Period
		   |FROM
		   |	PaymentAgent AS PaymentAgent
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Receipt),
		   |	PaymentAgent.Company,
		   |	PaymentAgent.Branch,
		   |	PaymentAgent.LegalName,
		   |	PaymentAgent.LegalNameContract,
		   |	PaymentAgent.Currency,
		   |	PaymentAgent.Period";
EndFunction

Function T2015S_TransactionsInfo()
	Return "SELECT
		   |	PaymentAgent.Period,
		   |	PaymentAgent.Company,
		   |	PaymentAgent.Branch,
		   |	PaymentAgent.Currency,
		   |	PaymentAgent.Partner,
		   |	PaymentAgent.LegalName,
		   |	PaymentAgent.Agreement,
		   |	PaymentAgent.Order,
		   |	TRUE AS IsCustomerTransaction,
		   |	PaymentAgent.Basis AS TransactionBasis,
		   |	SUM(PaymentAgent.Amount) AS Amount,
		   |	TRUE AS IsDue
		   |INTO T2015S_TransactionsInfo
		   |FROM
		   |	PaymentAgent AS PaymentAgent
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	PaymentAgent.Period,
		   |	PaymentAgent.Company,
		   |	PaymentAgent.Branch,
		   |	PaymentAgent.Currency,
		   |	PaymentAgent.Partner,
		   |	PaymentAgent.LegalName,
		   |	PaymentAgent.Agreement,
		   |	PaymentAgent.Order,
		   |	PaymentAgent.Basis";
EndFunction

Function T3010S_RowIDInfo()
	Return "SELECT
		   |	RowIDInfo.RowRef AS RowRef,
		   |	RowIDInfo.BasisKey AS BasisKey,
		   |	RowIDInfo.RowID AS RowID,
		   |	RowIDInfo.Basis AS Basis,
		   |	ItemList.Key AS Key,
		   |	ItemList.Price AS Price,
		   |	ItemList.Ref.Currency AS Currency,
		   |	ItemList.Unit AS Unit
		   |INTO T3010S_RowIDInfo
		   |FROM
		   |	Document.RetailSalesReceipt.ItemList AS ItemList
		   |		INNER JOIN Document.RetailSalesReceipt.RowIDInfo AS RowIDInfo
		   |		ON RowIDInfo.Ref = &Ref
		   |		AND ItemList.Ref = &Ref
		   |		AND RowIDInfo.Key = ItemList.Key
		   |		AND RowIDInfo.Ref = ItemList.Ref";
EndFunction

Function T6020S_BatchKeysInfo()
	Return "SELECT
		   |	ItemList.Key,
		   |	ItemList.ItemKey,
		   |	ItemList.Store,
		   |	ItemList.Company,
		   //|	ISNULL(ConsignorBatches.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber,
		   //|	case
		   //|		when ConsignorBatches.Key IS NULL
		   //|			then False
		   //|		else true
		   //|	end as IsConsignorBatches,
		   |	ItemList.InventoryOrigin = VALUE(Enum.InventoryOriginTypes.ConsignorStocks) AS IsConsignorBatches,
		   |
		   //|	ISNULL(ConsignorBatches.Quantity,0) AS ConsignorQuantity,
		   //|
		   //|	CASE
		   //|		WHEN ConsignorBatches.Quantity IS NULL
		   //|			THEN ItemList.Quantity
		   //|		ELSE ConsignorBatches.Quantity
		   //|	END AS Quantity,
		   |
		   |	ItemList.Quantity AS Quantity,
		   |	ItemList.Period,
		   |	VALUE(Enum.BatchDirection.Expense) AS Direction
		   //|	ConsignorBatches.Batch AS BatchConsignor
		   |INTO BatchKeysInfo_1
		   |FROM
		   |	ItemList AS ItemList
		   //|		LEFT JOIN ConsignorBatches AS ConsignorBatches
		   //|		ON ItemList.Key = ConsignorBatches.Key
		   |WHERE
		   |	NOT ItemList.IsService
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	BatchKeysInfo_1.ItemKey,
		   |	BatchKeysInfo_1.Store,
		   |	BatchKeysInfo_1.Company,
		   |	BatchKeysInfo_1.Period,
		   |	BatchKeysInfo_1.Direction,
		   //|	BatchKeysInfo_1.BatchConsignor,
		   //|CASE WHEN BatchKeysInfo_1.IsConsignorBatches THEN
		   //| BatchKeysInfo_1.ConsignorQuantity
		   //|ELSE
		   |CASE
		   |	WHEN ISNULL(SourceOfOrigins.Quantity, 0) <> 0
		   |		THEN ISNULL(SourceOfOrigins.Quantity, 0)
		   |	ELSE BatchKeysInfo_1.Quantity
		   //|END
		   |END AS Quantity,   
		   |	ISNULL(SourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)) AS SourceOfOrigin,
		   |	ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber
		   |INTO BatchKeysInfo
		   |FROM
		   |	BatchKeysInfo_1 AS BatchKeysInfo_1
		   |		LEFT JOIN SourceOfOrigins AS SourceOfOrigins
		   |		ON BatchKeysInfo_1.Key = SourceOfOrigins.Key
		   //|		and case
		   //|			when BatchKeysInfo_1.IsConsignorBatches
		   //|				then BatchKeysInfo_1.SerialLotNumber = SourceOfOrigins.SerialLotNumberStock
		   //|			else true
		   //|		end
		   |;
		   |SELECT
		   |	BatchKeysInfo.ItemKey,
		   |	BatchKeysInfo.Store,
		   |	BatchKeysInfo.Company,
		   |	BatchKeysInfo.Period,
		   |	BatchKeysInfo.Direction,
		   //|	BatchKeysInfo.BatchConsignor,
		   |	SUM(BatchKeysInfo.Quantity) AS Quantity,
		   |	BatchKeysInfo.SourceOfOrigin,
		   |	BatchKeysInfo.SerialLotNumber
		   |INTO T6020S_BatchKeysInfo
		   |FROM
		   |	BatchKeysInfo AS BatchKeysInfo
		   |WHERE TRUE
		   |GROUP BY
		   |	BatchKeysInfo.ItemKey,
		   |	BatchKeysInfo.Store,
		   |	BatchKeysInfo.Company,
		   |	BatchKeysInfo.Period,
		   |	BatchKeysInfo.Direction,
		   //|	BatchKeysInfo.BatchConsignor,
		   |	BatchKeysInfo.SourceOfOrigin,
		   |	BatchKeysInfo.SerialLotNumber";
EndFunction

//#2093
//Function R8012B_ConsignorInventory()
//	Return "SELECT
//		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
//		   |	ItemList.Period,
//		   |	ItemList.Company,
//		   |	ItemList.ItemKey,
//		   |	ConsignorBatches.SerialLotNumber,
//		   |	CASE
//		   |		WHEN ConsignorBatches.Batch REFS Document.OpeningEntry
//		   |			THEN ConsignorBatches.Batch.PartnerConsignor
//		   |		ELSE ConsignorBatches.Batch.Partner
//		   |	END AS Partner,
//		   |	CASE
//		   |		WHEN ConsignorBatches.Batch REFS Document.OpeningEntry
//		   |			THEN ConsignorBatches.Batch.AgreementConsignor
//		   |		ELSE ConsignorBatches.Batch.Agreement
//		   |	END AS Agreement,
//		   |	CASE
//		   |		WHEN ConsignorBatches.Batch REFS Document.OpeningEntry
//		   |			THEN ConsignorBatches.Batch.LegalNameConsignor
//		   |		ELSE ConsignorBatches.Batch.LegalName
//		   |	END AS LegalName,
//		   |	ConsignorBatches.Quantity
//		   |INTO R8012B_ConsignorInventory
//		   |FROM
//		   |	ItemList AS ItemList
//		   |		LEFT JOIN ConsignorBatches AS ConsignorBatches
//		   |		ON ItemList.Key = ConsignorBatches.Key
//		   |WHERE
//		   |	ItemList.IsConsignorStocks";
//EndFunction

//#2093
//Function R8013B_ConsignorBatchWiseBalance()
//	Return "SELECT
//		   |	ItemList.Key,
//		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
//		   |	ItemList.Period,
//		   |	ItemList.Company,
//		   |	ConsignorBatches.Batch,
//		   |	ConsignorBatches.ItemKey,
//		   |	ConsignorBatches.SerialLotNumber,
//		   |	ConsignorBatches.Store,
//		   |	ConsignorBatches.Quantity
//		   |INTO ConsignorBatchWiseBalance_1
//		   |FROM
//		   |	ItemList AS ItemList
//		   |		INNER JOIN ConsignorBatches AS ConsignorBatches
//		   |		ON ItemList.IsConsignorStocks
//		   |		AND ItemList.Key = ConsignorBatches.Key
//		   |		AND NOT ItemList.ShipmentConfirmationExists
//		   |;
//		   |
//		   |////////////////////////////////////////////////////////////////////////////////
//		   |SELECT
//		   |	ConsignorBatchWiseBalance_1.RecordType,
//		   |	ConsignorBatchWiseBalance_1.Period,
//		   |	ConsignorBatchWiseBalance_1.Company,
//		   |	ConsignorBatchWiseBalance_1.Batch,
//		   |	ConsignorBatchWiseBalance_1.ItemKey,
//		   |	ConsignorBatchWiseBalance_1.Store,
//		   |	SUM(ISNULL(ConsignorBatchWiseBalance_1.Quantity, 0)) AS Quantity,
//		   |
//		   |	SourceOfOrigins.SourceOfOriginStock AS SourceOfOrigin,
//		   |	SourceOfOrigins.SerialLotNumberStock AS SerialLotNumber
//		   |INTO R8013B_ConsignorBatchWiseBalance
//		   |FROM
//		   |	ConsignorBatchWiseBalance_1 AS ConsignorBatchWiseBalance_1
//		   |		LEFT JOIN SourceOfOrigins AS SourceOfOrigins
//		   |		ON ConsignorBatchWiseBalance_1.Key = SourceOfOrigins.Key
//		   |		AND ConsignorBatchWiseBalance_1.SerialLotNumber = SourceOfOrigins.SerialLotNumberStock
//		   |GROUP BY
//		   |	ConsignorBatchWiseBalance_1.RecordType,
//		   |	ConsignorBatchWiseBalance_1.Period,
//		   |	ConsignorBatchWiseBalance_1.Company,
//		   |	ConsignorBatchWiseBalance_1.Batch,
//		   |	ConsignorBatchWiseBalance_1.ItemKey,
//		   |	ConsignorBatchWiseBalance_1.Store,
//		   |	SourceOfOrigins.SourceOfOriginStock,
//		   |	SourceOfOrigins.SerialLotNumberStock";
//EndFunction

//#2093 ??????????
//Function R8014T_ConsignorSales()
//	Return "SELECT
//		   |	ItemList.Key AS Key,
//		   |	ItemList.Period,
//		   |	ItemList.Key AS RowKey,
//		   |	ItemList.Company,
//		   |	ConsignorBatches.Batch.Partner AS Partner,
//		   |	ConsignorBatches.Batch.Agreement AS Agreement,
//		   |	ItemList.Currency,
//		   |	ItemList.Invoice AS SalesInvoice,
//		   |	ConsignorBatches.Batch AS PurchaseInvoice,
//		   |	ItemList.ItemKey,
//		   |	ConsignorBatches.SerialLotNumber,
//		   |	ItemList.Unit,
//		   |	ItemList.Price,
//		   |	ItemList.PriceType,
//		   |	ItemList.PriceIncludeTax,
//		   |	ConsignorBatches.Quantity,
//		   |	CASE
//		   |		WHEN ItemList.Quantity = 0
//		   |			THEN 0
//		   |		ELSE (ItemList.NetAmount / ItemList.Quantity) * ConsignorBatches.Quantity
//		   |	END AS NetAmount,
//		   |	CASE
//		   |		WHEN ItemList.Quantity = 0
//		   |			THEN 0
//		   |		ELSE (ItemList.TotalAmount / ItemList.Quantity) * ConsignorBatches.Quantity
//		   |	END AS Amount
//		   |INTO ConsignorSales
//		   |FROM
//		   |	ItemList AS ItemList
//		   |		LEFT JOIN ConsignorBatches AS ConsignorBatches
//		   |		ON ItemList.Key = ConsignorBatches.Key
//		   |WHERE
//		   |	ItemList.IsConsignorStocks
//		   |;
//		   |
//		   |////////////////////////////////////////////////////////////////////////////////
//		   |SELECT
//		   |
//		   |	ConsignorSales.*,
//		   |	ConsignorSales.Quantity,
//		   |	ConsignorSales.NetAmount,
//		   |	ConsignorSales.Amount,
//		   |	SourceOfOrigins.SourceOfOriginStock AS SourceOfOrigin,
//		   |	SourceOfOrigins.SerialLotNumberStock AS SerialLotNumber
//		   |INTO ConsignorSales_1
//		   |FROM
//		   |	ConsignorSales AS ConsignorSales
//		   |		LEFT JOIN SourceOfOrigins AS SourceOfOrigins
//		   |		ON ConsignorSales.Key = SourceOfOrigins.Key
//		   |		AND ConsignorSales.SerialLotNumber = SourceOfOrigins.SerialLotNumberStock
//		   |;
//		   |
//		   |////////////////////////////////////////////////////////////////////////////////
//		   |SELECT
//		   |
//		   |	ConsignorSales_1.*,
//		   |	ConsignorSales_1.Key,
//		   |	ConsignorSales_1.NetAmount,
//		   |	ConsignorSales_1.Amount,
//		   |	ConsignorPrices.Price AS ConsignorPrice
//		   |INTO ConsignorSales_1_1
//		   |FROM
//		   |	ConsignorSales_1 AS ConsignorSales_1
//		   |		LEFT JOIN AccumulationRegister.R8015T_ConsignorPrices AS ConsignorPrices
//		   |		ON ConsignorSales_1.Company = ConsignorPrices.Company
//		   |		AND ConsignorSales_1.Partner = ConsignorPrices.Partner
//		   |		AND ConsignorSales_1.Agreement = ConsignorPrices.Agreement
//		   |		AND ConsignorSales_1.PurchaseInvoice = ConsignorPrices.PurchaseInvoice
//		   |		AND ConsignorSales_1.ItemKey = ConsignorPrices.ItemKey
//		   |		AND ConsignorSales_1.SerialLotNumber = ConsignorPrices.SerialLotNumber
//		   |		AND ConsignorSales_1.SourceOfOrigin = ConsignorPrices.SourceOfOrigin
//		   |		AND ConsignorSales_1.Currency = ConsignorPrices.Currency
//		   |		AND ConsignorPrices.CurrencyMovementType = Value(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
//		   |;
//		   |
//		   |////////////////////////////////////////////////////////////////////////////////
//		   |SELECT
//		   |	ConsignorSales_1_1.*
//		   |INTO R8014T_ConsignorSales
//		   |FROM
//		   |	ConsignorSales_1_1 AS ConsignorSales_1_1
//		   |WHERE
//		   |	TRUE";
//EndFunction

Function R2012B_SalesOrdersInvoiceClosing()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.Period AS Period,
		   |	ItemList.Company AS Company,
		   |	ItemList.Branch AS Branch,
		   |	ItemList.SalesOrder AS Order,
		   |	ItemList.Currency AS Currency,
		   |	ItemList.ItemKey AS ItemKey,
		   |	ItemList.RowID AS RowKey,
		   |	ItemList.Quantity AS Quantity,
		   |	ItemList.TotalAmount AS Amount,
		   |	ItemList.NetAmount AS NetAmount
		   |INTO R2012B_SalesOrdersInvoiceClosing
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.SalesOrderExists";
EndFunction

#EndRegion

#Region AccessObject

// Get access key.
// 
// Parameters:
//  Obj - DocumentObjectDocumentName -
// 
// Returns:
//  Map
Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	AccessKeyMap.Insert("Company", Obj.Company);
	AccessKeyMap.Insert("Branch", Obj.Branch);
	StoreList = Obj.ItemList.Unload(, "Store");
	StoreList.GroupBy("Store");
	AccessKeyMap.Insert("Store", StoreList.UnloadColumn("Store"));
	Return AccessKeyMap;
EndFunction

#EndRegion

#Region Accounting

Function T1050T_AccountingQuantities()
	Return "SELECT
		   |	ItemList.Period,
		   |	ItemList.Key AS RowKey,
		   |	VALUE(Catalog.AccountingOperations.RetailSalesReceipt_DR_R5022T_CR_R4050B) AS Operation,
		   |	ItemList.Quantity
		   |INTO T1050T_AccountingQuantities
		   |FROM
		   |	ItemList AS ItemList";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	Operations = Catalogs.AccountingOperations;
	If Parameters.Operation = Operations.RetailSalesReceipt_DR_R5022T_CR_R4050B Then
		Return GetAnalytics_DR_R5022T_CR_R4050B(Parameters); // Expenses (landed cost) - Stock inventory
	EndIf;
	Return Undefined;
EndFunction

#Region Accounting_Analytics

// Expenses (landed cost) - Stock inventory 
Function GetAnalytics_DR_R5022T_CR_R4050B(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters,
		Parameters.ObjectData.Company.LandedCostExpenseType);
	If ValueIsFilled(Debit.Account) Then
		AccountingAnalytics.Debit = Debit.Account;
	EndIf;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9010S_AccountsItemKey(AccountParameters, Parameters.RowData.ItemKey);
	If ValueIsFilled(Credit.Account) Then
		AccountingAnalytics.Credit = Credit.Account;
	EndIf;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value) Export
	If Parameters.Operation = Catalogs.AccountingOperations.RetailSalesReceipt_DR_R5022T_CR_R4050B Then

		If ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.ExpenseAndRevenueTypes")) <> Undefined Then
			Return Parameters.ObjectData.Company.LandedCostExpenseType;
		EndIf;

		If ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.Items")) <> Undefined Then
			Return Parameters.RowData.ItemKey.Item;
		EndIf;

		Return Value;
	EndIf;
	Return Value;
EndFunction

Function GetHintCreditExtDimension(Parameters, ExtDimensionType, Value) Export
	If Parameters.Operation = Catalogs.AccountingOperations.RetailSalesReceipt_DR_R5022T_CR_R4050B
		And ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.Items")) <> Undefined Then
		Return Parameters.RowData.ItemKey.Item;
	EndIf;
	Return Value;
EndFunction

#EndRegion

#EndRegion