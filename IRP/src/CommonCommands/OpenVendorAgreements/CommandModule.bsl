&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	Filters = New Structure("Type", PredefinedValue("Enum.AgreementTypes.Vendor"));
	OpenForm("Catalog.Agreements.ListForm", New Structure("Filter, FormTitle", Filters, R().Form_007), , 4);
EndProcedure