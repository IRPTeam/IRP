
Function IsItemKeyWithSerialLotNumbers(ItemKey, AddInfo = Undefined) Export
	If Not ValueIsFilled(ItemKey) Then
		Return False;
	EndIf;
	
	Return ItemKey.Item.ItemType.UseSerialLotNumber;
EndFunction	

Function CheckFilling(Object) Export
	IsOk = True;
	For Each Row In Object.ItemList Do
		If Not IsItemKeyWithSerialLotNumbers(Row.ItemKey) Then
			Continue;
		EndIf;

		ArrayOfSerialLotNumbers = Object.SerialLotNumbers.FindRows(New Structure("Key", Row.Key));
		If Not ArrayOfSerialLotNumbers.Count() Then
			IsOk = False;
			CommonFunctionsClientServer.ShowUsersMessage(
				StrTemplate(R().Error_010, "Serial lot number"), "ItemList[" + Format((Row.LineNumber - 1),
				"NZ=0; NG=0;") + "].SerialLotNumbersPresentation", Object);
		Else
			QuantityBySerialLotNumber = 0;
			For Each RowSerialLotNumber In ArrayOfSerialLotNumbers Do
				QuantityBySerialLotNumber = QuantityBySerialLotNumber + RowSerialLotNumber.Quantity;
			EndDo;
			If Row.Quantity <> QuantityBySerialLotNumber Then
				IsOk = False;
				CommonFunctionsClientServer.ShowUsersMessage(
					StrTemplate(R().Error_078, Row.Quantity, QuantityBySerialLotNumber), "ItemList[" + Format(
					(Row.LineNumber - 1), "NZ=0; NG=0;") + "].Quantity", Object);

			EndIf;
		EndIf;
	EndDo;
	Return IsOk;
EndFunction