#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;
	Parameters.IsReposting = False;
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	Tables.Insert("VendorsTransactions", PostingServer.GetQueryTableByName("VendorsTransactions", Parameters));

	Query = New Query;
	Query.Text =
	"SELECT
	|	RowIDInfo.Ref AS Ref,
	|	RowIDInfo.Key AS Key,
	|	MAX(RowIDInfo.RowID) AS RowID
	|INTO tmpRowIDInfo
	|FROM
	|	Document.PurchaseInvoice.RowIDInfo AS RowIDInfo
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
	|	PurchaseInvoice.Ref AS Document,
	|	PurchaseInvoice.Company AS Company,
	|	PurchaseInvoice.Ref.Date AS Period
	|FROM
	|	Document.PurchaseInvoice AS PurchaseInvoice
	|WHERE
	|	PurchaseInvoice.Ref = &Ref
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
	|	Document.PurchaseInvoice.SourceOfOrigins AS SourceOfOrigins
	|WHERE
	|	SourceOfOrigins.Ref = &Ref
	|
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
	|	ItemList.Ref.Company AS Company,
	|	SUM(ItemList.QuantityInBaseUnit) AS Quantity,
	|	ItemList.Ref.Date AS Period,
	|	VALUE(Enum.BatchDirection.Receipt) AS Direction,
	|	ItemList.Key AS Key,
	|	SUM(ItemList.NetAmount) AS Amount,
	|	ItemList.Ref.Currency AS Currency,
	|	ItemList.IsAdditionalItemCost AS IsAdditionalItemCost,
	|	RowIDInfo.RowID AS RowID
	|INTO tmpItemList
	|FROM
	|	Document.PurchaseInvoice.ItemList AS ItemList
	|		INNER JOIN tmpRowIDInfo AS RowIDInfo
	|		ON ItemList.Key = RowIDInfo.Key
	|			AND (RowIDInfo.Ref = &Ref)
	|WHERE
	|	ItemList.Ref = &Ref
	|	AND ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Product)
	|	AND NOT ItemList.IsAdditionalItemCost
	|
	|GROUP BY
	|	ItemList.ItemKey,
	|	ItemList.Store,
	|	ItemList.Ref.Company,
	|	ItemList.Ref.Date,
	|	ItemList.Key,
	|	ItemList.Ref.Currency,
	|	ItemList.IsAdditionalItemCost,
	|	RowIDInfo.RowID
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpItemList.ItemKey AS ItemKey,
	|	tmpItemList.Store AS Store,
	|	tmpItemList.Company AS Company,
	|	tmpItemList.Quantity AS TotalQuantity,
	|	tmpItemList.Period AS Period,
	|	tmpItemList.Direction AS Direction,
	|	tmpItemList.Key AS Key,
	|	tmpItemList.Amount AS TotalAmount,
	|	tmpItemList.Currency AS Currency,
	|	tmpItemList.IsAdditionalItemCost AS IsAdditionalItemCost,
	|	tmpItemList.RowID AS RowID,
	|	ISNULL(tmpSourceOfOrigins.Quantity, 0) AS QuantityBySourceOrigin,
	|	CASE
	|		WHEN ISNULL(tmpSourceOfOrigins.Quantity, 0) <> 0
	|			THEN ISNULL(tmpSourceOfOrigins.Quantity, 0)
	|		ELSE tmpItemList.Quantity
	|	END AS Quantity,
	|	CASE
	|		WHEN tmpItemList.Quantity <> 0
	|			THEN CASE
	|					WHEN ISNULL(tmpSourceOfOrigins.Quantity, 0) <> 0
	|						THEN tmpItemList.Amount / tmpItemList.Quantity * ISNULL(tmpSourceOfOrigins.Quantity, 0)
	|					ELSE tmpItemList.Amount
	|				END
	|		ELSE 0
	|	END AS Amount,
	|	ISNULL(tmpSourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)) AS SourceOfOrigin,
	|	ISNULL(tmpSourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber
	|FROM
	|	tmpItemList AS tmpItemList
	|		LEFT JOIN tmpSourceOfOrigins AS tmpSourceOfOrigins
	|		ON tmpItemList.Key = tmpSourceOfOrigins.Key";
	Query.SetParameter("Ref", Ref);

	QueryResults = Query.ExecuteBatch();

	BatchesInfo   = QueryResults[1].Unload();
	BatchKeysInfo = QueryResults[4].Unload();

	If Not BatchKeysInfo.Count() Then
		BatchesInfo.Clear();
	EndIf;
	
	// AmountTax to T6020S_BatchKeysInfo
	Query = New Query;
	Query.Text =
	"SELECT
	|	TaxList.Key,
	|	TaxList.Ref.Company,
	|	TaxList.Tax,
	|	TaxList.ManualAmount AS AmountTax
	|INTO TaxList
	|FROM
	|	Document.PurchaseInvoice.TaxList AS TaxList
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
	|	BatchKeysInfo.TotalQuantity,
	|	BatchKeysInfo.Quantity,
	|	*
	|INTO BatchKeysInfo
	|FROM
	|	&BatchKeysInfo AS BatchKeysInfo
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchKeysInfo.Key,
	|	case
	|		when BatchKeysInfo.TotalQuantity <> 0
	|			then (isnull(TaxListAmounts.AmountTax, 0) / BatchKeysInfo.TotalQuantity) * BatchKeysInfo.Quantity
	|		else 0
	|	end as AmountTax,
	|	BatchKeysInfo.*
	|FROM
	|	BatchKeysInfo AS BatchKeysInfo
	|		LEFT JOIN TaxListAmounts AS TaxListAmounts
	|		ON BatchKeysInfo.Key = TaxListAmounts.Key";
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("Period", Ref.Date);
	Query.SetParameter("BatchKeysInfo", BatchKeysInfo);
	QueryResult = Query.Execute();
	BatchKeysInfo = QueryResult.Unload();

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

	For Each Row In BatchKeysInfo Do
		CurrenciesServer.AddRowToCurrencyTable(Ref.Date, CurrencyTable, Row.Key, Row.Currency, CurrencyMovementType,
			ArrayOfFixedRates);
	EndDo;

	PostingDataTables = New Map;
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.T6020S_BatchKeysInfo,
		New Structure("RecordSet, WriteInTransaction", BatchKeysInfo, Parameters.IsReposting));
	Parameters.Insert("PostingDataTables", PostingDataTables);
	CurrenciesServer.PreparePostingDataTables(Parameters, CurrencyTable, AddInfo);

	BatchKeysInfoMetadata = Parameters.Object.RegisterRecords.T6020S_BatchKeysInfo.Metadata();
	If Parameters.Property("MultiCurrencyExcludePostingDataTables") Then
		Parameters.MultiCurrencyExcludePostingDataTables.Add(BatchKeysInfoMetadata);
	Else
		ArrayOfMultiCurrencyExcludePostingDataTables = New Array;
		ArrayOfMultiCurrencyExcludePostingDataTables.Add(BatchKeysInfoMetadata);
		Parameters.Insert("MultiCurrencyExcludePostingDataTables", ArrayOfMultiCurrencyExcludePostingDataTables);
	EndIf;

	BatchKeysInfo_DataTable = Parameters.PostingDataTables.Get(
		Parameters.Object.RegisterRecords.T6020S_BatchKeysInfo).RecordSet;
	BatchKeysInfo_DataTableGrouped = BatchKeysInfo_DataTable.CopyColumns();
	If BatchKeysInfo_DataTable.Count() Then
		BatchKeysInfo_DataTableGrouped = BatchKeysInfo_DataTable.Copy(
			New Structure("CurrencyMovementType", CurrencyMovementType));
		BatchKeysInfo_DataTableGrouped.GroupBy(
			"Period, RowID, Direction, Company, Store, ItemKey, Currency, CurrencyMovementType, SourceOfOrigin, SerialLotNumber",
			"Quantity, Amount, AmountTax");
	EndIf;

	Query = New Query;
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
	Query.SetParameter("T2", BatchKeysInfo_DataTableGrouped);
	Query.Execute();

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

	Tables.R8015T_ConsignorPrices.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);

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
		"Document.PurchaseInvoice.ItemList");

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
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.PurchaseInvoice.ItemList", AddInfo);
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
	QueryArray.Add(ItemListLandedCost());
	QueryArray.Add(SerialLotNumbers());
	QueryArray.Add(IncomingStocksReal());
	QueryArray.Add(SourceOfOrigins());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	QueryArray.Add(Exists_R4035B_IncomingStocks());
	QueryArray.Add(Exists_R4036B_IncomingStocksRequested());
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
		   |	Document.PurchaseInvoice.RowIDInfo AS RowIDInfo
		   |WHERE
		   |	RowIDInfo.Ref = &Ref
		   |GROUP BY
		   |	RowIDInfo.Ref,
		   |	RowIDInfo.Key
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	GoodsReceipts.Key
		   |INTO GoodsReceipts
		   |FROM
		   |	Document.PurchaseInvoice.GoodsReceipts AS GoodsReceipts
		   |WHERE
		   |	GoodsReceipts.Ref = &Ref
		   |GROUP BY
		   |	GoodsReceipts.Key
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	PurchaseInvoiceItemList.Ref.Date AS Period,
		   |	PurchaseInvoiceItemList.Ref AS Invoice,
		   |	TableRowIDInfo.RowID AS RowKey,
		   |	PurchaseInvoiceItemList.ItemKey,
		   |	PurchaseInvoiceItemList.Ref.Company AS Company,
		   |	PurchaseInvoiceItemList.Ref.Currency,
		   |	PurchaseInvoiceSpecialOffers.Offer AS SpecialOffer,
		   |	PurchaseInvoiceSpecialOffers.Amount AS OffersAmount,
		   |	PurchaseInvoiceSpecialOffers.Bonus AS OffersBonus,
		   |	PurchaseInvoiceSpecialOffers.AddInfo AS OffersAddInfo,
		   |	PurchaseInvoiceSpecialOffers.Ref.Branch AS Branch
		   |INTO OffersInfo
		   |FROM
		   |	Document.PurchaseInvoice.ItemList AS PurchaseInvoiceItemList
		   |		INNER JOIN Document.PurchaseInvoice.SpecialOffers AS PurchaseInvoiceSpecialOffers
		   |		ON PurchaseInvoiceItemList.Key = PurchaseInvoiceSpecialOffers.Key
		   |		INNER JOIN TableRowIDInfo AS TableRowIDInfo
		   |		ON PurchaseInvoiceItemList.Key = TableRowIDInfo.Key
		   |WHERE
		   |	PurchaseInvoiceItemList.Ref = &Ref
		   |	AND PurchaseInvoiceSpecialOffers.Ref = &Ref
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	PurchaseInvoiceItemList.Ref.Company AS Company,
		   |	PurchaseInvoiceItemList.Store AS Store,
		   |	PurchaseInvoiceItemList.UseGoodsReceipt AS UseGoodsReceipt,
		   |	NOT PurchaseInvoiceItemList.PurchaseOrder = VALUE(Document.PurchaseOrder.EmptyRef) AS PurchaseOrderExists,
		   |	NOT PurchaseInvoiceItemList.SalesOrder = VALUE(Document.SalesOrder.EmptyRef) AS SalesOrderExists,
		   |	NOT PurchaseInvoiceItemList.InternalSupplyRequest = VALUE(Document.InternalSupplyRequest.EmptyRef) AS InternalSupplyRequestExists,
		   |	NOT GoodsReceipts.Key IS NULL AS GoodsReceiptExists,
		   |	PurchaseInvoiceItemList.ItemKey AS ItemKey,
		   |	PurchaseInvoiceItemList.PurchaseOrder AS PurchaseOrder,
		   |	PurchaseInvoiceItemList.SalesOrder AS SalesOrder,
		   |	PurchaseInvoiceItemList.InternalSupplyRequest,
		   |	PurchaseInvoiceItemList.Ref AS Invoice,
		   |	PurchaseInvoiceItemList.Quantity AS UnitQuantity,
		   |	PurchaseInvoiceItemList.Price AS Price,
		   |	PurchaseInvoiceItemList.QuantityInBaseUnit AS Quantity,
		   |	PurchaseInvoiceItemList.TotalAmount AS Amount,
		   |	PurchaseInvoiceItemList.Ref.Partner AS Partner,
		   |	PurchaseInvoiceItemList.Ref.LegalName AS LegalName,
		   |	CASE
		   |		WHEN PurchaseInvoiceItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		   |		AND PurchaseInvoiceItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		   |			THEN PurchaseInvoiceItemList.Ref.Agreement.StandardAgreement
		   |		ELSE PurchaseInvoiceItemList.Ref.Agreement
		   |	END AS Agreement,
		   |	CASE
		   |		WHEN PurchaseInvoiceItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		   |			THEN PurchaseInvoiceItemList.Ref
		   |		ELSE UNDEFINED
		   |	END AS BasisDocument,
		   |	ISNULL(PurchaseInvoiceItemList.Ref.Currency, VALUE(Catalog.Currencies.EmptyRef)) AS Currency,
		   |	PurchaseInvoiceItemList.Unit AS Unit,
		   |	PurchaseInvoiceItemList.ItemKey.Item AS Item,
		   |	PurchaseInvoiceItemList.Ref.Date AS Period,
		   |	TableRowIDInfo.RowID AS RowKey,
		   |	PurchaseInvoiceItemList.AdditionalAnalytic AS AdditionalAnalytic,
		   |	PurchaseInvoiceItemList.ProfitLossCenter AS ProfitLossCenter,
		   |	PurchaseInvoiceItemList.ExpenseType AS ExpenseType,
		   |	PurchaseInvoiceItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
		   |	PurchaseInvoiceItemList.DeliveryDate AS DeliveryDate,
		   |	PurchaseInvoiceItemList.NetAmount AS NetAmount,
		   |	PurchaseInvoiceItemList.TaxAmount AS TaxAmount,
		   |	PurchaseInvoiceItemList.Key,
		   |	PurchaseInvoiceItemList.PriceType,
		   |	PurchaseInvoiceItemList.Ref.Branch AS Branch,
		   |	PurchaseInvoiceItemList.Ref.LegalNameContract AS LegalNameContract,
		   |	PurchaseInvoiceItemList.Ref.RecordPurchasePrices AS RecordPurchasePrices,
		   |	PurchaseInvoiceItemList.IsAdditionalItemCost,
		   |	PurchaseInvoiceItemList.Ref.TransactionType = value(Enum.PurchaseTransactionTypes.Purchase) AS IsPurchase,
		   |	PurchaseInvoiceItemList.Ref.TransactionType = value(Enum.PurchaseTransactionTypes.ReceiptFromConsignor) AS IsReceiptFromConsignor
		   |INTO ItemList
		   |FROM
		   |	Document.PurchaseInvoice.ItemList AS PurchaseInvoiceItemList
		   |		LEFT JOIN GoodsReceipts AS GoodsReceipts
		   |		ON PurchaseInvoiceItemList.Key = GoodsReceipts.Key
		   |		LEFT JOIN TableRowIDInfo AS TableRowIDInfo
		   |		ON PurchaseInvoiceItemList.Key = TableRowIDInfo.Key
		   |WHERE
		   |	PurchaseInvoiceItemList.Ref = &Ref
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	PurchaseInvoiceGoodsReceipts.Key,
		   |	PurchaseInvoiceGoodsReceipts.GoodsReceipt,
		   |	PurchaseInvoiceGoodsReceipts.Quantity
		   |INTO GoodReceiptInfo
		   |FROM
		   |	Document.PurchaseInvoice.GoodsReceipts AS PurchaseInvoiceGoodsReceipts
		   |WHERE
		   |	PurchaseInvoiceGoodsReceipts.Ref = &Ref
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	PurchaseInvoiceTaxList.Ref.Date AS Period,
		   |	PurchaseInvoiceTaxList.Ref.Company AS Company,
		   |	PurchaseInvoiceTaxList.Tax AS Tax,
		   |	PurchaseInvoiceTaxList.TaxRate AS TaxRate,
		   |	CASE
		   |		WHEN PurchaseInvoiceTaxList.ManualAmount = 0
		   |			THEN PurchaseInvoiceTaxList.Amount
		   |		ELSE PurchaseInvoiceTaxList.ManualAmount
		   |	END AS TaxAmount,
		   |	PurchaseInvoiceItemList.NetAmount AS TaxableAmount,
		   |	PurchaseInvoiceItemList.Ref.Branch AS Branch,
		   |	PurchaseInvoiceItemList.Ref.TransactionType = value(Enum.PurchaseTransactionTypes.Purchase) AS IsPurchase,
		   |	PurchaseInvoiceItemList.Ref.TransactionType = value(Enum.PurchaseTransactionTypes.ReceiptFromConsignor) AS IsReceiptFromConsignor
		   |INTO Taxes
		   |FROM
		   |	Document.PurchaseInvoice.ItemList AS PurchaseInvoiceItemList
		   |		LEFT JOIN Document.PurchaseInvoice.TaxList AS PurchaseInvoiceTaxList
		   |		ON PurchaseInvoiceItemList.Key = PurchaseInvoiceTaxList.Key
		   |WHERE
		   |	PurchaseInvoiceItemList.Ref = &Ref
		   |	AND PurchaseInvoiceTaxList.Ref = &Ref";
EndFunction

Function ItemListLandedCost()
	Return "SELECT
		   |	ItemList.Ref.Date AS Period,
		   |	ItemList.Ref AS Basis,
		   |	ItemList.Ref.Company AS Company,
		   |	ItemList.Ref.Branch AS Branch,
		   |	ItemList.Ref.Currency AS Currency,
		   |	ItemList.ProfitLossCenter,
		   |	ItemList.ExpenseType,
		   |	ItemList.ItemKey,
		   |	ItemList.AdditionalAnalytic,
		   |	ItemList.NetAmount,
		   |	ItemList.TaxAmount,
		   |	ItemList.IsAdditionalItemCost,
		   |	ItemList.IsService,
		   |	TableRowIDInfo.RowID AS RowID
		   |INTO ItemListLandedCost
		   |FROM
		   |	Document.PurchaseInvoice.ItemList AS ItemList
		   |		LEFT JOIN TableRowIDInfo AS TableRowIDInfo
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
		   |	Document.PurchaseInvoice.SerialLotNumbers AS SerialLotNumbers
		   |		LEFT JOIN Document.PurchaseInvoice.ItemList AS ItemList
		   |		ON SerialLotNumbers.Key = ItemList.Key
		   |		AND ItemList.Ref = &Ref
		   |WHERE
		   |	SerialLotNumbers.Ref = &Ref";
EndFunction

Function IncomingStocksReal()
	Return "SELECT
		   |	ItemList.Period,
		   |	ItemList.Store,
		   |	ItemList.ItemKey,
		   |	ItemList.PurchaseOrder AS Order,
		   |	SUM(ItemList.Quantity) AS Quantity
		   |INTO IncomingStocksReal
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.IsService
		   |	AND NOT ItemList.UseGoodsReceipt
		   |	AND NOT ItemList.GoodsReceiptExists
		   |GROUP BY
		   |	ItemList.ItemKey,
		   |	ItemList.Period,
		   |	ItemList.PurchaseOrder,
		   |	ItemList.Store";
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
		   |	SourceOfOrigins.SerialLotNumber AS SerialLotNumberStock,
		   |	SourceOfOrigins.SourceOfOrigin AS SourceOfOriginStock,
		   |	SUM(SourceOfOrigins.Quantity) AS Quantity
		   |INTO SourceOfOrigins
		   |FROM
		   |	Document.PurchaseInvoice.SourceOfOrigins AS SourceOfOrigins
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
		   |	SourceOfOrigins.SerialLotNumber,
		   |	SourceOfOrigins.SourceOfOrigin";
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
	QueryArray.Add(R1001T_Purchases());
	QueryArray.Add(R1005T_PurchaseSpecialOffers());
	QueryArray.Add(R1011B_PurchaseOrdersReceipt());
	QueryArray.Add(R1012B_PurchaseOrdersInvoiceClosing());
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R1022B_VendorsPaymentPlanning());
	QueryArray.Add(R1031B_ReceiptInvoicing());
	QueryArray.Add(R1040B_TaxesOutgoing());
	QueryArray.Add(R2013T_SalesOrdersProcurement());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4012B_StockReservation());
	QueryArray.Add(R4014B_SerialLotNumber());
	QueryArray.Add(R4017B_InternalSupplyRequestProcurement());
	QueryArray.Add(R4031B_GoodsInTransitIncoming());
	QueryArray.Add(R4033B_GoodsReceiptSchedule());
	QueryArray.Add(R4035B_IncomingStocks());
	QueryArray.Add(R4036B_IncomingStocksRequested());
	QueryArray.Add(R4050B_StockInventory());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5012B_VendorsAging());
	QueryArray.Add(R5022T_Expenses());
	QueryArray.Add(R6070T_OtherPeriodsExpenses());
	//#2093
	//QueryArray.Add(R8012B_ConsignorInventory());
	//#2093
	//QueryArray.Add(R8013B_ConsignorBatchWiseBalance());
	QueryArray.Add(R8015T_ConsignorPrices());
	QueryArray.Add(R9010B_SourceOfOriginStock());
	QueryArray.Add(T1040T_AccountingAmounts());
	QueryArray.Add(T1050T_AccountingQuantities());
	QueryArray.Add(T2015S_TransactionsInfo());
	QueryArray.Add(T3010S_RowIDInfo());
	QueryArray.Add(T6010S_BatchesInfo());
	QueryArray.Add(T6020S_BatchKeysInfo());
	QueryArray.Add(S1001L_VendorsPricesByItemKey());
	Return QueryArray;
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

