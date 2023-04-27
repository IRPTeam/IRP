
#Region ENTRY_POINTS

Procedure EntryPoint(StepNames, Parameters, ExecuteLazySteps = False) Export
	InitEntryPoint(StepNames, Parameters);
	Parameters.ModelEnvironment.StepNamesCounter.Add(StepNames);

If ValueIsFilled(StepNames) And StepNames <> "BindVoid" Then 

#IF Client THEN
	Transfer = New Structure("Form, Object", Parameters.Form, Parameters.Object);
	TransferFormToStructure(Transfer, Parameters);
#ENDIF

	ModelServer_V2.ServerEntryPoint(StepNames, Parameters, ExecuteLazySteps);

#IF Client THEN
	TransferStructureToForm(Transfer, Parameters);
#ENDIF
	
EndIf;

	// if cache was initialized from this EntryPoint then ChainComplete
	If Parameters.ModelEnvironment.FirstStepNames = StepNames Or ExecuteLazySteps Then
		If Parameters.ModelEnvironment.ArrayOfLazySteps.Count() Then
			LazyStepNames = StrConcat(Parameters.ModelEnvironment.ArrayOfLazySteps, ",");
			Parameters.ModelEnvironment.ArrayOfLazySteps.Clear();
			EntryPoint(LazyStepNames, Parameters, True);
		Else	
			ControllerClientServer_V2.OnChainComplete(Parameters);
			DestroyEntryPoint(Parameters);
		EndIf;
	EndIf;
EndProcedure

Procedure ServerEntryPoint(StepNames, Parameters, ExecuteLazySteps) Export
	Chain = GetChain();
	For Each ArrayItem In StrSplit(StepNames, ",") Do
		//@skip-warning
		Execute StrTemplate("%1.%2(Parameters, Chain);", 
			Parameters.ControllerModuleName, 
			StrReplace(TrimAll(ArrayItem), Chars.NBSp, ""));
	EndDo;
	ExecuteChain(Parameters, Chain, ExecuteLazySteps);
EndProcedure

Procedure TransferFormToStructure(Transfer, Parameters) Export
	If ValueIsFilled(Parameters.PropertyBeforeChange.Form.Names) Then
		// transfer form to structure, on server will be available attributes for read data
		TransferForm = New Structure(Parameters.PropertyBeforeChange.Form.Names);
		FillPropertyValues(TransferForm, Transfer.Form);
		Parameters.Form = TransferForm;
	Else
		Parameters.Form = Undefined;
	EndIf;
EndProcedure

Procedure TransferStructureToForm(Transfer, Parameters) Export
	Parameters.Form   = Transfer.Form;
	Parameters.Object = Transfer.Object;
EndProcedure

#EndRegion

#Region CHAIN

Function GetChainLink(ExecutorName)
	ChainLink = New Structure();
	ChainLink.Insert("Enable" , False);
	ChainLink.Insert("Options", New Array());
	ChainLink.Insert("Setter" , Undefined);
	ChainLink.Insert("ExecutorName", ExecutorName);
	ChainLink.Insert("IsLazyStep"  , False);
	ChainLink.Insert("LazyStepName", "");
	ChainLink.Insert("StepName"    , "");
	Return ChainLink; 
EndFunction

Function GetChainLinkOptions(StrOptions)
	Options = New Structure();
	Options.Insert("Key");
	Options.Insert("StepName"); // for debug only
	Options.Insert("DontExecuteIfExecutedBefore", False);
	Options.Insert("DisableNextSteps", False);
	Segments = StrSplit(StrOptions, ",");
	For Each Segment In Segments Do
		If ValueIsFilled(Segment) Then
			Options.Insert(TrimAll(Segment));
		EndIf;
	EndDo;
	Return Options;
EndFunction

Function GetChainLinkResult(Options, Value)
	Result = New Structure();
	Result.Insert("Value"   , Value);
	Result.Insert("Options" , Options);
	Return Result;
EndFunction

Procedure ExecuteChain(Parameters, Chain, ExecuteLazySteps)
	For Each ChainLink In Chain Do
		Name = ChainLink.Key;
		If Name = "Idle" Then
			Continue;
		EndIf;
		ChainItem = Chain[Name]; 
		If Not ChainItem.Enable Then
			Continue;
		EndIf;
		
		ChainItem_Options = ChainItem.Options;
		
		If ValueIsFilled(ChainItem.StepName) Then
			BufferChain = GetChain();
			//@skip-warning
			Execute StrTemplate("%1.%2(Parameters, BufferChain);", Parameters.ControllerModuleName, ChainItem.StepName);
			For Each KeyValue In BufferChain Do
				If KeyValue.Key = "Idle" Then
					Continue;
				EndIf;
				BufferChainItem = BufferChain[KeyValue.Key];
				If BufferChainItem.Enable Then
					ChainItem_Options = BufferChainItem.Options;
					ChainItem.Setter = BufferChainItem.Setter;
					Break;
				EndIf;
			EndDo;	
		EndIf;
			
		Results = New Array();
		For Each Options In ChainItem_Options Do	
			If Options.DontExecuteIfExecutedBefore 
				And Not Parameters.ModelEnvironment.AlreadyExecutedSteps.Get(Name + ":" + Options.Key) = Undefined Then
					Continue;
			EndIf;
				
			If Not ExecuteLazySteps And ChainItem.IsLazyStep Then
				StepName = ChainItem.LazyStepName;
				If Parameters.ModelEnvironment.ArrayOfLazySteps.Find(StepName) = Undefined Then
					Parameters.ModelEnvironment.ArrayOfLazySteps.Add(StepName);
				EndIf;
				AddToAlreadyExecutedSteps(Parameters, Options, Name);
				Continue; // dont execute
			EndIf;
			
			Result = Undefined;
			ExecutorName = ChainItem.ExecutorName;
			// procedure with prefix XX_ placed in extension
			If Mid(ExecutorName, 3, 1) = "_" Then
				ExecuteInExtension(Result, Options, ExecutorName);
			Else
				//@skip-warning
				Execute StrTemplate("Result = %1(Options)", ExecutorName);
			EndIf;
			Results.Add(GetChainLinkResult(Options, Result));
			AddToAlreadyExecutedSteps(Parameters, Options, Name);
		EndDo;
		// set result to property
		If Not ChainItem.IsLazyStep Or (ChainItem.IsLazyStep And ExecuteLazySteps) Then
			//@skip-warning
			Execute StrTemplate("%1.%2(Parameters, Results);", Parameters.ControllerModuleName, ChainItem.Setter);
		EndIf;
		
		ChainItem.Enable = False;
		ChainItem.Options.Clear();
		
	EndDo;
	
	ArrayOfNextSteps = New Array();
	For Each StepName In Parameters.NextSteps Do
		ArrayOfNextSteps.Add(StepName);
	EndDo;
	
	Parameters.NextSteps.Clear();
	NewChain = New Structure();
	For Each StepName In ArrayOfNextSteps Do
		IdleChain = GetChain();
		IdleChain.Idle = True;
		//@skip-warning
		Execute StrTemplate("%1.%2(Parameters, IdleChain);", Parameters.ControllerModuleName, StepName);
		For Each KeyValue In IdleChain Do
			If KeyValue.Key = "Idle" Then
				Continue;
			EndIf;
			IdleChainItem = IdleChain[KeyValue.Key];
			If IdleChainItem.Enable Then
				NewChainName = KeyValue.Key + "_" + StepName;
				NewChain.Insert(NewChainName, KeyValue.Value);
				NewChain[NewChainName].StepName = StepName;
			EndIf;
		EndDo;
	EndDo;
	If ArrayOfNextSteps.Count() Then
		ExecuteChain(Parameters, NewChain, ExecuteLazySteps);
	EndIf;
EndProcedure

Procedure AddToAlreadyExecutedSteps(Parameters, Options, Name)
	Parameters.ModelEnvironment.AlreadyExecutedSteps.Insert(Name + ":" + Options.Key, New Structure("Name, Key", Name, Options.Key));
EndProcedure

// used in extensions
Procedure ExecuteInExtension(Result, Options, ExecutorName)
	Return;
EndProcedure

Function GetChain()
	Chain = New Structure("Idle", False);
	// Default.List
	Chain.Insert("DefaultStoreInList"        , GetChainLink("DefaultStoreInListExecute"));
	Chain.Insert("DefaultDeliveryDateInList" , GetChainLink("DefaultDeliveryDateInListExecute"));
	Chain.Insert("DefaultQuantityInList"     , GetChainLink("DefaultQuantityInListExecute"));
	Chain.Insert("DefaultCurrencyInList"     , GetChainLink("DefaultCurrencyInListExecute"));
	Chain.Insert("DefaultInventoryOrigin"    , GetChainLink("DefaultInventoryOriginExecute"));
	
	// Empty.Header
	Chain.Insert("EmptyStoreInHeader"     , GetChainLink("EmptyStoreInHeaderExecute"));
	
	// Default.Header
	Chain.Insert("DefaultStoreInHeader"        , GetChainLink("DefaultStoreInHeaderExecute"));
	Chain.Insert("DefaultDeliveryDateInHeader" , GetChainLink("DefaultDeliveryDateInHeaderExecute"));
	
	Chain.Insert("GenerateNewSendUUID"    , GetChainLink("GenerateNewUUIDExecute"));
	Chain.Insert("GenerateNewReceiptUUID" , GetChainLink("GenerateNewUUIDExecute"));
	
	// Clears
	Chain.Insert("ClearByTransactionTypeBankPayment", GetChainLink("ClearByTransactionTypeBankPaymentExecute"));
	Chain.Insert("ClearByTransactionTypeBankReceipt", GetChainLink("ClearByTransactionTypeBankReceiptExecute"));
	Chain.Insert("ClearByTransactionTypeCashPayment", GetChainLink("ClearByTransactionTypeCashPaymentExecute"));
	Chain.Insert("ClearByTransactionTypeCashReceipt", GetChainLink("ClearByTransactionTypeCashReceiptExecute"));
	Chain.Insert("ClearByTransactionTypeOutgoingPaymentOrder", GetChainLink("ClearByTransactionTypeOutgoingPaymentOrderExecute"));
	Chain.Insert("ClearByTransactionTypeCashExpenseRevenue"  , GetChainLink("ClearByTransactionTypeCashExpenseRevenueExecute"));
	
	// Changes
	Chain.Insert("ChangeManagerSegmentByPartner", GetChainLink("ChangeManagerSegmentByPartnerExecute"));
	Chain.Insert("ChangeLegalNameByPartner"     , GetChainLink("ChangeLegalNameByPartnerExecute"));
	Chain.Insert("ChangePartnerByLegalName"     , GetChainLink("ChangePartnerByLegalNameExecute"));
	Chain.Insert("ChangePartnerByTransactionType", GetChainLink("ChangePartnerByTransactionTypeExecute"));
	Chain.Insert("ChangeAgreementByPartner"     , GetChainLink("ChangeAgreementByPartnerExecute"));
	
	Chain.Insert("ChangeCompanyByAgreement"           , GetChainLink("ChangeCompanyByAgreementExecute"));
	Chain.Insert("ChangeCurrencyByAgreement"          , GetChainLink("ChangeCurrencyByAgreementExecute"));
	Chain.Insert("ChangeStoreByAgreement"             , GetChainLink("ChangeStoreByAgreementExecute"));
	Chain.Insert("ChangeDeliveryDateByAgreement"      , GetChainLink("ChangeDeliveryDateByAgreementExecute"));
	Chain.Insert("ChangePriceIncludeTaxByAgreement"   , GetChainLink("ChangePriceIncludeTaxByAgreementExecute"));
	Chain.Insert("ChangeBasisDocumentByAgreement"     , GetChainLink("ChangeBasisDocumentByAgreementExecute"));
	Chain.Insert("ChangeOrderByAgreement"             , GetChainLink("ChangeOrderByAgreementExecute"));
	Chain.Insert("ChangeApArPostingDetailByAgreement" , GetChainLink("ChangeApArPostingDetailByAgreementExecute"));
	
	Chain.Insert("ChangeCashAccountByCompany"        , GetChainLink("ChangeCashAccountByCompanyExecute"));
	Chain.Insert("ChangeAccountSenderByCompany"      , GetChainLink("ChangeCashAccountByCompanyExecute"));
	Chain.Insert("ChangeAccountReceiverByCompany"    , GetChainLink("ChangeCashAccountByCompanyExecute"));
	Chain.Insert("ChangeLandedCostCurrencyByCompany" , GetChainLink("ChangeLandedCostCurrencyByCompanyExecute"));
	Chain.Insert("ChangeCashAccountByCompany_CashReceipt" , GetChainLink("ChangeCashAccountByCompany_CashReceiptExecute"));
	
	Chain.Insert("ChangeTransitAccountByAccount"      , GetChainLink("ChangeTransitAccountByAccountExecute"));
	Chain.Insert("ChangeReceiptingAccountByAccount"   , GetChainLink("ChangeReceiptingAccountByAccountExecute"));
	Chain.Insert("ChangeCashAccountByCurrency"        , GetChainLink("ChangeCashAccountByCurrencyExecute"));
	Chain.Insert("ChangeCashAccountByPartner"         , GetChainLink("ChangeCashAccountByPartnerExecute"));
	Chain.Insert("ChangeCashAccountByTransactionType" , GetChainLink("ChangeCashAccountByTransactionTypeExecute"));
	
	Chain.Insert("FillByPTBBankReceipt" , GetChainLink("FillByPTBBankReceiptExecute"));
	Chain.Insert("FillByPTBCashReceipt" , GetChainLink("FillByPTBCashReceiptExecute"));
	Chain.Insert("FillByPTBBankPayment" , GetChainLink("FillByPTBBankPaymentExecute"));
	Chain.Insert("FillByPTBCashPayment" , GetChainLink("FillByPTBCashPaymentExecute"));
	
	Chain.Insert("FillByCashTransferOrder" , GetChainLink("FillByCashTransferOrderExecute"));
	
	Chain.Insert("FillByMoneyTransferCashReceipt" , GetChainLink("FillByMoneyTransferCashReceiptExecute"));
	
	Chain.Insert("ChangeItemByPartnerItem" , GetChainLink("ChangeItemByPartnerItemExecute"));
	Chain.Insert("ChangeItemKeyByItem"     , GetChainLink("ChangeItemKeyByItemExecute"));
	Chain.Insert("ChangeItemKeyWriteOffByItem"      , GetChainLink("ChangeItemKeyWriteOffByItemExecute"));
	Chain.Insert("ChangeProcurementMethodByItemKey" , GetChainLink("ChangeProcurementMethodByItemKeyExecute"));
	
	Chain.Insert("ChangeCurrencyByAccount", GetChainLink("ChangeCurrencyByAccountExecute"));
	Chain.Insert("ChangeIsFixedCurrencyByAccount", GetChainLink("ChangeIsFixedCurrencyByAccountExecute"));
	Chain.Insert("ChangePlanningTransactionBasisByCurrency", GetChainLink("ChangePlanningTransactionBasisByCurrencyExecute"));
	Chain.Insert("FillStoresInList"       , GetChainLink("FillStoresInListExecute"));
	Chain.Insert("FillDeliveryDateInList" , GetChainLink("FillDeliveryDateInListExecute"));
	Chain.Insert("ChangeStoreInHeaderByStoresInList"    , GetChainLink("ChangeStoreInHeaderByStoresInListExecute"));
	Chain.Insert("ChangeDeliveryDateInHeaderByDeliveryDateInList" , GetChainLink("ChangeDeliveryDateInHeaderByDeliveryDateInListExecute"));
	Chain.Insert("ChangeUseShipmentConfirmationByStore" , GetChainLink("ChangeUseShipmentConfirmationByStoreExecute"));
	Chain.Insert("ChangeUseGoodsReceiptByStore"         , GetChainLink("ChangeUseGoodsReceiptByStoreExecute"));
	Chain.Insert("ChangeUseGoodsReceiptByUseShipmentConfirmation", GetChainLink("ChangeUseGoodsReceiptByUseShipmentConfirmationExecute"));
	
	Chain.Insert("ChangePriceTypeByAgreement"   , GetChainLink("ChangePriceTypeByAgreementExecute"));
	Chain.Insert("ChangePriceTypeAsManual"      , GetChainLink("ChangePriceTypeAsManualExecute"));

	Chain.Insert("ChangeUnitByItemKey"               , GetChainLink("ChangeUnitByItemKeyExecute"));
	Chain.Insert("ChangeUseSerialLotNumberByItemKey" , GetChainLink("ChangeUseSerialLotNumberByItemKeyExecute"));
	Chain.Insert("ChangeIsServiceByItemKey"          , GetChainLink("ChangeIsServiceByItemKeyExecute"));
	
	Chain.Insert("ClearSerialLotNumberByItemKey"    , GetChainLink("ClearSerialLotNumberByItemKeyExecute"));
	Chain.Insert("ClearBarcodeByItemKey"            , GetChainLink("ClearBarcodeByItemKeyExecute"));
	
	Chain.Insert("ChangePriceByPriceType"        , GetChainLink("ChangePriceByPriceTypeExecute"));
	Chain.Insert("ChangePaymentTermsByAgreement" , GetChainLink("ChangePaymentTermsByAgreementExecute"));	
	Chain.Insert("RequireCallCreateTaxesFormControls", GetChainLink("RequireCallCreateTaxesFormControlsExecute"));
	Chain.Insert("ChangeTaxRate", GetChainLink("ChangeTaxRateExecute"));
	Chain.Insert("ChangeTaxAmountAsManualAmount", GetChainLink("ChangeTaxAmountAsManualAmountExecute"));
	Chain.Insert("Calculations" , GetChainLink("CalculationsExecute"));
	Chain.Insert("SimpleCalculations" , GetChainLink("SimpleCalculationsExecute"));
	Chain.Insert("UpdatePaymentTerms" , GetChainLink("UpdatePaymentTermsExecute"));
	
	Chain.Insert("ChangePartnerByRetailCustomer"   , GetChainLink("ChangePartnerByRetailCustomerExecute"));
	Chain.Insert("ChangeAgreementByRetailCustomer" , GetChainLink("ChangeAgreementByRetailCustomerExecute"));
	Chain.Insert("ChangeLegalNameByRetailCustomer" , GetChainLink("ChangeLegalNameByRetailCustomerExecute"));
	Chain.Insert("ChangeUsePartnerTransactionsByRetailCustomer" , GetChainLink("ChangeUsePartnerTransactionsByRetailCustomerExecute"));

	Chain.Insert("ChangeExpenseTypeByItemKey" , GetChainLink("ChangeExpenseTypeByItemKeyExecute"));
	Chain.Insert("ChangeRevenueTypeByItemKey" , GetChainLink("ChangeRevenueTypeByItemKeyExecute"));
	
	Chain.Insert("ChangeReceiveAmountBySendAmount" , GetChainLink("ChangeReceiveAmountBySendAmountExecute"));
	
	Chain.Insert("CovertQuantityToQuantityInBaseUnit" , GetChainLink("CovertQuantityToQuantityInBaseUnitExecute"));
	
	Chain.Insert("CalculateDifferenceCount" , GetChainLink("CalculateDifferenceCountExecute"));

	Chain.Insert("GetCommissionPercent"	 , GetChainLink("GetCommissionPercentExecute"));
	Chain.Insert("CalculateCommission"   , GetChainLink("CalculateCommissionExecute"));
	Chain.Insert("ChangePercentByAmount" , GetChainLink("CalculatePercentByAmountExecute"));
	
	Chain.Insert("PaymentListCalculateCommission"  , GetChainLink("CalculatePaymentListCommissionExecute"));
	Chain.Insert("ChangeCommissionPercentByAmount" , GetChainLink("CalculateCommissionPercentByAmountExecute"));
	
	Chain.Insert("ChangeLandedCostBySalesDocument" , GetChainLink("ChangeLandedCostBySalesDocumentExecute"));
	
	Chain.Insert("ChangeStatusByCheque" , GetChainLink("ChangeStatusByChequeExecute"));
	
	Chain.Insert("ChangeConsolidatedRetailSalesByWorkstation" , GetChainLink("ChangeConsolidatedRetailSalesByWorkstationExecute"));
	Chain.Insert("ChangeConsolidatedRetailSalesByWorkstationForReturn" , GetChainLink("ChangeConsolidatedRetailSalesByWorkstationForReturnExecute"));
	
	Chain.Insert("ChangeIsManualChangedByItemKey"               , GetChainLink("ChangeIsManualChangedByItemKeyExecute"));
	Chain.Insert("ChangeIsManualChangedByQuantity"              , GetChainLink("ChangeIsManualChangedByQuantityExecute"));
	Chain.Insert("ChangeUniqueIDByItemKeyBOMAndBillOfMaterials" , GetChainLink("ChangeUniqueIDByItemKeyBOMAndBillOfMaterialsExecute"));
	Chain.Insert("ChangeStoreByCostWriteOff"                    , GetChainLink("ChangeStoreByCostWriteOffExecute"));
	Chain.Insert("ChangeProfitLossCenterByBillOfMaterials"      , GetChainLink("ChangeProfitLossCenterByBillOfMaterialsExecute"));
	Chain.Insert("ChangeExpenseTypeByBillOfMaterials"           , GetChainLink("ChangeExpenseTypeByBillOfMaterialsExecute"));
	
	Chain.Insert("ChangeBillOfMaterialsByItemKey" , GetChainLink("ChangeBillOfMaterialsByItemKeyExecute"));
	Chain.Insert("ChangeCostMultiplierRatioByBillOfMaterials"  , GetChainLink("ChangeCostMultiplierRatioByBillOfMaterialsExecute"));
	Chain.Insert("ChangeDurationOfProductionByBillOfMaterials" , GetChainLink("ChangeDurationOfProductionByBillOfMaterialsExecute"));
	
	Chain.Insert("ChangePlanningPeriodByDateAndBusinessUnit" , GetChainLink("ChangePlanningPeriodByDateAndBusinessUnitExecute"));
	Chain.Insert("ChangeProductionPlanningByPlanningPeriod"  , GetChainLink("ChangeProductionPlanningByPlanningPeriodExecute"));
	Chain.Insert("ChangeCurrentQuantityInProductions"        , GetChainLink("ChangeCurrentQuantityInProductionsExecute"));
	
	Chain.Insert("BillOfMaterialsListCalculations"           , GetChainLink("BillOfMaterialsListCalculationsExecute"));
	Chain.Insert("BillOfMaterialsListCalculationsCorrection" , GetChainLink("BillOfMaterialsListCalculationsCorrectionExecute"));
	Chain.Insert("MaterialsCalculations"                     , GetChainLink("MaterialsCalculationsExecute"));
	Chain.Insert("MaterialsRecalculateQuantity"              , GetChainLink("MaterialsRecalculateQuantityExecute"));
	
	Chain.Insert("ChangeTradeAgentFeeTypeByAgreement"           , GetChainLink("ChangeTradeAgentFeeTypeByAgreementExecute"));
	Chain.Insert("ChangeTradeAgentFeePercentByAgreement"        , GetChainLink("ChangeTradeAgentFeePercentByAgreementExecute"));
	Chain.Insert("ChangeTradeAgentFeePercentByAmount"           , GetChainLink("ChangeTradeAgentFeePercentByAmountExecute"));
	Chain.Insert("ChangeTradeAgentFeeAmountByTradeAgentFeeType" , GetChainLink("ChangeTradeAgentFeeAmountByTradeAgentFeeTypeExecute"));
	
	Chain.Insert("ConsignorBatchesFillBatches"                  , GetChainLink("ConsignorBatchesFillBatchesExecute"));
	
	// Extractors
	Chain.Insert("ExtractDataAgreementApArPostingDetail"   , GetChainLink("ExtractDataAgreementApArPostingDetailExecute"));
	Chain.Insert("ExtractDataCurrencyFromAccount"          , GetChainLink("ExtractDataCurrencyFromAccountExecute"));
	
	// Loaders
	Chain.Insert("LoadTable", GetChainLink("LoadTableExecute"));
	
	Return Chain;
EndFunction

#EndRegion

#Region INVENTORY_ORIGIN

Function DefaultInventoryOriginOptions() Export
	Return GetChainLinkOptions("CurrentInventoryOrigin");
EndFUnction

Function DefaultInventoryOriginExecute(Options) Export
	InventoryOrigin = ?(ValueIsFilled(Options.CurrentInventoryOrigin), Options.CurrentInventoryOrigin, 
		PredefinedValue("Enum.InventoryOriginTypes.OwnStocks"));
	Return InventoryOrigin;
EndFunction	

#EndRegion

#Region ITEM_ITEMKEY_UNIT_QUANTITYINBASEUNIT

Function DefaultQuantityInListOptions() Export
	Return GetChainLinkOptions("CurrentQuantity");
EndFunction

Function DefaultQuantityInListExecute(Options) Export
	Quantity = ?(ValueIsFilled(Options.CurrentQuantity), Options.CurrentQuantity, 1);
	Return Quantity;
EndFunction

Function ChangeItemKeyByItemOptions() Export
	Return GetChainLinkOptions("Item, ItemKey");
EndFunction

Function ChangeItemKeyByItemExecute(Options) Export
	If Not ValueIsFilled(Options.Item) Then
		Return Undefined;
	EndIf;
	If ValueIsFilled(Options.ItemKey) And Options.ItemKey.Item = Options.Item Then
		Return Options.ItemKey;
	EndIf;
	
	ItemKey = CatItemsServer.GetItemKeyByItem(Options.Item); 
	Return ItemKey;
EndFunction

Function ChangeItemKeyWriteOffByItemOptions() Export
	Return GetChainLinkOptions("Item, ItemKeyWriteOff");
EndFunction

Function ChangeItemKeyWriteOffByItemExecute(Options) Export
	If Not ValueIsFilled(Options.Item) Then
		Return Undefined;
	EndIf;
	If ValueIsFilled(Options.ItemKeyWriteOff) And Options.ItemKeyWriteOff.Item = Options.Item Then
		Return Options.ItemKeyWriteOff;
	EndIf;
	
	ItemKeyWriteOff = CatItemsServer.GetItemKeyByItem(Options.Item);	
	Return ItemKeyWriteOff;
EndFunction

Function ChangeUnitByItemKeyOptions() Export
	Return GetChainLinkOptions("ItemKey");
EndFunction

Function ChangeUnitByItemKeyExecute(Options) Export
	If Not ValueIsFilled(Options.ItemKey) Then
		Return Undefined;
	EndIf;
	UnitInfo = GetItemInfo.ItemUnitInfo(Options.ItemKey);
	Return UnitInfo.Unit;
EndFunction

#EndRegion

#Region CHANGE_LANDEDCOST_BY_SALES_DOCUMENT

Function ChangeLandedCostBySalesDocumentOptions() Export
	Return GetChainLinkOptions("SalesDocument, CurrentLandedCost");
EndFunction

Function ChangeLandedCostBySalesDocumentExecute(Options) Export
	If ValueIsFilled(Options.SalesDocument) Then
		Return Undefined;
	EndIf;
	Return Options.CurrentLandedCost;
EndFunction

#EndRegion

#Region CLEAR_BARCODE_BY_ITEMKEY

Function ClearBarcodeByItemKeyOptions() Export
	Return GetChainLinkOptions("ItemKeyIsChanged, CurrentBarcode");
EndFunction

Function ClearBarcodeByItemKeyExecute(Options) Export
	If Options.ItemKeyIsChanged Then
		Return Undefined;
	Else
		Return Options.CurrentBarcode;
	EndIf;
EndFunction

#EndRegion

#Region CLEAR_SERIAL_LOT_NUMBER_BY_ITEMKEY

Function ClearSerialLotNumberByItemKeyOptions() Export
	Return GetChainLinkOptions("ItemKeyIsChanged, CurrentSerialLotNumber");
EndFunction

Function ClearSerialLotNumberByItemKeyExecute(Options) Export
	If Options.ItemKeyIsChanged Then
		Return Undefined;
	Else
		Return Options.CurrentSerialLotNumber;
	EndIf;
EndFunction

#EndRegion

#Region CHANGE_IS_SERVICE_BY_ITEMKEY

Function ChangeIsServiceByItemKeyOptions() Export
	Return GetChainLinkOptions("ItemKey");
EndFunction

Function ChangeIsServiceByItemKeyExecute(Options) Export
	Result = GetItemInfo.GetInfoByItemsKey(Options.ItemKey);
	If Result.Count() Then
		Return Result[0].IsService;
	EndIf;	
	Return False;
EndFunction

#EndRegion

#Region CHANGE_USE_SERIAL_LOT_NUMBER_BY_ITEMKEY

Function ChangeUseSerialLotNumberByItemKeyOptions() Export
	Return GetChainLinkOptions("ItemKey");
EndFunction

Function ChangeUseSerialLotNumberByItemKeyExecute(Options) Export
	Return SerialLotNumbersServer.IsItemKeyWithSerialLotNumbers(Options.ItemKey);
EndFunction

#EndRegion

#Region CHANGE_TRANSIT_ACCOUNT_BY_ACCOUNT

Function ChangeTransitAccountByAccountOptions() Export
	Return GetChainLinkOptions("TransactionType, Account, CurrentTransitAccount");
EndFunction

Function ChangeTransitAccountByAccountExecute(Options) Export
	IsCurrencyExchange = 
	Options.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CurrencyExchange")
	Or Options.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CurrencyExchange");
	
	If Not IsCurrencyExchange Then
		Return Undefined;
	EndIf;
	
	TransitAccount = ServiceSystemServer.GetObjectAttribute(Options.Account, "TransitAccount");
	
	If ValueIsFilled(TransitAccount) Then
		Return TransitAccount;
	EndIf;
	Return Options.CurrentTransitAccount;
EndFunction

#EndRegion

#Region CHANGE_RECEIPTING_ACCOUNT_BY_ACCOUNT

Function ChangeReceiptingAccountByAccountOptions() Export
	Return GetChainLinkOptions("Account, CurrentReceiptingAccount");
EndFunction

Function ChangeReceiptingAccountByAccountExecute(Options) Export
	ReceiptingAccount = ServiceSystemServer.GetObjectAttribute(Options.Account, "ReceiptingAccount");
	
	If ValueIsFilled(ReceiptingAccount) Then
		Return ReceiptingAccount;
	EndIf;
	Return Options.CurrentReceiptingAccount;
EndFunction

#EndRegion

#Region CHANGE_CASH_ACCOUNT_BY_COMPANY

Function ChangeCashAccountByCompany_CashReceiptOptions() Export
	Return GetChainLinkOptions("Company, Account, TransactionType");
EndFunction

Function ChangeCashAccountByCompany_CashReceiptExecute(Options) Export
	CashAccountType = PredefinedValue("Enum.CashAccountTypes.Cash");
	If Options.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CashIn") Then
		CashAccountType = PredefinedValue("Enum.CashAccountTypes.POSCashAccount");
	EndIf;
	Parameters = New Structure();
	Parameters.Insert("Company"     , Options.Company);
	Parameters.Insert("Account"     , Options.Account);
	Parameters.Insert("AccountType" , CashAccountType);
	Return ChangeCashAccountByCompanyExecute(Parameters);
EndFunction

Function ChangeCashAccountByCompanyOptions() Export
	Return GetChainLinkOptions("Company, Account, AccountType");
EndFunction

Function ChangeCashAccountByCompanyExecute(Options) Export
	CashAccount = DocumentsServer.GetCashAccountByCompany(Options.Company, Options.Account, Options.AccountType);
	Return CashAccount;
EndFunction

#EndRegion

#Region CHANGE_CASH_ACCOUNT_BY_CURRENCY

Function ChangeCashAccountByCurrencyOptions() Export
	Return GetChainLinkOptions("Currency, CurrentAccount");
EndFunction

Function ChangeCashAccountByCurrencyExecute(Options) Export
	AccountCurrency = ServiceSystemServer.GetObjectAttribute(Options.CurrentAccount, "Currency");
	If Options.Currency <> AccountCurrency And ValueIsFilled(AccountCurrency) Then
		Return Undefined;
	EndIf;
	Return Options.CurrentAccount;
EndFunction

#EndRegion

#Region CHANGE_CASH_ACCOUNT_BY_TRANSACTION_TYPE

Function ChangeCashAccountByTransactionTypeOptions() Export
	Return GetChainLinkOptions("TransactionType, CurrentAccount");
EndFunction

Function ChangeCashAccountByTransactionTypeExecute(Options) Export
	CurrentCashAccountType = ServiceSystemServer.GetObjectAttribute(Options.CurrentAccount, "Type");
	If CurrentCashAccountType = PredefinedValue("Enum.CashAccountTypes.Cash") 
		And Options.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CashIn") Then
			Return Undefined;
	EndIf;
	If CurrentCashAccountType = PredefinedValue("Enum.CashAccountTypes.POSCashAccount")
		And Options.TransactionType <> PredefinedValue("Enum.IncomingPaymentTransactionType.CashIn") Then
			Return Undefined;
	EndIf;
	Return Options.CurrentAccount;
EndFunction

#EndRegion

#Region CHANGE_CASH_ACCOUNT_BY_PARTNER

Function ChangeCashAccountByPartnerOptions() Export
	Return GetChainLinkOptions("Partner, LegalName, Currency, TransactionType");
EndFunction

Function ChangeCashAccountByPartnerExecute(Options) Export
	If Options.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.EmployeeCashAdvance")
	Or Options.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.EmployeeCashAdvance") Then
		Return Undefined;
	EndIf;
	
	Return DocumentsServer.GetBankAccountByPartner(Options.Partner, Options.LegalName, Options.Currency);
EndFunction

#EndRegion

#Region CHANGE_BASIS_DOCUMENT_BY_AGREEMENT

Function ChangeBasisDocumentByAgreementOptions() Export
	Return GetChainLinkOptions("Agreement, CurrentBasisDocument");
EndFunction

Function ChangeBasisDocumentByAgreementExecute(Options) Export
	If Not ValueIsFilled(Options.Agreement) Then
		Return Undefined;
	EndIf;
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(Options.Agreement);
	If AgreementInfo.ApArPostingDetail <> PredefinedValue("Enum.ApArPostingDetail.ByDocuments") Then
		Return Undefined;
	ElsIf ValueIsFilled(Options.CurrentBasisDocument)
		And Not ServiceSystemServer.GetObjectAttribute(Options.CurrentBasisDocument, "Agreement") = Options.Agreement Then
		Return Undefined;
	EndIf;
	Return Options.CurrentBasisDocument;
EndFunction

#EndRegion

#Region CHANGE_PLANNING_TRANSACTION_BASIS_BY_CURRENCY

Function ChangePlanningTransactionBasisByCurrencyOptions() Export
	Return GetChainLinkOptions("Currency, PlanningTransactionBasis");
EndFunction

Function ChangePlanningTransactionBasisByCurrencyExecute(Options) Export
	If ValueIsFilled(Options.PlanningTransactionBasis) 
			And TypeOf(Options.PlanningTransactionBasis) = Type("DocumentRef.CashTransferOrder") 
			And ServiceSystemServer.GetObjectAttribute(Options.PlanningTransactionBasis, "SendCurrency") 
			<> Options.Currency Then
				Return Undefined;
	EndIf;
	Return Options.PlanningTransactionBasis;
EndFunction

#EndRegion

#Region CHANGE_ORDER_BY_AGREEMENT

Function ChangeOrderByAgreementOptions() Export
	Return GetChainLinkOptions("Agreement, CurrentOrder");
EndFunction

Function ChangeOrderByAgreementExecute(Options) Export
	If Not ValueIsFilled(Options.Agreement) Then
		Return Undefined;
	EndIf;
	If ValueIsFilled(Options.CurrentOrder)
		And Not ServiceSystemServer.GetObjectAttribute(Options.CurrentOrder, "Agreement") = Options.Agreement Then
		Return Undefined;
	EndIf;
	Return Options.CurrentOrder;
EndFunction

#EndRegion

#Region CHANGE_MANAGER_SEGMENT_BY_PARTNER

Function ChangeManagerSegmentByPartnerOptions() Export
	Return GetChainLinkOptions("Partner");
EndFunction

Function ChangeManagerSegmentByPartnerExecute(Options) Export
	Return DocumentsServer.GetManagerSegmentByPartner(Options.Partner);
EndFunction

#EndRegion

#Region CHANGE_LEGAL_NAME_BY_PARTNER

Function ChangeLegalNameByPartnerOptions() Export
	Return GetChainLinkOptions("Partner, LegalName, TransactionType");
EndFunction

Function ChangeLegalNameByPartnerExecute(Options) Export
	If Options.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.EmployeeCashAdvance")
	Or Options.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.EmployeeCashAdvance") Then
		Return Undefined;
	EndIf;
	
	Return DocumentsServer.GetLegalNameByPartner(Options.Partner, Options.LegalName);
EndFunction

#EndRegion

#Region CHANGE_LEGAL_NAME_BY_RETAIL_CUSTOMER

Function ChangeLegalNameByRetailCustomerOptions() Export
	Return GetChainLinkOptions("RetailCustomer");
EndFunction

Function ChangeLegalNameByRetailCustomerExecute(Options) Export
	RetailCustomerInfo = CatRetailCustomersServer.GetRetailCustomerInfo(Options.RetailCustomer);
	Return RetailCustomerInfo.LegalName;
EndFunction

#EndRegion

#Region CHANGE_PARTNER_BY_LEGAL_NAME

Function ChangePartnerByLegalNameOptions() Export
	Return GetChainLinkOptions("Partner, LegalName");
EndFunction

Function ChangePartnerByLegalNameExecute(Options) Export
	If ValueIsFilled(Options.LegalName) Then
		Partner = DocumentsServer.GetPartnerByLegalName(Options.LegalName, Options.Partner);
		If ValueIsFilled(Partner) Then
			Return Partner;
		Else
			Return Options.Partner;
		EndIf;
	EndIf;
	Return Options.Partner;
EndFunction

#EndRegion

#Region CHANGE_PARTNER_BY_TRANSACTION_TYPE

