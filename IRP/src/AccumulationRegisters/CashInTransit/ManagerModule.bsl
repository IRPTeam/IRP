#Region AccessObject

// Get access key.
// 	See Role.TemplateRegisters - Parameters orders has to be the same
//  
// Returns:
//  Structure
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	AccessKeyStructure.Insert("Company", Catalogs.Companies.EmptyRef());
	AccessKeyStructure.Insert("FromAccount", Catalogs.CashAccounts.EmptyRef());
	AccessKeyStructure.Insert("ToAccount", Catalogs.CashAccounts.EmptyRef());
	Return AccessKeyStructure;
EndFunction

#EndRegion