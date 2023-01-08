
#Region Internal

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

Procedure BeginGetDriver(NotifyOnClose, DriverInfo) Export
	ObjectName = StrSplit(DriverInfo.AddInID, ".");
	ObjectName.Add(ObjectName[1]);
	Params = New Structure("ProgID, NotifyOnClose, EquipmentDriver", StrConcat(ObjectName, "."), NotifyOnClose,
		DriverInfo.Driver);
	NotifyDescription = New NotifyDescription("BeginAttachingAddIn_End", ThisObject, Params);

	LinkOnDriver = GetURL(DriverInfo.Driver, "Driver");
	BeginAttachingAddIn(NotifyDescription, LinkOnDriver, ObjectName[1]);
EndProcedure

Procedure BeginAttachingAddIn_End(Connected, AddInfo) Export
	DriverObject = Undefined;

	If Connected Then
		Try
			DriverObject = New (AddInfo.ProgID);
		Except
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().EqError_005, """" + AddInfo.EquipmentDriver
				+ """", """" + AddInfo.ProgID + """"));
			Return;
		EndTry;
		If DriverObject <> Undefined Then
			globalEquipments.Drivers.Insert(AddInfo.EquipmentDriver, DriverObject);
			DriverObject = globalEquipments.Drivers[AddInfo.EquipmentDriver];
		EndIf;
		ExecuteNotifyProcessing(AddInfo.NotifyOnClose, DriverObject);
		Return;
	EndIf;

	ExecuteNotifyProcessing(AddInfo.NotifyOnClose, Undefined);
EndProcedure

Procedure InstallDriver(ID, NotifyOnCloseArchive = Undefined) Export
	DriversData = HardwareServer.GetDriverSettings(ID);
	DriverRef = GetURL(DriversData.EquipmentDriver, "Driver");
	BeginInstallAddIn(NotifyOnCloseArchive, DriverRef);
EndProcedure

Function RunningOperationOnEquipmentParams(Result = False, Error = Undefined, ID = Undefined) Export
	ResultData = New Structure();
	ResultData.Insert("Result", Result);
	ResultData.Insert("ErrorDescription", Error);
	ResultData.Insert("DeviceIdentifier", ID);
	ResultData.Insert("OutParameters", Undefined);
	Return ResultData;
EndFunction

Function GetConnectedDevice(ConnectionsList, ID) Export
	ConnectedDevice = Undefined;
	For Each Connection In ConnectionsList Do
		If Connection.Hardware = ID Then
			ConnectedDevice = Connection;
			Break;
		EndIf;
	EndDo;
	Return ConnectedDevice;
EndFunction

Procedure BeginStartAdditionalCommand_End(DriverObject, CommandParameters) Export
	If DriverObject = Undefined Then
		ErrorText = R().EqError_002;
		OutParameters = New Array();
		OutParameters.Add(999);
		OutParameters.Add(ErrorText);
		OutParameters.Add(R().Eq_002);
		ResultData = RunningOperationOnEquipmentParams(False, ErrorText);
		ResultData.OutParameters = OutParameters;
		ExecuteNotifyProcessing(CommandParameters.NotifyOnClose, ResultData);
	Else
		DeviceData = CommandParameters.DeviceData;
		ProcessingModule = GetProcessingModule(DeviceData.EquipmentType);

		preConnectionParameters = New Structure();
		preConnectionParameters.Insert("EquipmentType", "СканерШтрихкода");

		ErrorText = "";
		OutParameters = Undefined;
		Result = ProcessingModule.RunCommand(CommandParameters.Command, CommandParameters.IncomingParams,
			OutParameters, DriverObject, CommandParameters.Parameters, preConnectionParameters);
		If Not Result Then
			If OutParameters.Count() >= 2 Then
				ErrorText = OutParameters[1];
			EndIf;
			OutParameters.Add(R().Eq_001);
		EndIf;
		ResultData = RunningOperationOnEquipmentParams(Result);
		ResultData.OutParameters = OutParameters;
		ExecuteNotifyProcessing(CommandParameters.NotifyOnClose, ResultData);
	EndIf;
EndProcedure

