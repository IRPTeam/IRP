
#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
EndProcedure

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

#Region FormCommandsEventHandlers

&AtClient
Procedure LoadSettings(Command)
	Settings = HardwareClient.GetDefaultSettings(Object.EquipmentType);
	
	For Each Param In Settings Do
		Row = Object.ConnectParameters.Add();
		Row.Name = Param.Key;
		Row.Value = Param.Value;
	EndDo;	
EndProcedure

&AtClient
Procedure Test(Command)
	ClearMessages();

	ReadOnly = True;
	CommandBar.Enabled = False;
	
	InParameters  = Undefined;
	DeviceParameters = New Structure;
	
	For Each Row In Object.ConnectParameters Do
		DeviceParameters.Insert("P_" + Row.Name, Row.Value);
	EndDo;
	
	Notify = New NotifyDescription("EndTestDevice", ThisObject);
	HardwareClient.BeginStartAdditionalComand(Notify, "CheckHealth", InParameters, Object.Ref, DeviceParameters);
EndProcedure

#EndRegion

#Region Internal

&AtClient
Procedure EndTestDevice(ResultData, Parameters) Export	
	ReadOnly = Ложь;
	CommandBar.Enabled = Истина;
	OutParameters = ResultData.OutParameters;	
	If TypeOf(OutParameters) = Type("Array") Then		
		If OutParameters.Count() >= 2 Then
			Status(OutParameters[1], , , PictureLib.Stop);
		EndIf;
	EndIf;	
EndProcedure

#EndRegion