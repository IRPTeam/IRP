Function Strings(LangCode) Export
	Return LocalizationServer.Strings(LangCode);
EndFunction

Function CatalogDescription(Ref, LangCode = "", AddInfo = Undefined) Export
	Return LocalizationServer.CatalogDescription(Ref, LangCode, AddInfo);
EndFunction

Function CatalogDescriptionWithAddAttributes(Ref, LangCode = "", AddInfo = Undefined) Export
	Return LocalizationServer.CatalogDescriptionWithAddAttributes(Ref, LangCode, AddInfo);
EndFunction

Function AllDescription(AddInfo = Undefined) Export
	Return LocalizationServer.AllDescription(AddInfo);
EndFunction

Function UseMultiLanguage(MetadataFullName, AddInfo = Undefined) Export
	Return LocalizationServer.UseMultiLanguage(MetadataFullName, AddInfo);
EndFunction

Function GetLocalizationCode(AddInfo = Undefined) Export
	Return LocalizationServer.GetLocalizationCode(AddInfo);
EndFunction

Function FieldsListForDescriptions(SourceType) Export
	Return LocalizationServer.FieldsListForDescriptions(SourceType);
EndFunction

Function UserLanguageCode() Export
	Return SessionParameters.LocalizationCode;
EndFunction