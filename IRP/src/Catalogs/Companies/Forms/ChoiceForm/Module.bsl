#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatCompaniesServer.OnCreateAtServer(Cancel, StandardProcessing, ThisObject, Parameters);
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	CatalogsServer.OnCreateAtServerChoiceForm(ThisObject, List, Cancel, StandardProcessing);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "Writing_CatCompany" Then
		SetFormParametersAtServer();
		Items.List.Refresh();
	EndIf;
EndProcedure

#EndRegion

&AtClient
Procedure ListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	CatCompaniesClient.ListBeforeAddRow(ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure OurCompanyFilterOnChange(Item)
	CommonFunctionsClientServer.SetFilterItem(List.Filter.Items, "OurCompany", ?(OurCompanyFilter = 1, True, False),
		DataCompositionComparisonType.Equal, ValueIsFilled(OurCompanyFilter));
EndProcedure

&AtServer
Procedure SetFormParametersAtServer()
	CatCompaniesServer.SetChoiceFormParameters(ThisObject, Parameters);
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