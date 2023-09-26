
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
	Return;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If ThisObject.CalculationMethod <> Enums.DepreciationMethods.StraightLine Then
		CommonFunctionsClientServer.DeleteValueFromArray(CheckedAttributes, "UsefulLife");
	EndIf;
	
	If ThisObject.CalculationMethod <> Enums.DepreciationMethods.DecliningBalance Then
		CommonFunctionsClientServer.DeleteValueFromArray(CheckedAttributes, "Rate");
	EndIf;
EndProcedure
