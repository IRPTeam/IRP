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
		|	VALUE(enum.RecordType.Receipt) AS RecordType,
		|	&Period AS Date,
		|	TRUE AS IsCustomerAdvance,
		|	TRUE AS IsSalesOrderClose,
		|	CloseOrder.SalesOrder.Company AS Company,
		|	CloseOrder.SalesOrder.Branch AS Branch,
		|	CloseOrder.SalesOrder.Currency AS Currency,
		|	CloseOrder.SalesOrder.Partner AS Partner,
		|	CloseOrder.SalesOrder.LegalName AS LegalName,
		|	CASE
		|		WHEN CloseOrder.SalesOrder.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN CloseOrder.SalesOrder.Agreement
		|		ELSE UNDEFINED
		|	END AS AdvanceAgreement,
		|	CloseOrder.SalesOrder AS Order,
		|	CloseOrder.Ref AS Ref
		|INTO tmp_T2014S_AdvancesInfo
		|FROM
		|	Document.SalesOrderClosing AS CloseOrder
		|WHERE
		|	CloseOrder.Ref = &Ref
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	tmp_T2014S_AdvancesInfo.RecordType,
		|	tmp_T2014S_AdvancesInfo.Date,
		|	tmp_T2014S_AdvancesInfo.IsCustomerAdvance,
		|	tmp_T2014S_AdvancesInfo.IsSalesOrderClose,
		|	tmp_T2014S_AdvancesInfo.Company,
		|	tmp_T2014S_AdvancesInfo.Branch,
		|	tmp_T2014S_AdvancesInfo.Currency,
		|	tmp_T2014S_AdvancesInfo.Partner,
		|	tmp_T2014S_AdvancesInfo.LegalName,
		|	tmp_T2014S_AdvancesInfo.AdvanceAgreement,
		|	tmp_T2014S_AdvancesInfo.Order,
		|	ISNULL(SalesOrderClosingItemList.Project, VALUE(Catalog.Projects.EmptyRef)) AS Project
		|INTO T2014S_AdvancesInfo
		|FROM
		|	tmp_T2014S_AdvancesInfo AS tmp_T2014S_AdvancesInfo
		|		LEFT JOIN Document.SalesOrderClosing.ItemList AS SalesOrderClosingItemList
		|		ON (SalesOrderClosingItemList.Ref = tmp_T2014S_AdvancesInfo.Ref)";
EndFunction

Function T2014S_AdvancesInfo_POC() Export
	Return 
		"SELECT DISTINCT
		|	VALUE(Enum.RecordType.Receipt) AS RecordType,
		|	&Period AS Date,
		|	TRUE AS IsVendorAdvance,
		|	TRUE AS IsPurchaseOrderClose,
		|	CloseOrder.PurchaseOrder.Company AS Company,
		|	CloseOrder.PurchaseOrder.Branch AS Branch,
		|	CloseOrder.PurchaseOrder.Currency AS Currency,
		|	CloseOrder.PurchaseOrder.Partner AS Partner,
		|	CloseOrder.PurchaseOrder.LegalName AS LegalName,
		|	CASE
		|		WHEN CloseOrder.PurchaseOrder.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN CloseOrder.PurchaseOrder.Agreement
		|		ELSE UNDEFINED
		|	END AS AdvanceAgreement,
		|	CloseOrder.PurchaseOrder AS Order,
		|	CloseOrder.Ref
		|INTO tmp_T2014S_AdvancesInfo
		|FROM
		|	Document.PurchaseOrderClosing AS CloseOrder
		|WHERE
		|	CloseOrder.Ref = &Ref
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	tmp_T2014S_AdvancesInfo.RecordType,
		|	tmp_T2014S_AdvancesInfo.Date,
		|	tmp_T2014S_AdvancesInfo.IsVendorAdvance,
		|	tmp_T2014S_AdvancesInfo.IsPurchaseOrderClose,
		|	tmp_T2014S_AdvancesInfo.Company,
		|	tmp_T2014S_AdvancesInfo.Branch,
		|	tmp_T2014S_AdvancesInfo.Currency,
		|	tmp_T2014S_AdvancesInfo.Partner,
		|	tmp_T2014S_AdvancesInfo.LegalName,
		|	tmp_T2014S_AdvancesInfo.AdvanceAgreement,
		|	tmp_T2014S_AdvancesInfo.Order,
		|	ISNULL(PurchaseOrderClosingItemList.Project, VALUE(Catalog.Projects.EmptyRef)) AS Project
		|INTO T2014S_AdvancesInfo
		|FROM
		|	tmp_T2014S_AdvancesInfo AS tmp_T2014S_AdvancesInfo
		|		LEFT JOIN Document.PurchaseOrderClosing.ItemList AS PurchaseOrderClosingItemList
		|		ON tmp_T2014S_AdvancesInfo.Ref = PurchaseOrderClosingItemList.Ref";
EndFunction

Procedure AdditionalDataFilling(MovementsValueTable) Export
	ArrayForDelete = New Array();
	
	For Each Row In MovementsValueTable Do
		If Row.CurrencyMovementType <> ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	
	For Each Item In ArrayForDelete Do
		MovementsValueTable.Delete(Item);
	EndDo;
EndProcedure
