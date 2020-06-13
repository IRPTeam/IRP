#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		
		ObjectData = DocumentsClientServer.GetStructureFillStores();
		FillPropertyValues(ObjectData, Object);
		DocumentsClientServer.FillStores(ObjectData, Form);
		
		FillItemList(Object, Form);
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	
	FillTransactionTypeChoiceList(Form);	
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	
	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, CurrentObject);
	DocumentsClientServer.FillStores(ObjectData, Form);
	
	FillItemList(Object, Form);
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	
	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, CurrentObject);
	DocumentsClientServer.FillStores(ObjectData, Form);
	
	FillItemList(Object, Form);
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

#EndRegion

Function GetUnitFactor(FromUnit, ToUnit) Export
	Return Catalogs.Units.GetUnitFactor(FromUnit, ToUnit);
EndFunction

Procedure FillItemList(Object, Form)
	DocumentsServer.FillItemList(Object, Form);
	
	For Each Row In Object.ItemList Do
		Row.ReceiptBasisCurrency = ServiceSystemServer.GetCompositeObjectAttribute(Row.ReceiptBasis, "Currency");
	EndDo;
EndProcedure

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	
	If SessionParameters.isMobile Then
		Return;
	EndIf;
	
	AttributesArray = New Array;
	AttributesArray.Add("Company");
	AttributesArray.Add("Partner");
	AttributesArray.Add("LegalName");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Atr In AttributesArray Do
		Form.GroupItems.Add(Atr, ?(ValueIsFilled(Form.Items[Atr].Title),
				Form.Items[Atr].Title,
				Object.Ref.Metadata().Attributes[Atr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion



Function InfoReceiptBasisesFilling(FilterValues, ExistingRows, Ref) Export
	
	TableItemList = New ValueTable();
	TableItemList.Columns.Add("Store", New TypeDescription("CatalogRef.Stores"));
	TableItemList.Columns.Add("ItemKey", New TypeDescription("CatalogRef.ItemKeys"));
	TableItemList.Columns.Add("Unit", New TypeDescription("CatalogRef.Units"));
	TableItemList.Columns.Add("Quantity", New TypeDescription(Metadata.DefinedTypes.typeQuantity.Type));
	
	For Each ExistingRow In ExistingRows Do
		Row = TableItemList.Add();
		FillPropertyValues(Row, ExistingRow);
	EndDo;
	
	QueryTableOrders = New Query(
			"SELECT
			|	Table.Store,
			|	Table.ItemKey,
			|	Table.Quantity,
			|	Table.Unit
			|INTO docItemList
			|FROM
			|	&docItemList AS Table
			|;
			|////////////////////////////////////////////////////////////////////////////////
			|SELECT ALLOWED
			|	Table.Ref AS ReceiptBasis
			|into tmp
			|FROM
			|	Document.PurchaseOrder AS Table
			|WHERE
			|	Table.Company = &Company
			|	AND Table.Partner = &Partner
			|	AND Table.LegalName = &LegalName
			|	AND Table.GoodsReceiptBeforePurchaseInvoice
			|
			|UNION ALL
			|
			|SELECT
			|	Table.Ref
			|FROM
			|	Document.PurchaseInvoice AS Table
			|WHERE
			|	Table.Company = &Company
			|	AND Table.Partner = &Partner
			|	AND Table.LegalName = &LegalName
			|;
			|////////////////////////////////////////////////////////////////////////////////
			|SELECT ALLOWED
			|	GoodsInTransitIncomingBalance.Store AS Store,
			|	GoodsInTransitIncomingBalance.ReceiptBasis AS ReceiptBasis,
			|	GoodsInTransitIncomingBalance.ReceiptBasis.Currency AS Currency,
			|	GoodsInTransitIncomingBalance.ItemKey,
			|	CASE
			|		WHEN GoodsInTransitIncomingBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
			|			THEN GoodsInTransitIncomingBalance.ItemKey.Unit
			|		ELSE GoodsInTransitIncomingBalance.ItemKey.Item.Unit
			|	END AS Unit,
			|	GoodsInTransitIncomingBalance.QuantityBalance AS Quantity,
			|	GoodsInTransitIncomingBalance.RowKey
			|INTO tmpTable
			|FROM
			|	AccumulationRegister.GoodsInTransitIncoming.Balance(, ReceiptBasis IN
			|		(select
			|			ReceiptBasis
			|		from
			|			tmp)
			|	AND ItemKey IN
			|		(select
			|			ItemKey
			|		from
			|			docItemList)) AS GoodsInTransitIncomingBalance
			|
			|UNION ALL
			|
			|SELECT
			|	DocumentRecords.Store AS Store,
			|	DocumentRecords.ReceiptBasis AS ReceiptBasis,
			|	DocumentRecords.ReceiptBasis.Currency AS Currency,
			|	DocumentRecords.ItemKey,
			|	CASE
			|		WHEN DocumentRecords.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
			|			THEN DocumentRecords.ItemKey.Unit
			|		ELSE DocumentRecords.ItemKey.Item.Unit
			|	END AS Unit,
			|	CASE
			|		WHEN DocumentRecords.RecordType = VALUE(AccumulationRecordType.Receipt)
			|			THEN -DocumentRecords.Quantity
			|		ELSE DocumentRecords.Quantity
			|	END AS Quantity,
			|	DocumentRecords.RowKey
			|FROM
			|	AccumulationRegister.GoodsInTransitIncoming AS DocumentRecords
			|		INNER JOIN tmp AS tmp
			|		ON tmp.ReceiptBasis = DocumentRecords.ReceiptBasis
			|		AND DocumentRecords.Recorder = &Ref
			|		INNER JOIN (SELECT DISTINCT
			|			ItemKey
			|		FROM
			|			docItemList AS docItemList) AS docItemList
			|		ON docItemList.ItemKey = DocumentRecords.ItemKey
			|;
			|////////////////////////////////////////////////////////////////////////////////
			|SELECT ALLOWED
			|	Table.Store AS Store,
			|	Table.ReceiptBasis AS ReceiptBasis,
			|	Table.Currency AS Currency,
			|	Table.ItemKey,
			|	Table.Unit,
			|	SUM(Table.Quantity) AS Quantity,
			|	Table.RowKey
			|FROM
			|	tmpTable AS Table
			|GROUP BY
			|	Table.Store,
			|	Table.ReceiptBasis,
			|	Table.Currency,
			|	Table.ItemKey,
			|	Table.Unit,
			|	Table.RowKey
			|HAVING
			|	SUM(Table.Quantity) > 0");
	QueryTableOrders.SetParameter("Company", FilterValues.Company);
	QueryTableOrders.SetParameter("Partner", FilterValues.Partner);
	QueryTableOrders.SetParameter("LegalName", FilterValues.LegalName);
	QueryTableOrders.SetParameter("docItemList", TableItemList);
	QueryTableOrders.SetParameter("Ref", Ref);
	
	QueryTable = QueryTableOrders.Execute().Unload();
	
	Query = New Query();
	Query.TempTablesManager = PutQueryTableToTempTable(QueryTable);
	Query.Text =
		"SELECT ALLOWED
		|	Table.Store,
		|	Table.ReceiptBasis AS ReceiptBasis,
		|	Table.Currency,
		|	Cat.Item,
		|	Table.ItemKey,
		|	Table.Unit AS Unit,
		|	Table.Quantity,
		|	Table.Key,
		|	Table.RowKey,
		|	Table.SalesOrder
		|FROM
		|	(SELECT
		|		tmpQueryTable.Store,
		|		tmpQueryTable.ReceiptBasis AS ReceiptBasis,
		|		tmpQueryTable.Currency AS Currency,
		|		tmpQueryTable.ItemKey,
		|		tmpQueryTable.Unit AS Unit,
		|		tmpQueryTable.Quantity,
		|		tmpQueryTable.Key,
		|		tmpQueryTable.RowKey,
		|		Doc.SalesOrder AS SalesOrder
		|	FROM
		|		Document.PurchaseInvoice.ItemList AS Doc
		|			INNER JOIN tmpQueryTable AS tmpQueryTable
		|			ON tmpQueryTable.Key = Doc.Key
		|			AND tmpQueryTable.ReceiptBasis = Doc.Ref
		|
		|	UNION ALL
		|
		|	SELECT
		|		tmpQueryTable.Store,
		|		tmpQueryTable.ReceiptBasis,
		|		tmpQueryTable.Currency,
		|		tmpQueryTable.ItemKey,
		|		tmpQueryTable.Unit,
		|		tmpQueryTable.Quantity,
		|		tmpQueryTable.Key,
		|		tmpQueryTable.RowKey,
		|		CAST(Doc.PurchaseBasis AS Document.SalesOrder) AS SalesOrder
		|	FROM
		|		Document.PurchaseOrder.ItemList AS Doc
		|			INNER JOIN tmpQueryTable AS tmpQueryTable
		|			ON tmpQueryTable.Key = Doc.Key
		|			AND tmpQueryTable.ReceiptBasis = Doc.Ref) AS Table
		|	LEFT JOIN Catalog.ItemKeys AS Cat
		|	ON Cat.Ref = Table.ItemKey
		|ORDER BY
		|	ReceiptBasis.Date";
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	ResultArray = New Array;
	ReceiptTableMap = New Map;
	index = 0;
	While index < TableItemList.Count() Do
		RowItemList = TableItemList[index];
		
		ItemKeyBalance = RowItemList.Quantity;
		
		ReceiptTable = ReceiptTableMap.Get(RowItemList.ItemKey);
		If ReceiptTable = Undefined Then
			ReceiptTable = QueryTable.Copy(New Structure("ItemKey", RowItemList.ItemKey));
		EndIf;
		
		For Each ReceiptRow In ReceiptTable Do
			UnitFactor = Catalogs.Units.GetUnitFactor(RowItemList.Unit, ReceiptRow.Unit);
			CurrentQuantity = Min(ItemKeyBalance, ReceiptRow.Quantity / UnitFactor);
			
			If CurrentQuantity > 0 Then
				ReceiptRow.Quantity = ReceiptRow.Quantity - CurrentQuantity * UnitFactor;
				
				ResultStructure = New Structure("Store,ReceiptBasis,Item,ItemKey,Quantity,Unit,Key,SalesOrder");
				FillPropertyValues(ResultStructure, ReceiptRow, , "Quantity, Unit");
				ResultStructure.Unit = RowItemList.Unit;
				ResultStructure.Quantity = CurrentQuantity;
				ResultArray.Add(ResultStructure);
				
				ItemKeyBalance = ItemKeyBalance - CurrentQuantity;
			EndIf;
			If ItemKeyBalance <= 0 Then
				Break;
			EndIf;
		EndDo;
		
		If ItemKeyBalance > 0 Then
			ResultStructure = New Structure("Store,ReceiptBasis,Item,ItemKey,Quantity,Unit,Key,SalesOrder");
			FillPropertyValues(ResultStructure, RowItemList, , "Quantity");
			ResultStructure.Quantity = ItemKeyBalance;
			ResultStructure.Item = RowItemList.ItemKey.Item;
			ResultArray.Add(ResultStructure);
		EndIf;
		
		ReceiptTableMap.Insert(RowItemList.ItemKey, ReceiptTable);
		index = index + 1;
	EndDo;
	
	Return ResultArray;
	
EndFunction

Function PutQueryTableToTempTable(QueryTable) Export
	QueryTable.Columns.Add("Key", New TypeDescription("UUID"));
	For Each Row In QueryTable Do
		Row.Key = New UUID(Row.RowKey);
	EndDo;
	tempManager = New TempTablesManager();
	Query = New Query();
	Query.TempTablesManager = tempManager;
	Query.Text =
		"SELECT
		|	QueryTable.Store,
		|	QueryTable.ReceiptBasis,
		|	QueryTable.Currency,
		|   QueryTable.ItemKey,
		|   QueryTable.Unit,
		|	QueryTable.Quantity,
		|   QueryTable.Key,
		|   QueryTable.RowKey
		|INTO tmpQueryTable
		|FROM
		|	&QueryTable AS QueryTable";
	
	Query.SetParameter("QueryTable", QueryTable);
	Query.Execute();
	Return tempManager;
EndFunction

#Region ListFormEvents

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region ChoiceFormEvents

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region QuantityCompare

&AtServer
Procedure LoadDataFromQuantityCompare(Object, Form, ItemListAddress) Export
	Lists = GetFromTempStorage(ItemListAddress);
	QuantityCompareExpItemList = Lists.ExpItemList;
	QuantityComparePhysItemList = Lists.PhysItemList;
	Object.ItemList.Clear();
	For Each Row In QuantityComparePhysItemList Do
		ExpItemListFilter = New Structure();
		ExpItemListFilter.Insert("ItemKey", Row.ItemKey);
		ExpItemListFilter.Insert("Unit", Row.Unit);
		FoundedExpItemListRows = QuantityCompareExpItemList.FindRows(ExpItemListFilter);
		If FoundedExpItemListRows.Count() Then
			For Each FoundedRow In FoundedExpItemListRows Do
				NewRow = Object.ItemList.Add();
				NewRow.ItemKey = Row.ItemKey;
				NewRow.Item = Row.Item;
				NewRow.Unit = Row.Unit;				
				NewRow.ReceiptBasis = FoundedRow.BaseOn;
				NewRow.Store = Form.CurrentStore;
				If Row.Count <= FoundedRow.Quantity Then
					NewRow.Quantity = Row.Count;
					FoundedRow.Quantity = FoundedRow.Quantity - Row.Count;
					Row.Count = 0;
					Break;
				Else
					NewRow.Quantity = FoundedRow.Quantity;
					Row.Count = Row.Count - FoundedRow.Quantity;
					FoundedRow.Quantity = 0;					
				EndIf;				
			EndDo;
			If Row.Count Then
				NewRow = Object.ItemList.Add();
				NewRow.ItemKey = Row.ItemKey;
				NewRow.Item = Row.Item;
				NewRow.Unit = Row.Unit;
				NewRow.Quantity = Row.Count;
				NewRow.Store = Form.CurrentStore;
			EndIf;
		Else
			NewRow = Object.ItemList.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.Store = Form.CurrentStore;
		EndIf;
	EndDo;
EndProcedure

Function ParametersForQuantityCompare(Val Object, UUID) Export
	ReturnValue = New Structure;
	ExpItemListValue = Object.ItemList.Unload(, "ItemKey, Item, Unit, Quantity, ReceiptBasis");
	ExpItemListValue.Columns.Add("BaseOn", ExpItemListValue.Columns.ReceiptBasis.ValueType);
	ExpItemListValue.LoadColumn(ExpItemListValue.UnloadColumn("ReceiptBasis"), "BaseOn");
	ExpItemListValue.Columns.Delete("ReceiptBasis");
	IncomingExpItemListAddress = PutToTempStorage(ExpItemListValue, UUID);
	ReturnValue.Insert("IncomingExpItemListAddress", IncomingExpItemListAddress);
	Return ReturnValue;
EndFunction

#EndRegion

Procedure FillTransactionTypeChoiceList(Form)
	isSaasMode = Saas.isSaasMode();
	Form.Items.TransactionType.ChoiceList.Add(Enums.GoodsReceiptTransactionTypes.Purchase, Metadata.Enums.GoodsReceiptTransactionTypes.EnumValues.Purchase.Synonym);
	Form.Items.TransactionType.ChoiceList.Add(Enums.GoodsReceiptTransactionTypes.ReturnFromCustomer, Metadata.Enums.GoodsReceiptTransactionTypes.EnumValues.ReturnFromCustomer.Synonym);
	If Not isSaasMode Then
		Form.Items.TransactionType.ChoiceList.Add(Enums.GoodsReceiptTransactionTypes.InventoryTransfer, Metadata.Enums.GoodsReceiptTransactionTypes.EnumValues.InventoryTransfer.Synonym);
		Form.Items.TransactionType.ChoiceList.Add(Enums.GoodsReceiptTransactionTypes.Bundling, Metadata.Enums.GoodsReceiptTransactionTypes.EnumValues.Bundling.Synonym);
	EndIf;
EndProcedure
