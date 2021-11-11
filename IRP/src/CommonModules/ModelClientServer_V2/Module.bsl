
// MODEL
// 
// ОБЩИЙ МОДУЛЬ ДЛЯ ВСЕХ ДОКУМЕНТОВ - уровень бизнес логики
// никаких модификаций объектов тут делать нельзя, только запросы к БД и расчеты

#Region ENTRY_POINTS

Procedure EntryPoint(StepsEnablerName, Parameters) Export
	InitEntryPoint(StepsEnablerName, Parameters);
	Parameters.ModelInveronment.StepsEnablerNameCounter.Add(StepsEnablerName);
	
#IF Client THEN
	Transfer = New Structure("Form, Object", Parameters.Form, Parameters.Object);
	If ValueIsFilled(Parameters.FormPropertyNamesBeforeChange) Then
		// превращаем форму в структуру, что бы на сервере были доступны реквизиты формы, из них нужно читать данные
		TransferForm = New Structure(Parameters.FormPropertyNamesBeforeChange);
		FillPropertyValues(TransferForm, Transfer.Form);
		Parameters.Form = TransferForm;
	Else
		Parameters.Form = Undefined;
	EndIf;
	
//	UnloadControllerModule(Parameters);
//	UnloadViewModule(Parameters);
#ENDIF

	ModelServer_V2.ServerEntryPoint(StepsEnablerName, Parameters);
	
#IF Client THEN
	Parameters.Form   = Transfer.Form;
	Parameters.Object = Transfer.Object;
//	LoadControllerModule(Parameters);
//	LoadViewModule(Parameters);
#ENDIF
	
	// проверяем что кэш был инициализирован из этой EntryPoint
	// и если это так и мы дошли до конца процедуры то значит что ChainComplete 
	If Parameters.ModelInveronment.FirstStepsEnablerName = StepsEnablerName Then
		Execute StrTemplate("%1.OnChainComplete(Parameters);", Parameters.ControllerModuleName);
		DestroyEntryPoint(Parameters);
	EndIf;
EndProcedure

Procedure ServerEntryPoint(StepsEnablerName, Parameters) Export
	//LoadControllerModule(Parameters);	
	Chain = GetChain();
	Execute StrTemplate("%1.%2(Parameters, Chain);", Parameters.ControllerModuleName, StepsEnablerName);
	ExecuteChain(Parameters, Chain);
	
	//If Parameters.ModelInveronment.FirstStepsEnablerName = StepsEnablerName Then
		//DestroyEntryPoint(Parameters);
		//UnloadControllerModule(Parameters);
	//EndIf;	
EndProcedure

#EndRegion

#Region Chain

Function GetChainLink(ExecutorName)
	ChainLink = New Structure();
	ChainLink.Insert("Enable" , False);
	ChainLink.Insert("Options", New Array());
	ChainLink.Insert("Setter" , Undefined);
	ChainLink.Insert("ExecutorName", ExecutorName);
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
				Result = Undefined;
				Execute StrTemplate("Result = %1(Options)", Chain[Name].ExecutorName);
				Results.Add(GetChainLinkResult(Options, Result));
			EndDo;
			Execute StrTemplate("%1.%2(Parameters, Results);", Parameters.ControllerModuleName, Chain[Name].Setter);
		EndIf;
	EndDo;
EndProcedure

Function GetChain()
	Chain = New Structure();
	// Default.List
	Chain.Insert("DefaultStoreInList"    , GetChainLink("DefaultStoreInListExecute"));
	Chain.Insert("DefaultQuantityInList" , GetChainLink("DefaultQuantityInListExecute"));
	
	// Default.Header
	Chain.Insert("DefaultStoreInHeader", GetChainLink("DefaultStoreInHeaderExecute"));
		
	// Changes
	Chain.Insert("ChangeManagerSegmentByPartner", GetChainLink("ChangeManagerSegmentByPartnerExecute"));
	Chain.Insert("ChangeLegalNameByPartner"     , GetChainLink("ChangeLegalNameByPartnerExecute"));
	Chain.Insert("Agreement"        , GetChainLink("AgreementExecute"));
	Chain.Insert("Company"          , GetChainLink("CompanyExecute"));
	Chain.Insert("ChangeItemKeyByItem"    , GetChainLink("ChangeItemKeyByItemExecute"));
	Chain.Insert("ChangeUnitByItemKey"    , GetChainLink("ChangeUnitByItemKeyExecute"));
	Chain.Insert("ChangeCurrencyByAccount", GetChainLink("ChangeCurrencyByAccountExecute"));
	Chain.Insert("FillStoresInList" , GetChainLink("FillStoresInListExecute"));
	Chain.Insert("ChangeStoreInHeaderByStoresInList"    , GetChainLink("ChangeStoreInHeaderByStoresInListExecute"));
	Chain.Insert("ChangeUseShipmentConfirmationByStore" , GetChainLink("ChangeUseShipmentConfirmationByStoreExecute"));
	Chain.Insert("ChangeUseGoodsReceiptByStore"         , GetChainLink("ChangeUseGoodsReceiptByStoreExecute"));
	Chain.Insert("PriceType"        , GetChainLink("PriceTypeExecute"));
	Chain.Insert("PriceTypeAsManual", GetChainLink("PriceTypeAsManualExecute"));
	Chain.Insert("Price"            , GetChainLink("PriceExecute"));
	Chain.Insert("Calculations"     , GetChainLink("CalculationsExecute"));
	Return Chain;
EndFunction

#EndRegion

#Region ITEM_ITEMKEY_UNIT_QUANTITYINBASEUNIT

// При изменении Item изменяется ItemKey при изменении ItemKey изменяется Unit который может изменить QuantityInBaseUnit
// этот код может применятся во всех документах где есть Item, ItemKey, Unit, QuantityInBaseUnit, Quantity

Function DefaultQuantityInListOptions() Export
	Return GetChainLinkOptions("CurrentQuantity");
EndFunction

Function DefaultQuantityInListExecute(Options) Export
	Return ?(ValueIsFilled(Options.CurrentQuantity), Options.CurrentQuantity, 1);
EndFunction

// Параметры которые нужны для вычисления ItemKey
Function ChangeItemKeyByItemOptions() Export
	Return GetChainLinkOptions("Item");
EndFunction

// Возвращает ItemKey по Item который передан в параметре Options.Item
Function ChangeItemKeyByItemExecute(Options) Export
	If Not ValueIsFilled(Options.Item) Then
		// когда Item не заполнен ItemKey тоже будет пустым
		Return Undefined;
	EndIf;
	Return CatItemsServer.GetItemKeyByItem(Options.Item);
EndFunction

// Для вычисления Unit нужен только ItemKey
Function ChangeUnitByItemKeyOptions() Export
	Return GetChainLinkOptions("ItemKey");
EndFunction

// Возвращает Unit по ItemKey который передан в параметре Options.ItemKey
Function ChangeUnitByItemKeyExecute(Options) Export
	// вычисление Unit возлагаем на функцию ItemUnitInfo() вся логика получения Unit в ней
	If Not ValueIsFilled(Options.ItemKey) Then
		Return Undefined;
	EndIf;
	UnitInfo = GetItemInfo.ItemUnitInfo(Options.ItemKey);
	Return UnitInfo.Unit;
EndFunction

#EndRegion

#Region CHANGE_CURRENCY_BY_ACCOUNT

// Параметры которые нужны для вычисления Currency, в этом случае достаточно только Account
// если в Account не будет указана Currency то останется CurrentCurrency (та что уже указана в документе)
Function ChangeCurrencyByAccountOptions() Export
	Return GetChainLinkOptions("Account, CurrentCurrency");
EndFunction

// Возвращает Currency которая указана в Account
// если в Account пусто возвращает Currency которая уже указана в документе (параметр CurrentCurrency)
Function ChangeCurrencyByAccountExecute(Options) Export
	Currency = ServiceSystemServer.GetObjectAttribute(Options.Account, "Currency");
	If ValueIsFilled(Currency) Then
		Return Currency;
	EndIf;
	Return Options.CurrentCurrency;
EndFunction

#EndRegion

#Region CHANGE_MANAGER_SEGMENT_BY_PARTNER

Function ChangeManagerSegmentByPartnerOptions() Export
	Return GetChainLinkOptions("Partner");
EndFunction

Function ChangeManagerSegmentByPartnerExecute(Options) Export
	Return DocumentsServer.GetManagerSegmentByPartner(Options.Partner);
EndFunction

#EndRegion

#Region LEGAL_NAME

Function ChangeLegalNameByPartnerOptions() Export
	Return GetChainLinkOptions("Partner, LegalName");
EndFunction

Function ChangeLegalNameByPartnerExecute(Options) Export
	Return DocumentsServer.GetLegalNameByPartner(Options.Partner, Options.LegalName);
EndFunction

#EndRegion

#Region AGREEMENT

Function AgreementOptions() Export
	Return GetChainLinkOptions("Partner, Agreement, CurrentDate, AgreementType");
EndFunction

Function AgreementExecute(Options) Export
	Return DocumentsServer.GetAgreementByPartner(Options);
EndFunction

#EndRegion

#Region COMPANY

Function CompanyOptions() Export
	Return GetChainLinkOptions("Agreement, Company");
EndFunction

Function CompanyExecute(Options) Export
	If ValueIsFilled(Options.Company) Then
		Return Options.Company;
	Else
		Return CatAgreementsServer.GetAgreementInfo(Options.Agreement).Company;
	EndIf;
EndFunction

#EndRegion

#Region PRICE_TYPE

Function PriceTypeOptions() Export
	Return GetChainLinkOptions("Agreement");
EndFunction

Function PriceTypeExecute(Options) Export
	Return CatAgreementsServer.GetAgreementInfo(Options.Agreement).PriceType;
EndFunction

Function PriceTypeAsManualOptions() Export
	Return GetChainLinkOptions("IsUserChange, IsTotalAmountChange, CurrentPriceType");
EndFunction

Function PriceTypeAsManualExecute(Options) Export
	If Options.IsUserChange = True Or Options.IsTotalAmountChange = True Then
		Return PredefinedValue("Catalog.PriceTypes.ManualPriceType");
	Else
		Return Options.CurrentPriceType;
	EndIf;
EndFunction

#EndRegion

#Region PRICE

Function PriceOptions() Export
	Return GetChainLinkOptions("Ref, Date, PriceType, CurrentPrice, ItemKey, Unit");
EndFunction

Function PriceExecute(Options) Export
	If Options.PriceType = PredefinedValue("Catalog.PriceTypes.ManualPriceType") Then
		Return Options.CurrentPrice;
	EndIf;
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

#Region STORE

Function DefaultStoreInHeaderOptions() Export
	Return GetChainLinkOptions("DocumentRef, ArrayOfStoresInList, Agreement");
EndFunction

// Заполняет склад в шапке по умолчанию
Function DefaultStoreInHeaderExecute(Options) Export
	ArrayOfStoresUnique = New Array();
	For Each Store In Options.ArrayOfStoresInList Do
		If ValueIsFilled(Store) And ArrayOfStoresUnique.Find(Store) = Undefined Then
			ArrayOfStoresUnique.Add(Store);
		EndIf;
	EndDo;
	If ArrayOfStoresUnique.Count() = 1 Then
		Return ArrayOfStoresUnique[0]; // В табличной части указан один склад
	ElsIf ArrayOfStoresUnique.Count() > 1 Then
		Return Undefined; // В табличной части указаны несколько складов
	EndIf;
	
	// когда табличная часть пустая склад заполняется из Agreement или из UserSettings
	
	If ValueIsFilled(Options.Agreement) Then
		StoreInAgreement = Options.Agreement.Store;
		If ValueIsFilled(StoreInAgreement) Then
			Return StoreInAgreement; // Склад указанный в Agreement
		EndIf;
	EndIf;
	
	UserSettings = UserSettingsServer.GetUserSettingsForClientModule(Options.DocumentRef);
	For Each Setting In UserSettings Do
		If Setting.AttributeName = "ItemList.Store" Then
			Return Setting.Value; // Склад указанный в настройках пользователя
		EndIf;
	EndDo;
	
	Return Undefined;
