
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	GenerateDocument(CommandParameter);
EndProcedure

&AtClient
Procedure GenerateDocument(ArrayOfBasisDocuments)
	DocumentStructure = GetDocumentsStructure(ArrayOfBasisDocuments);
	For Each FillingData In DocumentStructure Do
		OpenForm("Document.StockAdjustmentAsSurplus.ObjectForm", New Structure("FillingValues", FillingData), , New UUID());
	EndDo;
EndProcedure

Function GetDocumentsStructure(ArrayOfBasisDocuments)
	ArrayOf_PhysicalInventory = New Array();
	
	For Each Row In ArrayOfBasisDocuments Do
		If TypeOf(Row) = Type("DocumentRef.PhysicalInventory") Then
			ArrayOf_PhysicalInventory.Add(Row);
		Else
			Raise R().Error_043;
		EndIf;
	EndDo;
	
	ArrayOfTables = New Array();
	ArrayOfTables.Add(GetDocumentTable_PhysicalInventory(ArrayOf_PhysicalInventory));
	
	Return JoinDocumentsStructure(ArrayOfTables, "BasedOn, Store");
EndFunction

Function JoinDocumentsStructure(ArrayOfTables, UnjoinFileds)
	ValueTable = New ValueTable();
	ValueTable.Columns.Add("BasedOn", New TypeDescription("String"));
	ValueTable.Columns.Add("Store", New TypeDescription("CatalogRef.Stores"));
	ValueTable.Columns.Add("BasisDocument", New TypeDescription(Metadata.DefinedTypes.typeStockAdjustmentAsWriteOffBasises.Type));
	ValueTable.Columns.Add("ItemKey", New TypeDescription("CatalogRef.ItemKeys"));
	ValueTable.Columns.Add("Unit", New TypeDescription("CatalogRef.Units"));
	ValueTable.Columns.Add("Quantity", New TypeDescription(Metadata.DefinedTypes.typeQuantity.Type));
	
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
			
			Result.ItemList.Add(NewRow);
		EndDo;
		ArrayOfResults.Add(Result);
	EndDo;
	Return ArrayOfResults;
EndFunction

Function GetDocumentTable_PhysicalInventory(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	""PhysicalInventory"" AS BasedOn,
		|	StockAdjustmentAsSurplusBalance.Store AS Store,
		|	StockAdjustmentAsSurplusBalance.BasisDocument AS BasisDocument,
		|	StockAdjustmentAsSurplusBalance.ItemKey,
		|	CASE
		|		WHEN StockAdjustmentAsSurplusBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN StockAdjustmentAsSurplusBalance.ItemKey.Unit
		|		ELSE StockAdjustmentAsSurplusBalance.ItemKey.Item.Unit
		|	END AS Unit,
		|	StockAdjustmentAsSurplusBalance.QuantityBalance AS Quantity
		|FROM
		|	AccumulationRegister.StockAdjustmentAsSurplus.Balance(, BasisDocument IN (&ArrayOfBasises)) AS
		|		StockAdjustmentAsSurplusBalance";
	Query.SetParameter("ArrayOfBasises", ArrayOfBasisDocuments);
	
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

