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
Function InitPrintParam(Ref) Export
	Param = New Structure();
	Param.Insert("SpreadsheetDoc", New SpreadsheetDocument);
	Param.Insert("RefDocument", Ref);
	Param.Insert("CountCopy", 1);
	Param.Insert("NameTemplate", "");
	
	Return  Param; 
EndFunction
