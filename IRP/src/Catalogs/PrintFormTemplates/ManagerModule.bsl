
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
		
	ElsIf Template.PrintFormType = Enums.PrintFormTypes.FormattedText Then
		TemplateData = Template.Template.Get();
		If TypeOf(TemplateData) <> Type("FormattedDocument") Then
			TemplateData = New FormattedDocument;
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
		
	ElsIf Template.PrintFormType = Enums.PrintFormTypes.FormattedText Then
		Return BuildResult_FormattedText(TemplateData, TemplateInfo, ParametersValueMap, ReturnAsSpreadsheet);
		
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
	If TableInfo.TableName <> "" And TypeOf(CurrentRow) = Type("Structure") And CurrentRow.Count() = 0 Then
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
// * Tags - Structure - : 
//	** Begin - String - Begin
//	** End - String - End
// * PrintInfo - Undefined, Structure - Print info :
//	** Text - String - Text
//	** Logo - Undefined, BinaryData - Logo
//	** Seal - Undefined, BinaryData - Seal
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
	
	Tags = New Structure;
	Tags.Insert("Begin", "<");
	Tags.Insert("End", ">");
	If Template.PrintFormVariableType = Enums.PrintFormVariableTypes.WikiStyle Then
		Tags.Begin = "[";
		Tags.End = "]";
	ElsIf Template.PrintFormVariableType = Enums.PrintFormVariableTypes.CurlyBrace Then
		Tags.Begin = "{";
		Tags.End = "}";
	EndIf;
	
	PrintInfo = Undefined;
	If Template.UsePrintInformations And Not IsBlankString(Template.PrintInfoPath) Then
		SetSafeMode(True);
		Try
			Result = Catalogs.PrintInfo.EmptyRef();
			Execute(Template.PrintInfoPath);
			If TypeOf(Result) = Type("CatalogRef.PrintInfo") And Not Result.IsEmpty() Then
				PrintInfo = New Structure;
				PrintInfo.Insert("Text", Result.AdditionalPrintInfo);
				
				LogoPicture = Undefined;
				If Result.isLogoSet Then
					Try
						LogoPicture = New Picture(Result.Logo.Get());
					Except EndTry;
				EndIf;
				PrintInfo.Insert("Logo", LogoPicture);
				
				SealPicture = Undefined;
				If Result.isSealSet Then
					Try
						SealPicture = New Picture(Result.Seal.Get());
					Except EndTry;
				EndIf;
				PrintInfo.Insert("Seal", SealPicture);
			EndIf;
		Except EndTry;
		SetSafeMode(False);
	EndIf;
	
	Result = New Structure;
	Result.Insert("Template", Template);
	Result.Insert("TableMap", TableMap);
	Result.Insert("RepeatingAreas", RepeatingAreas);
	Result.Insert("Tags", Tags);
	Result.Insert("PrintInfo", PrintInfo);
	Return Result;
EndFunction

// Get parameters value map.
// 
// Parameters:
//  TemplateInfo - See GetTemplateDataInfo
//  Source - AnyRef - Source
// 
// Returns:
//  Map - Get parameters value map :
//	* Key - String - Table name or empty string for common paramenters
//	* Value - Map - Values of parameters (by line numbers)
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
				ParameterInfo = New Structure("Value, HideEmpty", ParameterValue, TemplateParameter.HideEmpty);
				If ParametersValueMap[TableName] = Undefined Then
					ParametersValueMap[TableName] = New Map;
				EndIf;
				If ParametersValueMap[TableName][CurrentRowIndex] = Undefined Then
					ParametersValueMap[TableName][CurrentRowIndex] = New Map;
				EndIf;
				ParametersValueMap[TableName][CurrentRowIndex][TemplateParameter.Name] = ParameterInfo;
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

// Build area ranges Formatted Text.
// 
// Parameters:
//  TemplateInfo - See GetTemplateDataInfo
//  FormattedText_Template - FormattedDocument - Formatted Text template
// 
// Returns:
//  ValueTable - Build area ranges TXT:
// * Table - String -
// * TemplateItems - Array -
Function BuildAreaRanges_FormattedText(TemplateInfo, FormattedText_Template)
	AreaRanges = New ValueTable;
	AreaRanges.Columns.Add("Table");
	AreaRanges.Columns.Add("TemplateItems");
	
	Paragraphs = New Array; // Array of FormattedDocumentParagraph
	CurrentParagraph = Undefined;
	TextItems = FormattedText_Template.GetItems();
	For Each TextItem In TextItems Do
		If CurrentParagraph <> TextItem.Parent Then
			Paragraphs.Add(TextItem.Parent);
			CurrentParagraph = TextItem.Parent;
		EndIf;
	EndDo;
			
	If TemplateInfo.RepeatingAreas.Count() Then
		NextRow = 1;
		RepeatingAreas = TemplateInfo.Template.Tables.Unload(TemplateInfo.RepeatingAreas);
		RepeatingAreas.Sort("LineStart");
		For Each RepeatingArea In RepeatingAreas Do
			If NextRow < RepeatingArea.LineStart Then
				BuildAreaRow_FormattedText(
					AreaRanges, FormattedText_Template, Paragraphs, NextRow - 1, RepeatingArea.LineStart - 2, "");
			EndIf;
			BuildAreaRow_FormattedText(
				AreaRanges, 
				FormattedText_Template, 
				Paragraphs, 
				RepeatingArea.LineStart - 1, 
				RepeatingArea.LineEnd - 1, 
				RepeatingArea.Name);
			NextRow = RepeatingArea.LineEnd + 1;
		EndDo;
		If NextRow <= Paragraphs.Count() Then
			BuildAreaRow_FormattedText(
				AreaRanges, FormattedText_Template, Paragraphs, NextRow - 1, Paragraphs.Count() - 1, "");
		EndIf;
	Else
		BuildAreaRow_FormattedText(
			AreaRanges, FormattedText_Template, Paragraphs, 0, Paragraphs.Count() - 1, "");
	EndIf;
	Return AreaRanges;
EndFunction

// Build area row formatted text.
// 
// Parameters:
//  AreaRanges - ValueTable - Area ranges
//  FormattedText_Template - FormattedDocument - Formatted text template:
//  Paragraphs - Array - Paragraphs
//  Start - Number - Start
//  End - Number - End
//  TableName - String - Table name
Procedure BuildAreaRow_FormattedText(AreaRanges, FormattedText_Template, Paragraphs, Start, End, TableName)
	For LineIndex = Start To End Do
		CurrentArea = New Array;
		CurrentParagraph = Paragraphs[LineIndex];
		AreaItems = FormattedText_Template.GenerateItems(CurrentParagraph.BeginBookmark, CurrentParagraph.EndBookmark);
		For Each TemplateItem In AreaItems Do
			CurrentArea.Add(TemplateItem);
		EndDo;
		AreaRangeRecord = AreaRanges.Add();
		AreaRangeRecord.Table = TableName;
		AreaRangeRecord.TemplateItems = CurrentArea;
	EndDo;
