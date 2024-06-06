
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
