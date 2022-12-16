// @strict-types

#Region Form_Events

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	FormCash = GetFormCash(ThisObject);
	FormCash.CountConditionalAppearance = ThisObject.ConditionalAppearance.Items.Count();
	LoadMetadata(FormCash);
	
	RefsList = Parameters["RefsList"]; // Array, Undefined
	If TypeOf(RefsList) = Type("Array") Then
		TypeKey = TypeOf(RefsList[0]);
		TypeRecord = Items.ObjectType.ChoiceList.FindByValue(TypeKey);
		If Not TypeRecord = Undefined Then
			ThisObject["ObjectType"] = TypeKey;
			SetTablesList(ThisObject);
			If Not IsBlankString(GetObjectTable(ThisObject)) Then
				SetNewTable();
				SetRefsToFilter(RefsList, ThisObject.DataSettingsComposer);
				LoadTableData();
			EndIf;
		EndIf;
	EndIf;

EndProcedure

#EndRegion

#Region FormItems_Events

&AtClient
Procedure ObjectTypeOnChange(Item)
	
	Items.ObjectTable.ChoiceList.Clear();
	ThisObject.ObjectTable = "";
	
	If Not GetObjectType(ThisObject) = Undefined Then
		SetTablesList(ThisObject);
		If Not IsBlankString(GetObjectTable(ThisObject)) Then
			SetNewTable();
		EndIf;
	EndIf;

EndProcedure

&AtClient
Procedure ObjectTableOnChange(Item)
	SetNewTable();
EndProcedure

// Properties table selection.
// 
// Parameters:
//  Item - FormTable - Item
//  RowSelected - Number - Row selected
//  Field - FormField - Field
//  StandardProcessing - Boolean - Standard processing
&AtClient
Procedure PropertiesTableSelection(Item, RowSelected, Field, StandardProcessing)
	If Field = Items.PropertiesTableObject Then
		DataRow = ThisObject.PropertiesTable.FindByID(RowSelected);
		If Not DataRow = Undefined Then
			ShowValue(, DataRow.Object);
		EndIf;
	EndIf;
EndProcedure

// Properties table value on change.
// 
// Parameters:
//  Item - FormField - Item
&AtClient
Procedure PropertiesTableValueOnChange(Item)
	RowValue = Items.PropertiesTable.CurrentData;
	CheckRowModified(ThisObject, RowValue);
EndProcedure

// Properties table value start choice.
// 
// Parameters:
//  Item - FormField - Item
//  ChoiceData - ValueList - Choice data
//  StandardProcessing - Boolean - Standard processing
&AtClient
Procedure PropertiesTableValueStartChoice(Item, ChoiceData, StandardProcessing)
	
	FieldName = Item.Name; // String
	FieldDescription = Undefined; // See GetFieldDescription
	If GetFormCash(ThisObject).ColumnsData.Property(FieldName, FieldDescription) Then
		If TypeOf(Items.PropertiesTable.CurrentData[FieldName]) = Type("ValueList") Then
			Items.PropertiesTable.CurrentData[FieldName]["ValueType"] = FieldDescription.ValueType;
		ElsIf Items.PropertiesTable.CurrentData[FieldName] = Undefined Then
			Item.TypeRestriction = FieldDescription.ValueType;
		EndIf;
	EndIf;
	
EndProcedure

#EndRegion

#Region Form_Commands

&AtClient
Procedure Refresh(Command)
	LoadTableData();
EndProcedure

&AtClient
Procedure Save(Command)
	SaveAtServer();
	LoadTableData();
EndProcedure

&AtClient
Procedure DeleteCurrentValue(Command)
	
	RowValue = Items.PropertiesTable.CurrentData;
	Field = Items.PropertiesTable.CurrentItem.Name; // String
	FieldDescription = GetFormCash(ThisObject).ColumnsData[Field]; // See GetFieldDescription
	
	For Each SelectedRow In Items.PropertiesTable.SelectedRows Do
		RowIndex = SelectedRow; // Number
		RowValue = ThisObject.PropertiesTable.FindByID(RowIndex);
		If FieldDescription.isCollection Then
			RowValue[Field] = New ValueList();
		Else
			RowValue[Field] = Undefined;
		EndIf;
		CheckRowModified(ThisObject, RowValue);
	EndDo;

EndProcedure

&AtClient
Procedure CopyThisValueToEmptyCells(Command)
	
	CurrentRow = Items.PropertiesTable.CurrentData;
	Field = Items.PropertiesTable.CurrentItem.Name; // String
	FieldDescription = GetFormCash(ThisObject).ColumnsData[Field]; // See GetFieldDescription
	CurrentValue = CurrentRow[Field]; // Arbitrary, ValueList
	
	For Each Row In ThisObject.PropertiesTable Do
		If Row = CurrentRow Then
			Continue;
		EndIf;
		
		RowValue = Row[Field]; // Arbitrary, ValueList
		If FieldDescription.isCollection Then
			If RowValue = Undefined Or (TypeOf(RowValue) = Type("ValueList") And RowValue.Count() = 0) Then
				Row[Field] = CurrentValue;
			EndIf;
		Else
			If RowValue = Undefined Then
				Row[Field] = CurrentValue;
			EndIf;
		EndIf;
		
		CheckRowModified(ThisObject, Row);
	EndDo;

