&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	If ValueIsFilled(Object.Currency) Or Object.Type = Enums.CashAccountTypes.Bank Then
		ThisObject.CurrencyType = "Fixed";
	Else
		ThisObject.CurrencyType = "Multi";
	EndIf;
	If Parameters.Property("CurrencyType") Then
		CurrencyType = Parameters.CurrencyType;	
	EndIf;
EndProcedure

&AtClient
Procedure CurrencyTypeOnChange(Item)
	CatCashAccountsClient.SetItemsBehavior(Object, ThisObject);
EndProcedure

&AtClient
Procedure TransitAccountStartChoice(Item, ChoiceData, StandardProcessing)
	StandardProcessing = False;
	DefaultStartChoiceParameters = New Structure("Company", Object.Company);
	StartChoiceParameters = CatCashAccountsClient.GetDefaultStartChoiceParameters(DefaultStartChoiceParameters);
	StartChoiceParameters.CustomParameters.Filters.Add(DocumentsClientServer.CreateFilterItem("Type",
																		PredefinedValue("Enum.CashAccountTypes.Transit"),
																		,
																		DataCompositionComparisonType.Equal));
	StartChoiceParameters.FillingData.Insert("Type", PredefinedValue("Enum.CashAccountTypes.Transit"));
	OpenForm(StartChoiceParameters.FormName, StartChoiceParameters, Item, ThisObject.UUID, , ThisObject.URL);
EndProcedure

&AtClient
Procedure TransitAccountEditTextChange(Item, Text, StandardProcessing)
	DefaultEditTextParameters = New Structure("Company", Object.Company);
	EditTextParameters = CatCashAccountsClient.GetDefaultEditTextParameters(DefaultEditTextParameters);
	EditTextParameters.Filters.Add(DocumentsClientServer.CreateFilterItem("Type",
																		PredefinedValue("Enum.CashAccountTypes.Transit"),
																		ComparisonType.Equal));
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
