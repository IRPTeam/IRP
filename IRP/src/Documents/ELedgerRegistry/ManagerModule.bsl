// @strict-types

#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	Parameters.IsReposting = False;
	
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables; // Structure
	DataMapWithLockFields = New Map();

	PostingServer.GetLockDataSource(DataMapWithLockFields, DocumentDataTables);
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region Posting_Info

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", New Array);
	Str.Insert("QueryTextsSecondaryTables", New Array);
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure;
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

#EndRegion

#Region Posting_MainTables

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	PostingServer.GetLockDataSource(DataMapWithLockFields, DocumentDataTables);
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region CheckAfterWrite

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
	Return;
EndProcedure

#EndRegion

#Region AccessObject

Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	AccessKeyMap.Insert("Company", Obj.Company);
	Return AccessKeyMap;
EndFunction

#EndRegion

Function SetNumbers(Ref) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	JournalEntry.Ref
	|FROM
	|	Document.JournalEntry AS JournalEntry
	|WHERE
	|	JournalEntry.ELedgerRegistry = &ELedgerRegistry
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	JournalEntry.Ref
	|FROM
	|	Document.JournalEntry AS JournalEntry
	|WHERE
	|	NOT JournalEntry.DeletionMark
	|	AND JournalEntry.Company = &Company
	|	AND JournalEntry.LedgerType = &LedgerType
	|	AND JournalEntry.Date BETWEEN BEGINOFPERIOD(&BeginDate, DAY) AND ENDOFPERIOD(&EndDate, DAY)
	|
	|ORDER BY
	|	JournalEntry.PointInTime
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	MAX(JournalEntry.SequentalNumber) AS SequentalNumber
	|FROM
	|	Document.JournalEntry AS JournalEntry
	|WHERE
	|	JournalEntry.Company = &Company
	|	AND JournalEntry.LedgerType = &LedgerType
	|	AND JournalEntry.Date < BEGINOFPERIOD(&BeginDate, DAY)";
	Query.SetParameter("Company"         , Ref.Company);	
	Query.SetParameter("LedgerType"      , Ref.LedgerType);	
	Query.SetParameter("BeginDate"       , Ref.BeginDate);	
	Query.SetParameter("EndDate"         , Ref.EndDate);	
	Query.SetParameter("ELedgerRegistry" , Ref);
	
	QueryResults = Query.ExecuteBatch();
	
	QuerySelection = QueryResults[0].Select();
	While QuerySelection.Next() Do
		DocObject = QuerySelection.Ref.GetObject();
		DocObject.ELedgerRegistry = Undefined;
		DocObject.SequentalNumber = 0;
		CommonFunctionsClientServer.PutToAddInfo(DocObject.AdditionalProperties, "SetELedger", True);
		DocObject.Write();
	EndDo;
	
	SequentalNumber = 0;
	QuerySelection = QueryResults[2].Select();
	If QuerySelection.Next() And ValueIsFilled(QuerySelection.SequentalNumber) Then
		SequentalNumber = QuerySelection.SequentalNumber;
	EndIf;
	
	QuerySelection = QueryResults[1].Select();
	While QuerySelection.Next() Do
		DocObject = QuerySelection.Ref.GetObject();
		DocObject.ELedgerRegistry = Ref;
		SequentalNumber = SequentalNumber + 1;
		DocObject.SequentalNumber = SequentalNumber;
		CommonFunctionsClientServer.PutToAddInfo(DocObject.AdditionalProperties, "SetELedger", True);
		DocObject.Write();
	EndDo;
EndFunction









