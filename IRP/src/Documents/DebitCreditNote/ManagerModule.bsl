#Region PRINT_FORM

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region POSTING

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);	
	AccountingServer.CreateAccountingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo);
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	
	Tables.R1020B_AdvancesToVendors.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R1021B_VendorsTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2020B_AdvancesFromCustomers.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2021B_CustomersTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.T1040T_AccountingAmounts.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5020B_PartnersBalance.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5015B_OtherPartnersTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3027B_EmployeeCashAdvance.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	
	Tables.R5011B_CustomersAging.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5012B_VendorsAging.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map;
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	OffsetOfAdvancesServer.CheckAdvanceBalance(Ref, Cancel, Parameters, "R1020B_AdvancesToVendors");
	OffsetOfAdvancesServer.CheckAdvanceBalance(Ref, Cancel, Parameters, "R2020B_AdvancesFromCustomers");
EndProcedure

#EndRegion

#Region UNDOPOSTING

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

#Region Posting_Info

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure;
	StrParams.Insert("Ref", Ref);
	
	// advance vendor - debit - SEND
//	Register  "R1020 Advances to vendors" - RECEIPT
//	Register  "R5010 Reconciliation statement" - RECEIPT
//	Register  "R5020 Partners balance" - RECEIPT
//	Register  "T2014 Advances info" - RECEIPT

	// advance customer - credit - RECEIVE
//  Register  "R2020 Advances from customer" - RECEIPT
//  Register  "R5010 Reconciliation statement" - EXPENSE
//  Register  "R5020 Partners balance" - EXPENSE
//  Register  "T2014 Advances info" - RECEIPT
	
	// transaction vendor - credit - RECEIVE
//  Register  "R1021 Vendors transactions" - RECEIPT
//  Register  "R5010 Reconciliation statement" - EXPENSE
//  Register  "R5020 Partners balance" - EXPENSE
//  Register  "T2015 Transactions info" - is due
	
	// transaction customer - debit - SEND
	//Register  "R2021 Customer transactions" - RECEIPT
	//Register  "R5010 Reconciliation statement" - RECEIPT
	//Register  "R5020 Partners balance" - RECEIPT
	//Register  "T2015 Transactions info" - is due
	
	// employee - debit - SEND
//	Register  "R3027 Employee cash advance" - RECEIPT
	
	// other partner - debit - SEND
	//Register  "R5010 Reconciliation statement" - RECEIPT
	//Register  "R5015 Other partners transactions" - RECEIPT
	//Register  "R5020 Partners balance" - RECEIPT
	
//
//		
//	
	// Receivable
//	ArrayOfReceivable = New Array();
//	ArrayOfReceivable.Add(Enums.DebtTypes.AdvanceVendor);
//	ArrayOfReceivable.Add(Enums.DebtTypes.TransactionCustomer);
//	ArrayOfReceivable.Add(Enums.DebtTypes.OtherPartnerReceivable);
//	ArrayOfReceivable.Add(Enums.DebtTypes.EmployeeReceivable);
//	StrParams.Insert("ArrayOfReceivable", ArrayOfReceivable);
	
	// Payable
//	ArrayOfPayable = New Array();
//	ArrayOfPayable.Add(Enums.DebtTypes.AdvanceCustomer);
//	ArrayOfPayable.Add(Enums.DebtTypes.TransactionVendor);
//	StrParams.Insert("ArrayOfPayable", ArrayOfPayable);
	
	
	StrParams.Insert("IsAdvanceVendor_Send", 	   Ref.SendDebtType = Enums.DebtTypes.AdvanceVendor); 
	StrParams.Insert("IsAdvanceCustomer_Send",     Ref.SendDebtType = Enums.DebtTypes.AdvanceCustomer); 
	StrParams.Insert("IsTransactionVendor_Send",   Ref.SendDebtType = Enums.DebtTypes.TransactionVendor); 
	StrParams.Insert("IsTransactionCustomer_Send", Ref.SendDebtType = Enums.DebtTypes.TransactionCustomer); 
	StrParams.Insert("IsEmployee_Send", 	       Ref.SendDebtType = Enums.DebtTypes.EmployeeReceivable); 
	StrParams.Insert("IsOther_Send", 	           Ref.SendDebtType = Enums.DebtTypes.OtherPartnerReceivable);
	
	StrParams.Insert("IsAdvanceVendor_Receive", 	  Ref.ReceiveDebtType = Enums.DebtTypes.AdvanceVendor); 
	StrParams.Insert("IsAdvanceCustomer_Receive", 	  Ref.ReceiveDebtType = Enums.DebtTypes.AdvanceCustomer); 
	StrParams.Insert("IsTransactionVendor_Receive",   Ref.ReceiveDebtType = Enums.DebtTypes.TransactionVendor); 
	StrParams.Insert("IsTransactionCustomer_Receive", Ref.ReceiveDebtType = Enums.DebtTypes.TransactionCustomer); 
	StrParams.Insert("IsEmployee_Receive", 	          Ref.ReceiveDebtType = Enums.DebtTypes.EmployeeReceivable); 
	StrParams.Insert("IsOther_Receive", 	          Ref.ReceiveDebtType = Enums.DebtTypes.OtherPartnerReceivable); 
	
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(Header());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(T2014S_AdvancesInfo());
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(T2015S_TransactionsInfo());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R5011B_CustomersAging());
	QueryArray.Add(R5012B_VendorsAging());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5020B_PartnersBalance());
	QueryArray.Add(T1040T_AccountingAmounts());
	QueryArray.Add(R5015B_OtherPartnersTransactions());
	QueryArray.Add(R3027B_EmployeeCashAdvance());
	QueryArray.Add(PostingServer.Exists_R1020B_AdvancesToVendors());
	QueryArray.Add(PostingServer.Exists_R2020B_AdvancesFromCustomers());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function Header()
	Return
		"select 
		|Doc.Date AS Period,
		|Doc.Company AS Company,
		|
		|
		|Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceVendor) AS IsAdvanceVendor_Send,
		|Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer) AS IsAdvanceCustomer_Send,
		|Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionVendor) AS IsTransactionVendor_Send,
		|Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionCustomer) AS IsTransactionCustomer_Send,
		|Doc.SendDebtType = VALUE(Enum.DebtTypes.EmployeeReceivable) AS IsEmployee_Send,
		|Doc.SendDebtType = VALUE(Enum.DebtTypes.OtherPartnerReceivable) AS IsOther_Send,
		|
		|Doc.Branch AS SendBranch,
		|Doc.SendPartner,
		|Doc.SendLegalName,
		|Doc.SendLegalNameContract,
		|Doc.SendBasisDocument,
		|Doc.SendOrder,
		|Doc.SendCurrency,
		|Doc.SendAgreement,
		|Doc.SendProject,
		|Doc.SendAmount,
		|Doc.SendUUID,	
		|
		|
		|
		|Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.AdvanceVendor) AS IsAdvanceVendor_Receive,
		|Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer) AS IsAdvanceCustomer_Receive,
		|Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionVendor) AS IsTransactionVendor_Receive,
		|Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionCustomer) AS IsTransactionCustomer_Receive,
		|Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.EmployeeReceivable) AS IsEmployee_Receive,
		|Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.OtherPartnerReceivable) AS IsOther_Receive,
		|
		|Doc.ReceiveBranch,
		|Doc.ReceivePartner,
		|Doc.ReceiveLegalName,
		|Doc.ReceiveLegalNameContract,
		|Doc.ReceiveBasisDocument,
		|Doc.ReceiveOrder,
		|Doc.ReceiveCurrency,
		|Doc.ReceiveAgreement,
		|Doc.ReceiveProject,
		|Doc.ReceiveAmount,
		|Doc.ReceiveUUID
		|
		|into Doc
		|from Document.DebitCreditNote AS Doc where Doc.Ref = &Ref";
	
	
	
