#Region AccessObject

// Get access key.
// See Role.TemplateInformationRegisters
// 
// Returns:
//  Structure - Get access key:
// * Company - CatalogRef.Companies -
// * Account - CatalogRef.CashAccounts -
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	AccessKeyStructure.Insert("Company", Catalogs.Companies.EmptyRef());
	AccessKeyStructure.Insert("Account", Catalogs.CashAccounts.EmptyRef());
	Return AccessKeyStructure;
EndFunction

#EndRegion