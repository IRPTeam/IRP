
Function RunBackgroundJob(JobParameters) Export
	JobKey = String(New UUID());	
	StorageAddress = PutToTempStorage(Undefined, JobParameters.FormUUID);
	
	ServiceParameters = New Structure();
	ServiceParameters.Insert("Parameters_LoadData_Address", Undefined);
	
	If ValueIsFilled(JobParameters.Parameters.LoadData.Address) Then
		_LoadDataValue = GetFromTempStorage(JobParameters.Parameters.LoadData.Address);
		ServiceParameters.Parameters_LoadData_Address = _LoadDataValue;
	EndIf;
	
	BackgroundParameters = New Array();
	JobParameters.Parameters.Object = CommonFunctionsServer.SerializeXMLUseXDTO(JobParameters.Parameters.Object);
	BackgroundParameters.Add(JobParameters);	
	BackgroundParameters.Add(StorageAddress);
	BackgroundParameters.Add(ServiceParameters);
	
	Job = BackgroundJobs.Execute("ModelServer_V2.BackgroundJob", BackgroundParameters, JobKey);
	Return New Structure("BackgroundJobUUID, BackgroundJobStorageAddress", Job.UUID, StorageAddress);
EndFunction

Procedure BackgroundJob(JobParameters, StorageAddress, ServiceParameters) Export
	JobParameters.Parameters.Object = 
		CommonFunctionsServer.DeserializeXMLUseXDTO(JobParameters.Parameters.Object);
	
	If ValueIsFilled(ServiceParameters.Parameters_LoadData_Address) Then
		JobParameters.Parameters.LoadData.Address = 
			PutToTempStorage(ServiceParameters.Parameters_LoadData_Address);
	EndIf;
	
	ServerEntryPoint(JobParameters.StepNames, JobParameters.Parameters, JobParameters.ExecuteLazySteps, True);
	JobParameters.Parameters.Object = Undefined;
	JobResult = New Structure();
	JobResult.Insert("Parameters", JobParameters.Parameters);	
	CommonFunctionsServer.PutToCache(JobResult, StorageAddress);
EndProcedure

Procedure SetJobCompletePercent(Parameters, Total, Complete) Export
	If Parameters.IsBackgroundJob Then
		Msg = CommonFunctionsServer.SerializeJSON(New Structure("Total, Complete", Total, Complete));
		Msg = "__complete__percent__" + Msg;
		CommonFunctionsClientServer.ShowUsersMessage(Msg);
	EndIf;
EndProcedure

Function GetJobStatus(BackgroundJobUUID, BackgroundJobStorageAddress) Export
	//Begin
	//End
	//ErrorInfo
	//Key
	//Location
	//MethodName
	//UUID
	JobResult = New Structure;
	JobResult.Insert("JobUUID", BackgroundJobUUID);
	JobResult.Insert("Status", Enums.JobStatus.EmptyRef());
	JobResult.Insert("StorageAddress", BackgroundJobStorageAddress);
	JobResult.Insert("CompletePercent", Undefined);
	JobResult.Insert("SystemMessages", New Array);
	JobResult.Insert("Result", Undefined);
	
	If Not ValueIsFilled(BackgroundJobUUID) Then
		Return JobResult;
	EndIf;
	
	Job = BackgroundJobs.FindByUUID(BackgroundJobUUID);
	
	If Job = Undefined Then
		Return JobResult;
	EndIf;
	
	If Job.State = BackgroundJobState.Active Then
		JobResult.Status = Enums.JobStatus.Active;
	ElsIf Job.State = BackgroundJobState.Canceled Then
		JobResult.Status = Enums.JobStatus.Canceled;
		JobResult.SystemMessages.Add(R().Form_019);
	ElsIf Job.State = BackgroundJobState.Completed Then
		JobResult.Status = Enums.JobStatus.Completed;
		JobResult.Result = CommonFunctionsServer.GetFromCache(BackgroundJobStorageAddress);
	ElsIf Job.State = BackgroundJobState.Failed Then
		JobResult.Status = Enums.JobStatus.Failed;
		JobResult.SystemMessages.Add(ErrorProcessing.DetailErrorDescription(Job.ErrorInfo));
	EndIf;
	
	ArrayOfMsg = Job.GetUserMessages(True);
	If ArrayOfMsg.Count() Then
		Msg_text = "";
		For Each Msg In ArrayOfMsg Do 
			If StrStartsWith(Msg.Text, "__complete__percent__") Then
				// we need only last msg
				Msg_text = StrReplace(Msg.Text, "__complete__percent__", "");
			Else
				JobResult.SystemMessages.Add(Msg.Text);
			EndIf;
		EndDo;
		
		If Not IsBlankString(Msg_text) Then
			JobResult.CompletePercent = CommonFunctionsServer.DeserializeJSON(Msg_text);
		EndIf;
	EndIf;

	Return JobResult;
EndFunction

Procedure ServerEntryPoint(StepNames, Parameters, ExecuteLazySteps, UpdateCacheIndex) Export	
	If UpdateCacheIndex And Parameters.Property("Cache") Then
		For Each KeyValue In Parameters.Cache Do
			If TypeOf(Parameters.Cache[KeyValue.Key]) <> Type("Array") Then
				Continue;
			EndIf;
				
			For Each Row In Parameters.Cache[KeyValue.Key] Do
				If Not Row.Property("Key") Then
					Continue;
				EndIf;
						
				Parameters.CacheRowsMap.Insert(KeyValue.Key+":"+Row.Key, Row);
			EndDo;
		EndDo;					
	EndIf;
	ModelClientServer_V2.ServerEntryPoint(StepNames, Parameters, ExecuteLazySteps);
EndProcedure

Function ExtractDataAgreementApArPostingDetailImp(Agreement) Export
	If Not ValueIsFilled(Agreement) Then
		Return Enums.ApArPostingDetail.EmptyRef();
	EndIf;
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Agreements.ApArPostingDetail
	|FROM
	|	Catalog.Agreements AS Agreements
	|WHERE
	|	Agreements.Ref = &Ref";
	Query.SetParameter("Ref", Agreement);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.ApArPostingDetail;
	EndIf;
	Return Enums.ApArPostingDetail.EmptyRef();
EndFunction
	
Function ConvertQuantityToQuantityInBaseUnit(Bundle, Unit, Quantity) Export
	If TypeOf(Bundle) = Type("CatalogRef.ItemKeys") Then
		Return Catalogs.Units.ConvertQuantityToQuantityInBaseUnit(Bundle, Unit, Quantity).QuantityInBaseUnit;
	ElsIf TypeOf(Bundle) = Type("CatalogRef.Items") Then
		Return Catalogs.Units.Convert(Unit, Bundle.Unit, Quantity);
	EndIf;
EndFunction

Function GetUnitFactor(FromUnit, ToUnit) Export
	Return Catalogs.Units.GetUnitFactor(FromUnit, ToUnit);
EndFunction

Function GetBankTermInfo(PaymentType, BankTerm) Export
	Return ServerReuse.GetBankTermInfo(PaymentType, BankTerm);
EndFunction

Function _GetBankTermInfo(PaymentType, BankTerm) Export
	Result = New Structure("Percent, Account, Partner, LegalName, PartnerTerms, LegalNameContract",
	0, Undefined, Undefined, Undefined, Undefined, Undefined);
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	BankTermsPaymentTypes.Percent AS Percent,
		|	BankTermsPaymentTypes.Account AS Account,
		|	BankTermsPaymentTypes.Partner AS Partner,
		|	BankTermsPaymentTypes.LegalName AS LegalName,
		|	BankTermsPaymentTypes.PartnerTerms AS PartnerTerms,
		|	BankTermsPaymentTypes.LegalNameContract AS LegalNameContract
		|FROM
		|	Catalog.BankTerms.PaymentTypes AS BankTermsPaymentTypes
		|WHERE
		|	BankTermsPaymentTypes.Ref = &Ref
		|	AND BankTermsPaymentTypes.PaymentType = &PaymentType";
	
	Query.SetParameter("Ref", BankTerm);
	Query.SetParameter("PaymentType", PaymentType);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		FillPropertyValues(Result, QuerySelection);
	EndIf;
	Return Result;
