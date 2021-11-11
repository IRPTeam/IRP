
// CONTROLLER
// 
// ОБЩИЙ МОДУЛЬ ДЛЯ SalesInvoice и всех кто с него скопирован - уровень Данные (линковка бизнес логики со структурой документа)
// никаких запросов к БД и расчетов тут делать нельзя, модифицировать форму задавать вопросы пользователю и т.д нельзя 
// только чтение из объекта и запись в объект

#IF Client THEN

Procedure FillPropertyFormByDefault(Form, DataPath, Parameters) Export
	Bindings = GetAllBindings(Parameters);
	Defaults = GetAllFillByDefault(Parameters);
	
	Default = Defaults.Get(DataPath);
	If Default<> Undefined Then
		ForceCommintChanges = False;
		ModelClientServer_V2.EntryPoint(Default.StepsEnabler, Parameters);
	ElsIf ValueIsFilled(Form[DataPath]) Then
			SetPropertyForm(Parameters, DataPath, , Form[DataPath]);
			Binding = Bindings.Get(DataPath);
			If Binding <> Undefined Then
				ForceCommintChanges = False;
				ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
			EndIf;
	EndIf;
	If ForceCommintChanges Then
		CommitChainChanges(Parameters);
	EndIf;
EndProcedure

#ENDIF

Function GetAllBindings(Parameters)
	Binding = New Map();
	Binding.Insert("Company"   , CompanyStepsBinding(Parameters));
	Binding.Insert("Partner"   , PartnerStepsBinding(Parameters));
	Binding.Insert("LegalName" , LegalNameStepsBinding(Parameters));
	
	Binding.Insert("ItemList.Item"     , ItemListItemStepsBinding(Parameters));
	Binding.Insert("ItemList.ItemKey"  , ItemListItemKeyStepsBinding(Parameters));
	Binding.Insert("ItemList.Unit"     , ItemListUnitStepsBinding(Parameters));
	Binding.Insert("ItemList.Quantity" , ItemListQuantityStepsBinding(Parameters));
	Return Binding;
EndFunction

Function GetAllFillByDefault(Parameters)
	Binding = New Map();
	Binding.Insert("Store", StoreDefaultBinding(Parameters));
	
	Binding.Insert("ItemList.Store"    , ItemListStoreDefaultBinding(Parameters));
	Binding.Insert("ItemList.Quantity" , ItemListQuantityDefaultBinding(Parameters));
	Return Binding;
EndFunction

#Region ITEM_LIST

Procedure AddNewRow(TableName, Parameters) Export
	NewRow = Parameters.Rows[0];
	UserSettingsClientServer.FillingRowFromSettings(Parameters.Object, StrTemplate("Object.%1", TableName), NewRow, True);
	Parameters.Insert("RowFilledByUserSettings", NewRow);
	
	Bindings = GetAllBindings(Parameters);
	Defaults = GetAllFillByDefault(Parameters);
	
	ForceCommintChanges = True;
	For Each ColumnName In StrSplit(Parameters.ObjectMetadataInfo.Tables[TableName].Columns, ",") Do
		DataPath = StrTemplate("%1.%2", TableName, ColumnName);
		Default = Defaults.Get(DataPath);
		If Default<> Undefined Then
			ForceCommintChanges = False;
			ModelClientServer_V2.EntryPoint(Default.StepsEnabler, Parameters);
		ElsIf ValueIsFilled(NewRow[ColumnName]) Then
			SetPropertyObject(Parameters, DataPath, NewRow.Key, NewRow[ColumnName]);
			Binding = Bindings.Get(DataPath);
			If Binding <> Undefined Then
				ForceCommintChanges = False;
				ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
			EndIf;
		EndIf;
	EndDo;
	If ForceCommintChanges Then
		CommitChainChanges(Parameters);
	EndIf;
EndProcedure

Procedure DeleteRows(TableName, Parameters) Export
	For Each DepTableName In Parameters.ObjectMetadataInfo.DependencyTables Do
		ArrayForDelete = New Array();
		For Each Row In Parameters.Object[DepTableName] Do
			If Not Parameters.Object[TableName].FindRows(New Structure("Key", Row.Key)).Count() THen
				ArrayForDelete.Add(Row);
			EndIf;
		EndDo;
		For Each ItemForDelete In ArrayForDelete Do
			Parameters.Object[DepTableName].Delete(ItemForDelete);
		EndDo;
	EndDo;
EndProcedure

#Region ITEM_LIST_ITEM

// ItemList.Item.OnChange
Procedure ItemListItemOnChange(Parameters) Export
	Binding = ItemListItemStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.Item.Set
Procedure SetItemListItem(Parameters, Results) Export
	Binding = ItemListItemStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.Item.Bind
Function ItemListItemStepsBinding(Parameters)
	DataPath = "ItemList.Item";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation", "ItemListItemStepsEnabler");
	Binding.Insert("SalesInvoice"        , "ItemListItemStepsEnabler");
	Return BindSteps("ItemListItemStepsEnabler", DataPath, Binding, Parameters);
EndFunction

Procedure ItemListItemStepsEnabler(Parameters, Chain) Export
	Chain.ChangeItemKeyByItem.Enable = True;
	Chain.ChangeItemKeyByItem.Setter = "SetItemListItemKey";
	For Each Row In GetRows(Parameters, "ItemList") Do
		Options = ModelClientServer_V2.ChangeItemKeyByItemOptions();
		Options.Item = GetPropertyObject(Parameters, "ItemList.Item", Row.Key);
		Options.Key = Row.Key;
		Chain.ChangeItemKeyByItem.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_LIST_ITEMKEY

// ItemList.ItemKey.OnChange
Procedure ItemListItemKeyOnChange(Parameters) Export
	Binding = ItemListItemKeyStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.ItemKey.Set
Procedure SetItemListItemKey(Parameters, Results) Export
	Binding = ItemListItemKeyStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.ItemKey.Bind
Function ItemListItemKeyStepsBinding(Parameters)
	DataPath = "ItemList.ItemKey";
	Binding = New Structure();
	Return BindSteps("ItemListItemKeyStepsEnabler", DataPath, Binding, Parameters);
EndFunction

Procedure ItemListItemKeyStepsEnabler(Parameters, Chain) Export
	Chain.ChangeUnitByItemKey.Enable = True;
	Chain.ChangeUnitByItemKey.Setter = "SetItemListUnit";
	For Each Row In GetRows(Parameters, "ItemList") Do
		Options = ModelClientServer_V2.ChangeUnitByItemKeyOptions();
		Options.ItemKey = GetPropertyObject(Parameters, "ItemList.ItemKey", Row.Key);
		Options.Key = Row.Key;
		Chain.ChangeUnitByItemKey.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_KEY_UNIT

// ItemList.Unit.OnChange
Procedure ItemListUnitOnChange(Parameters) Export
	Binding = ItemListUnitStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.Unit.Set
Procedure SetItemListUnit(Parameters, Results) Export
	Binding = ItemListUnitStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, "ItemList.Unit", Parameters, Results);
EndProcedure

// ItemList.Unit.Bind
Function ItemListUnitStepsBinding(Parameters) Export
	DataPath = "ItemList.Unit";
	Binding = New Structure();
	Return BindSteps("ItemListUnitStepsEnabler", DataPath, Binding, Parameters);
EndFunction

Procedure ItemListUnitStepsEnabler(Parameters, Chain) Export
	Chain.Calculations.Enable = True;
	Chain.Calculations.Setter = "SetItemListQuantityInBaseUnit";
	For Each Row In GetRows(Parameters, "ItemList") Do
		Options     = ModelClientServer_V2.CalculationsOptions();
		Options.Ref = Parameters.Object.Ref;
		
		Options.CalculateQuantityInBaseUnit.Enable   = True;
		
		Options.QuantityOptions.ItemKey = GetPropertyObject(Parameters, "ItemList.ItemKey", Row.Key);
		Options.QuantityOptions.Unit    = GetPropertyObject(Parameters, "ItemList.Unit", Row.Key);
		Options.QuantityOptions.Quantity           = GetPropertyObject(Parameters, "ItemList.Quantity"           , Row.Key);
		Options.QuantityOptions.QuantityInBaseUnit = GetPropertyObject(Parameters, "ItemList.QuantityInBaseUnit" , Row.Key);
		
		Options.Key = Row.Key;
		Chain.Calculations.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_LIST_QUANTITY

// ItemList.Quantity.OnChange
Procedure ItemListQuantityOnChange(Parameters) Export
	AddViewNotify("OnSetItemListQuantityNotify", Parameters);
	Binding = ItemListQuantityStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.Quantity.Set
