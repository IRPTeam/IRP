
// strict-types

#Region TRANSFER_DOCUMENTS

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

#EndRegion

#Region COMPOSITE_DOCUMNETS

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

#EndRegion

#Region DECOMPOSITE_DOCUMENTS

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

#EndRegion

#Region MULTI_DIRECTION_DOCUMENTS

// Get array of multi direction document.
// 
// Returns:
//  Array - Get array of multi direction document
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

#EndRegion

#Region BATCHES_DOCUMENTS

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
	Return ArrayOfTypes;
EndFunction

// Get batch documents types.
// 
// Returns:
//  TypeDescription - Get batch documents types
Function GetBatchDocumentsTypes()
	ArrayOfTypes = GetArrayOfBatchDocumentTypes();
	Types = New TypeDescription(ArrayOfTypes);
	Return Types;
EndFunction

#EndRegion

// Posting batch wise balance.
// 
// Parameters:
//  CalculationSettings - See GetCalculationSettings
//  AddInfo - Undefined - Add info
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

// Entry point
// 
// Parameters:
//  LocksStorage - Array - Locks storage
//  CalculationSettings - See GetCalculationSettings
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

		ReallocatePeriod = NegativeStockBalanceSelection.Period - 2; // Date

		PositiveStockBalance = GetPositiveStockBalance(NegativeStockBalanceSelection.Company, ReallocatePeriod, LackItemList);

		ResultItemList = EmptyResultItemList.CopyColumns(); // See GetEmptyResultItemList
		IsQuantityEnough = True;
		For Each LackRow In LackItemList Do

			LackQuantity = LackRow.Quantity; // Number
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
		DocRef = QuerySelection.Ref; // DocumentRef.BatchReallocateIncoming, DocumentRef.BatchReallocateOutgoing 
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

// Get released batch reallocate document.
// 
// Parameters:
//  DocumentName - String - Document name
//  BatchReallocateRef - DocumentRef.CalculationMovementCosts - Batch reallocate ref
//  ReallocatePeriod - Date - Reallocate period
// 
// Returns:
//  DocumentObject.BatchReallocateOutgoing, DocumentObject.BatchReallocateIncoming - Get released batch reallocate document
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
		Ref = QuerySelection.Ref; // DocumentRef.BatchReallocateIncoming, DocumentRef.BatchReallocateOutgoing
		DocumentObject = Ref.GetObject();
	Else
		DocumentObject = Documents[DocumentName].CreateDocument();
	EndIf;
	DocumentObject.Date = ReallocatePeriod;
	DocumentObject.BatchReallocate = BatchReallocateRef;
	DocumentObject.Write();
	Return DocumentObject.Ref.GetObject();
EndFunction

// Get negative stock balance.
// 
// Parameters:
//  ProcessedRecorders - Array - Processed recorders
//  EndPeriod - Date - End period
// 
// Returns:
//  QueryResultSelection - Get negative stock balance:
//  * Period - Date
//  * Recorder - See Document.BatchReallocateIncoming.Document
//  * Company - CatalogRef.Companies
//  * Store - CatalogRef.Stores
//  * ItemKey - CatalogRef.ItemKeys
//  * Quantity - Number
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

// Get positive stock balance.
// 
// Parameters:
//  Company - CatalogRef.Companies - Company
//  Period - Date - Period
//  ItemList - ValueTable - Item list
// 
// Returns:
//  ValueTable - Get positive stock balance:
//  * Company - CatalogRef.Companies
//  * Store - CatalogRef.Stores
//  * ItemKey - CatalogRef.ItemKeys
//  * Quantity - Number
//  * QuantityBalance - Number
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

// Do registration calculation mode landed cost.
// 
// Parameters:
//  LocksStorage - Array - Locks storage
//  CalculationSettings - See GetCalculationSettings
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
	"AmountValue, AmountTaxValue, AmountCostRatio, NotDirectCosts, AmountCost, AmountCostTax, AmountRevenue, AmountRevenueTax");

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
	"Amount, AmountTax, AmountCostRatio, NotDirectCosts, Quantity, AmountCost, AmountCostTax, AmountRevenue, AmountRevenueTax");

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
	"Amount, AmountTax, AmountCostRatio, NotDirectCosts, Quantity, AmountCost, AmountCostTax, AmountRevenue, AmountRevenueTax");

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
	"Amount, AmountTax, AmountCostRatio, NotDirectCosts, AmountCost, AmountCostTax, AmountRevenue, AmountRevenueTax");

	For Each Row In BatchWiseBalanceTables.DataForWriteOffBatches Do
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
	
	// Relevance
	InformationRegisters.T6030S_BatchRelevance.BatchRelevance_Clear(CalculationSettings.Company, CalculationSettings.EndPeriod);
	InformationRegisters.T6030S_BatchRelevance.BatchRelevance_Restore(CalculationSettings.Company, CalculationSettings.EndPeriod);	
EndProcedure

