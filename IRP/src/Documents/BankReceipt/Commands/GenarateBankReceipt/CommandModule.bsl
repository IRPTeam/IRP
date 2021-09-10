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

&AtServer
Function ErrorMessageStructure(BasisDocuments)
	ErrorMessageStructure = New Structure();

	For Each BasisDocument In BasisDocuments Do
		ErrorMessageKey = ErrorMessageKey(BasisDocument);
		If ValueIsFilled(ErrorMessageKey) Then
			ErrorMessageStructure.Insert(ErrorMessageKey, StrTemplate(R()[ErrorMessageKey],
				Metadata.Documents.BankReceipt.Synonym));
		EndIf;
	EndDo;

	If ErrorMessageStructure.Count() = 1 Then
		ErrorMessageText = ErrorMessageStructure[ErrorMessageKey];
	ElsIf ErrorMessageStructure.Count() = 0 Then
		ErrorMessageText = StrTemplate(R().Error_051, Metadata.Documents.BankReceipt.Synonym);
	Else
		ErrorMessageText = StrTemplate(R().Error_059, Metadata.Documents.BankReceipt.Synonym) + Chars.LF + StrConcat(
			BasisDocuments, Chars.LF);
	EndIf;

	Return ErrorMessageText;
EndFunction

&AtServer
Function ErrorMessageKey(BasisDocument)
	ErrorMessageKey = Undefined;

	If TypeOf(BasisDocument) = Type("DocumentRef.CashTransferOrder") Then
		If Not BasisDocument.Receiver.Type = PredefinedValue("Enum.CashAccountTypes.Bank") Then
			ErrorMessageKey = "Error_057";
		Else
			ErrorMessageKey = "Error_060";
		EndIf;
	EndIf;

	Return ErrorMessageKey;
EndFunction

&AtServer
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

&AtServer
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
	ValueTable.Columns.Add("PlaningTransactionBasis",
		New TypeDescription(Metadata.DefinedTypes.typePlaningTransactionBasises.Type));
	ValueTable.Columns.Add("TransitAccount", New TypeDescription("CatalogRef.CashAccounts"));
	ValueTable.Columns.Add("AmountExchange", New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ValueTable.Columns.Add("FinancialMovementType", New TypeDescription("CatalogRef.ExpenseAndRevenueTypes"));

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
			NewRow.Insert("FinancialMovementType", RowPaymentList.FinancialMovementType);

			Result.PaymentList.Add(NewRow);
		EndDo;
		ArrayOfResults.Add(Result);
	EndDo;
	Return ArrayOfResults;
EndFunction

&AtServer
Function GetDocumentTable_CashTransferOrder(ArrayOfBasisDocuments)
	Result = DocBankReceiptServer.GetDocumentTable_CashTransferOrder(ArrayOfBasisDocuments);

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

&AtServer
Function GetDocumentTable_IncomingPaymentOrder(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
	"SELECT ALLOWED
	|	""IncomingPaymentOrder"" AS BasedOn,
	|	VALUE(Enum.IncomingPaymentTransactionType.PaymentFromCustomer) AS TransactionType,
	|	R3035T_CashPlanningTurnovers.FinancialMovementType AS FinancialMovementType,
	|	R3035T_CashPlanningTurnovers.Company AS Company,
	|	R3035T_CashPlanningTurnovers.Account AS Account,
	|	R3035T_CashPlanningTurnovers.Currency AS Currency,
	|	R3035T_CashPlanningTurnovers.Partner AS Partner,
	|	R3035T_CashPlanningTurnovers.LegalName AS Payer,
	|	R3035T_CashPlanningTurnovers.AmountTurnover AS Amount,
	|	R3035T_CashPlanningTurnovers.BasisDocument AS PlaningTransactionBasis
	|FROM
	|	AccumulationRegister.R3035T_CashPlanning.Turnovers(,,, CashFlowDirection = VALUE(Enum.CashFlowDirections.Incoming)
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND BasisDocument IN (&ArrayOfBasisDocuments)) AS R3035T_CashPlanningTurnovers
	|WHERE
	|	R3035T_CashPlanningTurnovers.Account.Type = VALUE(Enum.CashAccountTypes.Bank)
	|	AND R3035T_CashPlanningTurnovers.AmountTurnover > 0";
	Query.SetParameter("ArrayOfBasisDocuments", ArrayOfBasisDocuments);
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

&AtServer
Function GetDocumentTable_SalesInvoice(ArrayOfBasisDocuments)

	Return DocumentsGenerationServer.GetDocumentTable_SalesInvoice_ForReceipt(ArrayOfBasisDocuments);

EndFunction