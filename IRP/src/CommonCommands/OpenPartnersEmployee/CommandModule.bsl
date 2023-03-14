&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	Filters = New Structure("Employee", True);
	OpenForm("Catalog.Partners.ListForm", New Structure("Filter, FormTitle", Filters, R().Form_038), , 5);
EndProcedure