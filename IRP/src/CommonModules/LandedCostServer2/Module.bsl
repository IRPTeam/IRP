
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

Function IsCompositeDocument_Bundling(Document)
	Return TypeOf(Document) = Type("DocumentRef.Bundling");
EndFunction

Function IsCompositeDocument_Production(Document)
	Return TypeOf(Document) = Type("DocumentRef.Production");
EndFunction

Function IsCompositeDocument_ItemStockAdjustment(Document)
	Return TypeOf(Document) = Type("DocumentRef.ItemStockAdjustment");
EndFunction

Function IsCompositeDocument_StockCorrection(Document)
	Return TypeOf(Document) = Type("DocumentRef.StockCorrection");
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
	ArrayOfTypes.Add(Type("DocumentRef.StockCorrection"));
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

Function IsSimpleReceipt(Document, BatchRow)
	If IsNotMultiDirectionDocument(Document) // is not transfer, produce, bundling or unbundling
		And Not ValueIsFilled(BatchRow.SalesInvoice) // is not return by sales invoice
		And TypeOf(Document) <> Type("DocumentRef.BatchReallocateIncoming") // is not receipt by btach reallocation
		And Not IsShipmentToTradeAgent(Document) // sales invoice with transaction type "shipment to trade agent" is multi direction document
		And BatchRow.Direction = Enums.BatchDirection.Receipt Then
		Return True; // is simple receipt
	EndIf;
	Return False; // is not simple receipt	
EndFunction

Function IsReturnBySalesInvoice(Document, BatchRow)
	Return ValueIsFilled(BatchRow.SalesInvoice) And Not IsReturnFromTradeAgent(Document);
EndFunction

Function IsReturnWithoutSalesInvoice(Document, BatchRow)
	Return Not ValueIsFilled(BatchRow.SalesInvoice)
		And (TypeOf(Document) = Type("DocumentRef.SalesReturn") Or TypeOf(Document) = Type("DocumentRef.RetailReturnReceipt"));
EndFunction
	
Function IsReallocateIncomingDocument(Document)
	Return TypeOf(Document) = Type("DocumentRef.BatchReallocateIncoming");
EndFunction

Function IsInvoiceByPreliminary(Document, BatchRow)
	Return TypeOf(Document) = Type("DocumentRef.PurchaseInvoice") And ValueIsFilled(BatchRow.PreliminaryID);
EndFunction

// all documents who can movie batches
Function GetArrayOfBatchDocumentTypes()
	ArrayOfTypes = New Array();
	ArrayOfTypes.Add(Type("DocumentRef.Bundling"));
	ArrayOfTypes.Add(Type("DocumentRef.InventoryTransfer"));
	ArrayOfTypes.Add(Type("DocumentRef.ItemStockAdjustment"));
	ArrayOfTypes.Add(Type("DocumentRef.StockCorrection"));
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

	RecordSetR6010B = AccumulationRegisters.R6010B_BatchWiseBalance.CreateRecordSet();
	RecordSetR6010B.Filter.Recorder.Set(CalculationSettings.CalculationMovementCostRef);
	RecordSetR6010B.Clear();
	RecordSetR6010B.Write();

	RecordSetT6095S = InformationRegisters.T6095S_WriteOffBatchesInfo.CreateRecordSet();
	RecordSetT6095S.Filter.Recorder.Set(CalculationSettings.CalculationMovementCostRef);
	RecordSetT6095S.Clear();
	RecordSetT6095S.Write();
	
	Tables = GetBatchWiseBalance(CalculationSettings);
	
	// for grouping value tables
	_AmountResources = StrConcat(AmountResources(), ",");
	_QuantityResources = "Quantity, PreliminaryQuantity";
	
	RecordSetR6010B = AccumulationRegisters.R6010B_BatchWiseBalance.CreateRecordSet();
	RecordSetR6010B.Filter.Recorder.Set(CalculationSettings.CalculationMovementCostRef);

	// Batch wise balance
	For Each Row In Tables.DataForReceipt Do
	 	NewRecordReceipt = RecordSetR6010B.Add();
	 	FillPropertyValues(NewRecordReceipt, Row);
	 	NewRecordReceipt.Period = Row.Period;
	 	NewRecordReceipt.RecordType = AccumulationRecordType.Receipt;
	 	NewRecordReceipt.Recorder = CalculationSettings.CalculationMovementCostRef;
	EndDo;
	For Each Row In Tables.DataForExpense Do
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

	For Each Row In Tables.DataForBatchShortageOutgoing Do
		NewRecordR6030T = RecordSetR6030T.Add();
		FillPropertyValues(NewRecordR6030T, Row);
		NewRecordR6030T.Period = Row.Period;
		NewRecordR6030T.Recorder = CalculationSettings.CalculationMovementCostRef;
	EndDo;

	RecordSetR6030T.Write();
	
	// Batch shortage incoming
	RecordSetR6040T = AccumulationRegisters.R6040T_BatchShortageIncoming.CreateRecordSet();
	RecordSetR6040T.Filter.Recorder.Set(CalculationSettings.CalculationMovementCostRef);

	For Each Row In Tables.DataForBatchShortageIncoming Do
		NewRecordR6040T = RecordSetR6040T.Add();
		FillPropertyValues(NewRecordR6040T, Row);
		NewRecordR6040T.Period = Row.Period;
		NewRecordR6040T.Recorder = CalculationSettings.CalculationMovementCostRef;
	EndDo;

	RecordSetR6040T.Write();
	
	// Sales batches
	RecordSetR6050T = AccumulationRegisters.R6050T_SalesBatches.CreateRecordSet();
	RecordSetR6050T.Filter.Recorder.Set(CalculationSettings.CalculationMovementCostRef);

	For Each Row In Tables.DataForSalesBatches Do
		NewRecordR6050T = RecordSetR6050T.Add();
		FillPropertyValues(NewRecordR6050T, Row);
		NewRecordR6050T.Period = Row.Period;
		NewRecordR6050T.Recorder = CalculationSettings.CalculationMovementCostRef;
	EndDo;

	RecordSetR6050T.Write();
	
	// Bundle amount values
	RecordSetT6040S = InformationRegisters.T6040S_BundleAmountValues.CreateRecordSet();
	RecordSetT6040S.Filter.Recorder.Set(CalculationSettings.CalculationMovementCostRef);
	Tables.DataForBundleAmountValues.GroupBy(
	"Company, Period, Batch, BatchKey, BatchKeyBundle", _AmountResources);

	For Each Row In Tables.DataForBundleAmountValues Do
		NewRecordT6040S = RecordSetT6040S.Add();
		FillPropertyValues(NewRecordT6040S, Row);
		NewRecordT6040S.Period = Row.Period;
		NewRecordT6040S.Recorder = CalculationSettings.CalculationMovementCostRef;
	EndDo;

	RecordSetT6040S.Write();
	
	// Composite amount values
	RecordSetT6090S = InformationRegisters.T6090S_CompositeBatchesAmountValues.CreateRecordSet();
	RecordSetT6090S.Filter.Recorder.Set(CalculationSettings.CalculationMovementCostRef);
	Tables.DataForCompositeBatchesAmountValues.GroupBy(
	"Company, Period, Batch, BatchKey, BatchComposite, BatchKeyComposite", _AmountResources + "," + _QuantityResources);

	For Each Row In Tables.DataForCompositeBatchesAmountValues Do
		NewRecordT6090S = RecordSetT6090S.Add();
		FillPropertyValues(NewRecordT6090S, Row);
		NewRecordT6090S.Period = Row.Period;
		NewRecordT6090S.Recorder = CalculationSettings.CalculationMovementCostRef;
	EndDo;

	RecordSetT6090S.Write();
	
	// Reallocated amount values
	RecordSetT6080S = InformationRegisters.T6080S_ReallocatedBatchesAmountValues.CreateRecordSet();
	RecordSetT6080S.Filter.Recorder.Set(CalculationSettings.CalculationMovementCostRef);
	Tables.DataForReallocatedBatchesAmountValues.GroupBy(
	"Period, OutgoingDocument, IncomingDocument, BatchKey", _AmountResources + "," + _QuantityResources);

	For Each Row In Tables.DataForReallocatedBatchesAmountValues Do
		NewRecordT6080S = RecordSetT6080S.Add();
		FillPropertyValues(NewRecordT6080S, Row);
		NewRecordT6080S.Period = Row.Period;
		NewRecordT6080S.Recorder = CalculationSettings.CalculationMovementCostRef;
	EndDo;

	RecordSetT6080S.Write();
	
	// Write-off batches
	RecordSet = InformationRegisters.T6095S_WriteOffBatchesInfo.CreateRecordSet();
	RecordSet.Filter.Recorder.Set(CalculationSettings.CalculationMovementCostRef);
	Tables.DataForWriteOffBatches.GroupBy(
	"Period, Document, Company, Branch, ProfitLossCenter, ExpenseType, ItemKey, Currency, RowID, Batch, BatchKey,
	|AmountCorrectionType, CorrectionExpenseRevenueType", 
		_AmountResources + "," + _QuantityResources);
	
	For Each Row In Tables.DataForWriteOffBatches Do
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Period = Row.Period;
		NewRecord.Recorder = CalculationSettings.CalculationMovementCostRef;
	EndDo;

	RecordSet.Write();
	
	// Stock inventory info
	RecordSet = InformationRegisters.T4050_StockInventoryInfo.CreateRecordSet();
	RecordSet.Filter.Recorder.Set(CalculationSettings.CalculationMovementCostRef);
	Tables.DataForStockInventory.GroupBy("Period, Document, Company, Store, ItemKey, Direction", _QuantityResources);

	For Each Row In Tables.DataForStockInventory Do
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Period = Row.Period;
		NewRecord.Recorder = CalculationSettings.CalculationMovementCostRef;
	EndDo;

	RecordSet.Write();
	
	// Fixed assets
	RecordSet = InformationRegisters.T8510S_FixedAssetsInfo.CreateRecordSet();
	RecordSet.Filter.Recorder.Set(CalculationSettings.CalculationMovementCostRef);
	
	_DataForFixedAssets = Tables.DataForFixedAssets.Copy();
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
			+ Row.AllocatedRevenueAmount
			+ Row.PreliminaryAmount;
		
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
	
	// Revenues
	AccumulationRegisters.R5021T_Revenues.Revenues_LoadRecords(CalculationSettings.CalculationMovementCostRef);
	
	// Book value of fixed assets
	AccumulationRegisters.R8510B_BookValueOfFixedAsset.BookValueOfFixedAsset_LoadRecords(CalculationSettings.CalculationMovementCostRef);
	
	// Cost of fixed asset
	AccumulationRegisters.R8515T_CostOfFixedAsset.CostOfFixedAsset_LoadRecords(CalculationSettings.CalculationMovementCostRef);
	
	// Stock inventory
	AccumulationRegisters.R4050B_StockInventory.StockInventory_LoadRecords(CalculationSettings.CalculationMovementCostRef);
	AccumulationRegisters.R6510B_StockBalance.StockBalance_LoadRecords(CalculationSettings.CalculationMovementCostRef);
	
	// Relevance
	InformationRegisters.T6030S_BatchRelevance.BatchRelevance_Clear(CalculationSettings.Company, CalculationSettings.EndPeriod);
	InformationRegisters.T6030S_BatchRelevance.BatchRelevance_Restore(CalculationSettings.Company, CalculationSettings.EndPeriod);	
EndProcedure

Function GetBatchWiseBalance(CalculationSettings)

	// EmptyTable_BatchWiseBalance
	RegMetadata = Metadata.AccumulationRegisters.R6010B_BatchWiseBalance;
	EmptyTable_BatchWiseBalance = New ValueTable();
	EmptyTable_BatchWiseBalance.Columns.Add("Batch"     , New TypeDescription("CatalogRef.Batches"));
	EmptyTable_BatchWiseBalance.Columns.Add("BatchKey"  , New TypeDescription("CatalogRef.BatchKeys"));
	EmptyTable_BatchWiseBalance.Columns.Add("Document"  , GetBatchDocumentsTypes());
	EmptyTable_BatchWiseBalance.Columns.Add("Company"   , New TypeDescription("CatalogRef.Companies"));
	EmptyTable_BatchWiseBalance.Columns.Add("Period"    , RegMetadata.StandardAttributes.Period.Type);
	EmptyTable_BatchWiseBalance.Columns.Add("Quantity", RegMetadata.Resources.Quantity.Type);
	EmptyTable_BatchWiseBalance.Columns.Add("PreliminaryQuantity", RegMetadata.Resources.Quantity.Type);
	EmptyTable_BatchWiseBalance.Columns.Add("IsShortageOutgoing", New TypeDescription("Boolean"));
	EmptyTable_BatchWiseBalance.Columns.Add("IsShortageIncoming", New TypeDescription("Boolean"));
		
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
	DataForReallocatedBatchesAmountValues.Columns.Add("PreliminaryQuantity", RegMetadata.Resources.Quantity.Type);
	
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
	DataForWriteOffBatches.Columns.Add("Batch"            , RegMetadata.Dimensions.Batch.Type);
	DataForWriteOffBatches.Columns.Add("BatchKey"         , RegMetadata.Dimensions.BatchKey.Type);
	DataForWriteOffBatches.Columns.Add("AmountCorrectionType", RegMetadata.Dimensions.AmountCorrectionType.Type);
	DataForWriteOffBatches.Columns.Add("CorrectionExpenseRevenueType", RegMetadata.Dimensions.CorrectionExpenseRevenueType.Type);
	DataForWriteOffBatches.Columns.Add("Quantity"         , RegMetadata.Resources.Quantity.Type);
	DataForWriteOffBatches.Columns.Add("PreliminaryQuantity", RegMetadata.Resources.Quantity.Type);
	
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
	
	// Stock inventory
	RegMetadata = Metadata.InformationRegisters.T4050_StockInventoryInfo;
	DataForStockInventory = New ValueTable();
	DataForStockInventory.Columns.Add("Period"   , RegMetadata.StandardAttributes.Period.Type);
	DataForStockInventory.Columns.Add("Document" , RegMetadata.Dimensions.Document.Type);
	DataForStockInventory.Columns.Add("Company"  , RegMetadata.Dimensions.Company.Type);
	DataForStockInventory.Columns.Add("Store"    , RegMetadata.Dimensions.Store.Type);
	DataForStockInventory.Columns.Add("ItemKey"  , RegMetadata.Dimensions.ItemKey.Type);
	DataForStockInventory.Columns.Add("Direction", RegMetadata.Dimensions.Direction.Type);	
	DataForStockInventory.Columns.Add("Quantity" , RegMetadata.Resources.Quantity.Type);
	DataForStockInventory.Columns.Add("PreliminaryQuantity", RegMetadata.Resources.PreliminaryQuantity.Type);
	
	Tables.Insert("DataForStockInventory", DataForStockInventory);
	
	tmp_manager = New TempTablesManager();
	Tree = GetBatchTree(tmp_manager, CalculationSettings);
		
	For Each Row In Tree.Rows Do
		CountRows_DataForWriteOffBatches = Tables.DataForWriteOffBatches.Count();	
		
		CalculateBatch(Row.Document, Row.Rows, Tables, CalculationSettings);
		WriteBatchWiseBalance(Tables, CalculationSettings);
		
		If CountRows_DataForWriteOffBatches <> Tables.DataForWriteOffBatches.Count() Then
			WriteWriteoffBatches(Tables, CalculationSettings);
		EndIf;	
	EndDo;

	Return Tables;
EndFunction

Procedure CalculateBatch(Document, BatchRows, Tables, CalculationSettings)
	If IsTransferDocument(Document) Or IsShipmentToTradeAgent(Document) Or IsReturnFromTradeAgent(Document) Then
		Calculate_TransferDocument(Document, BatchRows, Tables, CalculationSettings);
	ElsIf IsCompositeDocument(Document) Then
		Calculate_CompositeDocument(Document, BatchRows, Tables, CalculationSettings);
	ElsIf IsDecompositeDocument(Document) Then
		Calculate_DecompositeDocument(Document, BatchRows, Tables, CalculationSettings);
	Else
		For Each BatchRow In BatchRows Do
			If IsInvoiceByPreliminary(Document, BatchRow) Then
				Calculate_InvoiceByPreliminary(Document, BatchRow, Tables, CalculationSettings);
			ElsIf IsSimpleReceipt(Document, BatchRow) Or IsReturnWithoutSalesInvoice(Document, BatchRow) Then
				Calculate_SimpleReceipt(Document, BatchRow, Tables, CalculationSettings);
			ElsIf IsReturnBySalesInvoice(Document, BatchRow) Then
				Calculate_ReturnBySalesInvoice(Document, BatchRow, Tables, CalculationSettings);
			ElsIf IsReallocateIncomingDocument(Document) Then
				Calculate_ReallocateIncomingDocument(Document, BatchRow, Tables, CalculationSettings);
			ElsIf IsCompositeDocument_ItemStockAdjustment(Document) Then
				Calculate_ItemStockAdjustment(Document, BatchRow, BatchRows, Tables, CalculationSettings);				
			ElsIf IsCompositeDocument_StockCorrection(Document) Then
				Calculate_StockCorrection(Document, BatchRow, BatchRows, Tables, CalculationSettings);
				
			// sales, write-off, reallocate outgoing
			ElsIf BatchRow.Direction = Enums.BatchDirection.Expense Then
				Calculate_SimpleExpense(Document, BatchRow, Tables, CalculationSettings);
			EndIf;
		EndDo;
	EndIf;
EndProcedure

Procedure Calculate_SimpleReceipt(Document, BatchRow, Tables, CalculationSettings)
	If BatchRow.InvoiceAmount = 0 AND BatchRow.Company.LandedCostFillEmptyAmount 
		AND (TypeOf(Document) = Type("DocumentRef.StockAdjustmentAsSurplus")
		OR TypeOf(Document) = Type("DocumentRef.SalesReturn")) Then
		
		Price = GetPriceForEmptyAmountFromDataForReceipt(BatchRow.BatchKey.ItemKey, BatchRow.Date, Tables.DataForReceipt);
						
		If Price = 0 Then
			Price = GetPriceForEmptyAmountFromBatchBalance(BatchRow.BatchKey.ItemKey, BatchRow.Date);
		EndIf;
						
		If Price = 0 AND Not BatchRow.Company.LandedCostPriceTypeForEmptyAmount.isEmpty() Then
			PriceSettings = New Structure();
			PriceSettings.Insert("ItemKey"   ,  BatchRow.BatchKey.ItemKey);
			PriceSettings.Insert("Period"    ,  BatchRow.Date);
			PriceSettings.Insert("PriceType" ,  BatchRow.Company.LandedCostPriceTypeForEmptyAmount);
			PriceSettings.Insert("Unit"      ,  GetItemInfo.GetInfoByItemsKey(BatchRow.BatchKey.ItemKey)[0].Unit);
			Price = GetItemInfo.ItemPriceInfo(PriceSettings).Price;
		EndIf;
		
		BatchRow.InvoiceAmount        = Price * BatchRow.Quantity;				
	EndIf; // fill empty amount
	
	NewReceipt = Tables.DataForReceipt.Add();
	NewReceipt.Batch     = BatchRow.Batch;
	NewReceipt.BatchKey  = BatchRow.BatchKey;
	NewReceipt.Document  = Document;
	NewReceipt.Company   = BatchRow.Company;
	NewReceipt.Period    = BatchRow.Date;

	NewReceipt.Quantity  = BatchRow.Quantity;
	NewReceipt.PreliminaryQuantity  = BatchRow.PreliminaryQuantity;
	
	For Each Res In AmountResources() Do
		NewReceipt[Res] = BatchRow[Res]; 
	EndDo;
EndProcedure

Procedure Calculate_InvoiceByPreliminary(Document, BatchRow, Tables, CalculationSettings)
	// receipt inventoty
	NewReceipt = Tables.DataForReceipt.Add();
	NewReceipt.Batch     = BatchRow.Batch;
	NewReceipt.BatchKey  = BatchRow.BatchKey;
	NewReceipt.Document  = Document;
	NewReceipt.Company   = BatchRow.Company;
	NewReceipt.Period    = BatchRow.Date;

	NewReceipt.Quantity  = BatchRow.Quantity;
	NewReceipt.PreliminaryQuantity  = BatchRow.PreliminaryQuantity;
	
	For Each Res In AmountResources() Do
		NewReceipt[Res] = BatchRow[Res]; 
	EndDo;
	
	// find all balances by preliminary batch in all stores
	PreliminaryInfo = GetPreliminaryBatches(BatchRow.PreliminaryID, 
		BatchRow.BatchKey.ItemKey, 
		BatchRow.BatchKey.SerialLotNumber, 
		BatchRow.BatchKey.SourceOfOrigin); 
	
	ArrayOf_Balance_BatchRows = New Array();
	
	For Each _r1 In PreliminaryInfo.Documents Do
		For Each _r2 In PreliminaryInfo.BatchKeys Do
			Balance_BatchRows = GetBatchesWithBalance(BatchRow.Company, _r2.BatchKey, Document.Date, _r1.PreliminaryDocument);
			For Each _r3 In Balance_BatchRows Do
				If Not ValueIsFilled(_r3.PreliminaryQuantity) Then
					Continue; // only balances with preliminary quantity
				EndIf;
				ArrayOf_Balance_BatchRows.Add(_r3);
			EndDo;		
		EndDo;
	EndDo;
	
	NeedExpense = BatchRow.Quantity;
	
	ArrayOfTransferedBatchKeys = New Array();
	
	// prelminary batches on balance
	For Each Balance_Batch In ArrayOf_Balance_BatchRows Do
		If NeedExpense = 0 Then
			Break;
		EndIf;
		ExpenseQuantity = Min(NeedExpense, Balance_Batch.PreliminaryQuantity);
		
		If Not ValueIsFilled(ExpenseQuantity) Then
			Continue;
		EndIf;
		
		If Balance_Batch.BatchKey <> BatchRow.BatchKey Then
			ArrayOfTransferedBatchKeys.Add(New Structure("Batch, BatchKey, ExpenseQuantity", 
				Balance_Batch.Batch, Balance_Batch.BatchKey, ExpenseQuantity));
		EndIf;
		
		NeedExpense = NeedExpense - ExpenseQuantity;
		
		ExpenseAmounts = New Structure();
		For Each Res In AmountResources() Do
			ExpenseAmounts.Insert(Res, AmountProportionByQuantity(ExpenseQuantity, Balance_Batch, Res, "PreliminaryQuantity"));
			Balance_Batch[Res] = Balance_Batch[Res] - ExpenseAmounts[Res];
		EndDo;
		Balance_Batch.PreliminaryQuantity = Balance_Batch.PreliminaryQuantity - ExpenseQuantity;
		
		// expense balance by preliminary batch (mirror stock inventory)
		NewExpense = Tables.DataForExpense.Add();
		NewExpense.Batch     = Balance_Batch.Batch;
		NewExpense.BatchKey  = Balance_Batch.BatchKey;
		NewExpense.Document  = Document;
		NewExpense.Company   = BatchRow.Company;
		NewExpense.Period    = BatchRow.Date;
		NewExpense.PreliminaryQuantity  = ExpenseQuantity;
		NewExpense.PreliminaryAmount    = ExpenseAmounts.PreliminaryAmount;
		NewExpense.PreliminaryTaxAmount = ExpenseAmounts.PreliminaryTaxAmount;
		
		// stock inventory (expense preliminary)
		NewStockExpense = Tables.DataForStockInventory.Add();
		NewStockExpense.Direction = Enums.BatchDirection.Expense;
		NewStockExpense.Document  = Document;
		NewStockExpense.Period  = BatchRow.Date;
		NewStockExpense.Company = BatchRow.Company;
		NewStockExpense.Store   = Balance_Batch.BatchKey.Store;
		NewStockExpense.ItemKey = Balance_Batch.BatchKey.ItemKey;
		NewStockExpense.PreliminaryQuantity = ExpenseQuantity;
		
	EndDo; // preliminary batches on balance
	
	// preliminary transfered batches
	For Each Transfer_Batch In ArrayOfTransferedBatchKeys Do
		ExpenseQuantity = Transfer_Batch.ExpenseQuantity;
		
		// expense inventory by current batch key (mirror stock inventory)
		NewExpense = Tables.DataForExpense.Add();
		NewExpense.Batch     = BatchRow.Batch;
		NewExpense.BatchKey  = BatchRow.BatchKey;
		NewExpense.Document  = Document;
		NewExpense.Company   = BatchRow.Company;
		NewExpense.Period    = BatchRow.Date;
		
		NewExpense.Quantity  = ExpenseQuantity;
		
		ExpenseAmounts = New Structure();
		For Each Res In AmountResources() Do
			ExpenseAmounts.Insert(Res, AmountProportionByQuantity(ExpenseQuantity, BatchRow, Res, "Quantity"));
		EndDo;
		
		For Each Res In AmountResources() Do
			NewExpense[Res] = ExpenseAmounts[Res]; 
		EndDo;
		
		// receipt inventory to other batch key (mirror stock inventory)
		NewReceipt = Tables.DataForReceipt.Add();
		NewReceipt.Batch     = BatchRow.Batch;
		NewReceipt.BatchKey  = Transfer_Batch.BatchKey;
		NewReceipt.Document  = Document;
		NewReceipt.Company   = BatchRow.Company;
		NewReceipt.Period    = BatchRow.Date;

		NewReceipt.Quantity  = ExpenseQuantity;
	
		For Each Res In AmountResources() Do
			NewReceipt[Res] = ExpenseAmounts[Res]; 
		EndDo;
	EndDo; // preliminary transfered batches
	
	WriteBatchWiseBalance(Tables, CalculationSettings);
	
	// ammount correction
	For Each _r1 In PreliminaryInfo.Documents Do
		For Each _r2 In PreliminaryInfo.BatchKeys Do
			UnrecoverExpenses = GetUrecoverExpenses(BatchRow.Date, _r1.PreliminaryDocument, _r2.BatchKey);
			For Each UnrecoverExpense In UnrecoverExpenses Do
				AmountCorrection = CorrectionInvoiceAmounts(UnrecoverExpense, BatchRow, "InvoiceAmount", "PreliminaryAmount");
				AmountTaxCorrection = CorrectionInvoiceAmounts(UnrecoverExpense, BatchRow, "InvoiceTaxAmount", "PreliminaryTaxAmount");					
				
				// correction invoice amount and tax amount
				If AmountCorrection <> 0 or AmountTaxCorrection <> 0 Then
					
					_Company = NewReceipt.Batch.Company;
					
					NewReceipt = Tables.DataForReceipt.Add();
					NewReceipt.Batch     = UnrecoverExpense.Batch;
					NewReceipt.BatchKey  = UnrecoverExpense.BatchKey;
					NewReceipt.Document  = Document;
					NewReceipt.Company   = _Company;
					NewReceipt.Period    = BatchRow.Date;

					NewReceipt.Quantity = 0;
					NewReceipt.PreliminaryQuantity = 0;
					NewReceipt.InvoiceAmount = AmountCorrection;
					NewReceipt.InvoiceTaxAmount = AmountTaxCorrection;
					NewExpense = Tables.DataForExpense.Add();
					FillPropertyValues(NewExpense, NewReceipt);
					
					If AmountCorrection <> 0 Then
						_new = Tables.DataForWriteOffBatches.Add();
						FillPropertyValues(_new, NewReceipt);
						_new.Batch               = NewReceipt.Batch;
						_new.BatchKey            = NewReceipt.BatchKey;
						_new.ItemKey             = NewReceipt.BatchKey.ItemKey;
						_new.InvoiceAmount    = AmountCorrection;
						_new.InvoiceTaxAmount = 0;
					
						If AmountCorrection > 0 Then 
							// P&L expense
							_new.AmountCorrectionType = Enums.AmountCorrectionTypes.Expense;
							_new.CorrectionExpenseRevenueType = _Company.LandedCostAmountCorrectionExpenseType;
						Else 
							// P&L revenue
							_new.AmountCorrectionType = Enums.AmountCorrectionTypes.Revenue;
							_new.CorrectionExpenseRevenueType = _Company.LandedCostAmountCorrectionRevenueType;
						EndIf;
						_new.ProfitLossCenter = BatchRow.ProfitLossCenter;
						_new.Branch           = BatchRow.Branch;
						_new.Currency         = _Company.LandedCostCurrencyMovementType.Currency;
//						_new.RowID            = BatchRow.RowID;
					EndIf;
					
					If AmountTaxCorrection <> 0 Then
						_new = Tables.DataForWriteOffBatches.Add();
						FillPropertyValues(_new, NewReceipt);
						_new.Batch               = NewReceipt.Batch;
						_new.BatchKey            = NewReceipt.BatchKey;
						_new.ItemKey             = NewReceipt.BatchKey.ItemKey;
						_new.InvoiceAmount = 0;
						_new.InvoiceTaxAmount = AmountTaxCorrection;
					
						If AmountTaxCorrection > 0 Then 
							// P&L expense
							_new.AmountCorrectionType = Enums.AmountCorrectionTypes.Expense;
							_new.CorrectionExpenseRevenueType = _Company.LandedCostAmountCorrectionExpenseType;
						Else 
							// P&L revenue
							_new.AmountCorrectionType = Enums.AmountCorrectionTypes.Revenue;
							_new.CorrectionExpenseRevenueType = _Company.LandedCostAmountCorrectionRevenueType;
						EndIf;
						_new.ProfitLossCenter = BatchRow.ProfitLossCenter;
						_new.Branch           = BatchRow.Branch;
						_new.Currency         = _Company.LandedCostCurrencyMovementType.Currency;
//						_new.RowID            = BatchRow.RowID;
					EndIf;
					
				EndIf;
								
				// expense inventory quantity
				NewExpense = Tables.DataForExpense.Add();
				NewExpense.Batch     = BatchRow.Batch;
				NewExpense.BatchKey  = BatchRow.BatchKey;
				NewExpense.Document  = Document;
				NewExpense.Company   = BatchRow.Company;
				NewExpense.Period    = BatchRow.Date;		
				NewExpense.Quantity  = UnrecoverExpense.PreliminaryQuantity;
		
				ExpenseAmounts = New Structure();
				For Each Res In AmountResources() Do
					ExpenseAmounts.Insert(Res, AmountProportionByQuantity(UnrecoverExpense.PreliminaryQuantity, BatchRow, Res, "Quantity"));
				EndDo;
		
				For Each Res In AmountResources() Do
					NewExpense[Res] = ExpenseAmounts[Res]; 
				EndDo;
				
				// stock inventory (expense preliminary)
				NewStockExpense = Tables.DataForStockInventory.Add();
				NewStockExpense.Direction = Enums.BatchDirection.Expense;
				NewStockExpense.Document  = Document;
				NewStockExpense.Period  = BatchRow.Date;
				NewStockExpense.Company = BatchRow.Company;
				NewStockExpense.Store   = BatchRow.BatchKey.Store;
				NewStockExpense.ItemKey = BatchRow.BatchKey.ItemKey;
				NewStockExpense.PreliminaryQuantity = UnrecoverExpense.PreliminaryQuantity;
				
			EndDo;
		EndDo;
	EndDo; // ammoint correction
EndProcedure

Function CorrectionInvoiceAmounts(UnrecoverExpense, BatchRow, ResourceName, PreliminaryResourceName)
	// calculate real quantity
	RealAmount = 0;
	If UnrecoverExpense.PreliminaryQuantity = BatchRow.Quantity Then
		RealAmount = BatchRow[ResourceName];
	Else
		If BatchRow.Quantity <> 0 Then
			RealAmount = Round((BatchRow[ResourceName] / BatchRow.Quantity) * UnrecoverExpense.PreliminaryQuantity, 2); 
		EndIf;
	EndIf;
				
	// compare real amounts and preliminary amounts
	PreliminaryAmount = UnrecoverExpense[PreliminaryResourceName] + UnrecoverExpense[ResourceName];
	CorrectionAmount = RealAmount - PreliminaryAmount;
	Return CorrectionAmount;					
EndFunction

Function GetUrecoverExpenses(Period, BatchDocument, BatchKey)
	Query = New Query();
	Query.Text = 
	"select 
	|	Reg.Batch, Reg.BatchKey,
	|	sum(Reg.Quantity) as Quantity, 
	|	sum(Reg.PreliminaryQuantity) as PreliminaryQuantity,
	|	sum(Reg.InvoiceAmount) as InvoiceAmount, 
	|	sum(Reg.PreliminaryAmount) as PreliminaryAmount,
	|	sum(Reg.InvoiceTaxAmount) as InvoiceTaxAmount, 
	|	sum(Reg.PreliminaryTaxAmount) as PreliminaryTaxAmount
	|from InformationRegister.T6095S_WriteOffBatchesInfo as Reg
	|where
	|	Reg.BatchKey = &BatchKey 
	|	and Reg.Batch.Document = &BatchDocument 
	|	and Reg.Period <= &Period
	|group by
	|	Reg.Batch, Reg.BatchKey
	|order by
	|	Reg.Batch.Date";
	
	Query.SetParameter("BatchDocument", BatchDocument);
	Query.SetParameter("BatchKey", BatchKey);
	Query.SetParameter("Period", Period);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

