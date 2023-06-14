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
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
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
	DataMapWithLockFields = New Map();
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
	Return;
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
	StrParams = New Structure();
	StrParams.Insert("Ref", Ref);
	If ValueIsFilled(Ref) Then
		StrParams.Insert("BalancePeriod", New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	Else
		StrParams.Insert("BalancePeriod", Undefined);
	EndIf;
	Return StrParams;
EndFunction

#EndRegion

#Region Posting_MainTables

#EndRegion

#Region Posting_SourceTable


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
	Return AccessKeyMap;
EndFunction

#EndRegion



Function GetQueryTextsSecondaryTables()
	QueryArray = New Array();
	QueryArray.Add(ItemList());
	QueryArray.Add(Taxes());
	QueryArray.Add(SerialLotNumbers());
	QueryArray.Add(SourceOfOrigins());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R2001T_Sales());
	QueryArray.Add(R2040B_TaxesIncoming());
	QueryArray.Add(R4050B_StockInventory());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5021T_Revenues());
	QueryArray.Add(T2015S_TransactionsInfo());
	QueryArray.Add(T6020S_BatchKeysInfo());
	QueryArray.Add(R8010B_TradeAgentInventory());
	QueryArray.Add(R8011B_TradeAgentSerialLotNumber());
	QueryArray.Add(R9010B_SourceOfOriginStock());	
	Return QueryArray;
EndFunction

Function ItemList()
	Return 
		"SELECT
		|	DocItemList.Ref.Company AS Company,
		|	DocItemList.Ref AS Invoice,
		|	DocItemList.ItemKey AS ItemKey,
		|	DocItemList.Key AS RowKey,
		|	DocItemList.Quantity AS UnitQuantity,
		|	DocItemList.QuantityInBaseUnit AS Quantity,
		|	DocItemList.TotalAmount AS Amount,
		|	DocItemList.Ref.Partner AS Partner,
		|	DocItemList.Ref.LegalName AS LegalName,
		|	CASE
		|		WHEN DocItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND DocItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN DocItemList.Ref.Agreement.StandardAgreement
		|		ELSE DocItemList.Ref.Agreement
		|	END AS Agreement,
		|	DocItemList.Ref.Currency AS Currency,
		|	DocItemList.Unit AS Unit,
		|	DocItemList.Ref.Date AS Period,
		|	DocItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
		|	DocItemList.ProfitLossCenter AS ProfitLossCenter,
		|	DocItemList.RevenueType AS RevenueType,
		|	DocItemList.AdditionalAnalytic AS AdditionalAnalytic,
		|	CASE
		|		WHEN DocItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN DocItemList.Ref
		|		ELSE UNDEFINED
		|	END AS Basis,
		|	DocItemList.NetAmount AS NetAmount,
		|	DocItemList.Key,
		|	DocItemList.Ref.Branch AS Branch,
		|	DocItemList.Ref.LegalNameContract AS LegalNameContract,
		|	DocItemList.PriceType,
		|	DocItemList.Ref.Company.TradeAgentStore AS TradeAgentStore
		|INTO ItemList
		|FROM
		|	Document.SalesReportFromTradeAgent.ItemList AS DocItemList
		|WHERE
		|	DocItemList.Ref = &Ref";
EndFunction

Function Taxes()
	Return 
		"SELECT
		|	DocTaxList.Ref.Date AS Period,
		|	DocTaxList.Ref.Company AS Company,
		|	DocTaxList.Tax AS Tax,
		|	DocTaxList.TaxRate AS TaxRate,
		|	CASE
		|		WHEN DocTaxList.ManualAmount = 0
		|			THEN DocTaxList.Amount
		|		ELSE DocTaxList.ManualAmount
		|	END AS TaxAmount,
		|	DocItemList.NetAmount AS TaxableAmount,
		|	DocItemList.Ref.Branch AS Branch
		|INTO Taxes
		|FROM
		|	Document.SalesReportFromTradeAgent.ItemList AS DocItemList
		|		INNER JOIN Document.SalesReportFromTradeAgent.TaxList AS DocTaxList
		|		ON DocItemList.Key = DocTaxList.Key
		|		AND DocItemList.Ref = &Ref
		|		AND DocTaxList.Ref = &Ref";
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
		|	ItemList.Ref.Agreement AS Agreement
		|INTO SerialLotNumbers
		|FROM
		|	Document.SalesReportFromTradeAgent.SerialLotNumbers AS SerialLotNumbers
		|		LEFT JOIN Document.SalesReportFromTradeAgent.ItemList AS ItemList
		|		ON SerialLotNumbers.Key = ItemList.Key
		|		AND ItemList.Ref = &Ref
		|WHERE
		|	SerialLotNumbers.Ref = &Ref";
EndFunction

Function SourceOfOrigins()
	Return
		"SELECT
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
		|	SUM(SourceOfOrigins.Quantity) AS Quantity
		|INTO SourceOfOrigins
		|FROM
		|	Document.SalesReportFromTradeAgent.SourceOfOrigins AS SourceOfOrigins
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
		|	SourceOfOrigins.SourceOfOrigin";
EndFunction

Function R9010B_SourceOfOriginStock()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.TradeAgentStore AS Store,
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
		|GROUP BY
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.TradeAgentStore,
		|	ItemList.ItemKey,
		|	SourceOfOrigins.SourceOfOriginStock,
		|	SourceOfOrigins.SerialLotNumber";
EndFunction

Function R2001T_Sales()
	Return 
		"SELECT
		|	*
		|INTO R2001T_Sales
		|FROM
		|	ItemList AS ItemList
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
		|	TRUE";
EndFunction

Function R4050B_StockInventory()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.TradeAgentStore AS Store,
		|	ItemList.ItemKey,
		|	SUM(ItemList.Quantity) AS Quantity
		|INTO R4050B_StockInventory
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|
		|GROUP BY
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.TradeAgentStore,
		|	ItemList.ItemKey";
EndFunction

Function R4010B_ActualStocks()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.TradeAgentStore AS Store,
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
		|GROUP BY
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.Period,
		|	ItemList.TradeAgentStore,
		|	ItemList.ItemKey,
		|	CASE
		|		WHEN SerialLotNumbers.StockBalanceDetail
		|			THEN SerialLotNumbers.SerialLotNumber
		|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		|	END";
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
		|	UNDEFINED AS Order,
		|	SUM(ItemList.Amount) AS Amount,
		|	UNDEFINED AS CustomersAdvancesClosing
		|INTO R2021B_CustomersTransactions
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	TRUE
		|GROUP BY
		|	ItemList.Agreement,
		|	ItemList.Basis,
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
		|	TRUE
		|GROUP BY
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.LegalName,
		|	ItemList.LegalNameContract,
		|	ItemList.Currency,
		|	ItemList.Period,
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
		|	TRUE";
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
	|	UNDEFINED AS Order,
	|	TRUE AS IsCustomerTransaction,
	|	ItemList.Basis AS TransactionBasis,
	|	SUM(ItemList.Amount) AS Amount,
	|	TRUE AS IsDue
	|INTO T2015S_TransactionsInfo
	|FROM
	|	ItemList AS ItemList
	|WHERE
	|	TRUE
	|GROUP BY
	|	ItemList.Period,
	|	ItemList.Company,
	|	ItemList.Branch,
	|	ItemList.Currency,
	|	ItemList.Partner,
	|	ItemList.LegalName,
	|	ItemList.Agreement,
	|	ItemList.Basis";
EndFunction

Function T6020S_BatchKeysInfo()
	Return
		"SELECT
		|	ItemLIst.Key,
		|	ItemList.ItemKey,
		|	ItemList.TradeAgentStore AS Store,
		|	ItemList.Company,
		|	ItemList.Quantity AS Quantity,
		|	ItemList.Period,
		|	VALUE(Enum.BatchDirection.Expense) AS Direction
		|INTO BatchKeysInfo_1
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Product)
		|;
		|////////////////////////////////////////////////////////////////////////
		|SELECT
		|	BatchKeysInfo_1.ItemKey,
		|	BatchKeysInfo_1.Store,
		|	BatchKeysInfo_1.Company,
		|	SUM(CASE
		|		WHEN ISNULL(SourceOfOrigins.Quantity, 0) <> 0
		|			THEN ISNULL(SourceOfOrigins.Quantity, 0)
		|		ELSE BatchKeysInfo_1.Quantity
		|	END) AS Quantity,
		|	BatchKeysInfo_1.Period,
		|	BatchKeysInfo_1.Direction,
		|	ISNULL(SourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)) AS SourceOfOrigin,
		|	ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber
		|INTO T6020S_BatchKeysInfo
		|FROM
		|	BatchKeysInfo_1 AS BatchKeysInfo_1
		|		LEFT JOIN SourceOfOrigins AS SourceOfOrigins
		|		ON BatchKeysInfo_1.Key = SourceOfOrigins.Key
		|GROUP BY
		|	BatchKeysInfo_1.ItemKey,
		|	BatchKeysInfo_1.Store,
		|	BatchKeysInfo_1.Company,
		|	BatchKeysInfo_1.Period,
		|	BatchKeysInfo_1.Direction,
		|	ISNULL(SourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)),
		|	ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef))";
EndFunction

Function R8010B_TradeAgentInventory()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.ItemKey,
		|	ItemList.Partner,
		|	ItemList.Agreement,
		|	ItemList.LegalName,
		|	SUM(ItemList.Quantity) AS Quantity
		|INTO R8010B_TradeAgentInventory
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|GROUP BY
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.ItemKey,
		|	ItemList.Partner,
		|	ItemList.Agreement,
		|	ItemList.LegalName";
EndFunction

Function R8011B_TradeAgentSerialLotNumber()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
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
		|	TRUE";
EndFunction
