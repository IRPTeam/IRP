#Region FormEvents

&AtClient
Procedure AfterWrite(WriteParameters)
	Notify("UpdateAvailableSpecificationsByItem", New Structure(), ThisObject);
	Notify("UpdateAffectPricingMD5", New Structure(), ThisObject);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	SavedDataStructure = GetSavedData();
	// Fill cheking
	HaveError = False;

	If Object.Type = Enums.SpecificationType.Bundle And Not ValueIsFilled(Object.ItemBundle) Then
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_010, R().Form_026), "Object.ItemBundle",
			ThisObject);
		HaveError = True;
	EndIf;

	For Each Field In SavedDataStructure.Fields Do
		If Items[Field.Key].AutoMarkIncomplete And Not ValueIsFilled(ThisObject[Field.Value.Item]) Then
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_010, R().Form_027), Field.Value.Item,
				ThisObject);
			HaveError = True;
		EndIf;
		If Not ThisObject[Field.Value.Table.Name].Count() Then
			CommonFunctionsClientServer.ShowUsersMessage(R().Error_011, Field.Value.Table.Name, ThisObject);
			HaveError = True;
		EndIf;
		RowIndex = 0;
		For Each Row In ThisObject[Field.Value.Table.Name] Do
			DimensionStr = New Structure();
			For Each Column In Field.Value.Table.Columns Do
				If Items[Column.FormName].AutoMarkIncomplete And Not ValueIsFilled(Row[Column.Name]) Then
					MessageText = "";
					If Column.Name = "Quantity" Then
						MessageText = StrTemplate(R().Error_010, R().Form_003);
					Else
						MessageText = StrTemplate(R().Error_010, String(ThisObject[Column.OwnerName]));
					EndIf;
					CommonFunctionsClientServer.ShowUsersMessage(MessageText, Field.Value.Table.Name + "[" + RowIndex
						+ "]." + Column.Name, ThisObject[Field.Value.Table.Name]);
					HaveError = True;
				EndIf;
				If Column.Name <> "Quantity" Then
					DimensionStr.Insert(Column.Name, Row[Column.Name]);
				EndIf;
			EndDo;
			// checking for duplicate lines
			If ThisObject[Field.Value.Table.Name].FindRows(DimensionStr).Count() > 1
				And Field.Value.Table.Columns.Count() Then
				MessageText = R().Error_013;
				CommonFunctionsClientServer.ShowUsersMessage(MessageText, Field.Value.Table.Name + "[" + RowIndex
					+ "]." + Field.Value.Table.Columns[0].Name, ThisObject[Field.Value.Table.Name]);
				HaveError = True;
			EndIf;
			RowIndex = RowIndex + 1;
		EndDo;
	EndDo;

	If HaveError Then
		Cancel = True;
		Return;
	EndIf;
	
	// Save data
	CurrentObject.DataSet.Clear();
	CurrentObject.DataQuantity.Clear();
	For Each Field In SavedDataStructure.Fields Do
		For Each Row In ThisObject[Field.Value.Table.Name] Do
			NewRowQuantity = CurrentObject.DataQuantity.Add();
			NewRowQuantity.Key = New UUID();
			NewRowQuantity.Quantity = Row["Quantity"];
			If Field.Value.Table.Columns.Count() <= 1 Then
				NewRow = CurrentObject.DataSet.Add();
				NewRow.Key = NewRowQuantity.Key;
				NewRow.Item = ThisObject[Field.Value.Item];
			Else
				For Each Column In Field.Value.Table.Columns Do
					If Column.Name = "Quantity" Then
						Continue;
					EndIf;
					NewRow = CurrentObject.DataSet.Add();
					NewRow.Key = NewRowQuantity.Key;
					NewRow.Item = ThisObject[Field.Value.Item];
					NewRow.Attribute = ThisObject[Column.OwnerName];
					NewRow.Value = Row[Column.Name];
				EndDo;
			EndIf;
		EndDo;
	EndDo;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);

	If Not ValueIsFilled(Object.Type) Then
		Object.Type = Enums.SpecificationType.Bundle;
	EndIf;

	DrawForm();

	If Items.GroupMainPages.ChildItems.Count() Then
		Items.GroupMainPages.CurrentPage = Items.GroupMainPages.ChildItems[0];
	EndIf;
	SetVisible();
EndProcedure

#EndRegion

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure SetVisible()
	Items.GroupAddNewPage.Visible = Object.Type = Enums.SpecificationType.Bundle;
	Items.ItemBundle.Visible = Object.Type = Enums.SpecificationType.Bundle;
	SavedDataStructure = GetSavedData();
	For Each Row In SavedDataStructure.Commands Do
		ThisObject.Items[Row.Value.ButtonName].Visible = SavedDataStructure.Commands.Count() > 1;
	EndDo;
EndProcedure

&AtServer
Procedure DrawForm()
	If Object.DataSet.Count() Then
		RestoreData();
	Else
		CreatePage();
	EndIf;
EndProcedure

#Region FormDrawer

&AtServer
Procedure RestoreData()

	ValueTable_Item = Object.DataSet.Unload();
	ValueTable_Item.GroupBy("Item");

	For Each Row_Item In ValueTable_Item Do
		PageInfo = CreatePage();
		SavedDataStructure = GetSavedData();
		ThisObject[SavedDataStructure.Fields[PageInfo.Field].Item] = Row_Item.Item;
		ItemOnChangeAtServer(PageInfo.Field);
		SavedDataStructure = GetSavedData();

		DataQuantity = GetDataQuantity(Row_Item.Item);
		For Each Row In DataQuantity Do
			NewRow = ThisObject[SavedDataStructure.Fields[PageInfo.Field].Table.Name].Add();
			NewRow.Quantity = Row.Quantity;
			For Each Column In SavedDataStructure.Fields[PageInfo.Field].Table.Columns Do
				If Column.Name = "Quantity" Then
					Continue;
				EndIf;
				NewRow[Column.Name] = GetAttributeValue(Row.Key, ThisObject[Column.OwnerName]);
			EndDo;
		EndDo;

	EndDo;
EndProcedure

&AtServer
Function GetDataQuantity(Item)
	TableOfResult = New ValueTable();
	TableOfResult.Columns.Add("Quantity");
	TableOfResult.Columns.Add("Key");

	TableOfKeys = Object.DataSet.Unload(New Structure("Item", Item));
	TableOfKeys.GroupBy("Key");

	For Each Row In TableOfKeys Do
		For Each RowQuantity In Object.DataQuantity.Unload(New Structure("Key", Row.Key), "Key, Quantity") Do
			NewRow = TableOfResult.Add();
			NewRow.Quantity = RowQuantity.Quantity;
			NewRow.Key = RowQuantity.Key;
		EndDo;
	EndDo;
	TableOfResult.GroupBy("Quantity, Key");
	Return TableOfResult;
EndFunction

&AtServer
Function GetAttributeValue(Key, Attribute)
	TableOfValues = Object.DataSet.Unload(New Structure("Key, Attribute", Key, Attribute));
	If TableOfValues.Count() Then
		Return TableOfValues[0].Value;
	Else
		Return Undefined;
	EndIf;
EndFunction

&AtClient
Procedure GroupMainPagesOnCurrentPageChange(Item, CurrentPage)
	If CurrentPage = Items.GroupAddNewPage Then
		CreatePage();
	EndIf;
EndProcedure

&AtServer
Function CreatePage()

	SavedDataStructure = GetSavedData();
	
	// Page
	NewPage = Items.Insert(GetUniqueName("Page"), Type("FormGroup"), Items.GroupMainPages, Items.GroupAddNewPage);
	NewPage.Type = FormGroupType.Page;
	NewPage.Title = R().Form_001;

	Items.GroupMainPages.CurrentPage = NewPage;
	
	// HorizontalGroup
	NewHorizontalGroup = Items.Add(GetUniqueName("HorizontalGroup"), Type("FormGroup"), NewPage);
	NewHorizontalGroup.Type = FormGroupType.UsualGroup;
	NewHorizontalGroup.Representation = UsualGroupRepresentation.None;
	NewHorizontalGroup.Group = ChildFormItemsGroup.AlwaysHorizontal;
	NewHorizontalGroup.ShowTitle = False;
	
	// CommAnd - DeletePage
	NewCommAnd = ThisObject.Commands.Add(GetUniqueName("DeletePage"));
	NewCommand.Action = "DeletePage";
	NewCommand.ModifiesStoredData = True;
	
	// Button - DeletePage
	NewButton = Items.Add(GetUniqueName("DeleteButton"), Type("FormButton"), NewHorizontalGroup);
	NewButton.CommandName = NewCommand.Name;
	NewButton.Picture = PictureLib.Delete;
	NewButton.Representation = ButtonRepresentation.PictureAndText;
	NewButton.Title = R().Form_002;
	
	// Attribute - Item
	ArrayOfAttributes = New Array();

	MapOfTypeDescriptions = New Map();
	MapOfTypeDescriptions.Insert(Enums.SpecificationType.Bundle, New TypeDescription("CatalogRef.Items"));
	MapOfTypeDescriptions.Insert(Enums.SpecificationType.Set, New TypeDescription("CatalogRef.ItemTypes"));

	MapOfFieldTitle = New Map();
	MapOfFieldTitle.Insert(Enums.SpecificationType.Bundle, R().Form_027);
	MapOfFieldTitle.Insert(Enums.SpecificationType.Set, R().Form_028);

	NewAttribute = New FormAttribute(GetUniqueName("Item"), MapOfTypeDescriptions.Get(Object.Type), "",
		MapOfFieldTitle.Get(Object.Type), True);
	ArrayOfAttributes.Add(NewAttribute);
	ThisObject.ChangeAttributes(ArrayOfAttributes);
	
	// Field - Item
	NewField = Items.Add(GetUniqueName("ItemField"), Type("FormField"), NewHorizontalGroup);
	NewField.Type = FormFieldType.InputField;
	NewField.DataPath = NewAttribute.Name;
	NewField.AutoMarkIncomplete = True;
	NewField.SetAction("OnChange", "ItemOnChange");
	
	// Table
	ArrayOfAttributes = New Array();
	NewTable = New FormAttribute(GetUniqueName("AttributesTable"), New TypeDescription("ValueTable"), "", "", True);
	ArrayOfAttributes.Add(NewTable);

	NewColumn = New FormAttribute("Quantity", Metadata.DefinedTypes.typeQuantity.Type, NewTable.Name, R().Form_003);
	ArrayOfAttributes.Add(NewColumn);
	ThisObject.ChangeAttributes(ArrayOfAttributes);
	
	// FormTable
	NewFormTable = Items.Add(GetUniqueName("FormTable"), Type("FormTable"), NewPage);
	NewFormTable.DataPath = NewTable.Name;

	NewFormColumn = Items.Add(NewFormTable.Name + "Quantity", Type("FormField"), NewFormTable);
	NewFormColumn.Type = FormFieldType.InputField;
	NewFormColumn.DataPath = NewTable.Name + "." + NewColumn.Name;
	NewFormColumn.AutoMarkIncomplete = True;

	Table = New Structure("Name, FormTableName, Columns", NewTable.Name, NewFormTable.Name, New Array());
	ColumnStructure = New Structure();
	ColumnStructure.Insert("Name", NewColumn.Name);
	ColumnStructure.Insert("DataPath", NewTable.Name + "." + NewColumn.Name);
	ColumnStructure.Insert("OwnerName", Undefined);
	ColumnStructure.Insert("FormName", NewFormColumn.Name);
	Table.Columns.Add(ColumnStructure);

	SavedDataStructure.Fields.Insert(NewField.Name, New Structure("Item, Page, Table", NewAttribute.Name, NewPage.Name,
		Table));

	SavedDataStructure.Commands.Insert(NewCommand.Name, New Structure("ButtonName, ItemField", NewButton.Name,
		NewField.Name));

	SetSavedData(SavedDataStructure);

	Return New Structure("Field", NewField.Name);
EndFunction

&AtClient
Procedure ItemOnChange(Item)
	ItemOnChangeAtServer(Item.Name);
EndProcedure

&AtServer
Procedure ItemOnChangeAtServer(ItemName)
	SavedDataStructure = GetSavedData();

	Item = ThisObject[SavedDataStructure.Fields[ItemName].Item];

	Items[SavedDataStructure.Fields[ItemName].Page].Title = ?(ValueIsFilled(Item), String(Item), R().Form_001);

	Table = SavedDataStructure.Fields[ItemName].Table;
	// Delete/Create column
	ArrayOfAttributes = New Array();
	For Each Column In Table.Columns Do
		ArrayOfAttributes.Add(Column.DataPath);
		Items.Delete(Items[Column.FormName]);
		If Column.OwnerName <> Undefined Then
			ArrayOfAttributes.Add(Column.OwnerName);
		EndIf;
	EndDo;

	ThisObject.ChangeAttributes( , ArrayOfAttributes);

	Table.Columns.Clear();
	ChoiceParametersMap = New Map();
	ArrayOfAttributes = New Array();

	If ValueIsFilled(Item) Then

		For Each i In GetItemAttributes(Item).FormAttributesInfo Do
			ColumnName = Table.Name + i.Name;
			ColumnOwnerName = Table.Name + i.Name_owner;
			ColumnStructure = New Structure();
			ColumnStructure.Insert("Name", ColumnName);
			ColumnStructure.Insert("DataPath", Table.Name + "." + ColumnName);
			ColumnStructure.Insert("OwnerName", ColumnOwnerName);
			ColumnStructure.Insert("FormName", "");
			Table.Columns.Add(ColumnStructure);

			NewColumn = New FormAttribute(ColumnName, i.Type, Table.Name, i.Title);
			ArrayOfAttributes.Add(NewColumn);

			NewColumnOwner = New FormAttribute(ColumnOwnerName, i.Type_owner);
			ArrayOfAttributes.Add(NewColumnOwner);

			ChoiceParametersMap.Insert(ColumnName, New Structure(Table.Name + i.Name_owner, i.Ref));
		EndDo;

	EndIf;

	QuantityColumn = New FormAttribute("Quantity", Metadata.DefinedTypes.typeQuantity.Type, Table.Name, R().Form_003);
	ArrayOfAttributes.Add(QuantityColumn);

	ColumnStructure = New Structure();
	ColumnStructure.Insert("Name", QuantityColumn.Name);
	ColumnStructure.Insert("DataPath", Table.Name + "." + QuantityColumn.Name);
	ColumnStructure.Insert("OwnerName", Undefined);
	ColumnStructure.Insert("FormName", "");
	Table.Columns.Add(ColumnStructure);

	ThisObject.ChangeAttributes(ArrayOfAttributes);
	
	// Form columns	
	For Each i In ChoiceParametersMap Do
		For Each j In ChoiceParametersMap[i.Key] Do
			ThisObject[j.Key] = j.Value;
		EndDo;
	EndDo;

	For Each Column In Table.Columns Do
		NewFormColumn = Items.Add(GetUniqueName(Column.Name), Type("FormField"), Items[Table.FormTableName]);
		NewFormColumn.Type = FormFieldType.InputField;
		NewFormColumn.DataPath = Table.Name + "." + Column.Name;
		NewFormColumn.AutoMarkIncomplete = True;

		Column.FormName = NewFormColumn.Name;

		If ChoiceParametersMap.Get(Column.Name) <> Undefined Then
			ArrayOfChoiceParameters = New Array();
			For Each i In ChoiceParametersMap[Column.Name] Do
				ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.Owner", i.Value));
			EndDo;
			NewFormColumn.ChoiceParameters = New FixedArray(ArrayOfChoiceParameters);
		EndIf;
	EndDo;

	SetSavedData(SavedDataStructure);
EndProcedure

&AtClient
Procedure DeletePage(Command) Export
	DeletePageAtServer(Command.Name);
EndProcedure

&AtServer
Procedure DeletePageAtServer(CommandName)
	SavedDataStructure = GetSavedData();
	Page = Items[SavedDataStructure.Fields[SavedDataStructure.Commands[CommandName].ItemField].Page];
	Items.Delete(Page);
	SavedDataStructure.Fields.Delete(SavedDataStructure.Commands[CommandName].ItemField);
	SavedDataStructure.Commands.Delete(CommandName);
	SetSavedData(SavedDataStructure);
	SetVisible();
EndProcedure

&AtServer
Function GetUniqueName(NamePart)
	Return NamePart + StrReplace(String(New UUID()), "-", "");
EndFunction

&AtServer
Function GetItemAttributes(Item)
	AvailableAttributes = Undefined;
	If Object.Type = Enums.SpecificationType.Bundle Then
		If ValueIsFilled(Item) And ValueIsFilled(Item.ItemType) Then
			AvailableAttributes = Item.ItemType.AvailableAttributes;
		EndIf;
	ElsIf Object.Type = Enums.SpecificationType.Set Then
		If ValueIsFilled(Item) Then
			AvailableAttributes = Item.AvailableAttributes;
		EndIf;
	Else
		AvailableAttributes = Undefined;
	EndIf;

	If AvailableAttributes <> Undefined Then
		ArrayOfAttributes = New Array();
		For Each Row In AvailableAttributes Do
			AttributeStructure = New Structure("Attribute, InterfaceGroup", Row.Attribute, Undefined);
			ArrayOfAttributes.Add(AttributeStructure);
		EndDo;

		Return AddAttributesAndPropertiesServer.FormAttributes(ArrayOfAttributes);
	Else
		Return Undefined;
	EndIf;
EndFunction

&AtServer
Function GetSavedData()
	If ValueIsFilled(ThisObject.DynamicDataForm) Then
		SavedDataStructure = CommonFunctionsServer.DeserializeXMLUseXDTO(ThisObject.DynamicDataForm);
	Else
		SavedDataStructure = New Structure();
		SavedDataStructure.Insert("Fields", New Structure());
		SavedDataStructure.Insert("Commands", New Structure());
	EndIf;
	Return SavedDataStructure;
EndFunction

&AtServer
Procedure SetSavedData(SavedDataStructure)
	ThisObject.DynamicDataForm = CommonFunctionsServer.SerializeXMLUseXDTO(SavedDataStructure);
EndProcedure

&AtClient
Procedure TypeOnChange(Item)
	Object.DataSet.Clear();
	Object.DataQuantity.Clear();
	Object.ItemBundle = Undefined;
	SavedDataStructure = GetSavedData();
	For Each CommAnd In SavedDataStructure.Commands Do
		DeletePageAtServer(Command.Key);
	EndDo;
	DrawForm();
	SetVisible();
EndProcedure

#EndRegion

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

#EndRegion