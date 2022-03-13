
#Region PARAMETERS

Function GetServerParameters(Object) Export
	Result = New Structure();
	Result.Insert("Object", Object);
	Result.Insert("ControllerModuleName", "ControllerClientServer_V2");
	Result.Insert("TableName", "");
	Result.Insert("Rows", Undefined);
	Result.Insert("ReadOnlyProperties", "");
	Result.Insert("IsBasedOn", False);
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
	// parameters for Client 
	Parameters.Insert("Form"             , FormParameters.Form);
	Parameters.Insert("FormIsExists"     , FormParameters.Form <> Undefined);
	Parameters.Insert("FormTaxColumnsExists", FormParameters.Form <> Undefined 
		And ValueIsFilled(FormParameters.TaxesCache));
	Parameters.Insert("FormModificators" , New Array());
	Parameters.Insert("CacheForm"        , New Structure()); // cache for form attributes
	Parameters.Insert("ViewNotify"       , New Array());
	Parameters.Insert("ViewClientModuleName"   , FormParameters.ViewClientModuleName);
	Parameters.Insert("ViewServerModuleName"   , FormParameters.ViewServerModuleName);
	Parameters.Insert("EventCaller"      , FormParameters.EventCaller);
	Parameters.Insert("TaxesCache"       , FormParameters.TaxesCache);
	Parameters.Insert("ChangedData"      , New Map());
	Parameters.Insert("ExtractedData"    , New Structure());
	
	Parameters.Insert("PropertyBeforeChange", FormParameters.PropertyBeforeChange);
	
	Parameters.Insert("FormParameters", New Structure("IsCopy", False));
	If Parameters.FormIsExists Then
		If FormParameters.Form.Parameters.Property("CopyingValue") Then
			Parameters.FormParameters.IsCopy = ValueIsFilled(FormParameters.Form.Parameters.CopyingValue);
		EndIf;
	EndIf;
	
	// parameters for Server + Client
	Parameters.Insert("Object" , ServerParameters.Object);
	Parameters.Insert("Cache"  , New Structure());
	Parameters.Insert("ControllerModuleName", ServerParameters.ControllerModuleName);
	
	Parameters.Insert("IsBasedOn"             , ServerParameters.IsBasedOn);
	Parameters.Insert("ReadOnlyProperties"    , ServerParameters.ReadOnlyProperties);
	Parameters.Insert("ReadOnlyPropertiesMap" , New Map());
	Parameters.Insert("ProcessedReadOnlyPropertiesMap" , New Map());
	ArrayOfProperties = StrSplit(ServerParameters.ReadOnlyProperties, ",");
	For Each Property In ArrayOfProperties Do
		Parameters.ReadOnlyPropertiesMap.Insert(Upper(TrimAll(Property)), True);
	EndDo;
	
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
	
	// if specific rows are not passed, then we use everything that is in the table with the name TableName
	If ServerParameters.Rows = Undefined Then 
		If ValueIsFilled(ServerParameters.TableName) Then
			ServerParameters.Rows = ServerParameters.Object[ServerParameters.TableName];
		Else
			ServerParameters.Rows = New Array();
		EndIf;
	EndIf;
	
	// the table row cannot be transferred to the server, so we put the data in an array of structures
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
			// when there is no form, then there is no column created programmatically
			If Parameters.FormTaxColumnsExists Then
				TaxRates.Insert(ItemOfTaxInfo.Name, Row[ItemOfTaxInfo.Name]);
			Else
			// create pseudo columns for tax rates
				NewRow.Insert(ItemOfTaxInfo.Name);
				
				// tax rates are taken from the TaxList table
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
		NewRow.Insert("TaxIsAlreadyCalculated", Parameters.IsBasedOn And ArrayOfRowsTaxList.Count());
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
	Defaults = GetAllBindingsByDefault(Parameters);
	
	For Each DataPath In ArrayOfDataPath Do
		DataPath = TrimAll(DataPath);
		Default = Defaults.Get(DataPath);
		If Default<> Undefined Then
			ForceCommitChanges = False;
			ModelClientServer_V2.EntryPoint(Default.StepsEnabler, Parameters);
		ElsIf ValueIsFilled(Form[DataPath]) Then
			SetPropertyForm(Parameters, DataPath, , Form[DataPath]);
			Binding = Bindings.Get(DataPath);
			If Binding <> Undefined Then
				ForceCommitChanges = False;
				ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
			EndIf;
		EndIf;
	EndDo;
	If ForceCommitChanges Then
		CommitChainChanges(Parameters);
	EndIf;
EndProcedure

#ENDIF

#Region API

// attributes that available through API
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

Function GetAllBindings(Parameters)
	BindingMap = New Map();
	BindingMap.Insert("Company"   , BindCompany(Parameters));
	BindingMap.Insert("Account"   , BindAccount(Parameters));
	BindingMap.Insert("Partner"   , BindPartner(Parameters));
	BindingMap.Insert("LegalName" , BindLegalName(Parameters));
	BindingMap.Insert("Currency"  , BindCurrency(Parameters));
	
	BindingMap.Insert("ItemList.Item"     , BindItemListItem(Parameters));
	BindingMap.Insert("ItemList.ItemKey"  , BindItemListItemKey(Parameters));
	BindingMap.Insert("ItemList.Unit"     , BindItemListUnit(Parameters));
	BindingMap.Insert("ItemList.Quantity" , BindItemListQuantity(Parameters));
	Return BindingMap;
EndFunction

Function GetAllBindingsByDefault(Parameters)
	Binding = New Map();
	Binding.Insert("Store"        , BindDefaultStore(Parameters));
	Binding.Insert("DeliveryDate" , BindDefaultDeliveryDate(Parameters));
	
	Binding.Insert("ItemList.Store"        , BindDefaultItemListStore(Parameters));
	Binding.Insert("ItemList.DeliveryDate" , BindDefaultItemListDeliveryDate(Parameters));
	Binding.Insert("ItemList.Quantity"     , BindDefaultItemListQuantity(Parameters));
	Binding.Insert("PaymentList.Currency"  , BindDefaultPaymentListCurrency(Parameters));
	Binding.Insert("PaymentList."          , BindDefaultPaymentListTaxRate(Parameters));
	
	Return Binding;
EndFunction

#EndRegion

#Region _FORM_

// Form.OnCreateAtServer
Procedure FormOnCreateAtServer(Parameters) Export
	Binding = BindFormOnCreateAtServer(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Form.OnCreateAtServer.Bind
Function BindFormOnCreateAtServer(Parameters)
	DataPath = "";
	Binding = New Structure();
	Binding.Insert("SalesInvoice",
		"StepItemListCalculations_RecalculationsOnCopy,
		|StepRequireCallCreateTaxesFormControls");
	
	Binding.Insert("PurchaseInvoice",
		"StepItemListCalculations_RecalculationsOnCopy,
		|StepRequireCallCreateTaxesFormControls");
									
	Binding.Insert("BankPayment",
		"StepPaymentListCalculations_RecalculationsOnCopy,
		|StepRequireCallCreateTaxesFormControls");

	Binding.Insert("BankReceipt",
		"StepPaymentListCalculations_RecalculationsOnCopy,
		|StepRequireCallCreateTaxesFormControls");
	
	Binding.Insert("CashPayment",
		"StepPaymentListCalculations_RecalculationsOnCopy,
		|StepRequireCallCreateTaxesFormControls");

	Binding.Insert("CashReceipt",
		"StepPaymentListCalculations_RecalculationsOnCopy,
		|StepRequireCallCreateTaxesFormControls");
	
	Binding.Insert("MoneyTransfer",
		"StepGenerateNewSendUUID,
		|StepGenerateNewReceiptUUID");

	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// Form.Modificator
Procedure FormModificator_CreateTaxesFormControls(Parameters, Results) Export
	If Results[0].Value Then
		Parameters.FormModificators.Add("FormModificator_CreateTaxesFormControls");
	EndIf;
EndProcedure

// Form.RequireCallCreateTaxesFormControls.Step
Procedure StepRequireCallCreateTaxesFormControls(Parameters, Chain) Export
	Chain.RequireCallCreateTaxesFormControls.Enable = True;
	Chain.RequireCallCreateTaxesFormControls.Setter = "FormModificator_CreateTaxesFormControls";
	Options = ModelClientServer_V2.RequireCallCreateTaxesFormControlsOptions();
	Options.Ref            = Parameters.Object.Ref;
	Options.Date           = GetDate(Parameters);
	Options.Company        = GetCompany(Parameters);
	Options.ArrayOfTaxInfo = Parameters.ArrayOfTaxInfo;
	Options.FormTaxColumnsExists = Parameters.FormTaxColumnsExists;
	Options.StepName = "StepRequireCallCreateTaxesFormControls";
	Chain.RequireCallCreateTaxesFormControls.Options.Add(Options);
EndProcedure

// Form.OnOpen
Procedure FormOnOpen(Parameters) Export
	AddViewNotify("OnOpenFormNotify", Parameters);
	Binding = BindFormOnOpen(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Form.OnOpen.Bind
Function BindFormOnOpen(Parameters)
	DataPath = "";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation"      , "StepExtractDataItemKeysWithSerialLotNumbers");
	Binding.Insert("GoodsReceipt"              , "StepExtractDataItemKeysWithSerialLotNumbers");
	Binding.Insert("StockAdjustmentAsSurplus"  , "StepExtractDataItemKeysWithSerialLotNumbers");
	Binding.Insert("StockAdjustmentAsWriteOff" , "StepExtractDataItemKeysWithSerialLotNumbers");
	Binding.Insert("SalesInvoice"              , "StepExtractDataItemKeysWithSerialLotNumbers");
	Binding.Insert("PurchaseInvoice"           , "StepExtractDataItemKeysWithSerialLotNumbers");
	Binding.Insert("CashExpense"               , "StepExtractDataCurrencyFromAccount");
	Binding.Insert("CashRevenue"               , "StepExtractDataCurrencyFromAccount");
	Return BindSteps("BindVoid"       , DataPath, Binding, Parameters);
EndFunction

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
	Defaults = GetAllBindingsByDefault(Parameters);
	
	ForceCommitChanges = True;
	For Each ColumnName In StrSplit(Parameters.ObjectMetadataInfo.Tables[TableName].Columns, ",") Do
		
		// column has its own handler .Default call it
		DataPath = StrTemplate("%1.%2", TableName, ColumnName);
		Segments = StrSplit(DataPath, ".");
		If Segments.Count() = 2 And StrStartsWith(Segments[1], "_" ) Then
			DataPath = Segments[0] + ".";
		EndIf;
		Default = Defaults.Get(DataPath);
		If Default<> Undefined Then
			ForceCommitChanges = False;
			ModelClientServer_V2.EntryPoint(Default.StepsEnabler, Parameters);

		// if column is filled  and has its own handler .OnChage call it
		ElsIf ValueIsFilled(NewRow[ColumnName]) Then
			SetPropertyObject(Parameters, DataPath, NewRow.Key, NewRow[ColumnName]);
			Binding = Bindings.Get(DataPath);
			If Binding <> Undefined Then
				ForceCommitChanges = False;
				ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
			EndIf;
		EndIf;
	EndDo;
	If ForceCommitChanges Then
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
	// execute handlers after deleting row
	Binding = BindListOnDelete(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// <TableName>.OnDelete.Bind
Function BindListOnDelete(Parameters)
	DataPath = "";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation", "StepChangeStoreInHeaderByStoresInList");
	Binding.Insert("GoodsReceipt"        , "StepChangeStoreInHeaderByStoresInList");
	
	Binding.Insert("SalesInvoice",
		"StepChangeStoreInHeaderByStoresInList,
		|StepUpdatePaymentTerms");
	
	Binding.Insert("PurchaseInvoice",
		"StepChangeStoreInHeaderByStoresInList,
		|StepUpdatePaymentTerms");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region _LIST_COPY

Procedure CopyRow(TableName, Parameters, ViewNotify = Undefined) Export
	If ViewNotify <> Undefined Then
		AddViewNotify(ViewNotify, Parameters);
	EndIf;
	// execute handlers after copy row
	Binding = BindListOnCopy(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// <TableName>.OnCopy.Bind
Function BindListOnCopy(Parameters)
	DataPath = "";
	Binding = New Structure();
	Binding.Insert("SalesInvoice" ,
		"StepItemListCalculations_IsCopyRow,
		|StepUpdatePaymentTerms");
	
	Binding.Insert("PurchaseInvoice" ,
		"StepItemListCalculations_IsCopyRow,
		|StepUpdatePaymentTerms");
	
	Binding.Insert("BankPayment"  , "StepPaymentListCalculations_IsCopyRow");
	Binding.Insert("BankReceipt"  , "StepPaymentListCalculations_IsCopyRow");
	Binding.Insert("CashPayment"  , "StepPaymentListCalculations_IsCopyRow");
	Binding.Insert("CashReceipt"  , "StepPaymentListCalculations_IsCopyRow");
	Binding.Insert("CashExpense"  , "StepPaymentListCalculations_IsCopyRow");
	Binding.Insert("CashRevenue"  , "StepPaymentListCalculations_IsCopyRow");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#EndRegion

#Region _EXTRACT_DATA_

// ExtractDataItemKeyIsService.Set
Procedure SetExtractDataItemKeyIsService(Parameters, Results) Export
	Parameters.ExtractedData.Insert("DataItemKeyIsService", New Array());
	For Each Result In Results Do
		NewRow = New Structure();
		NewRow.Insert("Key"       , Result.Options.Key);
		NewRow.Insert("IsService" , Result.Value);
		Parameters.ExtractedData.DataItemKeyIsService.Add(NewRow);
	EndDo;
EndProcedure

// ExtractDataItemKeyIsService.Step
Procedure StepExtractDataItemKeyIsService(Parameters, Chain) Export
	Chain.ExtractDataItemKeyIsService.Enable = True;
	Chain.ExtractDataItemKeyIsService.Setter = "SetExtractDataItemKeyIsService";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ExtractDataItemKeyIsServiceOptions();
		Options.ItemKey      = GetItemListItemKey(Parameters, Row.Key);
		Options.IsUserChange = IsUserChange(Parameters);
		Options.Key = Row.Key;
		Chain.ExtractDataItemKeyIsService.Options.Add(Options);
	EndDo;
EndProcedure

// ExtractDataItemKeysWithSerialLotNumbers.Set
Procedure SetExtractDataItemKeysWithSerialLotNumbers(Parameters, Results) Export
	Parameters.ExtractedData.Insert("ItemKeysWithSerialLotNumbers", New Array());
	For Each Result In Results Do
		If Result.Value Then // have serial lot numbers
			Parameters.ExtractedData.ItemKeysWithSerialLotNumbers.Add(Result.Options.ItemKey);
		EndIf;
	EndDo;
EndProcedure

// ExtractDataItemKeysWithSerialLotNumbers.Step
Procedure StepExtractDataItemKeysWithSerialLotNumbers(Parameters, Chain) Export
	Chain.ExtractDataItemKeysWithSerialLotNumbers.Enable = True;
	Chain.ExtractDataItemKeysWithSerialLotNumbers.Setter = "SetExtractDataItemKeysWithSerialLotNumbers";
	For Each Row In Parameters.Object.ItemList Do
		Options = ModelClientServer_V2.ExtractDataItemKeysWithSerialLotNumbersOptions();
		Options.ItemKey = GetItemListItemKey(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepExtractDataItemKeysWithSerialLotNumbers";
		Options.DontExecuteIfExecutedBefore = True;
		Chain.ExtractDataItemKeysWithSerialLotNumbers.Options.Add(Options);
	EndDo;
EndProcedure

// ExtractDataAgreementApArPostingDetail.Set
Procedure SetExtractDataAgreementApArPostingDetail(Parameters, Results) Export
	Parameters.ExtractedData.Insert("DataAgreementApArPostingDetail", New Array());
	For Each Result In Results Do
		NewRow = New Structure();
		NewRow.Insert("Key"               , Result.Options.Key);
		NewRow.Insert("ApArPostingDetail" , Result.Value);
		Parameters.ExtractedData.DataAgreementApArPostingDetail.Add(NewRow);
	EndDo;
EndProcedure

// ExtractDataAgreementApArPostingDetail.Step
Procedure StepExtractDataAgreementApArPostingDetail(Parameters, Chain) Export
	Chain.ExtractDataAgreementApArPostingDetail.Enable = True;
	Chain.ExtractDataAgreementApArPostingDetail.Setter = "SetExtractDataAgreementApArPostingDetail";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ExtractDataAgreementApArPostingDetailOptions();
		Options.Agreement = GetPaymentListAgreement(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepExtractDataAgreementApArPostingDetail";
		Chain.ExtractDataAgreementApArPostingDetail.Options.Add(Options);
	EndDo;
EndProcedure

// ExtractDataCurrencyFromAccount.Set
Procedure SetExtractDataCurrencyFromAccount(Parameters, Results) Export
	Parameters.ExtractedData.Insert("DataCurrencyFromAccount", New Array());
	For Each Result In Results Do
		Parameters.ExtractedData.DataCurrencyFromAccount.Add(Result.Value);
	EndDo;
EndProcedure

// ExtractDataCurrencyFromAccount.Step
Procedure StepExtractDataCurrencyFromAccount(Parameters, Chain) Export
	Chain.ExtractDataCurrencyFromAccount.Enable = True;
	Chain.ExtractDataCurrencyFromAccount.Setter = "SetExtractDataCurrencyFromAccount";
	Options = ModelClientServer_V2.ExtractDataCurrencyFromAccountOptions();
	Options.Account = GetAccount(Parameters);
	Options.StepName = "StepExtractDataCurrencyFromAccount";
	Chain.ExtractDataCurrencyFromAccount.Options.Add(Options);
EndProcedure

#EndRegion

#Region RECALCULATION_AFTER_QUESTIONS_TO_USER

// RecalculationsAfterQuestionToUser.Call
Procedure RecalculationsAfterQuestionToUser(Parameters) Export
	Binding = BindRecalculationsAfterQuestionToUser(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// RecalculationsAfterQuestionToUser.Bind
Function BindRecalculationsAfterQuestionToUser(Parameters)
	DataPath = "";
	Binding = New Structure();
	Binding.Insert("SalesInvoice", 
		"StepItemListCalculations_RecalculationsAfterQuestionToUser,
		|StepUpdatePaymentTerms");

	Binding.Insert("PurchaseInvoice", 
		"StepItemListCalculations_RecalculationsAfterQuestionToUser,
		|StepUpdatePaymentTerms");
		
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region ACCOUNT

// Account.OnChange
Procedure AccountOnChange(Parameters) Export
	ProceedPropertyBeforeChange_Object(Parameters);
	AddViewNotify("OnSetAccountNotify", Parameters);
	Binding = BindAccount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Account.Set
Procedure SetAccount(Parameters, Results) Export
	Binding = BindAccount(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetAccountNotify");
EndProcedure

// Account.Get
Function GetAccount(Parameters)
	Return GetPropertyObject(Parameters, BindAccount(Parameters).DataPath);
EndFunction

// Account.Bind
Function BindAccount(Parameters)
	DataPath = New Map();
	DataPath.Insert("IncomingPaymentOrder", "Account");
	DataPath.Insert("OutgoingPaymentOrder", "Account");
	DataPath.Insert("BankPayment", "Account");
	DataPath.Insert("BankReceipt", "Account");
	DataPath.Insert("CashPayment", "CashAccount");
	DataPath.Insert("CashReceipt", "CashAccount");
	DataPath.Insert("CashExpense", "Account");
	DataPath.Insert("CashRevenue", "Account");
	
	Binding = New Structure();
	Binding.Insert("IncomingPaymentOrder", "StepChangeCurrencyByAccount");
	Binding.Insert("OutgoingPaymentOrder", "StepChangeCurrencyByAccount");
	
	Binding.Insert("BankPayment",
		"StepChangeCurrencyByAccount,
		|StepChangeTransitAccountByAccount");

	Binding.Insert("BankReceipt",
		"StepChangeCurrencyByAccount,
		|StepChangeTransitAccountByAccount");
	
	Binding.Insert("CashPayment", "StepChangeCurrencyByAccount");
	Binding.Insert("CashReceipt", "StepChangeCurrencyByAccount");

	Binding.Insert("CashExpense",
		"StepChangeCurrencyByAccount_CurrencyInList,
		|StepExtractDataCurrencyFromAccount");
		
	Binding.Insert("CashRevenue",
		"StepChangeCurrencyByAccount_CurrencyInList,
		|StepExtractDataCurrencyFromAccount");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// Account.ChangeCashAccountByCurrency.Step
Procedure StepChangeCashAccountByCurrency(Parameters, Chain) Export
	Chain.ChangeCashAccountByCurrency.Enable = True;
	Chain.ChangeCashAccountByCurrency.Setter = "SetAccount";
	Options = ModelClientServer_V2.ChangeCashAccountByCurrencyOptions();
	Options.CurrentAccount = GetAccount(Parameters);
	Options.Currency       = GetCurrency(Parameters);
	Options.StepName = "StepChangeCashAccountByCurrency";
	Chain.ChangeCashAccountByCurrency.Options.Add(Options);
EndProcedure

// Account.ChangeCashAccountByCompany.[AccountTypeIsBank].Step
Procedure StepChangeCashAccountByCompany_AccountTypeIsBank(Parameters, Chain) Export
	StepChangeCashAccountByCompany(Parameters, Chain, PredefinedValue("Enum.CashAccountTypes.Bank"));
EndProcedure

// Account.ChangeCashAccountByCompany.[AccountTypeIsCash].Step
Procedure StepChangeCashAccountByCompany_AccountTypeIsCash(Parameters, Chain) Export
	StepChangeCashAccountByCompany(Parameters, Chain, PredefinedValue("Enum.CashAccountTypes.Cash"));
EndProcedure

// Account.ChangeCashAccountByCompany.[AccountTypeIsEmpty].Step
Procedure StepChangeCashAccountByCompany_AccountTypeIsEmpty(Parameters, Chain) Export
	StepChangeCashAccountByCompany(Parameters, Chain, PredefinedValue("Enum.CashAccountTypes.EmptyRef"));
EndProcedure

// Account.ChangeCashAccountByCompany.Step
Procedure StepChangeCashAccountByCompany(Parameters, Chain, AccountType)
	Chain.ChangeCashAccountByCompany.Enable = True;
	Chain.ChangeCashAccountByCompany.Setter = "SetAccount";
	Options = ModelClientServer_V2.ChangeCashAccountByCompanyOptions();
	Options.Company = GetCompany(Parameters);
	Options.Account = GetAccount(Parameters);
	Options.AccountType = AccountType;
	Options.StepName = "StepChangeCashAccountByCompany";
	Chain.ChangeCashAccountByCompany.Options.Add(Options);
EndProcedure

#EndRegion

#Region ACCOUNT_SENDER

// AccountSender.OnChange
Procedure AccountSenderOnChange(Parameters) Export
	ProceedPropertyBeforeChange_Object(Parameters);
	AddViewNotify("OnSetAccountSenderNotify", Parameters);
	Binding = BindAccountSender(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// AccountSender.Set
Procedure SetAccountSender(Parameters, Results) Export
	Binding = BindAccountSender(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// AccountSender.Get
Function GetAccountSender(Parameters)
	Return GetPropertyObject(Parameters, BindAccountSender(Parameters).DataPath);
EndFunction

// AccountSender.Bind
Function BindAccountSender(Parameters)
	DataPath = "Sender";
	Binding = New Structure();
	Return BindSteps("StepChangeSendCurrencyByAccount", DataPath, Binding, Parameters);
EndFunction

// AccountSender.ChangeAccountSenderByCompany.Step
Procedure StepChangeAccountSenderByCompany(Parameters, Chain) Export
	Chain.ChangeAccountSenderByCompany.Enable = True;
	Chain.ChangeAccountSenderByCompany.Setter = "SetAccountSender";
	Options = ModelClientServer_V2.ChangeCashAccountByCompanyOptions();
	Options.Company = GetCompany(Parameters);
	Options.Account = GetAccountSender(Parameters);
	Options.AccountType = PredefinedValue("Enum.CashAccountTypes.EmptyRef");
	Options.StepName = "StepChangeAccountSenderByCompany";
	Chain.ChangeAccountSenderByCompany.Options.Add(Options);
EndProcedure

#EndRegion

#Region ACCOUNT_RECEIVER

// AccountReceiver.OnChange
Procedure AccountReceiverOnChange(Parameters) Export
	ProceedPropertyBeforeChange_Object(Parameters);
	AddViewNotify("OnSetAccountReceiverNotify", Parameters);
	Binding = BindAccountReceiver(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// AccountReceiver.Set
Procedure SetAccountReceiver(Parameters, Results) Export
	Binding = BindAccountReceiver(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// AccountReceiver.Get
Function GetAccountReceiver(Parameters)
	Return GetPropertyObject(Parameters, BindAccountReceiver(Parameters).DataPath);
EndFunction

// AccountReceiver.Bind
Function BindAccountReceiver(Parameters)
	DataPath = "Receiver";
	Binding = New Structure();
	Return BindSteps("StepChangeReceiveCurrencyByAccount", DataPath, Binding, Parameters);
EndFunction

// AccountReceiver.ChangeAccountReceiverByCompany.Step
Procedure StepChangeAccountReceiverByCompany(Parameters, Chain) Export
	Chain.ChangeAccountReceiverByCompany.Enable = True;
	Chain.ChangeAccountReceiverByCompany.Setter = "SetAccountReceiver";
	Options = ModelClientServer_V2.ChangeCashAccountByCompanyOptions();
	Options.Company = GetCompany(Parameters);
	Options.Account = GetAccountReceiver(Parameters);
	Options.AccountType = PredefinedValue("Enum.CashAccountTypes.EmptyRef");
	Options.StepName = "StepChangeAccountReceiverByCompany";
	Chain.ChangeAccountReceiverByCompany.Options.Add(Options);
EndProcedure

#EndRegion

#Region ACCOUNT_TRANSIT

// TransitAccount.OnChange
Procedure TransitAccountOnChange(Parameters) Export
	Binding = BindTransitAccount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// TransitAccount.Set
Procedure SetTransitAccount(Parameters, Results) Export
	Binding = BindTransitAccount(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// TransitAccount.Get
Function GetTransitAccount(Parameters)
	Return GetPropertyObject(Parameters, BindTransitAccount(Parameters).DataPath);
EndFunction

// TransitAccount.Bind
Function BindTransitAccount(Parameters)
	DataPath = "TransitAccount";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// TransitAccount.ChangeTransitAccountByAccount.Set
Procedure StepChangeTransitAccountByAccount(Parameters, Chain) Export
	Chain.ChangeTransitAccountByAccount.Enable = True;
	Chain.ChangeTransitAccountByAccount.Setter = "SetTransitAccount";
	Options = ModelClientServer_V2.ChangeTransitAccountByAccountOptions();
	Options.TransactionType       = GetTransactionType(Parameters);
	Options.Account               = GetAccount(Parameters);
	Options.CurrentTransitAccount = GetTransitAccount(Parameters);
	Options.StepName = "StepChangeTransitAccountByAccount";
	Chain.ChangeTransitAccountByAccount.Options.Add(Options);
EndProcedure

#EndRegion

#Region SEND_UUID

// SendUUID.Set
Procedure SetSendUUID(Parameters, Results) Export
	Binding = BindSendUUID(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// SendUUID.Get
Function GetSendUUID(Parameters)
	Return GetPropertyObject(Parameters, BindSendUUID(Parameters).DataPath);
EndFunction

// SendUUID.Bind
Function BindSendUUID(Parameters)
	DataPath = "SendUUID";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// SendUUID.GenerateNewSendUUID.Step
Procedure StepGenerateNewSendUUID(Parameters, Chain) Export
	Chain.GenerateNewSendUUID.Enable = True;
	Chain.GenerateNewSendUUID.Setter = "SetSendUUID";
	Options = ModelClientServer_V2.GenerateNewUUIDOptions();
	Options.Ref = Parameters.Object.Ref;
	Options.CurrentUUID = GetSendUUID(Parameters);
	Options.StepName = "StepGenerateNewSendUUID";
	Chain.GenerateNewSendUUID.Options.Add(Options);
EndProcedure

#EndRegion

#Region RECEIVE_UUID

// ReceiveUUID.Set
Procedure SetReceiveUUID(Parameters, Results) Export
	Binding = BindReceiveUUID(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ReceiveUUID.Get
Function GetReceiveUUID(Parameters)
	Return GetPropertyObject(Parameters, BindReceiveUUID(Parameters).DataPath);
EndFunction

// ReceiveUUID.Bind
Function BindReceiveUUID(Parameters)
	DataPath = "ReceiveUUID";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// ReceiveUUID.GenerateNewReceiptUUID.Step
Procedure StepGenerateNewReceiptUUID(Parameters, Chain) Export
	Chain.GenerateNewReceiptUUID.Enable = True;
	Chain.GenerateNewReceiptUUID.Setter = "SetReceiveUUID";
	Options = ModelClientServer_V2.GenerateNewUUIDOptions();
	Options.Ref = Parameters.Object.Ref;
	Options.CurrentUUID = GetReceiveUUID(Parameters);
	Options.StepName = "StepGenerateNewReceiptUUID";
	Chain.GenerateNewReceiptUUID.Options.Add(Options);
EndProcedure

#EndRegion

#Region TRANSACTION_TYPE

// TransactionType.OnChange
Procedure TransactionTypeOnChange(Parameters) Export
	ProceedPropertyBeforeChange_Object(Parameters);
	AddViewNotify("OnSetTransactionTypeNotify", Parameters);
	Binding = BindTransactionType(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// TransactionType.Set
Procedure SetTransactionType(Parameters, Results) Export
	Binding = BindTransactionType(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetTransactionTypeNotify");
EndProcedure

// TransactionType.Get
Function GetTransactionType(Parameters)
	Return GetPropertyObject(Parameters, BindTransactionType(Parameters).DataPath);
EndFunction

// TransactionType.Bind
Function BindTransactionType(Parameters)
	DataPath = "TransactionType";
	Binding = New Structure();
	Binding.Insert("BankPayment",
		"StepChangeTransitAccountByAccount,
		|StepClearByTransactionTypeBankPayment");

	Binding.Insert("BankReceipt",
		"StepChangeTransitAccountByAccount,
		|StepClearByTransactionTypeBankReceipt");
	
	Binding.Insert("CashPayment" , "StepClearByTransactionTypeCashPayment");
	Binding.Insert("CashReceipt" , "StepClearByTransactionTypeCashReceipt");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// TransactionType.BankPayment.Fill
Procedure FillTransactionType_BankPayment(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Partner"                  , BindPaymentListPartner(Parameters));
	ResourceToBinding.Insert("Payee"                    , BindPaymentListLegalName(Parameters));
	ResourceToBinding.Insert("Agreement"                , BindPaymentListAgreement(Parameters));
	ResourceToBinding.Insert("LegalNameContract"        , BindPaymentListLegalNameContract(Parameters));
	ResourceToBinding.Insert("BasisDocument"            , BindPaymentListBasisDocument(Parameters));
	ResourceToBinding.Insert("PlanningTransactionBasis" , BindPaymentListPlanningTransactionBasis(Parameters));
	ResourceToBinding.Insert("Order"                    , BindPaymentListOrder(Parameters));
	ResourceToBinding.Insert("TransitAccount"           , BindTransitAccount(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// TransactionType.BankReceipt.Fill
Procedure FillTransactionType_BankReceipt(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Partner"                  , BindPaymentListPartner(Parameters));
	ResourceToBinding.Insert("Payer"                    , BindPaymentListLegalName(Parameters));
	ResourceToBinding.Insert("Agreement"                , BindPaymentListAgreement(Parameters));
	ResourceToBinding.Insert("LegalNameContract"        , BindPaymentListLegalNameContract(Parameters));
	ResourceToBinding.Insert("BasisDocument"            , BindPaymentListBasisDocument(Parameters));
	ResourceToBinding.Insert("PlanningTransactionBasis" , BindPaymentListPlanningTransactionBasis(Parameters));
	ResourceToBinding.Insert("Order"                    , BindPaymentListOrder(Parameters));
	ResourceToBinding.Insert("AmountExchange"           , BindPaymentListAmountExchange(Parameters));
	ResourceToBinding.Insert("POSAccount"               , BindPaymentListPOSAccount(Parameters));
	ResourceToBinding.Insert("TransitAccount"           , BindTransitAccount(Parameters));
	ResourceToBinding.Insert("CurrencyExchange"         , BindCurrencyExchange(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// TransactionType.CashPayment.Fill
Procedure FillTransactionType_CashPayment(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Partner"                  , BindPaymentListPartner(Parameters));
	ResourceToBinding.Insert("Payee"                    , BindPaymentListLegalName(Parameters));
	ResourceToBinding.Insert("Agreement"                , BindPaymentListAgreement(Parameters));
	ResourceToBinding.Insert("LegalNameContract"        , BindPaymentListLegalNameContract(Parameters));
	ResourceToBinding.Insert("BasisDocument"            , BindPaymentListBasisDocument(Parameters));
	ResourceToBinding.Insert("PlanningTransactionBasis" , BindPaymentListPlanningTransactionBasis(Parameters));
	ResourceToBinding.Insert("Order"                    , BindPaymentListOrder(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// TransactionType.CashReceipt.Fill
Procedure FillTransactionType_CashReceipt(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Partner"                  , BindPaymentListPartner(Parameters));
	ResourceToBinding.Insert("Payer"                    , BindPaymentListLegalName(Parameters));
	ResourceToBinding.Insert("Agreement"                , BindPaymentListAgreement(Parameters));
	ResourceToBinding.Insert("LegalNameContract"        , BindPaymentListLegalNameContract(Parameters));
	ResourceToBinding.Insert("BasisDocument"            , BindPaymentListBasisDocument(Parameters));
	ResourceToBinding.Insert("PlanningTransactionBasis" , BindPaymentListPlanningTransactionBasis(Parameters));
	ResourceToBinding.Insert("Order"                    , BindPaymentListOrder(Parameters));
	ResourceToBinding.Insert("AmountExchange"           , BindPaymentListAmountExchange(Parameters));
	ResourceToBinding.Insert("CurrencyExchange"         , BindCurrencyExchange(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// TransactionType.ClearByTransactionTypeBankPayment.Step
Procedure StepClearByTransactionTypeBankPayment(Parameters, Chain) Export
	Chain.ClearByTransactionTypeBankPayment.Enable = True;
	Chain.ClearByTransactionTypeBankPayment.Setter = "FillTransactionType_BankPayment";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ClearByTransactionTypeBankPaymentOptions();
		Options.TransactionType          = GetTransactionType(Parameters);
		Options.TransitAccount           = GetTransitAccount(Parameters);
		Options.Partner                  = GetPaymentListPartner(Parameters, Row.Key);
		Options.Payee                    = GetPaymentListLegalName(Parameters, Row.Key);
		Options.Agreement                = GetPaymentListAgreement(Parameters, Row.Key);
		Options.LegalNameContract        = GetPaymentListLegalNameContract(Parameters, Row.Key);
		Options.BasisDocument            = GetPaymentListBasisDocument(Parameters, Row.Key);
		Options.PlanningTransactionBasis = GetPaymentListPlanningTransactionBasis(Parameters, Row.Key);
		Options.Order                    = GetPaymentListOrder(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepClearByTransactionTypeBankPayment";
		Chain.ClearByTransactionTypeBankPayment.Options.Add(Options);
	EndDo;
EndProcedure

// TransactionType.ClearByTransactionTypeBankReceipt.Step
Procedure StepClearByTransactionTypeBankReceipt(Parameters, Chain) Export
	Chain.ClearByTransactionTypeBankReceipt.Enable = True;
	Chain.ClearByTransactionTypeBankReceipt.Setter = "FillTransactionType_BankReceipt";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ClearByTransactionTypeBankReceiptOptions();
		Options.TransactionType          = GetTransactionType(Parameters);
		Options.TransitAccount           = GetTransitAccount(Parameters);
		Options.CurrencyExchange         = GetCurrencyExchange(Parameters);
		Options.Partner                  = GetPaymentListPartner(Parameters, Row.Key);
		Options.Payer                    = GetPaymentListLegalName(Parameters, Row.Key);
		Options.Agreement                = GetPaymentListAgreement(Parameters, Row.Key);
		Options.LegalNameContract        = GetPaymentListLegalNameContract(Parameters, Row.Key);
		Options.BasisDocument            = GetPaymentListBasisDocument(Parameters, Row.Key);
		Options.PlanningTransactionBasis = GetPaymentListPlanningTransactionBasis(Parameters, Row.Key);
		Options.Order                    = GetPaymentListOrder(Parameters, Row.Key);
		Options.AmountExchange           = GetPaymentListAmountExchange(Parameters, Row.Key);
		Options.POSAccount               = GetPaymentListPOSAccount(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepClearByTransactionTypeBankReceipt";
		Chain.ClearByTransactionTypeBankReceipt.Options.Add(Options);
	EndDo;
EndProcedure

// TransactionType.ClearByTransactionTypeCashPayment.Step
Procedure StepClearByTransactionTypeCashPayment(Parameters, Chain) Export
	Chain.ClearByTransactionTypeCashPayment.Enable = True;
	Chain.ClearByTransactionTypeCashPayment.Setter = "FillTransactionType_CashPayment";
	For Each Row In GetRows(Parameters, "PaymentList") Do
		Options = ModelClientServer_V2.ClearByTransactionTypeCashPaymentOptions();
		Options.TransactionType          = GetTransactionType(Parameters);
		Options.BasisDocument            = GetPaymentListBasisDocument(Parameters, Row.Key);
		Options.Partner                  = GetPaymentListPartner(Parameters, Row.Key);
		Options.PlanningTransactionBasis = GetPaymentListPlanningTransactionBasis(Parameters, Row.Key);
		Options.Agreement                = GetPaymentListAgreement(Parameters, Row.Key);
		Options.LegalNameContract        = GetPaymentListLegalNameContract(Parameters, Row.Key);
		Options.Payee                    = GetPaymentListLegalName(Parameters, Row.Key);
		Options.Order                    = GetPaymentListOrder(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepClearByTransactionTypeCashPayment";
		Chain.ClearByTransactionTypeCashPayment.Options.Add(Options);
	EndDo;
EndProcedure

// TransactionType.ClearByTransactionTypeCashReceipt.Step
Procedure StepClearByTransactionTypeCashReceipt(Parameters, Chain) Export
	Chain.ClearByTransactionTypeCashReceipt.Enable = True;
	Chain.ClearByTransactionTypeCashReceipt.Setter = "FillTransactionType_CashReceipt";
	For Each Row In GetRows(Parameters, "PaymentList") Do
		Options = ModelClientServer_V2.ClearByTransactionTypeCashReceiptOptions();
		Options.TransactionType          = GetTransactionType(Parameters);
		Options.CurrencyExchange         = GetCurrencyExchange(Parameters);
		Options.Partner                  = GetPaymentListPartner(Parameters, Row.Key);
		Options.Payer                    = GetPaymentListLegalName(Parameters, Row.Key);
		Options.Agreement                = GetPaymentListAgreement(Parameters, Row.Key);
		Options.LegalNameContract        = GetPaymentListLegalNameContract(Parameters, Row.Key);
		Options.BasisDocument            = GetPaymentListBasisDocument(Parameters, Row.Key);
		Options.PlanningTransactionBasis = GetPaymentListPlanningTransactionBasis(Parameters, Row.Key);
		Options.Order                    = GetPaymentListOrder(Parameters, Row.Key);
		Options.AmountExchange           = GetPaymentListAmountExchange(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepClearByTransactionTypeCashReceipt";
		Chain.ClearByTransactionTypeCashReceipt.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region CURRENCY

// Currency.OnChange
Procedure CurrencyOnChange(Parameters) Export
	ProceedPropertyBeforeChange_Object(Parameters);
	AddViewNotify("OnSetCurrencyNotify", Parameters);
	Binding = BindCurrency(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Currency.Set
Procedure SetCurrency(Parameters, Results) Export
	Binding = BindCurrency(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetCurrencyNotify");
EndProcedure

// Currency.Get
Function GetCurrency(Parameters)
	Return GetPropertyObject(Parameters, BindCurrency(Parameters).DataPath);
EndFunction

// Currency.Bind
Function BindCurrency(Parameters)
	DataPath = "Currency";	
	Binding = New Structure();
	Binding.Insert("BankPayment", 
		"StepChangeCashAccountByCurrency,
		|StepChangePlanningTransactionBasisByCurrency");

	Binding.Insert("BankReceipt",
		"StepChangeCashAccountByCurrency,
		|StepChangePlanningTransactionBasisByCurrency");
	
	Binding.Insert("CashPayment",
		"StepChangeCashAccountByCurrency,
		|StepChangePlanningTransactionBasisByCurrency");
	
	Binding.Insert("CashReceipt",
		"StepChangeCashAccountByCurrency,
		|StepChangePlanningTransactionBasisByCurrency");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// Currency.ChangeCurrencyByAccount.[CurrencyInList].Step
Procedure StepChangeCurrencyByAccount_CurrencyInList(Parameters, Chain) Export
	Chain.ChangeCurrencyByAccount.Enable = True;
	Chain.ChangeCurrencyByAccount.Setter = "SetPaymentListCurrency";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeCurrencyByAccountOptions();
		Options.Account         = GetAccount(Parameters);
		Options.CurrentCurrency = GetPaymentListCurrency(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepChangeCurrencyByAccount_CurrencyInList";
		Chain.ChangeCurrencyByAccount.Options.Add(Options);
	EndDo;
EndProcedure

// Currency.ChangeCurrencyByAccount.Step
Procedure StepChangeCurrencyByAccount(Parameters, Chain) Export
	Chain.ChangeCurrencyByAccount.Enable = True;
	Chain.ChangeCurrencyByAccount.Setter = "SetCurrency";
	Options = ModelClientServer_V2.ChangeCurrencyByAccountOptions();
	Options.Account         = GetAccount(Parameters);
	Options.CurrentCurrency = GetCurrency(Parameters);
	Options.StepName = "StepChangeCurrencyByAccount";
	Chain.ChangeCurrencyByAccount.Options.Add(Options);
EndProcedure

// Currency.ChangeCurrencyByAgreement.Step
Procedure StepChangeCurrencyByAgreement(Parameters, Chain) Export
	Chain.ChangeCurrencyByAgreement.Enable = True;
	Chain.ChangeCurrencyByAgreement.Setter = "SetCurrency";
	Options = ModelClientServer_V2.ChangeCurrencyByAgreementOptions();
	Options.Agreement       = GetAgreement(Parameters);
	Options.CurrentCurrency = GetCurrency(Parameters);
	Options.StepName = "StepChangeCurrencyByAgreement";
	Chain.ChangeCurrencyByAgreement.Options.Add(Options);
EndProcedure

#EndRegion

#Region CURRENCY_RECEIVE

// ReceiveCurrency.OnChange
Procedure ReceiveCurrencyOnChange(Parameters) Export
	AddViewNotify("OnSetReceiveCurrencyNotify", Parameters);
	Binding = BindReceiveCurrency(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ReceiveCurrency.Set
Procedure SetReceiveCurrency(Parameters, Results) Export
	Binding = BindReceiveCurrency(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetReceiveCurrencyNotify");
EndProcedure

// ReceiveCurrency.Get
Function GetReceiveCurrency(Parameters)
	Return GetPropertyObject(Parameters, BindReceiveCurrency(Parameters).DataPath);
EndFunction

// ReceiveCurrency.Bind
Function BindReceiveCurrency(Parameters)
	DataPath = "ReceiveCurrency";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// ReceiveCurrency.ChangeCurrencyByAccount.Step
Procedure StepChangeReceiveCurrencyByAccount(Parameters, Chain) Export
	Chain.ChangeCurrencyByAccount.Enable = True;
	Chain.ChangeCurrencyByAccount.Setter = "SetReceiveCurrency";
	Options = ModelClientServer_V2.ChangeCurrencyByAccountOptions();
	Options.Account         = GetAccountReceiver(Parameters);
	Options.CurrentCurrency = GetReceiveCurrency(Parameters);
	Options.StepName = "StepChangeReceiveCurrencyByAccount";
	Chain.ChangeCurrencyByAccount.Options.Add(Options);
EndProcedure

#EndRegion

#Region CURRENCY_SEND

// SendCurrency.OnChange
Procedure SendCurrencyOnChange(Parameters) Export
	AddViewNotify("OnSetSendCurrencyNotify", Parameters);
	Binding = BindSendCurrency(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// SendCurrency.Set
Procedure SetSendCurrency(Parameters, Results) Export
	Binding = BindSendCurrency(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetSendCurrencyNotify");
EndProcedure

// SendCurrency.Get
Function GetSendCurrency(Parameters)
	Return GetPropertyObject(Parameters, BindSendCurrency(Parameters).DataPath);
EndFunction

// SendCurrency.Bind
Function BindSendCurrency(Parameters)
	DataPath = "SendCurrency";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// SendCurrency.ChangeCurrencyByAccount.Step
Procedure StepChangeSendCurrencyByAccount(Parameters, Chain) Export
	Chain.ChangeCurrencyByAccount.Enable = True;
	Chain.ChangeCurrencyByAccount.Setter = "SetSendCurrency";
	Options = ModelClientServer_V2.ChangeCurrencyByAccountOptions();
	Options.Account         = GetAccountSender(Parameters);
	Options.CurrentCurrency = GetSendCurrency(Parameters);
	Options.StepName = "StepChangeSendCurrencyByAccount";
	Chain.ChangeCurrencyByAccount.Options.Add(Options);
EndProcedure

#EndRegion

#Region CURRENCY_EXCHANGE

// CurrencyExchange.OnChange
Procedure CurrencyExchangeOnChange(Parameters) Export
	Binding = BindCurrencyExchange(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// CurrencyExchange.Set
Procedure SetCurrencyExchange(Parameters, Results) Export
	Binding = BindCurrencyExchange(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// CurrencyExchange.Get
Function GetCurrencyExchange(Parameters)
	Return GetPropertyObject(Parameters, BindCurrencyExchange(Parameters).DataPath);
EndFunction

// CurrencyExchange.Bind
Function BindCurrencyExchange(Parameters)
	DataPath = "CurrencyExchange";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region AMOUNT_SEND

// SendAmount.OnChange
Procedure SendAmountOnChange(Parameters) Export
	AddViewNotify("OnSetSendAmountNotify", Parameters);
	Binding = BindSendAmount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// SendAmount.Set
Procedure SetSendAmount(Parameters, Results) Export
	Binding = BindSendAmount(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetSendAmountNotify");
EndProcedure

// SendAmount.Get
Function GetSendAmount(Parameters)
	Return GetPropertyObject(Parameters, BindSendAmount(Parameters).DataPath);
EndFunction

// SendAmount.Bind
Function BindSendAmount(Parameters)
	DataPath = "SendAmount";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region AMOUNT_RECEIVE

// ReceiveAmount.OnChange
Procedure ReceiveAmountOnChange(Parameters) Export
	AddViewNotify("OnSetReceiveAmountNotify", Parameters);
	Binding = BindReceiveAmount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ReceiveAmount.Set
Procedure SetReceiveAmount(Parameters, Results) Export
	Binding = BindReceiveAmount(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetReceiveAmountNotify");
EndProcedure

// ReceiveAmount.Get
Function GetReceiveAmount(Parameters)
	Return GetPropertyObject(Parameters, BindReceiveAmount(Parameters).DataPath);
EndFunction

// ReceiveAmount.Bind
Function BindReceiveAmount(Parameters)
	DataPath = "ReceiveAmount";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region FINANCIAL_MOVEMENT_TYPE_SEND

// SendFinancialMovementType.Set
Procedure SetSendFinancialMovementType(Parameters, Results) Export
	Binding = BindSendFinancialMovementType(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// SendFinancialMovementType.Get
Function GetSendFinancialMovementType(Parameters)
	Return GetPropertyObject(Parameters, BindSendFinancialMovementType(Parameters).DataPath);
EndFunction

// SendFinancialMovementType.Bind
Function BindSendFinancialMovementType(Parameters)
	DataPath = "SendFinancialMovementType";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region FINANCIAL_MOVEMENT_TYPE_RECEIVE

// ReceiveFinancialMovementType.Set
Procedure SetReceiveFinancialMovementType(Parameters, Results) Export
	Binding = BindReceiveFinancialMovementType(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ReceiveFinancialMovementType.Get
Function GetReceiveFinancialMovementType(Parameters)
	Return GetPropertyObject(Parameters, BindReceiveFinancialMovementType(Parameters).DataPath);
EndFunction

// ReceiveFinancialMovementType.Bind
Function BindReceiveFinancialMovementType(Parameters)
	DataPath = "ReceiveFinancialMovementType";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region CASH_TRANSFER_ORDER

// CashTransferOrder.OnChange
Procedure CashTransferOrderOnChange(Parameters) Export
	ProceedPropertyBeforeChange_Object(Parameters);
	AddViewNotify("OnSetCashTransferOrderNotify", Parameters);
	Binding = BindCashTransferOrder(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// CashTransferOrder.Set
Procedure SetCashTransferOrder(Parameters, Results) Export
	Binding = BindCashTransferOrder(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetCashTransferOrderNotify");
EndProcedure

// CashTransferOrder.Get
Function GetCashTransferOrder(Parameters)
	Return GetPropertyObject(Parameters, BindCashTransferOrder(Parameters).DataPath);
EndFunction

// CashTransferOrder.Bind
Function BindCashTransferOrder(Parameters)
	DataPath = "CashTransferOrder";
	Binding = New Structure();
	Binding.Insert("MoneyTransfer", "StepFillByCashTransferOrder");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// CashTransferOrder.MoneyTransfer.Fill
Procedure FillCashTransferOrder_MoneyTransfer(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Company"                      , BindCompany(Parameters));
	ResourceToBinding.Insert("Branch"                       , BindBranch(Parameters));
	ResourceToBinding.Insert("CashTransferOrder"            , BindCashTransferOrder(Parameters));
	ResourceToBinding.Insert("Sender"                       , BindAccountSender(Parameters));
	ResourceToBinding.Insert("SendCurrency"                 , BindSendCurrency(Parameters));
	ResourceToBinding.Insert("SendFinancialMovementType"    , BindSendFinancialMovementType(Parameters));
	ResourceToBinding.Insert("SendAmount"                   , BindSendAmount(Parameters));
	ResourceToBinding.Insert("Receiver"                     , BindAccountReceiver(Parameters));
	ResourceToBinding.Insert("ReceiveCurrency"              , BindReceiveCurrency(Parameters));
	ResourceToBinding.Insert("ReceiveFinancialMovementType" , BindReceiveFinancialMovementType(Parameters));
	ResourceToBinding.Insert("ReceiveAmount"                , BindReceiveAmount(Parameters));
	
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// CashTransferOrder.FillByCashTarnsferOrder.Step
Procedure StepFillByCashTransferOrder(Parameters, Chain) Export
	Chain.FillByCashTransferOrder.Enable = True;
	Chain.FillByCashTransferOrder.Setter = "FillCashTransferOrder_MoneyTransfer";
		
	Options = ModelClientServer_V2.FillByCashTransferOrderOptions();
	Options.Company           = GetCompany(Parameters);
	Options.Branch            = GetBranch(Parameters);
	Options.CashTransferOrder = GetCashTransferOrder(Parameters);
	Options.Sender            = GetAccountSender(Parameters);
	Options.SendCurrency      = GetSendCurrency(Parameters);
	Options.SendAmount        = GetSendAmount(Parameters);
	Options.Receiver          = GetAccountReceiver(Parameters);
	Options.ReceiveCurrency   = GetReceiveCurrency(Parameters);
	Options.ReceiveAmount     = GetReceiveAmount(Parameters);
	Options.SendFinancialMovementType    = GetSendFinancialMovementType(Parameters);
	Options.ReceiveFinancialMovementType = GetReceiveFinancialMovementType(Parameters);
	Options.Ref = Parameters.Object.Ref;
	Options.StepName = "StepFillByCashTransferOrder";
	Chain.FillByCashTransferOrder.Options.Add(Options);
EndProcedure

#EndRegion

#Region _DATE

// Date.OnChange
Procedure DateOnChange(Parameters) Export
	ProceedPropertyBeforeChange_Object(Parameters);
	Binding = BindDate(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Date.Set
Procedure SetDate(Parameters, Results) Export
	Binding = BindDate(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Date.Get
Function GetDate(Parameters)
	Return GetPropertyObject(Parameters, BindDate(Parameters).DataPath);
EndFunction

// Date.Bind
Function BindDate(Parameters)
	DataPath = "Date";
	Binding = New Structure();
	Binding.Insert("SalesInvoice",
		"StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType,
		|StepChangeDeliveryDateByAgreement,
		|StepChangeAgreementByPartner_AgreementTypeIsCustomer, 
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader,
		|StepUpdatePaymentTerms");

	Binding.Insert("PurchaseInvoice",
		"StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType,
		|StepChangeDeliveryDateByAgreement,
		|StepChangeAgreementByPartner_AgreementTypeIsVendor, 
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader,
		|StepUpdatePaymentTerms");

	Binding.Insert("BankPayment",
		"StepRequireCallCreateTaxesFormControls, 
		|StepChangeTaxRate_AgreementInList");
		
	Binding.Insert("BankReceipt",
		"StepRequireCallCreateTaxesFormControls, 
		|StepChangeTaxRate_AgreementInList");
		
	Binding.Insert("CashPayment",
		"StepRequireCallCreateTaxesFormControls, 
		|StepChangeTaxRate_AgreementInList");
		
	Binding.Insert("CashReceipt",
		"StepRequireCallCreateTaxesFormControls, 
		|StepChangeTaxRate_AgreementInList");

	Binding.Insert("CashExpense",
		"StepRequireCallCreateTaxesFormControls, 
		|StepChangeTaxRate_AgreementInList");
	
	Binding.Insert("CashRevenue",
		"StepRequireCallCreateTaxesFormControls, 
		|StepChangeTaxRate_AgreementInList");
		
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region COMPANY

// Company.OnChange
Procedure CompanyOnChange(Parameters) Export
	ProceedPropertyBeforeChange_Object(Parameters);
	AddViewNotify("OnSetCompanyNotify", Parameters);
	Binding = BindCompany(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Company.Set
Procedure SetCompany(Parameters, Results) Export
	Binding = BindCompany(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetCompanyNotify");
EndProcedure

// Company.Get
Function GetCompany(Parameters)
	Return GetPropertyObject(Parameters, BindCompany(Parameters).DataPath);
EndFunction

// Company.Bind
Function BindCompany(Parameters)
	DataPath = "Company";
	Binding = New Structure();
	Binding.Insert("SalesInvoice",
		"StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_OnlyWhenAgreementIsFilled");

	Binding.Insert("PurchaseInvoice",
		"StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_OnlyWhenAgreementIsFilled");
	
	Binding.Insert("IncomingPaymentOrder", "StepChangeCashAccountByCompany_AccountTypeIsEmpty");
	Binding.Insert("OutgoingPaymentOrder", "StepChangeCashAccountByCompany_AccountTypeIsEmpty");
	
	Binding.Insert("BankPayment",
		"StepRequireCallCreateTaxesFormControls, 
		|StepChangeTaxRate_AgreementInList,
		|StepChangeCashAccountByCompany_AccountTypeIsBank");
	
	Binding.Insert("BankReceipt",
		"StepRequireCallCreateTaxesFormControls, 
		|StepChangeTaxRate_AgreementInList,
		|StepChangeCashAccountByCompany_AccountTypeIsBank");
	
	Binding.Insert("CashPayment",
		"StepRequireCallCreateTaxesFormControls, 
		|StepChangeTaxRate_AgreementInList,
		|StepChangeCashAccountByCompany_AccountTypeIsCash");
	
	Binding.Insert("CashReceipt",
		"StepRequireCallCreateTaxesFormControls, 
		|StepChangeTaxRate_AgreementInList,
		|StepChangeCashAccountByCompany_AccountTypeIsCash");
	
	Binding.Insert("CashExpense",
		"StepRequireCallCreateTaxesFormControls, 
		|StepChangeTaxRate_WithoutAgreement,
		|StepChangeCashAccountByCompany_AccountTypeIsCash");

	Binding.Insert("CashRevenue",
		"StepRequireCallCreateTaxesFormControls, 
		|StepChangeTaxRate_WithoutAgreement,
		|StepChangeCashAccountByCompany_AccountTypeIsCash");
	
	Binding.Insert("MoneyTransfer",
		"StepChangeAccountSenderByCompany,
		|StepChangeAccountReceiverByCompany");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// Company.ChangeCompanyByAgreement.Step
Procedure StepChangeCompanyByAgreement(Parameters, Chain) Export
	Chain.ChangeCompanyByAgreement.Enable = True;
	Chain.ChangeCompanyByAgreement.Setter = "SetCompany";
	Options = ModelClientServer_V2.ChangeCompanyByAgreementOptions();
	Options.Agreement      = GetAgreement(Parameters);
	Options.CurrentCompany = GetCompany(Parameters);
	Options.StepName = "StepChangeCompanyByAgreement";
	Chain.ChangeCompanyByAgreement.Options.Add(Options);
EndProcedure

#EndRegion

#Region BRANCH

// Branch.Set
Procedure SetBranch(Parameters, Results) Export
	Binding = BindBranch(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Branch.Get
Function GetBranch(Parameters)
	Return GetPropertyObject(Parameters, BindBranch(Parameters).DataPath);
EndFunction

// Branch.Bind
Function BindBranch(Parameters)
	DataPath = "Branch";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region PARTNER

// Partner.OnChange
Procedure PartnerOnChange(Parameters) Export
	ProceedPropertyBeforeChange_Object(Parameters);
	AddViewNotify("OnSetPartnerNotify", Parameters);
	Binding = BindPartner(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Partner.Set
Procedure SetPartner(Parameters, Results) Export
	Binding = BindPartner(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetPartnerNotify");
EndProcedure

// Partner.Get
Function GetPartner(Parameters)
	Return GetPropertyObject(Parameters, BindPartner(Parameters).DataPath);
EndFunction

// Partner.Bind
Function BindPartner(Parameters)
	DataPath = "Partner";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation", "StepChangeLegalNameByPartner");
	Binding.Insert("GoodsReceipt"        , "StepChangeLegalNameByPartner");
	
	Binding.Insert("SalesInvoice",
		"StepChangeAgreementByPartner_AgreementTypeIsCustomer,
		|StepChangeLegalNameByPartner,
		|StepChangeManagerSegmentByPartner");

	Binding.Insert("PurchaseInvoice",
		"StepChangeAgreementByPartner_AgreementTypeIsVendor,
		|StepChangeLegalNameByPartner");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region LEGAL_NAME

// LegalName.OnChange
Procedure LegalNameOnChange(Parameters) Export
	AddViewNotify("OnSetLegalNameNotify", Parameters);
	Binding = BindLegalName(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// LegalName.Set
Procedure SetLegalName(Parameters, Results) Export
	Binding = BindLegalName(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetLegalNameNotify");
EndProcedure

// LegalName.Get
Function GetLegalName(Parameters)
	Return GetPropertyObject(Parameters, BindLegalName(Parameters).DataPath);
EndFunction

// LegalName.Bind
Function BindLegalName(Parameters)
	DataPath = "LegalName";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// LegalName.ChangeLegalNameByPartner.Step
Procedure StepChangeLegalNameByPartner(Parameters, Chain) Export
	Chain.ChangeLegalNameByPartner.Enable = True;
	Chain.ChangeLegalNameByPartner.Setter = "SetLegalName";
	Options = ModelClientServer_V2.ChangeLegalNameByPartnerOptions();
	Options.Partner   = GetPartner(Parameters);
	Options.LegalName = GetLegalName(Parameters);
	Options.StepName = "StepChangeLegalNameByPartner";
	Chain.ChangeLegalNameByPartner.Options.Add(Options);
EndProcedure

#EndRegion

#Region DELIVERY_DATE

// DeliveryDate.OnChange
Procedure DeliveryDateOnChange(Parameters) Export
	ProceedPropertyBeforeChange_Form(Parameters);
	AddViewNotify("OnSetDeliveryDateNotify", Parameters);
	Binding = BindDeliveryDate(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// DeliveryDate.Set
Procedure SetDeliveryDate(Parameters, Results) Export
	Binding = BindDeliveryDate(Parameters);
	SetterForm(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetDeliveryDateNotify", ,True);
EndProcedure

// DeliveryDate.Get
Function GetDeliveryDate(Parameters)
	Return GetPropertyForm(Parameters, BindDeliveryDate(Parameters).DataPath);
EndFunction

// DeliveryDate.Default.Bind
Function BindDefaultDeliveryDate(Parameters)
	DataPath = "DeliveryDate";
	Binding = New Structure();
	Binding.Insert("SalesInvoice"   , "StepDefaultDeliveryDateInHeader");
	Binding.Insert("PurchaseInvoice", "StepDefaultDeliveryDateInHeader");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// DeliveryDate.Bind
Function BindDeliveryDate(Parameters)
	DataPath = "DeliveryDate";
	Binding = New Structure();
	Return BindSteps("StepItemListFillDeliveryDateInList", DataPath, Binding, Parameters);
EndFunction

// DeliveryDate.ChangeDeliveryDateByAgreement.Step
Procedure StepChangeDeliveryDateByAgreement(Parameters, Chain) Export
	Chain.ChangeDeliveryDateByAgreement.Enable = True;
	Chain.ChangeDeliveryDateByAgreement.Setter = "SetDeliveryDate";
	Options = ModelClientServer_V2.ChangeDeliveryDateByAgreementOptions();
	Options.Agreement           = GetAgreement(Parameters);
	Options.CurrentDeliveryDate = GetDeliveryDate(Parameters);
	Options.StepName = "StepChangeDeliveryDateByAgreement";
	Chain.ChangeDeliveryDateByAgreement.Options.Add(Options);
EndProcedure

// DeliveryDate.DefaultDeliveryDateInHeader.Step
Procedure StepDefaultDeliveryDateInHeader(Parameters, Chain) Export
	Chain.DefaultDeliveryDateInHeader.Enable = True;
	Chain.DefaultDeliveryDateInHeader.Setter = "SetDeliveryDate";
	Options = ModelClientServer_V2.DefaultDeliveryDateInHeaderOptions();
	Options.Date      = GetDate(Parameters);
	Options.Agreement = GetAgreement(Parameters);
	ArrayOfDeliveryDateInList = New Array();
	For Each Row In Parameters.Object[Parameters.TableName] Do
		ArrayOfDeliveryDateInList.Add(GetItemListDeliveryDate(Parameters, Row.Key));
	EndDo;
	Options.ArrayOfDeliveryDateInList = ArrayOfDeliveryDateInList; 
	Options.StepName = "StepDefaultDeliveryDateInHeader";
	Chain.DefaultDeliveryDateInHeader.Options.Add(Options);
EndProcedure

// DeliveryDate.ChangeDeliveryDateInHeaderByDeliveryDateInList.Step
Procedure StepChangeDeliveryDateInHeaderByDeliveryDateInList(Parameters, Chain) Export
	Chain.ChangeDeliveryDateInHeaderByDeliveryDateInList.Enable = True;
	Chain.ChangeDeliveryDateInHeaderByDeliveryDateInList.Setter = "SetDeliveryDate";
	Options = ModelClientServer_V2.ChangeDeliveryDateInHeaderByDeliveryDateInListOptions();
	ArrayOfDeliveryDateInList = New Array();
	For Each Row In Parameters.Object[Parameters.TableName] Do
		ArrayOfDeliveryDateInList.Add(GetItemListDeliveryDate(Parameters, Row.Key));
	EndDo;
	Options.ArrayOfDeliveryDateInList = ArrayOfDeliveryDateInList; 
	Options.StepName = "StepChangeDeliveryDateInHeaderByDeliveryDateInList";
	Chain.ChangeDeliveryDateInHeaderByDeliveryDateInList.Options.Add(Options);
EndProcedure

#EndRegion

#Region STORE

// Store.OnChange
Procedure StoreOnChange(Parameters) Export
	ProceedPropertyBeforeChange_Form(Parameters);
	AddViewNotify("OnSetStoreNotify", Parameters);
	If ValueIsFilled(GetStore(Parameters)) Then
		Binding = BindStore(Parameters);
	Else
		Binding = BindEmptyStore(Parameters);
	EndIf;
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Store.Set
Procedure SetStore(Parameters, Results) Export
	Binding = BindStore(Parameters);
	SetterForm(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetStoreNotify", ,True);
EndProcedure

// Store.Get
Function GetStore(Parameters)
	Return GetPropertyForm(Parameters, BindStore(Parameters).DataPath);
EndFunction

// Store.Default.Bind
Function BindDefaultStore(Parameters)
	DataPath = "Store";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation", "StepDefaultStoreInHeader_WithoutAgreement");
	Binding.Insert("GoodsReceipt"        , "StepDefaultStoreInHeader_WithoutAgreement");

	Binding.Insert("SalesInvoice"   , "StepDefaultStoreInHeader_AgreementInHeader");
	Binding.Insert("PurchaseInvoice", "StepDefaultStoreInHeader_AgreementInHeader");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// Store.Empty.Bind
Function BindEmptyStore(Parameters)
	DataPath = "Store";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation", "StepEmptyStoreInHeader_WithoutAgreement");
	Binding.Insert("GoodsReceipt"        , "StepEmptyStoreInHeader_WithoutAgreement");

	Binding.Insert("SalesInvoice"   , "StepEmptyStoreInHeader_AgreementInHeader");
	Binding.Insert("PurchaseInvoice", "StepEmptyStoreInHeader_AgreementInHeader");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// Store.Bind
Function BindStore(Parameters)
	DataPath = "Store";
	Binding = New Structure();
	Return BindSteps("StepItemListFillStoresInList", DataPath, Binding, Parameters);
EndFunction

// Store.ChangeStoreByAgreement.Step
Procedure StepChangeStoreByAgreement(Parameters, Chain) Export
	Chain.ChangeStoreByAgreement.Enable = True;
	Chain.ChangeStoreByAgreement.Setter = "SetStore";
	Options = ModelClientServer_V2.ChangeStoreByAgreementOptions();
	Options.Agreement    = GetAgreement(Parameters);
	Options.CurrentStore = GetStore(Parameters);
	Options.StepName = "StepChangeStoreByAgreement";
	Chain.ChangeStoreByAgreement.Options.Add(Options);
EndProcedure

// Store.EmptyStoreInHeader.[AgreementInHeader].Step
Procedure StepEmptyStoreInHeader_AgreementInHeader(Parameters, Chain) Export
	StepEmptyStoreInHeader(Parameters, Chain, True);
EndProcedure

// Store.EmptyStoreInHeader.[WithoutAgreement].Step
Procedure StepEmptyStoreInHeader_WithoutAgreement(Parameters, Chain) Export
	StepEmptyStoreInHeader(Parameters, Chain, False);
EndProcedure

// Store.EmptyStoreInHeader.Step
Procedure StepEmptyStoreInHeader(Parameters, Chain, AgreementInHeader)
	Chain.EmptyStoreInHeader.Enable = True;
	Chain.EmptyStoreInHeader.Setter = "SetStore";
	Options = ModelClientServer_V2.EmptyStoreInHeaderOptions();
	Options.DocumentRef = Parameters.Object.Ref;
	If AgreementInHeader Then
		Options.Agreement = GetAgreement(Parameters);
	EndIf;
	ArrayOfStoresInList = New Array();
	For Each Row In Parameters.Object[Parameters.TableName] Do
		ArrayOfStoresInList.Add(GetItemListStore(Parameters, Row.Key));
	EndDo;
	Options.ArrayOfStoresInList = ArrayOfStoresInList;
	Options.StepName = "StepEmptyStoreInHeader";
	Chain.EmptyStoreInHeader.Options.Add(Options);
EndProcedure

// Store.DefaultStoreInHeader.[AgreementInHeader].Step
Procedure StepDefaultStoreInHeader_AgreementInHeader(Parameters, Chain) Export
	StepDefaultStoreInHeader(Parameters, Chain, True);
EndProcedure

// Store.DefaultStoreInHeader.[WithoutAgreement].Step
Procedure StepDefaultStoreInHeader_WithoutAgreement(Parameters, Chain) Export
	StepDefaultStoreInHeader(Parameters, Chain, False);
EndProcedure

// Store.DefaultStoreInHeader.Step
Procedure StepDefaultStoreInHeader(Parameters, Chain, AgreementInHeader)
	Chain.DefaultStoreInHeader.Enable = True;
	Chain.DefaultStoreInHeader.Setter = "SetStore";
	Options = ModelClientServer_V2.DefaultStoreInHeaderOptions();
	Options.DocumentRef = Parameters.Object.Ref;
	If AgreementInHeader Then
		Options.Agreement   = GetAgreement(Parameters);
	EndIf;
	ArrayOfStoresInList = New Array();
	For Each Row In Parameters.Object.ItemList Do
		ArrayOfStoresInList.Add(GetItemListStore(Parameters, Row.Key));
	EndDo;
	Options.ArrayOfStoresInList = ArrayOfStoresInList;
	Options.StepName = "StepDefaultStoreInHeader";
	Chain.DefaultStoreInHeader.Options.Add(Options);
EndProcedure

// Store.ChangeStoreInHeaderByStoresInList.Step
Procedure StepChangeStoreInHeaderByStoresInList(Parameters, Chain) Export
	Chain.ChangeStoreInHeaderByStoresInList.Enable = True;
	Chain.ChangeStoreInHeaderByStoresInList.Setter = "SetStore";
	Options = ModelClientServer_V2.ChangeStoreInHeaderByStoresInListOptions();
	ArrayOfStoresInList = New Array();
	For Each Row In Parameters.Object.ItemList Do
		NewRow = New Structure();
		NewRow.Insert("Store"   , GetItemListStore(Parameters, Row.Key));
		NewRow.Insert("ItemKey" , GetItemListItemKey(Parameters, Row.Key));
		ArrayOfStoresInList.Add(NewRow);
	EndDo;
	Options.ArrayOfStoresInList = ArrayOfStoresInList; 
	Options.StepName = "StepChangeStoreInHeaderByStoresInList";
	Chain.ChangeStoreInHeaderByStoresInList.Options.Add(Options);
EndProcedure

#EndRegion

#Region AGREEMENT

// Agreement.OnChange
Procedure AgreementOnChange(Parameters) Export
	ProceedPropertyBeforeChange_Object(Parameters);
	AddViewNotify("OnSetPartnerNotify", Parameters);
	Binding = BindAgreement(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Agreement.Set
Procedure SetAgreement(Parameters, Results) Export
	Binding = BindAgreement(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Agreement.Get
Function GetAgreement(Parameters)
	Return GetPropertyObject(Parameters, BindAgreement(Parameters).DataPath);
EndFunction

// Agreement.Bind
Function BindAgreement(Parameters)
	DataPath = "Agreement";
	Binding = New Structure();
	Binding.Insert("SalesInvoice",
		"StepChangeCompanyByAgreement,
		|StepChangeCurrencyByAgreement,
		|StepChangeStoreByAgreement,
		|StepChangeDeliveryDateByAgreement,
		|StepItemListChangePriceTypeByAgreement,
		|StepChangePriceIncludeTaxByAgreement,
		|StepChangePaymentTermsByAgreement,
		|StepChangeTaxRate_AgreementInHeader");

	Binding.Insert("PurchaseInvoice",
		"StepChangeCompanyByAgreement,
		|StepChangeCurrencyByAgreement,
		|StepChangeStoreByAgreement,
		|StepChangeDeliveryDateByAgreement,
		|StepItemListChangePriceTypeByAgreement,
		|StepChangePriceIncludeTaxByAgreement,
		|StepChangePaymentTermsByAgreement,
		|StepChangeTaxRate_AgreementInHeader");
		
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// Agreement.ChangeAgreementByPartner.[AgreementTypeIsCustomer].Step
Procedure StepChangeAgreementByPartner_AgreementTypeIsCustomer(Parameters, Chain) Export
	StepChangeAgreementByPartner(Parameters, Chain, PredefinedValue("Enum.AgreementTypes.Customer"));
EndProcedure

// Agreement.ChangeAgreementByPartner.[AgreementTypeIsVendor].Step
Procedure StepChangeAgreementByPartner_AgreementTypeIsVendor(Parameters, Chain) Export
	StepChangeAgreementByPartner(Parameters, Chain, PredefinedValue("Enum.AgreementTypes.Vendor"));
EndProcedure

// Agreement.ChangeAgreementByPartner.Step
Procedure StepChangeAgreementByPartner(Parameters, Chain, AgreementType)
	Chain.ChangeAgreementByPartner.Enable = True;
	Chain.ChangeAgreementByPartner.Setter = "SetAgreement";
	Options = ModelClientServer_V2.ChangeAgreementByPartnerOptions();
	Options.Partner       = GetPartner(Parameters);
	Options.Agreement     = GetAgreement(Parameters);
	Options.CurrentDate   = GetDate(Parameters);
	Options.AgreementType = AgreementType;
	Options.StepName = "StepChangeAgreementByPartner";
	Chain.ChangeAgreementByPartner.Options.Add(Options);
EndProcedure

#EndRegion

#Region MANAGER_SEGMENT

// ManagerSegment.OnChange
Procedure ManagerSegmentOnChange(Parameters) Export
	Binding = BindManagerSegment(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ManagerSegment.Set
Procedure SetManagerSegment(Parameters, Results) Export
	Binding = BindManagerSegment(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ManagerSegment.Bind
Function BindManagerSegment(Parameters)
	DataPath = "ManagerSegment";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// ManagerSegment.ChangeManagerSegmentByPartner.Step
Procedure StepChangeManagerSegmentByPartner(Parameters, Chain) Export
	Chain.ChangeManagerSegmentByPartner.Enable = True;
	Chain.ChangeManagerSegmentByPartner.Setter = "SetManagerSegment";
	Options = ModelClientServer_V2.ChangeManagerSegmentByPartnerOptions();
	Options.Partner = GetPartner(Parameters);
	Options.StepName = "StepChangeManagerSegmentByPartner";
	Chain.ChangeManagerSegmentByPartner.Options.Add(Options);
EndProcedure

#EndRegion

#Region PRICE_INCLUDE_TAX

// PriceIncludeTax.OnChange
Procedure PriceIncludeTaxOnChange(Parameters) Export
	Binding = BindPriceIncludeTax(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PriceIncludeTax.Set
Procedure SetPriceIncludeTax(Parameters, Results) Export
	Binding = BindPriceIncludeTax(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PriceIncludeTax.Get
Function GetPriceIncludeTax(Parameters)
	Return GetPropertyObject(Parameters, "PriceIncludeTax");
EndFunction

// PriceIncludeTax.Bind
Function BindPriceIncludeTax(Parameters)
	DataPath = "PriceIncludeTax";
	Binding = New Structure();
	Return BindSteps("StepItemListCalculations_IsPriceIncludeTaxChanged", DataPath, Binding, Parameters);
EndFunction

// PriceIncludeTax.ChangePriceIncludeTaxByAgreement.Step
Procedure StepChangePriceIncludeTaxByAgreement(Parameters, Chain) Export
	Chain.ChangePriceIncludeTaxByAgreement.Enable = True;
	Chain.ChangePriceIncludeTaxByAgreement.Setter = "SetPriceIncludeTax";
	Options = ModelClientServer_V2.ChangePriceIncludeTaxByAgreementOptions();
	Options.Agreement = GetAgreement(Parameters);
	Options.StepName = "StepChangePriceIncludeTaxByAgreement";
	Chain.ChangePriceIncludeTaxByAgreement.Options.Add(Options);
EndProcedure

#EndRegion

#Region PAYMENT_TERMS_LIST

// PaymentTerms.Set
Procedure SetPaymentTerms(Parameters, Results) Export
	Binding = BindPaymentTerms(Parameters);
	For Each Result In Results Do
		If Parameters.ChangedData.Get(Binding.DataPath) = Undefined Then
			Parameters.Cache.Insert(Binding.DataPath, Result.Value.ArrayOfPaymentTerms);
		EndIf;
		// data is changed only when Object.PaymentTerms have rows
		If Parameters.Object.PaymentTerms.Count() Then
			PutToChangedData(Parameters, Binding.DataPath, Undefined, Undefined, Undefined);
		EndIf;
	EndDo;
EndProcedure

// PaymentTerms.Get
Function GetPaymentTerms(Parameters) Export
	Binding = BindPaymentTerms(Parameters);
	// if data in cache get from cache
	If Parameters.Cache.Property(Binding.DataPath) Then
		Return Parameters.Cache[Binding.DataPath];
	EndIf;
	// if not data in cache get from object 
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
Function BindPaymentTerms(Parameters)
	DataPath = "PaymentTerms";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// PaymentTerms.ChangePaymentTermsByAgreement.Step
Procedure StepChangePaymentTermsByAgreement(Parameters, Chain) Export
	Chain.ChangePaymentTermsByAgreement.Enable = True;
	Chain.ChangePaymentTermsByAgreement.Setter = "SetPaymentTerms";
	Options = ModelClientServer_V2.ChangePaymentTermsByAgreementOptions();
	Options.Agreement = GetAgreement(Parameters);
	Options.Date      = GetDate(Parameters);
	Options.ArrayOfPaymentTerms = GetPaymentTerms(Parameters);
	TotalAmount = 0;
	For Each Row In Parameters.Object[Parameters.TableName] Do
		TotalAmount = TotalAmount + GetItemListTotalAmount(Parameters, Row.Key);
	EndDo;
	Options.TotalAmount = TotalAmount;
	Options.StepName = "StepChangePaymentTermsByAgreement";
	Chain.ChangePaymentTermsByAgreement.Options.Add(Options);	
EndProcedure

// PaymentTerms.UpdatePaymentTerms.Step
Procedure StepUpdatePaymentTerms(Parameters, Chain) Export
	Chain.UpdatePaymentTerms.Enable = True;
	Chain.UpdatePaymentTerms.Setter = "SetPaymentTerms";
	Options = ModelClientServer_V2.UpdatePaymentTermsOptions();
	Options.Date                = GetDate(Parameters);
	Options.ArrayOfPaymentTerms = GetPaymentTerms(Parameters);
	TotalAmount = 0;
	For Each Row In Parameters.Object[Parameters.TableName] Do
		TotalAmount = TotalAmount + GetItemListTotalAmount(Parameters, Row.Key);
	EndDo;
	Options.TotalAmount = TotalAmount;
	Options.StepName = "StepUpdatePaymentTerms";
	Chain.UpdatePaymentTerms.Options.Add(Options);
EndProcedure

#EndRegion

#Region OFFERS_LIST

// Offers.OnChange
Procedure OffersOnChange(Parameters) Export
	Binding = BindOffers(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Offers.Bind
Function BindOffers(Parameters)
	DataPath = "Offers";
	Binding = New Structure();
	Return BindSteps("StepItemListCalculations_IsOffersChanged", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region TAX_LIST

// TaxList.Set
Procedure SetTaxList(Parameters, Results)
	// for tabular part TaxList needed full transfer from cache to object
	For Each Result In Results Do
		If Result.Value.TaxList.Count() Then
			If Not Parameters.Cache.Property("TaxList") Then
				Parameters.Cache.Insert("TaxList", New Array());
			EndIf;
			
			// remove from cache old rows
			Count = Parameters.Cache.TaxList.Count();
			For i = 1 To Count Do
				Index = Count - i;
				ArrayItem = Parameters.Cache.TaxList[Index];
				If ArrayItem.Key = Result.Options.Key Then
					Parameters.Cache.TaxList.Delete(Index);
				EndIf;
			EndDo;
			
			// add new rows
			For Each Row In Result.Value.TaxList Do
				Parameters.Cache.TaxList.Add(Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region TAX_RATE

// TaxRate.Get
Function GetTaxRate(Parameters, Row)
	TaxRates = New Structure();
	ReadOnlyFromCache = Not Parameters.FormTaxColumnsExists;
	For Each TaxRate In Row.TaxRates Do
		If ReadOnlyFromCache And ValueIsFilled(TaxRate.Value) Then
			TaxRates.Insert(TaxRate.Key, TaxRate.Value);
		Else
			TaxRates.Insert(TaxRate.Key, 
				GetPropertyObject(Parameters, Parameters.TableName + "." + TaxRate.Key, Row.Key, ReadOnlyFromCache));
		EndIf;
	EndDo;
	Return TaxRates;
EndFunction

// <List>.ChangeTaxRate.[AgreementInHeader].Step
Procedure StepChangeTaxRate_AgreementInHeader(Parameters, Chain) Export
	StepChangeTaxRate(Parameters, Chain, True);
EndProcedure

// <List>.ChangeTaxRate.[AgreementInList].Step
Procedure StepChangeTaxRate_AgreementInList(Parameters, Chain) Export
	StepChangeTaxRate(Parameters, Chain, , True);
EndProcedure

// <List>.ChangeTaxRate.[OnlyWhenAgreementIsFilled].Step
Procedure StepChangeTaxRate_OnlyWhenAgreementIsFilled(Parameters, Chain) Export
	StepChangeTaxRate(Parameters, Chain, True, , True);
EndProcedure

// <List>.ChangeTaxRate.[WithoutAgreement].Step
Procedure StepChangeTaxRate_WithoutAgreement(Parameters, Chain) Export
	StepChangeTaxRate(Parameters, Chain);
EndProcedure

// <List>.ChangeTaxRate.Step
Procedure StepChangeTaxRate(Parameters, Chain,
			AgreementInHeader = False,
			AgreementInList = False, 
			OnlyWhenAgreementIsFilled = False)
	
	Options_Date      = GetDate(Parameters);
	Options_Company   = GetCompany(Parameters);

	// ChangeTaxRate
	Chain.ChangeTaxRate.Enable = True;
	Chain.ChangeTaxRate.Setter = "Set" + Parameters.TableName + "TaxRate";
	
	TaxRates = Undefined;
	If Not (Parameters.FormTaxColumnsExists And Parameters.ArrayOfTaxInfo.Count()) Then
		Parameters.ArrayOfTaxInfo = TaxesServer._GetArrayOfTaxInfo(Parameters.Object, Options_Date, Options_Company);
		TaxRates = New Structure();
		For Each ItemOfTaxInfo In Parameters.ArrayOfTaxInfo Do
			TaxRates.Insert(ItemOfTaxInfo.Name, Undefined);
		EndDo;
	EndIf;
	
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		// ChangeTaxRate
		Options = ModelClientServer_V2.ChangeTaxRateOptions();
		If AgreementInHeader Then
			Options.Agreement = GetAgreement(Parameters);
		EndIf;
		If AgreementInList Then
			Options.Agreement = GetPropertyObject(Parameters, Parameters.TableName + "." + "Agreement", Row.Key);
		EndIf;
		Options.ChangeOnlyWhenAgreementIsFilled = OnlyWhenAgreementIsFilled;
		
		Options.Date           = Options_Date;
		Options.Company        = Options_Company;
		Options.ArrayOfTaxInfo = Parameters.ArrayOfTaxInfo;
		Options.IsBasedOn      = Parameters.IsBasedOn;
		Options.Ref            = Parameters.Object.Ref;
		
		If TaxRates <> Undefined Then
			For Each ItemOfTaxInfo In Parameters.ArrayOfTaxInfo Do
				SetProperty(Parameters.Cache, Parameters.TableName + "." + ItemOfTaxInfo.Name, Row.Key, Undefined);
			EndDo;
			Row.Insert("TaxRates", TaxRates);
		EndIf;
		
		Options.TaxRates = GetTaxRate(Parameters, Row);
		Options.TaxList  = Row.TaxList;
		Options.Key = Row.Key;
		Options.StepName = "StepChangeTaxRate";
		Chain.ChangeTaxRate.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region PAYMENT_LIST

#Region PAYMENT_LIST_PARTNER

// PaymentList.Partner.OnChange
Procedure PaymentListPartnerOnChange(Parameters) Export
	Binding = BindPaymentListPartner(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.Partner.Set
Procedure SetPaymentListPartner(Parameters, Results) Export
	Binding = BindPaymentListPartner(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.Partner.Get
Function GetPaymentListPartner(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentListPartner(Parameters).DataPath, _Key);
EndFunction

// PaymentList.Partner.Bind
Function BindPaymentListPartner(Parameters)
	DataPath = "PaymentList.Partner";
	Binding = New Structure();
	Binding.Insert("IncomingPaymentOrder",
		"StepPaymentListChangeLegalNameByPartner");
	
	Binding.Insert("OutgoingPaymentOrder",
		"StepPaymentListChangeLegalNameByPartner,
		|StepPaymentListChangeCashAccountByPartner");
	
	Binding.Insert("BankPayment",
		"StepPaymentListChangeLegalNameByPartner,
		|StepPaymentListChangeAgreementByPartner");
	
	Binding.Insert("BankReceipt",
		"StepPaymentListChangeLegalNameByPartner,
		|StepPaymentListChangeAgreementByPartner");
		
	Binding.Insert("CashPayment",
		"StepPaymentListChangeLegalNameByPartner,
		|StepPaymentListChangeAgreementByPartner");
		
	Binding.Insert("CashReceipt",
		"StepPaymentListChangeLegalNameByPartner,
		|StepPaymentListChangeAgreementByPartner");
	
	Return BindSteps(Undefined, DataPath, Binding, Parameters);
EndFunction

// PaymentList.Partner.ChangePartnerByLegalName.Step
Procedure StepPaymentListChangePartnerByLegalName(Parameters, Chain) Export
	Chain.ChangePartnerByLegalName.Enable = True;
	Chain.ChangePartnerByLegalName.Setter = "SetPaymentListPartner";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeLegalNameByPartnerOptions();
		Options.Partner   = GetPaymentListPartner(Parameters, Row.Key);
		Options.LegalName = GetPaymentListLegalName(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepPaymentListChangePartnerByLegalName";
		Chain.ChangePartnerByLegalName.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region PAYMENT_LIST_PARTNER_BANK_ACCOUNT

// PaymentList.PartnerBankAccount.OnChange
Procedure PaymentListPartnerBankAccountOnChange(Parameters) Export
	Binding = BindPaymentListPartnerBankAccount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.PartnerBankAccount.Set
Procedure SetPaymentListPartnerBankAccount(Parameters, Results) Export
	Binding = BindPaymentListPartnerBankAccount(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.PartnerBankAccount.Bind
Function BindPaymentListPartnerBankAccount(Parameters)
	DataPath = "PaymentList.PartnerBankAccount";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// PaymentList.PartnerBankAccount.ChangeCashAccountByPartner.Step
Procedure StepPaymentListChangeCashAccountByPartner(Parameters, Chain) Export
	Chain.ChangeCashAccountByPartner.Enable = True;
	Chain.ChangeCashAccountByPartner.Setter = "SetPaymentListPartnerBankAccount";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeCashAccountByPartnerOptions();
		Options.Partner   = GetPaymentListPartner(Parameters, Row.Key);
		Options.LegalName = GetPaymentListLegalName(Parameters, Row.Key);
		Options.Currency  = GetCurrency(Parameters);
		Options.Key = Row.Key;
		Options.StepName = "PaymentListChangeCashAccountByPartner";
		Chain.ChangeCashAccountByPartner.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region PAYMENT_LIST_AGREEMENT

// PaymentList.Agreement.OnChange
Procedure PaymentListAgreementOnChange(Parameters) Export
	Binding = BindPaymentListAgreement(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.Agreement.Set
Procedure SetPaymentListAgreement(Parameters, Results) Export
	Binding = BindPaymentListAgreement(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.Agreement.Get
Function GetPaymentListAgreement(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentListAgreement(Parameters).DataPath , _Key);
EndFunction

// PaymentList.Agreement.Bind
Function BindPaymentListAgreement(Parameters)
	DataPath = "PaymentList.Agreement";
	Binding = New Structure();
	Binding.Insert("BankPayment",
		"StepPaymentListChangeBasisDocumentByAgreement,
		|StepPaymentListChangeOrderByAgreement,
		|StepExtractDataAgreementApArPostingDetail,
		|StepChangeTaxRate_AgreementInList");
	
	Binding.Insert("BankReceipt",
		"StepPaymentListChangeBasisDocumentByAgreement,
		|StepPaymentListChangeOrderByAgreement,
		|StepExtractDataAgreementApArPostingDetail,
		|StepChangeTaxRate_AgreementInList");
	
	Binding.Insert("CashPayment",
		"StepPaymentListChangeBasisDocumentByAgreement,
		|StepPaymentListChangeOrderByAgreement,
		|StepExtractDataAgreementApArPostingDetail,
		|StepChangeTaxRate_AgreementInList");
	
	Binding.Insert("CashReceipt",
		"StepPaymentListChangeBasisDocumentByAgreement,
		|StepPaymentListChangeOrderByAgreement,
		|StepExtractDataAgreementApArPostingDetail,
		|StepChangeTaxRate_AgreementInList");
	Return BindSteps(Undefined, DataPath, Binding, Parameters);
EndFunction

// PaymentList.Agreement.ChangeAgreementByPartner.Step
Procedure StepPaymentListChangeAgreementByPartner(Parameters, Chain) Export
	Chain.ChangeAgreementByPartner.Enable = True;
	Chain.ChangeAgreementByPartner.Setter = "SetPaymentListAgreement";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeAgreementByPartnerOptions();
		Options.Partner       = GetPaymentListPartner(Parameters, Row.Key);
		Options.Agreement     = GetPaymentListAgreement(Parameters, Row.Key);
		Options.CurrentDate   = GetDate(Parameters);
		Options.Key = Row.Key;
		Options.StepName = "PaymentListChangeAgreementByPartner";
		Chain.ChangeAgreementByPartner.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region PAYMENT_LIST_CURRENCY

// PaymentList.Currency.Set
Procedure SetPaymentListCurrency(Parameters, Results) Export
	Binding = BindPaymentListCurrency(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.Currency.Get
Function GetPaymentListCurrency(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentListCurrency(Parameters).DataPath , _Key);
EndFunction

// PaymentList.Currency.Default.Bind
Function BindDefaultPaymentListCurrency(Parameters)
	DataPath = "PaymentList.Currency";
	Binding = New Structure();
	Return BindSteps("StepPaymentListDefaultCurrencyInList", DataPath, Binding, Parameters);
EndFunction

// PaymentList.Currency.Bind
Function BindPaymentListCurrency(Parameters)
	DataPath = "PaymentList.Currency";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// PaymentList.Currency..StepPaymentListDefaultCurrencyInList.Step
Procedure StepPaymentListDefaultCurrencyInList(Parameters, Chain) Export
	Chain.DefaultCurrencyInList.Enable = True;
	Chain.DefaultCurrencyInList.Setter = "SetPaymentListCurrency";
	Options = ModelClientServer_V2.DefaultCurrencyInListOptions();
	NewRow = Parameters.RowFilledByUserSettings;
	Options.Account         = GetAccount(Parameters);
	Options.CurrentCurrency = GetPaymentListCurrency(Parameters, NewRow.Key);
	Options.Key = NewRow.Key;
	Chain.DefaultCurrencyInList.Options.Add(Options);
EndProcedure

#EndRegion

#Region PAYMENT_LIST_LEGAL_NAME

// PaymentList.LegalName.OnChange
Procedure PaymentListLegalNameOnChange(Parameters) Export
	Binding = BindPaymentListLegalName(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.LegalName.Set
Procedure SetPaymentListLegalName(Parameters, Results) Export
	Binding = BindPaymentListLegalName(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.LegalName.Get
Function GetPaymentListLegalName(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentListLegalName(Parameters).DataPath , _Key);
EndFunction

// PaymentList.LegalName.Bind
Function BindPaymentListLegalName(Parameters)
	DataPath = New Map();
	DataPath.Insert("IncomingPaymentOrder", "PaymentList.Payer");
	DataPath.Insert("OutgoingPaymentOrder", "PaymentList.Payee");
	DataPath.Insert("BankPayment"         , "PaymentList.Payee");
	DataPath.Insert("BankReceipt"         , "PaymentList.Payer");
	DataPath.Insert("CashPayment"         , "PaymentList.Payee");
	DataPath.Insert("CashReceipt"         , "PaymentList.Payer");
	
	Binding = New Structure();
	Binding.Insert("IncomingPaymentOrder", "StepPaymentListChangePartnerByLegalName");
	Binding.Insert("OutgoingPaymentOrder", "StepPaymentListChangePartnerByLegalName");
	Binding.Insert("BankPayment"         , "StepPaymentListChangePartnerByLegalName");
	Binding.Insert("BankReceipt"         , "StepPaymentListChangePartnerByLegalName");
	Binding.Insert("CashPayment"         , "StepPaymentListChangePartnerByLegalName");
	Binding.Insert("CashReceipt"         , "StepPaymentListChangePartnerByLegalName");
	Return BindSteps(Undefined, DataPath, Binding, Parameters);
EndFunction

// PaymentList.LegalName.ChangeLegalNameByPartner.Step
Procedure StepPaymentListChangeLegalNameByPartner(Parameters, Chain) Export
	Chain.ChangeLegalNameByPartner.Enable = True;
	Chain.ChangeLegalNameByPartner.Setter = "SetPaymentListLegalName";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeLegalNameByPartnerOptions();
		Options.Partner   = GetPaymentListPartner(Parameters, Row.Key);
		Options.LegalName = GetPaymentListLegalName(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepPaymentListChangeLegalNameByPartner";
		Chain.ChangeLegalNameByPartner.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region PAYMENT_LIST_LEGAL_NAME_CONTRACT

// PaymentList.LegalNameContract.OnChange
Procedure PaymentListLegalNameContractOnChange(Parameters) Export
	Binding = BindPaymentListLegalNameContract(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.LegalNameContract.Set
Procedure SetPaymentListLegalNameContract(Parameters, Results) Export
	Binding = BindPaymentListLegalNameContract(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.LegalNameContract.Get
Function GetPaymentListLegalNameContract(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentListLegalNameContract(Parameters).DataPath , _Key);
EndFunction

// PaymentList.LegalNameContract.Bind
Function BindPaymentListLegalNameContract(Parameters)
	DataPath = "PaymentList.LegalNameContract";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region PAYMENT_LIST_POS_ACCOUNT

// PaymentList.POSAccount.OnChange
Procedure PaymentListPOSAccountOnChange(Parameters) Export
	Binding = BindPaymentListPOSAccount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.POSAccount.Set
Procedure SetPaymentListPOSAccount(Parameters, Results) Export
	Binding = BindPaymentListPOSAccount(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.POSAccount.Get
Function GetPaymentListPOSAccount(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentListPOSAccount(Parameters).DataPath , _Key);
EndFunction

// PaymentList.POSAccount.Bind
Function BindPaymentListPOSAccount(Parameters)
	DataPath = "PaymentList.POSAccount";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region PAYMENT_LIST_BASIS_DOCUMENT

// PaymentList.BasisDocument.OnChange
Procedure PaymentListBasisDocumentOnChange(Parameters) Export
	Binding = BindPaymentListBasisDocument(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.BasisDocument.Set
Procedure SetPaymentListBasisDocument(Parameters, Results) Export
	Binding = BindPaymentListBasisDocument(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.BasisDocument.Get
Function GetPaymentListBasisDocument(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentListBasisDocument(Parameters).DataPath , _Key);
EndFunction

// PaymentList.BasisDocument.Bind
Function BindPaymentListBasisDocument(Parameters)
	DataPath = "PaymentList.BasisDocument";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// PaymentList.BasisDocument.ChangeBasisDocumentByAgreement.Step
Procedure StepPaymentListChangeBasisDocumentByAgreement(Parameters, Chain) Export
	Chain.ChangeBasisDocumentByAgreement.Enable = True;
	Chain.ChangeBasisDocumentByAgreement.Setter = "SetPaymentListBasisDocument";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeBasisDocumentByAgreementOptions();
		Options.Agreement            = GetPaymentListAgreement(Parameters, Row.Key);
		Options.CurrentBasisDocument = GetPaymentListBasisDocument(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepPaymentListChangeBasisDocumentByAgreement";
		Chain.ChangeBasisDocumentByAgreement.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region PAYMENT_LIST_PLANNING_TRANSACTION_BASIS

// PaymentList.PlanningTransactionBasis.OnChange
Procedure PaymentListPlanningTransactionBasisOnChange(Parameters) Export
	Binding = BindPaymentListPlanningTransactionBasis(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.PlanningTransactionBasis.Set
Procedure SetPaymentListPlanningTransactionBasis(Parameters, Results) Export
	Binding = BindPaymentListPlanningTransactionBasis(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.PlanningTransactionBasis.Get
Function GetPaymentListPlanningTransactionBasis(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentListPlanningTransactionBasis(Parameters).DataPath , _Key);
EndFunction

// PaymentList.PlanningTransactionBasis.Bind
Function BindPaymentListPlanningTransactionBasis(Parameters)
	DataPath = "PaymentList.PlaningTransactionBasis";
	Binding = New Structure();
	Binding.Insert("BankPayment" , "StepPaymentListFillByPTBBankPayment");
	Binding.Insert("BankReceipt" , "StepPaymentListFIllByPTBBankReceipt");
	Binding.Insert("CashPayment" , "StepPaymentListFillByPTBCashPayment");
	Binding.Insert("CashReceipt" , "StepPaymentListFillByPTBCashReceipt");
	Return BindSteps(Undefined, DataPath, Binding, Parameters);
EndFunction

// PaymentList.PlanningTransactionBasis.ChangePlanningTransactionBasisByCurrency.Step
Procedure StepChangePlanningTransactionBasisByCurrency(Parameters, Chain) Export
	Chain.ChangePlanningTransactionBasisByCurrency.Enable = True;
	Chain.ChangePlanningTransactionBasisByCurrency.Setter = "SetPaymentListPlanningTransactionBasis";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangePlanningTransactionBasisByCurrencyOptions();
		Options.Currency = GetCurrency(Parameters);
		Options.PlanningTransactionBasis = GetPaymentListPlanningTransactionBasis(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepChangePlanningTransactionBasisByCurrency";
		Chain.ChangePlanningTransactionBasisByCurrency.Options.Add(Options);
	EndDo;
EndProcedure

// PaymentList.PlanningTransactionBasis.BankPayment.Fill
Procedure FIllPaymentListPlanningTransactionBasis_BankPayment(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Account"     , BindAccount(Parameters));
	ResourceToBinding.Insert("Company"     , BindCompany(Parameters));
	ResourceToBinding.Insert("Currency"    , BindCurrency(Parameters));
	ResourceToBinding.Insert("TotalAmount" , BindPaymentListTotalAmount(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// PaymentList.PlanningTransactionBasis.CashPayment.Fill
Procedure FIllPaymentListPlanningTransactionBasis_CashPayment(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Account"     , BindAccount(Parameters));
	ResourceToBinding.Insert("Company"     , BindCompany(Parameters));
	ResourceToBinding.Insert("Currency"    , BindCurrency(Parameters));
	ResourceToBinding.Insert("Partner"     , BindPaymentListPartner(Parameters));
	ResourceToBinding.Insert("TotalAmount" , BindPaymentListTotalAmount(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// PaymentList.PlanningTransactionBasis.BankReceipt.Fill
Procedure FIllPaymentListPlanningTransactionBasis_BankReceipt(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Account"          , BindAccount(Parameters));
	ResourceToBinding.Insert("Company"          , BindCompany(Parameters));
	ResourceToBinding.Insert("Currency"         , BindCurrency(Parameters));
	ResourceToBinding.Insert("CurrencyExchange" , BindCurrencyExchange(Parameters));
	ResourceToBinding.Insert("TotalAmount"      , BindPaymentListTotalAmount(Parameters));
	ResourceToBinding.Insert("AmountExchange"   , BindPaymentListAmountExchange(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// PaymentList.PlanningTransactionBasis.CashReceipt.Fill
Procedure FIllPaymentListPlanningTransactionBasis_CashReceipt(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Account"          , BindAccount(Parameters));
	ResourceToBinding.Insert("Company"          , BindCompany(Parameters));
	ResourceToBinding.Insert("Currency"         , BindCurrency(Parameters));
	ResourceToBinding.Insert("CurrencyExchange" , BindCurrencyExchange(Parameters));
	ResourceToBinding.Insert("Partner"          , BindPaymentListPartner(Parameters));
	ResourceToBinding.Insert("TotalAmount"      , BindPaymentListTotalAmount(Parameters));
	ResourceToBinding.Insert("AmountExchange"   , BindPaymentListAmountExchange(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// PaymentList.PlanningTransactionBasis.FillByPTBBankPayment.Step
Procedure StepPaymentListFillByPTBBankPayment(Parameters, Chain) Export
	Chain.FillByPTBBankPayment.Enable = True;
	Chain.FillByPTBBankPayment.Setter = "FIllPaymentListPlanningTransactionBasis_BankPayment";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.FillByPTBBankPaymentOptions();
		Options.PlanningTransactionBasis = GetPaymentListPlanningTransactionBasis(Parameters, Row.Key);
		Options.TotalAmount = GetPaymentListTotalAmount(Parameters, Row.Key);
		Options.Company     = GetCompany(Parameters);
		Options.Account     = GetAccount(Parameters);
		Options.Currency    = GetCurrency(Parameters);
		Options.Ref = Parameters.Object.Ref;
		Options.Key = Row.Key;
		Options.StepName = "StepPaymentListFillByPTBBankPayment";
		Chain.FillByPTBBankPayment.Options.Add(Options);
	EndDo;
EndProcedure

// PaymentList.PlanningTransactionBasis.FillByPTBCashPayment.Step
Procedure StepPaymentListFillByPTBCashPayment(Parameters, Chain) Export
	Chain.FillByPTBCashPayment.Enable = True;
	Chain.FillByPTBCashPayment.Setter = "FIllPaymentListPlanningTransactionBasis_CashPayment";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.FillByPTBCashPaymentOptions();
		Options.PlanningTransactionBasis = GetPaymentListPlanningTransactionBasis(Parameters, Row.Key);
		Options.TotalAmount = GetPaymentListTotalAmount(Parameters, Row.Key);
		Options.Partner     = GetPaymentListPartner(Parameters, Row.Key);
		Options.Company     = GetCompany(Parameters);
		Options.Account     = GetAccount(Parameters);
		Options.Currency    = GetCurrency(Parameters);
		Options.Ref = Parameters.Object.Ref;
		Options.Key = Row.Key;
		Options.StepName = "StepPaymentListFillByPTBCashPayment";
		Chain.FillByPTBCashPayment.Options.Add(Options);
	EndDo;
EndProcedure

// PaymentList.PlanningTransactionBasis.FIllByPTBBankReceipt.Step
Procedure StepPaymentListFIllByPTBBankReceipt(Parameters, Chain) Export
	Chain.FIllByPTBBankReceipt.Enable = True;
	Chain.FillByPTBBankReceipt.Setter = "FIllPaymentListPlanningTransactionBasis_BankReceipt";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.FillByPTBBankReceiptOptions();
		Options.PlanningTransactionBasis = GetPaymentListPlanningTransactionBasis(Parameters, Row.Key);
		Options.TotalAmount    = GetPaymentListTotalAmount(Parameters, Row.Key);
		Options.AmountExchange = GetPaymentListAmountExchange(Parameters, Row.Key);
		Options.Company  = GetCompany(Parameters);
		Options.Account  = GetAccount(Parameters);
		Options.Currency = GetCurrency(Parameters);
		Options.CurrencyExchange = GetCurrencyExchange(Parameters);
		Options.Ref = Parameters.Object.Ref;
		Options.Key = Row.Key;
		Options.StepName = "StepPaymentListFIllByPTBBankReceipt";
		Chain.FillByPTBBankReceipt.Options.Add(Options);
	EndDo;
EndProcedure

// PaymentList.PlanningTransactionBasis.FillByPTBCashReceipt.Step
Procedure StepPaymentListFillByPTBCashReceipt(Parameters, Chain) Export
	Chain.FillByPTBCashReceipt.Enable = True;
	Chain.FillByPTBCashReceipt.Setter = "FIllPaymentListPlanningTransactionBasis_CashReceipt";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.FillByPTBCashReceiptOptions();
		Options.PlanningTransactionBasis = GetPaymentListPlanningTransactionBasis(Parameters, Row.Key);
		Options.TotalAmount       = GetPaymentListTotalAmount(Parameters, Row.Key);
		Options.AmountExchange    = GetPaymentListAmountExchange(Parameters, Row.Key);
		Options.Partner           = GetPaymentListPartner(Parameters, Row.Key);
		Options.Company  = GetCompany(Parameters);
		Options.Account  = GetAccount(Parameters);
		Options.Currency = GetCurrency(Parameters);
		Options.CurrencyExchange = GetCurrencyExchange(Parameters);
		Options.Ref = Parameters.Object.Ref;
		Options.Key = Row.Key;
		Options.StepName = "StepPaymentListFillByPTBCashReceipt";
		Chain.FillByPTBCashReceipt.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region PAYMENT_LIST_ORDER

// PaymentList.Order.OnChange
Procedure PaymentListOrderOnChange(Parameters) Export
	Binding = BindPaymentListOrder(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.Order.Set
Procedure SetPaymentListOrder(Parameters, Results) Export
	Binding = BindPaymentListOrder(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.Order.Get
Function GetPaymentListOrder(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentListOrder(Parameters).DataPath , _Key);
EndFunction

// PaymentList.Order.Bind
Function BindPaymentListOrder(Parameters)
	DataPath = "PaymentList.Order";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// PaymentList.Order.ChangeOrderByAgreement.Step
Procedure StepPaymentListChangeOrderByAgreement(Parameters, Chain) Export
	Chain.ChangeOrderByAgreement.Enable = True;
	Chain.ChangeOrderByAgreement.Setter = "SetPaymentListOrder";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeOrderByAgreementOptions();
		Options.Agreement    = GetPaymentListAgreement(Parameters, Row.Key);
		Options.CurrentOrder = GetPaymentListOrder(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepPaymentListChangeOrderByAgreement";
		Chain.ChangeOrderByAgreement.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region PAYMENT_LIST_TAX_RATE

// PaymentList.TaxRate.OnChange
Procedure PaymentListTaxRateOnChange(Parameters) Export
	Binding = BindPaymentListTaxRate(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.TaxRate.Set
Procedure SetPaymentListTaxRate(Parameters, Results) Export
	Binding = BindPaymentListTaxRate(Parameters);
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

// PaymentList.TaxRate.Bind
Function BindPaymentListTaxRate(Parameters)
	DataPath = "PaymentList.";
	Binding = New Structure();
	Return BindSteps("StepPaymentListCalculations_IsTaxRateChanged", DataPath, Binding, Parameters);
EndFunction

// PaymentList.TaxRate.Default.Bind
Function BindDefaultPaymentListTaxRate(Parameters)
	DataPath = "PaymentList.";
	Binding = New Structure();
	Binding.Insert("CashExpense", "StepChangeTaxRate_WithoutAgreement");
	Binding.Insert("CashRevenue", "StepChangeTaxRate_WithoutAgreement");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region PAYMENT_LIST_DONTCALCULATEROW

// PaymentList.DontCalculateRow.OnChange
Procedure PaymentListDontCalculateRowOnChange(Parameters) Export
	Binding = BindPaymentListDontCalculateRow(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.DontCalculateRow.Set
Procedure SetPaymentListDontCalculateRow(Parameters, Results) Export
	Binding = BindPaymentListDontCalculateRow(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.DontCalculateRow.Get
Function GetPaymentListDontCalculateRow(Parameters, _Key)
	Return GetPropertyObject(Parameters, "PaymentList.DontCalculateRow", _Key);
EndFunction

// PaymentList.DontCalculateRow.Bind
Function BindPaymentListDontCalculateRow(Parameters)
	DataPath = "PaymentList.DontCalculateRow";
	Binding = New Structure();
	Return BindSteps("StepPaymentListCalculations_IsDontCalculateRowChanged", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region PAYMENT_LIST_TAX_AMOUNT

// PaymentList.TaxAmount.OnChange
Procedure PaymentListTaxAmountOnChange(Parameters) Export
	Binding = BindPaymentListTaxAmount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.TaxAmount.Set
Procedure SetPaymentListTaxAmount(Parameters, Results) Export
	Binding = BindPaymentListTaxAmount(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.TaxAmount.Get
Function GetPaymentListTaxAmount(Parameters, _Key)
	Return GetPropertyObject(Parameters, "PaymentList.TaxAmount", _Key);
EndFunction

// PaymentList.TaxAmount.Bind
Function BindPaymentListTaxAmount(Parameters)
	DataPath = "PaymentList.TaxAmount";
	Binding = New Structure();
	Steps = "StepPaymentListCalculations_IsTaxAmountChanged,
		|StepPaymentListChangeTaxAmountAsManualAmount";
	Return BindSteps(Steps, DataPath, Binding, Parameters);
EndFunction

// PaymentList.TaxAmount.ChangeTaxAmountAsManualAmount.Step
Procedure StepPaymentListChangeTaxAmountAsManualAmount(Parameters, Chain) Export
	Chain.ChangeTaxAmountAsManualAmount.Enable = True;
	Chain.ChangeTaxAmountAsManualAmount.Setter = "SetPaymentListTaxAmount";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeTaxAmountAsManualAmountOptions();
		Options.TaxAmount = GetPaymentListTaxAmount(Parameters, Row.Key);
		Options.TaxList   = Row.TaxList;
		Options.Key       = Row.Key;
		Options.StepName = "StepPaymentListChangeTaxAmountAsManualAmount";
		Chain.ChangeTaxAmountAsManualAmount.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region PAYMENT_LIST_NET_AMOUNT

// PaymentList.NetAmount.OnChange
Procedure PaymentListNetAmountOnChange(Parameters) Export
	Binding = BindPaymentListNetAmount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.NetAmount.Get
Function GetPaymentListNetAmount(Parameters, _Key)
	Return GetPropertyObject(Parameters, "PaymentList.NetAmount", _Key);
EndFunction

// PaymentList.NetAmount.Bind
Function BindPaymentListNetAmount(Parameters)
	DataPath = "PaymentList.NetAmount";
	Binding = New Structure();
	Steps = "StepPaymentListCalculations_IsNetAmountChanged";
	Return BindSteps(Steps, DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region PAYMENT_LIST_TOTAL_AMOUNT

// PaymentList.TotalAmount.OnChange
Procedure PaymentListTotalAmountOnChange(Parameters) Export
	Binding = BindPaymentListTotalAmount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.TotalAmount.Set
Procedure SetPaymentListTotalAmount(Parameters, Results) Export
	Binding = BindPaymentListTotalAmount(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.TotalAmount.Get
Function GetPaymentListTotalAmount(Parameters, _Key)
	Return GetPropertyObject(Parameters, "PaymentList.TotalAmount", _Key);
EndFunction

// PaymentList.TotalAmount.Bind
Function BindPaymentListTotalAmount(Parameters)
	DataPath = "PaymentList.TotalAmount";
	Binding = New Structure();
	Steps = "StepPaymentListCalculations_IsTotalAmountChanged";
	Return BindSteps(Steps, DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region PAYMENT_LIST_AMOUNT_EXCHANGE

// PaymentList.AmountExchange.Set
Procedure SetPaymentListAmountExchange(Parameters, Results) Export
	Binding = BindPaymentListAmountExchange(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.AmountExchange.Get
Function GetPaymentListAmountExchange(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentListAmountExchange(Parameters).DataPath , _Key);
EndFunction

// PaymentList.AmountExchange.Bind
Function BindPaymentListAmountExchange(Parameters)
	DataPath = "PaymentList.AmountExchange";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region PAYMENT_LIST_CALCULATIONS_NET_TAX_TOTAL

// PaymentList.Calculations.Set
Procedure SetPaymentListCalculations(Parameters, Results) Export
	Binding = BindPaymentListCalculations(Parameters);
	SetterObject(Undefined, "PaymentList.NetAmount"   , Parameters, Results, , "NetAmount");
	SetterObject(Undefined, "PaymentList.TaxAmount"   , Parameters, Results, , "TaxAmount");
	SetterObject(Binding.StepsEnabler, "PaymentList.TotalAmount" , Parameters, Results, , "TotalAmount");
	SetTaxList(Parameters, Results);
EndProcedure

// PaymentList.Calculations.Bind
Function BindPaymentListCalculations(Parameters)
	DataPath = "";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// PaymentList.Calculations.[RecalculationsOnCopy].Step
Procedure StepPaymentListCalculations_RecalculationsOnCopy(Parameters, Chain) Export
	If Parameters.FormIsExists And Parameters.FormParameters.IsCopy Then
		StepPaymentListCalculations(Parameters, Chain, "RecalculationsOnCopy");
	EndIf;
EndProcedure

// PaymentList.Calculations.[IsCopyRow].Step
Procedure StepPaymentListCalculations_IsCopyRow(Parameters, Chain) Export
	StepPaymentListCalculations(Parameters, Chain, "IsCopyRow");
EndProcedure

// PaymentList.Calculations.[IsTaxRateChanged].Step
Procedure StepPaymentListCalculations_IsTaxRateChanged(Parameters, Chain) Export
	StepPaymentListCalculations(Parameters, Chain, "IsTaxRateChanged");
EndProcedure

// PaymentList.Calculations.[IsTaxAmountChanged].Step
Procedure StepPaymentListCalculations_IsTaxAmountChanged(Parameters, Chain) Export
	StepPaymentListCalculations(Parameters, Chain, "IsTaxAmountChanged");
EndProcedure

// PaymentList.Calculations.[IsNetAmountChanged].Step
Procedure StepPaymentListCalculations_IsNetAmountChanged(Parameters, Chain) Export
	StepPaymentListCalculations(Parameters, Chain, "IsNetAmountChanged");
EndProcedure

// PaymentList.Calculations.[IsTotalAmountChanged].Step
Procedure StepPaymentListCalculations_IsTotalAmountChanged(Parameters, Chain) Export
	StepPaymentListCalculations(Parameters, Chain, "IsTotalAmountChanged");
EndProcedure

// PaymentList.Calculations.[IsDontCalculateRowChanged].Step
Procedure StepPaymentListCalculations_IsDontCalculateRowChanged(Parameters, Chain) Export
	StepPaymentListCalculations(Parameters, Chain, "IsDontCalculateRowChanged");
EndProcedure

Procedure StepPaymentListCalculations(Parameters, Chain, WhoIsChanged);
	Chain.Calculations.Enable = True;
	Chain.Calculations.Setter = "SetPaymentListCalculations";
	
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		
		Options     = ModelClientServer_V2.CalculationsOptions();
		Options.Ref = Parameters.Object.Ref;
		
		// need recalculate NetAmount, TotalAmount, TaxAmount
		If     WhoIsChanged = "IsTaxRateChanged" Or WhoIsChanged = "IsCopyRow" Then
			Options.CalculateNetAmount.Enable     = True;
			Options.CalculateTotalAmount.Enable   = True;
			Options.CalculateTaxAmount.Enable     = True;
			
		ElsIf WhoIsChanged = "IsTotalAmountChanged" Or WhoIsChanged = "RecalculationsOnCopy" Then
		//  when TotalAmount is changed taxes need recalculate reverse, will be changed NetAmount
			Options.CalculateTaxAmountReverse.Enable   = True;
			Options.CalculateNetAmountAsTotalAmountMinusTaxAmount.Enable   = True;
			
		ElsIf WhoIsChanged = "IsTaxAmountChanged" Then
		// enable use ManualAmount when calculating TaxAmount
			Options.TaxOptions.UseManualAmount = True;
			
			Options.CalculateNetAmount.Enable   = True;
			Options.CalculateTotalAmount.Enable = True;
			Options.CalculateTaxAmount.Enable   = True;
			
		ElsIf WhoIsChanged = "IsNetAmountChanged" Or WhoIsChanged = "IsDontCalculateRowChanged" Then
			Options.CalculateTaxAmountByNetAmount.Enable   = True;
			Options.CalculateTotalAmountByNetAmount.Enable = True;
		ElsIf WhoIsChanged = "IsDontCalculateRowChanged" Then
			Options.CalculateTaxAmountByNetAmount.Enable   = True;
			Options.CalculateTotalAmountByNetAmount.Enable = True;
		Else
			Raise StrTemplate("Unsupported [WhoIsChanged] = %1", WhoIsChanged);
		EndIf;
		
		If StrSplit(Parameters.ObjectMetadataInfo.Tables.PaymentList.Columns,",").Find("DontCalculateRow") <> Undefined Then
			Options.AmountOptions.DontCalculateRow = GetPaymentListDontCalculateRow(Parameters, Row.Key);
		Else
			Options.AmountOptions.DontCalculateRow = False;
		EndIf;
		
		Options.AmountOptions.NetAmount        = GetPaymentListNetAmount(Parameters, Row.Key);
		Options.AmountOptions.TaxAmount        = GetPaymentListTaxAmount(Parameters, Row.Key);
		Options.AmountOptions.TotalAmount      = GetPaymentListTotalAmount(Parameters, Row.Key);
		
		Options.TaxOptions.ArrayOfTaxInfo   = Parameters.ArrayOfTaxInfo;
		Options.TaxOptions.TaxRates         = GetTaxRate(Parameters, Row);
		Options.TaxOptions.TaxList          = Row.TaxList;
		
		Options.Key = Row.Key;
		Options.StepName = "StepPaymentListCalculations" + WhoIsChanged;
		Chain.Calculations.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#EndRegion

#Region ITEM_LIST

#Region ITEM_LIST_ITEM

// ItemList.Item.OnChange
Procedure ItemListItemOnChange(Parameters) Export
	Binding = BindItemListItem(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.Item.Set
Procedure SetItemListItem(Parameters, Results) Export
	Binding = BindItemListItem(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.Item.Get
Function ItemListItemGet(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindItemListItem(Parameters).DataPath, _Key);
EndFunction

// ItemList.Item.Bind
Function BindItemListItem(Parameters)
	DataPath = "ItemList.Item";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation"     , "StepItemListChangeItemKeyByItem");
	Binding.Insert("GoodsReceipt"             , "StepItemListChangeItemKeyByItem");
	Binding.Insert("StockAdjustmentAsSurplus" , "StepItemListChangeItemKeyByItem");
	Binding.Insert("StockAdjustmentAsWriteOff", "StepItemListChangeItemKeyByItem");
	Binding.Insert("SalesInvoice"             , "StepItemListChangeItemKeyByItem");
	Binding.Insert("PurchaseInvoice"          , "StepItemListChangeItemKeyByItem");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region ITEM_LIST_ITEMKEY

// ItemList.ItemKey.OnChange
Procedure ItemListItemKeyOnChange(Parameters) Export
	AddViewNotify("OnSetItemListItemKey", Parameters);
	Binding = BindItemListItemKey(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.ItemKey.Set
Procedure SetItemListItemKey(Parameters, Results) Export
	Binding = BindItemListItemKey(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetItemListItemKey");
EndProcedure

// ItemList.ItemKey.Get
Function GetItemListItemKey(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindItemListItemKey(Parameters).DataPath, _Key);
EndFunction

// ItemList.ItemKey.Bind
Function BindItemListItemKey(Parameters)
	DataPath = "ItemList.ItemKey";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation",
		"StepExtractDataItemKeysWithSerialLotNumbers,
		|StepChangeUnitByItemKey");
		
	Binding.Insert("GoodsReceipt",
		"StepExtractDataItemKeysWithSerialLotNumbers,
		|StepChangeUnitByItemKey");
		
	Binding.Insert("StockAdjustmentAsSurplus",
		"StepExtractDataItemKeysWithSerialLotNumbers,
		|StepChangeUnitByItemKey");
		
	Binding.Insert("StockAdjustmentAsWriteOff",
		"StepExtractDataItemKeysWithSerialLotNumbers,
		|StepChangeUnitByItemKey");
		
	Binding.Insert("SalesInvoice",
		"StepItemListChangeUseShipmentConfirmationByStore,
		|StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType,
		|StepChangeTaxRate_AgreementInHeader,
		|StepExtractDataItemKeysWithSerialLotNumbers,
		|StepChangeUnitByItemKey");
	
	Binding.Insert("PurchaseInvoice",
		"StepItemListChangeUseGoodsReceiptByStore,
		|StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType,
		|StepChangeTaxRate_AgreementInHeader,
		|StepExtractDataItemKeysWithSerialLotNumbers,
		|StepChangeUnitByItemKey");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// ItemList.ItemKey.ChangeItemKeyByItem.Step
Procedure StepItemListChangeItemKeyByItem(Parameters, Chain) Export
	Chain.ChangeItemKeyByItem.Enable = True;
	Chain.ChangeItemKeyByItem.Setter = "SetItemListItemKey";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeItemKeyByItemOptions();
		Options.Item    = ItemListItemGet(Parameters, Row.Key);
		Options.ItemKey = GetItemListItemKey(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepItemListChangeItemKeyByItem";
		Chain.ChangeItemKeyByItem.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_LIST_UNIT

// ItemList.Unit.OnChange
Procedure ItemListUnitOnChange(Parameters) Export
	Binding = BindItemListUnit(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.Unit.Set
Procedure SetItemListUnit(Parameters, Results) Export
	Binding = BindItemListUnit(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.Unit.Get
Function GetItemListUnit(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindItemListUnit(Parameters).DataPath, _Key);
EndFunction

// ItemList.Unit.Bind
Function BindItemListUnit(Parameters)
	DataPath = "ItemList.Unit";
	Binding = New Structure();
	Return BindSteps("StepItemListCalculateQuantityInBaseUnit", DataPath, Binding, Parameters);
EndFunction

// ItemList.Unit.ChangeUnitByItemKey.Step
Procedure StepChangeUnitByItemKey(Parameters, Chain) Export
	Chain.ChangeUnitByItemKey.Enable = True;
	Chain.ChangeUnitByItemKey.Setter = "SetItemListUnit";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeUnitByItemKeyOptions();
		Options.ItemKey = GetItemListItemKey(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepChangeUnitByItemKey";
		Chain.ChangeUnitByItemKey.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_LIST_DELIVERY_DATE

// ItemList.DeliveryDate.OnChange
Procedure ItemListDeliveryDateOnChange(Parameters) Export
	ProceedPropertyBeforeChange_List(Parameters);
	Binding = BindItemListDeliveryDate(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.DeliveryDate.Set
Procedure SetItemListDeliveryDate(Parameters, Results) Export
	Binding = BindItemListDeliveryDate(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.DeliveryDate.Get
Function GetItemListDeliveryDate(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindItemListDeliveryDate(Parameters).DataPath, _Key);
EndFunction

// ItemList.DeliveryDate.Default.Bind
Function BindDefaultItemListDeliveryDate(Parameters)
	DataPath = "ItemList.DeliveryDate";
	Binding = New Structure();
	Binding.Insert("SalesInvoice"   , "StepItemListDefaultDeliveryDateInList");
	Binding.Insert("PurchaseInvoice", "StepItemListDefaultDeliveryDateInList");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// ItemList.DeliveryDate.Bind
Function BindItemListDeliveryDate(Parameters)
	DataPath = "ItemList.DeliveryDate";
	Binding = New Structure();
	Binding.Insert("SalesInvoice"   , "StepChangeDeliveryDateInHeaderByDeliveryDateInList");
	Binding.Insert("PurchaseInvoice", "StepChangeDeliveryDateInHeaderByDeliveryDateInList");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// ItemList.DeliveryDate.FillDeliveryDateInList.Step
Procedure StepItemListFillDeliveryDateInList(Parameters, Chain) Export
	Chain.FillDeliveryDateInList.Enable = True;
	Chain.FillDeliveryDateInList.Setter = "SetItemListDeliveryDate";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.FillDeliveryDateInListOptions();
		Options.DeliveryDate       = GetDeliveryDate(Parameters);
		Options.DeliveryDateInList = GetItemListDeliveryDate(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepItemListFillDeliveryDateInList";
		Chain.FillDeliveryDateInList.Options.Add(Options);
	EndDo;
EndProcedure

// ItemList.DeliveryDate.DefaultDeliveryDateInList.Step
Procedure StepItemListDefaultDeliveryDateInList(Parameters, Chain) Export
	Chain.DefaultDeliveryDateInList.Enable = True;
	Chain.DefaultDeliveryDateInList.Setter = "SetItemListDeliveryDate";
	Options = ModelClientServer_V2.DefaultDeliveryDateInListOptions();
	NewRow = Parameters.RowFilledByUserSettings;
	Options.DeliveryDateInList   = GetItemListDeliveryDate(Parameters, NewRow.Key);
	Options.DeliveryDateInHeader = GetDeliveryDate(Parameters);
	Options.Date                 = GetDate(Parameters);
	Options.Agreement            = GetAgreement(Parameters);
	Options.Key = NewRow.Key;
	Options.StepName = "StepItemListDefaultDeliveryDateInList";
	Chain.DefaultDeliveryDateInList.Options.Add(Options);
EndProcedure

#EndRegion

#Region ITEM_LIST_STORE

// ItemList.Store.OnChange
Procedure ItemListStoreOnChange(Parameters) Export
	ProceedPropertyBeforeChange_List(Parameters);
	Binding = BindItemListStore(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.Store.Set
Procedure SetItemListStore(Parameters, Results) Export
	Binding = BindItemListStore(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.Store.Get
Function GetItemListStore(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindItemListStore(Parameters).DataPath, _Key);
EndFunction

// ItemList.Store.Default.Bind
Function BindDefaultItemListStore(Parameters)
	DataPath = "ItemList.Store";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation", "StepItemListDefaultStoreInList_WithoutAgreement");
	Binding.Insert("GoodsReceipt"        , "StepItemListDefaultStoreInList_WithoutAgreement");

	Binding.Insert("SalesInvoice"   , "StepItemListDefaultStoreInList_AgreementInHeader");
	Binding.Insert("PurchaseInvoice", "StepItemListDefaultStoreInList_AgreementInHeader");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// ItemList.Store.Bind
Function BindItemListStore(Parameters)
	DataPath = "ItemList.Store";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation", "StepChangeStoreInHeaderByStoresInList");
	Binding.Insert("GoodsReceipt"        , "StepChangeStoreInHeaderByStoresInList");

	Binding.Insert("SalesInvoice",
		"StepItemListChangeUseShipmentConfirmationByStore,
		|StepExtractDataItemKeyIsService,
		|StepChangeStoreInHeaderByStoresInList");
	
	Binding.Insert("PurchaseInvoice",
		"StepItemListChangeUseGoodsReceiptByStore,
		|StepExtractDataItemKeyIsService,
		|StepChangeStoreInHeaderByStoresInList");
	
	Return BindSteps(Undefined, DataPath, Binding, Parameters);
EndFunction

// ItemList.Store.FillStoresInList.Step
Procedure StepItemListFillStoresInList(Parameters, Chain) Export
	Chain.FillStoresInList.Enable = True;
	Chain.FillStoresInList.Setter = "SetItemListStore";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.FillStoresInListOptions();
		Options.Store        = GetStore(Parameters);
		Options.StoreInList  = GetItemListStore(Parameters, Row.Key);
		Options.IsUserChange = IsUserChange(Parameters);
		Options.Key = Row.Key;
		Options.StepName = "StepItemListFillStoresInList";
		Chain.FillStoresInList.Options.Add(Options);
	EndDo;
EndProcedure

// ItemList.Store.DefaultStoreInList.[AgreementInHeader].Step
Procedure StepItemListDefaultStoreInList_AgreementInHeader(Parameters, Chain) Export
	StepItemListDefaultStoreInList(Parameters, Chain, True);
EndProcedure

// ItemList.Store.DefaultStoreInList.[WithoutAgreement].Step
Procedure StepItemListDefaultStoreInList_WithoutAgreement(Parameters, Chain) Export
	StepItemListDefaultStoreInList(Parameters, Chain, False);
EndProcedure

// ItemList.Store.DefaultStoreInList.Step
Procedure StepItemListDefaultStoreInList(Parameters, Chain, AgreementInHeader)
	Chain.DefaultStoreInList.Enable = True;
	Chain.DefaultStoreInList.Setter = "SetItemListStore";
	Options = ModelClientServer_V2.DefaultStoreInListOptions();
	NewRow = Parameters.RowFilledByUserSettings;
	Options.StoreFromUserSettings = NewRow.Store;
	If AgreementInHeader Then
		Options.Agreement = GetAgreement(Parameters);
	EndIf;
	Options.StoreInList   = GetItemListStore(Parameters, NewRow.Key);
	Options.StoreInHeader = GetStore(Parameters);
	Options.Key = NewRow.Key;
	Options.StepName = "StepItemListDefaultStoreInList";
	Chain.DefaultStoreInList.Options.Add(Options);
EndProcedure

#EndRegion

#Region ITEM_LIST_USE_SHIPMENT_CONFIRMATION

// ItemList.UseShipmentConfirmation.Set
Procedure SetItemListUseShipmentConfirmation(Parameters, Results) Export
	SetterObject(Undefined, "ItemList.UseShipmentConfirmation", Parameters, Results);
EndProcedure

// ItemList.UseShipmentConfirmation.ChangeUseShipmentConfirmationByStore.Step
Procedure StepItemListChangeUseShipmentConfirmationByStore(Parameters, Chain) Export
	Chain.ChangeUseShipmentConfirmationByStore.Enable = True;
	Chain.ChangeUseShipmentConfirmationByStore.Setter = "SetItemListUseShipmentConfirmation";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeUseShipmentConfirmationByStoreOptions();
		Options.Store   = GetItemListStore(Parameters, Row.Key);
		Options.ItemKey = GetItemListItemKey(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepItemListChangeUseShipmentConfirmationByStore";
		Chain.ChangeUseShipmentConfirmationByStore.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_LIST_USE_GOODS_RECEIPT

// ItemList.UseGoodsReceipt.Set
Procedure SetItemListUseGoodsReceipt(Parameters, Results) Export
	SetterObject(Undefined, "ItemList.UseGoodsReceipt", Parameters, Results);
EndProcedure

// ItemList.UseGoodsReceipt.ChangeUseGoodsReceiptByStore.Step
Procedure StepItemListChangeUseGoodsReceiptByStore(Parameters, Chain) Export
	Chain.ChangeUseGoodsReceiptByStore.Enable = True;
	Chain.ChangeUseGoodsReceiptByStore.Setter = "SetItemListUseGoodsReceipt";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeUseGoodsReceiptByStoreOptions();
		Options.Store   = GetItemListStore(Parameters, Row.Key);
		Options.ItemKey = GetItemListItemKey(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepChangeUseGoodsReceiptByStore";
		Chain.ChangeUseGoodsReceiptByStore.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_LIST_PRICE_TYPE

// ItemList.PriceType.OnChange
Procedure ItemListPriceTypeOnChange(Parameters) Export
	Binding = BindItemListPriceType(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.PriceType.Set
Procedure SetItemListPriceType(Parameters, Results) Export
	Binding = BindItemListPriceType(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.PriceType.Get
Function GetItemListPriceType(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindItemListPriceType(Parameters).DataPath, _Key);
EndFunction

// ItemList.PriceType.Bind
Function BindItemListPriceType(Parameters)
	DataPath = "ItemList.PriceType";
	Binding = New Structure();
	Return BindSteps("StepItemListChangePriceByPriceType", DataPath, Binding, Parameters);
EndFunction

// ItemList.PriceType.ChangePriceTypeByAgreement.Step
Procedure StepItemListChangePriceTypeByAgreement(Parameters, Chain) Export
	Chain.ChangePriceTypeByAgreement.Enable = True;
	Chain.ChangePriceTypeByAgreement.Setter = "SetItemListPriceType";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangePriceTypeByAgreementOptions();
		Options.Agreement = GetAgreement(Parameters);
		Options.Key = Row.Key;
		Options.StepName = "StepItemListChangePriceTypeByAgreement";
		Chain.ChangePriceTypeByAgreement.Options.Add(Options);
	EndDo;
EndProcedure

// ItemList.PriceType.ChangePriceTypeAsManual.[IsUserChange].Step
Procedure StepItemListChangePriceTypeAsManual_IsUserChange(Parameters, Chain) Export
	StepItemListChangePriceTypeAsManual(Parameters, Chain, True, False);
EndProcedure

// ItemList.PriceType.ChangePriceTypeAsManual.[IsTotalAmountChange].Step
Procedure StepItemListChangePriceTypeAsManual_IsTotalAmountChange(Parameters, Chain) Export
	StepItemListChangePriceTypeAsManual(Parameters, Chain, False, True);
EndProcedure

// ItemList.PriceType.ChangePriceTypeAsManual.Step
Procedure StepItemListChangePriceTypeAsManual(Parameters, Chain, IsUserChange, IsTotalAmountChange)
	Chain.ChangePriceTypeAsManual.Enable = True;
	Chain.ChangePriceTypeAsManual.Setter = "SetItemListPriceType";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangePriceTypeAsManualOptions();
		Options.CurrentPriceType = GetItemListPriceType(Parameters, Row.Key);
		If IsUserChange Then
			Options.IsUserChange = IsUserChange(Parameters);
		ElsIf IsTotalAmountChange Then
			Options.IsTotalAmountChange = True;
			Options.DontCalculateRow = GetItemListDontCalculateRow(Parameters, Row.Key);
		EndIf;
		Options.Key = Row.Key;
		Options.StepName = "StepItemListChangePriceTypeAsManual";
		Chain.ChangePriceTypeAsManual.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_LIST_PRICE

// ItemList.Price.OnChange
Procedure ItemListPriceOnChange(Parameters) Export
	Binding = BindItemListPrice(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.Price.Set
Procedure SetItemListPrice(Parameters, Results) Export
	Binding = BindItemListPrice(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.Price.Get
Function GetItemListPrice(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindItemListPrice(Parameters).DataPath, _Key);
EndFunction

// ItemList.Price.Bind
Function BindItemListPrice(Parameters)
	DataPath = "ItemList.Price";
	Binding = New Structure();
	Binding.Insert("SalesInvoice",
		"StepItemListChangePriceTypeAsManual_IsUserChange,
		|StepItemListCalculations_IsPriceChanged");

	Binding.Insert("PurchaseInvoice",
		"StepItemListChangePriceTypeAsManual_IsUserChange,
		|StepItemListCalculations_IsPriceChanged");
		
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// ItemList.Price.ChangePriceByPriceType.Step
Procedure StepItemListChangePriceByPriceType(Parameters, Chain) Export
	Chain.ChangePriceByPriceType.Enable = True;
	Chain.ChangePriceByPriceType.Setter = "SetItemListPrice";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangePriceByPriceTypeOptions();
		Options.Ref          = Parameters.Object.Ref;
		Options.Date         = GetDate(Parameters);
		Options.CurrentPrice = GetItemListPrice(Parameters, Row.Key);
		Options.PriceType    = GetItemListPriceType(Parameters, Row.Key);
		Options.ItemKey      = GetItemListItemKey(Parameters, Row.Key);
		Options.Unit         = GetItemListUnit(Parameters, Row.Key);
		Options.Key          = Row.Key;
		Options.StepName = "StepItemListChangePriceByPriceType";
		Options.DontExecuteIfExecutedBefore = True;
		Chain.ChangePriceByPriceType.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_LIST_DONTCALCULATEROW

// ItemList.DontCalculateRow.OnChange
Procedure ItemListDontCalculateRowOnChange(Parameters) Export
	Binding = BindItemListDontCalculateRow(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.DontCalculateRow.Set
Procedure SetItemListDontCalculateRow(Parameters, Results) Export
	Binding = BindItemListDontCalculateRow(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.DontCalculateRow.Get
Function GetItemListDontCalculateRow(Parameters, _Key)
	Return GetPropertyObject(Parameters, "ItemList.DontCalculateRow", _Key);
EndFunction

// ItemList.DontCalculateRow.Bind
Function BindItemListDontCalculateRow(Parameters)
	DataPath = "ItemList.DontCalculateRow";
	Binding = New Structure();
	Return BindSteps("StepItemListCalculations_IsDontCalculateRowChanged", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region ITEM_LIST_QUANTITY

// ItemList.Quantity.OnChange
Procedure ItemListQuantityOnChange(Parameters) Export
	AddViewNotify("OnSetItemListQuantityNotify", Parameters);
	Binding = BindItemListQuantity(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.Quantity.Set
Procedure SetItemListQuantity(Parameters, Results) Export
	Binding = BindItemListQuantity(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetItemListQuantityNotify");
EndProcedure

// ItemList.Quantity.Get
Function GetItemListQuantity(Parameters, _Key)
	Return GetPropertyObject(Parameters, "ItemList.Quantity", _Key);
EndFunction

// ItemList.Quantity.Default.Bind
Function BindDefaultItemListQuantity(Parameters)
	DataPath = "ItemList.Quantity";
	Binding = New Structure();
	Return BindSteps("StepItemListDefaultQuantityInList", DataPath, Binding, Parameters);
EndFunction

// ItemList.Quantity.Bind
Function BindItemListQuantity(Parameters)
	DataPath = "ItemList.Quantity";
	Binding = New Structure();
	Return BindSteps("StepItemListCalculateQuantityInBaseUnit", DataPath, Binding, Parameters);
EndFunction

// ItemList.Quantity.DefaultQuantityInList.Step
Procedure StepItemListDefaultQuantityInList(Parameters, Chain) Export
	Chain.DefaultQuantityInList.Enable = True;
	Chain.DefaultQuantityInList.Setter = "SetItemListQuantity";
	Options = ModelClientServer_V2.DefaultQuantityInListOptions();
	NewRow = Parameters.RowFilledByUserSettings;
	Options.CurrentQuantity = GetItemListQuantity(Parameters, NewRow.Key);
	Options.Key = NewRow.Key;
	Chain.DefaultQuantityInList.Options.Add(Options);
EndProcedure

#EndRegion

#Region ITEM_LIST_QUANTITY_IN_BASE_UNIT

// ItemList.QuantityInBaseUnit.Set
Procedure SetItemListQuantityInBaseUnit(Parameters, Results) Export
	Binding = BindItemListQuantityInBaseUnit(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath , Parameters, Results,
		"OnSetItemListQuantityInBaseUnitNotify", "QuantityInBaseUnit");
EndProcedure

Function GetItemListQuantityInBaseUnit(Parameters, _Key)
	Return GetPropertyObject(Parameters, "ItemList.QuantityInBaseUnit" , _Key);
EndFunction

// ItemList.QuantityInBaseUnit.Bind
Function BindItemListQuantityInBaseUnit(Parameters)
	DataPath = "ItemList.QuantityInBaseUnit";
	Binding = New Structure();
	Binding.Insert("SalesInvoice"    , "StepItemListCalculations_IsQuantityInBaseUnitChanged");
	Binding.Insert("PurchaseInvoice" , "StepItemListCalculations_IsQuantityInBaseUnitChanged");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// ItemList.QuantityInBaseUnit.CalculateQuantityInBaseUnit.Step
Procedure StepItemListCalculateQuantityInBaseUnit(Parameters, Chain) Export
	Chain.Calculations.Enable = True;
	Chain.Calculations.Setter = "SetItemListQuantityInBaseUnit";
	For Each Row In GetRows(Parameters, "ItemList") Do
		Options     = ModelClientServer_V2.CalculationsOptions();
		Options.Ref = Parameters.Object.Ref;
		Options.CalculateQuantityInBaseUnit.Enable   = True;
		Options.QuantityOptions.ItemKey = GetItemListItemKey(Parameters, Row.Key);
		Options.QuantityOptions.Unit    = GetItemListUnit(Parameters, Row.Key);
		Options.QuantityOptions.Quantity           = GetItemListQuantity(Parameters, Row.Key);
		Options.QuantityOptions.QuantityInBaseUnit = GetItemListQuantityInBaseUnit(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepItemListCalculateQuantityInBaseUnit";
		Chain.Calculations.Options.Add(Options);
	EndDo;	
EndProcedure

#EndRegion

#Region ITEM_LIST_TAX_RATE

// ItemList.TaxRate.OnChange
Procedure ItemListTaxRateOnChange(Parameters) Export
	Binding = BindItemListTaxRate(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.TaxRate.Set
Procedure SetItemListTaxRate(Parameters, Results) Export
	Binding = BindItemListTaxRate(Parameters);
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

// ItemList.TaxRate.Bind
Function BindItemListTaxRate(Parameters)
	DataPath = "ItemList.";
	Binding = New Structure();
	Return BindSteps("StepItemListCalculations_IsTaxRateChanged", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region ITEM_LIST_TAX_AMOUNT

// ItemList.TaxAmount.OnChange
Procedure ItemListTaxAmountOnChange(Parameters) Export
	Binding = BindItemListTaxAmount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.TaxAmount.Set
Procedure SetItemListTaxAmount(Parameters, Results) Export
	Binding = BindItemListTaxAmount(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.TaxAmount.Get
Function GetItemListTaxAmount(Parameters, _Key)
	Return GetPropertyObject(Parameters, "ItemList.TaxAmount", _Key);
EndFunction

// ItemList.TaxAmount.Bind
Function BindItemListTaxAmount(Parameters)
	DataPath = "ItemList.TaxAmount";
	Binding = New Structure();
	Binding.Insert("SalesInvoice", 
		"StepItemListCalculations_IsTaxAmountChanged,
		|StepItemListChangeTaxAmountAsManualAmount");

	Binding.Insert("PurchaseInvoice", 
		"StepItemListCalculations_IsTaxAmountChanged,
		|StepItemListChangeTaxAmountAsManualAmount");
		
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// ItemList.TaxAmount.ChangeTaxAmountAsManualAmount.Step
Procedure StepItemListChangeTaxAmountAsManualAmount(Parameters, Chain) Export
	Chain.ChangeTaxAmountAsManualAmount.Enable = True;
	Chain.ChangeTaxAmountAsManualAmount.Setter = "SetItemListTaxAmount";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeTaxAmountAsManualAmountOptions();
		Options.TaxAmount = GetItemListTaxAmount(Parameters, Row.Key);
		Options.TaxList   = Row.TaxList;
		Options.Key       = Row.Key;
		Chain.ChangeTaxAmountAsManualAmount.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_LIST_OFFERS_AMOUNT

// ItemList.OffersAmount.OnChange
Procedure ItemListOffersAmountOnChange(Parameters) Export
	Binding = BindItemListOffersAmount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.OffersAmount.Get
Function GetItemListOffersAmount(Parameters, _Key)
	Return GetPropertyObject(Parameters, "ItemList.OffersAmount" , _Key);
ENdFunction

// ItemList.OffersAmount.Bind
Function BindItemListOffersAmount(Parameters)
	DataPath = "ItemList.OffersAmount";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region ITEM_LIST_NET_AMOUNT

// ItemList.NetAmount.OnChange
Procedure ItemListNetAmountOnChange(Parameters) Export
	Binding = BindItemListNetAmount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.NetAmount.Get
Function GetItemListNetAmount(Parameters, _Key)
	Return GetPropertyObject(Parameters, "ItemList.NetAmount" , _Key);
ENdFunction

// ItemList.NetAmount.Bind
Function BindItemListNetAmount(Parameters)
	DataPath = "ItemList.OffersAmount";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region ITEM_LIST_TOTAL_AMOUNT

// ItemList.TotalAmount.OnChange
Procedure ItemListTotalAmountOnChange(Parameters) Export
	Binding = BindItemListTotalAmount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.TotalAmount.Get
Function GetItemListTotalAmount(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindItemListTotalAmount(Parameters).DataPath , _Key);
EndFunction

// ItemList.TotalAmount.Bind
Function BindItemListTotalAmount(Parameters)
	DataPath = "ItemList.TotalAmount";
	Binding = New Structure();
	Binding.Insert("SalesInvoice",
		"StepItemListChangePriceTypeAsManual_IsTotalAmountChange,
		|StepItemListCalculations_IsTotalAmountChanged");

	Binding.Insert("PurchaseInvoice",
		"StepItemListChangePriceTypeAsManual_IsTotalAmountChange,
		|StepItemListCalculations_IsTotalAmountChanged");
		
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

#EndRegion

#Region ITEM_LIST_CALCULATIONS_NET_OFFERS_TAX_TOTAL

// ItemList.Calculations.Set
Procedure SetItemListCalculations(Parameters, Results) Export
	Binding = BindItemListCalculations(Parameters);
	SetterObject(Undefined, "ItemList.NetAmount"   , Parameters, Results, , "NetAmount");
	SetterObject(Undefined, "ItemList.TaxAmount"   , Parameters, Results, , "TaxAmount");
	SetterObject(Undefined, "ItemList.OffersAmount", Parameters, Results, , "OffersAmount");
	SetterObject(Undefined, "ItemList.Price"       , Parameters, Results, , "Price");
	SetterObject(Binding.StepsEnabler, "ItemList.TotalAmount" , Parameters, Results, , "TotalAmount");
	SetTaxList(Parameters, Results);
EndProcedure

// ItemList.Calculations.Bind
Function BindItemListCalculations(Parameters)
	DataPath = "";
	Binding = New Structure();
	Binding.Insert("SalesInvoice"    , "StepUpdatePaymentTerms");
	Binding.Insert("PurchaseInvoice" , "StepUpdatePaymentTerms");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters);
EndFunction

// ItemList.Calculations.[RecalculationsOnCopy].Step
Procedure StepItemListCalculations_RecalculationsOnCopy(Parameters, Chain) Export
	If Parameters.FormIsExists And Parameters.FormParameters.IsCopy Then
		StepItemListCalculations(Parameters, Chain, "RecalculationsOnCopy");
	EndIf;
EndProcedure

// ItemList.Calculations.[IsCopyRow].Step
Procedure StepItemListCalculations_IsCopyRow(Parameters, Chain) Export
	StepItemListCalculations(Parameters, Chain, "IsCopyRow");
EndProcedure

// ItemList.Calculations.[RecalculationsAfterQuestionToUser].Step
Procedure StepItemListCalculations_RecalculationsAfterQuestionToUser(Parameters, Chain) Export
	StepItemListCalculations(Parameters, Chain, "RecalculationsAfterQuestionToUser");
EndProcedure

// ItemList.Calculations.[IsPriceIncludeTaxChanged].Step
Procedure StepItemListCalculations_IsPriceIncludeTaxChanged(Parameters, Chain) Export
	StepItemListCalculations(Parameters, Chain, "IsPriceIncludeTaxChanged");
EndProcedure

// ItemList.Calculations.[IsOffersChanged].Step
Procedure StepItemListCalculations_IsOffersChanged(Parameters, Chain) Export
	StepItemListCalculations(Parameters, Chain, "IsOffersChanged");
EndProcedure

// ItemList.Calculations.[IsPriceChanged].Step
Procedure StepItemListCalculations_IsPriceChanged(Parameters, Chain) Export
	StepItemListCalculations(Parameters, Chain, "IsPriceChanged");
EndProcedure

// ItemList.Calculations.[IsTotalAmountChanged].Step
Procedure StepItemListCalculations_IsTotalAmountChanged(Parameters, Chain) Export
	StepItemListCalculations(Parameters, Chain, "IsTotalAmountChanged");
EndProcedure

// ItemList.Calculations.[IsDontCalculateRowChanged].Step
Procedure StepItemListCalculations_IsDontCalculateRowChanged(Parameters, Chain) Export
	StepItemListCalculations(Parameters, Chain, "IsDontCalculateRowChanged");
EndProcedure

// ItemList.Calculations.[IsQuantityInBaseUnitChanged].Step
Procedure StepItemListCalculations_IsQuantityInBaseUnitChanged(Parameters, Chain) Export
	StepItemListCalculations(Parameters, Chain, "IsQuantityInBaseUnitChanged");
EndProcedure

// ItemList.Calculations.[IsTaxRateChanged].Step
Procedure StepItemListCalculations_IsTaxRateChanged(Parameters, Chain) Export
	StepItemListCalculations(Parameters, Chain, "IsTaxRateChanged");
EndProcedure

// ItemList.Calculations.[IsTaxAmountChanged].Step
Procedure StepItemListCalculations_IsTaxAmountChanged(Parameters, Chain) Export
	StepItemListCalculations(Parameters, Chain, "IsTaxAmountChanged");
EndProcedure

Procedure StepItemListCalculations(Parameters, Chain, WhoIsChanged)
	Chain.Calculations.Enable = True;
	Chain.Calculations.Setter = "SetItemListCalculations";
	
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		
		Options     = ModelClientServer_V2.CalculationsOptions();
		Options.Ref = Parameters.Object.Ref;
		
		// need recalculate NetAmount, TotalAmount, TaxAmount, OffersAmount
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
		// when TotalAmount is changed taxes need recalculate reverse, will be changed NetAmount and Price
			
			//Options.CalculateTaxAmountReverse.Enable   = True;
			//Options.CalculateNetAmountAsTotalAmountMinusTaxAmount.Enable   = True;
			Options.CalculateTaxAmount.Enable     = True;
			Options.CalculateNetAmount.Enable     = True;
			
			Options.CalculatePriceByTotalAmount.Enable = True;
		ElsIf WhoIsChanged = "IsTaxAmountChanged" Then
		// enable use ManualAmount when calculating TaxAmount
			Options.TaxOptions.UseManualAmount = True;
			
			Options.CalculateNetAmount.Enable   = True;
			Options.CalculateTotalAmount.Enable = True;
			Options.CalculateTaxAmount.Enable   = True;
		Else
			Raise StrTemplate("Unsupported [WhoIsChanged] = %1", WhoIsChanged);
		EndIf;
		
		Options.AmountOptions.DontCalculateRow = GetItemListDontCalculateRow(Parameters, Row.Key);
		
		Options.AmountOptions.NetAmount        = GetItemListNetAmount(Parameters, Row.Key);
		Options.AmountOptions.OffersAmount     = GetItemListOffersAmount(Parameters, Row.Key);
		Options.AmountOptions.TaxAmount        = GetItemListTaxAmount(Parameters, Row.Key);
		Options.AmountOptions.TotalAmount      = GetItemListTotalAmount(Parameters, Row.Key);
		
		Options.PriceOptions.Price              = GetItemListPrice(Parameters, Row.Key);
		Options.PriceOptions.PriceType          = GetItemListPriceType(Parameters, Row.Key);
		Options.PriceOptions.Quantity           = GetItemListQuantity(Parameters, Row.Key);
		Options.PriceOptions.QuantityInBaseUnit = GetItemListQuantityInBaseUnit(Parameters, Row.Key);
		
		Options.TaxOptions.PriceIncludeTax  = GetPriceIncludeTax(Parameters);
		Options.TaxOptions.ArrayOfTaxInfo   = Parameters.ArrayOfTaxInfo;
		Options.TaxOptions.TaxRates         = GetTaxRate(Parameters, Row);
		Options.TaxOptions.TaxList          = Row.TaxList;
		Options.TaxOptions.IsAlreadyCalculated = Row.TaxIsAlreadyCalculated;
		
		Options.OffersOptions.SpecialOffers = Row.SpecialOffers;
		
		Options.Key = Row.Key;
		Options.StepName = "StepItemListCalculations";
		Chain.Calculations.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#EndRegion

// called when all chain steps is complete
Procedure OnChainComplete(Parameters) Export
	#IF Client THEN
		// on client need ask user, do not transfer from cache to object
		Execute StrTemplate("%1.OnChainComplete(Parameters);", Parameters.ViewClientModuleName);
	#ENDIF
	
	#IF Server THEN
		// on server transfer from cache to object
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
	
	#IF Client THEN
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

// move changes from Cache to Object form CacheForm to Form
Procedure _CommitChainChanges(Cache, Source)
	For Each Property In Cache Do
		PropertyName  = Property.Key;
		PropertyValue = Property.Value;
		If Upper(PropertyName) = Upper("TaxList") Then
			// tabular part Taxex moved transferred completely
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
		
		ElsIf TypeOf(PropertyValue) = Type("Array") Then // it is tabular part
			IsRowWithKey = PropertyValue.Count() And PropertyValue[0].Property("Key");
			// tabular parts ItemList and PaymentList moved by rows, key in rows is unique
			If IsRowWithKey Then
				For Each Row In PropertyValue Do
					FillPropertyValues(Source[PropertyName].FindRows(New Structure("Key", Row.Key))[0], Row);
				EndDo;
			Else
				// if tabular parts not contain key then transfered completely, for example PaymentTerms
				Source[PropertyName].Clear();
				For Each Row In PropertyValue Do
					FillPropertyValues(Source[PropertyName].Add(), Row);
				EndDo;
			EndIf;
		Else
			Source[PropertyName] = PropertyValue; // it is property of object
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

Procedure SetterForm(StepNames, DataPath, Parameters, Results, 
	ViewNotify = Undefined, ValueDataPath = Undefined, NotifyAnyWay = False, ReadOnlyFromCache = False)
	Setter("Form", StepNames, DataPath, Parameters, Results, ViewNotify, ValueDataPath, NotifyAnyWay, ReadOnlyFromCache);
EndProcedure

Procedure MultiSetterObject(Parameters, Results, ResourceToBinding)
	For Each KeyValue In ResourceToBinding Do
		Resource = KeyValue.Key;
		Binding = KeyValue.Value;
		Segments = StrSplit(Binding.DataPath, ".");
		If Segments.Count() = 1 Then // it is property of object
			_Results = New Array();
			For Each Result In Results Do
				_Results.Add(New Structure("Value, Options", Result.Value[Resource], New Structure("Key")));
				Break;
			EndDo;
			SetterObject(Binding.StepsEnabler, Binding.DataPath , Parameters, _Results);
		ElsIf Segments.Count() = 2 Then // it is column of table
			SetterObject(Binding.StepsEnabler, Binding.DataPath , Parameters, Results, , Resource);
		Else
			Raise StrTemplate("Wrong data path [%1]", Binding.DataPath);
		EndIf;
	EndDo;
EndProcedure

Procedure SetterObject(StepNames, DataPath, Parameters, Results, 
	ViewNotify = Undefined, ValueDataPath = Undefined, NotifyAnyWay = False, ReadOnlyFromCache = False)
	Setter("Object", StepNames, DataPath, Parameters, Results, ViewNotify, ValueDataPath, NotifyAnyWay, ReadOnlyFromCache);
EndProcedure

Procedure Setter(Source, StepNames, DataPath, Parameters, Results, ViewNotify, ValueDataPath, NotifyAnyWay, ReadOnlyFromCache)
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
	If ValueIsFilled(StepNames) Then
		// property is changed and have next steps
		// or property is ReadInly, call next steps
		If IsChanged Then
			ModelClientServer_V2.EntryPoint(StepNames, Parameters);
		ElsIf Parameters.ReadOnlyPropertiesMap.Get(Upper(DataPath)) = True Then
			If Parameters.ProcessedReadOnlyPropertiesMap.Get(Upper(DataPath)) = Undefined Then
				Parameters.ProcessedReadOnlyPropertiesMap.Insert(Upper(DataPath), True);
				ModelClientServer_V2.EntryPoint(StepNames, Parameters);
			EndIf;
		EndIf;
	EndIf;
EndProcedure

Procedure AddViewNotify(ViewNotify, Parameters)
	// redirect to the client module, the call was from the client, something needs to be updated on the form
	// we will call later when the whole chain of actions is completed,
	// and the changes will be transferred from the cache to the object
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

// parameter Key used when DataPath points to the attribute of the tabular section, for example, ItemList.PriceType
Function GetProperty(Cache, Source, DataPath, Key, ReadOnlyFromCache)
	Segments = StrSplit(DataPath, ".");
	// this is the header attribute, it is indicated without a dot, for example, Company
	If Segments.Count() = 1 Then
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
	// this is an attribute of the tabular part, consists of two parts separated by a dot ItemList.PriceType
	ElsIf Segments.Count() = 2 Then
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
		// not found in cache
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
		// there are no props with this path
		Raise StrTemplate("Wrong data path [%1]", DataPath);
	EndIf;
EndFunction

Function SetPropertyObject(Parameters, DataPath, _Key, _Value, ReadOnlyFromCache = False)
	// if property is ReadOnly and filled then do not change
	If Parameters.ReadOnlyPropertiesMap.Get(Upper(DataPath)) <> Undefined Then
		Segments = StrSplit(DataPath, ".");
		If Segments.Count() = 1 Then
			If ValueIsFilled(Parameters.Object[DataPath]) Then
				Return False; // property is ReadOnly and filled, do not change
			EndIf;
		ElsIf Segments.Count() = 2 Then
			// for tabular part, first need to find row
			TableName = TrimAll(Segments[0]);
			PropertyName = TrimAll(Segments[1]);
			If Upper(TableName) = Upper(Parameters.TableName) Then
				For Each Row In GetRows(Parameters, TableName) Do
					If Row.Key = _Key Then
						If ValueIsFilled(Row[PropertyName]) Then
							Return False; // property is ReadOnly and filled, do not change
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
		Return False; // property is not changed
	EndIf;
	// property is changed
	IsChanged = SetProperty(Parameters.Cache, DataPath, _Key, _Value);
	If IsChanged Then
		PutToChangedData(Parameters, DataPath, CurrentValue, _Value, _Key);
	EndIf;
	Return IsChanged;
EndFunction

Function SetPropertyForm(Parameters, DataPath, _Key, _Value, ReadOnlyFromCache = False)
	CurrentValue = GetPropertyForm(Parameters, DataPath, _Key, ReadOnlyFromCache);
	If ?(ValueIsFilled(CurrentValue), CurrentValue, Undefined) = ?(ValueIsFilled(_Value), _Value, Undefined) Then
		Return False; // property is not changed
	EndIf;
	// property is changed
	IsChanged = SetProperty(Parameters.CacheForm, DataPath, _Key, _Value);
	If IsChanged Then
		PutToChangedData(Parameters, DataPath, CurrentValue, _Value, _Key);
	EndIf;
	Return IsChanged;
EndFunction

// logs changed data so that you can ask questions to the user
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

// sets properties on the passed DataPath, such as ItemList.PriceType or Company
Function SetProperty(Cache, DataPath, _Key, _Value)
	// changed properties put to cache
	Segments = StrSplit(DataPath, ".");
	// this is the header attribute, it is indicated without a dot, for example, Company
	If Segments.Count() = 1 Then
		Cache.Insert(DataPath, _Value);
	// this is an attribute of the tabular part, consists of two parts separated by a dot ItemList.PriceType
	ElsIf Segments.Count() = 2 Then
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
		// there are no props with this path
		Raise StrTemplate("Wrong data path [%1]", DataPath);
	EndIf;	
	Return True;
EndFunction

Procedure BindVoid(Parameters, Chain) Export
	Return;
EndProcedure

Function BindSteps(DefaulStepsEnabler, DataPath, Binding, Parameters)
	Result = New Structure();
	Result.Insert("FullDataPath" , "");
	Result.Insert("StepsEnabler" , "");
	Result.Insert("DataPath"     , "");
	
	If TypeOf(DataPath) = Type("Map") Then
		DataPath = DataPath.Get(Parameters.ObjectMetadataInfo.MetadataName);
		If DataPath = Undefined Then
			Return Result;
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
	If Parameters.Property("IsProgramChange") And Parameters.IsProgramChange Then
		Return False; // Is programm change via scan barcode or other external forms
	EndIf;
	
	If Parameters.Property("ModelEnvironment")
		And Parameters.ModelEnvironment.Property("StepNamesCounter") Then
		Return Parameters.ModelEnvironment.StepNamesCounter.Count() = 1;
	EndIf;
	Return False;
EndFunction

#IF Server THEN

Function AddLinkedDocumentRows(Object, Form, LinkedResult, TableName) Export
	FormParameters = GetFormParameters(Form);
	ServerParameters = GetServerParameters(Object);
	ServerParameters.TableName = TableName;
	ServerParameters.IsBasedOn = True;
	ServerParameters.ReadOnlyProperties = LinkedResult.UpdatedProperties;
	ServerParameters.Rows = LinkedResult.Rows;
		
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
	Object.AdditionalProperties.Insert("IsBasedOn", True);
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
							TabularProperties.Add(StrTemplate("%1.%2", Property, Column.Key));
					EndIf;
				EndDo;
			EndIf;
		Else // is header property
			HeaderProperties.Add(Property);
		EndIf;
	EndDo;
	ReadOnlyProperties = StrConcat(HeaderProperties, ",") +","+StrConcat(TabularProperties, ",");
	Object.AdditionalProperties.Insert("ReadOnlyProperties", ReadOnlyProperties);
	Object.AdditionalProperties.Insert("IsBasedOn", True);
EndProcedure

#ENDIF
