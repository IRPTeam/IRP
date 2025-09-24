#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function Print(Ref, Param) Export
	If StrCompare(Param.NameTemplate, "GoodsReceiptPrint") = 0 Then
		Return GoodsReceiptPrint(Ref, Param);
	EndIf;
EndFunction

// Goods Receipt print.
// 
// Parameters:
//  Ref - DocumentRef.GoodsReceipt
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Goods Receipt print
Function GoodsReceiptPrint(Ref, Param)
		
	Template = GetTemplate("GoodsReceiptPrint");
	Template.LanguageCode = Param.LayoutLang;
	Query = New Query;
	Text =
	"SELECT
	|	DocumentHeader.Number AS Number,
	|	DocumentHeader.Date AS Date,
	|	DocumentHeader.Company.Description_en AS Company,
	|	DocumentHeader.Partner.Description_en AS Partner,
	|	DocumentHeader.Author AS Author,
	|	DocumentHeader.Ref AS Ref	
	|FROM
	|	Document.GoodsReceipt AS DocumentHeader
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
	|	DocumentItemList.Ref AS Ref,
	|	DocumentItemList.Key AS Key
	|INTO Items
	|FROM
	|	Document.GoodsReceipt.ItemList AS DocumentItemList
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
	
	Spreadsheet = New SpreadsheetDocument;
	Spreadsheet.LanguageCode = Param.LayoutLang;

	While SelectionHeader.Next() Do
		AreaCaption.Parameters.Fill(SelectionHeader);
		Spreadsheet.Put(AreaCaption);

		AreaHeader.Parameters.Fill(SelectionHeader);
		Spreadsheet.Put(AreaHeader);

		Spreadsheet.Put(AreaItemListHeader);
		
		Choice	= New Structure("Ref", SelectionHeader.Ref);
		FindRow = SelectionItems.FindRows(Choice);

		Number = 0;
		For Each It In FindRow Do
			Number = Number + 1;
			AreaItemList.Parameters.Fill(It);
			AreaItemList.Parameters.Number = Number;
			Spreadsheet.Put(AreaItemList);		
		EndDo;
	EndDo;

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
	Calculate_BatchKeysInfo(Ref, Parameters, AddInfo);
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;

	IncomingStocksServer.ClosureIncomingStocks(Parameters);

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
	|	RowIDInfo.Ref AS Ref,
	|	RowIDInfo.Key AS Key,
	|	MAX(RowIDInfo.RowID) AS RowID
	|INTO tmpRowIDInfo
	|FROM
	|	Document.GoodsReceipt.RowIDInfo AS RowIDInfo
	|WHERE
	|	RowIDInfo.Ref = &Ref
	|GROUP BY
	|	RowIDInfo.Ref,
	|	RowIDInfo.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
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
	|	SUM(SourceOfOrigins.Quantity) AS Quantity
	|INTO tmpSourceOfOrigins
	|FROM
	|	Document.GoodsReceipt.SourceOfOrigins AS SourceOfOrigins
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
	|	END
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList.ItemKey AS ItemKey,
	|	ItemList.Store AS Store,
	|	ItemList.Ref.Branch AS Branch,
	|	ItemList.Ref.Company AS Company,
	|	SUM(ItemList.QuantityInBaseUnit) AS Quantity,
	|	ItemList.Ref.Date AS Period,
	|	VALUE(Enum.BatchDirection.Receipt) AS Direction,
	|	ItemList.Key AS Key,
	|	ItemList.IsPreliminary AS IsPreliminary,
	|	SUM(ItemList.PreliminaryAmount) AS PreliminaryAmount,
	|	ItemList.Currency AS Currency,
	|	RowIDInfo.RowID AS RowID
	|INTO tmpItemList
	|FROM
	|	Document.GoodsReceipt.ItemList AS ItemList
	|		INNER JOIN tmpRowIDInfo AS RowIDInfo
	|		ON ItemList.Key = RowIDInfo.Key
	|		AND RowIDInfo.Ref = &Ref
	|WHERE
	|	ItemList.Ref = &Ref
	|GROUP BY
	|	ItemList.ItemKey,
	|	ItemList.Store,
	|	ItemList.Ref.Branch,
	|	ItemList.Ref.Company,
	|	ItemList.Ref.Date,
	|	ItemList.Key,
	|	ItemList.IsPreliminary,
	|	ItemList.Currency,
	|	RowIDInfo.RowID,
	|	VALUE(Enum.BatchDirection.Receipt)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpItemList.ItemKey AS ItemKey,
	|	tmpItemList.Store AS Store,
	|	tmpItemList.Branch AS Branch,
	|	tmpItemList.Company AS Company,
	|	tmpItemList.Quantity AS TotalQuantity,
	|	tmpItemList.Period AS Period,
	|	tmpItemList.Direction AS Direction,
	|	tmpItemList.Key AS Key,
	|	tmpItemList.Currency AS Currency,
	|	tmpItemList.RowID AS RowID,
	|
	|	case when tmpItemList.IsPreliminary then tmpItemList.RowID else undefined end as PreliminaryID,
	|
	|	ISNULL(tmpSourceOfOrigins.Quantity, 0) AS QuantityBySourceOrigin,
	|	CASE
	|		WHEN ISNULL(tmpSourceOfOrigins.Quantity, 0) <> 0
	|			THEN ISNULL(tmpSourceOfOrigins.Quantity, 0)
	|		ELSE tmpItemList.Quantity
	|	END AS Quantity,
	|	CASE
	|		WHEN tmpItemList.Quantity <> 0
	|			THEN 
	|
	|	case when tmpItemList.Quantity = ISNULL(tmpSourceOfOrigins.Quantity, 0) then
	|		tmpItemList.PreliminaryAmount
	|	else
	|			CASE
	|				WHEN ISNULL(tmpSourceOfOrigins.Quantity, 0) <> 0
	|					THEN tmpItemList.PreliminaryAmount / tmpItemList.Quantity * ISNULL(tmpSourceOfOrigins.Quantity, 0)
	|				ELSE tmpItemList.PreliminaryAmount
	|			END
	|end
	|		ELSE 0
	|	end as PreliminaryAmount,
	|
	|	ISNULL(tmpSourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)) AS SourceOfOrigin,
	|	ISNULL(tmpSourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber,
	|	tmpItemList.IsPreliminary AS IsPreliminary
	|INTO BatchKeysInfo
	|FROM
	|	tmpItemList AS tmpItemList
	|		LEFT JOIN tmpSourceOfOrigins AS tmpSourceOfOrigins
	|		ON tmpItemList.Key = tmpSourceOfOrigins.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Taxes.Key,
	|	Taxes.Ref.Company AS Company,
	|	&Vat AS Tax,
	|	Taxes.PreliminaryTaxAmount AS PreliminaryTaxAmount
	|INTO Taxes
	|FROM
	|	Document.GoodsReceipt.ItemList AS Taxes
	|WHERE
	|	Taxes.Ref = &Ref
	|	AND Taxes.PreliminaryTaxAmount <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Taxes.Key,
	|	SUM(Taxes.PreliminaryTaxAmount) AS PreliminaryTaxAmount
	|INTO TaxesAmounts
	|FROM
	|	Taxes AS Taxes
	|		INNER JOIN InformationRegister.Taxes.SliceLast(&Period, (Company, Tax) IN
	|			(SELECT
	|				Taxes.Company,
	|				Taxes.Tax
	|			FROM
	|				Taxes AS Taxes)) AS TaxesSliceLast
	|		ON TaxesSliceLast.Company = Taxes.Company
	|		AND TaxesSliceLast.Tax = Taxes.Tax
	|WHERE
	|	TaxesSliceLast.Use
	|	AND TaxesSliceLast.IncludeToLandedCost
	|GROUP BY
	|	Taxes.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchKeysInfo.Key,
	|	CASE
	|		WHEN BatchKeysInfo.TotalQuantity <> 0
	|			THEN ISNULL(TaxesAmounts.PreliminaryTaxAmount, 0) / BatchKeysInfo.TotalQuantity * BatchKeysInfo.Quantity
	|		ELSE 0
	|	END AS PreliminaryTaxAmount,
	|	BatchKeysInfo.PreliminaryAmount AS PreliminaryAmount,
	|	BatchKeysInfo.Quantity AS PreliminaryQuantity,
	|	BatchKeysInfo.*
	|FROM
	|	BatchKeysInfo AS BatchKeysInfo
	|		LEFT JOIN TaxesAmounts AS TaxesAmounts
	|		ON BatchKeysInfo.Key = TaxesAmounts.Key
	|WHERE
	|	BatchKeysInfo.IsPreliminary
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	GoodsReceipt.Ref AS Document,
	|	GoodsReceipt.Company AS Company,
	|	GoodsReceipt.Ref.Date AS Period
	|FROM
	|	Document.GoodsReceipt AS GoodsReceipt
	|WHERE
	|	GoodsReceipt.Ref = &Ref
	|	AND TRUE IN
	|		(SELECT
	|			IsPreliminary
	|		FROM
	|			BatchKeysInfo)";
	
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("Period", Ref.Date);
	Query.SetParameter("Vat", TaxesServer.GetVatRef());

	QueryResults = Query.ExecuteBatch();
	BatchKeysInfo = QueryResults[6].Unload();
	BatchesInfo   = QueryResults[7].Unload();

	CurrencyTable = Ref.Currencies.UnloadColumns();
	CurrencyMovementType = Ref.Company.LandedCostCurrencyMovementType;

	ArrayOfFixedRates = New Array;
	For Each Row In Ref.Currencies Do
		If Row.IsFixed Then
			FixedRates = New Structure("Key, CurrencyFrom, MovementType, Rate, ReverseRate, Multiplicity");
			FillPropertyValues(FixedRates, Row);
			ArrayOfFixedRates.Add(FixedRates);
		EndIf;
	EndDo;
	
	AddedKeys = New Array();
	For Each Row In BatchKeysInfo Do
		If AddedKeys.Find(Row.Key) <> Undefined Then
			Continue;
		EndIf;
		AddedKeys.Add(Row.Key);
		CurrencyParameters = CurrenciesServer.GetNewCurrencyRowParameters();
		CurrencyParameters.RowKey   = Row.Key;
		CurrencyParameters.Currency = Row.Currency;
		CurrencyParameters.Ref      = Ref;
		CurrenciesServer.AddRowToCurrencyTable(CurrencyParameters, Ref.Date, CurrencyTable, CurrencyMovementType, ArrayOfFixedRates);
	EndDo;

	T6020S_BatchKeysInfo = Metadata.InformationRegisters.T6020S_BatchKeysInfo;
	PostingServer.SetPostingDataTable(Parameters.PostingDataTables, Parameters, T6020S_BatchKeysInfo.Name, BatchKeysInfo);
	Parameters.PostingDataTables[T6020S_BatchKeysInfo].WriteInTransaction = Parameters.IsReposting;
	
	CurrenciesServer.PreparePostingDataTables(Parameters, CurrencyTable, AddInfo);
	CurrenciesServer.ExcludePostingDataTable(Parameters, T6020S_BatchKeysInfo);
	
	BatchKeysInfo_DataTable = Parameters.PostingDataTables[T6020S_BatchKeysInfo].PrepareTable;
	
	BatchKeysInfoSettings = PostingServer.GetBatchKeysInfoSettings();
	BatchKeysInfoSettings.DataTable = BatchKeysInfo_DataTable;
	BatchKeysInfoSettings.Dimensions = 
		"Period, 
		|RowID, 
		|Direction, 
		|Company, 
		|Branch, 
		|Store, 
		|ItemKey, 
		|Currency, 
		|CurrencyMovementType, 
		|SourceOfOrigin, 
		|SerialLotNumber,
		|PreliminaryID,
		|IsPreliminary";
	BatchKeysInfoSettings.Totals = "PreliminaryQuantity, PreliminaryAmount, PreliminaryTaxAmount";
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
	IncomingStocksServer.ClosureIncomingStocks_Unposting(Parameters);

	QueryArray = GetQueryTextsMasterTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region CheckAfterWrite

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	If CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "UnitTest", False) Then
		Return;
	EndIf;

	Unposting = ?(Parameters.Property("Unposting"), Parameters.Unposting, False);
	AccReg = AccumulationRegisters;

	Current_R4050B_StockInventory = PostingServer.GetQueryTableByName("R4050B_StockInventory", Parameters);
	Exists_R4050B_StockInventory  = PostingServer.GetQueryTableByName("Exists_R4050B_StockInventory", Parameters);
	
	Parameters.Insert("Current_R4050B_StockInventory", Current_R4050B_StockInventory);
	Parameters.Insert("Exists_R4050B_StockInventory" , Exists_R4050B_StockInventory);
	
	CheckAfterWrite_CheckStockBalance(Ref, Cancel, Parameters, AddInfo);

	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref, "Document.GoodsReceipt.ItemList");
	
	R4035B_IncomingStocks = PostingServer.GetQueryTableByName("R4035B_IncomingStocks", Parameters);
	Exists_R4035B_IncomingStocks = PostingServer.GetQueryTableByName("Exists_R4035B_IncomingStocks", Parameters);
	
	If Not Cancel And Not AccReg.R4035B_IncomingStocks.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		R4035B_IncomingStocks, Exists_R4035B_IncomingStocks, AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
	
	R4036B_IncomingStocksRequested = PostingServer.GetQueryTableByName("R4036B_IncomingStocksRequested", Parameters);
	Exists_R4036B_IncomingStocksRequested = PostingServer.GetQueryTableByName("Exists_R4036B_IncomingStocksRequested", Parameters);
	
	If Not Cancel And Not AccReg.R4036B_IncomingStocksRequested.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		R4036B_IncomingStocksRequested, Exists_R4036B_IncomingStocksRequested, AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;

	R4014B_SerialLotNumber = PostingServer.GetQueryTableByName("R4014B_SerialLotNumber", Parameters);
	Exists_R4014B_SerialLotNumber = PostingServer.GetQueryTableByName("Exists_R4014B_SerialLotNumber", Parameters);
	
	If Not Cancel And Not AccReg.R4014B_SerialLotNumber.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		R4014B_SerialLotNumber, Exists_R4014B_SerialLotNumber, AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure CheckAfterWrite_CheckStockBalance(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.GoodsReceipt.ItemList", AddInfo);
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
	StrParams.Insert("IsUseSimpleBatch", FOServer.IsUseSimpleBatch());
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(SerialLotNumbers());
	QueryArray.Add(SourceOfOrigins());
	QueryArray.Add(IncomingStocksReal());
	QueryArray.Add(OrderItemList());
	QueryArray.Add(Exists_R4035B_IncomingStocks());
	QueryArray.Add(Exists_R4036B_IncomingStocksRequested());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4014B_SerialLotNumber());
	QueryArray.Add(PostingServer.Exists_R4050B_StockInventory());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R1011B_PurchaseOrdersReceipt());
	QueryArray.Add(R1031B_ReceiptInvoicing());
	QueryArray.Add(R2013T_SalesOrdersProcurement());
	QueryArray.Add(R2031B_ShipmentInvoicing());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4012B_StockReservation());
	QueryArray.Add(R4014B_SerialLotNumber());
	QueryArray.Add(R4017B_InternalSupplyRequestProcurement());
	QueryArray.Add(R4021B_StockTransferOrdersReceipt());
	QueryArray.Add(R4031B_GoodsInTransitIncoming());
	QueryArray.Add(R4032B_GoodsInTransitOutgoing());
	QueryArray.Add(R4033B_GoodsReceiptSchedule());
	QueryArray.Add(R4035B_IncomingStocks());
	QueryArray.Add(R4036B_IncomingStocksRequested());
	QueryArray.Add(T3010S_RowIDInfo());
	QueryArray.Add(R6025B_SimpleBatch());
	QueryArray.Add(T6010S_BatchesInfo());
	QueryArray.Add(T6020S_BatchKeysInfo());
	QueryArray.Add(R4050B_StockInventory());
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
		   |	Document.GoodsReceipt.RowIDInfo AS RowIDInfo
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
		   |	ItemList.ReceiptBasis AS ReceiptBasis,
		   |	ItemList.Quantity AS UnitQuantity,
		   |	ItemList.QuantityInBaseUnit AS Quantity,
		   |	ItemList.Unit,
		   |	ItemList.Ref.Date AS Period,
		   |	ItemList.Ref AS GoodsReceipt,
		   |	TableRowIDInfo.RowID AS RowKey,
		   |	ItemList.SalesOrder AS SalesOrder,
		   |	NOT ItemList.SalesOrder = VALUE(Document.SalesOrder.EmptyRef) AS SalesOrderExists,
		   |	ItemList.SalesInvoice AS SalesInvoice,
		   |	NOT ItemList.SalesInvoice = VALUE(Document.SalesInvoice.EmptyRef) AS SalesInvoiceExists,
		   |	ItemList.PurchaseOrder AS PurchaseOrder,
		   |	NOT ItemList.PurchaseOrder = VALUE(Document.PurchaseOrder.EmptyRef) AS PurchaseOrderExists,
		   |	ItemList.PurchaseInvoice AS PurchaseInvoice,
		   |	NOT ItemList.PurchaseInvoice = VALUE(Document.PurchaseInvoice.EmptyRef) AS PurchaseInvoiceExists,
		   |	ItemList.InternalSupplyRequest AS InternalSupplyRequest,
		   |	NOT ItemList.InternalSupplyRequest = VALUE(Document.InternalSupplyRequest.EmptyRef) AS InternalSupplyRequestExists,
		   |	ItemList.InventoryTransferOrder AS InventoryTransferOrder,
		   |	NOT ItemList.InventoryTransferOrder = VALUE(Document.InventoryTransferOrder.EmptyRef) AS
		   |		InventoryTransferOrderExists,
		   |	ItemList.InventoryTransfer AS InventoryTransfer,
		   |	NOT ItemList.InventoryTransfer = VALUE(Document.InventoryTransfer.EmptyRef) AS InventoryTransferExists,
		   |	ItemList.SalesReturn AS SalesReturn,
		   |	NOT ItemList.SalesReturn = VALUE(Document.SalesReturn.EmptyRef) AS SalesReturnExists,
		   |	ItemList.SalesReturnOrder AS SalesReturnOrder,
		   |	NOT ItemList.SalesReturnOrder = VALUE(Document.SalesReturnOrder.EmptyRef) AS SalesReturnOrderExists,
		   |	ItemList.Ref.TransactionType = VALUE(Enum.GoodsReceiptTransactionTypes.Purchase) AS IsTransaction_Purchase,
		   |	ItemList.Ref.TransactionType = VALUE(Enum.GoodsReceiptTransactionTypes.ReturnFromCustomer) AS IsTransaction_ReturnFromCustomer,
		   |	ItemList.Ref.TransactionType = VALUE(Enum.GoodsReceiptTransactionTypes.InventoryTransfer) AS IsTransaction_InventoryTransfer,
		   |	ItemList.Ref.TransactionType = VALUE(Enum.GoodsReceiptTransactionTypes.ReturnFromTradeAgent) AS IsTransaction_ReturnFromTradeAgent,
		   |	ItemList.Ref.TransactionType = VALUE(Enum.GoodsReceiptTransactionTypes.PreliminaryStock) AS isPreliminaryStock,
		   |	ItemList.Ref.Company.TradeAgentStore AS TradeAgentStore,
		   |	ItemList.Ref.Branch AS Branch,
		   |	ItemList.ProductionPlanning AS ProductionPlanning,
		   |	ItemList.Key,
		   |	ItemList.SimpleBatch AS SimpleBatch,
		   |	ItemList.Amount,
		   |	ItemList.IsPreliminary AS IsPreliminary,
		   |	ItemList.ShipmentConfirmation as ShipmentConfirmation,
		   |	not ItemList.ShipmentConfirmation.Ref is null as ShipmentConfirmationExists
		   |INTO ItemList
		   |FROM
		   |	Document.GoodsReceipt.ItemList AS ItemList
		   |		LEFT JOIN TableRowIDInfo AS TableRowIDInfo
		   |		ON ItemList.Key = TableRowIDInfo.Key
		   |WHERE
		   |	ItemList.Ref = &Ref";
