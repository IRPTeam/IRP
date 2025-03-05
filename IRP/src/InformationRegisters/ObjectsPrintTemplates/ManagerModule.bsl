#Region AccessObject

// Get access key.
// See Role.TemplateInformationRegisters
// 
// Returns:
//  Structure - Get access key:
Function GetAccessKey() Export
	Return New Structure();
EndFunction

#EndRegion

// Get objects for print template.
// 
// Parameters:
//  PrintTemplate - CatalogRef.PrintFormTemplates - Print template
// 
// Returns:
//  Array of CatalogRef.AddAttributeAndPropertySets - Get objects for print template
Function GetObjectsForPrintTemplate(PrintTemplate) Export
	
	Query = New Query;
	Query.SetParameter("PrintTemplate", PrintTemplate);
	
	Query.Text =
	"SELECT
	|	ObjectsPrintTemplates.Object
	|FROM
	|	InformationRegister.ObjectsPrintTemplates AS ObjectsPrintTemplates
	|WHERE
	|	ObjectsPrintTemplates.PrintTemplate = &PrintTemplate";
	
	Return Query.Execute().Unload().UnloadColumn(0);
	
EndFunction
