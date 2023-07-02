#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	ViewServer_V2.OnCreateAtServer(Object, Form, "");
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	LockDataModificationPrivileged.LockFormIfObjectIsLocked(Form, CurrentObject);
EndProcedure

#EndRegion

#Region LIST_FORM

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region CHOICE_FORM

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region SERVICE

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Attr In AttributesArray Do
		Form.GroupItems.Add(Attr, ?(ValueIsFilled(Form.Items[Attr].Title), Form.Items[Attr].Title,
			Object.Ref.Metadata().Attributes[Attr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion

Function UseCashAdvanceHolder(Val Object) Export
	If Object.Sender.Type = Enums.CashAccountTypes.Cash And Object.Receiver.Type = Enums.CashAccountTypes.Cash
		And ValueIsFilled(Object.SendCurrency) And ValueIsFilled(Object.ReceiveCurrency) And Object.SendCurrency
		<> Object.ReceiveCurrency Then
		Return True;
	EndIf;
	Return False;
EndFunction

Function GetInfoForFillingCashReceipt(Ref) Export
	Result = New Structure("Ref, 
		|CashAccount, 
		|Company, 
		|Currency, 
		|CurrencyExchange,
		|SendingAccount, 
		|SendingBranch,
		|ReceiveFinancialMovementType");
		
	Query = New Query();
	Query.Text =
	"SELECT
	|	CashTransferOrder.Receiver AS CashAccount,
	|	CashTransferOrder.Company,
	|	CashTransferOrder.ReceiveCurrency AS Currency,
	|	CashTransferOrder.SendCurrency AS CurrencyExchange,
	|	CashTransferOrder.Sender AS SendingAccount,
	|	CashTransferOrder.Branch AS SendingBranch,
	|	CashTransferOrder.ReceiveFinancialMovementType AS ReceiveFinancialMovementType,
	|	CashTransferOrder.Ref
	|FROM
	|	Document.CashTransferOrder AS CashTransferOrder
	|WHERE
	|	CashTransferOrder.Ref = &Ref";
	Query.SetParameter("Ref", Ref);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		FillPropertyValues(Result, QuerySelection);
	EndIf;
	Return Result;
EndFunction

Function GetInfoForFillingCashPayment(Ref) Export
	Result = New Structure("Ref, 
		|CashAccount, 
		|Company, 
		|Currency, 
		|ReceiptingAccount, 
		|ReceiptingBranch, 
		|SendFinancialMovementType");
		
	Query = New Query();
	Query.Text =
	"SELECT
	|	CashTransferOrder.Sender AS CashAccount,
	|	CashTransferOrder.Company,
	|	CashTransferOrder.SendCurrency AS Currency,
	|	CashTransferOrder.Receiver AS ReceiptingAccount,
	|	CashTransferOrder.ReceiveBranch AS ReceiptingBranch,
	|	CashTransferOrder.SendFinancialMovementType AS SendFinancialMovementType,
	|	CashTransferOrder.Ref
	|FROM
	|	Document.CashTransferOrder AS CashTransferOrder
	|WHERE
	|	CashTransferOrder.Ref = &Ref";
	Query.SetParameter("Ref", Ref);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		FillPropertyValues(Result, QuerySelection);
	EndIf;
	Return Result;
EndFunction

Function GetInfoForFillingBankReceipt(Ref) Export
	Result = New Structure("Ref, 
		|Account, 
		|Company, 
		|Currency, 
		|CurrencyExchange,
		|SendingAccount, 
		|SendingBranch,
		|ReceiveFinancialMovementType");
		
	Query = New Query();
	Query.Text =
	"SELECT
	|	CashTransferOrder.Receiver AS Account,
	|	CashTransferOrder.Company,
	|	CashTransferOrder.ReceiveCurrency AS Currency,
	|	CashTransferOrder.SendCurrency AS CurrencyExchange,
	|	CashTransferOrder.Sender AS SendingAccount,
	|	CashTransferOrder.Branch AS SendingBranch,
	|	CashTransferOrder.ReceiveFinancialMovementType AS ReceiveFinancialMovementType,
	|	CashTransferOrder.Ref
	|FROM
	|	Document.CashTransferOrder AS CashTransferOrder
	|WHERE
	|	CashTransferOrder.Ref = &Ref";
	Query.SetParameter("Ref", Ref);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		FillPropertyValues(Result, QuerySelection);
	EndIf;
	Return Result;
EndFunction

Function GetInfoForFillingBankPayment(Ref) Export
	Result = New Structure("Ref, 
		|Account, 
		|Company, 
		|Currency, 
		|CurrencyExchange, 
		|ReceiptingAccount, 
		|ReceiptingBranch,
		|SendFinancialMovementType");
		
	Query = New Query();
	Query.Text =
	"SELECT
	|	CashTransferOrder.Sender AS Account,
	|	CashTransferOrder.Company,
	|	CashTransferOrder.SendCurrency AS Currency,
	|	CashTransferOrder.Receiver AS ReceiptingAccount,
	|	CashTransferOrder.ReceiveBranch AS ReceiptingBranch,
	|	CashTransferOrder.SendFinancialMovementType AS SendFinancialMovementType,
	|	CashTransferOrder.Ref
	|FROM
	|	Document.CashTransferOrder AS CashTransferOrder
	|WHERE
	|	CashTransferOrder.Ref = &Ref";
	Query.SetParameter("Ref", Ref);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		FillPropertyValues(Result, QuerySelection);
	EndIf;
	Return Result;
EndFunction