#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	DocumentsClientServer.ChangeTitleCollapse(Object, Form, Not ValueIsFilled(Object.Ref));
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	Else
		CommonFunctionsClientServer.SetObjectPreviousValue(Object, Form, "Company");
	EndIf;
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

#EndRegion

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array;
	AttributesArray.Add("Company");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Atr In AttributesArray Do
		Form.GroupItems.Add(Atr, ?(ValueIsFilled(Form.Items[Atr].Title),
				Form.Items[Atr].Title,
				Object.Ref.Metadata().Attributes[Atr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#Region ListFormEvents

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion


#Region CommonFunctions

Function CashAdvanceHolderVisibility(Settings) Export
	
	If Not Settings.Sender.Type = PredefinedValue("Enum.CashAccountTypes.Cash") Then
		Return False;
	EndIf;
	
	If Not Settings.Receiver.Type = PredefinedValue("Enum.CashAccountTypes.Cash") Then
		Return False;
	EndIf;
	 
	If Not ValueIsFilled(Settings.SendCurrency) = ValueIsFilled(Settings.ReceiveCurrency) Then
		Return False;
	EndIf;
	
	If Settings.SendCurrency = Settings.ReceiveCurrency Then
		Return False;
	EndIf;
	
	Return True;	
	
EndFunction

Function CurrencyExchangeChecking(Object) Export
	
	If Object.SendCurrency = Object.ReceiveCurrency Then
		Return False;
	EndIf;
	
	If Object.Sender.Type = Object.Receiver.Type Then
		Return False;
	EndIf;
	
	Return True;
	
EndFunction

#EndRegion

Function GetInfoForFillingCashReceipt(Ref) Export
	Result = New Structure("Ref, CashAccount, Company, Currency, CurrencyExchange");
	Query = New Query();
	Query.Text = 
	"SELECT
	|	CashTransferOrder.Receiver AS CashAccount,
	|	CashTransferOrder.Company,
	|	CashTransferOrder.ReceiveCurrency AS Currency,
	|	CashTransferOrder.SendCurrency AS CurrencyExchange,
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

