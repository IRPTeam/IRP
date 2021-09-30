// @strict-types

// R.
// 
// Parameters:
//  LangCode - String - Lang code
// 
// Returns:
// 	see Localization.Strings - Localizations strings
Function R(LangCode = "") Export
	If IsBlankString(LangCode) Then
		LangCode = String(LocalizationReuse.GetSessionParameter("InterfaceLocalizationCode"));
	EndIf;
	Return LocalizationReuse.Strings(LangCode);
EndFunction
