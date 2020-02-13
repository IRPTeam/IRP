
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	ObjectForm = GetForm("Document.PhysicalInventory.ObjectForm", New Structure("Key", CommandParameter));
	If ObjectForm.IsOpen() Then
		ObjectForm.GeneratePhysicalCountByLocation();
	Else
		ObjectForm.GeneratePhysicalCountByLocationAtServer();
	EndIf;
EndProcedure
