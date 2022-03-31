
#Region CACHE_BEFORE_CHANGE

Function GetSimpleParameters(Object, Form, TableName, Rows = Undefined)
	FormParameters   = GetFormParameters(Form);
	ServerParameters = GetServerParameters(Object);
	ServerParameters.TableName = TableName;
	ServerParameters.Rows      = Rows;
	Return GetParameters(ServerParameters, FormParameters);
EndFunction

Function GetFormParameters(Form)
	FormParameters   = ControllerClientServer_V2.GetFormParameters(Form);
	FormParameters.PropertyBeforeChange.Object.Names = GetObjectPropertyNamesBeforeChange();
	FormParameters.PropertyBeforeChange.Form.Names   = GetFormPropertyNamesBeforeChange();
	FormParameters.PropertyBeforeChange.List.Names   = GetListPropertyNamesBeforeChange();
	Return FormParameters;
EndFunction

Function GetServerParameters(Object)
	Return ControllerClientServer_V2.GetServerParameters(Object);
EndFunction

Function GetParameters(ServerParameters, FormParameters = Undefined)
	Return ControllerClientServer_V2.GetParameters(ServerParameters, FormParameters);
EndFunction

Procedure ExtractValueBeforeChange_Object(DataPath, FormParameters)
	FormParameters.PropertyBeforeChange.Object.DataPath = DataPath;
	ExtractValueBeforeChange(FormParameters, Undefined);
EndProcedure

Procedure ExtractValueBeforeChange_Form(DataPath, FormParameters)
	FormParameters.PropertyBeforeChange.Form.DataPath = DataPath;
	ExtractValueBeforeChange(FormParameters, Undefined);
EndProcedure

Procedure ExtractValueBeforeChange_List(DataPath, FormParameters, Rows)
	FormParameters.PropertyBeforeChange.List.DataPath = DataPath;
	ExtractValueBeforeChange(FormParameters, Rows);
EndProcedure

Procedure ExtractValueBeforeChange(FormParameters, Rows)

	If ValueIsFilled(FormParameters.PropertyBeforeChange.Object.DataPath) 
		Or ValueIsFilled(FormParameters.PropertyBeforeChange.Form.DataPath)
		Or ValueIsFilled(FormParameters.PropertyBeforeChange.List.DataPath) Then
		
		CacheBeforeChange = CommonFunctionsServer.DeserializeXMLUseXDTO(FormParameters.Form.CacheBeforeChange);
		
		If ValueIsFilled(FormParameters.PropertyBeforeChange.Object.DataPath) Then
			FormParameters.PropertyBeforeChange.Object.Value = 
				GetCacheBeforeChange(CacheBeforeChange.CacheObject, FormParameters.PropertyBeforeChange.Object.DataPath);
		EndIf;
		If ValueIsFilled(FormParameters.PropertyBeforeChange.Form.DataPath) Then
			FormParameters.PropertyBeforeChange.Form.Value = 
				GetCacheBeforeChange(CacheBeforeChange.CacheForm, FormParameters.PropertyBeforeChange.Form.DataPath);
		EndIf;
		If ValueIsFilled(FormParameters.PropertyBeforeChange.List.DataPath) Then
			If Rows = Undefined Then
				Raise "PropertyBeforeChange.List.DataPath is set but rows is Undefined";
			EndIf;
			FormParameters.PropertyBeforeChange.List.Value = 
				GetCacheBeforeChange(CacheBeforeChange.CacheList, FormParameters.PropertyBeforeChange.List.DataPath, Rows);
		EndIf;
	EndIf;
EndProcedure

Function GetCacheBeforeChange(Cache, DataPath, Rows = Undefined)
	Segments = StrSplit(DataPath, ".");
	If Segments.Count() = 2 Then
		If Rows = Undefined Then
			Raise StrTemplate("Error read data from cache by data path [%1] rows is Udefined", DataPath);
		EndIf;
		TableName  = Segments[0];
		ColumnName = Segments[1];
		ArrayOfValuesBeforeChange = New Array();
		For Each Row In Rows Do
			For Each CacheRow In Cache[TableName] Do
				If Row.Key = CacheRow.Key Then
					NewRow = New Structure("Key", Row.Key);
					NewRow.Insert(ColumnName, CacheRow[ColumnName]);
					ArrayOfValuesBeforeChange.Add(NewRow);
					Break;
				EndIf;
			EndDo;
		EndDo;
		Result = New Structure();
		Result.Insert("DataPath"   , DataPath);
		Result.Insert("TableName"  , TableName);
		Result.Insert("ColumnName" , ColumnName);
		Result.Insert("ArrayOfValuesBeforeChange", ArrayOfValuesBeforeChange);
		Return Result;
	ElsIf Segments.Count() = 1 Then
		If Not Cache.Property(DataPath) Then
			Raise StrTemplate("Property by DataPath [%1] not found in CacheBeforeChange", DataPath);
		EndIf;
		// value in attribute before it was changed
		ValueBeforeChange = Cache[DataPath];
		Return New Structure("DataPath, ValueBeforeChange", DataPath, ValueBeforeChange);
	Else
		Raise StrTemplate("Wrong property data path [%1]", DataPath);
	EndIf;
EndFunction

// stores attribute values before changing
Procedure UpdateCacheBeforeChange(Object, Form)
	// Object properties to be cached
	CacheObject = New Structure(GetObjectPropertyNamesBeforeChange());
	FillPropertyValues(CacheObject, Object);
	
	// Form properties to be cached
	CacheForm = New Structure(GetFormPropertyNamesBeforeChange());
	FillPropertyValues(CacheForm, Form);
	
	// Tables properties to be cached
	CacheList = New Structure();
	Tables    = New Structure();
	ListProperties = StrSplit(GetListPropertyNamesBeforeChange(), ",");
	For Each ListProperty In ListProperties Do
		Segments = StrSplit(ListProperty, ".");
		If Segments.Count() <> 2 Then
			Raise StrTemplate("Wrong list property [%1]", ListProperty);
		EndIf;
		TableName  = TrimAll(Segments[0]);
		ColumnName = TrimAll(Segments[1]);
		
		If Not CommonFunctionsClientServer.ObjectHasProperty(Object, TableName) Then
			Continue;
		EndIf;
		
		If Not Tables.Property(TableName) Then
			Tables.Insert(TableName, New Array());
		EndIf;
		If Tables[TableName].Find(ColumnName) = Undefined Then
			Tables[TableName].Add(ColumnName);
		EndIf;
	EndDo;
	
	For Each KeyValue In Tables Do
		TableName   = KeyValue.Key;
		ColumnNames = KeyValue.Value;
		
		CacheList.Insert(TableName, New Array());
		For Each Row In Object[TableName] Do
			NewRow = New Structure(StrConcat(ColumnNames, ","));
			NewRow.Insert("Key");
			FillPropertyValues(NewRow, Row);
			CacheList[TableName].Add(NewRow);
		EndDo;
	EndDo;
	
	CacheBeforeChange = New Structure();
	CacheBeforeChange.Insert("CacheObject", CacheObject);
	CacheBeforeChange.Insert("CacheForm"  , CacheForm);
	CacheBeforeChange.Insert("CacheList"  , CacheList);
	Form.CacheBeforeChange = CommonFunctionsServer.SerializeXMLUseXDTO(CacheBeforeChange);
EndProcedure

// returns list of Object attributes for get value before the change
Function GetObjectPropertyNamesBeforeChange()
	Return "Date,
		|Company,
		|Store,
		|Partner,
		|Agreement,
		|Currency,
		|Account,
		|CashAccount,
		|TransactionType,
		|Sender,
		|Receiver,
		|CashTransferOrder,
		|RetailCustomer";
EndFunction

// returns list of Table attributes for get value before the change
Function GetListPropertyNamesBeforeChange()
	Return "ItemList.Store, ItemList.DeliveryDate";
EndFunction

// returns list of Form attributes for get value before the change
Function GetFormPropertyNamesBeforeChange()
	Return "Store, DeliveryDate";
EndFunction

#EndRegion

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

#Region ON_CHAIN_COMPLETE

Procedure OnChainComplete(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "SalesInvoice"
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseInvoice"
		Or Parameters.ObjectMetadataInfo.MetadataName = "RetailSalesReceipt" Then
		__tmp_SalesPurchaseInvoice_OnChainComplete(Parameters);
		Return;
	EndIf;
	
	If Parameters.ObjectMetadataInfo.MetadataName = "BankPayment"
		Or Parameters.ObjectMetadataInfo.MetadataName = "BankReceipt"
		Or Parameters.ObjectMetadataInfo.MetadataName = "CashPayment"
		Or Parameters.ObjectMetadataInfo.MetadataName = "CashReceipt" Then
		__tmp_BankCashPaymentReceipt_OnChainComplete(Parameters);
		Return;
	EndIf;
	
	If Parameters.ObjectMetadataInfo.MetadataName = "MoneyTransfer" Then
		__tmp_MoneyTransfer_OnChainComplete(Parameters);
		Return;
	EndIf;
	 
	If Parameters.ObjectMetadataInfo.MetadataName = "CashExpense"
		Or Parameters.ObjectMetadataInfo.MetadataName = "CashRevenue" Then
		__tmp_CashExpenseRevenue_OnChainComplete(Parameters);
		Return;
	EndIf;
	
	If Parameters.ObjectMetadataInfo.MetadataName = "ShipmentConfirmation"
		Or Parameters.ObjectMetadataInfo.MetadataName = "GoodsReceipt" Then
		__tmp_GoodsShipmentReceipt_OnChainComplete(Parameters);
		Return;
	EndIf;
	CommitChanges(Parameters);
EndProcedure

Procedure CommitChanges(Parameters)
	ControllerClientServer_V2.CommitChainChanges(Parameters);
	UpdateCacheBeforeChange(Parameters.Object, Parameters.Form);
EndProcedure

#Region QUESTIONS_TO_USER

Function NeedQueryStoreOnUserChange(Parameters)
	If Parameters.Cache.Property("ItemList") Then
		For Each Row In Parameters.Cache.ItemList Do
			If Row.Property("Store") Then
				Return True;
			EndIf;
		EndDo;
	EndIf;
	Return False;
EndFunction

Function NeedCommitChangesItemListStoreOnUserChange(Parameters)
	If Parameters.Cache.Property("ItemList") Then
		For Each Row In Parameters.Cache.ItemList Do
			
			IsService = False;
			If Parameters.ExtractedData.Property("DataItemKeyIsService") Then
				For Each RowData In Parameters.ExtractedData.DataItemKeyIsService Do
					If RowData.Key = Row.Key Then
						IsService = RowData.IsService;
						Break;
					EndIf;
				EndDo;
			EndIf;
			
			If Row.Property("Store") And Not ValueIsFilled(Row.Store) And Not IsService Then
				Return False; // clear ItemList.Store impossible
			EndIf;
		EndDo;
	EndIf;
	Return True;
EndFunction

Procedure __tmp_SalesPurchaseInvoice_OnChainComplete(Parameters)
	
	// ItemList.Store is changed
	If Parameters.EventCaller = "ItemListStoreOnUserChange" Then
		If NeedCommitChangesItemListStoreOnUserChange(Parameters) Then
			CommitChanges(Parameters);
		EndIf;
		Return;
	EndIf;
	
	ArrayOfEventCallers = New Array();
	ArrayOfEventCallers.Add("DateOnUserChange");
	ArrayOfEventCallers.Add("CompanyOnUserChange");
	ArrayOfEventCallers.Add("PartnerOnUserChange");
	ArrayOfEventCallers.Add("AgreementOnUserChange");
	ArrayOfEventCallers.Add("StoreOnUserChange");
	ArrayOfEventCallers.Add("RetailCustomerOnUserChange");
	
	If ArrayOfEventCallers.Find(Parameters.EventCaller) = Undefined Then
		CommitChanges(Parameters);
		Return;
	EndIf;
	
	QuestionsParameters = New Array();
	ChangedPoints = New Structure();
	
	Changes = IsChangedProperty(Parameters, "ItemList.Store");
	If Changes.IsChanged Then // refill question ItemList.Store
		ChangedPoints.Insert("IsChangedItemListStore");
		QuestionsParameters.Add(New Structure("Action, QuestionText",
			"Stores", StrTemplate(R().QuestionToUser_009, String(Changes.NewValue))));
	EndIf;
	
	Changes = IsChangedProperty(Parameters, "ItemList.PriceType");
	If Changes.IsChanged Then // refill question ItemList.PriceType
		ChangedPoints.Insert("IsChangedItemListPriceType");
		QuestionsParameters.Add(New Structure("Action, QuestionText",
			"PriceTypes", StrTemplate(R().QuestionToUser_011, String(Changes.NewValue))));
	EndIf;
	
	Changes = IsChangedProperty(Parameters, "ItemList.Price");
	If Changes.IsChanged Then // refill question ItemList.Price
		ChangedPoints.Insert("IsChangedItemListPrice");
		QuestionsParameters.Add(New Structure("Action, QuestionText",
			"Prices", R().QuestionToUser_013));
	EndIf;
	
	Changes = IsChangedProperty(Parameters, "PaymentTerms");
	If Changes.IsChanged Then // refill question PaymentTerms
		ChangedPoints.Insert("IsChangedPaymentTerms");
		QuestionsParameters.Add(New Structure("Action, QuestionText",
			"PaymentTerm", R().QuestionToUser_019));
	EndIf;
	
	Changes = IsChangedTaxRates(Parameters);
	If Changes.IsChanged And Not Parameters.EventCaller = "CompanyOnUserChange" Then
		// refill question TaxRates
		ChangedPoints.Insert("IsChangedTaxRates");
		QuestionsParameters.Add(New Structure("Action, QuestionText",
			"TaxRates", R().QuestionToUser_004));
	EndIf;
	
	If QuestionsParameters.Count() Then
		NotifyParameters = New Structure("Parameters, ChangedPoints", Parameters, ChangedPoints);
		Notify = New NotifyDescription("QuestionsOnUserChangeContinue", ThisObject, NotifyParameters);
		OpenForm("CommonForm.UpdateItemListInfo",
			New Structure("QuestionsParameters", QuestionsParameters), 
			Parameters.Form, , , ,Notify ,FormWindowOpeningMode.LockOwnerWindow);
	Else
		CommitChanges(Parameters);
	EndIf;
EndProcedure

Procedure __tmp_MoneyTransfer_OnChainComplete(Parameters)
	ArrayOfEventCallers = New Array();
	ArrayOfEventCallers.Add("CompanyOnUserChange");
	ArrayOfEventCallers.Add("CashTransferOrderOnUserChange");
	
	If ArrayOfEventCallers.Find(Parameters.EventCaller) = Undefined Then
		__tmp_MoneyTransfer_CommitChanges(Parameters);
		Return;
	EndIf;
	
	// refill question Company
	If Parameters.EventCaller = "CompanyOnUserChange" Then
		
		If (IsChangedProperty(Parameters, "Sender").IsChanged 
			Or IsChangedProperty(Parameters, "Receiver").IsChanged) Then
	
			NotifyParameters = New Structure("Parameters", Parameters);
			ShowQueryBox(New NotifyDescription("__tmp_MoneyTransfer_CompanyOnUserChangeContinue", ThisObject, NotifyParameters), 
					R().QuestionToUser_015, QuestionDialogMode.OKCancel);
		Else
			__tmp_MoneyTransfer_CommitChanges(Parameters);
		EndIf;
		
	// refill question CashTransferOrder
	ElsIf Parameters.EventCaller = "CashTransferOrderOnUserChange" Then
		
		If (IsChangedProperty(Parameters, "Company").IsChanged 
			Or IsChangedProperty(Parameters, "Branch").IsChanged
			Or IsChangedProperty(Parameters, "Sender").IsChanged
			Or IsChangedProperty(Parameters, "SendCurrency").IsChanged
			Or IsChangedProperty(Parameters, "SendFinancialMovementType").IsChanged
			Or IsChangedProperty(Parameters, "SendAmount").IsChanged
			Or IsChangedProperty(Parameters, "Receiver").IsChanged
			Or IsChangedProperty(Parameters, "ReceiveCurrency").IsChanged
			Or IsChangedProperty(Parameters, "ReceiveFinancialMovementType").IsChanged
			Or IsChangedProperty(Parameters, "ReceiveAmount").IsChanged) Then
	
			NotifyParameters = New Structure("Parameters", Parameters);
			ShowQueryBox(New NotifyDescription("__tmp_MoneyTransfer_CashTransferOrderOnUserChangeContinue", ThisObject, NotifyParameters), 
					R().QuestionToUser_023, QuestionDialogMode.OKCancel);
		Else
			__tmp_MoneyTransfer_CommitChanges(Parameters);
		EndIf;
		
	Else
		__tmp_MoneyTransfer_CommitChanges(Parameters);
	EndIf;
EndProcedure

Procedure __tmp_MoneyTransfer_CompanyOnUserChangeContinue(Answer, NotifyParameters) Export
	If Answer = DialogReturnCode.OK Then
		__tmp_MoneyTransfer_CommitChanges(NotifyParameters.Parameters);
	EndIf;
EndProcedure

Procedure __tmp_MoneyTransfer_CashTransferOrderOnUserChangeContinue(Answer, NotifyParameters) Export
	If Answer = DialogReturnCode.OK Then
		__tmp_MoneyTransfer_CommitChanges(NotifyParameters.Parameters);
	EndIf;
EndProcedure

Procedure __tmp_MoneyTransfer_CommitChanges(Parameters)
	CommitChanges(Parameters);
EndProcedure

Procedure __tmp_CashExpenseRevenue_OnChainComplete(Parameters)
	ArrayOfEventCallers = New Array();
	ArrayOfEventCallers.Add("AccountOnUserChange");
	
	If ArrayOfEventCallers.Find(Parameters.EventCaller) = Undefined Then
		__tmp_CashExpenseRevenue_CommitChanges(Parameters);
		Return;
	EndIf;
	
	// refill question PaymentList.Currency
	If IsChangedProperty(Parameters, "PaymentList.Currency").IsChanged 
		And Parameters.Object.PaymentList.Count() Then
		NotifyParameters = New Structure("Parameters", Parameters);
		ShowQueryBox(New NotifyDescription("__tmp_CashExpenseRevenue_AccountOnUserChangeContinue", ThisObject, NotifyParameters), 
					R().QuestionToUser_006, QuestionDialogMode.YesNo);
	Else
		__tmp_CashExpenseRevenue_CommitChanges(Parameters);
	EndIf;

EndProcedure

Procedure __tmp_CashExpenseRevenue_AccountOnUserChangeContinue(Answer, NotifyParameters) Export
	If Answer = DialogReturnCode.Yes Then
		__tmp_CashExpenseRevenue_CommitChanges(NotifyParameters.Parameters);
	EndIf;
EndProcedure

Procedure __tmp_CashExpenseRevenue_CommitChanges(Parameters)
	If Parameters.ExtractedData.Property("DataCurrencyFromAccount") 
		And Parameters.ExtractedData.DataCurrencyFromAccount.Count() Then
		Parameters.Form.Currency = Parameters.ExtractedData.DataCurrencyFromAccount[0];
	EndIf;
	CommitChanges(Parameters);
EndProcedure

Procedure __tmp_BankCashPaymentReceipt_OnChainComplete(Parameters)
	
	ArrayOfEventCallers = New Array();
	ArrayOfEventCallers.Add("TransactionTypeOnUserChange");
	
	If ArrayOfEventCallers.Find(Parameters.EventCaller) = Undefined Then
		__tmp_BankCashPaymentReceipt_CommitChanges(Parameters);
		Return;
	EndIf;
	
	// refill question TransactionType
	If IsChangedProperty(Parameters, "TransactionType").IsChanged 
		And Parameters.Object.PaymentList.Count() Then
		NotifyParameters = New Structure("Parameters", Parameters);
		ShowQueryBox(New NotifyDescription("__tmp_BankCashPaymentReceipt_TransactionTypeOnUserChangeContinue", ThisObject, NotifyParameters), 
					R().QuestionToUser_014, QuestionDialogMode.OKCancel);
	Else
		__tmp_BankCashPaymentReceipt_CommitChanges(Parameters);
	EndIf;
EndProcedure

Procedure __tmp_BankCashPaymentReceipt_TransactionTypeOnUserChangeContinue(Answer, NotifyParameters) Export
	If Answer = DialogReturnCode.OK Then
		__tmp_BankCashPaymentReceipt_CommitChanges(NotifyParameters.Parameters);
	EndIf;
EndProcedure

Procedure __tmp_BankCashPaymentReceipt_CommitChanges(Parameters)
	// update form attributes
	If Parameters.ExtractedData.Property("DataAgreementApArPostingDetail") Then
		For Each RowPaymentList In Parameters.Object.PaymentList Do
			For Each RowData In Parameters.ExtractedData.DataAgreementApArPostingDetail Do
				If RowData.Key = RowPaymentList.Key Then
					RowPaymentList.ApArPostingDetail = RowData.ApArPostingDetail;
					Break;
				EndIf;
			EndDo;
		EndDo;
	EndIf;
	CommitChanges(Parameters);
EndProcedure

Procedure __tmp_GoodsShipmentReceipt_OnChainComplete(Parameters)
	
	// ItemList.Store is changed
	If Parameters.EventCaller = "ItemListStoreOnUserChange" Then
		If NeedCommitChangesItemListStoreOnUserChange(Parameters) Then
			__tmp_GoodsShipmentReceipt_CommitChanges(Parameters);
		EndIf;
		Return;
	EndIf;
	
	ArrayOfEventCallers = New Array();
	ArrayOfEventCallers.Add("StoreOnUserChange");
	
	If ArrayOfEventCallers.Find(Parameters.EventCaller) = Undefined Then
		__tmp_GoodsShipmentReceipt_CommitChanges(Parameters);
		Return;
	EndIf;

	If NeedQueryStoreOnUserChange(Parameters) Then
		// refill question ItemList.Store
		NotifyParameters = New Structure("Parameters", Parameters);
		ShowQueryBox(New NotifyDescription("__tmp_GoodsShipmentReceipt_StoreOnUserChangeContinue", ThisObject, NotifyParameters), 
					R().QuestionToUser_005, QuestionDialogMode.YesNoCancel);
	Else
		__tmp_GoodsShipmentReceipt_CommitChanges(Parameters);
	EndIf;
	
EndProcedure

Procedure __tmp_GoodsShipmentReceipt_StoreOnUserChangeContinue(Answer, NotifyParameters) Export
	If Answer = DialogReturnCode.Yes Then
		__tmp_GoodsShipmentReceipt_CommitChanges(NotifyParameters.Parameters);
	EndIf;
EndProcedure

Procedure __tmp_GoodsShipmentReceipt_CommitChanges(Parameters)
	CommitChanges(Parameters);
EndProcedure

Procedure QuestionsOnUserChangeContinue(Answer, NotifyParameters) Export
	If Answer = Undefined Then
		Return; // is Cancel pressed
	EndIf;
	Parameters    = NotifyParameters.Parameters;
	ChangedPoints = NotifyParameters.ChangedPoints;
	
	NeedRecalculate = False;
	If Not Answer.Property("UpdateStores") And ChangedPoints.Property("IsChangedItemListStore") Then
		RemoveFromCache("Store, ItemList.Store, ItemList.UseShipmentConfirmation, ItemList.UseGoodsReceipt", Parameters);
	EndIf;
	
	If Not Answer.Property("UpdatePriceTypes") And ChangedPoints.Property("IsChangedItemListPriceType") Then
		RemoveFromCache("ItemList.PriceType", Parameters);
		NeedRecalculate = True;
	EndIf;
	
	If Not Answer.Property("UpdatePrices") And ChangedPoints.Property("IsChangedItemListPrice") Then
		RemoveFromCache("ItemList.Price", Parameters);
		NeedRecalculate = True;
	EndIf;
	
	If Not Answer.Property("UpdatePaymentTerm") And ChangedPoints.Property("IsChangedPaymentTerms") Then
		RemoveFromCache("PaymentTerms", Parameters);
		NeedRecalculate = True;
	EndIf;
	
	If Not Answer.Property("UpdateTaxRates") And ChangedPoints.Property("IsChangedTaxRates") Then
		RemoveFromCacheTaxRates(Parameters);
		NeedRecalculate = True;
	EndIf;
	
	CommitChanges(Parameters);
	
	If NeedRecalculate Then
		FormParameters = GetFormParameters(Parameters.Form);
		FormParameters.EventCaller = "RecalculationsAfterQuestionToUser";
		ServerParameters = GetServerParameters(Parameters.Object);
		ServerParameters.TableName = "ItemList";
		Parameters = GetParameters(ServerParameters, FormParameters);
		ControllerClientServer_V2.RecalculationsAfterQuestionToUser(Parameters);
	EndIf;
EndProcedure

Function IsChangedTaxRates(Parameters)
	For Each TaxInfo In Parameters.ArrayOfTaxInfo Do
		Result = IsChangedProperty(Parameters, "ItemList." + TaxInfo.Name);
		If Result.IsChanged Then
			Return Result;
		EndIf;
	EndDo;
	Return New Structure("IsChanged", False);
EndFunction

Procedure RemoveFromCacheTaxRates(Parameters)
	ArrayOfDataPaths = New Array();
	For Each TaxInfo In Parameters.ArrayOfTaxInfo Do
		ArrayOfDataPaths.Add("ItemList." + TaxInfo.Name);
	EndDo;
	RemoveFromCache(StrConcat(ArrayOfDataPaths, ","), Parameters);
EndProcedure

Function IsChangedProperty(Parameters, DataPath)
	Result = New Structure("IsChanged, OldValue, NewValue", False, Undefined, Undefined);
	Changes = Parameters.ChangedData.Get(DataPath);
	If  Changes <> Undefined Then
		Result.IsChanged = True;
		Result.NewValue  = Changes[0].NewValue;
	EndIf;
	Return Result;
EndFunction

Procedure RemoveFromCache(DataPaths, Parameters)
	For Each DataPath In StrSplit(DataPaths, ",") Do
		Segments = StrSplit(DataPath, ".");
		If Segments.Count() = 1 Then
			PropertyName = TrimAll(Segments[0]);
			Parameters.CacheForm.Delete(PropertyName);
			Parameters.Cache.Delete(PropertyName);
		ElsIf Segments.Count() = 2 Then
			TableName  = TrimAll(Segments[0]);
			ColumnName = TrimAll(Segments[1]);
			If Not Parameters.Cache.Property(TableName) Then
				Raise StrTemplate("Not found property in cache for delete [%1]", DataPath);
			EndIf;
			For Each Row In Parameters.Cache[TableName] Do
				Row.Delete(ColumnName);
			EndDo;
		Else
			Raise StrTemplate("Wrong datapath remove from cache [%1]", DataPath);
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#EndRegion

Function AddOrCopyRow(Object, Form, TableName, Cancel, Clone, OriginRow, 
															OnAddViewNotify = Undefined, 
															OnCopyViewNotify = Undefined)
	Cancel = True;
	NewRow = Object[TableName].Add();
	If Clone Then // Copy()
		OriginRows = GetRowsByCurrentData(Form, TableName, OriginRow);
		If Not OriginRows.Count() Then
			Raise "Not found origin row for clone";
		EndIf;
		NewRow.Key = String(New UUID());
		Rows = GetRowsByCurrentData(Form, TableName, NewRow);
		Parameters = GetSimpleParameters(Object, Form, TableName, Rows);
		
		// columns that do not need to be copied
		ArrayOfExcludeProperties = New Array();
		ArrayOfExcludeProperties.Add("Key");
		If Parameters.ObjectMetadataInfo.DependencyTables.Find("RowIDInfo") <> Undefined Then
			// columns is form attributes
			ArrayOfExcludeProperties.Add("IsExternalLinked");
			ArrayOfExcludeProperties.Add("IsInternalLinked");
			ArrayOfExcludeProperties.Add("ExternalLinks");
			ArrayOfExcludeProperties.Add("InternalLinks");
		EndIf;
		
		If Parameters.ObjectMetadataInfo.DependencyTables.Find("SerialLotNumbers") <> Undefined Then
			// columns is form attributes
			ArrayOfExcludeProperties.Add("SerialLotNumbersPresentation");
			ArrayOfExcludeProperties.Add("SerialLotNumberIsFilling");
		EndIf;
		
		FillPropertyValues(NewRow, OriginRows[0], ,StrConcat(ArrayOfExcludeProperties, ","));
		
		Rows = GetRowsByCurrentData(Form, TableName, NewRow);
		Parameters = GetSimpleParameters(Object, Form, TableName, Rows);
		ControllerClientServer_V2.CopyRow(TableName, Parameters, OnCopyViewNotify);
	Else // Add()
		NewRow.Key = String(New UUID());
		Rows = GetRowsByCurrentData(Form, TableName, NewRow);
		Parameters = GetSimpleParameters(Object, Form, TableName, Rows);
		ControllerClientServer_V2.AddNewRow(TableName, Parameters, OnAddViewNotify);
	EndIf;
	Return NewRow;
EndFunction

Procedure DeleteRows(Object, Form, TableName, ViewNotify = Undefined)
	Parameters = GetSimpleParameters(Object, Form, TableName);
	ControllerClientServer_V2.DeleteRows(TableName, Parameters, ViewNotify);
EndProcedure

#Region FORM

Procedure OnOpen(Object, Form, TableNames) Export
	UpdateCacheBeforeChange(Object, Form);
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TrimAll(TableName));
		ControllerClientServer_V2.FillPropertyFormByDefault(Form, "Store, DeliveryDate", Parameters);
		ControllerClientServer_V2.FormOnOpen(Parameters);
	EndDo;
