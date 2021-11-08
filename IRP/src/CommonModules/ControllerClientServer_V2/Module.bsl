
// CONTROLLER
// 
// ОБЩИЙ МОДУЛЬ ДЛЯ SalesInvoice и всех кто с него скопирован - уровень Данные (линковка бизнес логики со структурой документа)
// никаких запросов к БД и расчетов тут делать нельзя, модифицировать форму задавать вопросы пользователю и т.д нельзя 
// только чтение из объекта и запись в объект

#Region ACCOUNT_SENDER

// Вызывается при изменении реквизита Sender в документе CashTransferOrder
Procedure AccountSenderOnChange(Parameters) Export
	// процедура для запоминания значения реквизита перед изменением
	ProceedObjectPropertyBeforeChange(Parameters);
	
	// Процедура OnSetAccountReceiverNotify_IsUserChange будет вызывана только если пользователь изменит реквизит
	// при программом изменении вызывана не будет
	AddViewNotify("OnSetAccountSenderNotify_IsUserChange", Parameters);
	
	// Запускаем процесс изменения документа
	// Первым параметром указываем имя процедуры в которой включаем нужные шаги вычислений
	ModelClientServer_V2.EntryPoint("AccountSenderStepsEnabler", Parameters);
EndProcedure

Procedure AccountSenderStepsEnabler(Parameters, Chain) Export
	// При изменении реквизита Sender нужно изменить Currency
	Chain.ChangeCurrencyByAccount.Enable = True;
	// Указывает процедуру SetSendCurrency, в нее будет передано расчитаное значение Currency 
	Chain.ChangeCurrencyByAccount.Setter = "SetSendCurrency";
	
	// Для вычисления Currency нужно заполнить параметр Account
	// значение лежит в реквизите Sender, читать из реквизитов нужно функцией GetPropertyObject()
	Options = ModelClientServer_V2.ChangeCurrencyByAccountOptions();
	Options.Account = GetPropertyObject(Parameters, "Sender");
	// Currency которая уже указана в документе, нужна если в Account будет пустая Currency
	Options.CurrentCurrency = GetPropertyObject(Parameters, "SendCurrency");
	Chain.ChangeCurrencyByAccount.Options.Add(Options);
EndProcedure

#EndRegion

#Region CURRENCY_SENDER

// При изменении реквизита SendCurrency изменений других реквизитов объекта не происходит
// проэтому нет процедуры OnChange только SetSendCurrency, что бы можно было программно устанавливать значения

// Устанавливает значение в реквизит SendCurrency
Procedure SetSendCurrency(Parameters, Results) Export
	// Процедура OnSetSendCurrencyNotify_IsProgrammChange 
	// будет вызывана при программном изменении реквизита SendCurrency
	
	SetterObject(Undefined, "SendCurrency", Parameters, Results, "OnSetSendCurrencyNotify_IsProgrammChange");
EndProcedure

#EndRegion

#Region ACCOUNT_RECEIVER

// Вызывается при изменении реквизита Receiver в документе CashTransferOrder
Procedure AccountReceiverOnChange(Parameters) Export
	// процедура для запоминания значения реквизита перед изменением
	ProceedObjectPropertyBeforeChange(Parameters);
	
	// Процедура OnSetAccountReceiverNotify_IsUserChange будет вызывана только если пользователь изменит реквизит
	// при программом изменении вызывана не будет
	AddViewNotify("OnSetAccountReceiverNotify_IsUserChange", Parameters);
	
	// Запускаем процесс изменения документа
	// Первым параметром указываем имя процедуры в которой включаем нужные шаги вычислений
	ModelClientServer_V2.EntryPoint("AccountReceiverStepsEnabler", Parameters);
EndProcedure

Procedure AccountReceiverStepsEnabler(Parameters, Chain) Export
	// При изменении реквизита Receiver нужно изменить Currency
	Chain.ChangeCurrencyByAccount.Enable = True;
	// Указывает процедуру SetReceiveCurrency, в нее будет передано расчитаное значение Currency 
	Chain.ChangeCurrencyByAccount.Setter = "SetReceiveCurrency";
	
	// Для вычисления Currency нужно заполнить параметр Account
	// значение лежит в реквизите Receiver, читать из реквизитов нужно функцией GetPropertyObject()
	Options = ModelClientServer_V2.ChangeCurrencyByAccountOptions();
	Options.Account = GetPropertyObject(Parameters, "Receiver");
	// Currency которая уже указана в документе, нужна если в Account будет пустая Currency
	Options.CurrentCurrency = GetPropertyObject(Parameters, "ReceiveCurrency");
	Chain.ChangeCurrencyByAccount.Options.Add(Options);
