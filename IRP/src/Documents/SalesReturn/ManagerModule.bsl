#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	Parameters.IsReposting = False;
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ItemList.Ref.Company AS Company,
	|	ItemList.SalesInvoice AS SalesDocument,
	|	ItemList.Store AS Store,
	|	ItemList.ItemKey AS ItemKey,
	|	ItemList.Quantity AS Quantity
	|FROM
	|	Document.SalesReturn.ItemList AS ItemLIst
	|WHERE
	|	ItemList.Ref = &Ref
	|	AND NOT ItemLIst.SalesInvoice.Ref IS NULL";
	Query.SetParameter("Ref", Ref);
	ItemListTable = Query.Execute().Unload();
	ConsignorBatches = CommissionTradeServer.GetTableConsignorBatchWiseBalanceForSalesReturn(Parameters.Object, ItemListTable);
	
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = "SELECT * INTO ConsignorBatches FROM &T1 AS T1";
	Query.SetParameter("T1", ConsignorBatches);
	Query.Execute();
	
	Query = New Query();
	Query.Text =
	"SELECT
	|	SalesReturn.Ref AS Document,
	|	SalesReturn.Company AS Company,
	|	SalesReturn.Ref.Date AS Period
	|FROM
	|	Document.SalesReturn AS SalesReturn
	|WHERE
	|	SalesReturn.Ref = &Ref
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
	|	CASE
	|		WHEN NOT SalesReturnItemList.SalesInvoice.Ref IS NULL
	|		AND SalesReturnItemList.SalesInvoice REFS Document.SalesInvoice
	|			THEN TRUE
	|		ELSE FALSE
	|	END AS SalesInvoiceIsFilled,
	|	SalesReturnItemList.SalesInvoice AS SalesInvoice,
	|	SalesReturnItemList.SalesInvoice.Company AS SalesInvoice_Company
	|FROM
	|	Document.SalesReturn.ItemList AS SalesReturnItemList
	|WHERE
	|	SalesReturnItemList.Ref = &Ref
	|	AND SalesReturnItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Product)
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
	|	VALUE(Enum.BatchDirection.Receipt)";
	
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.ExecuteBatch();
	
	BatchesInfo   = QueryResults[0].Unload();
	BatchKeysInfo = QueryResults[1].Unload();
	
	DontCreateBatch = True;
	For Each BatchKey In BatchKeysInfo Do
		If Not BatchKey.SalesInvoiceIsFilled Then
			DontCreateBatch = False; // need create batch, invoice is empty
			Break;
		EndIf;
		If BatchKey.Company <> BatchKey.SalesInvoice_Company Then 
			DontCreateBatch = False; // need create batch, company in invoice and in return not match
			Break;
		EndIf; 
	EndDo;
	If DontCreateBatch Then
		BatchesInfo.Clear();
	EndIf;
	
	// AmountTax to T6020S_BatchKeysInfo
	Query = New Query();
	Query.Text = 
	"SELECT
	|	TaxList.Key,
	|	TaxList.Ref.Company,
	|	TaxList.Tax,
	|	TaxList.ManualAmount AS AmountTax
	|INTO TaxList
	|FROM
	|	Document.SalesReturn.TaxList AS TaxList
	|WHERE
	|	TaxList.Ref = &Ref
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TaxList.Key,
	|	SUM(TaxList.AmountTax) AS AmountTax
	|INTO TaxListAmounts
	|FROM
	|	TaxList AS TaxList
	|		INNER JOIN InformationRegister.Taxes.SliceLast(&Period, (Company, Tax) IN
	|			(SELECT
	|				TaxList.Company,
	|				TaxList.Tax
	|			FROM
	|				TaxList AS TaxList)) AS TaxesSliceLast
	|		ON TaxesSliceLast.Company = TaxList.Company
	|		AND TaxesSliceLast.Tax = TaxList.Tax
	|WHERE
	|	TaxesSliceLast.Use
	|	AND TaxesSliceLast.IncludeToLandedCost
	|GROUP BY
	|	TaxList.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchKeysInfo.Key,
	|	*
	|INTO BatchKeysInfo
	|FROM
	|	&BatchKeysInfo AS BatchKeysInfo
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchKeysInfo.Key,
	|	ISNULL(TaxListAmounts.AmountTax, 0) AS AmountTax,
	|	BatchKeysInfo.*
	|FROM
	|	BatchKeysInfo AS BatchKeysInfo
	|		LEFT JOIN TaxListAmounts AS TaxListAmounts
	|		ON BatchKeysInfo.Key = TaxListAmounts.Key AND NOT BatchKeysInfo.SalesInvoiceIsFilled";
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("Period", Ref.Date);
	Query.SetParameter("BatchKeysInfo", BatchKeysInfo);
	QueryResult = Query.Execute();
	BatchKeysInfo = QueryResult.Unload();
	
	CurrencyTable = Ref.Currencies.UnloadColumns();
	CurrencyMovementType = Ref.Company.LandedCostCurrencyMovementType;
	For Each Row In BatchKeysInfo Do
		CurrenciesServer.AddRowToCurrencyTable(Ref.Date, CurrencyTable, Row.Key, Row.Currency, CurrencyMovementType);
	EndDo;
	
	PostingDataTables = New Map();
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.T6020S_BatchKeysInfo,
		New Structure("RecordSet, WriteInTransaction", BatchKeysInfo, Parameters.IsReposting));
	Parameters.Insert("PostingDataTables", PostingDataTables);
	CurrenciesServer.PreparePostingDataTables(Parameters, CurrencyTable, AddInfo);
	
	BatchKeysInfoMetadata = Parameters.Object.RegisterRecords.T6020S_BatchKeysInfo.Metadata();
	If Parameters.Property("MultiCurrencyExcludePostingDataTables") Then
		Parameters.MultiCurrencyExcludePostingDataTables.Add(BatchKeysInfoMetadata);
	Else
		ArrayOfMultiCurrencyExcludePostingDataTables = New Array();
		ArrayOfMultiCurrencyExcludePostingDataTables.Add(BatchKeysInfoMetadata);
		Parameters.Insert("MultiCurrencyExcludePostingDataTables", ArrayOfMultiCurrencyExcludePostingDataTables);
	EndIf;
	
	BatchKeysInfo_DataTable = Parameters.PostingDataTables.Get(Parameters.Object.RegisterRecords.T6020S_BatchKeysInfo).RecordSet;
	BatchKeysInfo_DataTableGrouped = BatchKeysInfo_DataTable.CopyColumns();
	If BatchKeysInfo_DataTable.Count() Then
		BatchKeysInfo_DataTableGrouped = BatchKeysInfo_DataTable.Copy(New Structure("CurrencyMovementType", CurrencyMovementType));
		BatchKeysInfo_DataTableGrouped.GroupBy("Period, Direction, Company, Store, ItemKey, Currency, CurrencyMovementType, SalesInvoice", 
		"Quantity, Amount, AmountTax");	
	EndIf;
	
	BatchKeysInfo_DataTableGrouped.Columns.Add("BatchConsignor", New TypeDescription("DocumentRef.PurchaseInvoice"));
	BatchKeysInfo_DataTableGrouped.Columns.Add("__tmp_Quantity");
	BatchKeysInfo_DataTableGrouped.Columns.Add("__tmp_Amount");
	BatchKeysInfo_DataTableGrouped.Columns.Add("__tmp_AmountTax");
	For Each Row In BatchKeysInfo_DataTableGrouped Do
		Row.__tmp_Quantity  = Row.Quantity;
		Row.__tmp_Amount    = Row.Amount;
		Row.__tmp_AmountTax = Row.AmountTax;
	EndDo;
	
	BatchKeysInfo_DataTableGrouped_Copy = BatchKeysInfo_DataTableGrouped.CopyColumns();
	
	For Each Row In BatchKeysInfo_DataTableGrouped Do
		Filter = New Structure();
		Filter.Insert("Company"       , Row.Company);	
		Filter.Insert("Store"         , Row.Store);	
		Filter.Insert("ItemKey"       , Row.ItemKey);	
		Filter.Insert("SalesDocument" , Row.SalesInvoice);
		
		FilteredRows = ConsignorBatches.FindRows(Filter);
		
		If Not FilteredRows.Count() Then
			FillPropertyValues(BatchKeysInfo_DataTableGrouped_Copy.Add(), Row);
			Continue;
		EndIf;
		
		NeedQuantity = Row.Quantity;
		For Each BatchRow In FilteredRows Do
			NewRow = BatchKeysInfo_DataTableGrouped_Copy.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.Quantity = Min(NeedQuantity, BatchRow.Quantity);
			NewRow.BatchConsignor = BatchRow.Batch;
			
			NeedQuantity = NeedQuantity - NewRow.Quantity;
			BatchRow.Quantity = BatchRow.Quantity - NewRow.Quantity;
		EndDo;
		
		If NeedQuantity <> 0 Then
			NewRow = BatchKeysInfo_DataTableGrouped_Copy.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.Quantity = NeedQuantity;
		EndIf;
	EndDo;
	
	For Each Row In BatchKeysInfo_DataTableGrouped_Copy Do
		If Not ValueIsFilled(Row.__tmp_Quantity) Then
			Row.tmp_Amount = 0;
			Row.AmountTax  = 0;
		Else
			Row.Amount    = Row.__tmp_Amount / Row.__tmp_Quantity * Row.Quantity;
			Row.AmountTax = Row.__tmp_AmountTax / Row.__tmp_Quantity * Row.Quantity;
		EndIf;
	EndDo;
	
	BatchKeysInfo_DataTableGrouped_Copy.Columns.Delete("__tmp_Quantity");
	BatchKeysInfo_DataTableGrouped_Copy.Columns.Delete("__tmp_Amount");
	BatchKeysInfo_DataTableGrouped_Copy.Columns.Delete("__tmp_AmountTax");
		
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT
	|	*
	|INTO BatchesInfo
	|FROM
	|	&T1 AS T1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	*
	|INTO BatchKeysInfo
	|FROM
	|	&T2 AS T2";
	Query.SetParameter("T1", BatchesInfo);
	Query.SetParameter("T2", BatchKeysInfo_DataTableGrouped_Copy);
	Query.Execute();

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
	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref, "Document.SalesReturn.ItemList");
	
	CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo);
	
	If Not Cancel And Not AccReg.R4014B_SerialLotNumber.CheckBalance(Ref, LineNumberAndItemKeyFromItemList, 
		PostingServer.GetQueryTableByName("R4014B_SerialLotNumber", Parameters), 
		PostingServer.GetQueryTableByName("Exists_R4014B_SerialLotNumber", Parameters),
		AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
	
	If Not Cancel And Ref.TransactionType = Enums.SalesReturnTransactionTypes.ReturnFromCustomer 
		And Not AccReg.R2001T_Sales.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R2001T_Sales", Parameters),
		PostingServer.GetQueryTableByName("Exists_R2001T_Sales", Parameters),
		AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.SalesReturn.ItemList", AddInfo);
EndProcedure

#EndRegion

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
	StrParams.Insert("Period", Ref.Date);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array();
	QueryArray.Add(ItemList());
	QueryArray.Add(OffersInfo());
	QueryArray.Add(GoodReceiptInfo());
	QueryArray.Add(Taxes());
	QueryArray.Add(SerialLotNumbers());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4014B_SerialLotNumber());
	QueryArray.Add(PostingServer.Exists_R2001T_Sales());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R2001T_Sales());
	QueryArray.Add(R2002T_SalesReturns());
	QueryArray.Add(R2005T_SalesSpecialOffers());
	QueryArray.Add(R2012B_SalesOrdersInvoiceClosing());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(R2031B_ShipmentInvoicing());
	QueryArray.Add(R2040B_TaxesIncoming());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4014B_SerialLotNumber());
	QueryArray.Add(R4031B_GoodsInTransitIncoming());
	QueryArray.Add(R4050B_StockInventory());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5021T_Revenues());
	QueryArray.Add(R5011B_CustomersAging());
	QueryArray.Add(T3010S_RowIDInfo());
	QueryArray.Add(T2015S_TransactionsInfo());
	QueryArray.Add(T6010S_BatchesInfo());
	QueryArray.Add(T6020S_BatchKeysInfo());
	QueryArray.Add(R8010B_TradeAgentInventory());
	QueryArray.Add(R8011B_TradeAgentSerialLotNumber());
	QueryArray.Add(R8013B_ConsignorBatchWiseBalance());
	QueryArray.Add(R8012B_ConsignorInventory());
	QueryArray.Add(R8014T_ConsignorSales());
	Return QueryArray;
