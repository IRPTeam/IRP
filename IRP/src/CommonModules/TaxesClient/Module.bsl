Function GetArrayOfTaxInfo(Form) Export
	SavedData = TaxesClientServer.GetSavedData(Form, TaxesServer.GetAttributeNames().CacheName);
	If SavedData.Property("ArrayOfColumnsInfo") Then
		Return SavedData.ArrayOfColumnsInfo;
	EndIf;
	Return New Array();
EndFunction

Function FindRowInTree(Filter, Tree) Export
	RowID = Undefined;
	FindRowInTreeRecursive(Filter, Tree.GetItems(), RowID);
	Return RowID;
EndFunction

Procedure FindRowInTreeRecursive(Filter, TreeRows, RowID)
	For Each Row In TreeRows Do
		If RowID <> Undefined Then
			Return;
		EndIf;
		Founded = True;
		For Each ItemOfFilter In Filter Do
			If Row[ItemOfFilter.Key] <> Filter[ItemOfFilter.Key] Then
				Founded = False;
				Break;
			EndIf;
		EndDo;
		If Founded Then
			RowID = Row.GetID();
		EndIf;
		If RowID = Undefined Then
			FindRowInTreeRecursive(Filter, Row.GetItems(), RowID);
		EndIf;
	EndDo;
EndProcedure

Procedure ExpandTaxTree(Tree, TreeRows) Export
	For Each ItemTreeRows In TreeRows Do
		Tree.Expand(ItemTreeRows.GetID());
	EndDo;
EndProcedure

Function ChangeTaxAmount(Object, Form, CurrentData, MainTable, Val Actions = Undefined) Export
	Filter = New Structure();
	Filter.Insert("Key", CurrentData.Key);
	Filter.Insert("Tax", ?(ValueIsFilled(CurrentData.Tax), CurrentData.Tax, PredefinedValue("Catalog.Taxes.EmptyRef")));
	Filter.Insert("Analytics", ?(ValueIsFilled(CurrentData.Analytics), CurrentData.Analytics, PredefinedValue("Catalog.TaxAnalytics.EmptyRef")));
	Filter.Insert("TaxRate", ?(ValueIsFilled(CurrentData.TaxRate), CurrentData.TaxRate, PredefinedValue("Catalog.TaxRates.EmptyRef")));
	
	ArrayOfFoundedTaxListRows = Object.TaxList.FindRows(Filter);
	
	If ArrayOfFoundedTaxListRows.Count() <> 1 Then
		Raise StrTemplate("Founded %1 rows by key: %2 In TaxList table.");
	EndIf;
	If Actions = Undefined Then
		Actions = CalculationStringsClientServer.GetCalculationSettings();
	EndIf;
	ArrayOfFoundedTaxListRows[0].ManualAmount = CurrentData.ManualAmount;
	
	Rows = MainTable.FindRows(New Structure("Key", CurrentData.Key));
	CalculationStringsClientServer.CalculateItemsRows(Object,
		Form,
		Rows,
		Actions,
		GetArrayOfTaxInfo(Form));
	Return Filter;
EndFunction

Function GetCalculateRowsActions() Export
	Actions = New Structure();
	Actions.Insert("CalculateTax");
	Actions.Insert("CalculateTotalAmount");
	Return Actions;
EndFunction

Procedure ChangeTaxRatesByAgreement(Object, Form) Export
	If Not ValueIsFilled(Object.Agreement) Then
		Return;
	EndIf;
	
	ArrayOfTaxInfo = TaxesClient.GetArrayOfTaxInfo(Form);
	ArrayOfCurrentTaxInfo = New Array();
	For Each ItemOfTaxInfo In ArrayOfTaxInfo Do
		If ItemOfTaxInfo.Type = PredefinedValue("Enum.TaxType.Rate") Then
			ArrayOfCurrentTaxRates = New Array();
			For Each RowItemList In Object.ItemList Do
				SelectedTaxRate = RowItemList[ItemOfTaxInfo.Name];
				If ValueIsFilled(SelectedTaxRate) Then
					ArrayOfCurrentTaxRates.Add(SelectedTaxRate);
				EndIf;
			EndDo;
			
			CurrentTaxInfo = New Structure();
			CurrentTaxInfo.Insert("Date", Object.Date);
			CurrentTaxInfo.Insert("Company", Object.Company);
			CurrentTaxInfo.Insert("Agreement", Object.Agreement);
			CurrentTaxInfo.Insert("Tax", ItemOfTaxInfo.Tax);
			CurrentTaxInfo.Insert("ArrayOfCurrentTaxRates", ArrayOfCurrentTaxRates);
			CurrentTaxInfo.Insert("TaxInfo", ItemOfTaxInfo);
			
			ArrayOfCurrentTaxInfo.Add(CurrentTaxInfo);
		EndIf;
	EndDo;
	
	ArrayOfChangeTaxParameters = New Array();
	
	For Each ItemOfCurrentTaxInfo In ArrayOfCurrentTaxInfo Do
		ArrayOfTaxRates = TaxesServer.TaxRatesForAgreement(ItemOfCurrentTaxInfo);
		If Not ArrayOfTaxRates.Count() Then
			Break;
		EndIf;
		For Each CurrentTaxRate In ItemOfCurrentTaxInfo.ArrayOfCurrentTaxRates Do
			If CurrentTaxRate <> ArrayOfTaxRates[0].TaxRate Then
				ArrayOfChangeTaxParameters.Add(ItemOfCurrentTaxInfo);
				Break;
			EndIf;
		EndDo;
	EndDo;
	
	If ArrayOfChangeTaxParameters.Count() Then
		Notify = New NotifyDescription("ChangeTaxRates", ThisObject
				, New Structure("Object, Form, ArrayOfChangeTaxParameters", Object, Form, ArrayOfChangeTaxParameters));
		ShowQueryBox(Notify, R()["QuestionToUser_004"], QuestionDialogMode.YesNo);
	EndIf;
EndProcedure

Procedure ChangeTaxRates(Result, Parameters = Undefined) Export
	If Not Result = DialogReturnCode.Yes Then
		Return;
	EndIf;
	For Each i In Parameters.ArrayOfChangeTaxParameters Do
		For Each Row In Parameters.Object.ItemList Do
			Row[i.TaxInfo.Name] = Undefined;
		EndDo;
	EndDo;
	CalculationStringsClientServer.CalculateItemsRows(Parameters.Object,
		Parameters.Form,
		Parameters.Object.ItemList,
		TaxesClient.GetCalculateRowsActions(),
		TaxesClient.GetArrayOfTaxInfo(Parameters.Form));
EndProcedure

Procedure CalculateReverseTaxOnChangeTotalAmount(Object, Form, CurrentData) Export
	ArrayOfTaxInfo = TaxesClient.GetArrayOfTaxInfo(Form);
	If Object.Property("PriceIncludeTax") And Object.PriceIncludeTax Then
		CalculationStringsClientServer.CalculateTaxReverse_PriceIncludeTax(Object, CurrentData, ArrayOfTaxInfo);
	Else
		CalculationStringsClientServer.CalculateTaxReverse_PriceNotIncludeTax(Object, CurrentData, ArrayOfTaxInfo);
	EndIf;
	CurrentData.Price = ?(CurrentData.Quantity = 0, 0, (CurrentData.TotalAmount - CurrentData.TaxAmount) / CurrentData.Quantity);
	
	CalculationStringsClientServer.CalculateItemsRows(Object,
		Form,
		Object.ItemList,
		TaxesClient.GetCalculateRowsActions(),
		ArrayOfTaxInfo);
EndProcedure

