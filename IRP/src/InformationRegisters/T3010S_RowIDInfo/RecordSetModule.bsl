
Procedure BeforeWrite(Cancel, Replacing)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	For Each Record In ThisObject Do
		If IsBlankString(Record.UniqueID) Then
			Record.UniqueID = String(New UUID());
		EndIf;
	EndDo;
EndProcedure
