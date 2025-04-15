// @strict-types

#Region Settings

// Returns priority order for table filling during transformation process.
// 
// Returns:
//  Array of String - Ordered list of table names to be processed first
Function TableFillingPriority() Export
	
	Result = New Array; // Array Of String
	Result.Add("ItemList");
	Result.Add("SerialLotNumbers");
	Result.Add("SpecialOffers");
	Result.Add("SourceOfOrigins");
	
	Return Result;
	
EndFunction

// Returns list of attributes to be ignored during object mapping.
// 
// Returns:
//  Array of String - List of attribute names to ignore
Function IgnoreAttributeOnMapping() Export
	Result = New Array; // Array Of String
	Result.Add("Ref");
	Result.Add("PredefinedDataName");
	Result.Add("Predefined");
	Result.Add("SourceNodeID");
	Result.Add("Editor");
	Result.Add("CreateDate");
	Result.Add("ModifyDate");
	Result.Add("NotActive");
	Result.Add("Posting");
	Result.Add("DataVersion");
	Result.Add("Key");
	Result.Add("Posted");
	
	Return Result;
EndFunction

// Returns list of tables to be ignored during object mapping.
// 
// Returns:
//  Array of String - List of table names to ignore
Function IgnoreTablesOnMapping() Export
	Result = New Array; // Array Of String
	Result.Add("RowIDInfo");
	
	Return Result;
EndFunction

#EndRegion

#Region Subscriptions

// Handler for OnWrite event of objects that support transformation.
// 
// Parameters:
//  Source - CatalogObject, DocumentObject - Object being written
//  Cancel - Boolean - Cancel flag
Procedure OnWrite_ObjectTransformation(Source, Cancel) Export
	
	If Source.DataExchange.Load Then
		Return;
	EndIf;
	
	If Not GetFunctionalOption("UseObjectTransformation") Then
		Return;
	EndIf;
	
	ProcessObjectTransformation(Source);
EndProcedure

// Handler for BeforeWrite event of documents that support transformation.
// 
// Parameters:
//  Source - DocumentObject - Document being written
//  Cancel - Boolean - Cancel flag
//  WriteMode - DocumentWriteMode - Mode of document writing
//  PostingMode - DocumentPostingMode - Mode of document posting
Procedure BeforeWrite_DocumentObjectTransformation(Source, Cancel, WriteMode, PostingMode) Export
	If Source.DataExchange.Load Then
		Return;
	EndIf;
		
	If Not GetFunctionalOption("UseObjectTransformation") Then
		Return;
	EndIf;
	
	Settings = CreateWriteSettings();
	Settings.Cancel = Cancel;
	Settings.WriteMode = WriteMode;
	Settings.PostingMode = PostingMode;
	
	PrepareForTransformation(Source, Settings);
EndProcedure

// Handler for BeforeWrite event of catalogs that support transformation.
// 
// Parameters:
//  Source - CatalogObject - Catalog being written
//  Cancel - Boolean - Cancel flag
Procedure BeforeWrite_CatalogObjectTransformation(Source, Cancel) Export
	If Source.DataExchange.Load Then
		Return;
	EndIf;
	
	If Not GetFunctionalOption("UseObjectTransformation") Then
		Return;
	EndIf;
		
	Settings = CreateWriteSettings();
	Settings.Cancel = Cancel;
	
	PrepareForTransformation(Source, Settings);
EndProcedure

// Creates structure with write settings.
// 
// Returns:
//  Structure - Write settings with the following properties:
// * Cancel - Boolean - Flag to cancel the write operation
// * WriteMode - Undefined, DocumentWriteMode - Write mode for documents
// * PostingMode - Undefined, DocumentPostingMode - Posting mode for documents
Function CreateWriteSettings()
	Result = New Structure();
	Result.Insert("Cancel", False);
	Result.Insert("WriteMode", Undefined);
	Result.Insert("PostingMode", Undefined);
	Return Result;
EndFunction

// Creates structure with object transformation settings.
// 
// Parameters:
//  Source - CatalogObject, DocumentObject - Source object
//  WriteSettings - See CreateWriteSettings
// 
// Returns:
//  Structure - Object transformation settings with properties:
//  * IsNew - Boolean - Flag indicating if the object is new
//  * WriteSettings - See CreateWriteSettings
Function CreateTransformationSettings(Source, WriteSettings) 
	Result = New Structure();
	Result.Insert("IsNew", Source.IsNew());
	Result.Insert("WriteSettings", WriteSettings);
	Return Result;
EndFunction

// Prepares object for transformation by storing settings in additional properties.
// 
// Parameters:
//  Source - CatalogObject, DocumentObject - Source object
//  WriteSettings - See CreateWriteSettings
Procedure PrepareForTransformation(Source, WriteSettings)
	Source.AdditionalProperties.Insert("ObjectTransformation", 
		CreateTransformationSettings(Source, WriteSettings));
EndProcedure

// Main procedure to process object transformation.
// 
// Parameters:
//  Source - CatalogObject, DocumentObject - Source object
Procedure ProcessObjectTransformation(Source)
	
	If Not Source.AdditionalProperties.Property("ObjectTransformation") Then
		Return;
	EndIf;
	
	//@skip-check property-return-type
	TransformationSettings = Source.AdditionalProperties.ObjectTransformation; // See CreateTransformationSettings
	
	BeginTransaction();
	Try
		// Update existing linked objects first
		ProcessExistingLinks(Source, TransformationSettings);
		
		// Create new linked objects based on auto-rules
		ProcessAutoRules(Source, TransformationSettings);
		
		CommitTransaction();
	Except
		RollbackTransaction();
		LogError("Object transformation error", ErrorInfo());
		Raise ErrorProcessing.BriefErrorDescription(ErrorInfo());
	EndTry;
EndProcedure

// Processes existing linked objects for the given source.
// 
// Parameters:
//  Source - CatalogObject, DocumentObject - Source object
//  TransformationSettings - See CreateTransformationSettings
Procedure ProcessExistingLinks(Source, TransformationSettings)
	LinkedTargetRefs = GetLinkedTargetRef(Source.Ref);
	
	For Each TargetLink In LinkedTargetRefs Do
		If TargetLink.TransformationRule.UpdateLinkedTarget Then
			UpdateLinkedObject(
				Source, 
				TargetLink.Target, 
				TargetLink.TransformationRule, 
				TransformationSettings
			);
		EndIf;
	EndDo;
EndProcedure

// Processes automatic transformation rules for the given source.
// 
// Parameters:
//  Source - CatalogObject, DocumentObject - Source object
//  TransformationSettings - See CreateTransformationSettings
Procedure ProcessAutoRules(Source, TransformationSettings)
	Rules = GetAutoRules(Source);
	LinkedTargetRefs = GetLinkedTargetRef(Source.Ref);
	
	For Each Rule In Rules Do
		If LinkedTargetRefs.FindRows(New Structure("Source, TransformationRule", Source.Ref, Rule)).Count() = 0 Then
			// No existing link found, create new linked object
			LinkedRef = CreateLinkedObject(Source, Rule, TransformationSettings);
			
			// Register the link
			RegisterObjectLink(Source.Ref, LinkedRef, Rule);
		EndIf;
	EndDo;
EndProcedure

// Registers a link between source and target objects.
// 
// Parameters:
//  SourceRef - AnyRef - Reference to source object
//  TargetRef - AnyRef - Reference to target object
//  Rule - CatalogRef.TransformationRules - Transformation rule used
Procedure RegisterObjectLink(SourceRef, TargetRef, Rule)
	LinkRecord = InformationRegisters.TranformedObjectsLink.CreateRecordManager();
	LinkRecord.Source = SourceRef;
	LinkRecord.Target = TargetRef;
	LinkRecord.TransformationRule = Rule;
	LinkRecord.Write();
