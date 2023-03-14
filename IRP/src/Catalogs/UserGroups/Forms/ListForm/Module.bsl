&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
EndProcedure

&AtClient
Procedure Settings(Command)
	CurrentRow = Items.List.CurrentRow;
	If CurrentRow <> Undefined Then
		OpenForm("CommonForm.EditUserSettings", New Structure("UserOrGroup", CurrentRow), ThisObject);
	EndIf;
EndProcedure