Procedure SetItemListQuantity(Parameters, Results) Export
	Binding = ItemListQuantityStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetItemListQuantityNotify");
EndProcedure

// ItemList.Quantity.Default.Bind
Function ItemListQuantityDefaultBinding(Parameters)
	DataPath = "ItemList.Quantity";
	Binding = New Structure();
	Return BindSteps("ItemListQuantityDefault", DataPath, Binding, Parameters);
EndFunction

// ItemList.Quantity.Bind
Function ItemListQuantityStepsBinding(Parameters) Export
	DataPath = "ItemList.Quantity";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation" ,"ItemListQuantityStepsEnabler_WithoutAmounts");
	Return BindSteps("ItemListQuantityStepsEnabler", DataPath, Binding, Parameters);
EndFunction

Procedure ItemListQuantityDefault(Parameters, Chain) Export
	Chain.DefaultQuantityInList.Enable = True;
	Chain.DefaultQuantityInList.Setter = "SetItemListQuantity";
	Options = ModelClientServer_V2.DefaultQuantityInListOptions();
	NewRow = Parameters.RowFilledByUserSettings;
	Options.CurrentQuantity = GetPropertyObject(Parameters, "ItemList.Quantity", NewRow.Key);
	Options.Key = NewRow.Key;
	Chain.DefaultQuantityInList.Options.Add(Options);
EndProcedure

Procedure ItemListQuantityStepsEnabler_WithoutAmounts(Parameters, Chain) Export
	Chain.Calculations.Enable = True;
	Chain.Calculations.Setter = "SetItemListQuantityInBaseUnit";
	For Each Row In GetRows(Parameters, "ItemList") Do
		Options     = ModelClientServer_V2.CalculationsOptions();
		Options.Ref = Parameters.Object.Ref;
		Options.CalculateQuantityInBaseUnit.Enable   = True;
		Options.QuantityOptions.ItemKey = GetPropertyObject(Parameters, "ItemList.ItemKey", Row.Key);
		Options.QuantityOptions.Unit    = GetPropertyObject(Parameters, "ItemList.Unit", Row.Key);
		Options.QuantityOptions.Quantity           = GetPropertyObject(Parameters, "ItemList.Quantity"           , Row.Key);
		Options.QuantityOptions.QuantityInBaseUnit = GetPropertyObject(Parameters, "ItemList.QuantityInBaseUnit" , Row.Key);
		Options.Key = Row.Key;
		Chain.Calculations.Options.Add(Options);
	EndDo;
EndProcedure

Procedure ItemListQuantityStepsEnabler(Parameters, Chain) Export
	ItemListEnableCalculations(Parameters, Chain, "IsQuantityChanged");
EndProcedure

#EndRegion

// ItemList.QuantityInBaseUnit.Set
Procedure SetItemListQuantityInBaseUnit(Parameters, Results) Export
	SetterObject(Undefined, "ItemList.QuantityInBaseUnit" , Parameters, Results, , "QuantityInBaseUnit");
EndProcedure

#EndRegion

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

#Region COMPANY

// Company.OnChange
Procedure CompanyOnChange(Parameters) Export
	AddViewNotify("OnSetCompanyNotify", Parameters);
	Binding = CompanyStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Company.Set
Procedure CompanyName(Parameters, Results) Export
	Binding = CompanyStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetCompanyNotify");
EndProcedure

// Company.Bind
Function CompanyStepsBinding(Parameters)
	DataPath = "Company";
	Binding = New Structure();
	Return BindSteps("CompanyStepsEnabler", DataPath, Binding, Parameters);
EndFunction

Procedure CompanyStepsEnabler(Parameters, Chain) Export
	Return;
EndProcedure

#EndRegion

#Region PARTNER

// Partner.OnChange
Procedure PartnerOnChange(Parameters) Export
	ProceedObjectPropertyBeforeChange(Parameters);
	AddViewNotify("OnSetPartnerNotify", Parameters);
	Binding = PartnerStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Partner.Set
Procedure SetPartner(Parameters, Results) Export
	Binding = PartnerStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetPartnerNotify");
EndProcedure

// Partner.Bind
Function PartnerStepsBinding(Parameters)
	DataPath = "Partner";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation", "PartnerStepsEnabler_ChangeOnlyLegalName");
	Return BindSteps("PartnerStepsEnabler", DataPath, Binding, Parameters);
EndFunction

Procedure PartnerStepsEnabler(Parameters, Chain) Export
	// При изменении партнера нужно изменить LegalName
	Chain.ChangeLegalNameByPartner.Enable = True;
	Chain.ChangeLegalNameByPartner.Setter = "SetLegalName";
	// эти данные (параметры) нужны для получения LegalName
	Options = ModelClientServer_V2.ChangeLegalNameByPartnerOptions();
	Options.Partner   = GetPropertyObject(Parameters, "Partner");
	Options.LegalName = GetPropertyObject(Parameters, "LegalName");;
	Chain.LegalName.Options.Add(Options);
	
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

Procedure PartnerStepsEnabler_ChangeOnlyLegalName(Parameters, Chain) Export
	Chain.ChangeLegalNameByPartner.Enable = True;
	Chain.ChangeLegalNameByPartner.Setter = "SetLegalName";
	Options = ModelClientServer_V2.ChangeLegalNameByPartnerOptions();
	Options.Partner   = GetPropertyObject(Parameters, "Partner");
	Options.LegalName = GetPropertyObject(Parameters, "LegalName");;
	Chain.ChangeLegalNameByPartner.Options.Add(Options);
EndProcedure

Procedure SetPartner_API(Parameters, Results) Export
	ModelClientServer_V2.Init_API("PartnerStepsEnabler", Parameters);
	SetPartner(Parameters, Results);
EndProcedure

#EndRegion

#Region LEGAL_NAME

// LegalName.OnChange
Procedure LegalNameOnChange(Parameters) Export
	AddViewNotify("OnSetLegalNameNotify", Parameters);
	Binding = LegalNameStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// LegalName.Set
Procedure SetLegalName(Parameters, Results) Export
	Binding = LegalNameStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetLegalNameNotify");
EndProcedure

// LegalName.Bind
Function LegalNameStepsBinding(Parameters)
	DataPath = "LegalName";
	Binding = New Structure();
	Return BindSteps("LegalNameStepsEnabler", DataPath, Binding, Parameters);
EndFunction

Procedure LegalNameStepsEnabler(Parameters, Chain) Export
	Return;
EndProcedure

#EndRegion

#Region STORE

// Store.OnChange
Procedure StoreOnChange(Parameters) Export
	ProceedFormPropertyBeforeChange(Parameters);
	AddViewNotify("OnSetStoreNotify", Parameters);
	Binding = StoreStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Store.Set
Procedure SetStore(Parameters, Results) Export
	Binding = StoreStepsBinding(Parameters);
	SetterForm(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetStoreNotify", ,True);
EndProcedure

// Store.Default.Bind
Function StoreDefaultBinding(Parameters)
	DataPath = "Store";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation", "StoreDefault");
	Binding.Insert("GoodsReceipt"        , "StoreDefault");

	Binding.Insert("SalesInvoice"   , "StoreDefault_HaveAgreementInHeader");
	Binding.Insert("PurchaseInvoice", "StoreDefault_HaveAgreementInHeader");
	
	Return BindSteps(Undefined, DataPath, Binding, Parameters);
EndFunction

// Store.Bind
Function StoreStepsBinding(Parameters)
	DataPath = "Store";
	Binding = New Structure();
	Return BindSteps("StoreStepsEnabler", DataPath, Binding, Parameters);
EndFunction

Procedure StoreDefault(Parameters, Chain) Export
	Chain.DefaultStoreInHeader.Enable = True;
	Chain.DefaultStoreInHeader.Setter = "SetStore";
	Options = ModelClientServer_V2.DefaultStoreInHeaderOptions();
	Options.DocumentRef = Parameters.Object.Ref;
	
	ArrayOfStoresInList = New Array();
	For Each Row In Parameters.Object.ItemList Do
		ArrayOfStoresInList.Add(GetPropertyObject(Parameters, "ItemList.Store", Row.Key));
	EndDo;
	Options.ArrayOfStoresInList = ArrayOfStoresInList; 
	
	Chain.DefaultStoreInHeader.Options.Add(Options);
EndProcedure

Procedure StoreDefault_HaveAgreementInHeader(Parameters, Chain) Export
	Chain.DefaultStoreInHeader.Enable = True;
	Chain.DefaultStoreInHeader.Setter = "SetStore";
	Options = ModelClientServer_V2.DefaultStoreInHeaderOptions();
	Options.DocumentRef = Parameters.Object.Ref;
	Options.Agreement   = GetPropertyObject(Parameters, "Agreement");
	
	ArrayOfStoresInList = New Array();
	For Each Row In Parameters.Object.ItemList Do
		ArrayOfStoresInList.Add(GetPropertyObject(Parameters, "ItemList.Store", Row.Key));
	EndDo;
	Options.ArrayOfStoresInList = ArrayOfStoresInList; 
	
	Chain.DefaultStoreInHeader.Options.Add(Options);
EndProcedure

Procedure StoreStepsEnabler(Parameters, Chain) Export
	Chain.FillStoresInList.Enable = True;
	Chain.FillStoresInList.Setter = "SetItemListStore";
	
	For Each Row In GetRows(Parameters, "ItemList") Do
		Options = ModelClientServer_V2.FillStoresInListOptions();
		Options.Store        = GetPropertyForm(Parameters, "Store");
		Options.StoreInList  = GetPropertyObject(Parameters, "ItemList.Store", Row.Key);
		Options.IsUserChange = IsUserChange(Parameters);
		Options.Key = Row.Key;
		Chain.FillStoresInList.Options.Add(Options);
	EndDo;
EndProcedure

// ItemList.Store.OnChange
Procedure ItemListStoreOnChange(Parameters) Export
	ProceedListPropertyBeforeChange(Parameters);
	Binding = ItemListStoreSptepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.Store.Set
Procedure SetItemListStore(Parameters, Results) Export
	Binding = ItemListStoreSptepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.Store.Default.Bind
Function ItemListStoreDefaultBinding(Parameters)
	DataPath = "ItemList.Store";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation", "ItemListStoreDefault");
	Binding.Insert("GoodsReceipt"        , "ItemListStoreDefault");

	Binding.Insert("SalesInvoice"   , "ItemListStoreDefault_HaveAgreementInHeader");
	Binding.Insert("PurchaseInvoice", "ItemListStoreDefault_HaveAgreementInHeader");
	
	Return BindSteps(Undefined, DataPath, Binding, Parameters);
EndFunction

// ItemList.Store.Bind
Function ItemListStoreSptepsBinding(Parameters)
	DataPath = "ItemList.Store";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation", "ItemListStoreStepsEnabler_HaveStoreInHeader");
	Binding.Insert("GoodsReceitp"        , "ItemListStoreStepsEnabler_HaveStoreInHeader");

	Binding.Insert("SalesInvoice"   , "ItemListStoreStepsEnabler_HaveUseShipmentConfirmationInList");
	Binding.Insert("PurchaseInvoice", "ItemListStoreStepsEnabler_HaveUseGoodsReceiptInList");
	
	Return BindSteps(Undefined, DataPath, Binding, Parameters);
EndFunction

Procedure ItemListStoreDefault(Parameters, Chain) Export
	Chain.DefaultStoreInList.Enable = True;
	Chain.DefaultStoreInList.Setter = "SetItemListStore";
	Options = ModelClientServer_V2.DefaultStoreInListOptions();
	NewRow = Parameters.RowFilledByUserSettings;
	Options.StoreFromUserSettings = NewRow.Store;
	Options.StoreInList           = GetPropertyObject(Parameters, "ItemList.Store", NewRow.Key);
	Options.StoreInHeader         = GetPropertyForm(Parameters  , "Store");
	Options.Key = NewRow.Key;
	Chain.DefaultStoreInList.Options.Add(Options);
EndProcedure

Procedure ItemListStoreDefault_HaveAgreementInHeader(Parameters, Chain) Export
	Chain.DefaultStoreInList.Enable = True;
	Chain.DefaultStoreInList.Setter = "SetItemListStore";
	Options = ModelClientServer_V2.DefaultStoreInListOptions();
	NewRow = Parameters.RowFilledByUserSettings;
	Options.StoreFromUserSettings = NewRow.Store;
	Options.StoreInList           = GetPropertyObject(Parameters, "ItemList.Store", NewRow.Key);
	Options.StoreInHeader         = GetPropertyForm(Parameters  , "Store");
	Options.Agreement             = GetPropertyObject(Parameters, "Agreement");
	Options.Key = NewRow.Key;
	Chain.DefaultStoreInList.Options.Add(Options);
EndProcedure

Procedure ItemListStoreStepsEnabler_HaveStoreInHeader(Parameters, Chain) Export
	// В шапке документа есть реквизит Store
	Chain.ChangeStoreInHeaderByStoresInList.Enable = True;
	Chain.ChangeStoreInHeaderByStoresInList.Setter = "SetStore";
	
	// нужно взять все строки в табличной части ItemList из строк получить Store
	Options = ModelClientServer_V2.ChangeStoreInHeaderByStoresInListOptions();
	ArrayOfStoresInList = New Array();
	For Each Row In Parameters.Object.ItemList Do
		ArrayOfStoresInList.Add(GetPropertyObject(Parameters, "ItemList.Store", Row.Key));
	EndDo;
	Options.ArrayOfStoresInList = ArrayOfStoresInList; 
	Chain.ChangeStoreInHeaderByStoresInList.Options.Add(Options);
EndProcedure

Procedure ItemListStoreStepsEnabler_HaveUseShipmentConfirmationInList(Parameters, Chain) Export
	ItemListStoreStepsEnabler_HaveStoreInHeader(Parameters, Chain);
	
	// В табличной части ItemList есть реквизит UseShipmentConfirmation
	Chain.ChangeUseShipmentConfirmationByStore.Enable = True;
	Chain.ChangeUseShipmentConfirmationByStore.Setter = "SetItemListUseShipmentConfirmation";
	
	For Each Row In GetRows(Parameters, "ItemList") Do
		Options = ModelClientServer_V2.ChangeUseShipmentConfirmationByStoreOptions();
		Options.Store   = GetPropertyObject(Parameters, "ItemList.Store", Row.Key);
		Options.ItemKey = GetPropertyObject(Parameters, "ItemList.ItemKey", Row.Key);
		Options.Key = Row.Key;
		Chain.ChangeUseShipmentConfirmationByStore.Options.Add(Options);
	EndDo;
EndProcedure

Procedure ItemListStoreStepsEnabler_HaveUseGoodsReceiptInList(Parameters, Chain) Export
	ItemListStoreStepsEnabler_HaveStoreInHeader(Parameters, Chain);
	
	// В табличной части ItemList есть реквизит UseGoodsReceipt
	Chain.ChangeUseGoodsReceiptByStore.Enable = True;
	Chain.ChangeUseGoodsReceiptByStore.Setter = "SetItemListUseGoodsReceipt";
	
	For Each Row In GetRows(Parameters, "ItemList") Do
		Options = ModelClientServer_V2.ChangeUseGoodsReceiptByStoreOptions();
		Options.Store   = GetPropertyObject(Parameters, "ItemList.Store", Row.Key);
		Options.ItemKey = GetPropertyObject(Parameters, "ItemList.ItemKey", Row.Key);
		Options.Key = Row.Key;
		Chain.ChangeUseGoodsReceiptByStore.Options.Add(Options);
	EndDo;	
EndProcedure

// ItemList.UseShipmentConfirmation.Set
Procedure SetItemListUseShipmentConfirmation(Parameters, Results) Export
	SetterObject(Undefined, "ItemList.UseShipmentConfirmation", Parameters, Results);
EndProcedure

// ItemList.UseGoodsReceipt.Set
Procedure SetItemListUseGoodsReceipt(Parameters, Results) Export
	SetterObject(Undefined, "ItemList.UseGoodsReceipt", Parameters, Results);
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
		
		Options     = ModelClientServer_V2.CalculationsOptions();
		Options.Ref = Parameters.Object.Ref;
		
		// при изменении цены нужно пересчитать NetAmount, TotalAmount, TaxAmount, OffersAmount
		If WhoIsChanged = "IsPriceChanged" Or WhoIsChanged = "IsPriceIncludeTaxChanged" Then
			Options.CalculateNetAmount.Enable   = True;
			Options.CalculateTotalAmount.Enable = True;
			Options.CalculateTaxAmount.Enable   = True;
		ElsIf WhoIsChanged = "IsTotalAmountChanged" Then
		// при изменении total amount налоги расчитываются в обратную сторону, меняется Net Amount и цена
			Options.CalculateTaxAmountReverse.Enable   = True;
			Options.CalculateNetAmountAsTotalAmountMinusTaxAmount.Enable   = True;
			Options.CalculatePriceByTotalAmount.Enable   = True;
		ElsIf WhoIsChanged = "IsQuantityChanged" Then
			Options.CalculateQuantityInBaseUnit.Enable   = True;
			Options.CalculateNetAmount.Enable   = True;
			Options.CalculateTotalAmount.Enable = True;
			Options.CalculateTaxAmount.Enable   = True;
		EndIf;
		
		Options.AmountOptions.DontCalculateRow = GetPropertyObject(Parameters, "ItemList.DontCalculateRow", Row.Key);
		
		Options.AmountOptions.NetAmount        = GetPropertyObject(Parameters, "ItemList.NetAmount"    , Row.Key);
		Options.AmountOptions.OffersAmount     = GetPropertyObject(Parameters, "ItemList.OffersAmount" , Row.Key);
		Options.AmountOptions.TaxAmount        = GetPropertyObject(Parameters, "ItemList.TaxAmount"    , Row.Key);
		Options.AmountOptions.TotalAmount      = GetPropertyObject(Parameters, "ItemList.TotalAmount"  , Row.Key);
		
		Options.PriceOptions.Price              = GetPropertyObject(Parameters, "ItemList.Price"              , Row.Key);
		Options.PriceOptions.PriceType          = GetPropertyObject(Parameters, "ItemList.PriceType"          , Row.Key);
		Options.PriceOptions.Quantity           = GetPropertyObject(Parameters, "ItemList.Quantity"           , Row.Key);
		Options.PriceOptions.QuantityInBaseUnit = GetPropertyObject(Parameters, "ItemList.QuantityInBaseUnit" , Row.Key);
		
		Options.TaxOptions.PriceIncludeTax  = GetPropertyObject(Parameters, "PriceIncludeTax");
		Options.TaxOptions.ItemKey          = GetPropertyObject(Parameters, "ItemList.ItemKey", Row.Key);
		Options.TaxOptions.ArrayOfTaxInfo   = Parameters.ArrayOfTaxInfo;
		Options.TaxOptions.TaxRates         = Row.TaxRates;
		Options.TaxOptions.TaxList          = Row.TaxList;
		
		Options.QuantityOptions.ItemKey = GetPropertyObject(Parameters, "ItemList.ItemKey", Row.Key);
		Options.QuantityOptions.Unit    = GetPropertyObject(Parameters, "ItemList.Unit", Row.Key);
		Options.QuantityOptions.Quantity           = GetPropertyObject(Parameters, "ItemList.Quantity"           , Row.Key);
		Options.QuantityOptions.QuantityInBaseUnit = GetPropertyObject(Parameters, "ItemList.QuantityInBaseUnit" , Row.Key);
		
		Options.Key = Row.Key;
		
		Chain.Calculations.Options.Add(Options);
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

#EndRegion

#EndRegion

// Вызывается когда вся цепочка связанных действий будет заверщена
Procedure OnChainComplete(Parameters) Export
	#IF Client THEN
		// на клиенте возможно нужно задать вопрос пользователю, поэтому сразу из кэша в объект не переносим
		If ValueIsFilled(Parameters.ViewModuleName) Then
			Execute StrTemplate("%1.OnChainComplete(Parameters);", Parameters.ViewModuleName);
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
		If Parameters.ViewNotify.Count() And Not ValueIsFilled(Parameters.ViewModuleName) Then
			Raise "View module name is not filled";
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

Procedure ProceedListPropertyBeforeChange(Parameters)
	If Parameters.ListPropertyBeforeChange = Undefined Then
		Return;
	EndIf;
	DataPath   = Parameters.ListPropertyBeforeChange.DataPath;
	TableName  = Parameters.ListPropertyBeforeChange.TableName;
	ColumnName = Parameters.ListPropertyBeforeChange.ColumnName;
	ArrayOfValuesBeforeChange = Parameters.ListPropertyBeforeChange.ArrayOfValuesBeforeChange;
	For Each Row In ArrayOfValuesBeforeChange Do
		CurrentValue = GetPropertyObject(Parameters, DataPath, Row.Key);
		For Each OriginRow In Parameters.Object[TableName] Do
			If Row.Key = OriginRow.Key Then
			 	OriginRow[ColumnName] = Row[ColumnName];
				SetPropertyObject(Parameters, DataPath, Row.Key, CurrentValue);
				Break;
			EndIf;
		EndDo;
	EndDo;
EndProcedure

Function GetRows(Parameters, TableName)
	If Parameters.Property("Rows") Then
		// расчет только для конкретных строк, переданных в параметре
		Return Parameters.Rows;
	EndIf;
	Return Parameters.Object[TableName];;
EndFunction

Procedure SetterForm(StepsEnablerName, DataPath, Parameters, Results, 
	ViewNotify = Undefined, ValueDataPath = Undefined, NotifyAnyWay = False)
	Setter("Form", StepsEnablerName, DataPath, Parameters, Results, ViewNotify, ValueDataPath, NotifyAnyWay);
EndProcedure

Procedure SetterObject(StepsEnablerName, DataPath, Parameters, Results, 
	ViewNotify = Undefined, ValueDataPath = Undefined, NotifyAnyWay = False)
	Setter("Object", StepsEnablerName, DataPath, Parameters, Results, ViewNotify, ValueDataPath, NotifyAnyWay);
EndProcedure

Procedure Setter(Source, StepsEnablerName, DataPath, Parameters, Results, ViewNotify, ValueDataPath, NotifyAnyWay)
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
	If IsChanged Or NotifyAnyWay Then
		AddViewNotify(ViewNotify, Parameters);
	EndIf;
	If IsChanged And ValueIsFilled(StepsEnablerName) Then
		ModelClientServer_V2.EntryPoint(StepsEnablerName, Parameters);
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
					Break;
				EndIf;
			EndDo;
		EndIf;
		If RowByKey = Undefined Then
			ArrayRowsByKey = Source[TableName].FindRows(New Structure("Key", Key));
			If ArrayRowsByKey.Count() <> 1 Then
				Raise StrTemplate("Found not 1 row by key [%1]", Key);
			EndIf;
			RowByKey = ArrayRowsByKey[0];
		EndIf;
		Return RowByKey[ColumnName];
	Else
		// реквизитов с таким путем не бывает
		Raise StrTemplate("Wrong data path [%1]", DataPath);
	EndIf;
EndFunction

Function SetPropertyObject(Parameters, DataPath, _Key, _Value)
	PropertyValue = GetPropertyObject(Parameters, DataPath, _Key);
	If ?(ValueIsFilled(PropertyValue), PropertyValue, Undefined) = ?(ValueIsFilled(_Value), _Value, Undefined) Then
		Return False; // Свойство не изменилось
	EndIf;
	Return SetProperty(Parameters.Cache, DataPath, _Key, _Value);
EndFunction

Function SetPropertyForm(Parameters, DataPath, _Key, _Value)
	PropertyValue = GetPropertyForm(Parameters, DataPath, _Key);
	If ?(ValueIsFilled(PropertyValue), PropertyValue, Undefined) = ?(ValueIsFilled(_Value), _Value, Undefined) Then
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

Function BindSteps(DefaulStepsEnabler, DataPath, Binding, Parameters)
	MetadataBinding = New Map();
	If Binding <> Undefined Then
		For Each KeyValue In Binding Do
			MetadataName = KeyValue.Key;
			MetadataBinding.Insert(StrTemplate("%1.%2", MetadataName, DataPath), Binding[MetadataName]);
		EndDo;
	EndIf;
	FullDataPath = StrTemplate("%1.%2", Parameters.ObjectMetadataInfo.MetadataName, DataPath);
	StepsEnabler = MetadataBinding.Get(FullDataPath);
	StepsEnabler = ?(StepsEnabler = Undefined, DefaulStepsEnabler, StepsEnabler);
	If Not ValueIsFilled(StepsEnabler) Then
		Raise StrTemplate("Steps enabler is not defined [%1]", DataPath);
	Endif;
	Result = New Structure();
	Result.Insert("FullDataPath" , FullDataPath);
	Result.Insert("StepsEnabler" , StepsEnabler);
	Result.Insert("DataPath", DataPath);
	Return Result;
EndFunction

Function IsUserChange(Parameters)
	If Parameters.Property("ModelInveronment")
		And Parameters.ModelInveronment.Property("StepsEnablerNameCounter") Then
		Return Parameters.ModelInveronment.StepsEnablerNameCounter.Count() = 1;
	EndIf;
	Return False;
EndFunction

