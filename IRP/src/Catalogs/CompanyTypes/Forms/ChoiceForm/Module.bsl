&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	FillingFromClassifiers.OnCreateAtServer(ThisObject, Cancel, StandardProcessing);
EndProcedure