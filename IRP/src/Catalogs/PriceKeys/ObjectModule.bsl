Procedure BeforeWrite(Cancel)
	If ValueIsFilled(ThisObject.Item) And ValueIsFilled(ThisObject.Item.ItemType) Then
		ThisObject.AffectPricingMD5
		= AddAttributesAndPropertiesServer.GetAffectPricingMD5(ThisObject.Item
				, ThisObject.Item.ItemType
				, ThisObject.AddAttributes.Unload());
	EndIf;
EndProcedure

