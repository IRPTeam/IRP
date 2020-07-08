Procedure BeforeWrite(Cancel)
	User = InfoBaseUsers.FindByName(Description);
	If User = Undefined Then
		User = InfoBaseUsers.CreateUser();
	EndIf;
	User.Name = Description;
	User.FullName = String(ThisObject);
	
	For Each Lang In Metadata.Languages Do
		If TrimAll(Upper(Lang.LanguageCode)) = TrimAll(Upper(InterfaceLocalizationCode)) Then
			User.Language = Lang;
			Break;
		EndIf;
	EndDo;
	
	If AdditionalProperties.Property("Password") AND ValueIsFilled(AdditionalProperties.Password) Then
		User.Password = AdditionalProperties.Password;
	EndIf;
	
	User.ShowInList = ShowInList;
	
	If Not InfoBaseUsers.GetUsers().Count() Then
		
		For Each Role In Metadata.DefaultRoles Do
			User.Roles.Add(Role);
		EndDo;
		
	EndIf;
	
	Settings = SystemSettingsStorage.Load("Common/ClientSettings", , , Description);
	
	If Not Type(Settings) = TypeOf("ClientSettings") Then
		Settings = New ClientSettings;
	EndIf;
			
	ScaleVariant = ClientApplicationFormScaleVariant[?(FormScaleVariant = "", "Auto", FormScaleVariant)];			
			
	Settings.ClientApplicationFormScaleVariant = ScaleVariant;
	SystemSettingsStorage.Save("Common/ClientSettings", , Settings, , Description);
			
	User.Write();
	
	InfobaseUserID = User.UUID;
EndProcedure