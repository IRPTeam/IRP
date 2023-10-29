// @strict-types

#Region Internal

// Begin get driver.
// 
// Parameters:
//  NotifyOnClose - NotifyDescription - Notify on close
//  DriverInfo - Structure:
//  * Driver - CatalogRef.EquipmentDrivers
//  * AddInID - String
Procedure BeginGetDriver(NotifyOnClose, DriverInfo) Export
	ObjectName = StrSplit(DriverInfo.AddInID, ".");
	ObjectName.Add(ObjectName[1]);
	Params = New Structure("ProgID, NotifyOnClose, EquipmentDriver", StrConcat(ObjectName, "."), NotifyOnClose,
		DriverInfo.Driver);
	NotifyDescription = New NotifyDescription("BeginAttachingAddIn_End", ThisObject, Params);

	LinkOnDriver = GetURL(DriverInfo.Driver, "Driver");
	BeginAttachingAddIn(NotifyDescription, LinkOnDriver, ObjectName[1]);
EndProcedure

// Begin attaching add in end.
// 
// Parameters:
//  Connected - Boolean
//  Params - Structure:
//  * ProgID - String
//  * NotifyOnClose - NotifyDescription
//  * EquipmentDriver - CatalogRef.EquipmentDrivers
Procedure BeginAttachingAddIn_End(Connected, Params) Export
	DriverObject = Undefined;

	If Connected Then
		Try
			DriverObject = New (Params.ProgID); // Arbitrary
		Except
			// @skip-check property-return-type, invocation-parameter-type-intersect
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().EqError_005, """" + Params.EquipmentDriver
				+ """", """" + Params.ProgID + """"));
			Return;
		EndTry;
		If DriverObject <> Undefined Then
			globalEquipments_AddDriver(Params.EquipmentDriver, DriverObject);
		EndIf;
		ExecuteNotifyProcessing(Params.NotifyOnClose, DriverObject);
	Else
		ExecuteNotifyProcessing(Params.NotifyOnClose, Undefined);
	EndIf;
EndProcedure

// Install driver.
// 
// Parameters:
//  DriverRef - CatalogRef.EquipmentDrivers
//  NotifyOnCloseArchive - NotifyDescription - Notify on close archive
Procedure InstallDriver(DriverRef, NotifyOnCloseArchive = Undefined) Export
	DriverAddress = GetURL(DriverRef, "Driver");
	BeginInstallAddIn(NotifyOnCloseArchive, DriverAddress);
EndProcedure

// Begin connect equipment.
// 
// Parameters:
//  Workstation - CatalogRef.Workstations - Workstation
Async Procedure BeginConnectEquipment(Workstation) Export

	HardwareList = HardwareServer.GetAllWorkstationHardwareList(Workstation);

	For Each Hardware In HardwareList Do
		ConnectClientHardware(Hardware);
	EndDo;
EndProcedure

// Connect hardware.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
// 
// Returns:
//  Structure:
//  * Result - Boolean
//  * ErrorDescription - String
//  * ConnectParameters - See GetDriverObject
Async Function ConnectHardware(Hardware) Export
	
	ResultData = New Structure();
	ResultData.Insert("Result", False);
	ResultData.Insert("ErrorDescription", "");
	ResultData.Insert("ConnectParameters", New Structure());

	If Not ValueIsFilled(Hardware) Then
		ResultData.Insert("ErrorDescription", R().Eq_013);
		Return ResultData;
	EndIf;
	
	ConnectedDevice = globalEquipment_GetConnectionSettings(Hardware);
	
	If Not ConnectedDevice.Connected Then
		Device = HardwareServer.GetConnectionSettings(Hardware);
		Settings = Await FillDriverParametersSettings(Hardware);
		
		If Settings.ConnectedDriver = Undefined Then
			// @skip-check property-return-type, invocation-parameter-type-intersect
			ErrorDescription = StrTemplate(R().Eq_007, Hardware);
			ResultData.ErrorDescription = ErrorDescription;
			ResultData.ConnectParameters = Device.ConnectParameters;
		Else
			//@skip-check module-unused-local-variable
			For Each Param In Device.ConnectParameters Do
				//@skip-check invocation-parameter-type-intersect
				Device_SetParameter(Settings.ConnectedDriver, Settings.ConnectedDriver.DriverObject, Param.Key, Param.Value);
			EndDo;
			
			APIModule = GetAPIModule(Hardware);
			If APIModule = Undefined Then
				Result = Device_Open(Settings.ConnectedDriver, Settings.ConnectedDriver.DriverObject, Settings.ConnectedDriver.ID); // Boolean
			Else
				Result = APIModule.Device_Open(Settings.ConnectedDriver, Settings.ConnectedDriver.DriverObject, Settings.ConnectedDriver.ID); // Boolean
			EndIf;
		
			globalEquipment_SetHardwareID(Settings.Hardware, Settings.ConnectedDriver.ID);
			
			For Each ParamRow In HardwareServer.GetConnectionParameters(Hardware) Do
				Device_SetParameter(Settings.ConnectedDriver, Settings.ConnectedDriver.DriverObject, ParamRow.Key, ParamRow.Value)
			EndDo;
			If Settings.ConnectedDriver.DriverObject <> Undefined OR Result Then
				// @skip-check property-return-type, invocation-parameter-type-intersect
				ErrorDescription = String(R().Eq_003);
				ResultData.Result = Result;
				ResultData.ErrorDescription = ErrorDescription;
				ResultData.ConnectParameters = Settings.ConnectedDriver;
			EndIf;
		EndIf;
	Else
		If ConnectedDevice.Settings.DriverObject <> Undefined OR ConnectedDevice.Settings.UseIS Then
			// @skip-check property-return-type, invocation-parameter-type-intersect
			ErrorDescription = String(R().Eq_003);
			ResultData.Result = True;
			ResultData.ErrorDescription = ErrorDescription;
			ResultData.ConnectParameters = ConnectedDevice.Settings;
		EndIf;
	EndIf;
	Return ResultData;
EndFunction

// Disconnect hardware.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
// 
// Returns:
//  Structure:
//  * Result - Boolean
//  * ErrorDescription - String
Async Function DisconnectHardware(Hardware) Export
	ResultData = New Structure();
	ResultData.Insert("Result", False);
	ResultData.Insert("ErrorDescription", "");
	
	ConnectedDevice = globalEquipment_GetConnectionSettings(Hardware);
	If ConnectedDevice.Connected Then
		APIModule = GetAPIModule(Hardware);
		If APIModule = Undefined Then
			Result = Device_Close(ConnectedDevice.Settings, ConnectedDevice.Settings.DriverObject, ConnectedDevice.Settings.ID); // Boolean
		Else
			Result = APIModule.Device_Close(ConnectedDevice.Settings, ConnectedDevice.Settings.DriverObject, ConnectedDevice.Settings.ID); // Boolean
		EndIf;
		
		ResultData.Result = Result;
		If Result Then
			// @skip-check property-return-type, invocation-parameter-type-intersect
			ErrorDescription = StrTemplate(R().Eq_008, Hardware);
			ResultData.ErrorDescription = ErrorDescription;
			globalEquipment_RemoveConnectionSettings(Hardware);
			globalEquipments_RemoveDriver(ConnectedDevice.Settings.DriverRef, ConnectedDevice.Settings.DriverObject);
		Else
			// @skip-check property-return-type, invocation-parameter-type-intersect
			ErrorDescription = StrTemplate(R().Eq_010, Hardware);
			ResultData.ErrorDescription = ErrorDescription;
		EndIf;
	Else
		ResultData.Result = True;
	EndIf;
	Return ResultData;
EndFunction

// Get driver object.
// 
// Parameters:
//  DriverInfo - See HardwareServer.GetConnectionSettings
// 
// Returns:
//  Structure - Get driver object:
// * ID - String -
// * DriverObject - Arbitrary -
// * DriverRef - CatalogRef.EquipmentDrivers, Arbitrary -
// * Hardware - CatalogRef.Hardware, Arbitrary -
// * AddInID - String, Arbitrary -
// * OldRevision - Boolean - Driver revision less then 3000
// * WriteLog - Boolean - Write log
// * UseIS - Boolean - Use integration settings
// * IntegrationSettings - CatalogRef.IntegrationSettings -
// * LastUseDate - Date -
// * SleepAfter - Number -
Async Function GetDriverObject(DriverInfo) Export
	ConnectionSettings = globalEquipment_GetConnectionSettings(DriverInfo.Hardware);
	If ConnectionSettings.Connected Then
		Return ConnectionSettings.Settings;
	EndIf;
	
	If DriverInfo.UseIS Then
		If Not GetAPIModule(DriverInfo.Hardware).Device_Open(DriverInfo, Undefined, "") Then // Boolean
			Raise "Can not connect to hardware service."
		EndIf;
	Else
		ObjectName = StrSplit(DriverInfo.AddInID, ".");
		ObjectName.Add(ObjectName[1]);
	
		LinkOnDriver = GetURL(DriverInfo.Driver, "Driver");
		Result = Await AttachAddInAsync(LinkOnDriver, ObjectName[1]);
	
		If Not Result Then
			Raise "Can not attach AddIn " + DriverInfo.Driver;
		EndIf;
	
		DriverObject = New (StrConcat(ObjectName, ".")); // Arbitrary
		If DriverObject = Undefined Then
			Raise "Can not connect driver";
		EndIf;
	EndIf;
	DeviceConnection = New Structure;
	DeviceConnection.Insert("ID", "");
	DeviceConnection.Insert("DriverObject", DriverObject);
	DeviceConnection.Insert("DriverRef", DriverInfo.Driver);
	DeviceConnection.Insert("Hardware", DriverInfo.Hardware);
	DeviceConnection.Insert("AddInID", DriverInfo.AddInID);
	DeviceConnection.Insert("OldRevision", DriverInfo.OldRevision);
	DeviceConnection.Insert("WriteLog", DriverInfo.WriteLog);
	DeviceConnection.Insert("IntegrationSettings", DriverInfo.IntegrationSettings);
	DeviceConnection.Insert("UseIS", DriverInfo.UseIS);
	DeviceConnection.Insert("LastUseDate", Date(1, 1, 1));
	DeviceConnection.Insert("SleepAfter", DriverInfo.SleepAfter);
	
	globalEquipment_AddConnectionSettings(DriverInfo.Hardware, DeviceConnection);
	Return DeviceConnection;

