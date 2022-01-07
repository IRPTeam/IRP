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
	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref, "Document.RetailSalesReceipt.ItemList");
	
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
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.RetailSalesReceipt.ItemList", AddInfo);
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
	QueryArray.Add(RetailSales());
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
		   |	Document.RetailSalesReceipt.RowIDInfo AS RowIDInfo
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
		   |	ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
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
		   |	ItemList.Key AS RowKey,
		   |	ItemList.Ref.UsePartnerTransactions AS UsePartnerTransactions,
		   |	ItemList.Ref.Branch AS Branch,
		   |	ItemList.Ref.LegalNameContract AS LegalNameContract
		   |INTO ItemList
		   |FROM
		   |	Document.RetailSalesReceipt.ItemList AS ItemList
		   |WHERE
		   |	ItemList.Ref = &Ref";
EndFunction

Function Payments()
	Return "SELECT
		   |	Payments.Ref.Date AS Period,
		   |	Payments.Ref.Company AS Company,
		   |	Payments.Ref.Branch AS Branch,
		   |	Payments.Account AS Account,
		   |	Payments.Ref.Currency AS Currency,
		   |	Payments.Amount AS Amount,
		   |	Payments.PaymentType AS PaymentType,
		   |	Payments.PaymentTerminal AS PaymentTerminal,
		   |	Payments.BankTerm AS BankTerm,
		   |	Payments.Percent AS Percent,
		   |	Payments.Commission AS Commission
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
		|	Document.RetailSalesReceipt.SerialLotNumbers AS SerialLotNumbers
		|		LEFT JOIN Document.RetailSalesReceipt.ItemList AS ItemList
		|		ON SerialLotNumbers.Key = ItemList.Key
		|		AND ItemList.Ref = &Ref
		|WHERE
		|	SerialLotNumbers.Ref = &Ref";
EndFunction

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

Function R3010B_CashOnHand()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R3010B_CashOnHand
		   |FROM
		   |	Payments AS Payments
		   |WHERE
		   |	TRUE";
EndFunction

Function R4011B_FreeStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	*
		   |INTO R4011B_FreeStocks
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.IsService";
EndFunction

Function R4010B_ActualStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	*
		   |INTO R4010B_ActualStocks
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.IsService";
EndFunction

Function R3050T_RetailCash()
	Return "SELECT
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
		   |	ItemList.Period
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
		|	Document.RetailSalesReceipt.ItemList AS ItemList
		|		INNER JOIN Document.RetailSalesReceipt.RowIDInfo AS RowIDInfo
		|		ON RowIDInfo.Ref = &Ref
		|		AND ItemList.Ref = &Ref
		|		AND RowIDInfo.Key = ItemList.Key
		|		AND RowIDInfo.Ref = ItemList.Ref";
EndFunction

#EndRegion
