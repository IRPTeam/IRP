Function GetArrayOfTaxInfo(Form) Export
	SavedData = TaxesClientServer.GetSavedData(Form, TaxesServer.GetAttributeNames().CacheName);
	If SavedData.Property("ArrayOfColumnsInfo") Then
		Return SavedData.ArrayOfColumnsInfo;
	EndIf;
	Return New Array();
EndFunction

Function GetCalculateRowsActions() Export
	Actions = New Structure();
	Actions.Insert("CalculateTax");
	Actions.Insert("CalculateTotalAmount");
	Return Actions;
EndFunction

Function GetArrayOfTaxInfoFromServerData(Object, Form, AddInfo) Export
	ArrayOfTaxInfo = Undefined;
	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	If ServerData = Undefined Then
		If ServiceSystemClientServer.ObjectHasAttribute("TaxList", Object) Then
			ArrayOfTaxInfo = TaxesClient.GetArrayOfTaxInfo(Form);
		EndIf;
	Else
		ArrayOfTaxInfo = ServerData.ArrayOfTaxInfo;
	EndIf;
	Return ArrayOfTaxInfo;
EndFunction

Procedure CalculateReverseTaxOnChangeNetAmount(Object, Form, CurrentData, AddInfo = Undefined) Export
	ArrayOfTaxInfo = GetArrayOfTaxInfoFromServerData(Object, Form, AddInfo);
	
	ArrayRows = New Array();
	ArrayRows.Add(CurrentData);
	
	Actions = New Structure();
	Actions.Insert("CalculateTaxByNetAmount");
	Actions.Insert("CalculateTotalAmountByNetAmount");
	
	CalculationStringsClientServer.CalculateItemsRows(Object, Form, ArrayRows, Actions, ArrayOfTaxInfo, AddInfo);
EndProcedure

Procedure CalculateReverseTaxOnChangeTotalAmount(Object, Form, CurrentData, AddInfo = Undefined) Export
	ArrayOfTaxInfo = GetArrayOfTaxInfoFromServerData(Object, Form, AddInfo);

	If Object.Property("PriceIncludeTax") And Object.PriceIncludeTax Then
		CalculationStringsClientServer.CalculateTaxReverse_PriceIncludeTax(Object, CurrentData, ArrayOfTaxInfo);
		CurrentData.Price = ?(CurrentData.Quantity = 0, 0, CurrentData.TotalAmount / CurrentData.Quantity);
	Else
		CalculationStringsClientServer.CalculateTaxReverse_PriceNotIncludeTax(Object, CurrentData, ArrayOfTaxInfo);
		If CurrentData.Property("Price") Then
			CurrentData.Price = ?(CurrentData.Quantity = 0, 0, (CurrentData.TotalAmount - CurrentData.TaxAmount) / CurrentData.Quantity);
		EndIf;
	EndIf;

	ArrayRows = New Array();
	ArrayRows.Add(CurrentData);
	
	Actions = New Structure();
	Actions.Insert("CalculateNetAmountAsTotalAmountMinusTaxAmount");
	
	CalculationStringsClientServer.CalculateItemsRows(Object, Form, ArrayRows, Actions, ArrayOfTaxInfo, AddInfo);
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

	CalculationStringsClientServer.CalculateItemsRows(Object, Form, ArrayRows,
		New Structure("CalculateTax, CalculateTotalAmount, CalculateNetAmount"), ServerData.ArrayOfTaxInfo, AddInfo);
EndProcedure

Procedure ChangeTaxAmount2(Object, Form, Parameters, StandardProcessing, AddInfo = Undefined) Export
	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	If ServerData.ArrayOfTaxInfo.Count() = 1 And Object.TaxList.FindRows(New Structure("Key",
		Parameters.CurrentData.Key)).Count() = 1 Then
		Parameters.Field.ReadOnly  = False;
	Else
		Parameters.Field.ReadOnly  = True;
		MainTableData = New Structure();
		MainTableData.Insert("Key", Parameters.CurrentData.Key);
		If Object.Property("Currency") Then
			MainTableData.Insert("Currency", Object.Currency);
		Else
			MainTableData.Insert("Currency", Parameters.CurrentData.Currency);
		EndIf;
		OpenForm_ChangeTaxAmount(Object, Form, Parameters.Item, StandardProcessing, MainTableData, AddInfo);
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
	OpeningParameters.Insert("MainTableData", MainTableData);
	OpeningParameters.Insert("ArrayOfTaxListRows", ArrayOfTaxListRows);

	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("Object", Object);
	AdditionalParameters.Insert("Form", Form);
	AdditionalParameters.Insert("AddInfo", AddInfo);
	AdditionalParameters.Insert("MainTableData", MainTableData);

	Notify = New NotifyDescription("TaxEditContinue", ThisObject, AdditionalParameters);
	OpenForm("CommonForm.EditTax", OpeningParameters, Form, Form.UUID, , , Notify,
		FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

Procedure TaxEditContinue(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;

	UpdateTaxList(AdditionalParameters.Object, AdditionalParameters.Form, Result.Key, Result.ArrayOfTaxListRows,
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
	
	ArrayOfItemListRows = New Array();
	If Object.Property("ItemList") Then
		ArrayOfItemListRows = Object.ItemList.FindRows(New Structure("Key", Key));
	ElsIf Object.Property("PaymentList") Then
		ArrayOfItemListRows = Object.PaymentList.FindRows(New Structure("Key", Key));
	EndIf;
	
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
		If Object.Property("SpecialOffers") Then
			Actions.Insert("CalculateSpecialOffers");
		EndIf;
		Actions.Insert("CalculateNetAmount");
		Actions.Insert("CalculateTax");
		Actions.Insert("CalculateTotalAmount");

		CalculationStringsClientServer.CalculateItemsRows(Object, Form, ArrayOfItemListRows, Actions,
			ServerData.ArrayOfTaxInfo, AddInfo);
	Else
		Notify("CalculationStrngsComplete", New Structure("AddInfo", AddInfo), Form);
	EndIf;
EndProcedure
