
#Region API

// Post.
// 
// Parameters:
//  DocObject - DocumentObjectDocumentName, DocumentRefDocumentName - Doc object
//  Cancel - Boolean - Cancel
//  PostingMode - DocumentPostingMode - Posting mode
//  AddInfo - Undefined - Add info
Procedure Post(DocObject, Cancel, PostingMode, AddInfo = Undefined) Export

	If Cancel Then
		Return;
	EndIf;
	
	Parameters = GetPostingParameters(DocObject, PostingMode, AddInfo);
	
	If Parameters.Cancel Then
		Cancel = True;
		Return;
	EndIf;
	
	// Multi currency integration
	CurrencyTable = Undefined;
	If Parameters.DocumentDataTables.Property("CurrencyTable") Then
		CurrencyTable = Parameters.DocumentDataTables.CurrencyTable;
	EndIf;
		
	CurrenciesServer.PreparePostingDataTables(Parameters, CurrencyTable, AddInfo);

	RegisteredRecords = RegisterRecords(Parameters);
	If Parameters.Cancel Then
		For Each Message In Parameters.Messages Do
			CommonFunctionsClientServer.ShowUsersMessage(Message);
		EndDo;
		Return;
	EndIf;	
	
	RegisteredRecordsArray = New Array;
	For Each Record In RegisteredRecords Do
		If Record.Value.WriteInTransaction Then
			// write when transaction will be commited or rollback
			If Metadata.AccumulationRegisters.Contains(Record.Key) Then
				Record.Value.RecordSet.LockForUpdate = True;
			EndIf;
			Record.Value.RecordSet.Write();
		Else // write only when transaction will be commited	
			Record.Value.RecordSet.Write = True;
		EndIf;
		
		RegisteredRecordsArray.Add(Record.Value.RecordSet);
	EndDo;
	Parameters.Insert("RegisteredRecords", RegisteredRecordsArray);

	Parameters.Module.PostingCheckAfterWrite(DocObject.Ref, Cancel, PostingMode, Parameters, AddInfo);
EndProcedure

// Get posting parameters.
// 
// Parameters:
//  DocObject - DocumentRefDocumentName - Doc object
//  PostingMode - DocumentPostingMode - Posting mode
//  AddInfo - Undefined, Structure - Add info
// 
// Returns:
//  Structure - Get posting parameters:
// * Cancel - Boolean - 
// * Object - DocumentRefDocumentName - 
// * PostingByRef - Boolean - 
// * IsReposting - Boolean - 
// * PointInTime - PointInTime - 
// * TempTablesManager - TempTablesManager - 
// * Metadata - MetadataObjectDocument - 
// * Module - DocumentManagerDocumentName, DocumentManager.SalesOrder - 
// * DocumentDataTables - Structure - 
// * DocumentDataTables - Map -
// * LockDataSources - Map -
// * PostingDataTables - Array Of KeyAndValue:
// ** Key - MetadataObjectDocument - Meta doc
// ** Value - See PostingTableSettings
// * ManualMovementsEdit - Boolean -  
// * Messages -  Array of String - User message
Function GetPostingParameters(DocObject, PostingMode, AddInfo = Undefined)
	Cancel = False;
	
	Parameters = New Structure();
	Parameters.Insert("Cancel", Cancel);
	Parameters.Insert("Object", DocObject);
	Parameters.Insert("PostingByRef", DocObject.Ref = DocObject);
	Parameters.Insert("IsReposting", False);
	Parameters.Insert("PointInTime", DocObject.PointInTime());
	Parameters.Insert("TempTablesManager", New TempTablesManager());
	Parameters.Insert("Metadata", DocObject.Ref.Metadata());
	Parameters.Insert("DocumentDataTables", New Structure);
	Parameters.Insert("LockDataSources", New Map);
	Parameters.Insert("PostingDataTables", New Map);
	Parameters.Insert("ManualMovementsEdit", DocObject.ManualMovementsEdit);
	Parameters.Insert("Messages", New Array);
	
	Module = Documents[Parameters.Metadata.Name]; // DocumentManager.SalesOrder, DocumentManagerDocumentName
	Parameters.Insert("Module", Module);
	
	Parameters.DocumentDataTables = Module.PostingGetDocumentDataTables(DocObject.Ref, Cancel, PostingMode, Parameters, AddInfo);
	
	If Cancel Then
		Parameters.Cancel = True;
		Return Parameters;
	EndIf;

	Parameters.LockDataSources = Module.PostingGetLockDataSource(DocObject.Ref, Cancel, PostingMode, Parameters, AddInfo);
	If Cancel Then
		Parameters.Cancel = True;
		Return Parameters;
	EndIf;
	
	// Save pointers to locks
	DataLock = Undefined;
	If Parameters.LockDataSources <> Undefined Then
		DataLock = SetLock(Parameters.LockDataSources);
	EndIf;
	If TypeOf(AddInfo) = Type("Structure") Then
		AddInfo.Insert("DataLock", DataLock);
	EndIf;

	Module.PostingCheckBeforeWrite(DocObject.Ref, Cancel, PostingMode, Parameters, AddInfo);
	If Cancel Then
		Parameters.Cancel = True;
		Return Parameters;
	EndIf;

	Parameters.PostingDataTables = Module.PostingGetPostingDataTables(DocObject.Ref, Cancel, PostingMode, Parameters, AddInfo);
	Return Parameters;
EndFunction

// Set lock.
// @skip-check property-return-type, dynamic-access-method-not-found, invocation-parameter-type-intersect, statement-type-change, variable-value-type
// 
// Parameters:
//  LockDataSources - Map - Lock data sources:
//  * Key - Undefined -
//  * Value - Structure:
//  ** Fields - Array Of String -
// 
// Returns:
//  DataLock - Set lock
Function SetLock(LockDataSources)
	DataLock = New DataLock();

	For Each Row In LockDataSources Do
		If Not Row.Value.Fields.Count() Then
			Continue;
		EndIf;
		DataLockItem = DataLock.Add(Row.Key);

		DataLockItem.Mode = DataLockMode.Exclusive;
		DataLockItem.DataSource = Row.Value.Data;

		For Each Field In Row.Value.Fields Do
			DataLockItem.UseFromDataSource(Field.Key, Field.Value);
		EndDo;
	EndDo;
	If LockDataSources.Count() Then
		//@skip-check lock-out-of-try
		DataLock.Lock();
	EndIf;
	Return DataLock;
EndFunction

// Register records.
// 
// Parameters:
//  Parameters - See GetPostingParameters
// 
// Returns:
//  Map - Register records
Function RegisterRecords(Parameters)
	
	isManualRecordsHasDifference = False;
	
	RegisteredRecords = New Map();
	For Each Row In Parameters.PostingDataTables Do
		RecordSet = Row.Value.RecordSet_Document;
		TableForLoad = Row.Value.PrepareTable.Copy();
			
		// Set record type
		If Row.Value.Property("RecordType") Then
			If TableForLoad.Columns.Find("RecordType") = Undefined Then
				TableForLoad.Columns.Add("RecordType");
			EndIf;
			TableForLoad.FillValues(Row.Value.RecordType, "RecordType");
		EndIf;
			
		// Set Active
		If TableForLoad.Columns.Find("Active") = Undefined Then
			TableForLoad.Columns.Add("Active");
			TableForLoad.FillValues(True, "Active");
		EndIf;
		
		If Row.Value.Metadata = Metadata.AccumulationRegisters.R6020B_BatchBalance 
			Or Row.Value.Metadata = AccumulationRegisters.R6060T_CostOfGoodsSold Then
				Continue; //Never rewrite
		EndIf;
		
		WriteAdvances(Parameters.Object, Row.Value.Metadata, TableForLoad);
		// MD5
		If RecordSetIsEqual(RecordSet, TableForLoad) Then
			Continue;
		Else
			If Parameters.ManualMovementsEdit Then
				Parameters.Cancel = True;
				isManualRecordsHasDifference = True;
			EndIf;		
		EndIf;
			
		//If Not Parameters.PostingByRef Then
			// WriteAdvances(Parameters.Object, Row.Value.Metadata, TableForLoad);
			
			UpdateCosts(Parameters.Object, Row.Value.Metadata, TableForLoad, RegisteredRecords);
		//EndIf;
		// Set write
		WriteInTransaction = False;
		If Row.Value.Property("WriteInTransaction") And Row.Value.WriteInTransaction Then
			WriteInTransaction = True;
		EndIf;
		Data = New Structure;
		Data.Insert("RecordSet", RecordSet);
		Data.Insert("WriteInTransaction", WriteInTransaction);
		Data.Insert("Metadata", RecordSet.Metadata());
		RegisteredRecords.Insert(RecordSet.Metadata(), Data);
	EndDo;
	If Parameters.ManualMovementsEdit Then
		If isManualRecordsHasDifference Then
			Parameters.Messages.Add(R().Error_144);
		Else
			Parameters.Messages.Add(R().InfoMessage_036);
		EndIf;
	EndIf;
				
	Return RegisteredRecords;
EndFunction

// Get document movements by register name.
// 
// Parameters:
//  DocRef - DocumentRef - Doc ref
//  RegisterName - String - Register name
// 
// Returns:
//  ValueTable - ValueTable
Function GetDocumentMovementsByRegisterName(DocRef, RegisterName) Export
	Query = New Query("SELECT * FROM " + RegisterName + " WHERE Recorder = &Ref");
	Query.SetParameter("Ref", DocRef);
	
	Return Query.Execute().Unload();
	
EndFunction	

Function RecordSetIsEqual(RecordSet, TableForLoad)
	RecordSet.Read();
	TableOldRecords = RecordSet.Unload();

	RecordSet.Load(TableForLoad);
	
	Result = CommonFunctionsServer.TablesIsEqual(RecordSet.Unload(), TableOldRecords, "Recorder,LineNumber,PointInTime,UniqueID");
	
	Return Result;
EndFunction

#EndRegion

Procedure WriteAdvances(DocObject, RecordMeta, TableForLoad) Export
	If RecordMeta = Metadata.AccumulationRegisters.R1020B_AdvancesToVendors Then
		AdvancesRelevanceServer.SetBound_Advances(DocObject, TableForLoad, Metadata.AccumulationRegisters.R1020B_AdvancesToVendors);
	ElsIf RecordMeta = Metadata.AccumulationRegisters.R2020B_AdvancesFromCustomers Then
		AdvancesRelevanceServer.SetBound_Advances(DocObject, TableForLoad, Metadata.AccumulationRegisters.R2020B_AdvancesFromCustomers);
	ElsIf RecordMeta = Metadata.AccumulationRegisters.R1021B_VendorsTransactions Then
		AdvancesRelevanceServer.SetBound_Transactions(DocObject, TableForLoad, Metadata.AccumulationRegisters.R1021B_VendorsTransactions);
	ElsIf RecordMeta = Metadata.AccumulationRegisters.R2021B_CustomersTransactions Then
		AdvancesRelevanceServer.SetBound_Transactions(DocObject, TableForLoad, Metadata.AccumulationRegisters.R2021B_CustomersTransactions);
	ElsIf RecordMeta = Metadata.AccumulationRegisters.R5012B_VendorsAging Then
		AdvancesRelevanceServer.SetBound_Aging(DocObject, TableForLoad, Metadata.AccumulationRegisters.R5012B_VendorsAging);
	ElsIf RecordMeta = Metadata.AccumulationRegisters.R5011B_CustomersAging Then
		AdvancesRelevanceServer.SetBound_Aging(DocObject, TableForLoad, Metadata.AccumulationRegisters.R5011B_CustomersAging);
	ElsIf RecordMeta = Metadata.AccumulationRegisters.R5020B_PartnersBalance Then
		For Each Row In TableForLoad Do
			If ValueIsFilled(Row.AdvancesClosing) Then
				Continue;
			EndIf;
			Row.Amount = 
			Row.CustomerTransaction
			+ Row.CustomerAdvance
			+ Row.VendorTransaction
			+ Row.VendorAdvance
			+ Row.OtherTransaction;
		EndDo;	
	EndIf;
EndProcedure

Procedure UpdateCosts(DocObject, RecordMeta, TableForLoad, RegisteredRecords)
	If RecordMeta = Metadata.InformationRegisters.T6020S_BatchKeysInfo Then
		
		R6020B_BatchBalance_RecordSet = AccumulationRegisters.R6020B_BatchBalance.CreateRecordSet();
		R6020B_BatchBalance_RecordSet.Filter.Recorder.Set(DocObject.Ref);
		R6020B_BatchBalance = AccumulationRegisters.R6020B_BatchBalance.BatchBalance_CollectRecords(DocObject);
		R6020B_BatchBalance_RecordSet.Load(R6020B_BatchBalance);
				
		Data = New Structure;
		Data.Insert("RecordSet", R6020B_BatchBalance_RecordSet);
		Data.Insert("WriteInTransaction", True);
		Data.Insert("Metadata", R6020B_BatchBalance_RecordSet.Metadata());
		RegisteredRecords.Insert(R6020B_BatchBalance_RecordSet.Metadata(), Data);
		
		R6060T_CostOfGoodsSold_RecordSet = AccumulationRegisters.R6060T_CostOfGoodsSold.CreateRecordSet();
		R6060T_CostOfGoodsSold_RecordSet.Filter.Recorder.Set(DocObject.Ref);
		R6060T_CostOfGoodsSold = AccumulationRegisters.R6060T_CostOfGoodsSold.CostOfGoodsSold_CollectRecords(DocObject);
		R6060T_CostOfGoodsSold_RecordSet.Load(R6060T_CostOfGoodsSold);
		
		Data = New Structure;
		Data.Insert("RecordSet", R6060T_CostOfGoodsSold_RecordSet);
		Data.Insert("WriteInTransaction", True);
		Data.Insert("Metadata", R6060T_CostOfGoodsSold_RecordSet.Metadata());
		RegisteredRecords.Insert(R6060T_CostOfGoodsSold_RecordSet.Metadata(), Data);
		
		TableForLoadEmpty = CommonFunctionsServer.CreateTable(Metadata.InformationRegisters.T6020S_BatchKeysInfo);
		For Each Row In TableForLoad Do
			FillPropertyValues(TableForLoadEmpty.Add(), Row);
		EndDo;
		InformationRegisters.T6030S_BatchRelevance.BatchRelevance_SetBound(DocObject, TableForLoadEmpty);
	EndIf;
EndProcedure

Procedure CalculateQuantityByUnit(DataTable) Export
	// Columns by default if Not set other:
	// ItemKey
	// ItemKeyUnit
	// Item
	// ItemUnit
	// Unit
	// Quantity
	// BasisQuantity
	// BasisUnit

	For Each Row In DataTable Do
		If ValueIsFilled(Row.ItemKey) And ValueIsFilled(Row.ItemKeyUnit) Then
			UnitFactor = Catalogs.Units.GetUnitFactor(Row.Unit, Row.ItemKeyUnit);
			Row.BasisQuantity = Row.Quantity * UnitFactor;
			If DataTable.Columns.Find("BasisUnit") <> Undefined Then
				Row.BasisUnit = Row.ItemKeyUnit;
			EndIf;
			Continue;
		EndIf;

		If ValueIsFilled(Row.Item) And ValueIsFilled(Row.ItemUnit) Then
			UnitFactor = Catalogs.Units.GetUnitFactor(Row.Unit, Row.ItemUnit);
			Row.BasisQuantity = Row.Quantity * UnitFactor;
			If DataTable.Columns.Find("BasisUnit") <> Undefined Then
				Row.BasisUnit = Row.ItemUnit;
			EndIf;
			Continue;
		EndIf;

		UnitFactor = Catalogs.Units.GetUnitFactor(Row.Unit);
		Row.BasisQuantity = Row.Quantity * UnitFactor;
		If DataTable.Columns.Find("BasisUnit") <> Undefined Then
			Row.BasisUnit = Row.Unit;
		EndIf;
	EndDo;
EndProcedure

