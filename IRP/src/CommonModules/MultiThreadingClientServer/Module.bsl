Function Settings(AddInfo = Undefined) Export
	Settings = New Structure();
	Settings.Insert("RowsInThread", 10);
	Return Settings;
EndFunction

#Region PutAndRegisterNewJob

Function PutJob(ExecutorName, DataCollection, Settings = Undefined, Description = "", AddInfo = Undefined) Export
	
	If Settings = Undefined Then
		Settings = Settings(AddInfo);
	EndIf;
	
	Token = New UUID();
	
	Args = New Array();
	Args.Add(Token);
	Args.Add(ExecutorName);
	Args.Add(DataCollection);
	Args.Add(Settings);
	Args.Add(Description);
	Args.Add(AddInfo);
	BackgroundJobs.Execute("MultiThreadingClientServer.RegisterNewJob", Args, String(Token), "New Job Registration");
	
	Return Token;
EndFunction

Procedure RegisterNewJob(Token, ExecutorName, DataCollection, Settings, Description, AddInfo = Undefined) Export
	WriteJobSettings(ExecutorName, Token, Settings, Description, AddInfo);
	DataParts = SeparateDate(DataCollection, Settings.RowsInThread, AddInfo);
	If Settings.RowsInThread > 0 And DataParts.Count() = 0 Then
		DataParts.Add(New Array());
	EndIf;
	WriteThreadsInfo(Token, DataParts, AddInfo);
EndProcedure

Function SeparateDate(DataCollection, RowsInThread, AddInfo = Undefined)
	IsValueTable = TypeOf(DataCollection) = Type("ValueTable");
	DataParts = New Array();
	Index = 0;
	CurrentPart = Undefined;
	For Each Row In DataCollection Do
		If Index = 0 Then
			CurrentPart = New Array();
			DataParts.Add(CurrentPart);
		EndIf;
		
		If IsValueTable Then
			Value = ValueTableRowToStructure(Row, AddInfo);
		Else
			Value = Row;
		EndIf;
		
		CurrentPart.Add(Value);
		
		If Index <= RowsInThread Then
			Index = Index + 1;
		Else
			Index = 0;
		EndIf;
	EndDo;
	Return DataParts;
EndFunction

Function ValueTableRowToStructure(Row, AddInfo = Undefined)
	Columns = Row.Owner().Columns;
	RowStructure = New Structure();
	For Each Column In Columns Do
		RowStructure.Insert(Column.Name, Row[Column.Name]);
	EndDo;
	Return RowStructure;
EndFunction

Procedure WriteJobSettings(ExecutorName, Token, Settings, Description, AddInfo = Undefined)
	RecordSet = InformationRegisters.JobSettings.CreateRecordSet();
	RecordSet.Filter.Token.Set(Token);
	Record = RecordSet.Add();
	Record.Token = Token;
	Record.Date = CurrentUniversalDate();
	Record.ExecutorName = ExecutorName;
	Record.Description = Description;
	JSON = SerializeToJSON(Settings);
	Record.Settings = New ValueStorage(JSON);
	Record.AddInfo = New ValueStorage(AddInfo);
	RecordSet.Write();
EndProcedure

Procedure WriteThreadsInfo(Token, DataParts, AddInfo = Undefined)
	RecordSet = InformationRegisters.ThreadsInfo.CreateRecordSet();
	RecordSet.Filter.Token.Set(Token);
	For Each Part In DataParts Do
		Record = RecordSet.Add();
		Record.Token = Token;
		Record.ThreadKey = New UUID();
		Record.State = Enums.ThreadState.Wait;
		Value = New ValueStorage(Part);
		Record.Value = Value;
		Record.InputValue = Value;
		Record.DatePut = CurrentUniversalDate();
	EndDo;
	RecordSet.Write();
EndProcedure

#EndRegion

#Region ThreadLaunch

Procedure LaunchNewThreads() Export
	
	ArrayOfActiveThreads = ActiveThreads();
	
	ArrayOfFailedThreads = MarkFailedThread(ArrayOfActiveThreads);
	
	CountThreadsForLaunch = MaximumThreads() - ArrayOfActiveThreads.Count() + ArrayOfFailedThreads.Count();
	
	ThreadsInfoTable = GetThreadsForLaunch(CountThreadsForLaunch);
	
	For Each ThreadInfo In ThreadsInfoTable Do
		LaunchThread(ThreadInfo.ThreadKey,
			ThreadInfo.ExecutorName,
			ThreadInfo.Value.Get(),
			ThreadInfo.AddInfo.Get());
	EndDo;
	
	
EndProcedure

Function MaximumThreads()
	Return Constants.MaximumThreads.Get();
EndFunction

Function ActiveThreads()
	Query = New Query();
	Query.Text =
		"SELECT
		|	ThreadsInfo.ThreadKey
		|FROM
		|	InformationRegister.ThreadsInfo AS ThreadsInfo
		|WHERE
		|	ThreadsInfo.State = VALUE(Enum.ThreadState.Active)";
	QueryResult = Query.Execute();
	ArrayOfActiveThreads = QueryResult.Unload().UnloadColumn("ThreadKey");
	Return ArrayOfActiveThreads;
EndFunction

Function MarkFailedThread(ArrayOfActiveThreads)
	ArrayOfFailedThreads = New Array();
	For Each ThreadKey In ArrayOfActiveThreads Do
		Filter = New Structure("Key", String(ThreadKey));
		ArrayOfThreads = BackgroundJobs.GetBackgroundJobs(Filter);
		If ArrayOfThreads.Count() Then
			Thread = ArrayOfThreads[0];
			If Thread.State <> BackgroundJobState.Active Then
				ErrorInfoDescription = "";
				If Thread.ErrorInfo <> Undefined Then
					ErrorInfoDescription = Thread.ErrorInfo.Description;
				EndIf;
				SetStateForThread(ThreadKey,
					Enums.ThreadState.Failed,
					StrTemplate(R().Error_038,
						String(Thread.State),
						String(Enums.ThreadState.Active),
						ErrorInfoDescription));
				ArrayOfFailedThreads.Add(ThreadKey);
			EndIf;
		Else
			SetStateForThread(ThreadKey, Enums.ThreadState.Failed, "Thread Not found");
			ArrayOfFailedThreads.Add(ThreadKey);
		EndIf;
	EndDo;
	Return ArrayOfFailedThreads;
EndFunction

Procedure SetStateForThread(ThreadKey, State, ErrorInfo = "", AddInfo = Undefined)
	RecordSet = InformationRegisters.ThreadsInfo.CreateRecordSet();
	RecordSet.Filter.ThreadKey.Set(ThreadKey);
	RecordSet.Read();
	Record = RecordSet[0];
	Record.State = State;
	
	If State = Enums.ThreadState.Failed
		Or State = Enums.ThreadState.Canceled
		Or State = Enums.ThreadState.Completed Then
		Record.DateFinish = CurrentUniversalDate();
	ElsIf State = Enums.ThreadState.Active Then
		Record.DateStart = CurrentUniversalDate();
	ElsIf State = Enums.ThreadState.Wait Then
		Record.DatePut = CurrentUniversalDate();
	EndIf;
	
	If ValueIsFilled(ErrorInfo) Then
		Record.ErrorInfo = ErrorInfo;
	EndIf;
	
	RecordSet.Write();
EndProcedure

Function GetThreadsForLaunch(CountThreads)
	Query = New Query();
	Query.Text =
		"SELECT TOP %1
		|	ThreadsInfo.Token,
		|	ThreadsInfo.ThreadKey,
		|	ThreadsInfo.Value,
		|	JobSettings.AddInfo,
		|	JobSettings.ExecutorName
		|FROM
		|	InformationRegister.ThreadsInfo AS ThreadsInfo
		|		LEFT JOIN InformationRegister.JobSettings AS JobSettings
		|		ON ThreadsInfo.Token = JobSettings.Token
		|WHERE
		|	ThreadsInfo.State = VALUE(Enum.ThreadState.Wait)
		|ORDER BY
		|	ThreadsInfo.DatePut";
	Query.Text = StrTemplate(Query.Text, CountThreads);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

Procedure LaunchThread(ThreadKey, ExecutorName, Data, AddInfo = Undefined)
	Args = New Array();
	Args.Add(ThreadKey);
	Args.Add(ExecutorName);
	Args.Add(Data);
	Args.Add(AddInfo);
	
	SetStateForThread(ThreadKey, Enums.ThreadState.Active, "", AddInfo);
	
	BackgroundJobs.Execute("MultiThreadingClientServer.ExecutorWrapper",
		Args,
		String(ThreadKey),
		ExecutorName);
	
EndProcedure

Procedure ExecutorWrapper(ThreadKey, ExecutorName, Data, AddInfo = Undefined) Export
	Args = New Array();
	Args.Add(Data);
	Args.Add(AddInfo);
	
	Result = ExecuteCustomMethod(ExecutorName, Args, AddInfo);
	
	RecordSet = InformationRegisters.ThreadsInfo.CreateRecordSet();
	RecordSet.Filter.ThreadKey.Set(ThreadKey);
	RecordSet.Read();
	Record = RecordSet[0];
	
	If Not Result.Success Then
		ArrayOfError = New Array();
		If ValueIsFilled(Record.ErrorInfo) Then
			ArrayOfError = DeserializeFromJSON(Record.ErrorInfo);
		EndIf;
		ArrayOfError.Add(Result.Value);
		Record.ErrorInfo = SerializeToJson(ArrayOfError);
		Record.State = Enums.ThreadState.Failed;
		Record.DateFinish = CurrentUniversalDate();
		RecordSet.Write();
		Raise Result.Value;
	Else
		Record.Value = New ValueStorage(Result.Value);
		Record.State = Enums.ThreadState.Completed;
		Record.DateFinish = CurrentUniversalDate();
		RecordSet.Write();
	EndIf;
	
EndProcedure

Function ExecuteCustomMethod(MethodPath, Val Args = Undefined, AddInfo = Undefined)
	Result = New Structure("Success, Value", True, Undefined);
	ArgsStr = "";
	If Args = Undefined Then
		Args = New Array();
	EndIf;
	For i = 0 To Args.Count() - 1 Do
		ArgsStr = ArgsStr + ?(ValueIsFilled(ArgsStr), " ,", "") + StrTemplate("Args[%1]", i);
	EndDo;
	
	Try
		Execute(StrTemplate("Result.Value = %1(%2)", MethodPath, ArgsStr));
	Except
		Result.Success = False;
		Result.Value = String(ErrorDescription());
	EndTry;
	// If CustomMethod use transaction, rollback failed transaction And open New transaction for ThreadInfo
	If Not Result.Success And TransactionActive() Then
		RollbackTransaction();
	EndIf;
	Return Result;
EndFunction

#EndRegion

#Region GetJobStatus

Function GetJobStatus(Token, AddInfo = Undefined) Export
	Result = New Structure("Status, Description", Undefined, "Job found");
	Query = New Query();
	Query.Text =
		"SELECT
		|	ThreadsInfo.State
		|FROM
		|	InformationRegister.ThreadsInfo AS ThreadsInfo
		|WHERE
		|	ThreadsInfo.Token = &Token
		|GROUP BY
		|	ThreadsInfo.State";
	Query.SetParameter("Token", Token);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	If FindThreadState(QueryTable, Enums.ThreadState.Failed, AddInfo).Success Then
		Result.Status = Enums.ThreadState.Failed;
		Return Result;
	ElsIf FindThreadState(QueryTable, Enums.ThreadState.Canceled, AddInfo).Success Then
		Result.Status = Enums.ThreadState.Canceled;
		Return Result;
	ElsIf FindThreadState(QueryTable, Enums.ThreadState.Active, AddInfo).Success Then
		Result.Status = Enums.ThreadState.Active;
		Return Result;
	ElsIf FindThreadState(QueryTable, Enums.ThreadState.Wait, AddInfo).Success Then
		Result.Status = Enums.ThreadState.Wait;
		Return Result;
	ElsIf FindThreadState(QueryTable, Enums.ThreadState.Completed).Success Then
		Result.Status = Enums.ThreadState.Completed;
		Return Result;
	EndIf;
	Result.Status = Undefined;
	Result.Description = R().Error_039;
	Return Result;
EndFunction

Function FindThreadState(Table, State, AddInfo = Undefined)
	Result = New Structure("Success", False);
	Filter = New Structure("State", State);
	Rows = Table.FindRows(Filter);
	If Rows.Count() Then
		Result.Success = True;
	EndIf;
	Return Result;
EndFunction

#EndRegion

Function SerializeToJson(Value)
	JSONWriter = New JSONWriter();
	JSONWriter.SetString();
	WriteJSON(JSONWriter, Value);
	JSON = JSONWriter.Close();
	Return JSON;
EndFunction

Function DeserializeFromJSON(JSON)
	JSONReader = New JSONReader();
	JSONReader.SetString(JSON);
	Value = ReadJSON(JSONReader);
	JSONReader.Close();
	Return Value;
EndFunction

