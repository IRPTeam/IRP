Function R(LangCode = Undefined) Export
	If LangCode = Undefined Then
		LangCode = LocalizationReuse.GetSessionParameter("InterfaceLocalizationCode");
	EndIf;
	Return LocalizationReuse.Strings(LangCode);
EndFunction