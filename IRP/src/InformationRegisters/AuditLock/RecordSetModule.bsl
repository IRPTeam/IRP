
Procedure BeforeWrite(Cancel, Replacing)
	If Not PrivilegedMode() Then
		Cancel = True;
	EndIf;
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure
