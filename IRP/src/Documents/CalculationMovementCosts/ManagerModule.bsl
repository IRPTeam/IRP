
Function GetInformationAboutMovements(Ref) Export
	Str = New Structure();
	Str.Insert("QueryParameters", New Structure());
	Str.Insert("QueryTextsMasterTables", New Array());
	Str.Insert("QueryTextsSecondaryTables", New Array());
	Return Str;
EndFunction
