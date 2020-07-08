&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	ThisObject.Users.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.Users.QueryText);
	ThisObject.Users.Parameters.SetParameterValue("UserGroup", ?(ValueIsFilled(Object.Ref), Object.Ref, Undefined));
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure Settings(Command)
	If Not ValueIsFilled(Object.Ref) Or ThisObject.Modified Then
		Notify = New NotifyDescription("EditUserSettingsProceed", ThisObject);
		ShowQueryBox(Notify, R()["QuestionToUser_001"], QuestionDialogMode.YesNo);
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

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	ThisObject.Users.Parameters.SetParameterValue("UserGroup", Object.Ref);
EndProcedure