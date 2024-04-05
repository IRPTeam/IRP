
Function GetOperationsDefinition()
	Map = New Map();
	AO = Catalogs.AccountingOperations;
	// Bank payment
	// Transaction type - Payment to vendor
	Map.Insert(AO.BankPayment_DR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions_CR_R3010B_CashOnHand, 
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.PaymentToVendor));
	Map.Insert(AO.BankPayment_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors,
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.PaymentToVendor));
	// Transaction type - Return to customer
	Map.Insert(AO.BankPayment_DR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions_CR_R3010B_CashOnHand,
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.ReturnToCustomer));
	Map.Insert(AO.BankPayment_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers,
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.ReturnToCustomer));
	// Transaction type - Cash transfer order
	Map.Insert(AO.BankPayment_DR_R3021B_CashInTransitIncoming_CR_R3010B_CashOnHand_CashTransferOrder, 
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.CashTransferOrder));
	// Transaction type - Currency exchange
	Map.Insert(AO.BankPayment_DR_R3021B_CashInTransitIncoming_CR_R3010B_CashOnHand_CurrencyExchange,
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.CurrencyExchange));
	
	// Bank receipt
	// Transaction type - Payment from customer
	Map.Insert(AO.BankReceipt_DR_R3010B_CashOnHand_CR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.PaymentFromCustomer));
	Map.Insert(AO.BankReceipt_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.PaymentFromCustomer));
	// Transaction type - Return from vendor
	Map.Insert(AO.BankReceipt_DR_R3010B_CashOnHand_CR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.ReturnFromVendor));
	Map.Insert(AO.BankReceipt_DR_R1020B_AdvancesToVendors_CR_R1021B_VendorsTransactions,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.ReturnFromVendor));
	// Transaction type - Cash transfer order
	Map.Insert(AO.BankReceipt_DR_R3010B_CashOnHand_CR_R3021B_CashInTransitIncoming_CashTransferOrder,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.CashTransferOrder));
	//  Transaction type - Currency exchange
	Map.Insert(AO.BankReceipt_DR_R3010B_CashOnHand_CR_R3021B_CashInTransitIncoming_CurrencyExchange,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.CurrencyExchange));
	Map.Insert(AO.BankReceipt_DR_R3021B_CashInTransit_CR_R5021T_Revenues,
		New Structure("ByRow, TransactionType", False, Enums.IncomingPaymentTransactionType.CurrencyExchange));
	Map.Insert(AO.BankReceipt_DR_R5022T_Expenses_CR_R3021B_CashInTransit,
		New Structure("ByRow, TransactionType", False, Enums.IncomingPaymentTransactionType.CurrencyExchange));

	// Cash payment
	//  Transaction type - Payment to vendor
	Map.Insert(AO.CashPayment_DR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions_CR_R3010B_CashOnHand,
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.PaymentToVendor));
	Map.Insert(AO.CashPayment_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors, 
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.PaymentToVendor));
	//  Transaction type - Return to customer
	Map.Insert(AO.CashPayment_DR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions_CR_R3010B_CashOnHand, 
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.ReturnToCustomer));
	Map.Insert(AO.CashPayment_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers, 
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.ReturnToCustomer));
	//  Transaction type - Cash transfer order
	Map.Insert(AO.CashPayment_DR_R3021B_CashInTransitIncoming_CR_R3010B_CashOnHand_CashTransferOrder,
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.CashTransferOrder));
	
	// Cash receipt
	//  Transaction type - Payment from customer
	Map.Insert(AO.CashReceipt_DR_R3010B_CashOnHand_CR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions, 
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.PaymentFromCustomer));
	Map.Insert(AO.CashReceipt_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.PaymentFromCustomer));
	//  Transaction type - Return from vendor
	Map.Insert(AO.CashReceipt_DR_R3010B_CashOnHand_CR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.ReturnFromVendor));
	Map.Insert(AO.CashReceipt_DR_R1020B_AdvancesToVendors_CR_R1021B_VendorsTransactions,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.ReturnFromVendor));
	//  Transaction type - Cash transfer order
	Map.Insert(AO.CashReceipt_DR_R3010B_CashOnHand_CR_R3021B_CashInTransitIncoming_CashTransferOrder,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.CashTransferOrder));
	
	// Cash expense
	Map.Insert(AO.CashExpense_DR_R5022T_Expenses_CR_R3010B_CashOnHand , New Structure("ByRow", True));
	
	// Cash revenue
	Map.Insert(AO.CashRevenue_DR_R3010B_CashOnHand_CR_R5021_Revenues , New Structure("ByRow", True));
		
	// Debit note
	Map.Insert(AO.DebitNote_DR_R1020B_AdvancesToVendors_CR_R5021_Revenues , New Structure("ByRow", True));
	Map.Insert(AO.DebitNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors , New Structure("ByRow", True));
	Map.Insert(AO.DebitNote_DR_R2021B_CustomersTransactions_CR_R5021_Revenues , New Structure("ByRow", True));
		
	// Credit note
	Map.Insert(AO.CreditNote_DR_R2020B_AdvancesFromCustomers_CR_R5022T_Expenses , New Structure("ByRow", True));
	Map.Insert(AO.CreditNote_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers , New Structure("ByRow", True));
	Map.Insert(AO.CreditNote_DR_R1021B_VendorsTransactions_CR_R5022T_Expenses , New Structure("ByRow", True));
				
	// Purchase invoice
	// receipt inventory
	Map.Insert(AO.PurchaseInvoice_DR_R4050B_StockInventory_R5022T_Expenses_CR_R1021B_VendorsTransactions, 
		New Structure("ByRow, TransactionType", True, Enums.PurchaseTransactionTypes.Purchase));
	Map.Insert(AO.PurchaseInvoice_DR_R4050B_StockInventory_R5022T_Expenses_CR_R1021B_VendorsTransactions_CurrencyRevaluation,
		New Structure("ByRow, TransactionType", True, Enums.PurchaseTransactionTypes.Purchase));
	// offset of advabces
	Map.Insert(AO.PurchaseInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors,
		New Structure("ByRow, TransactionType", False, Enums.PurchaseTransactionTypes.Purchase));
	Map.Insert(AO.PurchaseInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors_CurrencyRevaluation,
		New Structure("ByRow, TransactionType", False, Enums.PurchaseTransactionTypes.Purchase));
	
	Map.Insert(AO.PurchaseInvoice_DR_R1040B_TaxesOutgoing_CR_R1021B_VendorsTransactions,
		New Structure("ByRow, TransactionType", True, Enums.PurchaseTransactionTypes.Purchase));
	
	// Sales invoice
	// sales inventory
	Map.Insert(AO.SalesInvoice_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues,
		New Structure("ByRow, TransactionType", True, Enums.SalesTransactionTypes.Sales));
	Map.Insert(AO.SalesInvoice_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues_CurrencyRevaluation,
		New Structure("ByRow, TransactionType", True, Enums.SalesTransactionTypes.Sales));
	// offset of advances
	Map.Insert(AO.SalesInvoice_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions,
		New Structure("ByRow, TransactionType", False, Enums.SalesTransactionTypes.Sales));
	Map.Insert(AO.SalesInvoice_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions_CurrencyRevaluation,
		New Structure("ByRow, TransactionType", False, Enums.SalesTransactionTypes.Sales));
	
	Map.Insert(AO.SalesInvoice_DR_R5021T_Revenues_CR_R2040B_TaxesIncoming,
		New Structure("ByRow, TransactionType", True, Enums.SalesTransactionTypes.Sales));
	Map.Insert(AO.SalesInvoice_DR_R5022T_Expenses_CR_R4050B_StockInventory,
		New Structure("ByRow, TransactionType", True, Enums.SalesTransactionTypes.Sales));
	
	// Retail sales receipt
	Map.Insert(AO.RetailSalesReceipt_DR_R5022T_Expenses_CR_R4050B_StockInventory , New Structure("ByRow", True));

	// Foreign currency revaluation
	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R2020B_AdvancesFromCustomers_CR_R5021T_Revenues , New Structure("ByRow, RequestTable", True, True));
	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R2020B_AdvancesFromCustomers , New Structure("ByRow, RequestTable", True, True));
	
	// Money transfer
	Map.Insert(AO.MoneyTransfer_DR_R3010B_CashOnHand_CR_R3010B_CashOnHand    , New Structure("ByRow", False));
	Map.Insert(AO.MoneyTransfer_DR_R3010B_CashOnHand_CR_R3021B_CashInTransit , New Structure("ByRow", False));
	Map.Insert(AO.MoneyTransfer_DR_R3021B_CashInTransit_CR_R3010B_CashOnHand , New Structure("ByRow", False));
	Map.Insert(AO.MoneyTransfer_DR_R3021B_CashInTransit_CR_R5021T_Revenues   , New Structure("ByRow", False));
	Map.Insert(AO.MoneyTransfer_DR_R5022T_Expenses_CR_R3021B_CashInTransit   , New Structure("ByRow", False));

	// Commissioning of fixed assets
	Map.Insert(AO.CommissioningOfFixedAsset_DR_R8510B_BookValueOfFixedAsset_CR_R4050B_StockInventory, New Structure("ByRow", True));

	// Decommissioning of fixed assets
	Map.Insert(AO.DecommissioningOfFixedAsset_DR_R4050B_StockInventory_CR_R8510B_BookValueOfFixedAsset, New Structure("ByRow", True));
	
	// Modernization of fixed assets
	Map.Insert(AO.ModernizationOfFixedAsset_DR_R8510B_BookValueOfFixedAsset_CR_R4050B_StockInventory, New Structure("ByRow", True));
	Map.Insert(AO.ModernizationOfFixedAsset_DR_R4050B_StockInventory_CR_R8510B_BookValueOfFixedAsset, New Structure("ByRow", True));
 
 	// Fixed asstet transfer
	Map.Insert(AO.FixedAssetTransfer_DR_R8510B_BookValueOfFixedAsset_CR_R8510B_BookValueOfFixedAsset, New Structure("ByRow", False));
	
	// Depreciation calculation
	Map.Insert(AO.DepreciationCalculation_DR_DepreciationFixedAsset_CR_R8510B_BookValueOfFixedAsset, New Structure("ByRow", True));
	Map.Insert(AO.DepreciationCalculation_DR_R5022T_Expenses_CR_DepreciationFixedAsset             , New Structure("ByRow", True));
	
Return Map;
EndFunction

Function GetSupportedDocuments() Export
	ArrayOfDocuments = New Array();
	For Each type In Metadata.DefinedTypes.typeAccountingDocuments.Type.Types() Do
		t = new(type);
		ArrayOfDocuments.Add(t.Metadata());
	EndDo;
	Return ArrayOfDocuments;
EndFunction

#Region Service

Function GetAccountingAnalyticsResult(Parameters) Export
	AccountingAnalytics = New Structure();
	AccountingAnalytics.Insert("Operation" , Parameters.Operation);
	AccountingAnalytics.Insert("LedgerType", Parameters.LedgerType);
	
	// Debit
	AccountingAnalytics.Insert("Debit", Undefined);
	AccountingAnalytics.Insert("DebitExtDimensions", New Array());
	
	// Credit
	AccountingAnalytics.Insert("Credit", Undefined);
	AccountingAnalytics.Insert("CreditExtDimensions", New Array());
	Return AccountingAnalytics;
EndFunction

Function GetAccountingDataResult()
	Result = New Structure();
	Result.Insert("CurrencyDr", Undefined);
	Result.Insert("CurrencyAmountDr", 0);
	Result.Insert("CurrencyCr", Undefined);
	Result.Insert("CurrencyAmountCr", 0);
	
	Result.Insert("QuantityDr", 0);
	Result.Insert("QuantityCr", 0);
	
	Result.Insert("Amount", 0);
	Return Result;
EndFunction

Function IsAdvance(RowData) Export
	If Not ValueIsFilled(RowData.Agreement) Then
		Return True;
	EndIf;
	If RowData.Agreement.ApArPostingDetail = Enums.ApArPostingDetail.ByDocuments
		And Not ValueIsFilled(RowData.BasisDocument) Then
			Return True;
	EndIf;
	Return False; // IsTransaction
EndFunction

Procedure SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsValues = Undefined) Export
	If ValueIsFilled(AccountingAnalytics.Debit) Then
		For Each ExtDim In AccountingAnalytics.Debit.ExtDimensionTypes Do
			ExtDimension = New Structure("ExtDimensionType, ExtDimension");
			ExtDimension.ExtDimensionType  = ExtDim.ExtDimensionType;
			ArrayOfTypes = ExtDim.ExtDimensionType.ValueType.Types();
			ExtDimValue = ExtractValueByType(Parameters.ObjectData, Parameters.RowData, ArrayOfTypes, AdditionalAnalyticsValues);
			ExtDimValue = Documents[Parameters.MetadataName].GetHintDebitExtDimension(Parameters, ExtDim.ExtDimensionType, ExtDimValue);
			ExtDimension.ExtDimension = ExtDimValue;
			ExtDimension.Insert("Key"          , ?(Parameters.RowData = Undefined, "", Parameters.RowData.Key));
			ExtDimension.Insert("AnalyticType" , Enums.AccountingAnalyticTypes.Debit);
			ExtDimension.Insert("Operation"    , Parameters.Operation);
			ExtDimension.Insert("LedgerType"   , Parameters.LedgerType);
			AccountingAnalytics.DebitExtDimensions.Add(ExtDimension);
		EndDo;
	EndIf;
EndProcedure

Procedure SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsValues = Undefined) Export
	If ValueIsFilled(AccountingAnalytics.Credit) Then
		For Each ExtDim In AccountingAnalytics.Credit.ExtDimensionTypes Do
			ExtDimension = New Structure("ExtDimensionType, ExtDimension");
			ExtDimension.ExtDimensionType  = ExtDim.ExtDimensionType;
			ArrayOfTypes = ExtDim.ExtDimensionType.ValueType.Types();
			ExtDimValue = ExtractValueByType(Parameters.ObjectData, Parameters.RowData, ArrayOfTypes, AdditionalAnalyticsValues);
			ExtDimValue = Documents[Parameters.MetadataName].GetHintCreditExtDimension(Parameters, ExtDim.ExtDimensionType, ExtDimValue);
			ExtDimension.ExtDimension = ExtDimValue;
			ExtDimension.Insert("Key"          , ?(Parameters.RowData = Undefined, "", Parameters.RowData.Key));
			ExtDimension.Insert("AnalyticType" , Enums.AccountingAnalyticTypes.Credit);
			ExtDimension.Insert("Operation"    , Parameters.Operation);
			ExtDimension.Insert("LedgerType"   , Parameters.LedgerType);
			AccountingAnalytics.CreditExtDimensions.Add(ExtDimension);
		EndDo;
	EndIf;
EndProcedure

Function ExtractValueByType(ObjectData, RowData, ArrayOfTypes, AdditionalAnalyticsValues)
	If AdditionalAnalyticsValues <> Undefined Then
		For Each KeyValue In AdditionalAnalyticsValues Do
			If ArrayOfTypes.Find(TypeOf(AdditionalAnalyticsValues[KeyValue.Key])) <> Undefined Then
				Return AdditionalAnalyticsValues[KeyValue.Key];
			EndIf;
		EndDo;	
	EndIf;

	If RowData <> Undefined Then
		If TypeOf(RowData) = Type("ValueTableRow") Then
			For Each RowItem In RowData Do
				If ArrayOfTypes.Find(TypeOf(RowItem)) <> Undefined Then
					Return RowItem;
				EndIf;
			EndDo;
		ElsIf TypeOf(RowData) = Type("Structure") Then	
			For Each KeyValue In RowData Do
				If ArrayOfTypes.Find(TypeOf(RowData[KeyValue.Key])) <> Undefined Then
					Return RowData[KeyValue.Key];
				EndIf;
			EndDo;
		Else
			Raise "Unsupported type of row data";
		EndIf;
	EndIf;
	
	For Each KeyValue In ObjectData Do
		If ArrayOfTypes.Find(TypeOf(ObjectData[KeyValue.Key])) <> Undefined Then
			Return ObjectData[KeyValue.Key];
		EndIf;
	EndDo;
	
	Return Undefined;
EndFunction

Function GetDataByAccountingAnalytics(BasisRef, AnalyticRow) Export
	If Not ValueIsFilled(AnalyticRow.AccountDebit) Or Not ValueIsFilled(AnalyticRow.AccountCredit) Then
		Return GetAccountingDataResult();
	EndIf;
	Parameters = New Structure();
	Parameters.Insert("Recorder" , BasisRef);
	Parameters.Insert("RowKey"   , AnalyticRow.Key);
	Parameters.Insert("Operation", AnalyticRow.Operation);
	Parameters.Insert("CurrencyMovementType", AnalyticRow.LedgerType.CurrencyMovementType);
	Data = GetAccountingData(Parameters);
	
	Result = GetAccountingDataResult();
	
	If Data = Undefined Then
		Return Result;
	EndIf;
	
	If Data.Property("CurrencyDr") Then
		Result.CurrencyDr = Data.CurrencyDr;
	EndIf;

	If Data.Property("CurrencyAmountDr") Then
		Result.CurrencyAmountDr = Data.CurrencyAmountDr;
	EndIf;

	If Data.Property("CurrencyCr") Then
		Result.CurrencyCr = Data.CurrencyCr;
	EndIf;

	If Data.Property("CurrencyAmountCr") Then
		Result.CurrencyAmountCr = Data.CurrencyAmountCr;
	EndIf;

	If Data.Property("QuantityDr") Then
		Result.QuantityDr = Data.QuantityDr;
	EndIf;

	If Data.Property("QuantityCr") Then
		Result.QuantityCr = Data.QuantityCr;
	EndIf;

	If Data.Property("Amount") Then
		Result.Amount = Data.Amount;
	EndIf;
	Return Result;	
EndFunction

Function GetLedgerTypesByCompany(Ref, Date, Company) Export
	If Not ValueIsFilled(Company) Then
		Return New Array();
	EndIf;
	Query = New Query();
	Query.Text = 
	"SELECT
	|	CompanyLedgerTypesSliceLast.LedgerType
	|FROM
	|	InformationRegister.CompanyLedgerTypes.SliceLast(&Period, Company = &Company) AS CompanyLedgerTypesSliceLast
	|WHERE
	|	CompanyLedgerTypesSliceLast.Use";
	Period = CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(Ref, Date);
	Query.SetParameter("Period" , Period);
	Query.SetParameter("Company", Company);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	ArrayOfLedgerTypes = QueryTable.UnloadColumn("LedgerType");
	Return ArrayOfLedgerTypes;
EndFunction

Function GetAccountingOperationsByLedgerType(Object, Period, LedgerType)
	MetadataName = Object.Ref.Metadata().Name;
	AccountingOperationGroup = Catalogs.AccountingOperations["Document_" + MetadataName];
	Query = New Query();
	Query.Text =
	"SELECT
	|	LedgerTypeOperationsSliceLast.AccountingOperation AS AccountingOperation
	|FROM
	|	InformationRegister.LedgerTypeOperations.SliceLast(&Period, LedgerType = &LedgerType
	|	AND AccountingOperation.Parent = &AccountingOperationGroup) AS LedgerTypeOperationsSliceLast
	|WHERE
	|	LedgerTypeOperationsSliceLast.Use";
	Query.SetParameter("Period", Period);
	Query.SetParameter("LedgerType", LedgerType);
	Query.SetParameter("AccountingOperationGroup", AccountingOperationGroup);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	ArrayOfAccountingOperations = New Array();
	
	OperationsDefinition = GetOperationsDefinition();
	
	DocTransactionType = Undefined;
	If CommonFunctionsClientServer.ObjectHasProperty(Object, "TransactionType") Then
		DocTransactionType = Object.TransactionType;
	EndIf;
	
	While QuerySelection.Next() Do
		Def = OperationsDefinition.Get(QuerySelection.AccountingOperation);
		ByRow = ?(Def = Undefined, False, Def.ByRow);
		RequestTable = False;
		If Def <> Undefined And Def.Property("RequestTable") Then
			RequestTable = Def.RequestTable;
		EndIf;
		
		If Def <> Undefined 
			And Def.Property("TransactionType") 
			And Def.TransactionType <> DocTransactionType Then
			Continue;
		EndIf;
		
		NewAccountingOperation = New Structure();
		NewAccountingOperation.Insert("Operation"    , QuerySelection.AccountingOperation);
		NewAccountingOperation.Insert("ByRow"        , ByRow);
		NewAccountingOperation.Insert("RequestTable" , RequestTable);
		NewAccountingOperation.Insert("MetadataName" , MetadataName);
		ArrayOfAccountingOperations.Add(NewAccountingOperation);
	EndDo;
	Return ArrayOfAccountingOperations;
EndFunction

Function GetLedgerTypeVariants() Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	LedgerTypeVariants.Ref
	|FROM
	|	Catalog.LedgerTypeVariants AS LedgerTypeVariants
	|WHERE
	|	NOT LedgerTypeVariants.DeletionMark";
	QueryResult = Query.Execute();
	Result = New Array();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		Result.Add(QuerySelection.Ref);
	EndDo;
	Return Result;
EndFunction

Function SplitAccountingOperationsByTransactionTypes(DocumentInfo) Export
	Result = New Structure();
	Result.Insert("With_TransactionType", New Map());
	Result.Insert("Without_TransactionType", New Array());
	
	OperationsDefinition = GetOperationsDefinition();
	
	For Each KeyValue In OperationsDefinition Do
		If KeyValue.Key.Parent = DocumentInfo Then
			If KeyValue.Value.Property("TransactionType") And ValueIsFilled(KeyValue.Value.TransactionType) Then
				If Result.With_TransactionType.Get(KeyValue.Value.TransactionType) = Undefined Then
					Result.With_TransactionType.Insert(KeyValue.Value.TransactionType, New Array());
				EndIf;
				
				Result.With_TransactionType[KeyValue.Value.TransactionType].Add(KeyValue.Key);
				
			Else
				
				Result.Without_TransactionType.Add(KeyValue.Key);
				
			EndIf;
		EndIf;
	EndDo;
	
	Return Result;	
EndFunction

#EndRegion

#Region Accounts

Function GetAccountParameters(Parameters) Export
	Period = CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(Parameters.ObjectData.Ref, Parameters.ObjectData.Date);
	AccountParameters = New Structure();
	AccountParameters.Insert("Period", Period);
	AccountParameters.Insert("Company", Parameters.ObjectData.Company);
	AccountParameters.Insert("LedgerTypeVariant", Parameters.LedgerType.LedgerTypeVariant);
	Return AccountParameters;
EndFunction

Function GetT9010S_AccountsItemKey(AccountParameters, ItemKey) Export
	Return AccountingServerReuse.GetT9010S_AccountsItemKey_Reuse(
		AccountParameters.Period, 
		AccountParameters.Company, 
		AccountParameters.LedgerTypeVariant, 
		ItemKey);
EndFunction

Function __GetT9010S_AccountsItemKey(Period, Company, LedgerTypeVariant, ItemKey) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	ByItemKey.Account,
	|	1 AS Priority
	|INTO Accounts
	|FROM
	|	InformationRegister.T9010S_AccountsItemKey.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ItemKey = &ItemKey
	|	AND Item.Ref IS NULL
	|	AND ItemType.Ref IS NULL) AS ByItemKey
	|
	|UNION ALL
	|
	|SELECT
	|	ByItem.Account,
	|	2
	|FROM
	|	InformationRegister.T9010S_AccountsItemKey.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ItemKey.Ref IS NULL
	|	AND Item = &Item
	|	AND ItemType.Ref IS NULL) AS ByItem
	|
	|UNION ALL
	|
	|SELECT
	|	ByItemType.Account,
	|	3
	|FROM
	|	InformationRegister.T9010S_AccountsItemKey.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ItemKey.Ref IS NULL
	|	AND Item.Ref IS NULL
	|	AND ItemType = &ItemType) AS ByItemType
	|
	|UNION ALL
	|
	|SELECT
	|	ByType.Account,
	|	4
	|FROM
	|	InformationRegister.T9010S_AccountsItemKey.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ItemKey.Ref IS NULL
	|	AND Item.Ref IS NULL
	|	AND ItemType.Ref IS NULL
	|	AND TypeOfItemType = &TypeOfItemType) AS ByType
	|
	|UNION ALL
	|
	|SELECT
	|	ByCompany.Account,
	|	5
	|FROM
	|	InformationRegister.T9010S_AccountsItemKey.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ItemKey.Ref IS NULL
	|	AND Item.Ref IS NULL
	|	AND ItemType.Ref IS NULL
	|	AND TypeOfItemType.Ref IS NULL) AS ByCompany
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Accounts.Account,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts AS Accounts
	|
	|ORDER BY
	|	Priority";
	Query.SetParameter("Period"   , Period);
	Query.SetParameter("Company"  , Company);
	Query.SetParameter("LedgerTypeVariant"  , LedgerTypeVariant);
	Query.SetParameter("ItemKey"  , ItemKey);
	Query.SetParameter("Item"     , ItemKey.Item);
	Query.SetParameter("ItemType" , ItemKey.Item.ItemType);
	Query.SetParameter("TypeOfItemType" , ItemKey.Item.ItemType.Type);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Structure("Account", Undefined);
	If QuerySelection.Next() Then
		Result.Account = QuerySelection.Account;
	EndIf;
	Return Result;
EndFunction

Function GetT9011S_AccountsCashAccount(AccountParameters, CashAccount, Currency) Export
	Return AccountingServerReuse.GetT9011S_AccountsCashAccount_Reuse(AccountParameters.Period,
		AccountParameters.Company,
		AccountParameters.LedgerTypeVariant,
		CashAccount, Currency);
EndFunction

Function __GetT9011S_AccountsCashAccount(Period, Company, LedgerTypeVariant, CashAccount, Currency) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ByCashAccount.Company,
	|	ByCashAccount.CashAccount,
	|	ByCashAccount.Account,
	|	ByCashAccount.AccountTransit,
	|	1 AS Priority
	|INTO Accounts
	|FROM
	|	InformationRegister.T9011S_AccountsCashAccount.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND CashAccount = &CashAccount AND Currency = &Currency) AS ByCashAccount
	|
	|UNION ALL
	|
	|SELECT
	|	ByCompany.Company,
	|	ByCompany.CashAccount,
	|	ByCompany.Account,
	|	ByCompany.AccountTransit,
	|	2
	|FROM
	|	InformationRegister.T9011S_AccountsCashAccount.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND CashAccount.Ref IS NULL AND Currency.Ref IS NULL) AS ByCompany
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Accounts.Company,
	|	Accounts.CashAccount,
	|	Accounts.Account,
	|	Accounts.AccountTransit,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts AS Accounts
	|
	|ORDER BY
	|	Priority";
	Query.SetParameter("Period"      , Period);
	Query.SetParameter("Company"     , Company);
	Query.SetParameter("LedgerTypeVariant"     , LedgerTypeVariant);
	Query.SetParameter("CashAccount" , CashAccount);
	Query.SetParameter("Currency"    , Currency);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Structure("Account, AccountTransit");
	If QuerySelection.Next() Then
		Result.Account = QuerySelection.Account;
		Result.AccountTransit = QuerySelection.AccountTransit;
	EndIf;
	Return Result;
EndFunction

Function GetT9012S_AccountsPartner(AccountParameters, Partner, Agreement, Currency) Export
	Return AccountingServerReuse.GetT9012S_AccountsPartner_Reuse(
//	Return __GetT9012S_AccountsPartner(
		AccountParameters.Period, 
		AccountParameters.Company, 
		AccountParameters.LedgerTypeVariant,
		Partner, Agreement, Currency);
EndFunction

