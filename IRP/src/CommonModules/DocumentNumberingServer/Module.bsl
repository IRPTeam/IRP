
#Region Events

Procedure SetNewDocumentNumberBeforeWrite(Source, Cancel, WriteMode, PostingMode) Export
	
	If Source.DataExchange.Load = True Then
		Return;
	EndIf;
	
	If Constants.UseNumberingRules.Get() = False Then
		Return;
	EndIf;
	
	ContentItem = Metadata.CommonAttributes.NumeratorRules.Content.Find(Source.Metadata());
	If ContentItem = Undefined Or ContentItem.Use <> Metadata.ObjectProperties.CommonAttributeUse.Use Then
		Return;
	EndIf;
	
	If Source.NumeratorRules.IsEmpty() Then
		Source.NumeratorRules = GetNumeratorGroupForDocument(Source.Metadata().FullName(), Source.Date);
	EndIf;
	
	SetSourceNewNumber(Source);
	
EndProcedure

Procedure SetNewCatalogNumberBeforeWrite(Source, Cancel) Export
	
	If Source.DataExchange.Load = True Then
		Return;
	EndIf;
	
	If Constants.UseNumberingRules.Get() = False Then
		Return;
	EndIf;
	
	ContentItem = Metadata.CommonAttributes.NumeratorRules.Content.Find(Source.Metadata());
	If ContentItem = Undefined Or ContentItem.Use <> Metadata.ObjectProperties.CommonAttributeUse.Use Then
		Return;
	EndIf;
	
	If Source.NumeratorRules.IsEmpty() Then
		Source.NumeratorRules = GetNumeratorGroupForCatalog(Source.Metadata().FullName(), Source);
	EndIf;
	
	SetSourceNewNumber(Source);
	
EndProcedure

Procedure SetSourceNewNumber(Source) Export
	
	If Source.NumeratorRules.IsEmpty() Then
		Return;
	EndIf;
	
	NumberName = GetNumberNameByMetadata(Source.Ref.Metadata().FullName(), Source.NumeratorRules);
	If Not IsBlankString(Source[NumberName]) Then
		Return;
	EndIf;
	
	Source[NumberName] = GetNewNumber(Source);

EndProcedure
	
#EndRegion

#Region NumberTemplate

// Get new number.
// 
// Parameters:
//  SourceObject - DocumentObject, CatalogObject - Document object
// 
// Returns:
//  String - Get new number
Function GetNewNumber(SourceObject) Export
	
	If SourceObject.NumeratorRules.IsEmpty() Then
		Return "";
	EndIf;

	NumeratorDescription = FillNumeratorDescription(SourceObject.NumeratorRules);
	SourceDescription = GetSourceDescriptionForNumerator(SourceObject, NumeratorDescription);
	
	TemplateNumber = MakeNumber(NumeratorDescription, SourceDescription, 0);
	
	NumberValue = CreateNewNumber(NumeratorDescription, TemplateNumber, SourceDescription.Date);
	
	Return MakeNumber(NumeratorDescription, SourceDescription, NumberValue);

EndFunction

// Fill numerator description.
// 
// Parameters:
//  NumeratorRules - CatalogRef.NumeratorGroups - Numerator group
// 
// Returns:
//  See DocumentNumberingClientServer.GetNumeratorDescription 
Function FillNumeratorDescription(NumeratorRules) Export
	
	NumeratorDescription = DocumentNumberingClientServer.GetNumeratorDescription();
	
	NumeratorDescription.NumeratorRules = NumeratorRules.Ref;
	NumeratorDescription.NumberTemplate = NumeratorRules.NumberTemplate;
	
	NumeratorDescription.BasicRule.Ref = NumeratorRules.BasicRule;
	NumeratorDescription.BasicRule.UseCompanyPrefix = NumeratorRules.BasicRule.UseCompanyPrefix;
	NumeratorDescription.BasicRule.UseBranchPrefix = NumeratorRules.BasicRule.UseBranchPrefix;
	NumeratorDescription.BasicRule.UseDocumentPrefix = NumeratorRules.BasicRule.UseDocumentPrefix;
	NumeratorDescription.BasicRule.UseCatalogPrefix = NumeratorRules.BasicRule.UseCatalogPrefix;
	NumeratorDescription.BasicRule.UseTransactionTypePrefix = NumeratorRules.BasicRule.UseTransactionTypePrefix;
	NumeratorDescription.BasicRule.PrefixTemplate = NumeratorRules.BasicRule.PrefixTemplate;
	For Each PrefixRow In NumeratorRules.BasicRule.CompanyPrefixes Do
		NumeratorDescription.BasicRule.CompanyPrefixes.Insert(PrefixRow.Company, PrefixRow.Prefix);
	EndDo;
	For Each PrefixRow In NumeratorRules.BasicRule.BranchPrefixes Do
		NumeratorDescription.BasicRule.BranchPrefixes.Insert(PrefixRow.Branch, PrefixRow.Prefix);
	EndDo;
	For Each PrefixRow In NumeratorRules.BasicRule.CatalogPrefixes Do
		NumeratorDescription.BasicRule.CatalogPrefixes.Insert(PrefixRow.Catalog, PrefixRow.Prefix);
	EndDo;
	For Each PrefixRow In NumeratorRules.BasicRule.DocumentPrefixes Do
		If NumeratorDescription.BasicRule.DocumentPrefixes.Get(PrefixRow.Document) = Undefined Then
			NumeratorDescription.BasicRule.DocumentPrefixes.Insert(PrefixRow.Document, New Map);
		EndIf;
		If NumeratorRules.BasicRule.UseTransactionTypePrefix Then
			NumeratorDescription.BasicRule.DocumentPrefixes[PrefixRow.Document].Insert(
				PrefixRow.TransactionType, PrefixRow.Prefix);
		Else
			NumeratorDescription.BasicRule.DocumentPrefixes[PrefixRow.Document].Insert(
				Undefined, PrefixRow.Prefix);
		EndIf;
	EndDo;
	
	NumeratorDescription.BeginDate = NumeratorRules.BeginDate;
	NumeratorDescription.EndDate = NumeratorRules.EndDate;
	NumeratorDescription.ByDefault = NumeratorRules.ByDefault;
	
	NumeratorDescription.NumberingPeriod = NumeratorRules.NumberingPeriod;
	NumeratorDescription.StartNumber = NumeratorRules.StartNumber;
	NumeratorDescription.TotalLength = NumeratorRules.TotalLength;
	NumeratorDescription.WithoutLeadingZeros = NumeratorRules.WithoutLeadingZeros;
	
	For Each CatalogRow In NumeratorRules.Catalogs Do
		NumeratorDescription.CatalogDates.Insert(CatalogRow.Catalog, CatalogRow.DateName);
	EndDo;
	
	Return NumeratorDescription;
	
EndFunction

// Get source description for numerator.
// 
// Parameters:
//  SourceObject - DocumentObject, DocumentRef - Document/catalog source
//  NumeratorDescription - See DocumentNumberingClientServer.GetNumeratorDescription
// 
// Returns:
//  See SourceDescriptionForNumerator
Function GetSourceDescriptionForNumerator(SourceObject, NumeratorDescription) Export
	
	Result = SourceDescriptionForNumerator();
	
	SourceMetadata = SourceObject.Ref.Metadata();
	If SourceMetadata.Attributes.Find("Company") <> Undefined Then
		Result.Company = SourceObject.Company;
	EndIf;
	If SourceMetadata.Attributes.Find("TransactionType") <> Undefined Then
		Result.TransactionType = SourceObject.TransactionType;
	EndIf;
	
	ConfigurationMetadata = CatConfigurationMetadataServer.GetConfigurationMetadataItemByFullName(SourceMetadata.FullName());
	If ConfigurationMetadata <> Undefined Then
		Result.Source = ConfigurationMetadata;
	EndIf;
	
	BranchContent = Metadata.CommonAttributes.Branch.Content.Find(SourceMetadata);
	If BranchContent <> Undefined And BranchContent.Use = Metadata.ObjectProperties.CommonAttributeUse.Use Then
		Result.Branch = SourceObject.Branch;
	EndIf;
	
	If Metadata.Documents.Contains(SourceMetadata) Then
		Result.Date = SourceObject.Date;
	ElsIf Metadata.Catalogs.Contains(SourceMetadata) Then
		DateName = NumeratorDescription.CatalogDates.Get(Result.Source);
		If ValueIsFilled(DateName) Then
			Result.Date = SourceObject[DateName];
		EndIf;
	EndIf;
	
	Return Result;
	