EndFunction

Function ItemList()
	Return 
	"SELECT
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
	|	ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
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
	|	ItemList.Ref.TransactionType = Value(Enum.SalesReturnTransactionTypes.ReturnFromTradeAgent) AS IsReturnFromTradeAgent,
	|	ItemList.Ref.TransactionType = Value(Enum.SalesReturnTransactionTypes.ReturnFromCustomer) AS IsReturnFromCustomer,
	|	ItemList.Ref.Company.TradeAgentStore AS TradeAgentStore
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
	Return 
		"SELECT
		|	SalesReturnItemList.Ref.Date AS Period,
		|	SalesReturnItemList.Key AS RowKey,
		|	SalesReturnItemList.ItemKey,
		|	SalesReturnItemList.Ref.Company AS Company,
		|	SalesReturnItemList.Ref.Branch AS Branch,
		|	SalesReturnItemList.Ref.Currency,
		|	SalesReturnSpecialOffers.Offer AS SpecialOffer,
		|	SalesReturnItemList.SalesInvoice AS Invoice,
		|	-SalesReturnSpecialOffers.Amount AS OffersAmount,
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
	Return 
		"SELECT
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

Function Taxes()
	Return 
		"SELECT
		|	TaxList.Ref.Date AS Period,
		|	TaxList.Ref.Company AS Company,
		|	TaxList.Ref.Branch AS Branch,
		|	TaxList.Tax AS Tax,
		|	TaxList.TaxRate AS TaxRate,
		|	CASE
		|		WHEN TaxList.ManualAmount = 0
		|			THEN TaxList.Amount
		|		ELSE TaxList.ManualAmount
		|	END AS TaxAmount,
		|	ItemList.NetAmount AS TaxableAmount,
		|	TaxList.Ref.TransactionType = Value(Enum.SalesReturnTransactionTypes.ReturnFromTradeAgent) AS IsReturnFromTradeAgent,
		|	TaxList.Ref.TransactionType = Value(Enum.SalesReturnTransactionTypes.ReturnFromCustomer) AS IsReturnFromCustomer
		|INTO Taxes
		|FROM
		|	Document.SalesReturn.ItemList AS ItemList
		|		INNER JOIN Document.SalesReturn.TaxList AS TaxList
		|		ON ItemList.Key = TaxList.Key
		|		AND ItemList.Ref = &Ref
		|		AND TaxList.Ref = &Ref";
