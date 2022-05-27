Function GetCalculationSettings(Actions = Undefined, AddInfo = Undefined) Export
	If Actions = Undefined Then
		Actions = New Structure();
	EndIf;
	Actions.Insert("CalculateQuantityInBaseUnit");
	Actions.Insert("CalculateSpecialOffers");
	Actions.Insert("CalculateNetAmount");
	Actions.Insert("CalculateTax");
	Actions.Insert("CalculateTotalAmount");

#If MobileClient Then
	Actions.Insert("UpdateInfoString");
#EndIf

	Return Actions;
EndFunction

Procedure ClearDependentData(Object, AddInfo = Undefined) Export
	If AddInfo = Undefined Or Not AddInfo.Property("TableParent") Then
		TableName = "ItemList";
	Else
		TableName = AddInfo.TableParent;
	EndIf;

	If CommonFunctionsClientServer.ObjectHasProperty(Object, "TaxList") Then
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

	If CommonFunctionsClientServer.ObjectHasProperty(Object, "SpecialOffers") Then
		ArrayForDelete = New Array();
		For Each Row In Object.SpecialOffers Do
			If ValueIsFilled(Row.Offer) And CalculationServer.OfferHaveManualInputValue(Row.Offer)
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

Function CalculateItemsRows(Object, Form, ItemRows, Actions, ArrayOfTaxInfo = Undefined, AddInfo = Undefined) Export
	Result = New Structure("ItemList, PaymentList, TaxList, SpecialOffers");
	If Not Actions.Count() Then
		Return Result;
	EndIf;

	For Each ItemRow In ItemRows Do
		CalculateItemsRow(Object, ItemRow, Actions, ArrayOfTaxInfo, AddInfo);
	EndDo;
	If Object.Property("ItemList") Then
		Result.ItemList = Object.ItemList;
	EndIf;
	If Object.Property("PaymentList") Then
		Result.PaymentList = Object.PaymentList;
	EndIf;
	If Object.Property("TaxList") Then
		Result.TaxList = Object.TaxList;
	EndIf;
	If Object.Property("SpecialOffers") Then
		Result.SpecialOffers = Object.SpecialOffers;
	EndIf;


#If ThinClient Then

	For Each Action In Actions Do
		NotifyStructure = New Structure();
		NotifyStructure.Insert("Object", Object);
		NotifyStructure.Insert("ItemRow", Undefined);
		NotifyStructure.Insert("Actions", Actions);
		NotifyStructure.Insert("ArrayOfTaxInfo", ArrayOfTaxInfo);
		NotifyStructure.Insert("AddInfo", AddInfo);

		Notify(Action.Key, NotifyStructure, Form);
	EndDo;

	Notify("CalculationStringsComplete", New Structure("AddInfo", AddInfo), Form);

#EndIf
	Return Result;
EndFunction

