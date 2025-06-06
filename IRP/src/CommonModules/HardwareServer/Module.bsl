#Region Public

// Get driver settings.
// 
// Parameters:
//  AddInID - String - AddIn ID
// 
// Returns:
//  Structure -  Get driver settings:
// * EquipmentDriver - CatalogRef.EquipmentDrivers -
// * AddInID - String -
// * DriverLoaded - Boolean -
// * SleepAfter - Number -
Function GetDriverSettings(AddInID) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	EquipmentDrivers.Description,
	|	EquipmentDrivers.Ref,
	|	EquipmentDrivers.Driver,
	|	EquipmentDrivers.AddInID,
	|	EquipmentDrivers.DriverLoaded,
	|	EquipmentDrivers.SleepAfter
	|FROM
	|	Catalog.EquipmentDrivers AS EquipmentDrivers
	|WHERE
	|	EquipmentDrivers.AddInID = &AddInID";

	Query.SetParameter("AddInID", AddInID);

	QueryResult = Query.Execute();

	SelectionDetailRecords = QueryResult.Select();
	Settings = New Structure();
	If SelectionDetailRecords.Next() Then
		Settings.Insert("EquipmentDriver", SelectionDetailRecords.Ref);
		Settings.Insert("AddInID", SelectionDetailRecords.AddInID);
		Settings.Insert("DriverLoaded", SelectionDetailRecords.DriverLoaded);
		Settings.Insert("SleepAfter", SelectionDetailRecords.SleepAfter);
	EndIf;
	Return Settings;
EndFunction

// Get connection settings.
// 
// Parameters:
//  HardwareRef - CatalogRef.Hardware - Hardware ref
// 
// Returns:
//  Structure - Get connection settings:
// * Hardware - CatalogRef.Hardware -
// * EquipmentType - EnumRef.EquipmentTypes -
// * AddInID - String -
// * Driver - CatalogRef.EquipmentDrivers -
// * IntegrationSettings - CatalogRef.IntegrationSettings -
// * ConnectParameters - Structure:
// ** EquipmentType - String -
// * OldRevision - Boolean - Revision less then 3000
// * UseIS - Boolean - Use IntegrationSettings. Driver not using.
// * WriteLog - Boolean -
// * SleepAfter - Number -
Function GetConnectionSettings(HardwareRef) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	Hardware.Ref,
	|	Hardware.EquipmentType,
	|	Hardware.Driver,
	|	ISNULL(Hardware.Driver.SleepAfter, 0) AS SleepAfter,
	|	Hardware.Driver.AddInID AS AddInID,
	|	Hardware.Driver.RevisionNumber < 3000 AS OldRevision,
	|	Hardware.IntegrationSettings,
	|	Hardware.Log
	|FROM
	|	Catalog.Hardware AS Hardware
	|WHERE
	|	Hardware.Ref = &Ref";
	Query.SetParameter("Ref", HardwareRef);
	QueryResult = Query.Execute();

	SelectionDetailRecords = QueryResult.Select();
	Settings = New Structure();
	If SelectionDetailRecords.Next() Then
		Settings.Insert("Hardware", SelectionDetailRecords.Ref);
		Settings.Insert("EquipmentType", SelectionDetailRecords.EquipmentType);
		Settings.Insert("AddInID", SelectionDetailRecords.AddInID);
		Settings.Insert("Driver", SelectionDetailRecords.Driver);
		Settings.Insert("OldRevision", SelectionDetailRecords.OldRevision);
		Settings.Insert("ID", "");
		Settings.Insert("WriteLog", SelectionDetailRecords.Log);
		Settings.Insert("IntegrationSettings", SelectionDetailRecords.IntegrationSettings);
		Settings.Insert("UseIS", Not SelectionDetailRecords.IntegrationSettings.IsEmpty());
		Settings.Insert("SleepAfter", SelectionDetailRecords.SleepAfter);
		
		ConnectParameters = New Structure();
		ConnectParameters.Insert("EquipmentType", GetDriverEquipmentType(SelectionDetailRecords.EquipmentType));
		For Each Row In SelectionDetailRecords.Ref.ConnectParameters Do
			ConnectParameters.Insert(Row.Name, Row.Value);
		EndDo;
		Settings.Insert("ConnectParameters", ConnectParameters);
	EndIf;

	//@skip-check constructor-function-return-section
	Return Settings;
