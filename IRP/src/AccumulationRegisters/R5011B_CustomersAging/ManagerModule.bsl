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

Function R5011B_CustomersAging_Offset() Export
	Return 
		"SELECT
		|	CASE
		|		WHEN OffsetOfAging.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Receipt)
		|		ELSE VALUE(AccumulationRecordType.Expense)
		|	END AS RecordType,
		|	OffsetOfAging.Period,
		|	OffsetOfAging.Company,
		|	OffsetOfAging.Branch,
		|	OffsetOfAging.Partner,
		|	OffsetOfAging.Agreement,
		|	OffsetOfAging.Currency,
		|	OffsetOfAging.Invoice,
		|	OffsetOfAging.PaymentDate,
		|	OffsetOfAging.Amount,
		|	OffsetOfAging.Recorder AS AgingClosing
		|INTO R5011B_CustomersAging
		|FROM
		|	InformationRegister.T2013S_OffsetOfAging AS OffsetOfAging
		|WHERE
		|	OffsetOfAging.Document = &Ref";
EndFunction

Function R5011B_CustomersAging_SI() Export
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentTerms.Ref.Date AS Period,
		|	PaymentTerms.Ref.Company AS Company,
		|	PaymentTerms.Ref.Branch AS Branch,
		|	PaymentTerms.Ref.Currency AS Currency,
		|	PaymentTerms.Ref.Agreement AS Agreement,
		|	PaymentTerms.Ref.Partner AS Partner,
		|	PaymentTerms.Ref AS Invoice,
		|	PaymentTerms.Date AS PaymentDate,
		|	SUM(PaymentTerms.Amount) AS Amount,
		|	UNDEFINED AS AgingClosing
		|INTO R5011B_CustomersAging
		|FROM
		|	Document.SalesInvoice.PaymentTerms AS PaymentTerms
		|WHERE
		|	PaymentTerms.Ref = &Ref
		|GROUP BY
		|	PaymentTerms.Date,
		|	PaymentTerms.Ref,
		|	PaymentTerms.Ref.Agreement,
		|	PaymentTerms.Ref.Company,
		|	PaymentTerms.Ref.Branch,
		|	PaymentTerms.Ref.Currency,
		|	PaymentTerms.Ref.Date,
		|	PaymentTerms.Ref.Partner,
		|	VALUE(AccumulationRecordType.Receipt)
		|
		|UNION ALL
		|
		|SELECT
		|	CASE
		|		WHEN OffsetOfAging.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Receipt)
		|		ELSE VALUE(AccumulationRecordType.Expense)
		|	END,
		|	OffsetOfAging.Period,
		|	OffsetOfAging.Company,
		|	OffsetOfAging.Branch,
		|	OffsetOfAging.Currency,
		|	OffsetOfAging.Agreement,
		|	OffsetOfAging.Partner,
		|	OffsetOfAging.Invoice,
		|	OffsetOfAging.PaymentDate,
		|	OffsetOfAging.Amount,
		|	OffsetOfAging.Recorder
		|FROM
		|	InformationRegister.T2013S_OffsetOfAging AS OffsetOfAging
		|WHERE
		|	OffsetOfAging.Document = &Ref";
EndFunction

Function R5011B_CustomersAging_DebitNote() Export
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	Transactions.Period,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Currency AS Currency,
		|	Transactions.Agreement AS Agreement,
		|	Transactions.Partner AS Partner,
		|	Transactions.Ref AS Invoice,
		|	Transactions.Period AS PaymentDate,
		|	SUM(Transactions.Amount) AS Amount,
		|	UNDEFINED AS AgingClosing
		|INTO R5011B_CustomersAging
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsCustomer
		|	AND Transactions.IsPostingDetail_ByDocuments
		|GROUP BY
		|	Transactions.Period,
		|	Transactions.Ref,
		|	Transactions.Agreement,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Currency,
		|	Transactions.Partner,
		|	VALUE(AccumulationRecordType.Receipt)
		|
		|UNION ALL
		|
		|SELECT
		|	CASE
		|		WHEN OffsetOfAging.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Receipt)
		|		ELSE VALUE(AccumulationRecordType.Expense)
		|	END,
		|	OffsetOfAging.Period,
		|	OffsetOfAging.Company,
		|	OffsetOfAging.Branch,
		|	OffsetOfAging.Currency,
		|	OffsetOfAging.Agreement,
		|	OffsetOfAging.Partner,
		|	OffsetOfAging.Invoice,
		|	OffsetOfAging.PaymentDate,
		|	OffsetOfAging.Amount,
		|	OffsetOfAging.Recorder
		|FROM
		|	InformationRegister.T2013S_OffsetOfAging AS OffsetOfAging
		|WHERE
		|	OffsetOfAging.Document = &Ref
		|	AND OffsetOfAging.Recorder REFS Document.CustomersAdvancesClosing";
EndFunction

Function R5011B_CustomersAging_CreditNote() Export
	Return 
		"SELECT
		|	CASE
		|		WHEN OffsetOfAging.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Receipt)
		|		ELSE VALUE(AccumulationRecordType.Expense)
		|	END AS RecordType,
		|	OffsetOfAging.Period,
		|	OffsetOfAging.Company,
		|	OffsetOfAging.Branch,
		|	OffsetOfAging.Partner,
		|	OffsetOfAging.Agreement,
		|	OffsetOfAging.Currency,
		|	OffsetOfAging.Invoice,
		|	OffsetOfAging.PaymentDate,
		|	OffsetOfAging.Amount,
		|	OffsetOfAging.Recorder AS AgingClosing
		|INTO R5011B_CustomersAging
		|FROM
		|	InformationRegister.T2013S_OffsetOfAging AS OffsetOfAging
		|WHERE
		|	OffsetOfAging.Document = &Ref
		|	AND OffsetOfAging.Recorder REFS Document.CustomersAdvancesClosing";
EndFunction

// Additional data filling.
// 
// Parameters:
//  MovementsValueTable - ValueTable
Procedure AdditionalDataFilling(MovementsValueTable) Export
	Return;	
EndProcedure