//		"SELECT
//		|	Doc.Ref AS Ref,
//		|	Doc.SendDebtType IN (&ArrayOfReceivable) AS SendIsReceivable,
//		|	Doc.SendDebtType IN (&ArrayOfPayable) AS SendIsPayable,
//		|	Doc.SendDebtType IN (VALUE(Enum.DebtTypes.EmployeeReceivable)) AS SendIsEmployee,
//		|	Doc.ReceiveDebtType IN (VALUE(Enum.DebtTypes.EmployeeReceivable)) AS ReceiveIsEmployee
//		|INTO tmp
//		|FROM
//		|	Document.DebitCreditNote AS Doc
//		|WHERE
//		|	Doc.Ref = &Ref
//		|;
//		|
//		|////////////////////////////////////////////////////////////////////////////////
//		|SELECT
//		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceVendor) AS DoRecordsSend_R1020B_AdvancesToVendors,
//		|	CASE
//		|		WHEN Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceVendor)
//		|			THEN VALUE(AccumulationRecordType.Expense)
//		|	END AS RecordsTypeSend_R1020B_AdvancesToVendors,
//		|	Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.AdvanceVendor) AS DoRecordsReceive_R1020B_AdvancesToVendors,
//		|	CASE
//		|		WHEN Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.AdvanceVendor)
//		|			THEN CASE
//		|				WHEN tmp.SendIsReceivable
//		|					THEN VALUE(AccumulationRecordType.Receipt)
//		|				WHEN tmp.SendIsPayable
//		|					THEN VALUE(AccumulationRecordType.Expense)
//		|			END
//		|	END AS RecordsTypeReceive_R1020B_AdvancesToVendors,
//		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer) AS DoRecordsSend_R2020B_AdvancesFromCustomers,
//		|	CASE
//		|		WHEN Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer)
//		|			THEN VALUE(AccumulationRecordType.Expense)
//		|	END AS RecordsTypeSend_R2020B_AdvancesFromCustomers,
//		|	Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer) AS DoRecordsReceive_R2020B_AdvancesFromCustomers,
//		|	CASE
//		|		WHEN Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer)
//		|			THEN CASE
//		|				WHEN tmp.SendIsReceivable
//		|					THEN VALUE(AccumulationRecordType.Expense)
//		|				WHEN tmp.SendIsPayable
//		|					THEN VALUE(AccumulationRecordType.Receipt)
//		|			END
//		|	END AS RecordsTypeReceive_R2020B_AdvancesFromCustomers,
//		|	Doc.SendDebtType IN (VALUE(Enum.DebtTypes.AdvanceVendor), VALUE(Enum.DebtTypes.AdvanceCustomer)) AS
//		|		DoRecordsSend_T2014S_AdvancesInfo,
//		|	CASE
//		|		WHEN Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceVendor)
//		|		OR Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer)
//		|			THEN VALUE(Enum.RecordType.Expense)
//		|	END AS RecordsTypeSend_T2014S_AdvancesInfo,
//		|	Doc.ReceiveDebtType IN (VALUE(Enum.DebtTypes.AdvanceVendor), VALUE(Enum.DebtTypes.AdvanceCustomer)) AS
//		|		DoRecordsReceive_T2014S_AdvancesInfo,
//		|	CASE
//		|		WHEN Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.AdvanceVendor)
//		|			THEN CASE
//		|				WHEN tmp.SendIsReceivable
//		|					THEN VALUE(Enum.RecordType.Receipt)
//		|				WHEN tmp.SendIsPayable
//		|					THEN VALUE(Enum.RecordType.Expense)
//		|			END
//		|		WHEN Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer)
//		|			THEN CASE
//		|				WHEN tmp.SendIsReceivable
//		|					THEN VALUE(Enum.RecordType.Expense)
//		|				WHEN tmp.SendIsPayable
//		|					THEN VALUE(Enum.RecordType.Receipt)
//		|			END
//		|	END AS RecordsTypeReceive_T2014S_AdvancesInfo,
//		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionVendor) AS DoRecordsSend_R1021B_VendorsTransactions,
//		|	CASE
//		|		WHEN Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionVendor)
//		|			THEN VALUE(AccumulationRecordType.Expense)
//		|	END AS RecordsTypeSend_R1021B_VendorsTransactions,
//		|	Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionVendor) AS DoRecordsReceive_R1021B_VendorsTransactions,
//		|	CASE
//		|		WHEN Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionVendor)
//		|			THEN CASE
//		|				WHEN tmp.SendIsReceivable
//		|					THEN VALUE(AccumulationRecordType.Expense)
//		|				WHEN tmp.SendIsPayable
//		|					THEN VALUE(AccumulationRecordType.Receipt)
//		|			END
//		|	END AS RecordsTypeReceive_R1021B_VendorsTransactions,
//		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionCustomer) AS DoRecordsSend_R2021B_CustomersTransactions,
//		|	CASE
//		|		WHEN Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionCustomer)
//		|			THEN VALUE(AccumulationRecordType.Expense)
//		|	END AS RecordsTypeSend_R2021B_CustomersTransactions,
//		|	Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionCustomer) AS DoRecordsReceive_R2021B_CustomersTransactions,
//		|	CASE
//		|		WHEN Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionCustomer)
//		|			THEN CASE
//		|				WHEN tmp.SendIsReceivable
//		|					THEN VALUE(AccumulationRecordType.Receipt)
//		|				WHEN tmp.SendIsPayable
//		|					THEN VALUE(AccumulationRecordType.Expense)
//		|			END
//		|	END AS RecordsTypeReceive_R2021B_CustomersTransactions,
//		|	Doc.SendDebtType IN (VALUE(Enum.DebtTypes.TransactionVendor), VALUE(Enum.DebtTypes.TransactionCustomer)) AS
//		|		DoRecordsSend_T2015S_TransactionsInfo,
//		|	CASE
//		|		WHEN Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionVendor)
//		|		OR Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionCustomer)
//		|			THEN VALUE(Enum.RecordType.Expense)
//		|	END AS RecordsTypeSend_T2015S_TransactionsInfo,
//		|	Doc.ReceiveDebtType IN (VALUE(Enum.DebtTypes.TransactionVendor), VALUE(Enum.DebtTypes.TransactionCustomer)) AS
//		|		DoRecordsReceive_T2015S_TransactionsInfo,
//		|	CASE
//		|		WHEN Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionVendor)
//		|			THEN CASE
//		|				WHEN tmp.SendIsReceivable
//		|					THEN VALUE(Enum.RecordType.Expense)
//		|				WHEN tmp.SendIsPayable
//		|					THEN VALUE(Enum.RecordType.Receipt)
//		|			END
//		|		WHEN Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionCustomer)
//		|			THEN CASE
//		|				WHEN tmp.SendIsReceivable
//		|					THEN VALUE(Enum.RecordType.Receipt)
//		|				WHEN tmp.SendIsPayable
//		|					THEN VALUE(Enum.RecordType.Expense)
//		|			END
//		|	END AS RecordsTypeReceive_T2015S_TransactionsInfo,
//		|	NOT tmp.SendIsEmployee AS DoRecordsSend_R5010B_ReconciliationStatement,
//		|	CASE
//		|		WHEN tmp.SendIsReceivable
//		|			THEN VALUE(AccumulationRecordType.Expense)
//		|		WHEN tmp.SendIsPayable
//		|			THEN VALUE(AccumulationRecordType.Receipt)
//		|	END AS RecordsTypeSend_R5010B_ReconciliationStatement,
//		|	NOT tmp.ReceiveIsEmployee AS DoRecordsReceive_R5010B_ReconciliationStatement,
//		|	CASE
//		|		WHEN tmp.SendIsReceivable
//		|			THEN VALUE(AccumulationRecordType.Receipt)
//		|		WHEN tmp.SendIsPayable
//		|			THEN VALUE(AccumulationRecordType.Expense)
//		|	END AS RecordsTypeReceive_R5010B_ReconciliationStatement,
//		|	NOT tmp.SendIsEmployee AS DoRecordsSend_R5020B_PartnersBalance,
//		|	CASE
//		|		WHEN tmp.SendIsReceivable
//		|			THEN VALUE(AccumulationRecordType.Expense)
//		|		WHEN tmp.SendIsPayable
//		|			THEN VALUE(AccumulationRecordType.Receipt)
//		|	END AS RecordsTypeSend_R5020B_PartnersBalance,
//		|	NOT tmp.ReceiveIsEmployee AS DoRecordsReceive_R5020B_PartnersBalance,
//		|	CASE
//		|		WHEN tmp.SendIsReceivable
//		|			THEN VALUE(AccumulationRecordType.Receipt)
//		|		WHEN tmp.SendIsPayable
//		|			THEN VALUE(AccumulationRecordType.Expense)
//		|	END AS RecordsTypeReceive_R5020B_PartnersBalance,
//		|	Doc.SendDebtType IN (VALUE(Enum.DebtTypes.OtherPartnerReceivable)) AS
//		|		DoRecordsSend_R5015B_OtherPartnersTransactions,
//		|	CASE
//		|		WHEN 
//		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.OtherPartnerReceivable)
//		|			THEN VALUE(AccumulationRecordType.Expense)
//		|	END AS RecordsTypeSend_R5015B_OtherPartnersTransactions,
//		|	Doc.ReceiveDebtType IN (VALUE(Enum.DebtTypes.OtherPartnerReceivable)) AS
//		|		DoRecordsReceive_R5015B_OtherPartnersTransactions,
//		|	CASE
//		|		WHEN Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.OtherPartnerReceivable)
//		|			THEN CASE
//		|				WHEN tmp.SendIsReceivable
//		|					THEN VALUE(AccumulationRecordType.Receipt)
//		|				WHEN tmp.SendIsPayable
//		|					THEN VALUE(AccumulationRecordType.Expense)
//		|			END
//		|	END AS RecordsTypeReceive_R5015B_OtherPartnersTransactions,
//		|
//		|	Doc.SendDebtType IN (VALUE(Enum.DebtTypes.EmployeeReceivable)) AS DoRecordsSend_R3027B_EmployeeCashAdvance,
//		|
//		|	CASE
//		|		WHEN Doc.SendDebtType = VALUE(Enum.DebtTypes.EmployeeReceivable)
//		|			THEN VALUE(AccumulationRecordType.Expense)
//		|	END AS RecordsTypeSend_R3027B_EmployeeCashAdvance,
//		|
//		|	Doc.ReceiveDebtType IN (VALUE(Enum.DebtTypes.EmployeeReceivable)) AS
//		|		DoRecordsReceive_R3027B_EmployeeCashAdvance,
//		|
//		|	CASE
//		|		WHEN Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.EmployeeReceivable)
//		|			THEN CASE
//		|				WHEN tmp.SendIsReceivable
//		|					THEN VALUE(AccumulationRecordType.Receipt)
//		|				WHEN tmp.SendIsPayable
//		|					THEN VALUE(AccumulationRecordType.Expense)
//		|			END
//		|	END AS RecordsTypeReceive_R3027B_EmployeeCashAdvance,
//		|	Doc.Date AS Period,
//		|	Doc.Company AS Company,
//		|	UNDEFINED AS VendorsAdvancesClosing,
//		|	UNDEFINED AS CustomersAdvancesClosing,
//		|	Doc.Branch AS SendBranch,
//		|	Doc.SendPartner AS SendPartner,
//		|	Doc.SendLegalName AS SendLegalName,
//		|	Doc.SendCurrency AS SendCurrency,
//		|	Doc.SendAgreement AS SendAgreement,
//		|	Doc.SendProject AS SendProject,
//		|	Doc.SendAmount AS SendAmount,
//		|	Doc.SendUUID AS SendUUID,
//		|	Doc.SendLegalNameContract AS SendLegalNameContract,
//		|	CASE
//		|		WHEN Doc.SendAgreement.UseOrdersForSettlements
//		|			THEN Doc.SendOrder
//		|		ELSE UNDEFINED
//		|	END AS SendOrderSettlements,
//		|	Doc.SendBasisDocument AS SendBasisDocument,
//		|	CASE
//		|		WHEN Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionVendor)
//		|		OR Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionCustomer)
//		|			THEN Doc.SendBasisDocument
//		|	END AS SendPartnerBalanceDocument,
//		|	CASE
//		|		WHEN Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionCustomer)
//		|			THEN Doc.SendAmount
//		|		ELSE 0
//		|	END AS SendCustomerTransaction,
//		|	CASE
//		|		WHEN Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer)
//		|			THEN Doc.SendAmount
//		|		ELSE 0
//		|	END AS SendCustomerAdvance,
//		|	CASE
//		|		WHEN Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionVendor)
//		|			THEN Doc.SendAmount
//		|		ELSE 0
//		|	END AS SendVendorTransaction,
//		|	CASE
//		|		WHEN Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceVendor)
//		|			THEN Doc.SendAmount
//		|		ELSE 0
//		|	END AS SendVendorAdvance,
//		|	CASE
//		|		WHEN 
//		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.OtherPartnerReceivable)
//		|			THEN Doc.SendAmount
//		|		ELSE 0
//		|	END AS SendOtherTransaction,
//		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer) AS SendIsCustomerAdvance,
//		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceVendor) AS SendIsVendorAdvance,
//		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionVendor) AS SendIsVendorTransaction,
//		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionCustomer) AS SendIsCustomerTransaction,
//		|	Doc.ReceiveBranch AS ReceiveBranch,
//		|	Doc.ReceivePartner AS ReceivePartner,
//		|	Doc.ReceiveLegalName AS ReceiveLegalName,
//		|	Doc.ReceiveCurrency AS ReceiveCurrency,
//		|	Doc.ReceiveAgreement AS ReceiveAgreement,
//		|	Doc.ReceiveProject AS ReceiveProject,
//		|	Doc.ReceiveAmount AS ReceiveAmount,
//		|	Doc.ReceiveUUID AS ReceiveUUID,
//		|	Doc.ReceiveLegalNameContract AS ReceiveLegalNameContract,
//		|	CASE
//		|		WHEN Doc.ReceiveAgreement.UseOrdersForSettlements
//		|			THEN Doc.ReceiveOrder
//		|		ELSE UNDEFINED
//		|	END AS ReceiveOrderSettlements,
//		|	Doc.ReceiveBasisDocument AS ReceiveBasisDocument,
//		|	CASE
//		|		WHEN Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionVendor)
//		|		OR Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionCustomer)
//		|			THEN Doc.ReceiveBasisDocument
//		|	END AS ReceivePartnerBalanceDocument,
//		|	CASE
//		|		WHEN Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionCustomer)
//		|			THEN Doc.ReceiveAmount
//		|		ELSE 0
//		|	END AS ReceiveCustomerTransaction,
//		|	CASE
//		|		WHEN Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer)
//		|			THEN Doc.ReceiveAmount
//		|		ELSE 0
//		|	END AS ReceiveCustomerAdvance,
//		|	CASE
//		|		WHEN Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionVendor)
//		|			THEN Doc.ReceiveAmount
//		|		ELSE 0
//		|	END AS ReceiveVendorTransaction,
//		|	CASE
//		|		WHEN Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.AdvanceVendor)
//		|			THEN Doc.ReceiveAmount
//		|		ELSE 0
//		|	END AS ReceiveVendorAdvance,
//		|	CASE
//		|		WHEN 
//		|		Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.OtherPartnerReceivable)
//		|			THEN Doc.ReceiveAmount
//		|		ELSE 0
//		|	END AS ReceiveOtherTransaction,
//		|	Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer) AS ReceiveIsCustomerAdvance,
//		|	Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.AdvanceVendor) AS ReceiveIsVendorAdvance,
//		|	Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionVendor) AS ReceiveIsVendorTransaction,
//		|	Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionCustomer) AS ReceiveIsCustomerTransaction
//		|INTO Doc
//		|FROM
//		|	Document.DebitCreditNote AS Doc
//		|		INNER JOIN tmp AS tmp
//		|		ON Doc.Ref = tmp.Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

// advance to vendor
// advance from customer
// transaction vendor
// transaction customer

Function R5010B_ReconciliationStatement()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) as RecordType,
		|
		|	Doc.Period AS Period,
		|	Doc.Company AS Company,
		|	Doc.SendBranch AS Branch,
		|	Doc.SendCurrency AS Currency,
		|	Doc.SendLegalName AS LegalName,
		|	Doc.SendLegalNameContract AS LegalNameContract,
		|	Doc.SendAmount AS Amount
		|INTO R5010B_ReconciliationStatement
		|FROM
		|	Doc AS Doc
		|WHERE
		|	Doc.IsAdvanceVendor_Send or Doc.IsAdvanceCustomer_Send
		|	or Doc.IsTransactionVendor_Send or Doc.IsTransactionCustomer_Send
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	Doc.Period,
		|	Doc.Company,
		|	Doc.ReceiveBranch,
		|	Doc.ReceiveCurrency,
		|	Doc.ReceiveLegalName,
		|	Doc.ReceiveLegalNameContract,
		|	Doc.ReceiveAmount
		|FROM
		|	Doc AS Doc
		|WHERE
		|	Doc.IsAdvanceVendor_Receive or Doc.IsAdvanceCustomer_Receive
		|	or Doc.IsTransactionVendor_Receive or Doc.IsTransactionCustomer_Receive";
