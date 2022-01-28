// @strict-types

Var globalEquipments Export; // see NewEquipments
Var globalWorkstation Export; // CatalogRef.Workstations

Procedure OnStart()
	isMobile = False;
#If MobileAppClient Or MobileClient Or MobileAppServer Then
	isMobile = True;
#EndIf

	ClientType = PredefinedValue("Enum.SystemClientType.Other");

#If MobileAppClient Then
	ClientType = PredefinedValue("Enum.SystemClientType.MobileAppClient");
#ElsIf MobileClient Then
	ClientType = PredefinedValue("Enum.SystemClientType.MobileClient");
#ElsIf ThickClientManagedApplication Then
	ClientType = PredefinedValue("Enum.SystemClientType.ThickClientManagedApplication");
#ElsIf ThinClient Then
	ClientType = PredefinedValue("Enum.SystemClientType.ThinClient");
#ElsIf WebClient Then
	ClientType = PredefinedValue("Enum.SystemClientType.WebClient");
#EndIf

	ServiceSystemClient.SetSessionParameter("isMobile", isMobile);
	ServiceSystemClient.SetSessionParameter("ClientType", ClientType);
	globalWorkstation = WorkstationClient.GetCurrentWorkstation();
	ServiceSystemClient.SetSessionParameter("Workstation", globalWorkstation);

	ClientApplication.SetCaption(ServiceSystemClient.GetProgramTitle());
	
	AttachIdleHandler("ConnectAllEquipments", 0.1, True);
EndProcedure

// Before start.
// 
// Parameters:
//  Cancel - Boolean - Cancel
Procedure BeforeStart(Cancel)
	
	AreaStatus = SaasClient.CurrentAreaStatus();
	If AreaStatus.isError Then
		Cancel = True;
		Raise AreaStatus.Status;
	EndIf;

	globalEquipments = NewEquipments();

EndProcedure



#Region Hardware

Procedure ConnectAllEquipments() Export
	HardwareClient.BeginConnectEquipment(globalWorkstation);
EndProcedure

// New equipments.
// 
// Returns:
//  Structure - New equipments:
// * Drivers - Map -
// * ConnectionSettings - Array -
Function NewEquipments()
	globalEquipments = New Structure();
	globalEquipments.Insert("Drivers", New Map());
	globalEquipments.Insert("ConnectionSettings", New Array());
	Return globalEquipments;
EndFunction

#EndRegion