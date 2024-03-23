
// @strict-types

#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	SetOnlyReadModeByResponsibleUser();
	
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);

	FillTypes();

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
		CurrentObject.PreviewText = String(SettingsComposer.Settings.Filter);
	Else
		CurrentObject.DCS = Undefined;
		CurrentObject.PreviewText = "";
	EndIf; 
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	If CurrentObject.AdvancedMode Then
		Settings = CurrentObject.DCS.Get(); // DataCompositionSettings
		UpdateQueryFromServer(Settings);
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

&AtClient
Procedure AdvancedModeOnChange(Item)
	Object.SetOneRuleForAllObjects = True;
	SetVisible();
	UpdateQueryFromClient();
EndProcedure

&AtClient
Procedure RuleListOnChange(Item)
	UpdateQueryFromClient();
EndProcedure

&AtClient
Procedure RuleListTypeStartChoice(Item, ChoiceData, StandardProcessing)
	StandardProcessing = False;
	
	UsedTypes = New Array; // Array of String
	CurrentType = "";
	
	For Each RuleRow In Object.RuleList Do
		If RuleRow.GetID() = Items.RuleList.CurrentRow Then
			CurrentType = RuleRow.Type;
			Continue;
		EndIf;
		UsedTypes.Add(RuleRow.Type);
	EndDo;
	
	//@skip-check invocation-parameter-type-intersect
	CurrentList = GetTypeList(FormAddData["TypeMap"], TypeFilter, UsedTypes);
	If Not IsBlankString(CurrentType) Then
		InitialValue = CurrentList.FindByValue(CurrentType);
	EndIf;
	
	ListNotify = New NotifyDescription("ChooseTypeEnd", ThisObject);
	If InitialValue = Undefined Then
		ShowChooseFromList(ListNotify, CurrentList, Item);
	Else
		ShowChooseFromList(ListNotify, CurrentList, Item, InitialValue);
	EndIf;
EndProcedure

#EndRegion

#Region Notification

&AtClient
//@skip-check method-param-value-type, statement-type-change
Procedure ChooseTypeEnd(ChosenType, AddInfo) Export
	If TypeOf(ChosenType) = Type("ValueListItem") Then
		Items.RuleList.CurrentData.Type = ChosenType.Value;
		UpdateQueryFromClient(); 
	EndIf;
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
	Items.SetOneRuleForAllObjects.Visible = Not Object.AdvancedMode;
EndProcedure

&AtClient
Procedure BeforeWrite(Cancel, WriteParameters)
	UpdateQueryFromClient();
EndProcedure

&AtClient
Procedure PagesMainOnCurrentPageChange(Item, CurrentPage)
	If CurrentPage = Items.GroupFilterQuery Then
		UpdateQueryFromClient();
	EndIf;
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

&AtServer
Procedure UpdateQueryFromServer(Settings = Undefined)
	UpdateQuery(ThisObject, ?(Settings = Undefined, SettingsComposer.GetSettings(), Settings), FillAttributeListHead());
EndProcedure

