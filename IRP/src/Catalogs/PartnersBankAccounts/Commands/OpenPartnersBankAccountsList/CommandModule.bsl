
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	FillingData = New Structure();
	FillingData.Insert("Partner", CommandParameter);
	
	ArrayOfFilters = New Array();
	Filter = DocumentsClientServer.CreateFilterItem("Partner", CommandParameter, DataCompositionComparisonType.Equal);
	ArrayOfFilters.Add(Filter);
	
	FormParameters = New Structure();
	FormParameters.Insert("FillingData", FillingData);
	FormParameters.Insert("Partner", CommandParameter);
	
	DocumentsClient.OpenListForm("Catalog.PartnersBankAccounts.ListForm", ArrayOfFilters, FormParameters,
		CommandExecuteParameters.Source, CommandExecuteParameters.Uniqueness, CommandExecuteParameters.Window,
		CommandExecuteParameters.URL);
EndProcedure
