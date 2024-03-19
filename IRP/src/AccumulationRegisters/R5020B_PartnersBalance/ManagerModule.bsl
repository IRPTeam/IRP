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
		|SELECT // vendor advance offset
		|
		|	OffsetPartnersBalance.RecordType,
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
		|SELECT
		|	OffsetPartnersBalance.RecordType_Reverse,
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
		|
		|SELECT
		|	OffsetPartnersBalance.RecordType,
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
		|
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
		|	OffsetPartnersBalance.RecordType_Reverse,
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
		|	SUM(OffsetOfAdvances.Amount),
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

Function R5020B_PartnersBalance_SI() Export
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
		|	0 AS CustomerTransaction,
		|	SUM(ItemList.Amount) AS CustomerAdvance,
		|	0 AS VendorTransaction,
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
		|	VALUE(AccumulationRecordType.Receipt),
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
		|	SUM(OffsetOfAdvances.Amount),
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
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing
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
			|	VALUE(AccumulationRecordType.Expense)";
EndFunction	

Function R5020B_PartnersBalance_SR() Export
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

