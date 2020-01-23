#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	DocumentsClientServer.ChangeTitleCollapse(Object, Form, Not ValueIsFilled(Object.Ref));
	If Form.Parameters.Key.IsEmpty() Then
		Form.CurrentPartner = Object.Partner;
		Form.CurrentAgreement = Object.Agreement;
		Form.CurrentDate = Object.Date;
		Form.StoreBeforeChange 		= Form.Store;
		
		DocumentsClientServer.FillDefinedData(Object, Form);
		
		SetGroupItemsList(Object, Form);
		DocumentsServer.FillItemList(Object);
		
		ObjectData = DocumentsClientServer.GetStructureFillStores();
		FillPropertyValues(ObjectData, Object);
		DocumentsClientServer.FillStores(ObjectData, Form);
		
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	DocumentsServer.ShowUserMessageOnCreateAtServer(Form);
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	Form.CurrentPartner = CurrentObject.Partner;
	Form.CurrentAgreement = CurrentObject.Agreement;
	Form.CurrentDate = CurrentObject.Date;
	DocumentsServer.FillItemList(Object);
	
	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, CurrentObject);
	DocumentsClientServer.FillStores(ObjectData, Form);
	
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	Form.CurrentPartner = CurrentObject.Partner;
	Form.CurrentAgreement = CurrentObject.Agreement;
	Form.CurrentDate = CurrentObject.Date;
		
	DocumentsServer.FillItemList(Object);
	
	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, CurrentObject);
	DocumentsClientServer.FillStores(ObjectData, Form);
	
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
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

Function GetAgreementByPartner(Partner, Agreement) Export
	If Not Partner.IsEmpty() Then
		ArrayOfFilters = New Array();
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", Enums.AgreementTypes.Vendor, ComparisonType.Equal));
		If ValueIsFilled(Agreement) Then
			ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Ref", Agreement, ComparisonType.Equal));
		EndIf;
		AdditionalParameters = New Structure();
		AdditionalParameters.Insert("IncludeFilterByEndOfUseDate", True);
		AdditionalParameters.Insert("IncludeFilterByPartner", True);
		AdditionalParameters.Insert("IncludePartnerSegments", True);
		AdditionalParameters.Insert("EndOfUseDate", CurrentDate());
		AdditionalParameters.Insert("Partner", Partner);
		Parameters = New Structure("CustomSearchFilter, AdditionalParameters",
				DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters),
				DocumentsServer.SerializeArrayOfFilters(AdditionalParameters));
		Return Catalogs.Agreements.GetDefaultChoiseRef(Parameters);
	EndIf;
	Return Undefined;
EndFunction

Function GetLegalNameByPartner(Partner, LegalName) Export
	If Not Partner.IsEmpty() Then
		ArrayOfFilters = New Array();
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		If ValueIsFilled(LegalName) Then
			ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Ref", LegalName, ComparisonType.Equal));
		EndIf;
		AdditionalParameters = New Structure();
		If ValueIsFilled(Partner) Then
			AdditionalParameters.Insert("Partner", Partner);
			AdditionalParameters.Insert("FilterByPartnerHierarchy", True);
		EndIf;
		Parameters = New Structure("CustomSearchFilter, AdditionalParameters",
				DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters),
				DocumentsServer.SerializeArrayOfFilters(AdditionalParameters));
		Return Catalogs.Companies.GetDefaultChoiseRef(Parameters);
	EndIf;
	Return Undefined;
EndFunction


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
		|		AND NOT GoodsReceipt IN (&ExistingShipArray)) AS ReceiptOrdersBalance
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
	
	Query.SetParameter("ExistingShipArray", Parameters.ExistingShipArray);
	
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

Procedure FillDocumentWithGoodsReceiptArray(Object, Form, ArrayOfBasisDocuments) Export
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
		|	tmp.GoodsReceipt,
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
		|	QueryTable.GoodsReceipt,
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
		|	tmpQueryTable.ItemKey AS ItemKey,
		|	tmpQueryTable.ItemKey.Item AS Item,
		|	tmpQueryTable.Store AS Store,
		|	tmpQueryTable.PurchaseOrder AS PurchaseOrder,
		|	tmpQueryTable.Key,
		|	tmpQueryTable.Unit AS QuantityUnit,
		|	tmpQueryTable.Quantity AS Quantity,
		|	CAST(Doc.PurchaseBasis AS Document.SalesOrder) AS SalesOrder,
		|	ISNULL(Doc.Price, 0) AS Price,
		|	ISNULL(Doc.PriceType, VALUE(Catalog.PriceTypes.EmptyRef)) AS PriceType,
		|	ISNULL(Doc.Unit, VALUE(Catalog.Units.EmptyRef)) AS Unit,
		|	ISNULL(Doc.DeliveryDate, DATETIME(1, 1, 1)) AS DeliveryDate,
		|	tmpQueryTable.GoodsReceipt AS GoodsReceipt
		|FROM
		|	Document.PurchaseOrder.ItemList AS Doc
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.Key = Doc.Key
		|		AND tmpQueryTable.PurchaseOrder = Doc.Ref";
	
	Query.SetParameter("QueryTable", QueryTableOrderBalance);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	DocumentsServer.RecalculateQuantityInTable(QueryTable);
	
	Settings = New Structure();
	Settings.Insert("Rows", New Array());
	Settings.Insert("CalculateSettings", New Structure());
	Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	
	For Each Row In QueryTable Do
		RowsByKey = Object.ItemList.FindRows(New Structure("Key", Row.Key));
		If RowsByKey.Count() Then
			RowByKey = RowsByKey[0];
			ItemKeyUnit = CatItemsServer.GetItemKeyUnit(Row.ItemKey);
			UnitFactorFrom = Catalogs.Units.GetUnitFactor(RowByKey.Unit, ItemKeyUnit);
			UnitFactorTo = Catalogs.Units.GetUnitFactor(Row.Unit, ItemKeyUnit);
			FillPropertyValues(RowByKey, Row);
			RowByKey.Quantity = ?(UnitFactorTo = 0,
					0,
					RowByKey.Quantity * UnitFactorFrom / UnitFactorTo);
			RowByKey.PriceType = Row.PriceType;
			RowByKey.Price = Row.Price;
			Settings.Rows.Add(RowByKey);
		Else
			NewRow = Object.ItemList.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.PriceType = Row.PriceType;
			NewRow.Price = Row.Price;
			Settings.Rows.Add(NewRow);
		EndIf;
	EndDo;
	
	TaxInfo = Undefined;
	SavedData = TaxesClientServer.GetSavedData(Form, TaxesServer.GetAttributeNames().CacheName);
	If SavedData.Property("ArrayOfColumnsInfo") Then
		TaxInfo = SavedData.ArrayOfColumnsInfo;
	EndIf;
	CalculationStringsClientServer.CalculateItemsRows(Object,
		Form,
		Settings.Rows,
		Settings.CalculateSettings,
		TaxInfo);
EndProcedure

#Region ListFormEvents

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion