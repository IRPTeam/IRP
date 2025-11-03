
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
	
	UpdateDefault_Unit();
	
	UpdateDefault_PriceTypes();
	
	UpdateDefault_CurrencyMovementTypes();
	
	UpdateDefault_Currency();
	
	UpdateDefault_Company();
	
	UpdateDefault_Store();
	
EndProcedure

#Region Catalog_Units

Procedure UpdateDefault_Unit() Export
	
	NeedSave = False;
	ObjectUnit = Catalogs.Units.Default.GetObject();
	
	SetObjectProperty(ObjectUnit, "Quantity", 1, NeedSave);
	SetObjectDescription(ObjectUnit, "Default_001", NeedSave);
	
	SaveModifiedObject(ObjectUnit, NeedSave);
	
EndProcedure

Function GetDefault_Unit(UnitRef = Undefined) Export
	If FOServer.IsUseUnitsAndDimensions() Then
		Return UnitRef;
	EndIf;
	Return Catalogs.Units.Default;	
EndFunction

#EndRegion
	
#Region Catalog_PriceTypes

Procedure UpdateDefault_PriceTypes() Export
	
	NeedSave = False;
	ObjectPriceTypeCustomer = Catalogs.PriceTypes.Default_Customer.GetObject();
	SetObjectProperty(ObjectPriceTypeCustomer, "Assignment", Enums.PriceAssignment.Customer, NeedSave);
	SetObjectProperty(ObjectPriceTypeCustomer, "Currency", GetDefault_Currency(Undefined, True), NeedSave);
	SetObjectDescription(ObjectPriceTypeCustomer, "Default_004", NeedSave);
	SaveModifiedObject(ObjectPriceTypeCustomer, NeedSave);
	
	NeedSave = False;
	ObjectPriceTypeVendor = Catalogs.PriceTypes.Default_Vendor.GetObject();
	SetObjectProperty(ObjectPriceTypeVendor, "Assignment", Enums.PriceAssignment.Vendor, NeedSave);
	SetObjectProperty(ObjectPriceTypeVendor, "Currency", GetDefault_Currency(Undefined, True), NeedSave);
	SetObjectDescription(ObjectPriceTypeVendor, "Default_005", NeedSave);
	SaveModifiedObject(ObjectPriceTypeVendor, NeedSave);

EndProcedure

Function GetDefault_PriceType_Vendor(Value = Undefined) Export
	If FOServer.IsUsePartnerTerms() Then
		Return Value;
	EndIf;
	Return Catalogs.PriceTypes.Default_Vendor;
EndFunction

Function GetDefault_PriceType_Customer(Value = Undefined) Export
	If FOServer.IsUsePartnerTerms() Then
		Return Value;
	EndIf;
	Return Catalogs.PriceTypes.Default_Customer;
EndFunction

#EndRegion
	
#Region ChartsOfCharacteristicType_CurrencyMovementType

Procedure UpdateDefault_CurrencyMovementTypes() Export
	
	NeedSave = False;
	TypeObject = ChartsOfCharacteristicTypes.CurrencyMovementType.Default_PartnerTerm.GetObject();
	SetObjectProperty(TypeObject, "Type", Enums.CurrencyType.Agreement, NeedSave);
	SetObjectProperty(TypeObject, "Currency", GetDefault_Currency(Undefined, True), NeedSave);
	SetObjectDescription(TypeObject, "Default_006", NeedSave);
	SaveModifiedObject(TypeObject, NeedSave);
	
	NeedSave = False;
	TypeObject = ChartsOfCharacteristicTypes.CurrencyMovementType.Default_Legal.GetObject();
	SetObjectProperty(TypeObject, "Type", Enums.CurrencyType.Legal, NeedSave);
	SetObjectProperty(TypeObject, "Currency", GetDefault_Currency(Undefined, True), NeedSave);
	SetObjectDescription(TypeObject, "Default_007", NeedSave);
	SaveModifiedObject(TypeObject, NeedSave);
	
EndProcedure

Function GetDefault_CurrencyMovementType_PartnerTerm(Value = Undefined) Export
	If FOServer.IsUsePartnerTerms() Then
		Return Value;
	EndIf;
	Return ChartsOfCharacteristicTypes.CurrencyMovementType.Default_PartnerTerm;
EndFunction

Function GetDefault_CurrencyMovementType_Legal(Value = Undefined, IsUpdateDefaults = False) Export
	If FOServer.IsUseCompanies() And Not IsUpdateDefaults Then
		Return Value;
	EndIf;
	Return ChartsOfCharacteristicTypes.CurrencyMovementType.Default_Legal;
EndFunction

#EndRegion
	
#Region Catalog_Currencies
	
