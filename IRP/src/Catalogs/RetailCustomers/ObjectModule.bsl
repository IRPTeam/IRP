
Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	Description = Name + " " + Surname;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;	
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure
