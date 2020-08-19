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
Procedure AddAtributesFromExtensions(Form, Ref, ItemElement = Undefined) Export
	ElementParent = Undefined;
	
	If Not ItemElement = Undefined Then
		If TypeOf(ItemElement) = Type("FormGroup") Then
			If ItemElement.Type = FormGroupType.Pages Then
				ElementParent  = Form.ThisForm.Items.Add("ExtAttributes", Type("FormGroup"), ItemElement);
				ElementParent.Type = FormGroupType.Page;
				ElementParent.Title = R().Form_029;
			ElsIf ItemElement.Type = FormGroupType.Page OR
				ItemElement.Type = FormGroupType.UsualGroup Then
				ElementParent = ItemElement;
			EndIf;
		EndIf;
	EndIf;
	
	If ElementParent = Undefined Then
		ElementParent = Form.ThisForm;
	EndIf;
	
	Attributes = Metadata.FindByType(TypeOf(Ref)).Attributes;

	For Each Attribute In Attributes Do
		If Not StrFind(Attribute.Name, "_") Then 
			Continue;
		EndIf;
		NewAttribute = Form.ThisForm.Items.Add(Attribute.Name, Type("FormField"), ElementParent);
		NewAttribute.Type = FormFieldType.InputField;
		NewAttribute.DataPath = "Object." + Attribute.Name;
	EndDo;
	
EndProcedure
#EndRegion