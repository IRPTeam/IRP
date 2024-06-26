#Region FORM

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	ViewServer_V2.OnCreateAtServer(Object, Form, "PaymentList");
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	AccountingServer.AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	LockDataModificationPrivileged.LockFormIfObjectIsLocked(Form, CurrentObject);
	AccountingServer.OnReadAtServer(Object, Form, CurrentObject);
EndProcedure

#EndRegion

#Region _TITLE

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");
	AttributesArray.Add("Partner");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Attr In AttributesArray Do
		Form.GroupItems.Add(Attr, ?(ValueIsFilled(Form.Items[Attr].Title), Form.Items[Attr].Title,
			Object.Ref.Metadata().Attributes[Attr].Synonym + ":" + Chars.NBSp));
	EndDo;
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

Function GetAdvances(QueryParameters) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R3027B_EmployeeCashAdvanceBalance.Currency,
	|	R3027B_EmployeeCashAdvanceBalance.AmountBalance AS TotalAmount
	|FROM
	|	AccumulationRegister.R3027B_EmployeeCashAdvance.Balance(&BalancePeriod, Company = &Company
	|	AND Branch = &Branch
	|	AND Partner = &Partner
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
	|		R3027B_EmployeeCashAdvanceBalance";
	
	Query.SetParameter("Company"       , QueryParameters.Company);
	Query.SetParameter("Branch"        , QueryParameters.Branch);
	Query.SetParameter("Partner"       , QueryParameters.Partner);
	Query.SetParameter("BalancePeriod" , QueryParameters.BalancePeriod);

	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction
