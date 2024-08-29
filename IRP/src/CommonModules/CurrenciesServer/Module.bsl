
Function GetArrayOfPostingInfo(Parameters)
	ArrayOfPostingInfo = New Array();
	If Parameters.Property("ArrayOfPostingInfo") Then
		ArrayOfPostingInfo = Parameters.ArrayOfPostingInfo;
	Else
		For Each PostingInfo In Parameters.PostingDataTables Do
			If Parameters.Property("MultiCurrencyExcludePostingDataTables")
				And Parameters.MultiCurrencyExcludePostingDataTables.Find(PostingInfo.Value.Metadata) <> Undefined Then
				Continue;
			EndIf;

			If Metadata.AccumulationRegisters.Contains(PostingInfo.Value.Metadata) 
				Or Metadata.InformationRegisters.Contains(PostingInfo.Value.Metadata) Then
					
				Dimension = PostingInfo.Value.Metadata.Dimensions.Find("CurrencyMovementType");
				// Register supported multicurrency
				If Dimension <> Undefined Then
					ArrayOfPostingInfo.Add(PostingInfo);
				EndIf;
			EndIf;
		EndDo;
	EndIf;
	Return ArrayOfPOstingInfo;
EndFunction

Function PutCurrencyTableToTempTablesManager(Parameters, CurrencyTable)
	Query = New Query();
	Query.TempTablesManager = New TempTablesManager();
	Query.Text =
	"SELECT
	|	*
	|INTO CurrencyTable
	|FROM
	|	&CurrencyTable AS CurrencyTable";
	
	If CurrencyTable = Undefined Then
		Query.SetParameter("CurrencyTable", Parameters.Object.Currencies.Unload());
	Else
		Query.SetParameter("CurrencyTable", CurrencyTable);
	EndIf;
	Query.Execute();
	Return Query.TempTablesManager;
EndFunction

Procedure PreparePostingDataTables(Parameters, CurrencyTable, AddInfo = Undefined) Export
	ArrayOfPostingInfo = GetArrayOfPostingInfo(Parameters);
		
	If ArrayOfPostingInfo.Count() = 0 Then
 		Return; // not support currencies
 	EndIf;
	
	If CurrencyTable = Undefined Then
		If Parameters.Metadata.TabularSections.Find("Currencies") = Undefined Then
			Return;
		EndIf;
	EndIf;
	
	TempTablesManager = PutCurrencyTableToTempTablesManager(Parameters, CurrencyTable);
		
	PartnerBalanceTables = GetPartnerBalanceTables();
	
	If Parameters.Property("PostingDataTables") Then
		TransactionInfo = Parameters.PostingDataTables.Get(Metadata.InformationRegisters.T2015S_TransactionsInfo);
		If TransactionInfo <> Undefined Then
			PartnerBalanceTables.T2015S_TransactionsInfo = TransactionInfo.PrepareTable;
		EndIf;
	
		AdvanceInfo = Parameters.PostingDataTables.Get(Metadata.InformationRegisters.T2014S_AdvancesInfo);
		If AdvanceInfo <> Undefined Then
			PartnerBalanceTables.Table_T2014S_AdvancesInfo = AdvanceInfo.PrepareTable;
		EndIf;
	EndIf;
	
	For Each ItemOfPostingInfo In ArrayOfPostingInfo Do
		ItemOfPostingInfo = ItemOfPostingInfo.Value;
		If ItemOfPostingInfo.PrepareTable.Count() = 0 Then
			Continue; // register is empty
		EndIf;
		
		UseAgreementMovementType = IsUseAgreementMovementType(ItemOfPostingInfo.Metadata);
		UseLegalMovementType = IsUseLegalMovementType(ItemOfPostingInfo.Metadata);
		UseCurrencyJoin = IsUseCurrencyJoin(Parameters, ItemOfPostingInfo.Metadata);
		UseKey = ItemOfPostingInfo.PrepareTable.Columns.Find("Key") <> Undefined;
		
		IncludeDimensions = "";
		IncludeDimensionsMap = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "IncludeDimensions");
		If IncludeDimensionsMap <> Undefined Then
			_IncludeDimensions = IncludeDimensionsMap.Get(ItemOfPostingInfo.Metadata);
			If _IncludeDimensions <> Undefined Then
				IncludeDimensions = _IncludeDimensions;
			EndIf;
		EndIf;
		
		PrepareTable = ItemOfPostingInfo.PrepareTable;
		If ItemOfPostingInfo.Metadata = Metadata.AccumulationRegisters.T1040T_AccountingAmounts Then
			FullTable = ExpandTable(TempTablesManager, PrepareTable, UseAgreementMovementType, UseCurrencyJoin, UseKey);
			GroupTableByAllDimensions(PrepareTable, ItemOfPostingInfo.Metadata, UseKey, "RowKey", IncludeDimensions);	
			GroupedTable = ExpandTable(TempTablesManager, PrepareTable, UseAgreementMovementType, UseCurrencyJoin, UseKey);
			
			Table = AlignTables(FullTable, GroupedTable, ItemOfPostingInfo.Metadata, UseKey);
					
		Else
			Table = ExpandTable(TempTablesManager, PrepareTable, UseAgreementMovementType, UseCurrencyJoin, UseKey);
			GroupTableByAllDimensions(Table, ItemOfPostingInfo.Metadata, UseKey, "", IncludeDimensions);
		EndIf;
		ItemOfPostingInfo.PrepareTable = SetTransactionCurrency(Table, ItemOfPostingInfo.Metadata, 
																UseKey, 
																UseAgreementMovementType,
																UseLegalMovementType);
					
		PutToPartnerBalanceTables(PartnerBalanceTables, ItemOfPostingInfo.Metadata, ItemOfPostingInfo.PrepareTable);
							
	EndDo;
	
	IsOffsetOfAdvances          = CommonFunctionsClientServer.GetFromAddInfo(Parameters, "IsOffsetOfAdvances", False);
	IsDebitCreditNoteDifference = CommonFunctionsClientServer.GetFromAddInfo(Parameters, "IsDebitCreditNoteDifference", False);
	
	// currencies rate difference on money transfer
	ExchangeDifference(Parameters);
	
	// currencies rate difference on debit/credit note with difference currencies
	If Not IsDebitCreditNoteDifference And Not IsOffsetOfAdvances Then
		DebitCreditNoteDifference(Parameters);
	EndIf;
	
	If Not IsOffsetOfAdvances Then
		UpdatePartnerBalanceTables(PartnerBalanceTables);
	EndIf;
EndProcedure

Function IsUseAgreementMovementType(RegMetadata)
	// return true if use else (not use) return false	
	
	Reg = Metadata.AccumulationRegisters;
	
	Registers = New Array();
	Registers.Add(Reg.R2020B_AdvancesFromCustomers);
	Registers.Add(Reg.R2021B_CustomersTransactions);
	Registers.Add(Reg.R1020B_AdvancesToVendors);
	Registers.Add(Reg.R1021B_VendorsTransactions);
	Registers.Add(Reg.R5015B_OtherPartnersTransactions);
	Registers.Add(Reg.R5020B_PartnersBalance);
	
	Registers.Add(Reg.R8014T_ConsignorSales);
	Registers.Add(Reg.R8015T_ConsignorPrices);
	
	Registers.Add(Reg.R3027B_EmployeeCashAdvance);
	
	If Registers.Find(RegMetadata) = Undefined Then
		Return False;
	Else
		Return True;
	EndIf;
EndFunction

Function IsUseLegalMovementType(RegMetadata)
	// return true if use else (not use) return false	
	
	Reg = Metadata.AccumulationRegisters;
	
	Registers = New Array();
	Registers.Add(Reg.R2040B_TaxesIncoming);
	Registers.Add(Reg.R1040B_TaxesOutgoing);
	
	If Registers.Find(RegMetadata) = Undefined Then
		Return False;
	Else
		Return True;
	EndIf;
EndFunction

Function IsUseCurrencyJoin(Parameters, RecMetadata)
	UseCurrencyJoin = False;

	ArrayOfRecMetadata = New Array();
	ArrayOfRecMetadata.Add(Metadata.AccumulationRegisters.R3035T_CashPlanning);
	ArrayOfRecMetadata.Add(Metadata.AccumulationRegisters.R3010B_CashOnHand);
	ArrayOfRecMetadata.Add(Metadata.AccumulationRegisters.R3015B_CashAdvance);
	ArrayOfRecMetadata.Add(Metadata.AccumulationRegisters.R2021B_CustomersTransactions);
	ArrayOfRecMetadata.Add(Metadata.AccumulationRegisters.R1021B_VendorsTransactions);

	FilterByDocument = False;

	If (TypeOf(Parameters.Object) = Type("DocumentObject.BankReceipt") Or TypeOf(Parameters.Object) = Type("DocumentRef.BankReceipt")) 
		And Parameters.Object.TransactionType = Enums.IncomingPaymentTransactionType.CurrencyExchange Then
		FilterByDocument = True;
	EndIf;

	If (TypeOf(Parameters.Object) = Type("DocumentObject.CashReceipt") Or TypeOf(Parameters.Object) = Type("DocumentRef.CashReceipt")) 
		And Parameters.Object.TransactionType = Enums.IncomingPaymentTransactionType.CurrencyExchange Then
		FilterByDocument = True;
	EndIf;

	If FilterByDocument And ArrayOfRecMetadata.Find(RecMetadata) <> Undefined Then
		UseCurrencyJoin = True;
	EndIf;

	Return UseCurrencyJoin;
EndFunction

Function GetArrayOfResourceNames()
	ArrayOfRecourceNames = New Array();
	
	ArrayOfRecourceNames.Add("Amount");
	ArrayOfRecourceNames.Add("ManualAmount");
	ArrayOfRecourceNames.Add("NetAmount");
	ArrayOfRecourceNames.Add("OffersAmount");
	ArrayOfRecourceNames.Add("SalesAmount");
	ArrayOfRecourceNames.Add("NetOfferAmount");
	ArrayOfRecourceNames.Add("AmountWithTaxes");
	ArrayOfRecourceNames.Add("Commission");
	ArrayOfRecourceNames.Add("AmountTax");
	ArrayOfRecourceNames.Add("Price");
	ArrayOfRecourceNames.Add("ConsignorPrice");
	ArrayOfRecourceNames.Add("SalesAmount");
	ArrayOfRecourceNames.Add("NetOfferAmount");
	ArrayOfRecourceNames.Add("CustomerTransaction");
	ArrayOfRecourceNames.Add("CustomerAdvance");
	ArrayOfRecourceNames.Add("VendorTransaction");
	ArrayOfRecourceNames.Add("VendorAdvance");
	ArrayOfRecourceNames.Add("OtherTransaction");
	ArrayOfRecourceNames.Add("TaxableAmount");
	ArrayOfRecourceNames.Add("TaxAmount");
	ArrayOfRecourceNames.Add("InvoiceAmount");
	ArrayOfRecourceNames.Add("InvoiceTaxAmount");
	ArrayOfRecourceNames.Add("IndirectCostAmount");
	ArrayOfRecourceNames.Add("IndirectCostTaxAmount");
	ArrayOfRecourceNames.Add("ExtraCostAmountByRatio");
	ArrayOfRecourceNames.Add("ExtraCostTaxAmountByRatio");
	ArrayOfRecourceNames.Add("ExtraDirectCostAmount");
	ArrayOfRecourceNames.Add("ExtraDirectCostTaxAmount");
	ArrayOfRecourceNames.Add("AllocatedCostAmount");
	ArrayOfRecourceNames.Add("AllocatedCostTaxAmount");
	ArrayOfRecourceNames.Add("AllocatedRevenueAmount");
	ArrayOfRecourceNames.Add("AllocatedRevenueTaxAmount");
	
	Return ArrayOfRecourceNames;
