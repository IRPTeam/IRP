Procedure SessionParametersSetting(RequiredParameters) Export

	If RequiredParameters = Undefined Then
		SessionParameters.ConnectionSettings = Catalogs.DataBaseStatus.GetOrCreateDataBaseStatusInfo();
		StyleName = SessionParameters.ConnectionSettings.SelectedStyle;
		If Not Metadata.Styles.Find(StyleName) = Undefined Then
			MainStyle = StyleLib[StyleName];
		EndIf;

		Return;
	EndIf;

	If RequiredParameters.Find("LocalizationCode") <> Undefined Then
		SessionParameters.LocalizationCode = Metadata.DefaultLanguage.LanguageCode;
	EndIf;
	If RequiredParameters.Find("InterfaceLocalizationCode") <> Undefined Then
		SessionParameters.InterfaceLocalizationCode = Metadata.DefaultLanguage.LanguageCode;
	EndIf;
	If RequiredParameters.Find("OurCompanies") <> Undefined Then
		SessionParameters.OurCompanies = OurCompanies();
	EndIf;
	If Saas.isAreaActive() Then
		CurrentUser = UsersEvent.SessionParametersSetCurrentUser();
		If RequiredParameters.Find("CurrentUser") <> Undefined Then
			SessionParameters.CurrentUser = CurrentUser;
		EndIf;
		If RequiredParameters.Find("CurrentUserPartner") <> Undefined Then
			SessionParameters.CurrentUserPartner = CurrentUser.Partner;
		EndIf;
		If CurrentUser.isEmpty() Then
			If RequiredParameters.Find("LocalizationCode") <> Undefined Then
				SessionParameters.LocalizationCode = Metadata.DefaultLanguage.LanguageCode;
			EndIf;
			If RequiredParameters.Find("InterfaceLocalizationCode") <> Undefined Then
				SessionParameters.InterfaceLocalizationCode = Metadata.DefaultLanguage.LanguageCode;
			EndIf;
		Else
			If RequiredParameters.Find("LocalizationCode") <> Undefined Then
				SessionParameters.LocalizationCode = CurrentUser.LocalizationCode;
			EndIf;
			If RequiredParameters.Find("InterfaceLocalizationCode") <> Undefined Then
				SessionParameters.InterfaceLocalizationCode = CurrentUser.InterfaceLocalizationCode;
			EndIf;
		EndIf;
	Else
		If RequiredParameters.Find("CurrentUser") <> Undefined Then
			SessionParameters.CurrentUser = Catalogs.Users.EmptyRef();
		EndIf;
		If RequiredParameters.Find("LocalizationCode") <> Undefined Then
			SessionParameters.LocalizationCode = Metadata.DefaultLanguage.LanguageCode;
		EndIf;
		If RequiredParameters.Find("InterfaceLocalizationCode") <> Undefined Then
			SessionParameters.InterfaceLocalizationCode = Metadata.DefaultLanguage.LanguageCode;
		EndIf;
		If RequiredParameters.Find("CurrentUserPartner") <> Undefined Then
			SessionParameters.CurrentUserPartner = Catalogs.Partners.EmptyRef();
		EndIf;
	EndIf;
	If RequiredParameters.Find("ConnectedAddDataProc") <> Undefined Then
		SessionParameters.ConnectedAddDataProc = New FixedStructure();
	EndIf;
EndProcedure

Function GetSessionParameter(ParameterName) Export
	Return SessionParameters[ParameterName];
EndFunction

Function OurCompanies()
	OurCompanies = New Array();
	Query = New Query();
	Query.Text = "SELECT ALLOWED
				 |	Companies.Ref
				 |FROM
				 |	Catalog.Companies AS Companies
				 |WHERE
				 |	Companies.OurCompany";
	QueryUnload = Query.Execute().Unload();
	OurCompanies = QueryUnload.UnloadColumn("Ref");
	Return New FixedArray(OurCompanies);
EndFunction