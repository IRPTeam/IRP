#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function Print(Ref, Param) Export
	If StrCompare(Param.NameTemplate, "SalesReturnPrint") = 0 Then
		Return SalesReturnPrint(Ref, Param);
	EndIf;
EndFunction

// Sales return print.
// 
// Parameters:
//  Ref - DocumentRef.SalesReturn
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Sales return print
Function SalesReturnPrint(Ref, Param)
		
	Template = GetTemplate("SalesReturnPrint");
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
	|	Document.SalesReturn AS DocumentHeader
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
	|	Document.SalesReturn.ItemList AS DocumentItemList
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
	Parameters.IsReposting = False;
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	
	DocumentsServer.SalesBySerialLotNumbers(Parameters);
	
	Calculate_BatchKeysInfo(Ref, Parameters, AddInfo);

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

Procedure Calculate_BatchKeysInfo(Ref, Parameters, AddInfo)
	Query = New Query;
	Query.Text =
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
	|	SourceOfOrigins.SerialLotNumber AS SerialLotNumberStock,
	|	SUM(SourceOfOrigins.Quantity) AS Quantity
	|INTO tmpSourceOfOrigins
	|FROM
	|	Document.SalesReturn.SourceOfOrigins AS SourceOfOrigins
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
	|	SourceOfOrigins.SerialLotNumber
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SalesReturnItemList.ItemKey AS ItemKey,
	|	SalesReturnItemList.Store AS Store,
	|	SalesReturnItemList.Ref.Company AS Company,
	|	SUM(SalesReturnItemList.QuantityInBaseUnit) AS Quantity,
	|	SalesReturnItemList.Ref.Date AS Period,
	|	VALUE(Enum.BatchDirection.Receipt) AS Direction,
	|	SalesReturnItemList.Key AS Key,
	|	SalesReturnItemList.Ref.Currency AS Currency,
	|	SUM(CASE
	|		WHEN NOT SalesReturnItemList.SalesInvoice.Ref IS NULL
	|		AND SalesReturnItemList.SalesInvoice REFS Document.SalesInvoice
	|			THEN SalesReturnItemList.TotalAmount
	|		ELSE SalesReturnItemList.LandedCost
	|	END) AS Amount,
	|	SUM(CASE
	|		WHEN NOT SalesReturnItemList.SalesInvoice.Ref IS NULL
	|		AND SalesReturnItemList.SalesInvoice REFS Document.SalesInvoice
	|			THEN SalesReturnItemList.TaxAmount
	|		ELSE SalesReturnItemList.LandedCostTax
	|	END) AS LandedCostTax,
	|	CASE
	|		WHEN NOT SalesReturnItemList.SalesInvoice.Ref IS NULL
	|		AND SalesReturnItemList.SalesInvoice REFS Document.SalesInvoice
	|			THEN TRUE
	|		ELSE FALSE
	|	END AS SalesInvoiceIsFilled,
	|	SalesReturnItemList.SalesInvoice AS SalesInvoice,
	|	SalesReturnItemList.SalesInvoice.Company AS SalesInvoice_Company,
	|	SalesReturnItemList.InventoryOrigin,
	|	SalesReturnItemList.Consignor
	|INTO tmpItemList
	|FROM
	|	Document.SalesReturn.ItemList AS SalesReturnItemList
	|WHERE
	|	SalesReturnItemList.Ref = &Ref
	|	AND NOT SalesReturnItemList.IsService
	|GROUP BY
	|	SalesReturnItemList.ItemKey,
	|	SalesReturnItemList.Store,
	|	SalesReturnItemList.Ref.Company,
	|	SalesReturnItemList.Ref.Date,
	|	SalesReturnItemList.Key,
	|	SalesReturnItemList.Ref.Currency,
	|	SalesReturnItemList.SalesInvoice,
	|	SalesReturnItemList.SalesInvoice.Company,
	|	CASE
	|		WHEN NOT SalesReturnItemList.SalesInvoice.Ref IS NULL
	|		AND SalesReturnItemList.SalesInvoice REFS Document.SalesInvoice
	|			THEN TRUE
	|		ELSE FALSE
	|	END,
	|	VALUE(Enum.BatchDirection.Receipt),
	|	SalesReturnItemList.InventoryOrigin,
	|	SalesReturnItemList.Consignor
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpItemList.ItemKey,
	|	tmpItemList.Store,
	|	tmpItemList.Company,
	|	tmpItemList.Quantity AS TotalQuantity,
	|	tmpItemList.Period,
	|	tmpItemList.Direction,
	|	tmpItemList.Key,
	|	tmpItemList.Currency,
	|	tmpItemList.Amount AS TotalAmount,
	|	tmpItemList.SalesInvoiceIsFilled,
	|	tmpItemList.SalesInvoice,
	|	tmpItemList.SalesInvoice_Company,
	|	ISNULL(tmpSourceOfOrigins.Quantity, 0) AS QuantityBySourceOrigin,
	|	CASE
	|		WHEN ISNULL(tmpSourceOfOrigins.Quantity, 0) <> 0
	|			THEN ISNULL(tmpSourceOfOrigins.Quantity, 0)
	|		ELSE tmpItemList.Quantity
	|	END AS Quantity,
	|	CASE
	|		WHEN tmpItemList.Quantity <> 0
	|			THEN CASE
	|				WHEN ISNULL(tmpSourceOfOrigins.Quantity, 0) <> 0
	|					THEN tmpItemList.Amount / tmpItemList.Quantity * ISNULL(tmpSourceOfOrigins.Quantity, 0)
	|				ELSE tmpItemList.Amount
	|			END
	|		ELSE 0
	|	END AS Amount,
	|	CASE
	|		WHEN tmpItemList.Quantity <> 0
	|			THEN CASE
	|				WHEN ISNULL(tmpSourceOfOrigins.Quantity, 0) <> 0
	|					THEN tmpItemList.LandedCostTax / tmpItemList.Quantity * ISNULL(tmpSourceOfOrigins.Quantity, 0)
	|				ELSE tmpItemList.LandedCostTax
	|			END
	|		ELSE 0
	|	END AS LandedCostTax,
	|	ISNULL(tmpSourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)) AS SourceOfOrigin,
	|	ISNULL(tmpSourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber,
	|	ISNULL(tmpSourceOfOrigins.SourceOfOriginStock, VALUE(Catalog.SourceOfOrigins.EmptyRef)) AS SourceOfOriginStock,
	|	ISNULL(tmpSourceOfOrigins.SerialLotNumberStock, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumberStock,
	|	Not tmpItemList.SalesInvoiceIsFilled OR tmpItemList.Company <> tmpItemList.SalesInvoice_Company AS CreateBatch,
	|	tmpItemList.InventoryOrigin,
	|	tmpItemList.Consignor
	|INTO BatchKeysInfo
	|FROM
	|	tmpItemList AS tmpItemList
	|		LEFT JOIN tmpSourceOfOrigins AS tmpSourceOfOrigins
	|		ON tmpItemList.Key = tmpSourceOfOrigins.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchKeysInfo.Key,
	|	CASE
	|		WHEN NOT BatchKeysInfo.SalesInvoiceIsFilled
	|			THEN BatchKeysInfo.LandedCostTax
	|		ELSE 0
	|	END AS InvoiceTaxAmount,
	|	BatchKeysInfo.Amount AS InvoiceAmount,
	|	BatchKeysInfo.*
	|FROM
	|	BatchKeysInfo AS BatchKeysInfo
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SalesReturn.Ref AS Document,
	|	SalesReturn.Company AS Company,
	|	SalesReturn.Ref.Date AS Period
	|FROM
	|	Document.SalesReturn AS SalesReturn
	|WHERE
	|	SalesReturn.Ref = &Ref AND TRUE IN (SELECT CreateBatch FROM BatchKeysInfo)";
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("Period", Ref.Date);
	
	QueryResult = Query.ExecuteBatch();
	BatchesInfo = QueryResult[4].Unload();
	BatchKeysInfo = QueryResult[3].Unload();

	CurrencyTable = Ref.Currencies.UnloadColumns();
	CurrencyMovementType = Ref.Company.LandedCostCurrencyMovementType;
	For Each Row In BatchKeysInfo Do
		If CurrencyTable.FindRows(New Structure("Key, MovementType", Row.Key, CurrencyMovementType)).Count() Then
			Continue;
		EndIf;
		
		CurrencyParameters = CurrenciesServer.GetNewCurrencyRowParameters();
		CurrencyParameters.RowKey   = Row.Key;
		CurrencyParameters.Currency = Row.Currency;
		CurrencyParameters.Ref      = Ref;
		CurrenciesServer.AddRowToCurrencyTable(CurrencyParameters, Ref.Date, CurrencyTable, CurrencyMovementType);
	EndDo;

	T6020S_BatchKeysInfo = Metadata.InformationRegisters.T6020S_BatchKeysInfo;
	PostingServer.SetPostingDataTable(Parameters.PostingDataTables, Parameters, T6020S_BatchKeysInfo.Name, BatchKeysInfo);
	Parameters.PostingDataTables[T6020S_BatchKeysInfo].WriteInTransaction = Parameters.IsReposting;
	
	IncludeDimensions = New Map();
	IncludeDimensions.Insert(T6020S_BatchKeysInfo, "SourceOfOriginStock, SerialLotNumberStock, InventoryOrigin, Consignor");
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "IncludeDimensions", IncludeDimensions);
	CurrenciesServer.PreparePostingDataTables(Parameters, CurrencyTable, AddInfo);
	CurrenciesServer.ExcludePostingDataTable(Parameters, T6020S_BatchKeysInfo);
	
	BatchKeysInfo_DataTable = Parameters.PostingDataTables[T6020S_BatchKeysInfo].PrepareTable;
	
	BatchKeysInfoSettings = PostingServer.GetBatchKeysInfoSettings();
	BatchKeysInfoSettings.DataTable = BatchKeysInfo_DataTable;
	BatchKeysInfoSettings.Dimensions = "Period, Direction, Company, Store, ItemKey, Currency, CurrencyMovementType, SalesInvoice, SourceOfOrigin, SerialLotNumber, SourceOfOriginStock, SerialLotNumberStock, InventoryOrigin, Consignor";
	BatchKeysInfoSettings.Totals = "Quantity, InvoiceAmount, InvoiceTaxAmount";
	BatchKeysInfoSettings.CurrencyMovementType = CurrencyMovementType;
	
	PostingServer.SetBatchKeyInfoTable(Parameters, BatchKeysInfoSettings);
	
	Query = New Query;
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
	"SELECT
	|	BatchesInfo.*
	|INTO BatchesInfo
	|FROM
	|	&BatchesInfo AS BatchesInfo";
	
	Query.SetParameter("BatchesInfo", BatchesInfo);
 	Query.Execute();
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
		"Document.SalesReturn.ItemList");

	CheckAfterWrite_CheckStockBalance(Ref, Cancel, Parameters, AddInfo);

	If Not Cancel And Not AccReg.R4014B_SerialLotNumber.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R4014B_SerialLotNumber", Parameters), PostingServer.GetQueryTableByName(
		"Exists_R4014B_SerialLotNumber", Parameters), AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;

	If Not Cancel And Ref.TransactionType = Enums.SalesReturnTransactionTypes.ReturnFromCustomer
		And Not AccReg.R2001T_Sales.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R2001T_Sales", Parameters), PostingServer.GetQueryTableByName(
		"Exists_R2001T_Sales", Parameters), AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure CheckAfterWrite_CheckStockBalance(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.SalesReturn.ItemList", AddInfo);
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
	StrParams.Insert("Period", Ref.Date);
	StrParams.Insert("Vat", TaxesServer.GetVatRef());
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(OffersInfo());
	QueryArray.Add(GoodReceiptInfo());
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
	QueryArray.Add(R2002T_SalesReturns());
	QueryArray.Add(R2005T_SalesSpecialOffers());
	QueryArray.Add(R2012B_SalesOrdersInvoiceClosing());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R2031B_ShipmentInvoicing());
	QueryArray.Add(R1040B_TaxesOutgoing());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4014B_SerialLotNumber());
	QueryArray.Add(R4031B_GoodsInTransitIncoming());
	QueryArray.Add(R4050B_StockInventory());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5011B_CustomersAging());
	QueryArray.Add(R5021T_Revenues());
	QueryArray.Add(R8014T_ConsignorSales());
	QueryArray.Add(R9010B_SourceOfOriginStock());
	QueryArray.Add(T2015S_TransactionsInfo());
	QueryArray.Add(T3010S_RowIDInfo());
	QueryArray.Add(T6010S_BatchesInfo());
	QueryArray.Add(T6020S_BatchKeysInfo());
	QueryArray.Add(R5020B_PartnersBalance());
	QueryArray.Add(T1040T_AccountingAmounts());
	QueryArray.Add(T1050T_AccountingQuantities());
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
		   |			THEN ItemList.Ref
		   |		ELSE UNDEFINED
		   |	END AS BasisDocument,
		   |	ItemList.Ref AS AdvanceBasis,
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
		   |	ItemList.IsService AS IsService,
		   |	ItemList.ReturnReason,
		   |	ItemList.ProfitLossCenter AS ProfitLossCenter,
		   |	ItemList.RevenueType AS RevenueType,
		   |	ItemList.AdditionalAnalytic AS AdditionalAnalytic,
		   |	ItemList.Ref.Branch AS Branch,
		   |	ItemList.Ref.LegalNameContract AS LegalNameContract,
		   |	ItemList.OffersAmount,
		   |	ItemList.PriceType,
		   |	ItemList.SalesPerson,
		   |	ItemList.Key,
		   |	ItemList.Unit,
		   |	ItemList.Price,
		   |	ItemList.PriceType,
		   |	ItemList.Ref.PriceIncludeTax,
		   |	ItemList.SalesInvoice AS SalesDocument,
		   |	ItemList.Ref.TransactionType = Value(Enum.SalesReturnTransactionTypes.ReturnFromTradeAgent) AS IsReturnFromTradeAgent,
		   |	ItemList.Ref.TransactionType = Value(Enum.SalesReturnTransactionTypes.ReturnFromCustomer) AS IsReturnFromCustomer,
		   |	ItemList.Ref.Company.TradeAgentStore AS TradeAgentStore,
		   |	ItemList.InventoryOrigin = VALUE(Enum.InventoryOriginTypes.OwnStocks) AS IsOwnStocks,
		   |	ItemList.InventoryOrigin = VALUE(Enum.InventoryOriginTypes.ConsignorStocks) AS IsConsignorStocks,
		   |	ItemList.InventoryOrigin AS InventoryOrigin,
		   |	ItemList.VatRate AS VatRate,
		   |	ItemList.TaxAmount AS TaxAmount,
		   |	ItemList.Project
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
		   |	SalesReturnSpecialOffers.AddInfo AS OfferAddInfo,
		   |	SalesReturnItemList.SalesInvoice AS Invoice,
		   |	-SalesReturnSpecialOffers.Amount AS OffersAmount,
		   |	-SalesReturnSpecialOffers.Bonus AS OffersBonus,
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
		   |	SerialLotNumbers.SerialLotNumber.StockBalanceDetail AS StockBalanceDetail,
		   |	SerialLotNumbers.Quantity,
		   |	ItemList.ItemKey AS ItemKey,
		   |	ItemList.Ref.Partner AS Partner,
		   |	ItemList.Ref.Agreement AS Agreement,
		   |	ItemList.Ref.TransactionType = Value(Enum.SalesReturnTransactionTypes.ReturnFromTradeAgent) AS IsReturnFromTradeAgent
		   |INTO SerialLotNumbers
		   |FROM
		   |	Document.SalesReturn.SerialLotNumbers AS SerialLotNumbers
		   |		LEFT JOIN Document.SalesReturn.ItemList AS ItemList
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
		   |	Document.SalesReturn.SourceOfOrigins AS SourceOfOrigins
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
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
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
		   |	VALUE(AccumulationRecordType.Receipt),
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
		|	ItemList.SalesInvoice AS Invoice,
		|	ItemList.ItemKey,
		|	ItemList.RowKey,
		|	ItemList.SalesPerson,
		|	SalesBySerialLotNumbers.SerialLotNumber,
		|	-SalesBySerialLotNumbers.Quantity AS Quantity,
		|	-SalesBySerialLotNumbers.Amount AS Amount,
		|	-SalesBySerialLotNumbers.NetAmount AS NetAmount,
		|	-SalesBySerialLotNumbers.OffersAmount AS OffersAmount
		|INTO R2001T_Sales
		|FROM
		|	ItemList AS ItemList
		|		LEFT JOIN SalesBySerialLotNumbers
		|		ON ItemList.Key = SalesBySerialLotNumbers.Key
		|WHERE
		|	ItemList.IsReturnFromCustomer";
