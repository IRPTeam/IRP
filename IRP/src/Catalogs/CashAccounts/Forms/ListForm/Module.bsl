&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatCashAccountsServer.OnCreateAtServer(Cancel, StandardProcessing, ThisObject, Parameters);
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	CatalogsServer.OnCreateAtServerListForm(ThisObject, List, Cancel, StandardProcessing);

	For Each FilterItem In Parameters.Filter Do
		If FilterItem.Key = "Type" Then
			CashAccountTypeFilter = FilterItem.Value;
			Items.CashAccountTypeFilter.Enabled = False;
		EndIf;
	EndDo;

	CommonFunctionsClientServer.SetFilterItem(List.Filter.Items, "Type", CashAccountTypeFilter,
		DataCompositionComparisonType.Equal, ValueIsFilled(CashAccountTypeFilter));

	CatCashAccountsServer.RemoveUnusedAccountTypes(ThisObject, "CashAccountTypeFilter");	
EndProcedure

&AtClient
Procedure CashAccountTypeFilterOnChange(Item)
	CommonFunctionsClientServer.SetFilterItem(List.Filter.Items, "Type", CashAccountTypeFilter,
		DataCompositionComparisonType.Equal, ValueIsFilled(CashAccountTypeFilter));
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