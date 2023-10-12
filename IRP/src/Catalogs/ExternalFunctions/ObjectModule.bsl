// @strict-types

Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;

	If Not IsFolder And DeletionMark Then
		Enable = False;
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	If Not IsFolder Then
		CommonFunctionsServer.CreateScheduledJob(Ref);
	EndIf;
EndProcedure
