Procedure EditMultilineText(ItemName, Form, AddInfo = Undefined) Export
	OpenForm("CommonForm.EditMultilineText", New Structure("ItemName", ItemName), Form, , , , New NotifyDescription("OnEditedMultilineTextEnd", ThisObject, New Structure("Form, ItemName", Form, ItemName)), FormWindowOpeningMode.LockOwnerWindow);
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
// Parameters SettingsInfo - structure:
// 	RowData       - collection  - wich add In table
// 	Object        - table owner - any object, wich have table  
// 	Settings      - stucture    
// 		Name      - String	     - table name
// 		Search    - Array		 - column name, for search row
// 		AddNewRow - boolean  - always And New row 
// 	AddInfo       - any		 - any additional info
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

Procedure DynamicListBeforeAddRow(Form, Item, Cancel, Clone, Parent, IsFolder, Parameter, NewObjectFormName) Export
	FillingValues = CommonFormActionsServer.RestoreFillingData(Form.FillingData);
	If TypeOf(FillingValues) = Type("Structure") Then
		Cancel = True;
		OpenForm(NewObjectFormName, New Structure("FillingValues", FillingValues));
	EndIf;
EndProcedure