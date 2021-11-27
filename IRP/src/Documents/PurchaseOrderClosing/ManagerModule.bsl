#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParamenters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
#Region NewRegisterPosting
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Tables = PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	Return Tables;
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region CheckAfterWrite

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
	Return;
EndProcedure

#EndRegion

#Region NewRegistersPosting

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure();
	Str.Insert("QueryParameters", GetAdditionalQueryParamenters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParamenters(Ref)
	StrParams = New Structure();
	StrParams.Insert("PurchaseOrder", Ref.PurchaseOrder);
	StrParams.Insert("Period", Ref.Date);
	If ValueIsFilled(Ref) Then
		StrParams.Insert("BalancePeriod", New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	Else
		StrParams.Insert("BalancePeriod", Undefined);
	EndIf;
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array();
	QueryArray.Add(ItemList());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R1010T_PurchaseOrders());
	QueryArray.Add(R1011B_PurchaseOrdersReceipt());
	QueryArray.Add(R1012B_PurchaseOrdersInvoiceClosing());
	QueryArray.Add(R1014T_CanceledPurchaseOrders());
	QueryArray.Add(R4033B_GoodsReceiptSchedule());
	QueryArray.Add(R4035B_IncomingStocks());
	QueryArray.Add(R3025B_PurchaseOrdersToBePaid());
	QueryArray.Add(T2014S_AdvancesInfo());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R5012B_VendorsAging());
	Return QueryArray;
EndFunction

Function ItemList()
	Return "SELECT
		   |	PurchaseOrderItems.Ref.Company AS Company,
		   |	PurchaseOrderItems.Store AS Store,
		   |	PurchaseOrderItems.Store.UseGoodsReceipt AS UseGoodsReceipt,
		   |	PurchaseOrderItems.Ref.PurchaseOrder AS Order,
		   |	PurchaseOrderItems.PurchaseBasis AS PurchaseBasis,
		   |	PurchaseOrderItems.ItemKey.Item AS Item,
		   |	PurchaseOrderItems.ItemKey AS ItemKey,
		   |	PurchaseOrderItems.Quantity AS UnitQuantity,
		   |	PurchaseOrderItems.QuantityInBaseUnit AS Quantity,
		   |	PurchaseOrderItems.Unit,
		   |	PurchaseOrderItems.Ref.Date AS Period,
		   |	PurchaseOrderItems.Key AS RowKey,
		   |	PurchaseOrderItems.ProfitLossCenter AS ProfitLossCenter,
		   |	PurchaseOrderItems.ExpenseType AS ExpenseType,
		   |	PurchaseOrderItems.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
		   |	PurchaseOrderItems.DeliveryDate AS DeliveryDate,
		   |	PurchaseOrderItems.InternalSupplyRequest AS InternalSupplyRequest,
		   |	PurchaseOrderItems.SalesOrder AS SalesOrder,
		   |	PurchaseOrderItems.Cancel AS IsCanceled,
		   |	PurchaseOrderItems.CancelReason,
		   |	PurchaseOrderItems.TotalAmount AS Amount,
		   |	PurchaseOrderItems.NetAmount,
		   |	PurchaseOrderItems.Ref.UseItemsReceiptScheduling AS UseItemsReceiptScheduling,
		   |	PurchaseOrderItems.PurchaseBasis REFS Document.SalesOrder
		   |	AND NOT PurchaseOrderItems.PurchaseBasis.REF IS NULL AS UseSalesOrder,
		   |	PurchaseOrderItems.OffersAmount,
		   |	PurchaseOrderItems.Ref.Currency AS Currency,
		   |	PurchaseOrderItems.Ref.Branch AS Branch,
		   |	PurchaseOrderItems.Ref.Partner AS Partner,
		   |	PurchaseOrderItems.Ref.LegalName AS LegalName
		   |INTO ItemList
		   |FROM
		   |	Document.PurchaseOrderClosing.ItemList AS PurchaseOrderItems
		   |WHERE
		   |	PurchaseOrderItems.Ref = &Ref";
EndFunction

Function R1010T_PurchaseOrders()
	Return "SELECT 
		   |	- QueryTable.Quantity AS Quantity,
		   |	- QueryTable.OffersAmount AS OffersAmount,
		   |	- QueryTable.NetAmount AS NetAmount,
		   |	- QueryTable.Amount AS Amount,
		   |	*
		   |INTO R1010T_PurchaseOrders
		   |FROM
		   |	ItemList AS QueryTable
		   |WHERE QueryTable.isCanceled
		   |
		   |UNION ALL
		   |
		   |SELECT 
		   |	QueryTable.Quantity AS Quantity,
		   |	QueryTable.OffersAmount AS OffersAmount,
		   |	QueryTable.NetAmount AS NetAmount,
		   |	QueryTable.Amount AS Amount,
		   |	*
		   |FROM
		   |	ItemList AS QueryTable
		   |WHERE NOT QueryTable.isCanceled";

