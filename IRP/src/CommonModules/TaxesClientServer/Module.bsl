Function GetSavedData(Form, AttributeName) Export
	If ValueIsFilled(Form[AttributeName]) Then
		SavedDataStructure = CommonFunctionsServer.DeserializeXMLUseXDTO(Form[AttributeName]);
	Else
		SavedDataStructure = New Structure();
		SavedDataStructure.Insert("ArrayOfColumnsInfo", New Array());
	EndIf;
	Return SavedDataStructure;
EndFunction