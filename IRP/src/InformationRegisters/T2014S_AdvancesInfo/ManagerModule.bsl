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
		|	VALUE(Enum.RecordType.Receipt) AS RecordType,
		|	PaymentList.Period AS Date,
		|	PaymentList.Key,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Currency,
		|	PaymentList.Partner,
		|	PaymentList.LegalName,
		|	PaymentList.OrderSettlements AS Order,
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
		|	VALUE(Enum.RecordType.Receipt),
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
	Return 
		"SELECT
		|	VALUE(Enum.RecordType.Receipt) AS RecordType,
		|	PaymentList.Period AS Date,
		|	PaymentList.Key,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Currency,
		|	PaymentList.Partner,
		|	PaymentList.LegalName,
		|	PaymentList.AdvanceAgreement,
		|	PaymentList.Project,
		|	PaymentList.OrderSettlements AS Order,
		|	TRUE AS IsCustomerAdvance,
		|	FALSE AS IsVendorAdvance,
		|	PaymentList.Amount
		|INTO T2014S_AdvancesInfo
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
		|	VALUE(Enum.RecordType.Receipt),
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

Function T2014S_AdvancesInfo_DebitCreditNote() Export
	Return 
		"SELECT
		|
		|	case
		|		when Doc.SendIsCustomerAdvance
		|			then case
		|				when Doc.PartnersIsEqual
		|					then case
		|						when Doc.IsReceiveTransactionCustomer
		|						OR Doc.IsReceiveAdvanceCustomer
		|							then VALUE(Enum.RecordType.Expense)
		|						else VALUE(Enum.RecordType.Receipt)
		|					end
		|				else case
		|					when Doc.IsReceiveTransactionCustomer
		|					OR Doc.IsReceiveAdvanceVendor
		|					OR Doc.IsReceiveTransactionVendor
		|					OR Doc.IsReceiveAdvanceCustomer
		|						then VALUE(Enum.RecordType.Expense)
		|					else VALUE(Enum.RecordType.Receipt)
		|				end
		|			end
		|		else case
		|			when Doc.PartnersIsEqual
		|				then case
		|					when Doc.IsReceiveTransactionVendor
		|					OR Doc.IsReceiveAdvanceVendor
		|						then VALUE(Enum.RecordType.Expense)
		|					else VALUE(Enum.RecordType.Receipt)
		|				end
		|			else case
		|				when Doc.IsReceiveTransactionVendor
		|				OR Doc.IsReceiveAdvanceVendor
		|					then VALUE(Enum.RecordType.Expense)
		|				else VALUE(Enum.RecordType.Receipt)
		|			end
		|		end
		|	end AS RecordType,
		|	Doc.Period AS Date,
		|	Doc.Company AS Company,
		|	Doc.SendBranch AS Branch,
		|	Doc.SendPartner AS Partner,
		|	Doc.SendLegalName AS LegalName,
		|	Doc.Currency AS Currency,
		|	Doc.SendAgreement AS AdvanceAgreement,
		|	Doc.SendProject AS Project,
		|	Doc.SendOrderSettlements AS Order,
		|	Doc.SendIsCustomerAdvance AS IsCustomerAdvance,
		|	Doc.SendIsVendorAdvance AS IsVendorAdvance,
		|	Doc.Amount
		|INTO T2014S_AdvancesInfo
		|FROM
		|	SendAdvances AS Doc
		|
		|UNION ALL
		|
		|SELECT
		|	case
		|		when Doc.ReceiveIsCustomerAdvance
		|			then case
		|				when Doc.PartnersIsEqual
		|					then case
		|						when Doc.IsSendTransactionVendor
		|						OR Doc.IsSendAdvanceCustomer
		|							then VALUE(Enum.RecordType.Receipt)
		|						else VALUE(Enum.RecordType.Expense)
		|					end
		|				else case
		|					when Doc.IsSendTransactionVendor
		|					OR Doc.IsSendAdvanceCustomer
		|						then VALUE(Enum.RecordType.Receipt)
		|					else VALUE(Enum.RecordType.Expense)
		|				end
		|			end
		|		else case
		|			when Doc.PartnersIsEqual
		|				then case
		|					when Doc.IsSendTransactionCustomer
		|					OR Doc.IsSendAdvanceVendor
		|						then VALUE(Enum.RecordType.Receipt)
		|					else VALUE(Enum.RecordType.Expense)
		|				end
		|			else case
		|				when Doc.IsSendTransactionCustomer
		|				OR Doc.IsSendAdvanceVendor
		|					then VALUE(Enum.RecordType.Receipt)
		|				else VALUE(Enum.RecordType.Expense)
		|			end
		|		end
		|	end,
		|	Doc.Period,
		|	Doc.Company,
		|	Doc.ReceiveBranch,
		|	Doc.ReceivePartner,
		|	Doc.ReceiveLegalName,
		|	Doc.Currency,
		|	Doc.ReceiveAgreement,
		|	Doc.ReceiveProject,
		|	Doc.ReceiveOrderSettlements,
		|	Doc.ReceiveIsCustomerAdvance AS IsCustomerAdvance,
		|	Doc.ReceiveIsVendorAdvance AS IsVendorAdvance,
		|	Doc.Amount
		|FROM
		|	ReceiveAdvances AS Doc";
EndFunction

Function T2014S_AdvancesInfo_Cheque() Export 
	Return 
		"SELECT
		|	VALUE(Enum.RecordType.Receipt) AS RecordType,
		|	Table.Period AS Date,
		|	Table.Company,
		|	Table.Branch,
		|	Table.Currency,
		|	Table.Partner,
		|	Table.LegalName,
		|	Table.AdvanceAgreement,
		|	Table.Project,
		|	Table.OrderSettlements AS Order,
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
		|	VALUE(Enum.RecordType.Receipt),
		|	Table.Period,
		|	Table.Company,
		|	Table.Branch,
		|	Table.Currency,
		|	Table.Partner,
		|	Table.LegalName,
		|	Table.AdvanceAgreement,
		|	Table.Project,
		|	Table.OrderSettlements,
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
		|	VALUE(Enum.RecordType.Receipt),
		|	Table.Period,
		|	Table.Company,
		|	Table.Branch,
		|	Table.Currency,
		|	Table.Partner,
		|	Table.LegalName,
		|	Table.AdvanceAgreement,
		|	Table.Project,
		|	Table.OrderSettlements,
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
		|	VALUE(Enum.RecordType.Receipt),
		|	Table.Period,
		|	Table.Company,
		|	Table.Branch,
		|	Table.Currency,
		|	Table.Partner,
		|	Table.LegalName,
		|	Table.AdvanceAgreement,
		|	Table.Project,
		|	Table.OrderSettlements,
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
		|	VALUE(Enum.RecordType.Receipt),
		|	Table.Period,
		|	Table.Company,
		|	Table.Branch,
		|	Table.Currency,
		|	Table.Partner,
		|	Table.LegalName,
		|	Table.AdvanceAgreement,
		|	Table.Project,
		|	Table.OrderSettlements,
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
		|	VALUE(Enum.RecordType.Receipt),
		|	Table.Period,
		|	Table.Company,
		|	Table.Branch,
		|	Table.Currency,
		|	Table.Partner,
		|	Table.LegalName,
		|	Table.AdvanceAgreement,
		|	Table.Project,
		|	Table.OrderSettlements,
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
		|	VALUE(Enum.RecordType.Receipt) AS RecordType,
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
		|	VALUE(Enum.RecordType.Receipt) AS RecordType,
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
