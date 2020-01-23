Procedure Filling(FillingData, FillingText, StandardProcessing)
	If TypeOf(FillingData) = Type("Structure") Then
		FillPropertyValues(ThisObject, FillingData);
	EndIf;
EndProcedure

