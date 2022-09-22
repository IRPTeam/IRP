// @strict-types


#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	SetOnlyReadModeByResponsibleUser();
	
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);

	RuleListTypeList = FillTypes();
	For Each Row In RuleListTypeList Do
		Items.RuleListType.ChoiceList.Add(Row.Value, Row.Presentation, , Row.Picture);
	EndDo;

	ComparisonTypeArray = StrSplit("=,<>,<,<=,>,>=,IN,IN HIERARCHY,BETWEEN,IS NULL", ",");
	Items.RuleListComparisonType.ChoiceList.LoadValues(ComparisonTypeArray);
	Items.ComparisonType.ChoiceList.LoadValues(ComparisonTypeArray);

	If Object.SetOneRuleForAllObjects Then
		If Object.RuleList.Count() Then
			FillAttributeListHead(Items.Attribute.ChoiceList);
		EndIf;
	EndIf;
	
EndProcedure

// Notification processing.
// 
// Parameters:
//  EventName - String - Event name
//  Parameter - Arbitrary - Parameter
//  Source - Arbitrary - Source
&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	
	If CurrentObject.AdvancedMode Then
		CurrentObject.DCS = New ValueStorage(SettingsComposer.Settings);
	Else
		CurrentObject.DCS = Undefined;
	EndIf; 
	
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	If CurrentObject.AdvancedMode Then
		Settings = CurrentObject.DCS.Get(); // DataCompositionSettings
		UpdateQuery(Settings);
	EndIf;
EndProcedure


// Description opening.
// 
// Parameters:
//  Item - FormField - Item
//  StandardProcessing - Boolean - Standard processing
&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure ForAllUsersOnChange(Item)
	SetVisible();
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	SetVisible();
EndProcedure

&AtClient
Procedure SetOneRuleForAllObjectsOnChange(Item)
	SetVisible();
EndProcedure

&AtClient
Procedure ValueStartChoice(Item, ChoiceData, StandardProcessing)
	If Object.RuleList.Count() Then
		FillValueTypeHead(Object.RuleList[0].Type);
	EndIf;
EndProcedure

&AtClient
Procedure SetCurrentUser(Command)
	SetCurrentUserAtServer();
EndProcedure

#EndRegion

#Region Privat

&AtClient
Procedure SetVisible()
	Items.AccessGroupList.Visible = Not Object.ForAllUsers;
	Items.UserList.Visible = Not Object.ForAllUsers;
	Items.RuleListAttribute.Visible = Not Object.SetOneRuleForAllObjects;
	Items.RuleListComparisonType.Visible = Not Object.SetOneRuleForAllObjects;
	Items.RuleListValue.Visible = Not Object.SetOneRuleForAllObjects;
	Items.RuleListSetValueAsCode.Visible = Not Object.SetOneRuleForAllObjects;
	Items.GroupRuleSettings.Visible = Object.SetOneRuleForAllObjects And Not Object.AdvancedMode;
	Items.GroupAdvancedRules.Visible = Object.AdvancedMode;
EndProcedure

&AtServer
Procedure SetCurrentUserAtServer()
	CurrentUser = SessionParameters.CurrentUser;
	If CurrentUser.IsEmpty() Then
		Return;
	EndIf;
	Search = Object.ResponsibleUsers.FindRows(New Structure("User", CurrentUser));
	If Search.Count() > 0 Then
		Return;
	EndIf;
	
	NewUser = Object.ResponsibleUsers.Add();
	NewUser.User = CurrentUser;
EndProcedure

&AtServer
Procedure SetOnlyReadModeByResponsibleUser()
	If Not ReadOnly Then
		If Object.ResponsibleUsers.Count() = 0 Then
			Return;
		EndIf;
		
		Search = Object.ResponsibleUsers.FindRows(New Structure("User", SessionParameters.CurrentUser));
		If Search.Count() > 0 Then
			Return;
		EndIf;
		
		ThisObject.ReadOnly = True; 
	EndIf;
EndProcedure

&AtClient
Procedure AdvancedModeOnChange(Item)
	SetVisible();
	UpdateQuery();
EndProcedure

&AtClient
Procedure RuleListOnChange(Item)
	If Object.AdvancedMode Then
		UpdateQuery();
	EndIf;
EndProcedure

&AtServer
Procedure UpdateQuery(Settings = Undefined)
	
	DCSTemplate = Catalogs.LockDataModificationReasons.GetTemplate("DCS");
	
	DataSources = DCSTemplate.DataSources.Add();
	DataSources.DataSourceType = "Local";
	DataSources.Name = "DataSource";
	
	ValueListAvailableField = FillAttributeListHead();
	AvailableField = New Array;
	For Each Row In ValueListAvailableField Do
		AvailableField.Add("DataSet." + StrSplit(String(Row), ".")[StrSplit(String(Row), ".").UBound()]);
	EndDo;
	AvailableFields = StrConcat(AvailableField, ", ");
	For Each Row In Object.RuleList Do
		If Row.DisableRule Or IsBlankString(Row.Type) Then
			Continue;
		EndIf;
		
		Query = 
		"SELECT " + AvailableFields + "
		|FROM
		|    " + Row.Type + " AS DataSet";
		DataSet = DCSTemplate.DataSets.Add(Type("DataCompositionSchemaDataSetQuery"));
		DataSet.Query = Query;
		DataSet.Name = Row.Type;
		DataSet.DataSource = DataSources.Name;
	EndDo;
	
	If DCSTemplate.DataSets.Count() = 0 Then
		SettingsComposer = New DataCompositionSettingsComposer();
		Return;
	EndIf;
	
	Address = PutToTempStorage(DCSTemplate, UUID);
	SettingsComposer.Initialize(New DataCompositionAvailableSettingsSource(Address));
	If Not Settings = Undefined Then
		SettingsComposer.LoadSettings(Settings);
	EndIf;
	SettingsComposer.Settings.Selection.Items.Clear();

	For Each Field In SettingsComposer.Settings.Selection.SelectionAvailableFields.Items Do
		Selection = SettingsComposer.Settings.Selection.Items.Add(Type("DataCompositionSelectedField"));
		Selection.Use = True;
		Selection.Field = Field.Field;
	EndDo;

EndProcedure

#EndRegion

#Region AddAttributes

// Add attribute start choice.
// 
// Parameters:
//  Item - FormField - Item
//  ChoiceData - ChoiceParameter - Choice data
//  StandardProcessing - Boolean - Standard processing
&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

#EndRegion

#Region FillData

&AtServer
Function FillTypes()
	ValueList = New ValueList();
	For Each Cat In Metadata.Catalogs Do
		ValueList.Add(Cat.FullName(), Cat.Synonym, , PictureLib.Catalog);
	EndDo;
	For Each Doc In Metadata.Documents Do
		ValueList.Add(Doc.FullName(), Doc.Synonym, , PictureLib.Document);
	EndDo;
	For Each IR In Metadata.InformationRegisters Do
		ValueList.Add(IR.FullName(), IR.Synonym, , PictureLib.InformationRegister);
	EndDo;
	For Each AR In Metadata.AccumulationRegisters Do
		ValueList.Add(AR.FullName(), AR.Synonym, , PictureLib.AccumulationRegister);
	EndDo;
	Return ValueList;
EndFunction

&AtClient
Procedure RuleListAttributeStartChoice(Item, ChoiceData, StandardProcessing)
	ValueList = New ValueList();
	FillAttributeList(ValueList, Items.RuleList.CurrentData.Type);
	Items.RuleListAttribute.ChoiceList.Clear();
	For Each Row In ValueList Do
		Items.RuleListAttribute.ChoiceList.Add(Row.Value, Row.Presentation, , Row.Picture);
	EndDo;
EndProcedure

&AtClient
Procedure AttributeStartChoice(Item, ChoiceData, StandardProcessing)
	ValueList = New ValueList();
	FillAttributeListHead(ValueList);
	Items.Attribute.ChoiceList.Clear();
	For Each Row In ValueList Do
		Items.Attribute.ChoiceList.Add(Row.Value, Row.Presentation, , Row.Picture);
	EndDo;
EndProcedure

&AtClient
Procedure RuleListValueStartChoice(Item, ChoiceData, StandardProcessing)
	RowStructure = New Structure("SetValueAsCode, Attribute, Type", True, "", "");
	FillPropertyValues(RowStructure, Items.RuleList.CurrentData);
	FillValueType(RowStructure);
EndProcedure

&AtServer
Function FillAttributeListHead(ChoiceData = Undefined)

	VT = New ValueTable();
	VT.Columns.Add("Attribute", New TypeDescription("String"));
	VT.Columns.Add("Count", New TypeDescription("Number"));
	ValueList = New ValueList();
	Skip = 0;
	For Each Row In Object.RuleList Do
		If IsBlankString(Row.Type) Then
			Skip = Skip + 1;
			Continue;
		EndIf;
		
		ValueList = New ValueList(); // ValueList of String
		FillAttributeList(ValueList, Row.Type);
		For Each VLRow In ValueList Do
			VTRow = VT.Add();
			VTRow.Attribute = VLRow.Value;
			VTRow.Count = 1;
		EndDo;
	EndDo;
	// Group all added fields
	VT.GroupBy("Attribute", "Count");
	Array = New Array;
	// get only fields, where Count the same as Count rows at RuleList. Other way - its not common attributes
	For Each AttributeName In VT.FindRows(New Structure("Count", Object.RuleList.Count() - Skip)) Do
		//@skip-check property-return-type
		//@skip-check statement-type-change
		Row = ValueList.FindByValue(AttributeName.Attribute);
		If ChoiceData = Undefined Then
			Array.Add(Row.Value);
		Else
			ChoiceData.Add(Row.Value, Row.Presentation, , Row.Picture);
		EndIf;
	EndDo;
	Return Array;
EndFunction

// Fill attribute list.
// 
// Parameters:
//  ChoiceData - ValueList of String - Choice data
//  DataType - String - Data type
&AtServer
Procedure FillAttributeList(ChoiceData, DataType)
	If IsBlankString(DataType) Then
		Return;
	EndIf;
	MetadataType = Enums.MetadataTypes[StrSplit(DataType, ".")[0]];
	MetaItem = Metadata.FindByFullName(DataType);
	If MetadataInfo.hasAttributes(MetadataType) Then
		AddChild(MetaItem, ChoiceData, "Attributes");
	EndIf;
	If MetadataInfo.hasDimensions(MetadataType) Then
		AddChild(MetaItem, ChoiceData, "Dimensions");
	EndIf;
	If MetadataInfo.hasStandardAttributes(MetadataType) Then
		AddChild(MetaItem, ChoiceData, "StandardAttributes");
	EndIf;
	If MetadataInfo.hasRecalculations(MetadataType) Then
		AddChild(MetaItem, ChoiceData, "Recalculations");
	EndIf;
	If MetadataInfo.hasAccountingFlags(MetadataType) Then
		AddChild(MetaItem, ChoiceData, "AccountingFlags");
	EndIf;

	For Each CmAttribute In Metadata.CommonAttributes Do
		If Not CmAttribute.Content.Find(Metadata.FindByFullName(DataType)) = Undefined And CmAttribute.Content.Find(
			Metadata.FindByFullName(DataType)).Use = Metadata.ObjectProperties.CommonAttributeUse.Use Then
			ChoiceData.Add("CommonAttribute." + CmAttribute.Name, ?(IsBlankString(CmAttribute.Synonym),
				CmAttribute.Name, CmAttribute.Synonym), , PictureLib.CommonAttributes);
		EndIf;
	EndDo;
EndProcedure

// Add child.
// 
// Parameters:
//  MetaItem - MetadataObject - Meta item
//  AttributeChoiceList - ValueList of String - Attribute choice list
//  DataType - String - Data type
&AtServer
Procedure AddChild(MetaItem, AttributeChoiceList, DataType)

	If MetaItem = Undefined Then
		Return;
	EndIf;
	
	MetaCollection = MetaItem[DataType]; // Array of MetadataObjectAttribute
	If Not MetaCollection.Count() Then
		Return;
	EndIf;

	For Each AddChild In MetaCollection Do
		//@skip-check invocation-parameter-type-intersect
		AttributeChoiceList.Add(DataType + "." + AddChild.Name, ?(IsBlankString(AddChild.Synonym), AddChild.Name,
			AddChild.Synonym), , PictureLib[DataType]);
	EndDo;

EndProcedure

// Fill value type.
// 
// Parameters:
//  RowStructure - Structure - Row structure:
// * SetValueAsCode - Boolean -
// * Attribute - String -
// * Type - String -
//@skip-check statement-type-change
//@skip-check property-return-type
&AtServer
Procedure FillValueType(RowStructure)

	If RowStructure.SetValueAsCode Then
		ThisObject.Items.RuleListValue.TypeRestriction = New TypeDescription("String");
		ThisObject.Items.RuleListValue.InputHint = String(R().S_032);
	Else
		If StrSplit(RowStructure.Attribute, ".")[0] = "CommonAttribute" Then
			ThisObject.Items.RuleListValue.TypeRestriction = Metadata.FindByFullName(RowStructure.Attribute).Type;
		Else
			ThisObject.Items.RuleListValue.TypeRestriction = Metadata.FindByFullName(RowStructure.Type)[StrSplit(
				RowStructure.Attribute, ".")[0]][StrSplit(RowStructure.Attribute, ".")[1]].Type;
		EndIf;
		ThisObject.Items.RuleListValue.InputHint = String(ThisObject.Items.RuleListValue.TypeRestriction);
	EndIf;

EndProcedure

// Fill value type head.
// 
// Parameters:
//  Type - String - Type
//@skip-check statement-type-change
//@skip-check property-return-type
&AtServer
Procedure FillValueTypeHead(Type)

	If Object.SetValueAsCode Then
		ThisObject.Items.Value.TypeRestriction = New TypeDescription("String");
		ThisObject.Items.Value.InputHint = String(R().S_032);
	Else
		If StrSplit(Object.Attribute, ".")[0] = "CommonAttribute" Then
			ThisObject.Items.Value.TypeRestriction = Metadata.FindByFullName(Object.Attribute).Type;
		Else
			ThisObject.Items.Value.TypeRestriction = Metadata.FindByFullName(Type)[StrSplit(Object.Attribute,
				".")[0]][StrSplit(Object.Attribute, ".")[1]].Type;
		EndIf;
		ThisObject.Items.Value.InputHint = String(ThisObject.Items.Value.TypeRestriction);
	EndIf;

EndProcedure

#EndRegion