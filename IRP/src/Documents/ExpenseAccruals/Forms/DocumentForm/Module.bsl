
#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocExpenseRevenueAccrualsServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocExpenseRevenueAccrualsServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
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
	DocEmployeeCashAdvanceServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocExpenseRevenueAccrualsClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
	
	If Not Source = ThisObject Then
		Return;
	EndIf;	
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	Return;
EndProcedure

&AtClient
Procedure API_Callback(TableName, ArrayOfDataPaths) Export
	API_CallbackAtServer(TableName, ArrayOfDataPaths);
EndProcedure

&AtServer
Procedure API_CallbackAtServer(TableName, ArrayOfDataPaths)
	ViewServer_V2.API_CallbackAtServer(Object, ThisObject, TableName, ArrayOfDataPaths);
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	Form.Items.EditCurrencies.Enabled = Not Form.ReadOnly;
	Form.Items.EditAccounting.Enabled = Not Form.ReadOnly;	
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

#EndRegion

#Region _DATE

&AtClient
Procedure DateOnChange(Item)
	DocExpenseRevenueAccrualsClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocExpenseRevenueAccrualsClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocExpenseRevenueAccrualsClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocExpenseRevenueAccrualsClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region CURRENCY

&AtClient
Procedure CurrencyOnChange(Item)
	DocExpenseRevenueAccrualsClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COST_LIST

&AtClient
Procedure CostListSelection(Item, RowSelected, Field, StandardProcessing)
	DocExpenseRevenueAccrualsClient.CostListSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure CostListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocExpenseRevenueAccrualsClient.CostListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure CostListBeforeDeleteRow(Item, Cancel)
	DocExpenseRevenueAccrualsClient.CostListBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure CostListAfterDeleteRow(Item)
	DocExpenseRevenueAccrualsClient.CostListAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

#EndRegion

&AtClient
Procedure BasisStartChoice(Item, ChoiceData, StandardProcessing)
	StandardProcessing = False;
	OpenPickupForm();
EndProcedure

#Region SERVICE

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocExpenseRevenueAccrualsClient);
	Str.Insert("Server", DocExpenseRevenueAccrualsServer);
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

#EndRegion

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

&AtClient
Procedure EditCurrencies(Command)
	FormParameters = CurrenciesClientServer.GetParameters_V12(Object);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure EditAccounting(Command)
	CurrentData = ThisObject.Items.CostList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	UpdateAccountingData();
	AccountingClient.OpenFormEditAccounting(Object, ThisObject, CurrentData, "CostList");
EndProcedure

&AtServer
Procedure UpdateAccountingData()
	_AccountingRowAnalytics = ThisObject.AccountingRowAnalytics.Unload();
	_AccountingExtDimensions = ThisObject.AccountingExtDimensions.Unload();
	AccountingClientServer.UpdateAccountingTables(Object, 
			                                      _AccountingRowAnalytics, 
		                                          _AccountingExtDimensions, "CostList");
	ThisObject.AccountingRowAnalytics.Load(_AccountingRowAnalytics);
	ThisObject.AccountingExtDimensions.Load(_AccountingExtDimensions);
EndProcedure

&AtClient
Async Procedure OpenPickupForm()
	TableIsFilled = Object.CostList.Count() > 0;
	
	If TableIsFilled Then
		Answer = Await DoQueryBoxAsync(R().QuestionToUser_015, QuestionDialogMode.OKCancel);
	EndIf;
	
	If TableIsFilled And Answer = DialogReturnCode.Cancel Then
		Return;
	EndIf;
		
	If Not ValueIsFilled(Object.Currency) Then
		//@skip-check property-return-type
		TextMessage = R().Error_EmptyCurrency; // String
		CommonFunctionsClientServer.ShowUsersMessage(TextMessage, "Object.Currency");
		Return;
	EndIf;
	If Not ValueIsFilled(Object.TransactionType) Then
		//@skip-check property-return-type
		TextMessage = R().Error_EmptyTransactionType; // String
		CommonFunctionsClientServer.ShowUsersMessage(TextMessage, "Object.TransactionType");
		Return;
	EndIf;
	
	Object.CostList.Clear();
	
	Notify = New NotifyDescription("AfterExpensePickup", ThisObject);
	FormParameters = New Structure();
	FormParameters.Insert("Company", Object.Company);
	FormParameters.Insert("Branch", Object.Branch);
	FormParameters.Insert("Ref", Object.Ref);
	FormParameters.Insert("Date", Object.Date);
	FormParameters.Insert("Currency", Object.Currency);
	FormParameters.Insert("TransactionType", Object.TransactionType);
	
	OpenForm("Document.ExpenseAccruals.Form.PickupExpenseForm",
		FormParameters,
		ThisObject,
		ThisObject.UUID,
		,
		ThisObject.URL,
		Notify,
		FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure AfterExpensePickup(Result, AdditionalParemeters) Export
	If Result = Undefined Then
		Return;
	EndIf;	
	
	For Each Row In Result Do
		Object.Basis = Row.Basis;
		ViewClient_V2.CostListAddFilledRow(Object, ThisObject, Row);
	EndDo;	
EndProcedure

#EndRegion
