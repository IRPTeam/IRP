// @strict-types

#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	FormNamesArray = StrSplit(ThisObject.FormName, ".");
	CatalogFullName = FormNamesArray[0] + "." + FormNamesArray[1];
	
	ExternalCommandsServer.CreateCommands(ThisObject, CatalogFullName, Enums.FormTypes.ObjectForm);
	InternalCommandsServer.CreateCommands(ThisObject, Object, CatalogFullName, Enums.FormTypes.ObjectForm);
	
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	
	SetVisible();
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	SetVisible();
EndProcedure

#EndRegion

#Region FormItemsEvents

// Description opening.
// 
// Parameters:
//  Item - FormField - Item
//  StandardProcessing - Boolean - Standard processing
&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	If Object.Ref.IsEmpty() Then
		LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
	EndIf;
EndProcedure

&AtClient
Procedure AcceptForExecution(Command)
	AcceptForExecutionServer();
EndProcedure

#EndRegion

#Region COMMANDS

// Generated form command action by name.
// 
// Parameters:
//  Command - FormCommand - Command
&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

// Generated form command action by name server.
// 
// Parameters:
//  CommandName - String - Command name
&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

// Internal command action.
// 
// Parameters:
//  Command - FormCommand - Command
&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

// Internal command action with server context.
// 
// Parameters:
//  Command - FormCommand - Command
&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

// Internal command action with server context at server.
// 
// Parameters:
//  CommandName - String - Command name
&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

#EndRegion

#Region Other

&AtServer
Procedure SetVisible()
	
	Items.UserGroup.Visible = Not Object.UserGroup.IsEmpty();
	Items.Position.Visible = Not Object.Position.IsEmpty();
	Items.Branch.Visible = Not Object.Branch.IsEmpty();
	Items.ProfitLossCenter.Visible = Not Object.ProfitLossCenter.IsEmpty();
	
	ThisObject.Items.FormAcceptForExecution.Visible = Object.CurrentExecutor.IsEmpty();
	
EndProcedure

&AtServer
Procedure AcceptForExecutionServer()
	
	Object.CurrentExecutor = SessionParameters.CurrentUser;
	Object.AcceptetionForExecutionDate = CommonFunctionsServer.GetCurrentSessionDate();
	
	Write();
	
EndProcedure

#EndRegion