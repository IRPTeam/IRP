
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	For Each ObjectRef In Parameters.ObjectArray Do
		ObjectTable.Add().Ref = ObjectRef; 
	EndDo;
	CodeText = "Message(ObjectRef);";
EndProcedure

&AtClient
Procedure RunCode(Command)
	RunCodeAtServer();
EndProcedure

&AtServer
Procedure RunCodeAtServer()
	SetSafeMode(True);
	For Each ObjectRow In ObjectTable Do
		//@skip-check module-unused-local-variable
		ObjectRef = ObjectRow.Ref;
		Execute(CodeText);
	EndDo;	
	SetSafeMode(False);
EndProcedure
