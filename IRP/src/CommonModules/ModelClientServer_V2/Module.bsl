
// MODEL
// 
// ОБЩИЙ МОДУЛЬ ДЛЯ ВСЕХ ДОКУМЕНТОВ - уровень бизнес логики
// никаких модификаций объектов тут делать нельзя, только запросы к БД и расчеты

#Region ENTRY_POINTS

Procedure EntryPoint(EntryPointName, Parameters) Export
	InitCache(Parameters, EntryPointName);
	Chain = GetChain();
	Parameters.ControllerModule.EnableChainLinks(EntryPointName, Parameters, Chain);
	ExecuteChain(Parameters, Chain);
	
	// проверяем что кэш был инициализирован из этой EntryPoint
	// и если это так и мы дошли до конца процедуры то значит что ChainComplete 
	If Parameters.EntryPointName = EntryPointName Then
		Parameters.ControllerModule.OnChainComplete(Parameters);
	EndIf;
EndProcedure

Procedure Init_API(EntryPointName, Parameters) Export
	InitCache(Parameters, EntryPointName);
EndProcedure

#EndRegion

#Region Chain

Function GetChain()
	StrChainLinks = "LegalName, Agreement, Company, PriceType, Price, Calculations";
	Chain = New Structure();
	Segments = StrSplit(StrChainLinks, ",");
	For Each Segment In Segments Do
		Chain.Insert(TrimAll(Segment), GetChainLink());
	EndDo;
	Return Chain;
EndFunction

Function RouteExecutor(Name, Options)
	If    Name = "LegalName"    Then Return LegalNameExecute(Options);
	ElsIf Name = "Agreement"    Then Return AgreementExecute(Options);
	ElsIf Name = "Company"      Then Return CompanyExecute(Options);
	ElsIf Name = "PriceType"    Then Return PriceTypeExecute(Options);
	ElsIf Name = "Price"        Then Return PriceExecute(Options);
	ElsIf Name = "Calculations" Then Return CalculationsExecute(Options);
	Else Raise StrTemplate("Route executor error [%1]", Name); EndIf;
EndFunction

Procedure RouteSetter(Name, Parameters, Results)
	If    Name = "LegalName"    Then Parameters.ControllerModule.SetLegalName(Parameters, Results);
	ElsIf Name = "Agreement"    Then Parameters.ControllerModule.SetAgreement(Parameters, Results);
	ElsIf Name = "Company"      Then Parameters.ControllerModule.SetCompany(Parameters, Results);
	ElsIf Name = "PriceType"    Then Parameters.ControllerModule.SetPriceType(Parameters, Results);
	ElsIf Name = "Price"        Then Parameters.ControllerModule.SetPrice(Parameters, Results);
	ElsIf Name = "Calculations" Then Parameters.ControllerModule.SetCalculations(Parameters, Results);
	Else Raise StrTemplate("Route setter error [%1]", Name); EndIf;
EndProcedure

Function GetChainLink()
	ChainLink = New Structure();
	ChainLink.Insert("Enable", False);
	ChainLink.Insert("Options", New Array());
	Return ChainLink; 
EndFunction

Function GetChainLinkOptions(StrOptions)
	Options = New Structure();
	Options.Insert("Key");
	Segments = StrSplit(StrOptions, ",");
	For Each Segment In Segments Do
		If ValueIsFilled(Segment) Then
			Options.Insert(TrimAll(Segment));
		EndIf;
	EndDo;
	Return Options;
EndFunction

Function GetChainLinkResult(Options, Value)
	Result = New Structure();
	Result.Insert("Value"   , Value);
	Result.Insert("Options" , Options);
	Return Result;
EndFunction

Procedure ExecuteChain(Parameters, Chain)
	For Each ChainLink in Chain Do
		Name = ChainLink.Key;
		If Chain[Name].Enable Then
			Results = New Array();
			For Each Options In Chain[Name].Options Do
				Results.Add(GetChainLinkResult(Options, RouteExecutor(Name, Options)));
			EndDo;
			RouteSetter(Name, Parameters, Results);
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region LEGAL_NAME

Function LegalNameOptions() Export
	Return GetChainLinkOptions("Partner, LegalName");
EndFunction

Function LegalNameExecute(Options)
	Return DocumentsServer.GetLegalNameByPartner(Options.Partner, Options.LegalName);
EndFunction

#EndRegion

#Region AGREEMENT

Function AgreementOptions() Export
	Return GetChainLinkOptions("Partner, Agreement, CurrentDate, AgreementType");
