Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	isPreviewSet = ValueIsFilled(Preview.Get());
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