EndFunction

Function R2001T_Sales()
	Return 
		"SELECT
		|	-ItemList.Quantity AS Quantity,
		|	-ItemList.Amount AS Amount,
		|	-ItemList.NetAmount AS NetAmount,
		|	-ItemList.OffersAmount AS OffersAmount,
		|	ItemList.SalesInvoice AS Invoice,
		|	*
		|INTO R2001T_Sales
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsReturnFromCustomer";
EndFunction

Function R2002T_SalesReturns()
	Return 
		"SELECT
		|	ItemList.SalesInvoice AS Invoice,
		|	*
		|INTO R2002T_SalesReturns
		|FROM
		|	ItemList AS ItemList
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
	Return 
		"SELECT
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
		|	UNDEFINED AS CustomersAdvancesClosing,
		|	-SUM(ItemList.Amount) AS Amount
		|INTO R2021B_CustomersTransactions
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsReturnFromCustomer
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

Function R2020B_AdvancesFromCustomers()
	Return 
	"SELECT
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	OffsetOfAdvances.Period,
	|	OffsetOfAdvances.Company,
	|	OffsetOfAdvances.Branch,
	|	OffsetOfAdvances.Partner,
	|	OffsetOfAdvances.LegalName,
	|	OffsetOfAdvances.Currency,
	|	OffsetOfAdvances.Amount,
	|	UNDEFINED AS Key,
	|	OffsetOfAdvances.Recorder AS CustomersAdvancesClosing
	|FROM
	|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
	|WHERE
	|	OffsetOfAdvances.Document = &Ref";
