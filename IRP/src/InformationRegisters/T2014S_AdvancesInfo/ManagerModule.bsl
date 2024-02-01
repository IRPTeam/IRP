#Region AccessObject

// Get access key.
// See Role.TemplateInformationRegisters
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

Function T2014S_AdvancesInfo_BP_CP() Export
	Return 
		"SELECT
		|	PaymentList.Period AS Date,
		|	PaymentList.Key,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Currency,
		|	PaymentList.Partner,
		|	PaymentList.LegalName,
		|	PaymentList.Order,
		|	TRUE AS IsVendorAdvance,
		|	FALSE AS IsCustomerAdvance,
		|	PaymentList.AdvanceAgreement,
		|	PaymentList.Project,
		|	PaymentList.Amount
		|INTO T2014S_AdvancesInfo
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsPaymentToVendor
		|	AND PaymentList.IsAdvance
		|
		|UNION ALL
		|
		|SELECT
		|	PaymentList.Period,
		|	PaymentList.Key,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Currency,
		|	PaymentList.Partner,
		|	PaymentList.LegalName,
		|	UNDEFINED,
		|	FALSE,
		|	TRUE,
		|	PaymentList.AdvanceAgreement,
		|	PaymentList.Project,
		|	-PaymentList.Amount AS Amount
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	(PaymentList.IsReturnToCustomer
		|	OR PaymentList.IsReturnToCustomerByPOS)
		|	AND PaymentList.IsAdvance";
EndFunction

Function T2014S_AdvancesInfo_BR_CR() Export
	Return "SELECT
		   |	PaymentList.Period AS Date,
		   |	PaymentList.Key,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Currency,
		   |	PaymentList.Partner,
		   |	PaymentList.LegalName,
		   |	PaymentList.AdvanceAgreement,
		   |	PaymentList.Project,
		   |	PaymentList.Order,
		   |	TRUE AS IsCustomerAdvance,
		   |	FALSE AS IsVendorAdvance,
		   |	PaymentList.Amount
		   |INTO T2014S_AdvancesInfo
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	(PaymentList.IsPaymentFromCustomer OR PaymentList.IsPaymentFromCustomerByPOS)
		   |	AND PaymentList.IsAdvance
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	PaymentList.Period,
		   |	PaymentList.Key,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Currency,
		   |	PaymentList.Partner,
		   |	PaymentList.LegalName,
		   |	PaymentList.AdvanceAgreement,
		   |	PaymentList.Project,
		   |	UNDEFINED,
		   |	FALSE,
		   |	TRUE,
		   |	-PaymentList.Amount AS Amount
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsReturnFromVendor
		   |	AND PaymentList.IsAdvance";
EndFunction

Function T2014S_AdvancesInfo_DebitNote() Export
	Return 
		"SELECT
		|	Transactions.Period AS Date,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Partner,
		|	Transactions.LegalName,
		|	Transactions.Currency,
		|	Transactions.AdvanceAgreement,
		|	Transactions.Project,
		|	Transactions.Key,
		|	Transactions.Amount,
		|	TRUE AS IsVendorAdvance
		|INTO T2014S_AdvancesInfo
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsVendor";
EndFunction

Function T2014S_AdvancesInfo_CreditNote() Export
	Return 
		"SELECT
		|	Transactions.Period AS Date,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Partner,
		|	Transactions.LegalName,
		|	Transactions.Currency,
		|	Transactions.AdvanceAgreement,
		|	Transactions.Project,
		|	TRUE AS IsCustomerAdvance,
		|	Transactions.Key,
		|	Transactions.Amount
		|INTO T2014S_AdvancesInfo
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsCustomer";
EndFunction

Function T2014S_AdvancesInfo_Cheque() Export 
	Return 
		"SELECT
		|	Table.Period AS Date,
		|	Table.Company,
		|	Table.Branch,
		|	Table.Currency,
		|	Table.Partner,
		|	Table.LegalName,
		|	Table.AdvanceAgreement,
		|	Table.Project,
		|	Table.Order,
		|	TRUE AS IsCustomerAdvance,
		|	FALSE AS IsVendorAdvance,
		|	Table.Amount
		|INTO T2014S_AdvancesInfo
		|FROM
		|	CustomerTransaction_Posting AS Table
		|WHERE
		|	Table.IsIncomingCheque
		|	AND Table.IsAdvance
		|
		|UNION ALL
		|
		|SELECT
		|	Table.Period,
		|	Table.Company,
		|	Table.Branch,
		|	Table.Currency,
		|	Table.Partner,
		|	Table.LegalName,
		|	Table.AdvanceAgreement,
		|	Table.Project,
		|	Table.Order,
		|	TRUE,
		|	FALSE,
		|	-Table.Amount
		|FROM
		|	CustomerTransaction_Reversal AS Table
		|WHERE
		|	Table.IsIncomingCheque
		|	AND Table.IsAdvance
		|
		|UNION ALL
		|
		|SELECT
		|	Table.Period,
		|	Table.Company,
		|	Table.Branch,
		|	Table.Currency,
		|	Table.Partner,
		|	Table.LegalName,
		|	Table.AdvanceAgreement,
		|	Table.Project,
		|	Table.Order,
		|	TRUE,
		|	FALSE,
		|	-Table.Amount
		|FROM
		|	CustomerTransaction_Correction AS Table
		|WHERE
		|	Table.IsIncomingCheque
		|	AND Table.IsAdvance
		|
		|UNION ALL
		|
		|SELECT
		|	Table.Period,
		|	Table.Company,
		|	Table.Branch,
		|	Table.Currency,
		|	Table.Partner,
		|	Table.LegalName,
		|	Table.AdvanceAgreement,
		|	Table.Project,
		|	Table.Order,
		|	FALSE,
		|	TRUE,
		|	Table.Amount
		|FROM
		|	VendorTransaction_Posting AS Table
		|WHERE
		|	Table.IsOutgoingCheque
		|	AND Table.IsAdvance
		|
		|UNION ALL
		|
		|SELECT
		|	Table.Period,
		|	Table.Company,
		|	Table.Branch,
		|	Table.Currency,
		|	Table.Partner,
		|	Table.LegalName,
		|	Table.AdvanceAgreement,
		|	Table.Project,
		|	Table.Order,
		|	FALSE,
		|	TRUE,
		|	-Table.Amount
		|FROM
		|	VendorTransaction_Reversal AS Table
		|WHERE
		|	Table.IsOutgoingCheque
		|	AND Table.IsAdvance
		|
		|UNION ALL
		|
		|SELECT
		|	Table.Period,
		|	Table.Company,
		|	Table.Branch,
		|	Table.Currency,
		|	Table.Partner,
		|	Table.LegalName,
		|	Table.AdvanceAgreement,
		|	Table.Project,
		|	Table.Order,
		|	FALSE,
		|	TRUE,
		|	-Table.Amount
		|FROM
		|	VendorTransaction_Correction AS Table
		|WHERE
		|	Table.IsOutgoingCheque
		|	AND Table.IsAdvance";
EndFunction