EndFunction

Function DefaultStoreInListOptions() Export
	Return GetChainLinkOptions("StoreFromUserSettings, StoreInList, StoreInHeader, Agreement");
EndFunction

// Заполняет склад в табличной части по умолчанию
Function DefaultStoreInListExecute(Options) Export
	If ValueIsFilled(Options.StoreInList) Then
		Return Options.StoreInList; // Склад уже заполнен
	EndIf;
	
	If ValueIsFilled(Options.StoreInHeader) Then
		Return Options.StoreInHeader; // Склад указанный в шапке документа
	EndIf;
	
	If ValueIsFilled(Options.Agreement) Then
		StoreInAgreement = Options.Agreement.Store;
		If ValueIsFilled(StoreInAgreement) Then
			Return StoreInAgreement; // Склад указанный в Agreement
		EndIf;
	EndIf;
	
	Return Options.StoreFromUserSettings; // Склад указанный в настройках пользователя
EndFunction

Function ChangeUseShipmentConfirmationByStoreOptions() Export
	Return GetChainLinkOptions("Store, ItemKey");
EndFunction

Function ChangeUseGoodsReceiptByStoreOptions() Export
	Return GetChainLinkOptions("Store, ItemKey");
EndFunction

// устанавливает значение true\false в UseShipmentConfirmation, значение берется из склада 
Function ChangeUseShipmentConfirmationByStoreExecute(Options) Export
	Return ChangeOrderSchemeByStore(Options, "UseShipmentConfirmation");
EndFunction

// устанавливает значение true\false в UseGoodsReceipt, значение берется из склада
Function ChangeUseGoodsReceiptByStoreExecute(Options) Export
	Return ChangeOrderSchemeByStore(Options, "UseGoodsReceipt");
EndFunction

Function ChangeOrderSchemeByStore(Options, ReceiptShipment)
	If Not ValueIsFilled(Options.Store) Then
		Return False;
	EndIf;
	StoreInfo = DocumentsServer.GetStoreInfo(Options.Store, Options.ItemKey);
	If ValueIsFilled(Options.ItemKey) Then
		Return Not StoreInfo.IsService And StoreInfo[ReceiptShipment];
	EndIf;
	Return StoreInfo[ReceiptShipment];
EndFunction

Function FillStoresInListOptions() Export
	Return GetChainLinkOptions("Store, StoreInList, IsUserChange");
EndFunction

// заполняет Store в табличной части, тем Store что передан в параметре если переданный склад заполнен
// если не заполнен то оставляет тот склад что указан в табличной части
Function FillStoresInListExecute(Options) Export
	If Options.IsUserChange = True Then
		Return Options.Store;
	EndIf;
	If ValueIsFilled(Options.Store) Then
		Return Options.Store;
	EndIf;
	Return Options.StoreInList;
EndFunction

Function ChangeStoreInHeaderByStoresInListOptions() Export
	Return GetChainLinkOptions("ArrayOfStoresInList");
EndFunction

Function ChangeStoreInHeaderByStoresInListExecute(Options) Export
	// сделаем массив с кладов только с уникальными значениями
	ArrayOfStoresUnique = New Array();
	For Each Store In Options.ArrayOfStoresInList Do
		//If ValueIsFilled(Store) And ArrayOfStoresUnique.Find(Store) = Undefined Then
		If ArrayOfStoresUnique.Find(Store) = Undefined Then
			ArrayOfStoresUnique.Add(Store);
		EndIf;
	EndDo;
	If ArrayOfStoresUnique.Count() = 1 Then
		Return ArrayOfStoresUnique[0];
	Else
		Return Undefined;
	EndIf;