EndFunction

Function R5015B_OtherPartnersTransactions()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	Doc.Period AS Period,
		|	Doc.Company AS Company,
		|	Doc.SendBranch AS Branch,
		|	Doc.SendCurrency AS Currency,
		|	Doc.SendLegalName AS LegalName,
		|	Doc.SendPartner AS Partner,
		|	Doc.SendAgreement AS Agreement,
		|	Doc.SendBasisDocument AS Basis,
		|	Doc.SendAmount AS Amount,
		|	Doc.SendUUID AS Key
		|INTO R5015B_OtherPartnersTransactions
		|FROM
		|	Doc AS Doc
		|WHERE
		|	Doc.IsOther_Send
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	Doc.Period,
		|	Doc.Company,
		|	Doc.ReceiveBranch,
		|	Doc.ReceiveCurrency,
		|	Doc.ReceiveLegalName,
		|	Doc.ReceivePartner,
		|	Doc.ReceiveAgreement,
		|	Doc.ReceiveBasisDocument,
		|	Doc.ReceiveAmount,
		|	Doc.ReceiveUUID
		|FROM
		|	Doc AS Doc
		|WHERE
		|	Doc.IsOther_Receive";
EndFunction

//+
Function R3027B_EmployeeCashAdvance()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	Doc.Period AS Period,
		|	Doc.Company AS Company,
		|	Doc.SendBranch AS Branch,
		|	Doc.SendCurrency AS Currency,
		|	Doc.SendPartner AS Partner,
		|	Doc.SendAgreement AS Agreement,
		|	Doc.SendAmount AS Amount,
		|	Doc.SendUUID AS Key
		|INTO R3027B_EmployeeCashAdvance
		|FROM
		|	Doc AS Doc
		|WHERE
		|	Doc.IsEmployee_Send
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	Doc.Period,
		|	Doc.Company,
		|	Doc.ReceiveBranch,
		|	Doc.ReceiveCurrency,
		|	Doc.ReceivePartner,
		|	Doc.ReceiveAgreement,
		|	Doc.ReceiveAmount,
		|	Doc.ReceiveUUID
		|FROM
		|	Doc AS Doc
		|WHERE
		|	Doc.IsEmployee_Receive";
EndFunction

// advance to vendor
// advance from customer
//+
Function T2014S_AdvancesInfo()
	Return 
		"SELECT
		|	VALUE(Enum.RecordType.Receipt) AS RecordType,
		|	Doc.Period AS Date,
		|	Doc.Company AS Company,
		|	Doc.SendBranch AS Branch,
		|	Doc.SendPartner AS Partner,
		|	Doc.SendLegalName AS LegalName,
		|	Doc.SendCurrency AS Currency,
		|	Doc.SendAgreement AS AdvanceAgreement,
		|	Doc.SendProject AS Project,
		|	Doc.SendOrder AS Order,
		|	Doc.IsAdvanceCustomer_Receive AS IsCustomerAdvance,
		|	Doc.IsAdvanceVendor_Send AS IsVendorAdvance,
		|	Doc.SendAmount AS Amount,
		|	Doc.SendUUID AS Key
		|INTO T2014S_AdvancesInfo
		|FROM
		|	Doc AS Doc
		|WHERE
		|	Doc.IsAdvanceVendor_Send or Doc.IsAdvanceCustomer_Receive
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(Enum.RecordType.Expense),
		|	Doc.Period,
		|	Doc.Company,
		|	Doc.ReceiveBranch,
		|	Doc.ReceivePartner,
		|	Doc.ReceiveLegalName,
		|	Doc.ReceiveCurrency,
		|	Doc.ReceiveAgreement,
		|	Doc.ReceiveProject,
		|	Doc.ReceiveOrder,
		|	Doc.IsAdvanceCustomer_Send,
		|	Doc.IsAdvanceVendor_Receive,
		|	Doc.ReceiveAmount,
		|	Doc.ReceiveUUID
		|FROM
		|	Doc AS Doc
		|WHERE
		|	Doc.IsAdvanceVendor_Receive or Doc.IsAdvanceCustomer_Send";
EndFunction

//+
Function R1020B_AdvancesToVendors()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	Doc.Period AS Period,
		|	Doc.Company AS Company,
		|	Doc.SendBranch AS Branch,
		|	Doc.SendPartner AS Partner,
		|	Doc.SendLegalName AS LegalName,
		|	Doc.SendCurrency AS Currency,
		|	Doc.SendAgreement AS Agreement,
		|	Doc.SendProject AS Project,
		|	Doc.SendAmount AS Amount,
		|	Doc.SendUUID AS Key,
		|	Undefined AS VendorsAdvancesClosing
		|INTO R1020B_AdvancesToVendors
		|FROM
		|	Doc AS Doc
		|WHERE
		|	Doc.IsAdvanceVendor_Send
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	Doc.Period,
		|	Doc.Company,
		|	Doc.ReceiveBranch,
		|	Doc.ReceivePartner,
		|	Doc.ReceiveLegalName,
		|	Doc.ReceiveCurrency,
		|	Doc.ReceiveAgreement,
		|	Doc.ReceiveProject,
		|	Doc.ReceiveAmount,
		|	Doc.ReceiveUUID,
		|	Undefined
		|FROM
		|	Doc AS Doc
		|WHERE
		|	Doc.IsAdvanceVendor_Receive
		|
		|UNION ALL
		|
		|SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Receipt)
		|		ELSE VALUE(AccumulationRecordType.Expense)
		|	END,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.Agreement,
		|	OffsetOfAdvances.AdvanceProject,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing";
EndFunction

//+
Function R2020B_AdvancesFromCustomers()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	Doc.Period AS Period,
		|	Doc.Company AS Company,
		|	Doc.SendBranch AS Branch,
		|	Doc.SendPartner AS Partner,
		|	Doc.SendLegalName AS LegalName,
		|	Doc.SendCurrency AS Currency,
		|	Doc.SendAgreement AS Agreement,
		|	Doc.SendProject AS Project,
		|	Doc.SendAmount AS Amount,
		|	Doc.SendUUID AS Key,
		|	undefined AS CustomersAdvancesClosing
		|INTO R2020B_AdvancesFromCustomers
		|FROM
		|	Doc AS Doc
		|WHERE
		|	Doc.IsAdvanceCustomer_Send
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	Doc.Period,
		|	Doc.Company,
		|	Doc.ReceiveBranch,
		|	Doc.ReceivePartner,
		|	Doc.ReceiveLegalName,
		|	Doc.ReceiveCurrency,
		|	Doc.ReceiveAgreement,
		|	Doc.ReceiveProject,
		|	Doc.ReceiveAmount,
		|	Doc.ReceiveUUID,
		|	undefined
		|FROM
		|	Doc AS Doc
		|WHERE
		|	Doc.IsAdvanceCustomer_Receive
		|
		|UNION ALL
		|
		|SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Receipt)
		|		ELSE VALUE(AccumulationRecordType.Expense)
		|	END,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.Agreement,
		|	OffsetOfAdvances.AdvanceProject,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing";
EndFunction

//+
Function T2015S_TransactionsInfo()
	Return 
		"SELECT
		|	Doc.Period AS Date,
		|	Doc.Company AS Company,
		|	Doc.SendBranch AS Branch,
		|	Doc.SendCurrency AS Currency,
		|	Doc.SendLegalName AS LegalName,
		|	Doc.SendPartner AS Partner,
		|	Doc.SendAgreement AS Agreement,
		|	Doc.SendProject AS Project,
		|	Doc.SendBasisDocument AS TransactionBasis,
		|	Doc.SendOrder AS Order,
		|	Doc.IsTransactionVendor_Send  AS IsVendorTransaction,
		|	Doc.IsTransactionCustomer_Send AS IsCustomerTransaction,
		|	Doc.IsTransactionCustomer_Send AS IsDue,
		|	Doc.IsTransactionVendor_Send AS IsPaid,
		|	Doc.SendAmount AS Amount,
		|	Doc.SendUUID AS Key
		|INTO T2015S_TransactionsInfo
		|FROM
		|	Doc AS Doc
		|WHERE
		|	Doc.IsTransactionVendor_Send
		|
		|UNION ALL
		|
		|SELECT
		|	Doc.Period,
		|	Doc.Company,
		|	Doc.ReceiveBranch,
		|	Doc.ReceiveCurrency,
		|	Doc.ReceiveLegalName,
		|	Doc.ReceivePartner,
		|	Doc.ReceiveAgreement,
		|	Doc.ReceiveProject,
		|	Doc.ReceiveBasisDocument,
		|	Doc.ReceiveOrder,
		|	Doc.IsTransactionVendor_Receive as IsVendorTransaction,
		|	Doc.IsTransactionCustomer_Receive as IsCustomerTransaction,
		|	Doc.IsTransactionVendor_Receive AS IsDue,
		|	Doc.IsTransactionCustomer_Receive AS IsPaid,
		|	Doc.ReceiveAmount,
		|	Doc.ReceiveUUID
		|FROM
		|	Doc AS Doc
		|WHERE
		|	Doc.IsTransactionVendor_Receive";
