
#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocMoneyTransferServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocMoneyTransferServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
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
Procedure AfterWriteAtServer(CurrentObject, WriteParameters) Export
	DocMoneyTransferServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel) Export
	DocMoneyTransferClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source) Export
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
	Form.Items.EditCurrenciesSender.Enabled = Not Form.ReadOnly;
	Form.Items.EditCurrenciesReceiver.Enabled = Not Form.ReadOnly;
	Form.Items.EditAccounting.Enabled = Not Form.ReadOnly;
	
	CashTransferOrderIsFilled = ValueIsFilled(Object.CashTransferOrder);
	
	Form.Items.Sender.ReadOnly   = CashTransferOrderIsFilled;
	Form.Items.Receiver.ReadOnly = CashTransferOrderIsFilled;
	Form.Items.SendCurrency.ReadOnly    = CashTransferOrderIsFilled;
	Form.Items.ReceiveCurrency.ReadOnly = CashTransferOrderIsFilled;
	Form.Items.ReceiveFinancialMovementType.ReadOnly = CashTransferOrderIsFilled;
	Form.Items.SendFinancialMovementType.ReadOnly    = CashTransferOrderIsFilled;
	Form.Items.TransitAccount.Visible = ValueIsFilled(Object.SendCurrency) 
		And ValueIsFilled(Object.ReceiveCurrency)
		And Object.SendCurrency <> Object.ReceiveCurrency;
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

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item) Export
	DocMoneyTransferClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocMoneyTransferClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocMoneyTransferClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region _DATE

&AtClient
Procedure DateOnChange(Item) Export
	DocMoneyTransferClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ACCOUNT_SENDER

&AtClient
Procedure SenderOnChange(Item) Export
	DocMoneyTransferClient.SenderOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure SenderStartChoice(Item, ChoiceData, StandardProcessing)
	DocMoneyTransferClient.SenderStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure SenderEditTextChange(Item, Text, StandardProcessing)
	DocMoneyTransferClient.SenderEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region CURRENCY_SEND

&AtClient
Procedure SendCurrencyOnChange(Item) Export
	DocMoneyTransferClient.SendCurrencyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region AMOUNT_SEND

&AtClient
Procedure SendAmountOnChange(Item) Export
	DocMoneyTransferClient.SendAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ACCOUNT_RECEIVER

&AtClient
Procedure ReceiverOnChange(Item) Export
	DocMoneyTransferClient.ReceiverOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ReceiverStartChoice(Item, ChoiceData, StandardProcessing)
	DocMoneyTransferClient.ReceiverStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ReceiverEditTextChange(Item, Text, StandardProcessing)
	DocMoneyTransferClient.ReceiverEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region CURRENCY_RECEIVE

&AtClient
Procedure ReceiveCurrencyOnChange(Item) Export
	DocMoneyTransferClient.ReceiveCurrencyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region AMOUNT_RECEIVE

&AtClient
Procedure ReceiveAmountOnChange(Item) Export
	DocMoneyTransferClient.ReceiveAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region CASH_TRANSFER_ORDER

&AtClient
Procedure CashTransferOrderOnChange(Item)
	DocMoneyTransferClient.CashTransferOrderOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region WORKSTATION

&AtClient
Procedure WorkstationOnChange(Item)
	DocMoneyTransferClient.WorkstationOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region FINANCIAL_MOVEMENT_TYPE

&AtClient
Procedure SendFinancialMovementTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocMoneyTransferClient.FinancialMovementTypeStartChoice(Object, ThisObject, Item, ChoiceData,
		StandardProcessing);
EndProcedure

&AtClient
Procedure SendFinancialMovementTypeEditTextChange(Item, Text, StandardProcessing)
	DocMoneyTransferClient.FinancialMovementTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure ReceiveFinancialMovementTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocMoneyTransferClient.FinancialMovementTypeStartChoice(Object, ThisObject, Item, ChoiceData,
		StandardProcessing);
EndProcedure

&AtClient
Procedure ReceiveFinancialMovementTypeEditTextChange(Item, Text, StandardProcessing)
	DocMoneyTransferClient.FinancialMovementTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

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
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
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
Procedure EditAccounting(Command)
	UpdateAccountingData();
	AccountingClient.OpenFormEditAccounting(Object, ThisObject, Undefined, Undefined);
EndProcedure

&AtServer
Procedure UpdateAccountingData()
	_AccountingRowAnalytics = ThisObject.AccountingRowAnalytics.Unload();
	_AccountingExtDimensions = ThisObject.AccountingExtDimensions.Unload();
	AccountingClientServer.UpdateAccountingTables(Object, 
			                                      _AccountingRowAnalytics, 
		                                          _AccountingExtDimensions, Undefined);
	ThisObject.AccountingRowAnalytics.Load(_AccountingRowAnalytics);
	ThisObject.AccountingExtDimensions.Load(_AccountingExtDimensions);
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

&AtClient
Procedure EditCurrenciesSender(Command)
	FormParameters = CurrenciesClientServer.GetParameters_V7(Object, Object.SendUUID, Object.SendCurrency,
		Object.SendAmount);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure EditCurrenciesReceiver(Command)
	FormParameters = CurrenciesClientServer.GetParameters_V7(Object, Object.ReceiveUUID, Object.ReceiveCurrency,
		Object.ReceiveAmount);
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

#EndRegion
