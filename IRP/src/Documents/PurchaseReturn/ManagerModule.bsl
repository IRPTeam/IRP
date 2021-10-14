#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
#Region NewRegistersPosting
	QueryArray = GetQueryTextsSecondaryTables();
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
	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref, "Document.PurchaseReturn.ItemList");

	CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo);
	
	If Not Cancel And Not AccReg.R4014B_SerialLotNumber.CheckBalance(Ref, LineNumberAndItemKeyFromItemList, 
		PostingServer.GetQueryTableByName("R4014B_SerialLotNumber", Parameters), 
		PostingServer.GetQueryTableByName("R4014B_SerialLotNumber_Exists", Parameters),
		AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;	
EndProcedure

Procedure CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("RecordType", AccumulationRecordType.Expense);
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.PurchaseReturn.ItemList", AddInfo);
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
	QueryArray.Add(SerialLotNumbers());
	QueryArray.Add(OffersInfo());
	QueryArray.Add(ShipmentConfirmationsInfo());
	QueryArray.Add(Taxes());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	QueryArray.Add(PostingServer.Exists_R4014B_SerialLotNumber());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R1001T_Purchases());
	QueryArray.Add(R1002T_PurchaseReturns());
	QueryArray.Add(R1005T_PurchaseSpecialOffers());
	QueryArray.Add(R1012B_PurchaseOrdersInvoiceClosing());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R1031B_ReceiptInvoicing());
	QueryArray.Add(R1040B_TaxesOutgoing());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4014B_SerialLotNumber());
	QueryArray.Add(R4032B_GoodsInTransitOutgoing());
	QueryArray.Add(R4050B_StockInventory());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5022T_Expenses());
	QueryArray.Add(T2012S_PartnerAdvances());
	QueryArray.Add(R5012B_VendorsAging());
	QueryArray.Add(R5021T_Revenues());
	QueryArray.Add(T3010S_RowIDInfo());
	Return QueryArray;
EndFunction

