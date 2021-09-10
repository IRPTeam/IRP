&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatCompaniesServer.OnCreateAtServer(Cancel, StandardProcessing, ThisObject, Parameters);
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
EndProcedure

&AtClient
Procedure OurCompanyFilterOnChange(Item)
	CommonFunctionsClientServer.SetFilterItem(List.Filter.Items, "OurCompany", ?(OurCompanyFilter = 1, True, False),
		DataCompositionComparisonType.Equal, ValueIsFilled(OurCompanyFilter));
EndProcedure