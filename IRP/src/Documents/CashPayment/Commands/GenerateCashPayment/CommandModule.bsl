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

&AtServer
Function ErrorMessageStructure(BasisDocuments)
	ErrorMessageStructure = New Structure();

	For Each BasisDocument In BasisDocuments Do
		ErrorMessageKey = ErrorMessageKey(BasisDocument);
		If ValueIsFilled(ErrorMessageKey) Then
			ErrorMessageStructure.Insert(ErrorMessageKey, StrTemplate(R()[ErrorMessageKey],
				Metadata.Documents.CashPayment.Synonym));
		EndIf;
	EndDo;

	If ErrorMessageStructure.Count() = 1 Then
		ErrorMessageText = ErrorMessageStructure[ErrorMessageKey];
	ElsIf ErrorMessageStructure.Count() = 0 Then
		ErrorMessageText = StrTemplate(R().Error_051, Metadata.Documents.CashPayment.Synonym);
	Else
		ErrorMessageText = StrTemplate(R().Error_059, Metadata.Documents.CashPayment.Synonym) + Chars.LF + StrConcat(
			BasisDocuments, Chars.LF);
	EndIf;

	Return ErrorMessageText;
EndFunction

&AtServer
Function ErrorMessageKey(BasisDocument)
	ErrorMessageKey = Undefined;

	If TypeOf(BasisDocument) = Type("DocumentRef.CashTransferOrder") Then
		If Not BasisDocument.Sender.Type = PredefinedValue("Enum.CashAccountTypes.Cash") Then
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
	
	DocumentAmountTable = DocumentsGenerationServer.CreateDocumentAmountTable();
	DocumentsGenerationServer.FillDocumentAmountTable(DocumentAmountTable, ArrayOf_PurchaseInvoice, "PurchaseOrder");
	DocumentsGenerationServer.FillDocumentAmountTable(DocumentAmountTable, ArrayOf_SalesReturn);
	
	Return JoinDocumentsStructure(ArrayOfTables, DocumentAmountTable);
EndFunction

