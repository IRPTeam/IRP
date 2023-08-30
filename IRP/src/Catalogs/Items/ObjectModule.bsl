#Region EventHandlers

Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	ThisObject.Unit = FOServer.GetDefault_Unit(ThisObject.Unit);
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	FOServer.CreateDefault_ItemKey(New Structure("Item", ThisObject));
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure OnCopy(CopiedObject)
	PackageUnit = Undefined;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	CommissionTradeServer.FillCheckProcessing_ConsignorsInfo(Cancel, ThisObject);
EndProcedure

#EndRegion
