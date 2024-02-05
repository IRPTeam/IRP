&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	CatalogsServer.OnCreateAtServerChoiceForm(ThisObject, List, Cancel, StandardProcessing);
	If Parameters.Filter.Property("CustomFilterByItem") Then
		ThisObject.CustomFilterByItem = Parameters.Filter.CustomFilterByItem;
	EndIf;
	UpdateFiltersInList();
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAvailableSpecificationsByItem" Then
		UpdateFiltersInList();
	EndIf;
EndProcedure

&AtServer
Procedure UpdateFiltersInList()
	If ThisObject.CustomFilterByItem <> Undefined Then
		ThisObject.List.Filter.Items.Clear();
		FilterItem = ThisObject.List.Filter.Items.Add(Type("DataCompositionFilterItem"));
		FilterItem.LeftValue = New DataCompositionField("Ref");
		FilterItem.ComparisonType = DataCompositionComparisonType.InList;
		FilterItem.RightValue = Catalogs.Specifications.GetAvailableSpecificationsByItem(ThisObject.CustomFilterByItem);
	EndIf;
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