EndFunction

Function AgreementExecute(Options)
	Return DocumentsServer.GetAgreementByPartner(Options);
EndFunction

#EndRegion

#Region COMPANY

Function CompanyOptions() Export
	Return GetChainLinkOptions("Agreement");
EndFunction

Function CompanyExecute(Options)
	Return CatAgreementsServer.GetAgreementInfo(Options.Agreement).Company;
EndFunction

#EndRegion

#Region PRICE_TYPE

Function PriceTypeOptions() Export
	Return GetChainLinkOptions("Agreement");
EndFunction

Function PriceTypeExecute(Options)
	Return CatAgreementsServer.GetAgreementInfo(Options.Agreement).PriceType;
EndFunction

#EndRegion

#Region PRICE

Function PriceOptions() Export
	Return GetChainLinkOptions("Ref, Date, PriceType, ItemKey, Unit");
EndFunction

Function PriceExecute(Options)
	Period = CalculationStringsClientServer.GetSliceLastDateByRefAndDate(Options.Ref, Options.Date);
	PriceParameters = New Structure();
	PriceParameters.Insert("Period"       , Period);
	PriceParameters.Insert("PriceType"    , PredefinedValue("Catalog.PriceTypes.ManualPriceType"));
	PriceParameters.Insert("RowPriceType" , Options.PriceType);
	PriceParameters.Insert("ItemKey"      , Options.ItemKey);
	PriceParameters.Insert("Unit"         , Options.Unit);
	PriceInfo = GetItemInfo.ItemPriceInfo(PriceParameters);
	Return ?(PriceInfo = Undefined, 0, PriceInfo.Price);
EndFunction

#EndRegion

Function CalculationsOptions() Export
	Options = GetChainLinkOptions("");
	
	AmountOptions = New Structure();
	AmountOptions.Insert("DontCalculateRow", False);
	AmountOptions.Insert("NetAmount"       , 0);
	AmountOptions.Insert("OffersAmount"    , 0);
	AmountOptions.Insert("TaxAmount"       , 0);
	AmountOptions.Insert("TotalAmount"     , 0);
	Options.Insert("AmountOptions", AmountOptions);
	
	PriceOptions = New Structure("PriceType, Price, Quantity, QuantityInBaseUnit");
	Options.Insert("PriceOptions", PriceOptions);
	
	TaxOptions = New Structure("ItemKey, PriceIncludeTax");
	// TaxList columns: Key, Tax, Analytics, TaxRate, Amount, IncludeToTotalAmount, ManualAmount
	// CalculationsOptions_TaxOptions_TaxList
	TaxOptions.Insert("TaxList", New Array());
	Options.Insert("TaxOptions", TaxOptions);
	
	Options.Insert("CalculateTotalAmount"            , New Structure("Enable", False));
	Options.Insert("CalculateTotalAmountByNetAmount" , New Structure("Enable", False));
	
	Options.Insert("CalculateNetAmount"                            , New Structure("Enable", False));
	Options.Insert("CalculateNetAmountByTotalAmount"               , New Structure("Enable", False));
	Options.Insert("CalculateNetAmountAsTotalAmountMinusTaxAmount" , New Structure("Enable", False));
	
	Options.Insert("CalculateTaxAmount"              , New Structure("Enable", False));
	Options.Insert("CalculateTaxAmountByNetAmount"   , New Structure("Enable", False));
	Options.Insert("CalculateTaxAmountByTotalAmount" , New Structure("Enable", False));
	
	Return Options;
EndFunction

Function CalculationsOptions_TaxOptions_TaxList() Export
	Return New Structure("Key, Tax, Analytics, TaxRate, Amount, IncludeToTotalAmount, ManualAmount");
EndFunction

Function CalculationsExecute(Options)
//Procedure CalculateItemsRow(Object, ItemRow, Actions, ArrayOfTaxInfo = Undefined, AddInfo = Undefined) Export
	IsCalculatedRow = Not Options.AmountOptions.DontCalculateRow;
	
//	If Actions.Property("UpdateUnit") Then
//		UpdateUnit(Object, ItemRow, AddInfo);
//	EndIf;

//	If Actions.Property("UpdateRowUnit") Then
//		UpdateRowUnit(Object, ItemRow, AddInfo);
//	EndIf;

//	If Actions.Property("CalculateQuantityInBaseUnit") Then
//		CalculateQuantityInBaseUnit(Object, ItemRow, AddInfo);
//	EndIf;

//	If Actions.Property("ChangePriceType") Then
//		ChangePriceType(Object, ItemRow, Actions.ChangePriceType, AddInfo);
//	EndIf;

//	If Actions.Property("UpdatePrice") Then //
//		UpdatePrice(Object, ItemRow, Actions.UpdatePrice, AddInfo);
//	EndIf;

//	If Actions.Property("RecalculateAppliedOffers") Then
//		RecalculateAppliedOffers(Object, ItemRow, AddInfo);
//	EndIf;

//	If Actions.Property("CalculateSpecialOffers") Then //
//		CalculateSpecialOffers(Object, ItemRow, AddInfo);
//	EndIf;
	
	
	
	
	Result = New Structure();
	Result.Insert("NetAmount"    , Options.AmountOptions.NetAmount);
	Result.Insert("OffersAmount" , Options.AmountOptions.OffersAmount);
	Result.Insert("TaxAmount"    , Options.AmountOptions.TaxAmount);
	Result.Insert("TotalAmount"  , Options.AmountOptions.TotalAmount);
	
	If Options.TaxOptions.PriceIncludeTax <> Undefined Then
		If Options.TaxOptions.PriceIncludeTax Then
			If Options.CalculateTotalAmount.Enable And IsCalculatedRow Then
				Result.TotalAmount = CalculateTotalAmount_PriceIncludeTax(Options.PriceOptions, Result);
			EndIf;

			If Options.CalculateTaxAmount.Enable And IsCalculatedRow Then
				//CalculateTax_PriceIncludeTax(Object, ItemRow, ArrayOfTaxInfo, AddInfo);
			EndIf;

			If Options.CalculateNetAmountAsTotalAmountMinusTaxAmount.Enable And IsCalculatedRow Then
				Result.NetAmount = CalculateNetAmount_PriceIncludeTax(Options.PriceOptions, Result);
			EndIf;

			If Options.CalculateNetAmount.Enable And IsCalculatedRow Then
				Result.NetAmount = CalculateNetAmount_PriceIncludeTax(Options.PriceOptions, Result);
			EndIf;
		Else
			If Options.CalculateNetAmountAsTotalAmountMinusTaxAmount.Enable And IsCalculatedRow Then
				Result.NetAmount = CalculateNetAmountAsTotalAmountMinusTaxAmount_PriceNotIncludeTax(Options.PriceOptions, Result);
			EndIf;

			If Options.CalculateNetAmount.Enable And IsCalculatedRow Then
				Result.NetAmount = CalculateNetAmount_PriceNotIncludeTax(Options.PriceOptions, Result);
			EndIf;

			If Options.CalculateTaxAmount.Enable And IsCalculatedRow Then
				//CalculateTax_PriceNotIncludeTax(Object, ItemRow, ArrayOfTaxInfo, AddInfo);
			EndIf;

			If Options.CalculateTotalAmount.Enable And IsCalculatedRow Then
				Result.TotalAmount = CalculateTotalAmount_PriceNotIncludeTax(Options.PriceOptions, Result);
			EndIf;
		EndIf;
	Else
		If Options.CalculateTaxAmount.Enable And IsCalculatedRow Then
			//CalculateTaxManualPriority(Object, ItemRow, False, ArrayOfTaxInfo, False, AddInfo);
		EndIf;

		If Options.CalculateTotalAmount.Enable And IsCalculatedRow Then
			Result.TotalAmount = CalculateTotalAmount_PriceNotIncludeTax(Options.PriceOptions, Result);
		EndIf;

		If Options.CalculateTaxAmountByNetAmount.Enable And IsCalculatedRow Then
			//CalculateTaxManualPriority(Object, ItemRow, False, ArrayOfTaxInfo, False, AddInfo);
		EndIf;

		If Options.CalculateTaxAmountByTotalAmount.Enable And IsCalculatedRow Then
			//CalculateTaxManualPriority(Object, ItemRow, True, ArrayOfTaxInfo, False, AddInfo);
		EndIf;

		If Options.CalculateNetAmountAsTotalAmountMinusTaxAmount.Enable And IsCalculatedRow Then
			Result.NetAmount = CalculateNetAmount_PriceIncludeTax(Options.PriceOptions, Result);
		EndIf;

		If Options.CalculateNetAmountByTotalAmount.Enable And IsCalculatedRow Then
			Result.NetAmount = CalculateNetAmount_PriceIncludeTax(Options.PriceOptions, Result);
		EndIf;

		If Options.CalculateTotalAmountByNetAmount.Enable And IsCalculatedRow Then
			Result.TotalAmount = CalculateTotalAmount_PriceNotIncludeTax(Options.PriceOptions, Result);
		EndIf;
	EndIf;
