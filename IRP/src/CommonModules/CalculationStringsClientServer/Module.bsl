Function GetCalculationSettings(Actions = Undefined, AddInfo = Undefined) Export
	If Actions = Undefined Then
		Actions = New Structure;
	EndIf;
	
	Actions.Insert("CalculateSpecialOffers");
	Actions.Insert("CalculateNetAmount");
	Actions.Insert("CalculateTax");
	Actions.Insert("CalculateTotalAmount");
	Actions.Insert("UpdateInfoString");
	Return Actions;
EndFunction


// TODO: Test
Procedure ClearDependentData(Object, AddInfo = Undefined) Export
	If AddInfo = Undefined Or not AddInfo.Property("TableParent") Then
		TableName = "ItemList"
	Else
		TableName = AddInfo.TableParent;
	EndIf;
	
	If ServiceSystemClientServer.ObjectHasAttribute("TaxList", Object) Then
		ArrayForDelete = New Array();
		
		For Each Row In Object.TaxList Do
			If Object[TableName].FindRows(New Structure("Key", Row.Key)).Count() Then
				Continue;
			EndIf;
			ArrayForDelete.Add(Row);
		EndDo;
		For Each Row In ArrayForDelete Do
			Object.TaxList.Delete(Row);
		EndDo;
	EndIf;
	
	If ServiceSystemClientServer.ObjectHasAttribute("SpecialOffers", Object) Then
		ArrayForDelete = New Array();
		For Each Row In Object.SpecialOffers Do
			If ValueIsFilled(Row.Offer)
				And CalculationServer.OfferHaveManualInputValue(Row.Offer)
				And Object[TableName].FindRows(New Structure("Key", Row.Key)).Count() Then
				Continue;
			EndIf;
			ArrayForDelete.Add(Row);
		EndDo;
		For Each Row In ArrayForDelete Do
			Object.SpecialOffers.Delete(Row);
		EndDo;
	EndIf;
EndProcedure

Procedure CalculateItemsRows(Object, Form, ItemRows, Actions, ArrayOfTaxInfo = Undefined, AddInfo = Undefined) Export
	If Not Actions.Count() Then
		Return;
	EndIf;
			
	For Each ItemRow In ItemRows Do
		CalculateItemsRow(Object, ItemRow, Actions, ArrayOfTaxInfo, AddInfo);
	EndDo;
	
	#If ThinClient Then
		
	For Each Action In Actions Do
		
		NotifyStructure = New Structure();
		NotifyStructure.Insert("Object"			, Object);
		NotifyStructure.Insert("ItemRow"		, ItemRow);
		NotifyStructure.Insert("Actions"		, Actions);
		NotifyStructure.Insert("ArrayOfTaxInfo"	, ArrayOfTaxInfo);
		NotifyStructure.Insert("AddInfo"		, AddInfo);		
		Notify(Action.Key, NotifyStructure, Form);
	EndDo;
	Notify("CallbackHandler", Undefined, Form);
	#EndIf
EndProcedure


Procedure CalculateItemsRow(Object, ItemRow, Actions, ArrayOfTaxInfo = Undefined, AddInfo = Undefined) Export
	
	If Actions.Property("UpdateUnit") Then
		UpdateUnit(Object, ItemRow, AddInfo);
	EndIf;
	
	If Actions.Property("UpdateRowUnit") Then
		UpdateRowUnit(Object, ItemRow, AddInfo);
	EndIf;
	
	If Actions.Property("ChangePriceType") Then
		ChangePriceType(Object, ItemRow, Actions.ChangePriceType, AddInfo);
	EndIf;
	
	If Actions.Property("UpdatePrice") Then
		UpdatePrice(Object, ItemRow, Actions.UpdatePrice, AddInfo);
	EndIf;
	
	If Actions.Property("RecalculateAppliedOffers") Then
		RecalculateAppliedOffers(Object, ItemRow, AddInfo);
	EndIf;
	
	If Actions.Property("CalculateSpecialOffers") Then
		CalculateSpecialOffers(Object, ItemRow, AddInfo);
	EndIf;
	
	CheckingStructure = New Structure("PriceIncludeTax", Undefined);
	FillPropertyValues(CheckingStructure, Object);
	
	If CheckingStructure.PriceIncludeTax <> Undefined Then
		If Object.PriceIncludeTax Then
			If Actions.Property("CalculateTotalAmount") Then
				CalculateTotalAmount_PriceIncludeTax(Object, ItemRow, AddInfo);
			EndIf;
			
			If Actions.Property("CalculateTax") Then
				CalculateTax_PriceIncludeTax(Object, ItemRow, ArrayOfTaxInfo, AddInfo);
			EndIf;
			
			If Actions.Property("CalculateNetAmount") Then
				CalculateNetAmount_PriceIncludeTax(Object, ItemRow, AddInfo);
			EndIf;
		Else
			If Actions.Property("CalculateNetAmount") Then
				CalculateNetAmount_PriceNotIncludeTax(Object, ItemRow, AddInfo);
			EndIf;
			
			If Actions.Property("CalculateTax") Then
				CalculateTax_PriceNotIncludeTax(Object, ItemRow, ArrayOfTaxInfo, AddInfo);
			EndIf;
			
			If Actions.Property("CalculateTotalAmount") Then
				CalculateTotalAmount_PriceNotIncludeTax(Object, ItemRow, AddInfo);
			EndIf;
		EndIf;
	Else
		If Actions.Property("CalculateTax") Then
			CalculateTaxManualPriority(Object, ItemRow, False, ArrayOfTaxInfo, False, AddInfo);
		EndIf;
		
		If Actions.Property("CalculateTotalAmount") Then
			CalculateTotalAmount_PriceNotIncludeTax(Object, ItemRow, AddInfo);
		EndIf;
		
		If Actions.Property("CalculateTaxByNetAmount") Then
			CalculateTaxManualPriority(Object, ItemRow, False, ArrayOfTaxInfo, False, AddInfo);
		EndIf;
		
		If Actions.Property("CalculateTaxByTotalAmount") Then
			CalculateTaxManualPriority(Object, ItemRow, True, ArrayOfTaxInfo, False, AddInfo);
		EndIf;
		
		If Actions.Property("CalculateNetAmountByTotalAmount") Then
			CalculateNetAmount_PriceIncludeTax(Object, ItemRow, AddInfo);
		EndIf;
		
		If Actions.Property("CalculateTotalAmountByNetAmount") Then
			CalculateTotalAmount_PriceNotIncludeTax(Object, ItemRow, AddInfo);
		EndIf;
	EndIf;
	If Actions.Property("UpdateInfoString") Then
		UpdateInfoString(ItemRow);
	EndIf;
	
	If Actions.Property("UpdateInfoStringWithOffers") Then
		UpdateInfoStringWithOffers(Object, ItemRow, AddInfo);
	EndIf;
	
	If Actions.Property("UpdateBarcode") Then
		UpdateBarcode(Object, ItemRow, AddInfo);
	EndIf;
	
EndProcedure

Function ChangePriceType(Object, ItemRow, ChangePriceTypeSettings, AddInfo = Undefined)
	ChangePriceTypeSettings.Insert("ItemKey", ItemRow.ItemKey);
	ChangePriceTypeSettings.Insert("Unit", ItemRow.Unit);
	ChangePriceTypeSettings.Insert("Object", Object);
	
	PriceInfo = GetItemInfo.ItemPriceInfo(ChangePriceTypeSettings);
	ItemRow.Price = ?(PriceInfo = Undefined, 0, PriceInfo.Price);
	ItemRow.PriceType = ChangePriceTypeSettings.PriceType;
	Return ItemRow.Price;
EndFunction

Procedure UpdatePrice(Object, ItemRow, ChangePriceTypeSettings, AddInfo = Undefined)
	
	ChangePriceTypeSettings.Insert("ItemKey", ItemRow.ItemKey);
	
	If CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "PriceType") Then
		ChangePriceTypeSettings.Insert("RowPriceType", ItemRow.PriceType);
	Else
		ChangePriceTypeSettings.Insert("RowPriceType", ChangePriceTypeSettings.PriceType);
	EndIf;
	If ChangePriceTypeSettings.RowPriceType = PredefinedValue("Catalog.PriceTypes.ManualPriceType") Then
		Return;
	EndIf;
	
	ChangePriceTypeSettings.Insert("Unit", ItemRow.Unit);
	ChangePriceTypeSettings.Insert("Object", Object);
	
	PriceInfo = GetItemInfo.ItemPriceInfo(ChangePriceTypeSettings);
	ItemRow.Price = ?(PriceInfo = Undefined, 0, PriceInfo.Price);
	
EndProcedure

Procedure UpdateInfoStringWithOffers(Object, ItemRow, AddInfo = Undefined)
	Filter = New Structure();
	Filter.Insert("ItemKey", ItemRow.ItemKey);
	ArrayOfRows = Object.ItemList.FindRows(Filter);
	If ArrayOfRows.Count() Then
		ItemRow.Info = BuildInfoString(ArrayOfRows[0]);
	Else
		ItemRow.Info = BuildInfoString(ItemRow);
	EndIf;
EndProcedure

#Region Region
Procedure UpdateInfoString(ItemRow) Export
	ItemRow.Info = BuildInfoString(ItemRow);
EndProcedure

Function BuildInfoString(ItemRow)
	Total = CalculateAmount(ItemRow);
	
	OfferInfo = "";
	If ItemRow.OffersAmount And Total Then
		OfferInfo = " - "
			+ ItemRow.OffersAmount
			+ " (~"
			+ Round(100 * ItemRow.OffersAmount / Total)
			+ "%)";
	EndIf;
	
	Return ""
		+ ItemRow.Quantity
		+ " "
		+ ItemRow.Unit
		+ " × "
		+ ItemRow.Price
		+ OfferInfo;
EndFunction

Procedure CalculateNetAmount_PriceIncludeTax(Object, ItemRow, AddInfo = Undefined)
	If CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "OffersAmount") Then
		ItemRow.NetAmount = CalculateAmount(ItemRow) - ItemRow.TaxAmount - ItemRow.OffersAmount;
	Else
		ItemRow.NetAmount = CalculateAmount(ItemRow) - ItemRow.TaxAmount;
	EndIf;
EndProcedure

Procedure CalculateNetAmount_PriceNotIncludeTax(Object, ItemRow, AddInfo = Undefined)
	If CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "OffersAmount") Then
		ItemRow.NetAmount = CalculateAmount(ItemRow) - ItemRow.OffersAmount;
	Else
		ItemRow.NetAmount = CalculateAmount(ItemRow);
	EndIf;
EndProcedure

Function CalculateAmount(ItemRow)
	If CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "Price") 
			And CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "Quantity") Then
		Return ItemRow.Price * ItemRow.Quantity;
	Else
		Return ItemRow.TotalAmount;
	EndIf;
EndFunction

Procedure CalculateTotalAmount_PriceIncludeTax(Object, ItemRow, AddInfo = Undefined)
	If CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "Price") 
			And CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "Quantity") 
			And CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "OffersAmount") Then
		ItemRow.TotalAmount = CalculateAmount(ItemRow) - ItemRow.OffersAmount;
	Else
		ItemRow.TotalAmount = ItemRow.NetAmount;
	EndIf;
EndProcedure
#EndRegion

Procedure CalculateTotalAmount_PriceNotIncludeTax(Object, ItemRow, AddInfo = Undefined)
	ItemRow.TotalAmount = ItemRow.NetAmount + ItemRow.TaxAmount;
EndProcedure

Procedure CalculateTax_PriceIncludeTax(Object, ItemRow, ArrayOfTaxInfo, AddInfo = Undefined)
	CalculateTax(Object, ItemRow, True, ArrayOfTaxInfo, False, AddInfo);
EndProcedure

Procedure CalculateTax_PriceNotIncludeTax(Object, ItemRow, ArrayOfTaxInfo, AddInfo = Undefined)
	CalculateTax(Object, ItemRow, False, ArrayOfTaxInfo, False, AddInfo);
EndProcedure

Procedure CalculateTaxReverse_PriceIncludeTax(Object, ItemRow, ArrayOfTaxInfo, AddInfo = Undefined) Export
	CalculateTax(Object, ItemRow, True, ArrayOfTaxInfo, True, AddInfo);
EndProcedure

