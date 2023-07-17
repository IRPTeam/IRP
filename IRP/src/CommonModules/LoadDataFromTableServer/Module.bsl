// @strict-types

#Region FORM

// Create commands.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  ObjectMetadata - MetadataObject - Object Metadata
//  FormType - EnumRef.FormTypes - Form type
//  AddInfo - Undefined - Add info
Procedure CreateCommands(Form, ObjectMetadata, FormType, AddInfo = Undefined) Export
	
	If Not FormType = Enums.FormTypes.ObjectForm 
			Or Not Form.Commands.Find("LoadDataFromTable") = Undefined 
			Or Not Form.Items.Find("ItemListLoadDataFromTable") = Undefined Then
		Return;
	EndIf;
	
	ItemListForm = Form.Items.Find("ItemList"); // FormTable
	If ItemListForm = Undefined Then
		Return;
	EndIf;
	
	If Form.Commands.Find("LoadDataFromTable") = Undefined Then
		CommandForm = Form.Commands.Add("LoadDataFromTable");
		CommandForm.Representation = ButtonRepresentation.Picture;
		CommandForm.Picture = PictureLib.SpreadsheetShowGrid;
		CommandForm.Action = "LoadDataFromTable";
		R().Property("LDT_Button_Title",   CommandForm.Title);
		R().Property("LDT_Button_ToolTip", CommandForm.ToolTip);
	EndIf;
	
	If Form.Items.Find("ItemListLoadDataFromTable") = Undefined Then
		CommandButton = Form.Items.Add("ItemListLoadDataFromTable", Type("FormButton"), ItemListForm.CommandBar); // FormButton
		CommandButton.CommandName = "LoadDataFromTable";
	EndIf;
	
	FormAddAttributes = Form.GetAttributes();
	FormAttribute = New FormAttribute("_FieldsForLoadData", New TypeDescription(""));
	If FormAddAttributes.Find(FormAttribute) = Undefined Then
		NewAttributes = New Array; // Array of FormAttribute
		NewAttributes.Add(FormAttribute);
		Form.ChangeAttributes(NewAttributes);
		
		FieldsForLoadData = New Structure;
		For Each TableChildItem In Form.Items.ItemList.ChildItems Do
			If TableChildItem.Type = FormFieldType.InputField And TableChildItem.Visible Then
				DataPathParts = StrSplit(TableChildItem.DataPath, ".");
				TableName = DataPathParts[1];
				AttributeName = DataPathParts[2];
				TableAttributes = ObjectMetadata["TabularSections"][TableName]["Attributes"]; // MetadataObjectCollection
				ItemAttribute = TableAttributes.Find(AttributeName); // MetadataObjectAttribute
				If Not ItemAttribute = Undefined Then
					ItemDescription = New Structure;
					ItemDescription.Insert("Name", AttributeName);
					ItemDescription.Insert("Synonym", ItemAttribute.Synonym);
					ItemDescription.Insert("Type", ItemAttribute.Type);
					FieldsForLoadData.Insert(AttributeName, ItemDescription); 
				EndIf;
			EndIf;
		EndDo;
		Form["_FieldsForLoadData"] = FieldsForLoadData;
	EndIf;
	
	If ObjectMetadata = Metadata.Documents.PriceList Then
		If Form.Items.Find("ItemKeyListLoadDataFromTable") = Undefined Then
			CommandButton = Form.Items.Add(
				"ItemKeyListLoadDataFromTable", Type("FormButton"), Form.Items.ItemKeyList.CommandBar); // FormButton
			CommandButton.CommandName = "LoadDataFromTable";
		EndIf;
		
		FormAttribute = New FormAttribute("_FieldsForLoadData_ItemKey", New TypeDescription(""));
		If FormAddAttributes.Find(FormAttribute) = Undefined Then
			NewAttributes = New Array; // Array of FormAttribute
			NewAttributes.Add(FormAttribute);
			Form.ChangeAttributes(NewAttributes);
			
			FieldsForLoadData = New Structure;
			For Each TableChildItem In Form.Items.ItemKeyList.ChildItems Do
				If TableChildItem.Type = FormFieldType.InputField And TableChildItem.Visible Then
					DataPathParts = StrSplit(TableChildItem.DataPath, ".");
					TableName = DataPathParts[1];
					AttributeName = DataPathParts[2];
					TableAttributes = ObjectMetadata["TabularSections"][TableName]["Attributes"]; // MetadataObjectCollection
					ItemAttribute = TableAttributes.Find(AttributeName); // MetadataObjectAttribute
					If Not ItemAttribute = Undefined Then
						ItemDescription = New Structure;
						ItemDescription.Insert("Name", AttributeName);
						ItemDescription.Insert("Synonym", ItemAttribute.Synonym);
						ItemDescription.Insert("Type", ItemAttribute.Type);
						FieldsForLoadData.Insert(AttributeName, ItemDescription); 
					EndIf;
				EndIf;
			EndDo;
			Form["_FieldsForLoadData_ItemKey"] = FieldsForLoadData;
		EndIf;		
	EndIf;
	
EndProcedure

#EndRegion