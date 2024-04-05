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

Function T2015S_TransactionsInfo_BP_CP() Export
	Return 
		"SELECT
		|	PaymentList.Period AS Date,
		|	PaymentList.Key,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Currency,
		|	PaymentList.Partner,
		|	PaymentList.LegalName,
		|	PaymentList.Agreement,
		|	PaymentList.Project,
		|	PaymentList.OrderSettlements AS Order,
		|	TRUE AS IsVendorTransaction,
		|	FALSE AS IsCustomerTransaction,
		|	PaymentList.TransactionDocument AS TransactionBasis,
		|	PaymentList.Amount AS Amount,
		|	TRUE AS IsPaid
		|INTO T2015S_TransactionsInfo
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsPaymentToVendor
		|	AND NOT PaymentList.IsAdvance
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
		|	PaymentList.Agreement,
		|	PaymentList.Project,
		|	UNDEFINED,
		|	FALSE,
		|	TRUE,
		|	PaymentList.TransactionDocument,
		|	-PaymentList.Amount,
		|	TRUE AS IsPaid
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	(PaymentList.IsReturnToCustomer
		|	OR PaymentList.IsReturnToCustomerByPOS)
		|	AND NOT PaymentList.IsAdvance";
EndFunction

Function T2015S_TransactionsInfo_BR_CR() Export
	Return 
		"SELECT
		|	PaymentList.Period AS Date,
		|	PaymentList.Key,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Currency,
		|	PaymentList.Partner,
		|	PaymentList.LegalName,
		|	PaymentList.Agreement,
		|	PaymentList.Project,
		|	PaymentList.OrderSettlements AS Order,
		|	TRUE AS IsCustomerTransaction,
		|	FALSE AS IsVendorTransaction,
		|	PaymentList.TransactionDocument AS TransactionBasis,
		|	PaymentList.Amount AS Amount,
		|	TRUE AS IsPaid
		|INTO T2015S_TransactionsInfo
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
		|	PaymentList.Period,
		|	PaymentList.Key,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Currency,
		|	PaymentList.Partner,
		|	PaymentList.LegalName,
		|	PaymentList.Agreement,
		|	PaymentList.Project,
		|	UNDEFINED,
		|	FALSE,
		|	TRUE,
		|	PaymentList.TransactionDocument,
		|	-PaymentList.Amount,
		|	TRUE AS IsPaid
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsReturnFromVendor
		|	AND NOT PaymentList.IsAdvance";
EndFunction

Function T2015S_TransactionsInfo_DebitNote() Export 
	Return 
		"SELECT
		|	Transactions.Period AS Date,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Currency,
		|	Transactions.Partner,
		|	Transactions.LegalName,
		|	Transactions.Agreement,
		|	Transactions.Project,
		|	UNDEFINED AS Order,
		|	Transactions.BasisDocument AS TransactionBasis,
		|	Transactions.Key,
		|	TRUE AS IsCustomerTransaction,
		|	FALSE AS IsVendorTransaction,
		|	TRUE AS IsDue,
		|	SUM(Transactions.Amount) AS Amount
		|INTO T2015S_TransactionsInfo
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsCustomer
		|GROUP BY
		|	Transactions.Period,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Currency,
		|	Transactions.Partner,
		|	Transactions.LegalName,
		|	Transactions.Agreement,
		|	Transactions.Project,
		|	Transactions.BasisDocument,
		|	Transactions.Key
		|
		|UNION ALL
		|
		|SELECT
		|	Transactions.Period AS Date,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Currency,
		|	Transactions.Partner,
		|	Transactions.LegalName,
		|	Transactions.Agreement,
		|	Transactions.Project,
		|	UNDEFINED AS Order,
		|	Transactions.BasisDocument AS TransactionBasis,
		|	Transactions.Key,
		|	FALSE AS IsCustomerTransaction,
		|	TRUE AS IsVendorTransaction,
		|	TRUE AS IsDue,
		|	-SUM(Transactions.Amount) AS Amount
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsVendor
		|GROUP BY
		|	Transactions.Period,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Currency,
		|	Transactions.Partner,
		|	Transactions.LegalName,
		|	Transactions.Agreement,
		|	Transactions.Project,
		|	Transactions.BasisDocument,
		|	Transactions.Key";
EndFunction

Function T2015S_TransactionsInfo_CreditNote() Export 
	Return 
		"SELECT
		|	Transactions.Period AS Date,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Currency,
		|	Transactions.LegalName,
		|	Transactions.Partner,
		|	Transactions.Agreement,
		|	Transactions.Project,
		|	UNDEFINED AS Order,
		|	Transactions.BasisDocument AS TransactionBasis,
		|	Transactions.Key,
		|	TRUE AS IsVendorTransaction,
		|	FALSE AS IsCustomerTransaction,
		|	TRUE AS IsDue,
		|	SUM(Transactions.Amount) AS Amount
		|INTO T2015S_TransactionsInfo
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsVendor
		|GROUP BY
		|	Transactions.Period,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Currency,
		|	Transactions.Partner,
		|	Transactions.LegalName,
		|	Transactions.Agreement,
		|	Transactions.Project,
		|	Transactions.BasisDocument,
		|	Transactions.Key
		|
		|UNION ALL
		|
		|SELECT
		|	Transactions.Period,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Currency,
		|	Transactions.LegalName,
		|	Transactions.Partner,
		|	Transactions.Agreement,
		|	Transactions.Project,
		|	UNDEFINED,
		|	Transactions.BasisDocument,
		|	Transactions.Key,
		|	FALSE AS IsVendorTransaction,
		|	TRUE AS IsCustomerTransaction,
		|	TRUE AS IsDue,
		|	-SUM(Transactions.Amount) AS Amount
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsCustomer
		|GROUP BY
		|	Transactions.Period,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Currency,
		|	Transactions.Partner,
		|	Transactions.LegalName,
		|	Transactions.Agreement,
		|	Transactions.Project,
		|	Transactions.BasisDocument,
		|	Transactions.Key";
EndFunction

