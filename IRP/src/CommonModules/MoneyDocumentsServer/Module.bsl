
Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	Is = Is(Object);
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
		FillPaymentList(Object, Is);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	ViewServer_V2.OnCreateAtServer(Object, Form, "PaymentList");
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	Is = Is(Object);
	FillPaymentList(Object, Is);
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	Taxes_CreateFormControls(Form, Is);
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	Is = Is(Object);
	FillPaymentList(Object, Is);
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	Taxes_CreateFormControls(Form, Is);
EndProcedure

Procedure FillPaymentList(Object, Is)
	If Is.BankPayment Or Is.CashPayment Or Is.BankReceipt Or Is.CashReceipt Then
		For Each Row In Object.PaymentList Do
			Row.ApArPostingDetail = Row.Agreement.ApArPostingDetail;
		EndDo;
	EndIf;
EndProcedure

Procedure Taxes_CreateFormControls(Form, Is)
	If IsSupportTaxes(Is) Then
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

Function IsSupportTaxes(Is)
	Return Is.CashExpense Or Is.CashRevenue 
		Or Is.BankPayment Or Is.BankReceipt 
		Or Is.CashPayment Or Is.CashReceipt;
EndFunction

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
