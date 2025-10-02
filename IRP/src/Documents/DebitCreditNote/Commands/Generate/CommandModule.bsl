
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	DocumentStructure = GetDocumentsStructure(CommandParameter);

	For Each FillingData In DocumentStructure Do
		OpenForm("Document.DebitCreditNote.ObjectForm", New Structure("FillingValues", FillingData), , New UUID());
	EndDo;
EndProcedure

&AtServer
Function GetDocumentsStructure(ArrayOfBasisDocuments)

	ArrayOf_SalesReturn      = New Array();
	ArrayOf_PurchaseReturn   = New Array();
	ArrayOf_DebitNote   = New Array();
	ArrayOf_CreditNote   = New Array();
	
	For Each Row In ArrayOfBasisDocuments Do

		If TypeOf(Row) = Type("DocumentRef.SalesReturn") Then
			ArrayOf_SalesReturn.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.PurchaseReturn") Then
			ArrayOf_PurchaseReturn.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.DebitNote") Then
			ArrayOf_DebitNote.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.CreditNote") Then
			ArrayOf_CreditNote.Add(Row);
		Else
			Raise R().Error_043;
		EndIf;

	EndDo;

	ArrayOfTables = New Array();
	ArrayOfTables.Add(GetDocumentTable_SalesReturn(ArrayOf_SalesReturn));
	ArrayOfTables.Add(GetDocumentTable_PurchaseReturn(ArrayOf_PurchaseReturn));
	ArrayOfTables.Add(GetDocumentTable_DebitNote(ArrayOf_DebitNote));
	ArrayOfTables.Add(GetDocumentTable_CreditNote(ArrayOf_CreditNote));
	Return JoinDocumentsStructure(ArrayOfTables);
EndFunction

&AtServer
Function GetDocumentTable_DebitNote(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	""DebitNote"" AS BasedOn,
	|	DebitNoteTransactions.Ref.Company AS Company,
	|	DebitNoteTransactions.Currency AS Currency,
	|	DebitNoteTransactions.Ref AS BasisDocument,
	|	VALUE(Enum.DebtTypes.TransactionVendor) AS SendDebtType,
	|	DebitNoteTransactions.Ref.Branch AS Branch,
	|	DebitNoteTransactions.Partner AS SendPartner,
	|	DebitNoteTransactions.LegalName AS SendLegalName,
	|	DebitNoteTransactions.Agreement AS SendAgreement,
	|	DebitNoteTransactions.LegalNameContract AS SendLegalNameContract,
	|	DebitNoteTransactions.Project AS SendProject,
	|	DebitNoteTransactions.Ref AS SendBasisDocument,
	|	DebitNoteTransactions.Currency AS SendCurrency,
	|	-DebitNoteTransactions.Amount AS SendAmount,
	|	VALUE(Enum.DebtTypes.AdvanceVendor) AS ReceiveDebtType,
	|	DebitNoteTransactions.Ref.Branch AS ReceiveBranch,
	|	DebitNoteTransactions.Partner AS ReceivePartner,
	|	DebitNoteTransactions.LegalName AS ReceiveLegalName,
	|	DebitNoteTransactions.Agreement AS ReceiveAgreement,
	|	DebitNoteTransactions.LegalNameContract AS ReceiveLegalNameContract,
	|	DebitNoteTransactions.Project AS ReceiveProject,
	|	DebitNoteTransactions.Currency AS ReceiveCurrency,
	|	-DebitNoteTransactions.Amount AS ReceiveAmount
	|FROM
	|	Document.DebitNote.Transactions AS DebitNoteTransactions
	|WHERE
	|	DebitNoteTransactions.Ref IN (&ArrayOfBasisDocuments)
	|	AND DebitNoteTransactions.Agreement.Type = VALUE(Enum.AgreementTypes.Vendor)";
	Query.SetParameter("ArrayOfBasisDocuments", ArrayOfBasisDocuments);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
Endfunction

&AtServer
Function GetDocumentTable_CreditNote(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	""CreditNote"" AS BasedOn,
	|	CreditNoteTransactions.Ref.Company AS Company,
	|	CreditNoteTransactions.Currency AS Currency,
	|	CreditNoteTransactions.Ref AS BasisDocument,
	|	VALUE(Enum.DebtTypes.TransactionCustomer) AS SendDebtType,
	|	CreditNoteTransactions.Ref.Branch AS Branch,
	|	CreditNoteTransactions.Partner AS SendPartner,
	|	CreditNoteTransactions.LegalName AS SendLegalName,
	|	CreditNoteTransactions.Agreement AS SendAgreement,
	|	CreditNoteTransactions.LegalNameContract AS SendLegalNameContract,
	|	CreditNoteTransactions.Project AS SendProject,
	|	CreditNoteTransactions.Ref AS SendBasisDocument,
	|	CreditNoteTransactions.Currency AS SendCurrency,
	|	-CreditNoteTransactions.Amount AS SendAmount,
	|	VALUE(Enum.DebtTypes.AdvanceCustomer) AS ReceiveDebtType,
	|	CreditNoteTransactions.Ref.Branch AS ReceiveBranch,
	|	CreditNoteTransactions.Partner AS ReceivePartner,
	|	CreditNoteTransactions.LegalName AS ReceiveLegalName,
	|	CreditNoteTransactions.Agreement AS ReceiveAgreement,
	|	CreditNoteTransactions.LegalNameContract AS ReceiveLegalNameContract,
	|	CreditNoteTransactions.Project AS ReceiveProject,
	|	CreditNoteTransactions.Currency AS ReceiveCurrency,
	|	-CreditNoteTransactions.Amount AS ReceiveAmount
	|FROM
	|	Document.CreditNote.Transactions AS CreditNoteTransactions
	|WHERE
	|	CreditNoteTransactions.Ref IN (&ArrayOfBasisDocuments)
	|	AND CreditNoteTransactions.Agreement.Type = VALUE(Enum.AgreementTypes.Customer)";
	Query.SetParameter("ArrayOfBasisDocuments", ArrayOfBasisDocuments);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
Endfunction

&AtServer
Function GetDocumentTable_SalesReturn(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	""SalesReturn"" AS BasedOn,
	|	SalesReturnItemList.Ref.Company AS Company,
	|	SalesReturnItemList.Ref.Currency AS Currency,
	|	SalesReturnItemList.Ref AS BasisDocument,
	|	VALUE(Enum.DebtTypes.TransactionCustomer) AS SendDebtType,
	|	SalesReturnItemList.Ref.Branch AS Branch,
	|	SalesReturnItemList.Ref.Partner AS SendPartner,
	|	SalesReturnItemList.Ref.LegalName AS SendLegalName,
	|	SalesReturnItemList.Ref.Agreement AS SendAgreement,
	|	SalesReturnItemList.Ref.LegalNameContract AS SendLegalNameContract,
	|	SalesReturnItemList.Project AS SendProject,
	|	SalesReturnItemList.Ref AS SendBasisDocument,
	|	SalesReturnItemList.Ref.Currency AS SendCurrency,
	|	-SalesReturnItemList.TotalAmount AS SendAmount,
	|	VALUE(Enum.DebtTypes.AdvanceCustomer) AS ReceiveDebtType,
	|	SalesReturnItemList.Ref.Branch AS ReceiveBranch,
	|	SalesReturnItemList.Ref.Partner AS ReceivePartner,
	|	SalesReturnItemList.Ref.LegalName AS ReceiveLegalName,
	|	SalesReturnItemList.Ref.Agreement AS ReceiveAgreement,
	|	SalesReturnItemList.Ref.LegalNameContract AS ReceiveLegalNameContract,
	|	SalesReturnItemList.Project AS ReceiveProject,
	|	SalesReturnItemList.Ref.Currency AS ReceiveCurrency,
	|	-SalesReturnItemList.TotalAmount AS ReceiveAmount
	|FROM
	|	Document.SalesReturn.ItemList AS SalesReturnItemList
	|WHERE
	|	SalesReturnItemList.Ref IN (&ArrayOfBasisDocuments)";
	Query.SetParameter("ArrayOfBasisDocuments", ArrayOfBasisDocuments);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

&AtServer
Function GetDocumentTable_PurchaseReturn(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	""PurchaseReturn"" AS BasedOn,
	|	PurchaseReturnItemList.Ref.Company AS Company,
	|	PurchaseReturnItemList.Ref.Currency AS Currency,
	|	PurchaseReturnItemList.Ref AS BasisDocument,
	|	VALUE(Enum.DebtTypes.TransactionVendor) AS SendDebtType,
	|	PurchaseReturnItemList.Ref.Branch AS Branch,
	|	PurchaseReturnItemList.Ref.Partner AS SendPartner,
	|	PurchaseReturnItemList.Ref.LegalName AS SendLegalName,
	|	PurchaseReturnItemList.Ref.Agreement AS SendAgreement,
	|	PurchaseReturnItemList.Ref.LegalNameContract AS SendLegalNameContract,
	|	PurchaseReturnItemList.Project AS SendProject,
	|	PurchaseReturnItemList.Ref AS SendBasisDocument,
	|	PurchaseReturnItemList.Ref.Currency AS SendCurrency,
	|	-PurchaseReturnItemList.TotalAmount AS SendAmount,
	|	VALUE(Enum.DebtTypes.AdvanceVendor) AS ReceiveDebtType,
	|	PurchaseReturnItemList.Ref.Branch AS ReceiveBranch,
	|	PurchaseReturnItemList.Ref.Partner AS ReceivePartner,
	|	PurchaseReturnItemList.Ref.LegalName AS ReceiveLegalName,
	|	PurchaseReturnItemList.Ref.Agreement AS ReceiveAgreement,
	|	PurchaseReturnItemList.Ref.LegalNameContract AS ReceiveLegalNameContract,
	|	PurchaseReturnItemList.Project AS ReceiveProject,
	|	PurchaseReturnItemList.Ref.Currency AS ReceiveCurrency,
	|	-PurchaseReturnItemList.TotalAmount AS ReceiveAmount
	|FROM
	|	Document.PurchaseReturn.ItemList AS PurchaseReturnItemList
	|WHERE
	|	PurchaseReturnItemList.Ref IN (&ArrayOfBasisDocuments)";
	Query.SetParameter("ArrayOfBasisDocuments", ArrayOfBasisDocuments);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

&AtServer
Function JoinDocumentsStructure(ArrayOfTables)

	Attr = Metadata.Documents.DebitCreditNote.Attributes;
	ValueTable = New ValueTable();
	ValueTable.Columns.Add("BasedOn"  , New TypeDescription("String"));
	ValueTable.Columns.Add("Company"  , Attr.Company.Type);
	ValueTable.Columns.Add("Currency" , Attr.Currency.Type);
	ValueTable.Columns.Add("BasisDocument" , Attr.BasisDocument.Type);
	
	ValueTable.Columns.Add("SendDebtType"          , Attr.SendDebtType.Type);
	ValueTable.Columns.Add("Branch"                , Attr.ReceiveBranch.Type);
	ValueTable.Columns.Add("SendPartner"           , Attr.SendPartner.Type);
	ValueTable.Columns.Add("SendLegalName"         , Attr.SendLegalName.Type);
	ValueTable.Columns.Add("SendAgreement"         , Attr.SendAgreement.Type);
	ValueTable.Columns.Add("SendLegalNameContract" , Attr.SendLegalNameContract.Type);
	ValueTable.Columns.Add("SendProject"           , Attr.SendProject.Type);
	ValueTable.Columns.Add("SendOrder"             , Attr.SendOrder.Type);
	ValueTable.Columns.Add("SendBasisDocument"     , Attr.SendBasisDocument.Type);
	ValueTable.Columns.Add("SendCurrency"          , Attr.SendCurrency.Type);
	ValueTable.Columns.Add("SendAmount"            , Attr.SendAmount.Type);
	
	ValueTable.Columns.Add("ReceiveDebtType"          , Attr.ReceiveDebtType.Type);
	ValueTable.Columns.Add("ReceiveBranch"            , Attr.ReceiveBranch.Type);
	ValueTable.Columns.Add("ReceivePartner"           , Attr.ReceivePartner.Type);
	ValueTable.Columns.Add("ReceiveLegalName"         , Attr.ReceiveLegalName.Type);
	ValueTable.Columns.Add("ReceiveAgreement"         , Attr.ReceiveAgreement.Type);
	ValueTable.Columns.Add("ReceiveLegalNameContract" , Attr.ReceiveLegalNameContract.Type);
	ValueTable.Columns.Add("ReceiveProject"           , Attr.ReceiveProject.Type);
	ValueTable.Columns.Add("ReceiveOrder"             , Attr.ReceiveOrder.Type);
	ValueTable.Columns.Add("ReceiveCurrency"          , Attr.ReceiveCurrency.Type);
	ValueTable.Columns.Add("ReceiveAmount"            , Attr.ReceiveAmount.Type);
		
	For Each Table In ArrayOfTables Do
		For Each Row In Table Do
			NewRow = ValueTable.Add();
			FillPropertyValues(NewRow, Row);
		EndDo;
	EndDo;

	ArrayOfResults = New Array();

	ValueTableCopy = ValueTable.Copy();
	ValueTableCopy.GroupBy("BasedOn, Company, Currency, BasisDocument,
	|SendDebtType, Branch, SendPartner, SendLegalName, SendAgreement, SendLegalNameContract,
	|SendProject, SendOrder, SendBasisDocument, SendCurrency,
	|ReceiveDebtType, ReceiveBranch, ReceivePartner, ReceiveLegalName, ReceiveAgreement, ReceiveLegalNameContract,
	|ReceiveProject, ReceiveOrder, ReceiveCurrency", "SendAmount, ReceiveAmount");
	
	ArrayOfResults = New Array();

	For Each Row In ValueTableCopy Do

		Result = New Structure();
		Result.Insert("BasedOn"  , Row.BasedOn);
		Result.Insert("Company"  , Row.Company);
		Result.Insert("Currency" , Row.Currency);
		Result.Insert("BasisDocument" , Row.BasisDocument);
		
		Result.Insert("SendDebtType"          , Row.SendDebtType);
		Result.Insert("Branch"                , Row.ReceiveBranch);
		Result.Insert("SendPartner"           , Row.SendPartner);
		Result.Insert("SendLegalName"         , Row.SendLegalName);
		Result.Insert("SendAgreement"         , Row.SendAgreement);
		Result.Insert("SendLegalNameContract" , Row.SendLegalNameContract);
		Result.Insert("SendProject"           , Row.SendProject);
		Result.Insert("SendOrder"             , Row.SendOrder);
		Result.Insert("SendBasisDocument"     , Row.SendBasisDocument);
		Result.Insert("SendCurrency"          , Row.SendCurrency);
		Result.Insert("SendAmount"            , Row.SendAmount);
		
		Result.Insert("ReceiveDebtType"          , Row.ReceiveDebtType);
		Result.Insert("ReceiveBranch"            , Row.ReceiveBranch);
		Result.Insert("ReceivePartner"           , Row.ReceivePartner);
		Result.Insert("ReceiveLegalName"         , Row.ReceiveLegalName);
		Result.Insert("ReceiveAgreement"         , Row.ReceiveAgreement);
		Result.Insert("ReceiveLegalNameContract" , Row.ReceiveLegalNameContract);
		Result.Insert("ReceiveProject"           , Row.ReceiveProject);
		Result.Insert("ReceiveOrder"             , Row.ReceiveOrder);
		Result.Insert("ReceiveCurrency"          , Row.ReceiveCurrency);
		Result.Insert("ReceiveAmount"            , Row.ReceiveAmount);
		
		ArrayOfResults.Add(Result);
	EndDo;
	
	Return ArrayOfResults;
EndFunction