EndProcedure

#EndRegion

#Region CURRENCY_RECEIVER

// При изменении реквизита ReceiveCurrency изменений других реквизитов объекта не происходит
// проэтому нет процедуры OnChange только SetReceiveCurrency, что бы можно было программно устанавливать значения

// Устанавливает значение в реквизит ReceiveCurrency
Procedure SetReceiveCurrency(Parameters, Results) Export
	// Процедура OnSetReceiveCurrencyNotify_IsProgrammChange 
	// будет вызывана при программном изменении реквизита ReceiveCurrency
	SetterObject(Undefined, "ReceiveCurrency", Parameters, Results, "OnSetReceiveCurrencyNotify_IsProgrammChange");
EndProcedure

#EndRegion

#Region PARTNER

// Client Event handler, вызывается из модуля ViewClient_V2
Procedure PartnerOnChange(Parameters) Export
	ProceedObjectPropertyBeforeChange(Parameters);
	ModelClientServer_V2.EntryPoint("PartnerStepsEnabler", Parameters);
EndProcedure

Procedure PartnerStepsEnabler(Parameters, Chain) Export
	// При изменении партнера нужно изменить LegalName
	Chain.LegalName.Enable = True;
	Chain.LegalName.Setter = "SetLegalName";
	// эти данные (параметры) нужны для получения LegalName
	LegalNameOptions = ModelClientServer_V2.LegalNameOptions();
	LegalNameOptions.Partner   = GetPropertyObject(Parameters, "Partner");
	LegalNameOptions.LegalName = GetPropertyObject(Parameters, "LegalName");;
	Chain.LegalName.Options.Add(LegalNameOptions);
	
	// При изменении партнера нужно изменить Agreement
	Chain.Agreement.Enable = True;
	Chain.Agreement.Setter = "SetAgreement";
	// эти данные (параметры) нужны для получения Agreement
	AgreementOptions = ModelClientServer_V2.AgreementOptions();
	AgreementOptions.Partner       = GetPropertyObject(Parameters, "Partner");
	AgreementOptions.Agreement     = GetPropertyObject(Parameters, "Agreement");
	AgreementOptions.CurrentDate   = GetPropertyObject(Parameters, "Date");
	AgreementOptions.AgreementType = PredefinedValue("Enum.AgreementTypes.Customer");
	Chain.Agreement.Options.Add(AgreementOptions);
	
	Chain.ChangeManagerSegmentByPartner.Enable = True;
	Chain.ChangeManagerSegmentByPartner.Setter = "SetManagerSegment";
	Options = ModelClientServer_V2.ChangeManagerSegmentByPartnerOptions();
	Options.Partner = GetPropertyObject(Parameters, "Partner");
	Chain.ChangeManagerSegmentByPartner.Options.Add(Options);
EndProcedure

Procedure SetPartner_API(Parameters, Results) Export
	ModelClientServer_V2.Init_API("PartnerStepsEnabler", Parameters);
	SetPartner(Parameters, Results);
EndProcedure

Procedure SetPartner(Parameters, Results) Export
	SetterObject("PartnerStepsEnabler", "Partner", Parameters, Results);
EndProcedure

#EndRegion

#Region LEGAL_NAME

// Client Event handler вызывается из модуля ViewClient_V2
Procedure LegalNameOnChange(Parameters) Export
	AddViewNotify("OnSetLegalNameNotify", Parameters);
	ModelClientServer_V2.EntryPoint("LegalNameStepsEnabler", Parameters);
EndProcedure

Procedure LegalNameStepsEnabler(Parameters, Chain) Export
	Return;
EndProcedure

Procedure SetLegalName(Parameters, Results) Export
	SetterObject("LegalNameStepsEnabler", "LegalName", Parameters, Results, "OnSetLegalNameNotify");
EndProcedure

#EndRegion

#Region STORE

// это реквизит формы в шапке
Procedure StoreOnChange(Parameters) Export
	ProceedFormPropertyBeforeChange(Parameters);
	AddViewNotify("OnSetStoreNotify", Parameters);
	ModelClientServer_V2.EntryPoint("StoreStepsEnabler", Parameters);
EndProcedure

Procedure StoreStepsEnabler(Parameters, Chain) Export
	Chain.FillStoresInList.Enable = True;
	Chain.FillStoresInList.Setter = "SetItemListStore";
	
	For Each Row In GetRows(Parameters, "ItemList") Do
		Options = ModelClientServer_V2.FillStoresInListOptions();
		Options.Store       = GetPropertyForm(Parameters, "Store");
		Options.StoreInList = GetPropertyObject(Parameters, "ItemList.Store", Row.Key);
		Options.Key = Row.Key;
		Chain.FillStoresInList.Options.Add(Options);
	EndDo;
EndProcedure

Procedure SetStore(Parameters, Results) Export
	SetterForm("StoreStepsEnabler", "Store", Parameters, Results, "OnSetStoreNotify");
EndProcedure

#EndRegion

#Region AGREEMENT

// Client Event handler вызывается из модуля ViewClient_V2
Procedure AgreementOnChange(Parameters) Export
	ModelClientServer_V2.EntryPoint("AgreementStepsEnabler", Parameters);
EndProcedure

Procedure AgreementStepsEnabler(Parameters, Chain) Export
	// При изменении Agreement нужно изменить Company
	Chain.Company.Enable = True;
	Chain.Company.Setter =  "SetCompany";
	
	// Эти данные (параметры) нужны для получения Company
	CompanyOptions = ModelClientServer_V2.CompanyOptions();
	CompanyOptions.Agreement = GetPropertyObject(Parameters, "Agreement");
	CompanyOptions.Company   = GetPropertyObject(Parameters, "Company");
	
	Chain.Company.Options.Add(CompanyOptions);
	
	// При изменении Agreement нужно изменить PriceType
	Chain.PriceType.Enable = True;
	Chain.PriceType.Setter = "SetItemListPriceType";
	
	// Эти данные (параметры) нужны для получения PriceType
	// PriceType находится в табличной части ItemList, така как это уровень данных то беремиз этой табличной части
	For Each Row In GetRows(Parameters, "ItemList") Do
		PriceTypeOptions = ModelClientServer_V2.PriceTypeOptions();
		PriceTypeOptions.Agreement = GetPropertyObject(Parameters, "Agreement");
		// ключ нужен что бы потом, когда вернутся результаты из модуля Model идентифицировать строку,
		// для реквизитов в шапке ключ можно не заполнять, шапка только одна
		PriceTypeOptions.Key = Row.Key;
		Chain.PriceType.Options.Add(PriceTypeOptions);
	EndDo;
EndProcedure

Procedure SetAgreement(Parameters, Results) Export
	SetterObject("AgreementStepsEnabler", "Agreement", Parameters, Results);
EndProcedure

#EndRegion

#Region MANAGER_SEGMENT

Procedure SetManagerSegment(Parameters, Results) Export
	SetterObject(Undefined, "ManagerSegment", Parameters, Results);
EndProcedure
	
#EndRegion

#Region COMPANY

Procedure CompanyStepsEnabler(Parameters, Chain) Export
	Return;
EndProcedure

Procedure SetCompany(Parameters, Results) Export
	SetterObject("CompanyStepsEnabler", "Company", Parameters, Results);
EndProcedure

#EndRegion

#Region PRICE_INCLUDE_TAX

Procedure PriceIncludeTaxOnChange(Parameters) Export
	ModelClientServer_V2.EntryPoint("PriceIncludeTaxStepsEnabler", Parameters);
EndProcedure

Procedure PriceIncludeTaxStepsEnabler(Parameters, Chain) Export
	ItemListEnableCalculations(Parameters, Chain, "IsPriceIncludeTaxChanged");
EndProcedure

#EndRegion

#Region ITEM_LIST

#Region ITEM_LIST_STORE

// Store в табличной части ItemList
Procedure ItemListStoreOnChange(Parameters) Export
	ModelClientServer_V2.EntryPoint("ItemListStoreStepsEnabler", Parameters);
EndProcedure

Procedure ItemListStoreStepsEnabler(Parameters, Chain) Export
	Chain.ChangeUseShipmentConfirmationByStore.Enable = True;
	Chain.ChangeUseShipmentConfirmationByStore.Setter = "SetItemListUseShipmentConfirmation";
	
	For Each Row In GetRows(Parameters, "ItemList") Do
		Options = ModelClientServer_V2.ChangeUseShipmentConfirmationByStoreOptions();
		Options.Store   = GetPropertyObject(Parameters, "ItemList.Store", Row.Key);
		Options.ItemKey = GetPropertyObject(Parameters, "ItemList.ItemKey", Row.Key);
		Options.Key = Row.Key;
		Chain.ChangeUseShipmentConfirmationByStore.Options.Add(Options);
	EndDo;
	
	Chain.ChangeStoreInHeaderByStoresInList.Enable = True;
	Chain.ChangeStoreInHeaderByStoresInList.Setter = "SetStore";
	
	// нужно взять все строки в табличной части ItemList
	Options = ModelClientServer_V2.ChangeStoreInHeaderByStoresInListOptions();
	ArrayOfStoresInList = New Array();
	For Each Row In Parameters.Object.ItemList Do
		ArrayOfStoresInList.Add(GetPropertyObject(Parameters, "ItemList.Store", Row.Key));
	EndDo;
	Options.ArrayOfStoresInList = ArrayOfStoresInList; 
	Chain.ChangeStoreInHeaderByStoresInList.Options.Add(Options);