Procedure ShowPostingErrorMessage(QueryTable, Parameters, AddInfo = Undefined) Export
	If QueryTable.Columns.Find("Unposting") = Undefined Then
		QueryTable.Columns.Add("Unposting");
		QueryTable.FillValues(False, "Unposting");
	EndIf;

	TableDataPath = "Object.ItemList";
	If Parameters.Property("TableDataPath") Then
		TableDataPath = Parameters.TableDataPath;
	EndIf;

	ErrorQuantityField = Undefined;
	If Parameters.Property("ErrorQuantityField") Then
		ErrorQuantityField = Parameters.ErrorQuantityField;
	EndIf;

	QueryTableCopy = QueryTable.Copy();
	QueryTableCopy.GroupBy(Parameters.GroupColumns + ", Unposting", Parameters.SumColumns);
	
	ArrayOfPostingErrorMessages = New Array();
	QuantityColumnName = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "QuantityColumnName", "Quantity");
	For Each Row In QueryTableCopy Do
		SerialLotNumberIsPresent = CommonFunctionsClientServer.ObjectHasProperty(Row, "SerialLotNumber");
		
		Filter = New Structure(Parameters.FilterColumns);
		FillPropertyValues(Filter, Row);
		QueryTableFiltered = QueryTable.Copy(Filter);

		ArrayOfLineNumbers = QueryTableFiltered.UnloadColumn("LineNumber");
		LineNumbers = StrConcat(ArrayOfLineNumbers, ",");

		BasisUnit = "";
		If QueryTableCopy.Columns.Find("BasisUnit") <> Undefined Then
			BasisUnit = Row.BasisUnit;
		EndIf;
		LackOfBalance = ?(Row.LackOfBalance < 0, -Row.LackOfBalance, Row.LackOfBalance);
		If Parameters.RecordType = AccumulationRecordType.Receipt Then
			RemainsQuantity = Row.Quantity + LackOfBalance;
		Else
			If Row.LackOfBalance < 0 Then
				RemainsQuantity = Row.Quantity + LackOfBalance;
			Else
				RemainsQuantity = Row.Quantity - LackOfBalance;
			EndIf;
		EndIf;
		
		// row is present in document
		If ValueIsFilled(ArrayOfLineNumbers[0]) Then
			LineNumber = ArrayOfLineNumbers[0];

			If Row.Unposting Then
				
				If SerialLotNumberIsPresent And ValueIsFilled(Row.SerialLotNumber) Then
					MessageText = StrTemplate(R().Error_068_2, LineNumber, Row.Item, Row.ItemKey, Row.SerialLotNumber, 
						Parameters.Operation, LackOfBalance, 0, LackOfBalance, BasisUnit);
				Else
					MessageText = StrTemplate(R().Error_068, LineNumber, Row.Item, Row.ItemKey,
						Parameters.Operation, LackOfBalance, 0, LackOfBalance, BasisUnit);
				EndIf;
				
			Else // Posting
				
				If SerialLotNumberIsPresent And ValueIsFilled(Row.SerialLotNumber) Then
					MessageText = StrTemplate(R().Error_068_2, LineNumber, Row.Item, Row.ItemKey, Row.SerialLotNumber,
						Parameters.Operation, RemainsQuantity, Row.Quantity, LackOfBalance, BasisUnit);
				Else
					MessageText = StrTemplate(R().Error_068, LineNumber, Row.Item, Row.ItemKey,
						Parameters.Operation, RemainsQuantity, Row.Quantity, LackOfBalance, BasisUnit);
				EndIf;
				
			EndIf;
			
			CommonFunctionsClientServer.ShowUsersMessage(
				MessageText, TableDataPath + "[" + (LineNumber - 1) + "]." + QuantityColumnName, "Object.ItemList");
		
		Else // row is deleted
			
			If ValueIsFilled(ErrorQuantityField) Then
				If Row.Unposting Then
					
					If SerialLotNumberIsPresent And ValueIsFilled(Row.SerialLotNumber) Then
						MessageText = StrTemplate(R().Error_090_2, Row.Item, Row.ItemKey, Row.SerialLotNumber, 
							Parameters.Operation, LackOfBalance, 0, LackOfBalance, BasisUnit);
					Else
						MessageText = StrTemplate(R().Error_090, Row.Item, Row.ItemKey, 
							Parameters.Operation, LackOfBalance, 0, LackOfBalance, BasisUnit);
					EndIf;
				
				Else // Posting
					
					If SerialLotNumberIsPresent And ValueIsFilled(Row.SerialLotNumber) Then
						MessageText = StrTemplate(R().Error_090_2, Row.Item, Row.ItemKey, Row.SerialLotNumber,
							Parameters.Operation, RemainsQuantity, Row.Quantity, LackOfBalance, BasisUnit);
					Else
						MessageText = StrTemplate(R().Error_090, Row.Item, Row.ItemKey, 
							Parameters.Operation, RemainsQuantity, Row.Quantity, LackOfBalance, BasisUnit);
					EndIf;
				EndIf;
				CommonFunctionsClientServer.ShowUsersMessage(MessageText, ErrorQuantityField);
				
			Else // something else
				
				If SerialLotNumberIsPresent And ValueIsFilled(Row.SerialLotNumber) Then
					MessageText = StrTemplate(R().Error_068_2, LineNumbers, Row.Item, Row.ItemKey, Row.SerialLotNumber,
						Parameters.Operation, LackOfBalance, 0, LackOfBalance, BasisUnit);
				Else
					MessageText = StrTemplate(R().Error_068, LineNumbers, Row.Item, Row.ItemKey, 
						Parameters.Operation, LackOfBalance, 0, LackOfBalance, BasisUnit);
				EndIf;
				
				CommonFunctionsClientServer.ShowUsersMessage(MessageText);
			EndIf;
		EndIf;
	EndDo;
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ArrayOfPostingErrorMessages", ArrayOfPostingErrorMessages);
EndProcedure

Procedure UUIDToString(QueryTable, RowKeyUUID = "RowKeyUUID", RowKeyString = "RowKey") Export
	QueryTable.Columns.Add(RowKeyString, New TypeDescription("String", , New StringQualifiers(50)));
	For Each Row In QueryTable Do
		Row[RowKeyString] = String(Row[RowKeyUUID]);
	EndDo;
EndProcedure

Function GetLineNumberAndRowKeyFromItemList(Ref, FullTableName) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	ItemList.Key AS RowKeyUUID,
	|	ItemList.LineNumber AS LineNumber
	|FROM
	|	%1 AS ItemList
	|WHERE
	|	ItemList.Ref = &Ref";
	Query.Text = StrTemplate(Query.Text, FullTableName);
	Query.SetParameter("Ref", Ref);
	QueryResult = Query.Execute();
	ItemList_InDocument = QueryResult.Unload();
	UUIDToString(ItemList_Indocument);
	Return ItemList_InDocument;
EndFunction

Function GetLineNumberAndItemKeyFromItemList(Ref, FullTableName) Export
	ArrayOfNameParts = StrSplit(FullTableName, ".");
	DocumentName = ArrayOfNameParts[1];
	TabularSectionName = ArrayOfNameParts[2];

	IsStoreInTabularSection = Metadata.Documents[DocumentName].TabularSections[TabularSectionName].Attributes.Find("Store") <> Undefined;

	Query = New Query();
	Query.Text =
	"SELECT
	|	ItemList.ItemKey AS ItemKey,
	|	%1
	|	ItemList.LineNumber AS LineNumber
	|FROM
	|	%2 AS ItemList
	|WHERE
	|	ItemList.Ref = &Ref";
	QueryStoreField = "";
	If IsStoreInTabularSection Then
		QueryStoreField = "ItemList.Store AS Store,";
	Else
		QueryStoreField = "VALUE(Catalog.Stores.EmptyRef) AS Store,";
	EndIf;
	Query.Text = StrTemplate(Query.Text, QueryStoreField, FullTableName);
	Query.SetParameter("Ref", Ref);
	QueryResult = Query.Execute();
	ItemList_InDocument = QueryResult.Unload();
	Return ItemList_InDocument;
EndFunction

Function GetLockFieldsMap(LockFieldNames) Export
	Fields = New Map();
	ArrayOfFieldNames = StrSplit(LockFieldNames, ",", False);
	For Each ItemFieldName In ArrayOfFieldNames Do
		Fields.Insert(TrimAll(ItemFieldName), TrimAll(ItemFieldName));
	EndDo;
	Return Fields;
EndFunction