Procedure Calculate_ReturnBySalesInvoice(Document, BatchRow, Tables, CalculationSettings)
	
	Sales_BatchRows = GetSalesBatches(BatchRow.SalesInvoice, Tables.DataForSalesBatches, BatchRow.BatchKey);
	NeedReceipt = BatchRow.Quantity; // how many returned (quantity)

	For Each Sales_Batch In Sales_BatchRows Do
		If NeedReceipt = 0 Then
			Break;
		EndIf;

		QtyName = ?(Not ValueIsFilled(Sales_Batch.Quantity), "Preliminary", "") + "Quantity";
		ReceiptQuantity = Min(NeedReceipt, Sales_Batch[QtyName]);

		ReceiptAmounts = New Structure();
		For Each Res In AmountResources() Do
			ReceiptAmounts.Insert(Res, AmountProportionByQuantity(ReceiptQuantity, Sales_Batch, Res, QtyName));
			Sales_Batch[Res] = Sales_Batch[Res] - ReceiptAmounts[Res]; 
		EndDo;
					
		Sales_Batch[QtyName] = Sales_Batch[QtyName] - ReceiptQuantity;					
		NeedReceipt = NeedReceipt - ReceiptQuantity;
					
		//_Sales_Batch_Document = Sales_Batch.Document;
		_Sales_Batch_Company  = Sales_Batch.Company; // company from sales document
		_Sales_Batch_Batch    = Sales_Batch.Batch;
					
		// determine batch when returned by another company
		If ValueIsFilled(BatchRow.Batch) And BatchRow.Company <> _Sales_Batch_Company Then
			//_Sales_Batch_Document = BatchRow.Batch.Document;
			_Sales_Batch_Company  = BatchRow.Company; // current document company
			_Sales_Batch_Batch    = BatchRow.Batch;
		EndIf;

		NewReceipt = Tables.DataForReceipt.Add();
		NewReceipt.Batch     = _Sales_Batch_Batch;
		NewReceipt.BatchKey  = BatchRow.BatchKey;
		NewReceipt.Document  = Document;
		NewReceipt.Company   = _Sales_Batch_Company;
		NewReceipt.Period    = BatchRow.Date;

		NewReceipt[QtyName] = ReceiptQuantity;
		
		For Each Res In AmountResources() Do
			NewReceipt[Res] = ReceiptAmounts[Res]; 
		EndDo;

	EndDo; // For Each Sales_Batch In Sales_BatchRows

	If NeedReceipt <> 0 Then
		// Can not receipt Batch key by sales return: %1 , Quantity: %2 , Doc: %3
		Msg = StrTemplate(R().LC_Error_001, GetBatchKeyDetailPresentation(BatchRow.BatchKey), NeedReceipt, Document);
		CommonFunctionsClientServer.ShowUsersMessage(Msg);
		If CalculationSettings.RaiseOnCalculationError Then
			Raise Msg;
		EndIf;
		_nr = Tables.DataForBatchShortageIncoming.Add();
		_nr.BatchKey = BatchRow.BatchKey;
		_nr.Document = Document;
		_nr.Company  = BatchRow.Company;
		_nr.Period   = BatchRow.Date;
		_nr.Quantity = NeedReceipt;
	EndIf;
EndProcedure

Procedure Calculate_SimpleExpense(Document, BatchRow, Tables, CalculationSettings)
	
	Balance_BatchRows = GetBatchesWithBalance(BatchRow.Company, BatchRow.BatchKey, Document.Date);

	NeedExpense = BatchRow.Quantity;

	For Each Balance_Batch In Balance_BatchRows Do
		If NeedExpense = 0 Then
			Break;
		EndIf;

		QtyName = ?(Not ValueIsFilled(Balance_Batch.Quantity), "Preliminary", "") + "Quantity";
		ExpenseQuantity = Min(NeedExpense, Balance_Batch[QtyName]);

		If Not ValueIsFilled(ExpenseQuantity) Then
			Continue;
		EndIf;

		NeedExpense = NeedExpense - ExpenseQuantity;

		ExpenseAmounts = New Structure();
		For Each Res In AmountResources() Do
			ExpenseAmounts.Insert(Res, AmountProportionByQuantity(ExpenseQuantity, Balance_Batch, Res, QtyName));
			Balance_Batch[Res] = Balance_Batch[Res] - ExpenseAmounts[Res];
		EndDo;
		Balance_Batch[QtyName] = Balance_Batch[QtyName] - ExpenseQuantity;

		// expense
		NewExpense = Tables.DataForExpense.Add();
		NewExpense.Batch     = Balance_Batch.Batch;
		NewExpense.BatchKey  = BatchRow.BatchKey;
		NewExpense.Document  = Document;
		NewExpense.Company   = BatchRow.Company;
		NewExpense.Period    = BatchRow.Date;

		NewExpense[QtyName] = ExpenseQuantity;
		For Each Res In AmountResources() Do
			NewExpense[Res] = ExpenseAmounts[Res]; 
		EndDo;

			// sales batches
		If TypeOf(Document) = Type("DocumentRef.SalesInvoice") 
			Or TypeOf(Document) = Type("DocumentRef.RetailSalesReceipt") Then
			_new = Tables.DataForSalesBatches.Add();
			FillPropertyValues(_new, NewExpense);
			_new.SalesInvoice = Document;
		EndIf;
					
			// reallocated batches
		If TypeOf(Document) = Type("DocumentRef.BatchReallocateOutgoing") Then
			_new = Tables.DataForReallocatedBatchesAmountValues.Add();
			FillPropertyValues(_new, NewExpense);
			_new.OutgoingDocument = Document;
			_new.IncomingDocument = Document.Incoming;
		EndIf;
				
			// write-off batches
		If TypeOf(Document) = Type("DocumentRef.StockAdjustmentAsWriteOff")
			Or TypeOf(Document) = Type("DocumentRef.WorkSheet")
			Or TypeOf(Document) = Type("DocumentRef.SalesInvoice") 
			Or TypeOf(Document) = Type("DocumentRef.RetailSalesReceipt") Then
				
			_new = Tables.DataForWriteOffBatches.Add();
			FillPropertyValues(_new, NewExpense);
			_new.Batch               = NewExpense.Batch;
			_new.BatchKey            = NewExpense.BatchKey;
			_new.ItemKey             = NewExpense.BatchKey.ItemKey;
			_new.Quantity            = NewExpense.Quantity;
			_new.PreliminaryQuantity = NewExpense.PreliminaryQuantity;
			
			If TypeOf(Document) = Type("DocumentRef.SalesInvoice")
				Or TypeOf(Document) = Type("DocumentRef.RetailSalesReceipt") Then
				_new.ExpenseType = BatchRow.Company.LandedCostExpenseType;
			Else
				_new.ExpenseType = BatchRow.ExpenseType;
			EndIf;
			_new.ProfitLossCenter = BatchRow.ProfitLossCenter;
			_new.Branch           = BatchRow.Branch;
			_new.Currency         = BatchRow.Currency;
			_new.RowID            = BatchRow.RowID;
		EndIf;	
					
			// fixed asset
		If TypeOf(Document) = Type("DocumentRef.CommissioningOfFixedAsset")
			Or TypeOf(Document) = Type("DocumentRef.ModernizationOfFixedAsset") Then
			_new = Tables.DataForFixedAssets.Add();
			FillPropertyValues(_new, NewExpense);
			_new.FixedAsset       = BatchRow.FixedAsset;						
			_new.Branch           = BatchRow.Branch;						
			_new.ProfitLossCenter = BatchRow.ProfitLossCenter;					
		EndIf;	

	EndDo; // For Each Balance_Batch In BatchesWithBalance
	
	If NeedExpense <> 0 Then
		// Can not expense Batch key: %1 , Quantity: %2 , Doc: %3'
		Msg = StrTemplate(R().LC_Error_002, GetBatchKeyDetailPresentation(BatchRow.BatchKey), NeedExpense, Document);
		CommonFunctionsClientServer.ShowUsersMessage(Msg);
		If CalculationSettings.RaiseOnCalculationError Then
			Raise Msg;
		EndIf;
		_new = Tables.DataForBatchShortageOutgoing.Add();
		_new.BatchKey = BatchRow.BatchKey;
		_new.Document = Document;
		_new.Company  = BatchRow.Company;
		_new.Period   = BatchRow.Date;
		_new.Quantity = NeedExpense;
	EndIf;
EndProcedure

Procedure Calculate_TransferDocument(Document, BatchRows, Tables, CalculationSettings)
	Transfer_BatchRows = New ValueTable();
	Transfer_BatchRows.Columns.Add("Sender");
	Transfer_BatchRows.Columns.Add("Receiver");
	
	For Each _r1 In BatchRows Do
		If _r1.Direction = Enums.BatchDirection.Expense Then

			_nr = Transfer_BatchRows.Add();
			_nr.Sender = _r1;
			
			For Each _r2 In BatchRows Do
				If _r2.Direction = Enums.BatchDirection.Receipt 
					AND _r1.BatchKey.ItemKey = _r2.BatchKey.ItemKey
					AND _r1.BatchKey.SerialLotNumber = _r2.BatchKey.SerialLotNumber
					AND _r1.BatchKey.SourceOfOrigin = _r2.BatchKey.SourceOfOrigin Then

					_nr.Receiver = _r2;
				EndIf; 
			EndDo;
		EndIf;
	EndDo;

	For Each Transfer_Batch In Transfer_BatchRows Do

		Balance_BatchRows = GetBatchesWithBalance(Transfer_Batch.Sender.Company, Transfer_Batch.Sender.BatchKey, Document.Date);
	
		NeedExpense = Transfer_Batch.Sender.Quantity;

		For Each Balance_Batch In Balance_BatchRows Do
			If NeedExpense = 0 Then
				Break;
			EndIf;

			QtyName = ?(Not ValueIsFilled(Balance_Batch.Quantity), "Preliminary", "") + "Quantity";
			ExpenseQuantity = Min(NeedExpense, Balance_Batch[QtyName]);

			If Not ValueIsFilled(ExpenseQuantity) Then
				Continue;
			EndIf;

			NeedExpense = NeedExpense - ExpenseQuantity;

			ExpenseAmounts = New Structure();
			For Each Res In AmountResources() Do
				ExpenseAmounts.Insert(Res, AmountProportionByQuantity(ExpenseQuantity, Balance_Batch, Res, QtyName));
				Balance_Batch[Res] = Balance_Batch[Res] - ExpenseAmounts[Res];
			EndDo;
			Balance_Batch[QtyName] = Balance_Batch[QtyName] - ExpenseQuantity;

			// expense from sender
			NewExpense = Tables.DataForExpense.Add();
			NewExpense.Batch     = Balance_Batch.Batch;
			NewExpense.BatchKey  = Transfer_Batch.Sender.BatchKey;
			NewExpense.Document  = Document;
			NewExpense.Company   = Transfer_Batch.Sender.Company;
			NewExpense.Period    = Transfer_Batch.Sender.Date;

			NewExpense[QtyName] = ExpenseQuantity;
			For Each Res In AmountResources() Do
				NewExpense[Res] = ExpenseAmounts[Res]; 
			EndDo;

			// receipt to receiver
			NewReceipt = Tables.DataForReceipt.Add();
			FillPropertyValues(NewReceipt, NewExpense);
			NewReceipt.BatchKey  = Transfer_Batch.Receiver.BatchKey;
		EndDo; // For Each Balance_Batch In BatchesWithBalance
		
		If NeedExpense <> 0 Then
			// Can not expense Batch key: %1 , Quantity: %2 , Doc: %3'
			Msg = StrTemplate(R().LC_Error_002, GetBatchKeyDetailPresentation(Transfer_Batch.Sender.BatchKey), NeedExpense, Document);
			CommonFunctionsClientServer.ShowUsersMessage(Msg);
			If CalculationSettings.RaiseOnCalculationError Then
				Raise Msg;
			EndIf;
			_new = Tables.DataForBatchShortageOutgoing.Add();
			_new.BatchKey = Transfer_Batch.Sender.BatchKey;
			_new.Document = Document;
			_new.Company  = Transfer_Batch.Sender.Company;
			_new.Period   = Transfer_Batch.Sender.Date;
			_new.Quantity = NeedExpense;
			
			// Can not receipt Batch key: %1 , Quantity: %2 , Doc: %3'
			Msg = StrTemplate(R().LC_Error_003, GetBatchKeyDetailPresentation(Transfer_Batch.Receiver.BatchKey), NeedExpense, Document);
			CommonFunctionsClientServer.ShowUsersMessage(Msg);
			If CalculationSettings.RaiseOnCalculationError Then
				Raise Msg;
			EndIf;
			_new = Tables.DataForBatchShortageIncoming.Add();
			_new.BatchKey = Transfer_Batch.Receiver.BatchKey;
			_new.Document = Document;
			_new.Company  = Transfer_Batch.Receiver.Company;
			_new.Period   = Transfer_Batch.Receiver.Date;
			_new.Quantity = NeedExpense;
		EndIf;		
	EndDo; // For Each Transfer_Batch In Transfer_BatchRows
