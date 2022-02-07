
#Region ENTRY_POINTS

Procedure EntryPoint(StepsEnablerName, Parameters) Export
	InitEntryPoint(StepsEnablerName, Parameters);
	Parameters.ModelInveronment.StepsEnablerNameCounter.Add(StepsEnablerName);
	
#IF Client THEN
	Transfer = New Structure("Form, Object", Parameters.Form, Parameters.Object);
	If ValueIsFilled(Parameters.PropertyBeforeChange.Form.Names) Then
		// превращаем форму в структуру, что бы на сервере были доступны реквизиты формы, из них нужно читать данные
		TransferForm = New Structure(Parameters.PropertyBeforeChange.Form.Names);
		FillPropertyValues(TransferForm, Transfer.Form);
		Parameters.Form = TransferForm;
	Else
		Parameters.Form = Undefined;
	EndIf;
#ENDIF

	ModelServer_V2.ServerEntryPoint(StepsEnablerName, Parameters);
	
#IF Client THEN
	Parameters.Form   = Transfer.Form;
	Parameters.Object = Transfer.Object;
#ENDIF
	
	// проверяем что кэш был инициализирован из этой EntryPoint
	// и если это так и мы дошли до конца процедуры то значит что ChainComplete 
	If Parameters.ModelInveronment.FirstStepsEnablerName = StepsEnablerName Then
		Execute StrTemplate("%1.OnChainComplete(Parameters);", Parameters.ControllerModuleName);
		DestroyEntryPoint(Parameters);
	EndIf;
EndProcedure

Procedure ServerEntryPoint(StepsEnablerName, Parameters) Export
	Chain = GetChain();
	Execute StrTemplate("%1.%2(Parameters, Chain);", Parameters.ControllerModuleName, StepsEnablerName);
	ExecuteChain(Parameters, Chain);
EndProcedure

#EndRegion

#Region Chain

Function GetChainLink(ExecutorName)
	ChainLink = New Structure();
	ChainLink.Insert("Enable" , False);
	ChainLink.Insert("Options", New Array());
	ChainLink.Insert("Setter" , Undefined);
	ChainLink.Insert("ExecutorName", ExecutorName);
	Return ChainLink; 
EndFunction

Function GetChainLinkOptions(StrOptions)
	Options = New Structure();
	Options.Insert("Key");
	Options.Insert("StepsEnablerName"); // for debug only
	Options.Insert("DontExecuteIfExecutedBefore", False);
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

Function IsAlreadyExecutedStep(Parameters, Name, Key)
	For Each Step In Parameters.ModelInveronment.AlreadyExecutedSteps Do
		If Upper(Step.Name) = Upper(Name) And Upper(Step.Key) = Upper(Key) Then
			Return True;
		EndIf;
	EndDo;
	Return False;
EndFunction

Procedure ExecuteChain(Parameters, Chain)
	For Each ChainLink in Chain Do
		Name = ChainLink.Key;
		If Chain[Name].Enable Then
			Results = New Array();
			For Each Options In Chain[Name].Options Do
				If Options.DontExecuteIfExecutedBefore And IsAlreadyExecutedStep(Parameters, Name, Options.Key) Then
					Continue;
				EndIf;
				Result = Undefined;
				Execute StrTemplate("Result = %1(Options)", Chain[Name].ExecutorName);
				Results.Add(GetChainLinkResult(Options, Result));
				Parameters.ModelInveronment.AlreadyExecutedSteps.Add(New Structure("Name, Key", Name, Options.Key));
			EndDo;
			Execute StrTemplate("%1.%2(Parameters, Results);", Parameters.ControllerModuleName, Chain[Name].Setter);
		EndIf;
	EndDo;
EndProcedure

