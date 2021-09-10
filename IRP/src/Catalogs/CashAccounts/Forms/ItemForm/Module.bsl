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
	If ValueIsFilled(Object.Currency) Or Object.Type = Enums.CashAccountTypes.Bank Then
		ThisObject.CurrencyType = "Fixed";
	Else
		ThisObject.CurrencyType = "Multi";
	EndIf;
	If Parameters.Property("CurrencyType") Then
		CurrencyType = Parameters.CurrencyType;
	EndIf;
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	CatCashAccountsClient.SetItemsBehavior(Object, ThisObject);
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

#EndRegion

&AtClient
Procedure CurrencyTypeOnChange(Item)
	CatCashAccountsClient.SetItemsBehavior(Object, ThisObject);
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
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure TypeOnChange(Item)
	CatCashAccountsClient.TypeOnChange(Object, ThisObject, Item);
	CatCashAccountsClient.SetItemsBehavior(Object, ThisObject);
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