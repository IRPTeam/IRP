&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	GenerateDocument(CommandParameter);
EndProcedure

&AtClient
Procedure GenerateDocument(ArrayOfBasisDocuments)
	DocumentStructure = GetDocumentsStructure(ArrayOfBasisDocuments);
	
	If DocumentStructure.Count() = 0 Then
		For Each BasisDocument In ArrayOfBasisDocuments Do
			GetErrorMessage = GetErrorMessage(BasisDocument);
			If ValueIsFilled(GetErrorMessage) Then
				
				ShowMessageBox( , GetErrorMessage);
				Return;
			EndIf;
		EndDo;
	EndIf;
	
	
	For Each FillingData In DocumentStructure Do
		OpenForm("Document.GoodsReceipt.ObjectForm", New Structure("FillingValues", FillingData), , New UUID());
	EndDo;
EndProcedure

&AtServer
Function GetDocumentsStructure(ArrayOfBasisDocuments)
	ArrayOf_Bundling = New Array();
	ArrayOf_InventoryTransfer = New Array();
	ArrayOf_PurchaseInvoice = New Array();
	ArrayOf_PurchaseOrder = New Array();
	ArrayOf_SalesReturn = New Array();
	ArrayOf_Unbundling = New Array();
	
	For Each Row In ArrayOfBasisDocuments Do
		If TypeOf(Row) = Type("DocumentRef.Bundling") Then
			ArrayOf_Bundling.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.InventoryTransfer") Then
			ArrayOf_InventoryTransfer.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.PurchaseInvoice") Then
			ArrayOf_PurchaseInvoice.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.PurchaseOrder") Then
			ArrayOf_PurchaseOrder.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.SalesReturn") Then
			ArrayOf_SalesReturn.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.Unbundling") Then
			ArrayOf_Unbundling.Add(Row);
		Else
			Raise R().Error_043;
		EndIf;
	EndDo;
	
	ArrayOfTables = New Array();
	ArrayOfTables.Add(GetDocumentTable_Bundling(ArrayOf_Bundling));
	ArrayOfTables.Add(GetDocumentTable_InventoryTransfer(ArrayOf_InventoryTransfer));
	ArrayOfTables.Add(GetDocumentTable_PurchaseInvoice(ArrayOf_PurchaseInvoice));
	ArrayOfTables.Add(GetDocumentTable_PurchaseOrder(ArrayOf_PurchaseOrder));
	ArrayOfTables.Add(GetDocumentTable_SalesReturn(ArrayOf_SalesReturn));
	ArrayOfTables.Add(GetDocumentTable_Unbundling(ArrayOf_Unbundling));
	
	Return JoinDocumentsStructure(ArrayOfTables, "BasedOn, Company, Partner, LegalName, Agreement, Store");
EndFunction

&AtServer
Function JoinDocumentsStructure(ArrayOfTables, UnjoinFileds)
	
	ValueTable = New ValueTable();
	ValueTable.Columns.Add("BasedOn", New TypeDescription("String"));
	ValueTable.Columns.Add("Company", New TypeDescription("CatalogRef.Companies"));
	ValueTable.Columns.Add("Partner", New TypeDescription("CatalogRef.Partners"));
	ValueTable.Columns.Add("LegalName", New TypeDescription("CatalogRef.Companies"));
	ValueTable.Columns.Add("Agreement", New TypeDescription("CatalogRef.Agreements"));
	ValueTable.Columns.Add("Store", New TypeDescription("CatalogRef.Stores"));
	
	ValueTable.Columns.Add("ItemKey", New TypeDescription("CatalogRef.ItemKeys"));
	ValueTable.Columns.Add("Unit", New TypeDescription("CatalogRef.Units"));
	ValueTable.Columns.Add("Quantity", New TypeDescription(Metadata.DefinedTypes.typeQuantity.Type));
	ValueTable.Columns.Add("ReceiptBasis", New TypeDescription(Metadata.DefinedTypes.typeReceiptBasis.Type));
	ValueTable.Columns.Add("RowKey", New TypeDescription("String"));
	ValueTable.Columns.Add("Key", New TypeDescription("UUID"));
	ValueTable.Columns.Add("SalesOrder", New TypeDescription("DocumentRef.SalesOrder"));
	
	For Each Table In ArrayOfTables Do
		For Each Row In Table Do
			FillPropertyValues(ValueTable.Add(), Row);
		EndDo;
	EndDo;
	
	ValueTableCopy = ValueTable.Copy();
	ValueTableCopy.GroupBy(UnjoinFileds);
	
	ArrayOfResults = New Array();
	
	For Each Row In ValueTableCopy Do
		Result = New Structure(UnjoinFileds);
		FillPropertyValues(Result, Row);
		Result.Insert("ItemList", New Array());
		
		Filter = New Structure(UnjoinFileds);
		FillPropertyValues(Filter, Row);
		
		ItemList = ValueTable.Copy(Filter);
		For Each RowItemList In ItemList Do
			NewRow = New Structure();
			For Each ColumnItemList In ItemList.Columns Do
				NewRow.Insert(ColumnItemList.Name, RowItemList[ColumnItemList.Name]);
			EndDo;
			NewRow.Key = New UUID(RowItemList.RowKey);
			
			Result.ItemList.Add(NewRow);
		EndDo;
		ArrayOfResults.Add(Result);
	EndDo;
	Return ArrayOfResults;
