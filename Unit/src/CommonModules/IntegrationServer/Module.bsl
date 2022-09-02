
// Save service exchange data to catalog.
// 
// Parameters:
//  ServiceExchangeData - See IntegrationClientServer.GetServiceExchangeDataTemplate
Procedure SaveServiceExchangeData(ServiceExchangeData) Export
	Catalogs.ServiceExchangeHistory.SaveServiceExchangeData(ServiceExchangeData);
EndProcedure
