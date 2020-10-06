Procedure Post(DocObject, Cancel, PostingMode, AddInfo = Undefined) Export
	
	If Cancel Then
		Return;
	EndIf;
	
	Parameters = New Structure();
	Parameters.Insert("Object", DocObject);
	Parameters.Insert("IsReposting", False);
	Parameters.Insert("PointInTime", DocObject.PointInTime());
	
	Module = Documents[DocObject.Ref.Metadata().Name];
	
	DocumentDataTables = Module.PostingGetDocumentDataTables(DocObject.Ref, Cancel, PostingMode, Parameters, AddInfo);
	Parameters.Insert("DocumentDataTables", DocumentDataTables);
	If Cancel Then
		Return;
	EndIf;
	
	LockDataSources = Module.PostingGetLockDataSource(DocObject.Ref, Cancel, PostingMode, Parameters, AddInfo);
	Parameters.Insert("LockDataSources", LockDataSources);
	If Cancel Then
		Return;
	EndIf;
	
	// Save pointers to locks
	DataLock = Undefined;
	If LockDataSources <> Undefined Then
		DataLock = SetLock(LockDataSources);
	EndIf;
	If TypeOf(AddInfo) = Type("Structure") Then
		AddInfo.Insert("DataLock", DataLock);
	EndIf;
	
	Module.PostingCheckBeforeWrite(DocObject.Ref, Cancel, PostingMode, Parameters, AddInfo);
	If Cancel Then
		Return;
	EndIf;
	
	PostingDataTables = Module.PostingGetPostingDataTables(DocObject.Ref, Cancel, PostingMode, Parameters, AddInfo);
	If Parameters.Property("PostingDataTables") Then
		Parameters.PostingDataTables = PostingDataTables;
	Else	
		Parameters.Insert("PostingDataTables", PostingDataTables);
	EndIf;
	If Cancel Then
		Return;
	EndIf;
	
	For Each KeyValue In PostingDataTables Do
		RegisterMetadata = KeyValue.Key.Metadata();
		RegisterName = RegisterMetadata.Name;
		
		If Metadata.AccumulationRegisters.Find(RegisterName) = Undefined Then
			Continue;
		EndIf;
		
		RecordInfo = KeyValue.Value;
		If RecordInfo.RecordSet.Columns.Find("RowKey") = Undefined 
		Or RegisterMetadata.Dimensions.Find("RowKey") = Undefined
		Or Not RecordInfo.RecordSet.Count() Then
			Continue;
		EndIf;
		
		RecordsForExpense = New ValueTable();
		If RecordInfo.Property("RecordType") And RecordInfo.RecordType = AccumulationRecordType.Expense Then
			RecordsForExpense = RecordInfo.RecordSet.Copy();
			RecordInfo.RecordSet.Columns.Add("RecordType");
			RecordInfo.RecordSet.FillValues(AccumulationRecordType.Expense, "RecordType");
			RecordInfo.Delete("RecordType");
		Else
			If RecordInfo.RecordSet.Columns.Find("RecordType") <> Undefined Then
				RecordsForExpense = RecordInfo.RecordSet.Copy(New Structure("RecordType", AccumulationRecordType.Expense));
			EndIf;
		EndIf;
		
		If Not RecordsForExpense.Count() Then
			Continue;
		EndIf;
	EndDo;
	
	// Multi currency integration
	CurrenciesServer.PreparePostingDataTables(Parameters, Undefined, AddInfo);

	RegisteredRecords = RegisterRecords(DocObject, PostingDataTables, Parameters.Object.RegisterRecords);
	Parameters.Insert("RegisteredRecords", RegisteredRecords);
	
	Module.PostingCheckAfterWrite(DocObject.Ref, Cancel, PostingMode, Parameters, AddInfo);
	
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

