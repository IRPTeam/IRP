#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function Print(Ref, Param) Export
	If StrCompare(Param.NameTemplate, "ShipmentConfirmationPrint") = 0 Then
		Return ShipmentConfirmation(Ref, Param);
	EndIf;
EndFunction

// Shipment Confirmation print.
// 
// Parameters:
//  Ref - DocumentRef.ShipmentConfirmation
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Shipment Confirmation print
Function ShipmentConfirmation(Ref, Param)
		
	Template = GetTemplate("ShipmentConfirmationPrint");
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
	|	Document.ShipmentConfirmation AS DocumentHeader
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
	|	Document.ShipmentConfirmation.ItemList AS DocumentItemList
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

	CheckAfterWrite_CheckStockBalance(Ref, Cancel, Parameters, AddInfo);

	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref,
		"Document.ShipmentConfirmation.ItemList");

	If Not Cancel And Not AccReg.R4014B_SerialLotNumber.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R4014B_SerialLotNumber", Parameters), PostingServer.GetQueryTableByName(
		"Exists_R4014B_SerialLotNumber", Parameters), AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;

EndProcedure

Procedure CheckAfterWrite_CheckStockBalance(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("RecordType", AccumulationRecordType.Expense);
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.ShipmentConfirmation.ItemList", AddInfo);
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
	QueryArray.Add(SerialLotNumbers());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4014B_SerialLotNumber());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R1031B_ReceiptInvoicing());
	QueryArray.Add(R2011B_SalesOrdersShipment());
	QueryArray.Add(R2013T_SalesOrdersProcurement());
	QueryArray.Add(R2031B_ShipmentInvoicing());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4012B_StockReservation());
	QueryArray.Add(R4014B_SerialLotNumber());
	QueryArray.Add(R4022B_StockTransferOrdersShipment());
	QueryArray.Add(R4032B_GoodsInTransitOutgoing());
	QueryArray.Add(R4034B_GoodsShipmentSchedule());
	QueryArray.Add(T3010S_RowIDInfo());
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
		   |	Document.ShipmentConfirmation.RowIDInfo AS RowIDInfo
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
		   |	ItemList.Ref AS ShipmentConfirmation,
		   |	ItemList.Quantity AS UnitQuantity,
		   |	ItemList.QuantityInBaseUnit AS Quantity,
		   |	ItemList.Unit,
		   |	ItemList.Ref.Date AS Period,
		   |	TableRowIDInfo.RowID AS RowKey,
		   |	ItemList.SalesOrder AS SalesOrder,
		   |	NOT ItemList.SalesOrder.Ref IS NULL AS SalesOrderExists,
		   |	ItemList.SalesInvoice AS SalesInvoice,
		   |	NOT ItemList.SalesInvoice.Ref IS NULL AS SalesInvoiceExists,
		   |	ItemList.PurchaseReturnOrder AS PurchaseReturnOrder,
		   |	NOT ItemList.PurchaseReturnOrder.Ref IS NULL AS PurchaseReturnOrderExists,
		   |	ItemList.PurchaseReturn AS PurchaseReturn,
		   |	NOT ItemList.PurchaseReturn.Ref IS NULL AS PurchaseReturnExists,
		   |	ItemList.InventoryTransferOrder AS InventoryTransferOrder,
		   |	NOT ItemList.InventoryTransferOrder.Ref IS NULL AS InventoryTransferOrderExists,
		   |	ItemList.InventoryTransfer AS InventoryTransfer,
		   |	NOT ItemList.InventoryTransfer.Ref IS NULL AS InventoryTransferExists,
		   |	ItemList.Ref.TransactionType = VALUE(Enum.ShipmentConfirmationTransactionTypes.Sales) AS IsTransaction_Sales,
		   |    ItemList.Ref.TransactionType = VALUE(Enum.ShipmentConfirmationTransactionTypes.ShipmentToTradeAgent)  AS IsTransaction_ShipmentToTradeAgent,
		   |
		   |	ItemList.Ref.TransactionType = VALUE(Enum.ShipmentConfirmationTransactionTypes.ReturnToVendor) 
		   |	OR ItemList.Ref.TransactionType = VALUE(Enum.ShipmentConfirmationTransactionTypes.ReturnToConsignor) AS IsTransaction_ReturnToVendor,
		   |
		   |	ItemList.Ref.TransactionType = VALUE(Enum.ShipmentConfirmationTransactionTypes.InventoryTransfer) AS IsTransaction_InventoryTransfer,
		   |
		   |	ItemList.Ref.Branch AS Branch,
		   |	ItemList.Ref.Company.TradeAgentStore AS TradeAgentStore,
		   |	ItemList.Key
		   |INTO ItemList
		   |FROM
		   |	Document.ShipmentConfirmation.ItemList AS ItemList
		   |		INNER JOIN TableRowIDInfo AS TableRowIDInfo
		   |		ON ItemList.Key = TableRowIDInfo.Key
		   |WHERE
		   |	ItemList.Ref = &Ref";
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
		   |	Document.ShipmentConfirmation.SerialLotNumbers AS SerialLotNumbers
		   |		LEFT JOIN Document.ShipmentConfirmation.ItemList AS ItemList
		   |		ON SerialLotNumbers.Key = ItemList.Key
		   |		AND ItemList.Ref = &Ref
		   |WHERE
		   |	SerialLotNumbers.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function R2011B_SalesOrdersShipment()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.SalesOrder AS Order,
		   |	*
		   |INTO R2011B_SalesOrdersShipment
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.SalesOrderExists";

