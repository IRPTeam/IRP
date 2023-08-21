#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;

	ObjectStatusesServer.WriteStatusToRegister(Ref, Ref.Status);
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	Parameters.Insert("StatusInfo", StatusInfo);
	If Not StatusInfo.Posting Then
		QueryArray = GetQueryTextsSecondaryTables();
		Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
		PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
		Return Tables;
	EndIf;

	Parameters.IsReposting = False;

	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
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
	Unposting = ?(Parameters.Property("Unposting"), Parameters.Unposting, False);
	AccReg = AccumulationRegisters;

	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	If StatusInfo.Posting Then
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "BalancePeriod",
			New Boundary(New PointInTime(StatusInfo.Period, Ref), BoundaryType.Including));
	EndIf;

	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref,
		"Document.PurchaseOrder.ItemList");
	If Not Cancel And Not AccReg.R4035B_IncomingStocks.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R4035B_IncomingStocks", Parameters), PostingServer.GetQueryTableByName(
		"Exists_R4035B_IncomingStocks", Parameters), AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
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
	StrParams.Insert("Ref", Ref);
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	StrParams.Insert("StatusInfoPosting", StatusInfo.Posting);
	Return StrParams;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(Exists_R4035B_IncomingStocks());
	Return QueryArray;
EndFunction

Function ItemList()
	Return "SELECT
		   |	RowIDInfo.Ref AS Ref,
		   |	RowIDInfo.Key AS Key,
		   |	MAX(RowIDInfo.RowID) AS RowID
		   |INTO TableRowIDInfo
		   |FROM
		   |	Document.PurchaseOrder.RowIDInfo AS RowIDInfo
		   |WHERE
		   |	RowIDInfo.Ref = &Ref
		   |GROUP BY
		   |	RowIDInfo.Ref,
		   |	RowIDInfo.Key
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	PurchaseOrderItems.Ref.Company AS Company,
		   |	PurchaseOrderItems.Store AS Store,
		   |	PurchaseOrderItems.Store.UseGoodsReceipt AS UseGoodsReceipt,
		   |	PurchaseOrderItems.Ref AS Order,
		   |	PurchaseOrderItems.PurchaseBasis AS PurchaseBasis,
		   |	PurchaseOrderItems.ItemKey.Item AS Item,
		   |	PurchaseOrderItems.ItemKey AS ItemKey,
		   |	PurchaseOrderItems.Quantity AS UnitQuantity,
		   |	PurchaseOrderItems.QuantityInBaseUnit AS Quantity,
		   |	PurchaseOrderItems.Unit,
		   |	PurchaseOrderItems.Ref.Date AS Period,
		   |	ISNULL(TableRowIDInfo.RowID, PurchaseOrderItems.Key)  AS RowKey,
		   |	PurchaseOrderItems.ProfitLossCenter AS ProfitLossCenter,
		   |	PurchaseOrderItems.ExpenseType AS ExpenseType,
		   |	PurchaseOrderItems.IsService AS IsService,
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
		   |	PurchaseOrderItems.Ref.Currency AS Currency,
		   |	&StatusInfoPosting,
		   |	PurchaseOrderItems.Ref.Agreement AS Agreement,
		   |	PurchaseOrderItems.Ref.Partner AS Partner,
		   |	PurchaseOrderItems.Ref.LegalName,
		   |	PurchaseOrderItems.Ref.Branch AS Branch
		   |INTO ItemList
		   |FROM
		   |	Document.PurchaseOrder.ItemList AS PurchaseOrderItems
		   |		LEFT JOIN TableRowIDInfo AS TableRowIDInfo
		   |		ON PurchaseOrderItems.Key = TableRowIDInfo.Key
		   |WHERE
		   |	PurchaseOrderItems.Ref = &Ref
		   |	AND &StatusInfoPosting";
EndFunction

