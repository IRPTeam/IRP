
Procedure BatchBalance_Clear(DocObjectRef, Cancel) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	R6020B_BatchBalance.Recorder
	|FROM
	|	AccumulationRegister.R6020B_BatchBalance AS R6020B_BatchBalance
	|WHERE
	|	R6020B_BatchBalance.CalculationMovementCost = &CalculationMovementCost
	|GROUP BY
	|	R6020B_BatchBalance.Recorder";
	Query.SetParameter("CalculationMovementCost", DocObjectRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		RecordSet = CreateRecordSet();
		RecordSet.Filter.Recorder.Set(QuerySelection.Recorder);
		RecordSet.Read();
		ArrayForDelete = New Array();
		For Each Row In RecordSet Do
			If Row.CalculationMovementCost = DocObjectRef Then
				ArrayForDelete.Add(Row);
			EndIf;
		EndDo;
		For Each ItemForDelete In ArrayForDelete Do
			RecordSet.Delete(ItemForDelete);
		EndDo;
		RecordSet.Write();
	EndDo;
EndProcedure

Procedure BatchBalance_CollectRecords(DocObject) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	R6010B_BatchWiseBalance.Period AS Period,
	|	R6010B_BatchWiseBalance.RecordType AS RecordType,
	|	R6010B_BatchWiseBalance.Quantity AS Quantity,
	|	R6010B_BatchWiseBalance.Batch AS Batch,
	|	R6010B_BatchWiseBalance.BatchKey AS BatchKey,
	|	R6010B_BatchWiseBalance.BatchKey.ItemKey AS ItemKey,
	|	R6010B_BatchWiseBalance.BatchKey.Store AS Store,
	|	R6010B_BatchWiseBalance.Batch.Company AS Company,
	|
	// Inventory origin
	|	case 
	|	when R6010B_BatchWiseBalance.Batch.Document refs Document.PurchaseInvoice then
	|		case when R6010B_BatchWiseBalance.Batch.Document.TransactionType = value(Enum.PurchaseTransactionTypes.ReceiptFromConsignor) then
	|		value(Enum.InventoryOriginTypes.ConsignorStocks)		
	|		else value(Enum.InventoryOriginTypes.OwnStocks) end
	|
	|	when R6010B_BatchWiseBalance.Batch.Document refs Document.OpeningEntry then
	|		case when Not R6010B_BatchWiseBalance.Batch.Document.PartnerConsignor.Ref is null then
	|		value(Enum.InventoryOriginTypes.ConsignorStocks)
	|		else value(Enum.InventoryOriginTypes.OwnStocks) end
	|
	|	else value(Enum.InventoryOriginTypes.OwnStocks) 
	|	end as InventoryOrigin,
	|
	// Partner
	|	case 
	|	when R6010B_BatchWiseBalance.Batch.Document refs Document.PurchaseInvoice then
	|		case when R6010B_BatchWiseBalance.Batch.Document.TransactionType = value(Enum.PurchaseTransactionTypes.ReceiptFromConsignor) then
	|		R6010B_BatchWiseBalance.Batch.Document.Partner		
	|		else Undefined end
	|
	|	when R6010B_BatchWiseBalance.Batch.Document refs Document.OpeningEntry then
	|		case when Not R6010B_BatchWiseBalance.Batch.Document.PartnerConsignor.Ref is null then
	|		R6010B_BatchWiseBalance.Batch.Document.PartnerConsignor
	|		else Undefined end
	|
	|	else value(Enum.InventoryOriginTypes.OwnStocks) 
	|	end as Partner,
	// Agreement
	|	case 
	|	when R6010B_BatchWiseBalance.Batch.Document refs Document.PurchaseInvoice then
	|		case when R6010B_BatchWiseBalance.Batch.Document.TransactionType = value(Enum.PurchaseTransactionTypes.ReceiptFromConsignor) then
	|		R6010B_BatchWiseBalance.Batch.Document.Agreement		
	|		else Undefined end
	|
	|	when R6010B_BatchWiseBalance.Batch.Document refs Document.OpeningEntry then
	|		case when Not R6010B_BatchWiseBalance.Batch.Document.PartnerConsignor.Ref is null then
	|		R6010B_BatchWiseBalance.Batch.Document.AgreementConsignor
	|		else Undefined end
	|
	|	else value(Enum.InventoryOriginTypes.OwnStocks) 
	|	end as Agreement,
	// Legal name
	|	case 
	|	when R6010B_BatchWiseBalance.Batch.Document refs Document.PurchaseInvoice then
	|		case when R6010B_BatchWiseBalance.Batch.Document.TransactionType = value(Enum.PurchaseTransactionTypes.ReceiptFromConsignor) then
	|		R6010B_BatchWiseBalance.Batch.Document.LegalName		
	|		else Undefined end
	|
	|	when R6010B_BatchWiseBalance.Batch.Document refs Document.OpeningEntry then
	|		case when Not R6010B_BatchWiseBalance.Batch.Document.PartnerConsignor.Ref is null then
	|		R6010B_BatchWiseBalance.Batch.Document.LegalNameConsignor
	|		else Undefined end
	|
	|	else value(Enum.InventoryOriginTypes.OwnStocks) 
	|	end as LegalName,
	// Serial lot number, source of origin
	|	R6010B_BatchWiseBalance.BatchKey.SerialLotNumber AS SerialLotNumber,
	|	R6010B_BatchWiseBalance.BatchKey.SourceOfOrigin AS SourceOfOrigin,
	
	|	R6010B_BatchWiseBalance.Recorder AS CalculationMovementCost,
	|	R6010B_BatchWiseBalance.Amount AS Amount,
	|	R6010B_BatchWiseBalance.AmountTax AS AmountTax,
	|	R6010B_BatchWiseBalance.NotDirectCosts AS NotDirectCosts,
	|	R6010B_BatchWiseBalance.AmountCostRatio AS AmountCostRatio,
	|	R6010B_BatchWiseBalance.AmountCost AS AmountCost,
	|	R6010B_BatchWiseBalance.AmountCostTax AS AmountCostTax,
	|	R6010B_BatchWiseBalance.AmountRevenue AS AmountRevenue,
	|	R6010B_BatchWiseBalance.AmountRevenueTax AS AmountRevenueTax
	|FROM
	|	AccumulationRegister.R6010B_BatchWiseBalance AS R6010B_BatchWiseBalance
	|WHERE
	|	R6010B_BatchWiseBalance.Document = &Document
	|
	|UNION ALL
	|
	|SELECT
	|	R6030T_BatchShortageOutgoing.Period,
	|	VALUE(AccumulationRecordType.Expense),
	|	R6030T_BatchShortageOutgoing.Quantity,
	|	VALUE(Enum.BatchType.BatchShortageOutgoing),
	|	R6030T_BatchShortageOutgoing.BatchKey,
	|	R6030T_BatchShortageOutgoing.BatchKey.ItemKey,
	|	R6030T_BatchShortageOutgoing.BatchKey.Store,
	|	R6030T_BatchShortageOutgoing.Company,
	|	value(Enum.InventoryOriginTypes.OwnStocks),
	|	Undefined,
	|	Undefined,
	|	Undefined,
	|	R6030T_BatchShortageOutgoing.BatchKey.SerialLotNumber,
	|	R6030T_BatchShortageOutgoing.BatchKey.SourceOfOrigin,
	|	R6030T_BatchShortageOutgoing.Recorder,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0.
	|	0
	|FROM
	|	AccumulationRegister.R6030T_BatchShortageOutgoing AS R6030T_BatchShortageOutgoing
	|WHERE
	|	R6030T_BatchShortageOutgoing.Document = &Document
	|
	|UNION ALL
	|
	|SELECT
	|	R6040T_BatchShortageIncoming.Period,
	|	VALUE(AccumulationRecordType.Receipt),
	|	R6040T_BatchShortageIncoming.Quantity,
	|	VALUE(Enum.BatchType.BatchShortageIncoming),
	|	R6040T_BatchShortageIncoming.BatchKey,
	|	R6040T_BatchShortageIncoming.BatchKey.ItemKey,
	|	R6040T_BatchShortageIncoming.BatchKey.Store,
	|	R6040T_BatchShortageIncoming.Company,
	|	value(Enum.InventoryOriginTypes.OwnStocks),
	|	Undefined,
	|	Undefined,
	|	Undefined,
	|	R6040T_BatchShortageIncoming.BatchKey.SerialLotNumber,
	|	R6040T_BatchShortageIncoming.BatchKey.SourceOfOrigin,
	|	R6040T_BatchShortageIncoming.Recorder,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0.
	|	0
	|FROM
	|	AccumulationRegister.R6040T_BatchShortageIncoming AS R6040T_BatchShortageIncoming
	|WHERE
	|	R6040T_BatchShortageIncoming.Document = &Document";
	Query.SetParameter("Document", DocObject.Ref);
	QueryResult = Query.Execute();
	DocObject.RegisterRecords.R6020B_BatchBalance.Load(QueryResult.Unload());
EndProcedure

Procedure BatchBalance_LoadRecords(CalculationMovementCostRef) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	R6010B_BatchWiseBalance.Document AS Document
	|INTO AllDocumetsGrouped
	|FROM
	|	AccumulationRegister.R6010B_BatchWiseBalance AS R6010B_BatchWiseBalance
	|WHERE
	|	R6010B_BatchWiseBalance.Recorder = &Recorder
	|
	|GROUP BY
	|	R6010B_BatchWiseBalance.Document
	|
	|UNION
	|
	|SELECT
	|	R6030T_BatchShortageOutgoing.Document
	|FROM
	|	AccumulationRegister.R6030T_BatchShortageOutgoing AS R6030T_BatchShortageOutgoing
	|WHERE
	|	R6030T_BatchShortageOutgoing.Recorder = &Recorder
	|
	|UNION
	|
	|SELECT
	|	R6040T_BatchShortageIncoming.Document
	|FROM
	|	AccumulationRegister.R6040T_BatchShortageIncoming AS R6040T_BatchShortageIncoming
	|WHERE
	|	R6040T_BatchShortageIncoming.Recorder = &Recorder
	|
	|INDEX BY
	|	Document
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R6010B_BatchWiseBalance.Period AS Period,
	|	R6010B_BatchWiseBalance.Recorder AS CalculationMovementCosts,
	|	R6010B_BatchWiseBalance.RecordType AS RecordType,
	|	R6010B_BatchWiseBalance.Document AS Document,
	|	R6010B_BatchWiseBalance.Quantity AS Quantity,
	|	R6010B_BatchWiseBalance.Amount AS Amount,
	|	R6010B_BatchWiseBalance.AmountTax AS AmountTax,
	|	R6010B_BatchWiseBalance.NotDirectCosts AS NotDirectCosts,
	|	R6010B_BatchWiseBalance.AmountCostRatio AS AmountCostRatio,
	|	R6010B_BatchWiseBalance.AmountCost AS AmountCost,
	|	R6010B_BatchWiseBalance.AmountCostTax AS AmountCostTax,
	|
	|	R6010B_BatchWiseBalance.AmountRevenue AS AmountRevenue,
	|	R6010B_BatchWiseBalance.AmountRevenueTax AS AmountRevenueTax,
	|
	|	R6010B_BatchWiseBalance.Batch AS Batch,
	|	R6010B_BatchWiseBalance.BatchKey AS BatchKey,
	|	R6010B_BatchWiseBalance.BatchKey.ItemKey AS ItemKey,
	|	R6010B_BatchWiseBalance.BatchKey.Store AS Store,
	|	R6010B_BatchWiseBalance.Batch.Company AS Company,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Batch.Document REFS Document.PurchaseInvoice
	|			THEN CASE
	|					WHEN R6010B_BatchWiseBalance.Batch.Document.TransactionType = VALUE(Enum.PurchaseTransactionTypes.ReceiptFromConsignor)
	|						THEN VALUE(Enum.InventoryOriginTypes.ConsignorStocks)
	|					ELSE VALUE(Enum.InventoryOriginTypes.OwnStocks)
	|				END
	|		WHEN R6010B_BatchWiseBalance.Batch.Document REFS Document.OpeningEntry
	|			THEN CASE
	|					WHEN NOT R6010B_BatchWiseBalance.Batch.Document.PartnerConsignor.Ref IS NULL
	|						THEN VALUE(Enum.InventoryOriginTypes.ConsignorStocks)
	|					ELSE VALUE(Enum.InventoryOriginTypes.OwnStocks)
	|				END
	|		ELSE VALUE(Enum.InventoryOriginTypes.OwnStocks)
	|	END AS InventoryOrigin,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Batch.Document REFS Document.PurchaseInvoice
	|			THEN CASE
	|					WHEN R6010B_BatchWiseBalance.Batch.Document.TransactionType = VALUE(Enum.PurchaseTransactionTypes.ReceiptFromConsignor)
	|						THEN R6010B_BatchWiseBalance.Batch.Document.Partner
	|					ELSE UNDEFINED
	|				END
	|		WHEN R6010B_BatchWiseBalance.Batch.Document REFS Document.OpeningEntry
	|			THEN CASE
	|					WHEN NOT R6010B_BatchWiseBalance.Batch.Document.PartnerConsignor.Ref IS NULL
	|						THEN R6010B_BatchWiseBalance.Batch.Document.PartnerConsignor
	|					ELSE UNDEFINED
	|				END
	|		ELSE VALUE(Enum.InventoryOriginTypes.OwnStocks)
	|	END AS Partner,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Batch.Document REFS Document.PurchaseInvoice
	|			THEN CASE
	|					WHEN R6010B_BatchWiseBalance.Batch.Document.TransactionType = VALUE(Enum.PurchaseTransactionTypes.ReceiptFromConsignor)
	|						THEN R6010B_BatchWiseBalance.Batch.Document.Agreement
	|					ELSE UNDEFINED
	|				END
	|		WHEN R6010B_BatchWiseBalance.Batch.Document REFS Document.OpeningEntry
	|			THEN CASE
	|					WHEN NOT R6010B_BatchWiseBalance.Batch.Document.PartnerConsignor.Ref IS NULL
	|						THEN R6010B_BatchWiseBalance.Batch.Document.AgreementConsignor
	|					ELSE UNDEFINED
	|				END
	|		ELSE VALUE(Enum.InventoryOriginTypes.OwnStocks)
	|	END AS Agreement,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Batch.Document REFS Document.PurchaseInvoice
	|			THEN CASE
	|					WHEN R6010B_BatchWiseBalance.Batch.Document.TransactionType = VALUE(Enum.PurchaseTransactionTypes.ReceiptFromConsignor)
	|						THEN R6010B_BatchWiseBalance.Batch.Document.LegalName
	|					ELSE UNDEFINED
	|				END
	|		WHEN R6010B_BatchWiseBalance.Batch.Document REFS Document.OpeningEntry
	|			THEN CASE
	|					WHEN NOT R6010B_BatchWiseBalance.Batch.Document.PartnerConsignor.Ref IS NULL
	|						THEN R6010B_BatchWiseBalance.Batch.Document.LegalNameConsignor
	|					ELSE UNDEFINED
	|				END
	|		ELSE VALUE(Enum.InventoryOriginTypes.OwnStocks)
	|	END AS LegalName,
	|	R6010B_BatchWiseBalance.BatchKey.SerialLotNumber AS SerialLotNumber,
	|	R6010B_BatchWiseBalance.BatchKey.SourceOfOrigin AS SourceOfOrigin
	|INTO BatchBalance
	|FROM
	|	AccumulationRegister.R6010B_BatchWiseBalance AS R6010B_BatchWiseBalance
	|		INNER JOIN AllDocumetsGrouped AS AllDocumetsGrouped
	|		ON R6010B_BatchWiseBalance.Document = AllDocumetsGrouped.Document
	|
	|UNION ALL
	|
	|SELECT
	|	R6030T_BatchShortageOutgoing.Period,
	|	R6030T_BatchShortageOutgoing.Recorder,
	|	VALUE(AccumulationRecordType.Expense),
	|	R6030T_BatchShortageOutgoing.Document,
	|	R6030T_BatchShortageOutgoing.Quantity,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|
	|	0,
	|	0,
	|
	|	VALUE(Enum.BatchType.BatchShortageOutgoing),
	|	R6030T_BatchShortageOutgoing.BatchKey,
	|	R6030T_BatchShortageOutgoing.BatchKey.ItemKey,
	|	R6030T_BatchShortageOutgoing.BatchKey.Store,
	|	R6030T_BatchShortageOutgoing.Company,
	|	VALUE(Enum.InventoryOriginTypes.OwnStocks),
	|	UNDEFINED,
	|	UNDEFINED,
	|	UNDEFINED,
	|	R6030T_BatchShortageOutgoing.BatchKey.SerialLotNumber,
	|	R6030T_BatchShortageOutgoing.BatchKey.SourceOfOrigin
	|FROM
	|	AccumulationRegister.R6030T_BatchShortageOutgoing AS R6030T_BatchShortageOutgoing
	|		INNER JOIN AllDocumetsGrouped AS AllDocumetsGrouped
	|		ON (AllDocumetsGrouped.Document = R6030T_BatchShortageOutgoing.Document)
	|
	|UNION ALL
	|
	|SELECT
	|	R6040T_BatchShortageIncoming.Period,
	|	R6040T_BatchShortageIncoming.Recorder,
	|	VALUE(AccumulationRecordType.Receipt),
	|	R6040T_BatchShortageIncoming.Document,
	|	R6040T_BatchShortageIncoming.Quantity,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|
	|	0,
	|	0,
	|
	|	VALUE(Enum.BatchType.BatchShortageIncoming),
	|	R6040T_BatchShortageIncoming.BatchKey,
	|	R6040T_BatchShortageIncoming.BatchKey.ItemKey,
	|	R6040T_BatchShortageIncoming.BatchKey.Store,
	|	R6040T_BatchShortageIncoming.Company,
	|	VALUE(Enum.InventoryOriginTypes.OwnStocks),
	|	UNDEFINED,
	|	UNDEFINED,
	|	UNDEFINED,
	|	R6040T_BatchShortageIncoming.BatchKey.SerialLotNumber,
	|	R6040T_BatchShortageIncoming.BatchKey.SourceOfOrigin
	|FROM
	|	AccumulationRegister.R6040T_BatchShortageIncoming AS R6040T_BatchShortageIncoming
	|		INNER JOIN AllDocumetsGrouped AS AllDocumetsGrouped
	|		ON (AllDocumetsGrouped.Document = R6040T_BatchShortageIncoming.Document)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchBalance.Period AS Period,
	|	BatchBalance.CalculationMovementCosts AS CalculationMovementCosts,
	|	BatchBalance.RecordType AS RecordType,
	|	BatchBalance.Document AS Document,
	|	BatchBalance.Quantity AS Quantity,
	|	BatchBalance.Amount AS Amount,
	|	BatchBalance.AmountTax AS AmountTax,
	|	BatchBalance.NotDirectCosts AS NotDirectCosts,
	|	BatchBalance.AmountCostRatio AS AmountCostRatio,
	|	BatchBalance.AmountCost AS AmountCost,
	|	BatchBalance.AmountCostTax AS AmountCostTax,
	|
	|	BatchBalance.AmountRevenue AS AmountRevenue,
	|	BatchBalance.AmountRevenueTax AS AmountRevenueTax,
	|
	|	BatchBalance.Batch AS Batch,
	|	BatchBalance.BatchKey AS BatchKey,
	|	BatchBalance.ItemKey AS ItemKey,
	|	BatchBalance.Store AS Store,
	|	BatchBalance.Company AS Company,
	|	BatchBalance.InventoryOrigin AS InventoryOrigin,
	|	BatchBalance.Partner AS Partner,
	|	BatchBalance.Agreement AS Agreement,
	|	BatchBalance.LegalName AS LegalName,
	|	BatchBalance.SerialLotNumber AS SerialLotNumber,
	|	BatchBalance.SourceOfOrigin AS SourceOfOrigin
	|FROM
	|	BatchBalance AS BatchBalance
	|TOTALS BY
	|	Document";
	Query.SetParameter("Recorder", CalculationMovementCostRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select(QueryResultIteration.ByGroups);
	While QuerySelection.Next() Do
		If Not ValueIsFilled(QuerySelection.Document) Then
			Continue;
		EndIf;
		RecordSet = CreateRecordSet();
		RecordSet.Filter.Recorder.Set(QuerySelection.Document);
		QuerySelectionDetails = QuerySelection.Select();
		While QuerySelectionDetails.Next() Do
			NewRecord = RecordSet.Add();
			FillPropertyValues(NewRecord, QuerySelectionDetails);
			NewRecord.Recorder = QuerySelection.Document;
			NewRecord.Period = QuerySelectionDetails.Period;
			NewRecord.RecordType = QuerySelectionDetails.RecordType;
			NewRecord.CalculationMovementCost = QuerySelectionDetails.CalculationMovementCosts;
		EndDo;
		RecordSet.Write();
	EndDo;
EndProcedure