Procedure CalculateTaxReverse_PriceNotIncludeTax(Object, ItemRow, ArrayOfTaxInfo, AddInfo = Undefined) Export
	CalculateTax(Object, ItemRow, False, ArrayOfTaxInfo, True, AddInfo);
EndProcedure

Procedure CalculateTax(Object, ItemRow, PriceIncludeTax, ArrayOfTaxInfo, Reverse, AddInfo = Undefined)
	
	// ArrayOfTaxInfo
	// - Name (column name)
	// - Tax
	CachedColumns = "Key, Tax, Analytics, TaxRate, Amount, ManualAmount";
	TaxListCache = DeleteRowsInDependedTable(Object, "TaxList", ItemRow.Key, CachedColumns);
	
	CheckedColumns = "Key, Tax, Analytics, TaxRate";
	ArrayOfCheckedColumns = StrSplit(CheckedColumns, ",");
	
	If ArrayOfTaxInfo = Undefined Then
		Return;
	EndIf;
	
	If CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "ItemKey") 
			And Not ValueIsFilled(ItemRow.ItemKey) Then
		Return;
	EndIf;
	
	For Each ItemOfTaxInfo In ArrayOfTaxInfo Do
		If ItemOfTaxInfo.Type = PredefinedValue("Enum.TaxType.Rate")
			And Not ValueIsFilled(ItemRow[ItemOfTaxInfo.Name]) Then
			
			ArrayOfTaxRates = New Array();
			
			If CommonFunctionsClientServer.ObjectHasProperty(Object, "Agreement") Then
				Parameters = New Structure();
				Parameters.Insert("Date", Object.Date);
				Parameters.Insert("Company", Object.Company);
				Parameters.Insert("Tax", ItemOfTaxInfo.Tax);
				Parameters.Insert("Agreement", Object.Agreement);
				
				ArrayOfTaxRates = TaxesServer.TaxRatesForAgreement(Parameters);
			EndIf;
			
			If Not ArrayOfTaxRates.Count() Then
				Parameters = New Structure();
				Parameters.Insert("Date", Object.Date);
				Parameters.Insert("Company", Object.Company);
				Parameters.Insert("Tax", ItemOfTaxInfo.Tax);
				
				If CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "ItemKey") Then
					Parameters.Insert("ItemKey", ItemRow.ItemKey);
				Else
					Parameters.Insert("ItemKey", PredefinedValue("Catalog.ItemKeys.EmptyRef"));
				EndIf;
				
				ArrayOfTaxRates = TaxesServer.GetTaxRatesForItemKey(Parameters);
			EndIf;
			
			If ArrayOfTaxRates.Count() Then
				ItemRow[ItemOfTaxInfo.Name] = ArrayOfTaxRates[0].TaxRate;
			EndIf;
		EndIf;
		
		// Calculate tax amount
		TaxParameters = New Structure();
		TaxParameters.Insert("Tax", ItemOfTaxInfo.Tax);
		TaxParameters.Insert("TaxRateOrAmount", ItemRow[ItemOfTaxInfo.Name]);
		TaxParameters.Insert("PriceIncludeTax", PriceIncludeTax);
		TaxParameters.Insert("Key", ItemRow.Key);
		TaxParameters.Insert("Object", Object);
		TaxParameters.Insert("Reverse", Reverse);
		
		ArrayOfResult = TaxesServer.CalculateTax(TaxParameters);
		
		For Each RowOfResult In ArrayOfResult Do
			NewTax = Object.TaxList.Add();
			NewTax.Key = ItemRow.Key;
			NewTax.Tax = RowOfResult.Tax;
			NewTax.Analytics = RowOfResult.Analytics;
			NewTax.TaxRate = RowOfResult.TaxRate;
			NewTax.Amount = RowOfResult.Amount;
			NewTax.IncludeToTotalAmount = RowOfResult.IncludeToTotalAmount;
			
			CachedRow = FindRowInCache(TaxListCache, NewTax, ArrayOfCheckedColumns);
			
			If CachedRow = Undefined Then
				NewTax.ManualAmount = NewTax.Amount;
			Else
				NewTax.ManualAmount = ?(CachedRow.Amount = NewTax.Amount, CachedRow.ManualAmount, NewTax.Amount);
			EndIf;
		EndDo;
	EndDo;
	
	ItemRow.TaxAmount = GetTotalAmountByDependedTable(Object, "TaxList", ItemRow.Key);
