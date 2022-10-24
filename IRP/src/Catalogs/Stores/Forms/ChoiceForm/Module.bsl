&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	
	CompanyFilter = Undefined;
	isCompanyFilter = Parameters.Filter.Property("Company", CompanyFilter);
	If isCompanyFilter Then
		Parameters.Filter.Delete("Company");
	EndIf;
	List.Parameters.SetParameterValue("NotCompanyFilter", Not isCompanyFilter);
	List.Parameters.SetParameterValue("CompanyFilter", CompanyFilter);
EndProcedure