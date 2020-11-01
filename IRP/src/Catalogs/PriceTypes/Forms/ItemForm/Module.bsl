
#Region FormEvents

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	PutSettingsToTempStorage();
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
EndProcedure

#EndRegion

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#Region ExternalDataProc

&AtClient
Procedure ExternalDataProcSettings(Command)
	Info = AddDataProcServer.AddDataProcInfo(Object.ExternalDataProc);
	Info.Insert("Settings", ThisObject.AddressResult);
	CallMethodAddDataProc(Info);
	
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
Procedure CallMethodAddDataProc(Info)
	AddDataProcServer.CallMethodAddDataProc(Info);
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

#Region AddAttributes
&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

#EndRegion