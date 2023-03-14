&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	
	CompanyFilter = Undefined;
	isCompanyFilter = Parameters.Filter.Property("Company", CompanyFilter) And ValueIsFilled(CompanyFilter);
	List.Parameters.SetParameterValue("NotCompanyFilter", Not isCompanyFilter);
	List.Parameters.SetParameterValue("CompanyFilter", CompanyFilter);
	Parameters.Filter.Delete("Company");
EndProcedure