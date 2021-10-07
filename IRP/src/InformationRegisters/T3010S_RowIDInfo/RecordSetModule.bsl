
Procedure BeforeWrite(Cancel, Replacing)
	For Each Record In ThisObject Do
		Record.UniqueID = String(New UUID());
	EndDo;
EndProcedure
