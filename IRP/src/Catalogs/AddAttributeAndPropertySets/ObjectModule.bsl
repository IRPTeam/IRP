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
			
			CommonFunctionsClientServer.ShowUsersMessage(R().Error_033 + ": " + String(Row.Attribute)
				, "Attributes[" + (LineNumber - 1) + "].Attribute", ThisObject);
			Cancel = True;
		EndIf;
	EndDo;
EndProcedure