EndProcedure

&AtClient
Procedure SetNewValue(Command)
	
	CurrentRow = Items.PropertiesTable.CurrentData;
	Field = Items.PropertiesTable.CurrentItem.Name; // String
	
	For Each Row In ThisObject.PropertiesTable Do
		If Row = CurrentRow Then
			Continue;
		EndIf;
		Row[Field] = CurrentRow[Field]; // Arbitrary, ValueList
		CheckRowModified(ThisObject, Row);
	EndDo;

EndProcedure

#EndRegion

#Region Private

&AtClientAtServerNoContext
Procedure CheckRowModified(Form, RowValue)
	
	isModified = False;
	
	For Each ColumnKeyValue In GetFormCash(Form).ColumnsData Do
		ColumnKey = ColumnKeyValue.Key; // String
		ColumnValue = ColumnKeyValue.Value; // See GetFieldDescription
		CurrentValue = RowValue[ColumnKey]; // Arbitrary, ValueList
		OldValue = RowValue[ColumnKey + "_old"]; // Arbitrary, ValueList
		If ColumnValue.isCollection Then
			If Not TypeOf(CurrentValue) = Type("ValueList") Then
				CurrentValue = New ValueList();
				RowValue[ColumnKey] = CurrentValue;
			EndIf;
			If Not TypeOf(OldValue) = Type("ValueList") Then
				OldValue = New ValueList();
				RowValue[ColumnKey + "_old"] = CurrentValue;
			EndIf;
			RowValue[ColumnKey + "_modified"] = 0;
			If CurrentValue.Count() = 0 And OldValue.Count() = 0 Then
				RowValue[ColumnKey + "_modified"] = 1;
			ElsIf CurrentValue.Count() = 0 Then
				RowValue[ColumnKey + "_modified"] = 2;
				isModified = True;
			ElsIf Not CurrentValue.Count() = OldValue.Count() Then
				RowValue[ColumnKey + "_modified"] = 3;
				isModified = True;
			Else
				For Each ListItem In CurrentValue Do
					If OldValue.FindByValue(ListItem.Value) = Undefined Then
						RowValue[ColumnKey + "_modified"] = 3;
						isModified = True;
						Break;
					EndIf;
				EndDo;
			EndIf;
		Else
			If Not CurrentValue = OldValue Then
				isModified = True;
			EndIf;
		EndIf;
	EndDo;
	
	RowValue.isModified = isModified;

EndProcedure

#Region FormProperty_Getting

// Get form cash.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
// 
// Returns:
//  Structure - Form cash:
// * ObjectTables - Map - Set tables of specified object:
// 	** Key - Type
//	** Value - Structure:
//		*** Key - String
//		*** Value - String
// * SchemaAddress - String
// * ColumnsData - Structure:
//	** Key - String
//	** Value - See GetFieldDescription
// * CountConditionalAppearance - Number
&AtClientAtServerNoContext
Function GetFormCash(Form)
	FormCash = Form["FormDataCash"]; // Structure, Undefined
	If Not FormCash = Undefined Then
		Return FormCash;
	EndIf;
	
	FormCash = New Structure;
	FormCash.Insert("ObjectTables", New Map);
	FormCash.Insert("SchemaAddress", "");
	FormCash.Insert("ColumnsData", New Structure);
	FormCash.Insert("CountConditionalAppearance", 0);
	
	Form["FormDataCash"] = FormCash;
	
	Return FormCash;
EndFunction

// Get object type.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
// 
// Returns:
//  Type, Undefined - Get object type
&AtClientAtServerNoContext
Function GetObjectType(Form)
	ObjectType = Form["ObjectType"]; // Type, Undefined
	Return ObjectType;
EndFunction

// Get object table.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
// 
// Returns:
//  String - Get object table
&AtClientAtServerNoContext
Function GetObjectTable(Form)
	OT_String = "ObjectTable";
	ObjectTable = Form[OT_String]; // String
	Return ObjectTable;
EndFunction

#EndRegion

#Region FormProperty_Setting

// Set tables list.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
&AtClientAtServerNoContext
Procedure SetTablesList(Form)
	CL_String = "ChoiceList";
	OT_String = "ObjectTable";
	
	TablesChoiceList = Form.Items[OT_String][CL_String]; // ValueList of String
	TablesChoiceList.Clear();
	
	TablesStructure = GetFormCash(Form).ObjectTables.Get(GetObjectType(Form));
	If TypeOf(TablesStructure) = Type("Structure") Then
		For Each TableKeyValue In TablesStructure Do
			TableKey = TableKeyValue.Key; // String
			TableValue = TableKeyValue.Value; // String
			TablesChoiceList.Add(TableKey, TableValue);
		EndDo;
	EndIf;
	
	If TablesChoiceList.Count() > 0 Then
		Form.ObjectTable = TablesChoiceList[0].Value;
	EndIf;
	
	Form.Items[OT_String].Enabled = TablesChoiceList.Count() > 1;
EndProcedure

// Set new table.
// 
&AtServer
Procedure SetNewTable()
	SetSourceSettings(ThisObject);
	SetTableSettings(ThisObject);
EndProcedure	
	
// Set source settings.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
&AtServerNoContext
Procedure SetSourceSettings(Form)
	
	TS_String = "TabularSections";
	Table_String = GetObjectTable(Form); // String
	
	MetaObject = Metadata.FindByType(GetObjectType(Form));
	MetaObjectTable = MetaObject[TS_String][Table_String]; // MetadataObjectTabularSection
	
	DCSchema = New DataCompositionSchema;

	DS = DCSchema.DataSources.Add();
	DS.Name = "DataSources";
	DS.DataSourceType = "Local";
	
	DataSet = DCSchema.DataSets.Add(Type("DataCompositionSchemaDataSetQuery"));
	DataSet.Name = "DataSet";
	DataSet.DataSource = "DataSources";
	DataSet.Query =
	"SELECT
	|	Table.Ref,
	|	Attributes.Property,
	|	Attributes.Value
	|FROM
	|	" + MetaObject.FullName() + "." + Table_String + " AS Attributes
	|		FULL JOIN " + MetaObject.FullName() + " AS Table
	|		ON Attributes.Ref = Table.Ref";
	
	DataField = DataSet.Fields.Add(Type("DataCompositionSchemaDataSetField"));
	DataField.Field = "Ref";
	DataField.DataPath = "Ref";
	DataField.Title = "Ref";
		
	DataField = DataSet.Fields.Add(Type("DataCompositionSchemaDataSetField"));
	DataField.Field = "Property";
	DataField.DataPath = "Property";
	DataField.Title = MetaObjectTable.Attributes.Property.Synonym;
		
	DataField = DataSet.Fields.Add(Type("DataCompositionSchemaDataSetField"));
	DataField.Field = "Value";
	DataField.DataPath = "Value";
	DataField.Title = MetaObjectTable.Attributes.Value.Synonym;
		
	SchemaAddress = PutToTempStorage(DCSchema, Form.UUID);
  	AvailableSettingsSource = New DataCompositionAvailableSettingsSource(SchemaAddress);
	
	FormCash = GetFormCash(Form);
	FormCash.SchemaAddress = SchemaAddress; 
    
    DSC_String = "DataSettingsComposer";
    DataSettingsComposer = Form[DSC_String]; // DataCompositionSettingsComposer
	DataSettingsComposer.Initialize(AvailableSettingsSource);
    DataSettingsComposer.LoadSettings(DCSchema.DefaultSettings);
    
	SelectionItems = DataSettingsComposer.Settings.Selection.Items;
	SelectionItems.Clear();
	SelectionItems.Add(Type("DataCompositionSelectedField")).Field = New DataCompositionField("Ref");
	SelectionItems.Add(Type("DataCompositionSelectedField")).Field = New DataCompositionField("Property");
	SelectionItems.Add(Type("DataCompositionSelectedField")).Field = New DataCompositionField("Value");
	
    DataSettingsComposer.Settings.Structure.Clear();
    RefGroup = DataSettingsComposer.Settings.Structure.Add(Type("DataCompositionGroup"));
	RefGroup.GroupFields.Items.Add(Type("DataCompositionGroupField")).Field = New DataCompositionField("Ref");
	RefGroup.Selection.Items.Add(Type("DataCompositionSelectedField")).Field = New DataCompositionField("Ref");
	DetailGroup = RefGroup.Structure.Add(Type("DataCompositionGroup"));
	DetailGroup.Selection.Items.Add(Type("DataCompositionAutoSelectedField"));
    
EndProcedure

// Set refs to filter.
// 
// Parameters:
//  RefsArray - Array of AnyRef 
//  DataSettingsComposer - DataCompositionSettingsComposer - Data settings composer
&AtClientAtServerNoContext
Procedure SetRefsToFilter(RefsArray, DataSettingsComposer)
	List = New ValueList;
	List.LoadValues(RefsArray);
	
	RefsFilter = DataSettingsComposer.Settings.Filter.Items.Add(Type("DataCompositionFilterItem"));
	RefsFilter.LeftValue = New DataCompositionField("Ref");
	RefsFilter.ComparisonType  = DataCompositionComparisonType.InList;
	//@skip-warning
	RefsFilter.RightValue = List;
	RefsFilter.Use = True;
EndProcedure

