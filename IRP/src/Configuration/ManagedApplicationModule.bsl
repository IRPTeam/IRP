// @strict-types

Var globalEquipments Export; // see HardwareClient.NewEquipments
Var globalWorkstation Export; // CatalogRef.Workstations

Procedure OnStart()
	isMobile = False;
#If MobileAppClient Or MobileClient Or MobileAppServer Then
	isMobile = True;
#EndIf

	ClientType = PredefinedValue("Enum.SystemClientType.Other");

#If MobileAppClient Then
	//@skip-warning
	ClientType = PredefinedValue("Enum.SystemClientType.MobileAppClient");
#ElsIf MobileClient Then
	//@skip-warning
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
	
	UsersEventClient.OpenChangePasswordForm();
	
	AttachIdleHandler("ConnectAllEquipments", 0.1, True);
	
EndProcedure

// Before start.
// 
// Parameters:
//  Cancel - Boolean - Cancel
Procedure BeforeStart(Cancel)
	
	SessionParametersServer.SetUserTimeZone();
	
	AreaStatus = SaasClient.CurrentAreaStatus();
	If AreaStatus.isError Then
		Cancel = True;
		Raise AreaStatus.Status;
	EndIf;

	globalEquipments = HardwareClient.NewEquipments();

EndProcedure

#Region Hardware

Procedure ConnectAllEquipments() Export
	HardwareClient.BeginConnectEquipment(globalWorkstation);
EndProcedure

Procedure ExternEventProcessing(Source, Event, Data)
	If Data <> Undefined Then
		If Event = "NewBarcode" Or Event = "Штрихкод" Then
			Notify("NewBarcode", Data);
		EndIf;
	EndIf;
EndProcedure

#EndRegion