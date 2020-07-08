#Region FormEvents
Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	
	ArrayTypes = New Array();
	ArrayTypes.Add(Type("DocumentRef.PurchaseReturn"));
	ArrayTypes.Add(Type("DocumentRef.SalesInvoice"));
	Form.Items.PaymentListPartnerArBasisDocument.TypeRestriction = New TypeDescription(ArrayTypes);
	
	ArrayTypes = New Array();
	ArrayTypes.Add(Type("DocumentRef.PurchaseInvoice"));
	ArrayTypes.Add(Type("DocumentRef.SalesReturn"));
	Form.Items.PaymentListPartnerApBasisDocument.TypeRestriction = New TypeDescription(ArrayTypes);
	
EndProcedure

Procedure OnWriteAtServer(Object, Form, Cancel, CurrentObject, WriteParameters) Export
	DocumentsServer.OnWriteAtServer(Object, Form, Cancel, CurrentObject, WriteParameters);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	DocumentsServer.OnReadAtServer(Object, Form, CurrentObject);
EndProcedure

#EndRegion

#Region Common
Function CheckRowChequeBond(Status, CashAccount) Export
	If ValueIsFilled(Status) Then
		PostingData = ObjectStatusesServer.PutStatusPostingToStructure(Status);
		Return Not ValueIsFilled(CashAccount) 
				And Not (PostingData.PlaningCashTransactions = PredefinedValue("Enum.DocumentPostingTypes.Nothing")
				And PostingData.AccountBalance = PredefinedValue("Enum.DocumentPostingTypes.Nothing"));
	Else
		Return True;
	EndIf;
EndFunction

Function GetChequeInfo(ChequeBondTransactionRef, ChequeRef) Export
	InfoStructure = New Structure("Status, Amount, NewStatus, Currency");
	If ValueIsFilled(ChequeRef) Then
		InfoStructure.Status = ObjectStatusesServer.GetLastStatusInfoByCheque(
				New Boundary(ChequeBondTransactionRef.Date, BoundaryType.Excluding), ChequeRef).Status;
		If Not ValueIsFilled(InfoStructure.Status) Then		
			InfoStructure.NewStatus = ObjectStatusesServer.GetStatusByDefaultForCheque(ChequeRef);
		EndIf;
		
		InfoStructure.Amount = ChequeRef.Amount;
	EndIf;
	InfoStructure.Currency = ChequeRef.Currency;
	Return InfoStructure;
EndFunction

Procedure GetPaymentListFillingData(ChequeBondTransactionRef, Parameters) Export

	Query = New Query;
	Query.Text =
		"SELECT
		|	ChequeBondStatusesSliceLast.Cheque,
		|	ChequeBondStatusesSliceLast.Recorder
		|INTO TT_Transactions
		|FROM
		|	InformationRegister.ChequeBondStatuses.SliceLast(,
		|	NOT Recorder = &ChequeBondTransactionRef
		|	AND Cheque = &Cheque) AS ChequeBondStatusesSliceLast
		|WHERE
		|	ChequeBondStatusesSliceLast.Status = &Status
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ChequeBondTransactionChequeBonds.Key,
		|	TT_Transactions.Recorder
		|INTO TT_RowKeys
		|FROM
		|	TT_Transactions AS TT_Transactions
		|		INNER JOIN Document.ChequeBondTransaction.ChequeBonds AS ChequeBondTransactionChequeBonds
		|		ON ChequeBondTransactionChequeBonds.Ref = TT_Transactions.Recorder
		|		AND ChequeBondTransactionChequeBonds.Cheque = TT_Transactions.Cheque
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ChequeBondTransactionPaymentList.PartnerArBasisDocument,
		|	ChequeBondTransactionPaymentList.PartnerApBasisDocument,
		|	ChequeBondTransactionPaymentList.Amount
		|FROM
		|	Document.ChequeBondTransaction.PaymentList AS ChequeBondTransactionPaymentList
		|		INNER JOIN TT_RowKeys AS TT_RowKeys
		|		ON TT_RowKeys.Recorder = ChequeBondTransactionPaymentList.Ref
		|		AND TT_RowKeys.Key = ChequeBondTransactionPaymentList.Key";
	
	Query.SetParameter("Cheque"						, Parameters.Cheque);
	Query.SetParameter("Status"						, Parameters.Status);
	Query.SetParameter("ChequeBondTransactionRef"	, ChequeBondTransactionRef);
	
	QueryResult = Query.Execute();
	
	If QueryResult.IsEmpty() Then
		Return;
	EndIf;
	 
	SelectionDetailRecords = QueryResult.Select();
	While SelectionDetailRecords.Next() Do
		NewRow = Parameters.PaymentList.Add();
		NewRow.Key = Parameters.Key;
		FillPropertyValues(NewRow, SelectionDetailRecords);
	EndDo;

