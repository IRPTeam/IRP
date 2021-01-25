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
				If ValueIsFilled(Row.Order) Then
					ArrayOf_Service.Add(Row.Order);
				EndIf;
			EndIf;
		EndIf;
		
	EndDo;
	
	ArrayOfTables = New Array();
	ArrayOfTables.Add(GetDocumentTable_PurchaseOrder_NotIsService(ArrayOf_PurchaseOrder));
	ArrayOfTables.Add(GetDocumentTable_GoodsReceipt(ArrayOf_GoodsReceipt));
	ArrayOfTables.Add(GetDocumentTable_PurchaseOrder_IsService(ArrayOf_Service));
	ArrayOfTables.Add(GetDocumentTable_SalesOrder(ArrayOf_SalesOrder));
	
	Return JoinDocumentsStructure(ArrayOfTables, 
	"BasedOn, Company, Partner, LegalName, Agreement, Currency, PriceIncludeTax");
EndFunction

&AtServer
Function JoinDocumentsStructure(ArrayOfTables, UnjoinFields)
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
	ItemList.Columns.Add("Key"				, New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	ItemList.Columns.Add("RowKey"			, New TypeDescription("String"));
	ItemList.Columns.Add("DeliveryDate"		, New TypeDescription("Date"));
	ItemList.Columns.Add("SalesOrder"		, New TypeDescription("DocumentRef.SalesOrder"));
	ItemList.Columns.Add("DontCalculateRow" , New TypeDescription("Boolean"));
	
	TaxListMetadataColumns = Metadata.Documents.PurchaseInvoice.TabularSections.TaxList.Attributes;
	TaxList = New ValueTable();
	TaxList.Columns.Add("Key"					, TaxListMetadataColumns.Key.Type);
	TaxList.Columns.Add("Tax"					, TaxListMetadataColumns.Tax.Type);
	TaxList.Columns.Add("Analytics"				, TaxListMetadataColumns.Analytics.Type);
	TaxList.Columns.Add("TaxRate"				, TaxListMetadataColumns.TaxRate.Type);
	TaxList.Columns.Add("Amount"				, TaxListMetadataColumns.Amount.Type);
	TaxList.Columns.Add("IncludeToTotalAmount"	, TaxListMetadataColumns.IncludeToTotalAmount.Type);
	TaxList.Columns.Add("ManualAmount"			, TaxListMetadataColumns.ManualAmount.Type);
	TaxList.Columns.Add("Ref"					, New TypeDescription("DocumentRef.PurchaseOrder"));
	
	SpecialOffersMetadataColumns = Metadata.Documents.PurchaseInvoice.TabularSections.SpecialOffers.Attributes;
	SpecialOffers = New ValueTable();
	SpecialOffers.Columns.Add("Key"		, SpecialOffersMetadataColumns.Key.Type);
	SpecialOffers.Columns.Add("Offer"	, SpecialOffersMetadataColumns.Offer.Type);
	SpecialOffers.Columns.Add("Amount"	, SpecialOffersMetadataColumns.Amount.Type);
	SpecialOffers.Columns.Add("Percent"	, SpecialOffersMetadataColumns.Percent.Type);
	SpecialOffers.Columns.Add("Ref"		, New TypeDescription("DocumentRef.PurchaseOrder"));
	
	GoodsReceiptsMetadataColumns = Metadata.Documents.PurchaseInvoice.TabularSections.GoodsReceipts.Attributes;
	GoodsReceipts = New ValueTable();
	GoodsReceipts.Columns.Add("Key"          , GoodsReceiptsMetadataColumns.Key.Type);
	GoodsReceipts.Columns.Add("GoodsReceipt" , GoodsReceiptsMetadataColumns.GoodsReceipt.Type);
	GoodsReceipts.Columns.Add("Quantity"     , GoodsReceiptsMetadataColumns.Quantity.Type);
	GoodsReceipts.Columns.Add("QuantityInGoodsReceipt" , GoodsReceiptsMetadataColumns.QuantityInGoodsReceipt.Type);
	GoodsReceipts.Columns.Add("Ref"          , New TypeDescription("DocumentRef.PurchaseOrder"));
	
	
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
		For Each Row In TableStructure.GoodsReceipts Do
			FillPropertyValues(GoodsReceipts.Add(), Row);
		EndDo;		
	EndDo;
	
	ItemListCopy = ItemList.Copy();
	ItemListCopy.GroupBy(UnjoinFields);
	
	ArrayOfResults = New Array();
	
	For Each Row In ItemListCopy Do
		Result = New Structure(UnjoinFields);
		FillPropertyValues(Result, Row);
		
		Result.Insert("ItemList"		, New Array());
		Result.Insert("TaxList"			, New Array());
		Result.Insert("SpecialOffers"	, New Array());
		Result.Insert("GoodsReceipts"	, New Array());
		
		Filter = New Structure(UnjoinFields);
		FillPropertyValues(Filter, Row);
		
		ArrayOfTaxListFilters = New Array();
		ArrayOfSpecialOffersFilters = New Array();
		ArrayOfGoodsReceiptsFilters = New Array();
		
		ItemListFiltered = ItemList.Copy(Filter);
		For Each RowItemList In ItemListFiltered Do
			NewRow = New Structure();
			
			For Each ColumnItemList In ItemListFiltered.Columns Do
				NewRow.Insert(ColumnItemList.Name, RowItemList[ColumnItemList.Name]);
			EndDo;
			
			NewRow.Key = RowItemList.RowKey;
			
			ArrayOfTaxListFilters.Add(New Structure("Ref, Key", RowItemList.PurchaseOrder, NewRow.Key));
			ArrayOfSpecialOffersFilters.Add(New Structure("Ref, Key", RowItemList.PurchaseOrder, NewRow.Key));
			ArrayOfGoodsReceiptsFilters.Add(New Structure("Ref, Key", RowItemList.PurchaseOrder, NewRow.Key));
			
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
		
		For Each GoodsReceiptsFilter In ArrayOfGoodsReceiptsFilters Do
			For Each RowGoodsReceipts In GoodsReceipts.Copy(GoodsReceiptsFilter) Do
				NewRow = New Structure();
				NewRow.Insert("Key", RowGoodsReceipts.Key);
				NewRow.Insert("GoodsReceipt", RowGoodsReceipts.GoodsReceipt);
				NewRow.Insert("Quantity", RowGoodsReceipts.Quantity);
				NewRow.Insert("QuantityInGoodsReceipt", RowGoodsReceipts.QuantityInGoodsReceipt);
				Result.GoodsReceipts.Add(NewRow);
			EndDo;
		EndDo;
		
		ArrayOfResults.Add(Result);
	EndDo;
	Return ArrayOfResults;
EndFunction

&AtServer
Function ExtractInfoFrom_PurchaseOrder(QueryTable, GoodsReceiptsTable = Undefined)
	QueryTable.Columns.Add("Key", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	For Each Row In QueryTable Do
		Row.Key = Row.RowKey;
	EndDo;
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable.BasedOn,
		|	QueryTable.Store,
		|	QueryTable.PurchaseOrder,
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
		|	ISNULL(ItemList.Quantity, 0) AS OriginalQuantity,
		|	ISNULL(ItemList.Price, 0) AS Price,
		|	ISNULL(ItemList.Unit, VALUE(Catalog.Units.EmptyRef)) AS Unit,
		|	ISNULL(ItemList.TaxAmount, 0) AS TaxAmount,
		|	ISNULL(ItemList.TotalAmount, 0) AS TotalAmount,
		|	ISNULL(ItemList.NetAmount, 0) AS NetAmount,
		|	ISNULL(ItemList.OffersAmount, 0) AS OffersAmount,
		|	ISNULL(ItemList.DeliveryDate, DATETIME(1, 1, 1)) AS DeliveryDate,
		|	ISNULL(ItemList.PriceType, VALUE(Catalog.PriceTypes.EmptyRef)) AS PriceType,
		|	ItemList.BusinessUnit,
		|	ItemList.ExpenseType,
		|	CASE
		|		WHEN ItemList.PurchaseBasis REFS Document.SalesOrder
		|			THEN ItemList.PurchaseBasis
		|		ELSE UNDEFINED
		|	END AS SalesOrder,
		|	ISNULL(ItemList.DontCalculateRow, FALSE) AS DontCalculateRow
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
		
		For Each Row_SpecialOffers In QueryTable_SpecialOffers.FindRows(New Structure("Key", Row_ItemList.Key)) Do
			If Row_ItemList.OriginalQuantity = 0 Then
				Row_SpecialOffers.Amount = 0;
			Else
				Row_SpecialOffers.Amount = Row_SpecialOffers.Amount / Row_ItemList.OriginalQuantity * Row_ItemList.Quantity;
			EndIf;
		EndDo;		
	EndDo;

	Return New Structure("ItemList, TaxList, SpecialOffers, GoodsReceipts", 
	QueryTable_ItemList, 
	QueryTable_TaxList, 
	QueryTable_SpecialOffers,
	?(GoodsReceiptsTable = Undefined, CreateTable_GoodsReceipts(), GoodsReceiptsTable));
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
	Return New Structure("ItemList, TaxList, SpecialOffers, GoodsReceipts", 
							QueryResult.Unload(), 
							New ValueTable(),
							New ValueTable(),
							New ValueTable());
EndFunction

&AtServer
Function GetDocumentTable_PurchaseOrder_IsService(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	""PurchaseOrder"" AS BasedOn,
		|	OrderBalanceBalance.Store AS Store,
		|	OrderBalanceBalance.Order AS PurchaseOrder,
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
Function GetDocumentTable_PurchaseOrder_NotIsService(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	""PurchaseOrder"" AS BasedOn,
		|	OrderBalanceBalance.Store AS Store,
		|	OrderBalanceBalance.Order AS PurchaseOrder,
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
	BasedOnPurchaseOrderTable = New ValueTable();
	BasedOnPurchaseOrderTable.Columns.Add("Order", New TypeDescription("DocumentRef.PurchaseOrder"));	
	BasedOnPurchaseOrderTable.Columns.Add("ItemKey", New TypeDescription("CatalogRef.ItemKeys"));
	BasedOnPurchaseOrderTable.Columns.Add("Quantity", New TypeDescription(Metadata.DefinedTypes.typeQuantity.Type));
	BasedOnPurchaseOrderTable.Columns.Add("RowKey", Metadata.AccumulationRegisters.ReceiptOrders.Dimensions.RowKey.Type);
	
	BasedOnGoodsReceiptTable = New ValueTable();
	BasedOnGoodsReceiptTable.Columns.Add("Order", New TypeDescription("DocumentRef.PurchaseOrder"));
	BasedOnGoodsReceiptTable.Columns.Add("ItemKey", New TypeDescription("CatalogRef.ItemKeys"));
	BasedOnGoodsReceiptTable.Columns.Add("Quantity", New TypeDescription(Metadata.DefinedTypes.typeQuantity.Type));
	BasedOnGoodsReceiptTable.Columns.Add("RowKey", Metadata.AccumulationRegisters.ReceiptOrders.Dimensions.RowKey.Type);
	BasedOnGoodsReceiptTable.Columns.Add("Partner", New TypeDescription("CatalogRef.Partners"));
	BasedOnGoodsReceiptTable.Columns.Add("LegalName", New TypeDescription("CatalogRef.Companies"));
	BasedOnGoodsReceiptTable.Columns.Add("Company", New TypeDescription("CatalogRef.Companies"));
	BasedOnGoodsReceiptTable.Columns.Add("Unit", New TypeDescription("CatalogRef.Units"));
	
	GoodsReceiptsTable = CreateTable_GoodsReceipts();
	
	For Each Row In ArrayOfBasisDocuments Do
		RowKey = ?(ValueIsFilled(Row.RowKey), Row.RowKey, String(New UUID()));
		If ValueIsFilled(Row.Order) Then		
			BasedOnPurchaseOrderTable_NewRow = BasedOnPurchaseOrderTable.Add();
			BasedOnPurchaseOrderTable_NewRow.Order = Row.Order;
			BasedOnPurchaseOrderTable_NewRow.ItemKey = Row.ItemKey;
			BasedOnPurchaseOrderTable_NewRow.RowKey = Row.RowKey;
			BasedOnPurchaseOrderTable_NewRow.Quantity = Row.Quantity;
		Else
			BasedOnGoodsReceiptTable_NewRow = BasedOnGoodsReceiptTable.Add();
			BasedOnGoodsReceiptTable_NewRow.Order = Row.Order;
			BasedOnGoodsReceiptTable_NewRow.ItemKey = Row.ItemKey;
			BasedOnGoodsReceiptTable_NewRow.RowKey = RowKey;
			BasedOnGoodsReceiptTable_NewRow.Quantity = Row.Quantity;
			BasedOnGoodsReceiptTable_NewRow.Partner = Row.GoodsReceipt.Partner;
			BasedOnGoodsReceiptTable_NewRow.LegalName = Row.GoodsReceipt.LegalName;	
			BasedOnGoodsReceiptTable_NewRow.Company = Row.GoodsReceipt.Company;	
			If ValueIsFilled(Row.ItemKey.Unit) Then
				BasedOnGoodsReceiptTable_NewRow.Unit = Row.ItemKey.Unit;
			Else
				If ValueIsFilled(Row.ItemKey.Item.Unit) Then
					BasedOnGoodsReceiptTable_NewRow.Unit = Row.ItemKey.Item.Unit;
				EndIf;
			EndIf;
		EndIf;
		
		GoodsReceiptsTable_NewRow = GoodsReceiptsTable.Add();
		GoodsReceiptsTable_NewRow.Ref = Row.Order;
		GoodsReceiptsTable_NewRow.GoodsReceipt = Row.GoodsReceipt;
		GoodsReceiptsTable_NewRow.Key = RowKey;
		GoodsReceiptsTable_NewRow.Quantity = Row.Quantity;
		GoodsReceiptsTable_NewRow.QuantityInGoodsReceipt = Row.Quantity;
	EndDo;
	
	BasedOnPurchaseOrderTable.GroupBy("Order, ItemKey, RowKey", "Quantity");
	GoodsReceiptsTable.GroupBy("GoodsReceipt, Key, Ref", "Quantity, QuantityInGoodsReceipt");
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	BasedOnPurchaseOrderTable.Order AS Order,
		|	BasedOnPurchaseOrderTable.ItemKey AS ItemKey,
		|	BasedOnPurchaseOrderTable.RowKey AS RowKey, 
		|	BasedOnPurchaseOrderTable.Quantity AS Quantity
		|INTO tmp
		|FROM
		|	&BasedOnPurchaseOrderTable AS BasedOnPurchaseOrderTable
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
	Query.SetParameter("BasedOnPurchaseOrderTable", BasedOnPurchaseOrderTable);
	
	OrderBalanceTable = Query.Execute().Unload();
	
	TablesFromPurchaseOrder = ExtractInfoFrom_PurchaseOrder(OrderBalanceTable, GoodsReceiptsTable);
	
	For Each Row In BasedOnGoodsReceiptTable Do
	 	ItemLIst_NewRow = TablesFromPurchaseOrder.ItemList.Add();
	 	FillPropertyValues(ItemLIst_NewRow, Row);
	 	
	 	ItemLIst_NewRow.BasedOn = "GoodsReceipt";
	 	ItemLIst_NewRow.PurchaseOrder = Row.Order;
	 	ItemLIst_NewRow.Key = Row.RowKey;	 	
	 EndDo;
	
	Return TablesFromPurchaseOrder;
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
Function GetInfoGoodsReceiptBeforePurchaseInvoice(ArrayOfOrders)
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
		|	AccumulationRegister.ReceiptOrders.Balance(, Order IN (&ArrayOfOrders)) AS ReceiptOrdersBalance
		|TOTALS
		|BY
		|	Order,
		|	GoodsReceipt";
	Query.SetParameter("ArrayOfOrders", ArrayOfOrders);
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
		|	ReceiptOrders.Order AS Order,
		|	ReceiptOrders.GoodsReceipt AS GoodsReceipt,
		|	ReceiptOrders.ItemKey,
		|	SUM(ReceiptOrders.QuantityBalance) AS Quantity,
		|	ReceiptOrders.RowKey
		|INTO ReceiptOrders
		|FROM
		|	AccumulationRegister.ReceiptOrders.Balance(, GoodsReceipt IN (&ArrayOfGoodsReceipt)) AS ReceiptOrders
		|GROUP BY
		|	ReceiptOrders.Order,
		|	ReceiptOrders.GoodsReceipt,
		|	ReceiptOrders.ItemKey,
		|	ReceiptOrders.RowKey
		|HAVING
		|	SUM(ReceiptOrders.QuantityBalance) > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT ALLOWED
		|	ReceiptOrders.Order AS Order,
		|	ReceiptOrders.GoodsReceipt AS GoodsReceipt,
		|	ReceiptOrders.ItemKey AS ItemKey,
		|	ReceiptOrders.Quantity AS Quantity,
		|	ReceiptOrders.RowKey AS RowKey
		|FROM
		|	ReceiptOrders AS ReceiptOrders
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(Document.PurchaseOrder.EmptyRef),
		|	ReceiptInvoicing.Basis,
		|	ReceiptInvoicing.ItemKey,
		|	ReceiptInvoicing.QuantityBalance,
		|	""""
		|FROM
		|	AccumulationRegister.R1031B_ReceiptInvoicing.Balance(, Basis IN (&ArrayOfGoodsReceipt)
		|	AND NOT (Basis, ItemKey) IN
		|		(SELECT
		|			ReceiptOrders.GoodsReceipt,
		|			ReceiptOrders.ItemKey
		|		FROM
		|			ReceiptOrders AS ReceiptOrders)
		|	AND CAST(Basis AS Document.GoodsReceipt).TransactionType = VALUE(Enum.GoodsReceiptTransactionTypes.Purchase)) AS
		|		ReceiptInvoicing";
		
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

Function CreateTable_GoodsReceipts()
	ColumnsMetadata = Metadata.Documents.PurchaseInvoice.TabularSections.GoodsReceipts.Attributes;
	GoodsReceiptsTable = New ValueTable();
	GoodsReceiptsTable.Columns.Add("Key", ColumnsMetadata.Key.Type);
	GoodsReceiptsTable.Columns.Add("GoodsReceipt", ColumnsMetadata.GoodsReceipt.Type);
	GoodsReceiptsTable.Columns.Add("Quantity", ColumnsMetadata.Quantity.Type);
	GoodsReceiptsTable.Columns.Add("QuantityInGoodsReceipt", ColumnsMetadata.Quantity.Type);
	GoodsReceiptsTable.Columns.Add("Ref" , New TypeDescription("DocumentRef.PurchaseOrder"));
	Return GoodsReceiptsTable;
EndFunction

#Region Errors

&AtServer
Function GetErrorMessage(BasisDocument)
	ErrorMessage = Undefined;
	
	If TypeOf(BasisDocument) = Type("DocumentRef.SalesOrder") Then
		If Not BasisDocument.Status.Posting Or Not BasisDocument.Posted Then
			Return StrTemplate(R().Error_054, String(BasisDocument));		
		EndIf;
		ErrorMessage = R().Error_016;
	ElsIf TypeOf(BasisDocument) = Type("DocumentRef.PurchaseOrder") Then
		If Not BasisDocument.Status.Posting Or Not BasisDocument.Posted Then
			Return StrTemplate(R().Error_054, String(BasisDocument));		
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
			InfoMessage = StrTemplate(R().InfoMessage_001, 
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

