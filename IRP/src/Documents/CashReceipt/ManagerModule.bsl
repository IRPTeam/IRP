#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("PartnerArTransactions"                 , PostingServer.CreateTable(AccReg.PartnerArTransactions));
	Tables.Insert("AccountBalance"                        , PostingServer.CreateTable(AccReg.AccountBalance));
	Tables.Insert("PlaningCashTransactions"               , PostingServer.CreateTable(AccReg.PlaningCashTransactions));
	Tables.Insert("CashInTransit"                         , PostingServer.CreateTable(AccReg.CashInTransit));
	Tables.Insert("AdvanceFromCustomers"                  , PostingServer.CreateTable(AccReg.AdvanceFromCustomers));
	Tables.Insert("CashAdvance"                           , PostingServer.CreateTable(AccReg.CashAdvance));
	Tables.Insert("PartnerArTransactions_OffsetOfAdvance" , PostingServer.CreateTable(AccReg.PartnerArTransactions));
	Tables.Insert("Aging_Expense"                         , PostingServer.CreateTable(AccReg.Aging));
	
	Tables.AdvanceFromCustomers.Columns.Add("Key", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	Tables.PartnerArTransactions.Columns.Add("Key", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	
	QueryPaymentList = New Query();
	QueryPaymentList.Text = GetQueryTextCashReceiptPaymentList();
	QueryPaymentList.SetParameter("Ref", Ref);
	QueryResultsPaymentList = QueryPaymentList.Execute();
	QueryTablePaymentList = QueryResultsPaymentLIst.Unload();
	
	Query = New Query();
	Query.Text = GetQueryTextQueryTable();
	Query.SetParameter("QueryTable", QueryTablePaymentList);
	QueryResults = Query.ExecuteBatch();
	
	Tables.PartnerArTransactions = QueryResults[1].Unload();
	Tables.AccountBalance = QueryResults[2].Unload();
	Tables.PlaningCashTransactions = QueryResults[3].Unload();
	Tables.CashInTransit = QueryResults[4].Unload();
	Tables.AdvanceFromCustomers = QueryResults[5].Unload();
	Tables.CashAdvance = QueryResults[6].Unload();

#Region NewRegistersPosting	
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion	

	Return Tables;
EndFunction

Function GetQueryTextCashReceiptPaymentList()
	Return
		"SELECT
		|	CashReceiptPaymentList.Ref.Company AS Company,
		|	CashReceiptPaymentList.Ref.Currency AS Currency,
		|	CashReceiptPaymentList.Ref.CurrencyExchange AS CurrencyExchange,
		|	CashReceiptPaymentList.Ref.CashAccount AS CashAccount,
		|	CASE
		|		WHEN CashReceiptPaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN CASE
		|				WHEN VALUETYPE(CashReceiptPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|				AND
		|				NOT CashReceiptPaymentList.PlaningTransactionBasis.Date IS NULL
		|				AND
		|					CashReceiptPaymentList.PlaningTransactionBasis.SendCurrency <> CashReceiptPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|					THEN CashReceiptPaymentList.PlaningTransactionBasis
		|				ELSE CashReceiptPaymentList.BasisDocument
		|			END
		|		ELSE UNDEFINED
		|	END AS BasisDocument,
		|	CASE
		|		WHEN CashReceiptPaymentList.Agreement = VALUE(Catalog.Agreements.EmptyRef)
		|			THEN TRUE
		|		ELSE FALSE
		|	END
		|	AND
		|	NOT CASE
		|		WHEN VALUETYPE(CashReceiptPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|		AND
		|		NOT CashReceiptPaymentList.PlaningTransactionBasis.Date IS NULL
		|		AND
		|			CashReceiptPaymentList.PlaningTransactionBasis.SendCurrency <> CashReceiptPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsAdvance,
		|	CashReceiptPaymentList.PlaningTransactionBasis AS PlaningTransactionBasis,
		|	CASE
		|		WHEN CashReceiptPaymentList.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND CashReceiptPaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN CashReceiptPaymentList.Agreement.StandardAgreement
		|		ELSE CashReceiptPaymentList.Agreement
		|	END AS Agreement,
		|	CashReceiptPaymentList.Partner AS Partner,
		|	CashReceiptPaymentList.Payer AS Payer,
		|	CashReceiptPaymentList.Ref.Date AS Period,
		|	CashReceiptPaymentList.Amount AS Amount,
		|	CashReceiptPaymentList.AmountExchange AS AmountExchange,
		|	CASE
		|		WHEN VALUETYPE(CashReceiptPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|		AND
		|		NOT CashReceiptPaymentList.PlaningTransactionBasis.Date IS NULL
		|		AND
		|			CashReceiptPaymentList.PlaningTransactionBasis.SendCurrency = CashReceiptPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsMoneyTransfer,
		|	CASE
		|		WHEN VALUETYPE(CashReceiptPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|		AND
		|		NOT CashReceiptPaymentList.PlaningTransactionBasis.Date IS NULL
		|		AND
		|			CashReceiptPaymentList.PlaningTransactionBasis.SendCurrency <> CashReceiptPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsMoneyExchange,
		|	CashReceiptPaymentList.PlaningTransactionBasis.Sender AS FromAccount,
		|	CashReceiptPaymentList.PlaningTransactionBasis.Receiver AS ToAccount,
		|	CashReceiptPaymentList.Ref AS ReceiptDocument,
		|	CashReceiptPaymentList.Key AS Key
		|FROM
		|	Document.CashReceipt.PaymentList AS CashReceiptPaymentList
		|WHERE
		|	CashReceiptPaymentList.Ref = &Ref";
EndFunction

Function GetQueryTextQueryTable()
	Return
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Currency AS Currency,
		|	QueryTable.CurrencyExchange AS CurrencyExchange,
		|	QueryTable.CashAccount AS CashAccount,
		|	QueryTable.BasisDocument AS BasisDocument,
		|	QueryTable.IsAdvance AS IsAdvance,
		|	QueryTable.PlaningTransactionBasis AS PlaningTransactionBasis,
		|	QueryTable.Agreement AS Agreement,
		|	QueryTable.Partner AS Partner,
		|	QueryTable.Payer AS Payer,
		|	QueryTable.Period AS Period,
		|	QueryTable.Amount AS Amount,
		|	QueryTable.AmountExchange AS AmountExchange,
		|	QueryTable.IsMoneyTransfer AS IsMoneyTransfer,
		|	QueryTable.IsMoneyExchange AS IsMoneyExchange,
		|	QueryTable.FromAccount AS FromAccount,
		|	QueryTable.ToAccount AS ToAccount,
		|	QueryTable.ReceiptDocument,
		|	QueryTable.Key AS Key
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|//[1]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BasisDocument AS BasisDocument,
		|	tmp.Partner AS Partner,
		|	tmp.Payer AS LegalName,
		|	tmp.Agreement AS Agreement,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
		|	tmp.Period,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.IsMoneyTransfer
		|	AND
		|	NOT tmp.IsAdvance
		|	AND
		|	NOT tmp.IsMoneyExchange
		|GROUP BY
		|	tmp.Company,
		|	tmp.BasisDocument,
		|	tmp.Partner,
		|	tmp.Payer,
		|	tmp.Agreement,
		|	tmp.Currency,
		|	tmp.Period,
		|	tmp.Key
		|;
		|
		|//[2]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.CashAccount AS Account,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
		|	tmp.Period,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.CashAccount,
		|	tmp.Currency,
		|	tmp.Period,
		|	tmp.Key
		|;
		|
		|//[3]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.CashAccount AS Account,
		|	tmp.Currency AS Currency,
		|	tmp.PlaningTransactionBasis AS BasisDocument,
		|	VALUE(Enum.CashFlowDirections.Incoming) AS CashFlowDirection,
		|	CASE
		|		WHEN VALUETYPE(tmp.PlaningTransactionBasis) = TYPE(Document.IncomingPaymentOrder)
		|			THEN tmp.Partner
		|		ELSE VALUE(Catalog.Partners.EmptyRef)
		|	END AS Partner,
		|	CASE
		|		WHEN VALUETYPE(tmp.PlaningTransactionBasis) = TYPE(Document.IncomingPaymentOrder)
		|			THEN tmp.Payer
		|		ELSE VALUE(Catalog.Companies.EmptyRef)
		|	END AS LegalName,
		|	-SUM(tmp.Amount) AS Amount,
		|	tmp.Period,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.PlaningTransactionBasis.Date IS NULL
		|GROUP BY
		|	tmp.Company,
		|	tmp.CashAccount,
		|	tmp.Currency,
		|	tmp.PlaningTransactionBasis,
		|	tmp.Period,
		|	VALUE(Enum.CashFlowDirections.Incoming),
		|	CASE
		|		WHEN VALUETYPE(tmp.PlaningTransactionBasis) = TYPE(Document.IncomingPaymentOrder)
		|			THEN tmp.Partner
		|		ELSE VALUE(Catalog.Partners.EmptyRef)
		|	END,
		|	CASE
		|		WHEN VALUETYPE(tmp.PlaningTransactionBasis) = TYPE(Document.IncomingPaymentOrder)
		|			THEN tmp.Payer
		|		ELSE VALUE(Catalog.Companies.EmptyRef)
		|	END,
		|	tmp.Key
		|;
		|
		|//[4]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.PlaningTransactionBasis AS BasisDocument,
		|	tmp.FromAccount AS FromAccount,
		|	tmp.ToAccount AS ToAccount,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
		|	tmp.Period,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.IsMoneyTransfer
		|GROUP BY
		|	tmp.Company,
		|	tmp.PlaningTransactionBasis,
		|	tmp.FromAccount,
		|	tmp.ToAccount,
		|	tmp.Currency,
		|	tmp.Period,
		|	tmp.Key
		|;
		|
		|//[5]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Partner AS Partner,
		|	tmp.Payer AS LegalName,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
		|	tmp.Period,
		|	tmp.ReceiptDocument,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.IsAdvance
		|	AND 
		|	NOT tmp.IsMoneyExchange
		|	AND 
		|	NOT tmp.IsMoneyTransfer
		|GROUP BY
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.Payer,
		|	tmp.Currency,
		|	tmp.Period,
		|	tmp.BasisDocument,
		|	tmp.ReceiptDocument,
		|	tmp.Key
		|;
		|
		|//[6]////////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Partner AS Partner,
		|	tmp.CurrencyExchange AS Currency,
		|	SUM(tmp.AmountExchange) AS Amount,
		|	tmp.Period,
		|	tmp.PlaningTransactionBasis AS BasisDocument
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.IsMoneyExchange
		|GROUP BY
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.CurrencyExchange,
		|	tmp.Period,
		|	tmp.PlaningTransactionBasis";
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
#Region NewRegistersPosting
	Tables = Parameters.DocumentDataTables;	
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion
	
	// Advance from customers
	Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance =
	AccumulationRegisters.PartnerArTransactions.GetTablePartnerArTransactions_OffsetOfAdvance(
		Parameters.Object.RegisterRecords,
		Parameters.PointInTime,
		Parameters.DocumentDataTables.AdvanceFromCustomers,
		Parameters.DocumentDataTables.PartnerArTransactions);
			
	// Aging expense
	Parameters.DocumentDataTables.Aging_Expense = 
		AccumulationRegisters.Aging.GetTableAging_Expense_OnMoneyReceipt(
		Parameters.PointInTime,
		Parameters.DocumentDataTables.PartnerArTransactions,
		Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// AccountsStatement
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.PartnerArTransactions.CopyColumns();
	Table1.Columns.Amount.Name = "TransactionAP";
	PostingServer.AddColumnsToAccountsStatementTable(Table1);
	For Each Row In Parameters.DocumentDataTables.PartnerArTransactions Do
		If Row.Agreement.Type = Enums.AgreementTypes.Vendor  Then
			NewRow = Table1.Add(); 
			FillPropertyValues(NewRow, Row);
			NewRow.TransactionAP = - Row.Amount;
		EndIf;
	EndDo;
	Table1.FillValues(AccumulationRecordType.Expense, "RecordType");	
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.AdvanceFromCustomers.CopyColumns();
	Table2.Columns.Amount.Name = "AdvanceToSuppliers";
	PostingServer.AddColumnsToAccountsStatementTable(Table2);
	For Each Row In Parameters.DocumentDataTables.AdvanceFromCustomers Do
		If Row.Partner.Vendor 
			And PostingServer.OffsetOfAdvanceByVendorAgreement(
				Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance) Then
			NewRow = Table2.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.AdvanceToSuppliers = - Row.Amount;
		EndIf;
	EndDo;
	Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table2);
	
	Table3 = Parameters.DocumentDataTables.AdvanceFromCustomers.CopyColumns();
	Table3.Columns.Amount.Name = "AdvanceFromCustomers";
	PostingServer.AddColumnsToAccountsStatementTable(Table3);
	For Each Row In Parameters.DocumentDataTables.AdvanceFromCustomers Do
		If Row.Partner.Customer Then
			NewRow = Table3.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.AdvanceFromCustomers = Row.Amount;
		EndIf;
	EndDo;
	Table3.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table3);
	
	Table4 = Parameters.DocumentDataTables.PartnerArTransactions.CopyColumns();
	Table4.Columns.Amount.Name = "TransactionAR";
	PostingServer.AddColumnsToAccountsStatementTable(Table4);
	For Each Row In Parameters.DocumentDataTables.PartnerArTransactions Do
		If Row.Agreement.Type = Enums.AgreementTypes.Customer Then
			NewRow = Table4.Add(); 
			FillPropertyValues(NewRow, Row);
			NewRow.TransactionAR = Row.Amount;
		EndIf;
	EndDo;
	Table4.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table4);
	
	Table5 = Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance.CopyColumns();
	Table5.Columns.Amount.Name = "AdvanceFromCustomers";
	PostingServer.AddColumnsToAccountsStatementTable(Table5);
	For Each Row In Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance Do
		If Row.Partner.Customer Then
			NewRow = Table5.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.AdvanceFromCustomers = Row.Amount;
		EndIf;
	EndDo;
	Table5.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table5);
	
	Table6 = Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance.CopyColumns();
	Table6.Columns.Amount.Name = "TransactionAR";
	PostingServer.AddColumnsToAccountsStatementTable(Table6);
	For Each Row In Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance Do
		If Row.Agreement.Type = Enums.AgreementTypes.Customer Then
			NewRow = Table6.Add(); 
			FillPropertyValues(NewRow, Row);
			NewRow.TransactionAR = Row.Amount;
		EndIf;
	EndDo;
	Table6.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table6);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AccountsStatement,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, Partner, LegalName, BasisDocument, Currency, 
				|TransactionAP, AdvanceToSuppliers,
				|TransactionAR, AdvanceFromCustomers"),
			Parameters.IsReposting));
			
	// PartnerArTransactions
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.PartnerArTransactions.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PartnerArTransactions,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
			"RecordType, Period, Company, BasisDocument, Partner, LegalName, Agreement, Currency, Amount"),
			Parameters.IsReposting));
	
	// AccountBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AccountBalance,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.AccountBalance));
	
	// PlaningCashTransactions
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PlaningCashTransactions,
		New Structure("RecordSet", Parameters.DocumentDataTables.PlaningCashTransactions));
	
	// CashInIransit
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.CashInTransit,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.CashInTransit));
	
	// AdvanceFromCustomers
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.AdvanceFromCustomers.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AdvanceFromCustomers,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
			"RecordType, Period, Company, Partner, LegalName, Currency, ReceiptDocument, Amount, Key"),
			Parameters.IsReposting));
	
	
	// CashAdvance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.CashAdvance,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.CashAdvance));
	
	// Aging
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.Aging,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.Aging_Expense));

