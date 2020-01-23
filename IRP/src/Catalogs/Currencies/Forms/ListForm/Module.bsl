&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	FillingFromClassifiers.OnCreateAtServer(ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtClient
Procedure Integrations(Command)
	NotifyDescription = New NotifyDescription("SelectIntegrationEnd", ThisObject);
	OpenForm("Catalog.Currencies.Form.SelectIntegration", , ThisObject, , , , NotifyDescription);
EndProcedure

&AtClient
Procedure SelectIntegrationEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	ExternalDataProc = ServiceSystemServer.GetObjectAttribute(Result.IntegrationSettings, "ExternalDataProc");
	Info = AddDataProcServer.AddDataProcInfo(ExternalDataProc);
	Info.Insert("Settings", PutSettingsToTempStorage(Result.IntegrationSettings));
	Info.Insert("IntegrationSettingsRef", Result.IntegrationSettings);
	Info.Insert("IntegrationSettingsName",
		ServiceSystemServer.GetObjectAttribute(Result.IntegrationSettings, "UniqueID"));
	
	CallMetodAddDataProc(Info);
	
	AddDataProcClient.OpenFormAddDataProc(Info);
EndProcedure

&AtServer
Function PutSettingsToTempStorage(IntegrationSettings)
	Return PutToTempStorage(IntegrationSettings.ExternalDataProcSettings.Get(), ThisObject.UUID);
EndFunction

&AtServerNoContext
Procedure CallMetodAddDataProc(Info)
	AddDataProcServer.CallMetodAddDataProc(Info);
EndProcedure

&AtClient
Procedure CreateFromClassifier(Command)
	FormParameters = New Structure("MetadataName", "Catalog.Currencies");
	OpenForm("CommonForm.DataClassifier", 
				FormParameters, 
				ThisObject, , , , ,
				FormWindowOpeningMode.LockOwnerWindow);
EndProcedure
