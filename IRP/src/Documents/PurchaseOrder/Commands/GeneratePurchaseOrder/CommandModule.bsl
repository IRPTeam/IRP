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
				ErrorText = R()[ErrorMessageKey];
				If ErrorMessageKey = "Error_054" Then
					ErrorText = StrTemplate(ErrorText, BasisDocument);
				EndIf;
				ShowMessageBox( , ErrorText);
				Return;
			EndIf;
		EndDo;
	EndIf;
	
	For Each FillingData In DocumentStructure Do
		OpenForm("Document.PurchaseOrder.ObjectForm", New Structure("FillingValues", FillingData), , New UUID());
	EndDo;
EndProcedure

&AtServer
Function GetDocumentsStructure(ArrayOfBasisDocuments)
	ArrayOf_InternalSupplyRequest = New Array();
	ArrayOf_SalesOrder = New Array();
	
	For Each Row In ArrayOfBasisDocuments Do
		If TypeOf(Row) = Type("DocumentRef.InternalSupplyRequest") Then
			ArrayOf_InternalSupplyRequest.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.SalesOrder") Then
			ArrayOf_SalesOrder.Add(Row);
		Else
			Raise R().Error_043;
		EndIf;
	EndDo;
	
	ArrayOfTables = New Array();
	ArrayOfTables.Add(GetDocumentTable_InternalSupplyRequest(ArrayOf_InternalSupplyRequest));
	ArrayOfTables.Add(GetDocumentTable_SalesOrder(ArrayOf_SalesOrder));
	
	Return JoinDocumentsStructure(ArrayOfTables, "BasedOn, Company");
EndFunction

&AtServer
Function JoinDocumentsStructure(ArrayOfTables, UnjoinFields)
	
	ValueTable = New ValueTable();
	ValueTable.Columns.Add("BasedOn", New TypeDescription("String"));
	ValueTable.Columns.Add("Company", New TypeDescription("CatalogRef.Companies"));
	
	ValueTable.Columns.Add("Store", New TypeDescription("CatalogRef.Stores"));
	ValueTable.Columns.Add("PurchaseBasis", Metadata.DefinedTypes.typePurchaseBasis.Type);
	ValueTable.Columns.Add("ItemKey", New TypeDescription("CatalogRef.ItemKeys"));
	ValueTable.Columns.Add("Unit", New TypeDescription("CatalogRef.Units"));
	ValueTable.Columns.Add("Quantity", New TypeDescription(Metadata.DefinedTypes.typeQuantity.Type));
	ValueTable.Columns.Add("RowKey", New TypeDescription("String"));
	
	For Each Table In ArrayOfTables Do
		For Each Row In Table Do
			FillPropertyValues(ValueTable.Add(), Row);
		EndDo;
	EndDo;
	
	ValueTableCopy = ValueTable.Copy();
	ValueTableCopy.GroupBy(UnjoinFields);
	
	ArrayOfResults = New Array();
	
	For Each Row In ValueTableCopy Do
		Result = New Structure(UnjoinFields);
		FillPropertyValues(Result, Row);
		Result.Insert("ItemList", New Array());
		
		Filter = New Structure(UnjoinFields);
		FillPropertyValues(Filter, Row);
		
		ItemList = ValueTable.Copy(Filter);
		For Each RowItemList In ItemList Do
			NewRow = New Structure();
			NewRow.Insert("ItemKey", RowItemList.ItemKey);
			NewRow.Insert("Store", RowItemList.Store);
			NewRow.Insert("Unit", RowItemList.Unit);
			NewRow.Insert("Quantity", RowItemList.Quantity);
			NewRow.Insert("PurchaseBasis", RowItemList.PurchaseBasis);
			NewRow.Insert("Key", New UUID(RowItemList.RowKey));
			Result.ItemList.Add(NewRow);
		EndDo;
		ArrayOfResults.Add(Result);
	EndDo;
	Return ArrayOfResults;
EndFunction

&AtServer
Function GetDocumentTable_InternalSupplyRequest(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text = "SELECT ALLOWED
		|	""InternalSupplyRequest"" AS BasedOn,
		|	OrderBalance.Store AS Store,
		|	OrderBalance.Order AS PurchaseBasis,
		|	CAST(OrderBalance.Order AS document.InternalSupplyRequest).Company AS Company,
		|	OrderBalance.ItemKey,
		|	OrderBalance.RowKey,
		|	CASE
		|		WHEN OrderBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN OrderBalance.ItemKey.Unit
		|		ELSE OrderBalance.ItemKey.Item.Unit
		|	END AS Unit,
		|	OrderBalance.QuantityBalance AS Quantity
		|FROM
		|	AccumulationRegister.OrderBalance.Balance(, Order IN (&ArrayOfBasises)) AS OrderBalance";
	Query.SetParameter("ArrayOfBasises", ArrayOfBasisDocuments);
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

&AtServer
Function GetDocumentTable_SalesOrder(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text = "SELECT ALLOWED
		|	""SalesOrder"" AS BasedOn,
		|	OrderProcurement.Store AS Store,
		|	OrderProcurement.Order AS PurchaseBasis,
		|	OrderProcurement.Company AS Company,
		|	OrderProcurement.ItemKey,
		|	OrderProcurement.RowKey,
		|	CASE
		|		WHEN OrderProcurement.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN OrderProcurement.ItemKey.Unit
		|		ELSE OrderProcurement.ItemKey.Item.Unit
		|	END AS Unit,
		|	OrderProcurement.QuantityBalance AS Quantity
		|FROM
		|	AccumulationRegister.OrderProcurement.Balance(, Order IN (&ArrayOfBasises)) AS OrderProcurement";
	Query.SetParameter("ArrayOfBasises", ArrayOfBasisDocuments);
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

&AtServer
Function GetErrorMessageKey(BasisDocument)
	
	ErrorMessageKey = Undefined;
	
	If TypeOf(BasisDocument) = Type("DocumentRef.SalesOrder") Then
		If Not BasisDocument.Status.Posting Or Not BasisDocument.Posted Then
			ErrorMessageKey = "Error_054";
		ElsIf BasisDocument.ItemList.FindRows(New Structure("ProcurementMethod", PredefinedValue("Enum.ProcurementMethods.Purchase"))).Count() = 0 Then
			ErrorMessageKey = "Error_055";
		ElsIf GetDocumentTable_SalesOrder(BasisDocument).Count() = 0 Then
			ErrorMessageKey = "Error_056";
		Else
			ErrorMessageKey = "Error_016";
		EndIf;
		
	ElsIf TypeOf(BasisDocument) = Type("DocumentRef.InternalSupplyRequest") Then
		ErrorMessageKey = "Error_023";
	Else	
		ErrorMessageKey = Undefined;
	EndIf;
	
	Return ErrorMessageKey;
EndFunction

