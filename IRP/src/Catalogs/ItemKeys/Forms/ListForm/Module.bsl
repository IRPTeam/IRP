&AtClient
Var HTMLWindowPictures, HTMLWindowAddAttributes Export;

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)

	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	CatalogsServer.OnCreateAtServerListForm(ThisObject, List, Cancel, StandardProcessing);

	If Parameters.Property("CustomFilter") Then
		For Each KeyValue In Parameters.CustomFilter Do
			FilterItem = ThisObject.List.Filter.Items.Add(Type("DataCompositionFilterItem"));
			FilterItem.LeftValue = New DataCompositionField(KeyValue.Key);
			FilterItem.ComparisonType = DataCompositionComparisonType.Equal;
			FilterItem.RightValue = KeyValue.Value;
		EndDo;
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	PictureViewerClient.UpdateObjectPictures(ThisObject, PredefinedValue("Catalog.ItemKeys.EmptyRef"));
	AddAttributesAndPropertiesClient.UpdateObjectAddAttributeHTML(ThisObject, PredefinedValue(
		"Catalog.ItemKeys.EmptyRef"));
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
	If HTMLWindowPictures = Undefined Then
		HTMLWindowPictures = PictureViewerClient.InfoDocumentComplete(Item);
		HTMLWindowPictures.displayTarget("toolbar", False);
		UpdateHTMLPictures();
	EndIf;
EndProcedure

&AtClient
Async Procedure AddAttributesHTMLDocumentComplete(Item)
	If HTMLWindowAddAttributes = Undefined Then
		HTMLWindowAddAttributes = PictureViewerClient.InfoDocumentComplete(Item);
		UpdateHTMLAddAttributes();
	EndIf;
EndProcedure

&AtClient
Async Procedure UpdateHTMLPictures() Export
	CurrentRow = Items.List.CurrentData;
	If CurrentRow = Undefined Or Not CurrentRow.Property("Ref") Then
		Return;
	EndIf;

	JSON = PictureViewerClient.PicturesInfoForSlider(CurrentRow.Ref, UUID);
	HTMLWindowPictures.fillSlider(JSON);
EndProcedure

&AtClient
Async Procedure UpdateHTMLAddAttributes() Export
	CurrentRow = Items.List.CurrentData;
	If CurrentRow = Undefined Or Not CurrentRow.Property("Ref") Then
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