EndProcedure


Procedure CalculateTaxManualPriority(Object, ItemRow, PriceIncludeTax, ArrayOfTaxInfo, Reverse, AddInfo = Undefined)
	
	// ArrayOfTaxInfo
	// - Name (column name)
	// - Tax
	CachedColumns = "Key, Tax, Analytics, TaxRate, Amount, ManualAmount";
	TaxListCache = DeleteRowsInDependedTable(Object, "TaxList", ItemRow.Key, CachedColumns);
	
	CheckedColumns = "Key, Tax, Analytics, TaxRate";
	ArrayOfCheckedColumns = StrSplit(CheckedColumns, ",");
	
	If ArrayOfTaxInfo = Undefined Then
		Return;
	EndIf;
	
	If CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "ItemKey") 
			And Not ValueIsFilled(ItemRow.ItemKey) Then
		Return;
	EndIf;
	
	For Each ItemOfTaxInfo In ArrayOfTaxInfo Do
		If ItemOfTaxInfo.Type = PredefinedValue("Enum.TaxType.Rate")
			And Not ValueIsFilled(ItemRow[ItemOfTaxInfo.Name]) Then
			
			ArrayOfTaxRates = New Array();
			
			If CommonFunctionsClientServer.ObjectHasProperty(Object, "Agreement") Then
				Parameters = New Structure();
				Parameters.Insert("Date", Object.Date);
				Parameters.Insert("Company", Object.Company);
				Parameters.Insert("Tax", ItemOfTaxInfo.Tax);
				Parameters.Insert("Agreement", Object.Agreement);
				
				ArrayOfTaxRates = TaxesServer.TaxRatesForAgreement(Parameters);
			EndIf;
			
			If Not ArrayOfTaxRates.Count() Then
				Parameters = New Structure();
				Parameters.Insert("Date", Object.Date);
				Parameters.Insert("Company", Object.Company);
				Parameters.Insert("Tax", ItemOfTaxInfo.Tax);
				
				If CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "ItemKey") Then
					Parameters.Insert("ItemKey", ItemRow.ItemKey);
				Else
					Parameters.Insert("ItemKey", PredefinedValue("Catalog.ItemKeys.EmptyRef"));
				EndIf;
				
				ArrayOfTaxRates = TaxesServer.GetTaxRatesForItemKey(Parameters);
			EndIf;
			
			If ArrayOfTaxRates.Count() Then
				ItemRow[ItemOfTaxInfo.Name] = ArrayOfTaxRates[0].TaxRate;
			EndIf;
		EndIf;
		
		// Calculate tax amount
		TaxParameters = New Structure();
		TaxParameters.Insert("Tax", ItemOfTaxInfo.Tax);
		TaxParameters.Insert("TaxRateOrAmount", ItemRow[ItemOfTaxInfo.Name]);
		TaxParameters.Insert("PriceIncludeTax", PriceIncludeTax);
		TaxParameters.Insert("Key", ItemRow.Key);
		TaxParameters.Insert("Object", Object);
		TaxParameters.Insert("Reverse", Reverse);
		
		ArrayOfResult = TaxesServer.CalculateTax(TaxParameters);
		
		For Each RowOfResult In ArrayOfResult Do
			NewTax = Object.TaxList.Add();
			NewTax.Key = ItemRow.Key;
			NewTax.Tax = RowOfResult.Tax;
			NewTax.Analytics = RowOfResult.Analytics;
			NewTax.TaxRate = RowOfResult.TaxRate;
			NewTax.IncludeToTotalAmount = RowOfResult.IncludeToTotalAmount;
			NewTax.Amount = RowOfResult.Amount;
			
			CachedRow = FindRowInCache(TaxListCache, NewTax, ArrayOfCheckedColumns);
			
			If CachedRow = Undefined Then
				NewTax.ManualAmount = NewTax.Amount;
			Else
				NewTax.ManualAmount = ?(CachedRow.ManualAmount = CachedRow.Amount, NewTax.Amount, CachedRow.ManualAmount);
			EndIf;
		EndDo;
	EndDo;
	
	ItemRow.TaxAmount = GetTotalAmountByDependedTable(Object, "TaxList", ItemRow.Key);
EndProcedure

Function FindRowInCache(Cache, Filter, ArrayOfColumnNames)
	For Each ItemOfCache In Cache Do
		ValueEqualInAllColumns = True;
		For Each ItemOfColumnNames In ArrayOfColumnNames Do
			If ItemOfCache[TrimAll(ItemOfColumnNames)] <> Filter[TrimAll(ItemOfColumnNames)] Then
				ValueEqualInAllColumns = False;
				Break;
			EndIf;
		EndDo;
		If ValueEqualInAllColumns Then
			Return ItemOfCache;
		EndIf;
	EndDo;
	Return Undefined;
EndFunction

Procedure RecalculateAppliedOffers(Object, ItemRow, AddInfo = Undefined)
	ActiveOffers = OffersServer.GetAllActiveOffers_ForDocument(Object, AddInfo);
	AppliedOffers = OffersServer.GetAllAppliedOffers(Object, AddInfo);
	
	RecalculateAppliedOffers_ForDocument(Object, ItemRow, ActiveOffers, AppliedOffers, AddInfo);
	
	RecalculateAppliedOffers_ForRow(Object, AddInfo);
EndProcedure

Procedure RecalculateAppliedOffers_ForDocument(Object, ItemRow, ActiveOffers, AppliedOffers, AddInfo = Undefined) Export
	OffersAddress = OffersServer.CreateOffersTreeAndPutToTmpStorage(Object,
			Object.ItemList,
			Object.SpecialOffers,
			ActiveOffers);
	
	OffersAddress = OffersServer.SetIsSelectForAppliedOffers(OffersAddress, AppliedOffers);
	
	CalculateAndLoadOffers_ForDocument(Object, OffersAddress);
	
EndProcedure

Procedure RecalculateAppliedOffers_ForRow(Object, AddInfo = Undefined) Export
	For Each Row In Object.SpecialOffers Do
		If ValueIsFilled(Row.Offer)
			And OffersServer.IsOfferForRow(Row.Offer)
			And ValueIsFilled(Row.Percent)
			And ValueIsFilled(Row.Key) Then
			
			ArrayOfOffers = New Array();
			ArrayOfOffers.Add(Row.Offer);
			
			TreeByOneOfferAddress = OffersServer.CreateOffersTreeAndPutToTmpStorage(Object,
					Object.ItemList,
					Object.SpecialOffers,
					ArrayOfOffers,
					Row.Key);
			
			CalculateAndLoadOffers_ForRow(Object, TreeByOneOfferAddress, Row.Key);
			
		EndIf;
	EndDo;
EndProcedure

Procedure CalculateAndLoadOffers_ForDocument(Object, OffersAddress) Export
	OffersAddress = OffersServer.CalculateOffersTreeAndPutToTmpStorage_ForDocument(Object,
			New Structure("OffersAddress", OffersAddress));
	
	ArrayOfOffers = OffersServer.GetArrayOfAllOffers_ForDocument(Object, OffersAddress);
	Object.SpecialOffers.Clear();
	For Each Row In ArrayOfOffers Do
		FillPropertyValues(Object.SpecialOffers.Add(), Row);
	EndDo;
EndProcedure

Procedure CalculateAndLoadOffers_ForRow(Object, OffersAddress, ItemListRowKey) Export
	TreeByOneOfferAddress = OffersServer.CalculateOffersTreeAndPutToTmpStorage_ForRow(Object,
			New Structure("OffersAddress, ItemListRowKey", OffersAddress, ItemListRowKey));
	
	ArrayOfOffers = OffersServer.GetArrayOfAllOffers_ForRow(Object, TreeByOneOfferAddress, ItemListRowKey);
	Object.SpecialOffers.Clear();
	For Each Row In ArrayOfOffers Do
		FillPropertyValues(Object.SpecialOffers.Add(), Row);
	EndDo;
EndProcedure

