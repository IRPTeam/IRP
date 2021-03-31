#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("PartnerApTransactions"                 , PostingServer.CreateTable(AccReg.PartnerApTransactions));
	Tables.Insert("AccountBalance"                        , PostingServer.CreateTable(AccReg.AccountBalance));
	Tables.Insert("PlaningCashTransactions"               , PostingServer.CreateTable(AccReg.PlaningCashTransactions));
	Tables.Insert("CashInTransit"                         , PostingServer.CreateTable(AccReg.CashInTransit));
	Tables.Insert("AdvanceToSuppliers"                    , PostingServer.CreateTable(AccReg.AdvanceToSuppliers));
	Tables.Insert("CashAdvance"                           , PostingServer.CreateTable(AccReg.CashAdvance));
	Tables.Insert("PartnerApTransactions_OffsetOfAdvance" , PostingServer.CreateTable(AccReg.PartnerApTransactions));
	
	Tables.AdvanceToSuppliers.Columns.Add("Key", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	Tables.PartnerApTransactions.Columns.Add("Key", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	
	QueryPaymentList = New Query();
	QueryPaymentList.Text = GetQueryTextCashPaymentPaymentList();
	QueryPaymentList.SetParameter("Ref", Ref);
	QueryResultsPaymentList = QueryPaymentList.Execute();	
	QueryTablePaymentList = QueryResultsPaymentList.Unload();
	
	Query = New Query();
	Query.Text = GetQueryTextQueryTable();
	Query.SetParameter("QueryTable", QueryTablePaymentList);
	QueryResults = Query.ExecuteBatch();
	
	Tables.PartnerApTransactions = QueryResults[1].Unload();
	Tables.AccountBalance = QueryResults[2].Unload();
	Tables.PlaningCashTransactions = QueryResults[3].Unload();
	Tables.CashInTransit = QueryResults[4].Unload();
	Tables.AdvanceToSuppliers = QueryResults[5].Unload();
	Tables.CashAdvance = QueryResults[6].Unload();
	
	Return Tables;
EndFunction

Function GetQueryTextCashPaymentPaymentList()
	Return
		"SELECT
		|	CashPaymentPaymentList.Ref.Company AS Company,
		|	CashPaymentPaymentList.Ref.Currency AS Currency,
		|	CashPaymentPaymentList.Ref.CashAccount AS CashAccount,
		|	CASE
		|		WHEN CashPaymentPaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN CASE
		|				WHEN VALUETYPE(CashPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|				AND
		|				NOT CashPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
		|				AND
		|					CashPaymentPaymentList.PlaningTransactionBasis.SendCurrency <> CashPaymentPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|					THEN CashPaymentPaymentList.PlaningTransactionBasis
		|				ELSE CashPaymentPaymentList.BasisDocument
		|			END
		|		ELSE UNDEFINED
		|	END AS BasisDocument,
		|	CASE
		|		WHEN CashPaymentPaymentList.Agreement = VALUE(Catalog.Agreements.EmptyRef)
		|			THEN TRUE
		|		ELSE FALSE
		|	END
		|	AND
		|	NOT CASE
		|		WHEN VALUETYPE(CashPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|		AND
		|		NOT CashPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
		|		AND
		|			CashPaymentPaymentList.PlaningTransactionBasis.SendCurrency <> CashPaymentPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsAdvance,
		|	CashPaymentPaymentList.PlaningTransactionBasis AS PlaningTransactionBasis,
		|	CASE
		|		WHEN CashPaymentPaymentList.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND CashPaymentPaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN CashPaymentPaymentList.Agreement.StandardAgreement
		|		ELSE CashPaymentPaymentList.Agreement
		|	END AS Agreement,
		|	CashPaymentPaymentList.Partner AS Partner,
		|	CashPaymentPaymentList.Payee AS Payee,
		|	CashPaymentPaymentList.Ref.Date AS Period,
		|	CashPaymentPaymentList.Amount AS Amount,
		|	CASE
		|		WHEN VALUETYPE(CashPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|		AND
		|		NOT CashPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
		|		AND
		|			CashPaymentPaymentList.PlaningTransactionBasis.SendCurrency = CashPaymentPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsMoneyTransfer,
		|	CASE
		|		WHEN VALUETYPE(CashPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|		AND
		|		NOT CashPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
		|		AND
		|			CashPaymentPaymentList.PlaningTransactionBasis.SendCurrency <> CashPaymentPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsMoneyExchange,
		|	CashPaymentPaymentList.PlaningTransactionBasis.Sender AS FromAccount,
		|	CashPaymentPaymentList.PlaningTransactionBasis.Receiver AS ToAccount,
		|	CashPaymentPaymentList.Ref AS PaymentDocument,
		|	CashPaymentPaymentList.Key AS Key
		|FROM
		|	Document.CashPayment.PaymentList AS CashPaymentPaymentList
		|WHERE
		|	CashPaymentPaymentList.Ref = &Ref";
EndFunction

Function GetQueryTextQueryTable()
	Return
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Currency AS Currency,
		|	QueryTable.CashAccount AS CashAccount,
		|	QueryTable.BasisDocument AS BasisDocument,
		|	QueryTable.IsAdvance AS IsAdvance,
		|	QueryTable.PlaningTransactionBasis AS PlaningTransactionBasis,
		|	QueryTable.Agreement AS Agreement,
		|	QueryTable.Partner AS Partner,
		|	QueryTable.Payee AS Payee,
		|	QueryTable.Period AS Period,
		|	QueryTable.Amount AS Amount,
		|	QueryTable.IsMoneyTransfer AS IsMoneyTransfer,
		|	QueryTable.IsMoneyExchange AS IsMoneyExchange,
		|	QueryTable.FromAccount AS FromAccount,
		|	QueryTable.ToAccount AS ToAccount,
		|	QueryTable.PaymentDocument AS PaymentDocument,
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
		|	tmp.Payee AS LegalName,
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
		|	tmp.Partner,
		|	tmp.Payee,
		|	tmp.Agreement,
		|	tmp.Currency,
		|	tmp.Period,
		|	tmp.BasisDocument,
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
		|	CASE
		|		WHEN VALUETYPE(tmp.PlaningTransactionBasis) = TYPE(Document.OutgoingPaymentOrder)
		|			THEN tmp.Partner
		|		ELSE VALUE(Catalog.Partners.EmptyRef)
		|	END AS Partner,
		|	CASE
		|		WHEN VALUETYPE(tmp.PlaningTransactionBasis) = TYPE(Document.OutgoingPaymentOrder)
		|			THEN tmp.Payee
		|		ELSE VALUE(Catalog.Companies.EmptyRef)
		|	END AS LegalName,
		|	VALUE(Enum.CashFlowDirections.Outgoing) AS CashFlowDirection,
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
		|	VALUE(Enum.CashFlowDirections.Outgoing),
		|	CASE
		|		WHEN VALUETYPE(tmp.PlaningTransactionBasis) = TYPE(Document.OutgoingPaymentOrder)
		|			THEN tmp.Partner
		|		ELSE VALUE(Catalog.Partners.EmptyRef)
		|	END,
		|	CASE
		|		WHEN VALUETYPE(tmp.PlaningTransactionBasis) = TYPE(Document.OutgoingPaymentOrder)
		|			THEN tmp.Payee
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
		|	tmp.Payee AS LegalName,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
		|	tmp.Period,
		|	tmp.PaymentDocument,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.IsMoneyTransfer
		|	AND
		|	NOT tmp.IsMoneyExchange
		|	AND tmp.IsAdvance
		|GROUP BY
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.Payee,
		|	tmp.Currency,
		|	tmp.Period,
		|	tmp.BasisDocument,
		|	tmp.PaymentDocument,
		|	tmp.Key
		|;
		|
		|//[6]////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Partner AS Partner,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
		|	tmp.Period,
		|	tmp.PlaningTransactionBasis AS BasisDocument
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.IsMoneyExchange
		|GROUP BY
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.Currency,
		|	tmp.Period,
		|	tmp.PlaningTransactionBasis";
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// PartnerApTransactions
	PartnerApTransactions = 
	AccumulationRegisters.PartnerApTransactions.GetLockFields(DocumentDataTables.PartnerApTransactions);
	DataMapWithLockFields.Insert(PartnerApTransactions.RegisterName, PartnerApTransactions.LockInfo);
	
	// AccountBalance
	AccountBalance = AccumulationRegisters.AccountBalance.GetLockFields(DocumentDataTables.AccountBalance);
	DataMapWithLockFields.Insert(AccountBalance.RegisterName, AccountBalance.LockInfo);
	
	// PlaningCashTransactions
	PlaningCashTransactions = 
	AccumulationRegisters.PlaningCashTransactions.GetLockFields(DocumentDataTables.PlaningCashTransactions);
	DataMapWithLockFields.Insert(PlaningCashTransactions.RegisterName, PlaningCashTransactions.LockInfo);
	
	// CashInTransit
	CashInTransit = AccumulationRegisters.CashInTransit.GetLockFields(DocumentDataTables.CashInTransit);
	DataMapWithLockFields.Insert(CashInTransit.RegisterName, CashInTransit.LockInfo);
	
	// AdvanceToSuppliers
	AdvanceToSuppliers = AccumulationRegisters.AdvanceToSuppliers.GetLockFields(DocumentDataTables.AdvanceToSuppliers);
	DataMapWithLockFields.Insert(AdvanceToSuppliers.RegisterName, AdvanceToSuppliers.LockInfo);
	
	
	// CashAdvance
	CashAdvance = 
	AccumulationRegisters.CashAdvance.GetLockFields(DocumentDataTables.CashAdvance);
	DataMapWithLockFields.Insert(CashAdvance.RegisterName, CashAdvance.LockInfo);
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	// Advance to suppliers
	Parameters.DocumentDataTables.PartnerApTransactions_OffsetOfAdvance =
	AccumulationRegisters.PartnerApTransactions.GetTablePartnerApTransactions_OffsetOfAdvance(
		Parameters.Object.RegisterRecords,
		Parameters.PointInTime,
		Parameters.DocumentDataTables.AdvanceToSuppliers,
		Parameters.DocumentDataTables.PartnerApTransactions);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// AccountsStatement
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.PartnerApTransactions.CopyColumns();
	Table1.Columns.Amount.Name = "TransactionAP";
	PostingServer.AddColumnsToAccountsStatementTable(Table1);
	For Each Row In Parameters.DocumentDataTables.PartnerApTransactions Do
		If Row.Agreement.Type = Enums.AgreementTypes.Vendor Then
			NewRow = Table1.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.TransactionAP = Row.Amount;
		EndIf;
	EndDo;
	Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.AdvanceToSuppliers.CopyColumns();
	Table2.Columns.Amount.Name = "AdvanceToSuppliers";
	PostingServer.AddColumnsToAccountsStatementTable(Table2);
	For Each Row In Parameters.DocumentDataTables.AdvanceToSuppliers Do
		If Row.Partner.Vendor Then
			NewRow = Table2.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.AdvanceToSuppliers = Row.Amount;
		EndIf;
	EndDo;
	Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table2);
	
	Table3 = Parameters.DocumentDataTables.PartnerApTransactions.CopyColumns();
	Table3.Columns.Amount.Name = "TransactionAR";
	PostingServer.AddColumnsToAccountsStatementTable(Table3);
	For Each Row In Parameters.DocumentDataTables.PartnerApTransactions Do
		If Row.Agreement.Type = Enums.AgreementTypes.Customer Then
			NewRow = Table3.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.TransactionAR = - Row.Amount;
		EndIf;
	EndDo;
	Table3.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table3);
	
	Table4 = Parameters.DocumentDataTables.AdvanceToSuppliers.CopyColumns();
	Table4.Columns.Amount.Name = "AdvanceFromCustomers";
	PostingServer.AddColumnsToAccountsStatementTable(Table4);
	For Each Row In Parameters.DocumentDataTables.AdvanceToSuppliers Do
		If Row.Partner.Customer 
			And PostingServer.OffsetOfAdvanceByCustomerAgreement(
				Parameters.DocumentDataTables.PartnerApTransactions_OffsetOfAdvance) Then
			NewRow = Table4.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.AdvanceFromCustomers = - Row.Amount;
		EndIf;
	EndDo;
	Table4.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table4);
	
	Table5 = Parameters.DocumentDataTables.PartnerApTransactions_OffsetOfAdvance.CopyColumns();
	Table5.Columns.Amount.Name = "AdvanceToSuppliers";
	PostingServer.AddColumnsToAccountsStatementTable(Table5);
	For Each Row In Parameters.DocumentDataTables.PartnerApTransactions_OffsetOfAdvance Do
		If Row.Partner.Vendor Then
			NewRow = Table5.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.AdvanceToSuppliers = Row.Amount;
		EndIf;
	EndDo;
	Table5.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table5);
	
	Table6 = Parameters.DocumentDataTables.PartnerApTransactions_OffsetOfAdvance.CopyColumns();
	Table6.Columns.Amount.Name = "TransactionAP";
	PostingServer.AddColumnsToAccountsStatementTable(Table6);
	For Each Row In Parameters.DocumentDataTables.PartnerApTransactions_OffsetOfAdvance Do
		If Row.Agreement.Type = Enums.AgreementTypes.Vendor Then
			NewRow = Table6.Add(); 
			FillPropertyValues(NewRow, Row);
			NewRow.TransactionAP = Row.Amount;
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
			
	// PartnerApTransactions
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.PartnerApTransactions.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.PartnerApTransactions_OffsetOfAdvance.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PartnerApTransactions,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
			"RecordType, Period, Company, BasisDocument, Partner, LegalName, Agreement, Currency, Amount"),
			Parameters.IsReposting));
	
	// AccountBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AccountBalance,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.AccountBalance));
	
	// PlaningCashTransactions
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PlaningCashTransactions,
		New Structure("RecordSet", Parameters.DocumentDataTables.PlaningCashTransactions));
	
	
	// CashInIransit
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.CashInTransit,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.CashInTransit));
	
	// AdvanceToSuppliers
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.AdvanceToSuppliers.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.PartnerApTransactions_OffsetOfAdvance.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AdvanceToSuppliers,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
			"RecordType, Period, Company, Partner, LegalName, Currency, PaymentDocument, Amount, Key"),
			Parameters.IsReposting));
	
	
	// CashAdvance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.CashAdvance,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.CashAdvance));
	
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
	ArrayAll.Add("Payee");
	ArrayAll.Add("TransactionType");
	ArrayAll.Add("Description");
	
	ArrayAll.Add("PaymentList.BasisDocument");
	ArrayAll.Add("PaymentList.Partner");
	ArrayAll.Add("PaymentList.Payee");
	ArrayAll.Add("PaymentList.Agreement");
	ArrayAll.Add("PaymentList.PlaningTransactionBasis");
	ArrayAll.Add("PaymentList.Amount");
	
	ArrayByType = New Array();
	If TransactionType = Enums.OutgoingPaymentTransactionTypes.CashTransferOrder Then
		ArrayByType.Add("CashAccount");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
	ElsIf TransactionType = Enums.OutgoingPaymentTransactionTypes.CurrencyExchange Then
		ArrayByType.Add("CashAccount");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.Partner");
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
	Else // TransactionType PaymentToVendor
		ArrayByType.Add("CashAccount");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("Payee");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.BasisDocument");
		ArrayByType.Add("PaymentList.Partner");
		ArrayByType.Add("PaymentList.Agreement");
		ArrayByType.Add("PaymentList.Payee");
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
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

	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;

	Return QueryArray;
EndFunction

#EndRegion