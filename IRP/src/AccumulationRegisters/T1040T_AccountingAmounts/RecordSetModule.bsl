
Procedure BeforeWrite(Cancel, Replacing)
	If Not FOServer.IsUseAccounting() Then
		ThisObject.Clear();
	EndIf;
EndProcedure
