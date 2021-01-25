#Region EventHandlers

Procedure OnCreateAtServer(Form, GroupNameForPlacement = "", AddInfo = Undefined) Export
	CreateFormControls(Form, GroupNameForPlacement, AddInfo);
EndProcedure

Procedure BeforeWriteAtServer(Form, Cancel, CurrentObject, WriteParameters, AddInfo = Undefined) Export
	
	If CurrentObject.Metadata().TabularSections.Find("AddAttributes") = Undefined Then
		Return;
	EndIf;
	
	CurrentObject.AddAttributes.Clear();
	FormInfo = GetFormInfo(Form);
	If Not FormInfo.Property("Form") Then
		FormInfo.Insert("Form", Form);
	EndIf;
	
	AddAttributeAndPropertySetName = AddAttributeAndPropertySetName(FormInfo, AddInfo);
	ObjectAttributes = ObjectAttributes(FormInfo, AddAttributeAndPropertySetName, AddInfo);
	RequiredFiler = New Structure("Required", True);
	RequiredAttributesArray = AllAttributesArrayByFilter(CurrentObject, RequiredFiler);
	CancelValue = False;
	
	For Each Row In ObjectAttributes Do
		AttributeInfo = AttributeAndPropertyInfo(Row, AddInfo);
		RequiredAttributeResult = RequiredAttributesArray.Find(Row.Attribute);
		If ValueIsFilled(Form[AttributeInfo.Name]) Then
			NewAttribute = CurrentObject.AddAttributes.Add();
			NewAttribute.Property = AttributeInfo.Ref;
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

Procedure CreateFormControls(Form, GroupNameForPlacement = "", AddInfo = Undefined) Export
	FormInfo = Undefined;
	If TypeOf(AddInfo) = Type("Structure") Then
		If AddInfo.Property("FormInfo") Then
			FormInfo = AddInfo.FormInfo;
		EndIf;
	EndIf;
	
	If FormInfo = Undefined Then
		FormInfo = GetFormInfo(Form);
	EndIf;
	If Not FormInfo.Property("Form") Then
		FormInfo.Insert("Form", Form);
	EndIf;
	ClearForm(Form);
	
	SavedData = New Structure("FormGroups, FormAttributes, FormItemFields, ArrayOfAttributesInfo");
	
	AddAttributeAndPropertySetName = AddAttributeAndPropertySetName(FormInfo, AddInfo);
	ObjectAttributes = ObjectAttributes(FormInfo, AddAttributeAndPropertySetName, AddInfo);
	
	FormGroups = FormGroups(ObjectAttributes, AddInfo);
	CreatedFormGroups = CreateFormGroups(Form, FormGroups, AddInfo);
	SavedData.FormGroups = ExtractProperty(CreatedFormGroups, "Name");
	
	FormAttributes = FormAttributes(ObjectAttributes, AddInfo);
	SavedData.FormAttributes = ExtractProperty(FormAttributes.Attributes, "Name");
	
	ArrayOfAttributesInfo = New Array();
	For Each Row In FormAttributes.FormAttributesInfo Do
		ArrayOfAttributesInfo.Add(New Structure("Name, Name_owner"
				, Row.Name
				, Row.Name_owner));
	EndDo;
	
	SavedData.ArrayOfAttributesInfo = ArrayOfAttributesInfo;
	
	Form.ChangeAttributes(FormAttributes.Attributes);
	
	IsNewObject = Not ValueIsFilled(Form.Object.Ref);
	DefaultAttributeValues = Undefined;
	If IsNewObject Then
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
		FilterParameters.Insert("MetadataObject", Form.Object.Ref.Metadata());
		UserSettings = UserSettingsServer.GetUserSettings(SessionParameters.CurrentUser, FilterParameters);
		Query.SetParameter("UserSettings", UserSettings);
		DefaultAttributeValues = Query.Execute().Unload();
	EndIf;
	
	For Each Row In ObjectAttributes Do
		
		ArrayOfExistAttributes = FormInfo.AddAttributes.FindRows(New Structure("Property", Row.Attribute));
		If ArrayOfExistAttributes.Count() Then
			AttributeInfo = AttributeAndPropertyInfo(Row, AddInfo);
			Form[AttributeInfo.Name] = ArrayOfExistAttributes[0].Value;
			
		ElsIf IsNewObject And DefaultAttributeValues <> Undefined Then
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
	Form.SavedData = CommonFunctionsServer.SerializeXMLUseXDTO(SavedData);
EndProcedure

Procedure ClearForm(Form)
	SavedData = Undefined;
	For Each FormAttribute In Form.GetAttributes() Do
		If FormAttribute.Name = "SavedData" Then
			SavedData = Form["SavedData"];
			Break;
		EndIf;
	EndDo;
	If SavedData = Undefined Then
		Return;
	EndIf;
	
	SavedData = CommonFunctionsServer.DeserializeXMLUseXDTO(SavedData);
	
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

Function ExtractProperty(ArrayOfValues, Name)
	Result = New Array();
	For Each Row In ArrayOfValues Do
		Result.Add(Row[Name]);
	EndDo;
	Return Result;
EndFunction

Function CreateFormGroups(Form, FormGroupsInfo, AddInfo = Undefined) Export
	ArrayOfFormGroups = New Array;
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
		NewFormGroup = Form.Items.Add(GroupInfo.Name, Type("FormGroup"), GroupParent);
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
		NewFormElement = Form.Items.Add(AttrInfo.Name,
				Type("FormField"),
				GetFormItemParent(Form, GroupNameForPlacement, AttrInfo));
		
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
			
			NewFormElement.SetAction("StartChoice", "AddAttributeStartChoice");
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

Function GetFormInfo(Form)
	FormInfo = New Structure();
	FormInfo.Insert("Ref", Form.Object.Ref);
	
	FormInfo.Insert("AddAttributes", Form.Object.AddAttributes);
	
	If TypeOf(Form.Object.Ref) = Type("CatalogRef.ItemKeys")
		Or TypeOf(Form.Object.Ref) = Type("CatalogRef.PriceKeys") Then
		FormInfo.Insert("Item", Form.Object.Item);
		FormInfo.Insert("ItemType", ?(Form.Object.Item = Undefined, Undefined, Form.Object.Item.ItemType));
	EndIf;
	
	ExternalDataSet = New ValueTable();
	If TypeOf(Form.Object.Ref) = Type("CatalogRef.Items") Then		
		ExternalDataSet.Columns.Add("ItemType", New TypeDescription("CatalogRef.ItemTypes"));
		ExternalDataSet.Columns.Add("Ref", New TypeDescription("CatalogRef.Items"));		
		NewRow = ExternalDataSet.Add();
		NewRow.ItemType = Form.Object.ItemType;
		NewRow.Ref = Form.Object.Ref;
	EndIf;
	FormInfo.Insert("ExternalDataSet", ExternalDataSet);
	
	Return FormInfo;
EndFunction

Function GetObjectInfo(Object)
	FormInfo = New Structure();
	FormInfo.Insert("Ref", Object.Ref);
	
	FormInfo.Insert("AddAttributes", Object.AddAttributes);
	
	If TypeOf(Object.Ref) = Type("CatalogRef.ItemKeys")
		Or TypeOf(Object.Ref) = Type("CatalogRef.PriceKeys") Then
		FormInfo.Insert("Item", Object.Item);
		FormInfo.Insert("ItemType", ?(Object.Item = Undefined, Undefined, Object.Item.ItemType));
	EndIf;
	
	ExternalDataSet = New ValueTable();
	If TypeOf(Object.Ref) = Type("CatalogRef.Items") Then		
		ExternalDataSet.Columns.Add("ItemType", New TypeDescription("CatalogRef.ItemTypes"));
		ExternalDataSet.Columns.Add("Ref", New TypeDescription("CatalogRef.Items"));		
		NewRow = ExternalDataSet.Add();
		NewRow.ItemType = Object.ItemType;
		NewRow.Ref = Object.Ref;
	EndIf;
	FormInfo.Insert("ExternalDataSet", ExternalDataSet);
	
	Return FormInfo;
EndFunction

Function AddAttributeAndPropertySetRef(Ref, AddInfo = Undefined) Export
	SetName = AddAttributeAndPropertySetName(Ref, AddInfo);
	Return Catalogs.AddAttributeAndPropertySets[SetName];
EndFunction

Function AddAttributeAndPropertySetName(FormInfo, AddInfo = Undefined) Export
	Return StrReplace(FormInfo.Ref.Metadata().FullName(), ".", "_");
EndFunction

