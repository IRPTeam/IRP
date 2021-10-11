// @strict-types

// Description opening.
// 
// Parameters:
//  Object - FormDataStructure - Object
//  Form - ClientApplicationForm - Form
//  Item - FormField - Item
//  StandardProcessing - Boolean - Standard processing
Procedure DescriptionOpening(Object, Form, Item, StandardProcessing) Export
	StandardProcessing = False;
	OpenArgs = New Structure("Values", New Structure());

	For Each Attribute In LocalizationReuse.AllDescription() Do
		If "Description_" + LocalizationReuse.GetLocalizationCode() = Attribute Then
			FormItem = Form.Items.Find(Attribute); // FormFieldExtensionForATextBox
			OpenArgs.Values.Insert(Attribute, FormItem.EditText);
		Else
			OpenArgs.Values.Insert(Attribute, Object[Attribute]);
		EndIf;
	EndDo;

	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("Object", Object);
	AdditionalParameters.Insert("Form", Form);

	OpenForm("CommonForm.EditDescriptions", OpenArgs, Form, , , , New NotifyDescription("DescriptionEditEnd",
		ThisObject, AdditionalParameters));

EndProcedure

// Description edit end.
// 
// Parameters:
//  Result - Undefined, Structure - Result
//  AdditionalParameters - Structure - Additional parameters:
//  	* Object - FormDataStructure - Object
//  	* Form - ClientApplicationForm - Form
Procedure DescriptionEditEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	For Each KeyValue In Result Do
		If AdditionalParameters.Object[KeyValue.Key] <> KeyValue.Value Then
			AdditionalParameters.Object[KeyValue.Key] = KeyValue.Value;
			AdditionalParameters.Form.Modified = True;
		EndIf;
	EndDo;
EndProcedure