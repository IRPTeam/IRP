#Region FormEvents

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	Form.CurrentPartner   = CurrentObject.Partner;
	Form.CurrentAgreement = CurrentObject.Agreement;
	Form.CurrentDate      = CurrentObject.Date;
	DocumentsServer.FillItemList(Object);
	
	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, CurrentObject);
	DocumentsClientServer.FillStores(ObjectData, Form);
	
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	CurrenciesServer.UpdateRatePresentation(Object);
	CurrenciesServer.SetVisibleCurrenciesRow(Object, Undefined, True);
	Form.Taxes_CreateFormControls();
EndProcedure

Procedure BeforeWrite(Object, Form, Cancel, WriteMode, PostingMode) Export
	Return;
EndProcedure

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		Form.CurrentPartner    = Object.Partner;
		Form.CurrentAgreement  = Object.Agreement;
		Form.CurrentDate       = Object.Date;
		Form.StoreBeforeChange = Form.Store;
		
		DocumentsClientServer.FillDefinedData(Object, Form);
		
		SetGroupItemsList(Object, Form);
		DocumentsServer.FillItemList(Object);
		
		ObjectData = DocumentsClientServer.GetStructureFillStores();
		FillPropertyValues(ObjectData, Object);
		DocumentsClientServer.FillStores(ObjectData, Form);
		
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	Form.Taxes_CreateFormControls();
	DocumentsServer.ShowUserMessageOnCreateAtServer(Form);
EndProcedure

Procedure CalculateTableAtServer(Form, Object) Export
	If Form.Parameters.FillingValues.Property("BasedOn")Then
		
		If ValueIsFilled(Object.Agreement) Then
			
			CalculationSettings = CalculationStringsClientServer.GetCalculationSettings();
			PriceDate = CalculationStringsClientServer.GetPriceDateByRefAndDate(Object.Ref, Object.Date);
			CalculationSettings.Insert("UpdatePrice", 
							New Structure("Period, PriceType", PriceDate, Object.Agreement.PriceType));
			
			CalculateRows = New Array();
			
			For Each Row In Object.ItemList Do
				ArrayOfShipmentConfirmations = Object.ShipmentConfirmations.FindRows(New Structure("Key", Row.Key));
				If ArrayOfShipmentConfirmations.Count() And Not ValueIsFilled(Row.SalesOrder) Then
					CalculateRows.Add(Row);
				EndIf;
			EndDo;
			
			SavedData = TaxesClientServer.GetSavedData(Form, TaxesServer.GetAttributeNames().CacheName);
			If SavedData.Property("ArrayOfColumnsInfo") Then
				TaxInfo = SavedData.ArrayOfColumnsInfo;
			EndIf;	
			CalculationStringsClientServer.CalculateItemsRows(Object, Form, CalculateRows, CalculationSettings, TaxInfo);
		
		EndIf;
	EndIf;
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	Form.CurrentPartner   = CurrentObject.Partner;
	Form.CurrentAgreement = CurrentObject.Agreement;
	Form.CurrentDate      = CurrentObject.Date;
	
	DocumentsServer.FillItemList(Object);
		
	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, CurrentObject);
	DocumentsClientServer.FillStores(ObjectData, Form);
	
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	CurrenciesServer.UpdateRatePresentation(Object);
	CurrenciesServer.SetVisibleCurrenciesRow(Object, Undefined, True);
	Form.Taxes_CreateFormControls();
EndProcedure

