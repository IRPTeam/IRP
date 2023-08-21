#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);

	//#2093
//	Query = New Query;
//	Query.Text =
//	"SELECT
//	|	ItemList.Key AS Key,
//	|	ItemList.Ref.Company AS Company,
//	|	ItemList.Ref.Partner AS Partner,
//	|	ItemList.Ref.Agreement AS Agreement,
//	|	ItemList.PurchaseInvoice AS Batch,
//	|	ItemList.Store AS Store,
//	|	ItemList.ItemKey AS ItemKey,
//	|	ItemList.Quantity AS Quantity
//	|INTO tmpItemList
//	|FROM
//	|	Document.PurchaseReturn.ItemList AS ItemLIst
//	|WHERE
//	|	ItemList.Ref = &Ref
//	|	AND ItemLIst.Ref.TransactionType = VALUE(Enum.PurchaseReturnTransactionTypes.ReturnToConsignor)
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|SELECT
//	|	SerialLotNumbers.Key,
//	|	SerialLotNumbers.SerialLotNumber,
//	|	SerialLotNumbers.Quantity
//	|INTO tmpSerialLotNumbers
//	|FROM
//	|	Document.PurchaseReturn.SerialLotNumbers AS SerialLotNumbers
//	|WHERE
//	|	SerialLotNumbers.Ref = &Ref
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|SELECT
//	|	SourceOfOrigins.Key,
//	|	SourceOfOrigins.SerialLotNumber,
//	|	SourceOfOrigins.SourceOfOrigin,
//	|	SourceOfOrigins.Quantity
//	|INTO tmpSourceOfOrigins
//	|FROM
//	|	Document.PurchaseReturn.SourceOfOrigins AS SourceOfOrigins
//	|WHERE
//	|	SourceOfOrigins.Ref = &Ref
//	|;
//	|////////////////////////////////////////////////////////////////////////////////
//	|SELECT
//	|	tmpItemList.Key,
//	|	tmpItemList.Company,
//	|	tmpItemList.Partner,
//	|	tmpItemList.Agreement,
//	|	tmpItemList.Batch,
//	|	tmpItemList.Store,
//	|	tmpItemList.ItemKey,
//	|	CASE
//	|		WHEN tmpSerialLotNumbers.SerialLotNumber.Ref IS NULL
//	|			THEN tmpItemList.Quantity
//	|		ELSE tmpSerialLotNumbers.Quantity
//	|	END AS Quantity,
//	|	ISNULL(tmpSerialLotNumbers.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber
//	|INTO tmpItemList_1
//	|FROM
//	|	tmpItemList AS tmpItemList
//	|		LEFT JOIN tmpSerialLotNumbers AS tmpSerialLotNumbers
//	|		ON tmpItemList.Key = tmpSerialLotNumbers.Key
//	|;
//	|////////////////////////////////////////////////////////////////////////////////
//	|SELECT
//	|	tmpItemList_1.Key,
//	|	tmpItemList_1.Company,
//	|	tmpItemList_1.Partner,
//	|	tmpItemList_1.Agreement,
//	|	tmpItemList_1.Batch,
//	|	tmpItemList_1.Store,
//	|	tmpItemList_1.ItemKey,
//	|	tmpItemList_1.SerialLotNumber,
//	|	CASE
//	|		WHEN ISNULL(tmpSourceOfOrigins.Quantity, 0) <> 0
//	|			THEN ISNULL(tmpSourceOfOrigins.Quantity, 0)
//	|		ELSE tmpItemList_1.Quantity
//	|	END AS Quantity,
//	|	ISNULL(tmpSourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)) AS SourceOfOrigin
//	|FROM
//	|	tmpItemList_1 AS tmpItemList_1
//	|		LEFT JOIN tmpSourceOfOrigins AS tmpSourceOfOrigins
//	|		ON tmpItemList_1.Key = tmpSourceOfOrigins.Key
//	|		AND tmpItemList_1.SerialLotNumber = tmpSourceOfOrigins.SerialLotNumber";
//
//	Query.SetParameter("Ref", Ref);
//	ItemListTable = Query.Execute().Unload();
//	ConsignorBatches = CommissionTradeServer.GetTableConsignorBatchWiseBalanceForPurchaseReturn(Parameters.Object,
//		ItemListTable);
//
//	Query.TempTablesManager = Parameters.TempTablesManager;
//	Query.Text = "SELECT * INTO ConsignorBatches FROM &T1 AS T1";
//	Query.SetParameter("T1", ConsignorBatches);
//	Query.Execute();

	BatchKeysInfoMetadata = Parameters.Object.RegisterRecords.T6020S_BatchKeysInfo.Metadata();
	If Parameters.Property("MultiCurrencyExcludePostingDataTables") Then
		Parameters.MultiCurrencyExcludePostingDataTables.Add(BatchKeysInfoMetadata);
	Else
		ArrayOfMultiCurrencyExcludePostingDataTables = New Array;
		ArrayOfMultiCurrencyExcludePostingDataTables.Add(BatchKeysInfoMetadata);
		Parameters.Insert("MultiCurrencyExcludePostingDataTables", ArrayOfMultiCurrencyExcludePostingDataTables);
	EndIf;

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
		"Document.PurchaseReturn.ItemList");

	CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo);

	If Not Cancel And Not AccReg.R4014B_SerialLotNumber.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R4014B_SerialLotNumber", Parameters), PostingServer.GetQueryTableByName(
		"Exists_R4014B_SerialLotNumber", Parameters), AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("RecordType", AccumulationRecordType.Expense);
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.PurchaseReturn.ItemList", AddInfo);
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
	QueryArray.Add(OffersInfo());
	QueryArray.Add(ShipmentConfirmationsInfo());
	QueryArray.Add(Taxes());
	QueryArray.Add(SourceOfOrigins());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
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
		   |	Document.PurchaseReturn.RowIDInfo AS RowIDInfo
		   |WHERE
		   |	RowIDInfo.Ref = &Ref
		   |GROUP BY
		   |	RowIDInfo.Ref,
		   |	RowIDInfo.Key
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	ShipmentConfirmations.Key,
		   |	ShipmentConfirmations.ShipmentConfirmation
		   |INTO ShipmentConfirmations
		   |FROM
		   |	Document.PurchaseReturn.ShipmentConfirmations AS ShipmentConfirmations
		   |WHERE
		   |	ShipmentConfirmations.Ref = &Ref
		   |GROUP BY
		   |	ShipmentConfirmations.Key,
		   |	ShipmentConfirmations.ShipmentConfirmation
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	PurchaseReturnItemList.Ref.Company AS Company,
		   |	PurchaseReturnItemList.Store AS Store,
		   |	PurchaseReturnItemList.UseShipmentConfirmation AS UseShipmentConfirmation,
		   |	NOT ShipmentConfirmations.Key IS NULL AS ShipmentConfirmationExists,
		   |	ShipmentConfirmations.ShipmentConfirmation,
		   |	PurchaseReturnItemList.ItemKey AS ItemKey,
		   |	PurchaseReturnItemList.PurchaseReturnOrder AS PurchaseReturnOrder,
		   |	NOT PurchaseReturnItemList.PurchaseReturnOrder.Ref IS NULL AS PurchaseReturnOrderExists,
		   |	PurchaseReturnItemList.Ref AS PurchaseReturn,
		   |	CASE
		   |		WHEN PurchaseReturnItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		   |			THEN PurchaseReturnItemList.Ref
		   |		ELSE UNDEFINED
		   |	END AS BasisDocument,
		   |	PurchaseReturnItemList.Ref AS AdvanceBasis,
		   |	PurchaseReturnItemList.QuantityInBaseUnit AS Quantity,
		   |	PurchaseReturnItemList.TotalAmount AS TotalAmount,
		   |	PurchaseReturnItemList.TotalAmount AS Amount,
		   |	PurchaseReturnItemList.Ref.Partner AS Partner,
		   |	PurchaseReturnItemList.Ref.LegalName AS LegalName,
		   |	CASE
		   |		WHEN PurchaseReturnItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		   |		AND PurchaseReturnItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		   |			THEN PurchaseReturnItemList.Ref.Agreement.StandardAgreement
		   |		ELSE PurchaseReturnItemList.Ref.Agreement
		   |	END AS Agreement,
		   |	ISNULL(PurchaseReturnItemList.Ref.Currency, VALUE(Catalog.Currencies.EmptyRef)) AS Currency,
		   |	PurchaseReturnItemList.Ref.Date AS Period,
		   |	CASE
		   |		WHEN PurchaseReturnItemList.PurchaseInvoice.Ref IS NULL
		   |		OR VALUETYPE(PurchaseReturnItemList.PurchaseInvoice) <> TYPE(Document.PurchaseInvoice)
		   |			THEN PurchaseReturnItemList.Ref
		   |		ELSE PurchaseReturnItemList.PurchaseInvoice
		   |	END AS PurchaseInvoice,
		   |	PurchaseReturnItemList.PurchaseInvoice AS BatchDocument,
		   |	TableRowIDInfo.RowID AS RowKey,
		   |	PurchaseReturnItemList.Key,
		   |	PurchaseReturnItemList.IsService AS IsService,
		   |	PurchaseReturnItemList.NetAmount,
		   |	PurchaseReturnItemList.PurchaseInvoice AS Invoice,
		   |	PurchaseReturnItemList.ReturnReason,
		   |	PurchaseReturnItemList.ProfitLossCenter AS ProfitLossCenter,
		   |	PurchaseReturnItemList.ExpenseType AS ExpenseType,
		   |	PurchaseReturnItemList.AdditionalAnalytic AS AdditionalAnalytic,
		   |	PurchaseReturnItemList.Ref.Branch AS Branch,
		   |	PurchaseReturnItemList.Ref.LegalNameContract AS LegalNameContract,
		   |	PurchaseReturnItemList.OffersAmount,
		   |	PurchaseReturnItemList.Detail AS Detail,
		   |	PurchaseReturnItemList.Ref.TransactionType = VALUE(Enum.PurchaseReturnTransactionTypes.ReturnToVendor) AS IsReturnToVendor,
		   |	PurchaseReturnItemList.Ref.TransactionType = VALUE(Enum.PurchaseReturnTransactionTypes.ReturnToConsignor) AS IsReturnToConsignor
		   |INTO ItemList
		   |FROM
		   |	Document.PurchaseReturn.ItemList AS PurchaseReturnItemList
		   |		LEFT JOIN ShipmentConfirmations AS ShipmentConfirmations
		   |		ON PurchaseReturnItemList.Key = ShipmentConfirmations.Key
		   |		LEFT JOIN TableRowIDInfo AS TableRowIDInfo
		   |		ON PurchaseReturnItemList.Key = TableRowIDInfo.Key
		   |WHERE
		   |	PurchaseReturnItemList.Ref = &Ref";
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
		   |	Document.PurchaseReturn.SerialLotNumbers AS SerialLotNumbers
		   |		LEFT JOIN Document.PurchaseReturn.ItemList AS ItemList
		   |		ON SerialLotNumbers.Key = ItemList.Key
		   |		AND ItemList.Ref = &Ref
		   |WHERE
		   |	SerialLotNumbers.Ref = &Ref";
