// Get print info.
// 
// Parameters:
//  PrintInfo - CatalogRef.PrintInfo, CatalogRef.Companies - Print info
// 
// Returns:
//  Structure - Get print info:
// * Logo - Picture - 
// * Seal - Picture - 
// * AdditionalPrintInfo - String - 
// * DefaultColor - Color - 
Function GetPrintInfo(Val PrintInfo) Export
	
	If TypeOf(PrintInfo) = Type("CatalogRef.PrintInfo") Then
		PrintInfoRef = PrintInfo;
	Else
		PrintInfoRef = PrintInfo.PrintInfo;
	EndIf;
	
	Str = New Structure;
	Str.Insert("Logo", PrintInfoRef.Logo.Get());
	Str.Insert("Seal", PrintInfoRef.Seal.Get());
	Str.Insert("AdditionalPrintInfo", PrintInfoRef.AdditionalPrintInfo);
	If Not IsBlankString(PrintInfoRef.DefaultColor) Then
		Str.Insert("DefaultColor", CommonFunctionsServer.DeserializeJSONUseXDTO(PrintInfoRef.DefaultColor));
	Else
		Str.Insert("DefaultColor", Undefined);
	EndIf;
	
	Return Str;
EndFunction

// Get print info.
// 
// Parameters:
//  PrintInfo - CatalogRef.PrintInfo, CatalogRef.Companies - Print info
// 
// Returns:
//  Color 
Function GetDefaultColor(Val PrintInfo) Export
	If TypeOf(PrintInfo) = Type("CatalogRef.PrintInfo") Then
		PrintInfoRef = PrintInfo;
	Else
		PrintInfoRef = PrintInfo.PrintInfo;
	EndIf;
	
	If Not IsBlankString(PrintInfoRef.DefaultColor) Then
		Return CommonFunctionsServer.DeserializeJSONUseXDTO(PrintInfoRef.DefaultColor);
	Else
		Return Undefined;
	EndIf;
EndFunction