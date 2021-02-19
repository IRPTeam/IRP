
Var globalEquipments Export; 

Procedure OnStart()
	isMobile = False;
	ClientType = PredefinedValue("Enum.SystemClientType.Other");

	ServiceSystemClient.SetSessionParameter("isMobile", isMobile);
	ServiceSystemClient.SetSessionParameter("ClientType", ClientType);
	ServiceSystemClient.SetSessionParameter("Workstation", WorkstationClient.GetCurrentWorkstation());
	
	If Not Saas.isAreaActive() 
	   And (Saas.isAreaActive() And Not Saas.CurrentAreaID() = 0) Then

		If Not ServiceSystemServer.GetConstantValue("NotFirstStart") Then
			FillingFromClassifiers.FillDescriptionOfPredefinedCatalogs();
			ServiceSystemServer.SetConstantValue("NotFirstStart", True);
		EndIf;

	EndIf;
	
	ClientApplication.SetCaption(ServiceSystemClient.GetProgramTitle());
EndProcedure

Procedure BeforeStart(Cancel)
	AreaStatus = SaasClient.CurrentAreaStatus();
	If AreaStatus.isError Then
		Cancel = True;
		Raise AreaStatus.Status;
	EndIf;
	
	globalEquipments = New Structure;
	globalEquipments.Insert("Drivers", New Map);
	globalEquipments.Insert("ConnectionSettings" , New Array);
	
EndProcedure
