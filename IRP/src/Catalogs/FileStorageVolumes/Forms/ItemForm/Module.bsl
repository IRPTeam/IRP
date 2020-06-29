&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	SetVisible();
EndProcedure

&AtClient
Procedure FilesTypeOnChange(Item)
	SetVisible();
EndProcedure