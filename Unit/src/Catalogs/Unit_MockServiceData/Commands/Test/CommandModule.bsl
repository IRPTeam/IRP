// @strict-types


#Region EventHandlers

&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	Parameters = New Structure;
	If TypeOf(CommandParameter) = Type("CatalogRef.Unit_ServiceExchangeHistory") Then
		Parent = CommonFunctionsServer.GetRefAttribute(CommandParameter, "Parent"); // CatalogRef.Unit_ServiceExchangeHistory
		If ValueIsFilled(Parent) Then
			Parameters.Insert("Request", Parent);
			Parameters.Insert("Answer", CommandParameter);
		Else
			Parameters.Insert("Request", CommandParameter);
			Parameters.Insert("Answer", IntegrationServer.Unit_GetLastAnswerByRequest(CommandParameter));
		EndIf;
	ElsIf TypeOf(CommandParameter) = Type("CatalogRef.Unit_MockServiceData") Then
		Parameters.Insert("MockData", CommandParameter);
	EndIf;
	OpenForm("Catalog.Unit_MockServiceData.Form.TestForm", Parameters);
EndProcedure

#EndRegion