EndFunction

//+
Function R1021B_VendorsTransactions()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	Doc.Period AS Period,
		|	Doc.Company AS Company,
		|	Doc.SendBranch AS Branch,
		|	Doc.SendCurrency AS Currency,
		|	Doc.SendLegalName AS LegalName,
		|	Doc.SendPartner AS Partner,
		|	Doc.SendAgreement AS Agreement,
		|	Doc.SendProject AS Project,
		|	Doc.SendBasisDocument AS Basis,
		|	Doc.SendOrder AS Order,
		|	Doc.SendAmount AS Amount,
		|	Doc.SendUUID AS Key,
		|	undefined AS VendorsAdvancesClosing
		|INTO R1021B_VendorsTransactions
		|FROM
		|	Doc AS Doc
		|WHERE
		|	Doc.IsTransactionVendor_Send
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	Doc.Period,
		|	Doc.Company,
		|	Doc.ReceiveBranch,
		|	Doc.ReceiveCurrency,
		|	Doc.ReceiveLegalName,
		|	Doc.ReceivePartner,
		|	Doc.ReceiveAgreement,
		|	Doc.ReceiveProject,
		|	Doc.ReceiveBasisDocument,
		|	Doc.ReceiveOrder,
		|	Doc.ReceiveAmount,
		|	Doc.ReceiveUUID,
		|	undefined
		|FROM
		|	Doc AS Doc
		|WHERE
		|	Doc.IsTransactionVendor_Receive
		|
		|UNION ALL
		|
		|SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Receipt)
		|		ELSE VALUE(AccumulationRecordType.Expense)
		|	END,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.Agreement,
		|	OffsetOfAdvances.TransactionProject,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.TransactionOrder,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing";
//		"SELECT
//		|	Doc.RecordsTypeSend_R1021B_VendorsTransactions AS RecordType,
//		|	Doc.Period AS Period,
//		|	Doc.Company AS Company,
//		|	Doc.SendBranch AS Branch,
//		|	Doc.SendCurrency AS Currency,
//		|	Doc.SendLegalName AS LegalName,
//		|	Doc.SendPartner AS Partner,
//		|	Doc.SendAgreement AS Agreement,
//		|	Doc.SendProject AS Project,
//		|	Doc.SendBasisDocument AS Basis,
//		|	Doc.SendOrderSettlements AS Order,
//		|	Doc.SendAmount AS Amount,
//		|	Doc.SendUUID AS Key,
//		|	Doc.VendorsAdvancesClosing AS VendorsAdvancesClosing
//		|INTO R1021B_VendorsTransactions
//		|FROM
//		|	Doc AS Doc
//		|WHERE
//		|	Doc.DoRecordsSend_R1021B_VendorsTransactions
//		|
//		|UNION ALL
//		|
//		|SELECT
//		|	Doc.RecordsTypeReceive_R1021B_VendorsTransactions,
//		|	Doc.Period,
//		|	Doc.Company,
//		|	Doc.ReceiveBranch,
//		|	Doc.ReceiveCurrency,
//		|	Doc.ReceiveLegalName,
//		|	Doc.ReceivePartner,
//		|	Doc.ReceiveAgreement,
//		|	Doc.ReceiveProject,
//		|	Doc.ReceiveBasisDocument,
//		|	Doc.ReceiveOrderSettlements,
//		|	Doc.ReceiveAmount,
//		|	Doc.ReceiveUUID,
//		|	Doc.VendorsAdvancesClosing
//		|FROM
//		|	Doc AS Doc
//		|WHERE
//		|	Doc.DoRecordsReceive_R1021B_VendorsTransactions
//		|
//		|UNION ALL
//		|
//		|SELECT
//		|	CASE
//		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
//		|			THEN VALUE(AccumulationRecordType.Receipt)
//		|		ELSE VALUE(AccumulationRecordType.Expense)
//		|	END,
//		|	OffsetOfAdvances.Period,
//		|	OffsetOfAdvances.Company,
//		|	OffsetOfAdvances.Branch,
//		|	OffsetOfAdvances.Currency,
//		|	OffsetOfAdvances.LegalName,
//		|	OffsetOfAdvances.Partner,
//		|	OffsetOfAdvances.Agreement,
//		|	OffsetOfAdvances.TransactionProject,
//		|	OffsetOfAdvances.TransactionDocument,
//		|	OffsetOfAdvances.TransactionOrder,
//		|	OffsetOfAdvances.Amount,
//		|	OffsetOfAdvances.Key,
//		|	OffsetOfAdvances.Recorder
//		|FROM
//		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
//		|WHERE
//		|	OffsetOfAdvances.Document = &Ref
//		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing";
EndFunction

//+
Function R2021B_CustomersTransactions()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	Doc.Period AS Period,
		|	Doc.Company AS Company,
		|	Doc.SendBranch AS Branch,
		|	Doc.SendCurrency AS Currency,
		|	Doc.SendLegalName AS LegalName,
		|	Doc.SendPartner AS Partner,
		|	Doc.SendAgreement AS Agreement,
		|	Doc.SendProject AS Project,
		|	Doc.SendBasisDocument AS Basis,
		|	Doc.SendOrder AS Order,
		|	Doc.SendAmount AS Amount,
		|	Doc.SendUUID AS Key,
		|	undefined as CustomersAdvancesClosing
		|INTO R2021B_CustomersTransactions
		|FROM
		|	Doc AS Doc
		|WHERE
		|	Doc.IsTransactionCustomer_Send
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	Doc.Period,
		|	Doc.Company,
		|	Doc.ReceiveBranch,
		|	Doc.ReceiveCurrency,
		|	Doc.ReceiveLegalName,
		|	Doc.ReceivePartner,
		|	Doc.ReceiveAgreement,
		|	Doc.ReceiveProject,
		|	Doc.ReceiveBasisDocument,
		|	Doc.ReceiveOrder,
		|	Doc.ReceiveAmount,
		|	Doc.ReceiveUUID,
		|	undefined
		|FROM
		|	Doc AS Doc
		|WHERE
		|	Doc.IsTransactionCustomer_Receive
		|
		|UNION ALL
		|
		|SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Receipt)
		|		ELSE VALUE(AccumulationRecordType.Expense)
		|	END,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.Agreement,
		|	OffsetOfAdvances.TransactionProject,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.TransactionOrder,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing";
	
EndFunction

Function R5011B_CustomersAging()
	Return AccumulationRegisters.R5011B_CustomersAging.R5011B_CustomersAging_Offset();
EndFunction

Function R5012B_VendorsAging()
	Return AccumulationRegisters.R5012B_VendorsAging.R5012B_VendorsAging_Offset();
EndFunction

// advance to vendor
// advance from customer