EndFunction

Function R2002T_SalesReturns()
	Return 
		"SELECT
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.SalesInvoice AS Invoice,
		|	ItemList.ItemKey,
		|	ItemList.RowKey,
		|	ItemList.ReturnReason,
		|	ItemList.SalesPerson,
		|	SalesBySerialLotNumbers.SerialLotNumber,
		|	-SalesBySerialLotNumbers.Quantity AS Quantity,
		|	-SalesBySerialLotNumbers.Amount AS Amount,
		|	-SalesBySerialLotNumbers.NetAmount AS NetAmount,
		|	-SalesBySerialLotNumbers.OffersAmount AS OffersAmount
		|INTO R2002T_SalesReturns
		|FROM
		|	ItemList AS ItemList
		|		LEFT JOIN SalesBySerialLotNumbers
		|		ON ItemList.Key = SalesBySerialLotNumbers.Key
		|WHERE
		|	ItemList.IsReturnFromCustomer";
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
	Return AccumulationRegisters.R2021B_CustomersTransactions.R2021B_CustomersTransactions_SR();
EndFunction

Function R2020B_AdvancesFromCustomers()
	Return AccumulationRegisters.R2020B_AdvancesFromCustomers.R2020B_AdvancesFromCustomers_SI_SR_SOC_SRFTA();
EndFunction

Function R5011B_CustomersAging()
	Return AccumulationRegisters.R5011B_CustomersAging.R5011B_CustomersAging_Offset();
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
		   |		ON ItemList.Key = GoodReceipts.Key
		   |WHERE
		   |	TRUE";
EndFunction

Function R1040B_TaxesOutgoing()
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
		|	VALUE(Enum.InvoiceType.Return) AS InvoiceType
		|INTO R1040B_TaxesOutgoing
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsReturnFromCustomer
		|	AND ItemList.TaxAmount <> 0
		|GROUP BY
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.VatRate,
		|	VALUE(Enum.InvoiceType.Return)";
EndFunction

#Region Stock

Function R4010B_ActualStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
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
		   |	AND NOT ItemList.UseGoodsReceipt
		   |	AND NOT ItemList.GoodsReceiptExists
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Receipt),
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
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
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
		   |	AND NOT ItemList.UseGoodsReceipt
		   |	AND NOT ItemList.GoodsReceiptExists
		   |	AND ItemList.IsReturnFromTradeAgent
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Expense),
		   |	ItemList.Period,
		   |	ItemList.ItemKey,
		   |	CASE
		   |		WHEN SerialLotNumbers.StockBalanceDetail
		   |			THEN SerialLotNumbers.SerialLotNumber
		   |		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		   |	END,
		   |	ItemList.TradeAgentStore";
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
	Return 
		   "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemLIst.Store,
		   |	ItemList.ItemKey,
		   |	SUM(ItemList.Quantity) AS Quantity
		   |INTO R4050B_StockInventory
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.IsService
		   |	AND ItemList.IsOwnStocks
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Receipt),
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemLIst.Store,
		   |	ItemList.ItemKey
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemLIst.TradeAgentStore,
		   |	ItemList.ItemKey,
		   |	SUM(ItemList.Quantity) AS Quantity
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.IsService
		   |	AND ItemList.IsReturnFromTradeAgent
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Expense),
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemLIst.TradeAgentStore,
		   |	ItemList.ItemKey";
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
		   |	-SUM(ItemList.Amount) AS Amount,
		   |	ItemList.Period
		   |INTO R5010B_ReconciliationStatement
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.IsReturnFromCustomer
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
	Return "SELECT
		   |	*,
		   |	-ItemList.NetAmount AS Amount,
		   |	-ItemList.Amount AS AmountWithTaxes
		   |INTO R5021T_Revenues
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.IsReturnFromCustomer";
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
		   |	Document.SalesReturn.ItemList AS ItemList
		   |		INNER JOIN Document.SalesReturn.RowIDInfo AS RowIDInfo
		   |		ON RowIDInfo.Ref = &Ref
		   |		AND ItemList.Ref = &Ref
		   |		AND RowIDInfo.Key = ItemList.Key
		   |		AND RowIDInfo.Ref = ItemList.Ref";
