Function GetDeclarationInfo() Export
	Declaration = New Structure();
	Declaration.Insert("LibraryName", "");
	Declaration.Insert("Actions", New Array());
	Declaration.Insert("Data", New Structure());
	Return Declaration;
EndFunction

Function GetCallHandlerParameters() Export
	Parameters = New Structure();
	Parameters.Insert("Object", Undefined);
	Parameters.Insert("Form", Undefined);
	Parameters.Insert("LibraryName", "");
	Parameters.Insert("HandlerID", "");
	Parameters.Insert("AddInfo", Undefined);
	Return Parameters;
EndFunction

Procedure AddActionHandler(Declaration, ActionHandler, ActionName, Owners) Export
	Action = New Structure();
	Action.Insert("ActionHandler", ActionHandler);
	Action.Insert("ActionName", ActionName);
	If TypeOf(Owners) <> Type("Array") Then
		ArrayOfOwners = New Array();
		ArrayOfOwners.Add(Owners);
		Action.Insert("Owners", ArrayOfOwners);
	Else
		Action.Insert("Owners", Owners);
	EndIf;
	Declaration.Actions.Add(Action);
EndProcedure

Procedure PutData(Declaration, Data) Export
	Declaration.Data = Data;
EndProcedure

Procedure RegisterLibrary(Object, Form, Declaration) Export
	If Not ValueIsFilled(Declaration.LibraryName) Then
		Raise R().Exc_005;
	EndIf;
	Listeners = RestoreFormData(Object, Form, "Listeners", New Structure());
	For Each Action In Declaration.Actions Do
		Listeners.Insert(Action.ActionHandler, PushOwnerActionHandlers(Action));
	EndDo;
	SaveFormData(Object, Form, "Listeners", Listeners);
	Declaration.Data.Insert("FormUUID", Form.UUID);
	RestoreFormData(Object, Form, Declaration.LibraryName, New Structure());
	SaveFormData(Object, Form, Declaration.LibraryName, Declaration.Data);
EndProcedure

Function RestoreFormData(Object, Form, AttributeName, InitValue = Undefined)
#If Server Then
	If Not CommonFunctionsServer.FormHaveAttribute(Form, AttributeName) Then
		ArrayOfNewAttribute = New Array();
		ArrayOfNewAttribute.Add(New FormAttribute(AttributeName, New TypeDescription("String")));
		Form.ChangeAttributes(ArrayOfNewAttribute);
	EndIf;
#EndIf
	If ValueIsFilled(Form[AttributeName]) Then
		Return CommonFunctionsServer.DeserializeXMLUseXDTO(Form[AttributeName]);
	Else
		Return InitValue;
	EndIf;
EndFunction

Procedure SaveFormData(Object, Form, AttributeName, Data)
	Form[AttributeName] = CommonFunctionsServer.SerializeXMLUseXDTO(Data);
EndProcedure

Function PushOwnerActionHandlers(Action)
	ArrayOfPushedHandlers = New Array();
	For Each Owner In Action.Owners Do
		PushedHandler = New Structure();
		PushedHandler.Insert("ActionHandler", Owner.GetAction(Action.ActionName));
		PushedHandler.Insert("ActionName", Action.ActionName);
		If TypeOf(Owner) = Type("ClientApplicationForm") Then
			PushedHandler.Insert("OwnerName", "_ClientApplicationForm_");
		Else
			PushedHandler.Insert("OwnerName", Owner.Name);
		EndIf;
		Owner.SetAction(Action.ActionName, Action.ActionHandler);
		If ValueIsFilled(PushedHandler.ActionHandler) Then
			ArrayOfPushedHandlers.Add(PushedHandler);
		EndIf;
	EndDo;
	Return ArrayOfPushedHandlers;
EndFunction

Procedure CallHandler(Parameters, P1 = Undefined, P2 = Undefined, P3 = Undefined) Export
	If Not ValueIsFilled(Parameters.Form.Listeners) Then
		Return;
	EndIf;
	Listeners = CommonFunctionsServer.DeserializeXMLUseXDTO(Parameters.Form.Listeners);
	Data = CommonFunctionsServer.DeserializeXMLUseXDTO(Parameters.Form[Parameters.LibraryName]);
	CommonFunctionsClientServer.PutToAddInfo(Parameters.AddInfo, Parameters.LibraryName + "_Data_", Data);
	If Listeners.Property(Parameters.HandlerID) Then
		ArrayOfPushedHandlers = Listeners[Parameters.HandlerID];
		For Each PushedHandler In ArrayOfPushedHandlers Do
			ProceedPushedHandler(Parameters.Object, Parameters.Form, PushedHandler, Parameters.AddInfo, P1, P2, P3);
		EndDo;
	EndIf;
EndProcedure

