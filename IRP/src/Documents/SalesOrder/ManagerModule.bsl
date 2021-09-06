#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	
	ObjectStatusesServer.WriteStatusToRegister(Ref, Ref.Status);
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	Parameters.Insert("StatusInfo", StatusInfo);
	If Not StatusInfo.Posting Then
#Region NewRegistersPosting
		QueryArray = GetQueryTextsSecondaryTables();
		Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
		PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion
		Return Tables;
	EndIf;
		
	Parameters.IsReposting = False;

#Region NewRegistersPosting
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion	
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
		
#Region NewRegistersPosting
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
#EndRegion		
			
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
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
#Region NewRegistersPosting
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region CheckAfterWrite

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	If StatusInfo.Posting Then
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "BalancePeriod", 
			New Boundary(New PointInTime(StatusInfo.Period, Ref), BoundaryType.Including));
	EndIf;

	Parameters.Insert("RecordType", AccumulationRecordType.Expense);
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.SalesOrder.ItemList", AddInfo);
		
EndProcedure

#EndRegion

#Region NewRegistersPosting

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure();
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	StrParams.Insert("StatusInfoPosting", StatusInfo.Posting);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	Return QueryArray;	
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R2010T_SalesOrders());
	QueryArray.Add(R2011B_SalesOrdersShipment());
	QueryArray.Add(R2012B_SalesOrdersInvoiceClosing());
	QueryArray.Add(R2013T_SalesOrdersProcurement());
	QueryArray.Add(R2014T_CanceledSalesOrders());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4012B_StockReservation());
	QueryArray.Add(R4034B_GoodsShipmentSchedule());
	QueryArray.Add(R2022B_CustomersPaymentPlanning());
	Return QueryArray;	
EndFunction	

Function ItemList()
	Return
	"SELECT
	|	SalesOrderItemList.Ref.Company AS Company,
	|	SalesOrderItemList.Ref.ShipmentConfirmationsBeforeSalesInvoice AS ShipmentConfirmationsBeforeSalesInvoice,
	|	SalesOrderItemList.Store AS Store,
	|	SalesOrderItemList.Store.UseShipmentConfirmation AS UseShipmentConfirmation,
	|	SalesOrderItemList.ItemKey AS ItemKey,
	|	SalesOrderItemList.Ref AS Order,
	|	SalesOrderItemList.Quantity AS UnitQuantity,
	|	SalesOrderItemList.QuantityInBaseUnit AS Quantity,
	|	SalesOrderItemList.Unit,
	|	SalesOrderItemList.ItemKey.Item AS Item,
	|	SalesOrderItemList.Ref.Date AS Period,
	|	SalesOrderItemList.Key AS RowKey,
	|	SalesOrderItemList.DeliveryDate AS DeliveryDate,
	|	SalesOrderItemList.ProcurementMethod,
	|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Stock) AS IsProcurementMethod_Stock,
	|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Purchase) AS IsProcurementMethod_Purchase,
	|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.NoReserve) AS IsProcurementMethod_NonReserve,
	|	SalesOrderItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
	|	SalesOrderItemList.TotalAmount AS Amount,
	|	SalesOrderItemList.Ref.Currency AS Currency,
	|	SalesOrderItemList.Cancel AS IsCanceled,
	|	SalesOrderItemList.CancelReason,
	|	SalesOrderItemList.NetAmount,
	|	SalesOrderItemList.Ref.UseItemsShipmentScheduling AS UseItemsShipmentScheduling,
	|	SalesOrderItemList.OffersAmount,
	|	&StatusInfoPosting AS StatusInfoPosting,
	|	SalesOrderItemList.Ref.Branch AS Branch,
	|	CASE
	|		WHEN SalesOrderItemList.ReservationDate = DATETIME(1, 1, 1)
	|			THEN SalesOrderItemList.Ref.Date
	|		ELSE SalesOrderItemList.ReservationDate
	|	END AS ReservationDate
	|INTO ItemList
	|FROM
	|	Document.SalesOrder.ItemList AS SalesOrderItemList
	|WHERE
	|	SalesOrderItemList.Ref = &Ref
	|	AND &StatusInfoPosting";
