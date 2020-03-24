#Region FormEvents

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	Form.CurrentPartner = CurrentObject.Partner;
	Form.CurrentAgreement = CurrentObject.Agreement;
	Form.CurrentDate = CurrentObject.Date;
	
	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, CurrentObject);
	DocumentsClientServer.FillStores(ObjectData, Form);
	
	DocumentsServer.FillItemList(Object);
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

Procedure BeforeWrite(Object, Form, Cancel, WriteMode, PostingMode) Export
	Return;
EndProcedure

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then

		DocumentsClientServer.FillDefinedData(Object, Form);
		
		Form.CurrentPartner = Object.Partner;
		Form.CurrentAgreement = Object.Agreement;
		Form.CurrentDate = Object.Date;
		Form.StoreBeforeChange 		= Form.Store;
		
		ObjectData = DocumentsClientServer.GetStructureFillStores();
		FillPropertyValues(ObjectData, Object);
		DocumentsClientServer.FillStores(ObjectData, Form);
		
		DocumentsServer.FillItemList(Object);
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	
	DocumentsServer.ShowUserMessageOnCreateAtServer(Form);
EndProcedure

Procedure CalculateTableAtServer(Form, Object) Export
	If Form.Parameters.FillingValues.Property("BasedOn")Then
		
		If ValueIsFilled(Object.Agreement) Then
			
			CalculationSettings = CalculationStringsClientServer.GetCalculationSettings();
			CalculationSettings.Insert("UpdatePrice", 
							New Structure("Period, PriceType", Object.Date, Object.Agreement.PriceType));
			
			CalculateRows = New Array();
			
			For Each Row In Object.ItemList Do
				If ValueIsFilled(Row.ShipmentConfirmation) And Not ValueIsFilled(Row.SalesOrder) Then
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
	Form.CurrentPartner = CurrentObject.Partner;
	Form.CurrentAgreement = CurrentObject.Agreement;
	Form.CurrentDate = CurrentObject.Date;
		
	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, CurrentObject);
	DocumentsClientServer.FillStores(ObjectData, Form);
	
	DocumentsServer.FillItemList(Object);
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
		PrevRow = Object.ItemList.Get(RowCount - 2);
		ReturnValue = PrevRow.Store;
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
|	NOT ShipmentConfirmation IN (&ExistingShipArray)) AS ShipmentOrdersBalance
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
|	NOT ShipmentBasis IN (&ExistingShipArray)) AS GoodsInTransitOutgoingBalance
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
	
	Query.SetParameter("ExistingShipArray", Parameters.ExistingShipArray);
	
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

Procedure FillDocumentWithShipmentConfirmationArray(Object, Form, ArrayOfBasisDocuments) Export
	ValueTable = New ValueTable();
	ValueTable.Columns.Add("Order", New TypeDescription("DocumentRef.SalesOrder"));
	
	ValueTable.Columns.Add("ShipmentConfirmation"
		, New TypeDescription(Metadata.AccumulationRegisters.ShipmentOrders.Dimensions.ShipmentConfirmation.Type));
	
	ValueTable.Columns.Add("ItemKey", New TypeDescription("CatalogRef.ItemKeys"));
	ValueTable.Columns.Add("Quantity", New TypeDescription(Metadata.DefinedTypes.typeQuantity.Type));
	ValueTable.Columns.Add("RowKey", Metadata.AccumulationRegisters.ShipmentOrders.Dimensions.RowKey.Type);
	
	For Each Row In ArrayOfBasisDocuments Do
		NewRow = ValueTable.Add();
		NewRow.Order = Row.Order;
		NewRow.ShipmentConfirmation = Row.ShipmentConfirmation;
		NewRow.ItemKey = Row.ItemKey;
		NewRow.RowKey = Row.RowKey;
		NewRow.Quantity = Row.Quantity;
	EndDo;
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	ValueTable.Order AS Order,
		|	ValueTable.ShipmentConfirmation AS ShipmentConfirmation,
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
		|	OrderBalanceBalance.Order AS SalesOrder,
		|	OrderBalanceBalance.ItemKey,
		|	CASE
		|		WHEN OrderBalanceBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN OrderBalanceBalance.ItemKey.Unit
		|		ELSE OrderBalanceBalance.ItemKey.Item.Unit
		|	END AS Unit,
		|	OrderBalanceBalance.Store,
		|	tmp.Quantity,
		|	tmp.ShipmentConfirmation,
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
		|	VALUE(Document.SalesOrder.EmptyRef),
		|	GoodsInTransitOutgoingBalance.ItemKey,
		|	CASE
		|		WHEN GoodsInTransitOutgoingBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN GoodsInTransitOutgoingBalance.ItemKey.Unit
		|		ELSE GoodsInTransitOutgoingBalance.ItemKey.Item.Unit
		|	END,
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
		|			tmp AS tmp)) AS GoodsInTransitOutgoingBalance
		|		INNER JOIN tmp AS tmp
		|		ON tmp.ShipmentConfirmation = GoodsInTransitOutgoingBalance.ShipmentBasis
		|		AND tmp.ItemKey = GoodsInTransitOutgoingBalance.ItemKey
		|		AND tmp.RowKey = GoodsInTransitOutgoingBalance.RowKey
		|		AND GoodsInTransitOutgoingBalance.QuantityBalance < 0";
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
		|	tmpQueryTable.ItemKey AS ItemKey,
		|	tmpQueryTable.ItemKey.Item AS Item,
		|	tmpQueryTable.Store AS Store,
		|	tmpQueryTable.SalesOrder AS SalesOrder,
		|	tmpQueryTable.Key,
		|	tmpQueryTable.Unit AS QuantityUnit,
		|	tmpQueryTable.Quantity AS Quantity,
		|	ISNULL(Doc.Price, 0) AS Price,
		|	ISNULL(Doc.Unit, VALUE(Catalog.Units.EmptyRef)) AS Unit,
		|	ISNULL(Doc.DeliveryDate, DATETIME(1, 1, 1)) AS DeliveryDate,
		|	tmpQueryTable.ShipmentConfirmation AS ShipmentConfirmation,
		|	ISNULL(Doc.TotalAmount, 0) AS TotalAmount,
		|	ISNULL(Doc.NetAmount, 0) AS NetAmount,
		|	ISNULL(Doc.TaxAmount, 0) AS TaxAmount,
		|	ISNULL(Doc.PriceType, VALUE(Catalog.PriceTypes.EmptyRef)) AS PriceType
		|FROM
		|	Document.SalesOrder.ItemList AS Doc
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.Key = Doc.Key
		|		AND tmpQueryTable.SalesOrder = Doc.Ref
		|
		|UNION ALL
		|
		|SELECT
		|	tmpQueryTable.ItemKey,
		|	tmpQueryTable.ItemKey.Item,
		|	tmpQueryTable.Store,
		|	tmpQueryTable.SalesOrder,
		|	tmpQueryTable.Key,
		|	tmpQueryTable.Unit,
		|	tmpQueryTable.Quantity,
		|	0,
		|	ISNULL(ItemList.Unit, VALUE(Catalog.Units.EmptyRef)),
		|	DATETIME(1, 1, 1),
		|	tmpQueryTable.ShipmentConfirmation,
		|	0,
		|	0,
		|	0,
		|	VALUE(Catalog.PriceTypes.EmptyRef)
		|FROM
		|	Document.ShipmentConfirmation.ItemList AS ItemList
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.Key = ItemList.Key
		|		AND tmpQueryTable.ShipmentConfirmation = ItemList.Ref
		|		AND tmpQueryTable.SalesOrder = VALUE(Document.SalesOrder.EmptyRef)";
	
	Query.SetParameter("QueryTable", QueryTableOrderBalance);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	DocumentsServer.RecalculateQuantityInTable(QueryTable);
	
	Settings = New Structure();
	Settings.Insert("Rows", New Array());
	Settings.Insert("CalculateSettings", New Structure());
	Settings.CalculateSettings.Insert("UpdatePrice");
	Settings.CalculateSettings.UpdatePrice = New Structure("Period, PriceType", Object.Date, Form.CurrentPriceType);
	
	Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	
	AgreementInfo = Catalogs.Agreements.GetAgreementInfo(Object.Agreement);
	
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
			RowByKey.PriceType = ?(ValueIsFilled(RowByKey.PriceType), RowByKey.PriceType, AgreementInfo.PriceType);
			Settings.Rows.Add(RowByKey);
		Else
			NewRow = Object.ItemList.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.PriceType = ?(ValueIsFilled(NewRow.PriceType), NewRow.PriceType, AgreementInfo.PriceType);
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