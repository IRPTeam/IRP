&AtClient
Var HTMLWindowPictures, HTMLWindowAddAttributes Export;

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	CatalogsServer.OnCreateAtServerListForm(ThisObject, List, Cancel, StandardProcessing);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	PictureViewerClient.UpdateObjectPictures(ThisObject, PredefinedValue("Catalog.Items.EmptyRef"));
	AddAttributesAndPropertiesClient.UpdateObjectAddAttributeHTML(ThisObject, PredefinedValue("Catalog.Items.EmptyRef"));
EndProcedure

&AtClient
Procedure ListOnActivateRow(Item)
	HTMLOnActivateRow();
EndProcedure

#Region HTML
&AtClient
Async Procedure HTMLOnActivateRow()
	If Not HTMLWindowPictures = Undefined Then
		HTMLWindowPictures.clearAll();
		UpdateHTMLPictures();
	EndIf;

	If Not HTMLWindowAddAttributes = Undefined Then
		HTMLWindowAddAttributes.clearAll();
		UpdateHTMLAddAttributes();
	EndIf;
EndProcedure

&AtClient
Async Procedure PictureViewerHTMLDocumentComplete(Item)
	HTMLWindowPictures = PictureViewerClient.InfoDocumentComplete(Item);
	HTMLWindowPictures.displayTarget("toolbar", False);
	UpdateHTMLPictures();
EndProcedure

&AtClient
Async Procedure AddAttributesHTMLDocumentComplete(Item)
	HTMLWindowAddAttributes = PictureViewerClient.InfoDocumentComplete(Item);
	UpdateHTMLAddAttributes();
EndProcedure

&AtClient
Async Procedure UpdateHTMLPictures() Export
	CurrentRow = Items.List.CurrentData;
	If CurrentRow = Undefined Or Not CurrentRow.Property("Ref") Or Not Items.PictureViewHTML.Visible Then
		Return;
	EndIf;

	JSON = PictureViewerClient.PicturesInfoForSlider(CurrentRow.Ref, UUID);
	HTMLWindowPictures.fillSlider(JSON);
EndProcedure

&AtClient
Async Procedure UpdateHTMLAddAttributes() Export
	CurrentRow = Items.List.CurrentData;
	If CurrentRow = Undefined Or Not CurrentRow.Property("Ref") Or Not Items.AddAttributeViewHTML.Visible Then
		Return;
	EndIf;

	JSON = AddAttributesAndPropertiesClient.AddAttributeInfoForHTML(CurrentRow.Ref, UUID);
	HTMLWindowAddAttributes.fillData(JSON);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If StrStartsWith(EventName, "UpdateObjectPictures") Then
		UpdateHTMLPictures();
	EndIf;
EndProcedure

&AtClient
Procedure HTMLViewControl(Command)
	PictureViewerClient.HTMLViewControl(ThisObject, Command.Name);
EndProcedure

#EndRegion

#Region COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	SelectedRows = Items.List.SelectedRows;
	ExternalCommandsClient.GeneratedListChoiceFormCommandActionByName(SelectedRows, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name, SelectedRows);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName, SelectedRows) Export
	ExternalCommandsServer.GeneratedListChoiceFormCommandActionByName(SelectedRows, ThisObject, CommandName);
EndProcedure

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, List, Items.List.SelectedRows);
EndProcedure

#EndRegion