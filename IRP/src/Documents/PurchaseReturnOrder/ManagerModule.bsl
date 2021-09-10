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
	EndIf
	;

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
	Return;
EndProcedure

#EndRegion

#Region NewRegistersPosting

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure();
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure();
	StrParams.Insert("Ref", Ref);
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	StrParams.Insert("StatusInfoPosting", StatusInfo.Posting);
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
	QueryArray.Add(R1012B_PurchaseOrdersInvoiceClosing());
	Return QueryArray;
EndFunction

Function ItemList()
	Return "SELECT
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
		   |	PurchaseReturnOrderItemList.ProfitLossCenter AS ProfitLossCenter,
		   |	PurchaseReturnOrderItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
		   |	PurchaseReturnOrderItemList.Cancel AS IsCanceled,
		   |	PurchaseReturnOrderItemList.TotalAmount AS Amount,
		   |	PurchaseReturnOrderItemList.NetAmount,
		   |	PurchaseReturnOrderItemList.Ref.Currency AS Currency,
		   |	PurchaseReturnOrderItemList.PurchaseInvoice AS Invoice,
		   |	&StatusInfoPosting AS StatusInfoPosting,
		   |	PurchaseReturnOrderItemList.Ref.Branch AS Branch
		   |INTO ItemList
		   |FROM
		   |	Document.PurchaseReturnOrder.ItemList AS PurchaseReturnOrderItemList
		   |WHERE
		   |	PurchaseReturnOrderItemList.Ref = &Ref
		   |	AND &StatusInfoPosting";
EndFunction

Function R1010T_PurchaseOrders()
	Return "SELECT *
		   |INTO R1010T_PurchaseOrders
		   |FROM
		   |	ItemList AS QueryTable
		   |WHERE NOT QueryTable.isCanceled";

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

#EndRegion