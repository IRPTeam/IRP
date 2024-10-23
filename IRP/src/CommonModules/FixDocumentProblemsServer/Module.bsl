// @strict-types

// Get jobs for check posting documents.
// 
// @skip-check typed-value-adding-to-untyped-collection
// 
// Parameters:
//  DocumentList - ValueTable:
//  * DocumentType - String -
//  * Ref - DocumentRefDocumentName -
//  ProcedurePath - String - Procedure path
// 
// Returns:
//  Structure - See BackgroundJobAPIServer.JobDataSettings
Function GetJobsForCheckPostingDocuments(DocumentList, ProcedurePath) Export
	
	TypesTable = DocumentList.Copy(, "DocumentType");
	TypesTable.GroupBy("DocumentType");
	
	JobDataSettings = BackgroundJobAPIServer.JobDataSettings();
	JobDataSettings.CallbackFunction = "GetJobsForCheckPostingDocuments_Callback";
	JobDataSettings.ProcedurePath = ProcedurePath;
	JobDataSettings.CallbackWhenAllJobsDone = False;
					 
	DocsInPack = 100;
	For Each TypeItem In TypesTable Do
		DocumentsRows = DocumentList.FindRows(New Structure("DocumentType", TypeItem.DocumentType));
		 
		StreamArray = New Array; // Array Of Arbitrary
		Pack = 1;
		TotalDocs = DocumentsRows.Count();
		For Each Row In DocumentsRows Do
			StreamArray.Add(Row.Ref);
		 	
		 	If StreamArray.Count() = DocsInPack Then
		 		JobSettings = BackgroundJobAPIServer.JobSettings();
				JobSettings.ProcedureParams.Add(StreamArray);
				JobSettings.ProcedureParams.Add(True);
				JobSettings.Description = String(TypeItem.DocumentType) + ": " + Pack + " * (" + DocsInPack + ") / " + TotalDocs;
				JobDataSettings.JobSettings.Add(JobSettings);
				
				StreamArray = New Array;
		 		Pack = Pack + 1;
		 	EndIf;
		EndDo;
		If StreamArray.Count() > 0 Then
			JobSettings = BackgroundJobAPIServer.JobSettings();
			JobSettings.ProcedureParams.Add(StreamArray);
			JobSettings.ProcedureParams.Add(True);
			JobSettings.Description = String(TypeItem.DocumentType) + ": " + Pack + " * (" + StreamArray.Count() + ") / " + TotalDocs;
			JobDataSettings.JobSettings.Add(JobSettings);
	 	EndIf;
	EndDo;

	Return JobDataSettings;
EndFunction

Function GetJobsForWriteRecordSet(Tree) Export
	JobDataSettings = BackgroundJobAPIServer.JobDataSettings();
	JobDataSettings.CallbackFunction = "GetJobsForWriteRecordSet_Callback";
	JobDataSettings.ProcedurePath = "PostingServer.WriteDocumentsRecords";
					
	DocsInPack = 100;
	StreamArray = New Array;
	For Each Doc In Tree.Rows Do
		
		For Each Row In Doc.Rows Do
		
			If Not Row.Select OR Row.Processed Then
				Continue;
			EndIf;
			
			Pack = 1;
			Str = New Structure;
			Str.Insert("Ref", Row.Ref);
			Str.Insert("NewMovement", Row.NewMovement);
			Str.Insert("RegName", Row.RegName);
			StreamArray.Add(Str);
			
			If StreamArray.Count() = DocsInPack Then
				JobSettings = BackgroundJobAPIServer.JobSettings();
				JobSettings.ProcedureParams.Add(StreamArray);
				JobSettings.ProcedureParams.Add(True);
				JobSettings.Description = "Write records: " + Pack + " * (" + DocsInPack + ")";
				JobDataSettings.JobSettings.Add(JobSettings);
				
				StreamArray = New Array;
				Pack = Pack + 1;
			EndIf;
		EndDo;
	EndDo;
	If StreamArray.Count() > 0 Then
		JobSettings = BackgroundJobAPIServer.JobSettings();
		JobSettings.ProcedureParams.Add(StreamArray);
		JobSettings.ProcedureParams.Add(True);
		JobSettings.Description = "Write records: " + Pack + " * (" + StreamArray.Count() + ")";
		JobDataSettings.JobSettings.Add(JobSettings);
	EndIf;

	Return JobDataSettings;
