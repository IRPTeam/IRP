#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;
	Parameters.IsReposting = False;

	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	
	If ValueIsFilled(Ref.SalesOrder) Then
		Tables.Insert("CurrencyTable", Ref.SalesOrder.Currencies.Unload());
	EndIf;
	
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map;
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region CheckAfterWrite

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
	CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo);
EndProcedure

Procedure CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.SalesOrderClosing.ItemList", AddInfo);
EndProcedure

#EndRegion

#Region Posting_Info

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure;
	StrParams.Insert("SalesOrder", Ref.SalesOrder);
	StrParams.Insert("Period", Ref.Date);
	If ValueIsFilled(Ref) Then
		StrParams.Insert("BalancePeriod", New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	Else
		StrParams.Insert("BalancePeriod", Undefined);
	EndIf;
	Return StrParams;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	Return QueryArray;
EndFunction

Function ItemList()
	Return "SELECT
		   |	Closing.Ref.Date AS Period,
		   |	Order.Ref.Company,
		   |	Order.Ref.Branch,
		   |	Order.Ref.Currency,
		   |	Order.Ref AS Order,
		   |	Order.ItemKey,
		   |	Order.Key AS RowKey,
		   |	Order.ProcurementMethod,
		   |	Order.SalesPerson,
		   |	Closing.Cancel,
		   |	Closing.CancelReason,
		   |	Order.IsService,
		   |	Order.ProcurementMethod = VALUE(Enum.ProcurementMethods.Purchase) AS IsProcurementMethod_Purchase,
		   |	Closing.QuantityInBaseUnit AS Quantity,
		   |	CASE
		   |		WHEN Order.QuantityInBaseUnit = 0
		   |			THEN 0
		   |		ELSE CASE
		   |			WHEN Order.QuantityInBaseUnit = Closing.QuantityInBaseUnit
		   |				THEN Order.TotalAmount
		   |			ELSE Order.TotalAmount / Order.QuantityInBaseUnit * Closing.QuantityInBaseUnit
		   |		END
		   |	END AS TotalAmount,
		   |	CASE
		   |		WHEN Order.QuantityInBaseUnit = 0
		   |			THEN 0
		   |		ELSE CASE
		   |			WHEN Order.QuantityInBaseUnit = Closing.QuantityInBaseUnit
		   |				THEN Order.NetAmount
		   |			ELSE Order.NetAmount / Order.QuantityInBaseUnit * Closing.QuantityInBaseUnit
		   |		END
		   |	END AS NetAmount,
		   |	CASE
		   |		WHEN Order.QuantityInBaseUnit = 0
		   |			THEN 0
		   |		ELSE CASE
		   |			WHEN Order.OffersAmount = Order.QuantityInBaseUnit
		   |				THEN Order.OffersAmount
		   |			ELSE Order.OffersAmount / Order.QuantityInBaseUnit * Closing.QuantityInBaseUnit
		   |		END
		   |	END AS OffersAmount
		   |INTO ItemList
		   |FROM
		   |	Document.SalesOrder.ItemList AS Order
		   |		INNER JOIN Document.SalesOrderClosing.ItemList AS Closing
		   |		ON Order.Ref = Closing.Ref.SalesOrder
		   |		AND Order.Key = Closing.SalesOrderKey
		   |		AND Closing.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R2010T_SalesOrders());
	QueryArray.Add(R2011B_SalesOrdersShipment());
	QueryArray.Add(R2012B_SalesOrdersInvoiceClosing());
	QueryArray.Add(R2013T_SalesOrdersProcurement());
	QueryArray.Add(R2014T_CanceledSalesOrders());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R3024B_SalesOrdersToBePaid());
	QueryArray.Add(R3026B_SalesOrdersCustomerAdvance());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4012B_StockReservation());
	QueryArray.Add(R4034B_GoodsShipmentSchedule());
	QueryArray.Add(R5011B_CustomersAging());
	QueryArray.Add(T2014S_AdvancesInfo());
	Return QueryArray;
EndFunction

