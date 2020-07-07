#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		Form.CurrentCurrency = Object.Currency;
		Form.CurrentAccount = Object.Account;
		Form.CurrentTransactionType = Object.TransactionType;
		
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	DocumentsServer.FillPaymentList(Object);
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	Form.CurrentCurrency = CurrentObject.Currency;
	Form.CurrentAccount = CurrentObject.Account;
	Form.CurrentTransactionType = Object.TransactionType;
	DocumentsServer.FillPaymentList(Object);
	
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	Form.CurrentCurrency = CurrentObject.Currency;
	Form.CurrentAccount = CurrentObject.Account;
	Form.CurrentTransactionType = Object.TransactionType;
	DocumentsServer.FillPaymentList(Object);
	
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

#EndRegion

Function GetPartnerByLegalName(LegalName, Partner) Export
	If Not LegalName.IsEmpty() Then
		ArrayOfFilters = New Array();
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		If ValueIsFilled(Partner) Then
			ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Ref", Partner, ComparisonType.Equal));
		EndIf;
		AdditionalParameters = New Structure();
		If ValueIsFilled(LegalName) Then
			AdditionalParameters.Insert("Company", LegalName);
			AdditionalParameters.Insert("FilterPartnersByCompanies", True);
		EndIf;
		Parameters = New Structure("CustomSearchFilter, AdditionalParameters",
				DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters),
				DocumentsServer.SerializeArrayOfFilters(AdditionalParameters));
		Return Catalogs.Partners.GetDefaultChoiceRef(Parameters);
	EndIf;
	Return Undefined;
EndFunction

Procedure FillAttributesByType(TransactionType, ArrayAll, ArrayByType) Export
	Documents.BankReceipt.FillAttributesByType(TransactionType, ArrayAll, ArrayByType);
EndProcedure

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array;
	AttributesArray.Add("Company");
	AttributesArray.Add("Account");
	AttributesArray.Add("TransactionType");
	AttributesArray.Add("Currency");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Atr In AttributesArray Do
		Form.GroupItems.Add(Atr, ?(ValueIsFilled(Form.Items[Atr].Title),
				Form.Items[Atr].Title,
				Object.Ref.Metadata().Attributes[Atr].Synonym + ":" + Chars.NBSp));
	EndDo;
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
		Query.SetParameter("EndOfDate", CurrentDate());
	Else
		Query.SetParameter("EndOfDate", EndOfDate);
	EndIf;
	
	Query.Execute();
	Query.Text = 
	"SELECT
	|	tmp.BasedOn AS BasedOn,
	|	tmp.TransactionType AS TransactionType,
	|	tmp.Company AS Company,
	|	tmp.Account AS Account,
	|	tmp.Currency AS Currency,
	|	tmp.CurrencyExchange AS CurrencyExchange,
	|	tmp.Amount AS Amount,
	|	tmp.PlaningTransactionBasis AS PlaningTransactionBasis,
	|	tmp.TransitAccount AS TransitAccount,
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
	|	PlaningCashTransactionsTurnovers.Company AS Company,
	|	PlaningCashTransactionsTurnovers.Account AS Account,
	|	PlaningCashTransactionsTurnovers.Currency AS Currency,
	|	Doc.SendCurrency AS CurrencyExchange,
	|	CashInTransitBalance.AmountBalance AS Amount,
	|	PlaningCashTransactionsTurnovers.BasisDocument AS PlaningTransactionBasis
	|INTO tmp_IncomingMoney
	|FROM
	|	AccumulationRegister.PlaningCashTransactions.Turnovers(, &EndOfDate,,
	|		CashFlowDirection = VALUE(Enum.CashFlowDirections.Incoming)
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND CASE
	|		WHEN &UseArrayOfBasisDocuments
	|			THEN BasisDocument IN (&ArrayOfBasisDocuments)
	|		ELSE TRUE
	|	END) AS PlaningCashTransactionsTurnovers
	|		INNER JOIN Document.CashTransferOrder AS Doc
	|		ON PlaningCashTransactionsTurnovers.BasisDocument = Doc.Ref
	|		LEFT JOIN AccumulationRegister.CashInTransit.Balance(&EndOfDate,
	|			CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|		AND CASE
	|			WHEN &UseArrayOfBasisDocuments
	|				THEN BasisDocument IN (&ArrayOfBasisDocuments)
	|			ELSE TRUE
	|		END) AS CashInTransitBalance
	|		ON PlaningCashTransactionsTurnovers.BasisDocument = CashInTransitBalance.BasisDocument
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
	|		AND CASE
	|			WHEN &UseArrayOfBasisDocuments
	|				THEN PlaningCashTransactions.BasisDocument IN (&ArrayOfBasisDocuments)
	|			ELSE TRUE
	|		END
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
	|INTO tmp_CashTransferOrder
	|FROM
	|	tmp_IncomingMoney AS tmp_IncomingMoney
	|		LEFT JOIN tmp_OutgoingMoney AS tmp_OutgoingMoney
	|		ON tmp_IncomingMoney.Company = tmp_OutgoingMoney.Company
	|		AND tmp_IncomingMoney.CurrencyExchange = tmp_OutgoingMoney.SendCurrency
	|		AND tmp_IncomingMoney.PlaningTransactionBasis = tmp_OutgoingMoney.BasisDocument";
EndFunction

Function GetDocumentTable_CashTransferOrder_ForClient(ArrayOfBasisDocuments, ObjectRef = Undefined) Export
	EndOfDate = Undefined;
	If ValueIsFilled(ObjectRef) Then
		EndOfDate = New Boundary(ObjectRef.PointInTime(), BoundaryType.Excluding)
	EndIf;
	ArrayOfResults = New Array();
	ValueTable = GetDocumentTable_CashTransferOrder(ArrayOfBasisDocuments, EndOfDate);
	For Each Row In ValueTable Do
		NewRow = New Structure();
		NewRow.Insert("BasedOn"					, Row.BasedOn);
		NewRow.Insert("TransactionType" 		, Row.TransactionType);
		NewRow.Insert("Company"					, Row.Company);
		NewRow.Insert("Account"					, Row.Account);
		NewRow.Insert("Currency"				, Row.Currency);
		NewRow.Insert("CurrencyExchange"		, Row.CurrencyExchange);
		NewRow.Insert("Amount"					, Row.Amount);
		NewRow.Insert("PlaningTransactionBasis"	, Row.PlaningTransactionBasis);
		NewRow.Insert("TransitAccount"			, Row.TransitAccount);
		NewRow.Insert("AmountExchange"			, Row.AmountExchange);
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