Function Exists_R4035B_IncomingStocks()
	Return "SELECT *
		   |	INTO Exists_R4035B_IncomingStocks
		   |FROM
		   |	AccumulationRegister.R4035B_IncomingStocks AS R4035B_IncomingStocks
		   |WHERE
		   |	R4035B_IncomingStocks.Recorder = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R1010T_PurchaseOrders());
	QueryArray.Add(R1011B_PurchaseOrdersReceipt());
	QueryArray.Add(R1012B_PurchaseOrdersInvoiceClosing());
	QueryArray.Add(R1014T_CanceledPurchaseOrders());
	QueryArray.Add(R1022B_VendorsPaymentPlanning());
	QueryArray.Add(R2013T_SalesOrdersProcurement());
	QueryArray.Add(R3025B_PurchaseOrdersToBePaid());
	QueryArray.Add(R4016B_InternalSupplyRequestOrdering());
	QueryArray.Add(R4033B_GoodsReceiptSchedule());
	QueryArray.Add(R4035B_IncomingStocks());
	QueryArray.Add(T3010S_RowIDInfo());
	Return QueryArray;
EndFunction

Function R1010T_PurchaseOrders()
	Return "SELECT *
		   |INTO R1010T_PurchaseOrders
		   |FROM
		   |	ItemList AS QueryTable
		   |WHERE NOT QueryTable.isCanceled";

EndFunction

Function R1011B_PurchaseOrdersReceipt()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R1011B_PurchaseOrdersReceipt
		   |FROM
		   |	ItemList AS QueryTable
		   |WHERE NOT QueryTable.isCanceled
		   |	AND NOT QueryTable.IsService";

EndFunction

Function R1012B_PurchaseOrdersInvoiceClosing()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R1012B_PurchaseOrdersInvoiceClosing
		   |FROM
		   |	ItemList AS QueryTable
		   |WHERE NOT QueryTable.isCanceled";

EndFunction

Function R1014T_CanceledPurchaseOrders()
	Return "SELECT *
		   |INTO R1014T_CanceledPurchaseOrders
		   |FROM
		   |	ItemList AS QueryTable
		   |WHERE QueryTable.isCanceled";

EndFunction

Function R2013T_SalesOrdersProcurement()
	Return "SELECT
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.SalesOrder AS Order,
		   |	ItemList.ItemKey,
		   |	ItemList.RowKey,
		   |	ItemList.Quantity AS ReOrderedQuantity,
		   |	ItemList.NetAmount AS ReOrderedNetAmount,
		   |	ItemList.Amount AS ReOrderedTotalAmount
		   |INTO R2013T_SalesOrdersProcurement
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.isCanceled
		   |	AND NOT ItemList.IsService
		   |	AND NOT ItemList.SalesOrder = Value(Document.SalesOrder.EmptyRef)";
EndFunction

Function R4016B_InternalSupplyRequestOrdering()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	QueryTable.Quantity AS Quantity,
		   |	QueryTable.InternalSupplyRequest AS InternalSupplyRequest,
		   |	*
		   |INTO R4016B_InternalSupplyRequestOrdering
		   |FROM
		   |	ItemList AS QueryTable
		   |WHERE
		   |	NOT QueryTable.isCanceled
		   |	AND NOT QueryTable.IsService
		   |	AND NOT QueryTable.InternalSupplyRequest = Value(Document.InternalSupplyRequest.EmptyRef)";

EndFunction

Function R4033B_GoodsReceiptSchedule()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	CASE WHEN QueryTable.DeliveryDate = DATETIME(1, 1, 1) THEN
		   |		QueryTable.Period
		   |	ELSE
		   |		QueryTable.DeliveryDate
		   |	END AS Period,
		   |	QueryTable.Order AS Basis,
		   |*
		   |
		   |INTO R4033B_GoodsReceiptSchedule
		   |FROM
		   |	ItemList AS QueryTable
		   |WHERE NOT QueryTable.isCanceled 
		   |	AND NOT QueryTable.IsService 
		   |	AND QueryTable.UseItemsReceiptScheduling";

EndFunction

Function R4035B_IncomingStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	QueryTable.Period AS Period,
		   |	QueryTable.Store AS Store,
		   |	QueryTable.ItemKey AS ItemKey,
		   |	QueryTable.Order AS Order,
		   |	QueryTable.Quantity AS Quantity
		   |INTO R4035B_IncomingStocks
		   |FROM
		   |	ItemList AS QueryTable
		   |WHERE
		   |	NOT QueryTable.UseSalesOrder
		   |	AND NOT QueryTable.IsService
		   |	AND NOT QueryTable.IsCanceled";
