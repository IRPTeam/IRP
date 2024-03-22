#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	MoneyDocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	MoneyDocumentsServer.OnReadAtServer(Object, Form, CurrentObject);
	LockDataModificationPrivileged.LockFormIfObjectIsLocked(Form, CurrentObject);
	AccountingServer.OnReadAtServer(Object, Form, CurrentObject);
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	MoneyDocumentsServer.AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters);
	AccountingServer.AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters);
EndProcedure

#EndRegion

#Region Public

Function GetDocumentTable_CashTransferOrder(ArrayOfBasisDocuments, EndOfDate = Undefined) Export
	TempTableManager = New TempTablesManager();
	Query = New Query();
	Query.TempTablesManager = TempTableManager;
	Query.Text = GetDocumentTable_CashTransferOrder_QueryText();
	Query.SetParameter("ArrayOfBasisDocuments", ArrayOfBasisDocuments);
	Query.SetParameter("UseArrayOfBasisDocuments", True);
	If EndOfDate = Undefined Then
		Query.SetParameter("EndOfDate", CommonFunctionsServer.GetCurrentSessionDate());
	Else
		Query.SetParameter("EndOfDate", EndOfDate);
	EndIf;

	Query.Execute();
	Query.Text =
	"SELECT
	|	tmp.BasedOn AS BasedOn,
	|	tmp.TransactionType AS TransactionType,
	|	tmp.Company AS Company,
	|	tmp.Branch AS Branch,
	|	tmp.Account AS Account,
	|	tmp.Currency AS Currency,
	|	tmp.FinancialMovementType AS FinancialMovementType,
	|	tmp.CurrencyExchange AS CurrencyExchange,
	|	tmp.Amount AS Amount,
	|	tmp.PlaningTransactionBasis AS PlaningTransactionBasis,
	|	tmp.TransitAccount AS TransitAccount,
	|	tmp.AmountExchange AS AmountExchange
	|FROM
	|	tmp_CashTransferOrder AS tmp";
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

Function GetDocumentTable_CashTransferOrder_QueryText() Export
	Return "SELECT ALLOWED
		   |	""CashTransferOrder"" AS BasedOn,
		   |	CASE
		   |		WHEN Doc.SendCurrency = Doc.ReceiveCurrency
		   |			THEN VALUE(Enum.IncomingPaymentTransactionType.CashTransferOrder)
		   |		ELSE VALUE(Enum.IncomingPaymentTransactionType.CurrencyExchange)
		   |	END AS TransactionType,
		   |	R3035T_CashPlanningTurnovers.Company AS Company,
		   |	R3035T_CashPlanningTurnovers.Branch AS Branch,
		   |	R3035T_CashPlanningTurnovers.Account AS Account,
		   |	R3035T_CashPlanningTurnovers.Currency AS Currency,
		   |	R3035T_CashPlanningTurnovers.FinancialMovementType AS FinancialMovementType,
		   |	Doc.SendCurrency AS CurrencyExchange,
		   |	CashInTransitBalance.AmountBalance AS Amount,
		   |	R3035T_CashPlanningTurnovers.BasisDocument AS PlaningTransactionBasis
		   |INTO tmp_IncomingMoney
		   |FROM
		   |	AccumulationRegister.R3035T_CashPlanning.Turnovers(, &EndOfDate, ,
		   |		CashFlowDirection = VALUE(Enum.CashFlowDirections.Incoming)
		   |			AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
		   |			AND Account.Type = VALUE(Enum.CashAccountTypes.Bank)
		   |			AND CASE
		   |				WHEN &UseArrayOfBasisDocuments
		   |					THEN BasisDocument IN (&ArrayOfBasisDocuments)
		   |				ELSE TRUE
		   |			END) AS R3035T_CashPlanningTurnovers
		   |		INNER JOIN Document.CashTransferOrder AS Doc
		   |		ON R3035T_CashPlanningTurnovers.BasisDocument = Doc.Ref
		   |		LEFT JOIN AccumulationRegister.CashInTransit.Balance(&EndOfDate,
		   |			CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
		   |		AND CASE
		   |			WHEN &UseArrayOfBasisDocuments
		   |				THEN BasisDocument IN (&ArrayOfBasisDocuments)
		   |			ELSE TRUE
		   |		END) AS CashInTransitBalance
		   |		ON R3035T_CashPlanningTurnovers.BasisDocument = CashInTransitBalance.BasisDocument
		   |WHERE
		   |	R3035T_CashPlanningTurnovers.AmountTurnover > 0
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	R3035T_CashPlanning.Company AS Company,
		   |	R3035T_CashPlanning.Branch AS Branch,
		   |	Doc.SendCurrency AS SendCurrency,
		   |	R3035T_CashPlanning.BasisDocument AS BasisDocument,
		   |	CAST(R3035T_CashPlanning.Recorder AS Document.BankPayment).TransitAccount AS TransitAccount,
		   |	-SUM(R3035T_CashPlanning.Amount) AS Amount
		   |INTO tmp_OutgoingMoney
		   |FROM
		   |	AccumulationRegister.R3035T_CashPlanning AS R3035T_CashPlanning
		   |		INNER JOIN Document.CashTransferOrder AS Doc
		   |		ON R3035T_CashPlanning.BasisDocument = Doc.Ref
		   |		AND R3035T_CashPlanning.CashFlowDirection = VALUE(Enum.CashFlowDirections.Outgoing)
		   |		AND
		   |			R3035T_CashPlanning.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
		   |		AND CASE
		   |			WHEN &UseArrayOfBasisDocuments
		   |				THEN R3035T_CashPlanning.BasisDocument IN (&ArrayOfBasisDocuments)
		   |			ELSE TRUE
		   |		END
		   |		AND R3035T_CashPlanning.Account.Type = VALUE(Enum.CashAccountTypes.Bank)
		   |		AND R3035T_CashPlanning.Amount < 0
		   |GROUP BY
		   |	R3035T_CashPlanning.Company,
		   |	R3035T_CashPlanning.Branch,
		   |	Doc.SendCurrency,
		   |	R3035T_CashPlanning.BasisDocument,
		   |	CAST(R3035T_CashPlanning.Recorder AS Document.BankPayment).TransitAccount
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	tmp_IncomingMoney.BasedOn AS BasedOn,
		   |	tmp_IncomingMoney.TransactionType AS TransactionType,
		   |	tmp_IncomingMoney.Company AS Company,
		   |	tmp_IncomingMoney.Branch AS Branch,
		   |	tmp_IncomingMoney.Account AS Account,
		   |	tmp_IncomingMoney.Currency AS Currency,
		   |	tmp_IncomingMoney.FinancialMovementType AS FinancialMovementType,
		   |	tmp_IncomingMoney.CurrencyExchange AS CurrencyExchange,
		   |	tmp_IncomingMoney.Amount AS Amount,
		   |	tmp_IncomingMoney.PlaningTransactionBasis AS PlaningTransactionBasis,
		   |	tmp_OutgoingMoney.TransitAccount AS TransitAccount,
		   |	tmp_OutgoingMoney.Amount AS AmountExchange
		   |INTO tmp_CashTransferOrder
		   |FROM
		   |	tmp_IncomingMoney AS tmp_IncomingMoney
		   |		LEFT JOIN tmp_OutgoingMoney AS tmp_OutgoingMoney
		   |		ON tmp_IncomingMoney.Company = tmp_OutgoingMoney.Company
		   |		AND tmp_IncomingMoney.Branch = tmp_OutgoingMoney.Branch
		   |		AND tmp_IncomingMoney.CurrencyExchange = tmp_OutgoingMoney.SendCurrency
		   |		AND tmp_IncomingMoney.PlaningTransactionBasis = tmp_OutgoingMoney.BasisDocument";
EndFunction

Function GetDocumentTable_CashTransferOrder_ForClient(ArrayOfBasisDocuments, ObjectRef = Undefined) Export
	EndOfDate = Undefined;
	If ValueIsFilled(ObjectRef) Then
		EndOfDate = New Boundary(ObjectRef.PointInTime(), BoundaryType.Excluding);
	EndIf;
	ArrayOfResults = New Array();
	ValueTable = GetDocumentTable_CashTransferOrder(ArrayOfBasisDocuments, EndOfDate);
	For Each Row In ValueTable Do
		NewRow = New Structure();
		NewRow.Insert("BasedOn"                 , Row.BasedOn);
		NewRow.Insert("TransactionType"         , Row.TransactionType);
		NewRow.Insert("Company"                 , Row.Company);
		NewRow.Insert("Branch"                  , Row.Branch);
		NewRow.Insert("Account"                 , Row.Account);
		NewRow.Insert("Currency"                , Row.Currency);
		NewRow.Insert("CurrencyExchange"        , Row.CurrencyExchange);
		NewRow.Insert("Amount"                  , Row.Amount);
		NewRow.Insert("PlaningTransactionBasis" , Row.PlaningTransactionBasis);
		NewRow.Insert("TransitAccount"          , Row.TransitAccount);
		NewRow.Insert("AmountExchange"          , Row.AmountExchange);
		ArrayOfResults.Add(NewRow);
	EndDo;
	Return ArrayOfResults;
EndFunction

#EndRegion

#Region ListFormEvents

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region ChoiceFormEvents

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion