#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	Parameters.IsReposting = False;
#Region NewRegistersPosting
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion
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
	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref, "Document.SalesReturn.ItemList");
	
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.SalesReturn.ItemList", AddInfo);
	
	If Not Cancel And Not AccReg.R4014B_SerialLotNumber.CheckBalance(Ref, LineNumberAndItemKeyFromItemList, 
		PostingServer.GetQueryTableByName("R4014B_SerialLotNumber", Parameters), 
		PostingServer.GetQueryTableByName("R4014B_SerialLotNumber_Exists", Parameters),
		AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
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
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array();
	QueryArray.Add(ItemList());
	QueryArray.Add(OffersInfo());
	QueryArray.Add(GoodReceiptInfo());
	QueryArray.Add(Taxes());
	QueryArray.Add(SerialLotNumbers());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4014B_SerialLotNumber());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R2001T_Sales());
	QueryArray.Add(R2002T_SalesReturns());
	QueryArray.Add(R2005T_SalesSpecialOffers());
	QueryArray.Add(R2012B_SalesOrdersInvoiceClosing());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(R2031B_ShipmentInvoicing());
	QueryArray.Add(R2040B_TaxesIncoming());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4014B_SerialLotNumber());
	QueryArray.Add(R4031B_GoodsInTransitIncoming());
	QueryArray.Add(R4050B_StockInventory());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5021T_Revenues());
	QueryArray.Add(T2012S_PartnerAdvances());
	QueryArray.Add(R5011B_CustomersAging());
	Return QueryArray;
EndFunction

Function ItemList()
	Return "SELECT
	|	RowIDInfo.Ref AS Ref,
	|	RowIDInfo.Key AS Key,
	|	MAX(RowIDInfo.RowID) AS RowID
	|INTO TableRowIDInfo
	|FROM
	|	Document.SalesReturn.RowIDInfo AS RowIDInfo
	|WHERE
	|	RowIDInfo.Ref = &Ref
	|GROUP BY
	|	RowIDInfo.Ref,
	|	RowIDInfo.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	GoodsReceipts.Key,
	|	GoodsReceipts.GoodsReceipt
	|INTO GoodsReceipts
	|FROM
	|	Document.SalesReturn.GoodsReceipts AS GoodsReceipts
	|WHERE
	|	GoodsReceipts.Ref = &Ref
	|GROUP BY
	|	GoodsReceipts.Key,
	|	GoodsReceipts.GoodsReceipt
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList.Ref.Company AS Company,
	|	ItemList.Store AS Store,
	|	ItemList.UseGoodsReceipt AS UseGoodsReceipt,
	|	ItemList.ItemKey AS ItemKey,
	|	ItemList.SalesReturnOrder AS SalesReturnOrder,
	|	NOT ItemList.SalesReturnOrder.Ref IS NULL AS SalesReturnOrderExists,
	|	ItemList.Ref AS SalesReturn,
	|	CASE
	|		WHEN ItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
	|			THEN CASE
	|				WHEN ItemList.SalesInvoice.Ref IS NULL
	|					THEN ItemList.Ref
	|				ELSE ItemList.SalesInvoice
	|			END
	|		ELSE UNDEFINED
	|	END AS BasisDocument,
	|	ItemList.Ref AS AdvanceBasis,
	|	ItemList.Ref.DueAsAdvance AS DueAsAdvance,
	|	ItemList.QuantityInBaseUnit AS Quantity,
	|	ItemList.TotalAmount AS Amount,
	|	ItemList.Ref.Partner AS Partner,
	|	ItemList.Ref.LegalName AS LegalName,
	|	CASE
	|		WHEN ItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
	|		AND ItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
	|			THEN ItemList.Ref.Agreement.StandardAgreement
	|		ELSE ItemList.Ref.Agreement
	|	END AS Agreement,
	|	ISNULL(ItemList.Ref.Currency, VALUE(Catalog.Currencies.EmptyRef)) AS Currency,
	|	ItemList.Ref.Date AS Period,
	|	CASE
	|		WHEN ItemList.SalesInvoice.Ref IS NULL
	|		OR VALUETYPE(ItemList.SalesInvoice) <> TYPE(Document.SalesInvoice)
	|			THEN ItemList.Ref
	|		ELSE ItemList.SalesInvoice
	|	END AS SalesInvoice,
	|	ItemList.SalesInvoice AS AgingSalesInvoice,
	|	TableRowIDInfo.RowID AS RowKey,
	|	NOT GoodsReceipts.Key IS NULL AS GoodsReceiptExists,
	|	GoodsReceipts.GoodsReceipt,
	|	ItemList.NetAmount,
	|	ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
	|	ItemList.ReturnReason,
	|	ItemList.ProfitLossCenter AS ProfitLossCenter,
	|	ItemList.RevenueType AS RevenueType,
	|	ItemList.AdditionalAnalytic AS AdditionalAnalytic,
	|	ItemList.Ref.Branch AS Branch,
	|	ItemList.Ref.LegalNameContract AS LegalNameContract,
	|	ItemList.OffersAmount,
	|	ItemList.PriceType
	|INTO ItemList
	|FROM
	|	Document.SalesReturn.ItemList AS ItemList
	|		LEFT JOIN GoodsReceipts AS GoodsReceipts
	|		ON ItemList.Key = GoodsReceipts.Key
	|		LEFT JOIN TableRowIDInfo AS TableRowIDInfo
	|		ON ItemList.Key = TableRowIDInfo.Key
	|WHERE
	|	ItemList.Ref = &Ref";
EndFunction

Function GoodReceiptInfo()
	Return "SELECT
		   |	GoodReceiptInfo.Key,
		   |	GoodReceiptInfo.GoodsReceipt,
		   |	GoodReceiptInfo.Quantity
		   |INTO GoodReceiptInfo
		   |FROM
		   |	Document.SalesReturn.GoodsReceipts AS GoodReceiptInfo
		   |WHERE
		   |	GoodReceiptInfo.Ref = &Ref";
EndFunction

Function OffersInfo()
	Return "SELECT
		   |	SalesReturnItemList.Ref.Date AS Period,
		   |	SalesReturnItemList.Key AS RowKey,
		   |	SalesReturnItemList.ItemKey,
		   |	SalesReturnItemList.Ref.Company AS Company,
		   |	SalesReturnItemList.Ref.Branch AS Branch,
		   |	SalesReturnItemList.Ref.Currency,
		   |	SalesReturnSpecialOffers.Offer AS SpecialOffer,
		   |	SalesReturnItemList.SalesInvoice AS Invoice,
		   |	-SalesReturnSpecialOffers.Amount AS OffersAmount,
		   |	-SalesReturnItemList.TotalAmount AS SalesAmount,
		   |	-SalesReturnItemList.NetAmount AS NetAmount
		   |INTO OffersInfo
		   |FROM
		   |	Document.SalesReturn.ItemList AS SalesReturnItemList
		   |		INNER JOIN Document.SalesReturn.SpecialOffers AS SalesReturnSpecialOffers
		   |		ON SalesReturnItemList.Key = SalesReturnSpecialOffers.Key
		   |		AND SalesReturnItemList.Ref = &Ref
		   |		AND SalesReturnSpecialOffers.Ref = &Ref";
EndFunction

Function SerialLotNumbers()
	Return "SELECT
		   |	SerialLotNumbers.Ref.Date AS Period,
		   |	SerialLotNumbers.Ref.Company AS Company,
		   |	SerialLotNumbers.Ref.Branch AS Branch,
		   |	SerialLotNumbers.Key,
		   |	SerialLotNumbers.SerialLotNumber,
		   |	SerialLotNumbers.Quantity,
		   |	ItemList.ItemKey AS ItemKey
		   |INTO SerialLotNumbers
		   |FROM
		   |	Document.SalesReturn.SerialLotNumbers AS SerialLotNumbers
		   |		LEFT JOIN Document.SalesReturn.ItemList AS ItemList
		   |		ON SerialLotNumbers.Key = ItemList.Key
		   |		AND ItemList.Ref = &Ref
		   |WHERE
		   |	SerialLotNumbers.Ref = &Ref";
EndFunction

Function Taxes()
	Return "SELECT
		   |	SalesReturnTaxList.Ref.Date AS Period,
		   |	SalesReturnTaxList.Ref.Company AS Company,
		   |	SalesReturnTaxList.Ref.Branch AS Branch,
		   |	SalesReturnTaxList.Tax AS Tax,
		   |	SalesReturnTaxList.TaxRate AS TaxRate,
		   |	CASE
		   |		WHEN SalesReturnTaxList.ManualAmount = 0
		   |			THEN SalesReturnTaxList.Amount
		   |		ELSE SalesReturnTaxList.ManualAmount
		   |	END AS TaxAmount,
		   |	SalesReturnItemList.NetAmount AS TaxableAmount
		   |INTO Taxes
		   |FROM
		   |	Document.SalesReturn.ItemList AS SalesReturnItemList
		   |		INNER JOIN Document.SalesReturn.TaxList AS SalesReturnTaxList
		   |		ON SalesReturnItemList.Key = SalesReturnTaxList.Key
		   |		AND SalesReturnItemList.Ref = &Ref
		   |		AND SalesReturnTaxList.Ref = &Ref";
EndFunction

Function R2001T_Sales()
	Return "SELECT 
		   |	- ItemList.Quantity AS Quantity,
		   |	- ItemList.Amount AS Amount,
		   |	- ItemList.NetAmount AS NetAmount,
		   |	- ItemList.OffersAmount AS OffersAmount,
		   |	ItemList.SalesInvoice AS Invoice,
		   |	*
		   |INTO R2001T_Sales
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE TRUE";

EndFunction

Function R2002T_SalesReturns()
	Return "SELECT 
		   |	ItemList.SalesInvoice AS Invoice,
		   |	*
		   |INTO R2002T_SalesReturns
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE TRUE";

EndFunction

Function R2005T_SalesSpecialOffers()
	Return "SELECT
		   |	*
		   |INTO R2005T_SalesSpecialOffers
		   |FROM
		   |	OffersInfo AS OffersInfo
		   |WHERE TRUE";

EndFunction

Function R2012B_SalesOrdersInvoiceClosing()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.SalesReturnOrder AS Order,
		   |	*
		   |INTO R2012B_SalesOrdersInvoiceClosing
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.SalesReturnOrderExists";

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
		   |	UNDEFINED AS Key,
		   |	UNDEFINED AS CustomersAdvancesClosing,
		   |	-SUM(ItemList.Amount) AS Amount
		   |INTO R2021B_CustomersTransactions
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.DueAsAdvance
		   |GROUP BY
		   |	ItemList.Agreement,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.Currency,
		   |	ItemList.LegalName,
		   |	ItemList.Partner,
		   |	ItemList.Period,
		   |	ItemList.BasisDocument,
		   |	VALUE(AccumulationRecordType.Receipt)
		   |
		   |UNION ALL
		   |
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
		   |	OffsetOfAdvances.Key,
		   |	OffsetOfAdvances.Recorder,
		   |	OffsetOfAdvances.Amount
		   |FROM
		   |	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		   |WHERE
		   |	OffsetOfAdvances.Document = &Ref";
EndFunction

Function R2020B_AdvancesFromCustomers()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.Period AS Period,
		   |	ItemList.Company AS Company,
		   |	ItemList.Branch AS Branch,
		   |	ItemList.Partner AS Partner,
		   |	ItemList.LegalName AS LegalName,
		   |	ItemList.Currency AS Currency,
		   |	ItemList.AdvanceBasis AS Basis,
		   |	SUM(ItemList.Amount) AS Amount,
		   |	UNDEFINED AS Key,
		   |	UNDEFINED AS CustomersAdvancesClosing
		   |INTO R2020B_AdvancesFromCustomers
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.DueAsAdvance
		   |
		   |GROUP BY
		   |	ItemList.Partner,
		   |	ItemList.Branch,
		   |	ItemList.Currency,
		   |	ItemList.Period,
		   |	ItemList.AdvanceBasis,
		   |	ItemList.Company,
		   |	ItemList.LegalName
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense),
		   |	OffsetOfAdvances.Period,
		   |	OffsetOfAdvances.Company,
		   |	OffsetOfAdvances.Branch,
		   |	OffsetOfAdvances.Partner,
		   |	OffsetOfAdvances.LegalName,
		   |	OffsetOfAdvances.Currency,
		   |	OffsetOfAdvances.AdvancesDocument,
		   |	OffsetOfAdvances.Amount,
		   |	UNDEFINED,
		   |	OffsetOfAdvances.Recorder
		   |FROM
		   |	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		   |WHERE
		   |	OffsetOfAdvances.Document = &Ref";
EndFunction

Function R5011B_CustomersAging()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	OffsetOfAging.Period,
		   |	OffsetOfAging.Company,
		   |	OffsetOfAging.Branch,
		   |	OffsetOfAging.Partner,
		   |	OffsetOfAging.Agreement,
		   |	OffsetOfAging.Currency,
		   |	OffsetOfAging.Invoice,
		   |	OffsetOfAging.PaymentDate,
		   |	OffsetOfAging.Amount,
		   |	OffsetOfAging.Recorder AS AgingClosing
		   |INTO R5011B_CustomersAging
		   |FROM
		   |	InformationRegister.T2013S_OffsetOfAging AS OffsetOfAging
		   |WHERE
		   |	OffsetOfAging.Document = &Ref";
