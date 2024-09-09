
#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocDebitCreditNoteServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocDebitCreditNoteServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
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
	DocDebitCreditNoteServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel) Export
	DocDebitCreditNoteClient.OnOpen(Object, ThisObject, Cancel);
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
	Form.Items.SendLegalName.Enabled    = ValueIsFilled(Object.SendPartner);
	Form.Items.ReceiveLegalName.Enabled = ValueIsFilled(Object.ReceivePartner);
	
	Form.Items.EditCurrenciesSender.Enabled = Not Form.ReadOnly;
	Form.Items.EditCurrenciesReceiver.Enabled = Not Form.ReadOnly;
	Form.Items.EditAccounting.Enabled = Not Form.ReadOnly;
	
	IsEnabled_SendBasisDocument = True;
	If Object.SendDebtType = PredefinedValue("Enum.DebtTypes.AdvanceCustomer")
		Or Object.SendDebtType = PredefinedValue("Enum.DebtTypes.AdvanceVendor") Then
		IsEnabled_SendBasisDocument = False;
	ElsIf Not ValueIsFilled(Object.SendAgreement) Then
		IsEnabled_SendBasisDocument = False;
	ElsIf CommonFunctionsServer.GetRefAttribute(Object.SendAgreement, "ApArPostingDetail") 
		<> PredefinedValue("Enum.ApArPostingDetail.ByDocuments") Then
		IsEnabled_SendBasisDocument = False;
	EndIf;	
	Form.Items.SendBasisDocument.Enabled = IsEnabled_SendBasisDocument;
	
	IsEnabled_ReceiveBasisDocument = True;
	If Object.ReceiveDebtType = PredefinedValue("Enum.DebtTypes.AdvanceCustomer")
		Or Object.ReceiveDebtType = PredefinedValue("Enum.DebtTypes.AdvanceVendor") Then
		IsEnabled_ReceiveBasisDocument = False;
	ElsIf Not ValueIsFilled(Object.ReceiveAgreement) Then
		IsEnabled_ReceiveBasisDocument = False;
	ElsIf CommonFunctionsServer.GetRefAttribute(Object.ReceiveAgreement, "ApArPostingDetail") 
		<> PredefinedValue("Enum.ApArPostingDetail.ByDocuments") Then
		IsEnabled_ReceiveBasisDocument = False;
	EndIf;	
	Form.Items.ReceiveBasisDocument.Enabled = IsEnabled_ReceiveBasisDocument;
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
	DocDebitCreditNoteClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocDebitCreditNoteClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocDebitCreditNoteClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region _DATE

&AtClient
Procedure DateOnChange(Item) Export
	DocDebitCreditNoteClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region SEND_DEBT_TYPE

&AtClient
Procedure SendDebtTypeOnChange(Item)
	DocDebitCreditNoteClient.SendDebtTypeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region SEND_PARTNER

&AtClient
Procedure SendPartnerOnChange(Item)
	DocDebitCreditNoteClient.SendPartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure SendPartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocDebitCreditNoteClient.SendPartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure SendPartnerEditTextChange(Item, Text, StandardProcessing)
	DocDebitCreditNoteClient.SendPartnerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region SEND_AGREEMENT

&AtClient
Procedure SendAgreementOnChange(Item)
	DocDebitCreditNoteClient.SendAgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure SendAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocDebitCreditNoteClient.SendAgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure SendAgreementEditTextChange(Item, Text, StandardProcessing)
	DocDebitCreditNoteClient.SendAgreementEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region SEND_LEGAL_NAME

&AtClient
Procedure SendLegalNameOnChange(Item)
	DocDebitCreditNoteClient.SendLegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure SendLegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocDebitCreditNoteClient.SendLegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure SendLegalNameEditTextChange(Item, Text, StandardProcessing)
	DocDebitCreditNoteClient.SendLegalNameEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region RECEIVE_DEBT_TYPE

&AtClient
Procedure ReceiveDebtTypeOnChange(Item)
	DocDebitCreditNoteClient.ReceiveDebtTypeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region RECEIVE_PARTNER

&AtClient
Procedure ReceivePartnerOnChange(Item)
	DocDebitCreditNoteClient.ReceivePartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ReceivePartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocDebitCreditNoteClient.ReceivePartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ReceivePartnerEditTextChange(Item, Text, StandardProcessing)
	DocDebitCreditNoteClient.ReceivePartnerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region RECEIVE_AGREEMENT

&AtClient
Procedure ReceiveAgreementOnChange(Item)
	DocDebitCreditNoteClient.ReceiveAgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ReceiveAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocDebitCreditNoteClient.ReceiveAgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ReceiveAgreementEditTextChange(Item, Text, StandardProcessing)
	DocDebitCreditNoteClient.ReceiveAgreementEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region RECEIVE_LEGAL_NAME

&AtClient
Procedure ReceiveLegalNameOnChange(Item)
	DocDebitCreditNoteClient.ReceiveLegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ReceiveLegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocDebitCreditNoteClient.ReceiveLegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ReceiveLegalNameEditTextChange(Item, Text, StandardProcessing)
	DocDebitCreditNoteClient.ReceiveLegalNameEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

&AtClient
Procedure CurrencyOnChange(Item)
	DocDebitCreditNoteClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure SendCurrencyOnChange(Item)
	DocDebitCreditNoteClient.SendCurrencyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ReceiveCurrencyOnChange(Item)
	DocDebitCreditNoteClient.ReceiveCurrencyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure SendAmountOnChange(Item)
	DocDebitCreditNoteClient.SendAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ReceiveAmountOnChange(Item)
	DocDebitCreditNoteClient.ReceiveAmountOnChange(Object, ThisObject, Item);
EndProcedure

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
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

&AtClient
Procedure EditCurrenciesSender(Command)
	FormParameters = CurrenciesClientServer.GetParameters_V7(Object, Object.SendUUID, Object.SendCurrency,
		Object.SendAmount, Object.SendAgreement);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure EditCurrenciesReceiver(Command)
	FormParameters = CurrenciesClientServer.GetParameters_V7(Object, Object.ReceiveUUID, Object.ReceiveCurrency,
		Object.ReceiveAmount, Object.ReceiveAgreement);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

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

#EndRegion