Procedure CalculateItemsRow(Object, ItemRow, Actions, ArrayOfTaxInfo = Undefined, AddInfo = Undefined) Export
	IsCalculatedRow = True;
	If CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "DontCalculateRow") And ItemRow.DontCalculateRow Then
		IsCalculatedRow = False;
	EndIf;

	If Actions.Property("UpdateUnit") Then
		UpdateUnit(Object, ItemRow, AddInfo);
	EndIf;

	If Actions.Property("CalculateQuantityInBaseUnit") Then
		CalculateQuantityInBaseUnit(Object, ItemRow, AddInfo);
	EndIf;

	If Actions.Property("ChangePriceType") Then
		ChangePriceType(Object, ItemRow, Actions.ChangePriceType, AddInfo);
	EndIf;

	If Actions.Property("UpdatePrice") Then //
		UpdatePrice(Object, ItemRow, Actions.UpdatePrice, AddInfo);
	EndIf;

	If Actions.Property("RecalculateAppliedOffers") Then
		RecalculateAppliedOffers(Object, ItemRow, AddInfo);
	EndIf;

	If Actions.Property("CalculateSpecialOffers") Then //
		CalculateSpecialOffers(Object, ItemRow, AddInfo);
	EndIf;

	CheckingStructure = New Structure("PriceIncludeTax", Undefined);
	FillPropertyValues(CheckingStructure, Object);

	If CheckingStructure.PriceIncludeTax <> Undefined Then
		If Object.PriceIncludeTax Then
			If Actions.Property("CalculateTotalAmount") And IsCalculatedRow Then
				CalculateTotalAmount_PriceIncludeTax(Object, ItemRow, AddInfo);
			EndIf;

			If Actions.Property("CalculateTax") And IsCalculatedRow Then
				CalculateTax_PriceIncludeTax(Object, ItemRow, ArrayOfTaxInfo, AddInfo);
			EndIf;

			If Actions.Property("CalculateNetAmountAsTotalAmountMinusTaxAmount") And IsCalculatedRow Then
				CalculateNetAmount_PriceIncludeTax(Object, ItemRow, AddInfo);
			EndIf;

			If Actions.Property("CalculateNetAmount") And IsCalculatedRow Then
				CalculateNetAmount_PriceIncludeTax(Object, ItemRow, AddInfo);
			EndIf;
		Else
			If Actions.Property("CalculateNetAmountAsTotalAmountMinusTaxAmount") And IsCalculatedRow Then
				CalculateNetAmountAsTotalAmountMinusTaxAmount_PriceNotIncludeTax(Object, ItemRow, AddInfo);
			EndIf;

			If Actions.Property("CalculateNetAmount") And IsCalculatedRow Then
				CalculateNetAmount_PriceNotIncludeTax(Object, ItemRow, AddInfo);
			EndIf;

			If Actions.Property("CalculateTax") And IsCalculatedRow Then
				CalculateTax_PriceNotIncludeTax(Object, ItemRow, ArrayOfTaxInfo, AddInfo);
			EndIf;

			If Actions.Property("CalculateTotalAmount") And IsCalculatedRow Then
				CalculateTotalAmount_PriceNotIncludeTax(Object, ItemRow, AddInfo);
			EndIf;
		EndIf;
	Else

		If Actions.Property("CalculateTotalAmount") And IsCalculatedRow Then
			CalculateTotalAmount_PriceNotIncludeTax(Object, ItemRow, AddInfo);
		EndIf;

		If Actions.Property("CalculateNetAmountAsTotalAmountMinusTaxAmount") And IsCalculatedRow Then
			CalculateNetAmount_PriceIncludeTax(Object, ItemRow, AddInfo);
		EndIf;

		If Actions.Property("CalculateNetAmountByTotalAmount") And IsCalculatedRow Then
			CalculateNetAmount_PriceIncludeTax(Object, ItemRow, AddInfo);
		EndIf;

		If Actions.Property("CalculateTotalAmountByNetAmount") And IsCalculatedRow Then
			CalculateTotalAmount_PriceNotIncludeTax(Object, ItemRow, AddInfo);
		EndIf;
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

	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");

	ChangePriceTypeSettings.Insert("ItemKey", ItemRow.ItemKey);

	If CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "PriceType") Then
		ChangePriceTypeSettings.Insert("RowPriceType", ItemRow.PriceType);
	Else
		ChangePriceTypeSettings.Insert("RowPriceType", ChangePriceTypeSettings.PriceType);
	EndIf;

	If ServerData = Undefined Then
		If ChangePriceTypeSettings.RowPriceType = PredefinedValue("Catalog.PriceTypes.ManualPriceType") Then
			Return;
		EndIf;
	Else
		If ChangePriceTypeSettings.RowPriceType = ServerData.PriceTypes_ManualPriceType Then
			Return;
		EndIf;
	EndIf;

	ChangePriceTypeSettings.Insert("Unit", ItemRow.Unit);
	ChangePriceTypeSettings.Insert("Object", Object);

	PriceInfo = GetItemInfo.ItemPriceInfo(ChangePriceTypeSettings, AddInfo);
	ItemRow.Price = ?(PriceInfo = Undefined, 0, PriceInfo.Price);

EndProcedure

#Region Amount

