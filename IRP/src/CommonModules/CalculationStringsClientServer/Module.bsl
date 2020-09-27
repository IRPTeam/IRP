Function GetCalculationSettings(Actions = Undefined, AddInfo = Undefined) Export
	If Actions = Undefined Then
		Actions = New Structure;
	EndIf;
	
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
	If AddInfo = Undefined OR Not AddInfo.Property("TableParent") Then
		TableName = "ItemList";
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

Function GetColumnNames_ItemList(ArrayOfTaxInfo = Undefined) Export
	ColumnNames = "Key, Unit, Price, PriceType, ItemKey, Quantity, OffersAmount, 
				  |TotalAmount, NetAmount, TaxAmount, Info, Barcode, DontCalculateRow";
	If ArrayOfTaxInfo <> Undefined Then
		For Each ItemOfTaxInfo In ArrayOfTaxInfo Do
			ColumnNames = ColumnNames + "," +	ItemOfTaxInfo.Name;
		EndDo;
	EndIf;
	Return ColumnNames;
EndFunction	

Function GetColumnNames_TaxList() Export
	Return "Key, Tax, Analytics, TaxRate, Amount, IncludeToTotalAmount, ManualAmount";
EndFunction

Function GetColumnNames_SpecialOffers() Export
	Return "Key, Offer, Amount, Percent";
EndFunction

Function DataCollectionToArrayOfStructures(DataCollection, ColumnNames) Export
	ArrayOfStructures = New Array();
	For Each Row In DataCollection Do
		NewRow = New Structure(ColumnNames);
		FillPropertyValues(NewRow, Row);
		ArrayOfStructures.Add(NewRow);
	EndDo;
	Return ArrayOfStructures;
EndFunction

Procedure UpdateDataCollectionByArrayOfStructures(DataCollection, ArrayOfStructures, ColumnNames) Export
	For Each Row In ArrayOfStructures Do
		ArrayOfUpdatedRows = DataCollection.FindRows(New Structure("Key", Row.Key));
		If ArrayOfUpdatedRows.Count() = 0 Then
			Raise StrTemplate("Not found row by key [%1]", Row.Key);
		ElsIf ArrayOfUpdatedRows.Count() > 1 Then
			Raise StrTemplate("Found several row by key [%1]", Row.Key);;
		Else
			For Each UpdatedRow In ArrayOfUpdatedRows Do
				FillPropertyValues(UpdatedRow, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure	

Procedure FillDataCollectionByArrayOfStructures(DataCollection, ArrayOfStructures, ColumnNames) Export
	DataCollection.Clear();
	For Each Row In ArrayOfStructures Do
		FillPropertyValues(DataCollection.Add(), Row);
	EndDo;
EndProcedure	
		
Function CalculateItemsRows(Object, Form, ItemRows, Actions, ArrayOfTaxInfo = Undefined, AddInfo = Undefined) Export
	Result = New Structure("ItemList, TaxList, SpecialOffers");
	If Not Actions.Count() Then
		Return Result;
	EndIf;
	
	CalculateItemRowsAtServer = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "CalculateItemRowsAtServer");
	
	If CalculateItemRowsAtServer <> Undefined Then
		
		UpdateRowsAfterCalculate = True;
		UpdateRowsAfterCalculateValue = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "UpdateRowsAfterCalculate");
		If UpdateRowsAfterCalculateValue <> Undefined Then
			UpdateRowsAfterCalculate = UpdateRowsAfterCalculateValue;
		EndIf;
		
		CommonFunctionsClientServer.DeleteFromAddInfo(AddInfo, "UpdateRowsAfterCalculate");
		
		ColumnNames_ItemList      = GetColumnNames_ItemList(ArrayOfTaxInfo);
		ColumnNames_TaxList       = GetColumnNames_TaxList();
		ColumnNames_SpecilaOffers = GetColumnNames_SpecialOffers();
	
		ArrayOfRows_ItemList      = DataCollectionToArrayOfStructures(ItemRows             , ColumnNames_ItemList);
		ArrayOfRows_TaxList       = DataCollectionToArrayOfStructures(Object.TaxList       , ColumnNames_TaxList);
		ArrayOfRows_SpecialOffers = DataCollectionToArrayOfStructures(Object.SpecialOffers , ColumnNames_SpecilaOffers);
		
		ObjectAsStructure = New Structure("Date, Company, Partner, Agreement, PriceIncludeTax");
		FillPropertyValues(ObjectAsStructure, Object);
		ObjectAsStructure.Insert("Ref"           , Object.Ref);		
		ObjectAsStructure.Insert("ItemList"      , ArrayOfRows_ItemList);
		ObjectAsStructure.Insert("TaxList"       , ArrayOfRows_TaxList);
		ObjectAsStructure.Insert("SpecialOffers" , ArrayOfRows_SpecialOffers);
		
		CalculationServer.CalculateItemsRows(ObjectAsStructure, 
											 Undefined, 
											 Actions, 
											 ArrayOfTaxInfo, 
											 AddInfo);	
		
		Result.ItemList      = ObjectAsStructure.ItemList;
		Result.TaxList       = ObjectAsStructure.TaxList;
		Result.SpecialOffers = ObjectAsStructure.SpecialOffers;
		
		If UpdateRowsAfterCalculate Then
			UpdateDataCollectionByArrayOfStructures(Object.ItemList      , ObjectAsStructure.ItemList      , ColumnNames_ItemList);
			FillDataCollectionByArrayOfStructures(Object.TaxList         , ObjectAsStructure.TaxList       , ColumnNames_TaxList);		                                        
			FillDataCollectionByArrayOfStructures(Object.SpecialOffers   , ObjectAsStructure.SpecialOffers , ColumnNames_SpecilaOffers);									 
		EndIf;
	Else
		For Each ItemRow In ItemRows Do
			CalculateItemsRow(Object, ItemRow, Actions, ArrayOfTaxInfo, AddInfo);
		EndDo;
		If Object.Property("ItemList") Then
			Result.ItemList      = Object.ItemList;
		EndIf;
		If Object.Property("TaxList") Then
			Result.TaxList       = Object.TaxList;
		EndIf;
		If Object.Property("SpecialOffers") Then
			Result.SpecialOffers = Object.SpecialOffers;
		EndIf;		
	EndIf;
	
	#If ThinClient Then
		
	For Each Action In Actions Do		
		NotifyStructure = New Structure();
		NotifyStructure.Insert("Object"			, Object);
		NotifyStructure.Insert("ItemRow"		, Undefined);
		NotifyStructure.Insert("Actions"		, Actions);
		NotifyStructure.Insert("ArrayOfTaxInfo"	, ArrayOfTaxInfo);
		NotifyStructure.Insert("AddInfo"		, AddInfo);	
			
		Notify(Action.Key, NotifyStructure, Form);
	EndDo;

	Notify("CallbackHandler", New Structure("AddInfo", AddInfo), Form);
	
	#EndIf
	Return Result;
EndFunction

