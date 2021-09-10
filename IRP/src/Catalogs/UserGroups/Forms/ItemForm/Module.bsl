#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	ThisObject.Users.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.Users.QueryText);
	ThisObject.Users.Parameters.SetParameterValue("UserGroup", ?(ValueIsFilled(Object.Ref), Object.Ref, Undefined));
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	ThisObject.Users.Parameters.SetParameterValue("UserGroup", Object.Ref);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
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

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
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