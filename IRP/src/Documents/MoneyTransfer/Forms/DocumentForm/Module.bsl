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
	
	CashTransferOrderIsFilled = ValueIsFilled(Object.CashTransferOrder);
	
	Form.Items.Sender.ReadOnly   = CashTransferOrderIsFilled;
	Form.Items.Receiver.ReadOnly = CashTransferOrderIsFilled;
	Form.Items.SendCurrency.ReadOnly    = CashTransferOrderIsFilled;
	Form.Items.ReceiveCurrency.ReadOnly = CashTransferOrderIsFilled;
	Form.Items.ReceiveFinancialMovementType.ReadOnly = CashTransferOrderIsFilled;
	Form.Items.SendFinancialMovementType.ReadOnly    = CashTransferOrderIsFilled;
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
	DocMoneyTransferClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region TITLE_DECORATIONS

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocMoneyTransferClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocMoneyTransferClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocMoneyTransferClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocMoneyTransferClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
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
