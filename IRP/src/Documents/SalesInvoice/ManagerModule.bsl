#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);

	Tables.Insert("CustomersTransactions", PostingServer.GetQueryTableByName("CustomersTransactions", Parameters));
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ItemList.Key AS Key,
	|	ItemList.InventoryOrigin AS InventoryOrigin,
	|	ItemList.Ref.Company AS Company,
	|	ItemList.ItemKey AS ItemKey,
	|	ItemList.Store AS Store,
	|	ItemList.QuantityInBaseUnit AS Quantity
	|FROM
	|	Document.SalesInvoice.ItemList AS ItemList
	|WHERE
	|	ItemList.Ref = &Ref";
	Query.SetParameter("Ref", Ref);
	QueryResult = Query.Execute();
	ItemListTable = QueryResult.Unload();
	ConsignorBatches = CommissionTradeServer.GetRegistrateConsignorBatches(Parameters.Object, ItemListTable);

	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = "SELECT * INTO ConsignorBatches FROM &T1 AS T1";
	Query.SetParameter("T1", ConsignorBatches);
	Query.Execute();
	
	BatchKeysInfoMetadata = Parameters.Object.RegisterRecords.T6020S_BatchKeysInfo.Metadata();
	If Parameters.Property("MultiCurrencyExcludePostingDataTables") Then
		Parameters.MultiCurrencyExcludePostingDataTables.Add(BatchKeysInfoMetadata);
	Else
		ArrayOfMultiCurrencyExcludePostingDataTables = New Array();
		ArrayOfMultiCurrencyExcludePostingDataTables.Add(BatchKeysInfoMetadata);
		Parameters.Insert("MultiCurrencyExcludePostingDataTables", ArrayOfMultiCurrencyExcludePostingDataTables);
	EndIf;

	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
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
	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref, "Document.SalesInvoice.ItemList");
	
	If Not Unposting And Ref.Agreement.UseCreditLimit Then
		CreditLimitsServer.CheckCreditLimit(Ref, Cancel);
	EndIf;

	If Cancel Then
		Return;
	EndIf;

	CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo);
	
	If Not Cancel And Not AccReg.R4014B_SerialLotNumber.CheckBalance(Ref, LineNumberAndItemKeyFromItemList, 
		PostingServer.GetQueryTableByName("R4014B_SerialLotNumber", Parameters), 
		PostingServer.GetQueryTableByName("Exists_R4014B_SerialLotNumber", Parameters),
		AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
		
	If Not Cancel And Not AccReg.R2001T_Sales.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R2001T_Sales", Parameters),
		PostingServer.GetQueryTableByName("Exists_R2001T_Sales", Parameters),
		AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("RecordType", AccumulationRecordType.Expense);
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.SalesInvoice.ItemList", AddInfo);
EndProcedure

#EndRegion

#Region NewRegistersPosting

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure();
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
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
	QueryArray = New Array();
	QueryArray.Add(ItemList());
	QueryArray.Add(ItemListLandedCost());
	QueryArray.Add(OffersInfo());
	QueryArray.Add(Taxes());
	QueryArray.Add(SerialLotNumbers());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4014B_SerialLotNumber());
	QueryArray.Add(PostingServer.Exists_R2001T_Sales());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
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
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(R5011B_CustomersAging());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R2022B_CustomersPaymentPlanning());
	QueryArray.Add(R5021T_Revenues());
	QueryArray.Add(T3010S_RowIDInfo());
	QueryArray.Add(T2015S_TransactionsInfo());
	QueryArray.Add(T6020S_BatchKeysInfo());
	QueryArray.Add(R6080T_OtherPeriodsRevenues());
	QueryArray.Add(R8010B_TradeAgentInventory());
	QueryArray.Add(R8011B_TradeAgentSerialLotNumber());
	QueryArray.Add(R8012B_ConsignorInventory());
	QueryArray.Add(R8013B_ConsignorBatchWiseBalance());
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
		|	SalesInvoiceItemList.ProfitLossCenter AS ProfitLossCenter,
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
		|	SalesInvoiceItemList.Key,
		|	SalesInvoiceItemList.Ref.Branch AS Branch,
		|	SalesInvoiceItemList.Ref.LegalNameContract AS LegalNameContract,
		|	SalesInvoiceItemList.PriceType,
		|	SalesInvoiceItemList.SalesPerson,
		|	SalesInvoiceItemList.Ref.TransactionType = VALUE(Enum.SalesTransactionTypes.Sales) AS IsSales,
		|	SalesInvoiceItemList.Ref.TransactionType = VALUE(Enum.SalesTransactionTypes.ShipmentToTradeAgent) AS IsShipmentToTradeAgent,
		|	SalesInvoiceItemList.Ref.Company.TradeAgentStore AS TradeAgentStore,
		|	SalesInvoiceItemList.InventoryOrigin = VALUE(Enum.InventoryOrigingTypes.OwnStocks) AS IsOwnStocks,
		|	SalesInvoiceItemList.InventoryOrigin = VALUE(Enum.InventoryOrigingTypes.ConsignorStocks) AS IsConsignorStocks
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
		|	SalesInvoiceShipmentConfirmations.Ref = &Ref";
