// @strict-types

#Region EventSubscriptions

Procedure BeforeWrite_DocumentsLockDataModification(Source, Cancel, WriteMode, PostingMode) Export
	If Cancel Or Source.DataExchange.Load Or Not Constants.UseLockDataModification.Get() Then
		Return;
	EndIf;
	SourceParams = FillLockDataSettings();
	SourceParams.Source = Source;
	SourceParams.isNew = Source.IsNew();
	SourceParams.MetadataName = Source.Metadata().FullName();
	If SourceIsLocked(SourceParams) Then
		Cancel = True;
	EndIf;
EndProcedure

// Before write catalogs lock data modification.
// 
// Parameters:
//  Source - CatalogObject.ExpenseAndRevenueTypes, CatalogObject.Stores, CatalogObject.FileStorageVolumes, CatalogObject.Files, CatalogObject.Taxes, CatalogObject.BankTerms, CatalogObject.CashAccounts, CatalogObject.PartnerSegments, CatalogObject.SpecialOfferTypes, CatalogObject.ItemTypes, CatalogObject.PartnersBankAccounts, CatalogObject.Specifications, CatalogObject.PrintTemplates, CatalogObject.RetailCustomers, CatalogObject.FileStoragesInfo, CatalogObject.ExternalDataProc, CatalogObject.Extensions, CatalogObject.Companies, CatalogObject.Hardware, CatalogObject.SpecialOfferRules, CatalogObject.TaxAnalytics, CatalogObject.Currencies, CatalogObject.Agreements, CatalogObject.Workstations, CatalogObject.CashStatementStatuses, CatalogObject.IntegrationSettings, CatalogObject.ItemSegments, CatalogObject.MovementRules, CatalogObject.Users, CatalogObject.AddAttributeAndPropertySets, CatalogObject.Batches, CatalogObject.PaymentTerminals, CatalogObject.Countries, CatalogObject.SerialLotNumbers, CatalogObject.Units, CatalogObject.Items, CatalogObject.LegalNameContracts, CatalogObject.AccessProfiles, CatalogObject.IDInfoSets, CatalogObject.UserGroups, CatalogObject.PlanningPeriods, CatalogObject.IDInfoAddresses, CatalogObject.BusinessUnits, CatalogObject.CurrencyMovementSets, CatalogObject.LedgerTypes, CatalogObject.TaxRates, CatalogObjectCatalogName, CatalogObject.PaymentSchedules, CatalogObject.ItemKeys, CatalogObject.PaymentTypes, CatalogObject.UnitsOfMeasurement, CatalogObject.AccessGroups, CatalogObject.LockDataModificationReasons, CatalogObject.LedgerTypeVariants, CatalogObject.SpecialOffers, CatalogObject.InterfaceGroups, CatalogObject.ReportOptions, CatalogObject.PartnerItems, CatalogObject.PriceTypes, CatalogObject.ObjectStatuses, CatalogObject.AddAttributeAndPropertyValues, CatalogObject.ChequeBonds, CatalogObject.Partners, CatalogObject.AccountingOperations, CatalogObject.CancelReturnReasons - Source
//  Cancel - Boolean - Cancel
//  WriteMode - DocumentWriteMode - Write mode
//  PostingMode - DocumentPostingMode - Posting mode
Procedure BeforeWrite_CatalogsLockDataModification(Source, Cancel, WriteMode, PostingMode) Export
	If Cancel Or Source.DataExchange.Load Or Not Constants.UseLockDataModification.Get() Then
		Return;
	EndIf;
	SourceParams = FillLockDataSettings();
	SourceParams.Source = Source;
	SourceParams.isNew = Source.IsNew();
	SourceParams.MetadataName = Source.Metadata().FullName();
	If SourceIsLocked(SourceParams) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure BeforeWrite_InformationRegistersLockDataModification(Source, Cancel, Replacing) Export
	If Cancel Or Source.DataExchange.Load Or Not Constants.UseLockDataModification.Get() Then
		Return;
	EndIf;
	SourceParams = FillLockDataSettings();
	SourceParams.Source = Source;
	SourceParams.isNew = False;
	SourceParams.MetadataName = Source.Metadata().FullName();
	If SourceIsLocked(SourceParams) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure BeforeWrite_AccumulationRegistersLockDataModification(Source, Cancel, Replacing) Export
	If Cancel Or Source.DataExchange.Load Or Not Constants.UseLockDataModification.Get() Then
		Return;
	EndIf;
	SourceParams = FillLockDataSettings();
	SourceParams.Source = Source;
	SourceParams.isNew = False;
	SourceParams.MetadataName = Source.Metadata().FullName();
	If SourceIsLocked(SourceParams) Then
		Cancel = True;
	EndIf;
EndProcedure

#EndRegion

#Region Public
// Is lock form attribute.
// 
// Parameters:
//  Ref - AnyRef - Ref
// 
// Returns:
//  Boolean - Is lock form attribute
Function IsLockFormAttribute(Ref) Export

	LockForOtherReason = Catalogs.Units.GetListLockedAttributes_LockForOtherReason(Ref);

	If LockForOtherReason Then
		Return True;
	EndIf;

	Array = New Array();
	Array.Add(Ref);
	IncludeObjects = Catalogs.Units.GetListLockedAttributes_IncludeObjects();
	ExcludeObjects = Catalogs.Units.GetListLockedAttributes_ExcludeObjects();

	VT = FindByRef(Array, , IncludeObjects, ExcludeObjects);

	VT_Count = VT.Count();
	If VT_Count = 0 Then
		Return False;
	EndIf;

	//@skip-check property-return-type
	//@skip-check invocation-parameter-type-intersect
	CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().InfoMessage_021, VT_Count));
	ShowTop = 5;
	VT.GroupBy("Metadata");
	VT.Sort("Metadata");
	For Index = 0 To ?(VT.Count() - 1 > ShowTop, ShowTop - 1, VT.Count() - 1) Do
		CommonFunctionsClientServer.ShowUsersMessage(VT[Index].Metadata);
	EndDo;
	Return True;
EndFunction

#EndRegion

#Region Privat

// Fill lock data settings.
// 
// Returns:
//  Structure - Fill lock data settings:
// * Source - DocumentObjectDocumentName, CatalogObjectCatalogName, Undefined -
// * isNew - Boolean -
// * MetadataName - String -
Function FillLockDataSettings()
	SourceParams = New Structure();
	SourceParams.Insert("Source", Undefined);
	SourceParams.Insert("isNew", True);
	SourceParams.Insert("MetadataName", "");
	Return SourceParams;
EndFunction

Function SourceIsLocked(Val SourceParams)
	Rules = CalculateRuleByObject(SourceParams);
	If Rules.Count() = 0 Then
		Return False;
	EndIf;

	Return SourceLockedByRules(SourceParams, Rules);
EndFunction

Function CalculateRuleByObject(SourceParams, AddInfo = Undefined)

	VT = GetRuleList(SourceParams);
	
	For Each Row In VT Do
		If Row.LockDataModificationReasons.AdvancedMode Then
			Continue;
		EndIf;
		Row.Attribute = StrSplit(Row.Attribute, ".")[1];
		If Row.SetValueAsCode Then
			Params = CommonFunctionsServer.GetRecalculateExpressionParams();
			Params.Expression = String(Row.Value);
			Row.Value = CommonFunctionsServer.RecalculateExpression(Params).Result;
		EndIf;
	EndDo;

	Return VT;
EndFunction

// Get rule list.
// 
// Parameters:
//  SourceParams - See FillLockDataSettings
// 
// Returns:
//  ValueTable - Get rule list:
//  * Attribute - String -
//  * ComparisonType - ComparisonType -
//  * Value - Arbitrary -
//  * LockDataModificationReasons - CatalogRef.LockDataModificationReasons -
//  * SetValueAsCode - Boolean -
Function GetRuleList(SourceParams)
	AccessGroups = UsersEvent.GetAccessGroupsByUser();

	Query = New Query();
	Query.Text =
	"SELECT DISTINCT
	|	UserList.Ref AS LockDataModificationReason
	|INTO LockDataModificationReasonVT
	|FROM
	|	Catalog.LockDataModificationReasons.UserList AS UserList
	|WHERE
	|	UserList.User = &User
	|
	|UNION ALL
	|
	|SELECT
	|	AccessGroupList.Ref
	|FROM
	|	Catalog.LockDataModificationReasons.AccessGroupList AS AccessGroupList
	|WHERE
	|	AccessGroupList.AccessGroup IN (&AccessGroup)
	|
	|UNION ALL
	|
	|SELECT
	|	LockDataModificationReasons.Ref
	|FROM
	|	Catalog.LockDataModificationReasons AS LockDataModificationReasons
	|WHERE
	|	LockDataModificationReasons.ForAllUsers
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	LockDataModificationRules.Attribute,
	|	LockDataModificationRules.ComparisonType,
	|	LockDataModificationRules.Value,
	|	LockDataModificationRules.LockDataModificationReasons,
	|	LockDataModificationRules.SetValueAsCode
	|FROM
	|	InformationRegister.LockDataModificationRules AS LockDataModificationRules
	|		INNER JOIN LockDataModificationReasonVT AS LockDataModificationReasonVT
	|		ON LockDataModificationRules.LockDataModificationReasons = LockDataModificationReasonVT.LockDataModificationReason
	|WHERE
	|	LockDataModificationRules.Type = &MetadataName
	|	AND Not LockDataModificationRules.DisableRule
	|	AND Not LockDataModificationRules.LockDataModificationReasons.DeletionMark
	|	AND Not LockDataModificationRules.LockDataModificationReasons.DisableRule";
	Query.SetParameter("AccessGroup", AccessGroups);
	Query.SetParameter("User", SessionParameters.CurrentUser);
	Query.SetParameter("MetadataName", SourceParams.MetadataName);

	QueryResult = Query.Execute().Unload();
	Return QueryResult
EndFunction

Function SourceLockedByRules(SourceParams, Rules, AddInfo = Undefined)
	MetaNameType = StrSplit(SourceParams.MetadataName, ".")[0];

	If MetaNameType = "Catalog" Or MetaNameType = "Document" Then
		Return Not SourceParams.isNew 
				And	DataIsLocked_ByRef(SourceParams, Rules, True, AddInfo) 
				Or DataIsLocked_ByRef(SourceParams, Rules, False, AddInfo);
	ElsIf MetaNameType = "AccumulationRegister" Or MetaNameType = "InformationRegister" Then
		Return Not SourceParams.isNew 
				And ModifyDataIsLocked_ByTable(SourceParams, Rules, True, AddInfo)
				Or ModifyDataIsLocked_ByTable(SourceParams, Rules, False, AddInfo);
	Else
		Raise MetaNameType;
	EndIf;

	Return False;
EndFunction

