#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	AccReg = Metadata.AccumulationRegisters;
	Tables.Insert("OrderBalance"             , PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("SupplyRequestProcurement" , PostingServer.CreateTable(AccReg.SupplyRequestProcurement));
	
	Tables.Insert("OrderBalance_Exists", PostingServer.CreateTable(AccReg.OrderBalance));
	
	Tables.OrderBalance_Exists = 
	AccumulationRegisters.OrderBalance.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	InternalSupplyRequestItemList.Ref.Company AS Company,
		|	InternalSupplyRequestItemList.Ref.Store AS Store,
		|	InternalSupplyRequestItemList.ItemKey AS ItemKey,
		|	InternalSupplyRequestItemList.Ref.ProcurementDate AS ProcurementDate,
		|	InternalSupplyRequestItemList.Ref AS InternalSupplyRequest,
		|	InternalSupplyRequestItemList.Quantity AS Quantity,
		|	0 AS BasisQuantity,
		|	InternalSupplyRequestItemList.Unit,
		|	InternalSupplyRequestItemList.ItemKey.Item.Unit AS ItemUnit,
		|	InternalSupplyRequestItemList.ItemKey.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	InternalSupplyRequestItemList.ItemKey.Item AS Item,
		|	InternalSupplyRequestItemList.Ref.Date AS Period,
		|	InternalSupplyRequestItemList.Key AS RowKeyUUID
		|FROM
		|	Document.InternalSupplyRequest.ItemList AS InternalSupplyRequestItemList
		|WHERE
		|	InternalSupplyRequestItemList.Ref = &Ref";
	
	Query.SetParameter("Ref", Ref);	
	QueryResults = Query.Execute();
	QueryTable = QueryResults.Unload();
	
	PostingServer.UUIDToString(QueryTable);
	PostingServer.CalculateQuantityByUnit(QueryTable);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Store AS Store,
		|	QueryTable.ProcurementDate AS ProcurementDate,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.InternalSupplyRequest AS InternalSupplyRequest,
		|	QueryTable.InternalSupplyRequest AS Order,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BasisUnit AS Unit,
		|	QueryTable.Period AS Period,
		|   QueryTable.RowKey
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|//[1]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Quantity,
		|	tmp.Period,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|//[2]/////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Period,
		|	tmp.Company,
		|	tmp.ItemKey,
		|	tmp.Store,
		|	tmp.InternalSupplyRequest,
		|	CASE 
		|		WHEN tmp.ProcurementDate = DATETIME(1,1,1) THEN
		|		tmp.Period
		|	ELSE
		|		tmp.ProcurementDate
		|	END AS ProcurementDate,
		|	VALUE(Enum.ProcurementMovementTypes.Request) AS MovementType,
		|	tmp.Quantity AS Quantity
		|FROM 
		|	tmp AS tmp
		|";
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResults = Query.ExecuteBatch();
	
	Tables.OrderBalance             = QueryResults[1].Unload();
	Tables.SupplyRequestProcurement = QueryResults[2].Unload();
	
	Parameters.IsReposting = False;
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// OrderBalance
	OrderBalance = AccumulationRegisters.OrderBalance.GetLockFields(DocumentDataTables.OrderBalance);
	DataMapWithLockFields.Insert(OrderBalance.RegisterName, OrderBalance.LockInfo);
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// OrderBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.OrderBalance,
			True));
	
	// SupplyRequestProcurement
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.SupplyRequestProcurement,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.SupplyRequestProcurement,
			False));
	
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
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// OrderBalance
	OrderBalance = AccumulationRegisters.OrderBalance.GetLockFields(DocumentDataTables.OrderBalance_Exists);
	DataMapWithLockFields.Insert(OrderBalance.RegisterName, OrderBalance.LockInfo);
	
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
	Unposting = ?(Parameters.Property("Unposting"), Parameters.Unposting, False);
	LineNumberAndRowKeyFromItemList = PostingServer.GetLineNumberAndRowKeyFromItemList(Ref, "Document.InternalSupplyRequest.ItemList");
	
	If Not Cancel And Not AccumulationRegisters.OrderBalance.CheckBalance(Ref, 
	                                                                 LineNumberAndRowKeyFromItemList,
	                                                                 Parameters.DocumentDataTables.OrderBalance,
	                                                                 Parameters.DocumentDataTables.OrderBalance_Exists,
	                                                                 AccumulationRecordType.Receipt,
	                                                                 Unposting,
	                                                                 AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

#EndRegion
