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

Function R1021B_VendorsTransactions_BP_CP() Export
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
		|	PaymentList.Amount,
		|	UNDEFINED AS VendorsAdvancesClosing
		|INTO R1021B_VendorsTransactions
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsPaymentToVendor
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
		|	OffsetOfAdvances.Agreement,
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
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing";
EndFunction

Function R1021B_VendorsTransactions_BR_CR() Export
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
		|	UNDEFINED AS VendorsAdvancesClosing
		|INTO R1021B_VendorsTransactions
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsReturnFromVendor
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
		|	OffsetOfAdvances.Agreement,
		|	OffsetOfAdvances.TransactionProject,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing";
EndFunction

Function R1021B_VendorsTransactions_PI_SRTC() Export 
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
		|	ItemList.PurchaseOrderSettlements AS Order,
		|	SUM(ItemList.Amount) AS Amount,
		|	UNDEFINED AS VendorsAdvancesClosing
		|INTO R1021B_VendorsTransactions
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsPurchase
		|GROUP BY
		|	ItemList.Agreement,
		|	ItemList.BasisDocument,
		|	ItemList.PurchaseOrderSettlements,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.LegalName,
		|	ItemList.Project,
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
		|	OffsetOfAdvances.Agreement,
		|	OffsetOfAdvances.TransactionProject,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.TransactionOrder,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing";
EndFunction

Function R1021B_VendorsTransactions_PR() Export
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
		|	UNDEFINED AS VendorsAdvancesClosing,
		|	-SUM(ItemList.Amount) AS Amount
		|INTO R1021B_VendorsTransactions
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsReturnToVendor
		|GROUP BY
		|	ItemList.Agreement,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.LegalName,
		|	ItemList.Partner,
		|	ItemList.Period,
		|	ItemList.BasisDocument,
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.Project
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
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Recorder,
		|	OffsetOfAdvances.Amount
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing";
EndFunction

Function R1021B_VendorsTransactions_POC() Export
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
		|	OffsetOfAdvances.Agreement AS Agreement,
		|	OffsetOfAdvances.TransactionProject AS Project,
		|	OffsetOfAdvances.TransactionDocument AS Basis,
		|	OffsetOfAdvances.TransactionOrder AS Order,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Recorder AS VendorsAdvancesClosing
		|INTO R1021B_VendorsTransactions
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND NOT OffsetOfAdvances.IsAdvanceRelease
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing";
EndFunction

Function R1021B_VendorsTransactions_ECA() Export
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.VendorPartner AS Partner,
		|	PaymentList.VendorLegalName AS LegalName,
		|	PaymentList.Currency,
		|	PaymentList.VendorAgreement AS Agreement,
		|	PaymentList.Project,
		|	PaymentList.TransactionDocument AS Basis,
		|	Undefined AS Order,
		|	PaymentList.Key,
		|	PaymentList.TotalAmount AS Amount,
		|	UNDEFINED AS VendorsAdvancesClosing
		|INTO R1021B_VendorsTransactions
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsPurchase
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
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing";
EndFunction

Function R1021B_VendorsTransactions_DebitNote() Export
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
		|	Transactions.Key,
		|	-Transactions.Amount AS Amount,
		|	UNDEFINED AS VendorsAdvancesClosing
		|INTO R1021B_VendorsTransactions
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsVendor
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
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.Agreement AS Agreement,
		|	OffsetOfAdvances.TransactionProject AS Project,
		|	OffsetOfAdvances.TransactionDocument AS Basis,
		|	OffsetOfAdvances.TransactionOrder AS Order,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Recorder AS VendorsAdvancesClosing
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing";
EndFunction

Function R1021B_VendorsTransactions_CreditNote() Export
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	Transactions.Period AS Period,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Currency,
		|	Transactions.LegalName,
		|	Transactions.Partner,
		|	Transactions.Agreement,
		|	Transactions.Project,
		|	Transactions.BasisDocument AS Basis,
		|	UNDEFINED AS Order,
		|	Transactions.Key,
		|	Transactions.Amount,
		|	UNDEFINED AS VendorsAdvancesClosing
		|INTO R1021B_VendorsTransactions
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsVendor
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
		|	UNDEFINED,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing";
EndFunction

Function R1021B_VendorsTransactions_DebitCreditNote() Export
	Return
		"SELECT
		|case when Doc.PartnersIsEqual then
		|	case
		|		when Doc.IsReceiveAdvanceCustomer
		|			OR Doc.IsReceiveTransactionCustomer
		|			OR Doc.IsReceiveTransactionVendor
		|       then VALUE(AccumulationRecordType.Expense)
		|		else VALUE(AccumulationRecordType.Receipt) end
		|else
		|   case
		|		when  Doc.IsReceiveAdvanceCustomer
		|             OR Doc.IsReceiveTransactionCustomer
		|             OR Doc.IsReceiveTransactionVendor
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
		|	Doc.Key,
		|	UNDEFINED AS VendorsAdvancesClosing
		|INTO R1021B_VendorsTransactions
		|FROM
		|	SendTransactions AS Doc
		|WHERE
		|	Doc.SendIsVendorTransaction
		|
		|UNION ALL
		|
		|SELECT
		|case when Doc.PartnersIsEqual then
		|	case
		|		when Doc.IsSendTransactionVendor 
		|       then VALUE(AccumulationRecordType.Receipt)
		|		else VALUE(AccumulationRecordType.Expense) end
		|else
		|   case
		|		when  Doc.IsSendTransactionVendor 
		|		then VALUE(AccumulationRecordType.Receipt)
		|		else VALUE(AccumulationRecordType.Expense) end
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
		|	Doc.Key,
		|	UNDEFINED
		|FROM
		|	ReceiveTransactions AS Doc
		|WHERE
		|	Doc.SendIsVendorTransaction
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
EndFunction

Function R1021B_VendorsTransactions_Cheque() Export
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
		|	UNDEFINED AS VendorsAdvancesClosing
		|INTO R1021B_VendorsTransactions
		|FROM
		|	VendorTransaction_Posting AS Table
		|WHERE
		|	Table.IsOutgoingCheque
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
		|	VendorTransaction_Reversal AS Table
		|WHERE
		|	Table.IsOutgoingCheque
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
		|	VendorTransaction_Correction AS Table
		|WHERE
		|	Table.IsOutgoingCheque
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
		|	OffsetOfAdvances.Agreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.TransactionOrder,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing";
EndFunction

// Additional data filling.
// 
// Parameters:
//  MovementsValueTable - ValueTable
Procedure AdditionalDataFilling(MovementsValueTable) Export
	Return;	
EndProcedure