EndFunction

Function R5011B_CustomersAging()
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
		   |INTO R5011B_CustomersAging
		   |FROM
		   |	InformationRegister.T2013S_OffsetOfAging AS OffsetOfAging
		   |WHERE
		   |	OffsetOfAging.Document = &Ref";
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
		   |		ON ItemList.RowKey = GoodReceipts.Key
		   |WHERE
		   |	TRUE";
EndFunction

Function R2040B_TaxesIncoming()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	-Taxes.TaxableAmount,
		|	-Taxes.TaxAmount,
		|	*
		|INTO R2040B_TaxesIncoming
		|FROM
		|	Taxes AS Taxes
		|WHERE
		|	Taxes.IsReturnFromCustomer";
EndFunction

#Region Stock

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
	Return 
		"SELECT
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
		|	ConsignorBatches.Company,
		|	ConsignorBatches.ItemKey,
		|	ConsignorBatches.Store,
		|	SUM(ConsignorBatches.Quantity) AS Quantity
		|INTO ConsignorBatchesGrouped
		|FROM
		|	ConsignorBatches AS ConsignorBatches
		|GROUP BY
		|	ConsignorBatches.Company,
		|	ConsignorBatches.ItemKey,
		|	ConsignorBatches.Store
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemLIst.Store,
		|	ItemList.ItemKey,
		|	SUM(ItemList.Quantity) AS Quantity
		|INTO ItemListGrouped
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemLIst.Store,
		|	ItemList.ItemKey
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemLIst.Store,
		|	ItemList.ItemKey,
		|	SUM(ItemList.Quantity - ISNULL(ConsignorBatches.Quantity, 0)) AS Quantity
		|INTO R4050B_StockInventory
		|FROM
		|	ItemListGrouped AS ItemList
		|		LEFT JOIN ConsignorBatchesGrouped AS ConsignorBatches
		|		ON ItemList.Company = ConsignorBatches.Company
		|		AND ItemList.ItemKey = ConsignorBatches.ItemKey
		|		AND ItemList.Store = ConsignorBatches.Store
		|GROUP BY
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemLIst.Store,
		|	ItemList.ItemKey
		|HAVING
		|	SUM(ItemList.Quantity - ISNULL(ConsignorBatches.Quantity, 0)) > 0
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
	Return 
		"SELECT
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
	Return 
		"SELECT
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
		|	Document.SalesReturn.ItemList AS ItemList
		|		INNER JOIN Document.SalesReturn.RowIDInfo AS RowIDInfo
		|		ON RowIDInfo.Ref = &Ref
		|		AND ItemList.Ref = &Ref
		|		AND RowIDInfo.Key = ItemList.Key
		|		AND RowIDInfo.Ref = ItemList.Ref";
