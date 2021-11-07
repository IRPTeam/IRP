
Procedure OnCreateAtServer(Object, Form) Export
	If Not CommonFunctionsServer.FormHaveAttribute(Form, "CacheBeforeChange") Then
		ArrayOfNewAttribute = New Array();
		ArrayOfNewAttribute.Add(New FormAttribute("CacheBeforeChange", New TypeDescription("String")));
		Form.ChangeAttributes(ArrayOfNewAttribute);
	EndIf;
EndProcedure

Function GetColumnsOfTable(Val Object, TableNames) Export
	ArrayOfTables = New Array();	
	For Each TableName In StrSplit(TableNames, ",") Do
		ArrayOfColumns = New Array();
		For Each Column In Object[TrimAll(TableName)].Unload().Columns Do
			ArrayOfColumns.Add(Column.Name);
		EndDo;
		ArrayOfTables.Add(StrConcat(ArrayOfColumns, ","));
	EndDo;
	Return ArrayOfTables;
EndFunction