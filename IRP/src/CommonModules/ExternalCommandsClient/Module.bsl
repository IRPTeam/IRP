Procedure GeneratedFormCommandActionByName(Object, Form, CommandName, AddInfo = Undefined) Export
	ExtProc = ExternalCommandsServer.GetRefOfExternalDataProcByName(CommandName);
	Info = AddDataProcServer.AddDataProcInfo(ExtProc);
	CallMethodAddDataProc(Info);
	If Info.Property("OpenForm") And Info.OpenForm Then
		AddDataProcClient.OpenFormAddDataProc(Info, Form);
	Else
		ReceivedForm = AddDataProcClient.GetFormAddDataProc(Info, Form);
		ReceivedForm.CommandProcedure(Object, Form);
	EndIf;
EndProcedure

Procedure GeneratedListChoiceFormCommandActionByName(SelectedRows, Form, CommandName, AddInfo = Undefined) Export
	ExtProc = ExternalCommandsServer.GetRefOfExternalDataProcByName(CommandName);
	Info = AddDataProcServer.AddDataProcInfo(ExtProc);
	CallMethodAddDataProc(Info);
	If Info.Property("OpenForm") And Info.OpenForm Then
		AddDataProcClient.OpenFormAddDataProc(Info, Form);
	Else
		ReceivedForm = AddDataProcClient.GetFormAddDataProc(Info, Form);
		ReceivedForm.CommandProcedure(SelectedRows, Form);
	EndIf;
EndProcedure

Procedure CallMethodAddDataProc(Info)
	AddDataProcServer.CallMethodAddDataProc(Info);
EndProcedure