EndFunction

Function ConvertPriceByCurrency(Period, PriceType, CurrencyTo, Price) Export
	If Not ValueIsFilled(PriceType) Then
		Return Price;
	EndIf;
	
	CurrencyFrom = PriceType.Currency;
	If Not ValueIsFilled(CurrencyFrom) 
		Or Not ValueIsFilled(CurrencyTo) 
		Or CurrencyFrom = CurrencyTo Then
		Return Price;
	EndIf;
	
	CurrencyInfo = Catalogs.Currencies.GetCurrencyInfo(Period, 
			CurrencyFrom, 
			CurrencyTo,
			PriceType.Source);
	Rate = ?(ValueIsFilled(CurrencyInfo.Rate), CurrencyInfo.Rate, 0);
	Multiplicity = ?(ValueIsFilled(CurrencyInfo.Multiplicity), CurrencyInfo.Multiplicity, 0);
	
	If Rate = 0 Or Multiplicity = 0 Then
		Return Price;
	EndIf;
	
	PriceRecalculated = (Price * Rate) / Multiplicity;
	Return PriceRecalculated;
EndFunction

Function GetLandedCostCurrencyByCompany(Company) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Companies.LandedCostCurrencyMovementType.Currency AS Currency
	|FROM
	|	Catalog.Companies AS Companies
	|WHERE
	|	Companies.Ref = &Ref";
	Query.SetParameter("Ref", Company);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Currency;
	Else
		Return Undefined;
	EndIf;
EndFunction

Function GetBillOfMaterialsByItemKey(ItemKey, BusinessUnit) Export
	Return Catalogs.BillOfMaterials.GetBillOfMaterialsByItemKey(ItemKey, BusinessUnit);
EndFunction

Function GetExpenseTypeByBillOfMaterials(BillOfMaterials, ItemKey) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	BillOfMaterialsContent.ExpenseType AS ExpenseType
	|FROM
	|	Catalog.BillOfMaterials.Content AS BillOfMaterialsContent
	|WHERE
	|	BillOfMaterialsContent.Ref = &Ref
	|	AND BillOfMaterialsContent.ItemKey = &ItemKey";
	Query.SetParameter("Ref", BillOfMaterials);
	Query.SetParameter("ItemKey", ItemKey);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.ExpenseType;
	Else
		Return Undefined;
	EndIf;	
EndFunction

Function GetPlanningPeriod(Date, BusinessUnit) Export
	Query = New Query();
	Query.Text = 
	"SELECT TOP 2
	|	Table.Ref AS Ref
	|FROM
	|	Catalog.PlanningPeriods.BusinessUnits AS TableBusinessUnits
	|		INNER JOIN Catalog.PlanningPeriods AS Table
	|		ON Table.Ref = TableBusinessUnits.Ref
	|		AND &Date BETWEEN Table.BeginDate AND Table.EndDate
	|		AND NOT Table.DeletionMark
	|		AND TableBusinessUnits.BusinessUnit = &BusinessUnit";
	Query.SetParameter("Date", Date);
	Query.SetParameter("BusinessUnit", BusinessUnit);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Count() = 1 Then
		QuerySelection.Next();
		Return QuerySelection.Ref;
	EndIf;
	Return Catalogs.PlanningPeriods.EmptyRef();
EndFunction

Function GetDocumentProductionPlanning(Company, BusinessUnit, PlanningPeriod) Export
	Query = New Query();
	Query.Text = 
	"SELECT TOP 2
	|	ProductionPlanning.Ref
	|FROM
	|	Document.ProductionPlanning AS ProductionPlanning
	|WHERE
	|	ProductionPlanning.Company = &Company
	|	AND ProductionPlanning.BusinessUnit = &BusinessUnit
	|	AND ProductionPlanning.PlanningPeriod = &PlanningPeriod
	|	AND ProductionPlanning.Posted";
	Query.SetParameter("Company"         , Company);
	Query.SetParameter("BusinessUnit"    , BusinessUnit);
	Query.SetParameter("PlanningPeriod"  , PlanningPeriod);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Count() = 1 Then
		QuerySelection.Next();
		Return QuerySelection.Ref;
	EndIf;
	Return Documents.ProductionPlanning.EmptyRef();
EndFunction
	
Function GetCurrentQuantity(Company, ProductionPlanning, PlanningPeriod, BillOfMaterials, ItemKey) Export
	Return Documents.ProductionPlanningCorrection.GetCurrentQuantity(Company,
																		ProductionPlanning,
																		PlanningPeriod,  
	                                                                    BillOfMaterials,
	                                                                    ItemKey);
EndFunction
	
Function GetPartnerTypeByTransactionType(TransactionType) Export
	Map = New Map();
	Map.Insert(Enums.PurchaseTransactionTypes.Purchase             , "Vendor");
	Map.Insert(Enums.PurchaseTransactionTypes.ReceiptFromConsignor , "Consignor");
	
	Map.Insert(Enums.SalesTransactionTypes.Sales                , "Customer");
	Map.Insert(Enums.SalesTransactionTypes.ShipmentToTradeAgent , "TradeAgent");
	Map.Insert(Enums.SalesTransactionTypes.RetailSales          , "Customer");
	
	Map.Insert(Enums.SalesReturnTransactionTypes.ReturnFromCustomer   , "Customer");
	Map.Insert(Enums.SalesReturnTransactionTypes.ReturnFromTradeAgent , "TradeAgent");

	Map.Insert(Enums.PurchaseReturnTransactionTypes.ReturnToVendor    , "Vendor");
	Map.Insert(Enums.PurchaseReturnTransactionTypes.ReturnToConsignor , "Consignor");
	
	Map.Insert(Enums.ShipmentConfirmationTransactionTypes.Sales                , "Customer");
	Map.Insert(Enums.ShipmentConfirmationTransactionTypes.ReturnToVendor       , "Vendor");
	Map.Insert(Enums.ShipmentConfirmationTransactionTypes.ShipmentToTradeAgent , "TradeAgent");
	Map.Insert(Enums.ShipmentConfirmationTransactionTypes.ReturnToConsignor    , "Consignor");
	
	Map.Insert(Enums.GoodsReceiptTransactionTypes.Purchase             , "Vendor");
	Map.Insert(Enums.GoodsReceiptTransactionTypes.ReturnFromCustomer   , "Customer");
	Map.Insert(Enums.GoodsReceiptTransactionTypes.ReceiptFromConsignor , "Consignor");
	Map.Insert(Enums.GoodsReceiptTransactionTypes.ReturnFromTradeAgent , "TradeAgent");
	
	Map.Insert(Enums.RetailGoodsReceiptTransactionTypes.CourierDelivery , "Vendor");
	Map.Insert(Enums.RetailShipmentConfirmationTransactionTypes.CourierDelivery , "Vendor");
	
	Map.Insert(Enums.OutgoingPaymentTransactionTypes.PaymentToVendor , "Vendor");
	Map.Insert(Enums.OutgoingPaymentTransactionTypes.ReturnToCustomer , "Customer");
	Map.Insert(Enums.OutgoingPaymentTransactionTypes.ReturnToCustomerByPOS , "Customer");
	Map.Insert(Enums.OutgoingPaymentTransactionTypes.OtherPartner , "Other");
	Map.Insert(Enums.OutgoingPaymentTransactionTypes.OtherExpense , "Other");
	Map.Insert(Enums.OutgoingPaymentTransactionTypes.EmployeeCashAdvance , "Other");
	
	Map.Insert(Enums.IncomingPaymentTransactionType.ReturnFromVendor , "Vendor");
	Map.Insert(Enums.IncomingPaymentTransactionType.PaymentFromCustomer , "Customer");
	Map.Insert(Enums.IncomingPaymentTransactionType.PaymentFromCustomerByPOS , "Customer");
	Map.Insert(Enums.IncomingPaymentTransactionType.OtherPartner , "Other");
	Map.Insert(Enums.IncomingPaymentTransactionType.OtherIncome , "Other");
	
	Map.Insert(Enums.TaxesOperationTransactionType.TaxOffset , "Other");
	Map.Insert(Enums.TaxesOperationTransactionType.TaxOffsetAndPayment , "Other");
	Map.Insert(Enums.TaxesOperationTransactionType.TaxPayment , "Other");
		
	Return Map.Get(TransactionType);