EndProcedure

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
	
	PrintInfoTextTagName = TemplateInfo.Tags.Begin + "PrintInfo.Text" + TemplateInfo.Tags.End;
	PrintInfoText = ?(TemplateInfo.PrintInfo <> Undefined, TemplateInfo.PrintInfo.Text, "");
	
	AreaRanges = BuildAreaRanges_TXT(TemplateInfo, TemplateData);
	For Each AreaRangeRecord In AreaRanges Do
		CurrentRowIndex = 0;
		CurrentTable = AreaRangeRecord.Table;
		CurrentTemplate = AreaRangeRecord.Template;
		CurrentTableValue = TemplateInfo.TableMap[CurrentTable];
		//@skip-check module-unused-local-variable
		For Each CurrentTableValueRow In CurrentTableValue Do
			CurrentTemplateText = CurrentTemplate.GetText();
			CurrentTemplateText = StrReplace(CurrentTemplateText, PrintInfoTextTagName, PrintInfoText);
			CurrentResult = New TextDocument();
			CurrentResult.SetText(CurrentTemplateText);
			CurrentTableParameters = ParametersValueMap[CurrentTable][CurrentRowIndex]; // Map
			For LineNumber = 1 To CurrentResult.LineCount() Do
				LineText = CurrentResult.GetLine(LineNumber);
				SkipThisLine = False;
				If Not IsBlankString(LineText) Then
					For Each ParameterKeyValue In CurrentTableParameters Do
						ParamValue = ParameterKeyValue.Value.Value;
						ParamHideEmpty = ParameterKeyValue.Value.HideEmpty;
						If StrFind(LineText, ParameterKeyValue.Key) > 0 Then
							If ParamHideEmpty and Not ValueIsFilled(ParamValue) Then
								SkipThisLine = True;
								Break;
							EndIf;
							LineText = StrReplace(LineText, ParameterKeyValue.Key, ParamValue);
						EndIf;
					EndDo;
				EndIf;
				If Not SkipThisLine Then
					Result.AddLine(LineText);
				EndIf;
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
	
	PrintInfoTextTagName = TemplateInfo.Tags.Begin + "PrintInfo.Text" + TemplateInfo.Tags.End;
	PrintInfoText = ?(TemplateInfo.PrintInfo <> Undefined, TemplateInfo.PrintInfo.Text, "");
	PrintInfoLogoTagName = TemplateInfo.Tags.Begin + "PrintInfo.Logo" + TemplateInfo.Tags.End;
	PrintInfoLogo = ?(TemplateInfo.PrintInfo <> Undefined, TemplateInfo.PrintInfo.Logo, Undefined);
	PrintInfoSealTagName = TemplateInfo.Tags.Begin + "PrintInfo.Seal" + TemplateInfo.Tags.End;
	PrintInfoSeal = ?(TemplateInfo.PrintInfo <> Undefined, TemplateInfo.PrintInfo.Seal, Undefined);
	
	AreaRanges = BuildAreaRanges_MXL(TemplateInfo, TemplateData);
	For Each AreaRangeRecord In AreaRanges Do
		CurrentRowIndex = 0;
		CurrentTable = AreaRangeRecord.Table;
		CurrentTemplate = AreaRangeRecord.Template;
		CurrentTableValue = TemplateInfo.TableMap[CurrentTable];
		//@skip-check module-unused-local-variable
		For Each CurrentTableValueRow In CurrentTableValue Do
			CurrentTableParameters = ParametersValueMap[CurrentTable][CurrentRowIndex]; // Map
			For RowNum = 1 To CurrentTemplate.TableHeight Do
				SkipThisLine = False;
				CurrentResult = New SpreadsheetDocument();
				CurrentResult.Put(CurrentTemplate.GetArea("R" + Format(RowNum, "NG=;")));
				For ColNum = 1 To CurrentResult.TableWidth Do
					If SkipThisLine Then
						Break;
					EndIf;
					CellText = CurrentResult.Area("R1C" + Format(ColNum, "NG=;")).Text;
					If Not IsBlankString(CellText) Then
						If CellText = PrintInfoLogoTagName And PrintInfoLogo <> Undefined Then
							CurrentResult.Area("R1C" + Format(ColNum, "NG=;")).Text = "";
							CurrentResult.Area("R1C" + Format(ColNum, "NG=;")).Picture = PrintInfoLogo;
							Continue;
						EndIf;
						If CellText = PrintInfoSealTagName And PrintInfoSeal <> Undefined Then
							CurrentResult.Area("R1C" + Format(ColNum, "NG=;")).Text = "";
							CurrentResult.Area("R1C" + Format(ColNum, "NG=;")).Picture = PrintInfoSeal;
							Continue;
						EndIf;
						CellText = StrReplace(CellText, PrintInfoTextTagName, PrintInfoText);
						For Each ParameterKeyValue In CurrentTableParameters Do
							ParamValue = ParameterKeyValue.Value.Value;
							ParamHideEmpty = ParameterKeyValue.Value.HideEmpty;
							If StrFind(CellText, ParameterKeyValue.Key) > 0 Then
								If ParamHideEmpty and Not ValueIsFilled(ParamValue) Then
									SkipThisLine = True;
									Break;
								EndIf;
								CellText = StrReplace(CellText, ParameterKeyValue.Key, ParamValue);
							EndIf;
						EndDo;
						CurrentResult.Area("R1C" + Format(ColNum, "NG=;")).Text = CellText;
					EndIf;
				EndDo;
				If Not SkipThisLine Then
					Result.Put(CurrentResult);
				EndIf;
			EndDo;
			CurrentRowIndex = CurrentRowIndex + 1;
		EndDo;
	EndDo;
	Return Result;
EndFunction

