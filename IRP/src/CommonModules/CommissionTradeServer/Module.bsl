	
Function GetRegistrateConsignorBatches(DocObject, ItemListTable) Export
	RegisterConsignorBatches = GetRegisterConsignorBatches(DocObject);
	
	ArrayForDelete = New Array();
	For Each Row In RegisterConsignorBatches Do
		If Not ItemListTable.FindRows(New Structure("Key, SerialLotNumber", Row.Key, Row.SerialLotNumber)).Count() Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	
	For Each ItemForDelete In ArrayForDelete Do
		RegisterConsignorBatches.Delete(ItemForDelete);
	EndDo;
	
	ItemListFiltered = New ValueTable();
	ItemListFiltered.Columns.Add("Key"      , Metadata.DefinedTypes.typeRowID.Type);
	ItemListFiltered.Columns.Add("Company"  , New TypeDescription("CatalogRef.Companies"));
	ItemListFiltered.Columns.Add("ItemKey"  , New TypeDescription("CatalogRef.ItemKeys"));
	ItemListFiltered.Columns.Add("SerialLotNumber", New TypeDescription("CatalogRef.SerialLotNumbers"));
	ItemListFiltered.Columns.Add("Store"    , New TypeDescription("CatalogRef.Stores"));
	ItemListFiltered.Columns.Add("Quantity" , Metadata.DefinedTypes.typeQuantity.Type);
	
	ArrayForDelete = New Array();
	For Each Row In ItemListTable Do
		If Row.InventoryOrigin <> Enums.InventoryOrigingTypes.ConsignorStocks Then
			BatchRows = RegisterConsignorBatches.FindRows(New Structure("Key", Row.Key));
			For Each BatchRow In BatchRows Do
				RegisterConsignorBatches.Delete(BatchRow);
			EndDo;
			Continue;
		EndIf;
		
		IsChanged_ItemKey = False;
		IsChanged_Company = False;
		IsChanged_Store   = False;
		BatchQuantity = 0;
		
		BatchRows = RegisterConsignorBatches.FindRows(New Structure("Key, SerialLotNumber", Row.Key, Row.SerialLotNumber));
		For Each BatchRow In BatchRows Do
			BatchQuantity = BatchQuantity + BatchRow.Quantity;
			
			If BatchRow.ItemKey <> Row.ItemKey Then
				IsChanged_ItemKey = True;
			EndIf;
			
			If BatchRow.Batch.Company <> Row.Company Then
				IsChanged_Company = True;
			EndIf;
			
			If BatchRow.Store <> Row.Store Then
				IsChanged_Store = True;
			EndIf;
		EndDo;
		
		If BatchQuantity <> Row.Quantity 
			Or IsChanged_ItemKey Or IsChanged_Company Or IsChanged_Store Then
				
			For Each BatchRow In BatchRows Do
				ArrayForDelete.Add(BatchRow);
			EndDo;
			
			NewRow = ItemListFiltered.Add();
			NewRow.Key      = Row.Key;
			NewRow.Company  = Row.Company;
			NewRow.ItemKey  = Row.ItemKey;
			NewRow.SerialLotNumber  = Row.SerialLotNumber;
			NewRow.Store    = Row.Store;
			NewRow.Quantity = Row.Quantity;
		EndIf;
	EndDo;
	
	For Each ItemForDelete In ArrayForDelete Do
		RegisterConsignorBatches.Delete(ItemForDelete);
	EndDo;
	
	If ItemListFiltered.Count() Then
		LockConsignorBatchWiseBalance(DocObject, ItemListFiltered);		
		ConsignorBatchesTable = GetConsignorBatches_Sales_Transfer(ItemListFiltered, DocObject);	
		
		For Each Row In RegisterConsignorBatches Do
			Filter = New Structure();
			Filter.Insert("Key"             , Row.Key);
			Filter.Insert("ItemKey"         , Row.ItemKey);
			Filter.Insert("SerialLotNumber" , Row.SerialLotNumber);
			Filter.Insert("Store"           , Row.Store);
			
			If ConsignorBatchesTable.FindRows(Filter).Count() = 0 Then
				FillPropertyValues(ConsignorBatchesTable.Add(), Row);
			EndIf;
		EndDo;
			
		UpdateRegisterConsignorBatches(DocObject, ConsignorBatchesTable);
		Return ConsignorBatchesTable;
	Else
		UpdateRegisterConsignorBatches(DocObject, RegisterConsignorBatches);
		Return RegisterConsignorBatches;
	EndIf;
