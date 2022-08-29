// @strict-types


// Init print param.
// 
// Parameters:
//  Ref - DocumentRef
// 
// Returns:
//  Structure - Init print param:
// * SpreadsheetDoc - SpreadsheetDocument -
// * RefDocument - DocumentRef 
// * CountCopy - Number -
// * NameTemplate - String -
// * BuilderLayout - Boolean -
// * ModelData - String -
// * ModelLayout - String -
Function InitPrintParam(Ref) Export
	Param = New Structure();
	Param.Insert("SpreadsheetDoc", New SpreadsheetDocument);
	Param.Insert("RefDocument", Ref);
	Param.Insert("CountCopy", 1);
	Param.Insert("NameTemplate", "");
	Param.Insert("BuilderLayout", False);
	Param.Insert("ModelData", "");
	Param.Insert("ModelLayout", "");	
	Return  Param; 
EndFunction

// Build spreadsheet doc.
// 
// Parameters:
//  RefDocument - DocumentRef
//  NameTemplate - String
// 
// Returns:
//  SpreadsheetDocument - SpreadsheetDocument
Function BuildSpreadsheetDoc(RefDocument, NameTemplate) Export
	Manager = ObjectManagerByLink(RefDocument);
	Result = Manager.Print(RefDocument, NameTemplate);
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
//  Result -- String
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