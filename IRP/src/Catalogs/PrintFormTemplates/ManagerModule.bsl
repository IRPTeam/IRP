
#Region Public

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
		TemplateData = New TextDocument;
		TemplateDataText = Template.Template.Get();
		If TypeOf(TemplateDataText) = Type("String") Then
			TemplateData.SetText(TemplateDataText);
		EndIf;
		
	ElsIf Template.PrintFormType = Enums.PrintFormTypes.MXL Then
		TemplateData = Template.Template.Get();
		If TypeOf(TemplateData) <> Type("SpreadsheetDocument") Then
			TemplateData = New SpreadsheetDocument;
		EndIf;
		
	Else
		Return New SpreadsheetDocument;
	EndIf;
	
	TemplateInfo = GetTemplateDataInfo(Template, Source);
	ParametersValueMap = GetParametersValueMap(TemplateInfo, Source);
	
	If Template.PrintFormType = Enums.PrintFormTypes.TXT Then
		Return BuildResult_TXT(TemplateData, TemplateInfo, ParametersValueMap, ReturnAsSpreadsheet);
		
	ElsIf Template.PrintFormType = Enums.PrintFormTypes.MXL Then
		Return BuildResult_MXL(TemplateData, TemplateInfo, ParametersValueMap);
		
	EndIf;

EndFunction

// Get template table info
// 
// Parameters:
//  TableData - Map, Undefined - Table data map
//  CurrentRow - Structure, Undefined - Current row data
//  RowNumber - Number - Current row number
//  TableName - String - Table name
// 
// Returns:
//  Structure - Create table info:
// * TableData - Map - 
// * CurrentRow - Structure - 
// * RowNumber - Number - 
// * TableName - String - 
Function GetTemplateTableInfo(Val TableData = Undefined, Val CurrentRow = Undefined, RowNumber = 0, TableName = "") Export
	
	If TableData = Undefined Then
		TableData = New Map;
	EndIf;
	If CurrentRow = Undefined Then
		CurrentRow = New Structure;
	EndIf;
	
	TableInfo = New Structure;
	TableInfo.Insert("TableData", TableData);
	TableInfo.Insert("CurrentRow", CurrentRow);
	TableInfo.Insert("RowNumber", RowNumber);
	TableInfo.Insert("TableName", TableName);
	
	Return TableInfo;
	
EndFunction

// Get parameter value.
// 
// Parameters:
//  Expression - String - Expression
//  Source - AnyRef - Source
//  TableInfo - See GetTemplateTableInfo
// 
// Returns:
//  String
//@skip-check module-unused-local-variable
Function GetParameterValue(Val Expression, Val Source, Val TableInfo = Undefined) Export
	
	Result = "";
	
	If TableInfo = Undefined Then
		TableInfo = GetTemplateTableInfo();
	EndIf;
	
	TableData = New Map;
	RowNumber = TableInfo.RowNumber;
	CurrentRow = TableInfo.CurrentRow;					
	
	For Each TableDataKeyValue In TableInfo.TableData Do
		If TypeOf(TableDataKeyValue.Value) = Type("String") Then
			Try
				TableValue = GetTableValue(TableDataKeyValue.Value, Source);
				TableCount = TableValue.Count(); // checking for rows
				TableData.Insert(TableDataKeyValue.Key, TableValue);
			Except 
				TableData.Insert(TableDataKeyValue.Key, New Array);
			EndTry;
		Else
			TableData.Insert(TableDataKeyValue.Key, TableDataKeyValue.Value);
		EndIf;
	EndDo;
	
	// for formula testing
	If TableInfo.TableName <> "" And CurrentRow = Undefined Then
		TableValue = TableData[TableInfo.TableName];
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

#EndRegion

#Region Private

// Get template data info.
// 
// Parameters:
//  Template - CatalogRef.PrintFormTemplates - Template
//  Source - AnyRef - Source
// 
// Returns:
//  Structure - Get template data info:
// * Template - CatalogRef.PrintFormTemplates - Template 
// * TableMap - Map - 
// * RepeatingAreas - Array - 
Function GetTemplateDataInfo(Template, Source)
	TableMap = New Map;
	TableMap.Insert("", New Array(1));
	RepeatingAreas = New Array;
	If Template.UseTables Then
		For Each TableRow In Template.Tables Do
			TableMap.Insert(TableRow.Name, GetTableValue(TableRow.Expression, Source));
			If TableRow.RepeatingArea Then
				RepeatingAreas.Add(TableRow);
			EndIf;
		EndDo;
	EndIf;
	Result = New Structure;
	Result.Insert("Template", Template);
	Result.Insert("TableMap", TableMap);
	Result.Insert("RepeatingAreas", RepeatingAreas);
	Return Result;
EndFunction

// Get parameters value map.
// 
// Parameters:
//  TemplateInfo - See GetTemplateDataInfo
//  Source - AnyRef - Source
// 
// Returns:
//  Map - Get parameters value map
Function GetParametersValueMap(TemplateInfo, Source)
	ParametersValueMap = New Map;
	ParametersValueMap[""] = New Map;
	For Each TableKeyValue In TemplateInfo.TableMap Do
		TableName = TableKeyValue.Key;
		TableValue = TableKeyValue.Value;
		CurrentRowIndex = 0;
		ParametersValueMap[TableName] = New Map;
		For Each CurrentTableValueRow In TableValue Do
			ParametersValueMap[TableName][CurrentRowIndex] = New Map;
			For Each TemplateParameter In TemplateInfo.Template.Parameters Do
				If TemplateParameter.ToDelete Then
					Continue;
				ElsIf Not IsBlankString(TemplateParameter.Table) And TemplateParameter.Table <> TableName Then
					Continue;
				EndIf;
				ParameterValue = GetParameterValue(
						TemplateParameter.Expression, Source, GetTemplateTableInfo(
							TemplateInfo.TableMap, CurrentTableValueRow, CurrentRowIndex + 1, TemplateParameter.Table));
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
	Return ParametersValueMap;
