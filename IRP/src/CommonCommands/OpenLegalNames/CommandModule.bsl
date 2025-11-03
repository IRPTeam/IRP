
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	Filters = New Structure("OurCompany", False);
	OpenForm("Catalog.Companies.ListForm",  New Structure("Filter", Filters), , "NotOurCompaniesList" , , , , FormWindowOpeningMode.Independent);
EndProcedure
