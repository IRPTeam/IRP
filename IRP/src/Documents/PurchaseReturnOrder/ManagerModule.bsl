#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("OrderBalance"      , PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("PurchaseTurnovers" , PostingServer.CreateTable(AccReg.PurchaseTurnovers));
	
	ObjectStatusesServer.WriteStatusToRegister(Ref, Ref.Status);
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	Parameters.Insert("StatusInfo", StatusInfo);
	If Not StatusInfo.Posting Then
#Region NewRegistersPosting
		QueryArray = GetQueryTextsSecondaryTables();
		Parameters.Insert("QueryParameters", GetAdditionalQueryParamenters(Ref));
		PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion
		Return Tables;
	EndIf;
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	PurchaseReturnOrderItemList.Ref.Company AS Company,
		|	PurchaseReturnOrderItemList.Store AS Store,
		|	PurchaseReturnOrderItemList.Ref AS Order,
		|	PurchaseReturnOrderItemList.ItemKey.Item AS Item,
		|	PurchaseReturnOrderItemList.ItemKey AS ItemKey,
		|	SUM(PurchaseReturnOrderItemList.Quantity) AS Quantity,
		|	PurchaseReturnOrderItemList.Unit,
		|	PurchaseReturnOrderItemList.ItemKey.Item.Unit AS ItemUnit,
		|	PurchaseReturnOrderItemList.ItemKey.Unit AS ItemKeyUnit,
		|	0 AS BasisQuantity,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	&Period AS Period,
		|	PurchaseReturnOrderItemList.PurchaseInvoice AS PurchaseInvoice,
		|	ISNULL(PurchaseReturnOrderItemList.Ref.Currency, VALUE(Catalog.Currencies.EmptyRef)) AS Currency,
		|	SUM(PurchaseReturnOrderItemList.TotalAmount) AS TotalAmount,
		|	PurchaseReturnOrderItemList.Key AS RowKey,
		|	SUM(PurchaseReturnOrderItemList.NetAmount) AS NetAmount,
		|	CASE
		|		WHEN PurchaseReturnOrderItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service)
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsService
		|FROM
		|	Document.PurchaseReturnOrder.ItemList AS PurchaseReturnOrderItemList
		|WHERE
		|	PurchaseReturnOrderItemList.Ref = &Ref
		|GROUP BY
		|	PurchaseReturnOrderItemList.Ref.Company,
		|	PurchaseReturnOrderItemList.Store,
		|	PurchaseReturnOrderItemList.ItemKey,
		|	PurchaseReturnOrderItemList.Unit,
		|	PurchaseReturnOrderItemList.ItemKey.Item.Unit,
		|	PurchaseReturnOrderItemList.ItemKey.Unit,
		|	PurchaseReturnOrderItemList.ItemKey.Item,
		|	VALUE(Catalog.Units.EmptyRef),
		|	PurchaseReturnOrderItemList.Ref,
		|	PurchaseReturnOrderItemList.PurchaseInvoice,
		|	ISNULL(PurchaseReturnOrderItemList.Ref.Currency, VALUE(Catalog.Currencies.EmptyRef)),
		|	PurchaseReturnOrderItemList.Key,
		|	CASE
		|		WHEN PurchaseReturnOrderItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service)
		|			THEN TRUE
		|		ELSE FALSE
		|	END
		|HAVING
		|	SUM(PurchaseReturnOrderItemList.Quantity) <> 0";
	
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("Period", StatusInfo.Period);
	
	QueryResults = Query.Execute();
	
	QueryTable = QueryResults.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTable);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Store AS Store,
		|	QueryTable.Order AS Order,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BasisUnit AS Unit,
		|	QueryTable.Period AS Period,
		|	QueryTable.PurchaseInvoice,
		|	QueryTable.Currency AS Currency,
		|	QueryTable.TotalAmount AS Amount,
		|	QueryTable.RowKey AS RowKey,
		|	QueryTable.NetAmount AS NetAmount,
		|	QueryTable.IsService AS IsService
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|// 1. OrderBalance //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.Order,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.Order,
		|	tmp.ItemKey,
		|	tmp.Unit,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|
		|// 2. PurchaseTurnovers//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.PurchaseInvoice,
		|	tmp.Currency,
		|	tmp.ItemKey,
		|	-SUM(tmp.Quantity) AS Quantity,
		|	-SUM(Amount) AS Amount,
		|	-SUM(NetAmount) AS NetAmount,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.PurchaseInvoice,
		|	tmp.Currency,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.RowKey";
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResults = Query.ExecuteBatch();
	
	Tables.OrderBalance      = QueryResults[1].Unload();
	Tables.PurchaseTurnovers = QueryResults[2].Unload();
	
#Region NewRegistersPosting
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParamenters(Ref));
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
	
	// OrderBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.OrderBalance,
			Parameters.IsReposting));
	
	// PurchaseTurnuvers			   
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PurchaseTurnovers,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.PurchaseTurnovers,
			Parameters.IsReposting));
	
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
	StrParams.Insert("Ref", Ref);
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	StrParams.Insert("StatusInfoPosting", StatusInfo.Posting);
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
	QueryArray.Add(R1012B_PurchaseOrdersInvoiceClosing());
	Return QueryArray;	
EndFunction	

Function ItemList()
	Return
		"SELECT
		|	PurchaseReturnOrderItemList.Ref.Company AS Company,
		|	PurchaseReturnOrderItemList.Store AS Store,
		|	PurchaseReturnOrderItemList.Ref AS Order,
		|	PurchaseReturnOrderItemList.ItemKey.Item AS Item,
		|	PurchaseReturnOrderItemList.ItemKey AS ItemKey,
		|	PurchaseReturnOrderItemList.Quantity AS UnitQuantity,
		|	PurchaseReturnOrderItemList.QuantityInBaseUnit AS Quantity,
		|	PurchaseReturnOrderItemList.Unit,
		|	PurchaseReturnOrderItemList.Ref.Date AS Period,
		|	PurchaseReturnOrderItemList.Key AS RowKey,
		|	PurchaseReturnOrderItemList.BusinessUnit AS BusinessUnit,
		|	PurchaseReturnOrderItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
		|	PurchaseReturnOrderItemList.Cancel AS IsCanceled,
		|	PurchaseReturnOrderItemList.TotalAmount AS Amount,
		|	PurchaseReturnOrderItemList.NetAmount,
		|	PurchaseReturnOrderItemList.Ref.Currency AS Currency,
		|	PurchaseReturnOrderItemList.PurchaseInvoice AS Invoice,
		|	&StatusInfoPosting
		|INTO ItemList
		|FROM
		|	Document.PurchaseReturnOrder.ItemList AS PurchaseReturnOrderItemList
		|WHERE
		|	PurchaseReturnOrderItemList.Ref = &Ref
		|	AND &StatusInfoPosting";
EndFunction

Function R1010T_PurchaseOrders()
	Return
		"SELECT *
		|INTO R1010T_PurchaseOrders
		|FROM
		|	ItemList AS QueryTable
		|WHERE NOT QueryTable.isCanceled";

EndFunction

Function R1012B_PurchaseOrdersInvoiceClosing()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R1012B_PurchaseOrdersInvoiceClosing
		|FROM
		|	ItemList AS QueryTable
		|WHERE NOT QueryTable.isCanceled";

EndFunction

#EndRegion
