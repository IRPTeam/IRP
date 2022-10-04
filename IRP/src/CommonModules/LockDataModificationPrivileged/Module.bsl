// @strict-types

#Region EventSubscriptions

Procedure BeforeWrite_DocumentsLockDataModification(Source, Cancel, WriteMode, PostingMode) Export
	CheckLockData(Cancel, Source);
EndProcedure

Procedure BeforeWrite_CatalogsLockDataModification(Source, Cancel) Export
	CheckLockData(Cancel, Source);
EndProcedure

Procedure BeforeWrite_InformationRegistersLockDataModification(Source, Cancel, Replacing) Export
	CheckLockData(Cancel, Source);
EndProcedure

Procedure BeforeWrite_AccumulationRegistersLockDataModification(Source, Cancel, Replacing) Export
	CheckLockData(Cancel, Source);
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

Procedure CheckLockData(Cancel, Source)
	If Cancel OR Source.DataExchange.Load 
		OR SessionParameters.IgnoreLockModificationData 
		OR Not Constants.UseLockDataModification.Get() Then
			
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
		Return DataIsLocked_ByRef(SourceParams, Rules, AddInfo);
	ElsIf MetaNameType = "AccumulationRegister" Or MetaNameType = "InformationRegister" Then
		Return ModifyDataIsLocked_ByTable(SourceParams, Rules, AddInfo);
	Else
		Raise MetaNameType;
	EndIf;

	Return False;
EndFunction

Function ModifyDataIsLocked_ByTable(SourceParams, Rules, AddInfo = Undefined)
	ArrayOfLockedReasonsByAdvanced = New Array;

	ArrayOfLockedReasonsBySimple = ModifyDataIsLocked_ByTable_Simple(SourceParams, Rules, AddInfo);
	If ArrayOfLockedReasonsBySimple.Count() = 0 Then
		ArrayOfLockedReasonsByAdvanced = ModifyDataIsLocked_ByTable_AdvancedMode(SourceParams, Rules, AddInfo);
	EndIf;
	
	Return CalculateErrorAndShow(ArrayOfLockedReasonsBySimple, ArrayOfLockedReasonsByAdvanced);
EndFunction

Function ModifyDataIsLocked_ByTable_AdvancedMode(SourceParams, Rules, AddInfo = Undefined)
	
	Return New Array;
	
EndFunction

// Modify data is locked by table simple.
// 
// Parameters:
//  SourceParams - Structure - Fill lock data settings:
// * Source - InformationRegisterRecordSet -
// * isNew - Boolean -
// * MetadataName - String -
//  Rules - See GetRuleList
//  CheckCurrent - Boolean - Check current
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Boolean - Data is locked by ref simple mode
Function ModifyDataIsLocked_ByTable_Simple(SourceParams, Rules, AddInfo = Undefined)
	Filter = New Array;
	Fields = New Array;
	TotalFields = New Array;
	Query = New Query();
	
	FindSimpleRules = False;
	For Index = 0 To Rules.Count() - 1 Do
		If Rules[Index].LockDataModificationReasons.AdvancedMode Then
			Continue;
		EndIf;
		FindSimpleRules = True;
	EndDo;
	
	If Not FindSimpleRules Then
		Return New Array;
	EndIf;
	
	// Check new record
	Attributes = StrConcat(Rules.UnloadColumn("Attribute"), ",");
	VTTable = SourceParams.Source.Unload( , Attributes);
	VTTable.GroupBy(Attributes);
	Query.SetParameter("VTTable", VTTable);

	// Check Old record
	TemplateFilter = "Table.%1 = &%1";
	MetadataName = SourceParams.MetadataName;
	For Each FilterInSet In SourceParams.Source.Filter Do
		If Not FilterInSet.Use Then
			Continue;
		EndIf;
		Filter.Add(StrTemplate(TemplateFilter, FilterInSet.Name));
		Query.SetParameter(FilterInSet.Name, FilterInSet.Value);
	EndDo;
	For Index = 0 To Rules.Count() - 1 Do
		
		If Rules[Index].LockDataModificationReasons.AdvancedMode Then
			Continue;
		EndIf;
		FilterRow = "Table." + Rules[Index].Attribute + " " + Rules[Index].ComparisonType + " (" + "&Param" + Index + ")";
		Filter.Add(FilterRow);
		Fields.Add("MAX(CASE WHEN Table." + Rules[Index].Attribute + " " + Rules[Index].ComparisonType + " (" + "&Param" + Index + ")
			|THEN 
			|	&Reason" + Index + " 
			|END) AS Reason" + Index);
		TotalFields.Add("MAX(NT.Reason" + Index + ")");
		Query.SetParameter("Reason" + Index, Rules[Index].LockDataModificationReasons);
		Query.SetParameter("Param" + Index, Rules[Index].Value);
	EndDo;
	
	Query.Text =  
		"SELECT DISTINCT 
		|	* 
		|INTO TableCurrent
		|FROM &VTTable AS VTTable
		|
		|;
		|SELECT
		|	" + StrConcat(TotalFields, "," + Chars.LF) + " 
		|FROM (	SELECT DISTINCT 
		|		" + StrConcat(Fields, "," + Chars.LF) + " 
		|	FROM " + MetadataName	+ " AS Table 
		|	WHERE " + StrConcat(Filter, " AND ") + "
		|
		|	UNION
		|
		|	SELECT DISTINCT 
		|		" + StrConcat(Fields, "," + Chars.LF) + " 
		|	FROM TableCurrent AS Table
		|) AS NT";

	Return GetResultLockCheck(Query);