EndFunction

// Get basis prefix.
// 
// Parameters:
//  NumeratorDescription - See DocumentNumberingClientServer.GetNumeratorDescription
//  DocumentDescription - See SourceDescriptionForNumerator
// 
// Returns:
//  String - Get basis prefix
Function GetBasisPrefix(NumeratorDescription, DocumentDescription) Export
	
	CompanyPrefix = "";
	If NumeratorDescription.BasicRule.UseCompanyPrefix Then
		PrefixValue = NumeratorDescription.BasicRule.CompanyPrefixes.Get(DocumentDescription.Company);
		If PrefixValue = Undefined Then
			PrefixValue = NumeratorDescription.BasicRule.CompanyPrefixes.Get(Catalogs.Companies.EmptyRef());
			If PrefixValue = Undefined Then
				PrefixValue = "";
			EndIf;
		EndIf;
		CompanyPrefix = PrefixValue;
	EndIf;
	
	BranchPrefix = "";
	If NumeratorDescription.BasicRule.UseBranchPrefix Then
		PrefixValue = NumeratorDescription.BasicRule.BranchPrefixes.Get(DocumentDescription.Branch);
		If PrefixValue = Undefined Then
			PrefixValue = NumeratorDescription.BasicRule.BranchPrefixes.Get(Catalogs.BusinessUnits.EmptyRef());
			If PrefixValue = Undefined Then
				PrefixValue = "";
			EndIf;
		EndIf;
		BranchPrefix = PrefixValue;
	EndIf;
	
	CatalogPrefix = "";
	If NumeratorDescription.BasicRule.UseCatalogPrefix Then
		PrefixValue = NumeratorDescription.BasicRule.CatalogPrefixes.Get(DocumentDescription.Source);
		If PrefixValue = Undefined Then
			PrefixValue = NumeratorDescription.BasicRule.CatalogPrefixes.Get(Catalogs.ConfigurationMetadata.EmptyRef());
			If PrefixValue = Undefined Then
				PrefixValue = "";
			EndIf;
		EndIf;
		CatalogPrefix = PrefixValue;
	EndIf;
	
	DocumentPrefix = "";
	If NumeratorDescription.BasicRule.UseDocumentPrefix Then
		DocumentData = NumeratorDescription.BasicRule.DocumentPrefixes.Get(DocumentDescription.Source);
		If DocumentData = Undefined Then
			DocumentData = NumeratorDescription.BasicRule.DocumentPrefixes.Get(Catalogs.ConfigurationMetadata.EmptyRef());
		EndIf;
		If DocumentData <> Undefined Then
			If NumeratorDescription.BasicRule.UseTransactionTypePrefix Then
				PrefixValue = DocumentData.Get(DocumentDescription.TransactionType);
				If PrefixValue = Undefined Then
					PrefixValue = DocumentData.Get(Undefined);
				EndIf;
			Else
				PrefixValue = DocumentData.Get(Undefined);
			EndIf;
			If PrefixValue = Undefined Then
				PrefixValue = "";
			EndIf;
			DocumentPrefix = PrefixValue;
		EndIf;
	EndIf;
	
	NumberPrifixType = DocumentNumberingClientServer.GetNumberPrifixType();
	
	Result = NumeratorDescription.BasicRule.PrefixTemplate;
	Result = StrReplace(Result, NumberPrifixType.CompanyPrefix, CompanyPrefix);
	Result = StrReplace(Result, NumberPrifixType.BranchPrefix, BranchPrefix);
	Result = StrReplace(Result, NumberPrifixType.CatalogPrefix, CatalogPrefix);
	Result = StrReplace(Result, NumberPrifixType.DocumentPrefix, DocumentPrefix);
	
	Return Result;