EndProcedure

Procedure OnOpenFormNotify(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "ShipmentConfirmation"
		Or Parameters.ObjectMetadataInfo.MetadataName = "GoodsReceipt"
		Or Parameters.ObjectMetadataInfo.MetadataName = "StockAdjustmentAsSurplus"
		Or Parameters.ObjectMetadataInfo.MetadataName = "StockAdjustmentAsWriteOff"
		Or Parameters.ObjectMetadataInfo.MetadataName = "SalesInvoice"
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseInvoice"
		Or Parameters.ObjectMetadataInfo.MetadataName = "RetailSalesReceipt" Then
			
			ServerData = Undefined;
			If Parameters.ExtractedData.Property("ItemKeysWithSerialLotNumbers") Then
				ServerData = New Structure("ServerData", New Structure());
				ServerData.ServerData.Insert("ItemKeysWithSerialLotNumbers", Parameters.ExtractedData.ItemKeysWithSerialLotNumbers);
			EndIf;
			
			SerialLotNumberClient.UpdateSerialLotNumbersPresentation(Parameters.Object, ServerData);
			SerialLotNumberClient.UpdateSerialLotNumbersTree(Parameters.Object, Parameters.Form);
	EndIf;
	
	If Parameters.ObjectMetadataInfo.MetadataName = "SalesInvoice" Then
		DocumentsClient.SetLockedRowsForItemListByTradeDocuments(Parameters.Object, Parameters.Form, 
			"ShipmentConfirmations");
		DocumentsClient.UpdateTradeDocumentsTree(Parameters.Object, Parameters.Form, 
			"ShipmentConfirmations", "ShipmentConfirmationsTree", "QuantityInShipmentConfirmation");
	EndIf;
	
	If Parameters.ObjectMetadataInfo.MetadataName = "PurchaseInvoice" Then
		DocumentsClient.SetLockedRowsForItemListByTradeDocuments(Parameters.Object, Parameters.Form,
			"GoodsReceipts");
		DocumentsClient.UpdateTradeDocumentsTree(Parameters.Object, Parameters.Form, 
			"GoodsReceipts", "GoodsReceiptsTree", "QuantityInGoodsReceipt");
	EndIf;
	
	If Parameters.ObjectMetadataInfo.MetadataName = "CashExpense"
		Or Parameters.ObjectMetadataInfo.MetadataName = "CashRevenue" Then
		Parameters.Form.FormSetVisibilityAvailability();
	EndIf;
	
	DocumentsClient.SetTextOfDescriptionAtForm(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region FORM_MODIFICATOR

Procedure FormModificator_CreateTaxesFormControls(Parameters) Export
	Parameters.Form.Taxes_CreateFormControls();
EndProcedure

#EndRegion

#Region _ITEM_LIST_

Function ItemListBeforeAddRow(Object, Form, Cancel = False, Clone = False, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, "ItemList", Cancel, Clone, CurrentData,
		"ItemListOnAddRowFormNotify", "ItemListOnCopyRowFormNotify");
	Form.Items.ItemList.CurrentRow = NewRow.GetID();
	Form.Items.ItemList.ChangeRow();
	Return NewRow;
EndFunction

Procedure ItemListOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure ItemListOnCopyRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure ItemListAfterDeleteRow(Object, Form) Export
	DeleteRows(Object, Form, "ItemList", "ItemListAfterDeleteRowFormNotify");
EndProcedure

Procedure ItemListAfterDeleteRowFormNotify(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "ShipmentConfirmation"
		Or Parameters.ObjectMetadataInfo.MetadataName = "GoodsReceipt"
		Or Parameters.ObjectMetadataInfo.MetadataName = "StockAdjustmentAsSurplus"
		Or Parameters.ObjectMetadataInfo.MetadataName = "StockAdjustmentAsWriteOff"
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseInvoice"
		Or Parameters.ObjectMetadataInfo.MetadataName = "SalesInvoice"
		Or Parameters.ObjectMetadataInfo.MetadataName = "RetailSalesReceipt" Then
		SerialLotNumberClient.DeleteUnusedSerialLotNumbers(Parameters.Object);
		SerialLotNumberClient.UpdateSerialLotNumbersTree(Parameters.Object, Parameters.Form);
	EndIf;
EndProcedure

#EndRegion

#Region _ITEM_LIST_COLUMNS

// ItemList.Item
Procedure ItemListItemOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListItemOnChange(Parameters);
EndProcedure

// ItemList.Item.Set
Procedure SetItemListItem(Object, Form, Row, Value) Export
	Row.Item = Value;
	Rows = GetRowsByCurrentData(Form, "ItemList", Row);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	Parameters.Insert("IsProgramChange", True);
	ControllerClientServer_V2.ItemListItemOnChange(Parameters);
EndProcedure

// ItemList.ItemKey
Procedure ItemListItemKeyOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListItemKeyOnChange(Parameters);
EndProcedure

// ItemList.ItemKey.Set
Procedure SetItemListItemKey(Object, Form, Row, Value) Export
	Row.ItemKey = Value;
	Rows = GetRowsByCurrentData(Form, "ItemList", Row);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	Parameters.Insert("IsProgramChange", True);
	ControllerClientServer_V2.ItemListItemKeyOnChange(Parameters);
EndProcedure

Procedure OnSetItemListItemKey(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "SalesInvoice"
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseInvoice"
		Or Parameters.ObjectMetadataInfo.MetadataName = "ShipmentConfirmation"
		Or Parameters.ObjectMetadataInfo.MetadataName = "GoodsReceipt"
		Or Parameters.ObjectMetadataInfo.MetadataName = "StockAdjustmentAsSurplus"
		Or Parameters.ObjectMetadataInfo.MetadataName = "StockAdjustmentAsWriteOff"
		Or Parameters.ObjectMetadataInfo.MetadataName = "RetailSalesReceipt" Then
			ServerData = Undefined;
			If Parameters.ExtractedData.Property("ItemKeysWithSerialLotNumbers") Then
				ServerData = New Structure("ServerData", New Structure());
				ServerData.ServerData.Insert("ItemKeysWithSerialLotNumbers", Parameters.ExtractedData.ItemKeysWithSerialLotNumbers);
			EndIf;
			SerialLotNumberClient.UpdateUseSerialLotNumber(Parameters.Object, Parameters.Form, ServerData);
	EndIf;
EndProcedure

// ItemList.Unit
Procedure ItemListUnitOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListUnitOnChange(Parameters);
EndProcedure

// ItemList.Unit.Set
Procedure SetItemListUnit(Object, Form, Row, Value) Export
	Row.Unit = Value;
	Rows = GetRowsByCurrentData(Form, "ItemList", Row);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	Parameters.Insert("IsProgramChange", True);
	ControllerClientServer_V2.ItemListUnitOnChange(Parameters);
EndProcedure

// ItemList.TaxRate
Procedure ItemListTaxRateOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListTaxRateOnChange(Parameters);
EndProcedure

// ItemList.PriceType
Procedure ItemListPriceTypeOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListPriceTypeOnChange(Parameters);
EndProcedure

// ItemList.Price
Procedure ItemListPriceOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListPriceOnChange(Parameters);
EndProcedure

// ItemList.Price.Set
Procedure SetItemListPrice(Object, Form, Row, Value) Export
	Row.Price = Value;
	Rows = GetRowsByCurrentData(Form, "ItemList", Row);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	Parameters.Insert("IsProgramChange", True);
	ControllerClientServer_V2.ItemListPriceOnChange(Parameters);
EndProcedure

// ItemList.TaxAmount
Procedure ItemListTaxAmountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListTaxAmountOnChange(Parameters);
EndProcedure

// ItemList.OffersAmount
Procedure ItemListOffersAmountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListOffersAmountOnChange(Parameters);
EndProcedure

// ItemList.TotalAmount
Procedure ItemListTotalAmountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListTotalAmountOnChange(Parameters);
EndProcedure

// ItemList.Store
Procedure ItemListStoreOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	
	FormParameters = GetFormParameters(Form);
	ExtractValueBeforeChange_List("ItemList.Store", FormParameters, Rows);
	FormParameters.EventCaller = "ItemListStoreOnUserChange";

	ServerParameters = GetServerParameters(Object);
	ServerParameters.Rows      = Rows;
	ServerParameters.TableName = "ItemList";
	
	Parameters = GetParameters(ServerParameters, FormParameters);
	ControllerClientServer_V2.ItemListStoreOnChange(Parameters);
EndProcedure

// ItemList.DeliveryDate
Procedure ItemListDeliveryDateOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	
	FormParameters = GetFormParameters(Form);
	ExtractValueBeforeChange_List("ItemList.DeliveryDate", FormParameters, Rows);
	FormParameters.EventCaller = "ItemListDeliveryDateOnUserChange";

	ServerParameters = GetServerParameters(Object);
	ServerParameters.Rows      = Rows;
	ServerParameters.TableName = "ItemList";
	
	Parameters = GetParameters(ServerParameters, FormParameters);
	ControllerClientServer_V2.ItemListDeliveryDateOnChange(Parameters);
EndProcedure

// ItemList.DontCalculateRow
Procedure ItemListDontCalculateRowOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListDontCalculateRowOnChange(Parameters);
EndProcedure	

// ItemList.Quantity
Procedure ItemListQuantityOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListQuantityOnChange(Parameters);
EndProcedure

// ItemList.Quantity.Set
Procedure SetItemListQuantity(Object, Form, Row, Value) Export
	Row.Quantity = Value;
	Rows = GetRowsByCurrentData(Form, "ItemList", Row);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	Parameters.Insert("IsProgramChange", True);
	ControllerClientServer_V2.ItemListQuantityOnChange(Parameters);
EndProcedure

Procedure OnSetItemListQuantityNotify(Parameters) Export
	Return;
EndProcedure

Procedure OnSetItemListQuantityInBaseUnitNotify(Parameters) Export
	// Update -> SrialLotNubersTree
	If Parameters.ObjectMetadataInfo.MetadataName = "SalesInvoice"
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseInvoice" 
		Or Parameters.ObjectMetadataInfo.MetadataName = "ShipmentConfirmation"
		Or Parameters.ObjectMetadataInfo.MetadataName = "GoodsReceipt"
		Or Parameters.ObjectMetadataInfo.MetadataName = "StockAdjustmentAsSurplus"
		Or Parameters.ObjectMetadataInfo.MetadataName = "StockAdjustmentAsWriteOff"
		Or Parameters.ObjectMetadataInfo.MetadataName = "RetailSalesReceipt" Then
		SerialLotNumberClient.UpdateSerialLotNumbersTree(Parameters.Object, Parameters.Form);
	EndIf;
	
	// Update -> RowIDInfoQuantity
	If Parameters.ObjectMetadataInfo.MetadataName = "SalesInvoice"
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseInvoice" 
		Or Parameters.ObjectMetadataInfo.MetadataName = "ShipmentConfirmation" 
		Or Parameters.ObjectMetadataInfo.MetadataName = "GoodsReceipt"
		Or Parameters.ObjectMetadataInfo.MetadataName = "StockAdjustmentAsSurplus"
		Or Parameters.ObjectMetadataInfo.MetadataName = "StockAdjustmentAsWriteOff"
		Or Parameters.ObjectMetadataInfo.MetadataName = "RetailSalesReceipt" Then
		RowIDInfoClient.UpdateQuantity(Parameters.Object, Parameters.Form);
	EndIf;
	
	// Update -> TradeDocumentsTree
	If Parameters.ObjectMetadataInfo.MetadataName = "SalesInvoice" Then
		DocumentsClient.UpdateTradeDocumentsTree(Parameters.Object, Parameters.Form, 
			"ShipmentConfirmations", "ShipmentConfirmationsTree", "QuantityInShipmentConfirmation");
	EndIf;
	If Parameters.ObjectMetadataInfo.MetadataName = "PurchaseInvoice" Then
		DocumentsClient.UpdateTradeDocumentsTree(Parameters.Object, Parameters.Form, 
			"GoodsReceipts", "GoodsReceiptsTree", "QuantityInGoodsReceipt");
	EndIf;
EndProcedure

#EndRegion

#Region _PAYMENT_LIST_

Procedure PaymentListBeforeAddRow(Object, Form, Cancel, Clone, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, "PaymentList", Cancel, Clone, CurrentData,
		"PaymentListOnAddRowFormNotify", "PaymentListOnCopyRowFormNotify");
	Form.Items.PaymentList.CurrentRow = NewRow.GetID();
	Form.Items.PaymentList.ChangeRow();
EndProcedure

Procedure PaymentListOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure PaymentListOnCopyRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure PaymentListAfterDeleteRow(Object, Form) Export
	DeleteRows(Object, Form, "PaymentList");
EndProcedure

#EndRegion

#Region _PAYMENT_LIST_COLUMNS

// PaymentList.Partner
Procedure PaymentListPartnerOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "PaymentList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "PaymentList", Rows);
	ControllerClientServer_V2.PaymentListPartnerOnChange(Parameters);
EndProcedure

// PaymentList.Agreement
Procedure PaymentListAgreementOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "PaymentList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "PaymentList", Rows);
	ControllerClientServer_V2.PaymentListAgreementOnChange(Parameters);
EndProcedure

// PaymentList.LegalName
Procedure PaymentListLegalNameOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "PaymentList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "PaymentList", Rows);
	ControllerClientServer_V2.PaymentListLegalNameOnChange(Parameters);
EndProcedure

// PaymentList.BasisDocument
Procedure PaymentListBasisDocumentOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "PaymentList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "PaymentList", Rows);
	ControllerClientServer_V2.PaymentListBasisDocumentOnChange(Parameters);
EndProcedure

// PaymentList.BasisDocument.Set
Procedure SetPaymentListBasisDocument(Object, Form, Row, Value) Export
	Row.BasisDocument = Value;
	Rows = GetRowsByCurrentData(Form, "PaymentList", Row);
	Parameters = GetSimpleParameters(Object, Form, "PaymentList", Rows);
	Parameters.Insert("IsProgramChange", True);
	ControllerClientServer_V2.PaymentListBasisDocumentOnChange(Parameters);
EndProcedure

// PaymentList.PlanningTransactionBasis
Procedure PaymentListPlanningTransactionBasisOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "PaymentList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "PaymentList", Rows);
	ControllerClientServer_V2.PaymentListPlanningTransactionBasisOnChange(Parameters);
EndProcedure

// PaymentList.Order
Procedure PaymentListOrderOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "PaymentList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "PaymentList", Rows);
	ControllerClientServer_V2.PaymentListOrderOnChange(Parameters);
EndProcedure

// PaymentList.Order.Set
Procedure SetPaymentListOrder(Object, Form, Row, Value) Export
	Row.Order = Value;
	Rows = GetRowsByCurrentData(Form, "PaymentList", Row);
	Parameters = GetSimpleParameters(Object, Form, "PaymentList", Rows);
	Parameters.Insert("IsProgramChange", True);
	ControllerClientServer_V2.PaymentListOrderOnChange(Parameters);
EndProcedure

// PaymentList.TaxRate
Procedure PaymentListTaxRateOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "PaymentList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "PaymentList", Rows);
	ControllerClientServer_V2.PaymentListTaxRateOnChange(Parameters);
EndProcedure

// PaymentList.DontCalculateRow
Procedure PaymentListDontCalculateRowOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "PaymentList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "PaymentList", Rows);
	ControllerClientServer_V2.PaymentListDontCalculateRowOnChange(Parameters);
EndProcedure

// PaymentList.TaxAmount
Procedure PaymentListTaxAmountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "PaymentList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "PaymentList", Rows);
	ControllerClientServer_V2.PaymentListTaxAmountOnChange(Parameters);
EndProcedure

// PaymentList.NetAmount
Procedure PaymentListNetAmountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "PaymentList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "PaymentList", Rows);
	ControllerClientServer_V2.PaymentListNetAmountOnChange(Parameters);
EndProcedure

// PaymentList.TotalAmount
Procedure PaymentListTotalAmountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "PaymentList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "PaymentList", Rows);
	ControllerClientServer_V2.PaymentListTotalAmountOnChange(Parameters);
EndProcedure

// PaymentList.TotalAmount.Set
Procedure SetPaymentListTotalAmount(Object, Form, Row, Value) Export
	Row.TotalAmount = Value;
	Rows = GetRowsByCurrentData(Form, "PaymentList", Row);
	Parameters = GetSimpleParameters(Object, Form, "PaymentList", Rows);
	Parameters.Insert("IsProgramChange", True);
	ControllerClientServer_V2.PaymentListTotalAmountOnChange(Parameters);
EndProcedure

#EndRegion

#Region _TRANSACTIONS_LIST

Procedure TransactionsBeforeAddRow(Object, Form, Cancel, Clone, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, "Transactions", Cancel, Clone, CurrentData,
		"TransactionsOnAddRowFormNotify", "TransactionsOnCopyRowFormNotify");
	Form.Items.Transactions.CurrentRow = NewRow.GetID();
	Form.Items.Transactions.ChangeRow();
EndProcedure

Procedure TransactionsOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure TransactionsOnCopyRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure TransactionsAfterDeleteRow(Object, Form) Export
	DeleteRows(Object, Form, "Transactions");
EndProcedure

#EndRegion

#Region _TRANSACTIONS_LIST_COLUMNS

// Transactions.Partner
Procedure TransactionsPartnerOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "Transactions", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "Transactions", Rows);
	ControllerClientServer_V2.TransactionsPartnerOnChange(Parameters);
EndProcedure

// Transactions.Agreement
Procedure TransactionsAgreementOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "Transactions", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "Transactions", Rows);
	ControllerClientServer_V2.TransactionsAgreementOnChange(Parameters);
EndProcedure

// Transactions.LegalName
Procedure TransactionsLegalNameOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "Transactions", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "Transactions", Rows);
	ControllerClientServer_V2.TransactionsLegalNameOnChange(Parameters);
EndProcedure

#EndRegion

#Region ACCOUNT_SENDER

Procedure AccountSenderOnChange(Object, Form) Export
	FormParameters = GetFormParameters(Form);
	ExtractValueBeforeChange_Object("Sender", FormParameters);
	ServerParameters = GetServerParameters(Object);
	Parameters = GetParameters(ServerParameters, FormParameters);
	ControllerClientServer_V2.AccountSenderOnChange(Parameters);
EndProcedure

Procedure OnSetAccountSenderNotify(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "MoneyTransfer" Then
		Parameters.Form.FormSetVisibilityAvailability();
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region CURRENCY_SEND

Procedure SendCurrencyOnChange(Object, Form) Export
	FormParameters = GetFormParameters(Form);
	ServerParameters = GetServerParameters(Object);
	Parameters = GetParameters(ServerParameters, FormParameters);
	ControllerClientServer_V2.SendCurrencyOnChange(Parameters);
EndProcedure

Procedure OnSetSendCurrencyNotify(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "MoneyTransfer" Then
		Parameters.Form.FormSetVisibilityAvailability();
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region AMOUNT_SEND

Procedure SendAmountOnChange(Object, Form) Export
	FormParameters = GetFormParameters(Form);
	ServerParameters = GetServerParameters(Object);
	Parameters = GetParameters(ServerParameters, FormParameters);
	ControllerClientServer_V2.SendAmountOnChange(Parameters);
EndProcedure

Procedure OnSetSendAmountNotify(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "MoneyTransfer" Then
		Parameters.Form.FormSetVisibilityAvailability();
	EndIf;
EndProcedure

#EndRegion

#Region ACCOUNT_RECEIVER

Procedure AccountReceiverOnChange(Object, Form) Export
	FormParameters = GetFormParameters(Form);
	ExtractValueBeforeChange_Object("Sender", FormParameters);
	ServerParameters = GetServerParameters(Object);
	Parameters = GetParameters(ServerParameters, FormParameters);
	ControllerClientServer_V2.AccountReceiverOnChange(Parameters);
EndProcedure

Procedure OnSetAccountReceiverNotify(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "MoneyTransfer" Then
		Parameters.Form.FormSetVisibilityAvailability();
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region CURRENCY_RECEIVE

Procedure ReceiveCurrencyOnChange(Object, Form) Export
	FormParameters = GetFormParameters(Form);
	ServerParameters = GetServerParameters(Object);
	Parameters = GetParameters(ServerParameters, FormParameters);
	ControllerClientServer_V2.ReceiveCurrencyOnChange(Parameters);
EndProcedure

Procedure OnSetReceiveCurrencyNotify(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "MoneyTransfer" Then
		Parameters.Form.FormSetVisibilityAvailability();
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region AMOUNT_RECEIVE

Procedure ReceiveAmountOnChange(Object, Form) Export
	FormParameters = GetFormParameters(Form);
	ServerParameters = GetServerParameters(Object);
	Parameters = GetParameters(ServerParameters, FormParameters);
	ControllerClientServer_V2.ReceiveAmountOnChange(Parameters);
EndProcedure

Procedure OnSetReceiveAmountNotify(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "MoneyTransfer" Then
		Parameters.Form.FormSetVisibilityAvailability();
	EndIf;
EndProcedure

#EndRegion

#Region CASH_TRANSFER_ORDER

Procedure CashTransferOrderOnChange(Object, Form, TableNames) Export
	FormParameters = GetFormParameters(Form);
	ExtractValueBeforeChange_Object("CashTransferOrder", FormParameters);
	FormParameters.EventCaller = "CashTransferOrderOnUserChange";
	For Each TableName In StrSplit(TableNames, ",") Do
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TrimAll(TableName);
		Parameters = GetParameters(ServerParameters, FormParameters);
		ControllerClientServer_V2.CashTransferOrderOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetCashTransferOrderNotify(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "MoneyTransfer" Then
		Parameters.Form.FormSetVisibilityAvailability();
	EndIf;
EndProcedure

#EndRegion

#Region STORE

#Region STORE_OBJECT_ATTR

Procedure StoreObjectAttrOnChange(Object, Form, TableNames) Export
	FormParameters = GetFormParameters(Form);
	ExtractValueBeforeChange_Object("Store", FormParameters);
	FormParameters.EventCaller = "StoreObjectAttrOnUserChange";

	For Each TableName In StrSplit(TableNames, ",") Do
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TrimAll(TableName);
		Parameters = GetParameters(ServerParameters, FormParameters);
		ControllerClientServer_V2.StoreObjectAttrOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetStoreObjectAttrNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

Procedure StoreOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		FormParameters = GetFormParameters(Form);
		ExtractValueBeforeChange_Form("Store", FormParameters);
		FormParameters.EventCaller = "StoreOnUserChange";
		
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TableName;
	
		Parameters = GetParameters(ServerParameters, FormParameters);
	
		ControllerClientServer_V2.StoreOnChange(Parameters);
	EndDo;
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
	Else
		Parameters.Form.Items.Store.InputHint = "";
	EndIf;
EndProcedure

Procedure OnAddOrLinkUnlinkDocumentRows(ExtractedData, Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		FormParameters = GetFormParameters(Form);
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TableName;
		Parameters = GetParameters(ServerParameters, FormParameters);
		OnSetStoreNotify(Parameters);
		
		If Parameters.ObjectMetadataInfo.MetadataName = "ShipmentConfirmation"
			Or Parameters.ObjectMetadataInfo.MetadataName = "GoodsReceipt"
			Or Parameters.ObjectMetadataInfo.MetadataName = "StockAdjustmentAsSurplus"
			Or Parameters.ObjectMetadataInfo.MetadataName = "StockAdjustmentAsWriteOff"
			Or Parameters.ObjectMetadataInfo.MetadataName = "SalesInvoice"
			Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseInvoice" Then
				
				ServerData = Undefined;
				If ExtractedData.Property("ItemKeysWithSerialLotNumbers") Then
					ServerData = New Structure("ServerData", New Structure());
					ServerData.ServerData.Insert("ItemKeysWithSerialLotNumbers", ExtractedData.ItemKeysWithSerialLotNumbers);
				EndIf;
				
				SerialLotNumberClient.UpdateSerialLotNumbersPresentation(Parameters.Object);
				SerialLotNumberClient.UpdateSerialLotNumbersTree(Parameters.Object, Parameters.Form);
		EndIf;
		
		If Parameters.ObjectMetadataInfo.MetadataName = "SalesInvoice" Then
			Parameters.Form.Taxes_CreateFormControls();
			DocumentsClient.SetLockedRowsForItemListByTradeDocuments(Parameters.Object, Parameters.Form, 
				"ShipmentConfirmations");
			DocumentsClient.UpdateTradeDocumentsTree(Parameters.Object, Parameters.Form, 
				"ShipmentConfirmations", "ShipmentConfirmationsTree", "QuantityInShipmentConfirmation");
		EndIf;
		
		If Parameters.ObjectMetadataInfo.MetadataName = "PurchaseInvoice" Then
			Parameters.Form.Taxes_CreateFormControls();
			DocumentsClient.SetLockedRowsForItemListByTradeDocuments(Parameters.Object, Parameters.Form,
				"GoodsReceipts");
			DocumentsClient.UpdateTradeDocumentsTree(Parameters.Object, Parameters.Form, 
				"GoodsReceipts", "GoodsReceiptsTree", "QuantityInGoodsReceipt");
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region DELIVERY_DATE

Procedure DeliveryDateOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		FormParameters = GetFormParameters(Form);
		ExtractValueBeforeChange_Form("DeliveryDate", FormParameters);
		FormParameters.EventCaller = "DeliveryDateOnUserChange";
		
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TableName;
	
		Parameters = GetParameters(ServerParameters, FormParameters);
	
		ControllerClientServer_V2.DeliveryDateOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetDeliveryDateNotify(Parameters) Export
	DeliveryDateArray = New Array();
	For Each Row In Parameters.Object.ItemList Do
		If ValueIsFilled(Row.DeliveryDate) And DeliveryDateArray.Find(Row.DeliveryDate) = Undefined Then
			DeliveryDateArray.Add(Row.DeliveryDate);
		EndIf;
	EndDo;
	If DeliveryDateArray.Count() > 1 Then
		DeliveryDateFormattedArray = New Array();
		For Each Row In DeliveryDateArray Do
			DeliveryDateFormattedArray.Add(Format(Row, "DF=dd.MM.yy;"));
		EndDo;
		Parameters.Form.Items.DeliveryDate.Tooltip = StrConcat(DeliveryDateFormattedArray, "; ");
	Else
		Parameters.Form.Items.DeliveryDate.Tooltip = "";
	EndIf;
EndProcedure

#EndRegion

#Region _DATE

Procedure DateOnChange(Object, Form, TableNames) Export
	FormParameters = GetFormParameters(Form);
	ExtractValueBeforeChange_Object("Date", FormParameters);
	FormParameters.EventCaller = "DateOnUserChange";
	For Each TableName In StrSplit(TableNames, ",") Do
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TrimAll(TableName);
		Parameters = GetParameters(ServerParameters, FormParameters);
		ControllerClientServer_V2.DateOnChange(Parameters);
	EndDo;
EndProcedure

#EndRegion

#Region COMPANY

Procedure CompanyOnChange(Object, Form, TableNames) Export
	FormParameters = GetFormParameters(Form);
	ExtractValueBeforeChange_Object("Company", FormParameters);
	FormParameters.EventCaller = "CompanyOnUserChange";

	For Each TableName In StrSplit(TableNames, ",") Do
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TrimAll(TableName);
		Parameters = GetParameters(ServerParameters, FormParameters);
		ControllerClientServer_V2.CompanyOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetCompanyNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region ACCOUNT

Procedure AccountOnChange(Object, Form, TableNames) Export
	FormParameters = GetFormParameters(Form);
	ExtractValueBeforeChange_Object("Account", FormParameters);
	FormParameters.EventCaller = "AccountOnUserChange";
	For Each TableName In StrSplit(TableNames, ",") Do
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TrimAll(TableName);
		Parameters = GetParameters(ServerParameters, FormParameters);
		ControllerClientServer_V2.AccountOnChange(Parameters);
	EndDo;
EndProcedure
	
Procedure OnSetAccountNotify(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "CashExpense"
		Or Parameters.ObjectMetadataInfo.MetadataName = "CashRevenue"
		Or Parameters.ObjectMetadataInfo.MetadataName = "BankPayment"
		Or Parameters.ObjectMetadataInfo.MetadataName = "BankReceipt"
		Or Parameters.ObjectMetadataInfo.MetadataName = "CashPayment"
		Or Parameters.ObjectMetadataInfo.MetadataName = "CashReceipt" Then
		Parameters.Form.FormSetVisibilityAvailability();
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region CASH_ACCOUNT

Procedure CashAccountOnChange(Object, Form, TableNames) Export
	FormParameters = GetFormParameters(Form);
	ExtractValueBeforeChange_Object("CashAccount", FormParameters);
	FormParameters.EventCaller = "AccountOnUserChange";
	For Each TableName In StrSplit(TableNames, ",") Do
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TrimAll(TableName);
		Parameters = GetParameters(ServerParameters, FormParameters);
		ControllerClientServer_V2.AccountOnChange(Parameters);
	EndDo;
EndProcedure
	
Procedure OnSetCashAccountNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region TRANSACTION_TYPE

Procedure TransactionTypeOnChange(Object, Form, TableNames) Export
	FormParameters = GetFormParameters(Form);
	ExtractValueBeforeChange_Object("TransactionType", FormParameters);
	FormParameters.EventCaller = "TransactionTypeOnUserChange";
	For Each TableName In StrSplit(TableNames, ",") Do
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TrimAll(TableName);
		Parameters = GetParameters(ServerParameters, FormParameters);
		ControllerClientServer_V2.TransactionTypeOnChange(Parameters);
	EndDo;
EndProcedure
	
Procedure OnSetTransactionTypeNotify(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "BankPayment"
		Or Parameters.ObjectMetadataInfo.MetadataName = "BankReceipt"
		Or Parameters.ObjectMetadataInfo.MetadataName = "CashPayment"
		Or Parameters.ObjectMetadataInfo.MetadataName = "CashReceipt" Then
		Parameters.Form.FormSetVisibilityAvailability();
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region CURRENCY

Procedure CurrencyOnChange(Object, Form, TableNames) Export
	FormParameters = GetFormParameters(Form);
	ExtractValueBeforeChange_Object("Currency", FormParameters);
	FormParameters.EventCaller = "CurrencyOnUserChange";
	For Each TableName In StrSplit(TableNames, ",") Do
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TrimAll(TableName);
		Parameters = GetParameters(ServerParameters, FormParameters);
		ControllerClientServer_V2.CurrencyOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetCurrencyNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region PARTNER

Procedure PartnerOnChange(Object, Form, TableNames) Export
	FormParameters = GetFormParameters(Form);
	ExtractValueBeforeChange_Object("Partner", FormParameters);
	FormParameters.EventCaller = "PartnerOnUserChange";
	For Each TableName In StrSplit(TableNames, ",") Do
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TableName;
		Parameters = GetParameters(ServerParameters, FormParameters);
		ControllerClientServer_V2.PartnerOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetPartnerNotify(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "SalesInvoice"
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseInvoice"
		Or Parameters.ObjectMetadataInfo.MetadataName = "GoodsReceipt"
		Or Parameters.ObjectMetadataInfo.MetadataName = "ShipmentConfirmation"
		Or Parameters.ObjectMetadataInfo.MetadataName = "RetailSalesReceipt" Then
		Parameters.Form.FormSetVisibilityAvailability();
	EndIf;
	
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region LEGAL_NAME

Procedure LegalNameOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.LegalNameOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetLegalNameNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region AGREEMENT

Procedure AgreementOnChange(Object, Form, TableNames) Export
	FormParameters = GetFormParameters(Form);
	ExtractValueBeforeChange_Object("Agreement", FormParameters);
	FormParameters.EventCaller = "AgreementOnUserChange";
	For Each TableName In StrSplit(TableNames, ",") Do
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TableName;
		Parameters = GetParameters(ServerParameters, FormParameters);
		ControllerClientServer_V2.AgreementOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetAgreementNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region RETAIL_CUSTOMER

Procedure RetailCustomerOnChange(Object, Form, TableNames) Export
	FormParameters = GetFormParameters(Form);
	ExtractValueBeforeChange_Object("RetailCustomer", FormParameters);
	FormParameters.EventCaller = "RetailCustomerOnUserChange";
	For Each TableName In StrSplit(TableNames, ",") Do
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TrimAll(TableName);
		Parameters = GetParameters(ServerParameters, FormParameters);
		ControllerClientServer_V2.RetailCustomerOnChange(Parameters);
	EndDo;
EndProcedure

#EndRegion

#Region PRICE_INCLUDE_TAX

Procedure PriceIncludeTaxOnChange(Object, Form) Export
	Parameters = GetSimpleParameters(Object, Form, "ItemList");
	ControllerClientServer_V2.PriceIncludeTaxOnChange(Parameters);
EndProcedure

#EndRegion

#Region OFFERS
	
Procedure OffersOnChange(Object, Form) Export
	Parameters = GetSimpleParameters(Object, Form, "ItemList");
	ControllerClientServer_V2.OffersOnChange(Parameters);
EndProcedure
	
#EndRegion
