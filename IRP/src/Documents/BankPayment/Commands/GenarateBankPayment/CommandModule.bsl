&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	GenerateDocument(CommandParameter);
EndProcedure

&AtClient
Procedure GenerateDocument(ArrayOfBasisDocuments)
	DocumentStructure = GetDocumentsStructure(ArrayOfBasisDocuments);

	For Each FillingData In DocumentStructure Do
		OpenForm("Document.BankPayment.ObjectForm", New Structure("FillingValues", FillingData), , New UUID());
	EndDo;
EndProcedure

&AtServer
Function ErrorMessageStructure(BasisDocuments)
	ErrorMessageStructure = New Structure();

	For Each BasisDocument In BasisDocuments Do
		ErrorMessageKey = ErrorMessageKey(BasisDocument);
		If ValueIsFilled(ErrorMessageKey) Then
			ErrorMessageStructure.Insert(ErrorMessageKey, StrTemplate(R()[ErrorMessageKey],
				Metadata.Documents.BankPayment.Synonym));
		EndIf;
	EndDo;

	If ErrorMessageStructure.Count() = 1 Then
		ErrorMessageText = ErrorMessageStructure[ErrorMessageKey];
	ElsIf ErrorMessageStructure.Count() = 0 Then
		ErrorMessageText = StrTemplate(R().Error_051, Metadata.Documents.BankPayment.Synonym);
	Else
		ErrorMessageText = StrTemplate(R().Error_059, Metadata.Documents.BankPayment.Synonym) + Chars.LF + StrConcat(
			BasisDocuments, Chars.LF);
	EndIf;

	Return ErrorMessageText;
EndFunction

&AtServer
Function ErrorMessageKey(BasisDocument)
	ErrorMessageKey = Undefined;

	If TypeOf(BasisDocument) = Type("DocumentRef.CashTransferOrder") Then
		If Not BasisDocument.Sender.Type = PredefinedValue("Enum.CashAccountTypes.Bank") Then
			ErrorMessageKey = "Error_057";
		Else
			ErrorMessageKey = "Error_058";
		EndIf;
	EndIf;

	Return ErrorMessageKey;
EndFunction

&AtServer
Function GetDocumentsStructure(ArrayOfBasisDocuments)
	ArrayOf_CashTransferOrder      = New Array();
	ArrayOf_OutgoingPaymentOrder   = New Array();
	ArrayOf_PurchaseInvoice        = New Array();
	ArrayOf_PurchaseOrder          = New Array();
	ArrayOf_SalesReturn            = New Array();
	ArrayOf_SalesReportToConsignor = New Array();
	ArrayOf_EmployeeCashAdvance    = New Array();
	
	For Each Row In ArrayOfBasisDocuments Do

		If TypeOf(Row) = Type("DocumentRef.CashTransferOrder") Then
			ArrayOf_CashTransferOrder.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.OutgoingPaymentOrder") Then
			ArrayOf_OutgoingPaymentOrder.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.PurchaseInvoice") Then
			ArrayOf_PurchaseInvoice.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.PurchaseOrder") Then
			ArrayOf_PurchaseOrder.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.SalesReturn") Then
			ArrayOf_SalesReturn.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.SalesReportToConsignor") Then
			ArrayOf_SalesReportToConsignor.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.EmployeeCashAdvance") Then
			ArrayOf_EmployeeCashAdvance.Add(Row);
		Else
			Raise R().Error_043;
		EndIf;

	EndDo;

	ArrayOfTables = New Array();
	ArrayOfTables.Add(GetDocumentTable_CashTransferOrder(ArrayOf_CashTransferOrder));
	ArrayOfTables.Add(GetDocumentTable_OutgoingPaymentOrder(ArrayOf_OutgoingPaymentOrder));
	ArrayOfTables.Add(GetDocumentTable_PurchaseInvoice(ArrayOf_PurchaseInvoice));
	ArrayOfTables.Add(GetDocumentTable_PurchaseOrder(ArrayOf_PurchaseOrder));
	ArrayOfTables.Add(GetDocumentTable_SalesReturn(ArrayOf_SalesReturn));
	ArrayOfTables.Add(GetDocumentTable_SalesReportToConsignor(ArrayOf_SalesReportToConsignor));
	ArrayOfTables.Add(GetDocumentTable_EmployeeCashAdvance(ArrayOf_EmployeeCashAdvance));
	
	Return JoinDocumentsStructure(ArrayOfTables);
