// @strict-types

// Get
//
// Parameters:
//  DynamicList - DynamicList - Dynamic list
//  ListName - String - List name
//  Form - ClientApplicationForm - Form
// 
// Returns:
//  Structure:
//   * QuerySchema - QuerySchema - Query schema
//   * DynamicList - DynamicList - Dynamic list
//   * ListName - String - Form table name
//   * Form - ClientApplicationForm - Form
//   * Fields - Array of Structure:
//    ** Column - QuerySchemaColumn -
//    ** Synonym - String - 
//    ** Alias - String - 
//    ** Visible - Boolean -
//    ** AddToFormList - Boolean -
Function Get(DynamicList, ListName = Undefined, Form = Undefined) Export
	FormQueryText = DynamicList.QueryText;
	MainAttributeTable = DynamicList.MainTable;
	If Not DynamicList.CustomQuery Then
		FormQueryText = "Select _MainTable.* From " + MainAttributeTable + " AS _MainTable";
	EndIf;
	
	QuerySchema = New QuerySchema;
	QuerySchema.SetQueryText(FormQueryText);
	
	Result = New Structure;
	Result.Insert("QuerySchema", QuerySchema);
	Result.Insert("DynamicList", DynamicList);
	Result.Insert("Fields", New Array);
	Result.Insert("ListName", ListName);
	Result.Insert("Form", Form);
	
	Return Result;
EndFunction

// Set.
// 
// Parameters:
//  QuerySchemaAPI - See Get
Procedure Set(QuerySchemaAPI) Export
	QueryText = QuerySchemaAPI.QuerySchema.GetQueryText();
	MainAttributeTable = QuerySchemaAPI.DynamicList.MainTable;

	QuerySchemaAPI.DynamicList.QueryText = QueryText;
	QuerySchemaAPI.DynamicList.MainTable = MainAttributeTable;
	
	For Each Column In QuerySchemaAPI.Fields Do
		If Not Column.AddToFormList OR QuerySchemaAPI.Form = Undefined Then
			Continue;
		EndIf;
		
		NewColumn = QuerySchemaAPI.Form.Items.Add(QuerySchemaAPI.ListName + Column.Alias, Type("FormField"), QuerySchemaAPI.Form.Items[QuerySchemaAPI.ListName]);
		NewColumn.Title = Column.Synonym;
		NewColumn.DataPath = QuerySchemaAPI.ListName + "." + Column.Alias;
		NewColumn.Visible = Column.Visible;
		If Column.Column.ValueType.ContainsType(Type("Boolean")) Then
			NewColumn.Type = FormFieldType.CheckBoxField;
		EndIf;
	EndDo;
EndProcedure

// Add field.
// 
// Parameters:
//  QuerySchemaAPI - See Get
//  Path - String - Path, ex "Number"
//  Alias - String - Alias
//  Synonym - String - Synonym
//  AddToFormList - Boolean - Add to form list
//  Visible - Boolean - Visible on form
// 
// Returns:
//  QuerySchemaColumn
Function AddField(QuerySchemaAPI, Path, Alias = "", Synonym = "", AddToFormList = False, Visible = True) Export
	QueryBatch = QuerySchemaAPI.QuerySchema.QueryBatch[QuerySchemaAPI.QuerySchema.QueryBatch.Count() - 1];
	Operator = QueryBatch.Operators[QueryBatch.Operators.Count() - 1];
	Field = Operator.SelectedFields.Find(Path);
	If Field = Undefined Then
		Field = Operator.SelectedFields.Add(Path);
	EndIf;

	Column = QueryBatch.Columns.Find(Field);
	If Not IsBlankString(Alias) Then
		Column.Alias = Alias;
	EndIf;

	Str = New Structure;
	Str.Insert("Column", Column);
	Str.Insert("Synonym", Synonym);
	Str.Insert("AddToFormList", AddToFormList);
	Str.Insert("Visible", Visible);
	Str.Insert("Alias", Column.Alias);
	
	QuerySchemaAPI.Fields.Add(Str);

	Return Column;
EndFunction