Function ItemList()
	Return "SELECT
		   |	RowIDInfo.Ref AS Ref,
		   |	RowIDInfo.Key AS Key,
		   |	MAX(RowIDInfo.RowID) AS RowID
		   |INTO TableRowIDInfo
		   |FROM
		   |	Document.PurchaseReturn.RowIDInfo AS RowIDInfo
		   |WHERE
		   |	RowIDInfo.Ref = &Ref
		   |GROUP BY
		   |	RowIDInfo.Ref,
		   |	RowIDInfo.Key
		   |;
		   |
		   ////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	ShipmentConfirmations.Key,
		   |	ShipmentConfirmations.ShipmentConfirmation
		   |INTO ShipmentConfirmations
		   |FROM
		   |	Document.PurchaseReturn.ShipmentConfirmations AS ShipmentConfirmations
		   |WHERE
		   |	ShipmentConfirmations.Ref = &Ref
		   |GROUP BY
		   |	ShipmentConfirmations.Key,
		   |	ShipmentConfirmations.ShipmentConfirmation
		   |;
		   |
		   ////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	PurchaseReturnItemList.Ref.Company AS Company,
		   |	PurchaseReturnItemList.Store AS Store,
		   |	PurchaseReturnItemList.UseShipmentConfirmation AS UseShipmentConfirmation,
		   |	NOT ShipmentConfirmations.Key IS NULL AS ShipmentConfirmationExists,
		   |	ShipmentConfirmations.ShipmentConfirmation,
		   |	PurchaseReturnItemList.ItemKey AS ItemKey,
		   |	PurchaseReturnItemList.PurchaseReturnOrder AS PurchaseReturnOrder,
		   |	NOT PurchaseReturnItemList.PurchaseReturnOrder.Ref IS NULL AS PurchaseReturnOrderExists,
		   |	PurchaseReturnItemList.Ref AS PurchaseReturn,
		   |	CASE
		   |		WHEN PurchaseReturnItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		   |			THEN CASE
		   |				WHEN NOT PurchaseReturnItemList.PurchaseInvoice.Ref IS NULL
		   |					THEN PurchaseReturnItemList.PurchaseInvoice
		   |				ELSE PurchaseReturnItemList.Ref
		   |			END
		   |		ELSE UNDEFINED
		   |	END AS BasisDocument,
		   |	PurchaseReturnItemList.Ref AS AdvanceBasis,
		   |	PurchaseReturnItemList.Ref.DueAsAdvance AS DueAsAdvance,
		   |	PurchaseReturnItemList.QuantityInBaseUnit AS Quantity,
		   |	PurchaseReturnItemList.TotalAmount AS TotalAmount,
		   |	PurchaseReturnItemList.TotalAmount AS Amount,
		   |	PurchaseReturnItemList.Ref.Partner AS Partner,
		   |	PurchaseReturnItemList.Ref.LegalName AS LegalName,
		   |	CASE
		   |		WHEN PurchaseReturnItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		   |		AND PurchaseReturnItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		   |			THEN PurchaseReturnItemList.Ref.Agreement.StandardAgreement
		   |		ELSE PurchaseReturnItemList.Ref.Agreement
		   |	END AS Agreement,
		   |	ISNULL(PurchaseReturnItemList.Ref.Currency, VALUE(Catalog.Currencies.EmptyRef)) AS Currency,
		   |	PurchaseReturnItemList.Ref.Date AS Period,
		   |	CASE
		   |		WHEN PurchaseReturnItemList.PurchaseInvoice.Ref IS NULL
		   |		OR VALUETYPE(PurchaseReturnItemList.PurchaseInvoice) <> TYPE(Document.PurchaseInvoice)
		   |			THEN PurchaseReturnItemList.Ref
		   |		ELSE PurchaseReturnItemList.PurchaseInvoice
		   |	END AS PurchaseInvoice,
		   |	TableRowIDInfo.RowID AS RowKey,
		   |	PurchaseReturnItemList.Key,
		   |	PurchaseReturnItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
		   |	PurchaseReturnItemList.NetAmount,
		   |	PurchaseReturnItemList.PurchaseInvoice AS Invoice,
		   |	PurchaseReturnItemList.ReturnReason,
		   |	PurchaseReturnItemList.ProfitLossCenter AS ProfitLossCenter,
		   |	PurchaseReturnItemList.ExpenseType AS ExpenseType,
		   |	PurchaseReturnItemList.RevenueType AS RevenueType,
		   |	PurchaseReturnItemList.AdditionalAnalytic AS AdditionalAnalytic,
		   |	PurchaseReturnItemList.Ref.Branch AS Branch,
		   |	PurchaseReturnItemList.Ref.LegalNameContract AS LegalNameContract,
		   |	PurchaseReturnItemList.OffersAmount,
		   |	PurchaseReturnItemList.Detail AS Detail
		   |INTO ItemList
		   |FROM
		   |	Document.PurchaseReturn.ItemList AS PurchaseReturnItemList
		   |		LEFT JOIN ShipmentConfirmations AS ShipmentConfirmations
		   |		ON PurchaseReturnItemList.Key = ShipmentConfirmations.Key
		   |		LEFT JOIN TableRowIDInfo AS TableRowIDInfo
		   |		ON PurchaseReturnItemList.Key = TableRowIDInfo.Key
		   |WHERE
		   |	PurchaseReturnItemList.Ref = &Ref";
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
		   |	Document.PurchaseReturn.SerialLotNumbers AS SerialLotNumbers
		   |		LEFT JOIN Document.PurchaseReturn.ItemList AS ItemList
		   |		ON SerialLotNumbers.Key = ItemList.Key
		   |		AND ItemList.Ref = &Ref
		   |WHERE
		   |	SerialLotNumbers.Ref = &Ref";
EndFunction