Function ChangePartnerByTransactionTypeOptions() Export
	Return GetChainLinkOptions("Partner, TransactionType");
EndFunction

Function ChangePartnerByTransactionTypeExecute(Options) Export
	If Not ValueIsFilled(Options.Partner) Then
		Return Undefined;
	EndIf;
	
	PartnerType = ModelServer_V2.GetPartnerTypeByTransactionType(Options.TransactionType);
	
	If PartnerType = "Vendor" And CommonFunctionsServer.GetRefAttribute(Options.Partner, PartnerType) Then
		Return Options.Partner;
	ElsIf PartnerType = "Customer" And CommonFunctionsServer.GetRefAttribute(Options.Partner, PartnerType) Then	 
		Return Options.Partner;
	ElsIf PartnerType = "Consignor" And CommonFunctionsServer.GetRefAttribute(Options.Partner, PartnerType) Then
		Return Options.Partner;
	ElsIf PartnerType = "TradeAgent" And CommonFunctionsServer.GetRefAttribute(Options.Partner, PartnerType) Then
		Return Options.Partner;
	EndIf;
	
	Return Undefined;
EndFunction


#EndRegion

#Region CHANGE_PARTNER_BY_RETAIL_CUSTOMER

Function ChangePartnerByRetailCustomerOptions() Export
	Return GetChainLinkOptions("RetailCustomer");
EndFunction

Function ChangePartnerByRetailCustomerExecute(Options) Export
	RetailCustomerInfo = CatRetailCustomersServer.GetRetailCustomerInfo(Options.RetailCustomer);
	Return RetailCustomerInfo.Partner;
EndFunction

#EndRegion

#Region CHANGE_USE_PARTNER_TRANSACTIONS_BY_RETAIL_CUSTOMER

Function ChangeUsePartnerTransactionsByRetailCustomerOptions() Export
	Return GetChainLinkOptions("RetailCustomer");
EndFunction

Function ChangeUsePartnerTransactionsByRetailCustomerExecute(Options) Export
	RetailCustomerInfo = CatRetailCustomersServer.GetRetailCustomerInfo(Options.RetailCustomer);
	Return RetailCustomerInfo.UsePartnerTransactions;
EndFunction

#EndRegion

#Region CHANGE_AGREEMENT_BY_PARTNER

Function ChangeAgreementByPartnerOptions() Export
	Return GetChainLinkOptions("Partner, Agreement, CurrentDate, AgreementType, TransactionType");
EndFunction

Function ChangeAgreementByPartnerExecute(Options) Export
	If ValueIsFilled(Options.TransactionType) Then
		Options.AgreementType = ModelServer_V2.GetAgreementTypeByTransactionType(Options.TransactionType);
	EndIf;
	Return DocumentsServer.GetAgreementByPartner(Options);
EndFunction

#EndRegion

#Region CHANGE_AGREEMENT_BY_RETAIL_CUSTOMER

Function ChangeAgreementByRetailCustomerOptions() Export
	Return GetChainLinkOptions("RetailCustomer");
EndFunction

Function ChangeAgreementByRetailCustomerExecute(Options) Export
	RetailCustomerInfo = CatRetailCustomersServer.GetRetailCustomerInfo(Options.RetailCustomer);
	Return RetailCustomerInfo.Agreement;
EndFunction

#EndRegion

#Region CHANGE_PAYMENT_TERM_BY_AGREEMENT

Function ChangePaymentTermsByAgreementOptions() Export
	Return GetChainLinkOptions("Agreement, Date, TotalAmount, ArrayOfPaymentTerms");
EndFunction

Function ChangePaymentTermsByAgreementExecute(Options) Export
	ArrayOfPaymentTerms = CatAgreementsServer.GetAgreementPaymentTerms(Options.Agreement);
	Return _CalculatePaymentTerms(Options.Date, Options.TotalAmount, ArrayOfPaymentTerms);
EndFunction

Function UpdatePaymentTermsOptions() Export
	Return GetChainLinkOptions("Date, TotalAmount, ArrayOfPaymentTerms");
EndFunction

Function UpdatePaymentTermsExecute(Options) Export
	Return _CalculatePaymentTerms(Options.Date, Options.TotalAmount, Options.ArrayOfPaymentTerms);
EndFunction

Function _CalculatePaymentTerms(Date, TotalAmount, ArrayOfPaymentTerms)
	If Not ArrayOfPaymentTerms.Count() Then
		Return New Structure("ArrayOfPaymentTerms", ArrayOfPaymentTerms);
	EndIf;
	TotalAmount = TotalAmount;
	TotalPercent = 0;
	For Each Row In ArrayOfPaymentTerms Do
		TotalPercent = TotalPercent + Row.ProportionOfPayment;
	EndDo;
	
	PaymentTermsTotalAmount = 0;
	RowWithMaxAmount = Undefined;
	SecondsInOneDay = 86400;
	For Each Row In ArrayOfPaymentTerms Do
		Row.Date = Date + (SecondsInOneDay * Row.DuePeriod);
		Row.Amount = ?(TotalPercent = 0, 0, (TotalAmount / TotalPercent) * Row.ProportionOfPayment);
		PaymentTermsTotalAmount = PaymentTermsTotalAmount + Row.Amount;
		If RowWithMaxAmount = Undefined Then
			RowWithMaxAmount = Row;
		Else
			If Row.Amount > RowWithMaxAmount.Amount Then
				RowWithMaxAmount = Row;
			EndIf;
		EndIf;
	EndDo;
	
	If RowWithMaxAmount <> Undefined Then
		Difference = TotalAmount - PaymentTermsTotalAmount;
		RowWithMaxAmount.Amount = RowWithMaxAmount.Amount + Difference;
	EndIf;
	Return New Structure("ArrayOfPaymentTerms", ArrayOfPaymentTerms)
EndFunction

#EndRegion

#Region CHANGE_CURRENCY_BY_AGREEMENT

Function ChangeCurrencyByAgreementOptions() Export
	Return GetChainLinkOptions("Agreement, CurrentCurrency");
EndFunction

Function ChangeCurrencyByAgreementExecute(Options) Export
	If Not ValueIsFilled(Options.Agreement) Then
		Return Options.CurrentCurrency;
	EndIf;
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(Options.Agreement);
	If ValueIsFilled(AgreementInfo.Currency) Then
		Return AgreementInfo.Currency;
	EndIf;
	Return Options.CurrentCurrency;
EndFunction

#EndRegion

#Region CHANGE_LANDEDCOST_CURRENCY_BY_COMPANY

Function ChangeLandedCostCurrencyByCompanyOptions() Export
	Return GetChainLinkOptions("Company, CurrentCurrency");
EndFunction

Function ChangeLandedCostCurrencyByCompanyExecute(Options) Export
	If Not ValueIsFilled(Options.Company) Then
		Return Options.CurrentCurrency;
	EndIf;
	Currency = ModelServer_V2.GetLandedCostCurrencyByCompany(Options.Company);
	If Not ValueIsFilled(Currency) Then
		Return Options.CurrentCurrency;
	EndIf;
	Return Currency;
EndFunction

#EndRegion

#Region CHANGE_IS_FEXED_CURRENCY_BY_ACCOUNT

Function ChangeIsFixedCurrencyByAccountOptions() Export
	Return GetChainLinkOptions("Account");
EndFunction

Function ChangeIsFixedCurrencyByAccountExecute(Options) Export
	If Not ValueIsFilled(Options.Account) Then
		Return False;
	EndIf;
	Currency = ServiceSystemServer.GetObjectAttribute(Options.Account, "Currency");
	Return ValueIsFilled(Currency);
EndFunction

#EndRegion

#Region CHANGE_CURRENCY_BY_ACCOUNT

Function ChangeCurrencyByAccountOptions() Export
	Return GetChainLinkOptions("Account, CurrentCurrency");
EndFunction

Function ChangeCurrencyByAccountExecute(Options) Export
	If Not ValueIsFilled(Options.Account) Then
		Return Options.CurrentCurrency;
	EndIf;
	Currency = ServiceSystemServer.GetObjectAttribute(Options.Account, "Currency");
	If ValueIsFilled(Currency) Then
		Return Currency;
	EndIf;
	Return Options.CurrentCurrency;
EndFunction

Function DefaultCurrencyInListOptions() Export
	Return GetChainLinkOptions("CurrentCurrency, Account");
EndFunction

Function DefaultCurrencyInListExecute(Options) Export
	If Not ValueIsFilled(Options.Account) Or ValueIsFilled(Options.CurrentCurrency) Then
		Return Options.CurrentCurrency;
	EndIf;
	Currency = ServiceSystemServer.GetObjectAttribute(Options.Account, "Currency");
	If ValueIsFilled(Currency) Then
		Return Currency;
	EndIf;
	Return Options.CurrentCurrency;
EndFunction

#EndRegion

#Region CHANGE_COMPANY_BY_AGREEMENT

Function ChangeCompanyByAgreementOptions() Export
	Return GetChainLinkOptions("Agreement, CurrentCompany");
EndFunction

Function ChangeCompanyByAgreementExecute(Options) Export
	If Not ValueIsFilled(Options.Agreement) Then
		Return Options.CurrentCompany;
	EndIf;
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(Options.Agreement);
	If ValueIsFilled(AgreementInfo.Company) Then
		Return AgreementInfo.Company;
	EndIf;
	Return Options.CurrentCompany;
EndFunction

#EndRegion

#Region CHANGE_PRICE_INCLUDE_TAX_BY_AGREEMENT

Function ChangePriceIncludeTaxByAgreementOptions() Export
	Return GetChainLinkOptions("Agreement, CurrentPriceIncludeTax");
EndFunction

Function ChangePriceIncludeTaxByAgreementExecute(Options) Export
	If Not ValueIsFilled(Options.Agreement) Then
		Return Options.CurrentPriceIncludeTax;
	EndIf;
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(Options.Agreement);
	Return AgreementInfo.PriceIncludeTax;
EndFunction

#EndRegion

#Region CHANGE_PRICE_TYPE_BY_AGREEMENT

Function ChangePriceTypeByAgreementOptions() Export
	Return GetChainLinkOptions("Agreement, CurrentPriceType");
EndFunction

Function ChangePriceTypeByAgreementExecute(Options) Export
	If Not ValueIsFilled(Options.Agreement) Then
		Return Options.CurrentPriceType;
	EndIf;
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(Options.Agreement);
	Return AgreementInfo.PriceType;
EndFunction

#EndRegion

#Region CHANGE_PRICE_TYPE_AS_MANUAL

Function ChangePriceTypeAsManualOptions() Export
	Return GetChainLinkOptions("IsUserChange, IsTotalAmountChange, CurrentPriceType, DontCalculateRow");
EndFunction

Function ChangePriceTypeAsManualExecute(Options) Export
	// if TotalAmount is changed and DontCalculateRow = true  then do not need change PriceType
	If Options.DontCalculateRow = True And Options.IsTotalAmountChange = True Then
		Return Options.CurrentPriceType;
	EndIf;
	
	If Options.IsUserChange = True Or Options.IsTotalAmountChange = True Then
		Return PredefinedValue("Catalog.PriceTypes.ManualPriceType");
	Else
		Return Options.CurrentPriceType;
	EndIf;
EndFunction

#EndRegion

#Region CHANGE_PRICE_BY_PRICE_TYPE

Function ChangePriceByPriceTypeOptions() Export
	Return GetChainLinkOptions("Ref, Date, PriceType, CurrentPrice, ItemKey, Unit, Currency, RowIDInfo");
EndFunction

Function ChangePriceByPriceTypeExecute(Options) Export
	If Options.PriceType = PredefinedValue("Catalog.PriceTypes.ManualPriceType") Then
		Return Options.CurrentPrice;
	EndIf;
		
	For Each Row In Options.RowIDInfo Do
		DataFromBasis = RowIDInfoServer.GetAllDataFromBasis(Options.Ref, Row.Basis, Row.BasisKey, Row.RowID, Row.CurrentStep);
		If DataFromBasis <> Undefined And DataFromBasis.Count() And DataFromBasis[0].ItemList.Count() Then
			BasisRow = DataFromBasis[0].ItemList[0];
			PriceFromBasis = BasisRow.Price;
			UnitFactor = ModelServer_V2.GetUnitFactor(Options.Unit, BasisRow.Unit);
			Return PriceFromBasis * UnitFactor;
		EndIf;
	EndDo;
	
	Period = CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(Options.Ref, Options.Date);
	PriceParameters = New Structure();
	PriceParameters.Insert("Period"       , Period);
	PriceParameters.Insert("PriceType"    , PredefinedValue("Catalog.PriceTypes.ManualPriceType"));
	PriceParameters.Insert("RowPriceType" , Options.PriceType);
	PriceParameters.Insert("ItemKey"      , Options.ItemKey);
	PriceParameters.Insert("Unit"         , Options.Unit);
	PriceInfo = GetItemInfo.ItemPriceInfo(PriceParameters);
	If PriceInfo = Undefined Then
		Return 0;
	EndIf;
	
	Price = ModelServer_V2.ConvertPriceByCurrency(Period, Options.PriceType, Options.Currency, PriceInfo.Price);
	
	Return Price;
EndFunction

#EndRegion

#Region CHANGE_STORE_BY_AGREEMENT

Function ChangeStoreByAgreementOptions() Export
	Return GetChainLinkOptions("Agreement, CurrentStore");
EndFunction

Function ChangeStoreByAgreementExecute(Options) Export
	If Not ValueIsFilled(Options.Agreement) Then
		Return Options.CurrentStore;
	EndIf;
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(Options.Agreement);
	If ValueIsFilled(AgreementInfo.Store)  Then
		Return AgreementInfo.Store;
	EndIf;
	Return Options.CurrentStore;
EndFunction

#EndRegion

#Region CHANGE_DELIVERY_DATE_BY_AGREEMENT

Function ChangeDeliveryDateByAgreementOptions() Export
	Return GetChainLinkOptions("Agreement, CurrentDeliveryDate");
EndFunction

Function ChangeDeliveryDateByAgreementExecute(Options) Export
	If Not ValueIsFilled(Options.Agreement) Then
		Return Options.CurrentDeliveryDate;
	EndIf;
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(Options.Agreement);
	If ValueIsFilled(AgreementInfo.DeliveryDate)  Then
		Return AgreementInfo.DeliveryDate;
	EndIf;
	Return Options.CurrentDeliveryDate;
EndFunction

#EndRegion

#Region CHANGE_TRADE_AGENT_FEE_TYPE_BY_AGREEMENT

Function ChangeTradeAgentFeeTypeByAgreementOptions() Export
	Return GetChainLinkOptions("Agreement, CurrentFeeType");
EndFunction

Function ChangeTradeAgentFeeTypeByAgreementExecute(Options) Export
	If Not ValueIsFilled(Options.Agreement) Then
		Return Options.CurrentFeeType;
	EndIf;
	
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(Options.Agreement);
		
	If ValueIsFilled(AgreementInfo.TradeAgentFeeType)  Then
		Return AgreementInfo.TradeAgentFeeType;
	EndIf;
	
	Return Options.CurrentFeeType;
EndFunction
#EndRegion

#Region CHANGE_TRADE_AGENT_FEE_PERCENT_BY_AGREEMENT

Function ChangeTradeAgentFeePercentByAgreementOptions() Export
	Return GetChainLinkOptions("Agreement, FeeType, CurrentPercent");
EndFunction

Function ChangeTradeAgentFeePercentByAgreementExecute(Options) Export
	If Options.FeeType <> PredefinedValue("Enum.TradeAgentFeeTypes.Percent") Then
		Return 0;
	EndIf;
	
	If Not ValueIsFilled(Options.Agreement) Then
		Return Options.CurrentPercent;
	EndIf;
	
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(Options.Agreement);
		
	If ValueIsFilled(AgreementInfo.TradeAgentFeePercent)  Then
		Return AgreementInfo.TradeAgentFeePercent;
	EndIf;
	
	Return Options.CurrentPercent;
EndFunction

#EndRegion

#Region CHANGE_TRADE_AGENT_FEE_PERCENT_BY_AMOUNT

Function ChangeTradeAgentFeePercentByAmountOptions() Export
	Return GetChainLinkOptions("FeeType, FeeAmount, TotalAmount");
EndFunction

Function ChangeTradeAgentFeePercentByAmountExecute(Options) Export
	If Options.FeeType <> PredefinedValue("Enum.TradeAgentFeeTypes.Percent") Then
		Return 0;
	EndIf;
	
	_TotalAmount    = ?(ValueIsFilled(Options.TotalAmount)   , Options.TotalAmount   , 0);
	_FeeAmount      = ?(ValueIsFilled(Options.FeeAmount)     , Options.FeeAmount     , 0);
	
	If (_TotalAmount / 100) <> 0 Then
		Return _FeeAmount / (_TotalAmount / 100);
	EndIf;
	
	Return 0;
EndFunction

#EndRegion

#Region CHANGE_TRADE_AGENT_FEE_AMOUNT_BY_TRADE_AGENT_FEE_TYPE

Function ChangeTradeAgentFeeAmountByTradeAgentFeeTypeOptions() Export
	Return GetChainLinkOptions("Price, ConsignorPrice, Quantity, Percent, TotalAmount, FeeType");
EndFunction

Function ChangeTradeAgentFeeAmountByTradeAgentFeeTypeExecute(Options) Export
	_Price          = ?(ValueIsFilled(Options.Price)         , Options.Price         , 0);
	_ConsignorPrice = ?(ValueIsFilled(Options.ConsignorPrice), Options.ConsignorPrice, 0);
	_Quantity       = ?(ValueIsFilled(Options.Quantity)      , Options.Quantity      , 0);
	_TotalAmount    = ?(ValueIsFilled(Options.TotalAmount)   , Options.TotalAmount   , 0);
	_Percent        = ?(ValueIsFilled(Options.Percent)       , Options.Percent       , 0);
	
	If Options.FeeType = PredefinedValue("Enum.TradeAgentFeeTypes.DifferencePriceConsignorPrice") Then
		Return (_Price - _ConsignorPrice) * _Quantity;
	ElsIf Options.FeeType = PredefinedValue("Enum.TradeAgentFeeTypes.Percent") Then
		Return (_TotalAmount / 100) * _Percent;
	Else
		Return 0;
	EndIf;
EndFunction

#EndRegion

#Region CHANGE_EXPENSE_TYPE_BY_ITEMKEY

Function ChangeExpenseTypeByItemKeyOptions() Export
	Return GetChainLinkOptions("Company, ItemKey");
EndFunction

Function ChangeExpenseTypeByItemKeyExecute(Options) Export
	Return CatExpenseAndRevenueTypesServer.GetExpenseType(Options.Company, Options.ItemKey);
EndFunction

#EndRegion

#Region CHANGE_REVENUE_TYPE_BY_ITEMKEY

Function ChangeRevenueTypeByItemKeyOptions() Export
	Return GetChainLinkOptions("Company, ItemKey");
EndFunction

Function ChangeRevenueTypeByItemKeyExecute(Options) Export
	Return CatExpenseAndRevenueTypesServer.GetRevenueType(Options.Company, Options.ItemKey);
EndFunction

#EndRegion

#Region CHANGE_ITEM_BY_PARTNER_ITEM

Function ChangeItemByPartnerItemOptions() Export
	Return GetChainLinkOptions("PartnerItem");
EndFunction

Function ChangeItemByPartnerItemExecute(Options) Export
	Return DocumentsServer.GetItemAndItemKeyByPartnerItem(Options.PartnerItem);
EndFunction

#EndRegion

#Region CHANGE_PROCUREMENT_METHOD_BY_ITEM_KEY

Function ChangeProcurementMethodByItemKeyOptions() Export
	Return GetChainLinkOptions("ProcurementMethod, ItemKey, IsService");
EndFunction

Function ChangeProcurementMethodByItemKeyExecute(Options) Export
	If Options.IsService = True Then
		Return Undefined;
	EndIf;
	If ValueIsFilled(Options.ProcurementMethod) Then
		Return Options.ProcurementMethod;
	EndIf;
	If CatItemsServer.StoreMustHave(Options.ItemKey) Then
		Return PredefinedValue("Enum.ProcurementMethods.Stock");
	EndIf;
	Return PredefinedValue("Enum.ProcurementMethods.EmptyRef");
EndFunction

#EndRegion

#Region CHANGE_RECEIVE_AMOUNT_BY_SEND_AMOUNT

Function ChangeReceiveAmountBySendAmountOptions() Export
	Return GetChainLinkOptions("SendAmount, ReceiveAmount, SendCurrency, ReceiveCurrency");
EndFunction

Function ChangeReceiveAmountBySendAmountExecute(Options) Export
	If ValueIsFilled(Options.SendCurrency) And ValueIsFilled(Options.ReceiveCurrency) 
		And Options.SendCurrency = Options.ReceiveCurrency Then
		Return Options.SendAmount;
	Else
		Return Options.ReceiveAmount;
	EndIf;
EndFunction

#EndRegion

#Region CHANGE_STATUS_BY_CHEQUE

Function ChangeStatusByChequeOptions() Export
	Return GetChainLinkOptions("Ref, Cheque");
EndFunction

Function ChangeStatusByChequeExecute(Options) Export
	Return DocChequeBondTransactionServer.GetChequeInfo(Options.Ref, Options.Cheque);
EndFunction

#EndRegion

#Region CHANGE_AP_AR_POSTING_DETAIL_BY_AGREEMENT 

Function ChangeApArPostingDetailByAgreementOptions() Export
	Return GetChainLinkOptions("Agreement");
EndFunction

Function ChangeApArPostingDetailByAgreementExecute(Options) Export
	If Not ValueIsFilled(Options.Agreement) Then
		Return Undefined;
	EndIf;
	Return ServiceSystemServer.GetObjectAttribute(Options.Agreement, "ApArPostingDetail");
EndFunction

#EndRegion

#Region CHANGE_CONSOLIDATED_RETAIL_SALES_BY_WORKSTATION

Function ChangeConsolidatedRetailSalesByWorkstationOptions() Export
	Return GetChainLinkOptions("Company, Branch, Workstation");
EndFunction

Function ChangeConsolidatedRetailSalesByWorkstationExecute(Options) Export
	Return DocConsolidatedRetailSalesServer.GetDocument(Options.Company, Options.Branch, Options.Workstation);
EndFunction

#EndRegion

#Region CHANGE_CONSOLIDATED_RETAIL_SALES_BY_WORKSTATION_FOR_RETURN

Function ChangeConsolidatedRetailSalesByWorkstationForReturnOptions() Export
	Return GetChainLinkOptions("Company, Branch, Workstation, Date, SalesDocuments");
EndFunction

Function ChangeConsolidatedRetailSalesByWorkstationForReturnExecute(Options) Export
	SalesReturnData = New Structure();
	SalesReturnData.Insert("Date", Options.Date);
	SalesReturnData.Insert("ArrayOfSalesDocuments", Options.SalesDocuments);
	UseConsolidatedSales = DocConsolidatedRetailSalesServer.UseConsolidatedRetailSales(Options.Branch, SalesReturnData);
	If Not UseConsolidatedSales Then
		Return Undefined;
	EndIf;
	Return DocConsolidatedRetailSalesServer.GetDocument(Options.Company, Options.Branch, Options.Workstation);
EndFunction

#EndRegion

#Region CHANGE_IS_MANUAL_CHANGED_BY_ITEM_KEY

Function ChangeIsManualChangedByItemKeyOptions() Export
	Return GetChainLinkOptions("ItemKeyBOM, ItemKey, QuantityInBaseUnitBOM, QuantityInBaseUnit");
EndFunction

Function ChangeIsManualChangedByItemKeyExecute(Options) Export
	If Not ValueIsFilled(Options.ItemKeyBOM) Or Not ValueIsFilled(Options.ItemKey) Then
		Return False;
	EndIf;
	
	Return Options.ItemKey <> Options.ItemKeyBOM Or Options.QuantityInBaseUnit <> Options.QuantityInBaseUnitBOM; 
EndFunction

#EndRegion

#Region CHANGE_IS_MANUAL_CHANGED_BY_QUANTITY

Function ChangeIsManualChangedByQuantityOptions() Export
	Return GetChainLinkOptions("Quantity, QuantityBOM");
EndFunction

Function ChangeIsManualChangedByQuantityExecute(Options) Export	
	If Options.Quantity = Options.QuantityBOM Then
		Return False;
	Else
		Return True;
	EndIf;
EndFunction

#EndRegion

#Region CHANGE_UNIQUE_ID_BY_ITEM_KEY_BOM_AND_BILL_OF_MATERIALS

Function ChangeUniqueIDByItemKeyBOMAndBillOfMaterialsOptions() Export
	Return GetChainLinkOptions("ItemKeyBOM, BillOfMaterials");
EndFunction

Function ChangeUniqueIDByItemKeyBOMAndBillOfMaterialsExecute(Options) Export
	If Not ValueIsFilled(Options.ItemKeyBOM) Or Not ValueIsFilled(Options.BillOfMaterials) Then
		Return "";
	EndIf;
	Return String(Options.ItemKeyBOM.UUID()) + "-" + String(Options.BillOfMaterials.UUID()); 
EndFunction

#EndRegion

#Region CHANGE_STORE_BY_COST_WRITE_OFF

Function ChangeStoreByCostWriteOffOptions() Export
	Return GetChainLinkOptions("CostWriteOff, BillOfMaterials, CurrentStore");
EndFunction

Function ChangeStoreByCostWriteOffExecute(Options) Export
	If Options.CostWriteOff = PredefinedValue("Enum.MaterialsCostWriteOff.NotInclude") Then
		Return Undefined;
	EndIf;
	
	If ValueIsFilled(Options.CurrentStore) Then
		Return Options.CurrentStore;
	EndIf;
	
	Return CommonFunctionsServer.GetRefAttribute(Options.BillOfMaterials, "BusinessUnit.MaterialStore");
EndFunction

#EndRegion

#Region CHANGE_PROFIT_LOSS_CENTER_BY_BILL_OF_MATERIALS

Function ChangeProfitLossCenterByBillOfMaterialsOptions() Export
	Return GetChainLinkOptions("BillOfMaterials, CurrentProfitLossCenter");
EndFunction

Function ChangeProfitLossCenterByBillOfMaterialsExecute(Options) Export
	If ValueIsFilled(Options.CurrentProfitLossCenter) Then
		Return Options.CurrentProfitLossCenter;
	EndIf;
	
	Return CommonFunctionsServer.GetRefAttribute(Options.BillOfMaterials, "BusinessUnit");
EndFunction
		

#EndRegion

#Region CHANGE_EXPENSE_TYPE_BY_BILL_OF_MATERIALS

Function ChangeExpenseTypeByBillOfMaterialsOptions() Export
	Return GetChainLinkOptions("ItemKeyBOM, BillOfMaterials, CurrentExpenseType");
EndFunction

Function ChangeExpenseTypeByBillOfMaterialsExecute(Options) Export
	If ValueIsFilled(Options.CurrentExpenseType) Then
		Return Options.CurrentExpenseType;
	EndIf;
	
	Return ModelServer_V2.GetExpenseTypeByBillOfMaterials(Options.BillOfMaterials, Options.ItemKeyBOM);
EndFunction

#EndRegion

#Region CHANGE_PLANNING_PERIOD_BY_DATE_AND_BUSINESS_UNIT

Function ChangePlanningPeriodByDateAndBusinessUnitOptions() Export
	Return GetChainLinkOptions("Date, BusinessUnit");
EndFunction

Function ChangePlanningPeriodByDateAndBusinessUnitExecute(Options) Export
	_Date = ?(ValueIsFilled(Options.Date), Options.Date, CommonFunctionsServer.GetCurrentSessionDate());
	PlanningPeriod = ModelServer_V2.GetPlanningPeriod(_Date, Options.BusinessUnit);
	Return PlanningPeriod;
EndFunction

#EndRegion

#Region CHANGE_PRODUCTION_PLANNING_BY_PLANNING_PERIOD

Function ChangeProductionPlanningByPlanningPeriodOptions() Export
	Return GetChainLinkOptions("Company, BusinessUnit, PlanningPeriod, CurrentProductionPlanning");
EndFunction

Function ChangeProductionPlanningByPlanningPeriodExecute(Options) Export
	If ValueIsFilled(Options.CurrentProductionPlanning) Then
		Return Options.CurrentProductionPlanning;
	EndIf;
	Return ModelServer_V2.GetDocumentProductionPlanning(Options.Company, Options.BusinessUnit, Options.PlanningPeriod);
EndFunction

#EndRegion

#Region CHANGE_BILL_OF_MATERIALS_BY_ITEM_KEY		

Function ChangeBillOfMaterialsByItemKeyOptions() Export
	Return GetChainLinkOptions("ItemKey, CurrentBillOfMaterials");
EndFunction

Function ChangeBillOfMaterialsByItemKeyExecute(Options) Export
	If ValueIsFilled(Options.CurrentBillOfMaterials) Then
		Return Options.CurrentBillOfMaterials;
	EndIf;
	Return ModelServer_V2.GetBillOfMaterialsByItemKey(Options.ItemKey);
EndFunction

#EndRegion

#Region CHANGE_COST_MULTIPLIERRATIO_BY_BILL_OF_MATERIALS		

Function ChangeCostMultiplierRatioByBillOfMaterialsOptions() Export
	Return GetChainLinkOptions("BillOfMaterials");
EndFunction

Function ChangeCostMultiplierRatioByBillOfMaterialsExecute(Options) Export
	If Not ValueIsFilled(Options.BillOfMaterials) Then
		Return 0;
	EndIf;
	
	Return CommonFunctionsServer.GetRefAttribute(Options.BillOfMaterials, "CostMultiplierRatio");
EndFunction

#EndRegion

#Region CHANGE_DURATION_OF_PRODUCTION_BY_BILL_OF_MATERIALS		

Function ChangeDurationOfProductionByBillOfMaterialsOptions() Export
	Return GetChainLinkOptions("BillOfMaterials, ItemKey, Unit, Quantity, CurrentDurationOfProduction");
EndFunction

Function ChangeDurationOfProductionByBillOfMaterialsExecute(Options) Export
	Return ManufacturingServer.GetDurationOfProductionByBillOfMaterials(Options.BillOfMaterials, 
		Options.ItemKey, 
		Options.Unit,
		Options.Quantity,
		Options.CurrentDurationOfProduction);
EndFunction

#EndRegion

#Region CHANGE_CURRENT_QUANTITY_IN_PRODUCTIONS

Function ChangeCurrentQuantityInProductionsOptions() Export
	Return GetChainLinkOptions("Company, ProductionPlanning, PlanningPeriod, BillOfMaterials, ItemKey, Unit");
EndFunction

Function ChangeCurrentQuantityInProductionsExecute(Options) Export
	Result = New Structure();
	Result.Insert("Unit", Options.Unit);
	Result.Insert("CurrentQuantity", 0);
	
	CurrentQuantityInfo = ModelServer_V2.GetCurrentQuantity(Options.Company,
											 Options.ProductionPlanning, 
											 Options.PlanningPeriod, 
											 Options.BillOfMaterials,
											 Options.ItemKey);
											 
	If ValueIsFilled(CurrentQuantityInfo.BasisQuantity) Then
		Result.Unit = CurrentQuantityInfo.BasisUnit;
	EndIf;
	Result.CurrentQuantity = CurrentQuantityInfo.BasisQuantity;
	Return Result;	
EndFunction

#EndRegion

#Region CALCULATE_DIFFERENCE

Function CalculateDifferenceCountOptions() Export
	Return GetChainLinkOptions("PhysCount, ExpCount, ManualFixedCount");
EndFunction

Function CalculateDifferenceCountExecute(Options) Export
	Return Options.PhysCount - Options.ExpCount + Options.ManualFixedCount;
EndFunction

#EndRegion

#Region DELIVERY_DATE

Function DefaultDeliveryDateInHeaderOptions() Export
	Return GetChainLinkOptions("ArrayOfDeliveryDateInList, Date, Agreement");
EndFunction

// fill DeliveryDate in document header by default
Function DefaultDeliveryDateInHeaderExecute(Options) Export
	ArrayOfDeliveryDateUnique = New Array();
	For Each DeliveryDate In Options.ArrayOfDeliveryDateInList Do
		If ValueIsFilled(DeliveryDate) And ArrayOfDeliveryDateUnique.Find(DeliveryDate) = Undefined Then
			ArrayOfDeliveryDateUnique.Add(DeliveryDate);
		EndIf;
	EndDo;
	If ArrayOfDeliveryDateUnique.Count() = 1 Then
		Return ArrayOfDeliveryDateUnique[0];
	ElsIf ArrayOfDeliveryDateUnique.Count() > 1 Then
		Return Undefined;
	EndIf;
	
	If ValueIsFilled(Options.Agreement) Then
		AgreementInfo = CatAgreementsServer.GetAgreementInfo(Options.Agreement);
		DeliveryDateInAgreement = AgreementInfo.DeliveryDate;
		If ValueIsFilled(DeliveryDateInAgreement) Then
			Return DeliveryDateInAgreement;
		EndIf;
	EndIf;
	Return Undefined;
EndFunction

Function DefaultDeliveryDateInListOptions() Export
	Return GetChainLinkOptions("DeliveryDateInList, DeliveryDateInHeader, Date, Agreement");
EndFunction

Function DefaultDeliveryDateInListExecute(Options) Export
	If ValueIsFilled(Options.DeliveryDateInList) Then
		Return Options.DeliveryDateInList;
	EndIf;
	
	If ValueIsFilled(Options.DeliveryDateInHeader) Then
		Return Options.DeliveryDateInHeader;
	EndIf;
	
	If ValueIsFilled(Options.Agreement) Then
		AgreementInfo = CatAgreementsServer.GetAgreementInfo(Options.Agreement);
		DeliveryDateInAgreement = AgreementInfo.DeliveryDate;
		If ValueIsFilled(DeliveryDateInAgreement) Then
			Return DeliveryDateInAgreement;
		EndIf;
	EndIf;

	Return Undefined;
EndFunction

Function FillDeliveryDateInListOptions() Export
	Return GetChainLinkOptions("DeliveryDate, DeliveryDateInList");
EndFunction

Function FillDeliveryDateInListExecute(Options) Export
	If ValueIsFilled(Options.DeliveryDate) Then
		Return Options.DeliveryDate;
	EndIf;
	Return Options.DeliveryDateInList;
EndFunction

Function ChangeDeliveryDateInHeaderByDeliveryDateInListOptions() Export
	Return GetChainLinkOptions("ArrayOfDeliveryDateInList");
EndFunction

// change DeliveryDate in document header, dependencies of tabular part ItemList.DeliveryDate
// if in tabular part ItemList have different DeliveryDate then in document header DeliveryDate = Undefined
// if in tabular part ItemList have only one DeliveryDate then in document header DeliveryDate = ItemList.DeliveryDate
Function ChangeDeliveryDateInHeaderByDeliveryDateInListExecute(Options) Export
	// create array of DeliveryDate with unique values
	ArrayOfDeliveryDateUnique = New Array();
	For Each DeliveryDate In Options.ArrayOfDeliveryDateInList Do
		If ArrayOfDeliveryDateUnique.Find(DeliveryDate) = Undefined Then
			ArrayOfDeliveryDateUnique.Add(DeliveryDate);
		EndIf;
	EndDo;
	If ArrayOfDeliveryDateUnique.Count() = 1 Then
		Return ArrayOfDeliveryDateUnique[0];
	Else
		Return Undefined;
	EndIf;
EndFunction

#EndRegion

#Region STORE

Function EmptyStoreInHeaderOptions() Export
	Return GetChainLinkOptions("DocumentRef, ArrayOfStoresInList, Agreement");
EndFunction

// fill store in document header when is clear field
Function EmptyStoreInHeaderExecute(Options) Export
	// fill store from Agreement or UserSettings
	If ValueIsFilled(Options.Agreement) Then
		StoreInAgreement = Options.Agreement.Store;
		If ValueIsFilled(StoreInAgreement) Then
			Return StoreInAgreement; // store from Agreement
		EndIf;
	EndIf;
	
	UserSettings = UserSettingsServer.GetUserSettingsForClientModule(Options.DocumentRef);
	For Each Setting In UserSettings Do
		If Setting.AttributeName = "ItemList.Store" Then
			Return Setting.Value; // store from UserSettings
		EndIf;
	EndDo;
	
	Return Undefined;
EndFunction

Function DefaultStoreInHeaderOptions() Export
	Return GetChainLinkOptions("DocumentRef, ArrayOfStoresInList, Agreement");
EndFunction

// fill store in document header by defult
Function DefaultStoreInHeaderExecute(Options) Export
	ArrayOfStoresUnique = New Array();
	For Each Store In Options.ArrayOfStoresInList Do
		If ValueIsFilled(Store) And ArrayOfStoresUnique.Find(Store) = Undefined Then
			ArrayOfStoresUnique.Add(Store);
		EndIf;
	EndDo;
	If ArrayOfStoresUnique.Count() = 1 Then
		Return ArrayOfStoresUnique[0]; // in tabular part only one store
	ElsIf ArrayOfStoresUnique.Count() > 1 Then
		Return Undefined; // in tabular part several different stores
	EndIf;
	
	// when tabular part is empty then fill store from Agreement or UserSettings
	
	If ValueIsFilled(Options.Agreement) Then
		StoreInAgreement = Options.Agreement.Store;
		If ValueIsFilled(StoreInAgreement) Then
			Return StoreInAgreement; // store from Agreement
		EndIf;
	EndIf;
	
	UserSettings = UserSettingsServer.GetUserSettingsForClientModule(Options.DocumentRef);
	For Each Setting In UserSettings Do
		If Setting.AttributeName = "ItemList.Store" Then
			Return Setting.Value; // store from UserSettings
		EndIf;
	EndDo;
	
	Return Undefined;
EndFunction

Function DefaultStoreInListOptions() Export
	Return GetChainLinkOptions("StoreFromUserSettings, StoreInList, StoreInHeader, Agreement, StoreInPreviousRow, IsService");
EndFunction

// fill store in tabular part ItemList by default
Function DefaultStoreInListExecute(Options) Export
	If Options.IsService = True Then
		Return Undefined;
	EndIf;
	If ValueIsFilled(Options.StoreInList) Then
		Return Options.StoreInList; // store already is filled
	EndIf;
	
	If ValueIsFilled(Options.StoreInHeader) Then
		Return Options.StoreInHeader; // store for document header
	EndIf;
	
	If ValueIsFilled(Options.StoreInPreviousRow) Then
		Return Options.StoreInPreviousRow; // store from previous row
	EndIf;
	
	If ValueIsFilled(Options.Agreement) Then
		StoreInAgreement = Options.Agreement.Store;
		If ValueIsFilled(StoreInAgreement) Then
			Return StoreInAgreement; // store from Agreement
		EndIf;
	EndIf;
	
	Return Options.StoreFromUserSettings; // store from UserSettings
EndFunction

Function ChangeUseShipmentConfirmationByStoreOptions() Export
	Return GetChainLinkOptions("Store, ItemKey");
EndFunction

// set value true\false in UseShipmentConfirmation 
Function ChangeUseShipmentConfirmationByStoreExecute(Options) Export
	Return ChangeOrderSchemeByStore(Options, "UseShipmentConfirmation");
EndFunction

Function ChangeUseGoodsReceiptByStoreOptions() Export
	Return GetChainLinkOptions("Store, ItemKey");
EndFunction

// set value true\false in UseGoodsReceipt
Function ChangeUseGoodsReceiptByStoreExecute(Options) Export
	Return ChangeOrderSchemeByStore(Options, "UseGoodsReceipt");
EndFunction

Function ChangeOrderSchemeByStore(Options, ReceiptShipment)
	If Not ValueIsFilled(Options.Store) Then
		Return False;
	EndIf;
	StoreInfo = DocumentsServer.GetStoreInfo(Options.Store, Options.ItemKey);
	If ValueIsFilled(Options.ItemKey) Then
		Return Not StoreInfo.IsService And StoreInfo[ReceiptShipment];
	EndIf;
	Return StoreInfo[ReceiptShipment];
EndFunction

Function ChangeUseGoodsReceiptByUseShipmentConfirmationOptions() Export
	Return GetChainLinkOptions("UseShipmentConfirmation, UseGoodsReceipt, StoreSender, StoreReceiver, ShowUserMessage");
EndFunction

Function ChangeUseGoodsReceiptByUseShipmentConfirmationExecute(Options) Export
	If Options.UseShipmentConfirmation 
		And Not Options.UseGoodsReceipt 
		And ValueIsFilled(Options.StoreSender) 
		And ValueIsFilled(Options.StoreReceiver) Then
		Options.ShowUserMessage = True;
		Return True;
	Else
		Return Options.UseGoodsReceipt;
	EndIf;
EndFunction

Function FillStoresInListOptions() Export
	Return GetChainLinkOptions("Store, StoreInList, IsUserChange, IsService");
EndFunction

// fill Store in tabular part, if Store is not filled do not change store in ItemList
Function FillStoresInListExecute(Options) Export
	If Options.IsService = True Then
		Return Undefined;
	EndIf;
	If Options.IsUserChange = True Then
		Return Options.Store;
	EndIf;
	If ValueIsFilled(Options.Store) Then
		Return Options.Store;
	EndIf;
	Return Options.StoreInList;
EndFunction

Function ChangeStoreInHeaderByStoresInListOptions() Export
	Return GetChainLinkOptions("ArrayOfStoresInList");
EndFunction

// change Store in document header, dependencies of tabular part ItemList.Store
// if in tabular part ItemList have different stores then in document header Store = Undefined
// if in tabular part ItemList have only one store then in document header Store = ItemList.Store
Function ChangeStoreInHeaderByStoresInListExecute(Options) Export
	// create array of stores with unique values
	ArrayOfStoresUnique = New Array();
	For Each Row In Options.ArrayOfStoresInList Do
		If Row.IsService Then
			Continue;
		EndIf;
		
		If ArrayOfStoresUnique.Find(Row.Store) = Undefined Then
			ArrayOfStoresUnique.Add(Row.Store);
		EndIf;
	EndDo;
	If ArrayOfStoresUnique.Count() = 1 Then
		Return ArrayOfStoresUnique[0];
	Else
		Return Undefined;
	EndIf;
EndFunction
	
#EndRegion

#Region CONVERT_QUANTITY_TO_QUANTITY_IN_BASE_UNIT

Function CovertQuantityToQuantityInBaseUnitOptions() Export
	Return GetChainLinkOptions("Bundle, Unit, Quantity");
EndFunction

Function CovertQuantityToQuantityInBaseUnitExecute(Options) Export
	Return ModelServer_V2.ConvertQuantityToQuantityInBaseUnit(Options.Bundle, Options.Unit, Options.Quantity);
EndFunction

#EndRegion

#Region TAXES

Function ChangeTaxAmountAsManualAmountOptions() Export
	Return GetChainLinkOptions("TaxAmount, TaxList");
EndFunction

Function ChangeTaxAmountAsManualAmountExecute(Options) Export
	For Each Row In Options.TaxList Do
		Row.ManualAmount = Options.TaxAmount;
	EndDo;
	Return Options.TaxAmount;
EndFunction

// TaxesCache - XML string from form attribute
Function RequireCallCreateTaxesFormControlsOptions() Export
	Return GetChainLinkOptions("Ref, Date, Company, TransactionType, ArrayOfTaxInfo, FormTaxColumnsExists");
EndFunction

// return true if need create form controls for taxes
Function RequireCallCreateTaxesFormControlsExecute(Options) Export
	If Not Options.FormTaxColumnsExists = True Then
		Return True; // controls is not created yet
	EndIf;
	If Not Options.ArrayOfTaxInfo.Count() Then
		Return True; // cache is empty
	EndIf;
	// compares required taxes and taxes in cache, if they match return false
	TaxesInCache = New Array();
	For Each TaxInfo In Options.ArrayOfTaxInfo Do
		TaxesInCache.Add(TaxInfo.Tax);
	EndDo;
	
	DocumentName = Options.Ref.Metadata().Name;
	RequiredTaxes = TaxesServer.GetRequiredTaxesForDocument(Options.Date, Options.Company, DocumentName, Options.TransactionType);
	
	For Each Tax In RequiredTaxes Do
		If TaxesInCache.Find(Tax) = Undefined Then
			Return True; // not all required taxes in cache
		EndIf;
	EndDo;
	For Each Tax In TaxesInCache Do
		If RequiredTaxes.Find(Tax) = Undefined Then
			Return True; // extra taxes in cache
		EndIf;
	EndDo;
	Return False; // full match cache and required taxes
EndFunction

Function ChangeTaxRateOptions() Export
	Return GetChainLinkOptions("Date, Company, TransactionType, Agreement, ItemKey, InventoryOrigin, ConsignorBatches, TaxRates, ArrayOfTaxInfo, Ref, IsBasedOn, TaxList");
EndFunction

Function ChangeTaxRateExecute(Options) Export
	Result = New Structure();
	For Each TaxRate In Options.TaxRates Do
		Result.Insert(TaxRate.Key, TaxRate.Value);
	EndDo;
	
	// when BasedOn = True and TaxList is filled, do not recalculate
	// tax rates get from TaxList 
	If Options.IsBasedOn = True And Options.TaxList.Count() Then
		For Each KeyValue In Result Do
			TaxRef = Undefined;
			For Each RowInfo In Options.ArrayOfTaxInfo Do
				If KeyValue.Key = RowInfo.Name Then
					TaxRef = RowInfo.Tax;
					Break;
				EndIf;
			EndDo;
			If TaxRef = Undefined Then
				Result[KeyValue.Key] = Undefined;
				Continue;
			EndIf;
			TaxRateValue = Undefined;
			For Each RowTaxList In Options.TaxList Do
				If RowTaxList.Tax = TaxRef Then
						TaxRateValue = RowTaxList.TaxRate;
					Break;
				EndIf;
			EndDo;
			Result[KeyValue.Key] = TaxRateValue;
		EndDo;
		Return Result;
	EndIf;
		
	// taxes when have in company by document date
	DocumentName = Options.Ref.Metadata().Name;
	RequiredTaxes = TaxesServer.GetRequiredTaxesForDocument(Options.Date, Options.Company, DocumentName, Options.TransactionType);
	
	For Each ItemOfTaxInfo In Options.ArrayOfTaxInfo Do
		If ItemOfTaxInfo.Type <> PredefinedValue("Enum.TaxType.Rate") Then
			Continue;
		EndIf;
		
		
		
		// If tax is not taken into account by company, then clear tax rate TaxRate = Undefined
		If RequiredTaxes.Find(ItemOfTaxInfo.Tax) = Undefined Then
			Result.Insert(ItemOfTaxInfo.Name, Undefined);
			Continue;
		EndIf;
				
		// Tax rate from consignor batch
		If ValueIsFilled(Options.InventoryOrigin) 
			And Options.InventoryOrigin = PredefinedValue("Enum.InventoryOriginTypes.ConsignorStocks")
			And Options.ConsignorBatches.Count() Then
			
			Parameters = New Structure();
			Parameters = New Structure();
			Parameters.Insert("Date"      , Options.Date);
			Parameters.Insert("ConsignorBatches", Options.ConsignorBatches);
			Parameters.Insert("Tax"       , ItemOfTaxInfo.Tax);
			TaxRate = TaxesServer.GetTaxRateByConsignorBatch(Parameters);			
			Result.Insert(ItemOfTaxInfo.Name, TaxRate);
			Continue;
		EndIf;
		
		Parameters = New Structure();
		Parameters.Insert("Date"    , Options.Date);
		Parameters.Insert("Company" , Options.Company);
		Parameters.Insert("Tax"     , ItemOfTaxInfo.Tax);
		Parameters.Insert("ItemKey"         , Options.ItemKey);
		Parameters.Insert("Agreement"       , Options.Agreement);
		Parameters.Insert("TransactionType" , Options.TransactionType);
			
		TaxRate = TaxesServer.GetTaxRateByPriority(Parameters);
		Result.Insert(ItemOfTaxInfo.Name, TaxRate);
	EndDo;
		
	Return Result;
EndFunction

#EndRegion

#Region CONSIGNOR_BATCHES

Function ConsignorBatchesFillBatchesOptions() Export
	Return GetChainLinkOptions("DocObject, Table_ItemList, Table_SerialLotNumbers, Table_SourceOfOrigins, Table_ConsignorBatches, SilentMode");
EndFunction

Function ConsignorBatchesFillBatchesExecute(Options) Export
	SilentMode = False;
	If Options.SilentMode = True Then
		SilentMode = True;
	EndIf;
	
	SourceOfOrigins = SourceOfOriginServer.CalculateSourceOfOriginsTable(Options.Table_ItemList, 
		Options.Table_SerialLotNumbers, 
		Options.Table_SourceOfOrigins);
	
	ConsignorBatches = CommissionTradeServer.GetConsignorBatchesTable(Options.DocObject, 
		Options.Table_ItemList, 
		Options.Table_SerialLotNumbers, 
		SourceOfOrigins, 
		Options.Table_ConsignorBatches, 
		SilentMode);
	Return New Structure("ConsignorBatches", ConsignorBatches);	
EndFunction

#EndRegion

#Region BILL_OF_MATERIALS_CALCULATIONS

Function BillOfMaterialsListCalculationsOptions() Export
	Return GetChainLinkOptions("BillOfMaterialsList, BillOfMaterialsListColumns,
		|Company, BillOfMaterials, PlanningPeriod, ItemKey, Unit, Quantity");
EndFunction

Function BillOfMaterialsListCalculationsExecute(Options) Export
	Result = New Structure();
	Result.Insert("BillOfMaterialsList", New Array());
	
	CalculationParameters = New Structure();
	CalculationParameters.Insert("Key"             , Options.Key);
	CalculationParameters.Insert("Company"         , Options.Company);
	CalculationParameters.Insert("BillOfMaterials" , Options.BillOfMaterials);
	CalculationParameters.Insert("PlanningPeriod"  , Options.PlanningPeriod);
	CalculationParameters.Insert("ItemKey"         , Options.ItemKey);
	CalculationParameters.Insert("Unit"            , Options.Unit);
	CalculationParameters.Insert("Quantity"        , Options.Quantity);
	
	StoreCache = New Array();
	For Each Row In Options.BillOfMaterialsList Do
		Cache = New Structure("ReleaseStore, MaterialStore, SemiproductStore,
			|Key, ItemKey, InputID, OutputID, UniqueID");
		FillPropertyValues(Cache, Row);
		StoreCache.Add(Cache);
	EndDo;
	
	BillOfMaterialRows = ManufacturingServer.FillBillOfMaterialsTable(CalculationParameters);
	For Each Row In BillOfMaterialRows Do
		NewRow = New Structure(Options.BillOfMaterialsListColumns);
		FillPropertyValues(NewRow, Row);
		Result.BillOfMaterialsList.Add(NewRow);
		RestoreStoresFromCache(StoreCache, Row, NewRow);
	EndDo;
	Return Result;
EndFunction

Function BillOfMaterialsListCalculationsCorrectionOptions() Export
	Return GetChainLinkOptions("BillOfMaterialsList, BillOfMaterialsListColumns,
		|Company, BillOfMaterials, PlanningPeriod, ItemKey, Unit, Quantity, CurrentQuantity");
EndFunction

Function BillOfMaterialsListCalculationsCorrectionExecute(Options) Export
	Result = New Structure();
	Result.Insert("BillOfMaterialsList", New Array());
	
	CalculationParameters = New Structure();
	CalculationParameters.Insert("Key"             , Options.Key);
	CalculationParameters.Insert("Company"         , Options.Company);
	CalculationParameters.Insert("BillOfMaterials" , Options.BillOfMaterials);
	CalculationParameters.Insert("PlanningPeriod"  , Options.PlanningPeriod);
	CalculationParameters.Insert("ItemKey"         , Options.ItemKey);
	CalculationParameters.Insert("Unit"            , Options.Unit);
	CalculationParameters.Insert("Quantity"        , Options.Quantity);
	CalculationParameters.Insert("CurrentQuantity" , Options.CurrentQuantity);
	
	StoreCache = New Array();
	For Each Row In Options.BillOfMaterialsList Do
		Cache = New Structure("ReleaseStore, MaterialStore, SemiproductStore,
			|Key, ItemKey, InputID, OutputID, UniqueID");
		FillPropertyValues(Cache, Row);
		StoreCache.Add(Cache);
	EndDo;
	
	BillOfMaterialRows = ManufacturingServer.FillBillOfMaterialsTableCorrection(CalculationParameters);
	For Each Row In BillOfMaterialRows Do
		NewRow = New Structure(Options.BillOfMaterialsListColumns);
		FillPropertyValues(NewRow, Row);
		Result.BillOfMaterialsList.Add(NewRow);
		RestoreStoresFromCache(StoreCache, Row, NewRow);
	EndDo;
	Return Result;
EndFunction

Procedure RestoreStoresFromCache(StoreCache, Row, NewRow)
	For Each Cache In StoreCache Do
		If Cache.Key = Row.Key 
			And Cache.ItemKey = Row.ItemKey 
			And Cache.InputID = Row.InputID 
			And Cache.OutputID = Row.OutputID 
			And Cache.UniqueID = Row.UniqueID Then
				If ValueIsFilled(Cache.ReleaseStore) Then
					NewRow.ReleaseStore = Cache.ReleaseStore;
				EndIf;
				If ValueIsFilled(Cache.MaterialStore) Then
					NewRow.MaterialStore = Cache.MaterialStore;
				EndIf;
				If ValueIsFilled(Cache.SemiproductStore) Then
					NewRow.SemiproductStore = Cache.SemiproductStore;
				EndIf;
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region MATERIALS_CALCULATIONS

Function MaterialsCalculationsOptions() Export
	Return GetChainLinkOptions("Materials, BillOfMaterials, MaterialsColumns,
		|ItemKey, Unit, Quantity, KeyOwner");
EndFunction

Function MaterialsCalculationsExecute(Options) Export
	Result = New Structure();
	Result.Insert("Materials", Options.Materials);
	
	CalculationParameters = New Structure();
	CalculationParameters.Insert("Materials"        , Options.Materials);
	CalculationParameters.Insert("BillOfMaterials"  , Options.BillOfMaterials);
	CalculationParameters.Insert("MaterialsColumns" , Options.MaterialsColumns);
	CalculationParameters.Insert("ItemKey"          , Options.ItemKey);
	CalculationParameters.Insert("Unit"             , Options.Unit);
	CalculationParameters.Insert("Quantity"         , Options.Quantity);
	CalculationParameters.Insert("KeyOwner"         , Options.KeyOwner);
	
	ManufacturingServer.FillMaterialsTable(CalculationParameters);
		
	Return Result;
EndFunction

Function MaterialsRecalculateQuantityOptions() Export
	Return GetChainLinkOptions("Materials, BillOfMaterials, MaterialsColumns,
		|ItemKey, Unit, Quantity");
EndFunction

Function MaterialsRecalculateQuantityExecute(Options) Export
	Result = New Structure();
	Result.Insert("Materials", Options.Materials);
	
	CalculationParameters = New Structure();
	CalculationParameters.Insert("Materials"        , Options.Materials);
	CalculationParameters.Insert("BillOfMaterials"  , Options.BillOfMaterials);
	CalculationParameters.Insert("MaterialsColumns" , Options.MaterialsColumns);
	CalculationParameters.Insert("ItemKey"          , Options.ItemKey);
	CalculationParameters.Insert("Unit"             , Options.Unit);
	CalculationParameters.Insert("Quantity"         , Options.Quantity);
	
	ManufacturingServer.CalculateMaterialsQuantity(CalculationParameters);
	
	Return Result;
EndFunction

#EndRegion

#Region CALCULATIONS

Function CalculationsOptions() Export
	Options = GetChainLinkOptions("Ref, ItemKey, Unit");
	
	AmountOptions = New Structure();
	AmountOptions.Insert("DontCalculateRow", False);
	AmountOptions.Insert("NetAmount"       , 0);
	AmountOptions.Insert("OffersAmount"    , 0);
	AmountOptions.Insert("TaxAmount"       , 0);
	AmountOptions.Insert("TotalAmount"     , 0);
	Options.Insert("AmountOptions", AmountOptions);
	
	PriceOptions = New Structure("PriceType, Price, Quantity, QuantityInBaseUnit");
	Options.Insert("PriceOptions", PriceOptions);
	
	// TaxList columns: Key, Tax, Analytics, TaxRate, Amount, IncludeToTotalAmount, ManualAmount
	TaxOptions = New Structure("PriceIncludeTax, ArrayOfTaxInfo, TaxRates, UseManualAmount, IsAlreadyCalculated");
	TaxOptions.Insert("TaxList", New Array());
	Options.Insert("TaxOptions", TaxOptions);
	
	QuantityOptions = New Structure("ItemKey, Unit, Quantity, QuantityInBaseUnit");
	Options.Insert("QuantityOptions", QuantityOptions);
	
	// SpecialOffers columns: Key, Offer, Amount, Percent
	OffersOptions = New Structure();
	OffersOptions.Insert("SpecialOffers"      , New Array());
	OffersOptions.Insert("SpecialOffersCache" , New Array());
	Options.Insert("OffersOptions", OffersOptions);
	
	// TotalAmount
	Options.Insert("CalculateTotalAmount"            , New Structure("Enable", False));
	Options.Insert("CalculateTotalAmountByNetAmount" , New Structure("Enable", False));
	
	// NetAmount
	Options.Insert("CalculateNetAmount"                            , New Structure("Enable", False));
	Options.Insert("CalculateNetAmountByTotalAmount"               , New Structure("Enable", False));
	Options.Insert("CalculateNetAmountAsTotalAmountMinusTaxAmount" , New Structure("Enable", False));
	
	// TaxAmount
	Options.Insert("CalculateTaxAmount"              , New Structure("Enable", False));
	Options.Insert("CalculateTaxAmountByNetAmount"   , New Structure("Enable", False));
	Options.Insert("CalculateTaxAmountByTotalAmount" , New Structure("Enable", False));
	Options.Insert("CalculateTaxAmountReverse"       , New Structure("Enable", False));
	
	// Price
	Options.Insert("CalculatePriceByTotalAmount" , New Structure("Enable", False));
	
	// QuantityInBaseUnit
	Options.Insert("CalculateQuantityInBaseUnit" , New Structure("Enable", False));
	
	// SpecialOffers
	Options.Insert("CalculateSpecialOffers"   , New Structure("Enable", False));
	Options.Insert("RecalculateSpecialOffers" , New Structure("Enable", False));
	
	Options.Insert("RowIDInfo", New Array());
	
	Return Options;
EndFunction

Function CalculationsOptions_TaxOptions_TaxList() Export
	Return New Structure("Key, Tax, Analytics, TaxRate, Amount, IncludeToTotalAmount, ManualAmount");
EndFunction

Function CalculationsExecute(Options) Export
	IsCalculatedRow = Not Options.AmountOptions.DontCalculateRow;

	Result = New Structure();
	Result.Insert("NetAmount"    , Options.AmountOptions.NetAmount);
	Result.Insert("OffersAmount" , Options.AmountOptions.OffersAmount);
	Result.Insert("TaxAmount"    , Options.AmountOptions.TaxAmount);
	Result.Insert("TotalAmount"  , Options.AmountOptions.TotalAmount);
	Result.Insert("Price"        , Options.PriceOptions.Price);
	Result.Insert("TaxRates"     , Options.TaxOptions.TaxRates);
	Result.Insert("TaxList"      , New Array());
	Result.Insert("QuantityInBaseUnit" , Options.QuantityOptions.QuantityInBaseUnit);
	Result.Insert("SpecialOffers", New Array());
	
	For Each OfferRow In Options.OffersOptions.SpecialOffers Do
		NewOfferRow = New Structure("Key, Offer, Amount, Percent");
		FillPropertyValues(NewOfferRow, OfferRow);
		Result.SpecialOffers.Add(NewOfferRow);
	EndDo;
	
	UserManualAmountsFromBasisDocument = New Array();
	
	//IsLinkedRow = False;
	OffersFromBaseDocument = False;
//	IsUserChangeTaxAmount = False;
	If Options.RecalculateSpecialOffers.Enable Or Options.CalculateSpecialOffers.Enable Or Options.CalculateTaxAmount.Enable Then
		For Each Row In Options.RowIDInfo Do
			Scaling = New Structure();
			Scaling.Insert("QuantityInBaseUnit", Options.PriceOptions.QuantityInBaseUnit);
			Scaling.Insert("ItemKey" , Options.ItemKey);
			Scaling.Insert("Unit"    , Options.Unit);
			DataFromBasis = RowIDInfoServer.GetAllDataFromBasis(Options.Ref, Row.Basis, Row.BasisKey, Row.RowID, Row.CurrentStep, Scaling);
			If DataFromBasis <> Undefined And DataFromBasis.Count() Then 
				//IsLinkedRow = True;
				
				// Offers
				If (Options.RecalculateSpecialOffers.Enable Or Options.CalculateSpecialOffers.Enable) And DataFromBasis[0].SpecialOffers.Count() Then
					OffersFromBaseDocument = True;
					TotalOffers = 0;
					For Each OfferRow In Result.SpecialOffers Do
						For Each BasisRow In DataFromBasis[0].SpecialOffers Do
							If OfferRow.Offer = BasisRow.Offer Then 
								TotalOffers = TotalOffers + BasisRow.Amount;
								OfferRow.Amount = BasisRow.Amount;
							EndIf;
						EndDo;
					EndDo;
					Result.OffersAmount = TotalOffers;
				EndIf; // Offers
				
				// Taxes
				If Options.CalculateTaxAmount.Enable Then
					For Each RowTaxList In Options.TaxOptions.TaxList Do	
						For Each BasisRow In DataFromBasis[0].TaxList Do
							If BasisRow.Amount = BasisRow.ManualAmount Then
								Continue;
							EndIf;
							
							If  RowTaxList.Tax = BasisRow.Tax 
								And RowTaxList.Analytics = BasisRow.Analytics Then
//								And RowTaxList.TaxRate = BasisRow.TaxRate Then
								NewTaxRow = New Structure("Key, Tax, Analytics, TaxRate, Amount, IncludeToTotalAmount, ManualAmount");
								FillPropertyValues(NewTaxRow, BasisRow);
								NewTaxRow.Key = RowTaxList.Key;
								UserManualAmountsFromBasisDocument.Add(NewTaxRow);
							EndIf;
						EndDo;
					EndDo;
				EndIf; // Taxes
				
			EndIf;
		EndDo;
	EndIf;
	
	// RecalculateSpecialOffers
	If Options.RecalculateSpecialOffers.Enable And Not OffersFromBaseDocument Then
		For Each OfferRow In Options.OffersOptions.SpecialOffersCache Do
			Amount = 0;
			If Options.PriceOptions.Quantity = OfferRow.Quantity Then
				Amount = OfferRow.Amount;
			Else
				Amount = (OfferRow.Amount / OfferRow.Quantity) * Options.PriceOptions.Quantity;
			EndIf;
			For Each ResultOfferRow In Result.SpecialOffers Do
				If OfferRow.Key = ResultOfferRow.Key And OfferRow.Offer = ResultOfferRow.Offer Then
					ResultOfferRow.Amount = Amount;
				EndIf;
			EndDo;
		EndDo;
	EndIf;
	
	// CalculateSpecialOffers
	If Options.CalculateSpecialOffers.Enable And Not OffersFromBaseDocument Then
		TotalOffers = 0;
		For Each OfferRow In Result.SpecialOffers Do
			TotalOffers = TotalOffers + OfferRow.Amount;
		EndDo;
		Result.OffersAmount = TotalOffers;
	EndIf;
	
	// CalculateQuantityInBaseUnit
	If Options.CalculateQuantityInBaseUnit.Enable Then
		If Not ValueIsFilled(Options.QuantityOptions.ItemKey) Then
			UnitFactor = 0;
		Else
			UnitFactor = GetItemInfo.GetUnitFactor(Options.QuantityOptions.ItemKey, Options.QuantityOptions.Unit);
		EndIf;
		Result.QuantityInBaseUnit = Options.QuantityOptions.Quantity * UnitFactor;
	EndIf;
	
	If Not IsCalculatedRow Then
		For Each Row In Options.TaxOptions.TaxList Do
			Result.TaxList.Add(Row);
		EndDo;
	EndIf;
	
	If Options.TaxOptions.PriceIncludeTax <> Undefined Then
		If Options.TaxOptions.PriceIncludeTax Then
			
			If Options.CalculateTaxAmountReverse.Enable And IsCalculatedRow Then
				CalculateTaxAmount(Options, Options.TaxOptions, Result, True, False, False, UserManualAmountsFromBasisDocument);
			EndIf;
			
			If Options.CalculatePriceByTotalAmount.Enable And IsCalculatedRow Then
				Result.Price = ?(Options.PriceOptions.Quantity = 0, 0, 
				Result.TotalAmount / Options.PriceOptions.Quantity);  
			EndIf;
			
			If Options.CalculateTotalAmount.Enable And IsCalculatedRow Then
				Result.TotalAmount = CalculateTotalAmount_PriceIncludeTax(Options.PriceOptions, Result);
			EndIf;

			If Options.CalculateTaxAmount.Enable And (IsCalculatedRow Or Options.TaxOptions.IsAlreadyCalculated = True) Then
				CalculateTaxAmount(Options, Options.TaxOptions, Result, False, False, False, UserManualAmountsFromBasisDocument);
			EndIf;

			If Options.CalculateNetAmountAsTotalAmountMinusTaxAmount.Enable And IsCalculatedRow Then
				Result.NetAmount = CalculateNetAmount_PriceIncludeTax(Options.PriceOptions, Result);
			EndIf;

			If Options.CalculateNetAmount.Enable And IsCalculatedRow Then
				Result.NetAmount = CalculateNetAmount_PriceIncludeTax(Options.PriceOptions, Result);
			EndIf;
		Else
			If Options.CalculateTaxAmountReverse.Enable And IsCalculatedRow Then
				CalculateTaxAmount(Options, Options.TaxOptions, Result, True, False, False, UserManualAmountsFromBasisDocument);
			EndIf;
			
			If Options.CalculatePriceByTotalAmount.Enable And IsCalculatedRow Then
				Result.Price = ?(Options.PriceOptions.Quantity = 0, 0, 
				(Result.TotalAmount - Result.TaxAmount) / Options.PriceOptions.Quantity);
			EndIf;
			
			If Options.CalculateNetAmountAsTotalAmountMinusTaxAmount.Enable And IsCalculatedRow Then
				Result.NetAmount = CalculateNetAmountAsTotalAmountMinusTaxAmount_PriceNotIncludeTax(Options.PriceOptions, Result);
			EndIf;

			If Options.CalculateNetAmount.Enable And IsCalculatedRow Then
				Result.NetAmount = CalculateNetAmount_PriceNotIncludeTax(Options.PriceOptions, Result);
			EndIf;

			If Options.CalculateTaxAmount.Enable And (IsCalculatedRow Or Options.TaxOptions.IsAlreadyCalculated = True) Then
				CalculateTaxAmount(Options, Options.TaxOptions, Result, False, False, False, UserManualAmountsFromBasisDocument);
			EndIf;

			If Options.CalculateTotalAmount.Enable And IsCalculatedRow Then
				Result.TotalAmount = CalculateTotalAmount_PriceNotIncludeTax(Options.PriceOptions, Result);
			EndIf;
		EndIf;
	Else // PriceIncludeTax is Undefined
		If Options.CalculateTaxAmountReverse.Enable And IsCalculatedRow Then
			CalculateTaxAmount(Options, Options.TaxOptions, Result, True, False, False, UserManualAmountsFromBasisDocument);
		EndIf;
		
		If Options.CalculatePriceByTotalAmount.Enable And IsCalculatedRow Then
			Result.Price = ?(Options.PriceOptions.Quantity = 0, 0, 
			(Result.TotalAmount - Result.TaxAmount) / Options.PriceOptions.Quantity);
		EndIf;
		
		If Options.CalculateTaxAmount.Enable And (IsCalculatedRow Or Options.TaxOptions.IsAlreadyCalculated = True) Then
			CalculateTaxAmount(Options, Options.TaxOptions, Result, False, True, False, UserManualAmountsFromBasisDocument);
		EndIf;

		If Options.CalculateTotalAmount.Enable And IsCalculatedRow Then
			Result.TotalAmount = CalculateTotalAmount_PriceNotIncludeTax(Options.PriceOptions, Result);
		EndIf;

		If Options.CalculateTaxAmountByNetAmount.Enable And IsCalculatedRow Then
			CalculateTaxAmount(Options, Options.TaxOptions, Result, False, True, False, UserManualAmountsFromBasisDocument);
		EndIf;

		If Options.CalculateTaxAmountByTotalAmount.Enable And IsCalculatedRow Then
			CalculateTaxAmount(Options, Options.TaxOptions, Result, False, True, True, UserManualAmountsFromBasisDocument);
		EndIf;

		If Options.CalculateNetAmountAsTotalAmountMinusTaxAmount.Enable And IsCalculatedRow Then
			Result.NetAmount = CalculateNetAmount_PriceIncludeTax(Options.PriceOptions, Result);
		EndIf;

		If Options.CalculateNetAmountByTotalAmount.Enable And IsCalculatedRow Then
			Result.NetAmount = CalculateNetAmount_PriceIncludeTax(Options.PriceOptions, Result);
		EndIf;

		If Options.CalculateTotalAmountByNetAmount.Enable And IsCalculatedRow Then
			Result.TotalAmount = CalculateTotalAmount_PriceNotIncludeTax(Options.PriceOptions, Result);
		EndIf;
	EndIf;
	Return Result;
EndFunction

Function CalculateTotalAmount_PriceIncludeTax(PriceOptions, Result)
	If PriceOptions.Price <> Undefined Then
		Return _CalculateAmount(PriceOptions, Result) - Result.OffersAmount;
	Else
		Return Result.NetAmount;
	EndIf;
EndFunction

Function CalculateTotalAmount_PriceNotIncludeTax(PriceOptions, Result)
	Return Result.NetAmount + Result.TaxAmount;
EndFunction

Function CalculateNetAmount_PriceIncludeTax(PriceOptions, Result)
	If PriceOptions.Price <> Undefined Then
		Return _CalculateAmount(PriceOptions, Result) - Result.TaxAmount - Result.OffersAmount;
	Else
		Return (Result.TotalAmount - Result.TaxAmount - Result.OffersAmount);
	EndIf;
EndFunction

Function CalculateNetAmount_PriceNotIncludeTax(PriceOptions, Result)
	If PriceOptions.Price <> Undefined Then
		Return _CalculateAmount(PriceOptions, Result) - Result.OffersAmount;
	Else
		Return Result.TotalAmount;
	EndIf;
EndFunction

Function CalculateNetAmountAsTotalAmountMinusTaxAmount_PriceNotIncludeTax(PriceOptions, Result)
	Return Result.TotalAmount - Result.TaxAmount - Result.OffersAmount;
EndFunction

Function _CalculateAmount(PriceOptions, Result)
	If PriceOptions.Quantity <> Undefined Then
		Return Result.Price * PriceOptions.Quantity;
	EndIf;
	Return Result.TotalAmount;
EndFunction

Procedure CalculateTaxAmount(Options, TaxOptions, Result, IsReverse, IsManualPriority, PriceIncludeTax, UserManualAmountsFromBasisDocument)
	
	// TaxOptions.IsAlreadyCalculated - deprecated (tax calculated always)
	If TaxOptions.IsAlreadyCalculated = True Then
		TaxAmount = 0;
		For Each Row In TaxOptions.TaxList Do
			ResultRowIsExists = False;
			For Each ResultRow In Result.TaxList Do
				If ResultRow.Key = Row.Key And ResultRow.Tax = Row.Tax Then
					ResultRowIsExists = True;
					Break;
				EndIf;
			EndDo;
			If Not ResultRowIsExists Then
				Result.TaxList.Add(Row);
			EndIf;
			If Row.IncludeToTotalAmount Then
				TaxAmount = Round(TaxAmount + Row.ManualAmount, 2);
			EndIf;
		EndDo;
		Result.TaxAmount = TaxAmount;
		Return;
	EndIf; // IsAlreadyCalculated
	
	ArrayOfTaxInfo = TaxOptions.ArrayOfTaxInfo;
	If TaxOptions.ArrayOfTaxInfo = Undefined Then
		Return;
	EndIf;
	
	TaxAmount = 0;
	For Each ItemOfTaxInfo In ArrayOfTaxInfo Do
		If Not Result.TaxRates.Property(ItemOfTaxInfo.Name) Then
			Continue;
		EndIf;
		
		If ItemOfTaxInfo.Type = PredefinedValue("Enum.TaxType.Rate") 
			And Not ValueIsFilled(Result.TaxRates[ItemOfTaxInfo.Name]) Then
			// tax rate in row is not filled
			Continue;
		EndIf;
		
			
		TaxParameters = New Structure();
		TaxParameters.Insert("Tax"             , ItemOfTaxInfo.Tax);
		TaxParameters.Insert("TaxRateOrAmount" , Result.TaxRates[ItemOfTaxInfo.Name]);
		If TaxOptions.PriceIncludeTax = Undefined Then
			TaxParameters.Insert("PriceIncludeTax" , PriceIncludeTax);
		Else
			TaxParameters.Insert("PriceIncludeTax" , TaxOptions.PriceIncludeTax);
		EndIf;
		TaxParameters.Insert("Key"             , Options.Key);
		TaxParameters.Insert("TotalAmount"     , Result.TotalAmount);
		TaxParameters.Insert("NetAmount"       , Result.NetAmount);
		TaxParameters.Insert("Ref"             , Options.Ref);
		TaxParameters.Insert("Reverse"         , IsReverse);
		
		ArrayOfResultsTaxCalculation = TaxesServer.CalculateTax(TaxParameters);
		
		For Each RowOfResult In ArrayOfResultsTaxCalculation Do
			NewTax = New Structure();
			NewTax.Insert("Key", Options.Key);
			NewTax.Insert("Tax", ?(ValueIsFilled(RowOfResult.Tax), 
				RowOfResult.Tax, PredefinedValue("Catalog.Taxes.EmptyRef")));
			NewTax.Insert("Analytics", ?(ValueIsFilled(RowOfResult.Analytics), 
				RowOfResult.Analytics, PredefinedValue("Catalog.TaxAnalytics.EmptyRef")));
			NewTax.Insert("TaxRate", ?(ValueIsFilled(RowOfResult.TaxRate), 
				RowOfResult.TaxRate, PredefinedValue("Catalog.TaxRates.EmptyRef")));
			NewTax.Insert("Amount", ?(ValueIsFilled(RowOfResult.Amount),
				RowOfResult.Amount, 0));
			NewTax.Insert("IncludeToTotalAmount" , ?(ValueIsFilled(RowOfResult.IncludeToTotalAmount),
				RowOfResult.IncludeToTotalAmount, False));
			
			RowFromBasisDocument = False;
			For Each RowBasis In UserManualAmountsFromBasisDocument Do
				If RowBasis.Key = NewTax.Key
					And RowBasis.Tax = NewTax.Tax
					And RowBasis.Analytics = NewTax.Analytics
					And RowBasis.TaxRate = NewTax.TaxRate Then
					
					NewTax.Amount = RowBasis.Amount;
					NewTax.Insert("ManualAmount", Round(RowBasis.ManualAmount, 2));
					RowFromBasisDocument = True;
					Break;	
				EndIf;
			EndDo;
			
			If Not RowFromBasisDocument Then
				ManualAmount = 0;
				IsRowExists = False;
				For Each RowTaxList In TaxOptions.TaxList Do
					If RowTaxList.Key = NewTax.Key
						And RowTaxList.Tax = NewTax.Tax 
						And RowTaxList.Analytics = NewTax.Analytics
						And RowTaxList.TaxRate = NewTax.TaxRate Then
					
						RowTaxList_ManualAmount = Round(RowTaxList.ManualAmount, 2);
						RowTaxList_Amount       = Round(RowTaxList.Amount, 2);
						NewTax_Amount           = Round(NewTax.Amount, 2);
					
						IsRowExists = True;
						If IsManualPriority Then
							ManualAmount = ?(RowTaxList_ManualAmount = RowTaxList_Amount, NewTax_Amount, RowTaxList_ManualAmount);
						Else
							ManualAmount = ?(RowTaxList_Amount = NewTax_Amount And TaxOptions.UseManualAmount = True
								, RowTaxList_ManualAmount, NewTax_Amount);
						EndIf;
					EndIf;
				EndDo;
				If Not IsRowExists Then
					ManualAmount = Round(NewTax.Amount, 2);
				EndIf;
				NewTax.Insert("ManualAmount", ManualAmount);
			EndIf;
			
			Result.TaxList.Add(NewTax);
			If RowOfResult.IncludeToTotalAmount Then
				TaxAmount = Round(TaxAmount + NewTax.ManualAmount, 2);
			EndIf;
		EndDo;
	EndDo;

	Result.TaxAmount = TaxAmount;
EndProcedure

Function SimpleCalculationsOptions() Export
	Options = GetChainLinkOptions("Ref");
	
	Options.Insert("Amount", 0);
	Options.Insert("Price", 0);
	Options.Insert("Quantity", 0);
	
	Options.Insert("CalculateAmount", New Structure("Enable", False));
	Options.Insert("CalculatePrice" , New Structure("Enable", False));
	
	Return Options;
EndFunction

Function SimpleCalculationsExecute(Options) Export
	Result = New Structure();
	Result.Insert("Amount"  , Options.Amount);
	Result.Insert("Price"   , Options.Price);
	Result.Insert("Quantity", Options.Quantity);
	If Options.CalculatePrice.Enable Then
		Result.Price = ?(Result.Quantity = 0, 0, Result.Amount / Result.Quantity);
	EndIf;
	If Options.CalculateAmount.Enable Then
		Result.Amount = Result.Price * Result.Quantity;
	EndIf;
	Return Result;
EndFunction

#EndRegion

#Region _EXTRACT_DATA_

Function ExtractDataAgreementApArPostingDetailOptions() Export
	Return GetChainLinkOptions("Agreement");
EndFunction

Function ExtractDataAgreementApArPostingDetailExecute(Options) Export
	Return ModelServer_V2.ExtractDataAgreementApArPostingDetailImp(Options.Agreement);
EndFunction

Function ExtractDataCurrencyFromAccountOptions() Export
	Return GetChainLinkOptions("Account");
EndFunction

Function ExtractDataCurrencyFromAccountExecute(Options) Export
	Return ServiceSystemServer.GetObjectAttribute(Options.Account, "Currency");
EndFunction

#EndRegion

#Region PLANNING_TRANSACTION_BASIS

// Bank Payment
Function FillByPTBBankPaymentOptions() Export
	Return GetChainLinkOptions("PlanningTransactionBasis, Ref, Company, Account, Currency, TotalAmount");
EndFunction

Function FillByPTBBankPaymentExecute(Options) Export
	Result = New Structure();
	Result.Insert("Account"     , Options.Account);
	Result.Insert("Company"     , Options.Company);
	Result.Insert("Currency"    , Options.Currency);
	Result.Insert("TotalAmount" , Options.TotalAmount);
	
	If ValueIsFilled(Options.PlanningTransactionBasis) Then
		If TypeOf(Options.PlanningTransactionBasis) = Type("DocumentRef.CashTransferOrder") Then
			OrderInfo = DocCashTransferOrderServer.GetInfoForFillingBankPayment(Options.PlanningTransactionBasis);
			Result.Account  = OrderInfo.Account;
			Result.Company  = OrderInfo.Company;
			Result.Currency = OrderInfo.Currency;
			
			ArrayOfDocs = New Array();
			ArrayOfDocs.Add(Options.PlanningTransactionBasis);
			ArrayOfBalance = DocBankPaymentServer.GetDocumentTable_CashTransferOrder_ForClient(ArrayOfDocs, Options.Ref);
			If ArrayOfBalance.Count() Then
				Amount = ArrayOfBalance[0].Amount;
				Result.TotalAmount = ?(ValueIsFilled(Amount), Amount, 0);
			EndIf;
			
			Return Result;
		EndIf;
		
		If TypeOf(Options.PlanningTransactionBasis) = Type("DocumentRef.ChequeBondTransactionItem") Then
			OrderInfo = DocChequeBondTransactionServer.GetInfoForFillingBankDocument(Options.PlanningTransactionBasis);
			Result.Account     = OrderInfo.Account;
			Result.Company     = OrderInfo.Company;
			Result.Currency    = OrderInfo.Currency;
			Result.TotalAmount = OrderInfo.Amount;
			Return Result;
		EndIf;
		Return Result;
	EndIf;
	Return Result;
EndFunction

// Bank Receipt
Function FillByPTBBankReceiptOptions() Export
	Return GetChainLinkOptions("PlanningTransactionBasis, 
		|Ref, 
		|Company, 
		|Account, 
		|Currency, 
		|CurrencyExchange, 
		|TotalAmount,
		|AmountExchange");
EndFunction

Function FillByPTBBankReceiptExecute(Options) Export
	Result = New Structure();
	Result.Insert("Account"         , Options.Account);
	Result.Insert("Company"         , Options.Company);
	Result.Insert("Currency"        , Options.Currency);
	Result.Insert("CurrencyExchange", Options.CurrencyExchange);
	Result.Insert("TotalAmount"     , Options.TotalAmount);
	Result.Insert("AmountExchange"  , Options.AmountExchange);
	
	If ValueIsFilled(Options.PlanningTransactionBasis) Then
		If TypeOf(Options.PlanningTransactionBasis) = Type("DocumentRef.CashTransferOrder") Then
			OrderInfo = DocCashTransferOrderServer.GetInfoForFillingBankReceipt(Options.PlanningTransactionBasis);
			Result.Account  = OrderInfo.Account;
			Result.Company  = OrderInfo.Company;
			Result.Currency = OrderInfo.Currency;
			Result.CurrencyExchange = OrderInfo.CurrencyExchange;
			
			ArrayOfDocs = New Array();
			ArrayOfDocs.Add(Options.PlanningTransactionBasis);
			ArrayOfBalance = DocBankReceiptServer.GetDocumentTable_CashTransferOrder_ForClient(ArrayOfDocs, Options.Ref);
			If ArrayOfBalance.Count() Then
				BalanceRow = ArrayOfBalance[0];
				Result.TotalAmount     = ?(ValueIsFilled(BalanceRow.Amount), BalanceRow.Amount, 0);
				Result.AmountExchange = ?(ValueIsFilled(BalanceRow.AmountExchange), BalanceRow.AmountExchange, 0);
			EndIf;
			Return Result;
		EndIf;
		
		If TypeOf(Options.PlanningTransactionBasis) = Type("DocumentRef.ChequeBondTransactionItem") Then
			OrderInfo = DocChequeBondTransactionServer.GetInfoForFillingBankDocument(Options.PlanningTransactionBasis);
			Result.Account     = OrderInfo.Account;
			Result.Company     = OrderInfo.Company;
			Result.Currency    = OrderInfo.Currency;
			Result.TotalAmount = OrderInfo.Amount;
			Result.AmountExchange   = Undefined;
			Result.CurrencyExchange = Undefined;
			Return Result;
		EndIf;
		Return Result;
	EndIf;
	Return Result;
EndFunction

// Cash Payment
Function FillByPTBCashPaymentOptions() Export
	Return GetChainLinkOptions("PlanningTransactionBasis, 
		|Ref, 
		|Company, 
		|Account, 
		|Currency, 
		|Partner, 
		|TotalAmount");
EndFunction

Function FillByPTBCashPaymentExecute(Options) Export
	Result = New Structure();
	Result.Insert("Account"     , Options.Account);
	Result.Insert("Company"     , Options.Company);
	Result.Insert("Currency"    , Options.Currency);
	Result.Insert("Partner"     , Options.Partner);
	Result.Insert("TotalAmount" , Options.TotalAmount);
	
	If ValueIsFilled(Options.PlanningTransactionBasis)
		And TypeOf(Options.PlanningTransactionBasis) = Type("DocumentRef.CashTransferOrder") Then
			OrderInfo = DocCashTransferOrderServer.GetInfoForFillingCashPayment(Options.PlanningTransactionBasis);
			Result.Account  = OrderInfo.CashAccount;
			Result.Company  = OrderInfo.Company;
			Result.Currency = OrderInfo.Currency;
			
			ArrayOfDocs = New Array();
			ArrayOfDocs.Add(Options.PlanningTransactionBasis);
			ArrayOfBalance = DocCashPaymentServer.GetDocumentTable_CashTransferOrder_ForClient(ArrayOfDocs, Options.Ref);
			If ArrayOfBalance.Count() Then
				BalanceRow = ArrayOfBalance[0]; 
				Result.TotalAmount = ?(ValueIsFilled(BalanceRow.Amount), BalanceRow.Amount, 0);
				Result.Partner = BalanceRow.Partner;
			EndIf;
		
			Return Result;
	EndIf;
	Return Result;
EndFunction

// Cash Receipt
Function FillByPTBCashReceiptOptions() Export
	Return GetChainLinkOptions("PlanningTransactionBasis, 
		|Ref, 
		|Company, 
		|Account, 
		|Currency, 
		|CurrencyExchange, 
		|Partner, 
		|TotalAmount,
		|AmountExchange");
EndFunction

Function FillByPTBCashReceiptExecute(Options) Export
	Result = New Structure();
	Result.Insert("Account"         , Options.Account);
	Result.Insert("Company"         , Options.Company);
	Result.Insert("Currency"        , Options.Currency);
	Result.Insert("CurrencyExchange", Options.CurrencyExchange);
	Result.Insert("Partner"         , Options.Partner);
	Result.Insert("TotalAmount"     , Options.TotalAmount);
	Result.Insert("AmountExchange"  , Options.AmountExchange);
	
	If ValueIsFilled(Options.PlanningTransactionBasis)
		And TypeOf(Options.PlanningTransactionBasis) = Type("DocumentRef.CashTransferOrder") Then
			OrderInfo = DocCashTransferOrderServer.GetInfoForFillingCashReceipt(Options.PlanningTransactionBasis);
			Result.Account  = OrderInfo.CashAccount;
			Result.Company  = OrderInfo.Company;
			Result.Currency = OrderInfo.Currency;
			Result.CurrencyExchange = OrderInfo.CurrencyExchange;
			
			ArrayOfDocs = New Array();
			ArrayOfDocs.Add(Options.PlanningTransactionBasis);
			ArrayOfBalance = DocCashReceiptServer.GetDocumentTable_CashTransferOrder_ForClient(ArrayOfDocs);
			If ArrayOfBalance.Count() Then
				BalanceRow = ArrayOfBalance[0];
				Result.TotalAmount    = ?(ValueIsFilled(BalanceRow.Amount), BalanceRow.Amount, 0);
				Result.AmountExchange = ?(ValueIsFilled(BalanceRow.AmountExchange), BalanceRow.AmountExchange, 0);
				Result.Partner = BalanceRow.Partner;
			EndIf;
		
			Return Result;
	EndIf;
	Return Result;
EndFunction

#EndRegion

#Region MONEY_TRANSFER

Function FillByMoneyTransferCashReceiptOptions() Export
	Return GetChainLinkOptions("MoneyTransfer, 
		|Ref,
		|Company, 
		|Account, 
		|Currency, 
		|TotalAmount,
		|FinancialMovementType");
EndFunction

Function FillByMoneyTransferCashReceiptExecute(Options) Export
	Result = New Structure();
	Result.Insert("Company"         , Options.Company);
	Result.Insert("Account"         , Options.Account);
	Result.Insert("Currency"        , Options.Currency);
	Result.Insert("TotalAmount"     , Options.TotalAmount);
	Result.Insert("FinancialMovementType" , Options.FinancialMovementType);
	
	If ValueIsFilled(Options.MoneyTransfer) Then
		MoneyTransferInfo = DocMoneyTransferServer.GetInfoForFillingCashReceipt(Options.MoneyTransfer);
		Result.Company  = MoneyTransferInfo.Company;
		Result.Account  = MoneyTransferInfo.CashAccount;
		Result.Currency = MoneyTransferInfo.Currency;
		Result.FinancialMovementType = MoneyTransferInfo.FinancialMovementType;
			
		IncomingBalance = DocMoneyTransferServer.GetCashInTransitIncomingBalance(Options.MoneyTransfer, Options.Ref);
		Result.TotalAmount = ?(ValueIsFilled(IncomingBalance), IncomingBalance, 0);
		
		Return Result;
	EndIf;
	Return Result;
EndFunction

#EndRegion

#Region CASH_TRANSFER_ORDER

Function FillByCashTransferOrderOptions() Export
	Return GetChainLinkOptions("Ref, Company, Branch, CashTransferOrder,
		|Sender, SendCurrency, SendFinancialMovementType, SendAmount,
		|Receiver, ReceiveCurrency, ReceiveFinancialMovementType, ReceiveAmount");
EndFunction

Function FillByCashTransferOrderExecute(Options) Export
	Result = New Structure();
	Result.Insert("Company"                      , Options.Company);
	Result.Insert("Branch"                       , Options.Branch);
	Result.Insert("CashTransferOrder"            , Options.CashTransferOrder);
	Result.Insert("Sender"                       , Options.Sender);
	Result.Insert("SendCurrency"                 , Options.SendCurrency);
	Result.Insert("SendFinancialMovementType"    , Options.SendFinancialMovementType);
	Result.Insert("SendAmount"                   , Options.SendAmount);
	Result.Insert("Receiver"                     , Options.Receiver);
	Result.Insert("ReceiveCurrency"              , Options.ReceiveCurrency);
	Result.Insert("ReceiveFinancialMovementType" , Options.ReceiveFinancialMovementType);
	Result.Insert("ReceiveAmount"                , Options.ReceiveAmount);
	
	If Not ValueIsFilled(Options.CashTransferOrder) Then
		Return Result;
	EndIf;
	ArrayOfBasisDocuments = New Array();
	ArrayOfBasisDocuments.Add(Options.CashTransferOrder);
	ArrayOfResults = DocMoneyTransferServer.GetDocumentTable_CashTransferOrder_ForClient(ArrayOfBasisDocuments, Options.Ref);
	
	If Not ArrayOfResults.Count() Then
		Return Result;
	EndIf;
	
	Result.Company                      = ArrayOfResults[0].Company;
	Result.Branch                       = ArrayOfResults[0].Branch;
	Result.CashTransferOrder            = ArrayOfResults[0].CashTransferOrder;
	Result.Sender                       = ArrayOfResults[0].Sender;
	Result.SendCurrency                 = ArrayOfResults[0].SendCurrency;
	Result.SendFinancialMovementType    = ArrayOfResults[0].SendFinancialMovementType;
	Result.SendAmount                   = ArrayOfResults[0].SendAmount;
	Result.Receiver                     = ArrayOfResults[0].Receiver;
	Result.ReceiveCurrency              = ArrayOfResults[0].ReceiveCurrency;
	Result.ReceiveFinancialMovementType = ArrayOfResults[0].ReceiveFinancialMovementType;
	Result.ReceiveAmount                = ArrayOfResults[0].ReceiveAmount;
	
	Return Result;
EndFunction

#EndRegion

#Region TRANSACTION_TYPE

// Bank Payment
Function ClearByTransactionTypeBankPaymentOptions() Export
	Return GetChainLinkOptions("TransactionType,
		|TransitAccount,
		|Partner,
		|Payee,
		|Agreement,
		|LegalNameContract,
		|BasisDocument,
		|PlanningTransactionBasis,
		|Order,
		|PaymentType,
		|PaymentTerminal,
		|BankTerm,
		|RetailCustomer,
		|Employee");
EndFunction

Function ClearByTransactionTypeBankPaymentExecute(Options) Export
	Result = New Structure();
	Result.Insert("TransitAccount"           , Options.TransitAccount);
	Result.Insert("Partner"                  , Options.Partner);
	Result.Insert("Payee"                    , Options.Payee);
	Result.Insert("Agreement"                , Options.Agreement);
	Result.Insert("LegalNameContract"        , Options.LegalNameContract);
	Result.Insert("BasisDocument"            , Options.BasisDocument);
	Result.Insert("PlanningTransactionBasis" , Options.PlanningTransactionBasis);
	Result.Insert("Order"                    , Options.Order);
	Result.Insert("PaymentType"              , Options.PaymentType);
	Result.Insert("PaymentTerminal"          , Options.PaymentTerminal);
	Result.Insert("BankTerm"                 , Options.BankTerm);
	Result.Insert("RetailCustomer"           , Options.RetailCustomer);
	Result.Insert("Employee"                 , Options.Employee);
	
	Outgoing_CashTransferOrder = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CashTransferOrder");
	Outgoing_CurrencyExchange  = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CurrencyExchange");
	Outgoing_PaymentToVendor   = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.PaymentToVendor");
	Outgoing_ReturnToCustomer  = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.ReturnToCustomer");
	Outgoing_ReturnToCustomerByPOS  = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.ReturnToCustomerByPOS");
	Outgoing_PaymentByCheque     = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.PaymentByCheque");
	Outgoing_CustomerAdvance     = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CustomerAdvance");
	Outgoing_EmployeeCashAdvance = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.EmployeeCashAdvance");
	Outgoing_SalaryPayment       = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.SalaryPayment");
	
	// list of properties which not needed clear
	// PlanningTransactionBasis, BasisDocument, Order - clearing always
	If Options.TransactionType = Outgoing_CashTransferOrder Then
		StrByType = "";
	ElsIf Options.TransactionType = Outgoing_PaymentByCheque Then
		StrByType = "";
	ElsIf Options.TransactionType = Outgoing_CurrencyExchange Then
		StrByType = "
		|TransitAccount"; 
	ElsIf Options.TransactionType = Outgoing_PaymentToVendor 
		Or Options.TransactionType = Outgoing_ReturnToCustomer
		Or Options.TransactionType = Outgoing_ReturnToCustomerByPOS Then
		
		StrByType = "
		|Partner,
		|Agreement,
		|Payee,
		|LegalNameContract";
		
		If Options.TransactionType = Outgoing_ReturnToCustomerByPOS Then
			StrByType = StrByType + ", 
			|PaymentType,
			|PaymentTerminal,
			|BankTerm";
		EndIf;
	ElsIf Options.TransactionType = Outgoing_CustomerAdvance Then
		StrByType = "
		|RetailCustomer,
		|PaymentType,
		|PaymentTerminal,
		|BankTerm";
	ElsIf Options.TransactionType = Outgoing_EmployeeCashAdvance Then
		StrByType = "
		|Partner"; 	
	ElsIf Options.TransactionType = Outgoing_SalaryPayment Then
		StrByType = "
		|Employee"; 				
	EndIf;
	
	ArrayOfAttributes = New Array();
	For Each ArrayItem In StrSplit(StrByType, ",") Do
		ArrayOfAttributes.Add(StrReplace(TrimAll(ArrayItem), Chars.NBSp, ""));
	EndDo;
	
	For Each KeyValue In Result Do
		AttrName = TrimAll(KeyValue.Key);
		If Not ValueIsFilled(AttrName) Then
			Continue;
		EndIf;
		If ArrayOfAttributes.Find(AttrName) = Undefined Then
			Result[AttrName] = Undefined;
		EndIf;
	EndDo;
	Return Result;
EndFunction

// Bank Receipt
Function ClearByTransactionTypeBankReceiptOptions() Export
	Return GetChainLinkOptions("TransactionType,
		|TransitAccount,
		|CurrencyExchange,
		|Partner,
		|Payer,
		|Agreement,
		|LegalNameContract,
		|BasisDocument,
		|PlanningTransactionBasis,
		|Order,
		|AmountExchange,
		|POSAccount,
		|PaymentType,
		|PaymentTerminal,
		|BankTerm,
		|CommissionIsSeparate,
		|RetailCustomer");
EndFunction

Function ClearByTransactionTypeBankReceiptExecute(Options) Export
	Result = New Structure();
	Result.Insert("TransitAccount"           , Options.TransitAccount);
	Result.Insert("CurrencyExchange"         , Options.CurrencyExchange);
	Result.Insert("Partner"                  , Options.Partner);
	Result.Insert("Payer"                    , Options.Payer);
	Result.Insert("Agreement"                , Options.Agreement);
	Result.Insert("LegalNameContract"        , Options.LegalNameContract);
	Result.Insert("BasisDocument"            , Options.BasisDocument);
	Result.Insert("PlanningTransactionBasis" , Options.PlanningTransactionBasis);
	Result.Insert("Order"                    , Options.Order);
	Result.Insert("AmountExchange"           , Options.AmountExchange);
	Result.Insert("POSAccount"               , Options.POSAccount);
	Result.Insert("PaymentType"              , Options.PaymentType);
	Result.Insert("PaymentTerminal"          , Options.PaymentTerminal);
	Result.Insert("BankTerm"                 , Options.BankTerm);
	Result.Insert("CommissionIsSeparate"     , Options.CommissionIsSeparate);
	Result.Insert("RetailCustomer"           , Options.RetailCustomer);
	
	Incoming_CashTransferOrder   = PredefinedValue("Enum.IncomingPaymentTransactionType.CashTransferOrder");
	Incoming_CurrencyExchange    = PredefinedValue("Enum.IncomingPaymentTransactionType.CurrencyExchange");
	Incoming_PaymentFromCustomer = PredefinedValue("Enum.IncomingPaymentTransactionType.PaymentFromCustomer");
	Incoming_ReturnFromVendor    = PredefinedValue("Enum.IncomingPaymentTransactionType.ReturnFromVendor");
	Incoming_TransferFromPOS     = PredefinedValue("Enum.IncomingPaymentTransactionType.TransferFromPOS");
	Incoming_PaymentFromCustomerByPOS = PredefinedValue("Enum.IncomingPaymentTransactionType.PaymentFromCustomerByPOS");
	Incoming_ReceiptByCheque     = PredefinedValue("Enum.IncomingPaymentTransactionType.ReceiptByCheque");
	Incoming_CustomerAdvance     = PredefinedValue("Enum.IncomingPaymentTransactionType.CustomerAdvance");
	Incoming_EmployeeCashAdvance = PredefinedValue("Enum.IncomingPaymentTransactionType.EmployeeCashAdvance");
	
	// list of properties which not needed clear
	// PlanningTransactionBasis, BasisDocument, Order - clearing always
	If Options.TransactionType = Incoming_CashTransferOrder Then
		StrByType = "";
	ElsIf Options.TransactionType = Incoming_ReceiptByCheque Then
		StrByType = "";	
	ElsIf Options.TransactionType = Incoming_CurrencyExchange Then
		StrByType = "
		|TransitAccount, 
		|CurrencyExchange,
		|AmountExchange";
	ElsIf Options.TransactionType = Incoming_PaymentFromCustomer 
		Or Options.TransactionType = Incoming_ReturnFromVendor 
		Or Options.TransactionType = Incoming_PaymentFromCustomerByPOS Then
		
		StrByType = "
		|Partner,
		|Agreement,
		|Payer,
		|LegalNameContract";
		
		If Options.TransactionType = Incoming_PaymentFromCustomerByPOS Then
			StrByType = StrByType + ", 
			|PaymentType,
			|PaymentTerminal,
			|BankTerm";
		EndIf;
	ElsIf Options.TransactionType = Incoming_TransferFromPOS Then
		StrByType = "
		|POSAccount,
		|CommissionIsSeparate";
	ElsIf Options.TransactionType = Incoming_CustomerAdvance Then
		StrByType = "
		|RetailCustomer,
		|PaymentType,
		|PaymentTerminal,
		|BankTerm";
	ElsIf Options.TransactionType = Incoming_EmployeeCashAdvance Then
		StrByType = "
		|Partner";
	EndIf;
	
	ArrayOfAttributes = New Array();
	For Each ArrayItem In StrSplit(StrByType, ",") Do
		ArrayOfAttributes.Add(StrReplace(TrimAll(ArrayItem), Chars.NBSp, ""));
	EndDo;
	
	For Each KeyValue In Result Do
		AttrName = TrimAll(KeyValue.Key);
		If Not ValueIsFilled(AttrName) Then
			Continue;
		EndIf;
		If ArrayOfAttributes.Find(AttrName) = Undefined Then
			Result[AttrName] = Undefined;
		EndIf;
	EndDo;
	Return Result;
EndFunction

// Cash Payment
Function ClearByTransactionTypeCashPaymentOptions() Export
	Return GetChainLinkOptions("TransactionType,
		|BasisDocument,
		|Partner,
		|PlanningTransactionBasis,
		|Agreement,
		|LegalNameContract,
		|Payee,
		|Order,
		|RetailCustomer,
		|Employee");
EndFunction

Function ClearByTransactionTypeCashPaymentExecute(Options) Export
	Result = New Structure();
	Result.Insert("BasisDocument"            , Options.BasisDocument);
	Result.Insert("Partner"                  , Options.Partner);
	Result.Insert("PlanningTransactionBasis" , Options.PlanningTransactionBasis);
	Result.Insert("Agreement"                , Options.Agreement);
	Result.Insert("LegalNameContract"        , Options.LegalNameContract);
	Result.Insert("Payee"                    , Options.Payee);
	Result.Insert("Order"                    , Options.Order);
	Result.Insert("RetailCustomer"           , Options.RetailCustomer);
	Result.Insert("Employee"                 , Options.Employee);

	Outgoing_CashTransferOrder = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CashTransferOrder");
	Outgoing_CurrencyExchange  = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CurrencyExchange");
	Outgoing_PaymentToVendor   = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.PaymentToVendor");
	Outgoing_ReturnToCustomer  = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.ReturnToCustomer");
	Outgoing_CustomerAdvance     = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CustomerAdvance");
	Outgoing_EmployeeCashAdvance = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.EmployeeCashAdvance");
	Outgoing_SalaryPayment       = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.SalaryPayment");

	// list of properties which not needed clear
	// PlanningTransactionBasis, BasisDocument, Order - clearing always
	If Options.TransactionType = Outgoing_CashTransferOrder Then
		StrByType = "";
	ElsIf Options.TransactionType = Outgoing_CurrencyExchange Or Options.TransactionType = Outgoing_EmployeeCashAdvance Then
		StrByType = "
		|Partner"; 
	ElsIf Options.TransactionType = Outgoing_CustomerAdvance Then
		StrByType = "
		|RetailCustomer";
	ElsIf Options.TransactionType = Outgoing_PaymentToVendor Or Options.TransactionType = Outgoing_ReturnToCustomer Then
		StrByType = "
		|Partner,
		|Agreement,
		|Payee,
		|LegalNameContract";
	ElsIf Options.TransactionType = Outgoing_SalaryPayment Then
		StrByType = "
		|Employee";
	EndIf;
	
	ArrayOfAttributes = New Array();
	For Each ArrayItem In StrSplit(StrByType, ",") Do
		ArrayOfAttributes.Add(StrReplace(TrimAll(ArrayItem), Chars.NBSp, ""));
	EndDo;
	
	For Each KeyValue In Result Do
		AttrName = TrimAll(KeyValue.Key);
		If Not ValueIsFilled(AttrName) Then
			Continue;
		EndIf;
		If ArrayOfAttributes.Find(AttrName) = Undefined Then
			Result[AttrName] = Undefined;
		EndIf;
	EndDo;
	Return Result;
EndFunction

// Cash Receipt
Function ClearByTransactionTypeCashReceiptOptions() Export
	Return GetChainLinkOptions("TransactionType,
		|CurrencyExchange,
		|BasisDocument,
		|Partner,
		|PlanningTransactionBasis,
		|Agreement,
		|LegalNameContract,
		|Payer,
		|AmountExchange,
		|Order,
		|MoneyTransfer,
		|RetailCustomer");
EndFunction

Function ClearByTransactionTypeCashReceiptExecute(Options) Export
	Result = New Structure();
	Result.Insert("CurrencyExchange"         , Options.CurrencyExchange);
	Result.Insert("BasisDocument"            , Options.BasisDocument);
	Result.Insert("Partner"                  , Options.Partner);
	Result.Insert("PlanningTransactionBasis" , Options.PlanningTransactionBasis);
	Result.Insert("Agreement"                , Options.Agreement);
	Result.Insert("LegalNameContract"        , Options.LegalNameContract);
	Result.Insert("Payer"                    , Options.Payer);
	Result.Insert("AmountExchange"           , Options.AmountExchange);
	Result.Insert("Order"                    , Options.Order);
	Result.Insert("MoneyTransfer"            , Options.MoneyTransfer);
	Result.Insert("RetailCustomer"           , Options.RetailCustomer);

	Incoming_CashTransferOrder   = PredefinedValue("Enum.IncomingPaymentTransactionType.CashTransferOrder");
	Incoming_CurrencyExchange    = PredefinedValue("Enum.IncomingPaymentTransactionType.CurrencyExchange");
	Incoming_PaymentFromCustomer = PredefinedValue("Enum.IncomingPaymentTransactionType.PaymentFromCustomer");
	Incoming_ReturnFromVendor    = PredefinedValue("Enum.IncomingPaymentTransactionType.ReturnFromVendor");
	Incoming_CashIn              = PredefinedValue("Enum.IncomingPaymentTransactionType.CashIn");
	Incoming_CustomerAdvance     = PredefinedValue("Enum.IncomingPaymentTransactionType.CustomerAdvance");
	Incoming_EmployeeCashAdvance = PredefinedValue("Enum.IncomingPaymentTransactionType.EmployeeCashAdvance");
	
	// list of properties which not needed clear
	// PlanningTransactionBasis, BasisDocument, Order, MoneyTransfer - clearing always
	If Options.TransactionType = Incoming_CashTransferOrder Then
		StrByType = "";
	ElsIf Options.TransactionType = Incoming_CashIn Then
		StrByType = "";
	ElsIf Options.TransactionType = Incoming_CurrencyExchange Then
		StrByType = "
		|Partner, 
		|CurrencyExchange,
		|AmountExchange";
	ElsIf Options.TransactionType = Incoming_PaymentFromCustomer Or Options.TransactionType = Incoming_ReturnFromVendor Then
		StrByType = "
		|Partner,
		|Agreement,
		|Payer,
		|LegalNameContract";
	ElsIf Options.TransactionType = Incoming_CustomerAdvance Then
		StrByType = "
		|RetailCustomer";
	ElsIf Options.TransactionType = Incoming_EmployeeCashAdvance Then
		StrByType = "
		|Partner";
	EndIf;
	
	ArrayOfAttributes = New Array();
	For Each ArrayItem In StrSplit(StrByType, ",") Do
		ArrayOfAttributes.Add(StrReplace(TrimAll(ArrayItem), Chars.NBSp, ""));
	EndDo;
	
	For Each KeyValue In Result Do
		AttrName = TrimAll(KeyValue.Key);
		If Not ValueIsFilled(AttrName) Then
			Continue;
		EndIf;
		If ArrayOfAttributes.Find(AttrName) = Undefined Then
			Result[AttrName] = Undefined;
		EndIf;
	EndDo;
	Return Result;
EndFunction

// Outgoing payment order
Function ClearByTransactionTypeOutgoingPaymentOrderOptions() Export
	Return GetChainLinkOptions("TransactionType,
		|Partner,
		|PartnerBankAccount,
		|Payee,
		|BasisDocument");
EndFunction

Function ClearByTransactionTypeOutgoingPaymentOrderExecute(Options) Export
	Result = New Structure();
	Result.Insert("Partner"                  , Options.Partner);
	Result.Insert("PartnerBankAccount"       , Options.PartnerBankAccount);
	Result.Insert("Payee"                    , Options.Payee);
	Result.Insert("BasisDocument"            , Options.BasisDocument);

	Outgoing_EmployeeCashAdvance = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.EmployeeCashAdvance");
	Outgoing_PaymentToVendor     = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.PaymentToVendor");

	// list of properties which not needed clear
	// BasisDocument - clearing always
	If Options.TransactionType = Outgoing_EmployeeCashAdvance Then
		StrByType = "
		|PaymentList.Partner";
	ElsIf Options.TransactionType = Outgoing_PaymentToVendor Then
		StrByType = "
		|PaymentList.Partner,
		|PaymentList.PartnerBankAccount,
		|PaymentList.Payee";
	EndIf;
		
	ArrayOfAttributes = New Array();
	For Each ArrayItem In StrSplit(StrByType, ",") Do
		ArrayOfAttributes.Add(StrReplace(TrimAll(ArrayItem), Chars.NBSp, ""));
	EndDo;
	
	For Each KeyValue In Result Do
		AttrName = TrimAll(KeyValue.Key);
		If Not ValueIsFilled(AttrName) Then
			Continue;
		EndIf;
		If ArrayOfAttributes.Find(AttrName) = Undefined Then
			Result[AttrName] = Undefined;
		EndIf;
	EndDo;
	Return Result;
EndFunction

// Cash Expense-Revenue
Function ClearByTransactionTypeCashExpenseRevenueOptions() Export
	Return GetChainLinkOptions("TransactionType,
		|Partner,
		|OtherCompany");
EndFunction

Function ClearByTransactionTypeCashExpenseRevenueExecute(Options) Export
	Result = New Structure();
	Result.Insert("Partner"      , Options.Partner);
	Result.Insert("OtherCompany" , Options.OtherCompany);

	Other_CashExpense = PredefinedValue("Enum.CashExpenseTransactionTypes.OtherCompanyExpense");
	Other_CashRevenue = PredefinedValue("Enum.CashRevenueTransactionTypes.OtherCompanyRevenue");

	If Options.TransactionType = Other_CashExpense Or Options.TransactionType = Other_CashRevenue Then
		StrByType = "
		|Partner,
		|OtherCompany";
	EndIf;
		
	ArrayOfAttributes = New Array();
	For Each ArrayItem In StrSplit(StrByType, ",") Do
		ArrayOfAttributes.Add(StrReplace(TrimAll(ArrayItem), Chars.NBSp, ""));
	EndDo;
	
	For Each KeyValue In Result Do
		AttrName = TrimAll(KeyValue.Key);
		If Not ValueIsFilled(AttrName) Then
			Continue;
		EndIf;
		If ArrayOfAttributes.Find(AttrName) = Undefined Then
			Result[AttrName] = Undefined;
		EndIf;
	EndDo;
	Return Result;
EndFunction

#EndRegion

#Region GENERATE_NEW_HEADER_UUID

Function GenerateNewUUIDOptions() Export
	Return GetChainLinkOptions("Ref, CurrentUUID");
EndFunction

Function GenerateNewUUIDExecute(Options) Export
	If ValueIsFilled(Options.Ref) Then
		Return Options.CurrentUUID;
	EndIf;
	Return New UUID();
EndFunction

#EndRegion

#Region LOAD_TABLE

Function LoadTableOptions() Export
	Return GetChainLinkOptions("TableAddress");
EndFunction

Function LoadTableExecute(Options) Export
	Return Options.TableAddress;
EndFunction

#EndRegion

#Region CALCULATE_COMMISSION

Function CalculateCommissionOptions() Export
	Return GetChainLinkOptions("Amount, Percent");
EndFunction

Function CalculateCommissionExecute(Options) Export
	Return Options.Amount * Options.Percent / 100;
EndFunction

#EndRegion

#Region CALCULATE_PAYMENT_LIST_COMMISSION

Function CalculatePaymentListCommissionOptions() Export
	Return GetChainLinkOptions("TotalAmount, CommissionPercent");
EndFunction

Function CalculatePaymentListCommissionExecute(Options) Export
	Return Options.TotalAmount * Options.CommissionPercent / 100;
EndFunction

#EndRegion

#Region GET_COMMISSION_PERCENT

Function GetCommissionPercentOptions() Export
	Return GetChainLinkOptions("PaymentType, BankTerm");
EndFunction

Function GetCommissionPercentExecute(Options) Export
	Return ModelServer_V2.GetCommissionPercentExecute(Options);
EndFunction

#EndRegion

#Region CALCULATE_PERCENT_BY_AMOUNT

Function CalculatePercentByAmountOptions() Export
	Return GetChainLinkOptions("Amount, Commission");
EndFunction

Function CalculatePercentByAmountExecute(Options) Export
	If Options.Amount = 0 Then
		Return 0;
	EndIf;
		
	Return 100 * Options.Commission / Options.Amount;
EndFunction

#EndRegion

#Region CALCULATE_PERCENT_COMMISSION_BY_AMOUNT

Function CalculateCommissionPercentByAmountOptions() Export
	Return GetChainLinkOptions("TotalAmount, Commission");
EndFunction

Function CalculateCommissionPercentByAmountExecute(Options) Export
	
	If Options.TotalAmount = 0 Then
		Return 0;
	EndIf;
	
	Return 100 * Options.Commission / Options.TotalAmount;
EndFunction

#EndRegion

Procedure InitEntryPoint(StepNames, Parameters)
	If Not Parameters.Property("ModelEnvironment") Then
		Environment = New Structure();
		Environment.Insert("FirstStepNames"  		, StepNames);
		Environment.Insert("StepNamesCounter"		, New Array());
		Environment.Insert("AlreadyExecutedSteps"   , New Map());
		Environment.Insert("ArrayOfLazySteps"       , New Array());
		Parameters.Insert("ModelEnvironment"		, Environment)
	EndIf;
EndProcedure

Procedure DestroyEntryPoint(Parameters)
	If Parameters.Property("ModelEnvironment") Then
		Parameters.Delete("ModelEnvironment");
	EndIf;
EndProcedure