EndProcedure

Procedure Calculate_CompositeDocument(Document, BatchRows, Tables, CalculationSettings)
	Expense_BatchRows = New Array();
	Receipt_BatchRows = New Array();

	For Each _r1 In BatchRows Do
		If _r1.Direction = Enums.BatchDirection.Expense Then
			Expense_BatchRows.Add(_r1);
		ElsIf _r1.Direction = Enums.BatchDirection.Receipt Then
			Receipt_BatchRows.Add(_r1);
		EndIf;
	EndDo;

	If Receipt_BatchRows.Count() <> 1 Then
		Raise "Receipt batches found for composite document not equal to 1. Document: " + Document;
	EndIf;

	TotalExpenseAmounts = New Structure();
	For Each Res In AmountResources() Do
		TotalExpenseAmounts.Insert(Res, 0);
	EndDo;
	
	ArrayOf_BundleAmountValues = New Array();
	
	For Each Expense_Batch In Expense_BatchRows Do
		Balance_BatchRows = GetBatchesWithBalance(Expense_Batch.Company, Expense_Batch.BatchKey, Document.Date);
	
		NeedExpense = Expense_Batch.Quantity;

		For Each Balance_Batch In Balance_BatchRows Do
			If NeedExpense = 0 Then
				Break;
			EndIf;

			QtyName = ?(Not ValueIsFilled(Balance_Batch.Quantity), "Preliminary", "") + "Quantity";
			ExpenseQuantity = Min(NeedExpense, Balance_Batch[QtyName]);

			If Not ValueIsFilled(ExpenseQuantity) Then
				Continue;
			EndIf;

			NeedExpense = NeedExpense - ExpenseQuantity;

			ExpenseAmounts = New Structure();
			For Each Res In AmountResources() Do
				ExpenseAmounts.Insert(Res, AmountProportionByQuantity(ExpenseQuantity, Balance_Batch, Res, QtyName));
				Balance_Batch[Res] = Balance_Batch[Res] - ExpenseAmounts[Res];

				TotalExpenseAmounts[Res] = TotalExpenseAmounts[Res] + ExpenseAmounts[Res];
			EndDo;
			Balance_Batch[QtyName] = Balance_Batch[QtyName] - ExpenseQuantity;

			// expense materials and semiproducts
			NewExpense = Tables.DataForExpense.Add();
			NewExpense.Batch     = Balance_Batch.Batch;
			NewExpense.BatchKey  = Balance_Batch.BatchKey;
			NewExpense.Document  = Document;
			NewExpense.Company   = Expense_Batch.Company;
			NewExpense.Period    = Expense_Batch.Date;

			NewExpense[QtyName] = ExpenseQuantity;
			For Each Res In AmountResources() Do
				NewExpense[Res] = ExpenseAmounts[Res]; 
			EndDo;
			
			If IsCompositeDocument_Bundling(Document) Then
				_nr = New Structure();
				_nr.Insert("Period",   Expense_Batch.Date);
				_nr.Insert("Batch",    Balance_Batch.Batch);
				_nr.Insert("BatchKey", Balance_Batch.BatchKey);
				_nr.Insert("Company",  Expense_Batch.Company);
				_nr.Insert("BatchKeyBundle", Receipt_BatchRows[0].BatchKey);
				For Each Res In AmountResources() Do
					_nr.Insert(Res, ExpenseAmounts[Res]);
				EndDo;
				ArrayOf_BundleAmountValues.Add(_nr);				
			Else
				_nr = Tables.DataForCompositeBatchesAmountValues.Add();
				_nr.Period   = Expense_Batch.Date;
				_nr.Batch    = Balance_Batch.Batch;
				_nr.BatchKey = Balance_Batch.BatchKey;
				_nr.Company  = Expense_Batch.Company;
				_nr.BatchComposite = Receipt_BatchRows[0].Batch;
				_nr.BatchKeyComposite = Receipt_BatchRows[0].BatchKey;
				For Each Res In AmountResources() Do
					_nr[Res] = ExpenseAmounts[Res];
				EndDo;
			EndIf;	

		EndDo; // For Each Balance_Batch In BatchesWithBalance

		If NeedExpense <> 0 Then
			// Can not expense Batch key: %1 , Quantity: %2 , Doc: %3'
			Msg = StrTemplate(R().LC_Error_002, GetBatchKeyDetailPresentation(Expense_Batch.BatchKey), NeedExpense, Document);
			CommonFunctionsClientServer.ShowUsersMessage(Msg);
			If CalculationSettings.RaiseOnCalculationError Then
				Raise Msg;
			EndIf;
			_new = Tables.DataForBatchShortageOutgoing.Add();
			_new.BatchKey = Expense_Batch.BatchKey;
			_new.Document = Document;
			_new.Company  = Expense_Batch.Company;
			_new.Period   = Expense_Batch.Date;
			_new.Quantity = NeedExpense;
		EndIf;
	EndDo; // For Each Expense_Row In Expense_BatchRows
	
	For Each _r In ArrayOf_BundleAmountValues Do
		_nr = Tables.DataForBundleAmountValues.Add();
		_nr.Period = _r.Period;
		_nr.Batch = _r.Batch;
		_nr.BatchKey = _r.BatchKey;
		_nr.Company = _r.Company;
		_nr.BatchKeyBundle = _r.BatchKeyBundle;
		For Each Res In AmountResources() Do
			If TotalExpenseAmounts[Res] <> 0 And _r[Res] <> 0 Then
				_nr[Res] = _r[Res] / (TotalExpenseAmounts[Res] / 100);
			EndIf;
		EndDo;
	EndDo;
	
	For Each Receipt_Batch In Receipt_BatchRows Do
		NewReceipt = Tables.DataForReceipt.Add();
		NewReceipt.Batch     = Receipt_Batch.Batch;
		NewReceipt.BatchKey  = Receipt_Batch.BatchKey;
		NewReceipt.Document  = Document;
		NewReceipt.Company   = Receipt_Batch.Company;
		NewReceipt.Period    = Receipt_Batch.Date;

		NewReceipt.Quantity  = Receipt_Batch.Quantity;
		NewReceipt.PreliminaryQuantity  = 0; // Composite batches do not have preliminary quantity
		
		For Each Res In AmountResources() Do
			NewReceipt[Res] = Receipt_Batch[Res] + TotalExpenseAmounts[Res]; 
		EndDo;

		// is production
		If IsCompositeDocument_Production(Document) Then 
			NewReceipt.ExtraDirectCostAmount    = NewReceipt.ExtraDirectCostAmount + Document.ExtraDirectCostAmount;
			NewReceipt.ExtraDirectCostTaxAmount = NewReceipt.ExtraDirectCostTaxAmount + Document.ExtraDirectCostTaxAmount;
			
			_ExtraCostAmountByRatio = Document.ExtraCostAmountByRatio;
			If _ExtraCostAmountByRatio <> 0 Then
				_totalAmount = 
					NewReceipt.InvoiceAmount
					+ NewReceipt.PreliminaryAmount 
					+ NewReceipt.IndirectCostAmount
					+ NewReceipt.ExtraCostAmountByRatio 
					+ NewReceipt.ExtraDirectCostAmount
					+ NewReceipt.AllocatedCostAmount
					+ NewReceipt.AllocatedRevenueAmount;
								
				NewReceipt.ExtraCostAmountByRatio = NewReceipt.ExtraCostAmountByRatio + (_totalAmount / 100 * _ExtraCostAmountByRatio);
			EndIf;	
			
			_ExtraCostTaxAmountByRatio = Document.ExtraCostTaxAmountByRatio;
			If _ExtraCostTaxAmountByRatio <> 0 Then	  
				_totalTaxAmount = 
					NewReceipt.InvoiceTaxAmount
					+ NewReceipt.PreliminaryTaxAmount
					+ NewReceipt.IndirectCostTaxAmount
					+ NewReceipt.ExtraCostTaxAmountByRatio 
					+ NewReceipt.ExtraDirectCostTaxAmount 
					+ NewReceipt.AllocatedCostTaxAmount 
					+ NewReceipt.AllocatedRevenueTaxAmount; 

                NewReceipt.ExtraCostTaxAmountByRatio = NewReceipt.ExtraCostTaxAmountByRatio + (_totalTaxAmount / 100 * _ExtraCostTaxAmountByRatio);
			EndIf;
		EndIf; // is production
		
	EndDo; // For Each Receipt_Batch In Receipt_BatchRows
EndProcedure

