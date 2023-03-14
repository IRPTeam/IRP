
// @strict-types

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	GetCurrentWorkstation();
EndProcedure

&AtClient
Procedure SetCurrentWorkstation(Command)
	SetCurrentWorkstationAtServer();
EndProcedure

#EndRegion

#Region Private

&AtServer
Procedure GetCurrentWorkstation()
	CurrentWorkstation = SessionParameters.Workstation;
EndProcedure

&AtServer
Procedure SetCurrentWorkstationAtServer()
	Ref = Items.List.CurrentRow; // CatalogRef.Workstations
	WorkstationServer.SetWorkstation(Ref);
	CurrentWorkstation = Ref;
EndProcedure

#EndRegion