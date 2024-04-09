#Region EventHandlers

Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
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
	CommonFunctionsServer.CheckUniqueDescriptions_PrivilegedCall(Cancel, ThisObject);
	CheckDataPrivileged.FillCheckProcessing_Catalog_Items(Cancel, ThisObject);
EndProcedure

#EndRegion
