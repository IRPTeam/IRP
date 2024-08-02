
&AtClient
Procedure EditUUID(Command)
	FormParams = New Structure("TextUUID", String(Record.ExternalRef));
	Notify = New NotifyDescription("OnEditUUID", ThisObject);
	OpenForm("CommonForm.EditUUID", FormParams, ThisObject,,,, Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure OnEditUUID(Result, Params) Export
	If Result <> Undefined Then
		Record.ExternalRef = Result;
	EndIf;
EndProcedure
