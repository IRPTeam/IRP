
Procedure OnCreateAtServer(Object, Form) Export
	If Not CommonFunctionsServer.FormHaveAttribute(Form, "CacheBeforeChange") Then
		ArrayOfNewAttribute = New Array();
		ArrayOfNewAttribute.Add(New FormAttribute("CacheBeforeChange", New TypeDescription("String")));
		Form.ChangeAttributes(ArrayOfNewAttribute);
	EndIf;
EndProcedure

Function GetObjectMetadataInfo(Val Object, ArrayOfTableNames) Export
	Result = New Structure();
	Result.Insert("MetadataName", Object.Ref.Metadata().Name);
	
	Tables = New Structure();
	For Each TableName In StrSplit(ArrayOfTableNames, ",") Do
		ArrayOfColumns = New Array();
		Columns = Object[TrimAll(TableName)].Unload().Columns;
		For Each Column In Columns Do
			ArrayOfColumns.Add(Column.Name);
		EndDo;
		Tables.Insert(TableName, New Structure ("Columns", StrConcat(ArrayOfColumns, ",")));
	EndDo;
	Result.Insert("Tables",Tables);
	Return Result;
EndFunction

Function TEST_get_item() Export
	Return Catalogs.Items.FindByCode(110);
EndFunction

//Function GetColumnsOfTable(Val Object, TableNames) Export
//	ArrayOfTables = New Array();	
//	For Each TableName In StrSplit(TableNames, ",") Do
//		ArrayOfColumns = New Array();
//		For Each Column In Object[TrimAll(TableName)].Unload().Columns Do
//			ArrayOfColumns.Add(Column.Name);
//		EndDo;
//		ArrayOfTables.Add(StrConcat(ArrayOfColumns, ","));
//	EndDo;
//	Return ArrayOfTables;
//EndFunction