EndFunction

Procedure AddAmountsColumns(RecordSet, ColumnName)
	If RecordSet.Columns.Find(ColumnName) = Undefined Then
		RecordSet.Columns.Add(ColumnName, Metadata.DefinedTypes.typeAmount.Type);
		RecordSet.FillValues(0, ColumnName);
	EndIf;
EndProcedure

Function ExpandTable(TempTableManager, Table, UseAgreementMovementType, UseCurrencyJoin, UseKey)
	
	ArrayOfRecourceNames = GetArrayOfResourceNames();
	
	For Each ResourceName In ArrayOfRecourceNames Do
		AddAmountsColumns(Table, ResourceName);
	EndDo;
	
	Query = New Query();
	Query.TempTablesManager = TempTableManager;
	Query.Text =
	"SELECT
	|	*
	|INTO RecordSet
	|FROM
	|	&RecordSet AS RecordSet
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	RecordSet.*,
	|	CurrencyTable.MovementType AS CurrencyMovementType,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.NetOfferAmount * CurrencyTable.Rate) / CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS NetOfferAmount,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.SalesAmount * CurrencyTable.Rate) / CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS SalesAmount,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.Amount * CurrencyTable.Rate) / CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS Amount,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.ManualAmount * CurrencyTable.Rate) / CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS ManualAmount,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.NetAmount * CurrencyTable.Rate) / CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS NetAmount,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.OffersAmount * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS OffersAmount,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.AmountWithTaxes * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS AmountWithTaxes,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.Commission * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS Commission,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.AmountTax * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS AmountTax,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.Price * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS Price,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.ConsignorPrice * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS ConsignorPrice,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.CustomerTransaction * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS CustomerTransaction,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.CustomerAdvance * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS CustomerAdvance,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.VendorTransaction * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS VendorTransaction,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.VendorAdvance * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS VendorAdvance,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.OtherTransaction * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS OtherTransaction,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.TaxableAmount * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS TaxableAmount,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.TaxAmount * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS TaxAmount,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.InvoiceAmount * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS InvoiceAmount,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.InvoiceTaxAmount * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS InvoiceTaxAmount,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.IndirectCostAmount * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS IndirectCostAmount,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.IndirectCostTaxAmount * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS IndirectCostTaxAmount,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.ExtraCostAmountByRatio * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS ExtraCostAmountByRatio,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.ExtraCostTaxAmountByRatio * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS ExtraCostTaxAmountByRatio,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.ExtraDirectCostAmount * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS ExtraDirectCostAmount,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.ExtraDirectCostTaxAmount * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS ExtraDirectCostTaxAmount,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.AllocatedCostAmount * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS AllocatedCostAmount,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.AllocatedCostTaxAmount * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS AllocatedCostTaxAmount,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.AllocatedRevenueAmount * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS AllocatedRevenueAmount,
	|	ROUND(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.AllocatedRevenueTaxAmount * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END, &RoundDigitCapacity) AS AllocatedRevenueTaxAmount,
	|	CurrencyTable.MovementType.DeferredCalculation AS DeferredCalculation,
	|	CurrencyTable.MovementType.Currency AS Currency
	|FROM
	|	RecordSet AS RecordSet
	|		LEFT JOIN CurrencyTable AS CurrencyTable
	|		ON CASE
	|			WHEN &UseKey
	|				THEN RecordSet.Key = CurrencyTable.Key
	|			ELSE TRUE
	|		END
	|		AND 
	|		CASE WHEN &UseCurrencyJoin THEN RecordSet.Currency = CurrencyTable.CurrencyFrom ELSE TRUE END
	|WHERE
	|	NOT CurrencyTable.MovementType IS NULL
	|	AND CASE
	|		WHEN &UseAgreementMovementType
	|			THEN TRUE
	|		ELSE CurrencyTable.MovementType.Type <> VALUE(enum.CurrencyType.Agreement)
	|	END
	|
	|UNION ALL
	|
	|SELECT
	|	RecordSet.*,
	|	VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency),
	|	ROUND(RecordSet.NetOfferAmount, &RoundDigitCapacity) AS NetOfferAmount,
	|	ROUND(RecordSet.SalesAmount, &RoundDigitCapacity) AS SalesAmount,
	|	ROUND(RecordSet.Amount, &RoundDigitCapacity) AS Amount,
	|	ROUND(RecordSet.ManualAmount, &RoundDigitCapacity) AS ManualAmount,
	|	ROUND(RecordSet.NetAmount, &RoundDigitCapacity) AS NetAmount,
	|	ROUND(RecordSet.OffersAmount, &RoundDigitCapacity) AS OffersAmount,
	|	ROUND(RecordSet.AmountWithTaxes, &RoundDigitCapacity) AS AmountWithTaxes,
	|	ROUND(RecordSet.Commission, &RoundDigitCapacity) AS Commission,
	|	ROUND(RecordSet.AmountTax, &RoundDigitCapacity) AS AmountTax,
	|	ROUND(RecordSet.Price, &RoundDigitCapacity) AS Price,
	|	ROUND(RecordSet.ConsignorPrice, &RoundDigitCapacity) AS ConsignorPrice,
	|	ROUND(RecordSet.CustomerTransaction, &RoundDigitCapacity) AS CustomerTransaction,
	|	ROUND(RecordSet.CustomerAdvance, &RoundDigitCapacity) AS CustomerAdvance,
	|	ROUND(RecordSet.VendorTransaction, &RoundDigitCapacity) AS VendorTransaction,
	|	ROUND(RecordSet.VendorAdvance, &RoundDigitCapacity) AS VendorAdvance,
	|	ROUND(RecordSet.OtherTransaction, &RoundDigitCapacity) AS OtherTransaction,
	|	ROUND(RecordSet.TaxableAmount, &RoundDigitCapacity) AS TaxableAmount,
	|	ROUND(RecordSet.TaxAmount, &RoundDigitCapacity) AS TaxAmount,
	|	ROUND(RecordSet.InvoiceAmount, &RoundDigitCapacity) AS InvoiceAmount,
	|	ROUND(RecordSet.InvoiceTaxAmount, &RoundDigitCapacity) AS InvoiceTaxAmount,
	|	ROUND(RecordSet.IndirectCostAmount, &RoundDigitCapacity) AS IndirectCostAmount,
	|	ROUND(RecordSet.IndirectCostTaxAmount, &RoundDigitCapacity) AS IndirectCostTaxAmount,
	|	ROUND(RecordSet.ExtraCostAmountByRatio, &RoundDigitCapacity) AS ExtraCostAmountByRatio,
	|	ROUND(RecordSet.ExtraCostTaxAmountByRatio, &RoundDigitCapacity) AS ExtraCostTaxAmountByRatio,
	|	ROUND(RecordSet.ExtraDirectCostAmount, &RoundDigitCapacity) AS ExtraDirectCostAmount,
	|	ROUND(RecordSet.ExtraDirectCostTaxAmount, &RoundDigitCapacity) AS ExtraDirectCostTaxAmount,
	|	ROUND(RecordSet.AllocatedCostAmount, &RoundDigitCapacity) AS AllocatedCostAmount,
	|	ROUND(RecordSet.AllocatedCostTaxAmount, &RoundDigitCapacity) AS AllocatedCostTaxAmount,
	|	ROUND(RecordSet.AllocatedRevenueAmount, &RoundDigitCapacity) AS AllocatedRevenueAmount,
	|	ROUND(RecordSet.AllocatedRevenueTaxAmount, &RoundDigitCapacity) AS AllocatedRevenueTaxAmount,
	|	FALSE,
	|	RecordSet.Currency
	|FROM
	|	RecordSet AS RecordSet
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|DROP RecordSet";
	If Not UseKey And Table.Columns.Find("Key") = Undefined Then
		Table.Columns.Add("Key", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	EndIf;

	Query.SetParameter("RecordSet", Table);
	Query.SetParameter("UseKey", UseKey);
	Query.SetParameter("UseAgreementMovementType", UseAgreementMovementType);
	Query.SetParameter("UseCurrencyJoin", UseCurrencyJoin);
	Query.SetParameter("RoundDigitCapacity", Metadata.DefinedTypes.typeAmount.Type.NumberQualifiers.FractionDigits);
	QueryResults = Query.ExecuteBatch();
	QueryTable = QueryResults[1].Unload();
		
	Return QueryTable;
EndFunction

Function AlignTables(FullTable, GroupedTable, RegMetadata, UseKey)

	ArrayOfCurrencyMovementTypes = New Array();
	For Each Row In GroupedTable Do
		If ArrayOfCurrencyMovementTypes.Find(Row.CurrencyMovementType) = Undefined Then
			ArrayOfCurrencyMovementTypes.Add(Row.CurrencyMovementType);
		EndIf;
	EndDo;
		
	For Each CurrencyMovementType In ArrayOfCurrencyMovementTypes Do
			
		GroupedTableRows = GroupedTable.FindRows(New Structure("CurrencyMovementType", CurrencyMovementType));
		
		For Each RowGrouped In GroupedTableRows Do
			TotalsGroupedTable = New Structure();
				
			For Each ResourceName In GetArrayOfResourceNames() Do
				If CommonFunctionsClientServer.ObjectHasProperty(RowGrouped, ResourceName) Then
					If TotalsGroupedTable.Property(ResourceName) Then
						TotalsGroupedTable[ResourceName] = TotalsGroupedTable[ResourceName] + RowGrouped[ResourceName];
					Else
						TotalsGroupedTable.Insert(ResourceName, RowGrouped[ResourceName]);
					EndIf;
				EndIf;
			EndDo;
			
			Filter = New Structure(StrConcat(GetGroupColumns(FullTable, RegMetadata, UseKey, "RowKey", ""),","));
			FillPropertyValues(Filter, RowGrouped);
			
			FullTableRows = FullTable.FindRows(Filter);			
			TotalsFullTable = New Structure();
			
			For Each RowFull In FullTableRows Do
				For Each ResourceName In GetArrayOfResourceNames() Do
					If CommonFunctionsClientServer.ObjectHasProperty(RowFull, ResourceName) Then
						If TotalsFullTable.Property(ResourceName) Then
							TotalsFullTable[ResourceName] = TotalsFullTable[ResourceName] + RowFull[ResourceName];
						Else
							TotalsFullTable.Insert(ResourceName, RowFull[ResourceName]);
						EndIf;
					EndIf;
				EndDo;
			EndDo;
		
			// compare resource amounts
			For Each KeyValue In TotalsGroupedTable Do
				ResourceName = KeyValue.Key;
				
				Difference = TotalsGroupedTable[ResourceName] - TotalsFullTable[ResourceName];
				If Difference <> 0 Then
					// find max row in full table
					MaxRow = Undefined;
				
					For Each Row In FullTableRows Do
						If MaxRow = Undefined Then
							MaxRow = Row;
						Else
							If MaxRow[ResourceName] < Row[ResourceName] Then
								MaxRow = Row;
							EndIf;
						EndIf;
					EndDo;
				
					If MaxRow <> Undefined Then
						MaxRow[ResourceName] = MaxRow[ResourceName] + Difference;
					EndIf;
				EndIf;
			EndDo; // TotalsGroupedTable
				
		EndDo;
			
	EndDo;
	
	Return FullTable;
EndFunction

Function GetGroupColumns(Table, RegMetadata, UseKey, ExcludeDimensions, IncludeDimensions)
	GroupColumns = New Array();
	ArrayOfExludeDimensions = StrSplit(StrReplace(Lower(ExcludeDimensions)," ",""), ",", False);
	ArrayOfIncludeDimensions = StrSplit(StrReplace(Lower(IncludeDimensions)," ",""), ",", False);
		
	If UseKey Then
		GroupColumns.Add("Key");
	EndIf;
	
	For Each Field In ArrayOfIncludeDimensions Do
		If Table.Columns.Find(Field) <> Undefined Then
			GroupColumns.Add(Field)
		EndIf;		
	EndDo;
	
	For Each Field In RegMetadata.Dimensions Do
		If ArrayOfExludeDimensions.Find(Lower(Field.Name)) <> Undefined Then
			Continue;
		EndIf;
		
		If Table.Columns.Find(Field.Name) <> Undefined Then
			GroupColumns.Add(Field.Name)
		EndIf;
	EndDo;
	
	For Each Field In RegMetadata.Attributes Do
		If Table.Columns.Find(Field.Name) <> Undefined Then
			GroupColumns.Add(Field.Name)
		EndIf;		
	EndDo;
	
	For Each Field In RegMetadata.StandardAttributes Do
		If Table.Columns.Find(Field.Name) <> Undefined Then
			GroupColumns.Add(Field.Name)
		EndIf;		
	EndDo;
	
	Return GroupColumns;
EndFunction

Procedure GroupTableByAllDimensions(Table, RegMetadata, UseKey, ExcludeDimensions, IncludeDimensions)
	GroupColumns = GetGroupColumns(Table, RegMetadata, UseKey, ExcludeDimensions, IncludeDimensions); 
	SummColumn = New Array();
	
	For Each Field In RegMetadata.Resources Do
		If Table.Columns.Find(Field.Name) <> Undefined Then
			SummColumn.Add(Field.Name)
		EndIf;				
	EndDo;
	
	Table.GroupBy(StrConcat(GroupColumns, ","), StrConcat(SummColumn, ","));
EndProcedure

Function SetTransactionCurrency(ExpandTable, RegMetadata, UseKey, UseAgreementMovementType, UseLegalMovementType)
	If ExpandTable.Columns.Find("TransactionCurrency") = Undefined Then
		Return ExpandTable;
	EndIf;
		
	TrnRows = ExpandTable.FindRows(New Structure("CurrencyMovementType", 
		ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency));
	
	If TrnRows.Count() = 0 Then
		Return ExpandTable;
	EndIf;		
	
	ExcludeDimensions = New Array();
	ExcludeDimensions.Add(Lower("TransactionCurrency")); 
	ExcludeDimensions.Add(Lower("Currency")); 
	ExcludeDimensions.Add(Lower("CurrencyMovementType")); 
	ExcludeDimensions.Add(Lower("Price")); 
	
	If UseAgreementMovementType Then
		AgrRows = New Array();
	
		For Each Row In ExpandTable Do
			If Row.CurrencyMovementType.Type = Enums.CurrencyType.Agreement Then
				AgrRows.Add(Row);
			EndIf;
		EndDo;
		
		ReplaceTransactionCurrency(ExpandTable, TrnRows, AgrRows, ExcludeDimensions, RegMetadata, UseKey);
		
		For Each AgrRow In AgrRows Do
			ExpandTable.Delete(AgrRow);
		EndDo;		
	EndIf;
		
	If UseLegalMovementType Then
		LegalRows = New Array();
	
		For Each Row In ExpandTable Do
			If Row.CurrencyMovementType.Type = Enums.CurrencyType.Legal Then
				LegalRows.Add(Row);
			EndIf;
		EndDo;
		
		ReplaceTransactionCurrency(ExpandTable, TrnRows, LegalRows, ExcludeDimensions, RegMetadata, UseKey);
	EndIf;
				
	For Each TrnRow In TrnRows Do
		For Each Row In ExpandTable Do
			If UseKey And ValueIsFilled(TrnRow.Key) And Row.Key <> TrnRow.Key Then 
				Continue;
			EndIf;
			
			DimensionsMatch = True;
			For Each RegDimension In RegMetadata.Dimensions Do   
				If ExcludeDimensions.Find(Lower(RegDimension.Name)) <> Undefined Then
					Continue;
				EndIf;
					
				If TrnRow[RegDimension.Name] <> Row[RegDimension.Name] Then
					DimensionsMatch = False;
					Break;
				EndIf;
			EndDo;
				
			If Not DimensionsMatch Then
				Continue;
			EndIf;
				
			Row.TransactionCurrency = TrnRow.Currency;
		EndDo;
	EndDo;
	
	Return ExpandTable;
EndFunction

Procedure ReplaceTransactionCurrency(ExpandTable, TrnRows, OtherRows, ExcludeDimensions, RegMetadata, UseKey)
	
	ArrayOfResourceNames = GetArrayOfResourceNames();
			
	MatchingColumns = New Array();
	For Each RegDimension In RegMetadata.Dimensions Do
		MatchingColumns.Add(Lower(RegDimension.Name));
	EndDo;
	MatchingColumns.Add(Lower("RecordType"));
		
	For Each OtherRow In OtherRows Do
		For Each TrnRow In TrnRows Do
								
			If UseKey And ValueIsFilled(OtherRow.Key) And TrnRow.Key <> OtherRow.Key Then
				Continue;
			EndIf;
			
			DimensionsMatch = True;
			For Each MatchingColumn In MatchingColumns Do   
				If ExcludeDimensions.Find(Lower(MatchingColumn)) <> Undefined Then
					Continue;
				EndIf;
				
				If CommonFunctionsClientServer.ObjectHasProperty(OtherRow, MatchingColumn)
					And CommonFunctionsClientServer.ObjectHasProperty(TrnRow, MatchingColumn) Then
					If OtherRow[MatchingColumn] <> TrnRow[MatchingColumn] Then
						DimensionsMatch = False;
						Break;
					EndIf;
				EndIf;
			EndDo;
			
			If Not DimensionsMatch Then
				Continue;
			EndIf;
			
			TrnRow.Currency = OtherRow.Currency;
			For Each ResourceName In ArrayOfResourceNames Do 
				If CommonFunctionsClientServer.ObjectHasProperty(TrnRow, ResourceName)
					And CommonFunctionsClientServer.ObjectHasProperty(OtherRow, ResourceName) Then
					TrnRow[ResourceName] = OtherRow[ResourceName];
				EndIf;
			EndDo;
				
		EndDo;
	EndDo;		
EndProcedure

Function GetEmptyCurrenciesTable(RefMetadata)
	Columns = RefMetadata.TabularSections.Currencies.Attributes;
	EmptyCurrenciesTable = New ValueTable();
	EmptyCurrenciesTable.Columns.Add("Key"             , Columns.Key.Type);
	EmptyCurrenciesTable.Columns.Add("IsFixed"         , Columns.IsFixed.Type);
	EmptyCurrenciesTable.Columns.Add("CurrencyFrom"    , Columns.CurrencyFrom.Type);
	EmptyCurrenciesTable.Columns.Add("Rate"            , Columns.Rate.Type);
	EmptyCurrenciesTable.Columns.Add("ReverseRate"     , Columns.ReverseRate.Type);
	EmptyCurrenciesTable.Columns.Add("ShowReverseRate" , Columns.ShowReverseRate.Type);
	EmptyCurrenciesTable.Columns.Add("Multiplicity"    , Columns.Multiplicity.Type);
	EmptyCurrenciesTable.Columns.Add("MovementType"    , Columns.MovementType.Type);
	EmptyCurrenciesTable.Columns.Add("Amount"          , Columns.Amount.Type);
	Return EmptyCurrenciesTable;
EndFunction

Procedure UpdateCurrencyTable(Parameters, CurrenciesTable) Export
	EmptyCurrenciesTable = GetEmptyCurrenciesTable(Parameters.Ref.Metadata());
	
	RatePeriod    = CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(Parameters.Ref, Parameters.Date);
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(Parameters.Agreement);
	
	// Agreement currency
	If AgreementInfo <> Undefined And ValueIsFilled(AgreementInfo.Ref) Then
		AddRowToCurrencyTable(Parameters, RatePeriod, EmptyCurrenciesTable, AgreementInfo.CurrencyMovementType);
	EndIf;
	
	// Legal currency
	For Each ItemOfArray In Catalogs.Companies.GetLegalCurrencies(Parameters.Company) Do
		AddRowToCurrencyTable(Parameters, RatePeriod, EmptyCurrenciesTable, ItemOfArray.CurrencyMovementType);
	EndDo;
	
	// Reporting currency
	For Each ItemOfArray In Catalogs.Companies.GetReportingCurrencies(Parameters.Company) Do
		AddRowToCurrencyTable(Parameters, RatePeriod, EmptyCurrenciesTable, ItemOfArray.CurrencyMovementType);
	EndDo;
	
	// Budgeting currency
	For Each ItemOfArray In Catalogs.Companies.GetBudgetingCurrencies(Parameters.Company) Do
		AddRowToCurrencyTable(Parameters, RatePeriod, EmptyCurrenciesTable, ItemOfArray.CurrencyMovementType);
	EndDo;
	
	CurrenciesClientServer.CalculateAmount(EmptyCurrenciesTable, Parameters.DocumentAmount);
	
	For Each Row In Parameters.Currencies Do
		Filter = New Structure("Key, CurrencyFrom, MovementType");
		FillPropertyValues(Filter, Row);
		ArrayOfRows = EmptyCurrenciesTable.FindRows(Filter);
		If ArrayOfRows.Count() And Row.IsFixed Then
			NewRow = CurrenciesTable.Add();
			FillPropertyValues(NewRow, Row);
			If CommonFunctionsClientServer.ObjectHasProperty(NewRow, "RatePresentation") Then
				NewRow.RatePresentation = ?(Row.ShowReverseRate = True, Row.ReverseRate, Row.Rate);
			EndIf;
			If CommonFunctionsClientServer.ObjectHasProperty(NewRow, "IsVisible") Then
				NewRow.IsVisible = (Row.CurrencyFrom <> Row.MovementType.Currency);
			EndIf;
		EndIf;
	EndDo;
	
	For Each Row In EmptyCurrenciesTable Do
		Filter = New Structure("Key, CurrencyFrom, MovementType");
		FillPropertyValues(Filter, Row);
		ArrayOfRows = CurrenciesTable.FindRows(Filter);
		If Not ArrayOfRows.Count() Then
			NewRow = CurrenciesTable.Add();
			FillPropertyValues(NewRow, Row);
			
			ShowReverseRate = False;
			For Each ItemOfArray In Parameters.Currencies Do
				If CurrencyRowMatchFilter(ItemOfArray, Filter) And ItemOfArray.ShowReverseRate Then
						ShowReverseRate = True;
						Break;
				EndIf;
			EndDo;
			NewRow.ShowReverseRate = ShowReverseRate;
			
			If CommonFunctionsClientServer.ObjectHasProperty(NewRow, "RatePresentation") Then
				NewRow.RatePresentation = ?(Row.ShowReverseRate = True, Row.ReverseRate, Row.Rate);
			EndIf;
			If CommonFunctionsClientServer.ObjectHasProperty(NewRow, "IsVisible") Then
				NewRow.IsVisible = (Row.CurrencyFrom <> Row.MovementType.Currency);
			EndIf;
			If CommonFunctionsClientServer.ObjectHasProperty(NewRow, "RateOrigin") Then
				NewRow.RateOrigin = Row.Rate;
			EndIf;
			If CommonFunctionsClientServer.ObjectHasProperty(NewRow, "ReverseRateOrigin") Then
				NewRow.ReverseRateOrigin = Row.ReverseRate;
			EndIf;
			If CommonFunctionsClientServer.ObjectHasProperty(NewRow, "MultiplicityOrigin") Then
				NewRow.MultiplicityOrigin = Row.Multiplicity;
			EndIf;
		Else
			For Each ItemOfArray In ArrayOfRows Do
				If CommonFunctionsClientServer.ObjectHasProperty(NewRow, "RateOrigin") Then
					ItemOfArray.RateOrigin = Row.Rate;
				EndIf;
				If CommonFunctionsClientServer.ObjectHasProperty(NewRow, "ReverseRateOrigin") Then
					ItemOfArray.ReverseRateOrigin = Row.ReverseRate;
				EndIf;
				If CommonFunctionsClientServer.ObjectHasProperty(NewRow, "MultiplicityOrigin") Then
					ItemOfArray.MultiplicityOrigin = Row.Multiplicity;
				EndIf;
				CurrenciesClientServer.CalculateAmountByRow(ItemOfArray, Parameters.DocumentAmount);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Function GetNewCurrencyRowParameters() Export
	Parameters = New Structure();
	Parameters.Insert("RowKey", Undefined);
	Parameters.Insert("Currency", Undefined);
	Parameters.Insert("Ref", Undefined);
	Return Parameters;
EndFunction							

Function AddRowToCurrencyTable(Parameters, RatePeriod, CurrenciesTable, CurrencyMovementType, FixedRates = Undefined) Export
	If FixedRates <> Undefined Then
		TableOfFixedRates = New ValueTable();
		TableOfFixedRates.Columns.Add("Key");
		TableOfFixedRates.Columns.Add("CurrencyFrom");
		TableOfFixedRates.Columns.Add("MovementType");
		TableOfFixedRates.Columns.Add("Rate");
		TableOfFixedRates.Columns.Add("ReverseRate");
		TableOfFixedRates.Columns.Add("Multiplicity");
		
		For Each Row In FixedRates Do
			FillPropertyValues(TableOfFixedRates.Add(), Row);
		EndDo;
	EndIf;
	
	NewRow = CurrenciesTable.Add();
	NewRow.Key = Parameters.RowKey;
	NewRow.CurrencyFrom = Parameters.Currency;
	NewRow.MovementType = CurrencyMovementType;
	If Not CurrencyMovementType.DeferredCalculation Then
		
		UseFixedRates = False;
		UseBasisDocumentRates = False;
		
		// fixed rates from document
		If FixedRates <> Undefined Then
			Filter = New Structure();
			Filter.Insert("CurrencyFrom" , NewRow.CurrencyFrom);
			Filter.Insert("MovementType" , NewRow.MovementType);
			
			RowsFixedRates = TableOfFixedRates.FindRows(Filter);
			If RowsFixedRates.Count() Then
				UseFixedRates = True;
				
				NewRow.Rate         = RowsFixedRates[0].Rate;
				NewRow.ReverseRate  = RowsFixedRates[0].ReverseRate;
				NewRow.Multiplicity = RowsFixedRates[0].Multiplicity;
			EndIf;
		EndIf;
		
		// rates from basis document
		If Parameters.Property("DocObject") Then
			
			DocMetadata = Parameters.DocObject.Metadata();
			If (DocMetadata = Metadata.Documents.ExpenseAccruals 
				Or DocMetadata = Metadata.Documents.RevenueAccruals)
				And ValueIsFilled(Parameters.DocObject.Basis) Then
				
				Filter = New Structure();
				Filter.Insert("CurrencyFrom" , NewRow.CurrencyFrom);
				Filter.Insert("MovementType" , NewRow.MovementType);
			
				RowsBasisDocumentRates = Parameters.DocObject.Basis.Currencies.FindRows(Filter);
				If RowsBasisDocumentRates.Count() Then
					UseBasisDocumentRates = True;				
					NewRow.Rate         = RowsBasisDocumentRates[0].Rate;
					NewRow.ReverseRate  = RowsBasisDocumentRates[0].ReverseRate;
					NewRow.Multiplicity = RowsBasisDocumentRates[0].Multiplicity;
				EndIf;
			EndIf;
		EndIf;
		
		// rates from register	
		If Not UseFixedRates And Not UseBasisDocumentRates Then
			CurrencyInfo = Catalogs.Currencies.GetCurrencyInfo(RatePeriod, 
				Parameters.Currency, 
				CurrencyMovementType.Currency,
				CurrencyMovementType.Source);
			If Not ValueIsFilled(CurrencyInfo.Rate) Then
				NewRow.Rate = 0;
				NewRow.ReverseRate = 0;
				NewRow.Multiplicity = 1;
			Else
				NewRow.Rate = CurrencyInfo.Rate;
				NewRow.ReverseRate = 1 / CurrencyInfo.Rate;
				NewRow.Multiplicity = CurrencyInfo.Multiplicity;
			EndIf;
		EndIf;
		
	EndIf;
	Return NewRow;
EndFunction

Function CurrencyRowMatchFilter(CurrencyRow, Filter)
	Return CurrencyRow.Key = Filter.Key
		And CurrencyRow.CurrencyFrom = Filter.CurrencyFrom
		And CurrencyRow.MovementType = Filter.MovementType;
EndFunction

Function GetLandedCostCurrency(Company) Export
	Return ServerReuse.GetLandedCostCurrency(Company);
EndFunction

Function _GetLandedCostCurrency(Company) Export
	If Not ValueIsFilled(Company) Then
		Return Catalogs.Currencies.EmptyRef();
	EndIf;
	
	Return Company.LandedCostCurrencyMovementType.Currency;
EndFunction

Procedure ExcludePostingDataTable(Parameters, RegMetadata) Export
	If Parameters.Property("MultiCurrencyExcludePostingDataTables") Then
		Parameters.MultiCurrencyExcludePostingDataTables.Add(RegMetadata);
	Else
		Array = New Array();
		Array.Add(RegMetadata);
		Parameters.Insert("MultiCurrencyExcludePostingDataTables", Array);
	EndIf;
EndProcedure

#Region PARTNER_BALANCE

Function GetPartnerBalanceTables()
	PartnerBalanceTables = New Structure();	
	PartnerBalanceTables.Insert("T2015S_TransactionsInfo", New ValueTable());
	PartnerBalanceTables.Insert("Table_T2014S_AdvancesInfo", New ValueTable());
		
	PartnerBalanceTables.Insert("R2020B_AdvancesFromCustomers"    , New ValueTable());
	PartnerBalanceTables.Insert("R2021B_CustomersTransactions"    , New ValueTable());
	PartnerBalanceTables.Insert("R1020B_AdvancesToVendors"        , New ValueTable());
	PartnerBalanceTables.Insert("R1021B_VendorsTransactions"      , New ValueTable());
	
	Return PartnerBalanceTables;
EndFunction

Procedure PutToPartnerBalanceTables(PartnerBalanceTables, RegMetadata, PrepareTable)
	RegName = RegMetadata.Name;
	If PartnerBalanceTables.Property(RegName) Then
		PartnerBalanceTables[RegName] = PrepareTable;
	EndIf;
EndProcedure

Procedure UpdatePartnerBalanceTables(PartnerBalanceTables)
	Filter = New Structure("CurrencyMovementType", ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency);
	
	ExcludeDimensions = New Array();
	ExcludeDimensions.Add(Lower("TransactionCurrency")); 
	ExcludeDimensions.Add(Lower("Currency")); 
	ExcludeDimensions.Add(Lower("CurrencyMovementType")); 
	ExcludeDimensions.Add(Lower("Price")); 
	
	// transactions
	For Each Row In PartnerBalanceTables.T2015S_TransactionsInfo Do
		
		PrepereTable = Undefined;
		MainTableName = "";
		
		If Row.IsCustomerTransaction Then
			PrepereTable = PartnerBalanceTables.R2021B_CustomersTransactions;
			MainTableName = "R2021B_CustomersTransactions";	
		ElsIf Row.IsVendorTransaction Then
			PrepereTable = PartnerBalanceTables.R1021B_VendorsTransactions;
			MainTableName = "R1021B_VendorsTransactions";
		Else
			Raise "Unknown transaction type in [T2015S_TransactionsInfo]";
		EndIf;
		
		If Not PrepereTable.Count() Then
			Continue
		EndIf;
		
		RegisterRows = PrepereTable.FindRows(Filter);	
		If RegisterRows.Count() = 0 Then
			Raise StrTemplate("Not forund TRANSACTION CURRENCY in [%1]", MainTableName);
		EndIf;
		
		RegMetadata = Metadata.AccumulationRegisters[MainTableName];  
		
		For Each RegisterRow In RegisterRows Do
			If ValueIsFilled(Row.Key) And RegisterRow.Key <> Row.Key Then
				Continue;
			EndIf;       
			
			DimensionsMatch = True;
			For Each RegDimension In RegMetadata.Dimensions Do 
				If ExcludeDimensions.Find(RegDimension.Name) <> Undefined Then
					Continue;
				EndIf;
				
				If Not CommonFunctionsClientServer.ObjectHasProperty(Row, RegDimension.Name) Then
					Continue;
				EndIf;
				
				If RegisterRow[RegDimension.Name] <> Row[RegDimension.Name] Then
					DimensionsMatch = False;
					Break;
				EndIf;
			EndDo;
				
			If Not DimensionsMatch Then
				Continue;
			EndIf;
			
			Row.Currency = RegisterRow.Currency;
			Row.Amount   = RegisterRow.Amount;
		EndDo;
		
	EndDo;
	
	// advances
	For Each Row In PartnerBalanceTables.Table_T2014S_AdvancesInfo Do
		
		PrepereTable = Undefined;
		MainTableName = "";
		
		If Row.IsCustomerAdvance Then
			PrepereTable = PartnerBalanceTables.R2020B_AdvancesFromCustomers;
			MainTableName = "R2020B_AdvancesFromCustomers";	
		ElsIf Row.IsVendorAdvance Then
			PrepereTable = PartnerBalanceTables.R1020B_AdvancesToVendors;
			MainTableName = "R1020B_AdvancesToVendors";
		Else
			Raise "Unknown transaction type in [Table_T2014S_AdvancesInfo]";
		EndIf;
		
		If Not PrepereTable.Count() Then
			Continue;
		EndIf;
		
		RegisterRows = PrepereTable.FindRows(Filter);	
		If RegisterRows.Count() = 0 Then
			Raise StrTemplate("Not forund TRANSACTION CURRENCY in [%1]", MainTableName);
		EndIf;
		
		RegMetadata = Metadata.AccumulationRegisters[MainTableName];
		
		For Each RegisterRow In RegisterRows Do
			If ValueIsFilled(Row.Key) And RegisterRow.Key <> Row.Key Then
				Continue;
			EndIf;        
			
			DimensionsMatch = True;
			For Each RegDimension In RegMetadata.Dimensions Do  
				If ExcludeDimensions.Find(RegDimension.Name) <> Undefined Then
					Continue;
				EndIf;
				
				If Not CommonFunctionsClientServer.ObjectHasProperty(Row, RegDimension.Name) Then
					Continue;
				EndIf;
				
				If RegisterRow[RegDimension.Name] <> Row[RegDimension.Name] Then
					DimensionsMatch = False;
					Break;
				EndIf;
			EndDo;
				
			If Not DimensionsMatch Then
				Continue;
			EndIf;
			
			Row.Currency = RegisterRow.Currency;
			Row.Amount   = RegisterRow.Amount;
		EndDo;
		
	EndDo;
EndProcedure

#EndRegion

#Region EXCHANGE_DIFFERENCE

Procedure ExchangeDifference(Parameters)
	
	IsMoneyExchange = False;
	TransitIncoming = New ValueTable();
	TransitIncoming_PrepareTable = New ValueTable();
	AccountingOperation_Revenues = Undefined;
	AccountingOperation_Expenses = Undefined;
	
	ExpenseType  = Undefined;
	LossCenter   = Undefined;
	RevenueType  = Undefined;
	ProfitCenter = Undefined;
	
	If Parameters.Metadata = Metadata.Documents.MoneyTransfer 
		And Parameters.Object.SendCurrency <> Parameters.Object.ReceiveCurrency Then
		
		IsMoneyExchange = True;
		TransitIncoming_PrepareTable = Parameters.PostingDataTables[Metadata.AccumulationRegisters.R3021B_CashInTransitIncoming].PrepareTable;
		TransitIncoming = TransitIncoming_PrepareTable;
		
		AccountingOperation_Revenues = Catalogs.AccountingOperations.MoneyTransfer_DR_R3021B_CashInTransit_CR_R5021T_Revenues;
		AccountingOperation_Expenses = Catalogs.AccountingOperations.MoneyTransfer_DR_R5022T_Expenses_CR_R3021B_CashInTransit;
		
		ExpenseType  = Parameters.Object.ExpenseType;
		LossCenter   = Parameters.Object.LossCenter;
		RevenueType  = Parameters.Object.RevenueType;
		ProfitCenter = Parameters.Object.ProfitCenter;
					
	ElsIf Parameters.Metadata = Metadata.Documents.BankReceipt
		And Parameters.Object.TransactionType = Enums.IncomingPaymentTransactionType.CurrencyExchange Then
			
		IsMoneyExchange = True;
		TransitIncoming_PrepareTable = Parameters.PostingDataTables[Metadata.AccumulationRegisters.R3021B_CashInTransitIncoming].PrepareTable;
		
		AccountingOperation_Revenues = Catalogs.AccountingOperations.BankReceipt_DR_R3021B_CashInTransit_CR_R5021T_Revenues;
		AccountingOperation_Expenses = Catalogs.AccountingOperations.BankReceipt_DR_R5022T_Expenses_CR_R3021B_CashInTransit;
		
		ExpenseType  = Parameters.Object.ExpenseType;
		LossCenter   = Parameters.Object.LossCenter;
		RevenueType  = Parameters.Object.RevenueType;
		ProfitCenter = Parameters.Object.ProfitCenter;
		
		Query = New Query();
		Query.Text = 
		"SELECT
		|	tmp.Basis
		|INTO tmp
		|FROM
		|	&TransitIncoming_Expense AS tmp
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Basis
		|INTO TransitIncoming_Expense
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Basis
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	R3021B_CashInTransitIncoming.*
		|FROM
		|	AccumulationRegister.R3021B_CashInTransitIncoming AS R3021B_CashInTransitIncoming
		|		INNER JOIN TransitIncoming_Expense AS TransitIncoming_Expense
		|		ON R3021B_CashInTransitIncoming.RecordType = VALUE(AccumulationRecordType.Receipt)
		|		AND R3021B_CashInTransitIncoming.Basis = TransitIncoming_Expense.Basis
		|		AND R3021B_CashInTransitIncoming.Recorder <> &Ref";
		
		Query.SetParameter("TransitIncoming_Expense", TransitIncoming_PrepareTable);
		Query.SetParameter("Ref", Parameters.Object.Ref);
		
		QueryResult = Query.Execute();
		QuerySelection = QueryResult.Select();
		
		TransitIncoming = TransitIncoming_PrepareTable.CopyColumns();
		
		For Each Row In TransitIncoming_PrepareTable Do
			If Row.RecordType = AccumulationRecordType.Expense Then
				FillPropertyValues(TransitIncoming.Add(), Row);
			EndIf;
		EndDo;
		
		While QuerySelection.Next() Do
			FillPropertyValues(TransitIncoming.Add(), QuerySelection);
		EndDo;
	EndIf;
		
	If Not IsMoneyExchange Then
		Return; // is not exchange
	EndIf;
	
	Expenses = Parameters.PostingDataTables[Metadata.AccumulationRegisters.R5022T_Expenses].PrepareTable;	
	Revenues = Parameters.PostingDataTables[Metadata.AccumulationRegisters.R5021T_Revenues].PrepareTable;	
	Accounting = Parameters.PostingDataTables[Metadata.AccumulationRegisters.T1040T_AccountingAmounts].PrepareTable;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT *
	|INTO TransitIncoming
	|FROM &TransitIncoming AS TransitIncoming";
	Query.SetParameter("TransitIncoming", TransitIncoming);
	Query.Execute();
	
	ReplaceAmountInTransactionCurrency(Parameters.TempTablesManager, AccumulationRecordType.Receipt, TransitIncoming);
	ReplaceAmountInTransactionCurrency(Parameters.TempTablesManager, AccumulationRecordType.Expense, TransitIncoming);
	
	Query.Text = 
	"SELECT
	|	*
	|INTO TransitIncomingReplaced
	|FROM
	|	&TransitIncoming AS TransitIncoming
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TransitIncomingExpense.RecordType AS ExpenseRecordType,
	|	TransitIncomingReceipt.RecordType AS ReceiptRecordType,
	|	TransitIncomingExpense.Period AS Period,
	|	TransitIncomingReceipt.Amount - TransitIncomingExpense.Amount AS Amount,
	|	TransitIncomingReceipt.*
	|INTO Diff
	|FROM
	|	TransitIncomingReplaced AS TransitIncomingReceipt
	|		INNER JOIN TransitIncomingReplaced AS TransitIncomingExpense
	|		ON TransitIncomingReceipt.Company = TransitIncomingExpense.Company
	|		AND TransitIncomingReceipt.Branch = TransitIncomingExpense.Branch
	|		AND TransitIncomingReceipt.Account = TransitIncomingExpense.Account
	|		AND TransitIncomingReceipt.CurrencyMovementType = TransitIncomingExpense.CurrencyMovementType
	|		AND TransitIncomingReceipt.Currency = TransitIncomingExpense.Currency
	|		AND TransitIncomingReceipt.TransactionCurrency = TransitIncomingExpense.TransactionCurrency
	|		AND TransitIncomingReceipt.Basis = TransitIncomingExpense.Basis
	|
	|		AND (TransitIncomingReceipt.RecordType = VALUE(AccumulationRecordType.Receipt))
	|		AND (TransitIncomingExpense.RecordType = VALUE(AccumulationRecordType.Expense))
	|
	|		AND (NOT TransitIncomingReceipt.Period IS NULL)
	|		AND (NOT TransitIncomingExpense.Period IS NULL)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	CASE
	|		WHEN Diff.Amount < 0
	|			THEN Diff.ReceiptRecordType
	|		ELSE Diff.ExpenseRecordType
	|	END AS RecordType,
	|	CASE
	|		WHEN Diff.Amount < 0
	|			THEN -Diff.Amount
	|		ELSE Diff.Amount
	|	END AS Amount,
	|	Diff.*
	|FROM
	|	Diff AS Diff";
		
	Query.SetParameter("TransitIncoming", TransitIncoming);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	For Each Row In QueryTable Do
		If Not ValueIsFilled(Row.Amount) Then
			Continue; // not currency difference
		EndIf;
		
		FillPropertyValues(TransitIncoming_PrepareTable.Add(), Row);
		
		If Row.RecordType = AccumulationRecordType.Receipt Then
			
			If ValueIsFilled(AccountingOperation_Revenues) Then
				Accounting_NewRow = Accounting.Add();
				FillPropertyValues(Accounting_NewRow, Row);
				Accounting_NewRow.Operation = AccountingOperation_Revenues;
			EndIf;
			
			Revenues_NewRow = Revenues.Add();
			FillPropertyValues(Revenues_NewRow, Row);
			Revenues_NewRow.RevenueType = RevenueType;
			Revenues_NewRow.ProfitLossCenter = ProfitCenter;
			
		ElsIf Row.RecordType = AccumulationRecordType.Expense Then 
			
			If ValueIsFilled(AccountingOperation_Expenses) Then
				Accounting_NewRow = Accounting.Add();
				FillPropertyValues(Accounting_NewRow, Row);
				Accounting_NewRow.Operation = AccountingOperation_Expenses;
			EndIf;
			
			Expenses_NewRow = Expenses.Add();
			FillPropertyValues(Expenses_NewRow, Row);
			Expenses_NewRow.ExpenseType = ExpenseType;
			Expenses_NewRow.ProfitLossCenter = LossCenter;
			
		EndIf;
	EndDo;
	
EndProcedure

Procedure ReplaceAmountInTransactionCurrency(TempTablesManager, RecordType, TransitIncoming)
	Query = New Query();
	Query.TempTablesManager = TempTablesManager;
	Query.Text = 
	"SELECT *
	|FROM TransitIncoming AS TransitIncoming
	|WHERE
	|	TransitIncoming.RecordType = &RecordType
	|	AND (TransitIncoming.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|		OR TransitIncoming.TransactionCurrency = TransitIncoming.Currency)";
	Query.SetParameter("RecordType", RecordType);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	TransactionCurrencyType = ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency;
	
	For Each Row In QueryTable Do
		If Row.CurrencyMovementType <> TransactionCurrencyType Then
			Filter = New Structure();
			Filter.Insert("CurrencyMovementType", TransactionCurrencyType);
			Filter.Insert("RecordType", RecordType);
			TransitIncomingRows = TransitIncoming.FindRows(Filter);
			If TransitIncomingRows.Count() <> 1 Then
				Raise StrTemplate("Found [%1] rows in transit incoming", TransitIncomingRows.Count());
			EndIf;
			
			TransitIncomingRows[0].Amount = Row.Amount;
			
			Break;
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region DEBIT_CREDIT_NOTE_DIFFERENCE

Procedure DebitCreditNoteDifference(Parameters)

	If Not (Parameters.Metadata = Metadata.Documents.DebitCreditNote 
		And Parameters.Object.SendCurrency <> Parameters.Object.ReceiveCurrency) Then
		Return;
	EndIf;
	
	TotalReceipt = 0;
	TotalExpense = 0;
	LegalCurrency = Undefined;
	BalanceType   = Undefined;
	
	// Send (expenses)
	If Parameters.Object.SendDebtType = Enums.DebtTypes.TransactionCustomer Then
		
		Table = Parameters.PostingDataTables[Metadata.AccumulationRegisters.R2021B_CustomersTransactions].PrepareTable;
		Result = GetAmountByRecordType(Table, "CustomersAdvancesClosing", AccumulationRecordType.Expense);
		TotalExpense  = Result.TotalAmount;
	
	ElsIf Parameters.Object.SendDebtType = Enums.DebtTypes.AdvanceCustomer Then
		
		Table = Parameters.PostingDataTables[Metadata.AccumulationRegisters.R2020B_AdvancesFromCustomers].PrepareTable;
		Result = GetAmountByRecordType(Table, "CustomersAdvancesClosing", AccumulationRecordType.Expense);
		TotalExpense  = Result.TotalAmount;
		
	ElsIf Parameters.Object.SendDebtType = Enums.DebtTypes.TransactionVendor Then
		
		Table = Parameters.PostingDataTables[Metadata.AccumulationRegisters.R1021B_VendorsTransactions].PrepareTable;
		Result = GetAmountByRecordType(Table, "VendorsAdvancesClosing", AccumulationRecordType.Expense);
		TotalExpense  = Result.TotalAmount;
		
	ElsIf Parameters.Object.SendDebtType = Enums.DebtTypes.AdvanceVendor Then
		
		Table = Parameters.PostingDataTables[Metadata.AccumulationRegisters.R1020B_AdvancesToVendors].PrepareTable;
		Result = GetAmountByRecordType(Table, "VendorsAdvancesClosing", AccumulationRecordType.Expense);
		TotalExpense  = Result.TotalAmount;
	
	EndIf;
				
	// Receive (receipt)
	If Parameters.Object.ReceiveDebtType = Enums.DebtTypes.TransactionCustomer Then
		
		Table = Parameters.PostingDataTables[Metadata.AccumulationRegisters.R2021B_CustomersTransactions].PrepareTable;
		Result = GetAmountByRecordType(Table, "CustomersAdvancesClosing", AccumulationRecordType.Receipt);
		BalanceType   = "active";
		TotalReceipt  = Result.TotalAmount;
		LegalCurrency = Result.LegalCurrency;
		
	ElsIf Parameters.Object.ReceiveDebtType = Enums.DebtTypes.AdvanceCustomer Then
		
		Table = Parameters.PostingDataTables[Metadata.AccumulationRegisters.R2020B_AdvancesFromCustomers].PrepareTable;
		Result = GetAmountByRecordType(Table, "CustomersAdvancesClosing", AccumulationRecordType.Receipt);
		BalanceType   = "passive";
		TotalReceipt  = Result.TotalAmount;
		LegalCurrency = Result.LegalCurrency;
		
	ElsIf Parameters.Object.ReceiveDebtType = Enums.DebtTypes.TransactionVendor Then
		
		Table = Parameters.PostingDataTables[Metadata.AccumulationRegisters.R1021B_VendorsTransactions].PrepareTable;
		Result = GetAmountByRecordType(Table, "VendorsAdvancesClosing", AccumulationRecordType.Receipt);
		BalanceType   = "active";
		TotalReceipt  = Result.TotalAmount;
		LegalCurrency = Result.LegalCurrency;
		
	ElsIf Parameters.Object.ReceiveDebtType = Enums.DebtTypes.AdvanceVendor Then
		
		Table = Parameters.PostingDataTables[Metadata.AccumulationRegisters.R1020B_AdvancesToVendors].PrepareTable;
		Result = GetAmountByRecordType(Table, "VendorsAdvancesClosing", AccumulationRecordType.Receipt);
		BalanceType   = "passive";
		TotalReceipt  = Result.TotalAmount;
		LegalCurrency = Result.LegalCurrency;
		
	EndIf;
		
	If TotalExpense = TotalReceipt Then
		Return;
	EndIf;
	
	DataInfo = New Structure();
	DataInfo.Insert("RecordPeriod"    , Parameters.Object.Date);
	DataInfo.Insert("ReceiveCurrency" , Parameters.Object.ReceiveCurrency); 
	DataInfo.Insert("DocRef"          , Parameters.Object.Ref);
	DataInfo.Insert("ExpenseType"     , Parameters.Object.ExpenseType);
	DataInfo.Insert("LossCenter"      , Parameters.Object.LossCenter);
	DataInfo.Insert("RevenueType"     , Parameters.Object.RevenueType);
	DataInfo.Insert("ProfitCenter"    , Parameters.Object.ProfitCenter);
	DataInfo.Insert("TransitUUID"     , Parameters.Object.TransitUUID);
	DataInfo.Insert("Company"         , Parameters.Object.Company);
	DataInfo.Insert("Branch"          , Parameters.Object.Branch);
	DataInfo.Insert("Project"         , Parameters.Object.ReceiveProject);
	DataInfo.Insert("LegalCurrency"   , LegalCurrency);
	DataInfo.Insert("CurrenciesTable" , Parameters.Object.Currencies.Unload().Copy(New Structure("Key", DataInfo.TransitUUID)));
	
	Expenses    = Parameters.PostingDataTables[Metadata.AccumulationRegisters.R5022T_Expenses].PrepareTable;	
	Revenues   = Parameters.PostingDataTables[Metadata.AccumulationRegisters.R5021T_Revenues].PrepareTable;	
	Accounting = Parameters.PostingDataTables[Metadata.AccumulationRegisters.T1040T_AccountingAmounts].PrepareTable;
		
	Accounting_ClearCopy = Accounting.CopyColumns("Period, Operation, Currency, DrCurrency, CrCurrency, Amount, Key");
	
	Revenues_ClearCopy = Revenues.CopyColumns("Period, Company, Branch, ProfitLossCenter, RevenueType, Currency, Project, Amount");
	Revenues_ClearCopy.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	
	Expenses_ClearCopy = Expenses.CopyColumns("Period, Company, Branch, ProfitLossCenter, ExpenseType, Currency, Project, Amount");
	Expenses_ClearCopy.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
				
	If BalanceType = "active" Then
		// is revenue
		If TotalExpense < TotalReceipt Then
			
			Revenue_Amount = TotalReceipt - TotalExpense;
			
			AddRecord_Revenue_Accounting(DataInfo, Accounting_ClearCopy, Revenue_Amount);
			AddRecord_Revenue(DataInfo, Revenues_ClearCopy, Revenue_Amount);
					
		// is Expense
		ElsIf TotalExpense > TotalReceipt Then
			
			Expense_Amount = TotalExpense - TotalReceipt;
			
			AddRecord_Expense_Accounting(DataInfo, Accounting_ClearCopy, Expense_Amount);
			AddRecord_Expense(DataInfo, Expenses_ClearCopy, Expense_Amount);
			
		EndIf;
	EndIf;
	
	If BalanceType = "passive" Then
		// is Expense
		If TotalExpense < TotalReceipt Then
			
			Expense_Amount = TotalReceipt - TotalExpense;
			
			AddRecord_Expense_Accounting(DataInfo, Accounting_ClearCopy, Expense_Amount);
			AddRecord_Expense(DataInfo, Expenses_ClearCopy, Expense_Amount);
					
		// is Revenue
		ElsIf TotalExpense > TotalReceipt Then
			
			Revenue_Amount = TotalExpense - TotalReceipt;
			
			AddRecord_Revenue_Accounting(DataInfo, Accounting_ClearCopy, Revenue_Amount);
			AddRecord_Revenue(DataInfo, Revenues_ClearCopy, Revenue_Amount);
			
		EndIf;
	EndIf;
	
	PostingDataTables = New Map();
	
	RecordSet_AccountingAmounts = AccumulationRegisters.T1040T_AccountingAmounts.CreateRecordSet();
	Settings_AccountingAmounts = PostingServer.PostingTableSettings(Accounting_ClearCopy, RecordSet_AccountingAmounts);
	PostingDataTables.Insert(RecordSet_AccountingAmounts.Metadata(), Settings_AccountingAmounts);
	
	RecordSet_Expenses = AccumulationRegisters.R5022T_Expenses.CreateRecordSet();
	Settings_Expenses = PostingServer.PostingTableSettings(Expenses_ClearCopy, RecordSet_Expenses);
	PostingDataTables.Insert(RecordSet_Expenses.Metadata(), Settings_Expenses);
	
	RecordSet_Revenues = AccumulationRegisters.R5021T_Revenues.CreateRecordSet();
	Settings_Revenues = PostingServer.PostingTableSettings(Revenues_ClearCopy, RecordSet_Revenues);
	PostingDataTables.Insert(RecordSet_Revenues.Metadata(), Settings_Revenues);
	
	CurrenciesParameters = New Structure("IsDebitCreditNoteDifference", True);

	ArrayOfPostingInfo = New Array();
	For Each DataTable In PostingDataTables Do
		ArrayOfPostingInfo.Add(DataTable);
	EndDo;
	CurrenciesParameters.Insert("Object"   , DataInfo.DocRef);
	CurrenciesParameters.Insert("Metadata" , DataInfo.DocRef.Metadata());
	CurrenciesParameters.Insert("ArrayOfPostingInfo", ArrayOfPostingInfo);

	PreparePostingDataTables(CurrenciesParameters, DataInfo.CurrenciesTable);
	
	For Each ItemOfPostingInfo In ArrayOfPostingInfo Do
		If ItemOfPostingInfo.Key = Metadata.AccumulationRegisters.T1040T_AccountingAmounts Then
			For Each RowPostingInfo In ItemOfPostingInfo.Value.PrepareTable Do
				FillPropertyValues(Accounting.Add(), RowPostingInfo);
			EndDo;
		EndIf;
		
		If ItemOfPostingInfo.Key = Metadata.AccumulationRegisters.R5022T_Expenses Then
			For Each RowPostingInfo In ItemOfPostingInfo.Value.PrepareTable Do
				FillPropertyValues(Expenses.Add(), RowPostingInfo);
			EndDo;
		EndIf;
		
		If ItemOfPostingInfo.Key = Metadata.AccumulationRegisters.R5021T_Revenues Then
			For Each RowPostingInfo In ItemOfPostingInfo.Value.PrepareTable Do
				FillPropertyValues(Revenues.Add(), RowPostingInfo);
			EndDo;
		EndIf;

	EndDo;
EndProcedure

Function GetAmountByRecordType(Table, IgnoreColumnName, RecordType)
	Result = New Structure("LegalCurrency, TotalAmount", Undefined, 0);
	
	For Each Row In Table Do
		If ValueIsFilled(Row[IgnoreColumnName]) Then
			Continue;
		EndIf;
		
		If Row.CurrencyMovementType.Type <> Enums.CurrencyType.Legal Then
			Continue;
		EndIf;
		
		Result.LegalCurrency = Row.Currency;
		
		If Row.RecordType = RecordType Then
			Result.TotalAmount = Result.TotalAmount + Row.Amount;
		EndIf;
	EndDo;
	
	Return Result;
EndFunction

Procedure AddRecord_Revenue(DataInfo, Revenues_ClearCopy, Amount)
	NewRow = Revenues_ClearCopy.Add();
	NewRow.Period           = DataInfo.RecordPeriod;
	NewRow.Company          = DataInfo.Company;
	NewRow.Branch           = DataInfo.Branch;
	NewRow.ProfitLossCenter = DataInfo.ProfitCenter;
	NewRow.RevenueType      = DataInfo.RevenueType;
	NewRow.Currency         = DataInfo.LegalCurrency;
	NewRow.Project          = DataInfo.Project;
	NewRow.Amount           = Amount;
	NewRow.Key              = DataInfo.TransitUUID;
EndProcedure	

Procedure AddRecord_Expense(DataInfo, Expenses_ClearCopy, Amount)
	NewRow = Expenses_ClearCopy.Add();
	NewRow.Period           = DataInfo.RecordPeriod;
	NewRow.Company          = DataInfo.Company;
	NewRow.Branch           = DataInfo.Branch;
	NewRow.ProfitLossCenter = DataInfo.LossCenter;
	NewRow.ExpenseType      = DataInfo.ExpenseType;
	NewRow.Currency         = DataInfo.LegalCurrency;
	NewRow.Project          = DataInfo.Project;
	NewRow.Amount           = Amount;
	NewRow.Key              = DataInfo.TransitUUID;
EndProcedure

Procedure AddRecord_Revenue_Accounting(DataInfo, Accounting_ClearCopy, Amount)
	NewRow = Accounting_ClearCopy.Add();
	NewRow.Period     = DataInfo.RecordPeriod;
	NewRow.Currency   = DataInfo.LegalCurrency;
	NewRow.Key        = DataInfo.TransitUUID;
	NewRow.Operation  = Catalogs.AccountingOperations.DebitCreditNote_DR_R5020B_PartnersBalance_CR_R5021_Revenues;
	NewRow.DrCurrency = DataInfo.ReceiveCurrency;
	NewRow.CrCurrency = DataInfo.LegalCurrency;
	NewRow.Amount     = Amount;
EndProcedure

Procedure AddRecord_Expense_Accounting(DataInfo, Accounting_ClearCopy, Amount)
	NewRow = Accounting_ClearCopy.Add();
	NewRow.Period     = DataInfo.RecordPeriod;
	NewRow.Currency   = DataInfo.LegalCurrency;
	NewRow.Key        = DataInfo.TransitUUID;
	NewRow.Operation  = Catalogs.AccountingOperations.DebitCreditNote_DR_R5022T_Expenses_CR_R5020B_PartnersBalance;
	NewRow.DrCurrency = DataInfo.LegalCurrency;
	NewRow.CrCurrency = DataInfo.ReceiveCurrency;
	NewRow.Amount     = Amount;
EndProcedure

#EndRegion

#Region CURRENCY_REVALUATION

Function CreateExpenseRevenueInfo(Params) Export

	AccRegMetadata = Metadata.AccumulationRegisters.R5022T_Expenses;
	ExpensesTable = New ValueTable();
	ExpensesTable.Columns.Add("Period"               , AccRegMetadata.StandardAttributes.Period.Type);
	ExpensesTable.Columns.Add("Company"              , AccRegMetadata.Dimensions.Company.Type);
	ExpensesTable.Columns.Add("Branch"               , AccRegMetadata.Dimensions.Branch.Type);
	ExpensesTable.Columns.Add("ProfitLossCenter"     , AccRegMetadata.Dimensions.ProfitLossCenter.Type);
	ExpensesTable.Columns.Add("ExpenseType"          , AccRegMetadata.Dimensions.ExpenseType.Type);
	ExpensesTable.Columns.Add("Currency"             , AccRegMetadata.Dimensions.Currency.Type);
	ExpensesTable.Columns.Add("AdditionalAnalytic"   , AccRegMetadata.Dimensions.AdditionalAnalytic.Type);
	ExpensesTable.Columns.Add("CurrencyMovementType" , AccRegMetadata.Dimensions.CurrencyMovementType.Type);
	ExpensesTable.Columns.Add("Amount"               , AccRegMetadata.Resources.Amount.Type);

	AccRegMetadata = Metadata.AccumulationRegisters.R5021T_Revenues;
	RevenuesTable = New ValueTable();
	RevenuesTable.Columns.Add("Period"               , AccRegMetadata.StandardAttributes.Period.Type);
	RevenuesTable.Columns.Add("Company"              , AccRegMetadata.Dimensions.Company.Type);
	RevenuesTable.Columns.Add("Branch"               , AccRegMetadata.Dimensions.Branch.Type);
	RevenuesTable.Columns.Add("ProfitLossCenter"     , AccRegMetadata.Dimensions.ProfitLossCenter.Type);
	RevenuesTable.Columns.Add("RevenueType"          , AccRegMetadata.Dimensions.RevenueType.Type);
	RevenuesTable.Columns.Add("Currency"             , AccRegMetadata.Dimensions.Currency.Type);
	RevenuesTable.Columns.Add("AdditionalAnalytic"   , AccRegMetadata.Dimensions.AdditionalAnalytic.Type);
	RevenuesTable.Columns.Add("CurrencyMovementType" , AccRegMetadata.Dimensions.CurrencyMovementType.Type);
	RevenuesTable.Columns.Add("Amount"               , AccRegMetadata.Resources.Amount.Type);

	ExpenseRevenueInfo = New Structure();
	ExpenseRevenueInfo.Insert("DocumentDate", Params.DocumentDate);

	ExpenseRevenueInfo.Insert("RevenuesTable"              , RevenuesTable);
	ExpenseRevenueInfo.Insert("Revenue_ProfitLossCenter"   , Params.Revenue_ProfitLossCenter);
	ExpenseRevenueInfo.Insert("Revenue_AdditionalAnalytic" , Params.Revenue_AdditionalAnalytic);
	ExpenseRevenueInfo.Insert("RevenueType"                , Params.RevenueType);

	ExpenseRevenueInfo.Insert("ExpensesTable"              , ExpensesTable);
	ExpenseRevenueInfo.Insert("Expense_ProfitLossCenter"   , Params.Expense_ProfitLossCenter);
	ExpenseRevenueInfo.Insert("Expense_AdditionalAnalytic" , Params.Expense_AdditionalAnalytic);
	ExpenseRevenueInfo.Insert("ExpenseType"                , Params.ExpenseType);

	Return ExpenseRevenueInfo;
EndFunction

Procedure RevaluateCurrency(_TempTablesManager, ArrayOfRegisterNames, CurrencyRates, RegisterType, ExpenseRevenueInfo) Export
	_TransactionCurrency = ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency;
	
	For Each RegisterName In ArrayOfRegisterNames Do
		QueryTable = _TempTablesManager.Tables.Find("_" + RegisterName).GetData().Unload();
		
		DimensionsInfo = CreateDimensionsTableAndFilter(RegisterName);
		
		QueryTableCopy = QueryTable.Copy();
		QueryTableCopy.GroupBy(StrConcat(DimensionsInfo.DimensionsArray, ","));
		
		ArrayOfDataForRevaluate = New Array();
		
		For Each Row In QueryTableCopy Do
			FillPropertyValues(DimensionsInfo.DimensionsFilter, Row);
			Rows = QueryTable.FindRows(DimensionsInfo.DimensionsFilter);
			
			_CurrentBalanceByTransactionCurrency = 0;
			For Each Row2 In Rows Do
				If Row2.CurrencyMovementType = _TransactionCurrency Then
					_CurrentBalanceByTransactionCurrency = Row2.Amount;
					Break;
				EndIf;
			EndDo;
			
			DataForRevaluate = New Structure();
			DataForRevaluate.Insert("CurrentBalanceByTransactionCurrency", _CurrentBalanceByTransactionCurrency);
			DataForRevaluate.Insert("RowsForRevaluate", New Array());
			
			For Each Row3 In Rows Do
				If Row3.CurrencyMovementType <> _TransactionCurrency Then
					DataForRevaluate.RowsForRevaluate.Add(Row3);
				EndIf;
			EndDo;
			
			ArrayOfDataForRevaluate.Add(DataForRevaluate);		
		EndDo;
		
		For Each ItemOfDataForRevaluate In ArrayOfDataForRevaluate Do
			For Each OtherCurrencyRow In ItemOfDataForRevaluate.RowsForRevaluate Do

				CurrencyRatesFilter = New Structure;
				CurrencyRatesFilter.Insert("CurrencyFrom" , OtherCurrencyRow.TransactionCurrency);
				CurrencyRatesFilter.Insert("CurrencyTo"   , OtherCurrencyRow.Currency);
				CurrencyRatesFilter.Insert("Source"       , OtherCurrencyRow.Source);

				CurrencyInfo = CurrencyRates.FindRows(CurrencyRatesFilter);
				If CurrencyInfo.Count() > 1 Then
					Raise "CurrencyInfo.Count() > 1"; // some thing is wrong
				EndIf;

				If Not CurrencyInfo.Count() Then
					Continue; // currency rate not set
				EndIf;

				If Not ValueIsFilled(CurrencyInfo[0].Rate) Or Not ValueIsFilled(CurrencyInfo[0].Multiplicity) Then
					Continue;
				EndIf;

				CurrentAmountValue = OtherCurrencyRow.Amount;
				RevaluatedAmountValue = (ItemOfDataForRevaluate.CurrentBalanceByTransactionCurrency 
					* CurrencyInfo[0].Rate) / CurrencyInfo[0].Multiplicity;
				RevaluatedAmountValue = Round(RevaluatedAmountValue, 2);
				
				_IsExpense = False;
				_IsRevenue = False;
				
				If CurrentAmountValue > RevaluatedAmountValue Then
					AmountDifference = CurrentAmountValue - RevaluatedAmountValue;
					_RecordType = AccumulationRecordType.Expense;
					
					If RegisterType = "Active" Then
						_IsExpense = True;
					EndIf;
					
					If RegisterType = "Passive" Then
						_IsRevenue = True;
					EndIf;
					
				Else
					AmountDifference = RevaluatedAmountValue - CurrentAmountValue;
					_RecordType = AccumulationRecordType.Receipt;
					
					If RegisterType = "Active" Then
						_IsRevenue = True;
					EndIf;
					
					If RegisterType = "Passive" Then
						_IsExpense = True;
					EndIf;
					
				EndIf;
				
				If Not ValueIsFilled(AmountDifference) Then
					Continue;
				EndIf;
														
				NewRow = DimensionsInfo.DimensionsTable.Add();
				FillPropertyValues(NewRow, OtherCurrencyRow);
				NewRow.RecordType = _RecordType;
				NewRow.Period = ExpenseRevenueInfo.DocumentDate;
				NewRow.Key = String(New UUID());
				NewRow.AmountRevaluated = AmountDifference;

				If _IsRevenue Then
					NewRevenue = ExpenseRevenueInfo.RevenuesTable.Add();
					FillPropertyValues(NewRevenue, NewRow);
					NewRevenue.Period = ExpenseRevenueInfo.DocumentDate;
					NewRevenue.ProfitLossCenter    = ExpenseRevenueInfo.Revenue_ProfitLossCenter;
					NewRevenue.RevenueType         = ExpenseRevenueInfo.RevenueType;
					NewRevenue.AdditionalAnalytic  = ExpenseRevenueInfo.Revenue_AdditionalAnalytic;
					NewRevenue.Amount = AmountDifference;
				EndIf;

				If _IsExpense Then
					NewExpense = ExpenseRevenueInfo.ExpensesTable.Add();
					FillPropertyValues(NewExpense, NewRow);
					NewExpense.Period = ExpenseRevenueInfo.DocumentDate;
					NewExpense.ProfitLossCenter    = ExpenseRevenueInfo.Expense_ProfitLossCenter;
					NewExpense.ExpenseType         = ExpenseRevenueInfo.ExpenseType;
					NewExpense.AdditionalAnalytic  = ExpenseRevenueInfo.Expense_AdditionalAnalytic;
					NewExpense.Amount = AmountDifference;
				EndIf;
			EndDo;
		EndDo;
		
		DeleteEmptyAmounts(DimensionsInfo.DimensionsTable, "AmountRevaluated");
		
		If DimensionsInfo.DimensionsTable.Count() Then
			Query = New Query;
			Query.TempTablesManager = _TempTablesManager;
			Query.Text = StrTemplate(
				"SELECT *, DimensionsTable.AmountRevaluated AS Amount INTO %1 FROM &DimensionsTable AS DimensionsTable",
				"Revaluated_" + RegisterName);
			Query.SetParameter("DimensionsTable", DimensionsInfo.DimensionsTable);
			Query.Execute();
		EndIf;
	EndDo; // ArrayOfRegisterNames
EndProcedure

Procedure CreateVirtualTables(Parameters, ArrayOfRegisterNames) Export
	Query = New Query;
	Query.TempTablesManager = Parameters.TempTablesManager;

	For Each RegisterName In ArrayOfRegisterNames Do
		DimensionsInfo = CreateDimensionsTableAndFilter(RegisterName);
		If Parameters.TempTablesManager.Tables.Find("Revaluated_" + RegisterName) = Undefined Then
			Query.Text = Query.Text + StrTemplate("SELECT * INTO %1 FROM &DimensionsTable AS DimensionsTable; ",
				"Revaluated_" + RegisterName);
			Query.SetParameter("DimensionsTable", DimensionsInfo.DimensionsTable);
		EndIf;
	EndDo;
	If ValueIsFilled(Query.Text) Then
		Query.Execute();
	EndIf;
EndProcedure

Procedure DeleteEmptyAmounts(Table, ColumnName) Export
	ArrayForDelete = New Array();
	For Each Row In Table Do
		If Row[ColumnName] = 0 Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
		
	For Each ItemOfArray In ArrayForDelete Do
		Table.Delete(ItemOfArray);
	EndDo;
EndProcedure

Function CreateDimensionsTableAndFilter(RegisterName)
	_RegisterName = GetMetadataReisterName(RegisterName);
	
	DimensionsFilter = New Structure();
	DimensionsTable = New ValueTable();
	DimensionsArray = New Array();
	
	For Each Dimension In Metadata.AccumulationRegisters[_RegisterName].Dimensions Do
		DimensionsTable.Columns.Add(Dimension.Name, Dimension.Type);
		If Upper(Dimension.Name) = Upper("CurrencyMovementType") Or Upper(Dimension.Name) = Upper("Currency") Then
			Continue;
		EndIf;
		DimensionsFilter.Insert(Dimension.Name);
		DimensionsArray.Add(Dimension.Name);
	EndDo;
	DimensionsTable.Columns.Add("AmountRevaluated", Metadata.DefinedTypes.typeAmount.Type);
	DimensionsTable.Columns.Add("RecordType"      , Metadata.AccumulationRegisters[_RegisterName].StandardAttributes.RecordType.Type);
	DimensionsTable.Columns.Add("Period"          , Metadata.AccumulationRegisters[_RegisterName].StandardAttributes.Period.Type);
	DimensionsTable.Columns.Add("Key"      , Metadata.DefinedTypes.typeRowID.Type);
	
	Result = New Structure;
	Result.Insert("DimensionsTable", DimensionsTable);
	Result.Insert("DimensionsFilter", DimensionsFilter);
	Result.Insert("DimensionsArray", DimensionsArray);
	
	Return Result;
EndFunction

Function GetMetadataReisterName(RegisterName)
	If StrStartsWith(RegisterName, "R5020B_PartnersBalance") Then
		Return "R5020B_PartnersBalance";	
	Else
		Return RegisterName;
	EndIf;
EndFunction

#EndRegion

#Region LOCAL_TOTAL_AMOUNTS

Function GetLocalTotalAmounts(Object, Parameters, AmountsInfo) Export
	
	Result = New Structure("LocalTotalAmount, LocalNetAmount, LocalTaxAmount, LocalRate", 0, 0, 0, 0);
	
	EmptyCurrenciesTable = GetEmptyCurrenciesTable(Parameters.Ref.Metadata());
	
	RatePeriod = CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(Parameters.Ref, Parameters.Date);
	
	ArrayOfFixedRates = New Array;
	For Each Row In Parameters.Currencies Do
		If Row.IsFixed Then
			FixedRates = New Structure("Key, CurrencyFrom, MovementType, Rate, ReverseRate, Multiplicity");
			FillPropertyValues(FixedRates, Row);
			ArrayOfFixedRates.Add(FixedRates);
		EndIf;
	EndDo;
	
	// Legal currency
	For Each ItemOfArray In Catalogs.Companies.GetLegalCurrencies(Parameters.Company) Do
		AddRowToCurrencyTable(Parameters, RatePeriod, EmptyCurrenciesTable, ItemOfArray.CurrencyMovementType, ArrayOfFixedRates);
	EndDo;
	
	If Not EmptyCurrenciesTable.Count() Then
		Return Result;
	EndIf;
	
	// Local rate
	Result.LocalRate = EmptyCurrenciesTable[0].Rate;
	
	// Total amount
	If ValueIsFilled(AmountsInfo.TotalAmount.Value) Then
		CurrenciesClientServer.CalculateAmount(EmptyCurrenciesTable, AmountsInfo.TotalAmount.Value);
		Result.LocalTotalAmount = EmptyCurrenciesTable[0].Amount;
	EndIf;
	
	// Net amount
	If ValueIsFilled(AmountsInfo.NetAmount.Value) Then
		CurrenciesClientServer.CalculateAmount(EmptyCurrenciesTable, AmountsInfo.NetAmount.Value);
		Result.LocalNetAmount = EmptyCurrenciesTable[0].Amount;
	EndIf;
	
	// Tax amount
	If ValueIsFilled(AmountsInfo.TaxAmount.Value) Then
		CurrenciesClientServer.CalculateAmount(EmptyCurrenciesTable, AmountsInfo.TaxAmount.Value);
		Result.LocalTaxAmount = EmptyCurrenciesTable[0].Amount;
	EndIf;
	
	Return Result;	
EndFunction

Procedure UpdateLocalTotalAmounts(Object, TotalAmounts, AmountsInfo) Export
	If TotalAmounts.LocalTotalAmount <> AmountsInfo.TotalAmount.Name 
		And CommonFunctionsClientServer.ObjectHasProperty(Object, AmountsInfo.TotalAmount.Name) Then
		Object[AmountsInfo.TotalAmount.Name] = TotalAmounts.LocalTotalAmount;
	EndIf;
	
	If TotalAmounts.LocalNetAmount <> AmountsInfo.NetAmount.Name 
		And CommonFunctionsClientServer.ObjectHasProperty(Object, AmountsInfo.NetAmount.Name) Then
		Object[AmountsInfo.NetAmount.Name] = TotalAmounts.LocalNetAmount;
	EndIf;
	
	If TotalAmounts.LocalTaxAmount <> AmountsInfo.TaxAmount.Name 
		And CommonFunctionsClientServer.ObjectHasProperty(Object, AmountsInfo.TaxAmount.Name) Then
		Object[AmountsInfo.TaxAmount.Name] = TotalAmounts.LocalTaxAmount;
	EndIf;
	
	If TotalAmounts.LocalRate <> AmountsInfo.LocalRate.Name 
		And CommonFunctionsClientServer.ObjectHasProperty(Object, AmountsInfo.LocalRate.Name) Then
		Object[AmountsInfo.LocalRate.Name] = TotalAmounts.LocalRate;
	EndIf;
EndProcedure

#EndRegion
