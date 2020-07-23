#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatCompaniesServer.OnCreateAtServer(Cancel, StandardProcessing, ThisObject, Parameters);
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "Writing_CatCompany" Then
		SetFormParametersAtServer();
		Items.List.Refresh();
	EndIf;
EndProcedure

#EndRegion

&AtClient
Procedure ListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	CatCompaniesClient.ListBeforeAddRow(ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure OurCompanyFilterOnChange(Item)
	CommonFunctionsClientServer.SetFilterItem(List.Filter.Items,
		"Our",
		?(OurCompanyFilter = 1, True, False),
			DataCompositionComparisonType.Equal,
			ValueIsFilled(OurCompanyFilter));
EndProcedure

&AtServer
Procedure SetFormParametersAtServer()
	CatCompaniesServer.SetChoiceFormParameters(ThisObject, Parameters);
EndProcedure