Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;

	ThisObject.FullDescription = StrReplace(ThisObject.FullDescr(), "/", ", ");
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