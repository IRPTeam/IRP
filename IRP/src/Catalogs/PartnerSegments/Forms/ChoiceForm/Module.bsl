&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ParameterFillingData = Undefined;
	If Parameters.Property("FillingData", ParameterFillingData) Then
		FillingData = CommonFunctionsServer.SerializeXMLUseXDTO(ParameterFillingData);
	EndIf;
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	CatalogsServer.OnCreateAtServerChoiceForm(ThisObject, List, Cancel, StandardProcessing);
EndProcedure

&AtClient
Procedure ListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	CommonFormActions.DynamicListBeforeAddRow(
				ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter, "Catalog.PartnerSegments.ObjectForm");
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