EndFunction

Function GetAgreementTypeByTransactionType(TransactionType) Export
	PartnerType = GetPartnerTypeByTransactionType(TransactionType);
	If PartnerType = "Customer" Then
		Return Enums.AgreementTypes.Customer;
	ElsIf PartnerType = "Vendor" Then
		Return Enums.AgreementTypes.Vendor;
	ElsIf PartnerType = "Consignor" Then
		Return Enums.AgreementTypes.Consignor;
	ElsIf PartnerType = "TradeAgent" Then
		Return Enums.AgreementTypes.TradeAgent;
	ElsIf PartnerType = "RetailCustomer" Then
		Return Enums.AgreementTypes.EmptyRef();
	ElsIf PartnerType = "Other" Then
		Return Enums.AgreementTypes.Other;
	ElsIf PartnerType = "Employee" Then
		Return Enums.AgreementTypes.Other;		
	Else
		Return Enums.AgreementTypes.EmptyRef();
	EndIf;
EndFunction	

Function GetAgreementTypeByDebtType(DebtType) Export
	If Not ValueIsFilled(DebtType) Then
		Return Enums.AgreementTypes.EmptyRef();
	EndIf;
	
	If DebtType = Enums.DebtTypes.AdvanceCustomer 
		Or DebtType = Enums.DebtTypes.TransactionCustomer Then
		Return Enums.AgreementTypes.Customer;
	ElsIf DebtType = Enums.DebtTypes.AdvanceVendor
		Or DebtType = Enums.DebtTypes.TransactionVendor Then
		Return Enums.AgreementTypes.Vendor;
	Else
		Raise StrTemplate("Unknown AgreementType by DebtType [%1]", DebtType);
	EndIf;
EndFunction	
	
Function GetBankTermsByPaymentType(PaymentType, Branch) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	Table.Ref AS Ref
	|FROM
	|	Catalog.BankTerms AS Table
	|		INNER JOIN Catalog.BankTerms.PaymentTypes AS TablePaymentTypes
	|		ON Table.Ref = TablePaymentTypes.Ref
	|		AND NOT Table.DeletionMark
	|		AND TablePaymentTypes.PaymentType = &PaymentType
	|		INNER JOIN InformationRegister.BranchBankTerms AS BranchBankTerms
	|		ON BranchBankTerms.BankTerm = Table.Ref
	|		AND BranchBankTerms.Branch = &Branch
	|GROUP BY
	|	Table.Ref";
	
	Query.SetParameter("PaymentType", PaymentType);
	Query.SetParameter("Branch", Branch);
	
	QueryResult = Query.Execute();
	ArrayOfRefs = QueryResult.Unload().UnloadColumn("Ref");
	Return ArrayOfRefs;
EndFunction

Function GetPaymentTypesByBankTerm(BankTerm) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	Table.PaymentType AS Ref
	|FROM
	|	Catalog.BankTerms.PaymentTypes AS Table
	|WHERE
	|	Table.Ref = &BankTerm
	|	AND NOT Table.PaymentType.DeletionMark
	|GROUP BY
	|	Table.PaymentType";
	Query.SetParameter("BankTerm", BankTerm);
	QueryResult = Query.Execute();
	ArrayOfRefs = QueryResult.Unload().UnloadColumn("Ref");
	Return ArrayOfRefs;
EndFunction
