&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure SetPassword(Command)
	OpenArgs = New Structure();
	OpenArgs.Insert("Password", Password);
	OpenForm("Catalog.Users.Form.InputPassword", OpenArgs, ThisObject, , , ,
		New NotifyDescription("SetPasswordFinish", ThisObject));
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
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	CurrentObject.AdditionalProperties.Insert("Password", Password);
EndProcedure