EndProcedure

Procedure SetItemListStore(Parameters, Results) Export
	SetterObject("ItemListStoreStepsEnabler", "ItemList.Store", Parameters, Results);
EndProcedure

#EndRegion

#Region ITEM_LIST_USE_SHIPMENT_CONFIRMATION

Procedure SetItemListUseShipmentConfirmation(Parameters, Results) Export
	SetterObject(Undefined, "ItemList.UseShipmentConfirmation", Parameters, Results);
EndProcedure

#EndRegion

#Region ITEM_LIST_USE_GOODS_RECEIPT

Procedure SetItemListUseGoodsReceipt(Parameters, Results) Export
	SetterObject(Undefined, "ItemList.UseGoodsReceipt", Parameters, Results);
EndProcedure

#EndRegion

#Region ITEM_LIST_PRICE_TYPE

Procedure ItemListPriceTypeOnChange(Parameters) Export
	ModelClientServer_V2.EntryPoint("ItemListPriceTypeStepsEnabler", Parameters);
EndProcedure

Procedure ItemListPriceTypeStepsEnabler(Parameters, Chain) Export
	Chain.Price.Enable = True;
	Chain.Price.Setter = "SetItemListPrice";
	
	For Each Row In GetRows(Parameters, "ItemList") Do
		PriceOptions = ModelClientServer_V2.PriceOptions();
		PriceOptions.Ref          = Parameters.Object.Ref;
		PriceOptions.Date         = GetPropertyObject(Parameters, "Date");
		PriceOptions.CurrentPrice = GetPropertyObject(Parameters, "ItemList.Price", Row.Key);
		PriceOptions.PriceType    = GetPropertyObject(Parameters, "ItemList.PriceType", Row.Key);
		PriceOptions.ItemKey      = GetPropertyObject(Parameters, "ItemList.ItemKey"  , Row.Key);
		PriceOptions.Unit         = GetPropertyObject(Parameters, "ItemList.Unit"     , Row.Key);
		PriceOptions.Key          = Row.Key;
		Chain.Price.Options.Add(PriceOptions);
	EndDo;
EndProcedure

// Устанавливает PriceType в табличную часть ItemList
Procedure SetItemListPriceType(Parameters, Results) Export
	SetterObject("ItemListPriceTypeStepsEnabler", "ItemList.PriceType", Parameters, Results);
EndProcedure

#EndRegion

#Region ITEM_LIST_PRICE

Procedure ItemListPriceOnChange(Parameters) Export
	ModelClientServer_V2.EntryPoint("ItemListPriceStepsEnabler", Parameters);
EndProcedure

Procedure ItemListPriceStepsEnabler(Parameters, Chain) Export
	
	ItemListEnableCalculations(Parameters, Chain, "IsPriceChanged");
	
	Chain.PriceTypeAsManual.Enable = True;
	Chain.PriceTypeAsManual.Setter = "SetItemListPriceType";
	
	For Each Row In GetRows(Parameters, "ItemList") Do
		// при ручном изменении цены надо установить тип цен как ручной
		PriceTypeAsManualOptions = ModelClientServer_V2.PriceTypeAsManualOptions();
		// изменил пользователь напрямую
		PriceTypeAsManualOptions.IsUserChange     = IsUserChange(Parameters);
		PriceTypeAsManualOptions.CurrentPriceType = GetPropertyObject(Parameters, "ItemList.PriceType", Row.Key);
		PriceTypeAsManualOptions.Key = Row.Key;
		Chain.PriceTypeAsManual.Options.Add(PriceTypeAsManualOptions);
	EndDo;
EndProcedure

Procedure SetItemListPrice(Parameters, Results) Export
	SetterObject("ItemListPriceStepsEnabler", "ItemList.Price", Parameters, Results);
EndProcedure

#EndRegion

#Region NET_OFFERS_TAX_TOTAL_QUANTITY

