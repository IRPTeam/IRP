#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	If Not Parameters.Property("MetadataName", MetadataName) 
			OR IsBlankString(MetadataName) Then
		Cancel = True;
	EndIf;
	
	ClassifierData = FillingFromClassifiers.GetClassifierData(MetadataName);	
	If ClassifierData = Undefined OR Not ClassifierData.Count() Then
		Items.GroupPages.CurrentPage = Items.PageEmpty;
		Items.FormCreateItem.Enabled = False;
		Return;
	EndIf;
	
	Items.GroupPages.CurrentPage = Items.PageData;
	
	// Create form attributes (columns)
	AttributeArray = New Array();
	AttributesList.Clear();
	For Each KeyAndValue In ClassifierData[0] Do
    	NewAttribute = New FormAttribute(KeyAndValue.Key, New TypeDescription("String"), "ClassifierTable");
    	AttributeArray.Add(NewAttribute);
    	
    	AttributesList.Add(KeyAndValue.Key);
	EndDo;
	ChangeAttributes(AttributeArray);
	 
	 // Create form items 	
    For Each AttributesListElement In AttributesList Do
    	NewField = Items.Add("ClassifierTable" + AttributesListElement.Value
							, Type("FormField")
							, Items.ClassifierTable);
		NewField.Type = FormFieldType.InputField;
		NewField.DataPath = "ClassifierTable." + AttributesListElement.Value;
		NewField.ReadOnly = True;
	EndDo;
	
	// Fill table
	For Each ClassifierStructure In ClassifierData Do
		NewRow = ClassifierTable.Add();
		FillPropertyValues(NewRow, ClassifierStructure);
		For Each AttributesListElement In AttributesList Do
			If TypeOf(ClassifierStructure[AttributesListElement.Value]) = Type("Structure") Then
				For Each KeyAndValue In ClassifierStructure[AttributesListElement.Value] Do
					NewRow[AttributesListElement.Value] = KeyAndValue.Value;
					Break;
				EndDo;
			EndIf;
		EndDo; 
	EndDo;
	
EndProcedure

&AtClient
Procedure BeforeClose(Cancel, Exit, WarningText, StandardProcessing)
	If TypeOf(FormOwner) = Type("ClientApplicationForm") 
			AND FormOwner.Items.Find("List") <> Undefined 
			AND TypeOf(FormOwner.Items.List) = Type("FormTable") Then
		FormOwner.Items.List.Refresh();
	EndIf;
EndProcedure

#EndRegion

&AtClient
Procedure ClassifierTableSelection(Item, RowSelected, Field, StandardProcessing)
	If Items.ClassifierTable.CurrentData = Undefined Then
		Return;
	EndIf;
	
	CreateItemFromClassifierRow(Items.ClassifierTable.CurrentData);
EndProcedure

&AtClient
Procedure CreateItem(Command)
	If Items.ClassifierTable.CurrentData = Undefined Then
		Return;
	EndIf;
	
	CreateItemFromClassifierRow(Items.ClassifierTable.CurrentData);
EndProcedure

&AtClient
Procedure CreateItemFromClassifierRow(ClassifierRow)
	// TODO: check existing object
	
	NewItem = FillingFromClassifiers.CreateCatalogItemFromClassifier(MetadataName, 
							AttributesList[0].Value, 
							ClassifierRow[AttributesList[0].Value]);
	If ValueIsFilled(NewItem) Then
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R()["InfoMessage_002"], NewItem)
				, , ThisObject);
	EndIf;
EndProcedure