//	If Actions.Property("UpdateInfoString") Then
//		UpdateInfoString(ItemRow);
//	EndIf;
//
//	If Actions.Property("UpdateInfoStringWithOffers") Then
//		UpdateInfoStringWithOffers(Object, ItemRow, AddInfo);
//	EndIf;
//
//	If Actions.Property("UpdateBarcode") Then
//		UpdateBarcode(Object, ItemRow, AddInfo);
//	EndIf;
	Return Result;
EndFunction

Function CalculateTotalAmount_PriceIncludeTax(PriceOptions, Result)
	If PriceOptions.Price <> Undefined Then
		Return _CalculateAmount(PriceOptions, Result) - Result.OffersAmount;
	Else
		Return Result.NetAmount;
	EndIf;
EndFunction

Function CalculateTotalAmount_PriceNotIncludeTax(PriceOptions, Result)
	Return Result.NetAmount + Result.TaxAmount;
EndFunction

Function CalculateNetAmount_PriceIncludeTax(PriceOptions, Result)
	If PriceOptions.Price <> Undefined Then
		Return _CalculateAmount(PriceOptions, Result) - Result.TaxAmount - Result.OffersAmount;
	Else
		Return (Result.TotalAmount - Result.TaxAmount - Result.OffersAmount);
	EndIf;
EndFunction

Function CalculateNetAmount_PriceNotIncludeTax(PriceOptions, Result)
	If PriceOptions.Price <> Undefined Then
		Return _CalculateAmount(PriceOptions, Result) - Result.OffersAmount;
	Else
		Return Result.TotalAmount;
	EndIf;
EndFunction

Function CalculateNetAmountAsTotalAmountMinusTaxAmount_PriceNotIncludeTax(PriceOptions, Result)
	Return Result.TotalAmount - Result.TaxAmount - Result.OffersAmount;
EndFunction

Function _CalculateAmount(PriceOptions, Result)
	If PriceOptions.PriceType <> Undefined And PriceOptions.QuantityInBaseUnit <> Undefined 
		And PriceOptions.PriceType = PredefinedValue("Catalog.PriceTypes.ManualPriceType") Then
		
		Return PriceOptions.Price * PriceOptions.QuantityInBaseUnit;
	ElsIf PriceOptions.Quantity <> Undefined Then
		Return PriceOptions.Price * PriceOptions.Quantity;
	EndIf;
	Return Result.TotalAmount;
EndFunction

