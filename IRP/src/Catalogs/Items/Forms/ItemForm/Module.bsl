#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	If Object.Ref.IsEmpty() Then
		If Parameters.Property("Item") Then
			Object.Item = Parameters.Item;
			Items.Item.ReadOnly = True;
		EndIf;
		Items.PackageUnit.ReadOnly = True;
		Items.PackageUnit.InputHint = R().InfoMessage_004;
	EndIf;
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	If Parameters.Property("SelectedFilters") Then
		For Each Row In Parameters.SelectedFilters Do
			ThisObject[Row.Name] = Row.Value;
			Items[Row.Name].ReadOnly = True;
		EndDo;
	EndIf;
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
	RestoreSettings();
	Items.ConsignorsInfo.Visible = FOServer.IsUseCommissionTrading();
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	PictureViewerClient.UpdateObjectPictures(ThisObject, Object.Ref);
	AddAttributesAndPropertiesClient.UpdateObjectAddAttributeHTML(ThisObject, Object.Ref);
	SetSettings();
	ChangingFormBySettings();
	SetVisibleCodeString();
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
		UpdateAddAttributesHTMLDocument();
	EndIf;
	PictureViewerClient.HTMLEventAction(EventName, Parameter, Source, ThisObject);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	UpdateAddAttributesHTMLDocument();
	AddAttributesCreateFormControl();

	Items.PackageUnit.ReadOnly = False;
	Items.PackageUnit.InputHint = "";
EndProcedure

#EndRegion

#Region AddAttributeViewer

&AtClient
Async Procedure AddAttributesHTMLDocumentComplete(Item)
	UpdateAddAttributesHTMLDocument();
EndProcedure

&AtClient
Async Procedure UpdateAddAttributesHTMLDocument()
	If Items.ViewAdditionalAttribute.Check Then
		HTMLWindow = PictureViewerClient.InfoDocumentComplete(Items.AddAttributeViewHTML);
		JSON = AddAttributesAndPropertiesClient.AddAttributeInfoForHTML(Object.Ref, UUID);
		HTMLWindow.clearAll();
		HTMLWindow.fillData(JSON);
	EndIf;
EndProcedure

#EndRegion

#Region PictureViewer

&AtClient
Procedure HTMLViewControl(Command)
	PictureViewerClient.HTMLViewControl(ThisObject, Command.Name);
	ChangingFormBySettings();
	SaveSettings();
EndProcedure

&AtClient
Procedure PictureViewHTMLOnClick(Item, EventData, StandardProcessing)
	PictureViewerClient.PictureViewHTMLOnClick(ThisObject, Item, EventData, StandardProcessing);
EndProcedure

&AtClient
Procedure PictureViewerHTMLDocumentComplete(Item)
	PictureViewerClient.UpdateHTMLPicture(Item, ThisObject);
EndProcedure

#EndRegion

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#Region AddAttribute

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

#Region FormElementEvents

&AtClient
Procedure ItemTypeOnChange(Item)
	AddAttributesCreateFormControl();
EndProcedure

&AtClient
Procedure SizeOnChange(Item)
	CommonFunctionsClientServer.CalculateVolume(Object);
EndProcedure

&AtClient
Procedure ControlCodeStringOnChange(Item)
	If Not Object.ControlCodeString Then
		Object.CheckCodeString = False;
		Object.ControlCodeStringType = Undefined;
	EndIf;
	SetVisibleCodeString();
EndProcedure

#EndRegion

#Region Service

&AtClient
Procedure SetVisibleCodeString()
	Items.CheckCodeString.Visible = Object.ControlCodeString;
	Items.ControlCodeStringType.Visible = Object.ControlCodeString;
EndProcedure

&AtClient
Procedure SetSettings()
	PictureViewerClient.HTMLViewControl(ThisObject, "ViewPictures");
	PictureViewerClient.HTMLViewControl(ThisObject, "ViewAdditionalAttribute");
EndProcedure

&AtClient
// @skip-check unknown-method-property
Procedure ChangingFormBySettings()
	If Items.ViewPictures.Check Then
		Items.GroupMainLeft.Group = ChildFormItemsGroup.Vertical;
	Else
		Items.GroupMainLeft.Group = ChildFormItemsGroup.Horizontal;
	EndIf;
EndProcedure	

&AtServer
Procedure SaveSettings()
	NewSettings = New Structure;
	NewSettings.Insert("ViewPictures", Items.ViewPictures.Check);
	NewSettings.Insert("ViewAdditionalAttribute", Items.ViewAdditionalAttribute.Check);
	CommonSettingsStorage.Save("Catalog_Item", "Settings", NewSettings);
EndProcedure	

&AtServer
Procedure RestoreSettings()
	
	Items.ViewPictures.Check = True;
	Items.ViewAdditionalAttribute.Check = True;
	
	RestoreSettings = CommonSettingsStorage.Load("Catalog_Item", "Settings"); // Structure
	If TypeOf(RestoreSettings) = Type("Structure") Then
		If RestoreSettings.Property("ViewPictures") Then
			Items.ViewPictures.Check = Not RestoreSettings.ViewPictures;
		EndIf;
		If RestoreSettings.Property("ViewAdditionalAttribute") Then
			Items.ViewAdditionalAttribute.Check = Not RestoreSettings.ViewAdditionalAttribute;
		EndIf;
	EndIf;

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

#EndRegion