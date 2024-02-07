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

Function R2020B_AdvancesFromCustomers_BR_CR() Export
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Partner,
		|	PaymentList.LegalName,
		|	PaymentList.Currency,
		|	PaymentList.AdvanceAgreement AS Agreement,
		|	PaymentList.Project,
		|	PaymentList.Order,
		|	PaymentList.Amount,
		|	PaymentList.Key,
		|	UNDEFINED AS CustomersAdvancesClosing
		|INTO R2020B_AdvancesFromCustomers
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	(PaymentList.IsPaymentFromCustomer
		|	OR PaymentList.IsPaymentFromCustomerByPOS)
		|	AND PaymentList.IsAdvance
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
		|	OffsetOfAdvances.AdvanceAgreement,
		|	OffsetOfAdvances.AdvanceProject,
		|	OffsetOfAdvances.AdvanceOrder,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing";
EndFunction

Function R2020B_AdvancesFromCustomers_BP_CP() Export
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Partner,
		|	PaymentList.LegalName,
		|	PaymentList.AdvanceAgreement AS Agreement,
		|	PaymentList.Project,
		|	PaymentList.Currency,
		|	UNDEFINED AS Order,
		|	-PaymentList.Amount AS Amount,
		|	PaymentList.Key,
		|	UNDEFINED AS CustomersAdvancesClosing
		|INTO R2020B_AdvancesFromCustomers
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	(PaymentList.IsReturnToCustomer
		|	OR PaymentList.IsReturnToCustomerByPOS)
		|	AND PaymentList.IsAdvance
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
		|	OffsetOfAdvances.AdvanceAgreement,
		|	OffsetOfAdvances.AdvanceProject,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.AdvanceOrder,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing";
EndFunction

Function R2020B_AdvancesFromCustomers_SI_SR_SOC_SRFTA() Export
	Return 
		"SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Receipt)
		|		ELSE VALUE(AccumulationRecordType.Expense)
		|	END AS RecordType,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Recorder AS CustomersAdvancesClosing,
		|	OffsetOfAdvances.AdvanceOrder AS Order,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.AdvanceAgreement AS Agreement,
		|	OffsetOfAdvances.AdvanceProject AS Project,
		|	OffsetOfAdvances.Amount,
		|	UNDEFINED AS Key
		|INTO R2020B_AdvancesFromCustomers
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing";
EndFunction

Function R2020B_AdvancesFromCustomers_DebitNote() Export 
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
		|	OffsetOfAdvances.AdvanceAgreement AS Agreement,
		|	OffsetOfAdvances.AdvanceProject AS Project,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Recorder AS CustomersAdvancesClosing
		|INTO R2020B_AdvancesFromCustomers
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing";
EndFunction

Function R2020B_AdvancesFromCustomers_CreditNote() Export
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	Transactions.Period,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Partner,
		|	Transactions.LegalName,
		|	Transactions.Currency,
		|	Transactions.AdvanceAgreement AS Agreement,
		|	Transactions.Project,
		|	Transactions.Amount,
		|	Transactions.Key,
		|	UNDEFINED AS CustomersAdvancesClosing
		|INTO R2020B_AdvancesFromCustomers
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
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.AdvanceAgreement,
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

Function R2020B_AdvancesFromCustomers_Cheque() Export
	Return 
		"SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	Table.Period,
		   |	Table.Company,
		   |	Table.Branch,
		   |	Table.Partner,
		   |	Table.LegalName,
		   |	Table.Currency,
		   |	Table.AdvanceAgreement AS Agreement,
		   |	Table.Order,
		   |	Table.Amount,
		   |	UNDEFINED AS CustomersAdvancesClosing
		   |INTO R2020B_AdvancesFromCustomers
		   |FROM
		   |	CustomerTransaction_Posting AS Table
		   |WHERE
		   |	Table.IsIncomingCheque AND Table.IsAdvance
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
		   |	Table.AdvanceAgreement,
		   |	Table.Order,
		   |	Table.Amount,
		   |	UNDEFINED
		   |FROM
		   |	CustomerTransaction_Reversal AS Table
		   |WHERE
		   |	Table.IsIncomingCheque AND Table.IsAdvance
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
		   |	Table.AdvanceAgreement,
		   |	Table.Order,
		   |	Table.Amount,
		   |	UNDEFINED
		   |FROM
		   |	CustomerTransaction_Correction AS Table
		   |WHERE
		   |	Table.IsIncomingCheque AND Table.IsAdvance
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
		   |	OffsetOfAdvances.AdvanceAgreement,
		   |	OffsetOfAdvances.AdvanceOrder,
		   |	OffsetOfAdvances.Amount,
		   |	OffsetOfAdvances.Recorder
		   |FROM
		   |	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		   |WHERE
		   |	OffsetOfAdvances.Document = &Ref
		   |	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing";
EndFunction
