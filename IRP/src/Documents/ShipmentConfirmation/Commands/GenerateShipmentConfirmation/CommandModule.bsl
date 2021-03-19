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
		OpenForm("Document.ShipmentConfirmation.ObjectForm", New Structure("FillingValues", FillingData), , New UUID());
	EndDo;
EndProcedure

&AtServer
Function GetDocumentsStructure(ArrayOfBasisDocuments)
	ArrayOf_PurchaseReturn = New Array();
	
	For Each Row In ArrayOfBasisDocuments Do
		If TypeOf(Row) = Type("DocumentRef.PurchaseReturn") Then
			ArrayOf_PurchaseReturn.Add(Row);
		Else
			Raise R().Error_043;
		EndIf;
	EndDo;
	
	ArrayOfTables = New Array();
	ArrayOfTables.Add(GetDocumentTable_PurchaseReturn(ArrayOf_PurchaseReturn));
	Return JoinDocumentsStructure(ArrayOfTables);
EndFunction

&AtServer
Function JoinDocumentsStructure(ArrayOfTables)
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
	ValueTable.Columns.Add("ShipmentBasis", New TypeDescription(Metadata.DefinedTypes.typeShipmentBasis.Type));
	ValueTable.Columns.Add("SalesOrder", New TypeDescription(Metadata.DefinedTypes.typeShipmentBasis.Type));
	ValueTable.Columns.Add("RowKey", New TypeDescription("String"));
	
	For Each Table In ArrayOfTables Do
		For Each Row In Table Do
			FillPropertyValues(ValueTable.Add(), Row);
		EndDo;
	EndDo;
	
	ValueTableCopy = ValueTable.Copy();
	ValueTableCopy.GroupBy("BasedOn, Company, Partner, LegalName, Agreement, Store");
	
	ArrayOfResults = New Array();
	
	For Each Row In ValueTableCopy Do
		Result = New Structure();
		Result.Insert("BasedOn", Row.BasedOn);
		Result.Insert("Company", Row.Company);
		Result.Insert("Partner", Row.Partner);
		Result.Insert("LegalName", Row.LegalName);
		Result.Insert("Agreement", Row.Agreement);
		Result.Insert("Store", Row.Store);
		Result.Insert("ItemList", New Array());
		
		Filter = New Structure();
		Filter.Insert("BasedOn", Row.BasedOn);
		Filter.Insert("Company", Row.Company);
		Filter.Insert("Partner", Row.Partner);
		Filter.Insert("LegalName", Row.LegalName);
		Filter.Insert("Agreement", Row.Agreement);
		Filter.Insert("Store", Row.Store);
		
		ItemList = ValueTable.Copy(Filter);
		For Each RowItemList In ItemList Do
			NewRow = New Structure();
			NewRow.Insert("ItemKey", RowItemList.ItemKey);
			NewRow.Insert("Store", RowItemList.Store);
			NewRow.Insert("Unit", RowItemList.Unit);
			NewRow.Insert("Quantity", RowItemList.Quantity);
			NewRow.Insert("ShipmentBasis", RowItemList.ShipmentBasis);
			NewRow.Insert("SalesOrder", RowItemList.SalesOrder);
			NewRow.Insert("Key", RowItemList.RowKey);
			Result.ItemList.Add(NewRow);
		EndDo;
		ArrayOfResults.Add(Result);
	EndDo;
	Return ArrayOfResults;
EndFunction

&AtServer
Function GetDocumentTable_PurchaseReturn(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	""PurchaseReturn"" AS BasedOn,
		|	GoodsInTransitOutgoingBalance.Store AS Store,
		|	CAST(GoodsInTransitOutgoingBalance.ShipmentBasis AS Document.PurchaseReturn) AS ShipmentBasis,
		|	CAST(GoodsInTransitOutgoingBalance.ShipmentBasis AS Document.PurchaseReturn).Partner AS Partner,
		|	CAST(GoodsInTransitOutgoingBalance.ShipmentBasis AS Document.PurchaseReturn).LegalName AS LegalName,
		|	CAST(GoodsInTransitOutgoingBalance.ShipmentBasis AS Document.PurchaseReturn).Agreement AS Agreement,
		|	CAST(GoodsInTransitOutgoingBalance.ShipmentBasis AS Document.PurchaseReturn).Company AS Company,
		|	GoodsInTransitOutgoingBalance.ItemKey,
		|	CASE
		|		WHEN GoodsInTransitOutgoingBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN GoodsInTransitOutgoingBalance.ItemKey.Unit
		|		ELSE GoodsInTransitOutgoingBalance.ItemKey.Item.Unit
		|	END AS Unit,
		|	GoodsInTransitOutgoingBalance.QuantityBalance AS Quantity,
		|	GoodsInTransitOutgoingBalance.RowKey
		|FROM
		|	AccumulationRegister.GoodsInTransitOutgoing.Balance(, ShipmentBasis IN (&ArrayOfBasises)) AS
		|		GoodsInTransitOutgoingBalance";
	Query.SetParameter("ArrayOfBasises", ArrayOfBasisDocuments);
	
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

&AtServer
Function GetErrorMessage(BasisDocument)
	ErrorMessage = R().Error_019;
	Return StrTemplate(ErrorMessage, Metadata.Documents.ShipmentConfirmation.Synonym, BasisDocument.Metadata().Synonym);
EndFunction
