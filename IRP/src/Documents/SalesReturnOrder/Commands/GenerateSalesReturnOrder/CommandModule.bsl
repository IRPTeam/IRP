&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	GenerateDocument(CommandParameter);
EndProcedure

&AtClient
Procedure GenerateDocument(ArrayOfBasisDocuments)
	DocumentStructure = GetDocumentsStructure(ArrayOfBasisDocuments);
	
	If DocumentStructure.Count() = 0 Then
		For Each BasisDocument In ArrayOfBasisDocuments Do
			ErrorMessageKey = GetErrorMessageKey(BasisDocument);
			If ValueIsFilled(ErrorMessageKey) Then
				ShowMessageBox( , R()[ErrorMessageKey]);
				Return;
			EndIf;
		EndDo;
	EndIf;
	
	For Each FillingData In DocumentStructure Do
		OpenForm("Document.SalesReturnOrder.ObjectForm", New Structure("FillingValues", FillingData), , New UUID());
	EndDo;
EndProcedure

Function GetDocumentsStructure(ArrayOfBasisDocuments)
	
	ArrayOf_SalesInvoice = New Array();
	
	For Each Row In ArrayOfBasisDocuments Do
		If TypeOf(Row) = Type("DocumentRef.SalesInvoice") Then
			ArrayOf_SalesInvoice.Add(Row);
		Else
			Raise R().Error_043;
		EndIf;
	EndDo;
	
	ArrayOfTables = New Array();
	ArrayOfTables.Add(GetDocumentTable_SalesInvoice(ArrayOf_SalesInvoice));
	
	Return JoinDocumentsStructure(ArrayOfTables);
EndFunction

Function JoinDocumentsStructure(ArrayOfTables)
	
	ItemList = New ValueTable();
	ItemList.Columns.Add("BasedOn", New TypeDescription("String"));
	ItemList.Columns.Add("Company", New TypeDescription("CatalogRef.Companies"));
	ItemList.Columns.Add("Partner", New TypeDescription("CatalogRef.Partners"));
	ItemList.Columns.Add("LegalName", New TypeDescription("CatalogRef.Companies"));
	ItemList.Columns.Add("Agreement", New TypeDescription("CatalogRef.Agreements"));
	ItemList.Columns.Add("Currency", New TypeDescription("CatalogRef.Currencies"));
	ItemList.Columns.Add("Store", New TypeDescription("CatalogRef.Stores"));
	ItemList.Columns.Add("PriceIncludeTax", New TypeDescription("Boolean"));
	ItemList.Columns.Add("ManagerSegment", New TypeDescription("CatalogRef.PartnerSegments"));
	
	ItemList.Columns.Add("ItemKey", New TypeDescription("CatalogRef.ItemKeys"));
	ItemList.Columns.Add("Key", New TypeDescription("UUID"));
	ItemList.Columns.Add("Unit", New TypeDescription("CatalogRef.Units"));
	ItemList.Columns.Add("Quantity", New TypeDescription(Metadata.DefinedTypes.typeQuantity.Type));
	ItemList.Columns.Add("Price", New TypeDescription(Metadata.DefinedTypes.typePrice.Type));
	ItemList.Columns.Add("PriceType", New TypeDescription(Metadata.DefinedTypes.typePrice.Type));
	ItemList.Columns.Add("SalesInvoice", New TypeDescription("DocumentRef.SalesInvoice"));
	
	For Each Table In ArrayOfTables Do
		For Each Row In Table Do
			FillPropertyValues(ItemList.Add(), Row);
		EndDo;
	EndDo;
	
	ValueTableCopy = ItemList.Copy();
	ValueTableCopy.GroupBy("BasedOn, Company, Partner, LegalName, Agreement, Currency, PriceIncludeTax, ManagerSegment");
	
	ArrayOfResults = New Array();
	
	For Each Row In ValueTableCopy Do
		Result = New Structure();
		Result.Insert("BasedOn", Row.BasedOn);
		Result.Insert("Company", Row.Company);
		Result.Insert("Partner", Row.Partner);
		Result.Insert("LegalName", Row.LegalName);
		Result.Insert("Agreement", Row.Agreement);
		Result.Insert("Currency", Row.Currency);
		Result.Insert("ItemList", New Array());
		Result.Insert("PriceIncludeTax", Row.PriceIncludeTax);
		Result.Insert("ManagerSegment", Row.ManagerSegment);
		
		Filter = New Structure();
		Filter.Insert("BasedOn", Row.BasedOn);
		Filter.Insert("Company", Row.Company);
		Filter.Insert("Partner", Row.Partner);
		Filter.Insert("LegalName", Row.LegalName);
		Filter.Insert("Agreement", Row.Agreement);
		Filter.Insert("Currency", Row.Currency);
		Filter.Insert("PriceIncludeTax", Row.PriceIncludeTax);
		Filter.Insert("ManagerSegment", Row.ManagerSegment);
		
		ItemList = ItemList.Copy(Filter);
		For Each RowItemList In ItemList Do
			NewRow = New Structure();
			NewRow.Insert("ItemKey", RowItemList.ItemKey);
			NewRow.Insert("Key", RowItemList.Key);
			NewRow.Insert("Store", RowItemList.Store);
			NewRow.Insert("Unit", RowItemList.Unit);
			NewRow.Insert("Quantity", RowItemList.Quantity);
			NewRow.Insert("Price", RowItemList.Price);
			NewRow.Insert("PriceType", RowItemList.PriceType);
			NewRow.Insert("SalesInvoice", RowItemList.SalesInvoice);
			Result.ItemList.Add(NewRow);
		EndDo;
		ArrayOfResults.Add(Result);
	EndDo;
	Return ArrayOfResults;
