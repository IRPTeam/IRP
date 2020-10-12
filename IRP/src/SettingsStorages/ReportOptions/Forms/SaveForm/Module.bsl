
#Region Events

#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.ObjectKey = Parameters.ObjectKey;
	ThisObject.CurrentSettingsKey = Parameters.CurrentSettingsKey;
	
	OptionsList.Parameters.SetParameterValue("ObjectKey", ThisObject.ObjectKey);
	OptionsList.Parameters.SetParameterValue("CurrentSettingsKey", ThisObject.CurrentSettingsKey);
	OptionsList.Parameters.SetParameterValue("Author", SessionParameters.CurrentUser);
		
	Items.OptionsList.CurrentRow = Catalogs.ReportOptions.FindByCode(ThisObject.CurrentSettingsKey);	
EndProcedure

#EndRegion

#Region ItemsEvents

&AtClient
Procedure OptionsListSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
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
	ShowInputString(Notify, "", R().SuggestionToUser_4 , 128);
EndProcedure

#EndRegion

#Region Private

&AtClient
Procedure SaveSettingAtClient()
	Notify = New NotifyDescription("SaveAsEnd", ThisObject);
	CurrentData = Items.OptionsList.CurrentData;
	If CurrentData = Undefined Then
		ShowInputString(Notify, "", R().SuggestionToUser_3, 150);
	Else
		OptionDescription = ServiceSystemServer.GetObjectAttribute(CurrentData.ReportOption, "Description");
		If CurrentData.Author <> SessionParametersClientServer.GetSessionParameter("CurrentUser") Then 
			ShowInputString(Notify, OptionDescription, R().SuggestionToUser_3, 150);
		Else
			SaveChosenSetting(OptionDescription, CurrentData.ReportOption);
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure SaveAsEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	SaveChosenSetting(Result);
EndProcedure

&AtClient
Procedure SaveChosenSetting(Val OptionDescription, Val ReportOption = Undefined)
	OptionKey = SaveChosenSettingAtServer(OptionDescription, ReportOption);
	If ThisObject.SetShare Then
		NotifyParameters = New Structure();
		NotifyParameters.Insert("OptionKey", OptionKey);
		Notify = New NotifyDescription("ShareEnd", ThisObject, NotifyParameters);
		Users = GetSharedUsers(OptionKey);
		UsersValueList = New ValueList();
		UsersValueList.LoadValues(Users);
		OpenFormParameters = New Structure();
		OpenFormParameters.Insert("Users", UsersValueList);
		OpenForm("CommonForm.ShareToUsers", OpenFormParameters, ThisObject, ThisObject.UUID, , , Notify, FormWindowOpeningMode.LockOwnerWindow);
	Else
		CloseForm(OptionKey);
	EndIf;	
EndProcedure

&AtServer
Function GetSharedUsers(Val OptionKey)
	ReportOption = Catalogs.ReportOptions.FindByCode(OptionKey);
	Return InformationRegisters.SharedReportOptions.GetUsersByReportOption(ReportOption);
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
	If Users.Count()
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
Function SaveChosenSettingAtServer(Val OptionDescription, Val ReportOption)
	If ReportOption = Undefined Then
		OptionKey = String(New UUID());
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
