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
#Region NewRegistersPosting
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
	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref, "Document.RetailReturnReceipt.ItemList");
	
	CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo);
	
	If Not Cancel And Not AccReg.R4014B_SerialLotNumber.CheckBalance(Ref, LineNumberAndItemKeyFromItemList, 
		PostingServer.GetQueryTableByName("R4014B_SerialLotNumber", Parameters), 
		PostingServer.GetQueryTableByName("R4014B_SerialLotNumber_Exists", Parameters),
		AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.RetailReturnReceipt.ItemList", AddInfo);
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
	QueryArray.Add(Payments());
	QueryArray.Add(RetailReturn());
	QueryArray.Add(OffersInfo());
	QueryArray.Add(SerialLotNumbers());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	QueryArray.Add(PostingServer.Exists_R4014B_SerialLotNumber());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R3010B_CashOnHand());
	QueryArray.Add(R3050T_RetailCash());
	QueryArray.Add(R2050T_RetailSales());
	QueryArray.Add(R5021T_Revenues());
	QueryArray.Add(R2001T_Sales());
	QueryArray.Add(R2005T_SalesSpecialOffers());
	QueryArray.Add(R2002T_SalesReturns());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R4014B_SerialLotNumber());
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
		   |	Document.RetailReturnReceipt.RowIDInfo AS RowIDInfo
		   |WHERE
		   |	RowIDInfo.Ref = &Ref
		   |GROUP BY
		   |	RowIDInfo.Ref,
		   |	RowIDInfo.Key
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	ItemList.Ref.Company AS Company,
		   |	ItemList.Store AS Store,
		   |	ItemList.ItemKey AS ItemKey,
		   |	ItemList.Ref AS SalesReturn,
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
		   |	ISNULL(ItemList.Ref.Currency, VALUE(Catalog.Currencies.EmptyRef)) AS Currency,
		   |	ItemList.Ref.Date AS Period,
		   |	CASE
		   |		WHEN ItemList.RetailSalesReceipt = VALUE(Document.RetailSalesReceipt.EmptyRef)
		   |			THEN ItemList.Ref
		   |		ELSE ItemList.RetailSalesReceipt
		   |	END AS RetailSalesReceipt,
		   |	ItemList.Key AS RowKey,
		   |	ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
		   |	ItemList.ProfitLossCenter AS ProfitLossCenter,
		   |	ItemList.RevenueType AS RevenueType,
		   |	ItemList.AdditionalAnalytic AS AdditionalAnalytic,
		   |	ItemList.NetAmount AS NetAmount,
		   |	ItemList.OffersAmount AS OffersAmount,
		   |	ItemList.ReturnReason AS ReturnReason,
		   |	CASE
		   |		WHEN ItemList.RetailSalesReceipt.Ref IS NULL
		   |			THEN ItemList.Ref
		   |		ELSE ItemList.RetailSalesReceipt
		   |	END AS Invoice,
		   |	CASE
		   |		WHEN ItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		   |			THEN ItemList.Ref
		   |		ELSE UNDEFINED
		   |	END AS BasisDocument,
		   |	ItemList.Ref.UsePartnerTransactions AS UsePartnerTransactions,
		   |	ItemList.Ref.Branch AS Branch,
		   |	ItemList.Ref.LegalNameContract AS LegalNameContract
		   |INTO ItemList
		   |FROM
		   |	Document.RetailReturnReceipt.ItemList AS ItemList
		   |WHERE
		   |	ItemList.Ref = &Ref";
EndFunction

Function Payments()
	Return "SELECT
		   |	Payments.Ref.Date AS Period,
		   |	Payments.Ref.Company AS Company,
		   |	Payments.Account AS Account,
		   |	Payments.Ref.Currency AS Currency,
		   |	Payments.Amount AS Amount,
		   |	Payments.Ref.Branch AS Branch,
		   |	Payments.PaymentType AS PaymentType,
		   |	Payments.PaymentTerminal AS PaymentTerminal,
		   |	Payments.Percent AS Percent,
		   |	Payments.Commission AS Commission
		   |INTO Payments
		   |FROM
		   |	Document.RetailReturnReceipt.Payments AS Payments
		   |WHERE
		   |	Payments.Ref = &Ref";
EndFunction

