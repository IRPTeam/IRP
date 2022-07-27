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
	DocSalesOrderClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region CHEQUE_BONDS

&AtClient
Procedure ChequeBondsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocChequeBondTransactionClient.ItemListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure ChequeBondsAfterDeleteRow(Item)
	DocChequeBondTransactionClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

#Region CHEQUE_BONDS_COLUMNS

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
Procedure FillCheques(Command)
	FormParameters = New Structure();
	Filter = New Structure();
	Filter.Insert("Currency"     , Object.Currency);
	Filter.Insert("DeletionMark" , False);
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
//	If NOT ValueIsFilled(Result)
//		OR Not AdditionalParameters.Property("Object")
//		OR Not AdditionalParameters.Property("Form") Then
//		Return;
//	EndIf;
//	 
//	For Each ResultElement In Result Do
//		NewChequeBondRow = AdditionalParameters.Object.ChequeBonds.Add();
//		NewChequeBondRow.Key = New UUID();
//		NewChequeBondRow.Cheque = ResultElement.ChequeBond;
//		FillChequeBondsRow(NewChequeBondRow, AdditionalParameters.Object);
//	EndDo;
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

#EndRegion

//&AtClient
//Procedure EditCurrencies(Command)
//	FormParameters = CurrenciesClientServer.GetParameters_V3(Object);
//	NotifyParameters = New Structure();
//	NotifyParameters.Insert("Object", Object);
//	NotifyParameters.Insert("Form"  , ThisObject);
//	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
//	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
//EndProcedure

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

#EndRegion