// НЕДОПИСАНО
//
//Procedure CalculateTax_PriceIncludeTax(Object, ItemRow, ArrayOfTaxInfo, AddInfo = Undefined)
//	CalculateTax(Object, ItemRow, True, ArrayOfTaxInfo, False, AddInfo);
//EndProcedure
//
////Procedure CalculateTax(Object, ItemRow, PriceIncludeTax, ArrayOfTaxInfo, Reverse, AddInfo = Undefined)
//Procedure CalculateTax(TaxOptions, Result)
//	// ArrayOfTaxInfo
//	// - Name (column name)
//	// - Tax
//	//CachedColumns = "Key, Tax, Analytics, TaxRate, Amount, ManualAmount";
//	
//	//TaxListCache is TaxOptions.TaxList
//	//TaxListCache = DeleteRowsInDependedTable(Object, "TaxList", ItemRow.Key, CachedColumns);
//
//	CheckedColumns = "Key, Tax, Analytics, TaxRate";
//	ArrayOfCheckedColumns = StrSplit(CheckedColumns, ",");
//
//	If ArrayOfTaxInfo = Undefined Then
//		Return;
//	EndIf;
//
//	If TaxOptions.ItemKey <> Undefined And Not ValueIsFilled(TaxOptions.ItemKey) Then
//		Return;
//	EndIf;
//	//If CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "ItemKey") And Not ValueIsFilled(ItemRow.ItemKey) Then
//	//	Return;
//	//EndIf;
//
//	For Each ItemOfTaxInfo In ArrayOfTaxInfo Do
//
//		TaxTypeIsRate = True;
//		If ItemOfTaxInfo.Property("TaxTypeIsRate") Then
//			TaxTypeIsRate = ItemOfTaxInfo.TaxTypeIsRate;
//		Else
//			TaxTypeIsRate = (ItemOfTaxInfo.Type = PredefinedValue("Enum.TaxType.Rate"));
//		EndIf;
//
//		If TaxTypeIsRate And Not ValueIsFilled(ItemRow[ItemOfTaxInfo.Name]) Then
//
//			ArrayOfTaxRates = New Array();
//			If ItemOfTaxInfo.Property("ArrayOfTaxRates") Then
//				ArrayOfTaxRates = ItemOfTaxInfo.ArrayOfTaxRates;
//			Else
//
//				If CommonFunctionsClientServer.ObjectHasProperty(Object, "Agreement") Then
//					Parameters = New Structure();
//					Parameters.Insert("Date", Object.Date);
//					Parameters.Insert("Company", Object.Company);
//					Parameters.Insert("Tax", ItemOfTaxInfo.Tax);
//					Parameters.Insert("Agreement", Object.Agreement);
//					ArrayOfTaxRates = TaxesServer.GetTaxRatesForAgreement(Parameters);
//				EndIf;
//
//				If Not ArrayOfTaxRates.Count() Then
//					Parameters = New Structure();
//					Parameters.Insert("Date", Object.Date);
//					Parameters.Insert("Company", Object.Company);
//					Parameters.Insert("Tax", ItemOfTaxInfo.Tax);
//
//					If CommonFunctionsClientServer.ObjectHasProperty(ItemRow, "ItemKey") Then
//						Parameters.Insert("ItemKey", ItemRow.ItemKey);
//					Else
//						Parameters.Insert("ItemKey", PredefinedValue("Catalog.ItemKeys.EmptyRef"));
//					EndIf;
//
//					ArrayOfTaxRates = TaxesServer.GetTaxRatesForItemKey(Parameters);
//				EndIf;
//			EndIf;
//			If ArrayOfTaxRates.Count() Then
//				ItemRow[ItemOfTaxInfo.Name] = ArrayOfTaxRates[0].TaxRate;
//			EndIf;
//		EndIf;
//
//		TaxParameters = GetTaxCalculationParameters(Object, ItemRow, ItemOfTaxInfo, PriceIncludeTax, Reverse, AddInfo);
//
//		ArrayOfResultsTaxCalculation = TaxesServer.CalculateTax(TaxParameters);
//
//		For Each RowOfResult In ArrayOfResultsTaxCalculation Do
//			NewTax = Object.TaxList.Add();
//			NewTax.Key = ItemRow.Key;
//			NewTax.Tax = RowOfResult.Tax;
//			NewTax.Analytics = RowOfResult.Analytics;
//			NewTax.TaxRate = RowOfResult.TaxRate;
//			NewTax.Amount = RowOfResult.Amount;
//			NewTax.IncludeToTotalAmount = RowOfResult.IncludeToTotalAmount;
//
//			CachedRow = FindRowInCache(TaxListCache, NewTax, ArrayOfCheckedColumns);
//
//			If CachedRow = Undefined Then
//				NewTax.ManualAmount = NewTax.Amount;
//			Else
//				NewTax.ManualAmount = ?(CachedRow.Amount = NewTax.Amount, CachedRow.ManualAmount, NewTax.Amount);
//			EndIf;
//		EndDo;
//	EndDo;
//
//	ItemRow.TaxAmount = GetTotalAmountByDependedTable(Object, "TaxList", ItemRow.Key);
//EndProcedure
//
//Function DeleteRowsInDependedTable(Object, DependedTableName, MainTableKey, CachedColumns = Undefined)
//	DependedRows = Object[DependedTableName].FindRows(New Structure("Key", MainTableKey));
//	Cache = New Array();
//	ArrayOfCachedColumns = StrSplit(CachedColumns, ",");
//	For Each Row In DependedRows Do
//		CacheRow = New Structure();
//		For Each ItemOfCachedColumns In ArrayOfCachedColumns Do
//			CacheRow.Insert(TrimAll(ItemOfCachedColumns), Row[TrimAll(ItemOfCachedColumns)]);
//		EndDo;
//		Cache.Add(CacheRow);
//		Object[DependedTableName].Delete(Row);
//	EndDo;
//	Return Cache;
//EndFunction

// все измененные данные хранятся в кэше, для возможности откатить изменения, если пользователь откажется от изменений
// кэш инициализируется только один раз внезависимости от того какой именно EntryPoint использован
Procedure InitCache(Parameters, EntryPointName) Export
	If Not Parameters.Property("Cache") Then
		Parameters.Insert("Cache", New Structure());
		Parameters.Insert("EntryPointName", EntryPointName);
		Parameters.Insert("ViewNotify"    , New Array());
	EndIf;
EndProcedure
