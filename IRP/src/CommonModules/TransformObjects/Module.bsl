// @strict-types

#Region Settings

// Table filling priority.
// 
// Returns:
//  Array of String - Table filling priority
Function TableFillingPriority() Export
	
	Array = New Array; // Array Of String
	Array.Add("ItemList");
	Array.Add("SerialLotNumbers");
	Array.Add("SpecialOffers");
	Array.Add("SourceOfOrigins");
	
	Return Array;
	
EndFunction

// Ignore attribute on mapping.
// 
// Returns:
//  Array of String - Ignore attribute on mapping
Function IgnoreAttributeOnMapping() Export
	Array = New Array; // Array Of String
	Array.Add("Ref");
	Array.Add("PredefinedDataName");
	Array.Add("Predefined");
	Array.Add("SourceNodeID");
	Array.Add("Editor");
	Array.Add("CreateDate");
	Array.Add("ModifyDate");
	Array.Add("NotActive");
	Array.Add("Posting");
	Array.Add("DataVersion");
	Array.Add("Key");
	Array.Add("Posted");
	
	Return Array;
EndFunction

// Ignore tables on mapping.
// 
// Returns:
//  Array of String - Ignore tables on mapping
Function IgnoreTablesOnMapping() Export
	Array = New Array; // Array Of String
	Array.Add("RowIDInfo");
	
	Return Array;
EndFunction

#EndRegion

#Region Subscriptions

Procedure OnWrite_ObjectTransformation(Source, Cancel) Export
	
	If Source.DataExchange.Load Then
		Return;
	EndIf;
	
	If Not GetFunctionalOption("UseObjectTransformation") Then
		Return;
	EndIf;
	
	OnWrite(Source);
EndProcedure

Procedure BeforeWrite_DocumentObjectTransformation(Source, Cancel, WriteMode, PostingMode) Export
	If Source.DataExchange.Load Then
		Return;
	EndIf;
		
	If Not GetFunctionalOption("UseObjectTransformation") Then
		Return;
	EndIf;
	WriteSettings = WriteSettings();
	WriteSettings.Cancel = Cancel;
	WriteSettings.WriteMode = WriteMode;
	WriteSettings.PostingMode = PostingMode;
	
	BeforeWrite(Source, WriteSettings);
EndProcedure

Procedure BeforeWrite_CatalogObjectTransformation(Source, Cancel) Export
	If Source.DataExchange.Load Then
		Return;
	EndIf;
	
	If Not GetFunctionalOption("UseObjectTransformation") Then
		Return;
	EndIf;
		
	WriteSettings = WriteSettings();
	WriteSettings.Cancel = Cancel;
	
	BeforeWrite(Source, WriteSettings);
EndProcedure

// Write settings.
// 
// Returns:
//  Structure - Write settings:
// * Cancel - Boolean - 
// * WriteMode - Undefined - 
// * PostingMode - Undefined - 
Function WriteSettings();
	Str = New Structure();
	Str.Insert("Cancel", False);
	Str.Insert("WriteMode", Undefined);
	Str.Insert("PostingMode", Undefined);
	Return Str;
EndFunction

// Object transformation settings.
// 
// Parameters:
//  Source - CatalogObject, DocumentObject - Source
//  WriteSettings - See WriteSettings
// Returns:
//  Structure - Object transformation settings:
//  * isNew - Boolean - 
//  * WriteSettings - See WriteSettings
Function ObjectTransformationSettings(Source, WriteSettings) 
	Str = New Structure();
	Str.Insert("isNew", Source.IsNew());
	Str.Insert("WriteSettings", WriteSettings);
	Return Str;
EndFunction

Procedure BeforeWrite(Source, WriteSettings)
	Source.AdditionalProperties.Insert("ObjectTransformation", ObjectTransformationSettings(Source, WriteSettings));
EndProcedure

