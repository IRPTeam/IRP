&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	Filter = New Structure();
	Filter.Insert("Type", PredefinedValue("Enum.AgreementTypes.Customer"));
	Parameters = New Structure();
	Parameters.Insert("Filter", Filter);
	Parameters.Insert("FormTitle", R().Form_004);
	OpenForm("Catalog.Agreements.ListForm", Parameters, , "Customer");
EndProcedure