
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
	ThisObject.Type = Enums.BillOfMaterialsTypes.Product;
	ThisObject.Active = True;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If ThisObject.Type = Enums.BillOfMaterialsTypes.Product Then		
		IndexOfArray = CheckedAttributes.Find("Content.ExpenseType");
		If IndexOfArray <> Undefined Then
			CheckedAttributes.Delete(IndexOfArray);
		EndIf;
	EndIf;
EndProcedure
