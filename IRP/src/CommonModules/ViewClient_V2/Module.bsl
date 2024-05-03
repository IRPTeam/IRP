
#Region CACHE_BEFORE_CHANGE

Function GetSimpleParameters(Object, Form, TableName, Rows = Undefined)
	FormParameters   = GetFormParameters(Form);
	ServerParameters = GetServerParameters(Object);
	ServerParameters.TableName = TrimAll(TableName);
	ServerParameters.Rows      = Rows;
	Return GetParameters(ServerParameters, FormParameters);
EndFunction

Function GetLoadParameters(Object, Form, TableName, Address, GroupColumns = "", SumColumns = "")
	FormParameters   = GetFormParameters(Form);
	ServerParameters = GetServerParameters(Object);
	ServerParameters.TableName = TrimAll(TableName);
	LoadParameters   = ControllerClientServer_V2.GetLoadParameters(Address, GroupColumns, SumColumns);
	Return GetParameters(ServerParameters, FormParameters, LoadParameters);	
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

Function GetParameters(ServerParameters, FormParameters = Undefined, LoadParameters = Undefined)
	Return ControllerClientServer_V2.GetParameters(ServerParameters, FormParameters, LoadParameters);
EndFunction

Procedure FetchFromCacheBeforeChange_Object(DataPath, FormParameters)
	FormParameters.PropertyBeforeChange.Object.DataPath = DataPath;
	FetchFromCacheBeforeChange(FormParameters, Undefined);
EndProcedure

Procedure FetchFromCacheBeforeChange_Form(DataPath, FormParameters)
	FormParameters.PropertyBeforeChange.Form.DataPath = DataPath;
	FetchFromCacheBeforeChange(FormParameters, Undefined);
EndProcedure

Procedure FetchFromCacheBeforeChange_List(DataPath, FormParameters, Rows)
	FormParameters.PropertyBeforeChange.List.DataPath = DataPath;
	FetchFromCacheBeforeChange(FormParameters, Rows);
EndProcedure

Procedure FetchFromCacheBeforeChange(FormParameters, Rows)

	If ValueIsFilled(FormParameters.PropertyBeforeChange.Object.DataPath) 
		Or ValueIsFilled(FormParameters.PropertyBeforeChange.Form.DataPath)
		Or ValueIsFilled(FormParameters.PropertyBeforeChange.List.DataPath) Then
		
		CacheBeforeChange = FormParameters.Form.CacheBeforeChange;
		
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
			Raise StrTemplate("Error read data from cache by data path [%1] rows is Undefined", DataPath);
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
		
		Object_Table = Object[TableName];
		For Each Row In Object_Table Do
		//For Each Row In Object[TableName] Do
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
	Form.CacheBeforeChange = CacheBeforeChange;	
EndProcedure

// returns list of Object attributes for get value before the change
Function GetObjectPropertyNamesBeforeChange()
	Return "Date,
		|Company,
		|TradeAgentFeeType,
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
		|RetailCustomer,
		|PlanningPeriod,
		|BusinessUnit,
		|SendPartner,
		|SendAgreement,
		|ReceivePartner,
		|ReceiveAgreement";
EndFunction

// returns list of Table attributes for get value before the change
Function GetListPropertyNamesBeforeChange()
	Return "ItemList.Store, 
		|ItemList.DeliveryDate, 
		|ItemList.ItemKey, 
		|Inventory.ItemKey, 
		|ShipmentToTradeAgent.ItemKey, 
		|ReceiptFromConsignor.ItemKey, 
		|ProductionDurationsList.ItemKey,
		|Payments.BankTerm,
		|Payments.PaymentType";
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
	//VatRate visible
	If Parameters.TaxVisible <> Undefined Then
		TaxesClientServer.ChangeVsible(Parameters.Form, Parameters.TaxVisible);
		If Parameters.TaxVisible = True Then
			TaxesClientServer.LoadChoiceList(Parameters.Form, Parameters.TaxChoiceList);
		EndIf;
	EndIf;
	
	If Parameters.ObjectMetadataInfo.MetadataName = "SalesInvoice"
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseInvoice"
		Or Parameters.ObjectMetadataInfo.MetadataName = "SalesReturn"
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseReturn"
		Or Parameters.ObjectMetadataInfo.MetadataName = "WorkOrder"
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseOrder"
		Or Parameters.ObjectMetadataInfo.MetadataName = "SalesReturnOrder"
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseReturnOrder"
		Or Parameters.ObjectMetadataInfo.MetadataName = "SalesReportFromTradeAgent"
		Or Parameters.ObjectMetadataInfo.MetadataName = "SalesReportToConsignor" Then
		__tmp_CommonDocuments_OnChainComplete(Parameters, False);
		Return;
	EndIf;
	
	// SalesOrder
	If Parameters.ObjectMetadataInfo.MetadataName = "SalesOrder"
		And Upper(Parameters.Form.FormName) = Upper("Document.SalesOrder.Form.DocumentForm") Then
			__tmp_CommonDocuments_OnChainComplete(Parameters, True);
			Return;
	EndIf;
	
	// RetailReturnReceipt
	If Parameters.ObjectMetadataInfo.MetadataName = "RetailReturnReceipt"
		And Upper(Parameters.Form.FormName) = Upper("Document.RetailReturnReceipt.Form.DocumentForm") Then
			__tmp_CommonDocuments_OnChainComplete(Parameters, True);
			Return;
	EndIf;
	
	// RetailSalesReceipt
	If Parameters.ObjectMetadataInfo.MetadataName = "RetailSalesReceipt"
		And Upper(Parameters.Form.FormName) = Upper("Document.RetailSalesReceipt.Form.DocumentForm") Then
			__tmp_CommonDocuments_OnChainComplete(Parameters, True);
			Return;
	EndIf;
	
	// RetailReceiptCorrection
	If Parameters.ObjectMetadataInfo.MetadataName = "RetailReceiptCorrection"
		And Upper(Parameters.Form.FormName) = Upper("Document.RetailReceiptCorrection.Form.DocumentForm") Then
			__tmp_CommonDocuments_OnChainComplete(Parameters, True);
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
	
	If Parameters.ObjectMetadataInfo.MetadataName = "CashTransferOrder" Then
		__tmp_CashTransferOrder_OnChainComplete(Parameters);
		Return;
	EndIf;
	 
	If Parameters.ObjectMetadataInfo.MetadataName = "CashExpense"
		Or Parameters.ObjectMetadataInfo.MetadataName = "CashRevenue" Then
		__tmp_CashExpenseRevenue_OnChainComplete(Parameters);
		Return;
	EndIf;
	
	If Parameters.ObjectMetadataInfo.MetadataName = "ShipmentConfirmation"
		Or Parameters.ObjectMetadataInfo.MetadataName = "RetailShipmentConfirmation"
		Or Parameters.ObjectMetadataInfo.MetadataName = "GoodsReceipt" 
		Or Parameters.ObjectMetadataInfo.MetadataName = "RetailGoodsReceipt" Then
		__tmp_GoodsShipmentReceipt_OnChainComplete(Parameters);
		Return;
	EndIf;
	
	If Parameters.ObjectMetadataInfo.MetadataName = "ProductionPlanning"
		Or Parameters.ObjectMetadataInfo.MetadataName = "ProductionPlanningCorrection" Then
		__tmp_ProductionPlanning_OnChainComplete(Parameters);
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
			
			For Each RowItemList In Parameters.Object.ItemList Do
				If RowItemList.Key <> Row.Key Then
					Continue;
				EndIf;
				If CommonFunctionsClientServer.ObjectHasProperty(RowItemList, "IsService") Then
					IsService = RowItemList.IsService;
				EndIf;
				Break;
			EndDo;
						
			If Row.Property("Store") And Not ValueIsFilled(Row.Store) And Not IsService Then
				Return False; // clear ItemList.Store impossible
			EndIf;
		EndDo;
	EndIf;
	Return True;
EndFunction

Procedure __tmp_CommonDocuments_OnChainComplete(Parameters, IsRetail)
	
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
	ArrayOfEventCallers.Add("PaymentsBankTermOnUserChange");
	ArrayOfEventCallers.Add("PaymentsPaymentTypeOnUserChange");
	
	If ArrayOfEventCallers.Find(Parameters.EventCaller) = Undefined Then
		CommitChanges(Parameters);
		Return;
	EndIf;
	
	QuestionsParameters = New Array();
	ChangedPoints = New Structure();
	
	If IsRetail Then
		Changes_Partner           = IsChangedProperty(Parameters, "Payments.PaymentAgentPartner");
		Changes_LegalName         = IsChangedProperty(Parameters, "Payments.PaymentAgentLegalName");
		Changes_PartnerTerms      = IsChangedProperty(Parameters, "Payments.PaymentAgentPartnerTerms");
		Changes_LegalNameContract = IsChangedProperty(Parameters, "Payments.PaymentAgentLegalNameContract");
		
		If Changes_Partner.IsChanged 
			Or Changes_LegalName.IsChanged
			Or Changes_PartnerTerms.IsChanged 
			Or Changes_LegalNameContract.IsChanged Then
			
			ChangedPoints.Insert("IsChangedPaymentsPaymentAgent");
			QuestionsParameters.Add(New Structure("Action, QuestionText",
				"PaymentAgent", R().QuestionToUser_026));
		EndIf;
	EndIf;
	
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
	
	Changes = IsChangedProperty(Parameters, "ItemList.VatRate");
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
			Parameters.Form, , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
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

Procedure __tmp_ProductionPlanning_OnChainComplete(Parameters)
	ArrayOfEventCallers = New Array();
	ArrayOfEventCallers.Add("BusinessUnitOnUserChange");
	ArrayOfEventCallers.Add("DateOnUserChange");
	
	If ArrayOfEventCallers.Find(Parameters.EventCaller) = Undefined Then
		__tmp_ProductionPlanning_CommitChanges(Parameters);
		Return;
	EndIf;
	
	// refill question BusinessUnit or Date
	If (Parameters.EventCaller = "BusinessUnitOnUserChange"
		Or Parameters.EventCaller = "DateOnUserChange") Then
		
		ChangedPropertyInfo = IsChangedProperty(Parameters, "PlanningPeriod");
		
		If ChangedPropertyInfo.IsChanged And ValueIsFilled(ChangedPropertyInfo.OldValue) Then	
			
			NotifyParameters = New Structure("Parameters", Parameters);
			ShowQueryBox(New NotifyDescription("__tmp_ProductionPlanning_BusinessUnitOrDateOnUserChangeContinue", ThisObject, NotifyParameters), 
					R().QuestionToUser_024, QuestionDialogMode.YesNo);
		Else
			__tmp_ProductionPlanning_CommitChanges(Parameters);
		EndIf;		
		
	Else
		__tmp_ProductionPlanning_CommitChanges(Parameters);
	EndIf;
EndProcedure

Procedure __tmp_ProductionPlanning_BusinessUnitOrDateOnUserChangeContinue(Answer, NotifyParameters) Export
	If Answer = DialogReturnCode.Yes Then
		__tmp_ProductionPlanning_CommitChanges(NotifyParameters.Parameters);
	EndIf;
EndProcedure

Procedure __tmp_ProductionPlanning_CommitChanges(Parameters)
	CommitChanges(Parameters);
EndProcedure

Procedure __tmp_CashTransferOrder_OnChainComplete(Parameters)
	ArrayOfEventCallers = New Array();
	ArrayOfEventCallers.Add("CompanyOnUserChange");
	
	If ArrayOfEventCallers.Find(Parameters.EventCaller) = Undefined Then
		__tmp_CashTransferOrder_CommitChanges(Parameters);
		Return;
	EndIf;
	
	// refill question Company
	If Parameters.EventCaller = "CompanyOnUserChange" Then
		
		If (IsChangedProperty(Parameters, "Sender").IsChanged 
			Or IsChangedProperty(Parameters, "Receiver").IsChanged) Then
	
			NotifyParameters = New Structure("Parameters", Parameters);
			ShowQueryBox(New NotifyDescription("__tmp_CashTransferOrder_CompanyOnUserChangeContinue", ThisObject, NotifyParameters), 
					R().QuestionToUser_015, QuestionDialogMode.OKCancel);
		Else
			__tmp_CashTransferOrder_CommitChanges(Parameters);
		EndIf;		
		
	Else
		__tmp_MoneyTransfer_CommitChanges(Parameters);
	EndIf;
EndProcedure

Procedure __tmp_CashTransferOrder_CompanyOnUserChangeContinue(Answer, NotifyParameters) Export
	If Answer = DialogReturnCode.OK Then
		__tmp_MoneyTransfer_CommitChanges(NotifyParameters.Parameters);
	EndIf;
EndProcedure

Procedure __tmp_CashTransferOrder_CommitChanges(Parameters)
	CommitChanges(Parameters);
EndProcedure

Procedure __tmp_CashExpenseRevenue_OnChainComplete(Parameters)
	ArrayOfEventCallers = New Array();
	ArrayOfEventCallers.Add("AccountOnUserChange");
	ArrayOfEventCallers.Add("DateOnUserChange");
	
	If ArrayOfEventCallers.Find(Parameters.EventCaller) = Undefined Then
		__tmp_CashExpenseRevenue_CommitChanges(Parameters);
		Return;
	EndIf;
	
	If Parameters.EventCaller = "AccountOnUserChange" Then
		// refill question PaymentList.Currency
		If IsChangedProperty(Parameters, "PaymentList.Currency").IsChanged 
			And Parameters.Object.PaymentList.Count() Then
			NotifyParameters = New Structure("Parameters", Parameters);
			ShowQueryBox(New NotifyDescription("__tmp_CashExpenseRevenue_AccountOnUserChangeContinue", ThisObject, NotifyParameters), 
						R().QuestionToUser_006, QuestionDialogMode.YesNo);
		Else
			__tmp_CashExpenseRevenue_CommitChanges(Parameters);
		EndIf;

		ElsIf Parameters.EventCaller = "DateOnUserChange" Then
		// refill question tax rate
		If IsChangedProperty(Parameters, "PaymentList.VatRate").IsChanged 
			And Parameters.Object.PaymentList.Count() Then
			NotifyParameters = New Structure("Parameters", Parameters);
			ShowQueryBox(New NotifyDescription("__tmp_CashExpenseRevenue_DateOnUserChangeContinue", ThisObject, NotifyParameters), 
						R().QuestionToUser_025, QuestionDialogMode.YesNo);
		Else
			__tmp_CashExpenseRevenue_CommitChanges(Parameters);
		EndIf;
	Else
		__tmp_CashExpenseRevenue_CommitChanges(Parameters);
	EndIf;
EndProcedure

