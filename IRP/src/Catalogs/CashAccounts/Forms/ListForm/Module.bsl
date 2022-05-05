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

	CommonFunctionsClientServer.SetFilterItem(List.Filter.Items, "Type", CashAccountTypeFilter,
		DataCompositionComparisonType.Equal, ValueIsFilled(CashAccountTypeFilter));
		
	If Not FOServer.IsUseBankDocuments() Then
		ArrayForDelete = New Array();
		For Each ListItem In Items.CashAccountTypeFilter.ChoiceList Do
			If Not (Not ValueIsFilled(ListItem.Value) 
				Or ListItem.Value = Enums.CashAccountTypes.Cash
				Or ListItem.Value = Enums.CashAccountTypes.POS) Then
				ArrayForDelete.Add(ListItem);
			EndIf;
		EndDo;
		For Each ArrayItem In ArrayForDelete Do
			Items.CashAccountTypeFilter.ChoiceList.Delete(ArrayItem);
		EndDo;
	EndIf;
EndProcedure

&AtClient
Procedure CashAccountTypeFilterOnChange(Item)
	CommonFunctionsClientServer.SetFilterItem(List.Filter.Items, "Type", CashAccountTypeFilter,
		DataCompositionComparisonType.Equal, ValueIsFilled(CashAccountTypeFilter));
EndProcedure