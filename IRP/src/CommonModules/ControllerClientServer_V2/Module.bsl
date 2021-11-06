
// CONTROLLER
// 
// ОБЩИЙ МОДУЛЬ ДЛЯ SalesInvoice и всех кто с него скопирован - уровень Данные (линковка бизнес логики со структурой документа)
// никаких запросов к БД и расчетов тут делать нельзя, модифицировать форму задавать вопросы пользователю и т.д нельзя 
// только чтение из объекта и запись в объект


#Region PARTNER

// Client Event handler, вызывается из модуля ViewClient_V2
Procedure PartnerOnChange(Parameters) Export
	ModelClientServer_V2.EntryPoint("PartnerStepsEnabler", Parameters);
EndProcedure

Procedure PartnerStepsEnabler(Parameters, Chain) Export
	// При изменении партнера нужно изменить LegalName
	Chain.LegalName.Enable = True;
	Chain.LegalName.Setter = "SetLegalName";
	// эти данные (параметры) нужны для получения LegalName
	LegalNameOptions = ModelClientServer_V2.LegalNameOptions();
	LegalNameOptions.Partner   = GetProperty(Parameters, "Partner");
	LegalNameOptions.LegalName = GetProperty(Parameters, "LegalName");;
	Chain.LegalName.Options.Add(LegalNameOptions);
	
	// При изменении партнера нужно изменить Agreement
	Chain.Agreement.Enable = True;
	Chain.Agreement.Setter = "SetAgreement"
	;
	// эти данные (параметры) нужны для получения Agreement
	AgreementOptions = ModelClientServer_V2.AgreementOptions();
	AgreementOptions.Partner       = GetProperty(Parameters, "Partner");
	AgreementOptions.Agreement     = GetProperty(Parameters, "Agreement");
	AgreementOptions.CurrentDate   = GetProperty(Parameters, "Date");
	AgreementOptions.AgreementType = PredefinedValue("Enum.AgreementTypes.Customer");
	Chain.Agreement.Options.Add(AgreementOptions);
EndProcedure

Procedure SetPartner_API(Parameters, Results) Export
	ModelClientServer_V2.Init_API("PartnerStepsEnabler", Parameters);
	SetPartner(Parameters, Results);
EndProcedure

Procedure SetPartner(Parameters, Results) Export
	Setter("PartnerStepsEnabler", "Partner", Parameters, Results);
EndProcedure

#EndRegion

#Region LEGAL_NAME

// Client Event handler вызывается из модуля ViewClient_V2
Procedure LegalNameOnChange(Parameters) Export
	ModelClientServer_V2.EntryPoint("LegalNameStepsEnabler", Parameters);
EndProcedure

Procedure LegalNameStepsEnabler(Parameters, Chain) Export
	Return;
EndProcedure

Procedure SetLegalName(Parameters, Results) Export
	Setter("LegalNameStepsEnabler", "LegalName", Parameters, Results, "OnSetLegalNameNotify");
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
	CompanyOptions.Agreement = GetProperty(Parameters, "Agreement");
	CompanyOptions.Company   = GetProperty(Parameters, "Company");
	
	Chain.Company.Options.Add(CompanyOptions);
	
	// При изменении Agreement нужно изменить PriceType
	Chain.PriceType.Enable = True;
	Chain.PriceType.Setter = "SetItemListPriceType";
	
	// Эти данные (параметры) нужны для получения PriceType
	// PriceType находится в табличной части ItemList, така как это уровень данных то беремиз этой табличной части
	For Each Row In Parameters.Object.ItemList Do
		PriceTypeOptions = ModelClientServer_V2.PriceTypeOptions();
		PriceTypeOptions.Agreement = GetProperty(Parameters, "Agreement");
		// ключ нужен что бы потом, когда вернутся результаты из модуля Model идентифицировать строку,
		// для реквизитов в шапке ключ можно не заполнять, шапка только одна
		PriceTypeOptions.Key = Row.Key;
		Chain.PriceType.Options.Add(PriceTypeOptions);
	EndDo;
EndProcedure

Procedure SetAgreement(Parameters, Results) Export
	Setter("AgreementStepsEnabler", "Agreement", Parameters, Results);
EndProcedure

#EndRegion

#Region COMPANY

Procedure CompanyStepsEnabler(Parameters, Chain) Export
	Return;
EndProcedure

Procedure SetCompany(Parameters, Results) Export
	Setter("CompanyStepsEnabler", "Company", Parameters, Results);
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

