// @strict-types

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	WarningMessage = Parameters.WarningMessage;
	If IsBlankString(WarningMessage) Then
		Cancel = True;
	EndIf;
EndProcedure

#EndRegion

#Region FormHeaderItemsEventHandlers

&AtClient
Procedure ConfirmOnChange(Item)
	Items.OK.Enabled = Confirm;
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure OK(Command)
	Close(True);
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(False);
EndProcedure

#EndRegion