Procedure ItemListEnableCalculations(Parameters, Chain, WhoIsChanged)
	Chain.Calculations.Enable = True;
	Chain.Calculations.Setter = "SetItemListCalculations";
	
	For Each Row In GetRows(Parameters, "ItemList") Do
		
		CalculationsOptions     = ModelClientServer_V2.CalculationsOptions();
		CalculationsOptions.Ref = Parameters.Object.Ref;
		
		// при изменении цены нужно пересчитать NetAmount, TotalAmount, TaxAmount, OffersAmount
		If WhoIsChanged = "IsPriceChanged" Or WhoIsChanged = "IsPriceIncludeTaxChanged" Then
			CalculationsOptions.CalculateNetAmount.Enable   = True;
			CalculationsOptions.CalculateTotalAmount.Enable = True;
			CalculationsOptions.CalculateTaxAmount.Enable   = True;
		ElsIf WhoIsChanged = "IsTotalAmountChanged" Then
		// при изменении total amount налоги расчитываются в обратную сторону, меняется Net Amount и цена
			CalculationsOptions.CalculateTaxAmountReverse.Enable   = True;
			CalculationsOptions.CalculateNetAmountAsTotalAmountMinusTaxAmount.Enable   = True;
			CalculationsOptions.CalculatePriceByTotalAmount.Enable   = True;
		ElsIf WhoIsChanged = "IsQuantityChanged" Then
			CalculationsOptions.CalculateQuantityInBaseUnit.Enable   = True;
			CalculationsOptions.CalculateNetAmount.Enable   = True;
			CalculationsOptions.CalculateTotalAmount.Enable = True;
			CalculationsOptions.CalculateTaxAmount.Enable   = True;
		EndIf;
		
		CalculationsOptions.AmountOptions.DontCalculateRow = GetPropertyObject(Parameters, "ItemList.DontCalculateRow", Row.Key);
		
		CalculationsOptions.AmountOptions.NetAmount        = GetPropertyObject(Parameters, "ItemList.NetAmount"    , Row.Key);
		CalculationsOptions.AmountOptions.OffersAmount     = GetPropertyObject(Parameters, "ItemList.OffersAmount" , Row.Key);
		CalculationsOptions.AmountOptions.TaxAmount        = GetPropertyObject(Parameters, "ItemList.TaxAmount"    , Row.Key);
		CalculationsOptions.AmountOptions.TotalAmount      = GetPropertyObject(Parameters, "ItemList.TotalAmount"  , Row.Key);
		
		CalculationsOptions.PriceOptions.Price              = GetPropertyObject(Parameters, "ItemList.Price"              , Row.Key);
		CalculationsOptions.PriceOptions.PriceType          = GetPropertyObject(Parameters, "ItemList.PriceType"          , Row.Key);
		CalculationsOptions.PriceOptions.Quantity           = GetPropertyObject(Parameters, "ItemList.Quantity"           , Row.Key);
		CalculationsOptions.PriceOptions.QuantityInBaseUnit = GetPropertyObject(Parameters, "ItemList.QuantityInBaseUnit" , Row.Key);
		
		CalculationsOptions.TaxOptions.PriceIncludeTax  = GetPropertyObject(Parameters, "PriceIncludeTax");
		CalculationsOptions.TaxOptions.ItemKey          = GetPropertyObject(Parameters, "ItemList.ItemKey", Row.Key);
		CalculationsOptions.TaxOptions.ArrayOfTaxInfo   = Parameters.ArrayOfTaxInfo;
		CalculationsOptions.TaxOptions.TaxRates         = Row.TaxRates;
		CalculationsOptions.TaxOptions.TaxList          = Row.TaxList;
		
		CalculationsOptions.QuantityOptions.ItemKey = GetPropertyObject(Parameters, "ItemList.ItemKey", Row.Key);
		CalculationsOptions.QuantityOptions.Unit    = GetPropertyObject(Parameters, "ItemList.Unit", Row.Key);
		CalculationsOptions.QuantityOptions.Quantity           = GetPropertyObject(Parameters, "ItemList.Quantity"           , Row.Key);
		CalculationsOptions.QuantityOptions.QuantityInBaseUnit = GetPropertyObject(Parameters, "ItemList.QuantityInBaseUnit" , Row.Key);
		
		CalculationsOptions.Key = Row.Key;
		
		Chain.Calculations.Options.Add(CalculationsOptions);
	EndDo;
EndProcedure