EndFunction

Function T2015S_TransactionsInfo()
	Return InformationRegisters.T2015S_TransactionsInfo.T2015S_TransactionsInfo_SR();
EndFunction

Function T6010S_BatchesInfo()
	Return "SELECT
		   |	*
		   |INTO T6010S_BatchesInfo
		   |FROM
		   |	BatchesInfo
		   |WHERE
		   |	TRUE";
EndFunction

Function T6020S_BatchKeysInfo()
	Return "SELECT
		   |	BatchKeysInfo.Period,
		   |	BatchKeysInfo.Company,
		   |	BatchKeysInfo.Currency,
		   |	BatchKeysInfo.CurrencyMovementType,
		   |	BatchKeysInfo.Direction,
		   |	BatchKeysInfo.SalesInvoice,
		   |	BatchKeysInfo.ItemKey,
		   |	BatchKeysInfo.Store,
		   |	SUM(BatchKeysInfo.Quantity) AS Quantity,
		   |	SUM(BatchKeysInfo.InvoiceAmount) AS InvoiceAmount,
		   |	SUM(BatchKeysInfo.InvoiceTaxAmount) AS InvoiceTaxAmount,
		   |	BatchKeysInfo.SerialLotNumber,
		   |	BatchKeysInfo.SourceOfOrigin
		   |INTO T6020S_BatchKeysInfo
		   |FROM
		   |	BatchKeysInfo
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	BatchKeysInfo.Period,
		   |	BatchKeysInfo.Company,
		   |	BatchKeysInfo.Currency,
		   |	BatchKeysInfo.CurrencyMovementType,
		   |	BatchKeysInfo.Direction,
		   |	BatchKeysInfo.SalesInvoice,
		   |	BatchKeysInfo.ItemKey,
		   |	BatchKeysInfo.Store,
		   |	BatchKeysInfo.SerialLotNumber,
		   |	BatchKeysInfo.SourceOfOrigin
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	UNDEFINED,
		   |	UNDEFINED,
		   |	VALUE(Enum.BatchDirection.Expense),
		   |	UNDEFINED,
		   |	ItemList.ItemKey,
		   |	ItemList.TradeAgentStore,
		   |	SUM(CASE
		   |		WHEN ISNULL(SourceOfOrigins.Quantity, 0) <> 0
		   |			THEN ISNULL(SourceOfOrigins.Quantity, 0)
		   |		ELSE ItemList.Quantity
		   |	END) AS Quantity,
		   |	0,
		   |	0,
		   |	ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber,
		   |	ISNULL(SourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)) AS SourceOfOrigin
		   |FROM
		   |	ItemList AS ItemList
		   |LEFT JOIN SourceOfOrigins AS SourceOfOrigins
		   |		ON ItemList.Key = SourceOfOrigins.Key
		   |WHERE
		   |	NOT ItemList.IsService
		   |	AND ItemList.IsReturnFromTradeAgent
		   |GROUP BY
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	VALUE(Enum.BatchDirection.Expense),
		   |	ItemList.ItemKey,
		   |	ItemList.TradeAgentStore,
		   |	ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)),
		   |	ISNULL(SourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef))";
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
		|	ItemList.SalesDocument AS SalesInvoice,
		|	ItemList.Currency,
		|	-ItemList.NetAmount AS NetAmount,
		|	-ItemList.Amount AS Amount,
		|	-ItemList.Quantity AS Quantity,
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
	Return AccumulationRegisters.R5020B_PartnersBalance.R5020B_PartnersBalance_SR();
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