&AtServerNoContext
Procedure UpdateQuery(Form, Settings, ValueListAvailableField)

	If ValueListAvailableField.Count() = 0 Then
		Return;
	EndIf;
	
	DCSTemplate = Catalogs.LockDataModificationReasons.GetTemplate("DCS");
	
	DataSources = DCSTemplate.DataSources.Add();
	DataSources.DataSourceType = "Local";
	DataSources.Name = "DataSource";
	
	AvailableField = New Array; // Array Of String
	For Each Row In ValueListAvailableField Do
		AvailableField.Add("DS." + StrSplit(String(Row), ".")[StrSplit(String(Row), ".").UBound()]);
	EndDo;
	AvailableFields = StrConcat(AvailableField, ", " + Chars.LF);
	For Each Row In Form.Object.RuleList Do
		If Row.DisableRule Or IsBlankString(Row.Type) Then
			Continue;
		EndIf;
		
		If Not DCSTemplate.DataSets.Find(Row.Type) = Undefined Then
			Continue;
		EndIf;
		
		Query = 
		"SELECT " + AvailableFields + "
		|FROM
		|    " + Row.Type + " AS DS";
		DataSet = DCSTemplate.DataSets.Add(Type("DataCompositionSchemaDataSetQuery"));
		DataSet.Query = Query;
		DataSet.Name = Row.Type;
		DataSet.DataSource = DataSources.Name;
	EndDo;
	
	SettingsComposer = New DataCompositionSettingsComposer();

	Address = PutToTempStorage(DCSTemplate);
	SettingsComposer.Initialize(New DataCompositionAvailableSettingsSource(Address));
	SettingsComposer.LoadSettings(DCSTemplate.DefaultSettings);
	If Form.Object.isInitDCS Then
		SettingsComposer.LoadSettings(Settings);
	EndIf;

	SettingsComposer.Settings.Selection.Items.Clear();

	For Each Field In SettingsComposer.Settings.Selection.SelectionAvailableFields.Items Do
		
		If Field.Field = New DataCompositionField("SystemFields") Then
			Continue;
		EndIf;
		
		Selection = SettingsComposer.Settings.Selection.Items.Add(Type("DataCompositionSelectedField"));
		Selection.Use = True;
		Selection.Field = Field.Field;
	EndDo;
	
	Composer = New DataCompositionTemplateComposer();
	Try
		Template = Composer.Execute(DCSTemplate, SettingsComposer.GetSettings(), , , Type("DataCompositionValueCollectionTemplateGenerator"));

		QueryText = Template.DataSets[0].Query;
		
		QuerySchema = New QuerySchema();
		QuerySchema.SetQueryText(QueryText);
		FilterText = New Array; // Array Of QuerySchemaExpression
		For Each Row In QuerySchema.QueryBatch[0].Operators[0].Filter Do
			FilterText.Add(Row);
		EndDo;
		
		QueryFilter = "CASE WHEN " + StrConcat(FilterText, Chars.LF + " AND ") + " THEN &REF_ ELSE UNDEFINED END";
		If StrCompare(Form.Object.QueryFilter, QueryFilter) Then
			Form.Object.QueryFilter = QueryFilter;
			Form.Modified = True;
		EndIf;
		Form.Items.GroupAdvancedRules.Picture = PictureLib.AppearanceCheckBox;
	Except	
		CommonFunctionsClientServer.ShowUsersMessage(ErrorProcessing.BriefErrorDescription(ErrorInfo()));
		Form.Items.GroupAdvancedRules.Picture = PictureLib.AppearanceCross;
	EndTry;
	Form.SettingsComposer = SettingsComposer;
	If Not Form.Object.isInitDCS Then
		Form.Object.isInitDCS = True;
		Form.Modified = True;
	EndIf;
EndProcedure

&AtClient
Procedure UpdateQueryFromClient()
	If Object.AdvancedMode Then
		UpdateQueryFromServer();
	EndIf;
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

// Add attribute button click.
// 
// Parameters:
//  Item - FormButton -Item
&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion

#Region FillData

&AtServer
//@skip-check typed-value-adding-to-untyped-collection, property-return-type
//@skip-check dynamic-access-method-not-found, invocation-parameter-type-intersect
Procedure FillTypes()
	
	FullTypeList = Items.RuleListType.ChoiceList;
	FullTypeList.Clear();
	
	TypeFilterList = Items.TypeFilter.ChoiceList;
	TypeFilterList.Clear();
	
	If Not TypeOf(FormAddData) = Type("Structure") Then
		FormAddData = New Structure();
	EndIf;
	
	TypeMap = New Map; // Map
	FormAddData.Insert("TypeMap", TypeMap);
	
	TypeMap.Insert("Catalog", New ValueList);
	TypeMap.Insert("Document", New ValueList);
	TypeMap.Insert("InformationRegister", New ValueList);
	TypeMap.Insert("AccumulationRegister", New ValueList);
	
	For Each Cat In Metadata.Catalogs Do
		ListItem = FullTypeList.Add(Cat.FullName(), Cat.Synonym, , PictureLib.Catalog);
		FillPropertyValues(TypeMap.Get("Catalog").Add(), ListItem);
		If TypeFilterList.FindByValue("Catalog") = Undefined Then
			TypeFilterList.Add("Catalog", R().Str_Catalogs, , PictureLib.Catalog);
		EndIf;
	EndDo;
	TypeMap.Get("Catalog").SortByPresentation();
	For Each Doc In Metadata.Documents Do
		ListItem = FullTypeList.Add(Doc.FullName(), Doc.Synonym, , PictureLib.Document);
		FillPropertyValues(TypeMap.Get("Document").Add(), ListItem);
		If TypeFilterList.FindByValue("Document") = Undefined Then
			TypeFilterList.Add("Document", R().Str_Documents, , PictureLib.Document);
		EndIf;
	EndDo;
	TypeMap.Get("Document").SortByPresentation();
	For Each IR In Metadata.InformationRegisters Do
		ListItem = FullTypeList.Add(IR.FullName(), IR.Synonym, , PictureLib.InformationRegister);
		FillPropertyValues(TypeMap.Get("InformationRegister").Add(), ListItem);
		If TypeFilterList.FindByValue("InformationRegister") = Undefined Then
			TypeFilterList.Add("InformationRegister", R().Str_InformationRegisters, , PictureLib.InformationRegister);
		EndIf;
	EndDo;
	TypeMap.Get("InformationRegister").SortByPresentation();
	For Each AR In Metadata.AccumulationRegisters Do
		ListItem = FullTypeList.Add(AR.FullName(), AR.Synonym, , PictureLib.AccumulationRegister);
		FillPropertyValues(TypeMap.Get("AccumulationRegister").Add(), ListItem);
		If TypeFilterList.FindByValue("AccumulationRegister") = Undefined Then
			TypeFilterList.Add("AccumulationRegister", R().Str_AccumulationRegisters, , PictureLib.AccumulationRegister);
		EndIf;
	EndDo;
	TypeMap.Get("AccumulationRegister").SortByPresentation();