EndProcedure

Function  InvalidDocuments(ControlStructure) Export

	Query = New Query();
	Query.Text = "SELECT
		|	PartnerApTransactionsBalance.BasisDocument,
		|	PartnerApTransactionsBalance.AmountBalance,
		|	PartnerApTransactionsBalance.Company,
		|	PartnerApTransactionsBalance.Currency,
		|	PartnerApTransactionsBalance.LegalName,
		|	PartnerApTransactionsBalance.Agreement,
		|	PartnerApTransactionsBalance.Partner
		|FROM
		|	AccumulationRegister.PartnerApTransactions.Balance(&EndDate,) AS PartnerApTransactionsBalance
		|WHERE
		|	PartnerApTransactionsBalance.BasisDocument IN (&BasisDocuments)
		|	AND (Not PartnerApTransactionsBalance.Partner = &Partner
		|	OR Not PartnerApTransactionsBalance.LegalName = &LegalName
		|	OR Not PartnerApTransactionsBalance.Agreement = &Agreement
		|	OR CASE  WHEN &UseCurrencyFilter THEN Not PartnerApTransactionsBalance.Currency = &Currency ELSE TRUE END
		|	OR Not PartnerApTransactionsBalance.Company = &Company)
		|
		|UNION ALL
		|
		|SELECT
		|	PartnerArTransactionsBalance.BasisDocument,
		|	PartnerArTransactionsBalance.AmountBalance,
		|	PartnerArTransactionsBalance.Company,
		|	PartnerArTransactionsBalance.Currency,
		|	PartnerArTransactionsBalance.LegalName,
		|	PartnerArTransactionsBalance.Agreement,
		|	PartnerArTransactionsBalance.Partner
		|FROM
		|	AccumulationRegister.PartnerArTransactions.Balance(&EndDate,) AS PartnerArTransactionsBalance
		|WHERE
		|	PartnerArTransactionsBalance.BasisDocument IN (&BasisDocuments)
		|	AND (Not PartnerArTransactionsBalance.Partner = &Partner
		|	OR Not PartnerArTransactionsBalance.LegalName = &LegalName
		|	OR Not PartnerArTransactionsBalance.Agreement = &Agreement
		|	OR CASE  WHEN &UseCurrencyFilter THEN Not PartnerArTransactionsBalance.Currency = &Currency ELSE TRUE END
		|	OR Not PartnerArTransactionsBalance.Company = &Company)"; 

	Query.SetParameter("BasisDocuments", ControlStructure.ControlDocument);
	Query.SetParameter("Company", ControlStructure.Company);
	Query.SetParameter("Partner", ControlStructure.Partner);
	Query.SetParameter("LegalName", ControlStructure.LegalName);
	Query.SetParameter("Agreement", ControlStructure.Agreement);
	Query.SetParameter("Currency", ControlStructure.Currency);
	Query.SetParameter("UseCurrencyFilter", ControlStructure.UseCurrencyFilter);
	Query.SetParameter("EndDate", ControlStructure.EndDate);
	
	Return Query.Execute().Unload().UnloadColumn("BasisDocument");

EndFunction

Function  InvalidAgreements(Agreements, Company) Export

Query = New Query;
Query.Text =
	"SELECT
	|	Agreements.Ref
	|FROM
	|	Catalog.Agreements AS Agreements
	|WHERE
	|	Agreements.Ref IN (&Agreements)
	|	AND Not Agreements.Company IN (VALUE(Catalog.Companies.EmptyRef), &Company)";

Query.SetParameter("Agreements", Agreements);
Query.SetParameter("Company", Company);

	Return Query.Execute().Unload().UnloadColumn("Ref");

EndFunction
Function CurrencyOnChange(ChequeBonds, Currency) Export
	
	Return Catalogs.ChequeBonds.CheckChequeBondsOfCurrency(ChequeBonds, Currency);
	
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