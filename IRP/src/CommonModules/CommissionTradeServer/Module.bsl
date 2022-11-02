	
Procedure FillConsignorBatches(DocObject, Store = Undefined) Export
	
	ArrayForDelete = New Array();
	For Each Row In DocObject.ConsignorBatches Do
		If Not DocObject.ItemList.FindRows(New Structure("Key", Row.Key)).Count() Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	
	For Each ItemForDelete In ArrayForDelete Do
		DocObject.ConsignorBatches.Delete(ItemForDelete);
	EndDo;
	
	ItemListTable = New ValueTable();
	ItemListTable.Columns.Add("Key"      , Metadata.DefinedTypes.typeRowID.Type);
	ItemListTable.Columns.Add("Company"  , New TypeDescription("CatalogRef.Companies"));
	ItemListTable.Columns.Add("ItemKey"  , New TypeDescription("CatalogRef.ItemKeys"));
	ItemListTable.Columns.Add("Store"    , New TypeDescription("CatalogRef.Stores"));
	ItemListTable.Columns.Add("Quantity" , Metadata.DefinedTypes.typeQuantity.Type);
	
	ArrayForDelete = New Array();
	For Each Row In DocObject.ItemList Do
		If Row.InventoryOrigin <> Enums.InventoryOrigingTypes.ConsignorStocks Then
			BatchRows = DocObject.ConsignorBatches.FindRows(New Structure("Key", Row.Key));
			For Each BatchRow In BatchRows Do
				DocObject.ConsignorBatches.Delete(BatchRow);
			EndDo;
			Continue;
		EndIf;
		
		IsChanged_ItemKey = False;
		IsChanged_Company = False;
		IsChanged_Store   = False;
		BatchQuantity = 0;
		
		_Store = ?(ValueIsFilled(Store), Store, Row.Store);
		
		BatchRows = DocObject.ConsignorBatches.FindRows(New Structure("Key", Row.Key));
		For Each BatchRow In BatchRows Do
			BatchQuantity = BatchQuantity + BatchRow.Quantity;
			
			If BatchRow.ItemKey <> Row.ItemKey Then
				IsChanged_ItemKey = True;
			EndIf;
			
			If BatchRow.Batch.Company <> DocObject.Company Then
				IsChanged_Company = True;
			EndIf;
			
			If BatchRow.Store <> _Store Then
				IsChanged_Store = True;
			EndIf;
		EndDo;
		
		If BatchQuantity <> Row.QuantityInBaseUnit Or IsChanged_ItemKey Or IsChanged_Company Or IsChanged_Store Then
			For Each BatchRow In BatchRows Do
				ArrayForDelete.Add(BatchRow);
			EndDo;
			NewRow = ItemListTable.Add();
			NewRow.Key      = Row.Key;
			NewRow.Company  = DocObject.Company;
			NewRow.ItemKey  = Row.ItemKey;
			NewRow.Store    = _Store;
			NewRow.Quantity = Row.Quantity;
		EndIf;
	EndDo;
	
	For Each ItemForDelete In ArrayForDelete Do
		DocObject.ConsignorBatches.Delete(ItemForDelete);
	EndDo;
	
	LockStorage = New Array();
	If ItemListTable.Count() Then
		DataLock = New DataLock();
		ItemLock = DataLock.Add("AccumulationRegister.R8013B_ConsignorBatchWiseBallance");
		ItemLock.Mode = DataLockMode.Exclusive;
		ItemLock.DataSource = ItemListTable;
		ItemLock.UseFromDataSource("Company", "Company");
		ItemLock.UseFromDataSource("ItemKey", "ItemKey");
		ItemLock.UseFromDataSource("Store"  , "Store");
		DataLock.Lock();
		LockStorage.Add(DataLock);
		DocObject.AdditionalProperties.Insert("CommissionLockStorage", LockStorage);
		
		ConsignorBatchesTable = GetConsignorBatches_Sales_Transfer(ItemListTable, DocObject);		
		For Each Row In ConsignorBatchesTable Do
			FillPropertyValues(DocObject.ConsignorBatches.Add(), Row);
		EndDo;
	EndIf;
EndProcedure

Procedure FillConsignorBatches_ReturnToConsignor(DocObject) Export
	
	DocObject.ConsignorBatches.Clear();
	
	If DocObject.TransactionType <> Enums.PurchaseReturnTransactionTypes.ReturnToConsignor Then
		Return;
	EndIf;
	
	ItemListTable = New ValueTable();
	ItemListTable.Columns.Add("Key"       , Metadata.DefinedTypes.typeRowID.Type);
	ItemListTable.Columns.Add("Company"   , New TypeDescription("CatalogRef.Companies"));
	ItemListTable.Columns.Add("Partner"   , New TypeDescription("CatalogRef.Partners"));
	ItemListTable.Columns.Add("Agreement" , New TypeDescription("CatalogRef.Agreements"));
	ItemListTable.Columns.Add("Batch"     , New TypeDescription("DocumentRef.PurchaseInvoice"));
	ItemListTable.Columns.Add("ItemKey"   , New TypeDescription("CatalogRef.ItemKeys"));
	ItemListTable.Columns.Add("Store"     , New TypeDescription("CatalogRef.Stores"));
	ItemListTable.Columns.Add("Quantity"  , Metadata.DefinedTypes.typeQuantity.Type);
	
	For Each Row In DocObject.ItemList Do
		NewRow = ItemListTable.Add();
		NewRow.Key        = Row.Key;
		NewRow.Company    = DocObject.Company;
		NewRow.Partner    = DocObject.Partner;
		NewRow.Agreement  = DocObject.Agreement;
		NewRow.Batch      = Row.PurchaseInvoice;
		NewRow.ItemKey    = Row.ItemKey;
		NewRow.Store      = Row.Store;
		NewRow.Quantity = Row.Quantity;
	EndDo;
	
	LockStorage = New Array();
	If ItemListTable.Count() Then
		DataLock = New DataLock();
		ItemLock = DataLock.Add("AccumulationRegister.R8013B_ConsignorBatchWiseBallance");
		ItemLock.Mode = DataLockMode.Exclusive;
		ItemLock.DataSource = ItemListTable;
		ItemLock.UseFromDataSource("Company", "Company");
		ItemLock.UseFromDataSource("ItemKey", "ItemKey");
		ItemLock.UseFromDataSource("Store"  , "Store");
		DataLock.Lock();
		LockStorage.Add(DataLock);
		DocObject.AdditionalProperties.Insert("CommissionLockStorage", LockStorage);
		
		ConsignorBatchesTable = GetConsignorBatches_ReturnToConsignor(ItemListTable, DocObject);		
		For Each Row In ConsignorBatchesTable Do
			FillPropertyValues(DocObject.ConsignorBatches.Add(), Row);
		EndDo;
	EndIf;
EndProcedure