Function GetChain()
	Chain = New Structure();
	// Default.List
	Chain.Insert("DefaultStoreInList"        , GetChainLink("DefaultStoreInListExecute"));
	Chain.Insert("DefaultDeliveryDateInList" , GetChainLink("DefaultDeliveryDateInListExecute"));
	Chain.Insert("DefaultQuantityInList"     , GetChainLink("DefaultQuantityInListExecute"));
	
	// Empty.Header
	Chain.Insert("EmptyStoreInHeader"     , GetChainLink("EmptyStoreInHeaderExecute"));
	
	// Default.Header
	Chain.Insert("DefaultStoreInHeader"        , GetChainLink("DefaultStoreInHeaderExecute"));
	Chain.Insert("DefaultDeliveryDateInHeader" , GetChainLink("DefaultDeliveryDateInHeaderExecute"));
		
	// Changes
	Chain.Insert("ChangeManagerSegmentByPartner", GetChainLink("ChangeManagerSegmentByPartnerExecute"));
	Chain.Insert("ChangeLegalNameByPartner"     , GetChainLink("ChangeLegalNameByPartnerExecute"));
	Chain.Insert("ChangePartnerByLegalName"     , GetChainLink("ChangePartnerByLegalNameExecute"));
	Chain.Insert("ChangeAgreementByPartner"     , GetChainLink("ChangeAgreementByPartnerExecute"));
	
	Chain.Insert("ChangeCompanyByAgreement"     , GetChainLink("ChangeCompanyByAgreementExecute"));
	Chain.Insert("ChangeCurrencyByAgreement"    , GetChainLink("ChangeCurrencyByAgreementExecute"));
	Chain.Insert("ChangeStoreByAgreement"       , GetChainLink("ChangeStoreByAgreementExecute"));
	Chain.Insert("ChangeDeliveryDateByAgreement"       , GetChainLink("ChangeDeliveryDateByAgreementExecute"));
	Chain.Insert("ChangePriceIncludeTaxByAgreement"    , GetChainLink("ChangePriceIncludeTaxByAgreementExecute"));
	Chain.Insert("ChangeBasisDocumentByAgreement", GetChainLink("ChangeBasisDocumentByAgreementExecute"));
	Chain.Insert("ChangeOrderByAgreement"        , GetChainLink("ChangeOrderByAgreementExecute"));
	Chain.Insert("ChangeCashAccountByCompany"   , GetChainLink("ChangeCashAccountByCompanyExecute"));
	Chain.Insert("ChangeTransitAccountByAccount", GetChainLink("ChangeTransitAccountByAccountExecute"));
	Chain.Insert("ChangeCashAccountByCurrency"  , GetChainLink("ChangeCashAccountByCurrencyExecute"));
	
	Chain.Insert("ChangeCashAccountByPlanningTransactionBasis" , GetChainLink("ChangeCashAccountByPlanningTransactionBasisExecute"));
	Chain.Insert("ChangeCompanyByPlanningTransactionBasis"     , GetChainLink("ChangeCompanyByPlanningTransactionBasisExecute"));
	Chain.Insert("ChangeCurrencyByPlanningTransactionBasis"    , GetChainLink("ChangeCurrencyByPlanningTransactionBasisExecute"));
	Chain.Insert("ChangeTotalAmountByPlanningTransactionBasis" , GetChainLink("ChangeTotalAmountByPlanningTransactionBasisExecute"));
	
	Chain.Insert("ChangeItemKeyByItem"    , GetChainLink("ChangeItemKeyByItemExecute"));
	Chain.Insert("ChangeUnitByItemKey"    , GetChainLink("ChangeUnitByItemKeyExecute"));
	Chain.Insert("ChangeCurrencyByAccount", GetChainLink("ChangeCurrencyByAccountExecute"));
	Chain.Insert("ChangePlanningTransactionBasisByCurrency", GetChainLink("ChangePlanningTransactionBasisByCurrencyExecute"));
	Chain.Insert("FillStoresInList"       , GetChainLink("FillStoresInListExecute"));
	Chain.Insert("FillDeliveryDateInList" , GetChainLink("FillDeliveryDateInListExecute"));
	Chain.Insert("ChangeStoreInHeaderByStoresInList"    , GetChainLink("ChangeStoreInHeaderByStoresInListExecute"));
	Chain.Insert("ChangeDeliveryDateInHeaderByDeliveryDateInList" , GetChainLink("ChangeDeliveryDateInHeaderByDeliveryDateInListExecute"));
	Chain.Insert("ChangeUseShipmentConfirmationByStore" , GetChainLink("ChangeUseShipmentConfirmationByStoreExecute"));
	Chain.Insert("ChangeUseGoodsReceiptByStore"         , GetChainLink("ChangeUseGoodsReceiptByStoreExecute"));
	Chain.Insert("ChangePriceTypeByAgreement"   , GetChainLink("ChangePriceTypeByAgreementExecute"));
	Chain.Insert("ChangePriceTypeAsManual"      , GetChainLink("ChangePriceTypeAsManualExecute"));
	Chain.Insert("ChangePriceByPriceType"       , GetChainLink("ChangePriceByPriceTypeExecute"));
	Chain.Insert("ChangePaymentTermsByAgreement" , GetChainLink("ChangePaymentTermsByAgreementExecute"));	
	Chain.Insert("RequireCallCreateTaxesFormControls", GetChainLink("RequireCallCreateTaxesFormControlsExecute"));
	Chain.Insert("ChangeTaxRate", GetChainLink("ChangeTaxRateExecute"));
	Chain.Insert("ChangeTaxAmountAsManualAmount", GetChainLink("ChangeTaxAmountAsManualAmountExecute"));
	Chain.Insert("Calculations" , GetChainLink("CalculationsExecute"));
	Chain.Insert("UpdatePaymentTerms" , GetChainLink("UpdatePaymentTermsExecute"));
	
	// Extractors
	Chain.Insert("ExtractDataItemKeyIsService"             , GetChainLink("ExtractDataItemKeyIsServiceExecute"));
	Chain.Insert("ExtractDataItemKeysWithSerialLotNumbers" , GetChainLink("ExtractDataItemKeysWithSerialLotNumbersExecute"));
	Chain.Insert("ExtractDataAgreementApArPostingDetail"   , GetChainLink("ExtractDataAgreementApArPostingDetailExecute"));
	
	Chain.Insert("ClearByTransactionType", GetChainLink("ClearByTransactionTypeExecute"));
	Return Chain;
EndFunction

#EndRegion

#Region ITEM_ITEMKEY_UNIT_QUANTITYINBASEUNIT

// При изменении Item изменяется ItemKey при изменении ItemKey изменяется Unit который может изменить QuantityInBaseUnit
// этот код может применятся во всех документах где есть Item, ItemKey, Unit, QuantityInBaseUnit, Quantity

Function DefaultQuantityInListOptions() Export
	Return GetChainLinkOptions("CurrentQuantity");
EndFunction

Function DefaultQuantityInListExecute(Options) Export
	// устанавливает 1 в реквизит Quantity если в реквизите Quantity 0
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
	Return CatItemsServer.GetItemKeyByItem(Options.Item);
EndFunction

// Для вычисления Unit нужен только ItemKey
Function ChangeUnitByItemKeyOptions() Export
	Return GetChainLinkOptions("ItemKey");
EndFunction

// Возвращает Unit по ItemKey который передан в параметре Options.ItemKey
Function ChangeUnitByItemKeyExecute(Options) Export
	// вычисление Unit возлагаем на функцию ItemUnitInfo() вся логика получения Unit в ней
	If Not ValueIsFilled(Options.ItemKey) Then
		Return Undefined;
	EndIf;
	UnitInfo = GetItemInfo.ItemUnitInfo(Options.ItemKey);
	Return UnitInfo.Unit;
EndFunction

#EndRegion

#Region CHANGE_TRANSIT_ACCOUNT_BY_ACCOUNT

Function ChangeTransitAccountByAccountOptions() Export
	Return GetChainLinkOptions("TransactionType, Account, CurrentTransitAccount");
EndFunction

Function ChangeTransitAccountByAccountExecute(Options) Export
	TransitAccount = Options.CurrentTransitAccount;
	If Options.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CurrencyExchange") Then
		TransitAccount = ServiceSystemServer.GetObjectAttribute(Options.Account, "TransitAccount");
	EndIf;
	Return TransitAccount;
EndFunction

#EndRegion

#Region CHANGE_CASH_ACCOUNT_BY_COMPANY

Function ChangeCashAccountByCompanyOptions() Export
	Return GetChainLinkOptions("Company, Account, AccountType");
EndFunction

