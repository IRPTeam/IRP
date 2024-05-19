#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function Print(Ref, Param) Export
	If StrCompare(Param.NameTemplate, "RetailReturnReceiptPrint") = 0 Then
		Return RetailReturnReceiptPrint(Ref, Param);
	EndIf;
EndFunction

// Retail Return Receipt print.
// 
// Parameters:
//  Ref - DocumentRef.RetailReturnReceipt
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Retail Return Receipt print
Function RetailReturnReceiptPrint(Ref, Param)
		
	Template = GetTemplate("RetailReturnReceiptPrint");
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
	|	Document.RetailReturnReceipt AS DocumentHeader
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
	|	Document.RetailReturnReceipt.ItemList AS DocumentItemList
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
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);

	Parameters.IsReposting = False;

	DocumentsServer.SalesBySerialLotNumbers(Parameters);
	
	Calculate_BatchKeysInfo(Ref, Parameters, AddInfo);

	Tables = New Structure;

	CashInTransit = Metadata.AccumulationRegisters.CashInTransit;
	Tables.Insert(CashInTransit.Name, CommonFunctionsServer.CreateTable(CashInTransit));
	
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
	CashInTransit = Metadata.AccumulationRegisters.CashInTransit;
	PostingServer.SetPostingDataTable(PostingDataTables, Parameters, CashInTransit.Name, Parameters.DocumentDataTables[CashInTransit.Name]);
	
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
	|	Document.RetailReturnReceipt.SourceOfOrigins AS SourceOfOrigins
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
	|	RetailReturnReceiptItemList.ItemKey AS ItemKey,
	|	RetailReturnReceiptItemList.Store AS Store,
	|	RetailReturnReceiptItemList.Ref.Company AS Company,
	|	SUM(RetailReturnReceiptItemList.QuantityInBaseUnit) AS Quantity,
	|	RetailReturnReceiptItemList.Ref.Date AS Period,
	|	VALUE(Enum.BatchDirection.Receipt) AS Direction,
	|	RetailReturnReceiptItemList.Key AS Key,
	|	RetailReturnReceiptItemList.Ref.Currency AS Currency,
	|	SUM(CASE
	|		WHEN RetailReturnReceiptItemList.RetailSalesReceipt = VALUE(Document.RetailSalesReceipt.EmptyRef)
	|			THEN RetailReturnReceiptItemList.LandedCost
	|		ELSE RetailReturnReceiptItemList.TotalAmount
	|	END) AS Amount,
	|	SUM(CASE
	|		WHEN RetailReturnReceiptItemList.RetailSalesReceipt = VALUE(Document.RetailSalesReceipt.EmptyRef)
	|			THEN RetailReturnReceiptItemList.LandedCostTax
	|		ELSE RetailReturnReceiptItemList.TaxAmount
	|	END) AS LandedCostTax,
	|	CASE
	|		WHEN RetailReturnReceiptItemList.RetailSalesReceipt <> VALUE(Document.RetailSalesReceipt.EmptyRef)
	|			THEN TRUE
	|		ELSE FALSE
	|	END AS SalesInvoiceIsFilled,
	|	RetailReturnReceiptItemList.RetailSalesReceipt AS SalesInvoice,
	|	RetailReturnReceiptItemList.RetailSalesReceipt.Company AS SalesInvoice_Company,
	|	RetailReturnReceiptItemList.InventoryOrigin,
	|	RetailReturnReceiptItemList.Consignor
	|INTO tmpItemList
	|FROM
	|	Document.RetailReturnReceipt.ItemList AS RetailReturnReceiptItemList
	|WHERE
	|	RetailReturnReceiptItemList.Ref = &Ref
	|	AND NOT RetailReturnReceiptItemList.IsService
	|	AND	RetailReturnReceiptItemList.Ref.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
	|GROUP BY
	|	RetailReturnReceiptItemList.ItemKey,
	|	RetailReturnReceiptItemList.Store,
	|	RetailReturnReceiptItemList.Ref.Company,
	|	RetailReturnReceiptItemList.Ref.Date,
	|	RetailReturnReceiptItemList.Key,
	|	RetailReturnReceiptItemList.Ref.Currency,
	|	CASE
	|		WHEN RetailReturnReceiptItemList.RetailSalesReceipt <> VALUE(Document.RetailSalesReceipt.EmptyRef)
	|			THEN TRUE
	|		ELSE FALSE
	|	END,
	|	RetailReturnReceiptItemList.RetailSalesReceipt,
	|	RetailReturnReceiptItemList.RetailSalesReceipt.Company,
	|	VALUE(Enum.BatchDirection.Receipt),
	|	RetailReturnReceiptItemList.InventoryOrigin,
	|	RetailReturnReceiptItemList.Consignor
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
	|INTO tmpBatchKeysInfo
	|FROM
	|	tmpItemList AS tmpItemList
	|		LEFT JOIN tmpSourceOfOrigins AS tmpSourceOfOrigins
	|		ON tmpItemList.Key = tmpSourceOfOrigins.Key
	|
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Ref AS Document,
	|	Company AS Company,
	|	Ref.Date AS Period
	|FROM
	|	Document.RetailReturnReceipt
	|WHERE
	|	Ref = &Ref
	|	AND TRUE IN
	|		(SELECT
	|			BatchKeys.CreateBatch
	|		FROM
	|			tmpBatchKeysInfo AS BatchKeys)
	|	AND StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchKeysInfo.Key,
	|	CASE
	|		WHEN NOT BatchKeysInfo.SalesInvoiceIsFilled
	|			THEN BatchKeysInfo.LandedCostTax
	|		ELSE 0
	|	END AS AmountTax,
	|	BatchKeysInfo.*
	|FROM
	|	tmpBatchKeysInfo AS BatchKeysInfo";
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("Period", Ref.Date);
	
	QueryResult = Query.ExecuteBatch();
	BatchesInfo = QueryResult[3].Unload();
	BatchKeysInfo = QueryResult[4].Unload();

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
	
	CurrenciesServer.PreparePostingDataTables(Parameters, CurrencyTable, AddInfo);
	CurrenciesServer.ExcludePostingDataTable(Parameters, T6020S_BatchKeysInfo);
	
	BatchKeysInfo_DataTable = Parameters.PostingDataTables[T6020S_BatchKeysInfo].PrepareTable;
	
	BatchKeysInfoSettings = PostingServer.GetBatchKeysInfoSettings();
	BatchKeysInfoSettings.DataTable = BatchKeysInfo_DataTable;
	BatchKeysInfoSettings.Dimensions = "Period, Direction, Company, Store, ItemKey, Currency, CurrencyMovementType, SalesInvoice, SourceOfOrigin, SerialLotNumber, SourceOfOriginStock, SerialLotNumberStock, InventoryOrigin, Consignor";
	BatchKeysInfoSettings.Totals = "Quantity, Amount, AmountTax";
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
		"Document.RetailReturnReceipt.ItemList");

	CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo);

	If Not Cancel And Not AccReg.R4014B_SerialLotNumber.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R4014B_SerialLotNumber", Parameters), PostingServer.GetQueryTableByName(
		"Exists_R4014B_SerialLotNumber", Parameters), AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.RetailReturnReceipt.ItemList", AddInfo);
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
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(Payments());
	QueryArray.Add(RetailReturn());
	QueryArray.Add(OffersInfo());
	QueryArray.Add(SerialLotNumbers());
	QueryArray.Add(SourceOfOrigins());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	QueryArray.Add(PostingServer.Exists_R4014B_SerialLotNumber());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(CashInTransit());
	QueryArray.Add(R2001T_Sales());
	QueryArray.Add(R2002T_SalesReturns());
	QueryArray.Add(R2005T_SalesSpecialOffers());
	QueryArray.Add(R2006T_Certificates());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R2050T_RetailSales());
	QueryArray.Add(R3010B_CashOnHand());
	QueryArray.Add(R3011T_CashFlow());
	QueryArray.Add(R3022B_CashInTransitOutgoing());
	QueryArray.Add(R3050T_PosCashBalances());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4014B_SerialLotNumber());
	QueryArray.Add(R4050B_StockInventory());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5015B_OtherPartnersTransactions());
	QueryArray.Add(R5020B_PartnersBalance());
	QueryArray.Add(R5021T_Revenues());
	QueryArray.Add(R8014T_ConsignorSales());
	QueryArray.Add(R9010B_SourceOfOriginStock());
	QueryArray.Add(T3010S_RowIDInfo());
	QueryArray.Add(T6010S_BatchesInfo());
	QueryArray.Add(T6020S_BatchKeysInfo());
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
		   |	GoodsReceipts.Key,
		   |	GoodsReceipts.GoodsReceipt
		   |INTO GoodsReceipts
		   |FROM
		   |	Document.RetailReturnReceipt.GoodsReceipts AS GoodsReceipts
		   |WHERE
		   |	GoodsReceipts.Ref = &Ref
		   |GROUP BY
		   |	GoodsReceipts.Key,
		   |	GoodsReceipts.GoodsReceipt
		   |;
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	ItemList.Ref.Company AS Company,
		   |	ItemList.Store AS Store,
		   |	ItemList.ItemKey AS ItemKey,
		   |	ItemList.Ref AS SalesReturn,
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
		   |	ISNULL(ItemList.Ref.Currency, VALUE(Catalog.Currencies.EmptyRef)) AS Currency,
		   |	ItemList.Ref.Date AS Period,
		   |	ItemList.Ref.StatusType AS StatusType,
		   |	CASE
		   |		WHEN ItemList.RetailSalesReceipt = VALUE(Document.RetailSalesReceipt.EmptyRef)
		   |			THEN ItemList.Ref
		   |		ELSE ItemList.RetailSalesReceipt
		   |	END AS RetailSalesReceipt,
		   |	ItemList.Key AS RowKey,
		   |	ItemList.IsService AS IsService,
		   |	ItemList.ItemKey.Item.ItemType.Type = Value(Enum.ItemTypes.Certificate) AS IsCertificate,
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
		   |	ItemList.Ref.LegalNameContract AS LegalNameContract,
		   |	ItemList.SalesPerson,
		   |	ItemList.Key,
		   |	NOT GoodsReceipts.Key IS NULL AS GoodsReceiptExists,
		   |	GoodsReceipts.GoodsReceipt,
		   | 	ItemList.Unit,
		   |	ItemList.Price,
		   |	ItemList.PriceType,
		   |	ItemList.Ref.PriceIncludeTax,
		   |	ItemList.RetailSalesReceipt AS SalesDocument,
		   |	ItemList.InventoryOrigin = VALUE(Enum.InventoryOriginTypes.OwnStocks) AS IsOwnStocks,
		   |	ItemList.InventoryOrigin = VALUE(Enum.InventoryOriginTypes.ConsignorStocks) AS IsConsignorStocks,
		   |	ItemList.InventoryOrigin AS InventoryOrigin		  
		   |INTO ItemList
		   |FROM
		   |	Document.RetailReturnReceipt.ItemList AS ItemList
		   |		LEFT JOIN GoodsReceipts AS GoodsReceipts
		   |		ON ItemList.Key = GoodsReceipts.Key
		   |WHERE
		   |	ItemList.Ref = &Ref";
