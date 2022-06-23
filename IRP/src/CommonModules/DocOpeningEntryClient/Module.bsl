#Region FORM

Procedure OnOpen(Object, Form, Cancel, MainTables) Export
	ViewClient_V2.OnOpen(Object, Form, "");
EndProcedure

#EndRegion

#Region COMPANY

Procedure CompanyOnChange(Object, Form, Item, MainTables) Export
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

#Region _DATE

Procedure DateOnChange(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

#EndRegion

#Region INVENTORY

Procedure InventoryBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.InventoryBeforeAddRow(Object, Form, Cancel, Clone);
EndProcedure

Procedure InventoryAfterDeleteRow(Object, Form, Item) Export
	ViewClient_V2.InventoryAfterDeleteRow(Object, Form);
EndProcedure

#Region INVENTORY_COLUMNS

#Region _ITEM

Procedure InventoryItemOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.InventoryItemOnChange(Object, Form, CurrentData);
EndProcedure

Procedure InventoryItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ItemType.Type", 
		PredefinedValue("Enum.ItemTypes.Service"), DataCompositionComparisonType.NotEqual));

	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure InventiryItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ItemType.Type", 
		PredefinedValue("Enum.ItemTypes.Service"), ComparisonType.NotEqual));
	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region ITEM_KEY

Procedure InventoryItemKeyOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.InventoryItemKeyOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region ACCOUNT_BALANCE

Procedure AccountBalanceBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.AccountBalanceBeforeAddRow(Object, Form, Cancel, Clone);
EndProcedure

Procedure AccountBalanceAfterDeleteRow(Object, Form, Item) Export
	ViewClient_V2.AccountBalanceAfterDeleteRow(Object, Form);
EndProcedure

#Region ACCOUNT_BALANCE_COLUMNS

#Region ACCOUNT

Procedure AccountBalanceAccountOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.AccountBalanceAccountOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#EndRegion

#EndRegion
