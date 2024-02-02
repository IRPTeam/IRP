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

Function T2014S_AdvancesInfo_SOC() Export
	Return 
		"SELECT DISTINCT
		|	&Period AS Date,
		|	TRUE AS IsCustomerAdvance,
		|	TRUE AS IsSalesOrderClose,
		|	CloseOrderItemList.Ref.SalesOrder.Company AS Company,
		|	CloseOrderItemList.Ref.SalesOrder.Branch AS Branch,
		|	CloseOrderItemList.Ref.SalesOrder.Currency AS Currency,
		|	CloseOrderItemList.Ref.SalesOrder.Partner AS Partner,
		|	CloseOrderItemList.Ref.SalesOrder.LegalName AS LegalName,
		|	CASE
		|		WHEN CloseOrderItemList.Ref.SalesOrder.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN CloseOrderItemList.Ref.SalesOrder.Agreement
		|		ELSE UNDEFINED
		|	END AS AdvanceAgreement,
		|	CloseOrderItemList.Ref.SalesOrder AS Order,
		|	CloseOrderItemList.Project AS Project
		|INTO T2014S_AdvancesInfo
		|FROM
		|	Document.SalesOrderClosing.ItemList AS CloseOrderItemList
		|WHERE
		|	CloseOrderItemList.Ref = &Ref";
EndFunction

Function T2014S_AdvancesInfo_POC() Export
	Return 
		"SELECT DISTINCT
		|	&Period AS Date,
		|	TRUE AS IsVendorAdvance,
		|	TRUE AS IsPurchaseOrderClose,
		|	CloseOrderItemList.Ref.PurchaseOrder.Company AS Company,
		|	CloseOrderItemList.Ref.PurchaseOrder.Branch AS Branch,
		|	CloseOrderItemList.Ref.PurchaseOrder.Currency AS Currency,
		|	CloseOrderItemList.Ref.PurchaseOrder.Partner AS Partner,
		|	CloseOrderItemList.Ref.PurchaseOrder.LegalName AS LegalName,
		|	CASE
		|		WHEN CloseOrderItemList.Ref.PurchaseOrder.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN CloseOrderItemList.Ref.PurchaseOrder.Agreement
		|		ELSE UNDEFINED
		|	END AS AdvanceAgreement,
		|	CloseOrderItemList.Ref.PurchaseOrder AS Order,
		|	CloseOrderItemList.Project AS Project
		|INTO T2014S_AdvancesInfo
		|FROM
		|	Document.PurchaseOrderClosing.ItemList AS CloseOrderItemList
		|WHERE
		|	CloseOrderItemList.Ref = &Ref";
EndFunction
