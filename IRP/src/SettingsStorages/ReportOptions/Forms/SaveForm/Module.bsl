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

&AtClient
Procedure OnOpen(Cancel)
	ShowMarkedForDeleteReportOptions();
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
	ShowInputString(Notify, "", R().SuggestionToUser_4, 128);
EndProcedure

&AtClient
Procedure ShowMarkedForDeletion(Command)
	Items.OptionsListShowMarkedForDeletion.Check = Not Items.OptionsListShowMarkedForDeletion.Check;
	ShowMarkedForDeleteReportOptions();
EndProcedure

#EndRegion

#Region Private

&AtClient
Procedure SaveSettingAtClient()
	CurrentData = Items.OptionsList.CurrentData;
	If CurrentData = Undefined Then
		Notify = New NotifyDescription("SaveAsEnd", ThisObject);
		ShowInputString(Notify, "", R().SuggestionToUser_3, 150);
	Else
		If CurrentData.Author = SessionParametersServer.GetSessionParameter("CurrentUser") Then
			OptionDescriptionParameters = New Structure();
			OptionDescriptionParameters.Insert("ReportOption", CurrentData.ReportOption);
			OptionDescription = New NotifyDescription("OverwriteQuestionEnd", ThisObject, OptionDescriptionParameters);
			QueryText = R().QuestionToUser_020;
			QueryButtons = QuestionDialogMode.YesNo;
			ShowQueryBox(OptionDescription, QueryText, QueryButtons);
		Else
			OptionDescription = ServiceSystemServer.GetObjectAttribute(CurrentData.ReportOption, "Description");
			AdditionalParameters = New Structure;
			AdditionalParameters.Insert("Description", OptionDescription);
			AdditionalParameters.Insert("Author", CurrentData.Author);
			Notify = New NotifyDescription("SaveAsEnd", ThisObject, AdditionalParameters);
			ShowInputString(Notify, OptionDescription, R().SuggestionToUser_3, 150);
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure SaveAsEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	If TypeOf(AdditionalParameters) = Type("Structure") Then
		If Result = AdditionalParameters.Description Then
			WarningText = StrTemplate(R().Exc_012, AdditionalParameters.Description, AdditionalParameters.Author);
			ShowMessageBox(, WarningText);
			Return;
		EndIf;
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
		Users = GetShareReducers(OptionKey);
		UsersValueList = New ValueList();
		UsersValueList.LoadValues(Users);
		OpenFormParameters = New Structure();
		OpenFormParameters.Insert("Users", UsersValueList);
		OpenForm("CommonForm.ShareToUsers", OpenFormParameters, ThisObject, ThisObject.UUID, , , Notify,
			FormWindowOpeningMode.LockOwnerWindow);
	Else
		CloseForm(OptionKey);
	EndIf;
EndProcedure

&AtServer
Function GetShareReducers(Val OptionKey)
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
	If Users.Count() And Users.Find(SessionParameters.CurrentUser) = Undefined Then
		Users.Add(SessionParameters.CurrentUser);
	EndIf;
	InformationRegisters.SharedReportOptions.SetUsersToReportOption(ReportOption, Users);
EndProcedure

&AtClient
Procedure OverwriteQuestionEnd(Result, AdditionalParameters) Export
	If Result = DialogReturnCode.Yes Then
		OptionDescription = ServiceSystemServer.GetObjectAttribute(AdditionalParameters.ReportOption, "Description");
		SaveChosenSetting(OptionDescription, AdditionalParameters.ReportOption);
	EndIf;
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

&AtClient
Procedure CloseForm(OptionKey)
	Close(GetSettingsChoice(OptionKey));
EndProcedure

&AtServer
Function GetSettingsChoice(Val OptionKey)
	Return New SettingsChoice(OptionKey);
EndFunction

&AtClient
Procedure ShowMarkedForDeleteReportOptions()
	UseDeletionMarkFilter = Items.OptionsListShowMarkedForDeletion.Check;
	LeftValue = New DataCompositionField("DeletionMark");
	EditedFilterItem = Undefined;
	For Each FilterItem In OptionsList.Filter.Items Do
		If FilterItem.LeftValue = LeftValue Then
			EditedFilterItem = FilterItem;
			Break;
		EndIf;
	EndDo;
	If UseDeletionMarkFilter Then
		If EditedFilterItem <> Undefined Then
			OptionsList.Filter.Items.Delete(FilterItem);
		EndIf;
	Else
		If EditedFilterItem = Undefined Then
			EditedFilterItem = OptionsList.Filter.Items.Add(Type("DataCompositionFilterItem"));
		EndIf;
		EditedFilterItem.LeftValue = LeftValue;
		EditedFilterItem.ComparisonType = DataCompositionComparisonType.Equal;
		EditedFilterItem.ViewMode = DataCompositionSettingsItemViewMode.Inaccessible;
		EditedFilterItem.RightValue = False;
	EndIf;
EndProcedure

#EndRegion