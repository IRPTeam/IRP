
#Region ENTRY_POINTS

Procedure EntryPoint(StepNames, Parameters, ExecuteLazySteps = False) Export
	InitEntryPoint(StepNames, Parameters);
	Parameters.ModelEnvironment.StepNamesCounter.Add(StepNames);

	If ValueIsFilled(StepNames) And StepNames <> "BindVoid" Then 

#IF Client THEN
		Transfer = New Structure("Form, Object", Parameters.Form, Parameters.Object);
		TransferFormToStructure(Transfer, Parameters);
	
		If Parameters.IsBackgroundJob = True Then
			
			If Parameters.ShowBackgroundJobSplash = True Then
				
				Splash = OpenForm("CommonForm.BackgroundJobSplash",
					New Structure("BackgroundJobTitle", Parameters.BackgroundJobTitle),
					Transfer.Form, 
					New UUID(),,,,
					FormWindowOpeningMode.LockOwnerWindow);
				Transfer.Form.BackgroundJobSplash = Splash.UUID;
			EndIf;
					
			// run background task
			JobParameters = New Structure();
			JobParameters.Insert("FormUUID"         , Transfer.Form.UUID);
			JobParameters.Insert("StepNames"        , StepNames);
			JobParameters.Insert("Parameters"       , Parameters);
			JobParameters.Insert("ExecuteLazySteps" , ExecuteLazySteps);
	
			RunResult = ModelServer_V2.RunBackgroundJob(JobParameters);
			Transfer.Form.BackgroundJobUUID            = RunResult.BackgroundJobUUID; 
			Transfer.Form.BackgroundJobStorageAddress = RunResult.BackgroundJobStorageAddress;
			Transfer.Form._AttachIdleHandler();
			
			Splash.JobUUID = RunResult.BackgroundJobUUID;
		Else	
			ModelServer_V2.ServerEntryPoint(StepNames, Parameters, ExecuteLazySteps, True);
			TransferStructureToForm(Transfer, Parameters);
		EndIf;

#ELSE
	
		// Is server
		ModelServer_V2.ServerEntryPoint(StepNames, Parameters, ExecuteLazySteps, False);
	
#ENDIF
	
	EndIf;

	
	// if cache was initialized from this EntryPoint then ChainComplete
	If Parameters.ModelEnvironment.FirstStepNames = StepNames Or ExecuteLazySteps Then
		If Parameters.ModelEnvironment.ArrayOfLazySteps.Count() Then
			LazyStepNames = StrConcat(Parameters.ModelEnvironment.ArrayOfLazySteps, ",");
			Parameters.ModelEnvironment.ArrayOfLazySteps.Clear();
			EntryPoint(LazyStepNames, Parameters, True);
		Else	
			If Parameters.IsBackgroundJob = False Then
				ControllerClientServer_V2.OnChainComplete(Parameters);
				DestroyEntryPoint(Parameters);
			EndIf;
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
	Chain.Insert("DefaultVatRateInList"      , GetChainLink("DefaultVatRateInListExecute"));
	
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
	Chain.Insert("ClearByTransactionTypeCashExpense"  , GetChainLink("ClearByTransactionTypeCashExpenseExecute"));
	Chain.Insert("ClearByTransactionTypeCashRevenue"  , GetChainLink("ClearByTransactionTypeCashRevenueExecute"));
	
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
	Chain.Insert("ChangeRecordPurchasePricesByAgreement"   , GetChainLink("ChangeRecordPurchasePricesByAgreementExecute"));
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
	
	Chain.Insert("ChangeReceiveBranchByAccount" , GetChainLink("ChangeReceiveBranchByAccountExecute"));
	
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
	Chain.Insert("ChangeTaxVisible", GetChainLink("ChangeTaxVisibleExecute"));
	
	Chain.Insert("ChangeVatRate", GetChainLink("ChangeVatRateExecute"));
		
	Chain.Insert("Calculations" , GetChainLink("CalculationsExecute"));
	Chain.Insert("SimpleCalculations" , GetChainLink("SimpleCalculationsExecute"));
	Chain.Insert("UpdatePaymentTerms" , GetChainLink("UpdatePaymentTermsExecute"));
	
	Chain.Insert("ChangePartnerByRetailCustomer"   , GetChainLink("ChangePartnerByRetailCustomerExecute"));
	Chain.Insert("ChangeAgreementByRetailCustomer" , GetChainLink("ChangeAgreementByRetailCustomerExecute"));
	Chain.Insert("ChangeLegalNameByRetailCustomer" , GetChainLink("ChangeLegalNameByRetailCustomerExecute"));
	Chain.Insert("ChangeUsePartnerTransactionsByRetailCustomer" , GetChainLink("ChangeUsePartnerTransactionsByRetailCustomerExecute"));
	Chain.Insert("ChangePartnerByRetailCustomerAndTransactionType"   , GetChainLink("ChangePartnerByRetailCustomerAndTransactionTypeExecute"));
	Chain.Insert("ChangeLegalNameByRetailCustomerAndTransactionType" , GetChainLink("ChangeLegalNameByRetailCustomerAndTransactionTypeExecute"));

	Chain.Insert("ChangeExpenseTypeByItemKey" , GetChainLink("ChangeExpenseTypeByItemKeyExecute"));
	Chain.Insert("ChangeRevenueTypeByItemKey" , GetChainLink("ChangeRevenueTypeByItemKeyExecute"));
	
	Chain.Insert("ChangeReceiveAmountBySendAmount" , GetChainLink("ChangeReceiveAmountBySendAmountExecute"));
	
	Chain.Insert("CovertQuantityToQuantityInBaseUnit" , GetChainLink("CovertQuantityToQuantityInBaseUnitExecute"));
	
	Chain.Insert("CalculateDifferenceCount" , GetChainLink("CalculateDifferenceCountExecute"));

	Chain.Insert("ChangeCommissionPercentByBankTermAndPaymentType"	       , GetChainLink("ChangeCommissionPercentByBankTermAndPaymentTypeExecute"));
	Chain.Insert("ChangeAccountByBankTermAndPaymentType"	       , GetChainLink("ChangeAccountByBankTermAndPaymentTypeExecute"));
	Chain.Insert("ChangePartnerByBankTermAndPaymentType"	       , GetChainLink("ChangePartnerByBankTermAndPaymentTypeExecute"));
	Chain.Insert("ChangeLegalNameByBankTermAndPaymentType"	       , GetChainLink("ChangeLegalNameByBankTermAndPaymentTypeExecute"));
	Chain.Insert("ChangePartnerTermsByBankTermAndPaymentType"	   , GetChainLink("ChangePartnerTermsByBankTermAndPaymentTypeExecute"));
	Chain.Insert("ChangeLegalNameContractByBankTermAndPaymentType" , GetChainLink("ChangeLegalNameContractByBankTermAndPaymentTypeExecute"));
	Chain.Insert("ChangeBankTermByPaymentType" , GetChainLink("ChangeBankTermByPaymentTypeExecute"));
	Chain.Insert("ChangePaymentTypeByBankTerm" , GetChainLink("ChangePaymentTypeByBankTermExecute"));
	Chain.Insert("ChangeAccountByPaymentType"  , GetChainLink("ChangeAccountByPaymentTypeExecute"));
		
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
	Chain.Insert("ChangeExtraCostAmountByRatioByBillOfMaterials"    , GetChainLink("ChangeExtraCostAmountByRatioByBillOfMaterialsExecute"));
	Chain.Insert("ChangeExtraCostTaxAmountByRatioByBillOfMaterials" , GetChainLink("ChangeExtraCostTaxAmountByRatioByBillOfMaterialsExecute"));
	Chain.Insert("ChangeExtraDirectCostAmountByBillOfMaterials"     , GetChainLink("ChangeExtraDirectCostAmountByBillOfMaterialsExecute"));
	Chain.Insert("ChangeExtraDirectCostTaxAmountByBillOfMaterials"  , GetChainLink("ChangeExtraDirectCostTaxAmountByBillOfMaterialsExecute"));
	Chain.Insert("ChangeDurationOfProductionByBillOfMaterials" , GetChainLink("ChangeDurationOfProductionByBillOfMaterialsExecute"));
	
	Chain.Insert("ChangePlanningPeriodByDateAndBusinessUnit" , GetChainLink("ChangePlanningPeriodByDateAndBusinessUnitExecute"));
	Chain.Insert("ChangeProductionPlanningByPlanningPeriod"  , GetChainLink("ChangeProductionPlanningByPlanningPeriodExecute"));
	Chain.Insert("ChangeCurrentQuantityInProductions"        , GetChainLink("ChangeCurrentQuantityInProductionsExecute"));
	
	Chain.Insert("ChangeBeginDateByPlanningPeriod"  , GetChainLink("ChangeBeginDateByPlanningPeriodExecute"));
	Chain.Insert("ChangeEndDateByPlanningPeriod"    , GetChainLink("ChangeEndDateByPlanningPeriodExecute"));
	
	Chain.Insert("BillOfMaterialsListCalculations"           , GetChainLink("BillOfMaterialsListCalculationsExecute"));
	Chain.Insert("BillOfMaterialsListCalculationsCorrection" , GetChainLink("BillOfMaterialsListCalculationsCorrectionExecute"));
	Chain.Insert("MaterialsCalculations"                     , GetChainLink("MaterialsCalculationsExecute"));
	Chain.Insert("MaterialsRecalculateQuantity"              , GetChainLink("MaterialsRecalculateQuantityExecute"));
	
	Chain.Insert("ChangeTradeAgentFeeTypeByAgreement"           , GetChainLink("ChangeTradeAgentFeeTypeByAgreementExecute"));
	Chain.Insert("ChangeTradeAgentFeePercentByAgreement"        , GetChainLink("ChangeTradeAgentFeePercentByAgreementExecute"));
	Chain.Insert("ChangeTradeAgentFeePercentByAmount"           , GetChainLink("ChangeTradeAgentFeePercentByAmountExecute"));
	Chain.Insert("ChangeTradeAgentFeeAmountByTradeAgentFeeType" , GetChainLink("ChangeTradeAgentFeeAmountByTradeAgentFeeTypeExecute"));

	Chain.Insert("ChangeisControlCodeStringByItem" , GetChainLink("ChangeisControlCodeStringByItemExecute"));
	Chain.Insert("ChangeFinancialMovementTypeByPaymentType" , GetChainLink("ChangeFinancialMovementTypeByPaymentTypeExecute"));
	
	Chain.Insert("ChangeInventoryOriginByItemKey" , GetChainLink("ChangeInventoryOriginByItemKeyExecute"));
	Chain.Insert("ChangeConsignorByItemKey"       , GetChainLink("ChangeConsignorByItemKeyExecute"));
	
	Chain.Insert("ChangeExpenseTypeByAccrualDeductionType", GetChainLink("ChangeExpenseTypeByAccrualDeductionTypeExecute"));
	Chain.Insert("ChangeCourierByTransactionType"        , GetChainLink("ChangeCourierByTransactionTypeExecute"));
	Chain.Insert("ChangeShipmentModeByTransactionType"   , GetChainLink("ChangeShipmentModeByTransactionTypeExecute"));
	
	Chain.Insert("ChangeResponsiblePersonSenderByFixedAsset" , GetChainLink("ChangeResponsiblePersonSenderByFixedAssetExecute"));
	Chain.Insert("ChangeBranchByFixedAsset"      , GetChainLink("ChangeBranchByFixedAssetExecute"));
	Chain.Insert("ChangeProfitLossCenterSenderByFixedAsset"      , GetChainLink("ChangeProfitLossCenterSenderByFixedAssetExecute"));
	
	Chain.Insert("ChangePositionByEmployee"         , GetChainLink("ChangePositionByEmployeeExecute"));	
	Chain.Insert("ChangeEmployeeScheduleByEmployee" , GetChainLink("ChangeEmployeeScheduleByEmployeeExecute"));
	Chain.Insert("ChangeProfitLossCenterByEmployee" , GetChainLink("ChangeProfitLossCenterByEmployeeExecute"));
	Chain.Insert("ChangeBranchByEmployee"           , GetChainLink("ChangeBranchByEmployeeExecute"));
	Chain.Insert("ChangeAccrualTypeByCompany" , GetChainLink("ChangeAccrualTypeByCompanyExecute"));
	Chain.Insert("ChangeSalaryByPosition"     , GetChainLink("ChangeSalaryByPositionExecute"));
	Chain.Insert("ChangeSalaryByPositionOrEmployee"       , GetChainLink("ChangeSalaryByPositionOrEmployeeExecute"));
	Chain.Insert("ChangeAccrualTypeByPositionOrEmployee"  , GetChainLink("ChangeAccrualTypeByPositionOrEmployeeExecute"));
	Chain.Insert("ChangeSalaryBySalaryType", GetChainLink("ChangeSalaryBySalaryTypeExecute"));

	Chain.Insert("ChangePartnerChoiceList", GetChainLink("ChangePartnerChoiceListExecute"));
	
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
EndFunction

