
#Region RepostingDocuments

Function RepostingDocuments(Company, StartDate, EndDate, UpdateCurrenciesTable) Export
	Query = New Query();
	Query_Text = 
	"SELECT
	|	Doc.Ref,
	|	Doc.Date
	|	%2
	|FROM
	|	Document.%1 AS Doc
	|WHERE
	|	Doc.Posted
	|	AND Doc.Date BETWEEN BEGINOFPERIOD(&StartDate, DAY) AND ENDOFPERIOD(&EndDate, DAY)
	|	%3 ";
	
	Query.SetParameter("StartDate" , StartDate);
	Query.SetParameter("EndDate"   , EndDate);
	Query.SetParameter("Company"   , Company);
	
	ExcludeDocuments = New Array();
	ExcludeDocuments.Add(Metadata.Documents.CalculationMovementCosts);
	ExcludeDocuments.Add(Metadata.Documents.VendorsAdvancesClosing);
	ExcludeDocuments.Add(Metadata.Documents.CustomersAdvancesClosing);
	ExcludeDocuments.Add(Metadata.Documents.ForeignCurrencyRevaluation);
	ExcludeDocuments.Add(Metadata.Documents.JournalEntry);
	ExcludeDocuments.Add(Metadata.Documents.Labeling);
	ExcludeDocuments.Add(Metadata.Documents.PriceList);
	ExcludeDocuments.Add(Metadata.Documents.PhysicalCountByLocation);
	ExcludeDocuments.Add(Metadata.Documents.ReconciliationStatement);
	ExcludeDocuments.Add(Metadata.Documents.OutgoingMessage);
	
	ArrayOfQueryText = New Array();
	
	For Each DocMetadata In Metadata.Documents Do
		If ExcludeDocuments.Find(DocMetadata) <> Undefined Then
			Continue;
		EndIf;
		
		CompanyCondition = ?(DocMetadata.Attributes.Find("Company") <> Undefined, 
			" AND Doc.Company = &Company ","");
		
		ArrayOfQueryText.Add(StrTemplate(Query_Text, DocMetadata.Name, 
			?(ArrayOfQueryText.Count() = 0, " INTO AllDocuments ", ""),
			CompanyCondition));
	EndDo;
	
	Query.Text = StrConcat(ArrayOfQueryText, " UNION ALL ") + 
	";
	|SELECT
	|	AllDocuments.Ref
	|FROM AllDocuments AS AllDocuments
	|ORDER By
	|	Date;
	|"; 
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	Errors = New Array();
	
	TotalCount = QuerySelection.Count();
	
	If TotalCount = 0 Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Return JobAddErrorEmptyCollection(Msg, Errors, "No documents for reposting: 0");
	EndIf;

	Msg = BackgroundJobAPIServer.NotifySettings();
	Msg.Log = "Start reposting: " + TotalCount;
	BackgroundJobAPIServer.NotifyStream(Msg);
	
	Count = 0; 
	LastPercentLogged = 0;
	JobStartDate = CurrentUniversalDateInMilliseconds();
	
	HaveErrors = False;
	While QuerySelection.Next() Do
		Try
			DocObject = QuerySelection.Ref.GetObject();
			DocObject.AdditionalProperties.Insert("UpdateCurrenciesTable", UpdateCurrenciesTable);
			DocObject.Write(DocumentWriteMode.Posting);
		Except
			ErrorDescription = ErrorProcessing.DetailErrorDescription(ErrorInfo());
			JobAddErrorMessage(Msg, Errors, QuerySelection.Ref, ErrorDescription);
			HaveErrors = True;
			Break;
		EndTry;
				
		Count = Count + 1;
		JobAddPercentMessage(Count, TotalCount, LastPercentLogged, JobStartDate);		
	EndDo;
	
	JobAddEndMessage(Errors);
	
	If HaveErrors Then
		Raise "Job aborted";
	EndIf;
	
	Return Errors;
EndFunction
	
#EndRegion

#Region CalculationMovementType

Function Validate_CalculationMovementCost(Company, StartDate, EndDate, ForAllCompanies) Export
	_Company = ?(ForAllCompanies, Catalogs.Companies.EmptyRef(), Company);
	Return GetOverlappingPeriods(_Company, StartDate, EndDate, "CalculationMovementCosts", "BeginDate", "EndDate");
EndFunction

Function CalculationMovementCosts(Company, StartDate, EndDate, CalculationMode, ForAllCompanies, Periodicity) Export
	_Company = ?(ForAllCompanies, Catalogs.Companies.EmptyRef(), Company);
	PeriodsTable = GetPeriodsTable(StartDate, EndDate, Periodicity);
	
	UnpostExistsDocuments(PeriodsTable[0].StartDate, 
		PeriodsTable[PeriodsTable.Count() - 1].EndDate, 
		_Company, 
		"CalculationMovementCosts", 
		"BeginDate", 
		"EndDate");
		
	UnusedDocuments = GetUnusedDocuments("CalculationMovementCosts");
	TotalCount = PeriodsTable.Count();
	
	Errors = New Array();
	
	If TotalCount = 0 Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Return JobAddErrorEmptyCollection(Msg, Errors, "Empty periods table: 0");
	EndIf;

	Msg = BackgroundJobAPIServer.NotifySettings();
	Msg.Log = "Start calculation movement costs: " + TotalCount;
	BackgroundJobAPIServer.NotifyStream(Msg);
	
	Count = 0; 
	LastPercentLogged = 0;
	JobStartDate = CurrentUniversalDateInMilliseconds();
	
	HaveErrors = False;
		
	For Each Period In PeriodsTable Do
		Try
	
			If UnusedDocuments.Count() > 0 Then
				DocObject = UnusedDocuments[0].Ref.GetObject();
				UnusedDocuments.Delete(0);
			Else
				DocObject = Documents.CalculationMovementCosts.CreateDocument();
			EndIf;
			
			DocObject.Date = EndOfDay(Period.EndDate);
			DocObject.DeletionMark = False;
			DocObject.BeginDate = Period.StartDate;
			DocObject.EndDate = Period.EndDate;
			DocObject.CalculationMode = CalculationMode;
			DocObject.Company = _Company;
			DocObject.RaiseOnCalculationError = True;
			DocObject.Write(DocumentWriteMode.Write);
			DocObject.Write(DocumentWriteMode.Posting);
		Except
			ErrorDescription = ErrorProcessing.DetailErrorDescription(ErrorInfo());
			JobAddErrorMessage(Msg, Errors, DocObject.Ref, ErrorDescription);
			HaveErrors = True;
			Break;
		EndTry;
				
		Count = Count + 1;
		JobAddPercentMessage(Count, TotalCount, LastPercentLogged, JobStartDate);
		
	EndDo;
	
	JobAddEndMessage(Errors);
	
	If HaveErrors Then
		Raise "Job aborted";
	EndIf;
	
	Return Errors;
EndFunction

#EndRegion

#Region VendorsAdvancesClosing

Function Validate_VendorsAdvancesClosing(Company, StartDate, EndDate) Export
	Return GetOverlappingPeriods(Company, StartDate, EndDate, "VendorsAdvancesClosing", "BeginOfPeriod", "EndOfPeriod");
EndFunction

Function VendorsAdvancesClosing(Company, StartDate, EndDate, DontOffsetEmptyProjects, Periodicity) Export
	PeriodsTable = GetPeriodsTable(StartDate, EndDate, Periodicity);
	
	UnpostExistsDocuments(PeriodsTable[0].StartDate, 
		PeriodsTable[PeriodsTable.Count() - 1].EndDate, 
		Company, 
		"VendorsAdvancesClosing", 
		"BeginOfPeriod", 
		"EndOfPeriod");
		
	UnusedDocuments = GetUnusedDocuments("VendorsAdvancesClosing");
	TotalCount = PeriodsTable.Count();
	
	Errors = New Array();
	
	If TotalCount = 0 Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Return JobAddErrorEmptyCollection(Msg, Errors, "Empty periods table: 0");
	EndIf;

	Msg = BackgroundJobAPIServer.NotifySettings();
	Msg.Log = "Start vendors advances closing: " + TotalCount;
	BackgroundJobAPIServer.NotifyStream(Msg);
	
	Count = 0; 
	LastPercentLogged = 0;
	JobStartDate = CurrentUniversalDateInMilliseconds();
	
	HaveErrors = False;
		
	For Each Period In PeriodsTable Do
		Try
	
			If UnusedDocuments.Count() > 0 Then
				DocObject = UnusedDocuments[0].Ref.GetObject();
				UnusedDocuments.Delete(0);
			Else
				DocObject = Documents.VendorsAdvancesClosing.CreateDocument();
			EndIf;
			
			DocObject.Date = EndOfDay(Period.EndDate);
			DocObject.DeletionMark = False;
			DocObject.BeginOfPeriod = Period.StartDate;
			DocObject.EndOfPeriod = Period.EndDate;
			DocObject.Company = Company;
			DocObject.DontOffsetEmptyProjects = DontOffsetEmptyProjects;
			DocObject.Write(DocumentWriteMode.Write);
			DocObject.Write(DocumentWriteMode.Posting);
		Except
			ErrorDescription = ErrorProcessing.DetailErrorDescription(ErrorInfo());
			JobAddErrorMessage(Msg, Errors, DocObject.Ref, ErrorDescription);
			HaveErrors = True;
			Break;
		EndTry;
				
		Count = Count + 1;
		JobAddPercentMessage(Count, TotalCount, LastPercentLogged, JobStartDate);
		
	EndDo;
	
	JobAddEndMessage(Errors);
	
	If HaveErrors Then
		Raise "Job aborted";
	EndIf;
	
	Return Errors;
EndFunction

#EndRegion

#Region CustomersAdvancesClosing

Function Validate_CustomersAdvancesClosing(Company, StartDate, EndDate) Export
	Return GetOverlappingPeriods(Company, StartDate, EndDate, "CustomersAdvancesClosing", "BeginOfPeriod", "EndOfPeriod");
EndFunction

Function CustomersAdvancesClosing(Company, StartDate, EndDate, DontOffsetEmptyProjects, Periodicity) Export
	PeriodsTable = GetPeriodsTable(StartDate, EndDate, Periodicity);
	
	UnpostExistsDocuments(PeriodsTable[0].StartDate, 
		PeriodsTable[PeriodsTable.Count() - 1].EndDate, 
		Company, 
		"CustomersAdvancesClosing", 
		"BeginOfPeriod", 
		"EndOfPeriod");
		
	UnusedDocuments = GetUnusedDocuments("CustomersAdvancesClosing");
	TotalCount = PeriodsTable.Count();
	
	Errors = New Array();
	
	If TotalCount = 0 Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Return JobAddErrorEmptyCollection(Msg, Errors, "Empty periods table: 0");
	EndIf;

	Msg = BackgroundJobAPIServer.NotifySettings();
	Msg.Log = "Start customers advances closing: " + TotalCount;
	BackgroundJobAPIServer.NotifyStream(Msg);
	
	Count = 0; 
	LastPercentLogged = 0;
	JobStartDate = CurrentUniversalDateInMilliseconds();
	
	HaveErrors = False;
		
	For Each Period In PeriodsTable Do
		Try
	
			If UnusedDocuments.Count() > 0 Then
				DocObject = UnusedDocuments[0].Ref.GetObject();
				UnusedDocuments.Delete(0);
			Else
				DocObject = Documents.CustomersAdvancesClosing.CreateDocument();
			EndIf;
			
			DocObject.Date = EndOfDay(Period.EndDate);
			DocObject.DeletionMark = False;
			DocObject.BeginOfPeriod = Period.StartDate;
			DocObject.EndOfPeriod = Period.EndDate;
			DocObject.Company = Company;
			DocObject.DontOffsetEmptyProjects = DontOffsetEmptyProjects;
			DocObject.Write(DocumentWriteMode.Write);
			DocObject.Write(DocumentWriteMode.Posting);
		Except
			ErrorDescription = ErrorProcessing.DetailErrorDescription(ErrorInfo());
			JobAddErrorMessage(Msg, Errors, DocObject.Ref, ErrorDescription);
			HaveErrors = True;
			Break;
		EndTry;
				
		Count = Count + 1;
		JobAddPercentMessage(Count, TotalCount, LastPercentLogged, JobStartDate);
		
	EndDo;
	
	JobAddEndMessage(Errors);
	
	If HaveErrors Then
		Raise "Job aborted";
	EndIf;
	
	Return Errors;
