&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	GenerateDocument(CommandParameter);
EndProcedure

&AtClient
Procedure GenerateDocument(ArrayOfBasisDocuments)
	DocumentStructure = GetDocumentsStructure(ArrayOfBasisDocuments);
	
	If DocumentStructure.Count() = 0 Then
		For Each BasisDocument In ArrayOfBasisDocuments Do
			ShowMessageBox( , GetErrorMessage(BasisDocument));
			Return;			
		EndDo;
	EndIf;
	
	For Each FillingData In DocumentStructure Do
		OpenForm("Document.GoodsReceipt.ObjectForm", New Structure("FillingValues", FillingData), , New UUID());
	EndDo;
EndProcedure

&AtServer
Function GetDocumentsStructure(ArrayOfBasisDocuments)
	ArrayOf_SalesReturn = New Array();
	For Each Row In ArrayOfBasisDocuments Do
		If TypeOf(Row) = Type("DocumentRef.SalesReturn") Then
			ArrayOf_SalesReturn.Add(Row);
		Else
			Raise R().Error_043;
		EndIf;
	EndDo;
	
	ArrayOfTables = New Array();
	ArrayOfTables.Add(GetDocumentTable_SalesReturn(ArrayOf_SalesReturn));
	
	Return JoinDocumentsStructure(ArrayOfTables, "BasedOn, Company, Partner, LegalName, Agreement, Store");
EndFunction

&AtServer
Function JoinDocumentsStructure(ArrayOfTables, UnjoinFields)
	
	CommonTable = GetEmptyCommonTable();
	
	For Each Table In ArrayOfTables Do
		For Each Row In Table Do
			FillPropertyValues(CommonTable.Add(), Row);
		EndDo;
	EndDo;
	
	ValueTableCopy = CommonTable.Copy();
	ValueTableCopy.GroupBy(UnjoinFields);
	
	ArrayOfResults = New Array();
	
	For Each Row In ValueTableCopy Do
		Result = New Structure(UnjoinFields);
		FillPropertyValues(Result, Row);
		Result.Insert("ItemList", New Array());
		
		Filter = New Structure(UnjoinFields);
		FillPropertyValues(Filter, Row);
		
		ItemList = CommonTable.Copy(Filter);
		For Each RowItemList In ItemList Do
			NewRow = New Structure();
			For Each ColumnItemList In ItemList.Columns Do
				NewRow.Insert(ColumnItemList.Name, RowItemList[ColumnItemList.Name]);
			EndDo;
			NewRow.Key = RowItemList.RowKey;
			
			Result.ItemList.Add(NewRow);
		EndDo;
		ArrayOfResults.Add(Result);
	EndDo;
	Return ArrayOfResults;
EndFunction

&AtServer
Function GetEmptyCommonTable()
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
	ValueTable.Columns.Add("Key", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	ValueTable.Columns.Add("SalesOrder", New TypeDescription("DocumentRef.SalesOrder"));
	
	Return ValueTable;
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
Function GetErrorMessage(BasisDocument)
	ErrorMessage = R().Error_019;
	Return StrTemplate(ErrorMessage, Metadata.Documents.GoodsReceipt.Synonym, BasisDocument.Metadata().Synonym);
EndFunction