Procedure CalculateNetAmount_PriceIncludeTax(Object, ItemRow, AddInfo = Undefined)
	If CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "OffersAmount") Then
		ItemRow.NetAmount = CalculateAmount(ItemRow) - ItemRow.TaxAmount - ItemRow.OffersAmount;
	Else
		ItemRow.NetAmount = CalculateAmount(ItemRow) - ItemRow.TaxAmount;
	EndIf;

EndProcedure

Procedure CalculateNetAmountAsTotalAmountMinusTaxAmount_PriceNotIncludeTax(Object, ItemRow, AddInfo = Undefined)
	If CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "OffersAmount") Then
		ItemRow.NetAmount = ItemRow.TotalAmount - ItemRow.TaxAmount - ItemRow.OffersAmount;
	Else
		ItemRow.NetAmount = ItemRow.TotalAmount - ItemRow.TaxAmount;
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
	If CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "Price") Then
		If CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "QuantityInBaseUnit") And ItemRow.PriceType
			= PredefinedValue("Catalog.PriceTypes.ManualPriceType") Then
			Return ItemRow.Price * ItemRow.QuantityInBaseUnit;
		ElsIf CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "Quantity") Then
			Return ItemRow.Price * ItemRow.Quantity;
		Else
			Return ItemRow.TotalAmount;
		EndIf;
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

Function GetTaxCalculationParameters(Object, ItemRow, ItemOfTaxInfo, PriceIncludeTax, Reverse, AddInfo = Undefined)
	TaxParameters = New Structure();
	TaxParameters.Insert("Tax", ItemOfTaxInfo.Tax);
	TaxParameters.Insert("TaxRateOrAmount", ItemRow[ItemOfTaxInfo.Name]);
	TaxParameters.Insert("PriceIncludeTax", PriceIncludeTax);
	TaxParameters.Insert("Key", ItemRow.Key);

	Table = Undefined;
	If Object.Property("ItemList") Then
		Table = Object.ItemList;
	ElsIf Object.Property("PaymentList") Then
		Table = Object.PaymentList;
	Else
		Raise R().I_5;
	EndIf;

	ArrayOfItemRows = Table.FindRows(New Structure("Key", ItemRow.Key));
	If ArrayOfItemRows.Count() <> 1 Then
		Raise StrTemplate(R().I_4, ArrayOfItemRows.Count(), ItemRow.Key);
	EndIf;

	ItemRow = ArrayOfItemRows[0];
	TaxParameters.Insert("TotalAmount", ItemRow.TotalAmount);
	TaxParameters.Insert("NetAmount", ItemRow.NetAmount);
	TaxParameters.Insert("Ref", Object.Ref);

	TaxParameters.Insert("Reverse", Reverse);
	Return TaxParameters;
EndFunction

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

	If CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "ItemKey") And Not ValueIsFilled(ItemRow.ItemKey) Then
		Return;
	EndIf;

	For Each ItemOfTaxInfo In ArrayOfTaxInfo Do

		TaxTypeIsRate = True;
		If ItemOfTaxInfo.Property("TaxTypeIsRate") Then
			TaxTypeIsRate = ItemOfTaxInfo.TaxTypeIsRate;
		Else
			TaxTypeIsRate = (ItemOfTaxInfo.Type = PredefinedValue("Enum.TaxType.Rate"));
		EndIf;

		If TaxTypeIsRate And Not ValueIsFilled(ItemRow[ItemOfTaxInfo.Name]) Then

			ArrayOfTaxRates = New Array();
			If ItemOfTaxInfo.Property("ArrayOfTaxRates") Then
				ArrayOfTaxRates = ItemOfTaxInfo.ArrayOfTaxRates;
			Else

				If CommonFunctionsClientServer.ObjectHasProperty(Object, "Agreement") Then
					Parameters = New Structure();
					Parameters.Insert("Date", Object.Date);
					Parameters.Insert("Company", Object.Company);
					Parameters.Insert("Tax", ItemOfTaxInfo.Tax);
					Parameters.Insert("Agreement", Object.Agreement);
					ArrayOfTaxRates = TaxesServer.GetTaxRatesForAgreement(Parameters);
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
			EndIf;
			If ArrayOfTaxRates.Count() Then
				ItemRow[ItemOfTaxInfo.Name] = ArrayOfTaxRates[0].TaxRate;
			EndIf;
		EndIf;

		TaxParameters = GetTaxCalculationParameters(Object, ItemRow, ItemOfTaxInfo, PriceIncludeTax, Reverse, AddInfo);

		ArrayOfResultsTaxCalculation = TaxesServer.CalculateTax(TaxParameters);

		For Each RowOfResult In ArrayOfResultsTaxCalculation Do
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
	OffersAddress = OffersServer.CreateOffersTreeAndPutToTmpStorage(Object, Object.ItemList, Object.SpecialOffers,
		ActiveOffers);

	OffersAddress = OffersServer.SetIsSelectForAppliedOffers(OffersAddress, AppliedOffers);

	CalculateAndLoadOffers_ForDocument(Object, OffersAddress);

