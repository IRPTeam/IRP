#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetVisibility(Object, Form);
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	SetVisibility(CurrentObject, Form);
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	SetVisibility(CurrentObject, Form);
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

Procedure SetVisibility(Object, Form) Export
	Form.Items.OpeningBalanceDebit.Visible = Object.OpeningBalanceDebit > 0;
	Form.Items.OpeningBalanceCredit.Visible = Object.OpeningBalanceCredit > 0;
	Form.Items.ClosingBalanceDebit.Visible = Object.ClosingBalanceDebit > 0;
	Form.Items.ClosingBalanceCredit.Visible = Object.ClosingBalanceCredit > 0;
	// 0.00
	If Not (Form.Items.OpeningBalanceDebit.Visible OR Form.Items.OpeningBalanceCredit.Visible) Then
		Form.Items.OpeningBalanceDebit.Visible = True;
	EndIf;
	If Not (Form.Items.ClosingBalanceDebit.Visible OR Form.Items.ClosingBalanceCredit.Visible) Then
		Form.Items.ClosingBalanceDebit.Visible = True;
	EndIf;
EndProcedure

#EndRegion

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array;
	AttributesArray.Add("Company");
	AttributesArray.Add("LegalName");
	AttributesArray.Add("Currency");
	AttributesArray.Add("BeginPeriod");
	AttributesArray.Add("EndPeriod");
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

Function GetCompaniesByPartner(PartnerRef) Export
	Return Catalogs.Partners.GetCompaniesForPartner(PartnerRef);
EndFunction
	
