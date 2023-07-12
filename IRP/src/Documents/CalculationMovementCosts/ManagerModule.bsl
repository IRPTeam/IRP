#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting_Info

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", New Array);
	Str.Insert("QueryTextsSecondaryTables", New Array);
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure;
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

#EndRegion

#Region Posting_SourceTable

#EndRegion

#Region Posting_MainTables

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
	AccessKeyMap.Insert("Company", Obj.Company);
	Return AccessKeyMap;
EndFunction

#EndRegion