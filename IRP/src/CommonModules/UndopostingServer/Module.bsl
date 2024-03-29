// Undopost.
// 
// Parameters:
//  DocObject  - DocumentObjectDocumentName - Doc object
//  Cancel - Boolean - Cancel
//  AddInfo - Undefined - Add info
Procedure Undopost(DocObject, Cancel, AddInfo = Undefined) Export
	If Cancel Then
		Return;
	EndIf;
	
	If DocObject.ManualMovementsEdit Then
		TextMessage = R().Error_147;
		CommonFunctionsClientServer.ShowUsersMessage(TextMessage);
		Return;
	EndIf;
	
	For Each RecordSet In DocObject.RegisterRecords Do
		TableForLoad = New ValueTable();
		PostingServer.WriteAdvances(DocObject, RecordSet.Metadata(), TableForLoad);
		
		If RecordSet.Metadata() = Metadata.InformationRegisters.T6020S_BatchKeysInfo Then
			InformationRegisters.T6030S_BatchRelevance.BatchRelevance_SetBound(DocObject,
				CommonFunctionsServer.CreateTable(Metadata.InformationRegisters.T6020S_BatchKeysInfo));
		EndIf;
	EndDo;
	
	Parameters = New Structure();
	Parameters.Insert("Object", DocObject);
	Parameters.Insert("IsReposting", False);
	Parameters.Insert("PointInTime", DocObject.PointInTime());
	Parameters.Insert("TempTablesManager", New TempTablesManager());
	Parameters.Insert("DocumentDataTables", New Structure);
	Parameters.Insert("LockDataSources", New Map);
	Parameters.Insert("PostingDataTables", New Map);
	Parameters.Insert("Metadata", DocObject.Ref.Metadata());
	Parameters.Insert("PostingByRef", False);
		
	Module = Documents[DocObject.Ref.Metadata().Name]; // DocumentManager.SalesOrder

	Parameters.DocumentDataTables = Module.UndopostingGetDocumentDataTables(DocObject.Ref, Cancel, Parameters, AddInfo);
	If Cancel Then
		Return;
	EndIf;

	Parameters.LockDataSources = Module.UndopostingGetLockDataSource(DocObject.Ref, Cancel, Parameters, AddInfo);
	If Cancel Then
		Return;
	EndIf;
	
	// Save pointers to locks			
	DataLock = Undefined;
	If Parameters.LockDataSources <> Undefined Then
		DataLock = SetLock(Parameters.LockDataSources);
	EndIf;
	If TypeOf(AddInfo) = Type("Structure") Then
		AddInfo.Insert("DataLock", DataLock);
	EndIf;

	Module.UndopostingCheckBeforeWrite(DocObject.Ref, Cancel, Parameters, AddInfo);
	If Cancel Then
		Return;
	EndIf;

	For Each RecordSet In DocObject.RegisterRecords Do
		If RecordSet.Metadata() = Metadata.AccumulationRegisters.TM1010B_RowIDMovements Then
			Continue;
		EndIf;
		RecordSet.Clear();
		RecordSet.Write();
	EndDo;

	Module.UndopostingCheckAfterWrite(DocObject.Ref, Cancel, Parameters, AddInfo);
EndProcedure

Function SetLock(LockDataSources)
	DataLock = New DataLock();

	For Each Row In LockDataSources Do
		DataLockItem = DataLock.Add(Row.Key);

		DataLockItem.Mode = DataLockMode.Exclusive;
		DataLockItem.DataSource = Row.Value.Data;

		For Each Field In Row.Value.Fields Do
			DataLockItem.UseFromDataSource(Field.Key, Field.Value);
		EndDo;
	EndDo;
	If LockDataSources.Count() Then
		DataLock.Lock();
	EndIf;
	Return DataLock;
EndFunction