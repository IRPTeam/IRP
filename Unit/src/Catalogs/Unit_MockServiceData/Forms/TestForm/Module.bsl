// @strict-types



&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	MockData = Parameters.MockData;

EndProcedure



&AtClient
Procedure RunTest(Command)
	RunTestAtServer();
EndProcedure

&AtServer
Procedure RunTestAtServer()
	//TODO: Insert the handler content
EndProcedure

