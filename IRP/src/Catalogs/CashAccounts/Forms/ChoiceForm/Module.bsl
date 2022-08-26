&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatCashAccountsServer.OnCreateAtServer(Cancel, StandardProcessing, ThisObject, Parameters);
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);

//	For Each FilterItem In List.Filter.Items Do
//		If TypeOf(FilterItem) = Type("DataCompositionFilterItem") And FilterItem.LeftValue = New DataCompositionField("Type") Then
//		
//			If FilterItem.ComparisonType = DataCompositionComparisonType.Equal Then
//				ThisObject.CashAccountTypeFilter = FilterItem.RightValue;
//				Items.CashAccountTypeFilter.ReadOnly = True;
//			ElsIf FilterItem.ComparisonType = DataCompositionComparisonType.NotEqual Then
//				DeleteFilterItemFromCashAccountTypeFilter(FilterItem.RightValue);
//			ElsIf FilterItem.ComparisonType = DataCompositionComparisonType.NotInList Then
//				For Each FilterValue In FilterItem.RightValue Do
//					DeleteFilterItemFromCashAccountTypeFilter(FilterValue.Value);
//				EndDo;
//			EndIf;
//			
//		EndIf;
//	EndDo;
	
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
Procedure OnOpen(Cancel)
	For Each FilterItem In List.Filter.Items Do
		If TypeOf(FilterItem) = Type("DataCompositionFilterItem") And FilterItem.LeftValue = New DataCompositionField("Type") Then
		
			ArrayOfAvailableTypes = New Array();
			If FilterItem.ComparisonType = DataCompositionComparisonType.Equal Then
				ArrayOfAvailableTypes.Add(FilterItem.RightValue);
				ThisObject.CashAccountTypeFilter = FilterItem.RightValue;
				Items.CashAccountTypeFilter.ReadOnly = True;
			ElsIf FilterItem.ComparisonType = DataCompositionComparisonType.InList Then
				For Each FilterValue In FilterItem.RightValue Do
					ArrayOfAvailableTypes.Add(FilterValue.Value);
				EndDo;
			EndIf;
			
			ArrayForDelete = New Array();
			For Each FilterItem In Items.CashAccountTypeFilter.ChoiceList Do
				If ArrayOfAvailableTypes.Find(FilterItem.Value) = Undefined Then
					ArrayForDelete.Add(FilterItem);
				EndIf;
			EndDo;
			
			For Each FilterItem In ArrayForDelete Do
				Items.CashAccountTypeFilter.ChoiceList.Delete(FilterItem);
			EndDo;
					
		EndIf;
	EndDo;	
EndProcedure

//&AtServer
//Procedure DeleteFilterItemFromCashAccountTypeFilter(FilterValue)
//	FilterItem = Items.CashAccountTypeFilter.ChoiceList.FindByValue(FilterValue);
//	If FilterItem <> Undefined Then
//		Items.CashAccountTypeFilter.ChoiceList.Delete(FilterItem);
//	EndIf;
//EndProcedure

&AtClient
Procedure ListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Return;
	// for remove
	//CommonFormActions.DynamicListBeforeAddRow(ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter, "Catalog.CashAccounts.ObjectForm");
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