Function R2010T_SalesOrders()
	Return "SELECT
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.Currency,
		   |	ItemList.Order,
		   |	ItemList.ItemKey,
		   |	ItemList.RowKey,
		   |	ItemList.ProcurementMethod,
		   |	ItemList.SalesPerson,
		   |	-ItemList.Quantity AS Quantity,
		   |	-ItemList.TotalAmount AS Amount,
		   |	-ItemList.NetAmount AS NetAmount,
		   |	-ItemList.OffersAmount AS OffersAmount
		   |INTO R2010T_SalesOrders
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.Cancel
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.Currency,
		   |	ItemList.Order,
		   |	ItemList.ItemKey,
		   |	ItemList.RowKey,
		   |	ItemList.ProcurementMethod,
		   |	ItemList.SalesPerson,
		   |	ItemList.Quantity AS Quantity,
		   |	ItemList.TotalAmount AS Amount,
		   |	ItemList.NetAmount AS NetAmount,
		   |	ItemList.OffersAmount AS OffersAmount
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.Cancel";
EndFunction

Function R2011B_SalesOrdersShipment()
	Return "SELECT
		   |	&Period AS Period,
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	-R2011B_SalesOrdersShipmentBalance.QuantityBalance AS Quantity,
		   |	*
		   |INTO R2011B_SalesOrdersShipment
		   |FROM
		   |	AccumulationRegister.R2011B_SalesOrdersShipment.Balance(&BalancePeriod, Order = &SalesOrder) AS
		   |		R2011B_SalesOrdersShipmentBalance";
EndFunction

Function R2012B_SalesOrdersInvoiceClosing()
	Return "SELECT
		   |	&Period AS Period,
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	-R2012B_SalesOrdersInvoiceClosingBalance.QuantityBalance AS Quantity,
		   |	-R2012B_SalesOrdersInvoiceClosingBalance.AmountBalance AS Amount,
		   |	-R2012B_SalesOrdersInvoiceClosingBalance.NetAmountBalance AS NetAmount,
		   |	*
		   |INTO R2012B_SalesOrdersInvoiceClosing
		   |FROM
		   |	AccumulationRegister.R2012B_SalesOrdersInvoiceClosing.Balance(&BalancePeriod, Order = &SalesOrder) AS
		   |		R2012B_SalesOrdersInvoiceClosingBalance";
EndFunction

Function R2013T_SalesOrdersProcurement()
	Return "SELECT
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.Order,
		   |	ItemList.ItemKey,
		   |	-ItemList.Quantity AS OrderedQuantity,
		   |	-ItemList.NetAmount AS OrderedNetAmount,
		   |	-ItemList.TotalAmount AS OrderedTotalAmount
		   |INTO R2013T_SalesOrdersProcurement
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.Cancel
		   |	AND NOT ItemList.IsService
		   |	AND ItemList.IsProcurementMethod_Purchase";
EndFunction

Function R2014T_CanceledSalesOrders()
	Return "SELECT
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.Currency,
		   |	ItemList.Order,
		   |	ItemList.ItemKey,
		   |	ItemList.RowKey,
		   |	ItemList.CancelReason,
		   |	ItemList.SalesPerson,
		   |	ItemList.Quantity AS Quantity,
		   |	ItemList.TotalAmount AS Amount,
		   |	ItemList.NetAmount AS NetAmount
		   |INTO R2014T_CanceledSalesOrders
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.Cancel";
EndFunction

Function R4011B_FreeStocks()
	Return "SELECT
		   |	&Period AS Period,
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	StockReservation.Store AS Store,
		   |	StockReservation.ItemKey AS ItemKey,
		   |	StockReservation.Order AS Order,
		   |	-StockReservation.QuantityBalance AS Quantity
		   |INTO R4011B_FreeStocks
		   |FROM
		   |	AccumulationRegister.R4012B_StockReservation.Balance(&BalancePeriod, Order = &SalesOrder) AS StockReservation";
EndFunction

Function R4012B_StockReservation()
	Return "SELECT
		   |	&Period AS Period,
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	StockReservation.Store AS Store,
		   |	StockReservation.ItemKey AS ItemKey,
		   |	StockReservation.Order AS Order,
		   |	-StockReservation.QuantityBalance AS Quantity
		   |INTO R4012B_StockReservation
		   |FROM
		   |	AccumulationRegister.R4012B_StockReservation.Balance(&BalancePeriod, Order = &SalesOrder) AS StockReservation";
EndFunction

Function R4034B_GoodsShipmentSchedule()
	Return "SELECT
		   |	&Period AS Period,
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	-R4034B_GoodsShipmentScheduleBalance.QuantityBalance AS Quantity,
		   |	*
		   |INTO R4034B_GoodsShipmentSchedule
		   |FROM
		   |	AccumulationRegister.R4034B_GoodsShipmentSchedule.Balance(&BalancePeriod, Basis = &SalesOrder) AS
		   |		R4034B_GoodsShipmentScheduleBalance";
