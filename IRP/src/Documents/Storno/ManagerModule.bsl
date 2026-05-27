
#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
		
	AccoumulationRegisterData = New Structure();
	
	For Each RegisterMetadata In Ref.Basis.Metadata().RegisterRecords Do	
		If Metadata.AccumulationRegisters.Find(RegisterMetadata.Name) <> Undefined Then
			RecordSet = AccumulationRegisters[RegisterMetadata.Name].CreateRecordSet();
			RecordSet.Filter.Recorder.Set(Ref.Basis);
			RecordSet.Read();
		
			If RecordSet.Count() = 0 Then
				Continue;
			EndIf;
		
			RegisterData = CreateColumnsByRegister(RegisterMetadata);
			AccoumulationRegisterData.Insert(RegisterMetadata.Name, 
				New Structure("Table, QueryText", RegisterData.Table, 
					StrTemplate("select &Period as Period, * into %1 from &%1 as %1 where true", 
						RegisterMetadata.Name)));
			
			For Each Record In RecordSet Do
				NewRecord = RegisterData.Table.Add();
				FillPropertyValues(NewRecord, Record);
				If RegisterData.IsBalance Then
					NewRecord.RecordType = Record.RecordType;
				EndIf;
				For Each Res In RegisterData.Resources Do
					NewRecord[Res] = - Record[Res];
				EndDo;
			EndDo;
			
		EndIf;
	EndDo;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	ArrayOfQueryText = New Array();
	For Each RegisterData In AccoumulationRegisterData Do
		 ArrayOfQueryText.Add(RegisterData.Value.QueryText);
		 Query.SetParameter(RegisterData.Key, RegisterData.Value.Table);
	EndDo;
	Query.SetParameter("Period", Ref.Date);
	Query.Text = StrConcat(ArrayOfQueryText, " ; "); 
	Query.Execute();
	
	RowIDTables = New Structure();
	
	_TM1010B_RowIDMovements = Query.TempTablesManager.Tables.Find("TM1010B_RowIDMovements");
	If _TM1010B_RowIDMovements <> Undefined Then
		RowIDTables.Insert("TM1010B_RowIDMovements", _TM1010B_RowIDMovements.GetData().Unload());	
	EndIf;
		
	_TM1010T_RowIDMovements = Query.TempTablesManager.Tables.Find("TM1010T_RowIDMovements");
	If _TM1010T_RowIDMovements <> Undefined Then
		RowIDTables.Insert("TM1010T_RowIDMovements", _TM1010T_RowIDMovements.GetData().Unload());
	EndIf;
		
	_T1040T_RowIDSerialLotNumbers = Query.TempTablesManager.Tables.Find("T1040T_RowIDSerialLotNumbers");
	If _T1040T_RowIDSerialLotNumbers <> Undefined Then
		RowIDTables.Insert("T1040T_RowIDSerialLotNumbers", _T1040T_RowIDSerialLotNumbers.GetData().Unload());
	EndIf;
	
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "RowIDTables", RowIDTables);
		
	Return Tables;
EndFunction

Function CreateColumnsByRegister(RegisterMetadata)
	Result = New Structure();
	Result.Insert("Table", New ValueTable());
	Result.Insert("Dimensions", New Array());
	Result.Insert("Resources", New Array());
	Result.Insert("Attributes", New Array());
	Result.Insert("IsBalance", False);
	 
	For Each Dim In RegisterMetadata.Dimensions Do
		Result.Table.Columns.Add(Dim.Name, Dim.Type);
		Result.Dimensions.Add(Dim.Name);
	EndDo;	
			
	For Each Res In RegisterMetadata.Resources Do
		Result.Table.Columns.Add(Res.Name, Res.Type);
		Result.Resources.Add(Res.Name);
	EndDo;
	
	For Each Att In RegisterMetadata.Attributes Do
		Result.Table.Columns.Add(Att.Name, Att.Type);
		Result.Attributes.Add(Att.Name);
	EndDo;
	
	If RegisterMetadata.RegisterType = Metadata.ObjectProperties.AccumulationRegisterType.Balance  Then
		Result.IsBalance = True;
		Result.Table.Columns.Add("RecordType",  New TypeDescription("AccumulationRecordType"));			
	EndIf;
	Return Result;
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

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	If CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "UnitTest", False) Then
		Return;
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
	StrParams.Insert("Period", Ref.Date);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	Return QueryArray;
EndFunction

#EndRegion

#Region AccessObject

Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	AccessKeyMap.Insert("Company", Obj.Company);
	Return AccessKeyMap;
EndFunction

#EndRegion
