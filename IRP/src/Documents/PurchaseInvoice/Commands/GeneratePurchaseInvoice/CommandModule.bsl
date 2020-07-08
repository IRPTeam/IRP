&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	
	// Purchase orders when goods receipt before purchase invoice
	InfoGoodsReceipt = GetInfoGoodsReceiptBeforePurchaseInvoice(CommandParameter);
	
	If InfoGoodsReceipt.Linear.Count() Then
		OpenArgs = New Structure("InfoGoodsReceipt", InfoGoodsReceipt.Tree);
		OpenForm("Document.PurchaseInvoice.Form.SelectGoodsReceiptForm"
			, OpenArgs, , , ,
			, New NotifyDescription("SelectGoodsReceiptFinish", ThisObject,
				New Structure("InfoGoodsReceipt, CommandParameter",
					InfoGoodsReceipt, CommandParameter)));
	Else
		ArrayOfInfoGoodsReceipt = GetInfoGoodsReceipt(CommandParameter);
		For Each Row In ArrayOfInfoGoodsReceipt Do
			CommandParameter.Add(Row);
		EndDo;
		GenerateDocument(CommandParameter);
	EndIf;
	
EndProcedure

&AtClient
Procedure GenerateDocument(ArrayOfBasisDocuments)
	DocumentStructure = GetDocumentsStructure(ArrayOfBasisDocuments);
	
	If DocumentStructure.Count() = 0 Then
		For Each BasisDocument In ArrayOfBasisDocuments Do
			ErrorMessage = GetErrorMessage(BasisDocument);
			If ValueIsFilled(ErrorMessage) Then
				ShowMessageBox( , ErrorMessage);
				Return;
			EndIf;
		EndDo;	
	EndIf;
	
	For Each FillingData In DocumentStructure Do
		FormParameters = New Structure("FillingValues", FillingData);
		InfoMessage = GetInfoMessage(FillingData);
		If Not IsBlankString(InfoMessage) Then
			FormParameters.Insert("InfoMessage", InfoMessage);
		EndIf;
		OpenForm("Document.PurchaseInvoice.ObjectForm", FormParameters, , New UUID());
	EndDo;
EndProcedure

&AtServer
Function GetDocumentsStructure(ArrayOfBasisDocuments)
	ArrayOf_PurchaseOrder = New Array();
	ArrayOf_GoodsReceipt = New Array();
	ArrayOf_Service = New Array();
	ArrayOf_SalesOrder = New Array();
	
	For Each Row In ArrayOfBasisDocuments Do
		
		If TypeOf(Row) = Type("DocumentRef.PurchaseOrder") Then
			ArrayOf_PurchaseOrder.Add(Row);
			ArrayOf_Service.Add(Row);
		EndIf;
		
		If TypeOf(Row) = Type("DocumentRef.SalesOrder") Then
			ArrayOf_SalesOrder.Add(Row);
		EndIf;
		
		If TypeOf(Row) = Type("Structure") Then
			If Row.Property("GoodsReceipt") And
				(TypeOf(Row.GoodsReceipt) = Type("DocumentRef.GoodsReceipt")
					Or TypeOf(Row.GoodsReceipt) = Type("DocumentRef.PurchaseOrder")) Then
				ArrayOf_GoodsReceipt.Add(Row);
				ArrayOf_Service.Add(Row.Order);
			EndIf;
		EndIf;
		
	EndDo;
	
	ArrayOfTables = New Array();
	ArrayOfTables.Add(GetDocumentTable_PurchaseOrder(ArrayOf_PurchaseOrder));
	ArrayOfTables.Add(GetDocumentTable_GoodsReceipt(ArrayOf_GoodsReceipt));
	ArrayOfTables.Add(GetDocumentTable_Service(ArrayOf_Service));
	ArrayOfTables.Add(GetDocumentTable_SalesOrder(ArrayOf_SalesOrder));
	
	Return JoinDocumentsStructure(ArrayOfTables, 
	"BasedOn, Company, Partner, LegalName, Agreement, Currency, PriceIncludeTax");
