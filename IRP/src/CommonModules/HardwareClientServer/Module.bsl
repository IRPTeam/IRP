// @strict-types

// Get connect hardware result.
// 
// Returns:
//  Structure:
//  * Result - Boolean
//  * ErrorDescription - String
//  * ConnectParameters - See GetDeviceInfo
Function GetConnectHardwareResult() Export
	
	ResultData = New Structure();
	ResultData.Insert("Result", False);
	ResultData.Insert("ErrorDescription", "");
	ResultData.Insert("ConnectParameters", GetDeviceInfo());
	Return ResultData;
	
EndFunction

// Get device connection info.
// 
// Returns:
//  Structure - Get driver object:
// * ID - String -
// * AddInID - String -
// * DriverObject - Arbitrary - Add-In object
// * DriverRef - CatalogRef.EquipmentDrivers -
// * Hardware - CatalogRef.Hardware -
// * OldRevision - Boolean - Driver revision less then 3000
// * WriteLog - Boolean - Write log
// * UseIS - Boolean - Use integration settings
// * IntegrationSettings - CatalogRef.IntegrationSettings -
// * LastUseDate - Date -
// * SleepAfter - Number -
Function GetDeviceInfo() Export
	
	DeviceInfo = New Structure;
	DeviceInfo.Insert("ID", "");
	DeviceInfo.Insert("AddInID", "");
	DeviceInfo.Insert("DriverObject", Undefined);
	DeviceInfo.Insert("DriverRef", PredefinedValue("Catalog.EquipmentDrivers.EmptyRef"));
	DeviceInfo.Insert("Hardware", PredefinedValue("Catalog.Hardware.EmptyRef"));
	DeviceInfo.Insert("OldRevision", False);
	DeviceInfo.Insert("WriteLog", False);
	DeviceInfo.Insert("UseIS", False);
	DeviceInfo.Insert("IntegrationSettings", PredefinedValue("Catalog.IntegrationSettings.EmptyRef"));
	DeviceInfo.Insert("LastUseDate", Date(1, 1, 1));
	DeviceInfo.Insert("SleepAfter", 0);
	
	Return DeviceInfo;

EndFunction

// Get driver parameters settings.
// 
// Returns:
//  Structure - Fill driver parameters settings:
// * ID - String -
// * Hardware - CatalogRef.Hardware -
// * Callback - CallbackDescription, Undefined - Callback for client side
// * ConnectedDriver - See GetDeviceInfo
// * ParametersDriver - See GetParametersDriverDescription
// * AdditionalCommand - String -
// * SetParameters - Structure - Structure by Catalog.Hardware.ConnectParameters
// * OutParameters - Array of String -
// * ServiceCallback - CallbackDescription, Undefined -
Function GetDriverParametersSettings() Export
		
	Str = New Structure;
	Str.Insert("Hardware", PredefinedValue("Catalog.Hardware.EmptyRef"));
	Str.Insert("Callback", Undefined);
	Str.Insert("ConnectedDriver", GetDeviceInfo());
	Str.Insert("ParametersDriver", GetParametersDriverDescription());
	Str.Insert("AdditionalCommand", "");
	Str.Insert("SetParameters", New Structure);
	Str.Insert("OutParameters", New Array);
	Str.Insert("ServiceCallback", Undefined);
	
	Return Str;
	
EndFunction

// Get parameters driver description.
// 
// Returns:
//  Structure - Parameters driver description:
// * Installed - Boolean -
// * DriverVersion - String, Undefined -
// * IntegrationComponentVersion - Number, Undefined -
// * Name - String -
// * Description - String -
// * EquipmentType - String -
// * IntegrationComponent - Boolean -
// * MainDriverInstalled - Boolean -
// * InterfaceRevision - Number -
// * DownloadURL - String -
// * DriverParametersXML - String -
// * AdditionalActionsXML - String -
// * DriverDescriptionXML - String -
// * LogIsEnabled - Boolean -
// * LogPath - String -
// * IsEmulator - Boolean -
Function GetParametersDriverDescription() Export
	
	Result = New Structure();
	Result.Insert("Installed", False);
	Result.Insert("DriverVersion", Undefined);
	Result.Insert("IntegrationComponentVersion", Undefined);
	Result.Insert("Name", "");
	Result.Insert("Description" , "");
	Result.Insert("EquipmentType" , "");
	Result.Insert("IntegrationComponent"  , False);
	Result.Insert("MainDriverInstalled", False);
	Result.Insert("InterfaceRevision" , 3009);
	Result.Insert("DownloadURL" , "");
	Result.Insert("DriverParametersXML" , "");
	Result.Insert("AdditionalActionsXML", "");
	Result.Insert("DriverDescriptionXML" , "");
	Result.Insert("LogIsEnabled" , False);
	Result.Insert("LogPath" , "");
	Result.Insert("IsEmulator" , False);
	Return Result;
	
EndFunction