Function T2015S_TransactionsInfo_DebitCreditNote() Export
	Return 
		"SELECT
		|	Doc.Period AS Date,
		|	Doc.Company,
		|	Doc.SendBranch AS Branch,
		|	Doc.Currency,
		|	Doc.SendLegalName AS LegalName,
		|	Doc.SendPartner AS Partner,
		|	Doc.SendAgreement AS Agreement,
		|	Doc.SendProject AS Project,
		|	Doc.SendBasisDocument AS TransactionBasis,
		|	Doc.SendOrderSettlements AS Order,
		|	Doc.SendIsVendorTransaction AS IsVendorTransaction,
		|	Doc.SendIsCustomerTransaction AS IsCustomerTransaction,
		|	case
		|		when Doc.SendIsCustomerTransaction
		|			then case
		|				when Doc.PartnersIsEqual
		|					then case
		|						when Doc.IsReceiveAdvanceVendor
		|						OR Doc.IsReceiveTransactionCustomer
		|							then FALSE
		|						else TRUE
		|					end
		|				else case
		|					when Doc.IsReceiveAdvanceVendor
		|					OR Doc.IsReceiveTransactionVendor
		|					OR Doc.IsReceiveTransactionCustomer
		|						then FALSE
		|					else TRUE
		|				end
		|			end
		|		else case
		|			when Doc.PartnersIsEqual
		|				then case
		|					when Doc.IsReceiveAdvanceCustomer
		|					OR Doc.IsReceiveTransactionCustomer
		|					OR Doc.IsReceiveTransactionVendor
		|						then FALSE
		|					else TRUE
		|				end
		|			else case
		|				when Doc.IsReceiveAdvanceCustomer
		|				OR Doc.IsReceiveTransactionCustomer
		|				OR Doc.IsReceiveTransactionVendor
		|					then FALSE
		|				else TRUE
		|			end
		|		end
		|	end AS IsDue,
		|	case
		|		when Doc.SendIsCustomerTransaction
		|			then case
		|				when Doc.PartnersIsEqual
		|					then case
		|						when Doc.IsReceiveAdvanceVendor
		|						OR Doc.IsReceiveTransactionCustomer
		|							then TRUE
		|						else FALSE
		|					end
		|				else case
		|					when Doc.IsReceiveAdvanceVendor
		|					OR Doc.IsReceiveTransactionVendor
		|					OR Doc.IsReceiveTransactionCustomer
		|						then TRUE
		|					else FALSE
		|				end
		|			end
		|		else case
		|			when Doc.PartnersIsEqual
		|				then case
		|					when Doc.IsReceiveAdvanceCustomer
		|					OR Doc.IsReceiveTransactionCustomer
		|					OR Doc.IsReceiveTransactionVendor
		|						then TRUE
		|					else FALSE
		|				end
		|			else case
		|				when Doc.IsReceiveAdvanceCustomer
		|				OR Doc.IsReceiveTransactionCustomer
		|				OR Doc.IsReceiveTransactionVendor
		|					then TRUE
		|				else FALSE
		|			end
		|		end
		|	end AS IsPaid,
		|	Doc.Amount
		|INTO T2015S_TransactionsInfo
		|FROM
		|	SendTransactions AS Doc
		|
		|UNION ALL
		|
		|SELECT
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
		|	Doc.SendIsVendorTransaction,
		|	Doc.SendIsCustomerTransaction,
		|	case
		|		when Doc.SendIsCustomerTransaction
		|			then case
		|				when Doc.PartnersIsEqual
		|					then case
		|						when Doc.IsSendAdvanceCustomer
		|						OR Doc.IsSendTransactionVendor
		|							then FALSE
		|						else TRUE
		|					end
		|				else case
		|					when Doc.IsSendAdvanceCustomer
		|					OR Doc.IsSendTransactionVendor
		|						then FALSE
		|					else TRUE
		|				end
		|			end
		|		else case
		|			when Doc.PartnersIsEqual
		|				then case
		|					when Doc.IsSendTransactionVendor
		|						then TRUE
		|					else FALSE
		|				end
		|			else case
		|				when Doc.IsSendTransactionVendor
		|					then TRUE
		|				else FALSE
		|			end
		|		end
		|	end AS IsDue,
		|	case
		|		when Doc.SendIsCustomerTransaction
		|			then case
		|				when Doc.PartnersIsEqual
		|					then case
		|						when Doc.IsSendAdvanceCustomer
		|						OR Doc.IsSendTransactionVendor
		|							then TRUE
		|						else FALSE
		|					end
		|				else case
		|					when Doc.IsSendAdvanceCustomer
		|					OR Doc.IsSendTransactionVendor
		|						then TRUE
		|					else FALSE
		|				end
		|			end
		|		else case
		|			when Doc.PartnersIsEqual
		|				then case
		|					when Doc.IsSendTransactionVendor
		|						then FALSE
		|					else TRUE
		|				end
		|			else case
		|				when Doc.IsSendTransactionVendor
		|					then FALSE
		|				else TRUE
		|			end
		|		end
		|	end AS IsPaid,
		|	Doc.Amount
		|FROM
		|	ReceiveTransactions AS Doc";
EndFunction

Function T2015S_TransactionsInfo_Cheque() Export
	Return 
		"SELECT
		|	Table.Period AS Date,
		|	Table.Company,
		|	Table.Branch,
		|	Table.Currency,
		|	Table.Partner,
		|	Table.LegalName,
		|	Table.Agreement,
		|	Table.Project,
		|	Table.OrderSettlements AS Order,
		|	TRUE AS IsCustomerTransaction,
		|	FALSE AS IsVendorTransaction,
		|	Table.BasisDocument AS TransactionBasis,
		|	Table.Amount,
		|	TRUE AS IsPaid
		|INTO T2015S_TransactionsInfo
		|FROM
		|	CustomerTransaction_Posting AS Table
		|WHERE
		|	Table.IsIncomingCheque
		|	AND NOT Table.IsAdvance
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
		|	Table.Agreement,
		|	Table.Project,
		|	Table.OrderSettlements,
		|	TRUE,
		|	FALSE,
		|	Table.BasisDocument,
		|	-Table.Amount,
		|	TRUE
		|FROM
		|	CustomerTransaction_Reversal AS Table
		|WHERE
		|	Table.IsIncomingCheque
		|	AND NOT Table.IsAdvance
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
		|	Table.Agreement,
		|	Table.Project,
		|	Table.OrderSettlements,
		|	TRUE,
		|	FALSE,
		|	Table.BasisDocument,
		|	-Table.Amount,
		|	TRUE
		|FROM
		|	CustomerTransaction_Correction AS Table
		|WHERE
		|	Table.IsIncomingCheque
		|	AND NOT Table.IsAdvance
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
		|	Table.Agreement,
		|	Table.Project,
		|	Table.OrderSettlements,
		|	FALSE,
		|	TRUE,
		|	Table.BasisDocument,
		|	Table.Amount,
		|	TRUE
		|FROM
		|	VendorTransaction_Posting AS Table
		|WHERE
		|	Table.IsOutgoingCheque
		|	AND NOT Table.IsAdvance
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
		|	Table.Agreement,
		|	Table.Project,
		|	Table.OrderSettlements,
		|	FALSE,
		|	TRUE,
		|	Table.BasisDocument,
		|	-Table.Amount,
		|	TRUE
		|FROM
		|	VendorTransaction_Reversal AS Table
		|WHERE
		|	Table.IsOutgoingCheque
		|	AND NOT Table.IsAdvance
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
		|	Table.Agreement,
		|	Table.Project,
		|	Table.OrderSettlements,
		|	FALSE,
		|	TRUE,
		|	Table.BasisDocument,
		|	-Table.Amount,
		|	TRUE
		|FROM
		|	VendorTransaction_Correction AS Table
		|WHERE
		|	Table.IsOutgoingCheque
		|	AND NOT Table.IsAdvance";
EndFunction

Function T2015S_TransactionsInfo_PI_SRTC() Export
	Return 
		"SELECT
		|	ItemList.Period AS Date,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.Project,
		|	ItemList.PurchaseOrderSettlements AS Order,
		|	TRUE AS IsVendorTransaction,
		|	ItemList.BasisDocument AS TransactionBasis,
		|	SUM(ItemList.Amount) AS Amount,
		|	TRUE AS IsDue
		|INTO T2015S_TransactionsInfo
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsPurchase
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.Project,
		|	ItemList.PurchaseOrderSettlements,
		|	ItemList.BasisDocument";
EndFunction

Function T2015S_TransactionsInfo_PR() Export 
	Return 
		"SELECT
		|	ItemList.Period AS Date,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.Project,
		|	TRUE AS IsVendorTransaction,
		|	ItemList.BasisDocument AS TransactionBasis,
		|	-SUM(ItemList.Amount) AS Amount,
		|	TRUE AS IsDue
		|INTO T2015S_TransactionsInfo
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsReturnToVendor
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.Project,
		|	ItemList.BasisDocument";
EndFunction

Function T2015S_TransactionsInfo_SI_SRFTA() Export 
	Return 
		"SELECT
		|	ItemList.Period AS Date,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.Project,
		|	ItemList.SalesOrderSettlements AS Order,
		|	TRUE AS IsCustomerTransaction,
		|	ItemList.Basis AS TransactionBasis,
		|	SUM(ItemList.Amount) AS Amount,
		|	TRUE AS IsDue
		|INTO T2015S_TransactionsInfo
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsSales
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.Project,
		|	ItemList.SalesOrderSettlements,
		|	ItemList.Basis";
EndFunction

Function T2015S_TransactionsInfo_SR() Export
	Return 
		"SELECT
		|	ItemList.Period AS Date,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.Project,
		|	TRUE AS IsCustomerTransaction,
		|	ItemList.BasisDocument AS TransactionBasis,
		|	-SUM(ItemList.Amount) AS Amount,
		|	TRUE AS IsDue
		|INTO T2015S_TransactionsInfo
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsReturnFromCustomer
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.Project,
		|	ItemList.BasisDocument";
EndFunction

Function T2015S_TransactionsInfo_ECA() Export
	Return 
		"SELECT
		|	PaymentList.Period AS Date,
		|	PaymentList.Key,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Currency,
		|	PaymentList.VendorPartner AS Partner,
		|	PaymentList.VendorLegalName AS LegalName,
		|	PaymentList.VendorAgreement AS Agreement,
		|	PaymentList.Project,
		|	Undefined AS Order,
		|	TRUE AS IsVendorTransaction,
		|	FALSE AS IsCustomerTransaction,
		|	PaymentList.TransactionDocument AS TransactionBasis,
		|	PaymentList.TotalAmount AS Amount,
		|	TRUE AS IsPaid
		|INTO T2015S_TransactionsInfo
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsPurchase";
EndFunction
