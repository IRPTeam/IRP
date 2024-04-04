
// strict-types

// T6095S_WriteOffBatchesInfo
// R6010B_BatchWiseBalance
// T6030S_BatchRelevance
// R6030T_BatchShortageOutgoing
// R6040T_BatchShortageIncoming

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
	ArrayOfTypes.Add(Type("DocumentRef.CommissioningOfFixedAsset"));
	ArrayOfTypes.Add(Type("DocumentRef.ModernizationOfFixedAsset"));
	ArrayOfTypes.Add(Type("DocumentRef.DecommissioningOfFixedAsset"));
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

Function GetBatchWiseBalance(CalculationSettings)

	// EmptyTable_BatchWiseBalance
	RegMetadata = Metadata.AccumulationRegisters.R6010B_BatchWiseBalance;
	EmptyTable_BatchWiseBalance = New ValueTable();
	EmptyTable_BatchWiseBalance.Columns.Add("Batch"     , New TypeDescription("CatalogRef.Batches"));
	EmptyTable_BatchWiseBalance.Columns.Add("BatchKey"  , New TypeDescription("CatalogRef.BatchKeys"));
	EmptyTable_BatchWiseBalance.Columns.Add("Document"  , GetBatchDocumentsTypes());
	EmptyTable_BatchWiseBalance.Columns.Add("Company"   , New TypeDescription("CatalogRef.Companies"));
	EmptyTable_BatchWiseBalance.Columns.Add("Period"    , RegMetadata.StandardAttributes.Period.Type);
	EmptyTable_BatchWiseBalance.Columns.Add("Quantity"  , RegMetadata.Resources.Quantity.Type);

	EmptyTable_BatchWiseBalance.Columns.Add("InvoiceAmount"             , RegMetadata.Resources.InvoiceAmount.Type);
	EmptyTable_BatchWiseBalance.Columns.Add("InvoiceTaxAmount"          , RegMetadata.Resources.InvoiceTaxAmount.Type);
	
	EmptyTable_BatchWiseBalance.Columns.Add("IndirectCostAmount"        , RegMetadata.Resources.IndirectCostAmount.Type);
	EmptyTable_BatchWiseBalance.Columns.Add("IndirectCostTaxAmount"     , RegMetadata.Resources.IndirectCostTaxAmount.Type);
	
	EmptyTable_BatchWiseBalance.Columns.Add("ExtraCostAmountByRatio"    , RegMetadata.Resources.ExtraCostAmountByRatio.Type);
	EmptyTable_BatchWiseBalance.Columns.Add("ExtraCostTaxAmountByRatio" , RegMetadata.Resources.ExtraCostTaxAmountByRatio.Type);
	
	EmptyTable_BatchWiseBalance.Columns.Add("ExtraDirectCostAmount"     , RegMetadata.Resources.ExtraDirectCostAmount.Type);
	EmptyTable_BatchWiseBalance.Columns.Add("ExtraDirectCostTaxAmount"  , RegMetadata.Resources.ExtraDirectCostTaxAmount.Type);
	
	EmptyTable_BatchWiseBalance.Columns.Add("AllocatedCostAmount"       , RegMetadata.Resources.AllocatedCostAmount.Type);
	EmptyTable_BatchWiseBalance.Columns.Add("AllocatedCostTaxAmount"    , RegMetadata.Resources.AllocatedCostTaxAmount.Type);
	
	EmptyTable_BatchWiseBalance.Columns.Add("AllocatedRevenueAmount"    , RegMetadata.Resources.AllocatedRevenueAmount.Type);
	EmptyTable_BatchWiseBalance.Columns.Add("AllocatedRevenueTaxAmount" , RegMetadata.Resources.AllocatedRevenueTaxAmount.Type);
	
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
	
	DataForBundleAmountValues.Columns.Add("InvoiceAmount"             , RegMetadata.Resources.InvoiceAmount.Type);
	DataForBundleAmountValues.Columns.Add("InvoiceTaxAmount"          , RegMetadata.Resources.InvoiceTaxAmount.Type);

	DataForBundleAmountValues.Columns.Add("IndirectCostAmount"        , RegMetadata.Resources.IndirectCostAmount.Type);
	DataForBundleAmountValues.Columns.Add("IndirectCostTaxAmount"     , RegMetadata.Resources.IndirectCostTaxAmount.Type);
	
	DataForBundleAmountValues.Columns.Add("ExtraCostAmountByRatio"    , RegMetadata.Resources.ExtraCostAmountByRatio.Type);
	DataForBundleAmountValues.Columns.Add("ExtraCostTaxAmountByRatio" , RegMetadata.Resources.ExtraCostTaxAmountByRatio.Type);
	
	DataForBundleAmountValues.Columns.Add("ExtraDirectCostAmount"     , RegMetadata.Resources.ExtraDirectCostAmount.Type);
	DataForBundleAmountValues.Columns.Add("ExtraDirectCostTaxAmount"  , RegMetadata.Resources.ExtraDirectCostTaxAmount.Type);
		
	DataForBundleAmountValues.Columns.Add("AllocatedCostAmount"       , RegMetadata.Resources.AllocatedCostAmount.Type);
	DataForBundleAmountValues.Columns.Add("AllocatedCostTaxAmount"    , RegMetadata.Resources.AllocatedCostTaxAmount.Type);
	
	DataForBundleAmountValues.Columns.Add("AllocatedRevenueAmount"    , RegMetadata.Resources.AllocatedRevenueAmount.Type);
	DataForBundleAmountValues.Columns.Add("AllocatedRevenueTaxAmount" , RegMetadata.Resources.AllocatedRevenueTaxAmount.Type);
	
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
	
	DataForCompositeBatchesAmountValues.Columns.Add("InvoiceAmount"              , RegMetadata.Resources.InvoiceAmount.Type);
	DataForCompositeBatchesAmountValues.Columns.Add("InvoiceTaxAmount"           , RegMetadata.Resources.InvoiceTaxAmount.Type);
	
	DataForCompositeBatchesAmountValues.Columns.Add("IndirectCostAmount"         , RegMetadata.Resources.IndirectCostAmount.Type);
	DataForCompositeBatchesAmountValues.Columns.Add("IndirectCostTaxAmount"      , RegMetadata.Resources.IndirectCostTaxAmount.Type);
	
	DataForCompositeBatchesAmountValues.Columns.Add("ExtraCostAmountByRatio"     , RegMetadata.Resources.ExtraCostAmountByRatio.Type);
	DataForCompositeBatchesAmountValues.Columns.Add("ExtraCostTaxAmountByRatio"  , RegMetadata.Resources.ExtraCostTaxAmountByRatio.Type);
	
	DataForCompositeBatchesAmountValues.Columns.Add("ExtraDirectCostAmount"      , RegMetadata.Resources.ExtraDirectCostAmount.Type);
	DataForCompositeBatchesAmountValues.Columns.Add("ExtraDirectCostTaxAmount"   , RegMetadata.Resources.ExtraDirectCostTaxAmount.Type);
	
	DataForCompositeBatchesAmountValues.Columns.Add("AllocatedCostAmount"        , RegMetadata.Resources.AllocatedCostAmount.Type);
	DataForCompositeBatchesAmountValues.Columns.Add("AllocatedCostTaxAmount"     , RegMetadata.Resources.AllocatedCostTaxAmount.Type);
	
	DataForCompositeBatchesAmountValues.Columns.Add("AllocatedRevenueAmount"     , RegMetadata.Resources.AllocatedRevenueAmount.Type);
	DataForCompositeBatchesAmountValues.Columns.Add("AllocatedRevenueTaxAmount"  , RegMetadata.Resources.AllocatedRevenueTaxAmount.Type);
	
	Tables.Insert("DataForCompositeBatchesAmountValues", DataForCompositeBatchesAmountValues);
	
	// DataForReallocatedBatchesAmountValues
	RegMetadata = Metadata.InformationRegisters.T6080S_ReallocatedBatchesAmountValues;
	DataForReallocatedBatchesAmountValues = New ValueTable();
	DataForReallocatedBatchesAmountValues.Columns.Add("Period"           , RegMetadata.StandardAttributes.Period.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("OutgoingDocument" , RegMetadata.Dimensions.OutgoingDocument.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("IncomingDocument" , RegMetadata.Dimensions.IncomingDocument.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("BatchKey"         , RegMetadata.Dimensions.BatchKey.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("Quantity"         , RegMetadata.Resources.Quantity.Type);
	
	DataForReallocatedBatchesAmountValues.Columns.Add("InvoiceAmount"             , RegMetadata.Resources.InvoiceAmount.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("InvoiceTaxAmount"          , RegMetadata.Resources.InvoiceTaxAmount.Type);
	
	DataForReallocatedBatchesAmountValues.Columns.Add("IndirectCostAmount"        , RegMetadata.Resources.IndirectCostAmount.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("IndirectCostTaxAmount"     , RegMetadata.Resources.IndirectCostTaxAmount.Type);
	
	DataForReallocatedBatchesAmountValues.Columns.Add("ExtraCostAmountByRatio"    , RegMetadata.Resources.ExtraCostAmountByRatio.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("ExtraCostTaxAmountByRatio" , RegMetadata.Resources.ExtraCostTaxAmountByRatio.Type);
	
	DataForReallocatedBatchesAmountValues.Columns.Add("ExtraDirectCostAmount"     , RegMetadata.Resources.ExtraDirectCostAmount.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("ExtraDirectCostTaxAmount"  , RegMetadata.Resources.ExtraDirectCostTaxAmount.Type);
	
	DataForReallocatedBatchesAmountValues.Columns.Add("AllocatedCostAmount"       , RegMetadata.Resources.AllocatedCostAmount.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("AllocatedCostTaxAmount"    , RegMetadata.Resources.AllocatedCostTaxAmount.Type);
	
	DataForReallocatedBatchesAmountValues.Columns.Add("AllocatedRevenueAmount"    , RegMetadata.Resources.AllocatedRevenueAmount.Type);
	DataForReallocatedBatchesAmountValues.Columns.Add("AllocatedRevenueTaxAmount" , RegMetadata.Resources.AllocatedRevenueTaxAmount.Type);
	
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
	
	DataForWriteOffBatches.Columns.Add("InvoiceAmount"             , RegMetadata.Resources.InvoiceAmount.Type);
	DataForWriteOffBatches.Columns.Add("InvoiceTaxAmount"          , RegMetadata.Resources.InvoiceTaxAmount.Type);
	
	DataForWriteOffBatches.Columns.Add("IndirectCostAmount"        , RegMetadata.Resources.IndirectCostAmount.Type);
	DataForWriteOffBatches.Columns.Add("IndirectCostTaxAmount"     , RegMetadata.Resources.IndirectCostTaxAmount.Type);
	
	DataForWriteOffBatches.Columns.Add("ExtraCostAmountByRatio"    , RegMetadata.Resources.ExtraCostAmountByRatio.Type);
	DataForWriteOffBatches.Columns.Add("ExtraCostTaxAmountByRatio" , RegMetadata.Resources.ExtraCostTaxAmountByRatio.Type);
	
	DataForWriteOffBatches.Columns.Add("ExtraDirectCostAmount"     , RegMetadata.Resources.ExtraDirectCostAmount.Type);
	DataForWriteOffBatches.Columns.Add("ExtraDirectCostTaxAmount"  , RegMetadata.Resources.ExtraDirectCostTaxAmount.Type);
	
	DataForWriteOffBatches.Columns.Add("AllocatedCostAmount"       , RegMetadata.Resources.AllocatedCostAmount.Type);
	DataForWriteOffBatches.Columns.Add("AllocatedCostTaxAmount"    , RegMetadata.Resources.AllocatedCostTaxAmount.Type);
	
	DataForWriteOffBatches.Columns.Add("AllocatedRevenueAmount"    , RegMetadata.Resources.AllocatedRevenueAmount.Type);
	DataForWriteOffBatches.Columns.Add("AllocatedRevenueTaxAmount" , RegMetadata.Resources.AllocatedRevenueTaxAmount.Type);
	
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
	
	DataForFixedAssets.Columns.Add("InvoiceAmount"             , RegMetadata.Resources.Amount.Type);
	DataForFixedAssets.Columns.Add("InvoiceTaxAmount"          , RegMetadata.Resources.Amount.Type);
	
	DataForFixedAssets.Columns.Add("IndirectCostAmount"        , RegMetadata.Resources.Amount.Type);
	DataForFixedAssets.Columns.Add("IndirectCostTaxAmount"     , RegMetadata.Resources.Amount.Type);
	
	DataForFixedAssets.Columns.Add("ExtraCostAmountByRatio"    , RegMetadata.Resources.Amount.Type);
	DataForFixedAssets.Columns.Add("ExtraCostTaxAmountByRatio" , RegMetadata.Resources.Amount.Type);
	
	DataForFixedAssets.Columns.Add("ExtraDirectCostAmount"     , RegMetadata.Resources.Amount.Type);
	DataForFixedAssets.Columns.Add("ExtraDirectCostTaxAmount"  , RegMetadata.Resources.Amount.Type);
	
	DataForFixedAssets.Columns.Add("AllocatedCostAmount"       , RegMetadata.Resources.Amount.Type);
	DataForFixedAssets.Columns.Add("AllocatedCostTaxAmount"    , RegMetadata.Resources.Amount.Type);
	
	DataForFixedAssets.Columns.Add("AllocatedRevenueAmount"    , RegMetadata.Resources.Amount.Type);
	DataForFixedAssets.Columns.Add("AllocatedRevenueTaxAmount" , RegMetadata.Resources.Amount.Type);
	
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
	TableOfReturnedBatches.Columns.Add("Quantity"         , RegMetadata.Resources.Quantity.Type);
	
	TableOfReturnedBatches.Columns.Add("BatchDocument"    , RegMetadata.Dimensions.BatchDocument.Type);
	TableOfReturnedBatches.Columns.Add("SalesInvoice"     , RegMetadata.Dimensions.SalesInvoice.Type); 
	TableOfReturnedBatches.Columns.Add("AlreadyReceived"  , New TypeDescription("Boolean"));
	
	TableOfReturnedBatches.Columns.Add("InvoiceAmount"              , RegMetadata.Resources.InvoiceAmount.Type);
	TableOfReturnedBatches.Columns.Add("InvoiceTaxAmount"           , RegMetadata.Resources.InvoiceTaxAmount.Type);
	
	TableOfReturnedBatches.Columns.Add("IndirectCostAmount"         , RegMetadata.Resources.IndirectCostAmount.Type);
	TableOfReturnedBatches.Columns.Add("IndirectCostTaxAmount"      , RegMetadata.Resources.IndirectCostTaxAmount.Type);
	
	TableOfReturnedBatches.Columns.Add("ExtraCostAmountByRatio"     , RegMetadata.Resources.ExtraCostAmountByRatio.Type);
	TableOfReturnedBatches.Columns.Add("ExtraCostTaxAmountByRatio"  , RegMetadata.Resources.ExtraCostTaxAmountByRatio.Type);
	
	TableOfReturnedBatches.Columns.Add("ExtraDirectCostAmount"      , RegMetadata.Resources.ExtraDirectCostAmount.Type);
	TableOfReturnedBatches.Columns.Add("ExtraDirectCostTaxAmount"   , RegMetadata.Resources.ExtraDirectCostTaxAmount.Type);
	
	TableOfReturnedBatches.Columns.Add("AllocatedCostAmount"        , RegMetadata.Resources.AllocatedCostAmount.Type);
	TableOfReturnedBatches.Columns.Add("AllocatedCostTaxAmount"     , RegMetadata.Resources.AllocatedCostTaxAmount.Type);
	
	TableOfReturnedBatches.Columns.Add("AllocatedRevenueAmount"     , RegMetadata.Resources.AllocatedRevenueAmount.Type);
	TableOfReturnedBatches.Columns.Add("AllocatedRevenueTaxAmount"  , RegMetadata.Resources.AllocatedRevenueTaxAmount.Type);
	
	TableOfReturnedBatches.Columns.Add("InvoiceAmountBalance"             , RegMetadata.Resources.InvoiceAmount.Type);
	TableOfReturnedBatches.Columns.Add("InvoiceTaxAmountBalance"          , RegMetadata.Resources.InvoiceTaxAmount.Type);
	
	TableOfReturnedBatches.Columns.Add("IndirectCostAmountBalance"        , RegMetadata.Resources.IndirectCostAmount.Type);
	TableOfReturnedBatches.Columns.Add("IndirectCostTaxAmountBalance"     , RegMetadata.Resources.IndirectCostTaxAmount.Type);
	
	TableOfReturnedBatches.Columns.Add("ExtraCostAmountByRatioBalance"    , RegMetadata.Resources.ExtraCostAmountByRatio.Type);
	TableOfReturnedBatches.Columns.Add("ExtraCostTaxAmountByRatioBalance" , RegMetadata.Resources.ExtraCostTaxAmountByRatio.Type);
	
	TableOfReturnedBatches.Columns.Add("ExtraDirectCostAmountBalance"     , RegMetadata.Resources.ExtraDirectCostAmount.Type);
	TableOfReturnedBatches.Columns.Add("ExtraDirectCostTaxAmountBalance"  , RegMetadata.Resources.ExtraDirectCostTaxAmount.Type);
	
	TableOfReturnedBatches.Columns.Add("AllocatedCostAmountBalance"       , RegMetadata.Resources.AllocatedCostAmount.Type);
	TableOfReturnedBatches.Columns.Add("AllocatedCostTaxAmountBalance"    , RegMetadata.Resources.AllocatedCostTaxAmount.Type);
	
	TableOfReturnedBatches.Columns.Add("AllocatedRevenueAmountBalance"    , RegMetadata.Resources.AllocatedRevenueAmount.Type);
	TableOfReturnedBatches.Columns.Add("AllocatedRevenueTaxAmountBalance" , RegMetadata.Resources.AllocatedRevenueTaxAmount.Type);
	
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
			
			NewRow.InvoiceAmount    = Row.InvoiceAmount;
			NewRow.InvoiceTaxAmount = Row.InvoiceTaxAmount;
			
			NewRow.IndirectCostAmount   = Row.IndirectCostAmount;
			NewRow.IndirectCostTaxAmount   = Row.IndirectCostTaxAmount;
			
			NewRow.ExtraCostAmountByRatio = Row.ExtraCostAmountByRatio;
			NewRow.ExtraCostTaxAmountByRatio = Row.ExtraCostTaxAmountByRatio;
			
			NewRow.ExtraDirectCostAmount = Row.ExtraDirectCostAmount;
			NewRow.ExtraDirectCostTaxAmount = Row.ExtraDirectCostTaxAmount;
			
			NewRow.AllocatedCostAmount       = Row.AllocatedCostAmount;
			NewRow.AllocatedCostTaxAmount    = Row.AllocatedCostTaxAmount;
			
			NewRow.AllocatedRevenueAmount    = Row.AllocatedRevenueAmount;
			NewRow.AllocatedRevenueTaxAmount = Row.AllocatedRevenueTaxAmount;
			
			NewRow.ItemLinkID = Row.ItemLinkID;
			
			// simple receipt	
			If IsNotMultiDirectionDocument(Document) // is not transfer, produce, bundling or unbundling
				And Not ValueIsFilled(Row.SalesInvoice) // is not return by sales invoice
				And TypeOf(Document) <> Type("DocumentRef.BatchReallocateIncoming") // is not receipt by btach reallocation
				
				// sales invoice with transaction type "shipment to trade agent" is multi direction document
				And Not IsShipmentToTradeAgent(Document) Then
				
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
						
						NewRow.InvoiceAmount = Price * Row.Quantity;
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
										
					ReceiptQuantity = Min(NeedReceipt, BatchBySales.Quantity); // how many can receipt (quantity)
					
					ReceiptInvoiceAmount           = CalculateReceiptAmountBySalesReturn(ReceiptQuantity, BatchBySales, "InvoiceAmount");
					ReceiptInvoiceTaxAmount        = CalculateReceiptAmountBySalesReturn(ReceiptQuantity, BatchBySales, "InvoiceTaxAmount");
					
					ReceiptIndirectCostAmount   = CalculateReceiptAmountBySalesReturn(ReceiptQuantity, BatchBySales, "IndirectCostAmount");
					ReceiptIndirectCostTaxAmount   = CalculateReceiptAmountBySalesReturn(ReceiptQuantity, BatchBySales, "IndirectCostTaxAmount");
					
					ReceiptExtraCostAmountByRatio  = CalculateReceiptAmountBySalesReturn(ReceiptQuantity, BatchBySales, "ExtraCostAmountByRatio");
					ReceiptExtraCostTaxAmountByRatio  = CalculateReceiptAmountBySalesReturn(ReceiptQuantity, BatchBySales, "ExtraCostTaxAmountByRatio");
					
					ReceiptExtraDirectCostAmount  = CalculateReceiptAmountBySalesReturn(ReceiptQuantity, BatchBySales, "ExtraDirectCostAmount");
					ReceiptExtraDirectCostTaxAmount  = CalculateReceiptAmountBySalesReturn(ReceiptQuantity, BatchBySales, "ExtraDirectCostTaxAmount");
										
					ReceiptAllocatedCostAmount       = CalculateReceiptAmountBySalesReturn(ReceiptQuantity, BatchBySales, "AllocatedCostAmount");
					ReceiptAllocatedCostTaxAmount    = CalculateReceiptAmountBySalesReturn(ReceiptQuantity, BatchBySales, "AllocatedCostTaxAmount");
					
					ReceiptAllocatedRevenueAmount    = CalculateReceiptAmountBySalesReturn(ReceiptQuantity, BatchBySales, "AllocatedRevenueAmount");
					ReceiptAllocatedRevenueTaxAmount = CalculateReceiptAmountBySalesReturn(ReceiptQuantity, BatchBySales, "AllocatedRevenueTaxAmount");
					
					BatchBySales.Quantity  = BatchBySales.Quantity  - ReceiptQuantity;
					
					BatchBySales.InvoiceAmount    = BatchBySales.InvoiceAmount    - ReceiptInvoiceAmount;
					BatchBySales.InvoiceTaxAmount = BatchBySales.InvoiceTaxAmount - ReceiptInvoiceTaxAmount;
					
					BatchBySales.IndirectCostAmount  = BatchBySales.IndirectCostAmount  - ReceiptIndirectCostAmount;
					BatchBySales.IndirectCostTaxAmount  = BatchBySales.IndirectCostTaxAmount  - ReceiptIndirectCostTaxAmount;
					
					BatchBySales.ExtraCostAmountByRatio = BatchBySales.ExtraCostAmountByRatio - ReceiptExtraCostAmountByRatio;
					BatchBySales.ExtraCostTaxAmountByRatio = BatchBySales.ExtraCostTaxAmountByRatio - ReceiptExtraCostTaxAmountByRatio;
					
					BatchBySales.ExtraDirectCostAmount = BatchBySales.ExtraDirectCostAmount - ReceiptExtraDirectCostAmount;
					BatchBySales.ExtraDirectCostTaxAmount = BatchBySales.ExtraDirectCostTaxAmount - ReceiptExtraDirectCostTaxAmount;
					
					BatchBySales.AllocatedCostAmount     = BatchBySales.AllocatedCostAmount        - ReceiptAllocatedCostAmount;
					BatchBySales.AllocatedCostTaxAmount  = BatchBySales.AllocatedCostTaxAmount     - ReceiptAllocatedCostTaxAmount;
					
					BatchBySales.AllocatedRevenueAmount  = BatchBySales.AllocatedRevenueAmount     - ReceiptAllocatedRevenueAmount;
					BatchBySales.AllocatedRevenueTaxAmount  = BatchBySales.AllocatedRevenueTaxAmount  - ReceiptAllocatedRevenueTaxAmount;
					
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

						NewRow_ReturnedBatches.InvoiceAmount           = ReceiptInvoiceAmount;
						NewRow_ReturnedBatches.InvoiceTaxAmount        = ReceiptInvoiceTaxAmount;
						
						NewRow_ReturnedBatches.IndirectCostAmount   = ReceiptIndirectCostAmount;
						NewRow_ReturnedBatches.IndirectCostTaxAmount   = ReceiptIndirectCostTaxAmount;
						
						NewRow_ReturnedBatches.ExtraCostAmountByRatio  = ReceiptExtraCostAmountByRatio;
						NewRow_ReturnedBatches.ExtraCostTaxAmountByRatio  = ReceiptExtraCostTaxAmountByRatio;
						
						NewRow_ReturnedBatches.ExtraDirectCostAmount  = ReceiptExtraDirectCostAmount;
						NewRow_ReturnedBatches.ExtraDirectCostTaxAmount  = ReceiptExtraDirectCostTaxAmount;
						
						NewRow_ReturnedBatches.AllocatedCostAmount       = ReceiptAllocatedCostAmount;
						NewRow_ReturnedBatches.AllocatedCostTaxAmount    = ReceiptAllocatedCostTaxAmount;
						
						NewRow_ReturnedBatches.AllocatedRevenueAmount    = ReceiptAllocatedRevenueAmount;
						NewRow_ReturnedBatches.AllocatedRevenueTaxAmount = ReceiptAllocatedRevenueTaxAmount;
					
						NewRow_ReturnedBatches.Document         = _BatchBySales_Document;
						NewRow_ReturnedBatches.Company          = _BatchBySales_Company;
						NewRow_ReturnedBatches.Batch            = _BatchBySales_Batch;
					
						NewRow_ReturnedBatches.Date             = Row.Date;
						NewRow_ReturnedBatches.Direction        = Enums.BatchDirection.Receipt;
						NewRow_ReturnedBatches.QuantityBalance  = ReceiptQuantity;
						
						NewRow_ReturnedBatches.InvoiceAmountBalance    = ReceiptInvoiceAmount;
						NewRow_ReturnedBatches.InvoiceTaxAmountBalance = ReceiptInvoiceTaxAmount;
						
						NewRow_ReturnedBatches.IndirectCostAmountBalance  = ReceiptIndirectCostAmount;
						NewRow_ReturnedBatches.IndirectCostTaxAmountBalance  = ReceiptIndirectCostTaxAmount;
						
						NewRow_ReturnedBatches.ExtraCostAmountByRatioBalance = ReceiptExtraCostAmountByRatio;
						NewRow_ReturnedBatches.ExtraCostTaxAmountByRatioBalance = ReceiptExtraCostTaxAmountByRatio;
						
						NewRow_ReturnedBatches.ExtraDirectCostAmountBalance = ReceiptExtraDirectCostAmount;
						NewRow_ReturnedBatches.ExtraDirectCostTaxAmountBalance = ReceiptExtraDirectCostTaxAmount;
						
						NewRow_ReturnedBatches.AllocatedCostAmountBalance       = ReceiptAllocatedCostAmount;
						NewRow_ReturnedBatches.AllocatedCostTaxAmountBalance    = ReceiptAllocatedCostTaxAmount;
						
						NewRow_ReturnedBatches.AllocatedRevenueAmountBalance    = ReceiptAllocatedRevenueAmount;
						NewRow_ReturnedBatches.AllocatedRevenueTaxAmountBalance = ReceiptAllocatedRevenueTaxAmount;

						// Data for receipt
					
						NewRow_DataForReceipt = Tables.DataForReceipt.Add();
					
						NewRow_DataForReceipt.Company   = _BatchBySales_Company;
						NewRow_DataForReceipt.Batch     = _BatchBySales_Batch;
					
						NewRow_DataForReceipt.BatchKey  = Row.BatchKey;
						NewRow_DataForReceipt.Document  = Row.Document;
						NewRow_DataForReceipt.Period    = Row.Date;
						NewRow_DataForReceipt.Quantity  = ReceiptQuantity;

						NewRow_DataForReceipt.InvoiceAmount    = ReceiptInvoiceAmount;
						NewRow_DataForReceipt.InvoiceTaxAmount = ReceiptInvoiceTaxAmount;
						
						NewRow_DataForReceipt.IndirectCostAmount  = ReceiptIndirectCostAmount;
						NewRow_DataForReceipt.IndirectCostTaxAmount  = ReceiptIndirectCostTaxAmount;
						
						NewRow_DataForReceipt.ExtraCostAmountByRatio = ReceiptExtraCostAmountByRatio;
						NewRow_DataForReceipt.ExtraCostTaxAmountByRatio = ReceiptExtraCostTaxAmountByRatio;
						
						NewRow_DataForReceipt.ExtraDirectCostAmount = ReceiptExtraDirectCostAmount;
						NewRow_DataForReceipt.ExtraDirectCostTaxAmount = ReceiptExtraDirectCostTaxAmount;
						
						NewRow_DataForReceipt.AllocatedCostAmount       = ReceiptAllocatedCostAmount;
						NewRow_DataForReceipt.AllocatedCostTaxAmount    = ReceiptAllocatedCostTaxAmount;
						
						NewRow_DataForReceipt.AllocatedRevenueAmount    = ReceiptAllocatedRevenueAmount;
						NewRow_DataForReceipt.AllocatedRevenueTaxAmount = ReceiptAllocatedRevenueTaxAmount;

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
								
				ExpenseQuantity = Min(NeedExpense, Row_Batch.QuantityBalance);

				ExpenseInvoiceAmount           = CalculateExpenseAmount(ExpenseQuantity, Row_Batch, "InvoiceAmountBalance");
				ExpenseInvoiceTaxAmount        = CalculateExpenseAmount(ExpenseQuantity, Row_Batch, "InvoiceTaxAmountBalance");
				
				ExpenseIndirectCostAmount   = CalculateExpenseAmount(ExpenseQuantity, Row_Batch, "IndirectCostAmountBalance");
				ExpenseIndirectCostTaxAmount   = CalculateExpenseAmount(ExpenseQuantity, Row_Batch, "IndirectCostTaxAmountBalance");
				
				ExpenseExtraCostAmountByRatio  = CalculateExpenseAmount(ExpenseQuantity, Row_Batch, "ExtraCostAmountByRatioBalance");
				ExpenseExtraCostTaxAmountByRatio  = CalculateExpenseAmount(ExpenseQuantity, Row_Batch, "ExtraCostTaxAmountByRatioBalance");
				
				ExpenseExtraDirectCostAmount  = CalculateExpenseAmount(ExpenseQuantity, Row_Batch, "ExtraDirectCostAmountBalance");
				ExpenseExtraDirectCostTaxAmount  = CalculateExpenseAmount(ExpenseQuantity, Row_Batch, "ExtraDirectCostTaxAmountBalance");

				ExpenseAllocatedCostAmount       = CalculateExpenseAmount(ExpenseQuantity, Row_Batch, "AllocatedCostAmountBalance");
				ExpenseAllocatedCostTaxAmount    = CalculateExpenseAmount(ExpenseQuantity, Row_Batch, "AllocatedCostTaxAmountBalance");
				
				ExpenseAllocatedRevenueAmount    = CalculateExpenseAmount(ExpenseQuantity, Row_Batch, "AllocatedRevenueAmountBalance");
				ExpenseAllocatedRevenueTaxAmount = CalculateExpenseAmount(ExpenseQuantity, Row_Batch, "AllocatedRevenueTaxAmountBalance");
				
				Row_Batch.QuantityBalance  = Row_Batch.QuantityBalance  - ExpenseQuantity;
				
				Row_Batch.InvoiceAmountBalance    = Row_Batch.InvoiceAmountBalance    - ExpenseInvoiceAmount;
				Row_Batch.InvoiceTaxAmountBalance = Row_Batch.InvoiceTaxAmountBalance - ExpenseInvoiceTaxAmount;
				
				Row_Batch.IndirectCostAmountBalance  = Row_Batch.IndirectCostAmountBalance  - ExpenseIndirectCostAmount;
				Row_Batch.IndirectCostTaxAmountBalance  = Row_Batch.IndirectCostTaxAmountBalance  - ExpenseIndirectCostTaxAmount;
				
				Row_Batch.ExtraCostAmountByRatioBalance = Row_Batch.ExtraCostAmountByRatioBalance - ExpenseExtraCostAmountByRatio;
				Row_Batch.ExtraCostTaxAmountByRatioBalance = Row_Batch.ExtraCostTaxAmountByRatioBalance - ExpenseExtraCostTaxAmountByRatio;
				
				Row_Batch.ExtraDirectCostAmountBalance = Row_Batch.ExtraDirectCostAmountBalance - ExpenseExtraDirectCostAmount;
				Row_Batch.ExtraDirectCostTaxAmountBalance = Row_Batch.ExtraDirectCostTaxAmountBalance - ExpenseExtraDirectCostTaxAmount;
				
				Row_Batch.AllocatedCostAmountBalance       = Row_Batch.AllocatedCostAmountBalance       - ExpenseAllocatedCostAmount;
				Row_Batch.AllocatedCostTaxAmountBalance    = Row_Batch.AllocatedCostTaxAmountBalance    - ExpenseAllocatedCostTaxAmount;
				
				Row_Batch.AllocatedRevenueAmountBalance    = Row_Batch.AllocatedRevenueAmountBalance    - ExpenseAllocatedRevenueAmount;
				Row_Batch.AllocatedRevenueTaxAmountBalance = Row_Batch.AllocatedRevenueTaxAmountBalance - ExpenseAllocatedRevenueTaxAmount;
				
				NeedExpense = NeedExpense - ExpenseQuantity;

				If ExpenseQuantity <> 0 Or ExpenseInvoiceAmount <> 0 Then
					NewRow = Tables.DataForExpense.Add();
					NewRow.BatchKey  = Row.BatchKey;
					NewRow.Document  = Row.Document;
					NewRow.Company   = Row.Company;
					NewRow.Period    = Row.Date;
					NewRow.Batch     = Row_Batch.Batch;
					NewRow.Quantity  = ExpenseQuantity;
					
					NewRow.InvoiceAmount    = ExpenseInvoiceAmount;
					NewRow.InvoiceTaxAmount = ExpenseInvoiceTaxAmount;
					
					NewRow.IndirectCostAmount  = ExpenseIndirectCostAmount;
					NewRow.IndirectCostTaxAmount  = ExpenseIndirectCostTaxAmount;
					
					NewRow.ExtraCostAmountByRatio = ExpenseExtraCostAmountByRatio;
					NewRow.ExtraCostTaxAmountByRatio = ExpenseExtraCostTaxAmountByRatio;
					
					NewRow.ExtraDirectCostAmount = ExpenseExtraDirectCostAmount;
					NewRow.ExtraDirectCostTaxAmount = ExpenseExtraDirectCostTaxAmount;
					
					NewRow.AllocatedCostAmount       = ExpenseAllocatedCostAmount;
					NewRow.AllocatedCostTaxAmount    = ExpenseAllocatedCostTaxAmount;
					
					NewRow.AllocatedRevenueAmount    = ExpenseAllocatedRevenueAmount;
					NewRow.AllocatedRevenueTaxAmount = ExpenseAllocatedRevenueTaxAmount;
					
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
	
	TableOfNewReceivedBatches.Columns.Add("InvoiceAmount");
	TableOfNewReceivedBatches.Columns.Add("InvoiceTaxAmount");
	
	TableOfNewReceivedBatches.Columns.Add("IndirectCostAmount");
	TableOfNewReceivedBatches.Columns.Add("IndirectCostTaxAmount");
	
	TableOfNewReceivedBatches.Columns.Add("ExtraCostAmountByRatio");
	TableOfNewReceivedBatches.Columns.Add("ExtraCostTaxAmountByRatio");
	
	TableOfNewReceivedBatches.Columns.Add("ExtraDirectCostAmount");
	TableOfNewReceivedBatches.Columns.Add("ExtraDirectCostTaxAmount");
	
	TableOfNewReceivedBatches.Columns.Add("AllocatedCostAmount");
	TableOfNewReceivedBatches.Columns.Add("AllocatedCostTaxAmount");
	
	TableOfNewReceivedBatches.Columns.Add("AllocatedRevenueAmount");
	TableOfNewReceivedBatches.Columns.Add("AllocatedRevenueTaxAmount");
	
	TableOfNewReceivedBatches.Columns.Add("QuantityBalance");
	
	TableOfNewReceivedBatches.Columns.Add("InvoiceAmountBalance");
	TableOfNewReceivedBatches.Columns.Add("InvoiceTaxAmountBalance");
	
	TableOfNewReceivedBatches.Columns.Add("IndirectCostAmountBalance");
	TableOfNewReceivedBatches.Columns.Add("IndirectCostTaxAmountBalance");
	
	TableOfNewReceivedBatches.Columns.Add("ExtraCostAmountByRatioBalance");
	TableOfNewReceivedBatches.Columns.Add("ExtraCostTaxAmountByRatioBalance");
	
	TableOfNewReceivedBatches.Columns.Add("ExtraDirectCostAmountBalance");
	TableOfNewReceivedBatches.Columns.Add("ExtraDirectCostTaxAmountBalance");
	
	TableOfNewReceivedBatches.Columns.Add("AllocatedCostAmountBalance");
	TableOfNewReceivedBatches.Columns.Add("AllocatedCostTaxAmountBalance");
	
	TableOfNewReceivedBatches.Columns.Add("AllocatedRevenueAmountBalance");
	TableOfNewReceivedBatches.Columns.Add("AllocatedRevenueTaxAmountBalance");
	
	TableOfNewReceivedBatches.Columns.Add("IsOpeningBalance");
	TableOfNewReceivedBatches.Columns.Add("Direction");
	TableOfNewReceivedBatches.Columns.Add("ReturnRow");
	
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

			NewRowReceivedBatch.InvoiceAmount           = Row.InvoiceAmount;
			NewRowReceivedBatch.InvoiceTaxAmount        = Row.InvoiceTaxAmount;

			NewRowReceivedBatch.IndirectCostAmount   = Row.IndirectCostAmount;
			NewRowReceivedBatch.IndirectCostTaxAmount   = Row.IndirectCostTaxAmount;
			
			NewRowReceivedBatch.ExtraCostAmountByRatio  = Row.ExtraCostAmountByRatio;
			NewRowReceivedBatch.ExtraCostTaxAmountByRatio  = Row.ExtraCostTaxAmountByRatio;
			
			NewRowReceivedBatch.ExtraDirectCostAmount  = Row.ExtraDirectCostAmount;
			NewRowReceivedBatch.ExtraDirectCostTaxAmount  = Row.ExtraDirectCostTaxAmount;
			
			NewRowReceivedBatch.AllocatedCostAmount       = Row.AllocatedCostAmount;
			NewRowReceivedBatch.AllocatedCostTaxAmount    = Row.AllocatedCostTaxAmount;
			
			NewRowReceivedBatch.AllocatedRevenueAmount    = Row.AllocatedRevenueAmount;
			NewRowReceivedBatch.AllocatedRevenueTaxAmount = Row.AllocatedRevenueTaxAmount;
			
			NewRowReceivedBatch.QuantityBalance  = Row.Quantity;
			
			NewRowReceivedBatch.InvoiceAmountBalance    = Row.InvoiceAmount;
			NewRowReceivedBatch.InvoiceTaxAmountBalance = Row.InvoiceTaxAmount;
			
			NewRowReceivedBatch.IndirectCostAmountBalance  = Row.IndirectCostAmount;
			NewRowReceivedBatch.IndirectCostTaxAmountBalance  = Row.IndirectCostTaxAmount;
			
			NewRowReceivedBatch.ExtraCostAmountByRatioBalance = Row.ExtraCostAmountByRatio;
			NewRowReceivedBatch.ExtraCostTaxAmountByRatioBalance = Row.ExtraCostTaxAmountByRatio;
			
			NewRowReceivedBatch.ExtraDirectCostAmountBalance = Row.ExtraDirectCostAmount;
			NewRowReceivedBatch.ExtraDirectCostTaxAmountBalance = Row.ExtraDirectCostTaxAmount;
			
			NewRowReceivedBatch.AllocatedCostAmountBalance       = Row.AllocatedCostAmount;
			NewRowReceivedBatch.AllocatedCostTaxAmountBalance    = Row.AllocatedCostTaxAmount;
			
			NewRowReceivedBatch.AllocatedRevenueAmountBalance    = Row.AllocatedRevenueAmount;
			NewRowReceivedBatch.AllocatedRevenueTaxAmountBalance = Row.AllocatedRevenueTaxAmount;
			
			NewRowReceivedBatch.IsOpeningBalance = False;
			NewRowReceivedBatch.Direction        = Enums.BatchDirection.Receipt;
			NewRowReceivedBatch.ReturnRow = Row;
		EndDo;
	
		For Each Row In TableOfNewReceivedBatches Do 
			Filter = New Structure();
			Filter.Insert("Batch", Row.Batch);
			Filter.Insert("BatchKey", Row.BatchKey);
			Filter.Insert("Company", Row.Company);
			Filter.Insert("Direction", Row.Direction);
			
			FoundedRows = Tree.Rows.FindRows(Filter, True);
			QuantityBalanceIsFilled = False;
			For Each FoundedRow In FoundedRows Do
				If ValueIsFilled(FoundedRow.QuantityBalance) Then
					QuantityBalanceIsFilled = True;
					Break;
				EndIf;
			EndDo;
			
			If QuantityBalanceIsFilled Then
				Continue;
			EndIf;
		    Row.ReturnRow.AlreadyReceived = True;
			FillPropertyValues(Rows.Add(), Row);
		EndDo;
		ArrayForDelete = New Array();
		For Each Row In Rows Do
			If Not ValueIsFilled(Row.InvoiceAmountBalance) Then
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
			
			ReallocatedInvoiceAmount    = 0;
			ReallocatedInvoiceTaxAmount = 0;
			
			ReallocatedIndirectCostAmount  = 0;
			ReallocatedIndirectCostTaxAmount  = 0;
			
			ReallocatedExtraCostAmountByRatio = 0;
			ReallocatedExtraCostTaxAmountByRatio = 0;
			
			ReallocatedExtraDirectCostAmount = 0;
			ReallocatedExtraDirectCostTaxAmount = 0;

			ReallocatedAllocatedCostAmount       = 0;
			ReallocatedAllocatedCostTaxAmount    = 0;

			ReallocatedAllocatedRevenueAmount    = 0;
			ReallocatedAllocatedRevenueTaxAmount = 0;
			
			ReallocatedQuantity  = 0;
			If FilteredRows.Count() Then
				For Each FilteredRow In FilteredRows Do
					ReallocatedInvoiceAmount    = ReallocatedInvoiceAmount    + FilteredRow.InvoiceAmount;
					ReallocatedInvoiceTaxAmount = ReallocatedInvoiceTaxAmount + FilteredRow.InvoiceTaxAmount;
					
					ReallocatedIndirectCostAmount  = ReallocatedIndirectCostAmount  + FilteredRow.IndirectCostAmount;
					ReallocatedIndirectCostTaxAmount  = ReallocatedIndirectCostTaxAmount  + FilteredRow.IndirectCostTaxAmount;
					
					ReallocatedExtraCostAmountByRatio = ReallocatedExtraCostAmountByRatio + FilteredRow.ExtraCostAmountByRatio;
					ReallocatedExtraCostTaxAmountByRatio = ReallocatedExtraCostTaxAmountByRatio + FilteredRow.ExtraCostTaxAmountByRatio;
					
					ReallocatedExtraDirectCostAmount = ReallocatedExtraDirectCostAmount + FilteredRow.ExtraDirectCostAmount;
					ReallocatedExtraDirectCostTaxAmount = ReallocatedExtraDirectCostTaxAmount + FilteredRow.ExtraDirectCostTaxAmount;
					
					ReallocatedAllocatedCostAmount       = ReallocatedAllocatedCostAmount       + FilteredRow.AllocatedCostAmount;
					ReallocatedAllocatedCostTaxAmount    = ReallocatedAllocatedCostTaxAmount    + FilteredRow.AllocatedCostTaxAmount;
					
					ReallocatedAllocatedRevenueAmount    = ReallocatedAllocatedRevenueAmount    + FilteredRow.AllocatedRevenueAmount;
					ReallocatedAllocatedRevenueTaxAmount = ReallocatedAllocatedRevenueTaxAmount + FilteredRow.AllocatedRevenueTaxAmount;
					
					ReallocatedQuantity  = ReallocatedQuantity  + FilteredRow.Quantity;
				EndDo;
			Else
				QuerySelection = GetReallocatedBatchesAmount(Filter);
				If QuerySelection.Next() Then
					ReallocatedInvoiceAmount    = QuerySelection.InvoiceAmount;
					ReallocatedInvoiceTaxAmount = QuerySelection.InvoiceTaxAmount;
					
					ReallocatedIndirectCostAmount  = QuerySelection.IndirectCostAmount;
					ReallocatedIndirectCostTaxAmount  = QuerySelection.IndirectCostTaxAmount;
					
					ReallocatedExtraCostAmountByRatio = QuerySelection.ExtraCostAmountByRatio;
					ReallocatedExtraCostTaxAmountByRatio = QuerySelection.ExtraCostTaxAmountByRatio;
					
					ReallocatedExtraDirectCostAmount = QuerySelection.ExtraDirectCostAmount;
					ReallocatedExtraDirectCostTaxAmount = QuerySelection.ExtraDirectCostTaxAmount;
					
					ReallocatedAllocatedCostAmount       = QuerySelection.AllocatedCostAmount;
					ReallocatedAllocatedCostTaxAmount    = QuerySelection.AllocatedCostTaxAmount;

					ReallocatedAllocatedRevenueAmount    = QuerySelection.AllocatedRevenueAmount;
					ReallocatedAllocatedRevenueTaxAmount = QuerySelection.AllocatedRevenueTaxAmount;
					
					ReallocatedQuantity  = QuerySelection.Quantity;
				EndIf;
			EndIf;

			If NewRow.Quantity = ReallocatedQuantity Then
				NewRow.InvoiceAmount    = ReallocatedInvoiceAmount;
				NewRow.InvoiceTaxAmount = ReallocatedInvoiceTaxAmount;
				
				NewRow.IndirectCostAmount  = ReallocatedIndirectCostAmount;
				NewRow.IndirectCostTaxAmount  = ReallocatedIndirectCostTaxAmount;
				
				NewRow.ExtraCostAmountByRatio = ReallocatedExtraCostAmountByRatio;
				NewRow.ExtraCostTaxAmountByRatio = ReallocatedExtraCostTaxAmountByRatio;
				
				NewRow.ExtraDirectCostAmount = ReallocatedExtraDirectCostAmount;
				NewRow.ExtraDirectCostTaxAmount = ReallocatedExtraDirectCostTaxAmount;
				
				NewRow.AllocatedCostAmount       = ReallocatedAllocatedCostAmount;
				NewRow.AllocatedCostTaxAmount    = ReallocatedAllocatedCostTaxAmount;
			
				NewRow.AllocatedRevenueAmount    = ReallocatedAllocatedRevenueAmount;
				NewRow.AllocatedRevenueTaxAmount = ReallocatedAllocatedRevenueTaxAmount;
			Else
				If ReallocatedQuantity <> 0 Then
					NewRow.InvoiceAmount = NewRow.Quantity * (ReallocatedInvoiceAmount / ReallocatedQuantity);
					NewRow.InvoiceTaxAmount = NewRow.Quantity * (ReallocatedInvoiceTaxAmount / ReallocatedQuantity);
					
					NewRow.IndirectCostAmount  = NewRow.Quantity * (ReallocatedIndirectCostAmount  / ReallocatedQuantity);
					NewRow.IndirectCostTaxAmount  = NewRow.Quantity * (ReallocatedIndirectCostTaxAmount  / ReallocatedQuantity);
					
					NewRow.ExtraCostAmountByRatio = NewRow.Quantity * (ReallocatedExtraCostAmountByRatio / ReallocatedQuantity);
					NewRow.ExtraCostTaxAmountByRatio = NewRow.Quantity * (ReallocatedExtraCostTaxAmountByRatio / ReallocatedQuantity);
					
					NewRow.ExtraDirectCostAmount = NewRow.Quantity * (ReallocatedExtraDirectCostAmount / ReallocatedQuantity);
					NewRow.ExtraDirectCostTaxAmount = NewRow.Quantity * (ReallocatedExtraDirectCostTaxAmount / ReallocatedQuantity);
										
					NewRow.AllocatedCostAmount       = NewRow.Quantity * (ReallocatedAllocatedCostAmount       / ReallocatedQuantity);
					NewRow.AllocatedCostTaxAmount    = NewRow.Quantity * (ReallocatedAllocatedCostTaxAmount    / ReallocatedQuantity);
					
					NewRow.AllocatedRevenueAmount    = NewRow.Quantity * (ReallocatedAllocatedRevenueAmount    / ReallocatedQuantity);
					NewRow.AllocatedRevenueTaxAmount = NewRow.Quantity * (ReallocatedAllocatedRevenueTaxAmount / ReallocatedQuantity);
				Else
					NewRow.InvoiceAmount = 0;
					NewRow.InvoiceTaxAmount = 0;
					
					NewRow.IndirectCostAmount  = 0;
					NewRow.IndirectCostTaxAmount  = 0;
					
					NewRow.ExtraCostAmountByRatio = 0;
					NewRow.ExtraCostTaxAmountByRatio = 0;
					
					NewRow.ExtraDirectCostAmount = 0;
					NewRow.ExtraDirectCostTaxAmount = 0;
					
					NewRow.AllocatedCostAmount       = 0;
					NewRow.AllocatedCostTaxAmount    = 0;
					
					NewRow.AllocatedRevenueAmount    = 0;
					NewRow.AllocatedRevenueTaxAmount = 0;
				EndIf;
			EndIf;

			NewRowReceivedBatch = TableOfNewReceivedBatches.Add();
			NewRowReceivedBatch.Batch            = NewRow.Batch;
			NewRowReceivedBatch.BatchKey         = NewRow.BatchKey;
			NewRowReceivedBatch.Document         = NewRow.Document;
			NewRowReceivedBatch.Company          = NewRow.Company;
			NewRowReceivedBatch.Date             = NewRow.Period;
			NewRowReceivedBatch.Quantity         = NewRow.Quantity;
			
			NewRowReceivedBatch.InvoiceAmount           = NewRow.InvoiceAmount;
			NewRowReceivedBatch.InvoiceTaxAmount        = NewRow.InvoiceTaxAmount;
			
			NewRowReceivedBatch.IndirectCostAmount   = NewRow.IndirectCostAmount;
			NewRowReceivedBatch.IndirectCostTaxAmount   = NewRow.IndirectCostTaxAmount;
			
			NewRowReceivedBatch.ExtraCostAmountByRatio  = NewRow.ExtraCostAmountByRatio;
			NewRowReceivedBatch.ExtraCostTaxAmountByRatio  = NewRow.ExtraCostTaxAmountByRatio;
			
			NewRowReceivedBatch.ExtraDirectCostAmount  = NewRow.ExtraDirectCostAmount;
			NewRowReceivedBatch.ExtraDirectCostTaxAmount  = NewRow.ExtraDirectCostTaxAmount;
			
			NewRowReceivedBatch.AllocatedCostAmount       = NewRow.AllocatedCostAmount;
			NewRowReceivedBatch.AllocatedCostTaxAmount    = NewRow.AllocatedCostTaxAmount;
			
			NewRowReceivedBatch.AllocatedRevenueAmount    = NewRow.AllocatedRevenueAmount;
			NewRowReceivedBatch.AllocatedRevenueTaxAmount = NewRow.AllocatedRevenueTaxAmount;
			
			NewRowReceivedBatch.QuantityBalance  = NewRow.Quantity;
			
			NewRowReceivedBatch.InvoiceAmountBalance    = NewRow.InvoiceAmount;
			NewRowReceivedBatch.InvoiceTaxAmountBalance = NewRow.InvoiceTaxAmount;
			
			NewRowReceivedBatch.IndirectCostAmountBalance  = NewRow.IndirectCostAmount;
			NewRowReceivedBatch.IndirectCostTaxAmountBalance  = NewRow.IndirectCostTaxAmount;
			
			NewRowReceivedBatch.ExtraCostAmountByRatioBalance = NewRow.ExtraCostAmountByRatio;
			NewRowReceivedBatch.ExtraCostTaxAmountByRatioBalance = NewRow.ExtraCostTaxAmountByRatio;
			
			NewRowReceivedBatch.ExtraDirectCostAmountBalance = NewRow.ExtraDirectCostAmount;
			NewRowReceivedBatch.ExtraDirectCostTaxAmountBalance = NewRow.ExtraDirectCostTaxAmount;
			
			NewRowReceivedBatch.AllocatedCostAmountBalance       = NewRow.AllocatedCostAmount;
			NewRowReceivedBatch.AllocatedCostTaxAmountBalance    = NewRow.AllocatedCostTaxAmount;
			
			NewRowReceivedBatch.AllocatedRevenueAmountBalance    = NewRow.AllocatedRevenueAmount;
			NewRowReceivedBatch.AllocatedRevenueTaxAmountBalance = NewRow.AllocatedRevenueTaxAmount;
			
			NewRowReceivedBatch.IsOpeningBalance = False;
			NewRowReceivedBatch.Direction        = Enums.BatchDirection.Receipt;
		EndDo;

		For Each Row In TableOfNewReceivedBatches Do
			FillPropertyValues(Rows.Add(), Row);
		EndDo;
		ArrayForDelete = New Array();
		For Each Row In Rows Do
			If Not ValueIsFilled(Row.InvoiceAmountBalance) Then
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
	|	ISNULL(SUM(T6080S_ReallocatedBatchesAmountValuesSliceLast.InvoiceAmount), 0) AS InvoiceAmount,
	|	ISNULL(SUM(T6080S_ReallocatedBatchesAmountValuesSliceLast.InvoiceTaxAmount), 0) AS InvoiceTaxAmount,
	|
	|	ISNULL(SUM(T6080S_ReallocatedBatchesAmountValuesSliceLast.IndirectCostAmount), 0) AS IndirectCostAmount,
	|	ISNULL(SUM(T6080S_ReallocatedBatchesAmountValuesSliceLast.IndirectCostTaxAmount), 0) AS IndirectCostTaxAmount,
	|
	|	ISNULL(SUM(T6080S_ReallocatedBatchesAmountValuesSliceLast.ExtraCostAmountByRatio), 0) AS ExtraCostAmountByRatio,
	|	ISNULL(SUM(T6080S_ReallocatedBatchesAmountValuesSliceLast.ExtraCostTaxAmountByRatio), 0) AS ExtraCostTaxAmountByRatio,
	|
	|	ISNULL(SUM(T6080S_ReallocatedBatchesAmountValuesSliceLast.ExtraDirectCostAmount), 0) AS ExtraDirectCostAmount,
	|	ISNULL(SUM(T6080S_ReallocatedBatchesAmountValuesSliceLast.ExtraDirectCostTaxAmount), 0) AS ExtraDirectCostTaxAmount,
	|
	|	ISNULL(SUM(T6080S_ReallocatedBatchesAmountValuesSliceLast.AllocatedCostAmount), 0) AS AllocatedCostAmount,
	|	ISNULL(SUM(T6080S_ReallocatedBatchesAmountValuesSliceLast.AllocatedCostTaxAmount), 0) AS AllocatedCostTaxAmount,
	|
	|	ISNULL(SUM(T6080S_ReallocatedBatchesAmountValuesSliceLast.AllocatedRevenueAmount), 0) AS AllocatedRevenueAmount,
	|	ISNULL(SUM(T6080S_ReallocatedBatchesAmountValuesSliceLast.AllocatedRevenueTaxAmount), 0) AS AllocatedRevenueTaxAmount,
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
	//@skip-check bsl-ql-hub
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
	Query = New Query;
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
				
				NeedReceipt = NeedReceipt - Row_Expense.Quantity;
				NewRow = Tables.DataForReceipt.Add();
				NewRow.Batch     = Row_Expense.Batch;
				NewRow.BatchKey  = Row.BatchKey;
				NewRow.Document  = Row.Document;
				NewRow.Company   = Row.Company;
				NewRow.Period    = Row.Date;
				NewRow.Quantity  = Row_Expense.Quantity;
				
				NewRow.InvoiceAmount    = Row_Expense.InvoiceAmount;
				NewRow.InvoiceTaxAmount = Row_Expense.InvoiceTaxAmount;
				
				NewRow.IndirectCostAmount  = Row_Expense.IndirectCostAmount;
				NewRow.IndirectCostTaxAmount  = Row_Expense.IndirectCostTaxAmount;
				
				NewRow.ExtraCostAmountByRatio = Row_Expense.ExtraCostAmountByRatio;
				NewRow.ExtraCostTaxAmountByRatio = Row_Expense.ExtraCostTaxAmountByRatio;
				
				NewRow.ExtraDirectCostAmount = Row_Expense.ExtraDirectCostAmount;
				NewRow.ExtraDirectCostTaxAmount = Row_Expense.ExtraDirectCostTaxAmount;
				
				NewRow.AllocatedCostAmount       = Row_Expense.AllocatedCostAmount;
				NewRow.AllocatedCostTaxAmount    = Row_Expense.AllocatedCostTaxAmount;
				
				NewRow.AllocatedRevenueAmount    = Row_Expense.AllocatedRevenueAmount;
				NewRow.AllocatedRevenueTaxAmount = Row_Expense.AllocatedRevenueTaxAmount;

				NewRowReceivedBatch = TableOfNewReceivedBatches.Add();
				NewRowReceivedBatch.Batch            = Row_Expense.Batch;
				NewRowReceivedBatch.BatchKey         = Row.BatchKey;
				NewRowReceivedBatch.Document         = Row.Document;
				NewRowReceivedBatch.Company          = Row.Company;
				NewRowReceivedBatch.Date             = Row.Date;
				NewRowReceivedBatch.Quantity         = Row_Expense.Quantity;
				
				NewRowReceivedBatch.InvoiceAmount           = Row_Expense.InvoiceAmount;
				NewRowReceivedBatch.InvoiceTaxAmount        = Row_Expense.InvoiceTaxAmount;
				
				NewRowReceivedBatch.IndirectCostAmount   = Row_Expense.IndirectCostAmount;
				NewRowReceivedBatch.IndirectCostTaxAmount   = Row_Expense.IndirectCostTaxAmount;
				
				NewRowReceivedBatch.ExtraCostAmountByRatio  = Row_Expense.ExtraCostAmountByRatio;
				NewRowReceivedBatch.ExtraCostTaxAmountByRatio  = Row_Expense.ExtraCostTaxAmountByRatio;
				
				NewRowReceivedBatch.ExtraDirectCostAmount  = Row_Expense.ExtraDirectCostAmount;
				NewRowReceivedBatch.ExtraDirectCostTaxAmount  = Row_Expense.ExtraDirectCostTaxAmount;
				
				NewRowReceivedBatch.AllocatedCostAmount       = Row_Expense.AllocatedCostAmount;
				NewRowReceivedBatch.AllocatedCostTaxAmount    = Row_Expense.AllocatedCostTaxAmount;
				
				NewRowReceivedBatch.AllocatedRevenueAmount    = Row_Expense.AllocatedRevenueAmount;
				NewRowReceivedBatch.AllocatedRevenueTaxAmount = Row_Expense.AllocatedRevenueTaxAmount;
				
				NewRowReceivedBatch.QuantityBalance  = Row_Expense.Quantity;
				
				NewRowReceivedBatch.InvoiceAmountBalance    = Row_Expense.InvoiceAmount;
				NewRowReceivedBatch.InvoiceTaxAmountBalance = Row_Expense.InvoiceTaxAmount;
				
				NewRowReceivedBatch.IndirectCostAmountBalance  = Row_Expense.IndirectCostAmount;
				NewRowReceivedBatch.IndirectCostTaxAmountBalance  = Row_Expense.IndirectCostTaxAmount;
				
				NewRowReceivedBatch.ExtraCostAmountByRatioBalance = Row_Expense.ExtraCostAmountByRatio;
				NewRowReceivedBatch.ExtraCostTaxAmountByRatioBalance = Row_Expense.ExtraCostTaxAmountByRatio;
				
				NewRowReceivedBatch.ExtraDirectCostAmountBalance = Row_Expense.ExtraDirectCostAmount;
				NewRowReceivedBatch.ExtraDirectCostTaxAmountBalance = Row_Expense.ExtraDirectCostTaxAmount;
				
				NewRowReceivedBatch.AllocatedCostAmountBalance       = Row_Expense.AllocatedCostAmount;
				NewRowReceivedBatch.AllocatedCostTaxAmountBalance    = Row_Expense.AllocatedCostTaxAmount;
				
				NewRowReceivedBatch.AllocatedRevenueAmountBalance    = Row_Expense.AllocatedRevenueAmount;
				NewRowReceivedBatch.AllocatedRevenueTaxAmountBalance = Row_Expense.AllocatedRevenueTaxAmount;
				
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
		If Not ValueIsFilled(Row.InvoiceAmountBalance) Then
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

		TotalExpenseInvoiceAmount    = DataForExpense.Total("InvoiceAmount");
		TotalExpenseInvoiceTaxAmount = DataForExpense.Total("InvoiceTaxAmount");
		
		TotalExpenseIndirectCostAmount  = DataForExpense.Total("IndirectCostAmount");
		TotalExpenseIndirectCostTaxAmount  = DataForExpense.Total("IndirectCostTaxAmount");
		
		TotalExpenseExtraCostAmountByRatio = DataForExpense.Total("ExtraCostAmountByRatio");
		TotalExpenseExtraCostTaxAmountByRatio = DataForExpense.Total("ExtraCostTaxAmountByRatio");
		
		TotalExpenseExtraDirectCostAmount = DataForExpense.Total("ExtraDirectCostAmount");
		TotalExpenseExtraDirectCostTaxAmount = DataForExpense.Total("ExtraDirectCostTaxAmount");
		
		TotalExpenseAllocatedCostAmount       = DataForExpense.Total("AllocatedCostAmount");
		TotalExpenseAllocatedCostTaxAmount    = DataForExpense.Total("AllocatedCostTaxAmount");
		
		TotalExpenseAllocatedRevenueAmount    = DataForExpense.Total("AllocatedRevenueAmount");
		TotalExpenseAllocatedRevenueTaxAmount = DataForExpense.Total("AllocatedRevenueTaxAmount");
				
		For Each Row_Expense In DataForExpense Do
			
			If ValueIsFilled(Row_Receipt.ItemLinkID) Then
				If Row_Receipt.ItemLinkID <> Row_Expense.ItemLinkID Then
					Continue;
				EndIf;
			EndIf;
			
			NewRow.InvoiceAmount    = NewRow.InvoiceAmount    + Row_Expense.InvoiceAmount;
			NewRow.InvoiceTaxAmount = NewRow.InvoiceTaxAmount + Row_Expense.InvoiceTaxAmount;
			
			NewRow.IndirectCostAmount  = NewRow.IndirectCostAmount  + Row_Expense.IndirectCostAmount;
			NewRow.IndirectCostTaxAmount  = NewRow.IndirectCostTaxAmount  + Row_Expense.IndirectCostTaxAmount;
			
			NewRow.ExtraCostAmountByRatio = NewRow.ExtraCostAmountByRatio + Row_Expense.ExtraCostAmountByRatio;
			NewRow.ExtraCostTaxAmountByRatio = NewRow.ExtraCostTaxAmountByRatio + Row_Expense.ExtraCostTaxAmountByRatio;
			
			NewRow.ExtraDirectCostAmount = NewRow.ExtraDirectCostAmount + Row_Expense.ExtraDirectCostAmount;
			NewRow.ExtraDirectCostTaxAmount = NewRow.ExtraDirectCostTaxAmount + Row_Expense.ExtraDirectCostTaxAmount;
			
			NewRow.AllocatedCostAmount       = NewRow.AllocatedCostAmount       + Row_Expense.AllocatedCostAmount;
			NewRow.AllocatedCostTaxAmount    = NewRow.AllocatedCostTaxAmount    + Row_Expense.AllocatedCostTaxAmount;
			
			NewRow.AllocatedRevenueAmount    = NewRow.AllocatedRevenueAmount    + Row_Expense.AllocatedRevenueAmount;
			NewRow.AllocatedRevenueTaxAmount = NewRow.AllocatedRevenueTaxAmount + Row_Expense.AllocatedRevenueTaxAmount;
			
			If TypeOf(Row_Expense.Document) = Type("DocumentRef.Bundling") Then
				NewRowBundleAmountValues = Tables.DataForBundleAmountValues.Add();
				NewRowBundleAmountValues.Batch          = Row_Expense.Batch;
				NewRowBundleAmountValues.BatchKey       = Row_Expense.BatchKey;
				NewRowBundleAmountValues.Company        = Row_Expense.Company;
				NewRowBundleAmountValues.Period         = Row_Expense.Period;
				NewRowBundleAmountValues.BatchKeyBundle = Row_Receipt.BatchKey;
								
				// InvoiceAmount
				If TotalExpenseInvoiceAmount <> 0 And Row_Expense.InvoiceAmount <> 0 Then
					NewRowBundleAmountValues.InvoiceAmount = Row_Expense.InvoiceAmount / (TotalExpenseInvoiceAmount / 100);
				EndIf;
				
				// InvoiceTaxAmount
				If TotalExpenseInvoiceTaxAmount <> 0 And Row_Expense.InvoiceTaxAmount <> 0 Then
					NewRowBundleAmountValues.InvoiceTaxAmount = Row_Expense.InvoiceTaxAmount / (TotalExpenseInvoiceTaxAmount / 100);
				EndIf;
				
				// IndirectCostAmount
				If TotalExpenseIndirectCostAmount <> 0 And Row_Expense.IndirectCostAmount <> 0 Then
					NewRowBundleAmountValues.IndirectCostAmount = Row_Expense.IndirectCostAmount / (TotalExpenseIndirectCostAmount / 100);
				EndIf;
				
				// IndirectCostTaxAmount
				If TotalExpenseIndirectCostTaxAmount <> 0 And Row_Expense.IndirectCostTaxAmount <> 0 Then
					NewRowBundleAmountValues.IndirectCostTaxAmount = Row_Expense.IndirectCostTaxAmount / (TotalExpenseIndirectCostTaxAmount / 100);
				EndIf;
				
				// ExtraCostAmountByRatio
				If TotalExpenseExtraCostAmountByRatio <> 0 And Row_Expense.ExtraCostAmountByRatio <> 0 Then
					NewRowBundleAmountValues.ExtraCostAmountByRatio = Row_Expense.ExtraCostAmountByRatio / (TotalExpenseExtraCostAmountByRatio / 100);
				EndIf;
				
				// ExtraCostTaxAmountByRatio
				If TotalExpenseExtraCostTaxAmountByRatio <> 0 And Row_Expense.ExtraCostTaxAmountByRatio <> 0 Then
					NewRowBundleAmountValues.ExtraCostTaxAmountByRatio = Row_Expense.ExtraCostTaxAmountByRatio / (TotalExpenseExtraCostTaxAmountByRatio / 100);
				EndIf;
				
				// ExtraDirectCostAmount
				If TotalExpenseExtraDirectCostAmount <> 0 And Row_Expense.ExtraDirectCostAmount <> 0 Then
					NewRowBundleAmountValues.ExtraDirectCostAmount = Row_Expense.ExtraDirectCostAmount / (TotalExpenseExtraDirectCostAmount / 100);
				EndIf;
				
				// ExtraDirectCostTaxAmount
				If TotalExpenseExtraDirectCostTaxAmount <> 0 And Row_Expense.ExtraDirectCostTaxAmount <> 0 Then
					NewRowBundleAmountValues.ExtraDirectCostTaxAmount = Row_Expense.ExtraDirectCostTaxAmount / (TotalExpenseExtraDirectCostTaxAmount / 100);
				EndIf;
								
				// AllocatedCostAmount
				If TotalExpenseAllocatedCostAmount <> 0 And Row_Expense.AllocatedCostAmount <> 0 Then
					NewRowBundleAmountValues.AllocatedCostAmount = Row_Expense.AllocatedCostAmount / (TotalExpenseAllocatedCostAmount / 100);
				EndIf;
				
				// AllocatedCostTaxAmount
				If TotalExpenseAllocatedCostTaxAmount <> 0 And Row_Expense.AllocatedCostTaxAmount <> 0 Then
					NewRowBundleAmountValues.AllocatedCostTaxAmount = Row_Expense.AllocatedCostTaxAmount / (TotalExpenseAllocatedCostTaxAmount / 100);
				EndIf;
								
				// AllocatedRevenueAmount
				If TotalExpenseAllocatedRevenueAmount <> 0 And Row_Expense.AllocatedRevenueAmount <> 0 Then
					NewRowBundleAmountValues.AllocatedRevenueAmount = Row_Expense.AllocatedRevenueAmount / (TotalExpenseAllocatedRevenueAmount / 100);
				EndIf;
				
				// AllocatedRevenueTaxAmount
				If TotalExpenseAllocatedRevenueTaxAmount <> 0 And Row_Expense.AllocatedRevenueTaxAmount <> 0 Then
					NewRowBundleAmountValues.AllocatedRevenueTaxAmount = Row_Expense.AllocatedRevenueTaxAmount / (TotalExpenseAllocatedRevenueTaxAmount / 100);
				EndIf;
				
			Else
				NewRowCompositeBatchesAmountValues = Tables.DataForCompositeBatchesAmountValues.Add();
				NewRowCompositeBatchesAmountValues.Batch     = Row_Expense.Batch;
				NewRowCompositeBatchesAmountValues.BatchKey  = Row_Expense.BatchKey;
				NewRowCompositeBatchesAmountValues.Company   = Row_Expense.Company;
				NewRowCompositeBatchesAmountValues.Period    = Row_Expense.Period;
				NewRowCompositeBatchesAmountValues.BatchComposite    = Row_Receipt.Batch;
				NewRowCompositeBatchesAmountValues.BatchKeyComposite = Row_Receipt.BatchKey;
				NewRowCompositeBatchesAmountValues.InvoiceAmount    = Row_Expense.InvoiceAmount;
				NewRowCompositeBatchesAmountValues.InvoiceTaxAmount = Row_Expense.InvoiceTaxAmount; 
				
				NewRowCompositeBatchesAmountValues.IndirectCostAmount  = Row_Expense.IndirectCostAmount;
				NewRowCompositeBatchesAmountValues.IndirectCostTaxAmount  = Row_Expense.IndirectCostTaxAmount;
				
				NewRowCompositeBatchesAmountValues.ExtraCostAmountByRatio = Row_Expense.ExtraCostAmountByRatio;
				NewRowCompositeBatchesAmountValues.ExtraCostTaxAmountByRatio = Row_Expense.ExtraCostTaxAmountByRatio;
				
				NewRowCompositeBatchesAmountValues.ExtraDirectCostAmount = Row_Expense.ExtraDirectCostAmount;
				NewRowCompositeBatchesAmountValues.ExtraDirectCostTaxAmount = Row_Expense.ExtraDirectCostTaxAmount;
				
				NewRowCompositeBatchesAmountValues.AllocatedCostAmount       = Row_Expense.AllocatedCostAmount;
				NewRowCompositeBatchesAmountValues.AllocatedCostTaxAmount    = Row_Expense.AllocatedCostTaxAmount;
				
				NewRowCompositeBatchesAmountValues.AllocatedRevenueAmount    = Row_Expense.AllocatedRevenueAmount;
				NewRowCompositeBatchesAmountValues.AllocatedRevenueTaxAmount = Row_Expense.AllocatedRevenueTaxAmount;
				
				NewRowCompositeBatchesAmountValues.Quantity  = Row_Expense.Quantity;
			EndIf;
		EndDo; // DataForExpense

		If TypeOf(Row_Receipt.Document) = Type("DocumentRef.Production") Then

			NewRow.ExtraDirectCostAmount    = NewRow.ExtraDirectCostAmount + Row_Receipt.Document.ExtraDirectCostAmount;
			NewRow.ExtraDirectCostTaxAmount = NewRow.ExtraDirectCostTaxAmount + Row_Receipt.Document.ExtraDirectCostTaxAmount;
			
			_ExtraCostAmountByRatio = Row_Receipt.Document.ExtraCostAmountByRatio;
			If _ExtraCostAmountByRatio <> 0 Then
				_totalAmount = 
					NewRow.InvoiceAmount 
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
					+NewRow.IndirectCostTaxAmount
					+NewRow.ExtraCostTaxAmountByRatio 
					+NewRow.ExtraDirectCostTaxAmount 
					+NewRow.AllocatedCostTaxAmount 
					+NewRow.AllocatedRevenueTaxAmount; 

                NewRow.ExtraCostTaxAmountByRatio = (_totalTaxAmount / 100 * _ExtraCostTaxAmountByRatio) + NewRow.ExtraCostTaxAmountByRatio;
			EndIf;	
		EndIf;
		
		NewRowReceivedBatch = TableOfNewReceivedBatches.Add();
		NewRowReceivedBatch.Batch            = NewRow.Batch;
		NewRowReceivedBatch.BatchKey         = NewRow.BatchKey;
		NewRowReceivedBatch.Document         = NewRow.Document;
		NewRowReceivedBatch.Company          = NewRow.Company;
		NewRowReceivedBatch.Date             = NewRow.Period;
		NewRowReceivedBatch.Quantity         = NewRow.Quantity;
		
		NewRowReceivedBatch.InvoiceAmount           = NewRow.InvoiceAmount;
		NewRowReceivedBatch.InvoiceTaxAmount        = NewRow.InvoiceTaxAmount;
		
		NewRowReceivedBatch.IndirectCostAmount   = NewRow.IndirectCostAmount;
		NewRowReceivedBatch.IndirectCostTaxAmount   = NewRow.IndirectCostTaxAmount;
		
		NewRowReceivedBatch.ExtraCostAmountByRatio  = NewRow.ExtraCostAmountByRatio;
		NewRowReceivedBatch.ExtraCostTaxAmountByRatio  = NewRow.ExtraCostTaxAmountByRatio;
		
		NewRowReceivedBatch.ExtraDirectCostAmount  = NewRow.ExtraDirectCostAmount;
		NewRowReceivedBatch.ExtraDirectCostTaxAmount  = NewRow.ExtraDirectCostTaxAmount;
		
		NewRowReceivedBatch.AllocatedCostAmount       = NewRow.AllocatedCostAmount;
		NewRowReceivedBatch.AllocatedCostTaxAmount    = NewRow.AllocatedCostTaxAmount;

		NewRowReceivedBatch.AllocatedRevenueAmount    = NewRow.AllocatedRevenueAmount;
		NewRowReceivedBatch.AllocatedRevenueTaxAmount = NewRow.AllocatedRevenueTaxAmount;
		
		NewRowReceivedBatch.QuantityBalance  = NewRow.Quantity;
		
		NewRowReceivedBatch.InvoiceAmountBalance    = NewRow.InvoiceAmount;
		NewRowReceivedBatch.InvoiceTaxAmountBalance = NewRow.InvoiceTaxAmount;
		
		NewRowReceivedBatch.IndirectCostAmountBalance  = NewRow.IndirectCostAmount;
		NewRowReceivedBatch.IndirectCostTaxAmountBalance  = NewRow.IndirectCostTaxAmount;
		
		NewRowReceivedBatch.ExtraCostAmountByRatioBalance = NewRow.ExtraCostAmountByRatio;
		NewRowReceivedBatch.ExtraCostTaxAmountByRatioBalance = NewRow.ExtraCostTaxAmountByRatio;
		
		NewRowReceivedBatch.ExtraDirectCostAmountBalance = NewRow.ExtraDirectCostAmount;
		NewRowReceivedBatch.ExtraDirectCostTaxAmountBalance = NewRow.ExtraDirectCostTaxAmount;
		
		NewRowReceivedBatch.AllocatedCostAmountBalance       = NewRow.AllocatedCostAmount;
		NewRowReceivedBatch.AllocatedCostTaxAmountBalance    = NewRow.AllocatedCostTaxAmount;
		
		NewRowReceivedBatch.AllocatedRevenueAmountBalance    = NewRow.AllocatedRevenueAmount;
		NewRowReceivedBatch.AllocatedRevenueTaxAmountBalance = NewRow.AllocatedRevenueTaxAmount;
		
		NewRowReceivedBatch.IsOpeningBalance = False;
		NewRowReceivedBatch.Direction        = Enums.BatchDirection.Receipt;

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
			Query = New Query();
			Query.Text =
			"SELECT
			|	DataForBundleAmountValues.BatchKey AS BatchKey,
			|	DataForBundleAmountValues.Company AS Company,
			|	DataForBundleAmountValues.BatchKeyBundle AS BatchKeyBundle,
			|	DataForBundleAmountValues.InvoiceAmount AS InvoiceAmount,
			|	DataForBundleAmountValues.InvoiceTaxAmount AS InvoiceTaxAmount,
			|
			|	DataForBundleAmountValues.IndirectCostAmount AS IndirectCostAmount,
			|	DataForBundleAmountValues.IndirectCostTaxAmount AS IndirectCostTaxAmount,
			|
			|	DataForBundleAmountValues.ExtraCostAmountByRatio AS ExtraCostAmountByRatio,
			|	DataForBundleAmountValues.ExtraCostTaxAmountByRatio AS ExtraCostTaxAmountByRatio,
			|
			|	DataForBundleAmountValues.ExtraDirectCostAmount AS ExtraDirectCostAmount,
			|	DataForBundleAmountValues.ExtraDirectCostTaxAmount AS ExtraDirectCostTaxAmount,
			|
			|	DataForBundleAmountValues.AllocatedCostAmount AS AllocatedCostAmount,
			|	DataForBundleAmountValues.AllocatedCostTaxAmount AS AllocatedCostTaxAmount,
			|
			|	DataForBundleAmountValues.AllocatedRevenueAmount AS AllocatedRevenueAmount,
			|	DataForBundleAmountValues.AllocatedRevenueTaxAmount AS AllocatedRevenueTaxAmount
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
			|	DataForBundleAmountValues.InvoiceAmount AS InvoiceAmount,
			|	DataForBundleAmountValues.InvoiceTaxAmount AS InvoiceTaxAmount,
			|
			|	DataForBundleAmountValues.IndirectCostAmount AS IndirectCostAmount,
			|	DataForBundleAmountValues.IndirectCostTaxAmount AS IndirectCostTaxAmount,
			|
			|	DataForBundleAmountValues.ExtraCostAmountByRatio AS ExtraCostAmountByRatio,
			|	DataForBundleAmountValues.ExtraCostTaxAmountByRatio AS ExtraCostTaxAmountByRatio,
			|
			|	DataForBundleAmountValues.ExtraDirectCostAmount AS ExtraDirectCostAmount,
			|	DataForBundleAmountValues.ExtraDirectCostTaxAmount AS ExtraDirectCostTaxAmount,
			|
			|	DataForBundleAmountValues.AllocatedCostAmount AS AllocatedCostAmount,
			|	DataForBundleAmountValues.AllocatedCostTaxAmount AS AllocatedCostTaxAmount,
			|
			|	DataForBundleAmountValues.AllocatedRevenueAmount AS AllocatedRevenueAmount,
			|	DataForBundleAmountValues.AllocatedRevenueTaxAmount AS AllocatedRevenueTaxAmount
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
			|	T6040S_BundleAmountValues.InvoiceAmount,
			|	T6040S_BundleAmountValues.InvoiceTaxAmount,
			|
			|	T6040S_BundleAmountValues.IndirectCostAmount,
			|	T6040S_BundleAmountValues.IndirectCostTaxAmount,
			|
			|	T6040S_BundleAmountValues.ExtraCostAmountByRatio,
			|	T6040S_BundleAmountValues.ExtraCostTaxAmountByRatio,
			|
			|	T6040S_BundleAmountValues.ExtraDirectCostAmount,
			|	T6040S_BundleAmountValues.ExtraDirectCostTaxAmount,
			|
			|	T6040S_BundleAmountValues.AllocatedCostAmount,
			|	T6040S_BundleAmountValues.AllocatedCostTaxAmount,
			|
			|	T6040S_BundleAmountValues.AllocatedRevenueAmount,
			|	T6040S_BundleAmountValues.AllocatedRevenueTaxAmount
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
			|	T6050S_ManualBundleAmountValues.InvoiceAmount,
			|	T6050S_ManualBundleAmountValues.InvoiceTaxAmount,
			|
			|	T6050S_ManualBundleAmountValues.IndirectCostAmount,
			|	T6050S_ManualBundleAmountValues.IndirectCostTaxAmount,
			|
			|	T6050S_ManualBundleAmountValues.ExtraCostAmountByRatio,
			|	T6050S_ManualBundleAmountValues.ExtraCostTaxAmountByRatio,
			|
			|	T6050S_ManualBundleAmountValues.ExtraDirectCostAmount,
			|	T6050S_ManualBundleAmountValues.ExtraDirectCostTaxAmount,
			|
			|	T6050S_ManualBundleAmountValues.AllocatedCostAmount,
			|	T6050S_ManualBundleAmountValues.AllocatedCostTaxAmount,
			|
			|	T6050S_ManualBundleAmountValues.AllocatedRevenueAmount,
			|	T6050S_ManualBundleAmountValues.AllocatedRevenueTaxAmount
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
				NewRow.InvoiceAmount = NewRow.InvoiceAmount + (Row_Expense.InvoiceAmount / 100 * QuerySelection.InvoiceAmount);
				NewRow.InvoiceTaxAmount = NewRow.InvoiceTaxAmount + (Row_Expense.InvoiceTaxAmount / 100 * QuerySelection.InvoiceTaxAmount);
				
				NewRow.IndirectCostAmount  = NewRow.IndirectCostAmount  + (Row_Expense.IndirectCostAmount  / 100 * QuerySelection.IndirectCostAmount);
				NewRow.IndirectCostTaxAmount  = NewRow.IndirectCostTaxAmount  + (Row_Expense.IndirectCostTaxAmount  / 100 * QuerySelection.IndirectCostTaxAmount);
				
				NewRow.ExtraCostAmountByRatio = NewRow.ExtraCostAmountByRatio + (Row_Expense.ExtraCostAmountByRatio / 100 * QuerySelection.ExtraCostAmountByRatio);
				NewRow.ExtraCostTaxAmountByRatio = NewRow.ExtraCostTaxAmountByRatio + (Row_Expense.ExtraCostTaxAmountByRatio / 100 * QuerySelection.ExtraCostTaxAmountByRatio);
				
				NewRow.ExtraDirectCostAmount = NewRow.ExtraDirectCostAmount + (Row_Expense.ExtraDirectCostAmount / 100 * QuerySelection.ExtraDirectCostAmount);
				NewRow.ExtraDirectCostTaxAmount = NewRow.ExtraDirectCostTaxAmount + (Row_Expense.ExtraDirectCostTaxAmount / 100 * QuerySelection.ExtraDirectCostTaxAmount);
				
				NewRow.AllocatedCostAmount       = NewRow.AllocatedCostAmount       + (Row_Expense.AllocatedCostAmount       / 100 * QuerySelection.AllocatedCostAmount);
				NewRow.AllocatedCostTaxAmount    = NewRow.AllocatedCostTaxAmount    + (Row_Expense.AllocatedCostTaxAmount    / 100 * QuerySelection.AllocatedCostTaxAmount);
				
				NewRow.AllocatedRevenueAmount    = NewRow.AllocatedRevenueAmount    + (Row_Expense.AllocatedRevenueAmount    / 100 * QuerySelection.AllocatedRevenueAmount);
				NewRow.AllocatedRevenueTaxAmount = NewRow.AllocatedRevenueTaxAmount + (Row_Expense.AllocatedRevenueTaxAmount / 100 * QuerySelection.AllocatedRevenueTaxAmount);
			EndDo;
		EndDo;

		NewRowReceivedBatch = TableOfNewReceivedBatches.Add();
		NewRowReceivedBatch.Batch            = NewRow.Batch;
		NewRowReceivedBatch.BatchKey         = NewRow.BatchKey;
		NewRowReceivedBatch.Document         = NewRow.Document;
		NewRowReceivedBatch.Company          = NewRow.Company;
		NewRowReceivedBatch.Date             = NewRow.Period;
		NewRowReceivedBatch.Quantity         = NewRow.Quantity;
		
		NewRowReceivedBatch.InvoiceAmount           = NewRow.InvoiceAmount;
		NewRowReceivedBatch.InvoiceTaxAmount        = NewRow.InvoiceTaxAmount;
		
		NewRowReceivedBatch.IndirectCostAmount   = NewRow.IndirectCostAmount;
		NewRowReceivedBatch.IndirectCostTaxAmount   = NewRow.IndirectCostTaxAmount;
		
		NewRowReceivedBatch.ExtraCostAmountByRatio  = NewRow.ExtraCostAmountByRatio;
		NewRowReceivedBatch.ExtraCostTaxAmountByRatio  = NewRow.ExtraCostTaxAmountByRatio;
		
		NewRowReceivedBatch.ExtraDirectCostAmount  = NewRow.ExtraDirectCostAmount;
		NewRowReceivedBatch.ExtraDirectCostTaxAmount  = NewRow.ExtraDirectCostTaxAmount;
		
		NewRowReceivedBatch.AllocatedCostAmount       = NewRow.AllocatedCostAmount;
		NewRowReceivedBatch.AllocatedCostTaxAmount    = NewRow.AllocatedCostTaxAmount;
		
		NewRowReceivedBatch.AllocatedRevenueAmount    = NewRow.AllocatedRevenueAmount;
		NewRowReceivedBatch.AllocatedRevenueTaxAmount = NewRow.AllocatedRevenueTaxAmount;
		
		NewRowReceivedBatch.QuantityBalance  = NewRow.Quantity;
		
		NewRowReceivedBatch.InvoiceAmountBalance    = NewRow.InvoiceAmount;
		NewRowReceivedBatch.InvoiceTaxAmountBalance = NewRow.InvoiceTaxAmount;
		
		NewRowReceivedBatch.IndirectCostAmountBalance  = NewRow.IndirectCostAmount;
		NewRowReceivedBatch.IndirectCostTaxAmountBalance  = NewRow.IndirectCostTaxAmount;
		
		NewRowReceivedBatch.ExtraCostAmountByRatioBalance = NewRow.ExtraCostAmountByRatio;
		NewRowReceivedBatch.ExtraCostTaxAmountByRatioBalance = NewRow.ExtraCostTaxAmountByRatio;
		
		NewRowReceivedBatch.ExtraDirectCostAmountBalance = NewRow.ExtraDirectCostAmount;
		NewRowReceivedBatch.ExtraDirectCostTaxAmountBalance = NewRow.ExtraDirectCostTaxAmount;
				
		NewRowReceivedBatch.AllocatedCostAmountBalance       = NewRow.AllocatedCostAmount;
		NewRowReceivedBatch.AllocatedCostTaxAmountBalance    = NewRow.AllocatedCostTaxAmount;
		
		NewRowReceivedBatch.AllocatedRevenueAmountBalance    = NewRow.AllocatedRevenueAmount;
		NewRowReceivedBatch.AllocatedRevenueTaxAmountBalance = NewRow.AllocatedRevenueTaxAmount;
		
		NewRowReceivedBatch.IsOpeningBalance = False;
		NewRowReceivedBatch.Direction        = Enums.BatchDirection.Receipt;
	EndDo;

	For Each Row In TableOfNewReceivedBatches Do
		FillPropertyValues(Rows.Add(), Row);
	EndDo;
	ArrayForDelete = New Array();
	For Each Row In Rows Do
		If Not ValueIsFilled(Row.InvoiceAmountBalance) Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each Row In ArrayForDelete Do
		Rows.Delete(Row);
	EndDo;
EndProcedure

Function GetSalesBatches(SalesInvoice, DataForSalesBatches, BatchKey)
	Query = New Query();
	//@skip-check bsl-ql-hub
	Query.Text =
	"SELECT
	|	DataForSalesBatches.Batch AS Batch,
	|	DataForSalesBatches.Period AS Date,
	|	DataForSalesBatches.BatchKey AS BatchKey,
	|	DataForSalesBatches.SalesInvoice AS SalesInvoice,
	|	DataForSalesBatches.Quantity AS Quantity,
	|	DataForSalesBatches.InvoiceAmount AS InvoiceAmount,
	|	DataForSalesBatches.InvoiceTaxAmount AS InvoiceTaxAmount,
	|
	|	DataForSalesBatches.IndirectCostAmount AS IndirectCostAmount,
	|	DataForSalesBatches.IndirectCostTaxAmount AS IndirectCostTaxAmount,
	|
	|	DataForSalesBatches.ExtraCostAmountByRatio AS ExtraCostAmountByRatio,
	|	DataForSalesBatches.ExtraCostTaxAmountByRatio AS ExtraCostTaxAmountByRatio,
	|
	|	DataForSalesBatches.ExtraDirectCostAmount AS ExtraDirectCostAmount,
	|	DataForSalesBatches.ExtraDirectCostTaxAmount AS ExtraDirectCostTaxAmount,
	|
	|	DataForSalesBatches.AllocatedCostAmount AS AllocatedCostAmount,
	|	DataForSalesBatches.AllocatedCostTaxAmount AS AllocatedCostTaxAmount,
	|
	|	DataForSalesBatches.AllocatedRevenueAmount AS AllocatedRevenueAmount,
	|	DataForSalesBatches.AllocatedRevenueTaxAmount AS AllocatedRevenueTaxAmount
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
	|	R6050T_SalesBatchesTurnovers.InvoiceAmountTurnover AS InvoiceAmount,
	|	R6050T_SalesBatchesTurnovers.InvoiceTaxAmountTurnover AS InvoiceTaxAmount,
	|
	|	R6050T_SalesBatchesTurnovers.IndirectCostAmountTurnover AS IndirectCostAmount,
	|	R6050T_SalesBatchesTurnovers.IndirectCostTaxAmountTurnover AS IndirectCostTaxAmount,
	|
	|	R6050T_SalesBatchesTurnovers.ExtraCostAmountByRatioTurnover AS ExtraCostAmountByRatio,
	|	R6050T_SalesBatchesTurnovers.ExtraCostTaxAmountByRatioTurnover AS ExtraCostTaxAmountByRatio,
	|
	|	R6050T_SalesBatchesTurnovers.ExtraDirectCostAmountTurnover AS ExtraDirectCostAmount,
	|	R6050T_SalesBatchesTurnovers.ExtraDirectCostTaxAmountTurnover AS ExtraDirectCostTaxAmount,
	|
	|	R6050T_SalesBatchesTurnovers.AllocatedCostAmountTurnover AS AllocatedCostAmount,
	|	R6050T_SalesBatchesTurnovers.AllocatedCostTaxAmountTurnover AS AllocatedCostTaxAmount,
	|
	|	R6050T_SalesBatchesTurnovers.AllocatedRevenueAmountTurnover AS AllocatedRevenueAmount,
	|	R6050T_SalesBatchesTurnovers.AllocatedRevenueTaxAmountTurnover AS AllocatedRevenueTaxAmount
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
	|	DataForSalesBatches.InvoiceAmount AS InvoiceAmount,
	|	DataForSalesBatches.InvoiceTaxAmount AS InvoiceTaxAmount,
	|
	|	DataForSalesBatches.IndirectCostAmount AS IndirectCostAmount,
	|	DataForSalesBatches.IndirectCostTaxAmount AS IndirectCostTaxAmount,
	|
	|	DataForSalesBatches.ExtraCostAmountByRatio AS ExtraCostAmountByRatio,
	|	DataForSalesBatches.ExtraCostTaxAmountByRatio AS ExtraCostTaxAmountByRatio,
	|
	|	DataForSalesBatches.ExtraDirectCostAmount AS ExtraDirectCostAmount,
	|	DataForSalesBatches.ExtraDirectCostTaxAmount AS ExtraDirectCostTaxAmount,
	|
	|	DataForSalesBatches.AllocatedCostAmount AS AllocatedCostAmount,
	|	DataForSalesBatches.AllocatedCostTaxAmount AS AllocatedCostTaxAmount,
	|
	|	DataForSalesBatches.AllocatedRevenueAmount AS AllocatedRevenueAmount,
	|	DataForSalesBatches.AllocatedRevenueTaxAmount AS AllocatedRevenueTaxAmount,
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
	|	SalesBatches.InvoiceAmount,
	|	SalesBatches.InvoiceTaxAmount,
	|
	|	SalesBatches.IndirectCostAmount,
	|	SalesBatches.IndirectCostTaxAmount,
	|
	|	SalesBatches.ExtraCostAmountByRatio,
	|	SalesBatches.ExtraCostTaxAmountByRatio,
	|
	|	SalesBatches.ExtraDirectCostAmount,
	|	SalesBatches.ExtraDirectCostTaxAmount,
	|
	|	SalesBatches.AllocatedCostAmount,
	|	SalesBatches.AllocatedCostTaxAmount,
	|
	|	SalesBatches.AllocatedRevenueAmount,
	|	SalesBatches.AllocatedRevenueTaxAmount,
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
	|	SUM(AllData.InvoiceAmount) AS InvoiceAmount,
	|	SUM(AllData.InvoiceTaxAmount) AS InvoiceTaxAmount,
	|
	|	SUM(AllData.IndirectCostAmount) AS IndirectCostAmount,
	|	SUM(AllData.IndirectCostTaxAmount) AS IndirectCostTaxAmount,
	|
	|	SUM(AllData.ExtraCostAmountByRatio) AS ExtraCostAmountByRatio,
	|	SUM(AllData.ExtraCostTaxAmountByRatio) AS ExtraCostTaxAmountByRatio,
	|
	|	SUM(AllData.ExtraDirectCostAmount) AS ExtraDirectCostAmount,
	|	SUM(AllData.ExtraDirectCostTaxAmount) AS ExtraDirectCostTaxAmount,
	|
	|	SUM(AllData.AllocatedCostAmount) AS AllocatedCostAmount,
	|	SUM(AllData.AllocatedCostTaxAmount) AS AllocatedCostTaxAmount,
	|
	|	SUM(AllData.AllocatedRevenueAmount) AS AllocatedRevenueAmount,
	|	SUM(AllData.AllocatedRevenueTaxAmount) AS AllocatedRevenueTaxAmount,
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

