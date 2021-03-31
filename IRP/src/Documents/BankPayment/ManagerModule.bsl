#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("PartnerApTransactions"                 , PostingServer.CreateTable(AccReg.PartnerApTransactions));
	Tables.Insert("AccountBalance_Expense"                , PostingServer.CreateTable(AccReg.AccountBalance));
	Tables.Insert("PlaningCashTransactions"               , PostingServer.CreateTable(AccReg.PlaningCashTransactions));
	Tables.Insert("CashInTransit"                         , PostingServer.CreateTable(AccReg.CashInTransit));
	Tables.Insert("AdvanceToSuppliers"                    , PostingServer.CreateTable(AccReg.AdvanceToSuppliers));
	Tables.Insert("AccountBalance_Receipt"                , PostingServer.CreateTable(AccReg.AccountBalance));
	Tables.Insert("ExpensesTurnovers"                     , PostingServer.CreateTable(AccReg.ExpensesTurnovers));
	Tables.Insert("AccountBalance_Commission"             , PostingServer.CreateTable(AccReg.AccountBalance));
	Tables.Insert("PartnerApTransactions_OffsetOfAdvance" , PostingServer.CreateTable(AccReg.PartnerApTransactions));
	
	Tables.AdvanceToSuppliers.Columns.Add("Key", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	Tables.PartnerApTransactions.Columns.Add("Key", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	
	QueryPaymentList = New Query();
	QueryPaymentList.Text = GetQueryTextBankPaymentPaymentList();
	QueryPaymentList.SetParameter("Ref", Ref);
	QueryResultsPaymentList = QueryPaymentList.Execute();
	QueryTablePaymentList = QueryResultsPaymentList.Unload();
	
	Query = New Query();
	Query.Text = GetQueryTextQueryTable();
	Query.SetParameter("QueryTable", QueryTablePaymentList);
	QueryResults = Query.ExecuteBatch();
		
	Tables.PartnerApTransactions = QueryResults[1].Unload();
	Tables.AccountBalance_Expense = QueryResults[2].Unload();
	Tables.PlaningCashTransactions = QueryResults[3].Unload();
	Tables.CashInTransit = QueryResults[4].Unload();
	Tables.AdvanceToSuppliers = QueryResults[5].Unload();
	Tables.AccountBalance_Receipt = QueryResults[6].Unload();
	Tables.ExpensesTurnovers = QueryResults[7].Unload();
	Tables.AccountBalance_Commission = QueryResults[8].Unload();

#Region NewRegistersPosting	
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	
	Tables.Insert("AdvancesToVendors", 
	PostingServer.GetQueryTableByName("AdvancesToVendors", Parameters));	
#EndRegion	
	
	Return Tables;
EndFunction

Function GetQueryTextBankPaymentPaymentList()
	Return
		"SELECT
		|	BankPaymentPaymentList.Ref.Company AS Company,
		|	BankPaymentPaymentList.Ref.Currency AS Currency,
		|	BankPaymentPaymentList.Ref.Account AS Account,
		|	BankPaymentPaymentList.Ref.TransitAccount AS TransitAccount,
		|	CASE
		|		WHEN BankPaymentPaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN CASE
		|				WHEN VALUETYPE(BankPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|				AND
		|				NOT BankPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
		|				AND
		|					BankPaymentPaymentList.PlaningTransactionBasis.SendCurrency <> BankPaymentPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|					THEN BankPaymentPaymentList.PlaningTransactionBasis
		|				ELSE BankPaymentPaymentList.BasisDocument
		|			END
		|		ELSE UNDEFINED
		|	END AS BasisDocument,
		|	CASE
		|		WHEN BankPaymentPaymentList.Agreement = VALUE(Catalog.Agreements.EmptyRef)
		|			THEN TRUE
		|		ELSE FALSE
		|	END
		|	AND
		|	NOT CASE
		|		WHEN VALUETYPE(BankPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|		AND
		|		NOT BankPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
		|		AND
		|			BankPaymentPaymentList.PlaningTransactionBasis.SendCurrency <> BankPaymentPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsAdvance,
		|	BankPaymentPaymentList.PlaningTransactionBasis AS PlaningTransactionBasis,
		|	CASE
		|		WHEN BankPaymentPaymentList.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND BankPaymentPaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN BankPaymentPaymentList.Agreement.StandardAgreement
		|		ELSE BankPaymentPaymentList.Agreement
		|	END AS Agreement,
		|	BankPaymentPaymentList.Partner AS Partner,
		|	BankPaymentPaymentList.Payee AS Payee,
		|	BankPaymentPaymentList.Ref.Date AS Period,
		|	BankPaymentPaymentList.Amount AS Amount,
		|	CASE
		|		WHEN VALUETYPE(BankPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|		AND
		|		NOT BankPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
		|		AND
		|			BankPaymentPaymentList.PlaningTransactionBasis.SendCurrency = BankPaymentPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsMoneyTransfer,
		|	CASE
		|		WHEN VALUETYPE(BankPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|		AND
		|		NOT BankPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
		|		AND
		|			BankPaymentPaymentList.PlaningTransactionBasis.SendCurrency <> BankPaymentPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsMoneyExchange,
		|	BankPaymentPaymentList.PlaningTransactionBasis.Sender AS FromAccount,
		|	BankPaymentPaymentList.PlaningTransactionBasis.Receiver AS ToAccount,
		|	BankPaymentPaymentList.Ref AS PaymentDocument,
		|	BankPaymentPaymentList.Key AS Key,
		|	BankPaymentPaymentList.BusinessUnit AS BusinessUnit,
		|	BankPaymentPaymentList.ExpenseType AS ExpenseType,
		|	BankPaymentPaymentList.AdditionalAnalytic AS AdditionalAnalytic,
		|	BankPaymentPaymentList.Commission AS Commission
		|FROM
		|	Document.BankPayment.PaymentList AS BankPaymentPaymentList
		|WHERE
		|	BankPaymentPaymentList.Ref = &Ref";
EndFunction

Function GetQueryTextQueryTable()
	Return
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Currency AS Currency,
		|	QueryTable.Account AS Account,
		|	QueryTable.TransitAccount AS TransitAccount,
		|	QueryTable.BasisDocument AS BasisDocument,
		|	QueryTable.IsAdvance,
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
		|	QueryTable.Key AS Key,
		|	QueryTable.BusinessUnit AS BusinessUnit,
		|	QueryTable.ExpenseType AS ExpenseType,
		|	QueryTable.AdditionalAnalytic AS AdditionalAnalytic,
		|	QueryTable.Commission AS Commission
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
		|	tmp.Amount AS Amount,
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
		|;
		|
		|//[2]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Account AS Account,
		|	tmp.Currency AS Currency,
		|	tmp.Amount AS Amount,
		|	tmp.Period,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|;
		|
		|//[3]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Account AS Account,
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
		|	-tmp.Amount AS Amount,
		|	tmp.Period,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.PlaningTransactionBasis.Date IS NULL
		|;
		|
		|//[4]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.PlaningTransactionBasis AS BasisDocument,
		|	tmp.FromAccount AS FromAccount,
		|	tmp.ToAccount AS ToAccount,
		|	tmp.Currency AS Currency,
		|	tmp.Amount AS Amount,
		|	tmp.Period,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.IsMoneyTransfer
		|;
		|
		|//[5]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Partner AS Partner,
		|	tmp.Payee AS LegalName,
		|	tmp.Currency AS Currency,
		|	tmp.Amount AS Amount,
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
		|;
		|
		|
		|//[6]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.TransitAccount AS Account,
		|	tmp.Currency AS Currency,
		|	tmp.Amount AS Amount,
		|	tmp.Period,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.IsMoneyExchange
		|;
		|//[7]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BusinessUnit AS BusinessUnit,
		|	tmp.ExpenseType AS ExpenseType,
		|	tmp.Currency AS Currency,
		|	tmp.AdditionalAnalytic AS AdditionalAnalytic,
		|	tmp.Commission AS Amount,
		|	tmp.Period AS Period,
		|	tmp.Key AS Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.Commission <> 0
		|;
		|//[8]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Account AS Account,
		|	tmp.Currency AS Currency,
		|	tmp.Commission AS Amount,
		|	tmp.Period,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.Commission <> 0";
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// PartnerApTransactions
	PartnerApTransactions = 
	AccumulationRegisters.PartnerApTransactions.GetLockFields(DocumentDataTables.PartnerApTransactions);
	DataMapWithLockFields.Insert(PartnerApTransactions.RegisterName, PartnerApTransactions.LockInfo);
	
	// AccountBalance
	AccountBalance = AccumulationRegisters.AccountBalance.GetLockFields(DocumentDataTables.AccountBalance_Expense);
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
	
	
#Region NewRegistersPosting
	PostingServer.SetLockDataSource(DataMapWithLockFields, 
		AccumulationRegisters.R1021B_VendorsTransactions, 
		DocumentDataTables.AdvancesToVendors);
#EndRegion	
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
#Region NewRegisterPosting
	Tables = Parameters.DocumentDataTables;
	
	OffsetOfPartnersServer.Vendors_OnMoneyMovements(Parameters);
	
	QueryArray = GetQueryTextsMasterTables();
		
	PostingServer.SetRegisters(Tables, Ref);
	Tables.R1020B_AdvancesToVendors.Columns.Add("Key", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	Tables.R1021B_VendorsTransactions.Columns.Add("Key", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion
	
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
	
	// AccountBalance
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.AccountBalance_Expense.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.AccountBalance_Receipt.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table2);
	
	Table3 = Parameters.DocumentDataTables.AccountBalance_Commission.Copy();
	Table3.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table3.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table3);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AccountBalance,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, Account, Currency, Amount, Key"),
			Parameters.IsReposting));
	
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
	
	
	// ExpensesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ExpensesTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.ExpensesTurnovers));
	
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
	ArrayAll.Add("Account");
	ArrayAll.Add("Company");
	ArrayAll.Add("Currency");
	ArrayAll.Add("TransactionType");
	ArrayAll.Add("Payee");
	ArrayAll.Add("PaymentList.Agreement");
	ArrayAll.Add("TransitAccount");
	ArrayAll.Add("Description");
	
	ArrayAll.Add("PaymentList.BasisDocument");
	ArrayAll.Add("PaymentList.Partner");
	ArrayAll.Add("PaymentList.Payee");
	ArrayAll.Add("PaymentList.PlaningTransactionBasis");
	ArrayAll.Add("PaymentList.Amount");
	
	ArrayByType = New Array();
	If TransactionType = Enums.OutgoingPaymentTransactionTypes.CashTransferOrder Then
		ArrayByType.Add("Account");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
	ElsIf TransactionType = Enums.OutgoingPaymentTransactionTypes.CurrencyExchange Then
		ArrayByType.Add("Account");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("TransitAccount");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
	ElsIf TransactionType = Enums.OutgoingPaymentTransactionTypes.PaymentToVendor Then
		ArrayByType.Add("Account");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("Payee");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.BasisDocument");
		ArrayByType.Add("PaymentList.Partner");
		ArrayByType.Add("PaymentList.Payee");
		ArrayByType.Add("PaymentList.Agreement");
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
	Else // empty
		ArrayByType.Add("Account");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("Payee");
		ArrayByType.Add("TransitAccount");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.BasisDocument");
		ArrayByType.Add("PaymentList.Partner");
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
	QueryArray.Add(PaymentList());
	QueryArray.Add(AdvancesToVendors());
	QueryArray.Add(VendorsTransactions());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R5010B_ReconciliationStatement());
	Return QueryArray;
EndFunction

Function PaymentList()
	Return
		"SELECT
		|	BankPaymentPaymentList.Ref.Company AS Company,
		|	BankPaymentPaymentList.Ref.Currency AS Currency,
		|	BankPaymentPaymentList.Ref.Account AS Account,
		|	BankPaymentPaymentList.Ref.TransitAccount AS TransitAccount,
		|	CASE
		|		WHEN BankPaymentPaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN CASE
		|				WHEN VALUETYPE(BankPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|				AND
		|				NOT BankPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
		|				AND
		|					BankPaymentPaymentList.PlaningTransactionBasis.SendCurrency <> BankPaymentPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|					THEN BankPaymentPaymentList.PlaningTransactionBasis
		|				ELSE BankPaymentPaymentList.BasisDocument
		|			END
		|		ELSE UNDEFINED
		|	END AS TransactionDocument,
		|	CASE
		|		WHEN BankPaymentPaymentList.Agreement = VALUE(Catalog.Agreements.EmptyRef)
		|			THEN TRUE
		|		ELSE FALSE
		|	END
		|	AND
		|	NOT CASE
		|		WHEN VALUETYPE(BankPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|		AND
		|		NOT BankPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
		|		AND
		|			BankPaymentPaymentList.PlaningTransactionBasis.SendCurrency <> BankPaymentPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsAdvance,
		|	BankPaymentPaymentList.PlaningTransactionBasis AS PlaningTransactionBasis,
		|	CASE
		|		WHEN BankPaymentPaymentList.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND BankPaymentPaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN BankPaymentPaymentList.Agreement.StandardAgreement
		|		ELSE BankPaymentPaymentList.Agreement
		|	END AS Agreement,
		|	BankPaymentPaymentList.Partner AS Partner,
		|	BankPaymentPaymentList.Payee AS Payee,
		|	BankPaymentPaymentList.Ref.Date AS Period,
		|	BankPaymentPaymentList.Amount AS Amount,
		|	CASE
		|		WHEN VALUETYPE(BankPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|		AND
		|		NOT BankPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
		|		AND
		|			BankPaymentPaymentList.PlaningTransactionBasis.SendCurrency = BankPaymentPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsMoneyTransfer,
		|	CASE
		|		WHEN VALUETYPE(BankPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|		AND
		|		NOT BankPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
		|		AND
		|			BankPaymentPaymentList.PlaningTransactionBasis.SendCurrency <> BankPaymentPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsMoneyExchange,
		|	BankPaymentPaymentList.PlaningTransactionBasis.Sender AS FromAccount,
		|	BankPaymentPaymentList.PlaningTransactionBasis.Receiver AS ToAccount,
		|	BankPaymentPaymentList.Ref AS Basis,
		|	BankPaymentPaymentList.Key AS Key,
		|	BankPaymentPaymentList.BusinessUnit AS BusinessUnit,
		|	BankPaymentPaymentList.ExpenseType AS ExpenseType,
		|	BankPaymentPaymentList.AdditionalAnalytic AS AdditionalAnalytic,
		|	BankPaymentPaymentList.Commission AS Commission
		|INTO PaymentList
		|FROM
		|	Document.BankPayment.PaymentList AS BankPaymentPaymentList
		|WHERE
		|	BankPaymentPaymentList.Ref = &Ref";
EndFunction	

Function AdvancesToVendors()
	Return
		"SELECT
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Partner,
		|	PaymentList.Payee AS LegalName,
		|	PaymentList.Currency,
		|	PaymentList.Amount AS DocumentAmount,
		|	PaymentList.Basis AS AdvancesDocument,
		|	PaymentList.Key
		|INTO AdvancesToVendors
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	NOT PaymentList.IsMoneyTransfer
		|	AND NOT PaymentList.IsMoneyExchange
		|	AND PaymentList.IsAdvance";
	
EndFunction

Function VendorsTransactions()
	Return
		"SELECT
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.TransactionDocument,
		|	PaymentList.Partner,
		|	PaymentList.Payee AS LegalName,
		|	PaymentList.Agreement,
		|	PaymentList.Currency,
		|	PaymentList.Amount,
		|	PaymentList.Key
		|INTO VendorsTransactions
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	NOT PaymentList.IsMoneyTransfer
		|	AND NOT PaymentList.IsAdvance
		|	AND NOT PaymentList.IsMoneyExchange";
EndFunction

Function R1021B_VendorsTransactions()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	VendorsTransactions.Period,
		|	VendorsTransactions.Company,
		|	VendorsTransactions.Partner,
		|	VendorsTransactions.LegalName,
		|	VendorsTransactions.Currency,
		|	VendorsTransactions.Agreement,
		|	VendorsTransactions.TransactionDocument AS Basis,
		|	VendorsTransactions.Key,
		|	VendorsTransactions.Amount
		|INTO R1021B_VendorsTransactions
		|FROM
		|	VendorsTransactions AS VendorsTransactions
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	OffsetOfAdvance.Period,
		|	OffsetOfAdvance.Company,
		|	OffsetOfAdvance.Partner,
		|	OffsetOfAdvance.LegalName,
		|	OffsetOfAdvance.Currency,
		|	OffsetOfAdvance.Agreement,
		|	OffsetOfAdvance.TransactionDocument,
		|	OffsetOfAdvance.Key,
		|	SUM(OffsetOfAdvance.Amount) AS Amount
		|FROM
		|	OffsetOfAdvance AS OffsetOfAdvance
		|GROUP BY
		|	VALUE(AccumulationRecordType.Expense),
		|	OffsetOfAdvance.Period,
		|	OffsetOfAdvance.Company,
		|	OffsetOfAdvance.Partner,
		|	OffsetOfAdvance.LegalName,
		|	OffsetOfAdvance.Currency,
		|	OffsetOfAdvance.Agreement,
		|	OffsetOfAdvance.TransactionDocument,
		|	OffsetOfAdvance.Key";
EndFunction	

Function R1020B_AdvancesToVendors()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	AdvancesToVendors.Period,
		|	AdvancesToVendors.Company,
		|	AdvancesToVendors.Partner,
		|	AdvancesToVendors.LegalName,
		|	AdvancesToVendors.Currency,
		|	AdvancesToVendors.AdvancesDocument AS Basis,
		|	AdvancesToVendors.DocumentAmount AS Amount,
		|	AdvancesToVendors.Key
		|INTO R1020B_AdvancesToVendors
		|FROM
		|	AdvancesToVendors AS AdvancesToVendors
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	OffsetOfAdvance.Period,
		|	OffsetOfAdvance.Company,
		|	OffsetOfAdvance.Partner,
		|	OffsetOfAdvance.LegalName,
		|	OffsetOfAdvance.Currency,
		|	OffsetOfAdvance.AdvancesDocument AS Basis,
		|	SUM(OffsetOfAdvance.Amount) AS Amount,
		|	OffsetOfAdvance.Key
		|FROM
		|	OffsetOfAdvance AS OffsetOfAdvance
		|GROUP BY
		|	VALUE(AccumulationRecordType.Expense),
		|	OffsetOfAdvance.Period,
		|	OffsetOfAdvance.Company,
		|	OffsetOfAdvance.Partner,
		|	OffsetOfAdvance.LegalName,
		|	OffsetOfAdvance.Currency,
		|	OffsetOfAdvance.AdvancesDocument,
		|	OffsetOfAdvance.Key";
EndFunction

Function R5010B_ReconciliationStatement()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentList.Company,
		|	PaymentList.Payee AS LegalName,
		|	PaymentList.Currency,
		|	SUM(PaymentList.Amount) AS Amount,
		|	PaymentList.Period
		|INTO R5010B_ReconciliationStatement
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	NOT PaymentList.IsMoneyTransfer
		|	AND NOT PaymentList.IsMoneyExchange
		|GROUP BY
		|	PaymentList.Company,
		|	PaymentList.Payee,
		|	PaymentList.Currency,
		|	PaymentList.Period,
		|	VALUE(AccumulationRecordType.Receipt)";
EndFunction

#EndRegion


