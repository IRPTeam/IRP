Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;

	If ValueIsFilled(ThisObject.Item) And ValueIsFilled(ThisObject.Item.ItemType) Then
		ThisObject.AffectPricingMD5
		= AddAttributesAndPropertiesServer.GetAffectPricingMD5(ThisObject.Item, ThisObject.Item.ItemType,
			ThisObject.AddAttributes.Unload());
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