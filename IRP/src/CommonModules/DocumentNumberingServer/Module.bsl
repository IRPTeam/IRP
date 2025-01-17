
#Region Events

Procedure SetNewDocumentNumberBeforeWrite(Source, Cancel, WriteMode, PostingMode) Export
	
	If Source.DataExchange.Load = True Then
		Return;
	EndIf;
	
	If Constants.UseNumberingRules.Get() = False Then
		Return;
	EndIf;
	
	ContentItem = Metadata.CommonAttributes.NumeratorGroup.Content.Find(Source.Metadata());
	If ContentItem = Undefined Or ContentItem.Use <> Metadata.ObjectProperties.CommonAttributeUse.Use Then
		Return;
	EndIf;
	
	If Source.NumeratorGroup.IsEmpty() Then
		Source.NumeratorGroup = GetNumeratorGroupForDocument(Source.Metadata().FullName(), Source.Date);
	EndIf;
	If Source.NumeratorGroup.IsEmpty() Then
		Return;
	EndIf;
	
	NumberName = GetNumberNameForDocument(Source.Metadata().FullName(), Source.NumeratorGroup);
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
//  DocumentObject - DocumentObject - Document object
// 
// Returns:
//  String - Get new number
Function GetNewNumber(DocumentObject) Export
	
	If DocumentObject.NumeratorGroup.IsEmpty() Then
		Return "";
	EndIf;

	NumeratorDescription = FillNumeratorDescription(DocumentObject.NumeratorGroup);
	DocumentDescription = GetDocumentDescriptionForNumerator(DocumentObject);
	
	TemplateNumber = MakeNumber(NumeratorDescription, DocumentDescription, 0);
	
	NumberValue = CreateNewNumber(NumeratorDescription, TemplateNumber, DocumentObject.Date);
	
	Return MakeNumber(NumeratorDescription, DocumentDescription, NumberValue);

EndFunction

// Fill numerator description.
// 
// Parameters:
//  NumeratorGroup - CatalogRef.NumeratorGroups - Numerator group
// 
// Returns:
//  See DocumentNumberingClientServer.GetNumeratorDescription 
Function FillNumeratorDescription(NumeratorGroup) Export
	
	NumeratorDescription = DocumentNumberingClientServer.GetNumeratorDescription();
	
	NumeratorDescription.NumeratorGroup = NumeratorGroup.Ref;
	NumeratorDescription.NumberTemplate = NumeratorGroup.NumberTemplate;
	
	NumeratorDescription.BasicRule.Ref = NumeratorGroup.BasicRule;
	NumeratorDescription.BasicRule.UseCompanyPrefix = NumeratorGroup.BasicRule.UseCompanyPrefix;
	NumeratorDescription.BasicRule.UseBranchPrefix = NumeratorGroup.BasicRule.UseBranchPrefix;
	NumeratorDescription.BasicRule.UseDocumentPrefix = NumeratorGroup.BasicRule.UseDocumentPrefix;
	NumeratorDescription.BasicRule.UseTransactionTypePrefix = NumeratorGroup.BasicRule.UseTransactionTypePrefix;
	NumeratorDescription.BasicRule.PrefixTemplate = NumeratorGroup.BasicRule.PrefixTemplate;
	For Each PrefixRow In NumeratorGroup.BasicRule.CompanyPrefixes Do
		NumeratorDescription.BasicRule.CompanyPrefixes.Insert(PrefixRow.Company, PrefixRow.Prefix);
	EndDo;
	For Each PrefixRow In NumeratorGroup.BasicRule.BranchPrefixes Do
		NumeratorDescription.BasicRule.BranchPrefixes.Insert(PrefixRow.Branch, PrefixRow.Prefix);
	EndDo;
	For Each PrefixRow In NumeratorGroup.BasicRule.DocumentPrefixes Do
		If NumeratorDescription.BasicRule.DocumentPrefixes.Get(PrefixRow.Document) = Undefined Then
			NumeratorDescription.BasicRule.DocumentPrefixes.Insert(PrefixRow.Document, New Map);
		EndIf;
		If NumeratorGroup.BasicRule.UseTransactionTypePrefix Then
			NumeratorDescription.BasicRule.DocumentPrefixes[PrefixRow.Document].Insert(
				PrefixRow.TransactionType, PrefixRow.Prefix);
		Else
			NumeratorDescription.BasicRule.DocumentPrefixes[PrefixRow.Document].Insert(
				Undefined, PrefixRow.Prefix);
		EndIf;
	EndDo;
	
	NumeratorDescription.BeginDate = NumeratorGroup.BeginDate;
	NumeratorDescription.EndDate = NumeratorGroup.EndDate;
	NumeratorDescription.ByDefault = NumeratorGroup.ByDefault;
	
	NumeratorDescription.NumberingPeriod = NumeratorGroup.NumberingPeriod;
	NumeratorDescription.StartNumber = NumeratorGroup.StartNumber;
	NumeratorDescription.TotalLength = NumeratorGroup.TotalLength;
	NumeratorDescription.WithoutLeadingZeros = NumeratorGroup.WithoutLeadingZeros;
	
	Return NumeratorDescription;
	
