
#Region FORM

&AtClient
Var MainTables Export;

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocTaxesOperationServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocTaxesOperationServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;	
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	AccountingServer.BeforeWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocTaxesOperationServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocTaxesOperationClient.OnOpen(Object, ThisObject, Cancel);
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

&AtClient
Procedure CalculateTaxesDifference() Export
	Result = DocTaxesOperationServer.CalculateTaxDifference(Object);
	Object.TaxesDifference.Clear();
	For Each Row In Result Do
		FillPropertyValues(Object.TaxesDifference.Add(), Row);
	EndDo;
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
	DocTaxesOperationClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocTaxesOperationClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocTaxesOperationClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocTaxesOperationClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region CURRENCY

&AtClient
Procedure CurrencyOnChange(Item)
	DocTaxesOperationClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure
	
#EndRegion

#Region TRANSACTION_TYPE

&AtClient
Procedure TransactionTypeOnChange(Item)
	DocTaxesOperationClient.TransactionTypeOnChange(Object, ThisObject, Item);
	CalculateTaxesDifference();
EndProcedure

#EndRegion

#Region PARTNER

&AtClient
Procedure PartnerOnChange(Item)
	DocTaxesOperationClient.PartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocTaxesOperationClient.PartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PartnerEditTextChange(Item, Text, StandardProcessing)
	DocTaxesOperationClient.PartnerTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region LEGAL_NAME

&AtClient
Procedure LegalNameOnChange(Item)
	DocTaxesOperationClient.LegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure LegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocTaxesOperationClient.LegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure LegalNameEditTextChange(Item, Text, StandardProcessing)
	DocTaxesOperationClient.LegalNameTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region AGREEMENT

&AtClient
Procedure AgreementOnChange(Item)
	DocTaxesOperationClient.AgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocTaxesOperationClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AgreementEditTextChange(Item, Text, StandardProcessing)
	DocTaxesOperationClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region LEGAL_NAME_CONTRACT

&AtClient
Procedure LegalNameContractOnChange(Item)
	DocTaxesOperationClient.LegalNameContractOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TAXES_INCOMING
		
&AtClient
Procedure TaxesIncomingBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocTaxesOperationClient.TaxesIncomingBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure TaxesIncomingAfterDeleteRow(Item)
	DocTaxesOperationClient.TaxesIncomingAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TAXES_OUTGOING

&AtClient
Procedure TaxesOutgoingBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocTaxesOperationClient.TaxesOutgoingBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure TaxesOutgoingAfterDeleteRow(Item)
	DocTaxesOperationClient.TaxesOutgoingAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region SERVICE

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocTaxesOperationClient);
	Str.Insert("Server", DocTaxesOperationServer);
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
	FormParameters = CurrenciesClientServer.GetParameters_V13(Object);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure EditAccounting(Command)
	CurrentData = ThisObject.Items.TaxesDifference.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	UpdateAccountingData();
	AccountingClient.OpenFormEditAccounting(Object, ThisObject, CurrentData, "TaxesDifference");
EndProcedure

&AtServer
Procedure UpdateAccountingData()
	_AccountingRowAnalytics = ThisObject.AccountingRowAnalytics.Unload();
	_AccountingExtDimensions = ThisObject.AccountingExtDimensions.Unload();
	AccountingClientServer.UpdateAccountingTables(Object, 
			                                      _AccountingRowAnalytics, 
		                                          _AccountingExtDimensions, "TaxesDifference");
	ThisObject.AccountingRowAnalytics.Load(_AccountingRowAnalytics);
	ThisObject.AccountingExtDimensions.Load(_AccountingExtDimensions);
EndProcedure

&AtClient
Procedure FillTaxesIncoming(Command)
	Object.TaxesIncoming.Clear();
	DocTaxesOperationClient.FillTaxesIncomingOutgoing(Object, 
		ThisObject, Object.Ref, Object.Date, Object.Company, Object.Branch, Object.Currency, 
		"R2040B_TaxesIncoming", "TaxesIncoming");
	CalculateTaxesDifference();
EndProcedure

&AtClient
Procedure FillTaxesOutgoing(Command)
	Object.TaxesOutgoing.Clear();
	DocTaxesOperationClient.FillTaxesIncomingOutgoing(Object, 
		ThisObject, Object.Ref, Object.Date, Object.Company, Object.Branch, Object.Currency, 
		"R1040B_TaxesOutgoing", "TaxesOutgoing");
	CalculateTaxesDifference();
EndProcedure

#EndRegion

MainTables = "TaxesIncoming, TaxesOutgoing";