EndFunction

Function DataIsLocked_ByRef(SourceParams, Rules, AddInfo = Undefined)

	ArrayOfLockedReasonsByAdvanced = New Array;

	ArrayOfLockedReasonsBySimple = isDataIsLocked_ByRef_SimpleMode(SourceParams, Rules, AddInfo);
	If ArrayOfLockedReasonsBySimple.Count() = 0 Then
		ArrayOfLockedReasonsByAdvanced = DataIsLocked_ByRef_AdvancedMode(SourceParams, Rules, AddInfo);
	EndIf;
	
	Return CalculateErrorAndShow(ArrayOfLockedReasonsBySimple, ArrayOfLockedReasonsByAdvanced);

EndFunction

Function CalculateErrorAndShow(ArrayOfLockedReasonsBySimple, ArrayOfLockedReasonsByAdvanced)
	If ArrayOfLockedReasonsBySimple.Count() OR ArrayOfLockedReasonsByAdvanced.Count() Then
		ArrayOfLockedReasons = New Array;
		ArrayOfLockedReasons.Add(R().InfoMessage_019);		
		If ArrayOfLockedReasonsBySimple.Count() Then
			ArrayOfLockedReasons.Add(StrConcat(ArrayOfLockedReasonsBySimple, Chars.LF));
		EndIf;
		
		If ArrayOfLockedReasonsByAdvanced.Count() Then
			ArrayOfLockedReasons.Add(StrConcat(ArrayOfLockedReasonsByAdvanced, Chars.LF));
		EndIf;
		CommonFunctionsClientServer.ShowUsersMessage(StrConcat(ArrayOfLockedReasons, Chars.LF));
		Return True;
	Else
		Return False;
	EndIf;
EndFunction

