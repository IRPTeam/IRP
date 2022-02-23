
Procedure BeforeWrite(Cancel, Replacing)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	For Each Record In ThisObject Do
		Record.UniqueID = String(New UUID());
	EndDo;
EndProcedure
