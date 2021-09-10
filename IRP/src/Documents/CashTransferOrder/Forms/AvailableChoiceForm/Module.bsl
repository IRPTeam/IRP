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

	List.Parameters.SetParameterValue("ArrayOfPlaningTransactionBasis", QueryTable.UnloadColumn(
		"PlaningTransactionBasis"));
	If Parameters.Property("ArrayOfSelectedDocuments") And Parameters.ArrayOfSelectedDocuments.Count() Then
		List.Parameters.SetParameterValue("UseArrayOfSelectedDocuments", True);
		List.Parameters.SetParameterValue("ArrayOfSelectedDocuments", Parameters.ArrayOfSelectedDocuments);
	Else
		List.Parameters.SetParameterValue("UseArrayOfSelectedDocuments", False);
		List.Parameters.SetParameterValue("ArrayOfSelectedDocuments", Undefined);
	EndIf;
EndProcedure