EndFunction

&AtServer
Function JoinDocumentsStructure(ArrayOfTables)

	ValueTable = New ValueTable();
	ValueTable.Columns.Add("BasedOn"         , New TypeDescription("String"));
	ValueTable.Columns.Add("Company"         , New TypeDescription("CatalogRef.Companies"));
	ValueTable.Columns.Add("Branch"          , New TypeDescription("CatalogRef.BusinessUnits"));
	ValueTable.Columns.Add("Account"         , New TypeDescription("CatalogRef.CashAccounts"));
	ValueTable.Columns.Add("Currency"        , New TypeDescription("CatalogRef.Currencies"));
	ValueTable.Columns.Add("TransactionType" , New TypeDescription("EnumRef.OutgoingPaymentTransactionTypes"));
	ValueTable.Columns.Add("TransitAccount"  , New TypeDescription("CatalogRef.CashAccounts"));
	ValueTable.Columns.Add("BasisDocument"   , New TypeDescription(Metadata.DefinedTypes.typeApTransactionBasises.Type));
	ValueTable.Columns.Add("Agreement"       , New TypeDescription("CatalogRef.Agreements"));
	ValueTable.Columns.Add("Partner"         , New TypeDescription("CatalogRef.Partners"));
	ValueTable.Columns.Add("Amount"          , New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ValueTable.Columns.Add("Payee"           , New TypeDescription("CatalogRef.Companies"));
	ValueTable.Columns.Add("PlaningTransactionBasis",
		New TypeDescription(Metadata.DefinedTypes.typePlaningTransactionBasises.Type));
	ValueTable.Columns.Add("FinancialMovementType", New TypeDescription("CatalogRef.ExpenseAndRevenueTypes"));
	ValueTable.Columns.Add("Order", New TypeDescription("DocumentRef.PurchaseOrder"));
	
	For Each Table In ArrayOfTables Do
		For Each Row In Table Do
			FillPropertyValues(ValueTable.Add(), Row);
		EndDo;
	EndDo;

	ValueTableCopy = ValueTable.Copy();
	ValueTableCopy.GroupBy("BasedOn, TransactionType, Company, Branch, Account, Currency, TransitAccount");

	ArrayOfResults = New Array();

	For Each Row In ValueTableCopy Do
		Result = New Structure();
		Result.Insert("BasedOn"        , Row.BasedOn);
		Result.Insert("TransactionType", Row.TransactionType);
		Result.Insert("Company"        , Row.Company);
		Result.Insert("Branch"         , Row.Branch);
		Result.Insert("Account"        , Row.Account);
		Result.Insert("Currency"       , Row.Currency);
		Result.Insert("TransitAccount" , Row.TransitAccount);
		Result.Insert("PaymentList"    , New Array());

		Filter = New Structure();
		Filter.Insert("BasedOn"        , Row.BasedOn);
		Filter.Insert("TransactionType", Row.TransactionType);
		Filter.Insert("Company"        , Row.Company);
		Filter.Insert("Branch"         , Row.Branch);
		Filter.Insert("Account"        , Row.Account);
		Filter.Insert("Currency"       , Row.Currency);

		PaymentList = ValueTable.Copy(Filter);
		For Each RowPaymentList In PaymentList Do
			NewRow = New Structure();
			NewRow.Insert("BasisDocument"           , RowPaymentList.BasisDocument);
			NewRow.Insert("Agreement"               , RowPaymentList.Agreement);
			NewRow.Insert("Partner"                 , RowPaymentList.Partner);
			NewRow.Insert("Payee"                   , RowPaymentList.Payee);
			NewRow.Insert("TotalAmount"             , RowPaymentList.Amount);
			NewRow.Insert("PlaningTransactionBasis" , RowPaymentList.PlaningTransactionBasis);
			NewRow.Insert("FinancialMovementType"   , RowPaymentList.FinancialMovementType);
			NewRow.Insert("Order"                   , RowPaymentList.Order);
			Result.PaymentList.Add(NewRow);
		EndDo;
		ArrayOfResults.Add(Result);
	EndDo;
	Return ArrayOfResults;
EndFunction

&AtServer
Function GetDocumentTable_CashTransferOrder(ArrayOfBasisDocuments)

	Result = DocBankPaymentServer.GetDocumentTable_CashTransferOrder(ArrayOfBasisDocuments);

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
Function GetDocumentTable_OutgoingPaymentOrder(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
	"SELECT ALLOWED
	|	""OutgoingPaymentOrder"" AS BasedOn,
	|	R3035T_CashPlanningTurnovers.BasisDocument.TransactionType AS TransactionType,
	|	R3035T_CashPlanningTurnovers.FinancialMovementType AS FinancialMovementType,
	|	R3035T_CashPlanningTurnovers.Company AS Company,
	|	R3035T_CashPlanningTurnovers.Branch AS Branch,
	|	R3035T_CashPlanningTurnovers.Account AS Account,
	|	R3035T_CashPlanningTurnovers.Currency AS Currency,
	|	R3035T_CashPlanningTurnovers.Partner AS Partner,
	|	R3035T_CashPlanningTurnovers.LegalName AS Payee,
	|	R3035T_CashPlanningTurnovers.AmountTurnover AS Amount,
	|	R3035T_CashPlanningTurnovers.BasisDocument AS PlaningTransactionBasis
	|FROM
	|	AccumulationRegister.R3035T_CashPlanning.Turnovers(, , , CashFlowDirection = VALUE(Enum.CashFlowDirections.Outgoing)
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND BasisDocument IN (&ArrayOfBasisDocuments)) AS R3035T_CashPlanningTurnovers
	|WHERE
	|	R3035T_CashPlanningTurnovers.Account.Type = VALUE(Enum.CashAccountTypes.Bank)
	|	AND R3035T_CashPlanningTurnovers.AmountTurnover > 0";
	Query.SetParameter("ArrayOfBasisDocuments", ArrayOfBasisDocuments);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

&AtServer
Function GetDocumentTable_EmployeeCashAdvance(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
	"SELECT
	|	TableBasisDocument.Company,
	|	TableBasisDocument.Branch,
	|	TableBasisDocument.Account,
	|	TableBasisDocument.Currency,
	|	TableBasisDocument.Partner,
	|	TableBasisDocument.FinancialMovementType,
	|	TableBasisDocument.PlaningTransactionBasis,
	|	TableBasisDocument.BasisDocument
	|INTO TableBasisDocument
	|FROM
	|	&TableBasisDocument AS TableBasisDocument
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT ALLOWED
	|	""EmployeeCashAdvance"" AS BasedOn,
	|	VALUE(Enum.OutgoingPaymentTransactionTypes.EmployeeCashAdvance) AS TransactionType,
	|	R3027B_EmployeeCashAdvanceBalance.Company,
	|	R3027B_EmployeeCashAdvanceBalance.Branch,
	|	R3027B_EmployeeCashAdvanceBalance.Account,
	|	R3027B_EmployeeCashAdvanceBalance.Currency,
	|	R3027B_EmployeeCashAdvanceBalance.Partner,
	|	R3027B_EmployeeCashAdvanceBalance.FinancialMovementType,
	|	R3027B_EmployeeCashAdvanceBalance.PlaningTransactionBasis,
	|	-R3027B_EmployeeCashAdvanceBalance.AmountBalance AS Amount,
	|	TableBasisDocument.BasisDocument
	|FROM
	|	AccumulationRegister.R3027B_EmployeeCashAdvance.Balance(, (Company, Branch, Account, Currency, Partner,
	|		FinancialMovementType, PlaningTransactionBasis) IN
	|		(SELECT
	|			TableBasisDocument.Company,
	|			TableBasisDocument.Branch,
	|			TableBasisDocument.Account,
	|			TableBasisDocument.Currency,
	|			TableBasisDocument.Partner,
	|			TableBasisDocument.FinancialMovementType,
	|			TableBasisDocument.PlaningTransactionBasis
	|		FROM
	|			TableBasisDocument AS TableBasisDocument)
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND Account.Type = VALUE(Enum.CashAccountTypes.Bank)) AS R3027B_EmployeeCashAdvanceBalance
	|		INNER JOIN TableBasisDocument AS TableBasisDocument
	|		ON TableBasisDocument.Company = R3027B_EmployeeCashAdvanceBalance.Company
	|		AND TableBasisDocument.Branch = R3027B_EmployeeCashAdvanceBalance.Branch
	|		AND TableBasisDocument.Account = R3027B_EmployeeCashAdvanceBalance.Account
	|		AND TableBasisDocument.Currency = R3027B_EmployeeCashAdvanceBalance.Currency
	|		AND TableBasisDocument.Partner = R3027B_EmployeeCashAdvanceBalance.Partner
	|		AND TableBasisDocument.FinancialMovementType = R3027B_EmployeeCashAdvanceBalance.FinancialMovementType
	|		AND TableBasisDocument.PlaningTransactionBasis = R3027B_EmployeeCashAdvanceBalance.PlaningTransactionBasis
	|WHERE
	|	R3027B_EmployeeCashAdvanceBalance.AmountBalance < 0";
	
	AccReg = Metadata.AccumulationRegisters.R3027B_EmployeeCashAdvance.Dimensions;
	TableBasisDocument = New ValueTable();
	TableBasisDocument.Columns.Add("Company"  , AccReg.Company.Type);
	TableBasisDocument.Columns.Add("Branch"   , AccReg.Branch.Type);
	TableBasisDocument.Columns.Add("Account"  , AccReg.Account.Type);
	TableBasisDocument.Columns.Add("Currency" , AccReg.Currency.Type);
	TableBasisDocument.Columns.Add("Partner"  , AccReg.Partner.Type);
	TableBasisDocument.Columns.Add("FinancialMovementType"  , AccReg.FinancialMovementType.Type);
	TableBasisDocument.Columns.Add("PlaningTransactionBasis", AccReg.PlaningTransactionBasis.Type);
	TableBasisDocument.Columns.Add("BasisDocument"          , New TypeDescription("DocumentRef.EmployeeCashAdvance"));
		
	For Each Basis In ArrayOfBasisDocuments Do
		For Each Row In Basis.PaymentList Do
			NewRow = TableBasisDocument.Add();
			NewRow.Company  = Basis.Company;
			NewRow.Branch   = Basis.Branch;
			NewRow.Account  = Row.Account;
			NewRow.Currency = Row.Currency;
			NewRow.Partner  = Basis.Partner;
			NewRow.FinancialMovementType   = Row.FinancialMovementType;
			NewRow.PlaningTransactionBasis = Row.PlaningTransactionBasis;
			NewRow.BasisDocument = Basis;
		EndDo;
	EndDo;
	
	Query.SetParameter("TableBasisDocument", TableBasisDocument);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

&AtServer
Function GetDocumentTable_PurchaseInvoice(ArrayOfBasisDocuments)
	Return DocumentsGenerationServer.GetDocumentTable_PurchaseDocument_ForPayment(ArrayOfBasisDocuments, "PurchaseInvoice");
EndFunction

&AtServer
Function GetDocumentTable_PurchaseOrder(ArrayOfBasisDocuments)
	Return DocumentsGenerationServer.GetDocumentTable_PurchaseOrder_ForPayment(ArrayOfBasisDocuments);
EndFunction

&AtServer
Function GetDocumentTable_SalesReturn(ArrayOfBasisDocuments)
	Return DocumentsGenerationServer.GetDocumentTable_SalesReturn_ForPayment(ArrayOfBasisDocuments);
EndFunction

&AtServer
Function GetDocumentTable_SalesReportToConsignor(ArrayOfBasisDocuments)
	Return DocumentsGenerationServer.GetDocumentTable_PurchaseDocument_ForPayment(ArrayOfBasisDocuments, "SalesReportToConsignor");
EndFunction
