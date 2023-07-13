
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
	
	BackgroundJobs.Execute("ModelServer_V2.BackgroundJob", BackgroundParameters, JobKey);
	Return New Structure("BackgroungJobKey, BackgroungJobStorageAddress", JobKey, StorageAddress);
EndFunction

Procedure BackgroundJob(JobParameters, StorageAddress, ServiceParameters) Export
	JobParameters.Parameters.Object = 
		CommonFunctionsServer.DeserializeXMLUseXDTO(JobParameters.Parameters.Object);
	
	If ValueIsFilled(ServiceParameters.Parameters_LoadData_Address) Then
		JobParameters.Parameters.LoadData.Address = 
			PutToTempStorage(ServiceParameters.Parameters_LoadData_Address);
	EndIf;
	
	ServerEntryPoint(JobParameters.StepNames, JobParameters.Parameters, JobParameters.ExecuteLazySteps);
	JobResult = New Structure();
	JobResult.Insert("TestMessage", "test message from BJ");
	JobResult.Insert("Parameters", JobParameters.Parameters);	
	PutToTempStorage(JobResult, StorageAddress);
EndProcedure

Procedure SetJobCompletePercent(Parameters, Total, Complete) Export
	If Parameters.IsBackgroundJob Then
		Msg = CommonFunctionsServer.SerializeJSON(New Structure("Total, Complete", Total, Complete));
		Msg = "__complete__percent__" + Msg;
		Message(Msg);
	EndIf;
EndProcedure

Function GetJobStatus(BackgroungJobKey, BackgroungJobStorageAddress) Export
	//Begin
	//End
	//ErrorInfo
	//Key
	//Location
	//MethodName
	//UUID
	JobResult = New Structure("JobKey, Status, StorageAddress, CompletePercent");
		
	JobResult.StorageAddress = BackgroungJobStorageAddress;
	
	If Not ValueIsFilled(BackgroungJobKey) Then
		Return JobResult;
	EndIf;
	
	ArrayOfJobs = BackgroundJobs.GetBackgroundJobs();
	Job = Undefined;
	For Each ItemOfArray In ArrayOfJobs Do
		If ItemOfArray.Key = BackgroungJobKey Then
			Job = ItemOfArray;
			Break;
		EndIf;
	EndDo;
	
	If Job = Undefined Then
		Return JobResult;
	EndIf;
	
	JobResult.JobKey = BackgroungJobKey;
	
	If Job.State = BackgroundJobState.Active Then
		JobResult.Status = "Active";
	ElsIf Job.State = BackgroundJobState.Canceled Then
		JobResult.Status = "Canceled";
	ElsIf Job.State = BackgroundJobState.Completed Then
		JobResult.Status = "Completed";
	ElsIf Job.State = BackgroundJobState.Failed Then
		JobResult.Status = "Failed";
	EndIf;
	
	ArrayOfMsg = Job.GetUserMessages(True);
	If ArrayOfMsg.Count() Then
		Msg = ArrayOfMsg[ArrayOfMsg.Count() - 1];
		If StrStartsWith(Msg.Text, "__complete__percent__") Then
			Msg_text = StrReplace(Msg.Text, "__complete__percent__", "");
			JobResult.CompletePercent = CommonFunctionsServer.DeserializeJSON(Msg_text);
		EndIf;
	EndIf;

	Return JobResult;
EndFunction

Procedure ServerEntryPoint(StepNames, Parameters, ExecuteLazySteps) Export	
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

Function GetCommissionPercentExecute(Options) Export
	Query = New Query;
	Query.Text =
		"SELECT
		|	BankTermsPaymentTypes.Percent
		|FROM
		|	Catalog.BankTerms.PaymentTypes AS BankTermsPaymentTypes
		|WHERE
		|	BankTermsPaymentTypes.Ref = &Ref
		|	AND BankTermsPaymentTypes.PaymentType = &PaymentType";
	
	Query.SetParameter("Ref", Options.BankTerm);
	Query.SetParameter("PaymentType", Options.PaymentType);
	
	QueryResult = Query.Execute();
	
	SelectionDetailRecords = QueryResult.Select();
	
	While SelectionDetailRecords.Next() Do
		Return SelectionDetailRecords.Percent;
	EndDo;

	Return 0;
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
	//Map.Insert(Enums.SalesTransactionTypes.RetailSales          , "RetailCustomer");
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
	Else
		Raise StrTemplate("Unknown AgreementType by TransactionType [%1]", TransactionType);
	EndIf;
EndFunction	
	
	