Function GetExistsRecordsFromAccRegister(Ref, RegisterFullName, RecordType = Undefined, AddInfo = Undefined) Export
	Query = New Query();
	Query.Text =
	"SELECT *
	|FROM
	|	%1 AS Table
	|WHERE
	|	Table.Recorder = &Recorder
	|	AND CASE
	|		WHEN &Filter_RecordType
	|			THEN Table.RecordType = &RecordType
	|		ELSE TRUE
	|	END";
	Query.Text = StrTemplate(Query.Text, RegisterFullName);
	Query.SetParameter("Recorder", Ref);
	Query.SetParameter("Filter_RecordType", RecordType <> Undefined);
	If RecordType = Undefined Then
		Query.SetParameter("RecordType", AccumulationRecordType.Expense);
	Else
		Query.SetParameter("RecordType", RecordType);
	EndIf;
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

Function PrepareRecordsTables(Dimensions, LineNumberJoinConditionField, ItemList_InDocument, Records_InDocument,
	Records_Exists, Unposting, AddInfo = Undefined) Export

	ArrayOfDimensions = StrSplit(Dimensions, ",");
	JoinCondition = "";
	ArrayOfSelectedFields = New Array(); // Array Of String
	For Each ItemOfDimension In ArrayOfDimensions Do
		If Upper(TrimAll(ItemOfDimension)) = Upper(TrimAll(LineNumberJoinConditionField)) Then
			Continue;
		EndIf;
		ArrayOfSelectedFields.Add(" " + "Records." + TrimAll(ItemOfDimension));
		JoinCondition = JoinCondition + StrTemplate(" AND Records.%1 =  Records_with_LineNumbers.%1 ", TrimAll(
			ItemOfDimension));
	EndDo;
	StrSelectedFields = StrConcat(ArrayOfSelectedFields, ",");

	Query = New Query();
	Query.TempTablesManager = New TempTablesManager();
	Query.Text =
	"SELECT %1,
	|	Records.%2,
	|	Records.Quantity
	|INTO Records_InDocument
	|FROM
	|	&Records_InDocument AS Records
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList_InDocument.%2,
	|	ItemList_InDocument.LineNumber
	|INTO ItemList_InDocument
	|FROM
	|	&ItemList_InDocument AS ItemList_InDocument
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT %1, 
	|	Records.%2,
	|	Records.Quantity
	|INTO Records_Exists
	|FROM
	|	&Records_Exists AS Records
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT %1,
	|	Records.%2,
	|	Records.Quantity,
	|	ItemList_InDocument.LineNumber
	|INTO Records_with_LineNumbers
	|FROM
	|	Records_InDocument AS Records
	|		LEFT JOIN ItemList_InDocument AS ItemList_InDocument
	|		ON Records.%2 = ItemList_InDocument.%2
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT %1,
	|	Records.Quantity,
	|	Records.LineNumber,
	|	Records.%2
	|INTO ItemList_All
	|FROM
	|	Records_with_LineNumbers AS Records
	|
	|UNION ALL
	|
	|SELECT %1,
	|	Records.Quantity,
	|	UNDEFINED,
	|	Records.%2
	|FROM
	|	Records_Exists AS Records
	|		LEFT JOIN Records_with_LineNumbers AS Records_with_LineNumbers
	|		ON  Records.%2 = Records_with_LineNumbers.%2
	| 		%3
	|WHERE
	|	Records_with_LineNumbers.%2 IS NULL
	|	AND NOT &Unposting
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|SELECT %1,
	|	Records.%2,
	|	MIN(Records.LineNumber) AS LineNumber,
	|	SUM(Records.Quantity) AS Quantity
	|INTO ItemList
	|FROM 
	|	ItemList_All AS Records
	|GROUP BY
	|	%1,
	|	Records.%2
	|;";
	Query.Text = StrTemplate(Query.Text, StrSelectedFields, LineNumberJoinConditionField, JoinCondition);

	Query.SetParameter("Records_InDocument", Records_InDocument);
	Query.SetParameter("ItemList_InDocument", ItemList_InDocument);
	Query.SetParameter("Records_Exists", Records_Exists);
	Query.SetParameter("Unposting", Unposting);
	Query.Execute();

	Return Query.TempTablesManager;
EndFunction

Function CheckingBalanceIsRequired(Ref, SettingUniqueID) Export
	Filter = New Structure();
	Filter.Insert("MetadataObject", Ref.Metadata());
	Filter.Insert("AttributeName", SettingUniqueID);
	UserSettings = UserSettingsServer.GetUserSettings(Undefined, Filter);
	If UserSettings.Count() And UserSettings[0].Value = True Then
		Return True;
	Else
		Return False;
	EndIf;
EndFunction

Procedure CheckBalance_AfterWrite(Ref, Cancel, Parameters, TableNameWithItemKeys, AddInfo = Undefined) Export
	
	Unposting = ?(Parameters.Property("Unposting"), Parameters.Unposting, False);
	AccReg = AccumulationRegisters;

	RecordType = AccumulationRecordType.Receipt;
	If Parameters.Property("RecordType") Then
		RecordType = Parameters.RecordType;
	EndIf;

	LineNumberAndItemKeyFromItemList = GetLineNumberAndItemKeyFromItemList(Ref, TableNameWithItemKeys);
	
	// R4011B_FreeStocks
	If Parameters.Object.RegisterRecords.Find("R4011B_FreeStocks") <> Undefined Then
		Records_InDocument = Undefined;
		If Unposting Then
			Records_InDocument = Parameters.Object.RegisterRecords.R4011B_FreeStocks.Unload();
		Else
			Records_InDocument = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "R4011B_FreeStocks");
			If Records_InDocument = Undefined Then
				Records_InDocument = GetQueryTableByName("R4011B_FreeStocks", Parameters, True);
			EndIf;
		EndIf;

		If Not Records_InDocument.Columns.Count() Then
			Records_InDocument = CommonFunctionsServer.CreateTable(Metadata.AccumulationRegisters.R4011B_FreeStocks);
		EndIf;

		Exists_R4011B_FreeStocks = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "Exists_R4011B_FreeStocks");
		If Exists_R4011B_FreeStocks = Undefined Then
			Exists_R4011B_FreeStocks = GetQueryTableByName("Exists_R4011B_FreeStocks", Parameters, True);
		EndIf;

		If Not Cancel And Not AccReg.R4011B_FreeStocks.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
			Records_InDocument, Exists_R4011B_FreeStocks, RecordType, Unposting, AddInfo) Then
			Cancel = True;
		EndIf;
	EndIf;
	
	// R4010B_ActualStocks
	If Parameters.Object.RegisterRecords.Find("R4010B_ActualStocks") <> Undefined Then
		Records_InDocument = Undefined;
		If Unposting Then
			Records_InDocument = Parameters.Object.RegisterRecords.R4010B_ActualStocks.Unload();
		Else
			Records_InDocument = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "R4010B_ActualStocks");
			If Records_InDocument = Undefined Then
				Records_InDocument = GetQueryTableByName("R4010B_ActualStocks", Parameters, True);
			EndIf;
		EndIf;

		If Not Records_InDocument.Columns.Count() Then
			Records_InDocument = CommonFunctionsServer.CreateTable(Metadata.AccumulationRegisters.R4010B_ActualStocks);
		EndIf;

		Exists_R4010B_ActualStocks = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "Exists_R4010B_ActualStocks");
		If Exists_R4010B_ActualStocks = Undefined Then
			Exists_R4010B_ActualStocks = GetQueryTableByName("Exists_R4010B_ActualStocks", Parameters, True);
		EndIf;

		If Not Cancel And Not AccReg.R4010B_ActualStocks.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
			Records_InDocument, Exists_R4010B_ActualStocks, RecordType, Unposting, AddInfo) Then
			Cancel = True;
		EndIf;
	EndIf;
EndProcedure

Function CheckBalance_R4011B_FreeStocks(Ref, Tables, RecordType, Unposting, AddInfo = Undefined) Export
	Parameters = New Structure();
	Parameters.Insert("Metadata"         	 , Metadata.AccumulationRegisters.R4011B_FreeStocks);
	Parameters.Insert("Operation"            , Metadata.AccumulationRegisters.R4011B_FreeStocks.Synonym);
	Parameters.Insert("TempTablesManager"    , New TempTablesManager());
	Parameters.Insert("BalancePeriod", Undefined);
	Return CheckBalance(Ref, Parameters, Tables, RecordType, Unposting, AddInfo);
EndFunction