Procedure __tmp_CashExpenseRevenue_AccountOnUserChangeContinue(Answer, NotifyParameters) Export
	If Answer = DialogReturnCode.Yes Then
		__tmp_CashExpenseRevenue_CommitChanges(NotifyParameters.Parameters);
	EndIf;
EndProcedure

Procedure __tmp_CashExpenseRevenue_DateOnUserChangeContinue(Answer, NotifyParameters) Export
	If Answer = DialogReturnCode.Yes Then
		__tmp_CashExpenseRevenue_CommitChanges(NotifyParameters.Parameters);
	Else
		DataPaths = "PaymentList.VatRate, PaymentList.NetAmount, PaymentList.TaxAmount, PaymentList.TotalAmount";
		RemoveFromCache(DataPaths, NotifyParameters.Parameters, False);
		
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
	
	// affect to amounts
	IsPriceChecked = False;
	IsTaxRateChecked = False;
	IsPriceTypeChecked = False;
	
	ArrayOfDataPaths = New Array();
	
	If ChangedPoints.Property("IsChangedItemListStore") Then
		DataPaths = "Store, ItemList.Store, ItemList.UseShipmentConfirmation, ItemList.UseGoodsReceipt";
		ArrayOfDataPaths.Add(DataPaths);
		If Not Answer.Property("UpdateStores") Then
			RemoveFromCache(DataPaths, Parameters);
		EndIf;
	EndIf;
	
	If ChangedPoints.Property("IsChangedPaymentsPaymentAgent") Then
		DataPaths = "Payments.PaymentAgentPartner, Payments.PaymentAgentLegalName, Payments.PaymentAgentPartnerTerms ,Payments.PaymentAgentLegalNameContract";
		If Not Answer.Property("UpdatePaymentAgent") Then
			RemoveFromCache(DataPaths, Parameters);
		EndIf;
	EndIf;
	
	If ChangedPoints.Property("IsChangedItemListPriceType") Then
		DataPaths = "ItemList.PriceType";
		ArrayOfDataPaths.Add(DataPaths);	
		If Not Answer.Property("UpdatePriceTypes") Then
			RemoveFromCache(DataPaths, Parameters);
		Else
			IsPriceTypeChecked = True;
		EndIf;
	EndIf;
	
	If ChangedPoints.Property("IsChangedItemListPrice") Then
		DataPaths = "ItemList.Price";
		ArrayOfDataPaths.Add(DataPaths);
		If Not Answer.Property("UpdatePrices") Then
			RemoveFromCache(DataPaths, Parameters);
		Else
			IsPriceChecked = True;
		EndIf;
	EndIf;

	If ChangedPoints.Property("IsChangedPaymentTerms") Then
		DataPaths = "PaymentTerms";
		ArrayOfDataPaths.Add(DataPaths);
		If Not Answer.Property("UpdatePaymentTerm") Then
			RemoveFromCache(DataPaths, Parameters);
		EndIf;
	EndIf;
	
	If ChangedPoints.Property("IsChangedTaxRates") Then
		DataPaths = "ItemList.VatRate";
		ArrayOfDataPaths.Add(DataPaths);
		If Not Answer.Property("UpdateTaxRates") Then
			RemoveFromCache(DataPaths, Parameters);
		Else
			IsTaxRateChecked = True;
		EndIf;
	EndIf;
	
	// not affect amounts
	If Not (IsPriceTypeChecked Or IsPriceChecked Or IsTaxRateChecked) Then
		DataPaths = "ItemList.NetAmount, ItemList.TaxAmount, ItemList.TotalAmount";
		ArrayOfDataPaths.Add(DataPaths);
		RemoveFromCache(DataPaths, Parameters, False);
	EndIf;
	
	CommitChanges(Parameters);
	
	If ArrayOfDataPaths.Count() Then
		Parameters.Form.API_Callback(Parameters.TableName, ArrayOfDataPaths);
	EndIf;
	
	UpdateTotalAmounts(Parameters);
EndProcedure

Function IsChangedProperty(Parameters, DataPath)
	Return	ControllerClientServer_V2.IsChangedProperty(Parameters, DataPath);
EndFunction

Procedure RemoveFromCache(DataPaths, Parameters, RaiseException = True)
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
				If Not RaiseException Then
					Return;
				EndIf;
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

#Region _LIST

Procedure ListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing)
	RowIDInfoClient.ItemListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing);
EndProcedure

Function AddOrCopyRow(Object, Form, TableName, Cancel, Clone, OriginRow, 
															OnAddViewNotify = Undefined, 
															OnCopyViewNotify = Undefined,
															FillingValues = Undefined,
															KeyOwner = Undefined)
	Cancel = True;
	NewRow = Object[TableName].Add();
	If Clone Then // Copy()
		OriginRows = GetRowsByCurrentData(Form, TableName, OriginRow);
		If Not OriginRows.Count() Then
			Raise "Not found origin row for clone";
		EndIf;
		NewRow.Key = String(New UUID());
		
		If KeyOwner <> Undefined Then
			NewRow.KeyOwner = KeyOwner;
		EndIf;
		
		Rows = GetRowsByCurrentData(Form, TableName, NewRow);
		Parameters = GetSimpleParameters(Object, Form, TableName, Rows);
		
		// columns that do not need to be copied
		ArrayOfExcludeProperties = New Array();
		ArrayOfExcludeProperties.Add("Key");
		If Parameters.ObjectMetadataInfo.DependentTables.Find("RowIDInfo") <> Undefined Then
			// columns is form attributes
			ArrayOfExcludeProperties.Add("IsExternalLinked");
			ArrayOfExcludeProperties.Add("IsInternalLinked");
			ArrayOfExcludeProperties.Add("ExternalLinks");
			ArrayOfExcludeProperties.Add("InternalLinks");
		EndIf;
		
		If Parameters.ObjectMetadataInfo.DependentTables.Find("SerialLotNumbers") <> Undefined Then
			// columns is form attributes
			ArrayOfExcludeProperties.Add("SerialLotNumbersPresentation");
			ArrayOfExcludeProperties.Add("SerialLotNumberIsFilling");
		EndIf;
		
		If Parameters.ObjectMetadataInfo.DependentTables.Find("SourceOfOrigins") <> Undefined Then
			ArrayOfExcludeProperties.Add("SourceOfOriginsPresentation");
		EndIf;
		
		FillPropertyValues(NewRow, OriginRows[0], , StrConcat(ArrayOfExcludeProperties, ","));
		
		Rows = GetRowsByCurrentData(Form, TableName, NewRow);
		Parameters = GetSimpleParameters(Object, Form, TableName, Rows);
		ControllerClientServer_V2.CopyRow(TableName, Parameters, OnCopyViewNotify);
	Else // Add()
		NewRow.Key = String(New UUID());
		
		If KeyOwner <> Undefined Then
			NewRow.KeyOwner = KeyOwner;
		EndIf;
		
		Rows = GetRowsByCurrentData(Form, TableName, NewRow);
		Parameters = GetSimpleParameters(Object, Form, TableName, Rows);
		
		Transfer = New Structure("Form, Object", Parameters.Form, Parameters.Object);
		ModelClientServer_V2.TransferFormToStructure(Transfer, Parameters);
		ViewServer_V2.AddNewRowAtServer(TableName, Parameters, OnAddViewNotify, FillingValues);
		ModelClientServer_V2.TransferStructureToForm(Transfer, Parameters);
		ControllerClientServer_V2.CommitChainChanges(Parameters);
	EndIf;
	Return NewRow;
EndFunction

Function AddOrCopyRowSimpleTable(Object, Form, TableName, Cancel, Clone, OriginRow, 
															OnAddViewNotify = Undefined, 
															OnCopyViewNotify = Undefined,
															FillingValues = Undefined)
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
		If NewRow.Property("Key") Then
			ArrayOfExcludeProperties.Add("Key");
		EndIf;
		
		FillPropertyValues(NewRow, OriginRows[0], , StrConcat(ArrayOfExcludeProperties, ","));
		
		Rows = GetRowsByCurrentData(Form, TableName, NewRow);
		Parameters = GetSimpleParameters(Object, Form, TableName, Rows);
		ControllerClientServer_V2.CopyRowSimpleTable(TableName, Parameters, OnCopyViewNotify);
	Else // Add()
		NewRow.Key = String(New UUID());
		Rows = GetRowsByCurrentData(Form, TableName, NewRow);
		Parameters = GetSimpleParameters(Object, Form, TableName, Rows);
		
		Transfer = New Structure("Form, Object", Parameters.Form, Parameters.Object);
		ModelClientServer_V2.TransferFormToStructure(Transfer, Parameters);
		ViewServer_V2.AddNewRowAtServer(TableName, Parameters, OnAddViewNotify, FillingValues);
		ModelClientServer_V2.TransferStructureToForm(Transfer, Parameters);
		ControllerClientServer_V2.CommitChainChanges(Parameters);
	EndIf;
	Return NewRow;
EndFunction

Procedure DeleteRows(Object, Form, TableName, ViewNotify = Undefined)
	Parameters = GetSimpleParameters(Object, Form, TableName);
	ControllerClientServer_V2.DeleteRows(TableName, Parameters, ViewNotify);
EndProcedure

#EndRegion

#Region FORM

Procedure OnOpen(Object, Form, TableNames) Export
	UpdateCacheBeforeChange(Object, Form);
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TrimAll(TableName));
		ControllerClientServer_V2.FormOnOpen(Parameters);
	EndDo;
EndProcedure

Procedure OnOpenFormNotify(Parameters) Export
	If Parameters.ObjectMetadataInfo.Tables.Property("SerialLotNumbers") Then
		SerialLotNumberClient.UpdateSerialLotNumbersPresentation(Parameters.Object);
	EndIf;
	
	If Parameters.ObjectMetadataInfo.Tables.Property("ControlCodeStrings") Then
		ControlCodeStringsClient.UpdateState(Parameters.Object);
	EndIf;
	
	If Parameters.ObjectMetadataInfo.Tables.Property("SourceOfOrigins") Then
		SourceOfOriginClient.UpdateSourceOfOriginsPresentation(Parameters.Object);
	EndIf;
	
	If Parameters.ObjectMetadataInfo.MetadataName = "SalesInvoice" 
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseReturn" Then
		DocumentsClient.SetLockedRowsForItemListByTradeDocuments(Parameters.Object, Parameters.Form, "ShipmentConfirmations");
	EndIf;
	
	If Parameters.ObjectMetadataInfo.MetadataName = "PurchaseInvoice" 
		Or Parameters.ObjectMetadataInfo.MetadataName = "SalesReturn" Then
		DocumentsClient.SetLockedRowsForItemListByTradeDocuments(Parameters.Object, Parameters.Form, "GoodsReceipts");
	EndIf;
	
	If Parameters.ObjectMetadataInfo.MetadataName = "CashExpense"
		Or Parameters.ObjectMetadataInfo.MetadataName = "CashRevenue"
		Or Parameters.ObjectMetadataInfo.MetadataName = "InventoryTransfer"
		Or Parameters.ObjectMetadataInfo.MetadataName = "InventoryTransferOrder"
		Or Parameters.ObjectMetadataInfo.MetadataName = "EmployeeCashAdvance" Then
		Parameters.Form.FormSetVisibilityAvailability();
	EndIf;
	 
	UpdateTotalAmounts(Parameters);
	
	If Parameters.Form.IsCopyingInteractive Then
		SetDate(Parameters.Object, Parameters.Form, Parameters.TableName, CommonFunctionsServer.GetCurrentSessionDate());
	EndIf;
	
	DocumentsClient.SetTextOfDescriptionAtForm(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region COMMANDS

Procedure ExecuteCommand(Object, Form, TableName, CommandName) Export
	FormParameters = ControllerClientServer_V2.GetFormParameters(Form);
	ServerParameters = ControllerClientServer_V2.GetServerParameters(Object);
	ServerParameters.TableName = TableName;
	Parameters = ControllerClientServer_V2.GetParameters(ServerParameters, FormParameters);
	ControllerClientServer_V2.API_SetProperty(Parameters, New Structure("DataPath", CommandName), Undefined);
EndProcedure

#EndRegion

#Region INVENTORY

Function InventoryBeforeAddRow(Object, Form, Cancel = False, Clone = False, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, "Inventory", Cancel, Clone, CurrentData,
		"InventoryOnAddRowFormNotify", "InventoryOnCopyRowFormNotify");
	Form.Items.Inventory.CurrentRow = NewRow.GetID();
	If Form.Items.Inventory.CurrentRow <> Undefined Then
		Form.Items.Inventory.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure InventoryOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure InventoryOnCopyRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure InventoryAfterDeleteRow(Object, Form) Export
	DeleteRows(Object, Form, "Inventory");
EndProcedure

#EndRegion

#Region INVENTORY_COLUMNS

#Region INVENTORY_ITEM

// Inventory.Item
Procedure InventoryItemOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "Inventory", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "Inventory", Rows);
	ControllerClientServer_V2.InventoryItemOnChange(Parameters);
EndProcedure

#EndRegion

#Region INVENTORY_ITEM_KEY

// Inventory.ItemKey
Procedure InventoryItemKeyOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "Inventory", CurrentData);
	FormParameters = GetFormParameters(Form);
	FetchFromCacheBeforeChange_List("Inventory.ItemKey", FormParameters, Rows);
	
	ServerParameters = GetServerParameters(Object);
	ServerParameters.Rows      = Rows;
	ServerParameters.TableName = "Inventory";
	
	Parameters = GetParameters(ServerParameters, FormParameters);
	ControllerClientServer_V2.InventoryItemKeyOnChange(Parameters);
EndProcedure

#EndRegion

#Region INVENTORY_QUANTITY

// Inventory.Quantity
Procedure InventoryQuantityOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "Inventory", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "Inventory", Rows);
	ControllerClientServer_V2.InventoryQuantityOnChange(Parameters);
EndProcedure

#EndRegion

#Region INVENTORY_PRICE

// Inventory.Price
Procedure InventorytPriceOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "Inventory", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "Inventory", Rows);
	ControllerClientServer_V2.InventoryPriceOnChange(Parameters);
EndProcedure

#EndRegion

#Region INVENTORY_AMOUNT

// Inventory.Amount
Procedure InventoryAmountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "Inventory", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "Inventory", Rows);
	ControllerClientServer_V2.InventoryAmountOnChange(Parameters);
EndProcedure

#EndRegion

#EndRegion

#Region FIXED_ASSETS

Function FixedAssetsBeforeAddRow(Object, Form, Cancel = False, Clone = False, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, "FixedAssets", Cancel, Clone, CurrentData,
		"FixedAssetsOnAddRowFormNotify", "FixedAssetsOnCopyRowFormNotify");
	Form.Items.FixedAssets.CurrentRow = NewRow.GetID();
	If Form.Items.FixedAssets.CurrentRow <> Undefined Then
		Form.Items.FixedAssets.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure FixedAssetsOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure FixedAssetsOnCopyRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure FixedAssetsAfterDeleteRow(Object, Form) Export
	DeleteRows(Object, Form, "FixedAssets");
EndProcedure

#EndRegion

#Region EMPLOYEE_CASH_ADVANCE

Function EmployeeCashAdvanceBeforeAddRow(Object, Form, Cancel = False, Clone = False, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, "EmployeeCashAdvance", Cancel, Clone, CurrentData,
		"EmployeeCashAdvanceOnAddRowFormNotify", "EmployeeCashAdvanceOnCopyRowFormNotify");
	Form.Items.EmployeeCashAdvance.CurrentRow = NewRow.GetID();
	If Form.Items.EmployeeCashAdvance.CurrentRow <> Undefined Then
		Form.Items.EmployeeCashAdvance.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure EmployeeCashAdvanceOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure EmployeeCashAdvanceOnCopyRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure EmployeeCashAdvanceAfterDeleteRow(Object, Form) Export
	DeleteRows(Object, Form, "EmployeeCashAdvance");
EndProcedure

#EndRegion

#Region EMPLOYEE_CASH_ADVANCE_COLUMNS

#Region EMPLOYEE_CASH_ADVANCE_ACCOUNT

// EmployeeCashAdvance.Account
Procedure EmployeeCashAdvanceAccountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "EmployeeCashAdvance", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "EmployeeCashAdvance", Rows);
	ControllerClientServer_V2.EmployeeCashAdvanceAccountOnChange(Parameters);
EndProcedure

#EndRegion

#EndRegion

#Region ADVANCE_FROM_RETAIL_CUSTOMERS

Function AdvanceFromRetailCustomersBeforeAddRow(Object, Form, Cancel = False, Clone = False, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, "AdvanceFromRetailCustomers", Cancel, Clone, CurrentData,
		"AdvanceFromRetailCustomersOnAddRowFormNotify", "AdvanceFromRetailCustomersOnCopyRowFormNotify");
	Form.Items.AdvanceFromRetailCustomers.CurrentRow = NewRow.GetID();
	If Form.Items.AdvanceFromRetailCustomers.CurrentRow <> Undefined Then
		Form.Items.AdvanceFromRetailCustomers.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure AdvanceFromRetailCustomersOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure AdvanceFromRetailCustomersOnCopyRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure AdvanceFromRetailCustomersAfterDeleteRow(Object, Form) Export
	DeleteRows(Object, Form, "AdvanceFromRetailCustomers");
EndProcedure

#EndRegion

#Region SALARY_PAYMENT

Function SalaryPaymentBeforeAddRow(Object, Form, Cancel = False, Clone = False, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, "SalaryPayment", Cancel, Clone, CurrentData,
		"SalaryPaymentOnAddRowFormNotify", "SalaryPaymentOnCopyRowFormNotify");
	Form.Items.SalaryPayment.CurrentRow = NewRow.GetID();
	If Form.Items.SalaryPayment.CurrentRow <> Undefined Then
		Form.Items.SalaryPayment.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure SalaryPaymentOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure SalaryPaymentOnCopyRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure SalaryPaymentAfterDeleteRow(Object, Form) Export
	DeleteRows(Object, Form, "SalaryPayment");
EndProcedure

#EndRegion

#Region EMPLOYEE_LIST

Function EmployeeListBeforeAddRow(Object, Form, Cancel = False, Clone = False, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, "EmployeeList", Cancel, Clone, CurrentData,
		"EmployeeListOnAddRowFormNotify", "EmployeeListOnCopyRowFormNotify");
	Form.Items.EmployeeList.CurrentRow = NewRow.GetID();
	If Form.Items.EmployeeList.CurrentRow <> Undefined Then
		Form.Items.EmployeeList.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure EmployeeListOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure EmployeeListOnCopyRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure EmployeeListAfterDeleteRow(Object, Form) Export
	DeleteRows(Object, Form, "EmployeeList");
EndProcedure

// EmployeeList.SalaryType
Procedure EmployeeListSalaryTypeOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "EmployeeList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "EmployeeList", Rows);
	ControllerClientServer_V2.EmployeeListSalaryTypeOnChange(Parameters);
EndProcedure

#EndRegion

#Region SHIPMENT_TO_TRADE_AGENT

Function ShipmentToTradeAgentBeforeAddRow(Object, Form, Cancel = False, Clone = False, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, "ShipmentToTradeAgent", Cancel, Clone, CurrentData,
		"ShipmentToTradeAgentOnAddRowFormNotify", "ShipmentToTradeAgentOnCopyRowFormNotify");
	Form.Items.ShipmentToTradeAgent.CurrentRow = NewRow.GetID();
	If Form.Items.ShipmentToTradeAgent.CurrentRow <> Undefined Then
		Form.Items.ShipmentToTradeAgent.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure ShipmentToTradeAgentOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure ShipmentToTradeAgentOnCopyRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure ShipmentToTradeAgentAfterDeleteRow(Object, Form) Export
	DeleteRows(Object, Form, "ShipmentToTradeAgent");
EndProcedure

#EndRegion

#Region SHIPMENT_TO_TRADE_AGENT_COLUMNS

#Region SHIPMENT_TO_TRADE_AGENT_ITEM

// ShipmentToTradeAgent.Item
Procedure ShipmentToTradeAgentItemOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ShipmentToTradeAgent", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ShipmentToTradeAgent", Rows);
	ControllerClientServer_V2.ShipmentToTradeAgentItemOnChange(Parameters);
EndProcedure

#EndRegion

#Region SHIPMENT_TO_TRADE_AGENT_ITEM_KEY

// ShipmentToTradeAgent.ItemKey
Procedure ShipmentToTradeAgentItemKeyOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ShipmentToTradeAgent", CurrentData);
	FormParameters = GetFormParameters(Form);
	FetchFromCacheBeforeChange_List("ShipmentToTradeAgent.ItemKey", FormParameters, Rows);
	
	ServerParameters = GetServerParameters(Object);
	ServerParameters.Rows      = Rows;
	ServerParameters.TableName = "ShipmentToTradeAgent";
	
	Parameters = GetParameters(ServerParameters, FormParameters);
	ControllerClientServer_V2.ShipmentToTradeAgentItemKeyOnChange(Parameters);
EndProcedure

#EndRegion

#Region SHIPMENT_TO_TRADE_AGENT_QUANTITY

// ShipmentToTradeAgent.Quantity
Procedure ShipmentToTradeAgentQuantityOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ShipmentToTradeAgent", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ShipmentToTradeAgent", Rows);
	ControllerClientServer_V2.ShipmentToTradeAgentQuantityOnChange(Parameters);
EndProcedure

#EndRegion

#EndRegion

#Region RECEIPT_FROM_CONSIGNOR

Function ReceiptFromConsignorBeforeAddRow(Object, Form, Cancel = False, Clone = False, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, "ReceiptFromConsignor", Cancel, Clone, CurrentData,
		"ReceiptFromConsignorOnAddRowFormNotify", "ReceiptFromConsignorOnCopyRowFormNotify");
	Form.Items.ReceiptFromConsignor.CurrentRow = NewRow.GetID();
	If Form.Items.ReceiptFromConsignor.CurrentRow <> Undefined Then
		Form.Items.ReceiptFromConsignor.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure ReceiptFromConsignorOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure ReceiptFromConsignorOnCopyRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure ReceiptFromConsignorAfterDeleteRow(Object, Form) Export
	DeleteRows(Object, Form, "ReceiptFromConsignor");
EndProcedure

#EndRegion

#Region RECEIPT_FROM_CONSIGNOR_COLUMNS

#Region RECEIPT_FROM_CONSIGNOR_ITEM

// ReceiptFromConsignor.Item
Procedure ReceiptFromConsignorItemOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ReceiptFromConsignor", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ReceiptFromConsignor", Rows);
	ControllerClientServer_V2.ReceiptFromConsignorItemOnChange(Parameters);
EndProcedure

#EndRegion

#Region RECEIPT_FROM_CONSIGNOR_ITEM_KEY

// ReceiptFromConsignor.ItemKey
Procedure ReceiptFromConsignorItemKeyOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ReceiptFromConsignor", CurrentData);
	FormParameters = GetFormParameters(Form);
	FetchFromCacheBeforeChange_List("ReceiptFromConsignor.ItemKey", FormParameters, Rows);
	
	ServerParameters = GetServerParameters(Object);
	ServerParameters.Rows      = Rows;
	ServerParameters.TableName = "ReceiptFromConsignor";
	
	Parameters = GetParameters(ServerParameters, FormParameters);
	ControllerClientServer_V2.ReceiptFromConsignorItemKeyOnChange(Parameters);
EndProcedure

#EndRegion

#Region RECEIPT_FROM_CONSIGNOR_QUANTITY

// ReceiptFromConsignor.Quantity
Procedure ReceiptFromConsignorQuantityOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ReceiptFromConsignor", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ReceiptFromConsignor", Rows);
	ControllerClientServer_V2.ReceiptFromConsignorQuantityOnChange(Parameters);
EndProcedure

#EndRegion

#Region RECEIPT_FROM_CONSIGNOR_PRICE

// ReceiptFromConsignor.Price
Procedure ReceiptFromConsignorPriceOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ReceiptFromConsignor", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ReceiptFromConsignor", Rows);
	ControllerClientServer_V2.ReceiptFromConsignorPriceOnChange(Parameters);
EndProcedure

#EndRegion

#Region RECEIPT_FROM_CONSIGNOR_AMOUNT

// ReceiptFromConsignor.Amount
Procedure ReceiptFromConsignorAmountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ReceiptFromConsignor", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ReceiptFromConsignor", Rows);
	ControllerClientServer_V2.ReceiptFromConsignorAmountOnChange(Parameters);
EndProcedure

#EndRegion

#EndRegion

#Region ACCOUNT_BALANCE

Function AccountBalanceBeforeAddRow(Object, Form, Cancel = False, Clone = False, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, "AccountBalance", Cancel, Clone, CurrentData,
		"AccountBalanceOnAddRowFormNotify", "AccountBalanceOnCopyRowFormNotify");
	Form.Items.AccountBalance.CurrentRow = NewRow.GetID();
	If Form.Items.AccountBalance.CurrentRow <> Undefined Then
		Form.Items.AccountBalance.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure AccountBalanceOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure AccountBalanceOnCopyRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure AccountBalanceAfterDeleteRow(Object, Form) Export
	DeleteRows(Object, Form, "AccountBalance");
EndProcedure

#EndRegion

#Region ACCOUNT_BALANCE_COLUMNS

#Region ACCOUNT_BALANCE_ACCOUNT

// AccountBalance.Account
Procedure AccountBalanceAccountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "AccountBalance", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "AccountBalance", Rows);
	ControllerClientServer_V2.AccountBalanceAccountOnChange(Parameters);
EndProcedure

#EndRegion

#EndRegion

#Region CASH_IN_TRANSIT

Function CashInTransitBeforeAddRow(Object, Form, Cancel = False, Clone = False, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, "CashInTransit", Cancel, Clone, CurrentData,
		"CashInTransitOnAddRowFormNotify", "CashInTransitOnCopyRowFormNotify");
	Form.Items.CashInTransit.CurrentRow = NewRow.GetID();
	If Form.Items.CashInTransit.CurrentRow <> Undefined Then
		Form.Items.CashInTransit.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure CashInTransitOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure CashInTransitOnCopyRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure CashInTransitAfterDeleteRow(Object, Form) Export
	DeleteRows(Object, Form, "CashInTransit");
EndProcedure

#EndRegion

#Region CASH_IN_TRANSIT_COLUMNS

#Region CASH_IN_TRANSIT_RECEIPTING_ACCOUNT

// CashInTransit.ReceiptingAccount
Procedure CashInTransitReceiptingAccountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "CashInTransit", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "CashInTransit", Rows);
	ControllerClientServer_V2.CashInTransitReceiptingAccountOnChange(Parameters);
EndProcedure

#EndRegion

#EndRegion

#Region CHEQUE_BONDS

Function ChequeBondsBeforeAddRow(Object, Form, Cancel = False, Clone = False, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, "ChequeBonds", Cancel, Clone, CurrentData,
		"ChequeBondsOnAddRowFormNotify", "ChequeBondsOnCopyRowFormNotify");
	Form.Items.ChequeBonds.CurrentRow = NewRow.GetID();
	If Form.Items.ChequeBonds.CurrentRow <> Undefined Then
		Form.Items.ChequeBonds.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure ChequeBondsOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure ChequeBondsOnCopyRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure ChequeBondsAfterDeleteRow(Object, Form) Export
	DeleteRows(Object, Form, "ChequeBonds", "ChequeBondsAfterDeleteRowFormNotify");
EndProcedure

Procedure ChequeBondsAfterDeleteRowFormNotify(Parameters) Export
	Return;
EndProcedure

Function ChequeBondsAddFilledRow(Object, Form,  FillingValues) Export
	Cancel      = False;
	Clone       = False;
	CurrentData = Undefined;
	NewRow = AddOrCopyRow(Object, Form, "ChequeBonds", Cancel, Clone, CurrentData,
		"ChequeBondsOnAddRowFormNotify", "ChequeBondsOnCopyRowFormNotify", FillingValues);
	Form.Items.ChequeBonds.CurrentRow = NewRow.GetID();
	If Form.Items.ChequeBonds.CurrentRow <> Undefined Then
		Form.Items.ChequeBonds.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

#EndRegion

#Region CHEQUE_BONDS_COLUMNS

// ChequeBonds.Cheque
Procedure ChequeBondsChequeOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ChequeBonds", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ChequeBonds", Rows);
	ControllerClientServer_V2.ChequeBondsChequeOnChange(Parameters);
EndProcedure

Procedure OnSetChequeBondsChequeNotify(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "ChequeBondTransaction" Then
		Parameters.Form.FormSetVisibilityAvailability();
	EndIf;
EndProcedure

// ChequeBonds.NewStatus
Procedure ChequeBondsNewStatusOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ChequeBonds", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ChequeBonds", Rows);
	ControllerClientServer_V2.ChequeBondsNewStatusOnChange(Parameters);
EndProcedure

// ChequeBonds.Partner
Procedure ChequeBondsPartnerOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ChequeBonds", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ChequeBonds", Rows);
	ControllerClientServer_V2.ChequeBondsPartnerOnChange(Parameters);
EndProcedure

// ChequeBonds.Agreement
Procedure ChequeBondsAgreementOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ChequeBonds", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ChequeBonds", Rows);
	ControllerClientServer_V2.ChequeBondsAgreementOnChange(Parameters);
EndProcedure

// ChequeBonds.LegalName
Procedure ChequeBondsLegalNameOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ChequeBonds", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ChequeBonds", Rows);
	ControllerClientServer_V2.ChequeBondsLegalNameOnChange(Parameters);
EndProcedure

// ChequeBonds.BasisDocument
Procedure ChequeBondsBasisDocumentOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ChequeBonds", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ChequeBonds", Rows);
	ControllerClientServer_V2.ChequeBondsBasisDocumentOnChange(Parameters);
EndProcedure

// ChequeBonds.BasisDocument.Set
Procedure SetChequeBondsBasisDocument(Object, Form, Row, Value) Export
	Row.BasisDocument = Value;
	Rows = GetRowsByCurrentData(Form, "ChequeBonds", Row);
	Parameters = GetSimpleParameters(Object, Form, "ChequeBonds", Rows);
	Parameters.Insert("IsProgramChange", True);
	ControllerClientServer_V2.ChequeBondsBasisDocumentOnChange(Parameters);
EndProcedure

// ChequeBonds.Order
Procedure ChequeBondsOrderOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ChequeBonds", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ChequeBonds", Rows);
	ControllerClientServer_V2.ChequeBondsOrderOnChange(Parameters);
EndProcedure

// ChequeBonds.Order.Set
Procedure SetChequeBondsOrder(Object, Form, Row, Value) Export
	Row.Order = Value;
	Rows = GetRowsByCurrentData(Form, "ChequeBonds", Row);
	Parameters = GetSimpleParameters(Object, Form, "ChequeBonds", Rows);
	Parameters.Insert("IsProgramChange", True);
	ControllerClientServer_V2.ChequeBondsOrderOnChange(Parameters);
EndProcedure

#EndRegion

#Region MATERIALS

Function MaterialsBeforeAddRow(Object, Form, Cancel = False, Clone = False, CurrentData = Undefined, KeyOwner = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, "Materials", Cancel, Clone, CurrentData,
		"MaterialsOnAddRowFormNotify", "MaterialsOnCopyRowFormNotify", Undefined, KeyOwner);
	Form.Items.Materials.CurrentRow = NewRow.GetID();
	If Form.Items.Materials.CurrentRow <> Undefined Then
		Form.Items.Materials.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure MaterialsOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure MaterialsOnCopyRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure MaterialsAfterDeleteRow(Object, Form) Export
	DeleteRows(Object, Form, "Materials");
EndProcedure

#EndRegion

#Region MATERIALS_COLUMNS

#Region MATERIALS_ITEM

// Materials.Item
Procedure MaterialsItemOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "Materials", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "Materials", Rows);
	ControllerClientServer_V2.MaterialsItemOnChange(Parameters);
EndProcedure

#EndRegion

#Region MATERIALS_ITEM_KEY

// Materials.ItemKey
Procedure MaterialsItemKeyOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "Materials", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "Materials", Rows);
	ControllerClientServer_V2.MaterialsItemKeyOnChange(Parameters);
EndProcedure

#EndRegion

#Region MATERIALS_UNIT

// Materials.Unit
Procedure MaterialsUnitOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "Materials", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "Materials", Rows);
	ControllerClientServer_V2.MaterialsUnitOnChange(Parameters);
EndProcedure

#EndRegion

#Region MATERIALS_QUANTITY

// Materials.Quantity
Procedure MaterialsQuantityOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "Materials", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "Materials", Rows);
	ControllerClientServer_V2.MaterialsQuantityOnChange(Parameters);
EndProcedure

#EndRegion

#Region MATERIALS_COST_WRITE_OFF

// Materials.CostWriteOff
Procedure MaterialsCostWriteOffOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "Materials", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "Materials", Rows);
	ControllerClientServer_V2.MaterialsCostWriteOffOnChange(Parameters);
EndProcedure

#EndRegion

#Region MATERIALS_MATERIAL_TYPE

// Materials.MaterialType
Procedure MaterialsMaterialTypeOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "Materials", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "Materials", Rows);
	ControllerClientServer_V2.MaterialsMaterialTypeOnChange(Parameters);
EndProcedure

Procedure OnSetMaterialsMaterialTypeNotify(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "Production" Then
		Parameters.Form.FormSetVisibilityAvailability();
	EndIf;
EndProcedure

#EndRegion

#EndRegion

#Region WORKERS

Function WorkersBeforeAddRow(Object, Form, Cancel = False, Clone = False, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, "Workers", Cancel, Clone, CurrentData,
		"WorkersOnAddRowFormNotify", "WorkersOnCopyRowFormNotify");
	Form.Items.Workers.CurrentRow = NewRow.GetID();
	If Form.Items.Workers.CurrentRow <> Undefined Then
		Form.Items.Workers.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure WorkersOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure WorkersOnCopyRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

#EndRegion

#Region PRODUCTIONS

Function ProductionsBeforeAddRow(Object, Form, Cancel = False, Clone = False, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, "Productions", Cancel, Clone, CurrentData,
		"ProductionsOnAddRowFormNotify", "ProductionsOnCopyRowFormNotify");
	Form.Items.Productions.CurrentRow = NewRow.GetID();
	If Form.Items.Productions.CurrentRow <> Undefined Then
		Form.Items.Productions.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure ProductionsOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure ProductionsOnCopyRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure ProductionsAfterDeleteRow(Object, Form) Export
	DeleteRows(Object, Form, "Productions");
EndProcedure

#EndRegion

#Region PRODUCTIONS_COLUMNS

#Region PRODUCTIONS_ITEM

// Productions.Item
Procedure ProductionsItemOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "Productions", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "Productions", Rows);
	ControllerClientServer_V2.ProductionsItemOnChange(Parameters);
EndProcedure

#EndRegion

#Region PRODUCTIONS_ITEM_KEY

// Productions.ItemKey
Procedure ProductionsItemKeyOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "Productions", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "Productions", Rows);
	ControllerClientServer_V2.ProductionsItemKeyOnChange(Parameters);
EndProcedure

#EndRegion

#Region PRODUCTIONS_UNIT

// Productions.Unit
Procedure ProductionsUnitOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "Productions", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "Productions", Rows);
	ControllerClientServer_V2.ProductionsUnitOnChange(Parameters);
EndProcedure

#EndRegion

#Region PRODUCTIONS_QUANTITY

// Productions.Quantity
Procedure ProductionsQuantityOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "Productions", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "Productions", Rows);
	ControllerClientServer_V2.ProductionsQuantityOnChange(Parameters);
EndProcedure

#EndRegion

#Region PRODUCTIONS_BILL_OF_MATERIALS

// Productions.BillOfMaterials
Procedure ProductionsBillOfMaterialsOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "Productions", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "Productions", Rows);
	ControllerClientServer_V2.ProductionsBillOfMaterialsOnChange(Parameters);
EndProcedure

#EndRegion

#Region PRODUCTIONS_CURRENT_QUANTITY

// Productions.CurrentQuantity
Procedure OnSetProductionsCurrentQuantityNotify(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "ProductionPlanningCorrection" Then
		Parameters.Form.FormSetVisibilityAvailability();
	EndIf;
EndProcedure

#EndRegion

#EndRegion

#Region PRODUCTION_DURATIONS_LIST

Procedure ProductionDurationsListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	ListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing);
EndProcedure

Function ProductionDurationsListBeforeAddRow(Object, Form, Cancel = False, Clone = False, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, "ProductionDurationsList", Cancel, Clone, CurrentData,
		"ProductionDurationsListOnAddRowFormNotify", "ProductionDurationsListOnCopyRowFormNotify");
	Form.Items.ProductionDurationsList.CurrentRow = NewRow.GetID();
	If Form.Items.ProductionDurationsList.CurrentRow <> Undefined Then
		Form.Items.ProductionDurationsList.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure ProductionDurationsListOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure ProductionDurationsListOnCopyRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure ProductionDurationsListAfterDeleteRow(Object, Form) Export
	DeleteRows(Object, Form, "ProductionDurationsList", "ProductionDurationsListAfterDeleteRowFormNotify");
EndProcedure

Procedure ProductionDurationsListAfterDeleteRowFormNotify(Parameters) Export
	Return;
EndProcedure

Function ProductionDurationsListAddFilledRow(Object, Form,  FillingValues) Export
	Cancel      = False;
	Clone       = False;
	CurrentData = Undefined;
	NewRow = AddOrCopyRow(Object, Form, "ProductionDurationsList", Cancel, Clone, CurrentData,
		"ProductionDurationsListOnAddRowFormNotify", "ProductionDurationsListOnCopyRowFormNotify", FillingValues);
	Form.Items.ProductionDurationsList.CurrentRow = NewRow.GetID();
	If Form.Items.ProductionDurationsList.CurrentRow <> Undefined Then
		Form.Items.ProductionDurationsList.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure ProductionDurationsListLoad(Object, Form, Address, GroupColumn = "", SumColumn = "") Export
	Parameters = GetLoadParameters(Object, Form, "ProductionDurationsList", Address, GroupColumn, SumColumn);
	Parameters.LoadData.ExecuteAllViewNotify = True;
	ControllerClientServer_V2.AddEmptyRowsForLoad(Parameters);
	ControllerClientServer_V2.ProductionDurationsListLoad(Parameters);
EndProcedure

#EndRegion

#Region PRODUCTION_DURATIONS_LIST_COLUMNS

#Region PRODUCTION_DURATIONS_LIST_ITEM

// ProductionDurationsList.Item
Procedure ProductionDurationsListItemOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ProductionDurationsList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ProductionDurationsList", Rows);
	ControllerClientServer_V2.ProductionDurationsListItemOnChange(Parameters);
EndProcedure

#EndRegion

#Region PRODUCTION_DURATIONS_LIST_ITEM_KEY

// ProductionDurationsList.ItemKey
Procedure ProductionDurationsListItemKeyOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ProductionDurationsList", CurrentData);
	FormParameters = GetFormParameters(Form);
	FetchFromCacheBeforeChange_List("ProductionDurationsList.ItemKey", FormParameters, Rows);
	
	ServerParameters = GetServerParameters(Object);
	ServerParameters.Rows      = Rows;
	ServerParameters.TableName = "ProductionDurationsList";
	
	Parameters = GetParameters(ServerParameters, FormParameters);
	ControllerClientServer_V2.ProductionDurationsListItemKeyOnChange(Parameters);
EndProcedure

#EndRegion

#Region PRODUCTION_DURATIONS_LIST_DURATION

// ProductionDurationsList.Duration
Procedure ProductionDurationsListDurationOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ProductionDurationsList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ProductionDurationsList", Rows);
	ControllerClientServer_V2.ProductionDurationsListDurationOnChange(Parameters);
EndProcedure

#EndRegion

#Region PRODUCTION_DURATIONS_LIST_AMOUNT

// ProductionDurationsList.Amount
Procedure ProductionDurationsListAmountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ProductionDurationsList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ProductionDurationsList", Rows);
	ControllerClientServer_V2.ProductionDurationsListAmountOnChange(Parameters);
EndProcedure

#EndRegion

#EndRegion

#Region PRODUCTION_COSTS_LIST

Procedure ProductionCostsListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	ListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing);
EndProcedure

Function ProductionCostsListBeforeAddRow(Object, Form, Cancel = False, Clone = False, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, "ProductionCostsList", Cancel, Clone, CurrentData,
		"ProductionCostsListOnAddRowFormNotify", "ProductionCostsListOnCopyRowFormNotify");
	Form.Items.ProductionCostsList.CurrentRow = NewRow.GetID();
	If Form.Items.ProductionCostsList.CurrentRow <> Undefined Then
		Form.Items.ProductionCostsList.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure ProductionCostsListOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure ProductionCostsListOnCopyRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure ProductionCostsListAfterDeleteRow(Object, Form) Export
	DeleteRows(Object, Form, "ProductionCostsList", "ProductionCostsListAfterDeleteRowFormNotify");
EndProcedure

Procedure ProductionCostsListAfterDeleteRowFormNotify(Parameters) Export
	Return;
EndProcedure

Function ProductionCostsListAddFilledRow(Object, Form,  FillingValues) Export
	Cancel      = False;
	Clone       = False;
	CurrentData = Undefined;
	NewRow = AddOrCopyRow(Object, Form, "ProductionCostsList", Cancel, Clone, CurrentData,
		"ProductionCostsListOnAddRowFormNotify", "ProductionCostsListOnCopyRowFormNotify", FillingValues);
	Form.Items.ProductionCostsList.CurrentRow = NewRow.GetID();
	If Form.Items.ProductionCostsList.CurrentRow <> Undefined Then
		Form.Items.ProductionCostsList.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure ProductionCostsListLoad(Object, Form, Address, GroupColumn = "", SumColumn = "") Export
	Parameters = GetLoadParameters(Object, Form, "ProductionCostsList", Address, GroupColumn, SumColumn);
	Parameters.LoadData.ExecuteAllViewNotify = True;
	ControllerClientServer_V2.AddEmptyRowsForLoad(Parameters);
	ControllerClientServer_V2.ProductionCostsListLoad(Parameters);
EndProcedure

#EndRegion

#Region PRODUCTION_COSTS_LIST_COLUMNS

#Region PRODUCTION_COSTS_LIST_AMOUNT

// ProductionCostsList.Amount
Procedure ProductionCostsListAmountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ProductionCostsList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ProductionCostsList", Rows);
	ControllerClientServer_V2.ProductionCostsListAmountOnChange(Parameters);
EndProcedure

#EndRegion

#EndRegion

#Region _ITEM_LIST_

Procedure ItemListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	ListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing);
EndProcedure

Function ItemListBeforeAddRow(Object, Form, Cancel = False, Clone = False, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, "ItemList", Cancel, Clone, CurrentData,
		"ItemListOnAddRowFormNotify", "ItemListOnCopyRowFormNotify");
	Form.Items.ItemList.CurrentRow = NewRow.GetID();
	If Form.Items.ItemList.CurrentRow <> Undefined Then
		Form.Items.ItemList.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure ItemListOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure ItemListOnCopyRowFormNotify(Parameters) Export
	SourceOfOriginClientServer.UpdateSourceOfOriginsQuantity(Parameters.Object);
	Parameters.Form.Modified = True;
EndProcedure

Procedure ItemListAfterDeleteRow(Object, Form) Export
	DeleteRows(Object, Form, "ItemList", "ItemListAfterDeleteRowFormNotify");
EndProcedure

