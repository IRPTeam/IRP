&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatCashAccountsServer.OnCreateAtServer(Cancel, StandardProcessing, ThisObject, Parameters);
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	CatalogsServer.OnCreateAtServerChoiceForm(ThisObject, List, Cancel, StandardProcessing);
	
	CatCashAccountsServer.RemoveUnusedAccountTypes(ThisObject, "CashAccountTypeFilter");
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

#Region COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	SelectedRows = Items.List.SelectedRows;
	ExternalCommandsClient.GeneratedListChoiceFormCommandActionByName(SelectedRows, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name, SelectedRows);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName, SelectedRows) Export
	ExternalCommandsServer.GeneratedListChoiceFormCommandActionByName(SelectedRows, ThisObject, CommandName);
EndProcedure

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, List, Items.List.SelectedRows);
EndProcedure

#EndRegion