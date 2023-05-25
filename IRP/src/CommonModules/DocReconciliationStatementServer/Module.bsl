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
	LockDataModificationPrivileged.LockFormIfObjectIsLocked(Form, CurrentObject);
EndProcedure

Procedure SetVisibility(Object, Form) Export
	Form.Items.OpeningBalanceDebit.Visible = Object.OpeningBalanceDebit > 0;
	Form.Items.OpeningBalanceCredit.Visible = Object.OpeningBalanceCredit > 0;
	Form.Items.ClosingBalanceDebit.Visible = Object.ClosingBalanceDebit > 0;
	Form.Items.ClosingBalanceCredit.Visible = Object.ClosingBalanceCredit > 0;
	// 0.00
	If Not (Form.Items.OpeningBalanceDebit.Visible Or Form.Items.OpeningBalanceCredit.Visible) Then
		Form.Items.OpeningBalanceDebit.Visible = True;
	EndIf;
	If Not (Form.Items.ClosingBalanceDebit.Visible Or Form.Items.ClosingBalanceCredit.Visible) Then
		Form.Items.ClosingBalanceDebit.Visible = True;
	EndIf;
EndProcedure

#EndRegion

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");
	AttributesArray.Add("LegalName");
	AttributesArray.Add("Currency");
	AttributesArray.Add("BeginPeriod");
	AttributesArray.Add("EndPeriod");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Attr In AttributesArray Do
		Form.GroupItems.Add(Attr, ?(ValueIsFilled(Form.Items[Attr].Title), Form.Items[Attr].Title,
			Object.Ref.Metadata().Attributes[Attr].Synonym + ":" + Chars.NBSp));
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

Function GetAgreementsCurrency(Partner, Company, CurrentData = Undefined) Export
	
	If CurrentData = Undefined Then
		CurrentData = CommonFunctionsServer.GetCurrentSessionDate();
	EndIf;
	
	Query = New Query;
	Query.Text =
	"SELECT DISTINCT
	|	Agreements.CurrencyMovementType.Currency AS Currency
	|FROM
	|	Catalog.Agreements AS Agreements
	|WHERE
	|	Agreements.Partner = &Partner
	|	AND Agreements.Company = &Company
	|	AND NOT Agreements.DeletionMark
	|	AND (Agreements.StartUsing = DATETIME(1, 1, 1)
	|	OR Agreements.StartUsing <= &CurrentData)
	|	AND (Agreements.EndOfUse = DATETIME(1, 1, 1)
	|	OR Agreements.EndOfUse >= &CurrentData)
	|	AND (NOT Agreements.CurrencyMovementType.Currency IS NULL
	|	AND NOT Agreements.CurrencyMovementType.Currency = VALUE(Catalog.Currencies.EmptyRef))";
	
	Query.SetParameter("Partner", Partner);
	Query.SetParameter("Company", Company);
	Query.SetParameter("CurrentData", CurrentData);
	
	Return Query.Execute().Unload().UnloadColumn(0);
	
EndFunction