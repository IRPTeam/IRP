
Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	Is = Is(Object);
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		FillFormAttributes(Object, Form, Is);
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	FillPaymentList(Object, Is);
	Taxes_CreateFormControls(Form, Is);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	Is = Is(Object);
	FillFormAttributes(Object, Form, Is);
	FillPaymentList(Object, Is);
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	Taxes_CreateFormControls(Form, Is);
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	Is = Is(Object);
	FillFormAttributes(Object, Form, Is);
	FillPaymentList(Object, Is);
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	Taxes_CreateFormControls(Form, Is);
EndProcedure

Procedure FillFormAttributes(Object, Form, Is)
	If Is.BankPayment Or Is.BankReceipt Then
		Form.CurrentCurrency        = Object.Currency;
		Form.CurrentAccount         = Object.Account;
		Form.CurrentTransactionType = Object.TransactionType;
	EndIf;
	If Is.CashPayment Or Is.CashReceipt Then
		Form.CurrentCurrency        = Object.Currency;
		Form.CurrentAccount         = Object.CashAccount;
		Form.CurrentTransactionType = Object.TransactionType;
	EndIf;
	If Is.CashExpense Or Is.CashRevenue Then
		If ValueIsFilled(Object.Account) Then
			Form.CurrentAccount = Object.Account;
			Form.Currency = ServiceSystemServer.GetObjectAttribute(Object.Account, "Currency");
		EndIf;
	EndIf;
	If Is.IncomingPaymentOrder Or Is.OutgoingPaymentOrder Then
		If ValueIsFilled(Object.Account) And ValueIsFilled(Object.Account.Currency) 
			And Not ValueIsFilled(Object.Currency) Then
			Object.Currency = Object.Account.Currency;
		EndIf;
	EndIf;
EndProcedure

Procedure FillPaymentList(Object, Is)
	If Is.BankPayment Or Is.CashPayment Or Is.BankReceipt Or Is.CashReceipt Then
		DocumentsServer.FillPaymentList(Object);
	EndIf;
EndProcedure

Procedure Taxes_CreateFormControls(Form, Is)
	If Is.CashExpense Or Is.CashRevenue Then
		Form.Taxes_CreateFormControls();
	EndIf;
EndProcedure

Procedure SetGroupItemsList(Object, Form)
	AllAttributes = StrSplit("Company, Account, CashAccount, Currency, PlanningPeriod, Status, TransactionType", ",");
	AttributesArray = New Array();
	For Each Atr In AllAttributes Do
		If Object.Property(TrimAll(Atr)) Then
			AttributesArray.Add(TrimAll(Atr));
		EndIf;
	EndDo;
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Atr In AttributesArray Do
		Form.GroupItems.Add(Atr, ?(ValueIsFilled(Form.Items[Atr].Title), Form.Items[Atr].Title,
			Object.Ref.Metadata().Attributes[Atr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

Function Is(Object)
	Result = New Structure();
	Result.Insert("BankPayment", TypeOf(Object.Ref) = Type("DocumentRef.BankPayment"));
	Result.Insert("CashPayment", TypeOf(Object.Ref) = Type("DocumentRef.CashPayment"));
	Result.Insert("BankReceipt", TypeOf(Object.Ref) = Type("DocumentRef.BankReceipt"));
	Result.Insert("CashReceipt", TypeOf(Object.Ref) = Type("DocumentRef.CashReceipt"));
	Result.Insert("CashExpense", TypeOf(Object.Ref) = Type("DocumentRef.CashExpense"));
	Result.Insert("CashRevenue", TypeOf(Object.Ref) = Type("DocumentRef.CashRevenue"));
	Result.Insert("IncomingPaymentOrder", TypeOf(Object.Ref) = Type("DocumentRef.IncomingPaymentOrder"));
	Result.Insert("OutgoingPaymentOrder", TypeOf(Object.Ref) = Type("DocumentRef.OutgoingPaymentOrder"));
	Return Result;
EndFunction