EndFunction

// Get document list settings.
// 
// Returns:
//  Structure - Get document list settings:
// * StartDate - Date - 
// * EndDate - Date - 
// * OnlyPosted - Boolean - 
// * CompanyList - Array Of CatalogRef.Companies - 
// * QueryText - String - 
// * Accounting - Boolean - 
Function GetDocumentListSettings() Export
	Settings = New Structure;
	Settings.Insert("StartDate", BegOfMonth(CommonFunctionsServer.GetCurrentSessionDate()));
	Settings.Insert("EndDate", EndOfMonth(CommonFunctionsServer.GetCurrentSessionDate()));
	Settings.Insert("OnlyPosted", True);
	Settings.Insert("CompanyList", New Array);
	Settings.Insert("ExcludeDocumentTypes", New Array());
	Settings.Insert("QueryText", "");
	Settings.Insert("Accounting", True);
	Return Settings;
EndFunction

// Get document list.
// 
// Parameters:
//  Settings - See GetDocumentListSettings
// 
// Returns:
//  ValueTable - Get document list
Function GetDocumentList(Settings) Export
	If IsBlankString(Settings.QueryText) Then 
		QueryTxt = GetDocumentQueryText();
	Else
		QueryTxt = Settings.QueryText;
	EndIf;
	
	Query = New Query(QueryTxt);
	Query.SetParameter("StartDate", Settings.StartDate);
	Query.SetParameter("EndDate", Settings.EndDate);
	Query.SetParameter("OnlyPosted", Settings.OnlyPosted);
	Query.SetParameter("CompanySet", Settings.CompanyList.Count() > 0);
	Query.SetParameter("CompanyList", Settings.CompanyList);
	Query.SetParameter("UseExcludeDocuments", Settings.ExcludeDocumentTypes.Count() > 0);
	Query.SetParameter("ExcludeDocumentTypes", Settings.ExcludeDocumentTypes);
	Result = Query.Execute().Unload();
	Return Result
EndFunction

Function GetDocumentQueryText() Export
	Template = "SELECT Doc.Ref, Doc.Date, VALUETYPE(Doc.Ref) %1 %2 FROM Document.%3 AS Doc WHERE Doc.Date BETWEEN &StartDate AND &EndDate";
	Array  = New Array; // Array Of String
	For Each Doc In Metadata.Documents Do
		Array.Add(StrTemplate(Template, ?(Array.Count() > 0, "", "AS DocumentType"), ?(Array.Count() > 0, "", "INTO AllDocuments"), Doc.Name));
	EndDo;	
	
	QueryTxt = StrConcat(Array, Chars.LF + "UNION ALL" + Chars.LF) +	"
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AllDocuments.Date AS Date,
	|	AllDocuments.Ref,
	|	AllDocuments.DocumentType,
	|	CASE
	|		WHEN AllDocuments.Ref.Posted
	|			THEN 0
	|		WHEN AllDocuments.Ref.DeletionMark
	|			THEN 1
	|		ELSE 2
	|	END AS Picture
	|FROM
	|	AllDocuments AS AllDocuments
	|WHERE
	|	AllDocuments.Ref.Date BETWEEN &StartDate AND &EndDate
	|	AND CASE WHEN &OnlyPosted THEN AllDocuments.Ref.Posted ELSE TRUE END
	|	AND CASE WHEN &CompanySet THEN AllDocuments.Ref.Company IN (&CompanyList) ELSE TRUE END
	|	AND CASE WHEN &UseExcludeDocuments THEN VALUETYPE(AllDocuments.Ref) NOT IN (&ExcludeDocumentTypes) ELSE TRUE END
	|ORDER BY
	|	AllDocuments.Date";
	Return QueryTxt
EndFunction