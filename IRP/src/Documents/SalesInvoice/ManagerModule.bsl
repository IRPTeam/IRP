#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function Print(Ref, Param) Export
	If StrCompare(Param.NameTemplate, "SalesInvoicePrint") = 0 Then
		Return SalesInvoicePrint(Ref, Param);
	EndIf;
EndFunction

// Sales Invoice print.
// 
// Parameters:
//  Ref - DocumentRef.SalesInvoice
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Sales Invoice print
Function SalesInvoicePrint(Ref, Param)
		
	Template = GetTemplate("SalesInvoicePrint");
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
	|	Document.SalesInvoice AS DocumentHeader
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
	|	Document.SalesInvoice.ItemList AS DocumentItemList
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

	Tables.Insert("CustomersTransactions", PostingServer.GetQueryTableByName("CustomersTransactions", Parameters));

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
	
	If Ref.TransactionType = Enums.SalesTransactionTypes.CurrencyRevaluationCustomer 
		Or Ref.TransactionType = Enums.SalesTransactionTypes.CurrencyRevaluationVendor Then
		CurrenciesServer.CurrencyRevaluationInvoice(Ref, Parameters, "R2021B_CustomersTransactions", AddInfo);
	EndIf;
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
		"Document.SalesInvoice.ItemList");

	If Not Unposting And Ref.Agreement.UseCreditLimit Then
		CreditLimitsServer.CheckCreditLimit(Ref, Cancel);
	EndIf;

	If Cancel Then
		Return;
	EndIf;

	CheckAfterWrite_CheckStockBalance(Ref, Cancel, Parameters, AddInfo);

	If Not Cancel And Not AccReg.R4014B_SerialLotNumber.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R4014B_SerialLotNumber", Parameters), PostingServer.GetQueryTableByName(
		"Exists_R4014B_SerialLotNumber", Parameters), AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;

	If Not Cancel And Not AccReg.R2001T_Sales.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R2001T_Sales", Parameters), PostingServer.GetQueryTableByName(
		"Exists_R2001T_Sales", Parameters), AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure CheckAfterWrite_CheckStockBalance(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("RecordType", AccumulationRecordType.Expense);
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.SalesInvoice.ItemList", AddInfo);
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
	StrParams.Insert("Vat", TaxesServer.GetVatRef());
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(ItemListLandedCost());
	QueryArray.Add(OffersInfo());
	QueryArray.Add(SerialLotNumbers());
	QueryArray.Add(SourceOfOrigins());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4014B_SerialLotNumber());
	QueryArray.Add(PostingServer.Exists_R2001T_Sales());
	QueryArray.Add(PostingServer.Exists_R4050B_StockInventory());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R2001T_Sales());
	QueryArray.Add(R2005T_SalesSpecialOffers());
	QueryArray.Add(R2011B_SalesOrdersShipment());
	QueryArray.Add(R2012B_SalesOrdersInvoiceClosing());
	QueryArray.Add(R2013T_SalesOrdersProcurement());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R2022B_CustomersPaymentPlanning());
	QueryArray.Add(R2031B_ShipmentInvoicing());
	QueryArray.Add(R2040B_TaxesIncoming());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4012B_StockReservation());
	QueryArray.Add(R4014B_SerialLotNumber());
	QueryArray.Add(R4032B_GoodsInTransitOutgoing());
	QueryArray.Add(R4034B_GoodsShipmentSchedule());
	QueryArray.Add(R4050B_StockInventory());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5011B_CustomersAging());
	QueryArray.Add(R5021T_Revenues());
	QueryArray.Add(R6080T_OtherPeriodsRevenues());
	QueryArray.Add(R8014T_ConsignorSales());
	QueryArray.Add(R9010B_SourceOfOriginStock());
	QueryArray.Add(T2015S_TransactionsInfo());
	QueryArray.Add(T3010S_RowIDInfo());
	QueryArray.Add(T6020S_BatchKeysInfo());
	QueryArray.Add(T1040T_AccountingAmounts());
	QueryArray.Add(T1050T_AccountingQuantities());
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
	       |	Document.SalesInvoice.RowIDInfo AS RowIDInfo
	       |WHERE
	       |	RowIDInfo.Ref = &Ref
	       |
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
	       |
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
	       |				AND SalesInvoiceItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
	       |			THEN SalesInvoiceItemList.Ref.Agreement.StandardAgreement
	       |		ELSE SalesInvoiceItemList.Ref.Agreement
	       |	END AS Agreement,
	       |	SalesInvoiceItemList.Ref.Currency AS Currency,
	       |	SalesInvoiceItemList.Unit AS Unit,
	       |	SalesInvoiceItemList.Ref.Date AS Period,
	       |	SalesInvoiceItemList.Ref.PriceIncludeTax AS PriceIncludeTax,
	       |	SalesInvoiceItemList.SalesOrder AS SalesOrder,
	       |	CASE
	       |		WHEN SalesInvoiceItemList.Ref.Agreement.UseOrdersForSettlements
	       |			THEN SalesInvoiceItemList.SalesOrder
	       |		ELSE UNDEFINED
	       |	END AS SalesOrderSettlements,
	       |	NOT SalesInvoiceItemList.SalesOrder.Ref IS NULL AS SalesOrderExists,
	       |	TableRowIDInfo.RowID AS RowKey,
	       |	SalesInvoiceItemList.DeliveryDate AS DeliveryDate,
	       |	SalesInvoiceItemList.IsService AS IsService,
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
	       |	SalesInvoiceItemList.Key AS Key,
	       |	SalesInvoiceItemList.Ref.Branch AS Branch,
	       |	SalesInvoiceItemList.Ref.LegalNameContract AS LegalNameContract,
	       |	SalesInvoiceItemList.PriceType AS PriceType,
	       |	SalesInvoiceItemList.Price AS Price,
	       |	SalesInvoiceItemList.SalesPerson AS SalesPerson,
	       |(SalesInvoiceItemList.Ref.TransactionType = VALUE(Enum.SalesTransactionTypes.Sales)
	       |	OR SalesInvoiceItemList.Ref.TransactionType = VALUE(Enum.SalesTransactionTypes.CurrencyRevaluationCustomer)
	       |	OR SalesInvoiceItemList.Ref.TransactionType = VALUE(Enum.SalesTransactionTypes.CurrencyRevaluationVendor)) AS IsSales,
	       |
	       |	SalesInvoiceItemList.Ref.TransactionType = VALUE(Enum.SalesTransactionTypes.ShipmentToTradeAgent) AS IsShipmentToTradeAgent,
	       |	SalesInvoiceItemList.Ref.Company.TradeAgentStore AS TradeAgentStore,
	       |	SalesInvoiceItemList.InventoryOrigin = VALUE(Enum.InventoryOriginTypes.OwnStocks) AS IsOwnStocks,
	       |	SalesInvoiceItemList.InventoryOrigin = VALUE(Enum.InventoryOriginTypes.ConsignorStocks) AS IsConsignorStocks,
	       |	SalesInvoiceItemList.InventoryOrigin AS InventoryOrigin,
	       |	SalesInvoiceItemList.VatRate AS VatRate,
	       |	SalesInvoiceItemList.TaxAmount AS TaxAmount,
	       |	SalesInvoiceItemList.Project AS Project,
	       |	SalesInvoiceItemList.OtherPeriodRevenueType AS OtherPeriodRevenueType,
	       |
	       |	case when SalesInvoiceItemList.ItemKey = SalesInvoiceItemList.Ref.Company.CurrencyRevaluationItemKey 
	       |				then true else false end AS IsCurrencyRevaluation,
	       |	ISNULL(SalesInvoiceItemList.Ref.CurrencyRevaluationInvoice.Ref, Undefined) AS CurrencyRevaluationInvoice
	       |
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
	       |	SalesInvoiceShipmentConfirmations.Key AS Key,
	       |	SalesInvoiceShipmentConfirmations.ShipmentConfirmation AS ShipmentConfirmation,
	       |	SalesInvoiceShipmentConfirmations.Quantity AS Quantity
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
		|	ItemList.ProfitLossCenter AS ProfitLossCenter,
		|	ItemList.RevenueType AS RevenueType,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.AdditionalAnalytic AS AdditionalAnalytic,
		|	ItemList.NetAmount AS NetAmount,
		|	ItemList.TaxAmount AS TaxAmount,
		|	ItemList.IsService AS IsService,
		|	TableRowIDInfo.RowID AS RowID,
		|	ItemList.OtherPeriodRevenueType AS OtherPeriodRevenueType,
		|	ItemList.OtherPeriodRevenueType = VALUE(Enum.OtherPeriodRevenueType.ItemsRevenue) AS IsItemsRevenue,
		|	ItemList.OtherPeriodRevenueType = VALUE(Enum.OtherPeriodRevenueType.RevenueAccruals) AS IsRevenueAccruals
		|INTO ItemListLandedCost
		|FROM
		|	Document.SalesInvoice.ItemList AS ItemList
		|		LEFT JOIN TableRowIDInfo AS TableRowIDInfo
		|		ON ItemList.Key = TableRowIDInfo.Key
		|WHERE
		|	ItemList.Ref = &Ref";
