
#Region PARAMETERS

Function GetServerParameters(Object) Export
	Result = New Structure();
	Result.Insert("Object", Object);
	Result.Insert("ControllerModuleName", "ControllerClientServer_V2");
	Result.Insert("TableName", "");
	Result.Insert("Rows", Undefined);
	Result.Insert("ReadOnlyProperties", "");
	Return Result;
EndFunction

Function GetFormParameters(Form) Export
	Result = New Structure();
	Result.Insert("Form", Form);
	Result.Insert("ViewClientModuleName", "ViewClient_V2");
	Result.Insert("ViewServerModuleName", "ViewServer_V2");
	Result.Insert("EventCaller", "");
	Result.Insert("TaxesCache", "");
	
	If Form <> Undefined And CommonFunctionsClientServer.ObjectHasProperty(Form, "TaxesCache") Then
		Result.TaxesCache = Form.TaxesCache;
	EndIf;
	
	Result.Insert("PropertyBeforeChange", New Structure("Object, Form, List", 
		New Structure(), New Structure(), New Structure()));
	Result.PropertyBeforeChange.Object.Insert("Names"   , "");
	Result.PropertyBeforeChange.Object.Insert("DataPath", "");
	Result.PropertyBeforeChange.Object.Insert("Value"   , Undefined);

	Result.PropertyBeforeChange.Form.Insert("Names"   , "");
	Result.PropertyBeforeChange.Form.Insert("DataPath", "");
	Result.PropertyBeforeChange.Form.Insert("Value"   , Undefined);

	Result.PropertyBeforeChange.List.Insert("Names"   , "");
	Result.PropertyBeforeChange.List.Insert("DataPath", "");
	Result.PropertyBeforeChange.List.Insert("Value"   , Undefined);
	Return Result;
EndFunction

Function GetParameters(ServerParameters, FormParameters = Undefined) Export
	If FormParameters = Undefined Then
		Return CreateParameters(ServerParameters, GetFormParameters(Undefined));
	EndIf;
	Return CreateParameters(ServerParameters, FormParameters);
EndFunction

Function CreateParameters(ServerParameters, FormParameters)
	Parameters = New Structure();
	// параметры для Client 
	Parameters.Insert("Form"             , FormParameters.Form);
	Parameters.Insert("FormIsExists"     , FormParameters.Form <> Undefined);
	Parameters.Insert("FormTaxColumnsExists", FormParameters.Form <> Undefined 
		And ValueIsFilled(FormParameters.TaxesCache));
	Parameters.Insert("FormModificators" , New Array());
	Parameters.Insert("CacheForm"        , New Structure()); // кэш для реквизитов формы
	Parameters.Insert("ViewNotify"       , New Array());
	Parameters.Insert("ViewClientModuleName"   , FormParameters.ViewClientModuleName);
	Parameters.Insert("ViewServerModuleName"   , FormParameters.ViewServerModuleName);
	Parameters.Insert("EventCaller"      , FormParameters.EventCaller);
	Parameters.Insert("TaxesCache"       , FormParameters.TaxesCache);
	Parameters.Insert("ChangedData"      , New Map());
	Parameters.Insert("ExtractedData"    , New Structure());
	
	Parameters.Insert("PropertyBeforeChange", FormParameters.PropertyBeforeChange);
	
	// параметры для Server + Client
	// кэш для реквизитов объекта
	Parameters.Insert("Object" , ServerParameters.Object);
	Parameters.Insert("Cache"  , New Structure());
	Parameters.Insert("ControllerModuleName", ServerParameters.ControllerModuleName);
	
	Parameters.Insert("ReadOnlyProperties"    , ServerParameters.ReadOnlyProperties);
	Parameters.Insert("ReadOnlyPropertiesMap" , New Map());
	Parameters.Insert("ProcessedReadOnlyPropertiesMap" , New Map()); // ReadOnlyProperties для которых уже вызывались обработчики
	ArrayOfProperties = StrSplit(ServerParameters.ReadOnlyProperties, ",");
	For Each Property In ArrayOfProperties Do
		Parameters.ReadOnlyPropertiesMap.Insert(TrimAll(Property), True);
	EndDo;
	
	
	// таблицы для которых нужно получить колонки
	Parameters.Insert("TableName", ServerParameters.TableName);
	ArrayOfTableNames = New Array();
	ArrayOfTableNames.Add(ServerParameters.TableName);
	ArrayOfTableNames.Add("TaxList");
	ArrayOfTableNames.Add("SpecialOffers");
	
	// MetadataName
	// Tables.TableName.Columns
	// DependencyTables
	ObjectMetadataInfo = ViewServer_V2.GetObjectMetadataInfo(ServerParameters.Object, StrConcat(ArrayOfTableNames, ","));
	Parameters.Insert("ObjectMetadataInfo"    , ObjectMetadataInfo);
	Parameters.Insert("TaxListIsExists"       , ObjectMetadataInfo.Tables.Property("TaxList"));
	Parameters.Insert("SpecialOffersIsExists" , ObjectMetadataInfo.Tables.Property("SpecialOffers"));
	
	
	Parameters.Insert("ArrayOfTaxInfo", New Array());
	If Parameters.TaxListIsExists Then
		If Parameters.FormTaxColumnsExists Then
			DeserializedCache = CommonFunctionsServer.DeserializeXMLUseXDTO(Parameters.TaxesCache);
			Parameters.ArrayOfTaxInfo = DeserializedCache.ArrayOfTaxInfo;
		Else
			Parameters.ArrayOfTaxInfo = TaxesServer._GetArrayOfTaxInfo(ServerParameters.Object,
				ServerParameters.Object.Date, ServerParameters.Object.Company);
		EndIf;
	EndIf;
	
	// если не переданы конкретные строки то используем все что есть в таблице c именем TableName
	If ServerParameters.Rows = Undefined And ValueIsFilled(ServerParameters.TableName) Then
		ServerParameters.Rows = ServerParameters.Object[ServerParameters.TableName];
	EndIf;
	If ServerParameters.Rows = Undefined Then
		ServerParameters.Rows = New Array();
	EndIf;
	
	// строку таблицы нельзя передать на сервер, поэтому помещаем данные в массив структур
	// Rows
	ArrayOfRows = New Array();
	For Each Row In ServerParameters.Rows Do
		NewRow = New Structure(ObjectMetadataInfo.Tables[ServerParameters.TableName].Columns);
		FillPropertyValues(NewRow, Row);
		ArrayOfRows.Add(NewRow);
		
		// TaxList
		ArrayOfRowsTaxList = New Array();
		If Parameters.TaxListIsExists Then
			For Each TaxRow In ServerParameters.Object.TaxList.FindRows(New Structure("Key", Row.Key)) Do
				NewRowTaxList = New Structure(ObjectMetadataInfo.Tables.TaxList.Columns);
				FillPropertyValues(NewRowTaxList, TaxRow);
				ArrayOfRowsTaxList.Add(NewRowTaxList);
			EndDo;
		EndIf;
		
		// TaxRates
		TaxRates = New Structure();
		For Each ItemOfTaxInfo In Parameters.ArrayOfTaxInfo Do
			// когда нет формы то нет и колонки созданной программно
			If Parameters.FormTaxColumnsExists Then
				TaxRates.Insert(ItemOfTaxInfo.Name, Row[ItemOfTaxInfo.Name]);
			Else
			// создадим псевдо колонки для ставок налога
				NewRow.Insert(ItemOfTaxInfo.Name);
				
				// ставки налогов берем из таблицы TaxList
				TaxRate = Undefined;
				For Each TaxRow In ArrayOfRowsTaxList Do
					If TaxRow.Tax = ItemOfTaxInfo.Tax Then
						TaxRate = TaxRow.TaxRate;
						Break;
					EndIf;
				EndDo;
				TaxRates.Insert(ItemOfTaxInfo.Name, TaxRate);
			EndIf;
		EndDo;
		
		// SpecialOffers
		ArrayOfRowsSpecialOffers = New Array();
		If Parameters.SpecialOffersIsExists Then
			For Each SpecialOfferRow In ServerParameters.Object.SpecialOffers.FindRows(New Structure("Key", Row.Key)) Do
				NewRowSpecialOffer = New Structure(ObjectMetadataInfo.Tables.SpecialOffers.Columns);
				FillPropertyValues(NewRowSpecialOffer, SpecialOfferRow);
				ArrayOfRowsSpecialOffers.Add(NewRowSpecialOffer);
			EndDo;
		EndIf;
		
		NewRow.Insert("TaxRates"      , TaxRates);
		NewRow.Insert("TaxList"       , ArrayOfRowsTaxList);
		NewRow.Insert("SpecialOffers" , ArrayOfRowsSpecialOffers);
	EndDo;
	
	If ArrayOfRows.Count() Then
		Parameters.Insert("Rows", ArrayOfRows);
	EndIf;
	Return Parameters;
EndFunction

#EndRegion

#IF Client THEN

Procedure FillPropertyFormByDefault(Form, DataPaths, Parameters) Export
	ArrayOfDataPath = StrSplit(DataPaths, ",");
	
	Bindings = GetAllBindings(Parameters);
	Defaults = GetAllFillByDefault(Parameters);
	
	For Each DataPath In ArrayOfDataPath Do
		DataPath = TrimAll(DataPath);
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
	EndDo;
	If ForceCommintChanges Then
		CommitChainChanges(Parameters);
	EndIf;
EndProcedure

#ENDIF

#Region API

// реквизиты которые доступны через API
Function GetSetterNameByDataPath(DataPath)
	SettersMap = New Map();
	SettersMap.Insert("Sender"          , "SetAccountSender");
	SettersMap.Insert("SendCurrency"    , "SetSendCurrency");
	SettersMap.Insert("Receiver"        , "SetAccountReceiver");
	SettersMap.Insert("ReceiveCurrency" , "SetReceiveCurrency");
	SettersMap.Insert("Account"         , "SetAccount");
	SettersMap.Insert("CashAccount"     , "SetAccount");
	SettersMap.Insert("Currency"        , "SetCurrency");
	SettersMap.Insert("Date"            , "SetDate");
	SettersMap.Insert("Company"         , "SetCompany");
	SettersMap.Insert("Partner"         , "SetPartner");
	SettersMap.Insert("LegalName"       , "SetLegalName");
	SettersMap.Insert("Agreement"       , "SetAgreement");
	SettersMap.Insert("ManagerSegment"  , "SetManagerSegment");
	SettersMap.Insert("PriceIncludeTax" , "SetPriceIncludeTax");
	
	// PaymentList
	SettersMap.Insert("PaymentList.Partner" , "SetPaymentListPartner");
	SettersMap.Insert("PaymentList.Payer"   , "SetPaymentListLegalName");
	SettersMap.Insert("PaymentList.Payee"   , "SetPaymentListLegalName");
	
	// ItemList
	SettersMap.Insert("ItemList.ItemKey"            , "SetItemListItemKey");
	SettersMap.Insert("ItemList.Unit"               , "SetItemListUnit");
	SettersMap.Insert("ItemList.PriceType"          , "SetItemListPriceType");
	SettersMap.Insert("ItemList.Price"              , "SetItemListPrice");
	SettersMap.Insert("ItemList.DontCalculateRow"   , "SetItemListDontCalculateRow");
	SettersMap.Insert("ItemList.Quantity"           , "SetItemListQuantity");
	SettersMap.Insert("ItemList.Store"              , "SetItemListStore");
	SettersMap.Insert("ItemList.DeliveryDate"       , "SetItemListDeliveryDate");
	SettersMap.Insert("ItemList.QuantityInBaseUnit" , "SetItemListQuantityInBaseUnit");
	Return SettersMap.Get(DataPath);
EndFunction

Procedure API_SetProperty(Parameters, Property, Value) Export
	SetterName = GetSetterNameByDataPath(Property.DataPath);
	_Key = Undefined;
	If StrSplit(Property.DataPath, ".").Count() = 2 Then
		_Key = Parameters.Rows[0].Key;
	EndIf;
	If SetterName <> Undefined Then
		Results = New Array();
		Results.Add(New Structure("Options, Value", 
			New Structure("Key", _Key), Value));
		Execute StrTemplate("%1(Parameters, Results);", SetterName);
	Else
		SetPropertyObject(Parameters, Property.DataPath, _Key, Value);
		CommitChainChanges(Parameters);
	EndIf;
EndProcedure
	
#EndRegion

Function GetAllBindings(Parameters)
	BindingMap = New Map();
	BindingMap.Insert("Company"   , CompanyStepsBinding(Parameters));
	BindingMap.Insert("Account"   , AccountStepsBinding(Parameters));
	BindingMap.Insert("Partner"   , PartnerStepsBinding(Parameters));
	BindingMap.Insert("LegalName" , LegalNameStepsBinding(Parameters));
	BindingMap.Insert("Currency"  , CurrencyStepsBinding(Parameters));
	
	BindingMap.Insert("ItemList.Item"     , ItemListItemStepsBinding(Parameters));
	BindingMap.Insert("ItemList.ItemKey"  , ItemListItemKeyStepsBinding(Parameters));
	BindingMap.Insert("ItemList.Unit"     , ItemListUnitStepsBinding(Parameters));
	BindingMap.Insert("ItemList.Quantity" , ItemListQuantityStepsBinding(Parameters));
	Return BindingMap;
EndFunction

Function GetAllFillByDefault(Parameters)
	Binding = New Map();
	Binding.Insert("Store"        , StoreDefaultBinding(Parameters));
	Binding.Insert("DeliveryDate" , DeliveryDateDefaultBinding(Parameters));
	
	Binding.Insert("ItemList.Store"        , ItemListStoreDefaultBinding(Parameters));
	Binding.Insert("ItemList.DeliveryDate" , ItemListDeliveryDateDefaultBinding(Parameters));
	Binding.Insert("ItemList.Quantity"     , ItemListQuantityDefaultBinding(Parameters));
	Return Binding;
EndFunction

Procedure StepsEnablerEmpty(Parameters, Chain) Export
	Return;
EndProcedure

#Region _FORM_

// Form.OnCreateAtServer
Procedure FormOnCreateAtServer(Parameters) Export
	Binding = FormOnCreateAtServerStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Form.OnCreateAtServer.Bind
Function FormOnCreateAtServerStepsBinding(Parameters)
	DataPath = "";
	Binding = New Structure();
	Binding.Insert("SalesInvoice", "StepsEnabler_ItemListEnableCalculations_RecalculationsOnCopy,
									|StepsEnabler_RequireCallCreateTaxesFormControls");
									
	Binding.Insert("BankPayment" , "StepsEnabler_PaymentListEnableCalculations_RecalculationsOnCopy,
									|StepsEnabler_RequireCallCreateTaxesFormControls");

	Binding.Insert("BankReceipt" , "StepsEnabler_PaymentListEnableCalculations_RecalculationsOnCopy,
									|StepsEnabler_RequireCallCreateTaxesFormControls");
	
	Binding.Insert("CashPayment" , "StepsEnabler_PaymentListEnableCalculations_RecalculationsOnCopy,
									|StepsEnabler_RequireCallCreateTaxesFormControls");

	Binding.Insert("CashReceipt" , "StepsEnabler_PaymentListEnableCalculations_RecalculationsOnCopy,
									|StepsEnabler_RequireCallCreateTaxesFormControls");

	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

// Form.Modificator
Procedure FormModificator_CreateTaxesFormControls(Parameters, Results) Export
	If Results[0].Value Then
		Parameters.FormModificators.Add("FormModificator_CreateTaxesFormControls");
	EndIf;
EndProcedure

Procedure StepsEnabler_RequireCallCreateTaxesFormControls(Parameters, Chain) Export
	// RequireCallCreateTaxesFormControls
	Chain.RequireCallCreateTaxesFormControls.Enable = True;
	Chain.RequireCallCreateTaxesFormControls.Setter = "FormModificator_CreateTaxesFormControls";
	Options = ModelClientServer_V2.RequireCallCreateTaxesFormControlsOptions();
	Options.Ref            = Parameters.Object.Ref;
	Options.Date           = GetPropertyObject(Parameters, "Date");
	Options.Company        = GetPropertyObject(Parameters, "Company");
	Options.ArrayOfTaxInfo = Parameters.ArrayOfTaxInfo;
	Options.FormTaxColumnsExists = Parameters.FormTaxColumnsExists;
	Chain.RequireCallCreateTaxesFormControls.Options.Add(Options);
EndProcedure

Procedure StepsEnabler_ItemListEnableCalculations_RecalculationsOnCopy(Parameters, Chain) Export
	// при копировании документа нужно перерасчитать TaxAmount
	If Parameters.FormIsExists And ValueIsFilled(Parameters.Form.Parameters.CopyingValue) Then
		ItemListEnableCalculations(Parameters, Chain, "RecalculationsOnCopy");
	EndIf;
EndProcedure

Procedure StepsEnabler_PaymentListEnableCalculations_RecalculationsOnCopy(Parameters, Chain) Export
	// при копировании документа нужно перерасчитать TaxAmount
	If Parameters.FormIsExists And ValueIsFilled(Parameters.Form.Parameters.CopyingValue) Then
		PaymentListEnableCalculations(Parameters, Chain, "RecalculationsOnCopy");
	EndIf;
EndProcedure

// Form.OnOpen
Procedure FormOnOpen(Parameters) Export
	AddViewNotify("OnOpenFormNotify", Parameters);
	Binding = FormOnOpenStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Form.OnOpen.Bind
Function FormOnOpenStepsBinding(Parameters)
	DataPath = "";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation"      , "OnOpenStepsEnabler_WithSerialLotNumbers");
	Binding.Insert("GoodsReceipt"              , "OnOpenStepsEnabler_WithSerialLotNumbers");
	Binding.Insert("StockAdjustmentAsSurplus"  , "OnOpenStepsEnabler_WithSerialLotNumbers");
	Binding.Insert("StockAdjustmentAsWriteOff" , "OnOpenStepsEnabler_WithSerialLotNumbers");
	Binding.Insert("SalesInvoice"              , "OnOpenStepsEnabler_WithSerialLotNumbers");
	Return BindSteps("StepsEnablerEmpty"       , DataPath, Binding, Parameters);
EndFunction

Procedure OnOpenStepsEnabler_WithSerialLotNumbers(Parameters, Chain) Export
	StepsEnablerName = "OnOpenStepsEnabler_WithSerialLotNumbers";
	
	// ExtractDataItemKeysWithSerialLotNumbers
	Chain.ExtractDataItemKeysWithSerialLotNumbers.Enable = True;
	Chain.ExtractDataItemKeysWithSerialLotNumbers.Setter = "SetExtractDataItemKeysWithSerialLotNumbers";
	For Each Row In Parameters.Object.ItemList Do
		Options = ModelClientServer_V2.ExtractDataItemKeysWithSerialLotNumbersOptions();
		Options.ItemKey = GetPropertyObject(Parameters, "ItemList.ItemKey", Row.Key);
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Options.DontExecuteIfExecutedBefore = True;
		Chain.ExtractDataItemKeysWithSerialLotNumbers.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region _LIST_

#Region _LIST_ADD

Procedure AddNewRow(TableName, Parameters, ViewNotify = Undefined) Export
	If ViewNotify <> Undefined Then
		AddViewNotify(ViewNotify, Parameters);
	EndIf;
	
	NewRow = Parameters.Rows[0];
	UserSettingsClientServer.FillingRowFromSettings(Parameters.Object, StrTemplate("Object.%1", TableName), NewRow, True);
	Parameters.Insert("RowFilledByUserSettings", NewRow);
	
	Bindings = GetAllBindings(Parameters);
	Defaults = GetAllFillByDefault(Parameters);
	
	ForceCommintChanges = True;
	For Each ColumnName In StrSplit(Parameters.ObjectMetadataInfo.Tables[TableName].Columns, ",") Do
		
		// у колонки есть собственный обработчик .Default вызываем его
		DataPath = StrTemplate("%1.%2", TableName, ColumnName);
		Default = Defaults.Get(DataPath);
		If Default<> Undefined Then
			ForceCommintChanges = False;
			ModelClientServer_V2.EntryPoint(Default.StepsEnabler, Parameters);

		// если колонка заполнена, и у нее есть обработчик .OnChage, вызываем его
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

#EndRegion

#Region _LIST_DELETE

Procedure DeleteRows(TableName, Parameters, ViewNotify = Undefined) Export
	If ViewNotify <> Undefined Then
		AddViewNotify(ViewNotify, Parameters);
	EndIf;
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
	// выполняем обработчики после удаления строки
	Binding = ListOnDeleteStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// <TableName>.OnDelete.Bind
Function ListOnDeleteStepsBinding(Parameters)
	DataPath = "";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation", "ItemListOnDeleteStepsEnabler_ShipmentReceipt");
	Binding.Insert("GoodsReceipt"        , "ItemListOnDeleteStepsEnabler_ShipmentReceipt");
	Binding.Insert("SalesInvoice"        , "ItemListOnDeleteStepsEnabler_Trade_Shipment");
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

Procedure ItemListOnDeleteStepsEnabler_ShipmentReceipt(Parameters, Chain) Export
	// ChangeStoreInHeaderByStoresInList
	Chain.ChangeStoreInHeaderByStoresInList.Enable = True;
	Chain.ChangeStoreInHeaderByStoresInList.Setter = "SetStore";
	
	Options = ModelClientServer_V2.ChangeStoreInHeaderByStoresInListOptions();
	ArrayOfStoresInList = New Array();
	For Each Row In Parameters.Object.ItemList Do
		NewRow = New Structure();
		NewRow.Insert("Store"   , GetPropertyObject(Parameters, "ItemList.Store", Row.Key));
		NewRow.Insert("ItemKey" , GetPropertyObject(Parameters, "ItemList.ItemKey", Row.Key));
		ArrayOfStoresInList.Add(NewRow);
	EndDo;
	Options.ArrayOfStoresInList = ArrayOfStoresInList; 
	Chain.ChangeStoreInHeaderByStoresInList.Options.Add(Options);
EndProcedure

Procedure ItemListOnDeleteStepsEnabler_Trade_Shipment(Parameters, Chain) Export
	// ChangeStoreInHeaderByStoresInList
	Chain.ChangeStoreInHeaderByStoresInList.Enable = True;
	Chain.ChangeStoreInHeaderByStoresInList.Setter = "SetStore";
	
	Options = ModelClientServer_V2.ChangeStoreInHeaderByStoresInListOptions();
	ArrayOfStoresInList = New Array();
	For Each Row In Parameters.Object.ItemList Do
		NewRow = New Structure();
		NewRow.Insert("Store"   , GetPropertyObject(Parameters, "ItemList.Store", Row.Key));
		NewRow.Insert("ItemKey" , GetPropertyObject(Parameters, "ItemList.ItemKey", Row.Key));
		ArrayOfStoresInList.Add(NewRow);
	EndDo;
	Options.ArrayOfStoresInList = ArrayOfStoresInList; 
	Chain.ChangeStoreInHeaderByStoresInList.Options.Add(Options);
	
	// UpdatePaymentTerms
	Chain.UpdatePaymentTerms.Enable = True;
	Chain.UpdatePaymentTerms.Setter = "SetPaymentTerms";
	Options = ModelClientServer_V2.UpdatePaymentTermsOptions();
	Options.Date = GetPropertyObject(Parameters, "Date");
	Options.ArrayOfPaymentTerms = GetPaymentTerms(Parameters);
	// нужны все строки таблицы
	TotalAmount = 0;
	For Each Row In Parameters.Object.ItemList Do
		TotalAmount = TotalAmount + GetPropertyObject(Parameters, "ItemList.TotalAmount", Row.Key);
	EndDo;
	Options.TotalAmount = TotalAmount;
	Chain.UpdatePaymentTerms.Options.Add(Options);
EndProcedure

#EndRegion

#Region _LIST_COPY

Procedure CopyRow(TableName, Parameters, ViewNotify = Undefined) Export
	If ViewNotify <> Undefined Then
		AddViewNotify(ViewNotify, Parameters);
	EndIf;
	// выполняем обработчики после копирования строки
	Binding = ListOnCopyStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// <TableName>.OnCopy.Bind
Function ListOnCopyStepsBinding(Parameters)
	DataPath = "";
	Binding = New Structure();
	Binding.Insert("SalesInvoice" , "ItemListOnCopyStepsEnabler_Trade_Shipment");
	Binding.Insert("BankPayment"  , "ItemListOnCopyStepsEnabler_BankCashPaymentReceipt");
	Binding.Insert("BankReceipt"  , "ItemListOnCopyStepsEnabler_BankCashPaymentReceipt");
	Binding.Insert("CashPayment"  , "ItemListOnCopyStepsEnabler_BankCashPaymentReceipt");
	Binding.Insert("CashReceipt"  , "ItemListOnCopyStepsEnabler_BankCashPaymentReceipt");
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

Procedure ItemListOnCopyStepsEnabler_Trade_Shipment(Parameters, Chain) Export
	ItemListEnableCalculations(Parameters, Chain, "IsCopyRow");
	// UpdatePaymentTerms
	Chain.UpdatePaymentTerms.Enable = True;
	Chain.UpdatePaymentTerms.Setter = "SetPaymentTerms";
	Options = ModelClientServer_V2.UpdatePaymentTermsOptions();
	Options.Date = GetPropertyObject(Parameters, "Date");
	Options.ArrayOfPaymentTerms = GetPaymentTerms(Parameters);
	// нужны все строки таблицы
	TotalAmount = 0;
	For Each Row In Parameters.Object.ItemList Do
		TotalAmount = TotalAmount + GetPropertyObject(Parameters, "ItemList.TotalAmount", Row.Key);
	EndDo;
	Options.TotalAmount = TotalAmount;
	Chain.UpdatePaymentTerms.Options.Add(Options);
EndProcedure

Procedure ItemListOnCopyStepsEnabler_BankCashPaymentReceipt(Parameters, Chain) Export
	PaymentListEnableCalculations(Parameters, Chain, "IsCopyRow");
EndProcedure

#EndRegion

#EndRegion

#Region _EXTRACT_DATA_

Procedure SetExtractDataItemKeyIsService(Parameters, Results) Export
	Parameters.ExtractedData.Insert("DataItemKeyIsService", New Array());
	For Each Result In Results Do
		NewRow = New Structure();
		NewRow.Insert("Key"       , Result.Options.Key);
		NewRow.Insert("IsService" , Result.Value);
		Parameters.ExtractedData.DataItemKeyIsService.Add(NewRow);
	EndDo;
EndProcedure

Procedure SetExtractDataItemKeysWithSerialLotNumbers(Parameters, Results) Export
	Parameters.ExtractedData.Insert("ItemKeysWithSerialLotNumbers", New Array());
	For Each Result In Results Do
		If Result.Value Then // have serial lot numbers
			Parameters.ExtractedData.ItemKeysWithSerialLotNumbers.Add(Result.Options.ItemKey);
		EndIf;
	EndDo;
EndProcedure

Procedure SetExtractDataAgreementApArPostingDetail(Parameters, Results) Export
	Parameters.ExtractedData.Insert("DataAgreementApArPostingDetail", New Array());
	For Each Result In Results Do
		NewRow = New Structure();
		NewRow.Insert("Key"               , Result.Options.Key);
		NewRow.Insert("ApArPostingDetail" , Result.Value);
		Parameters.ExtractedData.DataAgreementApArPostingDetail.Add(NewRow);
	EndDo;
EndProcedure

#EndRegion

#Region RECALCULATION_AFTER_QUESTIONS_TO_USER

// RecalculationsAfterQuestionToUser.Call
Procedure RecalculationsAfterQuestionToUser(Parameters) Export
	Binding = RecalculationsAfterQuestionToUserStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// RecalculationsAfterQuestionToUser.Bind
Function RecalculationsAfterQuestionToUserStepsBinding(Parameters)
	DataPath = "";
	Binding = New Structure();
	Binding.Insert("SalesInvoice", "RecalculationsAfterQuestionToUserStepsEnabler");
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

Procedure RecalculationsAfterQuestionToUserStepsEnabler(Parameters, Chain) Export
	ItemListEnableCalculations(Parameters, Chain, "RecalculationsAfterQuestionToUser");
	
	// UpdatePaymentTerms
	Chain.UpdatePaymentTerms.Enable = True;
	Chain.UpdatePaymentTerms.Setter = "SetPaymentTerms";
	Options = ModelClientServer_V2.UpdatePaymentTermsOptions();
	Options.Date = GetPropertyObject(Parameters, "Date");
	Options.ArrayOfPaymentTerms = GetPaymentTerms(Parameters);
	// нужны все строки таблицы
	TotalAmount = 0;
	For Each Row In Parameters.Object.ItemList Do
		TotalAmount = TotalAmount + GetPropertyObject(Parameters, "ItemList.TotalAmount", Row.Key);
	EndDo;
	Options.TotalAmount = TotalAmount;
	Chain.UpdatePaymentTerms.Options.Add(Options);
EndProcedure

#EndRegion

#Region ACCOUNT_SENDER

// AccountSender.OnChange
Procedure AccountSenderOnChange(Parameters) Export
	ProceedPropertyBeforeChange_Object(Parameters);
	AddViewNotify("OnSetAccountSenderNotify_IsUserChange", Parameters);
	Binding = AccountSenderStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// AccountSender.Set
Procedure SetAccountSender(Parameters, Results) Export
	Binding = AccountSenderStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// AccountSender.Bind
Function AccountSenderStepsBinding(Parameters)
	DataPath = "Sender";
	Binding = New Structure();
	Return BindSteps("AccountSenderStepsEnabler", DataPath, Binding, Parameters);
EndFunction

Procedure AccountSenderStepsEnabler(Parameters, Chain) Export
	// ChangeCurrencyByAccount
	Chain.ChangeCurrencyByAccount.Enable = True;
	Chain.ChangeCurrencyByAccount.Setter = "SetSendCurrency";
	Options = ModelClientServer_V2.ChangeCurrencyByAccountOptions();
	Options.Account = GetPropertyObject(Parameters, "Sender");
	Options.CurrentCurrency = GetPropertyObject(Parameters, "SendCurrency");
	Chain.ChangeCurrencyByAccount.Options.Add(Options);
EndProcedure

#EndRegion

#Region SEND_CURRENCY

// SendCurrency.OnChange
Procedure SendCurrencyOnChange(Parameters) Export
	Binding = SendCurrencyStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// SendCurrency.Set
Procedure SetSendCurrency(Parameters, Results) Export
	Binding = SendCurrencyStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetSendCurrencyNotify_IsProgrammChange");
EndProcedure

// SendCurrency.Bind
Function SendCurrencyStepsBinding(Parameters)
	DataPath = "SendCurrency";
	Binding = New Structure();
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region ACCOUNT_RECEIVER

// AccountReceiver.OnChange
Procedure AccountReceiverOnChange(Parameters) Export
	ProceedPropertyBeforeChange_Object(Parameters);
	AddViewNotify("OnSetAccountReceiverNotify_IsUserChange", Parameters);
	Binding = AccountReceiverStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// AccountReceiver.Set
Procedure SetAccountReceiver(Parameters, Results) Export
	Binding = AccountReceiverStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// AccountReceiver.Bind
Function AccountReceiverStepsBinding(Parameters)
	DataPath = "Receiver";
	Binding = New Structure();
	Return BindSteps("AccountReceiverStepsEnabler", DataPath, Binding, Parameters);
EndFunction

Procedure AccountReceiverStepsEnabler(Parameters, Chain) Export
	// ChangeCurrencyByAccount
	Chain.ChangeCurrencyByAccount.Enable = True;
	Chain.ChangeCurrencyByAccount.Setter = "SetReceiveCurrency";
	Options = ModelClientServer_V2.ChangeCurrencyByAccountOptions();
	Options.Account = GetPropertyObject(Parameters, "Receiver");
	Options.CurrentCurrency = GetPropertyObject(Parameters, "ReceiveCurrency");
	Chain.ChangeCurrencyByAccount.Options.Add(Options);
EndProcedure

#EndRegion

#Region RECEIVE_CURRENCY

// ReceiveCurrency.OnChange
Procedure ReceiveCurrencyOnChange(Parameters) Export
	Binding = ReceiveCurrencyStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ReceiveCurrency.Set
Procedure SetReceiveCurrency(Parameters, Results) Export
	Binding = ReceiveCurrencyStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetReceiveCurrencyNotify_IsProgrammChange");
EndProcedure

// ReceiveCurrency.Bind
Function ReceiveCurrencyStepsBinding(Parameters)
	DataPath = "ReceiveCurrency";
	Binding = New Structure();
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region ACCOUNT

// Account.OnChange
Procedure AccountOnChange(Parameters) Export
	ProceedPropertyBeforeChange_Object(Parameters);
	AddViewNotify("OnSetAccountNotify", Parameters);
	Binding = AccountStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Account.Set
Procedure SetAccount(Parameters, Results) Export
	Binding = AccountStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetAccountNotify");
EndProcedure

// TransitAccount.Set
Procedure SetTransitAccount(Parameters, Results) Export
	Binding = TransitAccountStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Account.Bind
Function AccountStepsBinding(Parameters)
	DataPath = New Map();
	DataPath.Insert("IncomingPaymentOrder", "Account");
	DataPath.Insert("OutgoingPaymentOrder", "Account");
	DataPath.Insert("BankPayment", "Account");
	DataPath.Insert("BankReceipt", "Account");
	DataPath.Insert("CashPayment", "CashAccount");
	DataPath.Insert("CashReceipt", "CashAccount");
	
	Binding = New Structure();
	Binding.Insert("IncomingPaymentOrder", "StepsEnabler_ChangeCurrencyByAccount");
	Binding.Insert("OutgoingPaymentOrder", "StepsEnabler_ChangeCurrencyByAccount");
	
	Binding.Insert("BankPayment"         , "StepsEnabler_ChangeCurrencyByAccount,
											|StepsEnabler_ChangeTransitAccountByAccount");

	Binding.Insert("BankReceipt"         , "StepsEnabler_ChangeCurrencyByAccount,
											|StepsEnabler_ChangeTransitAccountByAccount");
	
	Binding.Insert("CashPayment", "StepsEnabler_ChangeCurrencyByCashAccount");
	Binding.Insert("CashReceipt", "StepsEnabler_ChangeCurrencyByCashAccount");
	
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

// TransitAccount.Bind
Function TransitAccountStepsBinding(Parameters)
	DataPath = "TransitAccount";
	Binding = New Structure();
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

Procedure StepsEnabler_ChangeCurrencyByAccount(Parameters, Chain) Export
	StepsEnablerName = "StepsEnabler_ChangeCurrencyByAccount";
	
	// ChangeCurrencyByAccount
	Chain.ChangeCurrencyByAccount.Enable = True;
	Chain.ChangeCurrencyByAccount.Setter = "SetCurrency";
	Options = ModelClientServer_V2.ChangeCurrencyByAccountOptions();
	Options.Account         = GetPropertyObject(Parameters, "Account");
	Options.CurrentCurrency = GetPropertyObject(Parameters, "Currency");
	Options.StepsEnablerName = StepsEnablerName;
	Chain.ChangeCurrencyByAccount.Options.Add(Options);
EndProcedure

Procedure StepsEnabler_ChangeCurrencyByCashAccount(Parameters, Chain) Export
	StepsEnablerName = "StepsEnabler_ChangeCurrencyByCashAccount";
	
	// ChangeCurrencyByAccount
	Chain.ChangeCurrencyByAccount.Enable = True;
	Chain.ChangeCurrencyByAccount.Setter = "SetCurrency";
	Options = ModelClientServer_V2.ChangeCurrencyByAccountOptions();
	Options.Account         = GetPropertyObject(Parameters, "CashAccount");
	Options.CurrentCurrency = GetPropertyObject(Parameters, "Currency");
	Options.StepsEnablerName = StepsEnablerName;
	Chain.ChangeCurrencyByAccount.Options.Add(Options);
EndProcedure

Procedure StepsEnabler_ChangeTransitAccountByAccount(Parameters, Chain) Export
	StepsEnablerName = "StepsEnabler_ChangeTransitAccountByAccount";
	
	Options_Account  = GetPropertyObject(Parameters, "Account");
//	Options_Currency = GetPropertyObject(Parameters, "Currency");
	Options_TransactionType = GetPropertyObject(Parameters, "TransactionType");
	Options_TransitAccount  = GetPropertyObject(Parameters, "TransitAccount");
	
//	// ChangeCurrencyByAccount
//	Chain.ChangeCurrencyByAccount.Enable = True;
//	Chain.ChangeCurrencyByAccount.Setter = "SetCurrency";
//	Options = ModelClientServer_V2.ChangeCurrencyByAccountOptions();
//	Options.Account         = Options_Account;
//	Options.CurrentCurrency = Options_Currency;
//	Options.StepsEnablerName = StepsEnablerName;
//	Chain.ChangeCurrencyByAccount.Options.Add(Options);
	
	// ChangeTransitAccountByAccount
	Chain.ChangeTransitAccountByAccount.Enable = True;
	Chain.ChangeTransitAccountByAccount.Setter = "SetTransitAccount";
	Options = ModelClientServer_V2.ChangeTransitAccountByAccountOptions();
	Options.TransactionType       = Options_TransactionType;
	Options.Account               = Options_Account;
	Options.CurrentTransitAccount = Options_TransitAccount;
	Options.StepsEnablerName = StepsEnablerName;
	Chain.ChangeTransitAccountByAccount.Options.Add(Options);
EndProcedure

#EndRegion

#Region TRANSACTION_TYPE

// TransactionType.OnChange
Procedure TransactionTypeOnChange(Parameters) Export
	ProceedPropertyBeforeChange_Object(Parameters);
	AddViewNotify("OnSetTransactionTypeNotify", Parameters);
	Binding = TransactionTypeStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// TransactionType.Set
Procedure SetTransactionType(Parameters, Results) Export
	Binding = TransactionTypeStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetTransactionTypeNotify");
EndProcedure

// TransactionType.Bind
Function TransactionTypeStepsBinding(Parameters)
	DataPath = "Account";
	Binding = New Structure();
	Binding.Insert("BankPayment" , "StepsEnabler_ChangeTransitAccountByAccount,
									|StepsEnabler_ClearByTransactionTypeBankPayment");

	Binding.Insert("BankReceipt" , "StepsEnabler_ChangeTransitAccountByAccount,
									|StepsEnabler_ClearByTransactionTypeBankReceipt");
	
	Binding.Insert("CashPayment" , "StepsEnabler_ClearByTransactionTypeCashPayment");
	Binding.Insert("CashReceipt" , "StepsEnabler_ClearByTransactionTypeCashReceipt");
	
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

// TransactionType.BankPayment.Fill
Procedure FillTransactionType_BankPayment(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Partner"                  , PaymentListPartnerStepsBinding(Parameters));
	ResourceToBinding.Insert("Payee"                    , PaymentListLegalNameStepsBinding(Parameters));
	ResourceToBinding.Insert("Agreement"                , PaymentListAgreementStepsBinding(Parameters));
	ResourceToBinding.Insert("LegalNameContract"        , PaymentListLegalNameContractStepsBinding(Parameters));
	ResourceToBinding.Insert("BasisDocument"            , PaymentListBasisDocumentStepsBinding(Parameters));
	ResourceToBinding.Insert("PlanningTransactionBasis" , PaymentListPlanningTransactionBasisStepsBinding(Parameters));
	ResourceToBinding.Insert("Order"                    , PaymentListOrderStepsBinding(Parameters));
	ResourceToBinding.Insert("TransitAccount"           , TransitAccountStepsBinding(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// TransactionType.BankReceipt.Fill
Procedure FillTransactionType_BankReceipt(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Partner"                  , PaymentListPartnerStepsBinding(Parameters));
	ResourceToBinding.Insert("Payer"                    , PaymentListLegalNameStepsBinding(Parameters));
	ResourceToBinding.Insert("Agreement"                , PaymentListAgreementStepsBinding(Parameters));
	ResourceToBinding.Insert("LegalNameContract"        , PaymentListLegalNameContractStepsBinding(Parameters));
	ResourceToBinding.Insert("BasisDocument"            , PaymentListBasisDocumentStepsBinding(Parameters));
	ResourceToBinding.Insert("PlanningTransactionBasis" , PaymentListPlanningTransactionBasisStepsBinding(Parameters));
	ResourceToBinding.Insert("Order"                    , PaymentListOrderStepsBinding(Parameters));
	ResourceToBinding.Insert("AmountExchange"           , PaymentListAmountExchangeStepsBinding(Parameters));
	ResourceToBinding.Insert("POSAccount"               , PaymentListPOSAccountStepsBinding(Parameters));
	ResourceToBinding.Insert("TransitAccount"           , TransitAccountStepsBinding(Parameters));
	ResourceToBinding.Insert("CurrencyExchange"         , CurrencyExchangeStepsBinding(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// TransactionType.CashPayment.Fill
Procedure FillTransactionType_CashPayment(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Partner"                  , PaymentListPartnerStepsBinding(Parameters));
	ResourceToBinding.Insert("Payee"                    , PaymentListLegalNameStepsBinding(Parameters));
	ResourceToBinding.Insert("Agreement"                , PaymentListAgreementStepsBinding(Parameters));
	ResourceToBinding.Insert("LegalNameContract"        , PaymentListLegalNameContractStepsBinding(Parameters));
	ResourceToBinding.Insert("BasisDocument"            , PaymentListBasisDocumentStepsBinding(Parameters));
	ResourceToBinding.Insert("PlanningTransactionBasis" , PaymentListPlanningTransactionBasisStepsBinding(Parameters));
	ResourceToBinding.Insert("Order"                    , PaymentListOrderStepsBinding(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// TransactionType.CashReceipt.Fill
Procedure FillTransactionType_CashReceipt(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Partner"                  , PaymentListPartnerStepsBinding(Parameters));
	ResourceToBinding.Insert("Payer"                    , PaymentListLegalNameStepsBinding(Parameters));
	ResourceToBinding.Insert("Agreement"                , PaymentListAgreementStepsBinding(Parameters));
	ResourceToBinding.Insert("LegalNameContract"        , PaymentListLegalNameContractStepsBinding(Parameters));
	ResourceToBinding.Insert("BasisDocument"            , PaymentListBasisDocumentStepsBinding(Parameters));
	ResourceToBinding.Insert("PlanningTransactionBasis" , PaymentListPlanningTransactionBasisStepsBinding(Parameters));
	ResourceToBinding.Insert("Order"                    , PaymentListOrderStepsBinding(Parameters));
	ResourceToBinding.Insert("AmountExchange"           , PaymentListAmountExchangeStepsBinding(Parameters));
	ResourceToBinding.Insert("CurrencyExchange"         , CurrencyExchangeStepsBinding(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

Procedure StepsEnabler_ClearByTransactionTypeBankPayment(Parameters, Chain) Export
	StepsEnablerName = "StepsEnabler_ClearByTransactionTypeBankPayment";
	
	Options_TransactionType = GetPropertyObject(Parameters, "TransactionType");
	Options_TransitAccount  = GetPropertyObject(Parameters, "TransitAccount");
	
	// ClearByTransactionTypeBankPayment
	Chain.ClearByTransactionTypeBankPayment.Enable = True;
	Chain.ClearByTransactionTypeBankPayment.Setter = "FillTransactionType_BankPayment";
	
	For Each Row In GetRows(Parameters, "PaymentList") Do
		// ClearByTransactionTypeBankPayment
		Options = ModelClientServer_V2.ClearByTransactionTypeBankPaymentOptions();
		Options.TransactionType          = Options_TransactionType;
		Options.TransitAccount           = Options_TransitAccount;
		Options.Partner                  = GetPropertyObject(Parameters, "PaymentList.Partner"                 , Row.Key);
		Options.Payee                    = GetPropertyObject(Parameters, "PaymentList.Payee"                   , Row.Key);
		Options.Agreement                = GetPropertyObject(Parameters, "PaymentList.Agreement"               , Row.Key);
		Options.LegalNameContract        = GetPropertyObject(Parameters, "PaymentList.LegalNameContract"       , Row.Key);
		Options.BasisDocument            = GetPropertyObject(Parameters, "PaymentList.BasisDocument"           , Row.Key);
		Options.PlanningTransactionBasis = GetPropertyObject(Parameters, "PaymentList.PlaningTransactionBasis" , Row.Key);
		Options.Order                    = GetPropertyObject(Parameters, "PaymentList.Order"                   , Row.Key);
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ClearByTransactionTypeBankPayment.Options.Add(Options);
	EndDo;
EndProcedure

Procedure StepsEnabler_ClearByTransactionTypeBankReceipt(Parameters, Chain) Export
	StepsEnablerName = "StepsEnabler_ClearByTransactionTypeBankReceipt";
	
	Options_TransactionType  = GetPropertyObject(Parameters, "TransactionType");
	Options_TransitAccount   = GetPropertyObject(Parameters, "TransitAccount");
	Options_CurrencyExchange = GetPropertyObject(Parameters, "CurrencyExchange");
	
	// ClearByTransactionTypeBankReceipt
	Chain.ClearByTransactionTypeBankReceipt.Enable = True;
	Chain.ClearByTransactionTypeBankReceipt.Setter = "FillTransactionType_BankReceipt";
	
	For Each Row In GetRows(Parameters, "PaymentList") Do
		// ClearByTransactionTypeBankReceipt
		Options = ModelClientServer_V2.ClearByTransactionTypeBankReceiptOptions();
		Options.TransactionType          = Options_TransactionType;
		Options.TransitAccount           = Options_TransitAccount;
		Options.CurrencyExchange         = Options_CurrencyExchange;
		Options.Partner                  = GetPropertyObject(Parameters, "PaymentList.Partner"                 , Row.Key);
		Options.Payer                    = GetPropertyObject(Parameters, "PaymentList.Payer"                   , Row.Key);
		Options.Agreement                = GetPropertyObject(Parameters, "PaymentList.Agreement"               , Row.Key);
		Options.LegalNameContract        = GetPropertyObject(Parameters, "PaymentList.LegalNameContract"       , Row.Key);
		Options.BasisDocument            = GetPropertyObject(Parameters, "PaymentList.BasisDocument"           , Row.Key);
		Options.PlanningTransactionBasis = GetPropertyObject(Parameters, "PaymentList.PlaningTransactionBasis" , Row.Key);
		Options.Order                    = GetPropertyObject(Parameters, "PaymentList.Order"                   , Row.Key);
		Options.AmountExchange           = GetPropertyObject(Parameters, "PaymentList.AmountExchange"          , Row.Key);
		Options.POSAccount               = GetPropertyObject(Parameters, "PaymentList.POSAccount"              , Row.Key);
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ClearByTransactionTypeBankReceipt.Options.Add(Options);
	EndDo;
EndProcedure

Procedure StepsEnabler_ClearByTransactionTypeCashPayment(Parameters, Chain) Export
	StepsEnablerName = "StepsEnabler_ClearByTransactionTypeCashPayment";
	
	Options_TransactionType = GetPropertyObject(Parameters, "TransactionType");
	
	// ClearByTransactionTypeCashPayment
	Chain.ClearByTransactionTypeCashPayment.Enable = True;
	Chain.ClearByTransactionTypeCashPayment.Setter = "FillTransactionType_CashPayment";
	
	For Each Row In GetRows(Parameters, "PaymentList") Do
		// ClearByTransactionTypeCashPayment
		Options = ModelClientServer_V2.ClearByTransactionTypeCashPaymentOptions();
		Options.TransactionType          = Options_TransactionType;
		Options.BasisDocument            = GetPropertyObject(Parameters, "PaymentList.BasisDocument"           , Row.Key);
		Options.Partner                  = GetPropertyObject(Parameters, "PaymentList.Partner"                 , Row.Key);
		Options.PlanningTransactionBasis = GetPropertyObject(Parameters, "PaymentList.PlaningTransactionBasis" , Row.Key);
		Options.Agreement                = GetPropertyObject(Parameters, "PaymentList.Agreement"               , Row.Key);
		Options.LegalNameContract        = GetPropertyObject(Parameters, "PaymentList.LegalNameContract"       , Row.Key);
		Options.Payee                    = GetPropertyObject(Parameters, "PaymentList.Payee"                   , Row.Key);
		Options.Order                    = GetPropertyObject(Parameters, "PaymentList.Order"                   , Row.Key);
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ClearByTransactionTypeCashPayment.Options.Add(Options);
	EndDo;
EndProcedure

Procedure StepsEnabler_ClearByTransactionTypeCashReceipt(Parameters, Chain) Export
	StepsEnablerName = "StepsEnabler_ClearByTransactionTypeCashReceipt";
	
	Options_TransactionType  = GetPropertyObject(Parameters, "TransactionType");
	Options_CurrencyExchange = GetPropertyObject(Parameters, "CurrencyExchange");
	
	// ClearByTransactionTypeCashReceipt
	Chain.ClearByTransactionTypeCashReceipt.Enable = True;
	Chain.ClearByTransactionTypeCashReceipt.Setter = "FillTransactionType_CashReceipt";
	
	For Each Row In GetRows(Parameters, "PaymentList") Do
		// ClearByTransactionTypeCashReceipt
		Options = ModelClientServer_V2.ClearByTransactionTypeCashReceiptOptions();
		Options.TransactionType          = Options_TransactionType;
		Options.CurrencyExchange         = Options_CurrencyExchange;
		Options.Partner                  = GetPropertyObject(Parameters, "PaymentList.Partner"                 , Row.Key);
		Options.Payer                    = GetPropertyObject(Parameters, "PaymentList.Payer"                   , Row.Key);
		Options.Agreement                = GetPropertyObject(Parameters, "PaymentList.Agreement"               , Row.Key);
		Options.LegalNameContract        = GetPropertyObject(Parameters, "PaymentList.LegalNameContract"       , Row.Key);
		Options.BasisDocument            = GetPropertyObject(Parameters, "PaymentList.BasisDocument"           , Row.Key);
		Options.PlanningTransactionBasis = GetPropertyObject(Parameters, "PaymentList.PlaningTransactionBasis" , Row.Key);
		Options.Order                    = GetPropertyObject(Parameters, "PaymentList.Order"                   , Row.Key);
		Options.AmountExchange           = GetPropertyObject(Parameters, "PaymentList.AmountExchange"          , Row.Key);
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ClearByTransactionTypeCashReceipt.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region CURRENCY

// Currency.OnChange
Procedure CurrencyOnChange(Parameters) Export
	ProceedPropertyBeforeChange_Object(Parameters);
	AddViewNotify("OnSetCurrencyNotify", Parameters);
	Binding = CurrencyStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Currency.Set
Procedure SetCurrency(Parameters, Results) Export
	Binding = CurrencyStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetCurrencyNotify");
EndProcedure

// Currency.Bind
Function CurrencyStepsBinding(Parameters)
	DataPath = "Currency";
	Binding = New Structure();
	Binding.Insert("BankPayment" , "StepsEnabler_ChangeAccountByCurrency,
									|StepsEnabler_ChangePlanningTransactionBasisByCurrency");

	Binding.Insert("BankReceipt" , "StepsEnabler_ChangeAccountByCurrency,
									|StepsEnabler_ChangePlanningTransactionBasisByCurrency");
	
	Binding.Insert("CashPayment" , "StepsEnabler_ChangeCashAccountByCurrency,
									|StepsEnabler_ChangePlanningTransactionBasisByCurrency");
	
	Binding.Insert("CashReceipt"    , "StepsEnabler_ChangeCashAccountByCurrency,
									|StepsEnabler_ChangePlanningTransactionBasisByCurrency");
	
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

// CurrencyExchange.Set
Procedure SetCurrencyExchange(Parameters, Results) Export
	Binding = CurrencyExchangeStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// CurrencyExchange.Bind
Function CurrencyExchangeStepsBinding(Parameters)
	DataPath = "CurrencyExchange";
	Binding = New Structure();
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

Procedure StepsEnabler_ChangeAccountByCurrency(Parameters, Chain) Export
	StepsEnablerName = "StepsEnabler_ChangeAccountByCurrency";
	Options_Currency = GetPropertyObject(Parameters, "Currency");
	Options_Account  = GetPropertyObject(Parameters, "Account");
	
	// ChangeCashAccountByCurrency
	Chain.ChangeCashAccountByCurrency.Enable = True;
	Chain.ChangeCashAccountByCurrency.Setter = "SetAccount";
	Options = ModelClientServer_V2.ChangeCashAccountByCurrencyOptions();
	Options.CurrentAccount = Options_Account;
	Options.Currency       = Options_Currency;
	Options.StepsEnablerName = StepsEnablerName;
	Chain.ChangeCashAccountByCurrency.Options.Add(Options);
EndProcedure

Procedure StepsEnabler_ChangeCashAccountByCurrency(Parameters, Chain) Export
	StepsEnablerName = "StepsEnabler_ChangeCashAccountByCurrency";
	
	Options_Currency = GetPropertyObject(Parameters, "Currency");
	Options_Account  = GetPropertyObject(Parameters, "CashAccount");
	
	// ChangeCashAccountByCurrency
	Chain.ChangeCashAccountByCurrency.Enable = True;
	Chain.ChangeCashAccountByCurrency.Setter = "SetAccount";
	Options = ModelClientServer_V2.ChangeCashAccountByCurrencyOptions();
	Options.CurrentAccount = Options_Account;
	Options.Currency       = Options_Currency;
	Options.StepsEnablerName = StepsEnablerName;
	Chain.ChangeCashAccountByCurrency.Options.Add(Options);
EndProcedure

Procedure StepsEnabler_ChangePlanningTransactionBasisByCurrency(Parameters, Chain) Export
	StepsEnablerName = "StepsEnabler_ChangePlanningTransactionBasisByCurrency";
	
	Options_Currency = GetPropertyObject(Parameters, "Currency");
	
	// ChangePlanningTransactionBasisByCurrency
	Chain.ChangePlanningTransactionBasisByCurrency.Enable = True;
	Chain.ChangePlanningTransactionBasisByCurrency.Setter = "SetPaymentListPlanningTransactionBasis";
	
	For Each Row In GetRows(Parameters, "PaymentList") Do
		// ChangePlanningTransactionBasisByCurrency
		Options = ModelClientServer_V2.ChangePlanningTransactionBasisByCurrencyOptions();
		Options.Currency = Options_Currency;
		Options.PlanningTransactionBasis = GetPropertyObject(Parameters, "PaymentList.PlaningTransactionBasis", Row.Key);
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ChangePlanningTransactionBasisByCurrency.Options.Add(Options);
	EndDo;
EndProcedure
	
#EndRegion

#Region _DATE

// Date.OnChange
Procedure DateOnChange(Parameters) Export
	ProceedPropertyBeforeChange_Object(Parameters);
	Binding = DateStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Date.Set
Procedure SetDate(Parameters, Results) Export
	Binding = DateStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Date.Bind
Function DateStepsBinding(Parameters)
	DataPath = "Date";
	Binding = New Structure();
	Binding.Insert("SalesInvoice" , "DateStepsEnabler_Trade_PartnerIsCustomer");
	Binding.Insert("BankPayment"  , "DateStepsEnabler_BankCashPaymentReceipt");
	Binding.Insert("BankReceipt"  , "DateStepsEnabler_BankCashPaymentReceipt");
	Binding.Insert("CashPayment"  , "DateStepsEnabler_BankCashPaymentReceipt");
	Binding.Insert("CashReceipt"  , "DateStepsEnabler_BankCashPaymentReceipt");
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

Procedure DateStepsEnabler_Trade_PartnerIsCustomer(Parameters, Chain) Export
	StepsEnablerName = "DateStepsEnabler_Trade_PartnerIsCustomer";
	
	// ChangeAgreementByPartner
	Chain.ChangeAgreementByPartner.Enable = True;
	Chain.ChangeAgreementByPartner.Setter = "SetAgreement";
	Options = ModelClientServer_V2.ChangeAgreementByPartnerOptions();
	Options.Partner       = GetPropertyObject(Parameters, "Partner");
	Options.Agreement     = GetPropertyObject(Parameters, "Agreement");
	Options.CurrentDate   = GetPropertyObject(Parameters, "Date");
	Options.AgreementType = PredefinedValue("Enum.AgreementTypes.Customer");
	Chain.ChangeAgreementByPartner.Options.Add(Options);

	// ChangeDeliveryDate
	Chain.ChangeDeliveryDateByAgreement.Enable = True;
	Chain.ChangeDeliveryDateByAgreement.Setter = "SetDeliveryDate";
	Options = ModelClientServer_V2.ChangeDeliveryDateByAgreementOptions();
	Options.Agreement = GetPropertyObject(Parameters, "Agreement");
	Options.CurrentDeliveryDate = GetPropertyForm(Parameters, "DeliveryDate");
	Chain.ChangeDeliveryDateByAgreement.Options.Add(Options);
	
	// RequireCallCreateTaxesFormControls
	Chain.RequireCallCreateTaxesFormControls.Enable = True;
	Chain.RequireCallCreateTaxesFormControls.Setter = "FormModificator_CreateTaxesFormControls";
	Options = ModelClientServer_V2.RequireCallCreateTaxesFormControlsOptions();
	Options.Ref            = Parameters.Object.Ref;
	Options.Date           = GetPropertyObject(Parameters, "Date");
	Options.Company        = GetPropertyObject(Parameters, "Company");
	Options.ArrayOfTaxInfo = Parameters.ArrayOfTaxInfo;
	Options.FormTaxColumnsExists = Parameters.FormTaxColumnsExists;
	Chain.RequireCallCreateTaxesFormControls.Options.Add(Options);
	
	// ChangePriceTypeByAgreement
	Chain.ChangePriceTypeByAgreement.Enable = True;
	Chain.ChangePriceTypeByAgreement.Setter = "SetItemListPriceType";
	
	// ChangePriceByPriceType
	Chain.ChangePriceByPriceType.Enable = True;
	Chain.ChangePriceByPriceType.Setter = "SetItemListPrice";
	
	// ChangeTaxRate
	Chain.ChangeTaxRate.Enable = True;
	Chain.ChangeTaxRate.Setter = "SetItemListTaxRate";
	
	Options_Date      = GetPropertyObject(Parameters, "Date");
	Options_Company   = GetPropertyObject(Parameters, "Company");
	Options_Agreement = GetPropertyObject(Parameters, "Agreement");
	TaxRates = Undefined;
	If Not (Parameters.FormTaxColumnsExists And Parameters.ArrayOfTaxInfo.Count()) Then
		Parameters.ArrayOfTaxInfo = TaxesServer._GetArrayOfTaxInfo(Parameters.Object, Options_Date, Options_Company);
		TaxRates = New Structure();
		For Each ItemOfTaxInfo In Parameters.ArrayOfTaxInfo Do
			TaxRates.Insert(ItemOfTaxInfo.Name, Undefined);
		EndDo;
	EndIf;
	
	For Each Row In GetRows(Parameters, "ItemList") Do
		// ChangePriceTypeByAgreement
		Options = ModelClientServer_V2.ChangePriceTypeByAgreementOptions();
		Options.Agreement = Options_Agreement;
		Options.Key = Row.Key;
		Chain.ChangePriceTypeByAgreement.Options.Add(Options);
		
		// ChangePriceByPriceType
		Options = ModelClientServer_V2.ChangePriceByPriceTypeOptions();
		Options.Ref          = Parameters.Object.Ref;
		Options.Date         = Options_Date;
		Options.CurrentPrice = GetPropertyObject(Parameters, "ItemList.Price", Row.Key);
		Options.PriceType    = GetPropertyObject(Parameters, "ItemList.PriceType", Row.Key);
		Options.ItemKey      = GetPropertyObject(Parameters, "ItemList.ItemKey"  , Row.Key);
		Options.Unit         = GetPropertyObject(Parameters, "ItemList.Unit"     , Row.Key);
		Options.Key          = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Options.DontExecuteIfExecutedBefore = True;
		Chain.ChangePriceByPriceType.Options.Add(Options);
		
		// ChangeTaxRate
		Options = ModelClientServer_V2.ChangeTaxRateOptions();
		Options.Date           = Options_Date;
		Options.Company        = Options_Company;
		Options.Agreement      = Options_Agreement;
		Options.ArrayOfTaxInfo = Parameters.ArrayOfTaxInfo;
		Options.Ref            = Parameters.Object.Ref;
		
		If TaxRates <> Undefined Then
			For Each ItemOfTaxInfo In Parameters.ArrayOfTaxInfo Do
				SetProperty(Parameters.Cache, "ItemList." + ItemOfTaxInfo.Name, Row.Key, Undefined);
			EndDo;
			Row.Insert("TaxRates", TaxRates);
		EndIf;
		
		Options.TaxRates = GetItemListTaxRate(Parameters, Row);
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ChangeTaxRate.Options.Add(Options);
	EndDo;
	
	// UpdatePaymentTerms
	Chain.UpdatePaymentTerms.Enable = True;
	Chain.UpdatePaymentTerms.Setter = "SetPaymentTerms";
	Options = ModelClientServer_V2.UpdatePaymentTermsOptions();
	Options.Date = GetPropertyObject(Parameters, "Date");
	Options.ArrayOfPaymentTerms = GetPaymentTerms(Parameters);
	// нужны все строки таблицы
	TotalAmount = 0;
	For Each Row In Parameters.Object.ItemList Do
		TotalAmount = TotalAmount + GetPropertyObject(Parameters, "ItemList.TotalAmount", Row.Key);
	EndDo;
	Options.TotalAmount = TotalAmount;
	Chain.UpdatePaymentTerms.Options.Add(Options);
EndProcedure

Procedure DateStepsEnabler_BankCashPaymentReceipt(Parameters, Chain) Export
	StepsEnablerName = "DateStepsEnabler_BankCashPaymentReceipt";
	
	Options_Date      = GetPropertyObject(Parameters, "Date");
	Options_Company   = GetPropertyObject(Parameters, "Company");
	
	// RequireCallCreateTaxesFormControls
	Chain.RequireCallCreateTaxesFormControls.Enable = True;
	Chain.RequireCallCreateTaxesFormControls.Setter = "FormModificator_CreateTaxesFormControls";
	Options = ModelClientServer_V2.RequireCallCreateTaxesFormControlsOptions();
	Options.Ref            = Parameters.Object.Ref;
	Options.Date           = Options_Date;
	Options.Company        = Options_Company;
	Options.ArrayOfTaxInfo = Parameters.ArrayOfTaxInfo;
	Options.FormTaxColumnsExists = Parameters.FormTaxColumnsExists;
	Chain.RequireCallCreateTaxesFormControls.Options.Add(Options);
	
	// ChangeTaxRate
	Chain.ChangeTaxRate.Enable = True;
	Chain.ChangeTaxRate.Setter = "SetPaymentListTaxRate";
	
	TaxRates = Undefined;
	If Not (Parameters.FormTaxColumnsExists And Parameters.ArrayOfTaxInfo.Count()) Then
		Parameters.ArrayOfTaxInfo = TaxesServer._GetArrayOfTaxInfo(Parameters.Object, Options_Date, Options_Company);
		TaxRates = New Structure();
		For Each ItemOfTaxInfo In Parameters.ArrayOfTaxInfo Do
			TaxRates.Insert(ItemOfTaxInfo.Name, Undefined);
		EndDo;
	EndIf;
	
	For Each Row In GetRows(Parameters, "PaymentList") Do
		// ChangeTaxRate
		Options = ModelClientServer_V2.ChangeTaxRateOptions();
		Options.Date           = Options_Date;
		Options.Company        = Options_Company;
		Options.Agreement      = GetPropertyObject(Parameters, "PaymentList.Agreement", Row.Key);;
		Options.ArrayOfTaxInfo = Parameters.ArrayOfTaxInfo;
		Options.Ref            = Parameters.Object.Ref;
		
		If TaxRates <> Undefined Then
			For Each ItemOfTaxInfo In Parameters.ArrayOfTaxInfo Do
				SetProperty(Parameters.Cache, "PaymentList." + ItemOfTaxInfo.Name, Row.Key, Undefined);
			EndDo;
			Row.Insert("TaxRates", TaxRates);
		EndIf;
		
		Options.TaxRates = GetPaymentListTaxRate(Parameters, Row);
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ChangeTaxRate.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region COMPANY

// Company.OnChange
Procedure CompanyOnChange(Parameters) Export
	ProceedPropertyBeforeChange_Object(Parameters);
	AddViewNotify("OnSetCompanyNotify", Parameters);
	Binding = CompanyStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Company.Set
Procedure SetCompany(Parameters, Results) Export
	Binding = CompanyStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetCompanyNotify");
EndProcedure

// Company.Bind
Function CompanyStepsBinding(Parameters)
	DataPath = "Company";
	Binding = New Structure();
	Binding.Insert("IncomingPaymentOrder", "CompanyStepsEnabler_Cash");
	Binding.Insert("OutgoingPaymentOrder", "CompanyStepsEnabler_Cash");
	
	Binding.Insert("BankPayment"         , "CompanyStepsEnabler_BankCashPaymentReceipt, 
											|StepsEnabler_ChangeAccountByCompany");
	
	Binding.Insert("BankReceipt"         , "CompanyStepsEnabler_BankCashPaymentReceipt, 
											|StepsEnabler_ChangeAccountByCompany");
	
	Binding.Insert("CashPayment"         , "CompanyStepsEnabler_BankCashPaymentReceipt, 
											|StepsEnabler_ChangeCashAccountByCompany");
	
	Binding.Insert("CashReceipt"         , "CompanyStepsEnabler_BankCashPaymentReceipt, 
											|StepsEnabler_ChangeCashAccountByCompany");
	
	Binding.Insert("SalesInvoice"        , "CompanyStepsEnabler_WithTaxes");
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

Procedure StepsEnabler_ChangeAccountByCompany(Parameters, Chain) Export
	StepsEnablerName = "StepsEnabler_ChangeAccountByCompany";
	
	Options_Company   = GetPropertyObject(Parameters, "Company");
	Options_Account   = GetPropertyObject(Parameters, "Account");
	
	// ChangeCashAccountByCompany
	Chain.ChangeCashAccountByCompany.Enable = True;
	Chain.ChangeCashAccountByCompany.Setter = "SetAccount";
	Options = ModelClientServer_V2.ChangeCashAccountByCompanyOptions();
	Options.Company = Options_Company;
	Options.Account = Options_Account;
	Options.AccountType = PredefinedValue("Enum.CashAccountTypes.Bank");
	Options.StepsEnablerName = StepsEnablerName;
	Chain.ChangeCashAccountByCompany.Options.Add(Options);
EndProcedure

Procedure StepsEnabler_ChangeCashAccountByCompany(Parameters, Chain) Export
	StepsEnablerName = "StepsEnabler_ChangeCashAccountByCompany";
	
	Options_Company   = GetPropertyObject(Parameters, "Company");
	Options_Account   = GetPropertyObject(Parameters, "CashAccount");
	
	// ChangeCashAccountByCompany
	Chain.ChangeCashAccountByCompany.Enable = True;
	Chain.ChangeCashAccountByCompany.Setter = "SetAccount";
	Options = ModelClientServer_V2.ChangeCashAccountByCompanyOptions();
	Options.Company = Options_Company;
	Options.Account = Options_Account;
	Options.AccountType = PredefinedValue("Enum.CashAccountTypes.Bank");
	Options.StepsEnablerName = StepsEnablerName;
	Chain.ChangeCashAccountByCompany.Options.Add(Options);
EndProcedure

Procedure CompanyStepsEnabler_Cash(Parameters, Chain) Export
	StepsEnablerName = "CompanyStepsEnabler_Cash";
	
	// ChangeCashAccountByCompany
	Chain.ChangeCashAccountByCompany.Enable = True;
	Chain.ChangeCashAccountByCompany.Setter = "SetAccount";
	Options = ModelClientServer_V2.ChangeCashAccountByCompanyOptions();
	Options.Company = GetPropertyObject(Parameters, "Company");
	Options.Account = GetPropertyObject(Parameters, "Account");
	Options.StepsEnablerName = StepsEnablerName;
	Chain.ChangeCashAccountByCompany.Options.Add(Options);
EndProcedure

Procedure CompanyStepsEnabler_WithTaxes(Parameters, Chain) Export
	StepsEnablerName = "CompanyStepsEnabler_WithTaxes";
	
	Options_Date      = GetPropertyObject(Parameters, "Date");
	Options_Company   = GetPropertyObject(Parameters, "Company");
	Options_Agreement = GetPropertyObject(Parameters, "Agreement");
	
	// RequireCallCreateTaxesFormControls
	Chain.RequireCallCreateTaxesFormControls.Enable = True;
	Chain.RequireCallCreateTaxesFormControls.Setter = "FormModificator_CreateTaxesFormControls";
	Options = ModelClientServer_V2.RequireCallCreateTaxesFormControlsOptions();
	Options.Ref            = Parameters.Object.Ref;
	Options.Date           = Options_Date;
	Options.Company        = Options_Company;
	Options.ArrayOfTaxInfo = Parameters.ArrayOfTaxInfo;
	Options.FormTaxColumnsExists = Parameters.FormTaxColumnsExists;
	Chain.RequireCallCreateTaxesFormControls.Options.Add(Options);
	
	// ChangeTaxRate
	Chain.ChangeTaxRate.Enable = True;
	Chain.ChangeTaxRate.Setter = "SetItemListTaxRate";
	
	TaxRates = Undefined;
	If Not (Parameters.FormTaxColumnsExists And Parameters.ArrayOfTaxInfo.Count()) Then
		Parameters.ArrayOfTaxInfo = TaxesServer._GetArrayOfTaxInfo(Parameters.Object, Options_Date, Options_Company);
		TaxRates = New Structure();
		For Each ItemOfTaxInfo In Parameters.ArrayOfTaxInfo Do
			TaxRates.Insert(ItemOfTaxInfo.Name, Undefined);
		EndDo;
	EndIf;
	
	For Each Row In GetRows(Parameters, "ItemList") Do
		// ChangeTaxRate
		Options = ModelClientServer_V2.ChangeTaxRateOptions();
		Options.Date           = Options_Date;
		Options.Company        = Options_Company;
		Options.Agreement      = Options_Agreement;
		Options.ArrayOfTaxInfo = Parameters.ArrayOfTaxInfo;
		Options.Ref            = Parameters.Object.Ref;
		Options.ChangeOnlyWhenAgreementIsFilled = True;
		
		If TaxRates <> Undefined Then
			For Each ItemOfTaxInfo In Parameters.ArrayOfTaxInfo Do
				SetProperty(Parameters.Cache, "ItemList." + ItemOfTaxInfo.Name, Row.Key, Undefined);
			EndDo;
			Row.Insert("TaxRates", TaxRates);
		EndIf;
		
		Options.TaxRates = GetItemListTaxRate(Parameters, Row);
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ChangeTaxRate.Options.Add(Options);
	EndDo;
EndProcedure

Procedure CompanyStepsEnabler_BankCashPaymentReceipt(Parameters, Chain) Export
	StepsEnablerName = "CompanyStepsEnabler_BankCashPaymentReceipt";
	
	Options_Date      = GetPropertyObject(Parameters, "Date");
	Options_Company   = GetPropertyObject(Parameters, "Company");
	//Options_Account   = GetPropertyObject(Parameters, "Account");
	
//	// ChangeCashAccountByCompany
//	Chain.ChangeCashAccountByCompany.Enable = True;
//	Chain.ChangeCashAccountByCompany.Setter = "SetAccount";
//	Options = ModelClientServer_V2.ChangeCashAccountByCompanyOptions();
//	Options.Company = Options_Company;
//	Options.Account = Options_Account;
//	Options.AccountType = PredefinedValue("Enum.CashAccountTypes.Bank");
//	Options.StepsEnablerName = StepsEnablerName;
//	Chain.ChangeCashAccountByCompany.Options.Add(Options);
	
	// RequireCallCreateTaxesFormControls
	Chain.RequireCallCreateTaxesFormControls.Enable = True;
	Chain.RequireCallCreateTaxesFormControls.Setter = "FormModificator_CreateTaxesFormControls";
	Options = ModelClientServer_V2.RequireCallCreateTaxesFormControlsOptions();
	Options.Ref            = Parameters.Object.Ref;
	Options.Date           = Options_Date;
	Options.Company        = Options_Company;
	Options.ArrayOfTaxInfo = Parameters.ArrayOfTaxInfo;
	Options.FormTaxColumnsExists = Parameters.FormTaxColumnsExists;
	Chain.RequireCallCreateTaxesFormControls.Options.Add(Options);
	
	// ChangeTaxRate
	Chain.ChangeTaxRate.Enable = True;
	Chain.ChangeTaxRate.Setter = "SetPaymentListTaxRate";
	
	TaxRates = Undefined;
	If Not (Parameters.FormTaxColumnsExists And Parameters.ArrayOfTaxInfo.Count()) Then
		Parameters.ArrayOfTaxInfo = TaxesServer._GetArrayOfTaxInfo(Parameters.Object, Options_Date, Options_Company);
		TaxRates = New Structure();
		For Each ItemOfTaxInfo In Parameters.ArrayOfTaxInfo Do
			TaxRates.Insert(ItemOfTaxInfo.Name, Undefined);
		EndDo;
	EndIf;
	
	For Each Row In GetRows(Parameters, "PaymentList") Do
		// ChangeTaxRate
		Options = ModelClientServer_V2.ChangeTaxRateOptions();
		Options.Date           = Options_Date;
		Options.Company        = Options_Company;
		Options.Agreement      = GetPropertyObject(Parameters, "PaymentList.Agreement", Row.Key);;
		Options.ArrayOfTaxInfo = Parameters.ArrayOfTaxInfo;
		Options.Ref            = Parameters.Object.Ref;
		
		If TaxRates <> Undefined Then
			For Each ItemOfTaxInfo In Parameters.ArrayOfTaxInfo Do
				SetProperty(Parameters.Cache, "PaymentList." + ItemOfTaxInfo.Name, Row.Key, Undefined);
			EndDo;
			Row.Insert("TaxRates", TaxRates);
		EndIf;
		
		Options.TaxRates = GetPaymentListTaxRate(Parameters, Row);
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ChangeTaxRate.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region PARTNER

// Partner.OnChange
Procedure PartnerOnChange(Parameters) Export
	ProceedPropertyBeforeChange_Object(Parameters);
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
	Binding.Insert("ShipmentConfirmation", "PartnerStepsEnabler_Warehouse");
	Binding.Insert("GoodsReceipt"        , "PartnerStepsEnabler_Warehouse");
	Binding.Insert("SalesInvoice"        , "PartnerStepsEnabler_Trade_PartnerIsCustomer");
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

Procedure PartnerStepsEnabler_Trade_PartnerIsCustomer(Parameters, Chain) Export
	Chain.ChangeLegalNameByPartner.Enable = True;
	Chain.ChangeLegalNameByPartner.Setter = "SetLegalName";
	Options = ModelClientServer_V2.ChangeLegalNameByPartnerOptions();
	Options.Partner   = GetPropertyObject(Parameters, "Partner");
	Options.LegalName = GetPropertyObject(Parameters, "LegalName");;
	Chain.ChangeLegalNameByPartner.Options.Add(Options);
	
	Chain.ChangeAgreementByPartner.Enable = True;
	Chain.ChangeAgreementByPartner.Setter = "SetAgreement";
	Options = ModelClientServer_V2.ChangeAgreementByPartnerOptions();
	Options.Partner       = GetPropertyObject(Parameters, "Partner");
	Options.Agreement     = GetPropertyObject(Parameters, "Agreement");
	Options.CurrentDate   = GetPropertyObject(Parameters, "Date");
	Options.AgreementType = PredefinedValue("Enum.AgreementTypes.Customer");
	Chain.ChangeAgreementByPartner.Options.Add(Options);
	
	Chain.ChangeManagerSegmentByPartner.Enable = True;
	Chain.ChangeManagerSegmentByPartner.Setter = "SetManagerSegment";
	Options = ModelClientServer_V2.ChangeManagerSegmentByPartnerOptions();
	Options.Partner = GetPropertyObject(Parameters, "Partner");
	Chain.ChangeManagerSegmentByPartner.Options.Add(Options);
EndProcedure

Procedure PartnerStepsEnabler_Warehouse(Parameters, Chain) Export
	Chain.ChangeLegalNameByPartner.Enable = True;
	Chain.ChangeLegalNameByPartner.Setter = "SetLegalName";
	Options = ModelClientServer_V2.ChangeLegalNameByPartnerOptions();
	Options.Partner   = GetPropertyObject(Parameters, "Partner");
	Options.LegalName = GetPropertyObject(Parameters, "LegalName");;
	Chain.ChangeLegalNameByPartner.Options.Add(Options);
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
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region FORM_DELIVERY_DATE

// DeliveryDate.OnChange
Procedure DeliveryDateOnChange(Parameters) Export
	ProceedPropertyBeforeChange_Form(Parameters);
	AddViewNotify("OnSetDeliveryDateNotify", Parameters);
	Binding = DeliveryDateStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// DeliveryDate.Set
Procedure SetDeliveryDate(Parameters, Results) Export
	Binding = DeliveryDateStepsBinding(Parameters);
	SetterForm(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetDeliveryDateNotify", ,True);
EndProcedure

// DeliveryDate.Default.Bind
Function DeliveryDateDefaultBinding(Parameters)
	DataPath = "DeliveryDate";
	Binding = New Structure();
	Binding.Insert("SalesInvoice"   , "DeliveryDateDefault");	
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

// DeliveryDate.Bind
Function DeliveryDateStepsBinding(Parameters)
	DataPath = "DeliveryDate";
	Binding = New Structure();
	Return BindSteps("DeliveryDateStepsEnabler", DataPath, Binding, Parameters);
EndFunction

Procedure DeliveryDateDefault(Parameters, Chain) Export
	// DefaultDeliveryDateInHeader
	Chain.DefaultDeliveryDateInHeader.Enable = True;
	Chain.DefaultDeliveryDateInHeader.Setter = "SetDeliveryDate";
	Options = ModelClientServer_V2.DefaultDeliveryDateInHeaderOptions();
	Options.Date      = GetPropertyObject(Parameters  , "Date");
	Options.Agreement = GetPropertyObject(Parameters  , "Agreement");
	
	ArrayOfDeliveryDateInList = New Array();
	For Each Row In Parameters.Object.ItemList Do
		ArrayOfDeliveryDateInList.Add(GetPropertyObject(Parameters, "ItemList.DeliveryDate", Row.Key));
	EndDo;
	Options.ArrayOfDeliveryDateInList = ArrayOfDeliveryDateInList; 
	
	Chain.DefaultDeliveryDateInHeader.Options.Add(Options);
EndProcedure

Procedure DeliveryDateStepsEnabler(Parameters, Chain) Export
	// FillDeliveryDateInList
	Chain.FillDeliveryDateInList.Enable = True;
	Chain.FillDeliveryDateInList.Setter = "SetItemListDeliveryDate";
	For Each Row In GetRows(Parameters, "ItemList") Do
		// FillDeliveryDateInList
		Options = ModelClientServer_V2.FillDeliveryDateInListOptions();
		Options.DeliveryDate       = GetPropertyForm(Parameters, "DeliveryDate");
		Options.DeliveryDateInList = GetPropertyObject(Parameters, "ItemList.DeliveryDate", Row.Key);
		Options.Key = Row.Key;
		Chain.FillDeliveryDateInList.Options.Add(Options);
	EndDo;
EndProcedure

// ItemList.DeliveryDate.OnChange
Procedure ItemListDeliveryDateOnChange(Parameters) Export
	ProceedPropertyBeforeChange_List(Parameters);
	Binding = ItemListDeliveryDateSptepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.DeliveryDate.Set
Procedure SetItemListDeliveryDate(Parameters, Results) Export
	Binding = ItemListDeliveryDateSptepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.DeliveryDate.Default.Bind
Function ItemListDeliveryDateDefaultBinding(Parameters)
	DataPath = "ItemList.DeliveryDate";
	Binding = New Structure();
	Binding.Insert("SalesInvoice", "ItemListDeliveryDateDefault");
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

// ItemList.DeliveryDate.Bind
Function ItemListDeliveryDateSptepsBinding(Parameters)
	DataPath = "ItemList.DeliveryDate";
	Binding = New Structure();
	Binding.Insert("SalesInvoice"   , "ItemListDeliveryDateStepsEnabler");
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

Procedure ItemListDeliveryDateDefault(Parameters, Chain) Export
	// DefaultDeliveryDateInList
	Chain.DefaultDeliveryDateInList.Enable = True;
	Chain.DefaultDeliveryDateInList.Setter = "SetItemListDeliveryDate";
	Options = ModelClientServer_V2.DefaultDeliveryDateInListOptions();
	NewRow = Parameters.RowFilledByUserSettings;
	Options.DeliveryDateInList   = GetPropertyObject(Parameters, "ItemList.DeliveryDate", NewRow.Key);
	Options.DeliveryDateInHeader = GetPropertyForm(Parameters  , "DeliveryDate");
	Options.Date                 = GetPropertyObject(Parameters, "Date");
	Options.Agreement            = GetPropertyObject(Parameters, "Agreement");
	Options.Key = NewRow.Key;
	Chain.DefaultDeliveryDateInList.Options.Add(Options);
EndProcedure

Procedure ItemListDeliveryDateStepsEnabler(Parameters, Chain) Export
	// ChangeDeliveryDateInHeaderByDeliveryDateInList
	Chain.ChangeDeliveryDateInHeaderByDeliveryDateInList.Enable = True;
	Chain.ChangeDeliveryDateInHeaderByDeliveryDateInList.Setter = "SetDeliveryDate";
	Options = ModelClientServer_V2.ChangeDeliveryDateInHeaderByDeliveryDateInListOptions();
	ArrayOfDeliveryDateInList = New Array();
	For Each Row In Parameters.Object.ItemList Do
		ArrayOfDeliveryDateInList.Add(GetPropertyObject(Parameters, "ItemList.DeliveryDate", Row.Key));
	EndDo;
	Options.ArrayOfDeliveryDateInList = ArrayOfDeliveryDateInList; 
	Chain.ChangeDeliveryDateInHeaderByDeliveryDateInList.Options.Add(Options);
EndProcedure

#EndRegion

#Region FORM_STORE

// Store.OnChange
Procedure StoreOnChange(Parameters) Export
	ProceedPropertyBeforeChange_Form(Parameters);
	AddViewNotify("OnSetStoreNotify", Parameters);
	If ValueIsFilled(GetPropertyForm(Parameters, "Store")) Then
		Binding = StoreStepsBinding(Parameters);
	Else
		Binding = StoreEmptyBinding(Parameters);
	EndIf;
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
	Binding.Insert("ShipmentConfirmation", "StoreDefault_ShipmentReceipt");
	Binding.Insert("GoodsReceipt"        , "StoreDefault_ShipmentReceipt");

	Binding.Insert("SalesInvoice"   , "StoreDefault_Trade");
	Binding.Insert("PurchaseInvoice", "StoreDefault_Trade");
	
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

// Store.Empty.Bind
Function StoreEmptyBinding(Parameters)
	DataPath = "Store";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation", "StoreEmpty_Shipment");
	Binding.Insert("GoodsReceipt"        , "StoreEmpty_Shipment");

	Binding.Insert("SalesInvoice"   , "StoreEmpty_Trade");
	Binding.Insert("PurchaseInvoice", "StoreEmpty_Trade");
	
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

// Store.Bind
Function StoreStepsBinding(Parameters)
	DataPath = "Store";
	Binding = New Structure();
	Return BindSteps("StoreStepsEnabler", DataPath, Binding, Parameters);
EndFunction

Procedure StoreDefault_ShipmentReceipt(Parameters, Chain) Export
	// DefaultStoreInHeader
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

Procedure StoreEmpty_Shipment(Parameters, Chain) Export
	// EmptyStoreInHeader
	Chain.EmptyStoreInHeader.Enable = True;
	Chain.EmptyStoreInHeader.Setter = "SetStore";
	Options = ModelClientServer_V2.EmptyStoreInHeaderOptions();
	Options.DocumentRef = Parameters.Object.Ref;
	ArrayOfStoresInList = New Array();
	For Each Row In Parameters.Object.ItemList Do
		ArrayOfStoresInList.Add(GetPropertyObject(Parameters, "ItemList.Store", Row.Key));
	EndDo;
	Options.ArrayOfStoresInList = ArrayOfStoresInList;
	Chain.EmptyStoreInHeader.Options.Add(Options);
EndProcedure

Procedure StoreDefault_Trade(Parameters, Chain) Export
	// DefaultStoreInHeader
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

Procedure StoreEmpty_Trade(Parameters, Chain) Export
	// EmptyStoreInHeader
	Chain.EmptyStoreInHeader.Enable = True;
	Chain.EmptyStoreInHeader.Setter = "SetStore";
	Options = ModelClientServer_V2.EmptyStoreInHeaderOptions();
	Options.DocumentRef = Parameters.Object.Ref;
	Options.Agreement   = GetPropertyObject(Parameters, "Agreement");
	ArrayOfStoresInList = New Array();
	For Each Row In Parameters.Object.ItemList Do
		ArrayOfStoresInList.Add(GetPropertyObject(Parameters, "ItemList.Store", Row.Key));
	EndDo;
	Options.ArrayOfStoresInList = ArrayOfStoresInList; 
	Chain.EmptyStoreInHeader.Options.Add(Options);
EndProcedure

Procedure StoreStepsEnabler(Parameters, Chain) Export
	// FillStoresInList
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
	ProceedPropertyBeforeChange_List(Parameters);
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
	
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

// ItemList.Store.Bind
Function ItemListStoreSptepsBinding(Parameters)
	DataPath = "ItemList.Store";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation", "ItemListStoreStepsEnabler_HaveStoreInHeader");
	Binding.Insert("GoodsReceipt"        , "ItemListStoreStepsEnabler_HaveStoreInHeader");

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
	// ChangeStoreInHeaderByStoresInList
	Chain.ChangeStoreInHeaderByStoresInList.Enable = True;
	Chain.ChangeStoreInHeaderByStoresInList.Setter = "SetStore";
	
	Options = ModelClientServer_V2.ChangeStoreInHeaderByStoresInListOptions();
	ArrayOfStoresInList = New Array();
	For Each Row In Parameters.Object.ItemList Do
		NewRow = New Structure();
		NewRow.Insert("Store"   , GetPropertyObject(Parameters, "ItemList.Store", Row.Key));
		NewRow.Insert("ItemKey" , GetPropertyObject(Parameters, "ItemList.ItemKey", Row.Key));
		ArrayOfStoresInList.Add(NewRow);
	EndDo;
	Options.ArrayOfStoresInList = ArrayOfStoresInList; 
	Chain.ChangeStoreInHeaderByStoresInList.Options.Add(Options);
EndProcedure

Procedure ItemListStoreStepsEnabler_HaveUseShipmentConfirmationInList(Parameters, Chain) Export
	ItemListStoreStepsEnabler_HaveStoreInHeader(Parameters, Chain);
	
	// ChangeUseShipmentConfirmationByStore
	Chain.ChangeUseShipmentConfirmationByStore.Enable = True;
	Chain.ChangeUseShipmentConfirmationByStore.Setter = "SetItemListUseShipmentConfirmation";
	
	// ExtractDataItemKeyIsService
	Chain.ExtractDataItemKeyIsService.Enable = True;
	Chain.ExtractDataItemKeyIsService.Setter = "SetExtractDataItemKeyIsService";
	
	For Each Row In GetRows(Parameters, "ItemList") Do
		// ChangeUseShipmentConfirmationByStore
		Options = ModelClientServer_V2.ChangeUseShipmentConfirmationByStoreOptions();
		Options.Store   = GetPropertyObject(Parameters, "ItemList.Store", Row.Key);
		Options.ItemKey = GetPropertyObject(Parameters, "ItemList.ItemKey", Row.Key);
		Options.Key = Row.Key;
		Chain.ChangeUseShipmentConfirmationByStore.Options.Add(Options);
		
		// ExtractDataItemKeyIsService
		Options = ModelClientServer_V2.ExtractDataItemKeyIsServiceOptions();
		Options.ItemKey = GetPropertyObject(Parameters, "ItemList.ItemKey", Row.Key);
		Options.IsUserChange = IsUserChange(Parameters);
		Options.Key = Row.Key;
		Chain.ExtractDataItemKeyIsService.Options.Add(Options);
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

// Agreement.OnChange
Procedure AgreementOnChange(Parameters) Export
	ProceedPropertyBeforeChange_Object(Parameters);
	AddViewNotify("OnSetPartnerNotify", Parameters);
	Binding = AgreementStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Agreement.Set
Procedure SetAgreement(Parameters, Results) Export
	Binding = AgreementStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Agreement.Bind
Function AgreementStepsBinding(Parameters)
	DataPath = "Agreement";
	Binding = New Structure();
	Binding.Insert("SalesInvoice"        , "AgreementStepsEnabler_Trade");
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

Procedure AgreementStepsEnabler_Trade(Parameters, Chain) Export
	StepsEnablerName = "AgreementStepsEnabler_Trade";
	
	// ChangeCompanyByAgreement
	Chain.ChangeCompanyByAgreement.Enable = True;
	Chain.ChangeCompanyByAgreement.Setter = "SetCompany";
	Options = ModelClientServer_V2.ChangeCompanyByAgreementOptions();
	Options.Agreement      = GetPropertyObject(Parameters, "Agreement");
	Options.CurrentCompany = GetPropertyObject(Parameters, "Company");	
	Chain.ChangeCompanyByAgreement.Options.Add(Options);
	
	// ChangePriceTypeByAgreement
	Chain.ChangePriceTypeByAgreement.Enable = True;
	Chain.ChangePriceTypeByAgreement.Setter = "SetItemListPriceType";
	
	// ChangeTaxRate
	Chain.ChangeTaxRate.Enable = True;
	Chain.ChangeTaxRate.Setter = "SetItemListTaxRate";
	
	Options_Date      = GetPropertyObject(Parameters, "Date");
	Options_Company   = GetPropertyObject(Parameters, "Company");
	Options_Agreement = GetPropertyObject(Parameters, "Agreement");
	TaxRates = Undefined;
	If Not (Parameters.FormTaxColumnsExists And Parameters.ArrayOfTaxInfo.Count()) Then
		Parameters.ArrayOfTaxInfo = TaxesServer._GetArrayOfTaxInfo(Parameters.Object, Options_Date, Options_Company);
		TaxRates = New Structure();
		For Each ItemOfTaxInfo In Parameters.ArrayOfTaxInfo Do
			TaxRates.Insert(ItemOfTaxInfo.Name, Undefined);
		EndDo;
	EndIf;
	
	For Each Row In GetRows(Parameters, "ItemList") Do
		// ChangePriceTypeByAgreement
		Options = ModelClientServer_V2.ChangePriceTypeByAgreementOptions();
		Options.Agreement = GetPropertyObject(Parameters, "Agreement");
		Options.Key = Row.Key;
		Chain.ChangePriceTypeByAgreement.Options.Add(Options);
		
		// ChangeTaxRate
		Options = ModelClientServer_V2.ChangeTaxRateOptions();
		Options.Date           = Options_Date;
		Options.Company        = Options_Company;
		Options.Agreement      = Options_Agreement;
		Options.ArrayOfTaxInfo = Parameters.ArrayOfTaxInfo;
		Options.Ref            = Parameters.Object.Ref;
		
		If TaxRates <> Undefined Then
			For Each ItemOfTaxInfo In Parameters.ArrayOfTaxInfo Do
				SetProperty(Parameters.Cache, "ItemList." + ItemOfTaxInfo.Name, Row.Key, Undefined);
			EndDo;
			Row.Insert("TaxRates", TaxRates);
		EndIf;
		
		Options.TaxRates = GetItemListTaxRate(Parameters, Row);
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ChangeTaxRate.Options.Add(Options);
	EndDo;
	
	// ChangeCurrencyByAgreement
	Chain.ChangeCurrencyByAgreement.Enable = True;
	Chain.ChangeCurrencyByAgreement.Setter = "SetCurrency";
	Options = ModelClientServer_V2.ChangeCurrencyByAgreementOptions();
	Options.Agreement       = GetPropertyObject(Parameters, "Agreement");
	Options.CurrentCurrency = GetPropertyObject(Parameters, "Currency");
	Chain.ChangeCurrencyByAgreement.Options.Add(Options);
	
	// ChangePriceIncludeTaxByAgreement
	Chain.ChangePriceIncludeTaxByAgreement.Enable = True;
	Chain.ChangePriceIncludeTaxByAgreement.Setter = "SetPriceIncludeTax";
	Options = ModelClientServer_V2.ChangePriceIncludeTaxByAgreementOptions();
	Options.Agreement = GetPropertyObject(Parameters, "Agreement");
	Chain.ChangePriceIncludeTaxByAgreement.Options.Add(Options);
	
	// ChangeStoreByAgreement
	Chain.ChangeStoreByAgreement.Enable = True;
	Chain.ChangeStoreByAgreement.Setter = "SetStore";
	Options = ModelClientServer_V2.ChangeStoreByAgreementOptions();
	Options.Agreement = GetPropertyObject(Parameters, "Agreement");
	Options.CurrentStore = GetPropertyForm(Parameters, "Store");
	Chain.ChangeStoreByAgreement.Options.Add(Options);
	
	// ChangeDeliveryDate
	Chain.ChangeDeliveryDateByAgreement.Enable = True;
	Chain.ChangeDeliveryDateByAgreement.Setter = "SetDeliveryDate";
	Options = ModelClientServer_V2.ChangeDeliveryDateByAgreementOptions();
	Options.Agreement = GetPropertyObject(Parameters, "Agreement");
	Options.CurrentDeliveryDate = GetPropertyForm(Parameters, "DeliveryDate");
	Chain.ChangeDeliveryDateByAgreement.Options.Add(Options);
	
	// ChangePaymentTerms
	Chain.ChangePaymentTermsByAgreement.Enable = True;
	Chain.ChangePaymentTermsByAgreement.Setter = "SetPaymentTerms";
	Options = ModelClientServer_V2.ChangePaymentTermsByAgreementOptions();
	Options.Agreement = GetPropertyObject(Parameters, "Agreement");
	Options.Date = GetPropertyObject(Parameters, "Date");
	Options.ArrayOfPaymentTerms = GetPaymentTerms(Parameters);
	// нужны все строки таблицы
	TotalAmount = 0;
	For Each Row In Parameters.Object.ItemList Do
		TotalAmount = TotalAmount + GetPropertyObject(Parameters, "ItemList.TotalAmount", Row.Key);
	EndDo;
	Options.TotalAmount = TotalAmount;
	Chain.ChangePaymentTermsByAgreement.Options.Add(Options);
EndProcedure

#EndRegion

#Region TABLE_PAYMENT_TERMS

// PaymentTerms.Set
Procedure SetPaymentTerms(Parameters, Results) Export
	Binding = PaymentTermsStepsBinding(Parameters);
	For Each Result In Results Do
		Parameters.Cache.Insert(Binding.DataPath, Result.Value.ArrayOfPaymentTerms);
		// данные изменены только если в Object.PaymentTerms уже есть строки
		If Parameters.Object.PaymentTerms.Count() Then
			PutToChangedData(Parameters, Binding.DataPath, Undefined, Undefined, Undefined);
		EndIf;
	EndDo;
EndProcedure

// PaymentTerms.Get
Function GetPaymentTerms(Parameters) Export
	Binding = PaymentTermsStepsBinding(Parameters);
	// если есть в кэше берем из него
	If Parameters.Cache.Property(Binding.DataPath) Then
		Return Parameters.Cache[Binding.DataPath];
	EndIf;
	// если нету, считываем из объекта
	ArrayOfPaymentTerms = New Array();
	For Each Row In Parameters.Object.PaymentTerms Do
		NewRow = New Structure("Date, ProportionOfPayment, DuePeriod,
			|Amount, CalculationType");
		FillPropertyValues(NewRow, Row);
		ArrayOfPaymentTerms.Add(NewRow);
	EndDo;
	Return ArrayOfPaymentTerms;
EndFunction

// PaymentTerms.Bind
Function PaymentTermsStepsBinding(Parameters)
	DataPath = "PaymentTerms";
	Binding = New Structure();
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region MANAGER_SEGMENT

// ManagerSegment.OnChange
Procedure ManagerSegmentOnChange(Parameters) Export
	Binding = ManagerSegmentStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ManagerSegment.Set
Procedure SetManagerSegment(Parameters, Results) Export
	Binding = ManagerSegmentStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ManagerSegment.Bind
Function ManagerSegmentStepsBinding(Parameters)
	DataPath = "ManagerSegment";
	Binding = New Structure();
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region PRICE_INCLUDE_TAX

// PriceIncludeTax.OnChange
Procedure PriceIncludeTaxOnChange(Parameters) Export
	Binding = PriceIncludeTaxStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PriceIncludeTax.Set
Procedure SetPriceIncludeTax(Parameters, Results) Export
	Binding = PriceIncludeTaxStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PriceIncludeTax.Bind
Function PriceIncludeTaxStepsBinding(Parameters)
	DataPath = "PriceIncludeTax";
	Binding = New Structure();
	Return BindSteps("PriceIncludeTaxStepsEnabler", DataPath, Binding, Parameters);
EndFunction

Procedure PriceIncludeTaxStepsEnabler(Parameters, Chain) Export
	ItemListEnableCalculations(Parameters, Chain, "IsPriceIncludeTaxChanged");
EndProcedure

#EndRegion

#Region OFFERS

// Offers.OnChange
Procedure OffersOnChange(Parameters) Export
	Binding = OffersStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PriceIncludeTax.Bind
Function OffersStepsBinding(Parameters)
	DataPath = "Offers";
	Binding = New Structure();
	Return BindSteps("OffersStepsEnabler", DataPath, Binding, Parameters);
EndFunction

Procedure OffersStepsEnabler(Parameters, Chain) Export
	ItemListEnableCalculations(Parameters, Chain, "IsOffersChanged");
EndProcedure

#EndRegion

#Region PAYMENT_LIST

#Region PAYMENT_LIST_PARTNER

// PaymentList.Partner.OnChange
Procedure PaymentListPartnerOnChange(Parameters) Export
	Binding = PaymentListPartnerStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.Partner.Set
Procedure SetPaymentListPartner(Parameters, Results) Export
	Binding = PaymentListPartnerStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.Partner.Bind
Function PaymentListPartnerStepsBinding(Parameters)
	DataPath = "PaymentList.Partner";
	Binding = New Structure();
	Binding.Insert("IncomingPaymentOrder", "PaymentListPartnerStepsEnabler_PaymentOrder_LegalNameIsPayer");
	Binding.Insert("OutgoingPaymentOrder", "PaymentListPartnerStepsEnabler_PaymentOrder_LegalNameIsPayee");
	Binding.Insert("BankPayment"         , "PaymentListPartnerStepsEnabler_BankCashPayment");
	Binding.Insert("BankReceipt"         , "PaymentListPartnerStepsEnabler_BankCashReceipt");
	Binding.Insert("CashPayment"         , "PaymentListPartnerStepsEnabler_BankCashPayment");
	Binding.Insert("CashReceipt"         , "PaymentListPartnerStepsEnabler_BankCashReceipt");
	Return BindSteps(Undefined, DataPath, Binding, Parameters);
EndFunction

Procedure PaymentListPartnerStepsEnabler_PaymentOrder_LegalNameIsPayer(Parameters, Chain) Export
	StepsEnablerName = "PaymentListPartnerStepsEnabler_PaymentOrder_LegalNameIsPayer";
	
	// ChangeLegalNameByPartner
	Chain.ChangeLegalNameByPartner.Enable = True;
	Chain.ChangeLegalNameByPartner.Setter = "SetPaymentListLegalName";
	For Each Row In GetRows(Parameters, "PaymentList") Do
		Options = ModelClientServer_V2.ChangeLegalNameByPartnerOptions();
		Options.Partner   = GetPropertyObject(Parameters, "PaymentList.Partner", Row.Key);
		Options.LegalName = GetPropertyObject(Parameters, "PaymentList.Payer"  , Row.Key);
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ChangeLegalNameByPartner.Options.Add(Options);
	EndDo;
EndProcedure

Procedure PaymentListPartnerStepsEnabler_PaymentOrder_LegalNameIsPayee(Parameters, Chain) Export
	StepsEnablerName = "PaymentListPartnerStepsEnabler_LegalNameIsPayee";

	Options_Currency = GetPropertyObject(Parameters, "Currency");
	
	// ChangeLegalNameByPartner
	Chain.ChangeLegalNameByPartner.Enable = True;
	Chain.ChangeLegalNameByPartner.Setter = "SetPaymentListLegalName";
	
	// ChangeCashAccountByPartner
	Chain.ChangeCashAccountByPartner.Enable = True;
	Chain.ChangeCashAccountByPartner.Setter = "SetPaymentListPartnerBankAccount";
	
	For Each Row In GetRows(Parameters, "PaymentList") Do
		Options_Partner   = GetPropertyObject(Parameters, "PaymentList.Partner", Row.Key);
		Options_LegalName = GetPropertyObject(Parameters, "PaymentList.Payee"  , Row.Key);
		
		// ChangeLegalNameByPartner
		Options = ModelClientServer_V2.ChangeLegalNameByPartnerOptions();
		Options.Partner   = Options_Partner;
		Options.LegalName = Options_LegalName;
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ChangeLegalNameByPartner.Options.Add(Options);
		
		// ChangeCashAccountByPartner
		Options = ModelClientServer_V2.ChangeCashAccountByPartnerOptions();
		Options.Partner   = Options_Partner;
		Options.LegalName = Options_LegalName;
		Options.Currency  = Options_Currency;
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ChangeCashAccountByPartner.Options.Add(Options);
	EndDo;
	
EndProcedure

Procedure PaymentListPartnerStepsEnabler_BankCashPayment(Parameters, Chain) Export
	StepsEnablerName = "PaymentListPartnerStepsEnabler_BankCashPayment";
	
	Options_Date = GetPropertyObject(Parameters, "Date");
	
	// ChangeLegalNameByPartner
	Chain.ChangeLegalNameByPartner.Enable = True;
	Chain.ChangeLegalNameByPartner.Setter = "SetPaymentListLegalName";
	
	// ChangeAgreementByPartner
	Chain.ChangeAgreementByPartner.Enable = True;
	Chain.ChangeAgreementByPartner.Setter = "SetPaymentListAgreement";
	
	For Each Row In GetRows(Parameters, "PaymentList") Do
		Options_Partner   = GetPropertyObject(Parameters, "PaymentList.Partner"  , Row.Key);
		Options_LegalName = GetPropertyObject(Parameters, "PaymentList.Payee"    , Row.Key);
		Options_Agreement = GetPropertyObject(Parameters, "PaymentList.Agreement", Row.Key);
		
		// ChangeLegalNameByPartner
		Options = ModelClientServer_V2.ChangeLegalNameByPartnerOptions();
		Options.Partner   = Options_Partner;
		Options.LegalName = Options_LegalName;
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ChangeLegalNameByPartner.Options.Add(Options);
		
		// ChangeAgreementByPartner
		Options = ModelClientServer_V2.ChangeAgreementByPartnerOptions();
		Options.Partner       = Options_Partner;
		Options.Agreement     = Options_Agreement;
		Options.CurrentDate   = Options_Date;
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ChangeAgreementByPartner.Options.Add(Options);
	EndDo;
EndProcedure

Procedure PaymentListPartnerStepsEnabler_BankCashReceipt(Parameters, Chain) Export
	StepsEnablerName = "PaymentListPartnerStepsEnabler_BankCashReceipt";
	
	Options_Date = GetPropertyObject(Parameters, "Date");
	
	// ChangeLegalNameByPartner
	Chain.ChangeLegalNameByPartner.Enable = True;
	Chain.ChangeLegalNameByPartner.Setter = "SetPaymentListLegalName";
	
	// ChangeAgreementByPartner
	Chain.ChangeAgreementByPartner.Enable = True;
	Chain.ChangeAgreementByPartner.Setter = "SetPaymentListAgreement";
	
	For Each Row In GetRows(Parameters, "PaymentList") Do
		Options_Partner   = GetPropertyObject(Parameters, "PaymentList.Partner"  , Row.Key);
		Options_LegalName = GetPropertyObject(Parameters, "PaymentList.Payer"    , Row.Key);
		Options_Agreement = GetPropertyObject(Parameters, "PaymentList.Agreement", Row.Key);
		
		// ChangeLegalNameByPartner
		Options = ModelClientServer_V2.ChangeLegalNameByPartnerOptions();
		Options.Partner   = Options_Partner;
		Options.LegalName = Options_LegalName;
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ChangeLegalNameByPartner.Options.Add(Options);
		
		// ChangeAgreementByPartner
		Options = ModelClientServer_V2.ChangeAgreementByPartnerOptions();
		Options.Partner       = Options_Partner;
		Options.Agreement     = Options_Agreement;
		Options.CurrentDate   = Options_Date;
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ChangeAgreementByPartner.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region PAYMENT_LIST_PARTNER_BANK_ACCOUNT

// PaymentList.PartnerBankAccount.OnChange
Procedure PaymentListPartnerBankAccountOnChange(Parameters) Export
	Binding = PaymentListPartnerBankAccountStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.PartnerBankAccount.Set
Procedure SetPaymentListPartnerBankAccount(Parameters, Results) Export
	Binding = PaymentListPartnerBankAccountStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.PartnerBankAccount.Bind
Function PaymentListPartnerBankAccountStepsBinding(Parameters)
	DataPath = "PaymentList.PartnerBankAccount";
	Binding = New Structure();
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region PAYMENT_LIST_AGREEMENT

// PaymentList.Agreement.OnChange
Procedure PaymentListAgreementOnChange(Parameters) Export
	Binding = PaymentListAgreementStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.Agreement.Set
Procedure SetPaymentListAgreement(Parameters, Results) Export
	Binding = PaymentListAgreementStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.Agreement.Bind
Function PaymentListAgreementStepsBinding(Parameters)
	DataPath = "PaymentList.Agreement";
	Binding = New Structure();
	Binding.Insert("BankPayment" , "PaymentListAgreementStepsEnabler_BankCashPaymentReceipt");
	Binding.Insert("BankReceipt" , "PaymentListAgreementStepsEnabler_BankCashPaymentReceipt");
	Binding.Insert("CashPayment" , "PaymentListAgreementStepsEnabler_BankCashPaymentReceipt");
	Binding.Insert("CashReceipt" , "PaymentListAgreementStepsEnabler_BankCashPaymentReceipt");
	Return BindSteps(Undefined, DataPath, Binding, Parameters);
EndFunction

Procedure PaymentListAgreementStepsEnabler_BankCashPaymentReceipt(Parameters, Chain) Export
	StepsEnablerName = "PaymentListAgreementStepsEnabler_BankCashPaymentReceipt";
	
	Options_Date    = GetPropertyObject(Parameters, "Date");
	Options_Company = GetPropertyObject(Parameters, "Company");
	
	//ChangeBasisDocumentByAgreement
	Chain.ChangeBasisDocumentByAgreement.Enable = True;
	Chain.ChangeBasisDocumentByAgreement.Setter = "SetPaymentListBasisDocument";
	
	//ChangeOrderByAgreement
	Chain.ChangeOrderByAgreement.Enable = True;
	Chain.ChangeOrderByAgreement.Setter = "SetPaymentListOrder";
	
	// ExtractDataAgreementApArPostingDetail
	Chain.ExtractDataAgreementApArPostingDetail.Enable = True;
	Chain.ExtractDataAgreementApArPostingDetail.Setter = "SetExtractDataAgreementApArPostingDetail";
	
	// ChangeTaxRate
	Chain.ChangeTaxRate.Enable = True;
	Chain.ChangeTaxRate.Setter = "SetPaymentListTaxRate";
	
	TaxRates = Undefined;
	If Not (Parameters.FormTaxColumnsExists And Parameters.ArrayOfTaxInfo.Count()) Then
		Parameters.ArrayOfTaxInfo = TaxesServer._GetArrayOfTaxInfo(Parameters.Object, Options_Date, Options_Company);
		TaxRates = New Structure();
		For Each ItemOfTaxInfo In Parameters.ArrayOfTaxInfo Do
			TaxRates.Insert(ItemOfTaxInfo.Name, Undefined);
		EndDo;
	EndIf;
	
	For Each Row In GetRows(Parameters, "PaymentList") Do
		Options_Agreement     = GetPropertyObject(Parameters, "PaymentList.Agreement"    , Row.Key);
		Options_BasisDocument = GetPropertyObject(Parameters, "PaymentList.BasisDocument", Row.Key);
		Options_Order         = GetPropertyObject(Parameters, "PaymentList.Order"        , Row.Key);
		
		// ChangeBasisDocumentByAgreement
		Options = ModelClientServer_V2.ChangeBasisDocumentByAgreementOptions();
		Options.Agreement            = Options_Agreement;
		Options.CurrentBasisDocument = Options_BasisDocument;
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ChangeBasisDocumentByAgreement.Options.Add(Options);
		
		// ChangeOrderByAgreement
		Options = ModelClientServer_V2.ChangeOrderByAgreementOptions();
		Options.Agreement    = Options_Agreement;
		Options.CurrentOrder = Options_Order;
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ChangeOrderByAgreement.Options.Add(Options);
		
		// ExtractDataAgreementApArPostingDetail
		Options = ModelClientServer_V2.ExtractDataAgreementApArPostingDetailOptions();
		Options.Agreement = Options_Agreement;
		Options.Key = Row.Key;
		Chain.ExtractDataAgreementApArPostingDetail.Options.Add(Options);
		
		// ChangeTaxRate
		Options = ModelClientServer_V2.ChangeTaxRateOptions();
		Options.Date           = Options_Date;
		Options.Company        = Options_Company;
		Options.Agreement      = Options_Agreement;
		Options.ArrayOfTaxInfo = Parameters.ArrayOfTaxInfo;
		Options.Ref            = Parameters.Object.Ref;
		
		If TaxRates <> Undefined Then
			For Each ItemOfTaxInfo In Parameters.ArrayOfTaxInfo Do
				SetProperty(Parameters.Cache, "PaymentList." + ItemOfTaxInfo.Name, Row.Key, Undefined);
			EndDo;
			Row.Insert("TaxRates", TaxRates);
		EndIf;
		
		Options.TaxRates = GetPaymentListTaxRate(Parameters, Row);
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ChangeTaxRate.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region PAYMENT_LIST_LEGAL_NAME

// PaymentList.LegalName.OnChange
Procedure PaymentListLegalNameOnChange(Parameters) Export
	Binding = PaymentListLegalNameStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.LegalName.Set
Procedure SetPaymentListLegalName(Parameters, Results) Export
	Binding = PaymentListLegalNameStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.LegalName.Bind
Function PaymentListLegalNameStepsBinding(Parameters)
	DataPath = New Map();
	DataPath.Insert("IncomingPaymentOrder", "PaymentList.Payer");
	DataPath.Insert("OutgoingPaymentOrder", "PaymentList.Payee");
	DataPath.Insert("BankPayment"         , "PaymentList.Payee");
	DataPath.Insert("BankReceipt"         , "PaymentList.Payer");
	DataPath.Insert("CashPayment"         , "PaymentList.Payee");
	DataPath.Insert("CashReceipt"         , "PaymentList.Payer");
	
	Binding = New Structure();
	Binding.Insert("IncomingPaymentOrder", "PaymentListLegalNameStepsEnabler_LegalNameIsPayer");
	Binding.Insert("OutgoingPaymentOrder", "PaymentListLegalNameStepsEnabler_LegalNameIsPayee");
	Binding.Insert("BankPayment"         , "PaymentListLegalNameStepsEnabler_LegalNameIsPayee");
	Binding.Insert("BankReceipt"         , "PaymentListLegalNameStepsEnabler_LegalNameIsPayer");
	Binding.Insert("CashPayment"         , "PaymentListLegalNameStepsEnabler_LegalNameIsPayee");
	Binding.Insert("CashReceipt"         , "PaymentListLegalNameStepsEnabler_LegalNameIsPayer");
	Return BindSteps(Undefined, DataPath, Binding, Parameters);
EndFunction

Procedure PaymentListLegalNameStepsEnabler_LegalNameIsPayer(Parameters, Chain) Export
	StepsEnablerName = "PaymentListLegalNameStepsEnabler_LegalNameIsPayer";
	
	// ChangePartnerByLegalName
	Chain.ChangePartnerByLegalName.Enable = True;
	Chain.ChangePartnerByLegalName.Setter = "SetPaymentListPartner";
	For Each Row In GetRows(Parameters, "PaymentList") Do
		Options = ModelClientServer_V2.ChangeLegalNameByPartnerOptions();
		Options.Partner   = GetPropertyObject(Parameters, "PaymentList.Partner", Row.Key);
		Options.LegalName = GetPropertyObject(Parameters, "PaymentList.Payer"  , Row.Key);
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ChangePartnerByLegalName.Options.Add(Options);
	EndDo;
EndProcedure

Procedure PaymentListLegalNameStepsEnabler_LegalNameIsPayee(Parameters, Chain) Export
	StepsEnablerName = "PaymentListLegalNameStepsEnabler_LegalNameIsPayee";
	
	// ChangePartnerByLegalName
	Chain.ChangePartnerByLegalName.Enable = True;
	Chain.ChangePartnerByLegalName.Setter = "SetPaymentListPartner";
	For Each Row In GetRows(Parameters, "PaymentList") Do
		Options = ModelClientServer_V2.ChangeLegalNameByPartnerOptions();
		Options.Partner   = GetPropertyObject(Parameters, "PaymentList.Partner", Row.Key);
		Options.LegalName = GetPropertyObject(Parameters, "PaymentList.Payee"  , Row.Key);
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ChangePartnerByLegalName.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region PAYMENT_LIST_LEGAL_NAME_CONTRACT

// PaymentList.LegalNameContract.OnChange
Procedure PaymentListLegalNameContractOnChange(Parameters) Export
	Binding = PaymentListLegalNameContractStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.LegalNameContract.Set
Procedure SetPaymentListLegalNameContract(Parameters, Results) Export
	Binding = PaymentListLegalNameContractStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.LegalNameContract.Bind
Function PaymentListLegalNameContractStepsBinding(Parameters)
	DataPath = "PaymentList.LegalNameContract";
	Binding = New Structure();
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region PAYMENT_LIST_POS_ACCOUNT

// PaymentList.POSAccount.OnChange
Procedure PaymentListPOSAccountOnChange(Parameters) Export
	Binding = PaymentListPOSAccountStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.POSAccount.Set
Procedure SetPaymentListPOSAccount(Parameters, Results) Export
	Binding = PaymentListPOSAccountStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.POSAccount.Bind
Function PaymentListPOSAccountStepsBinding(Parameters)
	DataPath = "PaymentList.POSAccount";
	Binding = New Structure();
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region PAYMENT_LIST_BASIS_DOCUMENT

// PaymentList.BasisDocument.OnChange
Procedure PaymentListBasisDocumentOnChange(Parameters) Export
	Binding = PaymentListBasisDocumentStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.BasisDocument.Set
Procedure SetPaymentListBasisDocument(Parameters, Results) Export
	Binding = PaymentListBasisDocumentStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.BasisDocument.Bind
Function PaymentListBasisDocumentStepsBinding(Parameters)
	DataPath = "PaymentList.BasisDocument";
	Binding = New Structure();
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region PAYMENT_LIST_PLANNING_TRANSACTION_BASIS

// PaymentList.PlanningTransactionBasis.OnChange
Procedure PaymentListPlanningTransactionBasisOnChange(Parameters) Export
	Binding = PaymentListPlanningTransactionBasisStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.PlanningTransactionBasis.Set
Procedure SetPaymentListPlanningTransactionBasis(Parameters, Results) Export
	Binding = PaymentListPlanningTransactionBasisStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.PlanningTransactionBasis.Bind
Function PaymentListPlanningTransactionBasisStepsBinding(Parameters)
	DataPath = "PaymentList.PlaningTransactionBasis";
	Binding = New Structure();
	Binding.Insert("BankPayment" , "PaymentListPTBStepsEnabler_BankPayment");
	Binding.Insert("BankReceipt" , "PaymentListPTBStepsEnabler_BankReceipt");
	Binding.Insert("CashPayment" , "PaymentListPTBStepsEnabler_CashPayment");
	Binding.Insert("CashReceipt" , "PaymentListPTBStepsEnabler_CashReceipt");
	Return BindSteps(Undefined, DataPath, Binding, Parameters);
EndFunction

// PaymentList.PlanningTransactionBasis.BankPayment.Fill
Procedure FIllPaymentListPlanningTransactionBasis_BankPayment(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Account"     , AccountStepsBinding(Parameters));
	ResourceToBinding.Insert("Company"     , CompanyStepsBinding(Parameters));
	ResourceToBinding.Insert("Currency"    , CurrencyStepsBinding(Parameters));
	ResourceToBinding.Insert("TotalAmount" , PaymentListTotalAmountStepsBinding(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// PaymentList.PlanningTransactionBasis.CashPayment.Fill
Procedure FIllPaymentListPlanningTransactionBasis_CashPayment(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Account"     , AccountStepsBinding(Parameters));
	ResourceToBinding.Insert("Company"     , CompanyStepsBinding(Parameters));
	ResourceToBinding.Insert("Currency"    , CurrencyStepsBinding(Parameters));
	ResourceToBinding.Insert("Partner"     , PaymentListPartnerStepsBinding(Parameters));
	ResourceToBinding.Insert("TotalAmount" , PaymentListTotalAmountStepsBinding(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// PaymentList.PlanningTransactionBasis.BankReceipt.Fill
Procedure FIllPaymentListPlanningTransactionBasis_BankReceipt(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Account"          , AccountStepsBinding(Parameters));
	ResourceToBinding.Insert("Company"          , CompanyStepsBinding(Parameters));
	ResourceToBinding.Insert("Currency"         , CurrencyStepsBinding(Parameters));
	ResourceToBinding.Insert("CurrencyExchange" , CurrencyExchangeStepsBinding(Parameters));
	ResourceToBinding.Insert("TotalAmount"      , PaymentListTotalAmountStepsBinding(Parameters));
	ResourceToBinding.Insert("AmountExchange"   , PaymentListAmountExchangeStepsBinding(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// PaymentList.PlanningTransactionBasis.CashReceipt.Fill
Procedure FIllPaymentListPlanningTransactionBasis_CashReceipt(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Account"          , AccountStepsBinding(Parameters));
	ResourceToBinding.Insert("Company"          , CompanyStepsBinding(Parameters));
	ResourceToBinding.Insert("Currency"         , CurrencyStepsBinding(Parameters));
	ResourceToBinding.Insert("CurrencyExchange" , CurrencyExchangeStepsBinding(Parameters));
	ResourceToBinding.Insert("Partner"          , PaymentListPartnerStepsBinding(Parameters));
	ResourceToBinding.Insert("TotalAmount"      , PaymentListTotalAmountStepsBinding(Parameters));
	ResourceToBinding.Insert("AmountExchange"   , PaymentListAmountExchangeStepsBinding(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

Procedure PaymentListPTBStepsEnabler_BankPayment(Parameters, Chain) Export
	StepsEnablerName = "PaymentListPTBStepsEnabler_BankPayment";
	
	Options_Company  = GetPropertyObject(Parameters, "Company");
	Options_Account  = GetPropertyObject(Parameters, "Account");
	Options_Currency = GetPropertyObject(Parameters, "Currency");
	
	// FillByPTBBankPayment
	Chain.FillByPTBBankPayment.Enable = True;
	Chain.FillByPTBBankPayment.Setter = "FIllPaymentListPlanningTransactionBasis_BankPayment";
	
	For Each Row In GetRows(Parameters, "PaymentList") Do
	
		// FillByPTBBankPayment
		Options = ModelClientServer_V2.FillByPTBBankPaymentOptions();
		Options.PlanningTransactionBasis = GetPropertyObject(Parameters, "PaymentList.PlaningTransactionBasis", Row.Key);
		Options.TotalAmount = GetPropertyObject(Parameters, "PaymentList.TotalAmount", Row.Key);
		Options.Company     = Options_Company;
		Options.Account     = Options_Account;
		Options.Currency    = Options_Currency;
		Options.Ref = Parameters.Object.Ref;
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.FillByPTBBankPayment.Options.Add(Options);
	EndDo;
EndProcedure

Procedure PaymentListPTBStepsEnabler_CashPayment(Parameters, Chain) Export
	StepsEnablerName = "PaymentListPTBStepsEnabler_CashPayment";
	
	Options_Company  = GetPropertyObject(Parameters, "Company");
	Options_Account  = GetPropertyObject(Parameters, "CashAccount");
	Options_Currency = GetPropertyObject(Parameters, "Currency");
	
	// FillByPTBCashPayment
	Chain.FillByPTBCashPayment.Enable = True;
	Chain.FillByPTBCashPayment.Setter = "FIllPaymentListPlanningTransactionBasis_CashPayment";
	
	
	For Each Row In GetRows(Parameters, "PaymentList") Do
	
		// FillByPTBCashPayment
		Options = ModelClientServer_V2.FillByPTBCashPaymentOptions();
		Options.PlanningTransactionBasis = GetPropertyObject(Parameters, "PaymentList.PlaningTransactionBasis", Row.Key);
		Options.TotalAmount = GetPropertyObject(Parameters, "PaymentList.TotalAmount", Row.Key);
		Options.Partner     = GetPropertyObject(Parameters, "PaymentList.Partner", Row.Key);
		Options.Company     = Options_Company;
		Options.Account     = Options_Account;
		Options.Currency    = Options_Currency;
		Options.Ref = Parameters.Object.Ref;
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.FillByPTBCashPayment.Options.Add(Options);
	EndDo;
EndProcedure

Procedure PaymentListPTBStepsEnabler_BankReceipt(Parameters, Chain) Export
	StepsEnablerName = "PaymentListPTBStepsEnabler_BankReceip";
	
	Options_Company          = GetPropertyObject(Parameters, "Company");
	Options_Account          = GetPropertyObject(Parameters, "Account");
	Options_Currency         = GetPropertyObject(Parameters, "Currency");
	Options_CurrencyExchange = GetPropertyObject(Parameters, "CurrencyExchange");
	
	// FillByPTBBankReceipt
	Chain.FIllByPTBBankReceipt.Enable = True;
	Chain.FillByPTBBankReceipt.Setter = "FIllPaymentListPlanningTransactionBasis_BankReceipt";
	
	For Each Row In GetRows(Parameters, "PaymentList") Do
		
		// FillByPTBBankReceipt
		Options = ModelClientServer_V2.FillByPTBBankReceiptOptions();
		Options.PlanningTransactionBasis = GetPropertyObject(Parameters, "PaymentList.PlaningTransactionBasis", Row.Key);
		Options.TotalAmount    = GetPropertyObject(Parameters, "PaymentList.TotalAmount", Row.Key);
		Options.AmountExchange = GetPropertyObject(Parameters, "PaymentList.AmountExchange", Row.Key);
		Options.Company  = Options_Company;
		Options.Account  = Options_Account;
		Options.Currency = Options_Currency;
		Options.CurrencyExchange = Options_CurrencyExchange;
		Options.Ref = Parameters.Object.Ref;
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.FillByPTBBankReceipt.Options.Add(Options);
	EndDo;
EndProcedure

Procedure PaymentListPTBStepsEnabler_CashReceipt(Parameters, Chain) Export
	StepsEnablerName = "PaymentListPTBStepsEnabler_CashReceip";
	
	Options_Company          = GetPropertyObject(Parameters, "Company");
	Options_Account          = GetPropertyObject(Parameters, "CashAccount");
	Options_Currency         = GetPropertyObject(Parameters, "Currency");
	Options_CurrencyExchange = GetPropertyObject(Parameters, "CurrencyExchange");
	
	// FillByPTBCashReceipt
	Chain.FillByPTBCashReceipt.Enable = True;
	Chain.FillByPTBCashReceipt.Setter = "FIllPaymentListPlanningTransactionBasis_CashReceipt";
	
	For Each Row In GetRows(Parameters, "PaymentList") Do
		
		// FillByPTBCashReceipt
		Options = ModelClientServer_V2.FillByPTBCashReceiptOptions();
		Options.PlanningTransactionBasis = GetPropertyObject(Parameters, "PaymentList.PlaningTransactionBasis", Row.Key);
		Options.TotalAmount       = GetPropertyObject(Parameters, "PaymentList.TotalAmount", Row.Key);
		Options.AmountExchange    = GetPropertyObject(Parameters, "PaymentList.AmountExchange", Row.Key);
		Options.Partner           = GetPropertyObject(Parameters, "PaymentList.Partner", Row.Key);
		Options.Company  = Options_Company;
		Options.Account  = Options_Account;
		Options.Currency = Options_Currency;
		Options.CurrencyExchange = Options_CurrencyExchange;		
		Options.Ref = Parameters.Object.Ref;
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.FillByPTBCashReceipt.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region PAYMENT_LIST_ORDER

// PaymentList.Order.OnChange
Procedure PaymentListOrderOnChange(Parameters) Export
	Binding = PaymentListOrderStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.Order.Set
Procedure SetPaymentListOrder(Parameters, Results) Export
	Binding = PaymentListOrderStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.Order.Bind
Function PaymentListOrderStepsBinding(Parameters)
	DataPath = "PaymentList.Order";
	Binding = New Structure();
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region PAYMENT_LIST_TAX_RATE

// PaymentList.TaxRate.OnChange
Procedure PaymentListTaxRateOnChange(Parameters) Export
	Binding = PaymentListTaxRateStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.TaxRate.Set
Procedure SetPaymentListTaxRate(Parameters, Results) Export
	Binding = PaymentListTaxRateStepsBinding(Parameters);
	ReadOnlyFromCache = Not Parameters.FormTaxColumnsExists;
	For Each Result In Results Do
		For Each TaxRate In Result.Value Do
			TaxRateResult = New Array();
			TaxRateResult.Add(New Structure("Value, Options", TaxRate.Value, Result.Options));
			SetterObject(Binding.StepsEnabler, Binding.DataPath + TaxRate.Key,
				Parameters, TaxRateResult, , , ,ReadOnlyFromCache);
		EndDo;
	EndDo;
EndProcedure

// PaymentList.TaxRate.Get
Function GetPaymentListTaxRate(Parameters, Row)
	TaxRates = New Structure();
	// когда нет формы то колонки со ставками налогов только в кэше
	// потому что колонки со ставками налога это реквизиты формы
	ReadOnlyFromCache = Not Parameters.FormTaxColumnsExists;
	For Each TaxRate In Row.TaxRates Do
		If ReadOnlyFromCache And ValueIsFilled(TaxRate.Value) Then
			TaxRates.Insert(TaxRate.Key, TaxRate.Value);
		Else
			TaxRates.Insert(TaxRate.Key, 
				GetPropertyObject(Parameters, "PaymentList."+TaxRate.Key, Row.Key, ReadOnlyFromCache));
		EndIf;
	EndDo;
	Return TaxRates;
EndFunction

// PaymentList.TaxRate.Bind
Function PaymentListTaxRateStepsBinding(Parameters)
	DataPath = "PaymentList.";
	Binding = New Structure();
	Return BindSteps("PaymentListTaxRateStepsEnabler", DataPath, Binding, Parameters);
EndFunction

Procedure PaymentListTaxRateStepsEnabler(Parameters, Chain) Export
	PaymentListEnableCalculations(Parameters, Chain, "IsTaxRateChanged");
EndProcedure

#EndRegion

#Region PAYMENT_LIST_TAX_AMOUNT

// PaymentList.TaxAmount.OnChange
Procedure PaymentListTaxAmountOnChange(Parameters) Export
	Binding = PaymentListTaxAmountStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.TaxAmount.Set
Procedure SetPaymentListTaxAmount(Parameters, Results) Export
	Binding = PaymentListTaxAmountStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.TaxAmount.Bind
Function PaymentListTaxAmountStepsBinding(Parameters)
	DataPath = "PaymentList.TaxAmount";
	Binding = New Structure();
	Return BindSteps("PaymentListTaxAmountStepsEnabler", DataPath, Binding, Parameters);
EndFunction

Procedure PaymentListTaxAmountStepsEnabler(Parameters, Chain) Export
	StepsEnablerName = "PaymentListTaxAmountStepsEnabler";
	
	PaymentListEnableCalculations(Parameters, Chain, "IsTaxAmountChanged");
	
	// ChangeTaxAmountAsManualAmount
	Chain.ChangeTaxAmountAsManualAmount.Enable = True;
	Chain.ChangeTaxAmountAsManualAmount.Setter = "SetPaymentListTaxAmount";
	For Each Row In GetRows(Parameters, "PaymentList") Do
		Options = ModelClientServer_V2.ChangeTaxAmountAsManualAmountOptions();
		Options.TaxAmount = GetPropertyObject(Parameters, "PaymentList.TaxAmount", Row.Key);
		Options.TaxList   = Row.TaxList;
		Options.Key       = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ChangeTaxAmountAsManualAmount.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region PAYMENT_LIST_NET_AMOUNT

// PaymentList.NetAmount.OnChange
Procedure PaymentListNetAmountOnChange(Parameters) Export
	Binding = PaymentListNetAmountStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.NetAmount.Bind
Function PaymentListNetAmountStepsBinding(Parameters)
	DataPath = "PaymentList.NetAmount";
	Binding = New Structure();
	Binding.Insert("BankPayment", "PaymentListNetAmountStepsEnabler");
	Binding.Insert("BankReceipt", "PaymentListNetAmountStepsEnabler");
	Binding.Insert("CashPayment", "PaymentListNetAmountStepsEnabler");
	Binding.Insert("CashReceipt", "PaymentListNetAmountStepsEnabler");
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

Procedure PaymentListNetAmountStepsEnabler(Parameters, Chain) Export
	PaymentListEnableCalculations(Parameters, Chain, "IsNetAmountChanged");
EndProcedure

#EndRegion

#Region PAYMENT_LIST_TOTAL_AMOUNT

// PaymentList.TotalAmount.OnChange
Procedure PaymentListTotalAmountOnChange(Parameters) Export
	Binding = PaymentListTotalAmountStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.TotalAmount.Set
Procedure SetPaymentListTotalAmount(Parameters, Results) Export
	Binding = PaymentListTotalAmountStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.TotalAmount.Bind
Function PaymentListTotalAmountStepsBinding(Parameters)
	DataPath = "PaymentList.TotalAmount";
	Binding = New Structure();
	Binding.Insert("BankPayment", "PaymentListTotalAmountStepsEnabler");
	Binding.Insert("BankReceipt", "PaymentListTotalAmountStepsEnabler");
	Binding.Insert("CashPayment", "PaymentListTotalAmountStepsEnabler");
	Binding.Insert("CashReceipt", "PaymentListTotalAmountStepsEnabler");
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

Procedure PaymentListTotalAmountStepsEnabler(Parameters, Chain) Export
	PaymentListEnableCalculations(Parameters, Chain, "IsTotalAmountChanged");
EndProcedure

#EndRegion

#Region PAYMENT_LIST_AMOUNT_EXCHANGE

// PaymentList.AmountExchange.Set
Procedure SetPaymentListAmountExchange(Parameters, Results) Export
	Binding = PaymentListAmountExchangeStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.AmountExchange.Bind
Function PaymentListAmountExchangeStepsBinding(Parameters)
	DataPath = "PaymentList.AmountExchange";
	Binding = New Structure();
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region PAYMENT_LIST_CALCULATIONS_NET_TAX_TOTAL

Procedure PaymentListEnableCalculations(Parameters, Chain, WhoIsChanged)
	StepsEnablerName = "PaymentListEnableCalculations";
	
	Chain.Calculations.Enable = True;
	Chain.Calculations.Setter = "SetPaymentListCalculations";
	
	For Each Row In GetRows(Parameters, "PaymentList") Do
		
		Options     = ModelClientServer_V2.CalculationsOptions();
		Options.Ref = Parameters.Object.Ref;
		
		// нужно пересчитать NetAmount, TotalAmount, TaxAmount
		If     WhoIsChanged = "IsTaxRateChanged" Or WhoIsChanged = "IsCopyRow" Then
			Options.CalculateNetAmount.Enable     = True;
			Options.CalculateTotalAmount.Enable   = True;
			Options.CalculateTaxAmount.Enable     = True;
			
		ElsIf WhoIsChanged = "IsTotalAmountChanged" Or WhoIsChanged = "RecalculationsOnCopy" Then
			// при изменении TotalAmount налоги расчитываются в обратную сторону, меняется NetAmount
			Options.CalculateTaxAmountReverse.Enable   = True;
			Options.CalculateNetAmountAsTotalAmountMinusTaxAmount.Enable   = True;
			
		ElsIf WhoIsChanged = "IsTaxAmountChanged" Then
			// указываем на то что нужно использовать ManualAmount (сумма введеная вручную) при расчете TaxAmount
			Options.TaxOptions.UseManualAmount = True;
			
			Options.CalculateNetAmount.Enable   = True;
			Options.CalculateTotalAmount.Enable = True;
			Options.CalculateTaxAmount.Enable   = True;
			
		ElsIf WhoIsChanged = "IsNetAmountChanged" Then
			Options.CalculateTaxAmountByNetAmount.Enable   = True;
			Options.CalculateTotalAmountByNetAmount.Enable = True;
		Else
			Raise StrTemplate("Unsupported [WhoIsChanged] = %1", WhoIsChanged);
		EndIf;
		
		Options.AmountOptions.DontCalculateRow = False;
		
		Options.AmountOptions.NetAmount        = GetPropertyObject(Parameters, "PaymentList.NetAmount"    , Row.Key);
		Options.AmountOptions.TaxAmount        = GetPropertyObject(Parameters, "PaymentList.TaxAmount"    , Row.Key);
		Options.AmountOptions.TotalAmount      = GetPropertyObject(Parameters, "PaymentList.TotalAmount"  , Row.Key);
		
		Options.TaxOptions.ArrayOfTaxInfo   = Parameters.ArrayOfTaxInfo;
		Options.TaxOptions.TaxRates         = GetPaymentListTaxRate(Parameters, Row);
		Options.TaxOptions.TaxList          = Row.TaxList;
		
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.Calculations.Options.Add(Options);
	EndDo;
EndProcedure

// PaymentList.Calculations.Set
Procedure SetPaymentListCalculations(Parameters, Results) Export
	Binding = PaymentListCalculationsStepsBinding(Parameters);
	SetterObject(Undefined, "PaymentList.NetAmount"   , Parameters, Results, , "NetAmount");
	SetterObject(Undefined, "PaymentList.TaxAmount"   , Parameters, Results, , "TaxAmount");
	SetterObject(Binding.StepsEnabler, "PaymentList.TotalAmount" , Parameters, Results, , "TotalAmount");
	
	// табличная часть TaxList кэщируется целиком, потом так же целиком переносится в документ
	For Each Result In Results Do
		If Result.Value.TaxList.Count() Then
			If Not Parameters.Cache.Property("TaxList") Then
				Parameters.Cache.Insert("TaxList", New Array());
			EndIf;
			
			// удаляем из кэша старые строки
			Count = Parameters.Cache.TaxList.Count();
			For i = 1 To Count Do
				Index = Count - i;
				ArrayItem = Parameters.Cache.TaxList[Index];
				If ArrayItem.Key = Result.Options.Key Then
					Parameters.Cache.TaxList.Delete(Index);
				EndIf;
			EndDo;
			
			// добавляем новые строки
			For Each Row In Result.Value.TaxList Do
				Parameters.Cache.TaxList.Add(Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

// PaymentList.Calculations.Bind
Function PaymentListCalculationsStepsBinding(Parameters)
	DataPath = "";
	Binding = New Structure();
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#EndRegion

#Region ITEM_LIST

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
	Binding.Insert("GoodsReceipt"        , "ItemListItemStepsEnabler");
	Binding.Insert("StockAdjustmentAsSurplus" , "ItemListItemStepsEnabler");
	Binding.Insert("StockAdjustmentAsWriteOff", "ItemListItemStepsEnabler");
	Binding.Insert("SalesInvoice"        , "ItemListItemStepsEnabler");
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

Procedure ItemListItemStepsEnabler(Parameters, Chain) Export
	Chain.ChangeItemKeyByItem.Enable = True;
	Chain.ChangeItemKeyByItem.Setter = "SetItemListItemKey";
	For Each Row In GetRows(Parameters, "ItemList") Do
		Options = ModelClientServer_V2.ChangeItemKeyByItemOptions();
		Options.Item    = GetPropertyObject(Parameters, "ItemList.Item"   , Row.Key);
		Options.ItemKey = GetPropertyObject(Parameters, "ItemList.ItemKey", Row.Key);
		Options.Key = Row.Key;
		Chain.ChangeItemKeyByItem.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_LIST_ITEMKEY

// ItemList.ItemKey.OnChange
Procedure ItemListItemKeyOnChange(Parameters) Export
	AddViewNotify("OnSetItemListItemKey", Parameters);
	Binding = ItemListItemKeyStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.ItemKey.Set
Procedure SetItemListItemKey(Parameters, Results) Export
	Binding = ItemListItemKeyStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetItemListItemKey");
EndProcedure

// ItemList.ItemKey.Bind
Function ItemListItemKeyStepsBinding(Parameters)
	DataPath = "ItemList.ItemKey";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation", "ItemListItemKeyStepsEnabler_Warehouse_ShipmentReceipt");
	Binding.Insert("GoodsReceipt"        , "ItemListItemKeyStepsEnabler_Warehouse_ShipmentReceipt");
	Binding.Insert("StockAdjustmentAsSurplus" , "ItemListItemKeyStepsEnabler_Warehouse_ShipmentReceipt");
	Binding.Insert("StockAdjustmentAsWriteOff", "ItemListItemKeyStepsEnabler_Warehouse_ShipmentReceipt");
	Binding.Insert("SalesInvoice"        , "ItemListItemKeyStepsEnabler_Trade_Shipment");
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

Procedure ItemListItemKeyStepsEnabler_Warehouse_ShipmentReceipt(Parameters, Chain) Export
	StepsEnablerName = "ItemListItemKeyStepsEnabler_Warehouse_ShipmentReceipt";
	
	// ExtractDataItemKeysWithSerialLotNumbers
	Chain.ExtractDataItemKeysWithSerialLotNumbers.Enable = True;
	Chain.ExtractDataItemKeysWithSerialLotNumbers.Setter = "SetExtractDataItemKeysWithSerialLotNumbers";
	For Each Row In Parameters.Object.ItemList Do
		Options = ModelClientServer_V2.ExtractDataItemKeysWithSerialLotNumbersOptions();
		Options.ItemKey = GetPropertyObject(Parameters, "ItemList.ItemKey", Row.Key);
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Options.DontExecuteIfExecutedBefore = True;
		Chain.ExtractDataItemKeysWithSerialLotNumbers.Options.Add(Options);
	EndDo;
	
	// ChangeUnitByItemKey
	Chain.ChangeUnitByItemKey.Enable = True;
	Chain.ChangeUnitByItemKey.Setter = "SetItemListUnit";
	For Each Row In GetRows(Parameters, "ItemList") Do
		// ChangeUnitByItemKey
		Options = ModelClientServer_V2.ChangeUnitByItemKeyOptions();
		Options.ItemKey = GetPropertyObject(Parameters, "ItemList.ItemKey", Row.Key);
		Options.Key = Row.Key;
		Chain.ChangeUnitByItemKey.Options.Add(Options);
	EndDo;
EndProcedure

Procedure ItemListItemKeyStepsEnabler_Trade_Shipment(Parameters, Chain) Export
	StepsEnablerName = "ItemListItemKeyStepsEnabler_Trade_Shipment";
	
	// ExtractDataItemKeysWithSerialLotNumbers
	Chain.ExtractDataItemKeysWithSerialLotNumbers.Enable = True;
	Chain.ExtractDataItemKeysWithSerialLotNumbers.Setter = "SetExtractDataItemKeysWithSerialLotNumbers";
	For Each Row In Parameters.Object.ItemList Do
		Options = ModelClientServer_V2.ExtractDataItemKeysWithSerialLotNumbersOptions();
		Options.ItemKey = GetPropertyObject(Parameters, "ItemList.ItemKey", Row.Key);
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Options.DontExecuteIfExecutedBefore = True;
		Chain.ExtractDataItemKeysWithSerialLotNumbers.Options.Add(Options);
	EndDo;
	
	// ChangeUnitByItemKey
	Chain.ChangeUnitByItemKey.Enable = True;
	Chain.ChangeUnitByItemKey.Setter = "SetItemListUnit";
	
	// ChangeUseShipmentConfirmationByStore
	Chain.ChangeUseShipmentConfirmationByStore.Enable = True;
	Chain.ChangeUseShipmentConfirmationByStore.Setter = "SetItemListUseShipmentConfirmation";
	
	// ChangePriceTypeByAgreement
	Chain.ChangePriceTypeByAgreement.Enable = True;
	Chain.ChangePriceTypeByAgreement.Setter = "SetItemListPriceType";
	
	
	// ChangePriceByPriceType
	Chain.ChangePriceByPriceType.Enable = True;
	Chain.ChangePriceByPriceType.Setter = "SetItemListPrice";
	
	// ChangeTaxRate
	Chain.ChangeTaxRate.Enable = True;
	Chain.ChangeTaxRate.Setter = "SetItemListTaxRate";
	
	Options_Date      = GetPropertyObject(Parameters, "Date");
	Options_Agreement = GetPropertyObject(Parameters, "Agreement");
	Options_Company   = GetPropertyObject(Parameters, "Company");
	
	For Each Row In GetRows(Parameters, "ItemList") Do
		
		Options_ItemKey   = GetPropertyObject(Parameters, "ItemList.ItemKey"  , Row.Key);
		Options_Store     = GetPropertyObject(Parameters, "ItemList.Store"    , Row.Key);
		Options_Price     = GetPropertyObject(Parameters, "ItemList.Price"    , Row.Key);
		Options_PriceType = GetPropertyObject(Parameters, "ItemList.PriceType", Row.Key);
		Options_Unit      = GetPropertyObject(Parameters, "ItemList.Unit"     , Row.Key);
		
		// ChangeUnitByItemKey
		Options = ModelClientServer_V2.ChangeUnitByItemKeyOptions();
		Options.ItemKey = Options_ItemKey;
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ChangeUnitByItemKey.Options.Add(Options);
		
		// ChangeUseShipmentConfirmationByStore
		Options = ModelClientServer_V2.ChangeUseShipmentConfirmationByStoreOptions();
		Options.ItemKey = Options_ItemKey;
		Options.Store   = Options_Store;
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ChangeUseShipmentConfirmationByStore.Options.Add(Options);
		
		// ChangePriceTypeByAgreement
		Options = ModelClientServer_V2.ChangePriceTypeByAgreementOptions();
		Options.Agreement = Options_Agreement;
		Options.Key = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ChangePriceTypeByAgreement.Options.Add(Options);
		
		// ChangePriceByPriceType
		Options = ModelClientServer_V2.ChangePriceByPriceTypeOptions();
		Options.Ref          = Parameters.Object.Ref;
		Options.Date         = Options_Date;
		Options.CurrentPrice = Options_Price;
		Options.PriceType    = Options_PriceType;
		Options.ItemKey      = Options_ItemKey;
		Options.Unit         = Options_Unit;
		Options.Key          = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Options.DontExecuteIfExecutedBefore = True;
		Chain.ChangePriceByPriceType.Options.Add(Options);
	
		// ChangeTaxRate
		Options = ModelClientServer_V2.ChangeTaxRateOptions();
		Options.Date           = Options_Date;
		Options.Company        = Options_Company;
		Options.Agreement      = Options_Agreement;
		Options.ItemKey        = Options_ItemKey;
		Options.ArrayOfTaxInfo = Parameters.ArrayOfTaxInfo;
		Options.Ref            = Parameters.Object.Ref;
		Options.TaxRates       = GetItemListTaxRate(Parameters, Row);
		Options.Key            = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ChangeTaxRate.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_LIST_UNIT

// ItemList.Unit.OnChange
Procedure ItemListUnitOnChange(Parameters) Export
	Binding = ItemListUnitStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.Unit.Set
Procedure SetItemListUnit(Parameters, Results) Export
	Binding = ItemListUnitStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.Unit.Bind
Function ItemListUnitStepsBinding(Parameters)
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

#Region ITEM_LIST_PRICE_TYPE

// ItemList.PriceType.OnChange
Procedure ItemListPriceTypeOnChange(Parameters) Export
	Binding = ItemListPriceTypeStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.PriceType.Set
Procedure SetItemListPriceType(Parameters, Results) Export
	Binding = ItemListPriceTypeStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.PriceType.Bind
Function ItemListPriceTypeStepsBinding(Parameters)
	DataPath = "ItemList.PriceType";
	Binding = New Structure();
	Return BindSteps("ItemListPriceTypeStepsEnabler", DataPath, Binding, Parameters);
EndFunction

Procedure ItemListPriceTypeStepsEnabler(Parameters, Chain) Export
	StepsEnablerName = "ItemListPriceTypeStepsEnabler";
	
	// ChangePriceByPriceType
	Chain.ChangePriceByPriceType.Enable = True;
	Chain.ChangePriceByPriceType.Setter = "SetItemListPrice";
	
	For Each Row In GetRows(Parameters, "ItemList") Do
		// ChangePriceByPriceType
		Options = ModelClientServer_V2.ChangePriceByPriceTypeOptions();
		Options.Ref          = Parameters.Object.Ref;
		Options.Date         = GetPropertyObject(Parameters, "Date");
		Options.CurrentPrice = GetPropertyObject(Parameters, "ItemList.Price", Row.Key);
		Options.PriceType    = GetPropertyObject(Parameters, "ItemList.PriceType", Row.Key);
		Options.ItemKey      = GetPropertyObject(Parameters, "ItemList.ItemKey"  , Row.Key);
		Options.Unit         = GetPropertyObject(Parameters, "ItemList.Unit"     , Row.Key);
		Options.Key          = Row.Key;
		Options.StepsEnablerName = StepsEnablerName;
		Chain.ChangePriceByPriceType.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_LIST_PRICE

// ItemList.Price.OnChange
Procedure ItemListPriceOnChange(Parameters) Export
	Binding = ItemListPriceStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.Price.Set
Procedure SetItemListPrice(Parameters, Results) Export
	Binding = ItemListPriceStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.Price.Bind
Function ItemListPriceStepsBinding(Parameters)
	DataPath = "ItemList.Price";
	Binding = New Structure();
	Return BindSteps("ItemListPriceStepsEnabler", DataPath, Binding, Parameters);
EndFunction

Procedure ItemListPriceStepsEnabler(Parameters, Chain) Export
	ItemListEnableCalculations(Parameters, Chain, "IsPriceChanged");
	
	Chain.ChangePriceTypeAsManual.Enable = True;
	Chain.ChangePriceTypeAsManual.Setter = "SetItemListPriceType";
	For Each Row In GetRows(Parameters, "ItemList") Do
		Options = ModelClientServer_V2.ChangePriceTypeAsManualOptions();
		Options.IsUserChange     = IsUserChange(Parameters);
		Options.CurrentPriceType = GetPropertyObject(Parameters, "ItemList.PriceType", Row.Key);
		Options.Key = Row.Key;
		Chain.ChangePriceTypeAsManual.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_LIST_DONTCALCULATEROW

// ItemList.DontCalculateRow.OnChange
Procedure ItemListDontCalculateRowOnChange(Parameters) Export
	Binding = ItemListDontCalculateRowStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.DontCalculateRow.Set
Procedure SetItemListDontCalculateRow(Parameters, Results) Export
	Binding = ItemListDontCalculateRowStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.DontCalculateRow.Bind
Function ItemListDontCalculateRowStepsBinding(Parameters)
	DataPath = "ItemList.DontCalculateRow";
	Binding = New Structure();
	Return BindSteps("ItemListDontCalculateRowStepsEnabler", DataPath, Binding, Parameters);
EndFunction

Procedure ItemListDontCalculateRowStepsEnabler(Parameters, Chain) Export
	ItemListEnableCalculations(Parameters, Chain, "IsDontCalculateRowChanged");
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
Function ItemListQuantityStepsBinding(Parameters)
	DataPath = "ItemList.Quantity";
	Binding = New Structure();
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

Procedure ItemListQuantityStepsEnabler(Parameters, Chain) Export
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

#Region ITEM_LIST_QUANTITY_IN_BASE_UNIT

// ItemList.QuantityInBaseUnit.Set
Procedure SetItemListQuantityInBaseUnit(Parameters, Results) Export
	Binding = ItemListQuantityInBaseUnitStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath , Parameters, Results,
		"OnSetItemListQuantityInBaseUnitNotify", "QuantityInBaseUnit");
EndProcedure

// ItemList.QuantityInBaseUnit.Bind
Function ItemListQuantityInBaseUnitStepsBinding(Parameters)
	DataPath = "ItemList.QuantityInBaseUnit";
	Binding = New Structure();
	Binding.Insert("SalesInvoice", "ItemListQuantityInBaseUnitStepsEnabler_Trade");
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

Procedure ItemListQuantityInBaseUnitStepsEnabler_Trade(Parameters, Chain) Export
	ItemListEnableCalculations(Parameters, Chain, "IsQuantityInBaseUnitChanged");
EndProcedure

#EndRegion

#Region ITEM_LIST_TAX_RATE

// ItemList.TaxRate.OnChange
Procedure ItemListTaxRateOnChange(Parameters) Export
	Binding = ItemListTaxRateStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.TaxRate.Set
Procedure SetItemListTaxRate(Parameters, Results) Export
	Binding = ItemListTaxRateStepsBinding(Parameters);
	ReadOnlyFromCache = Not Parameters.FormTaxColumnsExists;
	For Each Result In Results Do
		For Each TaxRate In Result.Value Do
			TaxRateResult = New Array();
			TaxRateResult.Add(New Structure("Value, Options", TaxRate.Value, Result.Options));
			SetterObject(Binding.StepsEnabler, Binding.DataPath + TaxRate.Key,
				Parameters, TaxRateResult, , , ,ReadOnlyFromCache);
		EndDo;
	EndDo;
EndProcedure

// ItemList.TaxRate.Get
Function GetItemListTaxRate(Parameters, Row)
	TaxRates = New Structure();
	// когда нет формы то колонки со ставками налогов только в кэше
	// потому что колонки со ставками налога это реквизиты формы
	ReadOnlyFromCache = Not Parameters.FormTaxColumnsExists;
	For Each TaxRate In Row.TaxRates Do
		If ReadOnlyFromCache And ValueIsFilled(TaxRate.Value) Then
			TaxRates.Insert(TaxRate.Key, TaxRate.Value);
		Else
			TaxRates.Insert(TaxRate.Key, 
				GetPropertyObject(Parameters, "ItemList."+TaxRate.Key, Row.Key, ReadOnlyFromCache));
		EndIf;
	EndDo;
	Return TaxRates;
EndFunction

// ItemList.TaxRate.Bind
Function ItemListTaxRateStepsBinding(Parameters)
	DataPath = "ItemList.";
	Binding = New Structure();
	Return BindSteps("ItemListTaxRateStepsEnabler", DataPath, Binding, Parameters);
EndFunction

Procedure ItemListTaxRateStepsEnabler(Parameters, Chain) Export
	ItemListEnableCalculations(Parameters, Chain, "IsTaxRateChanged");
EndProcedure

#EndRegion

#Region ITEM_LIST_TAX_AMOUNT

// ItemList.TaxAmount.OnChange
Procedure ItemListTaxAmountOnChange(Parameters) Export
	Binding = ItemListTaxAmountStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.TaxAmount.Set
Procedure SetItemListTaxAmount(Parameters, Results) Export
	Binding = ItemListTaxAmountStepsBinding(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.TaxAmount.Bind
Function ItemListTaxAmountStepsBinding(Parameters)
	DataPath = "ItemList.TaxAmount";
	Binding = New Structure();
	Return BindSteps("ItemListTaxAmountStepsEnabler", DataPath, Binding, Parameters);
EndFunction

Procedure ItemListTaxAmountStepsEnabler(Parameters, Chain) Export
	ItemListEnableCalculations(Parameters, Chain, "IsTaxAmountChanged");
	Chain.ChangeTaxAmountAsManualAmount.Enable = True;
	Chain.ChangeTaxAmountAsManualAmount.Setter = "SetItemListTaxAmount";
	For Each Row In GetRows(Parameters, "ItemList") Do
		Options = ModelClientServer_V2.ChangeTaxAmountAsManualAmountOptions();
		Options.TaxAmount = GetPropertyObject(Parameters, "ItemList.TaxAmount", Row.Key);
		Options.TaxList   = Row.TaxList;
		Options.Key       = Row.Key;
		Chain.ChangeTaxAmountAsManualAmount.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_LIST_OFFERS_AMOUNT

// ItemList.OffersAmount.OnChange
Procedure ItemListOffersAmountOnChange(Parameters) Export
	Binding = ItemListOffersAmountStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.OffersAmount.Bind
Function ItemListOffersAmountStepsBinding(Parameters)
	DataPath = "ItemList.OffersAmount";
	Binding = New Structure();
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region ITEM_LIST_TOTAL_AMOUNT

// ItemList.TotalAmount.OnChange
Procedure ItemListTotalAmountOnChange(Parameters) Export
	Binding = ItemListTotalAmountStepsBinding(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.TotalAmount.Bind
Function ItemListTotalAmountStepsBinding(Parameters)
	DataPath = "ItemList.TotalAmount";
	Binding = New Structure();
	Binding.Insert("SalesInvoice", "ItemListTotalAmountStepsEnabler");
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

Procedure ItemListTotalAmountStepsEnabler(Parameters, Chain) Export
	ItemListEnableCalculations(Parameters, Chain, "IsTotalAmountChanged");
	
	// ChangePriceTypeAsManual
	Chain.ChangePriceTypeAsManual.Enable = True;
	Chain.ChangePriceTypeAsManual.Setter = "SetItemListPriceType";
	For Each Row In GetRows(Parameters, "ItemList") Do
		Options = ModelClientServer_V2.ChangePriceTypeAsManualOptions();
		Options.IsTotalAmountChange = True;
		Options.CurrentPriceType = GetPropertyObject(Parameters, "ItemList.PriceType", Row.Key);
		Options.DontCalculateRow = GetPropertyObject(Parameters, "ItemList.DontCalculateRow", Row.Key);
		Options.Key = Row.Key;
		Chain.ChangePriceTypeAsManual.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_LIST_CALCULATIONS_NET_OFFERS_TAX_TOTAL

Procedure ItemListEnableCalculations(Parameters, Chain, WhoIsChanged)
	Chain.Calculations.Enable = True;
	Chain.Calculations.Setter = "SetItemListCalculations";
	
	For Each Row In GetRows(Parameters, "ItemList") Do
		
		Options     = ModelClientServer_V2.CalculationsOptions();
		Options.Ref = Parameters.Object.Ref;
		
		// нужно пересчитать NetAmount, TotalAmount, TaxAmount, OffersAmount
		If     WhoIsChanged = "IsPriceChanged"            Or WhoIsChanged = "IsPriceIncludeTaxChanged"
			Or WhoIsChanged = "IsDontCalculateRowChanged" Or WhoIsChanged = "IsQuantityInBaseUnitChanged" 
			Or WhoIsChanged = "IsTaxRateChanged"          Or WhoIsChanged = "IsOffersChanged"
			Or WhoIsChanged = "IsCopyRow"
			Or WhoIsChanged = "RecalculationsAfterQuestionToUser" Or WhoIsChanged = "RecalculationsOnCopy" Then
			Options.CalculateNetAmount.Enable     = True;
			Options.CalculateTotalAmount.Enable   = True;
			Options.CalculateTaxAmount.Enable     = True;
			Options.CalculateSpecialOffers.Enable = True;
		ElsIf WhoIsChanged = "IsTotalAmountChanged" Then
		// при изменении TotalAmount налоги расчитываются в обратную сторону, меняется NetAmount и Price
			Options.CalculateTaxAmountReverse.Enable   = True;
			Options.CalculateNetAmountAsTotalAmountMinusTaxAmount.Enable   = True;
			Options.CalculatePriceByTotalAmount.Enable = True;
		ElsIf WhoIsChanged = "IsTaxAmountChanged" Then
			// указываем на то что нужно использовать ManualAmount (сумма введеная вручную) при расчете TaxAmount
			Options.TaxOptions.UseManualAmount = True;
			
			Options.CalculateNetAmount.Enable   = True;
			Options.CalculateTotalAmount.Enable = True;
			Options.CalculateTaxAmount.Enable   = True;
		Else
			Raise StrTemplate("Unsupported [WhoIsChanged] = %1", WhoIsChanged);
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
		Options.TaxOptions.ArrayOfTaxInfo   = Parameters.ArrayOfTaxInfo;
		Options.TaxOptions.TaxRates         = GetItemListTaxRate(Parameters, Row);
		Options.TaxOptions.TaxList          = Row.TaxList;
		
		Options.OffersOptions.SpecialOffers = Row.SpecialOffers;
		
		Options.Key = Row.Key;
		
		Chain.Calculations.Options.Add(Options);
	EndDo;
EndProcedure

// ItemList.Calculations.Set
Procedure SetItemListCalculations(Parameters, Results) Export
	Binding = ItemListCalculationsStepsBinding(Parameters);
	SetterObject(Undefined, "ItemList.NetAmount"   , Parameters, Results, , "NetAmount");
	SetterObject(Undefined, "ItemList.TaxAmount"   , Parameters, Results, , "TaxAmount");
	SetterObject(Undefined, "ItemList.OffersAmount", Parameters, Results, , "OffersAmount");
	SetterObject(Undefined, "ItemList.Price"       , Parameters, Results, , "Price");
	SetterObject(Binding.StepsEnabler, "ItemList.TotalAmount" , Parameters, Results, , "TotalAmount");
	
	// табличная часть TaxList кэщируется целиком, потом так же целиком переносится в документ
	For Each Result In Results Do
		If Result.Value.TaxList.Count() Then
			If Not Parameters.Cache.Property("TaxList") Then
				Parameters.Cache.Insert("TaxList", New Array());
			EndIf;
			
			// удаляем из кэша старые строки
			Count = Parameters.Cache.TaxList.Count();
			For i = 1 To Count Do
				Index = Count - i;
				ArrayItem = Parameters.Cache.TaxList[Index];
				If ArrayItem.Key = Result.Options.Key Then
					Parameters.Cache.TaxList.Delete(Index);
				EndIf;
			EndDo;
			
			// добавляем новые строки
			For Each Row In Result.Value.TaxList Do
				Parameters.Cache.TaxList.Add(Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

// ItemList.Calculations.Bind
Function ItemListCalculationsStepsBinding(Parameters)
	DataPath = "";
	Binding = New Structure();
	Binding.Insert("SalesInvoice", "ItemListCalculationsStepsEnabler");
	Return BindSteps("StepsEnablerEmpty", DataPath, Binding, Parameters);
EndFunction

Procedure ItemListCalculationsStepsEnabler(Parameters, Chain) Export
	// UpdatePaymentTerms
	Chain.UpdatePaymentTerms.Enable = True;
	Chain.UpdatePaymentTerms.Setter = "SetPaymentTerms";
	Options = ModelClientServer_V2.UpdatePaymentTermsOptions();
	Options.Date = GetPropertyObject(Parameters, "Date");
	Options.ArrayOfPaymentTerms = GetPaymentTerms(Parameters);
	// нужны все строки таблицы
	TotalAmount = 0;
	For Each Row In Parameters.Object.ItemList Do
		TotalAmount = TotalAmount + GetPropertyObject(Parameters, "ItemList.TotalAmount", Row.Key);
	EndDo;
	Options.TotalAmount = TotalAmount;
	Chain.UpdatePaymentTerms.Options.Add(Options);
EndProcedure

#EndRegion

#EndRegion

// Вызывается когда вся цепочка связанных действий будет заверщена
Procedure OnChainComplete(Parameters) Export
	#IF Client THEN
		// на клиенте возможно нужно задать вопрос пользователю, поэтому сразу из кэша в объект не переносим
		Execute StrTemplate("%1.OnChainComplete(Parameters);", Parameters.ViewClientModuleName);
	#ENDIF
	
	#IF Server THEN
		// на сервере спрашивать некого, сразу переносим из кэша в объект
		CommitChainChanges(Parameters);
	#ENDIF
EndProcedure

Procedure CommitChainChanges(Parameters) Export
		
	_CommitChainChanges(Parameters.Cache, Parameters.Object);
	
	If Parameters.FormIsExists Then
		UniqueFormModificators = New Array();
		For Each FormModificator In Parameters.FormModificators Do
			If UniqueFormModificators.Find(FormModificator) = Undefined Then
				UniqueFormModificators.Add(FormModificator);
			EndIf;
		EndDo;
		For Each FormModificator In UniqueFormModificators Do
			ViewModuleName = "";
			#IF Client THEN
				ViewModuleName = Parameters.ViewClientModuleName;
			#ELSIF Server THEN
				ViewModuleName = Parameters.ViewServerModuleName;
			#ENDIF
			Execute StrTemplate("%1.%2(Parameters);", ViewModuleName, FormModificator);
		EndDo;
		
		_CommitChainChanges(Parameters.CacheForm, Parameters.Form);
		
	//EndIf;
	
	
	#IF Client THEN
		//_CommitChainChanges(Parameters.CacheForm, Parameters.Form);
		
		UniqueViewNotify = New Array();
		For Each ViewNotify In Parameters.ViewNotify Do
			If UniqueViewNotify.Find(ViewNotify) = Undefined Then
				UniqueViewNotify.Add(ViewNotify);
			EndIf;
		EndDo;
		For Each ViewNotify In UniqueViewNotify Do
			Execute StrTemplate("%1.%2(Parameters);", Parameters.ViewClientModuleName, ViewNotify);
		EndDo;
	#ENDIF
	EndIf;
EndProcedure

// Переносит изменения из Cache в Object из CacheForm в Fomr
Procedure _CommitChainChanges(Cache, Source)
	For Each Property In Cache Do
		PropertyName  = Property.Key;
		PropertyValue = Property.Value;
		If Upper(PropertyName) = Upper("TaxList") Then
			// табличная часть налогов переносится целиком
			ArrayOfKeys = New Array();
			For Each Row In PropertyValue Do
				If ArrayOfKeys.Find(Row.Key) = Undefined Then
					ArrayOfKeys.Add(Row.Key);
				EndIf;
			EndDo;
			
			For Each ItemOfKeys In ArrayOfKeys Do
				For Each Row In Source.TaxList.FindRows(New Structure("Key", ItemOfKeys)) Do
					Source.TaxList.Delete(Row);
				EndDo;
			EndDo;
			
			For Each Row In PropertyValue Do
				FillPropertyValues(Source.TaxList.Add(), Row);
			EndDo;
		
		
		ElsIf TypeOf(PropertyValue) = Type("Array") Then // это табличная часть
			IsRowWithKey = PropertyValue.Count() And PropertyValue[0].Property("Key");
			// Табличные части ItemList и PaymentList переносятся построчно так как Key в строках уникален
			If IsRowWithKey Then
				For Each Row In PropertyValue Do
					FillPropertyValues(Source[PropertyName].FindRows(New Structure("Key", Row.Key))[0], Row);
				EndDo;
			Else
				// если в строке нет ключа то переносится целиком, например PaymentTerms
				Source[PropertyName].Clear();
				For Each Row In PropertyValue Do
					FillPropertyValues(Source[PropertyName].Add(), Row);
				EndDo;
			EndIf;
		Else
			Source[PropertyName] = PropertyValue; // это реквизит шапки
		EndIf;
	EndDo;
EndProcedure

Procedure ProceedPropertyBeforeChange_Object(Parameters)
	If Parameters.PropertyBeforeChange.Object.Value <> Undefined Then
		DataPath          = Parameters.PropertyBeforeChange.Object.Value.DataPath;
		ValueBeforeChange = Parameters.PropertyBeforeChange.Object.Value.ValueBeforeChange;
		CurrentValue      = GetPropertyObject(Parameters, DataPath);
		Parameters.Object[DataPath] = ValueBeforeChange;
		SetPropertyObject(Parameters, DataPath, , CurrentValue);
	EndIf;
EndProcedure

Procedure ProceedPropertyBeforeChange_Form(Parameters)
	If Parameters.PropertyBeforeChange.Form.Value <> Undefined Then
		DataPath          = Parameters.PropertyBeforeChange.Form.Value.DataPath;
		ValueBeforeChange = Parameters.PropertyBeforeChange.Form.Value.ValueBeforeChange;
		CurrentValue      = GetPropertyForm(Parameters, DataPath);
		Parameters.Form[DataPath] = ValueBeforeChange;
		SetPropertyForm(Parameters, DataPath, , CurrentValue);
	EndIf;
EndProcedure

Procedure ProceedPropertyBeforeChange_List(Parameters)
	If Parameters.PropertyBeforeChange.List.Value = Undefined Then
		Return;
	EndIf;
	DataPath   = Parameters.PropertyBeforeChange.List.Value.DataPath;
	TableName  = Parameters.PropertyBeforeChange.List.Value.TableName;
	ColumnName = Parameters.PropertyBeforeChange.List.Value.ColumnName;
	ArrayOfValuesBeforeChange = Parameters.PropertyBeforeChange.List.Value.ArrayOfValuesBeforeChange;
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
		Return Parameters.Rows;
	EndIf;
	Return Parameters.Object[TableName];
EndFunction

Procedure SetterForm(StepsEnablerName, DataPath, Parameters, Results, 
	ViewNotify = Undefined, ValueDataPath = Undefined, NotifyAnyWay = False, ReadOnlyFromCache = False)
	Setter("Form", StepsEnablerName, DataPath, Parameters, Results, ViewNotify, ValueDataPath, NotifyAnyWay, ReadOnlyFromCache);
EndProcedure

Procedure MultiSetterObject(Parameters, Results, ResourceToBinding)
	For Each KeyValue In ResourceToBinding Do
		Resource = KeyValue.Key;
		Binding = KeyValue.Value;
		Segments = StrSplit(Binding.DataPath, ".");
		If Segments.Count() = 1 Then // это реквизит шапки
			_Results = New Array();
			For Each Result In Results Do
				_Results.Add(New Structure("Value, Options", Result.Value[Resource], New Structure("Key")));
				Break;
			EndDo;
			SetterObject(Binding.StepsEnabler, Binding.DataPath , Parameters, _Results);
		ElsIf Segments.Count() = 2 Then // это колонка таблицы
			SetterObject(Binding.StepsEnabler, Binding.DataPath , Parameters, Results, , Resource);
		Else
			Raise StrTemplate("Wrong data path [%1]", Binding.DataPath);
		EndIf;
	EndDo;
EndProcedure

Procedure SetterObject(StepsEnablerName, DataPath, Parameters, Results, 
	ViewNotify = Undefined, ValueDataPath = Undefined, NotifyAnyWay = False, ReadOnlyFromCache = False)
	Setter("Object", StepsEnablerName, DataPath, Parameters, Results, ViewNotify, ValueDataPath, NotifyAnyWay, ReadOnlyFromCache);
EndProcedure

Procedure Setter(Source, StepsEnablerName, DataPath, Parameters, Results, ViewNotify, ValueDataPath, NotifyAnyWay, ReadOnlyFromCache)
	IsChanged = False;
	For Each Result In Results Do
		_Key   = Result.Options.Key;
		If ValueIsFilled(ValueDataPath) Then
			_Value = ?(Result.Value = Undefined, Undefined, Result.Value[ValueDataPath]);
		Else
			_Value = Result.Value;
		EndIf;
		If Source = "Object" And SetPropertyObject(Parameters, DataPath, _Key, _Value, ReadOnlyFromCache) Then
			IsChanged = True;
		EndIf;
		If Source = "Form" And SetPropertyForm(Parameters, DataPath, _Key, _Value, ReadOnlyFromCache) Then
			IsChanged = True;
		EndIf;
	EndDo;
	If IsChanged Or NotifyAnyWay Then
		AddViewNotify(ViewNotify, Parameters);
	EndIf;
	If ValueIsFilled(StepsEnablerName) Then
		// свойство изменено и есть следующие шаги
		// или свойство не изменено но если оно ReadOnly, то вызовем его следующие шаги
		If IsChanged Then
			ModelClientServer_V2.EntryPoint(StepsEnablerName, Parameters);
		ElsIf Parameters.ReadOnlyPropertiesMap.Get(DataPath) = True Then
			If Parameters.ProcessedReadOnlyPropertiesMap.Get(DataPath) = Undefined Then
				Parameters.ProcessedReadOnlyPropertiesMap.Insert(DataPath, True);
				ModelClientServer_V2.EntryPoint(StepsEnablerName, Parameters);
			EndIf;
		EndIf;
	EndIf;
EndProcedure

Procedure AddViewNotify(ViewNotify, Parameters)
	// переадресация в клиентский модуль, вызов был с клиента, на форме что то надо обновить
	// вызывать будем потом когда завершится вся цепочка действий, и изменения будут перенесены с кэша в объект
	If ValueIsFilled(ViewNotify) Then
		Parameters.ViewNotify.Add(ViewNotify);
	EndIf;
EndProcedure

Function GetPropertyForm(Parameters, DataPath, Key = Undefined, ReadOnlyFromCache = False)
If Parameters.Form <> Undefined Then
	Return GetProperty(Parameters.CacheForm, Parameters.Form, DataPath, Key, ReadOnlyFromCache);
Else
	Return Undefined;
EndIf;
EndFunction

Function GetPropertyObject(Parameters, DataPath, Key = Undefined, ReadOnlyFromCache = False)
	Return GetProperty(Parameters.Cache, Parameters.Object, DataPath, Key, ReadOnlyFromCache);
EndFunction

// параметр Key используется когда DataPath указывает на реквизит табличной части, например ItemList.PriceType
Function GetProperty(Cache, Source, DataPath, Key, ReadOnlyFromCache)
	Segments = StrSplit(DataPath, ".");
	If Segments.Count() = 1 Then // это реквизит шапки, он указывается без точки, например Company
		If ValueIsFilled(Key) Then
			Raise StrTemplate("Key [%1] not allowed for data path [%2]", Key, DataPath);
		EndIf;
		If Cache.Property(DataPath) Then
			Return Cache[DataPath];
		Else
			If ReadOnlyFromCache Then
				Return Undefined;
			EndIf;
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
		// не нашли в кэше
		If RowByKey = Undefined Then
			If ReadOnlyFromCache Then
				Return Undefined;
			EndIf;
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

Function SetPropertyObject(Parameters, DataPath, _Key, _Value, ReadOnlyFromCache = False)
	// если свойство ReadOnly и оно заполнено то не меняем
	If Parameters.ReadOnlyPropertiesMap.Get(DataPath) <> Undefined Then
		Segments = StrSplit(DataPath, ".");
		If Segments.Count() = 1 Then
			If ValueIsFilled(Parameters.Object[DataPath]) Then
				Return False; // Свойство ReadOnly и заполнено, не меняем
			EndIf;
		ElsIf Segments.Count() = 2 Then
			// для табличной части нужно сначало найти строку
			TableName = TrimAll(Segments[0]);
			PropertyName = TrimAll(Segments[1]);
			If Upper(TableName) = Upper(Parameters.TableName) Then
				For Each Row In GetRows(Parameters, TableName) Do
					If Row.Key = _Key Then
						If ValueIsFilled(Row[PropertyName]) Then
							Return False; // Свойство ReadOnly и заполнено, не меняем
						EndIf;
						Break;
					EndIf;
				EndDo;
			EndIf;
		Else
			Raise StrTemplate("Wrong data path for read only property [%1]", DataPath);
		EndIf;
	EndIf;
	
	CurrentValue = GetPropertyObject(Parameters, DataPath, _Key, ReadOnlyFromCache);
	If ?(ValueIsFilled(CurrentValue), CurrentValue, Undefined) = ?(ValueIsFilled(_Value), _Value, Undefined) Then
		Return False; // Свойство не изменилось
	EndIf;
	// Свойство изменилось
	IsChanged = SetProperty(Parameters.Cache, DataPath, _Key, _Value);
	If IsChanged Then
		PutToChangedData(Parameters, DataPath, CurrentValue, _Value, _Key);
	EndIf;
	Return IsChanged;
EndFunction

Function SetPropertyForm(Parameters, DataPath, _Key, _Value, ReadOnlyFromCache = False)
	CurrentValue = GetPropertyForm(Parameters, DataPath, _Key, ReadOnlyFromCache);
	If ?(ValueIsFilled(CurrentValue), CurrentValue, Undefined) = ?(ValueIsFilled(_Value), _Value, Undefined) Then
		Return False; // Свойство не изменилось
	EndIf;
	// Свойство изменилось
	IsChanged = SetProperty(Parameters.CacheForm, DataPath, _Key, _Value);
	If IsChanged Then
		PutToChangedData(Parameters, DataPath, CurrentValue, _Value, _Key);
	EndIf;
	Return IsChanged;
EndFunction

// логирует измененные данные, для того чтобы можно было задавать вопросы пользователю
Procedure PutToChangedData(Parameters, DataPath, OldValue, NewValue, _Key)
	If Parameters.ChangedData.Get(DataPath) = Undefined Then
		Parameters.ChangedData.Insert(DataPath, New Array());
	EndIf;
	ChangedData = New Structure();
	ChangedData.Insert("OldValue", OldValue);
	ChangedData.Insert("NewValue", NewValue);
	ChangedData.Insert("Key"     , _Key);
	Parameters.ChangedData.Get(DataPath).Add(ChangedData);
EndProcedure

// Устанавливает свойства по переданному DataPath, например ItemList.PriceType или Company
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
	Result = New Structure();
	Result.Insert("FullDataPath" , "");
	Result.Insert("StepsEnabler" , "");
	Result.Insert("DataPath"     , "");
	
	If TypeOf(DataPath) = Type("Map") Then
		DataPath = DataPath.Get(Parameters.ObjectMetadataInfo.MetadataName);
		If DataPath = Undefined Then
			Return Result;
			//Raise StrTemplate("DataPath instance of Map not found value by key [%1]", 
			//	Parameters.ObjectMetadataInfo.MetadataName);
		EndIf;
	EndIf;
	
	MetadataBinding = New Map();
	For Each KeyValue In Binding Do
		MetadataName = KeyValue.Key;
		MetadataBinding.Insert(StrTemplate("%1.%2", MetadataName, DataPath), Binding[MetadataName]);
	EndDo;
	FullDataPath = StrTemplate("%1.%2", Parameters.ObjectMetadataInfo.MetadataName, DataPath);
	StepsEnabler = MetadataBinding.Get(FullDataPath);
	StepsEnabler = ?(StepsEnabler = Undefined, DefaulStepsEnabler, StepsEnabler);
	If Not ValueIsFilled(StepsEnabler) Then
		Raise StrTemplate("Steps enabler is not defined [%1]", DataPath);
	Endif;
	
	Result.FullDataPath = FullDataPath;
	Result.StepsEnabler = StepsEnabler;
	Result.DataPath     = DataPath;
	Return Result;
EndFunction

Function IsUserChange(Parameters)
	If Parameters.Property("IsProgrammChange") And Parameters.IsProgrammChange Then
		Return False; // Is programm change via scan barcode or other external forms
	EndIf;
	
	If Parameters.Property("ModelInveronment")
		And Parameters.ModelInveronment.Property("StepsEnablerNameCounter") Then
		Return Parameters.ModelInveronment.StepsEnablerNameCounter.Count() = 1;
	EndIf;
	Return False;
EndFunction

#IF Server THEN

Function AddLinkedDocumentRows(Object, Form, LinkedResult, TableName) Export
	FormParameters = GetFormParameters(Form);
	ServerParameters = GetServerParameters(Object);
	ServerParameters.TableName = TableName;
	ServerParameters.ReadOnlyProperties = LinkedResult.UpdatedProperties;
	ServerParameters.Rows = LinkedResult.NewRows;
		
	Parameters = GetParameters(ServerParameters, FormParameters);
	For Each PropertyName In StrSplit(ServerParameters.ReadOnlyProperties, ",") Do
		If StrStartsWith(PropertyName, TableName) Then
			Property = New Structure("DataPath", TrimAll(PropertyName));
			API_SetProperty(Parameters, Property, Undefined);
		EndIf;
	EndDo;
	Return Parameters.ExtractedData;
EndFunction

Procedure SetReadOnlyProperties_RowID(Object, PropertiesHeader, PropertiesTables) Export
	ArrayOfPropertiesHeader = New Array();
	For Each PropertyName In StrSplit(PropertiesHeader, ",") Do
		PropertyName = TrimAll(PropertyName);
		If CommonFunctionsClientServer.ObjectHasProperty(Object, PropertyName)
			And ValueIsFilled(Object[PropertyName])
			And ArrayOfPropertiesHeader.Find(PropertyName) = Undefined Then
				ArrayOfPropertiesHeader.Add(PropertyName);
		EndIf;
	EndDo;
	Object.AdditionalProperties.Insert("ReadOnlyProperties", 
			StrConcat(ArrayOfPropertiesHeader, ",") + ", " + PropertiesTables);
EndProcedure

Procedure SetReadOnlyProperties(Object, FillingData) Export
	HeaderProperties = New Array();
	TabularProperties = New Array();
	For Each KeyValue In FillingData Do
		Property = KeyValue.Key;
		Value    = KeyValue.Value;
		If Not CommonFunctionsClientServer.ObjectHasProperty(Object, Property) Then
			Continue;
		EndIf;
					
		If TypeOf(Value) = Type("Array") Then // is tabular section
			If Value.Count() Then
				For Each Column In Value[0] Do
					If Object.Metadata().TabularSections[Property]
						.Attributes.Find(Column.Key) <> Undefined Then
							TabularProperties.Add(StrTemplate("%1.%2",Property, Column.Key));
					EndIf;
				EndDo;
			EndIf;
		Else // is header property
			HeaderProperties.Add(Property);
		EndIf;
	EndDo;
	ReadOnlyProperties = StrConcat(HeaderProperties, ",") +","+StrConcat(TabularProperties, ",");
	Object.AdditionalProperties.Insert("ReadOnlyProperties", ReadOnlyProperties);
EndProcedure

#ENDIF
