#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	
	If ValueIsFilled(Ref.PersonalSalary) And ValueIsFilled(Ref.AccrualType) And PostingMode <> Undefined Then
		WriteSelfRecords(Ref);
	EndIf;
	
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);

	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map;
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	ClearSelfRecords(Ref);
	Return PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
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

#Region Posting_Info

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
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
	QueryArray.Add(T9510S_Staffing());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

#EndRegion

#Region Posting_MainTables

Function T9510S_Staffing()
	Return
		"SELECT
		|	EmployeeHiring.Date AS Period,
		|	EmployeeHiring.Employee,
		|	EmployeeHiring.Company,
		|	EmployeeHiring.Branch,
		|	EmployeeHiring.Position,
		|	EmployeeHiring.EmployeeSchedule,
		|	EmployeeHiring.ProfitLossCenter
		|INTO T9510S_Staffing
		|FROM
		|	Document.EmployeeHiring AS EmployeeHiring
		|WHERE
		|	EmployeeHiring.Ref = &Ref";
EndFunction

#EndRegion

#Region AccessObject

// Get access key.
// 
// Parameters:
//  Obj - DocumentObjectDocumentName -
// 
// Returns:
//  Map
Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	AccessKeyMap.Insert("Company", Obj.Company);
	AccessKeyMap.Insert("Branch", Obj.Branch);
	Return AccessKeyMap;
EndFunction

#EndRegion

#Region Service

Procedure ClearSelfRecords(Ref)
	Query = New Query();
	Query.Text =
	"SELECT
	|	Table.EmployeeOrPosition,
	|	Table.AccualOrDeductionType,
	|	Table.Period
	|FROM
	|	InformationRegister.T9500S_AccrualAndDeductionValues AS Table
	|WHERE
	|	Table.EmployeeHiring = &EmployeeHiring";
	Query.SetParameter("EmployeeHiring", Ref);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	While QuerySelection.Next() Do
		RecordSet = InformationRegisters.T9500S_AccrualAndDeductionValues.CreateRecordSet();
		RecordSet.Filter.EmployeeOrPosition.Set(QuerySelection.EmployeeOrPosition);
		RecordSet.Filter.AccualOrDeductionType.Set(QuerySelection.AccualOrDeductionType);
		RecordSet.Filter.Period.Set(QuerySelection.Period);
		RecordSet.Clear();
		RecordSet.Write();
	EndDo;
EndProcedure

Procedure WriteSelfRecords(Ref)
	RecordSet = InformationRegisters.T9500S_AccrualAndDeductionValues.CreateRecordSet();
	RecordSet.Filter.EmployeeOrPosition.Set(Ref.Employee);
	RecordSet.Filter.AccualOrDeductionType.Set(Ref.AccrualType);
	NewRecord = RecordSet.Add();
	
	NewRecord.Period = Ref.Date;
	NewRecord.EmployeeOrPosition = Ref.Employee;
	NewRecord.AccualOrDeductionType = Ref.AccrualType;
	NewRecord.Value = Ref.PersonalSalary;
	NewRecord.EmployeeHiring = Ref;
	
	RecordSet.Write();
EndProcedure

#EndRegion



















