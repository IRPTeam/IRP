
// @strict-types

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
	TemplateActions.SettingsComposer.Settings.Filter.Items[0].RightValue = Object.Ref;
EndProcedure

// Notification processing.
// 
// Parameters:
//  EventName - String - Event name
//  Parameter - Arbitrary - Parameter
//  Source - Arbitrary - Source
&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	AddAttributesCreateFormControl();
	TemplateActions.SettingsComposer.Settings.Filter.Items[0].RightValue = Object.Ref;
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	Notify("UpdatedFillingTemplate", New Structure("Ref", Object.Ref));
EndProcedure

// Description opening.
// 
// Parameters:
//  Item - FormField - Item
//  StandardProcessing - Boolean - Standard processing
&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#Region AddAttributes

// Add attribute start choice.
// 
// Parameters:
//  Item - FormField - Item
//  ChoiceData - ValueList - Choice data
//  StandardProcessing - Boolean - Standard processing
&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

// Add attribute button click.
// 
// Parameters:
//  Item - FormField - Item
&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion

#Region COMMANDS

// Generated form command action by name.
// 
// Parameters:
//  Command - CommandBarButton - Command
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
//  Command - CommandBarButton - Command
&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
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
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

#EndRegion