EndFunction

Function R2013T_SalesOrdersProcurement()
	Return "SELECT
		   |	ItemList.Quantity AS ShippedQuantity,
		   |	ItemList.SalesOrder AS Order,
		   |	*
		   |INTO R2013T_SalesOrdersProcurement
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.SalesOrderExists";
EndFunction

Function R2031B_ShipmentInvoicing()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.ShipmentConfirmation AS Basis,
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
		   |	NOT ItemList.SalesInvoiceExists
		   |	AND (ItemList.IsTransaction_Sales OR ItemList.IsTransaction_ShipmentToTradeAgent)
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense),
		   |	ItemList.SalesInvoice,
		   |	ItemList.Quantity,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.Period,
		   |	ItemList.ItemKey,
		   |	ItemList.Store
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.SalesInvoiceExists
		   |	AND (ItemList.IsTransaction_Sales OR ItemList.IsTransaction_ShipmentToTradeAgent)";
EndFunction

Function R1031B_ReceiptInvoicing()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.ShipmentConfirmation AS Basis,
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
		   |	NOT ItemList.PurchaseReturnExists
		   |	AND ItemList.IsTransaction_ReturnToVendor
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense),
		   |	ItemList.PurchaseReturn,
		   |	ItemList.Quantity,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.Period,
		   |	ItemList.ItemKey,
		   |	ItemList.Store
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.PurchaseReturnExists
		   |	AND ItemList.IsTransaction_ReturnToVendor";
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
		   |	TRUE
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
		   |	END,
		   |	SUM(CASE
		   |		WHEN SerialLotNumbers.SerialLotNumber IS NULL
		   |			THEN ItemList.Quantity
		   |		ELSE SerialLotNumbers.Quantity
		   |	END)
		   |FROM
		   |	ItemList AS ItemList
		   |		LEFT JOIN SerialLotNumbers AS SerialLotNumbers
		   |		ON ItemList.Key = SerialLotNumbers.Key
		   |WHERE
		   |	ItemList.IsTransaction_ShipmentToTradeAgent
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
		   |	ItemList.SalesInvoice AS SalesInvoice,
		   |	ItemList.SalesOrderExists AS SalesOrderExists,
		   |	ItemList.SalesInvoiceExists AS SalesInvoiceExists,
		   |	ItemList.InventoryTransferOrder AS InventoryTransferOrder,
		   |	ItemList.InventoryTransferOrderExists AS InventoryTransferOrderExists,
		   |	SUM(ItemList.Quantity) AS Quantity
		   |INTO ItemListGroup
		   |FROM
		   |	ItemList AS ItemList
		   |GROUP BY
		   |	ItemList.Period,
		   |	ItemList.Store,
		   |	ItemList.ItemKey,
		   |	ItemList.SalesOrder,
		   |	ItemList.SalesInvoice,
		   |	ItemList.SalesOrderExists,
		   |	ItemList.SalesInvoiceExists,
		   |	ItemList.InventoryTransferOrder,
		   |	ItemList.InventoryTransferOrderExists
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
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	StockReservation.Store,
		   |	StockReservation.Order,
		   |	StockReservation.ItemKey,
		   |	StockReservation.QuantityBalance
		   |FROM
		   |	AccumulationRegister.R4012B_StockReservation.Balance(&BalancePeriod, (Store, ItemKey, Order) IN
		   |		(SELECT
		   |			ItemList.Store,
		   |			ItemList.ItemKey,
		   |			ItemList.SalesInvoice
		   |		FROM
		   |			ItemList AS ItemList)) AS StockReservation
		   |WHERE
		   |	StockReservation.QuantityBalance > 0
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	StockReservation.Store,
		   |	StockReservation.Order,
		   |	StockReservation.ItemKey,
		   |	StockReservation.QuantityBalance
		   |FROM
		   |	AccumulationRegister.R4012B_StockReservation.Balance(&BalancePeriod, (Store, ItemKey, Order) IN
		   |		(SELECT
		   |			ItemList.Store,
		   |			ItemList.ItemKey,
		   |			ItemList.InventoryTransferOrder
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
		   |		AND (TmpStockReservation.Basis = ItemListGroup.SalesOrder
		   |		OR TmpStockReservation.Basis = ItemListGroup.SalesInvoice
		   |		OR TmpStockReservation.Basis = ItemListGroup.InventoryTransferOrder)
		   |WHERE
		   |	ItemListGroup.Quantity > ISNULL(TmpStockReservation.Quantity, 0)
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
		   |	ItemList.Period,
		   |	ItemList.Store,
		   |	ItemList.ItemKey,
		   |	ItemList.SalesOrder,
		   |	ItemList.SalesInvoice,
		   |	ItemList.InventoryTransferOrder,
		   |	SUM(ItemList.Quantity) AS Quantity
		   |INTO ItemListGroup
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.SalesOrderExists
		   |	OR ItemList.SalesInvoiceExists
		   |	OR ItemList.InventoryTransferOrderExists
		   |GROUP BY
		   |	ItemList.Period,
		   |	ItemList.Store,
		   |	ItemList.ItemKey,
		   |	ItemList.SalesOrder,
		   |	ItemList.SalesInvoice,
		   |	ItemList.InventoryTransferOrder
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	*
		   |INTO TmpStockReservation
		   |FROM
		   |	AccumulationRegister.R4012B_StockReservation.Balance(&BalancePeriod, (Store, ItemKey, Order) IN
		   |		(SELECT
		   |			ItemList.Store,
		   |			ItemList.ItemKey,
		   |			ItemList.SalesOrder
		   |		FROM
		   |			ItemListGroup AS ItemList))
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	*
		   |FROM
		   |	AccumulationRegister.R4012B_StockReservation.Balance(&BalancePeriod, (Store, ItemKey, Order) IN
		   |		(SELECT
		   |			ItemList.Store,
		   |			ItemList.ItemKey,
		   |			ItemList.SalesInvoice
		   |		FROM
		   |			ItemListGroup AS ItemList))
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	*
		   |FROM
		   |	AccumulationRegister.R4012B_StockReservation.Balance(&BalancePeriod, (Store, ItemKey, Order) IN
		   |		(SELECT
		   |			ItemList.Store,
		   |			ItemList.ItemKey,
		   |			ItemList.InventoryTransferOrder
		   |		FROM
		   |			ItemListGroup AS ItemList)) AS StockReservation
		   |WHERE
		   |	StockReservation.QuantityBalance > 0
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.Period AS Period,
		   |	ItemList.SalesOrder AS Order,
		   |	ItemList.ItemKey AS ItemKey,
		   |	ItemList.Store AS Store,
		   |	CASE
		   |		WHEN StockReservation.QuantityBalance > ItemList.Quantity
		   |			THEN ItemList.Quantity
		   |		ELSE StockReservation.QuantityBalance
		   |	END AS Quantity
		   |INTO R4012B_StockReservation
		   |FROM
		   |	ItemListGroup AS ItemList
		   |		INNER JOIN TmpStockReservation AS StockReservation
		   |		ON (ItemList.SalesOrder = StockReservation.Order
		   |			OR ItemList.SalesInvoice = StockReservation.Order
		   |			OR ItemList.InventoryTransferOrder = StockReservation.Order)
		   |		AND ItemList.ItemKey = StockReservation.ItemKey
		   |		AND ItemList.Store = StockReservation.Store
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |DROP TmpStockReservation
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |DROP ItemListGroup";
EndFunction

Function R4032B_GoodsInTransitOutgoing()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |CASE
		   |	When (ItemList.IsTransaction_Sales OR ItemList.IsTransaction_ShipmentToTradeAgent) AND ItemList.SalesInvoiceExists Then
		   |		ItemList.SalesInvoice
		   |	When ItemList.IsTransaction_InventoryTransfer AND ItemList.InventoryTransferExists Then
		   |		ItemList.InventoryTransfer
		   |	When ItemList.IsTransaction_ReturnToVendor AND ItemList.PurchaseReturnExists Then
		   |		ItemList.PurchaseReturn
		   |ELSE
		   |		ItemList.ShipmentConfirmation
		   |END AS Basis,
		   |	*
		   |INTO R4032B_GoodsInTransitOutgoing
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE";

EndFunction

Function R4014B_SerialLotNumber()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |*
		   |INTO R4014B_SerialLotNumber
		   |FROM
		   |	SerialLotNumbers AS SerialLotNumbers
		   |WHERE
		   |	FALSE";

EndFunction

Function R4022B_StockTransferOrdersShipment()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.InventoryTransferOrder AS Order,
		   |	*
		   |INTO R4022B_StockTransferOrdersShipment
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.InventoryTransferOrderExists";

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
		   |	ItemList.SalesOrderExists
		   |	AND ItemList.SalesOrder.UseItemsShipmentScheduling";

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
		   |	Document.ShipmentConfirmation.ItemList AS ItemList
		   |		INNER JOIN Document.ShipmentConfirmation.RowIDInfo AS RowIDInfo
		   |		ON RowIDInfo.Ref = &Ref
		   |		AND ItemList.Ref = &Ref
		   |		AND RowIDInfo.Key = ItemList.Key
		   |		AND RowIDInfo.Ref = ItemList.Ref";
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