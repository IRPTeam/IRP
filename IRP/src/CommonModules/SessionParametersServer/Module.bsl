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
	If RequiredParameters.Find("Workstation") <> Undefined Then
		SessionParameters.Workstation = Catalogs.Workstations.EmptyRef();
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
			If RequiredParameters.Find("CurrentUserAccessGroupList") <> Undefined Then
				SessionParameters.CurrentUserAccessGroupList = New FixedArray(UsersEvent.GetAccessGroupsByUser(CurrentUser));
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
	If RequiredParameters.Find("RunBackgroundJobInDebugMode") <> Undefined Then
		SessionParameters.RunBackgroundJobInDebugMode = False;
	EndIf;
	If RequiredParameters.Find("IgnoreLockModificationData") <> Undefined Then
		SessionParameters.IgnoreLockModificationData = False;
	EndIf;
	If RequiredParameters.Find("Buffer") <> Undefined Then
		SessionParameters.Buffer = New ValueStorage(New Array);;
	EndIf;
EndProcedure

Function GetSessionParameter(ParameterName) Export
	Return SessionParameters[ParameterName];
EndFunction

Procedure SetSessionParameter(ParameterName, Value) Export
	SessionParameters[ParameterName] = Value;
EndProcedure

Function OurCompanies()
	OurCompanies = New Array();	
	If GetFunctionalOption("UseCompanies") = True Then
		Query = New Query();
		Query.Text = 
		"SELECT ALLOWED
		|	Companies.Ref
		|FROM
		|	Catalog.Companies AS Companies
		|WHERE
		|	Companies.OurCompany";
		QueryUnload = Query.Execute().Unload();
		OurCompanies = QueryUnload.UnloadColumn("Ref");
	Else
		OurCompanies.Add(Catalogs.Companies.Default);
	EndIf;
	Return New FixedArray(OurCompanies);
EndFunction

Procedure SetUserTimeZone() Export
	TimeZone = SessionParameters.CurrentUser.TimeZone;
	If Not IsBlankString(TimeZone) Then
		SetSessionTimeZone(TimeZone);
	EndIf;
EndProcedure