EndFunction

Function OffersInfo()
	Return "SELECT
		   |	SalesInvoiceItemList.Ref.Date AS Period,
		   |	SalesInvoiceItemList.Ref AS Invoice,
		   |	TableRowIDInfo.RowID AS RowKey,
		   |	SalesInvoiceItemList.ItemKey,
		   |	SalesInvoiceItemList.Ref.Company AS Company,
		   |	SalesInvoiceItemList.Ref.Currency,
		   |	SalesInvoiceSpecialOffers.Offer AS SpecialOffer,
		   |	SalesInvoiceSpecialOffers.Amount AS OffersAmount,
		   |	SalesInvoiceSpecialOffers.Bonus AS OffersBonus,
		   |	SalesInvoiceSpecialOffers.AddInfo AS OffersAddInfo,
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

Function SerialLotNumbers()
	Return "SELECT
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
		   |	Document.SalesInvoice.SourceOfOrigins AS SourceOfOrigins
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

#EndRegion

#Region Posting_MainTables

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
		   |	ItemList.IsSales
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
		|	ItemList.IsSales";
EndFunction

Function R2005T_SalesSpecialOffers()
	Return "SELECT
		   |	*
		   |INTO R2005T_SalesSpecialOffers
		   |FROM
		   |	OffersInfo AS OffersInfo
		   |WHERE
		   |	TRUE";
