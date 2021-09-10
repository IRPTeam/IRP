#Region FormEvents

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	CurrentObject.AdditionalProperties.Insert("Password", Password);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);

	FillExistsLangs();

	If Object.Ref.IsEmpty() Then
		Object.InfobaseUserID = Undefined;
		Object.Description = "";
	EndIf;
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	UpdateRolesInfo(CurrentObject);
EndProcedure

#EndRegion

#Region Privat

&AtServer
Procedure UpdateRolesInfo(CurrentObject)
	User = Undefined;
	If AccessRight("DataAdministration", Metadata) Then
		If ValueIsFilled(CurrentObject.InfobaseUserID) Then
			User = InfoBaseUsers.FindByUUID(CurrentObject.InfobaseUserID);
		ElsIf ValueIsFilled(CurrentObject.Description) Then
			User = InfoBaseUsers.FindByName(CurrentObject.Description);
		EndIf;
	Else
		User = Undefined;
	EndIf;
	If Not User = Undefined Then
		For Each Role In User.Roles Do
			RoleList.Add(Role.Name, Role.Synonym);
		EndDo;
	EndIf;
EndProcedure

&AtServer
Procedure FillExistsLangs()

	For Each Lang In Metadata.Languages Do
		Items.LocalizationCode.ChoiceList.Add(Lower(Lang.LanguageCode), Lang.Synonym);
		Items.InterfaceLocalizationCode.ChoiceList.Add(Lower(Lang.LanguageCode), Lang.Synonym);
	EndDo;

EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure SetPassword(Command)
	OpenArgs = New Structure();
	OpenArgs.Insert("Password", Password);
	OpenForm("Catalog.Users.Form.InputPassword", OpenArgs, ThisObject, , , , New NotifyDescription("SetPasswordFinish",
		ThisObject));
EndProcedure

&AtClient
Procedure SetPasswordFinish(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;

	Password = Result.Password;
EndProcedure

&AtClient
Procedure Settings(Command)
	If Not ValueIsFilled(Object.Ref) Or ThisObject.Modified Then
		Notify = New NotifyDescription("EditUserSettingsProceed", ThisObject);
		ShowQueryBox(Notify, R().QuestionToUser_001, QuestionDialogMode.YesNo);
	Else
		EditUserSettingsProceed(DialogReturnCode.Yes);
	EndIf;
EndProcedure

&AtClient
Procedure EditUserSettingsProceed(Result, AddInfo = Undefined) Export
	If Result = DialogReturnCode.Yes And Write() Then
		OpenForm("CommonForm.EditUserSettings", New Structure("UserOrGroup", Object.Ref), ThisObject);
	EndIf;
EndProcedure
#EndRegion

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

#EndRegion