EndFunction

#EndRegion

#Region CALCULATIONS

Function CalculationsOptions() Export
	Options = GetChainLinkOptions("Ref");
	
	AmountOptions = New Structure();
	AmountOptions.Insert("DontCalculateRow", False);
	AmountOptions.Insert("NetAmount"       , 0);
	AmountOptions.Insert("OffersAmount"    , 0);
	AmountOptions.Insert("TaxAmount"       , 0);
	AmountOptions.Insert("TotalAmount"     , 0);
	Options.Insert("AmountOptions", AmountOptions);
	
	PriceOptions = New Structure("PriceType, Price, Quantity, QuantityInBaseUnit");
	Options.Insert("PriceOptions", PriceOptions);
	
	// TaxList columns: Key, Tax, Analytics, TaxRate, Amount, IncludeToTotalAmount, ManualAmount
	TaxOptions = New Structure("ItemKey, PriceIncludeTax, ArrayOfTaxInfo, TaxRates");
	TaxOptions.Insert("TaxList", New Array());
	Options.Insert("TaxOptions", TaxOptions);
	
	QuantityOptions = New Structure("ItemKey, Unit, Quantity, QuantityInBaseUnit");
	Options.Insert("QuantityOptions", QuantityOptions);
	
	Options.Insert("CalculateTotalAmount"            , New Structure("Enable", False));
	Options.Insert("CalculateTotalAmountByNetAmount" , New Structure("Enable", False));
	
	Options.Insert("CalculateNetAmount"                            , New Structure("Enable", False));
	Options.Insert("CalculateNetAmountByTotalAmount"               , New Structure("Enable", False));
	Options.Insert("CalculateNetAmountAsTotalAmountMinusTaxAmount" , New Structure("Enable", False));
	
	Options.Insert("CalculateTaxAmount"              , New Structure("Enable", False));
	Options.Insert("CalculateTaxAmountByNetAmount"   , New Structure("Enable", False));
	Options.Insert("CalculateTaxAmountByTotalAmount" , New Structure("Enable", False));
	
	Options.Insert("CalculateTaxAmountReverse"   , New Structure("Enable", False));
	Options.Insert("CalculatePriceByTotalAmount" , New Structure("Enable", False));

	Options.Insert("CalculateQuantityInBaseUnit" , New Structure("Enable", False));
	Return Options;
EndFunction

Function CalculationsOptions_TaxOptions_TaxList() Export
	Return New Structure("Key, Tax, Analytics, TaxRate, Amount, IncludeToTotalAmount, ManualAmount");
EndFunction

Function CalculationsExecute(Options) Export
	IsCalculatedRow = Not Options.AmountOptions.DontCalculateRow;
	
//	If Actions.Property("UpdateUnit") Then
//		UpdateUnit(Object, ItemRow, AddInfo);
//	EndIf;

//	If Actions.Property("UpdateRowUnit") Then
//		UpdateRowUnit(Object, ItemRow, AddInfo);
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
	Result.Insert("Price"        , Options.PriceOptions.Price);
	Result.Insert("TaxRates"     , Options.TaxOptions.TaxRates);
	Result.Insert("TaxList"      , New Array());
	Result.Insert("QuantityInBaseUnit" , Options.QuantityOptions.QuantityInBaseUnit);
	
	If Options.CalculateQuantityInBaseUnit.Enable Then
		UnitFactor = GetItemInfo.GetUnitFactor(Options.QuantityOptions.ItemKey, Options.QuantityOptions.Unit);
		Result.QuantityInBaseUnit = Options.QuantityOptions.Quantity * UnitFactor;
	EndIf;
	
	If Options.TaxOptions.PriceIncludeTax <> Undefined Then
		If Options.TaxOptions.PriceIncludeTax Then
			
			If Options.CalculateTaxAmountReverse.Enable And IsCalculatedRow Then
				CalculateTax(Options, Options.TaxOptions, Result, True, False);
			EndIf;
			
			If Options.CalculatePriceByTotalAmount.Enable And IsCalculatedRow Then
				Result.Price = ?(Options.PriceOptions.Quantity = 0, 0, 
				Result.TotalAmount / Options.PriceOptions.Quantity);  
			EndIf;
			
			If Options.CalculateTotalAmount.Enable And IsCalculatedRow Then
				Result.TotalAmount = CalculateTotalAmount_PriceIncludeTax(Options.PriceOptions, Result);
			EndIf;

			If Options.CalculateTaxAmount.Enable And IsCalculatedRow Then
				CalculateTax(Options, Options.TaxOptions, Result, False, False);
			EndIf;

			If Options.CalculateNetAmountAsTotalAmountMinusTaxAmount.Enable And IsCalculatedRow Then
				Result.NetAmount = CalculateNetAmount_PriceIncludeTax(Options.PriceOptions, Result);
			EndIf;

			If Options.CalculateNetAmount.Enable And IsCalculatedRow Then
				Result.NetAmount = CalculateNetAmount_PriceIncludeTax(Options.PriceOptions, Result);
			EndIf;
		Else
			If Options.CalculateTaxAmountReverse.Enable And IsCalculatedRow Then
				CalculateTax(Options, Options.TaxOptions, Result, True, False);
			EndIf;
			
			If Options.CalculatePriceByTotalAmount.Enable And IsCalculatedRow Then
				Result.Price = ?(Options.PriceOptions.Quantity = 0, 0, 
				(Result.TotalAmount - Result.TaxAmount) / Options.PriceOptions.Quantity);
			EndIf;
			
			If Options.CalculateNetAmountAsTotalAmountMinusTaxAmount.Enable And IsCalculatedRow Then
				Result.NetAmount = CalculateNetAmountAsTotalAmountMinusTaxAmount_PriceNotIncludeTax(Options.PriceOptions, Result);
			EndIf;

			If Options.CalculateNetAmount.Enable And IsCalculatedRow Then
				Result.NetAmount = CalculateNetAmount_PriceNotIncludeTax(Options.PriceOptions, Result);
			EndIf;

			If Options.CalculateTaxAmount.Enable And IsCalculatedRow Then
				CalculateTax(Options, Options.TaxOptions, Result, False, False);
			EndIf;

			If Options.CalculateTotalAmount.Enable And IsCalculatedRow Then
				Result.TotalAmount = CalculateTotalAmount_PriceNotIncludeTax(Options.PriceOptions, Result);
			EndIf;
		EndIf;
	Else // PriceIncludeTax = Undefined
		If Options.CalculateTaxAmountReverse.Enable And IsCalculatedRow Then
			CalculateTax(Options, Options.TaxOptions, Result, True, False);
		EndIf;
		
		If Options.CalculatePriceByTotalAmount.Enable And IsCalculatedRow Then
			Result.Price = ?(Options.PriceOptions.Quantity = 0, 0, 
			(Result.TotalAmount - Result.TaxAmount) / Options.PriceOptions.Quantity);
		EndIf;
		
		If Options.CalculateTaxAmount.Enable And IsCalculatedRow Then
			CalculateTax(Options, Options.TaxOptions, Result, False, True);
		EndIf;

		If Options.CalculateTotalAmount.Enable And IsCalculatedRow Then
			Result.TotalAmount = CalculateTotalAmount_PriceNotIncludeTax(Options.PriceOptions, Result);
		EndIf;

		If Options.CalculateTaxAmountByNetAmount.Enable And IsCalculatedRow Then
			CalculateTax(Options, Options.TaxOptions, Result, False, True);
		EndIf;

		If Options.CalculateTaxAmountByTotalAmount.Enable And IsCalculatedRow Then
			CalculateTax(Options, Options.TaxOptions, Result, False, True);
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

Procedure CalculateTax(Options, TaxOptions, Result, IsReverse, IsManualPriority)
	ArrayOfTaxInfo = TaxOptions.ArrayOfTaxInfo;
	If TaxOptions.ArrayOfTaxInfo = Undefined Then
		Return;
	EndIf;
	
	If TaxOptions.ItemKey <> Undefined And Not ValueIsFilled(TaxOptions.ItemKey) Then
		Return;
	EndIf;
	
	For Each ItemOfTaxInfo In ArrayOfTaxInfo Do
		If ItemOfTaxInfo.Type = PredefinedValue("Enum.TaxType.Rate") And Not ValueIsFilled(Result.TaxRates[ItemOfTaxInfo.Name]) Then
			DefaultTaxRate = GetDefaultTaxRate(Options, TaxOptions, ItemOfTaxInfo);
			If DefaultTaxRate = Undefined Then
				Continue;
			EndIf;
			Result.TaxRates[ItemOfTaxInfo.Name] = DefaultTaxRate;
		EndIf;
		
		TaxParameters = New Structure();
		TaxParameters.Insert("Tax"             , ItemOfTaxInfo.Tax);
		TaxParameters.Insert("TaxRateOrAmount" , Result.TaxRates[ItemOfTaxInfo.Name]);
		TaxParameters.Insert("PriceIncludeTax" , TaxOptions.PriceIncludeTax);
		TaxParameters.Insert("Key"             , Options.Key);
		TaxParameters.Insert("TotalAmount"     , Result.TotalAmount);
		TaxParameters.Insert("NetAmount"       , Result.NetAmount);
		TaxParameters.Insert("Ref"             , Options.Ref);
		TaxParameters.Insert("Reverse"         , IsReverse);
		
		ArrayOfResultsTaxCalculation = TaxesServer.CalculateTax(TaxParameters);
		
		TaxAmount = 0;
		For Each RowOfResult In ArrayOfResultsTaxCalculation Do
			NewTax = New Structure();
			NewTax.Insert("Key", Options.Key);
			NewTax.Insert("Tax", ?(ValueIsFilled(RowOfResult.Tax), 
				RowOfResult.Tax, PredefinedValue("Catalog.Taxes.EmptyRef")));
			NewTax.Insert("Analytics", ?(ValueIsFilled(RowOfResult.Analytics), 
				RowOfResult.Analytics, PredefinedValue("Catalog.TaxAnalytics.EmptyRef")));
			NewTax.Insert("TaxRate", ?(ValueIsFilled(RowOfResult.TaxRate), 
				RowOfResult.TaxRate, PredefinedValue("Catalog.TaxRates.EmptyRef")));
			NewTax.Insert("Amount", ?(ValueIsFilled(RowOfResult.Amount),
				RowOfResult.Amount, 0));
			NewTax.Insert("IncludeToTotalAmount" , ?(ValueIsFilled(RowOfResult.IncludeToTotalAmount),
				RowOfResult.IncludeToTotalAmount, False));
			
			ManualAmount = 0;
			IsRowExists = False;
			For Each RowTaxList In TaxOptions.TaxList Do
				If RowTaxList.Key = NewTax.Key
					And RowTaxList.Tax = NewTax.Tax 
					And RowTaxList.Analytics = NewTax.Analytics
					And RowTaxList.TaxRate = NewTax.TaxRate Then
					
					IsRowExists = True;
					If IsManualPriority Then
						ManualAmount = ?(RowTaxList.ManualAmount = RowTaxList.Amount, NewTax.Amount, RowTaxList.ManualAmount);
					Else
						ManualAmount = ?(RowTaxList.Amount = NewTax.Amount, RowTaxList.ManualAmount, NewTax.Amount);
					EndIf;
				EndIf;
			EndDo;
			If Not IsRowExists Then
				ManualAmount = NewTax.Amount;
			EndIf;
			
			NewTax.Insert("ManualAmount", ManualAmount);
			Result.TaxList.Add(NewTax);
			If RowOfResult.IncludeToTotalAmount Then
				TaxAmount = Round(TaxAmount + NewTax.ManualAmount, 2);
			EndIf;
		EndDo;
	EndDo;

	Result.TaxAmount = TaxAmount;
