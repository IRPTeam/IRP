
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	ArrayOfFillingValues = GetArrayOfFillingValues(CommandParameter);
	If Not ArrayOfFillingValues.Count() Then
		CommonFunctionsClientServer.ShowUsersMessage("nothing to fill");
	EndIf;
	For Each FillingValues In ArrayOfFillingValues Do
		FormParameters = New Structure("FillingValues", FillingValues);
		OpenForm("Document.ShipmentConfirmation.ObjectForm", FormParameters, , New UUID());
	EndDo;
EndProcedure

Function GetArrayOfFillingValues(Basises)
	BasisesTable = RowIDInfo.GetBasisesFor_ShipmentConfirmation(New Structure("Basises", Basises));
	ExtractedData = RowIDInfo.ExtractData(BasisesTable);
	Return RowIDInfo.ConvertDataToFillingValues(Metadata.Documents.ShipmentConfirmation, ExtractedData);	
EndFunction