// Set table settings.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
&AtServerNoContext
Procedure SetTableSettings(Form)
	
	PT_String = "PropertiesTable";
	
	Form.PropertiesTable.Clear();
	LoadNewColumns(Form);
	
	PrimaryCount = GetFormCash(Form).CountConditionalAppearance;
	While Form.ConditionalAppearance.Items.Count() > PrimaryCount Do
		LastItem = Form.ConditionalAppearance.Items.Get(Form.ConditionalAppearance.Items.Count() - 1);
		Form.ConditionalAppearance.Items.Delete(LastItem);
	EndDo;
	
	Oldfields = New Array; // Array of FormField
	For Each FieldItem In Form.Items.PropertiesFields.ChildItems Do
		Oldfields.Add(FieldItem);
	EndDo;
	For Each FieldItem In Oldfields Do
		Form.Items.Delete(FieldItem);
	EndDo;
	
	OldAttributes = New Array; // Array of String
	CurrentColumns = Form.GetAttributes(PT_String);
	For Each ColumnItem In CurrentColumns Do
		If ColumnItem.Name = "Object" Or ColumnItem.Name = "isModified" Then
			Continue;
		EndIf;
		OldAttributes.Add(StrTemplate("%1.%2", ColumnItem.Path, ColumnItem.Name));
	EndDo;
	Form.ChangeAttributes(, OldAttributes);
	
	NewAttributes = New Array; // Array of FormAttribute
	ColumnsData = GetFormCash(Form).ColumnsData;
	For Each ColumnItem In ColumnsData Do
		ColumnDescription = ColumnItem.Value; // See GetFieldDescription
		FormAttribute = New FormAttribute(
			ColumnItem.Key, 
			New TypeDescription(ColumnDescription.CollectionValueType, "Undefined"), 
			PT_String, 
			ColumnDescription.Presentation);
		NewAttributes.Add(FormAttribute);
		FormAttribute = New FormAttribute(
			ColumnItem.Key + "_old", 
			FormAttribute.ValueType, 
			PT_String, 
			ColumnDescription.Presentation + " (~)");
		NewAttributes.Add(FormAttribute);
		If ColumnDescription.isCollection Then
			FormAttribute = New FormAttribute(
				ColumnItem.Key + "_modified", 
				New TypeDescription("Number"), 
				PT_String, 
				ColumnDescription.Presentation + " (*)");
			NewAttributes.Add(FormAttribute);
		EndIf;
	EndDo;
	Form.ChangeAttributes(NewAttributes);
	
	For Each ColumnItem In ColumnsData Do
		ColumnKey = ColumnItem.Key; // String
		ColumnDescription = ColumnItem.Value; // See GetFieldDescription
		
		NewFormItem = Form.Items.Add(ColumnKey, Type("FormField"), Form.Items.PropertiesFields);
		NewFormItem.Type = FormFieldType.InputField;
		NewFormItem.DataPath = PT_String + "." + ColumnKey;
		NewFormItem.ChooseType = False;
		ParametersArray = New Array; // Array of ChoiceParameter
		ParametersArray.Add(New ChoiceParameter("Filter.Owner", ColumnDescription.Ref));
		NewFormItem.ChoiceParameters = New FixedArray(ParametersArray);
		NewFormItem.SetAction("OnChange", "PropertiesTableValueOnChange");
		NewFormItem.SetAction("StartChoice", "PropertiesTableValueStartChoice");
		
		CreateConditionalAppearance(Form, NewFormItem, ColumnDescription.isCollection);
	EndDo;
	
EndProcedure

