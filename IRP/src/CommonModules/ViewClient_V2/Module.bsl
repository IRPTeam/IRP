
// VIEW
// 
// В ЭТОМ МОДУЛЕ ТОЛЬКО МОДИФИКАЦИЯ ФОРМЫ, ВПРОСЫ ПОЛЬЗОВАТЕЛЮ и прочие клиентские вещи
// ДЕЛАТЬ ИЗМЕНЕНИЯ объекта нельзя только чтение

Function GetServerParameters()
	Result = New Structure();
	Result.Insert("TableName", "");
	Result.Insert("Rows", Undefined);
	
	Return Result;
EndFunction

Function GetFormParameters()
	Result = New Structure();
	Result.Insert("ObjectPropertyDataPathBeforeChange", "");
	Result.Insert("FormPropertyDataPathBeforeChange", "");
	Result.Insert("EventCaller", "");
	Return Result;
EndFunction

Function _GetParameters(Object, Form, ServerParameters, FormParameters = Undefined)
	If FormParameters <> Undefined Then
		Return GetParameters(Object, Form, ServerParameters.TableName, ServerParameters.Rows,
			FormParameters.ObjectPropertyDataPathBeforeChange,
			FormParameters.FormPropertyDataPathBeforeChange,
			FormParameters.EventCaller); 
	EndIf;
	Return GetParameters(Object, Form, ServerParameters.TableName, ServerParameters.Rows);
EndFunction

Function GetParameters(Object, Form, 
						TableName = "", 
						Rows = Undefined, 
						ObjectPropertyDataPathBeforeChange = "", 
						FormPropertyDataPathBeforeChange = "",
						EventCaller = "")
	Parameters = New Structure();
	// параметры для Client 
	Parameters.Insert("Form"           , Form);
	Parameters.Insert("CacheForm"      , New Structure()); // кэш для реквизитов формы
	Parameters.Insert("ViewNotify"     , New Array());
	Parameters.Insert("ViewModuleName" , "ViewClient_V2");
	
	Parameters.Insert("ObjectPropertyNamesBeforeChange" , GetObjectPropertyNamesBegoreChange());
	Parameters.Insert("ObjectPropertyBeforeChange"      , Undefined);
	
	Parameters.Insert("FormPropertyNamesBeforeChange"   , GetFormPropertyNamesBegoreChange());
	Parameters.Insert("FormPropertyBeforeChange"        , Undefined);
	
	// параметры для Server + Client
	// кэш для реквизитов объекта
	Parameters.Insert("Object" , Object);
	Parameters.Insert("Cache"  , New Structure());
	Parameters.Insert("ControllerModuleName" , "ControllerClientServer_V2");
	Parameters.Insert("EventCaller", EventCaller);
	
	// параметры для Client
	// PropertyDataPath - имя реквизита для которого надо получить значение до изменения
	If ValueIsFilled(ObjectPropertyDataPathBeforeChange) Or ValueIsFilled(FormPropertyDataPathBeforeChange) Then
		CacheBeforeChange = CommonFunctionsServer.DeserializeXMLUseXDTO(Form.CacheBeforeChange);
		If ValueIsFilled(ObjectPropertyDataPathBeforeChange) Then
			Parameters.ObjectPropertyBeforeChange = GetCacheBeforeChange(CacheBeforeChange.CacheObject, ObjectPropertyDataPathBeforeChange);
		EndIf;
		If ValueIsFilled(FormPropertyDataPathBeforeChange) Then
			Parameters.FormPropertyBeforeChange = GetCacheBeforeChange(CacheBeforeChange.CacheForm, FormPropertyDataPathBeforeChange);
		EndIf;
	EndIf;
	
	// налоги
	ArrayOfTaxInfo = TaxesClient.GetArrayOfTaxInfo(Form);
	Parameters.Insert("ArrayOfTaxInfo", ArrayOfTaxInfo);
	
	// получаем колонки из табличных частей
	ArrayOfTableNames = New Array();
	If TableName <> Undefined Then
		ArrayOfTableNames.Add(TableName);
	EndIf;	
	If CommonFunctionsClientServer.ObjectHasProperty(Object, "TaxList") Then
		ArrayOfTableNames.Add("TaxList");
	EndIf;
	// MetadataName
	// Tables.TableName.Columns
	// DependencyTables
	ObjectMetadataInfo = ViewServer_V2.GetObjectMetadataInfo(Object, StrConcat(ArrayOfTableNames, ","));
	
	// Server
	Parameters.Insert("ObjectMetadataInfo", ObjectMetadataInfo);
	
	// если не переданы конкретные строки то используем все что есть в таблице c именем TableName
	If Rows = Undefined And ValueIsFilled(TableName) Then
		Rows = Object[TableName];
	EndIf;
	If Rows = Undefined Then
		Rows = New Array();
	EndIf;
	
	// строку таблицы нельзя передать на сервер, поэтому помещаем данные в массив структур
	ArrayOfRows = New Array();
	For Each Row In Rows Do
		NewRow = New Structure(ObjectMetadataInfo.Tables[TableName].Columns);
		FillPropertyValues(NewRow, Row);
		ArrayOfRows.Add(NewRow);
		
		// налоги
		ArrayOfRowsTaxList = New Array();
		If ObjectMetadataInfo.Property("TaxListColumns") Then
			For Each TaxRow In Object.TaxList.FindRows(New Structure("Key", Row.Key)) Do
				NewRowTaxList = New Structure(ObjectMetadataInfo.Tables.TaxList.Columns);
				FillPropertyValues(NewRowTaxList, TaxRow);
				ArrayOfRowsTaxList.Add(NewRowTaxList);
			EndDo;
		EndIf;
		
		TaxRates = New Structure();
		For Each ItemOfTaxInfo In ArrayOfTaxInfo Do
			TaxRates.Insert(ItemOfTaxInfo.Name, Row[ItemOfTaxInfo.Name]);
		EndDo;
		NewRow.Insert("TaxRates", TaxRates);
		NewRow.Insert("TaxList" , ArrayOfRowsTaxList);
	EndDo;
	
	If ArrayOfRows.Count() Then
		Parameters.Insert("Rows", ArrayOfRows);
	EndIf;
	Return Parameters;
EndFunction

Function GetRowsByCurrentData(Form, TableName, CurrentData)
	Rows = New Array();
	If CurrentData = Undefined Then
		CurrentData = Form.Items[TableName].CurrentData;
	EndIf;
	If CurrentData <> Undefined Then
		Rows.Add(CurrentData);
	EndIf;
	Return Rows;
EndFunction

Function GetCacheBeforeChange(Cache, DataPath)
	If Not Cache.Property(DataPath) Then
		Raise StrTemplate("Property by DataPath [%1] not found in CacheBeforeChange", DataPath);
	EndIf;
	// значение которое было в реквизите до того как он был изменен
	ValueBeforeChange = Cache[DataPath];
	Return New Structure("DataPath, ValueBeforeChange", DataPath, ValueBeforeChange);
EndFunction

// возвращает список реквизитов объекта для которых нужно получить значение до изменения
Function GetObjectPropertyNamesBegoreChange()
	Return "Partner, Sender, Receiver";
EndFunction

// возвращает список реквизитов формы для которых нужно получить значение до изменения
Function GetFormPropertyNamesBegoreChange()
	Return "Store";
EndFunction

// хранит значения реквизитов до изменения
Procedure UpdateCacheBeforeChange(Object, Form)
	// реквизиты Object которые нужно кэшировать, для табличных частей не реализовано
	CacheObject = New Structure(GetObjectPropertyNamesBegoreChange());
	FillPropertyValues(CacheObject, Object);
	
	// реквизиты Form которые нужно кэшировать
	CacheForm = New Structure(GetFormPropertyNamesBegoreChange());
	FillPropertyValues(CacheForm, Form);
	
	CacheBeforeChange = New Structure("CacheObject, CacheForm", CacheObject, CacheForm);
	Form.CacheBeforeChange = CommonFunctionsServer.SerializeXMLUseXDTO(CacheBeforeChange);
EndProcedure

Procedure OnChainComplete(Parameters) Export
	If Parameters.EventCaller = "StoreOnUserChange" And NeedQueryStoreOnUserChange(Parameters) Then
		If Parameters.ObjectMetadataInfo.MetadataName = "ShipmentConfirmation" Then
			// Вопрос про изменение склада в табличной части
			NotifyParameters = New Structure("Parameters", Parameters);
			ShowQueryBox(New NotifyDescription("StoreOnUserChangeContinue", ThisObject, NotifyParameters), 
				R().QuestionToUser_005, QuestionDialogMode.YesNoCancel);
			
		EndIf;
	Else
		ControllerClientServer_V2.CommitChainChanges(Parameters);
		UpdateCacheBeforeChange(Parameters.Object, Parameters.Form);
	EndIf;
EndProcedure

Function NeedQueryStoreOnUserChange(Parameters)
	If Parameters.Cache.Property("ItemList") Then
		For Each Row In Parameters.Cache.ItemList Do
			If Row.Property("Store") And ValueIsFilled(Row.Store) Then
				Return True;
			EndIf;
		EndDo;
	EndIf;
	Return False;
EndFunction

Procedure StoreOnUserChangeContinue(Answer, NotifyPrameters) Export
	If Answer = DialogReturnCode.Yes Then
		ControllerClientServer_V2.CommitChainChanges(NotifyPrameters.Parameters);
		UpdateCacheBeforeChange(NotifyPrameters.Parameters.Object,
								NotifyPrameters.Parameters.Form);
	EndIf;
EndProcedure

Function AddOrCopyRow(Object, Form, TableName, Cancel, Clone, OriginRow)
	Cancel = True;
	NewRow = Object.ItemList.Add();
	If Clone Then // Copy()
		OriginRows = GetRowsByCurrentData(Form, TableName, OriginRow);
		If Not OriginRows.Count() Then
			Raise "Not found origin row for clone";
		EndIf;
		NewRow.Key = String(New UUID());
		Rows       = GetRowsByCurrentData(Form, TableName, NewRow);
		Parameters = GetParameters(Object, Form, TableName, Rows);
		
		// колонки которые не нужно копировать
		ArrayOfExcludeProperties = New Array();
		ArrayOfExcludeProperties.Add("Key");
		If Parameters.ObjectMetadataInfo.DependencyTables.Find("RowIDInfo") <> Undefined Then
			// эти колонки реквизиты формы
			ArrayOfExcludeProperties.Add("IsExternalLinked");
			ArrayOfExcludeProperties.Add("IsInternalLinked");
			ArrayOfExcludeProperties.Add("ExternalLinks");
			ArrayOfExcludeProperties.Add("InternalLinks");
		EndIf;
		
		FillPropertyValues(NewRow, OriginRows[0], ,StrConcat(ArrayOfExcludeProperties, ","));
		
	Else // Add()
		NewRow.Key = String(New UUID());
		Rows       = GetRowsByCurrentData(Form, TableName, NewRow);
		Parameters = GetParameters(Object, Form, TableName, Rows);
		ControllerClientServer_V2.AddNewRow(TableName, Parameters);
	EndIf;
	Return NewRow;
EndFunction

Procedure DeleteRows(Object, Form, TableName)
	ServerParameters = GetServerParameters();
	ServerParameters.TableName = TableName;
	ControllerClientServer_V2.DeleteRows(TableName, _GetParameters(Object, Form, ServerParameters));
EndProcedure

#Region FORM

Procedure OnOpen(Object, Form) Export
	UpdateCacheBeforeChange(Object, Form);
	// перенести в серверный модуль
	ControllerClientServer_V2.FillPropertyFormByDefault(Form,  "Store", GetParameters(Object, Form, "ItemList"));
EndProcedure

#EndRegion

#Region ITEM_LIST

Procedure ItemListBeforeAddRow(Object, Form, Cancel, Clone, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, "ItemList", Cancel, Clone, CurrentData);
	Form.Items.ItemList.CurrentRow = NewRow.GetID();
	Form.Items.ItemList.ChangeRow();
EndProcedure

Procedure ItemListAfterDeleteRow(Object, Form) Export
	DeleteRows(Object, Form, "ItemList");
EndProcedure

#EndRegion

#Region ITEM_ITEMKEY_UNIT_QUANTITYINBASEUNIT

// При изменении реквизитов Item, ItemKey, Unit, Quantity нет никаких изменений формы, 
// видимость и доступность не изменяется, поэтому обработчиков событий OnSet() нет

// Вызывается при изменении реквизита Item в табличной части ItemList
Procedure ItemListItemOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	ControllerClientServer_V2.ItemListItemOnChange(GetParameters(Object, Form, "ItemList", Rows));
EndProcedure

// Вызывается при изменении реквизита ItemKey в табличной части ItemList
Procedure ItemListItemKeyOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	ControllerClientServer_V2.ItemListItemKeyOnChange(GetParameters(Object, Form, "ItemList", Rows));
EndProcedure

// Вызывается при изменении реквизита Unit в табличной части ItemList
Procedure ItemListUnitOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	ControllerClientServer_V2.ItemListUnitOnChange(GetParameters(Object, Form, "ItemList", Rows));
EndProcedure

// Вызывается при изменении реквизита Quantity в табличной части ItemList
// в тех случаях когда в табличной части ItemList нет сумм (NetAmount, TotalAmount)
//Procedure ItemListQuantityWithoutAmountOnChange(Object, Form, CurrentData = Undefined) Export
//	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
//	ControllerClientServer_V2.ItemListQuantityWitoutAmountOnChange(GetParameters(Object, Form, "ItemList", Rows));
//EndProcedure

#EndRegion

#Region ACCOUNT_SENDER

// Вызывается при изменении реквизита Sender
Procedure AccountSenerOnChange(Object, Form) Export
	ControllerClientServer_V2.AccountSenderOnChange(GetParameters(Object, Form, , ,"Sender"));
EndProcedure

// В старом коде при изменении ПОЛЬЗОВАТЕЛЕМ реквизита Sender вызывалась процедура
// CommonFunctionsClientServer.SetFormItemModifiedByUser(Form, Item.Name);
// эта процедура нужна для работы с формой,
// эта процедура вызывается только если ПОЛЬЗОВАТЕЛЬ изменил этот реквизит, при программном изменении она не вызывается
Procedure OnSetAccountSenderNotify_IsUserChange(Parameters) Export
	CommonFunctionsClientServer.SetFormItemModifiedByUser(Parameters.Form, "Sender");
	
	SetSendCurrencyReadOnly(Parameters);
EndProcedure

// Эта процедура вызывается только при программом изменении реквизита Receiver
Procedure OnSetAccountSenderNotify_IsProgrammChange(Parameters) Export
	SetSendCurrencyReadOnly(Parameters);
EndProcedure

// код для установки значения ReadOnly в поле Receive currency
// весь код для управления видимстью доступностью формы нуно собрать в одну процедуру
// размазывать вот так по модулям не правильно
Procedure SetSendCurrencyReadOnly(Parameters)
	AccountSenderCurrency = ServiceSystemServer.GetObjectAttribute(Parameters.Object.Sender, "Currency");
	Parameters.Form.Items.SendCurrency.ReadOnly = ValueIsFilled(AccountSenderCurrency);
EndProcedure

#EndRegion

#Region CURRENCY_SENDER

//В старом коде при ПРОГРАММНОМ изменении реквизита SendCurrency вызывался код 
//Form.Items.SendCurrency.ReadOnly = ValueIsFilled(ObjectSendCurrency);
// эта процедура нужна для работы с формой,
// эта процедура вызывается только если ПРОГРАММНО изменен реквизит, при пользовтаельском изменении она не вызывается
Procedure OnSetSendCurrencyNotify_IsProgrammChange(Parameters) Export
	// смысл кода в том что если у Account заполнено Currency то поле ReadOnly
	// этот код
	// Form.Items.SendCurrency.ReadOnly = ValueIsFilled(ObjectSendCurrency);
	// будем выполнять при изменении Account, потому что ReadOnly зависит не от значения Currency а от значения Account
	Return;
EndProcedure

#EndRegion

#Region ACCOUNT_RECEIVER

// Вызывается при изменении реквизита Receiver
Procedure AccountReceiverOnChange(Object, Form) Export
	ControllerClientServer_V2.AccountReceiverOnChange(GetParameters(Object, Form, , ,"Receiver"));
EndProcedure

// В старом коде при изменении ПОЛЬЗОВАТЕЛЕМ реквизита Receiver вызывалась процедура
// CommonFunctionsClientServer.SetFormItemModifiedByUser(Form, Item.Name);
// эта процедура нужна для работы с формой,
// эта процедура вызывается только если ПОЛЬЗОВАТЕЛЬ изменил этот реквизит, при программном изменении она не вызывается
Procedure OnSetAccountReceiverNotify_IsUserChange(Parameters) Export
	CommonFunctionsClientServer.SetFormItemModifiedByUser(Parameters.Form, "Receiver");
	
	SetReceiveCurrencyReadOnly(Parameters);
EndProcedure

// Эта процедура вызывается только при программом изменении реквизита Receiver
Procedure OnSetAccountReceiverNotify_IsProgrammChange(Parameters) Export
	SetReceiveCurrencyReadOnly(Parameters);
EndProcedure

// код для установки значения ReadOnly в поле Receive currency
// весь код для управления видимстью доступностью формы нуно собрать в одну процедуру
// размазывать вот так по модулям не правильно
Procedure SetReceiveCurrencyReadOnly(Parameters)
	AccountReceiverCurrency = ServiceSystemServer.GetObjectAttribute(Parameters.Object.Receiver, "Currency");
	Parameters.Form.Items.ReceiveCurrency.ReadOnly = ValueIsFilled(AccountReceiverCurrency);
