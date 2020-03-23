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
		Return Catalogs.Partners.GetDefaultChoiseRef(Parameters);
	EndIf;
	Return Undefined;
EndFunction

Procedure FillAttributesByType(TransactionType, ArrayAll, ArrayByType) Export
	Documents.BankPayment.FillAttributesByType(TransactionType, ArrayAll, ArrayByType);
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
	|	tmp.TransitAccount AS TransitAccount,
	|	tmp.Currency AS Currency,
	|	tmp.Amount AS Amount,
	|	tmp.PlaningTransactionBasis AS PlaningTransactionBasis
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
	|			THEN VALUE(Enum.OutgoingPaymentTransactionTypes.CashTransferOrder)
	|		ELSE VALUE(Enum.OutgoingPaymentTransactionTypes.CurrencyExchange)
	|	END AS TransactionType,
	|	PlaningCashTransactionsTurnovers.Company AS Company,
	|	PlaningCashTransactionsTurnovers.Account AS Account,
	|	PlaningCashTransactionsTurnovers.Account.TransitAccount AS TransitAccount,
	|	PlaningCashTransactionsTurnovers.Currency AS Currency,
	|	PlaningCashTransactionsTurnovers.AmountTurnover AS Amount,
	|	PlaningCashTransactionsTurnovers.BasisDocument AS PlaningTransactionBasis
	|INTO tmp_CashTransferOrder
	|FROM
	|	AccumulationRegister.PlaningCashTransactions.Turnovers(, &EndOfDate,,
	|		CashFlowDirection = VALUE(Enum.CashFlowDirections.Outgoing)
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND CASE
	|		WHEN &UseArrayOfBasisDocuments
	|			THEN BasisDocument IN (&ArrayOfBasisDocuments)
	|		ELSE TRUE
	|	END) AS PlaningCashTransactionsTurnovers
	|		INNER JOIN Document.CashTransferOrder AS Doc
	|		ON PlaningCashTransactionsTurnovers.BasisDocument = Doc.Ref
	|WHERE
	|	PlaningCashTransactionsTurnovers.Account.Type = VALUE(Enum.CashAccountTypes.Bank)
	|	AND PlaningCashTransactionsTurnovers.AmountTurnover > 0";
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
		NewRow.Insert("BasedOn" ,Row.BasedOn);
		NewRow.Insert("TransactionType" ,Row.TransactionType);
		NewRow.Insert("Company" ,Row.Company);
		NewRow.Insert("Account" ,Row.Account);
		NewRow.Insert("TransitAccount" ,Row.TransitAccount);
		NewRow.Insert("Currency" ,Row.Currency);
		NewRow.Insert("Amount" ,Row.Amount);
		NewRow.Insert("PlaningTransactionBasis" ,Row.PlaningTransactionBasis);
		ArrayOfResults.Add(NewRow);
	EndDo;
	Return ArrayOfResults;
EndFunction