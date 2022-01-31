
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText,
		"MasterExtraDimensions.ExtDimensionType");
EndProcedure
