// @strict-types

#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CreateItems();
	ReadData();
EndProcedure

#EndRegion

#Region FormCommands

&AtClient
Procedure Save(Command)
	SaveData();
	RefreshInterface();
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure

&AtClient
Procedure Reset(Command)
	ReadData();
EndProcedure

#EndRegion

#Region FormItemsEvents

// Functional option item on change.
// 
// Parameters:
//  Item - FormField - Item
&AtClient
Procedure FO_Item_OnChange(Item) Export
	
	AttributeName = Item.Name;
	
	CurrentValue = ThisObject[AttributeName]; // Boolean
	
	_AttributeToFO = GetFormStructure(ThisObject, "AttributeToFO");
	FO_Name = _AttributeToFO[AttributeName]; // String
	
	_AttributeFromFO = GetFormStructure(ThisObject, "AttributeFromFO");
	AttributeNames = _AttributeFromFO[FO_Name]; // Array
	For Each AttributeName In AttributeNames Do
		ThisObject[AttributeName] = CurrentValue;
	EndDo;
	
	SetItemsEnables(ThisObject);
	
EndProcedure

#EndRegion

#Region ServerProcedures

&AtServer
Procedure ReadData()
	
	_AttributeFromFO = GetFormStructure(ThisObject, "AttributeFromFO");

	For Each DataItem In _AttributeFromFO Do
		FO_Name = DataItem.Key;
		AttributeNames = DataItem.Value; // Array
		Try
			FO_Value = FOServer.GetFunctionalOptionValue(FO_Name);
			For Each AttributeName In AttributeNames Do
				ThisObject[AttributeName] = FO_Value;
			EndDo;
		Except
			For Each AttributeName In AttributeNames Do
				Items[AttributeName].Enabled = False;
			EndDo;
		EndTry;
	EndDo;
		
	SetItemsEnables(ThisObject);

EndProcedure

&AtServer
Procedure SaveData()
	
	_AttributeToFO = GetFormStructure(ThisObject, "AttributeToFO");
	For Each DataItem In _AttributeToFO Do
		FO_Value = ThisObject[DataItem.Key]; // Boolean
		FO_Name = DataItem.Value; // String
		FOServer.SetFunctionalOptionValue(FO_Name, FO_Value);
	EndDo;

EndProcedure

&AtServer
Procedure CreateItems()
	
	FillGroupPresence();
	
	FO_Groups = FOServer.GetFOGroups();
	FO_Subordination = FOServer.GetFOSubordination();
	For Each GroupKeyValue In FO_Groups Do
		GroupName = GroupKeyValue.Key;
		NewFormGroup = CreateFormGroup(GroupName);
		GroupItems = GroupKeyValue.Value; // Array of String
		GroupInfo = New Structure("Name, Items", NewFormGroup.Name, New Structure);
		For Each FO_Item In GroupItems Do
			MarkGroupPresence(FO_Item);
			FO_Attribute = CreateAttributeName(FO_Item);
			SubItemItems = New Structure;
			If FO_Subordination.Property(FO_Item) = True Then
				For Each FO_SubItem In FO_Subordination[FO_Item] Do // String
					MarkGroupPresence(FO_SubItem);
					SubItemItems.Insert(CreateAttributeName(FO_SubItem));
				EndDo;
			EndIf;
			GroupInfo.Items.Insert(FO_Attribute, SubItemItems);
		EndDo;
		InsertValueToFormStructure(GroupName, GroupInfo, ThisObject, "GroupsData");
	EndDo;
	
	For Each FO_Item In GetFormArray(ThisObject, "FOWithoutGroup") Do // String
		AddValueToFormArray(CreateAttributeName(FO_Item), ThisObject, "AttributesWithoutGroup");
	EndDo;
	
	BType = New TypeDescription("Boolean");
	NewAttributes = New Array; // Array of FormAttribute
	_AttributesTitles = GetFormStructure(ThisObject, "AttributesTitles");
	For Each AttributeItem In GetFormStructure(ThisObject, "AttributeToFO") Do
		FO_Item_Name = AttributeItem.Key; // String
		NewAttributes.Add(New FormAttribute(FO_Item_Name, BType,, _AttributesTitles[FO_Item_Name]));
	EndDo;
	ChangeAttributes(NewAttributes);
	
	CreateCheckBoxes();

