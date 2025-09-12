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

#Region PAYMENT_PERIOD

Procedure PaymentPeriodOnChange(Object, Form, Item) Export
	ViewClient_V2.PlanningPeriodOnChange(Object, Form, Form.MainTables);
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

#Region SALARY_TAX_LIST

#Region SALARY_TAX_LIST_PARTNER

Procedure SalaryTaxListPartnerOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.SalaryTaxListPartnerOnChange(Object, Form, CurrentData);
EndProcedure

Procedure SalaryTaxListPartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Other", True, DataCompositionComparisonType.Equal));
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FillingData = New Structure();
	DocumentsClient.PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure SalaryTaxListPartnerEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Other", True, ComparisonType.Equal));
	AdditionalParameters = New Structure();
	DocumentsClient.PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region SALARY_TAX_LIST_LEGAL_NAME

Procedure SalaryTaxListLegalNameOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.SalaryTaxListLegalNameOnChange(Object, Form, CurrentData);
EndProcedure

Procedure SalaryTaxListLegalNameStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	CurrentData = Form.Items.SalaryTaxList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(
		DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(
		DocumentsClientServer.CreateFilterItem("Partner", CurrentData.Partner, DataCompositionComparisonType.Equal));
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("Partner", CurrentData.Partner);
	OpenSettings.FormParameters.Insert("FilterByPartnerHierarchy", True);
	OpenSettings.FillingData = New Structure("Partner", CurrentData.Partner);

	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure SalaryTaxListLegalNameEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	CurrentData = Form.Items.SalaryTaxList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(
		DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(
		DocumentsClientServer.CreateFilterItem("Partner", CurrentData.Partner, ComparisonType.Equal));
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("Partner", CurrentData.Partner);
	AdditionalParameters.Insert("FilterByPartnerHierarchy", True);
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region SALARY_TAX_LIST_AGREEMENT

Procedure SalaryTaxListAgreementOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.SalaryTaxListAgreementOnChange(Object, Form, CurrentData);
EndProcedure

Procedure SalaryTaxListAgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	CurrentData = Form.Items.SalaryTaxList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", PredefinedValue("Enum.AgreementTypes.Other"), DataCompositionComparisonType.Equal));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", PredefinedValue("Enum.AgreementKinds.Standard"), DataCompositionComparisonType.NotEqual));
	
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("Partner"                     , CurrentData.Partner);
	OpenSettings.FormParameters.Insert("IncludeFilterByPartner"      , True);
	OpenSettings.FormParameters.Insert("IncludePartnerSegments"      , True);
	OpenSettings.FormParameters.Insert("EndOfUseDate"                , Object.Date);
	OpenSettings.FormParameters.Insert("IncludeFilterByEndOfUseDate" , True);
	
	OpenSettings.FillingData = New Structure();
	OpenSettings.FillingData.Insert("Partner"   , CurrentData.Partner);
	OpenSettings.FillingData.Insert("LegalName" , CurrentData.LegalName);
	OpenSettings.FillingData.Insert("Company"   , Object.Company);
	OpenSettings.FillingData.Insert("Type"      , PredefinedValue("Enum.AgreementTypes.Other"));

	DocumentsClient.AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure SalaryTaxListAgreementEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	CurrentData = Form.Items.SalaryTaxList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", PredefinedValue("Enum.AgreementTypes.Other"),ComparisonType.Equal));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", PredefinedValue("Enum.AgreementKinds.Standard"),ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("IncludeFilterByEndOfUseDate" , True);
	AdditionalParameters.Insert("IncludeFilterByPartner"      , True);
	AdditionalParameters.Insert("IncludePartnerSegments"      , True);
	AdditionalParameters.Insert("EndOfUseDate"                , Object.Date);
	AdditionalParameters.Insert("Partner"                     , CurrentData.Partner);
	DocumentsClient.AgreementEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#EndRegion

#Region ACCRUAL_LIST_COLUMNS

#Region ACCRUAL_DEDUCTION_TYPE

Procedure PayrollListsAccrualDeductionTypeOnChange(Object, Form, Item, TableName, CurrentData = Undefined) Export
	ViewClient_V2.PayrollListsAccrualDeductionTypeOnChange(Object, Form, TableName, CurrentData);
EndProcedure

#EndRegion

Procedure PayrollListsAmountOnChange(Object, Form, Item, TableName, CurrentData = Undefined) Export
	ViewClient_V2.PayrollListsAmountOnChange(Object, Form, TableName, CurrentData);
EndProcedure

Procedure PayrollListsEmployeeOnChange(Object, Form, Item, TableName, CurrentData = Undefined) Export
	ViewClient_V2.PayrollListsEmployeeOnChange(Object, Form, TableName, CurrentData);
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
	
	Notify = New CallbackDescription("ChoiceByAccrualEnd", ThisObject,New Structure("Object, Form", Object, Form));
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
