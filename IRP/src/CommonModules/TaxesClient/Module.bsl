
Function GetArrayOfTaxInfo(Form) Export
	TaxesCache = TaxesClientServer.GetTaxesCache(Form);
	If TaxesCache.Property("ArrayOfTaxInfo") Then
		Return TaxesCache.ArrayOfTaxInfo;
	EndIf;
	Return New Array();
EndFunction

// @deprecated
//Function GetCalculateRowsActions() Export
//	Actions = New Structure();
//	Actions.Insert("CalculateTax");
//	Actions.Insert("CalculateTotalAmount");
//	Return Actions;
//EndFunction

// @deprecated
//Function GetArrayOfTaxInfoFromServerData(Object, Form, AddInfo) Export
//	ArrayOfTaxInfo = Undefined;
//	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
//	If ServerData = Undefined Then
//		If CommonFunctionsClientServer.ObjectHasProperty(Object, "TaxList") Then
//			ArrayOfTaxInfo = TaxesClient.GetArrayOfTaxInfo(Form);
//		EndIf;
//	Else
//		ArrayOfTaxInfo = ServerData.ArrayOfTaxInfo;
//	EndIf;
//	Return ArrayOfTaxInfo;
//EndFunction

// @deprecated
//Procedure CalculateReverseTaxOnChangeNetAmount(Object, Form, CurrentData, AddInfo = Undefined) Export
//	ArrayOfTaxInfo = GetArrayOfTaxInfoFromServerData(Object, Form, AddInfo);
//	
//	ArrayRows = New Array();
//	ArrayRows.Add(CurrentData);
//	
//	Actions = New Structure();
//	Actions.Insert("CalculateTaxByNetAmount");
//	Actions.Insert("CalculateTotalAmountByNetAmount");
//	
//	CalculationStringsClientServer.CalculateItemsRows(Object, Form, ArrayRows, Actions, ArrayOfTaxInfo, AddInfo);
//EndProcedure

// @deprecated
//Procedure CalculateReverseTaxOnChangeTotalAmount(Object, Form, CurrentData, AddInfo = Undefined) Export
//	ArrayOfTaxInfo = GetArrayOfTaxInfoFromServerData(Object, Form, AddInfo);
//
//	If Object.Property("PriceIncludeTax") And Object.PriceIncludeTax Then
//		CalculationStringsClientServer.CalculateTaxReverse_PriceIncludeTax(Object, CurrentData, ArrayOfTaxInfo);
//		CurrentData.Price = ?(CurrentData.Quantity = 0, 0, CurrentData.TotalAmount / CurrentData.Quantity);
//	Else
//		CalculationStringsClientServer.CalculateTaxReverse_PriceNotIncludeTax(Object, CurrentData, ArrayOfTaxInfo);
//		If CurrentData.Property("Price") Then
//			CurrentData.Price = ?(CurrentData.Quantity = 0, 0, (CurrentData.TotalAmount - CurrentData.TaxAmount) / CurrentData.Quantity);
//		EndIf;
//	EndIf;
//
//	ArrayRows = New Array();
//	ArrayRows.Add(CurrentData);
//	
//	Actions = New Structure();
//	Actions.Insert("CalculateNetAmountAsTotalAmountMinusTaxAmount");
//	
//	CalculationStringsClientServer.CalculateItemsRows(Object, Form, ArrayRows, Actions, ArrayOfTaxInfo, AddInfo);
//EndProcedure

// @deprecated
//Procedure CalculateTaxOnChangeTaxValue(Object, Form, CurrentData, Item, AddInfo = Undefined) Export
//	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
//
//	TaxRef = Undefined;
//	For Each ItemOfColumnsInfo In ServerData.ArrayOfTaxInfo Do
//		If ItemOfColumnsInfo.Name = Item.Name Then
//			TaxRef = ItemOfColumnsInfo.Tax;
//			Break;
//		EndIf;
//	EndDo;
//	If Not ValueIsFilled(TaxRef) Then
//		Raise StrTemplate(R().Error_042, Item.Name);
//	EndIf;
//
//	ArrayOfRowsTaxTable = Form.TaxesTable.FindRows(New Structure("Key, Tax", CurrentData.Key, TaxRef));
//	TaxTableRow = Undefined;
//	If ArrayOfRowsTaxTable.Count() = 0 Then
//		TaxTableRow = Form.TaxesTable.Add();
//	ElsIf ArrayOfRowsTaxTable.Count() = 1 Then
//		TaxTableRow = ArrayOfRowsTaxTable[0];
//	Else
//		Raise StrTemplate(R().Error_041, CurrentData.Key, TaxRef);
//	EndIf;
//	TaxTableRow.Key = CurrentData.Key;
//	TaxTableRow.Tax = TaxRef;
//	TaxTableRow.Value =  CurrentData[Item.Name];
//
//	ArrayRows = New Array();
//	ArrayRows.Add(CurrentData);
//
//	CalculationStringsClientServer.CalculateItemsRows(Object, Form, ArrayRows,
//		New Structure("CalculateTax, CalculateTotalAmount, CalculateNetAmount"), ServerData.ArrayOfTaxInfo, AddInfo);
//EndProcedure

Procedure ListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	CurrentData = Undefined;
	If Upper(Field.Name) = Upper("ItemListTaxAmount") Then
		CurrentData = Form.Items.ItemList.CurrentData;
	ElsIf Upper(Field.Name) = Upper("PaymentListTaxAmount") Then
		CurrentData = Form.Items.PaymentList.CurrentData;
	EndIf;
	
	If CurrentData <> Undefined Then
		Parameters = New Structure("CurrentData, Item, Field", CurrentData, Item, Field);
		ChangeTaxAmount(Object, Form, Parameters, StandardProcessing);
	EndIf;
EndProcedure	
	
Procedure ChangeTaxAmount(Object, Form, Parameters, StandardProcessing) Export
	ArrayOfTaxInfo = GetArrayOfTaxInfo(Form);
	If ArrayOfTaxInfo.Count() = 1 
		And Object.TaxList.FindRows(New Structure("Key", Parameters.CurrentData.Key)).Count() = 1 Then
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
		OpenForm_ChangeTaxAmount(Object, Form, Parameters.Item, StandardProcessing, MainTableData);
	EndIf;
EndProcedure

Procedure OpenForm_ChangeTaxAmount(Object, Form, Item, StandardProcessing, MainTableData)
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
	AdditionalParameters.Insert("Object"        , Object);
	AdditionalParameters.Insert("Form"          , Form);
	AdditionalParameters.Insert("MainTableData" , MainTableData);

	Notify = New NotifyDescription("TaxEditContinue", ThisObject, AdditionalParameters);
	OpenForm("CommonForm.EditTax", OpeningParameters, Form, Form.UUID, , , Notify,
		FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

Procedure TaxEditContinue(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;

	Object = AdditionalParameters.Object;
	Form   = AdditionalParameters.Form;
		
	For Each Row In Result.ArrayOfTaxListRows Do
		TaxListRows = Object.TaxList.FindRows(New Structure("Key, Tax", Result.Key, Row.Tax));
		For Each TaxListRow In TaxListRows Do
			TaxListRow.ManualAmount = Row.ManualAmount;
		EndDo;	
	EndDo;
	
	If Object.Property("ItemList") Then
		ViewClient_V2.ItemListTaxAmountUserFormOnChange(Object, Form);
	ElsIf Object.Property("PaymentList") Then
		ViewClient_V2.PaymentListTaxAmountUserFormOnChange(Object, Form);
	EndIf;
EndProcedure
