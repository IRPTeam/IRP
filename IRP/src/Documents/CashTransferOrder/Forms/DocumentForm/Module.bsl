#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocCashTransferOrderServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocCashTransferOrderServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	CurrenciesServer.BeforeWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocCashTransferOrderServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocCashTransferOrderClient.OnOpen(Object, ThisObject, Cancel);
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
	If DocCashTransferOrderServer.UseCashAdvanceHolder(Object) Then
		Form.Items.CashAdvanceHolder.Visible = True;
	Else
		Form.Items.CashAdvanceHolder.Visible = False;
		If Not ValueIsFilled(Object.Ref) Then
			Object.CashAdvanceHolder = Undefined;
		EndIf;
	EndIf;
	Form.Items.EditCurrenciesSender.Enabled = Not Form.ReadOnly;
	Form.Items.EditCurrenciesReceiver.Enabled = Not Form.ReadOnly;
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
Procedure CompanyOnChange(Item)
	DocCashTransferOrderClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashTransferOrderClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocCashTransferOrderClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region _DATE

&AtClient
Procedure DateOnChange(Item)
	DocCashTransferOrderClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ACCOUNT_SENDER

&AtClient
Procedure SenderOnChange(Item, AddInfo = Undefined) Export
	DocCashTransferOrderClient.SenderOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure SenderStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashTransferOrderClient.SenderStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure SenderEditTextChange(Item, Text, StandardProcessing)
	DocCashTransferOrderClient.SenderEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region CURRENCY_SEND

&AtClient
Procedure SendCurrencyOnChange(Item)
	DocCashTransferOrderClient.SendCurrencyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region CURRENCY_RECEIVE

&AtClient
Procedure ReceiveCurrencyOnChange(Item)
	DocCashTransferOrderClient.ReceiveCurrencyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region AMOUNT_SEND

&AtClient
Procedure SendAmountOnChange(Item)
	DocCashTransferOrderClient.SendAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ACCOUNT_RECEIVER

&AtClient
Procedure ReceiverOnChange(Item)
	DocCashTransferOrderClient.ReceiverOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ReceiverStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashTransferOrderClient.ReceiverStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ReceiverEditTextChange(Item, Text, StandardProcessing)
	DocCashTransferOrderClient.ReceiverEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region AMOUNT_RECEIVE

&AtClient
Procedure ReceiveAmountOnChange(Item)
	DocCashTransferOrderClient.ReceiveAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region FINANCIAL_MOVEMENT_TYPE

&AtClient
Procedure SendFinancialMovementTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashTransferOrderClient.FinancialMovementTypeStartChoice(Object, ThisObject, Item, ChoiceData,
		StandardProcessing);
EndProcedure

&AtClient
Procedure SendFinancialMovementTypeEditTextChange(Item, Text, StandardProcessing)
	DocCashTransferOrderClient.FinancialMovementTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure ReceiveFinancialMovementTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashTransferOrderClient.FinancialMovementTypeStartChoice(Object, ThisObject, Item, ChoiceData,
		StandardProcessing);
EndProcedure

&AtClient
Procedure ReceiveFinancialMovementTypeEditTextChange(Item, Text, StandardProcessing)
	DocCashTransferOrderClient.FinancialMovementTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region CASH_ADVANCE_HOLDER

&AtClient
Procedure CashAdvanceHolderStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashTransferOrderClient.CashAdvanceHolderStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CashAdvanceHolderEditTextChange(Item, Text, StandardProcessing)
	DocCashTransferOrderClient.CashAdvanceHolderTextChange(Object, ThisObject, Item, Text, StandardProcessing);
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
