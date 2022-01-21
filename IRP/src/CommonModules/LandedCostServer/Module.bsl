
Function GetTypeDescriptionDocument()
	ArrayOfTypesDocument = New Array();
	ArrayOfTypesDocument.Add(Type("DocumentRef.PurchaseInvoice"));
	ArrayOfTypesDocument.Add(Type("DocumentRef.SalesInvoice"));
	ArrayOfTypesDocument.Add(Type("DocumentRef.InventoryTransfer"));
	ArrayOfTypesDocument.Add(Type("DocumentRef.Bundling"));
	ArrayOfTypesDocument.Add(Type("DocumentRef.OpeningEntry"));
	ArrayOfTypesDocument.Add(Type("DocumentRef.StockAdjustmentAsSurplus"));
	ArrayOfTypesDocument.Add(Type("DocumentRef.StockAdjustmentAsWriteOff"));
	ArrayOfTypesDocument.Add(Type("DocumentRef.PurchaseReturn"));
	ArrayOfTypesDocument.Add(Type("DocumentRef.SalesReturn"));
	ArrayOfTypesDocument.Add(Type("DocumentRef.Unbundling"));
	ArrayOfTypesDocument.Add(Type("DocumentRef.RetailSalesReceipt"));
	ArrayOfTypesDocument.Add(Type("DocumentRef.RetailReturnReceipt"));
	ArrayOfTypesDocument.Add(Type("DocumentRef.ItemStockAdjustment"));
	Return New TypeDescription(ArrayOfTypesDocument);		
EndFunction

Function CreateTable_BatchWiseBalance()	
	Table = New ValueTable();
	Table.Columns.Add("Batch"    , New TypeDescription("CatalogRef.LC_Batches"));
	Table.Columns.Add("BatchKey" , New TypeDescription("CatalogRef.LC_BatchKeys"));
	Table.Columns.Add("Document" , GetTypeDescriptionDocument());
	Table.Columns.Add("Company"  , New TypeDescription("CatalogRef.Companies"));
	Table.Columns.Add("Period"   , Metadata.AccumulationRegisters.LC_BatchWiseBalance.StandardAttributes.Period.Type);
	Table.Columns.Add("Quantity" , Metadata.AccumulationRegisters.LC_BatchWiseBalance.Resources.Quantity.Type);
	Table.Columns.Add("Amount"   , Metadata.AccumulationRegisters.LC_BatchWiseBalance.Resources.Quantity.Type);
	Return Table;
EndFunction

Procedure LockTables(LocksStorage)
	// Set lock for table Catalog.LC_Batches
	DataLock_LC_Batches = New DataLock();
	ItemLock_LC_Batches = DataLock_LC_Batches.Add("Catalog.LC_Batches");
	ItemLock_LC_Batches.Mode = DataLockMode.Exclusive;
	DataLock_LC_Batches.Lock();
	LocksStorage.Add(DataLock_LC_Batches);
	
	// Set lock for table Catalog.LC_BatchKeys
	DataLock_LC_BatchKeys = New DataLock();
	ItemLock_LC_BatchKeys = DataLock_LC_Batches.Add("Catalog.LC_BatchKeys");
	ItemLock_LC_BatchKeys.Mode = DataLockMode.Exclusive;
	DataLock_LC_BatchKeys.Lock();
	LocksStorage.Add(DataLock_LC_BatchKeys);
EndProcedure	

//Entry point
Procedure Posting_BatchWiceBalance(CalculationMovementCostRef, Company, CalculationMode, BeginPeriod, EndPeriod, AddInfo = Undefined) Export
	LocksStorage = New Array();
	If Not TransactionActive() Then
		BeginTransaction(DataLockControlMode.Managed);
		Try
			BatchWiseBalance_DoRegistration(LocksStorage, CalculationMovementCostRef, Company, CalculationMode, BeginPeriod, EndPeriod);
			If TransactionActive() Then
				CommitTransaction();
			EndIf;
		Except
			If TransactionActive() Then
				RollbackTransaction();
			EndIf;
			Raise ErrorDescription();
		EndTry;
	Else
		BatchWiseBalance_DoRegistration(LocksStorage, CalculationMovementCostRef, Company, CalculationMode, BeginPeriod, EndPeriod);
	EndIf;
EndProcedure

Procedure BatchWiseBalance_DoRegistration(LocksStorage, CalculationMovementCostRef, Company, CalculationMode, BeginPeriod, EndPeriod)
	If CalculationMode = Enums.LC_CalculationMode.LandedCost Then
		DoRegistration_CalculationMode_LandedCost(LocksStorage, CalculationMovementCostRef, Company, BeginPeriod, EndPeriod);
	ElsIf CalculationMode = Enums.LC_CalculationMode.AdditionalItemCost Then
		DoRegistration_CalculationMode_AdditionalItemCost(LocksStorage, CalculationMovementCostRef, Company, BeginPeriod, EndPeriod);
	EndIf;
EndProcedure

Procedure DoRegistration_CalculationMode_LandedCost(LocksStorage, CalculationMovementCostRef, Company, BeginPeriod, EndPeriod)
	LockTables(LocksStorage);
	
	Catalogs.LC_Batches.Create_Batches(Company, BeginPeriod, EndPeriod);
	Catalogs.LC_BatchKeys.Create_BatchKeys(Company, BeginPeriod, EndPeriod);
	
	BatchWiseBalanceTables = GetBatchWiseBalance(Company, BeginPeriod, EndPeriod); 
	
	RecordSet = AccumulationRegisters.LC_BatchWiseBalance.CreateRecordSet();
	RecordSet.Filter.Recorder.Set(CalculationMovementCostRef);

	//Batch wise balance
	For Each Row In BatchWiseBalanceTables.DataForReceipt Do
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Period = Row.Period;
		NewRecord.RecordType = AccumulationRecordType.Receipt; 
		NewRecord.Recorder = CalculationMovementCostRef;
	EndDo;
	For Each Row In BatchWiseBalanceTables.DataForExpense Do
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Period = Row.Period;
		NewRecord.RecordType = AccumulationRecordType.Expense;
		NewRecord.Recorder = CalculationMovementCostRef;
	EndDo;
	
	RecordSet.Write();
	
	//Batch shortage outgoing
	RecordSet = AccumulationRegisters.LC_BatchShortageOutgoing.CreateRecordSet();
	RecordSet.Filter.Recorder.Set(CalculationMovementCostRef);

	For Each Row In BatchWiseBalanceTables.DataForBatchShortageOutgoing Do	
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Period = Row.Period;
		NewRecord.Recorder = CalculationMovementCostRef;
	EndDo;
	
	RecordSet.Write();
	
	//Batch shortage incoming
	RecordSet = AccumulationRegisters.LC_BatchShortageIncoming.CreateRecordSet();
	RecordSet.Filter.Recorder.Set(CalculationMovementCostRef);

	For Each Row In BatchWiseBalanceTables.DataForBatchShortageIncoming Do	
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Period = Row.Period;
		NewRecord.Recorder = CalculationMovementCostRef;
	EndDo;
	
	RecordSet.Write();
	
	//Sales batches
	RecordSet = AccumulationRegisters.LC_SalesBatches.CreateRecordSet();
	RecordSet.Filter.Recorder.Set(CalculationMovementCostRef);

	For Each Row In BatchWiseBalanceTables.DataForSalesBatches Do	
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Period = Row.Period;
		NewRecord.Recorder = CalculationMovementCostRef;
	EndDo;
	
	RecordSet.Write();
	
	//Bundle amount values
	RecordSet = InformationRegisters.LC_BundleAmountValues.CreateRecordSet();
	RecordSet.Filter.Recorder.Set(CalculationMovementCostRef);

	For Each Row In BatchWiseBalanceTables.DataForBundleAmountValues Do	
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Period = Row.Period;
		NewRecord.Recorder = CalculationMovementCostRef;
	EndDo;
	
	RecordSet.Write();
	
	//Batch balance
	AccumulationRegisters.LC_BatchBalance.BatchBalance_LoadRecords(CalculationMovementCostRef);
	
	//Cost of goods sold
	AccumulationRegisters.LC_CostOfGoodsSold.CostOfGoodsSold_LoadRecords(CalculationMovementCostRef);
	
	//Relevance
	InformationRegisters.LC_BatchRelevance.BatchRelevance_Clear(Company, EndPeriod);
	InformationRegisters.LC_BatchRelevance.BatchRelevance_Restore(Company, EndPeriod);
EndProcedure

Procedure DoRegistration_CalculationMode_AdditionalItemCost(LocksStorage, CalculationMovementCostRef, Company, BeginPeriod, EndPeriod)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	LC_BatchCostAllocationInfo.Company AS Company,
	|	LC_BatchCostAllocationInfo.Document AS Document,
	|	LC_BatchCostAllocationInfo.Store AS Store,
	|	LC_BatchCostAllocationInfo.ItemKey AS ItemKey,
	|	LC_BatchCostAllocationInfo.CurrencyMovementType AS CurrencyMovementType,
	|	LC_BatchCostAllocationInfo.Currency AS Currency,
	|	LC_BatchCostAllocationInfo.Amount AS Amount
	|INTO CostAllocationInfo
	|FROM
	|	InformationRegister.LC_BatchCostAllocationInfo AS LC_BatchCostAllocationInfo
	|WHERE
	|	LC_BatchCostAllocationInfo.Period BETWEEN BEGINOFPERIOD(&BeginPeriod, DAY) AND ENDOFPERIOD(&EndPeriod, DAY)
	|	AND LC_BatchCostAllocationInfo.Company = &Company
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	LC_BatchKeysInfo.Company AS Company,
	|	LC_BatchKeysInfo.Recorder AS Document,
	|	LC_BatchKeysInfo.Store AS Store,
	|	LC_BatchKeysInfo.ItemKey AS ItemKey,
	|	SUM(LC_BatchKeysInfo.Quantity) AS Quantity,
	|	MAX(CostAllocationInfo.Amount) AS Amount
	|INTO CostAmmounts_tmp
	|FROM
	|	InformationRegister.LC_BatchKeysInfo AS LC_BatchKeysInfo
	|		INNER JOIN CostAllocationInfo AS CostAllocationInfo
	|		ON LC_BatchKeysInfo.Company = CostAllocationInfo.Company
	|		AND LC_BatchKeysInfo.Recorder = CostAllocationInfo.Document
	|		AND LC_BatchKeysInfo.ItemKey = CostAllocationInfo.ItemKey
	|		AND LC_BatchKeysInfo.Currency = CostAllocationInfo.Currency
	|		AND LC_BatchKeysInfo.CurrencyMovementType = CostAllocationInfo.CurrencyMovementType
	|		AND LC_BatchKeysInfo.Direction = VALUE(Enum.LC_BatchDirection.Receipt)
	|GROUP BY
	|	LC_BatchKeysInfo.Company,
	|	LC_BatchKeysInfo.Recorder,
	|	LC_BatchKeysInfo.Store,
	|	LC_BatchKeysInfo.ItemKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	CostAmmounts_tmp.Company AS Company,
	|	CostAmmounts_tmp.Document AS Document,
	|	CostAmmounts_tmp.Store AS Store,
	|	CostAmmounts_tmp.ItemKey AS ItemKey,
	|	CostAmmounts_tmp.Quantity AS Quantity,
	|	CostAmmounts_tmp.Amount AS Amount,
	|	CASE
	|		WHEN CostAmmounts_tmp.Quantity = 0
	|			THEN 0
	|		ELSE CostAmmounts_tmp.Amount / CostAmmounts_tmp.Quantity
	|	END AS AmountPerOneUnit
	|INTO CostAmmounts
	|FROM
	|	CostAmmounts_tmp AS CostAmmounts_tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	LC_BatchWiseBalance.Period AS Period,
	|	LC_BatchWiseBalance.Recorder AS Recorder,
	|	LC_BatchWiseBalance.LineNumber AS LineNumber,
	|	LC_BatchWiseBalance.Active AS Active,
	|	LC_BatchWiseBalance.RecordType AS RecordType,
	|	LC_BatchWiseBalance.Batch AS Batch,
	|	LC_BatchWiseBalance.BatchKey AS BatchKey,
	|	LC_BatchWiseBalance.Quantity AS Quantity1,
	|	LC_BatchWiseBalance.Amount AS Amount1,
	|	LC_BatchWiseBalance.AmountCost AS AmountCost1,
	|	LC_BatchWiseBalance.Document AS Document,
	|	0 AS Quantity,
	|	0 AS Amount,
	|	CostAmmounts.AmountPerOneUnit * LC_BatchWiseBalance.Quantity AS AmountCost
	|FROM
	|	AccumulationRegister.LC_BatchWiseBalance AS LC_BatchWiseBalance
	|		INNER JOIN CostAmmounts AS CostAmmounts
	|		ON LC_BatchWiseBalance.Batch.Document = CostAmmounts.Document
	|		AND LC_BatchWiseBalance.Batch.Company = CostAmmounts.Company
	|		AND LC_BatchWiseBalance.BatchKey.ItemKey = CostAmmounts.ItemKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	LC_SalesBatches.Period AS Period,
	|	LC_SalesBatches.Recorder AS Recorder,
	|	LC_SalesBatches.LineNumber AS LineNumber,
	|	LC_SalesBatches.Active AS Active,
	|	LC_SalesBatches.Batch AS Batch,
	|	LC_SalesBatches.BatchKey AS BatchKey,
	|	LC_SalesBatches.SalesInvoice AS SalesInvoice,
	|	LC_SalesBatches.Quantity AS Quantity1,
	|	LC_SalesBatches.Amount AS Amount1,
	|	LC_SalesBatches.AmountCost AS AmountCost1,
	|	0 AS Quantity,
	|	0 AS Amount,
	|	CostAmmounts.AmountPerOneUnit * LC_SalesBatches.Quantity AS AmountCost
	|FROM
	|	AccumulationRegister.LC_SalesBatches AS LC_SalesBatches
	|		INNER JOIN CostAmmounts AS CostAmmounts
	|		ON LC_SalesBatches.Batch.Document = CostAmmounts.Document
	|		AND LC_SalesBatches.Batch.Company = CostAmmounts.Company
	|		AND LC_SalesBatches.BatchKey.ItemKey = CostAmmounts.ItemKey";
//	|		AND LC_SalesBatches.BatchKey.Store = CostAmmounts.Store";
	Query.SetParameter("Company"     , Company);
	Query.SetParameter("BeginPeriod" , BeginPeriod);
	Query.SetParameter("EndPeriod"   , EndPeriod);
	QueryResults = Query.ExecuteBatch();
	
	RecordSet = AccumulationRegisters.LC_BatchWiseBalance.CreateRecordSet();
	RecordSet.Filter.Recorder.Set(CalculationMovementCostRef);

	//Batch wise balance
	For Each Row In QueryResults[3].Unload() Do
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Recorder = CalculationMovementCostRef;
	EndDo;	
	RecordSet.Write();
	
	//Sales batches
	RecordSet = AccumulationRegisters.LC_SalesBatches.CreateRecordSet();
	RecordSet.Filter.Recorder.Set(CalculationMovementCostRef);

	For Each Row In QueryResults[4].Unload() Do	
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Recorder = CalculationMovementCostRef;
	EndDo;
	RecordSet.Write();
	
	//Batch balance
	AccumulationRegisters.LC_BatchBalance.BatchBalance_LoadRecords(CalculationMovementCostRef);
	
	//Cost of goods sold
	AccumulationRegisters.LC_CostOfGoodsSold.CostOfGoodsSold_LoadRecords(CalculationMovementCostRef);
EndProcedure

#Region Basic_FIFO_Implementation

Function GetBatchWiseBalance(Company, BeginPeriod,  EndPeriod)
	tmp_manager = New TempTablesManager();
	Tree = GetBatchTree(tmp_manager, Company, BeginPeriod, EndPeriod);
		
	Tables = New Structure();
	Tables.Insert("DataForExpense"               , CreateTable_BatchWiseBalance());
	Tables.Insert("DataForReceipt"               , CreateTable_BatchWiseBalance());
	Tables.Insert("DataForBatchShortageOutgoing" , CreateTable_BatchWiseBalance());
	Tables.Insert("DataForBatchShortageIncoming" , CreateTable_BatchWiseBalance());
	Tables.Insert("DataForSalesBatches"          , CreateTable_BatchWiseBalance());
	
	ArrayOfTypes_SalesInvoice = New Array();
	ArrayOfTypes_SalesInvoice.Add(Type("DocumentRef.SalesInvoice"));
	ArrayOfTypes_SalesInvoice.Add(Type("DocumentRef.RetailSalesReceipt"));
	Tables.DataForSalesBatches.Columns.Add("SalesInvoice", New TypeDescription(ArrayOfTypes_SalesInvoice));
	
	Tables.Insert("DataForBundleAmountValues", New ValueTable());
	RegMetadata = Metadata.InformationRegisters.LC_BundleAmountValues;
	Tables.DataForBundleAmountValues.Columns.Add("Batch"          , RegMetadata.Dimensions.Batch.Type);
	Tables.DataForBundleAmountValues.Columns.Add("BatchKey"       , RegMetadata.Dimensions.BatchKey.Type);
	Tables.DataForBundleAmountValues.Columns.Add("Company"        , RegMetadata.Dimensions.Company.Type);
	Tables.DataForBundleAmountValues.Columns.Add("AmountValue"    , RegMetadata.Resources.AmountValue.Type);
	Tables.DataForBundleAmountValues.Columns.Add("Period"         , RegMetadata.StandardAttributes.Period.Type);
	Tables.DataForBundleAmountValues.Columns.Add("BatchKeyBundle" , RegMetadata.Dimensions.BatchKeyBundle.Type);
	
	RegMetadata = Metadata.InformationRegisters.LC_BatchKeysInfo;
	TableOfReturnedBatches = New ValueTable();
	TableOfReturnedBatches.Columns.Add("IsOpeningBalance" , New TypeDescription("Boolean"));
	TableOfReturnedBatches.Columns.Add("Skip"             , New TypeDescription("Boolean"));
	TableOfReturnedBatches.Columns.Add("Priority"         , New TypeDescription("Number"));
	TableOfReturnedBatches.Columns.Add("BatchKey"         , New TypeDescription("CatalogRef.LC_BatchKeys"));
	TableOfReturnedBatches.Columns.Add("Quantity"         , RegMetadata.Resources.Quantity.Type);
	TableOfReturnedBatches.Columns.Add("Amount"           , RegMetadata.Resources.Amount.Type);
	TableOfReturnedBatches.Columns.Add("Document"         , GetTypeDescriptionDocument());
	TableOfReturnedBatches.Columns.Add("Date"             , RegMetadata.StandardAttributes.Period.Type);
	TableOfReturnedBatches.Columns.Add("Company"          , RegMetadata.Dimensions.Company.Type);
	TableOfReturnedBatches.Columns.Add("Direction"        , RegMetadata.Dimensions.Direction.Type);
	TableOfReturnedBatches.Columns.Add("Batch"            , New TypeDescription("CatalogRef.LC_Batches"));
	TableOfReturnedBatches.Columns.Add("QuantityBalance"  , RegMetadata.Resources.Quantity.Type);
	TableOfReturnedBatches.Columns.Add("AmountBalance"    , RegMetadata.Resources.Amount.Type);
	TableOfReturnedBatches.Columns.Add("BatchDocument"    , RegMetadata.Dimensions.BatchDocument.Type);
	TableOfReturnedBatches.Columns.Add("SalesInvoice"     , RegMetadata.Dimensions.SalesInvoice.Type);
		
	For Each Row In  Tree.Rows Do
		CalculateBatch(Row.Document, Row.Rows, Tables, Tree, TableOfReturnedBatches);
		If TableOfReturnedBatches.Count() Then
			For Each RowReturnedBatches In TableOfReturnedBatches Do
				ArrayOfTreeRows = Tree.Rows.FindRows(New Structure("Document", RowReturnedBatches.Document));
				If Not ArrayOfTreeRows.Count() Then 
					Raise "Not found batch for sales return";
				EndIf;
				For Each ItemOfTreeRows In ArrayOfTreeRows Do
					FillPropertyValues(ItemOfTreeRows.Rows.Add(), RowReturnedBatches);
				EndDo;
			EndDo;
			Row.Rows.Sort("Date");
		EndIf;
	EndDo;
	Return Tables;
EndFunction
	
Function GetBatchTree(TempTablesManager, Company, BeginPeriod, EndPeriod)
	Query = New Query();
	Query.TempTablesManager = TempTablesManager;
	Query.Text =	
	"SELECT
	|	LC_BatchKeys.Ref AS BatchKey,
	|	SUM(LC_BatchKeysInfo.Quantity) AS Quantity,
	|	SUM(LC_BatchKeysInfo.Amount) AS Amount,
	|	LC_BatchKeysInfo.Recorder AS Document,
	|	LC_BatchKeysInfo.Period AS Date,
	|	LC_BatchKeysInfo.Company AS Company,
	|	LC_BatchKeysInfo.Direction AS Direction,
	|	LC_BatchKeysInfo.BatchDocument AS BatchDocument,
	|	LC_BatchKeysInfo.SalesInvoice AS SalesInvoice
	|INTO BatchKeys
	|FROM
	|	InformationRegister.LC_BatchKeysInfo AS LC_BatchKeysInfo
	|		INNER JOIN Catalog.LC_BatchKeys AS LC_BatchKeys
	|		ON (LC_BatchKeysInfo.Period BETWEEN BEGINOFPERIOD(&BeginPeriod, DAY) AND ENDOFPERIOD(&EndPeriod, DAY))
	|			AND (LC_BatchKeys.ItemKey = LC_BatchKeysInfo.ItemKey)
	|			AND (LC_BatchKeys.Store = LC_BatchKeysInfo.Store)
	|			AND (NOT LC_BatchKeys.DeletionMark)
	|			AND (LC_BatchKeysInfo.Company = &Company)
	//
//	|			AND (LC_BatchKeysInfo.Direction = VALUE(Enum.LC_BatchDirection.Receipt) 
//	|					OR LC_BatchKeysInfo.Direction = VALUE(Enum.LC_BatchDirection.Expense))
	//
	|
	|GROUP BY
	|	LC_BatchKeys.Ref,
	|	LC_BatchKeysInfo.Recorder,
	|	LC_BatchKeysInfo.Period,
	|	LC_BatchKeysInfo.Company,
	|	LC_BatchKeysInfo.Direction,
	|	LC_BatchKeysInfo.BatchDocument,
	|	LC_BatchKeysInfo.SalesInvoice
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	FALSE AS IsOpeningBalance,
	|	BatchKeys.BatchKey AS BatchKey,
	|	BatchKeys.Quantity AS Quantity,
	|	BatchKeys.Amount AS Amount,
	|	BatchKeys.Document AS Document,
	|	BatchKeys.Date AS Date,
	|	BatchKeys.Company AS Company,
	|	BatchKeys.Direction AS Direction,
	|	ISNULL(LC_Batches.Ref, VALUE(Catalog.LC_Batches.EmptyRef)) AS Batch,
	|	CASE
	|		WHEN LC_Batches.Ref IS NULL OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.Quantity
	|	END AS QuantityBalance,
	|	CASE
	|		WHEN LC_Batches.Ref IS NULL OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.Amount
	|	END AS AmountBalance,
	|	BatchKeys.BatchDocument AS BatchDocument,
	|	BatchKeys.SalesInvoice AS SalesInvoice
	|INTO AllData
	|FROM
	|	BatchKeys AS BatchKeys
	|		LEFT JOIN Catalog.LC_Batches AS LC_Batches
	|		ON (LC_Batches.Document = BatchKeys.Document)
	|			AND (LC_Batches.Company = BatchKeys.Company)
	|			AND (LC_Batches.Date = BatchKeys.Date)
	|			AND (NOT LC_Batches.DeletionMark)
	|
	|UNION ALL
	|
	|SELECT
	|	TRUE,
	|	LC_BatchWiseBalance.BatchKey,
	|	0,
	|	0,
	|	LC_BatchWiseBalance.Batch.Document,
	|	LC_BatchWiseBalance.Batch.Date,
	|	LC_BatchWiseBalance.Batch.Company,
	|	VALUE(enum.LC_BatchDirection.Receipt),
	|	LC_BatchWiseBalance.Batch,
	|	LC_BatchWiseBalance.QuantityBalance,
	|	LC_BatchWiseBalance.AmountBalance,
	|	UNDEFINED,
	|	UNDEFINED
	|FROM
	|	AccumulationRegister.LC_BatchWiseBalance.Balance(
	|			ENDOFPERIOD(&EndPeriod, DAY),
	|			(BatchKey, Batch.Company) IN
	|				(SELECT
	|					BatchKeys.BatchKey,
	|					BatchKeys.Company
	|				FROM
	|					BatchKeys AS BatchKeys)) AS LC_BatchWiseBalance
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AllData.IsOpeningBalance AS IsOpeningBalance,
	|	AllData.BatchKey AS BatchKey,
	|	SUM(AllData.Quantity) AS Quantity,
	|	SUM(AllData.Amount) AS Amount,
	|	AllData.Document AS Document,
	|	AllData.Date AS Date,
	|	AllData.Company AS Company,
	|	AllData.Direction AS Direction,
	|	AllData.Batch AS Batch,
	|	SUM(AllData.QuantityBalance) AS QuantityBalance,
	|	SUM(AllData.AmountBalance) AS AmountBalance,
	|	AllData.BatchDocument AS BatchDocument,
	|	AllData.SalesInvoice AS SalesInvoice
	|INTO AllDataGrouped
	|FROM
	|	AllData AS AllData
	|
	|GROUP BY
	|	AllData.IsOpeningBalance,
	|	AllData.BatchKey,
	|	AllData.Document,
	|	AllData.Date,
	|	AllData.Company,
	|	AllData.Direction,
	|	AllData.Batch,
	|	AllData.BatchDocument,
	|	AllData.SalesInvoice
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AllDataGrouped.IsOpeningBalance AS IsOpeningBalance,
	|	AllDataGrouped.BatchKey AS BatchKey,
	|	AllDataGrouped.Quantity AS Quantity,
	|	AllDataGrouped.Amount AS Amount,
	|	AllDataGrouped.Document AS Document,
	|	AllDataGrouped.Date AS Date,
	|	AllDataGrouped.Company AS Company,
	|	AllDataGrouped.Direction AS Direction,
	|	AllDataGrouped.Batch AS Batch,
	|	AllDataGrouped.QuantityBalance AS QuantityBalance,
	|	AllDataGrouped.AmountBalance AS AmountBalance,
	|	AllDataGrouped.BatchDocument AS BatchDocument,
	|	AllDataGrouped.SalesInvoice AS SalesInvoice,
	|	FALSE AS Skip,
	|	0 AS Priority
	|FROM
	|	AllDataGrouped AS AllDataGrouped
	|
	|ORDER BY
	|	Date
	|TOTALS BY
	|	Document";
	
	Query.SetParameter("Company", Company);
	Query.SetParameter("BeginPeriod", BegOfDay(BeginPeriod));
	Query.SetParameter("EndPeriod", EndOfDay(EndPeriod));
	QueryResult = Query.Execute();
	Tree = QueryResult.Unload(QueryResultIteration.ByGroups);
	
	ArrayOfReturnedSalesInvoices = New Array();
	For Each Row In Tree.Rows Do
		For Each RowDetails In Row.Rows Do
			If ValueIsFilled(RowDetails.SalesInvoice) Then
				ArrayOfReturnedSalesInvoices.Add(RowDetails.SalesInvoice);
			EndIf;
		EndDo;
	EndDo;
	Query = New Query();
	Query.Text = 
	"SELECT
	|	LC_SalesBatchesTurnovers.Batch.Document AS BatchDocument
	|FROM
	|	AccumulationRegister.LC_SalesBatches.Turnovers(, , , SalesInvoice IN (&ArrayOfReturnedSalesInvoices)) AS LC_SalesBatchesTurnovers
	|
	|GROUP BY
	|	LC_SalesBatchesTurnovers.Batch.Document";
	Query.SetParameter("ArrayOfReturnedSalesInvoices", ArrayOfReturnedSalesInvoices);
	TableOfBatchDocuments = Query.Execute().Unload();
	For Each RowBatchDocument In TableOfBatchDocuments Do
		If Not Tree.Rows.FindRows(New Structure("Document", RowBatchDocument.BatchDocument)).Count() Then
			Tree.Rows.Add().Document = RowBatchDocument.BatchDocument; 	
		EndIf;
	EndDo;
	
	Return Tree;	
