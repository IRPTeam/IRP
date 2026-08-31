
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	FormParameters = New Structure();
	FormParameters.Insert("Dependent", CommandParameter);
	FormParameters.Insert("Basis", GetBasis(CommandParameter));
	OpenForm("DataProcessor.RowIDInspector.Form", FormParameters); 
EndProcedure

&AtServer
Function GetBasis(DocRef)
	Query = New Query();
	If TypeOf(DocRef) = Type("DocumentRef.SalesInvoice") Then
		Query.Text = 
		"SELECT
		|	TM1010B_RowIDMovementsBalance.Basis as Basis
		|FROM
		|	AccumulationRegister.TM1010B_RowIDMovements.Balance(, RowRef.PartnerSales = &Partner
		|	AND RowRef.AgreementSales = &Agreement) AS TM1010B_RowIDMovementsBalance
		|WHERE
		|	TM1010B_RowIDMovementsBalance.Basis REFS document.salesorder
		|	AND TM1010B_RowIDMovementsBalance.QuantityBalance > 0
		|
		|ORDER BY
		|	TM1010B_RowIDMovementsBalance.Basis.DocumentNumber";
	ElsIf TypeOf(DocRef) = Type("DocumentRef.PurchaseInvoice") Then
		Query.Text = 
		"SELECT
		|	TM1010B_RowIDMovementsBalance.Basis AS Basis
		|FROM
		|	AccumulationRegister.TM1010B_RowIDMovements.Balance(, RowRef.PartnerPurchases = &Partner
		|	AND RowRef.AgreementPurchases = &Agreement) AS TM1010B_RowIDMovementsBalance
		|WHERE
		|	TM1010B_RowIDMovementsBalance.Basis REFS document.purchaseorder
		|	AND TM1010B_RowIDMovementsBalance.QuantityBalance > 0
		|
		|ORDER BY
		|	TM1010B_RowIDMovementsBalance.Basis.DocumentNumber";
	EndIf;		
	Query.SetParameter("Partner", DocRef.Partner);
	Query.SetParameter("Agreement", DocRef.Agreement);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Basis;
	EndIf;
	Return Undefined;
EndFunction

