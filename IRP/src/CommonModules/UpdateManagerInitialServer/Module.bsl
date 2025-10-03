
Procedure GetUpdateInfo(ArrayOfUpdateInfo) Export
	UpdateInfo = UpdateManagerServer.GetUpdateInfoDefenition();
	UpdateInfo.Method = "UpdateManagerInitialServer.RunUpdate_UpdateSystemAttributes";
	UpdateInfo.Description = R().Update_002;
	UpdateInfo.FullDescription = R().UpdateDesc_002;
	ArrayOfUpdateInfo.Add(UpdateInfo);
	
	UpdateInfo = UpdateManagerServer.GetUpdateInfoDefenition();
	UpdateInfo.Method = "UpdateManagerInitialServer.RunUpdate_UpdateSystemAttributesSets";
	UpdateInfo.Description = R().Update_003;
	UpdateInfo.FullDescription = R().UpdateDesc_003;
	ArrayOfUpdateInfo.Add(UpdateInfo);

	UpdateInfo = UpdateManagerServer.GetUpdateInfoDefenition();
	UpdateInfo.Method = "UpdateManagerInitialServer.RunUpdate_UpdateSystemAttributesValue";
	UpdateInfo.Description = R().Update_004;
	UpdateInfo.FullDescription = R().UpdateDesc_004;
	ArrayOfUpdateInfo.Add(UpdateInfo);
	
EndProcedure

Function RunUpdate_UpdateSystemAttributes(MethodName) Export	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	SystemAttributes.Ref,
	|	SystemAttributes.PredefinedDataName
	|FROM
	|	ChartOfCharacteristicTypes.SystemAttributes AS SystemAttributes
	|WHERE
	|	SystemAttributes.Predefined";
	
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
			ChartsOfCharacteristicTypes.SystemAttributes.UpdatePredefinedNames(QuerySelection.PredefinedDataName);
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
        Raise R().JobAborted;
	EndIf;
	
	If Errors.Count() = 0 Then
		UpdateManagerServer.ApplieDatabaseUpdate(MethodName);
	EndIf;
	
	Return Errors;
EndFunction

Function RunUpdate_UpdateSystemAttributesSets(MethodName) Export	
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
			Catalogs.SystemAttributesSets.CheckFillSetPredefinedValue(QuerySelection.Ref);
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
            Raise R().JobAborted;
	EndIf;
	
	If Errors.Count() = 0 Then
		UpdateManagerServer.ApplieDatabaseUpdate(MethodName);
	EndIf;
	
	Return Errors;
EndFunction

Function RunUpdate_UpdateSystemAttributesValue(MethodName) Export	
	
	MaxDocsCount = 1000;
	
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
			If ArrayOfAttributes.Count() = 0 Then
				Continue;
			EndIf;
			
			Query = New Query;
			Query.Text = 
			"SELECT TOP 1 Object
			|FROM InformationRegister.SystemAttributes AS SystemAttributes
			|WHERE Object REFS Document." + DocMetadataName;
			QueryResult = Query.Execute();
			If QueryResult.IsEmpty() Then
				Msg = BackgroundJobAPIServer.NotifySettings();
				Msg.Log = DocMetadataName+ " - start";
				BackgroundJobAPIServer.NotifyStream(Msg);
			Else
				Msg = BackgroundJobAPIServer.NotifySettings();
				Msg.Log = DocMetadataName + " - skip";
				BackgroundJobAPIServer.NotifyStream(Msg);
				Continue;
			EndIf;
	
			PackNumber = 1;
			
			QueryDoc = New Query();
			QueryDoc.Text = 
			"SELECT Doc.Ref AS Ref, RECORDAUTONUMBER() AS Number INTO tmp
			|FROM Document." + DocMetadataName + " AS Doc;
			|SELECT tmp.Ref WHERE tmp.Number BETWEEN &StartNumber AND &FinishNumber";
			QueryDoc.SetParameter("StartNumber", (PackNumber - 1) * MaxDocsCount + 1);
			QueryDoc.SetParameter("FinishNumber", PackNumber * MaxDocsCount);
			
			QueryDocSelection = QueryDoc.Execute().Select();
			
			While QueryDocSelection.Count() > 0 Do
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
			PackNumber = PackNumber + 1;
			QueryDoc.SetParameter("StartNumber", (PackNumber - 1) * MaxDocsCount + 1);
			QueryDoc.SetParameter("FinishNumber", PackNumber * MaxDocsCount);
			QueryDocSelection = QueryDoc.Execute().Select();
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
	
	Msg = BackgroundJobAPIServer.NotifySettings();
	Msg.Log = "Finish";
	BackgroundJobAPIServer.NotifyStream(Msg);
	
	BackgroundJobAPIServer.JobAddEndMessage(Errors);
	
	If HaveErrors Then
		Raise R().JobAborted;
	EndIf;
	
	If Errors.Count() = 0 Then
		UpdateManagerServer.ApplieDatabaseUpdate(MethodName);
	EndIf;
	
	Return Errors;
EndFunction