Function DefaultInventoryOriginExecute(Options) Export
	InventoryOrigin = ?(ValueIsFilled(Options.CurrentInventoryOrigin), Options.CurrentInventoryOrigin, 
		PredefinedValue("Enum.InventoryOriginTypes.OwnStocks"));
	Return InventoryOrigin;
EndFunction	

#EndRegion

#Region CHANGE_INVENTORY_ORIGIN_BY_ITEM_KEY

Function ChangeInventoryOriginByItemKeyOptions() Export
	Return GetChainLinkOptions("Company, Item, ItemKey, Object");
EndFunction

Function ChangeInventoryOriginByItemKeyExecute(Options) Export
	SerialLotNumber = Undefined;
	If CommonFunctionsClientServer.ObjectHasProperty(Options.Object, "SerialLotNumbers") Then
		SLNRows = Options.Object.SerialLotNumbers.FindRows(New Structure("Key", Options.Key));
		If SLNRows.Count() = 1 And ValueIsFilled(SLNRows[0].SerialLotNumber) Then
			SerialLotNumber = SLNRows[0].SerialLotNumber;
		EndIf;
	EndIf;
	
	Result = CommissionTradeServer.GetInventoryOriginAndConsignor(Options.Company, Options.Item, Options.ItemKey, SerialLotNumber);
	Return Result.InventoryOrigin;
EndFunction

#EndRegion

#Region CHANGE_CONSIGNOR_BY_ITEM_KEY

Function ChangeConsignorByItemKeyOptions() Export
	Return GetChainLinkOptions("Company, Item, ItemKey, Object");
EndFunction

Function ChangeConsignorByItemKeyExecute(Options) Export
	SerialLotNumber = Undefined;
	If CommonFunctionsClientServer.ObjectHasProperty(Options.Object, "SerialLotNumbers") Then
		SLNRows = Options.Object.SerialLotNumbers.FindRows(New Structure("Key", Options.Key));
		If SLNRows.Count() = 1 And ValueIsFilled(SLNRows[0].SerialLotNumber) Then
			SerialLotNumber = SLNRows[0].SerialLotNumber;
		EndIf;
	EndIf;
	
	Result = CommissionTradeServer.GetInventoryOriginAndConsignor(Options.Company, Options.Item, Options.ItemKey, SerialLotNumber);
	Return Result.Consignor;
EndFunction

#EndRegion

#Region ITEM_LIST_VAT_RATE

Function DefaultVatRateInListOptions() Export
	Return GetChainLinkOptions("CurrentVatRate, Date, Company, ItemKey, Agreement, TransactionType, DocumentName");
EndFunction

Function DefaultVatRateInListExecute(Options) Export
	
	
	_arrayOfTaxes = TaxesServer.GetTaxesInfo(
		Options.Date, 
		Options.Company, 
		Options.DocumentName, 
		Options.TransactionType, 
		PredefinedValue("Enum.TaxKind.VAT"));
	
	_visible = _arrayOfTaxes.Count() <> 0;
	If Not _visible Then
		Return Undefined;
	EndIf;
	
	If ValueIsFilled(Options.CurrentVatRate) Then
		Return Options.CurrentVatRate;
	EndIf;
		
	Parameters = New Structure();
	Parameters.Insert("Date"    , Options.Date);
	Parameters.Insert("Company" , Options.Company);
	Parameters.Insert("ItemKey"         , Options.ItemKey);
	Parameters.Insert("Agreement"       , Options.Agreement);
	Parameters.Insert("TransactionType" , Options.TransactionType);
	TaxRate = TaxesServer.GetVatRateByPriority(Parameters); 
	Return TaxRate;
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
	Return GetChainLinkOptions("TransactionType, Account, CurrentTransitAccount, SendCurrency, ReceiveCurrency");
EndFunction

Function ChangeTransitAccountByAccountExecute(Options) Export
	IsCurrencyExchange = 
	Options.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CurrencyExchange")
	Or Options.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CurrencyExchange")
	Or Options.SendCurrency <> Options.ReceiveCurrency;
	
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
	Return GetChainLinkOptions("Agreement, DebtType, CurrentBasisDocument, CheckAgreementInBasisDocument");
EndFunction

Function ChangeBasisDocumentByAgreementExecute(Options) Export
	
	If Options.CheckAgreementInBasisDocument = False Then
		CheckAgreementInBasisDocument = False;
	Else
		CheckAgreementInBasisDocument = True;
	EndIf;
	
	If Not ValueIsFilled(Options.Agreement) Then
		Return Undefined;
	EndIf;
	
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(Options.Agreement);
	
	If AgreementInfo.ApArPostingDetail <> PredefinedValue("Enum.ApArPostingDetail.ByDocuments") Then
		Return Undefined;
	EndIf;
	
	If CheckAgreementInBasisDocument
		And ValueIsFilled(Options.CurrentBasisDocument)
		And Not ServiceSystemServer.GetObjectAttribute(Options.CurrentBasisDocument, "Agreement") = Options.Agreement Then
		Return Undefined;
	EndIf;
	
	If ValueIsFilled(Options.DebtType) Then
		If Options.DebtType = PredefinedValue("Enum.DebtTypes.AdvanceCustomer")
			Or Options.DebtType = PredefinedValue("Enum.DebtTypes.AdvanceVendor") Then
			Return Undefined;
		EndIf;
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

#Region CHANGE_LEGAL_NAME_BY_RETAIL_CUSTOMER_AND_TRANSACTION_TYPE

Function ChangeLegalNameByRetailCustomerAndTransactionTypeOptions() Export
	Return GetChainLinkOptions("RetailCustomer, TransactionType");
EndFunction

Function ChangeLegalNameByRetailCustomerAndTransactionTypeExecute(Options) Export
	If Options.TransactionType = PredefinedValue("Enum.RetailGoodsReceiptTransactionTypes.ReturnFromCustomer") Then
		RetailCustomerInfo = CatRetailCustomersServer.GetRetailCustomerInfo(Options.RetailCustomer);
		Return RetailCustomerInfo.LegalName;
	EndIf;
	Return Undefined;
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
	
	If Options.TransactionType = PredefinedValue("Enum.RetailGoodsReceiptTransactionTypes.CourierDelivery")
		Or Options.TransactionType = PredefinedValue("Enum.RetailGoodsReceiptTransactionTypes.Pickup") Then
		Return Undefined;
	ElsIf Options.TransactionType = PredefinedValue("Enum.RetailGoodsReceiptTransactionTypes.ReturnFromCustomer") Then
		Return Options.Partner;
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

#Region CHANGE_PARTNER_BY_RETAIL_CUSTOMER_AND_TRANSACTION_TYPE

Function ChangePartnerByRetailCustomerAndTransactionTypeOptions() Export
	Return GetChainLinkOptions("RetailCustomer, TransactionType");
EndFunction

Function ChangePartnerByRetailCustomerAndTransactionTypeExecute(Options) Export
	If Options.TransactionType = PredefinedValue("Enum.RetailGoodsReceiptTransactionTypes.ReturnFromCustomer") Then	
		RetailCustomerInfo = CatRetailCustomersServer.GetRetailCustomerInfo(Options.RetailCustomer);
		Return RetailCustomerInfo.Partner;
	EndIf;
	Return Undefined;
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
	Return GetChainLinkOptions("Company, Partner, Agreement, CurrentDate, AgreementType, TransactionType, DebtType");
EndFunction

Function ChangeAgreementByPartnerExecute(Options) Export
	If ValueIsFilled(Options.TransactionType) Then
		Options.AgreementType = ModelServer_V2.GetAgreementTypeByTransactionType(Options.TransactionType);
	ElsIf ValueIsFilled(Options.DebtType) Then
		Options.AgreementType = ModelServer_V2.GetAgreementTypeByDebtType(Options.DebtType);
	EndIf;
	Options.Insert("AllAgreements", True);
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

#Region CHANGE_RECORD_PURCHASE_PRICES_BY_AGREEMENT

Function ChangeRecordPurchasePricesByAgreementOptions() Export
	Return GetChainLinkOptions("Agreement, CurrentRecordPurchasePrices");
EndFunction

Function ChangeRecordPurchasePricesByAgreementExecute(Options) Export
	If Not ValueIsFilled(Options.Agreement) Then
		Return Options.CurrentRecordPurchasePrices;
	EndIf;
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(Options.Agreement);
	Return AgreementInfo.RecordPurchasePrices;
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
		If DataFromBasis <> Undefined And DataFromBasis.Count() 
			And DataFromBasis[0].ItemList.Count() And DataFromBasis[0].SpecialOffers.Count() Then
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
	If TypeOf(Price) = Type("Number") Then
		Price = Int(Price *100)/100;
	EndIf;
	
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
	ExpenseType = CatExpenseAndRevenueTypesServer.GetExpenseType(Options.Company, Options.ItemKey);
	Return ExpenseType;
EndFunction

#EndRegion

#Region CHANGE_REVENUE_TYPE_BY_ITEMKEY

Function ChangeRevenueTypeByItemKeyOptions() Export
	Return GetChainLinkOptions("Company, ItemKey");
EndFunction

Function ChangeRevenueTypeByItemKeyExecute(Options) Export
	RevenueType = CatExpenseAndRevenueTypesServer.GetRevenueType(Options.Company, Options.ItemKey);
	Return RevenueType;
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
	Return GetChainLinkOptions("Quantity, QuantityBOM, TransactionType");
EndFunction

Function ChangeIsManualChangedByQuantityExecute(Options) Export	
	If Options.TransactionType <> PredefinedValue("Enum.ProductionTransactionTypes.Produce") Then
		Return False;
	EndIf;
	
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
	Return GetChainLinkOptions("Date, BusinessUnit, TransactionType");
EndFunction

Function ChangePlanningPeriodByDateAndBusinessUnitExecute(Options) Export
	If ValueIsFilled(Options.TransactionType) 
		And (Options.TransactionType) <> PredefinedValue("Enum.ProductionTransactionTypes.Produce") Then
		Return Undefined;
	EndIf;
	
	_Date = ?(ValueIsFilled(Options.Date), Options.Date, CommonFunctionsServer.GetCurrentSessionDate());
	PlanningPeriod = ModelServer_V2.GetPlanningPeriod(_Date, Options.BusinessUnit);
	Return PlanningPeriod;
EndFunction

#EndRegion

#Region CHANGE_PRODUCTION_PLANNING_BY_PLANNING_PERIOD

Function ChangeProductionPlanningByPlanningPeriodOptions() Export
	Return GetChainLinkOptions("Company, BusinessUnit, PlanningPeriod, CurrentProductionPlanning, TransactionType");
EndFunction