#Region ITEM_LIST_PRICE_TYPE

Procedure ItemListPriceTypeOnChange(Parameters) Export
	ModelClientServer_V2.EntryPoint("ItemListPriceTypeStepsEnabler", Parameters);
EndProcedure

Procedure ItemListPriceTypeStepsEnabler(Parameters, Chain) Export
	Chain.Price.Enable = True;
	Chain.Price.Setter = "SetItemListPrice";
	
	Rows = Parameters.Object.ItemList;
	If Parameters.Property("Rows") Then
		// расчет только для конкретных строк, переданных в параметре
		Rows = Parameters.Rows;
	EndIf;
	For Each Row In Rows Do
		PriceOptions = ModelClientServer_V2.PriceOptions();
		PriceOptions.Ref          = Parameters.Object.Ref;
		PriceOptions.Date         = GetProperty(Parameters, "Date");
		PriceOptions.CurrentPrice = GetProperty(Parameters, "ItemList.Price", Row.Key);
		PriceOptions.PriceType    = GetProperty(Parameters, "ItemList.PriceType", Row.Key);
		PriceOptions.ItemKey      = GetProperty(Parameters, "ItemList.ItemKey"  , Row.Key);
		PriceOptions.Unit         = GetProperty(Parameters, "ItemList.Unit"     , Row.Key);
		PriceOptions.Key          = Row.Key;
		Chain.Price.Options.Add(PriceOptions);
	EndDo;
EndProcedure

// Устанавливает PriceType в табличную часть ItemList
Procedure SetItemListPriceType(Parameters, Results) Export
	Setter("ItemListPriceTypeStepsEnabler", "ItemList.PriceType", Parameters, Results);
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
	
	Rows = Parameters.Object.ItemList;
	If Parameters.Property("Rows") Then
		// расчет только для конкретных строк, переданных в параметре
		Rows = Parameters.Rows;
	EndIf;
	For Each Row In Rows Do
		// при ручном изменении цены надо установить тип цен как ручной
		PriceTypeAsManualOptions = ModelClientServer_V2.PriceTypeAsManualOptions();
		// изменил пользователь напрямую
		PriceTypeAsManualOptions.IsUserChange     = IsUserChange(Parameters);
		PriceTypeAsManualOptions.CurrentPriceType = GetProperty(Parameters, "ItemList.PriceType", Row.Key);
		PriceTypeAsManualOptions.Key = Row.Key;
		Chain.PriceTypeAsManual.Options.Add(PriceTypeAsManualOptions);
	EndDo;
EndProcedure

Procedure SetItemListPrice(Parameters, Results) Export
	Setter("ItemListPriceStepsEnabler", "ItemList.Price", Parameters, Results);
EndProcedure

#EndRegion

#Region NET_OFFERS_TAX_TOTAL_QUANTITY

Procedure ItemListEnableCalculations(Parameters, Chain, WhoIsChanged)
	Chain.Calculations.Enable = True;
	Chain.Calculations.Setter = "SetItemListCalculations";
	
	Rows = Parameters.Object.ItemList;
	If Parameters.Property("Rows") Then
		// расчет только для конкретных строк, переданных в параметре
		Rows = Parameters.Rows;
	EndIf;
	For Each Row In Rows Do
		
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
		
		CalculationsOptions.AmountOptions.DontCalculateRow = GetProperty(Parameters, "ItemList.DontCalculateRow", Row.Key);
		
		CalculationsOptions.AmountOptions.NetAmount        = GetProperty(Parameters, "ItemList.NetAmount"    , Row.Key);
		CalculationsOptions.AmountOptions.OffersAmount     = GetProperty(Parameters, "ItemList.OffersAmount" , Row.Key);
		CalculationsOptions.AmountOptions.TaxAmount        = GetProperty(Parameters, "ItemList.TaxAmount"    , Row.Key);
		CalculationsOptions.AmountOptions.TotalAmount      = GetProperty(Parameters, "ItemList.TotalAmount"  , Row.Key);
		
		CalculationsOptions.PriceOptions.Price              = GetProperty(Parameters, "ItemList.Price"              , Row.Key);
		CalculationsOptions.PriceOptions.PriceType          = GetProperty(Parameters, "ItemList.PriceType"          , Row.Key);
		CalculationsOptions.PriceOptions.Quantity           = GetProperty(Parameters, "ItemList.Quantity"           , Row.Key);
		CalculationsOptions.PriceOptions.QuantityInBaseUnit = GetProperty(Parameters, "ItemList.QuantityInBaseUnit" , Row.Key);
		
		CalculationsOptions.TaxOptions.PriceIncludeTax  = GetProperty(Parameters, "PriceIncludeTax");
		CalculationsOptions.TaxOptions.ItemKey          = GetProperty(Parameters, "ItemList.ItemKey", Row.Key);
		CalculationsOptions.TaxOptions.ArrayOfTaxInfo   = Parameters.ArrayOfTaxInfo;
		CalculationsOptions.TaxOptions.TaxRates         = Row.TaxRates;
		CalculationsOptions.TaxOptions.TaxList          = Row.TaxList;
		
		CalculationsOptions.QuantityOptions.ItemKey = GetProperty(Parameters, "ItemList.ItemKey", Row.Key);
		CalculationsOptions.QuantityOptions.Unit    = GetProperty(Parameters, "ItemList.Unit", Row.Key);
		CalculationsOptions.QuantityOptions.Quantity           = GetProperty(Parameters, "ItemList.Quantity"           , Row.Key);
		CalculationsOptions.QuantityOptions.QuantityInBaseUnit = GetProperty(Parameters, "ItemList.QuantityInBaseUnit" , Row.Key);
		
		CalculationsOptions.Key = Row.Key;
		
		Chain.Calculations.Options.Add(CalculationsOptions);
	EndDo;