EndFunction

Function ItemListLandedCost()
	Return
		"SELECT
		|	ItemList.Ref.Date AS Period,
		|	ItemList.Ref AS Basis,
		|	ItemList.Ref.Company AS Company,
		|	ItemList.Ref.Branch AS Branch,
		|	ItemList.Ref.Currency AS Currency,
		|	ItemList.ProfitLossCenter,
		|	ItemList.RevenueType,
		|	ItemList.ItemKey,
		|	ItemList.AdditionalAnalytic,
		|	ItemList.NetAmount,
		|	ItemList.IsAdditionalItemRevenue,
		|	ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
		|	TableRowIDInfo.RowID AS RowID
		|INTO ItemListLandedCost
		|FROM
		|	Document.SalesInvoice.ItemList AS ItemList
		|		LEFT JOIN TableRowIDInfo AS TableRowIDInfo
		|		ON ItemList.Key = TableRowIDInfo.Key
		|WHERE
		|	ItemList.Ref = &Ref";
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
		|	SalesInvoiceItemList.NetAmount,
		|	SalesInvoiceItemList.Ref.Branch AS Branch
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
		|	SalesInvoiceItemList.NetAmount AS TaxableAmount,
		|	SalesInvoiceItemList.Ref.Branch AS Branch,
		|	SalesInvoiceItemList.Ref.TransactionType = VALUE(Enum.SalesTransactionTypes.Sales) AS IsSales,
		|	SalesInvoiceItemList.Ref.TransactionType = VALUE(Enum.SalesTransactionTypes.ShipmentToTradeAgent) AS IsShipmentToTradeAgent,
		|	SalesInvoiceItemList.InventoryOrigin = VALUE(Enum.InventoryOrigingTypes.OwnStocks) AS IsOwnStocks,
		|	SalesInvoiceItemList.InventoryOrigin = VALUE(Enum.InventoryOrigingTypes.ConsignorStocks) AS IsConsignorStocks
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
		|	SerialLotNumbers.Ref.Branch AS Branch,
		|	SerialLotNumbers.Key,
		|	SerialLotNumbers.SerialLotNumber,
		|	SerialLotNumbers.SerialLotNumber.StockBalanceDetail AS StockBalanceDetail,
		|	SerialLotNumbers.Quantity,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.Ref.Partner AS Partner,
		|	ItemList.Ref.Agreement AS Agreement,
		|	ItemList.Ref.TransactionType = VALUE(Enum.SalesTransactionTypes.ShipmentToTradeAgent) AS IsShipmentToTradeAgent
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
		"SELECT
		|	*
		|INTO R2001T_Sales
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsSales";
EndFunction

Function R2005T_SalesSpecialOffers()
	Return 
		"SELECT
		|	*
		|INTO R2005T_SalesSpecialOffers
		|FROM
		|	OffersInfo AS OffersInfo
		|WHERE
		|	TRUE";
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
		|	ItemList.Branch,
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
		|	ItemList.Branch,
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
		|	*
		|INTO R2040B_TaxesIncoming
		|FROM
		|	Taxes AS Taxes
		|WHERE
		|	Taxes.IsSales";
