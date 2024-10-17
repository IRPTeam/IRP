// @strict-types

#Region Events

// On create at server.
// 
// Parameters:
//  Form - See Catalog.ItemKeys.Form.ItemForm
//  GroupNameForPlacement - String - Group name for placement
//  Prefix - String -
//  AddInfo - Undefined - Add info
Procedure OnCreateAtServer(Form, GroupNameForPlacement = "", Prefix= "", AddInfo = Undefined) Export
	CreateFormControls(Form, GroupNameForPlacement, Prefix, AddInfo);
EndProcedure

// Before write at server.
// 
// Parameters:
//  Form - See Catalog.ItemKeys.Form.ItemForm
//  Cancel - Boolean - Cancel
//  CurrentObject - CatalogObject.ItemKeys - Current object
//  WriteParameters - Structure - Write parameters
//  Prefix - String -
//  AddInfo - Undefined - Add info
Procedure BeforeWriteAtServer(Form, Cancel, CurrentObject, WriteParameters, Prefix = "", AddInfo = Undefined) Export

	If CurrentObject.Metadata().TabularSections.Find(Prefix + "AddAttributes") = Undefined Then
		Return;
	EndIf;

	CurrentObject.AddAttributes.Clear();
	//@skip-check invocation-parameter-type-intersect
	FormInfo = GetObjectInfo(Form.Object, Prefix);
	If Not FormInfo.Property("Form") Then
		FormInfo.Insert("Form", Form);
	EndIf;

	AddAttributeAndPropertySetName = AddAttributeAndPropertySetName(FormInfo.Ref, AddInfo);
	ObjectAttributes = ObjectAttributes(FormInfo, AddAttributeAndPropertySetName, AddInfo);
	RequiredFiler = New Structure("Required", True);
	RequiredAttributesArray = AllAttributesArrayByFilter(CurrentObject, Prefix, RequiredFiler);
	CancelValue = False;

	For Each Row In ObjectAttributes Do
		AttributeInfo = AttributeAndPropertyInfo(Row, AddInfo);
		RequiredAttributeResult = RequiredAttributesArray.Find(Row.Attribute);
		//@skip-check dynamic-access-method-not-found
		If AttributeInfo.Collection And AttributeInfo.isTag Then
			//@skip-check dynamic-access-method-not-found
			Parts = StrSplit(AttributeInfo.PathForTag, ".");
			CopyTable = CurrentObject[Parts[0]].Unload(); // See Document.SalesOrder.ItemList
			CopyTable.GroupBy(Parts[1]);
			For Each Attr In CopyTable.UnloadColumn(Parts[1]) Do
				If Not ValueIsFilled(Attr) Then
					Continue;
				EndIf;
				AddAttributes = CurrentObject[Prefix + "AddAttributes"]; // See Catalog.ItemKeys.AddAttributes
				NewAttribute = AddAttributes.Add(); 
				NewAttribute.Property = AttributeInfo.Ref;
				//@skip-check statement-type-change
				NewAttribute.Value = Attr;
			EndDo;
			
		ElsIf AttributeInfo.Collection And Form[AttributeInfo.Name].Count() Then
			//@skip-check dynamic-access-method-not-found
			For Each Attr In Form[AttributeInfo.Name].UnloadValues() Do // Characteristic.AddAttributeAndProperty
				AddAttributes = CurrentObject[Prefix + "AddAttributes"]; // See Catalog.ItemKeys.AddAttributes
				NewAttribute = AddAttributes.Add(); 
				NewAttribute.Property = AttributeInfo.Ref;
				NewAttribute.Value = Attr;
			EndDo;
		ElsIf Not AttributeInfo.Collection AND ValueIsFilled(Form[AttributeInfo.Name]) Then
			NewAttribute = CurrentObject.AddAttributes.Add();
			NewAttribute.Property = AttributeInfo.Ref;
			//@skip-check statement-type-change
			NewAttribute.Value = Form[AttributeInfo.Name];
		Else
			If RequiredAttributeResult <> Undefined Then
				UserMessageText = StrTemplate(R().Error_010, RequiredAttributesArray[RequiredAttributeResult]);
				CommonFunctionsClientServer.ShowUsersMessage(UserMessageText, AttributeInfo.Name, Form.Object);
				CancelValue = True;
			EndIf;
		EndIf;
		If RequiredAttributeResult <> Undefined Then
			RequiredAttributesArray.Delete(RequiredAttributeResult);
		EndIf;
	EndDo;

	For Each RequiredAttribute In RequiredAttributesArray Do
		UserMessageText = StrTemplate(R().Error_010, RequiredAttribute);
		CommonFunctionsClientServer.ShowUsersMessage(UserMessageText, AttributeInfo.Name, Form.Object);
		CancelValue = True;
	EndDo;

	If CancelValue Then
		Cancel = True;
	EndIf;
EndProcedure

#EndRegion

#Region WorkWithForm

Procedure CreateFormControls(Form, GroupNameForPlacement = "", Prefix = "", AddInfo = Undefined) Export
	//@skip-check invocation-parameter-type-intersect
	FormInfo = GetObjectInfo(Form.Object, Prefix);
	ClearForm(Form);

	SavedData = GetSavedData();

	AddAttributeAndPropertySetName = AddAttributeAndPropertySetName(FormInfo.Ref, AddInfo);
	ObjectAttributes = ObjectAttributes(FormInfo, AddAttributeAndPropertySetName, AddInfo);

	FormGroups = FormGroups(ObjectAttributes, AddInfo);
	CreatedFormGroups = CreateFormGroups(Form, FormGroups, AddInfo);
	SavedData.FormGroups = ExtractProperty(CreatedFormGroups, "Name");

	FormAttributes = FormAttributes(ObjectAttributes, AddInfo);
	SavedData.FormAttributes = ExtractProperty(FormAttributes.Attributes, "Name");
	SavedData.ArrayOfAttributesInfo = FillArrayOfAttributesInfo(FormAttributes);

	Form.ChangeAttributes(FormAttributes.Attributes);

	DefaultAttributeValues = GetDefaultAttributeValues(FormInfo);

	For Each Row In ObjectAttributes Do
		
		ArrayOfExistAttributes = FormInfo.AddAttributes.FindRows(New Structure("Property", Row.Attribute));
		If ArrayOfExistAttributes.Count() Then
			AttributeInfo = AttributeAndPropertyInfo(Row, AddInfo);
			If AttributeInfo.isTag Then
				Continue;
			EndIf;
			If Row.Collection Then
				For Each RowAttr In ArrayOfExistAttributes Do
					//@skip-check dynamic-access-method-not-found
					Form[AttributeInfo.Name].Add(RowAttr.Value);
				EndDo;
			Else
				Form[AttributeInfo.Name] = ArrayOfExistAttributes[0].Value;
			EndIf;

		ElsIf FormInfo.IsNew Then
			ArrayOfDefaultAttributes = DefaultAttributeValues.FindRows(New Structure("AttributeRef", Row.Attribute));
			If ArrayOfDefaultAttributes.Count() Then
				AttributeInfo = AttributeAndPropertyInfo(Row, AddInfo);
				Form[AttributeInfo.Name] = ArrayOfDefaultAttributes[0].Value;
			EndIf;
		EndIf;
	EndDo;

	For Each Row In FormAttributes.FormAttributesInfo Do
		Form[Row.Name_owner] = Row.Ref;
	EndDo;

	CreatedFormItemFields = CreateFormItemFields(Form, GroupNameForPlacement, FormAttributes.FormAttributesInfo, AddInfo);
	SavedData.FormItemFields = ExtractProperty(CreatedFormItemFields, "Name");
	//@skip-check property-return-type
	Form.SavedData = CommonFunctionsServer.SerializeXMLUseXDTO(SavedData);
EndProcedure

// Clear form.
// 
// Parameters:
//  Form - See Catalog.ItemKeys.Form.ItemForm
Procedure ClearForm(Form)
	If Not ServiceSystemServer.ObjectHasAttribute("SavedData", Form) Then
		Return;
	EndIf;
	
	//@skip-check property-return-type, invocation-parameter-type-intersect
	SavedData = CommonFunctionsServer.DeserializeXMLUseXDTO(Form.SavedData); // See GetSavedData
	
	// Fields
	For Each Name In SavedData.FormItemFields Do
		Form.Items.Delete(Form.Items[Name]);
	EndDo;
	
	// Groups
	For Each Name In SavedData.FormGroups Do
		Form.Items.Delete(Form.Items[Name]);
	EndDo;
	
	// Attributes
	Form.ChangeAttributes( , SavedData.FormAttributes);
EndProcedure

Function CreateFormGroups(Form, FormGroupsInfo, AddInfo = Undefined) Export
	ArrayOfFormGroups = New Array();
	For Each GroupInfo In FormGroupsInfo Do
		FoundedParent = Form.Items.Find(GroupInfo.ParentName);
		If FoundedParent = Undefined Then
			GroupParent = Form.Items.Add(GroupInfo.ParentName, Type("FormGroup"));
			GroupParent.Type = FormGroupType.UsualGroup;
			GroupParent.Group = ChildFormItemsGroup.Vertical;
			GroupParent.ThroughAlign = ThroughAlign.Use;
		Else
			GroupParent = FoundedParent;
		EndIf;
		NewFormGroup = Form.Items.Find(GroupInfo.Name);
		If NewFormGroup = Undefined Then
			NewFormGroup = Form.Items.Add(GroupInfo.Name, Type("FormGroup"), GroupParent);
		EndIf;
		NewFormGroup.Type = FormGroupType.UsualGroup;
		NewFormGroup.Group = GroupInfo.ChildFormItemsGroup;
		NewFormGroup.Behavior = GroupInfo.Behavior;
		If NewFormGroup.Behavior = UsualGroupBehavior.Collapsible Then
			NewFormGroup.Hide();
		EndIf;
		NewFormGroup.Title = GroupInfo.Title;
		NewFormGroup.ThroughAlign = ThroughAlign.Use;
		ArrayOfFormGroups.Add(NewFormGroup);
	EndDo;
	Return ArrayOfFormGroups;
EndFunction

Function CreateFormItemFields(Form, GroupNameForPlacement, FormAttributesInfo, AddInfo = Undefined) Export
	ArrayOfFormElements = New Array();
	For Each AttrInfo In FormAttributesInfo Do
		If AttrInfo.isURL = True Then
			CreateItemsForURL(Form, GroupNameForPlacement, AttrInfo, ArrayOfFormElements);
			Continue;
		EndIf;
		
		NewFormElement = Form.Items.Add(AttrInfo.Name, Type("FormField"), GetFormItemParent(Form,
			GroupNameForPlacement, AttrInfo));

		NewFormElement.DataPath = AttrInfo.Path;
		Types = New Array();
		Types.Add(Type("Boolean"));
		If AttrInfo.Type = New TypeDescription(Types) Then
			NewFormElement.Type = FormFieldType.CheckBoxField;
		Else
			NewFormElement.Type = FormFieldType.InputField;
			NewFormElement.ClearButton = True;
			ArrayOfChoiceParameters = New Array();
			ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.Owner", AttrInfo.Ref));
			NewFormElement.ChoiceParameters = New FixedArray(ArrayOfChoiceParameters);

			//@skip-check module-attachable-event-handler-name
			NewFormElement.SetAction("StartChoice", "AddAttributeStartChoice");
			If AttrInfo.Collection Then
				//@skip-check property-return-type
				Form[AttrInfo.Name].ValueType = AttrInfo.Type;
			EndIf; 
			NewFormElement.MultiLine = AttrInfo.Multiline;
		EndIf;

		ArrayOfFormElements.Add(NewFormElement);
	EndDo;
	Return ArrayOfFormElements;
EndFunction

Function GetFormItemParent(Form, GroupNameForPlacement, AttrInfo)
	If ValueIsFilled(GroupNameForPlacement) Then
		Return Form.Items[GroupNameForPlacement];
	EndIf;

	FoundedParent = Form.Items.Find(AttrInfo.ParentName);
	If FoundedParent = Undefined Then
		FoundedParent = Form.Items.Add(AttrInfo.ParentName, Type("FormGroup"));
		FoundedParent.Type = FormGroupType.UsualGroup;
		FoundedParent.Group = ChildFormItemsGroup.Vertical;
		FoundedParent.ThroughAlign = ThroughAlign.Use;
	EndIf;

	Return FoundedParent;
EndFunction

// Form attributes.
// 
// Parameters:
//  ObjectAttributes - See ReduceObjectAttributes
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Structure - Form attributes:
// * Attributes - Array Of FormAttribute - 
// * FormAttributesInfo - Array Of See AttributeAndPropertyInfo - 
Function FormAttributes(ObjectAttributes, AddInfo = Undefined) Export
	Attributes = New Array();
	FormAttributesInfo = New Array();
	For Each Row In ObjectAttributes Do
		
		If Not IsBlankString(Row.PathForTag) Then
			Continue; // Do now show on form tag attributes
		EndIf;
		
		AttributeInfo = AttributeAndPropertyInfo(Row, AddInfo);
		
		If AttributeInfo.Collection Then
			Type = New TypeDescription("ValueList");
		Else	
			Type = AttributeInfo.Type;
		EndIf;
		
		Attributes.Add(New FormAttribute(AttributeInfo.Name, Type, , AttributeInfo.Title,	AttributeInfo.StoredData));
		Attributes.Add(New FormAttribute(AttributeInfo.Name_owner, AttributeInfo.Type_owner, , AttributeInfo.Title_owner, AttributeInfo.StoredData_owner));
		FormAttributesInfo.Add(AttributeInfo);
	EndDo;

	Attributes.Add(New FormAttribute("SavedData", New TypeDescription("String"), , "SavedData", False));
		
	Result = New Structure;
	Result.Insert("Attributes", Attributes);
	Result.Insert("FormAttributesInfo", FormAttributesInfo);
	Return Result;
