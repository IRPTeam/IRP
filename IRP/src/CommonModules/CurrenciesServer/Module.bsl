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

			If Metadata.AccumulationRegisters.Contains(RecordSetMetadata) Or Metadata.InformationRegisters.Contains(
				RecordSetMetadata) Then
				Dimension = RecordSetMetadata.Dimensions.Find("CurrencyMovementType");
				// Register supported multicurrency
				If Dimension <> Undefined Then
					ArrayOfPostingInfo.Add(PostingInfo);
				EndIf;
			EndIf;
		EndDo;
	EndIf;

	If ArrayOfPostingInfo.Count() And Parameters.Object.Metadata().TabularSections.Find("Currencies") <> Undefined Then
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

			If TypeOf(Parameters.Object.Ref) = Type("DocumentRef.CashReceipt") Or TypeOf(Parameters.Object.Ref) = Type(
				"DocumentRef.BankReceipt") Then
				DocumentCondition = True;
				Name_LegalName = "Payer";
				RegisterType = Type("AccumulationRegisterRecordSet.R2021B_CustomersTransactions");
			EndIf;
			If TypeOf(Parameters.Object.Ref) = Type("DocumentRef.CashPayment") Or TypeOf(Parameters.Object.Ref) = Type(
				"DocumentRef.BankPayment") Then
				DocumentCondition = True;
				Name_LegalName = "Payee";
				RegisterType = Type("AccumulationRegisterRecordSet.R1021B_VendorsTransactions");
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
						ItemOfPostingInfo.Value.Recordset.Columns.Add("Key",
							New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
						For Each RowRecordSet In ItemOfPostingInfo.Value.Recordset Do
							NewRow = TableOfAgreementMovementTypes.Add();
							NewRow.MovementType = RowRecordSet.Agreement.CurrencyMovementType;
							NewRow.Partner      = RowRecordSet.Partner;
							NewRow.LegalName    = RowRecordSet.LegalName;
							NewRow.Amount       = RowRecordSet.Amount;
							For Each RowPaymentList In Parameters.Object.PaymentList Do
								PartnerAndLegalNameCondition = False;
								AgreementCondition = False;
								BasisDocumentCondition = False;
								If RowPaymentList.Partner = RowRecordSet.Partner And RowPaymentList[Name_LegalName]
									= RowRecordSet.LegalName Then
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
								If Not ValueIsFilled(RowPaymentList.BasisDocument) Or RowPaymentList.BasisDocument
									= RowRecordSet.Basis Then
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

				For Each RowPaymentList In Parameters.Object.PaymentList Do
					If ValueIsFilled(RowPaymentList.Agreement) Then
						Continue;
					EndIf;
					For Each RowMovementTypes In TableOfAgreementMovementTypes Do
						If RowPaymentList.Partner = RowMovementTypes.Partner And RowPaymentList[Name_LegalName]
							= RowMovementTypes.LegalName Then
							ArrayOfCurrencies = CurrencyTable.FindRows(
							New Structure("Key, MovementType", RowPaymentList.Key, RowMovementTypes.MovementType));
							If Not ArrayOfCurrencies.Count() Then
								NewRow = AddRowToCurrencyTable(Parameters.Object.Date, CurrencyTable, RowPaymentList.Key,
									Parameters.Object.Currency, RowMovementTypes.MovementType);
								CalculateAmountByRow(NewRow, RowMovementTypes.Amount);
							EndIf;
						EndIf;
					EndDo;
				EndDo;

			EndIf;
			Query.SetParameter("CurrencyTable", CurrencyTable);
		Else
			Query.SetParameter("CurrencyTable", CurrencyTable);
		EndIf;
		Query.Execute();
		For Each ItemOfPostingInfo In ArrayOfPostingInfo Do
			If ItemOfPostingInfo.Value.RecordSet.Count() Then
				UseAgreementMovementType = IsUseAgreementMovementType(ItemOfPostingInfo);
				UseCurrencyJoin = IsUseCurrencyJoin(Parameters, ItemOfPostingInfo);
				ItemOfPostingInfo.Value.RecordSet = ExpandTable(TempTableManager, ItemOfPostingInfo.Value.RecordSet,
					UseAgreementMovementType, UseCurrencyJoin);
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

	If (TypeOf(Parameters.Object) = Type("DocumentObject.BankReceipt") Or TypeOf(Parameters.Object) = Type(
		"DocumentRef.BankReceipt")) And Parameters.Object.TransactionType
		= Enums.IncomingPaymentTransactionType.CurrencyExchange Then
		FilterByDocument = True;
	EndIf;

	If (TypeOf(Parameters.Object) = Type("DocumentObject.CashReceipt") Or TypeOf(Parameters.Object) = Type(
		"DocumentRef.CashReceipt")) And Parameters.Object.TransactionType
		= Enums.IncomingPaymentTransactionType.CurrencyExchange Then
		FilterByDocument = True;
	EndIf;

	If TypeOf(Parameters.Object) = Type("DocumentObject.InvoiceMatch") Or TypeOf(Parameters.Object) = Type(
		"DocumentRef.InvoiceMatch") Then
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

	If RecordSet.Columns.Find("SalesAmount") = Undefined Then
		RecordSet.Columns.Add("SalesAmount", New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	EndIf;
	If RecordSet.Columns.Find("NetOfferAmount") = Undefined Then
		RecordSet.Columns.Add("NetOfferAmount", New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	EndIf;

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
	Return QueryTable;
EndFunction

Procedure FillCurrencyTable(Object, Date, Company, Currency, RowKey, AgreementInfo) Export
	
	// Agreement currency
	If AgreementInfo <> Undefined And ValueIsFilled(AgreementInfo.Ref) Then
		AddRowToCurrencyTable(Date, Object.Currencies, RowKey, Currency, AgreementInfo.CurrencyMovementType);
	EndIf;
	
	// Legal currency
	For Each ItemOfArray In Catalogs.Companies.GetLegalCurrencies(Company) Do
		AddRowToCurrencyTable(Date, Object.Currencies, RowKey, Currency, ItemOfArray.CurrencyMovementType);
	EndDo;
	
	// Reporting currency
	For Each ItemOfArray In Catalogs.Companies.GetReportingCurrencies(Company) Do
		AddRowToCurrencyTable(Date, Object.Currencies, RowKey, Currency, ItemOfArray.CurrencyMovementType);
	EndDo;
	
	// Budgeting currency
	For Each ItemOfArray In Catalogs.Companies.GetBudgetingCurrencies(Company) Do
		AddRowToCurrencyTable(Date, Object.Currencies, RowKey, Currency, ItemOfArray.CurrencyMovementType);
	EndDo;
EndProcedure

Function AddRowToCurrencyTable(Date, CurrenciesTable, RowKey, CurrencyFrom, CurrencyMovementType) Export
	NewRow = CurrenciesTable.Add();
	NewRow.Key = RowKey;
	NewRow.CurrencyFrom = CurrencyFrom;
	NewRow.MovementType = CurrencyMovementType;
	If Not CurrencyMovementType.DeferredCalculation Then
		CurrencyInfo = Catalogs.Currencies.GetCurrencyInfo(Date, CurrencyFrom, CurrencyMovementType.Currency,
			CurrencyMovementType.Source);
		If Not ValueIsFilled(CurrencyInfo.Rate) Then
			NewRow.Rate = 0;
			NewRow.ReverseRate = 0;
			NewRow.Multiplicity = 0;
		Else
			NewRow.Rate = CurrencyInfo.Rate;
			NewRow.ReverseRate = 1 / CurrencyInfo.Rate;
			NewRow.Multiplicity = CurrencyInfo.Multiplicity;
		EndIf;
	EndIf;
	Return NewRow;
EndFunction

Procedure ClearCurrenciesTable(Object, RowKey) Export
	If RowKey = Undefined Then
		Object.Currencies.Clear();
	Else
		ArrayForDelete = New Array();
		For Each Row In Object.Currencies Do
			If Row.Key = RowKey Then
				ArrayForDelete.Add(Row);
			EndIf;
		EndDo;
		For Each ItemForDelete In ArrayForDelete Do
			Object.Currencies.Delete(ItemForDelete);
		EndDo;
	EndIf;
EndProcedure

Procedure CalculateAmount(Object, DocumentAmount, RowKeyFilter, CurrencyFilter = Undefined) Export
	For Each Row In Object.Currencies Do
		If RowKeyFilter <> Undefined And Row.Key <> RowKeyFilter Then
			Continue;
		EndIf;
		If CurrencyFilter <> Undefined And Row.CurrencyFrom <> CurrencyFilter Then
			Continue;
		EndIf;

		If Row.Multiplicity = 0 Or Row.Rate = 0 Then
			Row.Amount = 0;
			Continue;
		EndIf;
		CalculateAmountByRow(Row, DocumentAmount);
	EndDo;
EndProcedure

Procedure CalculateAmountByRow(Row, DocumentAmount) Export
	If Row.ShowReverseRate Then
		Row.Amount = (DocumentAmount / Row.ReverseRate) / Row.Multiplicity;
	Else
		Row.Amount = (DocumentAmount * Row.Rate) / Row.Multiplicity;
	EndIf;
EndProcedure

Procedure CalculateRate(Object, DocumentAmount, MovementType, RowKeyFilter, CurrencyFilter = Undefined) Export
	For Each Row In Object.Currencies Do
		If Row.MovementType <> MovementType Then
			Continue;
		EndIf;
		If RowKeyFilter <> Undefined And Row.Key <> RowKeyFilter Then
			Continue;
		EndIf;
		If CurrencyFilter <> Undefined And Row.CurrencyFrom <> CurrencyFilter Then
			Continue;
		EndIf;

		If Row.Amount = 0 Or Row.Multiplicity = 0 Then
			Row.Rate = 0;
			Continue;
		EndIf;
		Row.Rate = Row.Amount * Row.Multiplicity / DocumentAmount;
		Row.ReverseRate = DocumentAmount / (Row.Amount * Row.Multiplicity);
	EndDo;
EndProcedure

Procedure UpdateRatePresentation(Object) Export
	For Each Row In Object.Currencies Do
		Row.RatePresentation = ?(Row.ShowReverseRate, Row.ReverseRate, Row.Rate);
	EndDo;
EndProcedure

Procedure SetVisibleCurrenciesRow(Object, RowKey, IgnoreRowKey) Export
	For Each Row In Object.Currencies Do
		If IgnoreRowKey Then
			Row.IsVisible = Row.CurrencyFrom <> Row.MovementType.Currency;
		Else
			Row.IsVisible = Row.Key = RowKey And Row.CurrencyFrom <> Row.MovementType.Currency;
		EndIf;
	EndDo;
EndProcedure

#Region Refactoring

Procedure UpdateCurrencyTable_Refactoring(Parameters, CurrenciesTable) Export
	EmptyCurrenciesTable = New ValueTable();
	EmptyCurrenciesTable.Columns.Add("Key");
	EmptyCurrenciesTable.Columns.Add("IsFixed");
	EmptyCurrenciesTable.Columns.Add("CurrencyFrom");
	EmptyCurrenciesTable.Columns.Add("Rate");
	EmptyCurrenciesTable.Columns.Add("ReverseRate");
	EmptyCurrenciesTable.Columns.Add("ShowReverseRate");
	EmptyCurrenciesTable.Columns.Add("Multiplicity");
	EmptyCurrenciesTable.Columns.Add("MovementType");
	EmptyCurrenciesTable.Columns.Add("Amount");
	
	RatePeriod    = CalculationStringsClientServer.GetSliceLastDateByRefAndDate(Parameters.Ref, Parameters.Date);
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(Parameters.Agreement);
	
	// Agreement currency
	If AgreementInfo <> Undefined And ValueIsFilled(AgreementInfo.Ref) Then
		AddRowToCurrencyTable_Refactoring(RatePeriod,
			EmptyCurrenciesTable,
			Parameters.RowKey,
			Parameters.Currency,
			AgreementInfo.CurrencyMovementType);
	EndIf;
	
	// Legal currency
	For Each ItemOfArray In Catalogs.Companies.GetLegalCurrencies(Parameters.Company) Do
		AddRowToCurrencyTable_Refactoring(RatePeriod,
			EmptyCurrenciesTable,
			Parameters.RowKey,
			Parameters.Currency,
			ItemOfArray.CurrencyMovementType);
	EndDo;
	
	// Reporting currency
	For Each ItemOfArray In Catalogs.Companies.GetReportingCurrencies(Parameters.Company) Do
		AddRowToCurrencyTable_Refactoring(RatePeriod,
			EmptyCurrenciesTable,
			Parameters.RowKey,
			Parameters.Currency,
			ItemOfArray.CurrencyMovementType);
	EndDo;
	
	// Budgeting currency
	For Each ItemOfArray In Catalogs.Companies.GetBudgetingCurrencies(Parameters.Company) Do
		AddRowToCurrencyTable_Refactoring(RatePeriod,
			EmptyCurrenciesTable,
			Parameters.RowKey,
			Parameters.Currency,
			ItemOfArray.CurrencyMovementType);
	EndDo;
	
	CurrenciesClientServer.CalculateAmount_Refactoring(EmptyCurrenciesTable, Parameters.DocumentAmount);
	
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
				CurrenciesClientServer.CalculateAmountByRow_Refactoring(ItemOfArray, Parameters.DocumentAmount);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Procedure AddRowToCurrencyTable_Refactoring(RatePeriod, CurrenciesTable, RowKey, CurrencyFrom, CurrencyMovementType)
	NewRow = CurrenciesTable.Add();
	NewRow.Key = RowKey;
	NewRow.CurrencyFrom = CurrencyFrom;
	NewRow.MovementType = CurrencyMovementType;
	If Not CurrencyMovementType.DeferredCalculation Then
		CurrencyInfo = Catalogs.Currencies.GetCurrencyInfo(RatePeriod, 
			CurrencyFrom, 
			CurrencyMovementType.Currency,
			CurrencyMovementType.Source);
		If Not ValueIsFilled(CurrencyInfo.Rate) Then
			NewRow.Rate = 0;
			NewRow.ReverseRate = 0;
			NewRow.Multiplicity = 0;
		Else
			NewRow.Rate = CurrencyInfo.Rate;
			NewRow.ReverseRate = 1 / CurrencyInfo.Rate;
			NewRow.Multiplicity = CurrencyInfo.Multiplicity;
		EndIf;
	EndIf;
EndProcedure

#EndRegion

