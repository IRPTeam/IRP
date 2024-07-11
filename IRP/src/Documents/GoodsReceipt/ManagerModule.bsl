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
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
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

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
	Unposting = ?(Parameters.Property("Unposting"), Parameters.Unposting, False);
	AccReg = AccumulationRegisters;

	CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo);

	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref,
		"Document.GoodsReceipt.ItemList");
	If Not Cancel And Not AccReg.R4035B_IncomingStocks.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R4035B_IncomingStocks", Parameters), PostingServer.GetQueryTableByName(
		"Exists_R4035B_IncomingStocks", Parameters), AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;

	If Not Cancel And Not AccReg.R4036B_IncomingStocksRequested.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R4036B_IncomingStocksRequested", Parameters),
		PostingServer.GetQueryTableByName("Exists_R4036B_IncomingStocksRequested", Parameters),
		AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;

	If Not Cancel And Not AccReg.R4014B_SerialLotNumber.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R4014B_SerialLotNumber", Parameters), PostingServer.GetQueryTableByName(
		"Exists_R4014B_SerialLotNumber", Parameters), AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;

EndProcedure

Procedure CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo = Undefined) Export
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
	Return StrParams;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(SerialLotNumbers());
	QueryArray.Add(IncomingStocksReal());
	QueryArray.Add(Exists_R4035B_IncomingStocks());
	QueryArray.Add(Exists_R4036B_IncomingStocksRequested());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4014B_SerialLotNumber());
	Return QueryArray;
EndFunction

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
		   |	ItemList.Ref.Company.TradeAgentStore AS TradeAgentStore,
		   |	ItemList.Ref.Branch AS Branch,
		   |	ItemList.ProductionPlanning AS ProductionPlanning,
		   |	ItemList.Key
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
	QueryArray.Add(R4033B_GoodsReceiptSchedule());
	QueryArray.Add(R4035B_IncomingStocks());
	QueryArray.Add(R4036B_IncomingStocksRequested());
	QueryArray.Add(T3010S_RowIDInfo());
	QueryArray.Add(T1040T_RowIDSerialLotNumbers());
	Return QueryArray;
EndFunction

Function R1011B_PurchaseOrdersReceipt()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.PurchaseOrder AS Order,
		   |	*
		   |INTO R1011B_PurchaseOrdersReceipt
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
	Return "SELECT
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
		   |	AND ItemList.IsTransaction_ReturnFromCustomer";
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
		   |	TRUE
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
		   |	VALUE(AccumulationRecordType.Expense),
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
		   |	ItemList.IsTransaction_ReturnFromTradeAgent
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

Function R4011B_FreeStocks()
	Return "SELECT
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
		   |	TRUE";
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
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	CASE
		   |		WHEN ItemList.IsTransaction_InventoryTransfer AND ItemList.InventoryTransferExists
		   |			THEN ItemList.InventoryTransfer
		   |		WHEN ItemList.IsTransaction_Purchase AND ItemList.PurchaseInvoiceExists
		   |			THEN ItemList.PurchaseInvoice
		   |		WHEN ItemList.IsTransaction_ReturnFromCustomer AND ItemList.SalesReturnExists
		   |			THEN ItemList.SalesReturn
		   |	ELSE
		   |		ItemList.GoodsReceipt
		   |	END AS Basis,
		   |	*
		   |INTO R4031B_GoodsInTransitIncoming
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE";
EndFunction

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
	Return "SELECT
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
		   |	TRUE";
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

Function T1040T_RowIDSerialLotNumbers()
	Return
		"SELECT
		|	CASE
		|		WHEN RowIDInfo.Key = RowIDInfo.RowID
		|			THEN SerialLotNumbers.Quantity
		|		ELSE - SerialLotNumbers.Quantity
		|	END AS Quantity,
		|	CASE 
		|		WHEN RowIDInfo.Key = RowIDInfo.RowID
		|			THEN RowIDInfo.NextStep
		|		ELSE RowIDInfo.CurrentStep
		|	END AS Step,
		|
		|	RowIDInfo.Ref.Date AS Period,
		|	RowIDInfo.RowID AS RowID,
		|	CASE
		|		WHEN RowIDInfo.Basis.Ref IS NULL
		|			THEN RowIDInfo.Ref
		|		ELSE RowIDInfo.Basis
		|	END AS Basis,
		|	SerialLotNumbers.SerialLotNumber AS SerialLotNumber
		|INTO T1040T_RowIDSerialLotNumbers
		|FROM
		|	Document.GoodsReceipt.RowIDInfo AS RowIDInfo
		|		INNER JOIN Document.GoodsReceipt.SerialLotNumbers AS SerialLotNumbers
		|		ON RowIDInfo.Ref = SerialLotNumbers.Ref
		|		AND (RowIDInfo.Ref = &Ref
		|		AND SerialLotNumbers.Ref = &Ref)
		|		AND RowIDInfo.Key = SerialLotNumbers.Key";
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