Function ChangeCashAccountByCompanyExecute(Options) Export
	Filters = New Array();
	Filters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", False, 
		ComparisonType.Equal, DataCompositionComparisonType.Equal));
		
	If ValueIsFilled(Options.AccountType) Then
		Filters.Add(DocumentsClientServer.CreateFilterItem("Type", Options.AccountType,
			ComparisonType.Equal, DataCompositionComparisonType.Equal));
	Else
		Filters.Add(DocumentsClientServer.CreateFilterItem("Type", PredefinedValue("Enum.CashAccountTypes.Transit"), 
			ComparisonType.NotEqual, DataCompositionComparisonType.NotEqual));
	EndIf;

	ComplexFilters = New Array();
	ComplexFilters.Add(DocumentsClientServer.CreateFilterItem("ByCompanyWithEmpty", Options.Company));

	ChoiceParameters = New Structure();
	ChoiceParameters.Insert("Filters"        , Filters);
	ChoiceParameters.Insert("ComplexFilters" , ComplexFilters);
	ChoiceParameters.Insert("Fields"         , New Structure("Ref", "Ref"));
	ChoiceParameters.Insert("OptionsString"  , "");
	ChoiceParameters.Insert("CashAccount"    , Options.Account);
	CashAccount = CatCashAccountsServer.GetCashAccountByCompany(Options.Company, ChoiceParameters);
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

#Region CHANGE_CASH_ACCOUNT_BY_PLANNING_TRANSACTION_BASIS

Function ChangeCashAccountByPlanningTransactionBasisOptions() Export
	Return GetChainLinkOptions("PlanningTransactionBasis, CurrentAccount");
EndFunction

Function ChangeCashAccountByPlanningTransactionBasisExecute(Options) Export
	If ValueIsFilled(Options.CurrentAccount) Then
		Return Options.CurrentAccount;
	EndIf;
	
	If ValueIsFilled(Options.PlanningTransactionBasis)
		And TypeOf(Options.PlanningTransactionBasis) = Type("DocumentRef.CashTransferOrder") Then
			CashTransferOrderInfo = DocCashTransferOrderServer.GetInfoForFillingBankPayment(Options.PlanningTransactionBasis);
			Return CashTransferOrderInfo.Account;
	EndIf;
	Return Options.CurrentAccount;
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
			And ServiceSystemServer.GetObjectAttribute(Options.PlanningTransactionBasis,"SendCurrency") 
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
	Return GetChainLinkOptions("Partner, LegalName");
EndFunction

Function ChangeLegalNameByPartnerExecute(Options) Export
	Return DocumentsServer.GetLegalNameByPartner(Options.Partner, Options.LegalName);
EndFunction

#EndRegion

#Region CHANGE_PARTNER_BY_LEGAL_NAME

Function ChangePartnerByLegalNameOptions() Export
	Return GetChainLinkOptions("Partner, LegalName");
EndFunction

Function ChangePartnerByLegalNameExecute(Options) Export
	If ValueIsFilled(Options.LegalName) Then
		Return DocumentsServer.GetPartnerByLegalName(Options.LegalName, Options.Partner);
	EndIf;
	Return Options.Partner;
EndFunction

#EndRegion

#Region CHANGE_AGREEMENT_BY_PARTNER

Function ChangeAgreementByPartnerOptions() Export
	Return GetChainLinkOptions("Partner, Agreement, CurrentDate, AgreementType");
EndFunction

Function ChangeAgreementByPartnerExecute(Options) Export
	Return DocumentsServer.GetAgreementByPartner(Options);
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
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(Options.Agreement);
	If ValueIsFilled(AgreementInfo.Currency) Then
		Return AgreementInfo.Currency;
	EndIf;
	Return Options.CurrentCurrency;
EndFunction

#EndRegion

#Region CHANGE_CURRENCY_BY_ACCOUNT

// Параметры которые нужны для вычисления Currency, в этом случае достаточно только Account
// если в Account не будет указана Currency то останется CurrentCurrency (та что уже указана в документе)
Function ChangeCurrencyByAccountOptions() Export
	Return GetChainLinkOptions("Account, CurrentCurrency");
EndFunction

// Возвращает Currency которая указана в Account
// если в Account пусто возвращает Currency которая уже указана в документе (параметр CurrentCurrency)
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

#EndRegion

#Region CHANGE_CURRENCY_BY_PLANNING_TRANSACTION_BASIS

Function ChangeCurrencyByPlanningTransactionBasisOptions() Export
	Return GetChainLinkOptions("PlanningTransactionBasis, CurrentCurrency");
EndFunction

Function ChangeCurrencyByPlanningTransactionBasisExecute(Options) Export
	If ValueIsFilled(Options.CurrentCurrency) Then
		Return Options.CurrentCurrency;
	EndIf;
	
	If ValueIsFilled(Options.PlanningTransactionBasis)
		And TypeOf(Options.PlanningTransactionBasis) = Type("DocumentRef.CashTransferOrder") Then
			CashTransferOrderInfo = DocCashTransferOrderServer.GetInfoForFillingBankPayment(Options.PlanningTransactionBasis);
			Return CashTransferOrderInfo.Currency;
	EndIf;
	Return Options.CurrentCurrency;
EndFunction

#EndRegion

#Region CHANGE_COMPANY_BY_AGREEMENT

Function ChangeCompanyByAgreementOptions() Export
	Return GetChainLinkOptions("Agreement, CurrentCompany");
EndFunction

Function ChangeCompanyByAgreementExecute(Options) Export
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(Options.Agreement);
	If ValueIsFilled(AgreementInfo.Company) Then
		Return AgreementInfo.Company;
	EndIf;
	Return Options.CurrentCompany;
EndFunction

#EndRegion

#Region CHANGE_COMPANY_BY_PLANNING_TRANSACTION_BASIS

Function ChangeCompanyByPlanningTransactionBasisOptions() Export
	Return GetChainLinkOptions("PlanningTransactionBasis, CurrentCompany");
EndFunction

Function ChangeCompanyByPlanningTransactionBasisExecute(Options) Export
	If ValueIsFilled(Options.CurrentCompany) Then
		Return Options.CurrentCompany;
	EndIf;
	
	If ValueIsFilled(Options.PlanningTransactionBasis)
		And TypeOf(Options.PlanningTransactionBasis) = Type("DocumentRef.CashTransferOrder") Then
			CashTransferOrderInfo = DocCashTransferOrderServer.GetInfoForFillingBankPayment(Options.PlanningTransactionBasis);
			Return CashTransferOrderInfo.Company;
	EndIf;
	Return Options.CurrentCompany;
