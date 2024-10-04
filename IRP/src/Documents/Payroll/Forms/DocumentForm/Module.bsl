
#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocPayrollServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocPayrollServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	AccountingServer.BeforeWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
	CurrenciesServer.BeforeWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocPayrollServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocPayrollClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	DocPayrollClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	Form.Items.LegalName.Enabled = ValueIsFilled(Object.Partner);
	
	Form.Items.EditCurrenciesAccrual.Enabled = Not Form.ReadOnly;
	Form.Items.EditCurrenciesDeduction.Enabled = Not Form.ReadOnly;
	Form.Items.EditCurrenciesCashAdvanceDeduction.Enabled = Not Form.ReadOnly;
	Form.Items.EditCurrenciesTaxes.Enabled = Not Form.ReadOnly;
	
	Form.Items.EditAccountingAccrual.Enabled = Not Form.ReadOnly;
	Form.Items.EditAccountingDeduction.Enabled = Not Form.ReadOnly;
	Form.Items.EditAccountingCashAdvanceDeduction.Enabled = Not Form.ReadOnly;
	Form.Items.EditAccountingTaxes.Enabled = Not Form.ReadOnly;
	
	Form.Items.FillAccrual.Enabled = Not Form.ReadOnly;
	Form.Items.FillDeduction.Enabled = Not Form.ReadOnly;	
	Form.Items.FillCashAdvanceDeduction.Enabled = Not Form.ReadOnly;	
EndProcedure

&AtClient
Procedure _IdeHandler()
	ViewClient_V2.ViewIdleHandler(ThisObject, Object);
EndProcedure

&AtClient
Procedure _AttachIdleHandler() Export
	AttachIdleHandler("_IdeHandler", 1);
EndProcedure

&AtClient 
Procedure _DetachIdleHandler() Export
	DetachIdleHandler("_IdeHandler");
EndProcedure

&AtClient
Procedure UpdateTotalAmounts() Export
	_TotalAccrual   = 0;
	_TotalDeduction = 0;
	_TotalCashAdvanceDeduction = 0;
	
	For Each Row In Object.AccrualList Do
		_TotalAccrual = _TotalAccrual + Row.Amount;
	EndDo;
	
	For Each Row In Object.DeductionList Do
		_TotalDeduction = _TotalDeduction + Row.Amount;
	EndDo;
	
	For Each Row In Object.CashAdvanceDeductionList Do
		_TotalCashAdvanceDeduction = _TotalCashAdvanceDeduction + Row.Amount;
	EndDo;
	
	ThisObject.TotalPaymentAmount = _TotalAccrual - _TotalDeduction - _TotalCashAdvanceDeduction;
EndProcedure

#EndRegion

#Region _DATE

&AtClient
Procedure DateOnChange(Item)
	DocPayrollClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure BeginDateOnChange(Item)
	DocPayrollClient.BeginDateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure EndDateOnChange(Item)
	DocPayrollClient.EndDateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PAYMENT_PERIOD

&AtClient
Procedure PaymentPeriodOnChange(Item)
	DocPayrollClient.PaymentPeriodOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocPayrollClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region CURRENCY

&AtClient
Procedure CurrencyOnChange(Item)
	DocPayrollClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure
	
#EndRegion


#Region PARTNER

&AtClient
Procedure PartnerOnChange(Item)
	DocPayrollClient.PartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocPayrollClient.PartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PartnerEditTextChange(Item, Text, StandardProcessing)
	DocPayrollClient.PartnerTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region LEGAL_NAME

&AtClient
Procedure LegalNameOnChange(Item)
	DocPayrollClient.LegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure LegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocPayrollClient.LegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure LegalNameEditTextChange(Item, Text, StandardProcessing)
	DocPayrollClient.LegalNameTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region AGREEMENT

&AtClient
Procedure AgreementOnChange(Item)
	DocPayrollClient.AgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocPayrollClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AgreementEditTextChange(Item, Text, StandardProcessing)
	DocPayrollClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region SALARY_TAX_LIST

&AtClient
Procedure SalaryTaxListSelection(Item, RowSelected, Field, StandardProcessing)
	DocPayrollClient.PayrollListsSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure SalaryTaxListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocPayrollClient.PayrollListsBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure SalaryTaxListBeforeDeleteRow(Item, Cancel)
	DocPayrollClient.PayrollListsBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure SalaryTaxListAfterDeleteRow(Item)
	DocPayrollClient.PayrollListsAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PAYROLL_LISTS_LIST

