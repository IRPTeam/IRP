&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure SetSettings(Command)
	CurrentRow = Items.ExternalDataProces.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	Info = AddDataProcServer.AddDataProcInfo(CurrentRow.ExternalDataProc);
	Info.Insert("Settings", ThisObject.AddressResult);
	Info.Insert("ExternalDataProcRef", CurrentRow.ExternalDataProc);
	Info.Insert("Country", CurrentRow.Country);
	CallMetodAddDataProc(Info);
	
	NotifyDescription = New NotifyDescription("OpenFormAddDataProcEnd", ThisObject);
	AddDataProcClient.OpenFormAddDataProc(Info, NotifyDescription, "Settings");
EndProcedure

&AtServerNoContext
Procedure CallMetodAddDataProc(Info)
	AddDataProcServer.CallMetodAddDataProc(Info);
EndProcedure

&AtClient
Procedure OpenFormAddDataProcEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	Modified = True;
	OpenFormAddDataProcEndServer(Result);
EndProcedure

&AtServer
Procedure OpenFormAddDataProcEndServer(Result)
	Obj = FormAttributeToValue("Object");
	Obj.ExternalDataProces[ThisObject.RowNumber - 1].Settings =
		New ValueStorage(Result, New Deflation(9));
	Obj.Write();
	PutToTempStorage(Result, ThisObject.AddressResult);
	ValueToFormAttribute(Obj, "Object");
EndProcedure

&AtClient
Procedure ExternalDataProcesOnActivateRow(Item)
	CurrentRow = Items.ExternalDataProces.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	PutSettingsToTempStorage(CurrentRow.LineNumber);
EndProcedure

&AtServer
Procedure PutSettingsToTempStorage(LineNumber)
	Obj = FormAttributeToValue("Object");
	Settings = Obj.ExternalDataProces[LineNumber - 1].Settings;
	ThisObject.AddressResult = PutToTempStorage(Settings.Get(), ThisObject.UUID);
	ThisObject.RowNumber = LineNumber;
EndProcedure