EndFunction

// Get workstation hardware by equipment type.
// 
// Parameters:
//  Workstation - CatalogRef.Workstations - Workstation
//  EquipmentType - EnumRef.EquipmentTypes - Equipment type
// 
// Returns:
//  Array Of CatalogRef.Hardware -  Get workstation hardware by equipment type
Function GetWorkstationHardwareByEquipmentType(Workstation, EquipmentType) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	HardwareList.Hardware
	|FROM
	|	Catalog.Workstations.HardwareList AS HardwareList
	|WHERE
	|	HardwareList.Ref = &Workstation
	|	And HardwareList.Hardware.EquipmentType = &EquipmentType
	|	And HardwareList.Enable
	|	And Not HardwareList.Hardware.DeletionMark";
	Query.SetParameter("Workstation", Workstation);
	Query.SetParameter("EquipmentType", EquipmentType);
	QueryResult = Query.Execute();
	SelectionDetailRecords = QueryResult.Select();
	HardwareList = New Array();
	While SelectionDetailRecords.Next() Do
		HardwareList.Add(SelectionDetailRecords.Hardware);
	EndDo;
	Return HardwareList;
EndFunction

// Get all workstation hardware list.
// 
// Parameters:
//  Workstation - CatalogRef.Workstations - Workstation
// 
// Returns:
//  Array of CatalogRef.Hardware - Get all workstation hardware list
Function GetAllWorkstationHardwareList(Workstation) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	HardwareList.Hardware
	|FROM
	|	Catalog.Workstations.HardwareList AS HardwareList
	|WHERE
	|	HardwareList.Ref = &Workstation
	|	And HardwareList.Enable
	|	And Not HardwareList.Hardware.DeletionMark";
	Query.SetParameter("Workstation", Workstation);
	QueryResult = Query.Execute();
	SelectionDetailRecords = QueryResult.Select();
	HardwareList = New Array();
	While SelectionDetailRecords.Next() Do
		HardwareList.Add(SelectionDetailRecords.Hardware);
	EndDo;
	Return HardwareList;
EndFunction

// Get connection settings.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware ref
// 
// Returns:
//  Array Of KeyAndValue - Connection parameters:
//  * Key - String
//  * Value - String
Function GetConnectionParameters(Hardware) Export
	Str = New Structure;
	For Each Row In Hardware.ConnectParameters Do
		Str.Insert(Row.Name, Row.Value);
	EndDo;
	Return Str;
EndFunction

Procedure WriteLog(Hardware, Val Method, Val isRequest, Val Data, Val Result = False) Export
	
	DataCopy = CopyForWrite(Data);
	FixTypesForWrite(DataCopy);
		
	Reg = InformationRegisters.HardwareLog.CreateRecordManager();
	Reg.Date = CurrentUniversalDateInMilliseconds();
	Reg.Hardware = Hardware;
	Reg.Period = CurrentUniversalDate();
	Reg.User = SessionParameters.CurrentUser;
	Reg.Method = Method;
	Reg.Request = isRequest;
	If TypeOf(DataCopy) = Type("String") Then
		Reg.Data = DataCopy;
	Else
		Reg.Data = CommonFunctionsServer.SerializeJSON(DataCopy);
	EndIf;
	Reg.Result = Result;
	Reg.Write();
	
EndProcedure

// Save ref data.
// 
// Parameters:
//  Data - Structure, String -
// 
// Returns:
//  Structure, String
Function CopyForWrite(Data)
	
	Copy = Data;
	
	If TypeOf(Data) = Type("Structure") Then
		Copy = New Structure();
		For Each DataKeyValue In Data Do
			Copy.Insert(DataKeyValue.Key, CopyForWrite(DataKeyValue.Value));
		EndDo;

	ElsIf TypeOf(Data) = Type("Map") Then
		Copy = New Map();
		For Each DataKeyValue In Data Do
			Copy.Insert(DataKeyValue.Key, CopyForWrite(DataKeyValue.Value));
		EndDo;
		
	ElsIf TypeOf(Data) = Type("Array") Then
		Copy = New Array();
		For Each DataRow In Data Do
			Copy.Add(CopyForWrite(DataRow));
		EndDo;
		
	EndIf;
	
	Return Copy;
	
