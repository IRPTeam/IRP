&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	isUseCompanies = CatCompaniesServer.isUseCompanies();
	If isUseCompanies Then
		OpenForm("Catalog.Companies.ListForm", , , , , , ,  FormWindowOpeningMode.Independent);
	Else
		OurCompanies = SessionParametersClientServer.GetSessionParameter("OurCompanies");
		If OurCompanies.Count() And ValueIsFilled(OurCompanies[0]) Then
			OpenFormFilters = New Structure("Key", OurCompanies[0]);
			OpenForm("Catalog.Companies.ObjectForm", OpenFormFilters, , , , , ,  FormWindowOpeningMode.Independent);		
		EndIf;		 
	EndIf;
EndProcedure