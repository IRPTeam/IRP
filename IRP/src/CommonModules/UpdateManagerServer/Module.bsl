
Function GetUpdateInfo() Export
	ArrayOfUpdateInfo = New Array();	
	UpdateManagerInitialServer.GetUpdateInfo(ArrayOfUpdateInfo);
	UpdateManagerReleaseServer.GetUpdateInfo(ArrayOfUpdateInfo);
	Return ArrayOfUpdateInfo;
EndFunction

Function GetUpdateInfoDefenition() Export
	Defenition = New Structure();
	Defenition.Insert("Method");
	Defenition.Insert("Description");
	Defenition.Insert("FullDescription");
	Return Defenition;
EndFunction

Procedure ApplieDatabaseUpdate(MethodName) Export
	RecordSet = InformationRegisters.AppliedDatabaseUpdates.CreateRecordSet();
	RecordSet.Filter.UpdateMethod.Set(MethodName);
	Record = RecordSet.Add();
	Record.UpdateMethod = MethodName;
	Record.AppliedDate = CurrentSessionDate();
	Record.ReleaseNumber = Metadata.Version;
	RecordSet.AdditionalProperties.Insert("SystemRecord", True);
	RecordSet.Write();
EndProcedure

Function GetUnappliedUpdates(MethodName = Undefined) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	AppliedDatabaseUpdates.UpdateMethod,
	|	AppliedDatabaseUpdates.AppliedDate,
	|	AppliedDatabaseUpdates.ReleaseNumber
	|FROM
	|	InformationRegister.AppliedDatabaseUpdates AS AppliedDatabaseUpdates
	|WHERE
	|	AppliedDatabaseUpdates.UpdateMethod IN (&UpdateMethods)";
	
	UpdateMethods = New Array();
	ArrayOfUpdateInfo = GetUpdateInfo();
	For Each Row In ArrayOfUpdateInfo Do
		If MethodName <> Undefined And Row.Method <> MethodName Then
			Continue;
		EndIf;
		UpdateMethods.Add(Row.Method);
	EndDo;
	
	Query.SetParameter("UpdateMethods", UpdateMethods);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	QuerySelection.Reset();
	
	Result = New Array();
	
	For Each Row In ArrayOfUpdateInfo Do
		If MethodName <> Undefined And Row.Method <> MethodName Then
			Continue;
		EndIf;
		
		ResultRow = New Structure("Method, Applied, AppliedDate, ReleaseNumber");
		ResultRow.Method = Row.Method;
		
		If QuerySelection.FindNext(New Structure("UpdateMethod", Row.Method)) Then
			ResultRow.Applied = True;
			ResultRow.AppliedDate   = QuerySelection.AppliedDate;
			ResultRow.ReleaseNumber = QuerySelection.ReleaseNumber;
		Else
			ResultRow.Applied = False;
			ResultRow.AppliedDate   = Undefined;
			ResultRow.ReleaseNumber = Undefined;	
		EndIf;
		Result.Add(ResultRow);
		QuerySelection.Reset();
	EndDo;
	Return Result;
EndFunction

Function NeedOpenForm_UpdateDataBase() Export
	If Metadata.Version <> Constants.LastReleaseNumber.Get() Then
		UnappliedUpdates = GetUnappliedUpdates();
		For Each Row In UnappliedUpdates Do
			If Row.Applied = False Then
				Return True;
			EndIf;
		EndDo;
	EndIf;
	Return False;
EndFunction
