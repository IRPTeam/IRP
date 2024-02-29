
Procedure BeforeWrite(Cancel, Replacing)
	If Not PrivilegedMode() Then
		Cancel = True;
	EndIf;
EndProcedure
