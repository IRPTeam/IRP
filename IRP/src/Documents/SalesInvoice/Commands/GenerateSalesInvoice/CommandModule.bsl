&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	InfoShipmentConfirmation = GetInfoShipmentConfirmationBeforeSalesInvoice(CommandParameter);
	
	If InfoShipmentConfirmation.Linear.Count() Then
		OpenArgs = New Structure("InfoShipmentConfirmations", InfoShipmentConfirmation.Tree);
		OpenForm("Document.SalesInvoice.Form.SelectShipmentConfirmationsForm"
			, OpenArgs, , , ,
			, New NotifyDescription("SelectShipmentConfirmationsFinish", ThisObject,
				New Structure("InfoShipmentConfirmation, CommandParameter",
					InfoShipmentConfirmation, CommandParameter)));
	Else
		ArrayOfInfoShipmentConfirmation = GetInfoShipmentConfirmation(CommandParameter);
		
		For Each Row In ArrayOfInfoShipmentConfirmation Do
			Index = CommandParameter.Find(Row.ShipmentConfirmation);
			If Index <> Undefined Then
				CommandParameter.Delete(Index);
			EndIf;
		EndDo;
		
		For Each Row In ArrayOfInfoShipmentConfirmation Do
			CommandParameter.Add(Row);
		EndDo;
		GenerateDocument(CommandParameter);
	EndIf;
EndProcedure

&AtClient
Procedure GenerateDocument(ArrayOfBasisDocuments)
	ArrayOfDocumentStructure = GetDocumentsStructure(ArrayOfBasisDocuments);
	
	If ArrayOfDocumentStructure.Count() = 0 Then
		For Each BasisDocument In ArrayOfBasisDocuments Do
			ErrorMessage = GetErrorMessage(BasisDocument);
			If ValueIsFilled(ErrorMessage) Then
				ShowMessageBox( , ErrorMessage);
				Return;
			EndIf;
		EndDo;	
	EndIf;
	
	For Each FillingData In ArrayOfDocumentStructure Do
		FormParameters = New Structure("FillingValues", FillingData);
			
		If FillingData.BasedOn = "SalesOrder" Then
			InfoMessage = GetInfoMessage(FillingData);
			If Not IsBlankString(InfoMessage) Then
				FormParameters.Insert("InfoMessage", InfoMessage);
			EndIf;
		EndIf;
			
		OpenForm("Document.SalesInvoice.ObjectForm", FormParameters, , New UUID());
	EndDo;
EndProcedure

&AtServer
Function GetDocumentsStructure(ArrayOfBasisDocuments)
	ArrayOf_SalesOrder = New Array();
	ArrayOf_ShipmentConfirmation = New Array();
	ArrayOf_Service = New Array();
	
	For Each Row In ArrayOfBasisDocuments Do
		If TypeOf(Row) = Type("DocumentRef.SalesOrder") Then
			ArrayOf_SalesOrder.Add(Row);
			ArrayOf_Service.Add(Row);
		EndIf;
		
		If TypeOf(Row) = Type("Structure") Then
			If Row.Property("ShipmentConfirmation") And
				(TypeOf(Row.ShipmentConfirmation) = Type("DocumentRef.ShipmentConfirmation")
					Or TypeOf(Row.ShipmentConfirmation) = Type("DocumentRef.SalesOrder")) Then
				ArrayOf_ShipmentConfirmation.Add(Row);
				If ValueIsFilled(Row.Order) Then
					ArrayOf_Service.Add(Row.Order);
				EndIf;
			EndIf;
		EndIf;
	EndDo;
	
	ArrayOfTables = New Array();
	ArrayOfTables.Add(GetDocumentTable_SalesOrder(ArrayOf_SalesOrder));
	ArrayOfTables.Add(GetDocumentTable_ShipmentConfirmation(ArrayOf_ShipmentConfirmation));
	ArrayOfTables.Add(GetDocumentTable_Service(ArrayOf_Service));
	
	Return JoinDocumentsStructure(ArrayOfTables);
EndFunction

