#Region FormEvents

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

Function GetInfoGoodsReceiptBeforePurchaseInvoice(Parameters) Export
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	PurchaseOrder.Ref AS Order
		|into tmp
		|FROM
		|	Document.PurchaseOrder AS PurchaseOrder
		|WHERE
		|	PurchaseOrder.Company = &Company
		|	AND PurchaseOrder.Partner = &Partner
		|	AND PurchaseOrder.LegalName = &LegalName
		|	AND PurchaseOrder.Agreement = &Agreement
		|	AND PurchaseOrder.Currency = &Currency
		|	AND PurchaseOrder.PriceIncludeTax = &PriceIncludeTax
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT ALLOWED
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
		|	AccumulationRegister.ReceiptOrders.Balance(, order in
		|		(select
		|			order
		|		from
		|			tmp)
		|		AND NOT GoodsReceipt IN (&AlreadySelectedGoodsReceipts)) AS ReceiptOrdersBalance
		|WHERE
		|	ReceiptOrdersBalance.QuantityBalance > 0
		|TOTALS
		|BY
		|	Order,
		|	GoodsReceipt";
	Query.SetParameter("Company", Parameters.Company);
	Query.SetParameter("Partner", Parameters.Partner);
	Query.SetParameter("LegalName", Parameters.LegalName);
	Query.SetParameter("Agreement", Parameters.Agreement);
	Query.SetParameter("Currency", Parameters.Currency);
	Query.SetParameter("PriceIncludeTax", Parameters.PriceIncludeTax);
	
	Query.SetParameter("AlreadySelectedGoodsReceipts", Parameters.AlreadySelectedGoodsReceipts);
	
	QueryResult = Query.Execute();
	Return DocPurchaseInvoiceServer.GetInfoGoodsReceiptBeforeSalesInvoiceFromQueryResult(QueryResult);
EndFunction

Function GetInfoGoodsReceiptBeforeSalesInvoiceFromQueryResult(QueryResult) Export
	
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

Procedure FillDocumentWithGoodsReceiptArray(Object, Form, ArrayOfBasisDocuments) Export
	ValueTable = New ValueTable();
	ValueTable.Columns.Add("Order", New TypeDescription("DocumentRef.PurchaseOrder"));	
	ValueTable.Columns.Add("ItemKey", New TypeDescription("CatalogRef.ItemKeys"));
	ValueTable.Columns.Add("Quantity", New TypeDescription(Metadata.DefinedTypes.typeQuantity.Type));
	ValueTable.Columns.Add("RowKey", Metadata.AccumulationRegisters.ReceiptOrders.Dimensions.RowKey.Type);
	
	GoodsReceiptsTable = CreateTable_GoodsReceipts();
	
	For Each Row In ArrayOfBasisDocuments Do		
		NewRow = ValueTable.Add();
		NewRow.Order = Row.Order;
		NewRow.ItemKey = Row.ItemKey;
		NewRow.RowKey = Row.RowKey;
		NewRow.Quantity = Row.Quantity;
		
		NewRow = GoodsReceiptsTable.Add();
		NewRow.Ref = Row.Order;
		NewRow.GoodsReceipt = Row.GoodsReceipt;
		NewRow.Key = New UUID(Row.RowKey);
		NewRow.Quantity = Row.Quantity;
		NewRow.QuantityInGoodsReceipt = Row.Quantity;
	EndDo;
	
	ValueTable.GroupBy("Order, ItemKey, RowKey", "Quantity");
	GoodsReceiptsTable.GroupBy("GoodsReceipt, Key, Ref", "Quantity, QuantityInGoodsReceipt");
	
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
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT ALLOWED
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
		|			tmp.RowKey
		|		FROM
		|			tmp AS tmp)
		|	AND ItemKey.Item.ItemType.Type <> VALUE(enum.ItemTypes.Service)) AS OrderBalanceBalance
		|		INNER JOIN tmp AS tmp
		|		ON tmp.Order = OrderBalanceBalance.Order
		|		AND tmp.ItemKey = OrderBalanceBalance.ItemKey
		|		AND tmp.RowKey = OrderBalanceBalance.RowKey
		|		AND OrderBalanceBalance.QuantityBalance > 0";
	Query.SetParameter("ValueTable", ValueTable);
	
	QueryTableOrderBalance = Query.Execute().Unload();
	
	QueryTableOrderBalance.Columns.Add("Key", New TypeDescription("UUID"));
	For Each Row In QueryTableOrderBalance Do
		Row.Key = New UUID(Row.RowKey);
	EndDo;
	
	Query = New Query();
	Query.Text =
		"SELECT
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
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT ALLOWED
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
	
	Query.SetParameter("QueryTable", QueryTableOrderBalance);
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
		Row_ItemList.PurchaseOrder = Row.PurchaseOrder;
		Row_ItemList.Quantity      = Row_ItemList.Quantity + Row.Quantity;
		Row_ItemList.Price         = Row.Price;
		Row_ItemList.Unit          = Row.Unit;
		Row_ItemList.TaxAmount     = Row_ItemList.TaxAmount + Row.TaxAmount;
		Row_ItemList.TotalAmount   = Row_ItemList.TotalAmount + Row.TotalAmount;
		Row_ItemList.NetAmount     = Row_ItemList.NetAmount + Row.NetAmount;
		Row_ItemList.OffersAmount  = Row_ItemList.OffersAmount + Row.OffersAmount;
		Row_ItemList.DeliveryDate  = Row.DeliveryDate;
		Row_ItemList.PriceType     = Row.PriceType;
		Row_ItemList.BusinessUnit  = Row.BusinessUnit;
		Row_ItemList.ExpenseType   = Row.ExpenseType;
		Row_ItemList.SalesOrder    = Row.SalesOrder;
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
	
	For Each Row In QueryTable_SpecialOffers Do
		FilterByKey = New Structure("Key", Row.Key);
		Rows_SpecialOffers = Object.SpecialOffers.FindRows(FilterByKey);
		If Rows_SpecialOffers.Count() Then
			Row_SpecialOffers = Rows_SpecialOffers[0];
		Else
			Row_SpecialOffers = Object.SpecialOffers.Add();
		EndIf;
		
		Row_SpecialOffers.Key     = Row.Key; 
		Row_SpecialOffers.Offer   = Row.Offer; 
		Row_SpecialOffers.Amount  = Row_SpecialOffers.Amount + Row.Amount;
		Row_SpecialOffers.Percent = Row.Percent;		
	EndDo;
	
	For Each Row In GoodsReceiptsTable Do
		FilterByKey = New Structure("Key, GoodsReceipt", Row.Key, Row.GoodsReceipt);
		Rows_GoodsReceipts = Object.GoodsReceipts.FindRows(FilterByKey);
		If Rows_GoodsReceipts.Count() Then
			Row_GoodsReceipts = Rows_GoodsReceipts[0];
		Else
			Row_GoodsReceipts = Object.GoodsReceipts.Add();
		EndIf;
		
		Row_GoodsReceipts.Key                    = Row.Key;
		Row_GoodsReceipts.GoodsReceipt           = Row.GoodsReceipt;
		Row_GoodsReceipts.Quantity               = Row.Quantity;
		Row_GoodsReceipts.QuantityInGoodsReceipt = Row.QuantityInGoodsReceipt;
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