Procedure ItemListAfterDeleteRowFormNotify(Parameters) Export
	
	If Parameters.ObjectMetadataInfo.Tables.Property("SerialLotNumbers") Then
		SerialLotNumberClient.DeleteUnusedSerialLotNumbers(Parameters.Object);
	EndIf;
	
	If Parameters.ObjectMetadataInfo.Tables.Property("SourceOfOrigins") Then
		SourceOfOriginClient.DeleteUnusedSourceOfOrigins(Parameters.Object, Parameters.Form);
	EndIf;
	
	UpdateTotalAmounts(Parameters);
	Parameters.Form.FormSetVisibilityAvailability();
EndProcedure

Function ItemListAddFilledRow(Object, Form,  FillingValues) Export
	Cancel      = False;
	Clone       = False;
	CurrentData = Undefined;
	NewRow = AddOrCopyRow(Object, Form, "ItemList", Cancel, Clone, CurrentData,
		"ItemListOnAddRowFormNotify", "ItemListOnCopyRowFormNotify", FillingValues);
	Form.Items.ItemList.CurrentRow = NewRow.GetID();
	If Form.Items.ItemList.CurrentRow <> Undefined Then
		Form.Items.ItemList.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure ItemListLoad(Object, Form, Address, GroupColumn = "", SumColumn = "") Export
	Parameters = GetLoadParameters(Object, Form, "ItemList", Address, GroupColumn, SumColumn);
	
	Parameters.IsBackgroundJob = True;
	Parameters.ShowBackgroundJobSplash = True;
	Parameters.BackgroundJobTitle = R().BgJ_Title_002;
	
	Parameters.LoadData.ExecuteAllViewNotify = True;
	ControllerClientServer_V2.AddEmptyRowsForLoad(Parameters);
	ControllerClientServer_V2.ItemListLoad(Parameters);
EndProcedure

#EndRegion

#Region _ITEM_LIST_COLUMNS

#Region ITEM_LIST_PARTNER_ITEM

// ItemList.PartnerItem
Procedure ItemListPartnerItemOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListPartnerItemOnChange(Parameters);
EndProcedure

#EndRegion

#Region ITEM_LIST_ITEM

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

Procedure OnSetItemListItem(Parameters) Export
	If Parameters.ObjectMetadataInfo.Tables.Property("ControlCodeStrings") Then
		If Not Parameters.isRowsAddByScan Then 
			ControlCodeStringsClient.ClearAllByRow(Parameters.Object, Parameters.Rows);
			ControlCodeStringsClient.UpdateState(Parameters.Object);
		EndIf;
	EndIf;
EndProcedure

#EndRegion

#Region ITEM_LIST_ITEM_KEY

// ItemList.ItemKey
Procedure ItemListItemKeyOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	FormParameters = GetFormParameters(Form);
	FetchFromCacheBeforeChange_List("ItemList.ItemKey", FormParameters, Rows);
	
	ServerParameters = GetServerParameters(Object);
	ServerParameters.Rows      = Rows;
	ServerParameters.TableName = "ItemList";
	
	Parameters = GetParameters(ServerParameters, FormParameters);
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
	If Parameters.ObjectMetadataInfo.Tables.Property("SerialLotNumbers") Then
		SerialLotNumberClient.DeleteUnusedSerialLotNumbers(Parameters.Object);
		SerialLotNumberClient.UpdateSerialLotNumbersPresentation(Parameters.Object);
	EndIf;
	
	If Parameters.ObjectMetadataInfo.Tables.Property("SourceOfOrigins") Then
		SourceOfOriginClient.DeleteUnusedSourceOfOrigins(Parameters.Object, Parameters.Form);
		SourceOfOriginClient.UpdateSourceOfOriginsPresentation(Parameters.Object);
	EndIf;
	
	If Parameters.ObjectMetadataInfo.Tables.Property("ControlCodeStrings") Then
		If Not Parameters.isRowsAddByScan Then 
			ControlCodeStringsClient.ClearAllByRow(Parameters.Object, Parameters.Rows);
			ControlCodeStringsClient.UpdateState(Parameters.Object);
		EndIf;
	EndIf;
EndProcedure

#EndRegion

#Region ITEM_LIST_BILL_OF_MATERIALS

// ItemList.BillOfMaterials
Procedure ItemListBillOfMaterialsOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	FormParameters = GetFormParameters(Form);
	
	ServerParameters = GetServerParameters(Object);
	ServerParameters.Rows      = Rows;
	ServerParameters.TableName = "ItemList";
	
	Parameters = GetParameters(ServerParameters, FormParameters);
	ControllerClientServer_V2.ItemListBillOfMaterialsOnChange(Parameters);
EndProcedure

Procedure OnSetItemListBillOfMaterialsNotify(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "WorkOrder"
		Or Parameters.ObjectMetadataInfo.MetadataName = "WorkSheet" Then
		VisibleRows = Parameters.Object.Materials.FindRows(New Structure("IsVisible", True));
		If VisibleRows.Count() Then
			Parameters.Form.Items.Materials.CurrentRow = VisibleRows[0].GetID();
		EndIf;
	EndIf;
EndProcedure

#EndRegion

#Region ITEM_LIST_UNIT

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

#EndRegion

#Region ITEM_LIST_CANCEL

// ItemList.Cancel
Procedure ItemListCancelOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListCancelOnChange(Parameters);
EndProcedure

Procedure OnSetItemListCancelNotify(Parameters) Export
	UpdateTotalAmounts(Parameters);
EndProcedure

#EndRegion

#Region ITEM_LIST_VAT_RATE

// ItemList.VatRate
Procedure ItemListVatRateOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListVatRateOnChange(Parameters);
EndProcedure

#EndRegion

#Region ITEM_LIST_PRICE_TYPE

// ItemList.PriceType
Procedure ItemListPriceTypeOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListPriceTypeOnChange(Parameters);
EndProcedure

#EndRegion

#Region ITEM_LIST_CONSIGNOR_PRICE

// ItemList.ConsignorPrice
Procedure ItemListConsignorPriceOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListConsignorPriceOnChange(Parameters);
EndProcedure

#EndRegion

#Region ITEM_LIST_TRADE_AGENT_FEE_PERCENT

// ItemList.TradeAgentFeePercent
Procedure ItemListTradeAgentFeePercentOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListTradeAgentFeePercentOnChange(Parameters);
EndProcedure

#EndRegion

#Region ITEM_LIST_TRADE_AGENT_FEE_AMOUNT

// ItemList.TradeAgentFeeAmount
Procedure ItemListTradeAgentFeeAmountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListTradeAgentFeeAmountOnChange(Parameters);
EndProcedure

#EndRegion

#Region ITEM_LIST_PRICE

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

#EndRegion

#Region ITEM_LIST_TAX_AMOUNT

// ItemList.TaxAmount
Procedure ItemListTaxAmountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListTaxAmountOnChange(Parameters);
EndProcedure

Procedure OnSetItemListTaxAmountNotify(Parameters) Export
	UpdateTotalAmounts(Parameters);
EndProcedure

#EndRegion

#Region ITEM_LIST_OFFERS_AMOUNT

// ItemList.OffersAmount
Procedure ItemListOffersAmountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListOffersAmountOnChange(Parameters);
EndProcedure

#EndRegion

#Region ITEM_LIST_NET_AMOUNT

// ItemList.NetAmount
Procedure ItemListNetAmountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListNetAmountOnChange(Parameters);
EndProcedure

Procedure OnSetItemListNetAmountNotify(Parameters) Export
	UpdateTotalAmounts(Parameters);
EndProcedure

#EndRegion

#Region ITEM_LIST_TOTAL_AMOUNT

// ItemList.TotalAmount
Procedure ItemListTotalAmountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListTotalAmountOnChange(Parameters);
EndProcedure

#EndRegion

#Region ITEM_LIST_AMOUNT

// ItemList.Amount
Procedure ItemListAmountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListAmountOnChange(Parameters);
EndProcedure

#EndRegion

#Region ITEM_LIST_STORE

// ItemList.Store
Procedure ItemListStoreOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	
	FormParameters = GetFormParameters(Form);
	FetchFromCacheBeforeChange_List("ItemList.Store", FormParameters, Rows);
	FormParameters.EventCaller = "ItemListStoreOnUserChange";

	ServerParameters = GetServerParameters(Object);
	ServerParameters.Rows      = Rows;
	ServerParameters.TableName = "ItemList";
	
	Parameters = GetParameters(ServerParameters, FormParameters);
	ControllerClientServer_V2.ItemListStoreOnChange(Parameters);
EndProcedure

#EndRegion

#Region ITEM_LIST_DELIVERY_DATE

// ItemList.DeliveryDate
Procedure ItemListDeliveryDateOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	
	FormParameters = GetFormParameters(Form);
	FetchFromCacheBeforeChange_List("ItemList.DeliveryDate", FormParameters, Rows);
	FormParameters.EventCaller = "ItemListDeliveryDateOnUserChange";

	ServerParameters = GetServerParameters(Object);
	ServerParameters.Rows      = Rows;
	ServerParameters.TableName = "ItemList";
	
	Parameters = GetParameters(ServerParameters, FormParameters);
	ControllerClientServer_V2.ItemListDeliveryDateOnChange(Parameters);
EndProcedure

#EndRegion

#Region ITEM_LIST_DONT_CALCULATE_ROW

// ItemList.DontCalculateRow
Procedure ItemListDontCalculateRowOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListDontCalculateRowOnChange(Parameters);
EndProcedure	

#EndRegion

#Region ITEM_LIST_QUANTITY_IN_BASE_UNIT

// ItemList.QuantityInBaseUnit
Procedure ItemListQuantityInBaseUnitOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListQuantityInBaseUnitOnChange(Parameters);
EndProcedure

Procedure OnSetItemListQuantityInBaseUnitNotify(Parameters) Export	
	If Parameters.ObjectMetadataInfo.Tables.Property("SourceOfOrigins") Then
		SourceOfOriginClient.UpdateSourceOfOriginsQuantity(Parameters.Object, Parameters.Form);
	EndIf;
	
	// Update -> RowIDInfoQuantity
	If Parameters.ObjectMetadataInfo.MetadataName = "SalesInvoice"
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseInvoice" 
		Or Parameters.ObjectMetadataInfo.MetadataName = "ShipmentConfirmation" 
		Or Parameters.ObjectMetadataInfo.MetadataName = "RetailShipmentConfirmation" 
		Or Parameters.ObjectMetadataInfo.MetadataName = "GoodsReceipt"
		Or Parameters.ObjectMetadataInfo.MetadataName = "RetailGoodsReceipt"
		Or Parameters.ObjectMetadataInfo.MetadataName = "StockAdjustmentAsSurplus"
		Or Parameters.ObjectMetadataInfo.MetadataName = "StockAdjustmentAsWriteOff"
		Or Parameters.ObjectMetadataInfo.MetadataName = "RetailSalesReceipt"
		Or Parameters.ObjectMetadataInfo.MetadataName = "RetailReceiptCorrection"
		Or Parameters.ObjectMetadataInfo.MetadataName = "RetailReturnReceipt"
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseReturn"
		Or Parameters.ObjectMetadataInfo.MetadataName = "SalesReturn"
		Or Parameters.ObjectMetadataInfo.MetadataName = "SalesOrder"
		Or Parameters.ObjectMetadataInfo.MetadataName = "WorkOrder"
		Or Parameters.ObjectMetadataInfo.MetadataName = "WorkSheet"
		Or Parameters.ObjectMetadataInfo.MetadataName = "SalesReturnOrder"
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseOrder"
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseReturnOrder"
		Or Parameters.ObjectMetadataInfo.MetadataName = "InventoryTransfer"
		Or Parameters.ObjectMetadataInfo.MetadataName = "InventoryTransferOrder" Then
		
		RowIDInfoClient.UpdateQuantity(Parameters.Object, Parameters.Form);
	EndIf;
	
	If CommonFunctionsClientServer.ObjectHasProperty(Parameters.Object, "ShipmentConfirmations") Then
		DocumentsClient.UpdateQuantityByTradeDocuments(Parameters.Object, "ShipmentConfirmations");
	EndIf;
	
	If CommonFunctionsClientServer.ObjectHasProperty(Parameters.Object, "GoodsReceipts") Then
		DocumentsClient.UpdateQuantityByTradeDocuments(Parameters.Object, "GoodsReceipts");
	EndIf;
	
	If Parameters.ObjectMetadataInfo.MetadataName = "WorkOrder"
		Or Parameters.ObjectMetadataInfo.MetadataName = "WorkSheet" Then
		VisibleRows = Parameters.Object.Materials.FindRows(New Structure("IsVisible", True));
		If VisibleRows.Count() Then
			Parameters.Form.Items.Materials.CurrentRow = VisibleRows[0].GetID();
		EndIf;
	EndIf;
	
	If Parameters.ObjectMetadataInfo.Tables.Property("ControlCodeStrings") Then
		If Not Parameters.isRowsAddByScan Then 
			ControlCodeStringsClient.ClearAllByRow(Parameters.Object, Parameters.UpdatedRowsByScan);
			ControlCodeStringsClient.UpdateState(Parameters.Object);
		EndIf;
	EndIf;
EndProcedure

#EndRegion

#Region QUANTITY_IS_FIXED

// ItemList.QuantityIsFixed
Procedure ItemListQuantityIsFixedOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListQuantityIsFixedOnChange(Parameters);
EndProcedure

Procedure OnSetItemListQuantityIsFixedNotify(Parameters) Export
	Parameters.Form.FormSetVisibilityAvailability();
EndProcedure

#EndRegion

#Region ITEM_LIST_QUANTITY

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

#EndRegion

#Region ITEM_LIST_PHYSICAL_COUNT

// ItemList.PhysCount
Procedure ItemListPhysCountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListPhysCountOnChange(Parameters);
EndProcedure

// ItemList.PhysCount.Set
Procedure SetItemListPhysCount(Object, Form, Row, Value) Export
	Row.PhysCount = Value;
	Rows = GetRowsByCurrentData(Form, "ItemList", Row);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	Parameters.Insert("IsProgramChange", True);
	ControllerClientServer_V2.ItemListPhysCountOnChange(Parameters);
EndProcedure

Procedure OnSetItemListPhysCountNotify(Parameters) Export
	Return;
EndProcedure

#EndRegion

#Region ITEM_LIST_MANUAL_FIXED_COUNT

// ItemList.ManualFixedCount
Procedure ItemListManualFixedCountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListManualFixedCountOnChange(Parameters);
EndProcedure

// ItemList.ManualFixedCount.Set
Procedure SetItemListManualFixedCount(Object, Form, Row, Value) Export
	Row.ManualFixedCount = Value;
	Rows = GetRowsByCurrentData(Form, "ItemList", Row);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	Parameters.Insert("IsProgramChange", True);
	ControllerClientServer_V2.ItemListManualFixedCountOnChange(Parameters);
EndProcedure

Procedure OnSetItemListManualFixedCountNotify(Parameters) Export
	Return;
EndProcedure

#EndRegion

#Region ITEM_LIST_SALES_DOCUMENT

// ItemList.SalesInvoice
Procedure ItemListSalesDocumentOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "ItemList", Rows);
	ControllerClientServer_V2.ItemListSalesDocumentOnChange(Parameters);
EndProcedure

#EndRegion

Procedure OnSetCalculationsNotify(Parameters) Export
	UpdateTotalAmounts(Parameters);
EndProcedure

Procedure UpdateTotalAmounts(Parameters)
	If Parameters.ObjectMetadataInfo.MetadataName = "SalesOrder"
		Or Parameters.ObjectMetadataInfo.MetadataName = "WorkOrder"
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseOrder"
		Or Parameters.ObjectMetadataInfo.MetadataName = "Payroll" Then
		Parameters.Form.UpdateTotalAmounts();
	EndIf;	
EndProcedure

#EndRegion

#Region _PAYMENT_LIST_

Procedure PaymentListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	ListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing);
EndProcedure

Procedure PaymentListBeforeAddRow(Object, Form, Cancel, Clone, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, "PaymentList", Cancel, Clone, CurrentData,
		"PaymentListOnAddRowFormNotify", "PaymentListOnCopyRowFormNotify");
	Form.Items.PaymentList.CurrentRow = NewRow.GetID();
	If Form.Items.PaymentList.CurrentRow <> Undefined Then
		Form.Items.PaymentList.ChangeRow();
	EndIf;
EndProcedure

Function PaymentListAddFilledRow(Object, Form,  FillingValues) Export
	Cancel      = False;
	Clone       = False;
	CurrentData = Undefined;
	NewRow = AddOrCopyRow(Object, Form, "PaymentList", Cancel, Clone, CurrentData,
		"PaymentListOnAddRowFormNotify", "PaymentListOnCopyRowFormNotify", FillingValues);
	Form.Items.PaymentList.CurrentRow = NewRow.GetID();
	If Form.Items.PaymentList.CurrentRow <> Undefined Then
		Form.Items.PaymentList.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure PaymentListOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure PaymentListOnCopyRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure PaymentListAfterDeleteRow(Object, Form) Export
	DeleteRows(Object, Form, "PaymentList");
EndProcedure

Procedure PaymentListLoad(Object, Form, Address, GroupColumn = "", SumColumn = "") Export
	Parameters = GetLoadParameters(Object, Form, "PaymentList", Address, GroupColumn, SumColumn);
	Parameters.LoadData.ExecuteAllViewNotify = True;
	ControllerClientServer_V2.AddEmptyRowsForLoad(Parameters);
	ControllerClientServer_V2.PaymentListLoad(Parameters);
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

// PaymentList.Account
Procedure PaymentListAccountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "PaymentList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "PaymentList", Rows);
	ControllerClientServer_V2.PaymentListAccountOnChange(Parameters);
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

// PaymentList.MoneyTransfer
Procedure PaymentListMoneyTransferOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "PaymentList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "PaymentList", Rows);
	ControllerClientServer_V2.PaymentListMoneyTransferOnChange(Parameters);
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

// PaymentList.Commission
Procedure PaymentListCommissionOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "PaymentList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "PaymentList", Rows);
	ControllerClientServer_V2.PaymentListCommissionOnChange(Parameters);
EndProcedure

// PaymentList.PaymentType
Procedure PaymentListPaymentTypeOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "PaymentList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "PaymentList", Rows);
	ControllerClientServer_V2.PaymentListPaymentTypeOnChange(Parameters);
EndProcedure

// PaymentList.BankTerm
Procedure PaymentListBankTermOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "PaymentList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "PaymentList", Rows);
	ControllerClientServer_V2.PaymentListBankTermOnChange(Parameters);
EndProcedure

// PaymentList.CommissionPercent
Procedure PaymentListCommissionPercentOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "PaymentList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "PaymentList", Rows);
	ControllerClientServer_V2.PaymentListCommissionPercentOnChange(Parameters);
EndProcedure

// PaymentList.VatRate
Procedure PaymentListVatRateOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "PaymentList", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "PaymentList", Rows);
	ControllerClientServer_V2.PaymentListVatRateOnChange(Parameters);
EndProcedure

#EndRegion

#Region _TRANSACTIONS_LIST

Procedure TransactionsBeforeAddRow(Object, Form, Cancel, Clone, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, "Transactions", Cancel, Clone, CurrentData,
		"TransactionsOnAddRowFormNotify", "TransactionsOnCopyRowFormNotify");
	Form.Items.Transactions.CurrentRow = NewRow.GetID();
	If Form.Items.Transactions.CurrentRow <> Undefined Then
		Form.Items.Transactions.ChangeRow();
	EndIf;
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

#Region PAYROLL_LISTS

Procedure PayrollListsSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	ListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing);
EndProcedure

Function PayrollListsBeforeAddRow(Object, Form, TableName, Cancel = False, Clone = False, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, TableName, Cancel, Clone, CurrentData,
		"PayrollListsOnAddRowFormNotify", "PayrollListsOnCopyRowFormNotify");

	Form.Items[TableName].CurrentRow = NewRow.GetID();
	If Form.Items[TableName].CurrentRow <> Undefined Then
		Form.Items[TableName].ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure PayrollListsOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure PayrollListsOnCopyRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure PayrollListsAfterDeleteRow(Object, Form, TableName) Export
	DeleteRows(Object, Form, TableName, "PayrollListsAfterDeleteRowFormNotify");
EndProcedure

Procedure PayrollListsAfterDeleteRowFormNotify(Parameters) Export
	UpdateTotalAmounts(Parameters);
EndProcedure

Procedure PayrollListsLoad(Object, Form, Address, TableName, GroupColumn = "", SumColumn = "") Export
	Parameters = GetLoadParameters(Object, Form, TableName, Address, GroupColumn, SumColumn);
	Parameters.LoadData.ExecuteAllViewNotify = True;
	ControllerClientServer_V2.AddEmptyRowsForLoad(Parameters);
	ControllerClientServer_V2.PayrollListsLoad(Parameters);
EndProcedure

#EndRegion

#Region PAYROLL_LISTS_COLUMNS

#Region PAYROLL_LISTS_EMPLOYEE

// PayrollLists.Employee
Procedure PayrollListsEmployeeOnChange(Object, Form, TableName, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, TableName, CurrentData);
	Parameters = GetSimpleParameters(Object, Form, TableName, Rows);
	ControllerClientServer_V2.PayrollListsEmployeeOnChange(Parameters);
EndProcedure

#EndRegion

#Region PAYROLL_LISTS_ACCRUAL_DEDUCTION_TYPE

// PayrollLists.AccrualDeductionType
Procedure PayrollListsAccrualDeductionTypeOnChange(Object, Form, TableName, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, TableName, CurrentData);
	Parameters = GetSimpleParameters(Object, Form, TableName, Rows);
	ControllerClientServer_V2.PayrollListsAccrualDeductionTypeOnChange(Parameters);
EndProcedure

#EndRegion

#Region PAYROLL_LISTS_AMOUNT

// PayrollLists.Amount
Procedure PayrollListsAmountOnChange(Object, Form, TableName, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, TableName, CurrentData);
	Parameters = GetSimpleParameters(Object, Form, TableName, Rows);
	ControllerClientServer_V2.PayrollListsAmountOnChange(Parameters);
EndProcedure

Procedure OnSetPayrollListsAmountNotify(Parameters) Export
	UpdateTotalAmounts(Parameters);
EndProcedure

#EndRegion

#EndRegion

//-------------
#Region COST_LIST

Procedure CostListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	ListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing);
EndProcedure

Function CostListBeforeAddRow(Object, Form, TableName, Cancel = False, Clone = False, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, TableName, Cancel, Clone, CurrentData,
		"CostListOnAddRowFormNotify", "CostListOnCopyRowFormNotify");

	Form.Items.CostList.CurrentRow = NewRow.GetID();
	If Form.Items.CostList.CurrentRow <> Undefined Then
		Form.Items.CostList.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure CostListOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure CostListOnCopyRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure CostListAfterDeleteRow(Object, Form, TableName) Export
	DeleteRows(Object, Form, TableName, "CostListAfterDeleteRowFormNotify");
EndProcedure

Procedure CostListAfterDeleteRowFormNotify(Parameters) Export
	UpdateTotalAmounts(Parameters);
EndProcedure

Procedure CostListLoad(Object, Form, Address, TableName, GroupColumn = "", SumColumn = "") Export
	Parameters = GetLoadParameters(Object, Form, TableName, Address, GroupColumn, SumColumn);
	Parameters.LoadData.ExecuteAllViewNotify = True;
	ControllerClientServer_V2.AddEmptyRowsForLoad(Parameters);
	ControllerClientServer_V2.PayrollListsLoad(Parameters);
EndProcedure


#EndRegion

//---------------

#Region TIME_SHEET_LIST

Procedure TimeSheetListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	ListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing);
EndProcedure

Function TimeSheetListBeforeAddRow(Object, Form, Cancel = False, Clone = False, CurrentData = Undefined) Export
	NewRow = AddOrCopyRow(Object, Form, "TimeSheetList", Cancel, Clone, CurrentData,
		"TimeSheetListOnAddRowFormNotify", "TimeSheetListOnCopyRowFormNotify");
	Form.Items.TimeSheetList.CurrentRow = NewRow.GetID();
	If Form.Items.TimeSheetList.CurrentRow <> Undefined Then
		Form.Items.TimeSheetList.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure TimeSheetListOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure TimeSheetListOnCopyRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure TimeSheetListAfterDeleteRow(Object, Form) Export
	DeleteRows(Object, Form, "TimeSheetList", "TimeSheetListAfterDeleteRowFormNotify");
EndProcedure

Procedure TimeSheetListAfterDeleteRowFormNotify(Parameters) Export
	Return;
EndProcedure

Function TimeSheetListAddFilledRow(Object, Form,  FillingValues) Export
	Cancel      = False;
	Clone       = False;
	CurrentData = Undefined;
	NewRow = AddOrCopyRow(Object, Form, "TimeSheetList", Cancel, Clone, CurrentData,
		"TimeSheetListOnAddRowFormNotify", "TimeSheetListOnCopyRowFormNotify", FillingValues);
	Form.Items.TimeSheetList.CurrentRow = NewRow.GetID();
	If Form.Items.TimeSheetList.CurrentRow <> Undefined Then
		Form.Items.TimeSheetList.ChangeRow();
	EndIf;
	Return NewRow;
EndFunction

Procedure TimeSheetListLoad(Object, Form, Address, GroupColumn = "", SumColumn = "") Export
	Parameters = GetLoadParameters(Object, Form, "TimeSheetList", Address, GroupColumn, SumColumn);
	Parameters.LoadData.ExecuteAllViewNotify = True;
	ControllerClientServer_V2.AddEmptyRowsForLoad(Parameters);
	ControllerClientServer_V2.TimeSheetListLoad(Parameters);
EndProcedure

#EndRegion

#Region ACCOUNT_SENDER

Procedure AccountSenderOnChange(Object, Form) Export
	FormParameters = GetFormParameters(Form);
	FetchFromCacheBeforeChange_Object("Sender", FormParameters);
	ServerParameters = GetServerParameters(Object);
	Parameters = GetParameters(ServerParameters, FormParameters);
	ControllerClientServer_V2.AccountSenderOnChange(Parameters);
EndProcedure