Function T1040T_AccountingAmounts()
	Return
		"SELECT
		|	ItemList.Period,
		|	ItemList.Key AS RowKey,
		|	ItemList.Currency,
		|	ItemList.NetAmount AS Amount,
		|	VALUE(Catalog.AccountingOperations.SalesReturn_DR_R5021T_Revenues_CR_R2021B_CustomersTransactions) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|INTO T1040T_AccountingAmounts
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsReturnFromCustomer
		|
		|UNION ALL
		|
		|SELECT
		|	ItemList.Period,
		|	ItemList.Key AS RowKey,
		|	ItemList.Currency,
		|	ItemList.TaxAmount,
		|	VALUE(Catalog.AccountingOperations.SalesReturn_DR_R1040B_TaxesOutgoing_CR_R2021B_CustomersTransactions),
		|	UNDEFINED
		|FROM
		|	ItemList as ItemList
		|WHERE
		|	ItemList.IsReturnFromCustomer
		|	AND ItemList.TaxAmount <> 0
		|
		|UNION ALL
		|
		|SELECT
		|	T2010S_OffsetOfAdvances.Period,
		|	T2010S_OffsetOfAdvances.Key AS RowKey,
		|	T2010S_OffsetOfAdvances.Currency,
		|	T2010S_OffsetOfAdvances.Amount,
		|	VALUE(Catalog.AccountingOperations.SalesReturn_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers),
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
		|	VALUE(Catalog.AccountingOperations.SalesReturn_DR_R5022T_Expenses_CR_R4050B_StockInventory) AS Operation,
		|	ItemList.Quantity
		|INTO T1050T_AccountingQuantities
		|FROM
		|	ItemList AS ItemList";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	AO = Catalogs.AccountingOperations;

	If Parameters.Operation = AO.SalesReturn_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers Then
		Return GetAnalytics_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers(Parameters);
	ElsIf Parameters.Operation = AO.SalesReturn_DR_R5021T_Revenues_CR_R2021B_CustomersTransactions Then
		Return GetAnalytics_DR_R5021T_Revenues_CR_R2021B_CustomersTransactions(Parameters);
	ElsIf Parameters.Operation = AO.SalesReturn_DR_R1040B_TaxesOutgoing_CR_R2021B_CustomersTransactions Then
		Return GetAnalytics_DR_R1040B_TaxesOutgoing_CR_R2021B_CustomersTransactions(Parameters);
	ElsIf Parameters.Operation = AO.SalesReturn_DR_R5022T_Expenses_CR_R4050B_StockInventory Then
		Return GetAnalytics_DR_R5022T_Expenses_CR_R4050B_StockInventory(Parameters);
	EndIf;

	Return Undefined;