Procedure SetItemListCalculations(Parameters, Results) Export
	SetterObject(Undefined, "ItemList.NetAmount"   , Parameters, Results, , "NetAmount");
	SetterObject(Undefined, "ItemList.TaxAmount"   , Parameters, Results, , "TaxAmount");
	SetterObject(Undefined, "ItemList.OffersAmount", Parameters, Results, , "OffersAmount");
	SetterObject(Undefined, "ItemList.TotalAmount" , Parameters, Results, , "TotalAmount");
	SetterObject(Undefined, "ItemList.Price"       , Parameters, Results, , "Price");
	SetterObject(Undefined, "ItemList.QuantityInBaseUnit" , Parameters, Results, , "QuantityInBaseUnit");
	
	// табличная часть TaxList кэщируется целиком, потом так же целиком переносится в документ
	For Each Result In Results Do
		If Result.Value.TaxList.Count() Then
			If Not Parameters.Cache.Property("TaxList") Then
				Parameters.Cache.Insert("TaxList", New Array());
			EndIf;
			// удаляем из кэша старые строки
			Count = Parameters.Cache.TaxList.Count();
			For i = 1 To Count Do
				ArrayItem = Parameters.Cache.TaxList[Count - i];
				If ArrayItem.Key = Result.Options.Key Then
					Parameters.Cache.TaxList.Delete(ArrayItem);
				EndIf;
			EndDo;
			
			For Each Row In Result.Value.TaxList Do
				Parameters.Cache.TaxList.Add(Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

// в ItemList Net Amount - не меняется ReadOnly
//Procedure ItemListNetAmountOnChange(Parameters) Export
//	ModelClientServer_V2.EntryPoint("NetAmountEntryPoint", Parameters);
//EndProcedure

//Procedure NetAmountEnableChainLinks(Parameters, Chain) Export
//	Return;
//EndProcedure

Procedure ItemListTaxAmountOnChange(Parameters) Export
	ModelClientServer_V2.EntryPoint("ItemListTaxAmountStepsEnabler", Parameters);
EndProcedure

Procedure ItemListTaxAmountStepsEnabler(Parameters, Chain) Export
	Return;
EndProcedure

Procedure ItemListOffersAmountOnChange(Parameters) Export
	ModelClientServer_V2.EntryPoint("ItemListOffersAmountStepsEnabler", Parameters);
EndProcedure

Procedure ItemListOffersAmountStepsEnabler(Parameters, Chain) Export
	Return;
EndProcedure

Procedure ItemListTotalAmountOnChange(Parameters) Export
	ModelClientServer_V2.EntryPoint("ItemListTotalAmountStepsEnabler", Parameters);
EndProcedure

Procedure ItemListTotalAmountStepsEnabler(Parameters, Chain) Export
	ItemListEnableCalculations(Parameters, Chain, "IsTotalAmountChanged");
	
	// при ручном изменении Total amount меняется цена, установим ее как Manual Price
	Chain.PriceTypeAsManual.Enable = True;
	Chain.PriceTypeAsManual.Setter = "SetItemListPriceType";
	
	For Each Row In GetRows(Parameters, "ItemList") Do
		// при ручном изменении цены надо установить тип цен как ручной
		PriceTypeAsManualOptions = ModelClientServer_V2.PriceTypeAsManualOptions();
		// изменил пользователь напрямую
		PriceTypeAsManualOptions.IsTotalAmountChange = True;
		PriceTypeAsManualOptions.CurrentPriceType = GetPropertyObject(Parameters, "ItemList.PriceType", Row.Key);
		PriceTypeAsManualOptions.Key = Row.Key;
		Chain.PriceTypeAsManual.Options.Add(PriceTypeAsManualOptions);
	EndDo;
EndProcedure

#Region ITEM_LIST_QUANTITY

Procedure ItemListQuantityOnChange(Parameters) Export
	AddViewNotify("OnSetItemListQuantityNotify", Parameters);
	ModelClientServer_V2.EntryPoint("ItemListQuantityStepsEnabler", Parameters);
EndProcedure

Procedure ItemListQuantityStepsEnabler(Parameters, Chain) Export
	ItemListEnableCalculations(Parameters, Chain, "IsQuantityChanged");
EndProcedure

Procedure SetQuantity(Parameters, Results) Export
	SetterObject("ItemListQuantityStepsEnabler", "ItemList.Quantity", Parameters, Results, "OnSetItemListQuantityNotify");
EndProcedure

#EndRegion

#EndRegion

#EndRegion

// Вызывается когда вся цепочка связанных действий будет заверщена
Procedure OnChainComplete(Parameters) Export
	#IF Client THEN
		// на клиенте возможно нужно задать вопрос пользователю, поэтому сразу из кэша в объект не переносим
		If Parameters.ViewModule <> Undefined Then
			Parameters.ViewModule.OnChainComplete(Parameters);
		EndIf;
	#ENDIF
	
	#IF Server THEN
		// на сервере спрашивать некого, сразу переносим из кэша в объект
		CommitChainChanges(Parameters);
	#ENDIF
EndProcedure

Procedure CommitChainChanges(Parameters) Export
	_CommitChainChanges(Parameters.Cache, Parameters.Object);
	
	#IF Client THEN
		_CommitChainChanges(Parameters.CacheForm, Parameters.Form);
		
		// уведомление клиента о том что данные были изменены
		If Parameters.ViewNotify.Count() And Parameters.ViewModule = Undefined Then
			Raise "View module undefined";
		EndIf;
		ArrayOfViewNotify = New Array();
		For Each ViewNotify In Parameters.ViewNotify Do
			If ArrayOfViewNotify.Find(ViewNotify) = Undefined Then
				ArrayOfViewNotify.Add(ViewNotify);
				Execute StrTemplate("%1.%2(Parameters);", Parameters.ViewModuleName, ViewNotify);
			EndIf;
		EndDo;
	#ENDIF
EndProcedure

// Переносит изменения из Cache в Object из CacheForm в Fomr
Procedure _CommitChainChanges(Cache, Source)
	For Each Property In Cache Do
		If Upper(Property.Key) = Upper("TaxList") Then
			// табличная часть налогов переносится целиком
			ArrayOfKeys = New Array();
			For Each Row In Property.Value Do
				If ArrayOfKeys.Find(Row.Key) = Undefined Then
					ArrayOfKeys.Add(Row.Key);
				EndIf;
			EndDo;
			
			For Each ItemOfKeys In ArrayOfKeys Do
				For Each Row In Source.TaxList.FindRows(New Structure("Key", ItemOfKeys)) Do
					Source.TaxList.Delete(Row);
				EndDo;
			EndDo;
			
			For Each Row In Property.Value Do
				FillPropertyValues(Source.TaxList.Add(), Row);
			EndDo;
		
		// Табличные части ItemList и PaymentList переносятся построчно так как Key в строках уникален
		ElsIf TypeOf(Property.Value) = Type("Array") Then // это табличная часть
			For Each Row In Property.Value Do
				FillPropertyValues(Source[Property.Key].FindRows(New Structure("Key", Row.Key))[0], Row);
			EndDo;
		Else
			Source[Property.Key] = Property.Value; // это реквизит шапки
		EndIf;
	EndDo;
EndProcedure

Procedure ProceedObjectPropertyBeforeChange(Parameters)
	If Parameters.ObjectPropertyBeforeChange <> Undefined Then
		DataPath          = Parameters.ObjectPropertyBeforeChange.DataPath;
		ValueBeforeChange = Parameters.ObjectPropertyBeforeChange.ValueBeforeChange;
		CurrentValue      = GetPropertyObject(Parameters, DataPath);
		Parameters.Object[DataPath] = ValueBeforeChange;
		SetPropertyObject(Parameters, DataPath, , CurrentValue);
	EndIf;
EndProcedure

Procedure ProceedFormPropertyBeforeChange(Parameters)
	If Parameters.FormPropertyBeforeChange <> Undefined Then
		DataPath          = Parameters.FormPropertyBeforeChange.DataPath;
		ValueBeforeChange = Parameters.FormPropertyBeforeChange.ValueBeforeChange;
		CurrentValue      = GetPropertyForm(Parameters, DataPath);
		Parameters.Form[DataPath] = ValueBeforeChange;
		SetPropertyForm(Parameters, DataPath, , CurrentValue);
	EndIf;
EndProcedure

Function GetRows(Parameters, TableName)
	Rows = Parameters.Object[TableName];
	If Parameters.Property("Rows") Then
		// расчет только для конкретных строк, переданных в параметре
		Rows = Parameters.Rows;
	EndIf;
	Return Rows;
EndFunction

Procedure SetterForm(StepsEnablerName, DataPath, Parameters, Results, ViewNotify = Undefined, ValueDataPath = Undefined)
	Setter("Form", StepsEnablerName, DataPath, Parameters, Results, ViewNotify, ValueDataPath);
EndProcedure

Procedure SetterObject(StepsEnablerName, DataPath, Parameters, Results, ViewNotify = Undefined, ValueDataPath = Undefined)
	Setter("Object", StepsEnablerName, DataPath, Parameters, Results, ViewNotify, ValueDataPath);
EndProcedure

Procedure Setter(Source, StepsEnablerName, DataPath, Parameters, Results, ViewNotify, ValueDataPath)
	IsChanged = False;
	For Each Result In Results Do
		_Key   = Result.Options.Key;
		If ValueIsFilled(ValueDataPath) Then
			_Value = Result.Value[ValueDataPath];
		Else
			_Value = Result.Value;
		EndIf;
		If Source = "Object" And SetPropertyObject(Parameters, DataPath, _Key, _Value) Then
			IsChanged = True;
		EndIf;
		If Source = "Form" And SetPropertyForm(Parameters, DataPath, _Key, _Value) Then
			IsChanged = True;
		EndIf;
	EndDo;
	If IsChanged Then
		AddViewNotify(ViewNotify, Parameters);
		If ValueIsFilled(StepsEnablerName) Then
			ModelClientServer_V2.EntryPoint(StepsEnablerName, Parameters);
		EndIf;
	EndIf;
EndProcedure

Procedure AddViewNotify(ViewNotify, Parameters)
	If Parameters.Property("ViewNotify") And ViewNotify <> Undefined Then
		// переадресация в клиентский модуль, вызов был с клиента, на форме что то надо обновить
		// вызывать будем потом когда завершится вся цепочка действий, и изменения будут перенесены с кэша в объект
		Parameters.ViewNotify.Add(ViewNotify);
	EndIf;	
EndProcedure

Function GetPropertyForm(Parameters, DataPath, Key = Undefined)
	Return GetProperty(Parameters.CacheForm, Parameters.Form, DataPath, Key);
EndFunction

Function GetPropertyObject(Parameters, DataPath, Key = Undefined)
	Return GetProperty(Parameters.Cache, Parameters.Object, DataPath, Key);
EndFunction

// параметр Key используется когда DataPath указывает на реквизит табличной части, например ItemList.PriceType
Function GetProperty(Cache, Source, DataPath, Key)
	Segments = StrSplit(DataPath, ".");
	If Segments.Count() = 1 Then // это реквизит шапки, он указывается без точки, например Company
		If ValueIsFilled(Key) Then
			Raise StrTemplate("Key [%1] not allowed for data path [%2]", Key, DataPath);
		EndIf;
		If Cache.Property(DataPath) Then
			Return Cache[DataPath];
		Else
			Return Source[DataPath];
		EndIf;
	ElsIf Segments.Count() = 2 Then // это реквизит табличной части, состоит из двух частей разделенных точкой ItemList.PriceType
		TableName = Segments[0];
		ColumnName = Segments[1];
		
		RowByKey = Undefined;
		If Cache.Property(TableName) Then
			For Each Row In Cache[TableName] Do
				If Not Row.Property(ColumnName) Then
					Continue;
				EndIf;
				If Row.Key = Key Then
					RowByKey = Row;
				EndIf;
			EndDo;
		EndIf;
		If RowByKey = Undefined Then
			RowByKey = Source[TableName].FindRows(New Structure("Key", Key))[0];
		EndIf;
		Return RowByKey[ColumnName];
	Else
		// реквизитов с таким путем не бывает
		Raise StrTemplate("Wrong data path [%1]", DataPath);
	EndIf;
EndFunction

Function SetPropertyObject(Parameters, DataPath, _Key, _Value)
	If GetPropertyObject(Parameters, DataPath, _Key) = _Value Then
		Return False; // Свойство не изменилось
	EndIf;
	Return SetProperty(Parameters.Cache, DataPath, _Key, _Value);
EndFunction

Function SetPropertyForm(Parameters, DataPath, _Key, _Value)
	If GetPropertyForm(Parameters, DataPath, _Key) = _Value Then
		Return False; // Свойство не изменилось
	EndIf;
	Return SetProperty(Parameters.CacheForm, DataPath, _Key, _Value);
EndFunction

// Устанавливает свойства по переданному DataPath, например ItemList.PriceType или Company
// возвращает True если хотябы одно свойство было изменено
Function SetProperty(Cache, DataPath, _Key, _Value)
	// измененные свойства сохраняются в кэш
	Segments = StrSplit(DataPath, ".");
	If Segments.Count() = 1 Then // это реквизит шапки, он указывается без точки, например Company
		Cache.Insert(DataPath, _Value);
	ElsIf Segments.Count() = 2 Then // это реквизит табличной части, состоит из двух частей разделенных точкой ItemList.PriceType
		TableName = Segments[0];
		ColumnName = Segments[1];
		If Not Cache.Property(TableName) Then
			Cache.Insert(TableName, New Array());
		EndIf;
		IsRowExists = False;
		For Each Row In Cache[TableName] Do
			If Row.Key = _Key Then
				Row.Insert(ColumnName, _Value);
				IsRowExists = True;
				Break;
			EndIf;
		EndDo;
		If Not IsRowExists Then
			NewRow = New Structure();
			NewRow.Insert("Key"      , _Key);
			NewRow.Insert(ColumnName , _Value);
			Cache[TableName].Add(NewRow);
		EndIf;
	Else
		// реквизитов с таким путем не бывает
		Raise StrTemplate("Wrong data path [%1]", DataPath);
	EndIf;	
	Return True;
EndFunction

Function IsUserChange(Parameters)
	If Parameters.Property("StepsEnablerNameCounter") Then
		Return Parameters.StepsEnablerNameCounter.Count() = 1;
	EndIf;
	Return False;
EndFunction