Function Exists_R4011B_FreeStocks() Export
	Return "SELECT *
		   |INTO Exists_R4011B_FreeStocks
		   |FROM
		   |	AccumulationRegister.R4011B_FreeStocks AS R4011B_FreeStocks
		   |WHERE
		   |	R4011B_FreeStocks.Recorder = &Ref";
EndFunction

Function CheckBalance_R4010B_ActualStocks(Ref, Tables, RecordType, Unposting, AddInfo = Undefined) Export
	Parameters = New Structure();
	Parameters.Insert("Metadata"         	 , Metadata.AccumulationRegisters.R4010B_ActualStocks);
	Parameters.Insert("Operation"            , Metadata.AccumulationRegisters.R4010B_ActualStocks.Synonym);
	Parameters.Insert("TempTablesManager"    , New TempTablesManager());
	Parameters.Insert("BalancePeriod", Undefined);
	Return CheckBalance(Ref, Parameters, Tables, RecordType, Unposting, AddInfo);
EndFunction

Function Exists_R4010B_ActualStocks() Export
	Return "SELECT *
		   |INTO Exists_R4010B_ActualStocks
		   |FROM
		   |	AccumulationRegister.R4010B_ActualStocks AS R4010B_ActualStocks
		   |WHERE
		   |	R4010B_ActualStocks.Recorder = &Ref";
EndFunction

Function CheckBalance(Ref, Parameters, Tables, RecordType, Unposting, AddInfo = Undefined)
	
	IsFreeStock = Parameters.Metadata = Metadata.AccumulationRegisters.R4011B_FreeStocks;
	
	If RecordType = AccumulationRecordType.Expense Then
		If Not IsFreeStock Then
			Parameters.BalancePeriod = 
				CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "BalancePeriod", New Boundary(Ref.PointInTime(), BoundaryType.Including));
		EndIf;
		
		CheckResult = CheckBalance_ExecuteQuery(Ref, Parameters, Tables, RecordType, Unposting, AddInfo);
		Return CheckResult.IsOk;
	Else // Receipt
		
		IsPostingNewDocument = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "IsPostingNewDocument", False);
		If IsPostingNewDocument Then
			Return True;
		EndIf;
		
		CheckResult = CheckBalance_ExecuteQuery(Ref, Parameters, Tables, RecordType, Unposting, AddInfo);
		
		If IsFreeStock Then
			Return CheckResult.IsOk;
		EndIf;
		
		If CheckResult.IsOk Then
			ExpensesCheckResult = CheckAllExpenses(Parameters, AddInfo);
			Return ExpensesCheckResult.IsOk;
		EndIf;
	EndIf;
	Return False;
EndFunction

Function GetOriginalDocumentDate(DocObject) Export
	If Not ValueIsFilled(DocObject.Ref) Then
		Return DocObject.Date;
	EndIf;
	Return DocObject.Ref.Date;
EndFunction

Function CheckAllExpenses(Parameters, AddInfo = Undefined)
	Result = New Structure("IsOk", True);
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT
	|	ActualStocks.Recorder AS Recorder,
	|	ActualStocks.Store AS Store,
	|	ActualStocks.ItemKey.Item AS Item,
	|	ActualStocks.ItemKey AS ItemKey,
	|	CASE
	|		WHEN ActualStocks.ItemKey.Unit = VALUE(Catalog.Units.EmptyRef)
	|			THEN ActualStocks.ItemKey.Item.Unit
	|		ELSE ActualStocks.ItemKey.Unit
	|	END AS BasisUnit,
	|	ActualStocks.SerialLotNumber AS SerialLotNumber,
	|	ActualStocks.QuantityClosingBalance AS LackOfBalance
	|FROM
	|	AccumulationRegister.R4010B_ActualStocks.BalanceAndTurnovers(&BeginPeriod,, Recorder,, (Store, ItemKey) IN
	|		(SELECT
	|			Records_Exists.Store AS Store,
	|			Records_Exists.ItemKey AS ItemKey
	|		FROM
	|			Records_Exists AS Records_Exists
	|		WHERE
	|			Records_Exists.Store.NegativeStockControl)) AS ActualStocks
	|WHERE
	|	ActualStocks.QuantityExpense > 0
	|	and ActualStocks.QuantityClosingBalance < 0";
	Query.SetParameter("BeginPeriod", 
		CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "OriginalDocumentDate", CommonFunctionsServer.GetCurrentSessionDate()));
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_104, String(QuerySelection.Recorder)));
		
		If ValueIsFilled(QuerySelection.SerialLotNumber) Then
			MessageText = StrTemplate(R().Error_069_2, 
				QuerySelection.Store, 
				QuerySelection.Item, 
				QuerySelection.ItemKey, 
				QuerySelection.SerialLotNumber, 
				-QuerySelection.LackOfBalance,
				QuerySelection.BasisUnit);
		Else
			MessageText = StrTemplate(R().Error_069, 
				QuerySelection.Store, 
				QuerySelection.Item, 
				QuerySelection.ItemKey, 
				-QuerySelection.LackOfBalance,
				QuerySelection.BasisUnit);
		EndIf;
		CommonFunctionsClientServer.ShowUsersMessage(MessageText);	
		Result.IsOk = False;
		Break;
	EndDo;
		
	Return Result;
EndFunction

