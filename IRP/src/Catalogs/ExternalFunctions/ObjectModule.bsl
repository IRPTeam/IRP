// @strict-types

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	CommonFunctionsServer.CreateScheduledJob(Ref);
EndProcedure
