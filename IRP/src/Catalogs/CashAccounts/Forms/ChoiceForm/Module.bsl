&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatCashAccountsServer.OnCreateAtServer(Cancel, StandardProcessing, ThisObject, Parameters);
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	
	For Each FilterItem In List.Filter.Items Do
		If TypeOf(FilterItem) = Type("DataCompositionFilterItem")
			And FilterItem.LeftValue = New DataCompositionField("Type")
			And ValueIsFilled(FilterItem.RightValue) Then
			CashAccountTypeFilter = FilterItem.RightValue;
			Items.CashAccountTypeFilter.Visible = FilterItem.ComparisonType <> DataCompositionComparisonType.Equal;
			If FilterItem.ComparisonType = DataCompositionComparisonType.NotEqual Then
				FoundedItemList = Items.CashAccountTypeFilter.ChoiceList.FindByValue(FilterItem.RightValue);
				If FoundedItemList <> Undefined Then
					Items.CashAccountTypeFilter.ChoiceList.Delete(FoundedItemList);
				EndIf
			EndIf;
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure ListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	CommonFormActions.DynamicListBeforeAddRow(
				ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter, "Catalog.CashAccounts.ObjectForm");
EndProcedure

&AtClient
Procedure CashAccountTypeFilterOnChange(Item)
	CommonFunctionsClientServer.SetFilterItem(List.Filter.Items,
		"Type",
		CashAccountTypeFilter,
		DataCompositionComparisonType.Equal,
		ValueIsFilled(CashAccountTypeFilter));
EndProcedure