EndProcedure

// Get type list.
// 
// Parameters:
//  TypeMap - Map - Type map
//  TypeFilter - String - Type filter
//  UsedTypes - Array of String - Used types
// 
// Returns:
//  ValueList - Get type list
&AtClientAtServerNoContext
Function GetTypeList(TypeMap, TypeFilter, UsedTypes)
	Result = New ValueList();
	If TypeFilter = "" Then
		ListByType = New ValueList();
		For Each ListItem In TypeMap.Get("Catalog") Do
			FillPropertyValues(ListByType.Add(), ListItem);
		EndDo;
		For Each ListItem In TypeMap.Get("Document") Do
			FillPropertyValues(ListByType.Add(), ListItem);
		EndDo;
		For Each ListItem In TypeMap.Get("InformationRegister") Do
			FillPropertyValues(ListByType.Add(), ListItem);
		EndDo;
		For Each ListItem In TypeMap.Get("AccumulationRegister") Do
			FillPropertyValues(ListByType.Add(), ListItem);
		EndDo;
	Else
		ListByType = TypeMap.Get(TypeFilter); // ValueList
	EndIf;
	For Each ListItem In ListByType Do
		//@skip-check invocation-parameter-type-intersect
		If UsedTypes.Find(ListItem.Value) = Undefined Then
			FillPropertyValues(Result.Add(), ListItem);
		EndIf;
	EndDo;
	Return Result;
EndFunction

&AtClient
Procedure RuleListAttributeStartChoice(Item, ChoiceData, StandardProcessing)
	ValueList = FillAttributeList(Items.RuleList.CurrentData.Type);
	Items.RuleListAttribute.ChoiceList.Clear();
	For Each Row In ValueList Do
		//@skip-check typed-value-adding-to-untyped-collection
		Items.RuleListAttribute.ChoiceList.Add(Row.Value, Row.Presentation, , Row.Picture);
	EndDo;
EndProcedure

&AtServer
Function FillAttributeList(Type)
	Return LockDataModificationReuse.FillAttributeList(Type).ChoiceData;
EndFunction

&AtClient
Procedure AttributeStartChoice(Item, ChoiceData, StandardProcessing)
	ValueList = New ValueList();
	FillAttributeListHead(ValueList);
	Items.Attribute.ChoiceList.Clear();
	For Each Row In ValueList Do
		//@skip-check typed-value-adding-to-untyped-collection
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
		
		ValueList = FillAttributeList(Row.Type);
		For Each VLRow In ValueList Do
			VTRow = VT.Add();
			VTRow.Attribute = VLRow.Value;
			VTRow.Count = 1;
		EndDo;
	EndDo;
	// Group all added fields
	VT.GroupBy("Attribute", "Count");
	Array = New Array; // Array Of Arbitrary
	// get only fields, where Count the same as Count rows at RuleList. Other way - its not common attributes
	For Each AttributeName In VT.FindRows(New Structure("Count", Object.RuleList.Count() - Skip)) Do
		//@skip-check property-return-type
		//@skip-check statement-type-change
		Row = ValueList.FindByValue(AttributeName.Attribute);
		If ChoiceData = Undefined Then
			//@skip-check typed-value-adding-to-untyped-collection
			Array.Add(Row.Value);
		Else
			//@skip-check typed-value-adding-to-untyped-collection
			ChoiceData.Add(Row.Value, Row.Presentation, , Row.Picture);
		EndIf;
	EndDo;
	Return Array;
EndFunction

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

#Region COMMANDS

// Generated form command action by name.
// 
// Parameters:
//  Command - CommandBarButton - Command
&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

// Internal command action.
// 
// Parameters:
//  Command - CommandBarButton - Command
&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

// Internal command action with server context.
// 
// Parameters:
//  Command - CommandBarButton - Command
&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

#EndRegion