#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure;
	Tables.Insert("CashInTransit", PostingServer.CreateTable(AccReg.CashInTransit));
	QueryPayments = New Query;
	QueryPayments.Text =
	"SELECT
	|	Payments.Ref.Date AS Period,
	|	Payments.Ref.Company AS Company,
	|	Payments.Ref.Currency AS Currency,
	|	Payments.Account AS FromAccount,
	|	Payments.Ref AS BasisDocument,
	|	Payments.Amount,
	|	Payments.Commission
	|
	|FROM
	|	Document.RetailReturnReceipt.Payments AS Payments
	|WHERE
	|	Payments.Ref = &Ref AND Payments.PostponedPayment";
	QueryPayments.SetParameter("Ref", Ref);
	Tables.CashInTransit = QueryPayments.Execute().Unload();

	Parameters.IsReposting = False;

	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);

	//#2093
//	Query = New Query;
//	Query.Text =
//	"SELECT
//	|	ItemList.Key,
//	|	ItemList.Ref.Company AS Company,
//	|	ItemList.RetailSalesReceipt AS SalesDocument,
//	|	ItemList.Store AS Store,
//	|	ItemList.ItemKey AS ItemKey,
//	|	ItemList.Quantity AS Quantity
//	|INTO tmpItemList
//	|FROM
//	|	Document.RetailReturnReceipt.ItemList AS ItemLIst
//	|WHERE
//	|	ItemList.Ref = &Ref
//	|	AND NOT ItemLIst.RetailSalesReceipt.Ref IS NULL
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|SELECT
//	|	SerialLotNumbers.Key,
//	|	SerialLotNumbers.SerialLotNumber,
//	|	SerialLotNumbers.Quantity
//	|INTO tmpSerialLotNumbers
//	|FROM
//	|	Document.RetailReturnReceipt.SerialLotNumbers AS SerialLotNumbers
//	|WHERE
//	|	SerialLotNumbers.Ref = &Ref
//	|;
//	|
//	|/////////////////////////////////////////////////////////////////////////////
//	|SELECT
//	|	SourceOfOrigins.Key,
//	|	SourceOfOrigins.SerialLotNumber,
//	|	SourceOfOrigins.SourceOfOrigin,
//	|	SourceOfOrigins.Quantity
//	|INTO tmpSourceOfOrigins
//	|FROM
//	|	Document.RetailReturnReceipt.SourceOfOrigins AS SourceOfOrigins
//	|WHERE
//	|	SourceOfOrigins.Ref = &Ref
//	|;
//	|////////////////////////////////////////////////////////////////////////////////
//	|SELECT
//	|	tmpItemList.Key,
//	|	tmpItemList.Company,
//	|	tmpItemList.SalesDocument,
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
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|SELECT
//	|	tmpItemList_1.Key,
//	|	tmpItemList_1.Company,
//	|	tmpItemList_1.SalesDocument,
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
//	Query.SetParameter("Ref", Ref);
//	ItemListTable = Query.Execute().Unload();
//	ConsignorBatches = CommissionTradeServer.GetTableConsignorBatchWiseBalanceForSalesReturn(Parameters.Object,
//		ItemListTable);
//
//	Query = New Query;
//	Query.TempTablesManager = Parameters.TempTablesManager;
//	Query.Text = "SELECT * INTO ConsignorBatches FROM &T1 AS T1";
//	Query.SetParameter("T1", ConsignorBatches);
//	Query.Execute();

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
	|SELECT // --[1]
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
	|	RetailReturnReceiptItemList.RetailSalesReceipt.Company AS SalesInvoice_Company
	|INTO tmpItemList
	|FROM
	|	Document.RetailReturnReceipt.ItemList AS RetailReturnReceiptItemList
	|WHERE
	|	RetailReturnReceiptItemList.Ref = &Ref
	|	AND NOT RetailReturnReceiptItemList.IsService
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
	|	VALUE(Enum.BatchDirection.Receipt)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT // --[0]
	|	RetailReturnReceipt.Ref AS Document,
	|	RetailReturnReceipt.Company AS Company,
	|	RetailReturnReceipt.Ref.Date AS Period
	|FROM
	|	Document.RetailReturnReceipt AS RetailReturnReceipt
	|WHERE
	|	RetailReturnReceipt.Ref = &Ref
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
	|	ISNULL(tmpSourceOfOrigins.SerialLotNumberStock, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumberStock
	|FROM
	|	tmpItemList AS tmpItemList
	|		LEFT JOIN tmpSourceOfOrigins AS tmpSourceOfOrigins
	|		ON tmpItemList.Key = tmpSourceOfOrigins.Key";

	Query.SetParameter("Ref", Ref);
	QueryResults = Query.ExecuteBatch();

	BatchesInfo   = QueryResults[2].Unload();
	BatchKeysInfo = QueryResults[3].Unload();

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
	Query = New Query;
	Query.Text =
	"SELECT
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
	|	CASE WHEN NOT BatchKeysInfo.SalesInvoiceIsFilled THEN BatchKeysInfo.LandedCostTax ELSE 0 END AS AmountTax,
	|
	|	BatchKeysInfo.*
	|FROM
	|	BatchKeysInfo AS BatchKeysInfo";
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
		BatchKeysInfo_DataTableGrouped.GroupBy("Period, Direction, Company, Store, ItemKey, Currency, CurrencyMovementType, SalesInvoice, SourceOfOrigin, SerialLotNumber, SourceOfOriginStock, SerialLotNumberStock,
											   |Quantity, Amount, AmountTax");
	EndIf;

//#2093
//	BatchKeysInfo_DataTableGrouped.Columns.Add("BatchConsignor", New TypeDescription("DocumentRef.PurchaseInvoice"));
//	BatchKeysInfo_DataTableGrouped.Columns.Add("__tmp_Quantity");
//	BatchKeysInfo_DataTableGrouped.Columns.Add("__tmp_Amount");
//	BatchKeysInfo_DataTableGrouped.Columns.Add("__tmp_AmountTax");
//	For Each Row In BatchKeysInfo_DataTableGrouped Do
//		Row.__tmp_Quantity  = Row.Quantity;
//		Row.__tmp_Amount    = Row.Amount;
//		Row.__tmp_AmountTax = Row.AmountTax;
//	EndDo;
//
//	BatchKeysInfo_DataTableGrouped_Copy = BatchKeysInfo_DataTableGrouped.CopyColumns();
//
//	For Each Row In BatchKeysInfo_DataTableGrouped Do
//		Filter = New Structure;
//		Filter.Insert("Company", Row.Company);
//		Filter.Insert("Store", Row.Store);
//		Filter.Insert("ItemKey", Row.ItemKey);
//		Filter.Insert("SourceOfOrigin", Row.SourceOfOriginStock);
//		Filter.Insert("SerialLotNumber", Row.SerialLotNumberStock);
//		Filter.Insert("SalesDocument", Row.SalesInvoice);
//
//		FilteredRows = ConsignorBatches.FindRows(Filter);
//
//		If Not FilteredRows.Count() Then
//			FillPropertyValues(BatchKeysInfo_DataTableGrouped_Copy.Add(), Row);
//			Continue;
//		EndIf;
//
//		NeedQuantity = Row.Quantity;
//		For Each BatchRow In FilteredRows Do
//			NewRow = BatchKeysInfo_DataTableGrouped_Copy.Add();
//			FillPropertyValues(NewRow, Row);
//			NewRow.Quantity = Min(NeedQuantity, BatchRow.Quantity);
//			NewRow.BatchConsignor = BatchRow.Batch;
//
//			NeedQuantity = NeedQuantity - NewRow.Quantity;
//			BatchRow.Quantity = BatchRow.Quantity - NewRow.Quantity;
//		EndDo;
//
//		If NeedQuantity <> 0 Then
//			NewRow = BatchKeysInfo_DataTableGrouped_Copy.Add();
//			FillPropertyValues(NewRow, Row);
//			NewRow.Quantity = NeedQuantity;
//		EndIf;
//	EndDo;
//
//	For Each Row In BatchKeysInfo_DataTableGrouped_Copy Do
//		If Not ValueIsFilled(Row.__tmp_Quantity) Then
//			Row.tmp_Amount = 0;
//			Row.AmountTax  = 0;
//		Else
//			Row.Amount    = Row.__tmp_Amount / Row.__tmp_Quantity * Row.Quantity;
//			Row.AmountTax = Row.__tmp_AmountTax / Row.__tmp_Quantity * Row.Quantity;
//		EndIf;
//	EndDo;
//
//	BatchKeysInfo_DataTableGrouped_Copy.Columns.Delete("__tmp_Quantity");
//	BatchKeysInfo_DataTableGrouped_Copy.Columns.Delete("__tmp_Amount");
//	BatchKeysInfo_DataTableGrouped_Copy.Columns.Delete("__tmp_AmountTax");
//
//	If BatchKeysInfo_DataTableGrouped_Copy.Count() Then
//		BatchKeysInfo_DataTableGrouped_Copy.GroupBy(
//			"BatchConsignor, Company ,Currency, CurrencyMovementType, Direction, ItemKey, Period, SalesInvoice, SerialLotNumber, SourceOfOrigin, Store",
//			"Quantity, Amount, AmountTax");
//	Else
//		BatchKeysInfo_DataTableGrouped_Copy.Columns.Add("CurrencyMovementType",
//			New TypeDescription("ChartOfCharacteristicTypesRef.CurrencyMovementType"));
//	EndIf;

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
	//#2093
//	Query.SetParameter("T2", BatchKeysInfo_DataTableGrouped_Copy);
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
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map;
	
	// CashInTransit
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.CashInTransit,
		New Structure("RecordType, RecordSet", AccumulationRecordType.Expense, Parameters.DocumentDataTables.CashInTransit));

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

#EndRegion

#Region Posting_SourceTable

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
	|	Payments.Certificate
	|INTO Payments
	|FROM
	|	Document.RetailReturnReceipt.Payments AS Payments
	|WHERE
	|	Payments.Ref = &Ref";
EndFunction

Function OffersInfo()
	Return "SELECT
		   |	RetailReturnReceiptItemList.Ref.Date AS Period,
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

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
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
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5021T_Revenues());
	//#2093
	//QueryArray.Add(R8012B_ConsignorInventory());
	//QueryArray.Add(R8013B_ConsignorBatchWiseBalance());
	
	QueryArray.Add(R8014T_ConsignorSales());
	QueryArray.Add(R9010B_SourceOfOriginStock());
	QueryArray.Add(T3010S_RowIDInfo());
	QueryArray.Add(T6010S_BatchesInfo());
	QueryArray.Add(T6020S_BatchKeysInfo());
	QueryArray.Add(R5015B_OtherPartnersTransactions());
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

Function R2001T_Sales()
	Return "SELECT
		   |	ItemList.RetailSalesReceipt AS Invoice,
		   |	- ItemList.Quantity AS Quantity,
		   |	- ItemList.TotalAmount AS Amount,
		   |	- ItemList.NetAmount AS NetAmount,
		   |	- ItemList.OffersAmount AS OffersAmount,
		   |	*
		   |INTO R2001T_Sales
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE";
EndFunction

Function R2005T_SalesSpecialOffers()
	Return "SELECT *
		   |INTO R2005T_SalesSpecialOffers
		   |FROM
		   |	OffersInfo AS OffersInfo
		   |WHERE TRUE";

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
		   |WHERE Payments.IsCertificate";
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
		   |	OR Payments.IsPaymentAgent)";
EndFunction

Function R3011T_CashFlow()
	Return "SELECT
		   |	Payments.Period,
		   |	Payments.Company,
		   |	Payments.Branch,
		   |	Payments.Account,
		   |	VALUE(Enum.CashFlowDirections.Outgoing) AS Direction,
		   |	Payments.FinancialMovementType,
		   |	Payments.Currency,
		   |	Payments.Amount
		   |INTO R3011T_CashFlow
		   |FROM
		   |	Payments AS Payments
		   |WHERE
		   |	NOT (Payments.IsPostponedPayment
		   |	OR Payments.IsPaymentAgent)";
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
		   |	AND NOT ItemList.GoodsReceiptExists";
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
		   |	NOT Payments.IsPaymentAgent";
EndFunction

Function R2050T_RetailSales()
	Return "SELECT
		   |	*
		   |INTO R2050T_RetailSales
		   |FROM
		   |	RetailReturn AS RetailReturn
		   |WHERE
		   |	TRUE";
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
		   |	TRUE";
EndFunction

Function R2002T_SalesReturns()
	Return "SELECT
		   |	*,
		   |	ItemList.TotalAmount AS Amount
		   |INTO R2002T_SalesReturns
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE";
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
		   |	SUM(ItemList.TotalAmount),
		   |	UNDEFINED
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.UsePartnerTransactions
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
		   |		AND RowIDInfo.Ref = ItemList.Ref";
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
		   |	Payments.IsPostponedPayment";
EndFunction

//#2093
//Function R8013B_ConsignorBatchWiseBalance()
//	Return "SELECT
//		   |	&Period AS Period,
//		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
//		   |	ConsignorBatches.Company,
//		   |	ConsignorBatches.Batch,
//		   |	ConsignorBatches.Store,
//		   |	ConsignorBatches.ItemKey,
//		   |	ConsignorBatches.SerialLotNumber,
//		   |	ConsignorBatches.SourceOfOrigin,
//		   |	SUM(ConsignorBatches.Quantity) AS Quantity
//		   |INTO R8013B_ConsignorBatchWiseBalance
//		   |FROM
//		   |	ConsignorBatches AS ConsignorBatches
//		   |WHERE
//		   |	TRUE
//		   |GROUP BY
//		   |	VALUE(AccumulationRecordType.Receipt),
//		   |	ConsignorBatches.Company,
//		   |	ConsignorBatches.Batch,
//		   |	ConsignorBatches.Store,
//		   |	ConsignorBatches.ItemKey,
//		   |	ConsignorBatches.SourceOfOrigin,
//		   |	ConsignorBatches.SerialLotNumber";
//EndFunction

//#2093
//Function R8012B_ConsignorInventory()
//	Return "SELECT
//		   |	&Period AS Period,
//		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
//		   |	ConsignorBatches.Company,
//		   |	ConsignorBatches.ItemKey,
//		   |	ConsignorBatches.SerialLotNumber,
//		   |	CASE
//		   |		WHEN ConsignorBatches.Batch REFS Document.OpeningEntry
//		   |			THEN ConsignorBatches.Batch.PartnerConsignor
//		   |		ELSE ConsignorBatches.Batch.Partner
//		   |	END AS Partner,
//		   |	CASE
//		   |		WHEN ConsignorBatches.Batch REFS Document.OpeningEntry
//		   |			THEN ConsignorBatches.Batch.AgreementConsignor
//		   |		ELSE ConsignorBatches.Batch.Agreement
//		   |	END AS Agreement,
//		   |	CASE
//		   |		WHEN ConsignorBatches.Batch REFS Document.OpeningEntry
//		   |			THEN ConsignorBatches.Batch.LegalNameConsignor
//		   |		ELSE ConsignorBatches.Batch.LegalName
//		   |	END AS LegalName,
//		   |	SUM(ConsignorBatches.Quantity) AS Quantity
//		   |INTO R8012B_ConsignorInventory
//		   |FROM
//		   |	ConsignorBatches AS ConsignorBatches
//		   |WHERE
//		   |	TRUE
//		   |GROUP BY
//		   |	VALUE(AccumulationRecordType.Receipt),
//		   |	ConsignorBatches.Company,
//		   |	ConsignorBatches.ItemKey,
//		   |	ConsignorBatches.SerialLotNumber,
//		   |	CASE
//		   |		WHEN ConsignorBatches.Batch REFS Document.OpeningEntry
//		   |			THEN ConsignorBatches.Batch.PartnerConsignor
//		   |		ELSE ConsignorBatches.Batch.Partner
//		   |	END,
//		   |	CASE
//		   |		WHEN ConsignorBatches.Batch REFS Document.OpeningEntry
//		   |			THEN ConsignorBatches.Batch.AgreementConsignor
//		   |		ELSE ConsignorBatches.Batch.Agreement
//		   |	END,
//		   |	CASE
//		   |		WHEN ConsignorBatches.Batch REFS Document.OpeningEntry
//		   |			THEN ConsignorBatches.Batch.LegalNameConsignor
//		   |		ELSE ConsignorBatches.Batch.LegalName
//		   |	END";
//EndFunction

Function R8014T_ConsignorSales()
	//#2093
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
		|	ItemList.IsConsignorStocks";
	
//	Return "SELECT
//		   |	&Period AS Period,
//		   |	ConsignorBatches.Company,
//		   |	ConsignorBatches.SalesDocument AS SalesInvoice,
//		   |	ConsignorBatches.ItemKey,
//		   |	ConsignorBatches.SerialLotNumber,
//		   |	ConsignorBatches.SourceOfOrigin,
//		   |	SUM(ConsignorBatches.Quantity) AS Quantity,
//		   |	ConsignorBatches.Batch AS BatchConsignor
//		   |INTO ReturnedConsignorBatches
//		   |FROM ConsignorBatches AS ConsignorBatches
//		   |GROUP BY
//		   |	ConsignorBatches.Company,
//		   |	ConsignorBatches.SalesDocument,
//		   |	ConsignorBatches.ItemKey,
//		   |	ConsignorBatches.SerialLotNumber,
//		   |	ConsignorBatches.SourceOfOrigin,
//		   |	ConsignorBatches.Batch
//		   |;
//		   |
//		   |////////////////////////////////////////////////////////////////////////////////
//		   |SELECT
//		   |	ConsignorSales.*
//		   |INTO ConsignorSales
//		   |FROM
//		   |	AccumulationRegister.R8014T_ConsignorSales AS ConsignorSales
//		   |WHERE
//		   |	(Company, Recorder, PurchaseInvoice, ItemKey, SerialLotNumber, SourceOfOrigin) IN
//		   |		(SELECT
//		   |			ReturnedConsignorBatches.Company,
//		   |			ReturnedConsignorBatches.SalesInvoice,
//		   |			ReturnedConsignorBatches.BatchConsignor,
//		   |			ReturnedConsignorBatches.ItemKey,
//		   |			ReturnedConsignorBatches.SerialLotNumber,
//		   |			ReturnedConsignorBatches.SourceOfOrigin
//		   |		FROM
//		   |			ReturnedConsignorBatches AS ReturnedConsignorBatches)
//		   |	AND ConsignorSales.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
//		   |;
//		   |
//		   |////////////////////////////////////////////////////////////////////////////////
//		   |SELECT
//		   |	ReturnedConsignorBatches.Period,
//		   |	ConsignorSales.RowKey AS Key,
//		   |	ConsignorSales.RowKey AS RowKey,
//		   |	ConsignorSales.Currency,
//		   |	-ReturnedConsignorBatches.Quantity AS Quantity,
//		   |	-case
//		   |		when ConsignorSales.Quantity = 0
//		   |			then 0
//		   |		else (ConsignorSales.NetAmount / ConsignorSales.Quantity) * ReturnedConsignorBatches.Quantity
//		   |	end AS NetAmount,
//		   |	-case
//		   |		when ConsignorSales.Quantity = 0
//		   |			then 0
//		   |		else (ConsignorSales.Amount / ConsignorSales.Quantity) * ReturnedConsignorBatches.Quantity
//		   |	end AS Amount,
//		   |	ConsignorSales.*
//		   |INTO R8014T_ConsignorSales
//		   |FROM
//		   |	ConsignorSales AS ConsignorSales
//		   |		INNER JOIN ReturnedConsignorBatches AS ReturnedConsignorBatches
//		   |		ON ReturnedConsignorBatches.Company = ConsignorSales.Company
//		   |		AND ReturnedConsignorBatches.SalesInvoice = ConsignorSales.SalesInvoice
//		   |		AND ReturnedConsignorBatches.ItemKey = ConsignorSales.ItemKey
//		   |		AND ReturnedConsignorBatches.SerialLotNumber = ConsignorSales.SerialLotNumber
//		   |		AND ReturnedConsignorBatches.SourceOfOrigin = ConsignorSales.SourceOfOrigin
//		   |		AND ReturnedConsignorBatches.BatchConsignor = ConsignorSales.PurchaseInvoice";
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