EndProcedure

#EndRegion

#Region CURRENCY_RECEIVER

//В старом коде при ПРОГРАММНОМ изменении реквизита ReceiveCurrency вызывался код 
//Form.Items.ReceiveCurrency.ReadOnly = ValueIsFilled(ObjectReceiverCurrency);
// эта процедура нужна для работы с формой,
// эта процедура вызывается только если ПРОГРАММНО изменен реквизит, при пользовтаельском изменении она не вызывается
Procedure OnSetReceiveCurrencyNotify_IsProgrammChange(Parameters) Export
	// смысл кода в том что если у Account заполнено Currency то поле ReadOnly
	// этот код
	// Form.Items.ReceiveCurrency.ReadOnly = ValueIsFilled(ObjectReceiverCurrency);
	// будем выполнять при изменении Account, потому что ReadOnly зависит не от значения Currency а от значения Account
	Return;
EndProcedure

#EndRegion

#Region STORE

// реквизит формы
Procedure StoreOnChange(Object, Form) Export
	ServerParameters = GetServerParameters();
	ServerParameters.TableName = "ItemList";
	
	FormParameters = GetFormParameters();
	FormParameters.FormPropertyDataPathBeforeChange = "Store";
	FormParameters.EventCaller = "StoreOnUserChange";
	
	ControllerClientServer_V2.StoreOnChange(_GetParameters(Object, Form, ServerParameters, FormParameters));
EndProcedure

Procedure OnSetStoreNotify(Parameters) Export
	StoreArray = New Array();
	For Each Row In Parameters.Object.ItemList Do
		If ValueIsFilled(Row.Store) And StoreArray.Find(Row.Store) = Undefined Then
			StoreArray.Add(Row.Store);
		EndIf;
	EndDo;
	If StoreArray.Count() > 1 Then
		Parameters.Form.Items.Store.InputHint = StrConcat(StoreArray, "; ");
	EndIf;
EndProcedure

#EndRegion

#Region COMPANY

Procedure CompanyOnChange(Object, Form) Export
	ControllerClientServer_V2.CompanyOnChange(GetParameters(Object, Form, "ItemList"));
EndProcedure

Procedure OnSetCompanyNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region PARTNER

Procedure PartnerOnChange(Object, Form) Export
	ControllerClientServer_V2.PartnerOnChange(GetParameters(Object, Form, "ItemList", , "Partner"));
EndProcedure

Procedure OnSetPartnerNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region LEGAL_NAME

Procedure LegalNameOnChange(Object, Form) Export
	ControllerClientServer_V2.LegalNameOnChange(GetParameters(Object, Form, "ItemList"));
EndProcedure

Procedure OnSetLegalNameNotify(Parameters) Export
	// действия с формой при изменении LegalName
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region PRICE_INCLUDE_TAX

Procedure PriceIncludeTaxOnChange(Object, Form) Export
	ControllerClientServer_V2.PriceIncludeTaxOnChange(GetParameters(Object, Form, "ItemList"));
EndProcedure

#EndRegion

#Region ITEM_LIST

Procedure ItemListPriceTypeOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	ControllerClientServer_V2.ItemListPriceTypeOnChange(GetParameters(Object, Form, "ItemList", Rows));
EndProcedure

Procedure ItemListPriceOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	ControllerClientServer_V2.ItemListPriceOnChange(GetParameters(Object, Form, "ItemList", Rows));
EndProcedure

Procedure ItemListTotalAmountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	ControllerClientServer_V2.ItemListTotalAmountOnChange(GetParameters(Object, "ItemList", Form, Rows));
EndProcedure

Procedure ItemListStoreOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	ControllerClientServer_V2.ItemListStoreOnChange(GetParameters(Object, Form, "ItemList", Rows));
EndProcedure

#Region ITEM_LIST_QUANTITY

Procedure ItemListQuantityOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	ControllerClientServer_V2.ItemListQuantityOnChange(GetParameters(Object, Form, "ItemList", Rows));
EndProcedure

Procedure OnSetItemListQuantityNotify(Parameters) Export
	Return;
//	Object = Parameters.Object;
//	Form   = Parameters.Form;
//	// для Sales Invoice
//	SerialLotNumberClient.UpdateSerialLotNumbersTree(Object, Form);
//	DocumentsClient.UpdateTradeDocumentsTree(Object, Form, 
//	"ShipmentConfirmations", "ShipmentConfirmationsTree", "QuantityInShipmentConfirmation");
EndProcedure

#EndRegion

#EndRegion
