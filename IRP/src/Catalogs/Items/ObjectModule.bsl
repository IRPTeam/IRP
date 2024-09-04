#Region EventHandlers

Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	If Not ThisObject.IsFolder Then
		ThisObject.Unit = FOServer.GetDefault_Unit(ThisObject.Unit);
		
		CheckResult = CheckDataPrivileged.CheckUnitForItem(ThisObject);
		If CheckResult.Error Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_138, 
				CheckResult.UnitFrom, CheckResult.UnitTo, CheckResult.Document));
		EndIf;
		
		If ControlCodeString And ControlCodeStringType.IsEmpty() Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_010, Metadata.Catalogs.Items.Attributes.ControlCodeStringType.Synonym));
		EndIf;
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	If Not ThisObject.IsFolder Then
		FOServer.CreateDefault_ItemKey(New Structure("Item", ThisObject));
	EndIf;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure OnCopy(CopiedObject)
	If Not ThisObject.IsFolder Then
		PackageUnit = Undefined;
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If Not ThisObject.IsFolder Then
		CommissionTradeServer.FillCheckProcessing_ConsignorsInfo(Cancel, ThisObject);
		CheckDataPrivileged.FillCheckProcessing_Catalog_Items(Cancel, ThisObject);
	EndIf;
	CommonFunctionsServer.CheckUniqueDescriptions_PrivilegedCall(Cancel, ThisObject);
EndProcedure

#EndRegion
