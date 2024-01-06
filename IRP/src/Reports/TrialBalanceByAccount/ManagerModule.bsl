
Function GetDetailsDataPaths() Export
	Return "Account, ExtDimension1, ExtDimension2, ExtDimension3";
EndFunction

Function GetAdditionalDetailsActions(DetailValuesMap) Export
	Result = New Structure();
	Result.Insert("MenuList", New ValueList());
	Result.Insert("OtherReportMapping", New Map());
	
	Account = DetailValuesMap["Account"];
	If Not ValueIsFilled(Account) Then
		Return Result;
	EndIf;
		
	Result.MenuList.Add(1, StrTemplate("%1: %2 = %3", Metadata.Reports.AccountCard.Synonym,  
		String(TypeOf(Account)), Account),, PictureLib.DebitCredit);
	
	Result.OtherReportMapping.Insert(1, "Report.AccountCard.ObjectForm");
	
	Return Result;
EndFunction

Function GetApplyingFilters(SelectedAction, DetailValuesMap) Export
	Result = New Structure();
	Result.Insert("DataParameters", New Map());
	Result.Insert("UserFilters", New Map());
	Result.Insert("DetailsFilters", New Map());
	Result.Insert("DetailsFiltersGroupOR", New Array()); 
	
	// Parameter [Period] from this report to parameter [Period] other report (trial balance by account)  
	Result.DataParameters.Insert("Period", "Period");
	
	// Copying filter [Company] from this repot to other report
	Result.UserFilters.Insert("Company", "Company");
	Result.UserFilters.Insert("LedgerType", "LedgerType");
	
	// New filter to other report Key=Value, FiledName= fild name in other report  	
	Result.DetailsFilters.Insert(DetailValuesMap["Account"], 
		New Structure("FieldName, ComparisonType", "Account", DataCompositionComparisonType.InHierarchy));
	
	
	FilterByExtDimension(1, DetailValuesMap, Result.DetailsFiltersGroupOR);
	FilterByExtDimension(2, DetailValuesMap, Result.DetailsFiltersGroupOR);
	FilterByExtDimension(3, DetailValuesMap, Result.DetailsFiltersGroupOR);
	
	Return Result;
EndFunction

Procedure FilterByExtDimension(Number, DetailValuesMap, DetailsFiltersGroupOR)
	ArrayOfFilters_ExtDimension = New Array();
	If ValueIsFilled(DetailValuesMap["ExtDimension"+Number]) Then 
		Filter_ExtDimensionDr = New Map();
		Filter_ExtDimensionDr.Insert(DetailValuesMap["ExtDimension"+Number], 
			New Structure("FieldName, ComparisonType", "ExtDimensionDr"+Number, DataCompositionComparisonType.Equal));
		ArrayOfFilters_ExtDimension.Add(Filter_ExtDimensionDr);
			
		Filter_ExtDimensionCr = New Map();
		Filter_ExtDimensionCr.Insert(DetailValuesMap["ExtDimension"+Number], 
			New Structure("FieldName, ComparisonType", "ExtDimensionCr"+Number, DataCompositionComparisonType.Equal));
		ArrayOfFilters_ExtDimension.Add(Filter_ExtDimensionCr);
	EndIf;
	If ArrayOfFilters_ExtDimension.Count() Then
		DetailsFiltersGroupOR.Add(ArrayOfFilters_ExtDimension);
	EndIf;
EndProcedure

