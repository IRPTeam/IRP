#Region Public

Procedure CreateUser(UserObject) Export
	If Not IsInRole(Metadata.Roles.FullAccess) And 
			Not IsInRole(Metadata.Roles.CreateOrModifyUsers) And
			Not UserObject.AdditionalProperties.Property("isUpdated") Then
		Raise R().Error_091;
	EndIf;

	If ValueIsFilled(UserObject.InfobaseUserID) Then
		User = InfoBaseUsers.FindByUUID(UserObject.InfobaseUserID);
	ElsIf ValueIsFilled(UserObject.Description) Then
		User = InfoBaseUsers.FindByName(UserObject.Description);
	EndIf;
	If User = Undefined Then
		User = InfoBaseUsers.CreateUser();
	EndIf;
	User.Name = UserObject.Description;
	User.FullName = String(UserObject);
	User.UnsafeOperationProtection.UnsafeOperationWarnings = False;
	For Each Lang In Metadata.Languages Do
		If TrimAll(Upper(Lang.LanguageCode)) = TrimAll(Upper(UserObject.InterfaceLocalizationCode)) Then
			User.Language = Lang;
			Break;
		EndIf;
	EndDo;

	If UserObject.AdditionalProperties.Property("Password") And ValueIsFilled(UserObject.AdditionalProperties.Password) Then
		User.Password = UserObject.AdditionalProperties.Password;
	EndIf;

	User.ShowInList = UserObject.ShowInList;

	If Not InfoBaseUsers.GetUsers().Count() Then
		User.Roles.Clear();
		If Not Saas.isSaasMode() Then
			For Each Row In Metadata.DefaultRoles Do
				User.Roles.Add(Metadata.Roles[Row.Name]);
			EndDo;
		Else
			User.Roles.Add(Metadata.Roles.RunThinClient);
			User.Roles.Add(Metadata.Roles.RunWebClient);
		EndIf;
	EndIf;

	Settings = SystemSettingsStorage.Load("Common/ClientSettings", , , UserObject.Description);

	If Not TypeOf(Settings) = Type("ClientSettings") Then
		Settings = New ClientSettings();
	EndIf;

	ScaleVariant = ClientApplicationFormScaleVariant[?(UserObject.FormScaleVariant = "", "Auto",
		UserObject.FormScaleVariant)];

	Settings.ClientApplicationFormScaleVariant = ScaleVariant;
	SystemSettingsStorage.Save("Common/ClientSettings", , Settings, , UserObject.Description);

	If Saas.isSaasMode() And User.Roles.Contains(Metadata.Roles.FullAccess) Then
		Raise StrTemplate(R().Error_092, Metadata.Roles.FullAccess);
	EndIf;

	User.Write();

	If IsBlankString(UserObject.LocalizationCode) Then
		UserObject.LocalizationCode = Metadata.DefaultLanguage.LanguageCode;
	EndIf;

	If IsBlankString(UserObject.InterfaceLocalizationCode) Then
		UserObject.InterfaceLocalizationCode = Metadata.DefaultLanguage.LanguageCode;
	EndIf;
	UserObject.InfobaseUserID = User.UUID;
EndProcedure

Procedure CommonDataFillingBeforeWrite_Catalogs(Source, Cancel) Export
	
	CommonAttributes = "Author, Editor, CreateDate, ModifyDate";
	CurrentData = New Structure(CommonAttributes, Undefined, Undefined, Date(1,1,1), Date(1,1,1));
	FillPropertyValues(CurrentData, Source);
	
	If Source.Ref.IsEmpty() Then
		CurrentData.Author = SessionParameters.CurrentUser;
		CurrentData.CreateDate = CurrentSessionDate();
	Else
		CurrentData.Editor = SessionParameters.CurrentUser;
		CurrentData.ModifyDate = CurrentSessionDate();
	EndIf;
	
	If Not ValueIsFilled(CurrentData.Author) Then
		CurrentData.Author = SessionParameters.CurrentUser;
		CurrentData.CreateDate = CurrentSessionDate();
	EndIf;
	
	FillPropertyValues(Source, CurrentData);
	
EndProcedure

Procedure CommonDataFilling1BeforeWrite_Documents(Source, Cancel, WriteMode, PostingMode) Export
	CommonDataFillingBeforeWrite_Catalogs(Source, Cancel);
EndProcedure

#EndRegion
