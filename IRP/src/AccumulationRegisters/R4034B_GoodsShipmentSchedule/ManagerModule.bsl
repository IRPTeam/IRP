#Region AccessObject

// Get access key.
// See Role.TemplateAccumulationRegisters - Parameters orders has to be the same
// 
// Returns:
//  Structure - Get access key:
// * Company - CatalogRef.Companies -
// * Branch - CatalogRef.BusinessUnits -
// * Store - CatalogRef.Stores -
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	AccessKeyStructure.Insert("Company", Catalogs.Companies.EmptyRef());
	AccessKeyStructure.Insert("Branch", Catalogs.BusinessUnits.EmptyRef());
	AccessKeyStructure.Insert("Store", Catalogs.Stores.EmptyRef());
	Return AccessKeyStructure;
EndFunction

#EndRegion

// Additional data filling.
// 
// Parameters:
//  MovementsValueTable - ValueTable
Procedure AdditionalDataFilling(MovementsValueTable) Export
	Return;	
EndProcedure