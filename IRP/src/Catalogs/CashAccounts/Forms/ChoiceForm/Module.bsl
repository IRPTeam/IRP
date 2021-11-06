&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatCashAccountsServer.OnCreateAtServer(Cancel, StandardProcessing, ThisObject, Parameters);
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);

	For Each FilterItem In List.Filter.Items Do
		If TypeOf(FilterItem) = Type("DataCompositionFilterItem") 
			And FilterItem.LeftValue = New DataCompositionField("Type") Then
		
			If FilterItem.ComparisonType = DataCompositionComparisonType.Equal Then
				ThisObject.CashAccountTypeFilter = FilterItem.RightValue;
				Items.CashAccountTypeFilter.Visible = False;
			ElsIf FilterItem.ComparisonType = DataCompositionComparisonType.NotEqual Then
				DeleteFilterItemFromCashAccountTypeFilter(FilterItem.RightValue);
			ElsIf FilterItem.ComparisonType = DataCompositionComparisonType.NotInList Then
				For Each FIlterValue In FilterItem.RightValue Do
					DeleteFilterItemFromCashAccountTypeFilter(FIlterValue.Value);
				EndDo;
			EndIf;
		EndIf;
	EndDo;
EndProcedure

&AtServer
Procedure DeleteFilterItemFromCashAccountTypeFilter(FilterValue)
	FilterItem = Items.CashAccountTypeFilter.ChoiceList.FindByValue(FilterValue);
	If FilterItem <> Undefined Then
		Items.CashAccountTypeFilter.ChoiceList.Delete(FilterItem);
	EndIf;
EndProcedure

&AtClient
Procedure ListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	CommonFormActions.DynamicListBeforeAddRow(
				ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter, "Catalog.CashAccounts.ObjectForm");
EndProcedure

&AtClient
Procedure CashAccountTypeFilterOnChange(Item)
	If Not ValueIsFilled(CashAccountTypeFilter) Then
		CommonFunctionsClientServer.SetFilterItem(List.Filter.Items, "Type",
			Items.CashAccountTypeFilter.ChoiceList.UnloadValues(),
			DataCompositionComparisonType.InList, True);
	Else
		CommonFunctionsClientServer.SetFilterItem(List.Filter.Items, "Type",
			CashAccountTypeFilter,
			DataCompositionComparisonType.Equal, ValueIsFilled(CashAccountTypeFilter));
	EndIf;
EndProcedure
