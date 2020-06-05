#Region FormEvents
Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
	//	TODO: Fix client/server
	//	Object.Account = CatCashAccountsServer.GetCashAccountByCompany(Object.Company, Object.Account);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	
	If ValueIsFilled(Object.Account) Then
		Form.CurentAccount = Object.Account;
		Form.Currency = ServiceSystemServer.GetObjectAttribute(Object.Account, "Currency");
	EndIf;
	
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export

	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);

EndProcedure
#EndRegion

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array;
	AttributesArray.Add("Company");
	AttributesArray.Add("Account");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Atr In AttributesArray Do
		Form.GroupItems.Add(Atr, ?(ValueIsFilled(Form.Items[Atr].Title),
								Form.Items[Atr].Title,
								Object.Ref.Metadata().Attributes[Atr].Synonym + ":" + Chars.NBSp));
	EndDo;	
EndProcedure

#EndRegion

#Region ListFormEvents

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region ChoiceFormEvents

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion
