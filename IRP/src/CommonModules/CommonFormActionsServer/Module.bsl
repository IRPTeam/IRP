
Function RestoreFillingData(Val FillingData) Export
	If Not ValueIsFilled(FillingData) Then
		Return Undefined;
	EndIf;
	Return CommonFunctionsServer.DeserializeXMLUseXDTO(FillingData);
EndFunction