EndFunction

#EndRegion

#Region CHANGE_PRICE_INCLUDE_TAX_BY_AGREEMENT

Function ChangePriceIncludeTaxByAgreementOptions() Export
	Return GetChainLinkOptions("Agreement");
EndFunction

Function ChangePriceIncludeTaxByAgreementExecute(Options) Export
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(Options.Agreement);
	Return AgreementInfo.PriceIncludeTax;
EndFunction

#EndRegion

#Region CHANGE_PRICE_TYPE_BY_AGREEMENT

Function ChangePriceTypeByAgreementOptions() Export
	Return GetChainLinkOptions("Agreement");
EndFunction

Function ChangePriceTypeByAgreementExecute(Options) Export
	Return CatAgreementsServer.GetAgreementInfo(Options.Agreement).PriceType;
EndFunction

#EndRegion

#Region CHANGE_PRICE_TYPE_AS_MANUAL

Function ChangePriceTypeAsManualOptions() Export
	Return GetChainLinkOptions("IsUserChange, IsTotalAmountChange, CurrentPriceType, DontCalculateRow");
EndFunction

Function ChangePriceTypeAsManualExecute(Options) Export
	// если это изменение TotalAmount и установлена галочка DontCalculateRow, менять тип цены не нужно
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
	Return GetChainLinkOptions("Ref, Date, PriceType, CurrentPrice, ItemKey, Unit");
EndFunction

Function ChangePriceByPriceTypeExecute(Options) Export
	If Options.PriceType = PredefinedValue("Catalog.PriceTypes.ManualPriceType") Then
		Return Options.CurrentPrice;
	EndIf;
	Period = CalculationStringsClientServer.GetSliceLastDateByRefAndDate(Options.Ref, Options.Date);
	PriceParameters = New Structure();
	PriceParameters.Insert("Period"       , Period);
	PriceParameters.Insert("PriceType"    , PredefinedValue("Catalog.PriceTypes.ManualPriceType"));
	PriceParameters.Insert("RowPriceType" , Options.PriceType);
	PriceParameters.Insert("ItemKey"      , Options.ItemKey);
	PriceParameters.Insert("Unit"         , Options.Unit);
	PriceInfo = GetItemInfo.ItemPriceInfo(PriceParameters);
	Return ?(PriceInfo = Undefined, 0, PriceInfo.Price);
EndFunction

#EndRegion

#Region CHANGE_TOTAL_AMOUNT_BY_PLANNING_TRANSACTION_BASIS

Function ChangeTotalAmountByPlanningTransactionBasisOptions() Export
	Return GetChainLinkOptions("PlanningTransactionBasis, CurrentTotalAmount, Ref");
EndFunction

Function ChangeTotalAmountByPlanningTransactionBasisExecute(Options) Export
	If ValueIsFilled(Options.PlanningTransactionBasis)
		And TypeOf(Options.PlanningTransactionBasis) = Type("DocumentRef.CashTransferOrder") Then
			ArrayOfPlaningTransactionBasises = New Array();
			ArrayOfPlaningTransactionBasises.Add(Options.PlanningTransactionBasis);
			ArrayOfBalance = 
			DocBankPaymentServer.GetDocumentTable_CashTransferOrder_ForClient(ArrayOfPlaningTransactionBasises, Options.Ref);
			If ArrayOfBalance.Count() Then
				Return ArrayOfBalance[0].Amount;
			Else
				Return Options.CurrentTotalAmount;
			EndIf;
	EndIf;
	Return Options.CurrentTotalAmount;
EndFunction

#EndRegion

#Region CHANGE_STORE_BY_AGREEMENT

Function ChangeStoreByAgreementOptions() Export
	Return GetChainLinkOptions("Agreement, CurrentStore");
EndFunction

Function ChangeStoreByAgreementExecute(Options) Export
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
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(Options.Agreement);
	If ValueIsFilled(AgreementInfo.DeliveryDate)  Then
		Return AgreementInfo.DeliveryDate;
	EndIf;
	Return Options.CurrentDeliveryDate;
EndFunction

#EndRegion

#Region DELIVERY_DATE

Function DefaultDeliveryDateInHeaderOptions() Export
	Return GetChainLinkOptions("ArrayOfDeliveryDateInList, Date, Agreement");
EndFunction

// Заполняет DeliveryDate в шапке по умолчанию
Function DefaultDeliveryDateInHeaderExecute(Options) Export
	ArrayOfDeliveryDateUnique = New Array();
	For Each DeliveryDate In Options.ArrayOfDeliveryDateInList Do
		If ValueIsFilled(DeliveryDate) And ArrayOfDeliveryDateUnique.Find(DeliveryDate) = Undefined Then
			ArrayOfDeliveryDateUnique.Add(DeliveryDate);
		EndIf;
	EndDo;
	If ArrayOfDeliveryDateUnique.Count() = 1 Then
		Return ArrayOfDeliveryDateUnique[0]; // В табличной части указан один DeliveryDate
	ElsIf ArrayOfDeliveryDateUnique.Count() > 1 Then
		Return Undefined; // В табличной части указаны несколько DeliveryDate
	EndIf;
	
	// когда табличная часть пустая DeliveryDate заполняется из Agreement
	If ValueIsFilled(Options.Agreement) Then
		AgreementInfo = CatAgreementsServer.GetAgreementInfo(Options.Agreement);
		DeliveryDateInAgreement = AgreementInfo.DeliveryDate;
		If ValueIsFilled(DeliveryDateInAgreement) Then
			Return DeliveryDateInAgreement; // DeliveryDate указанный в Agreement
		EndIf;
	EndIf;
	Return Undefined;
EndFunction

Function DefaultDeliveryDateInListOptions() Export
	Return GetChainLinkOptions("DeliveryDateInList, DeliveryDateInHeader, Date, Agreement");
EndFunction