EndFunction

Function GetTableConsignorBatchWiseBalanceForPurchaseReturn(DocObject, ItemListTable) Export
	If Not ItemListTable.Count() Then
		Return GetEmptyConsignorBatchesTable();
	EndIf;
	
	LockConsignorBatchWiseBalance(DocObject, ItemListTable);
	
	ConsignorBatchesTable = GetConsignorBatches_ReturnToConsignor(ItemListTable, DocObject);		
	Return ConsignorBatchesTable;
EndFunction

Function GetTableConsignorBatchWiseBalanceForSalesReturn(DocObject, ItemListTable) Export
	LockStorage = New Array();
	DataLock = New DataLock();
	ItemLock = DataLock.Add("AccumulationRegister.R8013B_ConsignorBatchWiseBalance");
	ItemLock.Mode = DataLockMode.Exclusive;
	ItemLock.DataSource = ItemListTable;
	ItemLock.UseFromDataSource("Company", "Company");
	ItemLock.UseFromDataSource("ItemKey", "ItemKey");
	DataLock.Lock();
	LockStorage.Add(DataLock);
	DocObject.AdditionalProperties.Insert("CommissionLockStorage", LockStorage);
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ItemList.Company,
	|	ItemList.SalesDocument,
	|	ItemList.Store,
	|	ItemList.ItemKey,
	|	ItemList.SerialLotNumber,
	|	ItemList.Quantity
	|INTO ItemList
	|FROM
	|	&ItemList AS ItemList
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList.Company,
	|	ItemList.SalesDocument,
	|	ItemList.Store,
	|	ItemList.ItemKey,
	|	ItemList.SerialLotNumber,
	|	SUM(ItemList.Quantity) AS Quantity
	|INTO ItemListGrouped
	|FROM
	|	ItemList AS ItemList
	|GROUP BY
	|	ItemList.Company,
	|	ItemList.SalesDocument,
	|	ItemList.Store,
	|	ItemList.ItemKey,
	|	ItemList.SerialLotNumber
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Batches.Company,
	|	Batches.Recorder AS SalesDocument,
	|	Batches.Batch,
	|	Batches.ItemKey,
	|	Batches.SerialLotNumber,
	|	Batches.Quantity
	|FROM
	|	AccumulationRegister.R8013B_ConsignorBatchWiseBalance AS Batches
	|WHERE
	|	(Company, ItemKey, SerialLotNumber, Recorder) IN
	|		(SELECT
	|			ItemList.Company,
	|			ItemList.ItemKey,
	|			ItemList.SerialLotNumber,
	|			ItemList.SalesDocument
	|		FROM
	|			ItemListGrouped AS ItemList)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList.Company,
	|	ItemList.SalesDocument,
	|	ItemList.Store,
	|	ItemList.ItemKey,
	|	ItemList.SerialLotNumber,
	|	ItemList.Quantity AS Quantity
	|FROM
	|	ItemListGrouped AS ItemList";
	
	Query.SetParameter("ItemList", ItemListTable);
	
	QueryResults = Query.ExecuteBatch();
	RegisterBatches  = QueryResults[2].Unload();
	DocumentItemList = QueryResults[3].Unload();
	
	AccReg = Metadata.AccumulationRegisters.R8013B_ConsignorBatchWiseBalance;
	ConsignorBatches = New ValueTable();
	ConsignorBatches.Columns.Add("Company"  , AccReg.Dimensions.Company.Type);
	ConsignorBatches.Columns.Add("Batch"    , AccReg.Dimensions.Batch.Type);
	ConsignorBatches.Columns.Add("Store"    , AccReg.Dimensions.Store.Type);
	ConsignorBatches.Columns.Add("ItemKey"  , AccReg.Dimensions.ItemKey.Type);
	ConsignorBatches.Columns.Add("SerialLotNumber" , AccReg.Dimensions.SerialLotNumber.Type);
	ConsignorBatches.Columns.Add("Quantity" , AccReg.Resources.Quantity.Type);
	ConsignorBatches.Columns.Add("SalesDocument" , AccReg.StandardAttributes.Recorder.Type);
	
	For Each Row_DocumentItemList In DocumentItemList Do
		NeedReceipt = Row_DocumentItemList.Quantity;
		
		Filter = New Structure();
		Filter.Insert("Company"         , Row_DocumentItemList.Company);
		Filter.Insert("SalesDocument"   , Row_DocumentItemList.SalesDocument);
		Filter.Insert("ItemKey"         , Row_DocumentItemList.ItemKey);
		Filter.Insert("SerialLotNumber" , Row_DocumentItemList.SerialLotNumber);
		
		RegisterBatchesRows = RegisterBatches.FindRows(Filter);
		For Each Row_RegisterBatches In RegisterBatchesRows Do
			If NeedReceipt = 0 Or Row_RegisterBatches.Quantity = 0 Then
				Continue;
			EndIf;
			CanReceipt = Min(NeedReceipt, Row_RegisterBatches.Quantity);
			
			NewRow = ConsignorBatches.Add();
			NewRow.Company  = Row_RegisterBatches.Company;
			NewRow.Batch    = Row_RegisterBatches.Batch;
			NewRow.Store    = Row_DocumentItemList.Store;
			NewRow.ItemKey  = Row_RegisterBatches.ItemKey;
			NewRow.SerialLotNumber = Row_RegisterBatches.SerialLotNumber;
			NewRow.Quantity = CanReceipt;
			NewRow.SalesDocument = Row_DocumentItemList.SalesDocument;
			
			NeedReceipt = NeedReceipt - CanReceipt;
			Row_RegisterBatches.Quantity = Row_RegisterBatches.Quantity - CanReceipt;
		EndDo;
		
	EndDo; 
	Return ConsignorBatches;