Function OffersInfo()
	Return "SELECT
		   |	RetailReturnReceiptItemList.Ref.Date AS Period,
		   |	RetailReturnReceiptItemList.RetailSalesReceipt AS Invoice,
		   |	TableRowIDInfo.RowID AS RowKey,
		   |	RetailReturnReceiptItemList.ItemKey,
		   |	RetailReturnReceiptItemList.Ref.Company AS Company,
		   |	RetailReturnReceiptItemList.Ref.Currency,
		   |	RetailReturnReceiptSpecialOffers.Offer AS SpecialOffer,
		   |	- RetailReturnReceiptSpecialOffers.Amount AS OffersAmount,
		   |	- RetailReturnReceiptItemList.TotalAmount AS SalesAmount,
		   |	- RetailReturnReceiptItemList.NetAmount AS NetAmount,
		   |	RetailReturnReceiptItemList.Ref.Branch AS Branch
		   |INTO OffersInfo
		   |FROM
		   |	Document.RetailReturnReceipt.ItemList AS RetailReturnReceiptItemList
		   |		INNER JOIN Document.RetailReturnReceipt.SpecialOffers AS RetailReturnReceiptSpecialOffers
		   |		ON RetailReturnReceiptItemList.Key = RetailReturnReceiptSpecialOffers.Key
		   |		AND RetailReturnReceiptItemList.Ref = &Ref
		   |		AND RetailReturnReceiptSpecialOffers.Ref = &Ref
		   |		INNER JOIN TableRowIDInfo AS TableRowIDInfo
		   |		ON RetailReturnReceiptItemList.Key = TableRowIDInfo.Key";
EndFunction

Function RetailReturn()
	Return "SELECT
	|	RetailReturnReceiptItemList.Ref.Branch AS Branch,
	|	RetailReturnReceiptItemList.Ref.Company AS Company,
	|	RetailReturnReceiptItemList.ItemKey AS ItemKey,
	|	SUM(RetailReturnReceiptItemList.QuantityInBaseUnit) AS Quantity,
	|	SUM(ISNULL(RetailReturnReceiptSerialLotNumbers.Quantity, 0)) AS QuantityBySerialLtNumbers,
	|	RetailReturnReceiptItemList.Ref.Date AS Period,
	|	CASE
	|		WHEN RetailReturnReceiptItemList.RetailSalesReceipt = VALUE(Document.RetailSalesReceipt.EmptyRef)
	|			THEN RetailReturnReceiptItemList.Ref
	|		ELSE RetailReturnReceiptItemList.RetailSalesReceipt
	|	END AS RetailSalesReceipt,
	|	SUM(RetailReturnReceiptItemList.TotalAmount) AS Amount,
	|	SUM(RetailReturnReceiptItemList.NetAmount) AS NetAmount,
	|	SUM(RetailReturnReceiptItemList.OffersAmount) AS OffersAmount,
	|	RetailReturnReceiptItemList.Key AS RowKey,
	|	RetailReturnReceiptSerialLotNumbers.SerialLotNumber AS SerialLotNumber,
	|	RetailReturnReceiptItemList.Store
	|INTO tmpRetailReturn
	|FROM
	|	Document.RetailReturnReceipt.ItemList AS RetailReturnReceiptItemList
	|		LEFT JOIN Document.RetailReturnReceipt.SerialLotNumbers AS RetailReturnReceiptSerialLotNumbers
	|		ON RetailReturnReceiptItemList.Key = RetailReturnReceiptSerialLotNumbers.Key
	|		AND RetailReturnReceiptItemList.Ref = RetailReturnReceiptSerialLotNumbers.Ref
	|		AND RetailReturnReceiptItemList.Ref = &Ref
	|		AND RetailReturnReceiptSerialLotNumbers.Ref = &Ref
	|WHERE
	|	RetailReturnReceiptItemList.Ref = &Ref
	|GROUP BY
	|	RetailReturnReceiptItemList.Ref.Branch,
	|	RetailReturnReceiptItemList.Ref.Company,
	|	RetailReturnReceiptItemList.ItemKey,
	|	RetailReturnReceiptItemList.Ref.Date,
	|	CASE
	|		WHEN RetailReturnReceiptItemList.RetailSalesReceipt = VALUE(Document.RetailSalesReceipt.EmptyRef)
	|			THEN RetailReturnReceiptItemList.Ref
	|		ELSE RetailReturnReceiptItemList.RetailSalesReceipt
	|	END,
	|	RetailReturnReceiptItemList.Key,
	|	RetailReturnReceiptSerialLotNumbers.SerialLotNumber,
	|	RetailReturnReceiptItemList.Store
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpRetailReturn.Company AS Company,
	|	tmpRetailReturn.Branch AS Branch,
	|	tmpRetailReturn.ItemKey AS ItemKey,
	|	CASE
	|		WHEN tmpRetailReturn.QuantityBySerialLtNumbers = 0
	|			THEN -tmpRetailReturn.Quantity
	|		ELSE -tmpRetailReturn.QuantityBySerialLtNumbers
	|	END AS Quantity,
	|	tmpRetailReturn.Period AS Period,
	|	tmpRetailReturn.RetailSalesReceipt AS RetailSalesReceipt,
	|	tmpRetailReturn.RowKey AS RowKey,
	|	tmpRetailReturn.SerialLotNumber AS SerialLotNumber,
	|	CASE
	|		WHEN tmpRetailReturn.QuantityBySerialLtNumbers <> 0
	|			THEN CASE
	|				WHEN tmpRetailReturn.Quantity = 0
	|					THEN 0
	|				ELSE -tmpRetailReturn.Amount / tmpRetailReturn.Quantity * tmpRetailReturn.QuantityBySerialLtNumbers
	|			END
	|		ELSE tmpRetailReturn.Amount
	|	END AS Amount,
	|	CASE
	|		WHEN tmpRetailReturn.QuantityBySerialLtNumbers <> 0
	|			THEN CASE
	|				WHEN tmpRetailReturn.Quantity = 0
	|					THEN 0
	|				ELSE -tmpRetailReturn.NetAmount / tmpRetailReturn.Quantity * tmpRetailReturn.QuantityBySerialLtNumbers
	|			END
	|		ELSE tmpRetailReturn.NetAmount
	|	END AS NetAmount,
	|	CASE
	|		WHEN tmpRetailReturn.QuantityBySerialLtNumbers <> 0
	|			THEN CASE
	|				WHEN tmpRetailReturn.Quantity = 0
	|					THEN 0
	|				ELSE -tmpRetailReturn.OffersAmount / tmpRetailReturn.Quantity * tmpRetailReturn.QuantityBySerialLtNumbers
	|			END
	|		ELSE tmpRetailReturn.OffersAmount
	|	END AS OffersAmount,
	|	tmpRetailReturn.Store
	|INTO RetailReturn
	|FROM
	|	tmpRetailReturn AS tmpRetailReturn";
