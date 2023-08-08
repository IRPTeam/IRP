#Region AccessObject

// Get access key.
// See Role.TemplateInformationRegisters
// 
// Returns:
//  Structure - Get access key:
// * PriceType - CatalogRef.PriceTypes -
// * Partner - CatalogRef.Partners -
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	AccessKeyStructure.Insert("PriceType", Catalogs.PriceTypes.EmptyRef());
	AccessKeyStructure.Insert("Partner", Catalogs.Partners.EmptyRef());
	Return AccessKeyStructure;
EndFunction

#EndRegion