&AtServer
Function JoinDocumentsStructure(ArrayOfTables)
	
	ItemList = New ValueTable();
	ItemList.Columns.Add("BasedOn"			, New TypeDescription("String"));
	ItemList.Columns.Add("Company"			, New TypeDescription("CatalogRef.Companies"));
	ItemList.Columns.Add("Partner"			, New TypeDescription("CatalogRef.Partners"));
	ItemList.Columns.Add("LegalName"		, New TypeDescription("CatalogRef.Companies"));
	ItemList.Columns.Add("Agreement"		, New TypeDescription("CatalogRef.Agreements"));
	ItemList.Columns.Add("Currency"			, New TypeDescription("CatalogRef.Currencies"));
	ItemList.Columns.Add("PriceIncludeTax"	, New TypeDescription("Boolean"));
	ItemList.Columns.Add("Store"			, New TypeDescription("CatalogRef.Stores"));
	ItemList.Columns.Add("ItemKey"			, New TypeDescription("CatalogRef.ItemKeys"));
	ItemList.Columns.Add("ManagerSegment"	, New TypeDescription("CatalogRef.PartnerSegments"));
	ItemList.Columns.Add("SalesOrder"
		, New TypeDescription(Metadata.AccumulationRegisters.OrderBalance.Dimensions.Order.Type));
	ItemList.Columns.Add("ShipmentConfirmation"
		, New TypeDescription(Metadata.AccumulationRegisters.ShipmentOrders.Dimensions.ShipmentConfirmation.Type));
	ItemList.Columns.Add("Unit"				, New TypeDescription("CatalogRef.Units"));
	ItemList.Columns.Add("Quantity"			, New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ItemList.Columns.Add("TaxAmount"		, New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ItemList.Columns.Add("TotalAmount"		, New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ItemList.Columns.Add("NetAmount"		, New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ItemList.Columns.Add("OffersAmount"		, New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ItemList.Columns.Add("PriceType"		, New TypeDescription("CatalogRef.PriceTypes"));
	ItemList.Columns.Add("Price"			, New TypeDescription(Metadata.DefinedTypes.typePrice.Type));
	ItemList.Columns.Add("Key"				, New TypeDescription("UUID"));
	ItemList.Columns.Add("DeliveryDate"	    , New TypeDescription("Date"));
	ItemList.Columns.Add("DontCalculateRow" , New TypeDescription("Boolean"));
	
	TaxListMetadataColumns = Metadata.Documents.SalesOrder.TabularSections.TaxList.Attributes;
	TaxList = New ValueTable();
	TaxList.Columns.Add("Key", TaxListMetadataColumns.Key.Type);
	TaxList.Columns.Add("Tax", TaxListMetadataColumns.Tax.Type);
	TaxList.Columns.Add("Analytics", TaxListMetadataColumns.Analytics.Type);
	TaxList.Columns.Add("TaxRate", TaxListMetadataColumns.TaxRate.Type);
	TaxList.Columns.Add("Amount", TaxListMetadataColumns.Amount.Type);
	TaxList.Columns.Add("IncludeToTotalAmount", TaxListMetadataColumns.IncludeToTotalAmount.Type);
	TaxList.Columns.Add("ManualAmount", TaxListMetadataColumns.ManualAmount.Type);
	TaxList.Columns.Add("Ref", New TypeDescription("DocumentRef.SalesOrder"));
	
	For Each TableStructure In ArrayOfTables Do
		For Each Row In TableStructure.ItemList Do
			FillPropertyValues(ItemList.Add(), Row);
		EndDo;
		For Each Row In TableStructure.TaxList Do
			FillPropertyValues(TaxList.Add(), Row);
		EndDo;
	EndDo;
	
	KeyFields = "BasedOn, Company, Partner, LegalName, Agreement, Currency, PriceIncludeTax, ManagerSegment";
	
	TransferredFields = New Structure(KeyFields);
		
	UniqueShipmentConfirmations = ItemList.Copy();
	UniqueShipmentConfirmations.GroupBy("ShipmentConfirmation");
	For Each RowUniqueShipmentConfirmations In UniqueShipmentConfirmations Do
		If Not ValueIsFilled(RowUniqueShipmentConfirmations.ShipmentConfirmation) Then
			Continue;
		EndIf;
		
		ItemListCopy = ItemList.Copy(New Structure("BasedOn, ShipmentConfirmation", 
			"SalesOrder", RowUniqueShipmentConfirmations.ShipmentConfirmation));
		If ItemListCopy.Count() Then
			FillPropertyValues(TransferredFields, ItemListCopy[0]);
		Else
			Continue;
		EndIf;
		
		For Each RowItemList In ItemList Do
			If RowItemList.BasedOn = "ShipmentConfirmation" 
			And RowItemList.ShipmentConfirmation = RowUniqueShipmentConfirmations.ShipmentConfirmation Then
				FillPropertyValues(RowItemList, TransferredFields);
			EndIf;
		EndDo;
	EndDo;
	
	ItemListCopy = ItemList.Copy();
	ItemListCopy.GroupBy(KeyFields);

	Filter = New Structure(KeyFields);
	ArrayOfResults = New Array();
	
	For Each Row In ItemListCopy Do
		Result = New Structure(KeyFields);
		FillPropertyValues(Result, Row);
			
		Result.Insert("ItemList"		, New Array());
		Result.Insert("TaxList"			, New Array());
		
		FillPropertyValues(Filter, Row);
		PriceType = Undefined;
		
		If Row.BasedOn = "ShipmentConfirmation" And Not ValueIsFilled(Result.Agreement) Then
			// Try get from user settings
			FilterParameters = New Structure();
			FilterParameters.Insert("MetadataObject", Metadata.Documents.SalesInvoice);
			UserSettings = UserSettingsServer.GetUserSettings(SessionParameters.CurrentUser, FilterParameters);
			SettingsRows = UserSettings.FindRows(New Structure("AttributeName", "Agreement"));
			If SettingsRows.Count() Then
				Result.Agreement = SettingsRows[0].Value;
			EndIf;
			
			// Check for actual (if get from user settings) or get if not get from user settings
			AgreementParameters = New Structure();
			AgreementParameters.Insert("Partner"		, Row.Partner);
			AgreementParameters.Insert("Agreement"		, Result.Agreement);
			AgreementParameters.Insert("CurrentDate"	, CurrentDate());
			AgreementParameters.Insert("ArrayOfFilters"	, New Array());
			AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
			AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", 
														PredefinedValue("Enum.AgreementTypes.Customer"), ComparisonType.Equal));
			AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", 
														PredefinedValue("Enum.AgreementKinds.Standard"), ComparisonType.NotEqual));	
			Result.Agreement = DocumentsServer.GetAgreementByPartner(AgreementParameters);
			
			If ValueIsFilled(Result.Agreement) Then
				PriceType = Catalogs.Agreements.GetAgreementInfo(Result.Agreement).PriceType;
			EndIf;
		EndIf;
		
		ArrayOfTaxListFilters = New Array();
		
		For Each RowItemList In ItemList.Copy(Filter) Do
			NewRow = New Structure();
			NewRow.Insert("ItemKey"				, RowItemList.ItemKey);
			NewRow.Insert("Store"				, RowItemList.Store);
			NewRow.Insert("SalesOrder"			, RowItemList.SalesOrder);
			NewRow.Insert("ShipmentConfirmation", RowItemList.ShipmentConfirmation);
			NewRow.Insert("Unit"				, RowItemList.Unit);
			NewRow.Insert("Quantity"			, RowItemList.Quantity);
			NewRow.Insert("Price"				, RowItemList.Price);
			NewRow.Insert("TaxAmount"			, RowItemList.TaxAmount);
			NewRow.Insert("TotalAmount"			, RowItemList.TotalAmount);
			NewRow.Insert("NetAmount"			, RowItemList.NetAmount);
			NewRow.Insert("OffersAmount"		, RowItemList.OffersAmount);
			NewRow.Insert("Key"					, RowItemList.Key);
			NewRow.Insert("DeliveryDate"		, RowItemList.DeliveryDate);
			
			If ValueIsFilled(PriceType) Then
				NewRow.Insert("PriceType"		, PriceType);
			Else
				NewRow.Insert("PriceType"		, RowItemList.PriceType);
			EndIf;
			
			ArrayOfTaxListFilters.Add(New Structure("Ref, Key", RowItemList.SalesOrder, RowItemList.Key));
			
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
		
		ArrayOfResults.Add(Result);
	EndDo;
	Return ArrayOfResults;
EndFunction

&AtServer
Function ExtractInfoFromOrderRows(QueryTable)
	QueryTable.Columns.Add("Key", New TypeDescription("UUID"));
	For Each Row In QueryTable Do
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
		|	ISNULL(ItemList.Price, 0) AS Price,
		|	ISNULL(ItemList.TaxAmount, 0) AS TaxAmount,
		|	ISNULL(ItemList.TotalAmount, 0) AS TotalAmount,
		|	ISNULL(ItemList.NetAmount, 0) AS NetAmount,
		|	ISNULL(ItemList.OffersAmount, 0) AS OffersAmount,
		|	ISNULL(ItemList.Unit, VALUE(Catalog.Units.EmptyRef)) AS Unit,
		|	ISNULL(ItemList.PriceType, VALUE(Catalog.PriceTypes.EmptyRef)) AS PriceType,
		|	ISNULL(ItemList.DeliveryDate, DATETIME(1, 1, 1)) AS DeliveryDate,
		|	tmpQueryTable.ShipmentConfirmation AS ShipmentConfirmation,
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
		|	tmpQueryTable.ShipmentConfirmation,
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
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResults = Query.ExecuteBatch();
	
	QueryTable_ItemList = QueryResults[1].Unload();
	DocumentsServer.RecalculateQuantityInTable(QueryTable_ItemList);
	
	QueryTable_TaxList = QueryResults[2].Unload();
	
	Return New Structure("ItemList, TaxList", QueryTable_ItemList, QueryTable_TaxList);
EndFunction

&AtServer
Function GetDocumentTable_Service(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	""SalesOrder"" AS BasedOn,
		|	OrderBalanceBalance.Store AS Store,
		|	OrderBalanceBalance.Order AS SalesOrder,
		|	VALUE(Document.ShipmentConfirmation.EmptyRef) AS ShipmentConfirmation,
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
	Return ExtractInfoFromOrderRows(QueryTable);
EndFunction

&AtServer
Function GetDocumentTable_SalesOrder(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	""SalesOrder"" AS BasedOn,
		|	OrderBalanceBalance.Store AS Store,
		|	OrderBalanceBalance.Order AS SalesOrder,
		|	VALUE(Document.ShipmentConfirmation.EmptyRef) AS ShipmentConfirmation,
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
		|		AND ItemKey.Item.ItemType.Type <> VALUE(enum.ItemTypes.Service)
		|		AND
		|		NOT Order.ShipmentConfirmationsBeforeSalesInvoice) AS OrderBalanceBalance";
	Query.SetParameter("ArrayOfOrders", ArrayOfBasisDocuments);
	
	QueryTable = Query.Execute().Unload();
	Return ExtractInfoFromOrderRows(QueryTable);
EndFunction

&AtServer
Function GetDocumentTable_ShipmentConfirmation(ArrayOfBasisDocuments)
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
		|			tmp AS tmp)) AS GoodsInTransitOutgoingBalance
		|		INNER JOIN tmp AS tmp
		|		ON tmp.ShipmentConfirmation = GoodsInTransitOutgoingBalance.ShipmentBasis
		|		AND tmp.ItemKey = GoodsInTransitOutgoingBalance.ItemKey
		|		AND tmp.RowKey = GoodsInTransitOutgoingBalance.RowKey
		|		AND GoodsInTransitOutgoingBalance.QuantityBalance < 0";
	Query.SetParameter("ValueTable", ValueTable);
	
	QueryTable = Query.Execute().Unload();
	Return ExtractInfoFromOrderRows(QueryTable);