Function R1001T_Purchases()
	Return "SELECT
		   |	*
		   |INTO R1001T_Purchases
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.IsPurchase";
EndFunction

Function R1005T_PurchaseSpecialOffers()
	Return "SELECT *
		   |INTO R1005T_PurchaseSpecialOffers
		   |FROM
		   |	OffersInfo AS OffersInfo
		   |WHERE TRUE";

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
		   |	NOT ItemList.UseGoodsReceipt
		   |	AND ItemList.PurchaseOrderExists
		   |	AND NOT ItemList.IsService";

EndFunction

Function R1012B_PurchaseOrdersInvoiceClosing()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.PurchaseOrder AS Order,
		   |	*
		   |INTO R1012B_PurchaseOrdersInvoiceClosing
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.PurchaseOrderExists";

EndFunction

Function R1020B_AdvancesToVendors()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	OffsetOfAdvances.Recorder AS VendorsAdvancesClosing,
		   |	OffsetOfAdvances.AdvancesOrder AS Order,
		   |	*
		   |INTO R1020B_AdvancesToVendors
		   |FROM
		   |	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		   |WHERE
		   |	OffsetOfAdvances.Document = &Ref";
EndFunction

Function R1021B_VendorsTransactions()
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
		   |	ItemList.PurchaseOrder AS Order,
		   |	SUM(ItemList.Amount) AS Amount,
		   |	UNDEFINED AS VendorsAdvancesClosing
		   |INTO R1021B_VendorsTransactions
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.IsPurchase
		   |GROUP BY
		   |	ItemList.Agreement,
		   |	ItemList.BasisDocument,
		   |	ItemList.PurchaseOrder,
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
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	OffsetOfAdvances.Period,
		   |	OffsetOfAdvances.Company,
		   |	OffsetOfAdvances.Branch,
		   |	OffsetOfAdvances.Currency,
		   |	OffsetOfAdvances.LegalName,
		   |	OffsetOfAdvances.Partner,
		   |	OffsetOfAdvances.Agreement,
		   |	OffsetOfAdvances.TransactionDocument,
		   |	OffsetOfAdvances.TransactionOrder,
		   |	OffsetOfAdvances.Amount,
		   |	OffsetOfAdvances.Recorder
		   |FROM
		   |	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		   |WHERE
		   |	OffsetOfAdvances.Document = &Ref";
EndFunction

Function R5012B_VendorsAging()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	PaymentTerms.Ref.Date AS Period,
		   |	PaymentTerms.Ref.Company AS Company,
		   |	PaymentTerms.Ref.Branch AS Branch,
		   |	PaymentTerms.Ref.Currency AS Currency,
		   |	PaymentTerms.Ref.Agreement AS Agreement,
		   |	PaymentTerms.Ref.Partner AS Partner,
		   |	PaymentTerms.Ref AS Invoice,
		   |	PaymentTerms.Date AS PaymentDate,
		   |	SUM(PaymentTerms.Amount) AS Amount,
		   |	UNDEFINED AS AgingClosing
		   |INTO R5012B_VendorsAging
		   |FROM
		   |	Document.PurchaseInvoice.PaymentTerms AS PaymentTerms
		   |WHERE
		   |	PaymentTerms.Ref = &Ref
		   |GROUP BY
		   |	PaymentTerms.Date,
		   |	PaymentTerms.Ref,
		   |	PaymentTerms.Ref.Agreement,
		   |	PaymentTerms.Ref.Company,
		   |	PaymentTerms.Ref.Branch,
		   |	PaymentTerms.Ref.Currency,
		   |	PaymentTerms.Ref.Date,
		   |	PaymentTerms.Ref.Partner,
		   |	VALUE(AccumulationRecordType.Receipt)
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense),
		   |	OffsetOfAging.Period,
		   |	OffsetOfAging.Company,
		   |	OffsetOfAging.Branch,
		   |	OffsetOfAging.Currency,
		   |	OffsetOfAging.Agreement,
		   |	OffsetOfAging.Partner,
		   |	OffsetOfAging.Invoice,
		   |	OffsetOfAging.PaymentDate,
		   |	OffsetOfAging.Amount,
		   |	OffsetOfAging.Recorder
		   |FROM
		   |	InformationRegister.T2013S_OffsetOfAging AS OffsetOfAging
		   |WHERE
		   |	OffsetOfAging.Document = &Ref";
EndFunction

Function R1031B_ReceiptInvoicing()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.Invoice AS Basis,
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
		   |	ItemList.UseGoodsReceipt
		   |	AND NOT ItemList.GoodsReceiptExists
		   |	AND NOT ItemList.IsService
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense),
		   |	GoodsReceipts.GoodsReceipt,
		   |	GoodsReceipts.Quantity,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.Period,
		   |	ItemList.ItemKey,
		   |	ItemList.Store
		   |FROM
		   |	ItemList AS ItemList
		   |		INNER JOIN GoodReceiptInfo AS GoodsReceipts
		   |		ON ItemList.Key = GoodsReceipts.Key
		   |WHERE
		   |	TRUE";

EndFunction

Function R1040B_TaxesOutgoing()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R1040B_TaxesOutgoing
		   |FROM
		   |	Taxes AS Taxes
		   |WHERE
		   |	Taxes.IsPurchase";
EndFunction

Function R2013T_SalesOrdersProcurement()
	Return "SELECT
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.SalesOrder AS Order,
		   |	ItemList.ItemKey,
		   |	ItemList.RowKey,
		   |	ItemList.Quantity AS PurchaseQuantity,
		   |	ItemList.NetAmount AS PurchaseNetAmount,
		   |	ItemList.Amount AS PurchaseTotalAmount
		   |INTO R2013T_SalesOrdersProcurement
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.IsService
		   |	AND ItemList.SalesOrderExists";
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
		   |	NOT ItemList.IsService
		   |	AND NOT ItemList.UseGoodsReceipt
		   |	AND NOT ItemList.GoodsReceiptExists
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

Function R4014B_SerialLotNumber()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R4014B_SerialLotNumber
		   |FROM
		   |	SerialLotNumbers AS SerialLotNumbers
		   |WHERE
		   |	TRUE";

EndFunction

Function R4017B_InternalSupplyRequestProcurement()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	*
		   |INTO R4017B_InternalSupplyRequestProcurement
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.IsService
		   |	AND ItemList.InternalSupplyRequestExists
		   |	AND NOT ItemList.UseGoodsReceipt";

EndFunction

Function R4031B_GoodsInTransitIncoming()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	CASE
		   |		WHEN ItemList.GoodsReceiptExists
		   |			Then GoodsReceipts.GoodsReceipt
		   |		Else ItemList.Invoice
		   |	End AS Basis,
		   |	CASE 
		   |		WHEN ItemList.GoodsReceiptExists
		   |			Then GoodsReceipts.Quantity
		   |		Else ItemList.Quantity
		   |	End AS Quantity,
		   |	*
		   |INTO R4031B_GoodsInTransitIncoming
		   |FROM
		   |	ItemList AS ItemList
		   |		LEFT JOIN GoodReceiptInfo AS GoodsReceipts
		   |		ON ItemList.Key = GoodsReceipts.Key
		   |WHERE
		   |	NOT ItemList.IsService
		   |	AND (ItemList.UseGoodsReceipt
		   |		OR ItemList.GoodsReceiptExists)";

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
		   |	NOT ItemList.IsService
		   |	AND NOT ItemList.UseGoodsReceipt
		   |	AND ItemList.PurchaseOrderExists
		   |	AND ItemList.PurchaseOrder.UseItemsReceiptScheduling";

EndFunction

Function R4050B_StockInventory()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
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
		   |	AND ItemList.IsPurchase
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Receipt),
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Store,
		   |	ItemList.ItemKey";
EndFunction

Function R5010B_ReconciliationStatement()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.Company AS Company,
		   |	ItemList.Branch AS Branch,
		   |	ItemList.LegalName AS LegalName,
		   |	ItemList.LegalNameContract AS LegalNameContract,
		   |	ItemList.Currency AS Currency,
		   |	SUM(ItemList.Amount) AS Amount,
		   |	ItemList.Period
		   |INTO R5010B_ReconciliationStatement
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.IsPurchase
		   |GROUP BY
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.LegalName,
		   |	ItemList.LegalNameContract,
		   |	ItemList.Currency,
		   |	ItemList.Period,
		   |	VALUE(AccumulationRecordType.Expense)";
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

Function R1022B_VendorsPaymentPlanning()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	PurchaseInvoicePaymentTerms.Ref.Date AS Period,
		   |	PurchaseInvoicePaymentTerms.Ref.Company AS Company,
		   |	PurchaseInvoicePaymentTerms.Ref.Branch AS Branch,
		   |	PurchaseInvoicePaymentTerms.Ref AS Basis,
		   |	PurchaseInvoicePaymentTerms.Ref.LegalName AS LegalName,
		   |	PurchaseInvoicePaymentTerms.Ref.Partner AS Partner,
		   |	PurchaseInvoicePaymentTerms.Ref.Agreement AS Agreement,
		   |	SUM(PurchaseInvoicePaymentTerms.Amount) AS Amount
		   |INTO R1022B_VendorsPaymentPlanning
		   |FROM
		   |	Document.PurchaseInvoice.PaymentTerms AS PurchaseInvoicePaymentTerms
		   |WHERE
		   |	PurchaseInvoicePaymentTerms.Ref = &Ref
		   |	AND PurchaseInvoicePaymentTerms.CalculationType = VALUE(Enum.CalculationTypes.PostShipmentCredit)
		   |GROUP BY
		   |	PurchaseInvoicePaymentTerms.Ref.Date,
		   |	PurchaseInvoicePaymentTerms.Ref.Company,
		   |	PurchaseInvoicePaymentTerms.Ref.Branch,
		   |	PurchaseInvoicePaymentTerms.Ref,
		   |	PurchaseInvoicePaymentTerms.Ref.LegalName,
		   |	PurchaseInvoicePaymentTerms.Ref.Partner,
		   |	PurchaseInvoicePaymentTerms.Ref.Agreement,
		   |	VALUE(AccumulationRecordType.Receipt)";
EndFunction

Function R5022T_Expenses()
	Return "SELECT
		   |	*,
		   |	ItemList.NetAmount AS Amount,
		   |	ItemList.Amount AS AmountWithTaxes
		   |INTO R5022T_Expenses
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.IsService
		   |	AND NOT ItemList.IsAdditionalItemCost
		   |	AND ItemList.IsPurchase";
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
		   |	Document.PurchaseInvoice.ItemList AS ItemList
		   |		INNER JOIN Document.PurchaseInvoice.RowIDInfo AS RowIDInfo
		   |		ON RowIDInfo.Ref = &Ref
		   |		AND ItemList.Ref = &Ref
		   |		AND RowIDInfo.Key = ItemList.Key
		   |		AND RowIDInfo.Ref = ItemList.Ref";
EndFunction

Function T2015S_TransactionsInfo()
	Return "SELECT
		   |	ItemList.Period AS Date,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.Currency,
		   |	ItemList.Partner,
		   |	ItemList.LegalName,
		   |	ItemList.Agreement,
		   |	ItemList.PurchaseOrder AS Order,
		   |	TRUE AS IsVendorTransaction,
		   |	ItemList.BasisDocument AS TransactionBasis,
		   |	SUM(ItemList.Amount) AS Amount,
		   |	TRUE AS IsDue
		   |INTO T2015S_TransactionsInfo
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.IsPurchase
		   |GROUP BY
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.Currency,
		   |	ItemList.Partner,
		   |	ItemList.LegalName,
		   |	ItemList.Agreement,
		   |	ItemList.PurchaseOrder,
		   |	ItemList.BasisDocument";
EndFunction

Function R6070T_OtherPeriodsExpenses()
	Return "SELECT
		   |	*,
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.NetAmount AS Amount,
		   |	ItemList.TaxAmount AS AmountTax
		   |INTO R6070T_OtherPeriodsExpenses
		   |FROM
		   |	ItemListLandedCost AS ItemList
		   |WHERE
		   |	ItemList.IsAdditionalItemCost";
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
		   |	*,
		   |	BatchKeysInfo.Amount AS InvoiceAmount, 
		   |	BatchKeysInfo.AmountTax AS InvoiceTaxAmount
		   |INTO T6020S_BatchKeysInfo
		   |FROM
		   |	BatchKeysInfo
		   |WHERE
		   |	TRUE";
EndFunction

//#2093
//Function R8012B_ConsignorInventory()
//	Return "SELECT
//		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
//		   |	ItemList.Period,
//		   |	ItemList.Company,
//		   |	ItemList.ItemKey,
//		   |	ItemList.Partner,
//		   |	ItemList.Agreement,
//		   |	ItemList.LegalName,
//		   |	SUM(case
//		   |		when SerialLotNumbers.SerialLotNumber.Ref IS NULL
//		   |			Then ItemList.Quantity
//		   |		else SerialLotNumbers.Quantity
//		   |	end) AS Quantity,
//		   |	SerialLotNumbers.SerialLotNumber
//		   |INTO R8012B_ConsignorInventory
//		   |FROM
//		   |	ItemList AS ItemList
//		   |		LEFT JOIN SerialLotNumbers AS SerialLotNumbers
//		   |		ON ItemList.Key = SerialLotNumbers.Key
//		   |WHERE
//		   |	NOT ItemList.IsService
//		   |	AND ItemList.IsReceiptFromConsignor
//		   |GROUP BY
//		   |	VALUE(AccumulationRecordType.Receipt),
//		   |	ItemList.Period,
//		   |	ItemList.Company,
//		   |	ItemList.ItemKey,
//		   |	ItemList.Partner,
//		   |	ItemList.Agreement,
//		   |	ItemList.LegalName,
//		   |	SerialLotNumbers.SerialLotNumber";
//EndFunction