Function RegisterRecords(DocObject, PostingDataTables, AllRegisterRecords)
	For Each RecordSet In AllRegisterRecords Do
		If PostingDataTables.Get(RecordSet) = Undefined Then
			RecordSet.Write = True;
		EndIf;
	EndDo;
	
	RegisteredRecords = New Array();
	For Each Row In PostingDataTables Do
		If Not Row.Value.Property("RecordSet") Then
			Continue;
		EndIf;
		
		RecordSet = Row.Key;
		TableForLoad = Row.Value.RecordSet.Copy();
			
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
			
		// MD5
		If RecordSetIsEqual(DocObject, RecordSet, TableForLoad) Then
			Continue;
		EndIf;
		
		// Set write
		If Row.Value.Property("WriteInTransaction") And Row.Value.WriteInTransaction Then
			// write when transaction will be commited or rollback
			RecordSet.Write();
			RecordSet.Write = False;
		Else // write oly when transaction will be commited	
			RecordSet.Write = True;
		EndIf;
		
		RegisteredRecords.Add(RecordSet);
	EndDo;
	Return RegisteredRecords;
EndFunction

Function RecordSetIsEqual(DocObject, RecordSet, TableForLoad)
	RecordSet.Read();
	TableOldRecords = RecordSet.Unload();
		
	RecordSet.Load(TableForLoad);
	Return TablesIsEqual(RecordSet.Unload(), TableOldRecords);
EndFunction	

Function TablesIsEqual(Table1, Table2) Export
    If Table1.Count() <> Table2.Count() Then
		Return False;
    EndIf;
    
    DeleteColumn(Table1, "Recorder");
	DeleteColumn(Table1, "LineNumber");
	DeleteColumn(Table1, "PointInTime");
	
	DeleteColumn(Table2, "Recorder");
	DeleteColumn(Table2, "LineNumber");
	DeleteColumn(Table2, "PointInTime");
    
	Text = "SELECT
	|	*
	|INTO VTSort1
	|FROM
	|	&VT1 AS VT1
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	*
	|INTO VTSort2
	|FROM
	|	&VT2 AS VT2
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	*
	|FROM
	|	VTSort1 AS VTSort1
	|AUTOORDER
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	*
	|FROM
	|	VTSort2 AS VTSort2
	|AUTOORDER";
    
	Query = New Query;
	Query.Text = Text;
	Query.SetParameter("VT1", Table1);
	Query.SetParameter("VT2", Table2);
	QueryResult = Query.ExecuteBatch();
	
	MD5_1 = GetMD5(QueryResult[2].Unload());
	MD5_2 = GetMD5(QueryResult[3].Unload());
	
	Return MD5_1 = MD5_2;
    
EndFunction

Procedure DeleteColumn(Table, ColumnName)
	If Table.Columns.Find(ColumnName) <> Undefined Then
		Table.Columns.Delete(ColumnName);
	EndIf;
EndProcedure

Function GetMD5(Table)
	XMLWriter = New XMLWriter();
	XMLWriter.SetString();
	XDTOSerializer.WriteXML(XMLWriter, Table);
	xml = XMLWriter.Close();
	
	DataHashing = New DataHashing(HashFunction.MD5);
	DataHashing.Append(xml);
	Return DataHashing.HashSum;
EndFunction

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

