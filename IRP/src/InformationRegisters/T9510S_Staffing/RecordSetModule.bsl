
Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	For Each Record In ThisObject Do
		If Record.Fired Then
			CommonFunctionsClientServer.DeleteValueFromArray(CheckedAttributes, "Company");
			CommonFunctionsClientServer.DeleteValueFromArray(CheckedAttributes, "Branch");
			CommonFunctionsClientServer.DeleteValueFromArray(CheckedAttributes, "Position");
		Else
			CommonFunctionsClientServer.AddValueToArray(CheckedAttributes, "Company");
			CommonFunctionsClientServer.AddValueToArray(CheckedAttributes, "Branch");
			CommonFunctionsClientServer.AddValueToArray(CheckedAttributes, "Position");
		EndIf;
	EndDo;
EndProcedure