// Add filter.
// 
// Parameters:
//  QuerySchemaAPI - See Get
//  Filter - String - Filter, ex "Number = &Number", "Posted"
Procedure AddFilter(QuerySchemaAPI, Filter) Export
	QueryBatch = QuerySchemaAPI.QuerySchema.QueryBatch[QuerySchemaAPI.QuerySchema.QueryBatch.Count() - 1];
	Operator = QueryBatch.Operators[QueryBatch.Operators.Count() - 1];
	Operator.Filter.Add(Filter);
EndProcedure

// Clear filter.
// 
// Parameters:
//  QuerySchemaAPI - See Get
Procedure ClearFilter(QuerySchemaAPI) Export
	QueryBatch = QuerySchemaAPI.QuerySchema.QueryBatch[QuerySchemaAPI.QuerySchema.QueryBatch.Count() - 1];
	Operator = QueryBatch.Operators[QueryBatch.Operators.Count() - 1];
	Operator.Filter.Clear();
EndProcedure

// Add appearance.
// 
// Parameters:
//  QuerySchemaAPI - See Get
//  Field - String - Field
//  ComparisonType - DataCompositionComparisonType - Comparison type
//  Value - Arbitrary - Right value
//  AppearanceType - String - Ex: TextColor
//  AppearanceValue - Arbitrary - Value of AppearanceType
//  Fields - String - Ex: "Field1,Field2"
// 
// Returns:
//  DataCompositionConditionalAppearanceItem
Function AddAppearance(QuerySchemaAPI, Field, ComparisonType, Value, AppearanceType = Undefined, AppearanceValue = Undefined, Fields = "") Export
	ConditionalAppearanceItem = QuerySchemaAPI.DynamicList.SettingsComposer.Settings.ConditionalAppearance.Items.Add();
	FilterItem = ConditionalAppearanceItem.Filter.Items.Add(Type("DataCompositionFilterItem"));
	FilterItem.ComparisonType = ComparisonType;
	FilterItem.LeftValue = New DataCompositionField(Field);
	FilterItem.RightValue = Value;
	FilterItem.Use = True;
	
	If Not AppearanceValue = Undefined Then
		ConditionalAppearanceItem.Appearance.SetParameterValue(AppearanceType, AppearanceValue);
	EndIf;
	
	If Not IsBlankString(Fields) Then
		FieldList = StrSplit(Fields, ",");
		For Each FieldPath In FieldList Do
			FieldDC = ConditionalAppearanceItem.Fields.AppearanceFieldsAvailableFields.FindField(New DataCompositionField(FieldPath));
			NewField = ConditionalAppearanceItem.Fields.Items.Add();
			NewField.Field = New DataCompositionField(FieldPath);
			NewField.Use = True;
		EndDo;
	EndIf;
	
	Return ConditionalAppearanceItem;
EndFunction

// Add source.
// 
// Parameters:
//  QuerySchemaAPI - See Get
//  Path - String - Path
//  Alias - String - Alias
//  Condition - String - Condition
// 
// Returns:
//  QuerySchemaSource
Function AddSource(QuerySchemaAPI, Path, Alias, Condition) Export
	QueryBatch = QuerySchemaAPI.QuerySchema.QueryBatch[QuerySchemaAPI.QuerySchema.QueryBatch.Count() - 1];
	Operator = QueryBatch.Operators[QueryBatch.Operators.Count() - 1];
	
	Condition = StrReplace(Condition, "#MainTable#", Operator.Sources[0].Source.Alias);
	NewSource = Operator.Sources.Add(Path, Alias);
	
	If NewSource.Joins.Count() = 1 Then
		NewSource.Joins[0].Condition = New QuerySchemaExpression(Condition);
		NewSource.Joins[0].JoinType = QuerySchemaJoinType.RightOuter;
	Else
		Operator.Sources[0].Joins.Add(NewSource, Condition);
		Operator.Sources[0].Joins[Operator.Sources[0].Joins.Count()-1].JoinType = QuerySchemaJoinType.LeftOuter;
	EndIf;
	
	Return NewSource;
EndFunction