EndFunction

Function IncomingStocksReal()
	Return "SELECT
		   |	ItemList.Period,
		   |	ItemList.Store,
		   |	ItemList.ItemKey,
		   |	CASE
		   |		WHEN ItemList.ProductionPlanning.Ref IS NULL
		   |			THEN ItemList.PurchaseOrder
		   |		ELSE ItemList.ProductionPlanning
		   |	END AS Order,
		   |	SUM(ItemList.Quantity) AS Quantity
		   |INTO IncomingStocksReal
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	ItemList.ItemKey,
		   |	ItemList.Period,
		   |	CASE
		   |		WHEN ItemList.ProductionPlanning.Ref IS NULL
		   |			THEN ItemList.PurchaseOrder
		   |		ELSE ItemList.ProductionPlanning
		   |	END,
		   |	ItemList.Store";
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
		   |	ItemList.ItemKey AS ItemKey
		   |INTO SerialLotNumbers
		   |FROM
		   |	Document.GoodsReceipt.SerialLotNumbers AS SerialLotNumbers
		   |		LEFT JOIN Document.GoodsReceipt.ItemList AS ItemList
		   |		ON SerialLotNumbers.Key = ItemList.Key
		   |		AND ItemList.Ref = &Ref
		   |WHERE
		   |	SerialLotNumbers.Ref = &Ref";
EndFunction

Function OrderItemList()
	Return
		"SELECT
		|	RowIDInfo.RowRef,
		|	MAX(RowIDInfo.RowID) AS RowID,
		|	RowIDInfo.Key
		|INTO OrderItemList_tmp1
		|FROM
		|	Document.GoodsReceipt.RowIDInfo AS RowIDInfo
		|WHERE
		|	RowIDInfo.Ref = &Ref
		|GROUP BY
		|	RowIDInfo.RowRef,
		|	RowIDInfo.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ItemList.Key,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.PurchaseOrder,
		|	ItemList.ItemKey,
		|	ItemList.RowKey,
		|	ItemList.Quantity,
		|	ItemList.PurchaseOrderExists
		|INTO OrderItemList_tmp2
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.PurchaseOrderExists
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp1.RowRef,
		|	tmp2.Period,
		|	tmp2.Company,
		|	tmp2.Branch,
		|	tmp2.PurchaseOrder,
		|	tmp2.ItemKey,
		|	tmp2.RowKey,
		|	tmp2.Quantity,
		|	tmp2.PurchaseOrderExists
		|INTO OrderItemList_tmp3
		|FROM
		|	OrderItemList_tmp1 AS tmp1
		|		INNER JOIN OrderItemList_tmp2 AS tmp2
		|		ON tmp1.Key = tmp2.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp3.Period,
		|	tmp3.Company,
		|	tmp3.Branch,
		|	tmp3.PurchaseOrder,
		|	tmp3.ItemKey,
		|	tmp3.RowKey,
		|	tmp3.Quantity,
		|	tmp3.PurchaseOrderExists,
		|	SalesOrderItemList.ItemKey AS OrderItemKey
		|INTO OrderItemList
		|FROM
		|	OrderItemList_tmp3 AS tmp3
		|		INNER JOIN Document.PurchaseOrder.RowIDInfo AS SalesOrderRowIDInfo
		|		ON SalesOrderRowIDInfo.RowRef = tmp3.RowRef
		|		INNER JOIN Document.PurchaseOrder.ItemList AS SalesOrderItemList
		|		ON SalesOrderItemList.Key = SalesOrderRowIDInfo.Key
		|		AND SalesOrderItemList.Ref = tmp3.PurchaseOrder
		|		AND SalesOrderItemList.IsVariableItemKey
		|		AND SalesOrderItemList.ItemKey <> tmp3.ItemKey";	
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
		|	SourceOfOrigins.SerialLotNumber AS SerialLotNumberStock,
		|	SUM(SourceOfOrigins.Quantity) AS Quantity
		|INTO SourceOfOrigins
		|FROM
		|	Document.GoodsReceipt.SourceOfOrigins AS SourceOfOrigins
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

Function Exists_R4035B_IncomingStocks()
	Return "SELECT *
		   |	INTO Exists_R4035B_IncomingStocks
		   |FROM
		   |	AccumulationRegister.R4035B_IncomingStocks AS R4035B_IncomingStocks
		   |WHERE
		   |	R4035B_IncomingStocks.Recorder = &Ref";
EndFunction

Function Exists_R4036B_IncomingStocksRequested()
	Return "SELECT
		   |	*
		   |INTO Exists_R4036B_IncomingStocksRequested
		   |FROM
		   |	AccumulationRegister.R4036B_IncomingStocksRequested AS R4036B_IncomingStocksRequested
		   |WHERE
		   |	R4036B_IncomingStocksRequested.Recorder = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function R1011B_PurchaseOrdersReceipt()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.PurchaseOrder AS Order,
		|	ItemList.OrderItemKey AS ItemKey,
		|	ItemList.RowKey,
		|	ItemList.Quantity
		|INTO R1011B_PurchaseOrdersReceipt
		|FROM
		|	OrderItemList AS ItemList
		|WHERE
		|	ItemList.PurchaseOrderExists
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.PurchaseOrder,
		|	ItemList.ItemKey,
		|	ItemList.RowKey,
		|	ItemList.Quantity
		|FROM
		|	OrderItemList AS ItemList
		|WHERE
		|	ItemList.PurchaseOrderExists
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.PurchaseOrder,
		|	ItemList.ItemKey,
		|	ItemList.RowKey,
		|	ItemList.Quantity
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.PurchaseOrderExists";
EndFunction

Function R1031B_ReceiptInvoicing()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.GoodsReceipt AS Basis,
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
		   |	NOT ItemList.PurchaseInvoiceExists
		   |	AND NOT ItemList.IsTransaction_InventoryTransfer
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense),
		   |	ItemList.PurchaseInvoice,
		   |	ItemList.Quantity,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.Period,
		   |	ItemList.ItemKey,
		   |	ItemList.Store
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.PurchaseInvoiceExists";
EndFunction

Function R2031B_ShipmentInvoicing()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.GoodsReceipt AS Basis,
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
		|	NOT ItemList.SalesReturnExists
		|	AND ItemList.IsTransaction_ReturnFromCustomer
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.SalesReturn,
		|	ItemList.Quantity,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Period,
		|	ItemList.ItemKey,
		|	ItemList.Store
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.SalesReturnExists
		|	AND ItemList.IsTransaction_ReturnFromCustomer
		|
		|union all
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.ShipmentConfirmation,
		|	ItemList.Quantity,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Period,
		|	ItemList.ItemKey,
		|	ItemList.Store
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.ShipmentConfirmationExists";
EndFunction

Function R2013T_SalesOrdersProcurement()
	Return "SELECT
		   |	ItemList.Quantity AS ReceiptQuantity,
		   |	ItemList.SalesOrder AS Order,
		   |	*
		   |INTO R2013T_SalesOrdersProcurement
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.SalesOrderExists";
EndFunction

