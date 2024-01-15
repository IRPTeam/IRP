&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	CatalogsServer.OnCreateAtServerChoiceForm(ThisObject, List, Cancel, StandardProcessing);
	If Parameters.Filter.Property("Item") Then
		If TypeOf(Parameters.Filter.Item) = Type("CatalogRef.Items") Then
			Item = Parameters.Filter.Item;
		Else
			Item = Parameters.Filter.Item.Item;
		EndIf;
		List.Parameters.SetParameterValue("Item", Item);
		List.Parameters.SetParameterValue("Unit", Item.Unit);
		List.Parameters.SetParameterValue("Filter", True);
	Else
		List.Parameters.SetParameterValue("Filter", False);
		List.Parameters.SetParameterValue("Item", Catalogs.Items.EmptyRef());
		List.Parameters.SetParameterValue("Unit", Catalogs.Units.EmptyRef());
	EndIf;
	If Parameters.Filter.Property("Quantity") Then
		List.Parameters.SetParameterValue("FilterForItemsAndKeys", True);
	Else
		List.Parameters.SetParameterValue("FilterForItemsAndKeys", False);
	EndIf;
	Parameters.Filter.Delete("Item");
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

#EndRegion