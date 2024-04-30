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

Function R1020B_AdvancesToVendors_BP_CP() Export
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Partner,
		|	PaymentList.LegalName,
		|	PaymentList.Currency,
		|	PaymentList.OrderSettlements AS Order,
		|	PaymentList.Amount,
		|	PaymentList.Key,
		|	PaymentList.AdvanceAgreement AS Agreement,
		|	PaymentList.Project,
		|	UNDEFINED AS VendorsAdvancesClosing
		|INTO R1020B_AdvancesToVendors
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsPaymentToVendor
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
		|	OffsetOfAdvances.AdvanceOrder,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.AdvanceAgreement,
		|	OffsetOfAdvances.AdvanceProject,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing";
EndFunction

Function R1020B_AdvancesToVendors_BR_CR() Export
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
		|	UNDEFINED AS VendorsAdvancesClosing
		|INTO R1020B_AdvancesToVendors
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsReturnFromVendor
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
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing";
EndFunction

Function R1020B_AdvancesToVendors_PI_PR_POC_SRTC() Export 
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
		|	OffsetOfAdvances.AdvanceOrder AS Order,
		|	OffsetOfAdvances.Amount,
		|	UNDEFINED AS Key,
		|	OffsetOfAdvances.Recorder AS VendorsAdvancesClosing
		|INTO R1020B_AdvancesToVendors
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing";
EndFunction

Function R1020B_AdvancesToVendors_DebitNote() Export
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
		|	OffsetOfAdvances.AdvanceOrder AS Order,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing";
EndFunction

Function R1020B_AdvancesToVendors_CreditNote() Export 
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
		|	OffsetOfAdvances.AdvanceOrder AS Order,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Recorder AS VendorsAdvancesClosing
		|INTO R1020B_AdvancesToVendors
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing";
EndFunction

Function R1020B_AdvancesToVendors_DebitCreditNote() Export
	Return 
		"SELECT
		|	case
		|		when Doc.PartnersIsEqual
		|			then case
		|				when Doc.IsReceiveTransactionVendor
		|				OR Doc.IsReceiveAdvanceVendor
		|					then VALUE(AccumulationRecordType.Expense)
		|				else VALUE(AccumulationRecordType.Receipt)
		|			end
		|		else case
		|			when Doc.IsReceiveTransactionVendor
		|			OR Doc.IsReceiveAdvanceVendor
		|				then VALUE(AccumulationRecordType.Expense)
		|			else VALUE(AccumulationRecordType.Receipt)
		|		end
		|	end as RecordType,
		|	Doc.Period,
		|	Doc.Company,
		|	Doc.SendBranch AS Branch,
		|	Doc.SendPartner AS Partner,
		|	Doc.SendLegalName AS LegalName,
		|	Doc.Currency,
		|	Doc.SendAgreement AS Agreement,
		|	Doc.SendProject AS Project,
		|	Doc.Amount,
		|	UNDEFINED AS VendorsAdvancesClosing
		|INTO R1020B_AdvancesToVendors
		|FROM
		|	SendAdvances AS Doc
		|WHERE
		|	Doc.SendIsVendorAdvance
		|
		|UNION ALL
		|
		|SELECT
		|	case
		|		when Doc.PartnersIsEqual
		|			then case
		|				when Doc.IsSendTransactionCustomer
		|				OR Doc.IsSendAdvanceVendor
		|					then VALUE(AccumulationRecordType.Receipt)
		|				else VALUE(AccumulationRecordType.Expense)
		|			end
		|		else case
		|			when Doc.IsSendTransactionCustomer
		|			OR Doc.IsSendAdvanceVendor
		|				then VALUE(AccumulationRecordType.Receipt)
		|			else VALUE(AccumulationRecordType.Expense)
		|		end
		|	end as RecordType,
		|	Doc.Period,
		|	Doc.Company,
		|	Doc.ReceiveBranch AS Branch,
		|	Doc.ReceivePartner AS Partner,
		|	Doc.ReceiveLegalName AS LegalName,
		|	Doc.Currency,
		|	Doc.ReceiveAgreement AS Agreement,
		|	Doc.ReceiveProject AS Project,
		|	Doc.Amount,
		|	UNDEFINED
		|FROM
		|	ReceiveAdvances AS Doc
		|WHERE
		|	Doc.ReceiveIsVendorAdvance
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
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing";
EndFunction

Function R1020B_AdvancesToVendors_Cheque() Export
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
		|	Table.OrderSettlements AS Order,
		|	Table.Amount,
		|	UNDEFINED AS VendorsAdvancesClosing
		|INTO R1020B_AdvancesToVendors
		|FROM
		|	VendorTransaction_Posting AS Table
		|WHERE
		|	Table.IsOutgoingCheque
		|	AND Table.IsAdvance
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
		|	Table.OrderSettlements,
		|	Table.Amount,
		|	UNDEFINED
		|FROM
		|	VendorTransaction_Reversal AS Table
		|WHERE
		|	Table.IsOutgoingCheque
		|	AND Table.IsAdvance
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
		|	Table.OrderSettlements,
		|	Table.Amount,
		|	UNDEFINED
		|FROM
		|	VendorTransaction_Correction AS Table
		|WHERE
		|	Table.IsOutgoingCheque
		|	AND Table.IsAdvance
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
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing";
EndFunction

// Additional data filling.
// 
// Parameters:
//  MovementsValueTable - ValueTable
Procedure AdditionalDataFilling(MovementsValueTable) Export
	Return;	
EndProcedure