EndFunction

Function T2012S_PartnerAdvances()
	Return "SELECT
		   |	ItemList.Period AS Period,
		   |	ItemList.Company AS Company,
		   |	ItemList.Branch AS Branch,
		   |	ItemList.Partner AS Partner,
		   |	ItemList.LegalName AS LegalName,
		   |	ItemList.Currency AS Currency,
		   |	ItemList.AdvanceBasis AS AdvancesDocument,
		   |	SUM(ItemList.Amount) AS Amount,
		   |	UNDEFINED AS Key,
		   |	TRUE AS IsCustomerAdvance
		   |INTO T2012S_PartnerAdvances
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.DueAsAdvance
		   |
		   |GROUP BY
		   |	ItemList.Branch,
		   |	ItemList.LegalName,
		   |	ItemList.Company,
		   |	ItemList.Partner,
		   |	ItemList.Period,
		   |	ItemList.AdvanceBasis,
		   |	ItemList.Currency";
EndFunction

Function R2031B_ShipmentInvoicing()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.SalesReturn AS Basis,
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
		   |	ItemList.UseGoodsReceipt
		   |	AND NOT ItemList.GoodsReceiptExists
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense),
		   |	GoodReceipts.GoodsReceipt,
		   |	GoodReceipts.Quantity,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.Period,
		   |	ItemList.ItemKey,
		   |	ItemList.Store
		   |FROM
		   |	ItemList AS ItemList
		   |		INNER JOIN GoodReceiptInfo AS GoodReceipts
		   |		ON ItemList.RowKey = GoodReceipts.Key
		   |WHERE
		   |	TRUE";
EndFunction

Function R2040B_TaxesIncoming()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	- Taxes.TaxableAmount,
		   |	- Taxes.TaxAmount,
		   |	*
		   |INTO R2040B_TaxesIncoming
		   |FROM
		   |	Taxes AS Taxes
		   |WHERE TRUE";

EndFunction

#Region Stock

Function R4010B_ActualStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.Period,
		   |	ItemList.Store,
		   |	ItemList.ItemKey,
		   |	ItemList.Quantity
		   |INTO R4010B_ActualStocks
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.IsService
		   |	AND NOT ItemList.UseGoodsReceipt
		   |	AND NOT ItemList.GoodsReceiptExists";
EndFunction

Function R4011B_FreeStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.Period,
		   |	ItemList.Store,
		   |	ItemList.ItemKey,
		   |	ItemList.Quantity
		   |INTO R4011B_FreeStocks
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.IsService
		   |	AND NOT ItemList.UseGoodsReceipt
		   |	AND NOT ItemList.GoodsReceiptExists";
EndFunction

Function R4014B_SerialLotNumber()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |*
		   |INTO R4014B_SerialLotNumber
		   |FROM
		   |	SerialLotNumbers AS SerialLotNumbers
		   |WHERE 
		   |	TRUE";

EndFunction

Function R4031B_GoodsInTransitIncoming()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	CASE
		   |		WHEN ItemList.GoodsReceiptExists
		   |			Then ItemList.GoodsReceipt
		   |		Else ItemList.SalesReturn
		   |	End AS Basis,
		   |	*
		   |INTO R4031B_GoodsInTransitIncoming
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.UseGoodsReceipt
		   |	OR ItemList.GoodsReceiptExists";

EndFunction

Function R4050B_StockInventory()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R4050B_StockInventory
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.IsService";

EndFunction

#EndRegion

Function R5010B_ReconciliationStatement()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.LegalName,
		   |	ItemList.LegalNameContract,
		   |	ItemList.Currency,
		   |	- SUM(ItemList.Amount) AS Amount,
		   |	ItemList.Period
		   |INTO R5010B_ReconciliationStatement
		   |FROM
		   |	ItemList AS ItemList
		   |GROUP BY
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.LegalName,
		   |	ItemList.LegalNameContract,
		   |	ItemList.Currency,
		   |	ItemList.Period";
EndFunction

#EndRegion

Function R5021T_Revenues()
	Return "SELECT
		   |	*,
		   |	- ItemList.NetAmount AS Amount,
		   |	- ItemList.Amount AS AmountWithTaxes
		   |INTO R5021T_Revenues
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE";
EndFunction