// Create conditional appearance.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  NewFormItem - FormFieldExtensionForATextDocument, FormFieldExtensionForAGanttChartField, FormFieldExtensionForALabelField, FormFieldExtensionForADendrogramField, FormFieldExtensionForAPictureField, FormFieldExtensionForATrackBarField, FormFieldExtensionForAPlanner, FormFieldExtensionForAChartField, FormFieldExtensionForAFormattedDocument, FormFieldExtensionForATextBox, FormFieldExtensionForAGeographicalSchemaField, FormFieldExtensionForAPeriodField, FormFieldExtensionForASpreadsheetDocumentField, FormField, FormExtensionForAHTMLDocumentField, FormFieldExtensionForACheckBoxField, FormFieldExtensionForACalendarField, FormFieldExtensionForAProgressBarField, FormFieldExtensionForARadioButtonField, FormFieldExtensionForAGraphicalSchemaField - New form item
//	isCollection - Boolean 
&AtServerNoContext
Procedure CreateConditionalAppearance(Form, NewFormItem, isCollection)
	
	If Not isCollection Then
		ConditionalAppearanceItem = Form.ConditionalAppearance.Items.Add();
		ConditionalAppearanceItem.Appearance.SetParameterValue("BackColor", WebColors.LightGreen);
		FilterItem = ConditionalAppearanceItem.Filter.Items.Add(Type("DataCompositionFilterItem"));
		FilterItem.ComparisonType = DataCompositionComparisonType.NotEqual;
		FilterItem.LeftValue = New DataCompositionField(NewFormItem.DataPath);
		//@skip-warning
		FilterItem.RightValue = Undefined;
		FilterItem.Use = True;
		FilterItem = ConditionalAppearanceItem.Filter.Items.Add(Type("DataCompositionFilterItem"));
		FilterItem.ComparisonType = DataCompositionComparisonType.NotEqual;
		FilterItem.LeftValue = New DataCompositionField(NewFormItem.DataPath);
		//@skip-warning
		FilterItem.RightValue = New DataCompositionField(NewFormItem.DataPath + "_old");
		FilterItem.Use = True;
		AppearanceField = ConditionalAppearanceItem.Fields.Items.Add();
		AppearanceField.Field = New DataCompositionField(NewFormItem.Name);
		AppearanceField.Use = True;
		
		ConditionalAppearanceItem = Form.ConditionalAppearance.Items.Add();
		ConditionalAppearanceItem.Appearance.SetParameterValue("BackColor", WebColors.LightGray);
		FilterItem = ConditionalAppearanceItem.Filter.Items.Add(Type("DataCompositionFilterItem"));
		FilterItem.ComparisonType = DataCompositionComparisonType.Equal;
		FilterItem.LeftValue = New DataCompositionField(NewFormItem.DataPath);
		//@skip-warning
		FilterItem.RightValue = Undefined;
		FilterItem.Use = True;
		FilterItem = ConditionalAppearanceItem.Filter.Items.Add(Type("DataCompositionFilterItem"));
		FilterItem.ComparisonType = DataCompositionComparisonType.Equal;
		FilterItem.LeftValue = New DataCompositionField(NewFormItem.DataPath);
		//@skip-warning
		FilterItem.RightValue = New DataCompositionField(NewFormItem.DataPath + "_old");
		FilterItem.Use = True;
		AppearanceField = ConditionalAppearanceItem.Fields.Items.Add();
		AppearanceField.Field = New DataCompositionField(NewFormItem.Name);
		AppearanceField.Use = True;
	
		ConditionalAppearanceItem = Form.ConditionalAppearance.Items.Add();
		ConditionalAppearanceItem.Appearance.SetParameterValue("BackColor", WebColors.LightPink);
		//@skip-warning
		ConditionalAppearanceItem.Appearance.SetParameterValue("Text", StrTemplate("<%1>", R().Form_002));
		FilterItem = ConditionalAppearanceItem.Filter.Items.Add(Type("DataCompositionFilterItem"));
		FilterItem.ComparisonType = DataCompositionComparisonType.Equal;
		FilterItem.LeftValue = New DataCompositionField(NewFormItem.DataPath);
		//@skip-warning
		FilterItem.RightValue = Undefined;
		FilterItem.Use = True;
		FilterItem = ConditionalAppearanceItem.Filter.Items.Add(Type("DataCompositionFilterItem"));
		FilterItem.ComparisonType = DataCompositionComparisonType.NotEqual;
		FilterItem.LeftValue = New DataCompositionField(NewFormItem.DataPath);
		//@skip-warning
		FilterItem.RightValue = New DataCompositionField(NewFormItem.DataPath + "_old");
		FilterItem.Use = True;
		AppearanceField = ConditionalAppearanceItem.Fields.Items.Add();
		AppearanceField.Field = New DataCompositionField(NewFormItem.Name);
		AppearanceField.Use = True;
	Else
		ConditionalAppearanceItem = Form.ConditionalAppearance.Items.Add();
		ConditionalAppearanceItem.Appearance.SetParameterValue("BackColor", WebColors.LightGray);
		FilterItem = ConditionalAppearanceItem.Filter.Items.Add(Type("DataCompositionFilterItem"));
		FilterItem.ComparisonType = DataCompositionComparisonType.Equal;
		FilterItem.LeftValue = New DataCompositionField(NewFormItem.DataPath + "_modified");
		//@skip-warning
		FilterItem.RightValue = 1;
		FilterItem.Use = True;
		AppearanceField = ConditionalAppearanceItem.Fields.Items.Add();
		AppearanceField.Field = New DataCompositionField(NewFormItem.Name);
		AppearanceField.Use = True;
		
		ConditionalAppearanceItem = Form.ConditionalAppearance.Items.Add();
		ConditionalAppearanceItem.Appearance.SetParameterValue("BackColor", WebColors.LightPink);
		//@skip-warning
		ConditionalAppearanceItem.Appearance.SetParameterValue("Text", StrTemplate("<%1>", R().Form_002));
		FilterItem = ConditionalAppearanceItem.Filter.Items.Add(Type("DataCompositionFilterItem"));
		FilterItem.ComparisonType = DataCompositionComparisonType.Equal;
		FilterItem.LeftValue = New DataCompositionField(NewFormItem.DataPath + "_modified");
		//@skip-warning
		FilterItem.RightValue = 2;
		FilterItem.Use = True;
		AppearanceField = ConditionalAppearanceItem.Fields.Items.Add();
		AppearanceField.Field = New DataCompositionField(NewFormItem.Name);
		AppearanceField.Use = True;
	
		ConditionalAppearanceItem = Form.ConditionalAppearance.Items.Add();
		ConditionalAppearanceItem.Appearance.SetParameterValue("BackColor", WebColors.LightGreen);
		FilterItem = ConditionalAppearanceItem.Filter.Items.Add(Type("DataCompositionFilterItem"));
		FilterItem.ComparisonType = DataCompositionComparisonType.Equal;
		FilterItem.LeftValue = New DataCompositionField(NewFormItem.DataPath + "_modified");
		//@skip-warning
		FilterItem.RightValue = 3;
		FilterItem.Use = True;
		AppearanceField = ConditionalAppearanceItem.Fields.Items.Add();
		AppearanceField.Field = New DataCompositionField(NewFormItem.Name);
		AppearanceField.Use = True;
	EndIf;
	
EndProcedure

#EndRegion

#Region LoadData

// Load metadata.
// 
// Parameters:
//  FormCash - See GetFormCash
&AtServer
Procedure LoadMetadata(FormCash)
	
	TS_String = "TabularSections";
	A_String = "Attributes";
	P_String = "Property";
		
	TypeChoiceList = Items.ObjectType.ChoiceList; // ValueList of Type
	TypeChoiceList.Clear();
	FormCash.ObjectTables.Clear();
	
	AvailableTypes = GetAvailableTypes();
	For Each AvailableType In AvailableTypes Do
		
		ItemPreffics = "";
		ItemPicture = Undefined;
		If Catalogs.AllRefsType().ContainsType(AvailableType) Then
			//@skip-warning
			ItemPreffics = StrTemplate("(" + R().Str_Catalog + ") ");
			ItemPicture = PictureLib.Catalog;
		ElsIf Documents.AllRefsType().ContainsType(AvailableType) Then
			//@skip-warning
			ItemPreffics = StrTemplate("(" + R().Str_Document + ") ");
			ItemPicture = PictureLib.DocumentJournal;
		EndIf;
		TypeChoiceList.Add(AvailableType, ItemPreffics + AvailableType, , ItemPicture);
		
		PropertyTables = New Structure;
		MetaObject = Metadata.FindByType(AvailableType);
		If TypeOf(MetaObject) = Type("MetadataObject") Then
			Try
				TabularSections = MetaObject[TS_String]; // MetadataObjectCollection
				For Each TabularSection In TabularSections Do
					TabularSectionAttributes = TabularSection[A_String]; // MetadataObjectCollection
					AttributeProperty = TabularSectionAttributes.Find(P_String); // MetadataObjectAttribute
					If Not AttributeProperty = Undefined And isChartOfCharacteristicTypes(AttributeProperty.Type) Then
						PropertyTables.Insert(TabularSection.Name, TabularSection.Synonym);
					EndIf;
				EndDo;
			Except
				//@skip-check module-unused-local-variable
				ErrorDescription = ErrorDescription(); 
			EndTry;
		EndIf;
		FormCash.ObjectTables.Insert(AvailableType, PropertyTables);
		
	EndDo;
	
	TypeChoiceList.SortByPresentation();
	
EndProcedure