// Data is locked by ref simple mode.
// 
// Parameters:
//  SourceParams - See FillLockDataSettings
//  Rules - See GetRuleList
//  CheckCurrent - Boolean - Check current
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Boolean - Data is locked by ref simple mode
Function isDataIsLocked_ByRef_SimpleMode(SourceParams, Rules, AddInfo = Undefined)
	Filter = New Array();
	Fields = New Array();
	Query = New Query();
	
	FindSimpleRules = False;
	
	For Index = 0 To Rules.Count() - 1 Do
		If Rules[Index].LockDataModificationReasons.AdvancedMode Then
			Continue;
		EndIf;
		// Check rules for new object
		Filter.Add("&SourceParam" + Index + " " + Rules[Index].ComparisonType + " (" + "&Param" + Index + ")");
		Fields.Add("CASE WHEN &SourceParam" + Index + " " + Rules[Index].ComparisonType + 
			" (" + "&Param" + Index + ")
			|THEN 
			|	&Reason" + Index + " 
			|END AS Reason" + Index);
			
		Query.SetParameter("Reason" + Index, Rules[Index].LockDataModificationReasons);
		Query.SetParameter("Param" + Index, Rules[Index].Value);
		
		If Rules[Index].ComparisonType = "IN HIERARCHY" And Rules[Index].Attribute = "Ref" Then
			Query.SetParameter("SourceParam" + Index, SourceParams.Source.Parent);
		Else
			Query.SetParameter("SourceParam" + Index, SourceParams.Source[Rules[Index].Attribute]); // Arbitrary
		EndIf;
		
		// Check rules by ref
		If Not SourceParams.isNew Then
			Filter.Add("&SourceParamCurrent" + Index + " " + Rules[Index].ComparisonType + " (" + "&ParamCurrent" + Index + ")");
			Fields.Add("CASE WHEN &SourceParamCurrent" + Index + " " + Rules[Index].ComparisonType + 
				" (" + "&ParamCurrent" + Index + ")
				|THEN 
				|	&ReasonCurrent"	+ Index + " 
				|END AS ReasonCurrent" + Index);	
			Query.SetParameter("ReasonCurrent" + Index, Rules[Index].LockDataModificationReasons);
			Query.SetParameter("ParamCurrent" + Index, Rules[Index].Value);
			
			Query.SetParameter("SourceParamCurrent" + Index, SourceParams.Source.Ref[Rules[Index].Attribute]);
		EndIf;
		FindSimpleRules = True;
	EndDo;
	
	If Not FindSimpleRules Then
		Return New Array;
	EndIf;
	
	Query.Text = "SELECT DISTINCT " + Chars.LF + StrConcat(Fields, "," + Chars.LF) + Chars.LF + "WHERE " + StrConcat(
		Filter, " OR" + Chars.LF);
	
	Return GetResultLockCheck(Query);
	
EndFunction

Function DataIsLocked_ByRef_AdvancedMode(SourceParams, Rules, AddInfo = Undefined)
	
	Query = New Query;
	TotalFields = New Array;
	Fields = New Array;
	For Index = 0 To Rules.Count() - 1 Do
		Rule = Rules[Index].LockDataModificationReasons;
		If Not Rule.AdvancedMode Then
			Continue;
		EndIf;
		
		RuleUUID = StrReplace(String(Rule.UUID()), "-", "");
		QueryPart = StrReplace(Rule.QueryFilter, "&REF_", "&REF_" + RuleUUID);
		QueryPart = StrReplace(QueryPart, "&P", "&P_" + RuleUUID + "_");
		Fields.Add(QueryPart + " AS Rule_" + RuleUUID);
		Params = SetQueryParameters(SourceParams.MetadataName, Rule);
		For Each Param In Params Do
			Query.SetParameter(StrReplace(String(Param.Key), "P", "P_" + RuleUUID + "_"), Param.Value);
		EndDo;
		Query.SetParameter("REF_" + RuleUUID, Rule);
		TotalFields.Add("MAX(NS.Rule_" + RuleUUID + ")");
	EndDo;
	
	If Not Fields.Count() Then
		Return New Array;
	EndIf;
				 
	Query.SetParameter("Ref", SourceParams.Source.Ref);
	
	VTTable = LockDataModificationReuse.GetVirtualTable(SourceParams.MetadataName);
	FillPropertyValues(VTTable.Add(), SourceParams.Source);
	Query.SetParameter("VTTable", VTTable);
	
	Query.Text =  
		"SELECT 
		|	* 
		|INTO TableCurrent
		|FROM &VTTable AS VTTable
		|
		|;
		|SELECT
		|	" + StrConcat(TotalFields, "," + Chars.LF) + " 
		|FROM (	SELECT DISTINCT 
		|		" + StrConcat(Fields, "," + Chars.LF) + " 
		|	FROM " + SourceParams.MetadataName + " AS DS 
		|	WHERE DS.Ref = &Ref
		|
		|	UNION
		|
		|	SELECT DISTINCT 
		|		" + StrConcat(Fields, "," + Chars.LF) + " 
		|	FROM TableCurrent AS DS
		|) AS NS";
	
	Return GetResultLockCheck(Query);
	
EndFunction

// Get query parameters.
// 
// Parameters:
//  MetadataName - String - Metadata name
//  Rule - CatalogRef.LockDataModificationReasons - Rule
// 
// Returns:
//  Structure - Set query parameters
Function SetQueryParameters(MetadataName, Rule)
	
	Template = LockDataModificationReuse.GetDSCTemplate(MetadataName, Rule);
	
	Params = New Structure;
	For Each Param In Template.ParameterValues Do
		Params.Insert(Param.Name, Param.Value);
	EndDo;
	Return Params;
EndFunction

Function GetResultLockCheck(Query)
	ArrayOfLockedReasons = New Array;
	
	QueryResult = Query.Execute();
	If Not QueryResult.IsEmpty() Then
		ResultTable = QueryResult.Unload();
		For Each Column In ResultTable.Columns Do
			If Not ValueIsFilled(ResultTable[0][Column.Name]) Then
				Continue;
			EndIf;
			If ArrayOfLockedReasons.Find(ResultTable[0][Column.Name]) = Undefined Then
				//@skip-check invocation-parameter-type-intersect
				ArrayOfLockedReasons.Add(ResultTable[0][Column.Name]);
			EndIf;
		EndDo;
	EndIf;
	Return ArrayOfLockedReasons
EndFunction

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