Procedure Calculate_ItemStockAdjustment(Document, BatchRow, BatchRows, Tables, CalculationSettings)
	If BatchRow.Direction = Enums.BatchDirection.Receipt Then
		Return; // receipt wiil be processed when get expense
	EndIf;
	
	Adj_BatchRows = New ValueTable();
	Adj_BatchRows.Columns.Add("Writeoff");
	Adj_BatchRows.Columns.Add("Surplus");
	
	For Each _r1 In BatchRows Do
		If _r1.Direction = Enums.BatchDirection.Receipt 
			And _r1.ItemStockAdjustmentID = BatchRow.ItemStockAdjustmentID Then

			_nr = Adj_BatchRows.Add();
			_nr.Writeoff = BatchRow;
			_nr.Surplus = _r1;
			
			Break; // only one surplus for one writeoff
		EndIf;
	EndDo;

	For Each Adj_Batch In Adj_BatchRows Do

		Balance_BatchRows = GetBatchesWithBalance(Adj_Batch.Writeoff.Company, Adj_Batch.Writeoff.BatchKey, Document.Date);
	
		NeedExpense = Adj_Batch.Writeoff.Quantity;

		For Each Balance_Batch In Balance_BatchRows Do
			If NeedExpense = 0 Then
				Break;
			EndIf;

			QtyName = ?(Not ValueIsFilled(Balance_Batch.Quantity), "Preliminary", "") + "Quantity";
			ExpenseQuantity = Min(NeedExpense, Balance_Batch[QtyName]);

			If Not ValueIsFilled(ExpenseQuantity) Then
				Continue;
			EndIf;

			NeedExpense = NeedExpense - ExpenseQuantity;

			ExpenseAmounts = New Structure();
			For Each Res In AmountResources() Do
				ExpenseAmounts.Insert(Res, AmountProportionByQuantity(ExpenseQuantity, Balance_Batch, Res, QtyName));
				Balance_Batch[Res] = Balance_Batch[Res] - ExpenseAmounts[Res];
			EndDo;
			Balance_Batch[QtyName] = Balance_Batch[QtyName] - ExpenseQuantity;

			// expense from writeoff
			NewExpense = Tables.DataForExpense.Add();
			NewExpense.Batch     = Balance_Batch.Batch;
			NewExpense.BatchKey  = Adj_Batch.Writeoff.BatchKey;
			NewExpense.Document  = Document;
			NewExpense.Company   = Adj_Batch.Writeoff.Company;
			NewExpense.Period    = Adj_Batch.Writeoff.Date;

			NewExpense[QtyName] = ExpenseQuantity;
			For Each Res In AmountResources() Do
				NewExpense[Res] = ExpenseAmounts[Res]; 
			EndDo;

			// receipt to surpluss
			NewReceipt = Tables.DataForReceipt.Add();
			FillPropertyValues(NewReceipt, NewExpense);
			NewReceipt.BatchKey  = Adj_Batch.Surplus.BatchKey;
		EndDo; // For Each Balance_Batch In BatchesWithBalance
		
		If NeedExpense <> 0 Then
			// Can not expense Batch key: %1 , Quantity: %2 , Doc: %3'
			Msg = StrTemplate(R().LC_Error_002, GetBatchKeyDetailPresentation(Adj_Batch.Writeoff.BatchKey), NeedExpense, Document);
			CommonFunctionsClientServer.ShowUsersMessage(Msg);
			If CalculationSettings.RaiseOnCalculationError Then
				Raise Msg;
			EndIf;
			_new = Tables.DataForBatchShortageOutgoing.Add();
			_new.BatchKey = Adj_Batch.Writeoff.BatchKey;
			_new.Document = Document;
			_new.Company  = Adj_Batch.Writeoff.Company;
			_new.Period   = Adj_Batch.Writeoff.Date;
			_new.Quantity = NeedExpense;
			
			// Can not receipt Batch key: %1 , Quantity: %2 , Doc: %3'
			Msg = StrTemplate(R().LC_Error_003, GetBatchKeyDetailPresentation(Adj_Batch.Surplus.BatchKey), NeedExpense, Document);
			CommonFunctionsClientServer.ShowUsersMessage(Msg);
			If CalculationSettings.RaiseOnCalculationError Then
				Raise Msg;
			EndIf;
			_new = Tables.DataForBatchShortageIncoming.Add();
			_new.BatchKey = Adj_Batch.Surplus.BatchKey;
			_new.Document = Document;
			_new.Company  = Adj_Batch.Surplus.Company;
			_new.Period   = Adj_Batch.Surplus.Date;
			_new.Quantity = NeedExpense;
		EndIf;		
	EndDo; // For Each Transfer_Batch In Transfer_BatchRows
EndProcedure

Procedure Calculate_StockCorrection(Document, BatchRow, BatchRows, Tables, CalculationSettings)
	If BatchRow.Direction = Enums.BatchDirection.Receipt Then
		Return; // receipt wiil be processed when get expense
	EndIf;
	
	Adj_BatchRows = New ValueTable();
	Adj_BatchRows.Columns.Add("Writeoff");
	Adj_BatchRows.Columns.Add("Surplus");
	
	For Each _r1 In BatchRows Do
		If _r1.Direction = Enums.BatchDirection.Receipt 
			And _r1.StockCorrectionID = BatchRow.StockCorrectionID Then

			_nr = Adj_BatchRows.Add();
			_nr.Writeoff = BatchRow;
			_nr.Surplus = _r1;
			
			Break; // only one surplus for one writeoff
		EndIf;
	EndDo;

	For Each Adj_Batch In Adj_BatchRows Do

		Balance_BatchRows = GetBatchesWithBalance(Adj_Batch.Writeoff.Company, Adj_Batch.Writeoff.BatchKey, Document.Date);
	
		NeedExpense = Adj_Batch.Writeoff.Quantity;

		For Each Balance_Batch In Balance_BatchRows Do
			If NeedExpense = 0 Then
				Break;
			EndIf;

			QtyName = ?(Not ValueIsFilled(Balance_Batch.Quantity), "Preliminary", "") + "Quantity";
			ExpenseQuantity = Min(NeedExpense, Balance_Batch[QtyName]);

			If Not ValueIsFilled(ExpenseQuantity) Then
				Continue;
			EndIf;

			NeedExpense = NeedExpense - ExpenseQuantity;

			ExpenseAmounts = New Structure();
			For Each Res In AmountResources() Do
				ExpenseAmounts.Insert(Res, AmountProportionByQuantity(ExpenseQuantity, Balance_Batch, Res, QtyName));
				Balance_Batch[Res] = Balance_Batch[Res] - ExpenseAmounts[Res];
			EndDo;
			Balance_Batch[QtyName] = Balance_Batch[QtyName] - ExpenseQuantity;

			// expense from writeoff
			NewExpense = Tables.DataForExpense.Add();
			NewExpense.Batch     = Balance_Batch.Batch;
			NewExpense.BatchKey  = Adj_Batch.Writeoff.BatchKey;
			NewExpense.Document  = Document;
			NewExpense.Company   = Adj_Batch.Writeoff.Company;
			NewExpense.Period    = Adj_Batch.Writeoff.Date;

			NewExpense[QtyName] = ExpenseQuantity;
			For Each Res In AmountResources() Do
				NewExpense[Res] = ExpenseAmounts[Res]; 
			EndDo;

			// receipt to surpluss
			NewReceipt = Tables.DataForReceipt.Add();
			FillPropertyValues(NewReceipt, NewExpense);
			NewReceipt.BatchKey  = Adj_Batch.Surplus.BatchKey;
		EndDo; // For Each Balance_Batch In BatchesWithBalance
		
		If NeedExpense <> 0 Then
			// Can not expense Batch key: %1 , Quantity: %2 , Doc: %3'
			Msg = StrTemplate(R().LC_Error_002, GetBatchKeyDetailPresentation(Adj_Batch.Writeoff.BatchKey), NeedExpense, Document);
			CommonFunctionsClientServer.ShowUsersMessage(Msg);
			If CalculationSettings.RaiseOnCalculationError Then
				Raise Msg;
			EndIf;
			_new = Tables.DataForBatchShortageOutgoing.Add();
			_new.BatchKey = Adj_Batch.Writeoff.BatchKey;
			_new.Document = Document;
			_new.Company  = Adj_Batch.Writeoff.Company;
			_new.Period   = Adj_Batch.Writeoff.Date;
			_new.Quantity = NeedExpense;
			
			// Can not receipt Batch key: %1 , Quantity: %2 , Doc: %3'
			Msg = StrTemplate(R().LC_Error_003, GetBatchKeyDetailPresentation(Adj_Batch.Surplus.BatchKey), NeedExpense, Document);
			CommonFunctionsClientServer.ShowUsersMessage(Msg);
			If CalculationSettings.RaiseOnCalculationError Then
				Raise Msg;
			EndIf;
			_new = Tables.DataForBatchShortageIncoming.Add();
			_new.BatchKey = Adj_Batch.Surplus.BatchKey;
			_new.Document = Document;
			_new.Company  = Adj_Batch.Surplus.Company;
			_new.Period   = Adj_Batch.Surplus.Date;
			_new.Quantity = NeedExpense;
		EndIf;		
	EndDo; // For Each Transfer_Batch In Transfer_BatchRows
EndProcedure

Procedure Calculate_DecompositeDocument(Document, BatchRows, Tables, CalculationSettings)
	Expense_BatchRows = New Array();
	Receipt_BatchRows = New Array();

	For Each _r1 In BatchRows Do
		If _r1.Direction = Enums.BatchDirection.Expense Then
			Expense_BatchRows.Add(_r1);
		ElsIf _r1.Direction = Enums.BatchDirection.Receipt Then
			Receipt_BatchRows.Add(_r1);
		EndIf;
	EndDo;

	If Expense_BatchRows.Count() <> 1 Then
		Raise "Expense batches found for composite document not equal to 1. Document: " + Document;
	EndIf;

	TotalReceiptAmounts = New Structure();
	For Each Res In AmountResources() Do
		TotalReceiptAmounts.Insert(Res, 0);
	EndDo;
	
	CreatedExpenses = New Array();
	CreatedReceipts = New Array();
	
	IsShortageOutgoing = False;
	
	For Each Expense_Batch In Expense_BatchRows Do 
		Balance_BatchRows = GetBatchesWithBalance(Expense_Batch.Company, Expense_Batch.BatchKey, Document.Date);
	
		NeedExpense = Expense_Batch.Quantity;
		
		For Each Balance_Batch In Balance_BatchRows Do
			If NeedExpense = 0 Then
				Break;
			EndIf;

			QtyName = ?(Not ValueIsFilled(Balance_Batch.Quantity), "Preliminary", "") + "Quantity";
			ExpenseQuantity = Min(NeedExpense, Balance_Batch[QtyName]);

			If Not ValueIsFilled(ExpenseQuantity) Then
				Continue;
			EndIf;

			NeedExpense = NeedExpense - ExpenseQuantity;

			ExpenseAmounts = New Structure();
			For Each Res In AmountResources() Do
				ExpenseAmounts.Insert(Res, AmountProportionByQuantity(ExpenseQuantity, Balance_Batch, Res, QtyName));
				Balance_Batch[Res] = Balance_Batch[Res] - ExpenseAmounts[Res];

				TotalReceiptAmounts[Res] = TotalReceiptAmounts[Res] + ExpenseAmounts[Res];
			EndDo;
			Balance_Batch[QtyName] = Balance_Batch[QtyName] - ExpenseQuantity;

			// expense bundle
			NewExpense = Tables.DataForExpense.Add();
			CreatedExpenses.Add(NewExpense);
			NewExpense.Batch     = Balance_Batch.Batch;
			NewExpense.BatchKey  = Balance_Batch.BatchKey;
			NewExpense.Document  = Document;
			NewExpense.Company   = Expense_Batch.Company;
			NewExpense.Period    = Expense_Batch.Date;

			NewExpense[QtyName] = ExpenseQuantity;
			For Each Res In AmountResources() Do
				NewExpense[Res] = ExpenseAmounts[Res]; 
			EndDo;

		EndDo; // For Each Balance_Batch In BatchesWithBalance

		If NeedExpense <> 0 Then
			// Can not expense Batch key: %1 , Quantity: %2 , Doc: %3'
			Msg = StrTemplate(R().LC_Error_002, GetBatchKeyDetailPresentation(Expense_Batch.BatchKey), NeedExpense, Document);
			CommonFunctionsClientServer.ShowUsersMessage(Msg);
			If CalculationSettings.RaiseOnCalculationError Then
				Raise Msg;
			EndIf;
			_nr = Tables.DataForBatchShortageOutgoing.Add();
			_nr.BatchKey = Expense_Batch.BatchKey;
			_nr.Document = Document;
			_nr.Company  = Expense_Batch.Company;
			_nr.Period   = Expense_Batch.Date;
			_nr.Quantity = NeedExpense;
			
			IsShortageOutgoing = True;
		EndIf;

	EndDo; // For Each Expense_Row In Expense_BatchRows

	For Each Receipt_Batch In Receipt_BatchRows Do

		NewReceipt = Tables.DataForReceipt.Add();
		CreatedReceipts.Add(NewReceipt);
		NewReceipt.Batch     = Receipt_Batch.Batch;
		NewReceipt.BatchKey  = Receipt_Batch.BatchKey;
		NewReceipt.Document  = Document;
		NewReceipt.Company   = Receipt_Batch.Company;
		NewReceipt.Period    = Receipt_Batch.Date;

		NewReceipt.Quantity = Receipt_Batch.Quantity;
		NewReceipt.PreliminaryQuantity = 0; // Decomposite batches do not have preliminary quantity

		BundleAmountValues = GetBundleAmountValues(Tables.DataForBundleAmountValues, Receipt_Batch, Expense_BatchRows[0]);

		For Each Row In BundleAmountValues Do
			For Each Res In AmountResources() Do
				NewReceipt[Res] = NewReceipt[Res] + (TotalReceiptAmounts[Res] / 100 * Row[Res]);
			EndDo;
		EndDo;
	EndDo; // For Each Receipt_Batch In Receipt_BatchRows
	
	For Each _r In CreatedExpenses Do
		_r.IsShortageOutgoing = IsShortageOutgoing;
	EndDo;
	
	For Each _r In CreatedReceipts Do
		_r.IsShortageOutgoing = IsShortageOutgoing;
	EndDo;
