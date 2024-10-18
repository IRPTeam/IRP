
Function GetTaxVisibleParameters() Export
	Return New Structure("Object, Form, DocumentName, TransactionType");
EndFunction

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
	
	_arrayOfFormItems.Add("TransactionsVatRate");
	_arrayOfFormItems.Add("TransactionsNetAmount");
	_arrayOfFormItems.Add("TransactionsTaxAmount");
	
	For Each _item In _arrayOfFormItems Do
		If CommonFunctionsClientServer.ObjectHasProperty(Form.Items, _item) Then
			Form.Items[_item].Visible = Visible;
		EndIf;
	EndDo;
EndProcedure

Procedure ChangeTaxExemptionReasonVisible(Form, Visible) Export
	_arrayOfFormItems = New Array();
	
	_arrayOfFormItems.Add("TransactionsTaxExemptionReason");
	
	For Each _item In _arrayOfFormItems Do
		If CommonFunctionsClientServer.ObjectHasProperty(Form.Items, _item) Then
			Form.Items[_item].Visible = Visible;
		EndIf;
	EndDo;
EndProcedure

Procedure LoadChoiceList(Form, ChoiceList) Export
	LoadChoiceList_VatRate(Form, ChoiceList, "ItemListVATRate");
	LoadChoiceList_VatRate(Form, ChoiceList, "PaymentListVATRate");
	LoadChoiceList_VatRate(Form, ChoiceList, "TransactionsVATRate");
EndProcedure

Procedure LoadChoiceList_VatRate(Form, ChoiceList, ItemName)
	If CommonFunctionsClientServer.ObjectHasProperty(Form.Items, ItemName) Then
		Form.Items[ItemName].ChoiceList.Clear();
		Form.Items[ItemName].ChoiceList.LoadValues(ChoiceList);
	EndIf;	
EndProcedure	

