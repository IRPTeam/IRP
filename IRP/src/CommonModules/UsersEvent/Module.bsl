Procedure UpdateUsersRoleOnWrite(Source, Cancel) Export
	If Cancel Then
		Return;
	EndIf;

	If Source.DataExchange.Load Then
		Return;
	EndIf;

	Users = New Array();

	If TypeOf(Source) = Type("CatalogObject.AccessGroups") Then
		Users = Source.Users.Unload();
		If Not Source.IsNew() And Source.AdditionalProperties.Property("OldUsersList") Then
			For Each User In Source.AdditionalProperties.OldUsersList Do
				NewRow = Users.Add();
				NewRow.User = User;
			EndDo;
			Users.GroupBy("User");
		EndIf;
		Users = Users.UnloadColumn("User");
	ElsIf TypeOf(Source) = Type("CatalogObject.AccessProfiles") Then
		If Source.IsNew() Then
			Return;
		EndIf;
		Query = New Query();
		Query.Text =
		"SELECT
		|	AccessGroupsProfiles.Ref
		|INTO vt_AccessGroups
		|FROM
		|	Catalog.AccessGroups.Profiles AS AccessGroupsProfiles
		|WHERE
		|	AccessGroupsProfiles.Profile In (&Profile)
		|GROUP BY
		|	AccessGroupsProfiles.Ref
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	AccessGroupsUsers.User
		|FROM
		|	Catalog.AccessGroups.Users AS AccessGroupsUsers
		|		INNER JOIN vt_AccessGroups AS vt_AccessGroups
		|		ON AccessGroupsUsers.Ref = vt_AccessGroups.Ref
		|GROUP BY
		|	AccessGroupsUsers.User";
		Query.SetParameter("Profile", Source.Ref);

		Users = Query.Execute().Unload().UnloadColumn("User");
	EndIf;
	Result = UpdateUsersRole(Users);
	If Source.AdditionalProperties.Property("UsersEventOnWriteResult") Then
		Source.AdditionalProperties["UsersEventOnWriteResult"] = Result;
	Else
		Source.AdditionalProperties.Insert("UsersEventOnWriteResult", Result);
	EndIf;
EndProcedure

Function UpdateUsersRole(Users)
	Result = New Structure();
	Result.Insert("Success", True);
	Result.Insert("ArrayOfResults", New Array());
	For Each User In Users Do
		UpdateUserRole(User, Result);
	EndDo;
	Return Result;
EndFunction

Function UpdateUserRole(User, Result)
	UserIB = Undefined;
	If ValueIsFilled(User.InfobaseUserID) Then
		UserIB = InfoBaseUsers.FindByUUID(User.InfobaseUserID);
	ElsIf ValueIsFilled(User.Description) Then
		UserIB = InfoBaseUsers.FindByName(User.Description);
	EndIf;
	If UserIB = Undefined Then
		Result.Success = False;
		Result.ArrayOfResults.Add(New Structure("Success, Message", False, StrTemplate(R().UsersEvent_001,
			User.InfobaseUserID, User.Description)));
	Else
		Result.ArrayOfResults.Add(New Structure("Success, Message", True, StrTemplate(R().UsersEvent_002,
			User.InfobaseUserID, User.Description)));
		UserIB.Roles.Clear();
		Roles = GetUserRoles(User);
		AddRoles(Roles, UserIB);
		UserIB.Write();
	EndIf;

	Return Result;
EndFunction

Function GetUserRoles(User)

	Query = New Query();
	Query.Text =
	"SELECT DISTINCT
	|	AccessGroupsProfiles.Profile
	|INTO Profiles
	|FROM
	|	Catalog.AccessGroups.Profiles AS AccessGroupsProfiles
	|WHERE
	|	AccessGroupsProfiles.Ref IN
	|		(SELECT DISTINCT
	|			AccessGroupsUsers.Ref AS AccessGroup
	|		FROM
	|			Catalog.AccessGroups.Users AS AccessGroupsUsers
	|		WHERE
	|			AccessGroupsUsers.User = &User)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	AccessProfilesRoles.Role
	|FROM
	|	Catalog.AccessProfiles.Roles AS AccessProfilesRoles
	|		INNER JOIN Profiles AS Profiles
	|		ON Profiles.Profile = AccessProfilesRoles.Ref";

	Query.SetParameter("User", User);

	Roles = Query.Execute().Unload().UnloadColumn("Role");
	Return Roles;
EndFunction

Procedure AddRoles(Roles, User)
	For Each Role In Roles Do
		MetadataRole = Metadata.Roles.Find(Role);
		If MetadataRole <> Undefined Then
			User.Roles.Add(MetadataRole);
		EndIf;
	EndDo;
EndProcedure

Function SessionParametersSetCurrentUser() Export

	CurrentInfobaseUser = InfobaseUsers.CurrentUser();
	InfobaseUserName	= CurrentInfobaseUser.Name;
	InfobaseUserID		= CurrentInfobaseUser.UUID;

	If Not ValueIsFilled(InfobaseUserName) Then
		Return Catalogs.Users.EmptyRef();
	EndIf;
		
	// If Saas Admin
	If Saas.isSaasMode() And Not CurrentInfobaseUser.DataSeparation.Count() Then
		Return Catalogs.Users.EmptyRef();
	EndIf;

	FoundUser = Catalogs.Users.FindByAttribute("InfobaseUserID", InfobaseUserID);
	If FoundUser.IsEmpty() Then
		// try find via name, if user was created in designer mode
		FoundUser = Catalogs.Users.FindByDescription(InfobaseUserName, True);
		If FoundUser.IsEmpty() Then
			FoundUserObject = Catalogs.Users.CreateItem();
			FoundUserObject.Description = InfobaseUserName;
		Else
			FoundUserObject = FoundUser.GetObject();
		EndIf;
		If Not CurrentInfobaseUser.Language = Undefined Then
			FoundUserObject.LocalizationCode = CurrentInfobaseUser.Language.LanguageCode;
		Else
			FoundUserObject.LocalizationCode = Metadata.DefaultLanguage.LanguageCode;
		EndIf;
		FoundUserObject.InfobaseUserID = InfobaseUserID;
		FoundUserObject.Write();
		FoundUser = FoundUserObject.Ref;
	EndIf;
	Return FoundUser;

EndFunction

Procedure UpdateAllUsersRolesViaAccessGroups() Export

	Query = New Query();
	Query.Text =
	"SELECT DISTINCT
	|	AccessGroupsUsers.User
	|FROM
	|	Catalog.AccessGroups.Users AS AccessGroupsUsers";

	Users = Query.Execute().Unload().UnloadColumn("User");

	UpdateUsersRole(Users);

EndProcedure

Function GetAccessGroupsByUser(User = Undefined) Export

	If User = Undefined Then
		User = SessionParameters.CurrentUser;
	EndIf;

	Query = New Query();
	Query.Text =
	"SELECT DISTINCT
	|	AccessGroupsUsers.Ref
	|FROM
	|	Catalog.AccessGroups.Users AS AccessGroupsUsers
	|WHERE
	|	AccessGroupsUsers.User = &User";
	Query.Parameters.Insert("User", User);
	Users = Query.Execute().Unload().UnloadColumn("Ref");
	Return Users
EndFunction