EndFunction

Function R2010T_SalesOrders()
	Return
		"SELECT
		|	*
		|INTO R2010T_SalesOrders
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.isCanceled";
EndFunction

Function R2011B_SalesOrdersShipment()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R2011B_SalesOrdersShipment
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.isCanceled
		|	AND NOT ItemList.IsService";
EndFunction

Function R2012B_SalesOrdersInvoiceClosing()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R2012B_SalesOrdersInvoiceClosing
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.isCanceled";
EndFunction

Function R2013T_SalesOrdersProcurement()
	Return
		"SELECT
		|	ItemList.Quantity AS OrderedQuantity,
		|	*
		|INTO R2013T_SalesOrdersProcurement
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.isCanceled
		|	AND NOT ItemList.IsService
		|	AND ItemList.IsProcurementMethod_Purchase";
EndFunction

Function R2014T_CanceledSalesOrders()
	Return
		"SELECT
		|	*
		|INTO R2014T_CanceledSalesOrders
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.isCanceled";
EndFunction

#Region Stock

Function R4011B_FreeStocks()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	*
		|INTO R4011B_FreeStocks
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.isCanceled
		|	AND NOT ItemList.IsService
		|	AND ItemList.IsProcurementMethod_Stock";
EndFunction

Function R4012B_StockReservation()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.ReservationDate AS Period,
		|	*
		|INTO R4012B_StockReservation
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.isCanceled
		|	AND NOT ItemList.IsService
		|	AND ItemList.IsProcurementMethod_Stock";
EndFunction

#EndRegion

Function R4034B_GoodsShipmentSchedule()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.DeliveryDate AS Period,
		|	ItemList.Order AS Basis,
		|	*
		|INTO R4034B_GoodsShipmentSchedule
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.isCanceled
		|	AND NOT ItemList.IsService
		|	AND NOT ItemList.DeliveryDate = DATETIME(1, 1, 1)
		|	AND ItemList.UseItemsShipmentScheduling";
EndFunction

Function R2022B_CustomersPaymentPlanning()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	SalesOrderPaymentTerms.Ref.Date AS Period,
		|	SalesOrderPaymentTerms.Ref.Company AS Company,
		|	SalesOrderPaymentTerms.Ref.Branch AS Branch,
		|	SalesOrderPaymentTerms.Ref AS Basis,
		|	SalesOrderPaymentTerms.Ref.LegalName AS LegalName,
		|	SalesOrderPaymentTerms.Ref.Partner AS Partner,
		|	SalesOrderPaymentTerms.Ref.Agreement AS Agreement,
		|	SUM(SalesOrderPaymentTerms.Amount) AS Amount
		|INTO R2022B_CustomersPaymentPlanning
		|FROM
		|	Document.SalesOrder.PaymentTerms AS SalesOrderPaymentTerms
		|WHERE
		|	SalesOrderPaymentTerms.Ref = &Ref
		|	AND SalesOrderPaymentTerms.CalculationType = VALUE(Enum.CalculationTypes.Prepaid)
		|	AND &StatusInfoPosting
		|GROUP BY
		|	SalesOrderPaymentTerms.Ref.Date,
		|	SalesOrderPaymentTerms.Ref.Company,
		|	SalesOrderPaymentTerms.Ref.Branch,
		|	SalesOrderPaymentTerms.Ref.Branch,
		|	SalesOrderPaymentTerms.Ref,
		|	SalesOrderPaymentTerms.Ref.LegalName,
		|	SalesOrderPaymentTerms.Ref.Partner,
		|	SalesOrderPaymentTerms.Ref.Agreement,
		|	VALUE(AccumulationRecordType.Receipt)";
EndFunction

#EndRegion
