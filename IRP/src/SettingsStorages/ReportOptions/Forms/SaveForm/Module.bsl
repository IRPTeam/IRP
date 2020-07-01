
#Region Events

#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.ObjectKey = Parameters.ObjectKey;
	ThisObject.CurrentSettingsKey = Parameters.CurrentSettingsKey;
	UserGroups = CatUserGroupsServer.GetUserGroupsByUser(SessionParameters.CurrentUser);
	
	OptionsList.Parameters.SetParameterValue("ObjectKey", ThisObject.ObjectKey);
	OptionsList.Parameters.SetParameterValue("CurrentSettingsKey", ThisObject.CurrentSettingsKey);
	OptionsList.Parameters.SetParameterValue("Author", SessionParameters.CurrentUser);
	OptionsList.Parameters.SetParameterValue("GroupsList", UserGroups);
		
	Items.OptionsList.CurrentRow = Catalogs.ReportOptions.FindByCode(ThisObject.CurrentSettingsKey);	
EndProcedure

#EndRegion

#Region ItemsEvents

&AtClient
Procedure OptionsListSelection(Item, RowSelected, Field, StandardProcessing)
	SaveSettingAtClient();
EndProcedure

#EndRegion

#EndRegion

#Region Commands

&AtClient
Procedure SaveSetting(Command)
	SaveSettingAtClient();
EndProcedure

&AtClient
Procedure SaveAs(Command)
	Notify = New NotifyDescription("SaveAsEnd", ThisObject);
	ShowInputString(Notify, "", "New option name", 128);
EndProcedure

#EndRegion

#Region Private

&AtClient
Procedure SaveSettingAtClient()
	Notify = New NotifyDescription("SaveAsEnd", ThisObject);
	CurrentData = Items.OptionsList.CurrentData;
	If CurrentData = Undefined Then
		ShowInputString(Notify, "", "Option name", 150);
	Else
		OptionDescription = ServiceSystemServer.GetObjectAttribute(CurrentData.ReportOption, "Description");
		If CurrentData.Author <> SessionParametersClientServer.GetSessionParameter("CurrentUser") Then 
			ShowInputString(Notify, OptionDescription, "Option name", 150);
		Else
			SaveChoosenSetting(OptionDescription, CurrentData.ReportOption);
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure SaveAsEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	SaveChoosenSetting(Result);
EndProcedure

&AtClient
Procedure SaveChoosenSetting(Val OptionDescription, Val ReportOption = Undefined)
	OptionKey = SaveChoosenSettingAtServer(OptionDescription, ReportOption);
	If ThisObject.SetShare Then
		NotifyParameters = New Structure();
		NotifyParameters.Insert("OptionKey", OptionKey);
		Notify = New NotifyDescription("ShareEnd", ThisObject, NotifyParameters);
		Users = GetSharedUsers(OptionKey);
		UsersValueList = New ValueList();
		UsersValueList.LoadValues(Users);
		UserGroups = GetSharedUserGroups(OptionKey);
		UserGroupsValueList = New ValueList();
		UserGroupsValueList.LoadValues(UserGroups);
		OpenFormParameters = New Structure();
		OpenFormParameters.Insert("UseUsers", True);
		OpenFormParameters.Insert("Users", UsersValueList);
		OpenFormParameters.Insert("UseUserGroups", True);
		OpenFormParameters.Insert("UserGroups", UserGroupsValueList);
		OpenForm("CommonForm.ShareToUserAndUserGroups", OpenFormParameters, ThisObject, ThisObject.UUID, , , Notify, FormWindowOpeningMode.LockOwnerWindow);
	Else
		CloseForm(OptionKey);
	EndIf;	
EndProcedure

&AtServer
Function GetSharedUsers(Val OptionKey)
	ReportOption = Catalogs.ReportOptions.FindByCode(OptionKey);
	Return InformationRegisters.SharedReportOptions.GetUsersByReportOption(ReportOption);
EndFunction

&AtServer
Function GetSharedUserGroups(Val OptionKey)
	ReportOption = Catalogs.ReportOptions.FindByCode(OptionKey);
	Return InformationRegisters.SharedReportOptions.GetUserGroupsByReportOption(ReportOption);
EndFunction

&AtClient
Procedure ShareEnd(Result, AdditionalParameters) Export
	If Result <> Undefined Then
		ShareEndAtServer(AdditionalParameters.OptionKey, Result);
	EndIf;
	CloseForm(AdditionalParameters.OptionKey);
EndProcedure

&AtServer
Procedure ShareEndAtServer(Val OptionKey, Val Parameters)
	ReportOption = Catalogs.ReportOptions.FindByCode(OptionKey);
	Users = Parameters.Users.UnloadValues();
	If Users.Count() > 1
		And Users.Find(SessionParameters.CurrentUser) = Undefined Then
		Users.Add(SessionParameters.CurrentUser);
	EndIf;
	InformationRegisters.SharedReportOptions.SetUsersToReportOption(ReportOption, Users);
EndProcedure

&AtClient
Procedure CloseForm(OptionKey)
	Close(New SettingsChoice(OptionKey));
EndProcedure

&AtServer
Function SaveChoosenSettingAtServer(Val OptionDescription, Val ReportOption)
	If ReportOption = Undefined Then
		OptionKey = New UUID();
		ReportOptionObj = Catalogs.ReportOptions.CreateItem();
		ReportOptionObj.Code = OptionKey;
		ReportOptionObj.Description = OptionDescription;
		ReportOptionObj.ObjectKey = ThisObject.ObjectKey;
		ReportOptionObj.Author = SessionParameters.CurrentUser;
		ReportOptionObj.Write();
	Else
		OptionKey = ReportOption.Code;
	EndIf;	
	Return OptionKey;
EndFunction

#EndRegion
