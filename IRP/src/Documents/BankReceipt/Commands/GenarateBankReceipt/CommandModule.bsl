&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	GenerateDocument(CommandParameter);
EndProcedure

&AtClient
Procedure GenerateDocument(ArrayOfBasisDocuments)
	DocumentStructure = GetDocumentsStructure(ArrayOfBasisDocuments);
	
	For Each FillingData In DocumentStructure Do
		OpenForm("Document.BankReceipt.ObjectForm", New Structure("FillingValues", FillingData), , New UUID());
	EndDo;
EndProcedure

Function ErrorMessageStructure(BasisDocuments)
	ErrorMessageStructure = New Structure();
	
	For Each BasisDocument In BasisDocuments Do
		ErrorMessagekey = ErrorMessagekey(BasisDocument);
		If ValueIsFilled(ErrorMessagekey) Then
			ErrorMessageStructure.Insert(ErrorMessagekey, StrTemplate(R()[ErrorMessagekey], Metadata.Documents.BankReceipt.Synonym));
		EndIf;
	EndDo;
	
	If ErrorMessageStructure.Count() = 1 Then
		ErrorMessageText = ErrorMessageStructure[ErrorMessagekey];	
	ElsIf ErrorMessageStructure.Count() = 0 Then
		ErrorMessageText = StrTemplate(R().Error_051, Metadata.Documents.BankReceipt.Synonym);
	Else
		ErrorMessageText = StrTemplate(R().Error_059, Metadata.Documents.BankReceipt.Synonym) + Chars.LF +
																			StrConcat(BasisDocuments, Chars.LF);
	EndIf;
	
	Return ErrorMessageText;
EndFunction

Function ErrorMessagekey(BasisDocument)
	ErrorMessagekey = Undefined;
	
	If TypeOf(BasisDocument) = Type("DocumentRef.CashTransferOrder") Then
		If Not BasisDocument.Receiver.Type = PredefinedValue("Enum.CashAccountTypes.Bank") Then
			ErrorMessagekey = "Error_057";
		Else
			ErrorMessagekey = "Error_060";
		EndIf;
	EndIf;
	
	Return ErrorMessagekey;
EndFunction

Function GetDocumentsStructure(ArrayOfBasisDocuments)
	ArrayOf_CashTransferOrder = New Array();
	ArrayOf_IncomingPaymentOrder = New Array();
	ArrayOf_SalesInvoice = New Array();
	
	For Each Row In ArrayOfBasisDocuments Do
		
		If TypeOf(Row) = Type("DocumentRef.CashTransferOrder") Then
			ArrayOf_CashTransferOrder.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.IncomingPaymentOrder") Then
			ArrayOf_IncomingPaymentOrder.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.SalesInvoice") Then
			ArrayOf_SalesInvoice.Add(Row);
		Else
			Raise R().Error_043;
		EndIf;
		
	EndDo;
	
	ArrayOfTables = New Array();
	ArrayOfTables.Add(GetDocumentTable_CashTransferOrder(ArrayOf_CashTransferOrder));
	ArrayOfTables.Add(GetDocumentTable_IncomingPaymentOrder(ArrayOf_IncomingPaymentOrder));
	ArrayOfTables.Add(GetDocumentTable_SalesInvoice(ArrayOf_SalesInvoice));
	
	Return JoinDocumentsStructure(ArrayOfTables);
EndFunction

Function JoinDocumentsStructure(ArrayOfTables)
	
	ValueTable = New ValueTable();
	ValueTable.Columns.Add("BasedOn", New TypeDescription("String"));
	ValueTable.Columns.Add("Company", New TypeDescription("CatalogRef.Companies"));
	ValueTable.Columns.Add("Account", New TypeDescription("CatalogRef.CashAccounts"));
	ValueTable.Columns.Add("Currency", New TypeDescription("CatalogRef.Currencies"));
	ValueTable.Columns.Add("CurrencyExchange", New TypeDescription("CatalogRef.Currencies"));
	ValueTable.Columns.Add("TransactionType", New TypeDescription("EnumRef.IncomingPaymentTransactionType"));
	
	ValueTable.Columns.Add("BasisDocument", New TypeDescription(Metadata.DefinedTypes.typeArTransactionBasises.Type));
	ValueTable.Columns.Add("Agreement", New TypeDescription("CatalogRef.Agreements"));
	ValueTable.Columns.Add("Partner", New TypeDescription("CatalogRef.Partners"));
	ValueTable.Columns.Add("Amount", New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ValueTable.Columns.Add("Payer", New TypeDescription("CatalogRef.Companies"));
	ValueTable.Columns.Add("PlaningTransactionBasis"
		, New TypeDescription(Metadata.DefinedTypes.typePlaningTransactionBasises.Type));
	ValueTable.Columns.Add("TransitAccount", New TypeDescription("CatalogRef.CashAccounts"));
	ValueTable.Columns.Add("AmountExchange", New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	
	For Each Table In ArrayOfTables Do
		For Each Row In Table Do
			FillPropertyValues(ValueTable.Add(), Row);
		EndDo;
	EndDo;
	
	ValueTableCopy = ValueTable.Copy();
	ValueTableCopy.GroupBy("BasedOn, TransactionType, Company, Account, TransitAccount, Currency, CurrencyExchange");
	
	ArrayOfResults = New Array();
	
	For Each Row In ValueTableCopy Do
		Result = New Structure();
		Result.Insert("BasedOn", Row.BasedOn);
		Result.Insert("TransactionType", Row.TransactionType);
		Result.Insert("Company", Row.Company);
		Result.Insert("Account", Row.Account);
		Result.Insert("TransitAccount", Row.TransitAccount);
		Result.Insert("Currency", Row.Currency);
		Result.Insert("CurrencyExchange", Row.CurrencyExchange);
		Result.Insert("PaymentList", New Array());
		
		Filter = New Structure();
		Filter.Insert("BasedOn", Row.BasedOn);
		Filter.Insert("TransactionType", Row.TransactionType);
		Filter.Insert("Company", Row.Company);
		Filter.Insert("Account", Row.Account);
		Filter.Insert("TransitAccount", Row.TransitAccount);
		Filter.Insert("Currency", Row.Currency);
		Filter.Insert("CurrencyExchange", Row.CurrencyExchange);
		
		PaymentList = ValueTable.Copy(Filter);
		For Each RowPaymentList In PaymentList Do
			NewRow = New Structure();
			NewRow.Insert("BasisDocument", RowPaymentList.BasisDocument);
			NewRow.Insert("Agreement", RowPaymentList.Agreement);
			NewRow.Insert("Partner", RowPaymentList.Partner);
			NewRow.Insert("Payer", RowPaymentList.Payer);
			NewRow.Insert("Amount", RowPaymentList.Amount);
			NewRow.Insert("AmountExchange", RowPaymentList.AmountExchange);
			NewRow.Insert("PlaningTransactionBasis", RowPaymentList.PlaningTransactionBasis);
			
			Result.PaymentList.Add(NewRow);
		EndDo;
		ArrayOfResults.Add(Result);
	EndDo;
	Return ArrayOfResults;
EndFunction

Function GetDocumentTable_CashTransferOrder(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	""CashTransferOrder"" AS BasedOn,
		|	CASE
		|		WHEN Doc.SendCurrency = Doc.ReceiveCurrency
		|			THEN VALUE(Enum.IncomingPaymentTransactionType.CashTransferOrder)
		|		ELSE VALUE(Enum.IncomingPaymentTransactionType.CurrencyExchange)
		|	END AS TransactionType,
		|	PlaningCashTransactionsTurnovers.Company AS Company,
		|	PlaningCashTransactionsTurnovers.Account AS Account,
		|	PlaningCashTransactionsTurnovers.Currency AS Currency,
		|	Doc.SendCurrency AS CurrencyExchange,
		|	PlaningCashTransactionsTurnovers.AmountTurnover AS Amount,
		|	PlaningCashTransactionsTurnovers.BasisDocument AS PlaningTransactionBasis
		|INTO tmp_IncomingMoney
		|FROM
		|	AccumulationRegister.PlaningCashTransactions.Turnovers(,,,
		|		CashFlowDirection = VALUE(Enum.CashFlowDirections.Incoming)
		|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
		|	AND BasisDocument IN (&ArrayOfBasisDocuments)) AS PlaningCashTransactionsTurnovers
		|		INNER JOIN Document.CashTransferOrder AS Doc
		|		ON PlaningCashTransactionsTurnovers.BasisDocument = Doc.Ref
		|WHERE
		|	PlaningCashTransactionsTurnovers.Account.Type = VALUE(Enum.CashAccountTypes.Bank)
		|	AND PlaningCashTransactionsTurnovers.AmountTurnover > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	PlaningCashTransactions.Company AS Company,
		|	Doc.SendCurrency AS SendCurrency,
		|	PlaningCashTransactions.BasisDocument AS BasisDocument,
		|	CAST(PlaningCashTransactions.Recorder AS Document.BankPayment).TransitAccount AS TransitAccount,
		|	-SUM(PlaningCashTransactions.Amount) AS Amount
		|INTO tmp_OutgoingMoney
		|FROM
		|	AccumulationRegister.PlaningCashTransactions AS PlaningCashTransactions
		|		INNER JOIN Document.CashTransferOrder AS Doc
		|		ON PlaningCashTransactions.BasisDocument = Doc.Ref
		|		AND PlaningCashTransactions.CashFlowDirection = VALUE(Enum.CashFlowDirections.Outgoing)
		|		AND
		|			PlaningCashTransactions.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
		|		AND PlaningCashTransactions.BasisDocument IN (&ArrayOfBasisDocuments)
		|		AND PlaningCashTransactions.Account.Type = VALUE(Enum.CashAccountTypes.Bank)
		|		AND PlaningCashTransactions.Amount < 0
		|GROUP BY
		|	PlaningCashTransactions.Company,
		|	Doc.SendCurrency,
		|	PlaningCashTransactions.BasisDocument,
		|	CAST(PlaningCashTransactions.Recorder AS Document.BankPayment).TransitAccount
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp_IncomingMoney.BasedOn AS BasedOn,
		|	tmp_IncomingMoney.TransactionType AS TransactionType,
		|	tmp_IncomingMoney.Company AS Company,
		|	tmp_IncomingMoney.Account AS Account,
		|	tmp_IncomingMoney.Currency AS Currency,
		|	tmp_IncomingMoney.CurrencyExchange AS CurrencyExchange,
		|	tmp_IncomingMoney.Amount AS Amount,
		|	tmp_IncomingMoney.PlaningTransactionBasis AS PlaningTransactionBasis,
		|	tmp_OutgoingMoney.TransitAccount AS TransitAccount,
		|	tmp_OutgoingMoney.Amount AS AmountExchange
		|FROM
		|	tmp_IncomingMoney AS tmp_IncomingMoney
		|		LEFT JOIN tmp_OutgoingMoney AS tmp_OutgoingMoney
		|		ON tmp_IncomingMoney.Company = tmp_OutgoingMoney.Company
		|		AND tmp_IncomingMoney.CurrencyExchange = tmp_OutgoingMoney.SendCurrency
		|		AND tmp_IncomingMoney.PlaningTransactionBasis = tmp_OutgoingMoney.BasisDocument";
	Query.SetParameter("ArrayOfBasisDocuments", ArrayOfBasisDocuments);
	QueryResult = Query.Execute();
	
	Result = QueryResult.Unload();
	
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

Function GetDocumentTable_IncomingPaymentOrder(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	""IncomingPaymentOrder"" AS BasedOn,
		|	VALUE(Enum.IncomingPaymentTransactionType.PaymentFromCustomer) AS TransactionType,
		|	PlaningCashTransactionsTurnovers.Company AS Company,
		|	PlaningCashTransactionsTurnovers.Account AS Account,
		|	PlaningCashTransactionsTurnovers.Currency AS Currency,
		|	PlaningCashTransactionsTurnovers.Partner AS Partner,
		|	PlaningCashTransactionsTurnovers.LegalName AS Payer,
		|	PlaningCashTransactionsTurnovers.AmountTurnover AS Amount,
		|	PlaningCashTransactionsTurnovers.BasisDocument AS PlaningTransactionBasis
		|FROM
		|	AccumulationRegister.PlaningCashTransactions.Turnovers(,,,
		|		CashFlowDirection = VALUE(Enum.CashFlowDirections.Incoming)
		|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
		|	AND BasisDocument IN (&ArrayOfBasisDocuments)) AS PlaningCashTransactionsTurnovers
		|WHERE
		|	PlaningCashTransactionsTurnovers.Account.Type = VALUE(Enum.CashAccountTypes.Bank)
		|	AND PlaningCashTransactionsTurnovers.AmountTurnover > 0";
	Query.SetParameter("ArrayOfBasisDocuments", ArrayOfBasisDocuments);
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

Function GetDocumentTable_SalesInvoice(ArrayOfBasisDocuments)
	ArrayOf_ApArPostingDetail_ByDocuments = New Array();
	ArrayOf_ApArPostingDetail_ByAgreements = New Array();
	For Each SalesInvoiceRef In ArrayOfBasisDocuments Do
		If ValueIsFilled(SalesInvoiceRef.Agreement) Then
			If SalesInvoiceRef.Agreement.ApArPostingDetail = Enums.ApArPostingDetail.ByDocuments Then
				ArrayOf_ApArPostingDetail_ByDocuments.Add(SalesInvoiceRef);
			Else
				ArrayOf_ApArPostingDetail_ByAgreements.Add(SalesInvoiceRef.Agreement);
			EndIf;
		EndIf;
	EndDo;
	
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	""SalesInvoice"" AS BasedOn,
		|	VALUE(Enum.IncomingPaymentTransactionType.PaymentFromCustomer) AS TransactionType,
		|	PartnerApTransactionsBalance.Company,
		|	PartnerApTransactionsBalance.Currency,
		|	PartnerApTransactionsBalance.BasisDocument,
		|	PartnerApTransactionsBalance.Agreement,
		|	PartnerApTransactionsBalance.Partner,
		|	PartnerApTransactionsBalance.LegalName AS Payer,
		|	PartnerApTransactionsBalance.AmountBalance AS Amount
		|FROM
		|	AccumulationRegister.PartnerArTransactions.Balance(, BasisDocument IN (&ArrayOf_ApArPostingDetail_ByDocuments)
		|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
		|		PartnerApTransactionsBalance
		|WHERE
		|	PartnerApTransactionsBalance.AmountBalance > 0
		|
		|UNION ALL
		|
		|SELECT
		|	""SalesInvoice"",
		|	VALUE(Enum.IncomingPaymentTransactionType.PaymentFromCustomer),
		|	PartnerApTransactionsBalance.Company,
		|	PartnerApTransactionsBalance.Currency,
		|	UNDEFINED,
		|	PartnerApTransactionsBalance.Agreement,
		|	PartnerApTransactionsBalance.Partner,
		|	PartnerApTransactionsBalance.LegalName,
		|	PartnerApTransactionsBalance.AmountBalance
		|FROM
		|	AccumulationRegister.PartnerArTransactions.Balance(, Agreement IN (&ArrayOf_ApArPostingDetail_ByAgreements)
		|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
		|		PartnerApTransactionsBalance
		|WHERE
		|	PartnerApTransactionsBalance.AmountBalance > 0";
		
	Query.SetParameter("ArrayOf_ApArPostingDetail_ByDocuments", ArrayOf_ApArPostingDetail_ByDocuments);
	Query.SetParameter("ArrayOf_ApArPostingDetail_ByAgreements", ArrayOf_ApArPostingDetail_ByAgreements);
	
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

