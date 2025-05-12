
Function GetUpdateInfo() Export
	ArrayOfUpdateInfo = New Array();
	
//	UpdateInfo = GetUpdateInfoDefenition();
//	UpdateInfo.Method = "UpdateManagerServer.RunUpdate_UpdateSystemAttributes_Store";
//	UpdateInfo.Description = "Update system attribute [Store]";
//	UpdateInfo.FullDescription = "Full description Update system attribute [Store]";
//	ArrayOfUpdateInfo.Add(UpdateInfo);
	
	UpdateInfo = GetUpdateInfoDefenition();
	UpdateInfo.Method = "UpdateManagerServer.RunUpdate_Update1";
	UpdateInfo.Description = "Update 1";
	UpdateInfo.FullDescription = "Full description Update 1";
	ArrayOfUpdateInfo.Add(UpdateInfo);
	
	UpdateInfo = GetUpdateInfoDefenition();
	UpdateInfo.Method = "UpdateManagerServer.RunUpdate_Update2";
	UpdateInfo.Description = "Update 2";
	UpdateInfo.FullDescription = "Full description 2";
	ArrayOfUpdateInfo.Add(UpdateInfo);
	
	UpdateInfo = GetUpdateInfoDefenition();
	UpdateInfo.Method = "UpdateManagerServer.RunUpdate_Update3";
	UpdateInfo.Description = "Update 3";
	UpdateInfo.FullDescription = "Full description 3";
	ArrayOfUpdateInfo.Add(UpdateInfo);
	
	UpdateInfo = GetUpdateInfoDefenition();
	UpdateInfo.Method = "UpdateManagerServer.RunUpdate_Update4";
	UpdateInfo.Description = "Update 4";
	UpdateInfo.FullDescription = "Full description 4";
	ArrayOfUpdateInfo.Add(UpdateInfo);
	
	UpdateInfo = GetUpdateInfoDefenition();
	UpdateInfo.Method = "UpdateManagerServer.RunUpdate_Update5";
	UpdateInfo.Description = "Update 5";
	UpdateInfo.FullDescription = "Full description 5";
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

#Region UPDATE_METHODS

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

Function RunUpdate_Update1() Export	
	
	Errors = New Array();
	
	TotalCount = 1000;
	
	If TotalCount = 0 Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Return BackgroundJobAPIServer.JobAddErrorEmptyCollection(Msg, Errors, "No data for update: 0");
	EndIf;

	Msg = BackgroundJobAPIServer.NotifySettings();
	Msg.Log = "Start update 1: " + TotalCount;
	BackgroundJobAPIServer.NotifyStream(Msg);
	
	Count = 0; 
	LastPercentLogged = 0;
	JobStartDate = CurrentUniversalDateInMilliseconds();
	
	HaveErrors = False;
	
	For i=0 to 1000 Do
		Try
			// do something
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
		ApplieDatabaseUpdate("UpdateManagerServer.RunUpdate_Update1");
	EndIf;
	
	Return Errors;
EndFunction

Function RunUpdate_Update2() Export	
	
	Errors = New Array();
	
	TotalCount = 1000;
	
	If TotalCount = 0 Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Return BackgroundJobAPIServer.JobAddErrorEmptyCollection(Msg, Errors, "No data for update: 0");
	EndIf;

	Msg = BackgroundJobAPIServer.NotifySettings();
	Msg.Log = "Start update 2: " + TotalCount;
	BackgroundJobAPIServer.NotifyStream(Msg);
	
	Count = 0; 
	LastPercentLogged = 0;
	JobStartDate = CurrentUniversalDateInMilliseconds();
	
	HaveErrors = False;
	
	For i=0 to 1000 Do
		Try
			// do something
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
		ApplieDatabaseUpdate("UpdateManagerServer.RunUpdate_Update2");
	EndIf;

	Return Errors;
EndFunction

Function RunUpdate_Update3() Export	
	
	Errors = New Array();
	
	TotalCount = 1000;
	
	If TotalCount = 0 Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Return BackgroundJobAPIServer.JobAddErrorEmptyCollection(Msg, Errors, "No data for update: 0");
	EndIf;

	Msg = BackgroundJobAPIServer.NotifySettings();
	Msg.Log = "Start update 3: " + TotalCount;
	BackgroundJobAPIServer.NotifyStream(Msg);
	
	Count = 0; 
	LastPercentLogged = 0;
	JobStartDate = CurrentUniversalDateInMilliseconds();
	
	HaveErrors = False;
	
	For i=0 to 1000 Do
		Try
			// do something
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
		ApplieDatabaseUpdate("UpdateManagerServer.RunUpdate_Update3");
	EndIf;
	
	Return Errors;
EndFunction

Function RunUpdate_Update4() Export	
	
	Errors = New Array();
	
	TotalCount = 1000;
	
	If TotalCount = 0 Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Return BackgroundJobAPIServer.JobAddErrorEmptyCollection(Msg, Errors, "No data for update: 0");
	EndIf;

	Msg = BackgroundJobAPIServer.NotifySettings();
	Msg.Log = "Start update 4: " + TotalCount;
	BackgroundJobAPIServer.NotifyStream(Msg);
	
	Count = 0; 
	LastPercentLogged = 0;
	JobStartDate = CurrentUniversalDateInMilliseconds();
	
	HaveErrors = False;
	
	For i=0 to 1000 Do
		Try
			// do something
			//d=12/0;
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
		ApplieDatabaseUpdate("UpdateManagerServer.RunUpdate_Update4");
	EndIf;
	
	Return Errors;
EndFunction

Function RunUpdate_Update5() Export	
	
	Errors = New Array();
	
	TotalCount = 1000;
	
	If TotalCount = 0 Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Return BackgroundJobAPIServer.JobAddErrorEmptyCollection(Msg, Errors, "No data for update: 0");
	EndIf;

	Msg = BackgroundJobAPIServer.NotifySettings();
	Msg.Log = "Start update 5: " + TotalCount;
	BackgroundJobAPIServer.NotifyStream(Msg);
	
	Count = 0; 
	LastPercentLogged = 0;
	JobStartDate = CurrentUniversalDateInMilliseconds();
	
	HaveErrors = False;
	
	For i=0 to 1000 Do
		Try
			// do something
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
		ApplieDatabaseUpdate("UpdateManagerServer.RunUpdate_Update5");
	EndIf;
	
	Return Errors;
EndFunction

#EndRegion