&AtClient
Procedure PayrollListsSelection(Item, RowSelected, Field, StandardProcessing)
	DocPayrollClient.PayrollListsSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure PayrollListsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocPayrollClient.PayrollListsBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure PayrollListsBeforeDeleteRow(Item, Cancel)
	DocPayrollClient.PayrollListsBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure PayrollListsAfterDeleteRow(Item)
	DocPayrollClient.PayrollListsAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

#Region PAYROLL_LISTS_COLUMNS

#Region ACCRUAL_TYPE

&AtClient
Procedure PayrollListsAccrualTypeOnChange(Item)
	DocPayrollClient.PayrollListsAccrualDeductionTypeOnChange(Object, ThisObject, Item, "AccrualList");
EndProcedure

#EndRegion

#Region DEDUCTION_TYPE

&AtClient
Procedure PayrollListsDeductionTypeOnChange(Item)
	DocPayrollClient.PayrollListsAccrualDeductionTypeOnChange(Object, ThisObject, Item, "DeductionList");
EndProcedure

#EndRegion

#Region AMOUNT

&AtClient
Procedure AccrualListAmountOnChange(Item)
	DocPayrollClient.PayrollListsAmountOnChange(Object, ThisObject, Item, "AccrualList");
EndProcedure

&AtClient
Procedure DeductionListAmountOnChange(Item)
	DocPayrollClient.PayrollListsAmountOnChange(Object, ThisObject, Item, "DeductionList");
EndProcedure

&AtClient
Procedure CashAdvanceDeductionListAmountOnChange(Item)
	DocPayrollClient.PayrollListsAmountOnChange(Object, ThisObject, Item, "CashAdvanceDeductionList");
EndProcedure

#EndRegion

&AtClient
Procedure AccrualListEmployeeOnChange(Item)
	DocPayrollClient.PayrollListsEmployeeOnChange(Object, ThisObject, Item, "AccrualList");
EndProcedure

&AtClient
Procedure DeductionListEmployeeOnChange(Item)
	DocPayrollClient.PayrollListsEmployeeOnChange(Object, ThisObject, Item, "DeductionList");
EndProcedure

#EndRegion

#EndRegion

#Region SERVICE

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocPayrollClient);
	Str.Insert("Server", DocPayrollServer);
	Return Str;
EndFunction

