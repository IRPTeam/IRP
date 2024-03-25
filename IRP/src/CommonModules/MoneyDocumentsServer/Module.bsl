
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
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	Is = Is(Object);
	FillPaymentList(Object, Is);
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

Procedure FillPaymentList(Object, Is)
	If Is.BankPayment Or Is.CashPayment Or Is.BankReceipt Or Is.CashReceipt Then
		For Each Row In Object.PaymentList Do
			Row.ApArPostingDetail = Row.Agreement.ApArPostingDetail;
		EndDo;
	EndIf;
EndProcedure

Procedure SetGroupItemsList(Object, Form)
	AllAttributes = StrSplit("Company, Account, CashAccount, Currency, PlanningPeriod, Status, TransactionType", ",");
	AttributesArray = New Array();
	For Each Attr In AllAttributes Do
		If Object.Property(TrimAll(Attr)) Then
			AttributesArray.Add(TrimAll(Attr));
		EndIf;
	EndDo;
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Attr In AttributesArray Do
		Form.GroupItems.Add(Attr, ?(ValueIsFilled(Form.Items[Attr].Title), Form.Items[Attr].Title,
			Object.Ref.Metadata().Attributes[Attr].Synonym + ":" + Chars.NBSp));
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

Procedure FillCheckProcessing_BankReceipt_CurrencyExchange(Object, Cancel) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R3021B_CashInTransitIncoming.Amount
	|FROM
	|	AccumulationRegister.R3021B_CashInTransitIncoming AS R3021B_CashInTransitIncoming
	|WHERE
	|	R3021B_CashInTransitIncoming.Basis IN (&ArrayOfBasises)
	|	AND R3021B_CashInTransitIncoming.Amount <> 0
	|	AND R3021B_CashInTransitIncoming.Recorder <> &Ref
	|	AND R3021B_CashInTransitIncoming.Recorder REFS Document.BankPayment";
	
	ArrayOfBasises = New Array();
	For Each Row In Object.PaymentList Do
		If ValueIsFilled(Row.PlaningTransactionBasis) Then
			ArrayOfBasises.Add(Row.PlaningTransactionBasis);
		EndIf;
	EndDo;
			
	Query.SetParameter("ArrayOfBasises", ArrayOfBasises);		
	Query.SetParameter("Ref", Object.Ref);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	If Not QuerySelection.Next() Then
		Cancel = True;
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_143);
	EndIf;
EndProcedure

