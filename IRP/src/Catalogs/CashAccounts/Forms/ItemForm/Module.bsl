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
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	
	If Parameters.Property("CurrencyType") Then
		ThisObject.CurrencyType = Parameters.CurrencyType;
	ElsIf ValueIsFilled(Object.Currency) 
		Or Object.Type = Enums.CashAccountTypes.Bank
		Or Object.Type = Enums.CashAccountTypes.POS Then
		ThisObject.CurrencyType = "Fixed";
	Else
		ThisObject.CurrencyType = "Multi";
	EndIf;
	
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	
	If Not FOServer.IsUseBankDocuments() Then
		ArrayForDelete = New Array();
		For Each ListItem In Items.Type.ChoiceList Do
			If Not (Not ValueIsFilled(ListItem.Value) 
				Or ListItem.Value = Enums.CashAccountTypes.Cash
				Or ListItem.Value = Enums.CashAccountTypes.POS) Then
				ArrayForDelete.Add(ListItem);
			EndIf;
		EndDo;
		For Each ArrayItem In ArrayForDelete Do
			Items.Type.ChoiceList.Delete(ArrayItem);
		EndDo;
	EndIf;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure BeforeWrite(Cancel, WriteParameters)
	CatCashAccountsClient.BeforeWrite(Object, ThisObject, Cancel, WriteParameters);
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
	
	Form.Items.BankName.Visible       = IsBankAccount Or IsPOSAccount;
	Form.Items.Number.Visible         = IsBankAccount Or IsPOSAccount;
	Form.Items.TransitAccount.Visible = IsBankAccount;
	Form.Items.CurrencyType.ReadOnly  = IsBankAccount Or IsPOSAccount Or IsTransitAccount;
	Form.Items.ReceiptingAccount.Visible    = IsPOSAccount;
	Form.Items.CommissionIsSeparate.Visible = IsBankAccount;
	
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
	StandardProcessing = False;
	DefaultStartChoiceParameters = New Structure("Company", Object.Company);
	StartChoiceParameters = CatCashAccountsClient.GetDefaultStartChoiceParameters(DefaultStartChoiceParameters);
	Filter = DocumentsClientServer.CreateFilterItem("Type", PredefinedValue("Enum.CashAccountTypes.Transit"), ,
		DataCompositionComparisonType.Equal);
	StartChoiceParameters.CustomParameters.Filters.Add(Filter);
	StartChoiceParameters.FillingData.Insert("Type", PredefinedValue("Enum.CashAccountTypes.Transit"));
	OpenForm(StartChoiceParameters.FormName, StartChoiceParameters, Item, ThisObject.UUID, , ThisObject.URL);
EndProcedure

&AtClient
Procedure TransitAccountEditTextChange(Item, Text, StandardProcessing)
	DefaultEditTextParameters = New Structure("Company", Object.Company);
	EditTextParameters = CatCashAccountsClient.GetDefaultEditTextParameters(DefaultEditTextParameters);
	Filter = DocumentsClientServer.CreateFilterItem("Type", PredefinedValue("Enum.CashAccountTypes.Transit"),
		ComparisonType.Equal);
	EditTextParameters.Filters.Add(Filter);
	Item.ChoiceParameters = CatCashAccountsClient.FixedArrayOfChoiceParameters(EditTextParameters);
EndProcedure

&AtClient
Procedure ReceiptingAccountStartChoice(Item, ChoiceData, StandardProcessing)
	StandardProcessing = False;
	DefaultStartChoiceParameters = New Structure("Company", Object.Company);
	StartChoiceParameters = CatCashAccountsClient.GetDefaultStartChoiceParameters(DefaultStartChoiceParameters);
	Filter = DocumentsClientServer.CreateFilterItem("Type", PredefinedValue("Enum.CashAccountTypes.Bank"), ,
		DataCompositionComparisonType.Equal);
	StartChoiceParameters.CustomParameters.Filters.Add(Filter);
	StartChoiceParameters.FillingData.Insert("Type", PredefinedValue("Enum.CashAccountTypes.Bank"));
	OpenForm(StartChoiceParameters.FormName, StartChoiceParameters, Item, ThisObject.UUID, , ThisObject.URL);
EndProcedure

&AtClient
Procedure ReceiptingAccountEditTextChange(Item, Text, StandardProcessing)
	DefaultEditTextParameters = New Structure("Company", Object.Company);
	EditTextParameters = CatCashAccountsClient.GetDefaultEditTextParameters(DefaultEditTextParameters);
	Filter = DocumentsClientServer.CreateFilterItem("Type", PredefinedValue("Enum.CashAccountTypes.Bank"),
		ComparisonType.Equal);
	EditTextParameters.Filters.Add(Filter);
	Item.ChoiceParameters = CatCashAccountsClient.FixedArrayOfChoiceParameters(EditTextParameters);
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure TypeOnChange(Item)
	CatCashAccountsClient.TypeOnChange(Object, ThisObject, Item);
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

#EndRegion