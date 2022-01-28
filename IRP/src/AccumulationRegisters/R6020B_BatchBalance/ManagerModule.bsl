
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
		RecordSet = AccumulationRegisters.R6020B_BatchBalance.CreateRecordSet();
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
	|	R6010B_BatchWiseBalance.Recorder AS CalculationMovementCost,
	|	R6010B_BatchWiseBalance.Amount AS Amount,
	|	R6010B_BatchWiseBalance.AmountCost AS AmountCost
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
	|	R6030T_BatchShortageOutgoing.Recorder,
	|	0,
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
	|	R6040T_BatchShortageIncoming.Recorder,
	|	0,
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
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R6010B_BatchWiseBalance.Period AS Period,
	|	R6010B_BatchWiseBalance.Recorder AS CalculationMovementCosts,
	|	R6010B_BatchWiseBalance.RecordType AS RecordType,
	|	R6010B_BatchWiseBalance.Document AS Document,
	|	R6010B_BatchWiseBalance.Quantity AS Quantity,
	|	R6010B_BatchWiseBalance.Amount AS Amount,
	|	R6010B_BatchWiseBalance.AmountCost AS AmountCost,
	|	R6010B_BatchWiseBalance.Batch AS Batch,
	|	R6010B_BatchWiseBalance.BatchKey AS BatchKey,
	|	R6010B_BatchWiseBalance.BatchKey.ItemKey AS ItemKey,
	|	R6010B_BatchWiseBalance.BatchKey.Store AS Store,
	|	R6010B_BatchWiseBalance.Batch.Company AS Company
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
	|	VALUE(Enum.BatchType.BatchShortageOutgoing),
	|	R6030T_BatchShortageOutgoing.BatchKey,
	|	R6030T_BatchShortageOutgoing.BatchKey.ItemKey,
	|	R6030T_BatchShortageOutgoing.BatchKey.Store,
	|	R6030T_BatchShortageOutgoing.Company
	|FROM
	|	AccumulationRegister.R6030T_BatchShortageOutgoing AS R6030T_BatchShortageOutgoing
	|		INNER JOIN AllDocumetsGrouped AS AllDocumetsGrouped
	|		ON AllDocumetsGrouped.Document = R6030T_BatchShortageOutgoing.Document
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
	|	VALUE(Enum.BatchType.BatchShortageIncoming),
	|	R6040T_BatchShortageIncoming.BatchKey,
	|	R6040T_BatchShortageIncoming.BatchKey.ItemKey,
	|	R6040T_BatchShortageIncoming.BatchKey.Store,
	|	R6040T_BatchShortageIncoming.Company
	|FROM
	|	AccumulationRegister.R6040T_BatchShortageIncoming AS R6040T_BatchShortageIncoming
	|		INNER JOIN AllDocumetsGrouped AS AllDocumetsGrouped
	|		ON AllDocumetsGrouped.Document = R6040T_BatchShortageIncoming.Document
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchBalance.Period AS Period,
	|	BatchBalance.CalculationMovementCosts AS CalculationMovementCosts,
	|	BatchBalance.RecordType AS RecordType,
	|	BatchBalance.Document AS Document,
	|	BatchBalance.Quantity AS Quantity,
	|	BatchBalance.Amount AS Amount,
	|	BatchBalance.AmountCost AS AmountCost,
	|	BatchBalance.Batch AS Batch,
	|	BatchBalance.BatchKey AS BatchKey,
	|	BatchBalance.ItemKey AS ItemKey,
	|	BatchBalance.Store AS Store,
	|	BatchBalance.Company AS Company
	|FROM
	|	BatchBalance AS BatchBalance
	|TOTALS
	|BY
	|	Document";
	Query.SetParameter("Recorder", CalculationMovementCostRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select(QueryResultIteration.ByGroups);
	While QuerySelection.Next() Do
		If Not ValueIsFilled(QuerySelection.Document) Then
			Continue;
		EndIf;
		RecordSet = AccumulationRegisters.R6020B_BatchBalance.CreateRecordSet();
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