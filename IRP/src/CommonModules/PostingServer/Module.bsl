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

Function GetTable_OffsetOfAdvance_OnTransaction(PointInTime, QueryTableParameter, DocumentName) Export
	Query = New Query();
	If DocumentName = "PaymentDocument" Then
		Query.Text = GetQueryText_OffsetOfAdvanceToSuppliers_OnTransaction();
	ElsIf DocumentName = "ReceiptDocument" Then
		Query.Text = GetQueryText_OffsetOfAdvanceFromCustomers_OnTransaction();
	Else
		Return New ValueTable();
	EndIf;
		
	Query.SetParameter("Period"              , PointInTime);
	Query.SetParameter("QueryTable"          , QueryTableParameter);
	
	QueryResult = Query.Execute();	
	QueryTable = QueryResult.Unload();
	
	QueryTable_OffsetOfAdvance = QueryTable.CopyColumns();
	
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
			
			NewRow = QueryTable_OffsetOfAdvance.Add();
			FillPropertyValues(NewRow, Row);
			
			NewRow[DocumentName] = ItemOfArray[DocumentName];
			NewRow.Amount = CanWriteOff;
			If NeedWriteOff = 0 Then
				Break;
			EndIf;
		EndDo;
	EndDo;
	Return QueryTable_OffsetOfAdvance;
EndFunction

