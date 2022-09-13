
#Region Public

// Save service exchange data to catalog.
// 
// Parameters:
//  ServiceExchangeData - See IntegrationClientServer.GetServiceExchangeDataTemplate
Procedure SaveServiceExchangeData(ServiceExchangeData) Export
	Catalogs.ServiceExchangeHistory.SaveServiceExchangeData(ServiceExchangeData);
EndProcedure

// Is it necessary to save the history of service exchange?
// 
// Returns:
//  Boolean - Need to save service exchange history
Function NeedToSaveServiceExchangeHistory() Export
	Return Constants.SaveServiceExchangeHistory.Get();	
EndFunction

#EndRegion