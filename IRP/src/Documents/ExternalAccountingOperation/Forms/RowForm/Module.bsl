
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.ReadOnly = True;
	FillPropertyValues(ThisObject, Parameters.RowData);
EndProcedure

&AtClient
Procedure ShowUUID(Command)
	FormParams = New Structure();
	FormParams.Insert("TextUUID", ThisObject[StrReplace(Command.Name, "ShowUUID", "")]);
	FormParams.Insert("ReadOnly", True);
	OpenForm("CommonForm.EditUUID", FormParams, ThisObject,,,,,FormWindowOpeningMode.LockOwnerWindow);	
EndProcedure