Function GetTable_OffsetOfAdvance_OnAdvance(PointInTime, TableOfAdvances, TableOfTransactions, DocumentName) Export
	Query = New Query();
	If DocumentName = "PaymentDocument" Then
		Query.Text = GetQueryText_OffsetOfAdvanceToSuppliers_OnAdvance();
	ElsIf DocumentName = "ReceiptDocument" Then
		Query.Text = GetQueryText_OffsetOfAdvanceFromCustomers_OnAdvance();
	Else
		Return New ValueTable();
	EndIf;
	
	TableOfAdvances.GroupBy("Period, Company, Partner, LegalName, Currency, Key," + DocumentName, "Amount"); 
	
	Query.SetParameter("Period"      , PointInTime);
	Query.SetParameter("QueryTable"  , TableOfAdvances);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	FilterByColumns = "Company,
		|Partner,
		|Agreement,
		|LegalName,
		|Currency,
		|Basisdocument";
	For Each Row In TableOfTransactions Do
		Filter = New Structure(FilterByColumns);
		FillPropertyValues(Filter, Row);
		ArrayOfRows = QueryTable.FindRows(Filter);
		For Each ItemOfArray In ArrayOfRows Do
			If ItemOfArray.AmountBalance < Row.Amount Then
				ItemOfArray.AmountBalance = 0;
			Else
				ItemOfArray.AmountBalance = ItemOfArray.AmountBalance - Row.Amount;
			EndIf;
		EndDo;
	EndDo;
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	QueryTable.Period,
	|	QueryTable.Company,
	|	QueryTable.Partner,
	|	QueryTable.LegalName,
	|	QueryTable.Currency,
	|	QueryTable." + DocumentName + ",
	|	QueryTable.Key,
	|	QueryTable.DocumentAmount,
	|	QueryTable.BasisDocument,
	|	QueryTable.Agreement,
	|	QueryTable.AmountBalance,
	|	QueryTable.Amount
	|INTO tmp
	|FROM
	|	&QueryTable AS QueryTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Period,
	|	tmp.Company,
	|	tmp.Partner,
	|	tmp.LegalName,
	|	tmp.Currency,
	|	tmp." + DocumentName + ",
	|	tmp.Key,
	|	tmp.DocumentAmount,
	|	tmp.BasisDocument,
	|	tmp.Agreement,
	|	tmp.AmountBalance AS AmountBalance,
	|	ISNULL(AgingBalance.AmountBalance,0) AS AgingAmountBalance,
	|	CASE
	|		WHEN tmp.BasisDocument.Date IS NULL
	|			THEN DATETIME(1, 1, 1)
	|		ELSE ISNULL(AgingBalance.PaymentDate, tmp.BasisDocument.Date)
	|	END AS PriorityDate,
	|	tmp.Amount
	|FROM
	|	tmp AS tmp
	|		LEFT JOIN AccumulationRegister.Aging.Balance(&Period, (Company, Partner, Agreement, Invoice, Currency) IN
	|			(SELECT
	|				tmp.Company,
	|				tmp.Partner,
	|				tmp.Agreement,
	|				tmp.BasisDocument,
	|				tmp.Currency
	|			FROM
	|				tmp AS tmp)) AS AgingBalance
	|		ON tmp.Company = AgingBalance.Company
	|		AND tmp.Partner = AgingBalance.Partner
	|		AND tmp.Agreement = AgingBalance.Agreement
	|		AND tmp.BasisDocument = AgingBalance.Invoice
	|		AND tmp.Currency = tmp.Currency
	|ORDER BY
	|	PriorityDate";
	Query.SetParameter("Period"      , PointInTime);
	Query.SetParameter("QueryTable"  , QueryTable);
	
	QueryResult = Query.Execute();
	QueryTable_Aging = QueryResult.Unload();
	
	FilterByColumns = "Period,
		|Company,
		|Partner,
		|LegalName,
		|Currency,
		|" + DocumentName + ",
		|DocumentAmount,
		|BasisDocument,
		|Agreement,
		|AmountBalance,
		|Amount";
	
	For Each Row In QueryTable Do
		NeedWriteOff = Row.AmountBalance;
		If NeedWriteOff = 0 Then
			Continue;
		EndIf;
		Filter = New Structure(FilterByColumns);
		FillPropertyValues(Filter, Row);
		ArrayOfRows = QueryTable_Aging.FindRows(Filter);
		For Each ItemOfArray In ArrayOfRows Do
			If Not ItemOfArray.AgingAmountBalance > 0 Then
				Continue;
			EndIf;
			CanWriteOff = Min(ItemOfArray.AgingAmountBalance, NeedWriteOff);
			NeedWriteOff = NeedWriteOff - CanWriteOff;
			ItemOfArray.AgingAmountBalance = ItemOfArray.AgingAmountBalance - CanWriteOff;
			ItemOfArray.AmountBalance = CanWriteOff;
			If NeedWriteOff = 0 Then
				Break;
			EndIf;
		EndDo;
	EndDo;
	
	QueryTable_OffsetOfAdvance = QueryTable_Aging.CopyColumns();
	QueryTable_Grupped = QueryTable_Aging.Copy();
	
	FilterByColumns = "Period, 
		|Company,
		|Partner, 
		|LegalName, 
		|Currency, 
		|DocumentAmount, 
		|" + DocumentName + ", 
		|Key,
		|Amount"; 
	QueryTable_Grupped.GroupBy(FilterByColumns);
	For Each Row In QueryTable_Grupped Do
		NeedWriteOff = Row.DocumentAmount;
		If NeedWriteOff = 0 Then
			Continue;
		EndIf;
		Filter = New Structure(FilterByColumns);
		FillPropertyValues(Filter, Row);
		ArrayOfRows = QueryTable_Aging.FindRows(Filter);
		
		For Each ItemOfArray In ArrayOfRows Do
			If Not ItemOfArray.AmountBalance > 0 Then
				Continue;
			EndIf;
			CanWriteOff = Min(ItemOfArray.AmountBalance, NeedWriteOff);
			NeedWriteOff = NeedWriteOff - CanWriteOff;
			ItemOfArray.AmountBalance = ItemOfArray.AmountBalance - CanWriteOff;
			
			NewRow = QueryTable_OffsetOfAdvance.Add();
			FillPropertyValues(NewRow, Row);
			
			NewRow[DocumentName] = ItemOfArray[DocumentName];
			NewRow.Amount        = CanWriteOff;
			NewRow.Agreement     = ItemOfArray.Agreement;
			NewRow.BasisDocument = ItemOfArray.BasisDocument;
			If NeedWriteOff = 0 Then
				Break;
			EndIf;
		EndDo;
	EndDo;
	Return QueryTable_OffsetOfAdvance;
EndFunction