Function CheckBalance_ExecuteQuery(Ref, Parameters, Tables, RecordType, Unposting, AddInfo = Undefined)
	
	QueryText_R4010B_ActualStocks =
	"SELECT
	|	Records_All_Grouped.ItemKey.Item AS Item,
	|	Records_All_Grouped.ItemKey,
	|	Records_All_Grouped.SerialLotNumber,
	|	Records_All_Grouped.Store,
	|	ISNULL(BalanceRegister.QuantityBalance, 0) AS QuantityBalance,
	|	Records_All_Grouped.Quantity AS Quantity,
	|	-ISNULL(BalanceRegister.QuantityBalance, 0) AS LackOfBalance,
	|	&Unposting AS Unposting
	|INTO Lack
	|FROM
	|	Records_All_Grouped AS Records_All_Grouped
	|		LEFT JOIN AccumulationRegister.%1.Balance(&Period, (Store, ItemKey, SerialLotNumber) IN
	|			(SELECT
	|				Records_All_Grouped.Store,
	|				Records_All_Grouped.ItemKey,
	|				Records_All_Grouped.SerialLotNumber
	|			FROM
	|				Records_All_Grouped AS Records_All_Grouped)) AS BalanceRegister
	|		ON Records_All_Grouped.Store = BalanceRegister.Store
	|		AND Records_All_Grouped.ItemKey = BalanceRegister.ItemKey
	|		AND Records_All_Grouped.SerialLotNumber = BalanceRegister.SerialLotNumber
	|WHERE
	|	ISNULL(BalanceRegister.QuantityBalance, 0) < 0
	|;";
		
	QueryText_R4011B_FreeStocks =
	"SELECT
	|	Records_All_Grouped.ItemKey.Item AS Item,
	|	Records_All_Grouped.ItemKey,
	|	VALUE(Catalog.SerialLotNumbers.EmptyRef) AS SerialLotNumber,
	|	Records_All_Grouped.Store,
	|	ISNULL(BalanceRegister.QuantityBalance, 0) AS QuantityBalance,
	|	Records_All_Grouped.Quantity AS Quantity,
	|	-ISNULL(BalanceRegister.QuantityBalance, 0) AS LackOfBalance,
	|	&Unposting AS Unposting
	|INTO Lack
	|FROM
	|	Records_All_Grouped AS Records_All_Grouped
	|		LEFT JOIN AccumulationRegister.%1.Balance(&Period, (Store, ItemKey) IN
	|			(SELECT
	|				Records_All_Grouped.Store,
	|				Records_All_Grouped.ItemKey
	|			FROM
	|				Records_All_Grouped AS Records_All_Grouped)) AS BalanceRegister
	|		ON Records_All_Grouped.Store = BalanceRegister.Store
	|		AND Records_All_Grouped.ItemKey = BalanceRegister.ItemKey
	|WHERE
	|	ISNULL(BalanceRegister.QuantityBalance, 0) < 0
	|;";
	
	BalanceRegisterTable = 
		?(Parameters.Metadata = Metadata.AccumulationRegisters.R4010B_ActualStocks,
			QueryText_R4010B_ActualStocks, QueryText_R4011B_FreeStocks);
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	//@skip-check bsl-ql-hub
	Query.Text =
	"SELECT
	|	ItemList.ItemKey,
	|	ItemList.Store,
	|	ItemList.LineNumber
	|INTO ItemList
	|FROM
	|	&ItemList_InDocument AS ItemList
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Records.Store,
	|	Records.ItemKey,
	|   Records.SerialLotNumber,
	|	Records.Quantity
	|INTO Records_Exists
	|FROM
	|	&Records_Exists AS Records
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Records.Store,
	|	Records.ItemKey,
	|	Records.SerialLotNumber,
	|	Records.Quantity
	|INTO Records_InDocument
	|FROM
	|	&Records_InDocument AS Records
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Records_Exists.Store,
	|	Records_Exists.ItemKey,
	|	Records_Exists.SerialLotNumber,
	|	Records_Exists.Quantity
	|INTO Records_All
	|FROM
	|	Records_Exists AS Records_Exists
	|		LEFT JOIN Records_InDocument AS Records_InDocument
	|		ON Records_Exists.Store = Records_InDocument.Store
	|		AND Records_Exists.ItemKey = Records_InDocument.ItemKey
	|		AND Records_Exists.SerialLotNumber = Records_InDocument.SerialLotNumber
	|WHERE
	|	Records_InDocument.ItemKey IS NULL
	|	AND NOT &Unposting
	|
	|UNION ALL
	|
	|SELECT
	|	Records_InDocument.Store,
	|	Records_InDocument.ItemKey,
	|	Records_InDocument.SerialLotNumber,
	|	Records_InDocument.Quantity
	|FROM
	|	Records_InDocument AS Records_InDocument
	|WHERE
	|	NOT &Unposting
	|
	|UNION ALL
	|
	|SELECT
	|	Records_Exists.Store,
	|	Records_Exists.ItemKey,
	|	Records_Exists.SerialLotNumber,
	|	Records_Exists.Quantity
	|FROM
	|	Records_Exists AS Records_Exists
	|WHERE
	|	&Unposting
	|
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Records_All.Store,
	|	Records_All.ItemKey,
	|	Records_All.SerialLotNumber,
	|	SUM(Records_All.Quantity) AS Quantity
	|INTO Records_All_Grouped
	|FROM
	|	Records_All AS Records_All
	|WHERE
	|	Records_All.Store.NegativeStockControl
	|GROUP BY
	|	Records_All.Store,
	|	Records_All.ItemKey,
	|	Records_All.SerialLotNumber
	|;
	|" + BalanceRegisterTable +
	"////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Lack.Item,
	|	Lack.ItemKey,
	|	Lack.SerialLotNumber,
	|	Lack.QuantityBalance,
	|	Lack.Quantity,
	|	Lack.LackOfBalance,
	|	Lack.Unposting,
	|	MIN(ItemList.LineNumber) AS LineNumber
	|FROM
	|	Lack AS Lack
	|		LEFT JOIN ItemList AS ItemList
	|		ON Lack.ItemKey = ItemList.ItemKey
	|		AND CASE 
	|			WHEN NOT ItemList.Store.Ref IS NULL THEN 
	|				Lack.Store = ItemList.Store 
	|			ELSE 
	|				TRUE 
	|		END
	|GROUP BY
	|	Lack.Item,
	|	Lack.ItemKey,
	|	Lack.SerialLotNumber,
	|	Lack.QuantityBalance,
	|	Lack.Quantity,
	|	Lack.LackOfBalance,
	|	Lack.Unposting";
	
	Query.Text = StrTemplate(Query.Text, Parameters.Metadata.Name);

	If Tables.Records_Exists.Columns.Find("SerialLotNumber") = Undefined Then
		Tables.Records_Exists.Columns.Add("SerialLotNumber", New TypeDescription("CatalogRef.SerialLotNumbers"));
		Tables.Records_Exists.FillValues(Catalogs.SerialLotNumbers.EmptyRef(), "SerialLotNumber");
	EndIf;
	
	If Tables.Records_InDocument.Columns.Find("SerialLotNumber") = Undefined Then
		Tables.Records_InDocument.Columns.Add("SerialLotNumber", New TypeDescription("CatalogRef.SerialLotNumbers"));
		Tables.Records_InDocument.FillValues(Catalogs.SerialLotNumbers.EmptyRef(), "SerialLotNumber");
	EndIf;
		
	Query.SetParameter("Period"              , Parameters.BalancePeriod);
	Query.SetParameter("ItemList_InDocument" , Tables.ItemList_InDocument);
	Query.SetParameter("Records_Exists"      , Tables.Records_Exists);
	Query.SetParameter("Records_InDocument"  , Tables.Records_InDocument);
	Query.SetParameter("Unposting"           , Unposting);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	Result = New Structure("IsOk", True);
	
	If QueryTable.Count() Then
		Result.IsOk = False;
		ErrorParameters = New Structure();
		ErrorParameters.Insert("GroupColumns"  , "ItemKey, Item, LackOfBalance, SerialLotNumber");
		ErrorParameters.Insert("SumColumns"    , "Quantity");
		ErrorParameters.Insert("FilterColumns" , "ItemKey, Item, LackOfBalance, SerialLotNumber");
		ErrorParameters.Insert("Operation"     , Parameters.Operation);
		ErrorParameters.Insert("RecordType"    , RecordType);

		TableDataPath = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "TableDataPath");
		If ValueIsFilled(TableDataPath) Then
			ErrorParameters.Insert("TableDataPath", TableDataPath);
		EndIf;

		ErrorQuantityField = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ErrorQuantityField");
		If ValueIsFilled(ErrorQuantityField) Then
			ErrorParameters.Insert("ErrorQuantityField", ErrorQuantityField);
		EndIf;

		ShowPostingErrorMessage(QueryTable, ErrorParameters, AddInfo);
	EndIf;
	Return Result;
EndFunction

Function UseRegister(Name) Export
	// Delete CashInTransit
	Return Mid(Name, 7, 1) = "_" Or Mid(Name, 4, 1) = "_" Or Mid(Name, 3, 1) = "_";
EndFunction

Procedure ExecuteQuery(Ref, QueryArray, Parameters) Export
	If Not QueryArray.Count() Then
		Return;
	EndIf;
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.SetParameter("Ref", Ref);

	If Parameters.Property("QueryParameters") Then
		For Each Param In Parameters.QueryParameters Do
			Query.SetParameter(Param.Key, Param.Value);
		EndDo;
	EndIf;

	Query.Text = StrConcat(QueryArray, Chars.LF + ";" + Chars.LF);
	Query.Execute();
EndProcedure

Function QueryTableIsExists(TableName, Parameters) Export
	Return Parameters.TempTablesManager.Tables.Find(TableName) <> Undefined;
EndFunction

Function GetQueryTableByName(TableName, Parameters, RaiseExeption = False) Export
	VTSearch = Parameters.TempTablesManager.Tables.Find(TableName);
	If VTSearch = Undefined Then
		If RaiseExeption Then
			Raise StrTemplate("Table [%1] not found in temp tables", TableName);
		Else
			Return New ValueTable();
		EndIf;
	EndIf;
	Return VTSearch.GetData().Unload();
EndFunction

Procedure FillPostingTables(Tables, Ref, QueryArray, Parameters) Export
	ExecuteQuery(Ref, QueryArray, Parameters);
	For Each VT In Tables Do
		QueryTable = GetQueryTableByName(VT.Key, Parameters);
		If QueryTable.Count() Then
			CommonFunctionsServer.MergeTables(Tables[VT.Key], QueryTable, "RecordType");
		EndIf;
	EndDo;
EndProcedure

// Set posting data tables.
// 
// Parameters:
//  PostingDataTables - Map:
//  * Key - MetadataObject
//  * Value - See PostingTableSettings
//  Parameters - See GetPostingParameters
//  UseOldRegisters - Boolean - Use old registers
Procedure SetPostingDataTables(PostingDataTables, Parameters, UseOldRegisters = False) Export
	
	RegisterRecords = GetRegisterRecords(Parameters);
	
	For Each Table In Parameters.DocumentDataTables Do
		If UseOldRegisters Or UseRegister(Table.Key) Then
			SetPostingDataTable(PostingDataTables, Parameters, Table.Key, Table.Value, RegisterRecords);
		EndIf;
	EndDo;