EndFunction

Function GetConsignorBatches_Sales_Transfer(ItemListTable, DocObject)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ItemListTable.Company,
	|	ItemListTable.ItemKey,
	|	ItemListTable.SerialLotNumber,
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
	|	ItemListTable.SerialLotNumber,
	|	ItemListTable.Store,
	|	SUM(ItemListTable.Quantity) AS Quantity
	|INTO ItemListTableGrouped
	|FROM
	|	ItemListTable AS ItemListTable
	|GROUP BY
	|	ItemListTable.Company,
	|	ItemListTable.ItemKey,
	|	ItemListTable.SerialLotNumber,
	|	ItemListTable.Store
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemListTableGrouped.ItemKey AS ItemKey,
	|	ItemListTableGrouped.SerialLotNumber AS SerialLotNumber,
	|	ItemListTableGrouped.Store AS Store,
	|	Batches.Batch AS Batch,
	|	ItemListTableGrouped.Quantity AS Quantity,
	|	ISNULL(Batches.QuantityBalance, 0) AS QuantityBalance
	|FROM
	|	ItemListTableGrouped AS ItemListTableGrouped
	|		LEFT JOIN AccumulationRegister.R8013B_ConsignorBatchWiseBalance.Balance(&Boundary, (Company, ItemKey, SerialLotNumber, Store) IN
	|			(SELECT
	|				ItemListTableGrouped.Company,
	|				ItemListTableGrouped.ItemKey,
	|				ItemListTableGrouped.SerialLotNumber,
	|				ItemListTableGrouped.Store
	|			FROM
	|				ItemListTableGrouped AS ItemListTableGrouped)) AS Batches
	|		ON ItemListTableGrouped.Company = Batches.Company
	|		AND ItemListTableGrouped.ItemKey = Batches.ItemKey
	|		AND ItemListTableGrouped.SerialLotNumber = Batches.SerialLotNumber
	|		AND ItemListTableGrouped.Store = Batches.Store
	|
	|ORDER BY
	|	Batches.Batch.Date
	|TOTALS
	|	MAX(Quantity)
	|BY
	|	ItemKey,
	|	SerialLotNumber,
	|	Store";
	
	Query.SetParameter("ItemListTable", ItemListTable);
	Query.SetParameter("Boundary", New Boundary(DocObject.Ref.PointInTime(), BoundaryType.Excluding));
	
	QueryResult = Query.Execute();
	BatchTree = QueryResult.Unload(QueryResultIteration.ByGroups);
	
	BatchResult = GetResultTable(BatchTree);	
	ConsignorBatchesTable = GetEmptyConsignorBatchesTable();
	
	If Not BatchResult.HaveError Then
		PutResultToConsignorBatches(ItemListTable, BatchResult.ResultTable, ConsignorBatchesTable);
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
	|	ItemListTable.SerialLotNumber,
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
	|	ItemListTable.SerialLotNumber,
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
	|	ItemListTable.SerialLotNumber,
	|	ItemListTable.Store
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemListTable.Company,
	|	ItemListTable.Partner,
	|	ItemListTable.Agreement,
	|	ItemListTable.ItemKey,
	|	ItemListTable.SerialLotNumber,
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
	|	ItemListTable.SerialLotNumber,
	|	ItemListTable.Store
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemListTable_Batches.Company,
	|	ItemListTable_Batches.Partner,
	|	ItemListTable_Batches.Agreement,
	|	ItemListTable_Batches.ItemKey,
	|	ItemListTable_Batches.SerialLotNumber,
	|	ItemListTable_Batches.Store,
	|	Batches.Batch AS Batch,
	|	SUM(ItemListTable_Batches.Quantity) AS Quantity,
	|	SUM(ISNULL(Batches.QuantityBalance, 0)) AS QuantityBalance
	|INTO ConsignorBatchWiseBalance_Batches
	|FROM
	|	ItemListTable_Batches AS ItemListTable_Batches
	|		LEFT JOIN AccumulationRegister.R8013B_ConsignorBatchWiseBalance.Balance(&Boundary, (Company, Batch.Partner,
	|			Batch.Agreement, Batch, ItemKey, SerialLotNumber, Store) IN
	|			(SELECT
	|				ItemListTable_Batches.Company,
	|				ItemListTable_Batches.Partner,
	|				ItemListTable_Batches.Agreement,
	|				ItemListTable_Batches.Batch,
	|				ItemListTable_Batches.ItemKey,
	|				ItemListTable_Batches.SerialLotNumber,
	|				ItemListTable_Batches.Store
	|			FROM
	|				ItemListTable_Batches AS ItemListTable_Batches)) AS Batches
	|		ON ItemListTable_Batches.Company = Batches.Company
	|		AND ItemListTable_Batches.Partner = Batches.Batch.Partner
	|		AND ItemListTable_Batches.Agreement = Batches.Batch.Agreement
	|		AND ItemListTable_Batches.Batch = Batches.Batch
	|		AND ItemListTable_Batches.ItemKey = Batches.ItemKey
	|		AND ItemListTable_Batches.SerialLotNumber = Batches.SerialLotNumber
	|		AND ItemListTable_Batches.Store = Batches.Store
	|GROUP BY
	|	ItemListTable_Batches.Company,
	|	ItemListTable_Batches.Partner,
	|	ItemListTable_Batches.Agreement,
	|	ItemListTable_Batches.ItemKey,
	|	ItemListTable_Batches.SerialLotNumber,
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
	|	ItemListTable_Grouped.SerialLotNumber,
	|	ItemListTable_Grouped.Store,
	|	Batches.Batch AS Batch,
	|	SUM(ItemListTable_Grouped.Quantity) AS Quantity,
	|	SUM(ISNULL(Batches.QuantityBalance, 0)) AS QuantityBalance
	|INTO ConsignorBatchWiseBalance_Grouped
	|FROM
	|	ItemListTable_Grouped AS ItemListTable_Grouped
	|		LEFT JOIN AccumulationRegister.R8013B_ConsignorBatchWiseBalance.Balance(&Boundary, (Company, Batch.Partner,
	|			Batch.Agreement, ItemKey, SerialLotNumber, Store) IN
	|			(SELECT
	|				ItemListTable_Grouped.Company,
	|				ItemListTable_Grouped.Partner,
	|				ItemListTable_Grouped.Agreement,
	|				ItemListTable_Grouped.ItemKey,
	|				ItemListTable_Grouped.SerialLotNumber,
	|				ItemListTable_Grouped.Store
	|			FROM
	|				ItemListTable_Grouped AS ItemListTable_Grouped)) AS Batches
	|		ON ItemListTable_Grouped.Company = Batches.Company
	|		AND ItemListTable_Grouped.Partner = Batches.Batch.Partner
	|		AND ItemListTable_Grouped.Agreement = Batches.Batch.Agreement
	|		AND ItemListTable_Grouped.ItemKey = Batches.ItemKey
	|		AND ItemListTable_Grouped.SerialLotNumber = Batches.SerialLotNumber
	|		AND ItemListTable_Grouped.Store = Batches.Store
	|GROUP BY
	|	ItemListTable_Grouped.Company,
	|	ItemListTable_Grouped.Partner,
	|	ItemListTable_Grouped.Agreement,
	|	ItemListTable_Grouped.ItemKey,
	|	ItemListTable_Grouped.SerialLotNumber,
	|	ItemListTable_Grouped.Store,
	|	Batches.Batch
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ConsignorBatchWiseBalance_Grouped.Company,
	|	ConsignorBatchWiseBalance_Grouped.Partner,
	|	ConsignorBatchWiseBalance_Grouped.Agreement,
	|	ConsignorBatchWiseBalance_Grouped.ItemKey,
	|	ConsignorBatchWiseBalance_Grouped.SerialLotNumber,
	|	ConsignorBatchWiseBalance_Grouped.Store,
	|	ConsignorBatchWiseBalance_Grouped.Batch,
	|	ConsignorBatchWiseBalance_Grouped.Quantity,
	|	ConsignorBatchWiseBalance_Grouped.QuantityBalance - ISNULL(ConsignorBatchWiseBalance_Batches.Quantity, 0) AS
	|		QuantityBalance
	|INTO ConsignorBatchWiseBalance
	|FROM
	|	ConsignorBatchWiseBalance_Grouped
	|		LEFT JOIN ConsignorBatchWiseBalance_Batches AS ConsignorBatchWiseBalance_Batches
	|		ON ConsignorBatchWiseBalance_Grouped.Company = ConsignorBatchWiseBalance_Batches.Company
	|		AND ConsignorBatchWiseBalance_Grouped.Partner = ConsignorBatchWiseBalance_Batches.Partner
	|		AND ConsignorBatchWiseBalance_Grouped.Agreement = ConsignorBatchWiseBalance_Batches.Agreement
	|		AND ConsignorBatchWiseBalance_Grouped.ItemKey = ConsignorBatchWiseBalance_Batches.ItemKey
	|		AND ConsignorBatchWiseBalance_Grouped.SerialLotNumber = ConsignorBatchWiseBalance_Batches.SerialLotNumber
	|		AND ConsignorBatchWiseBalance_Grouped.Store = ConsignorBatchWiseBalance_Batches.Store
	|		AND ConsignorBatchWiseBalance_Grouped.Batch = ConsignorBatchWiseBalance_Batches.Batch
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Table.ItemKey,
	|	Table.SerialLotNumber,
	|	Table.Store,
	|	Table.Batch,
	|	Table.Quantity,
	|	Table.QuantityBalance
	|FROM
	|	ConsignorBatchWiseBalance_Batches AS Table
	|
	|ORDER BY
	|	Table.Batch.Date
	|TOTALS
	|	MAX(Quantity)
	|BY
	|	ItemKey,
	|	SerialLotNumber,
	|	Store
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Table.ItemKey,
	|	Table.SerialLotNumber,
	|	Table.Store,
	|	Table.Batch,
	|	Table.Quantity,
	|	Table.QuantityBalance
	|FROM
	|	ConsignorBatchWiseBalance AS Table
	|
	|ORDER BY
	|	Table.Batch.Date
	|TOTALS
	|	MAX(Quantity)
	|BY
	|	ItemKey,
	|	SerialLotNumber,
	|	Store";
	
	Query.SetParameter("ItemListTable", ItemListTable);
	Query.SetParameter("Boundary", New Boundary(DocObject.Ref.PointInTime(), BoundaryType.Excluding));
	
	QueryResults = Query.ExecuteBatch();
	BatchTree = QueryResults[6].Unload(QueryResultIteration.ByGroups);
	BatchResult_1 = GetResultTable(BatchTree);
	BatchTree = QueryResults[7].Unload(QueryResultIteration.ByGroups);
	BatchResult_2 = GetResultTable(BatchTree);
	
	ConsignorBatchesTable = GetEmptyConsignorBatchesTable();
	
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

