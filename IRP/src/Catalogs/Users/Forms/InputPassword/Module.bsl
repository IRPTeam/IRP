&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure

&AtClient
Procedure Ok(Command)
	If ThisObject.Password <> ThisObject.ConfirmPassword Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_014, "ConfirmPassword");
		Return;
	ElsIf IsBlankString(ThisObject.Password) Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_015, "Password");
		Return;
	EndIf;
	Close(New Structure("Password", ThisObject.Password));
EndProcedure

&AtClient
Procedure Generate(Command)
	NewPass = UserSettingsServer.GeneratePassword();

	GeneratedValue = NewPass;
	ConfirmPassword = NewPass;
	Password = NewPass;
EndProcedure