#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function Print(Ref, Param) Export
	If StrCompare(Param.NameTemplate, "RetailSalesReceiptPrint") = 0 Then
		Return RetailSalesReceiptPrint(Ref, Param);
	EndIf;
EndFunction

// Retail sales receipt print.
// 
// Parameters:
//  Ref - DocumentRef.RetailSalesReceipt
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Sales Invoice print
Function RetailSalesReceiptPrint(Ref, Param)
		
	Template = GetTemplate("RetailSalesReceiptPrint");
	Template.LanguageCode = Param.LayoutLang;
	Query = New Query;
	Text =
	"SELECT
	|	DocumentHeader.Number AS Number,
	|	DocumentHeader.Date AS Date,
	|	DocumentHeader.Company.Description_en AS Company,
	|	DocumentHeader.Partner.Description_en AS Partner,
	|	DocumentHeader.Author AS Author,
	|	DocumentHeader.Ref AS Ref,
	|	DocumentHeader.Currency.Code AS Currency
	|FROM
	|	Document.RetailSalesReceipt AS DocumentHeader
	|WHERE
	|	DocumentHeader.Ref = &Ref
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	DocumentItemList.ItemKey.Item.Description_en AS Item,
	|	DocumentItemList.ItemKey.Description_en AS ItemKey,
	|	DocumentItemList.Quantity AS Quantity,
	|	DocumentItemList.Unit.Description_en AS Unit,
	|	DocumentItemList.Price AS Price,
	|	DocumentItemList.VatRate AS VatRate,
	|	DocumentItemList.TaxAmount AS TaxAmount,
	|	DocumentItemList.TotalAmount AS TotalAmount,
	|	DocumentItemList.NetAmount AS NetAmount,
	|	DocumentItemList.OffersAmount AS OffersAmount,
	|	DocumentItemList.Ref AS Ref,
	|	DocumentItemList.Key AS Key
	|INTO Items
	|FROM
	|	Document.RetailSalesReceipt.ItemList AS DocumentItemList
	|WHERE
	|	DocumentItemList.Ref = &Ref	
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Items.Item AS Item,
	|	Items.ItemKey AS ItemKey,
	|	Items.Quantity AS Quantity,
	|	Items.Unit AS Unit,
	|	Items.Price AS Price,
	|	Items.VatRate AS VatRate,
	|	Items.TaxAmount AS TaxAmount,
	|	Items.TotalAmount AS TotalAmount,
	|	Items.NetAmount AS NetAmount,
	|	Items.OffersAmount AS OffersAmount,
	|	Items.Ref AS Ref,
	|	Items.Key AS Key
	|FROM
	|	Items AS Items";

	LCode = Param.DataLang;
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text, "DocumentHeader.Company", LCode);
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text, "DocumentHeader.Partner", LCode);
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text, "DocumentItemList.ItemKey.Item", LCode);
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text, "DocumentItemList.ItemKey", LCode);
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text, "DocumentItemList.Unit", LCode);
	Query.Text = Text;                                                    

	Query.Parameters.Insert("Ref", Ref);
	Selection = Query.ExecuteBatch();
	SelectionHeader = Selection[0].Select();
	SelectionItems = Selection[2].Unload();
	SelectionItems.Indexes.Add("Ref");

	AreaCaption = Template.GetArea("Caption");
	AreaHeader = Template.GetArea("Header");
	AreaItemListHeader = Template.GetArea("ItemListHeader|ItemColumn");
	AreaItemList = Template.GetArea("ItemList|ItemColumn");
	AreaFooter = Template.GetArea("Footer");
	AreaListHeaderTAX = Template.GetArea("ItemListHeaderTAX|ColumnTAX");
	AreaListTAX = Template.GetArea("ItemListTAX|ColumnTAX");

	Spreadsheet = New SpreadsheetDocument;
	Spreadsheet.LanguageCode = Param.LayoutLang;

	TaxVat = TaxesServer.GetVatRef();
	
	While SelectionHeader.Next() Do
		AreaCaption.Parameters.Fill(SelectionHeader);
		Spreadsheet.Put(AreaCaption);

		AreaHeader.Parameters.Fill(SelectionHeader);
		Spreadsheet.Put(AreaHeader);

		Spreadsheet.Put(AreaItemListHeader);
		AreaListHeaderTAX.Parameters.NameTAX = LocalizationEvents.DescriptionRefLocalization(TaxVat, Spreadsheet.LanguageCode);
		Spreadsheet.Join(AreaListHeaderTAX);
		
		Choice	= New Structure("Ref", SelectionHeader.Ref);
		FindRow = SelectionItems.FindRows(Choice);

		Number = 0;
		TotalSum = 0;
		TotalTax = 0;
		TotalNet = 0;
		TotalOffers = 0;
		For Each It In FindRow Do
			Number = Number + 1;
			AreaItemList.Parameters.Fill(It);
			AreaItemList.Parameters.Number = Number;
			Spreadsheet.Put(AreaItemList);

			AreaListTAX.Parameters.PercentTax = It.VatRate;
			Spreadsheet.Join(AreaListTAX);
			
			TotalSum = TotalSum + It.TotalAmount;
			TotalTax = TotalTax + It.TaxAmount;
			TotalOffers	= TotalOffers + It.OffersAmount;
			TotalNet = TotalNet + It.NetAmount;
		EndDo;
	EndDo;

	AreaFooter.Parameters.Total = TotalSum;
	AreaFooter.Parameters.Currency = SelectionHeader.Currency;
	AreaFooter.Parameters.Total = TotalSum;
	AreaFooter.Parameters.TotalTax = TotalTax;
	AreaFooter.Parameters.TotalNet = TotalNet;
	AreaFooter.Parameters.TotalOffers = TotalOffers;
	AreaFooter.Parameters.Manager = SelectionHeader.Author;
	Spreadsheet.Put(AreaFooter);
	Spreadsheet = UniversalPrintServer.ResetLangSettings(Spreadsheet, Param.LayoutLang);
	Return Spreadsheet;
	
