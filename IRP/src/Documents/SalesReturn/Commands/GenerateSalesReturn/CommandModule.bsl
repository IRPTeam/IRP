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
		OpenForm("Document.SalesReturn.ObjectForm", New Structure("FillingValues", FillingData), , New UUID());
	EndDo;
EndProcedure

Function GetDocumentsStructure(ArrayOfBasisDocuments)
	
	ArrayOf_SalesInvoice = New Array();
	ArrayOf_SalesReturnOrder = New Array();
	
	For Each Row In ArrayOfBasisDocuments Do
		If TypeOf(Row) = Type("DocumentRef.SalesInvoice") Then
			ArrayOf_SalesInvoice.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.SalesReturnOrder") Then
			ArrayOf_SalesReturnOrder.Add(Row);
		Else
			Raise R().Error_043;
		EndIf;
	EndDo;
	
	ArrayOfTables = New Array();
	ArrayOfTables.Add(GetDocumentTable_SalesInvoice(ArrayOf_SalesInvoice));
	ArrayOfTables.Add(GetDocumentTable_SalesReturnOrder(ArrayOf_SalesReturnOrder));
	
	Return JoinDocumentsStructure(ArrayOfTables);
EndFunction

Function JoinDocumentsStructure(ArrayOfTables)
	
	ValueTable = New ValueTable();
	ValueTable.Columns.Add("BasedOn", New TypeDescription("String"));
	ValueTable.Columns.Add("Company", New TypeDescription("CatalogRef.Companies"));
	ValueTable.Columns.Add("Partner", New TypeDescription("CatalogRef.Partners"));
	ValueTable.Columns.Add("LegalName", New TypeDescription("CatalogRef.Companies"));
	ValueTable.Columns.Add("Agreement", New TypeDescription("CatalogRef.Agreements"));
	ValueTable.Columns.Add("Currency", New TypeDescription("CatalogRef.Currencies"));
	ValueTable.Columns.Add("Store", New TypeDescription("CatalogRef.Stores"));
	ValueTable.Columns.Add("PriceIncludeTax", New TypeDescription("Boolean"));
	
	ValueTable.Columns.Add("ItemKey", New TypeDescription("CatalogRef.ItemKeys"));
	ValueTable.Columns.Add("Key", New TypeDescription("UUID"));
	ValueTable.Columns.Add("Unit", New TypeDescription("CatalogRef.Units"));
	ValueTable.Columns.Add("Quantity", New TypeDescription(Metadata.DefinedTypes.typeQuantity.Type));
	ValueTable.Columns.Add("Price", New TypeDescription(Metadata.DefinedTypes.typePrice.Type));
	ValueTable.Columns.Add("PriceType", New TypeDescription(Metadata.DefinedTypes.typePrice.Type));
	ValueTable.Columns.Add("SalesInvoice", New TypeDescription("DocumentRef.SalesInvoice"));
	ValueTable.Columns.Add("SalesReturnOrder", New TypeDescription("DocumentRef.SalesReturnOrder"));
	
	For Each Table In ArrayOfTables Do
		For Each Row In Table Do
			FillPropertyValues(ValueTable.Add(), Row);
		EndDo;
	EndDo;
	
	ValueTableCopy = ValueTable.Copy();
	ValueTableCopy.GroupBy("BasedOn, Company, Partner, LegalName, Agreement, Currency, PriceIncludeTax");
	
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
		
		Filter = New Structure();
		Filter.Insert("BasedOn", Row.BasedOn);
		Filter.Insert("Company", Row.Company);
		Filter.Insert("Partner", Row.Partner);
		Filter.Insert("LegalName", Row.LegalName);
		Filter.Insert("Agreement", Row.Agreement);
		Filter.Insert("Currency", Row.Currency);
		Filter.Insert("PriceIncludeTax", Row.PriceIncludeTax);
		
		ItemList = ValueTable.Copy(Filter);
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
			NewRow.Insert("SalesReturnOrder", RowItemList.SalesReturnOrder);
			Result.ItemList.Add(NewRow);
		EndDo;
		ArrayOfResults.Add(Result);
	EndDo;
	Return ArrayOfResults;
EndFunction

Function GetDocumentTable_SalesInvoice(ArrayOfBasisDocuments)
	Return GetDocumentTable(ArrayOfBasisDocuments, "SalesInvoice");
EndFunction

