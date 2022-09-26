// @strict-types

// Init print param.
// 
// Parameters:
//  Ref - DocumentRef
//  LayoutLang - String - Layout lang
//  DataLang - String - Data lang
// 
// Returns:
//  Structure - Init print param:
// * SpreadsheetDoc - SpreadsheetDocument -
// * RefDocument - DocumentRef 
// * CountCopy - Number -
// * NameTemplate - String -
// * BuilderLayout - Boolean -
// * DataLang - String -
// * LayoutLang - String -
Function InitPrintParam(Ref, Val LayoutLang = Undefined, Val DataLang = Undefined) Export
	If LayoutLang = Undefined Then
		LayoutLang = LocalizationReuse.GetLocalizationCode();
	EndIf;
	If DataLang = Undefined Then
		DataLang = LocalizationReuse.GetLocalizationCode();
	EndIf;
	Param = New Structure();
	Param.Insert("SpreadsheetDoc", New SpreadsheetDocument);
	Param.Insert("RefDocument", Ref);
	Param.Insert("CountCopy", 1);
	Param.Insert("NameTemplate", "");
	Param.Insert("BuilderLayout", False);
	Param.Insert("LayoutLang", LayoutLang);
	Param.Insert("DataLang", DataLang);
	Return  Param; 
EndFunction

// Build spreadsheet doc.
// 
// Parameters:
//  RefDocument - DocumentRef
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - SpreadsheetDocument
Function BuildSpreadsheetDoc(RefDocument, Param) Export
	Manager = ObjectManagerByLink(RefDocument);
	Result = Manager.Print(RefDocument, Param);
	Return Result;	
EndFunction

// Object manager by link.
// 
// Parameters:
//  Ref - DocumentRef - Ref
// 
// Returns:
//  DocumentManager.SalesOrder, Undefined - Object manager by link
Function ObjectManagerByLink(Ref) Export
	Return ServiceSystemServer.GetManagerByMetadata(Ref.Metadata());
EndFunction
  
// Get synonym template.
// 
// Parameters:
//  Ref - DocumentRef -
//  NameTemplate - String -
// 
// Returns:
//  Result - String -
Function GetSynonymTemplate(Ref, NameTemplate) Export
	Try
		Result = Ref.Metadata().Templates.Find(NameTemplate).Synonym;
		If Not ValueIsFilled(Result) Then
			Result = NameTemplate;	
		EndIf;		
	Except
		Result = NameTemplate;
	EndTry;
	
	Return Result;
EndFunction

// Language name by code.
// 
// Parameters:
//  CodeL - String -
// 
// Returns:
//  Undefined, String - LanguageName By Code
Function LanguageNameByCode(CodeL) Export
	For Each It In Metadata.Languages Do
		If StrCompare(CodeL, It.LanguageCode) = 0 Then
			Return It.Name;
		EndIf;
	EndDo;
	Return Undefined;
EndFunction

// Code by language name.
// 
// Parameters:
//  NameL - string
// 
// Returns:
//  Undefined, String - Code by language name
Function CodeByLanguageName(NameL) Export
	For Each It In Metadata.Languages Do
		If StrCompare(NameL, It.Name) = 0 Then
			Return It.LanguageCode;
		EndIf;
	EndDo;
	Return Undefined;
EndFunction