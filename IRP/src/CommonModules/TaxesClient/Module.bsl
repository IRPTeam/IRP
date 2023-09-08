
//#@2094
//
//Function GetArrayOfTaxInfo(Form) Export
//	TaxesCache = TaxesClientServer.GetTaxesCache(Form);
//	If TaxesCache.Property("ArrayOfTaxInfo") Then
//		Return TaxesCache.ArrayOfTaxInfo;
//	EndIf;
//	Return New Array();
//EndFunction
//
//Procedure ListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
//	CurrentData = Undefined;
//	If Upper(Field.Name) = Upper("ItemListTaxAmount") Then
//		CurrentData = Form.Items.ItemList.CurrentData;
//	ElsIf Upper(Field.Name) = Upper("PaymentListTaxAmount") Then
//		CurrentData = Form.Items.PaymentList.CurrentData;
//	EndIf;
//	
//	If CurrentData <> Undefined Then
//		Parameters = New Structure("CurrentData, Item, Field", CurrentData, Item, Field);
//		ChangeTaxAmount(Object, Form, Parameters, StandardProcessing);
//	EndIf;
//EndProcedure	
	
//Procedure ChangeTaxAmount(Object, Form, Parameters, StandardProcessing) Export
//	ArrayOfTaxInfo = GetArrayOfTaxInfo(Form);
//	If ArrayOfTaxInfo.Count() = 1 
//		And Object.TaxList.FindRows(New Structure("Key", Parameters.CurrentData.Key)).Count() = 1 Then
//		Parameters.Field.ReadOnly  = False;
//	Else
//		Parameters.Field.ReadOnly  = True;
//		MainTableData = New Structure();
//		MainTableData.Insert("Key", Parameters.CurrentData.Key);
//		If Object.Property("Currency") Then
//			MainTableData.Insert("Currency", Object.Currency);
//		Else
//			MainTableData.Insert("Currency", Parameters.CurrentData.Currency);
//		EndIf;
//		OpenForm_ChangeTaxAmount(Object, Form, Parameters.Item, StandardProcessing, MainTableData);
//	EndIf;
//EndProcedure

//Procedure OpenForm_ChangeTaxAmount(Object, Form, Item, StandardProcessing, MainTableData)
//	StandardProcessing = False;
//
//	ArrayOfTaxListRows = New Array();
//	For Each Row In Object.TaxList.FindRows(New Structure("Key", MainTableData.Key)) Do
//		NewRowTaxList = New Structure("Key, Tax, Analytics, TaxRate, Amount, IncludeToTotalAmount, ManualAmount");
//		FillPropertyValues(NewRowTaxList, Row);
//		ArrayOfTaxListRows.Add(NewRowTaxList);
//	EndDo;
//
//	OpeningParameters = New Structure();
//	OpeningParameters.Insert("MainTableData", MainTableData);
//	OpeningParameters.Insert("ArrayOfTaxListRows", ArrayOfTaxListRows);
//
//	AdditionalParameters = New Structure();
//	AdditionalParameters.Insert("Object"        , Object);
//	AdditionalParameters.Insert("Form"          , Form);
//	AdditionalParameters.Insert("MainTableData" , MainTableData);
//
//	Notify = New NotifyDescription("TaxEditContinue", ThisObject, AdditionalParameters);
//	OpenForm("CommonForm.EditTax", OpeningParameters, Form, Form.UUID, , , Notify,
//		FormWindowOpeningMode.LockOwnerWindow);
//EndProcedure

//Procedure TaxEditContinue(Result, AdditionalParameters) Export
//	If Result = Undefined Then
//		Return;
//	EndIf;
//
//	Object = AdditionalParameters.Object;
//	Form   = AdditionalParameters.Form;
//		
//	For Each Row In Result.ArrayOfTaxListRows Do
//		TaxListRows = Object.TaxList.FindRows(New Structure("Key, Tax", Result.Key, Row.Tax));
//		For Each TaxListRow In TaxListRows Do
//			TaxListRow.ManualAmount = Row.ManualAmount;
//		EndDo;	
//	EndDo;
//	
//	If Object.Property("ItemList") Then
//		ViewClient_V2.ItemListTaxAmountUserFormOnChange(Object, Form);
//	ElsIf Object.Property("PaymentList") Then
//		ViewClient_V2.PaymentListTaxAmountUserFormOnChange(Object, Form);
//	EndIf;
//EndProcedure
