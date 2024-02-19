&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatAgreementsServer.OnCreateAtServer(Cancel, StandardProcessing, ThisObject, Parameters);
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	CatalogsServer.OnCreateAtServerChoiceForm(ThisObject, List, Cancel, StandardProcessing);
	If Parameters.Property("FillingData") And Parameters.FillingData.Property("Company") Then
		_FilterCompany = Parameters.FillingData.Company;
		If ValueIsFilled(_FilterCompany) Then
			ThisObject.FilterCompany = _FilterCompany;
			ThisObject.FilterCompanyUse = True;
			SetCompanyFilter();
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure ListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	CommonFormActions.DynamicListBeforeAddRow(ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter, "Catalog.Agreements.ObjectForm");
EndProcedure

&AtClient
Procedure FilterCompanyOnChange(Item)
	SetCompanyFilter();
EndProcedure

&AtClient
Procedure FilterCompanyUseOnChange(Item)
	SetCompanyFilter()
EndProcedure

&AtServer
Procedure SetCompanyFilter()
	CommonFunctionsClientServer.SetFilterItem(List.Filter.Items, 
		"Company", 
		ThisObject.FilterCompany, 
		DataCompositionComparisonType.Equal, ThisObject.FilterCompanyUse);
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