EndProcedure

Procedure Calculate_ReallocateIncomingDocument(Document, BatchRow, Tables, CalculationSettings)
	NewReceipt = Tables.DataForReceipt.Add();
	NewReceipt.Batch     = BatchRow.Batch;
	NewReceipt.BatchKey  = BatchRow.BatchKey;
	NewReceipt.Document  = Document;
	NewReceipt.Company   = BatchRow.Company;
	NewReceipt.Period    = BatchRow.Date;

	NewReceipt.Quantity  = BatchRow.Quantity;
	NewReceipt.PreliminaryQuantity  = BatchRow.PreliminaryQuantity;
	
	Filter = New Structure();
	Filter.Insert("BatchKey"        , NewReceipt.BatchKey);
	Filter.Insert("IncomingDocument", Document);
	Filter.Insert("OutgoingDocument", Document.Outgoing);
			
	FilteredRows = Tables.DataForReallocatedBatchesAmountValues.FindRows(Filter);
			
	ReallocatedAmounts = New Structure();
	For Each Res In AmountResources() Do 
		ReallocatedAmounts.Insert(Res, 0);
	EndDo;
	
	QtyName = ?(Not ValueIsFilled(NewReceipt.Quantity), "Preliminary", "") + "Quantity";

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
		If NewReceipt[QtyName] = Reallocated_Qty Then
			NewReceipt[Res] = ReallocatedAmounts[Res]; // all amounts
		ElsIf Reallocated_Qty <> 0 Then
			NewReceipt[Res] = NewReceipt[QtyName] * (ReallocatedAmounts[Res] / Reallocated_Qty); // proportion amounts	
		Else // Reallocated_Qty = 0
			NewReceipt[Res] = 0;
		EndIf;
	EndDo;
EndProcedure

Procedure WriteBatchWiseBalance(Tables, CalculationSettings)
	RecordSet = AccumulationRegisters.R6010B_BatchWiseBalance.CreateRecordSet();
	RecordSet.DataExchange.Load = True;
	RecordSet.Filter.Recorder.Set(CalculationSettings.CalculationMovementCostRef);
	RecordSet.Clear();
	
	For Each Row In Tables.DataForReceipt Do
		If Row.IsShortageOutgoing Then
			Continue;
		EndIf;
		NewRecordReceipt = RecordSet.Add();
		FillPropertyValues(NewRecordReceipt, Row);
		NewRecordReceipt.Period = Row.Period;
		NewRecordReceipt.RecordType = AccumulationRecordType.Receipt;
		NewRecordReceipt.Recorder = CalculationSettings.CalculationMovementCostRef;
	EndDo;

	For Each Row In Tables.DataForExpense Do
		If Row.IsShortageOutgoing Then
			Continue;
		EndIf;
		NewRecordR6010B = RecordSet.Add();
		FillPropertyValues(NewRecordR6010B, Row);
		NewRecordR6010B.Period = Row.Period;
		NewRecordR6010B.RecordType = AccumulationRecordType.Expense;
		NewRecordR6010B.Recorder = CalculationSettings.CalculationMovementCostRef;
	EndDo;
	
	RecordSet.Write();
EndProcedure

Procedure WriteWriteoffBatches(Tables, CalculationSettings)
	RecordSet = InformationRegisters.T6095S_WriteOffBatchesInfo.CreateRecordSet();
	RecordSet.DataExchange.Load = True;
	RecordSet.Filter.Recorder.Set(CalculationSettings.CalculationMovementCostRef);
	RecordSet.Clear();
	
	_AmountResources = StrConcat(AmountResources(), ",");
	_QuantityResources = "Quantity, PreliminaryQuantity";
	
	Tables.DataForWriteOffBatches.GroupBy(
	"Period, Document, Company, Branch, ProfitLossCenter, ExpenseType, ItemKey, Currency, RowID, Batch, BatchKey,
	|AmountCorrectionType, CorrectionExpenseRevenueType", 
		_AmountResources + "," + _QuantityResources);
	
	For Each Row In Tables.DataForWriteOffBatches Do
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Period = Row.Period;
		NewRecord.Recorder = CalculationSettings.CalculationMovementCostRef;
	EndDo;
	
	RecordSet.Write();
EndProcedure

Function GetBatchesWithBalance(Company, BatchKey, Period, BatchDocument = Undefined)
	Query = New Query();
	Query.Text =
	"SELECT
	|	BatchWiseBalance.Batch,
	|	BatchWiseBalance.Batch.Date AS BatchDate,
	|	CASE
	|		WHEN BatchWiseBalance.QuantityBalance <> 0
	|			THEN -1
	|		ELSE 1
	|	END AS Priority,
	|	BatchWiseBalance.BatchKey,
	|	BatchWiseBalance.QuantityBalance AS Quantity,
	|	BatchWiseBalance.PreliminaryQuantityBalance AS PreliminaryQuantity,
	|	BatchWiseBalance.InvoiceAmountBalance AS InvoiceAmount,
	|	BatchWiseBalance.InvoiceTaxAmountBalance AS InvoiceTaxAmount,
	|	BatchWiseBalance.PreliminaryAmountBalance AS PreliminaryAmount,
	|	BatchWiseBalance.PreliminaryTaxAmountBalance AS PreliminaryTaxAmount,
	|	BatchWiseBalance.ExtraCostAmountByRatioBalance AS ExtraCostAmountByRatio,
	|	BatchWiseBalance.ExtraCostTaxAmountByRatioBalance AS ExtraCostTaxAmountByRatio,
	|	BatchWiseBalance.ExtraDirectCostAmountBalance AS ExtraDirectCostAmount,
	|	BatchWiseBalance.ExtraDirectCostTaxAmountBalance AS ExtraDirectCostTaxAmount,
	|	BatchWiseBalance.IndirectCostAmountBalance AS IndirectCostAmount,
	|	BatchWiseBalance.IndirectCostTaxAmountBalance AS IndirectCostTaxAmount,
	|	BatchWiseBalance.AllocatedCostAmountBalance AS AllocatedCostAmount,
	|	BatchWiseBalance.AllocatedCostTaxAmountBalance AS AllocatedCostTaxAmount,
	|	BatchWiseBalance.AllocatedRevenueAmountBalance AS AllocatedRevenueAmount,
	|	BatchWiseBalance.AllocatedRevenueTaxAmountBalance AS AllocatedRevenueTaxAmount
	|INTO tmp
	|FROM
	|	AccumulationRegister.R6010B_BatchWiseBalance.Balance(ENDOFPERIOD(&EndPeriod, DAY), BatchKey = &BatchKey
	|	AND Batch.Company = &Company
	|	AND CASE
	|		WHEN &Filter_BatchDocument
	|			THEN Batch.Document = &BatchDocument
	|		ELSE TRUE
	|	END) AS BatchWiseBalance
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	*
	|FROM
	|	tmp AS tmp
	|
	|ORDER BY
	|	Priority,
	|	BatchDate";

	Query.SetParameter("Company", Company);
	Query.SetParameter("BatchKey", BatchKey);
	Query.SetParameter("EndPeriod", Period);
	Query.SetParameter("Filter_BatchDocument", ValueIsFilled(BatchDocument));
	Query.SetParameter("BatchDocument", BatchDocument);

	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

Function GetBatchTree(TempTablesManager, CalculationSettings)
	Query = New Query();
	Query.TempTablesManager = TempTablesManager;
	Query.Text =
	"SELECT
	|	SUM(T6020S_BatchKeysInfo.Quantity) AS Quantity,
	|	SUM(T6020S_BatchKeysInfo.PreliminaryQuantity) AS PreliminaryQuantity,
	|	SUM(T6020S_BatchKeysInfo.InvoiceAmount) AS InvoiceAmount,
	|	SUM(T6020S_BatchKeysInfo.InvoiceTaxAmount) AS InvoiceTaxAmount,
	|	SUM(T6020S_BatchKeysInfo.PreliminaryAmount) AS PreliminaryAmount,
	|   SUM(T6020S_BatchKeysInfo.PreliminaryTaxAmount) AS PreliminaryTaxAmount,
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
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.SalesInvoice
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.RetailSalesReceipt
	|	    or (T6020S_BatchKeysInfo.Recorder refs Document.PurchaseInvoice 
	|			and T6020S_BatchKeysInfo.PreliminaryID <> """")
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
	|		or (T6020S_BatchKeysInfo.Recorder refs Document.PurchaseInvoice 
	|			and T6020S_BatchKeysInfo.PreliminaryID <> """")
	|			then T6020S_BatchKeysInfo.Branch
	|		else undefined
	|	end AS Branch,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.SalesInvoice
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.RetailSalesReceipt
	|			then T6020S_BatchKeysInfo.Currency
	|		else undefined
	|	end AS Currency,
	|
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.ItemStockAdjustment
	|			then T6020S_BatchKeysInfo.RowID
	|		else undefined
	|	end as ItemStockAdjustmentID,
	|
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.StockCorrection
	|			then T6020S_BatchKeysInfo.RowID
	|		else undefined
	|	end as StockCorrectionID,
	|
	|	T6020S_BatchKeysInfo.Store AS Store,
	|	T6020S_BatchKeysInfo.FixedAsset AS FixedAsset,
	|	T6020S_BatchKeysInfo.SerialLotNumber AS SerialLotNumber,
	|	T6020S_BatchKeysInfo.SourceOfOrigin AS SourceOfOrigin,
	|	T6020S_BatchKeysInfo.ItemKey AS ItemKey,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.PurchaseInvoice
	|			OR T6020S_BatchKeysInfo.Recorder refs Document.GoodsReceipt
	|				then T6020S_BatchKeysInfo.PreliminaryID
	|			else """"
	|		end as PreliminaryID
	|
//	|	case
//	|		when T6020S_BatchKeysInfo.Recorder refs Document.PurchaseInvoice
//	|				then T6020S_BatchKeysInfo.PreliminaryKey
//	|			else """"
//	|		end as PreliminaryKey
	| 
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
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.SalesInvoice
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.RetailSalesReceipt
	|	    or (T6020S_BatchKeysInfo.Recorder refs Document.PurchaseInvoice 
	|			and T6020S_BatchKeysInfo.PreliminaryID <> """")
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
	|	    or (T6020S_BatchKeysInfo.Recorder refs Document.PurchaseInvoice 
	|			and T6020S_BatchKeysInfo.PreliminaryID <> """")
	|			then T6020S_BatchKeysInfo.Branch
	|		else undefined
	|	end,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.SalesInvoice
	|		OR T6020S_BatchKeysInfo.Recorder refs Document.RetailSalesReceipt
	|			then T6020S_BatchKeysInfo.Currency
	|		else undefined
	|	end,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.ItemStockAdjustment
	|			then T6020S_BatchKeysInfo.RowID
	|		else undefined
	|	end,
	|
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.StockCorrection
	|			then T6020S_BatchKeysInfo.RowID
	|		else undefined
	|	end,
	|
	|	T6020S_BatchKeysInfo.Store,
	|	T6020S_BatchKeysInfo.FixedAsset,
	|	T6020S_BatchKeysInfo.SerialLotNumber,
	|	T6020S_BatchKeysInfo.SourceOfOrigin,
	|	T6020S_BatchKeysInfo.ItemKey,
	|	case
	|		when T6020S_BatchKeysInfo.Recorder refs Document.PurchaseInvoice
	|			OR T6020S_BatchKeysInfo.Recorder refs Document.GoodsReceipt
	|				then T6020S_BatchKeysInfo.PreliminaryID
	|			else """"
	|		end
//	|	case
//	|		when T6020S_BatchKeysInfo.Recorder refs Document.PurchaseInvoice
//	|				then T6020S_BatchKeysInfo.PreliminaryKey
//	|			else """"
//	|		end
	|;
	|
	// ////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchKeysRegister.Quantity AS Quantity,
	|	BatchKeysRegister.PreliminaryQuantity AS PreliminaryQuantity,
	|	BatchKeysRegister.InvoiceAmount AS InvoiceAmount,
	|	BatchKeysRegister.InvoiceTaxAmount AS InvoiceTaxAmount,
	|	BatchKeysRegister.PreliminaryAmount AS PreliminaryAmount,
	|	BatchKeysRegister.PreliminaryTaxAmount AS PreliminaryTaxAmount,
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
	|	BatchKeysRegister.ItemStockAdjustmentID AS ItemStockAdjustmentID,
	|	BatchKeysRegister.StockCorrectionID AS StockCorrectionID,
	|	BatchKeysRegister.Store AS Store,
	|	BatchKeysRegister.FixedAsset AS FixedAsset,
	|	BatchKeysRegister.SerialLotNumber AS SerialLotNumber,
	|	BatchKeysRegister.SourceOfOrigin AS SourceOfOrigin,
	|	BatchKeysRegister.ItemKey AS ItemKey,
	|	BatchKeysRegister.PreliminaryID AS PreliminaryID
//	|	BatchKeysRegister.PreliminaryKey AS PreliminaryKey
	|INTO BatchKeysInfo
	|FROM
	|	BatchKeysRegister AS BatchKeysRegister
	|;
	// ////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchKeys.Ref AS BatchKey,
	|	SUM(BatchKeysInfo.Quantity) AS Quantity,
	|	SUM(BatchKeysInfo.PreliminaryQuantity) AS PreliminaryQuantity,
	|	SUM(BatchKeysInfo.InvoiceAmount) AS InvoiceAmount,
	|	SUM(BatchKeysInfo.InvoiceTaxAmount) AS InvoiceTaxAmount,
	|	SUM(BatchKeysInfo.PreliminaryAmount) AS PreliminaryAmount,
	|	SUM(BatchKeysInfo.PreliminaryTaxAmount) AS PreliminaryTaxAmount,
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
	|	BatchKeysInfo.ItemStockAdjustmentID AS ItemStockAdjustmentID,
	|	BatchKeysInfo.StockCorrectionID AS StockCorrectionID,
	|	BatchKeysInfo.Branch AS Branch,
	|	BatchKeysInfo.Currency AS Currency,
	|	BatchKeysInfo.FixedAsset AS FixedAsset,
	|	BatchKeysInfo.PreliminaryID AS PreliminaryID
//	|	BatchKeysInfo.PreliminaryKey AS PreliminaryKey
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
	|	BatchKeysInfo.ItemStockAdjustmentID,
	|	BatchKeysInfo.StockCorrectionID,
	|	BatchKeysInfo.Branch,
	|	BatchKeysInfo.Currency,
	|	BatchKeysInfo.FixedAsset,
	|	BatchKeysInfo.PreliminaryID
//	|	BatchKeysInfo.PreliminaryKey
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchKeys.BatchKey AS BatchKey,
	|	BatchKeys.Quantity AS Quantity,
	|	BatchKeys.PreliminaryQuantity AS PreliminaryQuantity,
	|	BatchKeys.InvoiceAmount AS InvoiceAmount,
	|	BatchKeys.InvoiceTaxAmount AS InvoiceTaxAmount,
	|	BatchKeys.PreliminaryAmount AS PreliminaryAmount,
	|	BatchKeys.PreliminaryTaxAmount AS PreliminaryTaxAmount,
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
	|	BatchKeys.BatchDocument AS BatchDocument,
	|	BatchKeys.SalesInvoice AS SalesInvoice,
	|	BatchKeys.ProfitLossCenter AS ProfitLossCenter,
	|	BatchKeys.ExpenseType AS ExpenseType,
	|	BatchKeys.RowID AS RowID,
	|	BatchKeys.ItemStockAdjustmentID AS ItemStockAdjustmentID,
	|	BatchKeys.StockCorrectionID AS StockCorrectionID,
	|	BatchKeys.Branch AS Branch,
	|	BatchKeys.Currency AS Currency,
	|	BatchKeys.FixedAsset AS FixedAsset,
	|	BatchKeys.PreliminaryID AS PreliminaryID
//	|	BatchKeys.PreliminaryKey AS PreliminaryKey
	|INTO AllData
	|FROM
	|	BatchKeys AS BatchKeys
	|		LEFT JOIN Catalog.Batches AS Batches
	|		ON (Batches.Document = BatchKeys.Document)
	|		AND (Batches.Company = BatchKeys.Company)
	|		AND (Batches.Date = BatchKeys.Date)
	|		AND (NOT Batches.DeletionMark)
	|;
	|
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AllData.BatchKey AS BatchKey,
	|	SUM(AllData.Quantity) AS Quantity,
	|	SUM(AllData.PreliminaryQuantity) AS PreliminaryQuantity,
	|	SUM(AllData.InvoiceAmount) AS InvoiceAmount,
	|	SUM(AllData.InvoiceTaxAmount) AS InvoiceTaxAmount,
	|	SUM(AllData.PreliminaryAmount) AS PreliminaryAmount,
	|	SUM(AllData.PreliminaryTaxAmount) AS PreliminaryTaxAmount,
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
	|	AllData.BatchDocument AS BatchDocument,
	|	AllData.SalesInvoice AS SalesInvoice,
	|	AllData.ProfitLossCenter AS ProfitLossCenter,
	|	AllData.ExpenseType AS ExpenseType,
	|	AllData.RowID AS RowID,
	|	AllData.ItemStockAdjustmentID AS ItemStockAdjustmentID,
	|	AllData.StockCorrectionID AS StockCorrectionID,
	|	AllData.Branch AS Branch,
	|	AllData.Currency AS Currency,
	|	AllData.FixedAsset AS FixedAsset,
	|	AllData.PreliminaryID AS PreliminaryID
//	|	AllData.PreliminaryKey AS PreliminaryKey
	|INTO AllDataGrouped
	|FROM
	|	AllData AS AllData
	|GROUP BY
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
	|	AllData.ItemStockAdjustmentID,
	|	AllData.StockCorrectionID,
	|	AllData.Branch,
	|	AllData.Currency,
	|	AllData.FixedAsset,
	|	AllData.PreliminaryID
//	|	AllData.PreliminaryKey
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AllDataGrouped.BatchKey AS BatchKey,
	|	AllDataGrouped.Quantity AS Quantity,
	|	AllDataGrouped.PreliminaryQuantity AS PreliminaryQuantity,
	|	AllDataGrouped.InvoiceAmount AS InvoiceAmount,
	|	AllDataGrouped.InvoiceTaxAmount AS InvoiceTaxAmount,
	|	AllDataGrouped.PreliminaryAmount AS PreliminaryAmount,
	|	AllDataGrouped.PreliminaryTaxAmount AS PreliminaryTaxAmount,
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
	|	AllDataGrouped.BatchDocument AS BatchDocument,
	|	AllDataGrouped.SalesInvoice AS SalesInvoice,
	|	AllDataGrouped.ProfitLossCenter AS ProfitLossCenter,
	|	AllDataGrouped.ExpenseType AS ExpenseType,
	|	AllDataGrouped.RowID AS RowID,
	|	AllDataGrouped.ItemStockAdjustmentID AS ItemStockAdjustmentID,
	|	AllDataGrouped.StockCorrectionID AS StockCorrectionID,
	|	AllDataGrouped.Branch AS Branch,
	|	AllDataGrouped.Currency AS Currency,
	|	AllDataGrouped.FixedAsset AS FixedAsset,
	|	AllDataGrouped.PreliminaryID AS PreliminaryID
//	|	AllDataGrouped.PreliminaryKey AS PreliminaryKey
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
	|DROP BatchKeysInfo;
	|DROP BatchKeys;
	|DROP AllData;
	|DROP AllDataGrouped";
	QueryDrop.Execute();
	
	Return Tree;
EndFunction

Function GetPreliminaryBatches(PreliminaryID, ItemKey, SerialLotNumber, SourceOfOrigin)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	T6020S_BatchKeysInfo.Recorder AS PreliminaryDocument
	|FROM
	|	InformationRegister.T6020S_BatchKeysInfo AS T6020S_BatchKeysInfo
	|WHERE
	|	T6020S_BatchKeysInfo.IsPreliminary
	|	AND T6020S_BatchKeysInfo.RowID = &PreliminaryID
	|GROUP BY
	|	T6020S_BatchKeysInfo.Recorder,
	|	T6020S_BatchKeysInfo.Period
	|
	|ORDER BY
	|	T6020S_BatchKeysInfo.Period
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchKeys.Ref AS BatchKey
	|FROM
	|	Catalog.BatchKeys AS BatchKeys
	|WHERE
	|		BatchKeys.ItemKey = &ItemKey
	|		AND BatchKeys.SerialLotNumber = &SerialLotNumber
	|		AND BatchKeys.SourceOfOrigin = &SourceOfOrigin
	|	AND NOT BatchKeys.DeletionMark";
	Query.SetParameter("PreliminaryID", PreliminaryID);
	Query.SetParameter("ItemKey", ItemKey);
	Query.SetParameter("SerialLotNumber", SerialLotNumber);
	Query.SetParameter("SourceOfOrigin", SourceOfOrigin);
	QueryResults = Query.ExecuteBatch();
	TablePreliminaryDocuments = QueryResults[0].Unload();
	TablePreliminaryBatchKeys = QueryResults[1].Unload();
	Return New Structure("Documents, BatchKeys", 
		TablePreliminaryDocuments, TablePreliminaryBatchKeys);
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
	|	AllData.Batch.Company AS Company
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

Function AmountProportionByQuantity(Quantity, Row_Batch, AmountColumnName, QuantityColumnName)
	AmountResult = 0;
	If Row_Batch[QuantityColumnName] - Quantity = 0 Then
		AmountResult = Row_Batch[AmountColumnName];
	Else
		If Row_Batch[QuantityColumnName] <> 0 Then
			AmountResult = Round((Row_Batch[AmountColumnName] / Row_Batch[QuantityColumnName]) * Quantity, 2);
		EndIf;
	EndIf;
	Return AmountResult;
EndFunction
