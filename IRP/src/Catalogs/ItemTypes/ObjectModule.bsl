Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	EmptyValues = New Array;
	For Each Row In AvailableAttributes Do
		If Not ValueIsFilled(Row.Attribute) Then
			EmptyValues.Add(Row);
		EndIf;
	EndDo;
	For Each Row In EmptyValues Do
		AvailableAttributes.Delete(Row);
	EndDo;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;

	Catalogs.AddAttributeAndPropertySets.SynchronizeItemKeysAttributes();
	Catalogs.AddAttributeAndPropertySets.SynchronizePriceKeysAttributes();

	Catalogs.ItemKeys.SynchronizeAffectPricingMD5ByItemType(ThisObject.Ref);
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If Not ThisObject.IsFolder Then
		ThisObject.Type = Enums.ItemTypes.Product;
		ThisObject.StockBalanceDetail = Enums.StockBalanceDetail.ByItemKey;
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	TableOfAttributes = ThisObject.AvailableAttributes.Unload();
	TableOfAttributes.Columns.Add("Counter");
	TableOfAttributes.FillValues(1, "Counter");
	TableOfAttributes.GroupBy("Attribute", "Counter");

	For Each Row In TableOfAttributes Do
		If Row.Counter <= 1 Then
			Continue;
		EndIf;

		Filter = New Structure("Attribute", Row.Attribute);
		FoundedRows = ThisObject.AvailableAttributes.FindRows(Filter);
		If FoundedRows.Count() Then
			LineNumber = FoundedRows[0].LineNumber;

			CommonFunctionsClientServer.ShowUsersMessage(R().Error_033 + ": " + String(Row.Attribute),
				"AvailableAttributes[" + (LineNumber - 1) + "].Attribute", ThisObject);
			Cancel = True;
		EndIf;
	EndDo;
	CheckDataPrivileged.FillCheckProcessing_Catalog_ItemTypes(Cancel, ThisObject);
EndProcedure