EndFunction

&AtClient
Procedure SelectShipmentConfirmationsFinish(Result, AdditionalParameters) Export
	
	ArrayOfBasisDocuments = New Array();
	For Each Row In AdditionalParameters.CommandParameter Do
		If AdditionalParameters.InfoShipmentConfirmation.Orders.Find(Row) = Undefined Then
			ArrayOfBasisDocuments.Add(Row);
		EndIf;
	EndDo;
	
	If Result <> Undefined Then
		For Each Row In AdditionalParameters.InfoShipmentConfirmation.Linear Do
			If Result.Find(Row.ShipmentConfirmation) <> Undefined Then
				ArrayOfBasisDocuments.Add(Row);
			EndIf;
		EndDo;
	EndIf;
	
	GenerateDocument(ArrayOfBasisDocuments);
	
EndProcedure

&AtServer
Function GetInfoShipmentConfirmationBeforeSalesInvoice(ArrayOfSaleOrders)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	ShipmentOrdersBalance.Order AS Order,
		|	ShipmentOrdersBalance.ShipmentConfirmation AS ShipmentConfirmation,
		|	ShipmentOrdersBalance.ItemKey.Item AS Item,
		|	ShipmentOrdersBalance.ItemKey,
		|	CASE
		|		WHEN ShipmentOrdersBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN ShipmentOrdersBalance.ItemKey.Unit
		|		ELSE ShipmentOrdersBalance.ItemKey.Item.Unit
		|	END AS Unit,
		|	ShipmentOrdersBalance.QuantityBalance AS Quantity,
		|	ShipmentOrdersBalance.RowKey
		|FROM
		|	AccumulationRegister.ShipmentOrders.Balance(, Order IN (&ArrayOfSaleOrders)) AS ShipmentOrdersBalance
		|TOTALS
		|BY
		|	Order,
		|	ShipmentConfirmation";
	Query.SetParameter("ArrayOfSaleOrders", ArrayOfSaleOrders);
	QueryResult = Query.Execute();
	
	Return DocSalesInvoiceServer.GetInfoShipmentConfirmationBeforeSalesInvoiceFromQueryResult(QueryResult);
	
EndFunction

&AtServer
Function GetInfoShipmentConfirmation(ArrayOfShipmentConfirmation)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	ShipmentOrdersBalance.Order AS Order,
		|	ShipmentOrdersBalance.ShipmentConfirmation AS ShipmentConfirmation,
		|	ShipmentOrdersBalance.ItemKey AS ItemKey,
		|	SUM(ShipmentOrdersBalance.QuantityBalance) AS Quantity,
		|	ShipmentOrdersBalance.RowKey AS RowKey
		|FROM
		|	AccumulationRegister.ShipmentOrders.Balance(, ShipmentConfirmation IN (&ArrayOfShipmentConfirmation)) AS
		|		ShipmentOrdersBalance
		|GROUP BY
		|	ShipmentOrdersBalance.Order,
		|	ShipmentOrdersBalance.ShipmentConfirmation,
		|	ShipmentOrdersBalance.ItemKey,
		|	ShipmentOrdersBalance.RowKey
		|HAVING
		|	SUM(ShipmentOrdersBalance.QuantityBalance) > 0
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(Document.SalesOrder.EmptyRef),
		|	GoodsInTransitOutgoingBalance.ShipmentBasis,
		|	GoodsInTransitOutgoingBalance.ItemKey,
		|	-SUM(GoodsInTransitOutgoingBalance.QuantityBalance),
		|	GoodsInTransitOutgoingBalance.RowKey
		|FROM
		|	AccumulationRegister.GoodsInTransitOutgoing.Balance(, ShipmentBasis IN (&ArrayOfShipmentConfirmation)) AS
		|		GoodsInTransitOutgoingBalance
		|GROUP BY
		|	GoodsInTransitOutgoingBalance.ShipmentBasis,
		|	GoodsInTransitOutgoingBalance.ItemKey,
		|	GoodsInTransitOutgoingBalance.RowKey,
		|	VALUE(Document.SalesOrder.EmptyRef)
		|HAVING 
		|	-SUM(GoodsInTransitOutgoingBalance.QuantityBalance) > 0";
		
	Query.SetParameter("ArrayOfShipmentConfirmation", ArrayOfShipmentConfirmation);
	Selection = Query.Execute().Select();
	
	InfoShipmentConfirmation = New Array;
	While Selection.Next() Do
		RowStructure = New Structure("Order,ShipmentConfirmation,ItemKey,RowKey,Quantity");
		FillPropertyValues(RowStructure, Selection);
		InfoShipmentConfirmation.Add(RowStructure);
	EndDo;
	Return InfoShipmentConfirmation;
	
