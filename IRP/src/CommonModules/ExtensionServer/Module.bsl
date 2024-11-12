#Region Service

Procedure InstallExtention(Name, ExtensionData, OverWrite = True) Export
	If ExtensionData = Undefined Then
		Return;
	EndIf;

	ArrayExt = ConfigurationExtensions.Get(New Structure("Name", Name));
	If ArrayExt.Count() Then
		If Not OverWrite Then
			Return;
		EndIf;
		Ext = ArrayExt[0];
	Else
		Ext = ConfigurationExtensions.Create();
	EndIf;

	Ext.Active = True;
	Ext.SafeMode = False;
	Ext.Write(ExtensionData);
EndProcedure

#EndRegion

#Region AddExtensionsAttributes

Procedure AddAttributesFromExtensions(Form, MetaTypeOrRef, ItemElement = Undefined) Export
	Types = New Array();
	Types.Add(Type("Boolean"));
	BooleanTypeDescription = New TypeDescription(Types);

	ElementParent = Undefined;

	If Not ItemElement = Undefined Then
		If TypeOf(ItemElement) = Type("FormGroup") Then
			If ItemElement.Type = FormGroupType.Pages Then
				ElementParent  = Form.Items.Add("ExtAttributes", Type("FormGroup"), ItemElement);
				ElementParent.Type = FormGroupType.Page;
				ElementParent.Title = R().Form_029;
			ElsIf ItemElement.Type = FormGroupType.Page Or ItemElement.Type = FormGroupType.UsualGroup Then
				ElementParent = ItemElement;
			EndIf;
		EndIf;
	EndIf;

	ObjectMetadata = Metadata.FindByType(TypeOf(MetaTypeOrRef));
	AttributesList = Catalogs.AddAttributeAndPropertySets.GetExtensionAttributesListByObjectMetadata(ObjectMetadata, MetaTypeOrRef);
	FormGroups = AddAttributesAndPropertiesServer.FormGroups(AttributesList);
	If ElementParent <> Undefined Then
		For Each FormGroup In FormGroups Do
			FormGroup.ParentName = ElementParent.Name;
		EndDo;
	EndIf;
	AddAttributesAndPropertiesServer.CreateFormGroups(Form, FormGroups);

	For Each Attribute In AttributesList Do
		If ValueIsFilled(Attribute.InterfaceGroup) Then
			ParentName = "_" + StrReplace(Attribute.InterfaceGroup.UUID(), "-", "");
			Parent = Form.Items[ParentName];
		ElsIf ElementParent <> Undefined Then
			Parent = ElementParent;
		Else
			Parent = Form;
		EndIf;

		NewAttribute = Form.Items.Add(Attribute.Attribute, Type("FormField"), Parent);
		NewAttribute.Type = FormFieldType.InputField;
		NewAttribute.DataPath = "Object." + Attribute.Attribute;
		If ObjectMetadata.Attributes.Find(Attribute.Attribute) = Undefined Then
			If Metadata.CommonAttributes[Attribute.Attribute].Type = BooleanTypeDescription Then
				NewAttribute.Type = FormFieldType.CheckBoxField;
			EndIf;
		Else
			If ObjectMetadata.Attributes[Attribute.Attribute].Type = BooleanTypeDescription Then
				NewAttribute.Type = FormFieldType.CheckBoxField;
			EndIf;
		EndIf;
	EndDo;

	For Each TabularSection In ObjectMetadata.TabularSections Do
		For Each Column In TabularSection.Attributes Do
			If Not StrFind(Column.Name, "_") Then
				Continue;
			EndIf;
			If StrStartsWith(Column.Name, "DELETE_") Then
				Continue;
			EndIf;
			Parent = Form.Items.Find(TabularSection.Name);
			If Parent = Undefined Then
				Continue;
			EndIf;

			NewColumn = Form.Items.Add(Column.Name, Type("FormField"), Parent);
			NewColumn.Type = FormFieldType.InputField;
			NewColumn.DataPath = "Object." + TabularSection.Name + "." + Column.Name;
			If Column.Type = BooleanTypeDescription Then
				NewColumn.Type = FormFieldType.CheckBoxField;
			EndIf;
		EndDo;
	EndDo;
EndProcedure

#EndRegion