EndProcedure

#EndRegion

#Region TransformObject

// Updates existing linked object according to transformation rule.
// 
// Parameters:
//  Source - CatalogObject, DocumentObject - Source object
//  Target - AnyRef - Reference to target object
//  Rule - CatalogRef.TransformationRules - Transformation rule
//  TransformationSettings - See CreateTransformationSettings
Procedure UpdateLinkedObject(Source, Target, Rule, TransformationSettings)
	Object = Target.GetObject(); // DocumentObjectDocumentName, CatalogObjectDocumentName
	
	If Rule.TargetType.Parent = Catalogs.ConfigurationMetadata.Documents Then
		//@skip-check invocation-parameter-type-intersect
		Wrapper = BuilderAPI.Init(Object, , , "ItemList");
	ElsIf Rule.TargetType.Parent = Catalogs.ConfigurationMetadata.Catalogs Then
		//@skip-check invocation-parameter-type-intersect
		Wrapper = BuilderAPI.Init(Object);
	Else
		Raise "Unsupported type " + Rule.TargetType.ObjectFullName;
	EndIf;

	UpdateTargetObject(Source, Rule, Wrapper, True);
	
	WriteTransformedObject(Rule, TransformationSettings, Object, Wrapper);
EndProcedure

// Creates new linked object according to transformation rule.
// 
// Parameters:
//  Source - CatalogObject, DocumentObject - Source object
//  Rule - CatalogRef.TransformationRules - Transformation rule
//  TransformationSettings - See CreateTransformationSettings
// 
// Returns:
//  AnyRef - Reference to created object
Function CreateLinkedObject(Source, Rule, TransformationSettings)
	ObjectManager = MetadataInfo.GetManager(Rule.TargetType.ObjectFullName);
	Object = Undefined; // DocumentObjectDocumentName, CatalogObjectDocumentName
	Wrapper = Undefined;
	
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
	
	WriteTransformedObject(Rule, TransformationSettings, Object, Wrapper);
	
	Return Object.Ref;
EndFunction

// Updates target object based on source object and transformation rule.
// 
// Parameters:
//  Source - CatalogObject, DocumentObject - Source object
//  Rule - CatalogRef.TransformationRules - Transformation rule
//  Wrapper - See BuilderAPI.Init
//  IsUpdate - Boolean - True if updating existing object, False if creating new
Procedure UpdateTargetObject(Source, Rule, Wrapper, IsUpdate)
	
	// Process header attributes first
	FillHeaderAttributes(Source, Rule, Wrapper);
	
	// Process tabular sections in priority order
	TablePriority = TableFillingPriority();
	FillPriorityTables(Source, Rule, Wrapper, TablePriority);
	
	// Process remaining tables
	FillRemainingTables(Source, Rule, Wrapper, TablePriority);
EndProcedure

// Fills tabular sections in priority order.
// 
// Parameters:
//  Source - CatalogObject, DocumentObject - Source object
//  Rule - CatalogRef.TransformationRules - Transformation rule
//  Wrapper - See BuilderAPI.Init
//  TablePriority - Array - Priority order for tables
Procedure FillPriorityTables(Source, Rule, Wrapper, TablePriority)
	TargetTables = GetTargetTables(Rule);
	TargetTableList = TargetTables.UnloadColumn("SortingIndex"); // Array Of String
	
	For Each TableName In TablePriority Do
		If IsBlankString(TableName) Or StrStartsWith(TableName, "0") Then
			Continue;
		EndIf;
		
		If TargetTableList.Find(TableName) = Undefined Then // Table not exists
			Continue;
		EndIf;
		
		FillTableRows(Source, Rule, Wrapper, TableName);
	EndDo;
EndProcedure

// Fills remaining tabular sections.
// 
// Parameters:
//  Source - CatalogObject, DocumentObject - Source object
//  Rule - CatalogRef.TransformationRules - Transformation rule
//  Wrapper - See BuilderAPI.Init
//  TablePriority - Array - Priority order for tables
Procedure FillRemainingTables(Source, Rule, Wrapper, TablePriority)
	TargetTables = GetTargetTables(Rule);
	TargetTableList = TargetTables.UnloadColumn("SortingIndex"); // Array Of String
	
	For Each TableName In TargetTableList Do
		If IsBlankString(TableName) Or StrStartsWith(TableName, "0") Then
			Continue;
		EndIf;
		
		If Not TablePriority.Find(TableName) = Undefined Then
			Continue; // Already processed in priority order
		EndIf;
		
		FillTableRows(Source, Rule, Wrapper, TableName);
	EndDo;
EndProcedure

// Returns target tables from transformation rule.
// 
// Parameters:
//  Rule - CatalogRef.TransformationRules - Transformation rule
// 
// Returns:
//  ValueTable - Table with SortingIndex column
Function GetTargetTables(Rule)
	TargetTables = Rule.Mapping.Unload(, "SortingIndex");
	TargetTables.GroupBy("SortingIndex");
	Return TargetTables;
EndFunction

// Fills rows in a tabular section.
// 
// Parameters:
//  Source - CatalogObject, DocumentObject - Source object
//  Rule - CatalogRef.TransformationRules - Transformation rule
//  Wrapper - See BuilderAPI.Init
//  TableName - String - Name of the table to fill
Procedure FillTableRows(Source, Rule, Wrapper, TableName)
	TableRules = Rule.Mapping.Unload(New Structure("SortingIndex", TableName));
	
	//@skip-check variable-value-type
	For Each SourceRow In Source[TableName] Do // ValueTableRow
		TableHasKey = CommonFunctionsClientServer.ObjectHasProperty(SourceRow, "Key");
		TargetRow = BuilderAPI.AddRow(Wrapper, TableName, False, ?(TableHasKey, SourceRow.Key, Undefined));
		
		FillTableRowAttributes(Source, SourceRow, Rule, Wrapper, TargetRow, TableName, TableRules);
	EndDo;
EndProcedure

// Writes transformed object to database.
// 
// Parameters:
//  Rule - CatalogRef.TransformationRules - Transformation rule
//  TransformationSettings - See CreateTransformationSettings
//  Object - CatalogObject, DocumentObject - Object to write
//  Wrapper - See BuilderAPI.Init
Procedure WriteTransformedObject(Rule, TransformationSettings, Object, Wrapper)
	If Rule.TargetType.Parent = Catalogs.ConfigurationMetadata.Documents Then
		BuilderAPI.Write(Wrapper, 
			TransformationSettings.WriteSettings.WriteMode, 
			TransformationSettings.WriteSettings.PostingMode, 
			Object);
		
		Object.CheckFilling();
		Object.Write(
			TransformationSettings.WriteSettings.WriteMode, 
			TransformationSettings.WriteSettings.PostingMode);
	ElsIf Rule.TargetType.Parent = Catalogs.ConfigurationMetadata.Catalogs Then
		BuilderAPI.Write(Wrapper, , , Object);
		
		Object.CheckFilling();
		Object.Write();
	Else
		Raise "Unsupported type " + Rule.TargetType.ObjectFullName;
	EndIf;
EndProcedure

// Evaluates expression for header attribute.
// 
// Parameters:
//  Source - CatalogObject, DocumentObject - Source object
//  Wrapper - See BuilderAPI.Init
//  Expression - String - Expression to evaluate
// 
// Returns:
//  Arbitrary - Result of evaluation
Function EvaluateExpression(Source, Wrapper, Expression)
	SetSafeMode(True);
	Return Eval(Expression);
EndFunction

// Evaluates expression for table row attribute.
// 
// Parameters:
//  Source - CatalogObject, DocumentObject - Source object
//  SourceRow - ValueTableRow - Source row
//  Wrapper - See BuilderAPI.Init
//  Expression - String - Expression to evaluate
// 
// Returns:
//  Arbitrary - Result of evaluation
Function EvaluateRowExpression(Source, SourceRow, Wrapper, Expression)
	SetSafeMode(True);
	Return Eval(Expression);
EndFunction


// Fills header attributes of target object.
// 
// Parameters:
//  Source - CatalogObject, DocumentObject - Source object
//  Rule - CatalogRef.TransformationRules - Transformation rule
//  Wrapper - See BuilderAPI.Init
Procedure FillHeaderAttributes(Source, Rule, Wrapper)
	For Each AttrRule In Rule.Mapping Do
		TargetTable = ?(StrSplit(AttrRule.TargetAttribute, ".").Count() = 1, "", StrSplit(AttrRule.TargetAttribute, ".")[0]);
		SourceTable = ?(StrSplit(AttrRule.SourceAttribute, ".").Count() = 1, "", StrSplit(AttrRule.SourceAttribute, ".")[0]);
		
		If TargetTable = "" Then
			If AttrRule.Copy Then
				BuilderAPI.SetProperty(Wrapper, AttrRule.TargetAttribute, Source[AttrRule.SourceAttribute]);
			ElsIf Not AttrRule.DefaultValue = Undefined Then
				BuilderAPI.SetProperty(Wrapper, AttrRule.TargetAttribute, AttrRule.DefaultValue);
			ElsIf Not IsBlankString(AttrRule.EvalTargetAttribute) Then
				BuilderAPI.SetProperty(Wrapper, AttrRule.TargetAttribute, 
					EvaluateExpression(Source, Wrapper, AttrRule.EvalTargetAttribute));
			ElsIf Not AttrRule.LinkedByRule.IsEmpty() Then		
				//@skip-check invocation-parameter-type-intersect, bsl-legacy-check-static-feature-access
				LinkedTarget = GetLinkedTargetRefByRule(Source[AttrRule.SourceAttribute], AttrRule.LinkedByRule);
				If Not LinkedTarget = Undefined Then
					BuilderAPI.SetProperty(Wrapper, AttrRule.TargetAttribute, LinkedTarget);
				EndIf;
			EndIf;
		EndIf;
	EndDo;
EndProcedure

// Fills attributes for a row in a tabular section.
// 
// Parameters:
//  Source - CatalogObject, DocumentObject - Source object
//  SourceRow - ValueTableRow - Source row
//  Rule - CatalogRef.TransformationRules - Transformation rule
//  Wrapper - See BuilderAPI.Init
//  TargetRow - ValueTableRow - Target row
//  TableName - String - Name of the table
//  TableRules - ValueTable - Rules for the table
Procedure FillTableRowAttributes(Source, SourceRow, Rule, Wrapper, TargetRow, TableName, TableRules)
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
			BuilderAPI.SetRowProperty(Wrapper, TargetRow, TargetAttribute, SourceRow[SourceAttribute], TableName);
		ElsIf Not AttrRule.DefaultValue = Undefined Then
			BuilderAPI.SetRowProperty(Wrapper, TargetRow, TargetAttribute, AttrRule.DefaultValue, TableName);
		ElsIf Not IsBlankString(AttrRule.EvalTargetAttribute) Then
			BuilderAPI.SetRowProperty(Wrapper, TargetRow, TargetAttribute, 
				EvaluateRowExpression(Source, SourceRow, Wrapper, AttrRule.EvalTargetAttribute), TableName);
		ElsIf Not AttrRule.LinkedByRule.IsEmpty() Then		
			//@skip-check invocation-parameter-type-intersect, bsl-legacy-check-static-feature-access
			LinkedTarget = GetLinkedTargetRefByRule(SourceRow[AttrRule.SourceAttribute], AttrRule.LinkedByRule);
			If Not LinkedTarget = Undefined Then
				BuilderAPI.SetRowProperty(Wrapper, TargetRow, AttrRule.TargetAttribute, LinkedTarget, TableName);
			EndIf;
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region Rules

// Gets automatic transformation rules applicable to the source object.
// 
// Parameters:
//  Source - CatalogObject, DocumentObject - Source object
// 
// Returns:
//  Array of CatalogRef.TransformationRules - Applicable rules
Function GetAutoRules(Source)
	SourceMetaType = CatConfigurationMetadataServer.GetConfigurationMetadataItemByObject(Source);
	AllRules = GetRulesBySource(SourceMetaType);
	Result = New Array; // Array Of CatalogRef.TransformationRules
	
	For Each Rule In AllRules Do
		If Not Rule.AutoTransform Then
			Continue;
		EndIf;
		
		If Not IsRuleApplicable(Source, Rule.SourceCondition) Then
			Continue;
		EndIf;
		
		Result.Add(Rule.Ref);
	EndDo;
	
	Return Result;
EndFunction

// Checks if a rule is applicable to the source object based on condition.
// 
// Parameters:
//  Source - CatalogObject, DocumentObject - Source object
//  Condition - String - Condition to evaluate
// 
// Returns:
//  Boolean - True if rule is applicable
Function IsRuleApplicable(Source, Condition)
	SetSafeMode(True);
	Return Eval(Condition);
EndFunction

// Gets all transformation rules for the given source metadata type.
// 
// Parameters:
//  SourceMetaType - CatalogRef.ConfigurationMetadata - Source metadata type
// 
// Returns:
//  ValueTable - Rules with columns:
//  * Ref - CatalogRef.TransformationRules - Rule reference
//  * AutoTransform - Boolean - Flag for automatic transformation
//  * SourceCondition - String - Condition for applying the rule
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

// Gets links from source object to target objects.
// 
// Parameters:
//  Source - AnyRef - Source object reference
// 
// Returns:
//  ValueTable - Links with columns:
//  * Source - AnyRef - Source object reference
//  * Target - AnyRef - Target object reference
//  * TransformationRule - CatalogRef.TransformationRules - Rule reference
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

// Gets linked target objects.
// 
// Parameters:
//  Source - AnyRef - Source object reference
//  Rule - CatalogRef.TransformationRules - 
// 
// Returns:
//  AnyRef
Function GetLinkedTargetRefByRule(Source, Rule)
	Query = New Query;
	Query.Text =
		"SELECT
		|	TranformedObjectsLink.Source,
		|	TranformedObjectsLink.Target,
		|	TranformedObjectsLink.TransformationRule
		|FROM
		|	InformationRegister.TranformedObjectsLink AS TranformedObjectsLink
		|WHERE
		|	TranformedObjectsLink.Source = &Source
		|	AND TranformedObjectsLink.TransformationRule = &TransformationRule";
	
	Query.SetParameter("Source", Source);
	Query.SetParameter("TransformationRule", Rule);
	
	Result = Query.Execute().Select();
	If Result.Next() Then
		//@skip-check property-return-type
		Return Result.Target;
	EndIf;
	
	Return Undefined;
EndFunction

// Gets links from target object to source objects.
// 
// Parameters:
//  Target - AnyRef - Target object reference
// 
// Returns:
//  ValueTable - Links with columns:
//  * Source - AnyRef - Source object reference
//  * Target - AnyRef - Target object reference
//  * TransformationRule - CatalogRef.TransformationRules - Rule reference
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

// Logs error information.
// 
// Parameters:
//  Message - String - Error message
//  ErrorInfo - ErrorInfo - Error information
Procedure LogError(Message, ErrorInfo)
	Log.Write(Message, ErrorProcessing.DetailErrorDescription(ErrorInfo));
EndProcedure

#EndRegion