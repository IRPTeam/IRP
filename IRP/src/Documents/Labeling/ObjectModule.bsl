
Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
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
		If FillingData.Property("BasedOn") Then
			For Each FillingDataItem In FillingData.BasedOn Do
				Filling_BasedOnPurchaseOrder(FillingDataItem);
			EndDo;
		EndIf;
	EndIf;
EndProcedure

Procedure Filling_BasedOnPurchaseOrder(FillingData)
	For Each Row In FillingData.ItemList Do
		If Int(Row.Quantity) = Row.Quantity Then
			For CountQauntity = 1 To Row.Quantity Do
				NewRow = ThisObject.ItemList.Add();
				FillPropertyValues(NewRow, Row);
				NewRow.PurchaseOrder = FillingData.Ref;
			EndDo;
		Else
			NewRow = ThisObject.ItemList.Add();
			FillPropertyValues(NewRow, Row);
		EndIf;
	EndDo;
EndProcedure
