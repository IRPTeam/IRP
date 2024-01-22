&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);
	If Object.isIconSet Then
		CurrentObject = FormAttributeToValue("Object");
		Icon = PutToTempStorage(CurrentObject.Icon.Get());
	EndIf;
	ShowFormItems(ThisObject.Items, ThisObject.Object);
EndProcedure

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

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	If Object.isIconSet Then
		CurrentObject.Icon = New ValueStorage(GetFromTempStorage(Icon), New Deflation(9));
	EndIf;
EndProcedure

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
Procedure SetRequiredAtAllSets(Command)
	AddAttributesAndPropertiesClient.SetRequiredAtAllSets(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
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
	BDScaled = PictureViewerServer.ScalePicture(BD, 16);
	Icon = PutToTempStorage(BDScaled, UUID);
	Object.isIconSet = True;

EndProcedure

&AtClient
Procedure ValueTypeOnChange(Item)
	ShowFormItems(ThisObject.Items, ThisObject.Object);
EndProcedure

// Show form items.
// 
// Parameters:
//  Items - ClientApplicationForm, FormAllItems - Items
//  Object - ClientApplicationForm, FormDataStructure - Object
&AtClientAtServerNoContext
Procedure ShowFormItems(Items, Object)
	Items.isURL.Visible = Object.ValueType.ContainsType(Type("String"));
	Items.Multiline.Visible = Object.ValueType.ContainsType(Type("String"));
EndProcedure