EndProcedure

#EndRegion

#Region Private

// Fill group presence.
//
&AtServer
Procedure FillGroupPresence()
	SetValueListToFormArray(FOServer.GetFOList(), ThisObject, "FOWithoutGroup");
EndProcedure

// Mark group presence.
// 
// Parameters:
//  FO_Name - String - FO name
&AtServer
Procedure MarkGroupPresence(FO_Name)
	WithoutGroup = GetFormArray(ThisObject, "FOWithoutGroup");
	ItemIndex = WithoutGroup.Find(FO_Name);
	If ItemIndex <> Undefined Then
		WithoutGroup.Delete(ItemIndex);
		SetValueListToFormArray(WithoutGroup, ThisObject, "FOWithoutGroup");
	EndIf;
EndProcedure

// Create form group.
// 
// Parameters:
//  GroupName - String - Group name
// 
// Returns:
//  FormGroup - Create form group
&AtServer
Function CreateFormGroup(GroupName)
	GroupSynonym = FOServer.GetFOGroupSynonym(GroupName);
	
	NewFormGroup = Items.Insert("FO_Group_" + GroupName, 
		Type("FormGroup"), Items.GroupForGroups, Items.FO_Group_Other); // FormGroupExtensionForAUsualGroup
	NewFormGroup.Type = FormGroupType.UsualGroup;
	NewFormGroup.Group = ChildFormItemsGroup.Vertical;
	NewFormGroup.Behavior = UsualGroupBehavior.Collapsible;
	NewFormGroup.Title = GroupSynonym;
	NewFormGroup.CollapsedRepresentationTitle = GroupSynonym;
	NewFormGroup.ControlRepresentation = UsualGroupControlRepresentation.Picture;
	
	If GroupName <> "BaseSettings" And GroupName <> "MasterData" Then
		NewFormGroup.Hide();
	EndIf;
	
	Return NewFormGroup;
EndFunction

// Create check boxes.
// 
&AtServer
Procedure CreateCheckBoxes()
	
	For Each GroupData In GetFormStructure(ThisObject, "GroupsData") Do
		GroupName = GroupData.Value["Name"]; // String
		FO_Items = GroupData.Value["Items"]; // Structure
		For Each FO_ItemKeyValue In FO_Items Do
			FO_Attribute = FO_ItemKeyValue.Key;
			CreateCheckBox(FO_Attribute, Items[GroupName], 1);
			FO_SubItems = FO_ItemKeyValue.Value; // Structure
			For Each FO_SubItemKeyValue In FO_SubItems Do
				SubFO_Attribute = FO_SubItemKeyValue.Key;
				CreateCheckBox(SubFO_Attribute, Items[GroupName], 2);
			EndDo;
		EndDo;
	EndDo;
	
	For Each FO_Attribute In GetFormArray(ThisObject, "AttributesWithoutGroup") Do // String
		CreateCheckBox(FO_Attribute, Items.FO_Group_Other, 3);
	EndDo;
	
EndProcedure

// Create check box.
// 
// Parameters:
//  AttributeName - String - Attribute name
//  FormGroup - FormGroup - Form group
//	Level - Number - Level 
&AtServer
Procedure CreateCheckBox(AttributeName, FormGroup, Level)
	NewFormItem = Items.Add(AttributeName, Type("FormField"), FormGroup); // FormFieldExtensionForACheckBoxField 
	NewFormItem.Type = FormFieldType.CheckBoxField;
	NewFormItem.TitleLocation = FormItemTitleLocation.Right;
	NewFormItem.DataPath = AttributeName;
	NewFormItem.SetAction("OnChange", "FO_Item_OnChange");
	
	If Level = 1 Then
		NewFormItem.TitleFont = New Font(,,True);
	ElsIf Level = 2 Then
		_AttributesTitles = GetFormStructure(ThisObject, "AttributesTitles");
		NewFormItem.Title = "  -  " + _AttributesTitles[AttributeName]; 
	EndIf;
EndProcedure

