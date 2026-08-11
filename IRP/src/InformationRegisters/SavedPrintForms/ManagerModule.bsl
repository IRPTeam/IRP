#Region AccessObject

// Get access key.
// See Role.TemplateInformationRegisters
// 
// Returns:
//  Structure - Get access key:
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	Return AccessKeyStructure;
EndFunction

#EndRegion

Procedure SaveToSavedPrintForms(SourceRef, TemplateName, PrintFormTemplate, Result) Export
	SetPrivilegedMode(True);
	Record = CreateRecordManager();
	Record.Source = SourceRef;
	Record.TemplateName = TemplateName;
	Record.PrintFormTemplate = PrintFormTemplate;
	Record.PrintForm = New ValueStorage(Result);
	Record.CreateDate = CommonFunctionsServer.GetCurrentSessionDate();
	Record.Write(True);
EndProcedure

Function GetSavedPrintForm(SourceRef, TemplateName, PrintFormTemplate) Export
	Query = New Query();
	Query.Text = 
	"SELECT ALLOWED
	|	SavedPrintForms.PrintForm AS PrintForm
	|FROM
	|	InformationRegister.SavedPrintForms AS SavedPrintForms
	|WHERE
	|	Source = &Source
	|	AND TemplateName = &Template
	|	AND PrintFormTemplate = &PrintFormTemplate";
	Query.SetParameter("Source", SourceRef);
	Query.SetParameter("Template", TemplateName);
	Query.SetParameter("PrintFormTemplate", PrintFormTemplate);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.PrintForm.Get();
	EndIf;
	Return Undefined;
EndFunction

Procedure ClearSavedPrintForms(SourceRef, TemplateName, PrintFormTemplate) Export
	SetPrivilegedMode(True);
	RecordSet = CreateRecordSet();
	RecordSet.Filter.Source.Set(SourceRef);
	RecordSet.Filter.TemplateName.Set(TemplateName);
	RecordSet.Filter.PrintFormTemplate.Set(PrintFormTemplate);
	RecordSet.Write(True);
EndProcedure