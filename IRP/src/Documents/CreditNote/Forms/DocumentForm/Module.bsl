
#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocCreditDebitNoteServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
	DocCreditDebitNoteServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	AccountingServer.BeforeWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocCreditDebitNoteServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocCreditDebitNoteClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
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
	DocCreditDebitNoteClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocCreditDebitNoteClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocCreditDebitNoteClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocCreditDebitNoteClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region TRANSACTIONS_LIST

&AtClient
Procedure TransactionsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocCreditDebitNoteClient.TransactionsBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure TransactionsAfterDeleteRow(Item)
	DocCreditDebitNoteClient.TransactionsAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

#Region TRANSACTIONS_LIST_COLUMNS

#Region PARTNER

&AtClient
Procedure TransactionsPartnerOnChange(Item)
	DocCreditDebitNoteClient.TransactionsPartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure TransactionsPartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocCreditDebitNoteClient.TransactionsPartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure TransactionsPartnerEditTextChange(Item, Text, StandardProcessing)
	DocCreditDebitNoteClient.TransactionsPartnerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region AGREEMENT

&AtClient
Procedure TransactionsAgreementOnChange(Item)
	DocCreditDebitNoteClient.TransactionsAgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure TransactionsAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocCreditDebitNoteClient.TransactionsAgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure TransactionsAgreementEditTextChange(Item, Text, StandardProcessing)
	DocCreditDebitNoteClient.TransactionsAgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region LEGAL_NAME

&AtClient
Procedure TransactionsLegalNameOnChange(Item)
	DocCreditDebitNoteClient.TransactionsLegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure TransactionsLegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocCreditDebitNoteClient.TransactionsLegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure TransactionsLegalNameEditTextChange(Item, Text, StandardProcessing)
	DocCreditDebitNoteClient.TransactionsLegalNameEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region EXPENSE_TYPE

&AtClient
Procedure TransactionsExpenseTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocCreditDebitNoteClient.TransactionsExpenseTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure TransactionsExpenseTypeEditTextChange(Item, Text, StandardProcessing)
	DocCreditDebitNoteClient.TransactionsExpenseTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

&AtClient
Procedure TransactionsVatRateOnChange(Item)
	DocCreditDebitNoteClient.TransactionsVatRateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure TransactionsNetAmountOnChange(Item)
	DocCreditDebitNoteClient.TransactionsNetAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure TransactionsTaxAmountOnChange(Item)
	DocCreditDebitNoteClient.TransactionsTaxAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure TransactionsAmountOnChange(Item)
	DocCreditDebitNoteClient.TransactionsAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#EndRegion

#Region SERVICE

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
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
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
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

#EndRegion

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

&AtClient
Procedure EditCurrencies(Command)
	CurrentData = ThisObject.Items.Transactions.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V4(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure EditAccounting(Command)
	CurrentData = ThisObject.Items.Transactions.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	UpdateAccountingData();
	AccountingClient.OpenFormEditAccounting(Object, ThisObject, CurrentData, "Transactions");
EndProcedure

&AtServer
Procedure UpdateAccountingData()
	_AccountingRowAnalytics = ThisObject.AccountingRowAnalytics.Unload();
	_AccountingExtDimensions = ThisObject.AccountingExtDimensions.Unload();
	AccountingClientServer.UpdateAccountingTables(Object, 
			                                      _AccountingRowAnalytics, 
		                                          _AccountingExtDimensions, "Transactions");
	ThisObject.AccountingRowAnalytics.Load(_AccountingRowAnalytics);
	ThisObject.AccountingExtDimensions.Load(_AccountingExtDimensions);
EndProcedure

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

#EndRegion

