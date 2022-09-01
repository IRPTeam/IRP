#Region FORM

Procedure OnOpen(Object, Form, Cancel) Export
	ViewClient_V2.OnOpen(Object, Form, "");
EndProcedure

#EndRegion

#Region _DATE

Procedure DateOnChange(Object, Form, Item) Export
	ViewClient_V2.DateOnChange(Object, Form, "");
EndProcedure

#EndRegion

#Region COMPANY

Procedure CompanyOnChange(Object, Form, Item) Export
	ViewClient_V2.CompanyOnChange(Object, Form, "");
EndProcedure

Procedure CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", True,
		DataCompositionComparisonType.Equal));
	OpenSettings.FillingData = New Structure("OurCompany", True);

	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", True, ComparisonType.Equal));
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region ACCOUNT

Procedure AccountOnChange(Object, Form, Item) Export
	ViewClient_V2.CashAccountOnChange(Object, Form, "");
EndProcedure

Procedure AccountStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	CashAccountTypes = New ValueList();
	CashAccountTypes.Add(PredefinedValue("Enum.CashAccountTypes.POSCashAccount"));
	CashAccountTypes.Add(PredefinedValue("Enum.CashAccountTypes.Cash"));
	
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Type", CashAccountTypes, DataCompositionComparisonType.InList));
	
	CommonFormActions.AccountStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, ArrayOfFilters);
EndProcedure

Procedure AccountEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	CashAccountTypes = New ValueList();
	CashAccountTypes.Add(PredefinedValue("Enum.CashAccountTypes.POSCashAccount"));
	CashAccountTypes.Add(PredefinedValue("Enum.CashAccountTypes.Cash"));
	
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Type", CashAccountTypes, ComparisonType.InList));
	
	CommonFormActions.AccountEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region STATUS

Procedure StatusOnChange(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

#EndRegion

#Region OPENING_DATE

Procedure OpeningDateOnChange(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

#EndRegion

#Region CLOSING_DATE

Procedure ClosingDateOnChange(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

#EndRegion
