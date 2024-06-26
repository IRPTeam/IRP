#Region AccessObject

// Get access key.
// See Role.TemplateAccumulationRegisters - Parameters orders has to be the same
// 
// Returns:
//  Structure - Get access key:
// * Company - CatalogRef.Companies -
// * Branch - CatalogRef.BusinessUnits -
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	AccessKeyStructure.Insert("Company", Catalogs.Companies.EmptyRef());
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

Function GetAvailableDays(Company, Employee, Date) Export
	
	Query = New Query;
	Query.Text =
		"SELECT ALLOWED
		|	R9541T_VacationUsageBalance.Employee,
		|	R9541T_VacationUsageBalance.DaysBalance AS Days
		|FROM
		|	AccumulationRegister.R9541T_VacationUsage.Balance(&Date, Company = &Company
		|	AND Employee = &Employee) AS R9541T_VacationUsageBalance
		|WHERE
		|	R9541T_VacationUsageBalance.DaysBalance > 0";
	
	Query.SetParameter("Date", Date);
	Query.SetParameter("Company", Company);
	Query.SetParameter("Employee", Employee);
	
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Days;
	EndIf;
	
	Return 0;
	
EndFunction