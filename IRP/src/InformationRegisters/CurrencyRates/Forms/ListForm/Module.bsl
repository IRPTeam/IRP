
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Property("Currency") Then
		GroupOr = List.Filter.Items.Add(Type("DataCompositionFilterItemGroup"));
		GroupOr.GroupType = DataCompositionFilterItemsGroupType.OrGroup;
		GroupOr.Use = True;
		
		FilterFrom = GroupOr.Items.Add(Type("DataCompositionFilterItem"));
		FilterFrom.LeftValue = New DataCompositionField("CurrencyFrom");
		FilterFrom.RightValue = Parameters.Currency;
		FilterFrom.Use = True;
		
		FilterTo = GroupOr.Items.Add(Type("DataCompositionFilterItem"));
		FilterTo.LeftValue = New DataCompositionField("CurrencyTo");
		FilterTo.RightValue = Parameters.Currency;
		FilterTo.Use = True;
	EndIf;
EndProcedure