Function GetQueryText_OffsetOfAdvanceToSuppliers_OnAdvance()
	Return
	"SELECT
	|	AdvanceToSuppliers.Period,
	|	AdvanceToSuppliers.Company,
	|	AdvanceToSuppliers.Partner,
	|	AdvanceToSuppliers.LegalName,
	|	AdvanceToSuppliers.Currency,
	|	AdvanceToSuppliers.Amount AS DocumentAmount,
	|	AdvanceToSuppliers.PaymentDocument,
	|	AdvanceToSuppliers.Key
	|INTO AdvanceToSuppliers
	|FROM
	|	&QueryTable AS AdvanceToSuppliers
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AdvanceToSuppliers.Period,
	|	AdvanceToSuppliers.Company,
	|	AdvanceToSuppliers.Partner,
	|	AdvanceToSuppliers.LegalName,
	|	AdvanceToSuppliers.Currency,
	|	AdvanceToSuppliers.PaymentDocument,
	|	AdvanceToSuppliers.Key,
	|	SUM(AdvanceToSuppliers.DocumentAmount) AS DocumentAmount,
	|	PartnerApTransactionsBalance.BasisDocument,
	|	PartnerApTransactionsBalance.Agreement,
	|	SUM(PartnerApTransactionsBalance.AmountBalance) AS AmountBalance,
	|	0 AS Amount
	|FROM
	|	AccumulationRegister.PartnerApTransactions.Balance(&Period, (Company, Partner, LegalName, Currency,
	|		CurrencyMovementType) IN
	|		(SELECT
	|			AdvanceToSuppliers.Company,
	|			AdvanceToSuppliers.Partner,
	|			AdvanceToSuppliers.LegalName,
	|			AdvanceToSuppliers.Currency,
	|			VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|		FROM
	|			AdvanceToSuppliers AS AdvanceToSuppliers)) AS PartnerApTransactionsBalance
	|		INNER JOIN AdvanceToSuppliers AS AdvanceToSuppliers
	|		ON AdvanceToSuppliers.Company = PartnerApTransactionsBalance.Company
	|		AND AdvanceToSuppliers.Partner = PartnerApTransactionsBalance.Partner
	|		AND AdvanceToSuppliers.LegalName = PartnerApTransactionsBalance.LegalName
	|		AND AdvanceToSuppliers.Currency = PartnerApTransactionsBalance.Currency
	|GROUP BY
	|	AdvanceToSuppliers.Period,
	|	AdvanceToSuppliers.Company,
	|	AdvanceToSuppliers.Partner,
	|	AdvanceToSuppliers.LegalName,
	|	AdvanceToSuppliers.Currency,
	|	AdvanceToSuppliers.PaymentDocument,
	|	AdvanceToSuppliers.Key,
	|	PartnerApTransactionsBalance.BasisDocument,
	|	PartnerApTransactionsBalance.Agreement
	|ORDER BY
	|	AdvanceToSuppliers.Period,
	|	PartnerApTransactionsBalance.BasisDocument.Date";
EndFunction

Function GetQueryText_OffsetOfAdvanceFromCustomers_OnAdvance()
	Return
	"SELECT
	|	AdvanceFromCustomers.Period,
	|	AdvanceFromCustomers.Company,
	|	AdvanceFromCustomers.Partner,
	|	AdvanceFromCustomers.LegalName,
	|	AdvanceFromCustomers.Currency,
	|	AdvanceFromCustomers.Amount AS DocumentAmount,
	|	AdvanceFromCustomers.ReceiptDocument,
	|	AdvanceFromCustomers.Key
	|INTO AdvanceFromCustomers
	|FROM
	|	&QueryTable AS AdvanceFromCustomers
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AdvanceFromCustomers.Period,
	|	AdvanceFromCustomers.Company,
	|	AdvanceFromCustomers.Partner,
	|	AdvanceFromCustomers.LegalName,
	|	AdvanceFromCustomers.Currency,
	|	AdvanceFromCustomers.ReceiptDocument,
	|	AdvanceFromCustomers.Key,
	|	SUM(AdvanceFromCustomers.DocumentAmount) AS DocumentAmount,
	|	PartnerArTransactionsBalance.BasisDocument,
	|	PartnerArTransactionsBalance.Agreement,
	|	SUM(PartnerArTransactionsBalance.AmountBalance) AS AmountBalance,
	|	0 AS Amount
	|FROM
	|	AccumulationRegister.PartnerArTransactions.Balance(&Period, (Company, Partner, LegalName, Currency,
	|		CurrencyMovementType) IN
	|		(SELECT
	|			AdvanceFromCustomers.Company,
	|			AdvanceFromCustomers.Partner,
	|			AdvanceFromCustomers.LegalName,
	|			AdvanceFromCustomers.Currency,
	|			VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|		FROM
	|			AdvanceFromCustomers AS AdvanceFromCustomers)) AS PartnerArTransactionsBalance
	|		INNER JOIN AdvanceFromCustomers AS AdvanceFromCustomers
	|		ON AdvanceFromCustomers.Company = PartnerArTransactionsBalance.Company
	|		AND AdvanceFromCustomers.Partner = PartnerArTransactionsBalance.Partner
	|		AND AdvanceFromCustomers.LegalName = PartnerArTransactionsBalance.LegalName
	|		AND AdvanceFromCustomers.Currency = PartnerArTransactionsBalance.Currency
	|GROUP BY
	|	AdvanceFromCustomers.Period,
	|	AdvanceFromCustomers.Company,
	|	AdvanceFromCustomers.Partner,
	|	AdvanceFromCustomers.LegalName,
	|	AdvanceFromCustomers.Currency,
	|	AdvanceFromCustomers.ReceiptDocument,
	|	AdvanceFromCustomers.Key,
	|	PartnerArTransactionsBalance.BasisDocument,
	|	PartnerArTransactionsBalance.Agreement
	|ORDER BY
	|	AdvanceFromCustomers.Period,
	|	PartnerArTransactionsBalance.BasisDocument.Date";
EndFunction

Function GetQueryText_OffsetOfAdvanceToSuppliers_OnTransaction()
	Return
	"SELECT
	|	TransactionsAP.Period,
	|	TransactionsAP.Company,
	|	TransactionsAP.Partner,
	|	TransactionsAP.LegalName,
	|	TransactionsAP.Currency,
	|	TransactionsAP.DocumentAmount,
	|	TransactionsAP.BasisDocument,
	|	TransactionsAP.Agreement
	|INTO TransactionsAP
	|FROM
	|	&QueryTable AS TransactionsAP
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TransactionsAP.Period,
	|	TransactionsAP.Company,
	|	TransactionsAP.Partner,
	|	TransactionsAP.LegalName,
	|	TransactionsAP.Currency,
	|	AdvanceToSuppliersBalance.PaymentDocument,
	|	SUM(TransactionsAP.DocumentAmount) AS DocumentAmount,
	|	TransactionsAP.BasisDocument,
	|	TransactionsAP.Agreement,
	|	SUM(AdvanceToSuppliersBalance.AmountBalance) AS AmountBalance,
	|	0 AS Amount
	|FROM
	|	AccumulationRegister.AdvanceToSuppliers.Balance(&Period, (Company, Partner, LegalName, Currency,
	|		CurrencyMovementType) IN
	|		(SELECT
	|			TransactionsAP.Company,
	|			TransactionsAP.Partner,
	|			TransactionsAP.LegalName,
	|			TransactionsAP.Currency,
	|			VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|		FROM
	|			TransactionsAP AS TransactionsAP)) AS AdvanceToSuppliersBalance
	|		LEFT JOIN TransactionsAP AS TransactionsAP
	|		ON AdvanceToSuppliersBalance.Company = TransactionsAP.Company
	|		AND AdvanceToSuppliersBalance.Partner = TransactionsAP.Partner
	|		AND AdvanceToSuppliersBalance.LegalName = TransactionsAP.LegalName
	|		AND AdvanceToSuppliersBalance.Currency = TransactionsAP.Currency
	|		AND
	|			AdvanceToSuppliersBalance.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|GROUP BY
	|	TransactionsAP.Period,
	|	TransactionsAP.Company,
	|	TransactionsAP.Partner,
	|	TransactionsAP.LegalName,
	|	TransactionsAP.Currency,
	|	TransactionsAP.BasisDocument,
	|	TransactionsAP.Agreement,
	|	AdvanceToSuppliersBalance.PaymentDocument
	|ORDER BY
	|	AdvanceToSuppliersBalance.PaymentDocument.Date,
	|	TransactionsAP.Period";
EndFunction

Function GetQueryText_OffsetOfAdvanceFromCustomers_OnTransaction()
	Return
	"SELECT
	|	TransactionsAR.Period,
	|	TransactionsAR.Company,
	|	TransactionsAR.Partner,
	|	TransactionsAR.LegalName,
	|	TransactionsAR.Currency,
	|	TransactionsAR.DocumentAmount,
	|	TransactionsAR.BasisDocument,
	|	TransactionsAR.Agreement
	|INTO TransactionsAR
	|FROM
	|	&QueryTable AS TransactionsAR
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TransactionsAR.Period,
	|	TransactionsAR.Company,
	|	TransactionsAR.Partner,
	|	TransactionsAR.LegalName,
	|	TransactionsAR.Currency,
	|	AdvanceFromCustomersBalance.ReceiptDocument,
	|	SUM(TransactionsAR.DocumentAmount) AS DocumentAmount,
	|	TransactionsAR.BasisDocument,
	|	TransactionsAR.Agreement,
	|	SUM(AdvanceFromCustomersBalance.AmountBalance) AS AmountBalance,
	|	0 AS Amount
	|FROM
	|	AccumulationRegister.AdvanceFromCustomers.Balance(&Period, (Company, Partner, LegalName, Currency,
	|		CurrencyMovementType) IN
	|		(SELECT
	|			TransactionsAR.Company,
	|			TransactionsAR.Partner,
	|			TransactionsAR.LegalName,
	|			TransactionsAR.Currency,
	|			VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|		FROM
	|			TransactionsAR AS TransactionsAR)) AS AdvanceFromCustomersBalance
	|		LEFT JOIN TransactionsAR AS TransactionsAR
	|		ON AdvanceFromCustomersBalance.Company = TransactionsAR.Company
	|		AND AdvanceFromCustomersBalance.Partner = TransactionsAR.Partner
	|		AND AdvanceFromCustomersBalance.LegalName = TransactionsAR.LegalName
	|		AND AdvanceFromCustomersBalance.Currency = TransactionsAR.Currency
	|		AND
	|			AdvanceFromCustomersBalance.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|GROUP BY
	|	TransactionsAR.Period,
	|	TransactionsAR.Company,
	|	TransactionsAR.Partner,
	|	TransactionsAR.LegalName,
	|	TransactionsAR.Currency,
	|	TransactionsAR.BasisDocument,
	|	TransactionsAR.Agreement,
	|	AdvanceFromCustomersBalance.ReceiptDocument
	|ORDER BY
	|	AdvanceFromCustomersBalance.ReceiptDocument.Date,
	|	TransactionsAR.Period";
EndFunction

Function OffsetOfAdvanceByVendorAgreement(PartnerArTransactions_OffsetOfAdvance) Export
	For Each Row In PartnerArTransactions_OffsetOfAdvance Do
		If Row.Agreement.Type = Enums.AgreementTypes.Vendor Then
			Return True;
		EndIf;
	EndDo;
	Return False;
EndFunction

Function OffsetOfAdvanceByCustomerAgreement(PartnerApTransactions_OffsetOfAdvance) Export
	For Each Row In PartnerApTransactions_OffsetOfAdvance Do
		If Row.Agreement.Type = Enums.AgreementTypes.Customer Then
			Return True;
		EndIf;
	EndDo;
	Return False;
EndFunction

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
			MessageText, TableDataPath + "[" + (LineNumber - 1) + "].Quantity", "Object.ItemList");
			// Delete row
		Else
			If ValueIsFilled(ErrorQuantityField) Then
				If Row.Unposting Then
					MessageText = StrTemplate(R().Error_090, Row.Item, Row.ItemKey, Parameters.Operation,
						LackOfBalance, 0, LackOfBalance, BasisUnit);
				Else
					MessageText = StrTemplate(R().Error_090, Row.Item, Row.ItemKey, Parameters.Operation,
						RemainsQuantity, Row.Quantity, LackOfBalance, BasisUnit);
				EndIf;
				CommonFunctionsClientServer.ShowUsersMessage(
				MessageText, ErrorQuantityField);
			Else	
				MessageText = StrTemplate(R().Error_068, LineNumbers, Row.Item, Row.ItemKey, Parameters.Operation,
					LackOfBalance, 0, LackOfBalance, BasisUnit);
				CommonFunctionsClientServer.ShowUsersMessage(MessageText);
			EndIf;			
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

