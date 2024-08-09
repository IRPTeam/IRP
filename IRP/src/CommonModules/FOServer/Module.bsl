
#Region FunctionalOptions

Function IsUseAccounting() Export
	Return GetFunctionalOption("UseAccounting");
EndFunction

Function IsUseBankDocuments() Export
	Return GetFunctionalOption("UseBankDocuments");
EndFunction

Function IsUseItemKey() Export
	Return GetFunctionalOption("UseItemKey");
EndFunction

Function IsUsePriceByProperties() Export
	Return GetFunctionalOption("UsePriceByProperties");
EndFunction

Function IsUsePartnerTerms() Export
	Return GetFunctionalOption("UsePartnerTerms");
EndFunction

Function IsUseCompanies() Export
	Return GetFunctionalOption("UseCompanies");
EndFunction

Function IsUsePartnersHierarchy() Export
	Return GetFunctionalOption("UsePartnersHierarchy");
EndFunction

Function IsUseUnitsAndDimensions() Export
	Return GetFunctionalOption("UseUnitsAndDimensions");
EndFunction

Function IsUseStores() Export
	Return GetFunctionalOption("UseStores");
EndFunction

Function IsUseCashTransaction() Export
	Return GetFunctionalOption("UseCashTransaction");
EndFunction

Function IsUseConsolidatedRetailSales() Export
	Return GetFunctionalOption("UseConsolidatedRetailSales");
EndFunction

Function IsUseManufacturing() Export
	Return GetFunctionalOption("UseManufacturing");
EndFunction

Function IsUseWorkOrders() Export
	Return GetFunctionalOption("UseWorkOrders");
EndFunction

Function IsUseCommissionTrading() Export
	Return GetFunctionalOption("UseCommissionTrading");
EndFunction

Function IsUseRetailOrders() Export
	Return GetFunctionalOption("UseRetailOrders");
EndFunction

Function IsUseSalary() Export
	Return GetFunctionalOption("UseSalary");
EndFunction

Function IsUseRetail() Export
	Return GetFunctionalOption("UseRetail");
EndFunction

Function IsUseLockDataModification() Export
	Return GetFunctionalOption("UseLockDataModification");
EndFunction

Function IsUseAdditionalTableControlDocument() Export
	Return GetFunctionalOption("UseAdditionalTableControlDocument");
EndFunction

Function IsUseSimpleMode() Export
	Return GetFunctionalOption("UseSimpleMode");
EndFunction

Function IsUseFixedAssets() Export
	Return GetFunctionalOption("UseFixedAssets");
EndFunction

Function IsUseShipmentConfirmationAndGoodsReceipts() Export
	Return GetFunctionalOption("UseShipmentConfirmationAndGoodsReceipts");
EndFunction

Function IsUseChequeBonds() Export
	Return GetFunctionalOption("UseChequeBonds");
EndFunction

Function IsUseAccountingService() Export
	Return GetFunctionalOption("UseAccountingService");
EndFunction

#EndRegion

Procedure UpdateDefaults() Export
	BeginTransaction();
	ErrorDescription = Undefined;
	Try
		UpdateDefaultsAtTransaction();
	Except
		ErrorDescription = ErrorDescription();
	EndTry;
	
	If ErrorDescription <> Undefined Then
		RollbackTransaction();
		Raise ErrorDescription;
	Else
		CommitTransaction();
	EndIf;
EndProcedure

Procedure UpdateDefaultsAtTransaction() Export
	Strings = GetStrings();
	
#Region Catalog_Units

	ObjectUnit = Catalogs.Units.Default.GetObject();
	FillPropertyValues(ObjectUnit, GetDescriptions("Default_001", Strings)); // pcs
	ObjectUnit.Quantity = 1;
	ObjectUnit.Write();
	
#EndRegion
	
#Region Catalog_PriceTypes

	ObjectPriceTypeCustomer = Catalogs.PriceTypes.Default_Customer.GetObject();
	FillPropertyValues(ObjectPriceTypeCustomer, GetDescriptions("Default_004", Strings)); // Customer price type
	ObjectPriceTypeCustomer.Currency = GetDefault_Currency(Undefined, True);
	ObjectPriceTypeCustomer.Assignment = Enums.PriceAssignment.Customer;
	ObjectPriceTypeCustomer.Write();
	
	ObjectPriceTypeVendor = Catalogs.PriceTypes.Default_Vendor.GetObject();
	FillPropertyValues(ObjectPriceTypeVendor, GetDescriptions("Default_005", Strings)); // Vendor price type
	ObjectPriceTypeVendor.Currency = GetDefault_Currency(Undefined, True);
	ObjectPriceTypeVendor.Assignment = Enums.PriceAssignment.Vendor;
	ObjectPriceTypeVendor.Write();