EndFunction

Function R2011B_SalesOrdersShipment()
	Return "SELECT
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
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.Period AS Period,
		   |	ItemList.Company AS Company,
		   |	ItemList.Branch AS Branch,
		   |	ItemList.SalesOrder AS Order,
		   |	ItemList.Currency AS Currency,
		   |	ItemList.ItemKey AS ItemKey,
		   |	ItemList.RowKey AS RowKey,
		   |	ItemList.Quantity AS Quantity,
		   |	ItemList.Amount AS Amount,
		   |	ItemList.NetAmount AS NetAmount
		   |INTO R2012B_SalesOrdersInvoiceClosing
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.SalesOrderExists";
EndFunction

Function R2013T_SalesOrdersProcurement()
	Return "SELECT
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.SalesOrder AS Order,
		   |	ItemList.ItemKey,
		   |	ItemList.RowKey,
		   |	ItemList.Quantity AS SalesQuantity,
		   |	ItemList.NetAmount AS SalesNetAmount,
		   |	ItemList.Amount AS SalesTotalAmount
		   |INTO R2013T_SalesOrdersProcurement
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.IsService
		   |	AND ItemList.SalesOrderExists";
EndFunction

Function R2031B_ShipmentInvoicing()
	Return "SELECT
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
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	&Vat AS Tax,
		|	ItemList.VatRate AS TaxRate,
		|	SUM(ItemList.TaxAmount) AS Amount,
		|	VALUE(Enum.InvoiceType.Invoice) AS InvoiceType
		|INTO R2040B_TaxesIncoming
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsSales
		|	AND ItemList.TaxAmount <> 0
		|GROUP BY
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.VatRate,
		|	VALUE(Enum.InvoiceType.Invoice)";
EndFunction

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
		   |	END";
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
	Return "SELECT
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
		   |	AND (ItemList.UseShipmentConfirmation
		   |	OR ItemList.ShipmentConfirmationExists)";
EndFunction

Function R4050B_StockInventory()
	Return "SELECT
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

Function R4034B_GoodsShipmentSchedule()
	Return "SELECT
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
	Return AccumulationRegisters.R2020B_AdvancesFromCustomers.R2020B_AdvancesFromCustomers_SI_SR_SOC_SRFTA();
EndFunction

Function R2021B_CustomersTransactions() 
	Return AccumulationRegisters.R2021B_CustomersTransactions.R2021B_CustomersTransactions_SI_SRFTA();
EndFunction

Function R5011B_CustomersAging()
	Return AccumulationRegisters.R5011B_CustomersAging.R5011B_CustomersAging_SI();
EndFunction

Function R5010B_ReconciliationStatement()
	Return "SELECT
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
	Return "SELECT
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
	|	ItemList.Period AS Period,
	|	ItemList.Company AS Company,
	|	ItemList.Branch AS Branch,
	|	ItemList.ProfitLossCenter AS ProfitLossCenter,
	|	ItemList.RevenueType AS RevenueType,
	|	ItemList.ItemKey AS ItemKey,
	|	ItemList.Currency AS Currency,
	|	ItemList.AdditionalAnalytic AS AdditionalAnalytic,
	|	ItemList.Project AS Project,
	|	ItemList.NetAmount AS Amount,
	|	ItemList.Amount AS AmountWithTaxes
	|INTO R5021T_Revenues
	|FROM
	|	ItemList AS ItemList
	|WHERE
	|	ItemList.IsSales
	|	AND ItemList.OtherPeriodRevenueType = VALUE(ENUM.OtherPeriodRevenueType.EmptyRef)";
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
		   |	Document.SalesInvoice.ItemList AS ItemList
		   |		INNER JOIN Document.SalesInvoice.RowIDInfo AS RowIDInfo
		   |		ON RowIDInfo.Ref = &Ref
		   |		AND ItemList.Ref = &Ref
		   |		AND RowIDInfo.Key = ItemList.Key
		   |		AND RowIDInfo.Ref = ItemList.Ref";
EndFunction

Function T2015S_TransactionsInfo() 
	Return InformationRegisters.T2015S_TransactionsInfo.T2015S_TransactionsInfo_SI_SRFTA();
EndFunction

Function R6080T_OtherPeriodsRevenues()
	Return	
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period AS Period,
		|	ItemList.Company AS Company,
		|	ItemList.Branch AS Branch,
		|	ItemList.Basis AS Basis,
		|	CASE
		|		WHEN ItemList.IsItemsRevenue
		|			THEN ItemList.RowID
		|	END AS RowID,
		|	CASE
		|		WHEN ItemList.IsItemsRevenue
		|			THEN ItemList.ItemKey
		|	END AS ItemKey,
		|	ItemList.Currency AS Currency,
		|	ItemList.OtherPeriodRevenueType AS OtherPeriodRevenueType,
		|	ItemList.NetAmount AS Amount,
		|	CASE
		|		WHEN ItemList.IsItemsRevenue
		|			THEN ItemList.TaxAmount
		|	END AS AmountTax
		|INTO R6080T_OtherPeriodsRevenues
		|FROM
		|	ItemListLandedCost AS ItemList
		|WHERE
		|	ItemList.IsItemsRevenue
		|	OR ItemList.IsRevenueAccruals";
EndFunction

Function T6020S_BatchKeysInfo()
	Return 
		"SELECT
		|	ItemList.Key,
		|	ItemList.ItemKey,
		|	ItemList.Store,
		|	ItemList.Company,
		|	ItemList.InventoryOrigin = VALUE(Enum.InventoryOriginTypes.ConsignorStocks) AS IsConsignorBatches,
		|	ItemList.Quantity AS Quantity,
		|	ItemList.Period,
		|	VALUE(Enum.BatchDirection.Expense) AS Direction
		|INTO BatchKeysInfo_1
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|;
		|
		|//////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ItemList.Key,
		|	ItemList.ItemKey,
		|	ItemList.TradeAgentStore,
		|	ItemList.Company,
		|	ItemList.InventoryOrigin = VALUE(Enum.InventoryOriginTypes.ConsignorStocks) AS IsConsignorBatches,
		|	ItemList.Quantity AS Quantity,
		|	ItemList.Period,
		|	VALUE(Enum.BatchDirection.Receipt) AS Direction
		|INTO BatchKeysInfo_2
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|	AND ItemList.IsShipmentToTradeAgent
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	BatchKeysInfo_1.ItemKey,
		|	BatchKeysInfo_1.Store,
		|	BatchKeysInfo_1.Company,
		|	CASE
		|		WHEN ISNULL(SourceOfOrigins.Quantity, 0) <> 0
		|			THEN ISNULL(SourceOfOrigins.Quantity, 0)
		|		ELSE BatchKeysInfo_1.Quantity
		|	END AS Quantity,
		|	BatchKeysInfo_1.Period,
		|	BatchKeysInfo_1.Direction,
		|	ISNULL(SourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)) AS SourceOfOrigin,
		|	ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber
		|INTO BatchKeysInfo
		|FROM
		|	BatchKeysInfo_1 AS BatchKeysInfo_1
		|		LEFT JOIN SourceOfOrigins AS SourceOfOrigins
		|		ON BatchKeysInfo_1.Key = SourceOfOrigins.Key
		|
		|UNION ALL
		|
		|SELECT
		|	BatchKeysInfo_2.ItemKey,
		|	BatchKeysInfo_2.TradeAgentStore,
		|	BatchKeysInfo_2.Company,
		|	CASE
		|		WHEN ISNULL(SourceOfOrigins.Quantity, 0) <> 0
		|			THEN ISNULL(SourceOfOrigins.Quantity, 0)
		|		ELSE BatchKeysInfo_2.Quantity
		|	END AS Quantity,
		|	BatchKeysInfo_2.Period,
		|	BatchKeysInfo_2.Direction,
		|	ISNULL(SourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)),
		|	ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef))
		|FROM
		|	BatchKeysInfo_2 AS BatchKeysInfo_2
		|		LEFT JOIN SourceOfOrigins AS SourceOfOrigins
		|		ON BatchKeysInfo_2.Key = SourceOfOrigins.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	BatchKeysInfo.ItemKey,
		|	BatchKeysInfo.Store,
		|	BatchKeysInfo.Company,
		|	SUM(ISNULL(BatchKeysInfo.Quantity, 0)) AS Quantity,
		|	BatchKeysInfo.Period,
		|	BatchKeysInfo.Direction,
		|	BatchKeysInfo.SourceOfOrigin,
		|	BatchKeysInfo.SerialLotNumber
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
		|	ItemList.Amount,
		|	ItemList.Quantity,
		|	SourceOfOrigins.SerialLotNumber,
		|	SourceOfOrigins.SourceOfOrigin
		|INTO R8014T_ConsignorSales
		|FROM
		|	ItemList AS ItemList
		|		LEFT JOIN SourceOfOrigins AS SourceOfOrigins
		|		ON ItemList.Key = SourceOfOrigins.Key
		|WHERE
		|	ItemList.IsConsignorStocks";
EndFunction
		 
Function R5020B_PartnersBalance()
	Return AccumulationRegisters.R5020B_PartnersBalance.R5020B_PartnersBalance_SI();
EndFunction
		 
#EndRegion

#Region AccessObject

// Get access key.
// 
// Parameters:
//  Obj - DocumentObject.SalesInvoice -
// 
// Returns:
//  Map
Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	AccessKeyMap.Insert("Company", Obj.Company);
	AccessKeyMap.Insert("Branch", Obj.Branch);
	CopyTable = Obj.ItemList.Unload(, "Store");
	CopyTable.GroupBy("Store");
	AccessKeyMap.Insert("Store", CopyTable.UnloadColumn("Store"));
	Return AccessKeyMap;
EndFunction

#EndRegion

#Region Accounting

