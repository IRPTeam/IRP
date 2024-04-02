#Region FORM

Procedure OnOpen(Object, Form, Cancel) Export
	ViewClient_V2.OnOpen(Object, Form, "Materials");
EndProcedure

Procedure AfterWriteAtClient(Object, Form, WriteParameters) Export
	Return;
EndProcedure

#EndRegion

#Region _DATE

Procedure DateOnChange(Object, Form, Item) Export
	ViewClient_V2.DateOnChange(Object, Form, "Materials");
EndProcedure

#EndRegion

#Region COMPANY

Procedure CompanyOnChange(Object, Form, Item) Export
	ViewClient_V2.CompanyOnChange(Object, Form, "Materials");
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

#Region TRANSACTION_TYPE

Procedure TransactionTypeOnChange(Object, Form, Item) Export
	ViewClient_V2.TransactionTypeOnChange(Object, Form, "Materials");
EndProcedure

#EndRegion

#Region BUSINESS_UNIT

Procedure BusinessUnitOnChange(Object, Form, Item) Export
	ViewClient_V2.BusinessUnitOnChange(Object, Form, "Materials");
EndProcedure

#EndRegion

#Region PLANNING_PERIOD

Procedure PlanningPeriodOnChange(Object, Form, Item) Export
	ViewClient_V2.PlanningPeriodOnChange(Object, Form, "Materials");
EndProcedure

#EndRegion

#Region _ITEM

Procedure ItemOnChange(Object, Form, Item) Export
	ViewClient_V2.ItemOnChange(Object, Form, "Materials");
EndProcedure

Procedure ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsForSelectItemWithoutServiceFilter();
	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = DocumentsClient.GetArrayOfFiltersForSelectItemWithoutServiceFilter();
	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region ITEM_KEY

Procedure ItemKeyOnChange(Object, Form, Item) Export
	ViewClient_V2.ItemKeyOnChange(Object, Form, "Materials");
EndProcedure

#EndRegion

#Region STORE_PRODUCTION

Procedure StoreProductionOnChange(Object, Form, Item) Export
	ViewClient_V2.StoreProductionOnChange(Object, Form, "Materials");
EndProcedure

#EndRegion

#Region QUANTITY

Procedure QuantityOnChange(Object, Form, Item) Export
	ViewClient_V2.QuantityOnChange(Object, Form, "Materials");
EndProcedure

#EndRegion

#Region UNIT

Procedure UnitOnChange(Object, Form, Item) Export
	ViewClient_V2.UnitOnChange(Object, Form, "Materials");
EndProcedure

#EndRegion

#Region BILL_OF_MATERIALS

Procedure BillOfMaterialsOnChange(Object, Form, Item) Export
	ViewClient_V2.BillOfMaterialsOnChange(Object, Form, "Materials");
EndProcedure

#EndRegion

#Region UPDATE_BY_BILL_OF_MATERIALS

Procedure UpdateByBillOfMaterials(Object, Form) Export
	ViewClient_V2.ExecuteCommand(Object, Form, "Materials", "Command_UpdateByBillOfMaterials");
EndProcedure
	
#EndRegion

#Region MATERIALS

Procedure MaterialsSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	Return;
EndProcedure

Procedure MaterialsBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.MaterialsBeforeAddRow(Object, Form, Cancel, Clone, Undefined, Undefined);
EndProcedure

Procedure MaterialsBeforeDeleteRow(Object, Form, Item, Cancel) Export
	CurrentData = Form.Items.Materials.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If ValueIsFilled(CurrentData.UniqueID) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure MaterialsAfterDeleteRow(Object, Form, Item) Export
	ViewClient_V2.MaterialsAfterDeleteRow(Object, Form);
EndProcedure

#Region MATERIALS_COLUMNS

#Region _ITEM

Procedure MaterialsItemOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.MaterialsItemOnChange(Object, Form, CurrentData);
EndProcedure

Procedure MaterialsItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
	
	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure MaterialsItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	
	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region ITEM_KEY

Procedure MaterialsItemKeyOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.MaterialsItemKeyOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region UNIT

Procedure MaterialsUnitOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.MaterialsUnitOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region QUANTITY

Procedure MaterialsQuantityOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.MaterialsQuantityOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region MATERIALS_TYPE

Procedure MaterialsMaterialTypeOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.MaterialsMaterialTypeOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#EndRegion

#EndRegion
