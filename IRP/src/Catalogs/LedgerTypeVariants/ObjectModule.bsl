
Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	If Not ValueIsFilled(ThisObject.UniqueID) Then
		ThisObject.UniqueID = "_" + String(New UUID());
	EndIf;
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

Procedure OnCopy(CopiedObject)
	ThisObject.UniqueID = Undefined;
EndProcedure
