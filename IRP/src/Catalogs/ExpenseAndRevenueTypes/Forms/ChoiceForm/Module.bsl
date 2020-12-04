&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatExpenseAndRevenueTypesServer.OnCreateAtServer(Cancel, StandardProcessing, ThisObject, Parameters);
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
EndProcedure