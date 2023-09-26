Procedure PreparePostingDataTables(Parameters, CurrencyTable, AddInfo = Undefined) Export
	ArrayOfPostingInfo = New Array();
	If Parameters.Property("ArrayOfPostingInfo") Then
		ArrayOfPostingInfo = Parameters.ArrayOfPostingInfo;
	Else
		For Each PostingInfo In Parameters.PostingDataTables Do
			RecordSetMetadata = PostingInfo.Key.Metadata();
			If Parameters.Property("MultiCurrencyExcludePostingDataTables")
				And Parameters.MultiCurrencyExcludePostingDataTables.Find(RecordSetMetadata) <> Undefined Then
				Continue;
			EndIf;

			If Metadata.AccumulationRegisters.Contains(RecordSetMetadata) 
				Or Metadata.InformationRegisters.Contains(RecordSetMetadata) Then
					
				Dimension = RecordSetMetadata.Dimensions.Find("CurrencyMovementType");
				// Register supported multicurrency
				If Dimension <> Undefined Then
					ArrayOfPostingInfo.Add(PostingInfo);
				EndIf;
			EndIf;
		EndDo;
	EndIf;

	If ArrayOfPostingInfo.Count() And
	 (Parameters.Object.Metadata().TabularSections.Find("Currencies") <> Undefined Or CurrencyTable <> Undefined) Then
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
			
			If TypeOf(Parameters.Object.Ref) = Type("DocumentRef.CashReceipt") Or TypeOf(Parameters.Object.Ref) = Type("DocumentRef.BankReceipt") Then
				DocumentCondition = True;
				RegisterType = Type("AccumulationRegisterRecordSet.R2021B_CustomersTransactions");
				For Each RowPaymentList In Parameters.Object.PaymentList Do
					NewRowPaymentList = _PaymentList.Add();
					FillPropertyValues(NewRowPaymentList, RowPaymentList);
					NewRowPaymentList.LegalName = RowPaymentList.Payer;
				EndDo;
			EndIf;
			If TypeOf(Parameters.Object.Ref) = Type("DocumentRef.CashPayment") Or TypeOf(Parameters.Object.Ref) = Type("DocumentRef.BankPayment") Then
				DocumentCondition = True;
				RegisterType = Type("AccumulationRegisterRecordSet.R1021B_VendorsTransactions");
				For Each RowPaymentList In Parameters.Object.PaymentList Do
					NewRowPaymentList = _PaymentList.Add();
					FillPropertyValues(NewRowPaymentList, RowPaymentList);
					NewRowPaymentList.LegalName = RowPaymentList.Payee;
				EndDo;
			EndIf;
			If TypeOf(Parameters.Object.Ref) = Type("DocumentRef.EmployeeCashAdvance") Then
				DocumentCondition = True;
				RegisterType = Type("AccumulationRegisterRecordSet.R1021B_VendorsTransactions");
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
				For Each ItemOfPostingInfo In ArrayOfPostingInfo Do
					If TypeOf(ItemOfPostingInfo.Key) = RegisterType Then
						If ItemOfPostingInfo.Value.Recordset.Columns.Find("Key") = Undefined Then
							ItemOfPostingInfo.Value.Recordset.Columns.Add("Key", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
						EndIf;
						For Each RowRecordSet In ItemOfPostingInfo.Value.Recordset Do
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
								NewRow = AddRowToCurrencyTable(Parameters.Object.Date, CurrencyTable, RowPaymentList.Key, Parameters.Object.Currency, RowMovementTypes.MovementType);
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
		For Each ItemOfPostingInfo In ArrayOfPostingInfo Do
			If ItemOfPostingInfo.Value.RecordSet.Count() Then
				UseAgreementMovementType = IsUseAgreementMovementType(ItemOfPostingInfo);
				UseCurrencyJoin = IsUseCurrencyJoin(Parameters, ItemOfPostingInfo);
				ItemOfPostingInfo.Value.RecordSet = ExpandTable(TempTableManager, ItemOfPostingInfo.Value.RecordSet, UseAgreementMovementType, UseCurrencyJoin);
			EndIf;
		EndDo;
	EndIf;
EndProcedure

Function IsUseAgreementMovementType(ItemOfPostingInfo)
	UseAgreementMovementType = True;
	If TypeOf(ItemOfPostingInfo.Key) = Type("AccumulationRegisterRecordSet.R3010B_CashOnHand") Or TypeOf(
		ItemOfPostingInfo.Key) = Type("AccumulationRegisterRecordSet.R2020B_AdvancesFromCustomers") Or TypeOf(
		ItemOfPostingInfo.Key) = Type("AccumulationRegisterRecordSet.R1020B_AdvancesToVendors") Then
		UseAgreementMovementType = False;
	EndIf;
	Return UseAgreementMovementType;
EndFunction

Function IsUseCurrencyJoin(Parameters, ItemOfPostingInfo)
	UseCurrencyJoin = False;

	TypeOfRecordSetsArray = New Array();
	TypeOfRecordSetsArray.Add(Type("AccumulationRegisterRecordSet.R3035T_CashPlanning"));
	TypeOfRecordSetsArray.Add(Type("AccumulationRegisterRecordSet.R3010B_CashOnHand"));
	TypeOfRecordSetsArray.Add(Type("AccumulationRegisterRecordSet.R3015B_CashAdvance"));
	TypeOfRecordSetsArray.Add(Type("AccumulationRegisterRecordSet.R2021B_CustomersTransactions"));
	TypeOfRecordSetsArray.Add(Type("AccumulationRegisterRecordSet.R1021B_VendorsTransactions"));

	FilterByDocument = False;

	If (TypeOf(Parameters.Object) = Type("DocumentObject.BankReceipt") Or TypeOf(Parameters.Object) = Type("DocumentRef.BankReceipt")) 
		And Parameters.Object.TransactionType = Enums.IncomingPaymentTransactionType.CurrencyExchange Then
		FilterByDocument = True;
	EndIf;

	If (TypeOf(Parameters.Object) = Type("DocumentObject.CashReceipt") Or TypeOf(Parameters.Object) = Type("DocumentRef.CashReceipt")) 
		And Parameters.Object.TransactionType = Enums.IncomingPaymentTransactionType.CurrencyExchange Then
		FilterByDocument = True;
	EndIf;

	If FilterByDocument And TypeOfRecordSetsArray.Find(TypeOf(ItemOfPostingInfo.Key)) <> Undefined Then
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
	|	CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.NetOfferAmount * CurrencyTable.Rate) / CurrencyTable.Multiplicity
	|	END AS NetOfferAmount,
	|	CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.SalesAmount * CurrencyTable.Rate) / CurrencyTable.Multiplicity
	|	END AS SalesAmount,
	|	CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.Amount * CurrencyTable.Rate) / CurrencyTable.Multiplicity
	|	END AS Amount,
	|	CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.ManualAmount * CurrencyTable.Rate) / CurrencyTable.Multiplicity
	|	END AS ManualAmount,
	|	CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.NetAmount * CurrencyTable.Rate) / CurrencyTable.Multiplicity
	|	END AS NetAmount,
	|	CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.OffersAmount * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END AS OffersAmount,
	|	CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.AmountWithTaxes * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END AS AmountWithTaxes,
	|	CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.Commission * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END AS Commission,
	|	CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.AmountTax * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END AS AmountTax,
	|	CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.Price * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END AS Price,
	|	CASE
	|		WHEN CurrencyTable.Rate = 0
	|		OR CurrencyTable.Multiplicity = 0
	|			THEN 0
	|		ELSE (RecordSet.ConsignorPrice * CurrencyTable.Rate )/ CurrencyTable.Multiplicity
	|	END AS ConsignorPrice,
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
	|	RecordSet.NetOfferAmount,
	|	RecordSet.SalesAmount,
	|	RecordSet.Amount,
	|	RecordSet.ManualAmount,
	|	RecordSet.NetAmount,
	|	RecordSet.OffersAmount,
	|	RecordSet.AmountWithTaxes,
	|	RecordSet.Commission,
	|	RecordSet.AmountTax,
	|	RecordSet.Price,
	|	RecordSet.ConsignorPrice,
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
		AddRowToCurrencyTable(RatePeriod,
			EmptyCurrenciesTable,
			Parameters.RowKey,
			Parameters.Currency,
			AgreementInfo.CurrencyMovementType);
	EndIf;
	
	// Legal currency
	For Each ItemOfArray In Catalogs.Companies.GetLegalCurrencies(Parameters.Company) Do
		AddRowToCurrencyTable(RatePeriod,
			EmptyCurrenciesTable,
			Parameters.RowKey,
			Parameters.Currency,
			ItemOfArray.CurrencyMovementType);
	EndDo;
	
	// Reporting currency
	For Each ItemOfArray In Catalogs.Companies.GetReportingCurrencies(Parameters.Company) Do
		AddRowToCurrencyTable(RatePeriod,
			EmptyCurrenciesTable,
			Parameters.RowKey,
			Parameters.Currency,
			ItemOfArray.CurrencyMovementType);
	EndDo;
	
	// Budgeting currency
	For Each ItemOfArray In Catalogs.Companies.GetBudgetingCurrencies(Parameters.Company) Do
		AddRowToCurrencyTable(RatePeriod,
			EmptyCurrenciesTable,
			Parameters.RowKey,
			Parameters.Currency,
			ItemOfArray.CurrencyMovementType);
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

Function AddRowToCurrencyTable(RatePeriod, CurrenciesTable, RowKey, CurrencyFrom, CurrencyMovementType, FixedRates = Undefined) Export
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
	NewRow.Key = RowKey;
	NewRow.CurrencyFrom = CurrencyFrom;
	NewRow.MovementType = CurrencyMovementType;
	If Not CurrencyMovementType.DeferredCalculation Then
		
		UseFixedRates = False;
		
		// fixed rates from document
		If FixedRates <> Undefined Then
			Filter = New Structure();
			//Filter.Insert("Key"          , NewRow.Key);
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
		
		// rates from register	
		If Not UseFixedRates Then
			CurrencyInfo = Catalogs.Currencies.GetCurrencyInfo(RatePeriod, 
				CurrencyFrom, 
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

