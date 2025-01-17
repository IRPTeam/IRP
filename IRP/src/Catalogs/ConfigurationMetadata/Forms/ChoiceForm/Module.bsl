
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Property("TypeFilter") <> Undefined Then
		NewFilter = List.Filter.Items.Add(Type("DataCompositionFilterItem"));
		NewFilter.LeftValue = New DataCompositionField("Parent");
		NewFilter.RightValue = Parameters.TypeFilter;
		NewFilter.ComparisonType = DataCompositionComparisonType.Equal;
		Items.List.Representation = TableRepresentation.List;
	EndIf;
	CatalogsServer.OnCreateAtServerListForm(ThisObject, List, Cancel, StandardProcessing);
EndProcedure

#Region FormCommandsEventHandlers

&AtClient
Procedure RefillMetadata(Command)
	CatConfigurationMetadataServer.RefillMetadata();
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

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, List, Items.List.SelectedRows);
EndProcedure

#EndRegion