EndProcedure

Procedure SetItemListCalculations(Parameters, Results) Export
	Setter(Undefined, "ItemList.NetAmount"   , Parameters, Results, , "NetAmount");
	Setter(Undefined, "ItemList.TaxAmount"   , Parameters, Results, , "TaxAmount");
	Setter(Undefined, "ItemList.OffersAmount", Parameters, Results, , "OffersAmount");
	Setter(Undefined, "ItemList.TotalAmount" , Parameters, Results, , "TotalAmount");
	Setter(Undefined, "ItemList.Price"       , Parameters, Results, , "Price");
	Setter(Undefined, "ItemList.QuantityInBaseUnit" , Parameters, Results, , "QuantityInBaseUnit");
	
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

Procedure NetAmountEnableChainLinks(Parameters, Chain) Export
	Return;
EndProcedure

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
	
	Rows = Parameters.Object.ItemList;
	If Parameters.Property("Rows") Then
		// расчет только для конкретных строк, переданных в параметре
		Rows = Parameters.Rows;
	EndIf;
	For Each Row In Rows Do
		// при ручном изменении цены надо установить тип цен как ручной
		PriceTypeAsManualOptions = ModelClientServer_V2.PriceTypeAsManualOptions();
		// изменил пользователь напрямую
		PriceTypeAsManualOptions.IsTotalAmountChange = True;
		PriceTypeAsManualOptions.CurrentPriceType = GetProperty(Parameters, "ItemList.PriceType", Row.Key);
		PriceTypeAsManualOptions.Key = Row.Key;
		Chain.PriceTypeAsManual.Options.Add(PriceTypeAsManualOptions);
	EndDo;
EndProcedure

#Region ITEM_LIST_QUANTITY

Procedure ItemListQuantityOnChange(Parameters) Export
	ModelClientServer_V2.EntryPoint("ItemListQuantityStepsEnabler", Parameters);
EndProcedure

Procedure ItemListQuantityStepsEnabler(Parameters, Chain) Export
	ItemListEnableCalculations(Parameters, Chain, "IsQuantityChanged");
EndProcedure

Procedure SetQuantity(Parameters, Results) Export
	Setter("ItemListQuantityStepsEnabler", "ItemList.Quantity", Parameters, Results, "OnSetQuantityNotify");
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

// Переносит изменения из Cache в Object
Procedure CommitChainChanges(Parameters) Export
	For Each Property In Parameters.Cache Do
		If Upper(Property.Key) = Upper("TaxList") Then
			// табличная часть налогов переносится целиком
			ArrayOfKeys = New Array();
			For Each Row In Property.Value Do
				If ArrayOfKeys.Find(Row.Key) = Undefined Then
					ArrayOfKeys.Add(Row.Key);
				EndIf;
			EndDo;
			
			For Each ItemOfKeys In ArrayOfKeys Do
				For Each Row In Parameters.Object.TaxList.FindRows(New Structure("Key", ItemOfKeys)) Do
					Parameters.Object.TaxList.Delete(Row);
				EndDo;
			EndDo;
			
			For Each Row In Property.Value Do
				FillPropertyValues(Parameters.Object.TaxList.Add(), Row);
			EndDo;
		
		// Табличные части ItemList и PaymentList переносятся построчно так как Key в строках уникален
		ElsIf TypeOf(Property.Value) = Type("Array") Then // это табличная часть
			For Each Row In Property.Value Do
				FillPropertyValues(Parameters.Object[Property.Key].FindRows(New Structure("Key", Row.Key))[0], Row);
			EndDo;
		Else
			Parameters.Object[Property.Key] = Property.Value; // это реквизит шапки
		EndIf;
	EndDo;
	// уведомление клиента о том что данные были изменены
	#IF Client THEN
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

