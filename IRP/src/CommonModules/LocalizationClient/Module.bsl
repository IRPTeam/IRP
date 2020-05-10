Procedure DescriptionOpening(Object, Form, Item, StandardProcessing) Export
	StandardProcessing = False;
	OpenArgs = New Structure("Values", New Structure());
	
	For Each Attribute In LocalizationReuse.AllDescription() Do
		If "Description_" + LocalizationReuse.GetLocalizationCode() = Attribute Then
			OpenArgs.Values.Insert(Attribute, Form.Items[Attribute].EditText);
		Else
			OpenArgs.Values.Insert(Attribute, Object[Attribute]);
		EndIf;
	EndDo;
	
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("Object", Object);
	AdditionalParameters.Insert("Form", Form);
	
	OpenForm("CommonForm.EditDescriptions"
		, OpenArgs
		, Form, , ,
		, New NotifyDescription("DescriptionEditEnd", ThisObject, AdditionalParameters));
	
EndProcedure

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

Procedure OpenFirstStartSettingsForm() Export

	OpenForm("DataProcessor.FirstStartSettings.Form.Form", , , , , , , FormWindowOpeningMode.LockWholeInterface);

EndProcedure