EndFunction

// Get last error.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware
//  
// Return:
//  String - Error description
Async Function GetLastError(Hardware) Export
	Device = HardwareServer.GetConnectionSettings(Hardware);
	ConnectedDriver = Await GetDriverObject(Device);
	ErrorDescription = "";
	Device_GetLastError(ConnectedDriver, ConnectedDriver.DriverObject, ErrorDescription);
	FullErrorDescription = String(Hardware) + ": " + ErrorDescription;
	Return FullErrorDescription;
EndFunction

#EndRegion

#Region API

// Connect client hardware.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
Async Procedure ConnectClientHardware(Hardware) Export
	ConnectionNotify = New NotifyDescription("ConnectHardware_End", ThisObject, Hardware);
	ResultData = Await ConnectHardware(Hardware);
	ExecuteNotifyProcessing(ConnectionNotify, ResultData);
EndProcedure

// Diconnect client hardware.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware
Async Procedure DiconnectClientHardware(Hardware) Export
	ConnectionNotify = New NotifyDescription("DisconnectHardware_End", ThisObject, Hardware);
	ResultData = Await DisconnectHardware(Hardware);
	ExecuteNotifyProcessing(ConnectionNotify, ResultData);
EndProcedure

// Fill driver parameters settings.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware
// 	
// Returns:
//  Structure - Fill driver parameters settings:
// * ID - String -
// * Hardware - CatalogRef.Hardware -
// * Callback - NotifyDescription, Undefined -
// * ConnectedDriver - See GetDriverObject
// * ParametersDriver - See ParametersDriverDescription
// * AdditionalCommand - String -
// * SetParameters - Structure -
// * OutParameters - Array of String -
// * ServiceCallback - NotifyDescription, Undefined -
Async Function FillDriverParametersSettings(Hardware) Export
		
	Device = HardwareServer.GetConnectionSettings(Hardware);
	ConnectedDriver = Await GetDriverObject(Device);
	
	Str = New Structure;
	Str.Insert("Hardware", Hardware);
	Str.Insert("Callback", Undefined);
	Str.Insert("ConnectedDriver", ConnectedDriver);
	Str.Insert("ParametersDriver", ParametersDriverDescription());
	Str.Insert("AdditionalCommand", "");
	Str.Insert("SetParameters", Device.ConnectParameters);
	Str.Insert("OutParameters", New Array);
	Str.Insert("ServiceCallback", Undefined);
	//@skip-check constructor-function-return-section
	Return Str;
EndFunction

// Test device.
// 
// Parameters:
//  Settings - See FillDriverParametersSettings
Async Procedure TestDevice(Settings) Export
	If Settings.Hardware.IsEmpty() Then
		Return;
	EndIf;
	
	Settings.ServiceCallback = New NotifyDescription("TestDevice_End", ThisObject, Settings);
	SetParameter(Settings)
EndProcedure

// Set parameter.
// 
// Parameters:
//  Settings - See FillDriverParametersSettings
Async Procedure SetParameter(Settings) Export
	SetParameter_End(True, Undefined, Settings);
EndProcedure

#EndRegion

#Region Service

// Connect hardware end.
// 
// Parameters:
//  Result - Structure:
//  * Result - Boolean
//  Hardware - CatalogRef.Hardware - Param
// @skip-check property-return-type, invocation-parameter-type-intersect
Procedure ConnectHardware_End(Result, Hardware) Export
	If Result.Result Then
		Status(StrTemplate(R().Eq_004, Hardware));
	Else
		Status(StrTemplate(R().Eq_005, Hardware));
	EndIf;
EndProcedure

// Disconnect hardware end.
// 
// Parameters:
//  Result - Structure:
//  * Result - Boolean
//  Hardware - CatalogRef.Hardware - Param
// @skip-check property-return-type, invocation-parameter-type-intersect
Procedure DisconnectHardware_End(Result, Hardware) Export
	If Result.Result Then
		Status(StrTemplate(R().Eq_008, Hardware));
	Else
		Status(StrTemplate(R().Eq_009, Hardware));
	EndIf;
EndProcedure

