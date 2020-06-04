
Procedure GeneratedFormCommandActionByName(Object, Form, CommandName, AddInfo = Undefined) Export	
	ExtProc = ExternalCommandsServer.GetRefOfExternalDataProcByName(CommandName);	
	Info = AddDataProcServer.AddDataProcInfo(ExtProc);	
	CallMetodAddDataProc(Info);	
	ReceivedForm = AddDataProcClient.GetFormAddDataProc(Info, Form);
	ReceivedForm.CommandProcedure(Object, Form);	
EndProcedure

Procedure GeneratedListChoiceFormCommandActionByName(SelectedRows, Form, CommandName, AddInfo = Undefined) Export	
	ExtProc = ExternalCommandsServer.GetRefOfExternalDataProcByName(CommandName);	
	Info = AddDataProcServer.AddDataProcInfo(ExtProc);	
	CallMetodAddDataProc(Info);	
	ReceivedForm = AddDataProcClient.GetFormAddDataProc(Info, Form);
	ReceivedForm.CommandProcedure(SelectedRows, Form);	
EndProcedure

Procedure CallMetodAddDataProc(Info)
	AddDataProcServer.CallMetodAddDataProc(Info);
EndProcedure