EndFunction

&AtServer
Function JoinDocumentsStructure(ArrayOfTables, UnjoinFileds)
	ItemList = New ValueTable();
	ItemList.Columns.Add("BasedOn"			, New TypeDescription("String"));
	ItemList.Columns.Add("Company"			, New TypeDescription("CatalogRef.Companies"));
	ItemList.Columns.Add("Partner"			, New TypeDescription("CatalogRef.Partners"));
	ItemList.Columns.Add("LegalName"		, New TypeDescription("CatalogRef.Companies"));
	ItemList.Columns.Add("Agreement"		, New TypeDescription("CatalogRef.Agreements"));
	ItemList.Columns.Add("PriceIncludeTax"	, New TypeDescription("Boolean"));
	ItemList.Columns.Add("Currency"			, New TypeDescription("CatalogRef.Currencies"));
	ItemList.Columns.Add("ItemKey"			, New TypeDescription("CatalogRef.ItemKeys"));
	ItemList.Columns.Add("Store"			, New TypeDescription("CatalogRef.Stores"));
	ItemList.Columns.Add("PurchaseOrder"
		, New TypeDescription(Metadata.AccumulationRegisters.OrderBalance.Dimensions.Order.Type));
	ItemList.Columns.Add("GoodsReceipt"
		, New TypeDescription(Metadata.AccumulationRegisters.ReceiptOrders.Dimensions.GoodsReceipt.Type));
	ItemList.Columns.Add("Unit"				, New TypeDescription("CatalogRef.Units"));
	ItemList.Columns.Add("Quantity"			, New TypeDescription(Metadata.DefinedTypes.typeQuantity.Type));
	ItemList.Columns.Add("TaxAmount"		, New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ItemList.Columns.Add("TotalAmount"		, New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ItemList.Columns.Add("NetAmount"		, New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ItemList.Columns.Add("OffersAmount"		, New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ItemList.Columns.Add("PriceType"		, New TypeDescription("CatalogRef.PriceTypes"));
	ItemList.Columns.Add("Price"			, New TypeDescription(Metadata.DefinedTypes.typePrice.Type));
	ItemList.Columns.Add("BusinessUnit"		, New TypeDescription("CatalogRef.BusinessUnits"));
	ItemList.Columns.Add("ExpenseType"		, New TypeDescription("CatalogRef.ExpenseAndRevenueTypes"));
	ItemList.Columns.Add("Key"				, New TypeDescription("UUID"));
	ItemList.Columns.Add("RowKey"			, New TypeDescription("String"));
	ItemList.Columns.Add("DeliveryDate"		, New TypeDescription("Date"));
	ItemList.Columns.Add("SalesOrder"		, New TypeDescription("DocumentRef.SalesOrder"));
	
	TaxListMetadataColumns = Metadata.Documents.SalesOrder.TabularSections.TaxList.Attributes;
	TaxList = New ValueTable();
	TaxList.Columns.Add("Key"					, TaxListMetadataColumns.Key.Type);
	TaxList.Columns.Add("Tax"					, TaxListMetadataColumns.Tax.Type);
	TaxList.Columns.Add("Analytics"				, TaxListMetadataColumns.Analytics.Type);
	TaxList.Columns.Add("TaxRate"				, TaxListMetadataColumns.TaxRate.Type);
	TaxList.Columns.Add("Amount"				, TaxListMetadataColumns.Amount.Type);
	TaxList.Columns.Add("IncludeToTotalAmount"	, TaxListMetadataColumns.IncludeToTotalAmount.Type);
	TaxList.Columns.Add("ManualAmount"			, TaxListMetadataColumns.ManualAmount.Type);
	TaxList.Columns.Add("Ref"					, New TypeDescription("DocumentRef.PurchaseOrder"));
	
	SpecialOffersMetadataColumns = Metadata.Documents.SalesOrder.TabularSections.SpecialOffers.Attributes;
	SpecialOffers = New ValueTable();
	SpecialOffers.Columns.Add("Key"		, SpecialOffersMetadataColumns.Key.Type);
	SpecialOffers.Columns.Add("Offer"	, SpecialOffersMetadataColumns.Offer.Type);
	SpecialOffers.Columns.Add("Amount"	, SpecialOffersMetadataColumns.Amount.Type);
	SpecialOffers.Columns.Add("Percent"	, SpecialOffersMetadataColumns.Percent.Type);
	SpecialOffers.Columns.Add("Ref"		, New TypeDescription("DocumentRef.PurchaseOrder"));
	
	For Each TableStructure In ArrayOfTables Do
		For Each Row In TableStructure.ItemList Do
			FillPropertyValues(ItemList.Add(), Row);
		EndDo;
		For Each Row In TableStructure.TaxList Do
			FillPropertyValues(TaxList.Add(), Row);
		EndDo;
		For Each Row In TableStructure.SpecialOffers Do
			FillPropertyValues(SpecialOffers.Add(), Row);
		EndDo;
	EndDo;
	
	ItemListCopy = ItemList.Copy();
	ItemListCopy.GroupBy(UnjoinFileds);
	
	ArrayOfResults = New Array();
	
	For Each Row In ItemListCopy Do
		Result = New Structure(UnjoinFileds);
		FillPropertyValues(Result, Row);
		
		Result.Insert("ItemList"		, New Array());
		Result.Insert("TaxList"			, New Array());
		Result.Insert("SpecialOffers"	, New Array());
		
		Filter = New Structure(UnjoinFileds);
		FillPropertyValues(Filter, Row);
		
		ArrayOfTaxListFilters = New Array();
		ArrayOfSpecialOffersFilters = New Array();
		
		ItemListFiltered = ItemList.Copy(Filter);
		For Each RowItemList In ItemListFiltered Do
			NewRow = New Structure();
			
			For Each ColumnItemList In ItemListFiltered.Columns Do
				NewRow.Insert(ColumnItemList.Name, RowItemList[ColumnItemList.Name]);
			EndDo;
			
			NewRow.Key = New UUID(RowItemList.RowKey);
			
			ArrayOfTaxListFilters.Add(New Structure("Ref, Key", RowItemList.PurchaseOrder, NewRow.Key));
			ArrayOfSpecialOffersFilters.Add(New Structure("Ref, Key", RowItemList.PurchaseOrder, NewRow.Key));
			
			Result.ItemList.Add(NewRow);
		EndDo;
		
		For Each TaxListFilter In ArrayOfTaxListFilters Do
			For Each RowTaxList In TaxList.Copy(TaxListFilter) Do
				NewRow = New Structure();
				NewRow.Insert("Key"					, RowTaxList.Key);
				NewRow.Insert("Tax"					, RowTaxList.Tax);
				NewRow.Insert("Analytics"			, RowTaxList.Analytics);
				NewRow.Insert("TaxRate"				, RowTaxList.TaxRate);
				NewRow.Insert("Amount"				, RowTaxList.Amount);
				NewRow.Insert("IncludeToTotalAmount", RowTaxList.IncludeToTotalAmount);
				NewRow.Insert("ManualAmount"		, RowTaxList.ManualAmount);
				Result.TaxList.Add(NewRow);
			EndDo;
		EndDo;
		
		For Each SpecialOffersFilter In ArrayOfSpecialOffersFilters Do
			For Each RowSpecialOffers In SpecialOffers.Copy(SpecialOffersFilter) Do
				NewRow = New Structure();
				NewRow.Insert("Key", RowSpecialOffers.Key);
				NewRow.Insert("Offer", RowSpecialOffers.Offer);
				NewRow.Insert("Amount", RowSpecialOffers.Amount);
				NewRow.Insert("Percent", RowSpecialOffers.Percent);
				Result.SpecialOffers.Add(NewRow);
			EndDo;
		EndDo;
		
		ArrayOfResults.Add(Result);
	EndDo;
	Return ArrayOfResults;
EndFunction

&AtServer
Function ExtractInfoFrom_PurchaseOrder(QueryTable)
	QueryTable.Columns.Add("Key", New TypeDescription("UUID"));
	For Each Row In QueryTable Do
		Row.Key = New UUID(Row.RowKey);
	EndDo;
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable.BasedOn,
		|	QueryTable.Store,
		|	QueryTable.PurchaseOrder,
		|	QueryTable.GoodsReceipt,
		|	QueryTable.ItemKey,
		|	QueryTable.Key,
		|	QueryTable.RowKey,
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
		|	tmpQueryTable.PurchaseOrder AS PurchaseOrder,
		|	CAST(tmpQueryTable.PurchaseOrder AS Document.PurchaseOrder).Partner AS Partner,
		|	CAST(tmpQueryTable.PurchaseOrder AS Document.PurchaseOrder).LegalName AS LegalName,
		|	CAST(tmpQueryTable.PurchaseOrder AS Document.PurchaseOrder).Agreement AS Agreement,
		|	CAST(tmpQueryTable.PurchaseOrder AS Document.PurchaseOrder).PriceIncludeTax AS PriceIncludeTax,
		|	CAST(tmpQueryTable.PurchaseOrder AS Document.PurchaseOrder).Currency AS Currency,
		|	CAST(tmpQueryTable.PurchaseOrder AS Document.PurchaseOrder).Company AS Company,
		|	tmpQueryTable.Key,
		|	tmpQueryTable.RowKey,
		|	tmpQueryTable.Unit AS QuantityUnit,
		|	tmpQueryTable.Quantity AS Quantity,
		|	ISNULL(ItemList.Price, 0) AS Price,
		|	ISNULL(ItemList.Unit, VALUE(Catalog.Units.EmptyRef)) AS Unit,
		|	ISNULL(ItemList.TaxAmount, 0) AS TaxAmount,
		|	ISNULL(ItemList.TotalAmount, 0) AS TotalAmount,
		|	ISNULL(ItemList.NetAmount, 0) AS NetAmount,
		|	ISNULL(ItemList.OffersAmount, 0) AS OffersAmount,
		|	ISNULL(ItemList.DeliveryDate, DATETIME(1, 1, 1)) AS DeliveryDate,
		|	ISNULL(ItemList.PriceType, VALUE(Catalog.PriceTypes.EmptyRef)) AS PriceType,
		|	tmpQueryTable.GoodsReceipt AS GoodsReceipt,
		|	ItemList.BusinessUnit,
		|	ItemList.ExpenseType,
		|	CASE
		|		WHEN ItemList.PurchaseBasis REFS Document.SalesOrder
		|			THEN ItemList.PurchaseBasis
		|		ELSE UNDEFINED
		|	END AS SalesOrder
		|FROM
		|	Document.PurchaseOrder.ItemList AS ItemList
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.Key = ItemList.Key
		|		AND tmpQueryTable.PurchaseOrder = ItemList.Ref
		|ORDER BY 
		|	ItemList.LineNumber
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
		|	Document.PurchaseOrder.TaxList AS TaxList
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.PurchaseOrder = TaxList.Ref
		|		AND tmpQueryTable.Key = TaxList.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SpecialOffers.Ref,
		|	SpecialOffers.Key,
		|	SpecialOffers.Offer,
		|	SpecialOffers.Amount,
		|	SpecialOffers.Percent
		|FROM
		|	Document.PurchaseOrder.SpecialOffers AS SpecialOffers
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.PurchaseOrder = SpecialOffers.Ref
		|		AND tmpQueryTable.Key = SpecialOffers.Key";
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResults = Query.ExecuteBatch();
	
	QueryTable_ItemList = QueryResults[1].Unload();
	DocumentsServer.RecalculateQuantityInTable(QueryTable_ItemList);
	
	QueryTable_TaxList = QueryResults[2].Unload();
	QueryTable_SpecialOffers = QueryResults[3].Unload();
	
	Return New Structure("ItemList, TaxList, SpecialOffers", QueryTable_ItemList, QueryTable_TaxList, QueryTable_SpecialOffers);
EndFunction

&AtServer
Function GetDocumentTable_SalesOrder(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	""SalesOrder"" AS BasedOn,
		|	OrderProcurement.Store AS Store,
		|	OrderProcurement.Order AS SalesOrder,
		|	OrderProcurement.Company AS Company,
		|	OrderProcurement.ItemKey,
		|	OrderProcurement.RowKey,
		|	CASE
		|		WHEN OrderProcurement.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN OrderProcurement.ItemKey.Unit
		|		ELSE OrderProcurement.ItemKey.Item.Unit
		|	END AS Unit,
		|	OrderProcurement.QuantityBalance AS Quantity
		|FROM
		|	AccumulationRegister.OrderProcurement.Balance(, Order IN (&ArrayOfBasises)) AS OrderProcurement";
	Query.SetParameter("ArrayOfBasises", ArrayOfBasisDocuments);
	QueryResult = Query.Execute();
	Return New Structure("ItemList, TaxList, SpecialOffers", 
							QueryResult.Unload(), 
							New ValueTable(),
							New ValueTable());
EndFunction

&AtServer
Function GetDocumentTable_Service(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	""PurchaseOrder"" AS BasedOn,
		|	OrderBalanceBalance.Store AS Store,
		|	OrderBalanceBalance.Order AS PurchaseOrder,
		|	VALUE(Document.GoodsReceipt.EmptyRef) AS GoodsReceipt,
		|	OrderBalanceBalance.ItemKey,
		|	OrderBalanceBalance.RowKey,
		|	CASE
		|		WHEN OrderBalanceBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN OrderBalanceBalance.ItemKey.Unit
		|		ELSE OrderBalanceBalance.ItemKey.Item.Unit
		|	END AS Unit,
		|	OrderBalanceBalance.QuantityBalance AS Quantity
		|FROM
		|	AccumulationRegister.OrderBalance.Balance(, Order IN (&ArrayOfOrders)
		|	AND ItemKey.Item.ItemType.Type = VALUE(enum.ItemTypes.Service)) AS OrderBalanceBalance";
	Query.SetParameter("ArrayOfOrders", ArrayOfBasisDocuments);
	
	QueryTable = Query.Execute().Unload();
	Return ExtractInfoFrom_PurchaseOrder(QueryTable);
EndFunction

&AtServer
Function GetDocumentTable_PurchaseOrder(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	""PurchaseOrder"" AS BasedOn,
		|	OrderBalanceBalance.Store AS Store,
		|	OrderBalanceBalance.Order AS PurchaseOrder,
		|	VALUE(Document.GoodsReceipt.EmptyRef) AS GoodsReceipt,
		|	OrderBalanceBalance.ItemKey,
		|	OrderBalanceBalance.RowKey,
		|	CASE
		|		WHEN OrderBalanceBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN OrderBalanceBalance.ItemKey.Unit
		|		ELSE OrderBalanceBalance.ItemKey.Item.Unit
		|	END AS Unit,
		|	OrderBalanceBalance.QuantityBalance AS Quantity
		|FROM
		|	AccumulationRegister.OrderBalance.Balance(, Order IN (&ArrayOfOrders)
		|	AND ItemKey.Item.ItemType.Type <> VALUE(enum.ItemTypes.Service)
		|	AND
		|	NOT Order.GoodsReceiptBeforePurchaseInvoice) AS OrderBalanceBalance";
	Query.SetParameter("ArrayOfOrders", ArrayOfBasisDocuments);
	
	QueryTable = Query.Execute().Unload();
	Return ExtractInfoFrom_PurchaseOrder(QueryTable);
EndFunction

&AtServer
Function GetDocumentTable_GoodsReceipt(ArrayOfBasisDocuments)
	ValueTable = New ValueTable();
	ValueTable.Columns.Add("Order", New TypeDescription("DocumentRef.PurchaseOrder"));
	
	ValueTable.Columns.Add("GoodsReceipt"
		, New TypeDescription(Metadata.AccumulationRegisters.ReceiptOrders.Dimensions.GoodsReceipt.Type));
	
	ValueTable.Columns.Add("ItemKey", New TypeDescription("CatalogRef.ItemKeys"));
	ValueTable.Columns.Add("Quantity", New TypeDescription(Metadata.DefinedTypes.typeQuantity.Type));
	ValueTable.Columns.Add("RowKey", Metadata.AccumulationRegisters.ReceiptOrders.Dimensions.RowKey.Type);
	
	For Each Row In ArrayOfBasisDocuments Do
		NewRow = ValueTable.Add();
		NewRow.Order = Row.Order;
		NewRow.GoodsReceipt = Row.GoodsReceipt;
		NewRow.ItemKey = Row.ItemKey;
		NewRow.RowKey = Row.RowKey;
		NewRow.Quantity = Row.Quantity;
	EndDo;
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	ValueTable.Order AS Order,
		|	ValueTable.GoodsReceipt AS GoodsReceipt,
		|	ValueTable.ItemKey AS ItemKey,
		|	ValueTable.RowKey AS RowKey, 
		|	ValueTable.Quantity AS Quantity
		|INTO tmp
		|FROM
		|	&ValueTable AS ValueTable
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT ALLOWED
		|	""PurchaseOrder"" AS BasedOn,
		|	OrderBalanceBalance.Order AS PurchaseOrder,
		|	OrderBalanceBalance.ItemKey,
		|	CASE
		|		WHEN OrderBalanceBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN OrderBalanceBalance.ItemKey.Unit
		|		ELSE OrderBalanceBalance.ItemKey.Item.Unit
		|	END AS Unit,
		|	OrderBalanceBalance.Store,
		|	tmp.Quantity,
		|	tmp.GoodsReceipt,
		|	OrderBalanceBalance.RowKey
		|FROM
		|	AccumulationRegister.OrderBalance.Balance(, (Order, ItemKey, RowKey) IN
		|		(SELECT
		|			tmp.Order,
		|			tmp.ItemKey,
		|           tmp.RowKey
		|		FROM
		|			tmp AS tmp)
		|	AND ItemKey.Item.ItemType.Type <> VALUE(enum.ItemTypes.Service)) AS OrderBalanceBalance
		|		INNER JOIN tmp AS tmp
		|		ON tmp.Order = OrderBalanceBalance.Order
		|		AND tmp.ItemKey = OrderBalanceBalance.ItemKey
		|		AND tmp.RowKey = OrderBalanceBalance.RowKey
		|		AND OrderBalanceBalance.QuantityBalance > 0";
	Query.SetParameter("ValueTable", ValueTable);
	
	QueryTable = Query.Execute().Unload();
	Return ExtractInfoFrom_PurchaseOrder(QueryTable);
EndFunction

&AtClient
Procedure SelectGoodsReceiptFinish(Result, AdditionalParameters) Export
	ArrayOfBasisDocuments = New Array();
	For Each Row In AdditionalParameters.CommandParameter Do
		If AdditionalParameters.InfoGoodsReceipt.Orders.Find(Row) = Undefined Then
			ArrayOfBasisDocuments.Add(Row);
		EndIf;
	EndDo;
	
	If Result <> Undefined Then
		For Each Row In AdditionalParameters.InfoGoodsReceipt.Linear Do
			If Result.Find(Row.GoodsReceipt) <> Undefined Then
				ArrayOfBasisDocuments.Add(Row);
			EndIf;
		EndDo;
	EndIf;
	
	GenerateDocument(ArrayOfBasisDocuments);
EndProcedure

&AtServer
Function GetInfoGoodsReceiptBeforePurchaseInvoice(ArrayOfPurchaseOrders)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	ReceiptOrdersBalance.Order AS Order,
		|	ReceiptOrdersBalance.GoodsReceipt AS GoodsReceipt,
		|	ReceiptOrdersBalance.ItemKey.Item AS Item,
		|	ReceiptOrdersBalance.ItemKey,
		|	CASE
		|		WHEN ReceiptOrdersBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN ReceiptOrdersBalance.ItemKey.Unit
		|		ELSE ReceiptOrdersBalance.ItemKey.Item.Unit
		|	END AS Unit,
		|	ReceiptOrdersBalance.QuantityBalance AS Quantity,
		|	ReceiptOrdersBalance.RowKey
		|FROM
		|	AccumulationRegister.ReceiptOrders.Balance(, Order IN (&ArrayOfPurchaseOrders)) AS ReceiptOrdersBalance
		|TOTALS
		|BY
		|	Order,
		|	GoodsReceipt";
	Query.SetParameter("ArrayOfPurchaseOrders", ArrayOfPurchaseOrders);
	QueryResult = Query.Execute();
	QuerySelection_Order = QueryResult.Select(QueryResultIteration.ByGroups);
	
	InfoGoodsReceiptLinear = New Array();
	InfoGoodsReceiptTree = New Array();
	InfoGoodsReceiptOrders = New Array();
	
	While QuerySelection_Order.Next() Do
		Row_Order = New Structure("Order, Rows");
		Row_Order.Order = QuerySelection_Order.Order;
		Row_Order.Rows = New Array();
		
		InfoGoodsReceiptOrders.Add(QuerySelection_Order.Order);
		
		QuerySelection_GoodsReceipt = QuerySelection_Order.Select(QueryResultIteration.ByGroups);
		While QuerySelection_GoodsReceipt.Next() Do
			Row_GoodsReceipt = New Structure("GoodsReceipt, Rows");
			Row_GoodsReceipt.GoodsReceipt = QuerySelection_GoodsReceipt.GoodsReceipt;
			Row_GoodsReceipt.Rows = New Array();
			Row_Order.Rows.Add(Row_GoodsReceipt);
			
			QuerySelection_Detail = QuerySelection_GoodsReceipt.Select();
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
				
				Row_GoodsReceipt.Rows.Add(Row_Detail);
				
				InfoGoodsReceiptLinearStructure = New Structure();
				InfoGoodsReceiptLinearStructure.Insert("Order", QuerySelection_Order.Order);
				InfoGoodsReceiptLinearStructure.Insert("GoodsReceipt", QuerySelection_GoodsReceipt.GoodsReceipt);
				InfoGoodsReceiptLinearStructure.Insert("Item", QuerySelection_Detail.Item);
				InfoGoodsReceiptLinearStructure.Insert("ItemKey", QuerySelection_Detail.ItemKey);
				InfoGoodsReceiptLinearStructure.Insert("RowKey", QuerySelection_Detail.RowKey);
				InfoGoodsReceiptLinearStructure.Insert("Unit", QuerySelection_Detail.Unit);
				InfoGoodsReceiptLinearStructure.Insert("Quantity", QuerySelection_Detail.Quantity);
				InfoGoodsReceiptLinear.Add(InfoGoodsReceiptLinearStructure);
				
			EndDo;
		EndDo;
		InfoGoodsReceiptTree.Add(Row_Order);
	EndDo;
	
	Return New Structure("Linear, Tree, Orders",
		InfoGoodsReceiptLinear
		, InfoGoodsReceiptTree
		, InfoGoodsReceiptOrders);
EndFunction

&AtServer
Function GetInfoGoodsReceipt(ArrayOfGoodsReceipt)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	Table.Order AS Order,
		|	Table.GoodsReceipt AS GoodsReceipt,
		|	Table.ItemKey,
		|	SUM(Table.QuantityBalance) AS Quantity,
		|	Table.RowKey
		|FROM
		|	AccumulationRegister.ReceiptOrders.Balance(, GoodsReceipt IN (&ArrayOfGoodsReceipt)) AS Table
		|GROUP BY
		|	Table.Order,
		|	Table.GoodsReceipt,
		|	Table.ItemKey,
		|	Table.RowKey
		|HAVING
		|	SUM(Table.QuantityBalance) > 0";
	Query.SetParameter("ArrayOfGoodsReceipt", ArrayOfGoodsReceipt);
	Selection = Query.Execute().Select();
	
	InfoGoodsReceipt = New Array;
	While Selection.Next() Do
		RowStructure = New Structure("Order,GoodsReceipt,ItemKey,RowKey,Quantity");
		FillPropertyValues(RowStructure, Selection);
		InfoGoodsReceipt.Add(RowStructure);
	EndDo;
	Return InfoGoodsReceipt;
	
EndFunction

#Region Errors

&AtServer
Function GetErrorMessage(BasisDocument)
	ErrorMessage = Undefined;
	
	If TypeOf(BasisDocument) = Type("DocumentRef.SalesOrder") Then
		If Not BasisDocument.Status.Posting Or Not BasisDocument.Posted Then
			Return StrTemplate(R().Error_067, String(BasisDocument));		
		EndIf;
		ErrorMessage = R().Error_016;
	ElsIf TypeOf(BasisDocument) = Type("DocumentRef.PurchaseOrder") Then
		If Not BasisDocument.Status.Posting Or Not BasisDocument.Posted Then
			Return StrTemplate(R().Error_067, String(BasisDocument));		
		EndIf;
		If BasisDocument.GoodsReceiptBeforePurchaseInvoice Then
			If GoodsReceiptExist(BasisDocument) Then
				ErrorMessage = R().Error_019;
				ErrorMessage = StrTemplate(ErrorMessage, Metadata.Documents.PurchaseInvoice.Synonym, BasisDocument.Metadata().Synonym);
			Else
				ErrorMessage = R().Error_017;
			EndIf;
		Else
			ErrorMessage = R().Error_019;
			ErrorMessage = StrTemplate(ErrorMessage, Metadata.Documents.PurchaseInvoice.Synonym, BasisDocument.Metadata().Synonym);
		EndIf;
	Else
		ErrorMessage = R().Error_019;
		ErrorMessage = StrTemplate(ErrorMessage, Metadata.Documents.PurchaseInvoice.Synonym, BasisDocument.Metadata().Synonym);
	EndIf;
	
	If ErrorMessage = Undefined Then
		Return Undefined;
	EndIf;
	
	Return ErrorMessage;
	
EndFunction

&AtServer
Function GetInfoMessage(FillingData)
	InfoMessage = "";
	If FillingData.BasedOn = "PurchaseOrder" Then
		BasisDocument = New Array();
		For Each Row In FillingData.ItemList Do
			BasisDocument.Add(Row.PurchaseOrder);
		EndDo;
		If PurchaseInvoiceExist(BasisDocument) Then
			InfoMessage = StrTemplate(R()["InfoMessage_001"], 
										Metadata.Documents.PurchaseInvoice.Synonym,
										Metadata.Documents.PurchaseOrder.Synonym);
		EndIf;
	EndIf;
	Return InfoMessage;	
EndFunction

&AtServer
Function GoodsReceiptExist(BasisDocument)
	Query = New Query(
	"SELECT ALLOWED TOP 1
	|	ReceiptOrdersBalance.Order AS Order,
	|	ReceiptOrdersBalance.GoodsReceipt AS GoodsReceipt
	|FROM
	|	AccumulationRegister.ReceiptOrders.Balance(, Order = &BasisDocument
	|		AND GoodsReceipt <> VALUE(Document.GoodsReceipt.EmptyRef)) AS ReceiptOrdersBalance");
	Query.SetParameter("BasisDocument", BasisDocument);
	Return Not Query.Execute().IsEmpty();
EndFunction

&AtServer
Function PurchaseInvoiceExist(BasisDocument)
	Query = New Query(
	"SELECT TOP 1
	|	OrderBalanceTurnovers.Recorder,
	|	OrderBalanceTurnovers.QuantityExpense AS QuantityExpense
	|FROM
	|	AccumulationRegister.OrderBalance.Turnovers(, , Recorder, Order IN (&BasisDocument)) AS OrderBalanceTurnovers
	|WHERE
	|	VALUETYPE(OrderBalanceTurnovers.Recorder) = TYPE(Document.PurchaseInvoice)");
	Query.SetParameter("BasisDocument", BasisDocument);
	Return Not Query.Execute().IsEmpty();
EndFunction

#EndRegion

