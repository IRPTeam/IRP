
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	CatalogsServer.OnCreateAtServerListForm(ThisObject, List, Cancel, StandardProcessing);
EndProcedure

&AtClient
Procedure Integrations(Command)
	NotifyDescription = New NotifyDescription("SelectIntegrationEnd", ThisObject);
	OpenForm("Catalog.Currencies.Form.SelectIntegration", , ThisObject, , , , NotifyDescription);
EndProcedure

&AtClient
Procedure SelectIntegrationEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;

	ExternalDataProc = ServiceSystemServer.GetObjectAttribute(Result.IntegrationSettings, "ExternalDataProc");
	Info = AddDataProcServer.AddDataProcInfo(ExternalDataProc);
	Info.Insert("Settings", PutSettingsToTempStorage(Result.IntegrationSettings));
	Info.Insert("IntegrationSettingsRef", Result.IntegrationSettings);
	Info.Insert("IntegrationSettingsName", ServiceSystemServer.GetObjectAttribute(Result.IntegrationSettings,
		"UniqueID"));

	CallMethodAddDataProc(Info);

	AddDataProcClient.OpenFormAddDataProc(Info);
EndProcedure

&AtServer
Function PutSettingsToTempStorage(IntegrationSettings)
	Return PutToTempStorage(IntegrationSettings.ExternalDataProcSettings.Get(), ThisObject.UUID);
EndFunction

&AtServerNoContext
Procedure CallMethodAddDataProc(Info)
	AddDataProcServer.CallMethodAddDataProc(Info);
EndProcedure

&AtClient
Procedure LoadCurrency(Command)
	OpenForm("Catalog.Currencies.Form.LoadCurrencies");
EndProcedure

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

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, List, Items.List.SelectedRows);
EndProcedure

#EndRegion