#EndRegion

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array;
	AttributesArray.Add("Company");
	AttributesArray.Add("Partner");
	AttributesArray.Add("LegalName");
	AttributesArray.Add("Agreement");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Atr In AttributesArray Do
		Form.GroupItems.Add(Atr, ?(ValueIsFilled(Form.Items[Atr].Title),
				Form.Items[Atr].Title,
				Object.Ref.Metadata().Attributes[Atr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion

Function GetManagerSegmentByPartner(Partner) Export
	Return Partner.ManagerSegment;
EndFunction

Procedure StoreOnChange(TempStructure) Export
	For Each Row In TempStructure.Object.ItemList Do
		Row.Store = TempStructure.Store;
	EndDo;
EndProcedure

Function GetStoresArray(Val Object) Export
	ReturnValue = New Array;
	TableOfStore = Object.ItemList.Unload( , "Store");
	TableOfStore.GroupBy("Store");
	ReturnValue = TableOfStore.UnloadColumn("Store");
	Return ReturnValue;
EndFunction

Function GetActualStore(Object) Export
	ReturnValue = Catalogs.Stores.EmptyRef();
	If Object.ItemList.Count() = 0 Then
		Return ReturnValue;
	ElsIf Object.ItemList.Count() = 1 Then
		ReturnValue = Object.AgreementInfo.Store;
	Else
		RowCount = Object.ItemList.Count();
		PreviousRow = Object.ItemList.Get(RowCount - 2);
		ReturnValue = PreviousRow.Store;
	EndIf;
	Return ReturnValue;
EndFunction

Function GetInfoShipmentConfirmationBeforeSalesInvoice(Parameters) Export
	Query = New Query();
	Query.Text =
"SELECT ALLOWED
|	SalesOrder.Ref AS Order
|INTO tmp
|FROM
|	Document.SalesOrder AS SalesOrder
|WHERE
|	SalesOrder.Company = &Company
|	AND SalesOrder.Partner = &Partner
|	AND SalesOrder.LegalName = &LegalName
|	AND SalesOrder.Agreement = &Agreement
|	AND SalesOrder.Currency = &Currency
|	AND SalesOrder.PriceIncludeTax = &PriceIncludeTax
|	AND SalesOrder.Posted
|;
|////////////////////////////////////////////////////////////////////////////////
|SELECT
|	ShipmentConfirmation.Ref AS ShipmentConfirmationRef
|INTO tmp2
|FROM
|	Document.ShipmentConfirmation AS ShipmentConfirmation
|WHERE
|	ShipmentConfirmation.Company = &Company
|	AND ShipmentConfirmation.Partner = &Partner
|	AND ShipmentConfirmation.LegalName = &LegalName
|	AND ShipmentConfirmation.Posted
|;
|////////////////////////////////////////////////////////////////////////////////
|SELECT ALLOWED
|	ShipmentOrdersBalance.Order AS Order,
|	ShipmentOrdersBalance.ShipmentConfirmation AS ShipmentConfirmation,
|	ShipmentOrdersBalance.ItemKey.Item AS Item,
|	ShipmentOrdersBalance.ItemKey AS ItemKey,
|	CASE
|		WHEN ShipmentOrdersBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
|			THEN ShipmentOrdersBalance.ItemKey.Unit
|		ELSE ShipmentOrdersBalance.ItemKey.Item.Unit
|	END AS Unit,
|	ShipmentOrdersBalance.QuantityBalance AS Quantity,
|	ShipmentOrdersBalance.RowKey AS RowKey
|INTO tmp_Documents
|FROM
|	AccumulationRegister.ShipmentOrders.Balance(, Order IN
|		(SELECT
|			tmp.Order
|		FROM
|			tmp AS tmp)
|	AND
|	NOT ShipmentConfirmation IN (&AlreadySelectedShipmentConfirmations)) AS ShipmentOrdersBalance
|WHERE
|	ShipmentOrdersBalance.QuantityBalance > 0
|
|UNION ALL
|
|SELECT
|	VALUE(Document.SalesOrder.EmptyRef),
|	GoodsInTransitOutgoingBalance.ShipmentBasis,
|	GoodsInTransitOutgoingBalance.ItemKey.Item,
|	GoodsInTransitOutgoingBalance.ItemKey,
|	CASE
|		WHEN GoodsInTransitOutgoingBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
|			THEN GoodsInTransitOutgoingBalance.ItemKey.Unit
|		ELSE GoodsInTransitOutgoingBalance.ItemKey.Item.Unit
|	END,
|	-GoodsInTransitOutgoingBalance.QuantityBalance,
|	GoodsInTransitOutgoingBalance.RowKey
|FROM
|	AccumulationRegister.GoodsInTransitOutgoing.Balance(, ShipmentBasis IN
|		(SELECT
|			tmp2.ShipmentConfirmationRef
|		FROM
|			tmp2 AS tmp2)
|	AND
|	NOT ShipmentBasis IN (&AlreadySelectedShipmentConfirmations)) AS GoodsInTransitOutgoingBalance
|		INNER JOIN tmp2 AS tmp2
|		ON GoodsInTransitOutgoingBalance.ShipmentBasis = tmp2.ShipmentConfirmationRef
|;
|////////////////////////////////////////////////////////////////////////////////
|SELECT
|	tmp_Documents.Order AS Order,
|	tmp_Documents.ShipmentConfirmation AS ShipmentConfirmation,
|	tmp_Documents.Item AS Item,
|	tmp_Documents.ItemKey AS ItemKey,
|	tmp_Documents.Unit AS Unit,
|	tmp_Documents.Quantity AS Quantity,
|	tmp_Documents.RowKey AS RowKey
|FROM
|	tmp_Documents AS tmp_Documents
|TOTALS
|BY
|	Order,
|	ShipmentConfirmation";

	Query.SetParameter("Company", Parameters.Company);
	Query.SetParameter("Partner", Parameters.Partner);
	Query.SetParameter("LegalName", Parameters.LegalName);
	Query.SetParameter("Agreement", Parameters.Agreement);
	Query.SetParameter("Currency", Parameters.Currency);
	Query.SetParameter("PriceIncludeTax", Parameters.PriceIncludeTax);
	
	Query.SetParameter("AlreadySelectedShipmentConfirmations", Parameters.AlreadySelectedShipmentConfirmations);
	
	QueryResult = Query.Execute();
	Return DocSalesInvoiceServer.GetInfoShipmentConfirmationBeforeSalesInvoiceFromQueryResult(QueryResult);
EndFunction

Function GetInfoShipmentConfirmationBeforeSalesInvoiceFromQueryResult(QueryResult) Export
	
	QuerySelection_Order = QueryResult.Select(QueryResultIteration.ByGroups);
	
	InfoShipmentConfirmationLinear = New Array();
	InfoShipmentConfirmationTree = New Array();
	InfoShipmentConfirmationOrders = New Array();
	
	While QuerySelection_Order.Next() Do
		Row_Order = New Structure("Order, Rows");
		Row_Order.Order = QuerySelection_Order.Order;
		Row_Order.Rows = New Array();
		
		InfoShipmentConfirmationOrders.Add(QuerySelection_Order.Order);
		
		QuerySelection_ShipmentConfirmation = QuerySelection_Order.Select(QueryResultIteration.ByGroups);
		While QuerySelection_ShipmentConfirmation.Next() Do
			Row_ShipmentConfirmation = New Structure("ShipmentConfirmation, Rows");
			Row_ShipmentConfirmation.ShipmentConfirmation = QuerySelection_ShipmentConfirmation.ShipmentConfirmation;
			Row_ShipmentConfirmation.Rows = New Array();
			Row_Order.Rows.Add(Row_ShipmentConfirmation);
			
			QuerySelection_Detail = QuerySelection_ShipmentConfirmation.Select();
			While QuerySelection_Detail.Next() Do
				Row_Detail = New Structure("Item, ItemKey, RowKey, Unit, Quantity");
				Row_Detail.Item = QuerySelection_Detail.Item;
				Row_Detail.ItemKey = QuerySelection_Detail.ItemKey;
				Row_Detail.RowKey = QuerySelection_Detail.RowKey;
				Row_Detail.Unit = QuerySelection_Detail.Unit;
				
				If ValueIsFilled(QuerySelection_Detail.Unit)
					And ValueIsFilled(QuerySelection_Detail.Unit.Quantity) Then
					Row_Detail.Quantity = QuerySelection_Detail.Quantity / QuerySelection_Detail.Unit.Quantity;
				EndIf;
				
				Row_ShipmentConfirmation.Rows.Add(Row_Detail);
				
				InfoShipmentConfirmationLinear.Add(New Structure(
						"Order,
						|ShipmentConfirmation,
						|Item,
						|ItemKey,
						|RowKey,
						|Unit,
						|Quantity",
						QuerySelection_Order.Order,
						QuerySelection_ShipmentConfirmation.ShipmentConfirmation,
						QuerySelection_Detail.Item,
						QuerySelection_Detail.ItemKey,
						QuerySelection_Detail.RowKey,
						QuerySelection_Detail.Unit,
						QuerySelection_Detail.Quantity));
				
			EndDo;
		EndDo;
		InfoShipmentConfirmationTree.Add(Row_Order);
	EndDo;
	
	Return New Structure("Linear, Tree, Orders",
		InfoShipmentConfirmationLinear
		, InfoShipmentConfirmationTree
		, InfoShipmentConfirmationOrders);
EndFunction

Function CreateTable_ShipmentConfirmations()
	ColumnsMetadata = Metadata.Documents.SalesInvoice.TabularSections.ShipmentConfirmations.Attributes;
	ShipmentConfirmationsTable = New ValueTable();
	ShipmentConfirmationsTable.Columns.Add("Key", ColumnsMetadata.Key.Type);
	ShipmentConfirmationsTable.Columns.Add("ShipmentConfirmation", ColumnsMetadata.ShipmentConfirmation.Type);
	ShipmentConfirmationsTable.Columns.Add("Quantity", ColumnsMetadata.Quantity.Type);
	ShipmentConfirmationsTable.Columns.Add("QuantityInShipmentConfirmation", ColumnsMetadata.Quantity.Type);
	ShipmentConfirmationsTable.Columns.Add("Ref" , New TypeDescription("DocumentRef.SalesOrder"));
	Return ShipmentConfirmationsTable;
EndFunction

Procedure FillDocumentWithShipmentConfirmationArray(Object, Form, ArrayOfBasisDocuments) Export
	ValueTable = New ValueTable();
	ValueTable.Columns.Add("Order", New TypeDescription("DocumentRef.SalesOrder"));
	ValueTable.Columns.Add("ItemKey", New TypeDescription("CatalogRef.ItemKeys"));
	ValueTable.Columns.Add("Quantity", New TypeDescription(Metadata.DefinedTypes.typeQuantity.Type));
	ValueTable.Columns.Add("RowKey", Metadata.AccumulationRegisters.ShipmentOrders.Dimensions.RowKey.Type);
	
	ValueTableWithShipmentConfirmation = New ValueTable();
	ValueTableWithShipmentConfirmation.Columns.Add("Order", New TypeDescription("DocumentRef.SalesOrder"));
	ValueTableWithShipmentConfirmation.Columns.Add("ShipmentConfirmation"
		, New TypeDescription(Metadata.AccumulationRegisters.ShipmentOrders.Dimensions.ShipmentConfirmation.Type));
	ValueTableWithShipmentConfirmation.Columns.Add("ItemKey", New TypeDescription("CatalogRef.ItemKeys"));
	ValueTableWithShipmentConfirmation.Columns.Add("Quantity", New TypeDescription(Metadata.DefinedTypes.typeQuantity.Type));
	ValueTableWithShipmentConfirmation.Columns.Add("RowKey", Metadata.AccumulationRegisters.ShipmentOrders.Dimensions.RowKey.Type);
	
	ShipmentConfirmationsTable = CreateTable_ShipmentConfirmations();
	
	For Each Row In ArrayOfBasisDocuments Do
		NewRow = ValueTable.Add();
		NewRow.Order = Row.Order;
		NewRow.ItemKey = Row.ItemKey;
		NewRow.RowKey = Row.RowKey;
		NewRow.Quantity = Row.Quantity;
		
		NewRow = ValueTableWithShipmentConfirmation.Add();
		NewRow.Order = Row.Order;
		NewRow.ShipmentConfirmation = Row.ShipmentConfirmation;
		NewRow.ItemKey = Row.ItemKey;
		NewRow.RowKey = Row.RowKey;
		NewRow.Quantity = Row.Quantity;
				
		NewRow = ShipmentConfirmationsTable.Add();
		NewRow.Ref = Row.Order;
		NewRow.ShipmentConfirmation = Row.ShipmentConfirmation;
		NewRow.Key = New UUID(Row.RowKey);
		NewRow.Quantity = Row.Quantity;
		NewRow.QuantityInShipmentConfirmation = Row.Quantity;
	EndDo;
	
	ValueTable.GroupBy("Order, ItemKey, RowKey", "Quantity");
	ShipmentConfirmationsTable.GroupBy("ShipmentConfirmation, Key, Ref", "Quantity, QuantityInShipmentConfirmation");
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	ValueTable.Order AS Order,
		|	ValueTable.ItemKey AS ItemKey,
		|	ValueTable.RowKey AS RowKey,
		|	ValueTable.Quantity AS Quantity
		|INTO tmp
		|FROM
		|	&ValueTable AS ValueTable
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ValueTable.Order AS Order,
		|	ValueTable.ShipmentConfirmation AS ShipmentConfirmation,
		|	ValueTable.ItemKey AS ItemKey,
		|	ValueTable.RowKey AS RowKey,
		|	ValueTable.Quantity AS Quantity
		|INTO tmp_WithShipmentConfirmation
		|FROM
		|	&ValueTable_WithShipmentConfirmation AS ValueTable
		|;
		|
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT ALLOWED
		|	""SalesOrder"" AS BasedOn,
		|	OrderBalanceBalance.Order AS SalesOrder,
		|	OrderBalanceBalance.ItemKey,
		|	CASE
		|		WHEN OrderBalanceBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN OrderBalanceBalance.ItemKey.Unit
		|		ELSE OrderBalanceBalance.ItemKey.Item.Unit
		|	END AS Unit,
		|	OrderBalanceBalance.Store,
		|	tmp.Quantity,
		|	Value(Document.ShipmentConfirmation.EmptyRef) AS ShipmentConfirmation,
		|	OrderBalanceBalance.RowKey
		|FROM
		|	AccumulationRegister.OrderBalance.Balance(, (Order, ItemKey, RowKey) IN
		|		(SELECT
		|			tmp.Order,
		|			tmp.ItemKey,
		|			tmp.RowKey
		|		FROM
		|			tmp AS tmp)
		|	AND ItemKey.Item.ItemType.Type <> VALUE(enum.ItemTypes.Service)) AS OrderBalanceBalance
		|		INNER JOIN tmp AS tmp
		|		ON tmp.Order = OrderBalanceBalance.Order
		|		AND tmp.ItemKey = OrderBalanceBalance.ItemKey
		|		AND tmp.RowKey = OrderBalanceBalance.RowKey
		|		AND OrderBalanceBalance.QuantityBalance > 0
		|
		|UNION ALL
		|
		|SELECT
		|	""ShipmentConfirmation"",
		|	VALUE(Document.SalesOrder.EmptyRef),
		|	GoodsInTransitOutgoingBalance.ItemKey,
		|	CASE
		|		WHEN GoodsInTransitOutgoingBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN GoodsInTransitOutgoingBalance.ItemKey.Unit
		|		ELSE GoodsInTransitOutgoingBalance.ItemKey.Item.Unit
		|	END AS Unit,
		|	GoodsInTransitOutgoingBalance.Store,
		|	-GoodsInTransitOutgoingBalance.QuantityBalance,
		|	GoodsInTransitOutgoingBalance.ShipmentBasis,
		|	GoodsInTransitOutgoingBalance.RowKey
		|FROM
		|	AccumulationRegister.GoodsInTransitOutgoing.Balance(, (ShipmentBasis, ItemKey, RowKey) IN
		|		(SELECT
		|			tmp.ShipmentConfirmation,
		|			tmp.ItemKey,
		|			tmp.RowKey
		|		FROM
		|			tmp_WithShipmentConfirmation AS tmp)) AS GoodsInTransitOutgoingBalance
		|		INNER JOIN tmp_WithShipmentConfirmation AS tmp
		|		ON tmp.ShipmentConfirmation = GoodsInTransitOutgoingBalance.ShipmentBasis
		|		AND tmp.ItemKey = GoodsInTransitOutgoingBalance.ItemKey
		|		AND tmp.RowKey = GoodsInTransitOutgoingBalance.RowKey
		|		AND GoodsInTransitOutgoingBalance.QuantityBalance < 0";
	Query.SetParameter("ValueTable", ValueTable);
	Query.SetParameter("ValueTable_WithShipmentConfirmation", ValueTableWithShipmentConfirmation);
	
	QueryTableOrderBalance = Query.Execute().Unload();
	
	QueryTableOrderBalance.Columns.Add("Key", New TypeDescription("UUID"));
	For Each Row In QueryTableOrderBalance Do
		Row.Key = New UUID(Row.RowKey);
	EndDo;
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable.BasedOn,
		|	QueryTable.Store,
		|	QueryTable.SalesOrder,
		|	QueryTable.ShipmentConfirmation,
		|	QueryTable.ItemKey,
		|	QueryTable.Key,
		|	QueryTable.Unit,
		|	QueryTable.Quantity
		|INTO tmpQueryTable
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT ALLOWED
		|	tmpQueryTable.BasedOn AS BasedOn,
		|	tmpQueryTable.ItemKey AS ItemKey,
		|	tmpQueryTable.Store AS Store,
		|	tmpQueryTable.SalesOrder AS SalesOrder,
		|	CAST(tmpQueryTable.SalesOrder AS Document.SalesOrder).Partner AS Partner,
		|	CAST(tmpQueryTable.SalesOrder AS Document.SalesOrder).LegalName AS LegalName,
		|	CAST(tmpQueryTable.SalesOrder AS Document.SalesOrder).PriceIncludeTax AS PriceIncludeTax,
		|	CAST(tmpQueryTable.SalesOrder AS Document.SalesOrder).Agreement AS Agreement,
		|	CAST(tmpQueryTable.SalesOrder AS Document.SalesOrder).ManagerSegment AS ManagerSegment,
		|	CAST(tmpQueryTable.SalesOrder AS Document.SalesOrder).Currency AS Currency,
		|	CAST(tmpQueryTable.SalesOrder AS Document.SalesOrder).Company AS Company,
		|	tmpQueryTable.Key,
		|	tmpQueryTable.Unit AS QuantityUnit,
		|	tmpQueryTable.Quantity AS Quantity,
		|	ISNULL(ItemList.Quantity, 0) AS OriginalQuantity,
		|	ISNULL(ItemList.Price, 0) AS Price,
		|	ISNULL(ItemList.TaxAmount, 0) AS TaxAmount,
		|	ISNULL(ItemList.TotalAmount, 0) AS TotalAmount,
		|	ISNULL(ItemList.NetAmount, 0) AS NetAmount,
		|	ISNULL(ItemList.OffersAmount, 0) AS OffersAmount,
		|	ISNULL(ItemList.Unit, VALUE(Catalog.Units.EmptyRef)) AS Unit,
		|	ISNULL(ItemList.PriceType, VALUE(Catalog.PriceTypes.EmptyRef)) AS PriceType,
		|	ISNULL(ItemList.DeliveryDate, DATETIME(1, 1, 1)) AS DeliveryDate,
		|	Value(Document.ShipmentConfirmation.EmptyRef) AS ShipmentConfirmation,
		|	ItemList.Ref,
		|	ISNULL(ItemList.DontCalculateRow, FALSE) AS DontCalculateRow
		|FROM
		|	Document.SalesOrder.ItemList AS ItemList
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.Key = ItemList.Key
		|		AND tmpQueryTable.SalesOrder = ItemList.Ref
		|GROUP BY
		|	ItemList.LineNumber,
		|	tmpQueryTable.BasedOn,
		|	tmpQueryTable.ItemKey,
		|	tmpQueryTable.Store,
		|	tmpQueryTable.SalesOrder,
		|	CAST(tmpQueryTable.SalesOrder AS Document.SalesOrder).Partner,
		|	CAST(tmpQueryTable.SalesOrder AS Document.SalesOrder).LegalName,
		|	CAST(tmpQueryTable.SalesOrder AS Document.SalesOrder).PriceIncludeTax,
		|	CAST(tmpQueryTable.SalesOrder AS Document.SalesOrder).Agreement,
		|	CAST(tmpQueryTable.SalesOrder AS Document.SalesOrder).ManagerSegment,
		|	CAST(tmpQueryTable.SalesOrder AS Document.SalesOrder).Currency,
		|	CAST(tmpQueryTable.SalesOrder AS Document.SalesOrder).Company,
		|	tmpQueryTable.Key,
		|	tmpQueryTable.Unit,
		|	tmpQueryTable.Quantity,
		|	ISNULL(ItemList.Quantity, 0),
		|	Value(Document.ShipmentConfirmation.EmptyRef),
		|	ISNULL(ItemList.Price, 0),
		|	ISNULL(ItemList.TaxAmount, 0),
		|	ISNULL(ItemList.TotalAmount, 0),
		|	ISNULL(ItemList.NetAmount, 0),
		|	ISNULL(ItemList.OffersAmount, 0),
		|	ISNULL(ItemList.Unit, VALUE(Catalog.Units.EmptyRef)),
		|	ISNULL(ItemList.PriceType, VALUE(Catalog.PriceTypes.EmptyRef)),
		|	ISNULL(ItemList.DeliveryDate, DATETIME(1, 1, 1)),
		|	ItemList.Ref,
		|	ISNULL(ItemList.DontCalculateRow, FALSE)
		|
		|UNION ALL
		|
		|SELECT
		|	tmpQueryTable.BasedOn,
		|	tmpQueryTable.ItemKey,
		|	tmpQueryTable.Store,
		|	tmpQueryTable.SalesOrder,
		|	CAST(tmpQueryTable.ShipmentConfirmation AS Document.ShipmentConfirmation).Partner,
		|	CAST(tmpQueryTable.ShipmentConfirmation AS Document.ShipmentConfirmation).LegalName,
		|	FALSE,
		|	VALUE(Catalog.Agreements.EmptyRef),
		|	VALUE(Catalog.PartnerSegments.EmptyRef),
		|	VALUE(Catalog.Currencies.EmptyRef),
		|	CAST(tmpQueryTable.ShipmentConfirmation AS Document.ShipmentConfirmation).Company,
		|	tmpQueryTable.Key,
		|	tmpQueryTable.Unit,
		|	tmpQueryTable.Quantity,
		|	tmpQueryTable.Quantity,
		|	0,
		|	0,
		|	0,
		|	0,
		|	0,
		|	ISNULL(ItemList.Unit, VALUE(Catalog.Units.EmptyRef)),
		|	VALUE(Catalog.PriceTypes.EmptyRef),
		|	DATETIME(1, 1, 1),
		|	tmpQueryTable.ShipmentConfirmation,
		|	ItemList.Ref,
		|	FALSE
		|FROM
		|	Document.ShipmentConfirmation.ItemList AS ItemList
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.Key = ItemList.Key
		|		AND tmpQueryTable.ShipmentConfirmation = ItemList.Ref
		|		AND tmpQueryTable.SalesOrder = VALUE(Document.SalesOrder.EmptyRef)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	TaxList.Ref,
		|	TaxList.Key,
		|	TaxList.Tax,
		|	TaxList.Analytics,
		|	TaxList.TaxRate,
		|	TaxList.Amount,
		|	TaxList.IncludeToTotalAmount,
		|	TaxList.ManualAmount
		|FROM
		|	Document.SalesOrder.TaxList AS TaxList
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.Key = TaxList.Key
		|		AND tmpQueryTable.SalesOrder = TaxList.Ref";
	
	Query.SetParameter("QueryTable", QueryTableOrderBalance);
	QueryResults = Query.ExecuteBatch();
	
	QueryTable_ItemList = QueryResults[1].Unload();
	DocumentsServer.RecalculateQuantityInTable(QueryTable_ItemList);
	
	QueryTable_TaxList = QueryResults[2].Unload();
	
	For Each Row_ItemList In QueryTable_ItemList Do
		If Row_ItemList.OriginalQuantity = 0 Then
			Row_ItemList.TaxAmount = 0;
			Row_ItemList.NetAmount = 0;
			Row_ItemList.TotalAmount = 0;
			Row_ItemList.OffersAmount = 0;
		Else
			Row_ItemList.TaxAmount = Row_ItemList.TaxAmount / Row_ItemList.OriginalQuantity * Row_ItemList.Quantity;
			Row_ItemList.NetAmount = Row_ItemList.NetAmount / Row_ItemList.OriginalQuantity * Row_ItemList.Quantity;;
			Row_ItemList.TotalAmount = Row_ItemList.TotalAmount / Row_ItemList.OriginalQuantity * Row_ItemList.Quantity;
			Row_ItemList.OffersAmount = Row_ItemList.OffersAmount / Row_ItemList.OriginalQuantity * Row_ItemList.Quantity;
		EndIf;	
		
		For Each Row_TaxList In QueryTable_TaxList.FindRows(New Structure("Key", Row_ItemList.Key)) Do
			If Row_ItemList.OriginalQuantity = 0 Then
				Row_TaxList.Amount = 0;
				Row_TaxList.ManualAmount = 0;
			Else
				Row_TaxList.Amount = Row_TaxList.Amount / Row_ItemList.OriginalQuantity * Row_ItemList.Quantity;
				Row_TaxList.ManualAmount = Row_TaxList.ManualAmount / Row_ItemList.OriginalQuantity * Row_ItemList.Quantity;;								
			EndIf;
		EndDo;
	EndDo;
	
	For Each Row In QueryTable_ItemList Do
		FilterByKey = New Structure("Key", Row.Key);
		Rows_ItemList = Object.ItemList.FindRows(FilterByKey);
		
		If Rows_ItemList.Count() Then
			Row_ItemList = Rows_ItemList[0];			
		Else
			Row_ItemList = Object.ItemList.Add();
		EndIf;
				
		Row_ItemList.Key           = Row.Key;
		Row_ItemList.ItemKey       = Row.ItemKey;
		Row_ItemList.Store         = Row.Store;
		Row_ItemList.SalesOrder    = Row.SalesOrder;
		Row_ItemList.Quantity      = Row_ItemList.Quantity + Row.Quantity;
		Row_ItemList.Price         = Row.Price;
		Row_ItemList.Unit          = Row.Unit;
		Row_ItemList.TaxAmount     = Row_ItemList.TaxAmount + Row.TaxAmount;
		Row_ItemList.TotalAmount   = Row_ItemList.TotalAmount + Row.TotalAmount;
		Row_ItemList.NetAmount     = Row_ItemList.NetAmount + Row.NetAmount;
		Row_ItemList.OffersAmount  = Row_ItemList.OffersAmount + Row.OffersAmount;
		Row_ItemList.DeliveryDate  = Row.DeliveryDate;
		Row_ItemList.DontCalculateRow  = Row.DontCalculateRow;
		
		Row_ItemList.PriceType     = Row.PriceType;
	EndDo;
		
	For Each Row In QueryTable_TaxList Do
		FilterByKey = New Structure("Key", Row.Key);
		Rows_TaxList = Object.TaxList.FindRows(FilterByKey);
		If Rows_TaxList.Count() Then
			Row_TaxList = Rows_TaxList[0];
		Else
			Row_TaxList = Object.TaxList.Add();
		EndIf;
		
		Row_TaxList.Key                  = Row.Key;
		Row_TaxList.Tax                  = Row.Tax;
		Row_TaxList.Analytics            = Row.Analytics;
		Row_TaxList.TaxRate              = Row.TaxRate; 
		Row_TaxList.Amount               = Row_TaxList.Amount + Row.Amount;
		Row_TaxList.IncludeToTotalAmount = Row.IncludeToTotalAmount;
		Row_TaxList.ManualAmount         = Row_TaxList.ManualAmount + Row.ManualAmount;		
	EndDo;
		
	For Each Row In ShipmentConfirmationsTable Do
		FilterByKey = New Structure("Key, ShipmentConfirmation", Row.Key, Row.ShipmentConfirmation);
		Rows_ShipmentConfirmations = Object.ShipmentConfirmations.FindRows(FilterByKey);
		If Rows_ShipmentConfirmations.Count() Then
			Row_ShipmentConfirmations = Rows_ShipmentConfirmations[0];
		Else
			Row_ShipmentConfirmations = Object.ShipmentConfirmations.Add();
		EndIf;
		
		Row_ShipmentConfirmations.Key                    = Row.Key;
		Row_ShipmentConfirmations.ShipmentConfirmation   = Row.ShipmentConfirmation;
		Row_ShipmentConfirmations.Quantity               = Row.Quantity;
		Row_ShipmentConfirmations.QuantityInShipmentConfirmation = Row.QuantityInShipmentConfirmation;
	EndDo;
EndProcedure

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