EndFunction

// Form groups.
// 
// Parameters:
//  ObjectAttributes - See ReduceObjectAttributes
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Array Of See GroupInfo
Function FormGroups(ObjectAttributes, AddInfo = Undefined) Export
	Groups = New Array();
	InterfaceGroups = New Array();
	For Each AttributeRow In ObjectAttributes Do
		If ValueIsFilled(AttributeRow.InterfaceGroup) Then
			FoundedGroup = InterfaceGroups.Find(AttributeRow.InterfaceGroup);
			If FoundedGroup = Undefined Then
				AttributeGroupInfo = GroupInfo(AttributeRow.InterfaceGroup, AddInfo);
				Groups.Add(AttributeGroupInfo);
				InterfaceGroups.Add(AttributeRow.InterfaceGroup);
			EndIf;
		EndIf;
	EndDo;
	Return Groups;
EndFunction

#EndRegion

#Region Filters

Procedure FillTableOfAvailableAttributesBy_AllItems(TableOfAvailableAttributes, ArrayOfCollection, FormInfo, AddAttributeAndPropertySetName, AllItems, AddInfo = Undefined)
	Template = GetDCSTemplate(AddAttributeAndPropertySetName, AddInfo);
	ExternalDataSet = FormInfo.ExternalDataSet;
	For Each Row In AllItems Do
		If Row.IsConditionSet Then
			Settings = Row.Condition.Get(); // DataCompositionSettings
			NewFilter = Settings.Filter.Items.Add(Type("DataCompositionFilterItem"));
			LeftValue = New DataCompositionField("Ref");
			NewFilter.LeftValue = LeftValue;
			NewFilter.Use = True;
			NewFilter.ComparisonType = DataCompositionComparisonType.Equal;
			NewFilter.RightValue = FormInfo.Ref;

			RefsByConditions = GetRefsByCondition(Template, Settings, ExternalDataSet, AddInfo);

			If RefsByConditions.Count() Then
				ArrayOfCollection.Add(Row);
			EndIf;
			
		Else
			If FormInfo.Metadata = Metadata.Catalogs.ItemKeys Then
				// get add attributes from ItemType (tabular section AvailableAttributes)
				If ValueIsFilled(FormInfo.Item) And ValueIsFilled(FormInfo.ItemType) Then
					Filter = New Structure("Attribute", Row.Attribute);
					FoundedRows = FormInfo.ItemType.AvailableAttributes.FindRows(Filter);
					If FoundedRows.Count() Then
						NewRowOfAvailableAttributes = TableOfAvailableAttributes.Add();
						//@skip-check property-return-type
						NewRowOfAvailableAttributes.RowOfAllItems = Row;
						//@skip-check property-return-type
						NewRowOfAvailableAttributes.LineNumber = FoundedRows[0].LineNumber;
					EndIf;
				EndIf;
			Else
				ArrayOfCollection.Add(Row);
			EndIf;
		EndIf;
	EndDo;

EndProcedure

#EndRegion

#Region Contruct

// Attribute and property info.
// 
// Parameters:
//  AttributePropertyRow - CatalogTabularSectionRow.AddAttributeAndPropertySets.Attributes - Attribute property row
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Structure - Attribute and property info:
// * Ref - ChartOfCharacteristicTypesRef.AddAttributeAndProperty - 
// * Name - String - 
// * Type - TypeDescription - 
// * isURL - Boolean - 
// * Path - String - 
// * isTag - Boolean - 
// * PathForTag - String - 
// * Title - String - 
// * StoredData - Boolean - 
// * ParentName - String - 
// * Name_owner - String - 
// * Type_owner - TypeDescription - 
// * Path_owner - String - 
// * Title_owner - String - 
// * StoredData_owner - Boolean - 
// * Multiline - Boolean -
// * Collection - Boolean -
Function AttributeAndPropertyInfo(AttributePropertyRow, AddInfo = Undefined) Export
	Result = New Structure();

	Name = AttributeName(AttributePropertyRow.Attribute, AddInfo);
	Result.Insert("Ref", AttributePropertyRow.Attribute);
	Result.Insert("Name", Name);
	Result.Insert("Type", AttributePropertyRow.Attribute.ValueType);
	Result.Insert("isURL", AttributePropertyRow.Attribute.isURL);
	Result.Insert("Multiline", AttributePropertyRow.Attribute.Multiline);
	Result.Insert("Collection", AttributePropertyRow.Collection);
	Result.Insert("Path", Name);
	Result.Insert("Title", String(AttributePropertyRow.Attribute));
	Result.Insert("StoredData", True);
	Result.Insert("isTag", Not IsBlankString(AttributePropertyRow.PathForTag));
	Result.Insert("PathForTag", AttributePropertyRow.PathForTag);
	If ValueIsFilled(AttributePropertyRow.InterfaceGroup) Then
		ParentName = "_" + StrReplace(String(AttributePropertyRow.InterfaceGroup.UUID()), "-", "");
	Else
		ParentName = "GroupMainAttributes";
	EndIf;

	Result.Insert("ParentName", ParentName);

	Name_owner = AttributeOwnerName(AttributePropertyRow.Attribute, AddInfo);
	Result.Insert("Name_owner", Name_owner);
	ArrayOfOwnerType = New Array();
	ArrayOfOwnerType.Add(TypeOf(AttributePropertyRow.Attribute));

	Result.Insert("Type_owner", New TypeDescription(ArrayOfOwnerType));
	Result.Insert("Path_owner", Name_owner);
	Result.Insert("Title_owner", String(AttributePropertyRow.Attribute) + "_owner");
	Result.Insert("StoredData_owner", False);

	Return Result;
EndFunction

// Group info.
// 
// Parameters:
//  Group - CatalogRef.InterfaceGroups - Group
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Structure - Group info:
// * Name - String - 
// * ParentName - String - 
// * Title - String - 
// * Behavior - UsualGroupBehavior -
// * ChildFormItemsGroup - ChildFormItemsGroup - 
// * Collapsed - Boolean - 
Function GroupInfo(Group, AddInfo = Undefined) Export
	Result = New Structure();
	Name = "_" + StrReplace(String(Group.UUID()), "-", "");
	Result.Insert("Name", Name);
	Result.Insert("ParentName", "Group" + Group.FormPosition);
	Result.Insert("Title", String(Group));
	Result.Insert("Behavior", UsualGroupBehavior[MetadataInfo.EnumNameByRef(Group.Behavior)]);
	Result.Insert("ChildFormItemsGroup", ChildFormItemsGroup[MetadataInfo.EnumNameByRef(Group.ChildFormItemsGroup)]);
	Result.Insert("Collapsed", Group.Collapsed);
	Return Result;
EndFunction

// Get form info.
// 
// Parameters:
//  Object - CatalogObject.ItemKeys
//  Prefix - String -
// 
// Returns:
//  Structure - Get form info:
// * Ref - DocumentRefDocumentName -
// * AddAttributes - See Document.SalesInvoice.AddAttributes
// * Item - CatalogRef.Items -
// * ItemType - CatalogRef.ItemTypes - 
// * IsNew - Boolean - 
// * ExternalDataSet - ValueTable - :
// ** ItemType - CatalogRef.ItemTypes - 
// ** Ref - CatalogRef.Items - 
Function GetObjectInfo(Object, Prefix)
	FormInfo = New Structure();
	FormInfo.Insert("Ref", Object.Ref);
	FormInfo.Insert("Metadata", Object.Ref.Metadata());
	FormInfo.Insert("IsNew", FormInfo.Ref.IsEmpty());
	FormInfo.Insert("AddAttributes", Object[Prefix + "AddAttributes"]);

	If FormInfo.Metadata = Metadata.Catalogs.ItemKeys 
		Or FormInfo.Metadata = Metadata.Catalogs.PriceKeys Then
		FormInfo.Insert("Item", Object.Item);
		FormInfo.Insert("ItemType", ?(Object.Item = Undefined, Undefined, Object.Item.ItemType));
	EndIf;

	ExternalDataSet = New ValueTable();
	If FormInfo.Metadata = Metadata.Catalogs.Items Then
		ExternalDataSet.Columns.Add("ItemType", New TypeDescription("CatalogRef.ItemTypes"));
		ExternalDataSet.Columns.Add("Ref", New TypeDescription("CatalogRef.Items"));
		NewRow = ExternalDataSet.Add();
		//@skip-check statement-type-change, property-return-type
		NewRow.ItemType = Object.ItemType;
		//@skip-check statement-type-change
		NewRow.Ref = FormInfo.Ref;
	EndIf;
	FormInfo.Insert("ExternalDataSet", ExternalDataSet);

	Return FormInfo;
EndFunction

// Add attribute and property set ref.
// 
// Parameters:
//  Ref - AnyRef - Ref
//  AddInfo - Undefined - Add info
// 
// Returns:
//  CatalogRef.AddAttributeAndPropertySets - Add attribute and property set ref
Function AddAttributeAndPropertySetRef(Ref, AddInfo = Undefined) Export
	SetName = AddAttributeAndPropertySetName(Ref, AddInfo);
	Return Catalogs.AddAttributeAndPropertySets[SetName];
EndFunction

// Add attribute and property set name.
// 
// Parameters:
//  Ref - AnyRef - Ref 
//  AddInfo - Undefined - Add info
// 
// Returns:
//  String - Add attribute and property set name
Function AddAttributeAndPropertySetName(Ref, AddInfo = Undefined) Export
	Return StrReplace(Ref.Metadata().FullName(), ".", "_");
EndFunction

// Object attributes.
// 
// Parameters:
//  FormInfo - See GetObjectInfo
//  AddAttributeAndPropertySetName - String - Add attribute and property set name
//  AddInfo - Undefined - Add info
// 
// Returns:
//  See ReduceObjectAttributes
Function ObjectAttributes(FormInfo, AddAttributeAndPropertySetName, AddInfo = Undefined) Export
	AllItems = Catalogs.AddAttributeAndPropertySets[AddAttributeAndPropertySetName].Attributes;
	Return ReduceObjectAttributes(FormInfo, AllItems, AddAttributeAndPropertySetName, AddInfo);
EndFunction

// Object properties.
// 
// Parameters:
//  AddAttributeAndPropertySetName - String - Add attribute and property set name
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Array Of CatalogTabularSectionRow.AddAttributeAndPropertySets.Attributes
Function ObjectProperties(AddAttributeAndPropertySetName, AddInfo = Undefined) Export
	Return Catalogs.AddAttributeAndPropertySets[AddAttributeAndPropertySetName].Properties;
EndFunction

// Get attribute info.
// 
// Returns:
//  Structure - Get attribute info:
// * Attribute - ChartOfCharacteristicTypesRef.AddAttributeAndProperty - 
// * InterfaceGroup - Undefined - 
// * Collection - Boolean - 
// * PathForTag - String - 
Function GetAttributeInfo() Export
	AttributeStructure = New Structure;
	AttributeStructure.Insert("Attribute", ChartsOfCharacteristicTypes.AddAttributeAndProperty.EmptyRef());
	AttributeStructure.Insert("InterfaceGroup", Undefined);
	AttributeStructure.Insert("Collection", False);
	AttributeStructure.Insert("PathForTag", "");
Return AttributeStructure;
EndFunction

#EndRegion

#Region CalculateMD5

// Get affect pricing MD5.
// 
// Parameters:
//  Item - CatalogRef.Items - Item
//  ItemType - CatalogRef.ItemTypes - Item type
//  AddAttributes - ValueTable - Add attributes
// 
// Returns:
//  String - Get affect pricing MD5
Function GetAffectPricingMD5(Item, ItemType, AddAttributes) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	AddAttributes.Property,
	|	AddAttributes.Value
	|INTO tmp
	|FROM
	|	&AddAttributes AS AddAttributes
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Property AS Property,
	|	tmp.Value AS Value,
	|	&Item AS Item
	|FROM
	|	Catalog.ItemTypes.AvailableAttributes AS ItemTypesAvailableAttributes
	|		INNER JOIN tmp AS tmp
	|		ON tmp.Property = ItemTypesAvailableAttributes.Attribute
	|		AND ItemTypesAvailableAttributes.AffectPricing
	|		AND ItemTypesAvailableAttributes.Ref = &ItemType";
	Query.SetParameter("ItemType", ItemType);
	Query.SetParameter("Item", Item);
	Query.SetParameter("AddAttributes", AddAttributes);
	QueryResult = Query.Execute();
	Return GetMD5ByAddAttributes(QueryResult.Unload());
EndFunction

// Get MD5 by add attributes.
// 
// Parameters:
//  AddAttributes - ValueTable - Add attributes:
//  * Property - ChartOfCharacteristicTypesRef.AddAttributeAndProperty -
//  * Value - AnyRef, String -
//  * Item - CatalogRef.Items
// 
// Returns:
//  String - Get m d5 by add attributes
Function GetMD5ByAddAttributes(AddAttributes) Export
	If Not AddAttributes.Count() Then
		Return "";
	EndIf;

	ValueTable = New ValueTable();
	ValueTable.Columns.Add("Property", New TypeDescription("UUID"));
	ValueTable.Columns.Add("Value");
	ValueTable.Columns.Add("Item", New TypeDescription("UUID"));

	For Each Row In AddAttributes Do
		NewRow = ValueTable.Add();
		NewRow.Property = Row.Property.UUID();
		NewRow.Item = Row.Item.UUID();
		If CommonFunctionsServer.IsPrimitiveValue(Row.Value) Then
			//@skip-check property-return-type
			NewRow.Value = Row.Value;
		Else
			//@skip-check property-return-type
			NewRow.Value = Row.Value.UUID();
		EndIf;
	EndDo;
	ValueTable.Sort("Property, Value, Item");

	Return CommonFunctionsServer.GetMD5(ValueTable);
EndFunction

// Get MD5 by specification.
// 
// Parameters:
//  AddAttributes - ValueTable - Add attributes:
//  * Property - ChartOfCharacteristicTypesRef.AddAttributeAndProperty -
//  * Value - AnyRef, String -
//  * Item - CatalogRef.Items - 
//  * Quantity - Number -
// 
// Returns:
//  String - Get m d5 by specification
Function GetMD5BySpecification(AddAttributes) Export
	If Not AddAttributes.Count() Then
		Return "";
	EndIf;

	ValueTable = New ValueTable();
	ValueTable.Columns.Add("Property", New TypeDescription("UUID"));
	ValueTable.Columns.Add("Value");
	ValueTable.Columns.Add("Item", New TypeDescription("UUID"));
	ValueTable.Columns.Add("Quantity", New TypeDescription("Number"));

	For Each Row In AddAttributes Do
		NewRow = ValueTable.Add();
		NewRow.Property = Row.Property.UUID();
		NewRow.Item = Row.Item.UUID();
		NewRow.Quantity = Row.Quantity;
		If CommonFunctionsServer.IsPrimitiveValue(Row.Value) Then
			//@skip-check property-return-type
			NewRow.Value = Row.Value;
		Else
			//@skip-check property-return-type
			NewRow.Value = Row.Value.UUID();
		EndIf;
	EndDo;
	ValueTable.Sort("Property, Value, Quantity");

	Return CommonFunctionsServer.GetMD5(ValueTable);
EndFunction

#EndRegion

#Region Getter

// Get saved data.
// 
// Returns:
//  Structure - Get saved data:
// * FormGroups - See ExtractProperty 
// * FormAttributes - See ExtractProperty
// * FormItemFields - See ExtractProperty
// * ArrayOfAttributesInfo - See FillArrayOfAttributesInfo 
Function GetSavedData()
	SavedData = New Structure;
	SavedData.Insert("FormGroups", New Array);
	SavedData.Insert("FormAttributes", New Array); 
	SavedData.Insert("FormItemFields", New Array); 
	SavedData.Insert("ArrayOfAttributesInfo", New Array);
	Return SavedData
EndFunction

// Get default attribute values.
// 
// Parameters:
//  FormInfo - See GetObjectInfo
// 
// Returns:
//  ValueTable - Get default attribute values:
//  * Value - Arbitrary -
Function GetDefaultAttributeValues(FormInfo)
	Query = New Query();
	Query.Text =
	"SELECT
	|	tmp.UserOrGroup AS UserOrGroup,
	|	tmp.MetadataObject AS MetadataObject,
	|	tmp.AttributeName AS AttributeName,
	|	tmp.KindOfAttribute AS KindOfAttribute,
	|	tmp.Value AS Value
	|INTO tmp
	|FROM
	|	&UserSettings AS tmp
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AddAttributeAndProperty.Ref AS AttributeRef,
	|	tmp.UserOrGroup,
	|	tmp.MetadataObject,
	|	tmp.AttributeName,
	|	tmp.KindOfAttribute,
	|	tmp.Value
	|FROM
	|	ChartOfCharacteristicTypes.AddAttributeAndProperty AS AddAttributeAndProperty
	|		INNER JOIN tmp AS tmp
	|		ON AddAttributeAndProperty.UniqueID = tmp.AttributeName
	|		AND tmp.KindOfAttribute = VALUE(Enum.KindsOfAttributes.Additional)";
	FilterParameters = New Structure();
	FilterParameters.Insert("MetadataObject", FormInfo.Metadata);
	UserSettings = UserSettingsServer.GetUserSettings(SessionParameters.CurrentUser, FilterParameters);
	Query.SetParameter("UserSettings", UserSettings);
	Return Query.Execute().Unload();
EndFunction

// Get add attribute value of ref by ID.
// 
// Parameters:
//  UniqueID - String - Unique ID
//  ObjectRef - AnyRef -  Object ref
// 
// Returns:
//  Undefined - Get add attribute value of ref by ID
Function GetAddAttributeValueOfRefByID(UniqueID, ObjectRef) Export

	ReturnValue = Undefined;

	//@skip-warning
	AddAttributeRef = ChartsOfCharacteristicTypes.AddAttributeAndProperty.FindByAttribute("UniqueID", UniqueID);
	If Not AddAttributeRef.IsEmpty() Then

		PropertyFilter = New Structure("Property", AddAttributeRef);
		FoundedRows = ObjectRef.AddAttributes.FindRows(PropertyFilter);
		If FoundedRows.Count() Then
			FoundedRow = FoundedRows[0];
			ReturnValue = FoundedRow.Value;
		EndIf;

	EndIf;

	Return ReturnValue;

EndFunction

// Get add property value of ref by ID.
// 
// Parameters:
//  UniqueID - String - Unique ID
//  ObjectRef - AnyRef -  Object ref
// 
// Returns:
//  Undefined - Get add property value of ref by ID
Function GetAddPropertyValueOfRefByID(UniqueID, ObjectRef) Export

	ReturnValue = Undefined;

	//@skip-warning
	AddPropertyRef = ChartsOfCharacteristicTypes.AddAttributeAndProperty.FindByAttribute("UniqueID", UniqueID);
	If Not AddPropertyRef.IsEmpty() Then

		Query = New Query();
		Query.Text = "SELECT
					 |	AddProperties.Value
					 |FROM
					 |	InformationRegister.AddProperties AS AddProperties
					 |WHERE
					 |	AddProperties.Object = &Object
					 |	AND AddProperties.Property = &Property";
		Query.SetParameter("Object", ObjectRef);
		Query.SetParameter("Property", AddPropertyRef);

		QueryExecution = Query.Execute();
		If Not QueryExecution.IsEmpty() Then

			QuerySelection = QueryExecution.Select();
			QuerySelection.Next();
			//@skip-check property-return-type, statement-type-change
			ReturnValue = QuerySelection.Value;

		EndIf;

	EndIf;

	Return ReturnValue;

EndFunction

// All attributes array by filter.
// 
// Parameters:
//  CurrentObject - CatalogObject.ItemKeys, AnyRef - Current object
//  Prefix - String -
//  Filter - Structure - Filter:
//  * Required - Boolean - 
// 
// Returns:
//  Array Of ChartOfCharacteristicTypesRef.AddAttributeAndProperty - All attributes array by filter
Function AllAttributesArrayByFilter(CurrentObject, Prefix, Filter = Undefined)
	ReturnValue = New Array();

	FormInfo = GetObjectInfo(CurrentObject, Prefix);
	Form = New Structure("Object", CurrentObject);
	FormInfo.Insert("Form", Form);

	ObjectPredefinedName = StrReplace(CurrentObject.Metadata().FullName(), ".", "_");
	If CurrentObject.Metadata() = Metadata.Catalogs.ItemKeys Then
		If ValueIsFilled(CurrentObject.Item) Then
			AddAttributeAndPropertySetsAttributes = CurrentObject.Item.ItemType.AvailableAttributes;
			AddAttributeAndPropertySetsAttributesByFilter = AddAttributeAndPropertySetsAttributes.Unload(Filter, "Attribute");
			ReturnValue = AddAttributeAndPropertySetsAttributesByFilter.UnloadColumn("Attribute");
		EndIf;
	Else
		AddAttributeAndPropertySetsAttributes = Catalogs.AddAttributeAndPropertySets[ObjectPredefinedName].Attributes; // CatalogTabularSection.ItemTypes.AvailableAttributes
		AddAttributeAndPropertySetsAttributesByFilter = AddAttributeAndPropertySetsAttributes.Unload(Filter);
		ReducedObjectAttributes = ReduceObjectAttributes(FormInfo, AddAttributeAndPropertySetsAttributesByFilter, ObjectPredefinedName);
		ReturnValue = New Array();
		For Each ReducedObjectAttribute In ReducedObjectAttributes Do
			ReturnValue.Add(ReducedObjectAttribute.Attribute);
		EndDo;
	EndIf;

	Return ReturnValue;