EndFunction

#Region Accounting_Analytics

Function GetAnalytics_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
	
	Accounts = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                      Parameters.ObjectData.Partner, 
	                                                      Parameters.ObjectData.Agreement,
	                                                      Parameters.ObjectData.Currency);

	// Debit
	AccountingAnalytics.Debit = Accounts.AccountTransactionsCustomer;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Partner", Parameters.ObjectData.Partner);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	AccountingAnalytics.Credit = Accounts.AccountAdvancesCustomer;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Partner", Parameters.ObjectData.Partner);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);
	
	Return AccountingAnalytics;
EndFunction

Function GetAnalytics_DR_R5021T_Revenues_CR_R2021B_CustomersTransactions(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
	
	// Debit
	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                           Parameters.RowData.RevenueType,
	                                                           Parameters.RowData.ProfitLossCenter);
	AccountingAnalytics.Debit = Debit.AccountRevenue;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                   Parameters.ObjectData.Partner, 
	                                                   Parameters.ObjectData.Agreement,
	                                                   Parameters.ObjectData.Currency);
	                                                   
	AccountingAnalytics.Credit = Credit.AccountTransactionsCustomer;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Partner", Parameters.ObjectData.Partner);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	Return AccountingAnalytics;
EndFunction
	
Function GetAnalytics_DR_R1040B_TaxesOutgoing_CR_R2021B_CustomersTransactions(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
	
	// Debit
	Debit = AccountingServer.GetT9013S_AccountsTax(AccountParameters, Parameters.RowData.TaxInfo);
	AccountingAnalytics.Debit = Debit.OutgoingAccountReturn;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, Parameters.RowData.TaxInfo);
	
	// Credit
	Credit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                   Parameters.ObjectData.Partner, 
	                                                   Parameters.ObjectData.Agreement,
	                                                   Parameters.ObjectData.Currency);
	                                                   
	AccountingAnalytics.Credit = Credit.AccountTransactionsCustomer;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Partner", Parameters.ObjectData.Partner);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	Return AccountingAnalytics;
EndFunction

Function GetAnalytics_DR_R5022T_Expenses_CR_R4050B_StockInventory(Parameters)
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
