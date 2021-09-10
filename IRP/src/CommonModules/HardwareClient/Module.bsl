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

Procedure BeginStartAdditionalCommand(NotifyOnClose, Command, IncomingParams, ID, Parameters) Export
	ConnectedDevice = GetConnectedDevice(globalEquipments.ConnectionSettings, ID);

	If ConnectedDevice = Undefined Then
		DeviceData = HardwareServer.GetConnectionSettings(ID);
		CommandParameters = New Structure();
		CommandParameters.Insert("Command", Command);
		CommandParameters.Insert("IncomingParams", IncomingParams);
		CommandParameters.Insert("Parameters", Parameters);
		CommandParameters.Insert("DeviceData", DeviceData);
		CommandParameters.Insert("NotifyOnClose", NotifyOnClose);
		Notify = New NotifyDescription("BeginStartAdditionalCommand_End", ThisObject, CommandParameters);
		BeginGetDriver(Notify, DeviceData);
	Else
		OutParameters = New Array();
		OutParameters.Add(999);
		OutParameters.Add(R().EqError_001);
		OutParameters.Add(R().Eq_001);
		ResultData = RunningOperationOnEquipmentParams(False, R().EqError_001, ID);
		ResultData.OutParameters = OutParameters;
		ExecuteNotifyProcessing(NotifyOnClose, ResultData);
	EndIf;
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
			If OutParameters.Количество() >= 2 Then
				ErrorText = OutParameters[1];
			EndIf;
			OutParameters.Add(R().Eq_001);
		EndIf;
		ResultData = RunningOperationOnEquipmentParams(Result);
		ResultData.OutParameters = OutParameters;
		ExecuteNotifyProcessing(CommandParameters.NotifyOnClose, ResultData);
	EndIf;
EndProcedure

Procedure BeginConnectEquipment(HardwareParameters) Export

	ConnectionNotify = Undefined;
	HardwareParameters.Property("ConnectionNotify", ConnectionNotify);
	Workstation = HardwareParameters.Workstation;
	EquipmentType = HardwareParameters.EquipmentType;
	HardwareList = HardwareServer.GetWorkstationHardwareByEquipmentType(Workstation, EquipmentType);

	For Each Hardware In HardwareList Do
		DriverObject = Undefined;
		Device = HardwareServer.GetConnectionSettings(Hardware);

		ConnectedDevice = GetConnectedDevice(globalEquipments.ConnectionSettings, Device.Hardware);
		If ConnectedDevice = Undefined Then
			ProcessingModule = GetProcessingModule(Device.EquipmentType);

			DriverObject = GetDriverObject(Device);
			OutParameters = Undefined;
			Result = ProcessingModule.ConnectDevice(DriverObject, Device.ConnectParameters, OutParameters);

			If OutParameters.Count() >= 2 Then
				Device.Insert("EventSource", OutParameters[0]);
				Device.Insert("EventsNames", OutParameters[1]);
			Else
				Device.Insert("EventSource", "");
				Device.Insert("EventsNames", Undefined);
			EndIf;

			ConnectParameters = globalEquipments.ConnectionSettings;
			ConnectParameters.Add(Device);

			If ConnectionNotify <> Undefined Then
				ErrorDescription = R().Eq_003;
				ResultData = New Structure("Result, ErrorDescription, ConnectParameters", Result, ErrorDescription,
					Device.ConnectParameters);
				ExecuteNotifyProcessing(ConnectionNotify, ResultData);
			EndIf;
		Else
			If ConnectionNotify <> Undefined Then
				ErrorDescription = R().Eq_003;
				ResultData = New Structure("Result, ErrorDescription, ConnectParameters", True, ErrorDescription,
					ConnectedDevice.ConnectParameters);
				ExecuteNotifyProcessing(ConnectionNotify, ResultData);
			EndIf;
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region Private

Function GetDriverObject(DriverInfo, ErrorText = Undefined)
	DriverObject = Undefined;

	For Each DriverData Из globalEquipments.Drivers Do
		If DriverData.Key = DriverInfo.Driver Then
			DriverObject = DriverData.Value;
			Return DriverObject;
		EndIf;
	EndDo;

	If DriverObject = Undefined Then
		ObjectName = StrSplit(DriverInfo.AddInID, ".");
		ObjectName.Add(ObjectName[1]);

		LinkOnDriver = GetURL(DriverInfo.Driver, "Driver");
		Result = AttachAddIn(LinkOnDriver, ObjectName[1]);

		If Result Then
			DriverObject = New (StrConcat(ObjectName, "."));
		EndIf;
	EndIf;

	If DriverObject <> Undefined Then
		globalEquipments.Drivers.Insert(DriverInfo.Driver, DriverObject);
		DriverObject = globalEquipments.Drivers[DriverInfo.Driver];
	EndIf;

	Return DriverObject;
EndFunction

Function GetProcessingModule(EquipmentType)
	Return Undefined;
EndFunction

#EndRegion