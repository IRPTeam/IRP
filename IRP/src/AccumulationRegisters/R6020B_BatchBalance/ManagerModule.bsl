
Procedure BatchBalance_Clear(DocObjectRef, Cancel) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	LC_BatchBalance.Recorder
	|FROM
	|	AccumulationRegister.LC_BatchBalance AS LC_BatchBalance
	|WHERE
	|	LC_BatchBalance.CalculationMovementCost = &CalculationMovementCost
	|GROUP BY
	|	LC_BatchBalance.Recorder";
	Query.SetParameter("CalculationMovementCost", DocObjectRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		RecordSet = AccumulationRegisters.LC_BatchBalance.CreateRecordSet();
		RecordSet.Filter.Recorder.Set(QuerySelection.Recorder);
		//
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
		//
		//RecordSet.Clear();
		RecordSet.Write();
	EndDo;
EndProcedure

Procedure BatchBalance_CollectRecords(DocObject) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	LC_BatchWiseBalance.Period AS Period,
	|	LC_BatchWiseBalance.RecordType AS RecordType,
	|	LC_BatchWiseBalance.Quantity AS Quantity,
	|	LC_BatchWiseBalance.Batch AS Batch,
	|	LC_BatchWiseBalance.BatchKey AS BatchKey,
	|	LC_BatchWiseBalance.BatchKey.ItemKey AS ItemKey,
	|	LC_BatchWiseBalance.BatchKey.Store AS Store,
	|	LC_BatchWiseBalance.Batch.Company AS Company,
	|	LC_BatchWiseBalance.Recorder AS CalculationMovementCost,
	|   LC_BatchWiseBalance.Amount AS Amount,
	|	LC_BatchWiseBalance.AmountCost AS AmountCost
	|FROM
	|	AccumulationRegister.LC_BatchWiseBalance AS LC_BatchWiseBalance
	|WHERE
	|	LC_BatchWiseBalance.Document = &Document
	|
	|UNION ALL
	|
	|SELECT
	|	LC_BatchShortageOutgoing.Period,
	|	VALUE(AccumulationRecordType.Expense),
	|	LC_BatchShortageOutgoing.Quantity,
	|	VALUE(Enum.LC_BatchType.BatchShortageOutgoing),
	|	LC_BatchShortageOutgoing.BatchKey,
	|	LC_BatchShortageOutgoing.BatchKey.ItemKey,
	|	LC_BatchShortageOutgoing.BatchKey.Store,
	|	LC_BatchShortageOutgoing.Company,
	|	LC_BatchShortageOutgoing.Recorder,
	|	0,
	|	0
	|FROM
	|	AccumulationRegister.LC_BatchShortageOutgoing AS LC_BatchShortageOutgoing
	|WHERE
	|	LC_BatchShortageOutgoing.Document = &Document
	|
	|UNION ALL
	|
	|SELECT
	|	LC_BatchShortageIncoming.Period,
	|	VALUE(AccumulationRecordType.Receipt),
	|	LC_BatchShortageIncoming.Quantity,
	|	VALUE(Enum.LC_BatchType.BatchShortageIncoming),
	|	LC_BatchShortageIncoming.BatchKey,
	|	LC_BatchShortageIncoming.BatchKey.ItemKey,
	|	LC_BatchShortageIncoming.BatchKey.Store,
	|	LC_BatchShortageIncoming.Company,
	|	LC_BatchShortageIncoming.Recorder,
	|	0,
	|	0
	|FROM
	|	AccumulationRegister.LC_BatchShortageIncoming AS LC_BatchShortageIncoming
	|WHERE
	|	LC_BatchShortageIncoming.Document = &Document";
	Query.SetParameter("Document", DocObject.Ref);
	QueryResult = Query.Execute();
	DocObject.RegisterRecords.LC_BatchBalance.Load(QueryResult.Unload());
EndProcedure

Procedure BatchBalance_LoadRecords(CalculationMovementCostRef) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	LC_BatchWiseBalance.Document AS Document
	|INTO AllDocumetsGrouped
	|FROM
	|	AccumulationRegister.LC_BatchWiseBalance AS LC_BatchWiseBalance
	|WHERE
	|	LC_BatchWiseBalance.Recorder = &Recorder
	|
	|GROUP BY
	|	LC_BatchWiseBalance.Document
	|
	|UNION
	|
	|SELECT
	|	LC_BatchShortageOutgoing.Document
	|FROM
	|	AccumulationRegister.LC_BatchShortageOutgoing AS LC_BatchShortageOutgoing
	|WHERE
	|	LC_BatchShortageOutgoing.Recorder = &Recorder
	|
	|UNION
	|
	|SELECT
	|	LC_BatchShortageIncoming.Document
	|FROM
	|	AccumulationRegister.LC_BatchShortageIncoming AS LC_BatchShortageIncoming
	|WHERE
	|	LC_BatchShortageIncoming.Recorder = &Recorder
	|
	|INDEX BY
	|	Document
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	LC_BatchWiseBalance.Period AS Period,
	//
	|   LC_BatchWiseBalance.Recorder AS CalculationMovementCosts,
	//
	|	LC_BatchWiseBalance.RecordType AS RecordType,
	|	LC_BatchWiseBalance.Document AS Document,
	|	LC_BatchWiseBalance.Quantity AS Quantity,
	|	LC_BatchWiseBalance.Amount AS Amount,
	|	LC_BatchWiseBalance.AmountCost AS AmountCost,
	|	LC_BatchWiseBalance.Batch AS Batch,
	|	LC_BatchWiseBalance.BatchKey AS BatchKey,
	|	LC_BatchWiseBalance.BatchKey.ItemKey AS ItemKey,
	|	LC_BatchWiseBalance.BatchKey.Store AS Store,
	|	LC_BatchWiseBalance.Batch.Company AS Company
	|INTO BatchBalance
	|FROM
	|	AccumulationRegister.LC_BatchWiseBalance AS LC_BatchWiseBalance
	|		INNER JOIN AllDocumetsGrouped AS AllDocumetsGrouped
	|		ON LC_BatchWiseBalance.Document = AllDocumetsGrouped.Document
	|
	|UNION ALL
	|
	|SELECT
	|	LC_BatchShortageOutgoing.Period,
	//
	|   LC_BatchShortageOutgoing.Recorder,
	//
	|	VALUE(AccumulationRecordType.Expense),
	|	LC_BatchShortageOutgoing.Document,
	|	LC_BatchShortageOutgoing.Quantity,
	|	0,
	|	0,
	|	VALUE(Enum.LC_BatchType.BatchShortageOutgoing),
	|	LC_BatchShortageOutgoing.BatchKey,
	|	LC_BatchShortageOutgoing.BatchKey.ItemKey,
	|	LC_BatchShortageOutgoing.BatchKey.Store,
	|	LC_BatchShortageOutgoing.Company
	|FROM
	|	AccumulationRegister.LC_BatchShortageOutgoing AS LC_BatchShortageOutgoing
	|		INNER JOIN AllDocumetsGrouped AS AllDocumetsGrouped
	|		ON (AllDocumetsGrouped.Document = LC_BatchShortageOutgoing.Document)
	|
	|UNION ALL
	|
	|SELECT
	|	LC_BatchShortageIncoming.Period,
	//
	|   LC_BatchShortageIncoming.Recorder,
	//
	|	VALUE(AccumulationRecordType.Receipt),
	|	LC_BatchShortageIncoming.Document,
	|	LC_BatchShortageIncoming.Quantity,
	|	0,
	|	0,
	|	VALUE(Enum.LC_BatchType.BatchShortageIncoming),
	|	LC_BatchShortageIncoming.BatchKey,
	|	LC_BatchShortageIncoming.BatchKey.ItemKey,
	|	LC_BatchShortageIncoming.BatchKey.Store,
	|	LC_BatchShortageIncoming.Company
	|FROM
	|	AccumulationRegister.LC_BatchShortageIncoming AS LC_BatchShortageIncoming
	|		INNER JOIN AllDocumetsGrouped AS AllDocumetsGrouped
	|		ON (AllDocumetsGrouped.Document = LC_BatchShortageIncoming.Document)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchBalance.Period AS Period,
	//
	| 	BatchBalance.CalculationMovementCosts AS CalculationMovementCosts,
	//
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
	|TOTALS BY
	|	Document";
	Query.SetParameter("Recorder", CalculationMovementCostRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select(QueryResultIteration.ByGroups);
	While QuerySelection.Next() Do
		If Not ValueIsFilled(QuerySelection.Document) Then
			Continue;
		EndIf;
		RecordSet = AccumulationRegisters.LC_BatchBalance.CreateRecordSet();
		RecordSet.Filter.Recorder.Set(QuerySelection.Document);
		QuerySelectionDetails = QuerySelection.Select();
		While QuerySelectionDetails.Next() Do
			NewRecord = RecordSet.Add();
			FillPropertyValues(NewRecord, QuerySelectionDetails);
			NewRecord.Recorder = QuerySelection.Document;
			NewRecord.Period = QuerySelectionDetails.Period;
			NewRecord.RecordType = QuerySelectionDetails.RecordType;
			NewRecord.CalculationMovementCost = QuerySelectionDetails.CalculationMovementCosts;//CalculationMovementCostRef;
		EndDo;
		RecordSet.Write();
	EndDo;
EndProcedure