EndFunction

Function R1022B_VendorsPaymentPlanning()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	PurchaseOrderPaymentTerms.Ref.Date AS Period,
		   |	PurchaseOrderPaymentTerms.Ref.Company AS Company,
		   |	PurchaseOrderPaymentTerms.Ref.Branch AS Branch,
		   |	PurchaseOrderPaymentTerms.Ref AS Basis,
		   |	PurchaseOrderPaymentTerms.Ref.LegalName AS LegalName,
		   |	PurchaseOrderPaymentTerms.Ref.Partner AS Partner,
		   |	PurchaseOrderPaymentTerms.Ref.Agreement AS Agreement,
		   |	SUM(PurchaseOrderPaymentTerms.Amount) AS Amount
		   |INTO R1022B_VendorsPaymentPlanning
		   |FROM
		   |	Document.PurchaseOrder.PaymentTerms AS PurchaseOrderPaymentTerms
		   |WHERE
		   |	PurchaseOrderPaymentTerms.Ref = &Ref
		   |	AND PurchaseOrderPaymentTerms.CalculationType = VALUE(Enum.CalculationTypes.Prepaid)
		   |	AND &StatusInfoPosting
		   |GROUP BY
		   |	PurchaseOrderPaymentTerms.Ref.Date,
		   |	PurchaseOrderPaymentTerms.Ref.Company,
		   |	PurchaseOrderPaymentTerms.Ref.Branch,
		   |	PurchaseOrderPaymentTerms.Ref,
		   |	PurchaseOrderPaymentTerms.Ref.LegalName,
		   |	PurchaseOrderPaymentTerms.Ref.Partner,
		   |	PurchaseOrderPaymentTerms.Ref.Agreement";
EndFunction
Function T3010S_RowIDInfo()
	Return "SELECT
		   |	RowIDInfo.RowRef AS RowRef,
		   |	RowIDInfo.BasisKey AS BasisKey,
		   |	RowIDInfo.RowID AS RowID,
		   |	RowIDInfo.Basis AS Basis,
		   |	ItemList.Key AS Key,
		   |	ItemList.Price AS Price,
		   |	ItemList.Ref.Currency AS Currency,
		   |	ItemList.Unit AS Unit
		   |INTO T3010S_RowIDInfo
		   |FROM
		   |	Document.PurchaseOrder.ItemList AS ItemList
		   |		INNER JOIN Document.PurchaseOrder.RowIDInfo AS RowIDInfo
		   |		ON RowIDInfo.Ref = &Ref
		   |		AND ItemList.Ref = &Ref
		   |		AND RowIDInfo.Key = ItemList.Key
		   |		AND RowIDInfo.Ref = ItemList.Ref";
EndFunction

Function R3025B_PurchaseOrdersToBePaid()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	PaymentTerms.Ref.Date AS Period,
		   |	PaymentTerms.Ref.Company,
		   |	PaymentTerms.Ref.Branch,
		   |	PaymentTerms.Ref.Currency,
		   |	PaymentTerms.Ref.Partner,
		   |	PaymentTerms.Ref.LegalName,
		   |	PaymentTerms.Ref AS Order,
		   |	SUM(PaymentTerms.Amount) AS Amount
		   |INTO R3025B_PurchaseOrdersToBePaid
		   |FROM
		   |	Document.PurchaseOrder.PaymentTerms AS PaymentTerms
		   |WHERE
		   |	PaymentTerms.Ref = &Ref
		   |	AND (PaymentTerms.CalculationType = VALUE(Enum.CalculationTypes.Prepaid)
		   |	AND PaymentTerms.CanBePaid)
		   |	AND &StatusInfoPosting
		   |GROUP BY
		   |	PaymentTerms.Ref,
		   |	PaymentTerms.Ref.Branch,
		   |	PaymentTerms.Ref.Company,
		   |	PaymentTerms.Ref.Currency,
		   |	PaymentTerms.Ref.Date,
		   |	PaymentTerms.Ref.LegalName,
		   |	PaymentTerms.Ref.Partner,
		   |	VALUE(AccumulationRecordType.Receipt)";
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