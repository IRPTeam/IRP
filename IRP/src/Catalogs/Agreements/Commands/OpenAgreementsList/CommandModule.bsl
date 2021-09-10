&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	ArrayOfFilters = New Array();
	FormParameters = New Structure();
	FillingData = New Structure();
	If TypeOf(CommandParameter) = Type("CatalogRef.Partners") Then
		FormParameters.Insert("Partner", CommandParameter);
		FormParameters.Insert("IncludeFilterByPartner", True);
		FormParameters.Insert("IncludePartnerSegments", True);
		FillingData.Insert("Partner", CommandParameter);
	EndIf;
	If TypeOf(CommandParameter) = Type("CatalogRef.PartnerSegments") Then
		Filter = DocumentsClientServer.CreateFilterItem("PartnerSegment", CommandParameter,
			DataCompositionComparisonType.Equal);
		ArrayOfFilters.Add(Filter);
		FillingData.Insert("PartnerSegment", CommandParameter);
	EndIf;
	FormParameters.Insert("FillingData", FillingData);

	DocumentsClient.OpenListForm("Catalog.Agreements.ListForm", ArrayOfFilters, FormParameters,
		CommandExecuteParameters.Source, CommandExecuteParameters.Uniqueness, CommandExecuteParameters.Window,
		CommandExecuteParameters.URL);
EndProcedure