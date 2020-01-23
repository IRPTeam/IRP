Procedure OpenMobileFormFormGetProcessing(Source, FormType, Parameters, SelectedForm, AdditionalInfo, StandardProcessing) Export
	If SessionParameters.isMobile Then
		// Check - is this standart form name
		If ValueIsFilled(FormType) Then
			MetaObject = Metadata.FindByType(Type(Source));
			StandartForm = MetaObject["Default" + FormType];
			If NOT StandartForm = Undefined Then
				MobileForm = MetaObject.Forms.Find(StandartForm.Name + "Mobile");
				If NOT MobileForm = Undefined Then
					SelectedForm = MobileForm;
					StandardProcessing = False;
				EndIf;
			EndIf;
		EndIf;
	EndIf;
EndProcedure

