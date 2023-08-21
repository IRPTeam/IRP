#Region Public

Function GetDriverSettings(AddInID) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	EquipmentDrivers.Description,
	|	EquipmentDrivers.Ref,
	|	EquipmentDrivers.Driver,
	|	EquipmentDrivers.AddInID,
	|	EquipmentDrivers.DriverLoaded
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
Function GetConnectionSettings(HardwareRef) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	Hardware.Ref,
	|	Hardware.EquipmentType,
	|	Hardware.Driver,
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
		
		ConnectParameters = New Structure();
		ConnectParameters.Insert("EquipmentType", GetDriverEquipmentType(SelectionDetailRecords.EquipmentType));
		For Each Row In SelectionDetailRecords.Ref.ConnectParameters Do
			ConnectParameters.Insert(Row.Name, Row.Value);
		EndDo;
		Settings.Insert("ConnectParameters", ConnectParameters);
	EndIf;

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
	EndIf;
	
	Reg = InformationRegisters.HardwareLog.CreateRecordManager();
	Reg.Date = CurrentUniversalDateInMilliseconds();
	Reg.Hardware = Hardware;
	Reg.Period = CurrentUniversalDate();
	Reg.User = SessionParameters.CurrentUser;
	Reg.Method = Method;
	Reg.Request = isRequest;
	Reg.Data = CommonFunctionsServer.SerializeJSON(Data);
	Reg.Result = Result;
	Reg.Write(); 
EndProcedure

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

#EndRegion