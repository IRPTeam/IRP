&AtClient
Var HTMLWindowPictures, HTMLWindowAddAttributes Export;

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
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
//	If HTMLWindowPictures = Undefined Then
		HTMLWindowPictures = PictureViewerClient.InfoDocumentComplete(Item);
		HTMLWindowPictures.displayTarget("toolbar", False);
		UpdateHTMLPictures();
//	EndIf;
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
