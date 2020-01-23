Procedure BeforeWrite(Cancel)
	If ThisObject.IsNew() Then
		ThisObject.UID = New UUID();
	EndIf;
EndProcedure