Function __GetT9012S_AccountsPartner(Period, Company, LedgerTypeVariant, Partner, Agreement, Currency) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ByAgreement.AccountAdvancesVendor,
	|	ByAgreement.AccountTransactionsVendor,
	|	1 AS Priority
	|INTO Accounts_Vendor
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Vendor
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Agreement = &Agreement
	|	AND Partner.Ref IS NULL
	|	AND Currency.Ref IS NULL) AS ByAgreement
	|
	|UNION ALL
	|
	|SELECT
	|	ByPartner.AccountAdvancesVendor,
	|	ByPartner.AccountTransactionsVendor,
	|	2
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Vendor
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Partner = &Partner
	|	AND Agreement.Ref IS NULL
	|	AND Currency.Ref IS NULL) AS ByPartner
	|
	|UNION ALL
	|
	|SELECT
	|	ByCurrency.AccountAdvancesVendor,
	|	ByCurrency.AccountTransactionsVendor,
	|	3
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Vendor
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Currency = &Currency
	|	AND Agreement.Ref IS NULL
	|	AND Partner.Ref IS NULL) AS ByCurrency
	|
	|UNION ALL
	|
	|SELECT
	|	ByCompany.AccountAdvancesVendor,
	|	ByCompany.AccountTransactionsVendor,
	|	4
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Vendor
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Partner.Ref IS NULL
	|	AND Agreement.Ref IS NULL
	|	AND Currency.Ref IS NULL) AS ByCompany
	|;
	|
	|///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ByAgreement.AccountAdvancesCustomer,
	|	ByAgreement.AccountTransactionsCustomer,
	|	1 AS Priority
	|INTO Accounts_Customer
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Customer
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Agreement = &Agreement
	|	AND Partner.Ref IS NULL
	|	AND Currency.Ref IS NULL) AS ByAgreement
	|
	|UNION ALL
	|
	|SELECT
	|	ByPartner.AccountAdvancesCustomer,
	|	ByPartner.AccountTransactionsCustomer,
	|	2
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Customer
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Partner = &Partner
	|	AND Agreement.Ref IS NULL
	|	AND Currency.Ref IS NULL) AS ByPartner
	|
	|UNION ALL
	|
	|SELECT
	|	ByCurrency.AccountAdvancesCustomer,
	|	ByCurrency.AccountTransactionsCustomer,
	|	3
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Customer
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Currency = &Currency
	|	AND Agreement.Ref IS NULL
	|	AND Partner.Ref IS NULL) AS ByCurrency
	|
	|UNION ALL
	|
	|SELECT
	|	ByCompany.AccountAdvancesCustomer,
	|	ByCompany.AccountTransactionsCustomer,
	|	4
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Customer
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Partner.Ref IS NULL
	|	AND Agreement.Ref IS NULL
	|	AND Currency.Ref IS NULL) AS ByCompany
	|;
	|
	|/////////////////////////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ByAgreement.AccountAdvancesOther,
	|	ByAgreement.AccountTransactionsOther,
	|	1 AS Priority
	|INTO Accounts_Other
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Other
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Agreement = &Agreement
	|	AND Partner.Ref IS NULL
	|	AND Currency.Ref IS NULL) AS ByAgreement
	|
	|UNION ALL
	|
	|SELECT
	|	ByPartner.AccountAdvancesOther,
	|	ByPartner.AccountTransactionsOther,
	|	2
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Other
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Partner = &Partner
	|	AND Agreement.Ref IS NULL
	|	AND Currency.Ref IS NULL) AS ByPartner
	|
	|UNION ALL
	|
	|SELECT
	|	ByCurrency.AccountAdvancesOther,
	|	ByCurrency.AccountTransactionsOther,
	|	3
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Other
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Currency = &Currency
	|	AND Agreement.Ref IS NULL
	|	AND Partner.Ref IS NULL) AS ByCurrency
	|
	|UNION ALL
	|
	|SELECT
	|	ByCompany.AccountAdvancesOther,
	|	ByCompany.AccountTransactionsOther,
	|	4
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Other
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Partner.Ref IS NULL
	|	AND Agreement.Ref IS NULL) AS ByCompany
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT TOP 1
	|	Accounts.AccountAdvancesVendor,
	|	Accounts.AccountTransactionsVendor,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts_Vendor AS Accounts
	|
	|ORDER BY
	|	Priority
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT TOP 1
	|	Accounts.AccountAdvancesCustomer,
	|	Accounts.AccountTransactionsCustomer,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts_Customer AS Accounts
	|
	|ORDER BY
	|	Priority
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT TOP 1
	|	Accounts.AccountAdvancesOther,
	|	Accounts.AccountTransactionsOther,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts_Other AS Accounts
	|
	|ORDER BY
	|	Priority";

	Query.SetParameter("Period"    , Period);
	Query.SetParameter("Company"   , Company);
	Query.SetParameter("LedgerTypeVariant"   , LedgerTypeVariant);
	Query.SetParameter("Partner"   , Partner);
	Query.SetParameter("Agreement" , Agreement);
	Query.SetParameter("Currency"  , Currency);
	
	QueryResults = Query.ExecuteBatch();
	
	Result = New Structure();
	Result.Insert("AccountAdvancesVendor"        , Undefined);
	Result.Insert("AccountTransactionsVendor"    , Undefined);
	Result.Insert("AccountAdvancesCustomer"      , Undefined);
	Result.Insert("AccountTransactionsCustomer"  , Undefined);
	Result.Insert("AccountAdvancesOther"         , Undefined);
	Result.Insert("AccountTransactionsOther"     , Undefined);

	QuerySelection_Vendor = QueryResults[3].Select();
	If QuerySelection_Vendor.Next() Then
		Result.AccountAdvancesVendor = QuerySelection_Vendor.AccountAdvancesVendor;
		Result.AccountTransactionsVendor = QuerySelection_Vendor.AccountTransactionsVendor;
	EndIf;
	
	QuerySelection_Customer = QueryResults[4].Select();
	If QuerySelection_Customer.Next() Then
		Result.AccountAdvancesCustomer = QuerySelection_Customer.AccountAdvancesCustomer;
		Result.AccountTransactionsCustomer = QuerySelection_Customer.AccountTransactionsCustomer;
	EndIf;
	
	QuerySelection_Other = QueryResults[5].Select();
	If QuerySelection_Other.Next() Then
		Result.AccountAdvancesOther = QuerySelection_Other.AccountAdvancesOther;
		Result.AccountTransactionsOther = QuerySelection_Other.AccountTransactionsOther;
	EndIf;
	
	Return Result;
EndFunction

Function GetT9013S_AccountsTax(AccountParameters, TaxInfo) Export
	Return AccountingServerReuse.GetT9013S_AccountsTax_Reuse(AccountParameters.Period,
		AccountParameters.Company,
		AccountParameters.LedgerTypeVariant,
		TaxInfo.Tax, TaxInfo.VatRate);	
EndFunction

Function __GetT9013S_AccountsTax(Period, Company, LedgerTypeVariant, Tax, VatRate) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ByVatRate.Company,
	|	ByVatRate.Tax,
	|	ByVatRate.VatRate,
	|	ByVatRate.IncomingAccount,
	|	ByVatRate.OutgoingAccount,
	|	0 AS Priority
	|INTO Accounts
	|FROM
	|	InformationRegister.T9013S_AccountsTax.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Tax = &Tax
	|	AND VatRate = &VatRate) AS ByVatRate
	|
	|UNION ALL
	|
	|SELECT
	|	ByTax.Company,
	|	ByTax.Tax,
	|	ByTax.VatRate,
	|	ByTax.IncomingAccount,
	|	ByTax.OutgoingAccount,
	|	1
	|FROM
	|	InformationRegister.T9013S_AccountsTax.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Tax = &Tax
	|	AND VatRate.Ref IS NULL) AS ByTax
	|
	|UNION ALL
	|
	|SELECT
	|	ByCompany.Company,
	|	ByCompany.Tax,
	|	ByCompany.VatRate,
	|	ByCompany.IncomingAccount,
	|	ByCompany.OutgoingAccount,
	|	2
	|FROM
	|	InformationRegister.T9013S_AccountsTax.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Tax.Ref IS NULL
	|	AND VatRate.Ref IS NULL) AS ByCompany
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT TOP 1
	|	Accounts.Company,
	|	Accounts.Tax,
	|	Accounts.VatRate,
	|	Accounts.IncomingAccount,
	|	Accounts.OutgoingAccount,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts AS Accounts
	|
	|ORDER BY
	|	Priority";
	Query.SetParameter("Period"  , Period);
	Query.SetParameter("Company" , Company);
	Query.SetParameter("LedgerTypeVariant" , LedgerTypeVariant);
	Query.SetParameter("Tax"     , Tax);
	Query.SetParameter("VatRate" , VatRate);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Structure("IncomingAccount, OutgoingAccount", Undefined, Undefined);
	If QuerySelection.Next() Then
		Result.IncomingAccount = QuerySelection.IncomingAccount;
		Result.OutgoingAccount = QuerySelection.OutgoingAccount;
	EndIf;
	Return Result;
EndFunction

Function GetT9014S_AccountsExpenseRevenue(AccountParameters, ExpenseRevenue) Export
	Return __GetT9014S_AccountsExpenseRevenue(//AccountingServerReuse.GetT9014S_AccountsExpenseRevenue_Reuse(
		AccountParameters.Period, 
		AccountParameters.Company, 
		AccountParameters.LedgerTypeVariant, 
		ExpenseRevenue);
EndFunction

Function __GetT9014S_AccountsExpenseRevenue(Period, Company, LedgerTypeVariant, ExpenseRevenue) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ByExpenseRevenue.Account,
	|	1 AS Priority
	|INTO Accounts
	|FROM
	|	InformationRegister.T9014S_AccountsExpenseRevenue.SliceLast(&Period, Company = &Company AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ExpenseRevenue = &ExpenseRevenue) AS ByExpenseRevenue
	|
	|UNION ALL
	|
	|SELECT
	|	ByCompany.Account,
	|	2
	|FROM
	|	InformationRegister.T9014S_AccountsExpenseRevenue.SliceLast(&Period, Company = &Company AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ExpenseRevenue.Ref IS NULL) AS ByCompany
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Accounts.Account,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts AS Accounts
	|
	|ORDER BY
	|	Priority";
	Query.SetParameter("Period"  , Period);
	Query.SetParameter("Company" , Company);
	Query.SetParameter("LedgerTypeVariant" , LedgerTypeVariant);
	Query.SetParameter("ExpenseRevenue" , ExpenseRevenue);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Structure("Account");
	If QuerySelection.Next() Then
		Result.Account = QuerySelection.Account;
	EndIf;
	Return Result;
EndFunction

Function GetT9015S_AccountsFixedAsset(AccountParameters, FixedAsset) Export
	Return AccountingServerReuse.GetT9015S_AccountsFixedAsset_Reuse(
		AccountParameters.Period, 
		AccountParameters.Company, 
		AccountParameters.LedgerTypeVariant, 
		FixedAsset);
EndFunction

Function __GetT9015S_AccountsFixedAsset(Period, Company, LedgerTypeVariant, FixedAsset) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	ByFixedAsset.Account,
	|	ByFixedAsset.AccountDepreciation,
	|	1 AS Priority
	|INTO Accounts
	|FROM
	|	InformationRegister.T9015S_AccountsFixedAsset.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND FixedAsset = &FixedAsset
	|	AND Type.Ref IS NULL) AS ByFixedAsset
	|
	|UNION ALL
	|
	|SELECT
	|	ByType.Account,
	|	ByType.AccountDepreciation,
	|	2
	|FROM
	|	InformationRegister.T9015S_AccountsFixedAsset.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND FixedAsset.Ref IS NULL
	|	AND Type = &Type ) AS ByType
	|
	|UNION ALL
	|
	|SELECT
	|	ByCompany.Account,
	|	ByCompany.AccountDepreciation,
	|	3
	|FROM
	|	InformationRegister.T9015S_AccountsFixedAsset.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND FixedAsset.Ref IS NULL
	|	AND Type.Ref IS NULL) AS ByCompany
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Accounts.Account,
	|	Accounts.AccountDepreciation,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts AS Accounts
	|
	|ORDER BY
	|	Priority";
	Query.SetParameter("Period"   , Period);
	Query.SetParameter("Company"  , Company);
	Query.SetParameter("LedgerTypeVariant" , LedgerTypeVariant);
	Query.SetParameter("FixedAsset" , FixedAsset);
	Query.SetParameter("Type"       , FixedAsset.Type);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Structure("Account, AccountDepreciation");
	If QuerySelection.Next() Then
		Result.Account = QuerySelection.Account;
		Result.AccountDepreciation = QuerySelection.AccountDepreciation;
	EndIf;
	Return Result;
EndFunction

#EndRegion

Procedure UpdateAccountingTables(Object, 
							     AccountingRowAnalytics,
							     AccountingExtDimensions,
							     MainTableName, 
							     Filter_LedgerType = Undefined, 
							     IgnoreFixed = False,
							     AddInfo = Undefined) Export
	
	Period = CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(Object.Ref, Object.Date);
	LedgerTypes = GetLedgerTypesByCompany(Object.Ref, Period, Object.Company);
	
	OperationsByLedgerType = New Array();
	For Each LedgerType In LedgerTypes Do
		// filter by ledger type
		If Filter_LedgerType <> Undefined And Filter_LedgerType <> LedgerType Then
			Continue;
		EndIf;
		OperationsInfo = GetAccountingOperationsByLedgerType(Object, Period, LedgerType);
		For Each OperationInfo In OperationsInfo Do
			OperationsByLedgerType.Add(New Structure("LedgerType, OperationInfo", LedgerType, OperationInfo));
		EndDo;
	EndDo;
			
	ClearAccountingTables(Object, AccountingRowAnalytics, AccountingExtDimensions, Period, LedgerTypes, MainTableName);
	
	ObjectData = GetDocumentData(Object, Undefined, Undefined).ObjectData;
	
	For Each Operation In OperationsByLedgerType Do
		If Operation.OperationInfo.ByRow Then
			Continue;
		EndIf;
		Parameters = New Structure();
		Parameters.Insert("Object"        , Object);
		Parameters.Insert("Operation"     , Operation.OperationInfo.Operation);
		Parameters.Insert("LedgerType"    , Operation.LedgerType);
		Parameters.Insert("MetadataName"  , Operation.OperationInfo.MetadataName);
		Parameters.Insert("MainTableName" , MainTableName);
		Parameters.Insert("IgnoreFixed"   , IgnoreFixed);
		Parameters.Insert("ObjectData"    , ObjectData);
		Parameters.Insert("RowData"       , Undefined);
		Parameters.Insert("AccountingRowAnalytics"  , AccountingRowAnalytics);
		Parameters.Insert("AccountingExtDimensions" , AccountingExtDimensions);
		
		FillAccountingRowAnalytics(Parameters);
	EndDo;
	
	If MainTableName = Undefined Then
		For Each Operation In OperationsByLedgerType Do
			If Not Operation.OperationInfo.RequestTable Then
				Continue;
			EndIf;
			
			DataTable = Documents[Operation.OperationInfo.MetadataName].GetAccountingDataTable(Operation.OperationInfo.Operation, AddInfo);
			
			For Each Row In DataTable Do
				Parameters = New Structure();
				Parameters.Insert("Object"        , Object);
				Parameters.Insert("Operation"     , Operation.OperationInfo.Operation);
				Parameters.Insert("LedgerType"    , Operation.LedgerType);
				Parameters.Insert("MetadataName"  , Operation.OperationInfo.MetadataName);
				Parameters.Insert("MainTableName" , MainTableName);
				Parameters.Insert("IgnoreFixed"   , IgnoreFixed);
				Parameters.Insert("ObjectData"    , ObjectData);
				Parameters.Insert("RowData"       , Row);
				Parameters.Insert("AccountingRowAnalytics"  , AccountingRowAnalytics);
				Parameters.Insert("AccountingExtDimensions" , AccountingExtDimensions);
			
				FillAccountingRowAnalytics(Parameters, Row);
			EndDo;
			
		EndDo;
	Else
		For Each Row In Object[MainTableName] Do
			RowData = GetDocumentData(Object, Row, MainTableName).RowData;
			For Each Operation In OperationsByLedgerType Do
				If Not Operation.OperationInfo.ByRow Then
					Continue;
				EndIf;
				Parameters = New Structure();
				Parameters.Insert("Object"        , Object);
				Parameters.Insert("Operation"     , Operation.OperationInfo.Operation);
				Parameters.Insert("LedgerType"    , Operation.LedgerType);
				Parameters.Insert("MetadataName"  , Operation.OperationInfo.MetadataName);
				Parameters.Insert("MainTableName" , MainTableName);
				Parameters.Insert("IgnoreFixed"   , IgnoreFixed);
				Parameters.Insert("ObjectData"    , ObjectData);
				Parameters.Insert("RowData"       , RowData);
				Parameters.Insert("AccountingRowAnalytics"  , AccountingRowAnalytics);
				Parameters.Insert("AccountingExtDimensions" , AccountingExtDimensions);
			
				FillAccountingRowAnalytics(Parameters, Row);
			EndDo;
		EndDo;
	EndIf;
	
	AccountingRowAnalytics.FillValues(Object.Ref, "Document");
	AccountingExtDimensions.FillValues(Object.Ref, "Document");
EndProcedure

Function GetDocumentData(Object, TableRow, MainTableName)
	Result = New Structure("ObjectData, RowData", New Structure(), New Structure());
	// data from row
	If TableRow <> Undefined Then
		TabularSections =  Object.Ref.Metadata().TabularSections;
		For Each Column In TabularSections[MainTableName].Attributes Do
			Result.RowData.Insert(Column.Name, TableRow[Column.Name]);	
		EndDo;
				
		If CommonFunctionsClientServer.ObjectHasProperty(TableRow, "VatRate") Then
			TaxInfo = New Structure();
			TaxInfo.Insert("Key", TableRow.Key);
			TaxInfo.Insert("Tax", TaxesServer.GetVatRef());
			TaxInfo.Insert("VatRate", TableRow.VatRate);
			Result.RowData.Insert("TaxInfo", TaxInfo);
		EndIf;
		
	Else
		Result.RowData.Insert("Key", "");
	EndIf;
	
	// data from object
	If Object <> Undefined Then
		For Each Attr In Object.Ref.Metadata().Attributes Do
			Result.ObjectData.Insert(Attr.Name, Object[Attr.Name]);
		EndDo;
		For Each Attr In Object.Ref.Metadata().StandardAttributes Do
			Result.ObjectData.Insert(Attr.Name, Object[Attr.Name]);
		EndDo;
	EndIf;
	
	Return Result;
EndFunction