Procedure LockConsignorBatchWiseBalance(DocObject, ItemListTable)
	LockStorage = New Array();
	DataLock = New DataLock();
	ItemLock = DataLock.Add("AccumulationRegister.R8013B_ConsignorBatchWiseBalance");
	ItemLock.Mode = DataLockMode.Exclusive;
	ItemLock.DataSource = ItemListTable;
	ItemLock.UseFromDataSource("Company", "Company");
	ItemLock.UseFromDataSource("ItemKey", "ItemKey");
	ItemLock.UseFromDataSource("Store"  , "Store");
	DataLock.Lock();
	LockStorage.Add(DataLock);
	DocObject.AdditionalProperties.Insert("CommissionLockStorage", LockStorage);	
EndProcedure

Function GetResultTable(BatchTree)
	ResultTable = New ValueTable();
	ResultTable.Columns.Add("ItemKey");
	ResultTable.Columns.Add("SerialLotNumber");
	ResultTable.Columns.Add("Store");
	ResultTable.Columns.Add("Batch");
	ResultTable.Columns.Add("Quantity");

	HaveError = False;
	For Each Row_ItemKey In BatchTree.Rows Do
		For Each Row_SerialLotNumber In Row_ItemKey.Rows Do
			For Each Row_Store In Row_SerialLotNumber.Rows Do
			
				NeedExpense = Row_Store.Quantity;
		
				For Each Row_Batch In Row_Store.Rows Do
					If NeedExpense = 0 Or Row_Batch.QuantityBalance = 0 Then
						Continue;
					EndIf;
		
					CanExpense = Min(NeedExpense, Row_Batch.QuantityBalance);
			
					NewRow = ResultTable.Add();
					NewRow.ItemKey  = Row_ItemKey.ItemKey;
					NewRow.SerialLotNumber  = Row_SerialLotNumber.SerialLotNumber;
					NewRow.Store    = Row_Store.Store;
					NewRow.Batch    = Row_Batch.Batch;
					NewRow.Quantity = CanExpense;
			
					Row_Batch.QuantityBalance = Row_Batch.QuantityBalance - CanExpense;
					NeedExpense = NeedExpense - CanExpense;
				EndDo; // Row_Store.Rows
		
				If NeedExpense <> 0 Then
					Required  = Format(Row_Store.Quantity, "NFD=3;");
					Remaining = Format(Row_Store.Quantity - NeedExpense, "NFD=3;");
					Lack = Format(NeedExpense, "NFD=3;");
			
					Msg = StrTemplate(R().Error_120, Row_ItemKey.ItemKey, Row_Store.Store, Required, Remaining, Lack);
					CommonFunctionsClientServer.ShowUsersMessage(Msg);
					HaveError = True;			
				EndIf;
			EndDo; // Row_SerialLotNumber.Rows
		EndDo; // Row_ItemKey.Rows
	EndDo; // BatchTree.Rows
	
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
			
			If Row.SerialLotNumber <> Row_Result.SerialLotNumber Then
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
			NewRow.SerialLotNumber  = Row.SerialLotNumber;
			NewRow.Store    = Row.Store;
			NewRow.Batch    = Row_Result.Batch;
			NewRow.Quantity = CanExpense;
		EndDo;
	EndDo;
EndProcedure

Function GetEmptyConsignorBatchesTable()
	ConsignorBatchesTable = New ValueTable();
	ConsignorBatchesTable.Columns.Add("Key"      , Metadata.DefinedTypes.typeRowID.Type);
	ConsignorBatchesTable.Columns.Add("ItemKey"  , New TypeDescription("CatalogRef.ItemKeys"));
	ConsignorBatchesTable.Columns.Add("SerialLotNumber"  , New TypeDescription("CatalogRef.SerialLotNumbers"));
	ConsignorBatchesTable.Columns.Add("Store"    , New TypeDescription("CatalogRef.Stores"));
	ConsignorBatchesTable.Columns.Add("Batch"    , New TypeDescription("DocumentRef.PurchaseInvoice"));
	ConsignorBatchesTable.Columns.Add("Quantity" , Metadata.DefinedTypes.typeQuantity.Type);
	Return ConsignorBatchesTable;
EndFunction

Function GetRegisterConsignorBatches(DocObject)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	T8010S_ConsignorBatches.Key,
	|	T8010S_ConsignorBatches.ItemKey,
	|	T8010S_ConsignorBatches.SerialLotNumber,
	|	T8010S_ConsignorBatches.Store,
	|	T8010S_ConsignorBatches.Batch,
	|	T8010S_ConsignorBatches.Quantity
	|FROM
	|	InformationRegister.T8010S_ConsignorBatches AS T8010S_ConsignorBatches
	|WHERE
	|	T8010S_ConsignorBatches.Document = &Document";
	Query.SetParameter("Document", DocObject.Ref);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	Return QueryTable;
