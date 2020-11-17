Procedure UpdateUsersRoleOnWrite(Source, Cancel) Export
	If Cancel Then
		Return;
	EndIf;
	
	If Source.DataExchange.Load Then
		Return;
	EndIf;
	
	If TypeOf(Source) = Type("CatalogObject.AccessGroups") Then
		Result = UpdateUsersRolesByGroup(Source);
	ElsIf TypeOf(Source) = Type("CatalogObject.AccessProfiles") Then
		If Source.IsNew() Then
			Return;
		EndIf;
		Result = UpdateUsersRole(Source.Ref);
	EndIf;
	If Source.AdditionalProperties.Property("UsersEventOnWriteResult") Then
		Source.AdditionalProperties["UsersEventOnWriteResult"] = Result;
	Else
		Source.AdditionalProperties.Insert("UsersEventOnWriteResult", Result);
	EndIf;
EndProcedure

Function UpdateUsersRolesByGroup(AccessGroup)
	
	UpdateUsersRole(AccessGroup.Profiles.UnloadColumn("Profile"));
	
	Return Undefined;
	
EndFunction

Function UpdateUsersRole(AccessProfile)
	Result = New Structure();
	Result.Insert("Success", True);
	Result.Insert("ArrayOfResults", New Array());
	
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
	Query.SetParameter("Profile", AccessProfile);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	While QuerySelection.Next() Do
		User = Undefined;
		If ValueIsFilled(QuerySelection.User.InfobaseUserID) Then
			User = InfoBaseUsers.FindByUUID(QuerySelection.User.InfobaseUserID);
		ElsIf ValueIsFilled(QuerySelection.User.Description) Then
			User = InfoBaseUsers.FindByName(QuerySelection.User.Description);
		EndIf;
		If User = Undefined Then
			Result.Success = False;
			Result.ArrayOfResults.Add(New Structure("Success, Message", False,
					StrTemplate(R().UsersEvent_001, QuerySelection.User.InfobaseUserID, QuerySelection.User.Description)));
		Else
			Result.ArrayOfResults.Add(New Structure("Success, Message", True,
					StrTemplate(R().UsersEvent_002, QuerySelection.User.InfobaseUserID, QuerySelection.User.Description)));
			User.Roles.Clear();
			If TypeOf(AccessProfile) = Type("Array") Then 
				For Each Profile In AccessProfile Do
					AddRoles(Profile.Roles, User);
				EndDo;
			Else
				AddRoles(AccessProfile.Roles, User);
			EndIf;
			User.Write();
		EndIf;
	EndDo;
	Return Result;
EndFunction

Procedure AddRoles(Roles, User)
	For Each Row In Roles Do
		MetadataRole = Metadata.Roles.Find(Row.Role);
		If MetadataRole <> Undefined Then
			User.Roles.Add(MetadataRole);
		EndIf;
	EndDo;
EndProcedure

Function SessionParametersSetCurrentUser() Export
	
	CurrentInfobaseUser = InfobaseUsers.CurrentUser();
	InfobaseUserName	= CurrentInfobaseUser.Name;
	InfobaseUserID		= CurrentInfobaseUser.UUID;

	If NOT ValueIsFilled(InfobaseUserName) Then
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
		If  NOT CurrentInfobaseUser.Language = Undefined Then
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
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	AccessGroups.Ref
		|FROM
		|	Catalog.AccessGroups AS AccessGroups
		|WHERE
		|	NOT AccessGroups.DeletionMark";
	
	QueryResult = Query.Execute();
	
	SelectionDetailRecords = QueryResult.Select();
	
	While SelectionDetailRecords.Next() Do
		 Result = UpdateUsersRolesByGroup(SelectionDetailRecords.Ref);
	EndDo;

EndProcedure