Function T1040T_AccountingAmounts()
	Return 
		"SELECT
		|	ItemList.Period,
		|	ItemList.Key AS RowKey,
		|	ItemList.Currency,
		|	ItemList.NetAmount AS Amount,
		|	VALUE(Catalog.AccountingOperations.SalesInvoice_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|INTO T1040T_AccountingAmounts
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsSales
		|
		|UNION ALL
		|
		|SELECT
		|	ItemList.Period,
		|	ItemList.Key AS RowKey,
		|	ItemList.Currency,
		|	ItemList.TaxAmount,
		|	VALUE(Catalog.AccountingOperations.SalesInvoice_DR_R2021B_CustomersTransactions_CR_R2040B_TaxesIncoming),
		|	UNDEFINED
		|FROM
		|	ItemList as ItemList
		|WHERE
		|	ItemList.IsSales
		|	AND ItemList.TaxAmount <> 0
		|
		|UNION ALL
		|
		|SELECT
		|	T2010S_OffsetOfAdvances.Period,
		|	T2010S_OffsetOfAdvances.Key AS RowKey,
		|	T2010S_OffsetOfAdvances.Currency,
		|	T2010S_OffsetOfAdvances.Amount,
		|	VALUE(Catalog.AccountingOperations.SalesInvoice_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions),
		|	T2010S_OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS T2010S_OffsetOfAdvances
		|WHERE
		|	T2010S_OffsetOfAdvances.Document = &Ref";
EndFunction

Function T1050T_AccountingQuantities()
	Return 
		"SELECT
		|	ItemList.Period,
		|	ItemList.Key AS RowKey,
		|	VALUE(Catalog.AccountingOperations.SalesInvoice_DR_R5022T_Expenses_CR_R4050B_StockInventory) AS Operation,
		|	ItemList.Quantity
		|INTO T1050T_AccountingQuantities
		|FROM
		|	ItemList AS ItemList";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	Operations = Catalogs.AccountingOperations;
	
	If Parameters.Operation = Operations.SalesInvoice_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues Then
		
		Return GetAnalytics_RevenueFromSales(Parameters); // Customer transactions - Revenues
	
	ElsIf Parameters.Operation = Operations.SalesInvoice_DR_R2021B_CustomersTransactions_CR_R2040B_TaxesIncoming Then 
		
		Return GetAnalytics_VATIncoming(Parameters); // Customer transaction - Tax incoming
	
	ElsIf Parameters.Operation = Operations.SalesInvoice_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions Then
			
		Return GetAnalytics_OffsetOfAdvances(Parameters); // Offset of advances (Advances from customer - Customer transactions)
		
	ElsIf Parameters.Operation = Operations.SalesInvoice_DR_R5022T_Expenses_CR_R4050B_StockInventory Then
		Return GetAnalytics_DR_R5022T_CR_R4050B(Parameters); // Expenses (landed cost) - Stock inventory
	EndIf;
	
	Return Undefined;
EndFunction

#Region Accounting_Analytics

// Customer transactions - Revenues
Function GetAnalytics_RevenueFromSales(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                   Parameters.ObjectData.Partner, 
	                                                   Parameters.ObjectData.Agreement,
	                                                   Parameters.ObjectData.Currency);
	                                                   
	AccountingAnalytics.Debit = Debit.AccountTransactionsCustomer;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Partner", Parameters.ObjectData.Partner);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                           Parameters.RowData.RevenueType,
	                                                           Parameters.RowData.ProfitLossCenter);
	If Parameters.RowData.OtherPeriodRevenueType = Enums.OtherPeriodRevenueType.RevenueAccruals Then
		AccountingAnalytics.Credit = Credit.AccountOtherPeriodsRevenue;
	Else
		AccountingAnalytics.Credit = Credit.AccountRevenue;
	EndIf;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);
	Return AccountingAnalytics;
EndFunction

// Customer transactions - Taxes incoming
Function GetAnalytics_VATIncoming(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
	
	// Debit
	Debit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                   Parameters.ObjectData.Partner, 
	                                                   Parameters.ObjectData.Agreement,
	                                                   Parameters.ObjectData.Currency);
	                                                   
	AccountingAnalytics.Debit = Debit.AccountTransactionsCustomer;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Partner", Parameters.ObjectData.Partner);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9013S_AccountsTax(AccountParameters, Parameters.RowData.TaxInfo);
	AccountingAnalytics.Credit = Credit.IncomingAccount;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, Parameters.RowData.TaxInfo);
	
	Return AccountingAnalytics;
EndFunction

// Offset of advances (Customer transactions - Advances from customer)
Function GetAnalytics_OffsetOfAdvances(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
	
	Accounts = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                      Parameters.ObjectData.Partner, 
	                                                      Parameters.ObjectData.Agreement,
	                                                      Parameters.ObjectData.Currency);

	// Debit
	AccountingAnalytics.Debit = Accounts.AccountAdvancesCustomer;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Partner", Parameters.ObjectData.Partner);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	AccountingAnalytics.Credit = Accounts.AccountTransactionsCustomer;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Partner", Parameters.ObjectData.Partner);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);
	
	Return AccountingAnalytics;
EndFunction

// Expenses (landed cost) - Stock inventory 
Function GetAnalytics_DR_R5022T_CR_R4050B(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
															  Parameters.ObjectData.Company.LandedCostExpenseType,
															  Parameters.RowData.ProfitLossCenter);
	AccountingAnalytics.Debit = Debit.AccountExpense;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("ExpenseType", Parameters.ObjectData.Company.LandedCostExpenseType);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9010S_AccountsItemKey(AccountParameters, Parameters.RowData.ItemKey);
	AccountingAnalytics.Credit = Credit.Account;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value, AdditionalAnalytics, Number) Export
	Return Value;
EndFunction

Function GetHintCreditExtDimension(Parameters, ExtDimensionType, Value, AdditionalAnalytics, Number) Export
	Return Value;
EndFunction

#EndRegion

#EndRegion