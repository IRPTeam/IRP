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
	ElementParent = Undefined;
	
	If Not ItemElement = Undefined Then
		If TypeOf(ItemElement) = Type("FormGroup") Then
			If ItemElement.Type = FormGroupType.Pages Then
				ElementParent  = Form.Items.Add("ExtAttributes", Type("FormGroup"), ItemElement);
				ElementParent.Type = FormGroupType.Page;
				ElementParent.Title = R().Form_029;
			ElsIf ItemElement.Type = FormGroupType.Page OR
				ItemElement.Type = FormGroupType.UsualGroup Then
				ElementParent = ItemElement;
			EndIf;
		EndIf;
	EndIf;
	
	ObjectMetadata = Metadata.FindByType(TypeOf(MetaTypeOrRef));
	
	For Each Attribute In ObjectMetadata.Attributes Do
		If Not StrFind(Attribute.Name, "_") Then 
			Continue;
		EndIf;
		
		OverrideInfo = OverrideElementParentInExtension(MetaTypeOrRef, Attribute.Name);
		Parent = Undefined;
		
		If OverrideInfo <> Undefined And ValueIsFilled(OverrideInfo.ParentName) Then
			Parent = Form.Items[OverrideInfo.ParentName];
		ElsIf ElementParent <> Undefined Then
			Parent = ElementParent;
		Else
			Parent = Form;
		EndIf;
		
		NewAttribute = Form.Items.Add(Attribute.Name, Type("FormField"), Parent);
		NewAttribute.Type = FormFieldType.InputField;
		NewAttribute.DataPath = "Object." + Attribute.Name;
	EndDo;
	
	For Each TabularSection In ObjectMetadata.TabularSections Do
		For Each Column In TabularSection.Attributes Do
			If Not StrFind(Column.Name, "_") Then 
				Continue;
			EndIf;
			Parent = Form.Items.Find(TabularSection.Name);
			If Parent = Undefined Then
				Continue;
			EndIf;
			
			NewColumn = Form.Items.Add(Column.Name, Type("FormField"), Parent);
			NewColumn.Type = FormFieldType.InputField;
			NewColumn.DataPath = "Object." + TabularSection.Name +"."+ Column.Name;
		EndDo;
	EndDo;
	
EndProcedure

Function OverrideElementParentInExtension(Ref, AttributeName)
	Return New Structure("ParentName");
EndFunction

#EndRegion
