Procedure PreparePostingDataTables(Parameters, CurrencyTable, AddInfo = Undefined) Export
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

	If ArrayOfPostingInfo.Count() And (Parameters.Metadata.TabularSections.Find("Currencies") <> Undefined Or CurrencyTable <> Undefined) Then
		TempTableManager = New TempTablesManager();
		Query = New Query();
		Query.TempTablesManager = TempTableManager;
		Query.Text =
		"SELECT
		|	*
		|INTO CurrencyTable
		|FROM
		|	&CurrencyTable AS CurrencyTable";
		If CurrencyTable = Undefined Then
			CurrencyTable = Parameters.Object.Currencies.Unload();
			DocumentCondition = False;

			// Partner, Agreement, LegalName, Key, BasisDocument
			_PaymentList = New ValueTable();
			_PaymentList.Columns.Add("Partner");
			_PaymentList.Columns.Add("Agreement");
			_PaymentList.Columns.Add("LegalName");
			_PaymentList.Columns.Add("Key");
			_PaymentList.Columns.Add("BasisDocument");
			
			If Parameters.Metadata = Metadata.Documents.CashReceipt Or Parameters.Metadata = Metadata.Documents.BankReceipt Then
				DocumentCondition = True;
				RegisterType = Metadata.AccumulationRegisters.R2021B_CustomersTransactions;
				For Each RowPaymentList In Parameters.Object.PaymentList Do
					NewRowPaymentList = _PaymentList.Add();
					FillPropertyValues(NewRowPaymentList, RowPaymentList);
					NewRowPaymentList.LegalName = RowPaymentList.Payer;
				EndDo;
			EndIf;
			If Parameters.Metadata = Metadata.Documents.CashPayment Or Parameters.Metadata = Metadata.Documents.BankPayment Then
				DocumentCondition = True;
				RegisterType = Metadata.AccumulationRegisters.R1021B_VendorsTransactions;
				For Each RowPaymentList In Parameters.Object.PaymentList Do
					NewRowPaymentList = _PaymentList.Add();
					FillPropertyValues(NewRowPaymentList, RowPaymentList);
					NewRowPaymentList.LegalName = RowPaymentList.Payee;
				EndDo;
			EndIf;
			If Parameters.Metadata = Metadata.Documents.EmployeeCashAdvance Then
				DocumentCondition = True;
				RegisterType = Metadata.AccumulationRegisters.R1021B_VendorsTransactions;
				For Each RowPaymentList In Parameters.Object.PaymentList Do
					If Not ValueIsFilled(RowPaymentList.Invoice) Then
						Continue;
					EndIf;
					NewRowPaymentList = _PaymentList.Add();
					NewRowPaymentList.Partner   = RowPaymentList.Invoice.Partner;
					NewRowPaymentList.Agreement = RowPaymentList.Invoice.Agreement;
					NewRowPaymentList.LegalName = RowPaymentList.Invoice.LegalName;
					NewRowPaymentList.Key       = RowPaymentList.Key;
					If RowPaymentList.Invoice.Agreement.ApArPostingDetail = Enums.ApArPostingDetail.ByDocuments Then
						NewRowPaymentList.BasisDocument = RowPaymentList.Invoice;
					Else
						NewRowPaymentList.BasisDocument = Undefined;
					EndIf;	
				EndDo;
			EndIf;
			If DocumentCondition Then
				TableOfAgreementMovementTypes = New ValueTable();
				TableOfAgreementMovementTypes.Columns.Add("MovementType");
				TableOfAgreementMovementTypes.Columns.Add("Partner");
				TableOfAgreementMovementTypes.Columns.Add("LegalName");
				TableOfAgreementMovementTypes.Columns.Add("Amount");
				TableOfAgreementMovementTypes.Columns.Add("Key");
				For Each ItemOfPostingInfoRow In ArrayOfPostingInfo Do
					ItemOfPostingInfo = ItemOfPostingInfoRow.Value;
					If ItemOfPostingInfo.Metadata = RegisterType Then
						If ItemOfPostingInfo.PrepareTable.Columns.Find("Key") = Undefined Then
							ItemOfPostingInfo.PrepareTable.Columns.Add("Key", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
						EndIf;
						For Each RowRecordSet In ItemOfPostingInfo.PrepareTable Do
							NewRow = TableOfAgreementMovementTypes.Add();
							NewRow.MovementType = RowRecordSet.Agreement.CurrencyMovementType;
							NewRow.Partner      = RowRecordSet.Partner;
							NewRow.LegalName    = RowRecordSet.LegalName;
							NewRow.Amount       = RowRecordSet.Amount;
							For Each RowPaymentList In _PaymentList Do
								PartnerAndLegalNameCondition = False;
								AgreementCondition = False;
								BasisDocumentCondition = False;
								If RowPaymentList.Partner = RowRecordSet.Partner And RowPaymentList.LegalName = RowRecordSet.LegalName Then
									PartnerAndLegalNameCondition = True;
								EndIf;
								If Not ValueIsFilled(RowPaymentList.Agreement) Then
									AgreementCondition = True;
								Else
									If RowPaymentList.Agreement.ApArPostingDetail = Enums.ApArPostingDetail.ByStandardAgreement
										And RowPaymentList.Agreement.StandardAgreement = RowRecordSet.Agreement Then
										AgreementCondition = True;
									Else
										If RowPaymentList.Agreement = RowRecordSet.Agreement Then
											AgreementCondition = True;
										EndIf;
									EndIf;
								EndIf;
								If Not ValueIsFilled(RowPaymentList.BasisDocument) Or RowPaymentList.BasisDocument = RowRecordSet.Basis Then
									BasisDocumentCondition = True;
								EndIf;
								If PartnerAndLegalNameCondition And AgreementCondition And BasisDocumentCondition Then
									RowRecordSet.Key = RowPaymentList.Key;
								EndIf;
							EndDo;
						EndDo;
					EndIf;
				EndDo;

				TableOfAgreementMovementTypes.GroupBy("MovementType, Partner, LegalName, Amount, Key");

				For Each RowPaymentList In _PaymentList Do
					If ValueIsFilled(RowPaymentList.Agreement) Then
						Continue;
					EndIf;
					For Each RowMovementTypes In TableOfAgreementMovementTypes Do
						If RowPaymentList.Partner = RowMovementTypes.Partner And RowPaymentList.LegalName = RowMovementTypes.LegalName Then
							ArrayOfCurrencies = CurrencyTable.FindRows(New Structure("Key, MovementType", RowPaymentList.Key, RowMovementTypes.MovementType));
							If Not ArrayOfCurrencies.Count() Then
								CurrencyParameters = GetNewCurrencyRowParameters();
								CurrencyParameters.RowKey   = RowPaymentList.Key;
								CurrencyParameters.Currency = Parameters.Object.Currency;
								CurrencyParameters.Ref      = Parameters.Object.Ref;
								
								NewRow = AddRowToCurrencyTable(CurrencyParameters, Parameters.Object.Date, CurrencyTable, RowMovementTypes.MovementType);
								CurrenciesClientServer.CalculateAmountByRow(NewRow, RowMovementTypes.Amount);
							EndIf;
						EndIf;
					EndDo;
				EndDo;

			EndIf; // DocumentCondition
			
			Query.SetParameter("CurrencyTable", CurrencyTable);
		
		Else // CurrencyTable <> Undefined
		
			Query.SetParameter("CurrencyTable", CurrencyTable);
			
		EndIf;
		Query.Execute();
		For Each ItemOfPostingInfoRow In ArrayOfPostingInfo Do
			ItemOfPostingInfo = ItemOfPostingInfoRow.Value;
			If ItemOfPostingInfo.PrepareTable.Count() Then
				UseAgreementMovementType = IsUseAgreementMovementType(ItemOfPostingInfo.Metadata);
				UseCurrencyJoin = IsUseCurrencyJoin(Parameters, ItemOfPostingInfo.Metadata);
				ItemOfPostingInfo.PrepareTable = ExpandTable(TempTableManager, 
															ItemOfPostingInfo.PrepareTable, 
															UseAgreementMovementType, 
															UseCurrencyJoin);
				
				IsOffsetOfAdvances = CommonFunctionsClientServer.GetFromAddInfo(Parameters, "IsOffsetOfAdvances", False);
				IsLandedCost = CommonFunctionsClientServer.GetFromAddInfo(Parameters, "IsLandedCost", False);
				
				If Not IsOffsetOfAdvances And Not IsLandedCost Then
				
					// Advances
					If ItemOfPostingInfo.Metadata = Metadata.AccumulationRegisters.R1020B_AdvancesToVendors
						Or ItemOfPostingInfo.Metadata = Metadata.AccumulationRegisters.R2020B_AdvancesFromCustomers Then
					
						AdvancesCurrencyRevaluation = GetAdvancesCurrencyRevaluation(Parameters.Object.Ref);
						For Each Row In AdvancesCurrencyRevaluation Do
							FillPropertyValues(ItemOfPostingInfo.PrepareTable.Add(), Row);
						EndDo;	
					
					EndIf;
			
					// Transactions
					If ItemOfPostingInfo.Metadata = Metadata.AccumulationRegisters.R1021B_VendorsTransactions
						Or ItemOfPostingInfo.Metadata = Metadata.AccumulationRegisters.R2021B_CustomersTransactions Then
					
						TransactionsCurrencyRevaluation = GetTransactionsCurrencyRevaluation(Parameters.Object.Ref);
						For Each Row In TransactionsCurrencyRevaluation Do
							FillPropertyValues(ItemOfPostingInfo.PrepareTable.Add(), Row);
						EndDo;	
					
					EndIf;
						
				EndIf; // Not IsOffsetOfAdvances 
			EndIf;
		EndDo;
	EndIf;
	
	ExchangeDifference(Parameters);	
EndProcedure

Function GetAdvancesCurrencyRevaluation(DocRef)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	Table.Period,
	|	Table.Recorder AS VendorsAdvancesClosing,
	|	Table.Recorder AS CustomersAdvancesClosing,
	|	Table.AdvanceOrder AS Order,
	|	Table.Company,
	|	Table.Branch,
	|	Table.Currency,
	|	Table.LegalName,
	|	Table.Partner,
	|	Table.Amount,
	|	Table.CurrencyMovementType,
	|	Table.TransactionCurrency
	|FROM
	|	InformationRegister.T2012S_AdvancesCurrencyRevaluation AS Table
	|WHERE
	|	Table.Document = &DocRef";
	Query.SetParameter("DocRef", DocRef);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

Function GetTransactionsCurrencyRevaluation(DocRef)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	Table.Period,
	|	Table.Recorder AS VendorsAdvancesClosing,
	|	Table.Recorder AS CustomersAdvancesClosing,
	|	Table.TransactionOrder AS Order,
	|	Table.TransactionDocument AS Basis,
	|	Table.Company,
	|	Table.Branch,
	|	Table.Currency,
	|	Table.LegalName,
	|	Table.Partner,
	|	Table.Agreement,
	|	Table.Amount,
	|	Table.CurrencyMovementType,
	|	Table.TransactionCurrency
	|FROM
	|	InformationRegister.T2011S_TransactionsCurrencyRevaluation AS Table
	|WHERE
	|	Table.Document = &DocRef";
	Query.SetParameter("DocRef", DocRef);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

Function GetAccountingAmounts(DocRef)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Table.Period,
	|	Table.Currency,
	|	Table.CurrencyMovementType,
	|	Table.Amount,
	|	Table.Recorder AS AdvancesClosing,
	|	""Advance"" AS AmountType
	|FROM
	|	InformationRegister.T2012S_AdvancesCurrencyRevaluation AS Table
	|WHERE
	|	Table.Document = &DocRef
	|
	|UNION ALL
	|
	|SELECT
	|	Table.Period,
	|	Table.Currency,
	|	Table.CurrencyMovementType,
	|	Table.Amount,
	|	Table.Recorder,
	|	""Transaction""
	|FROM
	|	InformationRegister.T2011S_TransactionsCurrencyRevaluation AS Table
	|WHERE
	|	Table.Document = &DocRef";
		
	Query.SetParameter("DocRef", DocRef);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

Function IsUseAgreementMovementType(RecMetadata)
	
	ExcludeRegisters = New Array();
	ExcludeRegisters.Add(Metadata.AccumulationRegisters.R3010B_CashOnHand);
		
	ExcludeRegisters.Add(Metadata.AccumulationRegisters.R6070T_OtherPeriodsExpenses);
	ExcludeRegisters.Add(Metadata.AccumulationRegisters.R6080T_OtherPeriodsRevenues);
	ExcludeRegisters.Add(Metadata.AccumulationRegisters.R5022T_Expenses);
	ExcludeRegisters.Add(Metadata.AccumulationRegisters.R5021T_Revenues);
	
	ExcludeRegisters.Add(Metadata.AccumulationRegisters.T1040T_AccountingAmounts);
	
	ExcludeRegisters.Add(Metadata.AccumulationRegisters.R2040B_TaxesIncoming);
	ExcludeRegisters.Add(Metadata.AccumulationRegisters.R1040B_TaxesOutgoing);
	
	If ExcludeRegisters.Find(RecMetadata) = Undefined Then
		Return True;
	Else
		Return False;
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

Procedure AddAmountsColumns(RecordSet, ColumnName)
	If RecordSet.Columns.Find(ColumnName) = Undefined Then
		RecordSet.Columns.Add(ColumnName, Metadata.DefinedTypes.typeAmount.Type);
		RecordSet.FillValues(0, ColumnName);
	EndIf;
EndProcedure

Function ExpandTable(TempTableManager, RecordSet, UseAgreementMovementType, UseCurrencyJoin)

	AddAmountsColumns(RecordSet, "Amount");
	AddAmountsColumns(RecordSet, "ManualAmount");
	AddAmountsColumns(RecordSet, "NetAmount");
	AddAmountsColumns(RecordSet, "OffersAmount");
	AddAmountsColumns(RecordSet, "SalesAmount");
	AddAmountsColumns(RecordSet, "NetOfferAmount");
	AddAmountsColumns(RecordSet, "AmountWithTaxes");
	AddAmountsColumns(RecordSet, "Commission");
	AddAmountsColumns(RecordSet, "AmountTax");
	AddAmountsColumns(RecordSet, "Price");
	AddAmountsColumns(RecordSet, "ConsignorPrice");
	AddAmountsColumns(RecordSet, "SalesAmount");
	AddAmountsColumns(RecordSet, "NetOfferAmount");
	AddAmountsColumns(RecordSet, "CustomerTransaction");
	AddAmountsColumns(RecordSet, "CustomerAdvance");
	AddAmountsColumns(RecordSet, "VendorTransaction");
	AddAmountsColumns(RecordSet, "VendorAdvance");
	AddAmountsColumns(RecordSet, "OtherTransaction");
	AddAmountsColumns(RecordSet, "TaxableAmount");
	AddAmountsColumns(RecordSet, "TaxAmount");

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
	|	CAST(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.NetOfferAmount * CurrencyTable.Rate) / CurrencyTable.Multiplicity
	|	END AS Number(15,2)) AS NetOfferAmount,
	|	CAST(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.SalesAmount * CurrencyTable.Rate) / CurrencyTable.Multiplicity
	|	END AS Number(15,2)) AS SalesAmount,
	|	CAST(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.Amount * CurrencyTable.Rate) / CurrencyTable.Multiplicity
	|	END AS Number(15,2)) AS Amount,
	|	CAST(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.ManualAmount * CurrencyTable.Rate) / CurrencyTable.Multiplicity
	|	END AS Number(15,2)) AS ManualAmount,
	|	CAST(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.NetAmount * CurrencyTable.Rate) / CurrencyTable.Multiplicity
	|	END AS Number(15,2)) AS NetAmount,
	|	CAST(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.OffersAmount * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END AS Number(15,2)) AS OffersAmount,
	|	CAST(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.AmountWithTaxes * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END AS Number(15,2)) AS AmountWithTaxes,
	|	CAST(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.Commission * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END AS Number(15,2)) AS Commission,
	|	CAST(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.AmountTax * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END AS Number(15,2)) AS AmountTax,
	|	CAST(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.Price * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END AS Number(15,2)) AS Price,
	|	CAST(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.ConsignorPrice * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END AS Number(15,2)) AS ConsignorPrice,
	|	CAST(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.CustomerTransaction * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END AS Number(15,2)) AS CustomerTransaction,
	|	CAST(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.CustomerAdvance * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END AS Number(15,2)) AS CustomerAdvance,
	|	CAST(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.VendorTransaction * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END AS Number(15,2)) AS VendorTransaction,
	|	CAST(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.VendorAdvance * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END AS Number(15,2)) AS VendorAdvance,
	|	CAST(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.OtherTransaction * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END AS Number(15,2)) AS OtherTransaction,
	|	CAST(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.TaxableAmount * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END AS Number(15,2)) AS TaxableAmount,
	|	CAST(CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.TaxAmount * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END AS Number(15,2)) AS TaxAmount,
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
	|	CAST(RecordSet.NetOfferAmount AS Number(15,2)) AS NetOfferAmount,
	|	CAST(RecordSet.SalesAmount AS Number(15,2)) AS SalesAmount,
	|	CAST(RecordSet.Amount AS Number(15,2)) AS Amount,
	|	CAST(RecordSet.ManualAmount AS Number(15,2)) AS ManualAmount,
	|	CAST(RecordSet.NetAmount AS Number(15,2)) AS NetAmount,
	|	CAST(RecordSet.OffersAmount AS Number(15,2)) AS OffersAmount,
	|	CAST(RecordSet.AmountWithTaxes AS Number(15,2)) AS AmountWithTaxes,
	|	CAST(RecordSet.Commission AS Number(15,2)) AS Commission,
	|	CAST(RecordSet.AmountTax AS Number(15,2)) AS AmountTax,
	|	CAST(RecordSet.Price AS Number(15,2)) AS Price,
	|	CAST(RecordSet.ConsignorPrice AS Number(15,2)) AS ConsignorPrice,
	|	CAST(RecordSet.CustomerTransaction AS Number(15,2)) AS CustomerTransaction,
	|	CAST(RecordSet.CustomerAdvance AS Number(15,2)) AS CustomerAdvance,
	|	CAST(RecordSet.VendorTransaction AS Number(15,2)) AS VendorTransaction,
	|	CAST(RecordSet.VendorAdvance AS Number(15,2)) AS VendorAdvance,
	|	CAST(RecordSet.OtherTransaction AS Number(15,2)) AS OtherTransaction,
	|	CAST(RecordSet.TaxableAmount AS Number(15,2)) AS TaxableAmount,
	|	CAST(RecordSet.TaxAmount AS Number(15,2)) AS TaxAmount,
	|	FALSE,
	|	RecordSet.Currency
	|FROM
	|	RecordSet AS RecordSet
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|DROP RecordSet";
	UseKey = RecordSet.Columns.Find("Key") <> Undefined;
	If Not UseKey Then
		RecordSet.Columns.Add("Key", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	EndIf;

	Query.SetParameter("RecordSet", RecordSet);
	Query.SetParameter("UseKey", UseKey);
	Query.SetParameter("UseAgreementMovementType", UseAgreementMovementType);
	Query.SetParameter("UseCurrencyJoin", UseCurrencyJoin);
	QueryResults = Query.ExecuteBatch();
	QueryTable = QueryResults[1].Unload();
	
	If QueryTable.Columns.Find("TransactionCurrency") <> Undefined Then
		TransactionRows = QueryTable.FindRows(New Structure("CurrencyMovementType", 
			ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency));
			
		For Each TransactionRow In TransactionRows Do
			For Each Row In QueryTable Do
				If UseKey And ValueIsFilled(TransactionRow.Key) Then 
					If Row.Key = TransactionRow.Key Then
						Row.TransactionCurrency = TransactionRow.Currency;
					Else
						Continue;
					EndIf;
				Else
					Row.TransactionCurrency = TransactionRow.Currency;
				EndIf;
			EndDo;
		EndDo;
	EndIf;
	
	Return QueryTable;
EndFunction

Procedure UpdateCurrencyTable(Parameters, CurrenciesTable) Export
	Columns = Parameters.Ref.Metadata().TabularSections.Currencies.Attributes;
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

#Region EXCHANGE_DIFFERENCE

Procedure ExchangeDifference(Parameters)
	
	IsMoneyExchange = False;
	TransitIncoming = New ValueTable();
	TransitIncoming_PrepareTable = NEw ValueTable();
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
	
	Expenes = Parameters.PostingDataTables[Metadata.AccumulationRegisters.R5022T_Expenses].PrepareTable;	
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
			
			Expenses_NewRow = Expenes.Add();
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
	
	ElsIf StrStartsWith(RegisterName, "R1040B_TaxesOutgoing") Then
		Return "R1040B_TaxesOutgoing";
	
	ElsIf StrStartsWith(RegisterName, "R2040B_TaxesIncoming") Then
		Return "R2040B_TaxesIncoming";
	
	Else
		Return RegisterName;
	EndIf;
EndFunction

#EndRegion
