Procedure Filling(FillingData, FillingText, StandardProcessing)
	If TypeOf(FillingData) = Type("Structure") Then
		FillPropertyValues(ThisObject, FillingData);
	EndIf;
	If Not ValueIsFilled(Type) Then
		Type = Enums.CashAccountTypes.Cash;
	EndIf;
EndProcedure