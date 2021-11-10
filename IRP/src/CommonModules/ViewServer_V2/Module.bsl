
Procedure OnCreateAtServer(Object, Form) Export
	If Not CommonFunctionsServer.FormHaveAttribute(Form, "CacheBeforeChange") Then
		ArrayOfNewAttribute = New Array();
		ArrayOfNewAttribute.Add(New FormAttribute("CacheBeforeChange", New TypeDescription("String")));
		Form.ChangeAttributes(ArrayOfNewAttribute);
	EndIf;
	
	// Fill by default form attributes
	
EndProcedure

Function GetObjectMetadataInfo(Val Object, ArrayOfTableNames) Export
	Result = New Structure();
	Result.Insert("MetadataName", Object.Ref.Metadata().Name);
	
	Tables = New Structure();
	For Each TableName In StrSplit(ArrayOfTableNames, ",") Do
		If Not ValueIsFilled(TableName) Then
			Continue;
		EndIf;
		ArrayOfColumns = New Array();
		Columns = Object[TrimAll(TableName)].Unload().Columns;
		For Each Column In Columns Do
			ArrayOfColumns.Add(Column.Name);
		EndDo;
		Tables.Insert(TableName, New Structure ("Columns", StrConcat(ArrayOfColumns, ",")));
	EndDo;
	Result.Insert("Tables",Tables);
	
	AllDepTables = New Array();
	AllDepTables.Add("SpecialOffers");
	AllDepTables.Add("TaxList");
	AllDepTables.Add("Currencies");
	AllDepTables.Add("SerialLotNumbers");
	AllDepTables.Add("ShipmentConfirmations");
	AllDepTables.Add("GoodsReceipts");
	AllDepTables.Add("RowIDInfo");
	
	ArrayOfDepTables = New Array();
	For Each TableName In AllDepTables Do
		If CommonFunctionsClientServer.ObjectHasProperty(Object, TableName) Then
			ArrayOfDepTables.Add(TableName);
		EndIf;
	EndDo;
	Result.Insert("DependencyTables", ArrayOfDepTables);
	
	Return Result;
EndFunction