&AtServer
Function JoinDocumentsStructure(ArrayOfTables, DocumentAmountTable)

	ValueTable = New ValueTable();
	ValueTable.Columns.Add("BasedOn"         , New TypeDescription("String"));
	ValueTable.Columns.Add("Company"         , New TypeDescription("CatalogRef.Companies"));
	ValueTable.Columns.Add("Branch"          , New TypeDescription("CatalogRef.BusinessUnits"));
	ValueTable.Columns.Add("CashAccount"     , New TypeDescription("CatalogRef.CashAccounts"));
	ValueTable.Columns.Add("Currency"        , New TypeDescription("CatalogRef.Currencies"));
	ValueTable.Columns.Add("TransactionType" , New TypeDescription("EnumRef.OutgoingPaymentTransactionTypes"));
	ValueTable.Columns.Add("BasisDocument"   , New TypeDescription(Metadata.DefinedTypes.typeApTransactionBasises.Type));
	ValueTable.Columns.Add("Agreement"       , New TypeDescription("CatalogRef.Agreements"));
	ValueTable.Columns.Add("Partner"         , New TypeDescription("CatalogRef.Partners"));
	ValueTable.Columns.Add("Amount"          , New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ValueTable.Columns.Add("NetAmount"       , New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ValueTable.Columns.Add("Payee"           , New TypeDescription("CatalogRef.Companies"));
	ValueTable.Columns.Add("PlaningTransactionBasis",
		New TypeDescription(Metadata.DefinedTypes.typePlaningTransactionBasises.Type));
	ValueTable.Columns.Add("FinancialMovementType", New TypeDescription("CatalogRef.ExpenseAndRevenueTypes"));
	ValueTable.Columns.Add("Order", New TypeDescription("DocumentRef.PurchaseOrder"));
	ValueTable.Columns.Add("Project", New TypeDescription("CatalogRef.Projects"));
	
	For Each Table In ArrayOfTables Do
		For Each Row In Table Do
			NewRow = ValueTable.Add();
			FillPropertyValues(NewRow, Row);
			If Not ValueIsFilled(NewRow.NetAmount) Then
				NewRow.NetAmount = NewRow.Amount;
			EndIf;
		EndDo;
	EndDo;

	ValueTableCopy = ValueTable.Copy();
	ValueTableCopy.GroupBy("BasedOn, TransactionType, Company, Branch, CashAccount, Currency");

	ArrayOfResults = New Array();

	For Each Row In ValueTableCopy Do
		Result = New Structure();
		Result.Insert("BasedOn"         , Row.BasedOn);
		Result.Insert("TransactionType" , Row.TransactionType);
		Result.Insert("Company"         , Row.Company);
		Result.Insert("Branch"          , Row.Branch);
		Result.Insert("CashAccount"     , Row.CashAccount);
		Result.Insert("Currency"        , Row.Currency);
		Result.Insert("PaymentList"     , New Array());

		Filter = New Structure();
		Filter.Insert("BasedOn"         , Row.BasedOn);
		Filter.Insert("TransactionType" , Row.TransactionType);
		Filter.Insert("Company"         , Row.Company);
		Filter.Insert("Branch"          , Row.Branch);
		Filter.Insert("CashAccount"     , Row.CashAccount);
		Filter.Insert("Currency"        , Row.Currency);

		PaymentList = ValueTable.Copy(Filter);
		For Each RowPaymentList In PaymentList Do
			
			FilterAmount = New Structure();
			FilterAmount.Insert("Company"  , Row.Company);
			FilterAmount.Insert("Branch"   , Row.Branch);
			FilterAmount.Insert("Currency" , Row.Currency);
			FilterAmount.Insert("Partner"  , RowPaymentList.Partner);
			FilterAmount.Insert("LegalName", RowPaymentList.Payee);
			FilterAmount.Insert("Agreement", RowPaymentList.Agreement);
			FilterAmount.Insert("Order"    , ?(ValueIsFilled(RowPaymentList.Order), RowPaymentList.Order, Undefined));
			FilterAmount.Insert("Project"  , RowPaymentList.Project);
			
			Amounts = DocumentsGenerationServer.CalculateDocumentAmount(DocumentAmountTable, FilterAmount, RowPaymentList.NetAmount, RowPaymentList.Amount);
			
			If Amounts.Skip Then
				Continue;
			EndIf;
			
			NewRow = New Structure();
			NewRow.Insert("BasisDocument"           , RowPaymentList.BasisDocument);
			NewRow.Insert("Agreement"               , RowPaymentList.Agreement);
			NewRow.Insert("Partner"                 , RowPaymentList.Partner);
			NewRow.Insert("Payee"                   , RowPaymentList.Payee);
			NewRow.Insert("TotalAmount"             , Amounts.TotalAmount);
			NewRow.Insert("NetAmount"               , Amounts.NetAmount);
			NewRow.Insert("PlaningTransactionBasis" , RowPaymentList.PlaningTransactionBasis);
			NewRow.Insert("FinancialMovementType"   , RowPaymentList.FinancialMovementType);
			NewRow.Insert("Order"                   , RowPaymentList.Order);
			NewRow.Insert("Project"                 , RowPaymentList.Project);
			Result.PaymentList.Add(NewRow);
		EndDo;
		ArrayOfResults.Add(Result);
	EndDo;
	Return ArrayOfResults;
EndFunction

&AtServer
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
	|	R3035T_CashPlanningTurnovers.Account AS CashAccount,
	|	R3035T_CashPlanningTurnovers.Currency AS Currency,
	|	R3035T_CashPlanningTurnovers.Partner AS Partner,
	|	R3035T_CashPlanningTurnovers.LegalName AS Payee,
	|	R3035T_CashPlanningTurnovers.AmountTurnover AS Amount,
	|	R3035T_CashPlanningTurnovers.BasisDocument AS PlaningTransactionBasis
	|FROM
	|	AccumulationRegister.R3035T_CashPlanning.Turnovers(, , , 
	|		CashFlowDirection = VALUE(Enum.CashFlowDirections.Outgoing)
	|		AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|		AND BasisDocument IN (&ArrayOfBasisDocuments)
	|		AND Account.Type = VALUE(Enum.CashAccountTypes.Cash)	
	|	) AS R3035T_CashPlanningTurnovers
	|WHERE
	|	R3035T_CashPlanningTurnovers.AmountTurnover > 0";
	Query.SetParameter("ArrayOfBasisDocuments", ArrayOfBasisDocuments);
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

&AtServer
Function GetDocumentTable_EmployeeCashAdvance(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
	"SELECT
	|	TableBasisDocument.Company,
	|	TableBasisDocument.Branch,
	|	TableBasisDocument.Currency,
	|	TableBasisDocument.Partner,
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
	|	R3027B_EmployeeCashAdvanceBalance.Currency,
	|	R3027B_EmployeeCashAdvanceBalance.Partner,
	|	-R3027B_EmployeeCashAdvanceBalance.AmountBalance AS Amount,
	|	TableBasisDocument.BasisDocument
	|FROM
	|	AccumulationRegister.R3027B_EmployeeCashAdvance.Balance(, (Company, Branch, Currency, Partner) IN
	|		(SELECT
	|			TableBasisDocument.Company,
	|			TableBasisDocument.Branch,
	|			TableBasisDocument.Currency,
	|			TableBasisDocument.Partner
	|		FROM
	|			TableBasisDocument AS TableBasisDocument)
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
	|		R3027B_EmployeeCashAdvanceBalance
	|		INNER JOIN TableBasisDocument AS TableBasisDocument
	|		ON TableBasisDocument.Company = R3027B_EmployeeCashAdvanceBalance.Company
	|		AND TableBasisDocument.Branch = R3027B_EmployeeCashAdvanceBalance.Branch
	|		AND TableBasisDocument.Currency = R3027B_EmployeeCashAdvanceBalance.Currency
	|		AND TableBasisDocument.Partner = R3027B_EmployeeCashAdvanceBalance.Partner
	|WHERE
	|	R3027B_EmployeeCashAdvanceBalance.AmountBalance < 0";
	
	AccReg = Metadata.AccumulationRegisters.R3027B_EmployeeCashAdvance.Dimensions;
	TableBasisDocument = New ValueTable();
	TableBasisDocument.Columns.Add("Company"  , AccReg.Company.Type);
	TableBasisDocument.Columns.Add("Branch"   , AccReg.Branch.Type);
	TableBasisDocument.Columns.Add("Currency" , AccReg.Currency.Type);
	TableBasisDocument.Columns.Add("Partner"  , AccReg.Partner.Type);
	TableBasisDocument.Columns.Add("BasisDocument"          , New TypeDescription("DocumentRef.EmployeeCashAdvance"));
		
	For Each Basis In ArrayOfBasisDocuments Do
		For Each Row In Basis.PaymentList Do
			NewRow = TableBasisDocument.Add();
			NewRow.Company  = Basis.Company;
			NewRow.Branch   = Basis.Branch;
			NewRow.Currency = Row.Currency;
			NewRow.Partner  = Basis.Partner;
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

