
// @strict-types

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	GetCurrentWorkstation();
	CatalogsServer.OnCreateAtServerListForm(ThisObject, List, Cancel, StandardProcessing);
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

#Region COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	SelectedRows = Items.List.SelectedRows;
	ExternalCommandsClient.GeneratedListChoiceFormCommandActionByName(SelectedRows, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name, SelectedRows);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName, SelectedRows) Export
	ExternalCommandsServer.GeneratedListChoiceFormCommandActionByName(SelectedRows, ThisObject, CommandName);
EndProcedure

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, List, Items.List.SelectedRows);
EndProcedure

#EndRegion