Procedure FillAccountingRowAnalytics(Parameters, Row = Undefined)
	AnalyticRow = Undefined;
	RowKey = "";
	Filter = New Structure();
	If Row <> Undefined Then
		RowKey = Row.Key;
		Filter.Insert("Key" , RowKey);
	EndIf;
	Filter.Insert("Operation"  , Parameters.Operation);
	Filter.Insert("LedgerType" , Parameters.LedgerType);
	
	AnalyticRows = Parameters.AccountingRowAnalytics.FindRows(Filter);
	
	If AnalyticRows.Count() > 1 Then
		Raise StrTemplate("More than 1 analytic rows by filter: Key[%1] Operation[%2] LedgerType[%3]", Filter.Key, Filter.Operation, Filter.LedgerType);
	ElsIf AnalyticRows.Count() = 1 Then
		AnalyticRow = AnalyticRows[0];
		If AnalyticRow.IsFixed And Not Parameters.IgnoreFixed Then
			Return;
		EndIf;
	Else
		AnalyticRow = Parameters.AccountingRowAnalytics.Add();
		AnalyticRow.Key = RowKey;		
	EndIf;
	AnalyticRow.IsFixed = False;
	
	AnalyticParameters = New Structure();
	AnalyticParameters.Insert("ObjectData"   , Parameters.ObjectData);
	AnalyticParameters.Insert("RowData"      , Parameters.RowData);
	AnalyticParameters.Insert("Operation"    , Parameters.Operation);
	AnalyticParameters.Insert("LedgerType"   , Parameters.LedgerType);
	AnalyticParameters.Insert("MetadataName" , Parameters.MetadataName);
	
	AnalyticData = Documents[Parameters.MetadataName].GetAccountingAnalytics(AnalyticParameters);
	If AnalyticData = Undefined Then
		Raise StrTemplate("Document [%1] not supported accounting operation [%2]", 
			Parameters.MetadataName, Parameters.Operation);
	EndIf;
		
	AnalyticRow.Operation = AnalyticData.Operation;
	AnalyticRow.LedgerType = AnalyticData.LedgerType;
	
	AnalyticRow.AccountDebit = AnalyticData.Debit;
	FillAccountingExtDimensions(AnalyticData.DebitExtDimensions, Parameters.AccountingExtDimensions);
	
	AnalyticRow.AccountCredit = AnalyticData.Credit;
	FillAccountingExtDimensions(AnalyticData.CreditExtDimensions, Parameters.AccountingExtDimensions);
EndProcedure

Procedure FillAccountingExtDimensions(ArrayOfData, AccountingExtDimensions)
	For Each ExtDim In ArrayOfData Do
		Filter = New Structure();
		If ValueIsFilled(ExtDim.Key) Then
			Filter.Insert("Key" , ExtDim.Key);
		EndIf;
		Filter.Insert("AnalyticType" , ExtDim.AnalyticType);
		Filter.Insert("Operation"    , ExtDim.Operation);
		Filter.Insert("LedgerType"   , ExtDim.LedgerType);
		AccountingExtDimensionRows = AccountingExtDimensions.FindRows(Filter);
		For Each RowForDelete In AccountingExtDimensionRows Do
			AccountingExtDimensions.Delete(RowForDelete);
		EndDo;
	EndDo;
	
	For Each ExtDim In ArrayOfData Do
		NewRow = AccountingExtDimensions.Add();
		NewRow.Key              = ExtDim.Key;
		NewRow.AnalyticType     = ExtDim.AnalyticType;
		NewRow.Operation        = ExtDim.Operation;
		NewRow.LedgerType       = ExtDim.LedgerType;
		NewRow.ExtDimensionType = ExtDim.ExtDimensionType;
		NewRow.ExtDimension     = ExtDim.ExtDimension;
	EndDo;
EndProcedure

Procedure ClearAccountingTables(Object, AccountingRowAnalytics, AccountingExtDimensions, Period, LedgerTypes, MainTableName)
	// AccountingRowAnalytics
	ArrayForDelete = New Array();
	For Each Row In AccountingRowAnalytics Do
		
		If LedgerTypes.Find(Row.LedgerType) = Undefined Then
			ArrayForDelete.Add(Row);
			Continue;
		EndIf;
	
		Operations = New Array();	
		OperationsInfo = GetAccountingOperationsByLedgerType(Object, Period, Row.LedgerType);
		For Each OperationInfo In OperationsInfo Do
			Operations.Add(OperationInfo.Operation);
		EndDo;
		If Operations.Find(Row.Operation) = Undefined Then
			ArrayForDelete.Add(Row);
			Continue;
		EndIf;
		
		If Not ValueIsFilled(MainTableName) Then
			ArrayForDelete.Add(Row);
		Else		
			If Not ValueIsFilled(Row.Key) Then
				Continue;
			EndIf;
			If Not Object[MainTableName].FindRows(New Structure("Key", Row.Key)).Count() Then
				ArrayForDelete.Add(Row);
			EndIf;
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		AccountingRowAnalytics.Delete(ItemForDelete);
	EndDo;
	
	// AccountingExtDimensions
	ArrayForDelete.Clear();
	For Each Row In AccountingExtDimensions Do
		
		If LedgerTypes.Find(Row.LedgerType) = Undefined Then
			ArrayForDelete.Add(Row);
			Continue;
		EndIf;
		
		Operations = New Array();	
		OperationsInfo = GetAccountingOperationsByLedgerType(Object, Period, Row.LedgerType);
		For Each OperationInfo In OperationsInfo Do
			Operations.Add(OperationInfo.Operation);
		EndDo;
		If Operations.Find(Row.Operation) = Undefined Then
			ArrayForDelete.Add(Row);
			Continue;
		EndIf;
		
		If Not ValueIsFilled(MainTableName) Then
			ArrayForDelete.Add(Row);
		Else	
			If Not ValueIsFilled(Row.Key) Then
				Continue;
			EndIf;
			If Not Object[MainTableName].FindRows(New Structure("Key", Row.Key)).Count() Then
				ArrayForDelete.Add(Row);
			EndIf;
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		AccountingExtDimensions.Delete(ItemForDelete);
	EndDo;
EndProcedure

