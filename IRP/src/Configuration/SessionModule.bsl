Procedure SessionParametersSetting(RequiredParameters)
	SessionParameters.LocalizationCode = Metadata.DefaultLanguage.LanguageCode;
	SessionParameters.InterfaceLocalizationCode = Metadata.DefaultLanguage.LanguageCode;
	If Saas.isAreaActive() Then
		CurrentUser = UsersEvent.SessionParametersSetCurrentUser();		
		SessionParameters.CurrentUser = CurrentUser;
		SessionParameters.CurrentUserPartner = CurrentUser.Partner;
		If CurrentUser.isEmpty() Then
			SessionParameters.LocalizationCode = Metadata.DefaultLanguage.LanguageCode;
			SessionParameters.InterfaceLocalizationCode = Metadata.DefaultLanguage.LanguageCode;
		Else
			SessionParameters.LocalizationCode = CurrentUser.LocalizationCode;
			SessionParameters.InterfaceLocalizationCode = CurrentUser.InterfaceLocalizationCode;
		EndIf;
	Else
		SessionParameters.CurrentUser = Catalogs.Users.EmptyRef();
		SessionParameters.LocalizationCode = Metadata.DefaultLanguage.LanguageCode;
		SessionParameters.InterfaceLocalizationCode = Metadata.DefaultLanguage.LanguageCode;
		SessionParameters.CurrentUserPartner = Catalogs.Partners.EmptyRef();
	EndIf;
	
	SessionParameters.ConnectedAddDataProc = New FixedStructure;
EndProcedure

