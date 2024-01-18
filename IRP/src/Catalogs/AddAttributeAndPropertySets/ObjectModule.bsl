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
	CheckAttributeTables(Cancel, "Attributes", "Attribute");
	CheckAttributeTables(Cancel, "Properties", "Property");
	CheckAttributeTables(Cancel, "ExtensionAttributes", "Attribute");
	
	AllProperty = Properties.Unload().UnloadColumn("Property");
	For Each Row In Attributes Do
		If Not AllProperty.Find(Row.Attribute) = Undefined Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().AddAttributeCannotUseWithProperty, Row.Attribute));
		EndIf;
		
		If Not IsBlankString(Row.PathForTag) Then
			Parts = StrSplit(Row.PathForTag, ". ", False);
			If Not Parts.Count() = 2 Then
				Cancel = True;
				CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().AddAttributeTagPathHasNotTwoPart, Row.PathForTag));
			EndIf;
		EndIf;
	EndDo;
EndProcedure

#Region Private

Procedure CheckAttributeTables(Cancel, TableName, AttrName)
	TableOfAttributes = ThisObject[TableName].Unload();
	TableOfAttributes.Columns.Add("Counter");
	TableOfAttributes.FillValues(1, "Counter");
	TableOfAttributes.GroupBy(AttrName, "Counter");
	For Each Row In TableOfAttributes Do
		If Row.Counter <= 1 Then
			Continue;
		EndIf;
		Filter = New Structure(AttrName, Row[AttrName]);
		FoundedRows = ThisObject[TableName].FindRows(Filter);
		If FoundedRows.Count() Then
			LineNumber = FoundedRows[0].LineNumber;
			Text = R().Error_033 + ": " + String(Row.Attribute);
			Path = TableName + "[" + (LineNumber - 1) + "]." + AttrName;
			CommonFunctionsClientServer.ShowUsersMessage(Text, Path, ThisObject);
			Cancel = True;
		EndIf;
	EndDo;
EndProcedure

#EndRegion