#Region FORM

Procedure OnOpen(Object, Form, Cancel) Export
	ViewClient_V2.OnOpen(Object, Form, "Productions");
EndProcedure

Procedure AfterWriteAtClient(Object, Form, WriteParameters) Export
	Return;
EndProcedure

#EndRegion

#Region _DATE

Procedure DateOnChange(Object, Form, Item) Export
	ViewClient_V2.DateOnChange(Object, Form, "Productions");
EndProcedure

#EndRegion

#Region COMPANY

Procedure CompanyOnChange(Object, Form, Item) Export
	ViewClient_V2.CompanyOnChange(Object, Form, "Productions");
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

#Region BUSINESS_UNIT

Procedure BusinessUnitOnChange(Object, Form, Item) Export
	ViewClient_V2.BusinessUnitOnChange(Object, Form, "Productions");
EndProcedure

#EndRegion

#Region PLANNING_PERIOD

Procedure PlanningPeriodOnChange(Object, Form, Item) Export
	ViewClient_V2.PlanningPeriodOnChange(Object, Form, "Productions");
EndProcedure

#EndRegion

//#Region ITEM_LIST
//
//Procedure ItemListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
//	ViewClient_V2.ItemListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing);
//EndProcedure
//
//Procedure ItemListBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
//	ViewClient_V2.ItemListBeforeAddRow(Object, Form, Cancel, Clone);
//EndProcedure
//
//Procedure ItemListBeforeDeleteRow(Object, Form, Item, Cancel) Export
//	RowIDInfoClient.ItemListBeforeDeleteRow(Object, Form, Item, Cancel);
//EndProcedure
//
//Procedure ItemListAfterDeleteRow(Object, Form, Item) Export
//	ViewClient_V2.ItemListAfterDeleteRow(Object, Form);
//EndProcedure
//
//#Region ITEM_LIST_COLUMNS
//
//#Region _ITEM
//
//Procedure ItemListItemOnChange(Object, Form, Item, CurrentData = Undefined) Export
//	ViewClient_V2.ItemListItemOnChange(Object, Form, CurrentData);
//EndProcedure
//
//Procedure ItemListItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
//	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
//
//	OpenSettings.ArrayOfFilters = New Array();
//	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
//		DataCompositionComparisonType.NotEqual));
//	
//	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ItemType.Type", PredefinedValue("Enum.ItemTypes.Service"),
//		DataCompositionComparisonType.Equal));
//	
//	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
//EndProcedure
//
//Procedure ItemListItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
//	ArrayOfFilters = New Array();
//	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
//	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ItemType.Type", PredefinedValue("Enum.ItemTypes.Service"), ComparisonType.Equal));
//	
//	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
//EndProcedure
//
//#EndRegion
//
//#Region ITEM_KEY
//
//Procedure ItemListItemKeyOnChange(Object, Form, Item, CurrentData = Undefined) Export
//	ViewClient_V2.ItemListItemKeyOnChange(Object, Form, CurrentData);
//EndProcedure
//
//#EndRegion
//
//#Region BILL_OF_MATERIALS
//
//Procedure ItemListBillOfMaterialsOnChange(Object, Form, Item, CurrentData = Undefined) Export
//	ViewClient_V2.ItemListBillOfMaterialsOnChange(Object, Form, CurrentData);
//	
//	If CurrentData = Undefined Then
//		CurrentData = Form.Items.ItemList.CurrentData;
//	EndIf;
//	
//	MaterialsData = DocWorkOrderServer.GetMaterialsForWork(CurrentData.BillOfMaterials, Form.UUID);
//	ViewClient_V2.MaterialsLoad(Object, Form, MaterialsData.Address, CurrentData.Key, MaterialsData.GroupColumns);
//EndProcedure
//
//#EndRegion
//
//#Region UNIT
//
//Procedure ItemListUnitOnChange(Object, Form, Item, CurrentData = Undefined) Export
//	ViewClient_V2.ItemListUnitOnChange(Object, Form, CurrentData);
//EndProcedure
//
//#EndRegion
//
//#Region QUANTITY
//
//Procedure ItemListQuantityOnChange(Object, Form, Item, CurrentData = Undefined) Export
//	ViewClient_V2.ItemListQuantityOnChange(Object, Form, CurrentData);
//EndProcedure
//
//#EndRegion
//
//#Region PRICE_TYPE
//
//Procedure ItemListPriceTypeOnChange(Object, Form, Item, CurrentData = Undefined) Export
//	ViewClient_V2.ItemListPriceTypeOnChange(Object, Form, CurrentData);
//EndProcedure
//
//#EndRegion
//
//#Region PRICE
//
//Procedure ItemListPriceOnChange(Object, Form, Item, CurrentData = Undefined) Export
//	ViewClient_V2.ItemListPriceOnChange(Object, Form, CurrentData);
//EndProcedure
//
//#EndRegion
//
//#Region NET_AMOUNT
//
//Procedure ItemListNetAmountOnChange(Object, Form, Item, CurrentData = Undefined) Export
//	ViewClient_V2.ItemListNetAmountOnChange(Object, Form, CurrentData);
//EndProcedure
//
//#EndRegion
//
//#Region TOTAL_AMOUNT
//
//Procedure ItemListTotalAmountOnChange(Object, Form, Item, CurrentData = Undefined) Export
//	ViewClient_V2.ItemListTotalAmountOnChange(Object, Form, CurrentData);
//EndProcedure
//
//#EndRegion
//
//#Region TAX_AMOUNT
//
//Procedure ItemListTaxAmountOnChange(Object, Form, Item, CurrentData = Undefined) Export
//	ViewClient_V2.ItemListTaxAmountOnChange(Object, Form, CurrentData);
//EndProcedure
//
//#EndRegion
//
//#Region DONT_CALCULATE_ROW
//
//Procedure ItemListDontCalculateRowOnChange(Object, Form, Item, CurrentData = Undefined) Export
//	ViewClient_V2.ItemListDontCalculateRowOnChange(Object, Form, CurrentData);
//EndProcedure
//
//#EndRegion
//
//#Region TAX_RATE
//
//Procedure ItemListTaxValueOnChange(Object, Form, Item, CurrentData = Undefined) Export
//	ViewClient_V2.ItemListTaxRateOnChange(Object, Form);
//EndProcedure
//
//#EndRegion
//
//#EndRegion
//
//#EndRegion
