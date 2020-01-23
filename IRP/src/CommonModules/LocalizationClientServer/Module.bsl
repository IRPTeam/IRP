Function R(LangCode = Undefined) Export
	If LangCode = Undefined Then
		LangCode = ServiceSystemServer.GetSessionParameter("InterfaceLocalizationCode");
	EndIf;
	Return LocalizationReuse.Strings(LangCode);
EndFunction