EndProcedure

Procedure RecalculateAppliedOffers_ForRow(Object, AddInfo = Undefined) Export
	For Each Row In Object.SpecialOffers Do
		isOfferRow = ValueIsFilled(Row.Offer) And OffersServer.IsOfferForRow(Row.Offer) And ValueIsFilled(Row.Percent)
			And ValueIsFilled(Row.Key);
		If isOfferRow Then

			ArrayOfOffers = New Array();
			ArrayOfOffers.Add(Row.Offer);

			TreeByOneOfferAddress = OffersServer.CreateOffersTreeAndPutToTmpStorage(Object, Object.ItemList,
				Object.SpecialOffers, ArrayOfOffers, Row.Key);

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
		If CommonFunctionsClientServer.ObjectHasProperty(Row, "IncludeToTotalAmount") And Not Row.IncludeToTotalAmount Then
			Continue;
		EndIf;
		If Row.Key = MainTableKey Then
			Amount = Round(Amount + ?(CommonFunctionsClientServer.ObjectHasProperty(Row, "ManualAmount"),
				Row.ManualAmount, Row.Amount), 2);
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

Function GetSliceLastDateByRefAndDate(Ref, Date) Export
	If Not ValueIsFilled(Ref) Then
		If Not ValueIsFilled(Date) Then
			Return CurrentDate();
		EndIf;
		If BegOfDay(Date) = BegOfDay(CurrentDate()) Then
			Return EndOfDay(Date);
		Else
			Return Date;
		EndIf;
	Else
		Return Date;
	EndIf;
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

#Region NewForms

Procedure CalculateRow(Object, Form, Settings, Actions) Export

	DoTableActions(Object, Form, Settings, Actions);

EndProcedure

Procedure DoTableActions(Object, Form, Settings, Actions, AddInfo = Undefined) Export

	For Each Action In Actions Do

		If Action.Key = "UpdateItemKey" Then
			UpdateItemKey(Object, Form, Settings, AddInfo);
		EndIf;
		
	EndDo;

EndProcedure

#EndRegion

#Region TableItemsChanges

Procedure UpdateItemKey(Object, Form, Settings, AddInfo = Undefined) Export
	CurrentRow = Settings.CurrentRow;
	CurrentItemKey = CurrentRow.ItemKey;

	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	If ServerData = Undefined Then
		CurrentRow.ItemKey = CatItemsServer.GetItemKeyByItem(CurrentRow.Item);
	Else
		CurrentRow.ItemKey = ServerData.ItemKeyByItem;
	EndIf;

	If ValueIsFilled(CurrentRow.ItemKey) Then
#If AtClient Then
		If CurrentRow.ItemKey <> CurrentItemKey Then
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

Procedure CalculateQuantityInBaseUnit(Object, ItemRow, AddInfo = Undefined)
	If Not CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "QuantityInBaseUnit") Then
		Return;
	EndIf;
	UnitFactor = GetItemInfo.GetUnitFactor(ItemRow.ItemKey, ItemRow.Unit);
	ItemRow.QuantityInBaseUnit = ItemRow.Quantity * UnitFactor;
EndProcedure

#EndRegion
