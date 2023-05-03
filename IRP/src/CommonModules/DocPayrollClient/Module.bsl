#Region FORM

Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export
	ViewClient_V2.OnOpen(Object, Form, Form.MainTables);
EndProcedure

Procedure AfterWriteAtClient(Object, Form, WriteParameters) Export
	Return;
EndProcedure

#EndRegion

#Region _DATE

Procedure DateOnChange(Object, Form, Item) Export
	ViewClient_V2.DateOnChange(Object, Form, Form.MainTables);
EndProcedure

Procedure BeginDateOnChange(Object, Form, Item) Export
	ViewClient_V2.BeginDateOnChange(Object, Form, Form.MainTables);
EndProcedure

Procedure EndDateOnChange(Object, Form, Item) Export
	ViewClient_V2.EndDateOnChange(Object, Form, Form.MainTables);
EndProcedure

#EndRegion

#Region COMPANY

Procedure CompanyOnChange(Object, Form, Item) Export
	ViewClient_V2.CompanyOnChange(Object, Form, Form.MainTables);
EndProcedure

#EndRegion

#Region CURRENCY

Procedure CurrencyOnChange(Object, Form, Item) Export
	ViewClient_V2.CurrencyOnChange(Object, Form, Form.MainTables);
EndProcedure

#EndRegion

#Region PAYROLL_LISTS

Procedure PayrollListsSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	ViewClient_V2.PayrollListsSelection(Object, Form, Item, RowSelected, Field, StandardProcessing);
EndProcedure

Procedure PayrollListsBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.PayrollListsBeforeAddRow(Object, Form, Item.Name, Cancel, Clone);
EndProcedure

Procedure PayrollListsBeforeDeleteRow(Object, Form, Item, Cancel) Export
	Return;
EndProcedure

Procedure PayrollListsAfterDeleteRow(Object, Form, Item) Export
	ViewClient_V2.PayrollListsAfterDeleteRow(Object, Form, Item.Name);
EndProcedure

#Region ACCRUAL_LIST_COLUMNS

#Region ACCRUAL_DEDUCTION_TYPE

Procedure PayrollListsAccrualDeductionTypeOnChange(Object, Form, Item, TableName, CurrentData = Undefined) Export
	ViewClient_V2.PayrollListsAccrualDeductionTypeOnChange(Object, Form, TableName, CurrentData);
EndProcedure

#EndRegion

Procedure PayrollListsAmountOnChange(Object, Form, Item, TableName, CurrentData = Undefined) Export
	ViewClient_V2.PayrollListsAmountOnChange(Object, Form, TableName, CurrentData);
EndProcedure

#EndRegion

#EndRegion

Procedure ChoiceByAccrual(Object, Form) Export
	OpenParameters = New Structure();
	OpenParameters.Insert("Company"  , Object.Company);
	OpenParameters.Insert("Branch"   , Object.Branch);
	OpenParameters.Insert("Currency" , Object.Currency);
	OpenParameters.Insert("Ref"      , Object.Ref);
	
	ArrayOfEmployee = New Array();
	For Each Row In Object.PaymentList Do
		ArrayOfEmployee.Add(Row.Employee);
	EndDo;
	OpenParameters.Insert("ArrayOfEmployee", ArrayOfEmployee);
	
	Notify = New NotifyDescription("ChoiceByAccrualEnd", ThisObject,New Structure("Object, Form", Object, Form));
	OpenForm("Document.Payroll.Form.ChoiceByAccrualForm", OpenParameters, Form, New UUID(), , , 
		Notify, FormWindowOpeningMode.LockOwnerWindow);	
EndProcedure

Procedure ChoiceByAccrualEnd(Result, Params) Export
	If Result = Undefined Then
		Return;
	EndIf;
	TableInfo = DocPayrollServer.PutChoiceDataToServerStorage(Result.ArrayOfDataRows, Params.Form.UUID);
	ViewClient_V2.PaymentListLoad(Params.Object, Params.Form, TableInfo.Address, TableInfo.GroupColumn, TableInfo.SumColumn);
EndProcedure	