#EndRegion
	
#Region ChartsOfCharacteristicType_CurrencyMovementType

	ObjectCurrencyMovementTypePartnerTerm = ChartsOfCharacteristicTypes.CurrencyMovementType.Default_PartnerTerm.GetObject();
	FillPropertyValues(ObjectCurrencyMovementTypePartnerTerm, GetDescriptions("Default_006", Strings)); // Partner term currency type 
	ObjectCurrencyMovementTypePartnerTerm.Currency = GetDefault_Currency(Undefined, True);
	ObjectCurrencyMovementTypePartnerTerm.Type = Enums.CurrencyType.Agreement;
	ObjectCurrencyMovementTypePartnerTerm.Write();
	
	ObjectCurrencyMovementTypeLegal = ChartsOfCharacteristicTypes.CurrencyMovementType.Default_Legal.GetObject();
	FillPropertyValues(ObjectCurrencyMovementTypeLegal, GetDescriptions("Default_007", Strings)); // Legal currency type
	ObjectCurrencyMovementTypeLegal.Currency = GetDefault_Currency(Undefined, True);
	ObjectCurrencyMovementTypeLegal.Type = Enums.CurrencyType.Legal;
	ObjectCurrencyMovementTypeLegal.Write();

#EndRegion
	
#Region Catalog_Currencies
	
	ObjectCurrency = Catalogs.Currencies.Default.GetObject();
	FillPropertyValues(ObjectCurrency, GetDescriptions("Default_008", Strings)); // American dollar
	ObjectCurrency.Code = R().Default_009; // USD
	ObjectCurrency.Symbol = R().Default_010; // $
	ObjectCurrency.Write();
	
#EndRegion

#Region Catalog_Companies

	ObjectCompany = Catalogs.Companies.Default.GetObject();
	FillPropertyValues(ObjectCompany, GetDescriptions("Default_011", Strings)); // My Company
	ObjectCompany.Type = Enums.CompanyLegalType.Company;
	ObjectCompany.OurCompany = True;
	ObjectCompany.Currencies.Clear();
	ObjectCompany.Currencies.Add().MovementType = GetDefault_CurrencyMovementType_Legal(Undefined, True);
	ObjectCompany.Write();

#EndRegion

#Region Catalog_Stores

	ObjectStore = Catalogs.Stores.Default.GetObject();
	FillPropertyValues(ObjectStore, GetDescriptions("Default_012", Strings)); // My Store
	ObjectStore.Write();

#EndRegion

EndProcedure

Function GetDefault_Unit(Value = Undefined) Export
	If IsUseUnitsAndDimensions() Then
		Return Value;
	EndIf;
	Return Catalogs.Units.Default;	
EndFunction

Function GetDefault_PriceType_Vendor(Value = Undefined) Export
	If IsUsePartnerTerms() Then
		Return Value;
	EndIf;
	Return Catalogs.PriceTypes.Default_Vendor;
EndFunction

Function GetDefault_PriceType_Customer(Value = Undefined) Export
	If IsUsePartnerTerms() Then
		Return Value;
	EndIf;
	Return Catalogs.PriceTypes.Default_Customer;
EndFunction

Function GetDefault_CurrencyMovementType_PartnerTerm(Value = Undefined) Export
	If IsUsePartnerTerms() Then
		Return Value;
	EndIf;
	Return ChartsOfCharacteristicTypes.CurrencyMovementType.Default_PartnerTerm;
EndFunction

Function GetDefault_CurrencyMovementType_Legal(Value = Undefined, IsUpdateDefaults = False) Export
	If IsUseCompanies() And Not IsUpdateDefaults Then
		Return Value;
	EndIf;
	Return ChartsOfCharacteristicTypes.CurrencyMovementType.Default_Legal;
EndFunction

