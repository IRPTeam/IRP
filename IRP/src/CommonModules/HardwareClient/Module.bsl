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
//  ID - String - ID
//  NotifyOnCloseArchive - NotifyDescription - Notify on close archive
Procedure InstallDriver(ID, NotifyOnCloseArchive = Undefined) Export
	DriversData = HardwareServer.GetDriverSettings(ID);
	DriverRef = GetURL(DriversData.EquipmentDriver, "Driver");
	BeginInstallAddIn(NotifyOnCloseArchive, DriverRef);
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
//  * ConnectParameters - Structure
Async Function ConnectHardware(Hardware) Export
	Device = HardwareServer.GetConnectionSettings(Hardware);
	ResultData = New Structure();
	ResultData.Insert("Result", False);
	ResultData.Insert("ErrorDescription", "");
	ResultData.Insert("ConnectParameters", New Structure());
	
	ConnectedDevice = globalEquipment_GetConnectionSettings(Device);
	If Not ConnectedDevice.Connected Then

		Settings = Await FillDriverParametersSettings(Hardware);
		
		If Settings.ConnectedDriver = Undefined Then
			// @skip-check property-return-type, invocation-parameter-type-intersect
			ErrorDescription = StrTemplate(R().Eq_007, Hardware);
			ResultData.ErrorDescription = ErrorDescription;
			ResultData.ConnectParameters = Device.ConnectParameters;
		Else
			//@skip-check module-unused-local-variable
			ResultSetParameter = Device_SetParameter(Settings.ConnectedDriver.DriverObject, "EquipmentType", Settings.ConnectedDriver.DriverEquipmentType);
			Result = Device_Open(Settings.ConnectedDriver.DriverObject, Settings.ConnectedDriver.ID); // Boolean
			globalEquipment_SetHardwareID(Settings.Hardware, Settings.ConnectedDriver.ID);
			If Settings.ConnectedDriver.DriverObject <> Undefined Then
				// @skip-check property-return-type, invocation-parameter-type-intersect
				ErrorDescription = String(R().Eq_003);
				ResultData.Result = Result;
				ResultData.ErrorDescription = ErrorDescription;
				ResultData.ConnectParameters = Settings.ConnectedDriver;
			EndIf;
		EndIf;
	Else
		If ConnectedDevice.Settings.DriverObject <> Undefined Then
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
	Device = HardwareServer.GetConnectionSettings(Hardware);
	ResultData = New Structure();
	ResultData.Insert("Result", False);
	ResultData.Insert("ErrorDescription", "");
	
	ConnectedDevice = globalEquipment_GetConnectionSettings(Device);
	If ConnectedDevice.Connected Then

		Result = Device_Close(ConnectedDevice.Settings.DriverObject, ConnectedDevice.Settings.ID); // Boolean
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
// * DriverEquipmentType - String -
// * DriverRef - CatalogRef.EquipmentDrivers, Arbitrary -
// * Hardware - CatalogRef.Hardware, Arbitrary -
// * AddInID - String, Arbitrary -
Async Function GetDriverObject(DriverInfo)
	ConnectionSettings = globalEquipment_GetConnectionSettings(DriverInfo);
	If ConnectionSettings.Connected Then
		Return ConnectionSettings.Settings;
	EndIf;
	
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

	DeviceConnection = New Structure;
	DeviceConnection.Insert("ID", "");
	DeviceConnection.Insert("DriverObject", DriverObject);
	DeviceConnection.Insert("DriverEquipmentType", DriverInfo.DriverEquipmentType);
	DeviceConnection.Insert("DriverRef", DriverInfo.Driver);
	DeviceConnection.Insert("Hardware", DriverInfo.Hardware);
	DeviceConnection.Insert("AddInID", DriverInfo.AddInID);
	globalEquipment_AddConnectionSettings(DriverInfo.Hardware, DeviceConnection);
	Return DeviceConnection;

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
// 	AutoConnect - Boolean - Open device if it closed
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
// * OutParameters - Array of Number -
// * ServiceCallback - NotifyDescription, Undefined -
Async Function FillDriverParametersSettings(Hardware, AutoConnect = True) Export
		
	Device = HardwareServer.GetConnectionSettings(Hardware);
	ConnectedDriver = Await GetDriverObject(Device);
	
	If AutoConnect And IsBlankString(ConnectedDriver.ID) Then
		Device_Open(ConnectedDriver.DriverObject, ConnectedDriver.ID);
	EndIf;
	
	Str = New Structure;
	Str.Insert("Hardware", Hardware);
	Str.Insert("Callback", Undefined);
	Str.Insert("ConnectedDriver", ConnectedDriver);
	Str.Insert("ParametersDriver", ParametersDriverDescription());
	Str.Insert("AdditionalCommand", "");
	Str.Insert("SetParameters", New Structure);
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
	Device_GetDescription_Begin(Settings.ConnectedDriver.DriverObject, Notify);
