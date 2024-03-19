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
	
	//---------------------------------------------------
	//AttachIdleHandler("OpenDebugForm", 2, True);
	//---------------------------------------------------
EndProcedure

Procedure OpenDebugForm() Export
	OpenForm("AccumulationRegister.R5020B_PartnersBalance.ListForm");
	OpenForm("InformationRegister.T2010S_OffsetOfAdvances.ListForm");
	OpenForm("AccumulationRegister.R1020B_AdvancesToVendors.ListForm");
	OpenForm("AccumulationRegister.R1021B_VendorsTransactions.ListForm");
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
	
	R(); // Init langs
EndProcedure

#Region Hardware

Procedure ConnectAllEquipments() Export
	HardwareClient.BeginConnectEquipment(globalWorkstation);
EndProcedure

Procedure ExternEventProcessing(Source, Event, Data)
	If Data <> Undefined Then
		If BarcodeClient.isBarcodeScanned(Event)  Then
			If StrStartsWith(Source, "InputDevice") Then 	
				For Each Settings In globalEquipments.ConnectionSettings Do
					If Settings.Value.ID = Source Then
						Notify("NewBarcode", Data);
					EndIf;
				EndDo;
			Else
				Notify("NewBarcode", Data);
			EndIf;
		EndIf;
	EndIf;
EndProcedure

#EndRegion