Function FormAttributes(ObjectAttributes, AddInfo = Undefined) Export
	Attributes = New Array();
	FormAttributesInfo = New Array();
	For Each Row In ObjectAttributes Do
		
		AttributeInfo = AttributeAndPropertyInfo(Row, AddInfo);
		
		Attributes.Add(New FormAttribute(AttributeInfo.Name,
				AttributeInfo.Type, ,
				AttributeInfo.Title,
				AttributeInfo.StoredData));
		
		Attributes.Add(New FormAttribute(AttributeInfo.Name_owner,
				AttributeInfo.Type_owner, ,
				AttributeInfo.Title_owner,
				AttributeInfo.StoredData_owner));
		
		FormAttributesInfo.Add(AttributeInfo);
		
	EndDo;
	
	Attributes.Add(New FormAttribute("SavedData",
			New TypeDescription("String"), ,
			// FIXIT: Localize?
			"SavedData",
			False));
	
	Return New Structure("Attributes, FormAttributesInfo", Attributes, FormAttributesInfo);
EndFunction

Function FormGroups(ObjectAttributes, AddInfo = Undefined) Export
	Groups = New Array();
	InterfaceGroups = New Array;
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

Function ObjectAttributes(FormInfo, AddAttributeAndPropertySetName, AddInfo = Undefined) Export
	AllItems = Catalogs.AddAttributeAndPropertySets[AddAttributeAndPropertySetName].Attributes;
	Return ReduceObjectAttributes(FormInfo, AllItems, AddAttributeAndPropertySetName, AddInfo);
EndFunction

Function ObjectProperties(AddAttributeAndPropertySetName, AddInfo = Undefined) Export
	Return Catalogs.AddAttributeAndPropertySets[AddAttributeAndPropertySetName].Properties;
EndFunction

Function ReduceObjectAttributes(FormInfo, AllItems, AddAttributeAndPropertySetName, AddInfo = Undefined)
	TableOfAvailableAttributes = New ValueTable();
	TableOfAvailableAttributes.Columns.Add("RowOfAllItems");
	TableOfAvailableAttributes.Columns.Add("LineNumber");
	
	ArrayOfCollection = New Array();
	
	If TypeOf(FormInfo.Ref) = Type("CatalogRef.PriceKeys") Then
		FixedExistItems = AllItems.UnloadColumns();
		For Each Row In FormInfo.Ref.AddAttributes Do
			NewRow = FixedExistItems.Add();
			NewRow.Attribute = Row.Property;
			ArrayOfCollection.Add(NewRow);
		EndDo;
		
	Else
		FillTableOfAvailableAttributesBy_AllItems(TableOfAvailableAttributes
			, ArrayOfCollection
			, FormInfo
			, AddAttributeAndPropertySetName
			, AllItems
			, AddInfo);
	EndIf;
	
	If TableOfAvailableAttributes.Count() Then
		TableOfAvailableAttributes.Sort("LineNumber");
		ArrayOfCollection = TableOfAvailableAttributes.UnloadColumn("RowOfAllItems");
	EndIf;
	
	Return ArrayOfCollection;
EndFunction

Procedure FillTableOfAvailableAttributesBy_AllItems(TableOfAvailableAttributes
		, ArrayOfCollection
		, FormInfo
		, AddAttributeAndPropertySetName
		, AllItems
		, AddInfo = Undefined)
	Template = GetDCSTemplate(AddAttributeAndPropertySetName, AddInfo);
	ExternalDataSet = FormInfo.ExternalDataSet;
	For Each Row In AllItems Do
		If Row.IsConditionSet Then
			Settings = Row.Condition.Get();
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
			If TypeOf(FormInfo.Ref) = Type("CatalogRef.ItemKeys") Then
				// get add attributes from ItemType (tabular section AvailableAttributes)
				If ValueIsFilled(FormInfo.Item) And ValueIsFilled(FormInfo.ItemType) Then
					Filter = New Structure("Attribute", Row.Attribute);
					FoundedRows = FormInfo.ItemType.AvailableAttributes.FindRows(Filter);
					If FoundedRows.Count() Then
						NewRowOfAvailableAttributes = TableOfAvailableAttributes.Add();
						NewRowOfAvailableAttributes.RowOfAllItems = Row;
						NewRowOfAvailableAttributes.LineNumber = FoundedRows[0].LineNumber;
					EndIf;
				EndIf;
			Else
				ArrayOfCollection.Add(Row);
			EndIf;
		EndIf;
	EndDo;
	
EndProcedure

