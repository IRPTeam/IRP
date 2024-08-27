// @strict-types
 
#Region Public

// See CommonModule.MessagesServer

#EndRegion

#Region Internal

#Region Posting_Info

// Get information about movements.
// 
// Parameters:
//  Ref - DocumentRefDocumentName - Ref
// 
// Returns:
//  Structure - Get information about movements:
// * QueryParameters - Structure - :
// ** Ref - DocumentRefDocumentName
// * QueryTextsMasterTables - Array - 
// * QueryTextsSecondaryTables - Array - 
Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure;
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	Return QueryArray;
EndFunction

#EndRegion

#Region AccessObject

// Get access key.
// 
// Parameters:
//  Obj - DocumentObjectDocumentName -
// 
// Returns:
//  Map
Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	Return AccessKeyMap;
EndFunction

#EndRegion

#Region PRINT_FORM

// Get print form.
// 
// Parameters:
//  Ref - DocumentRefDocumentName - Ref
//  PrintFormName - String - Print form name
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Undefined - Get print form
Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#EndRegion