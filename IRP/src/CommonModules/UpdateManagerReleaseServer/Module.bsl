
Procedure GetUpdateInfo(ArrayOfUpdateInfo) Export
	UpdateInfo = UpdateManagerServer.GetUpdateInfoDefenition();
	UpdateInfo.Method = "UpdateManagerReleaseServer.RunUpdate_ItemType_StockBalanceDetail_SerialLotNumber";
	UpdateInfo.Description = R().Update_001;
	UpdateInfo.FullDescription = R().UpdateDesc_001;
	ArrayOfUpdateInfo.Add(UpdateInfo);				
EndProcedure

Function RunUpdate_ItemType_StockBalanceDetail_SerialLotNumber(MethodName) Export	
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
		UpdateManagerServer.ApplieDatabaseUpdate(MethodName);
	EndIf;
	
	Return Errors;
EndFunction
