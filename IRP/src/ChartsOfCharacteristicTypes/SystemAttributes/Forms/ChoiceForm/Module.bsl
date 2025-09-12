
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	ChartsOfCharacteristicTypesServer.OnCreateAtServerChoiceForm(ThisObject, Cancel, StandardProcessing);
EndProcedure
