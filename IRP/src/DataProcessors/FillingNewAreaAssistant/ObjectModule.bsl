
#Region CreatingNewItems
	
Procedure CreateFinishData() Export
	Return;
EndProcedure

Procedure CreateCurrencyRateIntegrationSettings() Export
	
	Country = GetCountryByLocalizationCode(CompanyLocalization);
	If ValueIsFilled(Country) Then
		LegalCurrency = Country.Currency; 
	EndIf;
	
	// IntegrationSettings
	ClassifierElement = FillingFromClassifiers.GetElementFromClassifier("Catalog.IntegrationSettings", 
							"Description", CurrencyRateIntegrationSettingsName());
	If ClassifierElement <> Undefined Then
		ClassifierElement.ExternalDataProcSettings.DownloadRateType  = DownloadRateType;
		ClassifierElement.ExternalDataProcSettings.CurrencyFrom.Insert("NumericCode", LegalCurrency.NumericCode);
	EndIf;
	
	CurrencyRateIntegrationSettings = FillingFromClassifiers.CheckExistingAndCreateCatalogItemFromClassifierElement(
			"Catalog.IntegrationSettings", ClassifierElement);
	
EndProcedure

Procedure CreateCompany() Export
	
	// Company
	CompanyObject = Catalogs.Companies.CreateItem();
	CompanyObject.Our = True;
	FillPropertyValues(CompanyObject, 
						FillingFromClassifiers.DescriptionStructure(TrimAll(CompanyName)));
	CompanyObject.Type = CompanyType;
	
	If Not ValueIsFilled(Country) Then
		Country = GetCountryByLocalizationCode(CompanyLocalization);
	EndIf;
	CompanyObject.Country = Country;
	
	If Not ValueIsFilled(LegalCurrency) Then
		LegalCurrency = Country.Currency;
	EndIf;
	
	// Legal currency
	If ValueIsFilled(LegalCurrency) Then
		AttrStructure = New Structure();
		AttrStructure.Insert("Currency", LegalCurrency);
		AttrStructure.Insert("Source"  , CurrencyRateIntegrationSettings);
		AttrStructure.Insert("Type"    , Enums.CurrencyType.Legal);
		CompanyObject.Currencies.Add().MovementType = GetCurrencyMovementType(AttrStructure);
	EndIf;
	
	CompanyObject.Write();
	
	Company = CompanyObject.Ref;
	
	// User settings
	DataProcessors.FillingNewAreaAssistant.FillDefaultUserSettings(New Structure("Company", Company));
	
EndProcedure

Procedure CreateCurrencies(KeysArray) Export
	CreatedCurrencies.Clear();
	For Each KeyStructure In KeysArray Do
		For Each KeyAndValue In KeyStructure Do
			NewItem = FillingFromClassifiers.CreateCatalogItemFromClassifier("Catalog.Currencies", 
									KeyAndValue.Key, 
									KeyAndValue.Value);
			If ValueIsFilled(NewItem) Then
				CreatedCurrencies.Add().Currency = NewItem;
				CommonFunctionsClientServer.ShowUsersMessage(
					StrTemplate(R()["InfoMessage_002"], NewItem));
			EndIf;
		EndDo;
	EndDo;
EndProcedure

Procedure CreateAgreements() Export
	If Not ValueIsFilled(Company) Then
		Return;
	EndIf;
	
	PriceTypeSalesPrice    = GetPriceTypeByDescription("Sales price");
	PriceTypePurchasePrice = GetPriceTypeByDescription("Purchase price");
	
	MainStore = GetMainStore();
		
	For Each RowCurrency In CreatedCurrencies Do
		
		CurrencyDescription = TrimAll(RowCurrency.Currency.Description_en);
		
		// CurrencyMovementType
		AttrStructure = New Structure();
		AttrStructure.Insert("Currency", RowCurrency.Currency);
		AttrStructure.Insert("Type"    , Enums.CurrencyType.Agreement);
		CurrencyMovementTypeRef = GetCurrencyMovementType(AttrStructure);
		
		// Partner segment "Retail"
		PartnerSegment = Catalogs.PartnerSegments.CreateItem();
		FillPropertyValues(PartnerSegment, 
			FillingFromClassifiers.DescriptionStructure(StrTemplate(R()["Form_020"], CurrencyDescription)));
		PartnerSegment.Write();
		
		// Agreements
		// Customer agreement
		FillingData = New Structure();
		FillingData.Insert("CurrencyMovementType", CurrencyMovementTypeRef);
		FillingData.Insert("Date"                , CurrentSessionDate());
		FillingData.Insert("PartnerSegment"      , PartnerSegment.Ref);
		FillingData.Insert("Company"             , Company);
		FillingData.Insert("Standart"            , True);
		FillingData.Insert("PriceType"           , PriceTypeSalesPrice);
		FillingData.Insert("StartUsing"          , FillingData.Date);
		FillingData.Insert("Type"                , Enums.AgreementTypes.Customer);
		FillingData.Insert("Store"               , MainStore);
		
		CustomerAgreement = Catalogs.Agreements.CreateItem();
		FillPropertyValues(CustomerAgreement, FillingFromClassifiers.DescriptionStructure(
								StrTemplate(R().S_024, CurrencyDescription)));
		CustomerAgreement.Fill(FillingData);
		CustomerAgreement.Write();
		
		CommonFunctionsClientServer.ShowUsersMessage(
					StrTemplate(R()["InfoMessage_002"], CustomerAgreement));
					
		//  Vendor agreement
		FillingData = New Structure();
		FillingData.Insert("CurrencyMovementType", CurrencyMovementTypeRef);
		FillingData.Insert("Date"                , CurrentSessionDate());
		FillingData.Insert("PartnerSegment"      , PartnerSegment.Ref);
		FillingData.Insert("Company"             , Company);
		FillingData.Insert("Standart"            , True);
		FillingData.Insert("PriceType"           , PriceTypePurchasePrice);
		FillingData.Insert("StartUsing"          , FillingData.Date);
		FillingData.Insert("Type"                , Enums.AgreementTypes.Vendor);
		FillingData.Insert("Store"               , MainStore);
		
		VendorAgreement = Catalogs.Agreements.CreateItem();
		FillPropertyValues(VendorAgreement, FillingFromClassifiers.DescriptionStructure(
					StrTemplate(R().S_025, CurrencyDescription)));
		VendorAgreement.Fill(FillingData);
		VendorAgreement.Write();
		
		CommonFunctionsClientServer.ShowUsersMessage(
					StrTemplate(R()["InfoMessage_002"], VendorAgreement));
	EndDo;
EndProcedure

Procedure FillDefaultCompanyTaxes() Export
	If Not ValueIsFilled(Company) Then
		Return;
	EndIf;
	
	RecordPeriod = BegOfYear(CurrentSessionDate());
	
	// 1.Information register Taxes
	RecordSet = InformationRegisters.Taxes.CreateRecordSet();
	RecordSet.Filter.Company.Set(Company);
	
	// 2.Catalog Taxes
	ClassifierData = FillingFromClassifiers.GetClassifierData("Catalog.Taxes");
	For Each ClassifierElement In ClassifierData Do
		TaxRef = FillingFromClassifiers.CheckExistingAndCreateCatalogItemFromClassifierElement(
								"Catalog.Taxes", ClassifierElement);
		If ValueIsFilled(TaxRef) Then
			
			RecordSet.Filter.Tax.Set(TaxRef);
			RecordSet.Read();
			
			If Not RecordSet.Count() Then
				NewRecord = RecordSet.Add();
				NewRecord.Period  = RecordPeriod;
				NewRecord.Company = Company;
				NewRecord.Tax     = TaxRef;
				NewRecord.Use     = True;
				RecordSet.Write();
					
				CommonFunctionsClientServer.ShowUsersMessage(
						StrTemplate(R()["InfoMessage_002"], TaxRef));
			EndIf;
		EndIf;
	EndDo;
	
	// 3.Information register TaxSettings
	RecordSet = InformationRegisters.TaxSettings.CreateRecordSet();
	RecordSet.Filter.Company.Set(Company);
	
	ClassifierElements = FillingFromClassifiers.GetClassifierData("InformationRegister.TaxSettings");
	For Each ClassifierElement In ClassifierElements Do
		CurrentTax     = FillingFromClassifiers.CheckExistingAndCreateCatalogItemFromClassifierElement(
								"Catalog.Taxes", ClassifierElement.Tax);
		CurrentTaxRate = FillingFromClassifiers.CheckExistingAndCreateCatalogItemFromClassifierElement(
								"Catalog.TaxRates", ClassifierElement.TaxRate);
		
		RecordSet.Filter.Tax.Set(CurrentTax);
		RecordSet.Read();
		
		If Not RecordSet.Count() Then
			NewRecord = RecordSet.Add();
			NewRecord.Period  = RecordPeriod;
			NewRecord.Company = Company;
			NewRecord.Tax     = CurrentTax;
			NewRecord.TaxRate = CurrentTaxRate;
			RecordSet.Write();
					
			CommonFunctionsClientServer.ShowUsersMessage(
					StrTemplate(R()["InfoMessage_002"], CurrentTaxRate));
		EndIf;
	EndDo;
	
EndProcedure

Procedure CreateDefaultCashAndBankAccounts() Export
	If Not CreatedCashAccounts.Count() Then
		ClassifierElement = FillingFromClassifiers.GetElementFromClassifier("Catalog.CashAccounts", 
							"Description_en", 
							"Main cash account");
		If ClassifierElement <> Undefined Then
			ClassifierElement.Insert("Company", Company);
			FillingFromClassifiers.CreateCatalogItemFromClassifierElement("Catalog.CashAccounts", ClassifierElement);
		EndIf;
	EndIf;
	
	If Not CreatedBankAccounts.Count() Then
		ClassifierElement = FillingFromClassifiers.GetElementFromClassifier("Catalog.CashAccounts", 
							"Description_en", 
							"Main bank account");
		If ClassifierElement <> Undefined Then
			ClassifierElement.Insert("Company", Company);
			FillingFromClassifiers.CreateCatalogItemFromClassifierElement("Catalog.CashAccounts", ClassifierElement);
		EndIf;
	EndIf;
	
EndProcedure

#EndRegion


Function GetCountryByLocalizationCode(LocalizationCode)
	Query = New Query(
	"SELECT TOP 1
	|	Countries.Ref
	|FROM
	|	Catalog.Countries AS Countries
	|WHERE
	|	Countries.LocalizationCode = &LocalizationCode");
	Query.SetParameter("LocalizationCode", CompanyLocalization);
	Selection = Query.Execute().Select();
	If Selection.Next() Then
		Return Selection.Ref;
	EndIf;
	
	// Create from classifier
	Return FillingFromClassifiers.CreateCatalogItemFromClassifier("Catalog.Countries", "LocalizationCode", LocalizationCode);
EndFunction

Function GetPriceTypeByDescription(Description_en)
	Query = New Query(
	"SELECT TOP 1
	|	PriceTypes.Ref
	|FROM
	|	Catalog.PriceTypes AS PriceTypes
	|WHERE
	|	PriceTypes.Description_en = &Description_en");
	Query.SetParameter("Description_en", Description_en);
	Selection = Query.Execute().Select();
	If Selection.Next() Then
		Return Selection.Ref;
	EndIf;
	
	// Create from classifier
	Return FillingFromClassifiers.CreateCatalogItemFromClassifier("Catalog.PriceTypes", 
							"Description_en", 
							Description_en);
EndFunction

Function GetCurrencyMovementType(AttrStructure)
	QueryBuilderText =
	"SELECT TOP 1
	|	Table.Ref AS Ref,
	|	Table.DeletionMark,
	|	Table.Currency,
	|	Table.Source,
	|	Table.Type
	|FROM
	|	ChartOfCharacteristicTypes.CurrencyMovementType AS Table
	|WHERE
	|	NOT Table.DeletionMark";
	
	QueryBuilder = New QueryBuilder(QueryBuilderText);
	QueryBuilder.FillSettings();
	For Each AttrKeyAndValue In AttrStructure Do
		NewFilter = QueryBuilder.Filter.Add(AttrKeyAndValue.Key);
		NewFilter.Use = True;
		NewFilter.ComparisonType = ComparisonType.Equal;
		NewFilter.Value = AttrKeyAndValue.Value;
	EndDo;
	Query = QueryBuilder.GetQuery();

	Selection = Query.Execute().Select();
	If Selection.Next() Then
		Return Selection.Ref;
	EndIf;

	NewObject = ChartsOfCharacteristicTypes.CurrencyMovementType.CreateItem();
	FillPropertyValues(NewObject, FillingFromClassifiers.DescriptionStructure(TrimAll(LegalCurrency)));
	FillPropertyValues(NewObject, AttrStructure);
	NewObject.Write();

	Return NewObject.Ref;
EndFunction

Function GetMainStore()
	Query = New Query(
	"SELECT TOP 1
	|	Table.Ref AS Ref
	|FROM
	|	Catalog.Stores AS Table
	|WHERE
	|	NOT Table.DeletionMark
	|	AND Table.Description_en = &MainStoreDesc
	|");
	Query.SetParameter("MainStoreDesc", "Main store");
	Selection = Query.Execute().Select();
	If Selection.Next() Then
		Return Selection.Ref;
	EndIf;

	Return FillingFromClassifiers.CreateCatalogItemFromClassifier("Catalog.Stores", 
							"Description_en", 
							"Main store");
EndFunction

Function CurrencyRateIntegrationSettingsName() Export
	Return "tcmb_gov_tr (legal currency)";
EndFunction