Async Procedure BeginConnectEquipment(Workstation) Export

	HardwareList = HardwareServer.GetAllWorkstationHardwareList(Workstation);

	For Each Hardware In HardwareList Do
		ConnectionNotify = New NotifyDescription("ConnectHardware_End", ThisObject, Hardware);
		ResultData = Await ConnectHardware(Hardware);
		ExecuteNotifyProcessing(ConnectionNotify, ResultData);
	EndDo;
EndProcedure

Async Function ConnectHardware(Hardware)
	DriverObject = Undefined;
	Device = HardwareServer.GetConnectionSettings(Hardware);
	ResultData = New Structure();
	ResultData.Insert("Result", False);
	ResultData.Insert("ErrorDescription", "");
	ResultData.Insert("ConnectParameters", New Structure());
	
	ConnectedDevice = GetConnectedDevice(globalEquipments.ConnectionSettings, Device.Hardware);
	If ConnectedDevice = Undefined Then

		Settings = Await FillDriverParametersSettings(Hardware);
		
		If Settings.ConnectedDriver = Undefined Then
			ErrorDescription = StrTemplate(R().Eq_007, Hardware);
			ResultData.ErrorDescription = ErrorDescription;
			ResultData.ConnectParameters = Device.ConnectParameters;
		Else
			Result = Settings.ConnectedDriver.DriverObject.SetParameter("EquipmentType", Settings.ConnectedDriver.DriverEquipmentType);
			Result = Settings.ConnectedDriver.DriverObject.Open(Settings.ConnectedDriver.ID);
			globalEquipments.Drivers.Get(Settings.Hardware).ID = Settings.ConnectedDriver.ID;
			If Settings.ConnectedDriver.DriverObject <> Undefined Then
				ErrorDescription = R().Eq_003;
				
				ResultData.Result = Result;
				ResultData.ErrorDescription = ErrorDescription;
				ResultData.ConnectParameters = Device.ConnectParameters;
			EndIf;
		EndIf;
	Else
		If DriverObject <> Undefined Then
			ErrorDescription = R().Eq_003;
			ResultData.Result = True;
			ResultData.ErrorDescription = ErrorDescription;
			ResultData.ConnectParameters = ConnectedDevice.ConnectParameters;
		EndIf;
	EndIf;
	Return ResultData;
EndFunction

#EndRegion

#Region Private

Async Function GetDriverObject(DriverInfo, ErrorText = Undefined)
	AlreadyConnected = globalEquipments.Drivers.Get(DriverInfo.Hardware);
	If Not AlreadyConnected = Undefined Then
		Return AlreadyConnected;
	EndIf;
	
	DriverObject = Undefined;

	If DriverObject = Undefined Then
		ObjectName = StrSplit(DriverInfo.AddInID, ".");
		ObjectName.Add(ObjectName[1]);

		LinkOnDriver = GetURL(DriverInfo.Driver, "Driver");
		Result = Await AttachAddInAsync(LinkOnDriver, ObjectName[1]);

		If Result Then
			DriverObject = New (StrConcat(ObjectName, "."));
		EndIf;
	EndIf;

	If DriverObject = Undefined Then
		Raise "Can not coonnect driver";
	Else
		
		DeviceConnection = New Structure;
		DeviceConnection.Insert("ID", "");
		DeviceConnection.Insert("DriverObject", DriverObject);
		DeviceConnection.Insert("DriverEquipmentType", DriverInfo.DriverEquipmentType);
		DeviceConnection.Insert("DriverRef", DriverInfo.Driver);
		DeviceConnection.Insert("Hardware", DriverInfo.Hardware);
		DeviceConnection.Insert("AddInID", DriverInfo.AddInID);
		globalEquipments.Drivers.Insert(DriverInfo.Hardware, DeviceConnection);
		Return DeviceConnection;
	EndIf;

EndFunction

Function GetProcessingModule(EquipmentType)
	Return HardwareClient;
EndFunction

Procedure ConnectHardware_End(Result, Param) Export
	If Result.Result Then
		Status(StrTemplate(R().Eq_004, Param));
	Else
		Status(StrTemplate(R().Eq_005, Param));
	EndIf;
EndProcedure

#EndRegion

#Region API