// Заполняет DeliveryDate в табличной части по умолчанию
Function DefaultDeliveryDateInListExecute(Options) Export
	If ValueIsFilled(Options.DeliveryDateInList) Then
		Return Options.DeliveryDateInList; // DeliveryDate уже заполнен
	EndIf;
	
	If ValueIsFilled(Options.DeliveryDateInHeader) Then
		Return Options.DeliveryDateInHeader; // DeliveryDate указанный в шапке документа
	EndIf;
	
	If ValueIsFilled(Options.Agreement) Then
		AgreementInfo = CatAgreementsServer.GetAgreementInfo(Options.Agreement);
		DeliveryDateInAgreement = AgreementInfo.DeliveryDate;
		If ValueIsFilled(DeliveryDateInAgreement) Then
			Return DeliveryDateInAgreement; // DeliveryDate указанный в Agreement
		EndIf;
	EndIf;

	Return Undefined;
EndFunction

Function FillDeliveryDateInListOptions() Export
	Return GetChainLinkOptions("DeliveryDate, DeliveryDateInList");
EndFunction

// заполняет DeliveryDate в табличной части, тем DeliveryDate что передан в параметре 
Function FillDeliveryDateInListExecute(Options) Export
	If ValueIsFilled(Options.DeliveryDate) Then
		Return Options.DeliveryDate;
	EndIf;
	Return Options.DeliveryDateInList;
EndFunction

Function ChangeDeliveryDateInHeaderByDeliveryDateInListOptions() Export
	Return GetChainLinkOptions("ArrayOfDeliveryDateInList");
EndFunction

// изменяет DeliveryDate в шапке документа, взависимости от DeliveryDate указанных в табличной части ItemList.DeliveryDate
// если в табличной части ItemList есть разные DeliveryDate то склад в шапке будет Undefined
// если в табличной части ItemList есть только один DeliveryDate то DeliveryDate в шапке будет DeliveryDate = ItemList.DeliveryDate
Function ChangeDeliveryDateInHeaderByDeliveryDateInListExecute(Options) Export
	// сделаем массив с DeliveryDate только с уникальными значениями
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

// Заполняет Store в шапке когда его очищают
Function EmptyStoreInHeaderExecute(Options) Export
	// заполняется из Agreement или из UserSettings
	If ValueIsFilled(Options.Agreement) Then
		StoreInAgreement = Options.Agreement.Store;
		If ValueIsFilled(StoreInAgreement) Then
			Return StoreInAgreement; // Склад указанный в Agreement
		EndIf;
	EndIf;
	
	UserSettings = UserSettingsServer.GetUserSettingsForClientModule(Options.DocumentRef);
	For Each Setting In UserSettings Do
		If Setting.AttributeName = "ItemList.Store" Then
			Return Setting.Value; // Склад указанный в настройках пользователя
		EndIf;
	EndDo;
	
	Return Undefined;
EndFunction

Function DefaultStoreInHeaderOptions() Export
	Return GetChainLinkOptions("DocumentRef, ArrayOfStoresInList, Agreement");
EndFunction

// Заполняет Store в шапке по умолчанию
Function DefaultStoreInHeaderExecute(Options) Export
	ArrayOfStoresUnique = New Array();
	For Each Store In Options.ArrayOfStoresInList Do
		If ValueIsFilled(Store) And ArrayOfStoresUnique.Find(Store) = Undefined Then
			ArrayOfStoresUnique.Add(Store);
		EndIf;
	EndDo;
	If ArrayOfStoresUnique.Count() = 1 Then
		Return ArrayOfStoresUnique[0]; // В табличной части указан один склад
	ElsIf ArrayOfStoresUnique.Count() > 1 Then
		Return Undefined; // В табличной части указаны несколько складов
	EndIf;
	
	// когда табличная часть пустая склад заполняется из Agreement или из UserSettings
	
	If ValueIsFilled(Options.Agreement) Then
		StoreInAgreement = Options.Agreement.Store;
		If ValueIsFilled(StoreInAgreement) Then
			Return StoreInAgreement; // Склад указанный в Agreement
		EndIf;
	EndIf;
	
	UserSettings = UserSettingsServer.GetUserSettingsForClientModule(Options.DocumentRef);
	For Each Setting In UserSettings Do
		If Setting.AttributeName = "ItemList.Store" Then
			Return Setting.Value; // Склад указанный в настройках пользователя
		EndIf;
	EndDo;
	
	Return Undefined;
EndFunction

Function DefaultStoreInListOptions() Export
	Return GetChainLinkOptions("StoreFromUserSettings, StoreInList, StoreInHeader, Agreement");
EndFunction

// Заполняет склад в табличной части по умолчанию
Function DefaultStoreInListExecute(Options) Export
	If ValueIsFilled(Options.StoreInList) Then
		Return Options.StoreInList; // Склад уже заполнен
	EndIf;
	
	If ValueIsFilled(Options.StoreInHeader) Then
		Return Options.StoreInHeader; // Склад указанный в шапке документа
	EndIf;
	
	If ValueIsFilled(Options.Agreement) Then
		StoreInAgreement = Options.Agreement.Store;
		If ValueIsFilled(StoreInAgreement) Then
			Return StoreInAgreement; // Склад указанный в Agreement
		EndIf;
	EndIf;
	
	Return Options.StoreFromUserSettings; // Склад указанный в настройках пользователя
EndFunction

Function ChangeUseShipmentConfirmationByStoreOptions() Export
	Return GetChainLinkOptions("Store, ItemKey");
EndFunction

// устанавливает значение true\false в UseShipmentConfirmation, значение берется из склада 
Function ChangeUseShipmentConfirmationByStoreExecute(Options) Export
	Return ChangeOrderSchemeByStore(Options, "UseShipmentConfirmation");
EndFunction

Function ChangeUseGoodsReceiptByStoreOptions() Export
	Return GetChainLinkOptions("Store, ItemKey");
EndFunction

// устанавливает значение true\false в UseGoodsReceipt, значение берется из склада
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

Function FillStoresInListOptions() Export
	Return GetChainLinkOptions("Store, StoreInList, IsUserChange");
EndFunction

// заполняет Store в табличной части, тем Store что передан в параметре если переданный склад заполнен
// если не заполнен то оставляет тот склад что указан в табличной части
Function FillStoresInListExecute(Options) Export
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