Function AttributeAndPropertyInfo(AttributePropertyRow, AddInfo = Undefined) Export
	Result = New Structure();
	
	Name = AttributeName(AttributePropertyRow.Attribute, AddInfo);
	Result.Insert("Ref", AttributePropertyRow.Attribute);
	Result.Insert("Name", Name);
	Result.Insert("Type", AttributePropertyRow.Attribute.ValueType);
	Result.Insert("Path", Name);
	Result.Insert("Title", String(AttributePropertyRow.Attribute));
	Result.Insert("StoredData", True);
	If ValueIsFilled(AttributePropertyRow.InterfaceGroup) Then
		ParentName = "_" + StrReplace(AttributePropertyRow.InterfaceGroup.UUID(), "-", "");
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

Function GroupInfo(Group, AddInfo = Undefined) Export
	Result = New Structure();
	Name = "_" + StrReplace(Group.UUID(), "-", "");
	Result.Insert("Name", Name);
	Result.Insert("ParentName", "Group" + Group.FormPosition);
	Result.Insert("Title", String(Group));
	Result.Insert("Behavior", UsualGroupBehavior[MetadataInfo.EnumNameByRef(Group.Behavior)]);
	Result.Insert("ChildFormItemsGroup", ChildFormItemsGroup[MetadataInfo.EnumNameByRef(Group.ChildFormItemsGroup)]);
	Result.Insert("Collapsed", Group.Collapsed);
	Return Result;
EndFunction

Function AttributeName(Attribute, AddInfo = Undefined)
	Return "_" + StrReplace(Attribute.UniqueID, " ", "");
EndFunction

Function AttributeOwnerName(Attribute, AddInfo = Undefined)
	Return "_" + StrReplace(Attribute.UniqueID, " ", "") + "_owner";
EndFunction

Function GetDCSTemplate(PredefinedDataName, AddInfo = Undefined) Export
	If StrStartsWith(PredefinedDataName, "Catalog") Then
		TableName = StrReplace(PredefinedDataName, "_", ".");
		Template = Catalogs.AddAttributeAndPropertySets.GetTemplate("DCS_Catalog");
		Template.DataSets[0].Items[0].Query = StrTemplate(Template.DataSets[0].Items[0].Query, TableName);
	ElsIf StrStartsWith(PredefinedDataName, "Document") Then
		TableName = StrReplace(PredefinedDataName, "_", ".");
		Template = Catalogs.AddAttributeAndPropertySets.GetTemplate("DCS_Document");
		Template.DataSets[0].Query = StrTemplate(Template.DataSets[0].Query, TableName);
	Else
		Raise R().Error_004;
	EndIf;
	Return Template;
EndFunction

Function GetRefsByCondition(DCSTemplate, Settings, ExternalDataSet, AddInfo = Undefined) Export
	Composer = New DataCompositionTemplateComposer();
	Template = Composer.Execute(DCSTemplate, Settings, , ,
			Type("DataCompositionValueCollectionTemplateGenerator"));
	
	Processor = New DataCompositionProcessor();
	Processor.Initialize(Template, New Structure("ExternalDataSet", ExternalDataSet));	
	
	Output = New DataCompositionResultValueCollectionOutputProcessor();
	Result = New ValueTable();
	Output.SetObject(Result);
	Output.Output(Processor);
	
	Return Result;
EndFunction

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

Function GetMD5ByAddAttributes(AddAttributes) Export
	If Not AddAttributes.Count() Then
		Return "";
	EndIf;
	
	ValueTable = New ValueTable();
	ValueTable.Columns.Add("Property");
	ValueTable.Columns.Add("Value");
	ValueTable.Columns.Add("Item");
	
	For Each Row In AddAttributes Do
		NewRow = ValueTable.Add();
		NewRow.Property = String(Row.Property.UUID());
		NewRow.Item = String(Row.Item.UUID());
		If CommonFunctionsServer.IsPrimitiveValue(Row.Value) Then
			NewRow.Value = String(Row.Value);
		Else
			NewRow.Value = String(Row.Value.UUID());
		EndIf;
	EndDo;
	ValueTable.Sort("Property, Value, Item");
	
	Return GetMD5ForValueTable(ValueTable);
EndFunction