// Fill driver parameters.
// 
// Parameters:
//  Settings - See FillDriverParametersSettings
Procedure FillDriverParameters(Settings) Export
	#If WebClient Then
		Return;
	#EndIf 
	If Settings.Hardware.IsEmpty() Then
		Return;
	EndIf;
	
	Notify = New NotifyDescription("GetDescription_End", ThisObject, Settings);
	If Settings.ConnectedDriver.OldRevision Then
		Settings.ParametersDriver = Device_GetDescription_2000(Settings.ConnectedDriver, Settings.ConnectedDriver.DriverObject);
		//@skip-check invocation-parameter-type-intersect
		GetDescription_End(True, Settings.ParametersDriver, Settings);
	Else
		Device_GetDescription_Begin(Settings.ConnectedDriver, Settings.ConnectedDriver.DriverObject, Notify);
	EndIf;
EndProcedure

// Get description end.
// 
// Parameters:
//  Result - Boolean - Result
//  Parameters - Array of String, Structure - Parameters
//  Settings - See FillDriverParametersSettings
Procedure GetDescription_End(Result, Parameters, Settings) Export
	If Settings.ConnectedDriver.OldRevision Then
		GetInterfaceRevision_End(Settings.ParametersDriver.InterfaceRevision, Undefined, Settings);
	Else
		ParametersDriver = Settings.ParametersDriver;
		Data = Parameters[0];
		If Not IsBlankString(Parameters[0]) Then
	#If Not WebClient Then
			XMLReader = New XMLReader(); 
			XMLReader.SetString(Data);
			XMLReader.MoveToContent();
			If XMLReader.Name = "DriverDescription" И XMLReader.NodeType = XMLNodeType.StartElement Then
				ParametersDriver.Name = XMLReader.AttributeValue("Name");
				ParametersDriver.Description = XMLReader.AttributeValue("Description");
				ParametersDriver.EquipmentType = XMLReader.AttributeValue("EquipmentType");
				ParametersDriver.DriverVersion = XMLReader.AttributeValue("DriverVersion");
				ParametersDriver.IntegrationComponentVersion = XMLReader.AttributeValue("IntegrationComponentVersion");
				ParametersDriver.IntegrationComponent = StrCompare(XMLReader.AttributeValue("IntegrationComponent"), "TRUE") = 0;
				ParametersDriver.MainDriverInstalled = StrCompare(XMLReader.AttributeValue("MainDriverInstalled"), "TRUE") = 0;
				ParametersDriver.DownloadURL = XMLReader.AttributeValue("DownloadURL");
				ParametersDriver.LogIsEnabled = StrCompare(XMLReader.AttributeValue("LogIsEnabled"), "TRUE") = 0;   
				ParametersDriver.LogPath = XMLReader.AttributeValue("LogPath");
				ParametersDriver.IsEmulator = StrCompare(XMLReader.AttributeValue("IsEmulator"), "TRUE") = 0;
			EndIf;
	#EndIf
		EndIf;
		Settings.ParametersDriver = ParametersDriver;
		Notify = New NotifyDescription("GetInterfaceRevision_End", ThisObject, Settings);
		Device_GetInterfaceRevision_Begin(Settings.ConnectedDriver, Settings.ConnectedDriver.DriverObject, Notify);
	EndIf;
	
EndProcedure

// Get interface revision end.
// 
// Parameters:
//  Result - Number - Interface revision
//  Parameters - Undefined
//  Settings - See FillDriverParametersSettings
Procedure GetInterfaceRevision_End(Result, Parameters, Settings) Export
	Settings.ParametersDriver.InterfaceRevision = Result;
	
	Params = "";
	If Settings.ConnectedDriver.OldRevision Then
		Params = Device_GetParameters_2000(Settings.ConnectedDriver, Settings.ConnectedDriver.DriverObject);
		GetParameters_End(True, Params, Settings);
	Else
		Notify = New NotifyDescription("GetParameters_End", ThisObject, Settings);
		Device_GetParameters_Begin(Settings.ConnectedDriver, Settings.ConnectedDriver.DriverObject, Params, Notify);
	EndIf;
EndProcedure

// Get parameters end.
// 
// Parameters:
//  Result - Boolean - Result
//  Parameters - Array of String - Parameters
//  Settings - See FillDriverParametersSettings
Procedure GetParameters_End(Result, Parameters, Settings) Export
	Settings.ParametersDriver.DriverParametersXML = Parameters[0];
	
	If Settings.ConnectedDriver.OldRevision Then
		Params = Device_GetAdditionalActions_2000(Settings.ConnectedDriver, Settings.ConnectedDriver.DriverObject);
		GetAdditionalActions_End(True, Params, Settings);
	Else
		Notify = New NotifyDescription("GetAdditionalActions_End", ThisObject, Settings);
		Device_GetAdditionalActions_Begin(Settings.ConnectedDriver, Settings.ConnectedDriver.DriverObject, Notify);
	EndIf;
EndProcedure

