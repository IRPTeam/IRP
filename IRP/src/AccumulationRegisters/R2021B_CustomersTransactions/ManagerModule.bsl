// BSLLS-off
#Region AccessObject

// Get access key.
// See Role.TemplateAccumulationRegisters - Parameters orders has to be the same
// 
// Returns:
//  Structure - Get access key:
// * Company - CatalogRef.Companies -
// * Branch - CatalogRef.BusinessUnits -
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	AccessKeyStructure.Insert("Company", Catalogs.Companies.EmptyRef());
	AccessKeyStructure.Insert("Branch", Catalogs.BusinessUnits.EmptyRef());
	Return AccessKeyStructure;
EndFunction

#EndRegion

Function R2021B_CustomersTransactions_BP_CP() Export
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Partner,
		|	PaymentList.LegalName,
		|	PaymentList.Currency,
		|	PaymentList.Agreement,
		|	PaymentList.Project,
		|	PaymentList.TransactionDocument AS Basis,
		|	PaymentList.Key,
		|	-PaymentList.Amount AS Amount,
		|	UNDEFINED AS CustomersAdvancesClosing
		|INTO R2021B_CustomersTransactions
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	(PaymentList.IsReturnToCustomer
		|	OR PaymentList.IsReturnToCustomerByPOS)
		|	AND NOT PaymentList.IsAdvance
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
		|	OffsetOfAdvances.TransactionAgreement,
		|	OffsetOfAdvances.TransactionProject,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing";
EndFunction

Function R2021B_CustomersTransactions_BR_CR() Export
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Partner,
		|	PaymentList.LegalName,
		|	PaymentList.Currency,
		|	PaymentList.Agreement,
		|	PaymentList.Project,
		|	PaymentList.TransactionDocument AS Basis,
		|	PaymentList.OrderSettlements AS Order,
		|	PaymentList.Key,
		|	PaymentList.Amount AS Amount,
		|	UNDEFINED AS CustomersAdvancesClosing
		|INTO R2021B_CustomersTransactions
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	(PaymentList.IsPaymentFromCustomer
		|	OR PaymentList.IsPaymentFromCustomerByPOS)
		|	AND NOT PaymentList.IsAdvance
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
		|	OffsetOfAdvances.TransactionAgreement,
		|	OffsetOfAdvances.TransactionProject,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.TransactionOrder,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing";
EndFunction

Function R2021B_CustomersTransactions_SI_SRFTA() Export
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.LegalName,
		|	ItemList.Partner,
		|	ItemList.Agreement,
		|	ItemList.Project,
		|	ItemList.Basis,
		|	ItemList.SalesOrderSettlements AS Order,
		|	SUM(ItemList.Amount) AS Amount,
		|	UNDEFINED AS CustomersAdvancesClosing
		|INTO R2021B_CustomersTransactions
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsSales
		|GROUP BY
		|	ItemList.Agreement,
		|	ItemList.Project,
		|	ItemList.Basis,
		|	ItemList.SalesOrderSettlements,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.LegalName,
		|	ItemList.Partner,
		|	ItemList.Period,
		|	VALUE(AccumulationRecordType.Receipt)
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
		|	OffsetOfAdvances.TransactionAgreement,
		|	OffsetOfAdvances.TransactionProject,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.TransactionOrder,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing";
EndFunction

Function R2021B_CustomersTransactions_SR() Export 
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.LegalName,
		|	ItemList.Partner,
		|	ItemList.Agreement,
		|	ItemList.Project,
		|	ItemList.BasisDocument AS Basis,
		|	UNDEFINED AS Key,
		|	UNDEFINED AS CustomersAdvancesClosing,
		|	-SUM(ItemList.Amount) AS Amount
		|INTO R2021B_CustomersTransactions
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsReturnFromCustomer
		|GROUP BY
		|	ItemList.Agreement,
		|	ItemList.Project,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.LegalName,
		|	ItemList.Partner,
		|	ItemList.Period,
		|	ItemList.BasisDocument,
		|	VALUE(AccumulationRecordType.Receipt)
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
		|	OffsetOfAdvances.TransactionAgreement,
		|	OffsetOfAdvances.TransactionProject,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Recorder,
		|	OffsetOfAdvances.Amount
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing";
EndFunction

Function R2021B_CustomersTransactions_SOC() Export
	Return 
		"SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Receipt)
		|		ELSE VALUE(AccumulationRecordType.Expense)
		|	END AS RecordType,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.TransactionAgreement AS Agreement,
		|	OffsetOfAdvances.TransactionProject AS Project,
		|	OffsetOfAdvances.TransactionDocument AS Basis,
		|	OffsetOfAdvances.TransactionOrder AS Order,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Recorder AS VendorsAdvancesClosing
		|INTO R2021B_CustomersTransactions
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND NOT OffsetOfAdvances.IsAdvanceRelease
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing";
EndFunction

Function R2021B_CustomersTransactions_DebitNote() Export
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	Transactions.Period,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Currency,
		|	Transactions.LegalName,
		|	Transactions.Partner,
		|	Transactions.Agreement,
		|	Transactions.Project,
		|	Transactions.BasisDocument AS Basis,
		|	UNDEFINED AS Order,
		|	Transactions.Amount AS Amount,
		|	UNDEFINED AS CustomersAdvancesClosing,
		|	Transactions.Key AS Key
		|INTO R2021B_CustomersTransactions
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsCustomer
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
		|	OffsetOfAdvances.TransactionAgreement,
		|	OffsetOfAdvances.TransactionProject,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.TransactionOrder,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Recorder,
		|	OffsetOfAdvances.Key
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing";
EndFunction