#Region DESCRIPTION

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	CommonFormActions.EditMultilineText(ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region TITLE_DECORATIONS

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

#EndRegion

#Region ADD_ATTRIBUTES

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion

#Region EXTERNAL_COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

#EndRegion

#Region COMMANDS

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

#EndRegion

&AtClient
Procedure FillAccrual(Command)
	FillPayrollLists("AccrualList", "AccrualType", 
		PredefinedValue("Enum.PayrollTypes.Accrual"));
EndProcedure

&AtClient
Procedure FillDeduction(Command)
	FillPayrollLists("DeductionList", "DeductionType",  
		PredefinedValue("Enum.PayrollTypes.Deduction"));
EndProcedure

&AtClient
Async Procedure FillCashAdvanceDeduction(Command)
	TableIsFilled = Object.CashAdvanceDeductionList.Count() > 0;
	
	If TableIsFilled Then
		Answer = Await DoQueryBoxAsync(R().QuestionToUser_015, QuestionDialogMode.OKCancel);
	EndIf;
	
	If Not TableIsFilled Or Answer = DialogReturnCode.OK Then
		Result = FillCashAdvanceDeductionListAtServer();
		Object.CashAdvanceDeductionList.Clear();		
		ViewClient_V2.PayrollListsLoad(Object, ThisObject, Result.Address, 
			"CashAdvanceDeductionList", Result.GroupColumn, Result.SumColumn);
	EndIf;
EndProcedure

&AtServer
Function FillCashAdvanceDeductionListAtServer()
	FillingParameters = New Structure();
	FillingParameters.Insert("Company"  , Object.Company);
	FillingParameters.Insert("Branch"   , Object.Branch);
	FillingParameters.Insert("Currency" , Object.Currency);
	FillingParameters.Insert("Ref"      , Object.Ref);
	FillingParameters.Insert("EndDate"  , EndOfDay(Object.EndDate));
	
	Result = DocPayrollServer.GetCashAdvanceDeduction(FillingParameters);
	Address = PutToTempStorage(Result.Table, ThisObject.UUID);
	Return New Structure("Address, GroupColumn, SumColumn", Address, Result.GroupColumn, Result.SumColumn);
EndFunction	

&AtClient
Async Procedure FillPayrollLists(TableName, TypeColumnName, _Type)
	TableIsFilled = Object[TableName].Count() > 0;
	
	If TableIsFilled Then
		Answer = Await DoQueryBoxAsync(R().QuestionToUser_015, QuestionDialogMode.OKCancel);
	EndIf;
	
	If Not TableIsFilled Or Answer = DialogReturnCode.OK Then
		Result = FillPayrollListsAtServer(TypeColumnName, _Type);
		Object[TableName].Clear();		
		ViewClient_V2.PayrollListsLoad(Object, ThisObject, Result.Address, TableName, Result.GroupColumn, Result.SumColumn);
		ThisObject.Modified = True;
	EndIf;
EndProcedure

&AtServer
Function FillPayrollListsAtServer(TypeColumnName, _Type)
	FillingParameters = New Structure();
	FillingParameters.Insert("Company"   , Object.Company);
	FillingParameters.Insert("Branch"    , Object.Branch);
	FillingParameters.Insert("BeginDate" , BegOfDay(Object.BeginDate));
	FillingParameters.Insert("EndDate"   , EndOfDay(Object.EndDate));
	FillingParameters.Insert("_Type"     , _Type);
	FillingParameters.Insert("TypeColumnName" , TypeColumnName);
	FillingParameters.Insert("Ref" , Object.Ref);
		
	If _Type = Enums.PayrollTypes.Accrual Then
		Result = DocPayrollServer.GetPayrolls_Accrual(FillingParameters);
	Else
		Result = DocPayrollServer.GetPayrolls_Deduction(FillingParameters);
	EndIf;
	Address = PutToTempStorage(Result.Table, ThisObject.UUID);
	Return New Structure("Address, GroupColumn, SumColumn", Address, Result.GroupColumn, Result.SumColumn);
EndFunction	

&AtClient
Procedure EditCurrenciesAccrual(Command)
	EditCurrencies(Command, "AccrualList");
EndProcedure

&AtClient
Procedure EditCurrenciesCashAdvanceDeduction(Command)
	CurrentData = ThisObject.Items.CashAdvanceDeductionList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;	
	FormParameters = CurrenciesClientServer.GetParameters_V7(Object, 
	                                                         CurrentData.Key, 
	                                                         Object.Currency, 
	                                                         CurrentData.Amount, 
	                                                         CurrentData.Agreement);

	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
	
EndProcedure

&AtClient
Procedure EditCurrenciesDeduction(Command)
	EditCurrencies(Command, "DeductionList");
EndProcedure

&AtClient
Procedure EditCurrenciesTaxes(Command)
	EditCurrencies(Command, "SalaryTaxList");
EndProcedure

&AtClient
Procedure EditCurrencies(Command, TableName)
	CurrentData = ThisObject.Items[TableName].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;	
	FormParameters = CurrenciesClientServer.GetParameters_V5(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

&AtClient
Procedure EditAccountingAccrual(Command)
	EditAccounting("AccrualList");
EndProcedure

&AtClient
Procedure EditAccountingDeduction(Command)
	EditAccounting("DeductionList");
EndProcedure

&AtClient
Procedure EditAccountingCashAdvanceDeduction(Command)
	EditAccounting("CashAdvanceDeductionList");
EndProcedure

&AtClient
Procedure EditAccountingTaxes(Command)
	EditAccounting("SalaryTaxList");
EndProcedure

&AtClient
Procedure EditAccounting(TableName)
	CurrentData = ThisObject.Items[TableName].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	UpdateAccountingData(TableName);
	AccountingClient.OpenFormEditAccounting(Object, ThisObject, CurrentData, TableName);
EndProcedure

&AtServer
Procedure UpdateAccountingData(TableName)
	_AccountingRowAnalytics = ThisObject.AccountingRowAnalytics.Unload();
	_AccountingExtDimensions = ThisObject.AccountingExtDimensions.Unload();
	AccountingClientServer.UpdateAccountingTables(Object, 
			                                      _AccountingRowAnalytics, 
		                                          _AccountingExtDimensions, TableName);
	ThisObject.AccountingRowAnalytics.Load(_AccountingRowAnalytics);
	ThisObject.AccountingExtDimensions.Load(_AccountingExtDimensions);
EndProcedure

#EndRegion

ThisObject.MainTables = "AccrualList, DeductionList, CashAdvanceDeductionList, SalaryTaxList";
