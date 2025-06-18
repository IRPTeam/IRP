
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	ThisObject.List.Parameters.SetParameterValue("CurrentUser", SessionParameters.CurrentUser);
	ThisObject.List.Parameters.SetParameterValue("ShowAllTasks", False);
	ThisObject.List.Parameters.SetParameterValue("ShowExecuted", False);
EndProcedure

&AtClient
Procedure ShowExecuted(Command)
	ShowExecuted = Not Items.FormShowExecuted.Check;
	Items.FormShowExecuted.Check = ShowExecuted;
	ThisObject.List.Parameters.SetParameterValue("ShowExecuted", ShowExecuted);
EndProcedure

&AtClient
Procedure ShowAllTasks(Command)
	ShowAllTasks = Not Items.FormShowAllTasks.Check;
	Items.FormShowAllTasks.Check = ShowAllTasks;
	ThisObject.List.Parameters.SetParameterValue("ShowAllTasks", ShowAllTasks);
EndProcedure