// Get additional actions end.
// 
// Parameters:
//  Result - Boolean - Result
//  Parameters - Array of String - Parameters
//  Settings - See FillDriverParametersSettings
Procedure GetAdditionalActions_End(Result, Parameters, Settings) Export
	Settings.ParametersDriver.AdditionalActionsXML = Parameters[0];
	Settings.ParametersDriver.Installed = True;
	
	ResultStr = New Structure;
	ResultStr.Insert("Settings", Settings);
	ExecuteNotifyProcessing(Settings.Callback, ResultStr);
EndProcedure

// Set parameter end.
// 
// Parameters:
//  Result - Boolean - Result
//  Parameters - Undefined - Parameters
//  Settings - See FillDriverParametersSettings
Procedure SetParameter_End(Result = True, Parameters = Undefined, Settings) Export
	
	If Not Result Then
		ExecuteNotifyProcessing(Settings.ServiceCallback, Result);
		Return;
	EndIf;
	
	For Each Parameter In Settings.SetParameters Do
		If Settings.ConnectedDriver.OldRevision Then
			// @skip-check property-return-type, invocation-parameter-type-intersect
			Device_SetParameter(Settings.ConnectedDriver, Settings.ConnectedDriver.DriverObject, Parameter.Key, Parameter.Value);
		Else
			Notify = New NotifyDescription("SetParameter_End", ThisObject, Settings);
			// @skip-check property-return-type, invocation-parameter-type-intersect
			Device_SetParameter_Begin(Settings.ConnectedDriver, Settings.ConnectedDriver.DriverObject, Parameter.Key, Parameter.Value, Notify);
			// @skip-check property-return-type, invocation-parameter-type-intersect
			Settings.SetParameters.Delete(Parameter.Key);
			Return;
		EndIf;
	EndDo;
	
	If Settings.SetParameters.Count() = 0 Or Settings.ConnectedDriver.OldRevision Then
		ExecuteNotifyProcessing(Settings.ServiceCallback, Result);
	EndIf;
EndProcedure

// Test device end.
// 
// Parameters:
//  Result - Boolean - Result
//  Settings - See FillDriverParametersSettings
Procedure TestDevice_End(Result, Settings) Export

	TestResult		= "";
	DemoIsActivated = "";

	Device_DeviceTest_Begin(Settings.ConnectedDriver, Settings.ConnectedDriver.DriverObject, TestResult, DemoIsActivated, Settings.Callback);
	
EndProcedure

#EndRegion

#Region Device

// Device open.
// 
// Parameters:
//  Settings - See GetDriverObject
//  DriverObject - Arbitrary - Driver object
//  ID - String - ID
// 
// Returns:
//  Boolean
//  
// @skip-check dynamic-access-method-not-found
Function Device_Open(Settings, DriverObject, ID) Export
	Structure = New Structure("Out", New Structure("ID", ID));
	If Settings.WriteLog Then
		HardwareServer.WriteLog(Settings.Hardware, "Open", True, Structure);
	EndIf;
	
	Result = DriverObject.Open(Structure.Out.ID); // Boolean
	
	If Settings.WriteLog Then
		HardwareServer.WriteLog(Settings.Hardware, "Open", False, Structure, Result);
	EndIf;
	
	If Result And IsBlankString(Structure.Out.ID) Then
		Structure.Out.ID = String(New UUID);
	EndIf;
	
	//@skip-check property-return-type, statement-type-change
	ID = Structure.Out.ID;
	
	If Result Then
		Settings.LastUseDate = CurrentDate();
	EndIf;
	
	Return Result;
EndFunction

// Device close.
// 
// Parameters:
//  Settings - See GetDriverObject
//  DriverObject - Arbitrary - Driver object
//  ID - String - ID
// 
// Returns:
//  Boolean
//  
// @skip-check dynamic-access-method-not-found
Function Device_Close(Settings, DriverObject, ID) Export
	Structure = New Structure("In", New Structure("ID", ID));
	If Settings.WriteLog Then
		HardwareServer.WriteLog(Settings.Hardware, "Close", True, Structure);
	EndIf;
		
	Result = DriverObject.Close(Structure.In.ID); // Boolean
	
	If Settings.WriteLog Then
		HardwareServer.WriteLog(Settings.Hardware, "Close", False, Structure, Result);
	EndIf;
	
	Return Result;
EndFunction

// Device get description begin.
// 
// Parameters:
//  Settings - See GetDriverObject
//  DriverObject - Arbitrary - Driver object
//  Notify - NotifyDescription - Notify
// 
// Returns:
//  Boolean
//  
// @skip-check dynamic-access-method-not-found
Function Device_GetDescription_Begin(Settings, DriverObject, Notify) Export
	Structure = New Structure("Out", New Structure("DriverDescription", ""));
	If Settings.WriteLog Then
		HardwareServer.WriteLog(Settings.Hardware, "BeginCallingGetDescription", True, Structure);
	EndIf;
	Return DriverObject.BeginCallingGetDescription(Notify, Structure.Out.DriverDescription);
EndFunction