EndProcedure

Function GetDefaultTaxRate(Options, TaxOptions, ItemOfTaxInfo)
	ArrayOfTaxRates = New Array();
	If TaxOptions.Agreement <> Undefined Then
		Parameters = New Structure();
		Parameters.Insert("Date"      , TaxOptions.Date);
		Parameters.Insert("Company"   , TaxOptions.Company);
		Parameters.Insert("Tax"       , ItemOfTaxInfo.Tax);
		Parameters.Insert("Agreement" , TaxOptions.Agreement);
		ArrayOfTaxRates = TaxesServer.GetTaxRatesForAgreement(Parameters);
	EndIf;

	If Not ArrayOfTaxRates.Count() Then
		Parameters = New Structure();
		Parameters.Insert("Date"    , TaxOptions.Date);
		Parameters.Insert("Company" , TaxOptions.Company);
		Parameters.Insert("Tax"     , ItemOfTaxInfo.Tax);
		If TaxOptions.ItemKey <> Undefined Then
			Parameters.Insert("ItemKey", TaxOptions.ItemKey);
		Else
			Parameters.Insert("ItemKey", PredefinedValue("Catalog.ItemKeys.EmptyRef"));
		EndIf;
		ArrayOfTaxRates = TaxesServer.GetTaxRatesForItemKey(Parameters);
	EndIf;
	If ArrayOfTaxRates.Count() Then
		Return ArrayOfTaxRates[0].TaxRate;
	EndIf;
	Return Undefined;
EndFunction

#EndRegion

Procedure InitEntryPoint(StepsEnablerName, Parameters)
	If Not Parameters.Property("ModelInveronment") Then
		Inveronment = New Structure();
		Inveronment.Insert("FirstStepsEnablerName", StepsEnablerName);
//		Inveronment.Insert("ControllerModule", Undefined);
//		Inveronment.Insert("ViewModule", Undefined);
		Inveronment.Insert("StepsEnablerNameCounter", New Array());
		Parameters.Insert("ModelInveronment", Inveronment)
	EndIf;
//	If Not Parameters.Property("StepsEnablerName") Then
//		Parameters.Insert("StepsEnablerName"      , StepsEnablerName);
//		Parameters.Insert("ControllerModule"      , Undefined);
//		Parameters.Insert("StepsEnablerNameCounter" , New Array());
//	EndIf;
EndProcedure

Procedure DestroyEntryPoint(Parameters)
	If Parameters.Property("ModelInveronment") Then
		Parameters.Delete("ModelInveronment");
	EndIf;
//	If Parameters.Property("StepsEnablerName") Then
//		Parameters.Delete("StepsEnablerName");
//		Parameters.Delete("ControllerModule");
//		Parameters.Delete("ViewModule");
//		Parameters.Delete("StepsEnablerNameCounter");
//	EndIf;
EndProcedure

//Procedure LoadControllerModule(Parameters)
//	If Parameters.ModelInveronment.ControllerModule = Undefined Then
//		Parameters.ModelInveronment.ControllerModule = Eval(Parameters.ControllerModuleName);
//	EndIf;
//EndProcedure

//Procedure LoadViewModule(Parameters)
//	If Parameters.ModelInveronment.ViewModule = Undefined Then
//		Parameters.ModelInveronment.ViewModule = Eval(Parameters.ControllerModuleName);
//	EndIf;
//EndProcedure

//Procedure UnloadControllerModule(Parameters)
//	Parameters.ModelInveronment.ControllerModule = Undefined;
//EndProcedure

//Procedure UnloadViewModule(Parameters)
//	Parameters.ModelInveronment.ViewModule = Undefined;
//EndProcedure

Procedure Init_API(StepsEnablerName, Parameters) Export
	InitEntryPoint(StepsEnablerName, Parameters);
EndProcedure