EndFunction

#EndRegion

#Region ForeignCurrencyRevaluation

Function ForeignCurrencyRevaluation(Company, StartDate, EndDate, Analytics, Periodicity) Export
	PeriodsTable = GetPeriodsTable(StartDate, EndDate, Periodicity);
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Doc.Ref
	|FROM
	|	Document.ForeignCurrencyRevaluation AS Doc
	|WHERE
	|	Doc.Posted
	|	AND Doc.Company = &Company
	|	AND BEGINOFPERIOD(Doc.Date, DAY) BETWEEN &StartDate AND &EndDate";
	
	Query.SetParameter("Company", Company);
	
	For Each Period In PeriodsTable Do
		Query.SetParameter("StartDate" , Period.StartDate);
		Query.SetParameter("EndDate"   , Period.EndDate);
		QueryResult = Query.Execute();
		QuerySelection = QueryResult.Select();
		
		While QuerySelection.Next() Do
			DocObject = QuerySelection.Ref.GetObject();
			DocObject.Write(DocumentWriteMode.UndoPosting);
		EndDo;
	EndDo;
	
	UnusedDocuments = GetUnusedDocuments("ForeignCurrencyRevaluation");
	TotalCount = PeriodsTable.Count();
	
	Errors = New Array();
	
	If TotalCount = 0 Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Return JobAddErrorEmptyCollection(Msg, Errors, "Empty periods table: 0");
	EndIf;

	Msg = BackgroundJobAPIServer.NotifySettings();
	Msg.Log = "Start foreign currency revaluation: " + TotalCount;
	BackgroundJobAPIServer.NotifyStream(Msg);
	
	Count = 0; 
	LastPercentLogged = 0;
	JobStartDate = CurrentUniversalDateInMilliseconds();
	
	HaveErrors = False;
		
	For Each Period In PeriodsTable Do
		Try
	
			If UnusedDocuments.Count() > 0 Then
				DocObject = UnusedDocuments[0].Ref.GetObject();
				UnusedDocuments.Delete(0);
			Else
				DocObject = Documents.ForeignCurrencyRevaluation.CreateDocument();
			EndIf;
			
			DocObject.Date = EndOfDay(Period.EndDate);
			DocObject.DeletionMark = False;
			DocObject.Company = Company;
			
			DocObject.RevenueType               = Analytics.RevenueType; 
			DocObject.RevenueProfitLossCenter   = Analytics.RevenueProfitLossCenter; 
			DocObject.RevenueAdditionalAnalytic = Analytics.RevenueAdditionalAnalytic; 
			
			DocObject.ExpenseType               = Analytics.ExpenseType; 
			DocObject.ExpenseProfitLossCenter   = Analytics.ExpenseProfitLossCenter; 
			DocObject.ExpenseAdditionalAnalytic = Analytics.ExpenseAdditionalAnalytic; 
			
			DocObject.Write(DocumentWriteMode.Write);
			DocObject.Write(DocumentWriteMode.Posting);
		Except
			ErrorDescription = ErrorProcessing.DetailErrorDescription(ErrorInfo());
			JobAddErrorMessage(Msg, Errors, DocObject.Ref, ErrorDescription);
			HaveErrors = True;
			Break;
		EndTry;
				
		Count = Count + 1;
		JobAddPercentMessage(Count, TotalCount, LastPercentLogged, JobStartDate);
		
	EndDo;
	
	JobAddEndMessage(Errors);
	
	If HaveErrors Then
		Raise "Job aborted";
	EndIf;
	
	Return Errors;
EndFunction

#EndRegion

#Region AccountingTransalation

