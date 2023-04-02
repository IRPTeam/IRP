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

#Region UPDATE_CURRENT_QUANTITY

Procedure UpdateCurrentQuantity(Object, Form) Export
	ViewClient_V2.ExecuteCommand(Object, Form, "Productions", "Command_UpdateCurrentQuantity");
EndProcedure
	
#EndRegion

#Region PRODUCTIONS

Procedure ProductionsSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	If Not Form.ReadOnly Then
		Return;
	EndIf;
	CurrentData = Form.Items.Productions.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CommonFormActions.OpenObjectForm(Field, "ProductionsItem", CurrentData.Item, StandardProcessing);
	CommonFormActions.OpenObjectForm(Field, "ProductionsItemKey", CurrentData.ItemKey, StandardProcessing);
	CommonFormActions.OpenObjectForm(Field, "ProductionsUnit", CurrentData.Unit, StandardProcessing);
	CommonFormActions.OpenObjectForm(Field, "ProductionsBillOfMaterials", CurrentData.BillOfMaterials, StandardProcessing);
EndProcedure

Procedure ProductionsBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.ProductionsBeforeAddRow(Object, Form, Cancel, Clone);
EndProcedure

Procedure ProductionsBeforeDeleteRow(Object, Form, Item, Cancel) Export
	Return;
EndProcedure

Procedure ProductionsAfterDeleteRow(Object, Form, Item) Export
	ViewClient_V2.ProductionsAfterDeleteRow(Object, Form);
EndProcedure

#Region PRODUCTIONS_COLUMNS

#Region _ITEM

Procedure ProductionsItemOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ProductionsItemOnChange(Object, Form, CurrentData);
EndProcedure

Procedure ProductionsItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
	
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ItemType.Type", PredefinedValue("Enum.ItemTypes.Service"),
		DataCompositionComparisonType.NotEqual));
	
	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ProductionsItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ItemType.Type", PredefinedValue("Enum.ItemTypes.Service"), ComparisonType.NotEqual));
	
	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region ITEM_KEY

Procedure ProductionsItemKeyOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ProductionsItemKeyOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region BILL_OF_MATERIALS

Procedure ProductionsBillOfMaterialsOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ProductionsBillOfMaterialsOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region UNIT

Procedure ProductionsUnitOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ProductionsUnitOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region QUANTITY

Procedure ProductionsQuantityOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ProductionsQuantityOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#EndRegion

#EndRegion
