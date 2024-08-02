

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.TextUUID = Parameters.TextUUID;
	If Parameters.Property("ReadOnly") Then
		Items.TextUUID.ReadOnly = Parameters.ReadOnly;
	EndIf;
EndProcedure

&AtClient
Procedure Ok(Command)
	_UUID = Undefined;
	Try
		_UUID = New UUID(ThisObject.TextUUID);
	Except
		ShowMessageBox(, StrTemplate(R().Error_149, ThisObject.TextUUID));
		Return;
	EndTry;
	Close(_UUID);
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure
