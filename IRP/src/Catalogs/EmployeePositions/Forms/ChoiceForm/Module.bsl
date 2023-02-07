&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatExpenseAndRevenueTypesServer.OnCreateAtServer(Cancel, StandardProcessing, ThisObject, Parameters);
	FillingData = Undefined;
	If Parameters.Property("FillingData", FillingData) Then
		ThisObject.FillingData = CommonFunctionsServer.SerializeXMLUseXDTO(FillingData);
	EndIf;

	If Parameters.Property("FormTitle") Then
		ThisObject.Title = Parameters.FormTitle;
		ThisObject.AutoTitle = False;
	EndIf;
	
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
EndProcedure