//#2093
//Function R8013B_ConsignorBatchWiseBalance()
//	Return "SELECT
//		   |	ItemList.Key,
//		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
//		   |	ItemList.Period,
//		   |	ItemList.Company,
//		   |	ItemList.Invoice AS Batch,
//		   |	ItemList.Store,
//		   |	ItemList.ItemKey,
//		   |	case
//		   |		when SerialLotNumbers.SerialLotNumber.Ref IS NULL
//		   |			Then ItemList.Quantity
//		   |		ELSE SerialLotNumbers.Quantity
//		   |	end AS Quantity,
//		   |	ISNULL(SerialLotNumbers.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber
//		   |INTO ConsignorBatchWiseBalance_1
//		   |FROM
//		   |	ItemList AS ItemList
//		   |		LEFT JOIN SerialLotNumbers AS SerialLotNumbers
//		   |		ON SerialLotNumbers.Key = ItemList.Key
//		   |WHERE
//		   |	NOT ItemList.IsService
//		   |	AND ItemList.IsReceiptFromConsignor
//		   |;
//		   |
//		   |////////////////////////////////////////////////////////////////////////////////
//		   |SELECT
//		   |	ConsignorBatchWiseBalance_1.RecordType,
//		   |	ConsignorBatchWiseBalance_1.Period,
//		   |	ConsignorBatchWiseBalance_1.Company,
//		   |	ConsignorBatchWiseBalance_1.Batch,
//		   |	ConsignorBatchWiseBalance_1.Store,
//		   |	ConsignorBatchWiseBalance_1.ItemKey,
//		   |	SUM(CASE
//		   |		WHEN ISNULL(SourceOfOrigins.Quantity, 0) <> 0
//		   |			THEN ISNULL(SourceOfOrigins.Quantity, 0)
//		   |		ELSE ConsignorBatchWiseBalance_1.Quantity
//		   |	END) AS Quantity,
//		   |	SourceOfOrigins.SourceOfOriginStock AS SourceOfOrigin,
//		   |	SourceOfOrigins.SerialLotNumberStock AS SerialLotNumber
//		   |INTO R8013B_ConsignorBatchWiseBalance
//		   |FROM
//		   |	ConsignorBatchWiseBalance_1 AS ConsignorBatchWiseBalance_1
//		   |		LEFT JOIN SourceOfOrigins AS SourceOfOrigins
//		   |		ON ConsignorBatchWiseBalance_1.Key = SourceOfOrigins.Key
//		   |		AND ConsignorBatchWiseBalance_1.SerialLotNumber = SourceOfOrigins.SerialLotNumberStock
//		   |GROUP BY
//		   |	ConsignorBatchWiseBalance_1.RecordType,
//		   |	ConsignorBatchWiseBalance_1.Period,
//		   |	ConsignorBatchWiseBalance_1.Company,
//		   |	ConsignorBatchWiseBalance_1.Batch,
//		   |	ConsignorBatchWiseBalance_1.Store,
//		   |	ConsignorBatchWiseBalance_1.ItemKey,
//		   |	SourceOfOrigins.SourceOfOriginStock,
//		   |	SourceOfOrigins.SerialLotNumberStock";
//EndFunction

