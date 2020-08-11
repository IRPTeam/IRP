
Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;	
	
	ObjectStatusesServer.WriteStatusToRegister(Ref, Ref.Status, CurrentUniversalDate());
EndProcedure

Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;	
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure
