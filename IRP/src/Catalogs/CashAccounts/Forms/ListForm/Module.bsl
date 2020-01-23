&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatCashAccountsServer.OnCreateAtServer(Cancel, StandardProcessing, ThisObject, Parameters);
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	
	For Each FilterItem In Parameters.Filter Do
		If FilterItem.Key = "Type" Then
			CashAccountTypeFilter = FilterItem.Value;
			Items.CashAccountTypeFilter.Enabled = False;
		EndIf;
	EndDo;
	
	CommonFunctionsClientServer.SetFilterItem(List.Filter.Items,
		"Type",
		CashAccountTypeFilter,
		DataCompositionComparisonType.Equal,
		ValueIsFilled(CashAccountTypeFilter));
EndProcedure

&AtClient
Procedure CashAccountTypeFilterOnChange(Item)
	CommonFunctionsClientServer.SetFilterItem(List.Filter.Items,
		"Type",
		CashAccountTypeFilter,
		DataCompositionComparisonType.Equal,
		ValueIsFilled(CashAccountTypeFilter));
EndProcedure

