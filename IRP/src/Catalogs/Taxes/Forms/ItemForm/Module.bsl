&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	ThisObject.AddressResult
	= PutToTempStorage(FormAttributeToValue("Object").ExternalDataProcSettings.Get(), ThisObject.UUID);
	SetVisible();
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

&AtServer
Procedure SetVisible()
	UseTaxRate = Object.Type = Enums.TaxType.Rate;
	Items.TaxRates.Visible = UseTaxRate;
	Items.GroupTaxRates.Visible = UseTaxRate;
	Items.ExternalDataProc.Visible = UseTaxRate;
	Items.ExternalDataProcSettings.Visible = UseTaxRate;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	If Object.Type <> Enums.TaxType.Rate Then
		Object.TaxRates.Clear();
	EndIf;
EndProcedure

&AtClient
Procedure TypeOnChange(Item)
	SetVisible();
EndProcedure

