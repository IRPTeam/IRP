&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	GenerateDocument(CommandParameter);
EndProcedure

&AtClient
Procedure GenerateDocument(ArrayOfBasisDocuments)
	DocumentStructure = GetDocumentsStructure(ArrayOfBasisDocuments);
	
	For Each FillingData In DocumentStructure Do
		OpenForm("Document.InventoryTransfer.ObjectForm", New Structure("FillingValues", FillingData), , New UUID());
	EndDo;
EndProcedure

&AtServer
Function GetDocumentsStructure(ArrayOfBasisDocuments)
	ArrayOf_InventoryTransferOrder = New Array();
	
	For Each Row In ArrayOfBasisDocuments Do
		If TypeOf(Row) = Type("DocumentRef.InventoryTransferOrder") Then
			ArrayOf_InventoryTransferOrder.Add(Row);
		EndIf;
	EndDo;
	
	ArrayOfTables = New Array();
	ArrayOfTables.Add(GetDocumentTable_InventoryTransferOrder(ArrayOf_InventoryTransferOrder));
	
	Return JoinDocumentsStructure(ArrayOfTables);
EndFunction

&AtServer
Function JoinDocumentsStructure(ArrayOfTables)
	
	ValueTable = New ValueTable();
	ValueTable.Columns.Add("BasedOn", New TypeDescription("String"));
	ValueTable.Columns.Add("Company", New TypeDescription("CatalogRef.Companies"));
	ValueTable.Columns.Add("StoreSender", New TypeDescription("CatalogRef.Stores"));
	ValueTable.Columns.Add("StoreReceiver", New TypeDescription("CatalogRef.Stores"));
	
	ValueTable.Columns.Add("ItemKey", New TypeDescription("CatalogRef.ItemKeys"));
	ValueTable.Columns.Add("InventoryTransferOrder"
		, New TypeDescription(Metadata.AccumulationRegisters.TransferOrderBalance.Dimensions.Order.Type));
	ValueTable.Columns.Add("Unit", New TypeDescription("CatalogRef.Units"));
	ValueTable.Columns.Add("Quantity", New TypeDescription(Metadata.DefinedTypes.typeQuantity.Type));
	ValueTable.Columns.Add("Key", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	
	For Each Table In ArrayOfTables Do
		For Each Row In Table Do
			FillPropertyValues(ValueTable.Add(), Row);
		EndDo;
	EndDo;
	
	ValueTableCopy = ValueTable.Copy();
	ValueTableCopy.GroupBy("BasedOn, Company, StoreSender, StoreReceiver");
	
	ArrayOfResults = New Array();
	
	For Each Row In ValueTableCopy Do
		Result = New Structure();
		Result.Insert("BasedOn", Row.BasedOn);
		Result.Insert("Company", Row.Company);
		Result.Insert("StoreSender", Row.StoreSender);
		Result.Insert("StoreReceiver", Row.StoreReceiver);
		
		Result.Insert("ItemList", New Array());
		
		Filter = New Structure();
		Filter.Insert("BasedOn", Row.BasedOn);
		Filter.Insert("Company", Row.Company);
		Filter.Insert("StoreSender", Row.StoreSender);
		Filter.Insert("StoreReceiver", Row.StoreReceiver);
		
		ItemList = ValueTable.Copy(Filter);
		For Each RowItemList In ItemList Do
			NewRow = New Structure();
			NewRow.Insert("InventoryTransferOrder", RowItemList.InventoryTransferOrder);
			NewRow.Insert("ItemKey", RowItemList.ItemKey);
			NewRow.Insert("Unit", RowItemList.Unit);
			NewRow.Insert("Quantity", RowItemList.Quantity);
			NewRow.Insert("Key", RowItemList.Key);
			
			Result.ItemList.Add(NewRow);
		EndDo;
		ArrayOfResults.Add(Result);
	EndDo;
	Return ArrayOfResults;
EndFunction

&AtServer
Function ExtractInfoFromOrderRows(QueryTable)
	QueryTable.Columns.Add("Key", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	For Each Row In QueryTable Do
		Row.Key = Row.RowKey;
	EndDo;
	
	Query = New Query();
	Query.Text =
		"SELECT
		|   QueryTable.BasedOn,
		|	QueryTable.StoreSender,
		|	QueryTable.StoreReceiver,
		|	QueryTable.InventoryTransferOrder,
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
		|	tmpQueryTable.StoreSender AS StoreSender,
		|	tmpQueryTable.StoreReceiver AS StoreReceiver,
		|	tmpQueryTable.InventoryTransferOrder AS InventoryTransferOrder,
		|	CAST(tmpQueryTable.InventoryTransferOrder AS Document.InventoryTransferOrder).Company AS Company,
		|	tmpQueryTable.Key,
		|	tmpQueryTable.Unit AS QuantityUnit,
		|	tmpQueryTable.Quantity AS Quantity,
		|	ISNULL(Doc.Unit, VALUE(Catalog.Units.EmptyRef)) AS Unit
		|FROM
		|	Document.InventoryTransferOrder.ItemList AS Doc
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.Key = Doc.Key
		|		AND tmpQueryTable.InventoryTransferOrder = Doc.Ref";
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	DocumentsServer.RecalculateQuantityInTable(QueryTable);
	Return QueryTable;
EndFunction

&AtServer
Function GetDocumentTable_InventoryTransferOrder(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	""InventoryTransferOrder"" AS BasedOn,
		|	TransferOrderBalanceBalance.StoreSender,
		|	TransferOrderBalanceBalance.StoreReceiver,
		|	TransferOrderBalanceBalance.Order AS InventoryTransferOrder,
		|	TransferOrderBalanceBalance.ItemKey,
		|	TransferOrderBalanceBalance.RowKey,
		|	CASE
		|		WHEN TransferOrderBalanceBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN TransferOrderBalanceBalance.ItemKey.Unit
		|		ELSE TransferOrderBalanceBalance.ItemKey.Item.Unit
		|	END AS Unit,
		|	TransferOrderBalanceBalance.QuantityBalance AS Quantity
		|FROM
		|	AccumulationRegister.TransferOrderBalance.Balance(,Order IN (&ArrayOfBasis)) AS
		|		TransferOrderBalanceBalance
		|WHERE TransferOrderBalanceBalance.QuantityBalance > 0";
	Query.SetParameter("ArrayOfBasis", ArrayOfBasisDocuments);
	
	QueryTable = Query.Execute().Unload();
	Return ExtractInfoFromOrderRows(QueryTable);
EndFunction