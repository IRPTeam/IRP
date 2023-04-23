
Function AddNewSerialLotNumbers(Object, RowKey, SerialLotNumbers, AddNewLot) Export
	If Not AddNewLot Then
		ArrayOfSerialLotNumbers = Object.SerialLotNumbers.FindRows(New Structure("Key", RowKey));
		For Each Row In ArrayOfSerialLotNumbers Do
			Object.SerialLotNumbers.Delete(Row);
		EndDo;
	EndIf;
		
	For Each Row In SerialLotNumbers Do
		FoundRows = Object.SerialLotNumbers.FindRows(New Structure("Key, SerialLotNumber", RowKey, Row.SerialLotNumber));
		If FoundRows.Count() Then
			NewRow = FoundRows[0];
		Else
			NewRow = Object.SerialLotNumbers.Add();
		EndIf;
		NewRow.Key = RowKey;
		NewRow.SerialLotNumber = Row.SerialLotNumber;
		NewRow.Quantity = NewRow.Quantity + Row.Quantity;
	EndDo;
		
	TotalQuantity = 0;
	For Each Row In Object.SerialLotNumbers Do
		If Row.Key = RowKey Then
			TotalQuantity = TotalQuantity + Row.Quantity;
		EndIf;
	EndDo;
	Return TotalQuantity;	
EndFunction