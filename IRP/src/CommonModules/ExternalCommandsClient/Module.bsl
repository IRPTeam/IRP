
Procedure GeneratedFormCommandActionByName(Object, Form, CommandName, AddInfo = Undefined) Export	
	ExtProc = ExternalCommandsServer.GetRefOfExternalDataProcByName(CommandName);	
	Info = AddDataProcServer.AddDataProcInfo(ExtProc);	
	CallMethodAddDataProc(Info);	
	ReceivedForm = AddDataProcClient.GetFormAddDataProc(Info, Form);
	ReceivedForm.CommandProcedure(Object, Form);	
EndProcedure

Procedure GeneratedListChoiceFormCommandActionByName(SelectedRows, Form, CommandName, AddInfo = Undefined) Export	
	ExtProc = ExternalCommandsServer.GetRefOfExternalDataProcByName(CommandName);	
	Info = AddDataProcServer.AddDataProcInfo(ExtProc);	
	CallMethodAddDataProc(Info);	
	ReceivedForm = AddDataProcClient.GetFormAddDataProc(Info, Form);
	ReceivedForm.CommandProcedure(SelectedRows, Form);	
EndProcedure

Procedure CallMethodAddDataProc(Info)
	AddDataProcServer.CallMethodAddDataProc(Info);
EndProcedure