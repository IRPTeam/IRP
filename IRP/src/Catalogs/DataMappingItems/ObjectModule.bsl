
Procedure BeforeWrite(Cancel)
	If Not IsFolder And Parent.IsEmpty() Then
		Raise R().Error_087;
	EndIf;
EndProcedure
