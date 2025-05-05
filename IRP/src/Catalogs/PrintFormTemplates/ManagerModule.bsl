
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
		
	ElsIf Template.PrintFormType = Enums.PrintFormTypes.MXL Then
		Return GetPrintForm_MXL(Template, Source);
		
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
//@skip-check module-unused-local-variable
Function GetParameterValue(Val Expression, Val Source, Val TableName = "", Val TableData = Undefined) Export
	
	Result = "";
	
	_TableData = New Map;
	If TypeOf(TableData) <> Type("Map") Then
		TableData = New Map;
	EndIf;
	
	For Each TableDataKeyValue In TableData Do
		If TypeOf(TableDataKeyValue.Value) = Type("String") Then
			Try
				TableValue = GetTableValue(TableDataKeyValue.Value, Source);
				If TableValue.Count() > 0 Then
					TableValue = TableValue;
				EndIf;
			Except 
				TableValue = New Array;
			EndTry;
			_TableData.Insert(TableDataKeyValue.Key, TableValue);
		Else
			_TableData.Insert(TableDataKeyValue.Key, TableDataKeyValue.Value);
		EndIf;
	EndDo;
	TableData = _TableData;
	
	RowNumber = 0;
	CurrentRow = Undefined;
	If TableName <> "" Then
		TableValue = TableData[TableName];
		If TableValue.Count() > 0 Then
			RowNumber = 1;
			CurrentRow = TableValue[0];					
		EndIf;
	EndIf;
	
	SetSafeMode(True);
	Execute(Expression);
	
	Return String(Result);

EndFunction

// Get table value.
// 
// Parameters:
//  Expression - String - Expression
//  Source - AnyRef - Source
// 
// Returns:
//  Array, ValueTable - Get table value
Function GetTableValue(Val Expression, Val Source) Export
	
	Result = Undefined;
	
	SetSafeMode(True);
	Execute(Expression);
	
	Return Result;

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

	TableMap = New Map;
	If Template.UseTables Then
		For Each TableRow In Template.Tables Do
			TableMap.Insert(TableRow.Name, GetTableValue(TableRow.Expression, Source));
		EndDo;
	EndIf;

	For Each TemplateParameter In Template.Parameters Do
		If TemplateParameter.ToDelete Then
			Continue;
		EndIf;
		ParameterValue = GetParameterValue(TemplateParameter.Expression, Source, TemplateParameter.Table, TableMap);
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

// Get print form MXL.
// 
// Parameters:
//  Template - CatalogRef.PrintFormTemplates - Template
//  Source - AnyRef - Source
// 
// Returns:
//  SpreadsheetDocument - Get print form
Function GetPrintForm_MXL(Template, Source)
	
	MXL_Template = Template.Template.Get();
	If TypeOf(MXL_Template) <> Type("SpreadsheetDocument") Then
		MXL_Template = New SpreadsheetDocument;
	EndIf;

	TableMap = New Map;
	If Template.UseTables Then
		For Each TableRow In Template.Tables Do
			TableMap.Insert(TableRow.Name, GetTableValue(TableRow.Expression, Source));
		EndDo;
	EndIf;

	ParametersValueMap = New Map;
	For Each TemplateParameter In Template.Parameters Do
		If TemplateParameter.ToDelete Then
			Continue;
		EndIf;
		ParameterValue = GetParameterValue(TemplateParameter.Expression, Source, TemplateParameter.Table, TableMap);
		If ParametersValueMap[TemplateParameter.Table] = Undefined Then
			ParametersValueMap[TemplateParameter.Table] = New Map;
		EndIf;
		ParametersValueMap[TemplateParameter.Table][TemplateParameter.Name] = ParameterValue;
	EndDo;
	
	For RowNum = 1 To MXL_Template.TableHeight Do
		CurrentTable = ""; //TODO Using repeated table
		CurrentParameters = ParametersValueMap[CurrentTable]; // Map
		For ColNum = 1 To MXL_Template.TableWidth Do
			CellText = MXL_Template.Area("R" + Format(RowNum, "NG=;") + "C" + Format(ColNum, "NG=;")).Text;
			If Not IsBlankString(CellText) Then
				For Each ParameterKeyValue In CurrentParameters Do
					CellText = StrReplace(CellText, ParameterKeyValue.Key, ParameterKeyValue.Value);
				EndDo;
				MXL_Template.Area("R" + Format(RowNum, "NG=;") + "C" + Format(ColNum, "NG=;")).Text = CellText;
			EndIf;
		EndDo;
	EndDo;

	Return MXL_Template;
	
EndFunction

