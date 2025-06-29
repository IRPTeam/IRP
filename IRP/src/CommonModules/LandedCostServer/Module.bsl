
Function GetArrayOfTransferDocument()
	ArrayOfTypes = New Array();
	ArrayOfTypes.Add(Type("DocumentRef.InventoryTransfer"));
	Return ArrayOfTypes;
EndFunction

Function IsTransferDocument(Document)
	ArrayOfTypes = GetArrayOfTransferDocument();
	If ArrayOfTypes.Find(TypeOf(Document)) <> Undefined Then
		Return True;
	EndIf;
	Return False;
EndFunction

Function GetArrayOfCompositeDocument()
	ArrayOfTypes = New Array();
	ArrayOfTypes.Add(Type("DocumentRef.Bundling"));
	ArrayOfTypes.Add(Type("DocumentRef.ItemStockAdjustment"));
	ArrayOfTypes.Add(Type("DocumentRef.Production"));
	Return ArrayOfTypes;
EndFunction

Function IsCompositeDocument(Document)
	ArrayOfTypes = GetArrayOfCompositeDocument();
	If ArrayOfTypes.Find(TypeOf(Document)) <> Undefined Then
		Return True;
	EndIf;
	Return False;
EndFunction

Function GetArrayOfDecompositeDocument()
	ArrayOfTypes = New Array();
	ArrayOfTypes.Add(Type("DocumentRef.Unbundling"));
	Return ArrayOfTypes;
EndFunction

Function IsDecompositeDocument(Document)
	ArrayOfTypes = GetArrayOfDecompositeDocument();
	If ArrayOfTypes.Find(TypeOf(Document)) <> Undefined Then
		Return True;
	EndIf;
	Return False;
EndFunction

Function GetArrayOfMultiDirectionDocument()
	ArrayOfTypes = New Array();
	ArrayOfTypes.Add(Type("DocumentRef.InventoryTransfer"));
	ArrayOfTypes.Add(Type("DocumentRef.Bundling"));
	ArrayOfTypes.Add(Type("DocumentRef.Unbundling"));
	ArrayOfTypes.Add(Type("DocumentRef.ItemStockAdjustment"));
	ArrayOfTypes.Add(Type("DocumentRef.Production"));
	Return ArrayOfTypes;
EndFunction

Function IsNotMultiDirectionDocument(Document)
	If TypeOf(Document) = Type("DocumentRef.OpeningEntry") Then
		If ValueIsFilled(Document.PartnerTradeAgent) Then
			Return False; // is multidirection
		Else
			Return True;
		EndIf;
	Else
		ArrayOfTypes = GetArrayOfMultiDirectionDocument();
		If ArrayOfTypes.Find(TypeOf(Document)) = Undefined Then
			Return True;
		EndIf;
	EndIf;
	Return False; // is multidirection
EndFunction

Function IsShipmentToTradeAgent(Document)
	If TypeOf(Document) = Type("DocumentRef.SalesInvoice")
		And Document.TransactionType = Enums.SalesTransactionTypes.ShipmentToTradeAgent Then
			Return True; // is shipment to trade agent
	EndIf;
	
	If TypeOf(Document) = Type("DocumentRef.OpeningEntry")
		And ValueIsFilled(Document.PartnerTradeAgent) Then
			Return True; // is shipment to trade agent
	EndIf;
	
	Return False; 
EndFunction

Function IsReturnFromTradeAgent(Document)
	If TypeOf(Document) = Type("DocumentRef.SalesReturn")
		And Document.TransactionType = Enums.SalesReturnTransactionTypes.ReturnFromTradeAgent Then
			Return True; // is shipment to trade agent
	EndIf;
	
	Return False; 
EndFunction


// all documents who can movie batches
Function GetArrayOfBatchDocumentTypes()
	ArrayOfTypes = New Array();
	ArrayOfTypes.Add(Type("DocumentRef.Bundling"));
	ArrayOfTypes.Add(Type("DocumentRef.InventoryTransfer"));
	ArrayOfTypes.Add(Type("DocumentRef.ItemStockAdjustment"));
	ArrayOfTypes.Add(Type("DocumentRef.OpeningEntry"));
	ArrayOfTypes.Add(Type("DocumentRef.PurchaseInvoice"));
	ArrayOfTypes.Add(Type("DocumentRef.PurchaseReturn"));
	ArrayOfTypes.Add(Type("DocumentRef.RetailSalesReceipt"));
	ArrayOfTypes.Add(Type("DocumentRef.RetailReturnReceipt"));
	ArrayOfTypes.Add(Type("DocumentRef.SalesInvoice"));
	ArrayOfTypes.Add(Type("DocumentRef.SalesReturn"));
	ArrayOfTypes.Add(Type("DocumentRef.StockAdjustmentAsSurplus"));
	ArrayOfTypes.Add(Type("DocumentRef.StockAdjustmentAsWriteOff"));
	ArrayOfTypes.Add(Type("DocumentRef.Unbundling"));
	ArrayOfTypes.Add(Type("DocumentRef.BatchReallocateIncoming"));
	ArrayOfTypes.Add(Type("DocumentRef.BatchReallocateOutgoing"));
	ArrayOfTypes.Add(Type("DocumentRef.WorkSheet"));
	ArrayOfTypes.Add(Type("DocumentRef.Production"));
	ArrayOfTypes.Add(Type("DocumentRef.SalesReportFromTradeAgent"));
	ArrayOfTypes.Add(Type("DocumentRef.CommissioningOfFixedAsset"));
	ArrayOfTypes.Add(Type("DocumentRef.ModernizationOfFixedAsset"));
	ArrayOfTypes.Add(Type("DocumentRef.DecommissioningOfFixedAsset"));
	ArrayOfTypes.Add(Type("DocumentRef.GoodsReceipt"));
	Return ArrayOfTypes;
EndFunction

Function GetBatchDocumentsTypes()
	ArrayOfTypes = GetArrayOfBatchDocumentTypes();
	Types = New TypeDescription(ArrayOfTypes);
	Return Types;
EndFunction

Procedure Posting_BatchWiseBalance(CalculationSettings, AddInfo = Undefined) Export
	LocksStorage = New Array();
	If Not TransactionActive() Then
		BeginTransaction(DataLockControlMode.Managed);
		Try
			BatchWiseBalance_DoRegistration(LocksStorage, CalculationSettings);
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
		BatchWiseBalance_DoRegistration(LocksStorage, CalculationSettings);
	EndIf;
EndProcedure

Procedure BatchWiseBalance_DoRegistration(LocksStorage, CalculationSettings)
	If CalculationSettings.CalculationMode = Enums.CalculationMode.LandedCost Then
		DoRegistration_CalculationMode_LandedCost(LocksStorage, CalculationSettings);
	ElsIf CalculationSettings.CalculationMode = Enums.CalculationMode.LandedCostBatchReallocate Then
		CalculationSettings.Company = Undefined;
		BatchReallocate(LocksStorage, CalculationSettings.CalculationMovementCostRef, CalculationSettings.EndPeriod);
		DoRegistration_CalculationMode_LandedCost(LocksStorage, CalculationSettings);
	EndIf;
EndProcedure

Procedure BatchReallocate(LocksStorage, BatchReallocateRef, EndPeriod)
	// Set lock for Document.BatchReallocateIncoming
	DataLock_BatchReallocateIncoming = New DataLock();
	ItemLock_BatchReallocateIncoming = DataLock_BatchReallocateIncoming.Add("Document.BatchReallocateIncoming");
	ItemLock_BatchReallocateIncoming.Mode = DataLockMode.Exclusive;
	DataLock_BatchReallocateIncoming.Lock();
	LocksStorage.Add(DataLock_BatchReallocateIncoming);
	
	// Set lock for Document.BatchReallocateOutgoing
	DataLock_BatchReallocateOutgoing = New DataLock();
	ItemLock_BatchReallocateOutgoing = DataLock_BatchReallocateOutgoing.Add("Document.BatchReallocateOutgoing");
	ItemLock_BatchReallocateOutgoing.Mode = DataLockMode.Exclusive;
	DataLock_BatchReallocateOutgoing.Lock();
	LocksStorage.Add(DataLock_BatchReallocateOutgoing);
	
	ReleaseBatchReallocateDocuments(BatchReallocateRef);

	// EmptyLackItemList
	MetadataR4050B = Metadata.AccumulationRegisters.R4050B_StockInventory;
	EmptyLackItemList = New ValueTable();
	EmptyLackItemList.Columns.Add("Store"    , MetadataR4050B.Dimensions.Store.Type);
	EmptyLackItemList.Columns.Add("ItemKey"  , MetadataR4050B.Dimensions.ItemKey.Type);
	EmptyLackItemList.Columns.Add("Quantity" , MetadataR4050B.Resources.Quantity.Type);
	
	// EmptyResultItemList
	MetadataR4050B = Metadata.AccumulationRegisters.R4050B_StockInventory;
	EmptyResultItemList = New ValueTable();
	EmptyResultItemList.Columns.Add("Store"           , MetadataR4050B.Dimensions.Store.Type);
	EmptyResultItemList.Columns.Add("ItemKey"         , MetadataR4050B.Dimensions.ItemKey.Type);
	EmptyResultItemList.Columns.Add("Quantity"        , MetadataR4050B.Resources.Quantity.Type);
	EmptyResultItemList.Columns.Add("CompanySender"   , MetadataR4050B.Dimensions.Company.Type);
	EmptyResultItemList.Columns.Add("CompanyReceiver" , MetadataR4050B.Dimensions.Company.Type);
	
	ProcessedRecorders = New Array();
	LackOfBatches = True;
	While LackOfBatches Do

		NegativeStockBalanceSelection = GetNegativeStockBalance(ProcessedRecorders, EndPeriod);
		If Not NegativeStockBalanceSelection.Next() Then
			LackOfBatches = False;
			Break;
		EndIf;
		ProcessedRecorders.Add(NegativeStockBalanceSelection.Recorder);

		LackItemList = EmptyLackItemList.CopyColumns();
		ItemListSelection = NegativeStockBalanceSelection.Select();
		While ItemListSelection.Next() Do
			NewRow = LackItemList.Add();
			NewRow.Store    = ItemListSelection.Store;
			NewRow.ItemKey  = ItemListSelection.ItemKey;
			NewRow.Quantity = ItemListSelection.Quantity;
		EndDo;

		LackItemList.GroupBy("Store, ItemKey", "Quantity");

		ReallocatePeriod = NegativeStockBalanceSelection.Period - 2;

		PositiveStockBalance = GetPositiveStockBalance(NegativeStockBalanceSelection.Company, ReallocatePeriod, LackItemList);

		ResultItemList = EmptyResultItemList.CopyColumns();
		IsQuantityEnough = True;
		For Each LackRow In LackItemList Do

			LackQuantity = LackRow.Quantity;
			Filter = New Structure("Store, ItemKey", LackRow.Store, LackRow.ItemKey);
			FilteredRows = PositiveStockBalance.FindRows(Filter);

			For Each Row In FilteredRows Do
				If LackQuantity = 0 Then
					Break;
				EndIf;
				ReallocateQuantity = Min(LackQuantity, Row.QuantityBalance);
				Row.QuantityBalance = Row.QuantityBalance - ReallocateQuantity;
				LackQuantity = LackQuantity - ReallocateQuantity;

				NewRow = ResultItemList.Add();
				NewRow.CompanyReceiver = NegativeStockBalanceSelection.Company;
				NewRow.CompanySender   = Row.Company;
				NewRow.Store   = Row.Store;
				NewRow.ItemKey = Row.ItemKey;
				NewRow.Quantity = ReallocateQuantity;
			EndDo;

			If LackQuantity <> 0 Then
				IsQuantityEnough = False;
				Break;
			EndIf;
		EndDo;

		If Not IsQuantityEnough Then
			Continue;
		EndIf;

		ResultItemListCopy = ResultItemList.Copy();
		ResultItemListCopy.GroupBy("CompanyReceiver, CompanySender");

		For Each Row In ResultItemListCopy Do
			// outgoing reallocate
			OutgoingDoc = GetReleasedBatchReallocateDocument("BatchReallocateOutgoing", BatchReallocateRef, ReallocatePeriod);
			OutgoingDoc.Document = NegativeStockBalanceSelection.Recorder;
			OutgoingDoc.Company  = Row.CompanySender;
			
			// incoming reallocate
			IncomingDoc = GetReleasedBatchReallocateDocument("BatchReallocateIncoming", BatchReallocateRef, ReallocatePeriod + 1);
			IncomingDoc.Document = NegativeStockBalanceSelection.Recorder;
			IncomingDoc.Company  = Row.CompanyReceiver;

			Filter = New Structure("CompanyReceiver, CompanySender", Row.CompanyReceiver, Row.CompanySender);
			FilteredRows = ResultItemList.FindRows(Filter);
			For Each FilteredRow In FilteredRows Do
				// outgoing item list
				NewRowOutgoing = OutgoingDoc.ItemList.Add();
				NewRowOutgoing.ItemKey  = FilteredRow.ItemKey;
				NewRowOutgoing.Store    = FilteredRow.Store;
				NewRowOutgoing.Quantity = FilteredRow.Quantity;
				
				// incoming item list
				NewRowIncoming = IncomingDoc.ItemList.Add();
				NewRowIncoming.ItemKey  = FilteredRow.ItemKey;
				NewRowIncoming.Store    = FilteredRow.Store;
				NewRowIncoming.Quantity = FilteredRow.Quantity;
			EndDo;

			OutgoingDoc.Incoming = IncomingDoc.Ref;
			IncomingDoc.Outgoing = OutgoingDoc.Ref;

			OutgoingDoc.Write(DocumentWriteMode.Posting);
			IncomingDoc.Write(DocumentWriteMode.Posting);
		EndDo;
	EndDo;
EndProcedure

Procedure ReleaseBatchReallocateDocuments(BatchReallocateRef) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	BatchReallocateIncoming.Ref
	|FROM
	|	Document.BatchReallocateIncoming AS BatchReallocateIncoming
	|WHERE
	|	NOT BatchReallocateIncoming.DeletionMark
	|	AND BatchReallocateIncoming.BatchReallocate = &BatchReallocate
	|
	|UNION ALL
	|
	|SELECT
	|	BatchReallocateOutgoing.Ref
	|FROM
	|	Document.BatchReallocateOutgoing AS BatchReallocateOutgoing
	|WHERE
	|	NOT BatchReallocateOutgoing.DeletionMark
	|	AND BatchReallocateOutgoing.BatchReallocate = &BatchReallocate";
	Query.SetParameter("BatchReallocate", BatchReallocateRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		DocRef = QuerySelection.Ref; 
		DocObject = DocRef.GetObject();
		DocObject.ItemList.Clear();
		DocObject.BatchReallocate = Undefined;
		DocObject.Company         = Catalogs.Companies.EmptyRef();
		DocObject.Document        = Undefined;
		If TypeOf(DocObject) = Type("DocumentObject.BatchReallocateIncoming") Then
			DocObject.Outgoing = Undefined;
		EndIf;
		If TypeOf(DocObject) = Type("DocumentObject.BatchReallocateOutgoing") Then
			DocObject.Incoming = Undefined;
		EndIf;
		DocObject.Write(DocumentWriteMode.UndoPosting);
	EndDo;
EndProcedure

Function GetReleasedBatchReallocateDocument(DocumentName, BatchReallocateRef, ReallocatePeriod)
	Query = New Query();
	Query.Text =
	"SELECT TOP 1
	|	Table.Ref
	|FROM
	|	Document.%1 AS Table
	|WHERE
	|	NOT Table.DeletionMark
	|	AND Table.BatchReallocate.Ref IS NULL";
	Query.Text = StrTemplate(Query.Text, DocumentName);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Ref = QuerySelection.Ref;
		DocumentObject = Ref.GetObject();
	Else
		DocumentObject = Documents[DocumentName].CreateDocument();
	EndIf;
	DocumentObject.Date = ReallocatePeriod;
	DocumentObject.BatchReallocate = BatchReallocateRef;
	DocumentObject.Write();
	Return DocumentObject.Ref.GetObject();
EndFunction

Function GetNegativeStockBalance(ProcessedRecorders, EndPeriod)
	Query = New Query();
	Query.Text =
	"SELECT
	|	R4050B.Period AS Period,
	|	R4050B.Recorder AS Recorder,
	|	R4050B.Company AS Company,
	|	R4050B.Store AS Store,
	|	R4050B.ItemKey AS ItemKey,
	|	-R4050B.QuantityClosingBalance AS Quantity
	|FROM
	|	AccumulationRegister.R4050B_StockInventory.BalanceAndTurnovers(, ENDOFPERIOD(&EndPeriod, DAY), Recorder,
	|		RegisterRecords,) AS R4050B
	|WHERE
	|	R4050B.QuantityClosingBalance < 0
	|	AND NOT R4050B.Recorder IN (&ProcessedRecorders)
	|
	|ORDER BY
	|	R4050B.Recorder.PointInTime
	|TOTALS
	|	MAX(Period),
	|	MAX(Company)
	|BY
	|	Recorder";
	Query.SetParameter("EndPeriod", EndPeriod);
	Query.SetParameter("ProcessedRecorders", ProcessedRecorders);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select(QueryResultIteration.ByGroups);
	Return QuerySelection;
EndFunction

Function GetPositiveStockBalance(Company, Period, ItemList)
	Query = New Query();
	Query.Text =
	"SELECT
	|	tmp.Store,
	|	tmp.ItemKey,
	|	tmp.Quantity
	|INTO tmp
	|FROM
	|	&ItemList AS tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R4050B.Company,
	|	tmp.Store,
	|	tmp.ItemKey,
	|	tmp.Quantity,
	|	ISNULL(R4050B.QuantityBalance, 0) AS QuantityBalance
	|FROM
	|	tmp AS tmp
	|		LEFT JOIN AccumulationRegister.R4050B_StockInventory.Balance(&Period, Company <> &Company
	|		AND (Store, ItemKey) IN
	|			(SELECT
	|				tmp.Store,
	|				tmp.ItemKey
	|			FROM
	|				tmp AS tmp)) AS R4050B
	|		ON tmp.Store = R4050B.Store
	|		AND tmp.ItemKey = R4050B.ItemKey";
	Query.SetParameter("Period", Period);
	Query.SetParameter("Company", Company);
	Query.SetParameter("ItemList", ItemList);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

Procedure DoRegistration_CalculationMode_LandedCost(LocksStorage, CalculationSettings)
	// Set lock for table Catalog.Batches
	DataLock_Batches = New DataLock();
	ItemLock_Batches = DataLock_Batches.Add("Catalog.Batches");
	ItemLock_Batches.Mode = DataLockMode.Exclusive;
	DataLock_Batches.Lock();
	LocksStorage.Add(DataLock_Batches);
	
	// Set lock for table Catalog.BatchKeys
	DataLock_BatchKeys = New DataLock();
	ItemLock_BatchKeys = DataLock_Batches.Add("Catalog.BatchKeys");
	ItemLock_BatchKeys.Mode = DataLockMode.Exclusive;
	DataLock_BatchKeys.Lock();
	LocksStorage.Add(DataLock_BatchKeys);

	Catalogs.Batches.Create_Batches(CalculationSettings);
	Catalogs.BatchKeys.Create_BatchKeys(CalculationSettings);

	BatchWiseBalanceTables = GetBatchWiseBalance(CalculationSettings);

	RecordSetR6010B = AccumulationRegisters.R6010B_BatchWiseBalance.CreateRecordSet();
	RecordSetR6010B.Filter.Recorder.Set(CalculationSettings.CalculationMovementCostRef);

	// Batch wise balance
	For Each Row In BatchWiseBalanceTables.DataForReceipt Do
		NewRecordReceipt = RecordSetR6010B.Add();
		FillPropertyValues(NewRecordReceipt, Row);
		NewRecordReceipt.Period = Row.Period;
		NewRecordReceipt.RecordType = AccumulationRecordType.Receipt;
		NewRecordReceipt.Recorder = CalculationSettings.CalculationMovementCostRef;
	EndDo;
	For Each Row In BatchWiseBalanceTables.DataForExpense Do
		NewRecordR6010B = RecordSetR6010B.Add();
		FillPropertyValues(NewRecordR6010B, Row);
		NewRecordR6010B.Period = Row.Period;
		NewRecordR6010B.RecordType = AccumulationRecordType.Expense;
		NewRecordR6010B.Recorder = CalculationSettings.CalculationMovementCostRef;
	EndDo;

	RecordSetR6010B.Write();
	
	// Batch shortage outgoing
	RecordSetR6030T = AccumulationRegisters.R6030T_BatchShortageOutgoing.CreateRecordSet();
	RecordSetR6030T.Filter.Recorder.Set(CalculationSettings.CalculationMovementCostRef);

	For Each Row In BatchWiseBalanceTables.DataForBatchShortageOutgoing Do
		NewRecordR6030T = RecordSetR6030T.Add();
		FillPropertyValues(NewRecordR6030T, Row);
		NewRecordR6030T.Period = Row.Period;
		NewRecordR6030T.Recorder = CalculationSettings.CalculationMovementCostRef;
	EndDo;

	RecordSetR6030T.Write();
	
	// Batch shortage incoming
	RecordSetR6040T = AccumulationRegisters.R6040T_BatchShortageIncoming.CreateRecordSet();
	RecordSetR6040T.Filter.Recorder.Set(CalculationSettings.CalculationMovementCostRef);

	For Each Row In BatchWiseBalanceTables.DataForBatchShortageIncoming Do
		NewRecordR6040T = RecordSetR6040T.Add();
		FillPropertyValues(NewRecordR6040T, Row);
		NewRecordR6040T.Period = Row.Period;
		NewRecordR6040T.Recorder = CalculationSettings.CalculationMovementCostRef;
	EndDo;

	RecordSetR6040T.Write();
	
	// Sales batches
	RecordSetR6050T = AccumulationRegisters.R6050T_SalesBatches.CreateRecordSet();
	RecordSetR6050T.Filter.Recorder.Set(CalculationSettings.CalculationMovementCostRef);

	For Each Row In BatchWiseBalanceTables.DataForSalesBatches Do
		NewRecordR6050T = RecordSetR6050T.Add();
		FillPropertyValues(NewRecordR6050T, Row);
		NewRecordR6050T.Period = Row.Period;
		NewRecordR6050T.Recorder = CalculationSettings.CalculationMovementCostRef;
	EndDo;

	RecordSetR6050T.Write();
	
	// Bundle amount values
	RecordSetT6040S = InformationRegisters.T6040S_BundleAmountValues.CreateRecordSet();
	RecordSetT6040S.Filter.Recorder.Set(CalculationSettings.CalculationMovementCostRef);
	BatchWiseBalanceTables.DataForBundleAmountValues.GroupBy(
	"Company, Period, Batch, BatchKey, BatchKeyBundle",
	"InvoiceAmount, InvoiceTaxAmount, 
	|ExtraCostAmountByRatio, ExtraCostTaxAmountByRatio,
	|ExtraDirectCostAmount, ExtraDirectCostTaxAmount,
	|IndirectCostAmount, IndirectCostTaxAmount,
	|AllocatedCostAmount, AllocatedCostTaxAmount, 
	|AllocatedRevenueAmount, AllocatedRevenueTaxAmount");

	For Each Row In BatchWiseBalanceTables.DataForBundleAmountValues Do
		NewRecordT6040S = RecordSetT6040S.Add();
		FillPropertyValues(NewRecordT6040S, Row);
		NewRecordT6040S.Period = Row.Period;
		NewRecordT6040S.Recorder = CalculationSettings.CalculationMovementCostRef;
	EndDo;

	RecordSetT6040S.Write();
	
	// Composite amount values
	RecordSetT6090S = InformationRegisters.T6090S_CompositeBatchesAmountValues.CreateRecordSet();
	RecordSetT6090S.Filter.Recorder.Set(CalculationSettings.CalculationMovementCostRef);
	BatchWiseBalanceTables.DataForCompositeBatchesAmountValues.GroupBy(
	"Company, Period, Batch, BatchKey, BatchComposite, BatchKeyComposite",
	"InvoiceAmount, InvoiceTaxAmount, 
	|ExtraCostAmountByRatio, ExtraCostTaxAmountByRatio,
	|ExtraDirectCostAmount, ExtraDirectCostTaxAmount,
	|IndirectCostAmount, IndirectCostTaxAmount,
	|Quantity, 
	|AllocatedCostAmount, AllocatedCostTaxAmount, 
	|AllocatedRevenueAmount, AllocatedRevenueTaxAmount");

	For Each Row In BatchWiseBalanceTables.DataForCompositeBatchesAmountValues Do
		NewRecordT6090S = RecordSetT6090S.Add();
		FillPropertyValues(NewRecordT6090S, Row);
		NewRecordT6090S.Period = Row.Period;
		NewRecordT6090S.Recorder = CalculationSettings.CalculationMovementCostRef;
	EndDo;

	RecordSetT6090S.Write();
	
	// Reallocated amount values
	RecordSetT6080S = InformationRegisters.T6080S_ReallocatedBatchesAmountValues.CreateRecordSet();
	RecordSetT6080S.Filter.Recorder.Set(CalculationSettings.CalculationMovementCostRef);
	BatchWiseBalanceTables.DataForReallocatedBatchesAmountValues.GroupBy(
	"Period, OutgoingDocument, IncomingDocument, BatchKey",
	"InvoiceAmount, InvoiceTaxAmount, 
	|ExtraCostAmountByRatio, ExtraCostTaxAmountByRatio,
	|ExtraDirectCostAmount, ExtraDirectCostTaxAmount,
	|IndirectCostAmount, IndirectCostTaxAmount,
	|Quantity, 
	|AllocatedCostAmount, AllocatedCostTaxAmount, 
	|AllocatedRevenueAmount, AllocatedRevenueTaxAmount");

	For Each Row In BatchWiseBalanceTables.DataForReallocatedBatchesAmountValues Do
		NewRecordT6080S = RecordSetT6080S.Add();
		FillPropertyValues(NewRecordT6080S, Row);
		NewRecordT6080S.Period = Row.Period;
		NewRecordT6080S.Recorder = CalculationSettings.CalculationMovementCostRef;
	EndDo;

	RecordSetT6080S.Write();
	
	// Write-off batches
	RecordSet = InformationRegisters.T6095S_WriteOffBatchesInfo.CreateRecordSet();
	RecordSet.Filter.Recorder.Set(CalculationSettings.CalculationMovementCostRef);
	BatchWiseBalanceTables.DataForWriteOffBatches.GroupBy(
	"Period, Document, Company, Branch, ProfitLossCenter, ExpenseType, ItemKey, Currency, RowID",
	"InvoiceAmount, InvoiceTaxAmount, 
	|ExtraCostAmountByRatio, ExtraCostTaxAmountByRatio,
	|ExtraDirectCostAmount, ExtraDirectCostTaxAmount,
	|IndirectCostAmount, IndirectCostTaxAmount,
	|AllocatedCostAmount, AllocatedCostTaxAmount, 
	|AllocatedRevenueAmount, AllocatedRevenueTaxAmount");

	For Each Row In BatchWiseBalanceTables.DataForWriteOffBatches Do
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Period = Row.Period;
		NewRecord.Recorder = CalculationSettings.CalculationMovementCostRef;
	EndDo;

	RecordSet.Write();
	
	// Fixed assets
	RecordSet = InformationRegisters.T8510S_FixedAssetsInfo.CreateRecordSet();
	RecordSet.Filter.Recorder.Set(CalculationSettings.CalculationMovementCostRef);
	
	_DataForFixedAssets = BatchWiseBalanceTables.DataForFixedAssets.Copy();
	_DataForFixedAssets.Columns.Add("Amount");
	_DataForFixedAssets.Columns.Add("Currency");
	
	ArrayOfFixedAssets = New Array();
	_Currency = CurrenciesServer.GetLandedCostCurrency(CalculationSettings.Company);
	
	For Each Row In _DataForFixedAssets Do
		Row.Amount = 
			Row.InvoiceAmount
			+ Row.IndirectCostAmount
			+ Row.ExtraCostAmountByRatio
			+ Row.ExtraDirectCostAmount
			+ Row.AllocatedCostAmount
			+ Row.AllocatedRevenueAmount;
		
		Row.Currency = _Currency;
		
		If ArrayOfFixedAssets.Find(Row.FixedAsset) = Undefined Then
			ArrayOfFixedAssets.Add(Row.FixedAsset);
		EndIf;
	EndDo;
	
	_DataForFixedAssets.GroupBy("Period, Document, Company, Branch, ProfitLossCenter, FixedAsset, LedgerType, Schedule, Currency", 
		"Amount");
	
	_DataForFixedAssetsByLedgerTypes = _DataForFixedAssets.CopyColumns();
	
	For Each FixedAsset In ArrayOfFixedAssets Do
		_DataForFixedAssetsRows = _DataForFixedAssets.FindRows(New Structure("FixedAsset", FixedAsset));
		For Each Row In _DataForFixedAssetsRows Do
			For Each RowDepreciationInfo In FixedAsset.DepreciationInfo Do
				NewRow = _DataForFixedAssetsByLedgerTypes.Add();
				FillPropertyValues(NewRow, Row);
				NewRow.LedgerType = RowDepreciationInfo.LedgerType;
				NewRow.Schedule   = RowDepreciationInfo.Schedule;
			EndDo;
		EndDo; 
	EndDo;
	
	For Each Row In _DataForFixedAssetsByLedgerTypes Do
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Period = Row.Period;
		NewRecord.Recorder = CalculationSettings.CalculationMovementCostRef;
	EndDo;

	RecordSet.Write();
		
	// Batch balance
	AccumulationRegisters.R6020B_BatchBalance.BatchBalance_LoadRecords(CalculationSettings.CalculationMovementCostRef);
	
	// Cost of goods sold
	AccumulationRegisters.R6060T_CostOfGoodsSold.CostOfGoodsSold_LoadRecords(CalculationSettings.CalculationMovementCostRef);
	
	// Expenses
	AccumulationRegisters.R5022T_Expenses.Expenses_LoadRecords(CalculationSettings.CalculationMovementCostRef);
	
	// Book value of fixed assets
	AccumulationRegisters.R8510B_BookValueOfFixedAsset.BookValueOfFixedAsset_LoadRecords(CalculationSettings.CalculationMovementCostRef);
	
	// Cost of fixed asset
	AccumulationRegisters.R8515T_CostOfFixedAsset.CostOfFixedAsset_LoadRecords(CalculationSettings.CalculationMovementCostRef);
	
	// Relevance
	InformationRegisters.T6030S_BatchRelevance.BatchRelevance_Clear(CalculationSettings.Company, CalculationSettings.EndPeriod);
	InformationRegisters.T6030S_BatchRelevance.BatchRelevance_Restore(CalculationSettings.Company, CalculationSettings.EndPeriod);	
EndProcedure

Function AmountResources()
	Resources = New Array();
	Resources.Add("InvoiceAmount");
	Resources.Add("InvoiceTaxAmount");
	Resources.Add("IndirectCostAmount");
	Resources.Add("IndirectCostTaxAmount");
	Resources.Add("ExtraCostAmountByRatio");
	Resources.Add("ExtraCostTaxAmountByRatio");
	Resources.Add("ExtraDirectCostAmount");
	Resources.Add("ExtraDirectCostTaxAmount");
	Resources.Add("AllocatedCostAmount");
	Resources.Add("AllocatedCostTaxAmount");
	Resources.Add("AllocatedRevenueAmount");
	Resources.Add("AllocatedRevenueTaxAmount");
	Resources.Add("PreliminaryAmount");
	Resources.Add("PreliminaryTaxAmount");
	Return Resources;
EndFunction

Function GetBatchWiseBalance(CalculationSettings)

	// EmptyTable_BatchWiseBalance
	RegMetadata = Metadata.AccumulationRegisters.R6010B_BatchWiseBalance;
	EmptyTable_BatchWiseBalance = New ValueTable();
	EmptyTable_BatchWiseBalance.Columns.Add("Batch"     , New TypeDescription("CatalogRef.Batches"));
	EmptyTable_BatchWiseBalance.Columns.Add("BatchKey"  , New TypeDescription("CatalogRef.BatchKeys"));
	EmptyTable_BatchWiseBalance.Columns.Add("Document"  , GetBatchDocumentsTypes());
	EmptyTable_BatchWiseBalance.Columns.Add("Company"   , New TypeDescription("CatalogRef.Companies"));
	EmptyTable_BatchWiseBalance.Columns.Add("Period"    , RegMetadata.StandardAttributes.Period.Type);
	EmptyTable_BatchWiseBalance.Columns.Add("IsPreliminary" , New TypeDescription("Boolean"));
	EmptyTable_BatchWiseBalance.Columns.Add("Quantity", RegMetadata.Resources.Quantity.Type);
	EmptyTable_BatchWiseBalance.Columns.Add("PreliminaryQuantity", RegMetadata.Resources.Quantity.Type);

	For Each Res In AmountResources() Do
		EmptyTable_BatchWiseBalance.Columns.Add(Res, Metadata.DefinedTypes.typeAmount.Type);
	EndDo;

	Tables = New Structure();
	Tables.Insert("DataForExpense"               , EmptyTable_BatchWiseBalance.CopyColumns());
	Tables.Insert("DataForReceipt"               , EmptyTable_BatchWiseBalance.CopyColumns());
	Tables.Insert("DataForBatchShortageOutgoing" , EmptyTable_BatchWiseBalance.CopyColumns());
	Tables.Insert("DataForBatchShortageIncoming" , EmptyTable_BatchWiseBalance.CopyColumns());
	Tables.Insert("DataForSalesBatches"          , EmptyTable_BatchWiseBalance.CopyColumns());

	ArrayOfTypes_SalesInvoice = New Array();
	ArrayOfTypes_SalesInvoice.Add(Type("DocumentRef.SalesInvoice"));
	ArrayOfTypes_SalesInvoice.Add(Type("DocumentRef.RetailSalesReceipt"));
	Tables.DataForSalesBatches.Columns.Add("SalesInvoice", New TypeDescription(ArrayOfTypes_SalesInvoice));

	// DataForBundleAmountValues
	RegMetadata = Metadata.InformationRegisters.T6040S_BundleAmountValues;
	DataForBundleAmountValues = New ValueTable();
	DataForBundleAmountValues.Columns.Add("Period"         , RegMetadata.StandardAttributes.Period.Type);
	DataForBundleAmountValues.Columns.Add("Company"        , RegMetadata.Dimensions.Company.Type);
	DataForBundleAmountValues.Columns.Add("Batch"          , RegMetadata.Dimensions.Batch.Type);
	DataForBundleAmountValues.Columns.Add("BatchKey"       , RegMetadata.Dimensions.BatchKey.Type);
	DataForBundleAmountValues.Columns.Add("BatchKeyBundle" , RegMetadata.Dimensions.BatchKeyBundle.Type);
	
	For Each Res In AmountResources() Do
		DataForBundleAmountValues.Columns.Add(Res, Metadata.DefinedTypes.typeAmount.Type);
	EndDo;	
	
	Tables.Insert("DataForBundleAmountValues", DataForBundleAmountValues);
	
	// DataForCompositeBatchesAmountValues
	RegMetadata = Metadata.InformationRegisters.T6090S_CompositeBatchesAmountValues;
	DataForCompositeBatchesAmountValues = New ValueTable();
	DataForCompositeBatchesAmountValues.Columns.Add("Period"            , RegMetadata.StandardAttributes.Period.Type);
	DataForCompositeBatchesAmountValues.Columns.Add("Company"           , RegMetadata.Dimensions.Company.Type);
	DataForCompositeBatchesAmountValues.Columns.Add("Batch"             , RegMetadata.Dimensions.Batch.Type);
	DataForCompositeBatchesAmountValues.Columns.Add("BatchKey"          , RegMetadata.Dimensions.BatchKey.Type);
	DataForCompositeBatchesAmountValues.Columns.Add("BatchComposite"    , RegMetadata.Dimensions.BatchComposite.Type);
	DataForCompositeBatchesAmountValues.Columns.Add("BatchKeyComposite" , RegMetadata.Dimensions.BatchKeyComposite.Type);
	DataForCompositeBatchesAmountValues.Columns.Add("Quantity"          , RegMetadata.Resources.Quantity.Type);
	DataForCompositeBatchesAmountValues.Columns.Add("PreliminaryQuantity", RegMetadata.Resources.Quantity.Type);
	
	For Each Res In AmountResources() Do
		DataForCompositeBatchesAmountValues.Columns.Add(Res, Metadata.DefinedTypes.typeAmount.Type);
	EndDo;

	Tables.Insert("DataForCompositeBatchesAmountValues", DataForCompositeBatchesAmountValues);
	
	// DataForReallocatedBatchesAmountValues
	RegMetadata = Metadata.InformationRegisters.T6080S_ReallocatedBatchesAmountValues;
	DataForReallocatedBatchesAmountValues = New ValueTable();
	DataForReallocatedBatchesAmountValues.Columns.Add("Period"           , RegMetadata.StandardAttributes.Period.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("OutgoingDocument" , RegMetadata.Dimensions.OutgoingDocument.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("IncomingDocument" , RegMetadata.Dimensions.IncomingDocument.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("BatchKey"         , RegMetadata.Dimensions.BatchKey.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("Quantity"         , RegMetadata.Resources.Quantity.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("PreliminaryQuantity"         , RegMetadata.Resources.Quantity.Type);
	
	For Each Res In AmountResources() Do
		DataForReallocatedBatchesAmountValues.Columns.Add(Res, Metadata.DefinedTypes.typeAmount.Type);
	EndDo;

	Tables.Insert("DataForReallocatedBatchesAmountValues", DataForReallocatedBatchesAmountValues);
	
	// DataForWriteOffBatches
	RegMetadata = Metadata.InformationRegisters.T6095S_WriteOffBatchesInfo;
	DataForWriteOffBatches = New ValueTable();
	DataForWriteOffBatches.Columns.Add("Period"           , RegMetadata.StandardAttributes.Period.Type);
	DataForWriteOffBatches.Columns.Add("Document"         , RegMetadata.Dimensions.Document.Type);
	DataForWriteOffBatches.Columns.Add("Company"          , RegMetadata.Dimensions.Company.Type);
	DataForWriteOffBatches.Columns.Add("Branch"           , RegMetadata.Dimensions.Branch.Type);
	DataForWriteOffBatches.Columns.Add("ProfitLossCenter" , RegMetadata.Dimensions.ProfitLossCenter.Type);
	DataForWriteOffBatches.Columns.Add("ExpenseType"      , RegMetadata.Dimensions.ExpenseType.Type);
	DataForWriteOffBatches.Columns.Add("ItemKey"          , RegMetadata.Dimensions.ItemKey.Type);
	DataForWriteOffBatches.Columns.Add("Currency"         , RegMetadata.Dimensions.Currency.Type);
	DataForWriteOffBatches.Columns.Add("RowID"            , RegMetadata.Dimensions.RowID.Type);
	
	For Each Res In AmountResources() Do
		DataForWriteOffBatches.Columns.Add(Res, Metadata.DefinedTypes.typeAmount.Type);
	EndDo;
	
	Tables.Insert("DataForWriteOffBatches", DataForWriteOffBatches);
	
	// DataForFixedAssets
	RegMetadata = Metadata.InformationRegisters.T8510S_FixedAssetsInfo;
	DataForFixedAssets = New ValueTable();
	DataForFixedAssets.Columns.Add("Period"           , RegMetadata.StandardAttributes.Period.Type);
	DataForFixedAssets.Columns.Add("Document"         , RegMetadata.Dimensions.Document.Type);
	DataForFixedAssets.Columns.Add("Company"          , RegMetadata.Dimensions.Company.Type);
	DataForFixedAssets.Columns.Add("Branch"           , RegMetadata.Dimensions.Branch.Type);
	DataForFixedAssets.Columns.Add("ProfitLossCenter" , RegMetadata.Dimensions.ProfitLossCenter.Type);
	DataForFixedAssets.Columns.Add("FixedAsset"       , RegMetadata.Dimensions.FixedAsset.Type);
	DataForFixedAssets.Columns.Add("LedgerType"       , RegMetadata.Dimensions.LedgerType.Type);
	DataForFixedAssets.Columns.Add("Schedule"         , RegMetadata.Dimensions.Schedule.Type);

	For Each Res In AmountResources() Do
		DataForFixedAssets.Columns.Add(Res, Metadata.DefinedTypes.typeAmount.Type);
	EndDo;

	Tables.Insert("DataForFixedAssets", DataForFixedAssets);
	
	//TableOfReturnedBatches
	RegMetadata = Metadata.InformationRegisters.T6020S_BatchKeysInfo;
	TableOfReturnedBatches = New ValueTable();
	TableOfReturnedBatches.Columns.Add("Document"         , GetBatchDocumentsTypes());
	TableOfReturnedBatches.Columns.Add("Date"             , RegMetadata.StandardAttributes.Period.Type);
	TableOfReturnedBatches.Columns.Add("Company"          , RegMetadata.Dimensions.Company.Type);
	TableOfReturnedBatches.Columns.Add("Direction"        , RegMetadata.Dimensions.Direction.Type);
	TableOfReturnedBatches.Columns.Add("Batch"            , New TypeDescription("CatalogRef.Batches"));
	TableOfReturnedBatches.Columns.Add("QuantityBalance"  , RegMetadata.Resources.Quantity.Type);
	TableOfReturnedBatches.Columns.Add("IsOpeningBalance" , New TypeDescription("Boolean"));
	TableOfReturnedBatches.Columns.Add("Skip"             , New TypeDescription("Boolean"));
	TableOfReturnedBatches.Columns.Add("Priority"         , New TypeDescription("Number"));
	TableOfReturnedBatches.Columns.Add("BatchKey"         , New TypeDescription("CatalogRef.BatchKeys"));
	TableOfReturnedBatches.Columns.Add("IsPreliminary"    , New TypeDescription("Boolean"));
	TableOfReturnedBatches.Columns.Add("Quantity"         , RegMetadata.Resources.Quantity.Type);
	TableOfReturnedBatches.Columns.Add("PreliminaryQuantity", RegMetadata.Resources.Quantity.Type);

	TableOfReturnedBatches.Columns.Add("BatchDocument"    , RegMetadata.Dimensions.BatchDocument.Type);
	TableOfReturnedBatches.Columns.Add("SalesInvoice"     , RegMetadata.Dimensions.SalesInvoice.Type); 
	TableOfReturnedBatches.Columns.Add("AlreadyReceived"  , New TypeDescription("Boolean"));

	For Each Res In AmountResources() Do
		TableOfReturnedBatches.Columns.Add(Res, Metadata.DefinedTypes.typeAmount.Type);
		TableOfReturnedBatches.Columns.Add(Res + "Balance", Metadata.DefinedTypes.typeAmount.Type);
	EndDo;

	tmp_manager = New TempTablesManager();
	Tree = GetBatchTree(tmp_manager, CalculationSettings);
	
	For Each Row In Tree.Rows Do
		CalculateBatch(Row.Document, Row.Rows, Tables, Tree, TableOfReturnedBatches, EmptyTable_BatchWiseBalance, CalculationSettings);
		If TableOfReturnedBatches.Count() Then
			For Each RowReturnedBatches In TableOfReturnedBatches Do  
				If RowReturnedBatches.AlreadyReceived = True Then
					Continue;
				EndIf;
				ArrayOfTreeRows = Tree.Rows.FindRows(New Structure("Document", RowReturnedBatches.Document));
                If Not ArrayOfTreeRows.Count() Then
                	Raise R().BatchForSalesReturnNotFound;
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

Function GetBatchTree(TempTablesManager, CalculationSettings)
	Query = New Query();
	Query.TempTablesManager = TempTablesManager;
	Query.Text =
	"SELECT
	|	SUM(T6020S_BatchKeysInfo.Quantity) AS Quantity,
	|	SUM(T6020S_BatchKeysInfo.InvoiceAmount) AS InvoiceAmount,
	|	SUM(T6020S_BatchKeysInfo.InvoiceTaxAmount) AS InvoiceTaxAmount,
	|	SUM(T6020S_BatchKeysInfo.ExtraCostAmountByRatio) AS ExtraCostAmountByRatio,
	|	SUM(T6020S_BatchKeysInfo.ExtraCostTaxAmountByRatio) AS ExtraCostTaxAmountByRatio,
	|	SUM(T6020S_BatchKeysInfo.ExtraDirectCostAmount) AS ExtraDirectCostAmount,
	|	SUM(T6020S_BatchKeysInfo.ExtraDirectCostTaxAmount) AS ExtraDirectCostTaxAmount,
	|	sum(T6020S_BatchKeysInfo.IndirectCostAmount) AS IndirectCostAmount,
	|	sum(T6020S_BatchKeysInfo.IndirectCostTaxAmount) AS IndirectCostTaxAmount,
	|	sum(T6020S_BatchKeysInfo.AllocatedCostAmount) AS AllocatedCostAmount,
	|	sum(T6020S_BatchKeysInfo.AllocatedCostTaxAmount) AS AllocatedCostTaxAmount,
	|	sum(T6020S_BatchKeysInfo.AllocatedRevenueAmount) AS AllocatedRevenueAmount,
	|	sum(T6020S_BatchKeysInfo.AllocatedRevenueTaxAmount) AS AllocatedRevenueTaxAmount,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.ProductionCostsAllocation
	|			then T6020S_BatchKeysInfo.ProductionDocument
	|		when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalCostAllocation
	|			then T6020S_BatchKeysInfo.PurchaseInvoiceDocument
	|		when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalRevenueAllocation
	|			then T6020S_BatchKeysInfo.PurchaseInvoiceDocument
	|		else T6020S_BatchKeysInfo.Recorder
	|	end AS Document,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.ProductionCostsAllocation
	|			then T6020S_BatchKeysInfo.ProductionDocument.PointInTime
	|		when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalCostAllocation
	|			then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.PointInTime
	|		when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalRevenueAllocation
	|			then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.PointInTime
	|		else T6020S_BatchKeysInfo.Recorder.PointInTime
	|	end AS PointInTime,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.ProductionCostsAllocation
	|			then T6020S_BatchKeysInfo.ProductionDocument.Date
	|		when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalCostAllocation
	|			then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.Date
	|		when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalRevenueAllocation
	|			then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.Date
	|		else T6020S_BatchKeysInfo.Period
	|	end AS Date,
	|	T6020S_BatchKeysInfo.Company AS Company,
	|	T6020S_BatchKeysInfo.Direction AS Direction,
	|	T6020S_BatchKeysInfo.BatchDocument AS BatchDocument,
	|	T6020S_BatchKeysInfo.SalesInvoice AS SalesInvoice,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.CommissioningOfFixedAsset
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.ModernizationOfFixedAsset
	|			then T6020S_BatchKeysInfo.ProfitLossCenter
	|		else undefined
	|	end AS ProfitLossCenter,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet
	|			then T6020S_BatchKeysInfo.ExpenseType
	|		else undefined
	|	end AS ExpenseType,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet
	|			then T6020S_BatchKeysInfo.RowID
	|		else undefined
	|	end AS RowID,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.CommissioningOfFixedAsset
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.ModernizationOfFixedAsset
	|			then T6020S_BatchKeysInfo.Branch
	|		else undefined
	|	end AS Branch,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet
	|			then T6020S_BatchKeysInfo.Currency
	|		else undefined
	|	end AS Currency,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.ItemStockAdjustment
	|			then T6020S_BatchKeysInfo.RowID
	|		else undefined
	|	end AS ItemLinkID,
	|	T6020S_BatchKeysInfo.Store AS Store,
	|	T6020S_BatchKeysInfo.FixedAsset AS FixedAsset,
	|	T6020S_BatchKeysInfo.SerialLotNumber AS SerialLotNumber,
	|	T6020S_BatchKeysInfo.SourceOfOrigin AS SourceOfOrigin,
	|	T6020S_BatchKeysInfo.ItemKey AS ItemKey
	|INTO BatchKeysRegister
	|FROM
	|	InformationRegister.T6020S_BatchKeysInfo AS T6020S_BatchKeysInfo
	|WHERE
	|	T6020S_BatchKeysInfo.Period BETWEEN BEGINOFPERIOD(&BeginPeriod, DAY) AND ENDOFPERIOD(&EndPeriod, DAY)
	|	AND CASE
	|		WHEN &FilterByCompany
	|			THEN T6020S_BatchKeysInfo.Company = &Company
	|		ELSE TRUE
	|	END
	|GROUP BY
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.ProductionCostsAllocation
	|			then T6020S_BatchKeysInfo.ProductionDocument
	|		when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalCostAllocation
	|			then T6020S_BatchKeysInfo.PurchaseInvoiceDocument
	|		when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalRevenueAllocation
	|			then T6020S_BatchKeysInfo.PurchaseInvoiceDocument
	|		else T6020S_BatchKeysInfo.Recorder
	|	end,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.ProductionCostsAllocation
	|			then T6020S_BatchKeysInfo.ProductionDocument.PointInTime
	|		when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalCostAllocation
	|			then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.PointInTime
	|		when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalRevenueAllocation
	|			then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.PointInTime
	|		else T6020S_BatchKeysInfo.Recorder.PointInTime
	|	end,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.ProductionCostsAllocation
	|			then T6020S_BatchKeysInfo.ProductionDocument.Date
	|		when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalCostAllocation
	|			then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.Date
	|		when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalRevenueAllocation
	|			then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.Date
	|		else T6020S_BatchKeysInfo.Period
	|	end,
	|	T6020S_BatchKeysInfo.Company,
	|	T6020S_BatchKeysInfo.Direction,
	|	T6020S_BatchKeysInfo.BatchDocument,
	|	T6020S_BatchKeysInfo.SalesInvoice,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.CommissioningOfFixedAsset
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.ModernizationOfFixedAsset
	|			then T6020S_BatchKeysInfo.ProfitLossCenter
	|		else undefined
	|	end,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet
	|			then T6020S_BatchKeysInfo.ExpenseType
	|		else undefined
	|	end,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet
	|			then T6020S_BatchKeysInfo.RowID
	|		else undefined
	|	end,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.CommissioningOfFixedAsset
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.ModernizationOfFixedAsset
	|			then T6020S_BatchKeysInfo.Branch
	|		else undefined
	|	end,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet
	|			then T6020S_BatchKeysInfo.Currency
	|		else undefined
	|	end,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.ItemStockAdjustment
	|			then T6020S_BatchKeysInfo.RowID
	|		else undefined
	|	end,
	|	T6020S_BatchKeysInfo.Store,
	|	T6020S_BatchKeysInfo.FixedAsset,
	|	T6020S_BatchKeysInfo.SerialLotNumber,
	|	T6020S_BatchKeysInfo.SourceOfOrigin,
	|	T6020S_BatchKeysInfo.ItemKey
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ReallocateOutgoing.Ref AS Ref
	|INTO ReallocateDocuments
	|FROM
	|	Document.BatchReallocateOutgoing AS ReallocateOutgoing
	|WHERE
	|	ReallocateOutgoing.BatchReallocate = &CalculateMovementCostsRef
	|
	|UNION ALL
	|
	|SELECT
	|	ReallocateIncoming.Ref
	|FROM
	|	Document.BatchReallocateIncoming AS ReallocateIncoming
	|WHERE
	|	ReallocateIncoming.BatchReallocate = &CalculateMovementCostsRef
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ReallocateDocuments.Ref AS Ref
	|INTO ReallocateDocumentOutPeriod
	|FROM
	|	ReallocateDocuments AS ReallocateDocuments
	|		LEFT JOIN BatchKeysRegister AS BatchKeyRegister
	|		ON ReallocateDocuments.Ref = BatchKeyRegister.Document
	|WHERE
	|	BatchKeyRegister.Document IS NULL
	|GROUP BY
	|	ReallocateDocuments.Ref
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SUM(T6020S_BatchKeysInfo.Quantity) AS Quantity,
	|	SUM(T6020S_BatchKeysInfo.InvoiceAmount) AS InvoiceAmount,
	|	SUM(T6020S_BatchKeysInfo.InvoiceTaxAmount) AS InvoiceTaxAmount,
	|	SUM(T6020S_BatchKeysInfo.ExtraCostAmountByRatio) AS ExtraCostAmountByRatio,
	|	SUM(T6020S_BatchKeysInfo.ExtraCostTaxAmountByRatio) AS ExtraCostTaxAmountByRatio,
	|	SUM(T6020S_BatchKeysInfo.ExtraDirectCostAmount) AS ExtraDirectCostAmount,
	|	SUM(T6020S_BatchKeysInfo.ExtraDirectCostTaxAmount) AS ExtraDirectCostTaxAmount,
	|	sum(T6020S_BatchKeysInfo.IndirectCostAmount) AS IndirectCostAmount,
	|	sum(T6020S_BatchKeysInfo.IndirectCostTaxAmount) AS IndirectCostTaxAmount,
	|	sum(T6020S_BatchKeysInfo.AllocatedCostAmount) AS AllocatedCostAmount,
	|	sum(T6020S_BatchKeysInfo.AllocatedCostTaxAmount) AS AllocatedCostTaxAmount,
	|	sum(T6020S_BatchKeysInfo.AllocatedRevenueAmount) AS AllocatedRevenueAmount,
	|	sum(T6020S_BatchKeysInfo.AllocatedRevenueTaxAmount) AS AllocatedRevenueTaxAmount,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.ProductionCostsAllocation
	|			then T6020S_BatchKeysInfo.ProductionDocument
	|		when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalCostAllocation
	|			then T6020S_BatchKeysInfo.PurchaseInvoiceDocument
	|		when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalRevenueAllocation
	|			then T6020S_BatchKeysInfo.PurchaseInvoiceDocument
	|		else T6020S_BatchKeysInfo.Recorder
	|	end AS Document,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.ProductionCostsAllocation
	|			then T6020S_BatchKeysInfo.ProductionDocument.PointInTime
	|		when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalCostAllocation
	|			then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.PointInTime
	|		when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalRevenueAllocation
	|			then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.PointInTime
	|		else T6020S_BatchKeysInfo.Recorder.PointInTime
	|	end AS PointInTime,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.ProductionCostsAllocation
	|			then T6020S_BatchKeysInfo.ProductionDocument.Date
	|		when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalCostAllocation
	|			then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.Date
	|		when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalRevenueAllocation
	|			then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.Date
	|		else T6020S_BatchKeysInfo.Period
	|	end AS Date,
	|	T6020S_BatchKeysInfo.Company AS Company,
	|	T6020S_BatchKeysInfo.Direction AS Direction,
	|	T6020S_BatchKeysInfo.BatchDocument AS BatchDocument,
	|	T6020S_BatchKeysInfo.SalesInvoice AS SalesInvoice,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.CommissioningOfFixedAsset
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.ModernizationOfFixedAsset
	|			then T6020S_BatchKeysInfo.ProfitLossCenter
	|		else undefined
	|	end AS ProfitLossCenter,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet
	|			then T6020S_BatchKeysInfo.ExpenseType
	|		else undefined
	|	end AS ExpenseType,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet
	|			then T6020S_BatchKeysInfo.RowID
	|		else undefined
	|	end AS RowID,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.CommissioningOfFixedAsset
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.ModernizationOfFixedAsset
	|			then T6020S_BatchKeysInfo.Branch
	|		else undefined
	|	end AS Branch,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet
	|			then T6020S_BatchKeysInfo.Currency
	|		else undefined
	|	end AS Currency,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.ItemStockAdjustment
	|			then T6020S_BatchKeysInfo.RowID
	|		else undefined
	|	end AS ItemLinkID,
	|	T6020S_BatchKeysInfo.Store AS Store,
	|	T6020S_BatchKeysInfo.FixedAsset AS FixedAsset,
	|	T6020S_BatchKeysInfo.SerialLotNumber AS SerialLotNumber,
	|	T6020S_BatchKeysInfo.SourceOfOrigin AS SourceOfOrigin,
	|	T6020S_BatchKeysInfo.ItemKey AS ItemKey
	|INTO BatchKeysRegisterOutPeriod
	|FROM
	|	ReallocateDocumentOutPeriod AS ReallocateDocumentOutPeriod
	|		INNER JOIN InformationRegister.T6020S_BatchKeysInfo AS T6020S_BatchKeysInfo
	|		ON ReallocateDocumentOutPeriod.Ref = T6020S_BatchKeysInfo.Recorder
	|GROUP BY
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.ProductionCostsAllocation
	|			then T6020S_BatchKeysInfo.ProductionDocument
	|		when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalCostAllocation
	|			then T6020S_BatchKeysInfo.PurchaseInvoiceDocument
	|		when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalRevenueAllocation
	|			then T6020S_BatchKeysInfo.PurchaseInvoiceDocument
	|		else T6020S_BatchKeysInfo.Recorder
	|	end,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.ProductionCostsAllocation
	|			then T6020S_BatchKeysInfo.ProductionDocument.PointInTime
	|		when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalCostAllocation
	|			then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.PointInTime
	|		when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalRevenueAllocation
	|			then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.PointInTime
	|		else T6020S_BatchKeysInfo.Recorder.PointInTime
	|	end,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.ProductionCostsAllocation
	|			then T6020S_BatchKeysInfo.ProductionDocument.Date
	|		when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalCostAllocation
	|			then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.Date
	|		when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalRevenueAllocation
	|			then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.Date
	|		else T6020S_BatchKeysInfo.Period
	|	end,
	|	T6020S_BatchKeysInfo.Company,
	|	T6020S_BatchKeysInfo.Direction,
	|	T6020S_BatchKeysInfo.BatchDocument,
	|	T6020S_BatchKeysInfo.SalesInvoice,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.CommissioningOfFixedAsset
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.ModernizationOfFixedAsset
	|			then T6020S_BatchKeysInfo.ProfitLossCenter
	|		else undefined
	|	end,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet
	|			then T6020S_BatchKeysInfo.ExpenseType
	|		else undefined
	|	end,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet
	|			then T6020S_BatchKeysInfo.RowID
	|		else undefined
	|	end,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.CommissioningOfFixedAsset
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.ModernizationOfFixedAsset
	|			then T6020S_BatchKeysInfo.Branch
	|		else undefined
	|	end,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet
	|			then T6020S_BatchKeysInfo.Currency
	|		else undefined
	|	end,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.ItemStockAdjustment
	|			then T6020S_BatchKeysInfo.RowID
	|		else undefined
	|	end,
	|	T6020S_BatchKeysInfo.Store,
	|	T6020S_BatchKeysInfo.FixedAsset,
	|	T6020S_BatchKeysInfo.SerialLotNumber,
	|	T6020S_BatchKeysInfo.SourceOfOrigin,
	|	T6020S_BatchKeysInfo.ItemKey
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchKeysRegister.Quantity AS Quantity,
	|	BatchKeysRegister.InvoiceAmount AS InvoiceAmount,
	|	BatchKeysRegister.InvoiceTaxAmount AS InvoiceTaxAmount,
	|	BatchKeysRegister.ExtraCostAmountByRatio AS ExtraCostAmountByRatio,
	|	BatchKeysRegister.ExtraCostTaxAmountByRatio AS ExtraCostTaxAmountByRatio,
	|	BatchKeysRegister.ExtraDirectCostAmount AS ExtraDirectCostAmount,
	|	BatchKeysRegister.ExtraDirectCostTaxAmount AS ExtraDirectCostTaxAmount,
	|	BatchKeysRegister.IndirectCostAmount AS IndirectCostAmount,
	|	BatchKeysRegister.IndirectCostTaxAmount AS IndirectCostTaxAmount,
	|	BatchKeysRegister.AllocatedCostAmount AS AllocatedCostAmount,
	|	BatchKeysRegister.AllocatedCostTaxAmount AS AllocatedCostTaxAmount,
	|	BatchKeysRegister.AllocatedRevenueAmount AS AllocatedRevenueAmount,
	|	BatchKeysRegister.AllocatedRevenueTaxAmount AS AllocatedRevenueTaxAmount,
	|	BatchKeysRegister.Document AS Document,
	|	BatchKeysRegister.PointInTime AS PointInTime,
	|	BatchKeysRegister.Date AS Date,
	|	BatchKeysRegister.Company AS Company,
	|	BatchKeysRegister.Direction AS Direction,
	|	BatchKeysRegister.BatchDocument AS BatchDocument,
	|	BatchKeysRegister.SalesInvoice AS SalesInvoice,
	|	BatchKeysRegister.ProfitLossCenter AS ProfitLossCenter,
	|	BatchKeysRegister.ExpenseType AS ExpenseType,
	|	BatchKeysRegister.RowID AS RowID,
	|	BatchKeysRegister.Branch AS Branch,
	|	BatchKeysRegister.Currency AS Currency,
	|	BatchKeysRegister.ItemLinkID AS ItemLinkID,
	|	BatchKeysRegister.Store AS Store,
	|	BatchKeysRegister.FixedAsset AS FixedAsset,
	|	BatchKeysRegister.SerialLotNumber AS SerialLotNumber,
	|	BatchKeysRegister.SourceOfOrigin AS SourceOfOrigin,
	|	BatchKeysRegister.ItemKey AS ItemKey
	|INTO BatchKeysInfo
	|FROM
	|	BatchKeysRegister AS BatchKeysRegister
	|
	|UNION ALL
	|
	|SELECT
	|	BatchKeysRegisterOutPeriod.Quantity,
	|	BatchKeysRegisterOutPeriod.InvoiceAmount,
	|	BatchKeysRegisterOutPeriod.InvoiceTaxAmount,
	|	BatchKeysRegisterOutPeriod.ExtraCostAmountByRatio,
	|	BatchKeysRegisterOutPeriod.ExtraCostTaxAmountByRatio,
	|	BatchKeysRegisterOutPeriod.ExtraDirectCostAmount,
	|	BatchKeysRegisterOutPeriod.ExtraDirectCostTaxAmount,
	|	BatchKeysRegisterOutPeriod.IndirectCostAmount,
	|	BatchKeysRegisterOutPeriod.IndirectCostTaxAmount,
	|	BatchKeysRegisterOutPeriod.AllocatedCostAmount,
	|	BatchKeysRegisterOutPeriod.AllocatedCostTaxAmount,
	|	BatchKeysRegisterOutPeriod.AllocatedRevenueAmount,
	|	BatchKeysRegisterOutPeriod.AllocatedRevenueTaxAmount,
	|	BatchKeysRegisterOutPeriod.Document,
	|	BatchKeysRegisterOutPeriod.PointInTime,
	|	BatchKeysRegisterOutPeriod.Date,
	|	BatchKeysRegisterOutPeriod.Company,
	|	BatchKeysRegisterOutPeriod.Direction,
	|	BatchKeysRegisterOutPeriod.BatchDocument,
	|	BatchKeysRegisterOutPeriod.SalesInvoice,
	|	BatchKeysRegisterOutPeriod.ProfitLossCenter,
	|	BatchKeysRegisterOutPeriod.ExpenseType,
	|	BatchKeysRegisterOutPeriod.RowID,
	|	BatchKeysRegisterOutPeriod.Branch,
	|	BatchKeysRegisterOutPeriod.Currency,
	|	BatchKeysRegisterOutPeriod.ItemLinkID,
	|	BatchKeysRegisterOutPeriod.Store,
	|	BatchKeysRegisterOutPeriod.FixedAsset,
	|	BatchKeysRegisterOutPeriod.SerialLotNumber,
	|	BatchKeysRegisterOutPeriod.SourceOfOrigin,
	|	BatchKeysRegisterOutPeriod.ItemKey
	|FROM
	|	BatchKeysRegisterOutPeriod AS BatchKeysRegisterOutPeriod
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchKeys.Ref AS BatchKey,
	|	SUM(BatchKeysInfo.Quantity) AS Quantity,
	|	SUM(BatchKeysInfo.InvoiceAmount) AS InvoiceAmount,
	|	SUM(BatchKeysInfo.InvoiceTaxAmount) AS InvoiceTaxAmount,
	|	SUM(BatchKeysInfo.ExtraCostAmountByRatio) AS ExtraCostAmountByRatio,
	|	SUM(BatchKeysInfo.ExtraCostTaxAmountByRatio) AS ExtraCostTaxAmountByRatio,
	|	SUM(BatchKeysInfo.ExtraDirectCostAmount) AS ExtraDirectCostAmount,
	|	SUM(BatchKeysInfo.ExtraDirectCostTaxAmount) AS ExtraDirectCostTaxAmount,
	|	SUM(BatchKeysInfo.IndirectCostAmount) AS IndirectCostAmount,
	|	SUM(BatchKeysInfo.IndirectCostTaxAmount) AS IndirectCostTaxAmount,
	|	SUM(BatchKeysInfo.AllocatedCostAmount) AS AllocatedCostAmount,
	|	SUM(BatchKeysInfo.AllocatedCostTaxAmount) AS AllocatedCostTaxAmount,
	|	SUM(BatchKeysInfo.AllocatedRevenueAmount) AS AllocatedRevenueAmount,
	|	SUM(BatchKeysInfo.AllocatedRevenueTaxAmount) AS AllocatedRevenueTaxAmount,
	|	BatchKeysInfo.Document AS Document,
	|	BatchKeysInfo.PointInTime AS PointInTime,
	|	BatchKeysInfo.Date AS Date,
	|	BatchKeysInfo.Company AS Company,
	|	BatchKeysInfo.Direction AS Direction,
	|	BatchKeysInfo.BatchDocument AS BatchDocument,
	|	BatchKeysInfo.SalesInvoice AS SalesInvoice,
	|	BatchKeysInfo.ProfitLossCenter AS ProfitLossCenter,
	|	BatchKeysInfo.ExpenseType AS ExpenseType,
	|	BatchKeysInfo.RowID AS RowID,
	|	BatchKeysInfo.Branch AS Branch,
	|	BatchKeysInfo.Currency AS Currency,
	|	BatchKeysInfo.ItemLinkID AS ItemLinkID,
	|	BatchKeysInfo.FixedAsset AS FixedAsset
	|INTO BatchKeys
	|FROM
	|	BatchKeysInfo AS BatchKeysInfo
	|		INNER JOIN Catalog.BatchKeys AS BatchKeys
	|		ON (BatchKeys.ItemKey = BatchKeysInfo.ItemKey)
	|		AND (BatchKeys.Store = BatchKeysInfo.Store)
	|		AND (BatchKeys.SerialLotNumber = BatchKeysInfo.SerialLotNumber)
	|		AND (BatchKeys.SourceOfOrigin = BatchKeysInfo.SourceOfOrigin)
	|		AND (NOT BatchKeys.DeletionMark)
	|GROUP BY
	|	BatchKeys.Ref,
	|	BatchKeysInfo.Document,
	|	BatchKeysInfo.Date,
	|	BatchKeysInfo.PointInTime,
	|	BatchKeysInfo.Company,
	|	BatchKeysInfo.Direction,
	|	BatchKeysInfo.BatchDocument,
	|	BatchKeysInfo.SalesInvoice,
	|	BatchKeysInfo.ProfitLossCenter,
	|	BatchKeysInfo.ExpenseType,
	|	BatchKeysInfo.RowID,
	|	BatchKeysInfo.Branch,
	|	BatchKeysInfo.Currency,
	|	BatchKeysInfo.ItemLinkID,
	|	BatchKeysInfo.FixedAsset
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	FALSE AS IsOpeningBalance,
	|	BatchKeys.BatchKey AS BatchKey,
	|	BatchKeys.Quantity AS Quantity,
	|	BatchKeys.InvoiceAmount AS InvoiceAmount,
	|	BatchKeys.InvoiceTaxAmount AS InvoiceTaxAmount,
	|	BatchKeys.ExtraCostAmountByRatio AS ExtraCostAmountByRatio,
	|	BatchKeys.ExtraCostTaxAmountByRatio AS ExtraCostTaxAmountByRatio,
	|	BatchKeys.ExtraDirectCostAmount AS ExtraDirectCostAmount,
	|	BatchKeys.ExtraDirectCostTaxAmount AS ExtraDirectCostTaxAmount,
	|	BatchKeys.IndirectCostAmount AS IndirectCostAmount,
	|	BatchKeys.IndirectCostTaxAmount AS IndirectCostTaxAmount,
	|	BatchKeys.AllocatedCostAmount AS AllocatedCostAmount,
	|	BatchKeys.AllocatedCostTaxAmount AS AllocatedCostTaxAmount,
	|	BatchKeys.AllocatedRevenueAmount AS AllocatedRevenueAmount,
	|	BatchKeys.AllocatedRevenueTaxAmount AS AllocatedRevenueTaxAmount,
	|	BatchKeys.Document AS Document,
	|	BatchKeys.PointInTime AS PointInTime,
	|	BatchKeys.Date AS Date,
	|	BatchKeys.Company AS Company,
	|	BatchKeys.Direction AS Direction,
	|	ISNULL(Batches.Ref, VALUE(Catalog.Batches.EmptyRef)) AS Batch,
	|	CASE
	|		WHEN Batches.Ref IS NULL
	|		OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.Quantity
	|	END AS QuantityBalance,
	|	CASE
	|		WHEN Batches.Ref IS NULL
	|		OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.InvoiceAmount
	|	END AS InvoiceAmountBalance,
	|	CASE
	|		WHEN Batches.Ref IS NULL
	|		OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.InvoiceTaxAmount
	|	END AS InvoiceTaxAmountBalance,
	|	CASE
	|		WHEN Batches.Ref IS NULL
	|		OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.ExtraCostAmountByRatio
	|	END AS ExtraCostAmountByRatioBalance,
	|	CASE
	|		WHEN Batches.Ref IS NULL
	|		OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.ExtraCostTaxAmountByRatio
	|	END AS ExtraCostTaxAmountByRatioBalance,
	|	CASE
	|		WHEN Batches.Ref IS NULL
	|		OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.ExtraDirectCostAmount
	|	END AS ExtraDirectCostAmountBalance,
	|	CASE
	|		WHEN Batches.Ref IS NULL
	|		OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.ExtraDirectCostTaxAmount
	|	END AS ExtraDirectCostTaxAmountBalance,
	|	CASE
	|		WHEN Batches.Ref IS NULL
	|		OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.IndirectCostAmount
	|	END AS IndirectCostAmountBalance,
	|	CASE
	|		WHEN Batches.Ref IS NULL
	|		OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.IndirectCostTaxAmount
	|	END AS IndirectCostTaxAmountBalance,
	|	CASE
	|		WHEN Batches.Ref IS NULL
	|		OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.AllocatedCostAmount
	|	END AS AllocatedCostAmountBalance,
	|	CASE
	|		WHEN Batches.Ref IS NULL
	|		OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.AllocatedCostTaxAmount
	|	END AS AllocatedCostTaxAmountBalance,
	|	CASE
	|		WHEN Batches.Ref IS NULL
	|		OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.AllocatedRevenueAmount
	|	END AS AllocatedRevenueAmountBalance,
	|	CASE
	|		WHEN Batches.Ref IS NULL
	|		OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.AllocatedRevenueTaxAmount
	|	END AS AllocatedRevenueTaxAmountBalance,
	|	BatchKeys.BatchDocument AS BatchDocument,
	|	BatchKeys.SalesInvoice AS SalesInvoice,
	|	BatchKeys.ProfitLossCenter AS ProfitLossCenter,
	|	BatchKeys.ExpenseType AS ExpenseType,
	|	BatchKeys.RowID AS RowID,
	|	BatchKeys.Branch AS Branch,
	|	BatchKeys.Currency AS Currency,
	|	BatchKeys.ItemLinkID AS ItemLinkID,
	|	BatchKeys.FixedAsset AS FixedAsset
	|INTO AllData
	|FROM
	|	BatchKeys AS BatchKeys
	|		LEFT JOIN Catalog.Batches AS Batches
	|		ON (Batches.Document = BatchKeys.Document)
	|		AND (Batches.Company = BatchKeys.Company)
	|		AND (Batches.Date = BatchKeys.Date)
	|		AND (NOT Batches.DeletionMark)
	|
	|UNION ALL
	|
	|SELECT
	|	TRUE,
	|	R6010B_BatchWiseBalance.BatchKey,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|	R6010B_BatchWiseBalance.Batch.Document,
	|	R6010B_BatchWiseBalance.Batch.Document.PointInTime,
	|	R6010B_BatchWiseBalance.Batch.Date,
	|	R6010B_BatchWiseBalance.Batch.Company,
	|	VALUE(Enum.BatchDirection.Receipt),
	|	R6010B_BatchWiseBalance.Batch,
	|	R6010B_BatchWiseBalance.QuantityBalance,
	|	R6010B_BatchWiseBalance.InvoiceAmountBalance,
	|	R6010B_BatchWiseBalance.InvoiceTaxAmountBalance,
	|	R6010B_BatchWiseBalance.ExtraCostAmountByRatioBalance,
	|	R6010B_BatchWiseBalance.ExtraCostTaxAmountByRatioBalance,
	|	R6010B_BatchWiseBalance.ExtraDirectCostAmountBalance,
	|	R6010B_BatchWiseBalance.ExtraDirectCostTaxAmountBalance,
	|	R6010B_BatchWiseBalance.IndirectCostAmountBalance,
	|	R6010B_BatchWiseBalance.IndirectCostTaxAmountBalance,
	|	R6010B_BatchWiseBalance.AllocatedCostAmountBalance,
	|	R6010B_BatchWiseBalance.AllocatedCostTaxAmountBalance,
	|	R6010B_BatchWiseBalance.AllocatedRevenueAmountBalance,
	|	R6010B_BatchWiseBalance.AllocatedRevenueTaxAmountBalance,
	|	UNDEFINED,
	|	UNDEFINED,
	|	UNDEFINED,
	|	UNDEFINED,
	|	UNDEFINED,
	|	UNDEFINED,
	|	UNDEFINED,
	|	UNDEFINED,
	|	UNDEFINED
	|FROM
	|	AccumulationRegister.R6010B_BatchWiseBalance.Balance(ENDOFPERIOD(&EndPeriod, DAY), (BatchKey, Batch.Company) IN
	|		(SELECT
	|			BatchKeys.BatchKey,
	|			BatchKeys.Company
	|		FROM
	|			BatchKeys AS BatchKeys)) AS R6010B_BatchWiseBalance
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AllData.IsOpeningBalance AS IsOpeningBalance,
	|	AllData.BatchKey AS BatchKey,
	|	SUM(AllData.Quantity) AS Quantity,
	|	SUM(AllData.InvoiceAmount) AS InvoiceAmount,
	|	SUM(AllData.InvoiceTaxAmount) AS InvoiceTaxAmount,
	|	SUM(AllData.IndirectCostAmount) AS IndirectCostAmount,
	|	SUM(AllData.IndirectCostTaxAmount) AS IndirectCostTaxAmount,
	|	SUM(AllData.ExtraCostAmountByRatio) AS ExtraCostAmountByRatio,
	|	SUM(AllData.ExtraCostTaxAmountByRatio) AS ExtraCostTaxAmountByRatio,
	|	SUM(AllData.ExtraDirectCostAmount) AS ExtraDirectCostAmount,
	|	SUM(AllData.ExtraDirectCostTaxAmount) AS ExtraDirectCostTaxAmount,
	|	SUM(AllData.AllocatedCostAmount) AS AllocatedCostAmount,
	|	SUM(AllData.AllocatedCostTaxAmount) AS AllocatedCostTaxAmount,
	|	SUM(AllData.AllocatedRevenueAmount) AS AllocatedRevenueAmount,
	|	SUM(AllData.AllocatedRevenueTaxAmount) AS AllocatedRevenueTaxAmount,
	|	AllData.Document AS Document,
	|	AllData.Document.PointInTime AS PointInTime,
	|	AllData.Date AS Date,
	|	AllData.Company AS Company,
	|	AllData.Direction AS Direction,
	|	AllData.Batch AS Batch,
	|	SUM(AllData.QuantityBalance) AS QuantityBalance,
	|	SUM(AllData.InvoiceAmountBalance) AS InvoiceAmountBalance,
	|	SUM(AllData.InvoiceTaxAmountBalance) AS InvoiceTaxAmountBalance,
	|	SUM(AllData.IndirectCostAmountBalance) AS IndirectCostAmountBalance,
	|	SUM(AllData.IndirectCostTaxAmountBalance) AS IndirectCostTaxAmountBalance,
	|	SUM(AllData.ExtraCostAmountByRatioBalance) AS ExtraCostAmountByRatioBalance,
	|	SUM(AllData.ExtraCostTaxAmountByRatioBalance) AS ExtraCostTaxAmountByRatioBalance,
	|	SUM(AllData.ExtraDirectCostAmountBalance) AS ExtraDirectCostAmountBalance,
	|	SUM(AllData.ExtraDirectCostTaxAmountBalance) AS ExtraDirectCostTaxAmountBalance,
	|	SUM(AllData.AllocatedCostAmountBalance) AS AllocatedCostAmountBalance,
	|	SUM(AllData.AllocatedCostTaxAmountBalance) AS AllocatedCostTaxAmountBalance,
	|	SUM(AllData.AllocatedRevenueAmountBalance) AS AllocatedRevenueAmountBalance,
	|	SUM(AllData.AllocatedRevenueTaxAmountBalance) AS AllocatedRevenueTaxAmountBalance,
	|	AllData.BatchDocument AS BatchDocument,
	|	AllData.SalesInvoice AS SalesInvoice,
	|	AllData.ProfitLossCenter AS ProfitLossCenter,
	|	AllData.ExpenseType AS ExpenseType,
	|	AllData.RowID AS RowID,
	|	AllData.Branch AS Branch,
	|	AllData.Currency AS Currency,
	|	AllData.ItemLinkID AS ItemLinkID,
	|	AllData.FixedAsset AS FixedAsset
	|INTO AllDataGrouped
	|FROM
	|	AllData AS AllData
	|GROUP BY
	|	AllData.IsOpeningBalance,
	|	AllData.BatchKey,
	|	AllData.Document,
	|	AllData.Document.PointInTime,
	|	AllData.Date,
	|	AllData.Company,
	|	AllData.Direction,
	|	AllData.Batch,
	|	AllData.BatchDocument,
	|	AllData.SalesInvoice,
	|	AllData.ProfitLossCenter,
	|	AllData.ExpenseType,
	|	AllData.RowID,
	|	AllData.Branch,
	|	AllData.Currency,
	|	AllData.ItemLinkID,
	|	AllData.FixedAsset
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AllDataGrouped.IsOpeningBalance AS IsOpeningBalance,
	|	AllDataGrouped.BatchKey AS BatchKey,
	|	AllDataGrouped.Quantity AS Quantity,
	|	AllDataGrouped.InvoiceAmount AS InvoiceAmount,
	|	AllDataGrouped.InvoiceTaxAmount AS InvoiceTaxAmount,
	|	AllDataGrouped.IndirectCostAmount AS IndirectCostAmount,
	|	AllDataGrouped.IndirectCostTaxAmount AS IndirectCostTaxAmount,
	|	AllDataGrouped.ExtraCostAmountByRatio AS ExtraCostAmountByRatio,
	|	AllDataGrouped.ExtraCostTaxAmountByRatio AS ExtraCostTaxAmountByRatio,
	|	AllDataGrouped.ExtraDirectCostAmount AS ExtraDirectCostAmount,
	|	AllDataGrouped.ExtraDirectCostTaxAmount AS ExtraDirectCostTaxAmount,
	|	AllDataGrouped.AllocatedCostAmount AS AllocatedCostAmount,
	|	AllDataGrouped.AllocatedCostTaxAmount AS AllocatedCostTaxAmount,
	|	AllDataGrouped.AllocatedRevenueAmount AS AllocatedRevenueAmount,
	|	AllDataGrouped.AllocatedRevenueTaxAmount AS AllocatedRevenueTaxAmount,
	|	AllDataGrouped.Document AS Document,
	|	AllDataGrouped.Date AS Date,
	|	AllDataGrouped.Company AS Company,
	|	AllDataGrouped.Direction AS Direction,
	|	AllDataGrouped.Batch AS Batch,
	|	AllDataGrouped.QuantityBalance AS QuantityBalance,
	|	AllDataGrouped.InvoiceAmountBalance AS InvoiceAmountBalance,
	|	AllDataGrouped.InvoiceTaxAmountBalance AS InvoiceTaxAmountBalance,
	|	AllDataGrouped.IndirectCostAmountBalance AS IndirectCostAmountBalance,
	|	AllDataGrouped.IndirectCostTaxAmountBalance AS IndirectCostTaxAmountBalance,
	|	AllDataGrouped.ExtraCostAmountByRatioBalance AS ExtraCostAmountByRatioBalance,
	|	AllDataGrouped.ExtraCostTaxAmountByRatioBalance AS ExtraCostTaxAmountByRatioBalance,
	|	AllDataGrouped.ExtraDirectCostAmountBalance AS ExtraDirectCostAmountBalance,
	|	AllDataGrouped.ExtraDirectCostTaxAmountBalance AS ExtraDirectCostTaxAmountBalance,
	|	AllDataGrouped.AllocatedCostAmountBalance AS AllocatedCostAmountBalance,
	|	AllDataGrouped.AllocatedCostTaxAmountBalance AS AllocatedCostTaxAmountBalance,
	|	AllDataGrouped.AllocatedRevenueAmountBalance AS AllocatedRevenueAmountBalance,
	|	AllDataGrouped.AllocatedRevenueTaxAmountBalance AS AllocatedRevenueTaxAmountBalance,
	|	AllDataGrouped.BatchDocument AS BatchDocument,
	|	AllDataGrouped.SalesInvoice AS SalesInvoice,
	|	AllDataGrouped.ProfitLossCenter AS ProfitLossCenter,
	|	AllDataGrouped.ExpenseType AS ExpenseType,
	|	AllDataGrouped.RowID AS RowID,
	|	AllDataGrouped.Branch AS Branch,
	|	AllDataGrouped.Currency AS Currency,
	|	AllDataGrouped.ItemLinkID AS ItemLinkID,
	|	AllDataGrouped.FixedAsset AS FixedAsset,
	|	FALSE AS Skip,
	|	0 AS Priority,
	|	FALSE AS IsPreliminary,
	|	undefined AS PreliminaryID,
	|	0 AS PreliminaryQuantity,
	|	0 AS PreliminaryAmount,
	|	0 AS PreliminaryAmountBalance,
	|	0 AS PreliminaryTaxAmount,
	|	0 AS PreliminaryTaxAmountBalance
	|FROM
	|	AllDataGrouped AS AllDataGrouped
	|
	|ORDER BY
	|	AllDataGrouped.PointInTime
	|TOTALS
	|BY
	|	Document";

	Query.SetParameter("FilterByCompany"           , ValueIsFilled(CalculationSettings.Company));
	Query.SetParameter("CalculateMovementCostsRef" , CalculationSettings.CalculationMovementCostRef);
	Query.SetParameter("Company"                   , CalculationSettings.Company);
	Query.SetParameter("BeginPeriod"               , BegOfDay(CalculationSettings.BeginPeriod));
	Query.SetParameter("EndPeriod"                 , EndOfDay(CalculationSettings.EndPeriod));
	QueryResult = Query.Execute();
	Tree = QueryResult.Unload(QueryResultIteration.ByGroups);

	QueryDrop = New Query();
	QueryDrop.TempTablesManager = TempTablesManager;
	QueryDrop.Text =
	"DROP BatchKeysRegister;
	|DROP ReallocateDocuments;
	|DROP ReallocateDocumentOutPeriod;
	|DROP BatchKeysRegisterOutPeriod;
	|DROP BatchKeysInfo;
	|DROP BatchKeys;
	|DROP AllData;
	|DROP AllDataGrouped";
	QueryDrop.Execute();
	
	ArrayOfReturnedSalesInvoices = New Array();
	For Each Row In Tree.Rows Do // document level
		For Each RowDetails In Row.Rows Do // row level
			If ValueIsFilled(RowDetails.SalesInvoice) Then
				ArrayOfReturnedSalesInvoices.Add(RowDetails.SalesInvoice);
			EndIf;
		EndDo;
	EndDo;
	TableOfReturnedBatches = GetSalesBatchDocument(ArrayOfReturnedSalesInvoices);
	For Each ReturnedBatch In TableOfReturnedBatches Do
		If Not Tree.Rows.FindRows(New Structure("Document", ReturnedBatch.BatchDocument)).Count() Then
			Tree.Rows.Add().Document = ReturnedBatch.BatchDocument;
		EndIf;
	EndDo;

	Return Tree;
EndFunction

Function GetSalesBatchDocument(ArrayOfReturnedSalesInvoices)
	Query = New Query();
	Query.Text =
	"SELECT
	|	R6050T_SalesBatchesTurnovers.Batch.Document AS BatchDocument
	|FROM
	|	AccumulationRegister.R6050T_SalesBatches.Turnovers(, , , SalesInvoice IN (&ArrayOfReturnedSalesInvoices)) AS
	|		R6050T_SalesBatchesTurnovers
	|GROUP BY
	|	R6050T_SalesBatchesTurnovers.Batch.Document";
	Query.SetParameter("ArrayOfReturnedSalesInvoices", ArrayOfReturnedSalesInvoices);
	TableOfReturnedBatches = Query.Execute().Unload();
	Return TableOfReturnedBatches
EndFunction

Procedure CalculateBatch(Document, Rows, Tables, Tree, TableOfReturnedBatches, EmptyTable_BatchWiseBalance, CalculationSettings)
	TableOfReturnedBatches.Clear();

	DataForExpense = EmptyTable_BatchWiseBalance.CopyColumns();
	DataForReceipt = EmptyTable_BatchWiseBalance.CopyColumns();

	DataForExpense.Columns.Add("ItemLinkID");
	DataForReceipt.Columns.Add("ItemLinkID");
	
	For Each Row In Rows Do
		If Row.Skip Then
			Continue;
		EndIf;
		If Row.Direction = Enums.BatchDirection.Receipt And Not Row.IsOpeningBalance Then

			NewRow_DataForReceipt = DataForReceipt.Add();
			NewRow_DataForReceipt.Batch     = Row.Batch;
			NewRow_DataForReceipt.BatchKey  = Row.BatchKey;
			NewRow_DataForReceipt.Document  = Row.Document;
			NewRow_DataForReceipt.Company   = Row.Company;
			NewRow_DataForReceipt.Period    = Row.Date;
			NewRow_DataForReceipt.Quantity  = Row.Quantity;
			NewRow_DataForReceipt.PreliminaryQuantity  = Row.PreliminaryQuantity;
			NewRow_DataForReceipt.ItemLinkID = Row.ItemLinkID;
			NewRow_DataForReceipt.IsPreliminary = Row.IsPreliminary;

			For Each Res In AmountResources() Do
				NewRow_DataForReceipt[Res] = Row[Res];
			EndDo;

			// simple receipt	
			If IsNotMultiDirectionDocument(Document) // is not transfer, produce, bundling or unbundling
				And Not ValueIsFilled(Row.SalesInvoice) // is not return by sales invoice
				And TypeOf(Document) <> Type("DocumentRef.BatchReallocateIncoming") // is not receipt by btach reallocation
				And Not IsShipmentToTradeAgent(Document) Then // sales invoice with transaction type "shipment to trade agent" is multi direction document
				
				If Row.InvoiceAmount = 0 AND Row.Company.LandedCostFillEmptyAmount 
					AND (TypeOf(Document) = Type("DocumentRef.StockAdjustmentAsSurplus")
					OR TypeOf(Document) = Type("DocumentRef.SalesReturn")) Then
						Price = GetPriceForEmptyAmountFromDataForReceipt(Row.BatchKey.ItemKey, Row.Date, Tables.DataForReceipt);
						
						If Price = 0 Then
							Price = GetPriceForEmptyAmountFromBatchBalance(Row.BatchKey.ItemKey, Row.Date);
						EndIf;
						
						If Price = 0 AND Not Row.Company.LandedCostPriceTypeForEmptyAmount.isEmpty() Then
							PriceSettings = New Structure();
							PriceSettings.Insert("ItemKey"   , Row.BatchKey.ItemKey);
							PriceSettings.Insert("Period"    ,  Row.Date);
							PriceSettings.Insert("PriceType" ,  Row.Company.LandedCostPriceTypeForEmptyAmount);
							PriceSettings.Insert("Unit"      ,  GetItemInfo.GetInfoByItemsKey(Row.BatchKey.ItemKey)[0].Unit);
							Price = GetItemInfo.ItemPriceInfo(PriceSettings).Price;
						EndIf;
						
						Row.InvoiceAmount        = Price * Row.Quantity;
						Row.InvoiceAmountBalance = Price * Row.Quantity;
						
						NewRow_DataForReceipt.InvoiceAmount = Price * Row.Quantity;
				EndIf; // fill empty amount
				
				FillPropertyValues(Tables.DataForReceipt.Add(), NewRow_DataForReceipt);
				
			EndIf;

			If ValueIsFilled(Row.SalesInvoice) Then // return by sales invoice

				TableOfBatchBySales = GetSalesBatches(Row.SalesInvoice, Tables.DataForSalesBatches, Row.BatchKey);

				NeedReceipt = Row.Quantity; // how many returned (quantity)

				For Each BatchBySales In TableOfBatchBySales Do
					If NeedReceipt = 0 Then
						Break;
					EndIf;
					
					QtyName = ?(BatchBySales.IsPreliminary, "Preliminary", "") + "Quantity";
					ReceiptQuantity = Min(NeedReceipt, BatchBySales[QtyName]); // how many can receipt (quantity)
					
					ReceiptAmounts = New Structure();
					For Each Res In AmountResources() Do
						ReceiptAmounts.Insert(Res, AmountProportionByQuantity(ReceiptQuantity, BatchBySales, Res, "Quantity"));
						BatchBySales[Res] = BatchBySales[Res] - ReceiptAmounts[Res]; 
					EndDo;
					
					BatchBySales[QtyName] = BatchBySales[QtyName] - ReceiptQuantity;					
					NeedReceipt = NeedReceipt - ReceiptQuantity;
					
					_BatchBySales_Document = BatchBySales.Document;
					_BatchBySales_Company  = BatchBySales.Company; // company from sales document
					_BatchBySales_Batch    = BatchBySales.Batch;
					
					// determine batch when returned by another company
					If ValueIsFilled(Row.Batch) And Row.Company <> _BatchBySales_Company Then
						_BatchBySales_Document = Row.Batch.Document;
						_BatchBySales_Company  = Row.Company; // current document company
						_BatchBySales_Batch    = Row.Batch;
					EndIf;
					
					If Not IsReturnFromTradeAgent(Row.Document) Then
						
						// Table of returned batches
						NewRow_ReturnedBatches = TableOfReturnedBatches.Add();
						NewRow_ReturnedBatches.Date             = Row.Date;
						NewRow_ReturnedBatches.Direction        = Enums.BatchDirection.Receipt;
						NewRow_ReturnedBatches.IsOpeningBalance = False;
						NewRow_ReturnedBatches.Skip             = True;
						NewRow_ReturnedBatches.Priority         = 0;
						NewRow_ReturnedBatches.BatchKey         = Row.BatchKey;
						NewRow_ReturnedBatches.IsPreliminary    = Row.IsPreliminary;

						NewRow_ReturnedBatches.Document         = _BatchBySales_Document;
						NewRow_ReturnedBatches.Company          = _BatchBySales_Company;
						NewRow_ReturnedBatches.Batch            = _BatchBySales_Batch;
					
						NewRow_ReturnedBatches[QtyName] = ReceiptQuantity;
						NewRow_ReturnedBatches[QtyName + "Balance"] = ReceiptQuantity;

						For Each Res In AmountResources() Do
							NewRow_ReturnedBatches[Res] = ReceiptAmounts[Res];
							NewRow_ReturnedBatches[Res + "Balance"] = ReceiptAmounts[Res];
						EndDo;

						// Data for receipt
						NewRow_DataForReceipt = Tables.DataForReceipt.Add();
						NewRow_DataForReceipt.Period    = Row.Date;
						NewRow_DataForReceipt.Document  = Row.Document;
						NewRow_DataForReceipt.Company   = _BatchBySales_Company;
						NewRow_DataForReceipt.Batch     = _BatchBySales_Batch;
						NewRow_DataForReceipt.BatchKey  = Row.BatchKey;
						
						NewRow_DataForReceipt[QtyName] = ReceiptQuantity;

						For Each Res In AmountResources() Do 
							NewRow_DataForReceipt[Res] = ReceiptAmounts[Res];
						EndDo;	

					EndIf;
				EndDo; // return by sales invoice

				If NeedReceipt <> 0 Then
					// Can not receipt Batch key by sales return: %1 , Quantity: %2 , Doc: %3
					Msg = StrTemplate(R().LC_Error_001, GetBatchKeyDetailPresentation(Row.BatchKey), NeedReceipt, Row.Document);
					CommonFunctionsClientServer.ShowUsersMessage(Msg);
					If CalculationSettings.RaiseOnCalculationError Then
						Raise Msg;
					EndIf;
					NewRow_ShortageIncoming = Tables.DataForBatchShortageIncoming.Add();
					NewRow_ShortageIncoming.BatchKey = Row.BatchKey;
					NewRow_ShortageIncoming.Document = Row.Document;
					NewRow_ShortageIncoming.Company  = Row.Company;
					NewRow_ShortageIncoming.Period   = Row.Date;
					NewRow_ShortageIncoming.Quantity = NeedReceipt;
				EndIf;
			EndIf;
		Else //Expense

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

			Filter = New Structure();
			Filter.Insert("BatchKey", Row.BatchKey);
			FIlter.Insert("Direction", Enums.BatchDirection.Receipt);

			FilteredRows = Tree.Rows.FindRows(Filter, True);
						
			For Each Row_Batch In FilteredRows Do

				If Row_Batch.Date > Row.Date Then
					Break;
				EndIf;

				If Row_Batch.QuantityBalance = 0 Then
					Continue;
				EndIf;

				If NeedExpense = 0 Then
					Continue;
				EndIf;

				If Row_Batch.Company <> Row.Company Then
					Continue;
				EndIf;

				If Not ValueIsFilled(Row_Batch.Batch) Then
					Continue;
				EndIf;
					
				QtyName = ?(Row_Batch.IsPreliminary, "Preliminary", "") + "Quantity";
				ExpenseQuantity = Min(NeedExpense, Row_Batch[QtyName + "Balance"]);

				ExpenseAmounts = New Structure();
				For Each Res In AmountResources() Do
					ExpenseAmounts.Insert(Res, AmountProportionByQuantity(ExpenseQuantity, Row_Batch, Res + "Balance", "QuantityBalance"));
					Row_Batch[Res + "Balance"] = Row_Batch[Res + "Balance"] - ExpenseAmounts[Res];
				EndDo;

				Row_Batch[QtyName + "Balance"] = Row_Batch[QtyName + "Balance"]  - ExpenseQuantity;
				NeedExpense = NeedExpense - ExpenseQuantity;

				If ExpenseQuantity <> 0 Or ExpenseAmounts.InvoiceAmount <> 0 Or ExpenseAmounts.PreliminaryAmount <> 0 Then
					NewRow = Tables.DataForExpense.Add();
					NewRow.Period    = Row.Date;
					NewRow.Document  = Row.Document;
					NewRow.Company   = Row.Company;
					NewRow.Batch     = Row_Batch.Batch;
					NewRow.BatchKey  = Row.BatchKey;

					NewRow[QtyName]  = ExpenseQuantity;
					
					For Each Res In AmountResources() Do
						NewRow[Res] = ExpenseAmounts[Res];
					EndDo;

					NewRow_DataForExpense = DataForExpense.Add();
					FillPropertyValues(NewRow_DataForExpense, NewRow);
					NewRow_DataForExpense.ItemLinkID = Row.ItemLinkID;
						
						// sales batches
					If TypeOf(Row.Document) = Type("DocumentRef.SalesInvoice") 
						Or TypeOf(Row.Document) = Type("DocumentRef.RetailSalesReceipt") Then
						NewRow_SalesBatches = Tables.DataForSalesBatches.Add();
						FillPropertyValues(NewRow_SalesBatches, NewRow);
						NewRow_SalesBatches.SalesInvoice = Row.Document;
					EndIf;
						
						// reallocated batches
					If TypeOf(Row.Document) = Type("DocumentRef.BatchReallocateOutgoing") Then
						NewRow_ReallocatedBatches = Tables.DataForReallocatedBatchesAmountValues.Add();
						FillPropertyValues(NewRow_ReallocatedBatches, NewRow);
						NewRow_ReallocatedBatches.OutgoingDocument = Row.Document;
						NewRow_ReallocatedBatches.IncomingDocument = Row.Document.Incoming;
					EndIf;
					
						// write-off batches
					If TypeOf(Row.Document) = Type("DocumentRef.StockAdjustmentAsWriteOff")
						Or TypeOf(Row.Document) = Type("DocumentRef.WorkSheet") Then
						NewRow_WriteOffBatches = Tables.DataForWriteOffBatches.Add();
						FillPropertyValues(NewRow_WriteOffBatches, NewRow);
						NewRow_WriteOffBatches.ExpenseType      = Row.ExpenseType;
						NewRow_WriteOffBatches.ProfitLossCenter = Row.ProfitLossCenter;
						NewRow_WriteOffBatches.Branch           = Row.Branch;
						NewRow_WriteOffBatches.Currency         = Row.Currency;
						NewRow_WriteOffBatches.RowID            = Row.RowID;
					EndIf;	
						
						// fixed asset
					If TypeOf(Row.Document) = Type("DocumentRef.CommissioningOfFixedAsset")
						Or TypeOf(Row.Document) = Type("DocumentRef.ModernizationOfFixedAsset") Then
						NewRow_DataForFixedAssets = Tables.DataForFixedAssets.Add();
						FillPropertyValues(NewRow_DataForFixedAssets, NewRow);
						NewRow_DataForFixedAssets.FixedAsset       = Row.FixedAsset;						
						NewRow_DataForFixedAssets.Branch           = Row.Branch;						
						NewRow_DataForFixedAssets.ProfitLossCenter = Row.ProfitLossCenter;						
					EndIf;	
						
				EndIf;

			EndDo; // FilteredRows
			
			If RestoreSortByDate Then
				For Each Row_Documents In Tree.Rows Do
					Row_Documents.Rows.Sort("Date");
				EndDo;
			EndIf;

			If NeedExpense <> 0 Then
				// Can not expense Batch key: %1 , Quantity: %2 , Doc: %3'
				Msg = StrTemplate(R().LC_Error_002, GetBatchKeyDetailPresentation(Row.BatchKey), NeedExpense, Row.Document);
				CommonFunctionsClientServer.ShowUsersMessage(Msg);
				If CalculationSettings.RaiseOnCalculationError Then
					Raise Msg;
				EndIf;
				NewRow_ShortageOutgoing = Tables.DataForBatchShortageOutgoing.Add();
				NewRow_ShortageOutgoing.BatchKey = Row.BatchKey;
				NewRow_ShortageOutgoing.Document = Row.Document;
				NewRow_ShortageOutgoing.Company  = Row.Company;
				NewRow_ShortageOutgoing.Period   = Row.Date;
				NewRow_ShortageOutgoing.Quantity = NeedExpense;
			EndIf;
			
		EndIf;
	EndDo;
	
	// Bundling, Unbundling, Transfer, Produce
	TableOfNewReceivedBatches = New ValueTable();
	TableOfNewReceivedBatches.Columns.Add("Batch");
	TableOfNewReceivedBatches.Columns.Add("BatchKey");
	TableOfNewReceivedBatches.Columns.Add("Document");
	TableOfNewReceivedBatches.Columns.Add("Company");
	TableOfNewReceivedBatches.Columns.Add("Date");
	TableOfNewReceivedBatches.Columns.Add("IsOpeningBalance");
	TableOfNewReceivedBatches.Columns.Add("Direction");
	TableOfNewReceivedBatches.Columns.Add("ReturnRow");
	TableOfNewReceivedBatches.Columns.Add("IsPreliminary");

	TableOfNewReceivedBatches.Columns.Add("Quantity", Metadata.DefinedTypes.typeQuantity.Type);
	TableOfNewReceivedBatches.Columns.Add("QuantityBalance", Metadata.DefinedTypes.typeQuantity.Type);

	TableOfNewReceivedBatches.Columns.Add("PreliminaryQuantity", Metadata.DefinedTypes.typeQuantity.Type);
	TableOfNewReceivedBatches.Columns.Add("PreliminaryQuantityBalance", Metadata.DefinedTypes.typeQuantity.Type);
	
	For Each Res In AmountResources() Do
		TableOfNewReceivedBatches.Columns.Add(Res, Metadata.DefinedTypes.typeAmount.Type);
		TableOfNewReceivedBatches.Columns.Add(Res + "Balance", Metadata.DefinedTypes.typeAmount.Type);
	EndDo;
		
	If IsTransferDocument(Document) Or IsShipmentToTradeAgent(Document) Then
		
		CalculateTransferDocument(Rows, Tables, DataForExpense, TableOfNewReceivedBatches, CalculationSettings);
	
	ElsIf IsReturnFromTradeAgent(Document) Then
		
		CalculateTransferDocument(Rows, Tables, DataForExpense, TableOfNewReceivedBatches, CalculationSettings);
	
	ElsIf IsCompositeDocument(Document) Then
		
		CalculateCompositeDocument(Rows, Tables, DataForReceipt, DataForExpense, TableOfNewReceivedBatches);
	
	ElsIf IsDecompositeDocument(Document) Then
		
		CalculateDecompositeDocument(Rows, Tables, DataForReceipt, DataForExpense, TableOfNewReceivedBatches);
	
	ElsIf TypeOf(Document) = Type("DocumentRef.SalesReturn") Or TypeOf(Document) = Type("DocumentRef.RetailReturnReceipt") Then
		For Each Row_Return In TableOfReturnedBatches Do
//			AddTo_TableOfNewReceivedBatches(TableOfNewReceivedBatches, Row_Return, Row_Return.Date, Row_Return.Batch, Row_Return);
			Row_nrb = TableOfNewReceivedBatches.Add();
			Row_nrb.Date = Row_Return.Date;
			Row_nrb.ReturnRow = Row_Return;
			Row_nrb.Batch = Row_return.Batch;

			Row_nrb.Document = Row_return.Document;
			Row_nrb.Company = Row_return.Company;
			Row_nrb.BatchKey = Row_return.BatchKey;
			Row_nrb.IsPreliminary = Row_return.IsPreliminary;

			Row_nrb.IsOpeningBalance = False;
			Row_nrb.Direction = Enums.BatchDirection.Receipt;

			Row_nrb.Quantity = Row_return.Quantity;
			Row_nrb.QuantityBalance = Row_return.Quantity;
			Row_nrb.PreliminaryQuantity = Row_return.PreliminaryQuantity;
			Row_nrb.PreliminaryQuantityBalance = Row_return.PreliminaryQuantity;

			For Each Res In AmountResources() Do
				Row_nrb[Res] = Row_return[Res];
				Row_nrb[Res + "Balance"] = Row_return[Res];
			EndDo;	
		EndDo;
	
		For Each Row_ReceiveBatch In TableOfNewReceivedBatches Do 
			Filter = New Structure();
			Filter.Insert("Batch"    , Row_ReceiveBatch.Batch);
			Filter.Insert("BatchKey" , Row_ReceiveBatch.BatchKey);
			Filter.Insert("Company"  , Row_ReceiveBatch.Company);
			Filter.Insert("Direction", Row_ReceiveBatch.Direction);
			
			QtyName = ?(Row_ReceiveBatch.IsPreliminary, "Preliminary", "") + "Quantity";

			FoundedRows = Tree.Rows.FindRows(Filter, True);
			QuantityBalanceIsFilled = False;
			For Each FoundedRow In FoundedRows Do
				If ValueIsFilled(FoundedRow[QtyName + "Balance"]) Then
					QuantityBalanceIsFilled = True;
					Break;
				EndIf;
			EndDo;
			
			If QuantityBalanceIsFilled Then
				Continue;
			EndIf;
		    Row_ReceiveBatch.ReturnRow.AlreadyReceived = True;
			FillPropertyValues(Rows.Add(), Row_ReceiveBatch);
		EndDo;
		RemoveRowsWithEmptyAmountBalance(Rows);
		
	ElsIf TypeOf(Document) = Type("DocumentRef.BatchReallocateIncoming") Then

		For Each Row_Receipt In DataForReceipt Do
			NewRow = Tables.DataForReceipt.Add();
			FillPropertyValues(NewRow, Row_Receipt);

			Filter = New Structure();
			Filter.Insert("BatchKey"        , Row_Receipt.BatchKey);
			Filter.Insert("IncomingDocument", Document);
			Filter.Insert("OutgoingDocument", Document.Outgoing);
			
			FilteredRows = Tables.DataForReallocatedBatchesAmountValues.FindRows(Filter);
			
			ReallocatedAmounts = New Structure();
			For Each Res In AmountResources() Do 
				ReallocatedAmounts.Insert(Res, 0);
			EndDo;
	
			QtyName = ?(Row_Receipt.IsPreliminary, "Preliminary", "") + "Quantity";
			Reallocated_Qty  = 0;
			If FilteredRows.Count() Then
				For Each FilteredRow In FilteredRows Do
					For Each Res In AmountResources() Do
						ReallocatedAmounts[Res] = ReallocatedAmounts[Res] + FilteredRow[Res];
					EndDo;					
					Reallocated_Qty  = Reallocated_Qty + FilteredRow[QtyName];
				EndDo;
			Else
				QuerySelection = GetReallocatedBatchesAmount(Filter);
				If QuerySelection.Next() Then
					For Each Res In AmountResources() Do
						ReallocatedAmounts[Res] = QuerySelection[Res];
					EndDo;					
					Reallocated_Qty  = QuerySelection[QtyName];
				EndIf;
			EndIf;

			For Each Res In AmountResources() Do
				If NewRow[QtyName] = Reallocated_Qty Then
					NewRow[Res] = ReallocatedAmounts[Res]; // all amounts
				ElsIf Reallocated_Qty <> 0 Then
					NewRow[Res] = NewRow[QtyName] * (ReallocatedAmounts[Res] / Reallocated_Qty); // proportion amounts	
				Else // Reallocated_Qty = 0
					NewRow[Res] = 0;
				EndIf;
			EndDo;
//			AddTo_TableOfNewReceivedBatches(TableOfNewReceivedBatches, NewRow, NewRow.Period, NewRow.Batch);			
			Row_nrb = TableOfNewReceivedBatches.Add();
			Row_nrb.Date = NewRow.Period;
			Row_nrb.Batch = NewRow.Batch;

			Row_nrb.Document = NewRow.Document;
			Row_nrb.Company = NewRow.Company;
			Row_nrb.BatchKey = NewRow.BatchKey;
			Row_nrb.IsPreliminary = NewRow.IsPreliminary;

			Row_nrb.IsOpeningBalance = False;
			Row_nrb.Direction = Enums.BatchDirection.Receipt;

			Row_nrb.Quantity = NewRow.Quantity;
			Row_nrb.QuantityBalance = NewRow.Quantity;
			Row_nrb.PreliminaryQuantity = NewRow.PreliminaryQuantity;
			Row_nrb.PreliminaryQuantityBalance = NewRow.PreliminaryQuantity;

			For Each Res In AmountResources() Do
				Row_nrb[Res] = NewRow[Res];
				Row_nrb[Res + "Balance"] = NewRow[Res];
			EndDo;	
			
		EndDo;

		For Each Row In TableOfNewReceivedBatches Do
			FillPropertyValues(Rows.Add(), Row);
		EndDo;
		RemoveRowsWithEmptyAmountBalance(Rows);
	EndIf;
EndProcedure

Procedure CalculateTransferDocument(Rows, Tables, DataForExpense, TableOfNewReceivedBatches, CalculationSettings)
	For Each Row In Rows Do
		If Not (Row.Direction = Enums.BatchDirection.Receipt And Not Row.IsOpeningBalance) Then
			Continue;
		EndIf;

		QtyName = ?(Row.IsPreliminary, "Preliminary", "") + "Quantity";
		NeedReceipt = Row[QtyName];
		
		For Each Row_Expense In DataForExpense Do
			If NeedReceipt = 0 Then
				Continue;
			EndIf;
				
			If Row.BatchKey.ItemKey <> Row_Expense.BatchKey.ItemKey Then
				Continue;
			EndIf;
				
			If Row.BatchKey.SerialLotNumber <> Row_Expense.BatchKey.SerialLotNumber Then
				Continue;
			EndIf;
				
			If Row.BatchKey.SourceOfOrigin <> Row_Expense.BatchKey.SourceOfOrigin Then
				Continue;
			EndIf;
				
			NeedReceipt = NeedReceipt - Row_Expense[QtyName];

			NewRow = Tables.DataForReceipt.Add();
			NewRow.Batch     = Row_Expense.Batch;
			NewRow.BatchKey  = Row.BatchKey;
			NewRow.Document  = Row.Document;
			NewRow.Company   = Row.Company;
			NewRow.Period    = Row.Date;
				
			NewRow.Quantity  = Row_Expense.Quantity;
			NewRow.PreliminaryQuantity  = Row_Expense.PreliminaryQuantity;
				
			For Each Res In AmountResources() Do
				NewRow[Res] = Row_Expense[Res];
			EndDo;
//			AddTo_TableOfNewReceivedBatches(TableOfNewReceivedBatches, Row, Row.Date, Row_Expense.Batch);
			Row_nrb = TableOfNewReceivedBatches.Add();
			Row_nrb.Date = Row.Date;
			Row_nrb.Batch = Row_Expense.Batch;

			Row_nrb.Document = Row.Document;
			Row_nrb.Company = Row.Company;
			Row_nrb.BatchKey = Row.BatchKey;
			Row_nrb.IsPreliminary = Row_Expense.IsPreliminary;

			Row_nrb.IsOpeningBalance = False;
			Row_nrb.Direction = Enums.BatchDirection.Receipt;

			Row_nrb.Quantity = Row_Expense.Quantity;
			Row_nrb.QuantityBalance = Row_Expense.Quantity;
			Row_nrb.PreliminaryQuantity = Row_Expense.PreliminaryQuantity;
			Row_nrb.PreliminaryQuantityBalance = Row_Expense.PreliminaryQuantity;

			For Each Res In AmountResources() Do
				Row_nrb[Res] = Row_Expense[Res];
				Row_nrb[Res + "Balance"] = Row_Expense[Res];
			EndDo;	
			
		EndDo; // DataForExpense

		If NeedReceipt <> 0 Then
			// Can not receipt Batch key
			Msg = StrTemplate(R().LC_Error_003, GetBatchKeyDetailPresentation(Row.BatchKey), NeedReceipt, Row.Document);
			CommonFunctionsClientServer.ShowUsersMessage(Msg);
			If CalculationSettings.RaiseOnCalculationError Then
				Raise Msg;
			EndIf;
			NewRow = Tables.DataForBatchShortageIncoming.Add();
			NewRow.BatchKey = Row.BatchKey;
			NewRow.Document = Row.Document;
			NewRow.Company  = Row.Company;
			NewRow.Period   = Row.Date;
			NewRow.Quantity = NeedReceipt;
		EndIf;
		
	EndDo; // Rows

	For Each Row In TableOfNewReceivedBatches Do
		FillPropertyValues(Rows.Add(), Row);
	EndDo;

	RemoveRowsWithEmptyAmountBalance(Rows);
EndProcedure

Procedure CalculateCompositeDocument(Rows, Tables, DataForReceipt, DataForExpense, TableOfNewReceivedBatches)
	For Each Row_Receipt In DataForReceipt Do
		NewRow = Tables.DataForReceipt.Add();
		FillPropertyValues(NewRow, Row_Receipt);
		
		TotalExpenses = New Structure();
		For Each Res In AmountResources() Do
			TotalExpenses.Insert(Res, DataForExpense.Total(Res));
		EndDo;
			
		For Each Row_Expense In DataForExpense Do
			
			If ValueIsFilled(Row_Receipt.ItemLinkID) Then
				If Row_Receipt.ItemLinkID <> Row_Expense.ItemLinkID Then
					Continue;
				EndIf;
			EndIf;
			
			For Each Res In AmountResources() Do
				NewRow[Res] = NewRow[Res] + Row_Expense[Res];
			EndDo;
			
			If TypeOf(Row_Expense.Document) = Type("DocumentRef.Bundling") Then
				NewRowBundleAmountValues = Tables.DataForBundleAmountValues.Add();
				NewRowBundleAmountValues.Batch          = Row_Expense.Batch;
				NewRowBundleAmountValues.BatchKey       = Row_Expense.BatchKey;
				NewRowBundleAmountValues.Company        = Row_Expense.Company;
				NewRowBundleAmountValues.Period         = Row_Expense.Period;
				NewRowBundleAmountValues.BatchKeyBundle = Row_Receipt.BatchKey;

				For Each Res In AmountResources() Do
					If TotalExpenses[Res] <> 0 And Row_Expense[Res] <> 0 Then
						NewRowBundleAmountValues[Res] = Row_Expense[Res] / (TotalExpenses[Res] / 100);
					EndIf;
				EndDo;				
			Else
				NewRowCompositeBatchesAmountValues = Tables.DataForCompositeBatchesAmountValues.Add();
				NewRowCompositeBatchesAmountValues.Batch     = Row_Expense.Batch;
				NewRowCompositeBatchesAmountValues.BatchKey  = Row_Expense.BatchKey;
				NewRowCompositeBatchesAmountValues.Company   = Row_Expense.Company;
				NewRowCompositeBatchesAmountValues.Period    = Row_Expense.Period;
				NewRowCompositeBatchesAmountValues.BatchComposite    = Row_Receipt.Batch;
				NewRowCompositeBatchesAmountValues.BatchKeyComposite = Row_Receipt.BatchKey;

				NewRowCompositeBatchesAmountValues.Quantity  = Row_Expense.Quantity;
				NewRowCompositeBatchesAmountValues.PreliminaryQuantity  = Row_Expense.PreliminaryQuantity;
				
				For Each Res In AmountResources() Do
					NewRowCompositeBatchesAmountValues[Res] = Row_Expense[Res];
				EndDo;
			EndIf;
		EndDo; // DataForExpense

		If TypeOf(Row_Receipt.Document) = Type("DocumentRef.Production") Then

			NewRow.ExtraDirectCostAmount    = NewRow.ExtraDirectCostAmount + Row_Receipt.Document.ExtraDirectCostAmount;
			NewRow.ExtraDirectCostTaxAmount = NewRow.ExtraDirectCostTaxAmount + Row_Receipt.Document.ExtraDirectCostTaxAmount;
			
			_ExtraCostAmountByRatio = Row_Receipt.Document.ExtraCostAmountByRatio;
			If _ExtraCostAmountByRatio <> 0 Then
				_totalAmount = 
					NewRow.InvoiceAmount
					+ NewRow.PreliminaryAmount 
					+ NewRow.IndirectCostAmount
					+ NewRow.ExtraCostAmountByRatio 
					+ NewRow.ExtraDirectCostAmount
					+ NewRow.AllocatedCostAmount
					+ NewRow.AllocatedRevenueAmount;
								
				NewRow.ExtraCostAmountByRatio = (_totalAmount / 100 * _ExtraCostAmountByRatio) + NewRow.ExtraCostAmountByRatio;
			EndIf;	
			
			_ExtraCostTaxAmountByRatio = Row_Receipt.Document.ExtraCostTaxAmountByRatio;
			If _ExtraCostTaxAmountByRatio <> 0 Then	  
				_totalTaxAmount = 
					NewRow.InvoiceTaxAmount
					+ NewRow.PreliminaryTaxAmount
					+ NewRow.IndirectCostTaxAmount
					+ NewRow.ExtraCostTaxAmountByRatio 
					+ NewRow.ExtraDirectCostTaxAmount 
					+ NewRow.AllocatedCostTaxAmount 
					+ NewRow.AllocatedRevenueTaxAmount; 

                NewRow.ExtraCostTaxAmountByRatio = (_totalTaxAmount / 100 * _ExtraCostTaxAmountByRatio) + NewRow.ExtraCostTaxAmountByRatio;
			EndIf;	
		EndIf;
//		AddTo_TableOfNewReceivedBatches(TableOfNewReceivedBatches, NewRow, NewRow.Period, NewRow.Batch);
		Row_nrb = TableOfNewReceivedBatches.Add();
		Row_nrb.Date = NewRow.Period;
		Row_nrb.Batch = NewRow.Batch;

		Row_nrb.Document = NewRow.Document;
		Row_nrb.Company = NewRow.Company;
		Row_nrb.BatchKey = NewRow.BatchKey;
		Row_nrb.IsPreliminary = NewRow.IsPreliminary;

		Row_nrb.IsOpeningBalance = False;
		Row_nrb.Direction = Enums.BatchDirection.Receipt;

		Row_nrb.Quantity = NewRow.Quantity;
		Row_nrb.QuantityBalance = NewRow.Quantity;
		Row_nrb.PreliminaryQuantity = NewRow.PreliminaryQuantity;
		Row_nrb.PreliminaryQuantityBalance = NewRow.PreliminaryQuantity;

		For Each Res In AmountResources() Do
			Row_nrb[Res] = NewRow[Res];
			Row_nrb[Res + "Balance"] = NewRow[Res];
		EndDo;	
		
	EndDo; // DataForReceipt

	ArrayForDelete = New Array();
	For Each Row In TableOfNewReceivedBatches Do
		If ValueIsFilled(Row.InvoiceAmountBalance) Then
			For Each Row2 In Rows Do
				If Row.Batch = Row2.Batch 
					And Row.BatchKey = Row2.BatchKey 
					And Row.Direction = Row2.Direction 
					And Not ValueIsFilled(Row2.InvoiceAmountBalance) 
					And ArrayForDelete.Find(Row2) = Undefined Then

					ArrayForDelete.Add(Row2);
				EndIf;
			EndDo;
		EndIf;
		FillPropertyValues(Rows.Add(), Row);
	EndDo;

	For Each Row In ArrayForDelete Do
		Rows.Delete(Row);
	EndDo;
EndProcedure

Procedure CalculateDecompositeDocument(Rows, Tables, DataForReceipt, DataForExpense, TableOfNewReceivedBatches)
	For Each Row_Receipt In DataForReceipt Do
		NewRow = Tables.DataForReceipt.Add();
		FillPropertyValues(NewRow, Row_Receipt);
		For Each Row_Expense In DataForExpense Do
			If Not ValueIsFilled(Row_Expense.InvoiceAmount) Then
				Continue;
			EndIf;

			BundleAmountValues = GetBundleAmountValues(Tables.DataForBundleAmountValues, Row_Receipt, Row_Expense);
			For Each Row In BundleAmountValues Do
				For Each Res In AmountResources() Do
					NewRow[Res] = NewRow[Res] + (Row_Expense[Res] / 100 * Row[Res]);
				EndDo;
			EndDo;
		EndDo;
//		AddTo_TableOfNewReceivedBatches(TableOfNewReceivedBatches, NewRow, NewRow.Period, NewRow.Batch);
		Row_nrb = TableOfNewReceivedBatches.Add();
		Row_nrb.Date = NewRow.Period;
		Row_nrb.Batch = NewRow.Batch;

		Row_nrb.Document = NewRow.Document;
		Row_nrb.Company = NewRow.Company;
		Row_nrb.BatchKey = NewRow.BatchKey;
		Row_nrb.IsPreliminary = NewRow.IsPreliminary;

		Row_nrb.IsOpeningBalance = False;
		Row_nrb.Direction = Enums.BatchDirection.Receipt;

		Row_nrb.Quantity = NewRow.Quantity;
		Row_nrb.QuantityBalance = NewRow.Quantity;
		Row_nrb.PreliminaryQuantity = NewRow.PreliminaryQuantity;
		Row_nrb.PreliminaryQuantityBalance = NewRow.PreliminaryQuantity;

		For Each Res In AmountResources() Do
			Row_nrb[Res] = NewRow[Res];
			Row_nrb[Res + "Balance"] = NewRow[Res];
		EndDo;
	EndDo;

	For Each Row In TableOfNewReceivedBatches Do
		FillPropertyValues(Rows.Add(), Row);
	EndDo;

	RemoveRowsWithEmptyAmountBalance(Rows);
EndProcedure

Function GetBundleAmountValues(DataForBundleAmountValues, Row_Receipt, Row_Expense)
	Query = New Query();
	Query.Text =
	"SELECT
	|	tmp.BatchKey,
	|	tmp.Company,
	|	tmp.BatchKeyBundle,
	|	tmp.InvoiceAmount,
	|	tmp.InvoiceTaxAmount,
	|	tmp.IndirectCostAmount,
	|	tmp.IndirectCostTaxAmount,
	|	tmp.ExtraCostAmountByRatio,
	|	tmp.ExtraCostTaxAmountByRatio,
	|	tmp.ExtraDirectCostAmount,
	|	tmp.ExtraDirectCostTaxAmount,
	|	tmp.AllocatedCostAmount,
	|	tmp.AllocatedCostTaxAmount,
	|	tmp.AllocatedRevenueAmount,
	|	tmp.AllocatedRevenueTaxAmount,
	|	tmp.PreliminaryAmount,
	|	tmp.PreliminaryTaxAmount
	|INTO DataForBundleAmountValues
	|FROM
	|	&DataForBundleAmountValues AS tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.BatchKey,
	|	tmp.Company,
	|	tmp.BatchKeyBundle,
	|	tmp.InvoiceAmount,
	|	tmp.InvoiceTaxAmount,
	|	tmp.IndirectCostAmount,
	|	tmp.IndirectCostTaxAmount,
	|	tmp.ExtraCostAmountByRatio,
	|	tmp.ExtraCostTaxAmountByRatio,
	|	tmp.ExtraDirectCostAmount,
	|	tmp.ExtraDirectCostTaxAmount,
	|	tmp.AllocatedCostAmount,
	|	tmp.AllocatedCostTaxAmount,
	|	tmp.AllocatedRevenueAmount,
	|	tmp.AllocatedRevenueTaxAmount,
	|	tmp.PreliminaryAmount,
	|	tmp.PreliminaryTaxAmount
	|FROM
	|	DataForBundleAmountValues AS tmp
	|WHERE
	|	tmp.BatchKey = &BatchKey
	|	AND tmp.Company = &Company
	|	AND tmp.BatchKeyBundle = &BatchKeyBundle
	|
	|UNION
	|
	|SELECT
	|	Reg.BatchKey,
	|	Reg.Company,
	|	Reg.BatchKeyBundle,
	|	Reg.InvoiceAmount,
	|	Reg.InvoiceTaxAmount,
	|	Reg.IndirectCostAmount,
	|	Reg.IndirectCostTaxAmount,
	|	Reg.ExtraCostAmountByRatio,
	|	Reg.ExtraCostTaxAmountByRatio,
	|	Reg.ExtraDirectCostAmount,
	|	Reg.ExtraDirectCostTaxAmount,
	|	Reg.AllocatedCostAmount,
	|	Reg.AllocatedCostTaxAmount,
	|	Reg.AllocatedRevenueAmount,
	|	Reg.AllocatedRevenueTaxAmount,
	|	Reg.PreliminaryAmount,
	|	Reg.PreliminaryTaxAmount
	|FROM
	|	InformationRegister.T6040S_BundleAmountValues AS Reg
	|WHERE
	|	Reg.BatchKey = &BatchKey
	|	AND Reg.Company = &Company
	|	AND Reg.BatchKeyBundle = &BatchKeyBundle
	|
	|UNION
	|
	|SELECT
	|	BatchKeys.Ref,
	|	Reg.Company,
	|	BatchKeys_Bundle.Ref,
	|	Reg.InvoiceAmount,
	|	Reg.InvoiceTaxAmount,
	|	Reg.IndirectCostAmount,
	|	Reg.IndirectCostTaxAmount,
	|	Reg.ExtraCostAmountByRatio,
	|	Reg.ExtraCostTaxAmountByRatio,
	|	Reg.ExtraDirectCostAmount,
	|	Reg.ExtraDirectCostTaxAmount,
	|	Reg.AllocatedCostAmount,
	|	Reg.AllocatedCostTaxAmount,
	|	Reg.AllocatedRevenueAmount,
	|	Reg.AllocatedRevenueTaxAmount,
	|	Reg.PreliminaryAmount,
	|	Reg.PreliminaryTaxAmount
	|FROM
	|	InformationRegister.T6050S_ManualBundleAmountValues AS Reg
	|		INNER JOIN Catalog.BatchKeys AS BatchKeys
	|		ON Reg.ItemKey = BatchKeys.ItemKey
	|		AND Reg.Store = BatchKeys.Store
	|		INNER JOIN Catalog.BatchKeys AS BatchKeys_Bundle
	|		ON Reg.Bundle = BatchKeys_Bundle.ItemKey
	|		AND Reg.Store = BatchKeys_Bundle.Store
	|WHERE
	|	Reg.Company = &Company
	|	AND Reg.ItemKey = &ItemKey
	|	AND Reg.Bundle = &Bundle
	|	AND Reg.Store = &Store";

	Query.SetParameter("DataForBundleAmountValues", DataForBundleAmountValues);
	Query.SetParameter("BatchKeyBundle", Row_Expense.BatchKey);
	Query.SetParameter("BatchKey" , Row_Receipt.BatchKey);
	Query.SetParameter("Company"  , Row_Expense.Company);
	Query.SetParameter("ItemKey"  , Row_Receipt.BatchKey.ItemKey);
	Query.SetParameter("Bundle"   , Row_Expense.BatchKey.ItemKey);
	Query.SetParameter("Store"    , Row_Receipt.BatchKey.Store);

	Table_AmountValues = Query.Execute().Unload();
	Return Table_AmountValues;
EndFunction

Function GetSalesBatches(SalesInvoice, DataForSalesBatches, BatchKey)
	Query = New Query();
	Query.Text =
	"SELECT
	|	DataForSalesBatches.Period AS Date,
	|	DataForSalesBatches.Batch AS Batch,
	|	DataForSalesBatches.BatchKey AS BatchKey,
	|	DataForSalesBatches.SalesInvoice AS SalesInvoice,
	|	DataForSalesBatches.Quantity AS Quantity,
	|	DataForSalesBatches.PreliminaryQuantity AS PreliminaryQuantity,
	|	DataForSalesBatches.InvoiceAmount AS InvoiceAmount,
	|	DataForSalesBatches.InvoiceTaxAmount AS InvoiceTaxAmount,
	|	DataForSalesBatches.IndirectCostAmount AS IndirectCostAmount,
	|	DataForSalesBatches.IndirectCostTaxAmount AS IndirectCostTaxAmount,
	|	DataForSalesBatches.ExtraCostAmountByRatio AS ExtraCostAmountByRatio,
	|	DataForSalesBatches.ExtraCostTaxAmountByRatio AS ExtraCostTaxAmountByRatio,
	|	DataForSalesBatches.ExtraDirectCostAmount AS ExtraDirectCostAmount,
	|	DataForSalesBatches.ExtraDirectCostTaxAmount AS ExtraDirectCostTaxAmount,
	|	DataForSalesBatches.AllocatedCostAmount AS AllocatedCostAmount,
	|	DataForSalesBatches.AllocatedCostTaxAmount AS AllocatedCostTaxAmount,
	|	DataForSalesBatches.AllocatedRevenueAmount AS AllocatedRevenueAmount,
	|	DataForSalesBatches.AllocatedRevenueTaxAmount AS AllocatedRevenueTaxAmount,
	|	DataForSalesBatches.PreliminaryAmount AS PreliminaryAmount,
	|	DataForSalesBatches.PreliminaryTaxAmount AS PreliminaryTaxAmount
	|INTO DataForSalesBatches
	|FROM
	|	&DataForSalesBatches AS DataForSalesBatches
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R6050T_SalesBatchesTurnovers.Period AS Date,
	|	R6050T_SalesBatchesTurnovers.Batch AS Batch,
	|	R6050T_SalesBatchesTurnovers.BatchKey AS BatchKey,
	|	R6050T_SalesBatchesTurnovers.SalesInvoice AS SalesInvoice,
	|	R6050T_SalesBatchesTurnovers.QuantityTurnover AS Quantity,
	|	R6050T_SalesBatchesTurnovers.PreliminaryQuantityTurnover AS PreliminaryQuantity,
	|	R6050T_SalesBatchesTurnovers.InvoiceAmountTurnover AS InvoiceAmount,
	|	R6050T_SalesBatchesTurnovers.InvoiceTaxAmountTurnover AS InvoiceTaxAmount,
	|	R6050T_SalesBatchesTurnovers.IndirectCostAmountTurnover AS IndirectCostAmount,
	|	R6050T_SalesBatchesTurnovers.IndirectCostTaxAmountTurnover AS IndirectCostTaxAmount,
	|	R6050T_SalesBatchesTurnovers.ExtraCostAmountByRatioTurnover AS ExtraCostAmountByRatio,
	|	R6050T_SalesBatchesTurnovers.ExtraCostTaxAmountByRatioTurnover AS ExtraCostTaxAmountByRatio,
	|	R6050T_SalesBatchesTurnovers.ExtraDirectCostAmountTurnover AS ExtraDirectCostAmount,
	|	R6050T_SalesBatchesTurnovers.ExtraDirectCostTaxAmountTurnover AS ExtraDirectCostTaxAmount,
	|	R6050T_SalesBatchesTurnovers.AllocatedCostAmountTurnover AS AllocatedCostAmount,
	|	R6050T_SalesBatchesTurnovers.AllocatedCostTaxAmountTurnover AS AllocatedCostTaxAmount,
	|	R6050T_SalesBatchesTurnovers.AllocatedRevenueAmountTurnover AS AllocatedRevenueAmount,
	|	R6050T_SalesBatchesTurnovers.AllocatedRevenueTaxAmountTurnover AS AllocatedRevenueTaxAmount,
	|	R6050T_SalesBatchesTurnovers.PreliminaryAmountTurnover AS PreliminaryAmount,
	|	R6050T_SalesBatchesTurnovers.PreliminaryTaxAmountTurnover AS PreliminaryTaxAmount
	|INTO SalesBatches
	|FROM
	|	AccumulationRegister.R6050T_SalesBatches.Turnovers(, , Record, SalesInvoice = &SalesInvoice
	|	AND BatchKey.ItemKey = &BatchKey_ItemKey
	|	AND BatchKey.SerialLotNumber = &BatchKey_SerialLotNumber
	|	AND BatchKey.SourceOfOrigin = &BatchKey_SourceOfOrigin) AS R6050T_SalesBatchesTurnovers
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	DataForSalesBatches.Batch AS Batch,
	|	DataForSalesBatches.BatchKey AS BatchKey,
	|	DataForSalesBatches.SalesInvoice AS SalesInvoice,
	|	DataForSalesBatches.Quantity AS Quantity,
	|	DataForSalesBatches.PreliminaryQuantity AS PreliminaryQuantity,
	|	DataForSalesBatches.InvoiceAmount AS InvoiceAmount,
	|	DataForSalesBatches.InvoiceTaxAmount AS InvoiceTaxAmount,
	|	DataForSalesBatches.IndirectCostAmount AS IndirectCostAmount,
	|	DataForSalesBatches.IndirectCostTaxAmount AS IndirectCostTaxAmount,
	|	DataForSalesBatches.ExtraCostAmountByRatio AS ExtraCostAmountByRatio,
	|	DataForSalesBatches.ExtraCostTaxAmountByRatio AS ExtraCostTaxAmountByRatio,
	|	DataForSalesBatches.ExtraDirectCostAmount AS ExtraDirectCostAmount,
	|	DataForSalesBatches.ExtraDirectCostTaxAmount AS ExtraDirectCostTaxAmount,
	|	DataForSalesBatches.AllocatedCostAmount AS AllocatedCostAmount,
	|	DataForSalesBatches.AllocatedCostTaxAmount AS AllocatedCostTaxAmount,
	|	DataForSalesBatches.AllocatedRevenueAmount AS AllocatedRevenueAmount,
	|	DataForSalesBatches.AllocatedRevenueTaxAmount AS AllocatedRevenueTaxAmount,
	|	DataForSalesBatches.PreliminaryAmount AS PreliminaryAmount,
	|	DataForSalesBatches.PreliminaryTaxAmount AS PreliminaryTaxAmount,
	|	DataForSalesBatches.Date AS Date
	|INTO AllData
	|FROM
	|	DataForSalesBatches AS DataForSalesBatches
	|WHERE
	|	DataForSalesBatches.SalesInvoice = &SalesInvoice
	|	AND DataForSalesBatches.BatchKey.ItemKey = &BatchKey_ItemKey
	|	AND DataForSalesBatches.BatchKey.SerialLotNumber = &BatchKey_SerialLotNumber
	|	AND DataForSalesBatches.BatchKey.SourceOfOrigin = &BatchKey_SourceOfOrigin
	|
	|UNION ALL
	|
	|SELECT
	|	SalesBatches.Batch,
	|	SalesBatches.BatchKey,
	|	SalesBatches.SalesInvoice,
	|	SalesBatches.Quantity,
	|	SalesBatches.PreliminaryQuantity,
	|	SalesBatches.InvoiceAmount,
	|	SalesBatches.InvoiceTaxAmount,
	|	SalesBatches.IndirectCostAmount,
	|	SalesBatches.IndirectCostTaxAmount,
	|	SalesBatches.ExtraCostAmountByRatio,
	|	SalesBatches.ExtraCostTaxAmountByRatio,
	|	SalesBatches.ExtraDirectCostAmount,
	|	SalesBatches.ExtraDirectCostTaxAmount,
	|	SalesBatches.AllocatedCostAmount,
	|	SalesBatches.AllocatedCostTaxAmount,
	|	SalesBatches.AllocatedRevenueAmount,
	|	SalesBatches.AllocatedRevenueTaxAmount,
	|	SalesBatches.PreliminaryAmount,
	|	SalesBatches.PreliminaryTaxAmount,
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
	|	SUM(AllData.PreliminaryQuantity) AS PreliminaryQuantity,
	|	SUM(AllData.InvoiceAmount) AS InvoiceAmount,
	|	SUM(AllData.InvoiceTaxAmount) AS InvoiceTaxAmount,
	|	SUM(AllData.IndirectCostAmount) AS IndirectCostAmount,
	|	SUM(AllData.IndirectCostTaxAmount) AS IndirectCostTaxAmount,
	|	SUM(AllData.ExtraCostAmountByRatio) AS ExtraCostAmountByRatio,
	|	SUM(AllData.ExtraCostTaxAmountByRatio) AS ExtraCostTaxAmountByRatio,
	|	SUM(AllData.ExtraDirectCostAmount) AS ExtraDirectCostAmount,
	|	SUM(AllData.ExtraDirectCostTaxAmount) AS ExtraDirectCostTaxAmount,
	|	SUM(AllData.AllocatedCostAmount) AS AllocatedCostAmount,
	|	SUM(AllData.AllocatedCostTaxAmount) AS AllocatedCostTaxAmount,
	|	SUM(AllData.AllocatedRevenueAmount) AS AllocatedRevenueAmount,
	|	SUM(AllData.AllocatedRevenueTaxAmount) AS AllocatedRevenueTaxAmount,
	|	SUM(AllData.PreliminaryAmount) AS PreliminaryAmount,
	|	SUM(AllData.PreliminaryTaxAmount) AS PreliminaryTaxAmount,
	|	AllData.Batch.Document AS Document,
	|	AllData.Date AS Date,
	|	AllData.Batch.Company AS Company,
	|	(SUM(AllData.PreliminaryQuantity) > 0) AS IsPreliminary
	|FROM
	|	AllData AS AllData
	|GROUP BY
	|	AllData.Batch,
	|	AllData.BatchKey,
	|	AllData.SalesInvoice,
	|	AllData.Batch.Document,
	|	AllData.Date,
	|	AllData.Batch.Company
	|ORDER BY
	|	Date";
	Query.SetParameter("SalesInvoice"             , SalesInvoice);
	Query.SetParameter("DataForSalesBatches"      , DataForSalesBatches);
	Query.SetParameter("BatchKey_ItemKey"         , BatchKey.ItemKey);
	Query.SetParameter("BatchKey_SerialLotNumber" , BatchKey.SerialLotNumber);
	Query.SetParameter("BatchKey_SourceOfOrigin"  , BatchKey.SourceOfOrigin);
	Table_SalesBatches = Query.Execute().Unload();
	Return Table_SalesBatches;
EndFunction

Function GetBatchKeyDetailPresentation(BatchKey)
	BatchKey_Code = "";
	BatchKey_ItemKey_Code = "";
	BatchKey_Store = "";
	If ValueIsFilled(BatchKey) Then
		BatchKey_Code = BatchKey.Code;
						
		If ValueIsFilled(BatchKey.ItemKey) Then
			BatchKey_ItemKey_Code = BatchKey.ItemKey.Code;
		EndIf;
						
		If ValueIsFilled(BatchKey.Store) Then
			BatchKey_Store = BatchKey.Store;
		EndIf;
						
	EndIf;
					
	BatchKeyPresentation = StrTemplate("Btach key:[%1] Code:[%2] Item key code:[%3] Store:[%4]",
		BatchKey, BatchKey_Code, BatchKey_ItemKey_Code, BatchKey_Store);
	
	Return BatchKeyPresentation;
EndFunction			

Function GetReallocatedBatchesAmount(Filter)
	Query = New Query();
	Query.Text =
	"SELECT
	|	ISNULL(SUM(Reg.InvoiceAmount), 0) AS InvoiceAmount,
	|	ISNULL(SUM(Reg.InvoiceTaxAmount), 0) AS InvoiceTaxAmount,
	|	ISNULL(SUM(Reg.IndirectCostAmount), 0) AS IndirectCostAmount,
	|	ISNULL(SUM(Reg.IndirectCostTaxAmount), 0) AS IndirectCostTaxAmount,
	|	ISNULL(SUM(Reg.ExtraCostAmountByRatio), 0) AS ExtraCostAmountByRatio,
	|	ISNULL(SUM(Reg.ExtraCostTaxAmountByRatio), 0) AS ExtraCostTaxAmountByRatio,
	|	ISNULL(SUM(Reg.ExtraDirectCostAmount), 0) AS ExtraDirectCostAmount,
	|	ISNULL(SUM(Reg.ExtraDirectCostTaxAmount), 0) AS ExtraDirectCostTaxAmount,
	|	ISNULL(SUM(Reg.AllocatedCostAmount), 0) AS AllocatedCostAmount,
	|	ISNULL(SUM(Reg.AllocatedCostTaxAmount), 0) AS AllocatedCostTaxAmount,
	|	ISNULL(SUM(Reg.AllocatedRevenueAmount), 0) AS AllocatedRevenueAmount,
	|	ISNULL(SUM(Reg.AllocatedRevenueTaxAmount), 0) AS AllocatedRevenueTaxAmount,
	|	ISNULL(SUM(Reg.Quantity), 0) AS Quantity,
	|	ISNULL(SUM(Reg.PreliminaryQuantity), 0) AS PreliminaryQuantity,
	|	ISNULL(SUM(Reg.PreliminaryAmount), 0) AS PreliminaryAmount,
	|	ISNULL(SUM(Reg.PreliminaryTaxAmount), 0) AS PreliminaryTaxAmount
	|FROM
	|	InformationRegister.T6080S_ReallocatedBatchesAmountValues.SliceLast(, OutgoingDocument = &OutgoingDocument
	|	AND IncomingDocument = &IncomingDocument
	|	AND BatchKey = &BatchKey) AS Reg";
	Query.SetParameter("BatchKey", Filter.BatchKey);
	Query.SetParameter("IncomingDocument", Filter.IncomingDocument);
	Query.SetParameter("OutgoingDocument", Filter.OutgoingDocument);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Return QuerySelection
EndFunction

Function GetPriceForEmptyAmountFromDataForReceipt(ItemKey, Period, DataForReceipt)
	Query = New Query();
	Query.Text =
		"SELECT
		|	TemporaryTable.BatchKey,
		|	TemporaryTable.Period,
		|	TemporaryTable.InvoiceAmount,
		|	TemporaryTable.Quantity
		|INTO VT
		|FROM
		|	&DataForReceipt AS TemporaryTable
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT TOP 1
		|	VT.BatchKey,
		|	VT.Period AS Period,
		|	VT.InvoiceAmount,
		|	VT.Quantity,
		|	CASE
		|		WHEN VT.Quantity = 0
		|			THEN 0
		|		ELSE VT.InvoiceAmount / VT.Quantity
		|	END AS Price
		|FROM
		|	VT AS VT
		|WHERE
		|	VT.BatchKey.ItemKey = &ItemKey
		|	AND VT.Period <= &Period
		|
		|ORDER BY
		|	Period DESC";
	
	Query.SetParameter("Period", Period);
	Query.SetParameter("ItemKey", ItemKey);
	Query.SetParameter("DataForReceipt", DataForReceipt);
	Result = Query.Execute().Select();
	
	If Result.Next() Then 
		Return Result.Price;
	Else
		Return 0;
	EndIf;
EndFunction

Function GetPriceForEmptyAmountFromBatchBalance(ItemKey, Period)
	Query = New Query();
	Query.Text =
		"SELECT TOP 1
		|	BatchBalance.BatchKey,
		|	BatchBalance.Period AS Period,
		|	BatchBalance.InvoiceAmount,
		|	BatchBalance.Quantity,
		|	CASE
		|		WHEN BatchBalance.Quantity = 0
		|			THEN 0
		|		ELSE BatchBalance.InvoiceAmount / BatchBalance.Quantity
		|	END AS Price
		|FROM
		|	AccumulationRegister.R6020B_BatchBalance AS BatchBalance
		|WHERE
		|	BatchBalance.ItemKey = &ItemKey
		|	AND BatchBalance.Period <= &Period
		|	AND BatchBalance.RecordType = VALUE(AccumulationRecordType.Receipt)
		|	AND BatchBalance.InvoiceAmount > 0
		|
		|ORDER BY
		|	Period DESC";
	
	Query.SetParameter("Period", Period);
	Query.SetParameter("ItemKey", ItemKey);
	Result = Query.Execute().Select();
	
	If Result.Next() Then 
		Return Result.Price;
	Else
		Return 0;
	EndIf;
EndFunction

//Procedure AddTo_TableOfNewReceivedBatches(TableOfNewReceivedBatches, Source, Date, Batch, ReturnRow = Undefined)
//	Row = TableOfNewReceivedBatches.Add();
//	Row.Date = Date;
//	Row.ReturnRow = ReturnRow;
//	Row.Batch = Batch;
//
//	Row.Document = Source.Document;
//	Row.Company = Source.Company;
//	Row.BatchKey = Source.BatchKey;
//	Row.IsPreliminary = Source.IsPreliminary;
//
//	Row.IsOpeningBalance = False;
//	Row.Direction = Enums.BatchDirection.Receipt;
//
//	Row.Quantity = Source.Quantity;
//	Row.QuantityBalance = Source.Quantity;
//	Row.PreliminaryQuantity = Source.PreliminaryQuantity;
//	Row.PreliminaryQuantityBalance = Source.PreliminaryQuantity;
//
//	For Each Res In AmountResources() Do
//		Row[Res] = Source[Res];
//		Row[Res + "Balance"] = Source[Res];
//	EndDo;	
//EndProcedure	

Procedure RemoveRowsWithEmptyAmountBalance(RowsCollection)
	ArrayForDelete = New Array();
	For Each Row In RowsCollection Do
		AmtName = ?(Row.IsPreliminary, "Preliminary", "Invoice") + "AmountBalance";
		If Not ValueIsFilled(Row[AmtName]) Then
			ArrayForDelete.Add(Row); // balance amount is 0
		EndIf;
	EndDo;
	For Each Row In ArrayForDelete Do
		RowsCollection.Delete(Row);
	EndDo;
EndProcedure

Function AmountProportionByQuantity(Quantity, Row_Batch, AmountColumnName, QuantityColumnName)
	QtyName = ?(Row_Batch.IsPreliminary, "Preliminary", "") + QuantityColumnName;
	AmountResult = 0;
	If Row_Batch[QtyName] - Quantity = 0 Then
		AmountResult = Row_Batch[AmountColumnName];
	Else
		If Row_Batch[QtyName] <> 0 Then
			AmountResult = Round((Row_Batch[AmountColumnName] / Row_Batch[QtyName]) * Quantity, 2);
		EndIf;
	EndIf;
	Return AmountResult;
EndFunction
