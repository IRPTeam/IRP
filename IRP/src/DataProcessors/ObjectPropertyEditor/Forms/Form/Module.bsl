// @strict-types

#Region Form_Events

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	FormCash = GetFormCash(ThisObject);
	LoadMetadata(FormCash);
	
	RefsList = Parameters["RefsList"]; // Array, Undefined
	If TypeOf(RefsList) = Type("Array") Then
		TypeKey = TypeOf(RefsList[0]);
		TypeRecord = Items.ObjectType.ChoiceList.FindByValue(TypeKey);
		If Not TypeRecord = Undefined Then
			ThisObject["ObjectType"] = TypeKey;
			SetTablesList(ThisObject);
			If Not IsBlankString(GetObjectTable(ThisObject)) Then
				SetNewTable(ThisObject);
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
			SetNewTable(ThisObject);
		EndIf;
	EndIf;

EndProcedure

&AtClient
Procedure ObjectTableOnChange(Item)
	SetNewTable(ThisObject);
EndProcedure

#EndRegion

#Region Form_Commands

&AtClient
Procedure Refresh(Command)
	LoadTableData();
EndProcedure

#EndRegion

#Region Private

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
	
	AvailableTypes = Metadata.DefinedTypes.typeAddPropertyOwners.Type.Types();
	For Each AvailableType In AvailableTypes Do
		
		ItemPreffics = "";
		ItemPicture = Undefined;
		If Catalogs.AllRefsType().ContainsType(AvailableType) Then
			ItemPreffics = "(catalog) ";
			ItemPicture = PictureLib.Catalog;
		ElsIf Documents.AllRefsType().ContainsType(AvailableType) Then
			ItemPreffics = "(document) ";
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
// Parameters:
//  Form - ClientApplicationForm - Form
&AtClientAtServerNoContext
Procedure SetNewTable(Form)
	SetSourceSettings(Form);
	SetTableSettings(Form);
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
	DataSet.Name = "DataSet1";
	DataSet.DataSource = "DataSources";
	DataSet.Query = 
	"SELECT
	|	Table.Ref,
	|	Table.Property,
	|	Table.Value
	|FROM
	|	" + MetaObject.FullName() + "." + Table_String + " AS Table";
	
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
	LoadNewColumns(Form);
	
	PT_String = "PropertiesTable";
	
	Oldfields = New Array; // Array of FormField
	For Each FieldItem In Form.Items.PropertiesFields.ChildItems Do
		Oldfields.Add(FieldItem);
	EndDo;
	For Each FieldItem In Oldfields Do
		Form.Items.Delete(FieldItem);
	EndDo;
	
	OldAttributes = New Array; // Array of FormAttribute
	CurrentColumns = Form.GetAttributes(PT_String);
	For Each ColumnItem In CurrentColumns Do
		If ColumnItem.Name = "Object" Or ColumnItem.Name = "isModified" Then
			Continue;
		EndIf;
		OldAttributes.Add(ColumnItem);
	EndDo;
	Form.ChangeAttributes(, OldAttributes);
	
	NewAttributes = New Array; // Array of FormAttribute
	ColumnsData = GetFormCash(Form).ColumnsData;
	For Each ColumnItem In ColumnsData Do
		ColumnDescription = ColumnItem.Value; // See GetFieldDescription
		FormAttribute = New FormAttribute(
			ColumnItem.Key, 
			ColumnDescription.ValueType, 
			PT_String, 
			ColumnDescription.Presentation);
		NewAttributes.Add(FormAttribute);
	EndDo;
	Form.ChangeAttributes(NewAttributes);
	
	For Each ColumnItem In ColumnsData Do
		NewFormItem = Form.Items.Add(PT_String + ColumnItem.Key, Type("FormField"), Form.Items.PropertiesFields);
		NewFormItem.Type = FormFieldType.InputField;
		NewFormItem.DataPath = PT_String + "." + ColumnItem.Key;
	EndDo;
	
EndProcedure

#EndRegion

#Region LoadData

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
	
	AvailableItems_Table = New ValueTable;
	ArrayType = New Array; // Array of Type
	If AvailableItems.Count() = 0 Then
		ArrayType.Add(GetObjectType(Form));
	Else
		ArrayType.Add(TypeOf(AvailableItems[0]));
	EndIf;
	AvailableItems_Table.Columns.Add("Property", New TypeDescription(ArrayType));
	For Each AvailableItem In AvailableItems Do
		AvailableItems_Table.Add()["Property"] = AvailableItem;
	EndDo;
	
	Query = New Query;
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
	|	ISNULL(tmpAvailableItems.Property, tmpExistingItems.Property) AS Property,
	|	ISNULL(tmpAvailableItems.Property.Presentation, tmpExistingItems.Property.Presentation) AS Presentation,
	|	ISNULL(tmpAvailableItems.Property.ValueType, tmpExistingItems.Property.ValueType) AS ValueType,
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
	
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		ItemRef = QuerySelection.Property; // AnyRef
		ItemKey = StrReplace("Field_" + ItemRef.UUID(), "-", "");
		ItemPresentation = QuerySelection.Presentation; // String
		ValueType = QuerySelection.ValueType; // TypeDescription
		isAvailable = QuerySelection.isAvailable; // Boolean
		isExisting = QuerySelection.isExisting; // Boolean
		ColumnsData.Insert(ItemKey, GetFieldDescription(ItemRef, ItemPresentation, ValueType, isAvailable, isExisting));
	EndDo;
	
	FormCash = GetFormCash(Form);
	FormCash.ColumnsData = ColumnsData;
	
EndProcedure

&AtServer
Procedure LoadTableData()
	// TODO:
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
&AtServerNoContext
Function GetFieldDescription(Ref, Presentation, ValueType, isAvailable, isExisting)
	Result = New Structure;
	Result.Insert("Ref", Ref);
	Result.Insert("Presentation", Presentation);
	Result.Insert("ValueType", ValueType);
	Result.Insert("isAvailable", isAvailable);
	Result.Insert("isExisting", isExisting);
	Return Result;
EndFunction

#EndRegion

#Region OtherFunction

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

#EndRegion

#EndRegion