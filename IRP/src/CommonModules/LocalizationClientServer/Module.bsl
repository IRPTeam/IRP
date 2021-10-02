// @strict-types

// R.
// 
// Parameters:
//  LangCode - String - Lang code
// 
// Returns:
// 	see LocalizationReuse.Strings - Localizations strings
Function R(LangCode = "") Export
	If IsBlankString(LangCode) Then
		LangCode = String(LocalizationReuse.GetSessionParameter("InterfaceLocalizationCode"));
	EndIf;
	Return LocalizationReuse.Strings(LangCode);
EndFunction
