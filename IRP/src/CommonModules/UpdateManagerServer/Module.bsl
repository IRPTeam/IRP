
Function GetUpdateInfo() Export
	ArrayOfUpdateInfo = New Array();
	
	UpdateInfo = GetUpdateInfoDefenition();
	UpdateInfo.Method = "UpdateManagerServer.RunUpdate_UpdateSystemAttributes_Store";
	UpdateInfo.Description = R().Update_001;
	UpdateInfo.FullDescription = R().UpdateDesc_001;
	ArrayOfUpdateInfo.Add(UpdateInfo);
	
	UpdateInfo = GetUpdateInfoDefenition();
	UpdateInfo.Method = "UpdateManagerServer.RunUpdate_ItemType_StockBalanceDetail_SerialLotNumber";
	UpdateInfo.Description = R().Update_002;
	UpdateInfo.FullDescription = R().UpdateDesc_002;
	ArrayOfUpdateInfo.Add(UpdateInfo);
		
	UpdateInfo = GetUpdateInfoDefenition();
	UpdateInfo.Method = "UpdateManagerServer.RunUpdate_Update001";
	UpdateInfo.Description = R().Update_003;
	UpdateInfo.FullDescription = R().UpdateDesc_003;
	ArrayOfUpdateInfo.Add(UpdateInfo);
		
	Return ArrayOfUpdateInfo;
EndFunction

Function GetUpdateInfoDefenition()
	Defenition = New Structure();
	Defenition.Insert("Method");
	Defenition.Insert("Description");
	Defenition.Insert("FullDescription");
	Return Defenition;
EndFunction

Procedure ApplieDatabaseUpdate(MethodName)
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

#Region UPDATE_METHODS

Function RunUpdate_Update001() Export
	
	Errors = New Array();
	
	TotalCount = 1000;
	
	Msg = BackgroundJobAPIServer.NotifySettings();
	Msg.Log = "Start update item types: " + TotalCount;
	BackgroundJobAPIServer.NotifyStream(Msg);
	
	If TotalCount = 0 Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Return BackgroundJobAPIServer.JobAddErrorEmptyCollection(Msg, Errors, "No data for update: 0");
	EndIf;

	Msg = BackgroundJobAPIServer.NotifySettings();
	Msg.Log = "Start update item types: " + TotalCount;
	BackgroundJobAPIServer.NotifyStream(Msg);
	
	Count = 0; 
	LastPercentLogged = 0;
	JobStartDate = CurrentUniversalDateInMilliseconds();
	
	HaveErrors = False;
	
	For i= 0 to TotalCount Do
		Try
			// do somenthing
			
			// update 1
			
			// update 2
		Except
			ErrorDescription = ErrorProcessing.DetailErrorDescription(ErrorInfo());
			BackgroundJobAPIServer.JobAddErrorMessage(Msg, Errors, Undefined, ErrorDescription);
			HaveErrors = True;
			Break;
		EndTry;
		
		Count = Count + 1;
		BackgroundJobAPIServer.JobAddPercentMessage(Count, TotalCount, LastPercentLogged, JobStartDate);		
		
	EndDo;
	
	BackgroundJobAPIServer.JobAddEndMessage(Errors);
	
	If HaveErrors Then
		Raise "Job aborted";
	EndIf;
	
	If Errors.Count() = 0 Then
		ApplieDatabaseUpdate("UpdateManagerServer.RunUpdate_Update001");
	EndIf;
	
	Return Errors;

Endfunction

