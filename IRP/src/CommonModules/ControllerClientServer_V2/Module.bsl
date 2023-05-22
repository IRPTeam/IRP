
#Region PARAMETERS

Function GetServerParameters(Object) Export
	Result = New Structure();
	Result.Insert("Object", Object);
	Result.Insert("ControllerModuleName", "ControllerClientServer_V2");
	Result.Insert("TableName", "");
	Result.Insert("Rows", Undefined);
	Result.Insert("ReadOnlyProperties", "");
	Result.Insert("IsBasedOn", False);
	Result.Insert("NewRowsByScan", New Array);
	Result.Insert("UpdatedRowsByScan", New Array);
	Result.Insert("isRowsAddByScan", False);
	
	StepEnableFlags = New Structure();
	StepEnableFlags.Insert("PriceChanged_AfterQuestionToUser", False);
	
	Result.Insert("StepEnableFlags", StepEnableFlags);
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

Function GetLoadParameters(Address, GroupColumns = "", SumColumns = "") Export
	Result = New Structure();
	Result.Insert("Address", Address);
	Result.Insert("GroupColumns", GroupColumns);
	Result.Insert("SumColumns", SumColumns);
	Return Result;
EndFunction

Function GetParameters(ServerParameters, FormParameters = Undefined, LoadParameters = Undefined) Export
	_FormParameters = ?(FormParameters = Undefined, GetFormParameters(Undefined), FormParameters);
	_LoadParameters = ?(LoadParameters = Undefined, GetLoadParameters(Undefined), LoadParameters);
	Return CreateParameters(ServerParameters, _FormParameters, _LoadParameters);
EndFunction

Function CreateParameters(ServerParameters, FormParameters, LoadParameters)
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
	Parameters.Insert("LoadData"         , New Structure());
	
	Parameters.Insert("RowsForRecalculate"   , New Array());
	Parameters.Insert("UseRowsForRecalculate", False);
	Parameters.Insert("RowsConsignorStocks"  , New Array());
	
	Parameters.LoadData.Insert("Address"                   , LoadParameters.Address);
	Parameters.LoadData.Insert("GroupColumns"              , LoadParameters.GroupColumns);
	Parameters.LoadData.Insert("SumColumns"                , LoadParameters.SumColumns);
	Parameters.LoadData.Insert("ExecuteAllViewNotify"      , False);
	Parameters.LoadData.Insert("CountRows"                 , 0);
	Parameters.LoadData.Insert("SourceColumnsGroupBy"      , "");
	Parameters.LoadData.Insert("SourceColumnsSumBy"        , "");
	
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
	Parameters.Insert("StepEnableFlags", ServerParameters.StepEnableFlags);
	
	Parameters.Insert("IsBasedOn"             , ServerParameters.IsBasedOn);
	Parameters.Insert("ReadOnlyProperties"    , ServerParameters.ReadOnlyProperties);
	Parameters.Insert("ReadOnlyPropertiesMap" , New Map());
	Parameters.Insert("ProcessedReadOnlyPropertiesMap" , New Map());
	ArrayOfProperties = StrSplit(ServerParameters.ReadOnlyProperties, ",");
	For Each Property In ArrayOfProperties Do
		Parameters.ReadOnlyPropertiesMap.Insert(Upper(TrimAll(Property)), True);
	EndDo;
	
	Parameters.Insert("IsFullRefill_Materials", False);
	
	Parameters.Insert("TableName", ServerParameters.TableName);
	ArrayOfTableNames = New Array();
	ArrayOfTableNames.Add(ServerParameters.TableName);
	ArrayOfTableNames.Add("TaxList");
	ArrayOfTableNames.Add("SpecialOffers");
	ArrayOfTableNames.Add("SerialLotNumbers");
	ArrayOfTableNames.Add("BillOfMaterialsList");
	ArrayOfTableNames.Add("Materials");
	ArrayOfTableNames.Add("SourceOfOrigins");
	ArrayOfTableNames.Add("RowIDInfo");
	ArrayOfTableNames.Add("ControlCodeStrings");
		
	// MetadataName
	// Tables.TableName.Columns
	// DependentTables
	ServerData = ControllerServer_V2.GetServerData(ServerParameters.Object, 
												   ArrayOfTableNames,
												   Parameters.FormTaxColumnsExists, 
												   Parameters.TaxesCache,
												   Parameters.LoadData);
	
	Parameters.Insert("NewRowsByScan", ServerParameters.NewRowsByScan);
	Parameters.Insert("UpdatedRowsByScan", ServerParameters.UpdatedRowsByScan);
	Parameters.Insert("isRowsAddByScan", ServerParameters.isRowsAddByScan);
	
	IsItemList        = Upper("ItemList")    = Upper(ServerParameters.TableName);
	IsPaymentList     = Upper("PaymentList") = Upper(ServerParameters.TableName);
	IsProductionsList = Upper("Productions") = Upper(ServerParameters.TableName);
		
	Parameters.Insert("ObjectMetadataInfo"     , ServerData.ObjectMetadataInfo);
	
	Parameters.Insert("TaxListIsExists"        , 
		ServerData.ObjectMetadataInfo.Tables.Property("TaxList") And (IsItemList Or IsPaymentList));
	Parameters.Insert("SpecialOffersIsExists"  , 
		ServerData.ObjectMetadataInfo.Tables.Property("SpecialOffers") And IsItemList);
	Parameters.Insert("SerialLotNumbersExists" , 
		ServerData.ObjectMetadataInfo.Tables.Property("SerialLotNumbers") And IsItemList);	
	Parameters.Insert("BillOfMaterialsListExists" , 
		ServerData.ObjectMetadataInfo.Tables.Property("BillOfMaterialsList") And IsProductionsList);	
	Parameters.Insert("SourceOfOriginsExists" , 
		ServerData.ObjectMetadataInfo.Tables.Property("SourceOfOrigins") And IsItemList);	
	Parameters.Insert("RowIDInfoExists" ,
		ServerData.ObjectMetadataInfo.Tables.Property("RowIDInfo") And IsItemList);
	Parameters.Insert("ControlCodeStringsExists" , 
		ServerData.ObjectMetadataInfo.Tables.Property("ControlCodeStrings") And IsItemList);	
	
	Parameters.Insert("ArrayOfTaxInfo"         , ServerData.ArrayOfTaxInfo);
	
	Parameters.Insert("SourceTableMap" , New Map());
	Parameters.Insert("SourceTables"   , New Structure());
	For Each KeyValue In ServerData.ObjectMetadataInfo.Tables Do
		SourceTableName = KeyValue.Key;
		SourceColumns = KeyValue.Value.Columns;
		
		KeyIsPresent = False;
		For Each Column In StrSplit(SourceColumns, ",") Do
			If Upper(TrimAll(Column)) = Upper("Key") Then
				KeyIsPresent = True;
				Break;
			EndIf;
		EndDo;
		
		If Not KeyIsPresent Then
			Continue;
		EndIf;
		
		Parameters.SourceTables.Insert(SourceTableName, New Array());
		For Each SourceRow In ServerParameters.Object[SourceTableName] Do
			NewSourceRow = New Structure(SourceColumns);
			FillPropertyValues(NewSourceRow, SourceRow);
			
			Parameters.SourceTables[SourceTableName].Add(NewSourceRow);
			Parameters.SourceTableMap.Insert(SourceTableName + ":" + NewSourceRow.Key, NewSourceRow);
		EndDo;
	EndDo;

	Parameters.LoadData.CountRows                 = ServerData.LoadData.CountRows;
	Parameters.LoadData.SourceColumnsGroupBy      = ServerData.LoadData.SourceColumnsGroupBy;
	Parameters.LoadData.SourceColumnsSumBy        = ServerData.LoadData.SourceColumnsSumBy;
	Parameters.Insert("IsLoadData", Parameters.LoadData.CountRows > 0);
	
	Parameters.Insert("IsAddFilledRow", False);
	
	// if specific rows are not passed, then we use everything that is in the table with the name TableName
	If ServerParameters.Rows = Undefined Then 
		If ValueIsFilled(ServerParameters.TableName) Then
			ServerParameters.Rows = ServerParameters.Object[ServerParameters.TableName];
		Else
			ServerParameters.Rows = New Array();
		EndIf;
	EndIf;
	
	RowsConsignorStocks = New Array();	
	If ValueIsFilled(ServerParameters.TableName) 
		And (Parameters.ObjectMetadataInfo.MetadataName = "SalesInvoice"
			Or Parameters.ObjectMetadataInfo.MetadataName = "RetailSalesReceipt") Then
			
		For Each Row In ServerParameters.Object[ServerParameters.TableName] Do
			If Not CommonFunctionsClientServer.ObjectHasProperty(Row, "InventoryOrigin") Then
				Continue;
			EndIf;
			If Row.InventoryOrigin = PredefinedValue("Enum.InventoryOriginTypes.ConsignorStocks") Then
				RowsConsignorStocks.Add(Row);
			EndIf;
		EndDo;		
	EndIf;
		
	// the table row cannot be transferred to the server, so we put the data in an array of structures
	WrappedRows = WrapRows(Parameters, ServerParameters.Rows);
	If WrappedRows.Count() Then
		Parameters.Insert("Rows", WrappedRows);
	EndIf;
	
	WrappedRows = WrapRows(Parameters, RowsConsignorStocks);
	Parameters.Insert("RowsConsignorStocks", WrappedRows);
	
	Parameters.Insert("NextSteps"    , New Array());
	Parameters.Insert("CacheRowsMap" , New Map());
	Parameters.Insert("TableRowsMap" , New Map());
	Parameters.Insert("BindingMap"   , New Map());
	Parameters.Insert("CacheRowsRemovable", New Structure());
	
	Return Parameters;
EndFunction

Procedure AddEmptyRowsForLoad(Parameters) Export
	TableName = Parameters.TableName;
	NewRows = New Array();
	For i = 1 To Parameters.LoadData.CountRows Do
		NewRow = Parameters.Object[TableName].Add();
		NewRow.Key = String(New UUID());
		NewRows.Add(NewRow);
		
		NewSourceRow = New Structure(Parameters.ObjectMetadataInfo.Tables[TableName].Columns);
		FillPropertyValues(NewSourceRow, NewRow);
			
		Parameters.SourceTables[TableName].Add(NewSourceRow);
		Parameters.SourceTableMap.Insert(TableName + ":" + NewSourceRow.Key, NewSourceRow);
	EndDo;
	WrappedRows = WrapRows(Parameters, NewRows);
	If Parameters.Property("Rows") Then
		For Each Row In WrappedRows Do
			Parameters.Rows.Add(Row);
		EndDo;
	Else
		Parameters.Insert("Rows", WrappedRows);
	EndIf;	
EndProcedure

Function WrapRows(Parameters, Rows) Export
	ArrayOfRows = New Array();
	For Each Row In Rows Do
		NewRow = New Structure(Parameters.ObjectMetadataInfo.Tables[Parameters.TableName].Columns);
		FillPropertyValues(NewRow, Row);
		ArrayOfRows.Add(NewRow);

		FilterByKey = New Structure("Key", Row.Key);

		ArrayOfRowsTaxList = New Array();
		TaxRates = New Structure();
		If Parameters.TaxListIsExists Then
			// TaxList
			For Each TaxRow In Parameters.Object.TaxList.FindRows(FilterByKey) Do
				NewRowTaxList = New Structure(Parameters.ObjectMetadataInfo.Tables.TaxList.Columns);
				FillPropertyValues(NewRowTaxList, TaxRow);
				ArrayOfRowsTaxList.Add(NewRowTaxList);
			EndDo;
		
			// TaxRates
		
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
		EndIf; // TaxListIsExists
		
		// SpecialOffers
		ArrayOfRowsSpecialOffers = New Array();
		If Parameters.SpecialOffersIsExists Then
			For Each SpecialOfferRow In Parameters.Object.SpecialOffers.FindRows(FilterByKey) Do
				NewRowSpecialOffer = New Structure(Parameters.ObjectMetadataInfo.Tables.SpecialOffers.Columns);
				FillPropertyValues(NewRowSpecialOffer, SpecialOfferRow);
				ArrayOfRowsSpecialOffers.Add(NewRowSpecialOffer);
			EndDo;
		EndIf; // SpecialOffers
		
		// SpecialOffersCache
		ArrayOfRowsSpecialOffersCache = New Array();
		If Parameters.FormIsExists And CommonFunctionsClientServer.ObjectHasProperty(Parameters.Form, "SpecialOffersCache") Then
			For Each SpecialOfferRow In Parameters.Form.SpecialOffersCache.FindRows(FilterByKey) Do
				NewRowSpecialOffer = New Structure("Key, Offer, Amount, Quantity");
				FillPropertyValues(NewRowSpecialOffer, SpecialOfferRow);
				ArrayOfRowsSpecialOffersCache.Add(NewRowSpecialOffer);
			EndDo;
		EndIf; // SpecialOffersCache
		
		// BillOfMaterials
		ArrayOfRowsBillOfMaterialsList = New Array();
		If Parameters.BillOfMaterialsListExists Then
			For Each RowBillOfMaterials In Parameters.Object.BillOfMaterialsList.FindRows(FilterByKey) Do
				NewRowBillOfMaterials = New Structure(Parameters.ObjectMetadataInfo.Tables.BillOfMaterialsList.Columns);
				FillPropertyValues(NewRowBillOfMaterials, RowBillOfMaterials);
				ArrayOfRowsBillOfMaterialsList.Add(NewRowBillOfMaterials);
			EndDo;
		EndIf; // BillOfMaterialsListExists
		
		// RowIDInfo
		ArrayOfRowsRowIDInfo = New Array();
		If Parameters.RowIDInfoExists Then
			For Each RowRowIDInfo In Parameters.Object.RowIDInfo.FindRows(FilterByKey) Do
				NewRowRowIDInfo = New Structure(Parameters.ObjectMetadataInfo.Tables.RowIDInfo.Columns);
				FillPropertyValues(NewRowRowIDInfo, RowRowIDInfo);
				ArrayOfRowsRowIDInfo.Add(NewRowRowIDInfo);
			EndDo;
		EndIf; // RowIDInfoExeists

		NewRow.Insert("TaxIsAlreadyCalculated" , Parameters.IsBasedOn And ArrayOfRowsTaxList.Count());
		NewRow.Insert("TaxRates"               , TaxRates);
		NewRow.Insert("TaxList"                , ArrayOfRowsTaxList);
		NewRow.Insert("SpecialOffers"          , ArrayOfRowsSpecialOffers);
		NewRow.Insert("SpecialOffersCache"     , ArrayOfRowsSpecialOffersCache);
		NewRow.Insert("BillOfMaterialsList"    , ArrayOfRowsBillOfMaterialsList);
		NewRow.Insert("RowIDInfo"              , ArrayOfRowsRowIDInfo);
	EndDo;
	Return ArrayOfRows;
EndFunction	

#EndRegion

Procedure FillPropertyFormByDefault(Form, DataPaths, Parameters) Export
	ArrayOfDataPath = StrSplit(DataPaths, ",");
	
	Bindings = GetAllBindings(Parameters);
	Defaults = GetAllBindingsByDefault(Parameters);
	
	For Each DataPath In ArrayOfDataPath Do
		DataPath = TrimAll(DataPath);
		Default = Defaults.Get(DataPath);
		If Default <> Undefined Then
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

#Region API

// attributes that available through API
Function GetEventHandlersByDataPath(Parameters, DataPath, IsBuilder)
	EventHandlerMap = New Map();
	EventHandlerMap.Insert("Sender"          , "SetAccountSender");
	EventHandlerMap.Insert("SendCurrency"    , "SetSendCurrency");
	EventHandlerMap.Insert("Receiver"        , "SetAccountReceiver");
	EventHandlerMap.Insert("ReceiveCurrency" , "SetReceiveCurrency");
	EventHandlerMap.Insert("Account"         , "SetAccount");
	EventHandlerMap.Insert("CashAccount"     , "SetAccount");
	EventHandlerMap.Insert("Currency"        , "SetCurrency");
	EventHandlerMap.Insert("Date"            , "SetDate");
	EventHandlerMap.Insert("Company"         , "SetCompany");
	EventHandlerMap.Insert("Branch"          , "SetBranch");
	EventHandlerMap.Insert("Partner"         , "SetPartner");
	EventHandlerMap.Insert("LegalName"       , "SetLegalName");
	EventHandlerMap.Insert("Agreement"       , "SetAgreement");
	EventHandlerMap.Insert("ManagerSegment"  , "SetManagerSegment");
	EventHandlerMap.Insert("PriceIncludeTax" , "SetPriceIncludeTax");
	EventHandlerMap.Insert("StoreSender"     , "SetStoreSender");
	EventHandlerMap.Insert("StoreReceiver"   , "SetStoreReceiver");
	EventHandlerMap.Insert("Workstation"     , "SetWorkstation");
	EventHandlerMap.Insert("BusinessUnit"    , "SetBusinessUnit");
	EventHandlerMap.Insert("TransactionType" , "SetTransactionType");
	
	// PaymentList
	EventHandlerMap.Insert("PaymentList.Partner" , "SetPaymentListPartner");
	EventHandlerMap.Insert("PaymentList.Payer"   , "SetPaymentListLegalName");
	EventHandlerMap.Insert("PaymentList.Payee"   , "SetPaymentListLegalName");
	EventHandlerMap.Insert("PaymentList.Account" , "SetPaymentListAccount");
	
	// ItemList
	EventHandlerMap.Insert("ItemList.Item"               , "SetItemListItem");
	EventHandlerMap.Insert("ItemList.ItemKey"            , "SetItemListItemKey");
	EventHandlerMap.Insert("ItemList.Unit"               , "SetItemListUnit");
	EventHandlerMap.Insert("ItemList.PriceType"          , "SetItemListPriceType");
	EventHandlerMap.Insert("ItemList.Price"              , "SetItemListPrice");
	EventHandlerMap.Insert("ItemList.ConsignorPrice"     , "SetItemListConsignorPrice");
	EventHandlerMap.Insert("ItemList.TradeAgentFeePercent", "SetItemListTradeAgentFeePercent");
	EventHandlerMap.Insert("ItemList.DontCalculateRow"   , "SetItemListDontCalculateRow");
	EventHandlerMap.Insert("ItemList.Quantity"           , "SetItemListQuantity");
	EventHandlerMap.Insert("ItemList.Store"              , "SetItemListStore");
	EventHandlerMap.Insert("ItemList.DeliveryDate"       , "SetItemListDeliveryDate");
	EventHandlerMap.Insert("ItemList.QuantityInBaseUnit" , "SetItemListQuantityInBaseUnit");
	EventHandlerMap.Insert("ItemList.PhysCount"          , "SetItemListPhysCount");
	EventHandlerMap.Insert("ItemList.ManualFixedCount"   , "SetItemListManualFixedCount");
	EventHandlerMap.Insert("ItemList.ExpCount"           , "SetItemListExpCount");
	EventHandlerMap.Insert("ItemList.SalesInvoice"       , "SetItemListSalesDocument");
	EventHandlerMap.Insert("ItemList.RetailSalesReceipt" , "SetItemListSalesDocument");
	
	If Parameters.ObjectMetadataInfo.MetadataName = "SalesReportToConsignor" Then
		EventHandlerMap.Insert("ItemList.TotalAmount", "StepItemListChangePriceTypeAsManual_IsTotalAmountChange,
													|StepItemListCalculations_IsTotalAmountChanged_Without_SpecialOffers");
	Else
		EventHandlerMap.Insert("ItemList.TotalAmount", "StepItemListChangePriceTypeAsManual_IsTotalAmountChange,
													|StepItemListCalculations_IsTotalAmountChanged");
	EndIf;
	
	EventHandlerMap.Insert("ItemList.<tax_rate>"         , "StepChangeTaxRate_AgreementInHeader");
	EventHandlerMap.Insert("ItemList."                   , "StepItemListCalculations_IsTaxRateChanged");
	If IsBuilder Then
		EventHandlerMap.Insert("ItemList.TaxAmount"          , "SetItemListTaxAmount");
	EndIf;
	EventHandlerMap.Insert("ItemList.InventoryOrigin"        , "SetItemListInventoryOrigin");
	
	// Materials
	EventHandlerMap.Insert("Materials.BillOfMaterials"    , "SetMaterialsBillOfMaterials");
	EventHandlerMap.Insert("Materials.Item"               , "SetMaterialsItem");
	EventHandlerMap.Insert("Materials.ItemKey"            , "SetMaterialsItemKey");
	EventHandlerMap.Insert("Materials.ItemKeyBOM"         , "SetMaterialsItemKeyBOM");
	EventHandlerMap.Insert("Materials.Unit"               , "SetMaterialsUnit");
	EventHandlerMap.Insert("Materials.Quantity"           , "SetMaterialsQuantity");
	EventHandlerMap.Insert("Materials.QuantityBOM"        , "SetMaterialsQuantityBOM");
	
	// Manufacturing calculations
	EventHandlerMap.Insert("Command_UpdateCurrentQuantity"  , "CommandUpdateCurrentQuantity");
	EventHandlerMap.Insert("Command_UpdateByBillOfMaterials", "CommandUpdateByBillOfMaterials");
	
	// Source of origins
	EventHandlerMap.Insert("Command_UpdateConsignorBatches"  , "CommandUpdateConsignorBatches");

	// Recalculations
	EventHandlerMap.Insert("Command_RecalculationWhenBasedOn", "CommandRecalculationWhenBasedOn");
	
	// ReceiptFromConsignor
	EventHandlerMap.Insert("ReceiptFromConsignor.Price"    , "SetReceiptFromConsignorPrice");
	EventHandlerMap.Insert("ReceiptFromConsignor.Quantity" , "SetReceiptFromConsignorQuantity");
	EventHandlerMap.Insert("ReceiptFromConsignor.ItemKey"  , "SetReceiptFromConsignorItemKey");
	
	// Inventory
	EventHandlerMap.Insert("Inventory.Price"    , "SetInventoryPrice");
	EventHandlerMap.Insert("Inventory.Quantity" , "SetInventoryQuantity");
	EventHandlerMap.Insert("Inventory.ItemKey"  , "SetInventoryItemKey");
	
	// Payroll
	EventHandlerMap.Insert("AccrualList.Amount"              , "SetPayrollListsAmount");
	EventHandlerMap.Insert("AccrualList.AccrualType"         , "SetPayrollListsAccrualDeductionType");
	EventHandlerMap.Insert("DeductionList.Amount"            , "SetPayrollListsAmount");
	EventHandlerMap.Insert("DeductionList.DeductionType"     , "SetPayrollListsAccrualDeductionType");
	EventHandlerMap.Insert("CashAdvanceDeductionList.Amount" , "SetPayrollListsAmount");
	
	Return EventHandlerMap.Get(DataPath);
EndFunction

Function API_GetSettings() Export
	Settings = New Structure();
	Settings.Insert("CommitPropertyWithoutSetter", True);
	Settings.Insert("LaunchStepsImmediately", True);
	Return Settings;
EndFunction

Procedure API_SetProperty(Parameters, Property, Value, IsBuilder = False, Settings = Undefined) Export
	If Settings = Undefined Then
		Settings = API_GetSettings(); // default settings
	EndIf;
	
	ArrayOfEventHandlers = GetEventHandlersByDataPath(Parameters, Property.DataPath, IsBuilder);
	IsColumn = StrSplit(Property.DataPath, ".").Count() = 2;
	If ArrayOfEventHandlers = Undefined Then // no steps, no setter, no commands
		If IsColumn Then
			For Each Row In GetRows(Parameters, Parameters.TableName) Do
				SetterObject("BindVoid", Property.DataPath, Parameters, ResultArray(Row.Key, Value));
			EndDo;
		Else
			SetterObject("BindVoid", Property.DataPath, Parameters, ResultArray(Undefined, Value));
		EndIf;
		If Settings.CommitPropertyWithoutSetter Then
			CommitChainChanges(Parameters);
		EndIf;
	Else
		If IsColumn Then
			
			For Each EventHandler In StrSplit(ArrayOfEventHandlers, ",") Do
				EventHandler = TrimAll(EventHandler);
				If StrStartsWith(EventHandler, "Step") Then // step
					// ItemList.TotalAmount does not have setter
					If Upper(Property.DataPath) <> Upper("ItemList.TotalAmount") Then
						ModelClientServer_V2.EntryPoint(EventHandler, Parameters);
					EndIf;
				EndIf;
			EndDo;
			
			For Each Row In GetRows(Parameters, Parameters.TableName) Do
				For Each EventHandler In StrSplit(ArrayOfEventHandlers, ",") Do
					EventHandler = TrimAll(EventHandler);
					If StrStartsWith(EventHandler, "Step") Then // step
						
						If Upper(Property.DataPath) = Upper("ItemList.TotalAmount") Then
							If Value <> Undefined Then
								SetterObject("BindVoid", Property.DataPath, Parameters, ResultArray(Row.Key, Value));
								ModelClientServer_V2.EntryPoint(EventHandler, Parameters);
							EndIf;
						EndIf;
					
					ElsIf StrStartsWith(EventHandler, "Set") Then // set
						
						Results = ResultArray(Row.Key, Value);
						ExecuteSetterByName(Parameters, Results, EventHandler);
					
					EndIf;

				EndDo;
			EndDo;

		Else // not IsColumn
		
			For Each EventHandler In StrSplit(ArrayOfEventHandlers, ",") Do
				EventHandler = TrimAll(EventHandler);
				If StrStartsWith(EventHandler, "Step") Then // step
					ModelClientServer_V2.EntryPoint(EventHandler, Parameters);
				ElsIf StrStartsWith(EventHandler, "Command") Then // command
					ExecuteCommandByName(Parameters, EventHandler);
				Else // setter
					Results = ResultArray(Undefined, Value);
					ExecuteSetterByName(Parameters, Results, EventHandler);
				EndIf;
			EndDo;

		EndIf;

	EndIf;

	If Settings.LaunchStepsImmediately Then
		LaunchNextSteps(Parameters);
	EndIf;
EndProcedure

Procedure ExecuteSetterByName(Parameters, Results, SetterName)
	//@skip-warning
	Execute StrTemplate("%1(Parameters, Results);", SetterName);
EndProcedure

Procedure ExecuteCommandByName(Parameters, CommandName)
	//@skip-warning
	Execute StrTemplate("%1(Parameters);", CommandName);
EndProcedure

Function ResultArray(_Key, Value)
	Results = New Array();
	Results.Add(New Structure("Options, Value", New Structure("Key", _Key), Value));
	Return Results;
EndFunction	

Function GetAllBindings(Parameters)
	BindingMap = New Map();
	BindingMap.Insert("Company"       , BindCompany(Parameters));
	BindingMap.Insert("Account"       , BindAccount(Parameters));
	BindingMap.Insert("Partner"       , BindPartner(Parameters));
	BindingMap.Insert("LegalName"     , BindLegalName(Parameters));
	BindingMap.Insert("Currency"      , BindCurrency(Parameters));
	BindingMap.Insert("StoreSender"   , BindStoreSender(Parameters));
	BindingMap.Insert("StoreReceiver" , BindStoreReceiver(Parameters));
	
	BindingMap.Insert("ItemList.Item"     , BindItemListItem(Parameters));
	BindingMap.Insert("ItemList.ItemKey"  , BindItemListItemKey(Parameters));
	BindingMap.Insert("ItemList.Unit"     , BindItemListUnit(Parameters));
	BindingMap.Insert("ItemList.Quantity" , BindItemListQuantity(Parameters));
	
	BindingMap.Insert("Materials.Item"     , BindMaterialsItem(Parameters));
	BindingMap.Insert("Materials.ItemKey"  , BindMaterialsItemKey(Parameters));
	BindingMap.Insert("Materials.Unit"     , BindMaterialsUnit(Parameters));
	BindingMap.Insert("Materials.Quantity" , BindMaterialsQuantity(Parameters));
	
	BindingMap.Insert("Productions.Item"     , BindProductionsItem(Parameters));
	BindingMap.Insert("Productions.ItemKey"  , BindProductionsItemKey(Parameters));
	BindingMap.Insert("Productions.Unit"     , BindProductionsUnit(Parameters));
	BindingMap.Insert("Productions.Quantity" , BindProductionsQuantity(Parameters));
	
	Return BindingMap;
EndFunction

Function GetAllBindingsByDefault(Parameters)
	Binding = New Map();
	Binding.Insert("Store"        , BindDefaultStore(Parameters));
	Binding.Insert("DeliveryDate" , BindDefaultDeliveryDate(Parameters));
	
	Binding.Insert("ItemList.Store"          , BindDefaultItemListStore(Parameters));
	Binding.Insert("ItemList.DeliveryDate"   , BindDefaultItemListDeliveryDate(Parameters));
	Binding.Insert("ItemList.Quantity"       , BindDefaultItemListQuantity(Parameters));
	Binding.Insert("ItemList.InventoryOrigin", BindDefaultItemListInventoryOrigin(Parameters));
	
	Binding.Insert("PaymentList.Currency"  , BindDefaultPaymentListCurrency(Parameters));
	
	Binding.Insert("Materials.Quantity"    , BindDefaultMaterialsQuantity(Parameters));
	
	Binding.Insert("Productions.Quantity"  , BindDefaultProductionsQuantity(Parameters));
	
	Return Binding;
EndFunction

Function GetAllCommandsByDefault(Parameters)
	ArrayOfCommands = New Array();
	ArrayOfCommands.Add("CommandDefaultTaxRate");	
	Return ArrayOfCommands;
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
	
	Binding.Insert("SalesOrder"        , "StepRequireCallCreateTaxesFormControls");
	Binding.Insert("SalesInvoice"      , "StepRequireCallCreateTaxesFormControls");
	Binding.Insert("SalesReturnOrder"  , "StepRequireCallCreateTaxesFormControls");
	Binding.Insert("SalesReturn"       , "StepRequireCallCreateTaxesFormControls");
	
	Binding.Insert("PurchaseOrder"        , "StepRequireCallCreateTaxesFormControls");
	Binding.Insert("PurchaseInvoice"      , "StepRequireCallCreateTaxesFormControls");
	Binding.Insert("PurchaseReturnOrder"  , "StepRequireCallCreateTaxesFormControls");
	Binding.Insert("PurchaseReturn"       , "StepRequireCallCreateTaxesFormControls");
	
	Binding.Insert("RetailSalesReceipt"   , "StepRequireCallCreateTaxesFormControls");	
	Binding.Insert("RetailReturnReceipt"  , "StepRequireCallCreateTaxesFormControls");
									
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

	Binding.Insert("CashTransferOrder",
		"StepGenerateNewSendUUID,
		|StepGenerateNewReceiptUUID");
		
	Binding.Insert("CashRevenue",
		"StepPaymentListCalculations_RecalculationsOnCopy,
		|StepRequireCallCreateTaxesFormControls");
		
	Binding.Insert("CashExpense",
		"StepPaymentListCalculations_RecalculationsOnCopy,
		|StepRequireCallCreateTaxesFormControls");

	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindFormOnCreateAtServer");
EndFunction

// Form.Modificator
Procedure FormModificator_CreateTaxesFormControls(Parameters, Results) Export
	If Results[0].Value Then
		Parameters.FormModificators.Add("FormModificator_CreateTaxesFormControls");
		ExecuteCommandByName(Parameters, "CommandRecalculateWhenTaxsesContentChanged");
	EndIf;
EndProcedure

// Form.RequireCallCreateTaxesFormControls.Step
Procedure StepRequireCallCreateTaxesFormControls(Parameters, Chain) Export
	Chain.RequireCallCreateTaxesFormControls.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.RequireCallCreateTaxesFormControls.Setter = "FormModificator_CreateTaxesFormControls";
	Options = ModelClientServer_V2.RequireCallCreateTaxesFormControlsOptions();
	Options.Ref            = Parameters.Object.Ref;
	Options.Date           = GetDate(Parameters);
	Options.Company        = GetCompany(Parameters);
	Options.TransactionType = GetTransactionType(Parameters);
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
	Binding.Insert("CashExpense" , "StepExtractDataCurrencyFromAccount");
	Binding.Insert("CashRevenue" , "StepExtractDataCurrencyFromAccount");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindFormOnOpen");
EndFunction

#EndRegion

#Region _LIST_

#Region _LIST_ADD

Procedure AddNewRow(TableName, Parameters, ViewNotify = Undefined, LaunchSteps = True) Export
	If ViewNotify <> Undefined Then
		AddViewNotify(ViewNotify, Parameters);
	EndIf;
	
	NewRow = Parameters.Rows[0];
	UserSettingsClientServer.FillingRowFromSettings(Parameters.Object, StrTemplate("Object.%1", TableName), NewRow, True);
	Parameters.Insert("RowFilledByUserSettings", NewRow);
	
	Bindings = GetAllBindings(Parameters);
	Defaults = GetAllBindingsByDefault(Parameters);
	DefaultsCommand = GetAllCommandsByDefault(Parameters);
	
	For Each ColumnName In StrSplit(Parameters.ObjectMetadataInfo.Tables[TableName].Columns, ",") Do
		
		// column has its own handler .Default call it
		DataPath = StrTemplate("%1.%2", TableName, ColumnName);
		Segments = StrSplit(DataPath, ".");
		If Segments.Count() = 2 And StrStartsWith(Segments[1], "_" ) Then
			DataPath = Segments[0] + ".";
		EndIf;
		Default = Defaults.Get(DataPath);
		If Default <> Undefined Then
	
			RegisterNextSteps(Parameters, True , Default.StepsEnabler, DataPath);
			
		// if column is filled  and has its own handler .OnChage call it
		ElsIf ValueIsFilled(NewRow[ColumnName]) Then
			SetPropertyObject(Parameters, DataPath, NewRow.Key, NewRow[ColumnName]);
			Binding = Bindings.Get(DataPath);
			If Binding <> Undefined Then
				
				RegisterNextSteps(Parameters, True, Binding.StepsEnabler, DataPath);
			
			EndIf;
		EndIf;
		
	EndDo;
	
	If LaunchSteps Then
		LaunchNextSteps(Parameters);
	EndIf;
	
	For Each CommandName In DefaultsCommand Do
		ExecuteCommandByName(Parameters, CommandName);
	EndDo;
EndProcedure

#EndRegion

#Region _LIST_DELETE

Procedure DeleteRows(TableName, Parameters, ViewNotify = Undefined) Export
	If ViewNotify <> Undefined Then
		AddViewNotify(ViewNotify, Parameters);
	EndIf;
	
	// for determine Dependency and Linked tables see ViewServer_v2.GetObjectMetadataInfo()
	
	// Dependency tables
	For Each DepTableName In Parameters.ObjectMetadataInfo.DependentTables Do
		ArrayForDelete = New Array();
		For Each Row In Parameters.Object[DepTableName] Do
			If Not Parameters.Object[TableName].FindRows(New Structure("Key", Row.Key)).Count() Then
				ArrayForDelete.Add(Row);
			EndIf;
		EndDo;
		For Each ItemForDelete In ArrayForDelete Do
			Parameters.Object[DepTableName].Delete(ItemForDelete);
		EndDo;
	EndDo;
	
	// Subordinate tables
	For Each SubordinateTableName In Parameters.ObjectMetadataInfo.SubordinateTables Do
		ArrayForDelete = New Array();
		For Each Row In Parameters.Object[SubordinateTableName] Do
			If CommonFunctionsClientServer.ObjectHasProperty(Row, "KeyOwner") Then
				If Not Parameters.Object[TableName].FindRows(New Structure("Key", Row.KeyOwner)).Count() Then
					ArrayForDelete.Add(Row);
				EndIf;
			EndIf;
		EndDo;
		For Each ItemForDelete In ArrayForDelete Do
			Parameters.Object[SubordinateTableName].Delete(ItemForDelete);
		EndDo;
	EndDo;
	
	// execute handlers after deleting row
	Binding = BindListOnDelete(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

Procedure DeleteRowsFromTableByKeyOwner(Parameters, TableName, KeyOwner) Export
	ArrayForDelete = New Array();
	For Each Row In Parameters.Object[TableName] Do
		If Row.KeyOwner = KeyOwner Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		Parameters.Object[TableName].Delete(ItemForDelete);
	EndDo;
EndProcedure

// <TableName>.OnDelete.Bind
Function BindListOnDelete(Parameters)
	DataPath = "";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation"       , "StepChangeStoreInHeaderByStoresInList");
	Binding.Insert("RetailShipmentConfirmation" , "StepChangeStoreInHeaderByStoresInList");
	Binding.Insert("GoodsReceipt"               , "StepChangeStoreInHeaderByStoresInList");
	Binding.Insert("RetailGoodsReceipt"         , "StepChangeStoreInHeaderByStoresInList");
	
	Binding.Insert("SalesOrder",
		"StepChangeStoreInHeaderByStoresInList,
		|StepUpdatePaymentTerms");
	
	Binding.Insert("SalesInvoice",
		"StepChangeStoreInHeaderByStoresInList,
		|StepUpdatePaymentTerms");
	
	Binding.Insert("RetailSalesReceipt", "StepChangeStoreInHeaderByStoresInList");
	
	Binding.Insert("PurchaseOrder",
		"StepChangeStoreInHeaderByStoresInList,
		|StepUpdatePaymentTerms");
	
	Binding.Insert("PurchaseInvoice",
		"StepChangeStoreInHeaderByStoresInList,
		|StepUpdatePaymentTerms");
	
	Binding.Insert("SalesReturnOrder"    , "StepChangeStoreInHeaderByStoresInList");
	Binding.Insert("SalesReturn"         , "StepChangeStoreInHeaderByStoresInList");
	Binding.Insert("PurchaseReturnOrder" , "StepChangeStoreInHeaderByStoresInList");
	Binding.Insert("PurchaseReturn"      , "StepChangeStoreInHeaderByStoresInList");
	Binding.Insert("RetailReturnReceipt" , "StepChangeStoreInHeaderByStoresInList");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindListOnDelete");
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
	
	Binding.Insert("SalesOrder",
		"StepItemListCalculations_IsCopyRow,
		|StepUpdatePaymentTerms");
	
	Binding.Insert("SalesInvoice",
		"StepItemListCalculations_IsCopyRow,
		|StepUpdatePaymentTerms");

	Binding.Insert("RetailSalesReceipt"  , "StepItemListCalculations_IsCopyRow");
	Binding.Insert("SalesReturnOrder"    , "StepItemListCalculations_IsCopyRow");
	Binding.Insert("SalesReturn"         , "StepItemListCalculations_IsCopyRow");
	Binding.Insert("PurchaseReturnOrder" , "StepItemListCalculations_IsCopyRow");
	Binding.Insert("PurchaseReturn"      , "StepItemListCalculations_IsCopyRow");
	Binding.Insert("RetailReturnReceipt" , "StepItemListCalculations_IsCopyRow");
	
	Binding.Insert("PurchaseOrder",
		"StepItemListCalculations_IsCopyRow,
		|StepUpdatePaymentTerms");
	
	Binding.Insert("PurchaseInvoice",
		"StepItemListCalculations_IsCopyRow,
		|StepUpdatePaymentTerms");
	
	Binding.Insert("BankPayment"  , "StepPaymentListCalculations_IsCopyRow");
	Binding.Insert("BankReceipt"  , "StepPaymentListCalculations_IsCopyRow");
	Binding.Insert("CashPayment"  , "StepPaymentListCalculations_IsCopyRow");
	Binding.Insert("CashReceipt"  , "StepPaymentListCalculations_IsCopyRow");
	Binding.Insert("CashExpense"  , "StepPaymentListCalculations_IsCopyRow");
	Binding.Insert("CashRevenue"  , "StepPaymentListCalculations_IsCopyRow");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindListOnCopy");
EndFunction

Procedure CopyRowSimpleTable(TableName, Parameters, ViewNotify = Undefined) Export
	If ViewNotify <> Undefined Then
		AddViewNotify(ViewNotify, Parameters);
	EndIf;
	// execute handlers after copy row
	Binding = BindListOnCopySimpleTable(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// <TableName>.OnCopy.Bind
Function BindListOnCopySimpleTable(Parameters)
	DataPath = "";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindListOnCopySimpleTable");
EndFunction

#EndRegion

#EndRegion

#Region _EXTRACT_DATA_

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
	If Chain.Idle Then
		Return;
	EndIf;
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
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ExtractDataCurrencyFromAccount.Setter = "SetExtractDataCurrencyFromAccount";
	Options = ModelClientServer_V2.ExtractDataCurrencyFromAccountOptions();
	Options.Account = GetAccount(Parameters);
	Options.StepName = "StepExtractDataCurrencyFromAccount";
	Chain.ExtractDataCurrencyFromAccount.Options.Add(Options);
EndProcedure

#EndRegion

#Region COMMANDS

// UpdateByBillOfMaterials.Command
Procedure CommandUpdateByBillOfMaterials(Parameters) Export
	Binding = BindCommandUpdateByBillOfMaterials(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// UpdateByBillOfMaterials.Bind
Function BindCommandUpdateByBillOfMaterials(Parameters)
	Binding = New Structure();
	Return BindSteps("StepMaterialsCalculations", "", Binding, Parameters, "BindCommandUpdateByBillOfMaterials");
EndFunction

// UpdateCurrentQuantity.Command
Procedure CommandUpdateCurrentQuantity(Parameters) Export
	Binding = BindCommandUpdateCurrentQuantity(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// UpdateCurrentQuantity.Bind
Function BindCommandUpdateCurrentQuantity(Parameters)
	Binding = New Structure();
	Return BindSteps("StepChangeCurrentQuantityInProductions", "", Binding, Parameters, "BindCommandUpdateCurrentQuantity");
EndFunction

// UpdateConsignorBatches.Command
Procedure CommandUpdateConsignorBatches(Parameters) Export
	Binding = BindCommandUpdateConsignorBatches(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// UpdateConsignorBatches.Bind
Function BindCommandUpdateConsignorBatches(Parameters)
	Binding = New Structure();
	Binding.Insert("InventoryTransfer", "StepConsignorBatchesFillBatches_StoreSender");
	Return BindSteps("StepConsignorBatchesFillBatches", "", Binding, Parameters, "BindCommandUpdateConsignorBatches");
EndFunction

// RecalculationWhenBasedOn.Command
Procedure CommandRecalculationWhenBasedOn(Parameters) Export
	Binding = BindCommandRecalculationWhenBasedOn(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// RecalculationWhenBasedOn.Bind
Function BindCommandRecalculationWhenBasedOn(Parameters)
	Binding = New Structure();
	Binding.Insert("SalesReportFromTradeAgent" , "StepItemListCalculations_IsRecalculationWhenBasedOn_Without_SpecialOffers");
	Binding.Insert("SalesReportToConsignor"    , "StepItemListCalculations_IsRecalculationWhenBasedOn_Without_SpecialOffers");

	Binding.Insert("PurchaseInvoice"      , "StepItemListCalculations_IsRecalculationWhenBasedOn");
	Binding.Insert("PurchaseOrder"        , "StepItemListCalculations_IsRecalculationWhenBasedOn");
	Binding.Insert("PurchaseReturn"       , "StepItemListCalculations_IsRecalculationWhenBasedOn");
	Binding.Insert("PurchaseReturnOrder"  , "StepItemListCalculations_IsRecalculationWhenBasedOn");
	Binding.Insert("RetailReturnReceipt"  , "StepItemListCalculations_IsRecalculationWhenBasedOn");
	Binding.Insert("RetailSalesReceipt"   , "StepItemListCalculations_IsRecalculationWhenBasedOn");
	Binding.Insert("SalesInvoice"         , "StepItemListCalculations_IsRecalculationWhenBasedOn");
	Binding.Insert("SalesOrder"           , "StepItemListCalculations_IsRecalculationWhenBasedOn");
	Binding.Insert("SalesReturn"          , "StepItemListCalculations_IsRecalculationWhenBasedOn");
	Binding.Insert("SalesReturnOrder"     , "StepItemListCalculations_IsRecalculationWhenBasedOn");
	Binding.Insert("WorkOrder"            , "StepItemListCalculations_IsRecalculationWhenBasedOn");
	Return BindSteps("BindVoid", "", Binding, Parameters, "BindCommandRecalculationWhenBasedOn");
EndFunction

// DefaultTaxRate.Command
Procedure CommandDefaultTaxRate(Parameters) Export
	Binding = BindCommandDefaultTaxRate(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// DefaultTaxRate.Bind
Function BindCommandDefaultTaxRate(Parameters)
	Binding = New Structure();
	
	Binding.Insert("BankPayment__PaymentList", "StepChangeTaxRate_AgreementInList");
	Binding.Insert("BankReceipt__PaymentList", "StepChangeTaxRate_AgreementInList");
	Binding.Insert("CashExpense__PaymentList", "StepChangeTaxRate_WithoutAgreement");
	Binding.Insert("CashPayment__PaymentList", "StepChangeTaxRate_AgreementInList");
	Binding.Insert("CashReceipt__PaymentList", "StepChangeTaxRate_AgreementInList");
	Binding.Insert("CashRevenue__PaymentList", "StepChangeTaxRate_WithoutAgreement");
	Binding.Insert("EmployeeCashAdvance__PaymentList" , "StepChangeTaxRate_WithoutAgreement");
	Binding.Insert("PurchaseInvoice__ItemList"     , "StepChangeTaxRate_AgreementInHeader");
	Binding.Insert("PurchaseOrder__ItemList"       , "StepChangeTaxRate_AgreementInHeader");
	Binding.Insert("PurchaseReturn__ItemList"      , "StepChangeTaxRate_AgreementInHeader");
	Binding.Insert("PurchaseReturnOrder__ItemList" , "StepChangeTaxRate_AgreementInHeader");
	Binding.Insert("RetailReturnReceipt__ItemList" , "StepChangeTaxRate_AgreementInHeader");
	Binding.Insert("RetailSalesReceipt__ItemList"  , "StepChangeTaxRate_AgreementInHeader");
	Binding.Insert("SalesInvoice__ItemList"        , "StepChangeTaxRate_AgreementInHeader");
	Binding.Insert("SalesOrder__ItemList"          , "StepChangeTaxRate_AgreementInHeader");
	Binding.Insert("SalesReportFromTradeAgent__ItemList" , "StepChangeTaxRate_AgreementInHeader");
	Binding.Insert("SalesReportToConsignor__ItemList"    , "StepChangeTaxRate_AgreementInHeader");
	Binding.Insert("SalesReturn__ItemList"      , "StepChangeTaxRate_AgreementInHeader");
	Binding.Insert("SalesReturnOrder__ItemList" , "StepChangeTaxRate_AgreementInHeader");
	Binding.Insert("WorkOrder__ItemList"        , "StepChangeTaxRate_AgreementInHeader");
	
	Return BindSteps("BindVoid", "", Binding, Parameters, "BindCommandDefaultTaxRate");
EndFunction

// RecalculateWhenTaxsesContentChanged.Command
Procedure CommandRecalculateWhenTaxsesContentChanged(Parameters) Export
	Binding = BindCommandRecalculateWhenTaxsesContentChanged(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// RecalculateWhenTaxsesContentChanged.Bind
Function BindCommandRecalculateWhenTaxsesContentChanged(Parameters)
	Binding = New Structure();
	
	Binding.Insert("BankPayment", "StepPaymentListCalculations_IsTaxRateChanged");
	Binding.Insert("BankReceipt", "StepPaymentListCalculations_IsTaxRateChanged");
	Binding.Insert("CashExpense", "StepPaymentListCalculations_IsTaxRateChanged");
	Binding.Insert("CashPayment", "StepPaymentListCalculations_IsTaxRateChanged");
	Binding.Insert("CashReceipt", "StepPaymentListCalculations_IsTaxRateChanged");
	Binding.Insert("CashRevenue", "StepPaymentListCalculations_IsTaxRateChanged");
	Binding.Insert("EmployeeCashAdvance" , "StepPaymentListCalculations_IsTaxRateChanged");
	Binding.Insert("PurchaseInvoice"     , "StepItemListCalculations_IsTaxRateChanged");
	Binding.Insert("PurchaseOrder"       , "StepItemListCalculations_IsTaxRateChanged");
	Binding.Insert("PurchaseReturn"      , "StepItemListCalculations_IsTaxRateChanged");
	Binding.Insert("PurchaseReturnOrder" , "StepItemListCalculations_IsTaxRateChanged");
	Binding.Insert("RetailReturnReceipt" , "StepItemListCalculations_IsTaxRateChanged");
	Binding.Insert("RetailSalesReceipt"  , "StepItemListCalculations_IsTaxRateChanged");
	Binding.Insert("SalesInvoice"        , "StepItemListCalculations_IsTaxRateChanged");
	Binding.Insert("SalesOrder"          , "StepItemListCalculations_IsTaxRateChanged");
	Binding.Insert("SalesReportFromTradeAgent" , "StepItemListCalculations_IsTaxRateChanged_Without_SpecialOffers");
	Binding.Insert("SalesReportToConsignor"    , "StepItemListCalculations_IsTaxRateChanged_Without_SpecialOffers");
	Binding.Insert("SalesReturn"      , "StepItemListCalculations_IsTaxRateChanged");
	Binding.Insert("SalesReturnOrder" , "StepItemListCalculations_IsTaxRateChanged");
	Binding.Insert("WorkOrder"        , "StepItemListCalculations_IsTaxRateChanged");
	
	Return BindSteps("BindVoid", "", Binding, Parameters, "BindCommandDefaultTaxRate");
EndFunction

#EndRegion

#Region ACCOUNT

// Account.OnChange
Procedure AccountOnChange(Parameters) Export
	RollbackPropertyToValueBeforeChange_Object(Parameters);
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
	DataPath.Insert("BankPayment"   , "Account");
	DataPath.Insert("BankReceipt"   , "Account");
	DataPath.Insert("CashPayment"   , "CashAccount");
	DataPath.Insert("CashReceipt"   , "CashAccount");
	DataPath.Insert("CashExpense"   , "Account");
	DataPath.Insert("CashRevenue"   , "Account");
	DataPath.Insert("CashStatement" , "CashAccount");
	DataPath.Insert("ConsolidatedRetailSales" , "CashAccount");
	
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
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindAccount");
EndFunction

// Account.ChangeCashAccountByCurrency.Step
Procedure StepChangeCashAccountByCurrency(Parameters, Chain) Export
	Chain.ChangeCashAccountByCurrency.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeCashAccountByCurrency.Setter = "SetAccount";
	Options = ModelClientServer_V2.ChangeCashAccountByCurrencyOptions();
	Options.CurrentAccount = GetAccount(Parameters);
	Options.Currency       = GetCurrency(Parameters);
	Options.StepName = "StepChangeCashAccountByCurrency";
	Chain.ChangeCashAccountByCurrency.Options.Add(Options);
EndProcedure

// Account.ChangeCashAccountByTransactionType.Step
Procedure StepChangeCashAccountByTransactionType(Parameters, Chain) Export
	Chain.ChangeCashAccountByTransactionType.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeCashAccountByTransactionType.Setter = "SetAccount";
	Options = ModelClientServer_V2.ChangeCashAccountByTransactionTypeOptions();
	Options.CurrentAccount  = GetAccount(Parameters);
	Options.TransactionType = GetTransactionType(Parameters);
	Options.StepName = "StepChangeCashAccountByTransactionType";
	Chain.ChangeCashAccountByTransactionType.Options.Add(Options);
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
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeCashAccountByCompany.Setter = "SetAccount";
	Options = ModelClientServer_V2.ChangeCashAccountByCompanyOptions();
	Options.Company = GetCompany(Parameters);
	Options.Account = GetAccount(Parameters);
	Options.AccountType = AccountType;
	Options.StepName = "StepChangeCashAccountByCompany";
	Chain.ChangeCashAccountByCompany.Options.Add(Options);
EndProcedure

// Account.ChangeCashAccountByCompany_CashReceipt.Step
Procedure StepChangeCashAccountByCompany_CashReceipt(Parameters, Chain) Export
	Chain.ChangeCashAccountByCompany_CashReceipt.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeCashAccountByCompany_CashReceipt.Setter = "SetAccount";
	Options = ModelClientServer_V2.ChangeCashAccountByCompany_CashReceiptOptions();
	Options.Company = GetCompany(Parameters);
	Options.Account = GetAccount(Parameters);
	Options.TransactionType = GetTransactionType(Parameters);
	Options.StepName = "StepChangeCashAccountByCompany_CashReceipt";
	Chain.ChangeCashAccountByCompany_CashReceipt.Options.Add(Options);
EndProcedure

#EndRegion

#Region ACCOUNT_SENDER

// AccountSender.OnChange
Procedure AccountSenderOnChange(Parameters) Export
	RollbackPropertyToValueBeforeChange_Object(Parameters);
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
	Return BindSteps("StepChangeSendCurrencyByAccount", DataPath, Binding, Parameters, "BindAccountSender");
EndFunction

// AccountSender.ChangeAccountSenderByCompany.Step
Procedure StepChangeAccountSenderByCompany(Parameters, Chain) Export
	Chain.ChangeAccountSenderByCompany.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
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
	RollbackPropertyToValueBeforeChange_Object(Parameters);
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
	Return BindSteps("StepChangeReceiveCurrencyByAccount", DataPath, Binding, Parameters, "BindAccountReceiver");
EndFunction

// AccountReceiver.ChangeAccountReceiverByCompany.Step
Procedure StepChangeAccountReceiverByCompany(Parameters, Chain) Export
	Chain.ChangeAccountReceiverByCompany.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
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
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindTransitAccount");
EndFunction

// TransitAccount.ChangeTransitAccountByAccount.Set
Procedure StepChangeTransitAccountByAccount(Parameters, Chain) Export
	Chain.ChangeTransitAccountByAccount.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
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
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindSendUUID");
EndFunction

// SendUUID.GenerateNewSendUUID.Step
Procedure StepGenerateNewSendUUID(Parameters, Chain) Export
	Chain.GenerateNewSendUUID.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
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
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindReceiveUUID");
EndFunction

// ReceiveUUID.GenerateNewReceiptUUID.Step
Procedure StepGenerateNewReceiptUUID(Parameters, Chain) Export
	Chain.GenerateNewReceiptUUID.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.GenerateNewReceiptUUID.Setter = "SetReceiveUUID";
	Options = ModelClientServer_V2.GenerateNewUUIDOptions();
	Options.Ref = Parameters.Object.Ref;
	Options.CurrentUUID = GetReceiveUUID(Parameters);
	Options.StepName = "StepGenerateNewReceiptUUID";
	Chain.GenerateNewReceiptUUID.Options.Add(Options);
EndProcedure

#EndRegion

#Region SHIPMENT_MODE

// ShipmentMode.Set
Procedure SetShipmentMode(Parameters, Results) Export
	Binding = BindShipmentMode(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ShipmentMode.Get
Function GetShipmentMode(Parameters)
	Return GetPropertyObject(Parameters, BindShipmentMode(Parameters).DataPath);
EndFunction

// ShipmentMode.Bind
Function BindShipmentMode(Parameters)
	DataPath = "ShipmentMode";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindShipmentMode");
EndFunction

// ShipmentMode.ChangeShipmentModeByTransactionType.Step
Procedure StepChangeShipmentModeByTransactionType(Parameters, Chain) Export
	Chain.ChangeShipmentModeByTransactionType.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeShipmentModeByTransactionType.Setter = "SetShipmentMode";
	Options = ModelClientServer_V2.ChangeShipmentModeByTransactionTypeOptions();
	Options.TransactionType       = GetTransactionType(Parameters);
	Options.CurrentShipmentMode   = GetShipmentMode(Parameters);
	Options.StepName = "StepChangeShipmentModeByTransactionType";
	Chain.ChangeShipmentModeByTransactionType.Options.Add(Options);
EndProcedure

#EndRegion

#Region TRANSACTION_TYPE

// TransactionType.OnChange
Procedure TransactionTypeOnChange(Parameters) Export
	RollbackPropertyToValueBeforeChange_Object(Parameters);
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
	Binding = BindTransactionType(Parameters);
	If Not ValueIsFilled(Binding.DataPath) Then
		Return Undefined; // default value
	EndIf;
	Return GetPropertyObject(Parameters, Binding.DataPath);
EndFunction

// TransactionType.Bind
Function BindTransactionType(Parameters)
	DataPath = New Map();
	DataPath.Insert("BankPayment",          "TransactionType");
	DataPath.Insert("BankReceipt",          "TransactionType");
	DataPath.Insert("CashExpense",          "TransactionType");
	DataPath.Insert("CashPayment",          "TransactionType");
	DataPath.Insert("CashReceipt",          "TransactionType");
	DataPath.Insert("CashRevenue",          "TransactionType");
	DataPath.Insert("GoodsReceipt",         "TransactionType");
	DataPath.Insert("IncomingPaymentOrder", "TransactionType");
	DataPath.Insert("OutgoingPaymentOrder", "TransactionType");
	DataPath.Insert("PurchaseInvoice",      "TransactionType");
	DataPath.Insert("PurchaseOrder",        "TransactionType");
	DataPath.Insert("PurchaseOrderClosing", "TransactionType");
	DataPath.Insert("PurchaseReturn",       "TransactionType");
	DataPath.Insert("PurchaseReturnOrder",  "TransactionType");
	DataPath.Insert("SalesInvoice",         "TransactionType");
	DataPath.Insert("SalesOrder",           "TransactionType");
	DataPath.Insert("SalesOrderClosing",    "TransactionType");
	DataPath.Insert("SalesReturn",          "TransactionType");
	DataPath.Insert("SalesReturnOrder",     "TransactionType");
	DataPath.Insert("ShipmentConfirmation", "TransactionType");
	DataPath.Insert("RetailShipmentConfirmation", "TransactionType");
	DataPath.Insert("RetailGoodsReceipt",         "TransactionType");
		
	Binding = New Structure();
	Binding.Insert("BankPayment",
		"StepChangeTransitAccountByAccount,
		|StepClearByTransactionTypeBankPayment,
		|StepRequireCallCreateTaxesFormControls, 
		|StepChangeTaxRate_AgreementInList");
		
	Binding.Insert("BankReceipt",
		"StepChangeTransitAccountByAccount,
		|StepClearByTransactionTypeBankReceipt,
		|StepRequireCallCreateTaxesFormControls, 
		|StepChangeTaxRate_AgreementInList");
		
	Binding.Insert("CashPayment", 
		"StepClearByTransactionTypeCashPayment,
		|StepRequireCallCreateTaxesFormControls, 
		|StepChangeTaxRate_AgreementInList");
		
	Binding.Insert("CashReceipt", 
		"StepClearByTransactionTypeCashReceipt,
		|StepChangeCashAccountByTransactionType,
		|StepRequireCallCreateTaxesFormControls, 
		|StepChangeTaxRate_AgreementInList");
		
	Binding.Insert("CashExpense", 
		"StepClearByTransactionTypeCashExpenseRevenue,
		|StepRequireCallCreateTaxesFormControls, 
		|StepChangeTaxRate_WithoutAgreement");
		
	Binding.Insert("CashRevenue", 
		"StepClearByTransactionTypeCashExpenseRevenue,
		|StepRequireCallCreateTaxesFormControls, 
		|StepChangeTaxRate_WithoutAgreement");
		
	Binding.Insert("OutgoingPaymentOrder",
		"StepClearByTransactionTypeOutgoingPaymentOrder");
	
	Binding.Insert("ShipmentConfirmation"  , "StepChangePartnerByTransactionType");
	Binding.Insert("GoodsReceipt"          , "StepChangePartnerByTransactionType");
	
	Binding.Insert("RetailShipmentConfirmation", 
		"StepChangeCourierByTransactionType");
	
	Binding.Insert("RetailGoodsReceipt", 
		"StepChangeCourierByTransactionType");
	
	Binding.Insert("PurchaseInvoice", 
		"StepChangePartnerByTransactionType,
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");
	
	Binding.Insert("PurchaseOrder", 
		"StepChangePartnerByTransactionType,
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");
	
	Binding.Insert("PurchaseReturn", 
		"StepChangePartnerByTransactionType,
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");
	
	Binding.Insert("PurchaseReturnOrder", 
		"StepChangePartnerByTransactionType,
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");
	
	Binding.Insert("SalesInvoice", 
		"StepChangePartnerByTransactionType,
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");
	
	Binding.Insert("SalesOrder", 
		"StepChangePartnerByTransactionType,
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader,
		|StepChangeShipmentModeByTransactionType");
	
	Binding.Insert("SalesReturn", 
		"StepChangePartnerByTransactionType,
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");
	
	Binding.Insert("SalesReturnOrder", 
		"StepChangePartnerByTransactionType,
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindTransactionType");
EndFunction

// TransactionType.BankPayment.MultiSet
Procedure MultiSetTransactionType_BankPayment(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Partner"                  , BindPaymentListPartner(Parameters));
	ResourceToBinding.Insert("Payee"                    , BindPaymentListLegalName(Parameters));
	ResourceToBinding.Insert("Agreement"                , BindPaymentListAgreement(Parameters));
	ResourceToBinding.Insert("LegalNameContract"        , BindPaymentListLegalNameContract(Parameters));
	ResourceToBinding.Insert("BasisDocument"            , BindPaymentListBasisDocument(Parameters));
	ResourceToBinding.Insert("PlanningTransactionBasis" , BindPaymentListPlanningTransactionBasis(Parameters));
	ResourceToBinding.Insert("Order"                    , BindPaymentListOrder(Parameters));
	ResourceToBinding.Insert("TransitAccount"           , BindTransitAccount(Parameters));
	ResourceToBinding.Insert("PaymentType"              , BindPaymentListPaymentType(Parameters));
	ResourceToBinding.Insert("PaymentTerminal"          , BindPaymentListPaymentTerminal(Parameters));
	ResourceToBinding.Insert("BankTerm"                 , BindPaymentListBankTerm(Parameters));
	ResourceToBinding.Insert("RetailCustomer"           , BindPaymentListRetailCustomer(Parameters));
	ResourceToBinding.Insert("Employee"                 , BindPaymentListEmployee(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// TransactionType.BankReceipt.MultiSet
Procedure MultiSetTransactionType_BankReceipt(Parameters, Results) Export
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
	ResourceToBinding.Insert("PaymentType"              , BindPaymentListPaymentType(Parameters));
	ResourceToBinding.Insert("PaymentTerminal"          , BindPaymentListPaymentTerminal(Parameters));
	ResourceToBinding.Insert("BankTerm"                 , BindPaymentListBankTerm(Parameters));
	ResourceToBinding.Insert("CommissionIsSeparate"     , BindPaymentListCommissionIsSeparate(Parameters));
	ResourceToBinding.Insert("RetailCustomer"           , BindPaymentListRetailCustomer(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// TransactionType.CashPayment.MultiSet
Procedure MultiSetTransactionType_CashPayment(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Partner"                  , BindPaymentListPartner(Parameters));
	ResourceToBinding.Insert("Payee"                    , BindPaymentListLegalName(Parameters));
	ResourceToBinding.Insert("Agreement"                , BindPaymentListAgreement(Parameters));
	ResourceToBinding.Insert("LegalNameContract"        , BindPaymentListLegalNameContract(Parameters));
	ResourceToBinding.Insert("BasisDocument"            , BindPaymentListBasisDocument(Parameters));
	ResourceToBinding.Insert("PlanningTransactionBasis" , BindPaymentListPlanningTransactionBasis(Parameters));
	ResourceToBinding.Insert("Order"                    , BindPaymentListOrder(Parameters));
	ResourceToBinding.Insert("RetailCustomer"           , BindPaymentListRetailCustomer(Parameters));
	ResourceToBinding.Insert("Employee"                 , BindPaymentListEmployee(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// TransactionType.CashReceipt.MultiSet
Procedure MultiSetTransactionType_CashReceipt(Parameters, Results) Export
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
	ResourceToBinding.Insert("MoneyTransfer"            , BindPaymentListMoneyTransfer(Parameters));
	ResourceToBinding.Insert("RetailCustomer"           , BindPaymentListRetailCustomer(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// TransactionType.OutgoingPaymentOrder.MultiSet
Procedure MultiSetTransactionType_OutgoingPaymentOrder(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Partner"            , BindPaymentListPartner(Parameters));
	ResourceToBinding.Insert("PartnerBankAccount" , BindPaymentListPartnerBankAccount(Parameters));	
	ResourceToBinding.Insert("Payee"              , BindPaymentListLegalName(Parameters));
	ResourceToBinding.Insert("BasisDocument"      , BindPaymentListBasisDocument(Parameters));
	
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// TransactionType.CashExpenseRevenue.MultiSet
Procedure MultiSetTransactionType_CashExpenseRevenue(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Partner"       , BindPaymentListPartner(Parameters));
	ResourceToBinding.Insert("OtherCompany"  , BindOtherCompany(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// TransactionType.ClearByTransactionTypeBankPayment.Step
Procedure StepClearByTransactionTypeBankPayment(Parameters, Chain) Export
	Chain.ClearByTransactionTypeBankPayment.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ClearByTransactionTypeBankPayment.Setter = "MultiSetTransactionType_BankPayment";
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
		Options.PaymentType              = GetPaymentListPaymentType(Parameters, Row.Key);
		Options.PaymentTerminal          = GetPaymentListPaymentTerminal(Parameters, Row.Key);
		Options.BankTerm                 = GetPaymentListBankTerm(Parameters, Row.Key);
		Options.RetailCustomer           = GetPaymentListRetailCustomer(Parameters, Row.Key);
		Options.Employee                 = GetPaymentListEmployee(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepClearByTransactionTypeBankPayment";
		Chain.ClearByTransactionTypeBankPayment.Options.Add(Options);
	EndDo;
EndProcedure

// TransactionType.ClearByTransactionTypeBankReceipt.Step
Procedure StepClearByTransactionTypeBankReceipt(Parameters, Chain) Export
	Chain.ClearByTransactionTypeBankReceipt.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ClearByTransactionTypeBankReceipt.Setter = "MultiSetTransactionType_BankReceipt";
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
		Options.PaymentType              = GetPaymentListPaymentType(Parameters, Row.Key);
		Options.PaymentTerminal          = GetPaymentListPaymentTerminal(Parameters, Row.Key);
		Options.BankTerm                 = GetPaymentListBankTerm(Parameters, Row.Key);
		Options.CommissionIsSeparate     = GetPaymentListCommissionIsSeparate(Parameters, Row.Key);
		Options.RetailCustomer           = GetPaymentListRetailCustomer(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepClearByTransactionTypeBankReceipt";
		Chain.ClearByTransactionTypeBankReceipt.Options.Add(Options);
	EndDo;
EndProcedure

// TransactionType.ClearByTransactionTypeCashPayment.Step
Procedure StepClearByTransactionTypeCashPayment(Parameters, Chain) Export
	Chain.ClearByTransactionTypeCashPayment.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ClearByTransactionTypeCashPayment.Setter = "MultiSetTransactionType_CashPayment";
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
		Options.RetailCustomer           = GetPaymentListRetailCustomer(Parameters, Row.Key);
		Options.Employee                 = GetPaymentListEmployee(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepClearByTransactionTypeCashPayment";
		Chain.ClearByTransactionTypeCashPayment.Options.Add(Options);
	EndDo;
EndProcedure

// TransactionType.ClearByTransactionTypeCashReceipt.Step
Procedure StepClearByTransactionTypeCashReceipt(Parameters, Chain) Export
	Chain.ClearByTransactionTypeCashReceipt.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ClearByTransactionTypeCashReceipt.Setter = "MultiSetTransactionType_CashReceipt";
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
		Options.MoneyTransfer            = GetPaymentListMoneyTransfer(Parameters, Row.Key);
		Options.RetailCustomer           = GetPaymentListRetailCustomer(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepClearByTransactionTypeCashReceipt";
		Chain.ClearByTransactionTypeCashReceipt.Options.Add(Options);
	EndDo;
EndProcedure

// TransactionType.ClearByTransactionTypeOutgoingPaymentOrder.Step
Procedure StepClearByTransactionTypeOutgoingPaymentOrder(Parameters, Chain) Export
	Chain.ClearByTransactionTypeOutgoingPaymentOrder.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ClearByTransactionTypeOutgoingPaymentOrder.Setter = "MultiSetTransactionType_OutgoingPaymentOrder";
		
	For Each Row In GetRows(Parameters, "PaymentList") Do
		Options = ModelClientServer_V2.ClearByTransactionTypeOutgoingPaymentOrderOptions();
		Options.TransactionType    = GetTransactionType(Parameters);
		Options.Partner            = GetPaymentListPartner(Parameters, Row.Key);
		Options.PartnerBankAccount = GetPaymentListPartnerBankAccount(Parameters, Row.Key);
		Options.Payee              = GetPaymentListLegalName(Parameters, Row.Key);
		Options.BasisDocument      = GetPaymentListBasisDocument(Parameters, Row.Key);
		
		Options.Key = Row.Key;
		Options.StepName = "StepClearByTransactionTypeOutgoingPaymentOrder";
		Chain.ClearByTransactionTypeOutgoingPaymentOrder.Options.Add(Options);
	EndDo;
EndProcedure

// TransactionType.ClearByTransactionTypeCashExpenseRevenue.Step
Procedure StepClearByTransactionTypeCashExpenseRevenue(Parameters, Chain) Export
	Chain.ClearByTransactionTypeCashExpenseRevenue.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ClearByTransactionTypeCashExpenseRevenue.Setter = "MultiSetTransactionType_CashExpenseRevenue";
	For Each Row In GetRows(Parameters, "PaymentList") Do
		Options = ModelClientServer_V2.ClearByTransactionTypeCashExpenseRevenueOptions();
		Options.TransactionType          = GetTransactionType(Parameters);
		Options.OtherCompany             = GetOtherCompany(Parameters);
		Options.Partner                  = GetPaymentListPartner(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepClearByTransactionTypeCashExpenseRevenue";
		Chain.ClearByTransactionTypeCashExpenseRevenue.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region CURRENCY

// Currency.OnChange
Procedure CurrencyOnChange(Parameters) Export
	RollbackPropertyToValueBeforeChange_Object(Parameters);
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
	
	Binding.Insert("SalesOrder",
		"StepItemListChangePriceByPriceType");
	
	Binding.Insert("WorkOrder",
		"StepItemListChangePriceByPriceType");
	
	Binding.Insert("SalesInvoice",
		"StepItemListChangePriceByPriceType");
	
	Binding.Insert("PurchaseReturnOrder",
		"StepItemListChangePriceByPriceType");
	
	Binding.Insert("PurchaseReturn",
		"StepItemListChangePriceByPriceType");
	
	Binding.Insert("RetailSalesReceipt",
		"StepItemListChangePriceByPriceType");
	
	Binding.Insert("RetailReturnReceipt",
		"StepItemListChangePriceByPriceType");
	
	Binding.Insert("PurchaseOrder",
		"StepItemListChangePriceByPriceType");
	
	Binding.Insert("PurchaseInvoice",
		"StepItemListChangePriceByPriceType");
	
	Binding.Insert("SalesReportFromTradeAgent",
		"StepItemListChangePriceByPriceType");
	
	Binding.Insert("SalesReportToConsignor",
		"StepItemListChangePriceByPriceType");
	
	Binding.Insert("SalesReturnOrder",
		"StepItemListChangePriceByPriceType");

	Binding.Insert("SalesReturn",
		"StepItemListChangePriceByPriceType");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindCurrency");
EndFunction

// Currency.ChangeCurrencyByAccount.[CurrencyInList].Step
Procedure StepChangeCurrencyByAccount_CurrencyInList(Parameters, Chain) Export
	Chain.ChangeCurrencyByAccount.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
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
	If Chain.Idle Then
		Return;
	EndIf;
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
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeCurrencyByAgreement.Setter = "SetCurrency";
	Options = ModelClientServer_V2.ChangeCurrencyByAgreementOptions();
	Options.Agreement       = GetAgreement(Parameters);
	Options.CurrentCurrency = GetCurrency(Parameters);
	Options.StepName = "StepChangeCurrencyByAgreement";
	Chain.ChangeCurrencyByAgreement.Options.Add(Options);
EndProcedure

// Currency.ChangeLandedCostCurrencyByCompany.Step
Procedure StepChangeLandedCostCurrencyByCompany(Parameters, Chain) Export
	Chain.ChangeLandedCostCurrencyByCompany.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeLandedCostCurrencyByCompany.Setter = "SetCurrency";
	Options = ModelClientServer_V2.ChangeLandedCostCurrencyByCompanyOptions();
	Options.Company         = GetCompany(Parameters);
	Options.CurrentCurrency = GetCurrency(Parameters);
	Options.StepName = "StepChangeLandedCostCurrencyByCompany";
	Chain.ChangeLandedCostCurrencyByCompany.Options.Add(Options);
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
	Binding.Insert("CashTransferOrder", "StepChangeReceiveAmountBySendAmount");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindReceiveCurrency");
EndFunction

// ReceiveCurrency.ChangeCurrencyByAccount.Step
Procedure StepChangeReceiveCurrencyByAccount(Parameters, Chain) Export
	Chain.ChangeCurrencyByAccount.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
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
	Binding.Insert("CashTransferOrder", "StepChangeReceiveAmountBySendAmount");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindSendCurrency");
EndFunction

// SendCurrency.ChangeCurrencyByAccount.Step
Procedure StepChangeSendCurrencyByAccount(Parameters, Chain) Export
	Chain.ChangeCurrencyByAccount.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
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
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindCurrencyExchange");
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
	Binding.Insert("CashTransferOrder" , "StepChangeReceiveAmountBySendAmount");
	Binding.Insert("MoneyTransfer"     , "StepChangeReceiveAmountBySendAmount");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindSendAmount");
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
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindReceiveAmount");
EndFunction

// ReceiveAmount.ChangeReceiveAmountBySendAmount.Step
Procedure StepChangeReceiveAmountBySendAmount(Parameters, Chain) Export
	Chain.ChangeReceiveAmountBySendAmount.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeReceiveAmountBySendAmount.Setter = "SetReceiveAmount";
	Options = ModelClientServer_V2.ChangeReceiveAmountBySendAmountOptions();
	Options.SendAmount      = GetSendAmount(Parameters);
	Options.ReceiveAmount   = GetReceiveAmount(Parameters);
	Options.SendCurrency    = GetSendCurrency(Parameters);
	Options.ReceiveCurrency = GetReceiveCurrency(Parameters);
	Options.StepName = "StepChangeReceiveAmountBySendAmount";
	Chain.ChangeReceiveAmountBySendAmount.Options.Add(Options);
EndProcedure

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
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindSendFinancialMovementType");
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
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindReceiveFinancialMovementType");
EndFunction

#EndRegion

#Region CASH_TRANSFER_ORDER

// CashTransferOrder.OnChange
Procedure CashTransferOrderOnChange(Parameters) Export
	RollbackPropertyToValueBeforeChange_Object(Parameters);
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
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindCashTransferOrder");
EndFunction

// CashTransferOrder.MoneyTransfer.MultiSet
Procedure MultiSetCashTransferOrder_MoneyTransfer(Parameters, Results) Export
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
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.FillByCashTransferOrder.Setter = "MultiSetCashTransferOrder_MoneyTransfer";
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
	RollbackPropertyToValueBeforeChange_Object(Parameters);
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
	Binding.Insert("SalesOrder",
		"StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType,
		|StepChangeDeliveryDateByAgreement,
		|StepChangeAgreementByPartner_AgreementTypeByTransactionType, 
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader,
		|StepUpdatePaymentTerms");
	
	Binding.Insert("WorkOrder",
		"StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType,
		|StepChangeAgreementByPartner_AgreementTypeIsCustomer, 
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");
	
	Binding.Insert("SalesInvoice",
		"StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType,
		|StepChangeDeliveryDateByAgreement,
		|StepChangeAgreementByPartner_AgreementTypeIsCustomer, 
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader,
		|StepUpdatePaymentTerms,
		|StepConsignorBatchesFillBatches");

	Binding.Insert("RetailSalesReceipt",
		"StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType,
		|StepChangeAgreementByPartner_AgreementTypeIsCustomer, 
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader,
		|StepConsignorBatchesFillBatches");

	Binding.Insert("InventoryTransfer", "StepConsignorBatchesFillBatches_StoreSender");

	Binding.Insert("SalesReturnOrder",
		"StepChangeAgreementByPartner_AgreementTypeByTransactionType, 
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");

	Binding.Insert("SalesReturn",
		"StepChangeAgreementByPartner_AgreementTypeByTransactionType, 
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");

	Binding.Insert("PurchaseReturnOrder",
		"StepChangeAgreementByPartner_AgreementTypeByTransactionType, 
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");

	Binding.Insert("PurchaseReturn",
		"StepChangeAgreementByPartner_AgreementTypeByTransactionType, 
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");

	Binding.Insert("RetailReturnReceipt",
		"StepChangeAgreementByPartner_AgreementTypeIsCustomer, 
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader,
		|StepChangeConsolidatedRetailSalesByWorkstation");

	Binding.Insert("PurchaseOrder",
		"StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType,
		|StepChangeDeliveryDateByAgreement,
		|StepChangeAgreementByPartner_AgreementTypeByTransactionType, 
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader,
		|StepUpdatePaymentTerms");

	Binding.Insert("PurchaseInvoice",
		"StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType,
		|StepChangeDeliveryDateByAgreement,
		|StepChangeAgreementByPartner_AgreementTypeByTransactionType, 
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader,
		|StepUpdatePaymentTerms");
	
	Binding.Insert("SalesReportFromTradeAgent",
		"StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType, 
		|StepChangeAgreementByPartner_AgreementTypeIsTradeAgent, 
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");
	
	Binding.Insert("SalesReportToConsignor",
		"StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType,
		|StepChangeAgreementByPartner_AgreementTypeIsConsignor, 
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");
		
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
		|StepChangeTaxRate_AgreementInList,
		|StepChangeConsolidatedRetailSalesByWorkstation");

	Binding.Insert("CashExpense",
		"StepRequireCallCreateTaxesFormControls, 
		|StepChangeTaxRate_WithoutAgreement");
	
	Binding.Insert("CashRevenue",
		"StepRequireCallCreateTaxesFormControls, 
		|StepChangeTaxRate_WithoutAgreement");
		
	Binding.Insert("MoneyTransfer",
		"StepChangeConsolidatedRetailSalesByWorkstation");

	Binding.Insert("EmployeeCashAdvance",
		"StepRequireCallCreateTaxesFormControls, 
		|StepChangeTaxRate_WithoutAgreement");
		
	Binding.Insert("ProductionPlanning", 
		"StepChangePlanningPeriodByDateAndBusinessUnit");
		
	Binding.Insert("ProductionPlanningCorrection", 
		"StepChangePlanningPeriodByDateAndBusinessUnit");

	Binding.Insert("Production", 
		"StepChangePlanningPeriodByDateAndBusinessUnit");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindDate");
EndFunction

#EndRegion

#Region COMPANY

// Company.OnChange
Procedure CompanyOnChange(Parameters) Export
	RollbackPropertyToValueBeforeChange_Object(Parameters);
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
	Binding.Insert("SalesOrder",
		"StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader,
		|StepItemListChangeRevenueTypeByItemKey");
	
	Binding.Insert("WorkOrder",
		"StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");
	
	Binding.Insert("SalesInvoice",
		"StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader,
		|StepItemListChangeRevenueTypeByItemKey,
		|StepConsignorBatchesFillBatches");

	Binding.Insert("RetailSalesReceipt",
		"StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader,
		|StepItemListChangeRevenueTypeByItemKey,
		|StepChangeConsolidatedRetailSalesByWorkstation,
		|StepConsignorBatchesFillBatches");

	Binding.Insert("InventoryTransfer", "StepConsignorBatchesFillBatches_StoreSender");

	Binding.Insert("PurchaseOrder",
		"StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader,
		|StepItemListChangeExpenseTypeByItemKey");
	
	Binding.Insert("PurchaseInvoice",
		"StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader,
		|StepItemListChangeExpenseTypeByItemKey");
	
	Binding.Insert("SalesReportFromTradeAgent",
		"StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader,
		|StepItemListChangeTradeAgentFeeAmountByTradeAgentFeeType");
	
	Binding.Insert("SalesReportToConsignor",
		"StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader,
		|StepItemListChangeTradeAgentFeeAmountByTradeAgentFeeType");
	
	Binding.Insert("SalesReturnOrder",
		"StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader,
		|StepItemListChangeRevenueTypeByItemKey");
	
	Binding.Insert("SalesReturn",
		"StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader,
		|StepItemListChangeRevenueTypeByItemKey");
	
	Binding.Insert("PurchaseReturnOrder",
		"StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader,
		|StepItemListChangeExpenseTypeByItemKey");
	
	Binding.Insert("PurchaseReturn",
		"StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader,
		|StepItemListChangeExpenseTypeByItemKey");
	
	Binding.Insert("RetailReturnReceipt",
		"StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader,
		|StepItemListChangeRevenueTypeByItemKey,
		|StepChangeConsolidatedRetailSalesByWorkstation");
	
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
		|StepChangeCashAccountByCompany_CashReceipt");
	
	Binding.Insert("CashExpense",
		"StepRequireCallCreateTaxesFormControls, 
		|StepChangeTaxRate_WithoutAgreement,
		|StepChangeCashAccountByCompany_AccountTypeIsCash");

	Binding.Insert("CashRevenue",
		"StepRequireCallCreateTaxesFormControls, 
		|StepChangeTaxRate_WithoutAgreement,
		|StepChangeCashAccountByCompany_AccountTypeIsCash");
	
	Binding.Insert("EmployeeCashAdvance",
		"StepRequireCallCreateTaxesFormControls, 
		|StepChangeTaxRate_WithoutAgreement");
	
	Binding.Insert("MoneyTransfer",
		"StepChangeAccountSenderByCompany,
		|StepChangeAccountReceiverByCompany,
		|StepChangeConsolidatedRetailSalesByWorkstation");

	Binding.Insert("CashTransferOrder",
		"StepChangeAccountSenderByCompany,
		|StepChangeAccountReceiverByCompany");
	
	Binding.Insert("StockAdjustmentAsSurplus",
		"StepChangeLandedCostCurrencyByCompany");
	
	Binding.Insert("StockAdjustmentAsWriteOff",
		"StepChangeLandedCostCurrencyByCompany");
	
	Binding.Insert("ProductionPlanningCorrection",
		"StepChangeProductionPlanningByPlanningPeriod,
		|StepChangeCurrentQuantityInProductions");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindCompany");
EndFunction

// Company.ChangeCompanyByAgreement.Step
Procedure StepChangeCompanyByAgreement(Parameters, Chain) Export
	Chain.ChangeCompanyByAgreement.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeCompanyByAgreement.Setter = "SetCompany";
	Options = ModelClientServer_V2.ChangeCompanyByAgreementOptions();
	Options.Agreement      = GetAgreement(Parameters);
	Options.CurrentCompany = GetCompany(Parameters);
	Options.StepName = "StepChangeCompanyByAgreement";
	Chain.ChangeCompanyByAgreement.Options.Add(Options);
EndProcedure

#EndRegion

#Region OTHER_COMPANY

// OtherCompany.Set
Procedure SetOtherCompany(Parameters, Results) Export
	Binding = BindOtherCompany(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// OtherCompany.Get
Function GetOtherCompany(Parameters)
	Return GetPropertyObject(Parameters, BindOtherCompany(Parameters).DataPath);
EndFunction

// OtherCompany.Bind
Function BindOtherCompany(Parameters)
	DataPath = "OtherCompany";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindOtherCompany");
EndFunction

#EndRegion

#Region BRANCH

// Branch.OnChange
Procedure BranchOnChange(Parameters) Export
	AddViewNotify("OnSetBranchNotify", Parameters);
	Binding = BindPartner(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Branch.Set
Procedure SetBranch(Parameters, Results) Export
	Binding = BindBranch(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetBranchNotify");
EndProcedure

// Branch.Get
Function GetBranch(Parameters)
	Return GetPropertyObject(Parameters, BindBranch(Parameters).DataPath);
EndFunction

// Branch.Bind
Function BindBranch(Parameters)
	DataPath = "Branch";
	Binding = New Structure();
	Binding.Insert("RetailSalesReceipt", "StepChangeConsolidatedRetailSalesByWorkstation");
	Binding.Insert("RetailReturnReceipt", "StepChangeConsolidatedRetailSalesByWorkstation");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindBranch");
EndFunction

#EndRegion

#Region TRADE_AGENT_FEE_TYPE

// TradeAgentFeeType.OnChange
Procedure TradeAgentFeeTypeOnChange(Parameters) Export
	RollbackPropertyToValueBeforeChange_Object(Parameters);
	AddViewNotify("OnSetTradeAgentFeeTypeNotify", Parameters);
	Binding = BindTradeAgentFeeType(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// TradeAgentFeeType.Set
Procedure SetTradeAgentFeeType(Parameters, Results) Export
	Binding = BindTradeAgentFeeType(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetTradeAgentFeeTypeNotify");
EndProcedure

// TradeAgentFeeType.Get
Function GetTradeAgentFeeType(Parameters)
	Return GetPropertyObject(Parameters, BindTradeAgentFeeType(Parameters).DataPath);
EndFunction

// TradeAgentFeeType.Bind
Function BindTradeAgentFeeType(Parameters)
	DataPath = "TradeAgentFeeType";
	Binding = New Structure();
	Binding.Insert("SalesReportFromTradeAgent", 
		"StepItemListChangeTradeAgentFeeAmountByTradeAgentFeeType,
		|StepItemListChangeTradeAgentFeePercentByAgreement");
	
	Binding.Insert("SalesReportToConsignor",
		"StepItemListChangeTradeAgentFeeAmountByTradeAgentFeeType,
		|StepItemListChangeTradeAgentFeePercentByAgreement");
		
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindTradeAgentFeeType");
EndFunction

// TradeAgentFeeType.ChangeTradeAgentFeeTypeByAgreement.Step
Procedure StepChangeTradeAgentFeeTypeByAgreement(Parameters, Chain) Export
	Chain.ChangeTradeAgentFeeTypeByAgreement.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeTradeAgentFeeTypeByAgreement.Setter = "SetTradeAgentFeeType";
	Options = ModelClientServer_V2.ChangeTradeAgentFeeTypeByAgreementOptions();
	Options.Agreement = GetAgreement(Parameters);
	Options.CurrentFeeType = GetTradeAgentFeeType(Parameters);
	Options.StepName = "StepChangeTradeAgentFeeTypeByAgreement";
	Chain.ChangeTradeAgentFeeTypeByAgreement.Options.Add(Options);
EndProcedure

#EndRegion

#Region PARTNER

// Partner.OnChange
Procedure PartnerOnChange(Parameters) Export
	RollbackPropertyToValueBeforeChange_Object(Parameters);
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
	
	Binding.Insert("SalesOrder",
		"StepChangeAgreementByPartner_AgreementTypeByTransactionType,
		|StepChangeLegalNameByPartner,
		|StepChangeManagerSegmentByPartner");
	
	Binding.Insert("WorkOrder",
		"StepChangeAgreementByPartner_AgreementTypeIsCustomer,
		|StepChangeLegalNameByPartner");
	
	Binding.Insert("WorkSheet", "StepChangeLegalNameByPartner");
	
	Binding.Insert("SalesInvoice",
		"StepChangeAgreementByPartner_AgreementTypeByTransactionType,
		|StepChangeLegalNameByPartner,
		|StepChangeManagerSegmentByPartner");

	Binding.Insert("RetailSalesReceipt",
		"StepChangeAgreementByPartner_AgreementTypeIsCustomer,
		|StepChangeLegalNameByPartner,
		|StepChangeManagerSegmentByPartner");

	Binding.Insert("PurchaseOrder",
		"StepChangeAgreementByPartner_AgreementTypeByTransactionType,
		|StepChangeLegalNameByPartner");
	
	Binding.Insert("PurchaseInvoice",
		"StepChangeAgreementByPartner_AgreementTypeByTransactionType,
		|StepChangeLegalNameByPartner");
	
	Binding.Insert("SalesReportFromTradeAgent",
		"StepChangeAgreementByPartner_AgreementTypeIsTradeAgent,
		|StepChangeLegalNameByPartner");
	
	Binding.Insert("SalesReportToConsignor",
		"StepChangeAgreementByPartner_AgreementTypeIsConsignor,
		|StepChangeLegalNameByPartner");
	
	Binding.Insert("RetailReturnReceipt",
		"StepChangeAgreementByPartner_AgreementTypeIsCustomer,
		|StepChangeLegalNameByPartner");
	
	Binding.Insert("PurchaseReturnOrder",
		"StepChangeAgreementByPartner_AgreementTypeByTransactionType,
		|StepChangeLegalNameByPartner");
	
	Binding.Insert("PurchaseReturn",
		"StepChangeAgreementByPartner_AgreementTypeByTransactionType,
		|StepChangeLegalNameByPartner");
	
	Binding.Insert("SalesReturnOrder",
		"StepChangeAgreementByPartner_AgreementTypeByTransactionType,
		|StepChangeLegalNameByPartner");
	
	Binding.Insert("SalesReturn",
		"StepChangeAgreementByPartner_AgreementTypeByTransactionType,
		|StepChangeLegalNameByPartner");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPartner");
EndFunction

// Partner.ChangePartnerByRetailCustomer.Step
Procedure StepChangePartnerByRetailCustomer(Parameters, Chain) Export
	Chain.ChangePartnerByRetailCustomer.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangePartnerByRetailCustomer.Setter = "SetPartner";
	Options = ModelClientServer_V2.ChangePartnerByRetailCustomerOptions();
	Options.RetailCustomer = GetRetailCustomer(Parameters);
	Options.StepName = "StepChangePartnerByRetailCustomer";
	Chain.ChangePartnerByRetailCustomer.Options.Add(Options);
EndProcedure

// Partner.ChangePartnerByTransactionType.Step
Procedure StepChangePartnerByTransactionType(Parameters, Chain) Export
	Chain.ChangePartnerByTransactionType.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangePartnerByTransactionType.Setter = "SetPartner";
	Options = ModelClientServer_V2.ChangePartnerByTransactionTypeOptions();
	Options.TransactionType = GetTransactionType(Parameters);
	Options.Partner         = GetPartner(Parameters);
	Options.StepName = "StepChangePartnerByTransactionType";
	Chain.ChangePartnerByTransactionType.Options.Add(Options);
EndProcedure

#EndRegion

#Region PARTNER_TRADE_AGENT

// PartnerTradeAgent.OnChange
Procedure PartnerTradeAgentOnChange(Parameters) Export
	Binding = BindPartnerTradeAgent(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PartnerTradeAgent.Set
Procedure SetPartnerTradeAgent(Parameters, Results) Export
	Binding = BindPartnerTradeAgent(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PartnerTradeAgent.Get
Function GetPartnerTradeAgent(Parameters)
	Return GetPropertyObject(Parameters, BindPartnerTradeAgent(Parameters).DataPath);
EndFunction

// PartnerTradeAgent.Bind
Function BindPartnerTradeAgent(Parameters)
	DataPath = "PartnerTradeAgent";
	Binding = New Structure();
	
	Binding.Insert("OpeningEntry",
		"StepChangeAgreementTradeAgentByPartner,
		|StepChangeLegalNameTradeAgentByPartner");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPartnerTradeAgent");
EndFunction

#EndRegion

#Region PARTNER_CONSIGNOR

// PartnerConsignor.OnChange
Procedure PartnerConsignorOnChange(Parameters) Export
	Binding = BindPartnerConsignor(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PartnerConsignor.Set
Procedure SetPartnerConsignor(Parameters, Results) Export
	Binding = BindPartnerConsignor(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PartnerConsignor.Get
Function GetPartnerConsignor(Parameters)
	Return GetPropertyObject(Parameters, BindPartnerConsignor(Parameters).DataPath);
EndFunction

// PartnerConsignor.Bind
Function BindPartnerConsignor(Parameters)
	DataPath = "PartnerConsignor";
	Binding = New Structure();
	
	Binding.Insert("OpeningEntry",
		"StepChangeAgreementConsignorByPartner,
		|StepChangeLegalNameConsignorByPartner");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPartnerConsignor");
EndFunction

#EndRegion

#Region COURIER

// Courier.OnChange
Procedure CourierOnChange(Parameters) Export
	AddViewNotify("OnSetCourierNotify", Parameters);
	Binding = BindCourier(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Courier.Set
Procedure SetCourier(Parameters, Results) Export
	Binding = BindCourier(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetCourierNotify");
EndProcedure

// Courier.Get
Function GetCourier(Parameters)
	Return GetPropertyObject(Parameters, BindCourier(Parameters).DataPath);
EndFunction

// Courier.Bind
Function BindCourier(Parameters)
	DataPath = "Courier";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindCourier");
EndFunction

// Courier.ChangeCourierByTransactionType.Step
Procedure StepChangeCourierByTransactionType(Parameters, Chain) Export
	Chain.ChangeCourierByTransactionType.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeCourierByTransactionType.Setter = "SetCourier";
	Options = ModelClientServer_V2.ChangeCourierByTransactionTypeOptions();
	Options.TransactionType       = GetTransactionType(Parameters);
	Options.CurrentCourier        = GetCourier(Parameters);
	Options.StepName = "StepChangeCourierByTransactionType";
	Chain.ChangeCourierByTransactionType.Options.Add(Options);
EndProcedure

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
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindLegalName");
EndFunction

// LegalName.ChangeLegalNameByPartner.Step
Procedure StepChangeLegalNameByPartner(Parameters, Chain) Export
	Chain.ChangeLegalNameByPartner.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeLegalNameByPartner.Setter = "SetLegalName";
	Options = ModelClientServer_V2.ChangeLegalNameByPartnerOptions();
	Options.Partner   = GetPartner(Parameters);
	Options.LegalName = GetLegalName(Parameters);
	Options.StepName = "StepChangeLegalNameByPartner";
	Chain.ChangeLegalNameByPartner.Options.Add(Options);
EndProcedure

// LegalName.ChangeLegalNameByRetailCustomer.Step
Procedure StepChangeLegalNameByRetailCustomer(Parameters, Chain) Export
	Chain.ChangeLegalNameByRetailCustomer.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeLegalNameByRetailCustomer.Setter = "SetLegalName";
	Options = ModelClientServer_V2.ChangeLegalNameByRetailCustomerOptions();
	Options.RetailCustomer = GetRetailCustomer(Parameters);
	Options.StepName = "StepChangeLegalNameByRetailCustomer";
	Chain.ChangeLegalNameByRetailCustomer.Options.Add(Options);
EndProcedure

#EndRegion

#Region LEGAL_NAME_TRADE_AGENT

// LegalNameTradeAgent.OnChange
Procedure LegalNameTradeAgentOnChange(Parameters) Export
	Binding = BindLegalNameTradeAgent(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// LegalNameTradeAgent.Set
Procedure SetLegalNameTradeAgent(Parameters, Results) Export
	Binding = BindLegalNameTradeAgent(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// LegalNameTradeAgent.Get
Function GetLegalNameTradeAgent(Parameters)
	Return GetPropertyObject(Parameters, BindLegalNameTradeAgent(Parameters).DataPath);
EndFunction

// LegalNameTradeAgent.Bind
Function BindLegalNameTradeAgent(Parameters)
	DataPath = "LegalNameTradeAgent";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindLegalNameTradeAgent");
EndFunction

// LegalNameTradeAgent.ChangeLegalNameTradeAgentByPartner.Step
Procedure StepChangeLegalNameTradeAgentByPartner(Parameters, Chain) Export
	Chain.ChangeLegalNameByPartner.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeLegalNameByPartner.Setter = "SetLegalNameTradeAgent";
	Options = ModelClientServer_V2.ChangeLegalNameByPartnerOptions();
	Options.Partner   = GetPartnerTradeAgent(Parameters);
	Options.LegalName = GetLegalNameTradeAgent(Parameters);
	Options.StepName = "StepChangeLegalNameTradeAgentByPartner";
	Chain.ChangeLegalNameByPartner.Options.Add(Options);
EndProcedure

#EndRegion

#Region LEGAL_NAME_CONSIGNOR

// LegalNameConsignor.OnChange
Procedure LegalNameConsignorOnChange(Parameters) Export
	Binding = BindLegalNameConsignor(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// LegalNameConsignor.Set
Procedure SetLegalNameConsignor(Parameters, Results) Export
	Binding = BindLegalNameConsignor(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// LegalNameConsignor.Get
Function GetLegalNameConsignor(Parameters)
	Return GetPropertyObject(Parameters, BindLegalNameConsignor(Parameters).DataPath);
EndFunction

// LegalNameConsignor.Bind
Function BindLegalNameConsignor(Parameters)
	DataPath = "LegalNameConsignor";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindLegalNameConsignor");
EndFunction

// LegalNameConsignor.ChangeLegalNameConsignorByPartner.Step
Procedure StepChangeLegalNameConsignorByPartner(Parameters, Chain) Export
	Chain.ChangeLegalNameByPartner.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeLegalNameByPartner.Setter = "SetLegalNameConsignor";
	Options = ModelClientServer_V2.ChangeLegalNameByPartnerOptions();
	Options.Partner   = GetPartnerConsignor(Parameters);
	Options.LegalName = GetLegalNameConsignor(Parameters);
	Options.StepName = "StepChangeLegalNameConsignorByPartner";
	Chain.ChangeLegalNameByPartner.Options.Add(Options);
EndProcedure

#EndRegion

#Region CONSOLIDATED_RETAIL_SALES

// ConsolidatedRetailSales.OnChange
Procedure ConsolidatedRetailSalesOnChange(Parameters) Export
	AddViewNotify("OnSetConsolidatedRetailSalesNotify", Parameters);
	Binding = BindConsolidatedRetailSales(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ConsolidatedRetailSales.Set
Procedure SetConsolidatedRetailSales(Parameters, Results) Export
	Binding = BindConsolidatedRetailSales(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetConsolidatedRetailSalesNotify");
EndProcedure

// ConsolidatedRetailSales.Bind
Function BindConsolidatedRetailSales(Parameters)
	DataPath = "ConsolidatedRetailSales";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindConsolidatedRetailSales");
EndFunction

// ConsolidatedRetailSales.ChangeConsolidatedRetailSalesByWorkstation.Step
Procedure StepChangeConsolidatedRetailSalesByWorkstation(Parameters, Chain) Export
	Chain.ChangeConsolidatedRetailSalesByWorkstation.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeConsolidatedRetailSalesByWorkstation.Setter = "SetConsolidatedRetailSales";
	Options = ModelClientServer_V2.ChangeConsolidatedRetailSalesByWorkstationOptions();
	Options.Company = GetCompany(Parameters);
	Options.Branch = GetBranch(Parameters);
	Options.Workstation = GetWorkstation(Parameters);
	Options.StepName = "StepChangeConsolidatedRetailSalesByWorkstation";
	Chain.ChangeConsolidatedRetailSalesByWorkstation.Options.Add(Options);
EndProcedure

// ConsolidatedRetailSales.ChangeConsolidatedRetailSalesByWorkstationForReturn.Step
Procedure StepChangeConsolidatedRetailSalesByWorkstationForReturn(Parameters, Chain) Export
	Chain.ChangeConsolidatedRetailSalesByWorkstationForReturn.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeConsolidatedRetailSalesByWorkstationForReturn.Setter = "SetConsolidatedRetailSales";
	Options = ModelClientServer_V2.ChangeConsolidatedRetailSalesByWorkstationForReturnOptions();
	Options.Company = GetCompany(Parameters);
	Options.Branch = GetBranch(Parameters);
	Options.Workstation = GetWorkstation(Parameters);
	Options.Date = GetDate(Parameters);
	ArrayOfSalesDocuments = New Array();
	For Each Row In Parameters.Object.ItemList Do
		SalesDocument = GetItemListSalesDocument(Parameters, Row.Key);
		If ValueIsFilled(SalesDocument) Then
			ArrayOfSalesDocuments.Add(SalesDocument);
		EndIf;
	EndDo;
	Options.SalesDocuments = ArrayOfSalesDocuments;
	Options.StepName = "StepChangeConsolidatedRetailSalesByWorkstationForReturn";
	Chain.ChangeConsolidatedRetailSalesByWorkstationForReturn.Options.Add(Options);
EndProcedure

#EndRegion

#Region WORKSTATION

// Workstation.OnChange
Procedure WorkstationOnChange(Parameters) Export
	Binding = BindWorkstation(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Workstation.Set
Procedure SetWorkstation(Parameters, Results) Export
	Binding = BindWorkstation(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Workstation.Get
Function GetWorkstation(Parameters)
	Return GetPropertyObject(Parameters, BindWorkstation(Parameters).DataPath);
EndFunction

// Workstation.Bind
Function BindWorkstation(Parameters)
	DataPath = "Workstation";
	Binding = New Structure();
	Binding.Insert("RetailSalesReceipt"  , "StepChangeConsolidatedRetailSalesByWorkstation");
	Binding.Insert("RetailReturnReceipt" , "StepChangeConsolidatedRetailSalesByWorkstation");
	Binding.Insert("CashReceipt" 		 , "StepChangeConsolidatedRetailSalesByWorkstation");
	Binding.Insert("MoneyTransfer" 		 , "StepChangeConsolidatedRetailSalesByWorkstation");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindWorkstation");
EndFunction

#EndRegion

#Region STATUS

// Status.OnChange
Procedure StatusOnChange(Parameters) Export
	AddViewNotify("OnSetStatusNotify", Parameters);
	Binding = BindStatus(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Status.Set
Procedure SetStatus(Parameters, Results) Export
	Binding = BindStatus(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetStatusNotify");
EndProcedure

// Status.Bind
Function BindStatus(Parameters)
	DataPath = "Status";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindStatus");
EndFunction

#EndRegion

#Region BEGIN_DATE

// BeginDate.OnChange
Procedure BeginDateOnChange(Parameters) Export
	AddViewNotify("OnSetBeginDateNotify", Parameters);
	Binding = BindBeginDate(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// BeginDate.Set
Procedure SetBeginDate(Parameters, Results) Export
	Binding = BindBeginDate(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetBeginDateNotify");
EndProcedure

// BeginDate.Bind
Function BindBeginDate(Parameters)
	DataPath = "BeginDate";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindBeginDate");
EndFunction

#EndRegion

#Region END_DATE

// EndDate.OnChange
Procedure EndDateOnChange(Parameters) Export
	AddViewNotify("OnSetEndDateNotify", Parameters);
	Binding = BindEndDate(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// EndDate.Set
Procedure SetEndDate(Parameters, Results) Export
	Binding = BindEndDate(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetEndDateNotify");
EndProcedure

// EndDate.Bind
Function BindEndDate(Parameters)
	DataPath = "EndDate";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindEndDate");
EndFunction

#EndRegion

#Region _NUMBER

// Number.OnChange
Procedure NumberOnChange(Parameters) Export
	AddViewNotify("OnSetNumberNotify", Parameters);
	Binding = BindNumber(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Number.Set
Procedure SetNumber(Parameters, Results) Export
	Binding = BindNumber(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetNumberNotify");
EndProcedure

// Number.Bind
Function BindNumber(Parameters)
	DataPath = "Number";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindNumber");
EndFunction

#EndRegion

#Region RETAIL_CUSTOMER

// RetailCustomer.OnChange
Procedure RetailCustomerOnChange(Parameters) Export
	RollbackPropertyToValueBeforeChange_Object(Parameters);
	Binding = BindRetailCustomer(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// RetailCustomer.Set
Procedure SetRetailCustomer(Parameters, Results) Export
	Binding = BindRetailCustomer(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// RetailCustomer.Get
Function GetRetailCustomer(Parameters)
	Return GetPropertyObject(Parameters, BindRetailCustomer(Parameters).DataPath);
EndFunction

// RetailCustomer.Bind
Function BindRetailCustomer(Parameters)
	DataPath = "RetailCustomer";
	Binding = New Structure();
	
	Binding.Insert("RetailSalesReceipt",
		"StepChangePartnerByRetailCustomer,
		|StepChangeAgreementByRetailCustomer,
		|StepChangeLegalNameByRetailCustomer,
		|StepChangeUsePartnerTransactionsByRetailCustomer");
		
	Binding.Insert("SalesOrder",
		"StepChangePartnerByRetailCustomer,
		|StepChangeAgreementByRetailCustomer,
		|StepChangeLegalNameByRetailCustomer");
		
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindRetailCustomer");
EndFunction

#EndRegion

#Region USE_PARTNER_TRANSACTIONS 

// UsePartnerTransactions.Set
Procedure SetUsePartnerTransactions(Parameters, Results) Export
	Binding = BindUsePartnerTransactions(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// UsePartnerTransactions.Bind
Function BindUsePartnerTransactions(Parameters)
	DataPath = "UsePartnerTransactions";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindUsePartnerTransactions");
EndFunction

// UsePartnerTransactions.ChangeUsePartnerTransactionsByRetailCustomer.Step
Procedure StepChangeUsePartnerTransactionsByRetailCustomer(Parameters, Chain) Export
	Chain.ChangeUsePartnerTransactionsByRetailCustomer.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeUsePartnerTransactionsByRetailCustomer.Setter = "SetUsePartnerTransactions";
	Options = ModelClientServer_V2.ChangeUsePartnerTransactionsByRetailCustomerOptions();
	Options.RetailCustomer = GetRetailCustomer(Parameters);
	Options.StepName = "StepChangeUsePartnerTransactionsByRetailCustomer";
	Chain.ChangeUsePartnerTransactionsByRetailCustomer.Options.Add(Options);
EndProcedure

#EndRegion

#Region DELIVERY_DATE

// DeliveryDate.OnChange
Procedure DeliveryDateOnChange(Parameters) Export
	RollbackPropertyToValueBeforeChange_Form(Parameters);
	AddViewNotify("OnSetDeliveryDateNotify", Parameters);
	Binding = BindDeliveryDate(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// DeliveryDate.Set
Procedure SetDeliveryDate(Parameters, Results) Export
	Binding = BindDeliveryDate(Parameters);
	SetterForm(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetDeliveryDateNotify", , True);
EndProcedure

// DeliveryDate.Get
Function GetDeliveryDate(Parameters)
	Return GetPropertyForm(Parameters, BindDeliveryDate(Parameters).DataPath);
EndFunction

// DeliveryDate.Default.Bind
Function BindDefaultDeliveryDate(Parameters)
	DataPath = "DeliveryDate";
	Binding = New Structure();
	Binding.Insert("SalesOrder"           , "StepDefaultDeliveryDateInHeader");
	Binding.Insert("SalesInvoice"         , "StepDefaultDeliveryDateInHeader");
	Binding.Insert("PurchaseOrder"        , "StepDefaultDeliveryDateInHeader");
	Binding.Insert("PurchaseInvoice"      , "StepDefaultDeliveryDateInHeader");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindDefaultDeliveryDate");
EndFunction

// DeliveryDate.Bind
Function BindDeliveryDate(Parameters)
	DataPath = "DeliveryDate";
	Binding = New Structure();
	Return BindSteps("StepItemListFillDeliveryDateInList", DataPath, Binding, Parameters, "BindDeliveryDate");
EndFunction

// DeliveryDate.ChangeDeliveryDateByAgreement.Step
Procedure StepChangeDeliveryDateByAgreement(Parameters, Chain) Export
	Chain.ChangeDeliveryDateByAgreement.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
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
	If Chain.Idle Then
		Return;
	EndIf;
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
	If Chain.Idle Then
		Return;
	EndIf;
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

#Region STORE_OBJECT_ATTR

// StoreObjectAttr.OnChange
Procedure StoreObjectAttrOnChange(Parameters) Export
	RollbackPropertyToValueBeforeChange_Form(Parameters);
	AddViewNotify("OnSetStoreObjectAttrNotify", Parameters);
	Binding = BindStoreObjectAttr(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// StoreObjectAttr.Set
Procedure SetStoreObjectAttr(Parameters, Results) Export
	Binding = BindStoreObjectAttr(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetStoreObjectAttrNotify");
EndProcedure

// StoreObjectAttr.Bind
Function BindStoreObjectAttr(Parameters)
	DataPath = "Store";
	Binding = New Structure();	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindStoreObjectAttr");
EndFunction

#EndRegion

// Store.OnChange
Procedure StoreOnChange(Parameters) Export
	RollbackPropertyToValueBeforeChange_Form(Parameters);
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
	SetterForm(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetStoreNotify", , True);
EndProcedure

// Store.Get
Function GetStore(Parameters)
	Return GetPropertyForm(Parameters, BindStore(Parameters).DataPath);
EndFunction

// Store.Default.Bind
Function BindDefaultStore(Parameters)
	DataPath = "Store";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation" , "StepDefaultStoreInHeader_WithoutAgreement");
	Binding.Insert("GoodsReceipt"         , "StepDefaultStoreInHeader_WithoutAgreement");
	
	Binding.Insert("RetailShipmentConfirmation" , "StepDefaultStoreInHeader_WithoutAgreement");
	Binding.Insert("RetailGoodsReceipt"         , "StepDefaultStoreInHeader_WithoutAgreement");

	Binding.Insert("SalesOrder"           , "StepDefaultStoreInHeader_AgreementInHeader");
	Binding.Insert("SalesInvoice"         , "StepDefaultStoreInHeader_AgreementInHeader");
	Binding.Insert("RetailSalesReceipt"   , "StepDefaultStoreInHeader_AgreementInHeader");
	Binding.Insert("PurchaseOrder"        , "StepDefaultStoreInHeader_AgreementInHeader");
	Binding.Insert("PurchaseInvoice"      , "StepDefaultStoreInHeader_AgreementInHeader");
	Binding.Insert("RetailReturnReceipt"  , "StepDefaultStoreInHeader_AgreementInHeader");
	Binding.Insert("PurchaseReturnOrder"  , "StepDefaultStoreInHeader_AgreementInHeader");
	Binding.Insert("PurchaseReturn"       , "StepDefaultStoreInHeader_AgreementInHeader");
	Binding.Insert("SalesReturnOrder"     , "StepDefaultStoreInHeader_AgreementInHeader");
	Binding.Insert("SalesReturn"          , "StepDefaultStoreInHeader_AgreementInHeader");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindDefaultStore");
EndFunction

// Store.Empty.Bind
Function BindEmptyStore(Parameters)
	DataPath = "Store";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation", "StepEmptyStoreInHeader_WithoutAgreement");
	Binding.Insert("GoodsReceipt"        , "StepEmptyStoreInHeader_WithoutAgreement");
	
	Binding.Insert("RetailShipmentConfirmation", "StepEmptyStoreInHeader_WithoutAgreement");
	Binding.Insert("RetailGoodsReceipt"        , "StepEmptyStoreInHeader_WithoutAgreement");

	Binding.Insert("SalesOrder"           , "StepEmptyStoreInHeader_AgreementInHeader");
	Binding.Insert("SalesInvoice"         , "StepEmptyStoreInHeader_AgreementInHeader");
	Binding.Insert("RetailSalesReceipt"   , "StepEmptyStoreInHeader_AgreementInHeader");
	Binding.Insert("PurchaseOrder"        , "StepEmptyStoreInHeader_AgreementInHeader");
	Binding.Insert("PurchaseInvoice"      , "StepEmptyStoreInHeader_AgreementInHeader");
	Binding.Insert("RetailReturnReceipt"  , "StepEmptyStoreInHeader_AgreementInHeader");
	Binding.Insert("PurchaseReturnOrder"  , "StepEmptyStoreInHeader_AgreementInHeader");
	Binding.Insert("PurchaseReturn"       , "StepEmptyStoreInHeader_AgreementInHeader");
	Binding.Insert("SalesReturnOrder"     , "StepEmptyStoreInHeader_AgreementInHeader");
	Binding.Insert("SalesReturn"          , "StepEmptyStoreInHeader_AgreementInHeader");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindEmptyStore");
EndFunction

// Store.Bind
Function BindStore(Parameters)
	DataPath = "Store";
	Binding = New Structure();
	Return BindSteps("StepItemListFillStoresInList", DataPath, Binding, Parameters, "BindStore");
EndFunction

// Store.ChangeStoreByAgreement.Step
Procedure StepChangeStoreByAgreement(Parameters, Chain) Export
	Chain.ChangeStoreByAgreement.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
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
	If Chain.Idle Then
		Return;
	EndIf;
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
	If Chain.Idle Then
		Return;
	EndIf;
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
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeStoreInHeaderByStoresInList.Setter = "SetStore";
	Options = ModelClientServer_V2.ChangeStoreInHeaderByStoresInListOptions();
	ArrayOfStoresInList = New Array();
	For Each Row In Parameters.Object.ItemList Do
		IsService = False;
		If CommonFunctionsClientServer.ObjectHasProperty(Row, "IsService") Then
			IsService = GetItemListIsService(Parameters, Row.Key);
		EndIf;
		
		NewRow = New Structure();
		NewRow.Insert("Store"     , GetItemListStore(Parameters, Row.Key));
		NewRow.Insert("ItemKey"   , GetItemListItemKey(Parameters, Row.Key));
		NewRow.Insert("IsService" , IsService);
		ArrayOfStoresInList.Add(NewRow);
	EndDo;
	Options.ArrayOfStoresInList = ArrayOfStoresInList; 
	Options.StepName = "StepChangeStoreInHeaderByStoresInList";
	Chain.ChangeStoreInHeaderByStoresInList.Options.Add(Options);
EndProcedure

#EndRegion

#Region STORE_TRANSIT

// StoreTransit.OnChange
Procedure StoreTransitOnChange(Parameters) Export
	AddViewNotify("OnSetStoreTransitNotify", Parameters);
	Binding = BindStoreTransit(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// StoreTransit.Set
Procedure SetStoreTransit(Parameters, Results) Export
	Binding = BindStoreTransit(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetStoreTransitNotify");
EndProcedure

// StoreTransit.Bind
Function BindStoreTransit(Parameters)
	DataPath = "StoreTransit";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindStoreTransit");
EndFunction

#EndRegion

#Region STORE_SENDER

// StoreSender.OnChange
Procedure StoreSenderOnChange(Parameters) Export
	AddViewNotify("OnSetStoreSenderNotify", Parameters);
	Binding = BindStoreSender(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// StoreSender.Set
Procedure SetStoreSender(Parameters, Results) Export
	Binding = BindStoreSender(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetStoreSenderNotify");
EndProcedure

// StoreSender.Get
Function GetStoreSender(Parameters)
	Return GetPropertyObject(Parameters, BindStoreSender(Parameters).DataPath);
EndFunction

// StoreSender.Bind
Function BindStoreSender(Parameters)
	DataPath = "StoreSender";
	Binding = New Structure();
	Binding.Insert("InventoryTransfer", 
		"StepChangeUseShipmentConfirmationByStoreSender,
		|StepConsignorBatchesFillBatches_StoreSender");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindStoreSender");
EndFunction

#EndRegion

#Region STORE_RECEIVER

// StoreReceiver.OnChange
Procedure StoreReceiverOnChange(Parameters) Export
	AddViewNotify("OnSetStoreReceiverNotify", Parameters);
	Binding = BindStoreReceiver(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// StoreReceiver.Set
Procedure SetStoreReceiver(Parameters, Results) Export
	Binding = BindStoreReceiver(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetStoreReceiverNotify");
EndProcedure

// StoreReceiver.Get
Function GetStoreReceiver(Parameters)
	Return GetPropertyObject(Parameters, BindStoreReceiver(Parameters).DataPath);
EndFunction

// StoreReceiver.Bind
Function BindStoreReceiver(Parameters)
	DataPath = "StoreReceiver";
	Binding = New Structure();
	Binding.Insert("InventoryTransfer", "StepChangeUseGoodsReceiptByStoreReceiver");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindStoreReceiver");
EndFunction

#EndRegion

#Region STORE_PRODUCTION

// StoreProduction.OnChange
Procedure StoreProductionOnChange(Parameters) Export
	Binding = BindStoreProduction(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// StoreProduction.Set
Procedure SetStoreProduction(Parameters, Results) Export
	Binding = BindStoreProduction(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// StoreProduction.Bind
Function BindStoreProduction(Parameters)
	DataPath = "StoreProduction";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindStoreProduction");
EndFunction

#EndRegion

#Region USE_SHIPMENT_CONFIRMATION

// UseShipmentConfirmation.OnChange
Procedure UseShipmentConfirmationOnChange(Parameters) Export
	Binding = BindUseShipmentConfirmation(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// UseShipmentConfirmation.Set
Procedure SetUseShipmentConfirmation(Parameters, Results) Export
	Binding = BindUseShipmentConfirmation(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// UseShipmentConfirmation.Get
Function GetUseShipmentConfirmation(Parameters)
	Return GetPropertyObject(Parameters, BindUseShipmentConfirmation(Parameters).DataPath);
EndFunction

// UseShipmentConfirmation.Bind
Function BindUseShipmentConfirmation(Parameters)
	DataPath = "UseShipmentConfirmation";
	Binding = New Structure();
	Binding.Insert("InventoryTransfer", "StepChangeUseGoodsReceiptByUseShipmentConfirmation");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindUseShipmentConfirmation");
EndFunction

// UseShipmentConfirmation.ChangeUseShipmentConfirmationByStoreSender.Step
Procedure StepChangeUseShipmentConfirmationByStoreSender(Parameters, Chain) Export
	Chain.ChangeUseShipmentConfirmationByStore.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeUseShipmentConfirmationByStore.Setter = "SetUseShipmentConfirmation";
	Options = ModelClientServer_V2.ChangeUseShipmentConfirmationByStoreOptions();
	Options.Store   = GetStoreSender(Parameters);
	Options.StepName = "StepChangeUseShipmentConfirmationByStoreSender";
	Chain.ChangeUseShipmentConfirmationByStore.Options.Add(Options);
EndProcedure

#EndRegion

#Region USE_GOODS_RECEIPT

// UseGoodsReceipt.OnChange
Procedure UseGoodsReceiptOnChange(Parameters) Export
	Binding = BindUseGoodsReceipt(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// UseGoodsReceipt.Set
Procedure SetUseGoodsReceipt(Parameters, Results) Export
	Binding = BindUseGoodsReceipt(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);	
EndProcedure

// UseGoodsReceipt.Set.WithViewNotify
Procedure SetUseGoodsReceipt_WithViewNotify(Parameters, Results) Export
	Binding = BindUseGoodsReceipt(Parameters);
	SetterObject("BindVoid", Binding.DataPath, Parameters, Results);
	
	// if this property set programmatically as tru, notify client for show user message
	If Results[0].Options.ShowUserMessage = True Then
		AddViewNotify("OnSetUseGoodsReceiptNotify_IsProgramAsTrue", Parameters);
	EndIf;
EndProcedure

// UseGoodsReceipt.Get
Function GetUseGoodsReceipt(Parameters)
	Return GetPropertyObject(Parameters, BindUseGoodsReceipt(Parameters).DataPath);
EndFunction

// UseGoodsReceipt.Bind
Function BindUseGoodsReceipt(Parameters)
	DataPath = "UseGoodsReceipt";
	Binding = New Structure();
	Binding.Insert("InventoryTransfer", "StepChangeUseGoodsReceiptByUseShipmentConfirmation");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindUseGoodsReceipt");
EndFunction

// UseGoodsReceipt.ChangeUseGoodsReceiptByStoreReceiver.Step
Procedure StepChangeUseGoodsReceiptByStoreReceiver(Parameters, Chain) Export
	Chain.ChangeUseGoodsReceiptByStore.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeUseGoodsReceiptByStore.Setter = "SetUseGoodsReceipt";
	Options = ModelClientServer_V2.ChangeUseGoodsReceiptByStoreOptions();
	Options.Store   = GetStoreReceiver(Parameters);
	Options.StepName = "StepChangeUseGoodsReceiptByStoreReceiver";
	Chain.ChangeUseGoodsReceiptByStore.Options.Add(Options);
EndProcedure

// UseGoodsReceipt.ChangeUseGoodsReceiptByUseShipmentConfirmation.Step
Procedure StepChangeUseGoodsReceiptByUseShipmentConfirmation(Parameters, Chain) Export
	Chain.ChangeUseGoodsReceiptByUseShipmentConfirmation.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeUseGoodsReceiptByUseShipmentConfirmation.Setter = "SetUseGoodsReceipt_WithViewNotify";
	Options = ModelClientServer_V2.ChangeUseGoodsReceiptByUseShipmentConfirmationOptions();
	Options.UseShipmentConfirmation = GetUseShipmentConfirmation(Parameters);
	Options.UseGoodsReceipt         = GetUseGoodsReceipt(Parameters);
	Options.StoreSender             = GetStoreSender(Parameters);
	Options.StoreReceiver           = GetStoreReceiver(Parameters);
	Options.StepName = "StepChangeUseGoodsReceiptByUseShipmentConfirmation";
	Chain.ChangeUseGoodsReceiptByUseShipmentConfirmation.Options.Add(Options);	
EndProcedure

#EndRegion

#Region AGREEMENT

// Agreement.OnChange
Procedure AgreementOnChange(Parameters) Export
	RollbackPropertyToValueBeforeChange_Object(Parameters);
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
	Binding.Insert("SalesOrder",
		"StepChangeCompanyByAgreement,
		|StepChangeCurrencyByAgreement,
		|StepChangeStoreByAgreement,
		|StepChangeDeliveryDateByAgreement,
		|StepItemListChangePriceTypeByAgreement,
		|StepChangePriceIncludeTaxByAgreement,
		|StepChangePaymentTermsByAgreement,
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");
	
	Binding.Insert("WorkOrder",
		"StepChangeCompanyByAgreement,
		|StepChangeCurrencyByAgreement,
		|StepItemListChangePriceTypeByAgreement,
		|StepChangePriceIncludeTaxByAgreement,
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");
		
	Binding.Insert("SalesInvoice",
		"StepChangeCompanyByAgreement,
		|StepChangeCurrencyByAgreement,
		|StepChangeStoreByAgreement,
		|StepChangeDeliveryDateByAgreement,
		|StepItemListChangePriceTypeByAgreement,
		|StepChangePriceIncludeTaxByAgreement,
		|StepChangePaymentTermsByAgreement,
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");

	Binding.Insert("RetailSalesReceipt",
		"StepChangeCompanyByAgreement,
		|StepChangeCurrencyByAgreement,
		|StepChangeStoreByAgreement,
		|StepItemListChangePriceTypeByAgreement,
		|StepChangePriceIncludeTaxByAgreement,
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");

	Binding.Insert("RetailReturnReceipt",
		"StepChangeCompanyByAgreement,
		|StepChangeCurrencyByAgreement,
		|StepChangeStoreByAgreement,
		|StepItemListChangePriceTypeByAgreement,
		|StepChangePriceIncludeTaxByAgreement,
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");

	Binding.Insert("PurchaseReturnOrder",
		"StepChangeCompanyByAgreement,
		|StepChangeCurrencyByAgreement,
		|StepChangeStoreByAgreement,
		|StepItemListChangePriceTypeByAgreement,
		|StepChangePriceIncludeTaxByAgreement,
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");

	Binding.Insert("PurchaseReturn",
		"StepChangeCompanyByAgreement,
		|StepChangeCurrencyByAgreement,
		|StepChangeStoreByAgreement,
		|StepItemListChangePriceTypeByAgreement,
		|StepChangePriceIncludeTaxByAgreement,
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");

	Binding.Insert("SalesReturnOrder",
		"StepChangeCompanyByAgreement,
		|StepChangeCurrencyByAgreement,
		|StepChangeStoreByAgreement,
		|StepItemListChangePriceTypeByAgreement,
		|StepChangePriceIncludeTaxByAgreement,
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");

	Binding.Insert("SalesReturn",
		"StepChangeCompanyByAgreement,
		|StepChangeCurrencyByAgreement,
		|StepChangeStoreByAgreement,
		|StepItemListChangePriceTypeByAgreement,
		|StepChangePriceIncludeTaxByAgreement,
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");

	Binding.Insert("PurchaseOrder",
		"StepChangeCompanyByAgreement,
		|StepChangeCurrencyByAgreement,
		|StepChangeStoreByAgreement,
		|StepChangeDeliveryDateByAgreement,
		|StepItemListChangePriceTypeByAgreement,
		|StepChangePriceIncludeTaxByAgreement,
		|StepChangePaymentTermsByAgreement,
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");
	
	Binding.Insert("PurchaseInvoice",
		"StepChangeCompanyByAgreement,
		|StepChangeCurrencyByAgreement,
		|StepChangeStoreByAgreement,
		|StepChangeDeliveryDateByAgreement,
		|StepItemListChangePriceTypeByAgreement,
		|StepChangePriceIncludeTaxByAgreement,
		|StepChangePaymentTermsByAgreement,
		|StepRequireCallCreateTaxesFormControls,
		|StepChangeTaxRate_AgreementInHeader");
		
	Binding.Insert("SalesReportFromTradeAgent",
		"StepChangeCompanyByAgreement,
		|StepChangeCurrencyByAgreement,
		|StepChangePriceIncludeTaxByAgreement,
		|StepItemListChangeTradeAgentFeePercentByAgreement,
		|StepChangeTradeAgentFeeTypeByAgreement");
	
	Binding.Insert("SalesReportToConsignor",
		"StepChangeCompanyByAgreement,
		|StepChangeCurrencyByAgreement,
		|StepChangePriceIncludeTaxByAgreement,
		|StepItemListChangeTradeAgentFeePercentByAgreement,
		|StepChangeTradeAgentFeeTypeByAgreement");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindAgreement");
EndFunction

// Agreement.ChangeAgreementByPartner.[AgreementTypeIsCustomer].Step
Procedure StepChangeAgreementByPartner_AgreementTypeIsCustomer(Parameters, Chain) Export
	StepChangeAgreementByPartner(Parameters, Chain, PredefinedValue("Enum.AgreementTypes.Customer"), False);
EndProcedure

// Agreement.ChangeAgreementByPartner.[AgreementTypeIsVendor].Step
Procedure StepChangeAgreementByPartner_AgreementTypeIsVendor(Parameters, Chain) Export
	StepChangeAgreementByPartner(Parameters, Chain, PredefinedValue("Enum.AgreementTypes.Vendor"), False);
EndProcedure

// Agreement.ChangeAgreementByPartner.[AgreementTypeIsConsignor].Step
Procedure StepChangeAgreementByPartner_AgreementTypeIsConsignor(Parameters, Chain) Export
	StepChangeAgreementByPartner(Parameters, Chain, PredefinedValue("Enum.AgreementTypes.Consignor"), False);
EndProcedure

// Agreement.ChangeAgreementByPartner.[AgreementTypeIsTradeAgent].Step
Procedure StepChangeAgreementByPartner_AgreementTypeIsTradeAgent(Parameters, Chain) Export
	StepChangeAgreementByPartner(Parameters, Chain, PredefinedValue("Enum.AgreementTypes.TradeAgent"), False);
EndProcedure

// Agreement.ChangeAgreementByPartner.[AgreementTypeByTransactionType].Step
Procedure StepChangeAgreementByPartner_AgreementTypeByTransactionType(Parameters, Chain) Export
	StepChangeAgreementByPartner(Parameters, Chain, Undefined, True);
EndProcedure

// Agreement.ChangeAgreementByPartner.Step
Procedure StepChangeAgreementByPartner(Parameters, Chain, AgreementType, AgreementTypeByTransactionType)
	Chain.ChangeAgreementByPartner.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeAgreementByPartner.Setter = "SetAgreement";
	Options = ModelClientServer_V2.ChangeAgreementByPartnerOptions();
	Options.Partner       = GetPartner(Parameters);
	Options.Agreement     = GetAgreement(Parameters);
	Options.CurrentDate   = GetDate(Parameters);
	Options.AgreementType = AgreementType;
	If AgreementTypeByTransactionType Then
		Options.TransactionType = GetTransactionType(Parameters);
	EndIf;
	Options.StepName = "StepChangeAgreementByPartner";
	Chain.ChangeAgreementByPartner.Options.Add(Options);
EndProcedure

// Agreement.ChangeAgreementByRetailCustomer.Step
Procedure StepChangeAgreementByRetailCustomer(Parameters, Chain) Export
	Chain.ChangeAgreementByRetailCustomer.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeAgreementByRetailCustomer.Setter = "SetAgreement";
	Options = ModelClientServer_V2.ChangeAgreementByRetailCustomerOptions();
	Options.RetailCustomer = GetRetailCustomer(Parameters);
	Options.StepName = "StepChangeAgreementByRetailCustomer";
	Chain.ChangeAgreementByRetailCustomer.Options.Add(Options);
EndProcedure

#EndRegion

#Region AGREEMENT_TRADE_AGENT

// AgreementTradeAgent.OnChange
Procedure AgreementTradeAgentOnChange(Parameters) Export
	Binding = BindAgreementTradeAgent(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// AgreementTradeAgent.Set
Procedure SetAgreementTradeAgent(Parameters, Results) Export
	Binding = BindAgreementTradeAgent(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// AgreementTradeAgent.Get
Function GetAgreementTradeAgent(Parameters)
	Return GetPropertyObject(Parameters, BindAgreementTradeAgent(Parameters).DataPath);
EndFunction

// AgreementTradeAgent.Bind
Function BindAgreementTradeAgent(Parameters)
	DataPath = "AgreementTradeAgent";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindAgreementTradeAgent");
EndFunction

// AgreementTradeAgent.ChangeAgreementByPartner.Step
Procedure StepChangeAgreementTradeAgentByPartner(Parameters, Chain) Export
	Chain.ChangeAgreementByPartner.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeAgreementByPartner.Setter = "SetAgreementTradeAgent";
	Options = ModelClientServer_V2.ChangeAgreementByPartnerOptions();
	Options.Partner       = GetPartnerTradeAgent(Parameters);
	Options.Agreement     = GetAgreementTradeAgent(Parameters);
	Options.CurrentDate   = GetDate(Parameters);
	Options.AgreementType = PredefinedValue("Enum.AgreementTypes.TradeAgent");
	Options.TransactionType = PredefinedValue("Enum.SalesTransactionTypes.ShipmentToTradeAgent");
	Options.StepName = "StepChangeAgreementTradeAgentByPartner";
	Chain.ChangeAgreementByPartner.Options.Add(Options);
EndProcedure

#EndRegion

#Region AGREEMNT_CONSIGNOR

// AgreementConsignor.OnChange
Procedure AgreementConsignorOnChange(Parameters) Export
	Binding = BindAgreementConsignor(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// AgreementConsignor.Set
Procedure SetAgreementConsignor(Parameters, Results) Export
	Binding = BindAgreementConsignor(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// AgreementConsignor.Get
Function GetAgreementConsignor(Parameters)
	Return GetPropertyObject(Parameters, BindAgreementConsignor(Parameters).DataPath);
EndFunction

// AgreementConsignor.Bind
Function BindAgreementConsignor(Parameters)
	DataPath = "AgreementConsignor";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindAgreementConsignor");
EndFunction

// AgreementConsignor.ChangeAgreementByPartner.Step
Procedure StepChangeAgreementConsignorByPartner(Parameters, Chain) Export
	Chain.ChangeAgreementByPartner.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeAgreementByPartner.Setter = "SetAgreementConsignor";
	Options = ModelClientServer_V2.ChangeAgreementByPartnerOptions();
	Options.Partner       = GetPartnerConsignor(Parameters);
	Options.Agreement     = GetAgreementConsignor(Parameters);
	Options.CurrentDate   = GetDate(Parameters);
	Options.AgreementType = PredefinedValue("Enum.AgreementTypes.Consignor");
	Options.TransactionType = PredefinedValue("Enum.PurchaseTransactionTypes.ReceiptFromConsignor");
	Options.StepName = "StepChangeAgreementConsignorByPartner";
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
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindManagerSegment");
EndFunction

// ManagerSegment.ChangeManagerSegmentByPartner.Step
Procedure StepChangeManagerSegmentByPartner(Parameters, Chain) Export
	Chain.ChangeManagerSegmentByPartner.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
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
	
	Binding.Insert("SalesReportFromTradeAgent", "StepItemListCalculations_IsPriceIncludeTaxChanged_Without_SpecialOffers");
	Binding.Insert("SalesReportToConsignor"   , "StepItemListCalculations_IsPriceIncludeTaxChanged_Without_SpecialOffers");
	
	Return BindSteps("StepItemListCalculations_IsPriceIncludeTaxChanged", DataPath, Binding, Parameters, "BindPriceIncludeTax");
EndFunction

// PriceIncludeTax.ChangePriceIncludeTaxByAgreement.Step
Procedure StepChangePriceIncludeTaxByAgreement(Parameters, Chain) Export
	Chain.ChangePriceIncludeTaxByAgreement.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangePriceIncludeTaxByAgreement.Setter = "SetPriceIncludeTax";
	Options = ModelClientServer_V2.ChangePriceIncludeTaxByAgreementOptions();
	Options.Agreement = GetAgreement(Parameters);
	Options.CurrentPriceIncludeTax = GetPriceIncludeTax(Parameters);
	Options.StepName = "StepChangePriceIncludeTaxByAgreement";
	Chain.ChangePriceIncludeTaxByAgreement.Options.Add(Options);
EndProcedure

#EndRegion

#Region QUANTITY

// Quantity.OnChange
Procedure QuantityOnChange(Parameters) Export
	AddViewNotify("OnSetQuantityNotify", Parameters);
	Binding = BindQuantity(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Quantity.Set
Procedure SetQuantity(Parameters, Results) Export
	Binding = BindQuantity(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetQuantityNotify");
EndProcedure

// Quantity.Get
Function GetQuantity(Parameters)
	Return GetPropertyObject(Parameters, BindQuantity(Parameters).DataPath);
EndFunction

// Quantity.Bind
Function BindQuantity(Parameters)
	DataPath = "Quantity";
	Binding = New Structure();
	
	Binding.Insert("Bundling",
		"StepCovertQuantityToQuantityInBaseUnit_ItemBundle");
	
	Binding.Insert("Unbundling",
		"StepCovertQuantityToQuantityInBaseUnit_ItemKeyBundle");
	
	Binding.Insert("Production",
		"StepMaterialsRecalculateQuantity,
		|StepChangeDurationOfProductionByBillOfMaterials");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindQuantity");
EndFunction

#EndRegion

#Region QUANTITY_IN_BASE_UNIT

// QuantityInBaseUnit.Set
Procedure SetQuantityInBaseUnit(Parameters, Results) Export
	Binding = BindQuantityInBaseUnit(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath , Parameters, Results);
EndProcedure

// QuantityInBaseUnit.Bind
Function BindQuantityInBaseUnit(Parameters)
	DataPath = "QuantityInBaseUnit";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindQuantityInBaseUnit");
EndFunction

// QuantityInBaseUnit.CovertQuantityToQuantityInBaseUnit[ItemBundle].Step
Procedure StepCovertQuantityToQuantityInBaseUnit_ItemBundle(Parameters, Chain) Export
	StepCovertQuantityToQuantityInBaseUnit(Parameters, Chain, "ItemBundle");
EndProcedure

// QuantityInBaseUnit.CovertQuantityToQuantityInBaseUnit[ItemKeyBundle].Step
Procedure StepCovertQuantityToQuantityInBaseUnit_ItemKeyBundle(Parameters, Chain) Export
	StepCovertQuantityToQuantityInBaseUnit(Parameters, Chain, "ItemKeyBundle")
EndProcedure

Procedure StepCovertQuantityToQuantityInBaseUnit(Parameters, Chain, Type)
	Chain.CovertQuantityToQuantityInBaseUnit.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.CovertQuantityToQuantityInBaseUnit.Setter = "SetQuantityInBaseUnit";
	Options = ModelClientServer_V2.CovertQuantityToQuantityInBaseUnitOptions(); 
	If Type = "ItemBundle" Then
		Options.Bundle = GetItemBundle(Parameters);
	ElsIf Type = "ItemKeyBundle" Then
		Options.Bundle = GetItemKeyBundle(Parameters);
	Else
		Raise StrTemplate("Unsupported bundle type [%1]", Type);
	EndIf;
	Options.Unit       = GetUnit(Parameters);
	Options.Quantity   = GetQuantity(Parameters);
	Options.StepName   = "StepCovertQuantityToQuantityInBaseUnit";
	Chain.CovertQuantityToQuantityInBaseUnit.Options.Add(Options);
EndProcedure

#EndRegion

#Region UNIT

// Unit.OnChange
Procedure UnitOnChange(Parameters) Export
	AddViewNotify("OnSetUnitNotify", Parameters);
	Binding = BindUnit(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Unit.Set
Procedure SetUnit(Parameters, Results) Export
	Binding = BindUnit(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetUnitNotify");
EndProcedure

// Unit.Get
Function GetUnit(Parameters)
	Return GetPropertyObject(Parameters, BindUnit(Parameters).DataPath);
EndFunction

// Unit.Bind
Function BindUnit(Parameters)
	DataPath = "Unit";
	Binding = New Structure();
	
	Binding.Insert("Bundling", 
		"StepCovertQuantityToQuantityInBaseUnit_ItemBundle");
	
	Binding.Insert("Unbundling",
		"StepCovertQuantityToQuantityInBaseUnit_ItemKeyBundle");
	
	Binding.Insert("Production",
		"StepMaterialsRecalculateQuantity,
		|StepChangeDurationOfProductionByBillOfMaterials");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindUnit");
EndFunction

// Unit.ChangeUnitByItemKey.Step
Procedure StepChangeUnitByItemKey(Parameters, Chain) Export
	Chain.ChangeUnitByItemKey.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeUnitByItemKey.Setter = "SetUnit";
	Options = ModelClientServer_V2.ChangeUnitByItemKeyOptions();
	Options.ItemKey = GetItemKey(Parameters);
	Options.StepName = "StepChangeUnitByItemKey";
	Chain.ChangeUnitByItemKey.Options.Add(Options);
EndProcedure

#EndRegion

#Region ITEM_BUNDLE

// ItemBundle.OnChange
Procedure ItemBundleOnChange(Parameters) Export
	AddViewNotify("OnSetItemBundleNotify", Parameters);
	Binding = BindItemBundle(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemBundle.Set
Procedure SetItemBundle(Parameters, Results) Export
	Binding = BindItemBundle(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetItemBundleNotify");
EndProcedure

// ItemBundle.Get
Function GetItemBundle(Parameters)
	Return GetPropertyObject(Parameters, BindItemBundle(Parameters).DataPath);
EndFunction

// ItemBundle.Bind
Function BindItemBundle(Parameters)
	DataPath = "ItemBundle";
	Binding = New Structure();
	Binding.Insert("Bundling", "StepCovertQuantityToQuantityInBaseUnit_ItemBundle");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemBundle");
EndFunction

#EndRegion

#Region ITEM_KEY_BUNDLE

// ItemKeyBundle.OnChange
Procedure ItemKeyBundleOnChange(Parameters) Export
	AddViewNotify("OnSetItemKeyBundleNotify", Parameters);
	Binding = BindItemKeyBundle(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemKeyBundle.Set
Procedure SetItemKeyBundle(Parameters, Results) Export
	Binding = BindItemKeyBundle(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetItemKeyBundleNotify");
EndProcedure

// ItemKeyBundle.Get
Function GetItemKeyBundle(Parameters)
	Return GetPropertyObject(Parameters, BindItemKeyBundle(Parameters).DataPath);
EndFunction

// ItemKeyBundle.Bind
Function BindItemKeyBundle(Parameters)
	DataPath = "ItemKeyBundle";
	Binding = New Structure();
	Binding.Insert("Unbundling", "StepCovertQuantityToQuantityInBaseUnit_ItemKeyBundle");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemKeyBundle");
EndFunction

#EndRegion

#Region _ITEM

// Item.OnChange
Procedure ItemOnChange(Parameters) Export
	Binding = BindItem(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Item.Set
Procedure SetItem(Parameters, Results) Export
	Binding = BindItem(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Item.Get
Function GetItem(Parameters)
	Return GetPropertyObject(Parameters, BindItem(Parameters).DataPath);
EndFunction

// Item.Bind
Function BindItem(Parameters)
	DataPath = "Item";
	Binding = New Structure();
	
	Binding.Insert("Production", 
		"StepChangeItemKeyByItem");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItem");
EndFunction

#EndRegion

#Region ITEM_KEY

// ItemKey.OnChange
Procedure ItemKeyOnChange(Parameters) Export
	Binding = BindItemKey(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemKey.Set
Procedure SetItemKey(Parameters, Results) Export
	Binding = BindItemKey(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemKey.Get
Function GetItemKey(Parameters)
	Return GetPropertyObject(Parameters, BindItemKey(Parameters).DataPath);
EndFunction

// ItemKey.Bind
Function BindItemKey(Parameters)
	DataPath = "ItemKey";
	Binding = New Structure();
	
	Binding.Insert("Production",
		"StepChangeUnitByItemKey,
		|StepChangeBillOfMaterialsByItemKey");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemKey");
EndFunction

// ItemKey.ChangeItemKeyByItem.Step
Procedure StepChangeItemKeyByItem(Parameters, Chain) Export
	Chain.ChangeItemKeyByItem.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeItemKeyByItem.Setter = "SetItemKey";
	Options = ModelClientServer_V2.ChangeItemKeyByItemOptions();
	Options.Item    = GetItem(Parameters);
	Options.ItemKey = GetItemKey(Parameters);
	Options.StepName = "StepChangeItemKeyByItem";
	Chain.ChangeItemKeyByItem.Options.Add(Options);
EndProcedure

#EndRegion

#Region BILL_OF_MATERIALS

// BillOfMaterials.OnChange
Procedure BillOfMaterialsOnChange(Parameters) Export
	AddViewNotify("OnSetBillOfMaterialsNotify", Parameters);
	Binding = BindBillOfMaterials(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// BillOfMaterials.Set
Procedure SetBillOfMaterials(Parameters, Results) Export
	Binding = BindBillOfMaterials(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetBillOfMaterialsNotify");
EndProcedure

// BillOfMaterials.Get
Function GetBillOfMaterials(Parameters)
	Return GetPropertyObject(Parameters, BindBillOfMaterials(Parameters).DataPath);
EndFunction

// BillOfMaterials.Bind
Function BindBillOfMaterials(Parameters)
	DataPath = "BillOfMaterials";
	Binding = New Structure();
	
	Binding.Insert("Production",
		"StepMaterialsCalculations,
		|StepChangeCostMultiplierRatioByBillOfMaterials,
		|StepChangeDurationOfProductionByBillOfMaterials");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindBillOfMaterials");
EndFunction

// BillOfMaterials.ChangeBillOfMaterialsByItemKey.Step
Procedure StepChangeBillOfMaterialsByItemKey(Parameters, Chain) Export
	Chain.ChangeBillOfMaterialsByItemKey.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeBillOfMaterialsByItemKey.Setter = "SetBillOfMaterials";
	Options = ModelClientServer_V2.ChangeBillOfMaterialsByItemKeyOptions();
	Options.ItemKey = GetItemKey(Parameters);
	Options.CurrentBillOfMaterials = GetBillOfMaterials(Parameters);
	Options.StepName = "StepChangeBillOfMaterialsByItemKey";
	Chain.ChangeBillOfMaterialsByItemKey.Options.Add(Options);
EndProcedure

#EndRegion

#Region COST_MULTIPLIER_RATIO

// CostMultiplierRatio.Set
Procedure SetCostMultiplierRatio(Parameters, Results) Export
	Binding = BindCostMultiplierRatio(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// CostMultiplierRatio.Bind
Function BindCostMultiplierRatio(Parameters)
	DataPath = "CostMultiplierRatio";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindCostMultiplierRatio");
EndFunction

// CostMultiplierRatio.ChangeCostMultiplierRatioByBillOfMaterials.Step
Procedure StepChangeCostMultiplierRatioByBillOfMaterials(Parameters, Chain) Export
	Chain.ChangeCostMultiplierRatioByBillOfMaterials.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeCostMultiplierRatioByBillOfMaterials.Setter = "SetCostMultiplierRatio";
	Options = ModelClientServer_V2.ChangeCostMultiplierRatioByBillOfMaterialsOptions();
	Options.BillOfMaterials = GetBillOfMaterials(Parameters);
	Options.StepName = "StepChangeCostMultiplierRatioByBillOfMaterials";
	Chain.ChangeCostMultiplierRatioByBillOfMaterials.Options.Add(Options);
EndProcedure

#EndRegion

#Region DURATION_OF_PRODUCTION

// DurationOfProduction.Set
Procedure SetDurationOfProduction(Parameters, Results) Export
	Binding = BindDurationOfProduction(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// DurationOfProduction.Get
Function GetDurationOfProduction(Parameters)
	Return GetPropertyObject(Parameters, BindDurationOfProduction(Parameters).DataPath);
EndFunction

// DurationOfProduction.Bind
Function BindDurationOfProduction(Parameters)
	DataPath = "DurationOfProduction";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindDurationOfProduction");
EndFunction

// DurationOfProduction.ChangeDurationOfProductionByBillOfMaterials.Step
Procedure StepChangeDurationOfProductionByBillOfMaterials(Parameters, Chain) Export
	Chain.ChangeDurationOfProductionByBillOfMaterials.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeDurationOfProductionByBillOfMaterials.Setter = "SetDurationOfProduction";
	Options = ModelClientServer_V2.ChangeDurationOfProductionByBillOfMaterialsOptions();
	Options.BillOfMaterials = GetBillOfMaterials(Parameters);
	Options.ItemKey         = GetItemKey(Parameters);
	Options.Unit            = GetUnit(Parameters);
	Options.Quantity        = GetQUantity(Parameters);
	Options.CurrentDurationOfProduction = GetDurationOfProduction(Parameters);
	Options.StepName = "StepChangeDurationOfProductionByBillOfMaterials";
	Chain.ChangeDurationOfProductionByBillOfMaterials.Options.Add(Options);
EndProcedure

#EndRegion

#Region PRODUCTION_PLANNING

// ProductionPlanning.Set
Procedure SetProductionPlanning(Parameters, Results) Export
	Binding = BindProductionPlanning(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ProductionPlanning.Get
Function GetProductionPlanning(Parameters)
	Return GetPropertyObject(Parameters, BindProductionPlanning(Parameters).DataPath);
EndFunction

// ProductionPlanning.Bind
Function BindProductionPlanning(Parameters)
	DataPath = "ProductionPlanning";
	Binding = New Structure();
	
	Binding.Insert("ProductionPlanningCorrection",
		"StepChangeCurrentQuantityInProductions");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindProductionPlanning");
EndFunction

// ProductionPlanning.ChangeProductionPlanningByPlanningPeriod.Step
Procedure StepChangeProductionPlanningByPlanningPeriod(Parameters, Chain) Export
	Chain.ChangeProductionPlanningByPlanningPeriod.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeProductionPlanningByPlanningPeriod.Setter = "SetProductionPlanning";
	Options = ModelClientServer_V2.ChangeProductionPlanningByPlanningPeriodOptions();
	Options.Company        = GetCompany(Parameters);
	Options.BusinessUnit   = GetBusinessUnit(Parameters);
	Options.PlanningPeriod = GetPlanningPeriod(Parameters);
	Options.CurrentProductionPlanning = GetProductionPlanning(Parameters);
	Options.DontExecuteIfExecutedBefore = True;
	Options.StepName = "StepChangeProductionPlanningByPlanningPeriod";
	Chain.ChangeProductionPlanningByPlanningPeriod.Options.Add(Options);
EndProcedure

#EndRegion

#Region PLANNING_PERIOD

// PlanningPeriod.OnChange
Procedure PlanningPeriodOnChange(Parameters) Export
	AddViewNotify("OnSetPlanningPeriodNotify", Parameters);
	Binding = BindPlanningPeriod(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PlanningPeriod.Set
Procedure SetPlanningPeriod(Parameters, Results) Export
	Binding = BindPlanningPeriod(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetPlanningPeriodNotify");
EndProcedure

// PlanningPeriod.Get
Function GetPlanningPeriod(Parameters)
	Return GetPropertyObject(Parameters, BindPlanningPeriod(Parameters).DataPath);
EndFunction

// PlanningPeriod.Bind
Function BindPlanningPeriod(Parameters)
	DataPath = "PlanningPeriod";
	Binding = New Structure();
	
	Binding.Insert("ProductionPlanning",
		"StepBillOfMaterialsListCalculations");
	
	Binding.Insert("ProductionPlanningCorrection",
		"StepChangeProductionPlanningByPlanningPeriod,
		|StepChangeCurrentQuantityInProductions,
		|StepBillOfMaterialsListCalculationsCorrection");
	
	Binding.Insert("Production",
		"StepChangeProductionPlanningByPlanningPeriod");
		
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPlanningPeriod");
EndFunction

// PlanningPeriod.ChangePlanningPeriodByDateAndBusinessUnit.Step
Procedure StepChangePlanningPeriodByDateAndBusinessUnit(Parameters, Chain) Export
	Chain.ChangePlanningPeriodByDateAndBusinessUnit.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangePlanningPeriodByDateAndBusinessUnit.Setter = "SetPlanningPeriod";
	Options = ModelClientServer_V2.ChangePlanningPeriodByDateAndBusinessUnitOptions();
	Options.Date = GetDate(Parameters);
	Options.BusinessUnit = GetBusinessUnit(Parameters);
	Options.StepName = "StepChangePlanningPeriodByDateAndBusinessUnit";
	Chain.ChangePlanningPeriodByDateAndBusinessUnit.Options.Add(Options);
EndProcedure

#EndRegion

#Region BUSINESS_UNIT

// BusinessUnit.OnChange
Procedure BusinessUnitOnChange(Parameters) Export
	AddViewNotify("OnSetBusinessUnitNotify", Parameters);
	Binding = BindBusinessUnit(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// BusinessUnit.Set
Procedure SetBusinessUnit(Parameters, Results) Export
	Binding = BindBusinessUnit(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetBusinessUnitNotify");
EndProcedure

// BusinessUnit.Get
Function GetBusinessUnit(Parameters)
	Return GetPropertyObject(Parameters, BindBusinessUnit(Parameters).DataPath);
EndFunction

// BusinessUnit.Bind
Function BindBusinessUnit(Parameters)
	DataPath = "BusinessUnit";
	Binding = New Structure();
	Binding.Insert("ProductionPlanning", 
		"StepChangePlanningPeriodByDateAndBusinessUnit,
		|StepBillOfMaterialsListCalculations");
	                                     
	Binding.Insert("ProductionPlanningCorrection", 
		"StepChangePlanningPeriodByDateAndBusinessUnit,
		|StepChangeProductionPlanningByPlanningPeriod,
		|StepBillOfMaterialsListCalculationsCorrection");

	Binding.Insert("Production", 
		"StepChangePlanningPeriodByDateAndBusinessUnit");
		
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindBusinessUnit");
EndFunction

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
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentTerms");
EndFunction

// PaymentTerms.ChangePaymentTermsByAgreement.Step
Procedure StepChangePaymentTermsByAgreement(Parameters, Chain) Export
	Chain.ChangePaymentTermsByAgreement.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangePaymentTermsByAgreement.Setter = "SetPaymentTerms";
	Options = ModelClientServer_V2.ChangePaymentTermsByAgreementOptions();
	Options.Agreement = GetAgreement(Parameters);
	Options.Date      = GetDate(Parameters);
	If Options.Date = Date(1,1,1) Then
		Options.Date = BegOfDay(CommonFunctionsServer.GetCurrentSessionDate());
	EndIf;
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
	If Chain.Idle Then
		Return;
	EndIf;
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

// Offers.Set
Procedure SetSpecialOffers(Parameters, Results)
	TableName = "SpecialOffers";
	If Not Parameters.Cache.Property(TableName) Then
		AddTableToCacheRemovable(Parameters, TableName);
	EndIf;
	
	UpdateTableCacheRemovable(Parameters, TableName, Results);	
EndProcedure

// Offers.Bind
Function BindOffers(Parameters)
	DataPath = "Offers";
	Binding = New Structure();
	Return BindSteps("StepItemListCalculations_IsOffersChanged", DataPath, Binding, Parameters, "BindOffers");
EndFunction

#EndRegion

#Region TAX_LIST

// TaxList.Set
Procedure SetTaxList(Parameters, Results)
	TableName = "TaxList";
	If Not Parameters.Cache.Property(TableName) Then
		AddTableToCacheRemovable(Parameters, TableName);
	EndIf;
	
	UpdateTableCacheRemovable(Parameters, TableName, Results);
EndProcedure

#EndRegion

#Region TAX_RATE

// TaxRate.Get
Function GetTaxRate(Parameters, Row)
	TaxRates = New Structure();
	If Not CommonFunctionsClientServer.ObjectHasProperty(Row, "TaxRates") Then
		Return TaxRates;
	EndIf;
	
	ReadOnlyFromCache = Not Parameters.FormTaxColumnsExists;
	For Each TaxRate In Row.TaxRates Do
		If ReadOnlyFromCache And ValueIsFilled(TaxRate.Value) Then
			TaxRates.Insert(TaxRate.Key, TaxRate.Value);
		Else
			TaxRates.Insert(TaxRate.Key, GetPropertyObject(Parameters, Parameters.TableName + "." + TaxRate.Key, Row.Key, ReadOnlyFromCache));
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

// <List>.ChangeTaxRate.[WithoutAgreement].Step
Procedure StepChangeTaxRate_WithoutAgreement(Parameters, Chain) Export
	StepChangeTaxRate(Parameters, Chain);
EndProcedure

// <List>.ChangeTaxRate.[AgreementInHeader].Step
Procedure StepChangeTaxRate_AgreementInHeader_ConsignorBatches(Parameters, Chain) Export
	StepChangeTaxRate(Parameters, Chain, True, ,True);
EndProcedure

// <List>.ChangeTaxRate.Step
Procedure StepChangeTaxRate(Parameters, Chain, AgreementInHeader = False, AgreementInList = False, ConsignorBatches = False)
	Chain.ChangeTaxRate.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeTaxRate.Setter = "Set" + Parameters.TableName + "TaxRate";
	
	Options_Date            = GetDate(Parameters);
	Options_Company         = GetCompany(Parameters);
	Options_TransactionType = GetTransactionType(Parameters);
		
	Parameters.ArrayOfTaxInfo = TaxesServer.GetArrayOfTaxInfo(Parameters.Object, Options_Date, Options_Company, Options_TransactionType);
	
	AllTableRows =  GetRows(Parameters, Parameters.TableName);
	
	If ConsignorBatches Then
		For Each Row In Parameters.RowsConsignorStocks Do
			If Row.Property("InventoryOrigin") Then
				Parameters.UseRowsForRecalculate = True;
				If GetItemListInventoryOrigin(Parameters, Row.Key) = PredefinedValue("Enum.InventoryOriginTypes.ConsignorStocks") Then				
					Parameters.RowsForRecalculate.Add(Row);
				EndIf;
			EndIf;
		EndDo;
	EndIf;
	
	TableRows = New Array();
	
	If Parameters.UseRowsForRecalculate Then
		If Parameters.RowsForRecalculate.Count() Then
			TableRows = Parameters.RowsForRecalculate;
		Else
			If AllTableRows.Count() = 1 Then
				TableRows.Add(AllTableRows[0]);
				Parameters.RowsForRecalculate.Add(AllTableRows[0]);
			EndIf;
		EndIf;
	Else
		TableRows = AllTableRows;
	EndIf;
		
	For Each Row In TableRows Do
		// ChangeTaxRate
		Options = ModelClientServer_V2.ChangeTaxRateOptions();
		If AgreementInHeader Then
			Options.Agreement = GetAgreement(Parameters);
		EndIf;
		
		If AgreementInList Then
			Options.Agreement = GetPropertyObject(Parameters, Parameters.TableName + "." + "Agreement", Row.Key);
		EndIf;
		
		If Row.Property("InventoryOrigin") Then
			Options.InventoryOrigin  = GetItemListInventoryOrigin(Parameters, Row.Key);
			Options.ConsignorBatches = GetConsignorBatches(Parameters, Row.Key);
			Options.Consignor = GetItemListConsignor(Parameters, Row.Key);
		EndIf;
		
		If Row.Property("ItemKey") Then
			Options.ItemKey = GetItemListItemKey(Parameters, Row.Key);
		EndIf;
		
		Options.Date            = Options_Date;
		Options.Company         = Options_Company;
		Options.TransactionType = Options_TransactionType;		
		
		Options.ArrayOfTaxInfo  = Parameters.ArrayOfTaxInfo;
		Options.IsBasedOn       = Parameters.IsBasedOn;
		Options.Ref             = Parameters.Object.Ref;
		
		// update Tax rates
		For Each TaxInfoItem In Parameters.ArrayOfTaxInfo Do
			If Not Row.TaxRates.Property(TaxInfoItem.Name) Then
				Row.TaxRates.Insert(TaxInfoItem.Name);
				SetProperty(Parameters, Parameters.Cache, Parameters.TableName + "." + TaxInfoItem.Name, Row.Key, Undefined);
			EndIf;
		EndDo;
				
		Options.TaxRates = GetTaxRate(Parameters, Row);
		Options.TaxList  = Row.TaxList;
		Options.Key = Row.Key;
		Options.StepName = "StepChangeTaxRate";
		Chain.ChangeTaxRate.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region TRANSACTIONS_LIST

#Region TRANSACTIONS_LIST_PARTNER

// Transactions.Partner.OnChange
Procedure TransactionsPartnerOnChange(Parameters) Export
	Binding = BindTransactionsPartner(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Transactions.Partner.Set
Procedure SetTransactionsPartner(Parameters, Results) Export
	Binding = BindTransactionsPartner(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Transactions.Partner.Get
Function GetTransactionsPartner(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindTransactionsPartner(Parameters).DataPath, _Key);
EndFunction

// Transactions.Partner.Bind
Function BindTransactionsPartner(Parameters)
	DataPath = "Transactions.Partner";
	Binding = New Structure();
	Binding.Insert("CreditNote",
		"StepTransactionsChangeLegalNameByPartner,
		|StepTransactionsChangeAgreementByPartner");
	
	Binding.Insert("DebitNote",
		"StepTransactionsChangeLegalNameByPartner,
		|StepTransactionsChangeAgreementByPartner");
		
	Return BindSteps(Undefined, DataPath, Binding, Parameters, "BindTransactionsPartner");
EndFunction

// Transactions.Partner.ChangePartnerByLegalName.Step
Procedure StepTransactionsChangePartnerByLegalName(Parameters, Chain) Export
	Chain.ChangePartnerByLegalName.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangePartnerByLegalName.Setter = "SetTransactionsPartner";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeLegalNameByPartnerOptions();
		Options.Partner   = GetTransactionsPartner(Parameters, Row.Key);
		Options.LegalName = GetTransactionsLegalName(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepTransactionsChangePartnerByLegalName";
		Chain.ChangePartnerByLegalName.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region TRANSACTIONS_LIST_AGREEMENT

// Transactions.Agreement.OnChange
Procedure TransactionsAgreementOnChange(Parameters) Export
	Binding = BindTransactionsAgreement(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Transactions.Agreement.Set
Procedure SetTransactionsAgreement(Parameters, Results) Export
	Binding = BindTransactionsAgreement(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Transactions.Agreement.Get
Function GetTransactionsAgreement(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindTransactionsAgreement(Parameters).DataPath , _Key);
EndFunction

// Transactions.Agreement.Bind
Function BindTransactionsAgreement(Parameters)
	DataPath = "Transactions.Agreement";
	Binding = New Structure();
	Binding.Insert("CreditNote",
		"StepTransactionsChangeCurrencyByAgreement");
	
	Binding.Insert("DebitNote",
		"StepTransactionsChangeCurrencyByAgreement");
	Return BindSteps(Undefined, DataPath, Binding, Parameters, "BindTransactionsAgreement");
EndFunction

// Transactions.Agreement.ChangeAgreementByPartner.Step
Procedure StepTransactionsChangeAgreementByPartner(Parameters, Chain) Export
	Chain.ChangeAgreementByPartner.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeAgreementByPartner.Setter = "SetTransactionsAgreement";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeAgreementByPartnerOptions();
		Options.Partner       = GetTransactionsPartner(Parameters, Row.Key);
		Options.Agreement     = GetTransactionsAgreement(Parameters, Row.Key);
		Options.CurrentDate   = GetDate(Parameters);
		Options.Key = Row.Key;
		Options.StepName = "StepTransactionsChangeAgreementByPartner";
		Chain.ChangeAgreementByPartner.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region TRANSACTIONS_LIST_LEGAL_NAME

// Transactions.LegalName.OnChange
Procedure TransactionsLegalNameOnChange(Parameters) Export
	Binding = BindTransactionsLegalName(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Transactions.LegalName.Set
Procedure SetTransactionsLegalName(Parameters, Results) Export
	Binding = BindTransactionsLegalName(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Transactions.LegalName.Get
Function GetTransactionsLegalName(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindTransactionsLegalName(Parameters).DataPath , _Key);
EndFunction

// Transactions.LegalName.Bind
Function BindTransactionsLegalName(Parameters)
	DataPath = "Transactions.LegalName";
	Binding = New Structure();
	Binding.Insert("CreditNote",
		"StepTransactionsChangePartnerByLegalName");
	
	Binding.Insert("DebitNote",
		"StepTransactionsChangePartnerByLegalName");
	Return BindSteps(Undefined, DataPath, Binding, Parameters, "BindTransactionsLegalName");
EndFunction

// Transactions.LegalName.ChangeLegalNameByPartner.Step
Procedure StepTransactionsChangeLegalNameByPartner(Parameters, Chain) Export
	Chain.ChangeLegalNameByPartner.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeLegalNameByPartner.Setter = "SetTransactionsLegalName";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeLegalNameByPartnerOptions();
		Options.Partner   = GetTransactionsPartner(Parameters, Row.Key);
		Options.LegalName = GetTransactionsLegalName(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepTransactionsChangeLegalNameByPartner";
		Chain.ChangeLegalNameByPartner.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region TRANSACTIONS_LIST_CURRENCY

// Transactions.Currency.Set
Procedure SetTransactionsCurrency(Parameters, Results) Export
	Binding = BindTransactionsCurrency(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Transactions.Currency.Get
Function GetTransactionsCurrency(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindTransactionsCurrency(Parameters).DataPath , _Key);
EndFunction

// Transactions.Currency.Bind
Function BindTransactionsCurrency(Parameters)
	DataPath = "Transactions.Currency";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindTransactionsCurrency");
EndFunction

// Transactions.Currency.ChangeCurrencyByAgreement.Step
Procedure StepTransactionsChangeCurrencyByAgreement(Parameters, Chain) Export
	Chain.ChangeCurrencyByAgreement.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeCurrencyByAgreement.Setter = "SetTransactionsCurrency";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeCurrencyByAgreementOptions();
		Options.Agreement       = GetTransactionsAgreement(Parameters, Row.Key);
		Options.CurrentCurrency = GetTransactionsCurrency(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepTransactionsChangeCurrencyByAgreement";
		Chain.ChangeCurrencyByAgreement.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

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
	
	Binding.Insert("CashExpense", "BindVoid");
	
	Binding.Insert("CashRevenue", "BindVoid");
	
	Return BindSteps(Undefined, DataPath, Binding, Parameters, "BindPaymentListPartner");
EndFunction

// PaymentList.Partner.ChangePartnerByLegalName.Step
Procedure StepPaymentListChangePartnerByLegalName(Parameters, Chain) Export
	Chain.ChangePartnerByLegalName.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
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

#Region PAYMENT_LIST_RETAIL_CUSTOMER

// PaymentList.RetailCustomer.OnChange
Procedure PaymentListRetailCustomerOnChange(Parameters) Export
	Binding = BindPaymentListRetailCustomer(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.RetailCustomer.Set
Procedure SetPaymentListRetailCustomer(Parameters, Results) Export
	Binding = BindPaymentListRetailCustomer(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.RetailCustomer.Get
Function GetPaymentListRetailCustomer(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentListRetailCustomer(Parameters).DataPath, _Key);
EndFunction

// PaymentList.RetailCustomer.Bind
Function BindPaymentListRetailCustomer(Parameters)
	DataPath = "PaymentList.RetailCustomer";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentListRetailCustomer");
EndFunction

#EndRegion

#Region PAYMENT_LIST_EMPLOYEE

// PaymentList.Employee.OnChange
Procedure PaymentListEmployeeOnChange(Parameters) Export
	Binding = BindPaymentListEmployee(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.Employee.Set
Procedure SetPaymentListEmployee(Parameters, Results) Export
	Binding = BindPaymentListEmployee(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.Employee.Get
Function GetPaymentListEmployee(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentListEmployee(Parameters).DataPath, _Key);
EndFunction

// PaymentList.Employee.Bind
Function BindPaymentListEmployee(Parameters)
	DataPath = "PaymentList.Employee";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentListEmployee");
EndFunction

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

// PaymentList.PartnerBankAccount.Get
Function GetPaymentListPartnerBankAccount(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentListPartnerBankAccount(Parameters).DataPath , _Key);
EndFunction

// PaymentList.PartnerBankAccount.Bind
Function BindPaymentListPartnerBankAccount(Parameters)
	DataPath = "PaymentList.PartnerBankAccount";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentListPartnerBankAccount");
EndFunction

// PaymentList.PartnerBankAccount.ChangeCashAccountByPartner.Step
Procedure StepPaymentListChangeCashAccountByPartner(Parameters, Chain) Export
	Chain.ChangeCashAccountByPartner.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeCashAccountByPartner.Setter = "SetPaymentListPartnerBankAccount";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeCashAccountByPartnerOptions();
		Options.Partner   = GetPaymentListPartner(Parameters, Row.Key);
		Options.LegalName = GetPaymentListLegalName(Parameters, Row.Key);
		Options.Currency  = GetCurrency(Parameters);
		Options.TransactionType = GetTransactionType(Parameters);
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
	Return BindSteps(Undefined, DataPath, Binding, Parameters, "BindPaymentListAgreement");
EndFunction

// PaymentList.Agreement.ChangeAgreementByPartner.Step
Procedure StepPaymentListChangeAgreementByPartner(Parameters, Chain) Export
	Chain.ChangeAgreementByPartner.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
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
	Binding.Insert("BankPayment"             ,"StepPaymentListDefaultCurrencyInList");
	Binding.Insert("BankReceipt"             ,"StepPaymentListDefaultCurrencyInList");
	Binding.Insert("CashExpense"             ,"StepPaymentListDefaultCurrencyInList");
	Binding.Insert("CashPayment"             ,"StepPaymentListDefaultCurrencyInList");
	Binding.Insert("CashReceipt"             ,"StepPaymentListDefaultCurrencyInList");
	Binding.Insert("CashRevenue"             ,"StepPaymentListDefaultCurrencyInList");
	Binding.Insert("CashStatement"           ,"StepPaymentListDefaultCurrencyInList");
	Binding.Insert("ConsolidatedRetailSales" ,"StepPaymentListDefaultCurrencyInList");
	Binding.Insert("IncomingPaymentOrder"    ,"StepPaymentListDefaultCurrencyInList");
	Binding.Insert("OutgoingPaymentOrder"    ,"StepPaymentListDefaultCurrencyInList");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindDefaultPaymentListCurrency");
EndFunction

// PaymentList.Currency.Bind
Function BindPaymentListCurrency(Parameters)
	DataPath = "PaymentList.Currency";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentListCurrency");
EndFunction

// PaymentList.Currency..StepPaymentListDefaultCurrencyInList.Step
Procedure StepPaymentListDefaultCurrencyInList(Parameters, Chain) Export
	Chain.DefaultCurrencyInList.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
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
	Return BindSteps(Undefined, DataPath, Binding, Parameters, "BindPaymentListLegalName");
EndFunction

// PaymentList.LegalName.ChangeLegalNameByPartner.Step
Procedure StepPaymentListChangeLegalNameByPartner(Parameters, Chain) Export
	Chain.ChangeLegalNameByPartner.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeLegalNameByPartner.Setter = "SetPaymentListLegalName";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeLegalNameByPartnerOptions();
		Options.Partner         = GetPaymentListPartner(Parameters, Row.Key);
		Options.LegalName       = GetPaymentListLegalName(Parameters, Row.Key);
		Options.TransactionType = GetTransactionType(Parameters);
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
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentListLegalNameContract");
EndFunction

#EndRegion

#Region PAYMENT_LIST_ACCOUNT

// PaymentList.Account.OnChange
Procedure PaymentListAccountOnChange(Parameters) Export
	Binding = BindPaymentListAccount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.Account.Set
Procedure SetPaymentListAccount(Parameters, Results) Export
	Binding = BindPaymentListAccount(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.Account.Get
Function GetPaymentListAccount(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentListAccount(Parameters).DataPath , _Key);
EndFunction

// PaymentList.Account.Bind
Function BindPaymentListAccount(Parameters)
	DataPath = "PaymentList.Account";
	Binding = New Structure();
	Binding.Insert("CashStatement", "StepPaymentListChangeReceiptingAccountByAccount");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentListAccount");
EndFunction

#EndRegion

#Region PAYMENT_LIST_RECEIPTING_ACCOUNT

// PaymentList.ReceiptingAccount.OnChange
Procedure PaymentListReceiptingAccountOnChange(Parameters) Export
	Binding = BindPaymentListReceiptingAccount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.ReceiptingAccount.Set
Procedure SetPaymentListReceiptingAccount(Parameters, Results) Export
	Binding = BindPaymentListReceiptingAccount(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.ReceiptingAccount.Get
Function GetPaymentListReceiptingAccount(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentListReceiptingAccount(Parameters).DataPath , _Key);
EndFunction

// PaymentList.ReceiptingAccount.Bind
Function BindPaymentListReceiptingAccount(Parameters)
	DataPath = "PaymentList.ReceiptingAccount";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentListReceiptingAccount");
EndFunction

// PaymentList.ReceiptingAccount.ChangeReceiptingAccountByAccount.Step
Procedure StepPaymentListChangeReceiptingAccountByAccount(Parameters, Chain) Export
	Chain.ChangeReceiptingAccountByAccount.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeReceiptingAccountByAccount.Setter = "SetPaymentListReceiptingAccount";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeReceiptingAccountByAccountOptions();
		Options.Account                  = GetPaymentListAccount(Parameters, Row.Key);
		Options.CurrentReceiptingAccount = GetPaymentListReceiptingAccount(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepPaymentListChangeReceiptingAccountByAccount";
		Chain.ChangeReceiptingAccountByAccount.Options.Add(Options);
	EndDo;
EndProcedure

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
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentListPOSAccount");
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
	DataPath = New Map();
	DataPath.Insert("BankPayment", "PaymentList.BasisDocument");
	DataPath.Insert("BankReceipt", "PaymentList.BasisDocument");
	DataPath.Insert("CashPayment", "PaymentList.BasisDocument");
	DataPath.Insert("CashReceipt", "PaymentList.BasisDocument");
	
	DataPath.Insert("IncomingPaymentOrder", "PaymentList.Basis");
	DataPath.Insert("OutgoingPaymentOrder", "PaymentList.Basis");
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentListBasisDocument");
EndFunction

// PaymentList.BasisDocument.ChangeBasisDocumentByAgreement.Step
Procedure StepPaymentListChangeBasisDocumentByAgreement(Parameters, Chain) Export
	Chain.ChangeBasisDocumentByAgreement.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
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
	Return BindSteps(Undefined, DataPath, Binding, Parameters, "BindPaymentListPlanningTransactionBasis");
EndFunction

// PaymentList.PlanningTransactionBasis.ChangePlanningTransactionBasisByCurrency.Step
Procedure StepChangePlanningTransactionBasisByCurrency(Parameters, Chain) Export
	Chain.ChangePlanningTransactionBasisByCurrency.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
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

// PaymentList.PlanningTransactionBasis.BankPayment.MultiSet
Procedure MultiSetPaymentListPlanningTransactionBasis_BankPayment(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Account"     , BindAccount(Parameters));
	ResourceToBinding.Insert("Company"     , BindCompany(Parameters));
	ResourceToBinding.Insert("Currency"    , BindCurrency(Parameters));
	ResourceToBinding.Insert("TotalAmount" , BindPaymentListTotalAmount(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// PaymentList.PlanningTransactionBasis.CashPayment.MultiSet
Procedure MultiSetPaymentListPlanningTransactionBasis_CashPayment(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Account"     , BindAccount(Parameters));
	ResourceToBinding.Insert("Company"     , BindCompany(Parameters));
	ResourceToBinding.Insert("Currency"    , BindCurrency(Parameters));
	ResourceToBinding.Insert("Partner"     , BindPaymentListPartner(Parameters));
	ResourceToBinding.Insert("TotalAmount" , BindPaymentListTotalAmount(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// PaymentList.PlanningTransactionBasis.BankReceipt.MultiSet
Procedure MultiSetPaymentListPlanningTransactionBasis_BankReceipt(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Account"          , BindAccount(Parameters));
	ResourceToBinding.Insert("Company"          , BindCompany(Parameters));
	ResourceToBinding.Insert("Currency"         , BindCurrency(Parameters));
	ResourceToBinding.Insert("CurrencyExchange" , BindCurrencyExchange(Parameters));
	ResourceToBinding.Insert("TotalAmount"      , BindPaymentListTotalAmount(Parameters));
	ResourceToBinding.Insert("AmountExchange"   , BindPaymentListAmountExchange(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// PaymentList.PlanningTransactionBasis.CashReceipt.MultiSet
Procedure MultiSetPaymentListPlanningTransactionBasis_CashReceipt(Parameters, Results) Export
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
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.FillByPTBBankPayment.Setter = "MultiSetPaymentListPlanningTransactionBasis_BankPayment";
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
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.FillByPTBCashPayment.Setter = "MultiSetPaymentListPlanningTransactionBasis_CashPayment";
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
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.FillByPTBBankReceipt.Setter = "MultiSetPaymentListPlanningTransactionBasis_BankReceipt";
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
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.FillByPTBCashReceipt.Setter = "MultiSetPaymentListPlanningTransactionBasis_CashReceipt";
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

#Region PAYMENT_LIST_MONEY_TRANSFER

// PaymentList.MoneyTransfer.OnChange
Procedure PaymentListMoneyTransferOnChange(Parameters) Export
	Binding = BindPaymentListMoneyTransfer(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.MoneyTransfer.Set
Procedure SetPaymentListMoneyTransfer(Parameters, Results) Export
	Binding = BindPaymentListMoneyTransfer(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.MoneyTransfer.Get
Function GetPaymentListMoneyTransfer(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentListMoneyTransfer(Parameters).DataPath , _Key);
EndFunction

// PaymentList.MoneyTransfer.Bind
Function BindPaymentListMoneyTransfer(Parameters)
	DataPath = "PaymentList.MoneyTransfer";
	Binding = New Structure();
	Binding.Insert("CashReceipt" , "StepPaymentListFillByMoneyTransferCashReceipt");
	Return BindSteps(Undefined, DataPath, Binding, Parameters, "BindPaymentListMoneyTransfer");
EndFunction

// PaymentList.MoneyTransfer.CashReceipt.MultiSet
Procedure MultiSetPaymentListMoneyTransfer_CashReceipt(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Company"          , BindCompany(Parameters));
	ResourceToBinding.Insert("Account"          , BindAccount(Parameters));
	ResourceToBinding.Insert("Currency"         , BindCurrency(Parameters));
	ResourceToBinding.Insert("TotalAmount"      , BindPaymentListTotalAmount(Parameters));
	ResourceToBinding.Insert("FinancialMovementType" , BindPaymentListFinancialMovementType(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// PaymentList.MoneyTransfer.FillByMoneyTransferCashReceipt.Step
Procedure StepPaymentListFillByMoneyTransferCashReceipt(Parameters, Chain) Export
	Chain.FillByMoneyTransferCashReceipt.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.FillByMoneyTransferCashReceipt.Setter = "MultiSetPaymentListMoneyTransfer_CashReceipt";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.FillByMoneyTransferCashReceiptOptions();
		Options.MoneyTransfer         = GetPaymentListMoneyTransfer(Parameters, Row.Key);
		Options.TotalAmount           = GetPaymentListTotalAmount(Parameters, Row.Key);
		Options.FinancialMovementType = GetPaymentListFinancialMovementType(Parameters, Row.Key);
		Options.Company  = GetCompany(Parameters);
		Options.Account  = GetAccount(Parameters);
		Options.Currency = GetCurrency(Parameters);
		Options.Ref = Parameters.Object.Ref;
		Options.Key = Row.Key;
		Options.StepName = "StepPaymentListFillByMoneyTransferCashReceipt";
		Chain.FillByMoneyTransferCashReceipt.Options.Add(Options);
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
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentListOrder");
EndFunction

// PaymentList.Order.ChangeOrderByAgreement.Step
Procedure StepPaymentListChangeOrderByAgreement(Parameters, Chain) Export
	Chain.ChangeOrderByAgreement.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
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
				Parameters, TaxRateResult, , , , ReadOnlyFromCache);
		EndDo;
	EndDo;
EndProcedure

// PaymentList.TaxRate.Bind
Function BindPaymentListTaxRate(Parameters)
	DataPath = "PaymentList.";
	Binding = New Structure();
	Return BindSteps("StepPaymentListCalculations_IsTaxRateChanged", DataPath, Binding, Parameters, "BindPaymentListTaxRate");
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
	Return BindSteps("StepPaymentListCalculations_IsDontCalculateRowChanged", DataPath, Binding, Parameters, "BindPaymentListDontCalculateRow");
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
	Return BindSteps(Steps, DataPath, Binding, Parameters, "BindPaymentListTaxAmount");
EndFunction

// PaymentList.TaxAmount.ChangeTaxAmountAsManualAmount.Step
Procedure StepPaymentListChangeTaxAmountAsManualAmount(Parameters, Chain) Export
	Chain.ChangeTaxAmountAsManualAmount.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
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

#Region PAYMENT_LIST_TAX_AMOUNT_USER_FORM

// PaymentList.TaxAmountUserForm.OnChange
Procedure PaymentListTaxAmountUserFormOnChange(Parameters) Export
	Binding = BindPaymentListTaxAmountUserForm(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Payment.TaxAmountUserForm.Bind
Function BindPaymentListTaxAmountUserForm(Parameters)
	DataPath = "PaymentList.TaxAmount";
	Binding = New Structure();
	Return BindSteps("StepItemListCalculations_IsTaxAmountUserFormChanged", DataPath, Binding, Parameters, "BindPaymentListTaxAmountUserForm");
EndFunction

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
	Return BindSteps(Steps, DataPath, Binding, Parameters, "BindPaymentListNetAmount");
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
	Binding.Insert("BankPayment",
		"StepPaymentListCalculateCommission,
		|StepPaymentListCalculations_IsTotalAmountChanged");
	
	Binding.Insert("BankReceipt", 
		"StepPaymentListCalculateCommission,
		|StepPaymentListCalculations_IsTotalAmountChanged");
		
	Steps = "StepPaymentListCalculations_IsTotalAmountChanged";
	Return BindSteps(Steps, DataPath, Binding, Parameters, "BindPaymentListTotalAmount");
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
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentListAmountExchange");
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
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentListCalculations");
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
	If Chain.Idle Then
		Return;
	EndIf;
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
		
		If StrSplit(Parameters.ObjectMetadataInfo.Tables.PaymentList.Columns, ",").Find("DontCalculateRow") <> Undefined Then
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

#Region PAYMENT_LIST_PAYMENT_TYPE

// PaymentList.PaymentType.OnChange
Procedure PaymentListPaymentTypeOnChange(Parameters) Export
	Binding = BindPaymentListPaymentType(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.PaymentType.Set
Procedure SetPaymentListPaymentType(Parameters, Results) Export
	Binding = BindPaymentListPaymentType(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.PaymentType.Get
Function GetPaymentListPaymentType(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentListPaymentType(Parameters).DataPath , _Key);
EndFunction

// PaymentList.PaymentType.Bind
Function BindPaymentListPaymentType(Parameters)
	DataPath = "PaymentList.PaymentType";
	Binding = New Structure();

	Binding.Insert("BankPayment", 
		"StepPaymentListGetCommissionPercent");
	
	Binding.Insert("BankReceipt", 
		"StepPaymentListGetCommissionPercent");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentListPaymentType");
EndFunction

#EndRegion

#Region PAYMENT_LIST_PAYMENT_TERMINAL

// PaymentList.PaymentTerminal.Set
Procedure SetPaymentListPaymentTerminal(Parameters, Results) Export
	Binding = BindPaymentListPaymentTerminal(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.PaymentTerminal.Get
Function GetPaymentListPaymentTerminal(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentListPaymentTerminal(Parameters).DataPath , _Key);
EndFunction

// PaymentList.PaymentTerminal.Bind
Function BindPaymentListPaymentTerminal(Parameters)
	DataPath = "PaymentList.PaymentTerminal";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentListPaymentTerminal");
EndFunction

#EndRegion

#Region PAYMENT_LIST_BANK_TERM

// PaymentList.BankTerm.OnChange
Procedure PaymentListBankTermOnChange(Parameters) Export
	Binding = BindPaymentListBankTerm(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.BankTerm.Set
Procedure SetPaymentListBankTerm(Parameters, Results) Export
	Binding = BindPaymentListBankTerm(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.BankTerm.Get
Function GetPaymentListBankTerm(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentListBankTerm(Parameters).DataPath , _Key);
EndFunction

// PaymentList.BankTerm.Bind
Function BindPaymentListBankTerm(Parameters)
	DataPath = "PaymentList.BankTerm";
	Binding = New Structure();
	
	Binding.Insert("BankPayment", 
		"StepPaymentListGetCommissionPercent");
	
	Binding.Insert("BankReceipt", 
		"StepPaymentListGetCommissionPercent");
		
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentListBankTerm");
EndFunction

#EndRegion

#Region PAYMENT_LIST_COMMISSION_IS_SEPARATE

// PaymentList.CommissionIsSeparate.Set
Procedure SetPaymentListCommissionIsSeparate(Parameters, Results) Export
	Binding = BindPaymentListCommissionIsSeparate(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.CommissionIsSeparate.Get
Function GetPaymentListCommissionIsSeparate(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentListCommissionIsSeparate(Parameters).DataPath , _Key);
EndFunction

// PaymentList.CommissionIsSeparate.Bind
Function BindPaymentListCommissionIsSeparate(Parameters)
	DataPath = "PaymentList.CommissionIsSeparate";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentListCommissionIsSeparate");
EndFunction

#EndRegion

#Region PAYMENT_LIST_COMMISSION

// PaymentList.Commission.OnChange
Procedure PaymentListCommissionOnChange(Parameters) Export
	Binding = BindPaymentListCommission(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.Commission.Set
Procedure SetPaymentListCommission(Parameters, Results) Export
	Binding = BindPaymentListCommission(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.Commission.Get
Function GetPaymentListCommission(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentListCommission(Parameters).DataPath, _Key);
EndFunction

// PaymentList.Commission.Bind
Function BindPaymentListCommission(Parameters)
	DataPath = "PaymentList.Commission";
	Binding = New Structure();

	Binding.Insert("BankPayment", 
		"StepChangeCommissionPercentByAmount");
	
	Binding.Insert("BankReceipt", 
		"StepChangeCommissionPercentByAmount");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentListCommission");
EndFunction

// PaymentList.Commission.CalculateCommission.Step
Procedure StepPaymentListCalculateCommission(Parameters, Chain) Export
	Chain.PaymentListCalculateCommission.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.PaymentListCalculateCommission.Setter = "SetPaymentListCommission";
	For Each Row In GetRows(Parameters, "PaymentList") Do
		Options     = ModelClientServer_V2.CalculatePaymentListCommissionOptions();
		Options.TotalAmount = GetPaymentListTotalAmount(Parameters, Row.Key);
		Options.CommissionPercent = GetPaymentListCommissionPercent(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepPaymentListCalculateCommission";
		Chain.PaymentListCalculateCommission.Options.Add(Options);
	EndDo;	
EndProcedure

#EndRegion

#Region PAYMENT_LIST_PERCENT

// PaymentList.CommissionPercent.OnChange
Procedure PaymentListCommissionPercentOnChange(Parameters) Export
	Binding = BindPaymentListCommissionPercent(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.CommissionPercent.Set
Procedure SetPaymentListCommissionPercent(Parameters, Results) Export
	Binding = BindPaymentListCommissionPercent(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.CommissionPercent.Get
Function GetPaymentListCommissionPercent(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentListCommissionPercent(Parameters).DataPath, _Key);
EndFunction

// PaymentList.CommissionPercent.Bind
Function BindPaymentListCommissionPercent(Parameters)
	DataPath = "PaymentList.CommissionPercent";
	Binding = New Structure();

	Binding.Insert("BankPayment", 
		"StepPaymentListCalculateCommission");
	
	Binding.Insert("BankReceipt", 
		"StepPaymentListCalculateCommission");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentListCommissionPercent");
EndFunction

// PaymentList.CommissionPercent.GetCommissionPercent.Step
Procedure StepPaymentListGetCommissionPercent(Parameters, Chain) Export
	Chain.GetCommissionPercent.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.GetCommissionPercent.Setter = "SetPaymentListCommissionPercent";
	For Each Row In GetRows(Parameters, "PaymentList") Do
		Options     = ModelClientServer_V2.GetCommissionPercentOptions();
		Options.PaymentType = GetPaymentListPaymentType(Parameters, Row.Key);
		Options.BankTerm = GetPaymentListBankTerm(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepPaymentListGetCommissionPercent";
		Chain.GetCommissionPercent.Options.Add(Options);
	EndDo;	
EndProcedure

// PaymentList.CommissionPercent.ChangePercentByAmount.Step
Procedure StepChangeCommissionPercentByAmount(Parameters, Chain) Export
	Chain.ChangeCommissionPercentByAmount.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeCommissionPercentByAmount.Setter = "SetPaymentListCommissionPercent";
	For Each Row In GetRows(Parameters, "PaymentList") Do
		Options     = ModelClientServer_V2.CalculateCommissionPercentByAmountOptions();
		Options.Commission = GetPaymentListCommission(Parameters, Row.Key);
		Options.TotalAmount = GetPaymentListTotalAmount(Parameters, Row.Key);
		Options.DisableNextSteps = True;
		Options.Key = Row.Key;
		Options.StepName = "StepChangeCommissionPercentByAmount";
		Chain.ChangeCommissionPercentByAmount.Options.Add(Options);
	EndDo;	
EndProcedure

#EndRegion

#Region PAYMENT_LIST_FINANCIAL_MOVEMENT_TYPE

// PaymentList.FinancialMovementType.Set
Procedure SetPaymentListFinancialMovementType(Parameters, Results) Export
	Binding = BindPaymentListFinancialMovementType(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PaymentList.FinancialMovementType.Get
Function GetPaymentListFinancialMovementType(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentListFinancialMovementType(Parameters).DataPath , _Key);
EndFunction

// PaymentList.FinancialMovementType.Bind
Function BindPaymentListFinancialMovementType(Parameters)
	DataPath = "PaymentList.FinancialMovementType";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentListFinancialMovementType");
EndFunction

#EndRegion

#Region PAYMENT_LIST_LOAD_DATA

// PaymentList.Load
Procedure PaymentListLoad(Parameters) Export
	Binding = BindPaymentListLoad(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PaymentList.Load.Set
#If Server Then
	
Procedure ServerTableLoaderPaymentList(Parameters, Results) Export
	Binding = BindPaymentListLoad(Parameters);
	LoaderTable(Binding.DataPath, Parameters, Results);
EndProcedure

#EndIf

// PaymentList.Load.Bind
Function BindPaymentListLoad(Parameters)
	DataPath = "PaymentList";
	Binding = New Structure();
	Return BindSteps("StepPaymentListLoadTable", DataPath, Binding, Parameters, "BindPaymentListLoad");
EndFunction

// PaymentList.LoadAtServer.Step
Procedure StepPaymentListLoadTable(Parameters, Chain) Export
	Chain.LoadTable.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.LoadTable.Setter = "ServerTableLoaderPaymentList";
	Options = ModelClientServer_V2.LoadTableOptions();
	Options.TableAddress = Parameters.LoadData.Address;
	Chain.LoadTable.Options.Add(Options);
EndProcedure

#EndRegion

#EndRegion

#Region CHEQUE_BONDS

#Region CHEQUE_BONDS_CHEQUE

// ChequeBonds.Cheque.OnChange
Procedure ChequeBondsChequeOnChange(Parameters) Export
	AddViewNotify("OnSetChequeBondsChequeNotify", Parameters);
	Binding = BindChequeBondsCheque(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ChequeBonds.Cheque.Set
Procedure SetChequeBondsCheque(Parameters, Results) Export
	Binding = BindChequeBondsCheque(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetChequeBondsChequeNotify");
EndProcedure

// ChequeBonds.Cheque.MultiSet
Procedure MultiSetChequeBondsCheque(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Status"    , BindChequeBondsStatus(Parameters));
	ResourceToBinding.Insert("NewStatus" , BindChequeBondsNewStatus(Parameters));
	ResourceToBinding.Insert("Currency"  , BindChequeBondsCurrency(Parameters));
	ResourceToBinding.Insert("Amount"    , BindChequeBondsAmount(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// ChequeBonds.Cheque.Get
Function GetChequeBondsCheque(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindChequeBondsCheque(Parameters).DataPath, _Key);
EndFunction

// ChequeBonds.Cheque.Bind
Function BindChequeBondsCheque(Parameters)
	DataPath = "ChequeBonds.Cheque";
	Binding = New Structure();
	Binding.Insert("ChequeBondTransaction", "StepChangeStatusByCheque");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindChequeBondsCheque");
EndFunction

// ChequeBonds.Cheque.StepChangeStatusByCheque.Step
Procedure StepChangeStatusByCheque(Parameters, Chain) Export
	Chain.ChangeStatusByCheque.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeStatusByCheque.Setter = "MultiSetChequeBondsCheque";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeStatusByChequeOptions();
		Options.Ref = Parameters.Object.Ref;
		Options.Cheque = GetChequeBondsCheque(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepChangeStatusByCheque";
		Chain.ChangeStatusByCheque.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region CHEQUE_BONDS_STATUS

// ChequeBonds.Status.Set
Procedure SetChequeBondsStatus(Parameters, Results) Export
	Binding = BindChequeBondsStatus(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ChequeBonds.Status.Bind
Function BindChequeBondsStatus(Parameters)
	DataPath = "ChequeBonds.Status";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindChequeBondsStatus");
EndFunction

#EndRegion

#Region CHEQUE_BONDS_NEW_STATUS

// ChequeBonds.NewStatus.OnChange
Procedure ChequeBondsNewStatusOnChange(Parameters) Export
	Binding = BindChequeBondsNewStatus(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ChequeBonds.NewStatus.Set
Procedure SetChequeBondsNewStatus(Parameters, Results) Export
	Binding = BindChequeBondsNewStatus(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ChequeBonds.NewStatus.Bind
Function BindChequeBondsNewStatus(Parameters)
	DataPath = "ChequeBonds.NewStatus";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindChequeBondsNewStatus");
EndFunction

#EndRegion

#Region CHEQUE_BONDS_CURRENCY

// ChequeBonds.Currency.Set
Procedure SetChequeBondsCurrency(Parameters, Results) Export
	Binding = BindChequeBondsCurrency(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ChequeBonds.Currency.Bind
Function BindChequeBondsCurrency(Parameters)
	DataPath = "ChequeBonds.Currency";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindChequeBondsCurrency");
EndFunction

#EndRegion

#Region CHEQUE_BONDS_AMOUNT

// ChequeBonds.Amount.Set
Procedure SetChequeBondsAmount(Parameters, Results) Export
	Binding = BindChequeBondsAmount(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ChequeBonds.Amount.Bind
Function BindChequeBondsAmount(Parameters)
	DataPath = "ChequeBonds.Amount";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindChequeBondsAmount");
EndFunction

#EndRegion

#Region CHEQUE_BONDS_PARTNER

// ChequeBonds.Partner.OnChange
Procedure ChequeBondsPartnerOnChange(Parameters) Export
	Binding = BindChequeBondsPartner(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ChequeBonds.Partner.Set
Procedure SetChequeBondsPartner(Parameters, Results) Export
	Binding = BindChequeBondsPartner(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ChequeBonds.Partner.Get
Function GetChequeBondsPartner(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindChequeBondsPartner(Parameters).DataPath, _Key);
EndFunction

// ChequeBonds.Partner.Bind
Function BindChequeBondsPartner(Parameters)
	DataPath = "ChequeBonds.Partner";
	Binding = New Structure();
	Binding.Insert("ChequeBondTransaction", 
		"StepChequeBondsChangeLegalNameByPartner,
		|StepChequeBondsChangeAgreementByPartner");
		
	Return BindSteps(Undefined, DataPath, Binding, Parameters, "BindChequeBondsPartner");
EndFunction

// ChequeBonds.Partner.ChangePartnerByLegalName.Step
Procedure StepChequeBondsChangePartnerByLegalName(Parameters, Chain) Export
	Chain.ChangePartnerByLegalName.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangePartnerByLegalName.Setter = "SetChequeBondsPartner";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeLegalNameByPartnerOptions();
		Options.Partner   = GetChequeBondsPartner(Parameters, Row.Key);
		Options.LegalName = GetChequeBondsLegalName(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepChequeBondsChangePartnerByLegalName";
		Chain.ChangePartnerByLegalName.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region CHEQUE_BONDS_AGREEMENT

// ChequeBonds.Agreement.OnChange
Procedure ChequeBondsAgreementOnChange(Parameters) Export
	Binding = BindChequeBondsAgreement(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ChequeBonds.Agreement.Set
Procedure SetChequeBondsAgreement(Parameters, Results) Export
	Binding = BindChequeBondsAgreement(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ChequeBonds.Agreement.Get
Function GetChequeBondsAgreement(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindChequeBondsAgreement(Parameters).DataPath , _Key);
EndFunction

// ChequeBonds.Agreement.Bind
Function BindChequeBondsAgreement(Parameters)
	DataPath = "ChequeBonds.Agreement";
	Binding = New Structure();
	Binding.Insert("ChequeBondTransaction",
		"StepChequeBondsChangeBasisDocumentByAgreement,
		|StepChequeBondsChangeOrderByAgreement,
		|StepChequeBondsChangeApArPostingDetailByAgreement");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindChequeBondsAgreement");
EndFunction

// ChequeBonds.Agreement.ChangeAgreementByPartner.Step
Procedure StepChequeBondsChangeAgreementByPartner(Parameters, Chain) Export
	Chain.ChangeAgreementByPartner.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeAgreementByPartner.Setter = "SetChequeBondsAgreement";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeAgreementByPartnerOptions();
		Options.Partner       = GetChequeBondsPartner(Parameters, Row.Key);
		Options.Agreement     = GetChequeBondsAgreement(Parameters, Row.Key);
		Options.CurrentDate   = GetDate(Parameters);
		Options.Key = Row.Key;
		Options.StepName = "ChequeBondsChangeAgreementByPartner";
		Chain.ChangeAgreementByPartner.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region CHEQUE_BONDS_LEGAL_NAME

// ChequeBonds.LegalName.OnChange
Procedure ChequeBondsLegalNameOnChange(Parameters) Export
	Binding = BindChequeBondsLegalName(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ChequeBonds.LegalName.Set
Procedure SetChequeBondsLegalName(Parameters, Results) Export
	Binding = BindChequeBondsLegalName(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ChequeBonds.LegalName.Get
Function GetChequeBondsLegalName(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindChequeBondsLegalName(Parameters).DataPath , _Key);
EndFunction

// ChequeBonds.LegalName.Bind
Function BindChequeBondsLegalName(Parameters)
	DataPath = "ChequeBonds.LegalName";
	
	Binding = New Structure();
	Binding.Insert("ChequeBondTransaction", "StepChequeBondsChangePartnerByLegalName");
	
	Return BindSteps(Undefined, DataPath, Binding, Parameters, "BindChequeBondsLegalName");
EndFunction

// ChequeBonds.LegalName.ChangeLegalNameByPartner.Step
Procedure StepChequeBondsChangeLegalNameByPartner(Parameters, Chain) Export
	Chain.ChangeLegalNameByPartner.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeLegalNameByPartner.Setter = "SetChequeBondsLegalName";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeLegalNameByPartnerOptions();
		Options.Partner   = GetChequeBondsPartner(Parameters, Row.Key);
		Options.LegalName = GetChequeBondsLegalName(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepChequeBondsChangeLegalNameByPartner";
		Chain.ChangeLegalNameByPartner.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region CHEQUE_BONDS_BASIS_DOCUMENT

// ChequeBonds.BasisDocument.OnChange
Procedure ChequeBondsBasisDocumentOnChange(Parameters) Export
	Binding = BindChequeBondsBasisDocument(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ChequeBonds.BasisDocument.Set
Procedure SetChequeBondsBasisDocument(Parameters, Results) Export
	Binding = BindChequeBondsBasisDocument(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ChequeBonds.BasisDocument.Get
Function GetChequeBondsBasisDocument(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindChequeBondsBasisDocument(Parameters).DataPath , _Key);
EndFunction

// ChequeBonds.BasisDocument.Bind
Function BindChequeBondsBasisDocument(Parameters)
	DataPath = "ChequeBonds.BasisDocument";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindChequeBondsBasisDocument");
EndFunction

// ChequeBonds.BasisDocument.ChangeBasisDocumentByAgreement.Step
Procedure StepChequeBondsChangeBasisDocumentByAgreement(Parameters, Chain) Export
	Chain.ChangeBasisDocumentByAgreement.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeBasisDocumentByAgreement.Setter = "SetChequeBondsBasisDocument";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeBasisDocumentByAgreementOptions();
		Options.Agreement            = GetChequeBondsAgreement(Parameters, Row.Key);
		Options.CurrentBasisDocument = GetChequeBondsBasisDocument(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepChequeBondsChangeBasisDocumentByAgreement";
		Chain.ChangeBasisDocumentByAgreement.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region CHEQUE_BONDS_ORDER

// ChequeBonds.Order.OnChange
Procedure ChequeBondsOrderOnChange(Parameters) Export
	Binding = BindChequeBondsOrder(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ChequeBonds.Order.Set
Procedure SetChequeBondsOrder(Parameters, Results) Export
	Binding = BindChequeBondsOrder(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ChequeBonds.Order.Get
Function GetChequeBondsOrder(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindChequeBondsOrder(Parameters).DataPath , _Key);
EndFunction

// ChequeBonds.Order.Bind
Function BindChequeBondsOrder(Parameters)
	DataPath = "ChequeBonds.Order";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindChequeBondsOrder");
EndFunction

// ChequeBonds.Order.ChangeOrderByAgreement.Step
Procedure StepChequeBondsChangeOrderByAgreement(Parameters, Chain) Export
	Chain.ChangeOrderByAgreement.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeOrderByAgreement.Setter = "SetChequeBondsOrder";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeOrderByAgreementOptions();
		Options.Agreement    = GetChequeBondsAgreement(Parameters, Row.Key);
		Options.CurrentOrder = GetChequeBondsOrder(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepChequeBondsChangeOrderByAgreement";
		Chain.ChangeOrderByAgreement.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region CHEQUE_BONDS_AP_AR_POSTING_DETAILS

// ChequeBonds.ApArPostingDetail.Set
Procedure SetChequeBondsApArPostingDetail(Parameters, Results) Export
	Binding = BindChequeBondsApArPostingDetail(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ChequeBonds.ApArPostingDetail.Bind
Function BindChequeBondsApArPostingDetail(Parameters)
	DataPath = "ChequeBonds.ApArPostingDetail";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindChequeBondsApArPostingDetail");
EndFunction

// ChequeBonds.ApArPOstingDetail.ChangeApArPostingDetailByAgreement.Step
Procedure StepChequeBondsChangeApArPostingDetailByAgreement(Parameters, Chain) Export
	Chain.ChangeApArPostingDetailByAgreement.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeApArPostingDetailByAgreement.Setter = "SetChequeBondsApArPostingDetail";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeApArPostingDetailByAgreementOptions();
		Options.Agreement = GetChequeBondsAgreement(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepChequeBondsChangeApArPostingDetailByAgreement";
		Chain.ChangeApArPostingDetailByAgreement.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#EndRegion

#Region PRODUCTIONS

#Region PRODUCTIONS_ITEM

// Productions.Item.OnChange
Procedure ProductionsItemOnChange(Parameters) Export
	Binding = BindProductionsItem(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Productions.Item.Set
Procedure SetProductionsItem(Parameters, Results) Export
	Binding = BindProductionsItem(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Productions.Item.Get
Function GetProductionsItem(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindProductionsItem(Parameters).DataPath, _Key);
EndFunction

// Productions.Item.Bind
Function BindProductionsItem(Parameters)
	DataPath = "Productions.Item";
	Binding = New Structure();
	Binding.Insert("ProductionPlanning"           , "StepProductionsChangeItemKeyByItem");
	Binding.Insert("ProductionPlanningCorrection" , "StepProductionsChangeItemKeyByItem");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindProductionsItem");
EndFunction

#EndRegion

#Region PRODUCTIONS_ITEMKEY

// Productions.ItemKey.OnChange
Procedure ProductionsItemKeyOnChange(Parameters) Export
	Binding = BindProductionsItemKey(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Productions.ItemKey.Set
Procedure SetProductionsItemKey(Parameters, Results) Export
	Binding = BindProductionsItemKey(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Productions.ItemKey.Get
Function GetProductionsItemKey(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindProductionsItemKey(Parameters).DataPath, _Key);
EndFunction

// Productions.ItemKey.Bind
Function BindProductionsItemKey(Parameters)
	DataPath = "Productions.ItemKey";
	Binding = New Structure();
	
	Binding.Insert("ProductionPlanning", 
		"StepProductionsChangeUnitByItemKey,
		|StepProductionsChangeBillOfMaterialsByItemKey");
		
	Binding.Insert("ProductionPlanningCorrection",
		"StepProductionsChangeUnitByItemKey,
		|StepProductionsChangeBillOfMaterialsByItemKey,
		|StepChangeCurrentQuantityInProductions");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindProductionsItemKey");
EndFunction

// Productions.ItemKey.ChangeItemKeyByItem.Step
Procedure StepProductionsChangeItemKeyByItem(Parameters, Chain) Export
	Chain.ChangeItemKeyByItem.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeItemKeyByItem.Setter = "SetProductionsItemKey";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeItemKeyByItemOptions();
		Options.Item    = GetProductionsItem(Parameters, Row.Key);
		Options.ItemKey = GetProductionsItemKey(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepProductionsChangeItemKeyByItem";
		Chain.ChangeItemKeyByItem.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region PRODUCTIONS_UNIT

// Productions.Unit.OnChange
Procedure ProductionsUnitOnChange(Parameters) Export
	Binding = BindProductionsUnit(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Productions.Unit.Set
Procedure SetProductionsUnit(Parameters, Results) Export
	Binding = BindProductionsUnit(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Productions.Unit.Get
Function GetProductionsUnit(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindProductionsUnit(Parameters).DataPath, _Key);
EndFunction

// Productions.Unit.Bind
Function BindProductionsUnit(Parameters)
	DataPath = "Productions.Unit";
	Binding = New Structure();
	
	Binding.Insert("ProductionPlanning",
		"StepBillOfMaterialsListCalculations");
	
	Binding.Insert("ProductionPlanningCorrection",
		"StepBillOfMaterialsListCalculationsCorrection");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindProductionsUnit");
EndFunction

// Productions.Unit.ChangeUnitByItemKey.Step
Procedure StepProductionsChangeUnitByItemKey(Parameters, Chain) Export
	Chain.ChangeUnitByItemKey.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeUnitByItemKey.Setter = "SetProductionsUnit";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeUnitByItemKeyOptions();
		Options.ItemKey = GetProductionsItemKey(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepProductionsChangeUnitByItemKey";
		Chain.ChangeUnitByItemKey.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region PRODUCTIONS_QUANTITY

// Productions.Quantity.OnChange
Procedure ProductionsQuantityOnChange(Parameters) Export
	Binding = BindProductionsQuantity(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Productions.Quantity.Set
Procedure SetProductionsQuantity(Parameters, Results) Export
	Binding = BindProductionsQuantity(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Productions.Quantity.Get
Function GetProductionsQuantity(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindProductionsQuantity(Parameters).DataPath, _Key);
EndFunction

// Productions.Quantity.Default.Bind
Function BindDefaultProductionsQuantity(Parameters)
	DataPath = "Productions.Quantity";
	Binding = New Structure();
	Binding.Insert("ProductionPlanning"           , "StepProductionsDefaultQuantityInList");
	Binding.Insert("ProductionPlanningCorrection" , "StepProductionsDefaultQuantityInList");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindDefaultProductionsQuantity");
EndFunction

// Productions.Quantity.Bind
Function BindProductionsQuantity(Parameters)
	DataPath = "Productions.Quantity";
	Binding = New Structure();
	
	Binding.Insert("ProductionPlanning",
		"StepBillOfMaterialsListCalculations");
	
	Binding.Insert("ProductionPlanningCorrection",
		"StepChangeCurrentQuantityInProductions,
		|StepBillOfMaterialsListCalculationsCorrection");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindProductionsQuantity");
EndFunction

// Productions.Quantity.DefaultQuantityInList.Step
Procedure StepProductionsDefaultQuantityInList(Parameters, Chain) Export
	Chain.DefaultQuantityInList.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.DefaultQuantityInList.Setter = "SetProductionsQuantity";
	Options = ModelClientServer_V2.DefaultQuantityInListOptions();
	NewRow = Parameters.RowFilledByUserSettings;
	Options.CurrentQuantity = GetProductionsQuantity(Parameters, NewRow.Key);
	Options.Key = NewRow.Key;
	Chain.DefaultQuantityInList.Options.Add(Options);
EndProcedure

#EndRegion

#Region PRODUCTIONS_BILL_OF_MATERIALS

// Productions.BillOfMaterials.OnChange
Procedure ProductionsBillOfMaterialsOnChange(Parameters) Export
	Binding = BindProductionsBillOfMaterials(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Productions.BillOfMaterials.Set
Procedure SetProductionsBillOfMaterials(Parameters, Results) Export
	Binding = BindProductionsBillOfMaterials(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Productions.BillOfMaterials.Get
Function GetProductionsBillOfMaterials(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindProductionsBillOfMaterials(Parameters).DataPath, _Key);
EndFunction

// Productions.BillOfMaterials.Bind
Function BindProductionsBillOfMaterials(Parameters)
	DataPath = "Productions.BillOfMaterials";
	Binding = New Structure();
	
	Binding.Insert("ProductionPlanning",
		"StepBillOfMaterialsListCalculations");
	
	Binding.Insert("ProductionPlanningCorrection",
		"StepChangeCurrentQuantityInProductions,
		|StepBillOfMaterialsListCalculationsCorrection");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindProductionsBillOfMaterials");
EndFunction

// Productions.BillOfMaterials.ChangeBillOfMaterialsByItemKey.Step
Procedure StepProductionsChangeBillOfMaterialsByItemKey(Parameters, Chain) Export
	Chain.ChangeBillOfMaterialsByItemKey.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeBillOfMaterialsByItemKey.Setter = "SetProductionsBillOfMaterials";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeBillOfMaterialsByItemKeyOptions();
		Options.ItemKey = GetProductionsItemKey(Parameters, Row.Key);
		Options.CurrentBillOfMaterials = GetProductionsBillOfMaterials(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepProductionsChangeBillOfMaterialsByItemKey";
		Chain.ChangeBillOfMaterialsByItemKey.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region PRODUCTIONS_CURRENT_QUANTITY

// Productions.CurrentQuantity.MultiSet
Procedure MultiSetProductionsCurrentQuantity(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Unit"            , BindProductionsUnit(Parameters));
	ResourceToBinding.Insert("CurrentQuantity" , BindProductionsCurrentQuantity(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding, "OnSetProductionsCurrentQuantityNotify");
EndProcedure

// Productions.CurrentQuantity.Get
Function GetProductionsCurrentQuantity(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindProductionsCurrentQuantity(Parameters).DataPath, _Key);
EndFunction

// Productions.CurrentQuantity.Bind
Function BindProductionsCurrentQuantity(Parameters)
	DataPath = "Productions.CurrentQuantity";
	Binding = New Structure();
	
	Binding.Insert("ProductionPlanningCorrection",
		"StepBillOfMaterialsListCalculationsCorrection");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindProductionsCurrentQuantity");
EndFunction

// Productions.CurrentQuantity.ChangeCurrentQuantityInProductions.Step
Procedure StepChangeCurrentQuantityInProductions(Parameters, Chain) Export
	Chain.ChangeCurrentQuantityInProductions.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeCurrentQuantityInProductions.Setter = "MultiSetProductionsCurrentQuantity";
	Chain.ChangeCurrentQuantityInProductions.IsLazyStep = True;
	Chain.ChangeCurrentQuantityInProductions.LazyStepName = "StepChangeCurrentQuantityInProductions";
	
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeCurrentQuantityInProductionsOptions();
		Options.Company             = GetCompany(Parameters);
		Options.ProductionPlanning  = GetProductionPlanning(Parameters);
		Options.PlanningPeriod      = GetPlanningPeriod(Parameters);
		Options.BillOfMaterials     = GetProductionsBillOfMaterials(Parameters, Row.Key);
		Options.ItemKey             = GetProductionsItemKey(Parameters, Row.Key);
		Options.Unit                = GetProductionsUnit(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepChangeCurrentQuantityInProductions";
		Chain.ChangeCurrentQuantityInProductions.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#EndRegion

#Region BILL_OF_MATERIALS_LIST

// BillOfMaterialsList.Set
Procedure SetBillOfMaterialsList(Parameters, Results) Export
	TableName = "BillOfMaterialsList";
	If Not Parameters.Cache.Property(TableName) Then
		AddTableToCacheRemovable(Parameters, TableName);
	EndIf;
	
	UpdateTableCacheRemovable(Parameters, TableName, Results);	
EndProcedure

// Step.BillOfMaterialsList.Calculations
Procedure StepBillOfMaterialsListCalculations(Parameters, Chain) Export
	Chain.BillOfMaterialsListCalculations.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.BillOfMaterialsListCalculations.Setter = "SetBillOfMaterialsList";
	Chain.BillOfMaterialsListCalculations.IsLazyStep = True;
	Chain.BillOfMaterialsListCalculations.LazyStepName = "StepBillOfMaterialsListCalculations";
	
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.BillOfMaterialsListCalculationsOptions();
		
		Options.Company          = GetCompany(Parameters); 
		Options.BillOfMaterials  = GetProductionsBillOfMaterials(Parameters, Row.Key);
		Options.PlanningPeriod   = GetPlanningPeriod(Parameters);
		Options.ItemKey          = GetProductionsItemKey(Parameters, Row.Key);
		Options.Unit             = GetProductionsUnit(Parameters, Row.Key);
		Options.Quantity         = GetProductionsQuantity(Parameters, Row.Key);
		
		Options.BillOfMaterialsList = Row.BillOfMaterialsList;
		Options.BillOfMaterialsListColumns = Parameters.ObjectMetadataInfo.Tables.BillOfMaterialsList.Columns;
		Options.Key = Row.Key;
		Options.StepName = "StepBillOfMaterialsListCalculations";
		Chain.BillOfMaterialsListCalculations.Options.Add(Options);
	EndDo;
EndProcedure

// Step.BillOfMaterialsList.CalculationsCorrection
Procedure StepBillOfMaterialsListCalculationsCorrection(Parameters, Chain) Export
	Chain.BillOfMaterialsListCalculationsCorrection.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.BillOfMaterialsListCalculationsCorrection.Setter = "SetBillOfMaterialsList";
	Chain.BillOfMaterialsListCalculationsCorrection.IsLazyStep = True;
	Chain.BillOfMaterialsListCalculationsCorrection.LazyStepName = "StepBillOfMaterialsListCalculationsCorrection";
	
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.BillOfMaterialsListCalculationsCorrectionOptions();
		
		Options.Company          = GetCompany(Parameters); 
		Options.BillOfMaterials  = GetProductionsBillOfMaterials(Parameters, Row.Key);
		Options.PlanningPeriod   = GetPlanningPeriod(Parameters);
		Options.ItemKey          = GetProductionsItemKey(Parameters, Row.Key);
		Options.Unit             = GetProductionsUnit(Parameters, Row.Key);
		Options.Quantity         = GetProductionsQuantity(Parameters, Row.Key);
		Options.CurrentQuantity  = GetProductionsCurrentQuantity(Parameters, Row.Key);
		
		Options.BillOfMaterialsList = Row.BillOfMaterialsList;
		Options.BillOfMaterialsListColumns = Parameters.ObjectMetadataInfo.Tables.BillOfMaterialsList.Columns;		
		Options.Key = Row.Key;
		Options.StepName = "StepBillOfMaterialsListCalculationsCorrection";
		Chain.BillOfMaterialsListCalculationsCorrection.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region MATERIALS

#Region MATERIALS_BILL_OF_MATERIALS

// Materials.BillOfMaterials.Set
Procedure SetMaterialsBillOfMaterials(Parameters, Results) Export
	Binding = BindMaterialsBillOfMaterials(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Materials.BillOfMaterials.Get
Function GetMaterialsBillOfMaterials(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindMaterialsBillOfMaterials(Parameters).DataPath, _Key);
EndFunction

// Materials.BillOfMaterials.Bind
Function BindMaterialsBillOfMaterials(Parameters)
	DataPath = "Materials.BillOfMaterials";
	Binding = New Structure();
	Binding.Insert("WorkSheet", "StepMaterialsChangeUniqueIDByItemKeyBOMAndBillOfMaterials,
								|StepMaterialsChangeProfitLossCenterByBillOfMaterials,
								|StepMaterialsChangeExpenseTypeByBillOfMaterials");
								
	Binding.Insert("WorkOrder", "StepMaterialsChangeUniqueIDByItemKeyAndBillOfMaterials");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindMaterialsBillOfMaterials");
EndFunction

#EndRegion

#Region MATERIALS_ITEM

// Materials.Item.OnChange
Procedure MaterialsItemOnChange(Parameters) Export
	Binding = BindMaterialsItem(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Materials.Item.Set
Procedure SetMaterialsItem(Parameters, Results) Export
	Binding = BindMaterialsItem(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Materials.Item.Get
Function GetMaterialsItem(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindMaterialsItem(Parameters).DataPath, _Key);
EndFunction

// Materials.Item.Bind
Function BindMaterialsItem(Parameters)
	DataPath = "Materials.Item";
	Binding = New Structure();
	
	Binding.Insert("WorkOrder",
		"StepMaterialsChangeItemKeyByItem");
	
	Binding.Insert("WorkSheet",
		"StepMaterialsChangeItemKeyByItem");
		
	Binding.Insert("Production",
		"StepMaterialsChangeItemKeyByItem");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindMaterialsItem");
EndFunction

#EndRegion

#Region MATERIALS_ITEMKEY

// Materials.ItemKey.OnChange
Procedure MaterialsItemKeyOnChange(Parameters) Export
	Binding = BindMaterialsItemKey(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Materials.ItemKey.Set
Procedure SetMaterialsItemKey(Parameters, Results) Export
	Binding = BindMaterialsItemKey(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Materials.ItemKey.Get
Function GetMaterialsItemKey(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindMaterialsItemKey(Parameters).DataPath, _Key);
EndFunction

// Materials.ItemKey.Bind
Function BindMaterialsItemKey(Parameters)
	DataPath = "Materials.ItemKey";
	Binding = New Structure();
	Binding.Insert("WorkOrder",
		"StepMaterialsChangeUnitByItemKey");
	
	Binding.Insert("WorkSheet", 
		"StepMaterialsChangeUnitByItemKey,
		|StepMaterialsChangeIsManualChangedByItemKey");
	
	Binding.Insert("Production", 
		"StepMaterialsChangeUnitByItemKey");
		
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindMaterialsItemKey");
EndFunction

// Materials.ItemKey.ChangeItemKeyByItem.Step
Procedure StepMaterialsChangeItemKeyByItem(Parameters, Chain) Export
	Chain.ChangeItemKeyByItem.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeItemKeyByItem.Setter = "SetMaterialsItemKey";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeItemKeyByItemOptions();
		Options.Item    = GetMaterialsItem(Parameters, Row.Key);
		Options.ItemKey = GetMaterialsItemKey(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepMaterialsChangeItemKeyByItem";
		Chain.ChangeItemKeyByItem.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region MATERIALS_ITEMKEY_BOM

// Materials.ItemKeyBOM.Set
Procedure SetMaterialsItemKeyBOM(Parameters, Results) Export
	Binding = BindMaterialsItemKeyBOM(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Materials.ItemKeyBOM.Get
Function GetMaterialsItemKeyBOM(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindMaterialsItemKeyBOM(Parameters).DataPath, _Key);
EndFunction

// Materials.ItemKeyBOM.Bind
Function BindMaterialsItemKeyBOM(Parameters)
	DataPath = "Materials.ItemKeyBOM";
	Binding = New Structure();
	
	Binding.Insert("WorkOrder",
		"StepMaterialsChangeUniqueIDByItemKeyAndBillOfMaterials");
	
	Binding.Insert("WorkSheet", 
		"StepMaterialsChangeUniqueIDByItemKeyBOMAndBillOfMaterials,
		|StepMaterialsChangeExpenseTypeByBillOfMaterials");
		
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindMaterialsItemKeyBOM");
EndFunction

#EndRegion

#Region MATERIALS_UNIT

// Materials.Unit.OnChange
Procedure MaterialsUnitOnChange(Parameters) Export
	Binding = BindMaterialsUnit(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Materials.Unit.Set
Procedure SetMaterialsUnit(Parameters, Results) Export
	Binding = BindMaterialsUnit(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Materials.Unit.Get
Function GetMaterialsUnit(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindMaterialsUnit(Parameters).DataPath, _Key);
EndFunction

// Materials.Unit.Bind
Function BindMaterialsUnit(Parameters)
	DataPath = "Materials.Unit";
	Binding = New Structure();
	
	Binding.Insert("WorkOrder", 
		"StepMaterialsCalculateQuantityInBaseUnit");
		
	Binding.Insert("WorkSheet",
		"StepMaterialsCalculateQuantityInBaseUnit");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindMaterialsUnit");
EndFunction

// Materials.Unit.ChangeUnitByItemKey.Step
Procedure StepMaterialsChangeUnitByItemKey(Parameters, Chain) Export
	Chain.ChangeUnitByItemKey.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeUnitByItemKey.Setter = "SetMaterialsUnit";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeUnitByItemKeyOptions();
		Options.ItemKey = GetMaterialsItemKey(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepMaterialsChangeUnitByItemKey";
		Chain.ChangeUnitByItemKey.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region MATERIALS_UNIT_BOM

// Materials.UnitBOM.Get
Function GetMaterialsUnitBOM(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindMaterialsUnitBOM(Parameters).DataPath, _Key);
EndFunction

// Materials.UnitBOM.Bind
Function BindMaterialsUnitBOM(Parameters)
	DataPath = "Materials.UnitBOM";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindMaterialsUnitBOM");
EndFunction

#EndRegion

#Region MATERIALS_QUANTITY

// Materials.Quantity.OnChange
Procedure MaterialsQuantityOnChange(Parameters) Export
	Binding = BindMaterialsQuantity(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Materials.Quantity.Set
Procedure SetMaterialsQuantity(Parameters, Results) Export
	Binding = BindMaterialsQuantity(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Materials.Quantity.Get
Function GetMaterialsQuantity(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindMaterialsQuantity(Parameters).DataPath, _Key);
EndFunction

// Materials.Quantity.Default.Bind
Function BindDefaultMaterialsQuantity(Parameters)
	DataPath = "Materials.Quantity";
	Binding = New Structure();
	
	Binding.Insert("WorkOrder", 
		"StepMaterialsDefaultQuantityInList");
	
	Binding.Insert("WorkSheet", 
		"StepMaterialsDefaultQuantityInList");
	
	Binding.Insert("Production", 
		"StepMaterialsDefaultQuantityInList");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindDefaultMaterialsQuantity");
EndFunction

// Materials.Quantity.Bind
Function BindMaterialsQuantity(Parameters)
	DataPath = "Materials.Quantity";
	Binding = New Structure();
	
	Binding.Insert("WorkOrder",
		"StepMaterialsCalculateQuantityInBaseUnit");
	
	Binding.Insert("WorkSheet",
		"StepMaterialsCalculateQuantityInBaseUnit");
		
	Binding.Insert("Production",
		"StepMaterialsChangeIsManualChangedByQuantity");
			
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindMaterialsQuantity");
EndFunction

// Materials.Quantity.DefaultQuantityInList.Step
Procedure StepMaterialsDefaultQuantityInList(Parameters, Chain) Export
	Chain.DefaultQuantityInList.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.DefaultQuantityInList.Setter = "SetMaterialsQuantity";
	Options = ModelClientServer_V2.DefaultQuantityInListOptions();
	NewRow = Parameters.RowFilledByUserSettings;
	Options.CurrentQuantity = GetMaterialsQuantity(Parameters, NewRow.Key);
	Options.Key = NewRow.Key;
	Chain.DefaultQuantityInList.Options.Add(Options);
EndProcedure

#EndRegion

#Region MATERIALS_QUANTITY_BOM

// Materials.QuantityBOM.Set
Procedure SetMaterialsQuantityBOM(Parameters, Results) Export
	Binding = BindMaterialsQuantityBOM(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Materials.QuantityBOM.Get
Function GetMaterialsQuantityBOM(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindMaterialsQuantityBOM(Parameters).DataPath, _Key);
EndFunction

// Materials.QuantityBOM.Bind
Function BindMaterialsQuantityBOM(Parameters)
	DataPath = "Materials.QuantityBOM";
	Binding = New Structure();
	Binding.Insert("WorkSheet", "StepMaterialsCalculateQuantityInBaseUnitBOM");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindMaterialsQuantityBOM");
EndFunction

#EndRegion

#Region MATERIALS_QUANTITY_IN_BASE_UNIT

// Materials.QuantityInBaseUnit.Set
Procedure SetMaterialsQuantityInBaseUnit(Parameters, Results) Export
	Binding = BindMaterialsQuantityInBaseUnit(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath , Parameters, Results, , "QuantityInBaseUnit");
EndProcedure

Function GetMaterialsQuantityInBaseUnit(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindMaterialsQuantityInBaseUnit(Parameters).DataPath , _Key);
EndFunction

// Materials.QuantityInBaseUnit.Bind
Function BindMaterialsQuantityInBaseUnit(Parameters)
	DataPath = "Materials.QuantityInBaseUnit";
	Binding = New Structure();
	Binding.Insert("WorkSheet", "StepMaterialsChangeIsManualChangedByItemKey");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindMaterialsQuantityInBaseUnit");
EndFunction

// Materials.QuantityInBaseUnit.CalculateQuantityInBaseUnit.Step
Procedure StepMaterialsCalculateQuantityInBaseUnit(Parameters, Chain) Export
	Chain.Calculations.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.Calculations.Setter = "SetMaterialsQuantityInBaseUnit";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options     = ModelClientServer_V2.CalculationsOptions();
		Options.Ref = Parameters.Object.Ref;
		Options.CalculateQuantityInBaseUnit.Enable   = True;
		Options.QuantityOptions.ItemKey = GetMaterialsItemKey(Parameters, Row.Key);
		Options.QuantityOptions.Unit    = GetMaterialsUnit(Parameters, Row.Key);
		Options.QuantityOptions.Quantity           = GetMaterialsQuantity(Parameters, Row.Key);
		Options.QuantityOptions.QuantityInBaseUnit = GetMaterialsQuantityInBaseUnit(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepMaterialsCalculateQuantityInBaseUnitBOM";
		Chain.Calculations.Options.Add(Options);
	EndDo;	
EndProcedure

#EndRegion

#Region MATERIALS_QUANTITY_IN_BASE_UNIT_BOM

// Materials.QuantityInBaseUnitBOM.Set
Procedure SetMaterialsQuantityInBaseUnitBOM(Parameters, Results) Export
	Binding = BindMaterialsQuantityInBaseUnitBOM(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath , Parameters, Results, , "QuantityInBaseUnit");
EndProcedure

Function GetMaterialsQuantityInBaseUnitBOM(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindMaterialsQuantityInBaseUnitBOM(Parameters).DataPath , _Key);
EndFunction

// Materials.QuantityInBaseUnitBOM.Bind
Function BindMaterialsQuantityInBaseUnitBOM(Parameters)
	DataPath = "Materials.QuantityInBaseUnitBOM";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindMaterialsQuantityInBaseUnitBOM");
EndFunction

// Materials.QuantityInBaseUnit.CalculateQuantityInBaseUnitBOM.Step
Procedure StepMaterialsCalculateQuantityInBaseUnitBOM(Parameters, Chain) Export
	Chain.Calculations.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.Calculations.Setter = "SetMaterialsQuantityInBaseUnitBOM";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options     = ModelClientServer_V2.CalculationsOptions();
		Options.Ref = Parameters.Object.Ref;
		Options.CalculateQuantityInBaseUnit.Enable   = True;
		Options.QuantityOptions.ItemKey = GetMaterialsItemKeyBOM(Parameters, Row.Key);
		Options.QuantityOptions.Unit    = GetMaterialsUnitBOM(Parameters, Row.Key);
		Options.QuantityOptions.Quantity           = GetMaterialsQuantityBOM(Parameters, Row.Key);
		Options.QuantityOptions.QuantityInBaseUnit = GetMaterialsQuantityInBaseUnitBOM(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepMaterialsCalculateQuantityInBaseUnitBOM";
		Chain.Calculations.Options.Add(Options);
	EndDo;	
EndProcedure

#EndRegion

#Region MATERIALS_IS_MANUAL_CHANGED

// Materials.IsManualChanged.Set
Procedure SetMaterialsIsManualChanged(Parameters, Results) Export
	Binding = BindMaterialsIsManualChanged(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Materials.IsManualChanged.Bind
Function BindMaterialsIsManualChanged(Parameters)
	DataPath = "Materials.IsManualChanged";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindMaterialsIsManualChanged");
EndFunction

// Materials.IsManualChanged.ChangeIsManualChangedByItemKey.Step
Procedure StepMaterialsChangeIsManualChangedByItemKey(Parameters, Chain) Export
	Chain.ChangeIsManualChangedByItemKey.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeIsManualChangedByItemKey.Setter = "SetMaterialsIsManualChanged";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options     = ModelClientServer_V2.ChangeIsManualChangedByItemKeyOptions();		
		Options.ItemKeyBOM = GetMaterialsItemKeyBOM(Parameters, Row.Key);
		Options.ItemKey    = GetMaterialsItemKey(Parameters, Row.Key);
		Options.QuantityInBaseUnitBOM = GetMaterialsQuantityInBaseUnitBOM(Parameters, Row.Key);
		Options.QuantityInBaseUnit    = GetMaterialsQuantityInBaseUnit(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepMaterialsChangeIsManualChangedByItemKey";
		Chain.ChangeIsManualChangedByItemKey.Options.Add(Options);
	EndDo;	
EndProcedure

// Materials.IsManualChanged.ChangeIsManualChangedByQuantity.Step
Procedure StepMaterialsChangeIsManualChangedByQuantity(Parameters, Chain) Export
	Chain.ChangeIsManualChangedByQuantity.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeIsManualChangedByQuantity.Setter = "SetMaterialsIsManualChanged";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options     = ModelClientServer_V2.ChangeIsManualChangedByQuantityOptions();		
		Options.Quantity   = GetMaterialsQuantity(Parameters, Row.Key);
		Options.QuantityBOM = GetMaterialsQuantityBOM(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepMaterialsChangeIsManualChangedByQuantity";
		Chain.ChangeIsManualChangedByQuantity.Options.Add(Options);
	EndDo;	
EndProcedure

#EndRegion

#Region MATERIALS_UNIQUE_ID

// Materials.UniqueID.Set
Procedure SetMaterialsUniqueID(Parameters, Results) Export
	Binding = BindMaterialsUniqueID(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Materials.UniqueID.Bind
Function BindMaterialsUniqueID(Parameters)
	DataPath = "Materials.UniqueID";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindMaterialsUniqueID");
EndFunction

// Materials.UniqueID.ChangeUniqueIDByItemKeyBOMAndBillOfMaterials.Step
Procedure StepMaterialsChangeUniqueIDByItemKeyBOMAndBillOfMaterials(Parameters, Chain) Export
	Chain.ChangeUniqueIDByItemKeyBOMAndBillOfMaterials.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeUniqueIDByItemKeyBOMAndBillOfMaterials.Setter = "SetMaterialsUniqueID";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeUniqueIDByItemKeyBOMAndBillOfMaterialsOptions();		
		Options.ItemKeyBOM      = GetMaterialsItemKeyBOM(Parameters, Row.Key);
		Options.BillOfMaterials = GetMaterialsBillOfMaterials(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepMaterialsChangeUniqueIDByItemKeyBOMAndBillOfMaterials";
		Chain.ChangeUniqueIDByItemKeyBOMAndBillOfMaterials.Options.Add(Options);
	EndDo;	
EndProcedure

// Materials.UniqueID.ChangeUniqueIDByItemKeyAndBillOfMaterials.Step
Procedure StepMaterialsChangeUniqueIDByItemKeyAndBillOfMaterials(Parameters, Chain) Export
	Chain.ChangeUniqueIDByItemKeyBOMAndBillOfMaterials.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeUniqueIDByItemKeyBOMAndBillOfMaterials.Setter = "SetMaterialsUniqueID";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeUniqueIDByItemKeyBOMAndBillOfMaterialsOptions();		
		Options.ItemKeyBOM      = GetMaterialsItemKey(Parameters, Row.Key);
		Options.BillOfMaterials = GetMaterialsBillOfMaterials(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepMaterialsChangeUniqueIDByItemKeyAndBillOfMaterials";
		Chain.ChangeUniqueIDByItemKeyBOMAndBillOfMaterials.Options.Add(Options);
	EndDo;	
EndProcedure

#EndRegion

#Region MATERIALS_COST_WRITE_OFF

// Materials.CostWriteOff.OnChange
Procedure MaterialsCostWriteOffOnChange(Parameters) Export
	Binding = BindMaterialsCostWriteOff(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Materials.CostWriteOff.Set
Procedure SetMaterialsCostWriteOff(Parameters, Results) Export
	Binding = BindMaterialsCostWriteOff(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Materials.CostWriteOff.Get
Function GetMaterialsCostWriteOff(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindMaterialsCostWriteOff(Parameters).DataPath, _Key);
EndFunction

// Materials.CostWriteOff.Bind
Function BindMaterialsCostWriteOff(Parameters)
	DataPath = "Materials.CostWriteOff";
	Binding = New Structure();
	Binding.Insert("WorkSheet", "StepMaterialsChangeStoreByCostWriteOff");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindMaterialsCostWriteOff");
EndFunction

#EndRegion

#Region MATERIALS_STORE

// Materials.Store.Set
Procedure SetMaterialsStore(Parameters, Results) Export
	Binding = BindMaterialsStore(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Materials.Store.Get
Function GetMaterialsStore(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindMaterialsStore(Parameters).DataPath, _Key);
EndFunction

// Materials.Store.Bind
Function BindMaterialsStore(Parameters)
	DataPath = "Materials.Store";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindMaterialsStore");
EndFunction

// Materials.Store.ChangeStoreByCostWriteOff.Step
Procedure StepMaterialsChangeStoreByCostWriteOff(Parameters, Chain) Export
	Chain.ChangeStoreByCostWriteOff.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeStoreByCostWriteOff.Setter = "SetMaterialsStore";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeStoreByCostWriteOffOptions();
		Options.CostWriteOff    = GetMaterialsCostWriteOff(Parameters, Row.Key);
		Options.BillOfMaterials = GetMaterialsBillOfMaterials(Parameters, Row.Key);
		Options.CurrentStore    = GetMaterialsStore(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepMaterialsChangeStoreByCostWriteOff";
		Chain.ChangeStoreByCostWriteOff.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region MATERIALS_PROFIT_LOSS_CENTER

// Materials.ProfitLossCenter.Set
Procedure SetMaterialsProfitLossCenter(Parameters, Results) Export
	Binding = BindMaterialsProfitLossCenter(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Materials.ProfitLossCenter.Get
Function GetMaterialsProfitLossCenter(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindMaterialsProfitLossCenter(Parameters).DataPath, _Key);
EndFunction

// Materials.ProfitLossCenter.Bind
Function BindMaterialsProfitLossCenter(Parameters)
	DataPath = "Materials.ProfitLossCenter";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindMaterialsProfitLossCenter");
EndFunction

// Materials.ProfitLossCenter.ChangeProfitLossCenterByBillOfMaterials.Step
Procedure StepMaterialsChangeProfitLossCenterByBillOfMaterials(Parameters, Chain) Export
	Chain.ChangeProfitLossCenterByBillOfMaterials.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeProfitLossCenterByBillOfMaterials.Setter = "SetMaterialsProfitLossCenter";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeProfitLossCenterByBillOfMaterialsOptions();
		Options.BillOfMaterials = GetMaterialsBillOfMaterials(Parameters, Row.Key);
		Options.CurrentProfitLossCenter = GetMaterialsProfitLossCenter(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepMaterialsChangeProfitLossCenterByBillOfMaterials";
		Chain.ChangeProfitLossCenterByBillOfMaterials.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region MATERIALS_EXPENSE_TYPE

// Materials.ExpenseType.Set
Procedure SetMaterialsExpenseType(Parameters, Results) Export
	Binding = BindMaterialsExpenseType(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Materials.ExpenseType.Get
Function GetMaterialsExpenseType(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindMaterialsExpenseType(Parameters).DataPath, _Key);
EndFunction

// Materials.ExpenseType.Bind
Function BindMaterialsExpenseType(Parameters)
	DataPath = "Materials.ExpenseType";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindMaterialsExpenseType");
EndFunction

// Materials.ExpenseType.ChangeExpenseTypeByBillOfMaterials.Step
Procedure StepMaterialsChangeExpenseTypeByBillOfMaterials(Parameters, Chain) Export
	Chain.ChangeExpenseTypeByBillOfMaterials.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeExpenseTypeByBillOfMaterials.Setter = "SetMaterialsExpenseType";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeExpenseTypeByBillOfMaterialsOptions();
		Options.ItemKeyBOM      = GetMaterialsItemKeyBOM(Parameters, Row.Key);
		Options.BillOfMaterials = GetMaterialsBillOfMaterials(Parameters, Row.Key);
		Options.CurrentExpenseType = GetMaterialsExpenseType(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepMaterialsChangeExpenseTypeByBillOfMaterials";
		Chain.ChangeExpenseTypeByBillOfMaterials.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region MATERIALS_MATERIAL_TYPE

// Materials.MaterialType.OnChange
Procedure MaterialsMaterialTypeOnChange(Parameters) Export
	AddViewNotify("OnSetMaterialsMaterialTypeNotify", Parameters);
	Binding = BindMaterialsMaterialType(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Materials.MaterialType.Set
Procedure SetMaterialsMaterialType(Parameters, Results) Export
	Binding = BindMaterialsMaterialType(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetMaterialsMaterialTypeNotify");
EndProcedure

// Materials.MaterialType.Bind
Function BindMaterialsMaterialType(Parameters)
	DataPath = "Materials.MaterialType";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindMaterialsMaterialType");
EndFunction

#EndRegion

#Region MATERIALS_CALCULATIONS

// Materials.Set
Procedure SetMaterials(Parameters, Results) Export
	For Each Result In Results Do
		If Result.Value.Materials.Count() Then
			If Not Parameters.Cache.Property("Materials") Then
				AddTableToCache(Parameters, "Materials");
			Else
				Parameters.Cache.Materials.Clear();
			EndIf;
			
			// add new rows
			For Each Row In Result.Value.Materials Do
				AddRowToTableCache(Parameters, "Materials", Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

// Materials.SetWithKeyOwner
Procedure SetMaterialsWithKeyOwner(Parameters, Results) Export
	For Each Result In Results Do
		If Result.Value.Materials.Count() Then
			If Not Parameters.Cache.Property("Materials") Then
				AddTableToCache(Parameters, "Materials");
			EndIf;
			
			// remove from cache old rows
			Count = Parameters.Cache.Materials.Count();
			For i = 1 To Count Do
				Index = Count - i;
				ArrayItem = Parameters.Cache.Materials[Index];
				If ArrayItem.KeyOwner = Result.Options.KeyOwner Then
					Parameters.Cache.Materials.Delete(Index);
				EndIf;
			EndDo;
			
			// add new rows
			For Each Row In Result.Value.Materials Do
				If Row.KeyOwner = Result.Options.KeyOwner Then
					AddRowToTableCache(Parameters, "Materials", Row);
				EndIf;
			EndDo;
		EndIf;
	EndDo;
EndProcedure

// Step.Materials.Calculations
Procedure StepMaterialsCalculations(Parameters, Chain) Export
	Chain.MaterialsCalculations.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.MaterialsCalculations.Setter = "SetMaterials";
	Chain.MaterialsCalculations.IsLazyStep = True;
	Chain.MaterialsCalculations.LazyStepName = "StepMaterialsCalculations";
	
	ArrayOfMaterialsRows = New Array();
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		NewRow = New Structure(Parameters.ObjectMetadataInfo.Tables.Materials.Columns);
		FillPropertyValues(NewRow, Row);
		ArrayOfMaterialsRows.Add(NewRow);
	EndDo;	
		
	Options = ModelClientServer_V2.MaterialsCalculationsOptions();
	Options.Materials = ArrayOfMaterialsRows;
	Options.BillOfMaterials  = GetBillOfMaterials(Parameters);
	Options.MaterialsColumns = Parameters.ObjectMetadataInfo.Tables.Materials.Columns;
	Options.ItemKey          = GetItemKey(Parameters);
	Options.Unit             = GetUnit(Parameters);
	Options.Quantity         = GetQuantity(Parameters);
	Options.StepName = "StepMaterialsCalculations";
	Chain.MaterialsCalculations.Options.Add(Options);
	Parameters.IsFullRefill_Materials = True;
EndProcedure

// Step.Materials.CalculationsWithKeyOwner
Procedure StepMaterialsCalculationsWithKeyOwner(Parameters, Chain) Export
	Chain.MaterialsCalculations.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.MaterialsCalculations.Setter = "SetMaterialsWithKeyOwner";
	Chain.MaterialsCalculations.IsLazyStep = True;
	Chain.MaterialsCalculations.LazyStepName = "StepMaterialsCalculationsWithKeyOwner";
	
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		ArrayOfMaterialsRows = New Array();
		MaterialsRows = Parameters.Object.Materials.FindRows(New Structure("KeyOwner", Row.Key));
		For Each RowMaterials In MaterialsRows Do
			NewRow = New Structure(Parameters.ObjectMetadataInfo.Tables.Materials.Columns);
			FillPropertyValues(NewRow, RowMaterials);
			ArrayOfMaterialsRows.Add(AddBOMColumnsToRow(NewRow));
		EndDo;
				
		Options = ModelClientServer_V2.MaterialsCalculationsOptions();
		Options.KeyOwner  = Row.Key;
		Options.Materials = ArrayOfMaterialsRows;
		Options.BillOfMaterials  = GetItemListBillOfMaterials(Parameters, Row.Key);
		Options.MaterialsColumns = AddBOMColumnsToList(Parameters.ObjectMetadataInfo.Tables.Materials.Columns);
		Options.ItemKey          = GetItemListItemKey(Parameters, Row.Key);
		Options.Unit             = GetItemListUnit(Parameters, Row.Key);
		Options.Quantity         = GetItemListQuantity(Parameters, Row.Key);
		Options.StepName = "StepMaterialsCalculationsWithKeyOwner";
		Chain.MaterialsCalculations.Options.Add(Options);
	EndDo;
	Parameters.IsFullRefill_Materials = True;
EndProcedure

// Step.Materials.RecalculateQuantity
Procedure StepMaterialsRecalculateQuantity(Parameters, Chain) Export
	Chain.MaterialsRecalculateQuantity.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.MaterialsRecalculateQuantity.Setter = "SetMaterials";
	Chain.MaterialsRecalculateQuantity.IsLazyStep = True;
	Chain.MaterialsRecalculateQuantity.LazyStepName = "StepMaterialsRecalculateQuantity";
	
	ArrayOfMaterialsRows = New Array();
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		NewRow = New Structure(Parameters.ObjectMetadataInfo.Tables.Materials.Columns);
		FillPropertyValues(NewRow, Row);
		ArrayOfMaterialsRows.Add(NewRow);
	EndDo;	
		
	Options = ModelClientServer_V2.MaterialsCalculationsOptions();
	Options.Materials = ArrayOfMaterialsRows;
	Options.BillOfMaterials  = GetBillOfMaterials(Parameters);
	Options.MaterialsColumns = Parameters.ObjectMetadataInfo.Tables.Materials.Columns;
	Options.ItemKey          = GetItemKey(Parameters);
	Options.Unit             = GetUnit(Parameters);
	Options.Quantity         = GetQuantity(Parameters);
	Options.StepName = "StepMaterialsRecalculateQuantity";
	Chain.MaterialsRecalculateQuantity.Options.Add(Options);
	Parameters.IsFullRefill_Materials = True;
EndProcedure

// Step.Materials.RecalculateQuantityWithKeyOwner
Procedure StepMaterialsRecalculateQuantityWithKeyOwner(Parameters, Chain) Export
	Chain.MaterialsRecalculateQuantity.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.MaterialsRecalculateQuantity.Setter = "SetMaterialsWithKeyOwner";
	Chain.MaterialsRecalculateQuantity.IsLazyStep = True;
	Chain.MaterialsRecalculateQuantity.LazyStepName = "StepMaterialsRecalculateQuantityWithKeyOwner";
	
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		ArrayOfMaterialsRows = New Array();
		MaterialsRows = Parameters.Object.Materials.FindRows(New Structure("KeyOwner", Row.Key));
		For Each RowMaterials In MaterialsRows Do
			NewRow = New Structure(Parameters.ObjectMetadataInfo.Tables.Materials.Columns);
			FillPropertyValues(NewRow, RowMaterials);
			ArrayOfMaterialsRows.Add(AddBOMColumnsToRow(NewRow));
		EndDo;
			
		Options = ModelClientServer_V2.MaterialsCalculationsOptions();
		Options.KeyOwner = Row.Key; 
		Options.Materials = ArrayOfMaterialsRows;
		Options.BillOfMaterials  = GetItemListBillOfMaterials(Parameters, Row.Key);
		Options.MaterialsColumns = AddBOMColumnsToList(Parameters.ObjectMetadataInfo.Tables.Materials.Columns);
		Options.ItemKey          = GetItemListItemKey(Parameters, Row.Key);
		Options.Unit             = GetItemListUnit(Parameters, Row.Key);
		Options.Quantity         = GetItemListQuantity(Parameters, Row.Key);
		Options.StepName = "StepMaterialsRecalculateQuantity";
		Chain.MaterialsRecalculateQuantity.Options.Add(Options);
	EndDo;
	Parameters.IsFullRefill_Materials = True;
EndProcedure

Function AddBOMColumnsToRow(Row)
	If Not Row.Property("ItemBOM") Then
		Row.Insert("ItemBOM", Row.Item);
	EndIf;
			
	If Not Row.Property("ItemKeyBOM") Then
		Row.Insert("ItemKeyBOM", Row.ItemKey);
	EndIf;
			
	If Not Row.Property("UnitBOM") Then
		Row.Insert("UnitBOM", Row.Unit);
	EndIf;
			
	If Not Row.Property("QuantityBOM") Then
		Row.Insert("QuantityBOM", Row.Quantity);
	EndIf;
			
	If Not Row.Property("QuantityInBaseUnitBOM") Then
		Row.Insert("QuantityInBaseUnitBOM", Row.QuantityInBaseUnit);
	EndIf;
	
	If Not Row.Property("IsManualChanged") Then
		Row.Insert("IsManualChanged", False);
	EndIf;
	
	Return Row;
EndFunction

Function AddBOMColumnsToList(ExistsColumns)
	ArrayOfExistsColumns = New Array();
	For Each Column In StrSplit(ExistsColumns, ",") Do
		ArrayOfExistsColumns.Add(TrimAll(Column));
	EndDo;
	
	If ArrayOfExistsColumns.Find("ItemBOM") = Undefined Then
		ArrayOfExistsColumns.Add("ItemBOM");
	EndIf;
	
	If ArrayOfExistsColumns.Find("ItemKeyBOM") = Undefined Then
		ArrayOfExistsColumns.Add("ItemKeyBOM");
	EndIf;
	
	If ArrayOfExistsColumns.Find("UnitBOM") = Undefined Then
		ArrayOfExistsColumns.Add("UnitBOM");
	EndIf;
	
	If ArrayOfExistsColumns.Find("QuantityBOM") = Undefined Then
		ArrayOfExistsColumns.Add("QuantityBOM");
	EndIf;
	
	If ArrayOfExistsColumns.Find("QuantityInBaseUnitBOM") = Undefined Then
		ArrayOfExistsColumns.Add("QuantityInBaseUnitBOM");
	EndIf;

	If ArrayOfExistsColumns.Find("IsManualChanged") = Undefined Then
		ArrayOfExistsColumns.Add("IsManualChanged");
	EndIf;

	Return StrConcat(ArrayOfExistsColumns, ",");
EndFunction

#EndRegion

#EndRegion

#Region CONSIGNOR_BATCHES_LIST

// ConsignorBatches.Set
Procedure SetConsignorBatches(Parameters, Results) Export
	IsChanged = False;	
	For Each Result In Results Do
		
		If Result.Value.DontFill = True Then
			IsChanged = True;
			If Parameters.Rows.Count() Then
				Parameters.RowsForRecalculate.Add(Parameters.Rows[0]);
			EndIf;
			Continue;
		EndIf;
		
		If Not Parameters.Cache.Property("ConsignorBatches") Then
			AddTableToCache(Parameters, "ConsignorBatches");
		EndIf;
				
		// remove from cache all rows
		Parameters.Cache.ConsignorBatches.Clear();
		
		// add new rows
		For Each Row In Result.Value.ConsignorBatches Do
			AddRowToTableCache(Parameters, "ConsignorBatches", Row);
		EndDo;
		
		Changes = ControllerServer_V2.ArrayOfStructuresIsEqual(
			Parameters.Object.ConsignorBatches, 
			Parameters.Cache.ConsignorBatches, 
			"Key, ItemKey, SerialLotNumber, SourceOfOrigin, Store, Batch, Quantity");
		
		For Each Row0 In Changes Do
			For Each Row1 In Parameters.Rows Do
				If Row0.Key = Row1.Key Then
					Parameters.RowsForRecalculate.Add(Row1);
				EndIf;
			EndDo;
		EndDo;
		
		IsChanged = Changes.Count() > 0;
		
	EndDo;
	
	Binding = BindConsignorBatches(Parameters);
	RegisterNextSteps(Parameters, IsChanged, Binding.StepsEnabler, Binding.DataPath);
EndProcedure

Function GetConsignorBatches(Parameters, _Key = Undefined)
	ConsignorBatches = Parameters.Object.ConsignorBatches;
	If Parameters.Cache.Property("ConsignorBatches") Then
		ConsignorBatches =  Parameters.Cache.ConsignorBatches;
	EndIf;
		
	Table = New Array();
	For Each Row In ConsignorBatches Do
		If ValueIsFilled(_Key) And Row.Key <> _Key Then
			Continue;
		EndIf;
		
		NewRow = New Structure("Key, ItemKey, SerialLotNumber, Store, Batch, Quantity");
		FillPropertyValues(NewRow, Row);
		Table.Add(NewRow);
	EndDo;
	Return Table;
EndFunction

// ConsignorBatches.Bind
Function BindConsignorBatches(Parameters)
	DataPath = "ConsignorBatches";
	Binding = New Structure();
			
	Binding.Insert("SalesInvoice",
		"StepChangeTaxRate_AgreementInHeader_ConsignorBatches");
	
	Binding.Insert("RetailSalesReceipt",
		"StepChangeTaxRate_AgreementInHeader_ConsignorBatches");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindConsignorBatches");
EndFunction

// Step.ConsignorBatches.FillBatches
Procedure StepConsignorBatchesFillBatches(Parameters, Chain) Export
	Chain.ConsignorBatchesFillBatches.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ConsignorBatchesFillBatches.Setter = "SetConsignorBatches";
	Chain.ConsignorBatchesFillBatches.IsLazyStep = True;
	Chain.ConsignorBatchesFillBatches.LazyStepName = "StepConsignorBatchesFillBatches";
	
	Rows = GetRows(Parameters, Parameters.TableName);
	ItemListConsignor = Undefined;
	If Rows.Count() = 1 Then
		ItemListConsignor = GetItemListConsignor(Parameters, Rows[0].Key);
	EndIf;
	
	Options = ModelClientServer_V2.ConsignorBatchesFillBatchesOptions();
	
	If Not ValueIsFilled(ItemListConsignor) Then
		Options.Consignor = ItemListConsignor;
		Options.DocObject = Parameters.Object;
		Options.Table_ItemList         = GetOption_Table_ItemList(Parameters);
		Options.Table_SerialLotNumbers = GetOption_Table_SerialLotNumbers(Parameters);
		Options.Table_SourceOfOrigins  = GetOption_Table_SourceOfOrigins(Parameters);
		Options.Table_ConsignorBatches = GetConsignorBatches(Parameters);
		Options.SilentMode = Not Parameters.FormIsExists;	
	Else
		Options.DontFill = True;
		Options.Consignor = ItemListConsignor;
	EndIf;
	
	Options.StepName = "StepConsignorBatchesFillBatches";
	Chain.ConsignorBatchesFillBatches.Options.Add(Options);
EndProcedure

// Step.ConsignorBatches.FillBatches_StoreSender
Procedure StepConsignorBatchesFillBatches_StoreSender(Parameters, Chain) Export
	Chain.ConsignorBatchesFillBatches.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ConsignorBatchesFillBatches.Setter = "SetConsignorBatches";
	Chain.ConsignorBatchesFillBatches.IsLazyStep = True;
	Chain.ConsignorBatchesFillBatches.LazyStepName = "StepConsignorBatchesFillBatches_StoreSender";
	
	Options = ModelClientServer_V2.ConsignorBatchesFillBatchesOptions();
	Options.DocObject = Parameters.Object;
	Options.Table_ItemList         = GetOption_Table_ItemList_StoreSender(Parameters);
	Options.Table_SerialLotNumbers = GetOption_Table_SerialLotNumbers(Parameters);
	Options.Table_SourceOfOrigins  = GetOption_Table_SourceOfOrigins(Parameters);
	Options.Table_ConsignorBatches = GetConsignorBatches(Parameters);
	Options.SilentMode = Not Parameters.FormIsExists;	
	
	Options.StepName = "StepConsignorBatchesFillBatches";
	Chain.ConsignorBatchesFillBatches.Options.Add(Options);
EndProcedure

Function GetOption_Table_ItemList(Parameters)
	Table = New Array();
	For Each Row In Parameters.Object.ItemList Do
		NewRow = New Structure("Key, InventoryOrigin, Company, ItemKey, Store, Quantity");
		NewRow.Key = Row.Key;
		NewRow.InventoryOrigin = GetItemListInventoryOrigin(Parameters, Row.Key);
		NewRow.Company         = GetCompany(Parameters);
		NewRow.ItemKey         = GetItemListItemKey(Parameters, Row.Key);
		NewRow.Store           = GetItemListStore(Parameters, Row.Key);
		NewRow.Quantity        = GetItemListQuantityInBaseUnit(Parameters, Row.Key);
		Table.Add(NewRow);
	EndDo;
	Return Table;
EndFunction

Function GetOption_Table_ItemList_StoreSender(Parameters)
	Table = New Array();
	For Each Row In Parameters.Object.ItemList Do
		NewRow = New Structure("Key, InventoryOrigin, Company, ItemKey, Store, Quantity");
		NewRow.Key = Row.Key;
		NewRow.InventoryOrigin = GetItemListInventoryOrigin(Parameters, Row.Key);
		NewRow.Company         = GetCompany(Parameters);
		NewRow.ItemKey         = GetItemListItemKey(Parameters, Row.Key);
		NewRow.Store           = GetStoreSender(Parameters);
		NewRow.Quantity        = GetItemListQuantityInBaseUnit(Parameters, Row.Key);
		Table.Add(NewRow);
	EndDo;
	Return Table;
EndFunction

Function GetOption_Table_SerialLotNumbers(Parameters)
	Table = New Array();
	For Each Row In Parameters.Object.SerialLotNumbers Do
		NewRow = New Structure("Key, SerialLotNumber, Quantity");
		FillPropertyValues(NewRow, Row);
		Table.Add(NewRow);
	EndDo;
	Return Table;
EndFunction

Function GetOption_Table_SourceOfOrigins(Parameters)
	Table = New Array();
	For Each Row In Parameters.Object.SourceOfOrigins Do
		NewRow = New Structure("Key, SerialLotNumber, SourceOfOrigin, Quantity");
		FillPropertyValues(NewRow, Row);
		Table.Add(NewRow);
	EndDo;
	Return Table;
EndFunction

#EndRegion

#Region PRODUCTION_DURATIONS_LIST

#Region PRODUCTION_DURATIONS_LIST_ITEM

// ProductionDurationsList.Item.OnChange
Procedure ProductionDurationsListItemOnChange(Parameters) Export
	Binding = BindProductionDurationsListItem(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ProductionDurationsList.Item.Set
Procedure SetProductionDurationsListItem(Parameters, Results) Export
	Binding = BindProductionDurationsListItem(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ProductionDurationsList.Item.Get
Function GetProductionDurationsListItem(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindProductionDurationsListItem(Parameters).DataPath, _Key);
EndFunction

// ProductionDurationsList.Item.Bind
Function BindProductionDurationsListItem(Parameters)
	DataPath = "ProductionDurationsList.Item";
	Binding = New Structure();
	Binding.Insert("ProductionCostsAllocation", "StepProductionDurationsListChangeItemKeyByItem");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindProductionDurationsListItem");
EndFunction

#EndRegion

#Region PRODUCTION_DURATIONS_LIST_ITEMKEY

// ProductionDurationsList.ItemKey.OnChange
Procedure ProductionDurationsListItemKeyOnChange(Parameters) Export
	AddViewNotify("OnSetProductionDurationsListItemKey", Parameters);
	Binding = BindProductionDurationsListItemKey(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ProductionDurationsList.ItemKey.Set
Procedure SetProductionDurationsListItemKey(Parameters, Results) Export
	Binding = BindProductionDurationsListItemKey(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetProductionDurationsListItemKey");
EndProcedure

// ProductionDurationsList.ItemKey.Get
Function GetProductionDurationsListItemKey(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindProductionDurationsListItemKey(Parameters).DataPath, _Key);
EndFunction

// ProductionDurationsList.ItemKey.Bind
Function BindProductionDurationsListItemKey(Parameters)
	DataPath = "ProductionDurationsList.ItemKey";
	Binding = New Structure();
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindProductionDurationsListItemKey");
EndFunction

// ProductionDurationsList.ItemKey.ChangeItemKeyByItem.Step
Procedure StepProductionDurationsListChangeItemKeyByItem(Parameters, Chain) Export
	Chain.ChangeItemKeyByItem.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeItemKeyByItem.Setter = "SetProductionDurationsListItemKey";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeItemKeyByItemOptions();
		Options.Item    = GetProductionDurationsListItem(Parameters, Row.Key);
		Options.ItemKey = GetProductionDurationsListItemKey(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepProductionDurationsListChangeItemKeyByItem";
		Chain.ChangeItemKeyByItem.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region PRODUCTION_DURATIONS_LIST_DURATION

// ProductionDurationsList.Duration.OnChange
Procedure ProductionDurationsListDurationOnChange(Parameters) Export
	Binding = BindProductionDurationsListDuration(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ProductionDurationsList.Duration.Bind
Function BindProductionDurationsListDuration(Parameters)
	DataPath = "ProductionDurationsList.Duration";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindProductionDurationsListDuration");
EndFunction

#EndRegion

#Region PRODUCTION_DURATIONS_LIST_AMOUNT

// ProductionDurationsList.Amount.OnChange
Procedure ProductionDurationsListAmountOnChange(Parameters) Export
	Binding = BindProductionDurationsListAmount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ProductionDurationsList.Amount.Bind
Function BindProductionDurationsListAmount(Parameters)
	DataPath = "ProductionDurationsList.Amount";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindProductionDurationsListAmount");
EndFunction

#EndRegion

#Region PRODUCTION_DURATIONS_LIST_LOAD_DATA

// ProductionDurationsList.Load
Procedure ProductionDurationsListLoad(Parameters) Export
	Binding = BindProductionDurationsListLoad(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ProductionDurationsList.Load.Set
#If Server Then
	
Procedure ServerTableLoaderProductionDurationsList(Parameters, Results) Export
	Binding = BindProductionDurationsListLoad(Parameters);
	LoaderTable(Binding.DataPath, Parameters, Results);
EndProcedure

#EndIf

// ProductionDurationsList.Load.Bind
Function BindProductionDurationsListLoad(Parameters)
	DataPath = "ProductionDurationsList";
	Binding = New Structure();
	Return BindSteps("StepProductionDurationsListLoadTable", DataPath, Binding, Parameters, "BindProductionDurationsListLoad");
EndFunction

// ProductionDurationsList.LoadAtServer.Step
Procedure StepProductionDurationsListLoadTable(Parameters, Chain) Export
	Chain.LoadTable.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.LoadTable.Setter = "ServerTableLoaderProductionDurationsList";
	Options = ModelClientServer_V2.LoadTableOptions();
	Options.TableAddress = Parameters.LoadData.Address;
	Chain.LoadTable.Options.Add(Options);
EndProcedure

#EndRegion

#EndRegion

#Region PRODUCTION_COSTS_LIST

#Region PRODUCTION_COSTS_LIST_AMOUNT

// ProductionCostsList.Amount.OnChange
Procedure ProductionCostsListAmountOnChange(Parameters) Export
	Binding = BindProductionCostsListAmount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ProductionCostsList.Amount.Bind
Function BindProductionCostsListAmount(Parameters)
	DataPath = "ProductionCostsList.Amount";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindProductionCostsListAmount");
EndFunction

#EndRegion

#Region PRODUCTION_COSTS_LIST_LOAD_DATA

// ProductionCostsList.Load
Procedure ProductionCostsListLoad(Parameters) Export
	Binding = BindProductionCostsListLoad(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ProductionCostsList.Load.Set
#If Server Then
	
Procedure ServerTableLoaderProductionCostsList(Parameters, Results) Export
	Binding = BindProductionCostsListLoad(Parameters);
	LoaderTable(Binding.DataPath, Parameters, Results);
EndProcedure

#EndIf

// ProductionCostsList.Load.Bind
Function BindProductionCostsListLoad(Parameters)
	DataPath = "ProductionCostsList";
	Binding = New Structure();
	Return BindSteps("StepProductionCostsListLoadTable", DataPath, Binding, Parameters, "BindProductionCostsListLoad");
EndFunction

// ProductionCostsList.LoadAtServer.Step
Procedure StepProductionCostsListLoadTable(Parameters, Chain) Export
	Chain.LoadTable.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.LoadTable.Setter = "ServerTableLoaderProductionCostsList";
	Options = ModelClientServer_V2.LoadTableOptions();
	Options.TableAddress = Parameters.LoadData.Address;
	Chain.LoadTable.Options.Add(Options);
EndProcedure

#EndRegion

#EndRegion

#Region ITEM_LIST

#Region ITEM_LIST_PARTNER_ITEM

// ItemList.PartnerItem.OnChange
Procedure ItemListPartnerItemOnChange(Parameters) Export
	Binding = BindItemListPartnerItem(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.PartnerItem.MultiSet
Procedure MultiSetItemListPartnerItem(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Item"     , BindItemListItem(Parameters));
	ResourceToBinding.Insert("ItemKey"  , BindItemListItemKey(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// ItemList.PartnerItem.Get
Function GetItemListPartnerItem(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindItemListPartnerItem(Parameters).DataPath, _Key);
EndFunction

// ItemList.Item.Bind
Function BindItemListPartnerItem(Parameters)
	DataPath = "ItemList.PartnerItem";
	Binding = New Structure();
	Binding.Insert("SalesOrder"    , "StepItemListChangeItemByPartnerItem");
	Binding.Insert("PurchaseOrder" , "StepItemListChangeItemByPartnerItem");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListPartnerItem");
EndFunction

#EndRegion

#Region ITEM_LIST_ITEM

// ItemList.Item.OnChange
Procedure ItemListItemOnChange(Parameters) Export
	AddViewNotify("OnSetItemListItem", Parameters);
	Binding = BindItemListItem(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.Item.Set
Procedure SetItemListItem(Parameters, Results) Export
	Binding = BindItemListItem(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetItemListItem");
EndProcedure

// ItemList.Item.Get
Function GetItemListItem(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindItemListItem(Parameters).DataPath, _Key);
EndFunction

// ItemList.Item.Bind
Function BindItemListItem(Parameters)
	DataPath = "ItemList.Item";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation"      , "StepItemListChangeItemKeyByItem");
	Binding.Insert("GoodsReceipt"              , "StepItemListChangeItemKeyByItem");
	Binding.Insert("RetailShipmentConfirmation"      , "StepItemListChangeItemKeyByItem");
	Binding.Insert("RetailGoodsReceipt"              , "StepItemListChangeItemKeyByItem");
	Binding.Insert("StockAdjustmentAsSurplus"  , "StepItemListChangeItemKeyByItem");
	Binding.Insert("StockAdjustmentAsWriteOff" , "StepItemListChangeItemKeyByItem");
	Binding.Insert("SalesOrder"                , "StepItemListChangeItemKeyByItem");
	Binding.Insert("WorkOrder"                 , "StepItemListChangeItemKeyByItem");
	Binding.Insert("WorkSheet"                 , "StepItemListChangeItemKeyByItem");
	Binding.Insert("SalesInvoice"              , "StepItemListChangeItemKeyByItem");
	Binding.Insert("RetailSalesReceipt"        , "StepItemListChangeItemKeyByItem,StepChangeisControlCodeStringByItem");
	Binding.Insert("PurchaseOrder"             , "StepItemListChangeItemKeyByItem");
	Binding.Insert("PurchaseInvoice"           , "StepItemListChangeItemKeyByItem");
	Binding.Insert("RetailReturnReceipt"       , "StepItemListChangeItemKeyByItem,StepChangeisControlCodeStringByItem");
	Binding.Insert("PurchaseReturnOrder"       , "StepItemListChangeItemKeyByItem");
	Binding.Insert("PurchaseReturn"            , "StepItemListChangeItemKeyByItem");
	Binding.Insert("SalesReturnOrder"          , "StepItemListChangeItemKeyByItem");
	Binding.Insert("SalesReturn"               , "StepItemListChangeItemKeyByItem");
	Binding.Insert("InternalSupplyRequest"     , "StepItemListChangeItemKeyByItem");
	Binding.Insert("InventoryTransfer"         , "StepItemListChangeItemKeyByItem");
	Binding.Insert("InventoryTransferOrder"    , "StepItemListChangeItemKeyByItem");
	Binding.Insert("PhysicalInventory"         , "StepItemListChangeItemKeyByItem");
	Binding.Insert("PhysicalCountByLocation"   , "StepItemListChangeItemKeyByItem");
	Binding.Insert("ItemStockAdjustment"       , "StepItemListChangeItemKeyByItem, 
												 |StepItemListChangeItemKeyWriteOffByItem");
	Binding.Insert("Bundling"                  , "StepItemListChangeItemKeyByItem");
	Binding.Insert("Unbundling"                , "StepItemListChangeItemKeyByItem");
	
	Binding.Insert("SalesReportFromTradeAgent" , "StepItemListChangeItemKeyByItem");
	Binding.Insert("SalesReportToConsignor"    , "StepItemListChangeItemKeyByItem");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListItem");
EndFunction

// ItemList.Item.StepItemListChangeItemByPartnerItem.Step
Procedure StepItemListChangeItemByPartnerItem(Parameters, Chain) Export
	Chain.ChangeItemByPartnerItem.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeItemByPartnerItem.Setter = "MultiSetItemListPartnerItem";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeItemByPartnerItemOptions();
		Options.PartnerItem = GetItemListPartnerItem(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepItemListChangeItemByPartnerItem";
		Chain.ChangeItemByPartnerItem.Options.Add(Options);
	EndDo;
EndProcedure

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

// ItemList.ItemKey.Get.IsChanged
Function GetItemListItemKey_IsChanged(Parameters, _Key)
	Return IsChangedProperty(Parameters, BindItemListItemKey(Parameters).DataPath, _Key).IsChanged
		Or IsChangedPropertyDirectly_List(Parameters, _Key).IsChanged;
EndFunction

// ItemList.ItemKey.Bind
Function BindItemListItemKey(Parameters)
	DataPath = "ItemList.ItemKey";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation",
		"StepChangeUseSerialLotNumberByItemKey,
		|StepItemListChangeUnitByItemKey");
		
	Binding.Insert("GoodsReceipt",
		"StepChangeUseSerialLotNumberByItemKey,
		|StepItemListChangeUnitByItemKey");
	
	Binding.Insert("RetailShipmentConfirmation",
		"StepChangeUseSerialLotNumberByItemKey,
		|StepItemListChangeUnitByItemKey");
		
	Binding.Insert("RetailGoodsReceipt",
		"StepChangeUseSerialLotNumberByItemKey,
		|StepItemListChangeUnitByItemKey");
		
	Binding.Insert("StockAdjustmentAsSurplus",
		"StepChangeUseSerialLotNumberByItemKey,
		|StepItemListChangeUnitByItemKey");
		
	Binding.Insert("StockAdjustmentAsWriteOff",
		"StepChangeUseSerialLotNumberByItemKey,
		|StepItemListChangeUnitByItemKey");

	Binding.Insert("InventoryTransfer",
		"StepChangeUseSerialLotNumberByItemKey,
		|StepItemListChangeUnitByItemKey,
		|StepConsignorBatchesFillBatches_StoreSender");
	
	Binding.Insert("InventoryTransferOrder",
		"StepItemListChangeUnitByItemKey");
		
	Binding.Insert("SalesOrder",
		"StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType,
		|StepChangeTaxRate_AgreementInHeader,
		|StepItemListChangeUnitByItemKey,
		|StepItemListChangeRevenueTypeByItemKey,
		|StepItemListChangeProcurementMethodByItemKey,
		|StepChangeIsServiceByItemKey");
	
	Binding.Insert("WorkOrder",
		"StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType,
		|StepChangeTaxRate_AgreementInHeader,
		|StepItemListChangeUnitByItemKey,
		|StepChangeIsServiceByItemKey,
		|StepItemListChangeBillOfMaterialsByItemKey");
	
	Binding.Insert("WorkSheet", 
		"StepItemListChangeUnitByItemKey, 
		|StepChangeIsServiceByItemKey,
		|StepItemListChangeBillOfMaterialsByItemKey");
	
	Binding.Insert("SalesInvoice",
		"StepItemListChangeUseShipmentConfirmationByStore,
		|StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType,
		|StepChangeTaxRate_AgreementInHeader,
		|StepChangeUseSerialLotNumberByItemKey,
		|StepItemListChangeUnitByItemKey,
		|StepItemListChangeRevenueTypeByItemKey,
		|StepChangeIsServiceByItemKey,
		|StepConsignorBatchesFillBatches");

	Binding.Insert("PurchaseReturnOrder",
		"StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType,
		|StepChangeTaxRate_AgreementInHeader,
		|StepItemListChangeUnitByItemKey,
		|StepItemListChangeExpenseTypeByItemKey,
		|StepChangeIsServiceByItemKey");

	Binding.Insert("PurchaseReturn",
		"StepItemListChangeUseShipmentConfirmationByStore,
		|StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType,
		|StepChangeTaxRate_AgreementInHeader,
		|StepChangeUseSerialLotNumberByItemKey,
		|StepItemListChangeUnitByItemKey,
		|StepItemListChangeExpenseTypeByItemKey,
		|StepChangeIsServiceByItemKey");

	Binding.Insert("RetailSalesReceipt",
		"StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType,
		|StepChangeTaxRate_AgreementInHeader,
		|StepChangeUseSerialLotNumberByItemKey,
		|StepItemListChangeUnitByItemKey,
		|StepItemListChangeRevenueTypeByItemKey,
		|StepChangeIsServiceByItemKey,
		|StepConsignorBatchesFillBatches");
	
	Binding.Insert("RetailReturnReceipt",
		"StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType,
		|StepChangeTaxRate_AgreementInHeader,
		|StepChangeUseSerialLotNumberByItemKey,
		|StepItemListChangeUnitByItemKey,
		|StepItemListChangeRevenueTypeByItemKey,
		|StepChangeIsServiceByItemKey");
	
	Binding.Insert("PurchaseOrder",
		"StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType,
		|StepChangeTaxRate_AgreementInHeader,
		|StepItemListChangeUnitByItemKey,
		|StepItemListChangeExpenseTypeByItemKey,
		|StepChangeIsServiceByItemKey");
	
	Binding.Insert("PurchaseInvoice",
		"StepItemListChangeUseGoodsReceiptByStore,
		|StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType,
		|StepChangeTaxRate_AgreementInHeader,
		|StepChangeUseSerialLotNumberByItemKey,
		|StepItemListChangeUnitByItemKey,
		|StepItemListChangeExpenseTypeByItemKey,
		|StepChangeIsServiceByItemKey");
	
	Binding.Insert("SalesReportFromTradeAgent",
		"StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType,
		|StepChangeTaxRate_AgreementInHeader,
		|StepChangeUseSerialLotNumberByItemKey,
		|StepItemListChangeUnitByItemKey,
		|StepChangeIsServiceByItemKey");
	
	Binding.Insert("SalesReportToConsignor",
		"StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType,
		|StepChangeTaxRate_AgreementInHeader,
		|StepChangeUseSerialLotNumberByItemKey,
		|StepItemListChangeUnitByItemKey,
		|StepChangeIsServiceByItemKey");
	
	Binding.Insert("SalesReturnOrder",
		"StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType,
		|StepChangeTaxRate_AgreementInHeader,
		|StepItemListChangeUnitByItemKey,
		|StepItemListChangeRevenueTypeByItemKey,
		|StepChangeIsServiceByItemKey");
	
	Binding.Insert("SalesReturn",
		"StepItemListChangeUseGoodsReceiptByStore,
		|StepItemListChangePriceTypeByAgreement,
		|StepItemListChangePriceByPriceType,
		|StepChangeTaxRate_AgreementInHeader,
		|StepChangeUseSerialLotNumberByItemKey,
		|StepItemListChangeUnitByItemKey,
		|StepItemListChangeRevenueTypeByItemKey,
		|StepChangeIsServiceByItemKey");
	
	Binding.Insert("InternalSupplyRequest",
		"StepItemListChangeUnitByItemKey");
	
	Binding.Insert("PhysicalInventory", 
			"StepItemListChangeUnitByItemKey,
			|StepChangeUseSerialLotNumberByItemKey,
			|StepClearSerialLotNumberByItemKey");

	Binding.Insert("PhysicalCountByLocation", 
			"StepItemListChangeUnitByItemKey,
			|StepChangeUseSerialLotNumberByItemKey,
			|StepClearSerialLotNumberByItemKey,
			|StepClearBarcodeByItemKey");
		
	Binding.Insert("ItemStockAdjustment" , "StepItemListChangeUnitByItemKey");
	Binding.Insert("Bundling"            , "StepItemListChangeUnitByItemKey");
	Binding.Insert("Unbundling"          , "StepItemListChangeUnitByItemKey");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListItemKey");
EndFunction

// ItemList.ItemKey.ChangeItemKeyByItem.Step
Procedure StepItemListChangeItemKeyByItem(Parameters, Chain) Export
	Chain.ChangeItemKeyByItem.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeItemKeyByItem.Setter = "SetItemListItemKey";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeItemKeyByItemOptions();
		Options.Item    = GetItemListItem(Parameters, Row.Key);
		Options.ItemKey = GetItemListItemKey(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepItemListChangeItemKeyByItem";
		Chain.ChangeItemKeyByItem.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_LIST_ITEMKEY_WRITEOFF

// ItemList.ItemKeyWriteOff.Set
Procedure SetItemListItemKeyWriteOff(Parameters, Results) Export
	Binding = BindItemListItemKeyWriteOff(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.ItemKeyWriteOff.Get
Function GetItemListItemKeyWriteOff(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindItemListItemKeyWriteOff(Parameters).DataPath, _Key);
EndFunction

// ItemList.ItemKey.Bind
Function BindItemListItemKeyWriteOff(Parameters)
	DataPath = "ItemList.ItemKeyWriteOff";
	Binding = New Structure();	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListItemKeyWriteOff");
EndFunction

// ItemList.ItemKey.ChangeItemKeyWriteOffByItem.Step
Procedure StepItemListChangeItemKeyWriteOffByItem(Parameters, Chain) Export
	Chain.ChangeItemKeyWriteOffByItem.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeItemKeyWriteOffByItem.Setter = "SetItemListItemKeyWriteOff";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeItemKeyWriteOffByItemOptions();
		Options.Item            = GetItemListItem(Parameters, Row.Key);
		Options.ItemKeyWriteOff = GetItemListItemKeyWriteOff(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepItemListChangeItemKeyWriteOffByItem";
		Chain.ChangeItemKeyWriteOffByItem.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_LIST_BILL_OF_MATERIALS

// ItemList.BillOfMaterials.OnChange
Procedure ItemListBillOfMaterialsOnChange(Parameters) Export
	AddViewNotify("OnSetItemListBillOfMaterialsNotify", Parameters);
	Binding = BindItemListBillOfMaterials(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.BillOfMaterials.Set
Procedure SetItemListBillOfMaterials(Parameters, Results) Export
	Binding = BindItemListBillOfMaterials(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetItemListBillOfMaterialsNotify");
EndProcedure

// ItemList.BillOfMaterials.Get
Function GetItemListBillOfMaterials(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindItemListBillOfMaterials(Parameters).DataPath, _Key);
EndFunction

// ItemList.BillOfMaterials.Bind
Function BindItemListBillOfMaterials(Parameters)
	DataPath = "ItemList.BillOfMaterials";
	Binding = New Structure();
	
	Binding.Insert("WorkOrder",
		"StepMaterialsCalculationsWithKeyOwner");
	
	Binding.Insert("WorkSheet",
		"StepMaterialsCalculationsWithKeyOwner");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListBillOfMaterials");
EndFunction

// ItemList.BillOfMaterials.ChangeBillOfMaterialsByItemKey.Step
Procedure StepItemListChangeBillOfMaterialsByItemKey(Parameters, Chain) Export
	Chain.ChangeBillOfMaterialsByItemKey.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeBillOfMaterialsByItemKey.Setter = "SetItemListBillOfMaterials";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeBillOfMaterialsByItemKeyOptions();
		Options.ItemKey = GetItemListItemKey(Parameters, Row.Key);
		Options.CurrentBillOfMaterials = GetItemListBillOfMaterials(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepItemListChangeBillOfMaterialsByItemKey";
		Chain.ChangeBillOfMaterialsByItemKey.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_LIST_PROCUREMENT_METHOD

// ItemList.ProcurementMethod.Set
Procedure SetItemListProcurementMethod(Parameters, Results) Export
	Binding = BindItemListProcurementMethod(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.ProcurementMethod.Get
Function GetItemListProcurementMethod(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindItemListProcurementMethod(Parameters).DataPath, _Key);
EndFunction

// ItemList.ProcurementMethod.Bind
Function BindItemListProcurementMethod(Parameters)
	DataPath = "ItemList.ProcurementMethod";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListProcurementMethod");
EndFunction

// ItemList.ProcurementMethod.StepItemListChangeProcurementMethodByItemKey.Step
Procedure StepItemListChangeProcurementMethodByItemKey(Parameters, Chain) Export
	Chain.ChangeProcurementMethodByItemKey.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeProcurementMethodByItemKey.Setter = "SetItemListProcurementMethod";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeProcurementMethodByItemKeyOptions();
		Options.ProcurementMethod = GetItemListProcurementMethod(Parameters, Row.Key);
		Options.ItemKey           = GetItemListItemKey(Parameters, Row.Key);
		Options.IsService         = GetItemListIsService(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepItemListChangeProcurementMethodByItemKey";
		Chain.ChangeProcurementMethodByItemKey.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_LIST_SALES_DOCUMENT

// ItemList.SalesDocument.OnChange
Procedure ItemListSalesDocumentOnChange(Parameters) Export
	Binding = BindItemListSalesDocument(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.SalesDocument.Set
Procedure SetItemListSalesDocument(Parameters, Results) Export
	Binding = BindItemListSalesDocument(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.SalesDocument.Get
Function GetItemListSalesDocument(Parameters, _Key)
	Binding = BindItemListSalesDocument(Parameters);
	Return GetPropertyObject(Parameters, Binding.DataPath, _Key);
EndFunction

// ItemList.SalesDocument.Bind
Function BindItemListSalesDocument(Parameters)
	DataPath = New Map();
	DataPath.Insert("GoodsReceipt"           , "ItemList.SalesInvoice");
	DataPath.Insert("SalesReturn"            , "ItemList.SalesInvoice");
	DataPath.Insert("SalesReturnOrder"       , "ItemList.SalesInvoice");
	DataPath.Insert("ShipmentConfirmation"   , "ItemList.SalesInvoice");
	DataPath.Insert("WorkSheet"              , "ItemList.SalesInvoice");
	DataPath.Insert("RetailReturnReceipt"    , "ItemList.RetailSalesReceipt");
	DataPath.Insert("SalesReportToConsignor" , "ItemList.SalesInvoice");
	
	Binding = New Structure();
	Binding.Insert("SalesReturn"         , "StepChangeLandedCostBySalesDocument");
	
	Binding.Insert("RetailReturnReceipt" , 
		"StepChangeLandedCostBySalesDocument,
		|StepChangeConsolidatedRetailSalesByWorkstation");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListSalesDocument");
EndFunction

#EndRegion

#Region ITEM_LIST_LANDEDCOST

// ItemList.LandedCost.OnChange
Procedure ItemListLandedCostOnChange(Parameters) Export
	Binding = BindItemListLandedCost(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.LandedCost.Set
Procedure SetItemListLandedCost(Parameters, Results) Export
	Binding = BindItemListLandedCost(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.LandedCost.Get
Function GetItemListLandedCost(Parameters, _Key)
	Binding = BindItemListLandedCost(Parameters);
	Return GetPropertyObject(Parameters, Binding.DataPath, _Key);
EndFunction

// ItemList.LandedCost.Bind
Function BindItemListLandedCost(Parameters)
	DataPath = "ItemList.LandedCost";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListLandedCost");
EndFunction

// ItemList.LandedCost.StepChangeLandedCostBySalesDocument.Step
Procedure StepChangeLandedCostBySalesDocument(Parameters, Chain) Export
	Chain.ChangeLandedCostBySalesDocument.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeLandedCostBySalesDocument.Setter = "SetItemListLandedCost";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeLandedCostBySalesDocumentOptions();
		Options.SalesDocument     = GetItemListSalesDocument(Parameters, Row.Key);
		Options.CurrentLandedCost = GetItemListLandedCost(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepChangeLandedCostBySalesDocument";
		Chain.ChangeLandedCostBySalesDocument.Options.Add(Options);
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
	
	Binding.Insert("SalesOrder", 
		"StepItemListCalculateQuantityInBaseUnit,
		|StepItemListChangePriceByPriceType");
	
	Binding.Insert("WorkOrder", 
		"StepItemListCalculateQuantityInBaseUnit,
		|StepItemListChangePriceByPriceType");
	
	Binding.Insert("WorkSheet", "StepItemListCalculateQuantityInBaseUnit");
	
	Binding.Insert("SalesInvoice", 
		"StepItemListCalculateQuantityInBaseUnit,
		|StepItemListChangePriceByPriceType");
	
	Binding.Insert("PurchaseOrder", 
		"StepItemListCalculateQuantityInBaseUnit,
		|StepItemListChangePriceByPriceType");
	
	Binding.Insert("PurchaseInvoice", 
		"StepItemListCalculateQuantityInBaseUnit,
		|StepItemListChangePriceByPriceType");
	
	Binding.Insert("SalesReportFromTradeAgent", 
		"StepItemListCalculateQuantityInBaseUnit,
		|StepItemListChangePriceByPriceType");
	
	Binding.Insert("SalesReportToConsignor", 
		"StepItemListCalculateQuantityInBaseUnit,
		|StepItemListChangePriceByPriceType");
	
	Binding.Insert("RetailSalesReceipt", 
		"StepItemListCalculateQuantityInBaseUnit,
		|StepItemListChangePriceByPriceType");
	
	Binding.Insert("SalesReturnOrder", 
		"StepItemListCalculateQuantityInBaseUnit,
		|StepItemListChangePriceByPriceType");
	
	Binding.Insert("SalesReturn", 
		"StepItemListCalculateQuantityInBaseUnit,
		|StepItemListChangePriceByPriceType");
	
	Binding.Insert("PurchaseReturnOrder", 
		"StepItemListCalculateQuantityInBaseUnit,
		|StepItemListChangePriceByPriceType");
	
	Binding.Insert("PurchaseReturn", 
		"StepItemListCalculateQuantityInBaseUnit,
		|StepItemListChangePriceByPriceType");
	
	Binding.Insert("RetailReturnReceipt", 
		"StepItemListCalculateQuantityInBaseUnit,
		|StepItemListChangePriceByPriceType");
	
	Binding.Insert("PhysicalInventory", "BindVoid");

	Binding.Insert("PhysicalCountByLocation", "BindVoid");
	
	Return BindSteps("StepItemListCalculateQuantityInBaseUnit", DataPath, Binding, Parameters, "BindItemListUnit");
EndFunction

// ItemList.Unit.ChangeUnitByItemKey.Step
Procedure StepItemListChangeUnitByItemKey(Parameters, Chain) Export
	Chain.ChangeUnitByItemKey.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeUnitByItemKey.Setter = "SetItemListUnit";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeUnitByItemKeyOptions();
		Options.ItemKey = GetItemListItemKey(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepItemListChangeUnitByItemKey";
		Chain.ChangeUnitByItemKey.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_LIST_DELIVERY_DATE

// ItemList.DeliveryDate.OnChange
Procedure ItemListDeliveryDateOnChange(Parameters) Export
	RollbackPropertyToValueBeforeChange_List(Parameters);
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
	Binding.Insert("SalesOrder"           , "StepItemListDefaultDeliveryDateInList");
	Binding.Insert("SalesInvoice"         , "StepItemListDefaultDeliveryDateInList");
	Binding.Insert("PurchaseOrder"        , "StepItemListDefaultDeliveryDateInList");
	Binding.Insert("PurchaseInvoice"      , "StepItemListDefaultDeliveryDateInList");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindDefaultItemListDeliveryDate");
EndFunction

// ItemList.DeliveryDate.Bind
Function BindItemListDeliveryDate(Parameters)
	DataPath = "ItemList.DeliveryDate";
	Binding = New Structure();
	Binding.Insert("SalesOrder"           , "StepChangeDeliveryDateInHeaderByDeliveryDateInList");
	Binding.Insert("SalesInvoice"         , "StepChangeDeliveryDateInHeaderByDeliveryDateInList");
	Binding.Insert("PurchaseOrder"        , "StepChangeDeliveryDateInHeaderByDeliveryDateInList");
	Binding.Insert("PurchaseInvoice"      , "StepChangeDeliveryDateInHeaderByDeliveryDateInList");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListDeliveryDate");
EndFunction

// ItemList.DeliveryDate.FillDeliveryDateInList.Step
Procedure StepItemListFillDeliveryDateInList(Parameters, Chain) Export
	Chain.FillDeliveryDateInList.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
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
	If Chain.Idle Then
		Return;
	EndIf;
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
	RollbackPropertyToValueBeforeChange_List(Parameters);
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
	
	Binding.Insert("RetailShipmentConfirmation", "StepItemListDefaultStoreInList_WithoutAgreement");
	Binding.Insert("RetailGoodsReceipt"        , "StepItemListDefaultStoreInList_WithoutAgreement");

	Binding.Insert("SalesOrder"           , "StepItemListDefaultStoreInList_AgreementInHeader");
	Binding.Insert("SalesInvoice"         , "StepItemListDefaultStoreInList_AgreementInHeader");
	Binding.Insert("RetailSalesReceipt"   , "StepItemListDefaultStoreInList_AgreementInHeader");
	Binding.Insert("PurchaseOrder"        , "StepItemListDefaultStoreInList_AgreementInHeader");
	Binding.Insert("PurchaseInvoice"      , "StepItemListDefaultStoreInList_AgreementInHeader");
	Binding.Insert("RetailReturnReceipt"  , "StepItemListDefaultStoreInList_AgreementInHeader");
	Binding.Insert("PurchaseReturnOrder"  , "StepItemListDefaultStoreInList_AgreementInHeader");
	Binding.Insert("PurchaseReturn"       , "StepItemListDefaultStoreInList_AgreementInHeader");
	Binding.Insert("SalesReturnOrder"     , "StepItemListDefaultStoreInList_AgreementInHeader");
	Binding.Insert("SalesReturn"          , "StepItemListDefaultStoreInList_AgreementInHeader");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindDefaultItemListStore");
EndFunction

// ItemList.Store.Bind
Function BindItemListStore(Parameters)
	DataPath = "ItemList.Store";
	Binding = New Structure();
	Binding.Insert("ShipmentConfirmation", "StepChangeStoreInHeaderByStoresInList");
	Binding.Insert("GoodsReceipt"        , "StepChangeStoreInHeaderByStoresInList");
	
	Binding.Insert("RetailShipmentConfirmation", "StepChangeStoreInHeaderByStoresInList");
	Binding.Insert("RetailGoodsReceipt"        , "StepChangeStoreInHeaderByStoresInList");

	Binding.Insert("SalesOrder",
		"StepChangeStoreInHeaderByStoresInList");

	Binding.Insert("SalesInvoice",
		"StepItemListChangeUseShipmentConfirmationByStore,
		|StepChangeStoreInHeaderByStoresInList,
		|StepConsignorBatchesFillBatches");

	Binding.Insert("PurchaseReturnOrder",
		"StepChangeStoreInHeaderByStoresInList");

	Binding.Insert("PurchaseReturn",
		"StepItemListChangeUseShipmentConfirmationByStore,
		|StepChangeStoreInHeaderByStoresInList");

	Binding.Insert("RetailSalesReceipt",
		"StepChangeStoreInHeaderByStoresInList,
		|StepConsignorBatchesFillBatches");
	
	Binding.Insert("RetailReturnReceipt",
		"StepChangeStoreInHeaderByStoresInList");
	
	Binding.Insert("PurchaseOrder",
		"StepChangeStoreInHeaderByStoresInList");
	
	Binding.Insert("PurchaseInvoice",
		"StepItemListChangeUseGoodsReceiptByStore,
		|StepChangeStoreInHeaderByStoresInList");
	
	Binding.Insert("SalesReturnOrder",
		"StepChangeStoreInHeaderByStoresInList");
	
	Binding.Insert("SalesReturn",
		"StepItemListChangeUseGoodsReceiptByStore,
		|StepChangeStoreInHeaderByStoresInList");
	
	Binding.Insert("SalesOrderClosing", "BindVoid");
	Binding.Insert("PurchaseOrderClosing", "BindVoid");
	
	Return BindSteps(Undefined, DataPath, Binding, Parameters, "BindItemListStore");
EndFunction

// ItemList.Store.FillStoresInList.Step
Procedure StepItemListFillStoresInList(Parameters, Chain) Export
	StepName = "StepItemListFillStoresInList";
	Chain.FillStoresInList.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.FillStoresInList.Setter = "SetItemListStore";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.FillStoresInListOptions();
		Options.Store        = GetStore(Parameters);
		Options.StoreInList  = GetItemListStore(Parameters, Row.Key);
		Options.IsUserChange = IsUserChange(Parameters, StepName);
		If CommonFunctionsClientServer.ObjectHasProperty(Row, "IsService") Then
			Options.IsService = GetItemListIsService(Parameters, Row.Key);
		Else
			Options.IsService = False;
		EndIf;
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
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.DefaultStoreInList.Setter = "SetItemListStore";
	Options = ModelClientServer_V2.DefaultStoreInListOptions();
	NewRow = Parameters.RowFilledByUserSettings;
	Options.StoreFromUserSettings = NewRow.Store;
	If AgreementInHeader Then
		Options.Agreement = GetAgreement(Parameters);
		Options.IsService = GetItemListIsService(Parameters, NewRow.Key);
	EndIf;
	Options.StoreInList   = GetItemListStore(Parameters, NewRow.Key);
	Options.StoreInHeader = GetStore(Parameters);
	ItemListCount = Parameters.Object.ItemList.Count();
	If ItemListCount > 1 Then
		PreviousRowKey = Parameters.Object.ItemList[ItemListCount - 2].Key;
		Options.StoreInPreviousRow = GetItemListStore(Parameters, PreviousRowKey);
	EndIf;
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
	If Chain.Idle Then
		Return;
	EndIf;
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
	If Chain.Idle Then
		Return;
	EndIf;
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

#Region ITEM_LIST_CANCEL

// ItemList.Cancel.OnChange
Procedure ItemListCancelOnChange(Parameters) Export
	AddViewNotify("OnSetItemListCancelNotify", Parameters);
	Binding = BindItemListCancel(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.Cancel.Set
Procedure SetItemListCancel(Parameters, Results) Export
	Binding = BindItemListCancel(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetItemListCancelNotify");
EndProcedure

// ItemList.Cancel.Bind
Function BindItemListCancel(Parameters)
	DataPath = "ItemList.Cancel";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListCancel");
EndFunction

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
	Return BindSteps("StepItemListChangePriceByPriceType", DataPath, Binding, Parameters, "BindItemListPriceType");
EndFunction

// ItemList.PriceType.ChangePriceTypeByAgreement.Step
Procedure StepItemListChangePriceTypeByAgreement(Parameters, Chain) Export
	Chain.ChangePriceTypeByAgreement.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangePriceTypeByAgreement.Setter = "SetItemListPriceType";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangePriceTypeByAgreementOptions();
		Options.Agreement = GetAgreement(Parameters);
		Options.CurrentPriceType = GetItemListPriceType(Parameters, Row.Key);
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
	StepName = "StepItemListChangePriceTypeAsManual";
	Chain.ChangePriceTypeAsManual.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangePriceTypeAsManual.Setter = "SetItemListPriceType";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangePriceTypeAsManualOptions();
		Options.CurrentPriceType = GetItemListPriceType(Parameters, Row.Key);
		If IsUserChange Then
			Options.IsUserChange = IsUserChange(Parameters, "StepItemListChangePriceTypeAsManual_IsUserChange");
		ElsIf IsTotalAmountChange Then
			Options.IsTotalAmountChange = True;
			Options.DontCalculateRow = GetItemListDontCalculateRow(Parameters, Row.Key);
		EndIf;
		Options.Key = Row.Key;
		Options.StepName = StepName;
		Chain.ChangePriceTypeAsManual.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_LIST_CONSIGNOR_PRICE

// ItemList.ConsignorPrice.OnChange
Procedure ItemListConsignorPriceOnChange(Parameters) Export
	Binding = BindItemListConsignorPrice(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.ConsignorPrice.Set
Procedure SetItemListConsignorPrice(Parameters, Results) Export
	Binding = BindItemListConsignorPrice(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.ConsignorPrice.Get
Function GetItemListConsignorPrice(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindItemListConsignorPrice(Parameters).DataPath, _Key);
EndFunction

// ItemList.ConsignorPrice.Bind
Function BindItemListConsignorPrice(Parameters)
	DataPath = "ItemList.ConsignorPrice";
	Binding = New Structure();
	Binding.Insert("SalesReportFromTradeAgent", 
		"StepItemListChangeTradeAgentFeeAmountByTradeAgentFeeType");
	
	Binding.Insert("SalesReportToConsignor",
		"StepItemListChangeTradeAgentFeeAmountByTradeAgentFeeType");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListConsignorPrice");
EndFunction

#EndRegion

#Region ITEM_LIST_TRADE_AGENT_FEE_PERCENT

// ItemList.TradeAgentFeePercent.OnChange
Procedure ItemListTradeAgentFeePercentOnChange(Parameters) Export
	Binding = BindItemListTradeAgentFeePercent(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.TradeAgentFeePercent.Set
Procedure SetItemListTradeAgentFeePercent(Parameters, Results) Export
	Binding = BindItemListTradeAgentFeePercent(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.TradeAgentFeePercent.Get
Function GetItemListTradeAgentFeePercent(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindItemListTradeAgentFeePercent(Parameters).DataPath, _Key);
EndFunction

// ItemList.TradeAgentFeePercent.Bind
Function BindItemListTradeAgentFeePercent(Parameters)
	DataPath = "ItemList.TradeAgentFeePercent";
	Binding = New Structure();
	Binding.Insert("SalesReportFromTradeAgent", 
		"StepItemListChangeTradeAgentFeeAmountByTradeAgentFeeType");
	
	Binding.Insert("SalesReportToConsignor",
		"StepItemListChangeTradeAgentFeeAmountByTradeAgentFeeType");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListTradeAgentFeePercent");
EndFunction

// ItemList.TradeAgentFeePercent.ChangeTradeAgentFeePercentByAgreement.Step
Procedure StepItemListChangeTradeAgentFeePercentByAgreement(Parameters, Chain) Export
	Chain.ChangeTradeAgentFeePercentByAgreement.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeTradeAgentFeePercentByAgreement.Setter = "SetItemListTradeAgentFeePercent";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeTradeAgentFeePercentByAgreementOptions();
		Options.Agreement      = GetAgreement(Parameters);
		Options.FeeType        = GetTradeAgentFeeType(Parameters);
		Options.CurrentPercent = GetItemListTradeAgentFeePercent(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepItemListChangeTradeAgentFeePercentByAgreement";
		Options.DontExecuteIfExecutedBefore = True;
		Chain.ChangeTradeAgentFeePercentByAgreement.Options.Add(Options);
	EndDo;
EndProcedure

// ItemList.TradeAgentFeePercent.ChangeTradeAgentFeePercentByAmount.Step
Procedure StepItemListChangeTradeAgentFeePercentByAmount(Parameters, Chain) Export
	Chain.ChangeTradeAgentFeePercentByAmount.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeTradeAgentFeePercentByAmount.Setter = "SetItemListTradeAgentFeePercent";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeTradeAgentFeePercentByAmountOptions();
		Options.FeeType     = GetTradeAgentFeeType(Parameters);
		Options.FeeAmount   = GetItemListTradeAgentFeeAmount(Parameters, Row.Key);
		Options.TotalAmount = GetItemListTotalAmount(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepItemListChangeTradeAgentFeePercentByAmount";
		Options.DontExecuteIfExecutedBefore = True;
		Chain.ChangeTradeAgentFeePercentByAmount.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_LIST_TRADE_AGENT_FEE_AMOUNT

// ItemList.TradeAgentFeeAmount.OnChange
Procedure ItemListTradeAgentFeeAmountOnChange(Parameters) Export
	Binding = BindItemListTradeAgentFeeAmount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.TradeAgentFeeAmount.Set
Procedure SetItemListTradeAgentFeeAmount(Parameters, Results) Export
	Binding = BindItemListTradeAgentFeeAmount(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.TradeAgentFeeAmount.Get
Function GetItemListTradeAgentFeeAmount(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindItemListTradeAgentFeeAmount(Parameters).DataPath, _Key);
EndFunction

// ItemList.TradeAgentFeeAmount.Bind
Function BindItemListTradeAgentFeeAmount(Parameters)
	DataPath = "ItemList.TradeAgentFeeAmount";
	Binding = New Structure();
		
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListTradeAgentFeeAmount");
EndFunction

// ItemList.TradeAgentFeeAmount.ChangeTradeAgentFeeAmountByTradeAgentFeeType.Step
Procedure StepItemListChangeTradeAgentFeeAmountByTradeAgentFeeType(Parameters, Chain) Export
	Chain.ChangeTradeAgentFeeAmountByTradeAgentFeeType.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeTradeAgentFeeAmountByTradeAgentFeeType.Setter = "SetItemListTradeAgentFeeAmount";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeTradeAgentFeeAmountByTradeAgentFeeTypeOptions();
		Options.FeeType        = GetTradeAgentFeeType(Parameters);
		Options.Price          = GetItemListPrice(Parameters, Row.Key);
		Options.ConsignorPrice = GetItemListConsignorPrice(Parameters, Row.Key);
		Options.Quantity       = GetItemListQuantity(Parameters, Row.Key);
		Options.Percent        = GetItemListTradeAgentFeePercent(Parameters, Row.Key);
		Options.TotalAmount    = GetItemListTotalAmount(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepItemListChangeTradeAgentFeeAmountByTradeAgentFeeType";
		Options.DontExecuteIfExecutedBefore = True;
		Chain.ChangeTradeAgentFeeAmountByTradeAgentFeeType.Options.Add(Options);
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
	If Parameters.StepEnableFlags.PriceChanged_AfterQuestionToUser Then
		Binding.Insert("SalesOrder"           , "StepItemListCalculations_IsPriceChanged");
		Binding.Insert("WorkOrder"            , "StepItemListCalculations_IsPriceChanged");
		Binding.Insert("SalesInvoice"         , "StepItemListCalculations_IsPriceChanged");
		Binding.Insert("RetailSalesReceipt"   , "StepItemListCalculations_IsPriceChanged");
		Binding.Insert("PurchaseOrder"        , "StepItemListCalculations_IsPriceChanged");
		Binding.Insert("PurchaseInvoice"      , "StepItemListCalculations_IsPriceChanged");
		Binding.Insert("RetailReturnReceipt"  , "StepItemListCalculations_IsPriceChanged");
		Binding.Insert("PurchaseReturnOrder"  , "StepItemListCalculations_IsPriceChanged");
		Binding.Insert("PurchaseReturn"       , "StepItemListCalculations_IsPriceChanged");
		Binding.Insert("SalesReturnOrder"     , "StepItemListCalculations_IsPriceChanged");
		Binding.Insert("SalesReturn"          , "StepItemListCalculations_IsPriceChanged");	
		
		Binding.Insert("SalesReportFromTradeAgent" , "StepItemListCalculations_IsPriceChanged_Without_SpecialOffers");	
		Binding.Insert("SalesReportToConsignor"    , "StepItemListCalculations_IsPriceChanged_Without_SpecialOffers");	
	Else
		Binding.Insert("SalesOrder",
			"StepItemListChangePriceTypeAsManual_IsUserChange,
			|StepItemListCalculations_IsPriceChanged");
	
		Binding.Insert("WorkOrder",
			"StepItemListChangePriceTypeAsManual_IsUserChange,
			|StepItemListCalculations_IsPriceChanged");
	
		Binding.Insert("SalesInvoice",
			"StepItemListChangePriceTypeAsManual_IsUserChange,
			|StepItemListCalculations_IsPriceChanged");

		Binding.Insert("RetailSalesReceipt",
			"StepItemListChangePriceTypeAsManual_IsUserChange,
			|StepItemListCalculations_IsPriceChanged");

		Binding.Insert("PurchaseOrder",
			"StepItemListChangePriceTypeAsManual_IsUserChange,
			|StepItemListCalculations_IsPriceChanged");
	
		Binding.Insert("PurchaseInvoice",
			"StepItemListChangePriceTypeAsManual_IsUserChange,
			|StepItemListCalculations_IsPriceChanged");
	
		Binding.Insert("SalesReportFromTradeAgent",
			"StepItemListChangePriceTypeAsManual_IsUserChange,
			|StepItemListCalculations_IsPriceChanged_Without_SpecialOffers");
	
		Binding.Insert("SalesReportToConsignor",
			"StepItemListChangePriceTypeAsManual_IsUserChange,
			|StepItemListCalculations_IsPriceChanged_Without_SpecialOffers");
	
		Binding.Insert("RetailReturnReceipt",
			"StepItemListChangePriceTypeAsManual_IsUserChange,
			|StepItemListCalculations_IsPriceChanged");
	
		Binding.Insert("PurchaseReturnOrder",
			"StepItemListChangePriceTypeAsManual_IsUserChange,
			|StepItemListCalculations_IsPriceChanged");
	
		Binding.Insert("PurchaseReturn",
			"StepItemListChangePriceTypeAsManual_IsUserChange,
			|StepItemListCalculations_IsPriceChanged");
	
		Binding.Insert("SalesReturnOrder",
			"StepItemListChangePriceTypeAsManual_IsUserChange,
			|StepItemListCalculations_IsPriceChanged");
	
		Binding.Insert("SalesReturn",
			"StepItemListChangePriceTypeAsManual_IsUserChange,
			|StepItemListCalculations_IsPriceChanged");
		
		Binding.Insert("StockAdjustmentAsSurplus", "StepItemListSimpleCalculations_IsPriceChanged");	
	EndIf;
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListPrice");
EndFunction

// ItemList.Price.ChangePriceByPriceType.Step
Procedure StepItemListChangePriceByPriceType(Parameters, Chain) Export
	Chain.ChangePriceByPriceType.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;

	Chain.ChangePriceByPriceType.Setter = "SetItemListPrice";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangePriceByPriceTypeOptions();
		Options.Ref          = Parameters.Object.Ref;
		Options.Date         = GetDate(Parameters);
		Options.CurrentPrice = GetItemListPrice(Parameters, Row.Key);
		Options.PriceType    = GetItemListPriceType(Parameters, Row.Key);
		Options.ItemKey      = GetItemListItemKey(Parameters, Row.Key);
		Options.Unit         = GetItemListUnit(Parameters, Row.Key);
		Options.Currency     = GetCurrency(Parameters);
		Options.RowIDInfo    = Row.RowIDInfo;
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
	
	Binding.Insert("SalesReportFromTradeAgent", "StepItemListCalculations_IsDontCalculateRowChanged_Without_SpecialOffers");
	Binding.Insert("SalesReportToConsignor"   , "StepItemListCalculations_IsDontCalculateRowChanged_Without_SpecialOffers");
	
	Return BindSteps("StepItemListCalculations_IsDontCalculateRowChanged", DataPath, Binding, Parameters, "BindItemListDontCalculateRow");
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
	Return GetPropertyObject(Parameters, BindItemListQuantity(Parameters).DataPath, _Key);
EndFunction

// ItemList.Quantity.Default.Bind
Function BindDefaultItemListQuantity(Parameters)
	DataPath = "ItemList.Quantity";
	Binding = New Structure();
	Return BindSteps("StepItemListDefaultQuantityInList", DataPath, Binding, Parameters, "BindDefaultItemListQuantity");
EndFunction

// ItemList.Quantity.Bind
Function BindItemListQuantity(Parameters)
	DataPath = "ItemList.Quantity";
	Binding = New Structure();	
	Binding.Insert("StockAdjustmentAsSurplus",
		"StepItemListSimpleCalculations_IsQuantityChanged,
		|StepItemListCalculateQuantityInBaseUnit");
	Return BindSteps("StepItemListCalculateQuantityInBaseUnit", DataPath, Binding, Parameters, "BindItemListQuantity");
EndFunction

// ItemList.Quantity.DefaultQuantityInList.Step
Procedure StepItemListDefaultQuantityInList(Parameters, Chain) Export
	Chain.DefaultQuantityInList.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.DefaultQuantityInList.Setter = "SetItemListQuantity";
	Options = ModelClientServer_V2.DefaultQuantityInListOptions();
	NewRow = Parameters.RowFilledByUserSettings;
	Options.CurrentQuantity = GetItemListQuantity(Parameters, NewRow.Key);
	Options.Key = NewRow.Key;
	Chain.DefaultQuantityInList.Options.Add(Options);
EndProcedure

#EndRegion

#Region ITEM_LIST_CONSIGNOR

// ItemList.Consignor.Set
Procedure SetItemListConsignor(Parameters, Results) Export
	Binding = BindItemListConsignor(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.Consignor.Get
Function GetItemListConsignor(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindItemListConsignor(Parameters).DataPath, _Key);
EndFunction

// ItemList.Consignor.Bind
Function BindItemListConsignor(Parameters)
	DataPath = "ItemList.Consignor";
	Binding = New Structure();
	
	Binding.Insert("SalesInvoice",
		"StepConsignorBatchesFillBatches");
		
	Binding.Insert("RetailSalesReceipt",
		"StepConsignorBatchesFillBatches");
	
	Binding.Insert("InventoryTransfer",
		"StepConsignorBatchesFillBatches_StoreSender");
		
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListConsignor");
EndFunction

#EndRegion

#Region ITEM_LIST_INVENTORY_ORIGIN

// ItemList.InventoryOrigin.OnChange
Procedure ItemListInventoryOriginOnChange(Parameters) Export
	Binding = BindItemListInventoryOrigin(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.InventoryOrigin.Set
Procedure SetItemListInventoryOrigin(Parameters, Results) Export
	Binding = BindItemListInventoryOrigin(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.InventoryOrigin.Get
Function GetItemListInventoryOrigin(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindItemListInventoryOrigin(Parameters).DataPath, _Key);
EndFunction

// ItemList.InventoryOrigin.Default.Bind
Function BindDefaultItemListInventoryOrigin(Parameters)
	DataPath = "ItemList.InventoryOrigin";
	Binding = New Structure();
	Return BindSteps("StepItemListDefaultInventoryOrigin", DataPath, Binding, Parameters, "BindDefaultItemListInventoryOrigin");
EndFunction

// ItemList.InventoryOrigin.Bind
Function BindItemListInventoryOrigin(Parameters)
	DataPath = "ItemList.InventoryOrigin";
	Binding = New Structure();
	
	Binding.Insert("SalesInvoice",
		"StepConsignorBatchesFillBatches");
		
	Binding.Insert("RetailSalesReceipt",
		"StepConsignorBatchesFillBatches");
	
	Binding.Insert("InventoryTransfer",
		"StepConsignorBatchesFillBatches_StoreSender");
		
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListInventoryOrigin");
EndFunction

// ItemList.DefaultInventoryOrigin.Step
Procedure StepItemListDefaultInventoryOrigin(Parameters, Chain) Export
	Chain.DefaultInventoryOrigin.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.DefaultInventoryOrigin.Setter = "SetItemListInventoryOrigin";
	Options = ModelClientServer_V2.DefaultInventoryOriginOptions();
	NewRow = Parameters.RowFilledByUserSettings;
	Options.CurrentInventoryOrigin = GetItemListInventoryOrigin(Parameters, NewRow.Key);
	Options.Key = NewRow.Key;
	Chain.DefaultInventoryOrigin.Options.Add(Options);
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
	Return GetPropertyObject(Parameters, BindItemListQuantityInBaseUnit(Parameters).DataPath, _Key);
EndFunction

// ItemList.QuantityInBaseUnit.Bind
Function BindItemListQuantityInBaseUnit(Parameters)
	DataPath = "ItemList.QuantityInBaseUnit";
	Binding = New Structure();
	Binding.Insert("SalesOrder",
		"StepItemListCalculations_IsQuantityInBaseUnitChanged");
	
	Binding.Insert("WorkOrder", 
		"StepItemListCalculations_IsQuantityInBaseUnitChanged,
		|StepMaterialsRecalculateQuantityWithKeyOwner");
	
	Binding.Insert("WorkSheet", 
		"StepMaterialsRecalculateQuantityWithKeyOwner");
		
	Binding.Insert("SalesInvoice",
		"StepItemListCalculations_IsQuantityInBaseUnitChanged,
		|StepConsignorBatchesFillBatches");
	
	Binding.Insert("InventoryTransfer", "StepConsignorBatchesFillBatches_StoreSender");
	
	Binding.Insert("RetailSalesReceipt",
		"StepItemListCalculations_IsQuantityInBaseUnitChanged,
		|StepConsignorBatchesFillBatches");
	
	Binding.Insert("PurchaseOrder",
		"StepItemListCalculations_IsQuantityInBaseUnitChanged");
	
	Binding.Insert("PurchaseInvoice",
		"StepItemListCalculations_IsQuantityInBaseUnitChanged");
	
	Binding.Insert("SalesReportFromTradeAgent",
		"StepItemListCalculations_IsQuantityInBaseUnitChanged_Without_SpecialOffers");
	
	Binding.Insert("SalesReportToConsignor",
		"StepItemListCalculations_IsQuantityInBaseUnitChanged_Without_SpecialOffers");
	
	Binding.Insert("RetailReturnReceipt",
		"StepItemListCalculations_IsQuantityInBaseUnitChanged");
	
	Binding.Insert("PurchaseReturnOrder",
		"StepItemListCalculations_IsQuantityInBaseUnitChanged");
	
	Binding.Insert("PurchaseReturn",
		"StepItemListCalculations_IsQuantityInBaseUnitChanged");
	
	Binding.Insert("SalesReturnOrder",
		"StepItemListCalculations_IsQuantityInBaseUnitChanged");
	
	Binding.Insert("SalesReturn",
		"StepItemListCalculations_IsQuantityInBaseUnitChanged");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListQuantityInBaseUnit");
EndFunction

// ItemList.QuantityInBaseUnit.CalculateQuantityInBaseUnit.Step
Procedure StepItemListCalculateQuantityInBaseUnit(Parameters, Chain) Export
	Chain.Calculations.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
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

#Region ITEM_LIST_PHYS_COUNT

// ItemList.PhysCount.OnChange
Procedure ItemListPhysCountOnChange(Parameters) Export
	AddViewNotify("OnSetItemListPhysCountNotify", Parameters);
	Binding = BindItemListPhysCount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.PhysCount.Set
Procedure SetItemListPhysCount(Parameters, Results) Export
	Binding = BindItemListPhysCount(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.PhysCount.Get
Function GetItemListPhysCount(Parameters, _Key)
	Binding = BindItemListPhysCount(Parameters);
	Return GetPropertyObject(Parameters, Binding.DataPath, _Key);
EndFunction

// ItemList.PhysCount.Bind
Function BindItemListPhysCount(Parameters)
	DataPath = "ItemList.PhysCount";
	Binding = New Structure();
	Binding.Insert("PhysicalInventory", "StepCalculateDifferenceCount");	
	Binding.Insert("PhysicalCountByLocation", "StepCalculateDifferenceCount");	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListPhysCount");
EndFunction

#EndRegion

#Region ITEM_LIST_MANUAL_FIXED_COUNT

// ItemList.ManualFixedCount.OnChange
Procedure ItemListManualFixedCountOnChange(Parameters) Export
	AddViewNotify("OnSetItemListPhysCountNotify", Parameters);
	Binding = BindItemListManualFixedCount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.ManualFixedCount.Set
Procedure SetItemListManualFixedCount(Parameters, Results) Export
	Binding = BindItemListManualFixedCount(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.ManualFixedCount.Get
Function GetItemListManualFixedCount(Parameters, _Key)
	Binding = BindItemListManualFixedCount(Parameters);
	Return GetPropertyObject(Parameters, Binding.DataPath, _Key);
EndFunction

// ItemList.ManualFixedCount.Bind
Function BindItemListManualFixedCount(Parameters)
	DataPath = "ItemList.ManualFixedCount";
	Binding = New Structure();
	Binding.Insert("PhysicalInventory", "StepCalculateDifferenceCount");	
	Binding.Insert("PhysicalCountByLocation", "StepCalculateDifferenceCount");	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListManualFixedCount");
EndFunction

#EndRegion

#Region ITEM_LIST_EXPECTED_COUNT

// ItemList.ExpCount.Set
Procedure SetItemListExpCount(Parameters, Results) Export
	Binding = BindItemListExpCount(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.ExpCount.Get
Function GetItemListExpCount(Parameters, _Key)
	Binding = BindItemListExpCount(Parameters);
	Return GetPropertyObject(Parameters, Binding.DataPath, _Key);
EndFunction

// ItemList.ExpCount.Bind
Function BindItemListExpCount(Parameters)
	DataPath = "ItemList.ExpCount";
	Binding = New Structure();
	Binding.Insert("PhysicalInventory", "StepCalculateDifferenceCount");	
	Binding.Insert("PhysicalCountByLocation", "StepCalculateDifferenceCount");	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListExpCount");
EndFunction

#EndRegion

#Region ITEM_LIST_DIFFERENCE

// ItemList.Difference.Set
Procedure SetItemListDifference(Parameters, Results) Export
	Binding = BindItemListDifference(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.Difference.Bind
Function BindItemListDifference(Parameters)
	DataPath = "ItemList.Difference";
	Binding = New Structure();	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListDifference");
EndFunction

// ItemList.Difference.CalculateDifferenceCount.Step
Procedure StepCalculateDifferenceCount(Parameters, Chain) Export
	Chain.CalculateDifferenceCount.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.CalculateDifferenceCount.Setter = "SetItemListDifference";
	For Each Row In GetRows(Parameters, "ItemList") Do
		Options     = ModelClientServer_V2.CalculateDifferenceCountOptions();
		Options.PhysCount = GetItemListPhysCount(Parameters, Row.Key);
		Options.ExpCount = GetItemListExpCount(Parameters, Row.Key);
		Options.ManualFixedCount = GetItemListManualFixedCount(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepCalculateDifferenceCount";
		Chain.CalculateDifferenceCount.Options.Add(Options);
	EndDo;	
EndProcedure

#EndRegion

#Region ITEM_LIST_BARCODE

// ItemList.Barcoder.Set
Procedure SetItemListBarcode(Parameters, Results) Export
	Binding = BindItemListBarcode(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.Barcode.Get
Function GetItemListBarcode(Parameters, _Key)
	Binding = BindItemListBarcode(Parameters);
	Return GetPropertyObject(Parameters, Binding.DataPath, _Key);
EndFunction

// ItemList.Barcode.Bind
Function BindItemListBarcode(Parameters)
	DataPath = "ItemList.Barcode";
	Binding = New Structure();	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListBarcode");
EndFunction

// ItemList.Barcode.ClearBarcodeByItemKey.Step
Procedure StepClearBarcodeByItemKey(Parameters, Chain) Export
	Chain.ClearBarcodeByItemKey.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ClearBarcodeByItemKey.Setter = "SetItemListBarcode";
	For Each Row In GetRows(Parameters, "ItemList") Do
		Options = ModelClientServer_V2.ClearBarcodeByItemKeyOptions();
		Options.ItemKeyIsChanged  = GetItemListItemKey_IsChanged(Parameters, Row.Key);
		Options.CurrentBarcode = GetItemListBarcode(Parameters, Row.Key);
		Options.Key      = Row.Key;
		Options.StepName = "StepBarcodeByItemKey";
		Chain.ClearBarcodeByItemKey.Options.Add(Options);
	EndDo;	
EndProcedure

#EndRegion

#Region ITEM_LIST_SERIAL_LOT_NUMBER

// ItemList.SerialLotNumber.Set
Procedure SetItemListSerialLotNumber(Parameters, Results) Export
	Binding = BindItemListSerialLotNumber(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.SerialLotNumber.Get
Function GetItemListSerialLotNumber(Parameters, _Key)
	Binding = BindItemListSerialLotNumber(Parameters);
	Return GetPropertyObject(Parameters, Binding.DataPath, _Key);
EndFunction

// ItemList.SerialLotNumber.Bind
Function BindItemListSerialLotNumber(Parameters)
	DataPath = "ItemList.SerialLotNumber";
	Binding = New Structure();	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListSerialLotNumber");
EndFunction

// ItemList.SeriaLotNumber.ClearSerialLotNumberByItemKey.Step
Procedure StepClearSerialLotNumberByItemKey(Parameters, Chain) Export
	Chain.ClearSerialLotNumberByItemKey.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ClearSerialLotNumberByItemKey.Setter = "SetItemListSerialLotNumber";
	For Each Row In GetRows(Parameters, "ItemList") Do
		Options = ModelClientServer_V2.ClearSerialLotNumberByItemKeyOptions();
		Options.ItemKeyIsChanged  = GetItemListItemKey_IsChanged(Parameters, Row.Key);
		Options.CurrentSerialLotNumber = GetItemListSerialLotNumber(Parameters, Row.Key);
		Options.Key      = Row.Key;
		Options.StepName = "StepClearSerialLotNumberByItemKey";
		Chain.ClearSerialLotNumberByItemKey.Options.Add(Options);
	EndDo;	
EndProcedure

#EndRegion

#Region ITEM_LIST_DATE

// ItemList.Date.Set
Procedure SetItemListDate(Parameters, Results) Export
	Binding = BindItemListDate(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.Date.Bind
Function BindItemListDate(Parameters)
	DataPath = "ItemList.Date";
	Binding = New Structure();	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListDate");
EndFunction

#EndRegion

#Region ITEM_LIST_IS_SERVICE

// ItemList.IsService.Set
Procedure SetItemListIsService(Parameters, Results) Export
	Binding = BindItemListIsService(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.IsService.Get
Function GetItemListIsService(Parameters, _Key)
	Binding = BindItemListIsService(Parameters);
	Return GetPropertyObject(Parameters, Binding.DataPath, _Key);
EndFunction

// ItemList.IsService.Bind
Function BindItemListIsService(Parameters)
	DataPath = "ItemList.IsService";
	Binding = New Structure();
	Binding.Insert("SalesOrder"           , "StepItemListFillStoresInList, 
											|StepItemListChangeProcurementMethodByItemKey");
	Binding.Insert("SalesInvoice"         , "StepItemListFillStoresInList");
	Binding.Insert("RetailSalesReceipt"   , "StepItemListFillStoresInList");
	Binding.Insert("PurchaseOrder"        , "StepItemListFillStoresInList");
	Binding.Insert("PurchaseInvoice"      , "StepItemListFillStoresInList");
	Binding.Insert("RetailReturnReceipt"  , "StepItemListFillStoresInList");
	Binding.Insert("PurchaseReturnOrder"  , "StepItemListFillStoresInList");
	Binding.Insert("PurchaseReturn"       , "StepItemListFillStoresInList");
	Binding.Insert("SalesReturnOrder"     , "StepItemListFillStoresInList");
	Binding.Insert("SalesReturn"          , "StepItemListFillStoresInList");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListIsService");
EndFunction

// ItemList.IsService.ChangeIsServiceByItemKey.Step
Procedure StepChangeIsServiceByItemKey(Parameters, Chain) Export
	Chain.ChangeIsServiceByItemKey.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeIsServiceByItemKey.Setter = "SetItemListIsService";
	For Each Row In GetRows(Parameters, "ItemList") Do
		Options = ModelClientServer_V2.ChangeIsServiceByItemKeyOptions();
		Options.ItemKey  = GetItemListItemKey(Parameters, Row.Key);
		Options.Key      = Row.Key;
		Options.StepName = "StepChangeIsServiceByItemKey";
		Chain.ChangeIsServiceByItemKey.Options.Add(Options);
	EndDo;	
EndProcedure

#EndRegion

#Region ITEM_LIST_USE_SERIAL_LOT_NUMBER

// ItemList.UseSerialLotNumber.Set
Procedure SetItemListUseSerialLotNumber(Parameters, Results) Export
	Binding = BindItemListUseSerialLotNumber(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.UseSerialLotNumber.Bind
Function BindItemListUseSerialLotNumber(Parameters)
	DataPath = "ItemList.UseSerialLotNumber";
	Binding = New Structure();	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListUseSerialLotNumber");
EndFunction

// ItemList.UseSerialLotNumber.ChangeUseSerialLotNumberByItemKey.Step
Procedure StepChangeUseSerialLotNumberByItemKey(Parameters, Chain) Export
	Chain.ChangeUseSerialLotNumberByItemKey.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeUseSerialLotNumberByItemKey.Setter = "SetItemListUseSerialLotNumber";
	For Each Row In GetRows(Parameters, "ItemList") Do
		Options = ModelClientServer_V2.ChangeUseSerialLotNumberByItemKeyOptions();
		Options.ItemKey  = GetItemListItemKey(Parameters, Row.Key);
		Options.Key      = Row.Key;
		Options.StepName = "StepChangeUseSerialLotNumberByItemKey";
		Chain.ChangeUseSerialLotNumberByItemKey.Options.Add(Options);
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
				Parameters, TaxRateResult, , , , ReadOnlyFromCache);
				
			For Each Row In Parameters.Rows Do
				If Row.Key = Result.Options.Key Then
					Row.TaxRates[TaxRate.Key] = TaxRate.Value;
				EndIf;
			EndDo;

			For Each Row In Parameters.RowsForRecalculate Do
				If Row.Key = Result.Options.Key Then
					Row.TaxRates[TaxRate.Key] = TaxRate.Value;
				EndIf;
			EndDo;

		EndDo;
	EndDo;
EndProcedure

// ItemList.TaxRate.Bind
Function BindItemListTaxRate(Parameters)
	DataPath = "ItemList.";
	Binding = New Structure();
	
	Binding.Insert("SalesReportFromTradeAgent", "StepItemListCalculations_IsTaxRateChanged_Without_SpecialOffers");
	Binding.Insert("SalesReportToConsignor"   , "StepItemListCalculations_IsTaxRateChanged_Without_SpecialOffers");
	
	Return BindSteps("StepItemListCalculations_IsTaxRateChanged", DataPath, Binding, Parameters, "BindItemListTaxRate");
EndFunction

#EndRegion

#Region ITEM_LIST_TAX_AMOUNT

// ItemList.TaxAmount.OnChange
Procedure ItemListTaxAmountOnChange(Parameters) Export
	AddViewNotify("OnSetItemListTaxAmountNotify", Parameters);
	Binding = BindItemListTaxAmount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.TaxAmount.Set
Procedure SetItemListTaxAmount(Parameters, Results) Export
	Binding = BindItemListTaxAmount(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetItemListTaxAmountNotify");
EndProcedure

// ItemList.TaxAmount.Get
Function GetItemListTaxAmount(Parameters, _Key)
	Return GetPropertyObject(Parameters, "ItemList.TaxAmount", _Key);
EndFunction

// ItemList.TaxAmount.Bind
Function BindItemListTaxAmount(Parameters)
	DataPath = "ItemList.TaxAmount";
	Binding = New Structure();
	Binding.Insert("SalesOrder", 
		"StepItemListCalculations_IsTaxAmountChanged,
		|StepItemListChangeTaxAmountAsManualAmount");
	
	Binding.Insert("WorkOrder", 
		"StepItemListCalculations_IsTaxAmountChanged,
		|StepItemListChangeTaxAmountAsManualAmount");
	
	Binding.Insert("SalesInvoice", 
		"StepItemListCalculations_IsTaxAmountChanged,
		|StepItemListChangeTaxAmountAsManualAmount");

	Binding.Insert("RetailSalesReceipt", 
		"StepItemListCalculations_IsTaxAmountChanged,
		|StepItemListChangeTaxAmountAsManualAmount");

	Binding.Insert("PurchaseOrder", 
		"StepItemListCalculations_IsTaxAmountChanged,
		|StepItemListChangeTaxAmountAsManualAmount");
	
	Binding.Insert("PurchaseInvoice", 
		"StepItemListCalculations_IsTaxAmountChanged,
		|StepItemListChangeTaxAmountAsManualAmount");
	
	Binding.Insert("SalesReportFromTradeAgent", 
		"StepItemListCalculations_IsTaxAmountChanged_Without_SpecialOffers,
		|StepItemListChangeTaxAmountAsManualAmount");
	
	Binding.Insert("SalesReportToConsignor", 
		"StepItemListCalculations_IsTaxAmountChanged_Without_SpecialOffers,
		|StepItemListChangeTaxAmountAsManualAmount");
	
	Binding.Insert("RetailReturnReceipt", 
		"StepItemListCalculations_IsTaxAmountChanged,
		|StepItemListChangeTaxAmountAsManualAmount");
	
	Binding.Insert("PurchaseReturnOrder", 
		"StepItemListCalculations_IsTaxAmountChanged,
		|StepItemListChangeTaxAmountAsManualAmount");
	
	Binding.Insert("PurchaseReturn", 
		"StepItemListCalculations_IsTaxAmountChanged,
		|StepItemListChangeTaxAmountAsManualAmount");
	
	Binding.Insert("SalesReturnOrder", 
		"StepItemListCalculations_IsTaxAmountChanged,
		|StepItemListChangeTaxAmountAsManualAmount");
	
	Binding.Insert("SalesReturn", 
		"StepItemListCalculations_IsTaxAmountChanged,
		|StepItemListChangeTaxAmountAsManualAmount");
		
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListTaxAmount");
EndFunction

// ItemList.TaxAmount.ChangeTaxAmountAsManualAmount.Step
Procedure StepItemListChangeTaxAmountAsManualAmount(Parameters, Chain) Export
	Chain.ChangeTaxAmountAsManualAmount.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
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

#Region ITEM_LIST_TAX_AMOUNT_USER_FORM

// ItemList.TaxAmountUserForm.OnChange
Procedure ItemListTaxAmountUserFormOnChange(Parameters) Export
	AddViewNotify("OnSetItemListTaxAmountNotify", Parameters);
	Binding = BindItemListTaxAmountUserForm(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.TaxAmountUserForm.Bind
Function BindItemListTaxAmountUserForm(Parameters)
	DataPath = "ItemList.TaxAmount";
	Binding = New Structure();
	Binding.Insert("SalesOrder"           , "StepItemListCalculations_IsTaxAmountUserFormChanged");
	Binding.Insert("SalesInvoice"         , "StepItemListCalculations_IsTaxAmountUserFormChanged");
	Binding.Insert("RetailSalesReceipt"   , "StepItemListCalculations_IsTaxAmountUserFormChanged");
	Binding.Insert("PurchaseOrder"        , "StepItemListCalculations_IsTaxAmountUserFormChanged");
	Binding.Insert("PurchaseInvoice"      , "StepItemListCalculations_IsTaxAmountUserFormChanged");
	Binding.Insert("RetailReturnReceipt"  , "StepItemListCalculations_IsTaxAmountUserFormChanged");
	Binding.Insert("PurchaseReturnOrder"  , "StepItemListCalculations_IsTaxAmountUserFormChanged");
	Binding.Insert("PurchaseReturn"       , "StepItemListCalculations_IsTaxAmountUserFormChanged");
	Binding.Insert("SalesReturnOrder"     , "StepItemListCalculations_IsTaxAmountUserFormChanged");
	Binding.Insert("SalesReturn"          , "StepItemListCalculations_IsTaxAmountUserFormChanged");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListTaxAmountUserForm");
EndFunction

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
EndFunction

// ItemList.OffersAmount.Bind
Function BindItemListOffersAmount(Parameters)
	DataPath = "ItemList.OffersAmount";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListOffersAmount");
EndFunction

#EndRegion

#Region ITEM_LIST_NET_AMOUNT

// ItemList.NetAmount.OnChange
Procedure ItemListNetAmountOnChange(Parameters) Export
	AddViewNotify("OnSetItemListNetAmountNotify", Parameters);
	Binding = BindItemListNetAmount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.NetAmount.Set
Procedure SetItemListNetAmount(Parameters, Results) Export
	Binding = BindItemListQuantity(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetItemListNetAmountNotify");
EndProcedure

// ItemList.NetAmount.Get
Function GetItemListNetAmount(Parameters, _Key)
	Return GetPropertyObject(Parameters, "ItemList.NetAmount" , _Key);
EndFunction

// ItemList.NetAmount.Bind
Function BindItemListNetAmount(Parameters)
	DataPath = "ItemList.NetAmount";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListNetAmount");
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
	Binding.Insert("SalesOrder",
		"StepItemListChangePriceTypeAsManual_IsTotalAmountChange,
		|StepItemListCalculations_IsTotalAmountChanged");
	
	Binding.Insert("WorkOrder",
		"StepItemListChangePriceTypeAsManual_IsTotalAmountChange,
		|StepItemListCalculations_IsTotalAmountChanged");
	
	Binding.Insert("SalesInvoice",
		"StepItemListChangePriceTypeAsManual_IsTotalAmountChange,
		|StepItemListCalculations_IsTotalAmountChanged");

	Binding.Insert("RetailSalesReceipt",
		"StepItemListChangePriceTypeAsManual_IsTotalAmountChange,
		|StepItemListCalculations_IsTotalAmountChanged");

	Binding.Insert("PurchaseOrder",
		"StepItemListChangePriceTypeAsManual_IsTotalAmountChange,
		|StepItemListCalculations_IsTotalAmountChanged");
	
	Binding.Insert("PurchaseInvoice",
		"StepItemListChangePriceTypeAsManual_IsTotalAmountChange,
		|StepItemListCalculations_IsTotalAmountChanged");
	
	Binding.Insert("SalesReportFromTradeAgent",
		"StepItemListChangePriceTypeAsManual_IsTotalAmountChange,
		|StepItemListCalculations_IsTotalAmountChanged_Without_SpecialOffers");
	
	Binding.Insert("SalesReportToConsignor",
		"StepItemListChangePriceTypeAsManual_IsTotalAmountChange,
		|StepItemListCalculations_IsTotalAmountChanged_Without_SpecialOffers");
	
	Binding.Insert("RetailReturnReceipt",
		"StepItemListChangePriceTypeAsManual_IsTotalAmountChange,
		|StepItemListCalculations_IsTotalAmountChanged");
	
	Binding.Insert("PurchaseReturnOrder",
		"StepItemListChangePriceTypeAsManual_IsTotalAmountChange,
		|StepItemListCalculations_IsTotalAmountChanged");
	
	Binding.Insert("PurchaseReturn",
		"StepItemListChangePriceTypeAsManual_IsTotalAmountChange,
		|StepItemListCalculations_IsTotalAmountChanged");
	
	Binding.Insert("SalesReturnOrder",
		"StepItemListChangePriceTypeAsManual_IsTotalAmountChange,
		|StepItemListCalculations_IsTotalAmountChanged");
	
	Binding.Insert("SalesReturn",
		"StepItemListChangePriceTypeAsManual_IsTotalAmountChange,
		|StepItemListCalculations_IsTotalAmountChanged");
		
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListTotalAmount");
EndFunction

#EndRegion

#Region ITEM_LIST_AMOUNT

// ItemList.Amount.OnChange
Procedure ItemListAmountOnChange(Parameters) Export
	Binding = BindItemListAmount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.Amount.Get
Function GetItemListAmount(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindItemListAmount(Parameters).DataPath , _Key);
EndFunction

// ItemList.Amount.Bind
Function BindItemListAmount(Parameters)
	DataPath = "ItemList.Amount";
	Binding = New Structure();
	Binding.Insert("StockAdjustmentAsSurplus",
		"StepItemListSimpleCalculations_IsAmountChanged");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListAmount");
EndFunction

#EndRegion

#Region ITEM_LIST_CALCULATIONS_NET_OFFERS_TAX_TOTAL

// ItemList.Calculations.Set
Procedure SetItemListCalculations(Parameters, Results) Export
	ViewNotify = "OnSetCalculationsNotify";
	NotifyAnyway = True;
	Binding = BindItemListCalculations(Parameters);
	SetterObject(Undefined, "ItemList.NetAmount"   , Parameters, Results, ViewNotify, "NetAmount"    , NotifyAnyway);
	SetterObject(Undefined, "ItemList.TaxAmount"   , Parameters, Results, ViewNotify, "TaxAmount"    , NotifyAnyway);
	SetterObject(Undefined, "ItemList.OffersAmount", Parameters, Results, ViewNotify, "OffersAmount" , NotifyAnyway);
	SetterObject(Undefined, "ItemList.Price"       , Parameters, Results, ViewNotify, "Price"        , NotifyAnyway);
	SetterObject(Binding.StepsEnabler, "ItemList.TotalAmount" , Parameters, Results, ViewNotify, "TotalAmount" , NotifyAnyway);
	SetTaxList(Parameters, Results);
	SetSpecialOffers(Parameters, Results);
EndProcedure

// ItemList.Calculations_Without_SpecialOffers.Set
Procedure SetItemListCalculations_Without_SpecialOffers(Parameters, Results) Export
	ViewNotify = "OnSetCalculationsNotify";
	NotifyAnyway = True;
	Binding = BindItemListCalculations(Parameters);
	SetterObject(Undefined, "ItemList.NetAmount"   , Parameters, Results, ViewNotify, "NetAmount"    , NotifyAnyway);
	SetterObject(Undefined, "ItemList.TaxAmount"   , Parameters, Results, ViewNotify, "TaxAmount"    , NotifyAnyway);
	SetterObject(Undefined, "ItemList.Price"       , Parameters, Results, ViewNotify, "Price"        , NotifyAnyway);
	SetterObject(Binding.StepsEnabler, "ItemList.TotalAmount" , Parameters, Results, ViewNotify, "TotalAmount" , NotifyAnyway);
	SetTaxList(Parameters, Results);
	SetSpecialOffers(Parameters, Results);
EndProcedure

// ItemList.Calculations.Bind
Function BindItemListCalculations(Parameters)
	DataPath = "";
	Binding = New Structure();
	Binding.Insert("SalesOrder",
		"StepUpdatePaymentTerms");
		
	Binding.Insert("SalesInvoice",
		"StepUpdatePaymentTerms");
		
	Binding.Insert("PurchaseOrder",
		"StepUpdatePaymentTerms");
		
	Binding.Insert("PurchaseInvoice",
		"StepUpdatePaymentTerms");
	
	Binding.Insert("SalesReportFromTradeAgent",
		"StepItemListChangeTradeAgentFeeAmountByTradeAgentFeeType");
	
	Binding.Insert("SalesReportToConsignor",
		"StepItemListChangeTradeAgentFeeAmountByTradeAgentFeeType");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListCalculations");
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

// ItemList.Calculations.[IsPriceIncludeTaxChanged].Step
Procedure StepItemListCalculations_IsPriceIncludeTaxChanged(Parameters, Chain) Export
	StepItemListCalculations(Parameters, Chain, "IsPriceIncludeTaxChanged");
EndProcedure

// ItemList.Calculations.[IsPriceIncludeTaxChanged_Without_SpecialOffers].Step
Procedure StepItemListCalculations_IsPriceIncludeTaxChanged_Without_SpecialOffers(Parameters, Chain) Export
	StepItemListCalculations_Without_SpecialOffers(Parameters, Chain, "IsPriceIncludeTaxChanged");
EndProcedure

// ItemList.Calculations.[IsOffersChanged].Step
Procedure StepItemListCalculations_IsOffersChanged(Parameters, Chain) Export
	StepItemListCalculations(Parameters, Chain, "IsOffersChanged");
EndProcedure

// ItemList.Calculations.[IsPriceChanged].Step
Procedure StepItemListCalculations_IsPriceChanged(Parameters, Chain) Export
	StepItemListCalculations(Parameters, Chain, "IsPriceChanged");
EndProcedure

// ItemList.Calculations.[IsPriceChanged_Without_SpecialsOffers].Step
Procedure StepItemListCalculations_IsPriceChanged_Without_SpecialOffers(Parameters, Chain) Export
	StepItemListCalculations_Without_SpecialOffers(Parameters, Chain, "IsPriceChanged");
EndProcedure

// ItemList.Calculations.[IsTotalAmountChanged].Step
Procedure StepItemListCalculations_IsTotalAmountChanged(Parameters, Chain) Export
	StepItemListCalculations(Parameters, Chain, "IsTotalAmountChanged");
EndProcedure

// ItemList.Calculations.[IsTotalAmountChanged_Without_SpecialOffers].Step
Procedure StepItemListCalculations_IsTotalAmountChanged_Without_SpecialOffers(Parameters, Chain) Export
	StepItemListCalculations_Without_SpecialOffers(Parameters, Chain, "IsTotalAmountChanged");
EndProcedure

// ItemList.Calculations.[IsDontCalculateRowChanged].Step
Procedure StepItemListCalculations_IsDontCalculateRowChanged(Parameters, Chain) Export
	StepItemListCalculations(Parameters, Chain, "IsDontCalculateRowChanged");
EndProcedure

// ItemList.Calculations.[IsDontCalculateRowChanged_Without_SpecialOffers].Step
Procedure StepItemListCalculations_IsDontCalculateRowChanged_Without_SpecialOffers(Parameters, Chain) Export
	StepItemListCalculations_Without_SpecialOffers(Parameters, Chain, "IsDontCalculateRowChanged");
EndProcedure

// ItemList.Calculations.[IsQuantityInBaseUnitChanged].Step
Procedure StepItemListCalculations_IsQuantityInBaseUnitChanged(Parameters, Chain) Export
	StepItemListCalculations(Parameters, Chain, "IsQuantityInBaseUnitChanged");
EndProcedure

// ItemList.Calculations.[IsQuantityInBaseUnitChanged_Without_SpecialOffers].Step
Procedure StepItemListCalculations_IsQuantityInBaseUnitChanged_Without_SpecialOffers(Parameters, Chain) Export
	StepItemListCalculations_Without_SpecialOffers(Parameters, Chain, "IsQuantityInBaseUnitChanged");
EndProcedure

// ItemList.Calculations.[IsRecalculationWhenBasedOn_Without_SpecialOffers].Step
Procedure StepItemListCalculations_IsRecalculationWhenBasedOn_Without_SpecialOffers(Parameters, Chain) Export
	StepItemListCalculations_Without_SpecialOffers(Parameters, Chain, "IsRecalculationWhenBasedOn");
EndProcedure

// ItemList.Calculations.[IsTaxRateChanged].Step
Procedure StepItemListCalculations_IsTaxRateChanged(Parameters, Chain) Export
	StepItemListCalculations(Parameters, Chain, "IsTaxRateChanged");
EndProcedure

// ItemList.Calculations.[IsTaxRateChanged_Without_SpecialOffers].Step
Procedure StepItemListCalculations_IsTaxRateChanged_Without_SpecialOffers(Parameters, Chain) Export
	StepItemListCalculations_Without_SpecialOffers(Parameters, Chain, "IsTaxRateChanged");
EndProcedure

// ItemList.Calculations.[IsTaxAmountChanged].Step
Procedure StepItemListCalculations_IsTaxAmountChanged(Parameters, Chain) Export
	StepItemListCalculations(Parameters, Chain, "IsTaxAmountChanged");
EndProcedure

// ItemList.Calculations.[IsTaxAmountChanged_Without_SpecialOffers].Step
Procedure StepItemListCalculations_IsTaxAmountChanged_Without_SpecialOffers(Parameters, Chain) Export
	StepItemListCalculations_Without_SpecialOffers(Parameters, Chain, "IsTaxAmountChanged");
EndProcedure

// ItemList.Calculations.[IsTaxAmountUserFormChanged].Step
Procedure StepItemListCalculations_IsTaxAmountUserFormChanged(Parameters, Chain) Export
	StepItemListCalculations(Parameters, Chain, "IsTaxAmountUserFormChanged");
EndProcedure

// ItemList.Calculations.[IsRecalculationWhenBasedOn].Step
Procedure StepItemListCalculations_IsRecalculationWhenBasedOn(Parameters, Chain) Export
	StepItemListCalculations(Parameters, Chain, "IsRecalculationWhenBasedOn");
EndProcedure

Procedure StepItemListCalculations(Parameters, Chain, WhoIsChanged)
	Chain.Calculations.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.Calculations.Setter = "SetItemListCalculations";
	
	PriceIncludeTax = GetPriceIncludeTax(Parameters);
	
	TableRows = GetRows(Parameters, Parameters.TableName);
	
	If Parameters.UseRowsForRecalculate Then
		// Calculations when changed consignor batches
		TableRows = Parameters.RowsForRecalculate;
	Else
		TableRows = GetRows(Parameters, Parameters.TableName);
	EndIf;
	
	For Each Row In TableRows Do
		Options     = ModelClientServer_V2.CalculationsOptions();
		Options.Ref = Parameters.Object.Ref;
		Options.ItemKey = GetItemListItemKey(Parameters, Row.Key);
		Options.Unit    = GetItemListUnit(Parameters, Row.Key);
		
		// need recalculate NetAmount, TotalAmount, TaxAmount, OffersAmount
		If     WhoIsChanged = "IsPriceChanged"            Or WhoIsChanged = "IsPriceIncludeTaxChanged"
			Or WhoIsChanged = "IsDontCalculateRowChanged" Or WhoIsChanged = "IsQuantityInBaseUnitChanged" 
			Or WhoIsChanged = "IsTaxRateChanged"          Or WhoIsChanged = "IsOffersChanged"
			Or WhoIsChanged = "IsCopyRow"                 Or WhoIsChanged = "IsTaxAmountUserFormChanged"
			Or WhoIsChanged = "RecalculationsOnCopy"      Or WhoIsChanged = "IsRecalculationWhenBasedOn" Then
			Options.CalculateNetAmount.Enable       = True;
			Options.CalculateTotalAmount.Enable     = True;
			Options.CalculateTaxAmount.Enable       = True;
			Options.CalculateSpecialOffers.Enable   = True;
			Options.RecalculateSpecialOffers.Enable = True;
		ElsIf WhoIsChanged = "IsTotalAmountChanged" Then
		// when TotalAmount is changed taxes need recalculate reverse, will be changed NetAmount and Price
			
			If PriceIncludeTax Then
				Options.CalculateTaxAmount.Enable     = True;
				Options.CalculateNetAmount.Enable     = True;
			Else
				Options.CalculateTaxAmountReverse.Enable   = True;
				Options.CalculateNetAmountAsTotalAmountMinusTaxAmount.Enable   = True;
			EndIf;
			
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
		
		Options.PriceOptions.Price             = GetItemListPrice(Parameters, Row.Key);
		
		If WhoIsChanged = "IsPriceChanged" And IsUserChange(Parameters, "StepItemListCalculations_IsPriceChanged") Then
			Options.PriceOptions.PriceType = PredefinedValue("Catalog.PriceTypes.ManualPriceType");
		Else
			Options.PriceOptions.PriceType = GetItemListPriceType(Parameters, Row.Key);
		EndIf;
		
		Options.PriceOptions.Quantity           = GetItemListQuantity(Parameters, Row.Key);
		Options.PriceOptions.QuantityInBaseUnit = GetItemListQuantityInBaseUnit(Parameters, Row.Key);
		
		Options.TaxOptions.PriceIncludeTax  = PriceIncludeTax;
		Options.TaxOptions.ArrayOfTaxInfo   = Parameters.ArrayOfTaxInfo;
		Options.TaxOptions.TaxRates         = GetTaxRate(Parameters, Row);
		Options.TaxOptions.TaxList          = Row.TaxList;
		Options.TaxOptions.IsAlreadyCalculated = Row.TaxIsAlreadyCalculated;
			
		Options.OffersOptions.SpecialOffers      = Row.SpecialOffers;
		Options.OffersOptions.SpecialOffersCache = Row.SpecialOffersCache;

		Options.RowIDInfo = Row.RowIdInfo;
		
		Options.Key = Row.Key;
		Options.StepName = "StepItemListCalculations";
		Chain.Calculations.Options.Add(Options);
	EndDo;
EndProcedure

Procedure StepItemListCalculations_Without_SpecialOffers(Parameters, Chain, WhoIsChanged)
	Chain.Calculations.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.Calculations.Setter = "SetItemListCalculations_Without_SpecialOffers";
	
	PriceIncludeTax = GetPriceIncludeTax(Parameters);
	
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		
		Options     = ModelClientServer_V2.CalculationsOptions();
		Options.Ref = Parameters.Object.Ref;
		
		// need recalculate NetAmount, TotalAmount, TaxAmount, OffersAmount
		If     WhoIsChanged = "IsPriceChanged"            Or WhoIsChanged = "IsPriceIncludeTaxChanged"
			Or WhoIsChanged = "IsDontCalculateRowChanged" Or WhoIsChanged = "IsQuantityInBaseUnitChanged" 
			Or WhoIsChanged = "IsTaxRateChanged"
			Or WhoIsChanged = "IsCopyRow"                 Or WhoIsChanged = "IsTaxAmountUserFormChanged"
			Or WhoIsChanged = "RecalculationsOnCopy"      Or WhoIsChanged = "IsRecalculationWhenBasedOn" Then
			Options.CalculateNetAmount.Enable     = True;
			Options.CalculateTotalAmount.Enable   = True;
			Options.CalculateTaxAmount.Enable     = True;
		ElsIf WhoIsChanged = "IsTotalAmountChanged" Then
		// when TotalAmount is changed taxes need recalculate reverse, will be changed NetAmount and Price
			
			If PriceIncludeTax Then
				Options.CalculateTaxAmount.Enable     = True;
				Options.CalculateNetAmount.Enable     = True;
			Else
				Options.CalculateTaxAmountReverse.Enable   = True;
				Options.CalculateNetAmountAsTotalAmountMinusTaxAmount.Enable   = True;
			EndIf;
			
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
		Options.AmountOptions.TaxAmount        = GetItemListTaxAmount(Parameters, Row.Key);
		Options.AmountOptions.TotalAmount      = GetItemListTotalAmount(Parameters, Row.Key);
		
		Options.PriceOptions.Price             = GetItemListPrice(Parameters, Row.Key);
		
		If WhoIsChanged = "IsPriceChanged" And IsUserChange(Parameters, "StepItemListCalculations_IsPriceChanged_Without_SpecialOffers") Then
			Options.PriceOptions.PriceType = PredefinedValue("Catalog.PriceTypes.ManualPriceType");
		Else
			Options.PriceOptions.PriceType = GetItemListPriceType(Parameters, Row.Key);
		EndIf;
		
		Options.PriceOptions.Quantity           = GetItemListQuantity(Parameters, Row.Key);
		Options.PriceOptions.QuantityInBaseUnit = GetItemListQuantityInBaseUnit(Parameters, Row.Key);
		
		Options.TaxOptions.PriceIncludeTax  = PriceIncludeTax;
		Options.TaxOptions.ArrayOfTaxInfo   = Parameters.ArrayOfTaxInfo;
		Options.TaxOptions.TaxRates         = GetTaxRate(Parameters, Row);
		Options.TaxOptions.TaxList          = Row.TaxList;
		Options.TaxOptions.IsAlreadyCalculated = Row.TaxIsAlreadyCalculated;
		
		Options.Key = Row.Key;
		Options.StepName = "StepItemListCalculations";
		Chain.Calculations.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_LIST_SIMPLE_CALCULATIONS

// ItemList.SimpleCalculations.Set
Procedure SetItemListSimpleCalculations(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Price" , BindItemListPrice(Parameters));
	ResourceToBinding.Insert("Amount", BindItemListAmount(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

// ItemList.SimpleCalculations.[IsPriceChanged].Step
Procedure StepItemListSimpleCalculations_IsPriceChanged(Parameters, Chain) Export
	StepItemListSimpleCalculations(Parameters, Chain, "IsPriceChanged");
EndProcedure

// ItemList.SimpleCalculations.[IsAmountChanged].Step
Procedure StepItemListSimpleCalculations_IsAmountChanged(Parameters, Chain) Export
	StepItemListSimpleCalculations(Parameters, Chain, "IsAmountChanged");
EndProcedure

// ItemList.SimpleCalculations.[IsQuantityChanged].Step
Procedure StepItemListSimpleCalculations_IsQuantityChanged(Parameters, Chain) Export
	StepItemListSimpleCalculations(Parameters, Chain, "IsQuantityChanged");
EndProcedure

Procedure StepItemListSimpleCalculations(Parameters, Chain, WhoIsChanged)
	Chain.SimpleCalculations.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.SimpleCalculations.Setter = "SetItemListSimpleCalculations";
	
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options     = ModelClientServer_V2.SimpleCalculationsOptions();
		Options.Ref = Parameters.Object.Ref;
		Options.Key = Row.Key;
		Options.DontExecuteIfExecutedBefore = True;
		
		If WhoIsChanged = "IsPriceChanged" Or WhoIsChanged = "IsQuantityChanged" Then
			Options.CalculateAmount.Enable = True;
		ElsIf WhoIsChanged = "IsAmountChanged" Then
			Options.CalculatePrice.Enable = True;
		Else
			Raise StrTemplate("Unsupported [WhoIsChanged] = %1", WhoIsChanged);
		EndIf;
		
		Options.Amount   = GetItemListAmount(Parameters, Row.Key);
		Options.Price    = GetItemListPrice(Parameters, Row.Key);
		Options.Quantity = GetItemListQuantity(Parameters, Row.Key);
		Options.StepName = "StepItemListSimpleCalculations";
		Chain.SimpleCalculations.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region REVENUE_TYPE

// ItemList.RevenueType.Set
Procedure SetItemListRevenueType(Parameters, Results) Export
	Binding = BindItemListRevenueType(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.RevenueType.Bind
Function BindItemListRevenueType(Parameters)
	DataPath = "ItemList.RevenueType";
	Binding = New Structure();	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListRevenueType");
EndFunction

// ItemList.RevenueType.ChangeRevenueTypeByItemKey.Step
Procedure StepItemListChangeRevenueTypeByItemKey(Parameters, Chain) Export
	Chain.ChangeRevenueTypeByItemKey.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeRevenueTypeByItemKey.Setter = "SetItemListRevenueType";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeRevenueTypeByItemKeyOptions();
		Options.Company = GetCompany(Parameters);
		Options.ItemKey = GetItemListItemKey(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepItemListChangeRevenueTypeByItemKey";
		Chain.ChangeRevenueTypeByItemKey.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region EXPENSE_TYPE

// ItemList.ExpenseType.Set
Procedure SetItemListExpenseType(Parameters, Results) Export
	Binding = BindItemListExpenseType(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.ExpenseType.Bind
Function BindItemListExpenseType(Parameters)
	DataPath = "ItemList.ExpenseType";
	Binding = New Structure();	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListExpenseType");
EndFunction

// ItemList.ExpenseType.ChangeExpenseTypeByItemKey.Step
Procedure StepItemListChangeExpenseTypeByItemKey(Parameters, Chain) Export
	Chain.ChangeExpenseTypeByItemKey.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeExpenseTypeByItemKey.Setter = "SetItemListExpenseType";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeExpenseTypeByItemKeyOptions();
		Options.Company = GetCompany(Parameters);
		Options.ItemKey = GetItemListItemKey(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepItemListChangeExpenseTypeByItemKey";
		Chain.ChangeExpenseTypeByItemKey.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_LIST_LOAD_DATA

// ItemList.Load
Procedure ItemListLoad(Parameters) Export
	Binding = BindItemListLoad(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ItemList.Load.Set
#If Server Then
	
Procedure ServerTableLoaderItemList(Parameters, Results) Export
	Binding = BindItemListLoad(Parameters);
	LoaderTable(Binding.DataPath, Parameters, Results);
EndProcedure

#EndIf

// ItemList.Load.Bind
Function BindItemListLoad(Parameters)
	DataPath = "ItemList";
	Binding = New Structure();
	Return BindSteps("StepItemListLoadTable", DataPath, Binding, Parameters, "BindItemListLoad");
EndFunction

// ItemList.LoadAtServer.Step
Procedure StepItemListLoadTable(Parameters, Chain) Export
	Chain.LoadTable.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.LoadTable.Setter = "ServerTableLoaderItemList";
	Options = ModelClientServer_V2.LoadTableOptions();
	Options.TableAddress = Parameters.LoadData.Address;
	Chain.LoadTable.Options.Add(Options);
EndProcedure

#EndRegion

#Region ITEM_LIST_IS_CONTROL_CODE_STRING

// ItemList.isControlCodeString.Set
Procedure SetItemListisControlCodeString(Parameters, Results) Export
	Binding = BindItemListisControlCodeString(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ItemList.isControlCodeString.Get
Function GetItemListisControlCodeString(Parameters, _Key)
	Binding = BindItemListisControlCodeString(Parameters);
	Return GetPropertyObject(Parameters, Binding.DataPath, _Key);
EndFunction

// ItemList.isControlCodeString.Bind
Function BindItemListisControlCodeString(Parameters)
	DataPath = "ItemList.isControlCodeString";
	Binding = New Structure();
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindItemListisControlCodeString");
EndFunction

// ItemList.isControlCode.ChangeisControlCodeStringByItem.Step
Procedure StepChangeisControlCodeStringByItem(Parameters, Chain) Export
	Chain.ChangeisControlCodeStringByItem.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeisControlCodeStringByItem.Setter = "SetItemListisControlCodeString";
	For Each Row In GetRows(Parameters, "ItemList") Do
		Options = ModelClientServer_V2.ChangeisControlCodeStringByItemOptions();
		Options.Item	 = GetItemListItem(Parameters, Row.Key);
		Options.Key      = Row.Key;
		Options.StepName = "StepChangeisControlCodeStringByItem";
		Chain.ChangeisControlCodeStringByItem.Options.Add(Options);
	EndDo;	
EndProcedure

#EndRegion

#EndRegion

#Region PAYMENTS

#Region PAYMENTS_PAYMENT_TYPE

// Payments.PaymentType.OnChange
Procedure PaymentsPaymentTypeOnChange(Parameters) Export
	Binding = BindPaymentsPaymentType(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Payments.PaymentType.Set
Procedure SetPaymentsPaymentType(Parameters, Results) Export
	Binding = BindPaymentsPaymentType(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Payments.PaymentType.Get
Function GetPaymentsPaymentType(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentsPaymentType(Parameters).DataPath, _Key);
EndFunction

// Payments.PaymentType.Bind
Function BindPaymentsPaymentType(Parameters)
	DataPath = "Payments.PaymentType";
	Binding = New Structure();

	Binding.Insert("RetailSalesReceipt", 
		"StepPaymentsGetPercent");
	
	Binding.Insert("RetailReturnReceipt", 
		"StepPaymentsGetPercent");
	
	Binding.Insert("SalesOrder", 
		"StepPaymentsGetPercent");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentsPaymentType");
EndFunction

#EndRegion

#Region PAYMENTS_BANK_TERM

// Payments.BankTerm.OnChange
Procedure PaymentsBankTermOnChange(Parameters) Export
	Binding = BindPaymentsBankTerm(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Payments.BankTerm.Set
Procedure SetPaymentsBankTerm(Parameters, Results) Export
	Binding = BindPaymentsBankTerm(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Payments.BankTerm.Get
Function GetPaymentsBankTerm(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentsBankTerm(Parameters).DataPath, _Key);
EndFunction

// Payments.BankTerm.Bind
Function BindPaymentsBankTerm(Parameters)
	DataPath = "Payments.BankTerm";
	Binding = New Structure();

	Binding.Insert("RetailSalesReceipt", 
		"StepPaymentsGetPercent");
	
	Binding.Insert("RetailReturnReceipt", 
		"StepPaymentsGetPercent");
	
	Binding.Insert("SalesOrder", 
		"StepPaymentsGetPercent");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentsBankTerm");
EndFunction

#EndRegion

#Region PAYMENTS_ACCOUNT

// Payments.Account.OnChange
Procedure PaymentsAccountOnChange(Parameters) Export
	Binding = BindPaymentsAccount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Payments.Account.Set
Procedure SetPaymentsAccount(Parameters, Results) Export
	Binding = BindPaymentsAccount(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Payments.Account.Bind
Function BindPaymentsAccount(Parameters)
	DataPath = "Payments.Account";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentsAccount");
EndFunction

#EndRegion

#Region PAYMENTS_AMOUNT

// Payments.Amount.OnChange
Procedure PaymentsAmountOnChange(Parameters) Export
	Binding = BindPaymentsAmount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Payments.Amount.Set
Procedure SetPaymentsAmount(Parameters, Results) Export
	Binding = BindPaymentsAmount(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Payments.Amount.Get
Function GetPaymentsAmount(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentsAmount(Parameters).DataPath, _Key);
EndFunction

// Payments.Amount.Bind
Function BindPaymentsAmount(Parameters)
	DataPath = "Payments.Amount";
	Binding = New Structure();

	Binding.Insert("RetailSalesReceipt", 
		"StepPaymentsCalculateCommission");
	
	Binding.Insert("RetailReturnReceipt", 
		"StepPaymentsCalculateCommission");
		
	Binding.Insert("SalesOrder", 
		"StepPaymentsCalculateCommission");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentsAmount");
EndFunction

#EndRegion

#Region PAYMENTS_COMMISSION

// Payments.Commission.OnChange
Procedure PaymentsCommissionOnChange(Parameters) Export
	Binding = BindPaymentsCommission(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Payments.Commission.Set
Procedure SetPaymentsCommission(Parameters, Results) Export
	Binding = BindPaymentsCommission(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Payments.Commission.Get
Function GetPaymentsCommission(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentsCommission(Parameters).DataPath, _Key);
EndFunction

// Payments.Commission.Bind
Function BindPaymentsCommission(Parameters)
	DataPath = "Payments.Commission";
	Binding = New Structure();

	Binding.Insert("RetailSalesReceipt", 
		"StepChangePercentByAmount");
	
	Binding.Insert("RetailReturnReceipt", 
		"StepChangePercentByAmount");
		
	Binding.Insert("SalesOrder", 
		"StepChangePercentByAmount");
		
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentsCommission");
EndFunction

// Payments.Commission.CalculateCommission.Step
Procedure StepPaymentsCalculateCommission(Parameters, Chain) Export
	Chain.CalculateCommission.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.CalculateCommission.Setter = "SetPaymentsCommission";
	For Each Row In GetRows(Parameters, "Payments") Do
		Options     = ModelClientServer_V2.CalculateCommissionOptions();
		Options.Amount = GetPaymentsAmount(Parameters, Row.Key);
		Options.Percent = GetPaymentsPercent(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepPaymentsCalculateCommission";
		Chain.CalculateCommission.Options.Add(Options);
	EndDo;	
EndProcedure

#EndRegion

#Region PAYMENTS_PERCENT

// Payments.Percent.OnChange
Procedure PaymentsPercentOnChange(Parameters) Export
	Binding = BindPaymentsPercent(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Payments.Percent.Set
Procedure SetPaymentsPercent(Parameters, Results) Export
	Binding = BindPaymentsPercent(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Payments.Percent.Get
Function GetPaymentsPercent(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPaymentsPercent(Parameters).DataPath, _Key);
EndFunction

// Payments.Percent.Bind
Function BindPaymentsPercent(Parameters)
	DataPath = "Payments.Percent";
	Binding = New Structure();

	Binding.Insert("RetailSalesReceipt", 
		"StepPaymentsCalculateCommission");
	
	Binding.Insert("RetailReturnReceipt", 
		"StepPaymentsCalculateCommission");
		
	Binding.Insert("SalesOrder", 
		"StepPaymentsCalculateCommission");
	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPaymentsPercent");
EndFunction

// Payments.Percent.GetPercent.Step
Procedure StepPaymentsGetPercent(Parameters, Chain) Export
	Chain.GetCommissionPercent.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.GetCommissionPercent.Setter = "SetPaymentsPercent";
	For Each Row In GetRows(Parameters, "Payments") Do
		Options     = ModelClientServer_V2.GetCommissionPercentOptions();
		Options.PaymentType = GetPaymentsPaymentType(Parameters, Row.Key);
		Options.BankTerm = GetPaymentsBankTerm(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepPaymentsGetPercent";
		Chain.GetCommissionPercent.Options.Add(Options);
	EndDo;	
EndProcedure

// Payments.Percent.ChangePercentByAmount.Step
Procedure StepChangePercentByAmount(Parameters, Chain) Export
	Chain.ChangePercentByAmount.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangePercentByAmount.Setter = "SetPaymentsPercent";
	For Each Row In GetRows(Parameters, "Payments") Do
		Options     = ModelClientServer_V2.CalculatePercentByAmountOptions();
		Options.Commission = GetPaymentsCommission(Parameters, Row.Key);
		Options.Amount = GetPaymentsAmount(Parameters, Row.Key);
		Options.DisableNextSteps = True;
		Options.Key = Row.Key;
		Options.StepName = "StepChangePercentByAmount";
		Chain.ChangePercentByAmount.Options.Add(Options);
	EndDo;	
EndProcedure

#EndRegion

#EndRegion

#Region INVENTORY

#Region INVENTORY_ITEM

// Inventory.Item.OnChange
Procedure InventoryItemOnChange(Parameters) Export
	Binding = BindInventoryItem(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Inventory.Item.Set
Procedure SetInventoryItem(Parameters, Results) Export
	Binding = BindInventoryItem(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Inventory.Item.Get
Function GetInventoryItem(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindInventoryItem(Parameters).DataPath, _Key);
EndFunction

// Inventory.Item.Bind
Function BindInventoryItem(Parameters)
	DataPath = "Inventory.Item";
	Binding = New Structure();
	Binding.Insert("OpeningEntry", "StepInventoryChangeItemKeyByItem");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindInventoryItem");
EndFunction

#EndRegion

#Region INVENTORY_ITEMKEY

// Inventory.ItemKey.OnChange
Procedure InventoryItemKeyOnChange(Parameters) Export
	Binding = BindInventoryItemKey(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Inventory.ItemKey.Set
Procedure SetInventoryItemKey(Parameters, Results) Export
	Binding = BindInventoryItemKey(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Inventory.ItemKey.Get
Function GetInventoryItemKey(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindInventoryItemKey(Parameters).DataPath, _Key);
EndFunction

// Inventory.ItemKey.Get.IsChanged
Function GetInventoryItemKey_IsChanged(Parameters, _Key)
	Return IsChangedProperty(Parameters, BindInventoryItemKey(Parameters).DataPath, _Key).IsChanged
		Or IsChangedPropertyDirectly_List(Parameters, _Key).IsChanged;
EndFunction

// Inventory.ItemKey.Bind
Function BindInventoryItemKey(Parameters)
	DataPath = "Inventory.ItemKey";
	Binding = New Structure();
	Binding.Insert("OpeningEntry", 
		"StepInventoryChangeUseSerialLotNumberByItemKey,
		|StepInventoryClearSerialLotNumberByItemKey");
		
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindInventoryItemKey");
EndFunction

// Inventory.ItemKey.ChangeItemKeyByItem.Step
Procedure StepInventoryChangeItemKeyByItem(Parameters, Chain) Export
	Chain.ChangeItemKeyByItem.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeItemKeyByItem.Setter = "SetInventoryItemKey";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeItemKeyByItemOptions();
		Options.Item    = GetInventoryItem(Parameters, Row.Key);
		Options.ItemKey = GetInventoryItemKey(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepInventoryChangeItemKeyByItem";
		Chain.ChangeItemKeyByItem.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region INVENTORY_SERIAL_LOT_NUMBER

// Inventory.SerialLotNumber.Set
Procedure SetInventorySerialLotNumber(Parameters, Results) Export
	Binding = BindInventorySerialLotNumber(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Inventory.SerialLotNumber.Get
Function GetInventorySerialLotNumber(Parameters, _Key)
	Binding = BindInventorySerialLotNumber(Parameters);
	Return GetPropertyObject(Parameters, Binding.DataPath, _Key);
EndFunction

// Inventory.SerialLotNumber.Bind
Function BindInventorySerialLotNumber(Parameters)
	DataPath = "Inventory.SerialLotNumber";
	Binding = New Structure();	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindInventorySerialLotNumber");
EndFunction

// Inventory.SeriaLotNumber.ClearInventorySerialLotNumberByItemKey.Step
Procedure StepInventoryClearSerialLotNumberByItemKey(Parameters, Chain) Export
	Chain.ClearSerialLotNumberByItemKey.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ClearSerialLotNumberByItemKey.Setter = "SetInventorySerialLotNumber";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ClearSerialLotNumberByItemKeyOptions();
		Options.ItemKeyIsChanged  = GetInventoryItemKey_IsChanged(Parameters, Row.Key);
		Options.CurrentSerialLotNumber = GetInventorySerialLotNumber(Parameters, Row.Key);
		Options.Key      = Row.Key;
		Options.StepName = "StepInventoryClearSerialLotNumberByItemKey";
		Chain.ClearSerialLotNumberByItemKey.Options.Add(Options);
	EndDo;	
EndProcedure

#EndRegion

#Region INVENTORY_USE_SERIAL_LOT_NUMBER

// Inventory.UseSerialLotNumber.Set
Procedure SetInventoryUseSerialLotNumber(Parameters, Results) Export
	Binding = BindInventoryUseSerialLotNumber(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Inventory.UseSerialLotNumber.Bind
Function BindInventoryUseSerialLotNumber(Parameters)
	DataPath = "Inventory.UseSerialLotNumber";
	Binding = New Structure();	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindInventoryUseSerialLotNumber");
EndFunction

// Inventory.UseSerialLotNumber.InventoryChangeUseSerialLotNumberByItemKey.Step
Procedure StepInventoryChangeUseSerialLotNumberByItemKey(Parameters, Chain) Export
	Chain.ChangeUseSerialLotNumberByItemKey.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeUseSerialLotNumberByItemKey.Setter = "SetInventoryUseSerialLotNumber";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeUseSerialLotNumberByItemKeyOptions();
		Options.ItemKey  = GetInventoryItemKey(Parameters, Row.Key);
		Options.Key      = Row.Key;
		Options.StepName = "StepInventoryChangeUseSerialLotNumberByItemKey";
		Chain.ChangeUseSerialLotNumberByItemKey.Options.Add(Options);
	EndDo;	
EndProcedure

#EndRegion

#Region INVENTORY_QUANTITY

// Inventory.Quantity.OnChange
Procedure InventoryQuantityOnChange(Parameters) Export
	Binding = BindInventoryQuantity(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Inventory.Quantity.Set
Procedure SetInventoryQuantity(Parameters, Results) Export
	Binding = BindInventoryQuantity(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Inventory.Quantity.Get
Function GetInventoryQuantity(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindInventoryQuantity(Parameters).DataPath, _Key);
EndFunction

// Inventory.Quantity.Bind
Function BindInventoryQuantity(Parameters)
	DataPath = "Inventory.Quantity";
	Binding = New Structure();	
	Binding.Insert("OpeningEntry", "StepInventoryCalculations_IsQuantityChanged");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindInventoryQuantity");
EndFunction

#EndRegion

#Region INVENTORY_PRICE

// Inventory.Price.OnChange
Procedure InventoryPriceOnChange(Parameters) Export
	Binding = BindInventoryPrice(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Inventory.Price.Set
Procedure SetInventoryPrice(Parameters, Results) Export
	Binding = BindInventoryPrice(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Inventory.Price.Get
Function GetInventoryPrice(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindInventoryPrice(Parameters).DataPath, _Key);
EndFunction

// Inventory.Price.Bind
Function BindInventoryPrice(Parameters)
	DataPath = "Inventory.Price";
	Binding = New Structure();
	Binding.Insert("OpeningEntry", "StepInventoryCalculations_IsPriceChanged");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindInventoryPrice");
EndFunction

#EndRegion

#Region INVENTORY_AMOUNT

// Inventory.Amount.OnChange
Procedure InventoryAmountOnChange(Parameters) Export
	Binding = BindInventoryAmount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// Inventory.Amount.Set
Procedure SetInventoryAmount(Parameters, Results) Export
	Binding = BindInventoryAmount(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// Inventory.Amount.Get
Function GetInventoryAmount(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindInventoryAmount(Parameters).DataPath , _Key);
EndFunction

// Inventory.Amount.Bind
Function BindInventoryAmount(Parameters)
	DataPath = "Inventory.Amount";
	Binding = New Structure();
	Binding.Insert("OpeningEntry", "StepInventoryCalculations_IsAmountChanged");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindInventoryAmount");
EndFunction

#EndRegion

#Region INVENTORY_CALCULATION

// Inventory.SimpleCalculations.[IsQuantityChanged].Step
Procedure StepInventoryCalculations_IsQuantityChanged(Parameters, Chain) Export
	StepInventoryCalculations(Parameters, Chain, "IsQuantityChanged");
EndProcedure

// Inventory.SimpleCalculations.[IsPriceChanged].Step
Procedure StepInventoryCalculations_IsPriceChanged(Parameters, Chain) Export
	StepInventoryCalculations(Parameters, Chain, "IsPriceChanged");
EndProcedure

// Inventory.SimpleCalculations.[IsAmountChanged].Step
Procedure StepInventoryCalculations_IsAmountChanged(Parameters, Chain) Export
	StepInventoryCalculations(Parameters, Chain, "IsAmountChanged");
EndProcedure

// Inventory.Calculations.Set
Procedure SetInventoryCalculations(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Price" , BindInventoryPrice(Parameters));
	ResourceToBinding.Insert("Amount", BindInventoryAmount(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

Procedure StepInventoryCalculations(Parameters, Chain, WhoIsChanged)
	Chain.SimpleCalculations.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.SimpleCalculations.Setter = "SetInventoryCalculations";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options     = ModelClientServer_V2.SimpleCalculationsOptions();
		Options.Ref = Parameters.Object.Ref;
		Options.Key = Row.Key;
		Options.DontExecuteIfExecutedBefore = True;
		
		If WhoIsChanged = "IsPriceChanged" Or WhoIsChanged = "IsQuantityChanged" Then
			Options.CalculateAmount.Enable = True;
		ElsIf WhoIsChanged = "IsAmountChanged" Then
			Options.CalculatePrice.Enable = True;
		Else
			Raise StrTemplate("Unsupported [WhoIsChanged] = %1", WhoIsChanged);
		EndIf;
		
		Options.Amount   = GetInventoryAmount(Parameters, Row.Key);
		Options.Price    = GetInventoryPrice(Parameters, Row.Key);
		Options.Quantity = GetInventoryQuantity(Parameters, Row.Key);
		Options.StepName = "StepInventoryCalculations";
		Chain.SimpleCalculations.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#EndRegion

#Region SHIPMENT_TO_TRADE_AGENT

#Region SHIPMENT_TO_TRADE_AGENT_ITEM

// ShipmentToTradeAgent.Item.OnChange
Procedure ShipmentToTradeAgentItemOnChange(Parameters) Export
	Binding = BindShipmentToTradeAgentItem(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ShipmentToTradeAgent.Item.Set
Procedure SetShipmentToTradeAgentItem(Parameters, Results) Export
	Binding = BindShipmentToTradeAgentItem(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ShipmentToTradeAgent.Item.Get
Function GetShipmentToTradeAgentItem(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindShipmentToTradeAgentItem(Parameters).DataPath, _Key);
EndFunction

// ShipmentToTradeAgent.Item.Bind
Function BindShipmentToTradeAgentItem(Parameters)
	DataPath = "ShipmentToTradeAgent.Item";
	Binding = New Structure();
	Binding.Insert("OpeningEntry", "StepShipmentToTradeAgentChangeItemKeyByItem");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindShipmentToTradeAgentItem");
EndFunction

#EndRegion

#Region SHIPMENT_TO_TRADE_AGENT_ITEMKEY

// ShipmentToTradeAgent.ItemKey.OnChange
Procedure ShipmentToTradeAgentItemKeyOnChange(Parameters) Export
	Binding = BindShipmentToTradeAgentItemKey(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ShipmentToTradeAgent.ItemKey.Set
Procedure SetShipmentToTradeAgentItemKey(Parameters, Results) Export
	Binding = BindShipmentToTradeAgentItemKey(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ShipmentToTradeAgent.ItemKey.Get
Function GetShipmentToTradeAgentItemKey(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindShipmentToTradeAgentItemKey(Parameters).DataPath, _Key);
EndFunction

// ShipmentToTradeAgent.ItemKey.Get.IsChanged
Function GetShipmentToTradeAgentItemKey_IsChanged(Parameters, _Key)
	Return IsChangedProperty(Parameters, BindShipmentToTradeAgentItemKey(Parameters).DataPath, _Key).IsChanged
		Or IsChangedPropertyDirectly_List(Parameters, _Key).IsChanged;
EndFunction

// ShipmentToTradeAgent.ItemKey.Bind
Function BindShipmentToTradeAgentItemKey(Parameters)
	DataPath = "ShipmentToTradeAgent.ItemKey";
	Binding = New Structure();
	Binding.Insert("OpeningEntry", 
		"StepShipmentToTradeAgentChangeUseSerialLotNumberByItemKey,
		|StepShipmentToTradeAgentClearSerialLotNumberByItemKey");
		
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindShipmentToTradeAgentItemKey");
EndFunction

// ShipmentToTradeAgent.ItemKey.ChangeItemKeyByItem.Step
Procedure StepShipmentToTradeAgentChangeItemKeyByItem(Parameters, Chain) Export
	Chain.ChangeItemKeyByItem.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeItemKeyByItem.Setter = "SetShipmentToTradeAgentItemKey";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeItemKeyByItemOptions();
		Options.Item    = GetShipmentToTradeAgentItem(Parameters, Row.Key);
		Options.ItemKey = GetShipmentToTradeAgentItemKey(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepShipmentToTradeAgentChangeItemKeyByItem";
		Chain.ChangeItemKeyByItem.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region SHIPMENT_TO_TRADE_AGENT_SERIAL_LOT_NUMBER

// ShipmentToTradeAgent.SerialLotNumber.Set
Procedure SetShipmentToTradeAgentSerialLotNumber(Parameters, Results) Export
	Binding = BindShipmentToTradeAgentSerialLotNumber(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ShipmentToTradeAgent.SerialLotNumber.Get
Function GetShipmentToTradeAgentSerialLotNumber(Parameters, _Key)
	Binding = BindShipmentToTradeAgentSerialLotNumber(Parameters);
	Return GetPropertyObject(Parameters, Binding.DataPath, _Key);
EndFunction

// ShipmentToTradeAgent.SerialLotNumber.Bind
Function BindShipmentToTradeAgentSerialLotNumber(Parameters)
	DataPath = "ShipmentToTradeAgent.SerialLotNumber";
	Binding = New Structure();	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindShipmentToTradeAgentSerialLotNumber");
EndFunction

// ShipmentToTradeAgent.SeriaLotNumber.ClearInventorySerialLotNumberByItemKey.Step
Procedure StepShipmentToTradeAgentClearSerialLotNumberByItemKey(Parameters, Chain) Export
	Chain.ClearSerialLotNumberByItemKey.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ClearSerialLotNumberByItemKey.Setter = "SetShipmentToTradeAgentSerialLotNumber";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ClearSerialLotNumberByItemKeyOptions();
		Options.ItemKeyIsChanged  = GetShipmentToTradeAgentItemKey_IsChanged(Parameters, Row.Key);
		Options.CurrentSerialLotNumber = GetShipmentToTradeAgentSerialLotNumber(Parameters, Row.Key);
		Options.Key      = Row.Key;
		Options.StepName = "StepShipmentToTradeAgentClearSerialLotNumberByItemKey";
		Chain.ClearSerialLotNumberByItemKey.Options.Add(Options);
	EndDo;	
EndProcedure

#EndRegion

#Region SHIPMENT_TO_TRADE_AGENT_USE_SERIAL_LOT_NUMBER

// ShipmentToTradeAgent.UseSerialLotNumber.Set
Procedure SetShipmentToTradeAgentUseSerialLotNumber(Parameters, Results) Export
	Binding = BindShipmentToTradeAgentUseSerialLotNumber(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ShipmentToTradeAgent.UseSerialLotNumber.Bind
Function BindShipmentToTradeAgentUseSerialLotNumber(Parameters)
	DataPath = "ShipmentToTradeAgent.UseSerialLotNumber";
	Binding = New Structure();	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindShipmentToTradeAgentUseSerialLotNumber");
EndFunction

// ShipmentToTradeAgent.UseSerialLotNumber.ShipmentToTradeAgentChangeUseSerialLotNumberByItemKey.Step
Procedure StepShipmentToTradeAgentChangeUseSerialLotNumberByItemKey(Parameters, Chain) Export
	Chain.ChangeUseSerialLotNumberByItemKey.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeUseSerialLotNumberByItemKey.Setter = "SetShipmentToTradeAgentUseSerialLotNumber";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeUseSerialLotNumberByItemKeyOptions();
		Options.ItemKey  = GetShipmentToTradeAgentItemKey(Parameters, Row.Key);
		Options.Key      = Row.Key;
		Options.StepName = "StepShipmentToTradeAgentChangeUseSerialLotNumberByItemKey";
		Chain.ChangeUseSerialLotNumberByItemKey.Options.Add(Options);
	EndDo;	
EndProcedure

#EndRegion

#Region SHIPMENT_TO_TRADE_AGENT_QUANTITY

// ShipmentToTradeAgent.Quantity.OnChange
Procedure ShipmentToTradeAgentQuantityOnChange(Parameters) Export
	Binding = BindShipmentToTradeAgentQuantity(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ShipmentToTradeAgent.Quantity.Set
Procedure SetShipmentToTradeAgentQuantity(Parameters, Results) Export
	Binding = BindShipmentToTradeAgentQuantity(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ShipmentToTradeAgent.Quantity.Bind
Function BindShipmentToTradeAgentQuantity(Parameters)
	DataPath = "ShipmentToTradeAgent.Quantity";
	Binding = New Structure();	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindShipmentToTradeAgentQuantity");
EndFunction

#EndRegion

#EndRegion

#Region RECEIPT_FROM_CONSIGNOR

#Region RECEIPT_FROM_CONSIGNOR_ITEM

// ReceiptFromConsignor.Item.OnChange
Procedure ReceiptFromConsignorItemOnChange(Parameters) Export
	Binding = BindReceiptFromConsignorItem(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ReceiptFromConsignor.Item.Set
Procedure SetReceiptFromConsignorItem(Parameters, Results) Export
	Binding = BindReceiptFromConsignorItem(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ReceiptFromConsignor.Item.Get
Function GetReceiptFromConsignorItem(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindReceiptFromConsignorItem(Parameters).DataPath, _Key);
EndFunction

// ReceiptFromConsignor.Item.Bind
Function BindReceiptFromConsignorItem(Parameters)
	DataPath = "ReceiptFromConsignor.Item";
	Binding = New Structure();
	Binding.Insert("OpeningEntry", "StepReceiptFromConsignorChangeItemKeyByItem");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindReceiptFromConsignorItem");
EndFunction

#EndRegion

#Region RECEIPT_FROM_CONSIGNOR_ITEMKEY

// ReceiptFromConsignor.ItemKey.OnChange
Procedure ReceiptFromConsignorItemKeyOnChange(Parameters) Export
	Binding = BindReceiptFromConsignorItemKey(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ReceiptFromConsignor.ItemKey.Set
Procedure SetReceiptFromConsignorItemKey(Parameters, Results) Export
	Binding = BindReceiptFromConsignorItemKey(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ReceiptFromConsignor.ItemKey.Get
Function GetReceiptFromConsignorItemKey(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindReceiptFromConsignorItemKey(Parameters).DataPath, _Key);
EndFunction

// ReceiptFromConsignor.ItemKey.Get.IsChanged
Function GetReceiptFromConsignorItemKey_IsChanged(Parameters, _Key)
	Return IsChangedProperty(Parameters, BindReceiptFromConsignorItemKey(Parameters).DataPath, _Key).IsChanged
		Or IsChangedPropertyDirectly_List(Parameters, _Key).IsChanged;
EndFunction

// ReceiptFromConsignor.ItemKey.Bind
Function BindReceiptFromConsignorItemKey(Parameters)
	DataPath = "ReceiptFromConsignor.ItemKey";
	Binding = New Structure();
	Binding.Insert("OpeningEntry", 
		"StepReceiptFromConsignorChangeUseSerialLotNumberByItemKey,
		|StepReceiptFromConsignorClearSerialLotNumberByItemKey");
		
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindReceiptFromConsignorItemKey");
EndFunction

// ReceiptFromConsignor.ItemKey.ChangeItemKeyByItem.Step
Procedure StepReceiptFromConsignorChangeItemKeyByItem(Parameters, Chain) Export
	Chain.ChangeItemKeyByItem.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeItemKeyByItem.Setter = "SetReceiptFromConsignorItemKey";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeItemKeyByItemOptions();
		Options.Item    = GetReceiptFromConsignorItem(Parameters, Row.Key);
		Options.ItemKey = GetReceiptFromConsignorItemKey(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepReceiptFromConsignorChangeItemKeyByItem";
		Chain.ChangeItemKeyByItem.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region RECEIPT_FROM_CONSIGNOR_SERIAL_LOT_NUMBER

// ReceiptFromConsignor.SerialLotNumber.Set
Procedure SetReceiptFromConsignorSerialLotNumber(Parameters, Results) Export
	Binding = BindReceiptFromConsignorSerialLotNumber(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ReceiptFromConsignor.SerialLotNumber.Get
Function GetReceiptFromConsignorSerialLotNumber(Parameters, _Key)
	Binding = BindReceiptFromConsignorSerialLotNumber(Parameters);
	Return GetPropertyObject(Parameters, Binding.DataPath, _Key);
EndFunction

// ReceiptFromConsignor.SerialLotNumber.Bind
Function BindReceiptFromConsignorSerialLotNumber(Parameters)
	DataPath = "ReceiptFromConsignor.SerialLotNumber";
	Binding = New Structure();	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindReceiptFromConsignorSerialLotNumber");
EndFunction

// ReceiptFromConsignor.SeriaLotNumber.ClearReceiptFromConsignorSerialLotNumberByItemKey.Step
Procedure StepReceiptFromConsignorClearSerialLotNumberByItemKey(Parameters, Chain) Export
	Chain.ClearSerialLotNumberByItemKey.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ClearSerialLotNumberByItemKey.Setter = "SetReceiptFromConsignorSerialLotNumber";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ClearSerialLotNumberByItemKeyOptions();
		Options.ItemKeyIsChanged  = GetReceiptFromConsignorItemKey_IsChanged(Parameters, Row.Key);
		Options.CurrentSerialLotNumber = GetReceiptFromConsignorSerialLotNumber(Parameters, Row.Key);
		Options.Key      = Row.Key;
		Options.StepName = "StepReceiptFromConsignorClearSerialLotNumberByItemKey";
		Chain.ClearSerialLotNumberByItemKey.Options.Add(Options);
	EndDo;	
EndProcedure

#EndRegion

#Region RECEIPT_FROM_CONSIGNOR_USE_SERIAL_LOT_NUMBER

// ReceiptFromConsignor.UseSerialLotNumber.Set
Procedure SetReceiptFromConsignorUseSerialLotNumber(Parameters, Results) Export
	Binding = BindReceiptFromConsignorUseSerialLotNumber(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ReceiptFromConsignor.UseSerialLotNumber.Bind
Function BindReceiptFromConsignorUseSerialLotNumber(Parameters)
	DataPath = "ReceiptFromConsignor.UseSerialLotNumber";
	Binding = New Structure();	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindReceiptFromConsignorUseSerialLotNumber");
EndFunction

// ReceiptFromConsignor.UseSerialLotNumber.ReceiptFromConsignorChangeUseSerialLotNumberByItemKey.Step
Procedure StepReceiptFromConsignorChangeUseSerialLotNumberByItemKey(Parameters, Chain) Export
	Chain.ChangeUseSerialLotNumberByItemKey.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeUseSerialLotNumberByItemKey.Setter = "SetReceiptFromConsignorUseSerialLotNumber";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeUseSerialLotNumberByItemKeyOptions();
		Options.ItemKey  = GetReceiptFromConsignorItemKey(Parameters, Row.Key);
		Options.Key      = Row.Key;
		Options.StepName = "StepReceiptFromConsignorChangeUseSerialLotNumberByItemKey";
		Chain.ChangeUseSerialLotNumberByItemKey.Options.Add(Options);
	EndDo;	
EndProcedure

#EndRegion

#Region RECEIPT_FROM_CONSIGNOR_QUANTITY

// ReceiptFromConsignor.Quantity.OnChange
Procedure ReceiptFromConsignorQuantityOnChange(Parameters) Export
	Binding = BindReceiptFromConsignorQuantity(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ReceiptFromConsignor.Quantity.Set
Procedure SetReceiptFromConsignorQuantity(Parameters, Results) Export
	Binding = BindReceiptFromConsignorQuantity(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ReceiptFromConsignor.Quantity.Get
Function GetReceiptFromConsignorQuantity(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindReceiptFromConsignorQuantity(Parameters).DataPath, _Key);
EndFunction

// ReceiptFromConsignor.Quantity.Bind
Function BindReceiptFromConsignorQuantity(Parameters)
	DataPath = "ReceiptFromConsignor.Quantity";
	Binding = New Structure();	
	Binding.Insert("OpeningEntry", "StepReceiptFromConsignorCalculations_IsQuantityChanged");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindReceiptFromConsignorQuantity");
EndFunction

#EndRegion

#Region RECEIPT_FROM_CONSIGNOR_PRICE

// ReceiptFromConsignor.Price.OnChange
Procedure ReceiptFromConsignorPriceOnChange(Parameters) Export
	Binding = BindReceiptFromConsignorPrice(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ReceiptFromConsignor.Price.Set
Procedure SetReceiptFromConsignorPrice(Parameters, Results) Export
	Binding = BindReceiptFromConsignorPrice(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ReceiptFromConsignor.Price.Get
Function GetReceiptFromConsignorPrice(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindReceiptFromConsignorPrice(Parameters).DataPath, _Key);
EndFunction

// ReceiptFromConsignor.Price.Bind
Function BindReceiptFromConsignorPrice(Parameters)
	DataPath = "ReceiptFromConsignor.Price";
	Binding = New Structure();
	Binding.Insert("OpeningEntry", "StepReceiptFromConsignorCalculations_IsPriceChanged");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindReceiptFromConsignorPrice");
EndFunction

#EndRegion

#Region RECEIPT_FROM_CONSIGNOR_AMOUNT

// ReceiptFromConsignor.Amount.OnChange
Procedure ReceiptFromConsignorAmountOnChange(Parameters) Export
	Binding = BindReceiptFromConsignorAmount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// ReceiptFromConsignor.Amount.Set
Procedure SetReceiptFromConsignorAmount(Parameters, Results) Export
	Binding = BindReceiptFromConsignorAmount(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// ReceiptFromConsignor.Amount.Get
Function GetReceiptFromConsignorAmount(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindReceiptFromConsignorAmount(Parameters).DataPath , _Key);
EndFunction

// ReceiptFromConsignor.Amount.Bind
Function BindReceiptFromConsignorAmount(Parameters)
	DataPath = "ReceiptFromConsignor.Amount";
	Binding = New Structure();
	Binding.Insert("OpeningEntry", "StepReceiptFromConsignorCalculations_IsAmountChanged");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindReceiptFromConsignorAmount");
EndFunction

#EndRegion

#Region RECEIPT_FROM_CONSIGNOR_CALCULATION

// ReceiptFromConsignor.SimpleCalculations.[IsQuantityChanged].Step
Procedure StepReceiptFromConsignorCalculations_IsQuantityChanged(Parameters, Chain) Export
	StepReceiptFromConsignorCalculations(Parameters, Chain, "IsQuantityChanged");
EndProcedure

// ReceiptFromConsignor.SimpleCalculations.[IsPriceChanged].Step
Procedure StepReceiptFromConsignorCalculations_IsPriceChanged(Parameters, Chain) Export
	StepReceiptFromConsignorCalculations(Parameters, Chain, "IsPriceChanged");
EndProcedure

// ReceiptFromConsignor.SimpleCalculations.[IsAmountChanged].Step
Procedure StepReceiptFromConsignorCalculations_IsAmountChanged(Parameters, Chain) Export
	StepReceiptFromConsignorCalculations(Parameters, Chain, "IsAmountChanged");
EndProcedure

// ReceiptFromConsignor.Calculations.Set
Procedure SetReceiptFromConsignorCalculations(Parameters, Results) Export
	ResourceToBinding = New Map();
	ResourceToBinding.Insert("Price" , BindReceiptFromConsignorPrice(Parameters));
	ResourceToBinding.Insert("Amount", BindReceiptFromConsignorAmount(Parameters));
	MultiSetterObject(Parameters, Results, ResourceToBinding);
EndProcedure

Procedure StepReceiptFromConsignorCalculations(Parameters, Chain, WhoIsChanged)
	Chain.SimpleCalculations.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.SimpleCalculations.Setter = "SetReceiptFromConsignorCalculations";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options     = ModelClientServer_V2.SimpleCalculationsOptions();
		Options.Ref = Parameters.Object.Ref;
		Options.Key = Row.Key;
		Options.DontExecuteIfExecutedBefore = True;
		
		If WhoIsChanged = "IsPriceChanged" Or WhoIsChanged = "IsQuantityChanged" Then
			Options.CalculateAmount.Enable = True;
		ElsIf WhoIsChanged = "IsAmountChanged" Then
			Options.CalculatePrice.Enable = True;
		Else
			Raise StrTemplate("Unsupported [WhoIsChanged] = %1", WhoIsChanged);
		EndIf;
		
		Options.Amount   = GetReceiptFromConsignorAmount(Parameters, Row.Key);
		Options.Price    = GetReceiptFromConsignorPrice(Parameters, Row.Key);
		Options.Quantity = GetReceiptFromConsignorQuantity(Parameters, Row.Key);
		Options.StepName = "StepReceiptFromConsignorCalculations";
		Chain.SimpleCalculations.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#EndRegion

#Region ACCOUNT_BALANCE

#Region ACCOUNT_BALANCE_ACCOUNT

// AccountBalance.Account.OnChange
Procedure AccountBalanceAccountOnChange(Parameters) Export
	Binding = BindAccountBalanceAccount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// AccountBalance.Account.Set
Procedure SetAccountBalanceAccount(Parameters, Results) Export
	Binding = BindAccountBalanceAccount(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// AccountBalance.Account.Get
Function GetAccountBalanceAccount(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindAccountBalanceAccount(Parameters).DataPath, _Key);
EndFunction

// AccountBalance.Account.Bind
Function BindAccountBalanceAccount(Parameters)
	DataPath = "AccountBalance.Account";
	Binding = New Structure();
	Binding.Insert("OpeningEntry", 
		"StepAccountBalanceChangeCurrencyByAccount,
		|StepAccountBalanceChangeIsFixedCurrencyByAccount");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindAccountBalanceAccount");
EndFunction

#EndRegion

#Region ACCOUNT_BALANCE_CURRENCY

// AccountBalance.Currency.Set
Procedure SetAccountBalanceCurrency(Parameters, Results) Export
	Binding = BindAccountBalanceCurrency(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// AccountBalance.Currency.Get
Function GetAccountBalanceCurrency(Parameters, _Key)
	Binding = BindAccountBalanceCurrency(Parameters);
	Return GetPropertyObject(Parameters, Binding.DataPath, _Key);
EndFunction

// AccountBalance.Currency.Bind
Function BindAccountBalanceCurrency(Parameters)
	DataPath = "AccountBalance.Currency";
	Binding = New Structure();	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindAccountBalanceCurrency");
EndFunction

// AccountBalance.Currency.ChangeCurrencyByAccount.Step
Procedure StepAccountBalanceChangeCurrencyByAccount(Parameters, Chain) Export
	Chain.ChangeCurrencyByAccount.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeCurrencyByAccount.Setter = "SetAccountBalanceCurrency";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeCurrencyByAccountOptions();
		Options.Account         = GetAccountBalanceAccount(Parameters, Row.Key);
		Options.CurrentCurrency = GetAccountBalanceCurrency(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepAccountBalanceChangeCurrencyByAccount";
		Chain.ChangeCurrencyByAccount.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region ACCOUNT_BALANCE_IS_FIXED_CURRENCY

// AccountBalance.IsFixedCurrency.Set
Procedure SetAccountBalanceIsFixedCurrency(Parameters, Results) Export
	Binding = BindAccountBalanceIsFixedCurrency(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// AccountBalance.IsFixedCurrency.Bind
Function BindAccountBalanceIsFixedCurrency(Parameters)
	DataPath = "AccountBalance.IsFixedCurrency";
	Binding = New Structure();	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindAccountBalanceIsFixedCurrency");
EndFunction

// AccountBalance.IsFixedCurrency.ChangeIsFixedCurrencyByAccount.Step
Procedure StepAccountBalanceChangeIsFixedCurrencyByAccount(Parameters, Chain) Export
	Chain.ChangeIsFixedCurrencyByAccount.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeIsFixedCurrencyByAccount.Setter = "SetAccountBalanceIsFixedCurrency";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeIsFixedCurrencyByAccountOptions();
		Options.Account         = GetAccountBalanceAccount(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepAccountBalanceChangeIsFixedCurrencyByAccount";
		Chain.ChangeIsFixedCurrencyByAccount.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#EndRegion

#Region EMPLOYEE_CASH_ADVANCE

#Region EMPLOYEE_CASH_ADVANCE_ACCOUNT

// EmployeeCashAdvance.Account.OnChange
Procedure EmployeeCashAdvanceAccountOnChange(Parameters) Export
	Binding = BindEmployeeCashAdvanceAccount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// EmployeeCashAdvance.Account.Set
Procedure SetEmployeeCashAdvanceAccount(Parameters, Results) Export
	Binding = BindEmployeeCashAdvanceAccount(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// EmployeeCashAdvance.Account.Get
Function GetEmployeeCashAdvanceAccount(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindEmployeeCashAdvanceAccount(Parameters).DataPath, _Key);
EndFunction

// EmployeeCashAdvance.Account.Bind
Function BindEmployeeCashAdvanceAccount(Parameters)
	DataPath = "EmployeeCashAdvance.Account";
	Binding = New Structure();
	Binding.Insert("OpeningEntry", 
		"StepEmployeeCashAdvanceChangeCurrencyByAccount,
		|StepEmployeeCashAdvanceChangeIsFixedCurrencyByAccount");
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindEmployeeCashAdvanceAccount");
EndFunction

#EndRegion

#Region EMPLOYEE_CASH_ADVANCE_CURRENCY

// EmployeeCashAdvance.Currency.Set
Procedure SetEmployeeCashAdvanceCurrency(Parameters, Results) Export
	Binding = BindEmployeeCashAdvanceCurrency(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// EmployeeCashAdvance.Currency.Get
Function GetEmployeeCashAdvanceCurrency(Parameters, _Key)
	Binding = BindEmployeeCashAdvanceCurrency(Parameters);
	Return GetPropertyObject(Parameters, Binding.DataPath, _Key);
EndFunction

// EmployeeCashAdvance.Currency.Bind
Function BindEmployeeCashAdvanceCurrency(Parameters)
	DataPath = "EmployeeCashAdvance.Currency";
	Binding = New Structure();	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindEmployeeCashAdvanceCurrency");
EndFunction

// EmployeeCashAdvance.Currency.ChangeCurrencyByAccount.Step
Procedure StepEmployeeCashAdvanceChangeCurrencyByAccount(Parameters, Chain) Export
	Chain.ChangeCurrencyByAccount.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeCurrencyByAccount.Setter = "SetEmployeeCashAdvanceCurrency";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeCurrencyByAccountOptions();
		Options.Account         = GetEmployeeCashAdvanceAccount(Parameters, Row.Key);
		Options.CurrentCurrency = GetEmployeeCashAdvanceCurrency(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepEmployeeCashAdvanceChangeCurrencyByAccount";
		Chain.ChangeCurrencyByAccount.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region EMPLOYEE_CASH_ADVANCE_IS_FIXED_CURRENCY

// EmployeeCashAdvance.IsFixedCurrency.Set
Procedure SetEmployeeCashAdvanceIsFixedCurrency(Parameters, Results) Export
	Binding = BindEmployeeCashAdvanceIsFixedCurrency(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// EmployeeCashAdvance.IsFixedCurrency.Bind
Function BindEmployeeCashAdvanceIsFixedCurrency(Parameters)
	DataPath = "EmployeeCashAdvance.IsFixedCurrency";
	Binding = New Structure();	
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindEmployeeCashAdvanceIsFixedCurrency");
EndFunction

// EmployeeCashAdvance.IsFixedCurrency.ChangeIsFixedCurrencyByAccount.Step
Procedure StepEmployeeCashAdvanceChangeIsFixedCurrencyByAccount(Parameters, Chain) Export
	Chain.ChangeIsFixedCurrencyByAccount.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeIsFixedCurrencyByAccount.Setter = "SetEmployeeCashAdvanceIsFixedCurrency";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeIsFixedCurrencyByAccountOptions();
		Options.Account         = GetEmployeeCashAdvanceAccount(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepEmployeeCashAdvanceChangeIsFixedCurrencyByAccount";
		Chain.ChangeIsFixedCurrencyByAccount.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#EndRegion

#Region PAYROLL_LISTS

#Region PAYROLL_LISTS_ACRUAL_DEDUCTION_TYPE

// PayrollLists.AccrualDeductionType.OnChange
Procedure PayrollListsAccrualDeductionTypeOnChange(Parameters) Export
	Binding = BindPayrollListsAccrualDeductionType(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PayrollLists.AccrualDeductionType.Set
Procedure SetPayrollListsAccrualDeductionType(Parameters, Results) Export
	Binding = BindPayrollListsAccrualDeductionType(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PayrollLists.AccrualDeductionType.Get
Function GetPayrollListsAccrualDeductionType(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPayrollListsAccrualDeductionType(Parameters).DataPath, _Key);
EndFunction

// PayrollLists.AccrualDeductionType.Bind
Function BindPayrollListsAccrualDeductionType(Parameters)
	DataPathMap = New Map();
	DataPathMap.Insert("AccrualList"   , "AccrualList.AccrualType");
	DataPathMap.Insert("DeductionList" , "DeductionList.DeductionType");
	DataPath = DataPathMap.Get(Parameters.TableName);
	
	Binding = New Structure();
	Return BindSteps("StepPayrollListsChangeExpenseTypeByAccrualDeductionType", 
		DataPath, Binding, Parameters, "BindPayrollListsAccrualDeductionType");
EndFunction

// PayrollLists.ChangeExpenseTypeByAccrualDeductionType.Step
Procedure StepPayrollListsChangeExpenseTypeByAccrualDeductionType(Parameters, Chain) Export
	Chain.ChangeExpenseTypeByAccrualDeductionType.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.ChangeExpenseTypeByAccrualDeductionType.Setter = "SetPayrollListsExpenseType";
	For Each Row In GetRows(Parameters, Parameters.TableName) Do
		Options = ModelClientServer_V2.ChangeExpenseTypeByAccrualDeductionTypeOptions();
		Options.AccrualDeductionType = GetPayrollListsAccrualDeductionType(Parameters, Row.Key);
		Options.ExpenseType          = GetPayrollListsExpenseType(Parameters, Row.Key);
		Options.Key = Row.Key;
		Options.StepName = "StepPayrollListsChangeExpenseTypeByAccrualDeductionType";
		Chain.ChangeExpenseTypeByAccrualDeductionType.Options.Add(Options);
	EndDo;
EndProcedure

#EndRegion

#Region PAYROLL_LISTS_EXPENSE_TYPE

// PayrollLists.ExpenseType.Set
Procedure SetPayrollListsExpenseType(Parameters, Results) Export
	Binding = BindPayrollListsExpenseType(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// PayrollLists.ExpenseType.Get
Function GetPayrollListsExpenseType(Parameters, _Key)
	Return GetPropertyObject(Parameters, BindPayrollListsExpenseType(Parameters).DataPath, _Key);
EndFunction

// PayrollLists.ExpenseType.Bind
Function BindPayrollListsExpenseType(Parameters)
	DataPathMap = New Map();
	DataPathMap.Insert("AccrualList"   , "AccrualList.ExpenseType");
	DataPathMap.Insert("DeductionList" , "DeductionList.ExpenseType");
	DataPath = DataPathMap.Get(Parameters.TableName);
	
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPayrollListsExpenseType");
EndFunction

#EndRegion

#Region PAYROLL_LISTS_AMOUNT

// PayrollLists.Amount.OnChange
Procedure PayrollListsAmountOnChange(Parameters) Export
	AddViewNotify("OnSetPayrollListsAmountNotify", Parameters);
	Binding = BindPayrollListsAmount(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PayrollLists.Amount.Set
Procedure SetPayrollListsAmount(Parameters, Results) Export
	Binding = BindPayrollListsAmount(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results, "OnSetPayrollListsAmountNotify");
EndProcedure

// PayrollLists.Amount.Bind
Function BindPayrollListsAmount(Parameters)
	DataPathMap = New Map();
	DataPathMap.Insert("AccrualList"   , "AccrualList.Amount");
	DataPathMap.Insert("DeductionList" , "DeductionList.Amount");
	DataPathMap.Insert("CashAdvanceDeductionList" , "CashAdvanceDeductionList.Amount");
	DataPath = DataPathMap.Get(Parameters.TableName);
	
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindPayrollListsAmount");
EndFunction

#EndRegion

#Region PAYROLL_LISTS_LOAD_DATA

// PayrollLists.Load
Procedure PayrollListsLoad(Parameters) Export
	Binding = BindPayrollListsLoad(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// PayrollLists.Load.Set
#If Server Then
	
Procedure ServerTableLoaderPayrollLists(Parameters, Results) Export
	Binding = BindPayrollListsLoad(Parameters);
	LoaderTable(Binding.DataPath, Parameters, Results);
EndProcedure

#EndIf

// PayrollLists.Load.Bind
Function BindPayrollListsLoad(Parameters)
	DataPath = Parameters.TableName;
	Binding = New Structure();
	Return BindSteps("StepPayrollListsLoadTable", DataPath, Binding, Parameters, "BindPayrollListsLoad");
EndFunction

// PayrollLists.LoadAtServer.Step
Procedure StepPayrollListsLoadTable(Parameters, Chain) Export
	Chain.LoadTable.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.LoadTable.Setter = "ServerTableLoaderPayrollLists";
	Options = ModelClientServer_V2.LoadTableOptions();
	Options.TableAddress = Parameters.LoadData.Address;
	Chain.LoadTable.Options.Add(Options);
EndProcedure

#EndRegion

#EndRegion

#Region TIME_SHEET_LIST

#Region TIME_SHEET_LIST_EMPLOYEE

// TimeSheetList.Employee.OnChange
Procedure TimeSheetListEmployeeOnChange(Parameters) Export
	Binding = BindTimeSheetListEmployee(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// TimeSheetList.Employee.Set
Procedure SetTimeSheetListEmployee(Parameters, Results) Export
	Binding = BindTimeSheetListEmployee(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// TimeSheetList.Employee.Bind
Function BindTimeSheetListEmployee(Parameters)
	DataPath = "TimeSheetList.Employee";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindTimeSheetListEmployee");
EndFunction

#EndRegion

#Region TIME_SHEET_LIST_POSITION

// TimeSheetList.Position.OnChange
Procedure TimeSheetListPositionOnChange(Parameters) Export
	Binding = BindTimeSheetListPosition(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// TimeSheetList.Position.Set
Procedure SetTimeSheetListPosition(Parameters, Results) Export
	Binding = BindTimeSheetListPosition(Parameters);
	SetterObject(Binding.StepsEnabler, Binding.DataPath, Parameters, Results);
EndProcedure

// TimeSheetList.Position.Bind
Function BindTimeSheetListPosition(Parameters)
	DataPath = "TimeSheetList.Position";
	Binding = New Structure();
	Return BindSteps("BindVoid", DataPath, Binding, Parameters, "BindTimeSheetListPosition");
EndFunction

#EndRegion

#Region TIME_SHEET_LIST_LOAD_DATA

// TimeSheetList.Load
Procedure TimeSheetListLoad(Parameters) Export
	Binding = BindTimeSheetListLoad(Parameters);
	ModelClientServer_V2.EntryPoint(Binding.StepsEnabler, Parameters);
EndProcedure

// TimeSheetList.Load.Set
#If Server Then
	
Procedure ServerTableLoaderTimeSheetList(Parameters, Results) Export
	Binding = BindTimeSheetListLoad(Parameters);
	LoaderTable(Binding.DataPath, Parameters, Results);
EndProcedure

#EndIf

// TimeSheetList.Load.Bind
Function BindTimeSheetListLoad(Parameters)
	DataPath = "TimeSheetList";
	Binding = New Structure();
	Return BindSteps("StepTimeSheetListLoadTable", DataPath, Binding, Parameters, "BindTimeSheetListLoad");
EndFunction

// TimeSheetList.LoadAtServer.Step
Procedure StepTimeSheetListLoadTable(Parameters, Chain) Export
	Chain.LoadTable.Enable = True;
	If Chain.Idle Then
		Return;
	EndIf;
	Chain.LoadTable.Setter = "ServerTableLoaderTimeSheetList";
	Options = ModelClientServer_V2.LoadTableOptions();
	Options.TableAddress = Parameters.LoadData.Address;
	Chain.LoadTable.Options.Add(Options);
EndProcedure

#EndRegion

#EndRegion

// called when all chain steps is complete
Procedure OnChainComplete(Parameters) Export
	#IF Client THEN
		// on client need ask user, do not transfer from cache to object
		// web-client-buf-fix
		 ViewClient_V2.OnChainComplete(Parameters);
	#ENDIF
	
	#IF Server THEN
		// on server transfer from cache to object
		CommitChainChanges(Parameters);
	#ENDIF
EndProcedure

Procedure CommitChainChanges(Parameters, OnChangesNotifyView = True) Export
		
	_CommitChainChanges(Parameters.Cache, Parameters.Object, Parameters);
	
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
			//@skip-warning
			Execute StrTemplate("%1.%2(Parameters);", ViewModuleName, FormModificator);
		EndDo;
		_CommitChainChanges(Parameters.CacheForm, Parameters.Form, Parameters);
	
	#IF Client THEN
		If OnChangesNotifyView Then
			OnChangesNotifyView(Parameters);
		EndIf;
	#ENDIF
	EndIf;
EndProcedure

#IF Client Then
	
Procedure OnChangesNotifyView(Parameters) Export	
	UniqueViewNotify = New Array();
	For Each ViewNotify In Parameters.ViewNotify Do
		If UniqueViewNotify.Find(ViewNotify) = Undefined Then
			UniqueViewNotify.Add(ViewNotify);
		EndIf;
	EndDo;
	For Each ViewNotify In UniqueViewNotify Do
		ExecuteViewNotify(Parameters, ViewNotify);
	EndDo;	
EndProcedure

Procedure ExecuteViewNotify(Parameters, ViewNotify)
	If ViewNotify = "OnOpenFormNotify"                         Then ViewClient_V2.OnOpenFormNotify(Parameters);
	ElsIf ViewNotify = "InventoryOnAddRowFormNotify"           Then ViewClient_V2.InventoryOnAddRowFormNotify(Parameters);
	ElsIf ViewNotify = "InventoryOnCopyRowFormNotify"          Then ViewClient_V2.InventoryOnCopyRowFormNotify(Parameters);
	ElsIf ViewNotify = "AccountBalanceOnAddRowFormNotify"      Then ViewClient_V2.AccountBalanceOnAddRowFormNotify(Parameters);
	ElsIf ViewNotify = "AccountBalanceOnCopyRowFormNotify"     Then ViewClient_V2.AccountBalanceOnCopyRowFormNotify(Parameters);
	ElsIf ViewNotify = "ChequeBondsOnAddRowFormNotify"         Then ViewClient_V2.ChequeBondsOnAddRowFormNotify(Parameters);
	ElsIf ViewNotify = "ChequeBondsOnCopyRowFormNotify"        Then ViewClient_V2.ChequeBondsOnCopyRowFormNotify(Parameters);
	ElsIf ViewNotify = "ChequeBondsAfterDeleteRowFormNotify"   Then ViewClient_V2.ChequeBondsAfterDeleteRowFormNotify(Parameters);
	ElsIf ViewNotify = "OnSetChequeBondsChequeNotify"          Then ViewClient_V2.OnSetChequeBondsChequeNotify(Parameters);
	ElsIf ViewNotify = "ItemListOnAddRowFormNotify"            Then ViewClient_V2.ItemListOnAddRowFormNotify(Parameters);
	ElsIf ViewNotify = "ItemListOnCopyRowFormNotify"           Then ViewClient_V2.ItemListOnCopyRowFormNotify(Parameters);
	ElsIf ViewNotify = "ItemListAfterDeleteRowFormNotify"      Then ViewClient_V2.ItemListAfterDeleteRowFormNotify(Parameters);
	ElsIf ViewNotify = "OnSetItemListCancelNotify"             Then ViewClient_V2.OnSetItemListCancelNotify(Parameters);
	ElsIf ViewNotify = "OnSetItemListNetAmountNotify"          Then ViewClient_V2.OnSetItemListNetAmountNotify(Parameters);
	ElsIf ViewNotify = "OnSetItemListTaxAmountNotify"          Then ViewClient_V2.OnSetItemListTaxAmountNotify(Parameters);	
	ElsIf ViewNotify = "OnSetItemListQuantityNotify"           Then ViewClient_V2.OnSetItemListQuantityNotify(Parameters);
	ElsIf ViewNotify = "OnSetItemListQuantityInBaseUnitNotify" Then ViewClient_V2.OnSetItemListQuantityInBaseUnitNotify(Parameters);
	ElsIf ViewNotify = "OnSetItemListPhysCountNotify"          Then ViewClient_V2.OnSetItemListPhysCountNotify(Parameters);
	ElsIf ViewNotify = "OnSetItemListManualFixedCountNotify"   Then ViewClient_V2.OnSetItemListManualFixedCountNotify(Parameters);
	ElsIf ViewNotify = "OnSetCalculationsNotify"               Then ViewClient_V2.OnSetCalculationsNotify(Parameters);
	ElsIf ViewNotify = "PaymentListOnAddRowFormNotify"         Then ViewClient_V2.PaymentListOnAddRowFormNotify(Parameters);
	ElsIf ViewNotify = "PaymentListOnCopyRowFormNotify"        Then ViewClient_V2.PaymentListOnCopyRowFormNotify(Parameters);
	ElsIf ViewNotify = "TransactionsOnAddRowFormNotify"        Then ViewClient_V2.TransactionsOnAddRowFormNotify(Parameters);
	ElsIf ViewNotify = "TransactionsOnCopyRowFormNotify"       Then ViewClient_V2.TransactionsOnCopyRowFormNotify(Parameters);
	ElsIf ViewNotify = "OnSetAccountSenderNotify"              Then ViewClient_V2.OnSetAccountSenderNotify(Parameters);
	ElsIf ViewNotify = "OnSetSendCurrencyNotify"               Then ViewClient_V2.OnSetSendCurrencyNotify(Parameters);
	ElsIf ViewNotify = "OnSetSendAmountNotify"                 Then ViewClient_V2.OnSetSendAmountNotify(Parameters);
	ElsIf ViewNotify = "OnSetAccountReceiverNotify"            Then ViewClient_V2.OnSetAccountReceiverNotify(Parameters);
	ElsIf ViewNotify = "OnSetReceiveCurrencyNotify"            Then ViewClient_V2.OnSetReceiveCurrencyNotify(Parameters);
	ElsIf ViewNotify = "OnSetReceiveAmountNotify"              Then ViewClient_V2.OnSetReceiveAmountNotify(Parameters);
	ElsIf ViewNotify = "OnSetCashTransferOrderNotify"          Then ViewClient_V2.OnSetCashTransferOrderNotify(Parameters);
	ElsIf ViewNotify = "OnSetStoreObjectAttrNotify"            Then ViewClient_V2.OnSetStoreObjectAttrNotify(Parameters);
	ElsIf ViewNotify = "OnSetStoreNotify"                      Then ViewClient_V2.OnSetStoreNotify(Parameters);
	ElsIf ViewNotify = "OnSetStoreTransitNotify"               Then ViewClient_V2.OnSetStoreTransitNotify(Parameters);
	ElsIf ViewNotify = "OnSetStoreSenderNotify"                Then ViewClient_V2.OnSetStoreSenderNotify(Parameters);
	ElsIf ViewNotify = "OnSetStoreReceiverNotify"              Then ViewClient_V2.OnSetStoreReceiverNotify(Parameters);
	ElsIf ViewNotify = "OnSetDeliveryDateNotify"               Then ViewClient_V2.OnSetDeliveryDateNotify(Parameters);
	ElsIf ViewNotify = "OnSetCompanyNotify"                    Then ViewClient_V2.OnSetCompanyNotify(Parameters);
	ElsIf ViewNotify = "OnSetAccountNotify"                    Then ViewClient_V2.OnSetAccountNotify(Parameters);
	ElsIf ViewNotify = "OnSetCashAccountNotify"                Then ViewClient_V2.OnSetCashAccountNotify(Parameters);
	ElsIf ViewNotify = "OnSetTransactionTypeNotify"            Then ViewClient_V2.OnSetTransactionTypeNotify(Parameters);
	ElsIf ViewNotify = "OnSetCurrencyNotify"                   Then ViewClient_V2.OnSetCurrencyNotify(Parameters);
	ElsIf ViewNotify = "OnSetPartnerNotify"                    Then ViewClient_V2.OnSetPartnerNotify(Parameters);
	ElsIf ViewNotify = "OnSetLegalNameNotify"                  Then ViewClient_V2.OnSetLegalNameNotify(Parameters);
	ElsIf ViewNotify = "OnSetCourierNotify"                    Then ViewClient_V2.OnSetCourierNotify(Parameters);
	ElsIf ViewNotify = "OnSetConsolidatedRetailSalesNotify"    Then ViewClient_V2.OnSetConsolidatedRetailSalesNotify(Parameters);
	ElsIf ViewNotify = "OnSetBranchNotify"                     Then ViewClient_V2.OnSetBranchNotify(Parameters);
	ElsIf ViewNotify = "OnSetStatusNotify"                     Then ViewClient_V2.OnSetStatusNotify(Parameters);
	ElsIf ViewNotify = "OnSetNumberNotify"                     Then ViewClient_V2.OnSetNumberNotify(Parameters);
	ElsIf ViewNotify = "OnSetAgreementNotify"                  Then ViewClient_V2.OnSetAgreementNotify(Parameters);
	ElsIf ViewNotify = "OnSetQuantityNotify"                   Then ViewClient_V2.OnSetQuantityNotify(Parameters);
	ElsIf ViewNotify = "OnSetUnitNotify"                       Then ViewClient_V2.OnSetUnitNotify(Parameters);
	ElsIf ViewNotify = "OnSetItemBundleNotify"                 Then ViewClient_V2.OnSetItemBundleNotify(Parameters);
	ElsIf ViewNotify = "OnSetItemKeyBundleNotify"              Then ViewClient_V2.OnSetItemKeyBundleNotify(Parameters);
	ElsIf ViewNotify = "PaymentsOnAddRowFormNotify"            Then ViewClient_V2.PaymentsOnAddRowFormNotify(Parameters);
	ElsIf ViewNotify = "PaymentsOnCopyRowFormNotify"           Then ViewClient_V2.PaymentsOnCopyRowFormNotify(Parameters);
	ElsIf ViewNotify = "OnSetItemListItemKey"                  Then ViewClient_V2.OnSetItemListItemKey(Parameters);
	ElsIf ViewNotify = "OnSetItemListItem"                     Then ViewClient_V2.OnSetItemListItem(Parameters);
	ElsIf ViewNotify = "WorkersOnCopyRowFormNotify"            Then ViewClient_V2.WorkersOnCopyRowFormNotify(Parameters);
	ElsIf ViewNotify = "WorkersOnAddRowFormNotify"             Then ViewClient_V2.WorkersOnAddRowFormNotify(Parameters);
	ElsIf ViewNotify = "MaterialsOnAddRowFormNotify"           Then ViewClient_V2.MaterialsOnAddRowFormNotify(Parameters);
	ElsIf ViewNotify = "MaterialsOnCopyRowFormNotify"          Then ViewClient_V2.MaterialsOnCopyRowFormNotify(Parameters);
	ElsIf ViewNotify = "OnSetUseGoodsReceiptNotify_IsProgramAsTrue" Then ViewClient_V2.OnSetUseGoodsReceiptNotify_IsProgramAsTrue(Parameters);
	ElsIf ViewNotify = "OnSetPlanningPeriodNotify"             Then ViewClient_V2.OnSetPlanningPeriodNotify(Parameters);
	ElsIf ViewNotify = "OnSetBusinessUnitNotify"               Then ViewClient_V2.OnSetBusinessUnitNotify(Parameters);
	ElsIf ViewNotify = "ProductionsOnAddRowFormNotify"         Then ViewClient_V2.ProductionsOnAddRowFormNotify(Parameters);
	ElsIf ViewNotify = "ProductionsOnCopyRowFormNotify"        Then ViewClient_V2.ProductionsOnCopyRowFormNotify(Parameters);
	ElsIf ViewNotify = "OnSetProductionsCurrentQuantityNotify" Then ViewClient_V2.OnSetProductionsCurrentQuantityNotify(Parameters);
	ElsIf ViewNotify = "OnSetMaterialsMaterialTypeNotify"      Then ViewClient_V2.OnSetMaterialsMaterialTypeNotify(Parameters);
	ElsIf ViewNotify = "OnSetBillOfMaterialsNotify"            Then ViewClient_V2.OnSetBillOfMaterialsNotify(Parameters);
	ElsIf ViewNotify = "OnSetItemListBillOfMaterialsNotify"    Then ViewClient_V2.OnSetItemListBillOfMaterialsNotify(Parameters);
	ElsIf ViewNotify = "OnSetTradeAgentFeeTypeNotify"          Then ViewClient_V2.OnSetTradeAgentFeeTypeNotify(Parameters);
	ElsIf ViewNotify = "ShipmentToTradeAgentOnAddRowFormNotify" Then ViewClient_V2.ShipmentToTradeAgentOnAddRowFormNotify(Parameters);
	ElsIf ViewNotify = "ReceiptFromConsignorOnAddRowFormNotify" Then ViewClient_V2.ReceiptFromConsignorOnAddRowFormNotify(Parameters);
	ElsIf ViewNotify = "OnSetBeginDateNotify" Then ViewClient_V2.OnSetBeginDateNotify(Parameters);
	ElsIf ViewNotify = "OnSetEndDateNotify"   Then ViewClient_V2.OnSetEndDateNotify(Parameters);
	
	ElsIf ViewNotify = "ProductionCostsListOnAddRowFormNotify"        Then ViewClient_V2.ProductionCostsListOnAddRowFormNotify(Parameters);
	ElsIf ViewNotify = "ProductionCostsListOnCopyRowFormNotify"       Then ViewClient_V2.ProductionCostsListOnCopyRowFormNotify(Parameters);
	ElsIf ViewNotify = "ProductionCostsListAfterDeleteRowFormNotify"  Then ViewClient_V2.ProductionCostsListAfterDeleteRowFormNotify(Parameters);
	
	ElsIf ViewNotify = "ProductionDurationsListOnAddRowFormNotify"       Then ViewClient_V2.ProductionDurationsListOnAddRowFormNotify(Parameters);
	ElsIf ViewNotify = "ProductionDurationsListOnCopyRowFormNotify"      Then ViewClient_V2.ProductionDurationsListOnCopyRowFormNotify(Parameters);
	ElsIf ViewNotify = "ProductionDurationsListAfterDeleteRowFormNotify" Then ViewClient_V2.ProductionDurationsListAfterDeleteRowFormNotify(Parameters);
		
	ElsIf ViewNotify = "PayrollListsOnAddRowFormNotify"       Then ViewClient_V2.PayrollListsOnAddRowFormNotify(Parameters);
	ElsIf ViewNotify = "PayrollListsOnCopyRowFormNotify"      Then ViewClient_V2.PayrollListsOnCopyRowFormNotify(Parameters);
	ElsIf ViewNotify = "PayrollListsAfterDeleteRowFormNotify" Then ViewClient_V2.PayrollListsAfterDeleteRowFormNotify(Parameters);
		
	ElsIf ViewNotify = "TimeSheetListOnAddRowFormNotify"       Then ViewClient_V2.TimeSheetListOnAddRowFormNotify(Parameters);
	ElsIf ViewNotify = "TimeSheetListOnCopyRowFormNotify"      Then ViewClient_V2.TimeSheetListOnCopyRowFormNotify(Parameters);
	ElsIf ViewNotify = "TimeSheetListAfterDeleteRowFormNotify" Then ViewClient_V2.TimeSheetListAfterDeleteRowFormNotify(Parameters);
	
	ElsIf ViewNotify = "EmployeeCashAdvanceOnAddRowFormNotify"         Then ViewClient_V2.EmployeeCashAdvanceOnAddRowFormNotify(Parameters);
	ElsIf ViewNotify = "EmployeeCashAdvanceOnCopyRowFormNotify"        Then ViewClient_V2.EmployeeCashAdvanceOnCopyRowFormNotify(Parameters);
	ElsIf ViewNotify = "AdvanceFromRetailCustomersOnAddRowFormNotify"  Then ViewClient_V2.AdvanceFromRetailCustomersOnAddRowFormNotify(Parameters);
	ElsIf ViewNotify = "AdvanceFromRetailCustomersOnCopyRowFormNotify" Then ViewClient_V2.AdvanceFromRetailCustomersOnCopyRowFormNotify(Parameters);
	ElsIf ViewNotify = "SalaryPaymentOnAddRowFormNotify"               Then ViewClient_V2.SalaryPaymentOnAddRowFormNotify(Parameters);
	ElsIf ViewNotify = "SalaryPaymentOnCopyRowFormNotify"              Then ViewClient_V2.SalaryPaymentOnCopyRowFormNotify(Parameters);
	
	ElsIf ViewNotify = "OnSetPayrollListsAmountNotify" Then ViewClient_V2.OnSetPayrollListsAmountNotify(Parameters);
	
	Else
		Raise StrTemplate("Not handled view notify [%1]", ViewNotify);
	EndIf;
EndProcedure	
#ENDIF

Function IsFullTransferTabularSection(Parameters, PropertyName)
	_PropertyName = Upper(PropertyName);
	If _PropertyName = Upper("TaxList") 
		Or _PropertyName = Upper("SerialLotNumbers") 
		Or _PropertyName = Upper("SpecialOffers")
		Or _PropertyName = Upper("BillOfMaterialsList") Then
		Return True;
	ElsIf _PropertyName = Upper("Materials") Then
		If Parameters.IsFullRefill_Materials = True Then
			Return True;
		Else
			Return False;
		EndIf;
	EndIf;
	Return False;
EndFunction

Function IsFullLoadTabularSection(Parameters, PropertyName)
	_PropertyName = Upper(PropertyName);
	If _PropertyName = Upper("ConsignorBatches")
		Or _PropertyName = Upper("SourceOfOrigins") Then
		Return True;
	EndIf;
	Return False;
EndFunction

// move changes from Cache to Object form CacheForm to Form
Procedure _CommitChainChanges(Cache, Source, Parameters)
	For Each Property In Cache Do
		PropertyName  = Property.Key;
		PropertyValue = Property.Value;
		
		If IsFullTransferTabularSection(Parameters, PropertyName) Then	
			// tabular part transferred completely
			ArrayOfKeys = New Array();
			For Each Row In PropertyValue Do
				If ArrayOfKeys.Find(Row.Key) = Undefined Then
					ArrayOfKeys.Add(Row.Key);
				EndIf;
			EndDo;
			
			For Each ItemOfKeys In ArrayOfKeys Do
				For Each Row In Source[PropertyName].FindRows(New Structure("Key", ItemOfKeys)) Do
					Source[PropertyName].Delete(Row);
				EndDo;
			EndDo;
			
			For Each Row In PropertyValue Do
				FillPropertyValues(Source[PropertyName].Add(), Row);
			EndDo;
		
		ElsIf IsFullLoadTabularSection(Parameters, PropertyName) Then
		
			Source[PropertyName].Clear();
			
			For Each Row In PropertyValue Do
				FillPropertyValues(Source[PropertyName].Add(), Row);
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

Procedure RollbackPropertyToValueBeforeChange_Object(Parameters)
	If Parameters.PropertyBeforeChange.Object.Value <> Undefined Then
		DataPath          = Parameters.PropertyBeforeChange.Object.Value.DataPath;
		ValueBeforeChange = Parameters.PropertyBeforeChange.Object.Value.ValueBeforeChange;
		CurrentValue      = GetPropertyObject(Parameters, DataPath);
		Parameters.Object[DataPath] = ValueBeforeChange;
		SetPropertyObject(Parameters, DataPath, , CurrentValue);
	EndIf;
EndProcedure

Procedure RollbackPropertyToValueBeforeChange_Form(Parameters)
	If Parameters.PropertyBeforeChange.Form.Value <> Undefined Then
		DataPath          = Parameters.PropertyBeforeChange.Form.Value.DataPath;
		ValueBeforeChange = Parameters.PropertyBeforeChange.Form.Value.ValueBeforeChange;
		CurrentValue      = GetPropertyForm(Parameters, DataPath);
		Parameters.Form[DataPath] = ValueBeforeChange;
		SetPropertyForm(Parameters, DataPath, , CurrentValue);
	EndIf;
EndProcedure

Procedure RollbackPropertyToValueBeforeChange_List(Parameters)
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
			 	SourceRow = Parameters.SourceTableMap.Get(TableName + ":" + Row.Key);
			 	SourceRow[ColumnName] = Row[ColumnName];
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

Procedure MultiSetterObject(Parameters, Results, ResourceToBinding, ViewNotify = Undefined)
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
			SetterObject(Binding.StepsEnabler, Binding.DataPath , Parameters, _Results, ViewNotify);
		ElsIf Segments.Count() = 2 Then // it is column of table
			SetterObject(Binding.StepsEnabler, Binding.DataPath , Parameters, Results, ViewNotify, Resource);
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
	DisableNextSteps = False;
	For Each Result In Results Do
		_Key   = Result.Options.Key;
		If ValueIsFilled(ValueDataPath) Then
			_Value = ?(Result.Value = Undefined, Undefined, Result.Value[ValueDataPath]);
		Else
			_Value = Result.Value;
		EndIf;
		If Result.Options.Property("DisableNextSteps") And Result.Options.DisableNextSteps = True Then
			DisableNextSteps = True;
		EndIf;
		If Source = "Object" And SetPropertyObject(Parameters, DataPath, _Key, _Value, ReadOnlyFromCache) Then
			IsChanged = True;
		EndIf;
		If Source = "Form" And SetPropertyForm(Parameters, DataPath, _Key, _Value, ReadOnlyFromCache) Then
			IsChanged = True;
		EndIf;
	EndDo;
	If IsChanged Or NotifyAnyWay Or Parameters.LoadData.ExecuteAllViewNotify Then
		AddViewNotify(ViewNotify, Parameters);
	EndIf;
	If ValueIsFilled(StepNames) And Not DisableNextSteps Then
		RegisterNextSteps(Parameters, IsChanged, StepNames, DataPath);
	EndIf;
EndProcedure

Procedure RegisterNextSteps(Parameters, IsChanged, StepNames, DataPath)
	// property is changed and have next steps
	// or property is ReadInly, add to next steps
	NeedRegister = False;
	If IsChanged Then
		NeedRegister = True;
	ElsIf Parameters.ReadOnlyPropertiesMap.Get(Upper(DataPath)) = True Then
		If Parameters.ProcessedReadOnlyPropertiesMap.Get(Upper(DataPath)) = Undefined Then
			Parameters.ProcessedReadOnlyPropertiesMap.Insert(Upper(DataPath), True);
			NeedRegister = True;
		EndIf;
	EndIf;
	
	If NeedRegister Then
		ArrayOfNextStepNames = StepNamesToArray(StepNames);
		For Each NextStepName In ArrayOfNextStepNames Do
			If Parameters.NextSteps.Find(NextStepName) = Undefined Then
				Parameters.NextSteps.Add(NextStepName);
			EndIf;
		EndDo;
	EndIf;
EndProcedure

Procedure LaunchNextSteps(Parameters) Export
	Steps = StrConcat(Parameters.NextSteps, ",");
	Parameters.NextSteps.Clear();
	ModelClientServer_V2.EntryPoint(Steps, Parameters);
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
		Return GetProperty(Parameters, Parameters.CacheForm, Parameters.Form, DataPath, Key, ReadOnlyFromCache);
	Else
		Return Undefined;
	EndIf;
EndFunction

Function GetPropertyObject(Parameters, DataPath, Key = Undefined, ReadOnlyFromCache = False)
	Return GetProperty(Parameters, Parameters.Cache, Parameters.Object, DataPath, Key, ReadOnlyFromCache);
EndFunction

// parameter Key used when DataPath points to the attribute of the tabular section, for example, ItemList.PriceType
Function GetProperty(Parameters, Cache, Source, DataPath, Key, ReadOnlyFromCache)
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
		Row = GetRowFromTableCache(Parameters, TableName, Key);
		If Row <> Undefined And Row.Property(ColumnName) Then
			RowByKey = Row;
		EndIf;
		// not found in cache
		If RowByKey = Undefined Then
			If ReadOnlyFromCache Then
				Return Undefined;
			EndIf;
			
			RowByKey = Parameters.SourceTableMap.Get(TableName + ":" + Key);
			If RowByKey = Undefined Then
				Raise StrTemplate("Not found row in SourceTableMap [%1] [%2]", TableName, Key);
			EndIf;
			
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
				
				TableRows = GetRows(Parameters, TableName);
				UseMap = (TypeOf(TableRows) = Type("Array"));
				RowInMap = False;
				
				If UseMap Then
					Row = Parameters.TableRowsMap.Get(TableName + ":" + _Key);
					If Row <> Undefined Then
						RowInMap = True;
						If ReadOnlyPropertyIsFilled(Parameters, Row, PropertyName, TableName) Then
							Return False;
						EndIf;
					EndIf;
				EndIf;
						
				// not found in map
				If Not RowInMap Then
					For Each Row In GetRows(Parameters, TableName) Do
						If Row.Key = _Key Then
							If UseMap Then
								Parameters.TableRowsMap.Insert(TableName + ":" + _Key, Row);
							EndIf;
							If ReadOnlyPropertyIsFilled(Parameters, Row, PropertyName, TableName) Then
								Return False; // property is ReadOnly and filled, do not change
							EndIf;
							Break;
						EndIf;
					EndDo;
				EndIf;

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
	IsChanged = SetProperty(Parameters, Parameters.Cache, DataPath, _Key, _Value);
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
	IsChanged = SetProperty(Parameters, Parameters.CacheForm, DataPath, _Key, _Value);
	If IsChanged Then
		PutToChangedData(Parameters, DataPath, CurrentValue, _Value, _Key);
	EndIf;
	Return IsChanged;
EndFunction

Function ReadOnlyPropertyIsFilled(Parameters, Row, PropertyName, TableName)
	// when IsLoadData all values of ReadOnlyProperty in cache
	If Parameters.IsLoadData Or Parameters.IsAddFilledRow Then
		CacheRow = GetRowFromTableCache(Parameters, TableName, Row.Key);
		If CacheRow <> Undefined Then
			If CacheRow.Property(PropertyName) And ValueIsFilled(CacheRow[PropertyName]) Then
				Return True; // filled
			EndIf;
		EndIf;
	Else
		Return ValueIsFilled(Row[PropertyName]);
	EndIf;
	Return False; // not filled
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

Function IsChangedProperty(Parameters, DataPath, _Key = Undefined) Export
	Result = New Structure("IsChanged, OldValue, NewValue", False, Undefined, Undefined);
	Changes = Parameters.ChangedData.Get(DataPath);
	If  Changes <> Undefined Then
		If _Key = Undefined Then
			Result.IsChanged = True;
			Result.NewValue  = Changes[0].NewValue;
			Result.OldValue  = Changes[0].OldValue;
		Else
			For Each Row In Changes Do
				If Row.Key = _Key Then
					Result.IsChanged = True;
					Result.NewValue  = Row.NewValue;
					Result.OldValue  = Row.OldValue;
				EndIf;
			EndDo;
		EndIf;
	EndIf;
	Return Result;
EndFunction

Function IsChangedPropertyDirectly_List(Parameters, _Key) Export
	Result = New Structure("IsChanged, OldValue, NewValue", False, Undefined, Undefined);
	If Parameters.PropertyBeforeChange.List.Value = Undefined Then
		Return Result;
	EndIf;
	DataPath   = Parameters.PropertyBeforeChange.List.Value.DataPath;
	ColumnName = Parameters.PropertyBeforeChange.List.Value.ColumnName;
	ArrayOfValuesBeforeChange = Parameters.PropertyBeforeChange.List.Value.ArrayOfValuesBeforeChange;
	OldValue = Undefined;
	For Each Row In ArrayOfValuesBeforeChange Do
		If Row.Key = _Key Then
			OldValue = Row[ColumnName];
			Break;
		EndIf;
	EndDo;
	CurrentValue = GetPropertyObject(Parameters, DataPath, _Key);
	Result.IsChanged = (CurrentValue <> OldValue);
	Result.NewValue = CurrentValue;
	Result.OldValue = OldValue;
	Return Result;
EndFunction

Function IsChangedPropertyDirectly_Object(Parameters) Export
	Result = New Structure("IsChanged, OldValue, NewValue", False, Undefined, Undefined);
	If Parameters.PropertyBeforeChange.Object.Value = Undefined Then
		Return Result;
	EndIf;
	
	DataPath         = Parameters.PropertyBeforeChange.Object.Value.DataPath;
	OldValue         = Parameters.PropertyBeforeChange.Object.Value.ValueBeforeChange;
	CurrentValue     = GetPropertyObject(Parameters, DataPath);
	Result.IsChanged = (CurrentValue <> OldValue);
	Result.NewValue  = CurrentValue;
	Result.OldValue  = OldValue;
	Return Result;
EndFunction	

// sets properties on the passed DataPath, such as ItemList.PriceType or Company
Function SetProperty(Parameters, Cache, DataPath, _Key, _Value)
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
			AddTableToCache(Parameters, TableName);
		EndIf;
		IsRowExists = False;
		Row = GetRowFromTableCache(Parameters, TableName, _Key);
		If Row <> Undefined Then
			Row.Insert(ColumnName, _Value);
			IsRowExists = True;
		EndIf;
		
		If Not IsRowExists Then
			NewRow = New Structure();
			NewRow.Insert("Key"      , _Key);
			NewRow.Insert(ColumnName , _Value);
			AddRowToTableCache(Parameters, TableName, NewRow);
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

Function BindSteps(DefaulStepsEnabler, DataPath, Binding, Parameters, BindName)
	Result = Parameters.BindingMap.Get(BindName);
	If Result <> Undefined Then
		Return Result;
	EndIf;
	
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
		ObjectName = KeyValue.Key;
		ObjectNameSegments = StrSplit(ObjectName, "__", False);
		If ObjectNameSegments.Count() = 2 And Parameters.TableName <> ObjectNameSegments[1] Then
			Continue;
		EndIf;
		MetadataBinding.Insert(ObjectNameSegments[0] + "." + DataPath, Binding[ObjectName]);
	EndDo;
	
	FullDataPath = Parameters.ObjectMetadataInfo.MetadataName + "." + DataPath;
	StepsEnabler = MetadataBinding.Get(FullDataPath);
	StepsEnabler = ?(StepsEnabler = Undefined, DefaulStepsEnabler, StepsEnabler);
	If Not ValueIsFilled(StepsEnabler) Then
		Raise StrTemplate("Steps enabler is not defined [%1]", DataPath);
	EndIf;
	
	Result.FullDataPath = FullDataPath;
	Result.StepsEnabler = StepsEnabler;
	Result.DataPath     = DataPath;
	
	Parameters.BindingMap.Insert(BindName, Result);
	
	Return Result;
EndFunction

Function IsUserChange(Parameters, StepName)
	If Parameters.Property("IsProgramChange") And Parameters.IsProgramChange Then
		Return False; // Is programm change via scan barcode or other external forms
	EndIf;
	
	If Parameters.Property("ModelEnvironment") 
		And Parameters.ModelEnvironment.Property("StepNamesCounter") 
		And Parameters.ModelEnvironment.StepNamesCounter.Count() Then
		ArrayOfStepNames = StepNamesToArray(Parameters.ModelEnvironment.StepNamesCounter[0]);
		If ArrayOfStepNames.Find(StepName) <> Undefined Then
			Return True;
		EndIf;
		Return False;
	EndIf;
	Return False;
EndFunction

Function StepNamesToArray(StepNames)
	ArrayOfStepNames = New Array();
	For Each StepName In StrSplit(StepNames, ",") Do
		ArrayOfStepNames.Add(StrReplace(TrimAll(StepName), Chars.NBSp, ""));
	EndDo;
	Return ArrayOfStepNames;
EndFunction

Procedure AddTableToCache(Parameters, TableName)
	Parameters.Cache.Insert(TableName, New Array());
EndProcedure

Procedure AddRowToTableCache(Parameters, TableName, Row)
	Parameters.Cache[TableName].Add(Row);
	Parameters.CacheRowsMap.Insert(TableName + ":" + Row.Key, Row);
EndProcedure

Function GetRowFromTableCache(Parameters, TableName, _Key)
	Return Parameters.CacheRowsMap.Get(TableName + ":" + _Key);
EndFunction

Procedure UpdateTableCacheRemovable(Parameters, TableName, ArrayOfRows)
	For Each Result In ArrayOfRows Do
		If Not Result.Value[TableName].Count() Then
			Continue;
		EndIf;
		
		DeleteRowFromTableCacheRemovable(Parameters, TableName, Result.Options.Key);
		
		For Each NewRow In Result.Value[TableName] Do
			AddRowToTableCacheRemovable(Parameters, TableName, NewRow);
		EndDo;
	EndDo;
EndProcedure

Procedure AddTableToCacheRemovable(Parameters, TableName)
	Parameters.Cache.Insert(TableName, New Array());
	Parameters.CacheRowsRemovable.Insert(TableName, New Array());
EndProcedure

Procedure AddRowToTableCacheRemovable(Parameters, TableName, Row)
	Parameters.Cache[TableName].Add(Row);
	Parameters.CacheRowsRemovable[TableName].Add(Row.Key);
EndProcedure

Procedure DeleteRowFromTableCacheRemovable(Parameters, TableName, Key)
	Index = Parameters.CacheRowsRemovable[TableName].Find(Key);
	While Index <> Undefined Do
		Parameters.CacheRowsRemovable[TableName].Delete(Index);
		Parameters.Cache[TableName].Delete(Index);
		Index = Parameters.CacheRowsRemovable[TableName].Find(Key);
	EndDo;
EndProcedure

#IF Server THEN

Function AddLinkedDocumentRows(Object, Form, LinkedResult, TableName) Export
	If Not ValueIsFilled(LinkedResult) Then
		Return Undefined;
	EndIf;
	FormParameters = GetFormParameters(Form);
	ServerParameters = GetServerParameters(Object);
	ServerParameters.TableName = TableName;
	ServerParameters.IsBasedOn = True;
	ServerParameters.ReadOnlyProperties = LinkedResult.UpdatedProperties;
	ServerParameters.Rows = LinkedResult.Rows;
		
	Parameters = GetParameters(ServerParameters, FormParameters);
	For Each PropertyName In StrSplit(ServerParameters.ReadOnlyProperties, ",") Do
		If StrStartsWith(TrimAll(PropertyName), TableName) Then
			Property = New Structure("DataPath", TrimAll(PropertyName));
			API_SetProperty(Parameters, Property, Undefined);
		EndIf;
	EndDo;
	
//	If Object.Ref.Metadata().TabularSections.Find(TableName).Attributes.Find("DontCalculateRow") <> Undefined Then
//		PropertyName = TableName + ".DontCalculateRow";
//		Property = New Structure("DataPath", TrimAll(PropertyName));
//		FormParameters = GetFormParameters(Form);
//		ServerParameters = GetServerParameters(Object);
//		ServerParameters.TableName = TableName;
//		ServerParameters.IsBasedOn = False;
//		ServerParameters.ReadOnlyProperties = PropertyName;
//		ServerParameters.Rows = LinkedResult.Rows;
//		Parameters = GetParameters(ServerParameters, FormParameters);
//		API_SetProperty(Parameters, Property, Undefined);
//	EndIf;

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

Procedure SetReadOnlyProperties(Object, FillingData, ExcludedTabularSections = Undefined) Export
	HeaderProperties = New Array();
	TabularProperties = New Array();
	For Each KeyValue In FillingData Do
		Property = KeyValue.Key;
		Value    = KeyValue.Value;
		If Not CommonFunctionsClientServer.ObjectHasProperty(Object, Property) Then
			Continue;
		EndIf;
					
		If TypeOf(Value) = Type("Array") Then // is tabular section
			IsExcludedTabularSection = False;
			If ExcludedTabularSections <> Undefined Then
				ArrayOfExcludedTabularSections = StrSplit(ExcludedTabularSections, ",");
				For Each TabularSectionName in ArrayOfExcludedTabularSections Do
					If StrStartsWith(TrimAll(Property), TrimAll(TabularSectionName)) Then
						IsExcludedTabularSection = True;
						Break;
					EndIf;
				EndDo;
			EndIf;
			
			If IsExcludedTabularSection Then
				Continue;
			EndIf;
			
			If Value.Count() Then
				For Each Column In Value[0] Do
					If Object.Metadata().TabularSections[Property].Attributes.Find(Column.Key) <> Undefined Then
						TabularProperties.Add(StrTemplate("%1.%2", Property, Column.Key));
					EndIf;
				EndDo;
			EndIf;
		Else // is header property
			HeaderProperties.Add(Property);
		EndIf;
	EndDo;
	ReadOnlyProperties = StrConcat(HeaderProperties, ",") + "," + StrConcat(TabularProperties, ",");
	Object.AdditionalProperties.Insert("ReadOnlyProperties", ReadOnlyProperties);
	Object.AdditionalProperties.Insert("IsBasedOn", True);
EndProcedure

Procedure LoaderTable(DataPath, Parameters, Result) Export
	If Result.Count() <> 1 Then
		Raise "load more than one table not implemented";
	EndIf;
	
	SourceTable       = New ValueTable();
	SourceTableBuffer = New ValueTable();
	TempStorageData = GetFromTempStorage(Result[0].Value);
	If TypeOf(TempStorageData) = Type("ValueTable") Then
		SourceTable = TempStorageData;
	ElsIf TypeOf(TempStorageData) = Type("Structure") Then
		SourceTable = TempStorageData.SourceTable;
		SourceTableBuffer = TempStorageData.SourceTableBuffer;
	Else
		Raise "not supported temp storage data type";
	EndIf;
		
	SourceTableExpanded = New ValueTable();;
	If Parameters.SerialLotNumbersExists Then
		SourceTableExpanded = SourceTable.Copy();
	EndIf;
	
	SourceColumnsGroupBy = Parameters.LoadData.SourceColumnsGroupBy;
	SourceColumnsSumBy   = Parameters.LoadData.SourceColumnsSumBy;
	
	SourceTable.GroupBy(SourceColumnsGroupBy, SourceColumnsSumBy);
	
	SourceTable.Columns.Add("UniqueBufferKey");
	SourceTableExpanded.Columns.Add("UniqueBufferKey");
	
	For Each Row In SourceTableBuffer Do
		UniqueBufferKey = New UUID();
		
		NewRowSourceTable = SourceTable.Add(); 
		FillPropertyValues(NewRowSourceTable, Row);
		NewRowSourceTable.UniqueBufferKey = UniqueBufferKey;
		
		If Parameters.SerialLotNumbersExists Then
			NewRowSourceTableExpanded = SourceTableExpanded.Add();
			FillPropertyValues(NewRowSourceTableExpanded, Row);
			NewRowSourceTableExpanded.UniqueBufferKey = UniqueBufferKey;
		EndIf;
	EndDo;
	
	// only for physical inventory
	If Parameters.ObjectMetadataInfo.MetadataName = "PhysicalInventory"
		Or Parameters.ObjectMetadataInfo.MetadataName = "PhysicalCountByLocation" Then
		SourceTable.Columns.Quantity.Name = "PhysCount";
	EndIf;
	
	TableName = Parameters.TableName;
	
	// initialize cache
	If Not Parameters.Cache.Property(TableName) Then
		AddTableToCache(Parameters, TableName);
	EndIf;
	If Parameters.SerialLotNumbersExists And Not Parameters.Cache.Property("SerialLotNumbers") Then
		AddTableToCache(Parameters, "SerialLotNumbers");
	EndIf;
	If Parameters.SourceOfOriginsExists And Not Parameters.Cache.Property("SourceOfOrigins") Then
		AddTableToCache(Parameters, "SourceOfOrigins");
	EndIf;
	
	AllExtractedData = New Structure();
	
	AllRows = New Array();
	For Each Row In Parameters.Rows Do
		AllRows.Add(Row);
	EndDo;
	
	API_Settings = API_GetSettings();
	API_Settings.CommitPropertyWithoutSetter = False;
	API_Settings.LaunchStepsImmediately = False;
	
	IsFirstRow = True;
	DefaultFilledRow = New Structure();
	
	RowIndex = Parameters.Rows.Count() - Parameters.LoadData.CountRows;
	For Each SourceRow In SourceTable Do
		NewRow =  AllRows[RowIndex];
		Parameters.Rows.Clear();
		Parameters.Rows.Add(NewRow);
		
		// add serial lot number to separated table
		If Parameters.SerialLotNumbersExists Then
			Filter = New Structure(SourceColumnsGroupBy + ", UniqueBufferKey");
			FillPropertyValues(Filter, SourceRow);
			For Each RowSN In SourceTableExpanded.FindRows(Filter) Do
				If Not ValueIsFilled(RowSN.SerialLotNumber) Then
					Continue;
				EndIf;
				NewRowSN = New Structure(Parameters.ObjectMetadataInfo.Tables.SerialLotNumbers.Columns);
				FillPropertyValues(NewRowSN, RowSN);
				NewRowSN.Key = NewRow.Key;
				AddRowToTableCache(Parameters, "SerialLotNumbers", NewRowSN);
			EndDo;
		EndIf;
		
		// add source of origins to separeted table
		If Parameters.SourceOfOriginsExists Then
			Filter = New Structure(SourceColumnsGroupBy);
			FillPropertyValues(Filter, SourceRow);
			For Each RowSoO In SourceTableExpanded.FindRows(Filter) Do
				NewRowSoO = New Structure(Parameters.ObjectMetadataInfo.Tables.SourceOfOrigins.Columns);
				FillPropertyValues(NewRowSoO, RowSoO);
				NewRowSoO.Key = NewRow.Key;
				AddRowToTableCache(Parameters, "SourceOfOrigins", NewRowSoO);
			EndDo;
		EndIf;
			
		// fill new row default values from user settings
		tmpRow = New Structure("Key", NewRow.Key);
		
		If IsFirstRow Then
			IsFirstRow = False;
			AddNewRow(TableName, Parameters, , False);
			LaunchNextSteps(Parameters);
			If Parameters.Cache[TableName].Count() Then
				For Each KeyValue In Parameters.Cache[TableName][0] Do
					If Upper(KeyValue.Key) = Upper("Key") Then
						Continue;
					EndIf;
					DefaultFilledRow.Insert(KeyValue.Key, KeyValue.Value);
				EndDo;
			Else
				AddRowToTableCache(Parameters, TableName, tmpRow);
			EndIf;
		Else
			AddRowToTableCache(Parameters, TableName, tmpRow);
			
			For Each KeyValue In DefaultFilledRow Do
				DataPath = TrimAll(StrTemplate("%1.%2", TableName, KeyValue.Key));
				Property = New Structure("DataPath", DataPath);
				API_SetProperty(Parameters, Property, KeyValue.Value, , API_Settings);
			EndDo;
		EndIf;
		
		CacheRow = GetRowFromTableCache(Parameters, TableName, NewRow.Key);
		
		// initialize read only parameters for each row
		Parameters.ReadOnlyPropertiesMap.Clear();
		Parameters.ProcessedReadOnlyPropertiesMap.Clear();
		
		ReadOnlyDataPaths = New Array();
		FilledColumns = New Array();
		
		// data from source row
		For Each Column In SourceTable.Columns Do
			If Not CommonFunctionsClientServer.ObjectHasProperty(NewRow, Column.Name) Then
				Continue;
			EndIf;
			SourceRowValue = SourceRow[Column.Name];
			
			If ?(TypeOf(SourceRowValue) = Type("Boolean"), SourceRowValue, ValueIsFilled(SourceRowValue)) Then
				DataPath = TrimAll(StrTemplate("%1.%2", TableName, Column.Name));
				
				FilledColumns.Add(New Structure("DataPath, Column, Value", 
					DataPath, Column.Name, SourceRowValue));
					
				ReadOnlyDataPaths.Add(DataPath);
				Parameters.ReadOnlyPropertiesMap.Insert(Upper(DataPath), True);				
			EndIf;
		EndDo;
				
		// if columns filled from source, do not change value, even is wrong value
		Parameters.ReadOnlyProperties = StrConcat(ReadOnlyDataPaths, ",");
		For Each FilledColumn In FilledColumns Do
			Property = New Structure("DataPath", FilledColumn.DataPath);
			API_SetProperty(Parameters, Property, FilledColumn.Value, , API_Settings);
			CacheRow[FilledColumn.Column] = FilledColumn.Value;
		EndDo;
		RowIndex = RowIndex + 1;
		
		LaunchNextSteps(Parameters);
				
	EndDo;
	Parameters.ExtractedData = AllExtractedData;
EndProcedure

#ENDIF
