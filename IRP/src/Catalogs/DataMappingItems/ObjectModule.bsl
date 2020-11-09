
Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;

	If Not IsFolder And Parent.IsEmpty() Then
		Raise R().Error_087;
	EndIf;
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
