// @strict-types

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
		
		For Each TargetLink In GetLinkedTargetRef(Source.Ref) Do
			UpdateLinkedObject(Source, TargetLink.Target, TargetLink.TransformationRule, ObjectTransformationSettings);
		EndDo;
	
		Rules = GetAutoRules(Source);	
		For Each Rule In Rules Do
		
			If ObjectTransformationSettings.isNew Then
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
	Wrapper = BuilderAPI.Init(Object);

	For Each AttrRule In Rule.Mapping Do
		TargetTable = ?(StrSplit(AttrRule.TargetAttribute, ".").Count() = 1, "", StrSplit(AttrRule.TargetAttribute, ".")[0]);
		SourceTable = ?(StrSplit(AttrRule.SourceAttribute, ".").Count() = 1, "", StrSplit(AttrRule.SourceAttribute, ".")[0]);
		
		// Fill headers attribute
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
	
	For Each AttrRule In Rule.Mapping Do
		TargetTable = ?(StrSplit(AttrRule.TargetAttribute, ".").Count() = 1, "", StrSplit(AttrRule.TargetAttribute, ".")[0]);
		SourceTable = ?(StrSplit(AttrRule.SourceAttribute, ".").Count() = 1, "", StrSplit(AttrRule.SourceAttribute, ".")[0]);
		
		// Fill headers attribute
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
	
	Return Object.Ref;
EndFunction

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
