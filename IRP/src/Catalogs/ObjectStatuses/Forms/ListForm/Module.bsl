&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.CommandBar.ChildItems.FormCreateFolder.Visible = False;
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
EndProcedure