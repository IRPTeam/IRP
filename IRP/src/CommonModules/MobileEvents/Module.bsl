Procedure OpenMobileFormFormGetProcessing(Source, FormType, Parameters, SelectedForm, AdditionalInfo,
	StandardProcessing) Export
	If SessionParameters.isMobile Then
		// Check - is this Standard form name
		If ValueIsFilled(FormType) Then
			MetaObject = Metadata.FindByType(Type(Source));
			StandardForm = MetaObject["Default" + FormType];
			If Not StandardForm = Undefined Then
				MobileForm = MetaObject.Forms.Find(StandardForm.Name + "Mobile");
				If Not MobileForm = Undefined Then
					SelectedForm = MobileForm;
					StandardProcessing = False;
				EndIf;
			EndIf;
		EndIf;
	EndIf;
EndProcedure