Function GetConsignorBatches_Sales_Transfer(ItemListTable, DocObject)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ItemListTable.Company,
	|	ItemListTable.ItemKey,
	|	ItemListTable.Store,
	|	ItemListTable.Quantity
	|INTO ItemListTable
	|FROM
	|	&ItemListTable AS ItemListTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemListTable.Company,
	|	ItemListTable.ItemKey,
	|	ItemListTable.Store,
	|	SUM(ItemListTable.Quantity) AS Quantity
	|INTO ItemListTableGrouped
	|FROM
	|	ItemListTable AS ItemListTable
	|GROUP BY
	|	ItemListTable.Company,
	|	ItemListTable.ItemKey,
	|	ItemListTable.Store
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemListTableGrouped.ItemKey AS ItemKey,
	|	ItemListTableGrouped.Store AS Store,
	|	Batches.Batch AS Batch,
	|	ItemListTableGrouped.Quantity AS Quantity,
	|	ISNULL(Batches.QuantityBalance, 0) AS QuantityBalance
	|FROM
	|	ItemListTableGrouped AS ItemListTableGrouped
	|		LEFT JOIN AccumulationRegister.R8013B_ConsignorBatchWiseBallance.Balance(&Boundary, (Company, ItemKey, Store) IN
	|			(SELECT
	|				ItemListTableGrouped.Company,
	|				ItemListTableGrouped.ItemKey,
	|				ItemListTableGrouped.Store
	|			FROM
	|				ItemListTableGrouped AS ItemListTableGrouped)) AS Batches
	|		ON ItemListTableGrouped.Company = Batches.Company
	|		AND ItemListTableGrouped.ItemKey = Batches.ItemKey
	|		AND ItemListTableGrouped.Store = Batches.Store
	|
	|ORDER BY
	|	Batches.Batch.Date
	|TOTALS
	|	MAX(Quantity)
	|BY
	|	ItemKey,
	|	Store";
	
	Query.SetParameter("ItemListTable", ItemListTable);
	If ValueIsFilled(DocObject.Ref) Then
		Query.SetParameter("Boundary", New Boundary(DocObject.Ref.PointInTime(), BoundaryType.Excluding));
	Else
		Query.SetParameter("Boundary", CurrentSessionDate());
	EndIf;
	
	QueryResult = Query.Execute();
	BatchTree = QueryResult.Unload(QueryResultIteration.ByGroups);
	
	
	ResultTable = New ValueTable();
	ResultTable.Columns.Add("ItemKey");
	ResultTable.Columns.Add("Store");
	ResultTable.Columns.Add("Batch");
	ResultTable.Columns.Add("Quantity");

	HaveError = False;
	For Each Row_ItemKey In BatchTree.Rows Do
		For Each Row_Store In Row_ItemKey.Rows Do
			
			NeedExpense = Row_Store.Quantity;
		
			For Each Row_Batch In Row_Store.Rows Do
				If NeedExpense = 0 Or Row_Batch.QuantityBalance = 0 Then
					Continue;
				EndIf;
		
				CanExpense = Min(NeedExpense, Row_Batch.QuantityBalance);
			
				NewRow = ResultTable.Add();
				NewRow.ItemKey  = Row_ItemKey.ItemKey;
				NewRow.Store    = Row_Store.Store;
				NewRow.Batch    = Row_Batch.Batch;
				NewRow.Quantity = CanExpense;
			
				Row_Batch.QuantityBalance = Row_Batch.QuantityBalance - CanExpense;
				NeedExpense = NeedExpense - CanExpense;
			EndDo;
		
			If NeedExpense <> 0 Then
				Required  = Format(Row_Store.Quantity, "NFD=3;");
				Remaining = Format(Row_Store.Quantity - NeedExpense, "NFD=3;");
				Lack = Format(NeedExpense, "NFD=3;");
			
				Msg = StrTemplate(R().Error_120, Row_ItemKey.ItemKey, Row_Store.Store, Required, Remaining, Lack);
				CommonFunctionsClientServer.ShowUsersMessage(Msg);
				HaveError = True;			
			EndIf;
		EndDo;
	EndDo;
	
	ConsignorBatchesTable = New ValueTable();
	ConsignorBatchesTable.Columns.Add("Key");
	ConsignorBatchesTable.Columns.Add("ItemKey");
	ConsignorBatchesTable.Columns.Add("Store");
	ConsignorBatchesTable.Columns.Add("Batch");
	ConsignorBatchesTable.Columns.Add("Quantity");
	
	If Not HaveError Then
		For Each Row In ItemListTable Do
			
			NeedExpense = Row.Quantity;
			For Each Row_Result In ResultTable Do
				If Row.ItemKey <> Row_Result.ItemKey Then
					Continue;
				EndIf;
				
				If Row.Store <> Row_Result.Store Then
					Continue;
				EndIf;
				
				If NeedExpense = 0 Or Row_Result.Quantity = 0 Then
					Continue;
				EndIf;
				
				CanExpense = Min(NeedExpense, Row_Result.Quantity);
				Row_Result.Quantity = Row_Result.Quantity - CanExpense;
				NeedExpense = NeedExpense - CanExpense;
				
				NewRow = ConsignorBatchesTable.Add();
				NewRow.Key      = Row.Key;
				NewRow.ItemKey  = Row.ItemKey;
				NewRow.Store    = Row.Store;
				NewRow.Batch    = Row_Result.Batch;
				NewRow.Quantity = CanExpense;
			EndDo;
			
		EndDo;
	EndIf;
	Return ConsignorBatchesTable;
EndFunction