Function ChangeProductionPlanningByPlanningPeriodExecute(Options) Export
	If ValueIsFilled(Options.TransactionType) 
		And Options.TransactionType <> PredefinedValue("Enum.ProductionTransactionTypes.Produce") Then
		Return Undefined;
	EndIf;
	
	If ValueIsFilled(Options.CurrentProductionPlanning) Then
		Return Options.CurrentProductionPlanning;
	EndIf;
	Return ModelServer_V2.GetDocumentProductionPlanning(Options.Company, Options.BusinessUnit, Options.PlanningPeriod);
EndFunction

#EndRegion

#Region CHANGE_BILL_OF_MATERIALS_BY_ITEM_KEY		

Function ChangeBillOfMaterialsByItemKeyOptions() Export
	Return GetChainLinkOptions("ItemKey, CurrentBillOfMaterials, TransactionType, BusinessUnit");
EndFunction

Function ChangeBillOfMaterialsByItemKeyExecute(Options) Export
	If ValueIsFilled(Options.TransactionType) 
		And Options.TransactionType <> PredefinedValue("Enum.ProductionTransactionTypes.Produce") Then
		Return Undefined;
	EndIf;
	
	If ValueIsFilled(Options.CurrentBillOfMaterials) Then
		Return Options.CurrentBillOfMaterials;
	EndIf;
	Return ModelServer_V2.GetBillOfMaterialsByItemKey(Options.ItemKey, Options.BusinessUnit);
EndFunction

#EndRegion

#Region CHANGE_EXTRA_COST_AMOUNT_BY_RATIO_BY_BILL_OF_MATERIALS		

Function ChangeExtraCostAmountByRatioByBillOfMaterialsOptions() Export
	Return GetChainLinkOptions("BillOfMaterials");
EndFunction

Function ChangeExtraCostAmountByRatioByBillOfMaterialsExecute(Options) Export
	If Not ValueIsFilled(Options.BillOfMaterials) Then
		Return 0;
	EndIf;
	
	Return CommonFunctionsServer.GetRefAttribute(Options.BillOfMaterials, "ExtraCostAmountByRatio");
EndFunction

#EndRegion

#Region CHANGE_EXTRA_COST_TAX_AMOUNT_BY_RATIO_BY_BILL_OF_MATERIALS		

Function ChangeExtraCostTaxAmountByRatioByBillOfMaterialsOptions() Export
	Return GetChainLinkOptions("BillOfMaterials");
EndFunction

Function ChangeExtraCostTaxAmountByRatioByBillOfMaterialsExecute(Options) Export
	If Not ValueIsFilled(Options.BillOfMaterials) Then
		Return 0;
	EndIf;
	
	Return CommonFunctionsServer.GetRefAttribute(Options.BillOfMaterials, "ExtraCostTaxAmountByRatio");
EndFunction

#EndRegion

#Region CHANGE_EXTRA_DIRECT_COST_AMOUNT_BY_BILL_OF_MATERIALS		

Function ChangeExtraDirectCostAmountByBillOfMaterialsOptions() Export
	Return GetChainLinkOptions("BillOfMaterials");
EndFunction

Function ChangeExtraDirectCostAmountByBillOfMaterialsExecute(Options) Export
	If Not ValueIsFilled(Options.BillOfMaterials) Then
		Return 0;
	EndIf;
	
	Return CommonFunctionsServer.GetRefAttribute(Options.BillOfMaterials, "ExtraDirectCostAmount");
EndFunction

#EndRegion

#Region CHANGE_EXTRA_DIRECT_COST_TAX_AMOUNT_BY_BILL_OF_MATERIALS		

Function ChangeExtraDirectCostTaxAmountByBillOfMaterialsOptions() Export
	Return GetChainLinkOptions("BillOfMaterials");
EndFunction

Function ChangeExtraDirectCostTaxAmountByBillOfMaterialsExecute(Options) Export
	If Not ValueIsFilled(Options.BillOfMaterials) Then
		Return 0;
	EndIf;
	
	Return CommonFunctionsServer.GetRefAttribute(Options.BillOfMaterials, "ExtraDirectCostTaxAmount");
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

#Region CHANGE_EXPENSE_TYPE_BY_ACCRUAL_DEDUCTION_TYPE

Function ChangeExpenseTypeByAccrualDeductionTypeOptions() Export
	Return GetChainLinkOptions("AccrualDeductionType, ExpenseType");
EndFunction

Function ChangeExpenseTypeByAccrualDeductionTypeExecute(Options) Export
	If ValueIsFilled(Options.AccrualDeductionType) Then
		ExpenseType = CommonFunctionsServer.GetRefAttribute(Options.AccrualDeductionType, "ExpenseType");
		If ValueIsFilled(ExpenseType) Then
			Return ExpenseType;
		EndIf;
	EndIf;
	Return Options.ExpenseType;
EndFunction

#EndRegion

#Region CHANGE_COURIER_BY_TRANSACTION_TYPE

Function ChangeCourierByTransactionTypeOptions() Export
	Return GetChainLinkOptions("TransactionType, CurrentCourier");
EndFunction

Function ChangeCourierByTransactionTypeExecute(Options) Export
	If Options.TransactionType = PredefinedValue("Enum.RetailShipmentConfirmationTransactionTypes.CourierDelivery")
		Or Options.TransactionType = PredefinedValue("Enum.RetailGoodsReceiptTransactionTypes.CourierDelivery") Then
		Return Options.CurrentCourier;
	EndIf;
	Return Undefined;
EndFunction

#EndRegion

#Region CHANGE_SHIPMENT_MODE_BY_TRANSACTION_TYPE

Function ChangeShipmentModeByTransactionTypeOptions() Export
	Return GetChainLinkOptions("TransactionType, CurrentShipmentMode");
EndFunction

Function ChangeShipmentModeByTransactionTypeExecute(Options) Export
	If Options.TransactionType = PredefinedValue("Enum.SalesTransactionTypes.RetailSales") Then
		Return Options.CurrentShipmentMode
	EndIf;
	Return Undefined;
EndFunction

#EndRegion

#Region CHANGE_RECEIVE_BRANCH_BY_ACCOUNT

Function ChangeReceiveBranchByAccountOptions() Export
	Return GetChainLinkOptions("Account, ReceiveBranch");
EndFunction

Function ChangeReceiveBranchByAccountExecute(Options) Export
	ReceiveBranch = CommonFunctionsServer.GetRefAttribute(Options.Account, "Branch");
	If ValueIsFilled(ReceiveBranch) Then
		Return ReceiveBranch;
	EndIf;
	Return Options.ReceiveBranch;
EndFunction

#EndRegion

#Region CHANGE_RESPONSIBLE_PERSON_BY_FIXED_ASSET
	
Function ChangeResponsiblePersonSenderByFixedAssetOptions() Export
	Return GetChainLinkOptions("FixedAsset, Company, Date");
EndFunction

Function ChangeResponsiblePersonSenderByFixedAssetExecute(Options) Export
	Result = DocFixedAssetTransferServer.GetFixedAssetLocation(Options.Date, Options.Company, Options.FixedAsset);
	Return Result.ResponsiblePerson;
EndFunction
	
#EndRegion

#Region CHANGE_BRANCH_BY_FIXED_ASSET

Function ChangeBranchByFixedAssetOptions() Export
	Return GetChainLinkOptions("FixedAsset, Company, Date");
EndFunction

Function ChangeBranchByFixedAssetExecute(Options) Export
	Result = DocFixedAssetTransferServer.GetFixedAssetLocation(Options.Date, Options.Company, Options.FixedAsset);
	Return Result.Branch;
EndFunction

#EndRegion

#Region CHANGE_PROFIT_LOSS_CENTER_SENDER_BY_FIXED_ASSET

Function ChangeProfitLossCenterSenderByFixedAssetOptions() Export
	Return GetChainLinkOptions("FixedAsset, Company, Date");
EndFunction

Function ChangeProfitLossCenterSenderByFixedAssetExecute(Options) Export
	Result = DocFixedAssetTransferServer.GetFixedAssetLocation(Options.Date, Options.Company, Options.FixedAsset);
	Return Result.ProfitLossCenter;
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
	Return GetChainLinkOptions("ArrayOfStoresInList, DocumentRef");
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
		UserSettings = UserSettingsServer.GetUserSettingsForClientModule(Options.DocumentRef);
		For Each Setting In UserSettings Do
			If Setting.AttributeName = "ItemList.Store" Then
				Return Setting.Value; // store from UserSettings
			EndIf;
		EndDo;	
	EndIf;  
    Return Undefined;
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

#Region PARTNERS

Function ChangePartnerChoiceListOptions() Export
	Return GetChainLinkOptions("DocumentName, Company, TransactionType");
EndFunction

Function ChangePartnerChoiceListExecute(Options) Export
	Return CatPartnersServer.GetChoiceListForDocument(Options.DocumentName, Options.Company, Options.TransactionType);
EndFunction

#EndRegion

#Region TAXES

Function ChangeTaxVisibleOptions() Export
	Return GetChainLinkOptions("Date, Company, DocumentName, TransactionType");
EndFunction

Function ChangeTaxVisibleExecute(Options) Export
	_arrayOfTaxes = TaxesServer.GetTaxesInfo(
		Options.Date, 
		Options.Company, 
		Options.DocumentName, 
		Options.TransactionType, 
		PredefinedValue("Enum.TaxKind.VAT"));
	
	_visible = _arrayOfTaxes.Count() <> 0;
	_choiceList = New Array();
	
	If _visible Then
		_choiceList = TaxesServer.GetTaxRatesByTax(_arrayOfTaxes[0].Tax); 
	EndIf;
	
	Return New Structure("TaxVisible, TaxChoiceList", _visible, _choiceList);
EndFunction