EndFunction

Function GetDocumentTable_SalesInvoice(ArrayOfBasisDocuments)
	Return GetDocumentTable(ArrayOfBasisDocuments, "SalesInvoice");
EndFunction

Function GetDocumentTable(ArrayOfBasisDocuments, BasedOn)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	&BasedOn AS BasedOn,
		|	Table.SalesInvoice AS SalesInvoice,
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
		|	AccumulationRegister.SalesTurnovers.Turnovers(,,, SalesInvoice IN (&ArrayOfBasises)
		|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS Table
		|WHERE
		|	Table.QuantityTurnover > 0";
	Query.SetParameter("ArrayOfBasises", ArrayOfBasisDocuments);
	Query.SetParameter("BasedOn", BasedOn);
	
	QueryTable = Query.Execute().Unload();
	Return ExtractInfoFromOrderRows(QueryTable);
EndFunction

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
		|	QueryTable.SalesInvoice,
		|	QueryTable.ItemKey,
		|	QueryTable.Key,
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
		|	tmpQueryTable.SalesInvoice AS SalesInvoice,
		|	CAST(tmpQueryTable.SalesInvoice AS Document.SalesInvoice).Partner AS Partner,
		|	CAST(tmpQueryTable.SalesInvoice AS Document.SalesInvoice).LegalName AS LegalName,
		|	CAST(tmpQueryTable.SalesInvoice AS Document.SalesInvoice).PriceIncludeTax AS PriceIncludeTax,
		|	CAST(tmpQueryTable.SalesInvoice AS Document.SalesInvoice).Agreement AS Agreement,
		|	CAST(tmpQueryTable.SalesInvoice AS Document.SalesInvoice).Currency AS Currency,
		|	CAST(tmpQueryTable.SalesInvoice AS Document.SalesInvoice).ManagerSegment AS ManagerSegment,
		|	tmpQueryTable.Key AS Key,
		|	tmpQueryTable.Unit AS QuantityUnit,
		|	tmpQueryTable.Quantity AS Quantity,
		|	ISNULL(Doc.Price, 0) AS Price,
		|	ISNULL(Doc.Unit, VALUE(Catalog.Units.EmptyRef)) AS Unit,
		|	Doc.PriceType AS PriceType,
		|	Doc.Store AS Store
		|FROM
		|	Document.SalesInvoice.ItemList AS Doc
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.Key = Doc.Key
		|		AND tmpQueryTable.SalesInvoice = Doc.Ref";
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	DocumentsServer.RecalculateQuantityInTable(QueryTable);
	Return QueryTable;
EndFunction

#Region Errors

Function GetErrorMessageKey(BasisDocument)
	ErrorMessageKey = Undefined;
	
	If TypeOf(BasisDocument) = Type("DocumentRef.SalesInvoice") Then
		ErrorMessageKey = "Error_022";
	EndIf;
	
	Return ErrorMessageKey;
EndFunction

#EndRegion