EndFunction

// Build area ranges TXT.
// 
// Parameters:
//  TemplateInfo - See GetTemplateDataInfo
//  TXT_Template - TextDocument - TXT template
// 
// Returns:
//  ValueTable - Build area ranges TXT:
// * Table - String -
// * Template - TextDocument -
Function BuildAreaRanges_TXT(TemplateInfo, TXT_Template)
	AreaRanges = New ValueTable;
	AreaRanges.Columns.Add("Table");
	AreaRanges.Columns.Add("Template");
	If TemplateInfo.RepeatingAreas.Count() Then
		NextRow = 1;
		RepeatingAreas = TemplateInfo.Template.Tables.Unload(TemplateInfo.RepeatingAreas);
		RepeatingAreas.Sort("LineStart");
		For Each RepeatingArea In RepeatingAreas Do
			If NextRow < RepeatingArea.LineStart Then
				CurrentArea = New TextDocument();
				For LineNumber = NextRow To RepeatingArea.LineStart-1 Do
					CurrentArea.AddLine(TXT_Template.GetLine(LineNumber));
				EndDo;
				AreaRangeRecord = AreaRanges.Add();
				AreaRangeRecord.Table = "";
				AreaRangeRecord.Template = CurrentArea;
			EndIf;
			CurrentArea = New TextDocument();
			For LineNumber = RepeatingArea.LineStart To RepeatingArea.LineEnd Do
				CurrentArea.AddLine(TXT_Template.GetLine(LineNumber));
			EndDo;
			AreaRangeRecord = AreaRanges.Add();
			AreaRangeRecord.Table = RepeatingArea.Name;
			AreaRangeRecord.Template = CurrentArea;
			NextRow = RepeatingArea.LineEnd + 1;
		EndDo;
		If NextRow <= TXT_Template.LineCount() Then
			CurrentArea = New TextDocument();
			For LineNumber = NextRow To TXT_Template.LineCount() Do
				CurrentArea.AddLine(TXT_Template.GetLine(LineNumber));
			EndDo;
			AreaRangeRecord = AreaRanges.Add();
			AreaRangeRecord.Table = "";
			AreaRangeRecord.Template = CurrentArea;
		EndIf;
	Else
		AreaRangeRecord = AreaRanges.Add();
		AreaRangeRecord.Table = "";
		AreaRangeRecord.Template = TXT_Template;
	EndIf;
	Return AreaRanges;
EndFunction

// Build area ranges MXL.
// 
// Parameters:
//  TemplateInfo - See GetTemplateDataInfo
//  MXL_Template - SpreadsheetDocument - MXL template
// 
// Returns:
//  ValueTable - Build area ranges MXL:
// * Table - String -
// * Template - SpreadsheetDocument -
Function BuildAreaRanges_MXL(TemplateInfo, MXL_Template)
	AreaRanges = New ValueTable;
	AreaRanges.Columns.Add("Table");
	AreaRanges.Columns.Add("Template");
	If TemplateInfo.RepeatingAreas.Count() Then
		NextRow = 1;
		RepeatingAreas = TemplateInfo.Template.Tables.Unload(TemplateInfo.RepeatingAreas);
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
	Return AreaRanges;
EndFunction

// Build result TXT.
// 
// Parameters:
//  TemplateData - TextDocument 
//  TemplateInfo - See GetTemplateDataInfo
//  ParametersValueMap - See GetParametersValueMap
//  ReturnAsSpreadsheet - Boolean - Return as spreadsheet
// 
// Returns:
//  SpreadsheetDocument, String - Build result TXT
Function BuildResult_TXT(TemplateData, TemplateInfo, ParametersValueMap, ReturnAsSpreadsheet)
	Result = New TextDocument();
	AreaRanges = BuildAreaRanges_TXT(TemplateInfo, TemplateData);
	For Each AreaRangeRecord In AreaRanges Do
		CurrentRowIndex = 0;
		CurrentTable = AreaRangeRecord.Table;
		CurrentTemplate = AreaRangeRecord.Template;
		CurrentTableValue = TemplateInfo.TableMap[CurrentTable];
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

// Build result MXL.
// 
// Parameters:
//  TemplateData - TextDocument 
//  TemplateInfo - See GetTemplateDataInfo
//  ParametersValueMap - See GetParametersValueMap
// 
// Returns:
//  SpreadsheetDocument - Build result MXL
Function BuildResult_MXL(TemplateData, TemplateInfo, ParametersValueMap)
	Result = New SpreadsheetDocument();
	AreaRanges = BuildAreaRanges_MXL(TemplateInfo, TemplateData);
	For Each AreaRangeRecord In AreaRanges Do
		CurrentRowIndex = 0;
		CurrentTable = AreaRangeRecord.Table;
		CurrentTemplate = AreaRangeRecord.Template;
		CurrentTableValue = TemplateInfo.TableMap[CurrentTable];
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

#EndRegion