EndFunction
	
Procedure CalculateBatch(Document, Rows, Tables, Tree, TableOfReturnedBatches)
	TableOfReturnedBatches.Clear();
	
	DataForExpense = CreateTable_BatchWiseBalance();
	DataForReceipt = CreateTable_BatchWiseBalance();
	
	For Each Row In Rows Do
		If Row.Skip Then
			Continue;
		EndIf;
		If Row.Direction = Enums.LC_BatchDirection.Receipt 
			And Not Row.IsOpeningBalance Then
				
				NewRow = DataForReceipt.Add();
				NewRow.Batch     = Row.Batch;
				NewRow.BatchKey  = Row.BatchKey;
				NewRow.Document  = Row.Document;
				NewRow.Company   = Row.Company;
				NewRow.Period    = Row.Date;
				NewRow.Quantity  = Row.Quantity;
				NewRow.Amount    = Row.Amount;
			
			If TypeOf(Document) <> Type("DocumentRef.InventoryTransfer")
				And TypeOf(Document) <> Type("DocumentRef.Bundling")
				And TypeOf(Document) <> Type("DocumentRef.Unbundling")
				And TypeOf(Document) <> Type("DocumentRef.ItemStockAdjustment")
				And Not ValueIsFilled(Row.SalesInvoice)	Then
				FillPropertyValues(Tables.DataForReceipt.Add(), NewRow);
			EndIf;
			
			If ValueIsFilled(Row.SalesInvoice)Then //Return by sales invoice
				
				Table_SalesBatches = GetSalesBatches(Row.SalesInvoice, Tables.DataForSalesBatches, Row.BatchKey.ItemKey);
				
				NeedReceipt = Row.Quantity;
				
				For Each Row_SalesBatches In Table_SalesBatches Do
					ReceiptQuantity = Min(NeedReceipt, Row_SalesBatches.Quantity);	
					ReceiptAmount = 0;
					If Row_SalesBatches.Quantity - ReceiptQuantity = 0 Then
						ReceiptAmount = Row_SalesBatches.Amount;
					Else
						If Row_SalesBatches.Quantity <> 0 Then
							ReceiptAmount = (Row_SalesBatches.Amount / Row_SalesBatches.Quantity) * ReceiptQuantity;
						EndIf;
					EndIf;
					Row_SalesBatches.Quantity = Row_SalesBatches.Quantity - ReceiptQuantity;
					Row_SalesBatches.Amount = Row_SalesBatches.Amount - ReceiptAmount;
					NeedReceipt = NeedReceipt - ReceiptQuantity;

					NewRow_ReturnedBatches = TableOfReturnedBatches.Add();
					NewRow_ReturnedBatches.IsOpeningBalance = False;
					NewRow_ReturnedBatches.Skip             = True;
					NewRow_ReturnedBatches.Priority         = 0;
					NewRow_ReturnedBatches.BatchKey         = Row.BatchKey;
					NewRow_ReturnedBatches.Quantity         = ReceiptQuantity;
					NewRow_ReturnedBatches.Amount           = ReceiptAmount;
					NewRow_ReturnedBatches.Document         = Row_SalesBatches.Document;
					NewRow_ReturnedBatches.Date             = Row.Date;
					NewRow_ReturnedBatches.Company          = Row_SalesBatches.Company;
					NewRow_ReturnedBatches.Direction        = Enums.LC_BatchDirection.Receipt;
					NewRow_ReturnedBatches.Batch            = Row_SalesBatches.Batch;
					NewRow_ReturnedBatches.QuantityBalance  = ReceiptQuantity;
					NewRow_ReturnedBatches.AmountBalance    = ReceiptAmount;
					
					NewRow_DataForReceipt = Tables.DataForReceipt.Add();
					NewRow_DataForReceipt.Batch    = Row_SalesBatches.Batch;
					NewRow_DataForReceipt.BatchKey = Row.BatchKey;
					NewRow_DataForReceipt.Document = Row.Document;
					NewRow_DataForReceipt.Company  = Row_SalesBatches.Company;
					NewRow_DataForReceipt.Period   = Row.Date;
					NewRow_DataForReceipt.Quantity = ReceiptQuantity;
					NewRow_DataForReceipt.Amount   = ReceiptAmount;
				EndDo;
				
				If NeedReceipt <> 0 Then
					Message(StrTemplate("Can not receipt Batch key by sales return: %1 , Quantity: %2 , Doc: %3", Row.BatchKey,
						NeedReceipt, Row.Document));
					NewRow = Tables.DataForBatchShortageIncoming.Add();
					NewRow.BatchKey = Row.BatchKey;
					NewRow.Document = Row.Document;
					NewRow.Company  = Row.Company;
					NewRow.Period   = Row.Date;
					NewRow.Quantity = NeedReceipt;
				EndIf;
			EndIf;
		Else //Expense
			Stop = False;
			NeedExpense = Row.Quantity;
			
			RestoreSortByDate = False;
			//purchase return by purchase invoice
			If ValueIsFilled(Row.BatchDocument) Then
				RestoreSortByDate = True;
				For Each Row_Documents In Tree.Rows Do
					For Each Row_Batch In Row_Documents.Rows Do
						If Row.BatchDocument = Row_Batch.Batch.Document Then 
							Row_Batch.Priority = -1;
						EndIf;
					EndDo;
					Row_Documents.Rows.Sort("Priority, Date");
				EndDo;
			EndIf;
			
			For Each Row_Documents In Tree.Rows Do
				If Stop Then
					//Break;
				EndIf;
				
				For Each Row_Batch In Row_Documents.Rows Do
					If Row_Batch.Date > Row.Date Then
						Stop = True;
						Break;
					EndIf;
					If Not ValueIsFilled(Row_Batch.Batch) 
						Or Row_Batch.Direction <> Enums.LC_BatchDirection.Receipt
						Or NeedExpense = 0 
						Or Row_Batch.QuantityBalance = 0
						Or Row.BatchKey <> Row_Batch.BatchKey Then 
						Continue;
					EndIf;
					ExpenseQuantity = Min(NeedExpense, Row_Batch.QuantityBalance);

					ExpenseAmount = 0;
					If Row_Batch.QuantityBalance - ExpenseQuantity = 0 Then
						ExpenseAmount = Row_Batch.AmountBalance;
					Else
						If Row_Batch.QuantityBalance <> 0 Then
							ExpenseAmount = Round((Row_Batch.AmountBalance / Row_Batch.QuantityBalance) * ExpenseQuantity,2);
						EndIf;
					EndIf;
					Row_Batch.QuantityBalance = Row_Batch.QuantityBalance - ExpenseQuantity;
					Row_Batch.AmountBalance = Row_Batch.AmountBalance - ExpenseAmount;
					NeedExpense = NeedExpense - ExpenseQuantity;

					If ExpenseQuantity <> 0 Or ExpenseAmount <> 0 Then
						NewRow = Tables.DataForExpense.Add();
						NewRow.BatchKey = Row.BatchKey;
						NewRow.Document = Row.Document;
						NewRow.Company = Row.Company;
						NewRow.Period = Row.Date;

						NewRow.Batch = Row_Batch.Batch;
						NewRow.Quantity = ExpenseQuantity;
						NewRow.Amount = ExpenseAmount;
						
						FillPropertyValues(DataForExpense.Add(), NewRow);
						If TypeOf(Row.Document) = Type("DocumentRef.SalesInvoice") 
							Or TypeOf(Row.Document) = Type("DocumentRef.RetailSalesReceipt") Then
							NewRow_SalesBatches = Tables.DataForSalesBatches.Add();
							FillPropertyValues(NewRow_SalesBatches, NewRow);
							NewRow_SalesBatches.SalesInvoice = Row.Document;
						EndIf;
					EndIf;
				EndDo;
			EndDo;
			
			If RestoreSortByDate Then
				For Each Row_Documents In Tree.Rows Do
					Row_Documents.Rows.Sort("Date");
				EndDo;
			EndIf;
			
			If NeedExpense <> 0 Then
				Message(StrTemplate("Can not expense Batch key: %1 , Quantity: %2 , Doc: %3", Row.BatchKey,
					NeedExpense, Row.Document));
				NewRow = Tables.DataForBatchShortageOutgoing.Add();
				NewRow.BatchKey = Row.BatchKey;
				NewRow.Document = Row.Document;
				NewRow.Company = Row.Company;
				NewRow.Period = Row.Date;
				NewRow.Quantity = NeedExpense;
			EndIf;
		EndIf;
	EndDo;
	
	TableOfNewReceivedBatches = New ValueTable();
	TableOfNewReceivedBatches.Columns.Add("Batch");
	TableOfNewReceivedBatches.Columns.Add("BatchKey");
	TableOfNewReceivedBatches.Columns.Add("Document");
	TableOfNewReceivedBatches.Columns.Add("Company");
	TableOfNewReceivedBatches.Columns.Add("Date");
	TableOfNewReceivedBatches.Columns.Add("Quantity");
	TableOfNewReceivedBatches.Columns.Add("Amount");
	TableOfNewReceivedBatches.Columns.Add("QuantityBalance");
	TableOfNewReceivedBatches.Columns.Add("AmountBalance");
	TableOfNewReceivedBatches.Columns.Add("IsOpeningBalance");
	TableOfNewReceivedBatches.Columns.Add("Direction");
		
	If TypeOf(Document) = Type("DocumentRef.InventoryTransfer") Then
						
		For Each Row In Rows Do
			If Row.Direction = Enums.LC_BatchDirection.Receipt And Not Row.IsOpeningBalance Then
				NeedReceipt = Row.Quantity;
				For Each Row_Expense In DataForExpense Do
					If Row.BatchKey.ItemKey = Row_Expense.BatchKey.ItemKey Then
						
						NeedReceipt = NeedReceipt - Row_Expense.Quantity;
						
						NewRow = Tables.DataForReceipt.Add();
						NewRow.Batch = Row_Expense.Batch;
						NewRow.BatchKey = Row.BatchKey;
						NewRow.Document = Row.Document;
						NewRow.Company = Row.Company;
						NewRow.Period = Row.Date;
						NewRow.Quantity = Row_Expense.Quantity;
						NewRow.Amount = Row_Expense.Amount;
						
						NewRowReceivedBatch = TableOfNewReceivedBatches.Add();
						NewRowReceivedBatch.Batch = Row_Expense.Batch;
						NewRowReceivedBatch.BatchKey = Row.BatchKey;
						NewRowReceivedBatch.Document = Row.Document;
						NewRowReceivedBatch.Company = Row.Company;
						NewRowReceivedBatch.Date = Row.Date;
						NewRowReceivedBatch.Quantity = Row_Expense.Quantity;
						NewRowReceivedBatch.Amount = Row_Expense.Amount;
						NewRowReceivedBatch.QuantityBalance = Row_Expense.Quantity;
						NewRowReceivedBatch.AmountBalance = Row_Expense.Amount;
						NewRowReceivedBatch.IsOpeningBalance = False;
						NewRowReceivedBatch.Direction = Enums.LC_BatchDirection.Receipt;
							
					EndIf;
				EndDo;
				If NeedReceipt <> 0 Then
					Message(StrTemplate("Can not receipt Batch key: %1 , Quantity: %2 , Doc: %3", Row.BatchKey,
						NeedReceipt, Row.Document));
					NewRow = Tables.DataForBatchShortageIncoming.Add();
					NewRow.BatchKey = Row.BatchKey;
					NewRow.Document = Row.Document;
					NewRow.Company = Row.Company;
					NewRow.Period = Row.Date;
					NewRow.Quantity = NeedReceipt;
				EndIf;
			EndIf;
		EndDo;
		
		For Each Row In TableOfNewReceivedBatches Do
			FillPropertyValues(Rows.Add(), Row);	
		EndDo;
		ArrayForDelete = New Array();
		For Each Row In Rows Do
			If Not ValueIsFilled(Row.AmountBalance) Then
				ArrayForDelete.Add(Row);
			EndIf;
		EndDo;
		For Each Row In ArrayForDelete Do
			Rows.Delete(Row);
		EndDo;
	ElsIf TypeOf(Document) = Type("DocumentRef.Bundling") 
			Or TypeOf(Document) = Type("DocumentRef.ItemStockAdjustment") Then
		
		For Each Row_Receipt In DataForReceipt Do
			NewRow = Tables.DataForReceipt.Add();
			FillPropertyValues(NewRow, Row_Receipt);
			TotalExpense = DataForExpense.Total("Amount"); 
			For Each Row_Expense In DataForExpense Do
				NewRow.Amount = NewRow.Amount + Row_Expense.Amount;
				NewRowBundleAmountValues = Tables.DataForBundleAmountValues.Add();
				NewRowBundleAmountValues.Batch = Row_Expense.Batch;
				NewRowBundleAmountValues.BatchKey = Row_Expense.BatchKey;
				NewRowBundleAmountValues.Company = Row_Expense.Company;
				NewRowBundleAmountValues.Period = Row_Expense.Period;
				NewRowBundleAmountValues.BatchKeyBundle = Row_Receipt.BatchKey;
				If TotalExpense <> 0 And Row_Expense.Amount <> 0 Then
					NewRowBundleAmountValues.AmountValue = Row_Expense.Amount / (TotalExpense / 100);
				EndIf;
			EndDo;
			
			NewRowReceivedBatch = TableOfNewReceivedBatches.Add();
			NewRowReceivedBatch.Batch = NewRow.Batch;
			NewRowReceivedBatch.BatchKey = NewRow.BatchKey;
			NewRowReceivedBatch.Document = NewRow.Document;
			NewRowReceivedBatch.Company = NewRow.Company;
			NewRowReceivedBatch.Date = NewRow.Period;
			NewRowReceivedBatch.Quantity = NewRow.Quantity;
			NewRowReceivedBatch.Amount = NewRow.Amount;
			NewRowReceivedBatch.QuantityBalance = NewRow.Quantity;
			NewRowReceivedBatch.AmountBalance = NewRow.Amount;
			NewRowReceivedBatch.IsOpeningBalance = False;
			NewRowReceivedBatch.Direction = Enums.LC_BatchDirection.Receipt;
						
		EndDo;
		
		For Each Row In TableOfNewReceivedBatches Do
			FillPropertyValues(Rows.Add(), Row);	
		EndDo;
		ArrayForDelete = New Array();
		For Each Row In Rows Do
			If Not ValueIsFilled(Row.AmountBalance) Then
				ArrayForDelete.Add(Row);
			EndIf;
		EndDo;
		For Each Row In ArrayForDelete Do
			Rows.Delete(Row);
		EndDo;
		
	ElsIf TypeOf(Document) = Type("DocumentRef.Unbundling") Then
		
		For Each Row_Receipt In DataForReceipt Do
			NewRow = Tables.DataForReceipt.Add();
			FillPropertyValues(NewRow, Row_Receipt);
			For Each Row_Expense In DataForExpense Do
				If Not ValueIsFilled(Row_Expense.Amount) Then
					Continue;
				EndIf;
				Query = New Query();
				Query.Text = 
				"SELECT
				|	DataForBundleAmountValues.BatchKey AS BatchKey,
				|	DataForBundleAmountValues.Company AS Company,
				|	DataForBundleAmountValues.BatchKeyBundle AS BatchKeyBundle,
				|	DataForBundleAmountValues.AmountValue AS AmountValue
				|INTO DataForBundleAmountValues
				|FROM
				|	&DataForBundleAmountValues AS DataForBundleAmountValues
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|SELECT
				|	DataForBundleAmountValues.BatchKey AS BatchKey,
				|	DataForBundleAmountValues.Company AS Company,
				|	DataForBundleAmountValues.BatchKeyBundle AS BatchKeyBundle,
				|	DataForBundleAmountValues.AmountValue AS AmountValue
				|FROM
				|	DataForBundleAmountValues AS DataForBundleAmountValues
				|WHERE
				|	DataForBundleAmountValues.BatchKey = &BatchKey
				|	AND DataForBundleAmountValues.Company = &Company
				|	AND DataForBundleAmountValues.BatchKeyBundle = &BatchKeyBundle
				|
				|UNION
				|
				|SELECT
				|	LC_BundleAmountValues.BatchKey,
				|	LC_BundleAmountValues.Company,
				|	LC_BundleAmountValues.BatchKeyBundle,
				|	LC_BundleAmountValues.AmountValue
				|FROM
				|	InformationRegister.LC_BundleAmountValues AS LC_BundleAmountValues
				|WHERE
				|	LC_BundleAmountValues.BatchKey = &BatchKey
				|	AND LC_BundleAmountValues.Company = &Company
				|	AND LC_BundleAmountValues.BatchKeyBundle = &BatchKeyBundle
				|
				|UNION
				|
				|SELECT
				|	LC_BatchKeys.Ref,
				|	LC_ManualBundleAmountValues.Company,
				|	LC_BatchKeys_Bundle.Ref,
				|	LC_ManualBundleAmountValues.AmountValue
				|FROM
				|	InformationRegister.LC_ManualBundleAmountValues AS LC_ManualBundleAmountValues
				|		INNER JOIN Catalog.LC_BatchKeys AS LC_BatchKeys
				|		ON LC_ManualBundleAmountValues.ItemKey = LC_BatchKeys.ItemKey
				|			AND LC_ManualBundleAmountValues.Store = LC_BatchKeys.Store
				|		INNER JOIN Catalog.LC_BatchKeys AS LC_BatchKeys_Bundle
				|		ON LC_ManualBundleAmountValues.Bundle = LC_BatchKeys_Bundle.ItemKey
				|			AND LC_ManualBundleAmountValues.Store = LC_BatchKeys_Bundle.Store
				|WHERE
				|	LC_ManualBundleAmountValues.Company = &Company
				|	AND LC_ManualBundleAmountValues.ItemKey = &ItemKey
				|	AND LC_ManualBundleAmountValues.Bundle = &Bundle
				|	AND LC_ManualBundleAmountValues.Store = &Store";
				Query.SetParameter("DataForBundleAmountValues", Tables.DataForBundleAmountValues);
				Query.SetParameter("BatchKeyBundle", Row_Expense.BatchKey);
				Query.SetParameter("BatchKey", Row_Receipt.BatchKey); 
				Query.SetParameter("Company", Row_Expense.Company);
				Query.SetParameter("ItemKey", Row_Receipt.BatchKey.ItemKey);
				Query.SetParameter("Bundle", Row_Expense.BatchKey.ItemKey);
				Query.SetParameter("Store", Row_Receipt.BatchKey.Store);
				
				QuerySelection = Query.Execute().Select();
				While QuerySelection.Next() Do
					NewRow.Amount = NewRow.Amount + (Row_Expense.Amount /100 * QuerySelection.AmountValue);
				EndDo;
			EndDo;
			
			NewRowReceivedBatch = TableOfNewReceivedBatches.Add();
			NewRowReceivedBatch.Batch = NewRow.Batch;
			NewRowReceivedBatch.BatchKey = NewRow.BatchKey;
			NewRowReceivedBatch.Document = NewRow.Document;
			NewRowReceivedBatch.Company = NewRow.Company;
			NewRowReceivedBatch.Date = NewRow.Period;
			NewRowReceivedBatch.Quantity = NewRow.Quantity;
			NewRowReceivedBatch.Amount = NewRow.Amount;
			NewRowReceivedBatch.QuantityBalance = NewRow.Quantity;
			NewRowReceivedBatch.AmountBalance = NewRow.Amount;
			NewRowReceivedBatch.IsOpeningBalance = False;
			NewRowReceivedBatch.Direction = Enums.LC_BatchDirection.Receipt;
						
		EndDo;
		
		For Each Row In TableOfNewReceivedBatches Do
			FillPropertyValues(Rows.Add(), Row);	
		EndDo;
		ArrayForDelete = New Array();
		For Each Row In Rows Do
			If Not ValueIsFilled(Row.AmountBalance) Then
				ArrayForDelete.Add(Row);
			EndIf;
		EndDo;
		For Each Row In ArrayForDelete Do
			Rows.Delete(Row);
		EndDo;
	EndIf;