EndProcedure

Function GetRegisterRecords(Parameters)
	If Parameters.PostingByRef Then
		TmpDoc = Documents[Parameters.Metadata.Name].CreateDocument();
		RegisterRecords = TmpDoc.RegisterRecords;
	Else
		//@skip-check property-return-type
		RegisterRecords = Parameters.Object.RegisterRecords; // RegisterRecordsCollection
	EndIf;
	
	Return RegisterRecords;
EndFunction

Procedure SetPostingDataTable(PostingDataTables, Parameters, Name, VT, RegisterRecords = Undefined) Export
	If RegisterRecords = Undefined Then
		RegisterRecords = GetRegisterRecords(Parameters);
	EndIf;
	
	RecSetData = RegisterRecords[Name];
	If Parameters.PostingByRef Then
		RecSetData.Filter.Recorder.Set(Parameters.Object);
	EndIf;
	Settings = PostingTableSettings(VT, RecSetData);
	PostingDataTables.Insert(RecSetData.Metadata(), Settings);
EndProcedure

// Posting table settings.
// 
// Parameters:
//  Table - ValueTable -
//  RecSetData - InformationRegisterRecordSetInformationRegisterName, AccountingRegisterRecordSetAccountingRegisterName, CalculationRegisterRecordSetCalculationRegisterName, AccumulationRegisterRecordSetAccumulationRegisterName - Rec set data
// 
// Returns:
//  Structure - Posting table settings:
// * PrepareTable - ValueTable - 
// * WriteInTransaction - Boolean - 
// * Metadata - MetadataObjectInformationRegister, MetadataObjectAccountingRegister, MetadataObjectCalculationRegister, MetadataObjectAccumulationRegister - 
// * RecordSet_Document - AccumulationRegisterRecordSet, InformationRegisterRecordSet - 
// * RecordType - Undefined, AccumulationRecordType - 
Function PostingTableSettings(Table, RecSetData) Export
	Settings = New Structure;
	Settings.Insert("PrepareTable", Table);
	Settings.Insert("WriteInTransaction", True);
	Settings.Insert("Metadata", RecSetData.Metadata());
	Settings.Insert("RecordSet_Document", RecSetData);
	Return Settings;
EndFunction

Procedure GetLockDataSource(DataMapWithLockFields, DocumentDataTables, UseOldRegisters = False) Export
	For Each Register In DocumentDataTables Do
		If UseOldRegisters Or UseRegister(Register.Key) Then
			LockData = AccumulationRegisters[Register.Key].GetLockFields(DocumentDataTables[Register.Key]);
			DataMapWithLockFields.Insert(LockData.RegisterName, LockData.LockInfo);
		EndIf;
	EndDo;
EndProcedure

Procedure SetRegisters(Tables, DocumentRef, UseOldRegisters = False) Export
	For Each Register In DocumentRef.Metadata().RegisterRecords Do
		If UseOldRegisters Or UseRegister(Register.Name) Then
			Tables.Insert(Register.Name, CommonFunctionsServer.CreateTable(Register));
		EndIf;
	EndDo;
EndProcedure

Function Exists_R4014B_SerialLotNumber() Export
	Return 
		"SELECT *
		|	INTO Exists_R4014B_SerialLotNumber
		|FROM
		|	AccumulationRegister.R4014B_SerialLotNumber AS R4014B_SerialLotNumber
		|WHERE
		|	R4014B_SerialLotNumber.Recorder = &Ref";
EndFunction

Function Exists_R2001T_Sales() Export
	Return 
		"SELECT *
		|	INTO Exists_R2001T_Sales
		|FROM
		|	AccumulationRegister.R2001T_Sales AS R2001T_Sales
		|WHERE
		|	R2001T_Sales.Recorder = &Ref";
EndFunction

#Region BatchInfo

// Get batch keys info settings.
// 
// Returns:
//  Structure - Get batch keys info settings:
// * Dimensions - String - 
// * Totals - String - 
// * DataTable - ValueTable - 
// * CurrencyMovementType - ChartOfCharacteristicTypesRef.CurrencyMovementType - 
Function GetBatchKeysInfoSettings() Export
	BatchKeysInfoSettings = New Structure;
	BatchKeysInfoSettings.Insert("Dimensions", "");
	BatchKeysInfoSettings.Insert("Totals", "");
	BatchKeysInfoSettings.Insert("DataTable", New ValueTable());
	BatchKeysInfoSettings.Insert("CurrencyMovementType", ChartsOfCharacteristicTypes.CurrencyMovementType.EmptyRef());
	Return BatchKeysInfoSettings;
EndFunction

// Set batch key info table.
// 
// Parameters:
//  Parameters - See GetPostingParameters
//  BatchKeysInfoSettings - See GetBatchKeysInfoSettings
Procedure SetBatchKeyInfoTable(Parameters, BatchKeysInfoSettings) Export
	
	If BatchKeysInfoSettings.DataTable.Columns.Find("CurrencyMovementType") = Undefined Then
		BatchKeysInfoSettings.DataTable.Columns.Add("CurrencyMovementType", New TypeDescription("ChartOfCharacteristicTypesRef.CurrencyMovementType"));
	EndIf;
	
	TotalsArray = New Array;
	For Each Row In StrSplit(BatchKeysInfoSettings.Totals, ", ", False) Do
		TotalsArray.Add("SUM(" + Row + ") AS " + Row);
	EndDo;
	
	Query = New Query;
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
	"SELECT
	|	DataTable.*
	|INTO tmp_BatchKeysInfo
	|FROM
	|	&DataTable AS DataTable
	|;
	|
	|SELECT
	|	%1 %2 %3
	|INTO BatchKeysInfo
	|FROM
	|	tmp_BatchKeysInfo
	|WHERE
	|	CurrencyMovementType = &CurrencyMovementType
	|GROUP BY
	|	%1";
	
	Query.Text = StrTemplate(Query.Text, BatchKeysInfoSettings.Dimensions, ?(TotalsArray.Count() > 0, ",", ""),StrConcat(TotalsArray, ", "));
	
	Query.SetParameter("DataTable", BatchKeysInfoSettings.DataTable);
	Query.SetParameter("CurrencyMovementType", BatchKeysInfoSettings.CurrencyMovementType);
 	Query.Execute();
EndProcedure

#EndRegion

#Region CheckDocumentPosting

