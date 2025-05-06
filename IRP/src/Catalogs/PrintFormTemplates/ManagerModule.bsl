
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
Function GetParameterValue(Val Expression, Val Source, Val TableData = Undefined, Val CurrentRow = Undefined, Val RowNumber = 0, Val TableName = "") Export
	
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
	
	If TableName <> "" And CurrentRow = Undefined Then
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
	
	TXT_Template_Document = New TextDocument();
	TXT_Template_Document.SetText(TXT_Template);

	TableMap = New Map;
	TableMap.Insert("", New Array(1));
	UsedRepeatingAreas = New Array;
	If Template.UseTables Then
		For Each TableRow In Template.Tables Do
			TableMap.Insert(TableRow.Name, GetTableValue(TableRow.Expression, Source));
			If TableRow.RepeatingArea Then
				UsedRepeatingAreas.Add(TableRow);
			EndIf;
		EndDo;
	EndIf;
	
	ParametersValueMap = New Map;
	ParametersValueMap[""] = New Map;
	For Each TableKeyValue In TableMap Do
		TableName = TableKeyValue.Key;
		TableValue = TableKeyValue.Value;
		CurrentRowIndex = 0;
		ParametersValueMap[TableName] = New Map;
		For Each CurrentTableValueRow In TableValue Do
			ParametersValueMap[TableName][CurrentRowIndex] = New Map;
			For Each TemplateParameter In Template.Parameters Do
				If TemplateParameter.ToDelete Then
					Continue;
				ElsIf Not IsBlankString(TemplateParameter.Table) And TemplateParameter.Table <> TableName Then
					Continue;
				EndIf;
				ParameterValue = GetParameterValue(TemplateParameter.Expression, Source, TableMap, CurrentTableValueRow, CurrentRowIndex + 1, TemplateParameter.Table);
				If ParametersValueMap[TableName] = Undefined Then
					ParametersValueMap[TableName] = New Map;
				EndIf;
				If ParametersValueMap[TableName][CurrentRowIndex] = Undefined Then
					ParametersValueMap[TableName][CurrentRowIndex] = New Map;
				EndIf;
				ParametersValueMap[TableName][CurrentRowIndex][TemplateParameter.Name] = ParameterValue;
			EndDo;
			CurrentRowIndex = CurrentRowIndex + 1;
		EndDo;
	EndDo;
	
	AreaRanges = New ValueTable;
	AreaRanges.Columns.Add("Table");
	AreaRanges.Columns.Add("Template");
	If UsedRepeatingAreas.Count() Then
		NextRow = 1;
		RepeatingAreas = Template.Tables.Unload(UsedRepeatingAreas);
		RepeatingAreas.Sort("LineStart");
		For Each RepeatingArea In RepeatingAreas Do
			If NextRow < RepeatingArea.LineStart Then
				CurrentArea = New TextDocument();
				For LineNumber = NextRow To RepeatingArea.LineStart-1 Do
					CurrentArea.AddLine(TXT_Template_Document.GetLine(LineNumber));
				EndDo;
				AreaRangeRecord = AreaRanges.Add();
				AreaRangeRecord.Table = "";
				AreaRangeRecord.Template = CurrentArea;
			EndIf;
			CurrentArea = New TextDocument();
			For LineNumber = RepeatingArea.LineStart To RepeatingArea.LineEnd Do
				CurrentArea.AddLine(TXT_Template_Document.GetLine(LineNumber));
			EndDo;
			AreaRangeRecord = AreaRanges.Add();
			AreaRangeRecord.Table = RepeatingArea.Name;
			AreaRangeRecord.Template = CurrentArea;
			NextRow = RepeatingArea.LineEnd + 1;
		EndDo;
		If NextRow <= TXT_Template_Document.LineCount() Then
			CurrentArea = New TextDocument();
			For LineNumber = NextRow To TXT_Template_Document.LineCount() Do
				CurrentArea.AddLine(TXT_Template_Document.GetLine(LineNumber));
			EndDo;
			AreaRangeRecord = AreaRanges.Add();
			AreaRangeRecord.Table = "";
			AreaRangeRecord.Template = CurrentArea;
		EndIf;
	Else
		AreaRangeRecord = AreaRanges.Add();
		AreaRangeRecord.Table = "";
		AreaRangeRecord.Template = TXT_Template_Document;
	EndIf;

	Result = New TextDocument();
	For Each AreaRangeRecord In AreaRanges Do
		CurrentRowIndex = 0;
		CurrentTable = AreaRangeRecord.Table;
		CurrentTemplate = AreaRangeRecord.Template;
		CurrentTableValue = TableMap[CurrentTable];
		//@skip-check module-unused-local-variable
		For Each CurrentTableValueRow In CurrentTableValue Do
			CurrentResult = New TextDocument();
			CurrentResult.SetText(CurrentTemplate.GetText());
			CurrentTableParameters = ParametersValueMap[CurrentTable][CurrentRowIndex]; // Map
			For LineNumber = 1 To CurrentResult.LineCount() Do
				LineText = CurrentResult.GetLine(LineNumber);
				If Not IsBlankString(LineText) Then
					For Each ParameterKeyValue In CurrentTableParameters Do
						LineText = StrReplace(LineText, ParameterKeyValue.Key, ParameterKeyValue.Value);
					EndDo;
				EndIf;
				Result.AddLine(LineText);
			EndDo;
			CurrentRowIndex = CurrentRowIndex + 1;
		EndDo;
	EndDo;

	If ReturnAsSpreadsheet Then
		Spreadsheet = New SpreadsheetDocument;
		Spreadsheet.FitToPage = True;
		For LineNumber = 1 To Result.LineCount() Do
			Spreadsheet.Area(LineNumber, 1, LineNumber, 11).Merge();
			Spreadsheet.Area(LineNumber, 1, LineNumber, 11).Text = Result.GetLine(LineNumber);
			Spreadsheet.Area(LineNumber, 1, LineNumber, 11).TextPlacement = SpreadsheetDocumentTextPlacementType.Wrap; 
		EndDo;
		Return Spreadsheet;
	EndIf;

	Return Result.GetText();
	
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
	TableMap.Insert("", New Array(1));
	UsedRepeatingAreas = New Array;
	If Template.UseTables Then
		For Each TableRow In Template.Tables Do
			TableMap.Insert(TableRow.Name, GetTableValue(TableRow.Expression, Source));
			If TableRow.RepeatingArea Then
				UsedRepeatingAreas.Add(TableRow);
			EndIf;
		EndDo;
	EndIf;
	
	ParametersValueMap = New Map;
	ParametersValueMap[""] = New Map;
	For Each TableKeyValue In TableMap Do
		TableName = TableKeyValue.Key;
		TableValue = TableKeyValue.Value;
		CurrentRowIndex = 0;
		ParametersValueMap[TableName] = New Map;
		For Each CurrentTableValueRow In TableValue Do
			ParametersValueMap[TableName][CurrentRowIndex] = New Map;
			For Each TemplateParameter In Template.Parameters Do
				If TemplateParameter.ToDelete Then
					Continue;
				ElsIf Not IsBlankString(TemplateParameter.Table) And TemplateParameter.Table <> TableName Then
					Continue;
				EndIf;
				ParameterValue = GetParameterValue(TemplateParameter.Expression, Source, TableMap, CurrentTableValueRow, CurrentRowIndex + 1, TemplateParameter.Table);
				If ParametersValueMap[TableName] = Undefined Then
					ParametersValueMap[TableName] = New Map;
				EndIf;
				If ParametersValueMap[TableName][CurrentRowIndex] = Undefined Then
					ParametersValueMap[TableName][CurrentRowIndex] = New Map;
				EndIf;
				ParametersValueMap[TableName][CurrentRowIndex][TemplateParameter.Name] = ParameterValue;
			EndDo;
			CurrentRowIndex = CurrentRowIndex + 1;
		EndDo;
	EndDo;
	
	AreaRanges = New ValueTable;
	AreaRanges.Columns.Add("Table");
	AreaRanges.Columns.Add("Template");
	If UsedRepeatingAreas.Count() Then
		NextRow = 1;
		RepeatingAreas = Template.Tables.Unload(UsedRepeatingAreas);
		RepeatingAreas.Sort("LineStart");
		For Each RepeatingArea In RepeatingAreas Do
			If NextRow < RepeatingArea.LineStart Then
				CurrentArea = New SpreadsheetDocument();
				CurrentArea.Put(MXL_Template.GetArea("R"+Format(NextRow,"NG=;")+":R"+Format(RepeatingArea.LineStart-1,"NG=;")));
				AreaRangeRecord = AreaRanges.Add();
				AreaRangeRecord.Table = "";
				AreaRangeRecord.Template = CurrentArea;
			EndIf;
			CurrentArea = New SpreadsheetDocument();
			CurrentArea.Put(MXL_Template.GetArea("R"+Format(RepeatingArea.LineStart,"NG=;")+":R"+Format(RepeatingArea.LineEnd,"NG=;")));
			AreaRangeRecord = AreaRanges.Add();
			AreaRangeRecord.Table = RepeatingArea.Name;
			AreaRangeRecord.Template = CurrentArea;
			NextRow = RepeatingArea.LineEnd + 1;
		EndDo;
		If NextRow <= MXL_Template.TableHeight Then
			CurrentArea = New SpreadsheetDocument();
			CurrentArea.Put(MXL_Template.GetArea("R"+Format(NextRow,"NG=;")+":R"+Format(MXL_Template.TableHeight,"NG=;")));
			AreaRangeRecord = AreaRanges.Add();
			AreaRangeRecord.Table = "";
			AreaRangeRecord.Template = CurrentArea;
		EndIf;
	Else
		AreaRangeRecord = AreaRanges.Add();
		AreaRangeRecord.Table = "";
		AreaRangeRecord.Template = MXL_Template;
	EndIf;

	Result = New SpreadsheetDocument();
	For Each AreaRangeRecord In AreaRanges Do
		CurrentRowIndex = 0;
		CurrentTable = AreaRangeRecord.Table;
		CurrentTemplate = AreaRangeRecord.Template;
		CurrentTableValue = TableMap[CurrentTable];
		//@skip-check module-unused-local-variable
		For Each CurrentTableValueRow In CurrentTableValue Do
			CurrentResult = New SpreadsheetDocument();
			CurrentResult.Put(CurrentTemplate);
			CurrentTableParameters = ParametersValueMap[CurrentTable][CurrentRowIndex]; // Map
			For RowNum = 1 To CurrentResult.TableHeight Do
				For ColNum = 1 To CurrentResult.TableWidth Do
					CellText = CurrentResult.Area("R" + Format(RowNum, "NG=;") + "C" + Format(ColNum, "NG=;")).Text;
					If Not IsBlankString(CellText) Then
						For Each ParameterKeyValue In CurrentTableParameters Do
							CellText = StrReplace(CellText, ParameterKeyValue.Key, ParameterKeyValue.Value);
						EndDo;
						CurrentResult.Area("R" + Format(RowNum, "NG=;") + "C" + Format(ColNum, "NG=;")).Text = CellText;
					EndIf;
				EndDo;
			EndDo;
			Result.Put(CurrentResult);
			CurrentRowIndex = CurrentRowIndex + 1;
		EndDo;
	EndDo;

	Return Result;
	
EndFunction

