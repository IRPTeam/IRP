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
		OpenForm("Document.ShipmentConfirmation.ObjectForm", New Structure("FillingValues", FillingData), , New UUID());
	EndDo;
EndProcedure

&AtServer
Function GetDocumentsStructure(ArrayOfBasisDocuments)
	ArrayOf_Bundling = New Array();
	ArrayOf_InventoryTransfer = New Array();
	ArrayOf_PurchaseReturn = New Array();
	ArrayOf_SalesInvoice = New Array();
	ArrayOf_SalesOrder = New Array();
	ArrayOf_Unbundling = New Array();
	
	For Each Row In ArrayOfBasisDocuments Do
		If TypeOf(Row) = Type("DocumentRef.Bundling") Then
			ArrayOf_Bundling.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.InventoryTransfer") Then
			ArrayOf_InventoryTransfer.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.PurchaseReturn") Then
			ArrayOf_PurchaseReturn.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.SalesInvoice") Then
			ArrayOf_SalesInvoice.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.SalesOrder") Then
			ArrayOf_SalesOrder.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.Unbundling") Then
			ArrayOf_Unbundling.Add(Row);
		Else
			Raise R().Error_043;
		EndIf;
	EndDo;
	
	ArrayOfTables = New Array();
	ArrayOfTables.Add(GetDocumentTable_Bundling(ArrayOf_Bundling));
	ArrayOfTables.Add(GetDocumentTable_InventoryTransfer(ArrayOf_InventoryTransfer));
	ArrayOfTables.Add(GetDocumentTable_PurchaseReturn(ArrayOf_PurchaseReturn));
	ArrayOfTables.Add(GetDocumentTable_SalesInvoice(ArrayOf_SalesInvoice));
	ArrayOfTables.Add(GetDocumentTable_SalesOrder(ArrayOf_SalesOrder));
	ArrayOfTables.Add(GetDocumentTable_Unbundling(ArrayOf_Unbundling));
	
	Return JoinDocumentsStructure(ArrayOfTables);
EndFunction

&AtServer
Function JoinDocumentsStructure(ArrayOfTables)
	
	// *Filter {Header}:
	// BasedOn
	// Company
	// Partner
	// LegalName
	// Agreement
	// Store
	//
	// ItemList
	// -ItemKey
	// -Store
	// -Unit
	// -Quantity
	// -ShipmentBasis
	
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
			NewRow.Insert("Key", New UUID(RowItemList.RowKey));
			Result.ItemList.Add(NewRow);
		EndDo;
		ArrayOfResults.Add(Result);
	EndDo;
	Return ArrayOfResults;
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
Function GetDocumentTable_SalesInvoice(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	""SalesInvoice"" AS BasedOn,
		|	GoodsInTransitOutgoingBalance.Store AS Store,
		|	CAST(GoodsInTransitOutgoingBalance.ShipmentBasis AS Document.SalesInvoice) AS ShipmentBasis,
		|	CAST(GoodsInTransitOutgoingBalance.ShipmentBasis AS Document.SalesInvoice).Partner AS Partner,
		|	CAST(GoodsInTransitOutgoingBalance.ShipmentBasis AS Document.SalesInvoice).LegalName AS LegalName,
		|	CAST(GoodsInTransitOutgoingBalance.ShipmentBasis AS Document.SalesInvoice).Agreement AS Agreement,
		|	CAST(GoodsInTransitOutgoingBalance.ShipmentBasis AS Document.SalesInvoice).Company AS Company,
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
		|		GoodsInTransitOutgoingBalance
		|WHERE
		|	GoodsInTransitOutgoingBalance.QuantityBalance > 0";
	Query.SetParameter("ArrayOfBasises", ArrayOfBasisDocuments);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

&AtServer
Function GetDocumentTable_SalesOrder(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	""SalesOrder"" AS BasedOn,
		|	GoodsInTransitOutgoingBalance.Store AS Store,
		|	CAST(GoodsInTransitOutgoingBalance.ShipmentBasis AS Document.SalesOrder) AS ShipmentBasis,
		|	CAST(GoodsInTransitOutgoingBalance.ShipmentBasis AS Document.SalesOrder).Partner AS Partner,
		|	CAST(GoodsInTransitOutgoingBalance.ShipmentBasis AS Document.SalesOrder).LegalName AS LegalName,
		|	CAST(GoodsInTransitOutgoingBalance.ShipmentBasis AS Document.SalesOrder).Agreement AS Agreement,
		|	CAST(GoodsInTransitOutgoingBalance.ShipmentBasis AS Document.SalesOrder).Company AS Company,
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
Function GetDocumentTable_Unbundling(ArrayOfBasisDocuments)
	Return GetDocumentTable(ArrayOfBasisDocuments, "Unbundling");
EndFunction

&AtServer
Function GetDocumentTable(ArrayOfBasisDocuments, BasedOn)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	&BasedOn AS BasedOn,
		|	GoodsInTransitOutgoingBalance.Store AS Store,
		|	GoodsInTransitOutgoingBalance.ShipmentBasis AS ShipmentBasis,
		|	GoodsInTransitOutgoingBalance.ItemKey,
		|	CASE
		|		WHEN GoodsInTransitOutgoingBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN GoodsInTransitOutgoingBalance.ItemKey.Unit
		|		ELSE GoodsInTransitOutgoingBalance.ItemKey.Item.Unit
		|	END AS Unit,
		|	GoodsInTransitOutgoingBalance.QuantityBalance AS Quantity,
		|	GoodsInTransitOutgoingBalance.ShipmentBasis.Company AS Company,
		|	GoodsInTransitOutgoingBalance.RowKey
		|FROM
		|	AccumulationRegister.GoodsInTransitOutgoing.Balance(, ShipmentBasis IN (&ArrayOfBasises)) AS
		|		GoodsInTransitOutgoingBalance";
	Query.SetParameter("ArrayOfBasises", ArrayOfBasisDocuments);
	Query.SetParameter("BasedOn", BasedOn);
	
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

&AtServer
Function GetErrorMessage(BasisDocument)
	ErrorMessage = Undefined;
	
	If TypeOf(BasisDocument) = Type("DocumentRef.SalesOrder") Then
		If Not BasisDocument.Status.Posting Or Not BasisDocument.Posted Then
			Return StrTemplate(R()["Error_067"], String(BasisDocument));		
		EndIf;
		If BasisDocument.ShipmentConfirmationsBeforeSalesInvoice Then
			If WithoutBalance(BasisDocument) And HasShipmentConfirmation(BasisDocument) Then
				ErrorMessage = R()["Error_019"];
				ErrorMessage = StrTemplate(ErrorMessage, Metadata.Documents.ShipmentConfirmation.Synonym, BasisDocument.Metadata().Synonym);
			Else
				ErrorMessage = R()["Error_031"];
			EndIf;
		Else
			If SalesInvoiceExist(BasisDocument) Then
				ErrorMessage = R()["Error_019"];
				ErrorMessage = StrTemplate(ErrorMessage, Metadata.Documents.ShipmentConfirmation.Synonym, BasisDocument.Metadata().Synonym);
			Else
				ErrorMessage = R()["Error_024"];
			EndIf;
			
		EndIf;
		
	Else
		ErrorMessage = R()["Error_019"];
		ErrorMessage = StrTemplate(ErrorMessage, Metadata.Documents.ShipmentConfirmation.Synonym, BasisDocument.Metadata().Synonym);
	EndIf;
	
	Return ErrorMessage;
EndFunction

&AtServer
Function SalesInvoiceExist(BasisDocument)
	
	Query = New Query(
			"SELECT
			|	OrderBalance.Store,
			|	OrderBalance.Order,
			|	OrderBalance.ItemKey,
			|	OrderBalance.RowKey,
			|	OrderBalance.QuantityBalance
			|FROM
			|	AccumulationRegister.OrderBalance.Balance(, Order = &BasisDocument) AS OrderBalance");
	Query.SetParameter("BasisDocument", BasisDocument);
	Return Query.Execute().IsEmpty();
	
EndFunction

&AtServer
Function HasShipmentConfirmation(BasisDocument)
	
	Query = New Query;
	Query.Text =
		"SELECT TOP 1
		|	GoodsInTransitOutgoing.Recorder
		|FROM
		|	AccumulationRegister.GoodsInTransitOutgoing AS GoodsInTransitOutgoing
		|WHERE
		|	GoodsInTransitOutgoing.ShipmentBasis = &BasisDocument";
	
	Query.SetParameter("BasisDocument", BasisDocument);
	
	Return Not Query.Execute().IsEmpty();
EndFunction

&AtServer
Function WithoutBalance(BasisDocument)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	GoodsInTransitOutgoingBalance.ShipmentBasis,
		|	GoodsInTransitOutgoingBalance.QuantityBalance
		|FROM
		|	AccumulationRegister.GoodsInTransitOutgoing.Balance(, ShipmentBasis IN (&BasisDocument)) AS
		|		GoodsInTransitOutgoingBalance
		|WHERE
		|	GoodsInTransitOutgoingBalance.QuantityBalance > 0";
	Query.SetParameter("BasisDocument", BasisDocument);
	
	Return Query.Execute().IsEmpty() ;
	
EndFunction