Function R8015T_ConsignorPrices()
	Return "SELECT
		   |	ItemList.Key,
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Partner,
		   |	ItemList.Agreement,
		   |	ItemList.Invoice AS PurchaseInvoice,
		   |	ItemList.ItemKey,
		   |	ItemList.Currency,
		   |	ItemList.Price,
		   |	ISNULL(SerialLotNumbers.SerialLotNumber, Value(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber
		   |INTO ConsignorPrices_1
		   |FROM
		   |	ItemList AS ItemList
		   |		LEFT JOIN SerialLotNumbers AS SerialLotNumbers
		   |		ON SerialLotNumbers.Key = ItemList.Key
		   |WHERE
		   |	ItemList.IsReceiptFromConsignor
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	ConsignorPrices_1.Period,
		   |	ConsignorPrices_1.Company,
		   |	ConsignorPrices_1.Partner,
		   |	ConsignorPrices_1.Agreement,
		   |	ConsignorPrices_1.PurchaseInvoice,
		   |	ConsignorPrices_1.ItemKey,
		   |	ConsignorPrices_1.Currency,
		   |	AVG(ConsignorPrices_1.Price) AS Price,
		   |	SourceOfOrigins.SourceOfOriginStock AS SourceOfOrigin,
		   |	SourceOfOrigins.SerialLotNumberStock AS SerialLotNumber
		   |INTO R8015T_ConsignorPrices
		   |FROM
		   |	ConsignorPrices_1 AS ConsignorPrices_1
		   |		LEFT JOIN SourceOfOrigins AS SourceOfOrigins
		   |		ON ConsignorPrices_1.Key = SourceOfOrigins.Key
		   |		AND ConsignorPrices_1.SerialLotNumber = SourceOfOrigins.SerialLotNumberStock
		   |GROUP BY
		   |	ConsignorPrices_1.Period,
		   |	ConsignorPrices_1.Company,
		   |	ConsignorPrices_1.Partner,
		   |	ConsignorPrices_1.Agreement,
		   |	ConsignorPrices_1.PurchaseInvoice,
		   |	ConsignorPrices_1.ItemKey,
		   |	ConsignorPrices_1.Currency,
		   |	SourceOfOrigins.SourceOfOriginStock,
		   |	SourceOfOrigins.SerialLotNumberStock";
EndFunction

Function S1001L_VendorsPricesByItemKey()
	Return "SELECT
	|	PurchaseInvoiceItemList.Period,
	|	PurchaseInvoiceItemList.PriceType,
	|	PurchaseInvoiceItemList.Unit,
	|	PurchaseInvoiceItemList.ItemKey,
	|	PurchaseInvoiceItemList.Currency,
	|	PurchaseInvoiceItemList.Partner,
	|	SUM(PurchaseInvoiceItemList.Price * PurchaseInvoiceItemList.Quantity) AS SumPrice,
	|	SUM(PurchaseInvoiceItemList.Quantity) AS SumQuantity,
	|	SUM(PurchaseInvoiceItemList.Amount) AS Amount,
	|	SUM(PurchaseInvoiceItemList.NetAmount) AS NetAmount
	|INTO VTRecordPurchasePrices
	|FROM
	|	ItemList AS PurchaseInvoiceItemList
	|WHERE
	|	PurchaseInvoiceItemList.RecordPurchasePrices
	|GROUP BY
	|	PurchaseInvoiceItemList.Period,
	|	PurchaseInvoiceItemList.Currency,
	|	PurchaseInvoiceItemList.Partner,
	|	PurchaseInvoiceItemList.ItemKey,
	|	PurchaseInvoiceItemList.Unit,
	|	PurchaseInvoiceItemList.PriceType
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	VT.Period,
	|	VT.PriceType,
	|	VT.Partner,
	|	VT.ItemKey,
	|	VT.Unit,
	|	VT.Currency,
	|	VT.SumPrice / VT.SumQuantity AS Price,
	|	VT.Amount / VT.SumQuantity AS TotalPrice,
	|	VT.NetAmount / VT.SumQuantity AS NetPrice
	|INTO S1001L_VendorsPricesByItemKey
	|FROM
	|	VTRecordPurchasePrices AS VT
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|DROP VTRecordPurchasePrices";
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
	Return "SELECT
		   |	ItemList.Period,
		   |	ItemList.Key AS RowKey,
		   |	ItemList.Currency,
		   |	ItemList.NetAmount AS Amount,
		   |	VALUE(Catalog.AccountingOperations.PurchaseInvoice_DR_R4050B_R5022T_CR_R1021B) AS Operation,
		   |	UNDEFINED AS AdvancesClosing
		   |INTO T1040T_AccountingAmounts
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.IsPurchase
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	ItemList.Period,
		   |	ItemList.Key AS RowKey,
		   |	ItemList.Currency,
		   |	ItemList.TaxAmount,
		   |	VALUE(Catalog.AccountingOperations.PurchaseInvoice_DR_R1040B_CR_R1021B),
		   |	UNDEFINED
		   |FROM
		   |	ItemList as ItemList
		   |WHERE
		   |	ItemList.IsPurchase
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	T2010S_OffsetOfAdvances.Period,
		   |	T2010S_OffsetOfAdvances.Key AS RowKey,
		   |	T2010S_OffsetOfAdvances.Currency,
		   |	T2010S_OffsetOfAdvances.Amount,
		   |	VALUE(Catalog.AccountingOperations.PurchaseInvoice_DR_R1040B_CR_R1021B),
		   |	T2010S_OffsetOfAdvances.Recorder
		   |FROM
		   |	InformationRegister.T2010S_OffsetOfAdvances AS T2010S_OffsetOfAdvances
		   |WHERE
		   |	T2010S_OffsetOfAdvances.Document = &Ref";
EndFunction

Function T1050T_AccountingQuantities()
	Return "SELECT
		   |	ItemList.Period,
		   |	ItemList.Key AS RowKey,
		   |	VALUE(Catalog.AccountingOperations.PurchaseInvoice_DR_R4050B_R5022T_CR_R1021B) AS Operation,
		   |	ItemList.Quantity
		   |INTO T1050T_AccountingQuantities
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.IsPurchase";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	Operations = Catalogs.AccountingOperations;
	If Parameters.Operation = Operations.PurchaseInvoice_DR_R4050B_R5022T_CR_R1021B Then
		Return GetAnalytics_DR_R4050B_CR_R1021B(Parameters); // Stock inventory - Vendors transactions
	ElsIf Parameters.Operation = Operations.PurchaseInvoice_DR_R1021B_CR_R1020B Then
		Return GetAnalytics_DR_R1021B_CR_R1020B(Parameters); // Vendors transactions - Advances to vendors
	ElsIf Parameters.Operation = Operations.PurchaseInvoice_DR_R1040B_CR_R1021B Then
		Return GetAnalytics_DR_R1040B_CR_R1021B(Parameters); // Taxes outgoing - Vendors transactions
	EndIf;
	Return Undefined;
EndFunction

#Region Accounting_Analytics

// Stock inventory - Vendors transactions
Function GetAnalytics_DR_R4050B_CR_R1021B(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9010S_AccountsItemKey(AccountParameters, Parameters.RowData.ItemKey);
	If ValueIsFilled(Debit.Account) Then
		AccountingAnalytics.Debit = Debit.Account;
	EndIf;
	AdditionalAnalytics = New Structure;
	AdditionalAnalytics.Insert("Item", Parameters.RowData.ItemKey.Item);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, Parameters.ObjectData.Partner,
		Parameters.ObjectData.Agreement);
	If ValueIsFilled(Credit.AccountTransactionsVendor) Then
		AccountingAnalytics.Credit = Credit.AccountTransactionsVendor;
	EndIf;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Vendors transactions - Advances to vendors
Function GetAnalytics_DR_R1021B_CR_R1020B(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Accounts = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, Parameters.ObjectData.Partner,
		Parameters.ObjectData.Agreement);
	If ValueIsFilled(Accounts.AccountTransactionsVendor) Then
		AccountingAnalytics.Debit = Accounts.AccountTransactionsVendor;
	EndIf;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);
	
	// Credit
	If ValueIsFilled(Accounts.AccountAdvancesVendor) Then
		AccountingAnalytics.Credit = Accounts.AccountAdvancesVendor;
	EndIf;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Taxes outgoing - Vendors transactions
Function GetAnalytics_DR_R1040B_CR_R1021B(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
		
	// Debit
	Debit = AccountingServer.GetT9013S_AccountsTax(AccountParameters, Parameters.RowData.TaxInfo.Tax);
	If ValueIsFilled(Debit.Account) Then
		AccountingAnalytics.Debit = Debit.Account;
	EndIf;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, Parameters.RowData.TaxInfo);
	
	// Credit
	Credit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, Parameters.ObjectData.Partner,
		Parameters.ObjectData.Agreement);
	If ValueIsFilled(Credit.AccountTransactionsVendor) Then
		AccountingAnalytics.Credit = Credit.AccountTransactionsVendor;
	EndIf;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value) Export
	If Parameters.Operation = Catalogs.AccountingOperations.PurchaseInvoice_DR_R1021B_CR_R1020B
		And ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.Companies")) <> Undefined Then
		Return Parameters.ObjectData.LegalName;
	EndIf;
	Return Value;
EndFunction

Function GetHintCreditExtDimension(Parameters, ExtDimensionType, Value) Export
	If (Parameters.Operation = Catalogs.AccountingOperations.PurchaseInvoice_DR_R1021B_CR_R1020B
		Or Parameters.Operation = Catalogs.AccountingOperations.PurchaseInvoice_DR_R1040B_CR_R1021B
		Or Parameters.Operation = Catalogs.AccountingOperations.PurchaseInvoice_DR_R4050B_R5022T_CR_R1021B)
		And ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.Companies")) <> Undefined Then
		Return Parameters.ObjectData.LegalName;
	EndIf;
	Return Value;
EndFunction

#EndRegion

#EndRegion