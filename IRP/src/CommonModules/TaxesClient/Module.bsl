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
 
Function ChangeTaxAmount(Object, Form, CurrentData, MainTable, Val Actions = Undefined, AddInfo = Undefined) Export
	
	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	If ServerData = Undefined Then
		ArrayOfTaxInfo        = GetArrayOfTaxInfo(Form);
		Taxes_EmptyRef        = PredefinedValue("Catalog.Taxes.EmptyRef");
		TaxAnalytics_EmptyRef = PredefinedValue("Catalog.TaxAnalytics.EmptyRef");
		TaxRates_EmptyRef     = PredefinedValue("Catalog.TaxRates.EmptyRef");
	Else
		ArrayOfTaxInfo        = ServerData.ArrayOfTaxInfo;
		Taxes_EmptyRef        = ServerData.Taxes_EmptyRef;
		TaxAnalytics_EmptyRef = ServerData.TaxAnalytics_EmptyRef;
		TaxRates_EmptyRef     = ServerData.TaxRates_EmptyRef;
	EndIf;

	Filter = New Structure();
	Filter.Insert("Key", CurrentData.Key);
	Filter.Insert("Tax", ?(ValueIsFilled(CurrentData.Tax)             , CurrentData.Tax       , Taxes_EmptyRef));
	Filter.Insert("Analytics", ?(ValueIsFilled(CurrentData.Analytics) , CurrentData.Analytics , TaxAnalytics_EmptyRef));
	Filter.Insert("TaxRate", ?(ValueIsFilled(CurrentData.TaxRate)     , CurrentData.TaxRate   , TaxRates_EmptyRef));
	
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
		ArrayOfTaxInfo,
		AddInfo);
	Return Filter;
EndFunction

Function GetCalculateRowsActions() Export
	Actions = New Structure();
	Actions.Insert("CalculateTax");
	Actions.Insert("CalculateTotalAmount");
	Return Actions;
EndFunction

Procedure CalculateReverseTaxOnChangeTotalAmount(Object, Form, CurrentData, AddInfo = Undefined) Export
	ArrayOfTaxInfo = Undefined;
	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	If ServerData = Undefined Then
		If ServiceSystemClientServer.ObjectHasAttribute("TaxList", Object) Then
			ArrayOfTaxInfo = TaxesClient.GetArrayOfTaxInfo(Form);
		EndIf;
	Else
		ArrayOfTaxInfo = ServerData.ArrayOfTaxInfo;
	EndIf;
	
	If Object.Property("PriceIncludeTax") And Object.PriceIncludeTax Then
		CalculationStringsClientServer.CalculateTaxReverse_PriceIncludeTax(Object, CurrentData, ArrayOfTaxInfo);
		CurrentData.Price = ?(CurrentData.Quantity = 0, 0, CurrentData.TotalAmount / CurrentData.Quantity);
	Else
		CalculationStringsClientServer.CalculateTaxReverse_PriceNotIncludeTax(Object, CurrentData, ArrayOfTaxInfo);
		CurrentData.Price = ?(CurrentData.Quantity = 0, 0, (CurrentData.TotalAmount - CurrentData.TaxAmount) / CurrentData.Quantity);	
	EndIf;
	
	ArrayRows = New Array();
	ArrayRows.Add(CurrentData);
	
	CalculationStringsClientServer.CalculateItemsRows(Object,
		Form,
		ArrayRows,
		New Structure("CalculateNetAmountAsTotalAmountMinusTaxAmount"),
		ArrayOfTaxInfo,
		AddInfo);
EndProcedure

Procedure CalculateTaxOnChangeTaxValue(Object, Form, CurrentData, Item, AddInfo = Undefined) Export
	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	
	TaxRef = Undefined;
	For Each ItemOfColumnsInfo In ServerData.ArrayOfTaxInfo Do
		If ItemOfColumnsInfo.Name = Item.Name Then
			TaxRef = ItemOfColumnsInfo.Tax;
			Break;
		EndIf;
	EndDo;
	If Not ValueIsFilled(TaxRef) Then
		Raise StrTemplate(R().Error_042, Item.Name);
	EndIf;
	
	ArrayOfRowsTaxTable = Form.TaxesTable.FindRows(New Structure("Key, Tax", CurrentData.Key, TaxRef));
	TaxTableRow = Undefined;
	If ArrayOfRowsTaxTable.Count() = 0 Then
		TaxTableRow = Form.TaxesTable.Add();
	ElsIf ArrayOfRowsTaxTable.Count() = 1 Then
		TaxTableRow = ArrayOfRowsTaxTable[0];
	Else
		Raise StrTemplate(R().Error_041, CurrentData.Key, TaxRef);
	EndIf;
	TaxTableRow.Key = CurrentData.Key;
	TaxTableRow.Tax = TaxRef;
	TaxTableRow.Value =  CurrentData[Item.Name];	
	
	ArrayRows = New Array();
	ArrayRows.Add(CurrentData);
	
	CalculationStringsClientServer.CalculateItemsRows(Object,
		Form,
		ArrayRows,
		New Structure("CalculateTax, CalculateTotalAmount, CalculateNetAmount"),
		ServerData.ArrayOfTaxInfo,
		AddInfo);	
EndProcedure

Procedure ChangeTaxAmount2(Object, Form, Parameters, StandardProcessing, AddInfo = Undefined) Export
	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	If  ServerData.ArrayOfTaxInfo.Count() = 1 And
		Object.TaxList.FindRows(New Structure("Key", Parameters.CurrentData.Key)).Count() = 1 Then
		Parameters.Field.ReadOnly  = False;
	Else
		Parameters.Field.ReadOnly  = True;
		MainTableData = New Structure();
		MainTableData.Insert("Key"      , Parameters.CurrentData.Key);
		MainTableData.Insert("Currency" , Object.Currency);
			
		OpenForm_ChangeTaxAmount(Object, 
								 Form, 
								 Parameters.Item, 
								 StandardProcessing,
								 MainTableData,
								 AddInfo);
	EndIf;
EndProcedure	
	
Procedure OpenForm_ChangeTaxAmount(Object, Form, Item, StandardProcessing, MainTableData, AddInfo = Undefined)
	StandardProcessing = False;
	
	ArrayOfTaxListRows = New Array();
	For Each Row In Object.TaxList.FindRows(New Structure("Key", MainTableData.Key)) Do
		NewRowTaxList = New Structure("Key, Tax, Analytics, TaxRate, Amount, IncludeToTotalAmount, ManualAmount");
		FillPropertyValues(NewRowTaxList, Row);
		ArrayOfTaxListRows.Add(NewRowTaxList);
	EndDo;
	
	OpeningParameters = New Structure();
	OpeningParameters.Insert("MainTableData"      , MainTableData);
	OpeningParameters.Insert("ArrayOfTaxListRows" , ArrayOfTaxListRows);
	
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("Object"        , Object);
	AdditionalParameters.Insert("Form"          , Form); 
	AdditionalParameters.Insert("AddInfo"       , AddInfo);
	AdditionalParameters.Insert("MainTableData" , MainTableData);
	
	Notify = New NotifyDescription("TaxEditContinue", ThisObject, AdditionalParameters);
	OpenForm("CommonForm.EditTax", OpeningParameters, Form, Form.UUID, , , Notify , FormWindowOpeningMode.LockOwnerWindow);
EndProcedure
	
Procedure TaxEditContinue(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;

	UpdateTaxList(AdditionalParameters.Object, 
	              AdditionalParameters.Form, 
	              Result.Key, 
	              Result.ArrayOfTaxListRows, 
	              AdditionalParameters.AddInfo);
EndProcedure

Procedure UpdateTaxList(Object, Form, Key, ArrayOfTaxListRows, AddInfo = Undefined) Export
		
	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	ArrayForDelete = Object.TaxList.FindRows(New Structure("Key", Key));
	For Each ItemOfArrayForDelete In ArrayForDelete Do
		Object.TaxList.Delete(ItemOfArrayForDelete);
	EndDo;
	TotalTaxAmount = 0;
	For Each ItemOfArrayOfTaxListRows In ArrayOfTaxListRows Do
		FillPropertyValues(Object.TaxList.Add(), ItemOfArrayOfTaxListRows);
		If ItemOfArrayOfTaxListRows.IncludeToTotalAmount Then
			TotalTaxAmount = TotalTaxAmount + ItemOfArrayOfTaxListRows.ManualAmount;
		EndIf;
	EndDo;
	ArrayOfItemListRows = Object.ItemList.FindRows(New Structure("Key", Key));
	
	IsCalculatedRow = True;
	For Each ItemOfItemListRows In ArrayOfItemListRows Do
		If CommonFunctionsClientServer.ObjectHasProperty(ItemOfItemListRows, "DontCalculateRow")
		  And ItemOfItemListRows.DontCalculateRow Then
			IsCalculatedRow = False;
			ItemOfItemListRows.TaxAmount = TotalTaxAmount;	
		EndIf;
	EndDo;
	
	If IsCalculatedRow Then
		Actions = New Structure();
		Actions.Insert("CalculateSpecialOffers");
		Actions.Insert("CalculateNetAmount");
		Actions.Insert("CalculateTax");
		Actions.Insert("CalculateTotalAmount");

		CalculationStringsClientServer.CalculateItemsRows(Object,
		                                              	  Form,
		                                              	  ArrayOfItemListRows,
		                                              	  Actions,
		                                              	  ServerData.ArrayOfTaxInfo,
		                                              	  AddInfo);
	Else
		Notify("CallbackHandler", New Structure("AddInfo", AddInfo), Form);
	EndIf;
EndProcedure
	