Function GetConsignorBatches_ReturnToConsignor(ItemListTable, DocObject)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ItemListTable.Company,
	|	ItemListTable.Partner,
	|	ItemListTable.Agreement,
	|	ItemListTable.Batch,
	|	ItemListTable.ItemKey,
	|	ItemListTable.Store,
	|	ItemListTable.Quantity
	|INTO ItemListTable
	|FROM
	|	&ItemListTable AS ItemListTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemListTable.Company,
	|	ItemListTable.Partner,
	|	ItemListTable.Agreement,
	|	ItemListTable.Batch,
	|	ItemListTable.ItemKey,
	|	ItemListTable.Store,
	|	SUM(ItemListTable.Quantity) AS Quantity
	|INTO ItemListTable_Batches
	|FROM
	|	ItemListTable AS ItemListTable
	|WHERE
	|	NOT ItemListTable.Batch.Ref IS NULL
	|GROUP BY
	|	ItemListTable.Company,
	|	ItemListTable.Partner,
	|	ItemListTable.Agreement,
	|	ItemListTable.Batch,
	|	ItemListTable.ItemKey,
	|	ItemListTable.Store
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemListTable.Company,
	|	ItemListTable.Partner,
	|	ItemListTable.Agreement,
	|	ItemListTable.ItemKey,
	|	ItemListTable.Store,
	|	SUM(ItemListTable.Quantity) AS Quantity
	|INTO ItemListTable_Grouped
	|FROM
	|	ItemListTable AS ItemListTable
	|WHERE
	|	ItemListTable.Batch.Ref IS NULL
	|GROUP BY
	|	ItemListTable.Company,
	|	ItemListTable.Partner,
	|	ItemListTable.Agreement,
	|	ItemListTable.ItemKey,
	|	ItemListTable.Store
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemListTable_Batches.Company,
	|	ItemListTable_Batches.Partner,
	|	ItemListTable_Batches.Agreement,
	|	ItemListTable_Batches.ItemKey,
	|	ItemListTable_Batches.Store,
	|	Batches.Batch AS Batch,
	|	SUM(ItemListTable_Batches.Quantity) AS Quantity,
	|	SUM(ISNULL(Batches.QuantityBalance, 0)) AS QuantityBalance
	|INTO ConsignorBatchWiseBallance_Batches
	|FROM
	|	ItemListTable_Batches AS ItemListTable_Batches
	|		LEFT JOIN AccumulationRegister.R8013B_ConsignorBatchWiseBallance.Balance(&Boundary, (Company, Batch.Partner,
	|			Batch.Agreement, Batch, ItemKey, Store) IN
	|			(SELECT
	|				ItemListTable_Batches.Company,
	|				ItemListTable_Batches.Partner,
	|				ItemListTable_Batches.Agreement,
	|				ItemListTable_Batches.Batch,
	|				ItemListTable_Batches.ItemKey,
	|				ItemListTable_Batches.Store
	|			FROM
	|				ItemListTable_Batches AS ItemListTable_Batches)) AS Batches
	|		ON ItemListTable_Batches.Company = Batches.Company
	|		AND ItemListTable_Batches.Partner = Batches.Batch.Partner
	|		AND ItemListTable_Batches.Agreement = Batches.Batch.Agreement
	|		AND ItemListTable_Batches.Batch = Batches.Batch
	|		AND ItemListTable_Batches.ItemKey = Batches.ItemKey
	|		AND ItemListTable_Batches.Store = Batches.Store
	|GROUP BY
	|	ItemListTable_Batches.Company,
	|	ItemListTable_Batches.Partner,
	|	ItemListTable_Batches.Agreement,
	|	ItemListTable_Batches.ItemKey,
	|	ItemListTable_Batches.Store,
	|	Batches.Batch
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemListTable_Grouped.Company,
	|	ItemListTable_Grouped.Partner,
	|	ItemListTable_Grouped.Agreement,
	|	ItemListTable_Grouped.ItemKey,
	|	ItemListTable_Grouped.Store,
	|	Batches.Batch AS Batch,
	|	SUM(ItemListTable_Grouped.Quantity) AS Quantity,
	|	SUM(ISNULL(Batches.QuantityBalance, 0)) AS QuantityBalance
	|INTO ConsignorBatchWiseBallance_Grouped
	|FROM
	|	ItemListTable_Grouped AS ItemListTable_Grouped
	|		LEFT JOIN AccumulationRegister.R8013B_ConsignorBatchWiseBallance.Balance(&Boundary, (Company, Batch.Partner,
	|			Batch.Agreement, ItemKey, Store) IN
	|			(SELECT
	|				ItemListTable_Grouped.Company,
	|				ItemListTable_Grouped.Partner,
	|				ItemListTable_Grouped.Agreement,
	|				ItemListTable_Grouped.ItemKey,
	|				ItemListTable_Grouped.Store
	|			FROM
	|				ItemListTable_Grouped AS ItemListTable_Grouped)) AS Batches
	|		ON ItemListTable_Grouped.Company = Batches.Company
	|		AND ItemListTable_Grouped.Partner = Batches.Batch.Partner
	|		AND ItemListTable_Grouped.Agreement = Batches.Batch.Agreement
	|		AND ItemListTable_Grouped.ItemKey = Batches.ItemKey
	|		AND ItemListTable_Grouped.Store = Batches.Store
	|GROUP BY
	|	ItemListTable_Grouped.Company,
	|	ItemListTable_Grouped.Partner,
	|	ItemListTable_Grouped.Agreement,
	|	ItemListTable_Grouped.ItemKey,
	|	ItemListTable_Grouped.Store,
	|	Batches.Batch
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ConsignorBatchWiseBallance_Grouped.Company,
	|	ConsignorBatchWiseBallance_Grouped.Partner,
	|	ConsignorBatchWiseBallance_Grouped.Agreement,
	|	ConsignorBatchWiseBallance_Grouped.ItemKey,
	|	ConsignorBatchWiseBallance_Grouped.Store,
	|	ConsignorBatchWiseBallance_Grouped.Batch,
	|	ConsignorBatchWiseBallance_Grouped.Quantity,
	|	ConsignorBatchWiseBallance_Grouped.QuantityBalance - ISNULL(ConsignorBatchWiseBallance_Batches.Quantity, 0) AS
	|		QuantityBalance
	|INTO ConsignorBatchWiseBallance
	|FROM
	|	ConsignorBatchWiseBallance_Grouped
	|		LEFT JOIN ConsignorBatchWiseBallance_Batches AS ConsignorBatchWiseBallance_Batches
	|		ON ConsignorBatchWiseBallance_Grouped.Company = ConsignorBatchWiseBallance_Batches.Company
	|		AND ConsignorBatchWiseBallance_Grouped.Partner = ConsignorBatchWiseBallance_Batches.Partner
	|		AND ConsignorBatchWiseBallance_Grouped.Agreement = ConsignorBatchWiseBallance_Batches.Agreement
	|		AND ConsignorBatchWiseBallance_Grouped.ItemKey = ConsignorBatchWiseBallance_Batches.ItemKey
	|		AND ConsignorBatchWiseBallance_Grouped.Store = ConsignorBatchWiseBallance_Batches.Store
	|		AND ConsignorBatchWiseBallance_Grouped.Batch = ConsignorBatchWiseBallance_Batches.Batch
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Table.ItemKey,
	|	Table.Store,
	|	Table.Batch,
	|	Table.Quantity,
	|	Table.QuantityBalance
	|FROM
	|	ConsignorBatchWiseBallance_Batches AS Table
	|
	|ORDER BY
	|	Table.Batch.Date
	|TOTALS
	|	MAX(Quantity)
	|BY
	|	ItemKey,
	|	Store
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Table.ItemKey,
	|	Table.Store,
	|	Table.Batch,
	|	Table.Quantity,
	|	Table.QuantityBalance
	|FROM
	|	ConsignorBatchWiseBallance AS Table
	|
	|ORDER BY
	|	Table.Batch.Date
	|TOTALS
	|	MAX(Quantity)
	|BY
	|	ItemKey,
	|	Store";
	
	Query.SetParameter("ItemListTable", ItemListTable);
	If ValueIsFilled(DocObject.Ref) Then
		Query.SetParameter("Boundary", New Boundary(DocObject.Ref.PointInTime(), BoundaryType.Excluding));
	Else
		Query.SetParameter("Boundary", CurrentSessionDate());
	EndIf;
	
	QueryResults = Query.ExecuteBatch();
	BatchTree = QueryResults[6].Unload(QueryResultIteration.ByGroups);
	BatchResult_1 = GetResultTable(BatchTree);
	BatchTree = QueryResults[7].Unload(QueryResultIteration.ByGroups);
	BatchResult_2 = GetResultTable(BatchTree);
		
	ConsignorBatchesTable = New ValueTable();
	ConsignorBatchesTable.Columns.Add("Key");
	ConsignorBatchesTable.Columns.Add("ItemKey");
	ConsignorBatchesTable.Columns.Add("Store");
	ConsignorBatchesTable.Columns.Add("Batch");
	ConsignorBatchesTable.Columns.Add("Quantity");
	
	If Not BatchResult_1.HaveError And Not BatchResult_2.HaveError Then
		
		ItemListTable_1 = ItemListTable.Copy();
		ArrayForDelete = New Array();
		For Each Row In ItemListTable_1 Do
			If Not ValueIsFilled(Row.Batch) Then
				ArrayForDelete.Add(Row);
			EndIf;
		EndDo;
		
		For Each ItemForDelete In ArrayForDelete Do
			ItemListTable_1.Delete(ItemForDelete);
		EndDo;
		
		PutResultToConsignorBatches(ItemListTable_1, BatchResult_1.ResultTable, ConsignorBatchesTable);
		
		ItemListTable_2 = ItemListTable.Copy();
		ArrayForDelete = New Array();
		For Each Row In ItemListTable_2 Do
			If ValueIsFilled(Row.Batch) Then
				ArrayForDelete.Add(Row);
			EndIf;
		EndDo;
		
		For Each ItemForDelete In ArrayForDelete Do
			ItemListTable_2.Delete(ItemForDelete);
		EndDo;
		
		PutResultToConsignorBatches(ItemListTable_2, BatchResult_2.ResultTable, ConsignorBatchesTable);

	EndIf;
	Return ConsignorBatchesTable;
