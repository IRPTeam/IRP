
Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	RefreshReusableValues();
EndProcedure
