Procedure OnStart()
	isMobile = False;
	#If MobileAppClient OR MobileClient OR MobileAppServer Then
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
	
	If Not Saas.isAreaActive() 
	   And (Saas.isAreaActive() And Not Saas.CurrentAreaID() = 0) Then

		If Not ServiceSystemServer.GetConstantValue("NotFirstStart") Then
			FillingFromClassifiers.FillDescriptionOfPredefinedCatalogs();
			LocalizationClient.OpenFirstStartSettingsForm();
			ServiceSystemServer.SetConstantValue("NotFirstStart", True);
		EndIf;

	EndIf;

EndProcedure


Procedure BeforeStart(Cancel)
	AreaStatus = SaasClient.CurrentAreaStatus();
	If AreaStatus.isError Then
		Cancel = True;
		Raise AreaStatus.Status;
	EndIf;
EndProcedure