Procedure CalculateSpecialOffers(Object, ItemRow, AddInfo = Undefined)
	ItemRow.OffersAmount = GetTotalAmountByDependedTable(Object, "SpecialOffers", ItemRow.Key);
EndProcedure

Function GetTotalAmountByDependedTable(Object, DependedTableName, MainTableKey)
	Amount = 0;
	For Each Row In Object[DependedTableName] Do
		If CommonFunctionsClientServer.ObjectHasProperty(Row, "IncludeToTotalAmount") 
				And Not Row.IncludeToTotalAmount Then
			Continue;
		EndIf;
		If Row.Key = MainTableKey Then
			Amount = Amount + ?(CommonFunctionsClientServer.ObjectHasProperty(Row, "ManualAmount"), 
								Row.ManualAmount, 
								Row.Amount);
		EndIf;
	EndDo;
	Return Amount;
EndFunction

Function DeleteRowsInDependedTable(Object, DependedTableName, MainTableKey, CachedColumns = Undefined)
	DependedRows = Object[DependedTableName].FindRows(New Structure("Key", MainTableKey));
	Cache = New Array();
	ArrayOfCachedColumns = StrSplit(CachedColumns, ",");
	For Each Row In DependedRows Do
		CacheRow = New Structure();
		For Each ItemOfCachedColumns In ArrayOfCachedColumns Do
			CacheRow.Insert(TrimAll(ItemOfCachedColumns), Row[TrimAll(ItemOfCachedColumns)]);
		EndDo;
		Cache.Add(CacheRow);
		Object[DependedTableName].Delete(Row);
	EndDo;
	Return Cache;
EndFunction

Function PricesChanged(Object, Form, Settings) Export

	CachedColumns = "Key, Price, PriceType, ItemKey, Unit";
	ListCache = GetCacheTable(Object, "ItemList", CachedColumns);
	
	CalculationSettings = New Structure();
	PriceDate = ?(Object.Ref.IsEmpty(), CurrentDate(), Object.Date);
	CalculationSettings.Insert("UpdatePrice",
					New Structure("Period, PriceType", PriceDate, Form.CurrentPriceType));
	
	CalculateItemsRows(Object, Form, ListCache, CalculationSettings);

	For Each RowCache In ListCache Do
		FoundRows = Object.ItemList.FindRows(New Structure("Key", RowCache.Key));
		For Each FoundRow In FoundRows Do
			If Not FoundRow.Price = RowCache.Price Then
				Return True;	
			EndIf;
		EndDo;
	EndDo;
	
	Return False;
EndFunction

Function GetCacheTable(Object, TableName, CachedColumns = Undefined)
	Cache = New Array();
	ArrayOfCachedColumns = StrSplit(CachedColumns, ",");
	For Each Row In Object[TableName] Do
		CacheRow = New Structure();
		For Each ItemOfCachedColumns In ArrayOfCachedColumns Do
			CacheRow.Insert(TrimAll(ItemOfCachedColumns), Row[TrimAll(ItemOfCachedColumns)]);
		EndDo;
		Cache.Add(CacheRow);
	EndDo;
	Return Cache;
EndFunction

Function UpdateBarcode(Object, ItemRow, AddInfo = Undefined)
	ReturnValue = "";
	BarcodesInfo = BarcodeServer.GetBarcodesByItemKey(ItemRow.ItemKey);
	If BarcodesInfo.Count() Then
		ItemRow.Barcode = BarcodesInfo[0];
		ReturnValue = BarcodesInfo[0];
	Else
		ReturnValue = "";
	EndIf;
	Return ReturnValue;
EndFunction

#Region NeewForms


Procedure CalculateRow(Object, Form, Settings, Actions) Export
	
	DoTableActions(Object, Form, Settings, Actions);
	
EndProcedure


