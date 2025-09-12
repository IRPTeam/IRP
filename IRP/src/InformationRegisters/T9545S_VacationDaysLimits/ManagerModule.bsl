#Region AccessObject

// Get access key.
// See Role.TemplateInformationRegisters
// 
// Returns:
//  Structure - Get access key:
// * Company - CatalogRef.Companies -
// * Branch - CatalogRef.BusinessUnits -
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	Return AccessKeyStructure;
EndFunction

#EndRegion

Function GetLimit(Date, Company, Employee = Undefined) Export
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	T9545S_VacationDaysLimitsSliceLast.DayLimit,
	|	1 AS Priority
	|FROM
	|	InformationRegister.T9545S_VacationDaysLimits.SliceLast(&Date, Company = &Company
	|	AND Employee = &Employee) AS T9545S_VacationDaysLimitsSliceLast
	|
	|UNION ALL
	|
	|SELECT
	|	T9545S_VacationDaysLimitsSliceLast.DayLimit,
	|	2
	|FROM
	|	InformationRegister.T9545S_VacationDaysLimits.SliceLast(&Date, Company = &EmptyCompany
	|	AND Employee = &Employee) AS T9545S_VacationDaysLimitsSliceLast
	|
	|UNION ALL
	|
	|SELECT
	|	T9545S_VacationDaysLimitsSliceLast.DayLimit,
	|	3
	|FROM
	|	InformationRegister.T9545S_VacationDaysLimits.SliceLast(&Date, Company = &Company
	|	AND Employee = &EmptyEmployee) AS T9545S_VacationDaysLimitsSliceLast
	|
	|UNION ALL
	|
	|SELECT
	|	T9545S_VacationDaysLimitsSliceLast.DayLimit,
	|	4
	|FROM
	|	InformationRegister.T9545S_VacationDaysLimits.SliceLast(&Date, Company = &EmptyCompany
	|	AND Employee = &EmptyEmployee) AS T9545S_VacationDaysLimitsSliceLast
	|
	|ORDER BY
	|	Priority";
	
	Query.SetParameter("Date", Date);
	Query.SetParameter("Company", Company);
	Query.SetParameter("Employee", Employee);
	Query.SetParameter("EmptyCompany", Catalogs.Companies.EmptyRef());
	Query.SetParameter("EmptyEmployee", Catalogs.Partners.EmptyRef());
	
	QuerySelection = Query.Execute().Select();
	
	If QuerySelection.Next() Then
		Return QuerySelection.DayLimit;
	EndIf;
	
	Return 0;
	
EndFunction