Function RunUpdate_UpdateSystemAttributes_Store() Export	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	SystemAttributesSets.Ref,
	|	SystemAttributesSets.PredefinedDataName
	|FROM
	|	Catalog.SystemAttributesSets AS SystemAttributesSets
	|WHERE
	|	NOT SystemAttributesSets.DeletionMark
	|	AND SystemAttributesSets.Predefined";
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	Errors = New Array();
	
	TotalCount = QuerySelection.Count();
	
	If TotalCount = 0 Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Return BackgroundJobAPIServer.JobAddErrorEmptyCollection(Msg, Errors, "No system attributes for update: 0");
	EndIf;

	Msg = BackgroundJobAPIServer.NotifySettings();
	Msg.Log = "Start update system attributes: " + TotalCount;
	BackgroundJobAPIServer.NotifyStream(Msg);
	
	Count = 0; 
	LastPercentLogged = 0;
	JobStartDate = CurrentUniversalDateInMilliseconds();
	
	HaveErrors = False;

	While QuerySelection.Next() Do
		Try
			NameSegments = StrSplit(QuerySelection.PredefinedDataName, "_");
			DocMetadataFullName = NameSegments[0] + "." + NameSegments[1];
			DocMetadataName = NameSegments[1];
			
			ArrayOfAttributes = SystemAttributesServer.GetSystemAttributes(DocMetadataFullName);
			
			QueryDoc = New Query();
			QueryDoc.Text = 
			"SELECT
			|	Doc.Ref
			|FROM
			|	Document.%1 AS Doc";
			QueryDoc.Text = StrTemplate(QueryDoc.Text, DocMetadataName);
			QueryDocResult = QueryDoc.Execute();
			QueryDocSelection = QueryDocResult.Select();
			
			While QueryDocSelection.Next() Do
			
				RecordSet = InformationRegisters.SystemAttributes.CreateRecordSet();
				RecordSet.Filter.Object.Set(QueryDocSelection.Ref);
		
				For Each Attr In ArrayOfAttributes Do
					Values = Documents[DocMetadataName].GetSystemAttributeValues(QueryDocSelection.Ref, Attr);
			
					If Values = Undefined Then
						Continue;
					EndIf;
				
					ValueTable = New ValueTable();
					ValueTable.Columns.Add("Value");
					For Each Value In Values Do
						ValueTable.Add().Value = Value;
					EndDo;
					ValueTable.GroupBy("Value");
					
					LineNumber = 1;
					For Each TableRow In ValueTable Do
						If Not ValueIsFilled(TableRow.Value) Then
							Continue;
						EndIf;
						Record = RecordSet.Add();
						Record.Object = QueryDocSelection.Ref;
						Record.Property = Attr;
						Record.Key = LineNumber;
						Record.Value = TableRow.Value;
						LineNumber = LineNumber + 1;
					EndDo;
				EndDo;
				RecordSet.AdditionalProperties.Insert("SystemRecord", True);
				RecordSet.Write();		
			EndDo;
		Except
			ErrorDescription = ErrorProcessing.DetailErrorDescription(ErrorInfo());
			BackgroundJobAPIServer.JobAddErrorMessage(Msg, Errors, Undefined, ErrorDescription);
			HaveErrors = True;
			Break;
		EndTry;
		
		Count = Count + 1;
		BackgroundJobAPIServer.JobAddPercentMessage(Count, TotalCount, LastPercentLogged, JobStartDate);		
		
	EndDo;
	
	BackgroundJobAPIServer.JobAddEndMessage(Errors);
	
	If HaveErrors Then
		Raise "Job aborted";
	EndIf;
	
	If Errors.Count() = 0 Then
		ApplieDatabaseUpdate("UpdateManagerServer.RunUpdate_UpdateSystemAttributes_Store");
	EndIf;
	
	Return Errors;
EndFunction

Function RunUpdate_ItemType_StockBalanceDetail_SerialLotNumber() Export	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ItemTypes.Ref
	|FROM
	|	Catalog.ItemTypes AS ItemTypes
	|WHERE
	|	NOT ItemTypes.DeletionMark";
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	Errors = New Array();
	
	TotalCount = QuerySelection.Count();
	
	Msg = BackgroundJobAPIServer.NotifySettings();
	Msg.Log = "Start update item types: " + TotalCount;
	BackgroundJobAPIServer.NotifyStream(Msg);
	
	If TotalCount = 0 Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Return BackgroundJobAPIServer.JobAddErrorEmptyCollection(Msg, Errors, "No data for update: 0");
	EndIf;

	Msg = BackgroundJobAPIServer.NotifySettings();
	Msg.Log = "Start update item types: " + TotalCount;
	BackgroundJobAPIServer.NotifyStream(Msg);
	
	Count = 0; 
	LastPercentLogged = 0;
	JobStartDate = CurrentUniversalDateInMilliseconds();
	
	HaveErrors = False;
	
	While QuerySelection.Next() Do
		Try
			Obj = QuerySelection.Ref.GetObject();
			Obj.DataExchange.Load = True;
			Obj.StockBalanceDetailSerialLotNumber = 
				(Obj.DELETE_StockBalanceDetail = Enums.DELETE_StockBalanceDetail.BySerialLotNumber);
			Obj.Write();
		Except
			ErrorDescription = ErrorProcessing.DetailErrorDescription(ErrorInfo());
			BackgroundJobAPIServer.JobAddErrorMessage(Msg, Errors, Undefined, ErrorDescription);
			HaveErrors = True;
			Break;
		EndTry;
		
		Count = Count + 1;
		BackgroundJobAPIServer.JobAddPercentMessage(Count, TotalCount, LastPercentLogged, JobStartDate);		
		
	EndDo;
	
	BackgroundJobAPIServer.JobAddEndMessage(Errors);
	
	If HaveErrors Then
		Raise "Job aborted";
	EndIf;
	
	If Errors.Count() = 0 Then
		ApplieDatabaseUpdate("UpdateManagerServer.RunUpdate_ItemType_StockBalanceDetail_SerialLotNumber");
	EndIf;
	
	Return Errors;
EndFunction

#EndRegion