EndFunction

&AtServer
Function PutQueryTableToTempTable(QueryTable)
	QueryTable.Columns.Add("Key", New TypeDescription("UUID"));
	For Each Row In QueryTable Do
		Row.Key = New UUID(Row.RowKey);
	EndDo;
	tempManager = New TempTablesManager();
	Query = New Query();
	Query.TempTablesManager = tempManager;
	Query.Text =
		"SELECT
		|	QueryTable.BasedOn,
		|	QueryTable.Store,
		|	QueryTable.ReceiptBasis,
		|	QueryTable.Partner,
		|	QueryTable.LegalName,
		|	QueryTable.Agreement,
		|	QueryTable.Company,
		|   QueryTable.ItemKey,
		|   QueryTable.Unit,
		|	QueryTable.Quantity,
		|   QueryTable.Key,
		|   QueryTable.RowKey
		|INTO tmpQueryTable
		|FROM
		|	&QueryTable AS QueryTable";
	
	Query.SetParameter("QueryTable", QueryTable);
	Query.Execute();
	Return tempManager;
EndFunction

&AtServer
Function ExtractInfoFrom_PurchaseOrder(QueryTable)
	Query = New Query();
	Query.TempTablesManager = PutQueryTableToTempTable(QueryTable);
	Query.Text =
		"SELECT ALLOWED
		|	tmpQueryTable.BasedOn,
		|	tmpQueryTable.Store,
		|	tmpQueryTable.ReceiptBasis,
		|	tmpQueryTable.Partner,
		|	tmpQueryTable.LegalName,
		|	tmpQueryTable.Agreement,
		|	tmpQueryTable.Company,
		|   tmpQueryTable.ItemKey,
		|   tmpQueryTable.Unit AS QuantityUnit,
		|	tmpQueryTable.Quantity,
		|   tmpQueryTable.Key,
		|	tmpQueryTable.RowKey,	
		|	Doc.Unit AS Unit,
		|	CASE
		|		WHEN Doc.PurchaseBasis REFS Document.SalesOrder
		|			THEN Doc.PurchaseBasis
		|		ELSE UNDEFINED
		|	END AS SalesOrder
		|FROM
		|	Document.PurchaseOrder.ItemList AS Doc
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.Key = Doc.Key
		|		AND tmpQueryTable.ReceiptBasis = Doc.Ref";
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	DocumentsServer.RecalculateQuantityInTable(QueryTable, "QuantityUnit");
	Return QueryTable;
EndFunction

&AtServer
Function ExtractInfoFrom_PurchaseInvoice(QueryTable)
	Query = New Query();
	Query.TempTablesManager = PutQueryTableToTempTable(QueryTable);
	Query.Text =
		"SELECT ALLOWED
		|	tmpQueryTable.BasedOn,
		|	tmpQueryTable.Store,
		|	tmpQueryTable.ReceiptBasis,
		|	tmpQueryTable.Partner,
		|	tmpQueryTable.LegalName,
		|	tmpQueryTable.Agreement,
		|	tmpQueryTable.Company,
		|	tmpQueryTable.ItemKey,
		|	tmpQueryTable.Unit AS QuantityUnit,
		|	tmpQueryTable.Quantity,
		|	tmpQueryTable.Key,
		|	tmpQueryTable.RowKey,
		|	Doc.Unit AS Unit,
		|	Doc.SalesOrder AS SalesOrder
		|FROM
		|	Document.PurchaseInvoice.ItemList AS Doc
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.Key = Doc.Key
		|		AND tmpQueryTable.ReceiptBasis = Doc.Ref";
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	DocumentsServer.RecalculateQuantityInTable(QueryTable, "QuantityUnit");
	Return QueryTable;
EndFunction

&AtServer
Function GetDocumentTable_Bundling(ArrayOfBasisDocuments)
	Return GetDocumentTable(ArrayOfBasisDocuments, "Bundling");
EndFunction

&AtServer
Function GetDocumentTable_InventoryTransfer(ArrayOfBasisDocuments)
	Return GetDocumentTable(ArrayOfBasisDocuments, "InventoryTransfer");