EndFunction

#Region Errors

&AtServer
Function GetErrorMessage(BasisDocument)
	ErrorMessage = Undefined;
	
	If TypeOf(BasisDocument) = Type("DocumentRef.SalesOrder") Then
		If Not BasisDocument.Status.Posting Or Not BasisDocument.Posted Then
			Return StrTemplate(R().Error_054, String(BasisDocument));		
		EndIf;
		
		If BasisDocument.ShipmentConfirmationsBeforeSalesInvoice Then
			If ShipmentConfirmationExist(BasisDocument) Then
				ErrorMessage = R().Error_019;
				ErrorMessage = StrTemplate(ErrorMessage, Metadata.Documents.SalesInvoice.Synonym, BasisDocument.Metadata().Synonym);
			Else
				ErrorMessage = R().Error_018;
			EndIf;
		Else
			If SalesInvoiceExist(BasisDocument) Then
				ErrorMessage = R().Error_019;
				ErrorMessage = StrTemplate(ErrorMessage, Metadata.Documents.SalesInvoice.Synonym, BasisDocument.Metadata().Synonym);
			EndIf;
		EndIf;
	EndIf;
	If TypeOf(BasisDocument) = Type("DocumentRef.ShipmentConfirmation") Then
		ErrorMessage = R().Error_019;
		ErrorMessage = StrTemplate(ErrorMessage, Metadata.Documents.SalesInvoice.Synonym, BasisDocument.Metadata().Synonym);
	EndIf;
	
	Return ErrorMessage;
	
