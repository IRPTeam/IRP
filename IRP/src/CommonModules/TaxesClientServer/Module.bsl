
//#@2094
//Function GetTaxesCache(Form) Export
//	If CommonFunctionsClientServer.ObjectHasProperty(Form, "TaxesCache") And ValueIsFilled(Form.TaxesCache) Then
//		SavedDataStructure = CommonFunctionsServer.DeserializeXMLUseXDTO(Form.TaxesCache);
//	Else
//		SavedDataStructure = New Structure();
//		SavedDataStructure.Insert("ArrayOfTaxInfo", New Array());
//	EndIf;
//	Return SavedDataStructure;
//EndFunction

Function GetTaxVisibleParameters() Export
	Return New Structure("Object, Form, DocumentName, TransactionType");
EndFunction

//Procedure SetTaxVisible(Parameters) Export
//	// visible
//	_arrayOfTaxes = TaxesServer.GetTaxesInfo(
//		Parameters.Object.Date, 
//		Parameters.Object.Company, 
//		Parameters.DocumentName, 
//		Parameters.TransactionType, 
//		PredefinedValue("Enum.TaxKind.VAT"));
//	
//	_visible = _arrayOfTaxes.Count() <> 0;
//	ChangeVsible(Parameters.Form, _visible);
//	
//	If _visible Then
//		_choiceList = TaxesServer.GetTaxRatesByTax(_arrayOfTaxes[0].Tax); 
//		LoadChoiceList(Parameters.Form, _choiceList);	
//	EndIf;
//EndProcedure

Procedure ChangeVsible(Form, Visible) Export
	_arrayOfFormItems = New Array();
	_arrayOfFormItems.Add("ItemListTaxAmount");
	_arrayOfFormItems.Add("ItemListNetAmount");
	_arrayOfFormItems.Add("ItemListTotalTaxAmount");
	_arrayOfFormItems.Add("ItemListTotalNetAmount");
	_arrayOfFormItems.Add("ItemListVATRate");
	
	_arrayOfFormItems.Add("PaymentListTaxAmount");
	_arrayOfFormItems.Add("PaymentListNetAmount");
	_arrayOfFormItems.Add("PaymentListTotalTaxAmount");
	_arrayOfFormItems.Add("PaymentListTotalNetAmount");
	_arrayOfFormItems.Add("PaymentListVATRate");
	
	For Each _item In _arrayOfFormItems Do
		If CommonFunctionsClientServer.ObjectHasProperty(Form.Items, _item) Then
			Form.Items[_item].Visible = Visible;
		EndIf;
	EndDo;
EndProcedure

Procedure LoadChoiceList(Form, ChoiceList) Export
	If CommonFunctionsClientServer.ObjectHasProperty(Form.Items, "ItemListVATRate") Then
		Form.Items["ItemListVATRate"].ChoiceList.Clear();
		Form.Items["ItemListVATRate"].ChoiceList.LoadValues(ChoiceList);
	EndIf;
	
	If CommonFunctionsClientServer.ObjectHasProperty(Form.Items, "PaymentListVATRate") Then
		Form.Items["PaymentListVATRate"].ChoiceList.Clear();
		Form.Items["PaymentListVATRate"].ChoiceList.LoadValues(ChoiceList);
	EndIf;
EndProcedure