// Create attribute name.
// 
// Parameters:
//  FO_Name - String - Functional option name
// 
// Returns:
//  String - Create attribute name
&AtServer
Function CreateAttributeName(FO_Name)
	
	FO_Attribute = StrReplace("FO_" + New("UUID"), "-", "_");
	
	InsertValueToFormStructure(FO_Attribute, FO_Name, ThisObject, "AttributeToFO");
	
	_AttributeFromFO = GetFormStructure(ThisObject, "AttributeFromFO");
	If _AttributeFromFO.Property(FO_Name) = False Then
		_AttributeFromFO.Insert(FO_Name, New Array);
	EndIf;
	FO_Attributes = _AttributeFromFO[FO_Name]; // Array of String
	FO_Attributes.Add(FO_Attribute);
	
	FO_Title = Metadata.FunctionalOptions[FO_Name].Synonym;
	InsertValueToFormStructure(FO_Attribute, FO_Title, ThisObject, "AttributesTitles");
	
	Return FO_Attribute;
	
EndFunction

// Get form array.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  AttributeName - String - Attribute name
// 
// Returns:
//  Array - Get form array
&AtClientAtServerNoContext
Function GetFormArray(Form, AttributeName)
	
	Data = Form[AttributeName]; // Structure
	If Data = Undefined Then
		Data = New Structure;
		Data.Insert("Data", New Array);
		Form[AttributeName] = Data;
	EndIf;
	
	Return Data["Data"];
	
EndFunction

// Add value to form array.
// 
// Parameters:
//  Value - String, Arbitrary - Value
//  Form - ClientApplicationForm - Form
//  AttributeName - String - Attribute name
&AtClientAtServerNoContext
Procedure AddValueToFormArray(Value, Form, AttributeName)
	
	Data = Form[AttributeName]; // Structure
	If Data = Undefined Then
		Data = New Structure;
		Data.Insert("Data", New Array);
		Form[AttributeName] = Data;
	EndIf;
	
	DataArray = Data["Data"]; // Array of String, Arbitrary
	
	DataArray.Add(Value);
	
EndProcedure

// Set value list to form array.
// 
// Parameters:
//  ValueList - Array of String, Arbitrary - Value
//  Form - ClientApplicationForm - Form
//  AttributeName - String - Attribute name
&AtClientAtServerNoContext
Procedure SetValueListToFormArray(ValueList, Form, AttributeName)
	
	Data = Form[AttributeName]; // Structure
	If Data = Undefined Then
		Data = New Structure;
		Form[AttributeName] = Data;
	EndIf;
	
	Data.Insert("Data", ValueList);
	
EndProcedure

// Get form structure.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  AttributeName - String - Attribute name
// 
// Returns:
//  Structure - Get form structure
&AtClientAtServerNoContext
Function GetFormStructure(Form, AttributeName)
	
	Data = Form[AttributeName]; // Structure
	If Data = Undefined Then
		Data = New Structure;
		Form[AttributeName] = Data;
	EndIf;
	
	Return Data;
	
EndFunction

// Insert value to form structure.
// 
// Parameters:
//  Key - String - Key
//  Value - String, Arbitrary - Value
//  Form - ClientApplicationForm - Form
//  AttributeName - String - Attribute name
&AtClientAtServerNoContext
Procedure InsertValueToFormStructure(Key, Value, Form, AttributeName)
	
	Data = Form[AttributeName]; // Structure
	If Data = Undefined Then
		Data = New Structure;
		Form[AttributeName] = Data;
	EndIf;
	
	Data.Insert(Key, Value);
	
EndProcedure

// Set items enables.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
&AtClientAtServerNoContext
Procedure SetItemsEnables(Form)
	
	For Each GroupData In GetFormStructure(Form, "GroupsData") Do
		FO_Items = GroupData.Value["Items"]; // Structure
		For Each FO_ItemKeyValue In FO_Items Do
			FO_Attribute = FO_ItemKeyValue.Key;
			FO_Value = Form[FO_Attribute]; // Boolean
			FO_SubItems = FO_ItemKeyValue.Value; // Structure
			For Each FO_SubItemKeyValue In FO_SubItems Do
				SubFO_Attribute = FO_SubItemKeyValue.Key;
				Form.Items[SubFO_Attribute].Enabled = FO_Value;
			EndDo;
		EndDo;
	EndDo;

EndProcedure

#EndRegion
