Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;	
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure
Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	CheckAttributeTables(Cancel, "Attributes");
	CheckAttributeTables(Cancel, "ExtensionAttributes");
EndProcedure

#Region Private

Procedure CheckAttributeTables(Cancel, TableName)	
	TableOfAttributes = ThisObject[TableName].Unload();
	TableOfAttributes.Columns.Add("Counter");
	TableOfAttributes.FillValues(1, "Counter");
	TableOfAttributes.GroupBy("Attribute", "Counter");	
	For Each Row In TableOfAttributes Do
		If Row.Counter <= 1 Then
			Continue;
		EndIf;		
		Filter = New Structure("Attribute", Row.Attribute);
		FoundedRows = ThisObject[TableName].FindRows(Filter);
		If FoundedRows.Count() Then
			LineNumber = FoundedRows[0].LineNumber;
			Text = R().Error_033 + ": " + String(Row.Attribute);
			Path = TableName + "[" + (LineNumber - 1) + "].Attribute";			
			CommonFunctionsClientServer.ShowUsersMessage(Text, Path, ThisObject);
			Cancel = True;
		EndIf;
	EndDo;
EndProcedure

#EndRegion
