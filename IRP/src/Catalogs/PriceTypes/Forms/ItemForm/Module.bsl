&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	PutSettingsToTempStorage();
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#Region ExternalDataProc

&AtClient
Procedure ExternalDataProcSettings(Command)
	Info = AddDataProcServer.AddDataProcInfo(Object.ExternalDataProc);
	Info.Insert("Settings", ThisObject.AddressResult);
	CallMetodAddDataProc(Info);
	
	NotifyDescription = New NotifyDescription("OpenFormProcSettingsEnd", ThisObject);
	AddDataProcClient.OpenFormAddDataProc(Info, NotifyDescription, "Settings");
EndProcedure

&AtServer
Procedure PutSettingsToTempStorage()
	ThisObject.AddressResult = PutToTempStorage(FormAttributeToValue("Object").ExternalDataProcSettings.Get()
			, ThisObject.UUID);
EndProcedure

&AtClient
Procedure ExternalDataProcOnChange(Item)
	PutSettingsToTempStorage();
EndProcedure


&AtServerNoContext
Procedure CallMetodAddDataProc(Info)
	AddDataProcServer.CallMetodAddDataProc(Info);
EndProcedure

&AtClient
Procedure OpenFormProcSettingsEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	Modified = True;
	OpenFormProcSettingsEndServer(Result);
EndProcedure

&AtServer
Procedure OpenFormProcSettingsEndServer(Result)
	Obj = FormAttributeToValue("Object");
	Obj.ExternalDataProcSettings = New ValueStorage(Result, New Deflation(9));
	Obj.Write();
	PutToTempStorage(Result, ThisObject.AddressResult);
	ValueToFormAttribute(Obj, "Object");
EndProcedure

#EndRegion