Procedure OnSetAccountSenderNotify(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "MoneyTransfer"
	Or Parameters.ObjectMetadataInfo.MetadataName = "CashTransferOrder" Then
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
	If Parameters.ObjectMetadataInfo.MetadataName = "MoneyTransfer"
	Or Parameters.ObjectMetadataInfo.MetadataName = "CashTransferOrder" Then
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
	If Parameters.ObjectMetadataInfo.MetadataName = "MoneyTransfer"
	Or Parameters.ObjectMetadataInfo.MetadataName = "CashTransferOrder" Then
		Parameters.Form.FormSetVisibilityAvailability();
	EndIf;
EndProcedure

#EndRegion

#Region ACCOUNT_RECEIVER

Procedure AccountReceiverOnChange(Object, Form) Export
	FormParameters = GetFormParameters(Form);
	FetchFromCacheBeforeChange_Object("Sender", FormParameters);
	ServerParameters = GetServerParameters(Object);
	Parameters = GetParameters(ServerParameters, FormParameters);
	ControllerClientServer_V2.AccountReceiverOnChange(Parameters);
EndProcedure

Procedure OnSetAccountReceiverNotify(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "MoneyTransfer"
	Or Parameters.ObjectMetadataInfo.MetadataName = "CashTransferOrder" Then
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
	If Parameters.ObjectMetadataInfo.MetadataName = "MoneyTransfer"
	Or Parameters.ObjectMetadataInfo.MetadataName = "CashTransferOrder" Then
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
	If Parameters.ObjectMetadataInfo.MetadataName = "MoneyTransfer"
	Or Parameters.ObjectMetadataInfo.MetadataName = "CashTransferOrder" Then
		Parameters.Form.FormSetVisibilityAvailability();
	EndIf;
EndProcedure

#EndRegion

#Region CASH_TRANSFER_ORDER

Procedure CashTransferOrderOnChange(Object, Form, TableNames) Export
	FormParameters = GetFormParameters(Form);
	FetchFromCacheBeforeChange_Object("CashTransferOrder", FormParameters);
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
	FetchFromCacheBeforeChange_Object("Store", FormParameters);
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
		FetchFromCacheBeforeChange_Form("Store", FormParameters);
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
		
		If Not (Parameters.ObjectMetadataInfo.MetadataName = "InventoryTransfer"
			 Or Parameters.ObjectMetadataInfo.MetadataName = "InventoryTransferOrder"
			 Or Parameters.ObjectMetadataInfo.MetadataName = "WorkOrder"
			 Or Parameters.ObjectMetadataInfo.MetadataName = "WorkSheet"
			 Or Parameters.ObjectMetadataInfo.MetadataName = "StockAdjustmentAsSurplus"
			 Or Parameters.ObjectMetadataInfo.MetadataName = "StockAdjustmentAsWriteOff") Then
			OnSetStoreNotify(Parameters);
		EndIf;
		
		If Parameters.ObjectMetadataInfo.Tables.Property("SerialLotNumbers") Then
			SerialLotNumberClient.UpdateSerialLotNumbersPresentation(Parameters.Object);
		EndIf;
		
		If Parameters.ObjectMetadataInfo.Tables.Property("ControlCodeStrings") Then
			ControlCodeStringsClient.UpdateState(Parameters.Object);
		EndIf;
					
		If Parameters.ObjectMetadataInfo.MetadataName = "SalesInvoice"
			Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseReturn" Then
			DocumentsClient.SetLockedRowsForItemListByTradeDocuments(Parameters.Object, Parameters.Form, "ShipmentConfirmations");
		EndIf;
		
		If Parameters.ObjectMetadataInfo.MetadataName = "PurchaseInvoice"
			Or Parameters.ObjectMetadataInfo.MetadataName = "SalesReturn" Then
			DocumentsClient.SetLockedRowsForItemListByTradeDocuments(Parameters.Object, Parameters.Form, "GoodsReceipts");
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region STORE_TRANSIT

Procedure StoreTransitOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.StoreTransitOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetStoreTransitNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region STORE_SENDER

Procedure StoreSenderOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.StoreSenderOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetStoreSenderNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region STORE_RECEIVER

Procedure StoreReceiverOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.StoreReceiverOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetStoreReceiverNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region STORE_PRODUCTION

Procedure StoreProductionOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.StoreProductionOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetStoreProductionNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region USE_SHIPMENT_CONFIRMATION

Procedure UseShipmentConfirmationOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.UseShipmentConfirmationOnChange(Parameters);
	EndDo;
EndProcedure

#EndRegion

#Region USE_GOODS_RECEIPT

Procedure UseGoodsReceiptOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.UseGoodsReceiptOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetUseGoodsReceiptNotify_IsProgramAsTrue(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "InventoryTransfer" Then
		CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_023, "Object.UseGoodsReceipt");
	EndIf;
EndProcedure

#EndRegion

#Region DELIVERY_DATE

Procedure DeliveryDateOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		FormParameters = GetFormParameters(Form);
		FetchFromCacheBeforeChange_Form("DeliveryDate", FormParameters);
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
	FetchFromCacheBeforeChange_Object("Date", FormParameters);
	FormParameters.EventCaller = "DateOnUserChange";
	For Each TableName In StrSplit(TableNames, ",") Do
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TrimAll(TableName);
		Parameters = GetParameters(ServerParameters, FormParameters);
		ControllerClientServer_V2.DateOnChange(Parameters);
	EndDo;
EndProcedure

Procedure SetDate(Object, Form, TableNames, Value) Export
	Object.Date = Value;
	FormParameters = GetFormParameters(Form);
	FetchFromCacheBeforeChange_Object("Date", FormParameters);
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
	FetchFromCacheBeforeChange_Object("Company", FormParameters);
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

#Region FIXED_ASSETS

Procedure FixedAssetOnChange(Object, Form, TableNames) Export
	FormParameters = GetFormParameters(Form);
	For Each TableName In StrSplit(TableNames, ",") Do
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TrimAll(TableName);
		Parameters = GetParameters(ServerParameters, FormParameters);
		ControllerClientServer_V2.FixedAssetOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetFixedAssetNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region TRADE_AGENT_FEE_TYPE

Procedure TradeAgentFeeTypeOnChange(Object, Form, TableNames) Export
	FormParameters = GetFormParameters(Form);
	FetchFromCacheBeforeChange_Object("TradeAgentFeeType", FormParameters);
	FormParameters.EventCaller = "TradeAgentFeeTypeOnUserChange";

	For Each TableName In StrSplit(TableNames, ",") Do
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TrimAll(TableName);
		Parameters = GetParameters(ServerParameters, FormParameters);
		ControllerClientServer_V2.TradeAgentFeeTypeOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetTradeAgentFeeTypeNotify(Parameters) Export
	Parameters.Form.FormSetVisibilityAvailability();
EndProcedure

#EndRegion

#Region ACCOUNT

Procedure AccountOnChange(Object, Form, TableNames) Export
	FormParameters = GetFormParameters(Form);
	FetchFromCacheBeforeChange_Object("Account", FormParameters);
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
	FetchFromCacheBeforeChange_Object("CashAccount", FormParameters);
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
	FetchFromCacheBeforeChange_Object("TransactionType", FormParameters);
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
		Or Parameters.ObjectMetadataInfo.MetadataName = "CashReceipt"
		Or Parameters.ObjectMetadataInfo.MetadataName = "ShipmentConfirmation"
		Or Parameters.ObjectMetadataInfo.MetadataName = "RetailShipmentConfirmation"
		Or Parameters.ObjectMetadataInfo.MetadataName = "GoodsReceipt"	
		Or Parameters.ObjectMetadataInfo.MetadataName = "RetailGoodsReceipt"	
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseInvoice"
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseOrder"      
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseReturn"       
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseReturnOrder"  
		Or Parameters.ObjectMetadataInfo.MetadataName = "SalesInvoice"         
		Or Parameters.ObjectMetadataInfo.MetadataName = "SalesOrder"              
		Or Parameters.ObjectMetadataInfo.MetadataName = "SalesReturn"          
		Or Parameters.ObjectMetadataInfo.MetadataName = "SalesReturnOrder"
		Or Parameters.ObjectMetadataInfo.MetadataName = "OutgoingPaymentOrder"
		Or Parameters.ObjectMetadataInfo.MetadataName = "CashExpense"
		Or Parameters.ObjectMetadataInfo.MetadataName = "CashRevenue"
		Or Parameters.ObjectMetadataInfo.MetadataName = "Production" 
		Or Parameters.ObjectMetadataInfo.MetadataName = "PhysicalCountByLocation" Then
		Parameters.Form.FormSetVisibilityAvailability();
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region CURRENCY

Procedure CurrencyOnChange(Object, Form, TableNames) Export
	FormParameters = GetFormParameters(Form);
	FetchFromCacheBeforeChange_Object("Currency", FormParameters);
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
	FetchFromCacheBeforeChange_Object("Partner", FormParameters);
	FormParameters.EventCaller = "PartnerOnUserChange";
	For Each TableName In StrSplit(TableNames, ",") Do
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TrimAll(TableName);
		Parameters = GetParameters(ServerParameters, FormParameters);
		ControllerClientServer_V2.PartnerOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetPartnerNotify(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "SalesInvoice"
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseInvoice"
		Or Parameters.ObjectMetadataInfo.MetadataName = "GoodsReceipt"
		Or Parameters.ObjectMetadataInfo.MetadataName = "RetailGoodsReceipt"
		Or Parameters.ObjectMetadataInfo.MetadataName = "ShipmentConfirmation"
		Or Parameters.ObjectMetadataInfo.MetadataName = "RetailSalesReceipt"
		Or Parameters.ObjectMetadataInfo.MetadataName = "RetailReceiptCorrection"
		Or Parameters.ObjectMetadataInfo.MetadataName = "RetailReturnReceipt"
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseReturn"
		Or Parameters.ObjectMetadataInfo.MetadataName = "SalesReturn"
		Or Parameters.ObjectMetadataInfo.MetadataName = "SalesOrder"
		Or Parameters.ObjectMetadataInfo.MetadataName = "WorkOrder"
		Or Parameters.ObjectMetadataInfo.MetadataName = "WorkSheet"
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseOrder"
		Or Parameters.ObjectMetadataInfo.MetadataName = "SalesReturnOrder"
		Or Parameters.ObjectMetadataInfo.MetadataName = "PurchaseReturnOrder"
		Or Parameters.ObjectMetadataInfo.MetadataName = "SalesReportFromTradeAgent"
		Or Parameters.ObjectMetadataInfo.MetadataName = "SalesReportToConsignor"
		Or Parameters.ObjectMetadataInfo.MetadataName = "Payroll" Then
		Parameters.Form.FormSetVisibilityAvailability();
	EndIf;
	
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region PARTNER_TRADE_AGENT

Procedure PartnerTradeAgentOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.PartnerTradeAgentOnChange(Parameters);
	EndDo;
EndProcedure

#EndRegion

#Region PARTNER_CONSIGNOR

Procedure PartnerConsignorOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.PartnerConsignorOnChange(Parameters);
	EndDo;
EndProcedure

#EndRegion

#Region COURIER

Procedure CourierOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.CourierOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetCourierNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region EMPLOYEE

Procedure EmployeeOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.EmployeeOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetEmployeeNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region POSITION

Procedure PositionOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.PositionOnChange(Parameters);
	EndDo;
EndProcedure

#EndRegion

#Region TO_POSITION

Procedure ToPositionOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.ToPositionOnChange(Parameters);
	EndDo;
EndProcedure

#EndRegion

#Region ACCRUAL_TYPE

Procedure AccrualTypeOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.AccrualTypeOnChange(Parameters);
	EndDo;
EndProcedure

#EndRegion

#Region TO_ACCRUAL_TYPE

Procedure ToAccrualTypeOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.ToAccrualTypeOnChange(Parameters);
	EndDo;
EndProcedure

#EndRegion

#Region SALARY_AMOUNT

Procedure OnSetSalaryAmountNotify(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "EmployeeTransfer" Then
		Parameters.Form.FromSalaryType = ?(ValueIsFilled(Parameters.Object.FromPersonalSalary),"Personal", "ByPosition");
		Parameters.Form.ToSalaryType = ?(ValueIsFilled(Parameters.Object.ToPersonalSalary),"Personal", "ByPosition");
	EndIf;
	
	Parameters.Form.FormSetVisibilityAvailability();
EndProcedure

#EndRegion

#Region LEGAL_NAME

Procedure LegalNameOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TrimAll(TableName));
		ControllerClientServer_V2.LegalNameOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetLegalNameNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region LEGAL_NAME_TRADE_AGENT

Procedure LegalNameTradeAgentOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.LegalNameTradeAgentOnChange(Parameters);
	EndDo;
EndProcedure

#EndRegion

#Region LEGAL_NAME_CONSIGNOR

Procedure LegalNameConsignorOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.LegalNameConsignorOnChange(Parameters);
	EndDo;
EndProcedure

#EndRegion

#Region CONSOLIDATED_RETAIL_SALES

Procedure ConsolidatedRetailSalesOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.ConsolidatedRetailSalesOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetConsolidatedRetailSalesNotify(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "RetailSalesReceipt"
		Or Parameters.ObjectMetadataInfo.MetadataName = "RetailReceiptCorrection"
		Or Parameters.ObjectMetadataInfo.MetadataName = "RetailReturnReceipt" Then
		Parameters.Form.FormSetVisibilityAvailability();
	EndIf;
EndProcedure

#EndRegion

#Region WORKSTATION

Procedure WorkstationOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.WorkstationOnChange(Parameters);
	EndDo;
EndProcedure

#EndRegion

#Region BRANCH

Procedure BranchOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.BranchOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetBranchNotify(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "RetailSalesReceipt"
		Or Parameters.ObjectMetadataInfo.MetadataName = "RetailReceiptCorrection"
		Or Parameters.ObjectMetadataInfo.MetadataName = "RetailReturnReceipt" Then
		Parameters.Form.FormSetVisibilityAvailability();
	EndIf;
EndProcedure

#EndRegion

#Region STATUS

Procedure StatusOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.StatusOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetStatusNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region BEGIN_DATE

Procedure BeginDateOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.BeginDateOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetBeginDateNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region END_DATE

Procedure EndDateOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.EndDateOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetEndDateNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region _NUMBER

Procedure NumberOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.NumberOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetNumberNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region AGREEMENT

Procedure AgreementOnChange(Object, Form, TableNames) Export
	FormParameters = GetFormParameters(Form);
	FetchFromCacheBeforeChange_Object("Agreement", FormParameters);
	FormParameters.EventCaller = "AgreementOnUserChange";
	For Each TableName In StrSplit(TableNames, ",") Do
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TrimAll(TableName);
		Parameters = GetParameters(ServerParameters, FormParameters);
		ControllerClientServer_V2.AgreementOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetAgreementNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region AGREEMENT_TRADE_AGENT

Procedure AgreementTradeAgentOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.AgreementTradeAgentOnChange(Parameters);
	EndDo;
EndProcedure

#EndRegion

#Region AGREEMENT_CONSIGNOR

Procedure AgreementConsignorOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.AgreementConsignorOnChange(Parameters);
	EndDo;
EndProcedure

#EndRegion

#Region RETAIL_CUSTOMER

Procedure RetailCustomerOnChange(Object, Form, TableNames) Export
	FormParameters = GetFormParameters(Form);
	FetchFromCacheBeforeChange_Object("RetailCustomer", FormParameters);
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

#Region QUANTITY

Procedure QuantityOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.QuantityOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetQuantityNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region UNIT

Procedure UnitOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.UnitOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetUnitNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region ITEM_BUNDLE

Procedure ItemBundleOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.ItemBundleOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetItemBundleNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region ITEM_KEY_BUNDLE

Procedure ItemKeyBundleOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.ItemKeyBundleOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetItemKeyBundleNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region _ITEM

Procedure ItemOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.ItemOnChange(Parameters);
	EndDo;
EndProcedure

#EndRegion

#Region ITEM_KEY

Procedure ItemKeyOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.ItemKeyOnChange(Parameters);
	EndDo;
EndProcedure

#EndRegion

#Region BILL_OF_MATERIALS

Procedure BillOfMaterialsOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TableName);
		ControllerClientServer_V2.BillOfMaterialsOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetBillOfMaterialsNotify(Parameters) Export
	If Parameters.ObjectMetadataInfo.MetadataName = "Production" Then
		Parameters.Form.FormSetVisibilityAvailability();
	EndIf;
EndProcedure

#EndRegion

#Region PLANNING_PERIOD

Procedure PlanningPeriodOnChange(Object, Form, TableNames) Export
	FormParameters = GetFormParameters(Form);
	FetchFromCacheBeforeChange_Object("PlanningPeriod", FormParameters);
	FormParameters.EventCaller = "PlanningPeriodOnUserChange";
	For Each TableName In StrSplit(TableNames, ",") Do
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TrimAll(TableName);
		Parameters = GetParameters(ServerParameters, FormParameters);
		ControllerClientServer_V2.PlanningPeriodOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetPlanningPeriodNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region BUSINESS_UNIT

Procedure BusinessUnitOnChange(Object, Form, TableNames) Export
	FormParameters = GetFormParameters(Form);
	FetchFromCacheBeforeChange_Object("BusinessUnit", FormParameters);
	FormParameters.EventCaller = "BusinessUnitOnUserChange";
	For Each TableName In StrSplit(TableNames, ",") Do
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TableName;
		Parameters = GetParameters(ServerParameters, FormParameters);
		ControllerClientServer_V2.BusinessUnitOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetBusinessUnitNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region OFFERS
	
Procedure OffersOnChange(Object, Form) Export
	Parameters = GetSimpleParameters(Object, Form, "ItemList");
	ControllerClientServer_V2.OffersOnChange(Parameters);
EndProcedure
	
#EndRegion

#Region PAYMENTS

Procedure PaymentsBeforeAddRow(Object, Form, Cancel, Clone, CurrentData = Undefined) Export
	NewRow = AddOrCopyRowSimpleTable(Object, Form, "Payments", Cancel, Clone, CurrentData,
		"PaymentsOnAddRowFormNotify", "PaymentsOnCopyRowFormNotify");
	Form.Items.Payments.CurrentRow = NewRow.GetID();
	If Form.Items.Payments.CurrentRow <> Undefined Then
		Form.Items.Payments.ChangeRow();
	EndIf;
EndProcedure

Procedure PaymentsOnAddRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

Procedure PaymentsOnCopyRowFormNotify(Parameters) Export
	Parameters.Form.Modified = True;
EndProcedure

#Region PAYMENTS_PAYMENT_TYPE

// Payments.PaymentType
Procedure PaymentsPaymentTypeOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "Payments", CurrentData);
	
	FormParameters = GetFormParameters(Form);
	FetchFromCacheBeforeChange_List("Payments.PaymentType", FormParameters, Rows);
	FormParameters.EventCaller = "PaymentsPaymentTypeOnUserChange";

	ServerParameters = GetServerParameters(Object);
	ServerParameters.Rows      = Rows;
	ServerParameters.TableName = "Payments";
	
	Parameters = GetParameters(ServerParameters, FormParameters);
	ControllerClientServer_V2.PaymentsPaymentTypeOnChange(Parameters);
EndProcedure

// Payments.PaymentType.Set
Procedure SetPaymentsPaymentType(Object, Form, Row, Value) Export
	Row.PaymentType = Value;
	Rows = GetRowsByCurrentData(Form, "Payments", Row);
	Parameters = GetSimpleParameters(Object, Form, "Payments", Rows);
	Parameters.Insert("IsProgramChange", True);
	ControllerClientServer_V2.PaymentsPaymentTypeOnChange(Parameters);
EndProcedure

#EndRegion

#Region PAYMENTS_ACCOUNT

// Payments.Account
Procedure PaymentsAccountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "Payments", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "Payments", Rows);
	ControllerClientServer_V2.PaymentsAccountOnChange(Parameters);
EndProcedure

// Payments.Account.Set
Procedure SetPaymentsAccount(Object, Form, Row, Value) Export
	Row.Account = Value;
	Rows = GetRowsByCurrentData(Form, "Payments", Row);
	Parameters = GetSimpleParameters(Object, Form, "Payments", Rows);
	Parameters.Insert("IsProgramChange", True);
	ControllerClientServer_V2.PaymentsAccountOnChange(Parameters);
EndProcedure

#EndRegion

#Region PAYMENTS_BANK_TERM

// Payments.BankTerm
Procedure PaymentsBankTermOnChange(Object, Form, CurrentData = Undefined) Export	
	Rows = GetRowsByCurrentData(Form, "Payments", CurrentData);
	
	FormParameters = GetFormParameters(Form);
	FetchFromCacheBeforeChange_List("Payments.BankTerm", FormParameters, Rows);
	FormParameters.EventCaller = "PaymentsBankTermOnUserChange";

	ServerParameters = GetServerParameters(Object);
	ServerParameters.Rows      = Rows;
	ServerParameters.TableName = "Payments";
	
	Parameters = GetParameters(ServerParameters, FormParameters);
	ControllerClientServer_V2.PaymentsBankTermOnChange(Parameters);
	
EndProcedure

// Payments.BankTerm.Set
Procedure SetPaymentsBankTerm(Object, Form, Row, Value) Export
	Row.BankTerm = Value;
	Rows = GetRowsByCurrentData(Form, "Payments", Row);
	Parameters = GetSimpleParameters(Object, Form, "Payments", Rows);
	Parameters.Insert("IsProgramChange", True);
	ControllerClientServer_V2.PaymentsBankTermOnChange(Parameters);
EndProcedure

#EndRegion

#Region PAYMENTS_AMOUNT

// Payments.Amount
Procedure PaymentsAmountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "Payments", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "Payments", Rows);
	ControllerClientServer_V2.PaymentsAmountOnChange(Parameters);
EndProcedure

// Payments.Amount.Set
Procedure SetPaymentsAmount(Object, Form, Row, Value) Export
	Row.Amount = Value;
	Rows = GetRowsByCurrentData(Form, "Payments", Row);
	Parameters = GetSimpleParameters(Object, Form, "Payments", Rows);
	Parameters.Insert("IsProgramChange", True);
	ControllerClientServer_V2.PaymentsAmountOnChange(Parameters);
EndProcedure

#EndRegion

#Region PAYMENTS_PERCENT

// Payments.Percent
Procedure PaymentsPercentOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "Payments", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "Payments", Rows);
	ControllerClientServer_V2.PaymentsPercentOnChange(Parameters);