Function GetDefault_Currency(Value = Undefined, IsUpdateDefaults = False) Export
	If IsUsePartnerTerms() And Not IsUpdateDefaults Then
		Return Value;
	EndIf;
	Return Catalogs.Currencies.Default;
EndFunction

Function GetDefault_Company(Value = Undefined, IsUpdateDefaults = False) Export
	If IsUseCompanies() And Not IsUpdateDefaults Then
		Return Value;
	EndIf;
	Return Catalogs.Companies.Default;
EndFunction

Function GetDefault_Store(Value = Undefined, IsUpdateDefaults = False) Export
	If IsUseStores() And Not IsUpdateDefaults Then
		Return Value;
	EndIf;
	Return Catalogs.Stores.Default;
EndFunction

Function GetDefault_LegalName(Parameters, Value = Undefined) Export
	If IsUseCompanies() Then
		Return Value;
	EndIf;
	Query = New Query();
	Query.Text = 
	"SELECT TOP 2
	|	Table.Ref,
	|	Table.DeletionMark
	|FROM 
	|	Catalog.Companies AS Table
	|WHERE
	|	Table.Partner = &Partner";
	Query.SetParameter("Partner", Parameters.Partner.Ref);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		If QuerySelection.Count() > 1 Then
			Raise StrTemplate("Found more than 1 [%1] when option NOT [%2]", "Companies (Legal name)", "UseCompanies");
		EndIf;
		Return New Structure("Ref, DeletionMark", QuerySelection.Ref, QuerySelection.DeletionMark);
	EndIf;
	Return Undefined;
EndFunction

Function GetDefault_ItemKey(Parameters, Value = Undefined) Export
	If IsUseItemKey() Then
		Return Value;
	EndIf;
	Query = New Query();
	Query.Text = 
	"SELECT TOP 2
	|	Table.Ref,
	|	Table.DeletionMark
	|FROM 
	|	Catalog.ItemKeys AS Table
	|WHERE
	|	Table.Item = &Item";
	Query.SetParameter("Item", Parameters.Item.Ref);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then 
		If QuerySelection.Count() > 1 Then
			Raise StrTemplate("Found more than 1 [%1] when option NOT [%2]", "ItemKey", "UseItemKey");
		EndIf;
		Return New Structure("Ref, DeletionMark", QuerySelection.Ref, QuerySelection.DeletionMark);
	EndIf;
	Return Undefined;
EndFunction

Function GetDefault_Agreement(Parameters, Value) Export
	If IsUsePartnerTerms() Then
		Return Value;
	EndIf;
	Query = New Query();
	Query.Text = 
	"SELECT TOP 2
	|	Table.Ref,
	|	Table.DeletionMark
	|FROM 
	|	Catalog.Agreements AS Table
	|WHERE
	|	Table.Partner = &Partner
	|	AND Table.Type = &AgreementType";
	Query.SetParameter("Partner", Parameters.Partner.Ref);
	Query.SetParameter("AgreementType", Parameters.AgreementType);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		If QuerySelection.Count() > 1 Then
			StrTemplate("Found more than 1 [%1] when option NOT [%2]", "Agreement", "IsUsePartnerTerms");
		EndIf;
		Return New Structure("Ref, DeletionMark", QuerySelection.Ref, QuerySelection.DeletionMark);
	EndIf;
	Return Undefined;
EndFunction

Function CreateDefault_Agreement(Parameters, Value = Undefined) Export
	If Not Parameters.AgreementTypes.Count() Then
		Return Value; // only for customer or vendor
	EndIf;
	If IsUsePartnerTerms() Then
		Return Value;
	EndIf;
	
	ArrayOfNewAgreements = New Array();
	For Each AgreementType In Parameters.AgreementTypes Do
		NewAgreement = CreateDefault_AgreementByType(Parameters.Partner, AgreementType, Value);
		ArrayOfNewAgreements.Add(NewAgreement);
	EndDo;
	Return ArrayOfNewAgreements;
EndFunction