Function R5020B_PartnersBalance()
	Return
		"select 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	Doc.Period AS Period,
		|	Doc.SendUUID AS Key,
		|	Doc.Company AS Company,
		|	Doc.SendBranch AS Branch,
		|	Doc.SendPartner AS Partner,
		|	Doc.SendLegalName AS LegalName,
		|	Doc.SendAgreement AS Agreement,
		|	Doc.SendBasisDocument AS Document,
		|	Doc.SendCurrency AS Currency,
		|	0 AS Amount,
		|	case when Doc.IsTransactionCustomer_Send then Doc.SendAmount else 0 end AS CustomerTransaction,
		|	case when Doc.IsAdvanceCustomer_Send then Doc.SendAmount else 0 end AS CustomerAdvance,
		|	case when Doc.IsTransactionVendor_Send then Doc.SendAmount else 0 end AS VendorTransaction,
		|	case when Doc.IsAdvanceVendor_Send then Doc.SendAmount else 0 end AS VendorAdvance,
		|	case when Doc.IsOther_Send then Doc.SendAmount else 0 end AS OtherTransaction,
		|	UNDEFINED AS AdvancesClosing
		|
		|into R5020B_PartnersBalance
		|from Doc AS Doc
		|where Doc.IsAdvanceVendor_Send or Doc.IsAdvanceCustomer_Send
		|     or Doc.IsTransactionVendor_Send or Doc.IsTransactionCustomer_Send
		|		or Doc.IsOther_Send
		|union all
		|
		|select 
		|	VALUE(AccumulationRecordType.Expense),
		|	Doc.Period,
		|	Doc.ReceiveUUID,
		|	Doc.Company,
		|	Doc.ReceiveBranch,
		|	Doc.ReceivePartner,
		|	Doc.ReceiveLegalName,
		|	Doc.ReceiveAgreement,
		|	Doc.ReceiveBasisDocument,
		|	Doc.ReceiveCurrency,
		|	0 AS Amount,
		|	case when Doc.IsTransactionCustomer_Receive then Doc.ReceiveAmount else 0 end AS CustomerTransaction,
		|	case when Doc.IsAdvanceCustomer_Receive then Doc.ReceiveAmount else 0 end AS CustomerAdvance,
		|	case when Doc.IsTransactionVendor_Receive then Doc.SendAmount else 0 end AS VendorTransaction,
		|	case when Doc.IsAdvanceVendor_Receive then Doc.ReceiveAmount else 0 end AS VendorAdvance,
		|	case when Doc.IsOther_Receive then Doc.ReceiveAmount else 0 end AS OtherTransaction,
		|	UNDEFINED AS AdvancesClosing
		|
		|from Doc AS Doc
		|where Doc.IsAdvanceVendor_Receive or Doc.IsAdvanceCustomer_Receive 
		|	   or Doc.IsTransactionVendor_Receive or Doc.IsTransactionCustomer_Receive
		|		or Doc.IsOther_Receive
		|union all
		|
		// vendor advance
		|
		|SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Receipt)
		|		ELSE VALUE(AccumulationRecordType.Expense)
		|	END,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.Agreement,
		|	UNDEFINED,
		|	OffsetOfAdvances.Currency,
		|
		|	0,
		|	0 AS CustomerTransaction,
		|	0 as CustomerAdvance,
		|	0 AS VendorTransaction,
		|	case when &IsAdvanceVendor_Send or &IsAdvanceVendor_Receive then OffsetOfAdvances.Amount else 0 end AS VendorAdvance,
		|	0 AS OtherTransaction,
		|
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing
		|
		|union all
		|
		// vendor transaction
		|
		|SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.Agreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Currency,
		|
		|	0,
		|	0 AS CustomerTransaction,
		|	0 as CustomerAdvance,
		|	case when &IsTransactionVendor_Send or &IsTransactionVendor_Receive then OffsetOfAdvances.Amount else 0 end AS VendorTransaction,
		|	0 VendorAdvance,
		|	0 AS OtherTransaction,
		|
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing
		|
		|
		|union all
		|
		//customer advance
		|
		|SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.Agreement,
		|	UNDEFINED,
		|	OffsetOfAdvances.Currency,
		|
		|	0,
		|	0 AS CustomerTransaction,
		|	case when &IsAdvanceCustomer_Send or &IsAdvanceCustomer_Receive then OffsetOfAdvances.Amount else 0 end AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing
		|
		|union all
		|
		// customer transaction
		|
		|SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Receipt)
		|		ELSE VALUE(AccumulationRecordType.Expense)
		|	END,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.Agreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Currency,
		|
		|	0,
		|	case when &IsTransactionCustomer_Send or &IsTransactionCustomer_Receive then OffsetOfAdvances.Amount else 0 end AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing
		|";
EndFunction

#EndRegion

#Region AccessObject

// Get access key.
// 
// Parameters:
//  Obj - DocumentObjectDocumentName -
// 
// Returns:
//  Map
Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	AccessKeyMap.Insert("Company", Obj.Company);
	BranchArray = New Array;
	BranchArray.Add(Obj.Branch);
	BranchArray.Add(Obj.ReceiveBranch);
	AccessKeyMap.Insert("Branch", BranchArray);
	Return AccessKeyMap;
EndFunction

#EndRegion

#Region Accounting

Function T1040T_AccountingAmounts()
	Return 
		"SELECT
		|	Doc.Period AS Period,
		|	UNDEFINED AS RowKey,
		|	Doc.SendUUID AS Key,
		|	Doc.SendCurrency AS Currency,
		|	Doc.SendAmount AS Amount,
		|	VALUE(Catalog.AccountingOperations.DebitCreditNote_R5020B_PartnersBalance) AS Operation,
		|
		|	Doc.SendCurrency as DrCurrency,
		|	Doc.SendAmount as DrCurrencyAmount,
		|
		|	Doc.ReceiveCurrency as CrCurrency,
		|	Doc.ReceiveAmount as CrCurrencyAmount,
		|		
		|	UNDEFINED AS AdvancesClosing
		|INTO T1040T_AccountingAmounts
		|FROM
		|	Doc AS Doc
//		|WHERE
//		|	Doc.Ref = &Ref
		|
		|UNION ALL
		|
		|SELECT
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.Amount,
		|	VALUE(Catalog.AccountingOperations.DebitCreditNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors_Offset),
		|	UNDEFINED,
		|	0,
		|	UNDEFINED,
		|	0,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing
		|
		|UNION ALL
		|
		|SELECT
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.Amount,
		|	VALUE(Catalog.AccountingOperations.DebitCreditNote_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions_Offset),
		|	UNDEFINED,
		|	0,
		|	UNDEFINED,
		|	0,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing";
	
	
	
//		"SELECT
//		|	Doc.Date AS Period,
//		|	UNDEFINED AS RowKey,
//		|	Doc.SendUUID AS Key,
//		|	Doc.SendCurrency AS Currency,
//		|	Doc.SendAmount AS Amount,
//		|	VALUE(Catalog.AccountingOperations.DebitCreditNote_R5020B_PartnersBalance) AS Operation,
//		|
//		|	case 
//		|	when Doc.SendDebtType in (&ArrayOfReceivable) then  Doc.ReceiveCurrency
//		|	when Doc.SendDebtType in (&ArrayOfPayable) then     Doc.SendCurrency
//		|	end as DrCurrency,
//		|
//		|	case 
//		|	when Doc.SendDebtType in (&ArrayOfReceivable) then Doc.ReceiveAmount
//		|	when Doc.SendDebtType in (&ArrayOfPayable) then    Doc.SendAmount
//		|	end as DrCurrencyAmount,
//		|
//		|	case 
//		|	when Doc.SendDebtType in (&ArrayOfReceivable) then Doc.SendCurrency
//		|	when Doc.SendDebtType in (&ArrayOfPayable) then    Doc.ReceiveCurrency
//		|	end as CrCurrency,
//		|
//		|	case 
//		|	when Doc.SendDebtType in (&ArrayOfReceivable) then Doc.SendAmount
//		|	when Doc.SendDebtType in (&ArrayOfPayable) then    Doc.ReceiveAmount
//		|	end as CrCurrencyAmount,
//		|		
//		|	UNDEFINED AS AdvancesClosing
//		|INTO T1040T_AccountingAmounts
//		|FROM
//		|	Document.DebitCreditNote AS Doc
//		|WHERE
//		|	Doc.Ref = &Ref
//		|
//		|UNION ALL
//		|
//		|SELECT
//		|	OffsetOfAdvances.Period,
//		|	OffsetOfAdvances.Key,
//		|	OffsetOfAdvances.Key,
//		|	OffsetOfAdvances.Currency,
//		|	OffsetOfAdvances.Amount,
//		|	VALUE(Catalog.AccountingOperations.DebitCreditNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors_Offset),
//		|	UNDEFINED,
//		|	0,
//		|	UNDEFINED,
//		|	0,
//		|	OffsetOfAdvances.Recorder
//		|FROM
//		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
//		|WHERE
//		|	OffsetOfAdvances.Document = &Ref
//		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing
//		|
//		|UNION ALL
//		|
//		|SELECT
//		|	OffsetOfAdvances.Period,
//		|	OffsetOfAdvances.Key,
//		|	OffsetOfAdvances.Key,
//		|	OffsetOfAdvances.Currency,
//		|	OffsetOfAdvances.Amount,
//		|	VALUE(Catalog.AccountingOperations.DebitCreditNote_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions_Offset),
//		|	UNDEFINED,
//		|	0,
//		|	UNDEFINED,
//		|	0,
//		|	OffsetOfAdvances.Recorder
//		|FROM
//		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
//		|WHERE
//		|	OffsetOfAdvances.Document = &Ref
//		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	AO = Catalogs.AccountingOperations;
	
	If Parameters.Operation = AO.DebitCreditNote_R5020B_PartnersBalance Then
		Return GetAnalytics_R5020B_PartnersBalance(Parameters);
	ElsIf Parameters.Operation = AO.DebitCreditNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors_Offset Then 
		Return GetAnalytics_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors_Offset(Parameters);
	ElsIf Parameters.Operation = AO.DebitCreditNote_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions_Offset Then
		Return GetAnalytics_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions_Offset(Parameters);
	ElsIf Parameters.Operation = AO.DebitCreditNote_DR_R5020B_PartnersBalance_CR_R5021_Revenues Then
		Return GetAnalytics_DR_R5020B_PartnersBalance_CR_R5021_Revenues(Parameters);
	ElsIf Parameters.Operation = AO.DebitCreditNote_DR_R5022T_Expenses_CR_R5020B_PartnersBalance Then
		Return GetAnalytics_DR_R5022T_Expenses_CR_R5020B_PartnersBalance(Parameters);
	EndIf;
	
	Return Undefined;
