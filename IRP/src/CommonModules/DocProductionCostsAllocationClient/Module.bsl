
#Region FORM

Procedure OnOpen(Object, Form, Cancel) Export
	ViewClient_V2.OnOpen(Object, Form, "ProductionCostsList, ProductionDurationsList");
EndProcedure

Procedure AfterWriteAtClient(Object, Form, WriteParameters) Export
	Return;
EndProcedure

#EndRegion

#Region COMPANY

Procedure CompanyOnChange(Object, Form, Item) Export
	ViewClient_V2.CompanyOnChange(Object, Form, "ProductionCostsList, ProductionDurationsList");
EndProcedure

Procedure CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", True, DataCompositionComparisonType.Equal));
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

#Region BEGIN_DATE

Procedure BeginDateOnChange(Object, Form, Item) Export
	ViewClient_V2.BeginDateOnChange(Object, Form, "ProductionCostsList, ProductionDurationsList");
EndProcedure

#EndRegion

#Region END_DATE

Procedure EndDateOnChange(Object, Form, Item) Export
	ViewClient_V2.EndDateOnChange(Object, Form, "ProductionCostsList, ProductionDurationsList");
EndProcedure

#EndRegion

#Region PRODUCTION_DURATIONS_LIST

Procedure ProductionDurationsListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	ViewClient_V2.ProductionDurationsListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing);
EndProcedure

Procedure ProductionDurationsListBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.ProductionDurationsListBeforeAddRow(Object, Form, Cancel, Clone);
EndProcedure

Procedure ProductionDurationsListBeforeDeleteRow(Object, Form, Item, Cancel, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure ProductionDurationsListAfterDeleteRow(Object, Form, Item) Export
	ViewClient_V2.ProductionDurationsListAfterDeleteRow(Object, Form);
EndProcedure

#Region PRODUCTION_DURATIONS_LIST_COLUMNS

#Region _ITEM

Procedure ProductionDurationsListItemOnChange(Object, Form, CurrentData = Undefined) Export
	ViewClient_V2.ProductionDurationsListItemOnChange(Object, Form, CurrentData);
EndProcedure

Procedure ProductionDurationsListItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ProductionDurationsListItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region ITEM_KEY

Procedure ProductionDurationsListItemKeyOnChange(Object, Form, CurrentData = Undefined) Export
	ViewClient_V2.ProductionDurationsListItemKeyOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region DURATION

Procedure ProductionDurationsListDurationOnChange(Object, Form, CurrentData = Undefined) Export
	ViewClient_V2.ProductionDurationsListDurationOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region AMOUNT

Procedure ProductionDurationsListAmountOnChange(Object, Form, CurrentData = Undefined) Export
	ViewClient_V2.ProductionDurationsListAmountOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region PRODUCTION_COSTS_LIST

Procedure ProductionCostsListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	ViewClient_V2.ProductionCostsListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing);
EndProcedure

Procedure ProductionCostsListBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.ProductionCostsListBeforeAddRow(Object, Form, Cancel, Clone);
EndProcedure

Procedure ProductionCostsListBeforeDeleteRow(Object, Form, Item, Cancel, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure ProductionCostsListAfterDeleteRow(Object, Form, Item) Export
	ViewClient_V2.ProductionCostsListAfterDeleteRow(Object, Form);
EndProcedure

#Region PRODUCTION_COSTS_LIST_COLUMNS

#Region EXPENSE_TYPE

Procedure ProductionCostsListExpenseTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	DocumentsClient.ExpenseTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing);
EndProcedure

Procedure ProductionCostsListExpenseTypeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DocumentsClient.ExpenseTypeEditTextChange(Object, Form, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region AMOUNT

Procedure ProductionCostsListAmountOnChange(Object, Form, CurrentData = Undefined) Export
	ViewClient_V2.ProductionCostsListAmountOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#EndRegion

#EndRegion
