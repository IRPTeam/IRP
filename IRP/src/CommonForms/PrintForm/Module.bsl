
#Region FormEventHandlers

&AtClient
Procedure OnOpen(Cancel)
	EditResultSwitch();
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure EditResult(Command)
	Items.FormEditResult.Check = Not Items.FormEditResult.Check;
	EditResultSwitch();
EndProcedure

#EndRegion

#Region Private

&AtClient
Procedure EditResultSwitch()
	Items.GroupResultCommandBar.Visible = Items.FormEditResult.Check;
	Items.Result.Edit = Items.FormEditResult.Check;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Result = Parameters.Result;
EndProcedure


#EndRegion