EndFunction

#Region Accounting_Analytics

Function GetAdditionalAnalytics(Parameters)
	// Sender
	Sender = New Structure();
	Sender.Insert("Partner"       , Parameters.ObjectData.SendPartner);
	Sender.Insert("LegalName"     , Parameters.ObjectData.SendLegalName);
	Sender.Insert("Agreement"     , Parameters.ObjectData.SendAgreement);
	Sender.Insert("Contract"      , Parameters.ObjectData.SendLegalNameContract);
	Sender.Insert("Order"         , Parameters.ObjectData.SendOrder);
	Sender.Insert("BasisDocument" , Parameters.ObjectData.SendBasisDocument);
	Sender.Insert("Currency"      , Parameters.ObjectData.SendCurrency);
	
	// Receiver
	Receiver = New Structure();
	Receiver.Insert("Partner"       , Parameters.ObjectData.ReceivePartner);
	Receiver.Insert("LegalName"     , Parameters.ObjectData.ReceiveLegalName);
	Receiver.Insert("Agreement"     , Parameters.ObjectData.ReceiveAgreement);
	Receiver.Insert("Contract"      , Parameters.ObjectData.ReceiveLegalNameContract);
	Receiver.Insert("Order"         , Parameters.ObjectData.ReceiveOrder);
	Receiver.Insert("BasisDocument" , Parameters.ObjectData.ReceiveBasisDocument);
	Receiver.Insert("Currency"      , Parameters.ObjectData.ReceiveCurrency);
	
	Return New Structure("Sender, Receiver", Sender, Receiver);
EndFunction

Function GetAccountVariantsMapping()
	Mapping = New Map();
	Mapping.Insert(Enums.DebtTypes.AdvanceVendor          , "AccountAdvancesVendor");
	Mapping.Insert(Enums.DebtTypes.TransactionCustomer    , "AccountTransactionsCustomer");
	Mapping.Insert(Enums.DebtTypes.OtherPartnerReceivable , "AccountTransactionsOther");
	Mapping.Insert(Enums.DebtTypes.EmployeeReceivable     , "AccountCashAdvance");
	Mapping.Insert(Enums.DebtTypes.TransactionVendor      , "AccountTransactionsVendor");
	Mapping.Insert(Enums.DebtTypes.AdvanceCustomer        , "AccountAdvancesCustomer");
	Return Mapping;
EndFunction
	
Function GetAnalytics_R5020B_PartnersBalance(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
	
	AdditionalAnalytics = GetAdditionalAnalytics(Parameters);	
	Debit_Analytics = AdditionalAnalytics.Sender;
	Credit_Analytics = AdditionalAnalytics.Receiver;
			
	//QueryParams = GetAdditionalQueryParameters(Undefined);
	//Ref = QueryParams.Ref;
		
	AccountVariantsMapping = GetAccountVariantsMapping();
	Debit_AccountKey = AccountVariantsMapping.Get(Parameters.ObjectData.SendDebtType);
	Credit_AccountKey = AccountVariantsMapping.Get(Parameters.ObjectData.ReceiveDebtType);

	If Parameters.ObjectData.SendDebtType = Enums.DebtTypes.AdvanceVendor Then
		Debit_AccountKey = "AccountAdvancesVendor";
	EndIf;
	
	If Parameters.ObjectData.ReceiveDebtType = Enums.DebtTypes.AdvanceVendor Then 
		Credit_AccountKey = "AccountAdvancesVendor";
	EndIf;
		
//	If QueryParams.ArrayOfReceivable.Find(Parameters.ObjectData.SendDebtType) <> Undefined Then
//		Credit_Analytics  = AdditionalAnalytics.Sender;
//		Credit_AccountKey = AccountVariantsMapping.Get(Parameters.ObjectData.SendDebtType);
//		Debit_Analytics   = AdditionalAnalytics.Receiver;
//		Debit_AccountKey  = AccountVariantsMapping.Get(Parameters.ObjectData.ReceiveDebtType);
//	ElsIf QueryParams.ArrayOfPayable.Find(Parameters.ObjectData.SendDebtType) <> Undefined Then		 
//		Debit_Analytics   = AdditionalAnalytics.Sender;
//		Debit_AccountKey  = AccountVariantsMapping.Get(Parameters.ObjectData.SendDebtType);
//		Credit_Analytics  = AdditionalAnalytics.Receiver;
//		Credit_AccountKey = AccountVariantsMapping.Get(Parameters.ObjectData.ReceiveDebtType);		
//	Else
//		Raise StrTemplate("Unsupported send debt type[%1]", Parameters.ObjectData.SendDebtType);
//	EndIf; 

	If Debit_AccountKey = Undefined Then
		Raise "Error determine Debit account key";
	EndIf;
	
	If Credit_AccountKey = Undefined Then
		Raise "Error determine Credit account key";
	EndIf;
	
	If Upper(Debit_AccountKey) = Upper("AccountCashAdvance") Then
		Debit_AccountVariants = AccountingServer.GetT9016S_AccountsEmployee(AccountParameters, 
			Debit_Analytics.Partner);
	Else
		Debit_AccountVariants = AccountingServer.GetT9012S_AccountsPartner(AccountParameters,
			Debit_Analytics.Partner,
			Debit_Analytics.Agreement,
			Debit_Analytics.Currency);
	EndIf;
	
	If Upper(Credit_AccountKey) = Upper("AccountCashAdvance") Then
		Credit_AccountVariants = AccountingServer.GetT9016S_AccountsEmployee(AccountParameters, 
			Credit_Analytics.Partner);
	Else
		Credit_AccountVariants = AccountingServer.GetT9012S_AccountsPartner(AccountParameters,
			Credit_Analytics.Partner,
			Credit_Analytics.Agreement,
			Credit_Analytics.Currency);
	EndIf;
	
	AccountingAnalytics.Debit = Debit_AccountVariants[Debit_AccountKey];
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, Debit_Analytics);
	
	AccountingAnalytics.Credit = Credit_AccountVariants[Credit_AccountKey];
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, Credit_Analytics);
	
	Return AccountingAnalytics;


