Function Post(DocObject, Cancel, PostingMode, AddInfo = Undefined) Export
	
	If Cancel Then
		Return Undefined;
	EndIf;
	
	Parameters = New Structure();
	Parameters.Insert("Object", DocObject);
	Parameters.Insert("IsReposting", False);
	Parameters.Insert("PointInTime", DocObject.PointInTime());
	
	Module = Documents[DocObject.Ref.Metadata().Name];
	
	DocumentDataTables = Module.PostingGetDocumentDataTables(DocObject.Ref, Cancel, PostingMode, Parameters, AddInfo);
	Parameters.Insert("DocumentDataTables", DocumentDataTables);
	If Cancel Then
		Return Undefined;
	EndIf;
	
	LockDataSources = Module.PostingGetLockDataSource(DocObject.Ref, Cancel, PostingMode, Parameters, AddInfo);
	Parameters.Insert("LockDataSources", LockDataSources);
	If Cancel Then
		Return Undefined;
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
		Return Undefined;
	EndIf;
	
	PostingDataTables = Module.PostingGetPostingDataTables(DocObject.Ref, Cancel, PostingMode, Parameters, AddInfo);
	Parameters.Insert("PostingDataTables", PostingDataTables);
	If Cancel Then
		Return Undefined;
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
		FixRowKey(RegisterMetadata, RecordInfo, RecordsForExpense, DocObject);
	EndDo;
	
	// Multi currency integration
	CurrenciesServer.PreparePostingDataTables(Parameters, Undefined, AddInfo);

	RegisteredRecords = RegisterRecords(DocObject, PostingDataTables, Parameters.Object.RegisterRecords);
	Parameters.Insert("RegisteredRecords", RegisteredRecords);
	
	Module.PostingCheckAfterWrite(DocObject.Ref, Cancel, PostingMode, Parameters, AddInfo);
	
EndFunction

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

Function GetCurrentRecords(Recorder, RegisterMetadata) Export
	ArrayOfDimensions = New Array();
	For Each Dimension In RegisterMetadata.Dimensions Do
		ArrayOfDimensions.Add("t." + Dimension.Name);
	EndDo;
	StringOfDimensions = StrConcat(ArrayOfDimensions, ",");
	
	Query = New Query();
	Query.Text =
		StrTemplate("select %1 from %2 as t where t.Recorder = &Recorder group by %1",
			StringOfDimensions, RegisterMetadata.FullName());
	
	Query.SetParameter("Recorder", Recorder);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

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

