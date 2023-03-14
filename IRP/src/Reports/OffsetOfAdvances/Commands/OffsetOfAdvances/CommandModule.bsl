
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	FormParameters = GetFormParameters(CommandParameter);
	OpenForm("Report.OffsetOfAdvances.Form.ReportForm", FormParameters, 
		CommandExecuteParameters.Source, CommandExecuteParameters.Uniqueness, , CommandExecuteParameters.URL);
EndProcedure

&AtServer
Function GetFormParameters(Doc)
	FormParameters = New Structure();
	FormParameters.Insert("StartDate", Doc.BeginOfPeriod);
	FormParameters.Insert("EndDate", Doc.EndOfPeriod);
	If TypeOf(Doc) = Type("DocumentRef.VendorsAdvancesClosing") Then
		FormParameters.Insert("ReportType", "Vendors");
	ElsIf TypeOf(Doc) = Type("DocumentRef.CustomersAdvancesClosing") Then
		FormParameters.Insert("ReportType", "Customers");
	Else
		Raise StrTemplate("Unsupported document type [%1]", TypeOf(Doc));
	EndIf;
	Return FormParameters;
EndFunction
	