EndFunction	


#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);

	DocumentsServer.SalesBySerialLotNumbers(Parameters);
	
	CurrenciesServer.ExcludePostingDataTable(Parameters, Metadata.InformationRegisters.T6020S_BatchKeysInfo);
	
	AccountingServer.CreateAccountingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo);
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

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R2001T_Sales());
	QueryArray.Add(R2005T_SalesSpecialOffers());
	QueryArray.Add(R2006T_Certificates());
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
	QueryArray.Add(R8014T_ConsignorSales());
	QueryArray.Add(R9010B_SourceOfOriginStock());
	QueryArray.Add(T1050T_AccountingQuantities());
	QueryArray.Add(T2015S_TransactionsInfo());
	QueryArray.Add(T3010S_RowIDInfo());
	QueryArray.Add(T6020S_BatchKeysInfo());
	QueryArray.Add(R5015B_OtherPartnersTransactions());
	QueryArray.Add(R5020B_PartnersBalance());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

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
		   |	ItemList.TotalAmount AS Amount,
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
		   |	ItemList.Ref.StatusType AS StatusType,
		   |	ItemList.Ref AS RetailSalesReceipt,
		   |	ItemList.IsService AS IsService,
		   |	ItemList.ItemKey.Item.ItemType.Type = Value(Enum.ItemTypes.Certificate) AS IsCertificate,
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
		   |	Payments.Ref.StatusType AS StatusType,
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
		   |	Payments.PaymentType.Type = VALUE(Enum.PaymentTypes.PaymentAgent) AS IsPaymentAgent,
		   |	Payments.PaymentType.Type = VALUE(Enum.PaymentTypes.Certificate) AS IsCertificate,
		   |	Payments.Certificate,
		   |	Payments.CashFlowCenter
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
		   |	RetailSalesReceiptItemList.Ref.StatusType AS StatusType,
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
		   |	RetailSalesReceiptItemList.Ref.StatusType,
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
		   |	tmpRetailSales.StatusType AS StatusType,
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
		   |	RetailSalesReceiptItemList.Ref.StatusType AS StatusType,
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
		   |	SerialLotNumbers.Ref.StatusType AS StatusType,
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
		   |	SourceOfOrigins.Ref.StatusType AS StatusType,
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
		   |	SourceOfOrigins.Ref.StatusType,
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
		   |	Payments.Ref.StatusType AS StatusType,
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
		   |	AND Payments.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
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
		   |	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
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
		   |	TRUE
		   |	AND SerialLotNumbers.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
		   |";
		   
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
		   |	OR Payments.IsPaymentAgent OR Payments.IsCertificate)
		   |	AND Payments.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
		   |";
EndFunction

Function R3011T_CashFlow()
	Return "SELECT
		   |	Payments.Period,
		   |	Payments.Company,
		   |	Payments.Branch,
		   |	Payments.Account,
		   |	VALUE(Enum.CashFlowDirections.Incoming) AS Direction,
		   |	Payments.FinancialMovementType,
		   |	Payments.CashFlowCenter,
		   |	Payments.Currency,
		   |	Payments.Amount
		   |INTO R3011T_CashFlow
		   |FROM
		   |	Payments AS Payments
		   |WHERE
		   |	NOT (Payments.IsAdvance
		   |	OR Payments.IsPaymentAgent)
		   |	AND Payments.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";
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
	|	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
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
	|UNION ALL
	|
	|SELECT
	|	VALUE(AccumulationRecordType.Expense),
	|	ItemList.Period,
	|	ItemList.Store,
	|	ItemList.ItemKey,
	|	SUM(ItemList.Quantity)
	|FROM
	|	ItemList AS ItemList
	|WHERE
	|	NOT ItemList.IsService
	|	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.PostponedWithReserve)
	|GROUP BY
	|	ItemList.Period,
	|	ItemList.Store,
	|	ItemList.ItemKey
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
	|	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
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
	|
	|UNION ALL
	|
	|SELECT
	|	VALUE(AccumulationRecordType.Receipt),
	|	ItemList.Period,
	|	ItemList.Invoice,
	|	ItemList.ItemKey,
	|	ItemList.Store,
	|	SUM(ItemList.Quantity)
	|FROM
	|	ItemList AS ItemList
	|WHERE
	|	NOT ItemList.IsService
	|	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.PostponedWithReserve)
	|GROUP BY
	|	ItemList.Period,
	|	ItemList.Invoice,
	|	ItemList.ItemKey,
	|	ItemList.Store
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
		   |	AND ItemList.ShipmentConfirmationExists
		   |    AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";
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
		   |    AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
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
		   |	OR Payments.IsPaymentAgent OR Payments.IsCertificate)
		   |	AND Payments.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";
EndFunction

Function R2050T_RetailSales()
	Return "SELECT
		   |	*
		   |INTO R2050T_RetailSales
		   |FROM
		   |	RetailSales AS RetailSales
		   |WHERE
		   |	TRUE
		   |	AND RetailSales.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";
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
		   |	TRUE
		   |	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";
EndFunction

Function R2001T_Sales()
	Return 
		"SELECT
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.Invoice,
		|	ItemList.ItemKey,
		|	ItemList.RowKey,
		|	ItemList.SalesPerson,
		|	SalesBySerialLotNumbers.SerialLotNumber,
		|	SalesBySerialLotNumbers.Quantity,
		|	SalesBySerialLotNumbers.Amount,
		|	SalesBySerialLotNumbers.NetAmount,
		|	SalesBySerialLotNumbers.OffersAmount
		|INTO R2001T_Sales
		|FROM
		|	ItemList AS ItemList
		|		LEFT JOIN SalesBySerialLotNumbers
		|		ON ItemList.Key = SalesBySerialLotNumbers.Key
		|WHERE
		|	TRUE
		|	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";
EndFunction

Function R2005T_SalesSpecialOffers()
	Return "SELECT *
		   |INTO R2005T_SalesSpecialOffers
		   |FROM
		   |	OffersInfo AS OffersInfo
		   |WHERE 
		   |	TRUE
		   |	AND OffersInfo.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";

EndFunction

Function R2006T_Certificates()
	Return "SELECT
	|	ItemList.Period,
	|	ItemList.Currency,
	|	SerialLotNumbers.SerialLotNumber,
	|	SerialLotNumbers.Quantity AS Quantity,
	|	ItemList.TotalAmount AS Amount,
	|	""Sale"" AS MovementType
	|INTO R2006T_Certificates
	|FROM
	|	ItemList AS ItemList
	|		LEFT JOIN SerialLotNumbers AS SerialLotNumbers
	|		ON ItemList.Key = SerialLotNumbers.Key
	|WHERE
	|	ItemList.IsCertificate
	|   AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
	|
	|UNION ALL
	|
	|SELECT
	|	Payments.Period,
	|	Payments.Currency,
	|	Payments.Certificate,
	|	- 1,
	|	- Payments.Amount,
	|	""Used""
	|FROM
	|	Payments AS Payments
	|WHERE 
	|	Payments.IsCertificate
	|	AND Payments.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";
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
		   |	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
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
		   |	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
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
		   |	OffsetOfAdvances.TransactionAgreement,
		   |	OffsetOfAdvances.TransactionDocument,
		   |	OffsetOfAdvances.TransactionOrder,
		   |	OffsetOfAdvances.Amount,
		   |	OffsetOfAdvances.Recorder
		   |FROM
		   |	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		   |WHERE
		   |	OffsetOfAdvances.Document = &Ref
		   |	AND NOT OffsetOfAdvances.Document = VALUE(ENUM.RetailReceiptStatusTypes.Canceled)";
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
		   |	AND PaymentAgent.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
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
		   |	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
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
		   |	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
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
		   |	AND PaymentAgent.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
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
		   |	AND PaymentAgent.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
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
		   |		AND RowIDInfo.Ref = ItemList.Ref
		   |WHERE
		   |	ItemList.Ref.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";
EndFunction