Function R4010B_ActualStocks()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	CASE
		|		WHEN SerialLotNumbers.StockBalanceDetail
		|			THEN SerialLotNumbers.SerialLotNumber
		|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		|	END AS SerialLotNumber,
		|	case
		|		when SourceOfOrigins.SourceOfOriginStock.StockBalanceDetail
		|			then SourceOfOrigins.SourceOfOriginStock
		|		else VALUE(Catalog.SourceOfOrigins.EmptyRef)
		|	end AS SourceOfOrigin,
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
		|		left join SourceOfOrigins AS SourceOfOrigins
		|		on ItemList.Key = SourceOfOrigins.Key
		|		and ISNULL(SerialLotNumbers.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) = SourceOfOrigins.SerialLotNumberStock
		|WHERE
		|	TRUE
		|GROUP BY
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.Period,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	case
		|		when SourceOfOrigins.SourceOfOriginStock.StockBalanceDetail
		|			then SourceOfOrigins.SourceOfOriginStock
		|		else VALUE(Catalog.SourceOfOrigins.EmptyRef)
		|	end,
		|	CASE
		|		WHEN SerialLotNumbers.StockBalanceDetail
		|			THEN SerialLotNumbers.SerialLotNumber
		|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		|	END
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.Period,
		|	ItemList.TradeAgentStore,
		|	ItemList.ItemKey,
		|	CASE
		|		WHEN SerialLotNumbers.StockBalanceDetail
		|			THEN SerialLotNumbers.SerialLotNumber
		|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		|	END AS SerialLotNumber,
		|	case
		|		when SourceOfOrigins.SourceOfOriginStock.StockBalanceDetail
		|			then SourceOfOrigins.SourceOfOriginStock
		|		else VALUE(Catalog.SourceOfOrigins.EmptyRef)
		|	end AS SourceOfOrigin,
		|	SUM(CASE
		|		WHEN SerialLotNumbers.SerialLotNumber IS NULL
		|			THEN ItemList.Quantity
		|		ELSE SerialLotNumbers.Quantity
		|	END) AS Quantity
		|FROM
		|	ItemList AS ItemList
		|		LEFT JOIN SerialLotNumbers AS SerialLotNumbers
		|		ON ItemList.Key = SerialLotNumbers.Key
		|		left join SourceOfOrigins AS SourceOfOrigins
		|		on ItemList.Key = SourceOfOrigins.Key
		|		and ISNULL(SerialLotNumbers.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) = SourceOfOrigins.SerialLotNumberStock
		|WHERE
		|	ItemList.IsTransaction_ReturnFromTradeAgent
		|GROUP BY
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.Period,
		|	ItemList.TradeAgentStore,
		|	ItemList.ItemKey,
		|	case
		|		when SourceOfOrigins.SourceOfOriginStock.StockBalanceDetail
		|			then SourceOfOrigins.SourceOfOriginStock
		|		else VALUE(Catalog.SourceOfOrigins.EmptyRef)
		|	end,
		|	CASE
		|		WHEN SerialLotNumbers.StockBalanceDetail
		|			THEN SerialLotNumbers.SerialLotNumber
		|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		|	END";