// Fill driver parameters settings.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware
// 
// Returns:
//  Structure - Fill driver parameters settings:
// * Hardware - CatalogRef.Hardware -
// * Callback - NotifyDescription, Undefined -
// * ConnectedDriver - Arbitrary, Undefined -
// * ParametersDriver - See ParametersDriverDescription
// * AdditionalCommand - String -
// * SetParameters - Structure -
// * OutParameters - Array of Number -
// * ServiceCallback - NotifyDescription, Undefined -
Async Function FillDriverParametersSettings(Hardware) Export
		
	Device = HardwareServer.GetConnectionSettings(Hardware);
	ConnectedDriver = Await GetDriverObject(Device);
	
	Str = New Structure;
	Str.Insert("ID", "");
	Str.Insert("Hardware", Hardware);
	Str.Insert("Callback", Undefined);
	Str.Insert("ConnectedDriver", ConnectedDriver);
	Str.Insert("ParametersDriver", ParametersDriverDescription());
	Str.Insert("AdditionalCommand", "");
	Str.Insert("SetParameters", New Structure);
	Str.Insert("OutParameters", New Array);
	Str.Insert("ServiceCallback", Undefined);
	Return Str;
EndFunction

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
	Settings.ConnectedDriver.DriverObject.НачатьВызовПолучитьОписание(Notify, "");
EndProcedure

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
	Settings.ConnectedDriver.DriverObject.НачатьВызовПолучитьРевизиюИнтерфейса(Notify);
EndProcedure

Procedure GetInterfaceRevision_End(Result, Parameters, Settings) Export
	Settings.ParametersDriver.InterfaceRevision = Result;
	
	Notify = New NotifyDescription("GetParameters_End", ThisObject, Settings);
	Params = "";
	Settings.ConnectedDriver.DriverObject.НачатьВызовПолучитьПараметры(Notify, Params);
EndProcedure

Procedure GetParameters_End(Result, Parameters, Settings) Export
	Settings.ParametersDriver.DriverParametersXML = Parameters[0];
	
	Notify = New NotifyDescription("GetAdditionalActions_End", ThisObject, Settings);
	Settings.ConnectedDriver.DriverObject.НачатьВызовПолучитьДополнительныеДействия(Notify, "");
EndProcedure

Procedure GetAdditionalActions_End(Result, Parameters, Settings) Export
	Settings.ParametersDriver.AdditionalActionsXML = Parameters[0];
	Settings.ParametersDriver.Installed = True;
	
	Result = New Structure;
	Result.Insert("Settings", Settings);
	ExecuteNotifyProcessing(Settings.Callback, Result);
EndProcedure

Procedure SetParameter_End(Result = True, Parameters = Undefined, Settings) Export
	
	If Not Result Then
		ExecuteNotifyProcessing(Settings.ServiceCallback, Result);
		Return;
	EndIf;
	
	For Each Parameter In Settings.SetParameters Do
		Notify = New NotifyDescription("SetParameter_End", ThisObject, Settings);
		Settings.ConnectedDriver.DriverObject.НачатьВызовУстановитьПараметр(Notify, Parameter.Key, Parameter.Value);
		Settings.SetParameters.Delete(Parameter.Key);
		Return;
	EndDo;
	
	If Settings.SetParameters.Count() = 0 Then
		ExecuteNotifyProcessing(Settings.ServiceCallback, Result);
	EndIf;
EndProcedure

// Test device.
// 
// Parameters:
//  Settings - See FillDriverParametersSettings
Async Procedure TestDevice(Settings) Export
	If Settings.Hardware.IsEmpty() Then
		Return;
	EndIf;
	
	Settings.ServiceCallback = New NotifyDescription("TestDevice_End", ThisObject, Settings);
	SetParameter_End(, , Settings)
EndProcedure

Procedure TestDevice_End(Result, Settings) Export

	TestResult		= "";
	DemoIsActivated = "";

	Settings.ConnectedDriver.DriverObject.НачатьВызовТестУстройства(Settings.Callback, TestResult, DemoIsActivated);
	
EndProcedure

#Region Service

// Parameters driver description.
// 
// Returns:
//  Structure - Parameters driver description:
// * Installed - Boolean -
// * DriverVersion - String - 
// * IntegrationComponentVersion - String -
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
	Result.Insert("DriverVersion");
	Result.Insert("IntegrationComponentVersion");
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

#EndRegion

#EndRegion