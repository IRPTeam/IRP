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

#Region PARTNER

Procedure PartnerOnChange(Object, Form, Item) Export
	ViewClient_V2.PartnerOnChange(Object, Form, Form.MainTables);
EndProcedure

Procedure PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	PartnerType = "Other";
	
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("Filter", New Structure(PartnerType, True));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem(PartnerType, True, DataCompositionComparisonType.Equal));
	OpenSettings.FillingData = New Structure(PartnerType, True);
	
	DocumentsClient.PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure PartnerTextChange(Object, Form, Item, Text, StandardProcessing) Export
	PartnerType = "Other";
	
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem(PartnerType, True, ComparisonType.Equal));
	
	AdditionalParameters = New Structure();
	DocumentsClient.PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region LEGAL_NAME

Procedure LegalNameOnChange(Object, Form, Item) Export
	ViewClient_V2.LegalNameOnChange(Object, Form, Form.MainTables);
EndProcedure

Procedure LegalNameStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	DocumentsClient.LegalNameStartChoice_PartnerFilter(Object, Form, Item, ChoiceData, StandardProcessing, Object.Partner);
EndProcedure

Procedure LegalNameTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DocumentsClient.LegalNameTextChange_PartnerFilter(Object, Form, Item, Text, StandardProcessing, Object.Partner);
EndProcedure

#EndRegion

#Region AGREEMENT

Procedure AgreementOnChange(Object, Form, Item) Export
	ViewClient_V2.AgreementOnChange(Object, Form, Form.MainTables);
EndProcedure

Procedure AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	AgreementType = PredefinedValue("Enum.AgreementTypes.Other");
	
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", AgreementType, DataCompositionComparisonType.Equal));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", PredefinedValue("Enum.AgreementKinds.Standard"), DataCompositionComparisonType.NotEqual));
	
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("Partner"                     , Object.Partner);
	OpenSettings.FormParameters.Insert("IncludeFilterByPartner"      , True);
	OpenSettings.FormParameters.Insert("IncludePartnerSegments"      , True);
	OpenSettings.FormParameters.Insert("EndOfUseDate", Object.Date);
	OpenSettings.FormParameters.Insert("IncludeFilterByEndOfUseDate" , True);
	
	OpenSettings.FillingData = New Structure();
	OpenSettings.FillingData.Insert("Partner"   , Object.Partner);
	OpenSettings.FillingData.Insert("LegalName" , Object.LegalName);
	OpenSettings.FillingData.Insert("Company"   , Object.Company);
	OpenSettings.FillingData.Insert("Type"      , AgreementType);

	DocumentsClient.AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure AgreementTextChange(Object, Form, Item, Text, StandardProcessing) Export
	AgreementType = PredefinedValue("Enum.AgreementTypes.Other");
	
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", AgreementType,ComparisonType.Equal));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", PredefinedValue("Enum.AgreementKinds.Standard"),ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("IncludeFilterByEndOfUseDate" , True);
	AdditionalParameters.Insert("IncludeFilterByPartner"      , True);
	AdditionalParameters.Insert("IncludePartnerSegments"      , True);
	AdditionalParameters.Insert("EndOfUseDate"                , Object.Date);
	AdditionalParameters.Insert("Partner"                     , Object.Partner);
	DocumentsClient.AgreementEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
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
