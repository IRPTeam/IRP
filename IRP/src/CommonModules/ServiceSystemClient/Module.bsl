// Set session parameter.
// 
// Parameters:
//  Name - String - Name
//  Value - Arbitrary - Value parameter
//  AddInfo - Undefined - Add info
Procedure SetSessionParameter(Name, Value, AddInfo = Undefined) Export
	ServiceSystemServer.SetSessionParameter(Name, Value, AddInfo);
EndProcedure

// Get program title.
// 
// Returns:
//  String - Program title
Function GetProgramTitle() Export
	Return ServiceSystemServer.GetProgramTitle();
EndFunction