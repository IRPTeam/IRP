
#Region Public

Function GetDriverSettings(AddInID) Export
	Query = New Query;
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
	Settings = New Structure;
	If SelectionDetailRecords.Next() Then
		Settings.Insert("EquipmentDriver", SelectionDetailRecords.Ref);
		Settings.Insert("AddInID", SelectionDetailRecords.AddInID);
		Settings.Insert("DriverLoaded", SelectionDetailRecords.DriverLoaded);
	EndIf;
	Return Settings;
EndFunction

Function GetConnectionSettings(HardwareRef = Undefined, Name = "") Export
	
	If Not IsBlankString(Name) Then
		HardwareRef = Catalogs.Hardware.FindByDescription(Name);
	EndIf;
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	Hardware.Ref,
		|	Hardware.Workstation,
		|	Hardware.EquipmentType,
		|	Hardware.Driver,
		|	Hardware.Driver.AddInID AS AddInID
		|FROM
		|	Catalog.Hardware AS Hardware
		|WHERE
		|	Hardware.Ref = &Ref";
	
	Query.SetParameter("Ref", HardwareRef);
	
	QueryResult = Query.Execute();
	
	SelectionDetailRecords = QueryResult.Select();
	Settings = New Structure;
	If SelectionDetailRecords.Next() Then
		Settings.Insert("Hardware", SelectionDetailRecords.Ref);
		Settings.Insert("Workstation", SelectionDetailRecords.Workstation);
		Settings.Insert("EquipmentType", SelectionDetailRecords.EquipmentType);
		Settings.Insert("AddInID", SelectionDetailRecords.AddInID);
		Settings.Insert("Driver", SelectionDetailRecords.Driver);
		
		ConnectParameters = New Structure;
		For Each Row In SelectionDetailRecords.Ref.ConnectParameters Do
			ConnectParameters.Insert(Row.Name, Row.Value);
		EndDo;
		Settings.Insert("ConnectParameters", ConnectParameters);
	EndIf;
	Return Settings;

EndFunction

#EndRegion
