
#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ExtensionServer.AddAtributesFromExtensions(ThisObject, Object.Ref);
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure SetCurrent(Command)
	Object.UniqueID = WorkstationClient.GetUniqueID();
EndProcedure

#EndRegion