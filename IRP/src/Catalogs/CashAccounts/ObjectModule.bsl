Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If TypeOf(FillingData) = Type("Structure") Then
		FillPropertyValues(ThisObject, FillingData);
	EndIf;
	If Not ValueIsFilled(Type) Then
		Type = Enums.CashAccountTypes.Cash;
	EndIf;
EndProcedure

Procedure OnCopy(CopiedObject)
	Acquiring = Catalogs.Hardware.EmptyRef();
EndProcedure