EndFunction

&AtServer
Function GetDocumentTable_PurchaseInvoice(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	""PurchaseInvoice"" AS BasedOn,
		|	GoodsInTransitIncomingBalance.Store AS Store,
		|	CAST(GoodsInTransitIncomingBalance.ReceiptBasis AS Document.PurchaseInvoice) AS ReceiptBasis,
		|	CAST(GoodsInTransitIncomingBalance.ReceiptBasis AS Document.PurchaseInvoice).Partner AS Partner,
		|	CAST(GoodsInTransitIncomingBalance.ReceiptBasis AS Document.PurchaseInvoice).LegalName AS LegalName,
		|	CAST(GoodsInTransitIncomingBalance.ReceiptBasis AS Document.PurchaseInvoice).Agreement AS Agreement,
		|	CAST(GoodsInTransitIncomingBalance.ReceiptBasis AS Document.PurchaseInvoice).Company AS Company,
		|	GoodsInTransitIncomingBalance.ItemKey,
		|	CASE
		|		WHEN GoodsInTransitIncomingBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN GoodsInTransitIncomingBalance.ItemKey.Unit
		|		ELSE GoodsInTransitIncomingBalance.ItemKey.Item.Unit
		|	END AS Unit,
		|	GoodsInTransitIncomingBalance.QuantityBalance AS Quantity,
		|	GoodsInTransitIncomingBalance.RowKey
		|FROM
		|	AccumulationRegister.GoodsInTransitIncoming.Balance(, ReceiptBasis IN (&ArrayOfBasises)) AS
		|		GoodsInTransitIncomingBalance";
	Query.SetParameter("ArrayOfBasises", ArrayOfBasisDocuments);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return ExtractInfoFrom_PurchaseInvoice(QueryTable);
EndFunction

&AtServer
Function GetDocumentTable_PurchaseOrder(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	""PurchaseOrder"" AS BasedOn,
		|	GoodsInTransitIncomingBalance.Store AS Store,
		|	CAST(GoodsInTransitIncomingBalance.ReceiptBasis AS Document.PurchaseOrder) AS ReceiptBasis,
		|	CAST(GoodsInTransitIncomingBalance.ReceiptBasis AS Document.PurchaseOrder).Partner AS Partner,
		|	CAST(GoodsInTransitIncomingBalance.ReceiptBasis AS Document.PurchaseOrder).LegalName AS LegalName,
		|	CAST(GoodsInTransitIncomingBalance.ReceiptBasis AS Document.PurchaseOrder).Agreement AS Agreement,
		|	CAST(GoodsInTransitIncomingBalance.ReceiptBasis AS Document.PurchaseOrder).Company AS Company,
		|	GoodsInTransitIncomingBalance.ItemKey,
		|	CASE
		|		WHEN GoodsInTransitIncomingBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN GoodsInTransitIncomingBalance.ItemKey.Unit
		|		ELSE GoodsInTransitIncomingBalance.ItemKey.Item.Unit
		|	END AS Unit,
		|	GoodsInTransitIncomingBalance.QuantityBalance AS Quantity,
		|	GoodsInTransitIncomingBalance.RowKey
		|FROM
		|	AccumulationRegister.GoodsInTransitIncoming.Balance(, ReceiptBasis IN (&ArrayOfBasises)) AS
		|		GoodsInTransitIncomingBalance";
	Query.SetParameter("ArrayOfBasises", ArrayOfBasisDocuments);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return ExtractInfoFrom_PurchaseOrder(QueryTable);
EndFunction

&AtServer
Function GetDocumentTable_SalesReturn(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	""SalesReturn"" AS BasedOn,
		|	GoodsInTransitIncomingBalance.Store AS Store,
		|	CAST(GoodsInTransitIncomingBalance.ReceiptBasis AS Document.SalesReturn) AS ReceiptBasis,
		|	CAST(GoodsInTransitIncomingBalance.ReceiptBasis AS Document.SalesReturn).Partner AS Partner,
		|	CAST(GoodsInTransitIncomingBalance.ReceiptBasis AS Document.SalesReturn).LegalName AS LegalName,
		|	CAST(GoodsInTransitIncomingBalance.ReceiptBasis AS Document.SalesReturn).Agreement AS Agreement,
		|	CAST(GoodsInTransitIncomingBalance.ReceiptBasis AS Document.SalesReturn).Company AS Company,
		|	GoodsInTransitIncomingBalance.ItemKey,
		|	CASE
		|		WHEN GoodsInTransitIncomingBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN GoodsInTransitIncomingBalance.ItemKey.Unit
		|		ELSE GoodsInTransitIncomingBalance.ItemKey.Item.Unit
		|	END AS Unit,
		|	GoodsInTransitIncomingBalance.QuantityBalance AS Quantity,
		|	GoodsInTransitIncomingBalance.RowKey
		|FROM
		|	AccumulationRegister.GoodsInTransitIncoming.Balance(, ReceiptBasis IN (&ArrayOfBasises)) AS
		|		GoodsInTransitIncomingBalance";
	Query.SetParameter("ArrayOfBasises", ArrayOfBasisDocuments);
	
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

&AtServer
Function GetDocumentTable_Unbundling(ArrayOfBasisDocuments)
	Return GetDocumentTable(ArrayOfBasisDocuments, "Unbundling");
EndFunction

&AtServer
Function GetDocumentTable(ArrayOfBasisDocuments, BasedOn)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	&BasedOn AS BasedOn,
		|	GoodsInTransitIncomingBalance.Store AS Store,
		|	GoodsInTransitIncomingBalance.ReceiptBasis AS ReceiptBasis,
		|	GoodsInTransitIncomingBalance.ItemKey,
		|	CASE
		|		WHEN GoodsInTransitIncomingBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN GoodsInTransitIncomingBalance.ItemKey.Unit
		|		ELSE GoodsInTransitIncomingBalance.ItemKey.Item.Unit
		|	END AS Unit,
		|	GoodsInTransitIncomingBalance.QuantityBalance AS Quantity,
		|	GoodsInTransitIncomingBalance.ReceiptBasis.Company AS Company,
		|	GoodsInTransitIncomingBalance.RowKey
		|FROM
		|	AccumulationRegister.GoodsInTransitIncoming.Balance(, ReceiptBasis IN (&ArrayOfBasises)) AS
		|		GoodsInTransitIncomingBalance";
	Query.SetParameter("ArrayOfBasises", ArrayOfBasisDocuments);
	Query.SetParameter("BasedOn", BasedOn);
	
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

&AtServer
Function GetErrorMessage(BasisDocument)
	
	ErrorMessage = Undefined;
	
	If TypeOf(BasisDocument) = Type("DocumentRef.PurchaseOrder") Then
		If Not BasisDocument.Status.Posting Or Not BasisDocument.Posted Then
			Return StrTemplate(R().Error_054, String(BasisDocument));		
		EndIf;
		
		If BasisDocument.GoodsReceiptBeforePurchaseInvoice Then
			If WithoutBalance(BasisDocument) And HasGoodReceipt(BasisDocument) Then
			ErrorMessage = R().Error_073;
			ErrorMessage = StrTemplate(ErrorMessage,  BasisDocument.Metadata().Synonym, Metadata.Documents.GoodsReceipt.Synonym);
			Else
				If PurchaseInvoiceExist(BasisDocument) Then
					ErrorMessage = R().Error_019;
					ErrorMessage = StrTemplate(ErrorMessage, Metadata.Documents.GoodsReceipt.Synonym, BasisDocument.Metadata().Synonym);
				Else
					
					
					ErrorMessage = R().Error_017;
				EndIf;
				
			EndIf;
		Else
			ErrorMessage = R().Error_028;
		EndIf;
		
	Else
		ErrorMessage = R().Error_019;
		ErrorMessage = StrTemplate(ErrorMessage, Metadata.Documents.GoodsReceipt.Synonym, BasisDocument.Metadata().Synonym);
	EndIf;
	
	Return ErrorMessage;
	
EndFunction

&AtServer
Function PurchaseInvoiceExist(BasisDocument)
	
	Return False;
	
EndFunction

&AtServer
Function HasGoodReceipt(BasisDocument)
	
	Query = New Query;
	Query.Text =
		"SELECT TOP 1
		|	GoodsInTransitIncoming.Recorder
		|FROM
		|	AccumulationRegister.GoodsInTransitIncoming AS GoodsInTransitIncoming
		|WHERE
		|	GoodsInTransitIncoming.ReceiptBasis = &BasisDocument";
	
	Query.SetParameter("BasisDocument", BasisDocument);
	
	Return Not Query.Execute().IsEmpty();
EndFunction

&AtServer
Function WithoutBalance(BasisDocument)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	GoodsInTransitOutgoingBalance.ReceiptBasis,
		|	GoodsInTransitOutgoingBalance.QuantityBalance
		|FROM
		|	AccumulationRegister.GoodsInTransitIncoming.Balance(, ReceiptBasis IN (&BasisDocument)) AS
		|		GoodsInTransitOutgoingBalance
		|WHERE
		|	GoodsInTransitOutgoingBalance.QuantityBalance > 0";
	Query.SetParameter("BasisDocument", BasisDocument);
	
	Return Query.Execute().IsEmpty() ;
	
EndFunction