Function GetDocumentTable_SalesReturnOrder(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	&BasedOn AS BasedOn,
		|	Table.Order,
		|	Table.ItemKey,
		|	Table.RowKey,
		|	CASE
		|		WHEN Table.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN Table.ItemKey.Unit
		|		ELSE Table.ItemKey.Item.Unit
		|	END AS Unit,
		|	Table.QuantityBalance AS Quantity,
		|	Table.Store AS Store
		|FROM
		|	AccumulationRegister.OrderBalance.Balance(, Order IN (&ArrayOfBasises)) AS Table
		|WHERE
		|	Table.QuantityBalance > 0
		|";
	Query.SetParameter("ArrayOfBasises", ArrayOfBasisDocuments);
	Query.SetParameter("BasedOn", "SalesReturnOrder");
	
	QueryTable = Query.Execute().Unload();
	Return ExtractInfoFromOrderRows_SalesReturnOrder(QueryTable);
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
		|	UNDEFINED AS SalesReturnOrder,
		|	CAST(tmpQueryTable.SalesInvoice AS Document.SalesInvoice).Partner AS Partner,
		|	CAST(tmpQueryTable.SalesInvoice AS Document.SalesInvoice).LegalName AS LegalName,
		|	CAST(tmpQueryTable.SalesInvoice AS Document.SalesInvoice).Agreement AS Agreement,
		|	CAST(tmpQueryTable.SalesInvoice AS Document.SalesInvoice).PriceIncludeTax AS PriceIncludeTax,
		|	CAST(tmpQueryTable.SalesInvoice AS Document.SalesInvoice).Currency AS Currency,
		|
		|	tmpQueryTable.Key AS Key,
		|	tmpQueryTable.Unit AS QuantityUnit,
		|	tmpQueryTable.Quantity AS Quantity,
		|	ISNULL(Doc.Price, 0) AS Price,
		|	ISNULL(Doc.Unit, VALUE(Catalog.Units.EmptyRef)) AS Unit,
		|	Doc.PriceType AS PriceType,
		|	Doc.Store AS Store
		|FROM
		|	tmpQueryTable AS tmpQueryTable
		|		INNER JOIN Document.SalesInvoice.ItemList AS Doc
		|		ON tmpQueryTable.Key = Doc.Key
		|		AND tmpQueryTable.SalesInvoice = Doc.Ref";
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	DocumentsServer.RecalculateQuantityInTable(QueryTable);
	Return QueryTable;
EndFunction

Function ExtractInfoFromOrderRows_SalesReturnOrder(QueryTable)
	QueryTable.Columns.Add("Key", New TypeDescription("UUID"));
	For Each Row In QueryTable Do
		Row.Key = New UUID(Row.RowKey);
	EndDo;
	
	Query = New Query();
	Query.Text =
		"SELECT
		|   QueryTable.BasedOn,
		|	QueryTable.Store,
		|	QueryTable.Order,
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
		|	tmpQueryTable.Store AS Store,
		|	Doc.SalesInvoice AS SalesInvoice,
		|	tmpQueryTable.Order AS SalesReturnOrder,
		|	CAST(tmpQueryTable.Order AS Document.SalesReturnOrder).Company AS Company,
		|	CAST(tmpQueryTable.Order AS Document.SalesReturnOrder).Partner AS Partner,
		|	CAST(tmpQueryTable.Order AS Document.SalesReturnOrder).LegalName AS LegalName,
		|	CAST(tmpQueryTable.Order AS Document.SalesReturnOrder).Agreement AS Agreement,
		|	CAST(tmpQueryTable.Order AS Document.SalesReturnOrder).PriceIncludeTax AS PriceIncludeTax,
		|	CAST(tmpQueryTable.Order AS Document.SalesReturnOrder).Currency AS Currency,
		|
		|	tmpQueryTable.Key AS Key,
		|	tmpQueryTable.Unit AS QuantityUnit,
		|	tmpQueryTable.Quantity AS Quantity,
		|	ISNULL(Doc.Price, 0) AS Price,
		|	ISNULL(Doc.Unit, VALUE(Catalog.Units.EmptyRef)) AS Unit,
		|	Doc.PriceType AS PriceType
		|FROM
		|	tmpQueryTable AS tmpQueryTable
		|		INNER JOIN Document.SalesReturnOrder.ItemList AS Doc
		|		ON tmpQueryTable.Key = Doc.Key
		|		AND tmpQueryTable.Order = Doc.Ref";
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	DocumentsServer.RecalculateQuantityInTable(QueryTable);
	Return QueryTable;
EndFunction

#Region Errors

Function GetErrorMessage(BasisDocument)
	ErrorMessage = Undefined;
	
	If TypeOf(BasisDocument) = Type("DocumentRef.SalesReturnOrder") Then
		If Not BasisDocument.Status.Posting Or Not BasisDocument.Posted Then
			Return StrTemplate(R()["Error_067"], String(BasisDocument));
		EndIf;
	EndIf;
	
	If TypeOf(BasisDocument) = Type("DocumentRef.SalesInvoice") Then
		ErrorMessage = R()["Error_022"];
	EndIf;
	
	Return ErrorMessage;
EndFunction

#EndRegion