EndFunction

Function T2015S_TransactionsInfo()
	Return 
		"SELECT
		|	ItemList.Period AS Date,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	TRUE AS IsCustomerTransaction,
		|	ItemList.BasisDocument AS TransactionBasis,
		|	-SUM(ItemList.Amount) AS Amount,
		|	TRUE AS IsDue
		|INTO T2015S_TransactionsInfo
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsReturnFromCustomer
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.BasisDocument";
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
		|	BatchKeysInfo.Period,
		|	BatchKeysInfo.Company,
		|	BatchKeysInfo.Currency,
		|	BatchKeysInfo.CurrencyMovementType,
		|	BatchKeysInfo.Direction,
		|	BatchKeysInfo.SalesInvoice,
		|	BatchKeysInfo.ItemKey,
		|	BatchKeysInfo.Store,
		|	SUM(BatchKeysInfo.Quantity) AS Quantity,
		|	SUM(BatchKeysInfo.Amount) AS Amount,
		|	SUM(BatchKeysInfo.AmountTax) AS AmountTax,
		|	BatchKeysInfo.BatchConsignor
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
		|	BatchKeysInfo.BatchConsignor
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
		|	SUM(ItemList.Quantity),
		|	0,
		|	0,
		|	UNDEFINED
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|	AND ItemList.IsReturnFromTradeAgent
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.Company,
		|	VALUE(Enum.BatchDirection.Expense),
		|	ItemList.ItemKey,
		|	ItemList.TradeAgentStore";
EndFunction

Function R8010B_TradeAgentInventory()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.ItemKey,
		|	ItemList.Partner,
		|	ItemList.Agreement,
		|	SUM(ItemList.Quantity) AS Quantity
		|INTO R8010B_TradeAgentInventory
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|	AND ItemList.IsReturnFromTradeAgent
		|GROUP BY
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.ItemKey,
		|	ItemList.Partner,
		|	ItemList.Agreement";
EndFunction

Function R8011B_TradeAgentSerialLotNumber()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	SerialLotNumbers.Period,
		|	SerialLotNumbers.Company,
		|	SerialLotNumbers.ItemKey,
		|	SerialLotNumbers.Partner,
		|	SerialLotNumbers.Agreement,
		|	SerialLotNumbers.SerialLotNumber,
		|	SerialLotNumbers.Quantity
		|INTO R8011B_TradeAgentSerialLotNumber
		|FROM
		|	SerialLotNumbers AS SerialLotNumbers
		|WHERE
		|	SerialLotNumbers.IsReturnFromTradeAgent";
EndFunction

Function R8013B_ConsignorBatchWiseBalance()
	Return
		"SELECT
		|	&Period AS Period,
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ConsignorBatches.Company,
		|	ConsignorBatches.Batch,
		|	ConsignorBatches.Store,
		|	ConsignorBatches.ItemKey,
		|	SUM(ConsignorBatches.Quantity) AS Quantity
		|INTO R8013B_ConsignorBatchWiseBalance
		|FROM
		|	ConsignorBatches AS ConsignorBatches
		|WHERE
		|	TRUE
		|GROUP BY
		|	VALUE(AccumulationRecordType.Receipt),
		|	ConsignorBatches.Company,
		|	ConsignorBatches.Batch,
		|	ConsignorBatches.Store,
		|	ConsignorBatches.ItemKey";
EndFunction
		
Function R8012B_ConsignorInventory()
	Return
		"SELECT
		|	&Period AS Period,
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ConsignorBatches.Company,
		|	ConsignorBatches.ItemKey,
		|	ConsignorBatches.Batch.Partner AS Partner,
		|	ConsignorBatches.Batch.Agreement AS Agreement,
		|	SUM(ConsignorBatches.Quantity) AS Quantity
		|INTO R8012B_ConsignorInventory
		|FROM
		|	ConsignorBatches AS ConsignorBatches
		|WHERE
		|	TRUE
		|GROUP BY
		|	VALUE(AccumulationRecordType.Receipt),
		|	ConsignorBatches.Company,
		|	ConsignorBatches.ItemKey,
		|	ConsignorBatches.Batch.Partner,
		|	ConsignorBatches.Batch.Agreement";		
EndFunction
		
Function R8014T_ConsignorSales()
	Return
		"SELECT
		|	BatchKeysInfo.Period,
		|	BatchKeysInfo.Company,
		|	BatchKeysInfo.SalesInvoice,
		|	BatchKeysInfo.ItemKey,
		|	SUM(BatchKeysInfo.Quantity) AS Quantity,
		|	BatchKeysInfo.BatchConsignor
		|INTO ReturnedConsignorBatches
		|FROM
		|	BatchKeysInfo
		|WHERE
		|	NOT BatchKeysInfo.BatchConsignor.Ref IS NULL
		|GROUP BY
		|	BatchKeysInfo.Period,
		|	BatchKeysInfo.Company,
		|	BatchKeysInfo.SalesInvoice,
		|	BatchKeysInfo.ItemKey,
		|	BatchKeysInfo.BatchConsignor
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ConsignorSales.*
		|INTO ConsignorSales
		|FROM
		|	AccumulationRegister.R8014T_ConsignorSales AS ConsignorSales
		|WHERE
		|	(Company, Recorder, PurchaseInvoice, ItemKey) IN
		|		(SELECT
		|			ReturnedConsignorBatches.Company,
		|			ReturnedConsignorBatches.SalesInvoice,
		|			ReturnedConsignorBatches.BatchConsignor,
		|			ReturnedConsignorBatches.ItemKey
		|		FROM
		|			ReturnedConsignorBatches AS ReturnedConsignorBatches)
		|	AND ConsignorSales.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ReturnedConsignorBatches.Period,
		|	ConsignorSales.RowKey AS Key,
		|	ConsignorSales.RowKey AS RowKey,
		|	ConsignorSales.Currency,
		|	-ReturnedConsignorBatches.Quantity AS Quantity,
		|	-case
		|		when ConsignorSales.Quantity = 0
		|			then 0
		|		else (ConsignorSales.NetAmount / ConsignorSales.Quantity) * ReturnedConsignorBatches.Quantity
		|	end AS NetAmount,
		|	-case
		|		when ConsignorSales.Quantity = 0
		|			then 0
		|		else (ConsignorSales.Amount / ConsignorSales.Quantity) * ReturnedConsignorBatches.Quantity
		|	end AS Amount,
		|	ConsignorSales.*
		|INTO R8014T_ConsignorSales
		|FROM
		|	ConsignorSales AS ConsignorSales
		|		INNER JOIN ReturnedConsignorBatches AS ReturnedConsignorBatches
		|		ON ReturnedConsignorBatches.Company = ConsignorSales.Company
		|		AND ReturnedConsignorBatches.SalesInvoice = ConsignorSales.SalesInvoice
		|		AND ReturnedConsignorBatches.ItemKey = ConsignorSales.ItemKey
		|		AND ReturnedConsignorBatches.BatchConsignor = ConsignorSales.PurchaseInvoice";
EndFunction	