Function JoinTables(ArrayOfJoiningTables, Fields) Export
	
	If Not ArrayOfJoiningTables.Count() Then
		Return New ValueTable();
	EndIf;
	
	ArrayOfFieldsPut = New Array();
	ArrayOfFieldsSelect = New Array();
	
	Counter = 1;
	For Each Field In StrSplit(Fields, ",") Do
		ArrayOfFieldsPut.Add(StrTemplate(" tmp.%1 AS %1 ", TrimAll(Field)));
		ArrayOfFieldsSelect.Add(StrTemplate(" _tmp_.%1 AS %1 ", TrimAll(Field)));
		Counter = Counter + 1;
	EndDo;
	PutText = StrConcat(ArrayOfFieldsPut, ",");
	SelectText = StrConcat(ArrayOfFieldsSelect, ",");
	
	ArrayOfPutText = New Array();
	ArrayOfSelectText = New Array();
	
	Counter = 1;
	Query = New Query();
	
	DoExecuteQuery = False;
	For Each Table In ArrayOfJoiningTables Do
		If Not Table.Count() Then
			Continue;
		EndIf;
		DoExecuteQuery = True;
		
		ArrayOfPutText.Add(
			StrTemplate(
				"select %1
				|into tmp%2
				|from
				|	&Table%2 as tmp
				|", PutText, String(Counter)));
		
		ArrayOfSelectText.Add(
			StrReplace(
				StrTemplate(
					"select %1
					|from tmp%2 as tmp%2
					|", SelectText, String(Counter))
				
				, "_tmp_", "tmp" + String(Counter))
			
		);
		
		Query.SetParameter("Table" + String(Counter), Table);
		Counter = Counter + 1;
	EndDo;
	
	If DoExecuteQuery Then
		Query.Text = StrConcat(ArrayOfPutText, " ; ") + " ; " + StrConcat(ArrayOfSelectText, " union all ");
		QueryResult = Query.Execute();
		QueryTable = QueryResult.Unload();
		Return QueryTable;
	Else
		Return New ValueTable();
	EndIf;
EndFunction

Procedure MergeTables(MasterTable, SlaveTable) Export
	For Each Row In SlaveTable Do
		FillPropertyValues(MasterTable.Add(), Row);
	EndDo;
EndProcedure

Function CreateTable(RegisterMetadata) Export
	Table = New ValueTable();
	For Each Item In RegisterMetadata.Dimensions Do
		Table.Columns.Add(Item.Name, Item.Type);
	EndDo;
	
	For Each Item In RegisterMetadata.Resources Do
		Table.Columns.Add(Item.Name, Item.Type);
	EndDo;
	For Each Item In RegisterMetadata.Attributes Do
		Table.Columns.Add(Item.Name, Item.Type);
	EndDo;
	
	For Each Item In RegisterMetadata.StandardAttributes Do
		If Upper(Item.Name) = Upper("Period") Then
			Table.Columns.Add(Item.Name, Item.Type);
		EndIf;
	EndDo;
	Return Table;
EndFunction

Function GetTableExpenceAdvance(PointInTime, QueryTableParameter, DocumentName) Export
	
	Query = New Query();
	If DocumentName = "PaymentDocument" Then
		Query.Text = GetQueryTextAdvanceToSuppliers();
	ElsIf DocumentName = "ReceiptDocument" Then
		Query.Text = GetQueryTextAdvanceFromCustomers();
	Else
		Return New ValueTable();
	EndIf;
		
	Query.SetParameter("Period", PointInTime);
	Query.SetParameter("QueryTable", QueryTableParameter);
	
	QueryResult = Query.Execute();	
	QueryTable = QueryResult.Unload();
	
	QueryTable_Registrations = QueryTable.CopyColumns();
	
	QueryTable_Grupped = QueryTable.Copy();
	
	FilterByColumns = "Period, 
		|Company,
		|Partner, 
		|LegalName, 
		|Currency, 
		|DocumentAmount, 
		|BasisDocument, 
		|Agreement, 
		|Amount"; 
	QueryTable_Grupped.GroupBy(FilterByColumns);
	For Each Row In QueryTable_Grupped Do
		NeedWriteOff = Row.DocumentAmount;
		Filter = New Structure(FilterByColumns);
		FillPropertyValues(Filter, Row);
		ArrayOfRows = QueryTable.FindRows(Filter);
		For Each ItemOfArray In ArrayOfRows Do
			If Not ItemOfArray.AmountBalance > 0 Then
				Continue;
			EndIf;
			CanWriteOff = Min(ItemOfArray.AmountBalance, NeedWriteOff);
			NeedWriteOff = NeedWriteOff - CanWriteOff;
			ItemOfArray.AmountBalance = ItemOfArray.AmountBalance - CanWriteOff;
			
			NewRow = QueryTable_Registrations.Add();
			FillPropertyValues(NewRow, Row);
			
			NewRow[DocumentName] = ItemOfArray[DocumentName];
			NewRow.Amount = CanWriteOff;
			If NeedWriteOff = 0 Then
				Break;
			EndIf;
		EndDo;
	EndDo;
	Return QueryTable_Registrations;
EndFunction

Function GetQueryTextAdvanceToSuppliers()
	Return
	"SELECT
	|	QueryTable.Period,
	|	QueryTable.Company,
	|	QueryTable.Partner,
	|	QueryTable.LegalName,
	|	QueryTable.Currency,
	|	QueryTable.DocumentAmount,
	|	QueryTable.BasisDocument,
	|	QueryTable.Agreement
	|INTO tmp
	|FROM
	|	&QueryTable AS QueryTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp2.Period,
	|	tmp2.Company,
	|	tmp2.Partner,
	|	tmp2.LegalName,
	|	tmp2.Currency,
	|	ISNULL(PartnerApTransactions.AmountBalance, 0) + tmp2.DocumentAmount AS DocumentAmount,
	|	tmp2.BasisDocument,
	|	tmp2.Agreement,
	|	PartnerApTransactions.AmountBalance AS AP_Balance
	|INTO tmp2
	|FROM
	|	tmp AS tmp2
	|		LEFT JOIN AccumulationRegister.PartnerApTransactions.Balance(&Period, (Company, BasisDocument, Partner, LegalName,
	|			Agreement, Currency, CurrencyMovementType) IN
	|			(SELECT
	|				tmp.Company,
	|				tmp.BasisDocument,
	|				tmp.Partner,
	|				tmp.LegalName,
	|				tmp.Agreement,
	|				tmp.Currency,
	|				VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|			FROM
	|				tmp AS tmp)) AS PartnerApTransactions
	|		ON PartnerApTransactions.Company = tmp2.Company
	|		AND PartnerApTransactions.BasisDocument = tmp2.BasisDocument
	|		AND PartnerApTransactions.Partner = tmp2.Partner
	|		AND PartnerApTransactions.LegalName = tmp2.LegalName
	|		AND PartnerApTransactions.Agreement = tmp2.Agreement
	|		AND PartnerApTransactions.Currency = tmp2.Currency
	|		AND
	|			PartnerApTransactions.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp2.Period AS Period,
	|	tmp2.Company AS Company,
	|	tmp2.Partner AS Partner,
	|	tmp2.LegalName AS LegalName,
	|	tmp2.Currency AS Currency,
	|	AdvanceToSuppliersBalance.PaymentDocument AS PaymentDocument,
	|	SUM(tmp2.DocumentAmount) AS DocumentAmount,
	|	tmp2.BasisDocument AS BasisDocument,
	|	tmp2.Agreement AS Agreement,
	|	SUM(AdvanceToSuppliersBalance.AmountBalance) AS AmountBalance,
	|	0 AS Amount
	|FROM
	|	AccumulationRegister.AdvanceToSuppliers.Balance(&Period, (Company, Partner, LegalName, Currency,
	|		CurrencyMovementType) IN
	|		(SELECT
	|			tmp.Company,
	|			tmp.Partner,
	|			tmp.LegalName,
	|			tmp.Currency,
	|			VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|		FROM
	|			tmp AS tmp)) AS AdvanceToSuppliersBalance
	|		LEFT JOIN tmp2 AS tmp2
	|		ON AdvanceToSuppliersBalance.Company = tmp2.Company
	|		AND AdvanceToSuppliersBalance.Partner = tmp2.Partner
	|		AND AdvanceToSuppliersBalance.LegalName = tmp2.LegalName
	|		AND AdvanceToSuppliersBalance.Currency = tmp2.Currency
	|		AND
	|			AdvanceToSuppliersBalance.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|GROUP BY
	|	tmp2.Period,
	|	tmp2.Company,
	|	tmp2.Partner,
	|	tmp2.LegalName,
	|	tmp2.Currency,
	|	tmp2.BasisDocument,
	|	tmp2.Agreement,
	|	AdvanceToSuppliersBalance.PaymentDocument
	|ORDER BY
	|	AdvanceToSuppliersBalance.PaymentDocument.Date";
EndFunction

Function GetQueryTextAdvanceFromCustomers()
	Return
	"SELECT
	|	QueryTable.Period,
	|	QueryTable.Company,
	|	QueryTable.Partner,
	|	QueryTable.LegalName,
	|	QueryTable.Currency,
	|	QueryTable.DocumentAmount,
	|	QueryTable.BasisDocument,
	|	QueryTable.Agreement
	|INTO tmp
	|FROM
	|	&QueryTable AS QueryTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp2.Period,
	|	tmp2.Company,
	|	tmp2.Partner,
	|	tmp2.LegalName,
	|	tmp2.Currency,
	|	ISNULL(PartnerArTransactions.AmountBalance, 0) + tmp2.DocumentAmount AS DocumentAmount,
	|	tmp2.BasisDocument,
	|	tmp2.Agreement,
	|	PartnerArTransactions.AmountBalance AS AR_Balance
	|INTO tmp2
	|FROM
	|	tmp AS tmp2
	|		LEFT JOIN AccumulationRegister.PartnerArTransactions.Balance(&Period, (Company, BasisDocument, Partner, LegalName,
	|			Agreement, Currency, CurrencyMovementType) IN
	|			(SELECT
	|				tmp.Company,
	|				tmp.BasisDocument,
	|				tmp.Partner,
	|				tmp.LegalName,
	|				tmp.Agreement,
	|				tmp.Currency,
	|				VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|			FROM
	|				tmp AS tmp)) AS PartnerArTransactions
	|		ON PartnerArTransactions.Company = tmp2.Company
	|		AND PartnerArTransactions.BasisDocument = tmp2.BasisDocument
	|		AND PartnerArTransactions.Partner = tmp2.Partner
	|		AND PartnerArTransactions.LegalName = tmp2.LegalName
	|		AND PartnerArTransactions.Agreement = tmp2.Agreement
	|		AND PartnerArTransactions.Currency = tmp2.Currency
	|		AND
	|			PartnerArTransactions.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp2.Period AS Period,
	|	tmp2.Company AS Company,
	|	tmp2.Partner AS Partner,
	|	tmp2.LegalName AS LegalName,
	|	tmp2.Currency AS Currency,
	|	AdvanceFromCustomersBalance.ReceiptDocument AS ReceiptDocument,
	|	SUM(tmp2.DocumentAmount) AS DocumentAmount,
	|	tmp2.BasisDocument AS BasisDocument,
	|	tmp2.Agreement AS Agreement,
	|	SUM(AdvanceFromCustomersBalance.AmountBalance) AS AmountBalance,
	|	0 AS Amount
	|FROM
	|	AccumulationRegister.AdvanceFromCustomers.Balance(&Period, (Company, Partner, LegalName, Currency,
	|		CurrencyMovementType) IN
	|		(SELECT
	|			tmp.Company,
	|			tmp.Partner,
	|			tmp.LegalName,
	|			tmp.Currency,
	|			VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|		FROM
	|			tmp AS tmp)) AS AdvanceFromCustomersBalance
	|		LEFT JOIN tmp2 AS tmp2
	|		ON AdvanceFromCustomersBalance.Company = tmp2.Company
	|		AND AdvanceFromCustomersBalance.Partner = tmp2.Partner
	|		AND AdvanceFromCustomersBalance.LegalName = tmp2.LegalName
	|		AND AdvanceFromCustomersBalance.Currency = tmp2.Currency
	|		AND
	|			AdvanceFromCustomersBalance.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|GROUP BY
	|	tmp2.Period,
	|	tmp2.Company,
	|	tmp2.Partner,
	|	tmp2.LegalName,
	|	tmp2.Currency,
	|	tmp2.BasisDocument,
	|	tmp2.Agreement,
	|	AdvanceFromCustomersBalance.ReceiptDocument
	|ORDER BY
	|	AdvanceFromCustomersBalance.ReceiptDocument.Date";
EndFunction

Procedure ShowPostingErrorMessage(QueryTable, Parameters, AddInfo = Undefined) Export
	If QueryTable.Columns.Find("Unposting") = Undefined Then
		QueryTable.Columns.Add("Unposting");
		QueryTable.FillValues(False, "Unposting");
	EndIf;

	QueryTableCopy = QueryTable.Copy();
	QueryTableCopy.GroupBy(Parameters.GroupColumns + ", Unposting", Parameters.SumColumns);

	For Each Row In QueryTableCopy Do
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
		If ValueIsFilled(ArrayOfLineNumbers[0]) Then
			LineNumber = ArrayOfLineNumbers[0];

			If Row.Unposting Then
				MessageText = StrTemplate(R().Error_068, LineNumber, Row.Item, Row.ItemKey, Parameters.Operation,
					LackOfBalance, 0, LackOfBalance, BasisUnit);
			Else
				MessageText = StrTemplate(R().Error_068, LineNumber, Row.Item, Row.ItemKey, Parameters.Operation,
					RemainsQuantity, Row.Quantity, LackOfBalance, BasisUnit);
			EndIf;
			CommonFunctionsClientServer.ShowUsersMessage(
			MessageText, "Object.ItemList[" + (LineNumber - 1) + "].Quantity", "Object.ItemList");
			// Delete row
		Else
			MessageText = StrTemplate(R().Error_068, LineNumbers, Row.Item, Row.ItemKey, Parameters.Operation,
				LackOfBalance, 0, LackOfBalance, BasisUnit);
			CommonFunctionsClientServer.ShowUsersMessage(MessageText);
		EndIf;
	EndDo;
EndProcedure

Procedure AddColumnsToAccountsStatementTable(Table) Export
	If Table.Columns.Find("RecordType") = Undefined Then
		Table.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	EndIf;
	If Table.Columns.Find("BasisDocument") = Undefined Then
		Table.Columns.Add("BasisDocument", Metadata.DefinedTypes.typeAccountStatementBasises.Type);
	EndIf;
	If Table.Columns.Find("AdvanceToSuppliers") = Undefined Then
		Table.Columns.Add("AdvanceToSuppliers", Metadata.DefinedTypes.typeAmount.Type);
	EndIf;
	If Table.Columns.Find("AdvanceFromCustomers") = Undefined Then
		Table.Columns.Add("AdvanceFromCustomers", Metadata.DefinedTypes.typeAmount.Type);
	EndIf;
	If Table.Columns.Find("TransactionAR") = Undefined Then
		Table.Columns.Add("TransactionAR", Metadata.DefinedTypes.typeAmount.Type);
	EndIf;
	If Table.Columns.Find("TransactionAP") = Undefined Then
		Table.Columns.Add("TransactionAP", Metadata.DefinedTypes.typeAmount.Type);
	EndIf;
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

Function GetLockFieldsMap(LockFieldNames) Export
	Fields = New Map();
	ArrayOfFieldNames = StrSplit(LockFieldNames, ",");
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
	Query.SetParameter("RecordType", RecordType);
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

Function PrepareRecordsTables(Dimensions, ItemList_InDocument, Records_InDocument, Records_Exists, Unposting, AddInfo = Undefined) Export
	ArrayOfDimensions = StrSplit(Dimensions, ",");
	JoinCondition = "";
	ArrayOfSelectedFields = New Array();
	For Each ItemOfDimension In ArrayOfDimensions Do
		ArrayOfSelectedFields.Add(" " + "Records." + TrimAll(ItemOfDimension));
		JoinCondition = JoinCondition 
		+ StrTemplate(" AND Records.%1 =  Records_with_LineNumbers.%1 ", TrimAll(ItemOfDimension));
	EndDo;
	StrSelectedFields = StrConcat(ArrayOfSelectedFields, ",");
	
	Query = New Query();
	Query.TempTablesManager = New TempTablesManager();
	Query.Text =
	"SELECT %1,
	|	Records.RowKey,
	|	Records.Quantity
	|INTO Records_InDocument
	|FROM
	|	&Records_InDocument AS Records
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList_InDocument.LineNumber,
	|	ItemList_InDocument.RowKey
	|INTO ItemList_InDocument
	|FROM
	|	&ItemList_InDocument AS ItemList_InDocument
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT %1, 
	|	Records.RowKey,
	|	Records.Quantity
	|INTO Records_Exists
	|FROM
	|	&Records_Exists AS Records
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT %1,
	|	Records.RowKey,
	|	Records.Quantity,
	|	ItemList_InDocument.LineNumber
	|INTO Records_with_LineNumbers
	|FROM
	|	Records_InDocument AS Records
	|		LEFT JOIN ItemList_InDocument AS ItemList_InDocument
	|		ON Records.RowKey = ItemList_InDocument.RowKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT %1,
	|	Records.Quantity,
	|	Records.LineNumber,
	|	Records.RowKey
	|INTO ItemList
	|FROM
	|	Records_with_LineNumbers AS Records
	|
	|UNION ALL
	|
	|SELECT %1,
	|	Records.Quantity,
	|	UNDEFINED,
	|	Records.RowKey AS RowKey
	|FROM
	|	Records_Exists AS Records
	|		LEFT JOIN Records_with_LineNumbers AS Records_with_LineNumbers
	|		ON  Records.RowKey = Records_with_LineNumbers.RowKey
	| 		%2
	|WHERE
	|	Records_with_LineNumbers.RowKey IS NULL
	|	AND NOT &Unposting
	|;";
	Query.Text = StrTemplate(Query.Text,StrSelectedFields, JoinCondition);
	
	Query.SetParameter("Records_InDocument"  , Records_InDocument);
	Query.SetParameter("ItemList_InDocument" , ItemList_InDocument);
	Query.SetParameter("Records_Exists"      , Records_Exists);
	Query.SetParameter("Unposting"           , Unposting);
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