EndFunction

// Make number.
// 
// Parameters:
//  NumeratorDescription - See DocumentNumberingClientServer.GetNumeratorDescription 
//  DocumentDescription - See SourceDescriptionForNumerator 
//  NumberValue - Number - Number value
// 
// Returns:
//  String - Make number
Function MakeNumber(NumeratorDescription, DocumentDescription, NumberValue) Export
	
	Result = NumeratorDescription.NumberTemplate;
	NumberParts = DocumentNumberingClientServer.GetNumberParts();
	
	BasisPrefix = GetBasisPrefix(NumeratorDescription, DocumentDescription);
	Result = StrReplace(Result, NumberParts.Basic, BasisPrefix);
	
	YearValue2 = Format(DocumentDescription.Date, "DF=yy;");
	Result = StrReplace(Result, NumberParts.Year2, YearValue2);
	 
	YearValue4 = Format(DocumentDescription.Date, "DF=yyyy;");
	Result = StrReplace(Result, NumberParts.Year4, YearValue4);
	
	MonthValue = Month(DocumentDescription.Date);
	Result = StrReplace(Result, NumberParts.Month1, Format(MonthValue, "NZ=;"));
	Result = StrReplace(Result, NumberParts.Month2, Format(MonthValue, "ND=2; NZ=; NLZ=;"));
	
	QuarterValue = 
		?(MonthValue < 4, 1, 
			?(MonthValue < 7, 2,
				?(MonthValue < 10, 3, 4)
			)
		);
	Result = StrReplace(Result, NumberParts.Quarter, Format(QuarterValue, "NZ=;"));
	
	WeekValue = WeekOfYear(DocumentDescription.Date);
	Result = StrReplace(Result, NumberParts.Week1, Format(WeekValue, "NZ=;"));
	Result = StrReplace(Result, NumberParts.Week2, Format(WeekValue, "ND=2; NZ=; NLZ=;"));
	
	ResultWithoutNumber = StrReplace(Result, NumberParts.Number, "");
	NumberLength = NumeratorDescription.TotalLength - StrLen(ResultWithoutNumber);
	If NumberLength <= 0 Then
		Return Left(ResultWithoutNumber, NumeratorDescription.TotalLength);
	EndIf;
	
	NumberFormat = "NZ=; NG=; ND="+Format(NumberLength, "NG=;")+";";
	If Not NumeratorDescription.WithoutLeadingZeros Then
		NumberFormat = NumberFormat + " NLZ=;";
	EndIf;
	NumberString = Format(NumberValue, NumberFormat);

	Result = StrReplace(Result, NumberParts.Number, NumberString);
	
	Return Result;
EndFunction

// Create new number.
// 
// Parameters:
//  NumeratorDescription - See DocumentNumberingClientServer.GetNumeratorDescription 
//  TemplateNumber - String - Template number
//  NumberDate - Date - Number date
// 
// Returns:
//  Number - Create new number
Function CreateNewNumber(NumeratorDescription, TemplateNumber, NumberDate)
	
	NewNumber = NumeratorDescription.StartNumber;
	
	StartDate = Date(1,1,1);
	If NumeratorDescription.NumberingPeriod = Enums.NumberingPeriods.Year Then
		StartDate = BegOfYear(NumberDate); 
	ElsIf NumeratorDescription.NumberingPeriod = Enums.NumberingPeriods.Quarter Then
		StartDate = BegOfQuarter(NumberDate);
	ElsIf NumeratorDescription.NumberingPeriod = Enums.NumberingPeriods.Month Then
		StartDate = BegOfMonth(NumberDate);
	ElsIf NumeratorDescription.NumberingPeriod = Enums.NumberingPeriods.Week Then
		StartDate = BegOfWeek(NumberDate);
	EndIf;
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	NumeratorCounters.NumeratorRules,
	|	NumeratorCounters.TemplateNumber,
	|	NumeratorCounters.StartDate,
	|	NumeratorCounters.Counter
	|FROM
	|	InformationRegister.NumeratorCounters AS NumeratorCounters
	|WHERE
	|	NumeratorCounters.NumeratorRules = &NumeratorRules
	|	AND NumeratorCounters.TemplateNumber = &TemplateNumber
	|	AND NumeratorCounters.StartDate = &StartDate";
	
	Query.SetParameter("NumeratorRules", NumeratorDescription.NumeratorRules);
	Query.SetParameter("TemplateNumber", TemplateNumber);
	Query.SetParameter("StartDate", StartDate);
	
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		NewNumber = QuerySelection.Counter + 1; 
	EndIf;
	
	RecordMng = InformationRegisters.NumeratorCounters.CreateRecordManager();
	RecordMng.NumeratorRules = NumeratorDescription.NumeratorRules;
	RecordMng.TemplateNumber = TemplateNumber;
	RecordMng.StartDate = StartDate;
	RecordMng.Counter = NewNumber;
	RecordMng.Write(True);
	
	Return NewNumber;
EndFunction

// Source description for numerator.
// 
// Returns:
//  Structure - Source description for numerator:
// * Date - Date - 
// * Company - CatalogRef.Companies - 
// * Branch - CatalogRef.BusinessUnits - 
// * Source - CatalogRef.ConfigurationMetadata - 
// * TransactionType - Undefined, EnumRef - 
Function SourceDescriptionForNumerator()
	
	Result = New Structure;
	
	Result.Insert("Date", Date(1,1,1));
	Result.Insert("Company", Catalogs.Companies.EmptyRef());
	Result.Insert("Branch", Catalogs.BusinessUnits.EmptyRef());
	Result.Insert("Source", Catalogs.ConfigurationMetadata.EmptyRef());
	Result.Insert("TransactionType", Undefined);
	
	Return Result;
	
EndFunction

#EndRegion

#Region Other

// Get numerator group for catalog.
// 
// Parameters:
//  CatalogName - String - Catalog name
//  CatalogObject - CatalogObject - Catalog object
// 
// Returns:
//  CatalogRef.NumeratorGroups - Get numerator group for catalog
Function GetNumeratorGroupForCatalog(CatalogName, CatalogObject) Export
	
	ConfigurationMetadata = CatConfigurationMetadataServer.GetConfigurationMetadataItemByFullName(CatalogName);
	If ConfigurationMetadata = Undefined Then
		Return Catalogs.NumeratorGroups.EmptyRef();
	EndIf;
	
	DateDefault = "Date";
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	NumeratorGroupsCatalogs.Ref AS Ref,
	|	NumeratorGroupsCatalogs.DateName,
	|	NumeratorGroupsCatalogs.Ref.BeginDate AS BeginDate,
	|	NumeratorGroupsCatalogs.Ref.EndDate AS EndDate,
	|	NumeratorGroupsCatalogs.Ref.ByDefault AS ByDefault
	|FROM
	|	Catalog.NumeratorGroups.Catalogs AS NumeratorGroupsCatalogs
	|WHERE
	|	NumeratorGroupsCatalogs.Catalog = &Catalog
	|	AND NOT NumeratorGroupsCatalogs.Ref.DeletionMark
	|
	|ORDER BY
	|	ByDefault DESC,
	|	Ref DESC";
	
	Query.SetParameter("Catalog", ConfigurationMetadata);
	
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		DateName = ?(IsBlankString(QuerySelection.DateName), DateDefault, QuerySelection.DateName);
		DateValue = CatalogObject[DateName];
		If (QuerySelection.BeginDate = Date(1,1,1) or QuerySelection.BeginDate <= DateValue) AND 
				(QuerySelection.EndDate = Date(1,1,1) or QuerySelection.EndDate >= DateValue) Then
			Return QuerySelection.Ref;
		EndIf;
	EndDo;
	
	Return Catalogs.NumeratorGroups.EmptyRef();
	
EndFunction

// Get numerator group for document.
// 
// Parameters:
//  DocumentName - String - Document name
//  Date - Date - Date
// 
// Returns:
//  CatalogRef.NumeratorGroups - Get numerator group for document
Function GetNumeratorGroupForDocument(DocumentName, Date) Export
	
	ConfigurationMetadata = CatConfigurationMetadataServer.GetConfigurationMetadataItemByFullName(DocumentName);
	If ConfigurationMetadata = Undefined Then
		Return Catalogs.NumeratorGroups.EmptyRef();
	EndIf;
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	NumeratorGroupsDocuments.Ref AS Ref,
	|	NumeratorGroupsDocuments.Ref.ByDefault AS ByDefault
	|FROM
	|	Catalog.NumeratorGroups.Documents AS NumeratorGroupsDocuments
	|WHERE
	|	NumeratorGroupsDocuments.Document = &Document
	|	AND NOT NumeratorGroupsDocuments.Ref.DeletionMark
	|	AND (NumeratorGroupsDocuments.Ref.BeginDate >= &Date
	|	OR NumeratorGroupsDocuments.Ref.BeginDate = DATETIME(1, 1, 1))
	|	AND (NumeratorGroupsDocuments.Ref.EndDate <= &Date
	|	OR NumeratorGroupsDocuments.Ref.EndDate = DATETIME(1, 1, 1))
	|
	|ORDER BY
	|	ByDefault DESC,
	|	Ref DESC";
	
	Query.SetParameter("Date", Date);
	Query.SetParameter("Document", ConfigurationMetadata);
	
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Ref;
	EndIf;
	
	Return Catalogs.NumeratorGroups.EmptyRef();
	
EndFunction

// Get number name for document.
// 
// Parameters:
//  MetadataName - String - Metadata name
//  NumeratorRulesRef - CatalogRef.NumeratorGroups - Numerator rules ref
// 
// Returns:
//  String - Get number name for document
Function GetNumberNameByMetadata(MetadataName, NumeratorRulesRef) Export
	
	DefaultAttribute = Metadata.CommonAttributes.DocumentNumber.Name;
	
	ConfigurationMetadata = CatConfigurationMetadataServer.GetConfigurationMetadataItemByFullName(MetadataName);
	If ConfigurationMetadata = Undefined Then
		Return DefaultAttribute;
	EndIf;
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	NumeratorGroupsDocuments.NumberName
	|FROM
	|	Catalog.NumeratorGroups.Documents AS NumeratorGroupsDocuments
	|WHERE
	|	NumeratorGroupsDocuments.Ref = &NumeratorRules
	|	AND NumeratorGroupsDocuments.Document = &Metadata
	|	AND NumeratorGroupsDocuments.NumberName <> """"
	|
	|UNION ALL
	|
	|SELECT
	|	NumeratorGroupsCatalogs.NumberName
	|FROM
	|	Catalog.NumeratorGroups.Catalogs AS NumeratorGroupsCatalogs
	|WHERE
	|	NumeratorGroupsCatalogs.Ref = &NumeratorRules
	|	AND NumeratorGroupsCatalogs.Catalog = &Metadata
	|	AND NumeratorGroupsCatalogs.NumberName <> """"";
	
	Query.SetParameter("NumeratorRules", NumeratorRulesRef);
	Query.SetParameter("Metadata", ConfigurationMetadata);
	
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		Return QuerySelection.NumberName;
	EndIf;

	Return DefaultAttribute;
	
EndFunction

#EndRegion