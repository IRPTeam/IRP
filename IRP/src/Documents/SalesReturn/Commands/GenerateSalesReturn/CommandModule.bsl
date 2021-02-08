&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	GenerateDocument(CommandParameter);
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
		OpenForm("Document.SalesReturn.ObjectForm", FormParameters, , New UUID());
	EndDo;
EndProcedure

&AtServer
Function GetDocumentsStructure(ArrayOfBasisDocuments)
	
	ArrayOf_SalesInvoice = New Array();
	ArrayOf_SalesReturnOrder = New Array();
	ArrayOf_GoodsReceipt = New Array();
	
	For Each Row In ArrayOfBasisDocuments Do
		If TypeOf(Row) = Type("DocumentRef.SalesInvoice") Then
			ArrayOf_SalesInvoice.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.SalesReturnOrder") Then
			ArrayOf_SalesReturnOrder.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.GoodsReceipt") Then
			ArrayOf_GoodsReceipt.Add(Row);
		Else
			Raise R().Error_043;
		EndIf;
	EndDo;
	
	ArrayOfTables = New Array();
	ArrayOfTables.Add(GetDocumentTable_SalesInvoice(ArrayOf_SalesInvoice));
	ArrayOfTables.Add(GetDocumentTable_SalesReturnOrder(ArrayOf_SalesReturnOrder));
	ArrayOfTables.Add(GetDocumentTable_GoodsReceipt(ArrayOf_GoodsReceipt));
	
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
	ItemList.Columns.Add("SalesReturnOrder"
		, New TypeDescription("DocumentRef.SalesReturnOrder"));
	ItemList.Columns.Add("SalesInvoice"	, New TypeDescription("DocumentRef.SalesInvoice"));
	ItemList.Columns.Add("Unit"				, New TypeDescription("CatalogRef.Units"));
	ItemList.Columns.Add("Quantity"			, New TypeDescription(Metadata.DefinedTypes.typeQuantity.Type));
	ItemList.Columns.Add("TaxAmount"		, New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ItemList.Columns.Add("TotalAmount"		, New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ItemList.Columns.Add("NetAmount"		, New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ItemList.Columns.Add("OffersAmount"		, New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ItemList.Columns.Add("PriceType"		, New TypeDescription("CatalogRef.PriceTypes"));
	ItemList.Columns.Add("Price"			, New TypeDescription(Metadata.DefinedTypes.typePrice.Type));
	ItemList.Columns.Add("Key"				, New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	ItemList.Columns.Add("RowKey"			, New TypeDescription("String"));
	ItemList.Columns.Add("DontCalculateRow" , New TypeDescription("Boolean"));
	
	TaxListMetadataColumns = Metadata.Documents.SalesReturn.TabularSections.TaxList.Attributes;
	TaxList = New ValueTable();
	TaxList.Columns.Add("Key"					, TaxListMetadataColumns.Key.Type);
	TaxList.Columns.Add("Tax"					, TaxListMetadataColumns.Tax.Type);
	TaxList.Columns.Add("Analytics"				, TaxListMetadataColumns.Analytics.Type);
	TaxList.Columns.Add("TaxRate"				, TaxListMetadataColumns.TaxRate.Type);
	TaxList.Columns.Add("Amount"				, TaxListMetadataColumns.Amount.Type);
	TaxList.Columns.Add("IncludeToTotalAmount"	, TaxListMetadataColumns.IncludeToTotalAmount.Type);
	TaxList.Columns.Add("ManualAmount"			, TaxListMetadataColumns.ManualAmount.Type);
	TaxList.Columns.Add("Ref"					, New TypeDescription("DocumentRef.SalesReturnOrder"));
	
	SpecialOffersMetadataColumns = Metadata.Documents.SalesReturn.TabularSections.SpecialOffers.Attributes;
	SpecialOffers = New ValueTable();
	SpecialOffers.Columns.Add("Key"		, SpecialOffersMetadataColumns.Key.Type);
	SpecialOffers.Columns.Add("Offer"	, SpecialOffersMetadataColumns.Offer.Type);
	SpecialOffers.Columns.Add("Amount"	, SpecialOffersMetadataColumns.Amount.Type);
	SpecialOffers.Columns.Add("Ref"		, New TypeDescription("DocumentRef.SalesReturnOrder"));
	
	SerialLotNumbersMetadataColumns = Metadata.Documents.SalesReturn.TabularSections.SerialLotNumbers.Attributes;
	SerialLotNumbers = New ValueTable();
	SerialLotNumbers.Columns.Add("Key"		       , SerialLotNumbersMetadataColumns.Key.Type);
	SerialLotNumbers.Columns.Add("SerialLotNumber" , SerialLotNumbersMetadataColumns.SerialLotNumber.Type);
	SerialLotNumbers.Columns.Add("Quantity"	       , SerialLotNumbersMetadataColumns.Quantity.Type);
	SerialLotNumbers.Columns.Add("Ref"		       , New TypeDescription("DocumentRef.SalesReturnOrder"));
	
	GoodsReceiptsMetadataColumns = Metadata.Documents.SalesReturn.TabularSections.GoodsReceipts.Attributes;
	GoodsReceipts = New ValueTable();
	GoodsReceipts.Columns.Add("Key"		               , GoodsReceiptsMetadataColumns.Key.Type);
	GoodsReceipts.Columns.Add("GoodsReceipt"           , GoodsReceiptsMetadataColumns.GoodsReceipt.Type);
	GoodsReceipts.Columns.Add("Quantity"	           , GoodsReceiptsMetadataColumns.Quantity.Type);
	GoodsReceipts.Columns.Add("QuantityInGoodsReceipt" , GoodsReceiptsMetadataColumns.QuantityInGoodsReceipt.Type);
	GoodsReceipts.Columns.Add("Ref"		               , New TypeDescription("DocumentRef.SalesReturnOrder"));
	
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
		For Each Row In TableStructure.SerialLotNumbers Do
			FillPropertyValues(SerialLotNumbers.Add(), Row);
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
		
		Result.Insert("ItemList"		 , New Array());
		Result.Insert("TaxList"			 , New Array());
		Result.Insert("SpecialOffers"	 , New Array());
		Result.Insert("SerialLotNumbers" , New Array());
		Result.Insert("GoodsReceipts"    , New Array());
		
		Filter = New Structure(UnjoinFields);
		FillPropertyValues(Filter, Row);
		
		ArrayOfTaxListFilters = New Array();
		ArrayOfSpecialOffersFilters = New Array();
		ArrayOfSerialLotNumbersFilters = New Array();
		ArrayOfGoodsReceiptsFilters = New Array();
		
		ItemListFiltered = ItemList.Copy(Filter);
		For Each RowItemList In ItemListFiltered Do
			NewRow = New Structure();
			
			For Each ColumnItemList In ItemListFiltered.Columns Do
				NewRow.Insert(ColumnItemList.Name, RowItemList[ColumnItemList.Name]);
			EndDo;
			
			NewRow.Key = RowItemList.RowKey;
			
			ArrayOfTaxListFilters.Add(New Structure("Ref, Key", RowItemList.SalesReturnOrder, NewRow.Key));
			ArrayOfSpecialOffersFilters.Add(New Structure("Ref, Key", RowItemList.SalesReturnOrder, NewRow.Key));
			ArrayOfSerialLotNumbersFilters.Add(New Structure("Ref, Key", RowItemList.SalesReturnOrder, NewRow.Key));
			ArrayOfGoodsReceiptsFilters.Add(New Structure("Ref, Key", RowItemList.SalesReturnOrder, NewRow.Key));
			
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
				NewRow.Insert("Key"    , RowSpecialOffers.Key);
				NewRow.Insert("Offer"  , RowSpecialOffers.Offer);
				NewRow.Insert("Amount" , RowSpecialOffers.Amount);
				Result.SpecialOffers.Add(NewRow);
			EndDo;
		EndDo;
		
		For Each SerialLotNumbersFilter In ArrayOfSerialLotNumbersFilters Do
			For Each RowSerialLotNumbers In SerialLotNumbers.Copy(SerialLotNumbersFilter) Do
				NewRow = New Structure();
				NewRow.Insert("Key"             , RowSerialLotNumbers.Key);
				NewRow.Insert("SerialLotNumber" , RowSerialLotNumbers.SerialLotNumber);
				NewRow.Insert("Quantity"        , RowSerialLotNumbers.Quantity);
				Result.SerialLotNumbers.Add(NewRow);
			EndDo;
		EndDo;
		
		For Each GoodsReceiptsFilter In ArrayOfGoodsReceiptsFilters Do
			For Each RowGoodsReceipts In GoodsReceipts.Copy(GoodsReceiptsFilter) Do
				NewRow = New Structure();
				NewRow.Insert("Key"                    , RowGoodsReceipts.Key);			
				NewRow.Insert("GoodsReceipt"           , RowGoodsReceipts.GoodsReceipt);
				NewRow.Insert("Quantity"               , RowGoodsReceipts.Quantity);
				NewRow.Insert("QuantityInGoodsReceipt" , RowGoodsReceipts.QuantityInGoodsReceipt);
				Result.GoodsReceipts.Add(NewRow);
			EndDo;
		EndDo;
		
		ArrayOfResults.Add(Result);
	EndDo;
	Return ArrayOfResults;
EndFunction

&AtServer
Function GetDocumentTable_GoodsReceipt(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	""GoodsReceipt"" AS BasedOn,
		|	ReceiptInvoicing.Store AS Store,
		|	VALUE(Document.SalesReturnOrder.EmptyRef) AS SalesReturnOrder,
		|	ReceiptInvoicing.ItemKey AS ItemKey,
		|	CASE
		|		WHEN ReceiptInvoicing.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN ReceiptInvoicing.ItemKey.Unit
		|		ELSE ReceiptInvoicing.ItemKey.Item.Unit
		|	END AS Unit,
		|	CAST(ReceiptInvoicing.Basis AS Document.GoodsReceipt) AS GoodsReceipt,
		|	CAST(ReceiptInvoicing.Basis AS Document.GoodsReceipt).Company AS Company,
		|	CAST(ReceiptInvoicing.Basis AS Document.GoodsReceipt).Partner AS Partner,
		|	CAST(ReceiptInvoicing.Basis AS Document.GoodsReceipt).LegalName AS LegalName,
		|	ReceiptInvoicing.QuantityBalance AS Quantity
		|FROM
		|	AccumulationRegister.R1031B_ReceiptInvoicing.Balance(, Basis IN (&ArrayOfGoodsReceipt)
		|	AND CAST(Basis AS
		|		Document.GoodsReceipt).TransactionType = VALUE(Enum.GoodsReceiptTransactionTypes.ReturnFromCustomer)) AS
		|		ReceiptInvoicing";
	Query.SetParameter("ArrayOfGoodsReceipt", ArrayOfBasisDocuments);
	
	QueryTable = Query.Execute().Unload();
	Return ExtractInfoFromRows_GoodsReceipt(QueryTable);
EndFunction

&AtServer
Function GetDocumentTable_SalesReturnOrder(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	""SalesReturnOrder"" AS BasedOn,
		|	OrderBalanceBalance.Store AS Store,
		|	OrderBalanceBalance.Order AS SalesReturnOrder,
		|	OrderBalanceBalance.ItemKey,
		|	OrderBalanceBalance.RowKey,
		|	CASE
		|		WHEN OrderBalanceBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN OrderBalanceBalance.ItemKey.Unit
		|		ELSE OrderBalanceBalance.ItemKey.Item.Unit
		|	END AS Unit,
		|	OrderBalanceBalance.QuantityBalance AS Quantity
		|FROM
		|	AccumulationRegister.OrderBalance.Balance(, Order IN (&ArrayOfOrders)) AS OrderBalanceBalance";
	Query.SetParameter("ArrayOfOrders", ArrayOfBasisDocuments);
	
	QueryTable = Query.Execute().Unload();
	Return ExtractInfoFromRows_SalesReturnOrder(QueryTable);
EndFunction

&AtServer
Function GetDocumentTable_SalesInvoice(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	""SalesInvoice"" AS BasedOn,
		|	Table.SalesInvoice AS SalesInvoice,
		|	Table.ItemKey,
		|	Table.RowKey,
		|	CASE
		|		WHEN Table.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN Table.ItemKey.Unit
		|		ELSE Table.ItemKey.Item.Unit
		|	END AS Unit,
		|	Table.QuantityTurnover AS Quantity,
		|	Table.Company AS Company,
		|	Table.SerialLotNumber
		|FROM
		|	AccumulationRegister.SalesTurnovers.Turnovers(,,, SalesInvoice IN (&ArrayOfBasises)
		|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS Table
		|WHERE
		|	Table.QuantityTurnover > 0";
	Query.SetParameter("ArrayOfBasises", ArrayOfBasisDocuments);
	
	QueryTable = Query.Execute().Unload();
	Return ExtractInfoFromRows_SalesInvoice(QueryTable);
EndFunction

&AtServer
Function ExtractInfoFromRows_GoodsReceipt(QueryTable)
	GoodsReceiptsTable = CreateTable_GoodsReceipts();
	ItemList = QueryTable.Copy();
	ItemList.GroupBy("BasedOn, Store, SalesReturnOrder, ItemKey, Unit, Company, Partner, LegalName", "Quantity");
	ItemList.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	ItemList.Columns.Add("RowKey", Metadata.DefinedTypes.typeRowID.Type);
	For Each RowItemList In ItemList Do
		RowKey = String(New UUID());
		RowItemList.Key = RowKey;
		RowItemList.RowKey = RowKey;
		Filter = New Structure("BasedOn, Store, SalesReturnOrder, ItemKey, Unit, Company, Partner, LegalName");
		FillPropertyValues(Filter, RowItemList);
		For Each RowGoodsReceipts In QueryTable.Copy(Filter) Do
			NewRowGoodsReceipts = GoodsReceiptsTable.Add();
			NewRowGoodsReceipts.Key = RowItemList.Key;
			NewRowGoodsReceipts.GoodsReceipt = RowGoodsReceipts.GoodsReceipt;
			NewRowGoodsReceipts.Quantity = RowGoodsReceipts.Quantity;
			NewRowGoodsReceipts.QuantityInGoodsReceipt = RowGoodsReceipts.Quantity;
		EndDo;	
	EndDo;
	Return New Structure("ItemList, TaxList, SpecialOffers, SerialLotNumbers, GoodsReceipts", 
	ItemList, 
	New ValueTable(), 
	New ValueTable(),
	New ValueTable(),
	GoodsReceiptsTable);
EndFunction

&AtServer
Function ExtractInfoFromRows_SalesInvoice(QueryTable)
	QueryTable.Columns.Add("Key", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	For Each Row In QueryTable Do
		Row.Key = Row.RowKey;
	EndDo;
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable.BasedOn,
		|	QueryTable.SalesInvoice,
		|	QueryTable.ItemKey,
		|	QueryTable.Key,
		|	QueryTable.RowKey,
		|	QueryTable.Unit,
		|	QueryTable.Quantity,
		|	QueryTable.SerialLotNumber
		|INTO tmpQueryTableFull
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmpQueryTableFull.BasedOn,
		|	tmpQueryTableFull.SalesInvoice,
		|	tmpQueryTableFull.ItemKey,
		|	tmpQueryTableFull.Key,
		|	tmpQueryTableFull.RowKey,
		|	tmpQueryTableFull.Unit,
		|	SUM(tmpQueryTableFull.Quantity) AS Quantity
		|INTO tmpQueryTable
		|FROM
		|	tmpQueryTableFull AS tmpQueryTableFull
		|GROUP BY
		|	tmpQueryTableFull.BasedOn,
		|	tmpQueryTableFull.SalesInvoice,
		|	tmpQueryTableFull.ItemKey,
		|	tmpQueryTableFull.Key,
		|	tmpQueryTableFull.RowKey,
		|	tmpQueryTableFull.Unit
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT ALLOWED
		|	tmpQueryTable.BasedOn AS BasedOn,
		|	tmpQueryTable.ItemKey AS ItemKey,
		|	tmpQueryTable.SalesInvoice AS SalesInvoice,
		|	UNDEFINED AS SalesReturnOrder,
		|	CAST(tmpQueryTable.SalesInvoice AS Document.SalesInvoice).Partner AS Partner,
		|	CAST(tmpQueryTable.SalesInvoice AS Document.SalesInvoice).LegalName AS LegalName,
		|	CAST(tmpQueryTable.SalesInvoice AS Document.SalesInvoice).Agreement AS Agreement,
		|	CAST(tmpQueryTable.SalesInvoice AS Document.SalesInvoice).PriceIncludeTax AS PriceIncludeTax,
		|	CAST(tmpQueryTable.SalesInvoice AS Document.SalesInvoice).Currency AS Currency,
		|	CAST(tmpQueryTable.SalesInvoice AS Document.SalesInvoice).Company AS Company,
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
		|	ISNULL(ItemList.PriceType, VALUE(Catalog.PriceTypes.EmptyRef)) AS PriceType,
		|	ISNULL(ItemList.Store, VALUE(Catalog.Stores.EmptyRef)) AS Store,
		|	ISNULL(ItemList.DontCalculateRow, FALSE) AS DontCalculateRow
		|FROM
		|	tmpQueryTable AS tmpQueryTable
		|		INNER JOIN Document.SalesInvoice.ItemList AS ItemList
		|		ON tmpQueryTable.Key = ItemList.Key
		|		AND tmpQueryTable.SalesInvoice = ItemList.Ref
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
		|	Document.SalesInvoice.TaxList AS TaxList
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.SalesInvoice = TaxList.Ref
		|		AND tmpQueryTable.Key = TaxList.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SpecialOffers.Ref,
		|	SpecialOffers.Key,
		|	SpecialOffers.Offer,
		|	SpecialOffers.Amount
		|FROM
		|	Document.SalesInvoice.SpecialOffers AS SpecialOffers
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.SalesInvoice = SpecialOffers.Ref
		|		AND tmpQueryTable.Key = SpecialOffers.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SerialLotNumbers.Ref,
		|	SerialLotNumbers.Key,
		|	SerialLotNumbers.SerialLotNumber,
		|	tmpQueryTableFull.Quantity
		|FROM
		|	Document.SalesInvoice.SerialLotNumbers AS SerialLotNumbers
		|		INNER JOIN tmpQueryTableFull AS tmpQueryTableFull
		|		ON tmpQueryTableFull.SalesInvoice = SerialLotNumbers.Ref
		|		AND tmpQueryTableFull.Key = SerialLotNumbers.Key
		|		AND tmpQueryTableFull.SerialLotNumber = SerialLotNumbers.SerialLotNumber
		|WHERE
		|	tmpQueryTableFull.Quantity > 0";
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResults = Query.ExecuteBatch();
	
	QueryTable_ItemList = QueryResults[2].Unload();
	DocumentsServer.RecalculateQuantityInTable(QueryTable_ItemList);
	
	QueryTable_TaxList = QueryResults[3].Unload();
	QueryTable_SpecialOffers = QueryResults[4].Unload();
	QueryTable_SerialLotNumbers = QueryResults[5].Unload();
	
	Return New Structure("ItemList, TaxList, SpecialOffers, SerialLotNumbers, GoodsReceipts", 
	QueryTable_ItemList, 
	QueryTable_TaxList, 
	QueryTable_SpecialOffers,
	QueryTable_SerialLotNumbers,
	New ValueTable());
EndFunction

&AtServer
Function ExtractInfoFromRows_SalesReturnOrder(QueryTable)
	QueryTable.Columns.Add("Key", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	For Each Row In QueryTable Do
		Row.Key = Row.RowKey;
	EndDo;
	
	Query = New Query();
	Query.Text =
		"SELECT
		|   QueryTable.BasedOn,
		|	QueryTable.Store,
		|	QueryTable.SalesReturnOrder,
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
		|	tmpQueryTable.SalesReturnOrder AS SalesReturnOrder,
		|	CAST(tmpQueryTable.SalesReturnOrder AS Document.SalesReturnOrder).Partner AS Partner,
		|	CAST(tmpQueryTable.SalesReturnOrder AS Document.SalesReturnOrder).LegalName AS LegalName,
		|	CAST(tmpQueryTable.SalesReturnOrder AS Document.SalesReturnOrder).Agreement AS Agreement,
		|	CAST(tmpQueryTable.SalesReturnOrder AS Document.SalesReturnOrder).PriceIncludeTax AS PriceIncludeTax,
		|	CAST(tmpQueryTable.SalesReturnOrder AS Document.SalesReturnOrder).Currency AS Currency,
		|	CAST(tmpQueryTable.SalesReturnOrder AS Document.SalesReturnOrder).Company AS Company,
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
		|	ISNULL(ItemList.PriceType, VALUE(Catalog.PriceTypes.EmptyRef)) AS PriceType,
		|	ISNULL(ItemList.SalesInvoice, VALUE(Document.SalesInvoice.EmptyRef)) AS SalesInvoice,
		|	ISNULL(ItemList.DontCalculateRow, FALSE) AS DontCalculateRow
		|FROM
		|	Document.SalesReturnOrder.ItemList AS ItemList
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.Key = ItemList.Key
		|		AND tmpQueryTable.SalesReturnOrder = ItemList.Ref
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
		|	Document.SalesReturnOrder.TaxList AS TaxList
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.SalesReturnOrder = TaxList.Ref
		|		AND tmpQueryTable.Key = TaxList.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SpecialOffers.Ref,
		|	SpecialOffers.Key,
		|	SpecialOffers.Offer,
		|	SpecialOffers.Amount
		|FROM
		|	Document.SalesReturnOrder.SpecialOffers AS SpecialOffers
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.SalesReturnOrder = SpecialOffers.Ref
		|		AND tmpQueryTable.Key = SpecialOffers.Key";
		
	Query.SetParameter("QueryTable", QueryTable);
	QueryResults = Query.ExecuteBatch();
	
	QueryTable_ItemList = QueryResults[1].Unload();
	DocumentsServer.RecalculateQuantityInTable(QueryTable_ItemList);
	
	QueryTable_TaxList = QueryResults[2].Unload();
	QueryTable_SpecialOffers = QueryResults[3].Unload();
	
	Return New Structure("ItemList, TaxList, SpecialOffers, SerialLotNumbers, GoodsReceipts", 
	QueryTable_ItemList, 
	QueryTable_TaxList, 
	QueryTable_SpecialOffers,
	New ValueTable(),
	New ValueTable());
EndFunction

Function CreateTable_GoodsReceipts()
	ColumnsMetadata = Metadata.Documents.SalesReturn.TabularSections.GoodsReceipts.Attributes;
	GoodsReceiptsTable = New ValueTable();
	GoodsReceiptsTable.Columns.Add("Key", ColumnsMetadata.Key.Type);
	GoodsReceiptsTable.Columns.Add("GoodsReceipt", ColumnsMetadata.GoodsReceipt.Type);
	GoodsReceiptsTable.Columns.Add("Quantity", ColumnsMetadata.Quantity.Type);
	GoodsReceiptsTable.Columns.Add("QuantityInGoodsReceipt", ColumnsMetadata.Quantity.Type);
	GoodsReceiptsTable.Columns.Add("Ref" , New TypeDescription("DocumentRef.SalesReturnOrder"));
	Return GoodsReceiptsTable;
EndFunction

#Region Errors

&AtServer
Function GetInfoMessage(FillingData)
	InfoMessage = "";
	If FillingData.BasedOn = "SalesReturnOrder" Then
		BasisDocument = New Array();
		For Each Row In FillingData.ItemList Do
			BasisDocument.Add(Row.SalesReturnOrder);
		EndDo;
		If SalesReturnExist(BasisDocument) Then
			InfoMessage = StrTemplate(R().InfoMessage_001, 
										Metadata.Documents.SalesReturn.Synonym,
										Metadata.Documents.SalesReturnOrder.Synonym);
		EndIf;
	EndIf;
	Return InfoMessage;	
EndFunction

&AtServer
Function SalesReturnExist(BasisDocument)
	Query = New Query(
	"SELECT TOP 1
	|	SalesTurnoversTurnovers.Recorder,
	|	SalesTurnoversTurnovers.QuantityTurnover AS QuantityTurnover
	|FROM
	|	AccumulationRegister.SalesTurnovers.Turnovers(, , Recorder, SalesInvoice IN (&BasisDocument)) AS SalesTurnoversTurnovers
	|WHERE
	|	VALUETYPE(SalesTurnoversTurnovers.Recorder) = TYPE(Document.SalesReturn)");
	Query.SetParameter("BasisDocument", BasisDocument);
	Return Not Query.Execute().IsEmpty();
EndFunction

&AtServer
Function GetErrorMessage(BasisDocument)
	ErrorMessage = Undefined;
	
	If TypeOf(BasisDocument) = Type("DocumentRef.SalesReturnOrder") Then
		If Not BasisDocument.Status.Posting Or Not BasisDocument.Posted Then
			Return StrTemplate(R().Error_054, String(BasisDocument));		
		EndIf;
	EndIf;
	
	If TypeOf(BasisDocument) = Type("DocumentRef.SalesInvoice") Then
		ErrorMessage = StrTemplate(R().Error_021, Metadata.Documents.SalesInvoice.Synonym);
	EndIf;
	
	Return ErrorMessage;
EndFunction

#EndRegion

