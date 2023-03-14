#Region FormEvents

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	If Object.Type <> Enums.TaxType.Rate Then
		Object.TaxRates.Clear();
	EndIf;
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
	ProcSettings = FormAttributeToValue("Object").ExternalDataProcSettings.Get();
	ThisObject.AddressResult = PutToTempStorage(ProcSettings, ThisObject.UUID);
	SetVisible();
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref, Items.GroupMainPages);
EndProcedure

&AtClient
Procedure UseDocumentsDocumentNameStartChoice(Item, ChoiceData, StandardProcessing)
	Items.UseDocumentsDocumentName.ChoiceList.Clear();
	DocumentNameChoiceList = TaxesServer.GetDocumentsWithTax();
	For Each DocumentName In DocumentNameChoiceList Do
		If Object.UseDocuments.FindRows(New Structure("DocumentName", DocumentName.Value)).Count() Then
			Continue;
		EndIf;
		Items.UseDocumentsDocumentName.ChoiceList.Add(DocumentName.Value, DocumentName.Presentation);
	EndDo;
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

&AtServer
Procedure SetVisible()
	UseTaxRate = Object.Type = Enums.TaxType.Rate;
	Items.TaxRates.Visible = UseTaxRate;
	Items.GroupTaxRates.Visible = UseTaxRate;
	Items.ExternalDataProc.Visible = UseTaxRate;
	Items.ExternalDataProcSettings.Visible = UseTaxRate;
EndProcedure

&AtClient
Procedure TypeOnChange(Item)
	SetVisible();
EndProcedure

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