// изменяет Store в шапке документа, взависимости от складов указанных в табличной части ItemList.Store
// если в табличной части ItemList есть разные склады то склад в шапке будет Undefined
// если в табличной части ItemList есть только один склад то склад в шапке будет Store = ItemList.Store
Function ChangeStoreInHeaderByStoresInListExecute(Options) Export
	// сделаем массив с кладов только с уникальными значениями
	ArrayOfStoresUnique = New Array();
	For Each Row In Options.ArrayOfStoresInList Do
		IsService = ModelServer_V2.ExtractDataItemKeyIsServiceServerImp(Row.ItemKey);
		If IsService Then
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

// TaxesCache - строка XML из реквизита формы
Function RequireCallCreateTaxesFormControlsOptions() Export
	Return GetChainLinkOptions("Ref, Date, Company, ArrayOfTaxInfo, FormTaxColumnsExists");
EndFunction

// возвращает true если нужно создать элементы формы для отображения налогов
Function RequireCallCreateTaxesFormControlsExecute(Options) Export
	If Not Options.FormTaxColumnsExists = True Then
		Return True; // на форме нет колонок надо создавать
	EndIf;
	If Not Options.ArrayOfTaxInfo.Count() Then
		Return True; // кэш пустой надо создавать колонки
	EndIf;
	// свравнивает необходимые налоги и налоги в кэше, если они совпадают возвращает false (не нужно пересоздавать колонки)
	// если не совпадут возвращает true (нужно пересоздать колонки на форме)
	TaxesInCache = New Array();
	For Each TaxInfo In Options.ArrayOfTaxInfo Do
		TaxesInCache.Add(TaxInfo.Tax);
	EndDo;
	RequiredTaxes = New Array();
	DocumentName = Options.Ref.Metadata().Name;
	AllTaxes = TaxesServer.GetTaxesByCompany(Options.Date, Options.Company);
	For Each ItemOfAllTaxes In AllTaxes Do
		If ItemOfAllTaxes.UseDocuments.FindRows(New Structure("DocumentName", DocumentName)).Count() Then
			RequiredTaxes.Add(ItemOfAllTaxes.Tax);
		EndIf;
	EndDo;
	For Each Tax In RequiredTaxes Do
		If TaxesInCache.Find(Tax) = Undefined Then
			Return True; // не все необходимые налогив кэше
		EndIf;
	EndDo;
	For Each Tax In TaxesInCache Do
		If RequiredTaxes.Find(Tax) = Undefined Then
			Return True; // в кэше есть лишние налоги
		EndIf;
	EndDo;
	Return False; // в кэше все налоги и нет лишних
EndFunction