Function GetBatchWiseBalance(CalculationSettings)
	tmp_manager = New TempTablesManager();
	Tree = GetBatchTree(tmp_manager, CalculationSettings);

	// EmptyTable_BatchWiseBalance
	RegMetadata = Metadata.AccumulationRegisters.R6010B_BatchWiseBalance;
	EmptyTable_BatchWiseBalance = New ValueTable();
	EmptyTable_BatchWiseBalance.Columns.Add("Batch"     , New TypeDescription("CatalogRef.Batches"));
	EmptyTable_BatchWiseBalance.Columns.Add("BatchKey"  , New TypeDescription("CatalogRef.BatchKeys"));
	EmptyTable_BatchWiseBalance.Columns.Add("Document"  , GetBatchDocumentsTypes());
	EmptyTable_BatchWiseBalance.Columns.Add("Company"   , New TypeDescription("CatalogRef.Companies"));
	EmptyTable_BatchWiseBalance.Columns.Add("Period"    , RegMetadata.StandardAttributes.Period.Type);
	EmptyTable_BatchWiseBalance.Columns.Add("Quantity"  , RegMetadata.Resources.Quantity.Type);
	EmptyTable_BatchWiseBalance.Columns.Add("Amount"    , RegMetadata.Resources.Amount.Type);
	EmptyTable_BatchWiseBalance.Columns.Add("AmountTax" , RegMetadata.Resources.AmountTax.Type);
	EmptyTable_BatchWiseBalance.Columns.Add("NotDirectCosts"  , RegMetadata.Resources.NotDirectCosts.Type);
	EmptyTable_BatchWiseBalance.Columns.Add("AmountCostRatio" , RegMetadata.Resources.AmountCostRatio.Type);
	EmptyTable_BatchWiseBalance.Columns.Add("AmountCost"      , RegMetadata.Resources.AmountCost.Type);
	EmptyTable_BatchWiseBalance.Columns.Add("AmountCostTax"   , RegMetadata.Resources.AmountCostTax.Type);
	EmptyTable_BatchWiseBalance.Columns.Add("AmountRevenue"   , RegMetadata.Resources.AmountRevenue.Type);
	EmptyTable_BatchWiseBalance.Columns.Add("AmountRevenueTax", RegMetadata.Resources.AmountRevenueTax.Type);
	
	EmptyTable_BatchWiseBalance.Columns.Add("IsSalesConsignorStocks" , RegMetadata.Attributes.IsSalesConsignorStocks.Type);
	
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
	DataForBundleAmountValues.Columns.Add("AmountValue"    , RegMetadata.Resources.AmountValue.Type);
	DataForBundleAmountValues.Columns.Add("AmountTaxValue" , RegMetadata.Resources.AmountTaxValue.Type);
	DataForBundleAmountValues.Columns.Add("NotDirectCosts" , RegMetadata.Resources.NotDirectCosts.Type);
	DataForBundleAmountValues.Columns.Add("AmountCostRatio" , RegMetadata.Resources.AmountCostRatio.Type);
	DataForBundleAmountValues.Columns.Add("BatchKeyBundle"  , RegMetadata.Dimensions.BatchKeyBundle.Type);
	DataForBundleAmountValues.Columns.Add("AmountCost"      , RegMetadata.Resources.AmountCost.Type);
	DataForBundleAmountValues.Columns.Add("AmountCostTax"   , RegMetadata.Resources.AmountCostTax.Type);
	DataForBundleAmountValues.Columns.Add("AmountRevenue"   , RegMetadata.Resources.AmountRevenue.Type);
	DataForBundleAmountValues.Columns.Add("AmountRevenueTax", RegMetadata.Resources.AmountRevenueTax.Type);
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
	DataForCompositeBatchesAmountValues.Columns.Add("Amount"            , RegMetadata.Resources.Amount.Type);
	DataForCompositeBatchesAmountValues.Columns.Add("AmountTax"         , RegMetadata.Resources.AmountTax.Type);
	DataForCompositeBatchesAmountValues.Columns.Add("NotDirectCosts"    , RegMetadata.Resources.NotDirectCosts.Type);
	DataForCompositeBatchesAmountValues.Columns.Add("AmountCostRatio"   , RegMetadata.Resources.AmountCostRatio.Type);
	DataForCompositeBatchesAmountValues.Columns.Add("AmountCost"      , RegMetadata.Resources.AmountCost.Type);
	DataForCompositeBatchesAmountValues.Columns.Add("AmountCostTax"   , RegMetadata.Resources.AmountCostTax.Type);
	DataForCompositeBatchesAmountValues.Columns.Add("AmountRevenue"   , RegMetadata.Resources.AmountRevenue.Type);
	DataForCompositeBatchesAmountValues.Columns.Add("AmountRevenueTax", RegMetadata.Resources.AmountRevenueTax.Type);
	
	Tables.Insert("DataForCompositeBatchesAmountValues", DataForCompositeBatchesAmountValues);
	
	// DataForReallocatedBatchesAmountValues
	RegMetadata = Metadata.InformationRegisters.T6080S_ReallocatedBatchesAmountValues;
	DataForReallocatedBatchesAmountValues = New ValueTable();
	DataForReallocatedBatchesAmountValues.Columns.Add("Period"           , RegMetadata.StandardAttributes.Period.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("OutgoingDocument" , RegMetadata.Dimensions.OutgoingDocument.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("IncomingDocument" , RegMetadata.Dimensions.IncomingDocument.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("BatchKey"         , RegMetadata.Dimensions.BatchKey.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("Quantity"         , RegMetadata.Resources.Quantity.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("Amount"           , RegMetadata.Resources.Amount.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("AmountTax"        , RegMetadata.Resources.AmountTax.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("NotDirectCosts"   , RegMetadata.Resources.NotDirectCosts.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("AmountCostRatio"  , RegMetadata.Resources.AmountCostRatio.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("AmountCost"      , RegMetadata.Resources.AmountCost.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("AmountCostTax"   , RegMetadata.Resources.AmountCostTax.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("AmountRevenue"   , RegMetadata.Resources.AmountRevenue.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("AmountRevenueTax", RegMetadata.Resources.AmountRevenueTax.Type);
	
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
	DataForWriteOffBatches.Columns.Add("Amount"           , RegMetadata.Resources.Amount.Type);
	DataForWriteOffBatches.Columns.Add("AmountTax"        , RegMetadata.Resources.AmountTax.Type);
	DataForWriteOffBatches.Columns.Add("NotDirectCosts"   , RegMetadata.Resources.NotDirectCosts.Type);
	DataForWriteOffBatches.Columns.Add("AmountCostRatio"  , RegMetadata.Resources.AmountCostRatio.Type);
	DataForWriteOffBatches.Columns.Add("AmountCost"      , RegMetadata.Resources.AmountCost.Type);
	DataForWriteOffBatches.Columns.Add("AmountCostTax"   , RegMetadata.Resources.AmountCostTax.Type);
	DataForWriteOffBatches.Columns.Add("AmountRevenue"   , RegMetadata.Resources.AmountRevenue.Type);
	DataForWriteOffBatches.Columns.Add("AmountRevenueTax", RegMetadata.Resources.AmountRevenueTax.Type);
	Tables.Insert("DataForWriteOffBatches", DataForWriteOffBatches);
	
	//TableOfReturnedBatches
	RegMetadata = Metadata.InformationRegisters.T6020S_BatchKeysInfo;
	TableOfReturnedBatches = New ValueTable();
	TableOfReturnedBatches.Columns.Add("IsOpeningBalance" , New TypeDescription("Boolean"));
	TableOfReturnedBatches.Columns.Add("Skip"             , New TypeDescription("Boolean"));
	TableOfReturnedBatches.Columns.Add("Priority"         , New TypeDescription("Number"));
	TableOfReturnedBatches.Columns.Add("BatchKey"         , New TypeDescription("CatalogRef.BatchKeys"));
	TableOfReturnedBatches.Columns.Add("Quantity"         , RegMetadata.Resources.Quantity.Type);
	TableOfReturnedBatches.Columns.Add("Amount"           , RegMetadata.Resources.Amount.Type);
	TableOfReturnedBatches.Columns.Add("AmountTax"        , RegMetadata.Resources.AmountTax.Type);
	TableOfReturnedBatches.Columns.Add("NotDirectCosts"   , RegMetadata.Resources.NotDirectCosts.Type);
	TableOfReturnedBatches.Columns.Add("AmountCostRatio"  , RegMetadata.Resources.AmountCostRatio.Type);
	TableOfReturnedBatches.Columns.Add("AmountCost"       , RegMetadata.Resources.AmountCost.Type);
	TableOfReturnedBatches.Columns.Add("AmountCostTax"    , RegMetadata.Resources.AmountCostTax.Type);
	TableOfReturnedBatches.Columns.Add("AmountRevenue"    , RegMetadata.Resources.AmountRevenue.Type);
	TableOfReturnedBatches.Columns.Add("AmountRevenueTax" , RegMetadata.Resources.AmountRevenueTax.Type);
	TableOfReturnedBatches.Columns.Add("Document"         , GetBatchDocumentsTypes());
	TableOfReturnedBatches.Columns.Add("Date"             , RegMetadata.StandardAttributes.Period.Type);
	TableOfReturnedBatches.Columns.Add("Company"          , RegMetadata.Dimensions.Company.Type);
	TableOfReturnedBatches.Columns.Add("Direction"        , RegMetadata.Dimensions.Direction.Type);
	TableOfReturnedBatches.Columns.Add("Batch"            , New TypeDescription("CatalogRef.Batches"));
	TableOfReturnedBatches.Columns.Add("QuantityBalance"  , RegMetadata.Resources.Quantity.Type);
	TableOfReturnedBatches.Columns.Add("AmountBalance"    , RegMetadata.Resources.Amount.Type);
	TableOfReturnedBatches.Columns.Add("AmountTaxBalance" , RegMetadata.Resources.AmountTax.Type);
	TableOfReturnedBatches.Columns.Add("NotDirectCostsBalance"  , RegMetadata.Resources.NotDirectCosts.Type);
	TableOfReturnedBatches.Columns.Add("AmountCostRatioBalance" , RegMetadata.Resources.AmountCostRatio.Type);
	TableOfReturnedBatches.Columns.Add("AmountCostBalance"       , RegMetadata.Resources.AmountCost.Type);
	TableOfReturnedBatches.Columns.Add("AmountCostTaxBalance"    , RegMetadata.Resources.AmountCostTax.Type);
	TableOfReturnedBatches.Columns.Add("AmountRevenueBalance"    , RegMetadata.Resources.AmountRevenue.Type);
	TableOfReturnedBatches.Columns.Add("AmountRevenueTaxBalance" , RegMetadata.Resources.AmountRevenueTax.Type);
	TableOfReturnedBatches.Columns.Add("BatchDocument"    , RegMetadata.Dimensions.BatchDocument.Type);
	TableOfReturnedBatches.Columns.Add("SalesInvoice"     , RegMetadata.Dimensions.SalesInvoice.Type);
	
	For Each Row In Tree.Rows Do
		CalculateBatch(Row.Document, Row.Rows, Tables, Tree, TableOfReturnedBatches, EmptyTable_BatchWiseBalance, CalculationSettings);
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

Function GetBatchTree(TempTablesManager, CalculationSettings)
	Query = New Query();
	Query.TempTablesManager = TempTablesManager;
	Query.Text =
	"SELECT
	|	SUM(T6020S_BatchKeysInfo.Quantity) AS Quantity,
	|	SUM(T6020S_BatchKeysInfo.Amount) AS Amount,
	|	SUM(T6020S_BatchKeysInfo.AmountTax) AS AmountTax,
	|	SUM(T6020S_BatchKeysInfo.AmountCostRatio) AS AmountCostRatio,
	|	
//	|	T6020S_BatchKeysInfo.Recorder AS Document,
//	|	T6020S_BatchKeysInfo.Recorder.PointInTime AS PointInTime,
	|	
	|	sum(T6020S_BatchKeysInfo.NotDirectCosts) AS NotDirectCosts,
	|
	|	sum(T6020S_BatchKeysInfo.AmountCost) AS AmountCost,
	|	sum(T6020S_BatchKeysInfo.AmountCostTax) AS AmountCostTax,
	|	sum(T6020S_BatchKeysInfo.AmountRevenue) AS AmountRevenue,
	|	sum(T6020S_BatchKeysInfo.AmountRevenueTax) AS AmountRevenueTax,
	|//----------------------------------------
	|	case 
	|	when T6020S_BatchKeysInfo.Recorder refs Document.ProductionCostsAllocation 
	|	then T6020S_BatchKeysInfo.ProductionDocument
	|
	|	when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalCostAllocation 
	|	then T6020S_BatchKeysInfo.PurchaseInvoiceDocument
	|
	|	when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalRevenueAllocation 
	|	then T6020S_BatchKeysInfo.PurchaseInvoiceDocument
	|
	|	else T6020S_BatchKeysInfo.Recorder end AS Document,
	|//----------------------------------------
	|	case 
	|	when T6020S_BatchKeysInfo.Recorder refs Document.ProductionCostsAllocation 
	|	then T6020S_BatchKeysInfo.ProductionDocument.PointInTime
	|
	|	when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalCostAllocation 
	|	then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.PointInTime
	|
	|	when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalRevenueAllocation 
	|	then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.PointInTime
	|
	|	else T6020S_BatchKeysInfo.Recorder.PointInTime end AS PointInTime,
	|//----------------------------------------
	|	case 
	|	when T6020S_BatchKeysInfo.Recorder refs Document.ProductionCostsAllocation
	|	then T6020S_BatchKeysInfo.ProductionDocument.Date
	|
	|	when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalCostAllocation
	|	then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.Date
	|
	|	when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalRevenueAllocation
	|	then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.Date
	|
	|	else T6020S_BatchKeysInfo.Period end AS Date,
	|//----------------------------------------
	|	T6020S_BatchKeysInfo.Company AS Company,
	|	T6020S_BatchKeysInfo.Direction AS Direction,
	|	T6020S_BatchKeysInfo.BatchDocument AS BatchDocument,
	|	T6020S_BatchKeysInfo.SalesInvoice AS SalesInvoice,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet then T6020S_BatchKeysInfo.ProfitLossCenter else undefined end AS ProfitLossCenter,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet then T6020S_BatchKeysInfo.ExpenseType else undefined end AS ExpenseType,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet then T6020S_BatchKeysInfo.RowID else undefined end AS RowID,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet then T6020S_BatchKeysInfo.Branch else undefined end AS Branch,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet then T6020S_BatchKeysInfo.Currency else undefined end AS Currency,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.ItemStockAdjustment then T6020S_BatchKeysInfo.RowID else undefined end AS ItemLinkID,
	|	T6020S_BatchKeysInfo.BatchConsignor AS BatchConsignor,
	|	T6020S_BatchKeysInfo.Store AS Store,
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
	|
	|//--------------------------------------
	|	case 
	|	when T6020S_BatchKeysInfo.Recorder refs Document.ProductionCostsAllocation 
	|	then T6020S_BatchKeysInfo.ProductionDocument
	|
	|	when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalCostAllocation 
	|	then T6020S_BatchKeysInfo.PurchaseInvoiceDocument
	|
	|	when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalRevenueAllocation 
	|	then T6020S_BatchKeysInfo.PurchaseInvoiceDocument
	|	
	|	else T6020S_BatchKeysInfo.Recorder end,
	|//--------------------------------------
	|	case 
	|	when T6020S_BatchKeysInfo.Recorder refs Document.ProductionCostsAllocation 
	|	then T6020S_BatchKeysInfo.ProductionDocument.PointInTime
	|
	|	when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalCostAllocation 
	|	then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.PointInTime
	|
	|	when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalRevenueAllocation 
	|	then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.PointInTime
	|
	|	else T6020S_BatchKeysInfo.Recorder.PointInTime end,
	|//--------------------------------------
	|	case 
	|	when T6020S_BatchKeysInfo.Recorder refs Document.ProductionCostsAllocation
	|	then T6020S_BatchKeysInfo.ProductionDocument.Date
	|
	|	when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalCostAllocation
	|	then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.Date
	|
	|	when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalRevenueAllocation
	|	then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.Date
	|
	|	else T6020S_BatchKeysInfo.Period end,
	|//--------------------------------------
	|	T6020S_BatchKeysInfo.Company,
	|	T6020S_BatchKeysInfo.Direction,
	|	T6020S_BatchKeysInfo.BatchDocument,
	|	T6020S_BatchKeysInfo.SalesInvoice,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet then T6020S_BatchKeysInfo.ProfitLossCenter else undefined end,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet then T6020S_BatchKeysInfo.ExpenseType else undefined end,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet then T6020S_BatchKeysInfo.RowID else undefined end,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet then T6020S_BatchKeysInfo.Branch else undefined end,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet then T6020S_BatchKeysInfo.Currency else undefined end,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.ItemStockAdjustment then T6020S_BatchKeysInfo.RowID else undefined end,
	|	T6020S_BatchKeysInfo.BatchConsignor,
	|	T6020S_BatchKeysInfo.Store,
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
	|	SUM(T6020S_BatchKeysInfo.Amount) AS Amount,
	|	SUM(T6020S_BatchKeysInfo.AmountTax) AS AmountTax,
	|	SUM(T6020S_BatchKeysInfo.AmountCostRatio) AS AmountCostRatio,
	|	
	|	sum(T6020S_BatchKeysInfo.NotDirectCosts) AS NotDirectCosts,
	|
	|	sum(T6020S_BatchKeysInfo.AmountCost) AS AmountCost,
	|	sum(T6020S_BatchKeysInfo.AmountCostTax) AS AmountCostTax,
	|	sum(T6020S_BatchKeysInfo.AmountRevenue) AS AmountRevenue,
	|	sum(T6020S_BatchKeysInfo.AmountRevenueTax) AS AmountRevenueTax,
	|//----------------------------------
	|	case 
	|	when T6020S_BatchKeysInfo.Recorder refs Document.ProductionCostsAllocation 
	|	then T6020S_BatchKeysInfo.ProductionDocument
	|	
	|	when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalCostAllocation
	|	then T6020S_BatchKeysInfo.PurchaseInvoiceDocument
	|
	|	when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalRevenueAllocation
	|	then T6020S_BatchKeysInfo.PurchaseInvoiceDocument
	|
	|	else T6020S_BatchKeysInfo.Recorder end AS Document,
	|//-----------------------------------
	|	case 
	|	when T6020S_BatchKeysInfo.Recorder refs Document.ProductionCostsAllocation 
	|	then T6020S_BatchKeysInfo.ProductionDocument.PointInTime
	|
	|	when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalCostAllocation 
	|	then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.PointInTime
	|
	|	when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalRevenueAllocation 
	|	then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.PointInTime
	|	
	|	else T6020S_BatchKeysInfo.Recorder.PointInTime end AS PointInTime,
	|//-----------------------------------
	|	case
	|	when T6020S_BatchKeysInfo.Recorder refs Document.ProductionCostsAllocation
	|	then T6020S_BatchKeysInfo.ProductionDocument.Date
	|
	|	when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalCostAllocation
	|	then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.Date
	|
	|	when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalRevenueAllocation
	|	then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.Date
	|	
	|	else T6020S_BatchKeysInfo.Period end AS Date,
	|//-----------------------------------
	|	T6020S_BatchKeysInfo.Company AS Company,
	|	T6020S_BatchKeysInfo.Direction AS Direction,
	|	T6020S_BatchKeysInfo.BatchDocument AS BatchDocument,
	|	T6020S_BatchKeysInfo.SalesInvoice AS SalesInvoice,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet then T6020S_BatchKeysInfo.ProfitLossCenter else undefined end AS ProfitLossCenter,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet then T6020S_BatchKeysInfo.ExpenseType else undefined end AS ExpenseType,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet then T6020S_BatchKeysInfo.RowID else undefined end AS RowID,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet then T6020S_BatchKeysInfo.Branch else undefined end AS Branch,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet then T6020S_BatchKeysInfo.Currency else undefined end AS Currency,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.ItemStockAdjustment then T6020S_BatchKeysInfo.RowID else undefined end AS ItemLinkID,
	|	T6020S_BatchKeysInfo.BatchConsignor AS BatchConsignor,
	|	T6020S_BatchKeysInfo.Store AS Store,
	|	T6020S_BatchKeysInfo.SerialLotNumber AS SerialLotNumber,
	|	T6020S_BatchKeysInfo.SourceOfOrigin AS SourceOfOrigin,
	|	T6020S_BatchKeysInfo.ItemKey AS ItemKey
	|INTO BatchKeysRegisterOutPeriod
	|FROM
	|	ReallocateDocumentOutPeriod AS ReallocateDocumentOutPeriod
	|		INNER JOIN InformationRegister.T6020S_BatchKeysInfo AS T6020S_BatchKeysInfo
	|		ON ReallocateDocumentOutPeriod.Ref = T6020S_BatchKeysInfo.Recorder
	|GROUP BY
	|
	|//--------------------------------------
	|	case 
	|	when T6020S_BatchKeysInfo.Recorder refs Document.ProductionCostsAllocation 
	|	then T6020S_BatchKeysInfo.ProductionDocument
	|
	|	when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalCostAllocation 
	|	then T6020S_BatchKeysInfo.PurchaseInvoiceDocument
	|
	|	when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalRevenueAllocation 
	|	then T6020S_BatchKeysInfo.PurchaseInvoiceDocument
	|
	|	else T6020S_BatchKeysInfo.Recorder end,
	|//--------------------------------------
	|	case 
	|	when T6020S_BatchKeysInfo.Recorder refs Document.ProductionCostsAllocation 
	|	then T6020S_BatchKeysInfo.ProductionDocument.PointInTime
	|
	|	when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalCostAllocation 
	|	then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.PointInTime
	|
	|	when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalRevenueAllocation 
	|	then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.PointInTime
	|
	|	else T6020S_BatchKeysInfo.Recorder.PointInTime end,
	|//--------------------------------------
	|	case 
	|	when T6020S_BatchKeysInfo.Recorder refs Document.ProductionCostsAllocation
	|	then T6020S_BatchKeysInfo.ProductionDocument.Date
	|
	|	when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalCostAllocation
	|	then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.Date
	|
	|	when T6020S_BatchKeysInfo.Recorder refs Document.AdditionalRevenueAllocation
	|	then T6020S_BatchKeysInfo.PurchaseInvoiceDocument.Date
	|
	|	else T6020S_BatchKeysInfo.Period end,
	|//--------------------------------------
	|	T6020S_BatchKeysInfo.Company,
	|	T6020S_BatchKeysInfo.Direction,
	|	T6020S_BatchKeysInfo.BatchDocument,
	|	T6020S_BatchKeysInfo.SalesInvoice,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet then T6020S_BatchKeysInfo.ProfitLossCenter else undefined end,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet then T6020S_BatchKeysInfo.ExpenseType else undefined end,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet then T6020S_BatchKeysInfo.RowID else undefined end,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet then T6020S_BatchKeysInfo.Branch else undefined end,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff OR T6020S_BatchKeysInfo.Recorder refs Document.WorkSheet then T6020S_BatchKeysInfo.Currency else undefined end,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.ItemStockAdjustment then T6020S_BatchKeysInfo.RowID else undefined end,
	|	T6020S_BatchKeysInfo.BatchConsignor,
	|	T6020S_BatchKeysInfo.Store,
	|	T6020S_BatchKeysInfo.SerialLotNumber,
	|	T6020S_BatchKeysInfo.SourceOfOrigin,
	|	T6020S_BatchKeysInfo.ItemKey
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchKeysRegister.Quantity AS Quantity,
	|	BatchKeysRegister.Amount AS Amount,
	|	BatchKeysRegister.AmountTax AS AmountTax,
	|	BatchKeysRegister.AmountCostRatio AS AmountCostRatio,
	|
	|	BatchKeysRegister.NotDirectCosts AS NotDirectCosts,
	|
	|	BatchKeysRegister.AmountCost AS AmountCost,
	|	BatchKeysRegister.AmountCostTax AS AmountCostTax,
	|	BatchKeysRegister.AmountRevenue AS AmountRevenue,
	|	BatchKeysRegister.AmountRevenueTax AS AmountRevenueTax,
	|
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
	|	BatchKeysRegister.BatchConsignor AS BatchConsignor,
	|	BatchKeysRegister.Store AS Store,
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
	|	BatchKeysRegisterOutPeriod.Amount,
	|	BatchKeysRegisterOutPeriod.AmountTax,
	|	BatchKeysRegisterOutPeriod.AmountCostRatio,
	|
	|	BatchKeysRegisterOutPeriod.NotDirectCosts,
	|
	|	BatchKeysRegisterOutPeriod.AmountCost,
	|	BatchKeysRegisterOutPeriod.AmountCostTax,
	|	BatchKeysRegisterOutPeriod.AmountRevenue,
	|	BatchKeysRegisterOutPeriod.AmountRevenueTax,
	|
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
	|	BatchKeysRegisterOutPeriod.BatchConsignor,
	|	BatchKeysRegisterOutPeriod.Store,
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
	|	SUM(BatchKeysInfo.Amount) AS Amount,
	|	SUM(BatchKeysInfo.AmountTax) AS AmountTax,
	|	SUM(BatchKeysInfo.AmountCostRatio) AS AmountCostRatio,
	|
	|	SUM(BatchKeysInfo.NotDirectCosts) AS NotDirectCosts,
	|
	|	SUM(BatchKeysInfo.AmountCost) AS AmountCost,
	|	SUM(BatchKeysInfo.AmountCostTax) AS AmountCostTax,
	|	SUM(BatchKeysInfo.AmountRevenue) AS AmountRevenue,
	|	SUM(BatchKeysInfo.AmountRevenueTax) AS AmountRevenueTax,
	|
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
	|	BatchKeysInfo.BatchConsignor AS BatchConsignor,
	|	BatchKeysInfo.ItemLinkID AS ItemLinkID
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
	|	BatchKeysInfo.BatchConsignor,
	|	BatchKeysInfo.ItemLinkID
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	FALSE AS IsOpeningBalance,
	|	BatchKeys.BatchKey AS BatchKey,
	|	BatchKeys.Quantity AS Quantity,
	|	BatchKeys.Amount AS Amount,
	|	BatchKeys.AmountTax AS AmountTax,
	|	BatchKeys.AmountCostRatio AS AmountCostRatio,
	|
	|	BatchKeys.NotDirectCosts AS NotDirectCosts,
	|
	|	BatchKeys.AmountCost AS AmountCost,
	|	BatchKeys.AmountCostTax AS AmountCostTax,
	|	BatchKeys.AmountRevenue AS AmountRevenue,
	|	BatchKeys.AmountRevenueTax AS AmountRevenueTax,
	|
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
	|		ELSE BatchKeys.Amount
	|	END AS AmountBalance,
	|	CASE
	|		WHEN Batches.Ref IS NULL
	|		OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.AmountTax
	|	END AS AmountTaxBalance,
	|	CASE
	|		WHEN Batches.Ref IS NULL
	|		OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.AmountCostRatio
	|	END AS AmountCostRatioBalance,
	|
	|	CASE
	|		WHEN Batches.Ref IS NULL
	|		OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.NotDirectCosts
	|	END AS NotDirectCostsBalance,
	|
	|	CASE
	|		WHEN Batches.Ref IS NULL
	|		OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.AmountCost
	|	END AS AmountCostBalance,
	
	|	CASE
	|		WHEN Batches.Ref IS NULL
	|		OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.AmountCostTax
	|	END AS AmountCostTaxBalance,
	
	|	CASE
	|		WHEN Batches.Ref IS NULL
	|		OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.AmountRevenue
	|	END AS AmountRevenueBalance,
	
	|	CASE
	|		WHEN Batches.Ref IS NULL
	|		OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.AmountRevenueTax
	|	END AS AmountRevenueTaxBalance,
	
	|
	|
	|	BatchKeys.BatchDocument AS BatchDocument,
	|	BatchKeys.SalesInvoice AS SalesInvoice,
	|	BatchKeys.ProfitLossCenter AS ProfitLossCenter,
	|	BatchKeys.ExpenseType AS ExpenseType,
	|	BatchKeys.RowID AS RowID,
	|	BatchKeys.Branch AS Branch,
	|	BatchKeys.Currency AS Currency,
	|	BatchKeys.BatchConsignor AS BatchConsignor,
	|	BatchKeys.ItemLinkID AS ItemLinkID
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
	|
	|	0,
	|
	|	0,
	|	0,
	|	0,
	|	0,
	|
	|	R6010B_BatchWiseBalance.Batch.Document,
	|	R6010B_BatchWiseBalance.Batch.Document.PointInTime,
	|	R6010B_BatchWiseBalance.Batch.Date,
	|	R6010B_BatchWiseBalance.Batch.Company,
	|	VALUE(Enum.BatchDirection.Receipt),
	|	R6010B_BatchWiseBalance.Batch,
	|
	|	R6010B_BatchWiseBalance.QuantityBalance,
	|	R6010B_BatchWiseBalance.AmountBalance,
	|	R6010B_BatchWiseBalance.AmountTaxBalance,
	|	R6010B_BatchWiseBalance.AmountCostRatioBalance,
	|
	|	R6010B_BatchWiseBalance.NotDirectCostsBalance,
	|
	|	R6010B_BatchWiseBalance.AmountCostBalance,
	|	R6010B_BatchWiseBalance.AmountCostTaxBalance,
	|	R6010B_BatchWiseBalance.AmountRevenueBalance,
	|	R6010B_BatchWiseBalance.AmountRevenueTaxBalance,
	|
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
	|	SUM(AllData.Amount) AS Amount,
	|	SUM(AllData.AmountTax) AS AmountTax,
	|	SUM(AllData.AmountCostRatio) AS AmountCostRatio,
	|
	|	SUM(AllData.NotDirectCosts) AS NotDirectCosts,
	|
	|	SUM(AllData.AmountCost) AS AmountCost,
	|	SUM(AllData.AmountCostTax) AS AmountCostTax,
	|	SUM(AllData.AmountRevenue) AS AmountRevenue,
	|	SUM(AllData.AmountRevenueTax) AS AmountRevenueTax,
	|
	|	AllData.Document AS Document,
	|	AllData.Document.PointInTime AS PointInTime,
	|	AllData.Date AS Date,
	|	AllData.Company AS Company,
	|	AllData.Direction AS Direction,
	|	AllData.Batch AS Batch,
	|	SUM(AllData.QuantityBalance) AS QuantityBalance,
	|	SUM(AllData.AmountBalance) AS AmountBalance,
	|	SUM(AllData.AmountTaxBalance) AS AmountTaxBalance,
	|	SUM(AllData.AmountCostRatioBalance) AS AmountCostRatioBalance,
	|
	|	SUM(AllData.NotDirectCostsBalance) AS NotDirectCostsBalance,
	|
	|	SUM(AllData.AmountCostBalance) AS AmountCostBalance,
	|	SUM(AllData.AmountCostTaxBalance) AS AmountCostTaxBalance,
	|	SUM(AllData.AmountRevenueBalance) AS AmountRevenueBalance,
	|	SUM(AllData.AmountRevenueTaxBalance) AS AmountRevenueTaxBalance,
	|
	|	AllData.BatchDocument AS BatchDocument,
	|	AllData.SalesInvoice AS SalesInvoice,
	|	AllData.ProfitLossCenter AS ProfitLossCenter,
	|	AllData.ExpenseType AS ExpenseType,
	|	AllData.RowID AS RowID,
	|	AllData.Branch AS Branch,
	|	AllData.Currency AS Currency,
	|	AllData.BatchConsignor AS BatchConsignor,
	|	AllData.ItemLinkID AS ItemLinkID
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
	|	AllData.BatchConsignor,
	|	AllData.ItemLinkID
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AllDataGrouped.IsOpeningBalance AS IsOpeningBalance,
	|	AllDataGrouped.BatchKey AS BatchKey,
	|	AllDataGrouped.Quantity AS Quantity,
	|	AllDataGrouped.Amount AS Amount,
	|	AllDataGrouped.AmountTax AS AmountTax,
	|	AllDataGrouped.AmountCostRatio AS AmountCostRatio,
	|
	|	AllDataGrouped.NotDirectCosts AS NotDirectCosts,
	|
	|	AllDataGrouped.AmountCost AS AmountCost,
	|	AllDataGrouped.AmountCostTax AS AmountCostTax,
	|	AllDataGrouped.AmountRevenue AS AmountRevenue,
	|	AllDataGrouped.AmountRevenueTax AS AmountRevenueTax,
	|
	|	AllDataGrouped.Document AS Document,
	|	AllDataGrouped.Date AS Date,
	|	AllDataGrouped.Company AS Company,
	|	AllDataGrouped.Direction AS Direction,
	|	AllDataGrouped.Batch AS Batch,
	|	AllDataGrouped.QuantityBalance AS QuantityBalance,
	|	AllDataGrouped.AmountBalance AS AmountBalance,
	|	AllDataGrouped.AmountTaxBalance AS AmountTaxBalance,
	|	AllDataGrouped.AmountCostRatioBalance AS AmountCostRatioBalance,
	|
	|	AllDataGrouped.NotDirectCostsBalance AS NotDirectCostsBalance,
	|
	|	AllDataGrouped.AmountCostBalance AS AmountCostBalance,
	|	AllDataGrouped.AmountCostTaxBalance AS AmountCostTaxBalance,
	|	AllDataGrouped.AmountRevenueBalance AS AmountRevenueBalance,
	|	AllDataGrouped.AmountRevenueTaxBalance AS AmountRevenueTaxBalance,
	|
	|	AllDataGrouped.BatchDocument AS BatchDocument,
	|	AllDataGrouped.SalesInvoice AS SalesInvoice,
	|	AllDataGrouped.ProfitLossCenter AS ProfitLossCenter,
	|	AllDataGrouped.ExpenseType AS ExpenseType,
	|	AllDataGrouped.RowID AS RowID,
	|	AllDataGrouped.Branch AS Branch,
	|	AllDataGrouped.Currency AS Currency,
	|	AllDataGrouped.BatchConsignor AS BatchConsignor,
	|	AllDataGrouped.ItemLinkID AS ItemLinkID,
	|	FALSE AS Skip,
	|	0 AS Priority
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

			NewRow = DataForReceipt.Add();
			NewRow.Batch     = Row.Batch;
			NewRow.BatchKey  = Row.BatchKey;
			NewRow.Document  = Row.Document;
			NewRow.Company   = Row.Company;
			NewRow.Period    = Row.Date;
			NewRow.Quantity  = Row.Quantity;
			NewRow.Amount    = Row.Amount;
			NewRow.AmountTax = Row.AmountTax;
			NewRow.NotDirectCosts   = Row.NotDirectCosts;
			NewRow.AmountCost       = Row.AmountCost;
			NewRow.AmountCostTax    = Row.AmountCostTax;
			NewRow.AmountRevenue    = Row.AmountRevenue;
			NewRow.AmountRevenueTax = Row.AmountRevenueTax;
			
			NewRow.AmountCostRatio = Row.AmountCostRatio;
			NewRow.ItemLinkID = Row.ItemLinkID;
			
			// simple receipt	
			If IsNotMultiDirectionDocument(Document) // is not transfer, produce, bundling or unbundling
				And Not ValueIsFilled(Row.SalesInvoice) // is not return by sales invoice
				And TypeOf(Document) <> Type("DocumentRef.BatchReallocateIncoming") // is not receipt by btach reallocation
				
				// sales invoice with transaction type "shipment to trade agent" is multi direction document
				And Not IsShipmentToTradeAgent(Document) Then
				
				If Row.Amount = 0 AND Row.Company.LandedCostFillEmptyAmount 
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
						
						Row.Amount        = Price * Row.Quantity;
						Row.AmountBalance = Price * Row.Quantity;
						
						NewRow.Amount = Price * Row.Quantity;
				EndIf; // fill empty amount
				
				FillPropertyValues(Tables.DataForReceipt.Add(), NewRow);
				
			EndIf;

			If ValueIsFilled(Row.SalesInvoice) Then // return by sales invoice

				TableOfBatchBySales = GetSalesBatches(Row.SalesInvoice, Tables.DataForSalesBatches, Row.BatchKey);

				NeedReceipt = Row.Quantity; // how many returned (quantity)

				For Each BatchBySales In TableOfBatchBySales Do
					If NeedReceipt = 0 Then
						Break;
					EndIf;
					
					// return consigner goods
					If ValueIsFilled(Row.BatchConsignor) Then
						If BatchBySales.Document <> Row.BatchConsignor Then
							Continue;
						EndIf;
					Else // is not consigner goods
						If TypeOf(BatchBySales.Document) = Type("DocumentRef.PurchaseInvoice") Then
							If BatchBySales.Document.TransactionType = Enums.PurchaseTransactionTypes.ReceiptFromConsignor Then
								Continue;
							EndIf;
						EndIf;
					EndIf;
					
					ReceiptQuantity = Min(NeedReceipt, BatchBySales.Quantity); // how many can receipt (quantity)
					
					ReceiptAmount           = CalculateReceiptAmountBySalesReturn(ReceiptQuantity, BatchBySales, "Amount");
					ReceiptAmountTax        = CalculateReceiptAmountBySalesReturn(ReceiptQuantity, BatchBySales, "AmountTax");
					ReceiptNotDirectCosts   = CalculateReceiptAmountBySalesReturn(ReceiptQuantity, BatchBySales, "NotDirectCosts");
					ReceiptAmountCostRatio  = CalculateReceiptAmountBySalesReturn(ReceiptQuantity, BatchBySales, "AmountCostRatio");
					
					ReceiptAmountCost       = CalculateReceiptAmountBySalesReturn(ReceiptQuantity, BatchBySales, "AmountCost");
					ReceiptAmountCostTax    = CalculateReceiptAmountBySalesReturn(ReceiptQuantity, BatchBySales, "AmountCostTax");
					ReceiptAmountRevenue    = CalculateReceiptAmountBySalesReturn(ReceiptQuantity, BatchBySales, "AmountRevenue");
					ReceiptAmountRevenueTax = CalculateReceiptAmountBySalesReturn(ReceiptQuantity, BatchBySales, "AmountRevenueTax");
					
					BatchBySales.Quantity  = BatchBySales.Quantity  - ReceiptQuantity;
					
					BatchBySales.Amount    = BatchBySales.Amount    - ReceiptAmount;
					BatchBySales.AmountTax = BatchBySales.AmountTax - ReceiptAmountTax;
					BatchBySales.NotDirectCosts  = BatchBySales.NotDirectCosts  - ReceiptNotDirectCosts;
					BatchBySales.AmountCostRatio = BatchBySales.AmountCostRatio - ReceiptAmountCostRatio;
					
					BatchBySales.AmountCost     = BatchBySales.AmountCost        - ReceiptAmountCost;
					BatchBySales.AmountCostTax  = BatchBySales.AmountCostTax     - ReceiptAmountCostTax;
					BatchBySales.AmountRevenue  = BatchBySales.AmountRevenue     - ReceiptAmountRevenue;
					BatchBySales.AmountRevenue  = BatchBySales.AmountRevenueTax  - ReceiptAmountRevenueTax;
			
					
					NeedReceipt = NeedReceipt - ReceiptQuantity;
					
					_BatchBySales_Document = BatchBySales.Document;
					_BatchBySales_Company  = BatchBySales.Company;
					_BatchBySales_Batch    = BatchBySales.Batch;
					
					// determine batch when returned by another company
					If ValueIsFilled(Row.Batch) And Row.Company <> _BatchBySales_Company Then
						_BatchBySales_Document = Row.Batch.Document;
						_BatchBySales_Company  = Row.Company;
						_BatchBySales_Batch    = Row.Batch;
					EndIf;
					
					If Not IsReturnFromTradeAgent(Row.Document) Then
						
						// Table of returned batches
						NewRow_ReturnedBatches = TableOfReturnedBatches.Add();
						NewRow_ReturnedBatches.IsOpeningBalance = False;
						NewRow_ReturnedBatches.Skip             = True;
						NewRow_ReturnedBatches.Priority         = 0;
						NewRow_ReturnedBatches.BatchKey         = Row.BatchKey;
						NewRow_ReturnedBatches.Quantity         = ReceiptQuantity;
						NewRow_ReturnedBatches.Amount           = ReceiptAmount;
						NewRow_ReturnedBatches.AmountTax        = ReceiptAmountTax;
						NewRow_ReturnedBatches.NotDirectCosts   = ReceiptNotDirectCosts;
						NewRow_ReturnedBatches.AmountCostRatio  = ReceiptAmountCostRatio;
						
						NewRow_ReturnedBatches.AmountCost       = ReceiptAmountCost;
						NewRow_ReturnedBatches.AmountCostTax    = ReceiptAmountCostTax;
						NewRow_ReturnedBatches.AmountRevenue    = ReceiptAmountRevenue;
						NewRow_ReturnedBatches.AmountRevenueTax = ReceiptAmountRevenueTax;
					
						NewRow_ReturnedBatches.Document         = _BatchBySales_Document;
						NewRow_ReturnedBatches.Company          = _BatchBySales_Company;
						NewRow_ReturnedBatches.Batch            = _BatchBySales_Batch;
					
						NewRow_ReturnedBatches.Date             = Row.Date;
						NewRow_ReturnedBatches.Direction        = Enums.BatchDirection.Receipt;
						NewRow_ReturnedBatches.QuantityBalance  = ReceiptQuantity;
						NewRow_ReturnedBatches.AmountBalance    = ReceiptAmount;
						NewRow_ReturnedBatches.AmountTaxBalance = ReceiptAmountTax;
						NewRow_ReturnedBatches.NotDirectCostsBalance  = ReceiptNotDirectCosts;
						NewRow_ReturnedBatches.AmountCostRatioBalance = ReceiptAmountCostRatio;
						
						NewRow_ReturnedBatches.AmountCostBalance       = ReceiptAmountCost;
						NewRow_ReturnedBatches.AmountCostTaxBalance    = ReceiptAmountCostTax;
						NewRow_ReturnedBatches.AmountRevenueBalance    = ReceiptAmountRevenue;
						NewRow_ReturnedBatches.AmountRevenueTaxBalance = ReceiptAmountRevenueTax;
						
						// Data for receipt
					
						NewRow_DataForReceipt = Tables.DataForReceipt.Add();
					
						NewRow_DataForReceipt.Company   = _BatchBySales_Company;
						NewRow_DataForReceipt.Batch     = _BatchBySales_Batch;
					
						NewRow_DataForReceipt.BatchKey  = Row.BatchKey;
						NewRow_DataForReceipt.Document  = Row.Document;
						NewRow_DataForReceipt.Period    = Row.Date;
						NewRow_DataForReceipt.Quantity  = ReceiptQuantity;
						NewRow_DataForReceipt.Amount    = ReceiptAmount;
						NewRow_DataForReceipt.AmountTax = ReceiptAmountTax;
						NewRow_DataForReceipt.NotDirectCosts  = ReceiptNotDirectCosts;
						NewRow_DataForReceipt.AmountCostRatio = ReceiptAmountCostRatio;
						
						NewRow_DataForReceipt.AmountCost       = ReceiptAmountCost;
						NewRow_DataForReceipt.AmountCostTax    = ReceiptAmountCostTax;
						NewRow_DataForReceipt.AmountRevenue    = ReceiptAmountRevenue;
						NewRow_DataForReceipt.AmountRevenueTax = ReceiptAmountRevenueTax;
					EndIf;
				EndDo; // return by sales invoice

				If NeedReceipt <> 0 Then
					// Can not receipt Batch key by sales return: %1 , Quantity: %2 , Doc: %3
					Msg = StrTemplate(R().LC_Error_001, GetBatchKeyDetailPresentation(Row.BatchKey), NeedReceipt, Row.Document);
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
			
			// sales - consignor/own stocks
			IsSales_ConsignorStocks = False; 
			IsSales_OwnStocks = False; 
			If TypeOf(Row.Document) = Type("DocumentRef.SalesInvoice") 
				Or TypeOf(Row.Document) = Type("DocumentRef.RetailSalesReceipt") Then
				If ValueIsFilled(Row.BatchConsignor) Then
					IsSales_ConsignorStocks = True;
				Else
					IsSales_OwnStocks = True;
				EndIf;
			EndIf;
			
			// transfer - consignor/own stocks
			IsTransfer_ConsignorStocks = False; 
			IsTransfer_OwnStocks = False; 
			If TypeOf(Row.Document) = Type("DocumentRef.InventoryTransfer") Then
				If ValueIsFilled(Row.BatchConsignor) Then
					IsTransfer_ConsignorStocks = True;
				Else
					IsTransfer_OwnStocks = True;
				EndIf;
			EndIf;
			
			// purchase return - consignor/own stocks
			IsPurchaseReturn_ConsignorStocks = False;
			IsPurchaseReturn_OwnStocks = False;
			If TypeOf(Row.Document) = Type("DocumentRef.PurchaseReturn") Then
				If ValueIsFilled(Row.BatchConsignor) Then
					IsPurchaseReturn_ConsignorStocks = True;
				Else
					IsPurchaseReturn_OwnStocks = True;
				EndIf;
			EndIf;
			
			// stock adjustment as writeoff - only own stocks
			IsOnlyOwnStocks = False;
			If TypeOf(Row.Document) = Type("DocumentRef.StockAdjustmentAsWriteOff") Then
				IsOnlyOwnStocks = True;
			EndIf;
			
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
				
				// is sales/transfer own stocks, expense only purchased batches
				If IsSales_OwnStocks Or IsTransfer_OwnStocks Or IsPurchaseReturn_OwnStocks Then
					IsReceiptFromConsignor = TypeOf(Row_Batch.Batch.Document) = Type("DocumentRef.PurchaseInvoice") 
						And Row_Batch.Batch.Document.TransactionType = Enums.PurchaseTransactionTypes.ReceiptFromConsignor;
				
					If IsReceiptFromConsignor Then
						Continue;
					EndIf;
				EndIf;
				
				// is sales/transfer consignor stocks, expense only consignor batches
				If IsSales_ConsignorStocks Or IsTransfer_ConsignorStocks Or IsPurchaseReturn_ConsignorStocks Then
					If Row_Batch.Batch.Document <> Row.BatchConsignor Then
						Continue;
					EndIf;
				EndIf;
				
				// is write off - only own stocks
				If IsOnlyOwnStocks Then
					IsReceiptFromConsignor = TypeOf(Row_Batch.Batch.Document) = Type("DocumentRef.PurchaseInvoice") 
						And Row_Batch.Batch.Document.TransactionType = Enums.PurchaseTransactionTypes.ReceiptFromConsignor;
				
					If IsReceiptFromConsignor Then
						Continue;
					EndIf;
				EndIf;
				
				ExpenseQuantity = Min(NeedExpense, Row_Batch.QuantityBalance);

				ExpenseAmount           = CalculateExpenseAmount(ExpenseQuantity, Row_Batch, "AmountBalance");
				ExpenseAmountTax        = CalculateExpenseAmount(ExpenseQuantity, Row_Batch, "AmountTaxBalance");
				ExpenseNotDirectCosts   = CalculateExpenseAmount(ExpenseQuantity, Row_Batch, "NotDirectCostsBalance");
				ExpenseAmountCostRatio  = CalculateExpenseAmount(ExpenseQuantity, Row_Batch, "AmountCostRatioBalance");
				ExpenseAmountCost       = CalculateExpenseAmount(ExpenseQuantity, Row_Batch, "AmountCostBalance");
				ExpenseAmountCostTax    = CalculateExpenseAmount(ExpenseQuantity, Row_Batch, "AmountCostTaxBalance");
				ExpenseAmountRevenue    = CalculateExpenseAmount(ExpenseQuantity, Row_Batch, "AmountRevenueBalance");
				ExpenseAmountRevenueTax = CalculateExpenseAmount(ExpenseQuantity, Row_Batch, "AmountRevenueTaxBalance");
				
				Row_Batch.QuantityBalance  = Row_Batch.QuantityBalance  - ExpenseQuantity;
				
				Row_Batch.AmountBalance    = Row_Batch.AmountBalance    - ExpenseAmount;
				Row_Batch.AmountTaxBalance = Row_Batch.AmountTaxBalance - ExpenseAmountTax;
				Row_Batch.NotDirectCostsBalance  = Row_Batch.NotDirectCostsBalance  - ExpenseNotDirectCosts;
				Row_Batch.AmountCostRatioBalance = Row_Batch.AmountCostRatioBalance - ExpenseAmountCostRatio;
				
				Row_Batch.AmountCostBalance       = Row_Batch.AmountCostBalance       - ExpenseAmountCost;
				Row_Batch.AmountCostTaxBalance    = Row_Batch.AmountCostTaxBalance    - ExpenseAmountCostTax;
				Row_Batch.AmountRevenueBalance    = Row_Batch.AmountRevenueBalance    - ExpenseAmountRevenue;
				Row_Batch.AmountRevenueTaxBalance = Row_Batch.AmountRevenueTaxBalance - ExpenseAmountRevenueTax;
				
				NeedExpense = NeedExpense - ExpenseQuantity;

				If ExpenseQuantity <> 0 Or ExpenseAmount <> 0 Then
					NewRow = Tables.DataForExpense.Add();
					NewRow.BatchKey  = Row.BatchKey;
					NewRow.Document  = Row.Document;
					NewRow.Company   = Row.Company;
					NewRow.Period    = Row.Date;
					NewRow.Batch     = Row_Batch.Batch;
					NewRow.Quantity  = ExpenseQuantity;
					NewRow.Amount    = ExpenseAmount;
					NewRow.AmountTax = ExpenseAmountTax;
					NewRow.NotDirectCosts  = ExpenseNotDirectCosts;
					NewRow.AmountCostRatio = ExpenseAmountCostRatio;
					
					NewRow.AmountCost       = ExpenseAmountCost;
					NewRow.AmountCostTax    = ExpenseAmountCostTax;
					NewRow.AmountRevenue    = ExpenseAmountRevenue;
					NewRow.AmountRevenueTax = ExpenseAmountRevenueTax;
					
					NewRow.IsSalesConsignorStocks = IsSales_ConsignorStocks;
					
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
				
				NewRow = Tables.DataForBatchShortageOutgoing.Add();
				NewRow.BatchKey = Row.BatchKey;
				NewRow.Document = Row.Document;
				NewRow.Company  = Row.Company;
				NewRow.Period   = Row.Date;
				NewRow.Quantity = NeedExpense;
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
	TableOfNewReceivedBatches.Columns.Add("Quantity");
	TableOfNewReceivedBatches.Columns.Add("Amount");
	TableOfNewReceivedBatches.Columns.Add("AmountTax");
	TableOfNewReceivedBatches.Columns.Add("NotDirectCosts");
	TableOfNewReceivedBatches.Columns.Add("AmountCostRatio");
	TableOfNewReceivedBatches.Columns.Add("AmountCost");
	TableOfNewReceivedBatches.Columns.Add("AmountCostTax");
	TableOfNewReceivedBatches.Columns.Add("AmountRevenue");
	TableOfNewReceivedBatches.Columns.Add("AmountRevenueTax");
	TableOfNewReceivedBatches.Columns.Add("QuantityBalance");
	TableOfNewReceivedBatches.Columns.Add("AmountBalance");
	TableOfNewReceivedBatches.Columns.Add("AmountTaxBalance");
	TableOfNewReceivedBatches.Columns.Add("NotDirectCostsBalance");
	TableOfNewReceivedBatches.Columns.Add("AmountCostRatioBalance");
	TableOfNewReceivedBatches.Columns.Add("AmountCostBalance");
	TableOfNewReceivedBatches.Columns.Add("AmountCostTaxBalance");
	TableOfNewReceivedBatches.Columns.Add("AmountRevenueBalance");
	TableOfNewReceivedBatches.Columns.Add("AmountRevenueTaxBalance");
	TableOfNewReceivedBatches.Columns.Add("IsOpeningBalance");
	TableOfNewReceivedBatches.Columns.Add("Direction");
	
	If IsTransferDocument(Document) Or IsShipmentToTradeAgent(Document) Then
		
		CalculateTransferDocument(Rows, Tables, DataForExpense, TableOfNewReceivedBatches, CalculationSettings);
	
	ElsIf IsReturnFromTradeAgent(Document) Then
		
		CalculateTransferDocument(Rows, Tables, DataForExpense, TableOfNewReceivedBatches, CalculationSettings);
	
	ElsIf IsCompositeDocument(Document) Then
		
		CalculateCompositeDocument(Rows, Tables, DataForReceipt, DataForExpense, TableOfNewReceivedBatches);
	
	ElsIf IsDecompositeDocument(Document) Then
		
		CalculateDecompositeDocument(Rows, Tables, DataForReceipt, DataForExpense, TableOfNewReceivedBatches);
	
	ElsIf TypeOf(Document) = Type("DocumentRef.SalesReturn") Or TypeOf(Document) = Type("DocumentRef.RetailReturnReceipt") Then
		
		For Each Row In TableOfReturnedBatches Do
			NewRowReceivedBatch = TableOfNewReceivedBatches.Add();
			NewRowReceivedBatch.Batch            = Row.Batch;
			NewRowReceivedBatch.BatchKey         = Row.BatchKey;
			NewRowReceivedBatch.Document         = Row.Document;
			NewRowReceivedBatch.Company          = Row.Company;
			NewRowReceivedBatch.Date             = Row.Date;
			NewRowReceivedBatch.Quantity         = Row.Quantity;
			NewRowReceivedBatch.Amount           = Row.Amount;
			NewRowReceivedBatch.AmountTax        = Row.AmountTax;
			NewRowReceivedBatch.NotDirectCosts   = Row.NotDirectCosts;
			NewRowReceivedBatch.AmountCostRatio  = Row.AmountCostRatio;
			
			NewRowReceivedBatch.AmountCost       = Row.AmountCost;
			NewRowReceivedBatch.AmountCostTax    = Row.AmountCostTax;
			NewRowReceivedBatch.AmountRevenue    = Row.AmountRevenue;
			NewRowReceivedBatch.AmountRevenueTax = Row.AmountRevenueTax;
			
			NewRowReceivedBatch.QuantityBalance  = Row.Quantity;
			NewRowReceivedBatch.AmountBalance    = Row.Amount;
			NewRowReceivedBatch.AmountTaxBalance = Row.AmountTax;
			NewRowReceivedBatch.NotDirectCostsBalance  = Row.NotDirectCosts;
			NewRowReceivedBatch.AmountCostRatioBalance = Row.AmountCostRatio;
			
			NewRowReceivedBatch.AmountCostBalance       = Row.AmountCost;
			NewRowReceivedBatch.AmountCostTaxBalance    = Row.AmountCostTax;
			NewRowReceivedBatch.AmountRevenueBalance    = Row.AmountRevenue;
			NewRowReceivedBatch.AmountRevenueTaxBalance = Row.AmountRevenueTax;
			
			NewRowReceivedBatch.IsOpeningBalance = False;
			NewRowReceivedBatch.Direction        = Enums.BatchDirection.Receipt;
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
		
	ElsIf TypeOf(Document) = Type("DocumentRef.BatchReallocateIncoming") Then

		For Each Row_Receipt In DataForReceipt Do
			NewRow = Tables.DataForReceipt.Add();
			FillPropertyValues(NewRow, Row_Receipt);

			Filter = New Structure();
			Filter.Insert("BatchKey", Row_Receipt.BatchKey);
			Filter.Insert("IncomingDocument", Document);
			Filter.Insert("OutgoingDocument", Document.Outgoing);
			
			FilteredRows = Tables.DataForReallocatedBatchesAmountValues.FindRows(Filter);
			ReallocatedAmount    = 0;
			ReallocatedAmountTax = 0;
			ReallocatedNotDirectCosts  = 0;
			ReallocatedAmountCostRatio = 0;
			ReallocatedAmountCost       = 0;
			ReallocatedAmountCostTax    = 0;
			ReallocatedAmountRevenue    = 0;
			ReallocatedAmountRevenueTax = 0;
			ReallocatedQuantity  = 0;
			If FilteredRows.Count() Then
				For Each FilteredRow In FilteredRows Do
					ReallocatedAmount    = ReallocatedAmount    + FilteredRow.Amount;
					ReallocatedAmountTax = ReallocatedAmountTax + FilteredRow.AmountTax;
					ReallocatedNotDirectCosts  = ReallocatedNotDirectCosts  + FilteredRow.NotDirectCosts;
					ReallocatedAmountCostRatio = ReallocatedAmountCostRatio + FilteredRow.AmountCostRatio;
					
					ReallocatedAmountCost       = ReallocatedAmountCost       + FilteredRow.AmountCost;
					ReallocatedAmountCostTax    = ReallocatedAmountCostTax    + FilteredRow.AmountCostTax;
					ReallocatedAmountRevenue    = ReallocatedAmountRevenue    + FilteredRow.AmountRevenue;
					ReallocatedAmountRevenueTax = ReallocatedAmountRevenueTax + FilteredRow.AmountRevenueTax;
					
					ReallocatedQuantity  = ReallocatedQuantity  + FilteredRow.Quantity;
				EndDo;
			Else
				QuerySelection = GetReallocatedBatchesAmount(Filter);
				If QuerySelection.Next() Then
					ReallocatedAmount    = QuerySelection.Amount;
					ReallocatedAmountTax = QuerySelection.AmountTax;
					ReallocatedNotDirectCosts  = QuerySelection.NotDirectCosts;
					ReallocatedAmountCostRatio = QuerySelection.AmountCostRatio;
					
					ReallocatedAmountCost       = QuerySelection.AmountCost;
					ReallocatedAmountCostTax    = QuerySelection.AmountCostTax;
					ReallocatedAmountRevenue    = QuerySelection.AmountRevenue;
					ReallocatedAmountRevenueTax = QuerySelection.AmountRevenueTax;
					
					ReallocatedQuantity  = QuerySelection.Quantity;
				EndIf;
			EndIf;

			If NewRow.Quantity = ReallocatedQuantity Then
				NewRow.Amount    = ReallocatedAmount;
				NewRow.AmountTax = ReallocatedAmountTax;
				NewRow.NotDirectCosts  = ReallocatedNotDirectCosts;
				NewRow.AmountCostRatio = ReallocatedAmountCostRatio;
				
				NewRow.AmountCost       = ReallocatedAmountCost;
				NewRow.AmountCostTax    = ReallocatedAmountCostTax;
				NewRow.AmountRevenue    = ReallocatedAmountRevenue;
				NewRow.AmountRevenueTax = ReallocatedAmountRevenueTax;
			Else
				If ReallocatedQuantity <> 0 Then
					NewRow.Amount = NewRow.Quantity * (ReallocatedAmount / ReallocatedQuantity);
					NewRow.AmountTax = NewRow.Quantity * (ReallocatedAmountTax / ReallocatedQuantity);
					NewRow.NotDirectCosts  = NewRow.Quantity * (ReallocatedNotDirectCosts  / ReallocatedQuantity);
					NewRow.AmountCostRatio = NewRow.Quantity * (ReallocatedAmountCostRatio / ReallocatedQuantity);
					
					NewRow.AmountCost       = NewRow.Quantity * (ReallocatedAmountCost       / ReallocatedQuantity);
					NewRow.AmountCostTax    = NewRow.Quantity * (ReallocatedAmountCostTax    / ReallocatedQuantity);
					NewRow.AmountRevenue    = NewRow.Quantity * (ReallocatedAmountRevenue    / ReallocatedQuantity);
					NewRow.AmountRevenueTax = NewRow.Quantity * (ReallocatedAmountRevenueTax / ReallocatedQuantity);
				Else
					NewRow.Amount = 0;
					NewRow.AmountTax = 0;
					NewRow.NotDirectCosts  = 0;
					NewRow.AmountCostRatio = 0;
					
					NewRow.AmountCost       = 0;
					NewRow.AmountCostTax    = 0;
					NewRow.AmountRevenue    = 0;
					NewRow.AmountRevenueTax = 0;
				EndIf;
			EndIf;

			NewRowReceivedBatch = TableOfNewReceivedBatches.Add();
			NewRowReceivedBatch.Batch            = NewRow.Batch;
			NewRowReceivedBatch.BatchKey         = NewRow.BatchKey;
			NewRowReceivedBatch.Document         = NewRow.Document;
			NewRowReceivedBatch.Company          = NewRow.Company;
			NewRowReceivedBatch.Date             = NewRow.Period;
			NewRowReceivedBatch.Quantity         = NewRow.Quantity;
			NewRowReceivedBatch.Amount           = NewRow.Amount;
			NewRowReceivedBatch.AmountTax        = NewRow.AmountTax;
			NewRowReceivedBatch.NotDirectCosts   = NewRow.NotDirectCosts;
			NewRowReceivedBatch.AmountCostRatio  = NewRow.AmountCostRatio;
			
			NewRowReceivedBatch.AmountCost       = NewRow.AmountCost;
			NewRowReceivedBatch.AmountCostTax    = NewRow.AmountCostTax;
			NewRowReceivedBatch.AmountRevenue    = NewRow.AmountRevenue;
			NewRowReceivedBatch.AmountRevenueTax = NewRow.AmountRevenueTax;
			
			NewRowReceivedBatch.QuantityBalance  = NewRow.Quantity;
			NewRowReceivedBatch.AmountBalance    = NewRow.Amount;
			NewRowReceivedBatch.AmountTaxBalance = NewRow.AmountTax;
			NewRowReceivedBatch.NotDirectCostsBalance  = NewRow.NotDirectCosts;
			NewRowReceivedBatch.AmountCostRatioBalance = NewRow.AmountCostRatio;
			
			NewRowReceivedBatch.AmountCostBalance       = NewRow.AmountCost;
			NewRowReceivedBatch.AmountCostTaxBalance    = NewRow.AmountCostTax;
			NewRowReceivedBatch.AmountRevenueBalance    = NewRow.AmountRevenue;
			NewRowReceivedBatch.AmountRevenueTaxBalance = NewRow.AmountRevenueTax;
			
			NewRowReceivedBatch.IsOpeningBalance = False;
			NewRowReceivedBatch.Direction        = Enums.BatchDirection.Receipt;
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

Function GetReallocatedBatchesAmount(Filter)
	Query = New Query();
	Query.Text =
	"SELECT
	|	ISNULL(SUM(T6080S_ReallocatedBatchesAmountValuesSliceLast.Amount), 0) AS Amount,
	|	ISNULL(SUM(T6080S_ReallocatedBatchesAmountValuesSliceLast.AmountTax), 0) AS AmountTax,
	|	ISNULL(SUM(T6080S_ReallocatedBatchesAmountValuesSliceLast.NotDirectCosts), 0) AS NotDirectCosts,
	|	ISNULL(SUM(T6080S_ReallocatedBatchesAmountValuesSliceLast.AmountCostRatio), 0) AS AmountCostRatio,
	|	ISNULL(SUM(T6080S_ReallocatedBatchesAmountValuesSliceLast.AmountCost), 0) AS AmountCost,
	|	ISNULL(SUM(T6080S_ReallocatedBatchesAmountValuesSliceLast.AmountCostTax), 0) AS AmountCostTax,
	|	ISNULL(SUM(T6080S_ReallocatedBatchesAmountValuesSliceLast.AmountRevenue), 0) AS AmountRevenue,
	|	ISNULL(SUM(T6080S_ReallocatedBatchesAmountValuesSliceLast.AmountRevenueTax), 0) AS AmountRevenueTax,
	|	ISNULL(SUM(T6080S_ReallocatedBatchesAmountValuesSliceLast.Quantity), 0) AS Quantity
	|FROM
	|	InformationRegister.T6080S_ReallocatedBatchesAmountValues.SliceLast(, OutgoingDocument = &OutgoingDocument
	|	AND IncomingDocument = &IncomingDocument
	|	AND BatchKey = &BatchKey) AS T6080S_ReallocatedBatchesAmountValuesSliceLast";
	Query.SetParameter("BatchKey", Filter.BatchKey);
	Query.SetParameter("IncomingDocument", Filter.IncomingDocument);
	Query.SetParameter("OutgoingDocument", Filter.OutgoingDocument);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Return QuerySelection
EndFunction

Function GetPriceForEmptyAmountFromDataForReceipt(ItemKey, Period, DataForReceipt)
	Query = New Query;
	Query.Text =
		"SELECT
		|	TemporaryTable.BatchKey,
		|	TemporaryTable.Period,
		|	TemporaryTable.Amount,
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
		|	VT.Amount,
		|	VT.Quantity,
		|	CASE
		|		WHEN VT.Quantity = 0
		|			THEN 0
		|		ELSE VT.Amount / VT.Quantity
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
	Query = New Query;
	Query.Text =
		"SELECT TOP 1
		|	BatchBalance.BatchKey,
		|	BatchBalance.Period AS Period,
		|	BatchBalance.Amount,
		|	BatchBalance.Quantity,
		|	CASE
		|		WHEN BatchBalance.Quantity = 0
		|			THEN 0
		|		ELSE BatchBalance.Amount / BatchBalance.Quantity
		|	END AS Price
		|FROM
		|	AccumulationRegister.R6020B_BatchBalance AS BatchBalance
		|WHERE
		|	BatchBalance.ItemKey = &ItemKey
		|	AND BatchBalance.Period <= &Period
		|	AND BatchBalance.RecordType = VALUE(AccumulationRecordType.Receipt)
		|	AND BatchBalance.Amount > 0
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

Procedure CalculateTransferDocument(Rows, Tables, DataForExpense, TableOfNewReceivedBatches, CalculationSettings)
	For Each Row In Rows Do
		If Row.Direction = Enums.BatchDirection.Receipt And Not Row.IsOpeningBalance Then
			
			NeedReceipt = Row.Quantity;
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
				
				If ValueIsFilled(Row.BatchConsignor) Then
					If Row_Expense.Batch.Document <> Row.BatchConsignor Then
						Continue;
					EndIf;
				EndIf;
				
				NeedReceipt = NeedReceipt - Row_Expense.Quantity;
				NewRow = Tables.DataForReceipt.Add();
				NewRow.Batch     = Row_Expense.Batch;
				NewRow.BatchKey  = Row.BatchKey;
				NewRow.Document  = Row.Document;
				NewRow.Company   = Row.Company;
				NewRow.Period    = Row.Date;
				NewRow.Quantity  = Row_Expense.Quantity;
				NewRow.Amount    = Row_Expense.Amount;
				NewRow.AmountTax = Row_Expense.AmountTax;
				NewRow.NotDirectCosts  = Row_Expense.NotDirectCosts;
				NewRow.AmountCostRatio = Row_Expense.AmountCostRatio;
				
				NewRow.AmountCost       = Row_Expense.AmountCost;
				NewRow.AmountCostTax    = Row_Expense.AmountCostTax;
				NewRow.AmountRevenue    = Row_Expense.AmountRevenue;
				NewRow.AmountRevenueTax = Row_Expense.AmountRevenueTax;

				NewRowReceivedBatch = TableOfNewReceivedBatches.Add();
				NewRowReceivedBatch.Batch            = Row_Expense.Batch;
				NewRowReceivedBatch.BatchKey         = Row.BatchKey;
				NewRowReceivedBatch.Document         = Row.Document;
				NewRowReceivedBatch.Company          = Row.Company;
				NewRowReceivedBatch.Date             = Row.Date;
				NewRowReceivedBatch.Quantity         = Row_Expense.Quantity;
				NewRowReceivedBatch.Amount           = Row_Expense.Amount;
				NewRowReceivedBatch.AmountTax        = Row_Expense.AmountTax;
				NewRowReceivedBatch.NotDirectCosts   = Row_Expense.NotDirectCosts;
				
				NewRowReceivedBatch.AmountCost       = Row_Expense.AmountCost;
				NewRowReceivedBatch.AmountCostTax    = Row_Expense.AmountCostTax;
				NewRowReceivedBatch.AmountRevenue    = Row_Expense.AmountRevenue;
				NewRowReceivedBatch.AmountRevenueTax = Row_Expense.AmountRevenueTax;
				
				NewRowReceivedBatch.AmountCostRatio  = Row_Expense.AmountCostRatio;
				NewRowReceivedBatch.QuantityBalance  = Row_Expense.Quantity;
				NewRowReceivedBatch.AmountBalance    = Row_Expense.Amount;
				NewRowReceivedBatch.AmountTaxBalance = Row_Expense.AmountTax;
				NewRowReceivedBatch.NotDirectCostsBalance  = Row_Expense.NotDirectCosts;
				
				NewRowReceivedBatch.AmountCostBalance       = Row_Expense.AmountCost;
				NewRowReceivedBatch.AmountCostTaxBalance    = Row_Expense.AmountCostTax;
				NewRowReceivedBatch.AmountRevenueBalance    = Row_Expense.AmountRevenue;
				NewRowReceivedBatch.AmountRevenueTaxBalance = Row_Expense.AmountRevenueTax;
				
				NewRowReceivedBatch.AmountCostRatioBalance = Row_Expense.AmountCostRatio;
				NewRowReceivedBatch.IsOpeningBalance = False;
				NewRowReceivedBatch.Direction        = Enums.BatchDirection.Receipt;
				
			EndDo;
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
EndProcedure

Procedure CalculateCompositeDocument(Rows, Tables, DataForReceipt, DataForExpense, TableOfNewReceivedBatches)
	For Each Row_Receipt In DataForReceipt Do
		NewRow = Tables.DataForReceipt.Add();
		FillPropertyValues(NewRow, Row_Receipt);
				
		TotalExpenseAmount    = DataForExpense.Total("Amount");
		TotalExpenseAmountTax = DataForExpense.Total("AmountTax");
		TotalExpenseNotDirectCosts  = DataForExpense.Total("NotDirectCosts");
		TotalExpenseAmountCostRatio = DataForExpense.Total("AmountCostRatio");
		TotalExpenseAmountCost       = DataForExpense.Total("AmountCost");
		TotalExpenseAmountCostTax    = DataForExpense.Total("AmountCostTax");
		TotalExpenseAmountRevenue    = DataForExpense.Total("AmountRevenue");
		TotalExpenseAmountRevenueTax = DataForExpense.Total("AmountRevenueTax");
				
		For Each Row_Expense In DataForExpense Do
			
			If ValueIsFilled(Row_Receipt.ItemLinkID) Then
				If Row_Receipt.ItemLinkID <> Row_Expense.ItemLinkID Then
					Continue;
				EndIf;
			EndIf;
			
			NewRow.Amount    = NewRow.Amount    + Row_Expense.Amount;
			NewRow.AmountTax = NewRow.AmountTax + Row_Expense.AmountTax;
			NewRow.NotDirectCosts  = NewRow.NotDirectCosts  + Row_Expense.NotDirectCosts;
			NewRow.AmountCostRatio = NewRow.AmountCostRatio + Row_Expense.AmountCostRatio;
			NewRow.AmountCost       = NewRow.AmountCost       + Row_Expense.AmountCost;
			NewRow.AmountCostTax    = NewRow.AmountCostTax    + Row_Expense.AmountCostTax;
			NewRow.AmountRevenue    = NewRow.AmountRevenue    + Row_Expense.AmountRevenue;
			NewRow.AmountRevenueTax = NewRow.AmountRevenueTax + Row_Expense.AmountRevenueTax;
			
			If TypeOf(Row_Expense.Document) = Type("DocumentRef.Bundling") Then
				NewRowBundleAmountValues = Tables.DataForBundleAmountValues.Add();
				NewRowBundleAmountValues.Batch          = Row_Expense.Batch;
				NewRowBundleAmountValues.BatchKey       = Row_Expense.BatchKey;
				NewRowBundleAmountValues.Company        = Row_Expense.Company;
				NewRowBundleAmountValues.Period         = Row_Expense.Period;
				NewRowBundleAmountValues.BatchKeyBundle = Row_Receipt.BatchKey;
				
				// Amount
				If TotalExpenseAmount <> 0 And Row_Expense.Amount <> 0 Then
					NewRowBundleAmountValues.AmountValue = Row_Expense.Amount / (TotalExpenseAmount / 100);
				EndIf;
				
				// Amount tax
				If TotalExpenseAmountTax <> 0 And Row_Expense.AmountTax <> 0 Then
					NewRowBundleAmountValues.AmountTaxValue = Row_Expense.AmountTax / (TotalExpenseAmountTax / 100);
				EndIf;
				
				// Not direct costs
				If TotalExpenseNotDirectCosts <> 0 And Row_Expense.NotDirectCosts <> 0 Then
					NewRowBundleAmountValues.NotDirectCosts = Row_Expense.NotDirectCosts / (TotalExpenseNotDirectCosts / 100);
				EndIf;
				
				// Amount cost ratio
				If TotalExpenseAmountCostRatio <> 0 And Row_Expense.AmountCostRatio <> 0 Then
					NewRowBundleAmountValues.AmountCostRatio = Row_Expense.AmountCostRatio / (TotalExpenseAmountCostRatio / 100);
				EndIf;
				
				// Amount cost
				If TotalExpenseAmountCost <> 0 And Row_Expense.AmountCost <> 0 Then
					NewRowBundleAmountValues.AmountCost = Row_Expense.AmountCost / (TotalExpenseAmountCost / 100);
				EndIf;
				
				// Amount cost tax
				If TotalExpenseAmountCostTax <> 0 And Row_Expense.AmountCostTax <> 0 Then
					NewRowBundleAmountValues.AmountCostTax = Row_Expense.AmountCostTax / (TotalExpenseAmountCostTax / 100);
				EndIf;
				
				// Revenue
				If TotalExpenseAmountRevenue <> 0 And Row_Expense.AmountRevenue <> 0 Then
					NewRowBundleAmountValues.AmountRevenue = Row_Expense.AmountRevenue / (TotalExpenseAmountRevenue / 100);
				EndIf;
				
				// Revenue tax
				If TotalExpenseAmountRevenueTax <> 0 And Row_Expense.AmountRevenueTax <> 0 Then
					NewRowBundleAmountValues.AmountRevenueTax = Row_Expense.AmountRevenueTax / (TotalExpenseAmountRevenueTax / 100);
				EndIf;
			Else
				NewRowCompositeBatchesAmountValues = Tables.DataForCompositeBatchesAmountValues.Add();
				NewRowCompositeBatchesAmountValues.Batch     = Row_Expense.Batch;
				NewRowCompositeBatchesAmountValues.BatchKey  = Row_Expense.BatchKey;
				NewRowCompositeBatchesAmountValues.Company   = Row_Expense.Company;
				NewRowCompositeBatchesAmountValues.Period    = Row_Expense.Period;
				NewRowCompositeBatchesAmountValues.BatchComposite    = Row_Receipt.Batch;
				NewRowCompositeBatchesAmountValues.BatchKeyComposite = Row_Receipt.BatchKey;
				NewRowCompositeBatchesAmountValues.Amount    = Row_Expense.Amount;
				NewRowCompositeBatchesAmountValues.AmountTax = Row_Expense.AmountTax; 
				NewRowCompositeBatchesAmountValues.NotDirectCosts  = Row_Expense.NotDirectCosts;
				NewRowCompositeBatchesAmountValues.AmountCostRatio = Row_Expense.AmountCostRatio;
				
				NewRowCompositeBatchesAmountValues.AmountCost       = Row_Expense.AmountCost;
				NewRowCompositeBatchesAmountValues.AmountCostTax    = Row_Expense.AmountCostTax;
				NewRowCompositeBatchesAmountValues.AmountRevenue    = Row_Expense.AmountRevenue;
				NewRowCompositeBatchesAmountValues.AmountRevenueTax = Row_Expense.AmountRevenueTax;
				
				NewRowCompositeBatchesAmountValues.Quantity  = Row_Expense.Quantity;
			EndIf;
		EndDo; // DataForExpense
		
		If TypeOf(Row_Receipt.Document) = Type("DocumentRef.Production") Then
			CostMultiplierRatio = Row_Receipt.Document.CostMultiplierRatio;
			If CostMultiplierRatio <> 0 Then		
				NewRow.AmountCostRatio = (NewRow.Amount + NewRow.AmountCostRatio) / 100 * CostMultiplierRatio;
			EndIf;	
		EndIf;
		
		NewRowReceivedBatch = TableOfNewReceivedBatches.Add();
		NewRowReceivedBatch.Batch            = NewRow.Batch;
		NewRowReceivedBatch.BatchKey         = NewRow.BatchKey;
		NewRowReceivedBatch.Document         = NewRow.Document;
		NewRowReceivedBatch.Company          = NewRow.Company;
		NewRowReceivedBatch.Date             = NewRow.Period;
		NewRowReceivedBatch.Quantity         = NewRow.Quantity;
		NewRowReceivedBatch.Amount           = NewRow.Amount;
		NewRowReceivedBatch.AmountTax        = NewRow.AmountTax;
		NewRowReceivedBatch.NotDirectCosts   = NewRow.NotDirectCosts;
		NewRowReceivedBatch.AmountCostRatio  = NewRow.AmountCostRatio;
		
		NewRowReceivedBatch.AmountCost       = NewRow.AmountCost;
		NewRowReceivedBatch.AmountCostTax    = NewRow.AmountCostTax;
		NewRowReceivedBatch.AmountRevenue    = NewRow.AmountRevenue;
		NewRowReceivedBatch.AmountRevenueTax = NewRow.AmountRevenueTax;
		
		NewRowReceivedBatch.QuantityBalance  = NewRow.Quantity;
		NewRowReceivedBatch.AmountBalance    = NewRow.Amount;
		NewRowReceivedBatch.AmountTaxBalance = NewRow.AmountTax;
		NewRowReceivedBatch.NotDirectCostsBalance  = NewRow.NotDirectCosts;
		NewRowReceivedBatch.AmountCostRatioBalance = NewRow.AmountCostRatio;
		
		NewRowReceivedBatch.AmountCostBalance       = NewRow.AmountCost;
		NewRowReceivedBatch.AmountCostTaxBalance    = NewRow.AmountCostTax;
		NewRowReceivedBatch.AmountRevenueBalance    = NewRow.AmountRevenue;
		NewRowReceivedBatch.AmountRevenueTaxBalance = NewRow.AmountRevenueTax;
		
		NewRowReceivedBatch.IsOpeningBalance = False;
		NewRowReceivedBatch.Direction        = Enums.BatchDirection.Receipt;

	EndDo; // DataForReceipt

	ArrayForDelete = New Array();
	For Each Row In TableOfNewReceivedBatches Do
		If ValueIsFilled(Row.AmountBalance) Then
			For Each Row2 In Rows Do
				If Row.Batch = Row2.Batch 
					And Row.BatchKey = Row2.BatchKey 
					And Row.Direction = Row2.Direction 
					And Not ValueIsFilled(Row2.AmountBalance) 
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
			If Not ValueIsFilled(Row_Expense.Amount) Then
				Continue;
			EndIf;
			Query = New Query();
			Query.Text =
			"SELECT
			|	DataForBundleAmountValues.BatchKey AS BatchKey,
			|	DataForBundleAmountValues.Company AS Company,
			|	DataForBundleAmountValues.BatchKeyBundle AS BatchKeyBundle,
			|	DataForBundleAmountValues.AmountValue AS AmountValue,
			|	DataForBundleAmountValues.AmountTaxValue AS AmountTaxValue,
			|	DataForBundleAmountValues.NotDirectCosts AS NotDirectCosts,
			|	DataForBundleAmountValues.AmountCostRatio AS AmountCostRatio,
			|	DataForBundleAmountValues.AmountCost AS AmountCost,
			|	DataForBundleAmountValues.AmountCostTax AS AmountCostTax,
			|	DataForBundleAmountValues.AmountRevenue AS AmountRevenue,
			|	DataForBundleAmountValues.AmountRevenueTax AS AmountRevenueTax
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
			|	DataForBundleAmountValues.AmountValue AS AmountValue,
			|	DataForBundleAmountValues.AmountTaxValue AS AmountTaxValue,
			|	DataForBundleAmountValues.NotDirectCosts AS NotDirectCosts,
			|	DataForBundleAmountValues.AmountCostRatio AS AmountCostRatio,
			|	DataForBundleAmountValues.AmountCost AS AmountCost,
			|	DataForBundleAmountValues.AmountCostTax AS AmountCostTax,
			|	DataForBundleAmountValues.AmountRevenue AS AmountRevenue,
			|	DataForBundleAmountValues.AmountRevenueTax AS AmountRevenueTax
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
			|	T6040S_BundleAmountValues.BatchKey,
			|	T6040S_BundleAmountValues.Company,
			|	T6040S_BundleAmountValues.BatchKeyBundle,
			|	T6040S_BundleAmountValues.AmountValue,
			|	T6040S_BundleAmountValues.AmountTaxValue,
			|	T6040S_BundleAmountValues.NotDirectCosts,
			|	T6040S_BundleAmountValues.AmountCostRatio,
			|	T6040S_BundleAmountValues.AmountCost,
			|	T6040S_BundleAmountValues.AmountCostTax,
			|	T6040S_BundleAmountValues.AmountRevenue,
			|	T6040S_BundleAmountValues.AmountRevenueTax
			|FROM
			|	InformationRegister.T6040S_BundleAmountValues AS T6040S_BundleAmountValues
			|WHERE
			|	T6040S_BundleAmountValues.BatchKey = &BatchKey
			|	AND T6040S_BundleAmountValues.Company = &Company
			|	AND T6040S_BundleAmountValues.BatchKeyBundle = &BatchKeyBundle
			|
			|UNION
			|
			|SELECT
			|	BatchKeys.Ref,
			|	T6050S_ManualBundleAmountValues.Company,
			|	BatchKeys_Bundle.Ref,
			|	T6050S_ManualBundleAmountValues.AmountValue,
			|	T6050S_ManualBundleAmountValues.AmountTaxValue,
			|	T6050S_ManualBundleAmountValues.NotDirectCosts,
			|	T6050S_ManualBundleAmountValues.AmountCostRatio,
			|	T6050S_ManualBundleAmountValues.AmountCost,
			|	T6050S_ManualBundleAmountValues.AmountCostTax,
			|	T6050S_ManualBundleAmountValues.AmountRevenue,
			|	T6050S_ManualBundleAmountValues.AmountRevenueTax
			|FROM
			|	InformationRegister.T6050S_ManualBundleAmountValues AS T6050S_ManualBundleAmountValues
			|		INNER JOIN Catalog.BatchKeys AS BatchKeys
			|		ON T6050S_ManualBundleAmountValues.ItemKey = BatchKeys.ItemKey
			|		AND T6050S_ManualBundleAmountValues.Store = BatchKeys.Store
			|		INNER JOIN Catalog.BatchKeys AS BatchKeys_Bundle
			|		ON T6050S_ManualBundleAmountValues.Bundle = BatchKeys_Bundle.ItemKey
			|		AND T6050S_ManualBundleAmountValues.Store = BatchKeys_Bundle.Store
			|WHERE
			|	T6050S_ManualBundleAmountValues.Company = &Company
			|	AND T6050S_ManualBundleAmountValues.ItemKey = &ItemKey
			|	AND T6050S_ManualBundleAmountValues.Bundle = &Bundle
			|	AND T6050S_ManualBundleAmountValues.Store = &Store";

			Query.SetParameter("DataForBundleAmountValues", Tables.DataForBundleAmountValues);
			Query.SetParameter("BatchKeyBundle", Row_Expense.BatchKey);
			Query.SetParameter("BatchKey" , Row_Receipt.BatchKey);
			Query.SetParameter("Company"  , Row_Expense.Company);
			Query.SetParameter("ItemKey"  , Row_Receipt.BatchKey.ItemKey);
			Query.SetParameter("Bundle"   , Row_Expense.BatchKey.ItemKey);
			Query.SetParameter("Store"    , Row_Receipt.BatchKey.Store);

			QuerySelection = Query.Execute().Select();
			While QuerySelection.Next() Do
				NewRow.Amount = NewRow.Amount + (Row_Expense.Amount / 100 * QuerySelection.AmountValue);
				NewRow.AmountTax = NewRow.AmountTax + (Row_Expense.AmountTax / 100 * QuerySelection.AmountTaxValue);
				NewRow.NotDirectCosts  = NewRow.NotDirectCosts  + (Row_Expense.NotDirectCosts  / 100 * QuerySelection.NotDirectCosts);
				NewRow.AmountCostRatio = NewRow.AmountCostRatio + (Row_Expense.AmountCostRatio / 100 * QuerySelection.AmountCostRatio);
				
				NewRow.AmountCost       = NewRow.AmountCost       + (Row_Expense.AmountCost       / 100 * QuerySelection.AmountCost);
				NewRow.AmountCostTax    = NewRow.AmountCostTax    + (Row_Expense.AmountCostTax    / 100 * QuerySelection.AmountCostTax);
				NewRow.AmountRevenue    = NewRow.AmountRevenue    + (Row_Expense.AmountRevenue    / 100 * QuerySelection.AmountRevenue);
				NewRow.AmountRevenueTax = NewRow.AmountRevenueTax + (Row_Expense.AmountRevenueTax / 100 * QuerySelection.AmountRevenueTax);
			EndDo;
		EndDo;

		NewRowReceivedBatch = TableOfNewReceivedBatches.Add();
		NewRowReceivedBatch.Batch            = NewRow.Batch;
		NewRowReceivedBatch.BatchKey         = NewRow.BatchKey;
		NewRowReceivedBatch.Document         = NewRow.Document;
		NewRowReceivedBatch.Company          = NewRow.Company;
		NewRowReceivedBatch.Date             = NewRow.Period;
		NewRowReceivedBatch.Quantity         = NewRow.Quantity;
		NewRowReceivedBatch.Amount           = NewRow.Amount;
		NewRowReceivedBatch.AmountTax        = NewRow.AmountTax;
		NewRowReceivedBatch.NotDirectCosts   = NewRow.NotDirectCosts;
		NewRowReceivedBatch.AmountCostRatio  = NewRow.AmountCostRatio;
		
		NewRowReceivedBatch.AmountCost       = NewRow.AmountCost;
		NewRowReceivedBatch.AmountCostTax    = NewRow.AmountCostTax;
		NewRowReceivedBatch.AmountRevenue    = NewRow.AmountRevenue;
		NewRowReceivedBatch.AmountRevenueTax = NewRow.AmountRevenueTax;
		
		NewRowReceivedBatch.QuantityBalance  = NewRow.Quantity;
		NewRowReceivedBatch.AmountBalance    = NewRow.Amount;
		NewRowReceivedBatch.AmountTaxBalance = NewRow.AmountTax;
		NewRowReceivedBatch.NotDirectCostsBalance  = NewRow.NotDirectCosts;
		NewRowReceivedBatch.AmountCostRatioBalance = NewRow.AmountCostRatio;
		
		NewRowReceivedBatch.AmountCostBalance       = NewRow.AmountCost;
		NewRowReceivedBatch.AmountCostTaxBalance    = NewRow.AmountCostTax;
		NewRowReceivedBatch.AmountRevenueBalance    = NewRow.AmountRevenue;
		NewRowReceivedBatch.AmountRevenueTaxBalance = NewRow.AmountRevenueTax;
		
		NewRowReceivedBatch.IsOpeningBalance = False;
		NewRowReceivedBatch.Direction        = Enums.BatchDirection.Receipt;
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
EndProcedure

Function GetSalesBatches(SalesInvoice, DataForSalesBatches, BatchKey)
	Query = New Query();
	Query.Text =
	"SELECT
	|	DataForSalesBatches.Batch AS Batch,
	|	DataForSalesBatches.Period AS Date,
	|	DataForSalesBatches.BatchKey AS BatchKey,
	|	DataForSalesBatches.SalesInvoice AS SalesInvoice,
	|	DataForSalesBatches.Quantity AS Quantity,
	|	DataForSalesBatches.Amount AS Amount,
	|	DataForSalesBatches.AmountTax AS AmountTax,
	|	DataForSalesBatches.NotDirectCosts AS NotDirectCosts,
	|	DataForSalesBatches.AmountCostRatio AS AmountCostRatio,
	|	DataForSalesBatches.AmountCost AS AmountCost,
	|	DataForSalesBatches.AmountCostTax AS AmountCostTax,
	|	DataForSalesBatches.AmountRevenue AS AmountRevenue,
	|	DataForSalesBatches.AmountRevenueTax AS AmountRevenueTax
	|INTO DataForSalesBatches
	|FROM
	|	&DataForSalesBatches AS DataForSalesBatches
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R6050T_SalesBatchesTurnovers.Batch AS Batch,
	|	R6050T_SalesBatchesTurnovers.Period AS Date,
	|	R6050T_SalesBatchesTurnovers.BatchKey AS BatchKey,
	|	R6050T_SalesBatchesTurnovers.SalesInvoice AS SalesInvoice,
	|	R6050T_SalesBatchesTurnovers.QuantityTurnover AS Quantity,
	|	R6050T_SalesBatchesTurnovers.AmountTurnover AS Amount,
	|	R6050T_SalesBatchesTurnovers.AmountTaxTurnover AS AmountTax,
	|	R6050T_SalesBatchesTurnovers.NotDirectCostsTurnover AS NotDirectCosts,
	|	R6050T_SalesBatchesTurnovers.AmountCostRatioTurnover AS AmountCostRatio,
	|	R6050T_SalesBatchesTurnovers.AmountCostTurnover AS AmountCost,
	|	R6050T_SalesBatchesTurnovers.AmountCostTaxTurnover AS AmountCostTax,
	|	R6050T_SalesBatchesTurnovers.AmountRevenueTurnover AS AmountRevenue,
	|	R6050T_SalesBatchesTurnovers.AmountRevenueTaxTurnover AS AmountRevenueTax
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
	|	DataForSalesBatches.Amount AS Amount,
	|	DataForSalesBatches.AmountTax AS AmountTax,
	|	DataForSalesBatches.NotDirectCosts AS NotDirectCosts,
	|	DataForSalesBatches.AmountCostRatio AS AmountCostRatio,
	|	DataForSalesBatches.AmountCost AS AmountCost,
	|	DataForSalesBatches.AmountCostTax AS AmountCostTax,
	|	DataForSalesBatches.AmountRevenue AS AmountRevenue,
	|	DataForSalesBatches.AmountRevenueTax AS AmountRevenueTax,
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
	|	SalesBatches.Amount,
	|	SalesBatches.AmountTax,
	|	SalesBatches.NotDirectCosts,
	|	SalesBatches.AmountCostRatio,
	|	SalesBatches.AmountCost,
	|	SalesBatches.AmountCostTax,
	|	SalesBatches.AmountRevenue,
	|	SalesBatches.AmountRevenueTax,
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
	|	SUM(AllData.AmountTax) AS AmountTax,
	|	SUM(AllData.NotDirectCosts) AS NotDirectCosts,
	|	SUM(AllData.AmountCostRatio) AS AmountCostRatio,
	|	SUM(AllData.AmountCost) AS AmountCost,
	|	SUM(AllData.AmountCostTax) AS AmountCostTax,
	|	SUM(AllData.AmountRevenue) AS AmountRevenue,
	|	SUM(AllData.AmountRevenueTax) AS AmountRevenueTax,
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

Function CalculateReceiptAmountBySalesReturn(ReceiptQuantity, BatchBySales, AmountColumnName)
	ReceiptAmount = 0;
	If BatchBySales.Quantity - ReceiptQuantity = 0 Then
		ReceiptAmount = BatchBySales[AmountColumnName];
	Else
		If BatchBySales.Quantity <> 0 Then
			ReceiptAmount = (BatchBySales[AmountColumnName] / BatchBySales.Quantity) * ReceiptQuantity;
		EndIf;
	EndIf;
	Return ReceiptAmount;
EndFunction

Function CalculateExpenseAmount(ExpenseQuantity, Row_Batch, AmountColumnName)
	ExpenseAmount = 0;
	If Row_Batch.QuantityBalance - ExpenseQuantity = 0 Then
		ExpenseAmount = Row_Batch[AmountColumnName];
	Else
		If Row_Batch.QuantityBalance <> 0 Then
			ExpenseAmount = Round((Row_Batch[AmountColumnName] / Row_Batch.QuantityBalance) * ExpenseQuantity, 2);
		EndIf;
	EndIf;
	Return ExpenseAmount;
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