EndFunction

// All properties array by filter.
// 
// Parameters:
//  CurrentObject - CatalogObject.ItemKeys, AnyRef - Current object
//  Prefix - String -
//  Filter - Structure - Filter
// 
// Returns:
//  Array Of ChartOfCharacteristicTypesRef.AddAttributeAndProperty - All properties array by filter
Function AllPropertiesArrayByFilter(CurrentObject, Prefix, Filter = Undefined) Export
	ReturnValue = New Array();
	FullName = CurrentObject.Metadata().FullName();
	ObjectPredefinedName = StrReplace(FullName, ".", "_");
	AddAttributeAndPropertySetsAttributes = Catalogs.AddAttributeAndPropertySets[ObjectPredefinedName].Properties;
	AddAttributeAndPropertySetsAttributesByFilter = AddAttributeAndPropertySetsAttributes.Unload(Filter, "Property");
	ReturnValue = AddAttributeAndPropertySetsAttributesByFilter.UnloadColumn("Property");
	Return ReturnValue;
EndFunction

// Addition attribute value by ref.
// 
// Parameters:
//  Ref - AnyRef - Ref
//  ArrayAttributes - Array Of ChartOfCharacteristicTypesRef.AddAttributeAndProperty - Array attributes
// 
// Returns:
//  Array Of Structure:
//  * Attribute - ChartOfCharacteristicTypesRef.AddAttributeAndProperty -
//  * Value - AnyRef -
//  * ValueType - Type -
//  * ID - String -
Function AdditionAttributeValueByRef(Ref, ArrayAttributes) Export

	If ArrayAttributes = Undefined Then
		ArrayAttributes = New Array();
	EndIf;

	VT_Attribute = New ValueTable();
	VT_Attribute.Columns.Add("Attribute", New TypeDescription("ChartOfCharacteristicTypesRef.AddAttributeAndProperty"));
	For Each Attribute In ArrayAttributes Do
		VT_Attribute.Add().Attribute = Attribute;
	EndDo;

	Query = New Query();
	Query.Text =
	"SELECT
	|	VT.Attribute
	|INTO VT_Attributes
	|FROM
	|	&VT_Attributes AS VT
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemsAddAttributes.Value,
	|	ItemsAddAttributes.Property
	|INTO ObjAttributes
	|FROM
	|	%1.AddAttributes AS ItemsAddAttributes
	|WHERE
	|	ItemsAddAttributes.Ref = &Ref
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	VT_Attributes.Attribute,
	|	ISNULL(ObjAttributes.Value, &ValueIsEmpty) AS Value,
	|	VT_Attributes.Attribute.ValueType AS ValueType,
	|	VT_Attributes.Attribute.UniqueID AS ID
	|FROM
	|	VT_Attributes AS VT_Attributes
	|		LEFT JOIN ObjAttributes AS ObjAttributes
	|		ON VT_Attributes.Attribute = ObjAttributes.Property";

	MetadataName = Ref.Metadata().FullName();
	Query.Text = StrTemplate(Query.Text, MetadataName);
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("VT_Attributes", VT_Attribute);
	Query.SetParameter("ValueIsEmpty", R().S_027);
	QueryResult = Query.Execute().Unload();

	AttributeArray = New Array();
	For Each Row In QueryResult Do
		Str = New Structure;
		//@skip-check property-return-type
		Str.Insert("Attribute", Row.Attribute);
		//@skip-check property-return-type
		Str.Insert("Value", Row.Value);
		//@skip-check property-return-type
		Str.Insert("ValueType", Row.ValueType);
		//@skip-check property-return-type
		Str.Insert("ID", Row.ID);
		AttributeArray.Add(Str);
	EndDo;

	Return AttributeArray;
EndFunction

// Addition property value by ref.
// 
// Parameters:
//  Ref - AnyRef - Ref
//  ArrayProperties - Array Of ChartOfCharacteristicTypesRef.AddAttributeAndProperty - Array properties
// 
// Returns:
//  Array Of Structure:
//  * Attribute - ChartOfCharacteristicTypesRef.AddAttributeAndProperty -
//  * Value - AnyRef -
//  * ValueType - Type -
//  * ID - String -
Function AdditionPropertyValueByRef(Ref, ArrayProperties) Export

	If ArrayProperties = Undefined Then
		ArrayProperties = New Array();
	EndIf;

	VT_Property = New ValueTable();
	VT_Property.Columns.Add("Property", New TypeDescription("ChartOfCharacteristicTypesRef.AddAttributeAndProperty"));
	For Each Property In ArrayProperties Do
		VT_Property.Add().Property = Property;
	EndDo;

	Query = New Query();
	Query.Text =
	"SELECT
	|	VT.Property
	|INTO VT_Properties
	|FROM
	|	&VT_Properties AS VT
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AddProperties.Value,
	|	AddProperties.Property
	|INTO ObjProperty
	|FROM
	|	InformationRegister.AddProperties AS AddProperties
	|WHERE
	|	AddProperties.Object = &Ref
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	VT_Properties.Property AS Attribute,
	|	ISNULL(ObjProperty.Value, &ValueIsEmpty) AS Value,
	|	VT_Properties.Property.ValueType AS ValueType,
	|	VT_Properties.Property.UniqueID AS ID
	|FROM
	|	VT_Properties AS VT_Properties
	|		LEFT JOIN ObjProperty AS ObjProperty
	|		ON VT_Properties.Property = ObjProperty.Property";

	Query.SetParameter("Ref", Ref);
	Query.SetParameter("VT_Properties", VT_Property);
	Query.SetParameter("ValueIsEmpty", R().S_027);
	QueryResult = Query.Execute().Unload();

	PropertyArray = New Array();
	For Each Row In QueryResult Do
		Str = New Structure;
		//@skip-check property-return-type
		Str.Insert("Attribute", Row.Attribute);
		//@skip-check property-return-type
		Str.Insert("Value", Row.Value);
		//@skip-check property-return-type
		Str.Insert("ValueType", Row.ValueType);
		//@skip-check property-return-type
		Str.Insert("ID", Row.ID);
		PropertyArray.Add(Str);
	EndDo;

	Return PropertyArray;
EndFunction

#EndRegion

#Region Setter

// Set required at all sets.
// 
// Parameters:
//  AddAttribute - ChartOfCharacteristicTypesRef.AddAttributeAndProperty - Add attribute
//  Required - Boolean - Required
Procedure SetRequiredAtAllSets(AddAttribute, Required) Export
	Query = New Query();
	Query.Text = "SELECT ALLOWED
				 |	AddAttributeAndPropertySetsAttributes.Ref AS Ref
				 |FROM
				 |	Catalog.AddAttributeAndPropertySets.Attributes AS AddAttributeAndPropertySetsAttributes
				 |WHERE
				 |	AddAttributeAndPropertySetsAttributes.Attribute = &Attribute
				 |	AND AddAttributeAndPropertySetsAttributes.Required <> &Required
				 |	AND (AddAttributeAndPropertySetsAttributes.Ref <> VALUE(Catalog.AddAttributeAndPropertySets.Catalog_ItemKeys)
				 |	AND AddAttributeAndPropertySetsAttributes.Ref <> VALUE(Catalog.AddAttributeAndPropertySets.Catalog_PriceKeys))
				 |;
				 |SELECT ALLOWED
				 |	ItemTypesAvailableAttributes.Ref
				 |FROM
				 |	Catalog.ItemTypes.AvailableAttributes AS ItemTypesAvailableAttributes
				 |WHERE
				 |	ItemTypesAvailableAttributes.Attribute = &Attribute
				 |	AND ItemTypesAvailableAttributes.Required <> &Required";
	Query.SetParameter("Attribute", AddAttribute);
	Query.SetParameter("Required", Required);
	QueryExecuteBatch = Query.ExecuteBatch();

	QuerySelection = QueryExecuteBatch[0].Select();
	While QuerySelection.Next() Do
		//@skip-check dynamic-access-method-not-found, property-return-type
		CatObjSets = QuerySelection.Ref.GetObject(); // CatalogObject.AddAttributeAndPropertySets
		AttributeFilter = New Structure("Attribute", AddAttribute);
		AttributeFoundedRows = CatObjSets.Attributes.FindRows(AttributeFilter);
		For Each AttributeFoundedRow In AttributeFoundedRows Do
			AttributeFoundedRow.Required = Required;
		EndDo;
		CatObjSets.Write();
	EndDo;

	QuerySelection = QueryExecuteBatch[1].Select();
	While QuerySelection.Next() Do
		//@skip-check dynamic-access-method-not-found, property-return-type
		CatObj = QuerySelection.Ref.GetObject(); // CatalogObject.ItemTypes
		AttributeFilter = New Structure("Attribute", AddAttribute);
		AttributeFoundedRows = CatObj.AvailableAttributes.FindRows(AttributeFilter);
		For Each AttributeFoundedRow In AttributeFoundedRows Do
			AttributeFoundedRow.Required = Required;
		EndDo;
		CatObj.Write();
	EndDo;
EndProcedure

#EndRegion

#Region HTML

Function HTMLAddAttributes() Export
	HTMLAddAttributes = GetCommonTemplate("HTMLAddAttributes");
	HTMLAddAttributesText = HTMLAddAttributes.GetText();
	Return HTMLAddAttributesText;
EndFunction

// Prepare data for HTML.
// 
// Parameters:
//  ItemRef - AnyRef -
//  Prefix - String - Prefix
//  Filter - Structure - Filter
// 
// Returns:
//  String - Prepare data for HTML
Function PrepareDataForHTML(ItemRef, Prefix, Filter = Undefined) Export
	ArrayProperties = AllPropertiesArrayByFilter(ItemRef, Prefix, Filter);
	ArrayAttributes = AllAttributesArrayByFilter(ItemRef, Prefix, Filter);

	ArrayAttributesValue = AdditionAttributeValueByRef(ItemRef, ArrayAttributes);
	ArrayPropertiesValue = AdditionPropertyValueByRef(ItemRef, ArrayProperties);

	ReadyArrayAttributes = New Array();
	For Each AttributeRow In ArrayAttributesValue Do
		Str = New Structure;
		Str.Insert("Name", String(AttributeRow.Attribute));
		Str.Insert("Type", String(AttributeRow.ValueType));
		Str.Insert("Value", String(AttributeRow.Value));
		Str.Insert("Icon", GetURL(AttributeRow.Attribute, "Icon"));
		ReadyArrayAttributes.Add(Str);
	EndDo;

	ReadyArrayProperties = New Array();
	For Each PropertyRow In ArrayPropertiesValue Do
		Str = New Structure;
		Str.Insert("Name", String(PropertyRow.Attribute));
		Str.Insert("Type", String(PropertyRow.ValueType));
		Str.Insert("Value", String(PropertyRow.Value));
		Str.Insert("Icon", GetURL(PropertyRow.Attribute, "Icon"));
		ReadyArrayProperties.Add(Str);
	EndDo;

	Map = New Map();
	Map.Insert("Properties", ReadyArrayProperties);
	Map.Insert("Attributes", ReadyArrayAttributes);
	
	JSON = CommonFunctionsServer.SerializeJSON(Map);
	Return JSON;
EndFunction

Procedure EventSubscriptionOnCopy(Source, CopiedObject) Export
	If Not Source.Metadata().TabularSections.Find("AddAttributes") = Undefined Then
		Source.AddAttributes.Load(CopiedObject.AddAttributes.Unload());
	EndIf;
EndProcedure

#EndRegion

#Region Service

// Extract property.
// 
// Parameters:
//  ArrayOfValues - Array Of See GroupInfo
//  Name - String - Name
// 
// Returns:
//  Array Of See GroupInfo
Function ExtractProperty(ArrayOfValues, Name)
	Result = New Array();
	For Each Row In ArrayOfValues Do
		Result.Add(Row[Name]);
	EndDo;
	Return Result;
EndFunction

Procedure CreateItemsForURL(Form, GroupNameForPlacement, AttrInfo, ArrayOfFormElements)
	
	ElementPages = Form.Items.Add(
		AttrInfo.Name + "Pages", 
		Type("FormGroup"), 
		GetFormItemParent(Form, GroupNameForPlacement, AttrInfo)
	);	
	ElementPages.Type = FormGroupType.Pages;
	ElementPages.PagesRepresentation = FormPagesRepresentation.None;
	ElementPages.HorizontalStretch = True;
	
	ElementPageURL = Form.Items.Add(AttrInfo.Name + "PageURL", Type("FormGroup"), ElementPages);	
	ElementPageURL.Type = FormGroupType.Page;
	ElementPageURL.Group = ChildFormItemsGroup.Horizontal;
	
	ElementPageEdit = Form.Items.Add(AttrInfo.Name + "PageEdit", Type("FormGroup"), ElementPages);	
	ElementPageEdit.Type = FormGroupType.Page;
	ElementPageEdit.Group = ChildFormItemsGroup.Horizontal;
	
	FormElementEdit = Form.Items.Add(AttrInfo.Name, Type("FormField"), ElementPageEdit);
	FormElementEdit.DataPath = AttrInfo.Path;
	FormElementEdit.Type = FormFieldType.InputField;
	FormElementEdit.HorizontalStretch = True;
	FormElementEdit.ClearButton = True;
	
	FormButtonSave = Form.Items.Add(AttrInfo.Name + "_SaveURL", Type("FormDecoration"), ElementPageEdit);
	FormButtonSave.Type = FormDecorationType.Picture;
	FormButtonSave.Hyperlink = True;
	FormButtonSave.Picture = PictureLib.SaveFile;
	//@skip-check module-attachable-event-handler-name
	FormButtonSave.SetAction("Click", "AddAttributeButtonClick");
	
	FormElementURL = Form.Items.Add(AttrInfo.Name + "_URL", Type("FormDecoration"), ElementPageURL);
	FormElementURL.Hyperlink = True;
	FormElementURL.Title = String(Form[AttrInfo.Path]);
	FormElementURL.ToolTip = AttrInfo.Title;
	FormElementURL.ToolTipRepresentation = ToolTipRepresentation.ShowLeft;
	FormElementURL.BackColor = StyleColors.ToolTipBackColor;
	FormElementURL.HorizontalStretch = True;
	//@skip-check module-attachable-event-handler-name
	FormElementURL.SetAction("Click", "AddAttributeButtonClick");
	
	FormButtonEditURL = Form.Items.Add(AttrInfo.Name + "_EditURL", Type("FormDecoration"), ElementPageURL);
	FormButtonEditURL.Type = FormDecorationType.Picture;
	FormButtonEditURL.Hyperlink = True;
	FormButtonEditURL.Picture = PictureLib.Change;
	//@skip-check module-attachable-event-handler-name
	FormButtonEditURL.SetAction("Click", "AddAttributeButtonClick");
	
	ArrayOfFormElements.Add(FormElementURL);
	ArrayOfFormElements.Add(FormButtonEditURL);
	ArrayOfFormElements.Add(FormElementEdit);
	ArrayOfFormElements.Add(FormButtonSave);
	ArrayOfFormElements.Add(ElementPageURL);
	ArrayOfFormElements.Add(ElementPageEdit);
	ArrayOfFormElements.Add(ElementPages);
	
EndProcedure

// Fill array of attributes info.
// 
// Parameters:
//  FormAttributes - See FormAttributes
// 
// Returns:
//  Array Of Structure:
//  * Name - String -
//  * Name_owner - String -
Function FillArrayOfAttributesInfo(FormAttributes)
	ArrayOfAttributesInfo = New Array();
	For Each Row In FormAttributes.FormAttributesInfo Do
		Str = New Structure;
		Str.Insert("Name", Row.Name);
		Str.Insert("Name_owner", Row.Name_owner);
		ArrayOfAttributesInfo.Add(Str);
	EndDo;
	Return ArrayOfAttributesInfo;
EndFunction

Function AttributeName(Attribute, AddInfo = Undefined)
	Return "_" + StrReplace(Attribute.UniqueID, " ", "");
EndFunction

Function AttributeOwnerName(Attribute, AddInfo = Undefined)
	Return "_" + StrReplace(Attribute.UniqueID, " ", "") + "_owner";
EndFunction

Function GetDCSTemplate(PredefinedDataName, AddInfo = Undefined) Export
	TableName = StrReplace(PredefinedDataName, "_", ".");
	ArrayOfObjectNames = StrSplit(PredefinedDataName, "_");
	If ArrayOfObjectNames.Count() = 3 Then
		ObjectName = ArrayOfObjectNames[1] + "_" + ArrayOfObjectNames[2];
	Else
		ObjectName = ArrayOfObjectNames[1];
	EndIf;
	If StrStartsWith(PredefinedDataName, "Catalog") Then
		Template = Catalogs.AddAttributeAndPropertySets.GetTemplate("DCS_Catalog");
		Template.DataSets[0].Items[0].Query = StrReplace(Template.DataSets[0].Items[0].Query, "&TableName", TableName);
		//@skip-check property-return-type, dynamic-access-method-not-found
		Template.DataSets[0].Items.DataSet2.Fields.Find("Ref").ValueType = New TypeDescription("CatalogRef." + ObjectName);
	ElsIf StrStartsWith(PredefinedDataName, "Document") Then
		Template = Catalogs.AddAttributeAndPropertySets.GetTemplate("DCS_Document");
		Template.DataSets[0].Query = StrReplace(Template.DataSets[0].Query, "&TableName", TableName);
		Template.DataSets[0].Fields.Find("Ref").ValueType = New TypeDescription("DocumentRef." + ObjectName);
	Else
		Raise R().Error_004;
	EndIf;
	Return Template;
EndFunction

Function GetRefsByCondition(DCSTemplate, Settings, ExternalDataSet, AddInfo = Undefined) Export
	Composer = New DataCompositionTemplateComposer();
	Template = Composer.Execute(DCSTemplate, Settings, , , Type("DataCompositionValueCollectionTemplateGenerator"));
	
	Processor = New DataCompositionProcessor();
	Processor.Initialize(Template, New Structure("ExternalDataSet", ExternalDataSet));

	Output = New DataCompositionResultValueCollectionOutputProcessor();
	Result = New ValueTable();
	Output.SetObject(Result);
	Output.Output(Processor);

	Return Result;
EndFunction

// Reduce object attributes.
// 
// Parameters:
//  FormInfo - See GetObjectInfo
//  AllItems - ValueTable, CatalogTabularSection.AddAttributeAndPropertySets.Attributes - All items
//  AddAttributeAndPropertySetName - String - Add attribute and property set name
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Array Of CatalogTabularSectionRow.AddAttributeAndPropertySets.Attributes
Function ReduceObjectAttributes(FormInfo, AllItems, AddAttributeAndPropertySetName, AddInfo = Undefined)
	TableOfAvailableAttributes = New ValueTable();
	TableOfAvailableAttributes.Columns.Add("RowOfAllItems");
	TableOfAvailableAttributes.Columns.Add("LineNumber");

	ArrayOfCollection = New Array();

	If FormInfo.Metadata = Metadata.Catalogs.PriceKeys Then
		FixedExistItems = AllItems.UnloadColumns();
		For Each Row In FormInfo.Ref.AddAttributes Do
			NewRow = FixedExistItems.Add();
			NewRow.Attribute = Row.Property;
			ArrayOfCollection.Add(NewRow);
		EndDo;

	Else
		FillTableOfAvailableAttributesBy_AllItems(TableOfAvailableAttributes, ArrayOfCollection, FormInfo,
			AddAttributeAndPropertySetName, AllItems, AddInfo);
	EndIf;

	If TableOfAvailableAttributes.Count() Then
		TableOfAvailableAttributes.Sort("LineNumber");
		ArrayOfCollection = TableOfAvailableAttributes.UnloadColumn("RowOfAllItems");
	EndIf;

	Return ArrayOfCollection;
EndFunction

#EndRegion
