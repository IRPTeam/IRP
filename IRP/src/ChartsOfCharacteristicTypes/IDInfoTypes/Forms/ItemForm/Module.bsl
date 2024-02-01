&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);
	ChartsOfCharacteristicTypesServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	ChartsOfCharacteristicTypesServer.OnReadAtServer(Object, ThisObject, CurrentObject);
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	ChartsOfCharacteristicTypesServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure SetSettings(Command)
	CurrentRow = Items.ExternalDataProcess.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;

	Info = AddDataProcServer.AddDataProcInfo(CurrentRow.ExternalDataProc);
	Info.Insert("Settings", ThisObject.AddressResult);
	Info.Insert("ExternalDataProcRef", CurrentRow.ExternalDataProc);
	Info.Insert("Country", CurrentRow.Country);
	CallMethodAddDataProc(Info);

	NotifyDescription = New NotifyDescription("OpenFormAddDataProcEnd", ThisObject);
	AddDataProcClient.OpenFormAddDataProc(Info, NotifyDescription, "Settings");
EndProcedure

&AtServerNoContext
Procedure CallMethodAddDataProc(Info)
	AddDataProcServer.CallMethodAddDataProc(Info);
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
	Obj.ExternalDataProcess[ThisObject.RowNumber - 1].Settings = New ValueStorage(Result, New Deflation(9));
	Obj.Write();
	PutToTempStorage(Result, ThisObject.AddressResult);
	ValueToFormAttribute(Obj, "Object");
EndProcedure

&AtClient
Procedure ExternalDataProcessorOnActivateRow(Item)
	CurrentRow = Items.ExternalDataProcess.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	//@skip-check unknown-method-property
	PutSettingsToTempStorage(CurrentRow.LineNumber);
EndProcedure

&AtServer
Procedure PutSettingsToTempStorage(LineNumber)
	Obj = FormAttributeToValue("Object");
	Settings = Obj.ExternalDataProcess[LineNumber - 1].Settings;
	ThisObject.AddressResult = PutToTempStorage(Settings.Get(), ThisObject.UUID);
	ThisObject.RowNumber = LineNumber;
EndProcedure