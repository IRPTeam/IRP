
// Strings.
// 
// Parameters:
//  LangCode - String - Lang code
// 
// Returns:
// 	See Localization.Strings
Function Strings(LangCode) Export
	Return LocalizationServer.LocalizationStrings(LangCode);
EndFunction 

// Catalog description.
// 
// Parameters:
//  Ref - CatalogRef - Ref
//  LangCode - String - Lang code
//  AddInfo - Undefined, Structure - Add info
// 
// Returns:
//  String
Function CatalogDescription(Ref, LangCode = "", AddInfo = Undefined) Export
	Return LocalizationServer.CatalogDescription(Ref, LangCode, AddInfo);
EndFunction

// Catalog description with additional attributes.
// 
// Parameters:
//  Ref - CatalogRef - Ref
//  LangCode - String - Lang code
//  AddInfo - Undefined, Structure - Add info
// 
// Returns:
//  String
Function CatalogDescriptionWithAddAttributes(Ref, LangCode = "", AddInfo = Undefined) Export
	Return LocalizationServer.CatalogDescriptionWithAddAttributes(Ref, LangCode, AddInfo);
EndFunction

// All description.
// 
// Parameters:
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Array of String - All description
Function AllDescription(AddInfo = Undefined) Export
	Return LocalizationServer.AllDescription(AddInfo);
EndFunction

// Use multi language for data.
// 
// Parameters:
//  MetadataFullName - String - Metadata full name
//  AddInfo - Undefined, Structure - Add info
// 
// Returns:
//  Boolean - Use multi language for data
Function UseMultiLanguage(Val MetadataFullName, AddInfo = Undefined) Export
	Return LocalizationServer.UseMultiLanguage(MetadataFullName, , AddInfo);
EndFunction

// Fields list for descriptions.
// 
// Parameters:
//  SourceType - CatalogManager - Source type
// 
// Returns:
//  Array of String - Fields list for descriptions
Function FieldsListForDescriptions(Val SourceType) Export
	Return LocalizationServer.FieldsListForDescriptions(String(SourceType));
EndFunction

// Get localization code.
// 
// Parameters:
//  AddInfo - Undefined, Structure - Add info
// 
// Returns:
//  String - Get localization code
Function GetLocalizationCode(AddInfo = Undefined) Export
	Return LocalizationServer.GetLocalizationCode(AddInfo);
EndFunction

// Get interface localization code.
// 
// Parameters:
//  AddInfo - Undefined, Structure - Add info
// 
// Returns:
//  String - Get interface localization code
Function GetInterfaceLocalizationCode(AddInfo = Undefined) Export
	Return LocalizationServer.GetInterfaceLocalizationCode(AddInfo);
EndFunction

// NOTUSE. User language code.
// 
// Returns:
//  String - User language code
Function UserLanguageCode() Export
	Return GetLocalizationCode();
EndFunction

// Get session parameter.
// 
// Parameters:
//  Name - String - Name
// 
// Returns:
//  Arbitrary - Get session parameter
Function GetSessionParameter(Name) Export
	Return ServiceSystemServer.GetSessionParameter(Name);
EndFunction
 
// Metadata languages.
// 
// Returns:
//  Structure - Metadata languages:
//  * Key - String - Lang code
//  * Value - String - Lang description
Function MetadataLanguages() Export
	Result = New Structure;
	For Each It In Metadata.Languages Do
		If It.Name = "HASH" Then
			Continue;			
		EndIf;
		Result.Insert(It.LanguageCode, It.Name);
	EndDo;
	//@skip-check constructor-function-return-section
	Return Result;
EndFunction

Function ISO639() Export
	Str = New Structure;
	Str.Insert("en", "eng");
	Str.Insert("fr", "fra");
	Str.Insert("de", "ger");
	Str.Insert("es", "spa");
	Str.Insert("it", "ita");
	Str.Insert("pt", "por");
	Str.Insert("nl", "dut");
	Str.Insert("ja", "jpn");
	Str.Insert("zh", "chi");
	Str.Insert("ko", "kor");
	Str.Insert("ar", "ara");
	Str.Insert("hi", "hin");
	Str.Insert("he", "heb");
	Str.Insert("pl", "pol");
	Str.Insert("uk", "ukr");
	Str.Insert("cs", "cze");
	Str.Insert("el", "gre");
	Str.Insert("sv", "swe");
	Str.Insert("fi", "fin");
	Str.Insert("no", "nor");
	Str.Insert("da", "dan");
	Str.Insert("hu", "hun");
	Str.Insert("ro", "rum");
	Str.Insert("bg", "bul");
	Str.Insert("sk", "slo");
	Str.Insert("sl", "slv");
	Str.Insert("hr", "hrv");
	Str.Insert("sr", "srp");
	Str.Insert("mk", "mac");
	Str.Insert("lv", "lav");
	Str.Insert("lt", "lit");
	Str.Insert("et", "est");
	Str.Insert("vi", "vie");
	Str.Insert("th", "tha");
	Str.Insert("ms", "may");
	Str.Insert("id", "ind");
	Str.Insert("fa", "per");
	Str.Insert("tr", "tur");
	Str.Insert("ru", "rus");
	Str.Insert("en", "eng");
	Str.Insert("fr", "fra");
	Str.Insert("de", "ger");
	Str.Insert("es", "spa");
	Str.Insert("it", "ita");
	Str.Insert("pt", "por");
	Str.Insert("nl", "dut");
	Str.Insert("ja", "jpn");
	Str.Insert("zh", "chi");
	Str.Insert("ko", "kor");
	Str.Insert("ar", "ara");
	Str.Insert("hi", "hin");
	Str.Insert("he", "heb");
	Str.Insert("pl", "pol");
	Str.Insert("uk", "ukr");
	Str.Insert("cs", "cze");
	Str.Insert("el", "gre");
	Str.Insert("sv", "swe");
	Str.Insert("fi", "fin");
	Str.Insert("no", "nor");
	Str.Insert("da", "dan");
	Str.Insert("hu", "hun");
	Str.Insert("ro", "rum");
	Str.Insert("bg", "bul");
	Str.Insert("sk", "slo");
	Str.Insert("sl", "slv");
	Str.Insert("hr", "hrv");
	Str.Insert("sr", "srp");
	Str.Insert("mk", "mac");
	Str.Insert("lv", "lav");
	Str.Insert("lt", "lit");
	Str.Insert("et", "est");
	Str.Insert("vi", "vie");
	Str.Insert("th", "tha");
	Str.Insert("ms", "may");
	Str.Insert("id", "ind");
	Str.Insert("fa", "per");
	Return Str;
EndFunction

// Get interface localizations.
// 
// Returns:
//  Array of Structure:
// 	* LanguageCode - String - Language code
// 	* Synonym - String - Language synonym
Function GetInterfaceLocalizations() Export
	
	InterfaceLocalizations = New Array; // Array of Structure
	
	Languages = MetadataLanguages();
	For Each LangKeyValue In Languages Do
		Language = New Structure;
		Language.Insert("LanguageCode", Lower(LangKeyValue.Key));
		Language.Insert("Synonym", LangKeyValue.Value);
		InterfaceLocalizations.Add(Language);
	EndDo;
	
	Return InterfaceLocalizations;
	
EndFunction

// Get data localizations.
// 
// Returns:
//  Array of Structure:
// 	* LanguageCode - String - Language code
// 	* Synonym - String - Language synonym
Function GetDataLocalizations() Export
	
	DataLocalizations = New Array; // Array of Structure
	
	InterfaceLocalizations = GetInterfaceLocalizations();
	LocalizationsMap = New Map;
	For Each Lang In InterfaceLocalizations Do
		LocalizationsMap.Insert(Lang.LanguageCode, Lang.Synonym);
	EndDo;
	
	For Each CommonAttribute In Metadata.CommonAttributes Do
		If StrStartsWith(CommonAttribute.Name, "Description_") Then
			LanguageCode = Lower(StrReplace(CommonAttribute.Name, "Description_", ""));
			Lang = LocalizationsMap.Get(LanguageCode);
			If Lang <> Undefined Then
				Language = New Structure;
				Language.Insert("LanguageCode", Lang.LanguageCode);
				Language.Insert("Synonym", Lang.Synonym);
				DataLocalizations.Add(Language);
			EndIf;
		EndIf;
	EndDo;
	
	Return DataLocalizations;
	
EndFunction