Function CreateDefault_AgreementByType(Partner, AgreementType, Value)
	Parameters = New Structure("Partner, AgreementType", Partner, AgreementType);
	Exists = GetDefault_Agreement(Parameters, Value);
	If Exists <> Undefined Then
		Return UpdateDeletionMark(Exists, Parameters.Partner);
	EndIf;
	
	// creating
	DefaultDescriptionKey = "";
	DefaultPriceType = Undefined;
	
	If Parameters.AgreementType = Enums.AgreementTypes.Customer Then
		DefaultDescriptionKey = "Default_002";
		DefaultPriceType = GetDefault_PriceType_Customer();
	ElsIf Parameters.AgreementType = Enums.AgreementTypes.Vendor Then
		DefaultDescriptionKey = "Default_003";
		DefaultPriceType = GetDefault_PriceType_Vendor();
	Else
		Raise "Get default agreement implement only for customer or vendor";
	EndIf;
	
	DefaultLegalNameData = GetDefault_LegalName(Parameters);
	DefaultLegalNameRef = Undefined;
	If DefaultLegalNameData <> Undefined Then
		DefaultLegalNameRef = DefaultLegalNameData.Ref;
	EndIf;
	
	NewObject = Catalogs.Agreements.CreateItem();
	FillPropertyValues(NewObject, GetDescriptions(DefaultDescriptionKey));
	NewObject.Partner              = Parameters.Partner.Ref;
	NewObject.LegalName            = DefaultLegalNameRef;
	NewObject.Company              = GetDefault_Company();
	NewObject.Type                 = Parameters.AgreementType;
	NewObject.Kind                 = Enums.AgreementKinds.Regular;
	NewObject.ApArPostingDetail    = Enums.ApArPostingDetail.ByAgreements;
	NewObject.PriceType            = DefaultPriceType;
	NewObject.Store                = GetDefault_Store();
	NewObject.CurrencyMovementType = GetDefault_CurrencyMovementType_PartnerTerm();
	NewObject.Write();
	Return NewObject.Ref;
EndFunction	

Function CreateDefault_LegalName(Parameters, Value = Undefined) Export
	If IsUseCompanies() Then
		Return Value;
	EndIf;
		
	Exists = GetDefault_LegalName(Parameters, Value);
	If Exists <> Undefined Then
		Return UpdateDeletionMark(Exists, Parameters.Partner);
	EndIf;
	
	// creating	
	NewObject = Catalogs.Companies.CreateItem();
	FillPropertyValues(NewObject, Parameters.Partner, , "Parent, Owner, Ref, Code");
	NewObject.Partner = Parameters.Partner.Ref;
	NewObject.Type    = Enums.CompanyLegalType.Company;
	NewObject.Write();
	Return NewObject.Ref;
EndFunction

Function CreateDefault_ItemKey(Parameters, Value = Undefined) Export
	If IsUseItemKey() Then
		Return Value;
	EndIf;
	Exists = GetDefault_ItemKey(Parameters, Value);
	If Exists <> Undefined Then
		Return UpdateDeletionMark(Exists, Parameters.Item);
	EndIf;
	
	// creating
	NewObject = Catalogs.ItemKeys.CreateItem();
	FillPropertyValues(NewObject, Parameters.Item, , "Parent, Owner, Ref, Unit, Code");
	NewObject.Item = Parameters.Item.Ref;
	NewObject.Write();
	Return NewObject.Ref;	
EndFunction

Function UpdateDeletionMark(Receiver, Source)
	If Receiver.DeletionMark = Source.DeletionMark Then
		Return Receiver.Ref;
	EndIf;
	ObjectReceiver = Receiver.Ref.GetObject();
	ObjectReceiver.DeletionMark = Source.DeletionMark;
	ObjectReceiver.Write();
	Return ObjectReceiver.Ref;
EndFunction

Function GetStrings()
	Strings = New Structure();
	Strings.Insert("en", Localization.Strings("en"));
	Strings.Insert("ru", Localization.Strings("ru"));
	Strings.Insert("tr", Localization.Strings("tr"));
	Return Strings;
EndFunction

Function GetDescriptions(DescriptionKey, Strings = Undefined)
	If Strings = Undefined Then
		Strings = GetStrings();
	EndIf;
	Descriptions = New Structure();
	Descriptions.Insert("Description_en");
	Descriptions.Insert("Description_ru");
	Descriptions.Insert("Description_tr");
	
	For Each Desc In Descriptions Do
		Lang = StrReplace(Desc.Key, "Description_", "");
		Descriptions[Desc.Key] = Strings[Lang][DescriptionKey];
	EndDo;
	Return Descriptions;
EndFunction

