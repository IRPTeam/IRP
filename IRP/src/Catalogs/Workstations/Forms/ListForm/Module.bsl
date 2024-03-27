
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

// Generated form command action by name.
// 
// Parameters:
//  Command - CommandBarButton - Command
&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	SelectedRows = Items.List.SelectedRows;
	ExternalCommandsClient.GeneratedListChoiceFormCommandActionByName(SelectedRows, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name, SelectedRows);
EndProcedure

// Generated form command action by name server.
// 
// Parameters:
//  CommandName - CommandBarButton - Command name
//  SelectedRows - Array - Selected rows
&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName, SelectedRows) Export
	ExternalCommandsServer.GeneratedListChoiceFormCommandActionByName(SelectedRows, ThisObject, CommandName);
EndProcedure

// Internal command action.
// 
// Parameters:
//  Command - CommandBarButton - Command
&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, List, Items.List.SelectedRows);
EndProcedure

// Internal command action with server context.
// 
// Parameters:
//  Command - CommandBarButton - Command
&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, List, Items.List.SelectedRows);
EndProcedure

#EndRegion