EndFunction

Procedure FixTypesForWrite(Data) Export
	
	If TypeOf(Data) = Type("Structure") Then
		If Data.Property("Info") Then
			For Each Prop In Data.Info Do
				If Not CommonFunctionsServer.IsPrimitiveValue(Prop.Value) Then
					Data.Info[Prop.Key] = String(Prop.Value);
				EndIf;
			EndDo;
			
			If Data.Info.Property("CRS") And TypeOf(Data.Info.CRS) = Type("Structure") Then
				For Each Prop In Data.Info.CRS Do
					Data.Info.CRS[Prop.Key] = String(Prop.Value);
				EndDo;
			EndIf;
		EndIf;
		If Data.Property("In") And Data.In.Property("CheckPackage") And Data.In.CheckPackage.Property("Positions") Then
			For Each Row In Data.In.CheckPackage.Positions.FiscalStrings Do
				For Each Prop In Row Do
					If Not CommonFunctionsServer.IsPrimitiveValue(Prop.Value) Then
						Row[Prop.Key] = String(Prop.Value);
					EndIf;
				EndDo;
			EndDo;
		EndIf;
	EndIf;
EndProcedure

// Connect client hardware.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
Procedure ConnectClientHardware(Hardware) Export
	ConnectHardware(Hardware);
EndProcedure

// Diconnect client hardware.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware
Procedure DiconnectClientHardware(Hardware) Export
	DisconnectHardware(Hardware);
EndProcedure

// Fill driver parameters settings.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware
// 	
// Returns:
//  See HardwareClientServer.GetDriverParametersSettings
Function FillDriverParametersSettings(Hardware) Export
		
	Device = GetConnectionSettings(Hardware);
	ConnectedDriver = GetDriverObject(Device);
	
	Settings = HardwareClientServer.GetDriverParametersSettings();
	Settings.Hardware = Hardware;
	Settings.Callback = Undefined;
	Settings.ConnectedDriver = ConnectedDriver;
	Settings.ParametersDriver = HardwareClientServer.GetParametersDriverDescription();
	Settings.AdditionalCommand = "";
	Settings.SetParameters = Device.ConnectParameters;
	Settings.OutParameters = New Array;
	Settings.ServiceCallback = Undefined;
	
	Return Settings;
	
EndFunction

// Get APIModule.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware 
// 
// Returns:
//  CommonModule
Function GetAPIModule(Hardware) Export
	
	EquipmentAPIModule = CommonFunctionsServer.GetRefAttribute(Hardware, "EquipmentAPIModule"); // EnumRef.EquipmentAPIModule
	
	APIModule = Undefined;
	
	If APIModule = Undefined Then
		APIModule = GetAPIModule_Extension(EquipmentAPIModule);
	EndIf;
	
	If APIModule = Undefined Then
		APIModule = HardwareServer;
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

#Region Device

// Connect hardware.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
// 
// Returns:
//  See HardwareClientServer.GetConnectHardwareResult
Function ConnectHardware(Hardware) Export
	
	ResultData = HardwareClientServer.GetConnectHardwareResult();

	If Not ValueIsFilled(Hardware) Then
		ResultData.ErrorDescription = R().Eq_013;
		Return ResultData;
	EndIf;
	
	Device = GetConnectionSettings(Hardware);
	Settings = FillDriverParametersSettings(Hardware);
		
	If Settings.ConnectedDriver = Undefined Then
		ErrorDescription = StrTemplate(R().Eq_007, Hardware);
		ResultData.ErrorDescription = ErrorDescription;
		ResultData.ConnectParameters = Device.ConnectParameters;
	Else
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
		
		For Each ParamRow In GetConnectionParameters(Hardware) Do
			Device_SetParameter(Settings.ConnectedDriver, Settings.ConnectedDriver.DriverObject, ParamRow.Key, ParamRow.Value)
		EndDo;
		If Settings.ConnectedDriver.DriverObject <> Undefined OR Result Then
			ErrorDescription = String(R().Eq_003);
			ResultData.Result = Result;
			ResultData.ErrorDescription = ErrorDescription;
			ResultData.ConnectParameters = Settings.ConnectedDriver;
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
//  See HardwareClientServer.GetConnectHardwareResult
Function DisconnectHardware(Hardware) Export
	ResultData = HardwareClientServer.GetConnectHardwareResult();
	
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
			ErrorDescription = StrTemplate(R().Eq_008, Hardware);
			ResultData.ErrorDescription = ErrorDescription;
			globalEquipment_RemoveConnectionSettings(Hardware);
			globalEquipments_RemoveDriver(ConnectedDevice.Settings.DriverRef, ConnectedDevice.Settings.DriverObject);
		Else
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
//  DriverInfo - See GetConnectionSettings
// 
// Returns:
//  See HardwareClientServer.GetDeviceInfo
Function GetDriverObject(DriverInfo) Export
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
		Result = AttachAddIn(LinkOnDriver, ObjectName[1]);
	
		If Not Result Then
			Raise "Can not attach AddIn " + DriverInfo.Driver;
		EndIf;
	
		DriverObject = New (StrConcat(ObjectName, ".")); // Arbitrary
		If DriverObject = Undefined Then
			Raise "Can not connect driver";
		EndIf;
	EndIf;
	
	DeviceConnection = HardwareClientServer.GetDeviceInfo();
	DeviceConnection.ID = "";
	DeviceConnection.DriverObject = DriverObject;
	DeviceConnection.DriverRef = DriverInfo.Driver;
	DeviceConnection.Hardware = DriverInfo.Hardware;
	DeviceConnection.AddInID = DriverInfo.AddInID;
	DeviceConnection.OldRevision = DriverInfo.OldRevision;
	DeviceConnection.WriteLog = DriverInfo.WriteLog;
	DeviceConnection.IntegrationSettings = DriverInfo.IntegrationSettings;
	DeviceConnection.UseIS = DriverInfo.UseIS;
	DeviceConnection.LastUseDate = Date(1, 1, 1);
	DeviceConnection.SleepAfter = DriverInfo.SleepAfter;
	
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
Function GetLastError(Hardware) Export
	Device = GetConnectionSettings(Hardware);
	ConnectedDriver = GetDriverObject(Device);
	ErrorDescription = "";
	Device_GetLastError(ConnectedDriver, ConnectedDriver.DriverObject, ErrorDescription);
	FullErrorDescription = String(Hardware) + ": " + ErrorDescription;
	Return FullErrorDescription;
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
	Structure.Insert("Out", New Structure("ErrorDescription", ""));
	If Settings.WriteLog Then
		WriteLog(Settings.Hardware, "GetLastError", True, Structure);
	EndIf;
	
	Result = DriverObject.GetLastError(Structure.Out.ErrorDescription); // Boolean
	ErrorDescription = Structure.Out.ErrorDescription; // String
	
	If Settings.WriteLog Then
		WriteLog(Settings.Hardware, "GetLastError", False, Structure, Result);
	EndIf;
		
	Return Result;
EndFunction

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
		WriteLog(Settings.Hardware, "Open", True, Structure);
	EndIf;
	
	Result = DriverObject.Open(Structure.Out.ID); // Boolean
	
	If Settings.WriteLog Then
		WriteLog(Settings.Hardware, "Open", False, Structure, Result);
	EndIf;
	
	If Result And IsBlankString(Structure.Out.ID) Then
		Structure.Out.ID = String(New UUID);
	EndIf;
	
	ID = Structure.Out.ID;
	
	If Result Then
		//@skip-check use-non-recommended-method
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
		WriteLog(Settings.Hardware, "Close", True, Structure);
	EndIf;
		
	Result = DriverObject.Close(Structure.In.ID); // Boolean
	
	If Settings.WriteLog Then
		WriteLog(Settings.Hardware, "Close", False, Structure, Result);
	EndIf;
	
	Return Result;
EndFunction

// Device get description begin.
// 
// Parameters:
//  Settings - See GetDriverObject
//  DriverObject - Arbitrary - Driver object
//  Notify - CallbackDescription - Notify
// 
// Returns:
//  Boolean
//  
// @skip-check dynamic-access-method-not-found
Function Device_GetDescription_Begin(Settings, DriverObject, Notify) Export
	Structure = New Structure("Out", New Structure("DriverDescription", ""));
	If Settings.WriteLog Then
		WriteLog(Settings.Hardware, "BeginCallingGetDescription", True, Structure);
	EndIf;
	Return DriverObject.BeginCallingGetDescription(Notify, Structure.Out.DriverDescription);
EndFunction

// Device get interface revision begin.
// 
// Parameters:
//  Settings - See GetDriverObject
//  DriverObject - Arbitrary - Driver object
//  Notify - CallbackDescription - Notify
// 
// Returns:
//  Boolean
//  
// @skip-check dynamic-access-method-not-found
Function Device_GetInterfaceRevision_Begin(Settings, DriverObject, Notify)
	Structure = New Structure();
	If Settings.WriteLog Then
		WriteLog(Settings.Hardware, "BeginCallingGetInterfaceRevision", True, Structure);
	EndIf;
	Return DriverObject.BeginCallingGetInterfaceRevision(Notify);
EndFunction

// Device get parameters begin.
// 
// Parameters:
//  Settings - See GetDriverObject
//  DriverObject - Arbitrary - Driver object
//  Params - String - Output parameters
//  Notify - CallbackDescription - Notify
// 
// Returns:
//  Boolean
// @skip-check dynamic-access-method-not-found
Function Device_GetParameters_Begin(Settings, DriverObject, Params, Notify)
	Structure = New Structure();
	If Settings.WriteLog Then
		WriteLog(Settings.Hardware, "BeginCallingGetParameters", True, Structure);
	EndIf;
	Return DriverObject.BeginCallingGetParameters(Notify, Params);
EndFunction

// Device get additional actions begin.
// 
// Parameters:
//  Settings - See GetDriverObject
//  DriverObject - Arbitrary - Driver object
//  Notify - CallbackDescription - Notify
//  Params - String - Output parameters
// 
// Returns:
//  Boolean
// @skip-check dynamic-access-method-not-found
Function Device_GetAdditionalActions_Begin(Settings, DriverObject, Notify)
	Structure = New Structure("Out", New Structure("TableActions", ""));
	If Settings.WriteLog Then
		WriteLog(Settings.Hardware, "BeginCallingGetAdditionalActions", True, Structure);
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
//  Notify - CallbackDescription - Notify
// 
// Returns:
//  Boolean
// @skip-check dynamic-access-method-not-found
Function Device_SetParameter_Begin(Settings, DriverObject, Name, Value, Notify)
	Structure = New Structure("In", New Structure("Name, Value", Name, Value));
	If Settings.WriteLog Then
		WriteLog(Settings.Hardware, "BeginCallingSetParameter", True, Structure);
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
//  Notify - CallbackDescription - Notify
// 
// Returns:
//  Boolean
// @skip-check dynamic-access-method-not-found
Function Device_DeviceTest_Begin(Settings, DriverObject, TestResult, DemoIsActivated, Notify)
	Structure = New Structure("In", New Structure("TestResult, DemoIsActivated", TestResult, DemoIsActivated));
	If Settings.WriteLog Then
		WriteLog(Settings.Hardware, "BeginCallingDeviceTest", True, Structure);
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
		WriteLog(Settings.Hardware, "SetParameter", True, Structure);
	EndIf;
	
	Result =  DriverObject.SetParameter(Structure.In.Name, Structure.In.Value); // Boolean
	
	If Settings.WriteLog Then
		WriteLog(Settings.Hardware, "SetParameter", False, Structure, Result);
	EndIf;
		
	Return Result;
EndFunction

// Device get interface revision.
// 
// Parameters:
//  Settings - See GetDriverObject
//  DriverObject - Arbitrary - Driver object
//  Notify - CallbackDescription - Notify
// 
// Returns:
//  Number
//  
// @skip-check dynamic-access-method-not-found
Function Device_GetInterfaceRevision(Settings, DriverObject) Export
	Structure = New Structure();
	If Settings.WriteLog Then
		WriteLog(Settings.Hardware, "GetInterfaceRevision", True, Structure);
	EndIf;
	Try
		Result = DriverObject.GetInterfaceRevision(); // Number
	Except
		Result = 2000;
	EndTry;
	
	If Settings.WriteLog Then
		WriteLog(Settings.Hardware, "GetInterfaceRevision", False, Result, True);
	EndIf;
	
	Return Result;
EndFunction

// Device get description 2000.
// 
// Parameters:
//  Settings - See GetDriverObject
//  DriverObject - Arbitrary - Driver object
// 
// Returns:
//  See HardwareClientServer.GetParametersDriverDescription
// @skip-check dynamic-access-method-not-found
Function Device_GetDescription_2000(Settings, DriverObject) Export
	SettingsDescription = HardwareClientServer.GetParametersDriverDescription();
	Result = DriverObject.GetDescription(SettingsDescription.Name, SettingsDescription.Description, SettingsDescription.EquipmentType, 
		SettingsDescription.InterfaceRevision, SettingsDescription.IntegrationComponent, 
		SettingsDescription.MainDriverInstalled, SettingsDescription.DownloadURL); // Boolean
		
	If Settings.WriteLog Then
		WriteLog(Settings.Hardware, "GetDescription", False, SettingsDescription, Result);
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
		WriteLog(Settings.Hardware, "GetParameters", False, Parameters, Result);
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
		WriteLog(Settings.Hardware, "GetParameters", False, Parameters, Result);
	EndIf;	
	
	Array = New Array; // Array of String
	Array.Add(Parameters);
	Return Array;
EndFunction

// GetDataKKT.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetDataKKTSettings
//
// Returns:
//  Boolean - Getting data from the KKT for the registration of the fiscal memory and subsequent work
Function GetDataKKT(Hardware, Settings) Export
	Raise R().Error_044;
	//@skip-check bsl-legacy-check-method-for-statements-after-return
	Return False;
EndFunction

// OperationFN.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetOperationFNSettings
//
// Returns:
//  Boolean - Operation with the fiscal drive. After the operation, a report on the conduct of the corresponding operation is printed.
Function OperationFN(Hardware, Settings) Export
	Raise R().Error_044;
	//@skip-check bsl-legacy-check-method-for-statements-after-return
	Return False;
EndFunction

// OpenShift.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetOpenShiftSettings
//
// Returns:
//  Boolean - Opening of the shift in the KKT. After the operation, a shift opening report is printed.
Function OpenShift(Hardware, Settings) Export
	Raise R().Error_044;
	//@skip-check bsl-legacy-check-method-for-statements-after-return
	Return False;
EndFunction

// CloseShift.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetCloseShiftSettings
//
// Returns:
//  Boolean - Closing of the shift in the KKT. After the operation, a shift closing report is printed.
Function CloseShift(Hardware, Settings) Export
	Raise R().Error_044;
	//@skip-check bsl-legacy-check-method-for-statements-after-return
	Return False;
EndFunction

// ProcessCheck.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetProcessCheckSettings
//
// Returns:
//  Boolean - Formation of a check (receipt) in the KKT. After the operation, a check (receipt) is printed.
Function ProcessCheck(Hardware, Settings) Export
	Raise R().Error_044;
	//@skip-check bsl-legacy-check-method-for-statements-after-return
	Return False;
EndFunction

// ProcessCorrectionCheck.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetProcessCorrectionCheckSettings
//
// Returns:
//  Boolean - Formation of a correction check in the KKT. After the operation, a correction check is printed.
Function ProcessCorrectionCheck(Hardware, Settings) Export
	Raise R().Error_044;
	//@skip-check bsl-legacy-check-method-for-statements-after-return
	Return False;