Function OffersInfo()
	Return "SELECT
		   |	PurchaseReturnItemList.Ref.Date AS Period,
		   |	PurchaseReturnItemList.Ref AS Invoice,
		   |	PurchaseReturnItemList.Key AS RowKey,
		   |	PurchaseReturnItemList.ItemKey,
		   |	PurchaseReturnItemList.Ref.Company AS Company,
		   |	PurchaseReturnItemList.Ref.Currency AS Currency,
		   |	PurchaseReturnSpecialOffers.Offer AS SpecialOffer,
		   |	PurchaseReturnSpecialOffers.Amount AS OffersAmount,
		   |	PurchaseReturnItemList.TotalAmount AS SalesAmount,
		   |	PurchaseReturnItemList.NetAmount AS NetAmount,
		   |	PurchaseReturnItemList.Ref.Branch AS Branch
		   |INTO OffersInfo
		   |FROM
		   |	Document.PurchaseReturn.ItemList AS PurchaseReturnItemList
		   |		INNER JOIN Document.PurchaseReturn.SpecialOffers AS PurchaseReturnSpecialOffers
		   |		ON PurchaseReturnItemList.Key = PurchaseReturnSpecialOffers.Key
		   |		AND PurchaseReturnItemList.Ref = &Ref
		   |		AND PurchaseReturnSpecialOffers.Ref = &Ref";
EndFunction

Function ShipmentConfirmationsInfo()
	Return "SELECT
		   |	PurchaseReturnShipmentConfirmations.Key,
		   |	PurchaseReturnShipmentConfirmations.ShipmentConfirmation,
		   |	PurchaseReturnShipmentConfirmations.Quantity,
		   |	PurchaseReturnShipmentConfirmations.QuantityInShipmentConfirmation
		   |INTO ShipmentConfirmationsInfo
		   |FROM
		   |	Document.PurchaseReturn.ShipmentConfirmations AS PurchaseReturnShipmentConfirmations
		   |WHERE
		   |	PurchaseReturnShipmentConfirmations.Ref = &Ref";
EndFunction

Function Taxes()
	Return "SELECT
		   |	PurchaseReturnTaxList.Ref.Date AS Period,
		   |	PurchaseReturnTaxList.Ref.Company AS Company,
		   |	PurchaseReturnTaxList.Tax AS Tax,
		   |	PurchaseReturnTaxList.TaxRate AS TaxRate,
		   |	CASE
		   |		WHEN PurchaseReturnTaxList.ManualAmount = 0
		   |			THEN PurchaseReturnTaxList.Amount
		   |		ELSE PurchaseReturnTaxList.ManualAmount
		   |	END AS TaxAmount,
		   |	PurchaseReturnItemList.NetAmount AS TaxableAmount,
		   |	PurchaseReturnItemList.Ref.Branch AS Branch
		   |INTO Taxes
		   |FROM
		   |	Document.PurchaseReturn.ItemList AS PurchaseReturnItemList
		   |		INNER JOIN Document.PurchaseReturn.TaxList AS PurchaseReturnTaxList
		   |		ON PurchaseReturnItemList.Key = PurchaseReturnTaxList.Key
		   |		AND PurchaseReturnItemList.Ref = &Ref
		   |		AND PurchaseReturnTaxList.Ref = &Ref";
EndFunction

Function R1001T_Purchases()
	Return "SELECT 
		   |	- ItemList.Quantity AS Quantity,
		   |	- ItemList.Amount AS Amount,
		   |	- ItemList.NetAmount AS NetAmount,
		   |	- ItemList.OffersAmount AS OffersAmount,
		   |	ItemList.PurchaseInvoice AS Invoice,
		   |	*
		   |INTO R1001T_Purchases
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE TRUE";
EndFunction

Function R1002T_PurchaseReturns()
	Return "SELECT
		   |	ItemList.PurchaseInvoice AS Invoice, 
		   |	*
		   |INTO R1002T_PurchaseReturns
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE TRUE";

EndFunction

Function R1005T_PurchaseSpecialOffers()
	Return "SELECT *
		   |INTO R1005T_PurchaseSpecialOffers
		   |FROM
		   |	OffersInfo AS OffersInfo
		   |WHERE TRUE";

EndFunction

Function R1012B_PurchaseOrdersInvoiceClosing()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.PurchaseReturnOrder AS Order,
		   |	*
		   |INTO R1012B_PurchaseOrdersInvoiceClosing
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.PurchaseReturnOrderExists";

EndFunction

