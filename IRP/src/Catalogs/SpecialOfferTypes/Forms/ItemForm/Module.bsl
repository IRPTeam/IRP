&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	Obj = FormAttributeToValue("Object");
	AddressResult = PutToTempStorage(Obj.Settings.Get(), ThisObject.UUID);
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure SetSettings(Command)
	Info = AddDataProcServer.AddDataProcInfo(Object.Ref);
	Info.Insert("Settings", AddressResult);
	CallMetodAddDataProc(Info);
	
	NotifyDescription = New NotifyDescription("OpenFormAddDataProcEnd", ThisObject);
	AddDataProcClient.OpenFormAddDataProc(Info, 
	                                      NotifyDescription, 
	                                      ?(Object.GroupTypes, "GroupTypeForm", "ElementTypeForm"));
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
	PutToTempStorage(Result, AddressResult);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	CurrentObject.Settings = New ValueStorage(GetFromTempStorage(AddressResult), New Deflation(9));
	EndProcedure
	