EndFunction

Function R1011B_PurchaseOrdersReceipt()
	Return "SELECT
		   |	&Period AS Period,
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	-Balance.QuantityBalance AS Quantity,
		   |	*
		   |INTO R1011B_PurchaseOrdersReceipt
		   |FROM
		   |	AccumulationRegister.R1011B_PurchaseOrdersReceipt.Balance(&BalancePeriod, Order = &PurchaseOrder) AS Balance";
EndFunction

Function R1012B_PurchaseOrdersInvoiceClosing()
	Return "SELECT
		   |	&Period AS Period,
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	-PurchaseOrdersInvoiceClosing.QuantityBalance AS Quantity,
		   |	-PurchaseOrdersInvoiceClosing.AmountBalance AS Amount,
		   |	-PurchaseOrdersInvoiceClosing.NetAmountBalance AS NetAmount,
		   |	*
		   |INTO R1012B_PurchaseOrdersInvoiceClosing
		   |FROM
		   |	AccumulationRegister.R1012B_PurchaseOrdersInvoiceClosing.Balance(&BalancePeriod, Order = &PurchaseOrder) AS
		   |		PurchaseOrdersInvoiceClosing";

EndFunction

Function R1014T_CanceledPurchaseOrders()
	Return "SELECT *
		   |INTO R1014T_CanceledPurchaseOrders
		   |FROM
		   |	ItemList AS QueryTable
		   |WHERE QueryTable.isCanceled";

EndFunction

Function R4033B_GoodsReceiptSchedule()
	Return "SELECT 
		   |	&Period AS Period,
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	-IncomingStocks.QuantityBalance AS Quantity,
		   |	*
		   |
		   |INTO R4033B_GoodsReceiptSchedule
		   |FROM
		   |	AccumulationRegister.R4033B_GoodsReceiptSchedule.Balance(&BalancePeriod, Basis = &PurchaseOrder) AS
		   |		IncomingStocks";

EndFunction

Function R4035B_IncomingStocks()
	Return "SELECT
		   |	&Period AS Period,
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	-IncomingStocks.QuantityBalance AS Quantity,
		   |	*
		   |INTO R4035B_IncomingStocks
		   |FROM
		   |	AccumulationRegister.R4035B_IncomingStocks.Balance(&BalancePeriod, Order = &PurchaseOrder) AS
		   |		IncomingStocks";

EndFunction

Function R3025B_PurchaseOrdersToBePaid()
	Return 
	"SELECT
	|	&Period AS Period,
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	Balance.AmountBalance AS Amount,
	|	*
	|INTO R3025B_PurchaseOrdersToBePaid
	|FROM
	|	AccumulationRegister.R3025B_PurchaseOrdersToBePaid.Balance(&BalancePeriod, Order = &PurchaseOrder) AS Balance";
EndFunction

Function T2014S_AdvancesInfo()
	Return 
	"SELECT
	|	Doc.Date,
	|	Doc.Company,
	|	Doc.Branch,
	|	Doc.Currency,
	|	Doc.Partner,
	|	Doc.LegalName,
	|	Doc.PurchaseOrder AS Order,
	|	TRUE AS IsVendorAdvance,
	|	TRUE AS IsPurchaseOrderClose
	|INTO T2014S_AdvancesInfo
	|FROM
	|	Document.PurchaseOrderClosing AS Doc
	|WHERE
	|	Doc.Ref = &Ref";
EndFunction

Function R1020B_AdvancesToVendors()
	Return
	"SELECT
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
	|INTO R1020B_AdvancesToVendors
	|FROM
	|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
	|WHERE
	|	OffsetOfAdvances.Document = &Ref";
EndFunction

Function R1021B_VendorsTransactions()
	Return 
	"SELECT
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
	|INTO R1021B_VendorsTransactions
	|FROM
	|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
	|WHERE
	|	OffsetOfAdvances.Document = &Ref
	|	AND NOT OffsetOfAdvances.IsAdvanceRelease";
EndFunction

Function R5012B_VendorsAging()
	Return 
	"SELECT
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
	|INTO R5012B_VendorsAging
	|FROM
	|	InformationRegister.T2013S_OffsetOfAging AS OffsetOfAging
	|WHERE
	|	OffsetOfAging.Document = &Ref";
EndFunction

#EndRegion