#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	GetCurrentWorkstation();
EndProcedure

#EndRegion

#Region Private

&AtServer
Procedure GetCurrentWorkstation()
	CurrentWorkstation = SessionParameters.Workstation;
EndProcedure

#EndRegion