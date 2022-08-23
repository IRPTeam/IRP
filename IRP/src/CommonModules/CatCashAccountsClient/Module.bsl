#Region FormEvents

Procedure BeforeWrite(Object, Form, Cancel, WriteParameters) Export
	If Object.Type <> PredefinedValue("Enum.CashAccountTypes.Bank") Then
		Object.BankName = "";
		Object.Number = "";
	EndIf;
EndProcedure

Procedure TypeOnChange(Object, Form, Item) Export
	If Object.Type = PredefinedValue("Enum.CashAccountTypes.Bank")
		Or Object.Type = PredefinedValue("Enum.CashAccountTypes.POS") Then
		Form.CurrencyType = "Fixed";
	ElsIf Object.Type = PredefinedValue("Enum.CashAccountTypes.POSCashAccount") Then
		Form.CurrencyType = "Fixed";
		Object.TransitAccount = PredefinedValue("Catalog.CashAccounts.EmptyRef");
		Object.Number = "";
		Object.BankName = "";
	Else
		Form.CurrencyType = "Multi";
		Object.TransitAccount = PredefinedValue("Catalog.CashAccounts.EmptyRef");
		Object.Number = "";
		Object.BankName = "";
	EndIf;
EndProcedure

#EndRegion

#Region StartChoiceAndEditText

Function GetOpenSettingsStructure()
	Settings = New Structure();
	Settings.Insert("FormName", Undefined);
	Settings.Insert("FormParameters", New Structure());
	Settings.Insert("FillingData", New Structure());
	Settings.Insert("CustomParameters", New Structure());
	Return Settings;
EndFunction

Function GetDefaultStartChoiceParameters(Parameters) Export
	OpenSettings = GetOpenSettingsStructure();
	OpenSettings.FormName = "Catalog.CashAccounts.ChoiceForm";
	OpenSettings.FillingData.Insert("Company", Parameters.Company);
	OpenSettings.CustomParameters = DefaultCustomParameters(Parameters);
	OpenSettings.CustomParameters.Fields.Insert("Currency", "Currency");
	OpenSettings.CustomParameters.Fields.Insert("Type", "Type");
	OpenSettings.CustomParameters.Fields.Insert("Description", "Description_en");
	Return OpenSettings;
EndFunction

Function GetDefaultEditTextParameters(Parameters) Export
	CustomParameters = DefaultCustomParameters(Parameters);
	CustomParameters.Fields.Insert("Presentation", "Presentation");
	CustomParameters.OptionsString = "ALLOWED TOP 50";
	Return CustomParameters;
EndFunction

Function FixedArrayOfChoiceParameters(Parameters) Export
	ChoiceParameter = New ChoiceParameter("Filter.CustomParameters", DocumentsServer.SerializeArrayOfFilters(
		Parameters));
	ArrayOfChoiceParameters = New Array();
	ArrayOfChoiceParameters.Add(ChoiceParameter);
	Return New FixedArray(ArrayOfChoiceParameters);
EndFunction

Function DefaultCustomParameters(Parameters = Undefined) Export
	Filters = New Array();
	Filters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", False, ComparisonType.Equal,
		DataCompositionComparisonType.Equal));

	ComplexFilters = New Array();
	If Parameters.Property("Company") Then
		ComplexFilters.Add(DocumentsClientServer.CreateFilterItem("ByCompanyWithEmpty", Parameters.Company));
	EndIf;

	Fields = New Structure();
	Fields.Insert("Ref", "Ref");

	ReturnValue = New Structure();
	ReturnValue.Insert("Filters", Filters);
	ReturnValue.Insert("ComplexFilters", ComplexFilters);
	ReturnValue.Insert("Fields", Fields);
	ReturnValue.Insert("OptionsString", "");
	Return ReturnValue;
EndFunction

#EndRegion