// Check document array.
// 
// Parameters:
//  DocumentArray - Array of DocumentRefDocumentName - Document array
//  isJob - Boolean -
// 
// Returns:
//  Array Of Structure - Check document array:
// * Ref - DocumentRefDocumentName -
// * Error - String -
// * RegInfo - Array Of Structure:
// ** RegName - String -
Function CheckDocumentArray(DocumentArray, isJob = False) Export

	AddInfo = New Structure;
	PostingMode = DocumentPostingMode.Regular;
	Errors = New Array;
	
	If isJob And DocumentArray.Count() = 0 Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Msg.Log = "Empty doc list: " + DocumentArray.Count();
		Msg.End = True;
		Msg.DataAddress = CommonFunctionsServer.PutToCache(Errors);
		BackgroundJobAPIServer.NotifyStream(Msg);
		Return Errors;
	EndIf;

	If DocumentArray[0].GetObject().RegisterRecords.Count() = 0
		OR SkipOnCheckPosting(DocumentArray[0].Metadata()) Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Msg.Log = "Document type: " + DocumentArray[0].Metadata().Name + " not supported document type.";
		Msg.End = True;
		Msg.DataAddress = CommonFunctionsServer.PutToCache(Errors);
		BackgroundJobAPIServer.NotifyStream(Msg);
		Return Errors;
	EndIf;

	If isJob Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Msg.Log = "Start check: " + DocumentArray.Count();
		BackgroundJobAPIServer.NotifyStream(Msg);
	EndIf;
	Count = 0; 
	LastPercentLogged = 0;
	StartDate = CurrentUniversalDateInMilliseconds();
	For Each Doc In DocumentArray Do
		BeginTransaction();
		
		DocObject = Doc;
		Try
			Parameters = GetPostingParameters(DocObject, PostingMode, AddInfo);
	
			CurrencyTable = Undefined;
			If Parameters.DocumentDataTables.Property("CurrencyTable") Then
				CurrencyTable = Parameters.DocumentDataTables.CurrencyTable;
			EndIf;
			CurrenciesServer.PreparePostingDataTables(Parameters, CurrencyTable, AddInfo);
		
			RegisteredRecords = RegisterRecords(Parameters);
			
			If RegisteredRecords.Count() > 0 Then
				Result = New Structure;
				Result.Insert("Ref", Doc);
				Result.Insert("RegInfo", New Array);
				Result.Insert("Error", "");
				For Each Reg In RegisteredRecords Do
					RegInfo = New Structure;
					RegInfo.Insert("RegName", Reg.Key.FullName());
					RegInfo.Insert("NewPostingData", Reg.Value.RecordSet.Unload());
					Result.RegInfo.Add(RegInfo);
				EndDo;
				
				Errors.Add(Result);
			EndIf;
		Except
			Msg = BackgroundJobAPIServer.NotifySettings();
			Msg.Log = "Error: " + DocObject + ":" + Chars.LF + ErrorProcessing.DetailErrorDescription(ErrorInfo());
			BackgroundJobAPIServer.NotifyStream(Msg);
			
			Result = New Structure;
			Result.Insert("Ref", Doc);
			Result.Insert("RegInfo", New Array);
			Result.Insert("Error", Msg.Log);
			Errors.Add(Result);
		EndTry;
		
		RollbackTransaction();
		
		Count = Count + 1;
		
		Percent = 100 * Count / DocumentArray.Count();
		If isJob And (Percent - LastPercentLogged >= 1) Then  
			LastPercentLogged = Int(Percent);
			Msg = BackgroundJobAPIServer.NotifySettings();
			DateDiff = CurrentUniversalDateInMilliseconds() - StartDate;
			Msg.Speed = Format(1000 * Count / DateDiff, "NFD=2; NG=") + " doc/sec";
			Msg.Percent = Percent;
			BackgroundJobAPIServer.NotifyStream(Msg);
		EndIf;

	EndDo;
	
	If isJob Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Msg.End = True;
		Msg.DataAddress = CommonFunctionsServer.PutToCache(Errors);
		BackgroundJobAPIServer.NotifyStream(Msg);
	EndIf;
	
	Return Errors;
EndFunction

Function SkipOnCheckPosting(Doc)

	Array = New Array;
	Array.Add(Metadata.Documents.CalculationMovementCosts);
	
	Return Not Array.Find(Doc) = Undefined;
EndFunction

// Posting document array.
// 
// Parameters:
//  DocumentArray - Array of DocumentRefDocumentName - Document array
//  isJob - Boolean -
// 
// Returns:
//  Array Of Structure - Check document array:
// * Ref - DocumentRefDocumentName -
// * Error - String -
Function PostingDocumentArray(DocumentArray, isJob = False) Export

	Errors = New Array;
	
	If isJob And DocumentArray.Count() = 0 Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Msg.Log = "Empty doc list: " + DocumentArray.Count();
		Msg.End = True;
		Msg.DataAddress = CommonFunctionsServer.PutToCache(Errors);
		BackgroundJobAPIServer.NotifyStream(Msg);
		Return Errors;
	EndIf;

	Count = 0; 
	LastPercentLogged = 0;
	StartDate = CurrentUniversalDateInMilliseconds();
	For Each Doc In DocumentArray Do
		Try
			Result = New Structure;
			Result.Insert("Ref", Doc);
			Result.Insert("Error", "");
			If Doc.Posted Then
				Doc.GetObject().Write(DocumentWriteMode.Posting);
			Else
				Result.Error = String(Doc) + " - Not posted";
			EndIf;
			Errors.Add(Result);
		Except
			Msg = BackgroundJobAPIServer.NotifySettings();
			Msg.Log = "Error: " + Doc + ":" + Chars.LF + ErrorProcessing.DetailErrorDescription(ErrorInfo());
			BackgroundJobAPIServer.NotifyStream(Msg);
			
			Result = New Structure;
			Result.Insert("Ref", Doc);
			Result.Insert("Error", Msg.Log);
			Errors.Add(Result);
		EndTry;
		
		Count = Count + 1;
		
		Percent = 100 * Count / DocumentArray.Count();
		If isJob And (Percent - LastPercentLogged >= 1) Then  
			LastPercentLogged = Int(Percent);
			Msg = BackgroundJobAPIServer.NotifySettings();
			DateDiff = CurrentUniversalDateInMilliseconds() - StartDate;
			Msg.Speed = Format(1000 * Count / DateDiff, "NFD=2; NG=") + " doc/sec";
			Msg.Percent = Percent;
			BackgroundJobAPIServer.NotifyStream(Msg);
		EndIf;

	EndDo;
	
	If isJob Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Msg.End = True;
		Msg.DataAddress = CommonFunctionsServer.PutToCache(Errors);
		BackgroundJobAPIServer.NotifyStream(Msg);
	EndIf;
	
	Return Errors;
	
EndFunction

// Posting document array.
// 
// Parameters:
//  DocumentArray - Array of Structure:
//  * Ref - DocumentRefDocumentName - 
//  * NewMovement - ValueStorage -
//  * RegName - String -
//  isJob - Boolean -
// 
// Returns:
//  Array Of Structure - Check document array:
// * Ref - DocumentRefDocumentName -
// * Error - String -
Function WriteDocumentsRecords(DocumentArray, isJob = False) Export

	SetSafeMode(True);
	Errors = New Array;
	
	If isJob And DocumentArray.Count() = 0 Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Msg.Log = "Empty doc list: " + DocumentArray.Count();
		Msg.End = True;
		Msg.DataAddress = CommonFunctionsServer.PutToCache(Errors);
		BackgroundJobAPIServer.NotifyStream(Msg);
		Return Errors;
	EndIf;

	Count = 0; 
	LastPercentLogged = 0;
	StartDate = CurrentUniversalDateInMilliseconds();
	
	For Each Doc In DocumentArray Do
		
		Try
			Result = New Structure;
			Result.Insert("Ref", Doc.Ref);
			Result.Insert("RegName", Doc.RegName);
			Result.Insert("Error", "");
			NewMovement = Doc.NewMovement.Get(); // ValueTable
			If Not Doc.Ref.Posted And NewMovement.Count() > 0 Then
				Result.Error = String(Doc.Ref) + " - Not posted. Can not update records";
			Else
				
				Parts = StrSplit(Doc.RegName, ".");
				CreateRecordSet = Eval(Parts[0] + "s." + Parts[1] + ".CreateRecordSet()"); // AccumulationRegisterRecordSet
				//@skip-check unknown-method-property
				CreateRecordSet.Filter.Recorder.Set(Doc.Ref);
				NewMovement.FillValues(Doc.Ref, "Recorder");
				CreateRecordSet.Load(NewMovement);
				CreateRecordSet.Write(True);
			EndIf;
			Errors.Add(Result);
		Except
			Msg = BackgroundJobAPIServer.NotifySettings();
			Msg.Log = "Error: " + Doc + ":" + Chars.LF + ErrorProcessing.DetailErrorDescription(ErrorInfo());
			BackgroundJobAPIServer.NotifyStream(Msg);
			
			Result = New Structure;
			Result.Insert("Ref", Doc);
			Result.Insert("Error", Msg.Log);
			Result.Insert("RegName", Doc.RegName);
			Errors.Add(Result);
		EndTry;
		
		Count = Count + 1;
		
		Percent = 100 * Count / DocumentArray.Count();
		If isJob And (Percent - LastPercentLogged >= 1) Then  
			LastPercentLogged = Int(Percent);
			Msg = BackgroundJobAPIServer.NotifySettings();
			DateDiff = CurrentUniversalDateInMilliseconds() - StartDate;
			Msg.Speed = Format(1000 * Count / DateDiff, "NFD=2; NG=") + " doc/sec";
			Msg.Percent = Percent;
			BackgroundJobAPIServer.NotifyStream(Msg);
		EndIf;

	EndDo;
	
	If isJob Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Msg.End = True;
		Msg.DataAddress = CommonFunctionsServer.PutToCache(Errors);
		BackgroundJobAPIServer.NotifyStream(Msg);
	EndIf;
	
	Return Errors;
	
EndFunction

#EndRegion
