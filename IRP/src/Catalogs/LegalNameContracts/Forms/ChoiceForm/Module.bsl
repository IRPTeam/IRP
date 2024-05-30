
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatalogsServer.OnCreateAtServerChoiceForm(ThisObject, List, Cancel, StandardProcessing);
	
	CompanyFilter = Undefined;
	If Parameters.Property("Filter") And Parameters.Filter.Property("Company", CompanyFilter) Then
		Parameters.Filter.Delete("Company");
		If ValueIsFilled(CompanyFilter) Then
			CompanyList = New ValueList();
			CompanyList.Add(CompanyFilter);
			CompanyList.Add(Catalogs.Companies.EmptyRef());
			ListFilter = List.Filter.Items.Add(Type("DataCompositionFilterItem"));
			ListFilter.LeftValue = New DataCompositionField("Company");
			ListFilter.ComparisonType = DataCompositionComparisonType.InList;
			ListFilter.RightValue = CompanyList;
			ListFilter.Use = True;
		EndIf;
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

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, List, Items.List.SelectedRows);
EndProcedure

#EndRegion