#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	MoneyDocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	MoneyDocumentsServer.OnReadAtServer(Object, Form, CurrentObject);
	LockDataModificationPrivileged.LockFormIfObjectIsLocked(Form, CurrentObject);
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	MoneyDocumentsServer.AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters);
EndProcedure

#EndRegion

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
	|	tmp.CashAccount AS CashAccount,
	|	tmp.Currency AS Currency,
	|	tmp.FinancialMovementType AS FinancialMovementType,
	|	tmp.CurrencyExchange AS CurrencyExchange,
	|	tmp.Amount AS Amount,
	|	tmp.PlaningTransactionBasis AS PlaningTransactionBasis,
	|	tmp.Partner AS Partner,
	|	tmp.AmountExchange AS AmountExchange
	|FROM
	|	tmp_CashTransferOrder AS tmp";
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

Function GetDocumentTable_CashTransferOrder_QueryText() Export
	Return 
	"SELECT ALLOWED
	|	""CashTransferOrder"" AS BasedOn,
	|	CASE
	|		WHEN Doc.SendCurrency = Doc.ReceiveCurrency
	|			THEN VALUE(Enum.IncomingPaymentTransactionType.CashTransferOrder)
	|		ELSE VALUE(Enum.IncomingPaymentTransactionType.CurrencyExchange)
	|	END AS TransactionType,
	|	R3035T_CashPlanningTurnovers.Company AS Company,
	|	R3035T_CashPlanningTurnovers.Branch AS Branch,
	|	R3035T_CashPlanningTurnovers.Account AS CashAccount,
	|	R3035T_CashPlanningTurnovers.FinancialMovementType AS FinancialMovementType,
	|	R3035T_CashPlanningTurnovers.Currency AS Currency,
	|	Doc.SendCurrency AS CurrencyExchange,
	|	R3035T_CashPlanningTurnovers.AmountTurnover AS Amount,
	|	R3035T_CashPlanningTurnovers.BasisDocument AS PlaningTransactionBasis,
	|	CashAdvanceBalance.Partner AS Partner,
	|	CashAdvanceBalance.AmountBalance AS AmountExchange
	|INTO tmp
	|FROM
	|	AccumulationRegister.R3035T_CashPlanning.Turnovers(, &EndOfDate, ,
	|			CashFlowDirection = VALUE(Enum.CashFlowDirections.Incoming)
	|			AND Account.Type = VALUE(Enum.CashAccountTypes.Cash)
	|			AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|			AND CASE
	|				WHEN &UseArrayOfBasisDocuments
	|					THEN BasisDocument IN (&ArrayOfBasisDocuments)
	|				ELSE TRUE
	|			END) AS R3035T_CashPlanningTurnovers
	|		INNER JOIN Document.CashTransferOrder AS Doc
	|		ON R3035T_CashPlanningTurnovers.BasisDocument = Doc.Ref
	|		INNER JOIN AccumulationRegister.R3015B_CashAdvance.Balance(&EndOfDate,
	|			CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|		AND CASE
	|			WHEN &UseArrayOfBasisDocuments
	|				THEN Basis IN (&ArrayOfBasisDocuments)
	|			ELSE TRUE
	|		END) AS CashAdvanceBalance
	|		ON R3035T_CashPlanningTurnovers.BasisDocument = CashAdvanceBalance.Basis
	|WHERE
	|	R3035T_CashPlanningTurnovers.AmountTurnover > 0
	|
	|UNION ALL
	|
	|SELECT
	|	""CashTransferOrder"",
	|	CASE
	|		WHEN Doc.SendCurrency = Doc.ReceiveCurrency
	|			THEN VALUE(Enum.IncomingPaymentTransactionType.CashTransferOrder)
	|		ELSE VALUE(Enum.IncomingPaymentTransactionType.CurrencyExchange)
	|	END,
	|	R3035T_CashPlanningTurnovers.Company,
	|	R3035T_CashPlanningTurnovers.Branch,
	|	R3035T_CashPlanningTurnovers.Account,
	|	R3035T_CashPlanningTurnovers.FinancialMovementType,
	|	R3035T_CashPlanningTurnovers.Currency,
	|	Doc.SendCurrency,
	|	CashInTransitBalance.AmountBalance,
	|	R3035T_CashPlanningTurnovers.BasisDocument,
	|	NULL,
	|	0
	|FROM
	|	AccumulationRegister.R3035T_CashPlanning.Turnovers(, &EndOfDate, ,
	|		CashFlowDirection = VALUE(Enum.CashFlowDirections.Incoming)
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND CASE
	|		WHEN &UseArrayOfBasisDocuments
	|			THEN BasisDocument IN (&ArrayOfBasisDocuments)
	|		ELSE TRUE
	|	END) AS R3035T_CashPlanningTurnovers
	|		INNER JOIN Document.CashTransferOrder AS Doc
	|		ON R3035T_CashPlanningTurnovers.BasisDocument = Doc.Ref
	|		INNER JOIN AccumulationRegister.CashInTransit.Balance(&EndOfDate,
	|			CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|		AND CASE
	|			WHEN &UseArrayOfBasisDocuments
	|				THEN BasisDocument IN (&ArrayOfBasisDocuments)
	|			ELSE TRUE
	|		END) AS CashInTransitBalance
	|		ON R3035T_CashPlanningTurnovers.BasisDocument = CashInTransitBalance.BasisDocument
	|WHERE
	|	R3035T_CashPlanningTurnovers.Account.Type = VALUE(Enum.CashAccountTypes.Cash)
	|	AND R3035T_CashPlanningTurnovers.AmountTurnover > 0
	|	AND Doc.SendCurrency = Doc.ReceiveCurrency
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.BasedOn AS BasedOn,
	|	tmp.TransactionType AS TransactionType,
	|	tmp.Company AS Company,
	|	tmp.Branch AS Branch,
	|	tmp.CashAccount AS CashAccount,
	|	tmp.FinancialMovementType AS FinancialMovementType,
	|	tmp.Currency AS Currency,
	|	tmp.CurrencyExchange AS CurrencyExchange,
	|	tmp.Amount AS Amount,
	|	tmp.PlaningTransactionBasis AS PlaningTransactionBasis,
	|	tmp.Partner AS Partner,
	|	tmp.AmountExchange AS AmountExchange
	|INTO tmp_CashTransferOrder
	|FROM
	|	tmp AS tmp";
EndFunction

Function GetDocumentTable_CashTransferOrder_ForClient(ArrayOfBasisDocuments) Export
	ArrayOfResults = New Array();
	ValueTable = GetDocumentTable_CashTransferOrder(ArrayOfBasisDocuments);
	For Each Row In ValueTable Do
		NewRow = New Structure();
		NewRow.Insert("BasedOn"                 , Row.BasedOn);
		NewRow.Insert("TransactionType"         , Row.TransactionType);
		NewRow.Insert("Company"                 , Row.Company);
		NewRow.Insert("Branch"                  , Row.Branch);
		NewRow.Insert("CashAccount"             , Row.CashAccount);
		NewRow.Insert("Currency"                , Row.Currency);
		NewRow.Insert("CurrencyExchange"        , Row.CurrencyExchange);
		NewRow.Insert("Amount"                  , Row.Amount);
		NewRow.Insert("PlaningTransactionBasis" , Row.PlaningTransactionBasis);
		NewRow.Insert("Partner"                 , Row.Partner);
		NewRow.Insert("AmountExchange"          , Row.AmountExchange);
		ArrayOfResults.Add(NewRow);
	EndDo;
	Return ArrayOfResults;
EndFunction

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