
Function GetConsignorBatchesTable(DocObject, Table_ItemList, Table_SerialLotNumber, Table_SourceOfOrigins, Table_ConsignorBatches, SilentMode = False) Export
	tmpItemList = New ValueTable();
	tmpItemList.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	tmpItemList.Columns.Add("InventoryOrigin" , New TypeDescription("EnumRef.InventoryOriginTypes"));
	tmpItemList.Columns.Add("Company"         , New TypeDescription("CatalogRef.Companies"));
	tmpItemList.Columns.Add("ItemKey"         , New TypeDescription("CatalogRef.ItemKeys"));
	tmpItemList.Columns.Add("Store"           , New TypeDescription("CatalogRef.Stores"));
	tmpItemList.Columns.Add("Quantity"        , Metadata.DefinedTypes.typeQuantity.Type);
	
	For Each Row In Table_ItemList Do
		FillPropertyValues(tmpItemList.Add(), Row);
	EndDo;
	
	tmpSerialLotNumbers = New ValueTable();
	tmpSerialLotNumbers.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	tmpSerialLotNumbers.Columns.Add("SerialLotNumber" , New TypeDescription("CatalogRef.SerialLotNumbers"));
	tmpSerialLotNumbers.Columns.Add("Quantity"        , Metadata.DefinedTypes.typeQuantity.Type);
	
	For Each Row In Table_SerialLotNumber Do
		FillPropertyValues(tmpSerialLotNumbers.Add(), Row);
	EndDo;
	tmpSerialLotNumbers.GroupBy("Key, SerialLotNumber", "Quantity");
	
	tmpSourceOfOrigins = New ValueTable();
	tmpSourceOfOrigins.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	tmpSourceOfOrigins.Columns.Add("SerialLotNumber" , New TypeDescription("CatalogRef.SerialLotNumbers"));
	tmpSourceOfOrigins.Columns.Add("SourceOfOrigin"  , New TypeDescription("CatalogRef.SourceOfOrigins"));
	tmpSourceOfOrigins.Columns.Add("Quantity"        , Metadata.DefinedTypes.typeQuantity.Type);
	
	For Each Row In Table_SourceOfOrigins Do
		NewRow = tmpSourceOfOrigins.Add();
		FillPropertyValues(NewRow, Row);
		If Not ValueIsFilled(NewRow.SerialLotNumber) Then
			NewRow.SerialLotNumber = Catalogs.SerialLotNumbers.EmptyRef();
		EndIf;
	EndDo;
	
	tmpConsignorBatches = New ValueTable();
	tmpConsignorBatches.Columns.Add("Key"      , Metadata.DefinedTypes.typeRowID.Type);
	tmpConsignorBatches.Columns.Add("ItemKey"  , New TypeDescription("CatalogRef.ItemKeys"));
	tmpConsignorBatches.Columns.Add("SerialLotNumber", New TypeDescription("CatalogRef.SerialLotNumbers"));
	tmpConsignorBatches.Columns.Add("SourceOfOrigin" , New TypeDescription("CatalogRef.SourceOfOrigins"));
	tmpConsignorBatches.Columns.Add("Store"    , New TypeDescription("CatalogRef.Stores"));
	tmpConsignorBatches.Columns.Add("Batch"    , New TypeDescription("DocumentRef.SalesInvoice"));
	tmpConsignorBatches.Columns.Add("Quantity" , Metadata.DefinedTypes.typeQuantity.Type);
		
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ItemList.Key AS Key,
	|	ItemList.InventoryOrigin AS InventoryOrigin,
	|	ItemList.Company AS Company,
	|	ItemList.ItemKey AS ItemKey,
	|	ItemList.Store AS Store,
	|	ItemList.Quantity AS Quantity
	|INTO tmpItemList
	|FROM
	|	&tmpItemList AS ItemList
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SerialLotNumbers.Key,
	|	SerialLotNumbers.SerialLotNumber,
	|	SerialLotNumbers.Quantity
	|INTO tmpSerialLotNumbers
	|FROM
	|	&tmpSerialLotNumbers AS SerialLotNumbers
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpSourceOfOrigins.Key,
	|	tmpSourceOfOrigins.SerialLotNumber,
	|	tmpSourceOfOrigins.SourceOfOrigin,
	|	tmpSourceOfOrigins.Quantity
	|INTO tmpSourceOfOrigins
	|FROM
	|	&tmpSourceOfOrigins AS tmpSourceOfOrigins
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpItemList.Key,
	|	tmpItemList.InventoryOrigin,
	|	tmpItemList.Company,
	|	tmpItemList.ItemKey,
	|	tmpItemList.Store,
	|	CASE
	|		WHEN tmpSerialLotNumbers.SerialLotNumber.Ref IS NULL
	|			THEN tmpItemList.Quantity
	|		ELSE tmpSerialLotNumbers.Quantity
	|	END AS Quantity,
	|	ISNULL(tmpSerialLotNumbers.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber
	|INTO tmpItemList_1
	|FROM
	|	tmpItemList AS tmpItemList
	|		LEFT JOIN tmpSerialLotNumbers AS tmpSerialLotNumbers
	|		ON tmpItemList.Key = tmpSerialLotNumbers.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpItemList_1.Key,
	|	tmpItemList_1.InventoryOrigin,
	|	tmpItemList_1.Company,
	|	tmpItemList_1.ItemKey,
	|	tmpItemList_1.Store,
	|	tmpItemList_1.SerialLotNumber,
	|	CASE
	|		WHEN ISNULL(tmpSourceOfOrigins.Quantity, 0) <> 0
	|			THEN ISNULL(tmpSourceOfOrigins.Quantity, 0)
	|		ELSE tmpItemList_1.Quantity
	|	END AS Quantity,
	|	ISNULL(tmpSourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)) AS SourceOfOrigin
	|FROM
	|	tmpItemList_1 AS tmpItemList_1
	|		LEFT JOIN tmpSourceOfOrigins AS tmpSourceOfOrigins
	|		ON tmpItemList_1.Key = tmpSourceOfOrigins.Key
	|		AND tmpItemList_1.SerialLotNumber = tmpSourceOfOrigins.SerialLotNumber";
	Query.SetParameter("tmpItemList", tmpItemList);
	Query.SetParameter("tmpSerialLotNumbers", tmpSerialLotNumbers);
	Query.SetParameter("tmpSourceOfOrigins", tmpSourceOfOrigins);
	
	QueryResult = Query.Execute();
	ItemListTable = QueryResult.Unload();
	ConsignorBatches = GetRegistrateConsignorBatches(DocObject, ItemListTable, tmpConsignorBatches, SilentMode);
	
	Table_ConsignorBatches = New Array();
	For Each Row In ConsignorBatches Do
		NewRow = New Structure("Key, ItemKey, SerialLotNumber, SourceOfOrigin, Store, Batch, Quantity");
		FillPropertyValues(NewRow, Row);
		Table_ConsignorBatches.Add(NewRow);
	EndDo;
	
	Return Table_ConsignorBatches;
EndFunction

Function GetRegistrateConsignorBatches(DocObject, ItemListTable, ConsignorBatches = Undefined, SilentMode = False) Export
	If ConsignorBatches = Undefined Then
		RegisterConsignorBatches = GetRegisterConsignorBatches(DocObject);
	Else
		RegisterConsignorBatches = ConsignorBatches.Copy();
	EndIf;
	
	ArrayForDelete = New Array();
	For Each Row In RegisterConsignorBatches Do
		If Not ItemListTable.FindRows(New Structure("Key, SerialLotNumber, SourceOfOrigin", Row.Key, Row.SerialLotNumber, Row.SourceOfOrigin)).Count() Then
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
	ItemListFiltered.Columns.Add("SourceOfOrigin", New TypeDescription("CatalogRef.SourceOfOrigins"));
	ItemListFiltered.Columns.Add("Store"    , New TypeDescription("CatalogRef.Stores"));
	ItemListFiltered.Columns.Add("Quantity" , Metadata.DefinedTypes.typeQuantity.Type);
	
	ArrayForDelete = New Array();
	For Each Row In ItemListTable Do
		If Row.InventoryOrigin <> Enums.InventoryOriginTypes.ConsignorStocks Then
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
		
		BatchRows = RegisterConsignorBatches.FindRows(New Structure("Key, SerialLotNumber, SourceOfOrigin", Row.Key, Row.SerialLotNumber, Row.SourceOfOrigin));
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
				If ArrayForDelete.Find(BatchRow) = Undefined Then
					ArrayForDelete.Add(BatchRow);
				EndIf;
			EndDo;
			
			NewRow = ItemListFiltered.Add();
			NewRow.Key      = Row.Key;
			NewRow.Company  = Row.Company;
			NewRow.ItemKey  = Row.ItemKey;
			NewRow.SerialLotNumber  = Row.SerialLotNumber;
			NewRow.SourceOfOrigin   = Row.SourceOfOrigin;
			NewRow.Store    = Row.Store;
			NewRow.Quantity = Row.Quantity;
		EndIf;
	EndDo;
	
	For Each ItemForDelete In ArrayForDelete Do
		RegisterConsignorBatches.Delete(ItemForDelete);
	EndDo;
	
	If ItemListFiltered.Count() Then
		LockConsignorBatchWiseBalance(DocObject, ItemListFiltered);		
		ConsignorBatchesTable = GetConsignorBatches_Sales_Transfer(ItemListFiltered, DocObject, SilentMode);	
		
		For Each Row In RegisterConsignorBatches Do
			Filter = New Structure();
			Filter.Insert("Key"             , Row.Key);
			Filter.Insert("ItemKey"         , Row.ItemKey);
			Filter.Insert("SerialLotNumber" , Row.SerialLotNumber);
			Filter.Insert("SourceOfOrigin"  , Row.SourceOfOrigin);
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

Function GetTableConsignorBatchWiseBalanceForPurchaseReturn(DocObject, ItemListTable, SilentMode = False) Export
	If Not ItemListTable.Count() Then
		Return GetEmptyConsignorBatchesTable();
	EndIf;
	
	LockConsignorBatchWiseBalance(DocObject, ItemListTable);
	
	ConsignorBatchesTable = GetConsignorBatches_ReturnToConsignor(ItemListTable, DocObject, SilentMode);		
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
	|	ItemList.SourceOfOrigin,
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
	|	ItemList.SourceOfOrigin,
	|	SUM(ItemList.Quantity) AS Quantity
	|INTO ItemListGrouped
	|FROM
	|	ItemList AS ItemList
	|GROUP BY
	|	ItemList.Company,
	|	ItemList.SalesDocument,
	|	ItemList.Store,
	|	ItemList.ItemKey,
	|	ItemList.SerialLotNumber,
	|	ItemList.SourceOfOrigin
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Batches.Company,
	|	Batches.Recorder AS SalesDocument,
	|	Batches.Batch,
	|	Batches.ItemKey,
	|	Batches.SerialLotNumber,
	|	Batches.SourceOfOrigin,
	|	Batches.Quantity
	|FROM
	|	AccumulationRegister.R8013B_ConsignorBatchWiseBalance AS Batches
	|WHERE
	|	(Company, ItemKey, SerialLotNumber, SourceOfOrigin, Recorder) IN
	|		(SELECT
	|			ItemList.Company,
	|			ItemList.ItemKey,
	|			ItemList.SerialLotNumber,
	|			ItemList.SourceOfOrigin,
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
	|	ItemList.SourceOfOrigin,
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
	ConsignorBatches.Columns.Add("SourceOfOrigin"  , AccReg.Dimensions.SourceOfOrigin.Type);
	ConsignorBatches.Columns.Add("Quantity" , AccReg.Resources.Quantity.Type);
	ConsignorBatches.Columns.Add("SalesDocument" , AccReg.StandardAttributes.Recorder.Type);
	
	For Each Row_DocumentItemList In DocumentItemList Do
		NeedReceipt = Row_DocumentItemList.Quantity;
		
		Filter = New Structure();
		Filter.Insert("Company"         , Row_DocumentItemList.Company);
		Filter.Insert("SalesDocument"   , Row_DocumentItemList.SalesDocument);
		Filter.Insert("ItemKey"         , Row_DocumentItemList.ItemKey);
		Filter.Insert("SerialLotNumber" , Row_DocumentItemList.SerialLotNumber);
		Filter.Insert("SourceOfOrigin"  , Row_DocumentItemList.SourceOfOrigin);
		
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
			NewRow.SourceOfOrigin  = Row_RegisterBatches.SourceOfOrigin;
			NewRow.Quantity = CanReceipt;
			NewRow.SalesDocument = Row_DocumentItemList.SalesDocument;
			
			NeedReceipt = NeedReceipt - CanReceipt;
			Row_RegisterBatches.Quantity = Row_RegisterBatches.Quantity - CanReceipt;
		EndDo;
		
	EndDo; 
	Return ConsignorBatches;
EndFunction

Function GetConsignorBatches_Sales_Transfer(ItemListTable, DocObject, SilentMode)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ItemListTable.Company,
	|	ItemListTable.ItemKey,
	|	ItemListTable.SerialLotNumber,
	|	ItemListTable.SourceOfOrigin,
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
	|	ItemListTable.SourceOfOrigin,
	|	ItemListTable.Store,
	|	SUM(ItemListTable.Quantity) AS Quantity
	|INTO ItemListTableGrouped
	|FROM
	|	ItemListTable AS ItemListTable
	|GROUP BY
	|	ItemListTable.Company,
	|	ItemListTable.ItemKey,
	|	ItemListTable.SerialLotNumber,
	|	ItemListTable.SourceOfOrigin,
	|	ItemListTable.Store
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemListTableGrouped.ItemKey AS ItemKey,
	|	ItemListTableGrouped.SerialLotNumber AS SerialLotNumber,
	|	ItemListTableGrouped.SourceOfOrigin AS SourceOfOrigin,
	|	ItemListTableGrouped.Store AS Store,
	|	Batches.Batch AS Batch,
	|	ItemListTableGrouped.Quantity AS Quantity,
	|	ISNULL(Batches.QuantityBalance, 0) AS QuantityBalance
	|FROM
	|	ItemListTableGrouped AS ItemListTableGrouped
	|		LEFT JOIN AccumulationRegister.R8013B_ConsignorBatchWiseBalance.Balance(&Boundary, (Company, ItemKey, SerialLotNumber, SourceOfOrigin, Store) IN
	|			(SELECT
	|				ItemListTableGrouped.Company,
	|				ItemListTableGrouped.ItemKey,
	|				ItemListTableGrouped.SerialLotNumber,
	|				ItemListTableGrouped.SourceOfOrigin,
	|				ItemListTableGrouped.Store
	|			FROM
	|				ItemListTableGrouped AS ItemListTableGrouped)) AS Batches
	|		ON ItemListTableGrouped.Company = Batches.Company
	|		AND ItemListTableGrouped.ItemKey = Batches.ItemKey
	|		AND ItemListTableGrouped.SerialLotNumber = Batches.SerialLotNumber
	|		AND ItemListTableGrouped.SourceOfOrigin = Batches.SourceOfOrigin
	|		AND ItemListTableGrouped.Store = Batches.Store
	|
	|ORDER BY
	|	Batches.Batch.Date
	|TOTALS
	|	MAX(Quantity)
	|BY
	|	ItemKey,
	|	SerialLotNumber,
	|	SourceOfOrigin,
	|	Store";
	
	Query.SetParameter("ItemListTable", ItemListTable);
	
	If ValueIsFilled(DocObject.Ref) Then
		Query.SetParameter("Boundary", New Boundary(DocObject.Ref.PointInTime(), BoundaryType.Excluding));
	Else
		Query.SetParameter("Boundary", CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(DocObject.Ref, DocObject.Date));
	EndIf;
	
	QueryResult = Query.Execute();
	BatchTree = QueryResult.Unload(QueryResultIteration.ByGroups);
	
	BatchResult = GetResultTable(BatchTree, SilentMode);	
	ConsignorBatchesTable = GetEmptyConsignorBatchesTable();
	
	If Not BatchResult.HaveError Then
		PutResultToConsignorBatches(ItemListTable, BatchResult.ResultTable, ConsignorBatchesTable);
	EndIf;
	ConsignorBatchesTable.GroupBy("Key, ItemKey, SerialLotNumber, SourceOfOrigin, Store, Batch","Quantity");
	Return ConsignorBatchesTable;
EndFunction

Function GetConsignorBatches_ReturnToConsignor(ItemListTable, DocObject, SilentMode)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ItemListTable.Company,
	|	ItemListTable.Partner,
	|	ItemListTable.Agreement,
	|	ItemListTable.Batch,
	|	ItemListTable.ItemKey,
	|	ItemListTable.SerialLotNumber,
	|	ItemListTable.SourceOfOrigin,
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
	|	ItemListTable.SourceOfOrigin,
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
	|	ItemListTable.SourceOfOrigin,
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
	|	ItemListTable.SourceOfOrigin,
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
	|	ItemListTable.SourceOfOrigin,
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
	|	ItemListTable_Batches.SourceOfOrigin,
	|	ItemListTable_Batches.Store,
	|	Batches.Batch AS Batch,
	|	SUM(ItemListTable_Batches.Quantity) AS Quantity,
	|	SUM(ISNULL(Batches.QuantityBalance, 0)) AS QuantityBalance
	|INTO ConsignorBatchWiseBalance_Batches
	|FROM
	|	ItemListTable_Batches AS ItemListTable_Batches
	|		LEFT JOIN AccumulationRegister.R8013B_ConsignorBatchWiseBalance.Balance(&Boundary, (Company, Batch.Partner,
	|			Batch.Agreement, Batch, ItemKey, SerialLotNumber, SourceOfOrigin, Store) IN
	|			(SELECT
	|				ItemListTable_Batches.Company,
	|				ItemListTable_Batches.Partner,
	|				ItemListTable_Batches.Agreement,
	|				ItemListTable_Batches.Batch,
	|				ItemListTable_Batches.ItemKey,
	|				ItemListTable_Batches.SerialLotNumber,
	|				ItemListTable_Batches.SourceOfOrigin,
	|				ItemListTable_Batches.Store
	|			FROM
	|				ItemListTable_Batches AS ItemListTable_Batches)) AS Batches
	|		ON ItemListTable_Batches.Company = Batches.Company
	|		AND ItemListTable_Batches.Partner = Batches.Batch.Partner
	|		AND ItemListTable_Batches.Agreement = Batches.Batch.Agreement
	|		AND ItemListTable_Batches.Batch = Batches.Batch
	|		AND ItemListTable_Batches.ItemKey = Batches.ItemKey
	|		AND ItemListTable_Batches.SerialLotNumber = Batches.SerialLotNumber
	|		AND ItemListTable_Batches.SourceOfOrigin = Batches.SourceOfOrigin
	|		AND ItemListTable_Batches.Store = Batches.Store
	|GROUP BY
	|	ItemListTable_Batches.Company,
	|	ItemListTable_Batches.Partner,
	|	ItemListTable_Batches.Agreement,
	|	ItemListTable_Batches.ItemKey,
	|	ItemListTable_Batches.SerialLotNumber,
	|	ItemListTable_Batches.SourceOfOrigin,
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
	|	ItemListTable_Grouped.SourceOfOrigin,
	|	ItemListTable_Grouped.Store,
	|	Batches.Batch AS Batch,
	|	SUM(ItemListTable_Grouped.Quantity) AS Quantity,
	|	SUM(ISNULL(Batches.QuantityBalance, 0)) AS QuantityBalance
	|INTO ConsignorBatchWiseBalance_Grouped
	|FROM
	|	ItemListTable_Grouped AS ItemListTable_Grouped
	|		LEFT JOIN AccumulationRegister.R8013B_ConsignorBatchWiseBalance.Balance(&Boundary, (Company, Batch.Partner,
	|			Batch.Agreement, ItemKey, SerialLotNumber, SourceOfOrigin, Store) IN
	|			(SELECT
	|				ItemListTable_Grouped.Company,
	|				ItemListTable_Grouped.Partner,
	|				ItemListTable_Grouped.Agreement,
	|				ItemListTable_Grouped.ItemKey,
	|				ItemListTable_Grouped.SerialLotNumber,
	|				ItemListTable_Grouped.SourceOfOrigin,
	|				ItemListTable_Grouped.Store
	|			FROM
	|				ItemListTable_Grouped AS ItemListTable_Grouped)) AS Batches
	|		ON ItemListTable_Grouped.Company = Batches.Company
	|		AND ItemListTable_Grouped.Partner = Batches.Batch.Partner
	|		AND ItemListTable_Grouped.Agreement = Batches.Batch.Agreement
	|		AND ItemListTable_Grouped.ItemKey = Batches.ItemKey
	|		AND ItemListTable_Grouped.SerialLotNumber = Batches.SerialLotNumber
	|		AND ItemListTable_Grouped.SourceOfOrigin = Batches.SourceOfOrigin
	|		AND ItemListTable_Grouped.Store = Batches.Store
	|GROUP BY
	|	ItemListTable_Grouped.Company,
	|	ItemListTable_Grouped.Partner,
	|	ItemListTable_Grouped.Agreement,
	|	ItemListTable_Grouped.ItemKey,
	|	ItemListTable_Grouped.SerialLotNumber,
	|	ItemListTable_Grouped.SourceOfOrigin,
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
	|	ConsignorBatchWiseBalance_Grouped.SourceOfOrigin,
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
	|		AND ConsignorBatchWiseBalance_Grouped.SourceOfOrigin = ConsignorBatchWiseBalance_Batches.SourceOfOrigin
	|		AND ConsignorBatchWiseBalance_Grouped.Store = ConsignorBatchWiseBalance_Batches.Store
	|		AND ConsignorBatchWiseBalance_Grouped.Batch = ConsignorBatchWiseBalance_Batches.Batch
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Table.ItemKey,
	|	Table.SerialLotNumber,
	|	Table.SourceOfOrigin,
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
	|	SourceOfOrigin,
	|	Store
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Table.ItemKey,
	|	Table.SerialLotNumber,
	|	Table.SourceOfOrigin,
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
	|	SourceOfOrigin,
	|	Store";
	
	Query.SetParameter("ItemListTable", ItemListTable);
	
	If ValueIsFilled(DocObject.Ref) Then
		Query.SetParameter("Boundary", New Boundary(DocObject.Ref.PointInTime(), BoundaryType.Excluding));
	Else
		Query.SetParameter("Boundary", CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(DocObject.Ref, DocObject.Date));
	EndIf;
	
	QueryResults = Query.ExecuteBatch();
	BatchTree = QueryResults[6].Unload(QueryResultIteration.ByGroups);
	BatchResult_1 = GetResultTable(BatchTree, SilentMode);
	BatchTree = QueryResults[7].Unload(QueryResultIteration.ByGroups);
	BatchResult_2 = GetResultTable(BatchTree, SilentMode);
	
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
	If Not TransactionActive() Then
		Return;
	EndIf;
	
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

Function GetResultTable(BatchTree, SilentMode)
	ResultTable = New ValueTable();
	ResultTable.Columns.Add("ItemKey");
	ResultTable.Columns.Add("SerialLotNumber");
	ResultTable.Columns.Add("SourceOfOrigin");
	ResultTable.Columns.Add("Store");
	ResultTable.Columns.Add("Batch");
	ResultTable.Columns.Add("Quantity");

	HaveError = False;
	For Each Row_ItemKey In BatchTree.Rows Do // BatchTree
		For Each Row_SerialLotNumber In Row_ItemKey.Rows Do // ItemKey
			For Each Row_SourceOfOrigin In Row_SerialLotNumber.Rows Do // SerialLotNumber
				For Each Row_Store In Row_SourceOfOrigin.Rows Do // SourceOfOrigin
			
					NeedExpense = Row_Store.Quantity;
		
					For Each Row_Batch In Row_Store.Rows Do
						If NeedExpense = 0 Or Row_Batch.QuantityBalance = 0 Then
							Continue;
						EndIf;
		
						CanExpense = Min(NeedExpense, Row_Batch.QuantityBalance);
			
						NewRow = ResultTable.Add();
						NewRow.ItemKey  = Row_ItemKey.ItemKey;
						NewRow.SerialLotNumber  = Row_SerialLotNumber.SerialLotNumber;
						NewRow.SourceOfOrigin   = Row_SourceOfOrigin.SourceOfOrigin;
						NewRow.Store    = Row_Store.Store;
						NewRow.Batch    = Row_Batch.Batch;
						NewRow.Quantity = CanExpense;
			
						Row_Batch.QuantityBalance = Row_Batch.QuantityBalance - CanExpense;
						NeedExpense = NeedExpense - CanExpense;
					EndDo; // Row_Store.Rows
		
					If NeedExpense <> 0 Then
//						If Not SilentMode Then
//							Required  = Format(Row_Store.Quantity, "NFD=3;");
//							Remaining = Format(Row_Store.Quantity - NeedExpense, "NFD=3;");
//							Lack = Format(NeedExpense, "NFD=3;");
//			
//							Msg = StrTemplate(R().Error_120, Row_ItemKey.ItemKey, Row_Store.Store, Required, Remaining, Lack);
//							CommonFunctionsClientServer.ShowUsersMessage(Msg);
//						EndIf;
						HaveError = True;			
					EndIf;
				EndDo; // SourceOfOrigin
			EndDo; // SerialLotNumber
		EndDo; // ItemKey
	EndDo; // BatchTree
	
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
				
			If Row.SourceOfOrigin <> Row_Result.SourceOfOrigin Then
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
			NewRow.SourceOfOrigin   = Row.SourceOfOrigin;
			NewRow.Store    = Row.Store;
			NewRow.Batch    = Row_Result.Batch;
			NewRow.Quantity = CanExpense;
		EndDo;
	EndDo;
EndProcedure

Function GetEmptyConsignorBatchesTable()
	InfoReg = Metadata.InformationRegisters.T8010S_ConsignorBatches.Dimensions;
	ConsignorBatchesTable = New ValueTable();
	ConsignorBatchesTable.Columns.Add("Key"      , InfoReg.Key.Type);
	ConsignorBatchesTable.Columns.Add("ItemKey"  , InfoReg.ItemKey.Type);
	ConsignorBatchesTable.Columns.Add("SerialLotNumber", InfoReg.SerialLotNumber.Type);
	ConsignorBatchesTable.Columns.Add("SourceOfOrigin" , InfoReg.SourceOfOrigin.Type);
	ConsignorBatchesTable.Columns.Add("Store"    , InfoReg.Store.Type);
	ConsignorBatchesTable.Columns.Add("Batch"    , InfoReg.Batch.Type);
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
	|	T8010S_ConsignorBatches.SourceOfOrigin,
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
	If Not ValueIsFilled(DocObject.Ref) Then
		Return;
	EndIf;
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
	|	SalesReportToConsignor.Ref AS SalesReportRef,
	|	PRESENTATION(SalesReportToConsignor.Ref.LegalName) AS LegalNamePresentation,
	|	PRESENTATION(SalesReportToConsignor.Ref.Agreement) AS PartnerTermPresentation
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
	FillingData.Insert("ItemList"         , New Array());
	FillingData.Insert("TaxList"          , New Array());
	FillingData.Insert("SerialLotNumbers" , New Array());
	FillingData.Insert("SourceOfOrigins"  , New Array());
	
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
	
	For Each Row In DocRef.SourceOfOrigins Do
		NewRow = New Structure("Key, SerialLotNumber, SourceOfOrigin, Quantity");
		FillPropertyValues(NewRow, Row);
		FillingData.SourceOfOrigins.Add(NewRow);
	EndDo;
	
	Return FillingData;
EndFunction	

Function GetExistingRows(Object, StoreInHeader, FilterStructure, FilterValues, FirstCall = True) Export
	Result = New Structure();
	Result.Insert("ArrayOfRowKeys", New Array());
	Result.Insert("InventoryOrigin", Enums.InventoryOriginTypes.OwnStocks);
	
	DocMetadata = Object.Ref.Metadata();
	DocObject = FormDataToValue(Object, Type("DocumentObject." + DocMetadata.Name));
	DocInfo = New Structure("DocMetadata, DocObject", DocMetadata, DocObject);
	
	Wrapper = BuilderAPI.Initialize(Object, , ,"ItemList", DocInfo);
	
	NewRow_ItemList = BuilderAPI.AddRow(Wrapper, "ItemList");
	BuilderAPI.SetRowProperty(Wrapper, NewRow_ItemList, "Item"     , FilterValues.Item);
	BuilderAPI.SetRowProperty(Wrapper, NewRow_ItemList, "ItemKey"  , FilterValues.ItemKey);
	BuilderAPI.SetRowProperty(Wrapper, NewRow_ItemList, "Unit"     , FilterValues.Unit);
	BuilderAPI.SetRowProperty(Wrapper, NewRow_ItemList, "Quantity" , FilterValues.Quantity);
	
	If ValueIsFilled(StoreInHeader) Then
		BuilderAPI.SetRowProperty(Wrapper, NewRow_ItemList, "Store", StoreInHeader);
	EndIf;
	
	If ValueIsFilled(FilterValues.SerialLotNumber) Then
		NewRow_SerialLotNumber = Wrapper.Object.SerialLotNumbers.Add();
		NewRow_SerialLotNumber.Key = NewRow_ItemList.Key;
		
		NewRow_SerialLotNumber.SerialLotNumber = FilterValues.SerialLotNumber;
		NewRow_SerialLotNumber.Quantity        = FilterValues.Quantity;
	EndIf;
	
	If ValueIsFilled(FilterValues.SourceOfOrigin) Then
		NewRow_SourceOfOrigin = Wrapper.Object.SourceOfOrigins.Add();
		NewRow_SourceOfOrigin.Key = NewRow_ItemList.Key;
		
		NewRow_SourceOfOrigin.SerialLotNumber = FilterValues.SerialLotNumber;
		NewRow_SourceOfOrigin.SourceOfOrigin  = FilterValues.SourceOfOrigin;
		NewRow_SourceOfOrigin.Quantity        = FilterValues.Quantity;
	EndIf;
	
	BuilderAPI.SetRowProperty(Wrapper, NewRow_ItemList, "InventoryOrigin", Enums.InventoryOriginTypes.ConsignorStocks);
	
	ObjectRefType = TypeOf(Object.Ref);
	If ObjectRefType = Type("DocumentRef.InventoryTransfer") Then
		StoreRef = Wrapper.Object.StoreSender;
		Filter = New Structure("ItemKey", NewRow_ItemList.ItemKey);
	Else 
		StoreRef = NewRow_ItemList.Store;
		Filter = New Structure("Store, ItemKey", StoreRef, NewRow_ItemList.ItemKey);
	EndIf;
	
	ItemListRows = Object.ItemList.FindRows(Filter);
	
	QuantityInDocument = 0;
	For Each Row In ItemListRows Do
		QuantityInDocument = QuantityInDocument + Row.QuantityInBaseUnit;
	EndDo;
	
	ActualStocksBalance    = GetActualStocksBalance(Object, StoreRef, NewRow_ItemList.ItemKey, FilterValues.SerialLotNumber);
	ConsignorStocksBalance = GetConsignorStocksBalance(Object, Object.Company, StoreRef, NewRow_ItemList.ItemKey, FilterValues.SerialLotNumber);
		
	HowManyOwnStocks = ActualStocksBalance - ConsignorStocksBalance - QuantityInDocument; 
	
	ConsignorStockIsAvailable = False;
	
	If HowManyOwnStocks - NewRow_ItemList.QuantityInBaseUnit >= 0 Then
		Return AsOwnStocks(Object, Result, FilterStructure, FilterValues);		
	Else
		ConsignorStockAvailableQuantity = 0;
		For Each Row In Wrapper.Object.ConsignorBatches Do
			If Row.Key <> NewRow_ItemList.Key Then
				Continue;
			EndIf;
			ConsignorStockAvailableQuantity = ConsignorStockAvailableQuantity + Row.Quantity;
		EndDo;
			
		If NewRow_ItemList.QuantityInBaseUnit = ConsignorStockAvailableQuantity Then
			ConsignorStockIsAvailable = True;
		Else
			ConsignorStockIsAvailable = False;
		EndIf;
	EndIf;
	
	If ConsignorStockIsAvailable Then
		Return AsConsignorStocks(Object, Wrapper, NewRow_ItemList, Result, FilterStructure, FilterValues);
	Else
		If FirstCall And Not ValueIsFilled(FilterValues.SourceOfOrigin) Then
			
			ConsignorBatchesOnStock = GetConsignorBatchesOnStock(Object, Object.Company, StoreRef, NewRow_ItemList.ItemKey, FilterValues.SerialLotNumber);
			// Batch, Store, ItemKey, SerialLotNumber, SourceOfOrigin
			
			ConsignorBatchesGrouped = Object.ConsignorBatches.Unload();
			ConsignorBatchesGrouped.GroupBy("Batch, Store, ItemKey, SerialLotNumber, SourceOfOrigin", "Quantity");
			
			For Each Row_ConsignorBatchesGrouped In ConsignorBatchesGrouped Do
				Filter = New Structure("Batch, Store, ItemKey, SerialLotNumber, SourceOfOrigin");
				FillPropertyValues(Filter, Row_ConsignorBatchesGrouped);
				Rows_ConsignorBatchesOnStock = ConsignorBatchesOnStock.FindRows(Filter);
				For Each Row_ConsignorBatchesOnStock In Rows_ConsignorBatchesOnStock Do
					Row_ConsignorBatchesOnStock.Quantity = Row_ConsignorBatchesOnStock.Quantity - Row_ConsignorBatchesGrouped.Quantity;
				EndDo;
			EndDo;
			
			HaveOtherConsugnorBatches = False;
			For Each Row_ConsignorBatchesOnStock In ConsignorBatchesOnStock Do
				If Row_ConsignorBatchesOnStock.Quantity > 0 Then 
					If ValueIsFilled(Row_ConsignorBatchesOnStock.SourceOfOrigin) Then
						FilterValues.SourceOfOrigin = Row_ConsignorBatchesOnStock.SourceOfOrigin;
						HaveOtherConsugnorBatches = True;
						Return GetExistingRows(Object, StoreInHeader, FilterStructure, FilterValues, False);
					Else
						Break;
					EndIf; // Source of origin  = Is Filled
				EndIf; // > 0
			EndDo; // ConsignorBatchesOnStock
			
			If Not HaveOtherConsugnorBatches Then
				Return AsOwnStocks(Object, Result, FilterStructure, FilterValues);
			EndIf;
			
		Else // Second call
			Return AsOwnStocks(Object, Result, FilterStructure, FilterValues);
		EndIf;
	EndIf;
		
	Return Result;
EndFunction

Function AsOwnStocks(Object, Result, FilterStructure, FilterValues)
	FillPropertyValues(FilterStructure, FilterValues);
	FilterStructure.Insert("InventoryOrigin", Enums.InventoryOriginTypes.OwnStocks);

	ItemListRows = Object.ItemList.FindRows(FilterStructure);
	For Each Row In ItemListRows Do
		SkipItemListRow = False;
		If CommonFunctionsClientServer.ObjectHasProperty(Object, "SourceOfOrigins") Then
			_SourceOfOriginRef = ?(ValueIsFilled(FilterValues.SourceOfOrigin), FilterValues.SourceOfOrigin, Catalogs.SourceOfOrigins.EmptyRef());
			For Each _Row In Object.SourceOfOrigins Do
				If _Row.Key = Row.Key Then
					If _Row.SourceOfOrigin <> _SourceOfOriginRef Then
						SkipItemListRow = True;
						Break;
					EndIf;
				EndIf;
			EndDo; 
		EndIf;
		If SkipItemListRow Then
			Continue;
		EndIf;
			
		Result.ArrayOfRowKeys.Add(Row.Key);
	EndDo;
	Return Result;
EndFunction

Function AsConsignorStocks(Object, Wrapper, NewRow_ItemList, Result, FilterStructure, FilterValues)
	FillPropertyValues(FilterStructure, FilterValues);
	FilterStructure.Insert("InventoryOrigin", Enums.InventoryOriginTypes.ConsignorStocks);
	ItemListRows = Object.ItemList.FindRows(FilterStructure);
	
	ObjectRefType = TypeOf(Object.Ref);
	CheckTaxes = ObjectRefType = Type("DocumentRef.RetailSalesReceipt") 
			Or ObjectRefType = Type("DocumentRef.SalesInvoice");

	// check taxes
	If CheckTaxes Then
		ArrayOfTaxes = New Array();
		For Each TaxRow In Wrapper.Object.TaxList Do
			If TaxRow.Key = NewRow_ItemList.Key And ValueIsFilled(TaxRow.Tax) Then
				ArrayOfTaxes.Add(New Structure("Tax, TaxRate", TaxRow.Tax, TaxRow.TaxRate));
			EndIf;
		EndDo;
	EndIf;
	
	For Each Row In ItemListRows Do
			
		SkipItemListRow = False;
		If CommonFunctionsClientServer.ObjectHasProperty(Object, "SourceOfOrigins") Then
			_SourceOfOriginRef = ?(ValueIsFilled(FilterValues.SourceOfOrigin), FilterValues.SourceOfOrigin, Catalogs.SourceOfOrigins.EmptyRef());
			For Each _Row In Object.SourceOfOrigins Do
				If _Row.Key = Row.Key Then
					If _Row.SourceOfOrigin <> _SourceOfOriginRef Then
						SkipItemListRow = True;
						Break;
					EndIf;
				EndIf;
			EndDo; 
		EndIf;
		If SkipItemListRow Then
			Continue;
		EndIf;
		
		If CheckTaxes Then	
			TaxListRows = Object.TaxList.FindRows(New Structure("Key", Row.Key));
			IsAllTaxesTheSame = False;
			If ArrayOfTaxes.Count() = TaxListRows.Count() Then
				IsTaxesTheSame = True;
				For i = 0 To ArrayOfTaxes.Count() - 1 Do
					If ArrayOfTaxes[i].Tax <> TaxListRows[i].Tax Or ArrayOfTaxes[i].TaxRate <> TaxListRows[i].TaxRate Then
						IsTaxesTheSame = False;
					EndIf;
				EndDo;
				If IsTaxesTheSame Then
					IsAllTaxesTheSame = True;
				EndIf;
			EndIf;			
			If IsAllTaxesTheSame Then
				Result.ArrayOfRowKeys.Add(Row.Key);
			EndIf;
		Else
			Result.ArrayOfRowKeys.Add(Row.Key);
		EndIf;
	EndDo;
	
	Result.InventoryOrigin = Enums.InventoryOriginTypes.ConsignorStocks;
	Return Result;
EndFunction

Function GetActualStocksBalance(DocObject, Store, ItemKey, SerialLotNumber)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R4010B_ActualStocksBalance.QuantityBalance
	|FROM
	|	AccumulationRegister.R4010B_ActualStocks.Balance(&Boundary, Store = &Store
	|	AND ItemKey = &ItemKey
	|	AND CASE
	|		WHEN &StockBalanceDetail
	|			THEN SerialLotNumber = &SerialLotNumber
	|		ELSE TRUE
	|	END) AS R4010B_ActualStocksBalance";
	If ValueIsFilled(DocObject.Ref) Then
		Query.SetParameter("Boundary", New Boundary(DocObject.Ref.PointInTime(), BoundaryType.Excluding));
	Else
		Query.SetParameter("Boundary", CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(DocObject.Ref, DocObject.Date));
	EndIf;
	Query.SetParameter("Store"   , Store);
	Query.SetParameter("ItemKey" , ItemKey);
	Query.SetParameter("SerialLotNumber", SerialLotNumber);
	If ValueIsFilled(SerialLotNumber) Then
		Query.SetParameter("StockBalanceDetail" , SerialLotNumber.StockBalanceDetail);
	Else
		Query.SetParameter("StockBalanceDetail" , False);
	EndIf;
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.QuantityBalance;
	EndIf;
	Return 0;
EndFunction

Function GetConsignorStocksBalance(DocObject, Company, Store, ItemKey, SerialLotNumber)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R8013B_ConsignorBatchWiseBalance.QuantityBalance
	|FROM
	|	AccumulationRegister.R8013B_ConsignorBatchWiseBalance.Balance(&Boundary, Store = &Store
	|	AND ItemKey = &ItemKey
	|	AND Company = &Company
	|	AND SerialLotNumber = &SerialLotNumber) AS R8013B_ConsignorBatchWiseBalance";
	If ValueIsFilled(DocObject.Ref) Then
		Query.SetParameter("Boundary", New Boundary(DocObject.Ref.PointInTime(), BoundaryType.Excluding));
	Else
		Query.SetParameter("Boundary", CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(DocObject.Ref, DocObject.Date));
	EndIf;
	Query.SetParameter("Company" , Company);
	Query.SetParameter("Store"   , Store);
	Query.SetParameter("ItemKey" , ItemKey);
	If ValueIsFilled(SerialLotNumber) Then
		Query.SetParameter("SerialLotNumber", SerialLotNumber);
	Else
		Query.SetParameter("SerialLotNumber", Catalogs.SerialLotNumbers.EmptyRef());
	EndIf;
			
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.QuantityBalance;
	EndIf;
	Return 0;
EndFunction
	
Function GetConsignorBatchesOnStock(DocObject, Company, Store, ItemKey, SerialLotNumber)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R8013B_ConsignorBatchWiseBalance.Batch,
	|	R8013B_ConsignorBatchWiseBalance.Store,
	|	R8013B_ConsignorBatchWiseBalance.ItemKey,
	|	R8013B_ConsignorBatchWiseBalance.SerialLotNumber,
	|	R8013B_ConsignorBatchWiseBalance.SourceOfOrigin,
	|	SUM(R8013B_ConsignorBatchWiseBalance.QuantityBalance) AS Quantity,
	|	R8013B_ConsignorBatchWiseBalance.Batch.Date AS BatchDate
	|FROM
	|	AccumulationRegister.R8013B_ConsignorBatchWiseBalance.Balance(&Boundary, Store = &Store
	|	AND ItemKey = &ItemKey
	|	AND Company = &Company
	|	AND SerialLotNumber = &SerialLotNumber) AS R8013B_ConsignorBatchWiseBalance
	|GROUP BY
	|	R8013B_ConsignorBatchWiseBalance.Batch,
	|	R8013B_ConsignorBatchWiseBalance.Store,
	|	R8013B_ConsignorBatchWiseBalance.ItemKey,
	|	R8013B_ConsignorBatchWiseBalance.SerialLotNumber,
	|	R8013B_ConsignorBatchWiseBalance.SourceOfOrigin,
	|	R8013B_ConsignorBatchWiseBalance.Batch.Date";
	If ValueIsFilled(DocObject.Ref) Then
		Query.SetParameter("Boundary", New Boundary(DocObject.Ref.PointInTime(), BoundaryType.Excluding));
	Else
		Query.SetParameter("Boundary", CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(DocObject.Ref, DocObject.Date));
	EndIf;
	Query.SetParameter("Company" , Company);
	Query.SetParameter("Store"   , Store);
	Query.SetParameter("ItemKey" , ItemKey);
	If ValueIsFilled(SerialLotNumber) Then
		Query.SetParameter("SerialLotNumber", SerialLotNumber);
	Else
		Query.SetParameter("SerialLotNumber", Catalogs.SerialLotNumbers.EmptyRef());
	EndIf;
			
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	QueryTable.Sort("BatchDate");
	Return QueryTable;	
EndFunction

