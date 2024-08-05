// @strict-types

&AtClient
Var isIconSet Export; //Boolean 

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);
	ChartsOfCharacteristicTypesServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	ShowFormItems(ThisObject.Items, ThisObject.Object);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	ChartsOfCharacteristicTypesServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	Icon = PutToTempStorage(CurrentObject.Icon.Get(), UUID);
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	ChartsOfCharacteristicTypesServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	//@skip-check invocation-parameter-type-intersect
	If Not IsBlankString(Icon) Then
		CurrentObject.Icon = New ValueStorage(GetFromTempStorage(Icon), New Deflation(9));
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	isIconSet = Object.isIconSet;
EndProcedure

&AtClient
Procedure IconClick(Item, StandardProcessing)
	StandardProcessing = False;
	If isIconSet Then
		DoChangeIconAction();
	Else
		AskForChangeIcon();
	EndIf;
EndProcedure

&AtClient
Async Procedure DoChangeIconAction()
	QueryText = R().QuestionToUser_016;
	QueryButtons = New ValueList(); // ValueList Of String
	QueryButtons.Add("Change", R().Form_017);
	QueryButtons.Add("Clear", R().Form_018);
	QueryButtons.Add("Cancel", R().Form_019);
	Result = Await DoQueryBoxAsync(QueryText, QueryButtons); // String
	If Result = "Cancel" Then
		Return;
	ElsIf Result = "Change" Then
		AskForChangeIcon();
	Else
		Icon = PutToTempStorage(Undefined, UUID);;
		isIconSet = False;
	EndIf;
	Modified = True;
EndProcedure

&AtClient
Async Procedure AskForChangeIcon()
	DialogParameters = New PutFilesDialogParameters(R().S_026, False, PictureViewerClientServer.FilterForPicturesDialog());
	StoredFileDescription = Await PutFileToServerAsync(, , , DialogParameters); // StoredFileDescription
	If StoredFileDescription = Undefined OR StoredFileDescription.PutFileCanceled Then
		Return;
	EndIf;
	BD = GetFromTempStorage(StoredFileDescription.Address);
	BDScaled = PictureViewerServer.ScalePicture(BD, 16);
	Icon = PutToTempStorage(BDScaled, UUID);
	isIconSet = True;
EndProcedure

&AtClient
Procedure SetRequiredAtAllSets(Command)
	AddAttributesAndPropertiesClient.SetRequiredAtAllSets(Object, ThisObject, Command);
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
