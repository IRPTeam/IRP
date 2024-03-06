// @strict-types

// Get.
// 
// Parameters:
//  DynamicList - DynamicList - Dynamic list
// 
// Returns:
//  QuerySchema
Function Get(DynamicList) Export
	FormQueryText = DynamicList.QueryText;
	MainAttributeTable = DynamicList.MainTable;
	If Not DynamicList.CustomQuery Then
		FormQueryText = "Select * From " + MainAttributeTable;
	EndIf;
	
	QuerySchema = New QuerySchema;
	QuerySchema.SetQueryText(FormQueryText);
	
	Return QuerySchema;
EndFunction


// Add field.
// 
// Parameters:
//  QuerySchema - QuerySchema - QuerySchema
//  Path - String - Path, ex "Number"
//  Alias - String - Alias
// 
// Returns:
//  QuerySchemaColumn
Function AddField(QuerySchema, Path, Alias = "") Export
	QueryBatch = QuerySchema.QueryBatch[QuerySchema.QueryBatch.Count() - 1];
	Operator = QueryBatch.Operators[QueryBatch.Operators.Count() - 1];
	Field = Operator.SelectedFields.Find(Path);
	If Field = Undefined Then
		Field = Operator.SelectedFields.Add(Path);
		Column = QueryBatch.Columns.Find(Field);
		If Not IsBlankString(Alias) Then
			Column.Alias = Alias;
		EndIf;
	EndIf;

	Return Column;
EndFunction

// Add filter.
// 
// Parameters:
//  QuerySchema - QuerySchema - QuerySchema
//  Filter - String - Filter, ex "Number = &Number", "Posted"
Procedure AddFilter(QuerySchema, Filter) Export
	QueryBatch = QuerySchema.QueryBatch[QuerySchema.QueryBatch.Count() - 1];
	Operator = QueryBatch.Operators[QueryBatch.Operators.Count() - 1];
	Operator.Filter.Add(Filter);
EndProcedure