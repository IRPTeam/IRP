
Function GetDetailsDataPaths() Export
	Return "Account";
EndFunction

Function GetAdditionalDetailsActions(DetailValuesMap) Export
	Result = New Structure();
	Result.Insert("MenuList", New ValueList());
	Result.Insert("OtherReportMapping", New Map());
	
	Account = DetailValuesMap["Account"];
	If Not ValueIsFilled(Account) Then
		Return Result;
	EndIf;
	
	Result.MenuList.Add(1, StrTemplate("%1: %2 = %3", Metadata.Reports.A0011_TrialBalanceByAccount.Synonym,  
		String(TypeOf(Account)), Account),, PictureLib.Report);
	
	Result.MenuList.Add(2, StrTemplate("%1: %2 = %3", Metadata.Reports.A0013_AccountAnalysis.Synonym,  
		String(TypeOf(Account)), Account),, PictureLib.Report);
	
	Result.MenuList.Add(3, StrTemplate("%1: %2 = %3", Metadata.Reports.A0012_AccountCard.Synonym,  
		String(TypeOf(Account)), Account),, PictureLib.DebitCredit);
	
	Result.OtherReportMapping.Insert(1, "Report.A0011_TrialBalanceByAccount.ObjectForm");
	Result.OtherReportMapping.Insert(2, "Report.A0013_AccountAnalysis.ObjectForm");
	Result.OtherReportMapping.Insert(3, "Report.A0012_AccountCard.ObjectForm");
	
	Return Result;
EndFunction

Function GetApplyingFilters(SelectedAction, DetailValuesMap) Export
	Result = New Structure();
	Result.Insert("DataParameters", New Map());
	Result.Insert("UserFilters", New Map());
	Result.Insert("DetailsFilters", New Map());
	
	// Parameter [Period] from this report to parameter [Period] other report (trial balance by account)  
	Result.DataParameters.Insert("Period", "Period");
	
	// Copying filter [Company] from this repot to other report
	Result.UserFilters.Insert("Company", "Company");
	Result.UserFilters.Insert("LedgerType", "LedgerType");
	
	// New filter to other report Key=Value, FiledName= fild name in other report  	
	Result.DetailsFilters.Insert(DetailValuesMap["Account"], 
		New Structure("FieldName, ComparisonType", "Account", DataCompositionComparisonType.InHierarchy));
	
	Return Result;
EndFunction
