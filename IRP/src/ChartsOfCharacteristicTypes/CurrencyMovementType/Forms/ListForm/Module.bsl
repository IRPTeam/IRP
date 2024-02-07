&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	ChartsOfCharacteristicTypesServer.OnCreateAtServerListForm(ThisObject, Cancel, StandardProcessing);
EndProcedure