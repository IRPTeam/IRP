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
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
	
	If Parameters.Property("CurrencyType") Then
		ThisObject.CurrencyType = Parameters.CurrencyType;
	ElsIf ValueIsFilled(Object.Currency) 
		Or Object.Type = Enums.CashAccountTypes.Bank
		Or Object.Type = Enums.CashAccountTypes.POS 
		Or Object.Type = Enums.CashAccountTypes.POSCashAccount 
		Or Object.Type = Enums.CashAccountTypes.Transit Then
		ThisObject.CurrencyType = "Fixed";
	Else
		ThisObject.CurrencyType = "Multi";
	EndIf;
	
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	
	CatCashAccountsServer.RemoveUnusedAccountTypes(ThisObject, "Type");
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure FillCheckProcessingAtServer(Cancel, CheckedAttributes)
	If ThisObject.CurrencyType = "Fixed" And Not ValueIsFilled(Object.Currency) Then
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_047, "Currency"), "Object.Currency");
	EndIf;
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	IsBankAccount    = Object.Type = PredefinedValue("Enum.CashAccountTypes.Bank");
	IsPOSAccount     = Object.Type = PredefinedValue("Enum.CashAccountTypes.POS");		
	IsTransitAccount = Object.Type = PredefinedValue("Enum.CashAccountTypes.Transit");
	IsPOSCashAccount = Object.Type = PredefinedValue("Enum.CashAccountTypes.POSCashAccount");
	
	Form.Items.BankName.Visible       = IsBankAccount Or IsPOSAccount;
	Form.Items.Number.Visible         = IsBankAccount Or IsPOSAccount;
	Form.Items.TransitAccount.Visible = IsBankAccount;
	Form.Items.CurrencyType.ReadOnly  = IsBankAccount Or IsPOSAccount Or IsTransitAccount Or IsPOSCashAccount;
	Form.Items.ReceiptingAccount.Visible    = IsPOSAccount;
	Form.Items.CashAccount.Visible = IsPOSCashAccount;
	Form.Items.FinancialMovementType.Visible = IsPOSCashAccount;
	Form.Items.Acquiring.Visible    = IsPOSAccount;
	Form.Items.BankCountry.Visible = IsBankAccount;
	Form.Items.BankIdentifierCode.Visible = IsBankAccount;
	Form.Items.BankSWIFTCode.Visible = IsBankAccount;
	Form.Items.isIBAN.Visible = IsBankAccount;
	
	If Form.CurrencyType = "Fixed" Then
		Form.Items.Currency.Visible = True;
		Form.Items.Currency.AutoMarkIncomplete = True;
	Else
		Form.Items.Currency.Visible = False;
		Form.Items.Currency.AutoMarkIncomplete = False;
	EndIf;
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

#EndRegion

&AtClient
Procedure CurrencyTypeOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);
	If Not ThisObject.CurrencyType = "Fixed" Then
		Object.Currency = Undefined;
	EndIf;
EndProcedure

&AtClient
Procedure TransitAccountStartChoice(Item, ChoiceData, StandardProcessing)
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Type", PredefinedValue("Enum.CashAccountTypes.Transit"), DataCompositionComparisonType.Equal));
	
	CommonFormActions.AccountStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, ArrayOfFilters);
EndProcedure

&AtClient
Procedure TransitAccountEditTextChange(Item, Text, StandardProcessing)
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Type", PredefinedValue("Enum.CashAccountTypes.Transit"), ComparisonType.Equal));

	CommonFormActions.AccountEditTextChange(Object, ThisObject, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

&AtClient
Procedure ReceiptingAccountStartChoice(Item, ChoiceData, StandardProcessing)
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Type", PredefinedValue("Enum.CashAccountTypes.Bank"), DataCompositionComparisonType.Equal));
	
	CommonFormActions.AccountStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, ArrayOfFilters);
EndProcedure

&AtClient
Procedure ReceiptingAccountEditTextChange(Item, Text, StandardProcessing)
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Type", PredefinedValue("Enum.CashAccountTypes.Bank"), ComparisonType.Equal));

	CommonFormActions.AccountEditTextChange(Object, ThisObject, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure TypeOnChange(Item)
	
	Object.Acquiring = Undefined;
	
	If Object.Type = PredefinedValue("Enum.CashAccountTypes.Bank")
		Or Object.Type = PredefinedValue("Enum.CashAccountTypes.POS") Then
		ThisObject.CurrencyType = "Fixed";
		Object.CashAccount = Undefined;
		Object.FinancialMovementType = Undefined;
	ElsIf Object.Type = PredefinedValue("Enum.CashAccountTypes.POSCashAccount") Then
		ThisObject.CurrencyType = "Fixed";
		Object.TransitAccount = PredefinedValue("Catalog.CashAccounts.EmptyRef");
		Object.Number = "";
		Object.BankName = "";
	Else
		ThisObject.CurrencyType = "Multi";
		Object.TransitAccount = PredefinedValue("Catalog.CashAccounts.EmptyRef");
		Object.Number = "";
		Object.BankName = "";
		Object.CashAccount = Undefined;
		Object.FinancialMovementType = Undefined;
	EndIf;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

#Region AddAttributes

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
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

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