Procedure DoTableActions(Object, Form, Settings, Actions) Export
	
	For Each Action In Actions Do
		
		If Action.Key = "UpdateItemKey" Then
			UpdateItemKey(Object, Form, Settings);
		EndIf;
		
		If Action.Key = "UpdateItemType" Then
			UpdateItemType(Object, Form, Settings);
		EndIf;
		
		If Action.Key = "UpdateRowUnit" Then
			UpdateRowUnit(Object, Form, Settings);
		EndIf;
		
		If Action.Key = "UpdateRowPriceType" Then
			UpdateRowPriceType(Object, Form, Settings);
		EndIf;
		
		If Action.Key = "UpdateProcurementMethod" Then
			UpdateProcurementMethod(Object, Form, Settings);
		EndIf;
		
		If Action.Key = "UpdateOffersAmount" Then
			UpdateOffersAmount(Object, Form, Settings);
		EndIf;
		
		If Action.Key = "UpdateTaxAmount" Then
			UpdateTaxAmount(Object, Form, Settings);
		EndIf;
		
		If Action.Key = "UpdateNetAmount" Then
			UpdateNetAmount(Object, Form, Settings);
		EndIf;
		
		If Action.Key = "UpdateTotalAmount" Then
			UpdateTotalAmount(Object, Form, Settings);
		EndIf;
		
	EndDo;
	
EndProcedure

#EndRegion

#Region TableItemsChanges

Procedure UpdateItemKey(Object, Form, Settings) Export

	CurrentRow = Settings.CurrentRow;
	CurrentItemKey = CurrentRow.ItemKey;

	CurrentRow.ItemKey = CatItemsServer.GetItemKeyByItem(CurrentRow.Item);
	If ValueIsFilled(CurrentRow.ItemKey) Then
		#If AtClient Then
		If Not CurrentRow.ItemKey = CurrentItemKey Then
			DocumentsClient.ItemListItemKeyOnChange(Object, Form, Settings.Module, , Settings);
		EndIf;
		#EndIf
	Else
		Settings.CalculateSettings.Insert("ClearRow", "ClearRow");
	EndIf;
	
EndProcedure

Function UpdateUnit(Object, ItemRow, AddInfo = Undefined)	
	
	UnitInfo = GetItemInfo.ItemUnitInfo(ItemRow.ItemKey);
    ItemRow.Unit = UnitInfo.Unit;
    Return UnitInfo.Unit;
EndFunction

Procedure UpdateRowUnit(Object, Form, Settings)
	
	If Settings.Rows.Count() = 0 Then
		Return;
	EndIf;
	
	CurrentRow = Settings.Rows[0];
	
	UnitInfo = GetItemInfo.ItemUnitInfo(CurrentRow.ItemKey);
	CurrentRow.Unit = UnitInfo.Unit;
	
EndProcedure


Procedure UpdateRowPriceType(Object, Form, Settings)
	If Settings.Rows.Count() = 0 Then
		Return;
	EndIf;
	
	CurrentRow = Settings.Rows[0];
	
	CurrentRow.PriceType =  Form.CurrentPriceType;
	
EndProcedure

Procedure UpdateItemType(Object, Form, Settings) Export

	If Settings.Rows.Count() = 0 Then
		Return;
	EndIf;
	
	CurrentRow = Settings.Rows[0];
	
	// TODO: SalesOrder???
	CurrentRow.ItemType = DocSalesOrderServer.GetItemRowType(CurrentRow.Item);
	If CurrentRow.ItemType = PredefinedValue("Enum.ItemTypes.Service") Then
		CurrentRow.ProcurementMethod = Undefined;
	Else
		UpdateProcurementMethod(Object, Form, Settings);
	EndIf;
	
EndProcedure

Procedure UpdateProcurementMethod(Object, Form, Settings) Export
	
	If Settings.Rows.Count() = 0 Then
		Return;
	EndIf;
	
	CurrentRow = Settings.Rows[0];
	
	If ValueIsFilled(CurrentRow.ProcurementMethod) Then
		Return;
	EndIf;
	
	If CatItemsServer.StoreMustHave(CurrentRow.Item) Then
		CurrentRow.ProcurementMethod = PredefinedValue("Enum.ProcurementMethods.Stock");
	EndIf;
EndProcedure

Procedure UpdateOffersAmount(Object, Form, Settings) Export
	Return;
EndProcedure

Procedure UpdateTaxAmount(Object, Form, Settings) Export
	Return;
EndProcedure

Procedure UpdateNetAmount(Object, Form, Settings) Export
	Return;
EndProcedure

Procedure UpdateTotalAmount(Object, Form, Settings) Export
	Return;
EndProcedure

#EndRegion