// Build result Formatted Text.
// 
// Parameters:
//  Template - FormattingDocument - Template data 
//  TemplateInfo - See GetTemplateDataInfo
//  ParametersValueMap - See GetParametersValueMap
//  ReturnAsSpreadsheet - Boolean - Return as spreadsheet
// 
// Returns:
//  SpreadsheetDocument, String - Build result Formatted Text
Function BuildResult_FormattedText(Template, TemplateInfo, ParametersValueMap, ReturnAsSpreadsheet)
	Result = New FormattedDocument();
	
	PrintInfoTextTagName = TemplateInfo.Tags.Begin + "PrintInfo.Text" + TemplateInfo.Tags.End;
	PrintInfoText = ?(TemplateInfo.PrintInfo <> Undefined, TemplateInfo.PrintInfo.Text, "");
	PrintInfoLogoTagName = TemplateInfo.Tags.Begin + "PrintInfo.Logo" + TemplateInfo.Tags.End;
	PrintInfoLogo = ?(TemplateInfo.PrintInfo <> Undefined, TemplateInfo.PrintInfo.Logo, Undefined);
	PrintInfoSealTagName = TemplateInfo.Tags.Begin + "PrintInfo.Seal" + TemplateInfo.Tags.End;
	PrintInfoSeal = ?(TemplateInfo.PrintInfo <> Undefined, TemplateInfo.PrintInfo.Seal, Undefined);
	
	FormattedDocParts = New Array;
	AreaRanges = BuildAreaRanges_FormattedText(TemplateInfo, Template);
	For Each AreaRangeRecord In AreaRanges Do
		CurrentRowIndex = 0;
		CurrentTable = AreaRangeRecord.Table;
		TemplateItems = AreaRangeRecord.TemplateItems;
		CurrentTableValue = TemplateInfo.TableMap[CurrentTable];
		//@skip-check module-unused-local-variable
		For Each CurrentTableValueRow In CurrentTableValue Do
			FormattedRowParts = New Array;
			CurrentTableParameters = ParametersValueMap[CurrentTable][CurrentRowIndex]; // Map
			For Each TemplateItem In TemplateItems Do
				If TypeOf(TemplateItem) = Type("FormattedDocumentPicture") Then
					FormattedRowParts.Add(TemplateItem.Picture);
				ElsIf TypeOf(TemplateItem) = Type("FormattedDocumentText") Then
					SkipThisLine = False;
					LineText = TemplateItem.Text;
					If Not IsBlankString(LineText) Then
						If LineText = PrintInfoLogoTagName And PrintInfoLogo <> Undefined Then
							FormattedRowParts.Add(PrintInfoLogo);
							Continue;
						EndIf;
						If LineText = PrintInfoSealTagName And PrintInfoSeal <> Undefined Then
							FormattedRowParts.Add(PrintInfoSeal);
							Continue;
						EndIf;
						LineText = StrReplace(LineText, PrintInfoTextTagName, PrintInfoText);
						For Each ParameterKeyValue In CurrentTableParameters Do
							ParamValue = ParameterKeyValue.Value.Value;
							ParamHideEmpty = ParameterKeyValue.Value.HideEmpty;
							If StrFind(LineText, ParameterKeyValue.Key) > 0 Then
								If ParamHideEmpty and Not ValueIsFilled(ParamValue) Then
									SkipThisLine = True;
									Break;
								EndIf;
								LineText = StrReplace(LineText, ParameterKeyValue.Key, ParamValue);
							EndIf;
						EndDo;
					EndIf;
					If Not SkipThisLine Then
						NewLine = New FormattedString(
							LineText, TemplateItem.Font, TemplateItem.TextColor, TemplateItem.BackColor, TemplateItem.URL);
						FormattedRowParts.Add(NewLine);
					EndIf;
				EndIf;
			EndDo;
			If FormattedRowParts.Count() = 1 And TypeOf(FormattedRowParts[0]) = Type("Picture") Then
				FormattedDocParts.Add(FormattedRowParts[0]);				
			Else
				FormattedDocParts.Add(New FormattedString(FormattedRowParts));
			EndIf;
			CurrentRowIndex = CurrentRowIndex + 1;
		EndDo;
	EndDo;
	If ReturnAsSpreadsheet Then
		Spreadsheet = New SpreadsheetDocument;
		Spreadsheet.FitToPage = True;
		For LineNumber = 1 To FormattedDocParts.Count() Do
			CurrentData = FormattedDocParts[LineNumber - 1];
			Spreadsheet.Area(LineNumber, 1, LineNumber, 11).Merge();
			If TypeOf(CurrentData) = Type("Picture") Then
				Spreadsheet.Area(LineNumber, 1, LineNumber, 11).Picture = CurrentData;
				Spreadsheet.Area(LineNumber, 1, LineNumber, 11).PictureSize = PictureSize.RealSize;
			Else
				Spreadsheet.Area(LineNumber, 1, LineNumber, 11).Text = CurrentData;
				Spreadsheet.Area(LineNumber, 1, LineNumber, 11).TextPlacement = SpreadsheetDocumentTextPlacementType.Wrap; 
			EndIf;
		EndDo;
		Return Spreadsheet;
	EndIf;
	Result.SetFormattedString(New FormattedString(FormattedDocParts));
	Return Result;
EndFunction

#EndRegion