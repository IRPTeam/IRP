// @strict-types

Var globalEquipments Export; // see NewEquipments

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
	ServiceSystemClient.SetSessionParameter("Workstation", WorkstationClient.GetCurrentWorkstation());

	ClientApplication.SetCaption(ServiceSystemClient.GetProgramTitle());
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