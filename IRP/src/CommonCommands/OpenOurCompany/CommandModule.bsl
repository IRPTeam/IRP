&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	OurCompanies = SessionParametersClientServer.GetSessionParameter("OurCompanies");
	If OurCompanies.Count() And ValueIsFilled(OurCompanies[0]) Then
		Filters = New Structure("Key", OurCompanies[0]);
		OpenForm("Catalog.Companies.ObjectForm", Filters, , , , , ,  FormWindowOpeningMode.Independent);
	EndIf;	 
EndProcedure
