
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	
	If Not CheckAdmin() Then
		ShowMessageBox(, R().UsersEvent_003);
	EndIf;	
	
	UserConnectionProperty = GetUserConnectionProperty(CommandParameter);
	
	If UserConnectionProperty = Undefined Then
		ShowMessageBox(, R().UsersEvent_004);
		Return;
	EndIf; 
	
	RunSystem("/N """ + UserConnectionProperty.Name + """ /P " + UserConnectionProperty.Password);
	
	Success = ReturningUserProperties(UserConnectionProperty);
	If Not Success Then
		ShowMessageBox(, R().UsersEvent_005);
	EndIf;
	 
EndProcedure

&AtServer
Function CheckAdmin()
	//@skip-check using-isinrole
	Return IsInRole(Metadata.Roles.FullAccess);
EndFunction
	
&AtServer
Function GetUserConnectionProperty(UserRef)

	UserIB = InfoBaseUsers.FindByUUID(UserRef.InfobaseUserID);
	If UserIB = Undefined Then
		Return Undefined;
	EndIf; 
	
	ConnectionTime = CommonFunctionsServer.GetCurrentSessionDate();
	
	NewPassword = UserSettingsServer.GeneratePassword();
	
	Result = New Structure;
	
	Result.Insert("Name", 					UserIB.Name);
	Result.Insert("Password",				NewPassword);
	Result.Insert("StandardAuthentication", UserIB.StandardAuthentication);
	Result.Insert("StoredPasswordValue", 	UserIB.StoredPasswordValue);
	Result.Insert("ConnectionTime",			ConnectionTime);
	
	UserIB.StandardAuthentication = True;
	UserIB.Password = NewPassword;
	UserIB.Write();
	
	Return Result;

EndFunction // GetUserConnectionProperty()
 
&AtServer
Function ReturningUserProperties(UserConnectionProperty)

	Success = False;
	CheckTime = CurrentDate();
	
	While Not Success Do
		If CurrentDate() - CheckTime > 25 Then // limit the waiting time in seconds
			Break;
		EndIf; 
		
		Sessions = GetInfoBaseSessions();
		For Each Session In Sessions Do
			If Session.SessionStarted >= UserConnectionProperty.ConnectionTime 
					And Session.User <> Undefined 
					And Lower(Session.User.Name) = Lower(UserConnectionProperty.Name) Then
				Success = True;
				Break;
			EndIf; 
		EndDo;
	EndDo;
	
	UserIB = InfoBaseUsers.FindByName(UserConnectionProperty.Name);
	UserIB.StandardAuthentication = UserConnectionProperty.StandardAuthentication;
	UserIB.StoredPasswordValue = UserConnectionProperty.StoredPasswordValue;
	UserIB.Write();
	
	Return Success;

EndFunction // ReturningUserProperties()
