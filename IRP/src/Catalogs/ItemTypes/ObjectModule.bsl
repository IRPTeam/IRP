Procedure OnWrite(Cancel)
	Catalogs.AddAttributeAndPropertySets.SinhronizeItemKeysAttributes();
	Catalogs.AddAttributeAndPropertySets.SinhronizePriceKeysAttributes();
	
	Catalogs.ItemKeys.SynhronizeAffectPricingMD5ByItemType(ThisObject.Ref);
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If Not ThisObject.IsFolder Then
		ThisObject.Type = Enums.ItemTypes.Product;
	EndIf;
EndProcedure

