
Function GetTaxesCache(Form) Export
	If ValueIsFilled(Form.TaxesCache) Then
		SavedDataStructure = CommonFunctionsServer.DeserializeXMLUseXDTO(Form.TaxesCache);
	Else
		SavedDataStructure = New Structure();
		SavedDataStructure.Insert("ArrayOfTaxInfo", New Array());
	EndIf;
	Return SavedDataStructure;
EndFunction