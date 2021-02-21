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
	Str = New Structure;
	Str.Insert("QueryParamenters", GetAdditionalQueryParamenters(Ref));
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
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R1010T_PurchaseOrders());
	QueryArray.Add(R1011B_PurchaseOrdersReceipt());
	QueryArray.Add(R1012B_PurchaseOrdersInvoiceClosing());
	QueryArray.Add(R1014T_CanceledPurchaseOrders());
	Return QueryArray;	
EndFunction	

Function ItemList()
	Return
		"SELECT
		|	PurchaseOrderItems.Ref.Company AS Company,
		|	PurchaseOrderItems.Store AS Store,
		|	PurchaseOrderItems.Store.UseGoodsReceipt AS UseGoodsReceipt,
		|	PurchaseOrderItems.Ref.GoodsReceiptBeforePurchaseInvoice AS GoodsReceiptBeforePurchaseInvoice,
		|	PurchaseOrderItems.Ref AS Order,
		|	PurchaseOrderItems.PurchaseBasis AS PurchaseBasis,
		|	PurchaseOrderItems.ItemKey.Item AS Item,
		|	PurchaseOrderItems.ItemKey AS ItemKey,
		|	PurchaseOrderItems.Quantity AS UnitQuantity,
		|	PurchaseOrderItems.QuantityInBaseUnit AS Quantity,
		|	PurchaseOrderItems.Unit,
		|	PurchaseOrderItems.Ref.Date AS Period,
		|	PurchaseOrderItems.Key AS RowKey,
		|	PurchaseOrderItems.BusinessUnit AS BusinessUnit,
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
		|	PurchaseOrderItems.OffersAmount
		|INTO ItemList
		|FROM
		|	Document.PurchaseOrder.ItemList AS PurchaseOrderItems
		|WHERE
		|	PurchaseOrderItems.Ref = &Ref";
EndFunction

Function R1010T_PurchaseOrders()
	Return
		"SELECT 
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
	Return
		"SELECT
		|	&Period AS Period,
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	-Balance.QuantityBalance AS Quantity,
		|	*
		|INTO R1011B_PurchaseOrdersReceipt
		|FROM
		|	AccumulationRegister.R1011B_PurchaseOrdersReceipt.Balance(&BalancePeriod, Order = &PurchaseOrder) AS Balance";


EndFunction

Function R1012B_PurchaseOrdersInvoiceClosing()
	Return
		"SELECT
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
	Return
		"SELECT *
		|INTO R1014T_CanceledPurchaseOrders
		|FROM
		|	ItemList AS QueryTable
		|WHERE QueryTable.isCanceled";

EndFunction

#EndRegion