//	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
//	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
//	
//	AdditionalAnalytics = GetAdditionalAnalytics(Parameters);
//	AccountVariantsMapping = GetAccountVariantsMapping();
//			
//	QueryParams = GetAdditionalQueryParameters(Undefined);
//	
//	Debit_AccountKey = Undefined;
//	Credit_AccountKey = Undefined;
//	
//	If QueryParams.ArrayOfReceivable.Find(Parameters.ObjectData.SendDebtType) <> Undefined Then
//		Credit_Analytics  = AdditionalAnalytics.Sender;
//		Credit_AccountKey = AccountVariantsMapping.Get(Parameters.ObjectData.SendDebtType);
//		Debit_Analytics   = AdditionalAnalytics.Receiver;
//		Debit_AccountKey  = AccountVariantsMapping.Get(Parameters.ObjectData.ReceiveDebtType);
//	ElsIf QueryParams.ArrayOfPayable.Find(Parameters.ObjectData.SendDebtType) <> Undefined Then		 
//		Debit_Analytics   = AdditionalAnalytics.Sender;
//		Debit_AccountKey  = AccountVariantsMapping.Get(Parameters.ObjectData.SendDebtType);
//		Credit_Analytics  = AdditionalAnalytics.Receiver;
//		Credit_AccountKey = AccountVariantsMapping.Get(Parameters.ObjectData.ReceiveDebtType);		
//	Else
//		Raise StrTemplate("Unsupported send debt type[%1]", Parameters.ObjectData.SendDebtType);
//	EndIf; 
//
//	If Debit_AccountKey = Undefined Then
//		Raise "Error determine Debit account key";
//	EndIf;
//	
//	If Credit_AccountKey = Undefined Then
//		Raise "Error determine Credit account key";
//	EndIf;
//	
//	If Upper(Debit_AccountKey) = Upper("AccountCashAdvance") Then
//		Debit_AccountVariants = AccountingServer.GetT9016S_AccountsEmployee(AccountParameters, 
//			Debit_Analytics.Partner);
//	Else
//		Debit_AccountVariants = AccountingServer.GetT9012S_AccountsPartner(AccountParameters,
//			Debit_Analytics.Partner,
//			Debit_Analytics.Agreement,
//			Debit_Analytics.Currency);
//	EndIf;
//	
//	If Upper(Credit_AccountKey) = Upper("AccountCashAdvance") Then
//		Credit_AccountVariants = AccountingServer.GetT9016S_AccountsEmployee(AccountParameters, 
//			Credit_Analytics.Partner);
//	Else
//		Credit_AccountVariants = AccountingServer.GetT9012S_AccountsPartner(AccountParameters,
//			Credit_Analytics.Partner,
//			Credit_Analytics.Agreement,
//			Credit_Analytics.Currency);
//	EndIf;
//	
//	AccountingAnalytics.Debit = Debit_AccountVariants[Debit_AccountKey];
//	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, Debit_Analytics);
//	
//	AccountingAnalytics.Credit = Credit_AccountVariants[Credit_AccountKey];
//	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, Credit_Analytics);
//	
//	Return AccountingAnalytics;
EndFunction

// Vendors transactions - Advances to vendors (offset)
Function GetAnalytics_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors_Offset(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Partner"       , Parameters.ObjectData.ReceivePartner);
	AdditionalAnalytics.Insert("LegalName"     , Parameters.ObjectData.ReceiveLegalName);
	AdditionalAnalytics.Insert("Agreement"     , Parameters.ObjectData.ReceiveAgreement);
	AdditionalAnalytics.Insert("Contract"      , Parameters.ObjectData.ReceiveLegalNameContract);
	AdditionalAnalytics.Insert("Order"         , Parameters.ObjectData.ReceiveOrder);
	AdditionalAnalytics.Insert("BasisDocument" , Parameters.ObjectData.ReceiveBasisDocument);
	
	Accounts = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                      Parameters.ObjectData.ReceivePartner, 
	                                                      Parameters.ObjectData.ReceiveAgreement,
	                                                      Parameters.ObjectData.ReceiveCurrency);
	// Debit                                                      
	AccountingAnalytics.Debit = Accounts.AccountTransactionsVendor;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	// Credit
	AccountingAnalytics.Credit = Accounts.AccountAdvancesVendor;	
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	Return AccountingAnalytics;
EndFunction

// Advance from customer - Customer transaction (offset)
Function GetAnalytics_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions_Offset(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Partner"       , Parameters.ObjectData.ReceivePartner);
	AdditionalAnalytics.Insert("LegalName"     , Parameters.ObjectData.ReceiveLegalName);
	AdditionalAnalytics.Insert("Agreement"     , Parameters.ObjectData.ReceiveAgreement);
	AdditionalAnalytics.Insert("Contract"      , Parameters.ObjectData.ReceiveLegalNameContract);
	AdditionalAnalytics.Insert("Order"         , Parameters.ObjectData.ReceiveOrder);
	AdditionalAnalytics.Insert("BasisDocument" , Parameters.ObjectData.ReceiveBasisDocument);
	
	Accounts = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                      Parameters.ObjectData.ReceivePartner, 
	                                                      Parameters.ObjectData.ReceiveAgreement,
	                                                      Parameters.ObjectData.ReceiveCurrency);
	// Debit                                                      
	AccountingAnalytics.Debit = Accounts.AccountAdvancesCustomer;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	// Credit
	AccountingAnalytics.Credit = Accounts.AccountTransactionsCustomer;	
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	Return AccountingAnalytics;
EndFunction

Function GetAnalytics_DR_R5020B_PartnersBalance_CR_R5021_Revenues(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
	
	AdditionalAnalytics = GetAdditionalAnalytics(Parameters);
	AccountVariantsMapping = GetAccountVariantsMapping();
	
	Debit_Analytics   = AdditionalAnalytics.Receiver;
	Debit_AccountKey  = AccountVariantsMapping.Get(Parameters.ObjectData.ReceiveDebtType);
		
	If Upper(Debit_AccountKey) = Upper("AccountCashAdvance") Then
		Debit_AccountVariants = AccountingServer.GetT9016S_AccountsEmployee(AccountParameters, 
			Debit_Analytics.Partner);
	Else
		Debit_AccountVariants = AccountingServer.GetT9012S_AccountsPartner(AccountParameters,
			Debit_Analytics.Partner,
			Debit_Analytics.Agreement,
			Debit_Analytics.Currency);
	EndIf;
			
	AdditionalAnalytics_Revenue = New Structure();
	AdditionalAnalytics_Revenue.Insert("RevenueType"  , Parameters.ObjectData.RevenueType);
	AdditionalAnalytics_Revenue.Insert("ProfitCenter" , Parameters.ObjectData.ProfitCenter);
	
	Accounts_Revenue = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.RevenueType,
	                                                          Parameters.ObjectData.ProfitCenter);
		
	AccountingAnalytics.Debit = Debit_AccountVariants[Debit_AccountKey];
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, Debit_Analytics);

	// Credit
	AccountingAnalytics.Credit = Accounts_Revenue.AccountRevenue;	
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics_Revenue);	
	
	Return AccountingAnalytics;
EndFunction

Function GetAnalytics_DR_R5022T_Expenses_CR_R5020B_PartnersBalance(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
	
	AdditionalAnalytics = GetAdditionalAnalytics(Parameters);
	AccountVariantsMapping = GetAccountVariantsMapping();
	
	Credit_Analytics   = AdditionalAnalytics.Receiver;
	Credit_AccountKey  = AccountVariantsMapping.Get(Parameters.ObjectData.ReceiveDebtType);
		
	If Upper(Credit_AccountKey) = Upper("AccountCashAdvance") Then
		Credit_AccountVariants = AccountingServer.GetT9016S_AccountsEmployee(AccountParameters, Credit_Analytics.Partner);
	Else
		Credit_AccountVariants = AccountingServer.GetT9012S_AccountsPartner(AccountParameters,
			Credit_Analytics.Partner,
			Credit_Analytics.Agreement,
			Credit_Analytics.Currency);
	EndIf;
	
	AdditionalAnalytics_Expense = New Structure();
	AdditionalAnalytics_Expense.Insert("ExpenseType" , Parameters.ObjectData.ExpenseType);
	AdditionalAnalytics_Expense.Insert("LossCenter"  , Parameters.ObjectData.LossCenter);
	
	Accounts_Expense = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.ExpenseType,
	                                                          Parameters.ObjectData.LossCenter);
	
	// Debit                                                      
	AccountingAnalytics.Debit = Accounts_Expense.AccountExpense;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics_Expense);

	// Credit
	AccountingAnalytics.Credit = Credit_AccountVariants[Credit_AccountKey];	
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, Credit_Analytics);	
	
	Return AccountingAnalytics;
EndFunction

Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value, AdditionalAnalytics, Number) Export
	Return Value;
EndFunction

Function GetHintCreditExtDimension(Parameters, ExtDimensionType, Value, AdditionalAnalytics, Number) Export
	Return Value;
EndFunction

#EndRegion

#EndRegion