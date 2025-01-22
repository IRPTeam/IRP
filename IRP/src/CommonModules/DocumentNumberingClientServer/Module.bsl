
// Get number prifix type.
// 
// Returns:
//  Structure - Get number prifix type:
// * CompanyPrefix - String - 
// * BranchPrefix - String - 
// * DocumentPrefix - String - 
Function GetNumberPrifixType() Export
	
	Result = New Structure;
	
	Result.Insert("CompanyPrefix", "[company]");
	Result.Insert("BranchPrefix", "[branch]");
	Result.Insert("DocumentPrefix", "[document]");
	Result.Insert("CatalogPrefix", "[catalog]");
	
	Return Result;
	
EndFunction

// Get number parts.
// 
// Returns:
//  Structure - Get number parts:
// * Number - String - 
// * Basic - String - 
// * Year2 - String - 
// * Year4 - String - 
// * Quarter - String - 
// * Month1 - String - 
// * Month2 - String - 
// * Week1 - String - 
// * Week2 - String - 
Function GetNumberParts() Export
	
	Result = New Structure;
	
	Result.Insert("Number", "[number]");
	Result.Insert("Basic", "[basic]");
	Result.Insert("Year2", "[year2]");
	Result.Insert("Year4", "[year4]");
	Result.Insert("Quarter", "[quarter]");
	Result.Insert("Month1", "[month1]");
	Result.Insert("Month2", "[month2]");
	Result.Insert("Week1", "[week1]");
	Result.Insert("Week2", "[week2]");
	
	Return Result;
	
EndFunction

// Get numerator description.
// 
// Returns:
//  Structure - Get numerator description:
// * BasicRule - Structure - :
// ** Ref - CatalogRef.NumeratorBasicRules - 
// ** UseCompanyPrefix - Boolean - 
// ** UseBranchPrefix - Boolean - 
// ** UseDocumentPrefix - Boolean - 
// ** UseCatalogPrefix - Boolean - 
// ** UseTransactionTypePrefix - Boolean - 
// ** PrefixTemplate - String - 
// ** CompanyPrefixes - Map - 
// ** BranchPrefixes - Map - 
// ** DocumentPrefixes - Map - 
// ** CatalogPrefixes - Map - 
// * NumeratorRules - CatalogRef.NumeratorGroups - 
// * NumberTemplate - String - 
// * BeginDate - Date - 
// * EndDate - Date - 
// * ByDefault - Boolean - 
// * NumberingPeriod - EnumRef.NumberingPeriods - 
// * StartNumber - Number - 
// * TotalLength - Number - 
// * WithoutLeadingZeros - Boolean - 
// * CatalogDates - Map - 
Function GetNumeratorDescription() Export
	
	Description = New Structure;
	
	BasicRule = New Structure;
	BasicRule.Insert("Ref", PredefinedValue("Catalog.NumeratorBasicRules.EmptyRef"));
	BasicRule.Insert("UseCompanyPrefix", False);
	BasicRule.Insert("UseBranchPrefix", False);
	BasicRule.Insert("UseDocumentPrefix", False);
	BasicRule.Insert("UseCatalogPrefix", False);
	BasicRule.Insert("UseTransactionTypePrefix", False);
	BasicRule.Insert("PrefixTemplate", "");
	BasicRule.Insert("CompanyPrefixes", New Map);
	BasicRule.Insert("BranchPrefixes", New Map);
	BasicRule.Insert("DocumentPrefixes", New Map);
	BasicRule.Insert("CatalogPrefixes", New Map);
	Description.Insert("BasicRule", BasicRule);
	
	Description.Insert("NumeratorRules", PredefinedValue("Catalog.NumeratorGroups.EmptyRef"));
	Description.Insert("NumberTemplate", "");
	
	Description.Insert("BeginDate", Date(1,1,1));
	Description.Insert("EndDate", Date(1,1,1));
	Description.Insert("ByDefault", False);
	
	Description.Insert("NumberingPeriod", PredefinedValue("Enum.NumberingPeriods.NoPeriod"));
	Description.Insert("StartNumber", 0);
	Description.Insert("TotalLength", 0);
	Description.Insert("WithoutLeadingZeros", False);

	Description.Insert("CatalogDates", New Map);
	
	Return Description;
	
EndFunction
