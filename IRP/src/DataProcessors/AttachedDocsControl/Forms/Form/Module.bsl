#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	Object.Period.StartDate = BegOfYear(CurrentDate());
	Object.Period.EndDate = EndOfYear(CurrentDate());
	
	FillDocumentsToControl();

EndProcedure

#EndRegion

#Region Private

&AtServerNoContext
Function GetArrayMetaDocsToControl()
	
	ArrayDocsNames = New Array;
	
	Query = New Query;
	Query.Text = 
	"SELECT
	|	AttachedDocumentSettings.Description AS Name
	|FROM
	|	Catalog.AttachedDocumentSettings AS AttachedDocumentSettings
	|WHERE
	|	NOT AttachedDocumentSettings.DeletionMark";
	
	QueryResult = Query.Execute();
	
	SelectionDetailRecords = QueryResult.Select();
	While SelectionDetailRecords.Next() Do
		ArrayDocsNames.Add(SelectionDetailRecords.Name);
	EndDo;
		
	Return ArrayDocsNames;
	
EndFunction

&AtServer
Procedure FillDocumentsToControl()
	
	Object.Documents.Clear();
	
	DocsNamesToControl = GetArrayMetaDocsToControl(); //Array
	If DocsNamesToControl.Count() = 0 Then
		Return;
	EndIf;

	
	Template = "SELECT Doc.Ref, Doc.Date, VALUETYPE(Doc.Ref) %1 %2 FROM Document.%3 AS Doc WHERE Doc.Date BETWEEN &StartDate AND &EndDate";
	
	Array = New Array;
	For Each DocName In DocsNamesToControl Do
		Array.Add(StrTemplate(Template, ?(Array.Count(), "", "AS DocumentType"), ?(Array.Count(), "", "INTO AllDocuments"), DocName));
	EndDo;

	QueryTxt = StrConcat(Array, Chars.LF + "UNION ALL" + Chars.LF) +	"
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AllDocuments.Date AS DocDate,
	|	AllDocuments.Ref.Author AS Author,
	|	AllDocuments.Ref.Branch AS Branch,
	|	AllDocuments.Ref.Number AS DocNumber,
	|	AllDocuments.Ref AS DocRef,
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
	|
	|ORDER BY
	|	AllDocuments.Date";
	
	Query = New Query(QueryTxt);
	Query.SetParameter("StartDate", Object.Period.StartDate);
	Query.SetParameter("EndDate", Object.Period.EndDate);
	Query.SetParameter("OnlyPosted", True);
	Query.SetParameter("CompanySet", Company.Count() > 0);
	Query.SetParameter("CompanyList", Company.UnloadValues());
	
	QueryResult = Query.Execute();
	SelectionDetailRecords = QueryResult.Select();

	Array = New Array;
	While SelectionDetailRecords.Next() Do
		NewRow = Object.Documents.Add();
		FillPropertyValues(NewRow, SelectionDetailRecords);
	EndDo;

	
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure FillDocuments(Command)
	
	FillDocumentsToControl();
	
EndProcedure


#EndRegion