EndFunction

Function GetResultTable(BatchTree)
	ResultTable = New ValueTable();
	ResultTable.Columns.Add("ItemKey");
	ResultTable.Columns.Add("Store");
	ResultTable.Columns.Add("Batch");
	ResultTable.Columns.Add("Quantity");

	HaveError = False;
	For Each Row_ItemKey In BatchTree.Rows Do
		For Each Row_Store In Row_ItemKey.Rows Do
			
			NeedExpense = Row_Store.Quantity;
		
			For Each Row_Batch In Row_Store.Rows Do
				If NeedExpense = 0 Or Row_Batch.QuantityBalance = 0 Then
					Continue;
				EndIf;
		
				CanExpense = Min(NeedExpense, Row_Batch.QuantityBalance);
			
				NewRow = ResultTable.Add();
				NewRow.ItemKey  = Row_ItemKey.ItemKey;
				NewRow.Store    = Row_Store.Store;
				NewRow.Batch    = Row_Batch.Batch;
				NewRow.Quantity = CanExpense;
			
				Row_Batch.QuantityBalance = Row_Batch.QuantityBalance - CanExpense;
				NeedExpense = NeedExpense - CanExpense;
			EndDo;
		
			If NeedExpense <> 0 Then
				Required  = Format(Row_Store.Quantity, "NFD=3;");
				Remaining = Format(Row_Store.Quantity - NeedExpense, "NFD=3;");
				Lack = Format(NeedExpense, "NFD=3;");
			
				Msg = StrTemplate(R().Error_120, Row_ItemKey.ItemKey, Row_Store.Store, Required, Remaining, Lack);
				CommonFunctionsClientServer.ShowUsersMessage(Msg);
				HaveError = True;			
			EndIf;
		EndDo;
	EndDo;
	Return New Structure("ResultTable, HaveError", ResultTable, HaveError);
EndFunction

Procedure PutResultToConsignorBatches(ItemListTable, ResultTable, ConsignorBatchesTable)
	For Each Row In ItemListTable Do
		NeedExpense = Row.Quantity;
		For Each Row_Result In ResultTable Do
			If Row.ItemKey <> Row_Result.ItemKey Then
				Continue;
			EndIf;
				
			If Row.Store <> Row_Result.Store Then
				Continue;
			EndIf;
				
			If NeedExpense = 0 Or Row_Result.Quantity = 0 Then
				Continue;
			EndIf;
				
			CanExpense = Min(NeedExpense, Row_Result.Quantity);
			Row_Result.Quantity = Row_Result.Quantity - CanExpense;
			NeedExpense = NeedExpense - CanExpense;
				
			NewRow = ConsignorBatchesTable.Add();
			NewRow.Key      = Row.Key;
			NewRow.ItemKey  = Row.ItemKey;
			NewRow.Store    = Row.Store;
			NewRow.Batch    = Row_Result.Batch;
			NewRow.Quantity = CanExpense;
		EndDo;
	EndDo;
EndProcedure

