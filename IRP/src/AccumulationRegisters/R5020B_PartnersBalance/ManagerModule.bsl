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

Function R5020B_PartnersBalance_BP_CP() Export
	Return 
		"SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Receipt)
		|		ELSE VALUE(AccumulationRecordType.Expense)
		|	END AS RecordType,
		|
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END AS RecordType_Reverse,
		|
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.AdvanceAgreement,
		|	OffsetOfAdvances.TransactionAgreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Document.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.PaymentToVendor) AS
		|		IsPaymentToVendor,
		|	OffsetOfAdvances.Document.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.ReturnToCustomer) AS
		|		IsReturnToCustomer,
		|	OffsetOfAdvances.Document.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.ReturnToCustomerByPOS) AS
		|		IsReturnToCustomerByPOS,
		|	OffsetOfAdvances.Recorder AS AdvancesClosing,
		|	OffsetOfAdvances.Key
		|INTO OffsetPartnersBalance
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND (OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing
		|	OR OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		// Customer advance, Vendor advance
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Partner,
		|	PaymentList.LegalName,
		|	PaymentList.AdvanceAgreement AS Agreement,
		|	UNDEFINED AS Document,
		|	PaymentList.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	CASE
		|		WHEN PaymentList.IsReturnToCustomer
		|		OR PaymentList.IsReturnToCustomerByPOS
		|			THEN PaymentList.Amount
		|		ELSE 0
		|	END AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	CASE
		|		WHEN PaymentList.IsPaymentToVendor
		|			THEN PaymentList.Amount
		|		ELSE 0
		|	END AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED AS AdvancesClosing,
		|	PaymentList.Key
		|INTO R5020B_PartnersBalance
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsAdvance
		|	AND (PaymentList.IsPaymentToVendor
		|	OR PaymentList.IsReturnToCustomer
		|	OR PaymentList.IsReturnToCustomerByPOS)
		|
		|UNION ALL
		|
		// Customer advance, Vendor advance (offset)
		|SELECT
		|	case when OffsetPartnersBalance.IsReturnToCustomer then
		|		OffsetPartnersBalance.RecordType_Reverse
		|	else
		|		OffsetPartnersBalance.RecordType
		|	end,
		|	OffsetPartnersBalance.Period,
		|	OffsetPartnersBalance.Company,
		|	OffsetPartnersBalance.Branch,
		|	OffsetPartnersBalance.Partner,
		|	OffsetPartnersBalance.LegalName,
		|	OffsetPartnersBalance.AdvanceAgreement,
		|	UNDEFINED,
		|	OffsetPartnersBalance.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	CASE
		|		WHEN OffsetPartnersBalance.IsReturnToCustomer
		|		OR OffsetPartnersBalance.IsReturnToCustomerByPOS
		|			THEN OffsetPartnersBalance.Amount
		|		ELSE 0
		|	END AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	CASE
		|		WHEN OffsetPartnersBalance.IsPaymentToVendor
		|			THEN OffsetPartnersBalance.Amount
		|		ELSE 0
		|	END AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	OffsetPartnersBalance.AdvancesClosing,
		|	OffsetPartnersBalance.Key
		|FROM
		|	OffsetPartnersBalance AS OffsetPartnersBalance
		|WHERE
		|	OffsetPartnersBalance.IsPaymentToVendor
		|	OR OffsetPartnersBalance.IsReturnToCustomer
		|	OR OffsetPartnersBalance.IsReturnToCustomerByPOS
		|
		|UNION ALL
		|
		// Customer transaction, Vendor transaction
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Partner,
		|	PaymentList.LegalName,
		|	PaymentList.Agreement,
		|	PaymentList.TransactionDocument,
		|	PaymentList.Currency,
		|	0 AS Amount,
		|	CASE
		|		WHEN PaymentList.IsReturnToCustomer
		|		OR PaymentList.IsReturnToCustomerByPOS
		|			THEN PaymentList.Amount
		|		ELSE 0
		|	END AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	CASE
		|		WHEN PaymentList.IsPaymentToVendor
		|			THEN PaymentList.Amount
		|		ELSE 0
		|	END AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED,
		|	PaymentList.Key
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	NOT PaymentList.IsAdvance
		|	AND (PaymentList.IsPaymentToVendor
		|	OR PaymentList.IsReturnToCustomer
		|	OR PaymentList.IsReturnToCustomerByPOS)
		|
		|UNION ALL
		|
		// Customer transaction, Vendor transaction (offset)
		|SELECT
		|	case when OffsetPartnersBalance.IsReturnToCustomer then 
		|		OffsetPartnersBalance.RecordType
		|	else
		|		OffsetPartnersBalance.RecordType_Reverse
		|	end,
		|	OffsetPartnersBalance.Period,
		|	OffsetPartnersBalance.Company,
		|	OffsetPartnersBalance.Branch,
		|	OffsetPartnersBalance.Partner,
		|	OffsetPartnersBalance.LegalName,
		|	OffsetPartnersBalance.TransactionAgreement,
		|	OffsetPartnersBalance.TransactionDocument,
		|	OffsetPartnersBalance.Currency,
		|	0 AS Amount,
		|	CASE
		|		WHEN OffsetPartnersBalance.IsReturnToCustomer
		|		OR OffsetPartnersBalance.IsReturnToCustomerByPOS
		|			THEN OffsetPartnersBalance.Amount
		|		ELSE 0
		|	END AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	CASE
		|		WHEN OffsetPartnersBalance.IsPaymentToVendor
		|			THEN OffsetPartnersBalance.Amount
		|		ELSE 0
		|	END AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	OffsetPartnersBalance.AdvancesClosing,
		|	OffsetPartnersBalance.Key
		|FROM
		|	OffsetPartnersBalance AS OffsetPartnersBalance
		|WHERE
		|	(OffsetPartnersBalance.IsPaymentToVendor
		|	OR OffsetPartnersBalance.IsReturnToCustomer
		|	OR OffsetPartnersBalance.IsReturnToCustomerByPOS)
		|
		|UNION ALL
		|
		// Other transaction
		|SELECT
		|
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Partner,
		|	PaymentList.LegalName,
		|	PaymentList.Agreement,
		|	UNDEFINED AS Document,
		|	PaymentList.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	PaymentList.Amount AS OtherTransaction,
		|	UNDEFINED AS AdvancesClosing,
		|	PaymentList.Key
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsOtherPartner";
EndFunction

Function R5020B_PartnersBalance_BR_CR() Export
	Return 
		"SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Receipt)
		|		ELSE VALUE(AccumulationRecordType.Expense)
		|	END AS RecordType,
		|
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END AS RecordType_Reverse,
		|
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.AdvanceAgreement,
		|	OffsetOfAdvances.TransactionAgreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Document.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.PaymentFromCustomer) AS
		|		IsPaymentFromCustomer,
		|	OffsetOfAdvances.Document.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.ReturnFromVendor) AS
		|		IsReturnFromVendor,
		|	OffsetOfAdvances.Document.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.PaymentFromCustomerByPOS) AS
		|		IsPaymentFromCustomerByPOS,
		|	OffsetOfAdvances.Recorder AS AdvancesClosing,
		|	OffsetOfAdvances.Key
		|INTO OffsetPartnersBalance
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND (OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing
		|	OR OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		// Customer advance, Vendor advance
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Partner,
		|	PaymentList.LegalName,
		|	PaymentList.AdvanceAgreement AS Agreement,
		|	UNDEFINED AS Document,
		|	PaymentList.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	CASE
		|		WHEN PaymentList.IsPaymentFromCustomer
		|		OR PaymentList.IsPaymentFromCustomerByPOS
		|			THEN PaymentList.Amount
		|		ELSE 0
		|	END AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	CASE
		|		WHEN PaymentList.IsReturnFromVendor
		|			THEN PaymentList.Amount
		|		ELSE 0
		|	END AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED AS AdvancesClosing,
		|	PaymentList.Key
		|INTO R5020B_PartnersBalance
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsAdvance
		|	AND (PaymentList.IsPaymentFromCustomer
		|	OR PaymentList.IsReturnFromVendor
		|	OR PaymentList.IsPaymentFromCustomerByPOS)
		|
		|UNION ALL
		// Customer advance, Vendor advance (offset)
		|SELECT
		|	CASE WHEN OffsetPartnersBalance.IsReturnFromVendor THEN
		|		OffsetPartnersBalance.RecordType
		|	ELSE
		|		OffsetPartnersBalance.RecordType_Reverse
		|	END,
		|	OffsetPartnersBalance.Period,
		|	OffsetPartnersBalance.Company,
		|	OffsetPartnersBalance.Branch,
		|	OffsetPartnersBalance.Partner,
		|	OffsetPartnersBalance.LegalName,
		|	OffsetPartnersBalance.AdvanceAgreement,
		|	UNDEFINED,
		|	OffsetPartnersBalance.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	CASE
		|		WHEN OffsetPartnersBalance.IsPaymentFromCustomer
		|		OR OffsetPartnersBalance.IsPaymentFromCustomerByPOS
		|			THEN OffsetPartnersBalance.Amount
		|		ELSE 0
		|	END AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	CASE
		|		WHEN OffsetPartnersBalance.IsReturnFromVendor
		|			THEN OffsetPartnersBalance.Amount
		|		ELSE 0
		|	END AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	OffsetPartnersBalance.AdvancesClosing,
		|	OffsetPartnersBalance.Key
		|FROM
		|	OffsetPartnersBalance AS OffsetPartnersBalance
		|WHERE
		|	OffsetPartnersBalance.IsPaymentFromCustomer
		|	OR OffsetPartnersBalance.IsReturnFromVendor
		|	OR OffsetPartnersBalance.IsPaymentFromCustomerByPOS
		|
		|UNION ALL
		// Customer transaction, Vendor transaction
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Partner,
		|	PaymentList.LegalName,
		|	PaymentList.Agreement,
		|	PaymentList.TransactionDocument,
		|	PaymentList.Currency,
		|	0 AS Amount,
		|	CASE
		|		WHEN PaymentList.IsPaymentFromCustomer
		|		OR PaymentList.IsPaymentFromCustomerByPOS
		|			THEN PaymentList.Amount
		|		ELSE 0
		|	END AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	CASE
		|		WHEN PaymentList.IsReturnFromVendor
		|			THEN PaymentList.Amount
		|		ELSE 0
		|	END AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED,
		|	PaymentList.Key
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	NOT PaymentList.IsAdvance
		|	AND (PaymentList.IsPaymentFromCustomer
		|	OR PaymentList.IsReturnFromVendor
		|	OR PaymentList.IsPaymentFromCustomerByPOS)
		|
		|UNION ALL
		|
		|SELECT
		// Customer transaction, Vendor transaction (offset)
		|	CASE WHEN OffsetPartnersBalance.IsReturnFromVendor THEN
		|		OffsetPartnersBalance.RecordType_Reverse
		|	ELSE
		|		OffsetPartnersBalance.RecordType
		|	END,
		|	OffsetPartnersBalance.Period,
		|	OffsetPartnersBalance.Company,
		|	OffsetPartnersBalance.Branch,
		|	OffsetPartnersBalance.Partner,
		|	OffsetPartnersBalance.LegalName,
		|	OffsetPartnersBalance.TransactionAgreement,
		|	OffsetPartnersBalance.TransactionDocument,
		|	OffsetPartnersBalance.Currency,
		|	0 AS Amount,
		|	CASE
		|		WHEN OffsetPartnersBalance.IsPaymentFromCustomer
		|		OR OffsetPartnersBalance.IsPaymentFromCustomerByPOS
		|			THEN OffsetPartnersBalance.Amount
		|		ELSE 0
		|	END AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	CASE
		|		WHEN OffsetPartnersBalance.IsReturnFromVendor
		|			THEN OffsetPartnersBalance.Amount
		|		ELSE 0
		|	END AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	OffsetPartnersBalance.AdvancesClosing,
		|	OffsetPartnersBalance.Key
		|FROM
		|	OffsetPartnersBalance AS OffsetPartnersBalance
		|WHERE
		|	(OffsetPartnersBalance.IsPaymentFromCustomer
		|	OR OffsetPartnersBalance.IsReturnFromVendor
		|	OR OffsetPartnersBalance.IsPaymentFromCustomerByPOS)
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Partner,
		|	PaymentList.LegalName,
		|	PaymentList.Agreement,
		|	UNDEFINED AS Document,
		|	PaymentList.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	PaymentList.Amount AS OtherTransaction,
		|	UNDEFINED AS AdvancesClosing,
		|	PaymentList.Key
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsOtherPartner";
EndFunction

Function R5020B_PartnersBalance_PI() Export
	Return 
		// Vendor transaction
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.BasisDocument AS Document,
		|	ItemList.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	SUM(ItemList.Amount) AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED AS AdvancesClosing,
		|	UNDEFINED AS Key
		|INTO R5020B_PartnersBalance
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsPurchase
		|GROUP BY
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.BasisDocument,
		|	ItemList.Currency
		|
		|UNION ALL
		|
		// Vendor advance (offset)
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
		|	UNDEFINED,
		|	OffsetOfAdvances.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	OffsetOfAdvances.Amount AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	OffsetOfAdvances.Recorder,
		|	UNDEFINED
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing
		|
		|UNION ALL
		|
		// Vendor transaction (offset)
		|SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.TransactionAgreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	SUM(OffsetOfAdvances.Amount) AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	OffsetOfAdvances.Recorder,
		|	UNDEFINED
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing
		|GROUP BY
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.TransactionAgreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.Recorder";
EndFunction

Function R5020B_PartnersBalance_PR() Export
	Return 
		// Vendor transaction
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.BasisDocument AS Document,
		|	ItemList.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	-SUM(ItemList.Amount) AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED AS AdvancesClosing
		|INTO R5020B_PartnersBalance
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsReturnToVendor
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.BasisDocument,
		|	ItemList.Currency,
		|	VALUE(AccumulationRecordType.Receipt),
		|	VALUE(AccumulationRecordType.Expense)
		|
		|UNION ALL
		|
		// Vendor transaction (offset)
		|SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.TransactionAgreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	OffsetOfAdvances.Amount AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing
		|
		|UNION ALL
		|
		// Vendor advance (offset)
		|SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END AS RecordType,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.AdvanceAgreement,
		|	UNDEFINED,
		|	OffsetOfAdvances.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	-OffsetOfAdvances.Amount AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing";
EndFunction

Function R5020B_PartnersBalance_SI() Export
	Return 
		// Customer transaction
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.Basis AS Document,
		|	ItemList.Currency,
		|	0 AS Amount,
		|	SUM(ItemList.Amount) AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED AS AdvancesClosing,
		|	UNDEFINED AS Key
		|INTO R5020B_PartnersBalance
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsSales
		|GROUP BY
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.Basis,
		|	ItemList.Currency
		|
		|UNION ALL
		|
		// Customer advance (offset)
		|SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.AdvanceAgreement,
		|	UNDEFINED,
		|	OffsetOfAdvances.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	OffsetOfAdvances.Amount AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	OffsetOfAdvances.Recorder,
		|	UNDEFINED
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing
		|
		|UNION ALL
		|
		// Customer transaction (offset)
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
		|	OffsetOfAdvances.TransactionAgreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Currency,
		|	0 AS Amount,
		|	OffsetOfAdvances.Amount AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	OffsetOfAdvances.Recorder,
		|	UNDEFINED
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing";
EndFunction

Function R5020B_PartnersBalance_SR() Export
	Return 
		// Customer transaction
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.BasisDocument AS Document,
		|	ItemList.Currency,
		|	0 AS Amount,
		|	-SUM(ItemList.Amount) AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED AS AdvancesClosing
		|INTO R5020B_PartnersBalance
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsReturnFromCustomer
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.BasisDocument,
		|	ItemList.Currency,
		|	VALUE(AccumulationRecordType.Receipt)
		|
		|UNION ALL
		|
		// Customer transaction (offset)
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
		|	OffsetOfAdvances.TransactionAgreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Currency,
		|	0 AS Amount,
		|	OffsetOfAdvances.Amount AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing
		|
		|UNION ALL
		|
		// Customer advance (offset)
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
		|	OffsetOfAdvances.AdvanceAgreement AS Agreement,
		|	UNDEFINED,
		|	OffsetOfAdvances.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	-OffsetOfAdvances.Amount AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing";
		
EndFunction

Function R5020B_PartnersBalance_RSR() Export
		Return 
			"SELECT
			|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
			|	ItemList.Period,
			|	ItemList.Company,
			|	ItemList.Branch,
			|	ItemList.Partner,
			|	ItemList.LegalName,
			|	ItemList.Agreement,
			|	ItemList.BasisDocument AS Document,
			|	ItemList.Currency,
			|	0 AS Amount,
			|	SUM(ItemList.TotalAmount) AS CustomerTransaction,
			|	0 AS CustomerAdvance,
			|	0 AS VendorTransaction,
			|	0 AS VendorAdvance,
			|	0 AS OtherTransaction,
			|	UNDEFINED AS AdvancesClosing
			|INTO R5020B_PartnersBalance
			|FROM
			|	ItemList AS ItemList
			|WHERE
			|	ItemList.UsePartnerTransactions
			|	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
			|GROUP BY
			|	ItemList.Period,
			|	ItemList.Company,
			|	ItemList.Branch,
			|	ItemList.Partner,
			|	ItemList.LegalName,
			|	ItemList.Agreement,
			|	ItemList.BasisDocument,
			|	ItemList.Currency,
			|	VALUE(AccumulationRecordType.Receipt)
			|
			|UNION ALL
			|
			|SELECT
			|	VALUE(AccumulationRecordType.Expense) AS RecordType,
			|	ItemList.Period,
			|	ItemList.Company,
			|	ItemList.Branch,
			|	ItemList.Partner,
			|	ItemList.LegalName,
			|	ItemList.Agreement,
			|	ItemList.BasisDocument AS Document,
			|	ItemList.Currency,
			|	0 AS Amount,
			|	SUM(ItemList.TotalAmount) AS CustomerTransaction,
			|	0 AS CustomerAdvance,
			|	0 AS VendorTransaction,
			|	0 AS VendorAdvance,
			|	0 AS OtherTransaction,
			|	UNDEFINED AS AdvancesClosing
			|FROM
			|	ItemList AS ItemList
			|WHERE
			|	ItemList.UsePartnerTransactions
			|	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
			|GROUP BY
			|	ItemList.Period,
			|	ItemList.Company,
			|	ItemList.Branch,
			|	ItemList.Partner,
			|	ItemList.LegalName,
			|	ItemList.Agreement,
			|	ItemList.BasisDocument,
			|	ItemList.Currency,
			|	VALUE(AccumulationRecordType.Expense)
			|
			|UNION ALL
			|
			|SELECT
			|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
			|	PaymentAgent.Period,
			|	PaymentAgent.Company,
			|	PaymentAgent.Branch,
			|	PaymentAgent.Partner,
			|	PaymentAgent.LegalName,
			|	PaymentAgent.Agreement,
			|	PaymentAgent.Basis,
			|	PaymentAgent.Currency,
			|	0 AS Amount,
			|	0 AS CustomerTransaction,
			|	0 AS CustomerAdvance,
			|	0 AS VendorTransaction,
			|	0 AS VendorAdvance,
			|	SUM(PaymentAgent.Amount) AS OtherTransaction,
			|	UNDEFINED
			|FROM
			|	PaymentAgent AS PaymentAgent
			|WHERE
			|	TRUE
			|	AND PaymentAgent.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
			|GROUP BY
			|	VALUE(AccumulationRecordType.Receipt),
			|	PaymentAgent.Period,
			|	PaymentAgent.Company,
			|	PaymentAgent.Branch,
			|	PaymentAgent.Partner,
			|	PaymentAgent.LegalName,
			|	PaymentAgent.Agreement,
			|	PaymentAgent.Basis,
			|	PaymentAgent.Currency";
EndFunction	

Function R5020B_PartnersBalance_RRR() Export
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.BasisDocument AS Document,
		|	ItemList.Currency,
		|	0 AS Amount,
		|	-SUM(ItemList.TotalAmount) AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED AS AdvancesClosing
		|INTO R5020B_PartnersBalance
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.UsePartnerTransactions
		|	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.BasisDocument,
		|	ItemList.Currency,
		|	VALUE(AccumulationRecordType.Receipt)
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.BasisDocument,
		|	ItemList.Currency,
		|	0 AS Amount,
		|	-SUM(ItemList.TotalAmount) AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.UsePartnerTransactions
		|	AND ItemList.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.BasisDocument,
		|	ItemList.Currency,
		|	VALUE(AccumulationRecordType.Expense)
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	Payments.Period,
		|	Payments.Company,
		|	Payments.Branch,
		|	Payments.Partner,
		|	Payments.LegalName,
		|	Payments.Agreement,
		|	UNDEFINED,
		|	Payments.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	-SUM(Payments.Amount) AS OtherTransaction,
		|	UNDEFINED
		|FROM
		|	Payments AS Payments
		|WHERE
		|	Payments.IsPaymentAgent
		|	AND Payments.StatusType = VALUE(ENUM.RetailReceiptStatusTypes.Completed)
		|GROUP BY
		|	VALUE(AccumulationRecordType.Receipt),
		|	Payments.Period,
		|	Payments.Company,
		|	Payments.Branch,
		|	Payments.Partner,
		|	Payments.LegalName,
		|	Payments.Currency,
		|	Payments.Agreement";
EndFunction

Function R5020B_PartnersBalance_ECA() Export
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.VendorPartner AS Partner,
		|	PaymentList.VendorLegalName AS LegalName,
		|	PaymentList.VendorAgreement AS Agreement,
		|	PaymentList.TransactionDocument AS Document,
		|	PaymentList.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	PaymentList.TotalAmount AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	PaymentList.Key,
		|	UNDEFINED AS AdvancesClosing
		|INTO R5020B_PartnersBalance
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
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.TransactionAgreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	OffsetOfAdvances.Amount AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing";
EndFunction

Function R5020B_PartnersBalance_SRTC() Export
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.BasisDocument AS Document,
		|	ItemList.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	SUM(ItemList.Amount) AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED AS AdvancesClosing
		|INTO R5020B_PartnersBalance
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsPurchase
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.BasisDocument,
		|	ItemList.Currency,
		|	VALUE(AccumulationRecordType.Expense)
		|
		|UNION ALL
		|
		|SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.TransactionAgreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	OffsetOfAdvances.Amount AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
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
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END AS RecordType,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.AdvanceAgreement,
		|	UNDEFINED,
		|	OffsetOfAdvances.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	OffsetOfAdvances.Amount AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing";	
EndFunction

Function R5020B_PartnersBalance_SRFTA() Export
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.Basis AS Document,
		|	ItemList.Currency,
		|	0 AS Amount,
		|	SUM(ItemList.Amount) AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED AS AdvancesClosing
		|INTO R5020B_PartnersBalance
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsSales
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.Basis,
		|	ItemList.Currency,
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
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.TransactionAgreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Currency,
		|	0 AS Amount,
		|	OffsetOfAdvances.Amount AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing
		|
		|UNION ALL
		|
		|SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END AS RecordType,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.AdvanceAgreement,
		|	UNDEFINED,
		|	OffsetOfAdvances.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	OffsetOfAdvances.Amount AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing";
		
EndFunction

Function R5020B_PartnersBalance_DebitNote() Export
	Return 
		// Customer transaction
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	Transactions.Period,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Partner,
		|	Transactions.LegalName,
		|	Transactions.Agreement,
		|	Transactions.BasisDocument AS Document,
		|	Transactions.Currency,
		|	0 AS Amount,
		|	Transactions.Amount AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED AS AdvancesClosing,
		|	Transactions.Key AS Key
		|INTO R5020B_PartnersBalance
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsCustomer
		|
		|UNION ALL
		// Customer advance (offset)
		|SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END AS RecordType,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.AdvanceAgreement,
		|	UNDEFINED,
		|	OffsetOfAdvances.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	OffsetOfAdvances.Amount AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	OffsetOfAdvances.Recorder,
		|	OffsetOfAdvances.Key
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing
		|
		|UNION ALL
		// Customer transaction (offset)
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
		|	OffsetOfAdvances.TransactionAgreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Currency,
		|	0 AS Amount,
		|	OffsetOfAdvances.Amount AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	OffsetOfAdvances.Recorder,
		|	OffsetOfAdvances.Key
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing
		|
		|UNION ALL
		// Vendor transaction
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	Transactions.Period,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Partner,
		|	Transactions.LegalName,
		|	Transactions.Agreement,
		|	Transactions.BasisDocument AS Document,
		|	Transactions.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	-Transactions.Amount AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED AS AdvancesClosing,
		|	Transactions.Key AS Key
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsVendor
		|
		|UNION ALL
		// Vendor transaction (offset)
		|SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END AS RecordType,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.TransactionAgreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	OffsetOfAdvances.Amount AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	OffsetOfAdvances.Recorder,
		|	OffsetOfAdvances.Key
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing
		|
		|UNION ALL
		// Vendor advance (offset)
		|SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.AdvanceAgreement,
		|	UNDEFINED,
		|	OffsetOfAdvances.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	OffsetOfAdvances.Amount AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	OffsetOfAdvances.Recorder,
		|	OffsetOfAdvances.Key
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing
		|
		|UNION ALL
		// Other
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	Transactions.Period,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Partner,
		|	Transactions.LegalName,
		|	Transactions.Agreement,
		|	UNDEFINED,
		|	Transactions.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	Transactions.Amount AS OtherTransaction,
		|	UNDeFINED,
		|	Transactions.Key AS Key
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsOther";
	
EndFunction

Function R5020B_PartnersBalance_CreditNote() Export
	Return
		// Vendor transaction
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	Transactions.Period AS Period,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Partner,
		|	Transactions.LegalName,
		|	Transactions.Agreement,
		|	Transactions.BasisDocument AS Document,
		|	Transactions.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	Transactions.Amount AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED AS AdvancesClosing,
		|	Transactions.Key
		|INTO R5020B_PartnersBalance
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsVendor
		|
		|UNION ALL
		// Vendor advances (offset)
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
		|	OffsetOfAdvances.AdvanceAgreement,
		|	UNDEFINED,
		|	OffsetOfAdvances.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	OffsetOfAdvances.Amount AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	OffsetOfAdvances.Recorder,
		|	OffsetOfAdvances.Key
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing
		|
		|UNION ALL
		// Vendor transaction (offset)
		|SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.TransactionAgreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	OffsetOfAdvances.Amount AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	OffsetOfAdvances.Recorder,
		|	OffsetOfAdvances.Key
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing
		|
		|UNION ALL
		// Customer transaction
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	Transactions.Period,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Partner,
		|	Transactions.LegalName,
		|	Transactions.Agreement,
		|	Transactions.BasisDocument,
		|	Transactions.Currency,
		|	0 AS Amount,
		|	-Transactions.Amount AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED AS AdvancesClosing,
		|	Transactions.Key
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsCustomer
		|
		|UNION ALL
		// Customer transaction (offset)
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
		|	OffsetOfAdvances.TransactionAgreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Currency,
		|	0 AS Amount,
		|	OffsetOfAdvances.Amount AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	OffsetOfAdvances.Recorder,
		|	OffsetOfAdvances.Key
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing
		|
		|UNION ALL
		// Customer advances (offset)
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
		|	UNDEFINED,
		|	OffsetOfAdvances.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	-OffsetOfAdvances.Amount AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	OffsetOfAdvances.Recorder,
		|	OffsetOfAdvances.Key
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing
		|
		|UNION ALL
		// Other
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	Transactions.Period,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Partner,
		|	Transactions.LegalName,
		|	Transactions.Agreement,
		|	UNDEFINED,
		|	Transactions.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	Transactions.Amount AS OtherTransaction,
		|	UNDEFINED,
		|	Transactions.Key
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsOther";
EndFUnction

Function R5020B_PartnersBalance_OE() Export
	Return
	// Customer transactions
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	CustomersTransactions.Period,
		|	CustomersTransactions.Company,
		|	CustomersTransactions.Branch,
		|	CustomersTransactions.Partner,
		|	CustomersTransactions.LegalName,
		|	CustomersTransactions.Agreement,
		|	CustomersTransactions.Basis AS Document,
		|	CustomersTransactions.Currency,
		|	0 AS Amount,
		|	CustomersTransactions.Amount AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED AS AdvancesClosing,
		|	CustomersTransactions.Key
		|INTO R5020B_PartnersBalance
		|FROM
		|	CustomersTransactions AS CustomersTransactions
		|WHERE
		|	TRUE
		|
		|UNION ALL
		// Customer advances
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	AdvancesFromCustomers.Period,
		|	AdvancesFromCustomers.Company,
		|	AdvancesFromCustomers.Branch,
		|	AdvancesFromCustomers.Partner,
		|	AdvancesFromCustomers.LegalName,
		|	AdvancesFromCustomers.Agreement,
		|	UNDEFINED,
		|	AdvancesFromCustomers.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	AdvancesFromCustomers.Amount AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED,
		|	AdvancesFromCustomers.Key
		|FROM
		|	AdvancesFromCustomers AS AdvancesFromCustomers
		|WHERE
		|	TRUE
		|
		|UNION ALL
		// Vendor transactions
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	VendorsTransactions.Period,
		|	VendorsTransactions.Company,
		|	VendorsTransactions.Branch,
		|	VendorsTransactions.Partner,
		|	VendorsTransactions.LegalName,
		|	VendorsTransactions.Agreement,
		|	VendorsTransactions.Basis,
		|	VendorsTransactions.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	VendorsTransactions.Amount AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED,
		|	VendorsTransactions.Key
		|FROM
		|	VendorsTransactions AS VendorsTransactions
		|WHERE
		|	TRUE
		|
		|UNION ALL
		// Vendor advances
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	AdvancesToVendors.Period,
		|	AdvancesToVendors.Company,
		|	AdvancesToVendors.Branch,
		|	AdvancesToVendors.Partner,
		|	AdvancesToVendors.LegalName,
		|	AdvancesToVendors.Agreement,
		|	UNDEFINED,
		|	AdvancesToVendors.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	AdvancesToVendors.Amount AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED,
		|	AdvancesToVendors.Key
		|FROM
		|	AdvancesToVendors AS AdvancesToVendors
		|WHERE
		|	TRUE
		|
		|UNION ALL
		// Other transactions
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	OtherVendorsTransactions.Period,
		|	OtherVendorsTransactions.Company,
		|	OtherVendorsTransactions.Branch,
		|	OtherVendorsTransactions.Partner,
		|	OtherVendorsTransactions.LegalName,
		|	OtherVendorsTransactions.Agreement,
		|	UNDEFINED,
		|	OtherVendorsTransactions.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	OtherVendorsTransactions.Amount AS OtherTransaction,
		|	UNDEFINED,
		|	OtherVendorsTransactions.Key
		|FROM
		|	OtherVendorsTransactions AS OtherVendorsTransactions
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	OtherCustomersTransactions.Period,
		|	OtherCustomersTransactions.Company,
		|	OtherCustomersTransactions.Branch,
		|	OtherCustomersTransactions.Partner,
		|	OtherCustomersTransactions.LegalName,
		|	OtherCustomersTransactions.Agreement,
		|	UNDEFINED,
		|	OtherCustomersTransactions.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	OtherCustomersTransactions.Amount AS OtherTransaction,
		|	UNDEFINED,
		|	OtherCustomersTransactions.Key
		|FROM
		|	OtherCustomersTransactions AS OtherCustomersTransactions";
EndFunction

Function R5020B_PartnersBalance_DebitCreditNote() Export
	Return
		// Vendor advance (send)
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	
		|	SendAdvances.Period,
		|	SendAdvances.Company,
		|	SendAdvances.SendBranch AS Branch,
		|	SendAdvances.SendPartner AS Partner,
		|	SendAdvances.SendLegalName AS LegalName,
		|	SendAdvances.SendAgreement AS Agreement,
		|	UNDEFINED AS Document,
		|	SendAdvances.Currency,
		|
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,	
		|	SendAdvances.Amount AS VendorAdvance,
		|	0 AS OtherTransaction,
		|
		|	UNDEFINED AS AdvancesClosing
		|
		|INTO R5020B_PartnersBalance
		|FROM
		|	SendAdvances AS SendAdvances
		|WHERE
		|	SendAdvances.IsSendAdvanceVendor
		|	AND SendAdvances.IsDifferentPartners
		|
		|UNION ALL
		|
		// Vendor advance (receipt)
		|SELECT
		//|	VALUE(AccumulationRecordType.Receipt),
		|   
		|	case when ReceiveAdvances.IsSendAdvanceCustomer and ReceiveAdvances.IsReceiveAdvanceVendor then
		|   	VALUE(AccumulationRecordType.Expense)
		|	else
		|		VALUE(AccumulationRecordType.Receipt)
		|	end,
		|
		|	ReceiveAdvances.Period,
		|	ReceiveAdvances.Company,
		|	ReceiveAdvances.ReceiveBranch AS Branch,
		|	ReceiveAdvances.ReceivePartner AS Partner,
		|	ReceiveAdvances.ReceiveLegalName AS LegalName,
		|	ReceiveAdvances.ReceiveAgreement AS Agreement,
		|	UNDEFINED AS Document,
		|	ReceiveAdvances.Currency,
		|
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,	
		|	ReceiveAdvances.Amount AS VendorAdvance,
		|	0 AS OtherTransaction,
		|
		|	UNDEFINED AS AdvancesClosing
		|
		|FROM
		|	ReceiveAdvances AS ReceiveAdvances
		|WHERE
		|	ReceiveAdvances.IsReceiveAdvanceVendor
		|	AND ReceiveAdvances.IsDifferentPartners
		|
		|UNION ALL
		|
		// Customer advance (send)
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|
		|	SendAdvances.Period,
		|	SendAdvances.Company,
		|	SendAdvances.SendBranch AS Branch,
		|	SendAdvances.SendPartner AS Partner,
		|	SendAdvances.SendLegalName AS LegalName,
		|	SendAdvances.SendAgreement AS Agreement,
		|	UNDEFINED AS Document,
		|	SendAdvances.Currency,
		|
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	SendAdvances.Amount AS CustomerAdvance,
		|	0 AS VendorTransaction,	
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|
		|	UNDEFINED AS AdvancesClosing
		|
		|FROM
		|	SendAdvances AS SendAdvances
		|WHERE
		|	SendAdvances.IsSendAdvanceCustomer
		|	AND SendAdvances.IsDifferentPartners
		|
		|UNION ALL
		|
		// Customer advance (receipt)
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|
		|	ReceiveAdvances.Period,
		|	ReceiveAdvances.Company,
		|	ReceiveAdvances.ReceiveBranch AS Branch,
		|	ReceiveAdvances.ReceivePartner AS Partner,
		|	ReceiveAdvances.ReceiveLegalName AS LegalName,
		|	ReceiveAdvances.ReceiveAgreement AS Agreement,
		|	UNDEFINED AS Document,
		|	ReceiveAdvances.Currency,
		|
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	ReceiveAdvances.Amount AS CustomerAdvance,
		|	0 AS VendorTransaction,	
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|
		|	UNDEFINED AS AdvancesClosing
		|
		|FROM
		|	ReceiveAdvances AS ReceiveAdvances
		|WHERE
		|	ReceiveAdvances.IsReceiveAdvanceCustomer
		|	AND ReceiveAdvances.IsDifferentPartners
		|
		|UNION ALL
		|
		// Vendor transaction (send)
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	
		|	SendTransactions.Period,
		|	SendTransactions.Company,
		|	SendTransactions.SendBranch AS Branch,
		|	SendTransactions.SendPartner AS Partner,
		|	SendTransactions.SendLegalName AS LegalName,
		|	SendTransactions.SendAgreement AS Agreement,
		|	SendTransactions.SendBasisDocument AS Document,
		|	SendTransactions.Currency,
		|
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	SendTransactions.Amount AS VendorTransaction,	
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|
		|	UNDEFINED AS AdvancesClosing
		|
		|FROM
		|	SendTransactions AS SendTransactions
		|WHERE
		|	SendTransactions.IsSendTransactionVendor
		|	AND SendTransactions.IsDifferentPartners
		|
		|UNION ALL
		|
		// Vendor transaction (receipt)
		|SELECT
		|	
		|	case when ReceiveTransactions.IsSendTransactionVendor and ReceiveTransactions.IsReceiveTransactionVendor then
		|   	value(AccumulationRecordType.Expense)
		|   else
		|   	VALUE(AccumulationRecordType.Receipt)
		|	end,
		|
		|	ReceiveTransactions.Period,
		|	ReceiveTransactions.Company,
		|	ReceiveTransactions.ReceiveBranch AS Branch,
		|	ReceiveTransactions.ReceivePartner AS Partner,
		|	ReceiveTransactions.ReceiveLegalName AS LegalName,
		|	ReceiveTransactions.ReceiveAgreement AS Agreement,
		|	ReceiveTransactions.ReceiveBasisDocument AS Document,
		|	ReceiveTransactions.Currency,
		|
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	ReceiveTransactions.Amount AS VendorTransaction,	
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|
		|	UNDEFINED AS AdvancesClosing
		|
		|FROM
		|	ReceiveTransactions AS ReceiveTransactions
		|WHERE
		|	ReceiveTransactions.IsReceiveTransactionVendor
		|	AND ReceiveTransactions.IsDifferentPartners
		|
		|UNION ALL
		|
		// Customer transaction (send)
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|
		|	SendTransactions.Period,
		|	SendTransactions.Company,
		|	SendTransactions.SendBranch AS Branch,
		|	SendTransactions.SendPartner AS Partner,
		|	SendTransactions.SendLegalName AS LegalName,
		|	SendTransactions.SendAgreement AS Agreement,
		|	SendTransactions.SendBasisDocument AS Document,
		|	SendTransactions.Currency,
		|
		|	0 AS Amount,
		|	SendTransactions.Amount AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,	
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|
		|	UNDEFINED AS AdvancesClosing
		|
		|FROM
		|	SendTransactions AS SendTransactions
		|WHERE
		|	SendTransactions.IsSendTransactionCustomer
		|	AND SendTransactions.IsDifferentPartners
		|
		|UNION ALL
		|
		// Customer transaction (receipt)
		|SELECT
		|         
		|	case when ReceiveTransactions.IsSendTransactionCustomer and ReceiveTransactions.IsReceiveTransactionCustomer then
		|   	value(AccumulationRecordType.Receipt)
		|   else
		|   	VALUE(AccumulationRecordType.Expense)
		|	end,
		|
		|	ReceiveTransactions.Period,
		|	ReceiveTransactions.Company,
		|	ReceiveTransactions.ReceiveBranch AS Branch,
		|	ReceiveTransactions.ReceivePartner AS Partner,
		|	ReceiveTransactions.ReceiveLegalName AS LegalName,
		|	ReceiveTransactions.ReceiveAgreement AS Agreement,
		|	ReceiveTransactions.ReceiveBasisDocument AS Document,
		|	ReceiveTransactions.Currency,
		|
		|	0 AS Amount,
		|	ReceiveTransactions.Amount AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,	
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|
		|	UNDEFINED AS AdvancesClosing
		|
		|FROM
		|	ReceiveTransactions AS ReceiveTransactions
		|WHERE
		|	 ReceiveTransactions.IsReceiveTransactionCustomer
		|	AND ReceiveTransactions.IsDifferentPartners
		|
		|UNION ALL
		|
		// Vendor advance (offset)
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
		|	UNDEFINED,
		|	OffsetOfAdvances.Currency,
		|
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	OffsetOfAdvances.Amount AS VendorAdvance,
		|	0 AS OtherTransaction,
		|
		|	OffsetOfAdvances.Recorder
		|
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing
		|	AND (CAST(OffsetOfAdvances.Document AS Document.DebitCreditNote).ReceiveDebtType 
		|		= VALUE(Enum.DebtTypes.AdvanceVendor)
		|		OR
		|		CAST(OffsetOfAdvances.Document AS Document.DebitCreditNote).ReceiveDebtType
		|		= VALUE(Enum.DebtTypes.TransactionVendor))
		|
		|UNION ALL
		|
		// Customer advance (offset)
		|SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.AdvanceAgreement,
		|	UNDEFINED,
		|	OffsetOfAdvances.Currency,
		|
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	OffsetOfAdvances.Amount AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|
		|	OffsetOfAdvances.Recorder
		|
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing
		|	AND (CAST(OffsetOfAdvances.Document AS Document.DebitCreditNote).ReceiveDebtType 
		|		= VALUE(Enum.DebtTypes.AdvanceCustomer)
		|		OR
		|		CAST(OffsetOfAdvances.Document AS Document.DebitCreditNote).ReceiveDebtType
		|		= VALUE(Enum.DebtTypes.TransactionCustomer))
		|
		|
		|UNION ALL
		|
		// Vendor transaction (offset)
		|SELECT
		|	CASE
		|		WHEN OffsetOfAdvances.RecordType = VALUE(Enum.RecordType.Receipt)
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.TransactionAgreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Currency,
		|
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	OffsetOfAdvances.Amount AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|
		|	OffsetOfAdvances.Recorder
		|	
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing
		|	AND (CAST(OffsetOfAdvances.Document AS Document.DebitCreditNote).ReceiveDebtType 
		|		= VALUE(Enum.DebtTypes.AdvanceVendor)
		|		OR 
		|		CAST(OffsetOfAdvances.Document AS Document.DebitCreditNote).ReceiveDebtType
		|		= VALUE(Enum.DebtTypes.TransactionVendor))
		|
		|UNION ALL
		|
		// Customer transaction (offset)
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
		|	OffsetOfAdvances.TransactionAgreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Currency,
		|
		|	0 AS Amount,
		|	OffsetOfAdvances.Amount AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|
		|	OffsetOfAdvances.Recorder
		|	
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing
		|	AND (CAST(OffsetOfAdvances.Document AS Document.DebitCreditNote).ReceiveDebtType 
		|		= VALUE(Enum.DebtTypes.AdvanceCustomer)
		|		OR 
		|		CAST(OffsetOfAdvances.Document AS Document.DebitCreditNote).ReceiveDebtType
		|		= VALUE(Enum.DebtTypes.TransactionCustomer))
		|
		|";
EndFunction
Function R5020B_PartnersBalance_Payroll() Export
	Return 
		// Other transaction
		"SELECT
		|
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	SalaryTaxList.Period,
		|	SalaryTaxList.Company,
		|	SalaryTaxList.Branch,
		|	SalaryTaxList.Partner,
		|	SalaryTaxList.LegalName,
		|	SalaryTaxList.Agreement,
		|	UNDEFINED AS Document,
		|	SalaryTaxList.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	SalaryTaxList.Amount AS OtherTransaction,
		|	UNDEFINED AS AdvancesClosing,
		|	SalaryTaxList.Key
		|INTO R5020B_PartnersBalance
		|FROM
		|	SalaryTaxList AS SalaryTaxList
		|WHERE
		|	TRUE";
EndFunction

Procedure AdditionalDataFilling(MovementsValueTable) Export
	For Each Row In MovementsValueTable Do
		If ValueIsFilled(Row.AdvancesClosing) Then
			Continue;
		EndIf;
		Row.Amount = 
		Row.CustomerTransaction
		+ Row.CustomerAdvance
		+ Row.VendorTransaction
		+ Row.VendorAdvance
		+ Row.OtherTransaction;
	EndDo;
EndProcedure