Procedure ProceedPushedHandler(Object, Form, PushedHandler, AddInfo, P1, P2, P3)
	If PushedHandler.OwnerName = "_ClientApplicationForm_" Then
		If Not CallChainHandler(Object, Form, PushedHandler.ActionHandler, AddInfo, P1, P2, P3) Then
			Raise StrTemplate(R().Exc_003, PushedHandler.ActionHandler);
		EndIf;
	Else
		If P1 <> Undefined And TypeOf(P1) <> Type("String") And PushedHandler.OwnerName = P1.Name Then
			If Not CallChainHandler(Object, Form, PushedHandler.ActionHandler, AddInfo, P1, P2, P3) Then
				Raise StrTemplate(R().Exc_003, PushedHandler.ActionHandler);
			EndIf;
		EndIf;
	EndIf;
EndProcedure

Function CallChainHandler(Object, Form, ActionHandler, AddInfo, P1, P2, P3)
	If Form_CallChainHandler(Object, Form, ActionHandler, AddInfo, P1, P2, P3) Then
		Return True;
	EndIf;
	If FormItems_CallChainHandler(Object, Form, ActionHandler, AddInfo, P1, P2, P3) Then
		Return True;
	EndIf;
	If Currencies_CallChainHandler(Object, Form, ActionHandler, AddInfo, P1, P2, P3) Then
		Return True;
	EndIf;
	Return False;
EndFunction