Procedure CalculateItemsRow(Object, ItemRow, Actions, ArrayOfTaxInfo = Undefined, AddInfo = Undefined) Export
	IsCalculatedRow = True;
	If CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "DontCalculateRow")
		And ItemRow.DontCalculateRow Then
			IsCalculatedRow = False;
	EndIf;
			
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
			If Actions.Property("CalculateTotalAmount") And IsCalculatedRow Then
				CalculateTotalAmount_PriceIncludeTax(Object, ItemRow, AddInfo);
			EndIf;
			
			If Actions.Property("CalculateTax") And IsCalculatedRow Then
				CalculateTax_PriceIncludeTax(Object, ItemRow, ArrayOfTaxInfo, AddInfo);
			EndIf;
			
			If Actions.Property("CalculateNetAmount") And IsCalculatedRow Then
				CalculateNetAmount_PriceIncludeTax(Object, ItemRow, AddInfo);
			EndIf;
		Else
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
		If Actions.Property("CalculateTax") And IsCalculatedRow Then
			CalculateTaxManualPriority(Object, ItemRow, False, ArrayOfTaxInfo, False, AddInfo);
		EndIf;
		
		If Actions.Property("CalculateTotalAmount") And IsCalculatedRow Then
			CalculateTotalAmount_PriceNotIncludeTax(Object, ItemRow, AddInfo);
		EndIf;
		
		If Actions.Property("CalculateTaxByNetAmount") And IsCalculatedRow Then
			CalculateTaxManualPriority(Object, ItemRow, False, ArrayOfTaxInfo, False, AddInfo);
		EndIf;
		
		If Actions.Property("CalculateTaxByTotalAmount") And IsCalculatedRow Then
			CalculateTaxManualPriority(Object, ItemRow, True, ArrayOfTaxInfo, False, AddInfo);
		EndIf;
		
		If Actions.Property("CalculateNetAmountByTotalAmount") And IsCalculatedRow Then
			CalculateNetAmount_PriceIncludeTax(Object, ItemRow, AddInfo);
		EndIf;
		
		If Actions.Property("CalculateTotalAmountByNetAmount") And IsCalculatedRow Then
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
		Raise "Not supported table";
	EndIf;
	
	ArrayOfItemRows = Table.FindRows(New Structure("Key", ItemRow.Key));
	If ArrayOfItemRows.Count() <> 1 Then
		Raise StrTemplate("Find %1 rows in table by key %2", ArrayOfItemRows.Count(), ItemRow.Key);
	EndIf;
	
	ItemRow = ArrayOfItemRows[0];
	TaxParameters.Insert("TotalAmount", ItemRow.TotalAmount);
	TaxParameters.Insert("NetAmount" ,ItemRow.NetAmount);
	TaxParameters.Insert("Ref" ,Object.Ref);
		
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
	
	If CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "ItemKey") 
			And Not ValueIsFilled(ItemRow.ItemKey) Then
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
					Parameters = New Structure;
					Parameters.Insert("Date", Object.Date);
					Parameters.Insert("Company", Object.Company);
					Parameters.Insert("Tax", ItemOfTaxInfo.Tax);
					Parameters.Insert("Agreement", Object.Agreement);
					ArrayOfTaxRates = TaxesServer.TaxRatesForAgreement(Parameters);
				EndIf;

				If Not ArrayOfTaxRates.Count() Then
					Parameters = New Structure;
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
		
		TaxParameters = GetTaxCalculationParameters(Object, ItemRow, ItemOfTaxInfo, PriceIncludeTax, Reverse, AddInfo);
		
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
			Amount = Round(Amount + ?(CommonFunctionsClientServer.ObjectHasProperty(Row, "ManualAmount"), 
								Row.ManualAmount, 
								Row.Amount), 2);
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

Function IsPricesChanged(Object, Form, Settings, AddInfo = Undefined) Export
	ListCache = DataCollectionToArrayOfStructures(Object.ItemList, GetColumnNames_ItemList());
	
	CalculationSettings = New Structure();
	PriceDate = GetPriceDateByRefAndDate(Object.Ref, Object.Date);
	CalculationSettings.Insert("UpdatePrice", New Structure("Period, PriceType", PriceDate, Form.CurrentPriceType));
	
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "UpdateRowsAfterCalculate", False);
	CalculatedTables = CalculateItemsRows(Object, Form, ListCache, CalculationSettings, Undefined, AddInfo);

	For Each RowCalculatedTables In CalculatedTables.ItemList Do
		FoundRows = Object.ItemList.FindRows(New Structure("Key", RowCalculatedTables.Key));
		For Each FoundRow In FoundRows Do
			If Not FoundRow.Price = RowCalculatedTables.Price Then
				Return True;
			EndIf;
		EndDo;
	EndDo;
	
	Return False;
EndFunction

Function GetPriceDateByRefAndDate(Ref, Date) Export
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
Endfunction

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

Procedure DoTableActions(Object, Form, Settings, Actions, AddInfo = Undefined) Export
	
	For Each Action In Actions Do
		
		If Action.Key = "UpdateItemKey" Then
			UpdateItemKey(Object, Form, Settings, AddInfo);
		EndIf;
		
		If Action.Key = "UpdateItemType" Then
			UpdateItemType(Object, Form, Settings);
		EndIf;
		
		If Action.Key = "UpdateRowUnit" Then
			UpdateRowUnit(Object, Form, Settings, AddInfo);
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

Procedure UpdateRowUnit(Object, Form, Settings, AddInfo = Undefined)
	
	If Settings.Rows.Count() = 0 Then
		Return;
	EndIf;
	
	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	
	CurrentRow = Settings.Rows[0];
	
	If ServerData = Undefined Then
		UnitInfo = GetItemInfo.ItemUnitInfo(CurrentRow.ItemKey);
	Else
		UnitInfo = ServerData.ItemUnitInfo;
	EndIf;
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