Function GetMD5BySpecification(AddAttributes) Export
	If Not AddAttributes.Count() Then
		Return "";
	EndIf;
	
	ValueTable = New ValueTable();
	ValueTable.Columns.Add("Property");
	ValueTable.Columns.Add("Value");
	ValueTable.Columns.Add("Item");
	ValueTable.Columns.Add("Quantity");
	
	For Each Row In AddAttributes Do
		NewRow = ValueTable.Add();
		NewRow.Property = String(Row.Property.UUID());
		NewRow.Item = String(Row.Item.UUID());
		NewRow.Quantity = String(Row.Quantity);
		If CommonFunctionsServer.IsPrimitiveValue(Row.Value) Then
			NewRow.Value = String(Row.Value);
		Else
			NewRow.Value = String(Row.Value.UUID());
		EndIf;
	EndDo;
	ValueTable.Sort("Property, Value, Quantity");
	
	Return GetMD5ForValueTable(ValueTable);	
EndFunction

Function GetMD5ForValueTable(ValueTable) Export
	xml = CommonFunctionsServer.SerializeXMLUseXDTO(ValueTable);
	
	DataHashing = New DataHashing(HashFunction.MD5);
	DataHashing.Append(xml);
	Return Upper(DataHashing.HashSum);
EndFunction

Function GetAddAttributeValueOfRefByID(UniqueID, ObjectRef) Export
	
	ReturnValue = Undefined;
	
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

Function GetAddPropertyValueOfRefByID(UniqueID, ObjectRef) Export
	
	ReturnValue = Undefined;
	
	AddPropertyRef = ChartsOfCharacteristicTypes.AddAttributeAndProperty.FindByAttribute("UniqueID", UniqueID);	
	If Not AddPropertyRef.IsEmpty() Then		
		
		Query = New Query;
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
			ReturnValue = QuerySelection.Value;
			
		EndIf; 
		
	EndIf;
	
	Return ReturnValue;
	
EndFunction

Function AllAttributesArrayByFilter(CurrentObject, Filter = Undefined)	Export
	ReturnValue = New Array;
	
	FormInfo = GetObjectInfo(CurrentObject);
	Form = New Structure("Object", CurrentObject);
	FormInfo.Insert("Form", Form);
	
	ObjectPredefinedName = StrReplace(CurrentObject.Metadata().FullName(), ".", "_");
	If ObjectPredefinedName = "Catalog_ItemKeys" Then
		If ValueIsFilled(CurrentObject.Item) Then
			AddAttributeAndPropertySetsAttributes = CurrentObject.Item.ItemType.AvailableAttributes;			
			AddAttributeAndPropertySetsAttributesByFilter = AddAttributeAndPropertySetsAttributes.Unload(Filter, "Attribute");
			ReturnValue = AddAttributeAndPropertySetsAttributesByFilter.UnloadColumn("Attribute");
		EndIf;
	Else 	
		AddAttributeAndPropertySetsAttributes = Catalogs.AddAttributeAndPropertySets[ObjectPredefinedName].Attributes;
		AddAttributeAndPropertySetsAttributesByFilter = AddAttributeAndPropertySetsAttributes.Unload(Filter);
		ReducedObjectAttributes = ReduceObjectAttributes(FormInfo, AddAttributeAndPropertySetsAttributesByFilter, ObjectPredefinedName);
		ReturnValue = New Array;
		For Each ReducedObjectAttribute In ReducedObjectAttributes Do
			ReturnValue.Add(ReducedObjectAttribute.Attribute);
		EndDo;
	EndIf;
		
	Return ReturnValue;
EndFunction

Function AllPropertiesArrayByFilter(CurrentObject, Filter = Undefined)	Export
	ReturnValue = New Array;
	ObjectPredefinedName = StrReplace(CurrentObject.Metadata().FullName(), ".", "_");
	AddAttributeAndPropertySetsAttributes = Catalogs.AddAttributeAndPropertySets[ObjectPredefinedName].Properties;
	AddAttributeAndPropertySetsAttributesByFilter = AddAttributeAndPropertySetsAttributes.Unload(Filter, "Property");
	ReturnValue = AddAttributeAndPropertySetsAttributesByFilter.UnloadColumn("Property");	
	Return ReturnValue;
EndFunction

