&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	Filters = New Structure("Customer", True);
	OpenForm("Catalog.Partners.ListForm", New Structure("Filter, FormTitle", Filters, R().Form_005), , 1); 
EndProcedure