// Load new columns.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
&AtServerNoContext
Procedure LoadNewColumns(Form)
	
	ColumnsData = New Structure;
	
	TS_String = "TabularSections";
	Table_String = GetObjectTable(Form); // String
	
	MetaObject = Metadata.FindByType(GetObjectType(Form));
	MetaCharacteristics = MetaObject["Characteristics"]; // CharacteristicsDescriptions 
	MetaObjectTable = MetaObject[TS_String][Table_String]; // MetadataObjectTabularSection
	TableDataPath = StrReplace(MetaObjectTable.FullName(), "TabularSection.", "");
	
	TypeOption_Table = Undefined; // MetadataObject
	TypeOption_FieldRef = Undefined; // Field
	TypeOption_FieldFilter = Undefined; // Field
	TypeOption_FilterValue = Undefined; // Arbitrary
	For Each CharacteristicRecord In MetaCharacteristics Do
		If CharacteristicRecord.CharacteristicValues = MetaObjectTable Then
			TypeOption_Table = CharacteristicRecord.CharacteristicTypes;
			TypeOption_FieldRef = CharacteristicRecord.KeyField;
			TypeOption_FieldFilter = CharacteristicRecord.TypesFilterField;
			TypeOption_FilterValue = GetObjectProperty(CharacteristicRecord, "TypesFilterValue");
		EndIf;
	EndDo;
	
	AvailableItems = New Array; // Array of Arbitrary, Undefined 
	If Not TypeOption_Table = Undefined Then
		Query = New Query;
		
		Path = TypeOption_Table.FullName();
		If StrFind(Path, "TabularSection.") > 0 Then
			Path = StrReplace(Path, "TabularSection.", "");
		EndIf;
		
		Query.Text = "SELECT T." + TypeOption_FieldRef.Name + " AS Ref FROM " + Path + " AS T";
		If Not TypeOption_FieldFilter = Undefined Then
			Query.Text = Query.Text + Chars.CR +
				"WHERE T." + TypeOption_FieldFilter.Name + " = &FilterValue";
			Query.SetParameter("FilterValue", TypeOption_FilterValue);
		EndIf;  
		
		QuerySelection = Query.Execute().Select();
		While QuerySelection.Next() Do
			AvailableItems.Add(QuerySelection.Ref);
		EndDo;
	EndIf;
	
	Query = New Query;
	
	If AvailableItems.Count() = 0 Then
		Query.Text = StrTemplate(
		"SELECT DISTINCT
		|	Table.Property
		|INTO tmpProperties
		|FROM
		|	%1 AS Table
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmpProperties.Property AS Property,
		|	tmpProperties.Property.Presentation AS Presentation,
		|	tmpProperties.Property.ValueType AS ValueType,
		|	FALSE AS isAvailable,
		|	TRUE AS isExisting
		|FROM
		|	tmpProperties AS tmpProperties
		|
		|ORDER BY
		|	Property", TableDataPath);
	Else
		AvailableItems_Table = New ValueTable;
		ArrayType = New Array; // Array of Type
		ArrayType.Add(TypeOf(AvailableItems[0]));
		AvailableItems_Table.Columns.Add("Property", New TypeDescription(ArrayType));
		For Each AvailableItem In AvailableItems Do
			AvailableItems_Table.Add()["Property"] = AvailableItem;
		EndDo;
		Query.SetParameter("AvailableItems", AvailableItems_Table);
		Query.Text = StrTemplate(
		"SELECT
		|	AvailableItems.Property
		|INTO tmpAvailableItems
		|FROM
		|	&AvailableItems AS AvailableItems
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	Table.Property
		|INTO tmpExistingItems
		|FROM
		|	%1 AS Table
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ISNULL(tmpExistingItems.Property, tmpAvailableItems.Property) AS Property,
		|	ISNULL(tmpExistingItems.Property.Presentation, tmpAvailableItems.Property.Presentation) AS Presentation,
		|	ISNULL(tmpExistingItems.Property.ValueType, tmpAvailableItems.Property.ValueType) AS ValueType,
		|	NOT tmpAvailableItems.Property is Null AS isAvailable,
		|	NOT tmpExistingItems.Property is Null AS isExisting
		|FROM
		|	tmpAvailableItems AS tmpAvailableItems
		|		FULL JOIN tmpExistingItems AS tmpExistingItems
		|		ON tmpExistingItems.Property = tmpAvailableItems.Property
		|
		|ORDER BY
		|	Property,
		|	isAvailable DESC", TableDataPath);
	EndIf;
	
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		ItemRef = QuerySelection.Property; // AnyRef
		ItemKey = GetFieldKeyFromRef(ItemRef);
		ItemPresentation = QuerySelection.Presentation; // String
		ValueType = QuerySelection.ValueType; // TypeDescription
		isAvailable = QuerySelection.isAvailable; // Boolean
		isExisting = QuerySelection.isExisting; // Boolean
		ColumnsData.Insert(ItemKey, GetFieldDescription(
			ItemRef, ItemPresentation, ValueType, isAvailable, isExisting, ContainsValuesCollection(ItemRef, Form)));
	EndDo;
	
	FormCash = GetFormCash(Form);
	FormCash.ColumnsData = ColumnsData;
	
EndProcedure

&AtServer
Procedure LoadTableData()
	
	Ref_String = "Ref";
	Object_String = "Object";
	Property_String = "Property";
	Value_String = "Value";
	
	ColumnsData = GetFormCash(ThisObject).ColumnsData;
	SchemaAddress = GetFormCash(ThisObject).SchemaAddress;
	Schema = GetFromTempStorage(SchemaAddress); // DataCompositionSchema
	
	TemplateComposer = New DataCompositionTemplateComposer;
	DataCompositionTemplate = TemplateComposer.Execute(
		Schema, 
		ThisObject.DataSettingsComposer.GetSettings(), , , 
		Type("DataCompositionValueCollectionTemplateGenerator"));
	
	DataCompositionProcessor = New DataCompositionProcessor;
	DataCompositionProcessor.Инициализировать(DataCompositionTemplate);
	
	DataTree = New ValueTree();
	OutputProcessor = New DataCompositionResultValueCollectionOutputProcessor;
	OutputProcessor.SetObject(DataTree);
	OutputProcessor.Output(DataCompositionProcessor);
	
	ThisObject.PropertiesTable.Clear();
	For Each RowData In DataTree.Rows Do
		TableRecord = ThisObject.PropertiesTable.Add();
		DataRef = RowData[Ref_String]; // AnyRef
		TableRecord[Object_String] = DataRef;
		For Each RowProperty In RowData.Rows Do
			PropertyRef = RowProperty[Property_String]; // AnyRef
			If PropertyRef = Null Then
				Break;
			EndIf;
			PropertyKey = GetFieldKeyFromRef(PropertyRef);
			ColumnDescription = Undefined; // See GetFieldDescription
			If ColumnsData.Property(PropertyKey, ColumnDescription) Then
				If ColumnDescription.isCollection Then
					If TableRecord[PropertyKey] = Undefined Then
						TableRecord[PropertyKey] = New ValueList();
					EndIf;
					PropertyValues = TableRecord[PropertyKey]; // ValueList of Arbitrary, Undefined
					PropertyValues.Add(RowProperty[Value_String]);
				Else
					TableRecord[PropertyKey] = RowProperty[Value_String];
				EndIf;
				TableRecord[PropertyKey + "_old"] = TableRecord[PropertyKey];
			EndIf;
		EndDo;
		CheckRowModified(ThisObject, TableRecord);
	EndDo;
	
EndProcedure

#EndRegion

#Region SaveData

&AtServer
Procedure SaveAtServer()
	
	Property_String = "Property";
	Value_String = "Value";
	
	ModifiedRows = ThisObject.PropertiesTable.FindRows(New Structure("isModified", True));
	For Each Row In ModifiedRows Do
		
		ModifiedObject = Row.Object.GetObject();
		ModifiedTable = ModifiedObject[ThisObject.ObjectTable]; // TabularSection
		ModifiedTable.Clear();
		
		For Each ColumndKeyValue In GetFormCash(ThisObject).ColumnsData Do
			ColumnKey = ColumndKeyValue.Key; // String
			ColumnDescription = ColumndKeyValue.Value; // See GetFieldDescription
			
			ColumnValue = Row[ColumnKey]; // Arbitrary, Undefined
			If TypeOf(ColumnValue) = Type("ValueList") And ColumnValue.Count() = 0 Then
				ColumnValue = Undefined;
			EndIf;

			If TypeOf(ColumnValue) = Type("ValueList") Then
				For Each CollectionItem In ColumnValue Do
					NewRecord = ModifiedTable.Add();
					NewRecord[Property_String] = ColumnDescription.Ref;
					NewRecord[Value_String] = CollectionItem.Value;
				EndDo;
			ElsIf Not ColumnValue = Undefined Then
				NewRecord = ModifiedTable.Add();
				NewRecord[Property_String] = ColumnDescription.Ref;
				NewRecord[Value_String] = ColumnValue;
			EndIf;
		EndDo;
		
		ModifiedObject.Write();
	EndDo;
	
EndProcedure

#EndRegion
	
#Region Descriptions

// Get field description.
// 
// Parameters:
//  Ref - AnyRef - Ref
//  Presentation - String - Presentation
//  isAvailable - Boolean - Is available
//  isExisting - Boolean - Is existing
// 
// Returns:
//  Structure - Get field description:
// * Ref - AnyRef, Arbitrary -
// * Presentation - String, Arbitrary -
// * ValueType - TypeDescription, Arbitrary -
// * isAvailable - Boolean, Arbitrary -
// * isExisting - Boolean, Arbitrary -
// * isCollection - Boolean -
// * CollectionValueType - TypeDescription -
&AtServerNoContext
Function GetFieldDescription(Ref, Presentation, ValueType, isAvailable, isExisting, isCollection)
	Result = New Structure;
	Result.Insert("Ref", Ref);
	Result.Insert("Presentation", Presentation);
	Result.Insert("ValueType", ValueType);
	Result.Insert("isAvailable", isAvailable);
	Result.Insert("isExisting", isExisting);
	Result.Insert("isCollection", isCollection);
	Result.Insert("CollectionValueType", New TypeDescription(ValueType, "ValueList"));
	Return Result;
EndFunction

#EndRegion

#Region OtherFunction

// Get available types.
// 
// Returns:
//  Array of Type - Get available types
&AtServerNoContext
Function GetAvailableTypes()
	Return Metadata.DefinedTypes.typeAddPropertyOwners.Type.Types();
EndFunction

// Is chart of characteristic types.
// 
// Parameters:
//  ValueTypes - TypeDescription - Value types
// 
// Returns:
//  Boolean - Is chart of characteristic types
&AtServerNoContext
Function isChartOfCharacteristicTypes(ValueTypes)
	For Each ValueType In ValueTypes.Types() Do
		If ChartsOfCharacteristicTypes.AllRefsType().ContainsType(ValueType) Then
			Return True;
		EndIf;
	EndDo;
	Return False;
EndFunction

// Get object property.
// 
// Parameters:
//  Object - Arbitrary - Object
//  Property - String - Property
// 
// Returns:
//  Arbitrary, Undefined
&AtClientAtServerNoContext
Function GetObjectProperty(Object, Property)
	Try
		Return Object[Property];
	Except
		Return Undefined;
	EndTry;
EndFunction

// Get field key from ref.
// 
// Parameters:
//  Ref - AnyRef - Ref
// 
// Returns:
//  String - Get field key from ref
&AtClientAtServerNoContext
Function GetFieldKeyFromRef(Ref)
	Return StrReplace("Field_" + Ref.UUID(), "-", "");
EndFunction

// Contains values collection.
// 
// Parameters:
//  Property - AnyRef - Property
//  Form - ClientApplicationForm - Form
// 
// Returns:
//  Boolean - Contains values collection
&AtServerNoContext
Function ContainsValuesCollection(Property, Form)
	Return False;
EndFunction

#EndRegion

#EndRegion