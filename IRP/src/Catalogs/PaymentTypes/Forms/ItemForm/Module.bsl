#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
	
	If Object.isIconSet Then
		CurrentObject = FormAttributeToValue("Object");
		Icon = PutToTempStorage(CurrentObject.Icon.Get());
	EndIf;
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	
	If Object.isIconSet Then
		CurrentObject.Icon = New ValueStorage(GetFromTempStorage(Icon), New Deflation(9));
	EndIf;
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	Notify("PaymetTypesWrite");	
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)	
	Return;
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

#EndRegion

&AtClient
Procedure TypeOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion

&AtClient
Procedure IconClick(Item, StandardProcessing)
	StandardProcessing = False;
	If Object.isIconSet Then
		Notify = New NotifyDescription("IconOnClickEnd", ThisObject);
		QueryText = R().QuestionToUser_016;
		QueryButtons = New ValueList();
		QueryButtons.Add("Change", R().Form_017);
		QueryButtons.Add("Clear", R().Form_018);
		QueryButtons.Add("Cancel", R().Form_019);
		ShowQueryBox(Notify, QueryText, QueryButtons);
	Else
		AskForChangeIcon();
	EndIf;
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#Region Service

&AtClient
Procedure AskForChangeIcon()
	Var OpenFileDialog;
	Notify = New NotifyDescription("SelectFileEnd", ThisObject);
	OpenFileDialog = New FileDialog(FileDialogMode.Open);
	OpenFileDialog.Multiselect = False;
	OpenFileDialog.Title = R().S_026;
	OpenFileDialog.Filter = PictureViewerClientServer.FilterForPicturesDialog();
	//@skip-warning
	BeginPuttingFiles(Notify, , OpenFileDialog, True, UUID);
EndProcedure

&AtClient
Procedure IconOnClickEnd(Result, AdditionalParameters) Export
	If Result = "Cancel" Then
		Return;
	ElsIf Result = "Change" Then
		AskForChangeIcon();
	Else
		Icon = "";
		Object.isIconSet = False;
	EndIf;
EndProcedure

&AtClient
Procedure SelectFileEnd(Files, AdditionalParameters) Export
	If Files = Undefined Then
		Return;
	EndIf;

	BD = New BinaryData(Files[0].FullName);
	Icon = PutToTempStorage(BD, UUID);
	Object.isIconSet = True;
EndProcedure

#EndRegion

#Region COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

#EndRegion