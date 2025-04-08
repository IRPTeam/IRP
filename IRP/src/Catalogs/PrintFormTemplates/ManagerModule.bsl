
// Get print form.
// 
// Parameters:
//  Template - CatalogRef.PrintFormTemplates - Template
//  Source - AnyRef - Source
//  ReturnAsSpreadsheet - Boolean - Return as spreadsheet
// 
// Returns:
//  SpreadsheetDocument - Get print form
Function GetPrintForm(Template, Source, ReturnAsSpreadsheet=False) Export
	
	If Template.PrintFormType = Enums.PrintFormTypes.TXT Then
		Return GetPrintForm_TXT(Template, Source, ReturnAsSpreadsheet);
		
	EndIf;
	
	Return New SpreadsheetDocument;
	
EndFunction

// Get parameter value.
// 
// Parameters:
//  Expression - String - Expression
//  Source - AnyRef - Source
// 
// Returns:
//  String
Function GetParameterValue(Val Expression, Val Source) Export
	
	Result = "";
	
	SetSafeMode(True);
	Execute(Expression);
	
	Return String(Result);

EndFunction

// Get print form TXT.
// 
// Parameters:
//  Template - CatalogRef.PrintFormTemplates - Template
//  Source - AnyRef - Source
//  ReturnAsSpreadsheet - Boolean - Return as spreadsheet
// 
// Returns:
//  String, SpreadsheetDocument - Get print form
Function GetPrintForm_TXT(Template, Source, ReturnAsSpreadsheet)
	
	TXT_Template = Template.Template.Get();
	If TypeOf(TXT_Template) <> Type("String") Then
		TXT_Template = "";
	EndIf;

	For Each TemplateParameter In Template.Parameters Do
		ParameterValue = GetParameterValue(TemplateParameter.Expression, Source);
		TXT_Template = StrReplace(TXT_Template, TemplateParameter.Name, ParameterValue);
	EndDo;
	
	If ReturnAsSpreadsheet Then
		CurrentNum = 0;
		Spreadsheet = New SpreadsheetDocument;
		Spreadsheet.FitToPage = True;
		LinesArray = StrSplit(TXT_Template, Chars.LF, True);
		For Each LineString In LinesArray Do
			CurrentNum = CurrentNum + 1;
			Spreadsheet.Area(CurrentNum, 1, CurrentNum, 11).Merge();
			Spreadsheet.Area(CurrentNum, 1, CurrentNum, 11).Text = LineString;
			Spreadsheet.Area(CurrentNum, 1, CurrentNum, 11).TextPlacement = SpreadsheetDocumentTextPlacementType.Wrap; 
		EndDo;
		Return Spreadsheet;
	EndIf;

	Return TXT_Template;
	
EndFunction

