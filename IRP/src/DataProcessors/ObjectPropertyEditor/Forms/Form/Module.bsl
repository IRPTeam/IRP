// @strict-types

#Region Form_Events

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	FormCash = GetFormCash(ThisObject);
	FormCash.CountConditionalAppearance = ThisObject.ConditionalAppearance.Items.Count();
	FormCash.CountNewConditionalAppearance = ThisObject.ConditionalAppearance.Items.Count();
	
	LoadMetadata(FormCash);
	
	RefsList = Parameters.RefsList;
	If RefsList.Count() > 0 Then
		TypeKey = TypeOf(RefsList[0].Value);
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

// Properties table OnActivateField.
// 
// Parameters:
//  Item - FormTable - Item
&AtClient
Procedure PropertiesTableOnActivateField(Item)
	CurrentField = Item.CurrentItem.Name;
	AutoColor = Items.PropertiesTableObject.TitleBackColor;
	For Each TableField In Items.PropertiesFields.ChildItems Do
		If TableField.Name = CurrentField Then
			TableField.TitleBackColor = New Color(255, 255, 0);
		Else
			TableField.TitleBackColor = AutoColor;
		EndIf;
	EndDo;

EndProcedure

// Properties table value on change.
// 
// Parameters:
//  Item - FormField - Item
&AtClient
Procedure PropertiesTableValueOnChange(Item)
	RowValue = Items.PropertiesTable.CurrentData;
	If Not RowValue = Undefined Then
		CheckRowModified(ThisObject, RowValue);
	EndIf;
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
	CurrentFieldValue = Items.PropertiesTable.CurrentData[FieldName]; // Arbitrary, String, ValueList
	If GetFormCash(ThisObject).ColumnsData.Property(FieldName, FieldDescription) Then
		If TypeOf(CurrentFieldValue) = Type("ValueList") Then
			CurrentFieldValue.ValueType = FieldDescription.ValueType;
		ElsIf CurrentFieldValue = Undefined Then
			Item.TypeRestriction = FieldDescription.ValueType;
		EndIf;
	EndIf;
	
	If TypeOf(CurrentFieldValue) = Type("String") Then
		StandardProcessing = False;
		SelectedRows = New Array; // Array of Number
		SelectedRows.Add(Items.PropertiesTable.CurrentData.GetID());
		OpenForm("DataProcessor.ObjectPropertyEditor.Form.EditMultilineText", 
				New Structure("ExternalText", CurrentFieldValue), 
				ThisObject, , , ,
				New NotifyDescription("OnEditedMultilineTextEnd", 
					ThisObject, 
					New Structure("SelectedRows, FieldName", SelectedRows, FieldName)),
				FormWindowOpeningMode.LockOwnerWindow);
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
Procedure FieldSettings(Command)
	OpenForm("DataProcessor.ObjectPropertyEditor.Form.FieldSettings", 
		New Structure("ColumnsData", GetFormCash(ThisObject).ColumnsData), 
		ThisObject, , , ,
		New NotifyDescription("FieldSettingsEnd", ThisObject),
		FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure MarkOffAll(Command)
	For Each TableRow In ThisObject.PropertiesTable Do
		TableRow.Marked = False;
	EndDo;
EndProcedure

&AtClient
Procedure MarkOnAll(Command)
	For Each TableRow In ThisObject.PropertiesTable Do
		TableRow.Marked = True;
	EndDo;
EndProcedure

&AtClient
Procedure MarkSelectedRows(Command)
	For Each RowIndex In Items.PropertiesTable.SelectedRows Do
		RowIndex = RowIndex; // Number
		Row = ThisObject.PropertiesTable.Get(RowIndex);
		Row.Marked = True; 
	EndDo;
EndProcedure

&AtClient
Procedure DeleteMarkedValue(Command)
	
	Field = Items.PropertiesTable.CurrentItem.Name; // String
	FieldDescription = GetFormCash(ThisObject).ColumnsData[Field]; // See GetFieldDescription
	
	MarkedRows = ThisObject.PropertiesTable.FindRows(New Structure("Marked", True));
	For Each MarkedRow In MarkedRows Do
		If FieldDescription.isCollection Then
			SetNewValueToRowField(ThisObject, MarkedRow, Field, New ValueList());
		Else
			SetNewValueToRowField(ThisObject, MarkedRow, Field, Undefined);
		EndIf;
	EndDo;

EndProcedure

&AtClient
Procedure SetValueToEmptyCells(Command)
	
	If Items.PropertiesTable.CurrentItem.Parent = Items.PropertiesTable Then
		Return;
	EndIf;
	
	Field = Items.PropertiesTable.CurrentItem.Name; // String
	FieldDescription = GetFormCash(ThisObject).ColumnsData[Field]; // See GetFieldDescription
	
	SelectedRows = New Array; // Array of Number
	
	For Each Row In ThisObject.PropertiesTable Do
		RowValue = Row[Field]; // Arbitrary, ValueList
		If FieldDescription.isCollection Then
			If RowValue = Undefined Or (TypeOf(RowValue) = Type("ValueList") And RowValue.Count() = 0) Then
				SelectedRows.Add(Row.GetID());
			EndIf;
		Else
			If RowValue = Undefined Then
				SelectedRows.Add(Row.GetID());
			EndIf;
		EndIf;
	EndDo;

	SettingNewValueForRows(SelectedRows);

EndProcedure

&AtClient
Procedure SetValueForMarkedRows(Command)
	
	If Items.PropertiesTable.CurrentItem.Parent = Items.PropertiesTable Then
		Return;
	EndIf;
	
	SelectedRows = New Array; // Array of Number
	MarkedRows = ThisObject.PropertiesTable.FindRows(New Structure("Marked", True));
	For Each MarkedRow In MarkedRows Do
		RowIndex = MarkedRow.GetID(); // Number
		SelectedRows.Add(RowIndex);
	EndDo;

	SettingNewValueForRows(SelectedRows);

EndProcedure

&AtClient
Procedure CopyThisRowValueToMarkedRows(Command)
	
	CurrentRow = Items.PropertiesTable.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	RowDescription = New Array; // Array of Structure
	ColumnsData = GetFormCash(ThisObject).ColumnsData;
	For Each ColumnKeyValue In ColumnsData Do
		FieldName = ColumnKeyValue.Key; // String
		FieldDescription = ColumnKeyValue.Value; // See GetFieldDescription
		FieldData = New Structure;
		FieldData.Insert("Property", FieldDescription.Ref);
		FieldData.Insert("Value", CurrentRow[FieldName]);
		FieldData.Insert("isCollection", FieldDescription.isCollection);
		FieldData.Insert("FieldName", FieldName);
		RowDescription.Add(FieldData);
	EndDo;
	
	OpenForm("DataProcessor.ObjectPropertyEditor.Form.PropertyPackEditor", 
		New Structure("RowData", RowDescription), 
		ThisObject, 
		UUID, , ,
		New NotifyDescription("CopyThisRowValueToMarkedRowsEnd", ThisObject), 
		FormWindowOpeningMode.LockWholeInterface);
	
EndProcedure

#EndRegion

#Region NotifyDescriptions

// On edited multiline text end.
// 
// Parameters:
//  ChangedText - String, Undefined - Changed text
//  AddInfo - Structure - Add info:
//		* FieldName - String -
//		* SelectedRows - Array of Number -
&AtClient
Procedure OnEditedMultilineTextEnd(ChangedText, AddInfo) Export
	If ValueIsFilled(ChangedText) Then
		For Each RowKey In AddInfo.SelectedRows Do
			CurrentRow = ThisObject.PropertiesTable.FindByID(RowKey);
			SetNewValueToRowField(ThisObject, CurrentRow, AddInfo.FieldName, ChangedText);
		EndDo;
	EndIf;
EndProcedure

// Set value for selected rows end.
// 
// Parameters:
//  ChangedValue - Arbitrary - Changed value
//  AddInfo - Structure - Add info:
//		* FieldName - String -
//		* SelectedRows - Array of Number -
&AtClient
Procedure SetValueForSelectedRowsEnd(ChangedValue, AddInfo) Export
	If Not ChangedValue = Undefined Then
		For Each RowKey In AddInfo.SelectedRows Do
			CurrentRow = ThisObject.PropertiesTable.FindByID(RowKey);
			SetNewValueToRowField(ThisObject, CurrentRow, AddInfo.FieldName, ChangedValue);
		EndDo;
	EndIf;
EndProcedure

// Set value for selected rows end.
// 
// Parameters:
//  RowData - Array of Structure:
// 		* FieldName - String -
// 		* Value - Undefined -
//  AddInfo - Structure
&AtClient
Procedure CopyThisRowValueToMarkedRowsEnd(RowData, AddInfo) Export
	If Not RowData = Undefined Then
		MarkedRows = ThisObject.PropertiesTable.FindRows(New Structure("Marked", True));
		For Each MarkedRow In MarkedRows Do
			For Each FieldData In RowData Do
				SetNewValueToRowField(ThisObject, MarkedRow, FieldData.FieldName, FieldData.Value);
			EndDo;
		EndDo;
	EndIf;
EndProcedure

// Field settings end.
// 
// Parameters:
//  Result - Boolean, Undefined - Result
//  AddInfo - Undefined - Add info
&AtClient
Procedure FieldSettingsEnd(Result, AddInfo) Export
	If Result = True Then
		SetPropertyAvailability();
	EndIf;
EndProcedure	

#EndRegion

#Region Private

&AtClientAtServerNoContext
Procedure SetNewValueToRowField(Form, Row, Field, Val NewValue)
	
	If TypeOf(NewValue) = Type("ValueList") Then
		CopyValy = New ValueList; // ValueList of String, Number, Arbitrary
		For Each ListItem In NewValue Do
			ItemValue = ListItem.Value; // String, Number, Arbitrary
			CopyValy.Add(ItemValue);
		EndDo;
		CopyValy.ValueType = NewValue.ValueType;
		NewValue = CopyValy; 
	EndIf;
	
	FormCash = GetFormCash(Form);
	FieldDescription = FormCash.ColumnsData[Field]; // See GetFieldDescription
	
	If FormCash.ConstraintName = "" Then
		Row[Field] = NewValue;
	Else
		PropertyValues = FormCash.PropertyConstraints.Get(Row.Constraint); // Array of AnyRef
		If Not PropertyValues.Find(FieldDescription.Ref) = Undefined Then
			Row[Field] = NewValue;
		EndIf;
	EndIf;
	
	CheckRowModified(Form, Row);
	
EndProcedure

// Check row modified.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  RowValue - FormDataStructure, FormDataCollectionItem, FormDataTreeItem, Undefined - Row value
&AtClientAtServerNoContext
Procedure CheckRowModified(Form, RowValue)
	
	If RowValue = Undefined Then
		Return;
	EndIf;
	
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
// * CountConditionalAppearance - Number - Number of predefined appearance
// * CountNewConditionalAppearance - Number - Number of appearances after table settings
// * ConstraintName - String - Name of ref' property for constraint
// * PropertyConstraints - Map - Set properties constraints:
//	** Key - CatalogRef - Ref of properties constraint
//	** Value - Array of ChartOfCharacteristicTypesRef - Array of available properties 
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
	FormCash.Insert("CountNewConditionalAppearance", 0);
	FormCash.Insert("ConstraintName", "");
	FormCash.Insert("PropertyConstraints", New Map);
	
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

// Setting new value for rows.
// 
// Parameters:
//  SelectedRows - Array of Number - Selected rows
&AtClient
Procedure SettingNewValueForRows(SelectedRows)

	RowValue = Items.PropertiesTable.CurrentData;
	Field = Items.PropertiesTable.CurrentItem.Name; // String
	CurrentRowValue = RowValue[Field]; // String, Number, Arbitrary, ValueList
	
	FieldDescription = GetFormCash(ThisObject).ColumnsData[Field]; // See GetFieldDescription
	ClearType = New TypeDescription(FieldDescription.ValueType, , "Undefined");
	If FieldDescription.isCollection Then
		If Not TypeOf(CurrentRowValue) = Type("ValueList") Then
			NewValue = New ValueList; // ValueList of String, Number, Arbitrary
			If Not CurrentRowValue = Undefined Then
				NewValue.Add(CurrentRowValue);
			EndIf;
			NewValue.ValueType = ClearType;
			CurrentRowValue = NewValue;
		EndIf;
	Else
		If CurrentRowValue = Undefined Then
			CurrentRowValue = ClearType.AdjustValue();
		EndIf;
	EndIf;
	
	If TypeOf(CurrentRowValue) = Type("String") Then
		OpenForm("DataProcessor.ObjectPropertyEditor.Form.EditMultilineText", 
			New Structure("ExternalText", CurrentRowValue), 
			ThisObject, , , ,
			New NotifyDescription("OnEditedMultilineTextEnd", 
				ThisObject, 
				New Structure("SelectedRows, FieldName", SelectedRows, Field)),
			FormWindowOpeningMode.LockOwnerWindow);
			
	ElsIf TypeOf(CurrentRowValue) = Type("ValueList") Then
		OpenForm("DataProcessor.ObjectPropertyEditor.Form.EditValueList", 
			New Structure("List, ItemType", CurrentRowValue, ClearType), 
			ThisObject, , , ,
			New NotifyDescription("SetValueForSelectedRowsEnd", 
				ThisObject, 
				New Structure("SelectedRows, FieldName", SelectedRows, Field)),
			FormWindowOpeningMode.LockOwnerWindow);
			
	ElsIf Not IsBlankString(FieldDescription.ValueChoiceForm) Then
		OpenFormParameters = New Structure;
		OpenFormParameters.Insert("Key", CurrentRowValue);
		OpenFormParameters.Insert("Filter", New Structure("Owner", FieldDescription.Ref));
		OpenForm(FieldDescription.ValueChoiceForm, 
			OpenFormParameters, 
			ThisObject, , , ,
			New NotifyDescription("SetValueForSelectedRowsEnd", 
				ThisObject, 
				New Structure("FieldName, SelectedRows", Field, SelectedRows)), 
			FormWindowOpeningMode.LockOwnerWindow);
			
	Else
		ShowInputValue(
			New NotifyDescription("SetValueForSelectedRowsEnd", 
				ThisObject, 
				New Structure("FieldName, SelectedRows", Field, SelectedRows)), 
			CurrentRowValue, 
			"Input new value", 
			ClearType);
	EndIf;
	
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
&AtServer
Procedure SetNewTable()
	SetPropertiesConstraint(ThisObject);
	SetSourceSettings(ThisObject);
	SetTableSettings(ThisObject);
EndProcedure

&AtServerNoContext
Procedure SetPropertiesConstraint(Form)
	FormCash = GetFormCash(Form);
	FormCash.ConstraintName = GetConstraintName(GetObjectType(Form), GetObjectTable(Form)); 
EndProcedure	
	
// Set source settings.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
&AtServerNoContext
Procedure SetSourceSettings(Form)
	
	DCSchema = GetDCSchema(Form);
		
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
	SelectionItems.Add(Type("DataCompositionSelectedField")).Field = New DataCompositionField("Constraint");
	
    DataSettingsComposer.Settings.Structure.Clear();
    RefGroup = DataSettingsComposer.Settings.Structure.Add(Type("DataCompositionGroup"));
	RefGroup.GroupFields.Items.Add(Type("DataCompositionGroupField")).Field = New DataCompositionField("Ref");
	RefGroup.Selection.Items.Add(Type("DataCompositionSelectedField")).Field = New DataCompositionField("Ref");
	RefGroup.GroupFields.Items.Add(Type("DataCompositionGroupField")).Field = New DataCompositionField("Constraint");
	RefGroup.Selection.Items.Add(Type("DataCompositionSelectedField")).Field = New DataCompositionField("Constraint");
	DetailGroup = RefGroup.Structure.Add(Type("DataCompositionGroup"));
	DetailGroup.Selection.Items.Add(Type("DataCompositionAutoSelectedField"));
    
EndProcedure

// Get DCSchema.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
// 
// Returns:
//  DataCompositionSchema
&AtServerNoContext
Function GetDCSchema(Form)

	TS_String = "TabularSections";
	Table_String = GetObjectTable(Form); // String
	
	FormCash = GetFormCash(Form);
	 
	MetaObject = Metadata.FindByType(GetObjectType(Form));
	MetaObjectTable = MetaObject[TS_String][Table_String]; // MetadataObjectTabularSection
	
	DCSchema = New DataCompositionSchema;

	DS = DCSchema.DataSources.Add();
	DS.Name = "DataSources";
	DS.DataSourceType = "Local";
	
	DataSet = DCSchema.DataSets.Add(Type("DataCompositionSchemaDataSetQuery"));
	DataSet.Name = "DataSet";
	DataSet.DataSource = "DataSources";
	DataSet.Query = StrTemplate(
		"SELECT
		|	Table.Ref,
		|	%4 As Constraint,
		|	Attributes.Property,
		|	Attributes.Value
		|FROM
		|	%1.%2 AS Attributes
		|		FULL JOIN %3 AS Table
		|		ON Attributes.Ref = Table.Ref", 
		MetaObject.FullName(), 
		Table_String, 
		MetaObject.FullName(),
		?(IsBlankString(FormCash.ConstraintName), "Undefined", "Table.Ref." + FormCash.ConstraintName));
	
	DataField = DataSet.Fields.Add(Type("DataCompositionSchemaDataSetField"));
	DataField.Field = "Ref";
	DataField.DataPath = "Ref";
	DataField.Title = "Ref";
		
	DataField = DataSet.Fields.Add(Type("DataCompositionSchemaDataSetField"));
	DataField.Field = "Property";
	DataField.DataPath = "Property";
	DataField.Title = MetaObjectTable.Attributes.Property.Synonym;
	DataField.UseRestriction.Condition = True;
	DataField.AttributeUseRestriction.Condition = True;
		
	DataField = DataSet.Fields.Add(Type("DataCompositionSchemaDataSetField"));
	DataField.Field = "Value";
	DataField.DataPath = "Value";
	DataField.Title = MetaObjectTable.Attributes.Value.Synonym;
	DataField.UseRestriction.Condition = True;
	DataField.AttributeUseRestriction.Condition = True;
	
	DataField = DataSet.Fields.Add(Type("DataCompositionSchemaDataSetField"));
	DataField.Field = "Constraint";
	DataField.DataPath = "Constraint";
	DataField.UseRestriction.Condition = True;
	DataField.AttributeUseRestriction.Condition = True;
		
	Return DCSchema;
EndFunction

// Set refs to filter.
// 
// Parameters:
//  RefsList - ValueList of AnyRef 
//  DataSettingsComposer - DataCompositionSettingsComposer - Data settings composer
&AtClientAtServerNoContext
Procedure SetRefsToFilter(RefsList, DataSettingsComposer)
	RefsFilter = DataSettingsComposer.Settings.Filter.Items.Add(Type("DataCompositionFilterItem"));
	RefsFilter.LeftValue = New DataCompositionField("Ref");
	RefsFilter.ComparisonType  = DataCompositionComparisonType.InList;
	//@skip-warning
	RefsFilter.RightValue = RefsList;
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
		If ColumnItem.Name = "Object" 
				Or ColumnItem.Name = "Constraint"
				Or ColumnItem.Name = "Marked"
				Or ColumnItem.Name = "isModified" Then
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
		
		AddFormItemProperties(NewFormItem, ColumnDescription);
		
		CreateConditionalAppearance(Form, NewFormItem, ColumnDescription.isCollection);
	EndDo;
	
	GetFormCash(Form).CountNewConditionalAppearance = Form.ConditionalAppearance.Items.Count();
	
EndProcedure

// Add form item properties.
// 
// Parameters:
//  NewFormItem - FormFieldExtensionForACalendarField, FormFieldExtensionForACheckBoxField, FormFieldExtensionForADendrogramField, FormFieldExtensionForAGraphicalSchemaField, FormFieldExtensionForASpreadsheetDocumentField, FormExtensionForAHTMLDocumentField, FormFieldExtensionForAPictureField, FormFieldExtensionForATextDocument, FormFieldExtensionForAGeographicalSchemaField, FormFieldExtensionForATrackBarField, FormFieldExtensionForALabelField, FormFieldExtensionForATextBox, FormFieldExtensionForARadioButtonField, FormFieldExtensionForAPlanner, FormField, FormFieldExtensionForAChartField, FormFieldExtensionForAPeriodField, FormFieldExtensionForAProgressBarField, FormFieldExtensionForAGanttChartField, FormFieldExtensionForAFormattedDocument - New form item
//  ColumnDescription - See GetFieldDescription
&AtServerNoContext
Procedure AddFormItemProperties(NewFormItem, ColumnDescription)
	If Not ColumnDescription.isCollection And ColumnDescription.ValueType.ContainsType(Type("String")) Then
		NewFormItem.ChoiceButton = True;
	EndIf;
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
		ConditionalAppearanceItem.Appearance.SetParameterValue("BackColor", WebColors.LightPink);
		//@skip-warning
		ConditionalAppearanceItem.Appearance.SetParameterValue("Text", StrTemplate("<%1>", R().Form_002));
		FilterItem = ConditionalAppearanceItem.Filter.Items.Add(Type("DataCompositionFilterItem"));
		FilterItem.ComparisonType = DataCompositionComparisonType.Equal;
		FilterItem.LeftValue = New DataCompositionField(NewFormItem.DataPath + "_modified");
		//@skip-warning
		FilterItem.RightValue = 2; // Now zero quantity, but before more
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
		FilterItem.RightValue = 3; // Quantity has changed
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
			//@skip-warning
			TypeOption_FilterValue = CharacteristicRecord.TypesFilterValue;
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
			//@skip-warning
			AvailableItems_Table.Add().Property = AvailableItem;
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
		If Not ValueIsFilled(ItemRef) Then
			Continue;
		EndIf;
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
	Constraint_String = "Constraint";
	
	ColumnsData = GetFormCash(ThisObject).ColumnsData;
	SchemaAddress = GetFormCash(ThisObject).SchemaAddress;
	Schema = GetFromTempStorage(SchemaAddress); // DataCompositionSchema
	
	TemplateComposer = New DataCompositionTemplateComposer;
	DataCompositionTemplate = TemplateComposer.Execute(
		Schema, 
		ThisObject.DataSettingsComposer.GetSettings(), , , 
		Type("DataCompositionValueCollectionTemplateGenerator"));
	
	DataCompositionProcessor = New DataCompositionProcessor;
	DataCompositionProcessor.Initialize(DataCompositionTemplate);
	
	DataTree = New ValueTree();
	OutputProcessor = New DataCompositionResultValueCollectionOutputProcessor;
	OutputProcessor.SetObject(DataTree);
	OutputProcessor.Output(DataCompositionProcessor);
	
	ThisObject.PropertiesTable.Clear();
	For Each RowData In DataTree.Rows Do
		TableRecord = ThisObject.PropertiesTable.Add();
		DataRef = RowData[Ref_String]; // AnyRef
		ConstraintRef = RowData[Constraint_String]; // AnyRef
		TableRecord[Object_String] = DataRef;
		TableRecord[Constraint_String] = ConstraintRef;
		For Each RowProperty In RowData.Rows Do
			PropertyRef = ReadPropertyFromTreeRow(RowProperty);
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
					PropertyValues.Add(ReadPropertyValueFromTreeRow(RowProperty, PropertyRef));
				Else
					TableRecord[PropertyKey] = ReadPropertyValueFromTreeRow(RowProperty, PropertyRef);
				EndIf;
				TableRecord[PropertyKey + "_old"] = TableRecord[PropertyKey];
			EndIf;
		EndDo;
		CheckRowModified(ThisObject, TableRecord);
	EndDo;
	
	LoadConstraints();
	
	SetPropertyAvailability();
	
EndProcedure

&AtServer
Procedure LoadConstraints()
	
	String_Value = "Value";
	String_Ref = "Ref";
	
	FormCash = GetFormCash(ThisObject);
	FormCash.PropertyConstraints.Clear();
	
	If IsBlankString(FormCash.ConstraintName) Then
		Return;
	EndIf;
	
	ConstraintTree = GetConstraintTree(
		GetObjectType(ThisObject), 
		GetObjectTable(ThisObject),
		ThisObject.PropertiesTable.Unload(, "Constraint").UnloadColumn(0));
		
	If ConstraintTree = Undefined Then
		Return;
	EndIf;
	
	For Each ConstraintRow In ConstraintTree.Rows Do
		ConstraintValues = New Array; // Array of AnyRef
		For Each ValueRow In ConstraintRow.Rows Do
			ValueValue = ValueRow[String_Value]; // AnyRef
			ConstraintValues.Add(ValueValue);
		EndDo;
		FormCash.PropertyConstraints.Insert(ConstraintRow[String_Ref], ConstraintValues);
	EndDo;

EndProcedure

&AtServer
Procedure SetPropertyAvailability()
	
	FormCash = GetFormCash(ThisObject);
	If FormCash.ConstraintName = "" Then
		Return;
	EndIf;
	
	AllAvailableProperty = New Array; // Array of AnyRef
	PropertyNames = New Map;
	
	ConstraintTable = ThisObject.PropertiesTable.Unload(, "Constraint");
	ConstraintTable.GroupBy("Constraint");
	
	For Each ConstraintRecord In ConstraintTable Do
		ConstraintValues = FormCash.PropertyConstraints.Get(ConstraintRecord.Constraint); // Array of AnyRef
		If TypeOf(ConstraintValues) = Type("Array") Then
			For Each Constraint In ConstraintValues Do
				If AllAvailableProperty.Find(Constraint) = Undefined Then
					AllAvailableProperty.Add(Constraint);
				EndIf;
			EndDo;
		EndIf;
	EndDo;
	
	For Each ColumndKeyValue In FormCash.ColumnsData Do
		ColumnName = ColumndKeyValue.Key; // String
		ColumnDescription = ColumndKeyValue.Value; // See GetFieldDescription
		Items.Find(ColumnName).Visible = 
			ColumnDescription.isVisible And Not (AllAvailableProperty.Find(ColumnDescription.Ref) = Undefined);
		PropertyNames.Insert(ColumnDescription.Ref, ColumnName);
	EndDo;

	ConditionalAppearanceCount = FormCash.CountNewConditionalAppearance;
	While ThisObject.ConditionalAppearance.Items.Count() > ConditionalAppearanceCount Do
		LastItem = ThisObject.ConditionalAppearance.Items.Get(ThisObject.ConditionalAppearance.Items.Count() - 1);
		ThisObject.ConditionalAppearance.Items.Delete(LastItem);
	EndDo;
	
	For Each ConstraintRecord In ConstraintTable Do
		If Not ValueIsFilled(ConstraintRecord.Constraint) Then
			Continue;
		EndIf;
		ConstraintValues = FormCash.PropertyConstraints.Get(ConstraintRecord.Constraint); // Array of AnyRef
		If ConstraintValues.Count() < PropertyNames.Count() Then
			ConditionalAppearanceItem = ThisObject.ConditionalAppearance.Items.Add();
			ConditionalAppearanceItem.Appearance.SetParameterValue("BackColor", WebColors.LightGray);
			ConditionalAppearanceItem.Appearance.SetParameterValue("ReadOnly", True);
			FilterItem = ConditionalAppearanceItem.Filter.Items.Add(Type("DataCompositionFilterItem"));
			FilterItem.ComparisonType = DataCompositionComparisonType.Equal;
			FilterItem.LeftValue = New DataCompositionField("PropertiesTable.Constraint");
			//@skip-warning
			FilterItem.RightValue = ConstraintRecord.Constraint;
			FilterItem.Use = True;
			For Each PropertyKeyValue In PropertyNames Do
				If ConstraintValues.Find(PropertyKeyValue.Key) = Undefined Then
					AppearanceField = ConditionalAppearanceItem.Fields.Items.Add();
					AppearanceField.Field = New DataCompositionField(PropertyKeyValue.Value);
					AppearanceField.Use = True;
				EndIf;
			EndDo;
		EndIf;
	EndDo;

EndProcedure

// Read property from Tree Row.
// 
// Parameters:
//  TreeRow - ValueTreeRow - TableRow:
//  * Property - ChartOfCharacteristicTypesRef.AddAttributeAndProperty, AnyRef, Arbitrary - Property
// 
// Returns:
//  ChartOfCharacteristicTypesRef.AddAttributeAndProperty, AnyRef, Arbitrary
&AtServer
Function ReadPropertyFromTreeRow(TreeRow)
	Return TreeRow.Property;
EndFunction

// Read property value from Tree Row.
// 
// Parameters:
//  TreeRow - ValueTreeRow - TableRow:
//  * Value - Characteristic.AddAttributeAndProperty, Arbitrary, Undefined - 
//  Property - ChartOfCharacteristicTypesRef.AddAttributeAndProperty, AnyRef, Arbitrary - Property
// 
// Returns:
//  Characteristic.AddAttributeAndProperty, Arbitrary, Undefined - Value
&AtServer
Function ReadPropertyValueFromTreeRow(TreeRow, Property)
	Return TreeRow.Value;
EndFunction

#EndRegion

#Region SaveData

&AtServer
Procedure SaveAtServer()
	
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
					WritePropertyValue(ModifiedTable, ColumnDescription.Ref, CollectionItem.Value);
				EndDo;
			ElsIf Not ColumnValue = Undefined Then
				WritePropertyValue(ModifiedTable, ColumnDescription.Ref, ColumnValue);
			EndIf;
		EndDo;
		
		ModifiedObject.Write();
	EndDo;
	
EndProcedure

// Write property value to Table.
// 
// Parameters:
//  Table - TabularSection, CatalogTabularSection.ItemKeys.AddAttributes - Table
//  Property - ChartOfCharacteristicTypesRef.AddAttributeAndProperty, AnyRef, Arbitrary - Property
//  Value - Characteristic.AddAttributeAndProperty, Arbitrary, Undefined - Value
&AtServer
Procedure WritePropertyValue(Table, Property, Value)
	NewRecord = Table.Add();
	NewRecord.Property = Property;
	NewRecord.Value = Value;
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
// * isVisible - Boolean, Arbitrary -
// * isCollection - Boolean -
// * CollectionValueType - TypeDescription -
// * ValueChoiceForm - String -
&AtServerNoContext
Function GetFieldDescription(Ref, Presentation, ValueType, isAvailable, isExisting, isCollection)
	Result = New Structure;
	Result.Insert("Ref", Ref);
	Result.Insert("Presentation", Presentation);
	Result.Insert("ValueType", ValueType);
	Result.Insert("isAvailable", isAvailable);
	Result.Insert("isExisting", isExisting);
	Result.Insert("isVisible", True);
	Result.Insert("isCollection", isCollection);
	Result.Insert("CollectionValueType", New TypeDescription(ValueType, "ValueList"));
	Result.Insert("ValueChoiceForm", "");
	
	EmptyValue = ValueType.AdjustValue(); // CatalogRef
	If Catalogs.AllRefsType().ContainsType(TypeOf(EmptyValue)) Then
		ValueMetadata = EmptyValue.Metadata();
		If Not ValueMetadata.DefaultChoiceForm = Undefined And ValueMetadata.Owners.Count() > 0 Then
			Result.Insert("ValueChoiceForm", ValueMetadata.DefaultChoiceForm.FullName());
		EndIf;
	EndIf;
	
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

// Get constraint name.
// 
// Parameters:
//  ObjectType - Type - Object type
//  ObjectTable - String - Object table
// 
// Returns:
//  String - Get constraint name
&AtServerNoContext
Function GetConstraintName(ObjectType, ObjectTable)
	
	If ObjectType = Type("CatalogRef.ItemKeys") And ObjectTable = "AddAttributes" Then
		Return "Item.ItemType";
	Else
		Return "";
	EndIf;
	
EndFunction

// Get constraint tree.
// 
// Parameters:
//  ObjectType - Type - Object type
//  ObjectTable - String - Object table
//  ConstraintRefs - AnyRef, Arbitrary - Constraint refs
// 
// Returns:
//  ValueTree
//		* Ref - AnyRef
//		* Value - AnyRef
&AtServerNoContext
Function GetConstraintTree(ObjectType, ObjectTable, ConstraintRefs)
	
	If ObjectType = Type("CatalogRef.ItemKeys") And ObjectTable = "AddAttributes" Then
		Query = New Query(
		"SELECT DISTINCT
		|	ItemTypesAvailableAttributes.Ref AS Ref,
		|	ItemTypesAvailableAttributes.Attribute AS Value
		|FROM
		|	Catalog.ItemTypes.AvailableAttributes AS ItemTypesAvailableAttributes
		|WHERE
		|	ItemTypesAvailableAttributes.Ref IN (&Refs)
		|TOTALS
		|BY
		|	Ref");
		Query.SetParameter("Refs", ConstraintRefs);
		Return Query.Execute().Unload(QueryResultIteration.ByGroups);
	Else
		Return Undefined;
	EndIf;
	
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