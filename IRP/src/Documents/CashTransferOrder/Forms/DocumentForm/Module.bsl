#Region FormEvents

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
	DocCashTransferOrderServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Not ValueIsFilled(Object.Ref) Then
		Object.SendUUID = New UUID();
		Object.ReceiveUUID = New UUID();
	EndIf;
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters, AddInfo = Undefined) Export
	DocCashTransferOrderServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocCashTransferOrderServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel, AddInfo = Undefined) Export
	DocCashTransferOrderClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form) Export
	Form.Items.EditCurrenciesSender.Enabled = Not Form.ReadOnly;
	Form.Items.EditCurrenciesReceiver.Enabled = Not Form.ReadOnly;
EndProcedure

#EndRegion

&AtClient
Procedure SendCurrencyOnChange(Item, AddInfo = Undefined) Export
	DocCashTransferOrderClient.SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure ReceiveCurrencyOnChange(Item, AddInfo = Undefined) Export
	DocCashTransferOrderClient.SetVisibilityAvailability(Object, ThisObject);
EndProcedure

#Region ItemCompany

&AtClient
Procedure CompanyOnChange(Item, AddInfo = Undefined) Export
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

&AtClient
Procedure DateOnChange(Item, AddInfo = Undefined) Export
	DocCashTransferOrderClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ReceiveAmountOnChange(Item, AddInfo = Undefined) Export
	DocCashTransferOrderClient.ReceiveAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure SendAmountOnChange(Item, AddInfo = Undefined) Export
	DocCashTransferOrderClient.SendAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure SenderOnChange(Item, AddInfo = Undefined) Export
	DocCashTransferOrderClient.SenderOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ReceiverOnChange(Item, AddInfo = Undefined) Export
	DocCashTransferOrderClient.ReceiverOnChange(Object, ThisObject, Item);
EndProcedure

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

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocCashTransferOrderClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocCashTransferOrderClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocCashTransferOrderClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocCashTransferOrderClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region DescriptionEvents

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocCashTransferOrderClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

&AtClient
Procedure SenderStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashTransferOrderClient.SenderStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ReceiverStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashTransferOrderClient.ReceiverStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure SenderEditTextChange(Item, Text, StandardProcessing)
	DocCashTransferOrderClient.SenderEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure ReceiverEditTextChange(Item, Text, StandardProcessing)
	DocCashTransferOrderClient.ReceiverEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure CashAdvanceHolderStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashTransferOrderClient.CashAdvanceHolderStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CashAdvanceHolderEditTextChange(Item, Text, StandardProcessing)
	DocCashTransferOrderClient.CashAdvanceHolderTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

#EndRegion

#Region ExternalCommands

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
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , ,Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure EditCurrenciesReceiver(Command)
	FormParameters = CurrenciesClientServer.GetParameters_V7(Object, Object.ReceiveUUID, Object.ReceiveCurrency,
		Object.ReceiveAmount);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , ,Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure


