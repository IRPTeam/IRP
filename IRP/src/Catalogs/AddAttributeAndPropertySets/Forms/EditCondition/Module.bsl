&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Ref = Parameters.Ref;
	
	DCSTemplate = AddAttributesAndPropertiesServer.GetDCSTemplate(ThisObject.Ref.PredefinedDataName);
	Address = PutToTempStorage(DCSTemplate);
	ThisObject.SettingsComposer.Initialize(New DataCompositionAvailableSettingsSource(Address));
	
	If Parameters.SavedSettings = Undefined Then
		ThisObject.SettingsComposer.LoadSettings(DCSTemplate.DefaultSettings);
	Else
		ThisObject.SettingsComposer.LoadSettings(Parameters.SavedSettings);
	EndIf;
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

&AtClient
Procedure Ok(Command)
	Close(PrepareResult());
EndProcedure

&AtServer
Function PrepareResult()
	Settings = ThisObject.SettingsComposer.GetSettings();
	
	Result = New Structure();
	Result.Insert("Settings", Settings);
	Return Result;
EndFunction

&AtClient
Procedure Verify(Command)
	VerifyAtServer();
EndProcedure

&AtServer
Procedure VerifyAtServer()
	DCSTemplate = AddAttributesAndPropertiesServer.GetDCSTemplate(ThisObject.Ref.PredefinedDataName);
	Settings = ThisObject.SettingsComposer.GetSettings();
	Result = AddAttributesAndPropertiesServer.GetRefsByCondition(DCSTemplate, Settings,  New ValueTable());
	ThisObject.ResultTable.Load(Result);
EndProcedure