Function GetLineNumberAndItemKeyFromItemList(Ref, FullTableName) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ItemList.ItemKey AS ItemKey,
	|	ItemList.LineNumber AS LineNumber
	|FROM
	|	%1 AS ItemList
	|WHERE
	|	ItemList.Ref = &Ref";
	Query.Text = StrTemplate(Query.Text, FullTableName);
	Query.SetParameter("Ref", Ref);
	QueryResult = Query.Execute();
	ItemList_InDocument = QueryResult.Unload();
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

Procedure CheckBalance_AfterWrite(Ref, Cancel, Parameters, TableNameWithItemKeys, AddInfo = Undefined) Export
	Unposting = ?(Parameters.Property("Unposting"), Parameters.Unposting, False);
	AccReg = AccumulationRegisters;
	
	RecordType = AccumulationRecordType.Receipt;
	If Parameters.Property("RecordType") Then
		RecordType = Parameters.RecordType;
	EndIf;
	
	LineNumberAndItemKeyFromItemList = GetLineNumberAndItemKeyFromItemList(Ref, TableNameWithItemKeys);
	If Parameters.DocumentDataTables.Property("StockReservation_Exists") Then
		Records_InDocument = Undefined;
		If Unposting Then
			Records_InDocument = Parameters.Object.RegisterRecords.StockReservation.Unload();
		Else
			PostingDataTable = Parameters.PostingDataTables[Parameters.Object.RegisterRecords.StockReservation];
			If PostingDataTable <> Undefined Then
				Records_InDocument = PostingDataTable.RecordSet;
			EndIf;
		EndIf;	
			
		If Records_InDocument <> Undefined 
			And TypeOf(Records_InDocument) = Type("ValueTable") 
			And Not Records_InDocument.Columns.Count() Then
				Records_InDocument = PostingServer.CreateTable(Metadata.AccumulationRegisters.StockReservation);
		EndIf;
		
		If Not Cancel And Records_InDocument <> Undefined 
			And Not AccReg.StockReservation.CheckBalance(Ref, LineNumberAndItemKeyFromItemList, 
			Records_InDocument, 
			Parameters.DocumentDataTables.StockReservation_Exists, 
			RecordType, Unposting, AddInfo) Then
			Cancel = True;
		EndIf;
	EndIf;
	
	If Parameters.DocumentDataTables.Property("StockBalance_Exists") Then
		Records_InDocument = Undefined;
		If Unposting Then
			Records_InDocument = Parameters.Object.RegisterRecords.StockBalance.Unload();
		Else
			PostingDataTable = Parameters.PostingDataTables[Parameters.Object.RegisterRecords.StockBalance];
			If PostingDataTable <> Undefined Then
				Records_InDocument = PostingDataTable.RecordSet;
			EndIf;
		EndIf;
		
		If Records_InDocument <> Undefined 
			And TypeOf(Records_InDocument) = Type("ValueTable") 
			And Not Records_InDocument.Columns.Count() Then
				Records_InDocument = PostingServer.CreateTable(Metadata.AccumulationRegisters.StockBalance);
		EndIf;
		
		If Not Cancel And Records_InDocument <> Undefined
			And Not AccReg.StockBalance.CheckBalance(Ref, LineNumberAndItemKeyFromItemList, 
			Records_InDocument, 
			Parameters.DocumentDataTables.StockBalance_Exists, 
			RecordType, Unposting, AddInfo) Then
			Cancel = True;
		EndIf;
	EndIf;
EndProcedure

Function CheckBalance_StockReservation(Ref, Tables, RecordType, Unposting, AddInfo = Undefined) Export
	Parameters = New Structure();
	Parameters.Insert("RegisterName" , "StockReservation");
	Parameters.Insert("Operation"    , "Reservation");
	Return CheckBalance(Ref, Parameters, Tables, RecordType, Unposting, AddInfo);	
EndFunction	

Function CheckBalance_StockBalance(Ref, Tables, RecordType, Unposting, AddInfo = Undefined) Export
	Parameters = New Structure();
	Parameters.Insert("RegisterName" , "StockBalance");
	Parameters.Insert("Operation"    , "Write off");
	Return CheckBalance(Ref, Parameters, Tables, RecordType, Unposting, AddInfo);
