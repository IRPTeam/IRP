	
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
		
		ConsignorBatchesTable = GetConsignorBatches(ItemListTable, DocObject);		
		For Each Row In ConsignorBatchesTable Do
			FillPropertyValues(DocObject.ConsignorBatches.Add(), Row);
		EndDo;
	EndIf;
EndProcedure

Function GetConsignorBatches(ItemListTable, DocObject)
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