EndFunction

Function OffersInfo()
	Return "SELECT
		   |	PurchaseReturnItemList.Ref.Date AS Period,
		   |	PurchaseReturnItemList.Ref AS Invoice,
		   |	PurchaseReturnItemList.Key AS RowKey,
		   |	PurchaseReturnItemList.ItemKey,
		   |	PurchaseReturnItemList.Ref.Company AS Company,
		   |	PurchaseReturnItemList.Ref.Currency AS Currency,
		   |	PurchaseReturnSpecialOffers.Offer AS SpecialOffer,
		   |	PurchaseReturnSpecialOffers.Amount AS OffersAmount,
		   |	PurchaseReturnSpecialOffers.Bonus AS OffersBonus,
		   |	PurchaseReturnSpecialOffers.AddInfo AS OffersAddInfo,
		   |	PurchaseReturnItemList.TotalAmount AS SalesAmount,
		   |	PurchaseReturnItemList.NetAmount AS NetAmount,
		   |	PurchaseReturnItemList.Ref.Branch AS Branch
		   |INTO OffersInfo
		   |FROM
		   |	Document.PurchaseReturn.ItemList AS PurchaseReturnItemList
		   |		INNER JOIN Document.PurchaseReturn.SpecialOffers AS PurchaseReturnSpecialOffers
		   |		ON PurchaseReturnItemList.Key = PurchaseReturnSpecialOffers.Key
		   |		AND PurchaseReturnItemList.Ref = &Ref
		   |		AND PurchaseReturnSpecialOffers.Ref = &Ref";
EndFunction

Function ShipmentConfirmationsInfo()
	Return "SELECT
		   |	PurchaseReturnShipmentConfirmations.Key,
		   |	PurchaseReturnShipmentConfirmations.ShipmentConfirmation,
		   |	PurchaseReturnShipmentConfirmations.Quantity,
		   |	PurchaseReturnShipmentConfirmations.QuantityInShipmentConfirmation
		   |INTO ShipmentConfirmationsInfo
		   |FROM
		   |	Document.PurchaseReturn.ShipmentConfirmations AS PurchaseReturnShipmentConfirmations
		   |WHERE
		   |	PurchaseReturnShipmentConfirmations.Ref = &Ref";
EndFunction

Function Taxes()
	Return "SELECT
		   |	TaxList.Ref.Date AS Period,
		   |	TaxList.Ref.Company AS Company,
		   |	TaxList.Tax AS Tax,
		   |	TaxList.TaxRate AS TaxRate,
		   |	CASE
		   |		WHEN TaxList.ManualAmount = 0
		   |			THEN TaxList.Amount
		   |		ELSE TaxList.ManualAmount
		   |	END AS TaxAmount,
		   |	ItemList.NetAmount AS TaxableAmount,
		   |	ItemList.Ref.Branch AS Branch,
		   |	TaxList.Ref.TransactionType = VALUE(Enum.PurchaseReturnTransactionTypes.ReturnToVendor) AS IsReturnToVendor,
		   |	TaxList.Ref.TransactionType = VALUE(Enum.PurchaseReturnTransactionTypes.ReturnToConsignor) AS IsReturnToConsignor
		   |INTO Taxes
		   |FROM
		   |	Document.PurchaseReturn.ItemList AS ItemList
		   |		INNER JOIN Document.PurchaseReturn.TaxList AS TaxList
		   |		ON ItemList.Key = TaxList.Key
		   |		AND ItemList.Ref = &Ref
		   |		AND TaxList.Ref = &Ref";
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
		   |	Document.PurchaseReturn.SourceOfOrigins AS SourceOfOrigins
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

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R1001T_Purchases());
	QueryArray.Add(R1002T_PurchaseReturns());
	QueryArray.Add(R1005T_PurchaseSpecialOffers());
	QueryArray.Add(R1012B_PurchaseOrdersInvoiceClosing());
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R1031B_ReceiptInvoicing());
	QueryArray.Add(R1040B_TaxesOutgoing());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4014B_SerialLotNumber());
	QueryArray.Add(R4032B_GoodsInTransitOutgoing());
	QueryArray.Add(R4050B_StockInventory());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5012B_VendorsAging());
	QueryArray.Add(R5022T_Expenses());
	QueryArray.Add(R8012B_ConsignorInventory());
	QueryArray.Add(R8013B_ConsignorBatchWiseBalance());
	QueryArray.Add(R9010B_SourceOfOriginStock());
	QueryArray.Add(T2015S_TransactionsInfo());
	QueryArray.Add(T3010S_RowIDInfo());
	QueryArray.Add(T6020S_BatchKeysInfo());
	Return QueryArray;
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
		   |	ItemList.IsReturnToVendor
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

Function R1001T_Purchases()
	Return "SELECT
		   |	-ItemList.Quantity AS Quantity,
		   |	-ItemList.Amount AS Amount,
		   |	-ItemList.NetAmount AS NetAmount,
		   |	-ItemList.OffersAmount AS OffersAmount,
		   |	ItemList.PurchaseInvoice AS Invoice,
		   |	*
		   |INTO R1001T_Purchases
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.IsReturnToVendor";
EndFunction

Function R1002T_PurchaseReturns()
	Return "SELECT
		   |	ItemList.PurchaseInvoice AS Invoice,
		   |	*
		   |INTO R1002T_PurchaseReturns
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.IsReturnToVendor";
EndFunction

Function R1005T_PurchaseSpecialOffers()
	Return "SELECT *
		   |INTO R1005T_PurchaseSpecialOffers
		   |FROM
		   |	OffersInfo AS OffersInfo
		   |WHERE TRUE";

EndFunction

Function R1012B_PurchaseOrdersInvoiceClosing()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.PurchaseReturnOrder AS Order,
		   |	*
		   |INTO R1012B_PurchaseOrdersInvoiceClosing
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.PurchaseReturnOrderExists";

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
		   |	UNDEFINED AS Key,
		   |	UNDEFINED AS VendorsAdvancesClosing,
		   |	-SUM(ItemList.Amount) AS Amount
		   |INTO R1021B_VendorsTransactions
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.IsReturnToVendor
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

Function R1020B_AdvancesToVendors()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	OffsetOfAdvances.Period,
		   |	OffsetOfAdvances.Company,
		   |	OffsetOfAdvances.Branch,
		   |	OffsetOfAdvances.Partner,
		   |	OffsetOfAdvances.LegalName,
		   |	OffsetOfAdvances.Currency,
		   |	OffsetOfAdvances.Amount,
		   |	UNDEFINED AS Key,
		   |	OffsetOfAdvances.Recorder AS VendorsAdvancesClosing
		   |INTO R1020B_AdvancesToVendors
		   |FROM
		   |	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		   |WHERE
		   |	OffsetOfAdvances.Document = &Ref";
EndFunction

Function R5012B_VendorsAging()
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
		   |INTO R5012B_VendorsAging
		   |FROM
		   |	InformationRegister.T2013S_OffsetOfAging AS OffsetOfAging
		   |WHERE
		   |	OffsetOfAging.Document = &Ref";
EndFunction

Function R1031B_ReceiptInvoicing()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.PurchaseReturn AS Basis,
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
		   |	ItemList.UseShipmentConfirmation
		   |	AND NOT ItemList.ShipmentConfirmationExists
		   |	AND NOT ItemList.IsService
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
		   |		ON ItemList.RowKey = ShipmentConfirmations.Key
		   |WHERE
		   |	TRUE";

EndFunction

Function R1040B_TaxesOutgoing()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	-Taxes.TaxableAmount,
		   |	-Taxes.TaxAmount,
		   |	*
		   |INTO R1040B_TaxesOutgoing
		   |FROM
		   |	Taxes AS Taxes
		   |WHERE
		   |	Taxes.IsReturnToVendor";
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
		   |	END";
EndFunction

Function R4011B_FreeStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.Period AS Period,
		   |	ItemList.Store AS Store,
		   |	ItemList.ItemKey AS ItemKey,
		   |	ItemList.Quantity AS Quantity
		   |INTO R4011B_FreeStocks
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.IsService
		   |	AND NOT ItemList.UseShipmentConfirmation
		   |	AND NOT ItemList.ShipmentConfirmationExists";

EndFunction