EndFunction

Function R3024B_SalesOrdersToBePaid()
	Return "SELECT
		   |	&Period AS Period,
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	Balance.AmountBalance AS Amount,
		   |	*
		   |INTO R3024B_SalesOrdersToBePaid
		   |FROM
		   |	AccumulationRegister.R3024B_SalesOrdersToBePaid.Balance(&BalancePeriod, Order = &SalesOrder) AS Balance";
EndFunction

Function R3026B_SalesOrdersCustomerAdvance()
	Return "SELECT
		   |	&Period AS Period,
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	Balance.AmountBalance AS Amount,
		   |	*
		   |INTO R3026B_SalesOrdersCustomerAdvance
		   |FROM
		   |	AccumulationRegister.R3026B_SalesOrdersCustomerAdvance.Balance(&BalancePeriod, Order = &SalesOrder) AS Balance";
EndFunction

Function T2014S_AdvancesInfo()
	Return "SELECT
		   |	&Period AS Date,
		   |	Doc.Company,
		   |	Doc.Branch,
		   |	Doc.Currency,
		   |	Doc.Partner,
		   |	Doc.LegalName,
		   |	Doc.Ref AS Order,
		   |	TRUE AS IsCustomerAdvance,
		   |	TRUE AS IsSalesOrderClose
		   |INTO T2014S_AdvancesInfo
		   |FROM
		   |	Document.SalesOrder AS Doc
		   |WHERE
		   |	Doc.Ref = &SalesOrder";
EndFunction

Function R2020B_AdvancesFromCustomers()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	OffsetOfAdvances.Period,
		   |	OffsetOfAdvances.Company,
		   |	OffsetOfAdvances.Branch,
		   |	OffsetOfAdvances.Partner,
		   |	OffsetOfAdvances.LegalName,
		   |	OffsetOfAdvances.Currency,
		   |	OffsetOfAdvances.AdvancesOrder AS Order,
		   |	OffsetOfAdvances.Amount,
		   |	OffsetOfAdvances.Recorder AS VendorsAdvancesClosing
		   |INTO R2020B_AdvancesFromCustomers
		   |FROM
		   |	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		   |WHERE
		   |	OffsetOfAdvances.Document = &Ref";
EndFunction

Function R2021B_CustomersTransactions()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	OffsetOfAdvances.Period,
		   |	OffsetOfAdvances.Company,
		   |	OffsetOfAdvances.Branch,
		   |	OffsetOfAdvances.Partner,
		   |	OffsetOfAdvances.LegalName,
		   |	OffsetOfAdvances.Currency,
		   |	OffsetOfAdvances.Agreement,
		   |	OffsetOfAdvances.TransactionDocument AS Basis,
		   |	OffsetOfAdvances.TransactionOrder AS Order,
		   |	OffsetOfAdvances.Amount,
		   |	OffsetOfAdvances.Recorder AS VendorsAdvancesClosing
		   |INTO R2021B_CustomersTransactions
		   |FROM
		   |	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		   |WHERE
		   |	OffsetOfAdvances.Document = &Ref
		   |	AND NOT OffsetOfAdvances.IsAdvanceRelease";
EndFunction

Function R5011B_CustomersAging()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	OffsetOfAging.Period,
		   |	OffsetOfAging.Company,
		   |	OffsetOfAging.Branch,
		   |	OffsetOfAging.Partner,
		   |	OffsetOfAging.Agreement,
		   |	OffsetOfAging.Currency,
		   |	OffsetOfAging.Invoice,
		   |	OffsetOfAging.PaymentDate,
		   |	OffsetOfAging.Amount,
		   |	OffsetOfAging.Recorder AS AgingClosing
		   |INTO R5011B_CustomersAging
		   |FROM
		   |	InformationRegister.T2013S_OffsetOfAging AS OffsetOfAging
		   |WHERE
		   |	OffsetOfAging.Document = &Ref";
EndFunction

#EndRegion

#Region AccessObject

// Get access key.
// 
// Parameters:
//  Obj - DocumentObjectDocumentName -
// 
// Returns:
//  Map
Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	AccessKeyMap.Insert("Company", Obj.Company);
	AccessKeyMap.Insert("Branch", Obj.Branch);
	StoreList = Obj.ItemList.Unload(, "Store");
	StoreList.GroupBy("Store");
	AccessKeyMap.Insert("Store", StoreList.UnloadColumn("Store"));
	Return AccessKeyMap;
EndFunction

#EndRegion