EndProcedure

// Get description end.
// 
// Parameters:
//  Result - Boolean - Result
//  Parameters - Array of String - Parameters
//  Settings - See FillDriverParametersSettings
Procedure GetDescription_End(Result, Parameters, Settings) Export
	ParametersDriver = Settings.ParametersDriver;
	Data = Parameters[0];
	If Not IsBlankString(Parameters[0]) Then
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
	EndIf;
	Settings.ParametersDriver = ParametersDriver;
	
	Notify = New NotifyDescription("GetInterfaceRevision_End", ThisObject, Settings);
	Device_GetInterfaceRevision_Begin(Settings.ConnectedDriver.DriverObject, Notify);
EndProcedure

// Get interface revision end.
// 
// Parameters:
//  Result - Number - Interface revision
//  Parameters - Undefined
//  Settings - See FillDriverParametersSettings
Procedure GetInterfaceRevision_End(Result, Parameters, Settings) Export
	Settings.ParametersDriver.InterfaceRevision = Result;
	
	Notify = New NotifyDescription("GetParameters_End", ThisObject, Settings);
	Params = "";
	Device_GetParameters_Begin(Settings.ConnectedDriver.DriverObject, Params, Notify);
EndProcedure

// Get parameters end.
// 
// Parameters:
//  Result - Boolean - Result
//  Parameters - Array of String - Parameters
//  Settings - See FillDriverParametersSettings
Procedure GetParameters_End(Result, Parameters, Settings) Export
	Settings.ParametersDriver.DriverParametersXML = Parameters[0];
	
	Notify = New NotifyDescription("GetAdditionalActions_End", ThisObject, Settings);
	Device_GetAdditionalActions_Begin(Settings.ConnectedDriver.DriverObject, Notify);
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
		Notify = New NotifyDescription("SetParameter_End", ThisObject, Settings);
		// @skip-check property-return-type, invocation-parameter-type-intersect
		Device_SetParameter_Begin(Settings.ConnectedDriver.DriverObject, Parameter.Key, Parameter.Value, Notify);
		// @skip-check property-return-type, invocation-parameter-type-intersect
		Settings.SetParameters.Delete(Parameter.Key);
		Return;
	EndDo;
	
	If Settings.SetParameters.Count() = 0 Then
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

	Device_DeviceTest_Begin(Settings.ConnectedDriver.DriverObject, TestResult, DemoIsActivated, Settings.Callback);
	
EndProcedure

#EndRegion

#Region Device

// Device open.
// 
// Parameters:
//  DriverObject - Arbitrary - Driver object
//  ID - String - ID
// 
// Returns:
//  Boolean
//  
// @skip-check dynamic-access-method-not-found
Function Device_Open(DriverObject, ID)
	Return DriverObject.Open(ID);
EndFunction

// Device close.
// 
// Parameters:
//  DriverObject - Arbitrary - Driver object
//  ID - String - ID
// 
// Returns:
//  Boolean
//  
// @skip-check dynamic-access-method-not-found
Function Device_Close(DriverObject, ID)
	Return DriverObject.Close(ID); // Boolean