Procedure UpdateDefault_Currency() Export
	
	NeedSave = False;
	ObjectCurrency = Catalogs.Currencies.Default.GetObject();
	SetObjectProperty(ObjectCurrency, "Code", R().Default_009, NeedSave); // USD
	SetObjectProperty(ObjectCurrency, "Symbol", R().Default_010, NeedSave); // $
	SetObjectDescription(ObjectCurrency, "Default_008", NeedSave);
	SaveModifiedObject(ObjectCurrency, NeedSave);
	
EndProcedure

Function GetDefault_Currency(Value = Undefined, IsUpdateDefaults = False) Export
	If FOServer.IsUsePartnerTerms() And Not IsUpdateDefaults Then
		Return Value;
	EndIf;
	Return Catalogs.Currencies.Default;
EndFunction

#EndRegion

#Region Catalog_Companies

Procedure UpdateDefault_Company() Export
	
	NeedSave = False;
	ObjectCompany = Catalogs.Companies.Default.GetObject();
	SetObjectProperty(ObjectCompany, "Type", Enums.CompanyLegalType.Company, NeedSave);
	SetObjectProperty(ObjectCompany, "OurCompany", True, NeedSave);
	SetObjectDescription(ObjectCompany, "Default_011", NeedSave);
	
	LegalCMT = GetDefault_CurrencyMovementType_Legal(Undefined, True);
	If ObjectCompany.Currencies.Count() = 0 OR ObjectCompany.Currencies[0].MovementType <> LegalCMT Then
		NeedSave = True;
		ObjectCompany.Currencies.Clear();
		ObjectCompany.Currencies.Add().MovementType = LegalCMT;
	EndIf;
	
	SaveModifiedObject(ObjectCompany, NeedSave);

EndProcedure

Function GetDefault_Company(Value = Undefined, IsUpdateDefaults = False) Export
	If FOServer.IsUseCompanies() And Not IsUpdateDefaults Then
		Return Value;
	EndIf;
	Return Catalogs.Companies.Default;
EndFunction

#EndRegion

#Region Catalog_Stores

Procedure UpdateDefault_Store() Export
	
	NeedSave = False;
	ObjectStore = Catalogs.Stores.Default.GetObject();
	
	SetObjectDescription(ObjectStore, "Default_012", NeedSave);
	
	SaveModifiedObject(ObjectStore, NeedSave);

EndProcedure

Function GetDefault_Store(Value = Undefined, IsUpdateDefaults = False) Export
	If FOServer.IsUseStores() And Not IsUpdateDefaults Then
		Return Value;
	EndIf;
	Return Catalogs.Stores.Default;
EndFunction

#EndRegion

#Region Catalog_LegalName

Function CreateDefault_LegalName(Parameters, Value = Undefined) Export
	If FOServer.IsUseLegalName() Then
		Return Value;
	EndIf;
		
	Exists = GetDefault_LegalName(Parameters, Value);
	If Exists <> Undefined Then
		Return SyncDeletionMark(Exists, Parameters.Partner);
	EndIf;
	
	// creating	
	NewObject = Catalogs.Companies.CreateItem();
	FillPropertyValues(NewObject, Parameters.Partner, , "Parent, Owner, Ref, Code");
	NewObject.Partner = Parameters.Partner.Ref;
	NewObject.Type    = Enums.CompanyLegalType.Company;
	NewObject.Write();
	Return NewObject.Ref;
EndFunction

Function GetDefault_LegalName(Parameters, Value = Undefined) Export
	If FOServer.IsUseLegalName() Then
		Return Value;
	EndIf;
	Query = New Query();
	Query.Text = 
	"SELECT ALLOWED TOP 2
	|	Table.Ref AS Ref,
	|	Table.DeletionMark AS DeletionMark
	|FROM
	|	Catalog.Companies AS Table
	|WHERE
	|	Table.Partner = &Partner";
	Query.SetParameter("Partner", Parameters.Partner.Ref);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		If QuerySelection.Count() > 1 Then
			Raise StrTemplate(R().Error_FoundMoreThanOneCompany);
		EndIf;
		Return RefStructure(QuerySelection.Ref, QuerySelection.DeletionMark);
	EndIf;
	Return Undefined;
EndFunction

#EndRegion

#Region Catalog_ItemKey

Function CreateDefault_ItemKey(Parameters, Value = Undefined) Export
	If FOServer.IsUseItemKey() Then
		Return Value;
	EndIf;
	Exists = GetDefault_ItemKey(Parameters, Value);
	If Exists <> Undefined Then
		Return SyncDeletionMark(Exists, Parameters.Item);
	EndIf;
	
	// creating
	NewObject = Catalogs.ItemKeys.CreateItem();
	FillPropertyValues(NewObject, Parameters.Item, , "Parent, Owner, Ref, Unit, Code");
	NewObject.Item = Parameters.Item.Ref;
	NewObject.Write();
	Return NewObject.Ref;	