EndProcedure

Function GetSalesBatches(SalesInvoice, DataForSalesBatches, ItemKey)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	DataForSalesBatches.Batch AS Batch,
	|	DataForSalesBatches.Period AS Date,
	|	DataForSalesBatches.BatchKey AS BatchKey,
	|	DataForSalesBatches.SalesInvoice AS SalesInvoice,
	|	DataForSalesBatches.Quantity AS Quantity,
	|	DataForSalesBatches.Amount AS Amount
	|INTO DataForSalesBatches
	|FROM
	|	&DataForSalesBatches AS DataForSalesBatches
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	LC_SalesBatchesTurnovers.Batch AS Batch,
	|	LC_SalesBatchesTurnovers.Period AS Date,
	|	LC_SalesBatchesTurnovers.BatchKey AS BatchKey,
	|	LC_SalesBatchesTurnovers.SalesInvoice AS SalesInvoice,
	|	LC_SalesBatchesTurnovers.QuantityTurnover AS Quantity,
	|	LC_SalesBatchesTurnovers.AmountTurnover AS Amount
	|INTO SalesBatches
	|FROM
	|	AccumulationRegister.LC_SalesBatches.Turnovers(
	|			,
	|			,
	|			Record,
	|			SalesInvoice = &SalesInvoice
	|				AND BatchKey.ItemKey = &BatchKey_ItemKey) AS LC_SalesBatchesTurnovers
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	DataForSalesBatches.Batch AS Batch,
	|	DataForSalesBatches.BatchKey AS BatchKey,
	|	DataForSalesBatches.SalesInvoice AS SalesInvoice,
	|	DataForSalesBatches.Quantity AS Quantity,
	|	DataForSalesBatches.Amount AS Amount,
	|	DataForSalesBatches.Date AS Date
	|INTO AllData
	|FROM
	|	DataForSalesBatches AS DataForSalesBatches
	|WHERE
	|	DataForSalesBatches.SalesInvoice = &SalesInvoice
	|	AND DataForSalesBatches.BatchKey.ItemKey = &BatchKey_ItemKey
	|
	|UNION ALL
	|
	|SELECT
	|	SalesBatches.Batch,
	|	SalesBatches.BatchKey,
	|	SalesBatches.SalesInvoice,
	|	SalesBatches.Quantity,
	|	SalesBatches.Amount,
	|	SalesBatches.Date
	|FROM
	|	SalesBatches AS SalesBatches
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AllData.Batch AS Batch,
	|	AllData.BatchKey AS BatchKey,
	|	AllData.SalesInvoice AS SalesInvoice,
	|	SUM(AllData.Quantity) AS Quantity,
	|	SUM(AllData.Amount) AS Amount,
	|	AllData.Batch.Document AS Document,
	|	AllData.Date AS Date,
	|	AllData.Batch.Company AS Company
	|FROM
	|	AllData AS AllData
	|
	|GROUP BY
	|	AllData.Batch,
	|	AllData.BatchKey,
	|	AllData.SalesInvoice,
	|	AllData.Batch.Document,
	|	AllData.Date
	|
	|ORDER BY
	|	Date";
	Query.SetParameter("SalesInvoice"        , SalesInvoice);
	Query.SetParameter("DataForSalesBatches" , DataForSalesBatches);
	Query.SetParameter("BatchKey_ItemKey"    , ItemKey);
	Table_SalesBatches = Query.Execute().Unload();
	Return Table_SalesBatches;
EndFunction

#EndRegion
