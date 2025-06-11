
&AtServerNoContext
Procedure RestoreAllAtServer(SimpleBatchList = Undefined)
	Query = New Query;
	Query.Text =
		"SELECT
		|	SimpleBatchSeq.SimpleBatch AS SimpleBatch,
		|	MAX(SimpleBatchSeq.Recorder) AS PointInTime
		|INTO LastSeq
		|FROM
		|	Sequence.SimpleBatch AS SimpleBatchSeq
		|WHERE
		|	CASE
		|			WHEN &SimpleBatchSetFilter
		|				THEN SimpleBatchSeq.SimpleBatch IN (&SimpleBatch)
		|			ELSE TRUE
		|		END
		|
		|GROUP BY
		|	SimpleBatchSeq.SimpleBatch
		|
		|INDEX BY
		|	SimpleBatch,
		|	PointInTime
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SequenceSimpleBatchBoundaries.SimpleBatch AS SimpleBatch,
		|	SequenceSimpleBatchBoundaries.PointInTime AS PointInTime
		|INTO ProblemBatch
		|FROM
		|	LastSeq AS LastSeq
		|		LEFT JOIN Sequence.SimpleBatch.Boundaries AS SequenceSimpleBatchBoundaries
		|		ON (SequenceSimpleBatchBoundaries.SimpleBatch = LastSeq.SimpleBatch)
		|WHERE
		|	NOT SequenceSimpleBatchBoundaries.Recorder = LastSeq.PointInTime
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SimpleBatchAll.Recorder AS Recorder,
		|	SimpleBatchAll.SimpleBatch AS SimpleBatch
		|FROM
		|	ProblemBatch AS ProblemBatch
		|		LEFT JOIN Sequence.SimpleBatch AS SimpleBatchAll
		|		ON (ProblemBatch.SimpleBatch = SimpleBatchAll.SimpleBatch)
		|			AND (SimpleBatchAll.PointInTime > ProblemBatch.PointInTime)
		|WHERE
		|	NOT SimpleBatchAll.Recorder IS NULL
		|	AND  NOT SimpleBatchAll.SimpleBatch IS NULL
		|
		|ORDER BY
		|	SimpleBatchAll.PointInTime
		|TOTALS BY
		|	Recorder";
	Query.SetParameter("SimpleBatchSetFilter", Not SimpleBatchList = Undefined);
	Query.SetParameter("SimpleBatch", SimpleBatchList);
	RepostingTree = Query.Execute().Unload(QueryResultIteration.ByGroups);
	
	BatchWithErrors = New Array; 
	
	For Each Row In RepostingTree.Rows Do
		
		// Skipp All incomes
		If Not Sequences.SimpleBatch.BelongsTo(Row.Recorder) Then
			Continue;
		EndIf;
		
		Set = AccumulationRegisters.R6025B_SimpleBatch.CreateRecordSet();
		Set.Filter.Recorder.Set(Row.Recorder);
		Set.Read();
		CurrentMovement = Set.Unload();
		
		BatchForCheck = New Array;
		
		For Each BatchRow In Row.Rows Do
			// Skip batch where already was problem with calculation
			If Not BatchWithErrors.Find(BatchRow.SimpleBatch) = Undefined Then
				Continue;
			EndIf;
			
			BatchForCheck.Add(BatchRow.SimpleBatch);
		EndDo;

		// Mb all batch with problems
		If BatchForCheck.Count() = 0 Then
			Continue;
		EndIf;

		Cancel = False;
		Posting_R6025B = SimpleBatchCostCalculationServer.UpdateOutgoingMovementsCost(Row.Recorder, CurrentMovement, Cancel, BatchForCheck, BatchWithErrors);

		If Not Posting_R6025B = Undefined Then
			Set.Load(Posting_R6025B);
			Set.Write();
		EndIf;
		
	EndDo;
	
EndProcedure

&AtClient
Procedure RestoreAll(Command)
	RestoreAllAtServer();
	Items.List.Refresh();
EndProcedure

&AtClient
Procedure RestoreSelected(Command)
	SimpleBatchFilter = New Array;
	For Each Row In Items.List.SelectedRows Do
		SimpleBatchFilter.Add(Row);
	EndDo;
	RestoreAllAtServer(SimpleBatchFilter);
	Items.List.Refresh();
EndProcedure
