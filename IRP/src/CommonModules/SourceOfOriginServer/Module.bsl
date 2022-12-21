
Function CalculateSourceOfOriginsTable(Array_ItemList, Array_SerialLotNumbers, Array_SourceOfOrigins) Export
	Table_ItemList = New ValueTable();
	Table_ItemList.Columns.Add("Key");
	Table_ItemList.Columns.Add("Quantity");
	
	For Each Row In Array_ItemList Do
		FillPropertyValues(Table_ItemList.Add(), Row);
	EndDo;

	Table_SerialLotNumbers = New ValueTable();
	Table_SerialLotNumbers.Columns.Add("Key");
	Table_SerialLotNumbers.Columns.Add("SerialLotNumber");
	Table_SerialLotNumbers.Columns.Add("Quantity");
	
	For Each Row In Array_SerialLotNumbers Do
		FillPropertyValues(Table_SerialLotNumbers.Add(), Row);
	EndDo;
	Table_SerialLotNumbers.GroupBy("Key, SerialLotNumber", "Quantity");
	
	Table_SourceOfOrigins = New ValueTable();
	Table_SourceOfOrigins.Columns.Add("Key");
	Table_SourceOfOrigins.Columns.Add("SerialLotNumber");
	Table_SourceOfOrigins.Columns.Add("SourceOfOrigin");
	Table_SourceOfOrigins.Columns.Add("Quantity");
	
	For Each Row In Array_SourceOfOrigins Do
		FillPropertyValues(Table_SourceOfOrigins.Add(), Row);
	EndDo;
	
	For Each Row_ItemList In Table_ItemList Do
		
		SerialLotNumbers = Table_SerialLotNumbers.FindRows(New Structure("Key", Row_ItemList.Key));
		
		If SerialLotNumbers.Count() Then
			
			For Each Row_SerialLotNumbers In SerialLotNumbers Do // SerialLotNumbers
				SourceOfOrigins = Table_SourceOfOrigins.FindRows(New Structure("Key, SerialLotNumber", 
						Row_ItemList.Key, Row_SerialLotNumbers.SerialLotNumber));
						
				If SourceOfOrigins.Count() = 1 Then
					SourceOfOrigins[0].Quantity = Row_SerialLotNumbers.Quantity;
				ElsIf SourceOfOrigins.Count() > 1 Then
					For Each Row_SourceOfOrigins In SourceOfOrigins Do
						Table_SourceOfOrigins.Delete(Row_SourceOfOrigins);
					EndDo;
					NewRow = Table_SourceOfOrigins.Add();
					NewRow.Key = Row_ItemList.Key; 
					NewRow.SerialLotNumber = Row_SerialLotNumbers.SerialLotNumber;
					NewRow.Quantity = Row_SerialLotNumbers.Quantity;				
				Else // SourceOfOrigins.Count() = 0
					NewRow = Table_SourceOfOrigins.Add();
					NewRow.Key = Row_ItemList.Key; 
					NewRow.SerialLotNumber = Row_SerialLotNumbers.SerialLotNumber;
					NewRow.Quantity = Row_SerialLotNumbers.Quantity;				
				EndIf;
			EndDo; // SerialLotNumbers
			
		Else // Not SerialLotNumbers.Count()
			
			SourceOfOrigins = Table_SourceOfOrigins.FindRows(New Structure("Key", Row_ItemList.Key));
			If SourceOfOrigins.Count() = 1 Then
				SourceOfOrigins[0].SerialLotNumber = Undefined;
				SourceOfOrigins[0].Quantity = Row_ItemList.Quantity;
			ElsIf SourceOfOrigins.Count() > 1 Then
				For Each Row_SourceOfOrigins In SourceOfOrigins Do
					Table_SourceOfOrigins.Delete(Row_SourceOfOrigins);
				EndDo;
				NewRow = Table_SourceOfOrigins.Add();
				NewRow.Key = Row_ItemList.Key; 
				NewRow.Quantity = Row_ItemList.Quantity; 				
			Else // SourceOfOrigins.Count() = 0
				NewRow = Table_SourceOfOrigins.Add();
				NewRow.Key = Row_ItemList.Key; 
				NewRow.Quantity = Row_ItemList.Quantity; 
			EndIf;
			
		EndIf; // SerialLotNumbers.Count()
	EndDo;
		
	ArrayForDelete = New Array();
	For Each Row In Table_SourceOfOrigins Do
		If Not Table_ItemList.FindRows(New Structure("Key", Row.Key)).Count() Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	
	For Each Row In ArrayForDelete Do
		Table_SourceOfOrigins.Delete(Row);
	EndDo;
	
	ArrayForDelete = New Array();
	For Each Row In Table_SourceOfOrigins Do
		If Not ValueIsFilled(Row.SerialLotNumber) And Not Table_SerialLotNumbers.FindRows(New Structure("Key", Row.Key)).Count() Then
			Continue;
		EndIf;
			
		Filter = New Structure();
		Filter.Insert("Key", Row.Key);
		Filter.Insert("SerialLotNumber", Row.SerialLotNumber);
		If Not Table_SerialLotNumbers.FindRows(Filter).Count() Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
		
	For Each Row In ArrayForDelete Do
		Table_SourceOfOrigins.Delete(Row);
	EndDo;
	
	Result = New Array();
	For Each Row In Table_SourceOfOrigins Do
		NewRow = New Structure("Key, SerialLotNumber, SourceOfOrigin, Quantity");
		FillPropertyValues(NewRow, Row);
		Result.Add(NewRow);
	EndDo;
	Return Result;
EndFunction