Procedure Setter(StepsEnablerName, DataPath, Parameters, Results, ViewNotify = Undefined, ValueDataPath = Undefined)
	IsChanged = False;
	For Each Result In Results Do
		_Key   = Result.Options.Key;
		If ValueIsFilled(ValueDataPath) Then
			_Value = Result.Value[ValueDataPath];
		Else
			_Value = Result.Value;
		EndIf;
		If SetProperty(Parameters, DataPath, _Key, _Value) Then
			IsChanged = True;
		EndIf;
	EndDo;
	If IsChanged Then
		If ViewNotify <> Undefined Then
			// переадресация в клиентский модуль, вызов был с клиента, на форме что то надо обновить
			// вызывать будем потом когда завершится вся цепочка действий, и изменения будут перенесены с кэша в объект
			Parameters.ViewNotify.Add(ViewNotify);
		EndIf;
		If ValueIsFilled(StepsEnablerName) Then
			ModelClientServer_V2.EntryPoint(StepsEnablerName, Parameters);
		EndIf;
	EndIf;
EndProcedure

// параметр Key используется когда DataPath указывает на реквизит табличной части, например ItemList.PriceType
Function GetProperty(Parameters, DataPath, Key = Undefined)
	Segments = StrSplit(DataPath, ".");
	If Segments.Count() = 1 Then // это реквизит шапки, он указывается без точки, например Company
		If ValueIsFilled(Key) Then
			Raise StrTemplate("Key [%1] not allowed for data path [%2]", Key, DataPath);
		EndIf;
		If Parameters.Cache.Property(DataPath) Then
			Return Parameters.Cache[DataPath];
		Else
			Return Parameters.Object[DataPath];
		EndIf;
	ElsIf Segments.Count() = 2 Then // это реквизит табличной части, состоит из двух частей разделенных точкой ItemList.PriceType
		TableName = Segments[0];
		ColumnName = Segments[1];
		
		RowByKey = Undefined;
		If Parameters.Cache.Property(TableName) Then
			For Each Row In Parameters.Cache[TableName] Do
				If Not Row.Property(ColumnName) Then
					Continue;
				EndIf;
				If Row.Key = Key Then
					RowByKey = Row;
				EndIf;
			EndDo;
		EndIf;
		If RowByKey = Undefined Then
			RowByKey = Parameters.Object[TableName].FindRows(New Structure("Key", Key))[0];
		EndIf;
		Return RowByKey[ColumnName];
	Else
		// реквизитов с таким путем не бывает
		Raise StrTemplate("Wrong data path [%1]", DataPath);
	EndIf;
EndFunction

// Устанавливает свойства по переданному DataPath, например ItemList.PriceType или Company
// возвращает True если хотябы одно свойство было изменено
Function SetProperty(Parameters, DataPath, _Key, _Value)
	// что бы получить значение из коллекции нужно искать его по ключу
	If GetProperty(Parameters, DataPath, _Key) = _Value Then
		Return False; // Свойство не изменилось
	EndIf;
	// измененные свойства сохраняются в кэш
	Segments = StrSplit(DataPath, ".");
	If Segments.Count() = 1 Then // это реквизит шапки, он указывается без точки, например Company
		Parameters.Cache.Insert(DataPath, _Value);
	ElsIf Segments.Count() = 2 Then // это реквизит табличной части, состоит из двух частей разделенных точкой ItemList.PriceType
		TableName = Segments[0];
		ColumnName = Segments[1];
		If Not Parameters.Cache.Property(TableName) Then
			Parameters.Cache.Insert(TableName, New Array());
		EndIf;
		IsRowExists = False;
		For Each Row In Parameters.Cache[TableName] Do
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
			Parameters.Cache[TableName].Add(NewRow);
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

