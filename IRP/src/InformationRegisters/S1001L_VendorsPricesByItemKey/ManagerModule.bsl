#Region AccessObject

// Get access key.
// See Role.TemplateInformationRegisters
// 
// Returns:
//  Structure - Get access key:
// * PriceType - CatalogRef.PriceTypes -
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	AccessKeyStructure.Insert("PriceType", Catalogs.PriceTypes.EmptyRef());
	Return AccessKeyStructure;
EndFunction

#EndRegion

