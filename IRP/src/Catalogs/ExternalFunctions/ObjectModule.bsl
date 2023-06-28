// @strict-types

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	If Not IsFolder Then
		CommonFunctionsServer.CreateScheduledJob(Ref);
	EndIf;
EndProcedure
