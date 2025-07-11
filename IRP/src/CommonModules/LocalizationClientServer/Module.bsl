// @strict-types

// R.
// 
// Parameters:
//  LangCode - String - Lang code
// 
// Returns:
// 	See Localization.Strings 
Function R(LangCode = "") Export
	
	If IsBlankString(LangCode) Then
		LangCode = LocalizationReuse.GetInterfaceLocalizationCode();
	EndIf;
	Return LocalizationReuse.Strings(LangCode);
EndFunction
