
Function FindRowInArrayOfStructures(ArrayOfStructures, KeyNames, 
                                    Value1 = Undefined, 
                                    Value2 = Undefined, 
                                    Value3 = Undefined) Export
	ArrayOfKeys = StrSplit(KeyNames, ",");
	EqualRow = Undefined;
	For Each Row In ArrayOfStructures Do
		RowIsEqual = True;
		
		KeyNumber = 1;
		For Each KeyName In ArrayOfKeys Do
			If KeyNumber = 1 And Value1 <> Undefined Then
				If Row[TrimAll(KeyName)] <> Value1 Then
					RowIsEqual = False;
					Break;
				EndIf;
			EndIf;
			
			If KeyNumber = 2 And Value2 <> Undefined Then
				If Row[TrimAll(KeyName)] <> Value2 Then
					RowIsEqual = False;
					Break;
				EndIf;
			EndIf;
			
			If KeyNumber = 3 And Value3 <> Undefined Then
				If Row[TrimAll(KeyName)] <> Value3 Then
					RowIsEqual = False;
					Break;
				EndIf;
			EndIf;
			
			KeyNumber = KeyNumber + 1;
		EndDo;
		
		If RowIsEqual Then
			EqualRow = Row;
			Break;
		EndIf;
	EndDo;
	Return EqualRow;
EndFunction

