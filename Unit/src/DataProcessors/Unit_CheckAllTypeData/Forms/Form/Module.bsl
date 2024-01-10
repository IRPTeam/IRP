// @strict-types

&AtClient
Procedure Check(Command)
	CheckAtServer();
EndProcedure

&AtServer
Procedure CheckAtServer()
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
	|	AllDocuments.Ref.Posted
	|
	|ORDER BY
	|	AllDocuments.Date";
	
	Query = New Query(QueryTxt);
	Result = Query.Execute().Unload();
	
EndProcedure

