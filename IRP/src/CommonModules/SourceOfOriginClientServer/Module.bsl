
Procedure AddNewSourceOfOrigins(Object, RowKey, SourceOfOrigins) Export
	For Each Row In SourceOfOrigins Do
		Filter = New Structure();
		Filter.Insert("Key", RowKey);
		Filter.Insert("SerialLotNumber", PredefinedValue("Catalog.SerialLotNumbers.EmptyRef"));
		If ValueIsFilled(Row.SerialLotNumber) Then
			Filter.SerialLotNumber = Row.SerialLotNumber;
		EndIf;
		
		FilteredRows = Object.SourceOfOrigins.FindRows(Filter);
		If FilteredRows.Count() Then                     
			FilteredRows[0].SourceOfOrigin = Row.SourceOfOrigin;
		Else
			NewRow = Object.SourceOfOrigins.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.Key = RowKey;
		EndIf;
	EndDo;
EndProcedure

Procedure UpdateSourceOfOriginsQuantity(Object) Export
	If Not CommonFunctionsClientServer.ObjectHasProperty(Object, "SourceOfOrigins") Then
		Return;
	EndIf;
	
	For Each Row_ItemList In Object.ItemList Do
		SerialLotNumbers = Object.SerialLotNumbers.FindRows(New Structure("Key", Row_ItemList.Key));
		If SerialLotNumbers.Count() Then
			
			SerialLotNumbersGrouped = New Array();
			For Each Row0 In SerialLotNumbers Do
				FoundRow = Undefined;
				For Each Row1 In SerialLotNumbersGrouped Do
					If Row0.Key = Row1.Key And Row0.SerialLotNumber = Row1.SerialLotNumber Then
						FoundRow = Row1;
						Break;
					EndIf;
				EndDo;
				If FoundRow <> Undefined Then
					FoundRow.Quantity = FoundRow.Quantity + Row0.Quantity;
				Else
					SerialLotNumbersGrouped.Add(New Structure("Key, SerialLotNumber, Quantity", Row0.Key, Row0.SerialLotNumber, Row0.Quantity));
				EndIf;
			EndDo;
			
			For Each Row_SerialLotNumbers In SerialLotNumbersGrouped Do // SerialLotNumbers
				SourceOfOrigins = Object.SourceOfOrigins.FindRows(New Structure("Key, SerialLotNumber", 
					Row_ItemList.Key, Row_SerialLotNumbers.SerialLotNumber));
					
				If SourceOfOrigins.Count() = 1 Then
					SourceOfOrigins[0].Quantity = Row_SerialLotNumbers.Quantity;
				ElsIf SourceOfOrigins.Count() > 1 Then
					For Each Row_SourceOfOrigins In SourceOfOrigins Do
						Object.SourceOfOrigins.Delete(Row_SourceOfOrigins);
					EndDo;
					NewRow = Object.SourceOfOrigins.Add();
					NewRow.Key = Row_ItemList.Key; 
					NewRow.SerialLotNumber = Row_SerialLotNumbers.SerialLotNumber;
					NewRow.Quantity = Row_SerialLotNumbers.Quantity;				
				Else // SourceOfOrigins.Count() = 0
					NewRow = Object.SourceOfOrigins.Add();
					NewRow.Key = Row_ItemList.Key; 
					NewRow.SerialLotNumber = Row_SerialLotNumbers.SerialLotNumber;
					NewRow.SourceOfOrigin = CommonFunctionsServer.GetRefAttribute(Row_SerialLotNumbers.SerialLotNumber, "SourceOfOrigin");
					NewRow.Quantity = Row_SerialLotNumbers.Quantity;				
				EndIf;
			EndDo; // SerialLotNumbers
			
		Else // Not SerialLotNumbers.Count()
			
			SourceOfOrigins = Object.SourceOfOrigins.FindRows(New Structure("Key", Row_ItemList.Key));
			If SourceOfOrigins.Count() = 1 Then
				SourceOfOrigins[0].SerialLotNumber = Undefined;
				SourceOfOrigins[0].Quantity = Row_ItemList.QuantityInBaseUnit;
			ElsIf SourceOfOrigins.Count() > 1 Then
				For Each Row_SourceOfOrigins In SourceOfOrigins Do
					Object.SourceOfOrigins.Delete(Row_SourceOfOrigins);
				EndDo;
				NewRow = Object.SourceOfOrigins.Add();
				NewRow.Key = Row_ItemList.Key; 
				NewRow.Quantity = Row_ItemList.QuantityInBaseUnit; 				
			Else // SourceOfOrigins.Count() = 0
				NewRow = Object.SourceOfOrigins.Add();
				NewRow.Key = Row_ItemList.Key; 
				NewRow.Quantity = Row_ItemList.QuantityInBaseUnit; 
			EndIf;
			
		EndIf; // SerialLotNumbers.Count()
	EndDo;
EndProcedure

Procedure DeleteUnusedSourceOfOrigins(Object, KeyForDelete = Undefined) Export
	If Not CommonFunctionsClientServer.ObjectHasProperty(Object, "SourceOfOrigins") Then
		Return;
	EndIf;
	
	If KeyForDelete = Undefined Then
		ArrayForDelete = New Array();
		For Each Row In Object.SourceOfOrigins Do
			If Not Object.ItemList.FindRows(New Structure("Key", Row.Key)).Count() Then
				ArrayForDelete.Add(Row);
			EndIf;
		EndDo;
		For Each Row In ArrayForDelete Do
			Object.SourceOfOrigins.Delete(Row);
		EndDo;
	Else
		ArrayForDelete = Object.SourceOfOrigins.FindRows(New Structure("Key", KeyForDelete));
		For Each Row In ArrayForDelete Do
			Object.SourceOfOrigins.Delete(Row);
		EndDo;
	EndIf;
	
	If CommonFunctionsClientServer.ObjectHasProperty(Object, "SerialLotNumbers") Then
		ArrayForDelete = New Array();
		For Each Row In Object.SourceOfOrigins Do
			If Not ValueIsFilled(Row.SerialLotNumber) And Not Object.SerialLotNumbers.FindRows(New Structure("Key", Row.Key)).Count() Then
				Continue;
			EndIf;
			
			Filter = New Structure();
			Filter.Insert("Key", Row.Key);
			Filter.Insert("SerialLotNumber", Row.SerialLotNumber);
			If Not Object.SerialLotNumbers.FindRows(Filter).Count() Then
				ArrayForDelete.Add(Row);
			EndIf;
		EndDo;
		
		For Each Row In ArrayForDelete Do
			Object.SourceOfOrigins.Delete(Row);
		EndDo;
	EndIf;
EndProcedure