Function R4014B_SerialLotNumber()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	*
		   |INTO R4014B_SerialLotNumber
		   |FROM
		   |	SerialLotNumbers AS QueryTable
		   |WHERE 
		   |	TRUE";

EndFunction

Function R4032B_GoodsInTransitOutgoing()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	CASE
		   |		WHEN ItemList.ShipmentConfirmationExists
		   |			Then ItemList.ShipmentConfirmation
		   |		Else ItemList.PurchaseReturn
		   |	End AS Basis,
		   |	*
		   |INTO R4032B_GoodsInTransitOutgoing
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.IsService
		   |	AND (ItemList.UseShipmentConfirmation
		   |		OR ItemList.ShipmentConfirmationExists)";

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
		   |	AND ItemList.IsReturnToVendor
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Expense),
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
		   |	-SUM(ItemList.Amount) AS Amount,
		   |	ItemList.Period
		   |INTO R5010B_ReconciliationStatement
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.IsReturnToVendor
		   |GROUP BY
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.LegalName,
		   |	ItemList.LegalNameContract,
		   |	ItemList.Currency,
		   |	ItemList.Period,
		   |	VALUE(AccumulationRecordType.Expense)";
EndFunction

Function R5022T_Expenses()
	Return "SELECT
		   |	*,
		   |	-ItemList.NetAmount AS Amount,
		   |	-ItemList.TotalAmount AS AmountWithTaxes
		   |INTO R5022T_Expenses
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.IsService
		   |	AND ItemList.IsReturnToVendor";
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
		   |	Document.PurchaseReturn.ItemList AS ItemList
		   |		INNER JOIN Document.PurchaseReturn.RowIDInfo AS RowIDInfo
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
		   |	TRUE AS IsVendorTransaction,
		   |	ItemList.BasisDocument AS TransactionBasis,
		   |	-SUM(ItemList.Amount) AS Amount,
		   |	TRUE AS IsDue
		   |INTO T2015S_TransactionsInfo
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.IsReturnToVendor
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

Function T6020S_BatchKeysInfo()
	Return "SELECT
		   |	ItemList.Key,
		   |	ItemList.Period AS Period,
		   |	VALUE(Enum.BatchDirection.Expense) AS Direction,
		   |	ItemList.Company AS Company,
		   |	ItemList.Store AS Store,
		   |	ItemList.ItemKey AS ItemKey,
		   |	ItemList.BatchDocument AS BatchDocument,
		   //#2093
		   //|	ConsignorBatches.Batch AS BatchConsignor,
		   //|	ISNULL(ConsignorBatches.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber,
		   //|	case
		   //|		when ConsignorBatches.Key IS NULL
		   //|			then False
		   //|		else true
		   //|	end as IsConsignorBatches,
		   //|	case
		   //|		when ConsignorBatches.Quantity is null
		   //|			then ItemList.Quantity
		   //|		else ConsignorBatches.Quantity
		   //|	end AS Quantity
		   |	ItemList.Quantity AS Quantity
		   |INTO BatchKeysInfo_1
		   |FROM
		   |	ItemList AS ItemList
		   //|		LEFT JOIN ConsignorBatches AS ConsignorBatches
		   //|		ON ItemList.Key = ConsignorBatches.Key
		   |WHERE
		   |	NOT ItemList.IsService
		   |;
		   |//////////////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	BatchKeysInfo_1.Period,
		   |	BatchKeysInfo_1.Direction,
		   |	BatchKeysInfo_1.Company,
		   |	BatchKeysInfo_1.Store,
		   |	BatchKeysInfo_1.ItemKey,
		   |	BatchKeysInfo_1.BatchDocument,
		  // |	BatchKeysInfo_1.BatchConsignor,
		   |	SUM(CASE
		   |		WHEN ISNULL(SourceOfOrigins.Quantity, 0) <> 0
		   |			THEN ISNULL(SourceOfOrigins.Quantity, 0)
		   |		ELSE BatchKeysInfo_1.Quantity
		   |	END) AS Quantity,
		   |	ISNULL(SourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)) AS SourceOfOrigin,
		   |	ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber
		   |INTO T6020S_BatchKeysInfo
		   |FROM
		   |	BatchKeysInfo_1 AS BatchKeysInfo_1
		   |		LEFT JOIN SourceOfOrigins AS SourceOfOrigins
		   |		ON BatchKeysInfo_1.Key = SourceOfOrigins.Key
		  // |		and case
		   //|			when BatchKeysInfo_1.IsConsignorBatches
		  // |				then BatchKeysInfo_1.SerialLotNumber = SourceOfOrigins.SerialLotNumberStock
		  // |			else true
		  // |		end
		   |GROUP BY
		   |	BatchKeysInfo_1.Period,
		   |	BatchKeysInfo_1.Direction,
		   |	BatchKeysInfo_1.Company,
		   |	BatchKeysInfo_1.Store,
		   |	BatchKeysInfo_1.ItemKey,
		   |	BatchKeysInfo_1.BatchDocument,
		 //  |	BatchKeysInfo_1.BatchConsignor,
		   |	ISNULL(SourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)),
		   |	ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef))";
EndFunction

//#2093
//Function R8012B_ConsignorInventory()
//	Return "SELECT
//		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
//		   |	ItemList.Period,
//		   |	ItemList.Company,
//		   |	ItemList.ItemKey,
//		   |	ConsignorBatches.SerialLotNumber,
//		   |	ItemList.Partner,
//		   |	ItemList.Agreement,
//		   |	ItemList.LegalName,
//		   |	SUM(ConsignorBatches.Quantity) AS Quantity
//		   |INTO R8012B_ConsignorInventory
//		   |FROM
//		   |	ItemList AS ItemList
//		   |		LEFT JOIN ConsignorBatches AS ConsignorBatches
//		   |		ON ItemList.Key = ConsignorBatches.Key
//		   |WHERE
//		   |	NOT ItemList.IsService
//		   |	AND ItemList.IsReturnToConsignor
//		   |GROUP BY
//		   |	VALUE(AccumulationRecordType.Expense),
//		   |	ItemList.Period,
//		   |	ItemList.Company,
//		   |	ItemList.ItemKey,
//		   |	ConsignorBatches.SerialLotNumber,
//		   |	ItemList.Partner,
//		   |	ItemList.Agreement,
//		   |	ItemList.LegalName";
//EndFunction

//#2093
//Function R8013B_ConsignorBatchWiseBalance()
//	Return "SELECT
//		   |	ItemList.Key,
//		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
//		   |	ItemList.Period,
//		   |	ItemList.Company,
//		   |	ConsignorBatches.Batch,
//		   |	ConsignorBatches.ItemKey,
//		   |	ConsignorBatches.SerialLotNumber,
//		   |	ConsignorBatches.Store,
//		   |	ConsignorBatches.Quantity
//		   |INTO ConsignorBatchWiseBalance_1
//		   |FROM
//		   |	ItemList AS ItemList
//		   |		INNER JOIN ConsignorBatches AS ConsignorBatches
//		   |		ON ItemList.IsReturnToConsignor
//		   |		AND ItemList.Key = ConsignorBatches.Key;
//		   |
//		   |////////////////////////////////////////////////////////////////////////////////
//		   |SELECT
//		   |	ConsignorBatchWiseBalance_1.RecordType,
//		   |	ConsignorBatchWiseBalance_1.Period,
//		   |	ConsignorBatchWiseBalance_1.Company,
//		   |	ConsignorBatchWiseBalance_1.Batch,
//		   |	ConsignorBatchWiseBalance_1.ItemKey,
//		   |	ConsignorBatchWiseBalance_1.Store,
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
//		   |	ConsignorBatchWiseBalance_1.ItemKey,
//		   |	ConsignorBatchWiseBalance_1.Store,
//		   |	SourceOfOrigins.SourceOfOriginStock,
//		   |	SourceOfOrigins.SerialLotNumberStock";
//
//EndFunction

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