&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	CatalogsServer.OnCreateAtServerListForm(ThisObject, List, Cancel, StandardProcessing);
EndProcedure

&AtClient
Procedure ListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
	FormParameters = New Structure();
	FormParameters.Insert("AllowOwnerEdit", True);
	OwnerValue = PredefinedValue("ChartOfCharacteristicTypes.AddAttributeAndProperty.EmptyRef");
	For Each Filter In List.Filter.Items Do
		isSetConditionByOwner = TypeOf(Filter) = Type("DataCompositionFilterItem") And Filter.LeftValue
			= New DataCompositionField("Owner") And Filter.Use And Filter.ComparisonType
			= DataCompositionComparisonType.Equal And ValueIsFilled(Filter.RightValue);

		If isSetConditionByOwner Then
			OwnerValue = Filter.RightValue;
			FormParameters.Insert("AllowOwnerEdit", False);
		EndIf;
	EndDo;
	OpenedForm = OpenForm("Catalog.AddAttributeAndPropertyValues.ObjectForm", FormParameters, Item, UUID);
	If ValueIsFilled(OwnerValue) Then
		OpenedFormObject = OpenedForm.Object;
		OpenedFormObject.Owner = OwnerValue;
	EndIf;
EndProcedure

&AtClient
Procedure ListBeforeRowChange(Item, Cancel)
	Cancel = True;
	FormParameters = New Structure();
	FormParameters.Insert("AllowOwnerEdit", True);
	FormParameters.Insert("Key", Items.List.CurrentRow);
	OpenForm("Catalog.AddAttributeAndPropertyValues.ObjectForm", FormParameters, Item, UUID);
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