EndFunction

Procedure UpdateRegisterConsignorBatches(DocObject, ConsignorBatchesTable)
	RecordSet = InformationRegisters.T8010S_ConsignorBatches.CreateRecordSet();
	RecordSet.Filter.Document.Set(DocObject.Ref);
	For Each Row In ConsignorBatchesTable Do
		Record = RecordSet.Add();
		FillPropertyValues(Record, Row);
		Record.Document = DocObject.Ref;
	EndDo;
	RecordSet.Write();
EndProcedure

Function GetSalesReportToConsignorList() Export
	Return CommissionTradePrivileged.GetSalesReportToConsignorList();
EndFunction
	
Function __GetSalesReportToConsignorList() Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	PRESENTATION(SalesReportToConsignor.Company) AS CompanyPresentation,
	|	SalesReportToConsignor.Date,
	|	SalesReportToConsignor.Number,
	|	SalesReportToConsignor.StartDate,
	|	SalesReportToConsignor.EndDate,
	|	SalesReportToConsignor.Ref AS SalesReportRef
	|FROM
	|	Document.SalesReportToConsignor AS SalesReportToConsignor
	|WHERE
	|	SalesReportToConsignor.Posted";
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;	
EndFunction

Function GetFillingDataBySalesReportToConsignor(DocRef) Export
	Return CommissionTradePrivileged.GetFillingDataBySalesReportToConsignor(DocRef);
EndFunction	

Function __GetFillingDataBySalesReportToConsignor(DocRef) Export
	FillingData = New Structure("BasedOn", "SalesReportToConsignor");
	FillingData.Insert("ItemList", New Array());
	FillingData.Insert("TaxList", New Array());
	FillingData.Insert("SerialLotNumbers", New Array());
	
	FillingData.Insert("Partner", DocRef.Company.Partner);
	
	For Each Row In DocRef.ItemList Do
		NewRow = New Structure("Key, Item, ItemKey, Unit, Quantity, Price, PriceType, 
		|TaxAmount, TotalAmount, NetAmount, DontCalculateRow,
		|ConsignorPrice, TradeAgentFeePercent, TradeAgentFeeAmount");
		FillPropertyValues(NewRow, Row);
		FillingData.ItemList.Add(NewRow);
	EndDo;
	
	For Each Row In DocRef.TaxList Do
		NewRow = New Structure("Key, Tax, Analytics, TaxRate, Amount, IncludeToTotalAmount, ManualAmount");
		FillPropertyValues(NewRow, Row);
		FillingData.TaxList.Add(NewRow);
	EndDo;
	
	For Each Row In DocRef.SerialLotNumbers Do
		NewRow = New Structure("Key, SerialLotNumber, Quantity");
		FillPropertyValues(NewRow, Row);
		FillingData.SerialLotNumbers.Add(NewRow);
	EndDo;
	
	Return FillingData;
EndFunction	