Function ChangeTaxRateOptions() Export
	Return GetChainLinkOptions("Date, Company, Agreement, ItemKey, TaxRates, ArrayOfTaxInfo, Ref, 
		|ChangeOnlyWhenAgreementIsFilled");
EndFunction

Function ChangeTaxRateExecute(Options) Export
	Result = New Structure();
	For Each TaxRate In Options.TaxRates Do
		Result.Insert(TaxRate.Key, TaxRate.Value);
	EndDo;
	
	If Options.ChangeOnlyWhenAgreementIsFilled = True And Not ValueIsFilled(Options.Agreement) Then
		Return Result;
	EndIf;
	
	// налоги которые учитываются по организации на дату документа
	DocumentName = Options.Ref.Metadata().Name;
	AllTaxes = TaxesServer.GetTaxesByCompany(Options.Date, Options.Company);
	RequiredTaxes = New Array();
	For Each ItemOfAllTaxes In AllTaxes Do
		If ItemOfAllTaxes.UseDocuments.FindRows(New Structure("DocumentName", DocumentName)).Count() Then
			RequiredTaxes.Add(ItemOfAllTaxes.Tax);
		EndIf;
	EndDo;
	
	For Each ItemOfTaxInfo In Options.ArrayOfTaxInfo Do
		If ItemOfTaxInfo.Type <> PredefinedValue("Enum.TaxType.Rate") Then
			Continue;
		EndIf;
		
		// Если налог не учитывается организацией то очистим ставку налога TaxRate = Undefined
		If RequiredTaxes.Find(ItemOfTaxInfo.Tax) = Undefined Then
			Result.Insert(ItemOfTaxInfo.Name, Undefined);
			Continue;
		EndIf;
		
		ArrayOfTaxRates = New Array();
		If ValueIsFilled(Options.Agreement) Then
			Parameters = New Structure();
			Parameters.Insert("Date"      , Options.Date);
			Parameters.Insert("Company"   , Options.Company);
			Parameters.Insert("Tax"       , ItemOfTaxInfo.Tax);
			Parameters.Insert("Agreement" , Options.Agreement);
			ArrayOfTaxRates = TaxesServer.GetTaxRatesForAgreement(Parameters);
		EndIf;

		If Not ArrayOfTaxRates.Count() Then
			Parameters = New Structure();
			Parameters.Insert("Date"    , Options.Date);
			Parameters.Insert("Company" , Options.Company);
			Parameters.Insert("Tax"     , ItemOfTaxInfo.Tax);
			If ValueIsFilled(Options.ItemKey) Then
				Parameters.Insert("ItemKey", Options.ItemKey);
			Else
				Parameters.Insert("ItemKey", PredefinedValue("Catalog.ItemKeys.EmptyRef"));
			EndIf;
			ArrayOfTaxRates = TaxesServer.GetTaxRatesForItemKey(Parameters);
		EndIf;
		If ArrayOfTaxRates.Count() Then
			Result.Insert(ItemOfTaxInfo.Name, ArrayOfTaxRates[0].TaxRate);
		EndIf;
	EndDo;
		
	Return Result;
EndFunction

#EndRegion

#Region CALCULATIONS

Function CalculationsOptions() Export
	Options = GetChainLinkOptions("Ref");
	
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
	TaxOptions = New Structure("PriceIncludeTax, ArrayOfTaxInfo, TaxRates, UseManualAmount");
	TaxOptions.Insert("TaxList", New Array());
	Options.Insert("TaxOptions", TaxOptions);
	
	QuantityOptions = New Structure("ItemKey, Unit, Quantity, QuantityInBaseUnit");
	Options.Insert("QuantityOptions", QuantityOptions);
	
	// SpecialOffers columns: Key, Offer, Amount, Percent
	OffersOptions = New Structure("SpecialOffers", New Array());
	Options.Insert("OffersOptions", OffersOptions);
	
	Options.Insert("CalculateTotalAmount"            , New Structure("Enable", False));
	Options.Insert("CalculateTotalAmountByNetAmount" , New Structure("Enable", False));
	
	Options.Insert("CalculateNetAmount"                            , New Structure("Enable", False));
	Options.Insert("CalculateNetAmountByTotalAmount"               , New Structure("Enable", False));
	Options.Insert("CalculateNetAmountAsTotalAmountMinusTaxAmount" , New Structure("Enable", False));
	
	Options.Insert("CalculateTaxAmount"              , New Structure("Enable", False));
	Options.Insert("CalculateTaxAmountByNetAmount"   , New Structure("Enable", False));
	Options.Insert("CalculateTaxAmountByTotalAmount" , New Structure("Enable", False));
	
	Options.Insert("CalculateTaxAmountReverse"   , New Structure("Enable", False));
	Options.Insert("CalculatePriceByTotalAmount" , New Structure("Enable", False));

	Options.Insert("CalculateQuantityInBaseUnit" , New Structure("Enable", False));
	
	Options.Insert("CalculateSpecialOffers" , New Structure("Enable", False));
	
	Return Options;
EndFunction

Function CalculationsOptions_TaxOptions_TaxList() Export
	Return New Structure("Key, Tax, Analytics, TaxRate, Amount, IncludeToTotalAmount, ManualAmount");
EndFunction

Function CalculationsExecute(Options) Export
	IsCalculatedRow = Not Options.AmountOptions.DontCalculateRow;

//	If Actions.Property("RecalculateAppliedOffers") Then
//		RecalculateAppliedOffers(Object, ItemRow, AddInfo);
//	EndIf;

	Result = New Structure();
	Result.Insert("NetAmount"    , Options.AmountOptions.NetAmount);
	Result.Insert("OffersAmount" , Options.AmountOptions.OffersAmount);
	Result.Insert("TaxAmount"    , Options.AmountOptions.TaxAmount);
	Result.Insert("TotalAmount"  , Options.AmountOptions.TotalAmount);
	Result.Insert("Price"        , Options.PriceOptions.Price);
	Result.Insert("TaxRates"     , Options.TaxOptions.TaxRates);
	Result.Insert("TaxList"      , New Array());
	Result.Insert("QuantityInBaseUnit" , Options.QuantityOptions.QuantityInBaseUnit);
	
	// CalculateSpecialOffers
	If Options.CalculateSpecialOffers.Enable Then
		TotalOffers = 0;
		For Each Row In Options.OffersOptions.SpecialOffers Do
			TotalOffers = TotalOffers + Row.Amount;
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
	
	If Options.TaxOptions.PriceIncludeTax <> Undefined Then
		If Options.TaxOptions.PriceIncludeTax Then
			
			If Options.CalculateTaxAmountReverse.Enable And IsCalculatedRow Then
				CalculateTaxAmount(Options, Options.TaxOptions, Result, True, False);
			EndIf;
			
			If Options.CalculatePriceByTotalAmount.Enable And IsCalculatedRow Then
				Result.Price = ?(Options.PriceOptions.Quantity = 0, 0, 
				Result.TotalAmount / Options.PriceOptions.Quantity);  
			EndIf;
			
			If Options.CalculateTotalAmount.Enable And IsCalculatedRow Then
				Result.TotalAmount = CalculateTotalAmount_PriceIncludeTax(Options.PriceOptions, Result);
			EndIf;

			If Options.CalculateTaxAmount.Enable And IsCalculatedRow Then
				CalculateTaxAmount(Options, Options.TaxOptions, Result, False, False);
			EndIf;

			If Options.CalculateNetAmountAsTotalAmountMinusTaxAmount.Enable And IsCalculatedRow Then
				Result.NetAmount = CalculateNetAmount_PriceIncludeTax(Options.PriceOptions, Result);
			EndIf;

			If Options.CalculateNetAmount.Enable And IsCalculatedRow Then
				Result.NetAmount = CalculateNetAmount_PriceIncludeTax(Options.PriceOptions, Result);
			EndIf;
		Else
			If Options.CalculateTaxAmountReverse.Enable And IsCalculatedRow Then
				CalculateTaxAmount(Options, Options.TaxOptions, Result, True, False);
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

			If Options.CalculateTaxAmount.Enable And IsCalculatedRow Then
				CalculateTaxAmount(Options, Options.TaxOptions, Result, False, False);
			EndIf;

			If Options.CalculateTotalAmount.Enable And IsCalculatedRow Then
				Result.TotalAmount = CalculateTotalAmount_PriceNotIncludeTax(Options.PriceOptions, Result);
			EndIf;
		EndIf;
	Else // PriceIncludeTax = Undefined
		If Options.CalculateTaxAmountReverse.Enable And IsCalculatedRow Then
			CalculateTaxAmount(Options, Options.TaxOptions, Result, True, False);
		EndIf;
		
		If Options.CalculatePriceByTotalAmount.Enable And IsCalculatedRow Then
			Result.Price = ?(Options.PriceOptions.Quantity = 0, 0, 
			(Result.TotalAmount - Result.TaxAmount) / Options.PriceOptions.Quantity);
		EndIf;
		
		If Options.CalculateTaxAmount.Enable And IsCalculatedRow Then
			CalculateTaxAmount(Options, Options.TaxOptions, Result, False, True);
		EndIf;

		If Options.CalculateTotalAmount.Enable And IsCalculatedRow Then
			Result.TotalAmount = CalculateTotalAmount_PriceNotIncludeTax(Options.PriceOptions, Result);
		EndIf;

		If Options.CalculateTaxAmountByNetAmount.Enable And IsCalculatedRow Then
			CalculateTaxAmount(Options, Options.TaxOptions, Result, False, True);
		EndIf;

		If Options.CalculateTaxAmountByTotalAmount.Enable And IsCalculatedRow Then
			CalculateTaxAmount(Options, Options.TaxOptions, Result, False, True, True);
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
	
//	If Actions.Property("UpdateInfoString") Then
//		UpdateInfoString(ItemRow);
//	EndIf;
//
//	If Actions.Property("UpdateInfoStringWithOffers") Then
//		UpdateInfoStringWithOffers(Object, ItemRow, AddInfo);
//	EndIf;
//
//	If Actions.Property("UpdateBarcode") Then
//		UpdateBarcode(Object, ItemRow, AddInfo);
//	EndIf;
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
	If PriceOptions.PriceType <> Undefined And PriceOptions.QuantityInBaseUnit <> Undefined 
		And PriceOptions.PriceType = PredefinedValue("Catalog.PriceTypes.ManualPriceType") Then
		
		Return PriceOptions.Price * PriceOptions.QuantityInBaseUnit;
	ElsIf PriceOptions.Quantity <> Undefined Then
		Return PriceOptions.Price * PriceOptions.Quantity;
	EndIf;
	Return Result.TotalAmount;
EndFunction

Procedure CalculateTaxAmount(Options, TaxOptions, Result, IsReverse, IsManualPriority, PriceIncludeTax = False)
	ArrayOfTaxInfo = TaxOptions.ArrayOfTaxInfo;
	If TaxOptions.ArrayOfTaxInfo = Undefined Then
		Return;
	EndIf;
	
	TaxAmount = 0;
	For Each ItemOfTaxInfo In ArrayOfTaxInfo Do
		If ItemOfTaxInfo.Type = PredefinedValue("Enum.TaxType.Rate") 
			And Not ValueIsFilled(Result.TaxRates[ItemOfTaxInfo.Name]) Then
			// ставка налога в строке не заполнена
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
			Result.TaxList.Add(NewTax);
			If RowOfResult.IncludeToTotalAmount Then
				TaxAmount = Round(TaxAmount + NewTax.ManualAmount, 2);
			EndIf;
		EndDo;
	EndDo;

	Result.TaxAmount = TaxAmount;
EndProcedure

#EndRegion

#Region _EXTRACT_DATA_

Function ExtractDataItemKeyIsServiceOptions() Export
	Return GetChainLinkOptions("ItemKey, IsUserChange");
EndFunction

Function ExtractDataItemKeyIsServiceExecute(Options) Export
	If Not Options.IsUserChange = True Then
		Return Undefined;
	EndIf;
	Return ModelServer_V2.ExtractDataItemKeyIsServiceServerImp(Options.Itemkey);
EndFunction

Function ExtractDataItemKeysWithSerialLotNumbersOptions() Export
	Return GetChainLinkOptions("ItemKey");
EndFunction

Function ExtractDataItemKeysWithSerialLotNumbersExecute(Options) Export
	Return ModelServer_V2.ExtractDataItemKeysWithSerialLotNumbersImp(Options.Itemkey);
EndFunction

Function ExtractDataAgreementApArPostingDetailOptions() Export
	Return GetChainLinkOptions("Agreement");
EndFunction

Function ExtractDataAgreementApArPostingDetailExecute(Options) Export
	Return ModelServer_V2.ExtractDataAgreementApArPostingDetailImp(Options.Agreement);
EndFunction

#EndRegion

#Region TRANSACTION_TYPE

Function ClearByTransactionTypeOptions() Export
	Return GetChainLinkOptions("TransactionType,
		|TransitAccount,
		|Partner,
		|Payee,
		|Agreement,
		|LegalNameContract,
		|BasisDocument,
		|PlanningTransactionBasis,
		|Order");
EndFunction

Function ClearByTransactionTypeExecute(Options) Export
	Result = New Structure();
	Result.Insert("TransitAccount"          , Options.TransitAccount);
	Result.Insert("Partner"                 , Options.Partner);
	Result.Insert("Payee"                   , Options.Payee);
	Result.Insert("Agreement"               , Options.Agreement);
	Result.Insert("LegalNameContract"       , Options.LegalNameContract);
	Result.Insert("BasisDocument"           , Options.BasisDocument);
	Result.Insert("PlanningTransactionBasis" , Options.PlanningTransactionBasis);
	Result.Insert("Order"                   , Options.Order);
	
	Outgoing_CashTransferOrder = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CashTransferOrder");
	Outgoing_CurrencyExchange  = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CurrencyExchange");
	Outgoing_PaymentToVendor   = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.PaymentToVendor");
	Outgoing_ReturnToCustomer  = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.ReturnToCustomer");
	
	If Options.TransactionType = Outgoing_CashTransferOrder Then
		StrByType = "
		|PlanningTransactionBasis";
	ElsIf Options.TransactionType = Outgoing_CurrencyExchange Then
		StrByType = "
		|TransitAccount, 
		|PlanningTransactionBasis";
	ElsIf Options.TransactionType = Outgoing_PaymentToVendor Or Options.TransactionType = Outgoing_ReturnToCustomer Then
		StrByType = "
		|BasisDocument,
		|Partner,
		|Agreement,
		|Payee,
		|PlaninngTransactionBasis,
		|LegalNameContract";
		If Options.TransactionType = Outgoing_PaymentToVendor Then
			StrByType = StrByType + ", PaymentList.Order";
		EndIf;
	EndIf;
	ArrayOfAttributes = New Array();
	For Each ArrayItem In StrSplit(StrByType, ",") Do
		ArrayOfAttributes.Add(StrReplace(TrimAll(ArrayItem),Chars.NBSp,""));
	EndDo;
	
	For Each KeyValue In Result Do
		If ArrayOfAttributes.Find(KeyValue.Key) = Undefined Then
			Result[KeyValue.Key] = Undefined;
		EndIf;
	EndDo;
	Return Result;
EndFunction

#EndRegion

Procedure InitEntryPoint(StepsEnablerName, Parameters)
	If Not Parameters.Property("ModelInveronment") Then
		Inveronment = New Structure();
		Inveronment.Insert("FirstStepsEnablerName"  , StepsEnablerName);
		Inveronment.Insert("StepsEnablerNameCounter", New Array());
		Inveronment.Insert("AlreadyExecutedSteps"   , New Array());
		Parameters.Insert("ModelInveronment", Inveronment)
	EndIf;
EndProcedure

Procedure DestroyEntryPoint(Parameters)
	If Parameters.Property("ModelInveronment") Then
		Parameters.Delete("ModelInveronment");
	EndIf;
EndProcedure
