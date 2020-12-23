&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	
	MapOfSeparatedInternalSupplyRequests = SeparateInternalSupplyRequestsByStores(CommandParameter);
	
	If MapOfSeparatedInternalSupplyRequests.Count() > 1 Then
		
		OpenArgs = New Structure("MapOfSeparatedInternalSupplyRequests",
				MapOfSeparatedInternalSupplyRequests);
		OpenForm("Document.InventoryTransferOrder.Form.SelectStoreForm"
			, OpenArgs, , , ,
			, New NotifyDescription("SelectStoreFinish", ThisObject,
				New Structure("MapOfSeparatedInternalSupplyRequests",
					MapOfSeparatedInternalSupplyRequests)));
	Else
		
		GenerateDocument(CommandParameter);
		
	EndIf;
EndProcedure

&AtClient
Procedure SelectStoreFinish(Result, AdditionalParameters) Export
	
	If Result = Undefined Then
		Return;
	EndIf;
	
	FillingValues = AdditionalParameters.MapOfSeparatedInternalSupplyRequests.Get(Result);
	
	GenerateDocument(FillingValues);
	
EndProcedure

&AtClient
Procedure GenerateDocument(ArrayOfBasisDocuments)
	
	ErrorMessageKey = GetErrorMessageKey(ArrayOfBasisDocuments);
	If ValueIsFilled(ErrorMessageKey) Then
		ShowMessageBox( , R()[ErrorMessageKey]);
		Return;
	EndIf;
	Settings = New Structure("FillingValues", New Structure("Basis", ArrayOfBasisDocuments));
	OpenForm("Document.InventoryTransferOrder.ObjectForm", Settings, , New UUID());
	
EndProcedure

&AtServer
Function SeparateInternalSupplyRequestsByStores(ArrayOfInternalSupplyRequests)
	Query = New Query();
	Query.Text =
		"SELECT
		|	InternalSupplyRequest.Ref,
		|	InternalSupplyRequest.Store AS Store
		|FROM
		|	Document.InternalSupplyRequest AS InternalSupplyRequest
		|WHERE
		|	InternalSupplyRequest.Ref IN (&ArrayOfInternalSupplyRequests)
		|GROUP BY
		|	InternalSupplyRequest.Ref,
		|	InternalSupplyRequest.Store
		|TOTALS
		|BY
		|	Store";
	Query.SetParameter("ArrayOfInternalSupplyRequests", ArrayOfInternalSupplyRequests);
	QueryResult = Query.Execute();
	QuerySelectionStore = QueryResult.Select(QueryResultIteration.ByGroups);
	ResultMap = New Map();
	While QuerySelectionStore.Next() Do
		QuerySelectionRef = QuerySelectionStore.Select();
		ArrayOfRefs = New Array();
		
		While QuerySelectionRef.Next() Do
			ArrayOfRefs.Add(QuerySelectionRef.Ref);
		EndDo;
		
		ResultMap.Insert(QuerySelectionStore.Store, ArrayOfRefs);
	EndDo;
	Return ResultMap;
EndFunction

&AtServer
Function GetErrorMessageKey(BasisDocument)
	ErrorMessageKey = Undefined;
	
	If TypeOf(BasisDocument) = Type("DocumentRef.InternalSupplyRequest") 
		Or TypeOf(BasisDocument) = Type("Array") Then
		
		If OrdersExist(BasisDocument) Then
			ErrorMessageKey = "Error_023";
		EndIf;
		
	EndIf;
	
	Return ErrorMessageKey;
EndFunction

&AtServer
Function OrdersExist(ArrayOfBasises)
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	OrderBalanceBalance.Store AS Store,
		|	OrderBalanceBalance.Order AS InternalSupplyRequest,
		|	OrderBalanceBalance.ItemKey,
		|	OrderBalanceBalance.RowKey,
		|	CASE
		|		WHEN OrderBalanceBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|			THEN OrderBalanceBalance.ItemKey.Unit
		|		ELSE OrderBalanceBalance.ItemKey.Item.Unit
		|	END AS Unit,
		|	OrderBalanceBalance.QuantityBalance AS Quantity
		|FROM
		|	AccumulationRegister.OrderBalance.Balance(&Period, Order IN (&ArrayOfBasises)) AS OrderBalanceBalance";
	Query.SetParameter("ArrayOfBasises", ArrayOfBasises);
	Query.SetParameter("Period", New Boundary(CurrentSessionDate(), BoundaryType.Excluding));
	
	Return Query.Execute().IsEmpty();
	
EndFunction

