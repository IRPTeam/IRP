#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	Tables = New Structure();
	
	Tables.Insert("ChequeBondStatuses", New ValueTable());
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	ChequeBondTransactionChequeBonds.Cheque AS Cheque,
		|	ChequeBondTransactionChequeBonds.NewStatus AS Status,
		|	ChequeBondTransactionChequeBonds.Ref.Date AS Date
		|FROM
		|	Document.ChequeBondTransaction.ChequeBonds AS ChequeBondTransactionChequeBonds
		|WHERE
		|	ChequeBondTransactionChequeBonds.Ref = &Ref";
	
	Query.SetParameter("Ref", Ref);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable.Cheque AS Cheque,
		|	QueryTable.Status AS Status,
		|	QueryTable.Date AS Period
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Cheque,
		|	tmp.Status,
		|	tmp.Period
		|FROM
		|	tmp AS tmp";
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResults = Query.ExecuteBatch();
	
	Tables.ChequeBondStatuses = QueryResults[1].Unload();
	
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// ChequeBondStatuses
	Fields = New Map();
	Fields.Insert("Cheque", "Cheque");
	DataMapWithLockFields.Insert("InformationRegister.ChequeBondStatuses",
		New Structure("Fields, Data", Fields, DocumentDataTables.ChequeBondStatuses));
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// ChequeBondStatuses
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ChequeBondStatuses,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.ChequeBondStatuses,
			Parameters.IsReposting));
	
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;	
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;	
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;	
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;	
EndProcedure

#EndRegion