// Modify data is locked by table.
// 
// Parameters:
//  SourceParams - Structure:
//   * Source - InformationRegisterRecordSet.Barcodes
//   * isNew - Boolean -
//   * MetadataName - String -
//  Rules - Undefined, ValueTable - Rules
//  CheckCurrent - Boolean - Check current
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Boolean - Modify data is locked by table
Function ModifyDataIsLocked_ByTable(SourceParams, Rules, CheckCurrent, AddInfo = Undefined)
	Text = New Array();
	Fields = New Array();
	Query = New Query();
	If CheckCurrent Then
		TemplateFilter = "Table.%1 = &%1";
		MetadataName = SourceParams.MetadataName;
		For Each Filter In SourceParams.Source.Filter Do
			If Not Filter.Use Then
				Continue;
			EndIf;
			Text.Add(StrTemplate(TemplateFilter, Filter.Name));
			Query.SetParameter(Filter.Name, Filter.Value);
		EndDo;
	Else
		Attributes = Rules.UnloadColumn("Attribute");
		Query.TempTablesManager = New TempTablesManager();
		Query.Text = "SELECT * INTO Table From &VTTable AS VTTable";
		MetadataName = "Table";
		Query.SetParameter("VTTable", SourceParams.Source.Unload( , StrConcat(Attributes, ",")));
		Query.Execute();
	EndIf;

	For Index = 0 To Rules.Count() - 1 Do
		Text.Add("Table." + Rules[Index].Attribute + " " + Rules[Index].ComparisonType + " (" + "&Param" + Index + ")");
		Fields.Add("CASE WHEN Table." + Rules[Index].Attribute + " " + Rules[Index].ComparisonType + " (" + "&Param"
			+ Index + ")
					  |THEN 
					  |	&Reason" + Index + " 
											  |END AS Reason" + Index);
		Query.SetParameter("Reason" + Index, Rules[Index].LockDataModificationReasons);
		Query.SetParameter("Param" + Index, Rules[Index].Value);
	EndDo;
	Query.Text = "SELECT DISTINCT " + Chars.LF + StrConcat(Fields, "," + Chars.LF) + Chars.LF + " From " + MetadataName
		+ " AS Table 
		  |WHERE " + StrConcat(Text, " AND ");

	QueryResult = Query.Execute();
	If QueryResult.IsEmpty() Then
		Return False;
	EndIf;
//	Return ShowInfoAboutLock(QueryResult);
EndFunction

Function DataIsLocked_ByRef(SourceParams, Rules, CheckCurrent, AddInfo = Undefined)

	ArrayOfLockedReasons = New Array;
	
	DataIsLocked = isDataIsLocked_ByRef_SimpleMode(ArrayOfLockedReasons, SourceParams, Rules, CheckCurrent, AddInfo);
	
	If Not DataIsLocked Then
		DataIsLocked = DataIsLocked_ByRef_AdvancedMode(ArrayOfLockedReasons, SourceParams, Rules, CheckCurrent, AddInfo);
	EndIf;
	
	Return DataIsLocked;
	
EndFunction

// Data is locked by ref simple mode.
// 
// Parameters:
//  ArrayOfLockedReasons - Array of CatalogRef.LockDataModificationReasons - Array of locked reasons
//  SourceParams - See FillLockDataSettings
//  Rules - See GetRuleList
//  CheckCurrent - Boolean - Check current
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Boolean - Data is locked by ref simple mode
Function isDataIsLocked_ByRef_SimpleMode(ArrayOfLockedReasons, SourceParams, Rules, CheckCurrent, AddInfo = Undefined)
	Filter = New Array();
	Fields = New Array();
	Query = New Query();
	
	FindSimpleRules = False;
	
	For Index = 0 To Rules.Count() - 1 Do
		If Rules[Index].LockDataModificationReasons.AdvancedMode Then
			Continue;
		EndIf;
		Filter.Add("&SourceParam" + Index + " " + Rules[Index].ComparisonType + " (" + "&Param" + Index + ")");
		Fields.Add("CASE WHEN &SourceParam" + Index + " " + Rules[Index].ComparisonType + 
			" (" + "&Param" + Index + ")
			|THEN 
			|	&Reason"
			+ Index + " 
			|END AS Reason" + Index);
		Query.SetParameter("Reason" + Index, Rules[Index].LockDataModificationReasons);
		Query.SetParameter("Param" + Index, Rules[Index].Value);
		
		FindSimpleRules = True;
	EndDo;
	
	If Not FindSimpleRules Then
		Return False;
	EndIf;
	
	Query.Text = "SELECT DISTINCT " + Chars.LF + StrConcat(Fields, "," + Chars.LF) + Chars.LF + "WHERE " + StrConcat(
		Filter, " OR" + Chars.LF);

	For Index = 0 To Rules.Count() - 1 Do
		If Rules[Index].LockDataModificationReasons.AdvancedMode Then
			Continue;
		EndIf;
		If CheckCurrent Then
			SourceValue = SourceParams.Source.Ref[Rules[Index].Attribute]; // Arbitrary
		Else
			If Rules[Index].ComparisonType = "IN HIERARCHY" And Rules[Index].Attribute = "Ref" Then
				SourceValue = SourceParams.Source.Parent;
			Else
				SourceValue = SourceParams.Source[Rules[Index].Attribute]; // Arbitrary
			EndIf;
		EndIf;
		Query.SetParameter("SourceParam" + Index, SourceValue);
	EndDo;
	QueryResult = Query.Execute();
	If Not QueryResult.IsEmpty() Then
		ResultTable = QueryResult.Unload();
		//@skip-check property-return-type
		//@skip-check invocation-parameter-type-intersect
		ArrayOfLockedReasons.Add(R().InfoMessage_019);
		For Each Column In ResultTable.Columns Do
			If Not ValueIsFilled(ResultTable[0][Column.Name]) Then
				Continue;
			EndIf;
			//@skip-check invocation-parameter-type-intersect
			ArrayOfLockedReasons.Add(ResultTable[0][Column.Name]);
		EndDo;
	EndIf;
	Return ArrayOfLockedReasons.Count() > 0;
	
EndFunction

Function DataIsLocked_ByRef_AdvancedMode(ArrayOfLockedReasons, SourceParams, Rules, CheckCurrent, AddInfo = Undefined)
	For Index = 0 To Rules.Count() - 1 Do
		If Not Rules[Index].LockDataModificationReasons.AdvancedMode Then
			Continue;
		EndIf;

		Settings = Rules[Index].LockDataModificationReasons.DCS.Get(); // DataCompositionSettings
		InitDataCompositionSchemeForRef(Settings, SourceParams.MetadataName, CheckCurrent);
	EndDo;
	Return True;
EndFunction

// Init data composition scheme for ref.
// 
// Parameters:
//  Settings - DataCompositionSettings - Settings
//  MetadataName - String - Metadata name
Procedure InitDataCompositionSchemeForRef(Settings, MetadataName, CheckCurrent)
	
	DCSTemplate = Catalogs.LockDataModificationReasons.GetTemplate("DCS");
	DCSTemplate.DataSources.Clear();
	DataSources = DCSTemplate.DataSources.Add();
	DataSources.DataSourceType = "Local";
	DataSources.Name = "DataSource";
	
	Query = 
	"SELECT 
	|	DataSet.Ref AS Ref
	|FROM
	|    " + MetadataName + " AS DataSet";
	DataSet = DCSTemplate.DataSets.Add(Type("DataCompositionSchemaDataSetQuery"));
	DataSet.Query = Query;
	DataSet.Name = MetadataName;
	DataSet.DataSource = DataSources.Name;

	Composer = New DataCompositionTemplateComposer();
	Template = Composer.Execute(DCSTemplate, Settings, , , Type("DataCompositionValueCollectionTemplateGenerator"));

	Processor = New DataCompositionProcessor();
	Processor.Initialize(Template);

EndProcedure

// Save rule settings.
// 
// Parameters:
//  RuleObject  - CatalogObject.LockDataModificationReasons - Rule object
Procedure SaveRuleSettings(RuleObject) Export
	Reg = InformationRegisters.LockDataModificationRules.CreateRecordSet();
	Reg.Filter.LockDataModificationReasons.Set(RuleObject.Ref);

	For Each Row In RuleObject.RuleList Do
		NewRow = Reg.Add();
		NewRow.LockDataModificationReasons = RuleObject.Ref;
		FillPropertyValues(NewRow, Row);
		NewRow.Number = Row.LineNumber;
		If RuleObject.SetOneRuleForAllObjects Then
			FillPropertyValues(NewRow, RuleObject);
		Else
			If RuleObject.DisableRule Then
				NewRow.DisableRule = True;
			EndIf;
		EndIf;
	EndDo;
	Reg.Write();
EndProcedure

#EndRegion