EndFunction

#Region Stock

Function R4010B_ActualStocks()
	Return 
		"SELECT
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
		|	AND NOT ItemList.UseShipmentConfirmation
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
		|	END
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.Period,
		|	ItemList.TradeAgentStore,
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
		|FROM
		|	ItemList AS ItemList
		|		LEFT JOIN SerialLotNumbers AS SerialLotNumbers
		|		ON ItemList.Key = SerialLotNumbers.Key
		|WHERE
		|	NOT ItemList.IsService
		|	AND NOT ItemList.UseShipmentConfirmation
		|	AND NOT ItemList.ShipmentConfirmationExists
		|	AND ItemList.IsShipmentToTradeAgent
		|GROUP BY
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.Period,
		|	ItemList.TradeAgentStore,
		|	ItemList.ItemKey,
		|	CASE
		|		WHEN SerialLotNumbers.StockBalanceDetail
		|			THEN SerialLotNumbers.SerialLotNumber
		|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		|	END,
		|	VALUE(AccumulationRecordType.Receipt)";
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
		|	OR ItemList.ShipmentConfirmationExists)";
EndFunction

Function R4050B_StockInventory()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	SUM(ItemList.Quantity) AS Quantity
		|INTO R4050B_StockInventory
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|	AND ItemList.IsOwnStocks
		|
		|GROUP BY
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Store,
		|	ItemList.ItemKey
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.TradeAgentStore,
		|	ItemList.ItemKey,
		|	SUM(ItemList.Quantity) AS Quantity
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|	AND ItemList.IsShipmentToTradeAgent
		|
		|GROUP BY
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.TradeAgentStore,
		|	ItemList.ItemKey";
EndFunction

#EndRegion

Function R4014B_SerialLotNumber()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	*
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
		|	OffsetOfAdvances.Recorder AS CustomersAdvancesClosing,
		|	OffsetOfAdvances.AdvancesOrder AS Order,
		|	*
		|INTO R2020B_AdvancesFromCustomers
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref";
EndFunction

Function R2021B_CustomersTransactions()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.LegalName,
		|	ItemList.Partner,
		|	ItemList.Agreement,
		|	ItemList.Basis,
		|	ItemList.SalesOrder AS Order,
		|	SUM(ItemList.Amount) AS Amount,
		|	UNDEFINED AS CustomersAdvancesClosing
		|INTO R2021B_CustomersTransactions
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsSales
		|GROUP BY
		|	ItemList.Agreement,
		|	ItemList.Basis,
		|	ItemList.SalesOrder,
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

Function R5011B_CustomersAging()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentTerms.Ref.Date AS Period,
		|	PaymentTerms.Ref.Company AS Company,
		|	PaymentTerms.Ref.Branch AS Branch,
		|	PaymentTerms.Ref.Currency AS Currency,
		|	PaymentTerms.Ref.Agreement AS Agreement,
		|	PaymentTerms.Ref.Partner AS Partner,
		|	PaymentTerms.Ref AS Invoice,
		|	PaymentTerms.Date AS PaymentDate,
		|	SUM(PaymentTerms.Amount) AS Amount,
		|	UNDEFINED AS AgingClosing
		|INTO R5011B_CustomersAging
		|FROM
		|	Document.SalesInvoice.PaymentTerms AS PaymentTerms
		|WHERE
		|	PaymentTerms.Ref = &Ref
		|GROUP BY
		|	PaymentTerms.Date,
		|	PaymentTerms.Ref,
		|	PaymentTerms.Ref.Agreement,
		|	PaymentTerms.Ref.Company,
		|	PaymentTerms.Ref.Branch,
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
		|	OffsetOfAging.Branch,
		|	OffsetOfAging.Currency,
		|	OffsetOfAging.Agreement,
		|	OffsetOfAging.Partner,
		|	OffsetOfAging.Invoice,
		|	OffsetOfAging.PaymentDate,
		|	OffsetOfAging.Amount,
		|	OffsetOfAging.Recorder
		|FROM
		|	InformationRegister.T2013S_OffsetOfAging AS OffsetOfAging
		|WHERE
		|	OffsetOfAging.Document = &Ref";
EndFunction

Function R5010B_ReconciliationStatement()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.LegalName,
		|	ItemList.LegalNameContract,
		|	ItemList.Currency,
		|	SUM(ItemList.Amount) AS Amount,
		|	ItemList.Period
		|INTO R5010B_ReconciliationStatement
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsSales
		|GROUP BY
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.LegalName,
		|	ItemList.LegalNameContract,
		|	ItemList.Currency,
		|	ItemList.Period,
		|	VALUE(AccumulationRecordType.Receipt)";
EndFunction

Function R2022B_CustomersPaymentPlanning()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	SalesInvoicePaymentTerms.Ref.Date AS Period,
		|	SalesInvoicePaymentTerms.Ref.Company AS Company,
		|	SalesInvoicePaymentTerms.Ref.Branch AS Branch,
		|	SalesInvoicePaymentTerms.Ref AS Basis,
		|	SalesInvoicePaymentTerms.Ref.LegalName AS LegalName,
		|	SalesInvoicePaymentTerms.Ref.Partner AS Partner,
		|	SalesInvoicePaymentTerms.Ref.Agreement AS Agreement,
		|	SUM(SalesInvoicePaymentTerms.Amount) AS Amount
		|INTO R2022B_CustomersPaymentPlanning
		|FROM
		|	Document.SalesInvoice.PaymentTerms AS SalesInvoicePaymentTerms
		|WHERE
		|	SalesInvoicePaymentTerms.Ref = &Ref
		|	AND SalesInvoicePaymentTerms.CalculationType = VALUE(Enum.CalculationTypes.PostShipmentCredit)
		|GROUP BY
		|	SalesInvoicePaymentTerms.Ref.Date,
		|	SalesInvoicePaymentTerms.Ref.Company,
		|	SalesInvoicePaymentTerms.Ref.Branch,
		|	SalesInvoicePaymentTerms.Ref,
		|	SalesInvoicePaymentTerms.Ref.LegalName,
		|	SalesInvoicePaymentTerms.Ref.Partner,
		|	SalesInvoicePaymentTerms.Ref.Agreement,
		|	VALUE(AccumulationRecordType.Receipt)";
EndFunction

Function R5021T_Revenues()
	Return 
		"SELECT
		|	*,
		|	ItemList.NetAmount AS Amount,
		|	ItemList.Amount AS AmountWithTaxes
		|INTO R5021T_Revenues
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemLIst.IsSales";
EndFunction

Function T3010S_RowIDInfo()
	Return
		"SELECT
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
		|	Document.SalesInvoice.ItemList AS ItemList
		|		INNER JOIN Document.SalesInvoice.RowIDInfo AS RowIDInfo
		|		ON RowIDInfo.Ref = &Ref
		|		AND ItemList.Ref = &Ref
		|		AND RowIDInfo.Key = ItemList.Key
		|		AND RowIDInfo.Ref = ItemList.Ref";
EndFunction

Function T2015S_TransactionsInfo()
	Return 
	"SELECT
	|	ItemList.Period AS Date,
	|	ItemList.Company,
	|	ItemList.Branch,
	|	ItemList.Currency,
	|	ItemList.Partner,
	|	ItemList.LegalName,
	|	ItemList.Agreement,
	|	ItemList.SalesOrder AS Order,
	|	TRUE AS IsCustomerTransaction,
	|	ItemList.Basis AS TransactionBasis,
	|	SUM(ItemList.Amount) AS Amount,
	|	TRUE AS IsDue
	|INTO T2015S_TransactionsInfo
	|FROM
	|	ItemList AS ItemList
	|WHERE
	|	ItemList.IsSales
	|GROUP BY
	|	ItemList.Period,
	|	ItemList.Company,
	|	ItemList.Branch,
	|	ItemList.Currency,
	|	ItemList.Partner,
	|	ItemList.LegalName,
	|	ItemList.Agreement,
	|	ItemList.SalesOrder,
	|	ItemList.Basis";
EndFunction

Function R6080T_OtherPeriodsRevenues()
	Return
		"SELECT
		|	*,
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.NetAmount AS Amount
		|INTO R6080T_OtherPeriodsRevenues
		|FROM
		|	ItemListLandedCost AS ItemList
		|WHERE
		|	ItemList.IsAdditionalItemRevenue";
EndFunction

Function T6020S_BatchKeysInfo()
	Return
		"SELECT
		|	ItemList.ItemKey,
		|	ItemList.Store,
		|	ItemList.Company,
		|	SUM(case when ConsignorBatches.Quantity is null then ItemList.Quantity else ConsignorBatches.Quantity end) AS Quantity,
		|	ItemList.Period,
		|	VALUE(Enum.BatchDirection.Expense) AS Direction,
		|	ConsignorBatches.Batch AS BatchConsignor
		|INTO T6020S_BatchKeysInfo
		|FROM
		|	ItemList AS ItemList
		|	LEFT JOIN ConsignorBatches AS ConsignorBatches ON
		|	ItemList.Key = ConsignorBatches.Key
		|
		|WHERE
		|	ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Product)
		|
		|GROUP BY
		|	ItemList.ItemKey,
		|	ItemList.Store,
		|	ItemList.Company,
		|	ItemList.Period,
		|	VALUE(Enum.BatchDirection.Expense),
		|	ConsignorBatches.Batch
		|
		|UNION ALL
		|
		|SELECT
		|	ItemList.ItemKey,
		|	ItemList.TradeAgentStore,
		|	ItemList.Company,
		|	SUM(ItemList.Quantity),
		|	ItemList.Period,
		|	VALUE(Enum.BatchDirection.Receipt),
		|	UNDEFINED
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Product)
		|	AND ItemList.IsShipmentToTradeAgent
		|
		|GROUP BY
		|	ItemList.ItemKey,
		|	ItemList.TradeAgentStore,
		|	ItemList.Company,
		|	ItemList.Period,
		|	VALUE(Enum.BatchDirection.Receipt)";
EndFunction

Function R8010B_TradeAgentInventory()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.ItemKey,
		|	ItemList.Partner,
		|	ItemList.Agreement,
		|	SUM(ItemList.Quantity) AS Quantity
		|INTO R8010B_TradeAgentInventory
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|	AND ItemList.IsShipmentToTradeAgent
		|
		|GROUP BY
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.ItemKey,
		|	ItemList.Partner,
		|	ItemList.Agreement";
EndFunction

Function R8011B_TradeAgentSerialLotNumber()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	SerialLotNumbers.Period,
		|	SerialLotNumbers.Company,
		|	SerialLotNumbers.ItemKey,
		|	SerialLotNumbers.Partner,
		|	SerialLotNumbers.Agreement,
		|	SerialLotNumbers.SerialLotNumber,
		|	SerialLotNumbers.Quantity
		|INTO R8011B_TradeAgentSerialLotNumber
		|FROM
		|	SerialLotNumbers AS SerialLotNumbers
		|WHERE
		|	SerialLotNumbers.IsShipmentToTradeAgent";
EndFunction

Function R8012B_ConsignorInventory()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.ItemKey,
		|	ItemList.Partner,
		|	ItemList.Agreement,
		|	ItemList.Quantity
		|INTO R8012B_ConsignorInventory
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsSales
		|	AND ItemList.IsConsignorStocks";		
EndFunction

Function R8013B_ConsignorBatchWiseBalance()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ConsignorBatches.Batch,
		|	ConsignorBatches.ItemKey,
		|	ConsignorBatches.Store,
		|	ConsignorBatches.Quantity
		|INTO R8013B_ConsignorBatchWiseBalance
		|FROM
		|	ItemList AS ItemList
		|		INNER JOIN ConsignorBatches AS ConsignorBatches
		|		ON ItemList.IsSales
		|		AND ItemList.IsConsignorStocks
		|		AND ItemList.Key = ConsignorBatches.Key";
EndFunction

#EndRegion
