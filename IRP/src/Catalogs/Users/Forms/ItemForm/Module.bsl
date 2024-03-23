// @strict-types

#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);

	FillExistsLangs();

	If Object.Ref.IsEmpty() Then
		Object.InfobaseUserID = Undefined;
		Object.Description = "";
	EndIf;
	
	Items.TimeZone.ChoiceList.Clear();
	For Each Zone In GetAvailableTimeZones() Do
		Items.TimeZone.ChoiceList.Add(String(Zone));
	EndDo;
	
	If SessionParameters.CurrentUser = Object.Ref Then
		TimeZone = SessionTimeZone();
		If Not IsBlankString(TimeZone) And Not TimeZone = Object.TimeZone Then
			Object.TimeZone = TimeZone;
		EndIf;
	EndIf;
	
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	If Not IsBlankString(Password) Then
		CurrentObject.AdditionalProperties.Insert("Password", Password);
	EndIf;
EndProcedure

// Notification processing.
// 
// Parameters:
//  EventName - String - Event name
//  Parameter - Undefined - Parameter
//  Source - Undefined - Source
//  AddInfo - Undefined - Add info
&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	UpdateRolesInfo(CurrentObject);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	UpdateRolesInfo(CurrentObject);
	
	If SessionParameters.CurrentUser = Object.Ref 
		And Not Object.TimeZone = SessionTimeZone() Then
		SetSessionTimeZone(Object.TimeZone);
	EndIf;
	
	Password = "";
EndProcedure

#EndRegion

#Region Privat

&AtServer
Procedure UpdateRolesInfo(CurrentObject)
	RoleList.Clear();
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

// Description opening.
// 
// Parameters:
//  Item - FormField - Item
//  StandardProcessing - Boolean - Standard processing
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

// Set password finish.
// 
// Parameters:
//  Result - Structure:
//  * Password - String
//  AdditionalParameters - Undefined - Additional parameters
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
		//@skip-check property-return-type
		//@skip-check invocation-parameter-type-intersect
		ShowQueryBox(Notify, R().QuestionToUser_001, QuestionDialogMode.YesNo);
	Else
		EditUserSettingsProceed(DialogReturnCode.Yes);
	EndIf;
EndProcedure

// Edit user settings proceed.
// 
// Parameters:
//  Result - DialogReturnCode - Result
//  AddInfo - Undefined - Add info
&AtClient
Procedure EditUserSettingsProceed(Result, AddInfo = Undefined) Export
	If Result = DialogReturnCode.Yes And Write() Then
		OpenForm("CommonForm.EditUserSettings", New Structure("UserOrGroup", Object.Ref), ThisObject);
	EndIf;
EndProcedure
#EndRegion

#Region AddAttributes

// Add attribute start choice.
// 
// Parameters:
//  Item - FormField - Item
//  ChoiceData - ValueList - Choice data
//  StandardProcessing - Boolean - Standard processing
&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

// Add attribute button click.
// 
// Parameters:
//  Item - FormField - Item
&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion

#Region COMMANDS

// Generated form command action by name.
// 
// Parameters:
//  Command - CommandBarButton - Command
&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

// Internal command action.
// 
// Parameters:
//  Command - CommandBarButton - Command
&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

// Internal command action with server context.
// 
// Parameters:
//  Command - CommandBarButton - Command
&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

#EndRegion