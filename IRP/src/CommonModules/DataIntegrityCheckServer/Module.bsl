
Procedure BackgroundJob(StorageAddress, StartDate, EndDate, Company, Branch, ArrayOfChecks) Export
	JobResult = New Structure();
	
	If ArrayOfChecks.Find("DuplicateActiveFACommissioningRecords") <> Undefined Then
		JobResult.Insert("DuplicateActiveFACommissioningRecords", 
			DuplicateActiveFACommissioningRecords(StartDate, EndDate, Company, Branch));
	EndIf;
	
	If ArrayOfChecks.Find("NegativeActualDepreciationAmount") <> Undefined Then
		JobResult.Insert("NegativeActualDepreciationAmount", 
			NegativeActualDepreciationAmount(StartDate, EndDate, Company, Branch));
	EndIf;
	
	If ArrayOfChecks.Find("ExpiredUsefulLifeWithUnwrittenOffBalance") <> Undefined Then
		JobResult.Insert("ExpiredUsefulLifeWithUnwrittenOffBalance", 
			ExpiredUsefulLifeWithUnwrittenOffBalance(StartDate, EndDate, Company, Branch));
	EndIf;
	
	If ArrayOfChecks.Find("MissingDepreciationPeriodForActiveFixedAsset") <> Undefined Then
		JobResult.Insert("MissingDepreciationPeriodForActiveFixedAsset", 
			MissingDepreciationPeriodForActiveFixedAsset(StartDate, EndDate, Company, Branch));
	EndIf;
	
	If ArrayOfChecks.Find("CostCenterMismatchWithCurrentAssetLocation") <> Undefined Then
		JobResult.Insert("CostCenterMismatchWithCurrentAssetLocation", 
			CostCenterMismatchWithCurrentAssetLocation(StartDate, EndDate, Company, Branch));
	EndIf;
	
	If ArrayOfChecks.Find("FATransactionOrDisposalDatePredatesLastTransfer") <> Undefined Then
		JobResult.Insert("FATransactionOrDisposalDatePredatesLastTransfer", 
			FATransactionOrDisposalDatePredatesLastTransfer(StartDate, EndDate, Company, Branch));
	EndIf;
	
	CommonFunctionsServer.PutToCache(JobResult, StorageAddress);
EndProcedure

Function DuplicateActiveFACommissioningRecords(StartDate, EndDate, Company, Branch)
	Query = New Query();
	Query.Text = 
	"SELECT DISTINCT
	|	T8515S_FixedAssetsLocation.FixedAsset AS FixedAsset,
	|	T8515S_FixedAssetsLocation.Recorder
	|FROM
	|	InformationRegister.T8515S_FixedAssetsLocation AS T8515S_FixedAssetsLocation
	|WHERE
	|	T8515S_FixedAssetsLocation.Period BETWEEN BEGINOFPERIOD(&StartDate, DAY) AND ENDOFPERIOD(&EndDate, DAY)";
	
	Query.SetParameter("StartDate", StartDate);
	Query.SetParameter("EndDate", EndDate);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	DocumentsTable = New ValueTable();
	DocumentsTable.Columns.Add("Document");
	
	While QuerySelection.Next() Do
		CheckResult = FixedAssetAlreadyCommisioned(QuerySelection.FixedAsset, QuerySelection.Recorder); 
		If CheckResult.Count() Then
			DocumentsTable.Add().Document = QuerySelection.Recorder;
			For Each Document In CheckResult Do
				DocumentsTable.Add().Document = Document;
			EndDo;	
		EndIf;
	EndDo;
	
	DocumentsTable.GroupBy("Document");
	
	Result = New Structure("Failed, Documents", False, New Array());
	For Each Row In DocumentsTable Do
		Result.Failed = True;
		Result.Documents.Add(Row.Document);
	EndDo;
	Return Result;
EndFunction

Function FixedAssetAlreadyCommisioned(FixedAsset, Recorder)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	T8515S_FixedAssetsLocation.Recorder
	|FROM
	|	InformationRegister.T8515S_FixedAssetsLocation AS T8515S_FixedAssetsLocation
	|WHERE
	|	T8515S_FixedAssetsLocation.Recorder <> &Recorder
	|	AND T8515S_FixedAssetsLocation.FixedAsset = &FixedAsset
	|	AND T8515S_FixedAssetsLocation.IsActive";
	Query.SetParameter("Recorder", Recorder);
	Query.SetParameter("FixedAsset", FixedAsset);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	ArrayOfDocuments = New Array();
	While QuerySelection.Next() Do
		ArrayOfDocuments.Add(QuerySelection.Recorder);
	EndDo;
	Return ArrayOfDocuments;
EndFunction

Function NegativeActualDepreciationAmount(StartDate, EndDate, Company, Branch)
	
EndFunction

Function ExpiredUsefulLifeWithUnwrittenOffBalance(StartDate, EndDate, Company, Branch)
	
EndFunction

Function MissingDepreciationPeriodForActiveFixedAsset(StartDate, EndDate, Company, Branch)
	
EndFunction

Function CostCenterMismatchWithCurrentAssetLocation(StartDate, EndDate, Company, Branch)
	
EndFunction

Function FATransactionOrDisposalDatePredatesLastTransfer(StartDate, EndDate, Company, Branch)
	
EndFunction
