&AtClient
Procedure NewWriteProcessing(NewObject, Source, StandardProcessing)
	//@skip-check unknown-method-property
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
EndProcedure