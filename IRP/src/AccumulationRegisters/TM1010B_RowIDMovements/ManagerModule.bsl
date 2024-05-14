
Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.TM1010B_RowIDMovements");
	Result.Insert("LockInfo", New Structure("Data, Fields", Data, PostingServer.GetLockFieldsMap(GetLockFieldNames())));
	Return Result;
EndFunction

Function GetLockFieldNames() Export
	Return "RowID, Step, Basis, RowRef";
EndFunction

Function GetExistsRecords(Ref, RecordType = Undefined, AddInfo = Undefined) Export
	Return PostingServer.GetExistsRecordsFromAccRegister(Ref, "AccumulationRegister.TM1010B_RowIDMovements", RecordType, AddInfo);
EndFunction

Function CheckBalance(Ref, ItemList_InDocument, Records_InDocument, Records_Exists, RecordType, Unposting, AddInfo = Undefined) Export
	Query = New Query();
	Query.TempTablesManager = PostingServer.PrepareRecordsTables(GetLockFieldNames(), "RowID", ItemList_InDocument,
		Records_InDocument, Records_Exists, Unposting, AddInfo);
	
	Query.Text =
	"SELECT
	|	RegisterBalance.RowID,
	|	RegisterBalance.Step,
	|	RegisterBalance.Basis,
	|	RegisterBalance.RowRef,
	|	RegisterBalance.QuantityBalance AS QuantityBalance,
	|	ItemList.Quantity,
	|	-RegisterBalance.QuantityBalance AS LackOfBalance,
	|	ItemList.LineNumber AS LineNumber,
	|	&Unposting AS Unposting
	|FROM
	|	ItemList AS ItemList
	|		INNER JOIN AccumulationRegister.TM1010B_RowIDMovements.Balance(, (RowID, Step, Basis, RowRef) IN
	|			(SELECT
	|				ItemList.RowID,
	|				ItemList.Step,
	|				ItemList.Basis,
	|				ItemList.RowRef
	|			FROM
	|				ItemList AS ItemList)) AS RegisterBalance
	|		ON  RegisterBalance.RowID = ItemList.RowID
	|		AND RegisterBalance.Step = ItemList.Step
	|		AND RegisterBalance.Basis = ItemList.Basis
	|		AND RegisterBalance.RowRef = ItemList.RowRef
	|WHERE
	|	RegisterBalance.QuantityBalance < 0
	|ORDER BY
	|	LineNumber";
	Query.SetParameter("Unposting", Unposting);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();

	If Not QueryTable.Count() Then
		// is ok
		Return True;
	EndIf;
	
	Query = New Query();
	Query.Text =
	"SELECT
	|	QueryTable.RowID,
	|	QueryTable.Step,
	|	QueryTable.Basis,
	|	QueryTable.RowRef,
	|	QueryTable.QuantityBalance,
	|	QueryTable.Quantity,
	|	QueryTable.LackOfBalance,
	|	QueryTable.LineNumber,
	|	QueryTable.Unposting
	|INTO tmpQueryTable
	|from
	|	&QueryTable AS QueryTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList_InDocument.RowID,
	|	ItemList_InDocument.ItemKey
	|Into tmpItemList_InDocument
	|from
	|	&ItemList_InDocument AS ItemList_InDocument
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpItemList_InDocument.ItemKey.Item AS Item,
	|	tmpItemList_InDocument.ItemKey,
	|	tmpQueryTable.RowID,
	|	tmpQueryTable.Step,
	|	tmpQueryTable.Basis,
	|	tmpQueryTable.RowRef,
	|	tmpQueryTable.QuantityBalance,
	|	tmpQueryTable.Quantity,
	|	tmpQueryTable.LackOfBalance,
	|	tmpQueryTable.LineNumber,
	|	tmpQueryTable.Unposting
	|FROM
	|	tmpQueryTable AS tmpQueryTable
	|		LEFT JOIN tmpItemList_InDocument AS tmpItemList_InDocument
	|		ON tmpQueryTable.RowID = tmpItemList_InDocument.RowID";
	
	Query.SetParameter("QueryTable", QueryTable);
	Query.SetParameter("ItemList_InDocument", ItemList_InDocument);
	
	ErrorParameters = New Structure();
	ErrorParameters.Insert("GroupColumns", "Item, ItemKey, RowID, Step, Basis, RowRef, LackOfBalance");
	ErrorParameters.Insert("SumColumns", "Quantity");
	ErrorParameters.Insert("FilterColumns", "Item, ItemKey, RowID, Step, Basis, RowRef, LackOfBalance");
	ErrorParameters.Insert("Operation", "RowID movements");
	ErrorParameters.Insert("RecordType", RecordType);
	PostingServer.ShowPostingErrorMessage(Query.Execute().Unload(), ErrorParameters, AddInfo);
	
	// is error
	Return False;
EndFunction

#Region AccessObject

// Get access key.
// 	See Role.TemplateAccumulationRegisters - Parameters orders has to be the same
//  
// Returns:
//  Structure
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	Return AccessKeyStructure;
EndFunction

#EndRegion