EndProcedure

// Payments.Percent.Set
Procedure SetPaymentsPercent(Object, Form, Row, Value) Export
	Row.Percent = Value;
	Rows = GetRowsByCurrentData(Form, "Payments", Row);
	Parameters = GetSimpleParameters(Object, Form, "Payments", Rows);
	Parameters.Insert("IsProgramChange", True);
	ControllerClientServer_V2.PaymentsPercentOnChange(Parameters);
EndProcedure

#EndRegion

#Region PAYMENTS_COMMISSION

// Payments.Commission
Procedure PaymentsCommissionOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "Payments", CurrentData);
	Parameters = GetSimpleParameters(Object, Form, "Payments", Rows);
	ControllerClientServer_V2.PaymentsCommissionOnChange(Parameters);
EndProcedure

// Payments.Commission.Set
Procedure SetPaymentsCommission(Object, Form, Row, Value) Export
	Row.Commission = Value;
	Rows = GetRowsByCurrentData(Form, "Payments", Row);
	Parameters = GetSimpleParameters(Object, Form, "Payments", Rows);
	Parameters.Insert("IsProgramChange", True);
	ControllerClientServer_V2.PaymentsCommissionOnChange(Parameters);
EndProcedure

#EndRegion

#EndRegion

#Region SEND_DEBT_TYPE

Procedure SendDebtTypeOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TrimAll(TableName));
		ControllerClientServer_V2.SendDebtTypeOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetSendDebtTypeNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
	Parameters.Form.FormSetVisibilityAvailability();
EndProcedure

#EndRegion

#Region SEND_PARTNER

Procedure SendPartnerOnChange(Object, Form, TableNames) Export
	FormParameters = GetFormParameters(Form);
	FetchFromCacheBeforeChange_Object("SendPartner", FormParameters);
	FormParameters.EventCaller = "SendPartnerOnUserChange";
	For Each TableName In StrSplit(TableNames, ",") Do
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TrimAll(TableName);
		Parameters = GetParameters(ServerParameters, FormParameters);
		ControllerClientServer_V2.SendPartnerOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetSendPartnerNotify(Parameters) Export
	Parameters.Form.FormSetVisibilityAvailability();	
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region SEND_LEGAL_NAME

Procedure SendLegalNameOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TrimAll(TableName));
		ControllerClientServer_V2.SendLegalNameOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetSendLegalNameNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region SEND_AGREEMENT

Procedure SendAgreementOnChange(Object, Form, TableNames) Export
	FormParameters = GetFormParameters(Form);
	FetchFromCacheBeforeChange_Object("SendAgreement", FormParameters);
	FormParameters.EventCaller = "SendAgreementOnUserChange";
	For Each TableName In StrSplit(TableNames, ",") Do
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TrimAll(TableName);
		Parameters = GetParameters(ServerParameters, FormParameters);
		ControllerClientServer_V2.SendAgreementOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetSendAgreementNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
	Parameters.Form.FormSetVisibilityAvailability();
EndProcedure

#EndRegion

#Region RECEIVE_DEBT_TYPE

Procedure ReceiveDebtTypeOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TrimAll(TableName));
		ControllerClientServer_V2.ReceiveDebtTypeOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetReceiveDebtTypeNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
	Parameters.Form.FormSetVisibilityAvailability();
EndProcedure

#EndRegion

#Region RECEIVE_PARTNER

Procedure ReceivePartnerOnChange(Object, Form, TableNames) Export
	FormParameters = GetFormParameters(Form);
	FetchFromCacheBeforeChange_Object("ReceivePartner", FormParameters);
	FormParameters.EventCaller = "ReceivePartnerOnUserChange";
	For Each TableName In StrSplit(TableNames, ",") Do
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TrimAll(TableName);
		Parameters = GetParameters(ServerParameters, FormParameters);
		ControllerClientServer_V2.ReceivePartnerOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetReceivePartnerNotify(Parameters) Export
	Parameters.Form.FormSetVisibilityAvailability();
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region RECEIVE_LEGAL_NAME

Procedure ReceiveLegalNameOnChange(Object, Form, TableNames) Export
	For Each TableName In StrSplit(TableNames, ",") Do
		Parameters = GetSimpleParameters(Object, Form, TrimAll(TableName));
		ControllerClientServer_V2.ReceiveLegalNameOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetReceiveLegalNameNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region RECEIVE_AGREEMENT

Procedure ReceiveAgreementOnChange(Object, Form, TableNames) Export
	FormParameters = GetFormParameters(Form);
	FetchFromCacheBeforeChange_Object("ReceiveAgreement", FormParameters);
	FormParameters.EventCaller = "ReceiveAgreementOnUserChange";
	For Each TableName In StrSplit(TableNames, ",") Do
		ServerParameters = GetServerParameters(Object);
		ServerParameters.TableName = TrimAll(TableName);
		Parameters = GetParameters(ServerParameters, FormParameters);
		ControllerClientServer_V2.ReceiveAgreementOnChange(Parameters);
	EndDo;
EndProcedure

Procedure OnSetReceiveAgreementNotify(Parameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
	Parameters.Form.FormSetVisibilityAvailability();
EndProcedure

#EndRegion

Procedure ViewIdleHandler(Form, Object) Export
	JobStatus = ModelServer_V2.GetJobStatus(Form.BackgroundJobUUID, Form.BackgroundJobStorageAddress);
	If JobStatus.Status = PredefinedValue("Enum.JobStatus.EmptyRef") Then
		CancelIdleHandler(Form);
		Return;
	EndIf;
	
	OpenedSplashForm = GetSplashByUUID(Form.BackgroundJobSplash); // See CommonForm.BackgroundJobSplash
	
	If JobStatus.Status = PredefinedValue("Enum.JobStatus.Canceled") 
		Or JobStatus.Status = PredefinedValue("Enum.JobStatus.Failed") Then
			
			For Each Msg In JobStatus.SystemMessages Do
				NewMsg = OpenedSplashForm.SystemMessages.Add();
				NewMsg.Message = Msg;
			EndDo;
			
			CancelIdleHandler(Form);
			Return;
	EndIf;
	
	If JobStatus.Status = PredefinedValue("Enum.JobStatus.Active") Then
		// wait
		If JobStatus.CompletePercent = Undefined And JobStatus.SystemMessages.Count() = 0 Then
			Return;
		EndIf;

		If Form.BackgroundJobSplash = Undefined Then
			Return;
		EndIf;
		
		If OpenedSplashForm <> Undefined And OpenedSplashForm.IsOpen() Then
			If Not JobStatus.CompletePercent = Undefined Then
				OpenedSplashForm.Items.Percent.MaxValue = JobStatus.CompletePercent.Total;
				OpenedSplashForm.Percent = JobStatus.CompletePercent.Complete;
			EndIf;
			For Each Msg In JobStatus.SystemMessages Do
				NewMsg = OpenedSplashForm.SystemMessages.Add();
				NewMsg.Message = Msg;
			EndDo;

			If OpenedSplashForm.SystemMessages.Count() And Not OpenedSplashForm.Items.GroupMessages.Visible Then
				OpenedSplashForm.Items.GroupMessages.Visible = True;
				OpenedSplashForm.DoNotCloseOnFinish = True;
			EndIf;

			DiffDate = CommonFunctionsServer.GetCurrentSessionDate() - OpenedSplashForm.StartDate;
			TimeToEnd = OpenedSplashForm.Items.Percent.MaxValue * DiffDate / OpenedSplashForm.Percent - DiffDate;
			OpenedSplashForm.EndIn = CommonFunctionsServer.GetCurrentSessionDate() + TimeToEnd;
		EndIf;
	Else
		// complete..
		JobResult = JobStatus.Result;
		
		If Not JobResult = Undefined Then
			JobResult.Parameters.Object = Object;
			JobResult.Parameters.Form   = Form;
			ControllerClientServer_V2.OnChainComplete(JobResult.Parameters);
			ModelClientServer_V2.DestroyEntryPoint(JobResult.Parameters);
		EndIf;
		CancelIdleHandler(Form);
	EndIf;
EndProcedure	

Procedure CancelIdleHandler(Form)
	Form._DetachIdleHandler();
	Form.BackgroundJobUUID = "";
	If Form.BackgroundJobSplash <> Undefined Then
		OpenedSplashForm = GetSplashByUUID(Form.BackgroundJobSplash); // See CommonForm.BackgroundJobSplash
		If OpenedSplashForm <> Undefined And OpenedSplashForm.IsOpen() Then
			OpenedSplashForm.EndDate = CommonFunctionsServer.GetCurrentSessionDate();
			OpenedSplashForm.Percent = OpenedSplashForm.Items.Percent.MaxValue;
			OpenedSplashForm.FormCanBeClose = True;
			OpenedSplashForm.CommandBar.ChildItems.FormOK.Visible = True;
			OpenedSplashForm.Items.Decoration.Visible = False;
			
			If OpenedSplashForm.SystemMessages.Count() And Not OpenedSplashForm.Items.GroupMessages.Visible Then
				OpenedSplashForm.Items.GroupMessages.Visible = True;
				OpenedSplashForm.DoNotCloseOnFinish = True;
			EndIf;
			
			If Not OpenedSplashForm.DoNotCloseOnFinish Then
				OpenedSplashForm.Close();
			EndIf;
		EndIf;
		Form.BackgroundJobSplash = Undefined;
	EndIf;
EndProcedure

Function GetSplashByUUID(BackgroundJobSplash)
	OpenedSplashForm = Undefined;
	Windows = GetWindows();
	For Each Window In Windows Do
		If OpenedSplashForm <> Undefined Then
			Break;
		EndIf;
		If Not Window.IsMain Then
			For Each Splash In Window.Content Do
				If Splash.UUID = BackgroundJobSplash Then
					OpenedSplashForm = Splash;
					Break;
				EndIf;
			EndDo;
		EndIf;
	EndDo;
	Return OpenedSplashForm;
EndFunction
