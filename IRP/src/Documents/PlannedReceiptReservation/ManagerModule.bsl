#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	
	Return Tables;	
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref, True);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters, True);
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

#Region PostingInfo

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	Return QueryArray;	
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R4035B_IncomingStocks());
	QueryArray.Add(R4036B_IncomingStocksRequested());
	Return QueryArray;	
EndFunction	

Function ItemList()
	Return
		"SELECT
		|	PlannedReceiptReservationItemList.Ref.Date AS Period,
		|	PlannedReceiptReservationItemList.ItemKey,
		|	PlannedReceiptReservationItemList.QuantityInBaseUnit AS Quantity,
		|	PlannedReceiptReservationItemList.Ref.Store AS IncomingStore,
		|	PlannedReceiptReservationItemList.Store AS RequesterStore,
		|	PlannedReceiptReservationItemList.Ref.Requester AS Requester,
		|	PlannedReceiptReservationItemList.IncomingDocument
		|INTO ItemList
		|FROM
		|	Document.PlannedReceiptReservation.ItemList AS PlannedReceiptReservationItemList
		|WHERE
		|	PlannedReceiptReservationItemList.Ref = &Ref"
EndFunction

Function R4035B_IncomingStocks()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.IncomingStore AS Store,
		|	ItemList.ItemKey,
		|	ItemList.IncomingDocument AS Order,
		|	ItemList.Quantity
		|INTO R4035B_IncomingStocks
		|FROM
		|	ItemList AS ItemList";
EndFunction

Function R4036B_IncomingStocksRequested()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period,
		|	ItemList.RequesterStore AS IncomingStore,
		|	ItemList.RequesterStore,
		|	ItemList.ItemKey,
		|	ItemList.IncomingDocument AS Order,
		|	ItemList.Requester,
		|	ItemList.Quantity
		|INTO R4036B_IncomingStocksRequested
		|FROM 
		|	ItemList AS ItemList";
EndFunction

#EndRegion