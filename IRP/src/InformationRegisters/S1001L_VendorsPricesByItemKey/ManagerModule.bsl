#Region AccessObject

// Get access key.
// See Role.TemplateInformationRegisters
// 
// Returns:
//  Structure - Get access key:
// * PriceType - CatalogRef.PriceTypes -
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	AccessKeyStructure.Insert("PriceType", Catalogs.PriceTypes.EmptyRef());
	Return AccessKeyStructure;
EndFunction

#EndRegion

// Fill vendor prices.
// 
// Parameters:
//  Object - FormDataStructure
Procedure FillVendorPricesInObject(Object) Export
		
	Query = New Query;
	Query.Text =
		"SELECT ALLOWED
		|	S1001L_VendorsPricesByItemKeySliceLast.Price AS LastVendorPrice,
		|	S1001L_VendorsPricesByItemKeySliceLast.ItemKey,
		|	S1001L_VendorsPricesByItemKeySliceLast.Currency AS LastVendorPriceCurrency
		|FROM
		|	InformationRegister.S1001L_VendorsPricesByItemKey.SliceLast(&Period, Partner = &Partner
		|	AND ItemKey IN (&ItemKeys)
		|	AND Currency = &Currency) AS S1001L_VendorsPricesByItemKeySliceLast";
	
	Query.SetParameter("Period", CurrentSessionDate());
	Query.SetParameter("Currency", Object.Currency);
	Query.SetParameter("Partner", Object.Partner);
	Query.SetParameter("ItemKeys", Object.ItemList.Unload().UnloadColumn("ItemKey"));
	
	TablePrices = Query.Execute().Unload(); // ValueTable
	TablePrices.Indexes.Add("ItemKey");
	
	For Each Row In Object.ItemList Do
		SearchRow = TablePrices.Find(Row.ItemKey, "ItemKey");
		If SearchRow <> Undefined Then
			FillPropertyValues(Row, SearchRow, "LastVendorPrice, LastVendorPriceCurrency");
		EndIf;	
	EndDo;
EndProcedure