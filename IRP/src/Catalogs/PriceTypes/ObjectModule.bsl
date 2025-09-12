Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
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

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If ThisObject.IsFolder Then
		Return;
	EndIf;
	
	NotCheckedAttributes = Catalogs.PriceTypes.GetNotCheckedAttributes(Ref);
	For Each Attribut In NotCheckedAttributes Do
		AttributIndex = CheckedAttributes.Find(Attribut);
		If Not AttributIndex = Undefined Then
			CheckedAttributes.Delete(AttributIndex);
		EndIf;
	EndDo;
EndProcedure
