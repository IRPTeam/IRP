&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
	
	If Object.Ref.IsEmpty() Then
		Object.AdminPassword = UserSettingsServer.GeneratePassword();
	EndIf;

	FillExistsLangs();
EndProcedure

&AtServer
Procedure FillExistsLangs()

	For Each Lang In Metadata.Languages Do
		Items.AdminLocalization.ChoiceList.Add(Lower(Lang.LanguageCode), Lang.Synonym);
		Items.InterfaceLocalizationCode.ChoiceList.Add(Lower(Lang.LanguageCode), Lang.Synonym);
	EndDo;

EndProcedure

#Region COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

#EndRegion