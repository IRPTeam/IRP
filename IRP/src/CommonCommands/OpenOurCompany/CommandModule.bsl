&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	Filters = New Structure("Ref", True);
	OurCompany = OurCompany();
	If ValueIsFilled(OurCompany) Then
		Filters = New Structure("Key", OurCompany);
		OpenForm("Catalog.Companies.ObjectForm", Filters, , , , , ,  FormWindowOpeningMode.Independent);
	EndIf; 
EndProcedure

&AtServer
Function OurCompany()
	If SessionParameters.OurCompanies.Count() Then
		OurCompany = SessionParameters.OurCompanies.Get(0);
	Else
		OurCompany = Catalogs.Companies.EmptyRef();
	EndIf;
	Return OurCompany;
EndFunction