EndFunction

Function SerialLotNumbers()
	Return 
		"SELECT
		|	SerialLotNumbers.Ref.Date AS Period,
		|	SerialLotNumbers.Ref.Company AS Company,
		|	SerialLotNumbers.Ref.Branch AS Branch,
		|	SerialLotNumbers.Key,
		|	SerialLotNumbers.SerialLotNumber,
		|	SerialLotNumbers.Quantity,
		|	ItemList.ItemKey AS ItemKey
		|INTO SerialLotNumbers
		|FROM
		|	Document.RetailReturnReceipt.SerialLotNumbers AS SerialLotNumbers
		|		LEFT JOIN Document.RetailReturnReceipt.ItemList AS ItemList
		|		ON SerialLotNumbers.Key = ItemList.Key
		|		AND ItemList.Ref = &Ref
		|WHERE
		|	SerialLotNumbers.Ref = &Ref";
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

Function R2001T_Sales()
	Return "SELECT
		   |	ItemList.RetailSalesReceipt AS Invoice,
		   |	- ItemList.Quantity AS Quantity,
		   |	- ItemList.TotalAmount AS Amount,
		   |	- ItemList.NetAmount AS NetAmount,
		   |	- ItemList.OffersAmount AS OffersAmount,
		   |	*
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

Function R3010B_CashOnHand()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	*
		   |INTO R3010B_CashOnHand
		   |FROM
		   |	Payments AS Payments
		   |WHERE
		   |	TRUE";
EndFunction

Function R4011B_FreeStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R4011B_FreeStocks
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.IsService";
EndFunction

Function R4010B_ActualStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R4010B_ActualStocks
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.IsService";
EndFunction

Function R3050T_RetailCash()
	Return "SELECT
		   |	- Payments.Amount AS Amount,
		   |	*
		   |INTO R3050T_RetailCash
		   |FROM
		   |	Payments AS Payments
		   |WHERE
		   |	TRUE";
EndFunction

Function R2050T_RetailSales()
	Return "SELECT
		   |	*
		   |INTO R2050T_RetailSales
		   |FROM
		   |	RetailReturn AS RetailReturn
		   |WHERE
		   |	TRUE";
EndFunction

Function R5021T_Revenues()
	Return "SELECT
		   |	*,
		   |	- ItemList.NetAmount AS Amount,
		   |	- ItemList.TotalAmount AS AmountWithTaxes
		   |INTO R5021T_Revenues
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE";
EndFunction

Function R2002T_SalesReturns()
	Return "SELECT
		   |	*,
		   |	ItemList.TotalAmount AS Amount
		   |INTO R2002T_SalesReturns
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE";
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
		   |	- SUM(ItemList.TotalAmount) AS Amount,
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
		   |	VALUE(AccumulationRecordType.Expense)";
EndFunction

Function R5010B_ReconciliationStatement()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.LegalName,
		   |	ItemList.LegalNameContract,
		   |	ItemList.Currency,
		   |	- SUM(ItemList.TotalAmount) AS Amount,
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
		   |	ItemList.Period
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Receipt),
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
		   |	ItemList.Period";
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
		|	Document.RetailReturnReceipt.ItemList AS ItemList
		|		INNER JOIN Document.RetailReturnReceipt.RowIDInfo AS RowIDInfo
		|		ON RowIDInfo.Ref = &Ref
		|		AND ItemList.Ref = &Ref
		|		AND RowIDInfo.Key = ItemList.Key
		|		AND RowIDInfo.Ref = ItemList.Ref";
EndFunction

#EndRegion