Function GetAccountingData_LandedCost(Parameters)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ItemList.Ref,
	|	ItemList.Key,
	|	ItemList.ItemKey,
	|	ItemList.Store,
	|	ItemList.QuantityInBaseUnit
	|INTO ItemList
	|FROM
	|	Document.%1.ItemList AS ItemList
	|WHERE
	|	ItemList.Ref = &Recorder and ItemList.Key = &RowKey
	|	AND %2
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList.Key,
	|	R6020B_BatchBalance.Company.LandedCostCurrencyMovementType.Currency AS Currency,
	|	ItemList.QuantityInBaseUnit AS Quantity,
	|	sum(isnull(R6020B_BatchBalance.Quantity, 0)) AS QuantityBatchBalance,
	|	sum(isnull(R6020B_BatchBalance.TotalNetAmount, 0)) AS AmountBatchBalance,
	|	0 AS Amount
	|FROM
	|	ItemList AS ItemList
	|		INNER JOIN AccumulationRegister.R6020B_BatchBalance AS R6020B_BatchBalance
	|		ON R6020B_BatchBalance.Store = ItemList.Store
	|		AND R6020B_BatchBalance.ItemKey = ItemList.ItemKey
	|		AND R6020B_BatchBalance.Recorder = ItemList.Ref
	|GROUP BY
	|	ItemList.Key,
	|	R6020B_BatchBalance.Company.LandedCostCurrencyMovementType.Currency,
	|	ItemList.QuantityInBaseUnit";
	
	AdditionalCondition = "TRUE";
	If Parameters.Recorder.MeTadata() = Metadata.Documents.ModernizationOfFixedAsset Then		
		AdditionalCondition = "ItemList.ModernizationType = VALUE(Enum.ModernizationTypes.Mount)";
	EndIf;
	
	Query.Text = StrTemplate(Query.Text, Parameters.Recorder.MeTadata().Name, AdditionalCondition);
	
	OperationsDefinition = GetOperationsDefinition();
	Property = OperationsDefinition.Get(Parameters.Operation);
	ByRow = ?(Property = Undefined, False, Property.ByRow);
	
	RowKey = "";
	If ByRow Then
		RowKey = Parameters.RowKey;
	EndIf;
	
	Query.SetParameter("Recorder" , Parameters.Recorder);
	Query.SetParameter("RowKey"   , RowKey);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	TotalAmount   = 0;
	TotalQuantity = 0;
	If QueryTable.Count() Then
		TotalAmount   = QueryTable[0].AmountBatchBalance;
		TotalQuantity = QueryTable[0].QuantityBatchBalance;
	EndIf;
	
	For Each Row In QueryTable Do
		If Row.Quantity = TotalQuantity Then
			Row.Amount = TotalAmount;
		Else
			Row.Amount = ?(Row.QuantityBatchBalance = 0, 0, (TotalAmount / TotalQuantity) * Row.Quantity);
			TotalQuantity = TotalQuantity - Row.Quantity;
			TotalAmount   = TotalAmount - Row.Amount;
		EndIf;
	EndDo;
	
	RecordSet_AccountingAmounts = AccumulationRegisters.T1040T_AccountingAmounts.CreateRecordSet();
	
	TableAccountingAmounts = RecordSet_AccountingAmounts.UnloadColumns();
	TableAccountingAmounts.Columns.Delete(TableAccountingAmounts.Columns.PointInTime);
	CalculatedTableAccountingAmounts = TableAccountingAmounts.Copy();
		
	For Each Row In QueryTable Do		
		// Accounting amounts
		NewRow_AccountingAmounts = TableAccountingAmounts.Add();
		FillPropertyValues(NewRow_AccountingAmounts, Row);
		NewRow_AccountingAmounts.Period = Parameters.Recorder.Date;
		NewRow_AccountingAmounts.RowKey = Row.Key;
		NewRow_AccountingAmounts.Operation = Parameters.Operation;
	EndDo;
	
	// Currency calculation
	
	CurrenciesTableParams = New Structure();
	CurrenciesTableParams.Insert("Ref"            , Parameters.Recorder);
	CurrenciesTableParams.Insert("Date"           , Parameters.Recorder.Date);
	CurrenciesTableParams.Insert("Company"        , Parameters.Recorder.Company);
	CurrenciesTableParams.Insert("Currency"       , Parameters.Recorder.Company.LandedCostCurrencyMovementType.Currency);
	CurrenciesTableParams.Insert("Agreement"      , Undefined);
	CurrenciesTableParams.Insert("RowKey"         , "");
	CurrenciesTableParams.Insert("DocumentAmount" , 0);
	CurrenciesTableParams.Insert("Currencies"     , New Array());
	
	CurrenciesTable = Parameters.Recorder.Currencies.UnloadColumns();
	CurrenciesServer.UpdateCurrencyTable(CurrenciesTableParams, CurrenciesTable);
	
	CurrenciesParameters = New Structure();
	PostingDataTables = New Map();
	
	TableAccountingAmountsSettings = PostingServer.PostingTableSettings(TableAccountingAmounts, RecordSet_AccountingAmounts);
	PostingDataTables.Insert(RecordSet_AccountingAmounts.Metadata(), TableAccountingAmountsSettings);
		
	ArrayOfPostingInfo = New Array();
	For Each DataTable In PostingDataTables Do
		ArrayOfPostingInfo.Add(DataTable);
	EndDo;
	CurrenciesParameters.Insert("Object", Parameters.Recorder);
	CurrenciesParameters.Insert("Metadata", Parameters.Recorder.Metadata());
	CurrenciesParameters.Insert("ArrayOfPostingInfo", ArrayOfPostingInfo);
	CurrenciesParameters.Insert("IsLandedCost", True);
	CurrenciesServer.PreparePostingDataTables(CurrenciesParameters, CurrenciesTable);
	
	For Each ItemOfPostingInfo In ArrayOfPostingInfo Do
		If ItemOfPostingInfo.Key = Metadata.AccumulationRegisters.T1040T_AccountingAmounts Then
			For Each RowPostingInfo In ItemOfPostingInfo.Value.PrepareTable Do
				FillPropertyValues(CalculatedTableAccountingAmounts.Add(), RowPostingInfo);
			EndDo;
		EndIf;
	EndDo;
	
	Query = New Query();
	Query.Text = 
	"select
	|	table.Currency,
	|	table.Amount,
	|	table.Operation,
	|	table.CurrencyMovementType,
	|	table.RowKey
	|into table
	|from
	|	&table as table
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Amounts.Currency,
	|	SUM(Amounts.Amount) AS Amount
	|FROM
	|	table AS Amounts
	|WHERE
	|	Amounts.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND Amounts.RowKey = &RowKey
	|GROUP BY
	|	Amounts.Currency
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SUM(Amounts.Amount) AS Amount
	|FROM
	|	table AS Amounts
	|WHERE
	|	Amounts.CurrencyMovementType = &CurrencyMovementType
	|	AND Amounts.RowKey = &RowKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SUM(Quantities.Quantity) AS Quantity
	|FROM
	|	AccumulationRegister.T1050T_AccountingQuantities AS Quantities
	|WHERE
	|	Quantities.Recorder = &Recorder
	|	AND Quantities.RowKey = &RowKey";
	
	Query.SetParameter("table"                , CalculatedTableAccountingAmounts);
	Query.SetParameter("Recorder"             , Parameters.Recorder);
	Query.SetParameter("CurrencyMovementType" , Parameters.CurrencyMovementType);
	Query.SetParameter("Operation"            , Parameters.Operation);
	Query.SetParameter("RowKey"           	  , RowKey);
	
	QueryResults = Query.ExecuteBatch();
	
	Result = GetAccountingDataResult();
	
	// Currency amount
	QuerySelection = QueryResults[1].Select();
	If QuerySelection.Next() Then
		Result.CurrencyDr       = QuerySelection.Currency;
		Result.CurrencyAmountDr = QuerySelection.Amount;
		Result.CurrencyCr       = QuerySelection.Currency;
		Result.CurrencyAmountCr = QuerySelection.Amount;
	EndIf;
	
	// Amount
	QuerySelection = QueryResults[2].Select();
	If QuerySelection.Next() Then
		Result.Amount = QuerySelection.Amount;
	EndIf;
	
	// Quantity
	QuerySelection = QueryResults[3].Select();
	If QuerySelection.Next() Then
		Result.QuantityCr = QuerySelection.Quantity;
		Result.QuantityDr = QuerySelection.Quantity;
	EndIf;
	
	Return Result;	
EndFunction

Function GetAccountingData(Parameters)

	If Parameters.Operation = Catalogs.AccountingOperations.RetailSalesReceipt_DR_R5022T_Expenses_CR_R4050B_StockInventory Then
		Return GetAccountingData_LandedCost(Parameters);
	EndIf;
	
	If Parameters.Operation = Catalogs.AccountingOperations.SalesInvoice_DR_R5022T_Expenses_CR_R4050B_StockInventory Then
		Return GetAccountingData_LandedCost(Parameters);
	EndIf;
	
	If Parameters.Operation = Catalogs.AccountingOperations.CommissioningOfFixedAsset_DR_R8510B_BookValueOfFixedAsset_CR_R4050B_StockInventory Then
		Return GetAccountingData_LandedCost(Parameters);
	EndIf;
	
	If Parameters.Operation = Catalogs.AccountingOperations.ModernizationOfFixedAsset_DR_R8510B_BookValueOfFixedAsset_CR_R4050B_StockInventory Then
		Return GetAccountingData_LandedCost(Parameters);
	EndIf;
	
	If Parameters.Operation = Catalogs.AccountingOperations.DecommissioningOfFixedAsset_DR_R4050B_StockInventory_CR_R8510B_BookValueOfFixedAsset Then
		Return GetAccountingData_LandedCost(Parameters);
	EndIf;
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Amounts.Currency,
	|	SUM(Amounts.Amount) AS Amount
	|FROM
	|	AccumulationRegister.T1040T_AccountingAmounts AS Amounts
	|WHERE
	|	Amounts.Recorder = &Recorder
	|	AND Amounts.Operation = &Operation
	|	AND Amounts.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND case
	|		when &FilterByRowKey
	|			then Amounts.RowKey = &RowKey
	|		else True
	|	end
	|GROUP BY
	|	Amounts.Currency
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SUM(Amounts.Amount) AS Amount
	|FROM
	|	AccumulationRegister.T1040T_AccountingAmounts AS Amounts
	|WHERE
	|	Amounts.Recorder = &Recorder
	|	AND Amounts.Operation = &Operation
	|	AND Amounts.CurrencyMovementType = &CurrencyMovementType
	|	AND case
	|		when &FilterByRowKey
	|			then Amounts.RowKey = &RowKey
	|		else True
	|	end
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SUM(Quantities.Quantity) AS Quantity
	|FROM
	|	AccumulationRegister.T1050T_AccountingQuantities AS Quantities
	|WHERE
	|	Quantities.Recorder = &Recorder
	|	AND case
	|		when &FilterByRowKey
	|			then Quantities.RowKey = &RowKey
	|		else True
	|	end";
	
	OperationsDefinition = GetOperationsDefinition();
	Property = OperationsDefinition.Get(Parameters.Operation);
	ByRow = ?(Property = Undefined, False, Property.ByRow);
	
	RowKey = "";
	If ByRow Then
		RowKey = Parameters.RowKey;
	EndIf;
	
	Query.SetParameter("Recorder"             , Parameters.Recorder);
	Query.SetParameter("CurrencyMovementType" , Parameters.CurrencyMovementType);
	Query.SetParameter("Operation"            , Parameters.Operation);
	Query.SetParameter("FilterByRowKey"       , ValueIsFilled(RowKey));
	Query.SetParameter("RowKey"           	  , RowKey);
	
	QueryResults = Query.ExecuteBatch();
	
	Result = GetAccountingDataResult();
	
	// Currency amount
	QuerySelection = QueryResults[0].Select();
	If QuerySelection.Next() Then
		Result.CurrencyDr       = QuerySelection.Currency;
		Result.CurrencyAmountDr = QuerySelection.Amount;
		Result.CurrencyCr       = QuerySelection.Currency;
		Result.CurrencyAmountCr = QuerySelection.Amount;
	EndIf;
	
	// Amount
	QuerySelection = QueryResults[1].Select();
	If QuerySelection.Next() Then
		Result.Amount = QuerySelection.Amount;
	EndIf;
	
	// Quantity
	QuerySelection = QueryResults[2].Select();
	If QuerySelection.Next() Then
		Result.QuantityCr = QuerySelection.Quantity;
		Result.QuantityDr = QuerySelection.Quantity;
	EndIf;
	
	Return Result;	
EndFunction

#Region Event_Handlers

// Form

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	UpdateFormTables(Object, Form);
EndProcedure

Procedure BeforeWriteAtServer(Object, Form, Cancel, CurrentObject, WriteParameters) Export
	CurrentObject.AdditionalProperties.Insert("AccountingRowAnalytics"  , Form.AccountingRowAnalytics.Unload());
	CurrentObject.AdditionalProperties.Insert("AccountingExtDimensions" , Form.AccountingExtDimensions.Unload());
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	UpdateFormTables(Object, Form);
EndProcedure

Procedure UpdateFormTables(Object, Form)
	RecordSet = InformationRegisters.T9050S_AccountingRowAnalytics.CreateRecordSet();
	RecordSet.Filter.Document.Set(Object.Ref);
	RecordSet.Read();
	Form.AccountingRowAnalytics.Load(RecordSet.Unload());
	
	RecordSet = InformationRegisters.T9051S_AccountingExtDimensions.CreateRecordSet();
	RecordSet.Filter.Document.Set(Object.Ref);
	RecordSet.Read();
	Form.AccountingExtDimensions.Load(RecordSet.Unload());
EndProcedure	

// Object

Procedure OnWrite(Object, Cancel) Export
	_AccountingRowAnalytics = CommonFunctionsClientServer.GetFromAddInfo(Object.AdditionalProperties, "AccountingRowAnalytics", Undefined);
	If _AccountingRowAnalytics = Undefined Then
		RecordSet = InformationRegisters.T9050S_AccountingRowAnalytics.CreateRecordSet();
		RecordSet.Filter.Document.Set(Object.Ref);
		RecordSet.Read();
		_AccountingRowAnalytics = RecordSet.Unload();
	EndIf;
			
	_AccountingExtDimensions = CommonFunctionsClientServer.GetFromAddInfo(Object.AdditionalProperties, "AccountingExtDimensions", Undefined);
	If _AccountingExtDimensions = Undefined Then
		RecordSet = InformationRegisters.T9051S_AccountingExtDimensions.CreateRecordSet();
		RecordSet.Filter.Document.Set(Object.Ref);
		RecordSet.Read();
		_AccountingExtDimensions = RecordSet.Unload();
	EndIf;
		
	AccountingClientServer.UpdateAccountingTables(Object, 
		                                         _AccountingRowAnalytics, 
		                                         _AccountingExtDimensions,
		                                         AccountingClientServer.GetDocumentMainTable(Object));
		
	Object.AdditionalProperties.Insert("AccountingRowAnalytics"  , _AccountingRowAnalytics);
	Object.AdditionalProperties.Insert("AccountingExtDimensions" , _AccountingExtDimensions);
EndProcedure

// Manager

Procedure CreateAccountingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo) Export
	_AccountingRowAnalytics  = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "AccountingRowAnalytics", Undefined);
	_AccountingExtDimensions = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "AccountingExtDimensions", Undefined);
	
	If _AccountingRowAnalytics = Undefined Or _AccountingExtDimensions = Undefined Then
		Return;
	EndIf;
	
	_AccountingRowAnalytics.FillValues(Ref, "Document");
	
	RecordSet = InformationRegisters.T9050S_AccountingRowAnalytics.CreateRecordSet();
	RecordSet.Filter.Document.Set(Ref);
	RecordSet.Load(_AccountingRowAnalytics);
	RecordSet.Write();
		
	_AccountingExtDimensions.FillValues(Ref, "Document");
	
	RecordSet = InformationRegisters.T9051S_AccountingExtDimensions.CreateRecordSet();
	RecordSet.Filter.Document.Set(Ref);
	RecordSet.Load(_AccountingExtDimensions);
	RecordSet.Write();	
EndProcedure

#EndRegion

#Region JournalEntry

Procedure CreateJE_ByDocumentName(DocumentName, Company, LedgerType, StartDate, EndDate) Export
	Query = New Query();
	Query_Text = 
	"SELECT
	|	Doc.Ref
	|INTO Documents
	|FROM
	|	Document.%1 AS Doc
	|WHERE
	|	Doc.Date BETWEEN BEGINOFPERIOD(&StartDate, DAY) AND ENDOFPERIOD(&EndDate, DAY)
	|	AND Doc.Company = &Company
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Documents.Ref AS Basis,
	|	JournalEntry.Ref AS JournalEntry,
	|	&LedgerType AS LedgerType
	|FROM
	|	Documents AS Documents
	|		LEFT JOIN Document.JournalEntry AS JournalEntry
	|		ON Documents.Ref = JournalEntry.Basis
	|		AND NOT JournalEntry.DeletionMark
	|		AND JournalEntry.LedgerType = &LedgerType";
	Query.Text = StrTemplate(Query_Text, DocumentName);
	Query.SetParameter("StartDate"  , StartDate);
	Query.SetParameter("EndDate"    , EndDate);
	Query.SetParameter("Company"    , Company);
	Query.SetParameter("LedgerType" , LedgerType);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	CreateJE(QueryTable);
	
EndProcedure

Procedure CreateJE_ByArrayRefs(ArrayOfRefs, ArrayOfLedgerTypes) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Doc.Document,
	|	Doc.LedgerType
	|INTO Documents
	|FROM
	|	&Documents AS Doc
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Documents.Document AS Basis,
	|	JournalEntry.Ref AS JournalEntry,
	|	Documents.LedgerType
	|FROM
	|	Documents AS Documents
	|		LEFT JOIN Document.JournalEntry AS JournalEntry
	|		ON Documents.Document = JournalEntry.Basis
	|		AND NOT JournalEntry.DeletionMark
	|		AND JournalEntry.LedgerType = Documents.LedgerType";

	DocumentTable = New ValueTable();
	DocumentTable.Columns.Add("Document", Metadata.Documents.JournalEntry.Attributes.Basis.Type);
	DocumentTable.Columns.Add("LedgerType", New TypeDescription("CatalogRef.LedgerTypes"));
	
		For Each Ref In ArrayOfRefs Do
			AvailableLedgerTypes = GetLedgerTypesByCompany(Ref, Ref.Date, Ref.Company);
			For Each LedgerTpe In ArrayOfLedgerTypes Do
				If AvailableLedgerTypes.Find(LedgerTpe) = Undefined Then
					Continue;
				EndIf;		
				NewRow = DocumentTable.Add();
				NewRow.Document = Ref;
				NewRow.LedgerType = LedgerTpe;
			EndDo;
		EndDo;
	
	Query.SetParameter("Documents"  , DocumentTable);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	CreateJE(QueryTable);			
EndProcedure

Procedure CreateJE(QueryTable)
	For Each Row In QueryTable Do
		If ValueIsFilled(Row.JournalEntry) Then
			DocObject = Row.JournalEntry.GetObject();
			CommonFunctionsClientServer.PutToAddInfo(DocObject.AdditionalProperties, "WriteOnForm", True);
			DocObject.Write(DocumentWriteMode.Write);
		Else
			DocObject = Documents.JournalEntry.CreateDocument();
			CommonFunctionsClientServer.PutToAddInfo(DocObject.AdditionalProperties, "WriteOnForm", True);
			DocObject.Fill(New Structure("Basis, LedgerType", Row.Basis, Row.LedgerType));
			DocObject.Date = Row.Basis.Date;
			DocObject.Write(DocumentWriteMode.Write);
		EndIf;
	EndDo;
EndProcedure

Procedure UpdateAnalyticsJE_ByDocumentName(DocumentName, Company, StartDate, EndDate) Export
	Query = New Query();
	Query_Text = 
	"SELECT
	|	Doc.Ref
	|FROM
	|	Document.%1 AS Doc
	|WHERE
	|	Doc.Posted
	|	AND Doc.Date BETWEEN BEGINOFPERIOD(&StartDate, DAY) AND ENDOFPERIOD(&EndDate, DAY)
	|	AND Doc.Company = &Company";
	
	Query.Text = StrTemplate(Query_Text, DocumentName);
	Query.SetParameter("StartDate"  , StartDate);
	Query.SetParameter("EndDate"    , EndDate);
	Query.SetParameter("Company"    , Company);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	UpdateAnalyticsJE(QueryTable);
EndProcedure

Procedure UpdateAnalyticsJE_ByArrayRefs(ArrayOfRefs) Export
	DocumentTable = New ValueTable();
	DocumentTable.Columns.Add("Ref", Metadata.Documents.JournalEntry.Attributes.Basis.Type);
	
	For Each Ref In ArrayOfRefs Do
		NewRow = DocumentTable.Add();
		NewRow.Ref = Ref;
	EndDo;
	
	UpdateAnalyticsJE(DocumentTable);
EndProcedure

Procedure UpdateAnalyticsJE(QueryTable)
	For Each Row In QueryTable Do
		RecordSet_T9050S = InformationRegisters.T9050S_AccountingRowAnalytics.CreateRecordSet();
		RecordSet_T9050S.Filter.Document.Set(Row.Ref);
		RecordSet_T9050S.Read();
		_AccountingRowAnalytics = RecordSet_T9050S.Unload();
		
		RecordSet_T9051S = InformationRegisters.T9051S_AccountingExtDimensions.CreateRecordSet();
		RecordSet_T9051S.Filter.Document.Set(Row.Ref);
		RecordSet_T9051S.Read();
		_AccountingExtDimensions = RecordSet_T9051S.Unload();
					
		AccountingClientServer.UpdateAccountingTables(Row.Ref, 
													  _AccountingRowAnalytics, 
													  _AccountingExtDimensions, 
													  AccountingClientServer.GetDocumentMainTable(Row.Ref));
													  
		//_AccountingRowAnalytics.FillValues(True, "Active");
		//_AccountingExtDimensions.FillValues(True, "Active");
		
		RecordSet_T9050S.Load(_AccountingRowAnalytics);
		RecordSet_T9050S.Write();
		
		RecordSet_T9051S.Load(_AccountingExtDimensions);
		RecordSet_T9051S.Write();		
	EndDo;	
EndProcedure

#EndRegion

