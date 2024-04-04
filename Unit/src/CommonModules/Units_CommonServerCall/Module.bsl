
// Get error value.
// 
// Parameters:
//  Name - String - Name
// 
// Returns:
//  Structure - Get error value:
// * Boolean - Boolean - 
Function GetErrorValue(Name) Export
	
	Ref = Catalogs.Unit_ErrorTypes[Name];
	
	Str = New Structure;
	Str.Insert("Boolean", Ref.Boolean);
	Return Str;
	
EndFunction 