#Region NewRegistersPosting	
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
#EndRegion

	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;	
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

Procedure FillAttributesByType(TransactionType, ArrayAll, ArrayByType) Export
	
	ArrayAll = New Array();
	ArrayAll.Add("CashAccount");
	ArrayAll.Add("Company");
	ArrayAll.Add("Currency");
	ArrayAll.Add("TransactionType");
	ArrayAll.Add("CurrencyExchange");
	ArrayAll.Add("Payer");
	ArrayAll.Add("Description");
	
	ArrayAll.Add("PaymentList.BasisDocument");
	ArrayAll.Add("PaymentList.Partner");
	ArrayAll.Add("PaymentList.Payer");
	ArrayAll.Add("PaymentList.PlaningTransactionBasis");
	ArrayAll.Add("PaymentList.Amount");
	ArrayAll.Add("PaymentList.Agreement");
	ArrayAll.Add("PaymentList.AmountExchange");
	
	ArrayByType = New Array();
	If TransactionType = Enums.IncomingPaymentTransactionType.CashTransferOrder Then
		ArrayByType.Add("CashAccount");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
	ElsIf TransactionType = Enums.IncomingPaymentTransactionType.CurrencyExchange Then
		ArrayByType.Add("CashAccount");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("CurrencyExchange");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.Partner");
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
		ArrayByType.Add("PaymentList.AmountExchange");
		
	ElsIf TransactionType = Enums.IncomingPaymentTransactionType.PaymentFromCustomer Then
		ArrayByType.Add("CashAccount");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("Payer");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.BasisDocument");
		ArrayByType.Add("PaymentList.Partner");
		ArrayByType.Add("PaymentList.Payer");
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
		ArrayByType.Add("PaymentList.Agreement");
		
	Else // empty
		ArrayByType.Add("CashAccount");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("CurrencyExchange");
		ArrayByType.Add("Payer");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.BasisDocument");
		ArrayByType.Add("PaymentList.Partner");
		ArrayByType.Add("PaymentList.Payer");
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
		ArrayByType.Add("PaymentList.AmountExchange");
		
	EndIf;
	
EndProcedure

#Region NewRegistersPosting
Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParamenters", GetAdditionalQueryParamenters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParamenters(Ref)
	StrParams = New Structure();
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(PaymentList());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R3010B_CashOnHand());
	QueryArray.Add(R3015B_CashAdvance());
	Return QueryArray;
EndFunction

Function PaymentList()
	Return
	"SELECT
	|	PaymentList.Ref.Date AS Period,
	|	PaymentList.Ref.Company AS Company,
	|	PaymentList.Payer AS LegalName,
	|	PaymentList.Ref.Currency AS Currency,
	|	PaymentList.Ref.CashAccount AS CashAccount,
	|	PaymentList.BasisDocument AS Basis,
	|	PaymentList.Partner.Employee AS IsEmployee,
	|	PaymentList.Amount,
	|	PaymentList.Ref.TransactionType
	|   = VALUE(Enum.IncomingPaymentTransactionType.PaymentFromCustomer) AS IsPaymentFromCustomer,
	|	PaymentList.Ref.TransactionType
	|   = VALUE(Enum.IncomingPaymentTransactionType.CurrencyExchange) AS IsCurrencyExchange,
	|	PaymentList.Ref.TransactionType
	|   = VALUE(Enum.IncomingPaymentTransactionType.CashTransferOrder) AS IsCashTransferOrder,
	|	PaymentList.Ref.TransactionType
	|   = VALUE(Enum.IncomingPaymentTransactionType.TransferFromPOS) AS IsTransferFromPOS
	|INTO PaymentList
	|FROM
	|	Document.CashReceipt.PaymentList AS PaymentList
	|WHERE
	|	PaymentList.Ref = &Ref";	
EndFunction

Function R5010B_ReconciliationStatement()
	Return
	"SELECT
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	*
	|INTO R5010B_ReconciliationStatement
	|FROM
	|	PaymentList";	
EndFunction

Function R3010B_CashOnHand()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.CashAccount AS Account,
		|	PaymentList.Currency,
		|	SUM(PaymentList.Amount) AS Amount
		|INTO R3010B_CashOnHand
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsPaymentFromCustomer
		|	OR PaymentList.IsCashTransferOrder
		|GROUP BY
		|	VALUE(AccumulationRecordType.Receipt),
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.CashAccount,
		|	PaymentList.Currency";	
EndFunction

Function R3015B_CashAdvance()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Currency,
		|	PaymentList.Basis,
		|	SUM(PaymentList.Amount) AS Amount
		|INTO R3015B_CashAdvance
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsCurrencyExchange
		|	AND PaymentList.IsEmployee
		|GROUP BY
		|	VALUE(AccumulationRecordType.Expense),
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Currency,
		|	PaymentList.Basis";	
EndFunction

#EndRegion