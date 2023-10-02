#Region AccessObject

// Get access key.
// 
// Returns:
//  Structure - Get access key:
// * Company - CatalogRef.Companies -
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	AccessKeyStructure.Insert("Company", Catalogs.Companies.EmptyRef());
	Return AccessKeyStructure;
EndFunction

#EndRegion