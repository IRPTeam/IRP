
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	For Each FunctionalOption In Metadata.FunctionalOptions Do
		NameParts = StrSplit(FunctionalOption.Name, "_");
		If StrStartsWith(NameParts[NameParts.UBound()], "Use") Then
			NewRow = ThisObject.FunctionalOptions.Add();
			NewRow.OptionName = FunctionalOption.Name;
			NewRow.OptionPresentation = FunctionalOption.Synonym;
			NewRow.Use = Constants[FunctionalOption.Name].Get();
		EndIf;
	EndDO;
EndProcedure

&AtClient
Procedure Save(Command)
	SaveAtServer();
	RefreshInterface();
EndProcedure

&AtServer
Procedure SaveAtServer()
	For Each FunctionalOption In ThisObject.FunctionalOptions Do
		Constants[FunctionalOption.OptionName].Set(FunctionalOption.Use);
	EndDo;
EndProcedure	

&AtClient
Procedure UpdateAllUserSettings(Command)
	UpdateAllUserSettingsAtServer();
EndProcedure

&AtServerNoContext
Procedure UpdateAllUserSettingsAtServer()
	UserSettingsServer.SetDefaultUserSettings();
EndProcedure

&AtClient
Procedure FunctionalOptionsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure FunctionalOptionsBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure

&AtClient
Procedure CheckAll(Command)
	ChangeChecked(True);
EndProcedure

&AtClient
Procedure UncheckAll(Command)
	ChangeChecked(False);
EndProcedure

&AtClient
Procedure ChangeChecked(Value)
	For Each Row In ThisObject.FunctionalOptions Do
		Row.Use = Value;
	EndDo;
EndProcedure

&AtClient
Procedure UpdateDefaults(Command)
	UpdateDefaultsAtServer();
EndProcedure

&AtServerNoContext
Procedure UpdateDefaultsAtServer()
	FOServer.UpdateDefaults();	
EndProcedure