EndFunction

&AtServer
Function GetInfoMessage(FillingData)
	InfoMessage = "";
	BasisDocument = New Array();
	For Each Row In FillingData.ItemList Do
		BasisDocument.Add(Row.SalesOrder);
	EndDo;
	If SalesInvoiceExist(BasisDocument) Then
		InfoMessage = StrTemplate(R().InfoMessage_001, 
						Metadata.Documents.SalesInvoice.Synonym, 
						Metadata.Documents.SalesOrder.Synonym);
	EndIf;
	Return InfoMessage;	
EndFunction

&AtServer
Function ShipmentConfirmationExist(BasisDocument)
	Query = New Query(
	"SELECT ALLOWED
	|	GoodsInTransitOutgoingBalance.ShipmentBasis,
	|	GoodsInTransitOutgoingBalance.QuantityBalance
	|FROM
	|	AccumulationRegister.GoodsInTransitOutgoing.Balance(, ShipmentBasis IN (&BasisDocument)) AS
	|		GoodsInTransitOutgoingBalance
	|WHERE
	|	GoodsInTransitOutgoingBalance.QuantityBalance > 0");
	Query.SetParameter("BasisDocument", BasisDocument);	
	Return Query.Execute().IsEmpty();
EndFunction

&AtServer
Function SalesInvoiceExist(BasisDocument)
	Query = New Query(
	"SELECT TOP 1
	|	OrderBalanceTurnovers.Recorder,
	|	OrderBalanceTurnovers.QuantityExpense AS QuantityExpense
	|FROM
	|	AccumulationRegister.OrderBalance.Turnovers(, , Recorder, Order IN (&BasisDocument)) AS OrderBalanceTurnovers
	|WHERE
	|	VALUETYPE(OrderBalanceTurnovers.Recorder) = TYPE(Document.SalesInvoice)");
	Query.SetParameter("BasisDocument", BasisDocument);
	Return Not Query.Execute().IsEmpty();
EndFunction

#EndRegion