// Device get interface revision begin.
// 
// Parameters:
//  Settings - See GetDriverObject
//  DriverObject - Arbitrary - Driver object
//  Notify - NotifyDescription - Notify
// 
// Returns:
//  Boolean
//  
// @skip-check dynamic-access-method-not-found
Function Device_GetInterfaceRevision_Begin(Settings, DriverObject, Notify)
	Structure = New Structure();
	If Settings.WriteLog Then
		HardwareServer.WriteLog(Settings.Hardware, "BeginCallingGetInterfaceRevision", True, Structure);
	EndIf;
	Return DriverObject.BeginCallingGetInterfaceRevision(Notify);
EndFunction

// Device get parameters begin.
// 
// Parameters:
//  Settings - See GetDriverObject
//  DriverObject - Arbitrary - Driver object
//  Params - String - Output parameters
//  Notify - NotifyDescription - Notify
// 
// Returns:
//  Boolean
// @skip-check dynamic-access-method-not-found
Function Device_GetParameters_Begin(Settings, DriverObject, Params, Notify)
	Structure = New Structure();
	If Settings.WriteLog Then
		HardwareServer.WriteLog(Settings.Hardware, "BeginCallingGetParameters", True, Structure);
	EndIf;
	Return DriverObject.BeginCallingGetParameters(Notify, Params);
EndFunction

// Device get additional actions begin.
// 
// Parameters:
//  Settings - See GetDriverObject
//  DriverObject - Arbitrary - Driver object
//  Notify - NotifyDescription - Notify
//  Params - String - Output parameters
// 
// Returns:
//  Boolean
// @skip-check dynamic-access-method-not-found
Function Device_GetAdditionalActions_Begin(Settings, DriverObject, Notify)
	Structure = New Structure("Out", New Structure("TableActions", ""));
	If Settings.WriteLog Then
		HardwareServer.WriteLog(Settings.Hardware, "BeginCallingGetAdditionalActions", True, Structure);
	EndIf;
	Return DriverObject.BeginCallingGetAdditionalActions(Notify, "");
EndFunction

// Device set parameter begin.
// 
// Parameters:
//  Settings - See GetDriverObject
//  DriverObject - Arbitrary - Driver object
//  Name - String - Name
//  Value - String, Number, Boolean, Date - Value
//  Notify - NotifyDescription - Notify
// 
// Returns:
//  Boolean
// @skip-check dynamic-access-method-not-found
Function Device_SetParameter_Begin(Settings, DriverObject, Name, Value, Notify)
	Structure = New Structure("In", New Structure("Name, Value", Name, Value));
	If Settings.WriteLog Then
		HardwareServer.WriteLog(Settings.Hardware, "BeginCallingSetParameter", True, Structure);
	EndIf;
	Return DriverObject.BeginCallingSetParameter(Notify, Structure.In.Name, Structure.In.Value);
EndFunction

// Device device test begin.
// 
// Parameters:
//  Settings - See GetDriverObject
//  DriverObject - Arbitrary - Driver object
//  TestResult - String - Test result
//  DemoIsActivated - String - Demo is activated
//  Notify - NotifyDescription - Notify
// 
// Returns:
//  Boolean
// @skip-check dynamic-access-method-not-found
Function Device_DeviceTest_Begin(Settings, DriverObject, TestResult, DemoIsActivated, Notify)
	Structure = New Structure("In", New Structure("TestResult, DemoIsActivated", TestResult, DemoIsActivated));
	If Settings.WriteLog Then
		HardwareServer.WriteLog(Settings.Hardware, "BeginCallingDeviceTest", True, Structure);
	EndIf;
	Return DriverObject.BeginCallingDeviceTest(Notify, Structure.In.TestResult, Structure.In.DemoIsActivated);
EndFunction

// Device set parameter.
// 
// Parameters:
//  Settings - See GetDriverObject
//  DriverObject - Arbitrary - Driver object
//  Name - String - Parameter name
//  Value - String - Parameter value
// 
// Returns:
//  Boolean
//  
// @skip-check dynamic-access-method-not-found
Function Device_SetParameter(Settings, DriverObject, Name, Value)
	 
	If Settings.UseIS Then
		Return True;
	EndIf;
	
	Structure = New Structure("In", New Structure("Name, Value", Name, Value));
	If Settings.WriteLog Then
		HardwareServer.WriteLog(Settings.Hardware, "SetParameter", True, Structure);
	EndIf;
	
	Result =  DriverObject.SetParameter(Structure.In.Name, Structure.In.Value); // Boolean
	
	If Settings.WriteLog Then
		HardwareServer.WriteLog(Settings.Hardware, "SetParameter", False, Structure, Result);
	EndIf;
		
	Return Result;
EndFunction

// Get last error.
// 
// Parameters:
//  Settings - See GetDriverObject
//  DriverObject - Arbitrary - Driver object
//  ErrorDescription - String - Error result text
// 
// Returns:
//  Boolean
//  
// @skip-check dynamic-access-method-not-found
Function Device_GetLastError(Settings, DriverObject, ErrorDescription)
	Structure = New Structure;
	Structure.Insert("Out", New Structure);
	Structure.Out.Insert("ErrorDescription", "");
	If Settings.WriteLog Then
		HardwareServer.WriteLog(Settings.Hardware, "GetLastError", True, Structure);
	EndIf;
	
	//@skip-check property-return-type
	Result =  DriverObject.GetLastError(Structure.Out.ErrorDescription); // Boolean
	//@skip-check property-return-type
	ErrorDescription = Structure.Out.ErrorDescription; // String
	
	If Settings.WriteLog Then
		HardwareServer.WriteLog(Settings.Hardware, "GetLastError", False, Structure, Result);
	EndIf;
		
	Return Result;
EndFunction

// Device get interface revision.
// 
// Parameters:
//  Settings - See GetDriverObject
//  DriverObject - Arbitrary - Driver object
//  Notify - NotifyDescription - Notify
// 
// Returns:
//  Number
//  
// @skip-check dynamic-access-method-not-found
Function Device_GetInterfaceRevision(Settings, DriverObject) Export
	Structure = New Structure();
	If Settings.WriteLog Then
		HardwareServer.WriteLog(Settings.Hardware, "GetInterfaceRevision", True, Structure);
	EndIf;
	Try
		Result = DriverObject.GetInterfaceRevision(); // Number
	Except
		Result = 2000;
	EndTry;
	
	If Settings.WriteLog Then
		HardwareServer.WriteLog(Settings.Hardware, "GetInterfaceRevision", False, Result, True);
	EndIf;
	
	Return Result;
EndFunction

// Device get description 2000.
// @skip-check dynamic-access-method-not-found
// 
// Parameters:
//  Settings - See GetDriverObject
//  DriverObject - Arbitrary - Driver object
// 
// Returns:
//  See ParametersDriverDescription
Function Device_GetDescription_2000(Settings, DriverObject) Export
	SettingsDescription = ParametersDriverDescription();
	Result = DriverObject.GetDescription(SettingsDescription.Name, SettingsDescription.Description, SettingsDescription.EquipmentType, 
		SettingsDescription.InterfaceRevision, SettingsDescription.IntegrationComponent, 
		SettingsDescription.MainDriverInstalled, SettingsDescription.DownloadURL); // Boolean
		
	If Settings.WriteLog Then
		HardwareServer.WriteLog(Settings.Hardware, "GetDescription", False, SettingsDescription, Result);
	EndIf;	
	Return SettingsDescription;
EndFunction

// Device get parameters 2000.
// 
// Parameters:
//  Settings - See GetDriverObject
//  DriverObject - Arbitrary - Driver object
// 
// Returns:
//  String
//
// @skip-check dynamic-access-method-not-found
Function Device_GetParameters_2000(Settings, DriverObject) Export
	Parameters = "";
	Result = DriverObject.GetParameters(Parameters); // Boolean
	
	If Settings.WriteLog Then
		HardwareServer.WriteLog(Settings.Hardware, "GetParameters", False, Parameters, Result);
	EndIf;	
	
	Array = New Array; // Array of String
	Array.Add(Parameters);
	Return Array;
EndFunction

// Device get additional actions 2000.
// 
// Parameters:
//  Settings - See GetDriverObject
//  DriverObject - Arbitrary - Driver object
// 
// Returns:
//  String
//
// @skip-check dynamic-access-method-not-found
Function Device_GetAdditionalActions_2000(Settings, DriverObject) Export
	Parameters = "";
	Result = DriverObject.GetAdditionalActions(Parameters); // Boolean
	
	If Settings.WriteLog Then
		HardwareServer.WriteLog(Settings.Hardware, "GetParameters", False, Parameters, Result);
	EndIf;	
	
	Array = New Array; // Array of String
	Array.Add(Parameters);
	Return Array;
EndFunction

#EndRegion

#Region GlobalEquipment

// New equipments.
// 
// Returns:
//  Structure - New equipments:
// * Drivers - Map:
// ** Key - CatalogRef.EquipmentDrivers
// ** Value - Arbitrary
// * ConnectionSettings - Map:
// ** Key - CatalogRef.Hardware
// ** Value - See HardwareClient.FillDriverParametersSettings
Function NewEquipments() Export
	globalEquipment = New Structure();
	globalEquipment.Insert("Drivers", New Map());
	globalEquipment.Insert("ConnectionSettings", New Map());
	Return globalEquipment;
EndFunction

// Global equipments add driver.
// 
// Parameters:
//  EquipmentDriver - CatalogRef.EquipmentDrivers - Equipment driver
//  DriverObject - Arbitrary - Driver object
Procedure globalEquipments_AddDriver(EquipmentDriver, DriverObject)
	globalEquipment = globalEquipments; // See NewEquipments
	globalEquipment.Drivers.Insert(EquipmentDriver, DriverObject);
EndProcedure

