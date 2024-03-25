#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DescriptionParameters = LocalizationEvents.DescriptionParameters();
	DescriptionParameters.CreateFillByTemplate_Description = True;
	DescriptionParameters.CreateFillByTemplate_LocalDescription = True;
	DescriptionParameters.CreateFillByTemplate_ForeignDescription = True;

	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions", DescriptionParameters);
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);
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
	If Items.ViewDetailsTree.Check And Items.ViewPictures.Check Then
		PictureViewerClient.HTMLViewControl(ThisObject, Commands.ViewDetailsTree.Name);
	EndIf;
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

&AtClient
Procedure ViewDetailsTree(Command)
	PictureViewerClient.HTMLViewControl(ThisObject, Command.Name);
	If Items.ViewDetailsTree.Check And Items.ViewPictures.Check Then
		PictureViewerClient.HTMLViewControl(ThisObject, Commands.ViewPictures.Name);
	EndIf;
	ChangingFormBySettings();
	SaveSettings();
EndProcedure

#EndRegion

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	DescriptionParameters = LocalizationEvents.DescriptionParameters();
	DescriptionParameters.CreateFillByTemplate_Description = True;
	DescriptionParameters.DescriptionTemplate = CommonFunctionsServer.GetRefAttribute(Object.ItemType, "ItemDescriptionTemplate");
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing, DescriptionParameters);
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

&AtClient
Procedure Tree_RefreshData(Command)
	RefreshDetailsTreeAtServer();
	Tree_ExpandAll(Command);
EndProcedure

&AtClient
Procedure Tree_ExpandAll(Command)
	For Each TreeRow In ThisObject.DetailsTree.GetItems() Do
		Items.DetailsTree.Expand(TreeRow.GetID(), True);
	EndDo;
EndProcedure

&AtClient
Procedure Tree_CollapseAll(Command)
	For Each TreeRow In ThisObject.DetailsTree.GetItems() Do
		Items.DetailsTree.Collapse(TreeRow.GetID());
	EndDo;
EndProcedure

&AtClient
Procedure DetailsTreeSelection(Item, RowSelected, Field, StandardProcessing)
	TableRow = ThisObject.DetailsTree.FindByID(RowSelected);
	If ValueIsFilled(TableRow.RefValue) Then
		ShowValue(, TableRow.RefValue);
	EndIf;
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
	PictureViewerClient.HTMLViewControl(ThisObject, "ViewDetailsTree");
EndProcedure

&AtClient
// @skip-check unknown-method-property
Procedure ChangingFormBySettings()
	If Items.ViewPictures.Check Then
		Items.GroupMainLeft.Group = ChildFormItemsGroup.Vertical;
	Else
		Items.GroupMainLeft.Group = ChildFormItemsGroup.Horizontal;
	EndIf;
	
	Items.DetailsTree.Visible = Items.ViewDetailsTree.Check;
	If Items.DetailsTree.Visible And ThisObject.DetailsTree.GetItems().Count() = 0 Then
		Tree_RefreshData(Undefined);
	EndIf;
	
EndProcedure	

&AtServer
Procedure SaveSettings()
	NewSettings = New Structure;
	NewSettings.Insert("ViewPictures", Items.ViewPictures.Check);
	NewSettings.Insert("ViewAdditionalAttribute", Items.ViewAdditionalAttribute.Check);
	NewSettings.Insert("ViewDetailsTree", Items.ViewDetailsTree.Check);
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
		If RestoreSettings.Property("ViewDetailsTree") Then
			Items.ViewDetailsTree.Check = Not RestoreSettings.ViewDetailsTree;
		EndIf;
	EndIf;

EndProcedure

&AtServer
Procedure RefreshDetailsTreeAtServer()
	
	ThisObject.DetailsTree.GetItems().Clear();
	If Object.Ref.IsEmpty() Then
		Return;
	EndIf;
	
	TreeInfo = GetItemInfo.GetItemTreeInfo(Object.Ref);
		
	ValueToFormAttribute(TreeInfo, "DetailsTree");
	
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
Procedure FillDescriptionByTemplate(Command)
	If ThisObject.Modified Then
		ShowQueryBox(New NotifyDescription("FillDescriptionByTemplateEnd", ThisObject, New Structure("CommandName", Command.Name)), 
			R().QuestionToUser_001, QuestionDialogMode.OKCancel);
	Else
		FillDescriptionByTemplateAtClient(Command.Name);
	EndIf;
EndProcedure

&AtClient
Procedure FillDescriptionByTemplateEnd(Result, NotifyParameters) Export
	If Result = DialogReturnCode.OK Then
		If Write() Then
			FillDescriptionByTemplateAtClient(NotifyParameters.CommandName);
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure FillDescriptionByTemplateAtClient(CommandName)
	If StrStartsWith(CommandName, "CommandFillByTemplate_Description") Then
		FillDescriptionByTemplateAtServer("Description_" + LocalizationReuse.GetLocalizationCode(), "ItemDescriptionTemplate");
	ElsIf StrStartsWith(CommandName, "CommandFillByTemplate_LocalDescription") Then
		FillDescriptionByTemplateAtServer("LocalFullDescription", "ItemLocalFullDescriptionTemplate");
	ElsIf StrStartsWith(CommandName, "CommandFillByTemplate_ForeignDescription") Then
		FillDescriptionByTemplateAtServer("ForeignFullDescription", "ItemForeignFullDescriptionTemplate");
	Else
		Raise StrTemplate("Unknown command [%1]", CommandName);
	EndIf;		
EndProcedure

&AtServer
Procedure FillDescriptionByTemplateAtServer(AttributeName, TemplateName)
	Template = Object.ItemType[TemplateName];
	If Not ValueIsFilled(Template) Then
		CommonFunctionsClientServer.ShowUsersMessage(R().FormulaEditor_Error05);
		Return;
	EndIf;
	NewDesciption = GetItemInfo.GetDescriptionByTemplate(Object, Template);
	If Object[AttributeName] <> NewDesciption Then
		Object[AttributeName] = NewDesciption;
		ThisObject.Modified = True;
	EndIf;
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

#EndRegion