Procedure SetRequiredAtAllSets(AddAttribute, Required) Export
	Query = New Query;
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
		CatObj = QuerySelection.Ref.GetObject();
		AttributeFilter = New Structure("Attribute", AddAttribute);
		AttributeFoundedRows = CatObj.Attributes.FindRows(AttributeFilter);
		For Each AttributeFoundedRow In AttributeFoundedRows Do
			AttributeFoundedRow.Required = Required;
		EndDo;
		CatObj.Write();
	EndDo;
	
	QuerySelection = QueryExecuteBatch[1].Select();
	While QuerySelection.Next() Do
		CatObj = QuerySelection.Ref.GetObject();
		AttributeFilter = New Structure("Attribute", AddAttribute);
		AttributeFoundedRows = CatObj.AvailableAttributes.FindRows(AttributeFilter);
		For Each AttributeFoundedRow In AttributeFoundedRows Do
			AttributeFoundedRow.Required = Required;
		EndDo;
		CatObj.Write();
	EndDo;		
EndProcedure

Function AdditionAttributeValueByRef(Ref, ArrayAttributes) Export
	
	If ArrayAttributes = Undefined Then
		ArrayAttributes = New Array;
	EndIf;

	VT_Attribute = New ValueTable();
	VT_Attribute.Columns.Add("Attribute", New TypeDescription("ChartOfCharacteristicTypesRef.AddAttributeAndProperty"));
	For Each Attribute In ArrayAttributes Do
		VT_Attribute.Add().Attribute = Attribute;
	EndDo;
	
	Query = New Query;
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
	
	AttributeArray = New Array;
	For Each Row In QueryResult Do
		Str = New Structure("Attribute, Value, ValueType, ID");
		FillPropertyValues(Str, Row);
		AttributeArray.Add(Str);
	EndDo;
	
	Return AttributeArray;
EndFunction

Function AdditionPropertyValueByRef(Ref, ArrayProperties) Export
	
	If ArrayProperties = Undefined Then
		ArrayProperties = New Array;
	EndIf;

	VT_Property = New ValueTable();
	VT_Property.Columns.Add("Property", New TypeDescription("ChartOfCharacteristicTypesRef.AddAttributeAndProperty"));
	For Each Property In ArrayProperties Do
		VT_Property.Add().Property = Property;
	EndDo;
	
	Query = New Query;
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
	
	PropertyArray = New Array;
	For Each Row In QueryResult Do
		Str = New Structure("Attribute, Value, ValueType, ID");
		FillPropertyValues(Str, Row);
		PropertyArray.Add(Str);
	EndDo;
	
	Return PropertyArray;
EndFunction

#Region HTML

Function HTMLAddAttributes() Export
	HTMLAddAttributes = GetCommonTemplate("HTMLAddAttributes");
	HTMLAddAttributes = HTMLAddAttributes.GetText();
	Return HTMLAddAttributes;
EndFunction

Function PrepareDataForHTML(ItemRef, Filter = Undefined) Export
	ArrayProperties = AddAttributesAndPropertiesServer.AllPropertiesArrayByFilter(ItemRef, Filter);
	ArrayAttributes = AddAttributesAndPropertiesServer.AllAttributesArrayByFilter(ItemRef, Filter);
	
	ArrayAttributesValue = AdditionAttributeValueByRef(ItemRef, ArrayAttributes);
	ArrayPropertiesValue = AdditionPropertyValueByRef(ItemRef, ArrayProperties);
	
	ReadyArrayAttributes = New Array;
	For Each AttributeRow In ArrayAttributesValue Do
		Str = New Structure("Icon, Name, Value, Type, Attribute");
		Str.Name = String(AttributeRow.Attribute);
		Str.Type = String(AttributeRow.ValueType);
		Str.Value = String(AttributeRow.Value);
		Str.Icon = AttributeRow.Attribute.Icon.Get();
		ReadyArrayAttributes.Add(Str);
	EndDo;

	ReadyArrayProperties = New Array;
	For Each PropertyRow In ArrayPropertiesValue Do
		Str = New Structure("Icon, Name, Value, Type, Attribute");
		Str.Name = String(PropertyRow.Attribute);
		Str.Type = String(PropertyRow.ValueType);
		Str.Value = String(PropertyRow.Value);
		Str.Icon = PropertyRow.Attribute.Icon.Get();
		ReadyArrayProperties.Add(Str);
	EndDo;
	
	Str = New Map();
	Str.Insert("Properties", ReadyArrayProperties);
	Str.Insert("Attributes", ReadyArrayAttributes);	
	
	Return Str;
EndFunction

Procedure EventSubscriptionOnCopy(Source, CopiedObject) Export
	If Not Metadata.FindByType(TypeOf(Source)).TabularSections.Find("AddAttributes") = Undefined Then
		Source.AddAttributes.Load(CopiedObject.AddAttributes.Unload());
	EndIf;
EndProcedure

#EndRegion