// Global equipments remove driver.
// 
// Parameters:
//  EquipmentDriver - CatalogRef.EquipmentDrivers - Equipment driver
//  DriverObject - Arbitrary - Driver object
Procedure globalEquipments_RemoveDriver(EquipmentDriver, DriverObject)
	globalEquipment = globalEquipments; // See NewEquipments
	globalEquipment.Drivers.Delete(EquipmentDriver);
EndProcedure

// Global equipment add connection settings.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  DeviceConnection - See GetDriverObject
Procedure globalEquipment_AddConnectionSettings(Hardware, DeviceConnection)
	globalEquipment = globalEquipments; // See NewEquipments
	globalEquipment.ConnectionSettings.Insert(Hardware, DeviceConnection);
EndProcedure

// Global equipment remove connection settings.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
Procedure globalEquipment_RemoveConnectionSettings(Hardware)
	globalEquipment = globalEquipments; // See NewEquipments
	globalEquipment.ConnectionSettings.Delete(Hardware);
EndProcedure

// Global equipment set hardware ID.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  ID - String - ID
Procedure globalEquipment_SetHardwareID(Hardware, ID)
	globalEquipment = globalEquipments; // See NewEquipments
	ConnectionSettings = globalEquipment.ConnectionSettings.Get(Hardware); // See GetDriverObject
	ConnectionSettings.ID = ID;
EndProcedure

// Get connection settings.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware
// 
// Returns:
//  Structure - Get connection settings:
// * Connected - Boolean -
// * Settings - See GetDriverObject
Function globalEquipment_GetConnectionSettings(Hardware) Export
	
	Str = New Structure;
	Str.Insert("Connected", False);
	Str.Insert("Settings", New Structure);
	globalEquipment = globalEquipments; // See NewEquipments
	CurrentConnection = globalEquipment.ConnectionSettings.Get(Hardware); // See GetDriverObject
	
	If Not CurrentConnection = Undefined Then
		If CurrentConnection.SleepAfter > 0 Then
			//@skip-check use-non-recommended-method
			Str.Connected = CurrentDate() - CurrentConnection.LastUseDate < CurrentConnection.SleepAfter;
		Else
			Str.Connected = True;
		EndIf;
		If Str.Connected Then
			Str.Settings = CurrentConnection;
		Else
			globalEquipment_RemoveConnectionSettings(Hardware);
		EndIf;
	EndIf;
	
	Return Str;
EndFunction

// Get APIModule.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware
// 
// Returns:
//  CommonModule
Function GetAPIModule(Hardware) Export
	
	EquipmentAPIModule = CommonFunctionsServer.GetRefAttribute(Hardware, "EquipmentAPIModule"); // EnumRef.EquipmentAPIModule
	
	APIModule = Undefined;
	
	If EquipmentAPIModule = PredefinedValue("Enum.EquipmentAPIModule.Acquiring_CommonAPI") Then
		APIModule = EquipmentAcquiring_CommonAPI;
	ElsIf EquipmentAPIModule = PredefinedValue("Enum.EquipmentAPIModule.FiscalPrinter_CommonAPI") Then
		APIModule = EquipmentFiscalPrinter_CommonAPI;
	EndIf;
	
	If APIModule = Undefined Then
		APIModule = GetAPIModule_Extension(EquipmentAPIModule);
	EndIf;
	
	If APIModule = Undefined Then
		APIModule = HardwareClient;
	EndIf;
	
	Return APIModule;
EndFunction

// Get APIModule.
// 
// Parameters:
//  EquipmentAPIModule - EnumRef.EquipmentAPIModule
// 
// Returns:
//  CommonModule
Function GetAPIModule_Extension(EquipmentAPIModule) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Settings

// Parameters driver description.
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
Function ParametersDriverDescription() Export
	
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

// Get default settings.
// 
// Parameters:
//  EquipmentType - EnumRef.EquipmentTypes
// 
// Returns:
//  Structure - Get default settings:
// * COMEncoding - String -
// * DataBits - Number -
// * GSSymbolKey - Number -
// * IgnoreKeyboardState - Boolean -
// * OutputDataType - Number -
// * Port - Number -
// * Prefix - Number -
// * Speed - Number -
// * StopBit - Number -
// * Suffix - Number -
// * Timeout - Number -
// * TimeoutCOM - Number -
Function GetDefaultSettings(EquipmentType) Export
	Settings = New Structure();
	If EquipmentType = PredefinedValue("Enum.EquipmentTypes.InputDevice") Then
		Settings.Insert("COMEncoding", "UTF-8");
		Settings.Insert("DataBits", 8);
		Settings.Insert("GSSymbolKey", -1);
		Settings.Insert("IgnoreKeyboardState", True);
		Settings.Insert("OutputDataType", 0);
		Settings.Insert("Port", 3);
		Settings.Insert("Prefix", -1);
		Settings.Insert("Speed", 9600);
		Settings.Insert("StopBit", 0);
		Settings.Insert("Suffix", 13);
		Settings.Insert("Timeout", 75);
		Settings.Insert("TimeoutCOM", 5);
	EndIf;
	Return Settings;
EndFunction

#EndRegion
