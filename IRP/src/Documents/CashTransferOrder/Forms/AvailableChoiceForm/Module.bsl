

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	TempTableManager = New TempTablesManager();
	Query = New Query();
	Query.TempTablesManager = TempTableManager;
		
	If TypeOf(Parameters.OwnerRef) = Type("DocumentRef.CashPayment") Then
		Query.Text = DocCashPaymentServer.GetDocumentTable_CashTransferOrder_QueryText();
	ElsIf TypeOf(Parameters.OwnerRef) = Type("DocumentRef.CashReceipt") Then
		Query.Text = DocCashReceiptServer.GetDocumentTable_CashTransferOrder_QueryText();
	ElsIf TypeOf(Parameters.OwnerRef) = Type("DocumentRef.BankPayment") Then
		Query.Text = DocBankPaymentServer.GetDocumentTable_CashTransferOrder_QueryText();
	ElsIf TypeOf(Parameters.OwnerRef) = Type("DocumentRef.BankReceipt") Then
		Query.Text = DocBankReceiptServer.GetDocumentTable_CashTransferOrder_QueryText();
	EndIf;
		
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
	|	tmp.PlaningTransactionBasis AS PlaningTransactionBasis
	|FROM
	|	tmp_CashTransferOrder AS tmp";
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
		
	List.Parameters.SetParameterValue("ArraytOfPlaningTransactionBasis", QueryTable.UnloadColumn("PlaningTransactionBasis"));
	If Parameters.Property("ArrayOfChoisedDocuments") 
		And Parameters.ArrayOfChoisedDocuments.Count() Then
		List.Parameters.SetParameterValue("UseArrayOfChoisedDocuments", True);
		List.Parameters.SetParameterValue("ArrayOfChoisedDocuments", Parameters.ArrayOfChoisedDocuments);
	Else
		List.Parameters.SetParameterValue("UseArrayOfChoisedDocuments", False);
		List.Parameters.SetParameterValue("ArrayOfChoisedDocuments", Undefined);
	EndIf;
EndProcedure
