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
		OpenForm("Document.PurchaseReturnOrder.ObjectForm", FormParameters, , New UUID());
	EndDo;
EndProcedure

&AtServer
Function GetDocumentsStructure(ArrayOfBasisDocuments)
	
	ArrayOf_PurchaseInvoice = New Array();
	
	For Each Row In ArrayOfBasisDocuments Do
		If TypeOf(Row) = Type("DocumentRef.PurchaseInvoice") Then
			ArrayOf_PurchaseInvoice.Add(Row);
		Else
			Raise R().Error_043;
		EndIf;
	EndDo;
	
	ArrayOfTables = New Array();
	ArrayOfTables.Add(GetDocumentTable_PurchaseInvoice(ArrayOf_PurchaseInvoice));
	
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
	ItemList.Columns.Add("Unit"				, New TypeDescription("CatalogRef.Units"));
	ItemList.Columns.Add("Quantity"			, New TypeDescription(Metadata.DefinedTypes.typeQuantity.Type));
	ItemList.Columns.Add("TaxAmount"		, New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ItemList.Columns.Add("TotalAmount"		, New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ItemList.Columns.Add("NetAmount"		, New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ItemList.Columns.Add("OffersAmount"		, New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ItemList.Columns.Add("PriceType"		, New TypeDescription(Metadata.DefinedTypes.typePrice.Type));
	ItemList.Columns.Add("Price"			, New TypeDescription(Metadata.DefinedTypes.typePrice.Type));
	ItemList.Columns.Add("BusinessUnit"		, New TypeDescription("CatalogRef.BusinessUnits"));
	ItemList.Columns.Add("Key"				, New TypeDescription("UUID"));
	ItemList.Columns.Add("RowKey"			, New TypeDescription("String"));	
	ItemList.Columns.Add("PurchaseInvoice"	, New TypeDescription("DocumentRef.PurchaseInvoice"));
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
	TaxList.Columns.Add("Ref"					, New TypeDescription("DocumentRef.PurchaseInvoice"));
	
	SpecialOffersMetadataColumns = Metadata.Documents.PurchaseInvoice.TabularSections.SpecialOffers.Attributes;
	SpecialOffers = New ValueTable();
	SpecialOffers.Columns.Add("Key"		, SpecialOffersMetadataColumns.Key.Type);
	SpecialOffers.Columns.Add("Offer"	, SpecialOffersMetadataColumns.Offer.Type);
	SpecialOffers.Columns.Add("Amount"	, SpecialOffersMetadataColumns.Amount.Type);
	SpecialOffers.Columns.Add("Percent"	, SpecialOffersMetadataColumns.Percent.Type);
	SpecialOffers.Columns.Add("Ref"		, New TypeDescription("DocumentRef.PurchaseInvoice"));
	
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
	ItemListCopy.GroupBy(UnjoinFields);
	
	ArrayOfResults = New Array();
	
	For Each Row In ItemListCopy Do
		Result = New Structure(UnjoinFields);
		FillPropertyValues(Result, Row);
		
		Result.Insert("ItemList"		, New Array());
		Result.Insert("TaxList"			, New Array());
		Result.Insert("SpecialOffers"	, New Array());
		
		Filter = New Structure(UnjoinFields);
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
			
			ArrayOfTaxListFilters.Add(New Structure("Ref, Key", RowItemList.PurchaseInvoice, NewRow.Key));
			ArrayOfSpecialOffersFilters.Add(New Structure("Ref, Key", RowItemList.PurchaseInvoice, NewRow.Key));
			
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
Function GetDocumentTable_PurchaseInvoice(ArrayOfBasisDocuments)
	Return GetDocumentTable(ArrayOfBasisDocuments, "PurchaseInvoice");
EndFunction

&AtServer
Function GetDocumentTable(ArrayOfBasisDocuments, BasedOn)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	&BasedOn AS BasedOn,
		|	Table.PurchaseInvoice AS PurchaseInvoice,
		|	Table.ItemKey,
		|	Table.RowKey,
		|	CASE
		|		WHEN Table.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN Table.ItemKey.Unit
		|		ELSE Table.ItemKey.Item.Unit
		|	END AS Unit,
		|	Table.QuantityTurnover AS Quantity,
		|	Table.Company AS Company
		|FROM
		|	AccumulationRegister.PurchaseTurnovers.Turnovers(,,, PurchaseInvoice IN (&ArrayOfBasises)
		|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS Table
		|WHERE
		|	Table.QuantityTurnover > 0";
	Query.SetParameter("ArrayOfBasises", ArrayOfBasisDocuments);
	Query.SetParameter("BasedOn", BasedOn);
	
	QueryTable = Query.Execute().Unload();
	Return ExtractInfoFromOrderRows(QueryTable);
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
		|   QueryTable.BasedOn,
		|	QueryTable.Company,
		|	QueryTable.PurchaseInvoice,
		|	QueryTable.ItemKey,
		|	QueryTable.Key,
		|	QueryTable.RowKey,
		|	QueryTable.Unit,
		|	QueryTable.Quantity
		|INTO tmpQueryTable
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT ALLOWED
		|   tmpQueryTable.BasedOn AS BasedOn,
		|	tmpQueryTable.ItemKey AS ItemKey,
		|	tmpQueryTable.Company AS Company,
		|	tmpQueryTable.PurchaseInvoice AS PurchaseInvoice,
		|	CAST(tmpQueryTable.PurchaseInvoice AS Document.PurchaseInvoice).Partner AS Partner,
		|	CAST(tmpQueryTable.PurchaseInvoice AS Document.PurchaseInvoice).LegalName AS LegalName,
		|	CAST(tmpQueryTable.PurchaseInvoice AS Document.PurchaseInvoice).PriceIncludeTax AS PriceIncludeTax,
		|	CAST(tmpQueryTable.PurchaseInvoice AS Document.PurchaseInvoice).Agreement AS Agreement,
		|	CAST(tmpQueryTable.PurchaseInvoice AS Document.PurchaseInvoice).Currency AS Currency,
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
		|	ItemList.BusinessUnit,
		|	ISNULL(ItemList.DontCalculateRow, FALSE) AS DontCalculateRow
		|FROM
		|	Document.PurchaseInvoice.ItemList AS ItemList
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.Key = ItemList.Key
		|		AND tmpQueryTable.PurchaseInvoice = ItemList.Ref
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
		|	Document.PurchaseInvoice.TaxList AS TaxList
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.PurchaseInvoice = TaxList.Ref
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
		|	Document.PurchaseInvoice.SpecialOffers AS SpecialOffers
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.PurchaseInvoice = SpecialOffers.Ref
		|		AND tmpQueryTable.Key = SpecialOffers.Key";
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResults = Query.ExecuteBatch();
	
	QueryTable_ItemList = QueryResults[1].Unload();
	DocumentsServer.RecalculateQuantityInTable(QueryTable_ItemList);
	
	QueryTable_TaxList = QueryResults[2].Unload();
	QueryTable_SpecialOffers = QueryResults[3].Unload();
	
	Return New Structure("ItemList, TaxList, SpecialOffers", QueryTable_ItemList, QueryTable_TaxList, QueryTable_SpecialOffers);	
EndFunction

#Region Errors
&AtServer
Function GetErrorMessage(BasisDocument)
	ErrorMessage = Undefined;
	
	If TypeOf(BasisDocument) = Type("DocumentRef.PurchaseInvoice") Then
		ErrorMessage = StrTemplate(R().Error_021, Metadata.Documents.PurchaseInvoice.Synonym);
	EndIf;
	
	Return ErrorMessage;
EndFunction

&AtServer
Function GetInfoMessage(FillingData)
	InfoMessage = "";
	If FillingData.BasedOn = "PurchaseInvoice" Then
		BasisDocument = New Array();
		For Each Row In FillingData.ItemList Do
			BasisDocument.Add(Row.PurchaseInvoice);
		EndDo;
		If PurchaseReturnOrderExist(BasisDocument) Then
			InfoMessage = StrTemplate(R().InfoMessage_001, 
										Metadata.Documents.PurchaseReturnOrder.Synonym,
										Metadata.Documents.PurchaseInvoice.Synonym);
		EndIf;
	EndIf;
	Return InfoMessage;	
EndFunction

&AtServer
Function PurchaseReturnOrderExist(BasisDocument)
	Query = New Query(
	"SELECT TOP 1
	|	OrderBalanceTurnovers.Recorder
	|FROM
	|	AccumulationRegister.OrderBalance.Turnovers(, , Recorder, Order IN (&BasisDocument)) AS OrderBalanceTurnovers
	|WHERE
	|	VALUETYPE(OrderBalanceTurnovers.Recorder) = TYPE(Document.PurchaseReturnOrder)");
	Query.SetParameter("BasisDocument", BasisDocument);
	Return Not Query.Execute().IsEmpty();
EndFunction

#EndRegion