EndFunction

Function R4011B_FreeStocks()
	Return 
				"SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.Period AS Period,
		   |	ItemList.Store AS Store,
		   |	ItemList.ItemKey AS ItemKey,
		   |	ItemList.Quantity AS Quantity
		   |INTO R4011B_FreeStocks
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense),
		   |	FreeStocks.Period,
		   |	FreeStocks.Store,
		   |	FreeStocks.ItemKey,
		   |	FreeStocks.Quantity
		   |FROM
		   |	FreeStocks AS FreeStocks
		   |WHERE
		   |	TRUE
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.Period AS Period,
		   |	ItemList.Store AS Store,
		   |	ItemList.ItemKey AS ItemKey,
		   |	ItemList.Quantity AS Quantity
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	(ItemList.SalesOrderExists AND ItemList.PurchaseOrderExists)
		   |	OR (ItemList.SalesOrderExists AND ItemList.InventoryTransferExists)
		   |	OR (ItemList.SalesOrderExists AND ItemList.PurchaseInvoiceExists)";
EndFunction

Function R4014B_SerialLotNumber()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |*
		   |INTO R4014B_SerialLotNumber
		   |FROM
		   |	SerialLotNumbers AS SerialLotNumbers
		   |WHERE
		   |	FALSE";

EndFunction

Function R4017B_InternalSupplyRequestProcurement()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	*
		   |INTO R4017B_InternalSupplyRequestProcurement
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.InternalSupplyRequestExists";
EndFunction

Function R4021B_StockTransferOrdersReceipt()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.InventoryTransferOrder AS Order,
		   |	*
		   |INTO R4021B_StockTransferOrdersReceipt
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.InventoryTransferOrderExists";
EndFunction

Function R4031B_GoodsInTransitIncoming()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	ItemList.Quantity,
		|	CASE
		|		WHEN ItemList.IsTransaction_InventoryTransfer
		|		AND ItemList.InventoryTransferExists
		|			THEN ItemList.InventoryTransfer
		|		WHEN ItemList.IsTransaction_Purchase
		|		AND ItemList.PurchaseInvoiceExists
		|			THEN ItemList.PurchaseInvoice
		|		WHEN ItemList.IsTransaction_ReturnFromCustomer
		|		AND ItemList.SalesReturnExists
		|			THEN ItemList.SalesReturn
		|		ELSE ItemList.GoodsReceipt
		|	END AS Basis
		|INTO R4031B_GoodsInTransitIncoming
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	TRUE";
EndFunction

Function R4032B_GoodsInTransitOutgoing()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	ItemList.Quantity,
		|	ItemList.ShipmentConfirmation AS Basis,
		|	undefined as SerialLotNumber
		|INTO R4032B_GoodsInTransitOutgoing
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.ShipmentConfirmationExists";	
Endfunction

Function R4033B_GoodsReceiptSchedule()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.PurchaseOrder AS Basis,
		   |	*
		   |INTO R4033B_GoodsReceiptSchedule
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.PurchaseOrderExists
		   |	AND ItemList.PurchaseOrder.UseItemsReceiptScheduling";
EndFunction

Function R4035B_IncomingStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	*
		   |INTO R4035B_IncomingStocks
		   |FROM
		   |	IncomingStocks AS IncomingStocks
		   |WHERE
		   |	TRUE";
EndFunction

Function R4036B_IncomingStocksRequested()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	*
		   |INTO R4036B_IncomingStocksRequested
		   |FROM
		   |	IncomingStocksRequested AS IncomingStocksRequested
		   |WHERE
		   |	TRUE";
EndFunction

Function R4012B_StockReservation()
	Return 
				"SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	IncomingStocksRequested.Period,
		   |	IncomingStocksRequested.IncomingStore AS Store,
		   |	IncomingStocksRequested.ItemKey,
		   |	IncomingStocksRequested.Requester AS Order,
		   |	IncomingStocksRequested.Quantity
		   |INTO R4012B_StockReservation
		   |FROM
		   |	IncomingStocksRequested
		   |WHERE
		   |	TRUE
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.Period AS Period,
		   |	ItemList.Store AS Store,
		   |	ItemList.ItemKey AS ItemKey,
		   |	ItemList.SalesOrder AS Order,
		   |	ItemList.Quantity AS Quantity
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	(ItemList.SalesOrderExists AND ItemList.PurchaseOrderExists)
		   |	OR (ItemList.SalesOrderExists AND ItemList.InventoryTransferExists)
		   |	OR (ItemList.SalesOrderExists AND ItemList.PurchaseInvoiceExists)";
EndFunction

Function T3010S_RowIDInfo()
	Return "SELECT
		   |	RowIDInfo.RowRef AS RowRef,
		   |	RowIDInfo.BasisKey AS BasisKey,
		   |	RowIDInfo.RowID AS RowID,
		   |	RowIDInfo.Basis AS Basis,
		   |	ItemList.Key AS Key,
		   |	0 AS Price,
		   |	UNDEFINED AS Currency,
		   |	ItemList.Unit AS Unit
		   |INTO T3010S_RowIDInfo
		   |FROM
		   |	Document.GoodsReceipt.ItemList AS ItemList
		   |		INNER JOIN Document.GoodsReceipt.RowIDInfo AS RowIDInfo
		   |		ON RowIDInfo.Ref = &Ref
		   |		AND ItemList.Ref = &Ref
		   |		AND RowIDInfo.Key = ItemList.Key
		   |		AND RowIDInfo.Ref = ItemList.Ref";
EndFunction

Function R6025B_SimpleBatch()
	Return 
	"SELECT
	|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
	|	ItemList.Period,
	|	ItemList.SimpleBatch,
	|	SUM(ItemList.Quantity) AS Quantity,
	|	SUM(ItemList.Amount) AS Amount
	|INTO R6025B_SimpleBatch
	|FROM
	|	ItemList AS ItemList
	|		LEFT JOIN Constant.UseSimpleBatch AS UseSimpleBatch
	|		ON TRUE
	|WHERE
	|	NOT ItemList.SimpleBatch = VALUE(Catalog.SimpleBatch.EmptyRef)
	|	AND &IsUseSimpleBatch
	|	AND ItemList.isPreliminaryStock
	|GROUP BY
	|	ItemList.Period,
	|	ItemList.SimpleBatch,
	|	VALUE(AccumulationRecordType.Receipt)";
EndFunction

Function T6010S_BatchesInfo()
	Return 
		"SELECT
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
		|	*
		|INTO T6020S_BatchKeysInfo
		|FROM
		|	BatchKeysInfo
		|WHERE
		|	TRUE";
EndFunction

Function R4050B_StockInventory()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	SUM(ItemList.Quantity) AS PreliminaryQuantity,
		|	0 AS Quantity
		|INTO R4050B_StockInventory
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsPreliminary
		|GROUP BY
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Store,
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

#Region SystemAttributes

Function GetPredefinedSystemAttributes() Export
	SystemAttributes = New Array(); // Array of ChartOfCharacteristicTypesRef.SystemAttributes
	SystemAttributes.Add(ChartsOfCharacteristicTypes.SystemAttributes.Store);
	Return SystemAttributes;
EndFunction

Function GetSystemAttributeValues(Obj, SystemAttribute) Export
	Values = New Array();
	If SystemAttribute = ChartsOfCharacteristicTypes.SystemAttributes.Store Then
		Values = Obj.ItemList.Unload(, "Store").UnloadColumn("Store");
	EndIf;
	Return Values;
EndFunction

#EndRegion
