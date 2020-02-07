&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	GenerateDocument(CommandParameter);
EndProcedure

&AtClient
Procedure GenerateDocument(ArrayOfBasisDocuments)
	DocumentStructure = GetDocumentsStructure(ArrayOfBasisDocuments);
		
	For Each FillingData In DocumentStructure Do
		OpenForm("Document.CashPayment.ObjectForm", New Structure("FillingValues", FillingData), , New UUID());
	EndDo;
EndProcedure

Function ErrorMessageStructure(BasisDocuments)
	ErrorMessageStructure = New Structure();
	
	For Each BasisDocument In BasisDocuments Do
		ErrorMessagekey = ErrorMessagekey(BasisDocument);
		If ValueIsFilled(ErrorMessagekey) Then
			ErrorMessageStructure.Insert(ErrorMessagekey, StrTemplate(R()[ErrorMessagekey], Metadata.Documents.CashPayment.Synonym));
		EndIf;
	EndDo;
	
	If ErrorMessageStructure.Count() = 1 Then
		ErrorMessageText = ErrorMessageStructure[ErrorMessagekey];	
	ElsIf ErrorMessageStructure.Count() = 0 Then
		ErrorMessageText = StrTemplate(R().Error_051, Metadata.Documents.CashPayment.Synonym);
	Else
		ErrorMessageText = StrTemplate(R().Error_059, Metadata.Documents.CashPayment.Synonym) + Chars.LF +
																			StrConcat(BasisDocuments, Chars.LF);
	EndIf;
	
	Return ErrorMessageText;
EndFunction

Function ErrorMessagekey(BasisDocument)
	ErrorMessagekey = Undefined;
	
	If TypeOf(BasisDocument) = Type("DocumentRef.CashTransferOrder") Then
		If Not BasisDocument.Sender.Type = PredefinedValue("Enum.CashAccountTypes.Cash") Then
			ErrorMessagekey = "Error_057";
		Else
			ErrorMessagekey = "Error_058";
		EndIf;
	EndIf;
	
	Return ErrorMessagekey;
EndFunction

&AtServer 
Function GetUserMessege()
	Return StrTemplate(R().Error_051, Metadata.Documents.CashPayment.ListPresentation);
EndFunction

Function GetDocumentsStructure(ArrayOfBasisDocuments)
	ArrayOf_CashTransferOrder = New Array();
	ArrayOf_OutgoingPaymentOrder = New Array();
	ArrayOf_PurchaseInvoice = New Array();
	
	For Each Row In ArrayOfBasisDocuments Do
		
		If TypeOf(Row) = Type("DocumentRef.CashTransferOrder") Then
			ArrayOf_CashTransferOrder.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.OutgoingPaymentOrder") Then
			ArrayOf_OutgoingPaymentOrder.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.PurchaseInvoice") Then
			ArrayOf_PurchaseInvoice.Add(Row);
		Else
			Raise R().Error_043;
		EndIf;
		
	EndDo;
	
	ArrayOfTables = New Array();
	ArrayOfTables.Add(GetDocumentTable_CashTransferOrder(ArrayOf_CashTransferOrder));
	ArrayOfTables.Add(GetDocumentTable_OutgoingPaymentOrder(ArrayOf_OutgoingPaymentOrder));
	ArrayOfTables.Add(GetDocumentTable_PurchaseInvoice(ArrayOf_PurchaseInvoice));
	
	Return JoinDocumentsStructure(ArrayOfTables);
EndFunction