Procedure FixRowKey(RegisterMetadata, RecordInfo, RecordsForExpense, DocObject)
	
	// explicit type cast
	If RecordInfo.RecordSet.Columns.RowKey.ValueType <> RegisterMetadata.Dimensions.RowKey.Type Then
		RecordInfo.RecordSet.Columns.RowKey.Name = "_RowKey";
		RecordInfo.RecordSet.Columns.Add("RowKey", RegisterMetadata.Dimensions.RowKey.Type);
		For Each Row In RecordInfo.RecordSet Do
			Row.RowKey = Row._RowKey;
		EndDo;
	EndIf;
	
	ArrayOfDimensions = New Array();
	For Each Dimension In RegisterMetadata.Dimensions Do
		If Upper(Dimension.Name) = Upper("RowKey") Then
			Continue;
		EndIf;
		ArrayOfDimensions.Add(Dimension.Name);
	EndDo;
	Dimensions = StrConcat(ArrayOfDimensions, ", ");
		
	Query = New Query();
	Query.Text = 
	"SELECT " + Dimensions + "
	|INTO tmp
	|FROM
	|	&RecordsForExpense AS tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT " + Dimensions + ",
	|RowKey, 
	|QuantityBalance AS Quantity
	|FROM
	|	AccumulationRegister." + RegisterMetadata.Name + ".Balance(&Period, (" + Dimensions + ") IN
	|		(SELECT " + Dimensions + "
	|		FROM
	|			tmp AS tmp)) AS RegisterBalance";
	Query.SetParameter("Period", New Boundary(DocObject.PointInTime(), BoundaryType.Excluding));
	Query.SetParameter("RecordsForExpense", RecordsForExpense);
	QueryResult = Query.Execute();
	BalanceTable = QueryResult.Unload();
		
	RecordSet_Expense = RecordInfo.RecordSet.CopyColumns();
	RecordSet_Receipt = RecordInfo.RecordSet.CopyColumns();
	For Each Row In RecordsForExpense Do
		Filter = New Structure(Dimensions);
		FillPropertyValues(Filter, Row);
		ArrayOfBalanceRows = BalanceTable.FindRows(Filter);
		For Each ItemOfBalance In ArrayOfBalanceRows Do
			If Row.Quantity = 0 Then
				Break;
			EndIf;

			If ItemOfBalance.Quantity = 0 Then
				Continue;
			EndIf;
				
			If Row.Quantity > 0 Then
				Quantity = Min(Row.Quantity, ItemOfBalance.Quantity);
				Row.Quantity = Row.Quantity - Quantity;
				ItemOfBalance.Quantity = ItemOfBalance.Quantity - Quantity;
			// Storno records
			Else
				Quantity = Max(Row.Quantity, ItemOfBalance.Quantity);
				Row.Quantity = Row.Quantity + Quantity;
				ItemOfBalance.Quantity = ItemOfBalance.Quantity + Quantity;
			EndIf;
				
				// Expense
				NewRecord_Expense = RecordSet_Expense.Add();
				FillPropertyValues(NewRecord_Expense, ItemOfBalance);
				NewRecord_Expense.Period = Row.Period;
				NewRecord_Expense.RowKey = ItemOfBalance.RowKey;
				NewRecord_Expense.RecordType = AccumulationRecordType.Expense;
				NewRecord_Expense.Quantity = Quantity;
				
				// Receipt
				NewRecord_Receipt = RecordSet_Receipt.Add();
				FillPropertyValues(NewRecord_Receipt, ItemOfBalance);
				NewRecord_Receipt.Period = Row.Period;
				NewRecord_Receipt.RowKey = Row.RowKey;
				NewRecord_Receipt.RecordType = AccumulationRecordType.Receipt;
				NewRecord_Receipt.Quantity = Quantity;
		EndDo;
	EndDo;
		
	Query = New Query();
	Query.Text = 
	"SELECT " + Dimensions + ",
	|	RowKey, - Quantity AS Quantity
	|INTO tmp_expense
	|FROM
	|	&RecordSet_Expense AS tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT " + Dimensions + ",
	|	RowKey, Quantity AS Quantity
	|INTO tmp_receipt
	|FROM
	|	&RecordSet_Receipt AS tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT " + Dimensions + ",
	|	RowKey, SUM(Quantity) AS Quantity
	|INTO tmp_expense_grouped
	|FROM
	|	tmp_expense AS tmp_expense
	|GROUP BY " + Dimensions + ",
	|	RowKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT " + Dimensions + ",
	|	RowKey, SUM(Quantity) AS Quantity
	|INTO tmp_receipt_grouped
	|FROM
	|	tmp_receipt AS tmp_receipt
	|GROUP BY " + Dimensions + ",
	|	RowKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT " + Dimensions + ",
	|	RowKey, Quantity
	|
	|INTO tmp
	|FROM
	|	tmp_expense_grouped AS tmp_expense_grouped
	|
	|UNION ALL
	|
	|SELECT " + Dimensions + ",
	|	RowKey, Quantity
	|FROM
	|	tmp_receipt_grouped AS tmp_receipt_grouped
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT " + Dimensions + ",
	|	RowKey, SUM(Quantity) AS Quantity
	|FROM
	|	tmp AS tmp
	|GROUP BY " + Dimensions + ",
	|	RowKey
	|HAVING
	|	SUM(Quantity) = 0";
	
	Query.SetParameter("RecordSet_Expense", RecordSet_Expense);
	Query.SetParameter("RecordSet_Receipt", RecordSet_Receipt);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	For Each Row In QueryTable Do
		Filter = New Structure(Dimensions + ", RowKey");
		FillPropertyValues(Filter, Row);
		ArrayForDelete = RecordSet_Expense.FindRows(Filter);
		For Each ItemForDelete In ArrayForDelete Do
			RecordSet_Expense.Delete(ItemForDelete);
		EndDo;
		ArrayForDelete = RecordSet_Receipt.FindRows(Filter);
		For Each ItemForDelete In ArrayForDelete Do
			RecordSet_Receipt.Delete(ItemForDelete);
		EndDo;
	EndDo;
	
	For Each Row In RecordSet_Expense Do
		FillPropertyValues(RecordInfo.RecordSet.Add(), Row);
	EndDo;
	For Each Row In RecordSet_Receipt Do
		FillPropertyValues(RecordInfo.RecordSet.Add(), Row);
	EndDo;
EndProcedure

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
		
		RemainsQuantity = ?(Parameters.Excess, Row.BasisQuantity + Row.LackOfBalance, Row.BasisQuantity - Row.LackOfBalance);
		If ArrayOfLineNumbers.Count() = 1 Then
			If ValueIsFilled(ArrayOfLineNumbers[0]) Then
				LineNumber = ArrayOfLineNumbers[0];
				
				If Row.Unposting Then
					MessageText =
					StrTemplate(R().Error_068, LineNumber, Row.Item, Row.ItemKey, Parameters.Operation,
						Row.LackOfBalance,
						0,
						Row.LackOfBalance,
						Row.BasisUnit);
				Else
					MessageText =
					StrTemplate(R().Error_068, LineNumber, Row.Item, Row.ItemKey, Parameters.Operation,
						RemainsQuantity,
						Row.BasisQuantity,
						Row.LackOfBalance,
						Row.BasisUnit);
				EndIf;
				CommonFunctionsClientServer.ShowUsersMessage(MessageText
					, "Object.ItemList[" + (LineNumber - 1) + "].Quantity"
					, "Object.ItemList");
			// Delete row
			Else
				MessageText =
				StrTemplate(R().Error_068, LineNumbers, Row.Item, Row.ItemKey, Parameters.Operation,
						Row.LackOfBalance,
						0,
						Row.LackOfBalance,
						Row.BasisUnit);
				CommonFunctionsClientServer.ShowUsersMessage(MessageText);	
			EndIf;
		Else
			If Row.Unposting Then
				MessageText =
				StrTemplate(R().Error_068, LineNumber, Row.Item, Row.ItemKey, Parameters.Operation,
					Row.LackOfBalance,
					0,
					Row.LackOfBalance,
					Row.BasisUnit);
			Else
				MessageText =
				StrTemplate(R().Error_068, LineNumbers, Row.Item, Row.ItemKey, Parameters.Operation,
						RemainsQuantity,
						Row.BasisQuantity,
						Row.LackOfBalance,
						Row.BasisUnit);
			EndIf;
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
	If Table.Columns.Find("AdvanceToSupliers") = Undefined Then
		Table.Columns.Add("AdvanceToSupliers", Metadata.DefinedTypes.typeAmount.Type);
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

