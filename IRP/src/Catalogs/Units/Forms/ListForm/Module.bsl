&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	CatalogsServer.OnCreateAtServerListForm(ThisObject, List, Cancel, StandardProcessing);
	List.Parameters.SetParameterValue("ShowAllUnits", False);
	If Parameters.Filter.Property("Item") Then
		List.Parameters.SetParameterValue("Item", Parameters.Filter.Item);
		Item = Parameters.Filter.Item;
		List.Parameters.SetParameterValue("Unit", Parameters.Filter.Item.Unit);
		List.Parameters.SetParameterValue("Filter", True);

		Parameters.Filter.Delete("Item");
	Else
		List.Parameters.SetParameterValue("Filter", False);
		List.Parameters.SetParameterValue("Item", Catalogs.Items.EmptyRef());
		List.Parameters.SetParameterValue("Unit", Catalogs.Units.EmptyRef());
	EndIf;
EndProcedure

&AtClient
Procedure ListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
	FormParameters = New Structure("Item", ThisObject.Item);
	Filter = New Structure("FillingValues", FormParameters);
	OpenForm("Catalog.Units.ObjectForm", Filter);
EndProcedure
&AtClient
Procedure ShowAllUnits(Command)
	Items.FormShowAllUnits.Check = Not Items.FormShowAllUnits.Check;
	List.Parameters.SetParameterValue("ShowAllUnits", Items.FormShowAllUnits.Check);
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