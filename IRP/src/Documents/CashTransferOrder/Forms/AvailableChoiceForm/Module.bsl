

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If TypeOf(Parameters.OwnerRef) = Type("DocumentRef.CashPayment") Then
		TempTableManager = New TempTablesManager();
		Query = New Query();
		Query.TempTablesManager = TempTableManager;
		Query.Text = DocCashPaymentServer.GetDocumentTable_CashTransferOrder_QueryText();
		Query.SetParameter("ArrayOfBasisDocuments", Undefined);
		Query.SetParameter("UseArrayOfBasisDocuments", False);
		If ValueIsFilled(Parameters.OwnerRef) Then
			Query.SetParameter("EndOfDate", New Boundary(Parameters.OwnerRef.PointInTime(), BoundaryType.Excluding));
		Else
			Query.SetParameter("EndOfDate", CurrentDate());
		EndIf;
		
		Query.Execute();
		Query.Text = 
		"SELECT
		|	tmp.BasedOn AS BasedOn,
		|	tmp.TransactionType AS TransactionType,
		|	tmp.Company AS Company,
		|	tmp.CashAccount AS CashAccount,
		|	tmp.Currency AS Currency,
		|	tmp.Amount AS Amount,
		|	tmp.PlaningTransactionBasis AS PlaningTransactionBasis,
		|	tmp.Partner AS Partner
		|FROM
		|	tmp_CashTransferOrder AS tmp";
		QueryResult = Query.Execute();
		QueryTable = QueryResult.Unload();
		
		List.Parameters.SetParameterValue("ArraytOfPlaningTransactionBasis", QueryTable.UnloadColumn("PlaningTransactionBasis"));
		//GetDocumentTable_CashTransferOrder(ArrayOfBasisDocuments, New Boundary(Parameters.Ref.PointInTime(), BoundaryType.Excluding));
		//List.QueryText = DocCashPaymentServer.GetDocumentTable_CashTransferOrder_QueryText() + " ; " + List.QueryText;
	EndIf;
	
	
	
	
//SELECT
//	CashTransferOrder.Ref,
//	CashTransferOrder.Number,
//	CashTransferOrder.Date,
//	CashTransferOrder.Company,
//	CashTransferOrder.Sender,
//	CashTransferOrder.SendCurrency,
//	CashTransferOrder.Receiver,
//	CashTransferOrder.ReceiveCurrency,
//	tmp.TransactionType AS TransactionType,
//	tmp.Amount AS Amount,
//	tmp.Partner AS Partner
//FROM
//	tmp_CashTransferOrder AS tmp
//		INNER JOIN Document.CashTransferOrder AS CashTransferOrder
//		ON tmp.PlaningTransactionBasis = CashTransferOrder.Ref
	
//	List.Parameters.SetParameterValue("EndOfDate", );
//	
//	If Parameters.Property("ArrayOfChoisedDocuments") 
//		And Parameters.ArrayOfChoisedDocuments.Count() Then
//		List.Parameters.SetParameterValue("UseArrayOfChoisedDocuments", True);
//		List.Parameters.SetParameterValue("ArrayOfChoisedDocuments", Parameters.ArrayOfChoisedDocuments);
//	Else
//		List.Parameters.SetParameterValue("UseArrayOfChoisedDocuments", False);
//		List.Parameters.SetParameterValue("ArrayOfChoisedDocuments", Undefined);
//	EndIf;
EndProcedure
