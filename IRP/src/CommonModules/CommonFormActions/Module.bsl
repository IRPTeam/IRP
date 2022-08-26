
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
	
	// ????
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
	
	ArrayOfChoiceParameters = New Array();
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.CustomSearchFilter", DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters)));
	Item.ChoiceParameters = New FixedArray(ArrayOfChoiceParameters);
EndProcedure

//Procedure OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpeningSettings)
//	ChoiceForm = GetForm(OpeningSettings.FormName, OpeningSettings.FormParameters, Item, Form.UUID, , Form.URL);
//	For Each Filter In OpeningSettings.ArrayOfFilters Do
//		DocumentsClient.AddFilterToChoiceForm(ChoiceForm, Filter.FieldName, Filter.Value, Filter.ComparisonType);
//	EndDo;
//	ChoiceForm.Open();
//EndProcedure
//
//Procedure SetCurrentRow(Object, Form, Item, FormParameters, AttributeName) Export
//	If CommonFunctionsClientServer.ObjectHasProperty(Object, Item.Name) Then
//		FormParameters.Insert("CurrentRow", Object[Item.Name]);
//	Else // item placed in tabular section, for example ItemList.ItemKey
//		TabularSection = Left(Item.Name, StrLen(Item.Name) - StrLen(AttributeName));
//		If CommonFunctionsClientServer.ObjectHasProperty(Form.Items, TabularSection) Then
//			CurrentData = Form.Items[TabularSection].CurrentData;
//			If CurrentData <> Undefined And CommonFunctionsClientServer.ObjectHasProperty(CurrentData, AttributeName) Then
//				If Not ValueIsFilled(CurrentData[AttributeName]) 
//					And CommonFunctionsClientServer.ObjectHasProperty(CurrentData, "LineNumber") Then
//					RowIndex = CurrentData.LineNumber - 1;
//					PreviousRow = ?(RowIndex > 0, Object[TabularSection][RowIndex - 1], CurrentData);
//					FormParameters.Insert("CurrentRow", PreviousRow[AttributeName]);
//				Else
//					FormParameters.Insert("CurrentRow", CurrentData[AttributeName]);
//				EndIf;
//			EndIf;
//		EndIf;
//	EndIf;
//EndProcedure

//Function CreateFilterItem(FieldName, Value, ComparisonType)
//	FilterStructure = New Structure();
//	FilterStructure.Insert("FieldName", FieldName);
//	FilterStructure.Insert("Value", Value);
//	FilterStructure.Insert("ComparisonType", ComparisonType);
//	Return FilterStructure;
//EndFunction
//
//Procedure AddFilterToChoiceForm(ChoiceForm, PathToField, Value, ComparisonType)
//	FilterItem = ChoiceForm.List.Filter.Items.Add(Type("DataCompositionFilterItem"));
//	FilterItem.LeftValue = New DataCompositionField(PathToField);
//	FilterItem.RightValue = Value;
//	FilterItem.ComparisonType = ComparisonType;
//EndProcedure
//
//Function CreateListByValues(Value1 = Undefined, Value2 = Undefined, Value3 = Undefined)
//	ListOfValues = New ValueList();
//	If Value1 <> Undefined Then
//		ListOfValues.Add(Value1);
//	EndIf;
//	
//	If Value2 <> Undefined Then
//		ListOfValues.Add(Value2);
//	EndIf;
//	
//	If Value3 <> Undefined Then
//		ListOfValues.Add(Value3);
//	EndIf;
//	Return ListOfValues;
//EndFunction	
	