EndFunction

// Get document description for numerator.
// 
// Parameters:
//  DocumentSource - DocumentObject, DocumentRef - Document source
// 
// Returns:
//  See DocumentDescriptionForNumerator
Function GetDocumentDescriptionForNumerator(DocumentSource) Export
	
	Result = DocumentDescriptionForNumerator();
	
	Result.Date = DocumentSource.Date;
	
	DocumentMetadata = DocumentSource.Ref.Metadata();
	If DocumentMetadata.Attributes.Find("Company") <> Undefined Then
		Result.Company = DocumentSource.Company;
	EndIf;
	If DocumentMetadata.Attributes.Find("TransactionType") <> Undefined Then
		Result.TransactionType = DocumentSource.TransactionType;
	EndIf;
	
	ConfigurationMetadata = CatConfigurationMetadataServer.GetConfigurationMetadataItemByFullName(DocumentMetadata.FullName());
	If ConfigurationMetadata <> Undefined Then
		Result.Document = ConfigurationMetadata;
	EndIf;
	
	BranchContent = Metadata.CommonAttributes.Branch.Content.Find(DocumentMetadata);
	If BranchContent <> Undefined And BranchContent.Use = Metadata.ObjectProperties.CommonAttributeUse.Use Then
		Result.Branch = DocumentSource.Branch;
	EndIf;
	
	Return Result;
	
EndFunction

// Get basis prefix.
// 
// Parameters:
//  NumeratorDescription - See DocumentNumberingClientServer.GetNumeratorDescription
//  DocumentDescription - See DocumentDescriptionForNumerator
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
	
	DocumentPrefix = "";
	If NumeratorDescription.BasicRule.UseDocumentPrefix Then
		DocumentData = NumeratorDescription.BasicRule.DocumentPrefixes.Get(DocumentDescription.Document);
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
	Result = StrReplace(Result, NumberPrifixType.DocumentPrefix, DocumentPrefix);
	
	Return Result;
EndFunction

// Make number.
// 
// Parameters:
//  NumeratorDescription - See DocumentNumberingClientServer.GetNumeratorDescription 
//  DocumentDescription - See DocumentDescriptionForNumerator 
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
	|	NumeratorCounters.NumeratorGroup,
	|	NumeratorCounters.TemplateNumber,
	|	NumeratorCounters.StartDate,
	|	NumeratorCounters.Counter
	|FROM
	|	InformationRegister.NumeratorCounters AS NumeratorCounters
	|WHERE
	|	NumeratorCounters.NumeratorGroup = &NumeratorGroup
	|	AND NumeratorCounters.TemplateNumber = &TemplateNumber
	|	AND NumeratorCounters.StartDate = &StartDate";
	
	Query.SetParameter("NumeratorGroup", NumeratorDescription.NumeratorGroup);
	Query.SetParameter("TemplateNumber", TemplateNumber);
	Query.SetParameter("StartDate", StartDate);
	
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		NewNumber = QuerySelection.Counter + 1; 
	EndIf;
	
	RecordMng = InformationRegisters.NumeratorCounters.CreateRecordManager();
	RecordMng.NumeratorGroup = NumeratorDescription.NumeratorGroup;
	RecordMng.TemplateNumber = TemplateNumber;
	RecordMng.StartDate = StartDate;
	RecordMng.Counter = NewNumber;
	RecordMng.Write(True);
	
	Return NewNumber;
EndFunction

// Document description for numerator.
// 
// Returns:
//  Structure - Document description for numerator:
// * Date - Date - 
// * Company - CatalogRef.Companies - 
// * Branch - CatalogRef.BusinessUnits - 
// * Document - CatalogRef.ConfigurationMetadata - 
// * TransactionType - Undefined, EnumRef - 
Function DocumentDescriptionForNumerator()
	
	Result = New Structure;
	
	Result.Insert("Date", Date(1,1,1));
	Result.Insert("Company", Catalogs.Companies.EmptyRef());
	Result.Insert("Branch", Catalogs.BusinessUnits.EmptyRef());
	Result.Insert("Document", Catalogs.ConfigurationMetadata.EmptyRef());
	Result.Insert("TransactionType", Undefined);
	
	Return Result;
	
EndFunction

#EndRegion

#Region Other

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

Function GetNumberNameForDocument(DocumentName, NumeratorGroup) Export
	
	DefaultAttribute = Metadata.CommonAttributes.DocumentNumber.Name;
	
	ConfigurationMetadata = CatConfigurationMetadataServer.GetConfigurationMetadataItemByFullName(DocumentName);
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
	|	NumeratorGroupsDocuments.Ref = &NumeratorGroup
	|	AND NumeratorGroupsDocuments.Document = &Document
	|	AND NumeratorGroupsDocuments.NumberName <> """"";
	
	Query.SetParameter("NumeratorGroup", NumeratorGroup);
	Query.SetParameter("Document", ConfigurationMetadata);
	
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		Return QuerySelection.NumberName;
	EndIf;

	Return DefaultAttribute;
	
EndFunction

#EndRegion