Function Form_CallChainHandler(Object, Form, ActionHandler, AddInfo, P1, P2, P3)
	If Upper(ActionHandler) = Upper("OnOpen") Then
		Form.OnOpen(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("AfterWriteAtServer") Then
		Form.AfterWriteAtServer(P1, P2, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("AfterWrite") Then
		Form.AfterWrite(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("NotificationProcessing") Then
		Form.NotificationProcessing(P1, P2, P3, AddInfo);
		Return True;
	Else
		Return False;
	EndIf;
EndFunction

Function FormItems_CallChainHandler(Object, Form, ActionHandler, AddInfo, P1, P2, P3)
	If FormItems_Header_CallChainHandler(Object, Form, ActionHandler, AddInfo, P1, P2, P3) Then
		Return True;
	EndIf;
	If FormItems_ChequeBonds_CallChainHandler(Object, Form, ActionHandler, AddInfo, P1, P2, P3) Then
		Return True;
	EndIf;
	If FormItems_ItemList_CallChainHandler(Object, Form, ActionHandler, AddInfo, P1, P2, P3) Then
		Return True;
	EndIf;
	If FormItems_PaymentList_CallChainHandler(Object, Form, ActionHandler, AddInfo, P1, P2, P3) Then
		Return True;
	EndIf;
	If FormItems_Unclassified_CallChainHandler(Object, Form, ActionHandler, AddInfo, P1, P2, P3) Then
		Return True;
	EndIf;
	Return False;
EndFunction

Function FormItems_Header_CallChainHandler(Object, Form, ActionHandler, AddInfo, P1, P2, P3)
	If Upper(ActionHandler) = Upper("DateOnChange") Then
		Form.DateOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("PlaningPeriodOnChange") Then
		Form.PlaningPeriodOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("CompanyOnChange") Then
		Form.CompanyOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("PartnerOnChange") Then
		Form.PartnerOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("LegalNameOnChange") Then
		Form.LegalNameOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("AgreementOnChange") Then
		Form.AgreementOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("CurrencyOnChange") Then
		Form.CurrencyOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("AccountOnChange") Then
		Form.AccountOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("TransactionTypeOnChange") Then
		Form.TransactionTypeOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("OperationTypeOnChange") Then
		Form.OperationTypeOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("SendCurrencyOnChange") Then
		Form.SendCurrencyOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("ReceiveCurrencyOnChange") Then
		Form.ReceiveCurrencyOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("SendAmountOnChange") Then
		Form.SendAmountOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("ReceiveAmountOnChange") Then
		Form.ReceiveAmountOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("SenderOnChange") Then
		Form.SenderOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("ReceiverOnChange") Then
		Form.ReceiverOnChange(P1, AddInfo);
		Return True;
	Else
		Return False;
	EndIf;
EndFunction

Function FormItems_ChequeBonds_CallChainHandler(Object, Form, ActionHandler, AddInfo, P1, P2, P3)
	If Upper(ActionHandler) = Upper("ChequeBondsChequeOnChange") Then
		Form.ChequeBondsChequeOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("ChequeBondsPartnerOnChange") Then
		Form.ChequeBondsPartnerOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("ChequeBondsAgreementOnChange") Then
		Form.ChequeBondsAgreementOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("ChequeBondsBeforeDeleteRow") Then
		Form.ChequeBondsBeforeDeleteRow(P1, P2, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("ChequeBondsOnActivateRow") Then
		Form.ChequeBondsOnActivateRow(P1, AddInfo);
		Return True;
	Else
		Return False;
	EndIf;
EndFunction

Function FormItems_ItemList_CallChainHandler(Object, Form, ActionHandler, AddInfo, P1, P2, P3)
	If Upper(ActionHandler) = Upper("ItemListOnChange") Then
		Form.ItemListOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("ItemListItemOnChange") Then
		Form.ItemListItemOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("ItemListItemKeyOnChange") Then
		Form.ItemListItemKeyOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("ItemListQuantityOnChange") Then
		Form.ItemListQuantityOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("ItemListUnitOnChange") Then
		Form.ItemListUnitOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("ItemListPriceTypeOnChange") Then
		Form.ItemListPriceTypeOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("ItemListPriceOnChange") Then
		Form.ItemListPriceOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("ItemListTotalAmountOnChange") Then
		Form.ItemListTotalAmountOnChange(P1, AddInfo);
		Return True;
	Else
		Return False;
	EndIf;
EndFunction

Function FormItems_PaymentList_CallChainHandler(Object, Form, ActionHandler, AddInfo, P1, P2, P3)
	If Upper(ActionHandler) = Upper("PaymentListOnActivateRow") Then
		Form.PaymentListOnActivateRow(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("PaymentListBasisDocumentOnChange") Then
		Form.PaymentListBasisDocumentOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("PaymentListPartnerOnChange") Then
		Form.PaymentListPartnerOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("PaymentListCurrencyOnChange") Then
		Form.PaymentListCurrencyOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("PaymentListNetAmountOnChange") Then
		Form.PaymentListNetAmountOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("PaymentListTotalAmountOnChange") Then
		Form.PaymentListTotalAmountOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("PaymentListAgreementOnChange") Then
		Form.PaymentListAgreementOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("PaymentListPayerOnChange") Then
		Form.PaymentListPayerOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("PaymentListPayeeOnChange") Then
		Form.PaymentListPayeeOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("PaymentListPlaningTransactionBasisOnChange") Then
		Form.PaymentListPlaningTransactionBasisOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("PaymentListAmountOnChange") Then
		Form.PaymentListAmountOnChange(P1, AddInfo);
		Return True;
	Else
		Return False;
	EndIf;
EndFunction

Function FormItems_Unclassified_CallChainHandler(Object, Form, ActionHandler, AddInfo, P1, P2, P3)
	If Upper(ActionHandler) = Upper("AccountBalanceAccountOnChange") Then
		Form.AccountBalanceAccountOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("AccountPayableByAgreementsPartnerOnChange") Then
		Form.AccountPayableByAgreementsPartnerOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("AccountReceivableByAgreementsPartnerOnChange") Then
		Form.AccountReceivableByAgreementsPartnerOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("AccountPayableByDocumentsPartnerOnChange") Then
		Form.AccountPayableByDocumentsPartnerOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("AccountReceivableByDocumentsPartnerOnChange") Then
		Form.AccountReceivableByDocumentsPartnerOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("TransactionsBasisDocumentOnChange") Then
		Form.TransactionsBasisDocumentOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("TransactionsAgreementOnChange") Then
		Form.TransactionsAgreementOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("TransactionsPartnerOnChange") Then
		Form.TransactionsPartnerOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("AccountReceivableByDocumentsOnActivateRow") Then
		Form.AccountReceivableByDocumentsOnActivateRow(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("AccountPayableByDocumentsOnActivateRow") Then
		Form.AccountPayableByDocumentsOnActivateRow(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("AccountReceivableByDocumentsAfterDeleteRow") Then
		Form.AccountReceivableByDocumentsAfterDeleteRow(P1, AddInfo);
		Return True;
	Else
		Return False;
	EndIf;
EndFunction

#Region Currencies

Function Currencies_CallChainHandler(Object, Form, ActionHandler, AddInfo, P1, P2, P3)
	If Upper(ActionHandler) = Upper("Currencies_OnOpen") Then
		Form.Currencies_OnOpen(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("Currencies_AfterWriteAtServer") Then
		Form.Currencies_AfterWriteAtServer(P1, P2, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("Currencies_AfterWrite") Then
		Form.Currencies_AfterWrite(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("NotificationProcessing") Then
		Form.Currencies_NotificationProcessing(P1, P2, P3, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("Currencies_MainTableBeforeDeleteRow") Then
		Form.Currencies_MainTableBeforeDeleteRow(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("Currencies_MainTableOnActivateRow") Then
		Form.Currencies_MainTableOnActivateRow(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("Currencies_MainTableColumnOnChange") Then
		Form.Currencies_MainTableColumnOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("Currencies_MainTableAmountOnChange") Then
		Form.Currencies_MainTableAmountOnChange(P1, AddInfo);
		Return True;
	ElsIf Upper(ActionHandler) = Upper("Currencies_HeaderOnChange") Then
		Form.Currencies_HeaderOnChange(P1, AddInfo);
		Return True;
	Else
		Return False;
	EndIf;
EndFunction

#EndRegion