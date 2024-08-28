#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocChequeBondTransactionServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocChequeBondTransactionServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
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
	DocChequeBondTransactionServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel) Export
	DocChequeBondTransactionClient.OnOpen(Object, ThisObject, Cancel);
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
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	Return;
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
	DocChequeBondTransactionClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocChequeBondTransactionClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocChequeBondTransactionClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocChequeBondTransactionClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region CURRENCY

&AtClient
Procedure CurrencyOnChange(Item)
	DocChequeBondTransactionClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region CHEQUE_BONDS

&AtClient
Procedure ChequeBondsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocChequeBondTransactionClient.ChequeBondsBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure ChequeBondsAfterDeleteRow(Item)
	DocChequeBondTransactionClient.ChequeBondsAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

#Region CHEQUE_BONDS_COLUMNS

#Region CHEQUE

&AtClient
Procedure ChequeBondsChequeOnChange(Item)
	DocChequeBondTransactionClient.ChequeBondsChequeOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ChequeBondsChequeStartChoice(Item, ChoiceData, StandardProcessing)
	DocChequeBondTransactionClient.ChequeBondsChequeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ChequeBondsChequeEditTextChange(Item, Text, StandardProcessing)
	DocChequeBondTransactionClient.ChequeBondsChequeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region NEW_STATUS

&AtClient
Procedure ChequeBondsNewStatusOnChange(Item)
	DocChequeBondTransactionClient.ChequeBondsNewStatusOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ChequeBondsNewStatusStartChoice(Item, ChoiceData, StandardProcessing)
	DocChequeBondTransactionClient.ChequeBondsNewStatusStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure 

&AtClient
Procedure ChequeBondsNewStatusEditTextChange(Item, Text, StandardProcessing)
	DocChequeBondTransactionClient.ChequeBondsNewStatusEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);	
EndProcedure

#EndRegion

#Region ACCOUNT

&AtClient
Procedure ChequeBondsAccountStartChoice(Item, ChoiceData, StandardProcessing)
	DocChequeBondTransactionClient.ChequeBondsAccountStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ChequeBondsAccountEditTextChange(Item, Text, StandardProcessing)
	DocChequeBondTransactionClient.ChequeBondsAccountEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region PARTNER

&AtClient
Procedure ChequeBondsPartnerOnChange(Item)
	DocChequeBondTransactionClient.ChequeBondsPartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ChequeBondsPartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocChequeBondTransactionClient.ChequeBondsPartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ChequeBondsPartnerEditTextChange(Item, Text, StandardProcessing)
	DocChequeBondTransactionClient.ChequeBondsPartnerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region LEGAL_NAME

&AtClient
Procedure ChequeBondsLegalNameOnChange(Item)
	DocChequeBondTransactionClient.ChequeBondsLegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ChequeBondsLegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocChequeBondTransactionClient.ChequeBondsLegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ChequeBondsLegalNameEditTextChange(Item, Text, StandardProcessing)
	DocChequeBondTransactionClient.ChequeBondsLegalNameEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region AGREEMENT

&AtClient
Procedure ChequeBondsAgreementOnChange(Item)
	DocChequeBondTransactionClient.ChequeBondsAgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ChequeBondsAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocChequeBondTransactionClient.ChequeBondsAgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ChequeBondsAgreementEditTextChange(Item, Text, StandardProcessing)
	DocChequeBondTransactionClient.ChequeBondsAgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region BASIS_DOCUMENT

&AtClient
Procedure ChequeBondsBasisDocumentOnChange(Item)
	DocChequeBondTransactionClient.ChequeBondsBasisDocumentOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ChequeBondsBasisDocumentStartChoice(Item, ChoiceData, StandardProcessing)
	DocChequeBondTransactionClient.ChequeBondsBasisDocumentStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

#EndRegion

#Region _ORDER

&AtClient
Procedure ChequeBondsOrderOnChange(Item)
	DocChequeBondTransactionClient.ChequeBondsOrderOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ChequeBondsOrderStartChoice(Item, ChoiceData, StandardProcessing)
	DocChequeBondTransactionClient.ChequeBondsOrderStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

#EndRegion

#Region FINANCIAL_MOVEMENT_TYPE

&AtClient
Procedure ChequeBondsFinancialMovementTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocChequeBondTransactionClient.ChequeBondsFinancialMovementTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ChequeBondsFinancialMovementTypeEditTextChange(Item, Text, StandardProcessing)
	DocChequeBondTransactionClient.ChequeBondsFinancialMovementTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region SERVICE

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocChequeBondTransactionClient);
	Str.Insert("Server", DocChequeBondTransactionServer);
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
Procedure PickupCheques(Command)
	FormParameters = New Structure();
	Filter = New Structure();
	Filter.Insert("Currency", Object.Currency);
	FormParameters.Insert("Filter", Filter);
	
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Form"   , ThisObject);
	NotifyParameters.Insert("Object" , Object);
	NotifyDescription = New NotifyDescription("FillChequesContinue", ThisObject, NotifyParameters);
	
	OpenForm("Catalog.ChequeBonds.Form.PickUpForm", 
		FormParameters, ThisObject, , , , 
		NotifyDescription, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure FillChequesContinue(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	For Each Row In Result Do
		FillingValues = New Structure();
		FillingValues.Insert("Cheque" , Row.ChequeBond);
		ViewClient_V2.ChequeBondsAddFilledRow(Object, ThisObject, FillingValues);
	EndDo;
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

#EndRegion

&AtClient
Procedure EditCurrencies(Command)
	CurrentData = ThisObject.Items.ChequeBonds.CurrentData;
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
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

#EndRegion