Function R2021B_CustomersTransactions_CreditNote() Export
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	Transactions.Period,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Currency,
		|	Transactions.LegalName,
		|	Transactions.Partner,
		|	Transactions.Agreement,
		|	Transactions.Project,
		|	UNDEFINED AS Order,
		|	Transactions.BasisDocument AS Basis,
		|	Transactions.Key AS Key,
		|	UNDEFINED AS CustomersAdvancesClosing,
		|	-Transactions.Amount AS Amount
		|INTO R2021B_CustomersTransactions
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsCustomer
		|
		|UNION ALL
		|
		|SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Receipt)
		|		ELSE VALUE(AccumulationRecordType.Expense)
		|	END AS RecordType,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.TransactionAgreement AS Agreement,
		|	OffsetOfAdvances.TransactionProject AS Project,
		|	OffsetOfAdvances.TransactionOrder AS Order,
		|	OffsetOfAdvances.TransactionDocument AS Basis,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Recorder AS CustomersAdvancesClosing,
		|	OffsetOfAdvances.Amount
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing";
EndFunction

Function R2021B_CustomersTransactions_DebitCreditNote() Export
	Return
		"SELECT
		|case when Doc.PartnersIsEqual then
		|	case
		|		when Doc.IsReceiveAdvanceVendor 
		|			OR Doc.IsReceiveTransactionCustomer 
		|       then VALUE(AccumulationRecordType.Expense)
		|		else VALUE(AccumulationRecordType.Receipt) end
		|else
		|   case
		|		when  Doc.IsReceiveAdvanceVendor 
		|             OR Doc.IsReceiveTransactionVendor 
		|             OR Doc.IsReceiveTransactionCustomer 
		|		then VALUE(AccumulationRecordType.Expense)
		|		else VALUE(AccumulationRecordType.Receipt) end
		|end as RecordType,
		|
		|	Doc.Period,
		|	Doc.Company,
		|	Doc.SendBranch AS Branch,
		|	Doc.Currency,
		|	Doc.SendLegalName AS LegalName,
		|	Doc.SendPartner AS Partner,
		|	Doc.SendAgreement AS Agreement,
		|	Doc.SendProject AS Project,
		|	Doc.SendBasisDocument AS Basis,
		|	Doc.SendOrderSettlements AS Order,
		|	Doc.Amount,
		|	UNDEFINED AS CustomersAdvancesClosing
		|INTO R2021B_CustomersTransactions
		|FROM
		|	SendTransactions AS Doc
		|WHERE
		|	Doc.SendIsCustomerTransaction
		|
		|UNION ALL
		|
		|SELECT
		|case when Doc.PartnersIsEqual then
		|	case
		|		when Doc.IsSendAdvanceCustomer 
		|			OR Doc.IsSendTransactionVendor 
		|       then VALUE(AccumulationRecordType.Expense)
		|		else VALUE(AccumulationRecordType.Receipt) end
		|else
		|   case
		|		when  Doc.IsSendAdvanceCustomer 
		|             OR Doc.IsSendTransactionVendor 
		|		then VALUE(AccumulationRecordType.Expense)
		|		else VALUE(AccumulationRecordType.Receipt) end
		|end as RecordType,
		|
		|	Doc.Period,
		|	Doc.Company,
		|	Doc.ReceiveBranch,
		|	Doc.Currency,
		|	Doc.ReceiveLegalName,
		|	Doc.ReceivePartner,
		|	Doc.ReceiveAgreement,
		|	Doc.ReceiveProject,
		|	Doc.ReceiveBasisDocument,
		|	Doc.ReceiveOrderSettlements,
		|	Doc.Amount,
		|	UNDEFINED
		|FROM
		|	ReceiveTransactions AS Doc
		|WHERE
		|	Doc.SendIsCustomerTransaction
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
		|	OffsetOfAdvances.TransactionAgreement,
		|	OffsetOfAdvances.TransactionProject,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.TransactionOrder,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing";
EndFunction

Function R2021B_CustomersTransactions_Cheque() Export
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	Table.Period,
		|	Table.Company,
		|	Table.Branch,
		|	Table.Partner,
		|	Table.LegalName,
		|	Table.Currency,
		|	Table.Agreement,
		|	Table.BasisDocument AS Basis,
		|	Table.OrderSettlements AS Order,
		|	Table.Amount,
		|	UNDEFINED AS CustomersAdvancesClosing
		|INTO R2021B_CustomersTransactions
		|FROM
		|	CustomerTransaction_Posting AS Table
		|WHERE
		|	Table.IsIncomingCheque
		|	AND NOT Table.IsAdvance
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	Table.Period,
		|	Table.Company,
		|	Table.Branch,
		|	Table.Partner,
		|	Table.LegalName,
		|	Table.Currency,
		|	Table.Agreement,
		|	Table.BasisDocument,
		|	Table.OrderSettlements,
		|	Table.Amount,
		|	UNDEFINED
		|FROM
		|	CustomerTransaction_Reversal AS Table
		|WHERE
		|	Table.IsIncomingCheque
		|	AND NOT Table.IsAdvance
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	Table.Period,
		|	Table.Company,
		|	Table.Branch,
		|	Table.Partner,
		|	Table.LegalName,
		|	Table.Currency,
		|	Table.Agreement,
		|	Table.BasisDocument,
		|	Table.OrderSettlements,
		|	Table.Amount,
		|	UNDEFINED
		|FROM
		|	CustomerTransaction_Correction AS Table
		|WHERE
		|	Table.IsIncomingCheque
		|	AND NOT Table.IsAdvance
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
		|	OffsetOfAdvances.TransactionAgreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.TransactionOrder,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing";
EndFunction
