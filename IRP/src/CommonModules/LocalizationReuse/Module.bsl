// @strict-types

// Strings.
// 
// Parameters:
//  LangCode - String - Lang code
// 
// Returns:
// 	see Localization.Strings
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

// Use multi language.
// 
// Parameters:
//  MetadataFullName - String - Metadata full name
//  AddInfo - Undefined, Structure - Add info
// 
// Returns:
//  Boolean - Use multi language
Function UseMultiLanguage(Val MetadataFullName, AddInfo = Undefined) Export
	Return LocalizationServer.UseMultiLanguage(MetadataFullName, AddInfo);
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

// Fields list for descriptions.
// 
// Parameters:
//  SourceType - CatalogManager - Source type
// 
// Returns:
//  Array of String - Fields list for descriptions
Function FieldsListForDescriptions(Val SourceType) Export
	Return LocalizationServer.FieldsListForDescriptions(SourceType);
EndFunction

// User language code.
// 
// Returns:
//  String - User language code
Function UserLanguageCode() Export
	Return SessionParameters.LocalizationCode;
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