Function R1021B_VendorsTransactions()
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
		   |	UNDEFINED AS VendorsAdvancesClosing,
		   |	-SUM(ItemList.Amount) AS Amount
		   |INTO R1021B_VendorsTransactions
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

Function R1020B_AdvancesToVendors()
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
		   |	UNDEFINED AS VendorsAdvancesClosing
		   |INTO R1020B_AdvancesToVendors
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

Function R5012B_VendorsAging()
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
		   |INTO R5012B_VendorsAging
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
		   |	TRUE AS IsVendorAdvance
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

Function R1031B_ReceiptInvoicing()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.PurchaseReturn AS Basis,
		   |	ItemList.Quantity AS Quantity,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.Period,
		   |	ItemList.ItemKey,
		   |	ItemList.Store
		   |INTO R1031B_ReceiptInvoicing
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.UseShipmentConfirmation
		   |	AND NOT ItemList.ShipmentConfirmationExists
		   |	AND NOT ItemList.IsService
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
		   |		ON ItemList.RowKey = ShipmentConfirmations.Key
		   |WHERE
		   |	TRUE";

EndFunction

Function R1040B_TaxesOutgoing()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	- Taxes.TaxableAmount,
		   |	- Taxes.TaxAmount,
		   |	*
		   |INTO R1040B_TaxesOutgoing
		   |FROM
		   |	Taxes AS Taxes
		   |WHERE TRUE";

EndFunction

Function R4010B_ActualStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	*
		   |INTO R4010B_ActualStocks
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.IsService
		   |	AND NOT ItemList.UseShipmentConfirmation
		   |	AND NOT ItemList.ShipmentConfirmationExists";

EndFunction

Function R4011B_FreeStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.Period AS Period,
		   |	ItemList.Store AS Store,
		   |	ItemList.ItemKey AS ItemKey,
		   |	ItemList.Quantity AS Quantity
		   |INTO R4011B_FreeStocks
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.IsService
		   |	AND NOT ItemList.UseShipmentConfirmation
		   |	AND NOT ItemList.ShipmentConfirmationExists";

EndFunction

Function R4014B_SerialLotNumber()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	*
		   |INTO R4014B_SerialLotNumber
		   |FROM
		   |	SerialLotNumbers AS QueryTable
		   |WHERE 
		   |	TRUE";

EndFunction

Function R4032B_GoodsInTransitOutgoing()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	CASE
		   |		WHEN ItemList.ShipmentConfirmationExists
		   |			Then ItemList.ShipmentConfirmation
		   |		Else ItemList.PurchaseReturn
		   |	End AS Basis,
		   |	*
		   |INTO R4032B_GoodsInTransitOutgoing
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.IsService
		   |	AND (ItemList.UseShipmentConfirmation
		   |		OR ItemList.ShipmentConfirmationExists)";

EndFunction

Function R4050B_StockInventory()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	*
		   |INTO R4050B_StockInventory
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.IsService";

EndFunction

Function R5010B_ReconciliationStatement()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.Company AS Company,
		   |	ItemList.Branch AS Branch,
		   |	ItemList.LegalName AS LegalName,
		   |	ItemList.LegalNameContract AS LegalNameContract,
		   |	ItemList.Currency AS Currency,
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

Function R5022T_Expenses()
	Return "SELECT
		   |	*,
		   |	- ItemList.NetAmount AS Amount,
		   |	- ItemList.TotalAmount AS AmountWithTaxes
		   |INTO R5022T_Expenses
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.IsService";
EndFunction

Function R5021T_Revenues()
	Return 
		"SELECT
		|	*,
		|	ItemList.NetAmount AS Amount,
		|	ItemList.TotalAmount AS AmountWithTaxes
		|INTO R5021T_Revenues
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.DueAsAdvance";
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
		|	Document.PurchaseReturn.ItemList AS ItemList
		|		INNER JOIN Document.PurchaseReturn.RowIDInfo AS RowIDInfo
		|		ON RowIDInfo.Ref = &Ref
		|		AND ItemList.Ref = &Ref
		|		AND RowIDInfo.Key = ItemList.Key
		|		AND RowIDInfo.Ref = ItemList.Ref";
EndFunction