Function ChangeVatRateOptions() Export
	Return GetChainLinkOptions("Date, 
		|Company, 
		|Consignor, 
		|TransactionType, 
		|Agreement, 
		|ItemKey, 
		|InventoryOrigin,
		|DocumentName");
EndFunction

Function ChangeVatRateExecute(Options) Export
	
	_arrayOfTaxes = TaxesServer.GetTaxesInfo(
		Options.Date, 
		Options.Company, 
		Options.DocumentName, 
		Options.TransactionType, 
		PredefinedValue("Enum.TaxKind.VAT"));
		
	If _arrayOfTaxes.Count() = 0 Then
		Return Undefined;
	EndIf;
	
	_vat = TaxesServer.GetVatRef();
	If ValueIsFilled(Options.InventoryOrigin) 
		And Options.InventoryOrigin = PredefinedValue("Enum.InventoryOriginTypes.ConsignorStocks")
		And ValueIsFilled(Options.Consignor) Then
			
		Parameters = New Structure();
		Parameters.Insert("Date"    , Options.Date);
		Parameters.Insert("Company" , Options.Consignor);
		Parameters.Insert("Tax"     , _vat);
		TaxRate = TaxesServer.GetTaxRateByCompany(Parameters);			
		Return TaxRate;
	EndIf;
		
	Parameters = New Structure();
	Parameters.Insert("Date"    , Options.Date);
	Parameters.Insert("Company" , Options.Company);
	Parameters.Insert("Tax"     , _vat);
	Parameters.Insert("ItemKey"         , Options.ItemKey);
	Parameters.Insert("Agreement"       , Options.Agreement);
	Parameters.Insert("TransactionType" , Options.TransactionType);		
	TaxRate = TaxesServer.GetVatRateByPriority(Parameters);
	Return TaxRate;
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
		|ItemKey, Unit, Quantity, KeyOwner, TransactionType");
EndFunction

Function MaterialsCalculationsExecute(Options) Export
	Result = New Structure();
	Result.Insert("Materials", Options.Materials);
	
	If ValueIsFilled(Options.TransactionType) 
		And (Options.TransactionType) <> PredefinedValue("Enum.ProductionTransactionTypes.Produce") Then
			For Each Row In Result.Materials Do
				Row.ItemBOM         = Undefined;
				Row.ItemKeyBOM      = Undefined;
				Row.UnitBOM         = Undefined;
				Row.QuantityBOM     = Undefined;
				Row.IsManualChanged = Undefined;
			EndDo;
		Return Result;
	EndIf;
	
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
	AmountOptions.Insert("OffersBonus"    , 0);
	AmountOptions.Insert("TaxAmount"       , 0);
	AmountOptions.Insert("TotalAmount"     , 0);
	Options.Insert("AmountOptions", AmountOptions);
	
	PriceOptions = New Structure("PriceType, Price, Quantity, QuantityInBaseUnit");
	Options.Insert("PriceOptions", PriceOptions);
	
	TaxOptions = New Structure("PriceIncludeTax, VatRate, UseManualAmount");
	Options.Insert("TaxOptions", TaxOptions);
	
	QuantityOptions = New Structure("ItemKey, Unit, Quantity, QuantityInBaseUnit, QuantityIsFixed");
	Options.Insert("QuantityOptions", QuantityOptions);
	
	// SpecialOffers columns: Key, Offer, Amount, Percent, Bonus, AddInfo
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

Function CalculationsExecute(Options) Export
	IsCalculatedRow = Not Options.AmountOptions.DontCalculateRow;

	Result = New Structure();
	Result.Insert("NetAmount"    , Options.AmountOptions.NetAmount);
	Result.Insert("OffersAmount" , Options.AmountOptions.OffersAmount);
	Result.Insert("OffersBonus"  , Options.AmountOptions.OffersBonus);
	Result.Insert("TaxAmount"    , Options.AmountOptions.TaxAmount);
	Result.Insert("TotalAmount"  , Options.AmountOptions.TotalAmount);
	Result.Insert("Price"        , Options.PriceOptions.Price);
	Result.Insert("QuantityInBaseUnit" , Options.QuantityOptions.QuantityInBaseUnit);
	Result.Insert("QuantityIsFixed"    , Options.QuantityOptions.QuantityIsFixed);
	Result.Insert("SpecialOffers", New Array());
	
	For Each OfferRow In Options.OffersOptions.SpecialOffers Do
		NewOfferRow = OffersServer.GetOffersTableRow();
		FillPropertyValues(NewOfferRow, OfferRow);
		Result.SpecialOffers.Add(NewOfferRow);
	EndDo;
	
	UserManualAmountsFromBasisDocument = New Array();
	
	OffersFromBaseDocument = False;
	If Options.RecalculateSpecialOffers.Enable Or Options.CalculateSpecialOffers.Enable Or Options.CalculateTaxAmount.Enable Then
		For Each Row In Options.RowIDInfo Do
			Scaling = New Structure();
			Scaling.Insert("QuantityInBaseUnit", Options.PriceOptions.QuantityInBaseUnit);
			Scaling.Insert("ItemKey" , Options.ItemKey);
			Scaling.Insert("Unit"    , Options.Unit);
			DataFromBasis = RowIDInfoServer.GetAllDataFromBasis(Options.Ref, Row.Basis, Row.BasisKey, Row.RowID, Row.CurrentStep, Scaling);
			If DataFromBasis <> Undefined And DataFromBasis.Count() Then 
				// Offers
				If (Options.RecalculateSpecialOffers.Enable Or Options.CalculateSpecialOffers.Enable) And DataFromBasis[0].SpecialOffers.Count() Then
					OffersFromBaseDocument = True;
					TotalOffers = 0;
					TotalBonus = 0;
					For Each OfferRow In Result.SpecialOffers Do
						For Each BasisRow In DataFromBasis[0].SpecialOffers Do
							If OfferRow.Offer = BasisRow.Offer Then 
								TotalOffers = TotalOffers + BasisRow.Amount;
								TotalBonus = TotalBonus + BasisRow.Bonus;
								OfferRow.Amount = BasisRow.Amount;
								OfferRow.Bonus = BasisRow.Bonus;
							EndIf;
						EndDo;
					EndDo;
					Result.OffersAmount = TotalOffers;
					Result.OffersBonus = TotalBonus;
				EndIf; // Offers
				
			EndIf;
		EndDo;
	EndIf;
	
	// RecalculateSpecialOffers
	If Options.RecalculateSpecialOffers.Enable And Not OffersFromBaseDocument Then
		For Each OfferRow In Options.OffersOptions.SpecialOffersCache Do
			Amount = 0;
			Bonus = 0;
			If Options.PriceOptions.Quantity = OfferRow.Quantity Then
				Amount = OfferRow.Amount;
				Bonus = OfferRow.Bonus;
			Else
				Amount = (OfferRow.Amount / OfferRow.Quantity) * Options.PriceOptions.Quantity;
				Bonus = (OfferRow.Bonus / OfferRow.Quantity) * Options.PriceOptions.Quantity;
			EndIf;
			For Each ResultOfferRow In Result.SpecialOffers Do
				If OfferRow.Key = ResultOfferRow.Key And OfferRow.Offer = ResultOfferRow.Offer Then
					ResultOfferRow.Amount = Amount;
					ResultOfferRow.Bonus = Bonus;
				EndIf;
			EndDo;
		EndDo;
	EndIf;
	
	// CalculateSpecialOffers
	If Options.CalculateSpecialOffers.Enable And Not OffersFromBaseDocument Then
		TotalOffers = 0;
		TotalBonus = 0;
		For Each OfferRow In Result.SpecialOffers Do
			TotalOffers = TotalOffers + OfferRow.Amount;
			TotalBonus = TotalBonus + OfferRow.Bonus;
		EndDo;
		Result.OffersAmount = TotalOffers;
		Result.OffersBonus = TotalBonus;
	EndIf;
	
	// CalculateQuantityInBaseUnit
	If Options.CalculateQuantityInBaseUnit.Enable And (Options.QuantityOptions.QuantityIsFixed <> True) Then
		If Not ValueIsFilled(Options.QuantityOptions.ItemKey) Then
			UnitFactor = 0;
		Else
			UnitFactor = GetItemInfo.GetUnitFactor(Options.QuantityOptions.ItemKey, Options.QuantityOptions.Unit);
		EndIf;
		Result.QuantityInBaseUnit = Options.QuantityOptions.Quantity * UnitFactor;
	EndIf;
	
	If Options.TaxOptions.PriceIncludeTax <> Undefined Then
		If Options.TaxOptions.PriceIncludeTax Then
			
			If Options.CalculateTaxAmountReverse.Enable And IsCalculatedRow Then
				
				Result.TaxAmount = CalculateTaxAmount(Options.TaxOptions.VatRate, 
					Options.TaxOptions.PriceIncludeTax, 
					Result.TotalAmount, 
					Result.NetAmount, 
					True, Options.TaxOptions.UseManualAmount, Result.TaxAmount);
				
			EndIf;
			
			If Options.CalculatePriceByTotalAmount.Enable And IsCalculatedRow Then
				Result.Price = ?(Options.PriceOptions.Quantity = 0, 0, 
					(Result.TotalAmount / Options.PriceOptions.Quantity) + Result.OffersAmount / Options.PriceOptions.Quantity);  
			EndIf;
			
			If Options.CalculateTotalAmount.Enable And IsCalculatedRow Then
				Result.TotalAmount = CalculateTotalAmount_PriceIncludeTax(Options.PriceOptions, Result);
			EndIf;

			If Options.CalculateTaxAmount.Enable And IsCalculatedRow Then
				
				Result.TaxAmount = CalculateTaxAmount(Options.TaxOptions.VatRate, 
					Options.TaxOptions.PriceIncludeTax, 
					Result.TotalAmount, 
					Result.NetAmount, 
					False, Options.TaxOptions.UseManualAmount, Result.TaxAmount);
				
			EndIf;

			If Options.CalculateNetAmountAsTotalAmountMinusTaxAmount.Enable And IsCalculatedRow Then
				Result.NetAmount = CalculateNetAmount_PriceIncludeTax(Options.PriceOptions, Result);
			EndIf;

			If Options.CalculateNetAmount.Enable And IsCalculatedRow Then
				Result.NetAmount = CalculateNetAmount_PriceIncludeTax(Options.PriceOptions, Result);
			EndIf;
		Else
			If Options.CalculateTaxAmountReverse.Enable And IsCalculatedRow Then
				
				Result.TaxAmount = CalculateTaxAmount(Options.TaxOptions.VatRate, 
					Options.TaxOptions.PriceIncludeTax, 
					Result.TotalAmount, 
					Result.NetAmount, 
					True, Options.TaxOptions.UseManualAmount, Result.TaxAmount);
				
			EndIf;
			
			If Options.CalculatePriceByTotalAmount.Enable And IsCalculatedRow Then
				Result.Price = ?(Options.PriceOptions.Quantity = 0, 0, 
				((Result.TotalAmount - Result.TaxAmount) / Options.PriceOptions.Quantity)  + Result.OffersAmount / Options.PriceOptions.Quantity);
			EndIf;
			
			If Options.CalculateNetAmountAsTotalAmountMinusTaxAmount.Enable And IsCalculatedRow Then
				Result.NetAmount = CalculateNetAmountAsTotalAmountMinusTaxAmount_PriceNotIncludeTax(Options.PriceOptions, Result);
			EndIf;

			If Options.CalculateNetAmount.Enable And IsCalculatedRow Then
				Result.NetAmount = CalculateNetAmount_PriceNotIncludeTax(Options.PriceOptions, Result);
			EndIf;

			If Options.CalculateTaxAmount.Enable And IsCalculatedRow Then
				
				Result.TaxAmount = CalculateTaxAmount(Options.TaxOptions.VatRate, 
					Options.TaxOptions.PriceIncludeTax, 
					Result.TotalAmount, 
					Result.NetAmount, 
					False, Options.TaxOptions.UseManualAmount, Result.TaxAmount);
				
			EndIf;

			If Options.CalculateTotalAmount.Enable And IsCalculatedRow Then
				Result.TotalAmount = CalculateTotalAmount_PriceNotIncludeTax(Options.PriceOptions, Options.TaxOptions, Options.AmountOptions, Result);
			EndIf;
		EndIf;
	Else // PriceIncludeTax is Undefined
		If Options.CalculateTaxAmountReverse.Enable And IsCalculatedRow Then
			
			Result.TaxAmount = CalculateTaxAmount(Options.TaxOptions.VatRate, 
				Options.TaxOptions.PriceIncludeTax, 
				Result.TotalAmount, 
				Result.NetAmount, 
				True, Options.TaxOptions.UseManualAmount, Result.TaxAmount);
			
		EndIf;
		
		If Options.CalculatePriceByTotalAmount.Enable And IsCalculatedRow Then
			Result.Price = ?(Options.PriceOptions.Quantity = 0, 0, 
			((Result.TotalAmount - Result.TaxAmount) / Options.PriceOptions.Quantity) + Result.OffersAmount / Options.PriceOptions.Quantity);
		EndIf;
		
		If Options.CalculateTaxAmount.Enable And IsCalculatedRow Then
			
			Result.TaxAmount = CalculateTaxAmount(Options.TaxOptions.VatRate, 
				Options.TaxOptions.PriceIncludeTax, 
				Result.TotalAmount, 
				Result.NetAmount, 
				False, Options.TaxOptions.UseManualAmount, Result.TaxAmount);
			
		EndIf;

		If Options.CalculateTotalAmount.Enable And IsCalculatedRow Then
			Result.TotalAmount = CalculateTotalAmount_PriceNotIncludeTax(Options.PriceOptions, Options.TaxOptions, Options.AmountOptions, Result);
		EndIf;

		If Options.CalculateTaxAmountByNetAmount.Enable And IsCalculatedRow Then

			Result.TaxAmount =  CalculateTaxAmount(Options.TaxOptions.VatRate, 
				Options.TaxOptions.PriceIncludeTax, 
				Result.TotalAmount, 
				Result.NetAmount, 
				False, Options.TaxOptions.UseManualAmount, Result.TaxAmount);
			
		EndIf;

		If Options.CalculateTaxAmountByTotalAmount.Enable And IsCalculatedRow Then
			
			Result.TaxAmount = CalculateTaxAmount(Options.TaxOptions.VatRate, 
				Options.TaxOptions.PriceIncludeTax, 
				Result.TotalAmount, 
				Result.NetAmount, 
				False, Options.TaxOptions.UseManualAmount, Result.TaxAmount);
				
		EndIf;

		If Options.CalculateNetAmountAsTotalAmountMinusTaxAmount.Enable And IsCalculatedRow Then
			Result.NetAmount = CalculateNetAmount_PriceIncludeTax(Options.PriceOptions, Result);
		EndIf;

		If Options.CalculateNetAmountByTotalAmount.Enable And IsCalculatedRow Then
			Result.NetAmount = CalculateNetAmount_PriceIncludeTax(Options.PriceOptions, Result);
		EndIf;

		If Options.CalculateTotalAmountByNetAmount.Enable And IsCalculatedRow Then
			Result.TotalAmount = CalculateTotalAmount_PriceNotIncludeTax(Options.PriceOptions, Options.TaxOptions, Options.AmountOptions, Result);
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

Function CalculateTotalAmount_PriceNotIncludeTax(PriceOptions, TaxOptions, AmountOptions, Result)
	If Not ValueIsFilled(TaxOptions.VatRate) Then
		Return Result.NetAmount;
	EndIf;
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
	Return Result.TotalAmount - Result.TaxAmount;
EndFunction

Function _CalculateAmount(PriceOptions, Result)
	If PriceOptions.Quantity <> Undefined Then
		Return Result.Price * PriceOptions.Quantity;
	EndIf;
	Return Result.TotalAmount;
EndFunction

Function CalculateTaxAmount(RateRef, PriceIncludeTax, TotalAmount, NetAmount, Reverse, UseManualAmount, ManualTaxAmount)
	If UseManualAmount = True Then
		Return ManualTaxAmount;
	EndIf;
	
	If Not ValueIsFilled(RateRef) Then
		Rate = 0;
	Else	
		Rate = CommonFunctionsServer.GetRefAttribute(RateRef, "Rate");
	EndIf;
	
	TaxAmount = 0;
	TaxRate = Rate / 100;
	If Reverse Then
		TaxAmount = TotalAmount * TaxRate / (TaxRate + 1);
	Else
		If PriceIncludeTax = True Then
			TaxAmount = TotalAmount * TaxRate / (TaxRate + 1);
		Else
			TaxAmount = NetAmount * TaxRate;
		EndIf;
	EndIf;
	Return Round(TaxAmount, 2);
EndFunction

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
	Return GetChainLinkOptions("PlanningTransactionBasis, 
		|Ref, 
		|Company, 
		|Account, 
		|Currency, 
		|TotalAmount,
		|ReceiptingAccount,
		|ReceiptingBranch,
		|FinancialMovementType");		
EndFunction

Function FillByPTBBankPaymentExecute(Options) Export
	Result = New Structure();
	Result.Insert("Account"     , Options.Account);
	Result.Insert("Company"     , Options.Company);
	Result.Insert("Currency"    , Options.Currency);
	Result.Insert("TotalAmount" , Options.TotalAmount);
	Result.Insert("ReceiptingAccount" , Options.ReceiptingAccount);
	Result.Insert("ReceiptingBranch"  , Options.ReceiptingBranch);
	Result.Insert("FinancialMovementType"  , Options.FinancialMovementType);
	
	If ValueIsFilled(Options.PlanningTransactionBasis) Then
		If TypeOf(Options.PlanningTransactionBasis) = Type("DocumentRef.CashTransferOrder") Then
			OrderInfo = DocCashTransferOrderServer.GetInfoForFillingBankPayment(Options.PlanningTransactionBasis);
			Result.Account  = OrderInfo.Account;
			Result.Company  = OrderInfo.Company;
			Result.Currency = OrderInfo.Currency;
			Result.ReceiptingAccount = OrderInfo.ReceiptingAccount;
			Result.ReceiptingBranch  = OrderInfo.ReceiptingBranch;
			Result.FinancialMovementType  = OrderInfo.SendFinancialMovementType;
			
			If Not ValueIsFilled(Result.TotalAmount) Then
				ArrayOfDocs = New Array();
				ArrayOfDocs.Add(Options.PlanningTransactionBasis);
				ArrayOfBalance = DocBankPaymentServer.GetDocumentTable_CashTransferOrder_ForClient(ArrayOfDocs, Options.Ref);
				If ArrayOfBalance.Count() Then
					Amount = ArrayOfBalance[0].Amount;
					Result.TotalAmount = ?(ValueIsFilled(Amount), Amount, 0);
				EndIf;
			EndIf;
			
			Return Result;
		EndIf;
		
		If TypeOf(Options.PlanningTransactionBasis) = Type("DocumentRef.ChequeBondTransactionItem") Then
			OrderInfo = DocChequeBondTransactionServer.GetInfoForFillingBankDocument(Options.PlanningTransactionBasis);
			Result.Account     = OrderInfo.Account;
			Result.Company     = OrderInfo.Company;
			Result.Currency    = OrderInfo.Currency;
			If Not ValueIsFilled(Result.TotalAmount) Then
				Result.TotalAmount = OrderInfo.Amount;
			EndIf;
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
		|AmountExchange,
		|SendingAccount,
		|SendingBranch,
		|FinancialMovementType");
EndFunction

Function FillByPTBBankReceiptExecute(Options) Export
	Result = New Structure();
	Result.Insert("Account"         , Options.Account);
	Result.Insert("Company"         , Options.Company);
	Result.Insert("Currency"        , Options.Currency);
	Result.Insert("CurrencyExchange", Options.CurrencyExchange);
	Result.Insert("TotalAmount"     , Options.TotalAmount);
	Result.Insert("AmountExchange"  , Options.AmountExchange);
	Result.Insert("SendingAccount" , Options.SendingAccount);
	Result.Insert("SendingBranch"  , Options.SendingBranch);
	Result.Insert("FinancialMovementType"  , Options.FinancialMovementType);
	
	If ValueIsFilled(Options.PlanningTransactionBasis) Then
		If TypeOf(Options.PlanningTransactionBasis) = Type("DocumentRef.CashTransferOrder") Then
			OrderInfo = DocCashTransferOrderServer.GetInfoForFillingBankReceipt(Options.PlanningTransactionBasis);
			Result.Account  = OrderInfo.Account;
			Result.Company  = OrderInfo.Company;
			Result.Currency = OrderInfo.Currency;
			Result.CurrencyExchange = OrderInfo.CurrencyExchange;
			Result.SendingAccount = OrderInfo.SendingAccount;
			Result.SendingBranch  = OrderInfo.SendingBranch;
			Result.FinancialMovementType  = OrderInfo.ReceiveFinancialMovementType;
			
			
			ArrayOfDocs = New Array();
			ArrayOfDocs.Add(Options.PlanningTransactionBasis);
			ArrayOfBalance = DocBankReceiptServer.GetDocumentTable_CashTransferOrder_ForClient(ArrayOfDocs, Options.Ref);
			If ArrayOfBalance.Count() Then
				BalanceRow = ArrayOfBalance[0];
				If Not ValueIsFilled(Result.TotalAmount) Then
					Result.TotalAmount     = ?(ValueIsFilled(BalanceRow.Amount), BalanceRow.Amount, 0);
				EndIf;
				Result.AmountExchange = ?(ValueIsFilled(BalanceRow.AmountExchange), BalanceRow.AmountExchange, 0);
			EndIf;
			Return Result;
		EndIf;
		
		If TypeOf(Options.PlanningTransactionBasis) = Type("DocumentRef.ChequeBondTransactionItem") Then
			OrderInfo = DocChequeBondTransactionServer.GetInfoForFillingBankDocument(Options.PlanningTransactionBasis);
			Result.Account     = OrderInfo.Account;
			Result.Company     = OrderInfo.Company;
			Result.Currency    = OrderInfo.Currency;
			If Not ValueIsFilled(Result.TotalAmount) Then
				Result.TotalAmount = OrderInfo.Amount;
			EndIf;
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
		|TotalAmount,
		|ReceiptingAccount,
		|ReceiptingBranch,
		|FinancialMovementType");
EndFunction

Function FillByPTBCashPaymentExecute(Options) Export
	Result = New Structure();
	Result.Insert("Account"     , Options.Account);
	Result.Insert("Company"     , Options.Company);
	Result.Insert("Currency"    , Options.Currency);
	Result.Insert("Partner"     , Options.Partner);
	Result.Insert("TotalAmount" , Options.TotalAmount);
	Result.Insert("ReceiptingAccount" , Options.ReceiptingAccount);
	Result.Insert("ReceiptingBranch"  , Options.ReceiptingBranch);
	Result.Insert("FinancialMovementType"  , Options.FinancialMovementType);
	
	If ValueIsFilled(Options.PlanningTransactionBasis)
		And TypeOf(Options.PlanningTransactionBasis) = Type("DocumentRef.CashTransferOrder") Then
			OrderInfo = DocCashTransferOrderServer.GetInfoForFillingCashPayment(Options.PlanningTransactionBasis);
			Result.Account  = OrderInfo.CashAccount;
			Result.Company  = OrderInfo.Company;
			Result.Currency = OrderInfo.Currency;
			Result.ReceiptingAccount = OrderInfo.ReceiptingAccount;
			Result.ReceiptingBranch  = OrderInfo.ReceiptingBranch;
			Result.FinancialMovementType  = OrderInfo.SendFinancialMovementType;
			
			ArrayOfDocs = New Array();
			ArrayOfDocs.Add(Options.PlanningTransactionBasis);
			ArrayOfBalance = DocCashPaymentServer.GetDocumentTable_CashTransferOrder_ForClient(ArrayOfDocs, Options.Ref);
			If ArrayOfBalance.Count() Then
				BalanceRow = ArrayOfBalance[0]; 
				If Not ValueIsFilled(Result.TotalAmount) Then
					Result.TotalAmount = ?(ValueIsFilled(BalanceRow.Amount), BalanceRow.Amount, 0);
				EndIf;
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
		|AmountExchange,
		|SendingAccount,
		|SendingBranch,
		|FinancialMovementType");
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
	Result.Insert("SendingAccount" , Options.SendingAccount);
	Result.Insert("SendingBranch"  , Options.SendingBranch);
	Result.Insert("FinancialMovementType"  , Options.FinancialMovementType);

	If ValueIsFilled(Options.PlanningTransactionBasis)
		And TypeOf(Options.PlanningTransactionBasis) = Type("DocumentRef.CashTransferOrder") Then
			OrderInfo = DocCashTransferOrderServer.GetInfoForFillingCashReceipt(Options.PlanningTransactionBasis);
			Result.Account  = OrderInfo.CashAccount;
			Result.Company  = OrderInfo.Company;
			Result.Currency = OrderInfo.Currency;
			Result.CurrencyExchange = OrderInfo.CurrencyExchange;
			Result.SendingAccount = OrderInfo.SendingAccount;
			Result.SendingBranch  = OrderInfo.SendingBranch;
			Result.FinancialMovementType  = OrderInfo.ReceiveFinancialMovementType;
			
			ArrayOfDocs = New Array();
			ArrayOfDocs.Add(Options.PlanningTransactionBasis);
			ArrayOfBalance = DocCashReceiptServer.GetDocumentTable_CashTransferOrder_ForClient(ArrayOfDocs);
			If ArrayOfBalance.Count() Then
				BalanceRow = ArrayOfBalance[0];
				If Not ValueIsFilled(Result.TotalAmount) Then
					Result.TotalAmount    = ?(ValueIsFilled(BalanceRow.Amount), BalanceRow.Amount, 0);
				EndIf;
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
		|Employee,
		|PaymentPeriod,
		|CalculationType,
		|ReceiptingAccount,
		|ReceiptingBranch,
		|Project,
		|ExpenseType,
		|ProfitLossCenter,
		|AdditionalAnalytic");
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
	Result.Insert("PaymentPeriod"            , Options.PaymentPeriod);
	Result.Insert("CalculationType"          , Options.Calculationtype);
	Result.Insert("ReceiptingAccount"        , Options.ReceiptingAccount);
	Result.Insert("ReceiptingBranch"         , Options.ReceiptingBranch);
	Result.Insert("Project"                  , Options.Project);
	Result.Insert("ExpenseType"              , Options.ExpenseType);
	Result.Insert("ProfitLossCenter"         , Options.ProfitLossCenter);
	Result.Insert("AdditionalAnalytic"       , Options.AdditionalAnalytic);
		
	Outgoing_CashTransferOrder = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CashTransferOrder");
	Outgoing_CurrencyExchange  = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CurrencyExchange");
	Outgoing_PaymentToVendor   = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.PaymentToVendor");
	Outgoing_ReturnToCustomer  = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.ReturnToCustomer");
	Outgoing_ReturnToCustomerByPOS  = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.ReturnToCustomerByPOS");
	Outgoing_PaymentByCheque     = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.PaymentByCheque");
	Outgoing_RetailCustomerAdvance     = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.RetailCustomerAdvance");
	Outgoing_EmployeeCashAdvance = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.EmployeeCashAdvance");
	Outgoing_SalaryPayment       = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.SalaryPayment");
	Outgoing_OtherPartner        = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.OtherPartner");
	Outgoing_OtherExpense        = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.OtherExpense");
	
	// list of properties which not needed clear
	// PlanningTransactionBasis, BasisDocument, Order - clearing always
	If Options.TransactionType = Outgoing_CashTransferOrder Then
		StrByType = "
		|ReceiptingAccount,
		|ReceiptingBranch";
	ElsIf Options.TransactionType = Outgoing_PaymentByCheque Then
		StrByType = "";
	ElsIf Options.TransactionType = Outgoing_CurrencyExchange Then
		StrByType = "
		|ReceiptingAccount,
		|ReceiptingBranch,
		|TransitAccount";
	ElsIf Options.TransactionType = Outgoing_PaymentToVendor 
		Or Options.TransactionType = Outgoing_ReturnToCustomer
		Or Options.TransactionType = Outgoing_ReturnToCustomerByPOS Then
		
		StrByType = "
		|Agreement,
		|Payee,
		|LegalNameContract";
					
		PartnerType = ModelServer_V2.GetPartnerTypeByTransactionType(Options.TransactionType);
		If (PartnerType = "Vendor" And CommonFunctionsServer.GetRefAttribute(Options.Partner, PartnerType))
			Or (PartnerType = "Customer" And CommonFunctionsServer.GetRefAttribute(Options.Partner, PartnerType)) Then	 
			StrByType = StrByType + ", 
			|Partner";
		EndIf;
		
		If Options.TransactionType = Outgoing_ReturnToCustomerByPOS Then
			StrByType = StrByType + ", 
			|PaymentType,
			|PaymentTerminal,
			|BankTerm";
		EndIf;
		
		If Options.TransactionType = Outgoing_PaymentToVendor 
			Or Options.TransactionType = Outgoing_ReturnToCustomer Then
			StrByType = StrByType + ", Project";	
		EndIf;
		
	ElsIf Options.TransactionType = Outgoing_OtherPartner Then
		StrByType = "
		|Agreement,
		|Payee,
		|LegalNameContract";
		
		PartnerType = ModelServer_V2.GetPartnerTypeByTransactionType(Options.TransactionType);
		If PartnerType = "Other" And CommonFunctionsServer.GetRefAttribute(Options.Partner, PartnerType) Then
			StrByType = StrByType + ", 
			|Partner";
		EndIf;
	ElsIf Options.TransactionType = Outgoing_RetailCustomerAdvance Then
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
		|Employee,
		|PaymentPeriod,
		|CalculationType"; 
	ElsIf Options.TransactionType = Outgoing_OtherExpense Then
		StrByType = "
		|ExpenseType,
		|ProfitLossCenter,
		|AdditionalAnalytic";
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
		|RetailCustomer,
		|RevenueType,
		|SendingAccount,
		|SendingBranch,
		|Project,
		|ProfitLossCenter,
		|ExpenseType,
		|AdditionalAnalytic,
		|CommissionPercent,
		|Commission,
		|CommissionFinancialMovementType,
		|Employee,
		|PaymentPeriod,
		|CalculationType");		
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
	Result.Insert("RetailCustomer"           , Options.RetailCustomer);
	Result.Insert("RevenueType"              , Options.RevenueType);
	Result.Insert("SendingAccount"           , Options.SendingAccount);
	Result.Insert("SendingBranch"            , Options.SendingBranch);
	Result.Insert("Project"                  , Options.Project);
	Result.Insert("ProfitLossCenter"         , Options.ProfitLossCenter);
	Result.Insert("ExpenseType"              , Options.ExpenseType);
	Result.Insert("AdditionalAnalytic"       , Options.AdditionalAnalytic);
	Result.Insert("CommissionPercent"        , Options.CommissionPercent);
	Result.Insert("Commission"               , Options.Commission);
	Result.Insert("CommissionFinancialMovementType" , Options.CommissionFinancialMovementType);
	Result.Insert("Employee"                 , Options.Employee);
	Result.Insert("PaymentPeriod"            , Options.PaymentPeriod);
	Result.Insert("CalculationType"          , Options.Calculationtype);
		
	Incoming_CashTransferOrder   = PredefinedValue("Enum.IncomingPaymentTransactionType.CashTransferOrder");
	Incoming_CurrencyExchange    = PredefinedValue("Enum.IncomingPaymentTransactionType.CurrencyExchange");
	Incoming_PaymentFromCustomer = PredefinedValue("Enum.IncomingPaymentTransactionType.PaymentFromCustomer");
	Incoming_ReturnFromVendor    = PredefinedValue("Enum.IncomingPaymentTransactionType.ReturnFromVendor");
	Incoming_TransferFromPOS     = PredefinedValue("Enum.IncomingPaymentTransactionType.TransferFromPOS");
	Incoming_PaymentFromCustomerByPOS = PredefinedValue("Enum.IncomingPaymentTransactionType.PaymentFromCustomerByPOS");
	Incoming_ReceiptByCheque     = PredefinedValue("Enum.IncomingPaymentTransactionType.ReceiptByCheque");
	Incoming_RetailCustomerAdvance     = PredefinedValue("Enum.IncomingPaymentTransactionType.RetailCustomerAdvance");
	Incoming_EmployeeCashAdvance = PredefinedValue("Enum.IncomingPaymentTransactionType.EmployeeCashAdvance");
	Incoming_OtherIncome         = PredefinedValue("Enum.IncomingPaymentTransactionType.OtherIncome");
	Incoming_OtherPartner        = PredefinedValue("Enum.IncomingPaymentTransactionType.OtherPartner");
	Incoming_SalaryReturn        = PredefinedValue("Enum.IncomingPaymentTransactionType.SalaryReturn");
	
	// list of properties which not needed clear
	// PlanningTransactionBasis, BasisDocument, Order - clearing always
	If Options.TransactionType = Incoming_CashTransferOrder Then
		StrByType = "
		|SendingAccount,
		|SendingBranch,
	    |ProfitLossCenter,
		|ExpenseType,
		|AdditionalAnalytic,
		|CommissionPercent,
		|Commission,
		|CommissionFinancialMovementType";		
	ElsIf Options.TransactionType = Incoming_ReceiptByCheque Then
		StrByType = "";	
	ElsIf Options.TransactionType = Incoming_CurrencyExchange Then
		StrByType = "
		|SendingAccount,
		|SendingBranch,
		|TransitAccount, 
		|CurrencyExchange,
		|AmountExchange,
		|ProfitLossCenter,
		|ExpenseType,
		|AdditionalAnalytic,
		|CommissionPercent,
		|Commission,
		|CommissionFinancialMovementType";		
	ElsIf Options.TransactionType = Incoming_PaymentFromCustomer 
		Or Options.TransactionType = Incoming_ReturnFromVendor 
		Or Options.TransactionType = Incoming_PaymentFromCustomerByPOS Then
		
		StrByType = "
		|Agreement,
		|Payer,
		|LegalNameContract";
		
		If Options.TransactionType = Incoming_PaymentFromCustomerByPOS Then
			StrByType = StrByType + ", 
			|PaymentType,
			|PaymentTerminal,
			|BankTerm,
			|ProfitLossCenter,
		    |ExpenseType,
		    |AdditionalAnalytic,
		    |CommissionPercent,
		    |Commission,
		    |CommissionFinancialMovementType";			
		EndIf;
		
		If Options.TransactionType = Incoming_PaymentFromCustomer
			Or Options.TransactionType = Incoming_ReturnFromVendor Then
			
			StrByType = StrByType + ", Project";
		EndIf;
		
		PartnerType = ModelServer_V2.GetPartnerTypeByTransactionType(Options.TransactionType);
		If (PartnerType = "Vendor" And CommonFunctionsServer.GetRefAttribute(Options.Partner, PartnerType))
			Or (PartnerType = "Customer" And CommonFunctionsServer.GetRefAttribute(Options.Partner, PartnerType)) Then	 
			StrByType = StrByType + ", 
			|Partner";
		EndIf;
	ElsIf Options.TransactionType = Incoming_OtherPartner Then
		StrByType = "
		|Agreement,
		|Payer,
		|LegalNameContract";
		
		PartnerType = ModelServer_V2.GetPartnerTypeByTransactionType(Options.TransactionType);
		If PartnerType = "Other" And CommonFunctionsServer.GetRefAttribute(Options.Partner, PartnerType) Then
			StrByType = StrByType + ", 
			|Partner";
		EndIf;
	ElsIf Options.TransactionType = Incoming_TransferFromPOS Then
		StrByType = "
		|POSAccount,
		|ProfitLossCenter,
		|ExpenseType,
		|AdditionalAnalytic,
		|CommissionPercent,
		|Commission,
		|CommissionFinancialMovementType";		
	ElsIf Options.TransactionType = Incoming_RetailCustomerAdvance Then
		StrByType = "
		|RetailCustomer,
		|PaymentType,
		|PaymentTerminal,
		|BankTerm,
		|CommissionPercent,
		|Commission";
	ElsIf Options.TransactionType = Incoming_EmployeeCashAdvance Then
		StrByType = "
		|Partner";
	ElsIf Options.TransactionType = Incoming_OtherIncome Then
		StrByType = "
		|RevenueType,
		|ProfitLossCenter,
		|AdditionalAnalytic";
	ElsIf Options.TransactionType = Incoming_SalaryReturn Then
		StrByType = "
		|Employee,
		|PaymentPeriod,
		|CalculationType";
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
		|Employee,
		|PaymentPeriod,
		|CalculationType,
		|ReceiptingAccount,
		|ReceiptingBranch,
		|Project");
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
	Result.Insert("PaymentPeriod"            , Options.PaymentPeriod);
	Result.Insert("CalculationType"          , Options.CalculationType);
	Result.Insert("ReceiptingAccount"        , Options.ReceiptingAccount);
	Result.Insert("ReceiptingBranch"         , Options.ReceiptingBranch);
	Result.Insert("Project"                  , Options.Project);

	Outgoing_CashTransferOrder = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CashTransferOrder");
	Outgoing_CurrencyExchange  = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CurrencyExchange");
	Outgoing_PaymentToVendor   = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.PaymentToVendor");
	Outgoing_ReturnToCustomer  = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.ReturnToCustomer");
	Outgoing_RetailCustomerAdvance     = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.RetailCustomerAdvance");
	Outgoing_EmployeeCashAdvance = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.EmployeeCashAdvance");
	Outgoing_SalaryPayment       = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.SalaryPayment");
	Outgoing_OtherPartner        = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.OtherPartner");

	// list of properties which not needed clear
	// PlanningTransactionBasis, BasisDocument, Order - clearing always
	If Options.TransactionType = Outgoing_CashTransferOrder Then
		StrByType = "
		|ReceiptingAccount,
		|ReceiptingBranch";
	ElsIf Options.TransactionType = Outgoing_CurrencyExchange Then 
		StrByType = "
		|ReceiptingAccount,
		|ReceiptingBranch,
		|Partner";
	ElsIf Options.TransactionType = Outgoing_EmployeeCashAdvance Then
		StrByType = "
		|Partner"; 
	ElsIf Options.TransactionType = Outgoing_RetailCustomerAdvance Then
		StrByType = "
		|RetailCustomer";
	ElsIf Options.TransactionType = Outgoing_PaymentToVendor Or Options.TransactionType = Outgoing_ReturnToCustomer Then
		StrByType = "
		|Agreement,
		|Payee,
		|LegalNameContract,
		|Project";
		
		PartnerType = ModelServer_V2.GetPartnerTypeByTransactionType(Options.TransactionType);
		If (PartnerType = "Vendor" And CommonFunctionsServer.GetRefAttribute(Options.Partner, PartnerType))
			Or (PartnerType = "Customer" And CommonFunctionsServer.GetRefAttribute(Options.Partner, PartnerType)) Then	 
			StrByType = StrByType + ", 
			|Partner";
		EndIf;
	ElsIf Options.TransactionType = Outgoing_OtherPartner Then
		StrByType = "
		|Agreement,
		|Payee,
		|LegalNameContract";
		
		PartnerType = ModelServer_V2.GetPartnerTypeByTransactionType(Options.TransactionType);
		If PartnerType = "Other" And CommonFunctionsServer.GetRefAttribute(Options.Partner, PartnerType) Then
			StrByType = StrByType + ", 
			|Partner";
		EndIf;
	ElsIf Options.TransactionType = Outgoing_SalaryPayment Then
		StrByType = "
		|Employee,
		|PaymentPeriod,
		|CalculationType";
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
		|RetailCustomer,
		|SendingAccount,
		|SendingBranch,
		|Project,
		|Employee,
		|PaymentPeriod,
		|CalculationType");		
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
	Result.Insert("SendingAccount"           , Options.SendingAccount);
	Result.Insert("SendingBranch"            , Options.SendingBranch);
	Result.Insert("Project"                  , Options.Project);
	Result.Insert("Employee"                 , Options.Employee);
	Result.Insert("PaymentPeriod"            , Options.PaymentPeriod);
	Result.Insert("CalculationType"          , Options.CalculationType);
	
	Incoming_CashTransferOrder   = PredefinedValue("Enum.IncomingPaymentTransactionType.CashTransferOrder");
	Incoming_CurrencyExchange    = PredefinedValue("Enum.IncomingPaymentTransactionType.CurrencyExchange");
	Incoming_PaymentFromCustomer = PredefinedValue("Enum.IncomingPaymentTransactionType.PaymentFromCustomer");
	Incoming_ReturnFromVendor    = PredefinedValue("Enum.IncomingPaymentTransactionType.ReturnFromVendor");
	Incoming_CashIn              = PredefinedValue("Enum.IncomingPaymentTransactionType.CashIn");
	Incoming_RetailCustomerAdvance     = PredefinedValue("Enum.IncomingPaymentTransactionType.RetailCustomerAdvance");
	Incoming_EmployeeCashAdvance = PredefinedValue("Enum.IncomingPaymentTransactionType.EmployeeCashAdvance");
	Incoming_OtherPartner        = PredefinedValue("Enum.IncomingPaymentTransactionType.OtherPartner");
	Incoming_SalaryReturn        = PredefinedValue("Enum.IncomingPaymentTransactionType.SalaryReturn");
	
	// list of properties which not needed clear
	// PlanningTransactionBasis, BasisDocument, Order, MoneyTransfer - clearing always
	If Options.TransactionType = Incoming_CashTransferOrder Then
		StrByType = "
		|SendingAccount,
		|SendingBranch";
	ElsIf Options.TransactionType = Incoming_CashIn Then
		StrByType = "";
	ElsIf Options.TransactionType = Incoming_CurrencyExchange Then
		StrByType = "
		|SendingAccount,
		|SendingBranch,
		|Partner, 
		|CurrencyExchange,
		|AmountExchange";
	ElsIf Options.TransactionType = Incoming_PaymentFromCustomer Or Options.TransactionType = Incoming_ReturnFromVendor Then
		StrByType = "
		|Agreement,
		|Payer,
		|LegalNameContract,
		|Project";
		
		PartnerType = ModelServer_V2.GetPartnerTypeByTransactionType(Options.TransactionType);
		If (PartnerType = "Vendor" And CommonFunctionsServer.GetRefAttribute(Options.Partner, PartnerType))
			Or (PartnerType = "Customer" And CommonFunctionsServer.GetRefAttribute(Options.Partner, PartnerType)) Then	 
			StrByType = StrByType + ", 
			|Partner";
		EndIf;
	ElsIf Options.TransactionType = Incoming_OtherPartner Then
		StrByType = "
		|Agreement,
		|Payer,
		|LegalNameContract";	
		
		PartnerType = ModelServer_V2.GetPartnerTypeByTransactionType(Options.TransactionType);
		If PartnerType = "Other" And CommonFunctionsServer.GetRefAttribute(Options.Partner, PartnerType) Then
			StrByType = StrByType + ", 
			|Partner";
		EndIf;
	ElsIf Options.TransactionType = Incoming_RetailCustomerAdvance Then
		StrByType = "
		|RetailCustomer";
	ElsIf Options.TransactionType = Incoming_EmployeeCashAdvance Then
		StrByType = "
		|Partner";
	ElsIf Options.TransactionType = Incoming_SalaryReturn Then
		StrByType = "
		|Employee,
		|PaymentPeriod,
		|CalculationType";
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

// Cash Expense
Function ClearByTransactionTypeCashExpenseOptions() Export
	Return GetChainLinkOptions("TransactionType,
		|Partner,
		|Employee,
		|OtherCompany,
		|PaymentPeriod,
		|CalculationType,
		|ProfitLossCenter,
		|ExpenseType,
		|FinancialMovementTypeOtherCompany");
EndFunction

Function ClearByTransactionTypeCashExpenseExecute(Options) Export
	Result = New Structure();
	Result.Insert("Partner"       , Options.Partner);
	Result.Insert("Employee"      , Options.Employee);
	Result.Insert("OtherCompany"  , Options.OtherCompany);
	Result.Insert("PaymentPeriod" , Options.PaymentPeriod);
	Result.Insert("CalculationType"  , Options.CalculationType);
	Result.Insert("ProfitLossCenter" , Options.ProfitLossCenter);
	Result.Insert("ExpenseType"      , Options.ExpenseType);
	Result.Insert("FinancialMovementTypeOtherCompany" , Options.FinancialMovementTypeOtherCompany);

	CurrentCompanyCashExpense = PredefinedValue("Enum.CashExpenseTransactionTypes.CurrentCompanyExpense");
	OtherCurrentCashExpense   = PredefinedValue("Enum.CashExpenseTransactionTypes.OtherCompanyExpense");
	SalaryPayment      = PredefinedValue("Enum.CashExpenseTransactionTypes.SalaryPayment");
	
	If Options.TransactionType = CurrentCompanyCashExpense Then
		StrByType = "
		|ProfitLossCenter,
		|ExpenseType";
	ElsIf Options.TransactionType = OtherCurrentCashExpense Then
		StrByType = "
		|Partner,
		|OtherCompany,
		|ProfitLossCenter,
		|ExpenseType,
		|FinancialMovementTypeOtherCompany";
	ElsIf Options.TransactionType = SalaryPayment Then
		StrByType = "
		|Partner,
		|Employee,
		|OtherCompany,
		|PaymentPeriod,
		|CalculationType";
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

// Cash Revenue
Function ClearByTransactionTypeCashRevenueOptions() Export
	Return GetChainLinkOptions("TransactionType,
		|Partner,
		|OtherCompany");
EndFunction

Function ClearByTransactionTypeCashRevenueExecute(Options) Export
	Result = New Structure();
	Result.Insert("Partner"      , Options.Partner);
	Result.Insert("OtherCompany" , Options.OtherCompany);

	OtherCashRevenue = PredefinedValue("Enum.CashRevenueTransactionTypes.OtherCompanyRevenue");

	If Options.TransactionType = OtherCashRevenue Then
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
	Return GetChainLinkOptions("TotalAmount, CommissionPercent, TransactionType");
EndFunction

Function CalculatePaymentListCommissionExecute(Options) Export
	_CommissionPercent = 0;
	If ValueIsFilled(Options.CommissionPercent) Then
		_CommissionPercent = Options.CommissionPercent;
	EndIf;
	
	CommissionAmount = 0;
	If Options.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.RetailCustomerAdvance") Then
		CommissionAmount = Options.TotalAmount * _CommissionPercent / 100;
	Else
		CommissionAmount = (Options.TotalAmount/(1- _CommissionPercent/100)) - Options.TotalAmount;
	EndIf;
	
	Return CommissionAmount;
EndFunction

#EndRegion

#Region CHANGE_PERCENT_BY_BANK_TERM_AND_PAYMENT_TYPE

Function ChangeCommissionPercentByBankTermAndPaymentTypeOptions() Export
	Return GetChainLinkOptions("PaymentType, BankTerm, CurrentCommissionPercent, IsUserChange");
EndFunction

Function ChangeCommissionPercentByBankTermAndPaymentTypeExecute(Options) Export
	If Not Options.IsUserChange Then
		Return Options.CurrentCommissionPercent;
	EndIf;
	
	BankTermInfo = ModelServer_V2.GetBankTermInfo(Options.PaymentType, Options.BankTerm);
	Return BankTermInfo.Percent;
EndFunction

#EndRegion

#Region CHANGE_ACCOUNT_BY_BANK_TERM_AND_PAYMENT_TYPE

Function ChangeAccountByBankTermAndPaymentTypeOptions() Export
	Return GetChainLinkOptions("PaymentType, BankTerm, CurrentAccount");
EndFunction

Function ChangeAccountByBankTermAndPaymentTypeExecute(Options) Export
	_Type = CommonFunctionsServer.GetRefAttribute(Options.PaymentType, "Type");
	If _Type = PredefinedValue("Enum.PaymentTypes.Card") Then
		Return ModelServer_V2.GetBankTermInfo(Options.PaymentType, Options.BankTerm).Account;
	EndIf;
	Return Options.CurrentAccount;
EndFunction

#EndRegion

#Region CHANGE_PARTNER_BY_BANK_TERM_AND_PAYMENT_TYPE

Function ChangePartnerByBankTermAndPaymentTypeOptions() Export
	Return GetChainLinkOptions("PaymentType, BankTerm");
EndFunction

Function ChangePartnerByBankTermAndPaymentTypeExecute(Options) Export
	Return ModelServer_V2.GetBankTermInfo(Options.PaymentType, Options.BankTerm).Partner;
EndFunction

#EndRegion

#Region CHANGE_LEGAL_NAME_BY_BANK_TERM_AND_PAYMENT_TYPE

Function ChangeLegalNameByBankTermAndPaymentTypeOptions() Export
	Return GetChainLinkOptions("PaymentType, BankTerm");
EndFunction

Function ChangeLegalNameByBankTermAndPaymentTypeExecute(Options) Export
	Return ModelServer_V2.GetBankTermInfo(Options.PaymentType, Options.BankTerm).LegalName;
EndFunction

#EndRegion

#Region CHANGE_PARTNER_TERMS_BY_BANK_TERM_AND_PAYMENT_TYPE

Function ChangePartnerTermsByBankTermAndPaymentTypeOptions() Export
	Return GetChainLinkOptions("PaymentType, BankTerm");
EndFunction

Function ChangePartnerTermsByBankTermAndPaymentTypeExecute(Options) Export
	Return ModelServer_V2.GetBankTermInfo(Options.PaymentType, Options.BankTerm).PartnerTerms;
EndFunction

#EndRegion

#Region CHANGE_LEGAL_NAME_CONTRACT_BY_BANK_TERM_AND_PAYMENT_TYPE

Function ChangeLegalNameContractByBankTermAndPaymentTypeOptions() Export
	Return GetChainLinkOptions("PaymentType, BankTerm");
EndFunction

Function ChangeLegalNameContractByBankTermAndPaymentTypeExecute(Options) Export
	Return ModelServer_V2.GetBankTermInfo(Options.PaymentType, Options.BankTerm).LegalNameContract;
EndFunction

#EndRegion

#Region CHANGE_BANK_TERM_BY_PAYMENT_TYPE

Function ChangeBankTermByPaymentTypeOptions() Export
	Return GetChainLinkOptions("CurrentBankTerm, PaymentType, Branch");
EndFunction

Function ChangeBankTermByPaymentTypeExecute(Options) Export
	If Not ValueIsFilled(Options.PaymentType) Then
		Return Options.CurrentBankTerm;
	EndIf;
	ArrayOfRefs = ModelServer_V2.GetBankTermsByPaymentType(Options.PaymentType, Options.Branch);
	If ArrayOfRefs.Count() = 1 Then
		Return ArrayOfRefs[0];
	EndIf;
	If ArrayOfRefs.Find(Options.CurrentBankTerm) <> Undefined Then
		Return Options.CurrentBankTerm;
	EndIf;
	Return Undefined;
EndFunction

#EndRegion

#Region CHANGE_PAYMENT_TYPE_BY_BANK_TERM
	
Function ChangePaymentTypeByBankTermOptions() Export
	Return GetChainLinkOptions("CurrentPaymentType, BankTerm");
EndFunction

Function ChangePaymentTypeByBankTermExecute(Options) Export
	If Not ValueIsFilled(Options.BankTerm) Then
		Return Options.CurrentPaymentType;
	EndIf;
	ArrayOfRefs = ModelServer_V2.GetPaymentTypesByBankTerm(Options.BankTerm);
	If ArrayOfRefs.Count() = 1 Then
		Return ArrayOfRefs[0];
	EndIf;
	If ArrayOfRefs.Find(Options.CurrentPaymentType) <> Undefined Then
		Return Options.CurrentPaymentType;
	EndIf;
	Return Undefined;
EndFunction

#EndRegion

#Region CHANGE_ACCOUNT_BY_PAYMENT_TYPE

Function ChangeAccountByPaymentTypeOptions() Export
	Return GetChainLinkOptions("PaymentType, Workstation, BankTerm, CurrentAccount");
EndFunction

Function ChangeAccountByPaymentTypeExecute(Options) Export
	If Not ValueIsFilled(Options.PaymentType) Then
		Return Undefined;
	EndIf;
	
	_Type = CommonFunctionsServer.GetRefAttribute(Options.PaymentType, "Type");
	If _Type = PredefinedValue("Enum.PaymentTypes.Cash") Then
		Account = CommonFunctionsServer.GetRefAttribute(Options.Workstation, "CashAccount");
		If ValueIsFilled(Account) Then
			Return Account;
		EndIf; 
	ElsIf _Type = PredefinedValue("Enum.PaymentTypes.Card") Then
		Return ModelServer_V2.GetBankTermInfo(Options.PaymentType, Options.BankTerm).Account;
	EndIf;
	
	Return Options.CurrentAccount;
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
		
	CommissionPercent = 100 * Options.Commission / Options.Amount;
		
	Return CommissionPercent
EndFunction

#EndRegion

#Region CALCULATE_PERCENT_COMMISSION_BY_AMOUNT

Function CalculateCommissionPercentByAmountOptions() Export
	Return GetChainLinkOptions("TotalAmount, Commission, TransactionType");
EndFunction

Function CalculateCommissionPercentByAmountExecute(Options) Export
	
	If Options.TotalAmount = 0 Then
		Return 0;
	EndIf;
	
	_Commission = 0;
	If ValueIsFilled(Options.Commission) Then
		_Commission = Options.Commission;
	EndIf;
	
	CommissionPercent = 0;
	If Options.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.RetailCustomerAdvance") Then
		If ValueIsFilled(Options.TotalAmount) Then
			CommissionPercent = 100 * _Commission / Options.TotalAmount;
		EndIf;
	Else
		CommissionPercent = _Commission/(Options.TotalAmount + _Commission) * 100;
	EndIf;
	
	Return CommissionPercent;
EndFunction

#EndRegion

#Region CHANGE_IS_CONTROL_CODE_STRING_BY_ITEM

Function ChangeisControlCodeStringByItemOptions() Export
	Return GetChainLinkOptions("Item");
EndFunction

Function ChangeisControlCodeStringByItemExecute(Options) Export  
	Try
		Workstation = SessionParametersServer.GetSessionParameter("Workstation");
	Except
		Workstation = Undefined;
	EndTry;
	
	If ValueIsFilled(Workstation) And CommonFunctionsServer.GetRefAttribute(Workstation, "IgnoreCodeStringControl") Then
		Return False;
	Else
		Return CommonFunctionsServer.GetRefAttribute(Options.Item, "ControlCodeString");
	EndIf;
EndFunction

#EndRegion

#Region CHANGE_FINANCIAL_MOVEMENT_TYPE_BY_PAYMENT_TYPE

Function ChangeFinancialMovementTypeByPaymentTypeOptions() Export
	Return GetChainLinkOptions("PaymentType");
EndFunction

Function ChangeFinancialMovementTypeByPaymentTypeExecute(Options) Export
	If Not ValueIsFilled(Options.PaymentType) Then
		Return Undefined;
	EndIf;
	Return CommonFunctionsServer.GetRefAttribute(Options.PaymentType, "FinancialMovementType");
EndFunction

#EndRegion

#Region CHANGE_BEGIN_DATE_BY_PLANNING_PERIOD

Function ChangeBeginDateByPlanningPeriodOptions() Export
	Return GetChainLinkOptions("PlanningPeriod");
EndFunction

Function ChangeBeginDateByPlanningPeriodExecute(Options) Export
	If Not ValueIsFilled(Options.PlanningPeriod) Then
		Return Undefined;
	EndIf;
	Return CommonFunctionsServer.GetRefAttribute(Options.PlanningPeriod, "BeginDate");
EndFunction

#EndRegion

#Region CHANGE_END_DATE_BY_PLANNING_PERIOD

Function ChangeEndDateByPlanningPeriodOptions() Export
	Return GetChainLinkOptions("PlanningPeriod");
EndFunction

Function ChangeEndDateByPlanningPeriodExecute(Options) Export
	If Not ValueIsFilled(Options.PlanningPeriod) Then
		Return Undefined;
	EndIf;
	Return CommonFunctionsServer.GetRefAttribute(Options.PlanningPeriod, "EndDate");
EndFunction

#EndRegion

#Region CHANGE_POSITION_BY_EMPLOYEE

Function ChangePositionByEmployeeOptions() Export
	Return GetChainLinkOptions("Ref, Date, Company, Employee");
EndFunction

Function ChangePositionByEmployeeExecute(Options) Export
	Result = SalaryServer.GetEmployeeInfo(Options.Ref, Options.Date, Options.Company, Options.Employee);
	Return Result.Position;
EndFunction

#EndRegion

#Region CHANGE_EMPLOYEE_SCHEDULE_BY_EMPLOYEE

Function ChangeEmployeeScheduleByEmployeeOptions() Export
	Return GetChainLinkOptions("Ref, Date, Company, Employee");
EndFunction

Function ChangeEmployeeScheduleByEmployeeExecute(Options) Export
	Result = SalaryServer.GetEmployeeInfo(Options.Ref, Options.Date, Options.Company, Options.Employee);
	Return Result.EmployeeSchedule;
EndFunction

#EndRegion

#Region CHANGE_PROFIT_LOSS_CENTER_BY_EMPLOYEE

Function ChangeProfitLossCenterByEmployeeOptions() Export
	Return GetChainLinkOptions("Ref, Date, Company, Employee");
EndFunction

Function ChangeProfitLossCenterByEmployeeExecute(Options) Export
	Result = SalaryServer.GetEmployeeInfo(Options.Ref, Options.Date, Options.Company, Options.Employee);
	Return Result.ProfitLossCenter;
EndFunction

#EndRegion

#Region CHANGE_BRANCH_BY_EMPLOYEE

Function ChangeBranchByEmployeeOptions() Export
	Return GetChainLinkOptions("Ref, Date, Company, Employee");
EndFunction

Function ChangeBranchByEmployeeExecute(Options) Export
	Result = SalaryServer.GetEmployeeInfo(Options.Ref, Options.Date, Options.Company, Options.Employee);
	Return Result.Branch;
EndFunction

#EndRegion

#Region CHANGE_ACCRUAL_TYPE_BY_COMPANY

Function ChangeAccrualTypeByCompanyOptions() Export
	Return GetChainLinkOptions("Company");
EndFunction

Function ChangeAccrualTypeByCompanyExecute(Options) Export
	If Not ValueIsFilled(Options.Company) Then
		Return Undefined;
	EndIf;
	
	Return CommonFunctionsServer.GetRefAttribute(Options.Company, "SalaryBasicPayroll");
EndFunction

#EndRegion

#Region CHANGE_SALARY_BY_POSITION
	
Function ChangeSalaryByPositionOptions() Export
	Return GetChainLinkOptions("Ref, Date, Position, AccrualType");
EndFunction
	
Function ChangeSalaryByPositionExecute(Options) Export
	Result = SalaryServer.GetSalaryValue(Options.Ref, Options.Date, Options.Position, Options.AccrualType);
	Return Result;
EndFunction

#EndRegion

#Region CHANGE_SALARY_BY_POSITION_OR_PERSONAL_SALARY

Function ChangeSalaryByPositionOrEmployeeOptions() Export
	Return GetChainLinkOptions("Ref, Date, Employee, Position, AccrualType");
EndFunction
	
Function ChangeSalaryByPositionOrEmployeeExecute(Options) Export
	Result = SalaryServer.GetSalaryByPositionOrEmployee(Options.Ref, Options.Date, Options.Employee, Options.Position, Options.AccrualType);
	Return New Structure("Salary, PersonalSalary", Result.Salary, Result.PersonalSalary);
EndFunction

#EndRegion

#Region CHANGE_ACCRUAL_TYPE_BY_POSITION_OR_EMPLOYEE

Function ChangeAccrualTypeByPositionOrEmployeeOptions() Export
	Return GetChainLinkOptions("Ref, Date, Employee, Position");
EndFunction
	
Function ChangeAccrualTypeByPositionOrEmployeeExecute(Options) Export
	Result = SalaryServer.GetAccrualTypeByPositionOrEmployee(Options.Ref, Options.Date, Options.Employee, Options.Position);
	Return Result;
EndFunction

#EndRegion

#Region CHANGE_SALARY_BY_SALARY_TYPE

Function ChangeSalaryBySalaryTypeOptions() Export
	Return GetChainLinkOptions("SalaryType, CurrentSalary");
EndFunction
	
Function ChangeSalaryBySalaryTypeExecute(Options) Export
	If Options.SalaryType = PredefinedValue("Enum.SalaryTypes.Personal") Then
		Return Options.CurrentSalary;
	EndIf;
	
	Return Undefined;
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

Procedure DestroyEntryPoint(Parameters) Export
	If Parameters.Property("ModelEnvironment") Then
		Parameters.Delete("ModelEnvironment");
	EndIf;
EndProcedure