Function JoinDocumentsStructure(ArrayOfTables)
	
	ValueTable = New ValueTable();
	ValueTable.Columns.Add("BasedOn", New TypeDescription("String"));
	ValueTable.Columns.Add("Company", New TypeDescription("CatalogRef.Companies"));
	ValueTable.Columns.Add("CashAccount", New TypeDescription("CatalogRef.CashAccounts"));
	ValueTable.Columns.Add("Currency", New TypeDescription("CatalogRef.Currencies"));
	ValueTable.Columns.Add("TransactionType", New TypeDescription("EnumRef.OutgoingPaymentTransactionTypes"));
	
	ValueTable.Columns.Add("BasisDocument", New TypeDescription(Metadata.DefinedTypes.typeApTransactionBasises.Type));
	ValueTable.Columns.Add("Agreement", New TypeDescription("CatalogRef.Agreements"));
	ValueTable.Columns.Add("Partner", New TypeDescription("CatalogRef.Partners"));
	ValueTable.Columns.Add("Amount", New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ValueTable.Columns.Add("Payee", New TypeDescription("CatalogRef.Companies"));
	ValueTable.Columns.Add("PlaningTransactionBasis"
		, New TypeDescription(Metadata.DefinedTypes.typePlaningTransactionBasises.Type));
	
	For Each Table In ArrayOfTables Do
		For Each Row In Table Do
			FillPropertyValues(ValueTable.Add(), Row);
		EndDo;
	EndDo;
	
	ValueTableCopy = ValueTable.Copy();
	ValueTableCopy.GroupBy("BasedOn, TransactionType, Company, CashAccount, Currency");
	
	ArrayOfResults = New Array();
	
	For Each Row In ValueTableCopy Do
		Result = New Structure();
		Result.Insert("BasedOn", Row.BasedOn);
		Result.Insert("TransactionType", Row.TransactionType);
		Result.Insert("Company", Row.Company);
		Result.Insert("CashAccount", Row.CashAccount);
		Result.Insert("Currency", Row.Currency);
		Result.Insert("PaymentList", New Array());
		
		Filter = New Structure();
		Filter.Insert("BasedOn", Row.BasedOn);
		Filter.Insert("TransactionType", Row.TransactionType);
		Filter.Insert("Company", Row.Company);
		Filter.Insert("CashAccount", Row.CashAccount);
		Filter.Insert("Currency", Row.Currency);
		
		PaymentList = ValueTable.Copy(Filter);
		For Each RowPaymentList In PaymentList Do
			NewRow = New Structure();
			NewRow.Insert("BasisDocument", RowPaymentList.BasisDocument);
			NewRow.Insert("Agreement", RowPaymentList.Agreement);
			NewRow.Insert("Partner", RowPaymentList.Partner);
			NewRow.Insert("Payee", RowPaymentList.Payee);
			NewRow.Insert("Amount", RowPaymentList.Amount);
			NewRow.Insert("PlaningTransactionBasis", RowPaymentList.PlaningTransactionBasis);
			
			Result.PaymentList.Add(NewRow);
		EndDo;
		ArrayOfResults.Add(Result);
	EndDo;
	Return ArrayOfResults;
EndFunction

Function GetDocumentTable_CashTransferOrder(ArrayOfBasisDocuments)
	Result = DocCashPaymentServer.GetDocumentTable_CashTransferOrder(ArrayOfBasisDocuments);
	
	ErrorDocuments = New Array();
	For Each BasisDocument In ArrayOfBasisDocuments Do
		If Result.FindRows(New Structure("PlaningTransactionBasis", BasisDocument)).Count() = 0 Then
			ErrorDocuments.Add(BasisDocument);
		EndIf;
	EndDo;
	
	If ErrorDocuments.Count() Then
		ErrorMessageText = ErrorMessageStructure(ErrorDocuments);
		CommonFunctionsClientServer.ShowUsersMessage(ErrorMessageText);	
	EndIf;
	
	Return Result;
EndFunction

Function GetDocumentTable_OutgoingPaymentOrder(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	""OutgoingPaymentOrder"" AS BasedOn,
		|	VALUE(Enum.OutgoingPaymentTransactionTypes.PaymentToVendor) AS TransactionType,
		|	PlaningCashTransactionsTurnovers.Company AS Company,
		|	PlaningCashTransactionsTurnovers.Account AS CashAccount,
		|	PlaningCashTransactionsTurnovers.Currency AS Currency,
		|	PlaningCashTransactionsTurnovers.Partner AS Partner,
		|	PlaningCashTransactionsTurnovers.LegalName AS Payee,
		|	PlaningCashTransactionsTurnovers.AmountTurnover AS Amount,
		|	PlaningCashTransactionsTurnovers.BasisDocument AS PlaningTransactionBasis
		|FROM
		|	AccumulationRegister.PlaningCashTransactions.Turnovers(,,,
		|		CashFlowDirection = VALUE(Enum.CashFlowDirections.Outgoing)
		|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
		|	AND BasisDocument IN (&ArrayOfBasisDocuments)) AS PlaningCashTransactionsTurnovers
		|WHERE
		|	PlaningCashTransactionsTurnovers.Account.Type = VALUE(Enum.CashAccountTypes.Cash)
		|	AND PlaningCashTransactionsTurnovers.AmountTurnover > 0";
	Query.SetParameter("ArrayOfBasisDocuments", ArrayOfBasisDocuments);
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

Function GetDocumentTable_PurchaseInvoice(ArrayOfBasisDocuments)
	
	Return DocumentsGenerationServer.GetDocumentTable_PurchaseInvoice_ForPayment(ArrayOfBasisDocuments);
	
EndFunction