Procedure OnWrite(Source)
	
	If Not Source.AdditionalProperties.Property("ObjectTransformation") Then
		Return;
	EndIf;
	
	//@skip-check property-return-type
	ObjectTransformationSettings = Source.AdditionalProperties.ObjectTransformation; // See ObjectTransformationSettings
	BeginTransaction();
	Try
		
		LinkedTargetRef = GetLinkedTargetRef(Source.Ref);
		For Each TargetLink In LinkedTargetRef Do
			If TargetLink.TransformationRule.UpdateLinkedTarget Then
				UpdateLinkedObject(Source, TargetLink.Target, TargetLink.TransformationRule, ObjectTransformationSettings);
			EndIf;
		EndDo;
	
		Rules = GetAutoRules(Source);	
		For Each Rule In Rules Do
		
			If LinkedTargetRef.FindRows(New Structure("Source, TransformationRule", Source.Ref, Rule)).Count() = 0 Then
				LinkedRef = CreateLinkedObject(Source, Rule, ObjectTransformationSettings);
				Info = InformationRegisters.TranformedObjectsLink.CreateRecordManager();
				Info.Source = Source.Ref;
				Info.Target = LinkedRef;
				Info.TransformationRule = Rule;
				Info.Write();
			EndIf;
			
		EndDo;
		CommitTransaction();
	Except
		RollbackTransaction();
		ErrorInfo = ErrorInfo();
		Log.Write("Tranfer object", ErrorProcessing.DetailErrorDescription(ErrorInfo));
		Raise ErrorProcessing.BriefErrorDescription(ErrorInfo);
	EndTry;
EndProcedure

#EndRegion

#Region TransformObject

Procedure UpdateLinkedObject(Source, Target, Rule, OTS)

	Object = Target.GetObject(); // DocumentObjectDocumentName, CatalogObjectDocumentName
	
	//@skip-check invocation-parameter-type-intersect
	Wrapper = BuilderAPI.Init(Object, , , "ItemList");

	UpdateTargetObject(Source, Rule, Wrapper, True);
	
	WriteObject(Rule, OTS, Object, Wrapper);
	
EndProcedure

Function CreateLinkedObject(Source, Rule, OTS)

	ObjectManager = MetadataInfo.GetManager(Rule.TargetType.ObjectFullName); 
	Object = Undefined; // DocumentObjectDocumentName, CatalogObjectDocumentName
	If Rule.TargetType.Parent = Catalogs.ConfigurationMetadata.Documents Then
		//@skip-check dynamic-access-method-not-found
		Object = ObjectManager.CreateDocument(); // DocumentObjectDocumentName
		//@skip-check invocation-parameter-type-intersect
		Wrapper = BuilderAPI.Init(Object, , , "ItemList");
	ElsIf Rule.TargetType.Parent = Catalogs.ConfigurationMetadata.Catalogs Then
		//@skip-check dynamic-access-method-not-found, statement-type-change, statement-type-change
		Object = ObjectManager.CreateItem(); // CatalogObjectDocumentName
		//@skip-check invocation-parameter-type-intersect
		Wrapper = BuilderAPI.Init(Object);
	Else
		Raise "Unsupported type " + Rule.TargetType.ObjectFullName;
	EndIf;
	
	UpdateTargetObject(Source, Rule, Wrapper, False);
	
	WriteObject(Rule, OTS, Object, Wrapper);
	
	Return Object.Ref;
EndFunction

// Update target object.
// 
// Parameters:
//  Source - CatalogObject, DocumentObject - Source
//  Rule - CatalogRef.TransformationRules, Arbitrary - Rule
//  Wrapper - See BuilderAPI.Init
//  isUpdate - Boolean - Is update
Procedure UpdateTargetObject(Source, Rule, Wrapper, isUpdate)
	
	// Fill headers attribute
	For Each AttrRule In Rule.Mapping Do
		TargetTable = ?(StrSplit(AttrRule.TargetAttribute, ".").Count() = 1, "", StrSplit(AttrRule.TargetAttribute, ".")[0]);
		SourceTable = ?(StrSplit(AttrRule.SourceAttribute, ".").Count() = 1, "", StrSplit(AttrRule.SourceAttribute, ".")[0]);
		
		If TargetTable = "" Then
			If AttrRule.Copy Then
				BuilderAPI.SetProperty(Wrapper, AttrRule.TargetAttribute, Source[AttrRule.SourceAttribute]);
			ElsIf Not AttrRule.DefaultValue = Undefined Then
				BuilderAPI.SetProperty(Wrapper, AttrRule.TargetAttribute, AttrRule.DefaultValue);
			ElsIf Not IsBlankString(AttrRule.EvalTargetAttribute) Then
				BuilderAPI.SetProperty(Wrapper, AttrRule.TargetAttribute, EvalAttribute(Source, Wrapper, AttrRule.EvalTargetAttribute));
			EndIf;
		EndIf;
	EndDo;
	
	TablePriority = TableFillingPriority();
	TargetTables = Rule.Mapping.Unload(, "SortingIndex"); 
	TargetTables.GroupBy("SortingIndex");
	TargetTableList = TargetTables.UnloadColumn("SortingIndex"); // Array Of String
	// Fill Pririty tables, if exists
	For Each Table In TablePriority Do
		If IsBlankString(Table) Or StrStartsWith(Table, "0") Then
			Continue;
		EndIf;
		
		If TargetTableList.Find(Table) = Undefined Then // Table not exists
			Continue;
		EndIf;
		
		TableRules = Rule.Mapping.Unload(New Structure("SortingIndex", Table));
		
		//@skip-check variable-value-type
		For Each SourceRow In Source[Table] Do // ValueTableRow
			TableHasKey = CommonFunctionsClientServer.ObjectHasProperty(SourceRow, "Key");
			TargetRow = BuilderAPI.AddRow(Wrapper, Table, False, ?(TableHasKey, SourceRow.Key, Undefined));
			For Each AttrRule In TableRules Do
				If IsBlankString(AttrRule.TargetAttribute) Then
					Continue;
				EndIf;
				TargetAttribute = StrSplit(AttrRule.TargetAttribute, ".")[1];
				If Not IsBlankString(AttrRule.SourceAttribute) Then
					SourceAttribute = StrSplit(AttrRule.SourceAttribute, ".")[1];
				Else
					SourceAttribute = "";
				EndIf;
				
				If AttrRule.Copy Then
					BuilderAPI.SetRowProperty(Wrapper, TargetRow, TargetAttribute, SourceRow[SourceAttribute], Table);
				ElsIf Not AttrRule.DefaultValue = Undefined Then
					BuilderAPI.SetRowProperty(Wrapper, TargetRow, TargetAttribute, AttrRule.DefaultValue, Table);
				ElsIf Not IsBlankString(AttrRule.EvalTargetAttribute) Then
					BuilderAPI.SetRowProperty(Wrapper, TargetRow, TargetAttribute, EvalRowAttribute(Source, SourceRow, Wrapper, AttrRule.EvalTargetAttribute), Table);
				EndIf;
			EndDo;
		EndDo;
	EndDo;
	
	// Fill all other tables
	For Each Table In TargetTableList Do
		If IsBlankString(Table) Or StrStartsWith(Table, "0") Then
			Continue;
		EndIf;
		
		If Not TablePriority.Find(Table) = Undefined Then
			Continue;
		EndIf;
		
		TableRules = Rule.Mapping.Unload(New Structure("SortingIndex", Table));
		
		//@skip-check variable-value-type
		For Each SourceRow In Source[Table] Do // ValueTableRow
			TableHasKey = CommonFunctionsClientServer.ObjectHasProperty(SourceRow, "Key");
			TargetRow = BuilderAPI.AddRow(Wrapper, Table, , ?(TableHasKey, SourceRow.Key, Undefined));
			For Each AttrRule In TableRules Do
			
				If IsBlankString(AttrRule.TargetAttribute) Then
					Continue;
				EndIf;
				TargetAttribute = StrSplit(AttrRule.TargetAttribute, ".")[1];
				If Not IsBlankString(AttrRule.SourceAttribute) Then
					SourceAttribute = StrSplit(AttrRule.SourceAttribute, ".")[1];
				Else
					SourceAttribute = "";
				EndIf;
				
				If AttrRule.Copy Then
					BuilderAPI.SetRowProperty(Wrapper, TargetRow, TargetAttribute, SourceRow[SourceAttribute]);
				ElsIf Not AttrRule.DefaultValue = Undefined Then
					BuilderAPI.SetRowProperty(Wrapper, TargetRow, TargetAttribute, AttrRule.DefaultValue);
				ElsIf Not IsBlankString(AttrRule.EvalTargetAttribute) Then
					BuilderAPI.SetRowProperty(Wrapper, TargetRow, TargetAttribute, EvalRowAttribute(Source, SourceRow, Wrapper, AttrRule.EvalTargetAttribute));
				EndIf;
			EndDo;
		EndDo;
	EndDo;
EndProcedure

Procedure WriteObject(Rule, OTS, Object, Wrapper)
	If Rule.TargetType.Parent = Catalogs.ConfigurationMetadata.Documents Then
		BuilderAPI.Write(Wrapper, OTS.WriteSettings.WriteMode, OTS.WriteSettings.PostingMode, Object);
		Object.CheckFilling();
		Object.Write(OTS.WriteSettings.WriteMode, OTS.WriteSettings.PostingMode);
	ElsIf Rule.TargetType.Parent = Catalogs.ConfigurationMetadata.Catalogs Then
		BuilderAPI.Write(Wrapper, , , Object);
		Object.CheckFilling();
		Object.Write();
	Else
		Raise "Unsupported type " + Rule.TargetType.ObjectFullName;
	EndIf;
EndProcedure

// Eval attribute.
// 
// Parameters:
//  Source - CatalogObject, DocumentObject - Source
//  Wrapper - See BuilderAPI.Init
//  EvalTargetAttribute - String - Eval target attribute
// 
// Returns:
//  Arbitrary - Eval attribute
Function EvalAttribute(Source, Wrapper, EvalTargetAttribute)
	SetSafeMode(True);
	Return Eval(EvalTargetAttribute);
EndFunction

// Eval Row attribute.
// 
// Parameters:
//  Source - CatalogObject, DocumentObject - Source
//  SourceRow - ValueTableRow
//  Wrapper - See BuilderAPI.Init
//  EvalTargetAttribute - String - Eval target attribute
// 
// Returns:
//  Arbitrary - Eval attribute
Function EvalRowAttribute(Source, SourceRow, Wrapper, EvalTargetAttribute)
	SetSafeMode(True);
	Return Eval(EvalTargetAttribute);
EndFunction

#EndRegion

#Region Rules

// Get auto rules.
// 
// Parameters:
//  Source - CatalogObjectCatalogName, DocumentObjectDocumentName - Source
// 
// Returns:
//  Array Of CatalogRef.TransformationRules
Function GetAutoRules(Source)
	SourceMetaType = CatConfigurationMetadataServer.GetConfigurationMetadataItemByObject(Source);
	AllRules = GetRulesBySource(SourceMetaType);
	Rules = New Array; // Array Of CatalogRef.TransformationRules
	For Each Rule In AllRules Do
		If Not Rule.AutoTransform Then
			Continue;
		EndIf;
		If Not CheckIsRuleApplied(Source, Rule.SourceCondition) Then
			Continue;
		EndIf;
		Rules.Add(Rule.Ref);
	EndDo;
	Return Rules;
EndFunction

Function CheckIsRuleApplied(Source, SourceCondition)
	SetSafeMode(True);
	Return Eval(SourceCondition)
EndFunction

// Get rules by source.
// 
// Parameters:
//  SourceMetaType - CatalogRef.ConfigurationMetadata - Source meta type
// 
// Returns:
//  ValueTable - Get rules by source:
//  * Ref - CatalogRef.TransformationRules
//  * AutoTransform - Boolean
//  * SourceCondition - String
Function GetRulesBySource(SourceMetaType)
	Query = New Query;
	Query.Text =
		"SELECT
		|	TransformationRules.Ref,
		|	TransformationRules.AutoTransform,
		|	TransformationRules.SourceCondition
		|FROM
		|	Catalog.TransformationRules AS TransformationRules
		|WHERE
		|	NOT TransformationRules.DeletionMark
		|	AND TransformationRules.SourceType = &SourceType";
	
	Query.SetParameter("SourceType", SourceMetaType);
	
	Return Query.Execute().Unload();
EndFunction

// Get linked target ref.
// 
// Parameters:
//  Source - AnyRef - Source
// 
// Returns:
//  ValueTable - Get linked target ref:
//  * Source - AnyRef -
//  * Target - AnyRef -
//  * TransformationRule - CatalogRef.TransformationRules
Function GetLinkedTargetRef(Source)
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	TranformedObjectsLink.Source,
		|	TranformedObjectsLink.Target,
		|	TranformedObjectsLink.TransformationRule
		|FROM
		|	InformationRegister.TranformedObjectsLink AS TranformedObjectsLink
		|WHERE
		|	TranformedObjectsLink.Source = &Source";
	
	Query.SetParameter("Source", Source);
	
	Return Query.Execute().Unload();
EndFunction

// Get linked target ref.
// 
// Parameters:
//  Target - AnyRef - Target
// 
// Returns:
//  ValueTable - Get linked target ref:
//  * Source - AnyRef -
//  * Target - AnyRef -
//  * TransformationRule - CatalogRef.TransformationRules
Function GetLinkedSourceRef(Target)
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	TranformedObjectsLink.Source,
		|	TranformedObjectsLink.Target,
		|	TranformedObjectsLink.TransformationRule
		|FROM
		|	InformationRegister.TranformedObjectsLink AS TranformedObjectsLink
		|WHERE
		|	TranformedObjectsLink.Target = &Target";
	
	Query.SetParameter("Target", Target);
	
	Return Query.Execute().Unload();
EndFunction

#EndRegion
