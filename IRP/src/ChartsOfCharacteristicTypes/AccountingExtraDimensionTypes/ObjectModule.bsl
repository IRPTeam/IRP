
Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	If Not ValueIsFilled(ThisObject.UniqueID) Then
		ThisObject.UniqueID = "_" + String(New UUID());
	EndIf;
EndProcedure

Procedure OnCopy(CopiedObject)
	ThisObject.UniqueID = Undefined;
EndProcedure