Function AccountingTranslation(ArrayOfDocuments) Export
	TotalCount = ArrayOfDocuments.Count();
	
	Errors = New Array();
	
	If TotalCount = 0 Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Return JobAddErrorEmptyCollection(Msg, Errors, "Empty documents array: 0");
	EndIf;

	Msg = BackgroundJobAPIServer.NotifySettings();
	Msg.Log = "Start accounting translations: " + TotalCount;
	BackgroundJobAPIServer.NotifyStream(Msg);
	
	Count = 0; 
	LastPercentLogged = 0;
	JobStartDate = CurrentUniversalDateInMilliseconds();
			
	For Each DocRef In ArrayOfDocuments Do
		Try
	
			ArrayOfBasisDocuments = New Array();
			ArrayOfBasisDocuments.Add(DocRef);

			ArrayOfLedgerTypes = AccountingServer.GetLedgerTypesByCompany(DocRef, DocRef.Date, DocRef.Company);		
			TableOfJEDocuments = AccountingServer.GetTableOfJEDocuments(ArrayOfBasisDocuments, ArrayOfLedgerTypes);
					
			For Each Row In TableOfJEDocuments Do
				CommonFunctionsClientServer.PutToAddInfo(Row.JEDocument.AdditionalProperties, "WriteOnForm", True);
				Row.JEDocument.DeletionMark = Row.BasisDocument.DeletionMark;
				Row.JEDocument.Write(DocumentWriteMode.Write);
			EndDo;							
		Except
			ErrorDescription = ErrorProcessing.DetailErrorDescription(ErrorInfo());
			JobAddErrorMessage(Msg, Errors, DocRef, ErrorDescription);
		EndTry;
				
		Count = Count + 1;
		JobAddPercentMessage(Count, TotalCount, LastPercentLogged, JobStartDate);
		
	EndDo;
	
	JobAddEndMessage(Errors);
		
	Return Errors;
EndFunction



#EndRegion

#Region BacjgroundJob

Procedure JobAddErrorMessage(Msg, Errors, Doc, ErrorDescription)
	Msg = BackgroundJobAPIServer.NotifySettings();
	Msg.Log = "Error: " + Doc + ":" + Chars.LF + ErrorDescription;
	BackgroundJobAPIServer.NotifyStream(Msg);
			
	Result = New Structure;
	Result.Insert("Ref", Doc);
	Result.Insert("RegInfo", New Array);
	Result.Insert("Error", Msg.Log);
	Errors.Add(Result);
EndProcedure

Function JobAddErrorEmptyCollection(Msg, Errors, Message)
	Msg = BackgroundJobAPIServer.NotifySettings();
	Msg.Log = "Empty doc list: 0";
	Msg.End = True;
	Msg.DataAddress = CommonFunctionsServer.PutToCache(Errors);
	BackgroundJobAPIServer.NotifyStream(Msg);
	Return Errors;
EndFunction

Procedure JobAddPercentMessage(Count, TotalCount, LastPercentLogged, StartDate)
	Percent = 100 * Count / TotalCount;
	If (Percent - LastPercentLogged >= 1) Then  
		LastPercentLogged = Int(Percent);
		Msg = BackgroundJobAPIServer.NotifySettings();
		DateDiff = CurrentUniversalDateInMilliseconds() - StartDate;
		If DateDiff = 0 Then
			DateDiff = 1;
		EndIf;
		Msg.Speed = Format(1000 * Count / DateDiff, "NFD=2; NG=") + " doc/sec";
		Msg.Percent = Percent;
		BackgroundJobAPIServer.NotifyStream(Msg);
	EndIf;
EndProcedure

Procedure JobAddEndMessage(Errors)
	Msg = BackgroundJobAPIServer.NotifySettings();
	Msg.End = True;
	Msg.DataAddress = CommonFunctionsServer.PutToCache(Errors);
	BackgroundJobAPIServer.NotifyStream(Msg);
EndProcedure

#EndRegion