EndFunction

// Device set parameter.
// 
// Parameters:
//  DriverObject - Arbitrary - Driver object
//  Name - String - Parameter name
//  Value - String - Parameter value
// 
// Returns:
//  Boolean
//  
// @skip-check dynamic-access-method-not-found
Function Device_SetParameter(DriverObject, Name, Value)
	Return DriverObject.SetParameter(Name, Value);
EndFunction

// Device get description begin.
// 
// Parameters:
//  DriverObject - Arbitrary - Driver object
//  Notify - NotifyDescription - Notify
// 
// Returns:
//  Boolean
//  
// @skip-check dynamic-access-method-not-found
Function Device_GetDescription_Begin(DriverObject, Notify)
	Return DriverObject.НачатьВызовПолучитьОписание(Notify, "");
EndFunction

// Device get interface revision begin.
// 
// Parameters:
//  DriverObject - Arbitrary - Driver object
//  Notify - NotifyDescription - Notify
// 
// Returns:
//  Boolean
//  
// @skip-check dynamic-access-method-not-found
Function Device_GetInterfaceRevision_Begin(DriverObject, Notify)
	Return DriverObject.НачатьВызовПолучитьРевизиюИнтерфейса(Notify);
EndFunction

// Device get parameters begin.
// 
// Parameters:
//  DriverObject - Arbitrary - Driver object
//  Params - String - Output parameters
//  Notify - NotifyDescription - Notify
// 
// Returns:
//  Boolean
// @skip-check dynamic-access-method-not-found
Function Device_GetParameters_Begin(DriverObject, Params, Notify)
	Return DriverObject.НачатьВызовПолучитьПараметры(Notify, Params);
EndFunction

// Device get additional actions begin.
// 
// Parameters:
//  DriverObject - Arbitrary - Driver object
//  Notify - NotifyDescription - Notify
//  Params - String - Output parameters
// 
// Returns:
//  Boolean
// @skip-check dynamic-access-method-not-found
Function Device_GetAdditionalActions_Begin(DriverObject, Notify)
	Return DriverObject.НачатьВызовПолучитьПараметры(Notify, "");
EndFunction

// Device set parameter begin.
// 
// Parameters:
//  DriverObject - Arbitrary - Driver object
//  Name - String - Name
//  Value - String, Number, Boolean, Date - Value
//  Notify - NotifyDescription - Notify
// 
// Returns:
//  Boolean
// @skip-check dynamic-access-method-not-found
Function Device_SetParameter_Begin(DriverObject, Name, Value, Notify)
	Return DriverObject.НачатьВызовУстановитьПараметр(Notify, Name, Value);
EndFunction

// Device device test begin.
// 
// Parameters:
//  DriverObject - Arbitrary - Driver object
//  TestResult - String - Test result
//  DemoIsActivated - String - Demo is activated
//  Notify - NotifyDescription - Notify
// 
// Returns:
//  Boolean
// @skip-check dynamic-access-method-not-found
Function Device_DeviceTest_Begin(DriverObject, TestResult, DemoIsActivated, Notify)
	Return DriverObject.НачатьВызовТестУстройства(Notify, TestResult, DemoIsActivated);
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
//  Device - See HardwareServer.GetConnectionSettings
// 
// Returns:
//  Structure - Get connection settings:
// * Connected - Boolean -
// * Settings - See GetDriverObject
Function globalEquipment_GetConnectionSettings(Device) Export
	
	Str = New Structure;
	Str.Insert("Connected", False);
	Str.Insert("Settings", New Structure);
	globalEquipment = globalEquipments; // See NewEquipments
	CurrentConnection = globalEquipment.ConnectionSettings.Get(Device.Hardware); // See GetDriverObject
	
	If Not CurrentConnection = Undefined Then
		Str.Connected = True;
		Str.Settings = CurrentConnection;
	EndIf;
	
	Return Str;
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