Function T6020S_BatchKeysInfo()
	Return 
		"SELECT
		|	ItemList.Key AS Key,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.Store AS Store,
		|	ItemList.Company AS Company,
		|	ItemList.InventoryOrigin = VALUE(Enum.InventoryOriginTypes.ConsignorStocks) AS IsConsignorBatches,
		|	ItemList.Quantity AS Quantity,
		|	ItemList.Period AS Period,
		|	VALUE(Enum.BatchDirection.Expense) AS Direction
		|INTO BatchKeysInfo_1
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	BatchKeysInfo_1.ItemKey AS ItemKey,
		|	BatchKeysInfo_1.Store AS Store,
		|	BatchKeysInfo_1.Company AS Company,
		|	BatchKeysInfo_1.Period AS Period,
		|	BatchKeysInfo_1.Direction AS Direction,
		|	CASE
		|		WHEN ISNULL(SourceOfOrigins.Quantity, 0) <> 0
		|			THEN ISNULL(SourceOfOrigins.Quantity, 0)
		|		ELSE BatchKeysInfo_1.Quantity
		|	END AS Quantity,
		|	ISNULL(SourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)) AS SourceOfOrigin,
		|	ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber
		|INTO BatchKeysInfo
		|FROM
		|	BatchKeysInfo_1 AS BatchKeysInfo_1
		|		LEFT JOIN SourceOfOrigins AS SourceOfOrigins
		|		ON BatchKeysInfo_1.Key = SourceOfOrigins.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	BatchKeysInfo.ItemKey AS ItemKey,
		|	BatchKeysInfo.Store AS Store,
		|	BatchKeysInfo.Company AS Company,
		|	BatchKeysInfo.Period AS Period,
		|	BatchKeysInfo.Direction AS Direction,
		|	SUM(BatchKeysInfo.Quantity) AS Quantity,
		|	BatchKeysInfo.SourceOfOrigin AS SourceOfOrigin,
		|	BatchKeysInfo.SerialLotNumber AS SerialLotNumber
		|INTO T6020S_BatchKeysInfo
		|FROM
		|	BatchKeysInfo AS BatchKeysInfo
		|WHERE
		|	TRUE
		|GROUP BY
		|	BatchKeysInfo.ItemKey,
		|	BatchKeysInfo.Store,
		|	BatchKeysInfo.Company,
		|	BatchKeysInfo.Period,
		|	BatchKeysInfo.Direction,
		|	BatchKeysInfo.SourceOfOrigin,
		|	BatchKeysInfo.SerialLotNumber";
EndFunction

Function R8014T_ConsignorSales()
	Return
		"SELECT
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.ItemKey,
		|	ItemList.Unit,
		|	ItemList.Price,
		|	ItemList.PriceType,
		|	ItemList.PriceIncludeTax,
		|	ItemList.Invoice AS SalesInvoice,
		|	ItemList.Currency,
		|	ItemList.NetAmount,
		|	ItemList.TotalAmount AS Amount,
		|	ItemList.Quantity,
		|	SourceOfOrigins.SerialLotNumber,
		|	SourceOfOrigins.SourceOfOrigin
		|INTO R8014T_ConsignorSales
		|FROM
		|	ItemList AS ItemList
		|		LEFT JOIN SourceOfOrigins AS SourceOfOrigins
		|		ON ItemList.Key = SourceOfOrigins.Key
		|WHERE
		|	ItemList.IsConsignorStocks
		|	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";
EndFunction

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
		   |	ItemList.SalesOrderExists
		   |	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";
EndFunction

Function R5020B_PartnersBalance()
	Return AccumulationRegisters.R5020B_PartnersBalance.R5020B_PartnersBalance_RSR();
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
		   |	VALUE(Catalog.AccountingOperations.RetailSalesReceipt_DR_R5022T_Expenses_CR_R4050B_StockInventory) AS Operation,
		   |	ItemList.Quantity
		   |INTO T1050T_AccountingQuantities
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	Operations = Catalogs.AccountingOperations;
	If Parameters.Operation = Operations.RetailSalesReceipt_DR_R5022T_Expenses_CR_R4050B_StockInventory Then
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
		                                                      Parameters.ObjectData.Company.LandedCostExpenseType,
		                                                      Parameters.RowData.ProfitLossCenter);
	AccountingAnalytics.Debit = Debit.AccountExpense;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9010S_AccountsItemKey(AccountParameters, Parameters.RowData.ItemKey);
	AccountingAnalytics.Credit = Credit.Account;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value) Export
	If Parameters.Operation = Catalogs.AccountingOperations.RetailSalesReceipt_DR_R5022T_Expenses_CR_R4050B_StockInventory Then

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
	If Parameters.Operation = Catalogs.AccountingOperations.RetailSalesReceipt_DR_R5022T_Expenses_CR_R4050B_StockInventory
		And ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.Items")) <> Undefined Then
		Return Parameters.RowData.ItemKey.Item;
	EndIf;
	Return Value;
EndFunction

#EndRegion

#EndRegion