EndFunction

Function Payments()
	Return "SELECT
	|	Payments.Ref.Date AS Period,
	|	Payments.Ref.StatusType AS StatusType,
	|	Payments.Ref.Company AS Company,
	|	Payments.Ref AS Basis,
	|	Payments.Account AS Account,
	|	Payments.Account.Type = VALUE(Enum.CashAccountTypes.Bank) AS IsBankAccount,
	|	Payments.Account.Type = VALUE(Enum.CashAccountTypes.Cash) AS IsCashAccount,
	|	Payments.Account.Type = VALUE(Enum.CashAccountTypes.POS) AS IsPOSAccount,
	|	Payments.PostponedPayment AS IsPostponedPayment,
	|	Payments.Ref.Currency AS Currency,
	|	Payments.Amount AS Amount,
	|	Payments.Ref.Branch AS Branch,
	|	Payments.PaymentType AS PaymentType,
	|	Payments.FinancialMovementType AS FinancialMovementType,
	|	Payments.PaymentType.Type = VALUE(Enum.PaymentTypes.Card) AS IsCardPayment,
	|	Payments.PaymentType.Type = VALUE(Enum.PaymentTypes.Cash) AS IsCashPayment,
	|	Payments.PaymentType.Type = VALUE(Enum.PaymentTypes.PaymentAgent) AS IsPaymentAgent,
	|	Payments.PaymentType.Type = VALUE(Enum.PaymentTypes.Certificate) AS IsCertificate,
	|	Payments.PaymentTerminal AS PaymentTerminal,
	|	Payments.Percent AS Percent,
	|	Payments.Commission AS Commission,
	|	Payments.PaymentAgentPartner AS Partner,
	|	Payments.PaymentAgentLegalName AS LegalName,
	|	Payments.PaymentAgentPartnerTerms AS Agreement,
	|	Payments.PaymentAgentLegalNameContract AS LegalNameContract,
	|	Payments.Certificate,
	|	Payments.CashFlowCenter
	|INTO Payments
	|FROM
	|	Document.RetailReturnReceipt.Payments AS Payments
	|WHERE
	|	Payments.Ref = &Ref";
EndFunction

Function OffersInfo()
	Return "SELECT
		   |	RetailReturnReceiptItemList.Ref.Date AS Period,
		   |	RetailReturnReceiptItemList.Ref.StatusType AS StatusType,
		   |	RetailReturnReceiptItemList.RetailSalesReceipt AS Invoice,
		   |	TableRowIDInfo.RowID AS RowKey,
		   |	RetailReturnReceiptItemList.ItemKey,
		   |	RetailReturnReceiptItemList.Ref.Company AS Company,
		   |	RetailReturnReceiptItemList.Ref.Currency,
		   |	RetailReturnReceiptSpecialOffers.Offer AS SpecialOffer,
		   |	RetailReturnReceiptSpecialOffers.AddInfo AS OffersAddInfo,
		   |	- RetailReturnReceiptSpecialOffers.Amount AS OffersAmount,
		   |	- RetailReturnReceiptSpecialOffers.Bonus AS OffersBonus,
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
		   |	RetailReturnReceiptItemList.Ref.StatusType AS StatusType,
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
		   |	RetailReturnReceiptItemList.Store,
		   |	RetailReturnReceiptItemList.SalesPerson
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
		   |	RetailReturnReceiptItemList.Ref.StatusType,
		   |	CASE
		   |		WHEN RetailReturnReceiptItemList.RetailSalesReceipt = VALUE(Document.RetailSalesReceipt.EmptyRef)
		   |			THEN RetailReturnReceiptItemList.Ref
		   |		ELSE RetailReturnReceiptItemList.RetailSalesReceipt
		   |	END,
		   |	RetailReturnReceiptItemList.Key,
		   |	RetailReturnReceiptSerialLotNumbers.SerialLotNumber,
		   |	RetailReturnReceiptItemList.Store,
		   |	RetailReturnReceiptItemList.SalesPerson
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
		   |	tmpRetailReturn.StatusType AS StatusType,
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
		   |		ELSE -tmpRetailReturn.Amount
		   |	END AS Amount,
		   |	CASE
		   |		WHEN tmpRetailReturn.QuantityBySerialLtNumbers <> 0
		   |			THEN CASE
		   |				WHEN tmpRetailReturn.Quantity = 0
		   |					THEN 0
		   |				ELSE -tmpRetailReturn.NetAmount / tmpRetailReturn.Quantity * tmpRetailReturn.QuantityBySerialLtNumbers
		   |			END
		   |		ELSE -tmpRetailReturn.NetAmount
		   |	END AS NetAmount,
		   |	CASE
		   |		WHEN tmpRetailReturn.QuantityBySerialLtNumbers <> 0
		   |			THEN CASE
		   |				WHEN tmpRetailReturn.Quantity = 0
		   |					THEN 0
		   |				ELSE -tmpRetailReturn.OffersAmount / tmpRetailReturn.Quantity * tmpRetailReturn.QuantityBySerialLtNumbers
		   |			END
		   |		ELSE -tmpRetailReturn.OffersAmount
		   |	END AS OffersAmount,
		   |	tmpRetailReturn.Store,
		   |	tmpRetailReturn.SalesPerson
		   |INTO RetailReturn
		   |FROM
		   |	tmpRetailReturn AS tmpRetailReturn";
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
		   |	Document.RetailReturnReceipt.SerialLotNumbers AS SerialLotNumbers
		   |		LEFT JOIN Document.RetailReturnReceipt.ItemList AS ItemList
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
		   |	Document.RetailReturnReceipt.SourceOfOrigins AS SourceOfOrigins
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