EndFunction

// PrintTextDocument.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetPrintTextDocumentSettings
//
// Returns:
//  Boolean - Printing a text document on the KKT.
Function PrintTextDocument(Hardware, Settings) Export
	Raise R().Error_044;
	//@skip-check bsl-legacy-check-method-for-statements-after-return
	Return False;
EndFunction

// CashInOutcome.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetCashInOutcomeSettings
//
// Returns:
//  Boolean - Printing a check of income or withdrawal of cash from the cash register.
Function CashInOutcome(Hardware, Settings) Export
	Raise R().Error_044;
	//@skip-check bsl-legacy-check-method-for-statements-after-return
	Return False;
EndFunction

// PrintXReport.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetPrintXReportSettings
//
// Returns:
//  Boolean - Printing a report without resetting.
Function PrintXReport(Hardware, Settings) Export
	Raise R().Error_044;
	//@skip-check bsl-legacy-check-method-for-statements-after-return
	Return False;
EndFunction

// PrintCheckCopy.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetPrintCheckCopySettings
//
// Returns:
//  Boolean - Printing a copy of the check.
Function PrintCheckCopy(Hardware, Settings) Export
	Raise R().Error_044;
	//@skip-check bsl-legacy-check-method-for-statements-after-return
	Return False;
EndFunction

// GetCurrentStatus.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetCurrentStatusSettings
//
// Returns:
//  Boolean - Getting the current state of the KKT.
Function GetCurrentStatus(Hardware, Settings) Export
	Raise R().Error_044;
	//@skip-check bsl-legacy-check-method-for-statements-after-return
	Return False;
EndFunction

// ReportCurrentStatusOfSettlements.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetReportCurrentStatusOfSettlementsSettings
//
// Returns:
//  Boolean - Getting a report on the current state of settlements.
Function ReportCurrentStatusOfSettlements(Hardware, Settings) Export
	Raise R().Error_044;
	//@skip-check bsl-legacy-check-method-for-statements-after-return
	Return False;
EndFunction

// OpenCashDrawer.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetOpenCashDrawerSettings
//
// Returns:
//  Boolean - Opening the cash drawer.
Function OpenCashDrawer(Hardware, Settings) Export
	Raise R().Error_044;
	//@skip-check bsl-legacy-check-method-for-statements-after-return
	Return False;
EndFunction

// GetLineLength.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetLineLengthSettings
//
// Returns:
//  Boolean - Getting the line length for the KKT.
Function GetLineLength(Hardware, Settings) Export
	Raise R().Error_044;
	//@skip-check bsl-legacy-check-method-for-statements-after-return
	Return False;
EndFunction

// OpenSessionRegistrationKM.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetOpenSessionRegistrationKMSettings
//
// Returns:
//  Boolean - Opening a registration session in the control module.
Function OpenSessionRegistrationKM(Hardware, Settings) Export
	Raise R().Error_044;
	//@skip-check bsl-legacy-check-method-for-statements-after-return
	Return False;
EndFunction

// CloseSessionRegistrationKM.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetCloseSessionRegistrationKMSettings
//
// Returns:
//  Boolean - Closing a registration session in the control module.
Function CloseSessionRegistrationKM(Hardware, Settings) Export
	Raise R().Error_044;
	//@skip-check bsl-legacy-check-method-for-statements-after-return
	Return False;
EndFunction

// RequestKM.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetRequestKMSettings
//
// Returns:
//  Boolean - Sending a request to the control module.
Function RequestKM(Hardware, Settings) Export
	Raise R().Error_044;
	//@skip-check bsl-legacy-check-method-for-statements-after-return
	Return False;
EndFunction

// GetProcessingKMResult.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetProcessingKMResultSettings
//
// Returns:
//  Boolean - The method requests the results of the marking code check in the OISM.
Function GetProcessingKMResult(Hardware, Settings) Export
	Raise R().Error_044;
	//@skip-check bsl-legacy-check-method-for-statements-after-return
	Return False;
EndFunction

// ConfirmKM.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetConfirmKMSettings
//
// Returns:
//  Boolean - Confirms or cancels the previously checked KM as part of the document on the sale of marked goods. KM must have been previously checked by the RequestKM method.
Function ConfirmKM(Hardware, Settings) Export
	Raise R().Error_044;
	//@skip-check bsl-legacy-check-method-for-statements-after-return
	Return False;
EndFunction

// Is code string approved
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetProcessingKMResultSettings
//
// Returns:
//  Boolean - Is code string approved
Function isCodeStringApproved(Hardware, Settings) Export
	Raise R().Error_044;
	//@skip-check bsl-legacy-check-method-for-statements-after-return
	Return False;
EndFunction

#EndRegion

#Region Private

Function GetDriverEquipmentType(EquipmentType)
	ReturnValue = "";
	If EquipmentType = Enums.EquipmentTypes.InputDevice Then
		ReturnValue = "СканерШтрихкода";
	ElsIf EquipmentType = Enums.EquipmentTypes.FiscalPrinter Then
		ReturnValue = "ККТ";
	ElsIf EquipmentType = Enums.EquipmentTypes.Acquiring Then
		ReturnValue = "ЭквайринговыйТерминал";
	EndIf;
	Return ReturnValue;
EndFunction

// New equipments.
// 
// Returns:
//  Structure - New equipments:
// * Drivers - Map:
// ** Key - CatalogRef.EquipmentDrivers
// ** Value - Arbitrary
// * ConnectionSettings - Map:
// ** Key - CatalogRef.Hardware
// ** Value - See FillDriverParametersSettings
Function NewEquipments() Export
	globalEquipment = New Structure();
	globalEquipment.Insert("Drivers", New Map());
	globalEquipment.Insert("ConnectionSettings", New Map());
	Return globalEquipment;
EndFunction

// Set new equipments.
// 
Procedure SetNewEquipments() Export
	SessionParameters.ServerEquipments = PutToTempStorage(NewEquipments(), New UUID());
EndProcedure

// Global equipments add driver.
// 
// Parameters:
//  EquipmentDriver - CatalogRef.EquipmentDrivers - Equipment driver
//  DriverObject - Arbitrary - Driver object
Procedure globalEquipments_AddDriver(EquipmentDriver, DriverObject)
	globalEquipment = GetFromTempStorage(SessionParameters.ServerEquipments); // See NewEquipments
	globalEquipment.Drivers.Insert(EquipmentDriver, DriverObject);
EndProcedure

// Global equipments remove driver.
// 
// Parameters:
//  EquipmentDriver - CatalogRef.EquipmentDrivers - Equipment driver
//  DriverObject - Arbitrary - Driver object
Procedure globalEquipments_RemoveDriver(EquipmentDriver, DriverObject)
	globalEquipment = GetFromTempStorage(SessionParameters.ServerEquipments); // See NewEquipments
	globalEquipment.Drivers.Delete(EquipmentDriver);
EndProcedure

// Global equipment add connection settings.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  DeviceConnection - See GetDriverObject
Procedure globalEquipment_AddConnectionSettings(Hardware, DeviceConnection)
	globalEquipment = GetFromTempStorage(SessionParameters.ServerEquipments); // See NewEquipments
	globalEquipment.ConnectionSettings.Insert(Hardware, DeviceConnection);
EndProcedure

// Global equipment remove connection settings.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
Procedure globalEquipment_RemoveConnectionSettings(Hardware)
	globalEquipment = GetFromTempStorage(SessionParameters.ServerEquipments); // See NewEquipments
	globalEquipment.ConnectionSettings.Delete(Hardware);
EndProcedure

// Global equipment set hardware ID.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  ID - String - ID
Procedure globalEquipment_SetHardwareID(Hardware, ID)
	globalEquipment = GetFromTempStorage(SessionParameters.ServerEquipments); // See NewEquipments
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
	globalEquipment = GetFromTempStorage(SessionParameters.ServerEquipments); // See NewEquipments
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

#EndRegion