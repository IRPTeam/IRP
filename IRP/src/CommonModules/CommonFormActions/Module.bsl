
Procedure EditMultilineText(Form, Item, StandardProcessing) Export
	StandardProcessing = False;
	OpenForm("CommonForm.EditMultilineText", New Structure("ItemName", Item.Name), Form, , , ,
		New NotifyDescription("OnEditedMultilineTextEnd", ThisObject, New Structure("Form, ItemName", Form, Item.Name)),
		FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

Procedure OnEditedMultilineTextEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	If AdditionalParameters.Form.Object[AdditionalParameters.ItemName] <> Result Then
		AdditionalParameters.Form.Modified = True;
	EndIf;
	AdditionalParameters.Form.Object[AdditionalParameters.ItemName] = Result;
	DocumentsClient.SetTextOfDescriptionAtForm(AdditionalParameters.Form.Object, AdditionalParameters.Form);
EndProcedure

// Procedure wich add string In table, or add quantity to exist one
// 
// Parameters:
//  SettingsInfo - Structure:
//  	* RowData       - Structure  - wich add In table
//  	* Object        - DocumentObject, CatalogObject - any object, wich have table
// 		* Settings      - Structure
// 		* Name      - String	     - table name
// 		* Search    - Array of String		 - column name, for search row
// 		* AddNewRow - Boolean  - always And New row
//  AddInfo - Undefined - Add info
// 
// Returns:
//  ValueTableRow
Function AddRowAtObjectTable(SettingsInfo, AddInfo = Undefined) Export
	Table = SettingsInfo.Object[SettingsInfo.Settings.Name];

	FillPropertyValues(SettingsInfo.Settings.Search, SettingsInfo.RowData);

	SearchRow = Table.FindRows(SettingsInfo.Settings.Search);

	If SearchRow.Count() Then
		NewStr = SearchRow[0];
		SourceQuantity = NewStr.Quantity;
		FillPropertyValues(NewStr, SettingsInfo.RowData);
		If SettingsInfo.Settings.AddQuantity Then
			NewStr.Quantity = SourceQuantity + SettingsInfo.RowData.Quantity;
		Else
			NewStr.Quantity = SettingsInfo.RowData.Quantity;
		EndIf;
	Else
		NewStr = Table.Add();
		FillPropertyValues(NewStr, SettingsInfo.RowData);
	EndIf;

	If Not ValueIsFilled(NewStr.Key) Then
		NewStr.Key = New UUID();
	EndIf;

	Return NewStr;
EndFunction

Function SettingsAddRowAtObjectTable(AddInfo = Undefined) Export
	NewSettings = New Structure("RowData, Object, Settings, AddInfo", Undefined, Undefined, New Structure(), Undefined);
	NewSettings.Settings.Insert("Name", "");
	NewSettings.Settings.Insert("Search", New Structure());
	NewSettings.Settings.Insert("AddNewRow", False);
	NewSettings.Settings.Insert("DeleteEmpty", True);
	NewSettings.Settings.Insert("AddQuantity", True);
	NewSettings.Settings.Insert("Currency", Undefined);
	// Using for create info string In table 
	NewSettings.Settings.Insert("Formula", "");
	NewSettings.Settings.Insert("MainTableKey", New UUID());
	Return NewSettings;
EndFunction

// for delete
Procedure DynamicListBeforeAddRow(Form, Item, Cancel, Clone, Parent, IsFolder, Parameter, NewObjectFormName) Export
	FillingValues = CommonFormActionsServer.RestoreFillingData(Form.FillingData);
	If TypeOf(FillingValues) = Type("Structure") Then
		Cancel = True;
		OpenForm(NewObjectFormName, New Structure("FillingValues", FillingValues));
	EndIf;
EndProcedure

Procedure AccountStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, ArrayOfFIlters, FillingValues = Undefined) Export	
	StandardProcessing = False;	
	OpeningSettings = DocumentsClient.GetOpenSettingsStructure();
	OpeningSettings.FormName = "Catalog.CashAccounts.Form.ChoiceForm";
	OpeningSettings.FormParameters = New Structure();
	
	OpeningSettings.ArrayOfFilters = New Array();
	OpeningSettings.ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("DeletionMark", False          , DataCompositionComparisonType.Equal));
	OpeningSettings.ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Company"     , Object.Company , DataCompositionComparisonType.Equal));
	
	For Each Filter In ArrayOfFIlters Do
		OpeningSettings.ArrayOfFilters.Add(Filter);
	EndDo;
	
	If FillingValues <> Undefined Then
		OpeningSettings.FormParameters.Insert("FillingData", FillingValues);
	EndIf;
	
	DocumentsClient.SetCurrentRow(Object, Form, Item, OpeningSettings.FormParameters, "Ref");
	DocumentsClient.OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpeningSettings);
EndProcedure

Procedure AccountEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters) Export
	Filters = New Array();
	Filters.Add(DocumentsClient.CreateFilterItem("DeletionMark" , True            , ComparisonType.NotEqual));
	Filters.Add(DocumentsClient.CreateFilterItem("Company"      , Object.Company  , ComparisonType.Equal));
	
	For Each Filter In ArrayOfFilters Do
		Filters.Add(Filter);
	EndDo;
	
	AdditionalParameters = New Structure();
	
	ArrayOfChoiceParameters = New Array();
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.CustomSearchFilter"  , DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters)));
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.AdditionalParameters", DocumentsServer.SerializeArrayOfFilters(AdditionalParameters)));
	
	Item.ChoiceParameters = New FixedArray(ArrayOfChoiceParameters);
EndProcedure

Procedure OpenObjectForm(Field, FieldName, Ref, StandardProcessing) Export
	If Upper(Field.Name) = Upper(FieldName) Then
		StandardProcessing = False;
		If Not ValueIsFilled(Ref) Then
			Return;
		EndIf;
		OpenParameters = New Structure();
		OpenParameters.Insert("Key", Ref);
		OpenForm(CommonFormActionsServer.GetMetadataFullName(Ref) + ".ObjectForm", OpenParameters);
	EndIf;	
EndProcedure

Procedure ExpandTree(Tree, TreeRows) Export
	If Not Tree.Visible Then
		Return;
	EndIf;
	For Each ItemTreeRows In TreeRows Do
		Tree.Expand(ItemTreeRows.GetID());
		ExpandTree(Tree, ItemTreeRows.GetItems());
	EndDo;
EndProcedure