Function CashInTransit()
	Return 	"SELECT
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	Payments.Ref.Date AS Period,
	|	Payments.Ref.Company AS Company,
	|	Payments.Ref.Currency AS Currency,
	|	Payments.Account AS FromAccount,
	|	Payments.Ref AS BasisDocument,
	|	Payments.Amount,
	|	Payments.Commission
	|FROM
	|	Document.RetailReturnReceipt.Payments AS Payments
	|WHERE
	|	Payments.Ref = &Ref
	|	AND Payments.PostponedPayment
	|	AND Payments.Ref.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";
	
EndFunction

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
		   |	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
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

Function R4014B_SerialLotNumber()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R4014B_SerialLotNumber
		   |FROM
		   |	SerialLotNumbers AS SerialLotNumbers
		   |WHERE
		   |	TRUE
		   |	AND SerialLotNumbers.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";
EndFunction

Function R2001T_Sales()
	Return 
		"SELECT
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.RetailSalesReceipt AS Invoice,
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
		|	TRUE
		|	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";
EndFunction

Function R2005T_SalesSpecialOffers()
	Return "SELECT *
		   |INTO R2005T_SalesSpecialOffers
		   |FROM
		   |	OffersInfo AS OffersInfo
		   |WHERE TRUE
		   |	AND OffersInfo.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";

EndFunction

Function R2006T_Certificates()
	Return "SELECT
		   |	ItemList.Period,
		   |	ItemList.Currency,
		   |	SerialLotNumbers.SerialLotNumber,
		   |	- SerialLotNumbers.Quantity AS Quantity,
		   |	- ItemList.TotalAmount AS Amount,
		   |	""Return"" AS MovementType
		   |INTO R2006T_Certificates
		   |FROM
		   |	ItemList AS ItemList
		   |	LEFT JOIN SerialLotNumbers AS SerialLotNumbers
		   |		ON ItemList.Key = SerialLotNumbers.Key
		   |WHERE ItemList.IsCertificate
		   |	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
		   |
		   |UNION ALL
		   |	
		   |SELECT
		   |	Payments.Period,
		   |	Payments.Currency,
		   |	Payments.Certificate,
		   |	1,
		   |	Payments.Amount,
		   |	""ReturnUsed""
		   |FROM
		   |	Payments AS Payments
		   |WHERE Payments.IsCertificate
		   |	AND Payments.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";
EndFunction

Function R3010B_CashOnHand()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
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
		   |	NOT (Payments.IsPostponedPayment
		   |	OR Payments.IsPaymentAgent OR Payments.IsCertificate)
		   |	AND Payments.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";
EndFunction

Function R3011T_CashFlow()
	Return "SELECT
		   |	Payments.Period,
		   |	Payments.Company,
		   |	Payments.Branch,
		   |	Payments.Account,
		   |	VALUE(Enum.CashFlowDirections.Outgoing) AS Direction,
		   |	Payments.FinancialMovementType,
		   |	Payments.CashFlowCenter,
		   |	Payments.Currency,
		   |	Payments.Amount
		   |INTO R3011T_CashFlow
		   |FROM
		   |	Payments AS Payments
		   |WHERE
		   |	NOT (Payments.IsPostponedPayment
		   |	OR Payments.IsPaymentAgent)
		   |	AND Payments.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";
EndFunction

Function R4011B_FreeStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R4011B_FreeStocks
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.IsService
		   |	AND NOT ItemList.GoodsReceiptExists
		   |	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";
EndFunction

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
		   |	AND NOT ItemList.GoodsReceiptExists
		   |	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Receipt),
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
		   |	-Payments.Amount AS Amount,
		   |	-Payments.Commission AS Commission,
		   |	*
		   |INTO R3050T_PosCashBalances
		   |FROM
		   |	Payments AS Payments
		   |WHERE
		   |	NOT (Payments.IsPaymentAgent OR Payments.IsPostponedPayment OR Payments.IsCertificate)
		   |	AND Payments.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";
EndFunction

Function R2050T_RetailSales()
	Return "SELECT
		   |	*
		   |INTO R2050T_RetailSales
		   |FROM
		   |	RetailReturn AS RetailReturn
		   |WHERE
		   |	TRUE
		   |	AND RetailReturn.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";
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
		   |	TRUE
		   |	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";
EndFunction

Function R2002T_SalesReturns()
	Return 
		"SELECT
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.RetailSalesReceipt AS Invoice,
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
		|	TRUE
		|	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";
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
		   |	-SUM(ItemList.TotalAmount) AS Amount,
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
		   |	-SUM(ItemList.TotalAmount),
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
		   |	VALUE(AccumulationRecordType.Expense)";

EndFunction

Function R5015B_OtherPartnersTransactions()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	Payments.Period,
		   |	Payments.Company,
		   |	Payments.Branch,
		   |	Payments.Currency,
		   |	Payments.LegalName AS LegalName,
		   |	Payments.Partner AS Partner,
		   |	Payments.Agreement AS Agreement,
		   |	-SUM(Payments.Amount) AS Amount,
		   |	UNDEFINED AS CustomersAdvancesClosing
		   |INTO R5015B_OtherPartnersTransactions
		   |FROM
		   |	Payments AS Payments
		   |WHERE
		   |	Payments.IsPaymentAgent
		   |	AND Payments.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Receipt),
		   |	Payments.Period,
		   |	Payments.Company,
		   |	Payments.Branch,
		   |	Payments.Currency,
		   |	Payments.LegalName,
		   |	Payments.Partner,
		   |	Payments.Agreement";
EndFunction

Function R5010B_ReconciliationStatement()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.LegalName,
		   |	ItemList.LegalNameContract,
		   |	ItemList.Currency,
		   |	-SUM(ItemList.TotalAmount) AS Amount,
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
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	Payments.Company,
		   |	Payments.Branch,
		   |	Payments.LegalName AS LegalName,
		   |	Payments.LegalNameContract AS LegalNameContract,
		   |	Payments.Currency,
		   |	-SUM(Payments.Amount) AS Amount,
		   |	Payments.Period
		   |FROM
		   |	Payments AS Payments
		   |WHERE
		   |	Payments.IsPaymentAgent
		   |	AND Payments.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Receipt),
		   |	Payments.Company,
		   |	Payments.Branch,
		   |	Payments.LegalName,
		   |	Payments.LegalNameContract,
		   |	Payments.Currency,
		   |	Payments.Period";
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
		   |	Document.RetailReturnReceipt.ItemList AS ItemList
		   |		INNER JOIN Document.RetailReturnReceipt.RowIDInfo AS RowIDInfo
		   |		ON RowIDInfo.Ref = &Ref
		   |		AND ItemList.Ref = &Ref
		   |		AND RowIDInfo.Key = ItemList.Key
		   |		AND RowIDInfo.Ref = ItemList.Ref
		   |WHERE
		   |	ItemList.Ref.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)		";
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
	Return 
		"SELECT
		|	BatchKeysInfo.Company AS Company,
		|	BatchKeysInfo.Currency AS Currency,
		|	BatchKeysInfo.CurrencyMovementType AS CurrencyMovementType,
		|	BatchKeysInfo.Direction AS Direction,
		|	BatchKeysInfo.ItemKey AS ItemKey,
		|	BatchKeysInfo.Period AS Period,
		|	SUM(BatchKeysInfo.Quantity) AS Quantity,
		|	BatchKeysInfo.SalesInvoice AS SalesInvoice,
		|	BatchKeysInfo.SerialLotNumber AS SerialLotNumber,
		|	BatchKeysInfo.SourceOfOrigin AS SourceOfOrigin,
		|	BatchKeysInfo.Store AS Store,
		|	SUM(BatchKeysInfo.Amount) AS InvoiceAmount,
		|	SUM(BatchKeysInfo.AmountTax) AS InvoiceTaxAmount
		|INTO T6020S_BatchKeysInfo
		|FROM
		|	BatchKeysInfo AS BatchKeysInfo
		|WHERE
		|	TRUE
		|
		|GROUP BY
		|	BatchKeysInfo.Company,
		|	BatchKeysInfo.Currency,
		|	BatchKeysInfo.CurrencyMovementType,
		|	BatchKeysInfo.Direction,
		|	BatchKeysInfo.ItemKey,
		|	BatchKeysInfo.Period,
		|	BatchKeysInfo.SalesInvoice,
		|	BatchKeysInfo.SerialLotNumber,
		|	BatchKeysInfo.SourceOfOrigin,
		|	BatchKeysInfo.Store";
EndFunction

Function R3022B_CashInTransitOutgoing()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	Payments.Period,
		   |	Payments.Company,
		   |	Payments.Branch,
		   |	Payments.Currency,
		   |	Payments.Account,
		   |	Payments.Basis,
		   |	Payments.Amount,
		   |	Payments.Commission
		   |INTO R3022B_CashInTransitOutgoing
		   |FROM
		   |	Payments AS Payments
		   |WHERE
		   |	Payments.IsPostponedPayment
		   |	AND Payments.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)";
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
		|	-ItemList.TotalAmount AS Amount,
		|	-ItemList.Quantity AS Quantity,
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

Function R5020B_PartnersBalance()
	Return AccumulationRegisters.R5020B_PartnersBalance.R5020B_PartnersBalance_RRR();
EndFunction

Function R4050B_StockInventory()
	Return "SELECT
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
		   |	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Receipt),
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemLIst.Store,
		   |	ItemList.ItemKey";
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

Function GetAccountingAnalytics(Parameters) Export
	Return Undefined;
EndFunction

#Region Accounting_Analytics

Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value) Export
	Return Value;
EndFunction

Function GetHintCreditExtDimension(Parameters, ExtDimensionType, Value) Export
	Return Value;
EndFunction

#EndRegion

#EndRegion