EndFunction	

Function CheckBalance(Ref, Parameters, Tables, RecordType, Unposting, AddInfo = Undefined)
	BalancePeriod = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "BalancePeriod");
	If Not ValueIsFilled(BalancePeriod) Then
		BalancePeriod = New Boundary(Ref.PointInTime(), BoundaryType.Including);
	EndIf;
	Parameters.Insert("BalancePeriod", BalancePeriod);
	If CheckBalance_ExecuteQuery(Ref, Parameters, Tables, RecordType, Unposting, AddInfo) Then
		Parameters.BalancePeriod = Undefined;
		Return CheckBalance_ExecuteQuery(Ref, Parameters, Tables, RecordType, Unposting, AddInfo);
	EndIf;
	Return False;
EndFunction

Function CheckBalance_ExecuteQuery(Ref, Parameters, Tables, RecordType, Unposting, AddInfo = Undefined)
	Query = New Query();
	Query.Text =
	"SELECT
	|	ItemList.ItemKey,
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
	|	Records_Exists.Quantity
	|INTO Records_All
	|FROM
	|	Records_Exists AS Records_Exists
	|		LEFT JOIN Records_InDocument AS Records_InDocument
	|		ON Records_Exists.Store = Records_InDocument.Store
	|		AND Records_Exists.ItemKey = Records_InDocument.ItemKey
	|WHERE
	|	Records_InDocument.ItemKey IS NULL
	|	AND NOT &Unposting
	|
	|UNION ALL
	|
	|SELECT
	|	Records_InDocument.Store,
	|	Records_InDocument.ItemKey,
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
	|	SUM(Records_All.Quantity) AS Quantity
	|INTO Records_All_Grouped
	|FROM
	|	Records_All AS Records_All
	|GROUP BY
	|	Records_All.Store,
	|	Records_All.ItemKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Records_All_Grouped.ItemKey.Item AS Item,
	|	Records_All_Grouped.ItemKey,
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
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Lack.Item,
	|	Lack.ItemKey,
	|	Lack.QuantityBalance,
	|	Lack.Quantity,
	|	Lack.LackOfBalance,
	|	Lack.Unposting,
	|	MIN(ItemList.LineNumber) AS LineNumber
	|FROM
	|	Lack AS Lack
	|		LEFT JOIN ItemList AS ItemList
	|		ON Lack.ItemKey = ItemList.ItemKey
	|GROUP BY
	|	Lack.Item,
	|	Lack.ItemKey,
	|	Lack.QuantityBalance,
	|	Lack.Quantity,
	|	Lack.LackOfBalance,
	|	Lack.Unposting";
	
	Query.Text = StrTemplate(Query.Text, Parameters.RegisterName);
	
	Query.SetParameter("Period"             , Parameters.BalancePeriod);
	Query.SetParameter("ItemList_InDocument", Tables.ItemList_InDocument);
	Query.SetParameter("Records_Exists"     , Tables.Records_Exists);
	Query.SetParameter("Records_InDocument" , Tables.Records_InDocument);
	Query.SetParameter("Unposting"          , Unposting);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();	
	
	Error = False;
	If QueryTable.Count() Then
		Error = True;
		ErrorParameters = New Structure();
		ErrorParameters.Insert("GroupColumns"  , "ItemKey, Item, LackOfBalance");
		ErrorParameters.Insert("SumColumns"    , "Quantity");
		ErrorParameters.Insert("FilterColumns" , "ItemKey, Item, LackOfBalance");
		ErrorParameters.Insert("Operation"     , Parameters.Operation);
		ErrorParameters.Insert("RecordType"    , RecordType);
		
		TableDataPath = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "TableDataPath");
		If ValueIsFilled(TableDataPath) Then
			ErrorParameters.Insert("TableDataPath" , TableDataPath);
		EndIf;
		
		ErrorQuantityField = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ErrorQuantityField");
		If ValueIsFilled(ErrorQuantityField) Then
			ErrorParameters.Insert("ErrorQuantityField" , ErrorQuantityField);
		EndIf;
	
		ShowPostingErrorMessage(QueryTable, ErrorParameters, AddInfo);
	EndIf;
	Return Not Error;
EndFunction
