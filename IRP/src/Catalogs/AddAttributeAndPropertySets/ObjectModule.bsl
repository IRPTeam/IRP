Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	TableOfAttributes = ThisObject.Attributes.Unload();
	TableOfAttributes.Columns.Add("Counter");
	TableOfAttributes.FillValues(1, "Counter");
	TableOfAttributes.GroupBy("Attribute", "Counter");
	
	For Each Row In TableOfAttributes Do
		If Row.Counter <= 1 Then
			Continue;
		EndIf;
		
		Filter = New Structure("Attribute", Row.Attribute);
		FoundedRows = ThisObject.Attributes.FindRows(Filter);
		If FoundedRows.Count() Then
			LineNumber = FoundedRows[0].LineNumber;
			Text = R().Error_033 + ": " + String(Row.Attribute);
			Path = "Attributes[" + (LineNumber - 1) + "].Attribute";			
			CommonFunctionsClientServer.ShowUsersMessage(Text, Path, ThisObject);
			Cancel = True;
		EndIf;
	EndDo;
EndProcedure

