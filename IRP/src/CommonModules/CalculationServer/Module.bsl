
Function CalculateDocumentAmount(ItemList) Export
	CancelColumnIsPresent = False;
	If ItemList.Count() 
		And CommonFunctionsClientServer.ObjectHasProperty(ItemList[0], "Cancel") Then
		CancelColumnIsPresent = True;
	EndIf;
		
	TotalAmount = 0;
	For Each Row In ItemList Do
		If CancelColumnIsPresent And Row.Cancel Then
			Continue;
		EndIf;
		TotalAmount = TotalAmount + Row.TotalAmount;
	EndDo;
	Return TotalAmount;
EndFunction