EndFunction

Function GetDefault_ItemKey(Parameters, Value = Undefined) Export
	If FOServer.IsUseItemKey() Then
		Return Value;
	EndIf;
	Query = New Query();
	Query.Text = 
	"SELECT DISTINCT TOP 2
	|	Table.Ref AS Ref,
	|	Table.DeletionMark AS DeletionMark
	|FROM
	|	Catalog.ItemKeys AS Table
	|WHERE
	|	Table.Item = &Item";
	Query.SetParameter("Item", Parameters.Item.Ref);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then 
		If QuerySelection.Count() > 1 Then
			Raise StrTemplate(R().Error_FoundMoreThanOneItemKey);
		EndIf;
		Return RefStructure(QuerySelection.Ref, QuerySelection.DeletionMark);
	EndIf;
	Return Undefined;
EndFunction

#EndRegion

#Region Catalog_Agreement

Function CreateDefault_Agreement(Parameters, Value = Undefined) Export
	If Not Parameters.AgreementTypes.Count() Then
		Return Value; // only for customer or vendor
	EndIf;
	If FOServer.IsUsePartnerTerms() Then
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
		Return SyncDeletionMark(Exists, Parameters.Partner);
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
		Raise R().DefaultAgreementOnlyCustVendor;
	EndIf;
	
	DefaultLegalNameData = GetDefault_LegalName(Parameters);
	DefaultLegalNameRef = Undefined;
	If DefaultLegalNameData <> Undefined Then
		DefaultLegalNameRef = DefaultLegalNameData.Ref;
	EndIf;
	
	NewObject = Catalogs.Agreements.CreateItem();
	SetObjectDescription(NewObject, DefaultDescriptionKey, False);
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

Function GetDefault_Agreement(Parameters, Value) Export
	If FOServer.IsUsePartnerTerms() Then
		Return Value;
	EndIf;
	Query = New Query();
	Query.Text = 
	"SELECT ALLOWED TOP 2
	|	Table.Ref AS Ref,
	|	Table.DeletionMark AS DeletionMark
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
			StrTemplate(R().FoundMoreThanOneWhenOptionNot, "Agreement", "IsUsePartnerTerms");
		EndIf;
		Return RefStructure(QuerySelection.Ref, QuerySelection.DeletionMark);
	EndIf;
	Return Undefined;
EndFunction

#EndRegion

#Region Private

// Ref structure.
// 
// Parameters:
//  Ref - CatalogRef - Ref
//  DeletionMark - Boolean - Deletion mark
// 
// Returns:
//  Structure - Ref structure:
// * Ref - CatalogRef - 
// * DeletionMark - Boolean - 
Function RefStructure(Ref, DeletionMark)
	Result = New Structure("Ref, DeletionMark", Ref, DeletionMark);
	Return Result;
EndFunction

// Sync deletion mark.
// 
// Parameters:
//  Ref - See RefStructure 
//  MainRef - CatalogRef - Main ref
// 
// Returns:
//  CatalogRef - Synchronized ref
Function SyncDeletionMark(RefStructure, MainRef)
	If RefStructure.DeletionMark = MainRef.DeletionMark Then
		Return RefStructure.Ref;
	EndIf;
	ObjectReceiver = RefStructure.Ref.GetObject();
	ObjectReceiver.DeletionMark = MainRef.DeletionMark;
	ObjectReceiver.Write();
	Return RefStructure.Ref;
EndFunction

// Set object property.
// 
// Parameters:
//  Object - CatalogObject - Object
//  PropertyName - String - Property name
//  NewValue - Arbitrary - New value
//  Modified - Boolean - Modified
Procedure SetObjectProperty(Object, PropertyName, NewValue, Modified)
	
	If Object[PropertyName] <> NewValue Then
		Object[PropertyName] = NewValue;
		Modified = True;
	EndIf;
	
EndProcedure	

// Set object description.
// 
// Parameters:
//  Object - CatalogObject - Object
//  PredefinedNameCode - String - Predefined name code
//  Modified - Boolean - Modified
Procedure SetObjectDescription(Object, PredefinedNameCode, Modified)

	For Each Lang In LocalizationReuse.AllDescription() Do
		PredefinedName = R(StrSplit(Lang, "_")[1])[PredefinedNameCode];
		SetObjectProperty(Object, Lang, PredefinedName, Modified);
	EndDo;

EndProcedure	

// Save modified object.
// 
// Parameters:
//  Object - CatalogObject - Object
//  Modified - Boolean - Modified
Procedure SaveModifiedObject(Object, Modified)
	If Modified Then
		Object.Write();
	EndIf;
EndProcedure
	
#EndRegion
