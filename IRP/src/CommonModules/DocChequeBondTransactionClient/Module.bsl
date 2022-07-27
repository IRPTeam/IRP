#Region FORM

Procedure OnOpen(Object, Form, Cancel) Export
	ViewClient_V2.OnOpen(Object, Form, "ChequeBonds");
EndProcedure

#EndRegion

#Region _DATE

Procedure DateOnChange(Object, Form, Item) Export
	ViewClient_V2.DateOnChange(Object, Form, "ChequeBonds");
EndProcedure

#EndRegion

#Region COMPANY

Procedure CompanyOnChange(Object, Form, Item) Export
	ViewClient_V2.CompanyOnChange(Object, Form, "ChequeBonds");
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

#Region CURRENCY

Procedure CurrencyOnChange(Object, Form, Item) Export
	ViewClient_V2.CurrencyOnChange(Object, Form, "ChequeBonds");
EndProcedure

#EndRegion

#Region STATUS
	
Procedure StatusStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;
	
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.FormName = "Catalog.ObjectStatuses.Form.ChoiceForm";
	OpenSettings.ArrayOfFilters = New Array;
	
	If Form.ChequeBondType = PredefinedValue("Enum.ChequeBondTypes.OwnCheque") Then
		Parent = PredefinedValue("Catalog.ObjectStatuses.ChequeBondOutgoing");
	Else
		Parent = PredefinedValue("Catalog.ObjectStatuses.ChequeBondIncoming");
	EndIf;
	
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																	True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Parent", 
																Parent, DataCompositionComparisonType.InHierarchy));
	
	DocumentsClient.StatusStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);																																
EndProcedure						

Procedure StatusEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	EditSettings = DocumentsClient.GetOpenSettingsStructure();

	If Form.ChequeBondType = PredefinedValue("Enum.ChequeBondTypes.OwnCheque") Then
		Parent = PredefinedValue("Catalog.ObjectStatuses.ChequeBondOutgoing");
	Else
		Parent = PredefinedValue("Catalog.ObjectStatuses.ChequeBondIncoming");
	EndIf;
	
	EditSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																		True, DataCompositionComparisonType.NotEqual));
	EditSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Parent", 
																Parent, DataCompositionComparisonType.InHierarchy));	
	
	DocumentsClient.StatusEditTextChange(Object, Form, Item, Text, StandardProcessing, EditSettings);
EndProcedure

#EndRegion

#Region CHEQUE_BONDS

Procedure ItemListBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.ChequeBondsBeforeAddRow(Object, Form, Cancel, Clone);
EndProcedure

Procedure ItemListAfterDeleteRow(Object, Form, Item) Export
	ViewClient_V2.ChequeBondsAfterDeleteRow(Object, Form);
EndProcedure

#Region CHEQUE_BONDS_COLUMNS

#EndRegion

#EndRegion