Function GetOverlappingPeriods(Company, StartDate, EndDate, DocumentName, StartDateFieldName, EndDateFieldName)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Doc.Ref AS Ref,
	|	Doc.%2 AS StartDate,
	|	Doc.%3 AS EndDate
	|FROM
	|	Document.%1 AS Doc
	|WHERE
	|	Doc.Posted
	|	AND Doc.Company = &Company
	|	AND Doc.%2 < &StartDate
	|	AND (Doc.%3 BETWEEN &StartDate AND &EndDate)
	|
	|UNION ALL
	|
	|SELECT
	|	Doc.Ref AS Ref,
	|	Doc.%2,
	|	Doc.%3
	|FROM
	|	Document.%1 AS Doc
	|WHERE
	|	Doc.Posted
	|	AND Doc.Company = &Company
	|	AND Doc.%3 > &EndDate
	|	AND (Doc.%2 BETWEEN &StartDate AND &EndDate)
	|
	|UNION ALL
	|
	|SELECT
	|	Doc.Ref AS Ref,
	|	Doc.%2,
	|	Doc.%3
	|FROM
	|	Document.%1 AS Doc
	|WHERE
	|	Doc.Posted
	|	AND Doc.Company = &Company
	|	AND Doc.%3 > &EndDate
	|	AND Doc.%2 < &StartDate";
	
	Query.Text = StrTemplate(Query.Text, DocumentName, StartDateFieldName, EndDateFieldName);
	
	Query.SetParameter("StartDate", StartDate);
	Query.SetParameter("EndDate"  , EndDate);
	Query.SetParameter("Company"  , Company);

	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	ArrayOfErrors = New Array();
	
	While QuerySelection.Next() Do
		Msg = StrTemplate("Overlapping period [%1 - %2] %3", 
			Format(QuerySelection.StartDate, "DF=dd.MM.yyyy;"),
			Format(QuerySelection.EndDate, "DF=dd.MM.yyyy;"));
		ArrayOfErrors.Add(New Structure("Msg, Ref", Msg, QuerySelection.Ref));
	EndDo;
	
	Return ArrayOfErrors;
EndFunction

Procedure UnpostExistsDocuments(StartDate, EndDate, Company, DocumentName, StartDateFieldName, EndDateFieldName)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Doc.Ref
	|FROM
	|	Document.%1 AS Doc
	|WHERE
	|	Doc.Posted
	|	AND (Doc.%2 BETWEEN &StartDate AND &EndDate
	|	AND Doc.%3 BETWEEN &StartDate AND &EndDate)
	|	AND Doc.Company = &Company";
	
	Query.Text = StrTemplate(Query.Text, DocumentName, StartDateFieldName, EndDateFieldName);
	
	Query.SetParameter("StartDate", StartDate);
	Query.SetParameter("EndDate"  , EndDate);
	Query.SetParameter("Company"  , Company);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
		
	While QuerySelection.Next() Do
		DocObject = QuerySelection.Ref.GetObject();
		DocObject.Write(DocumentWriteMode.UndoPosting);
	EndDo;	
EndProcedure

Function GetUnusedDocuments(DocumentName)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Doc.Ref
	|FROM
	|	Document.%1 AS Doc
	|WHERE
	|	NOT Doc.Posted
	|
	|ORDER BY
	|	Doc.Number";
	
	Query.Text = StrTemplate(Query.Text, DocumentName);
	
	QueryResult = Query.Execute();
	UnusedDocuments = QueryResult.Unload();
	Return UnusedDocuments;
EndFunction

Function GetPeriodsTable(StartDate, EndDate, Periodicity)
	PeriodsTable = New ValueTable();
	PeriodsTable.Columns.Add("StartDate");
	PeriodsTable.Columns.Add("EndDate");
	
	If StartDate = EndDate Or Periodicity = "ByPeriod" Then
		NewRow = PeriodsTable.Add();
		NewRow.StartDate = StartDate;
		NewRow.EndDate = EndDate;
		Return PeriodsTable;
	EndIf;
	
	_StartDate = StartDate;
	
	While _StartDate <= EndDate Do
		If Periodicity = "Everyday" Then
			NewRow = PeriodsTable.Add();
			NewRow.StartDate = _StartDate;
			NewRow.EndDate = _StartDate;
		ElsIf Periodicity = "Monthly" Then
			If BegOfMonth(_StartDate) = _StartDate 
				And EndOfMonth(_StartDate) <= EndOfDay(EndDate) Then
				NewRow = PeriodsTable.Add();
				NewRow.StartDate = BegOfMonth(_StartDate);
				NewRow.EndDate = BegOfDay(EndOfMonth(_StartDate));
			EndIf;
		EndIf;
		_StartDate = EndOfDay(_StartDate) + 1; // next day
	EndDo;
	Return PeriodsTable;
EndFunction

Function AccountingTranslatons(Company, StartDate, EndDate) Export

EndFunction

