&AtClient
Procedure Ok(Command)
	Result = New Structure();
	For Each Attribute In LocalizationReuse.AllDescription() Do
		Result.Insert(Attribute, ThisObject[Attribute]);
	EndDo;
	Close(Result);
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Not Parameters.Property("Values") Then
		Cancel = True;
	EndIf;
	LocalizationEvents.CreateSubFormItemDescription(ThisObject, Parameters.Values, "GroupDescriptions");
EndProcedure

