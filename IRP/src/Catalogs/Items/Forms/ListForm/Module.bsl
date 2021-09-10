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
	If Not HTMLWindowPictures = Undefined Then
		HTMLWindowPictures.clearAll();
		AttachIdleHandler("UpdateHTMLPictures", 0.1, True);
	EndIf;

	If Not HTMLWindowAddAttributes = Undefined Then
		HTMLWindowAddAttributes.clearAll();
		AttachIdleHandler("UpdateHTMLAddAttributes", 0.1, True);
	EndIf;

EndProcedure

#Region HTML
&AtClient
Procedure PictureViewerHTMLDocumentComplete(Item)
	HTMLWindowPictures = PictureViewerClient.InfoDocumentComplete(Item);
	HTMLWindowPictures.displayTarget("toolbar", False);
	AttachIdleHandler("UpdateHTMLPictures", 0.1, True);
EndProcedure

&AtClient
Procedure AddAttributesHTMLDocumentComplete(Item)
	HTMLWindowAddAttributes = PictureViewerClient.InfoDocumentComplete(Item);
	AttachIdleHandler("UpdateHTMLAddAttributes", 0.1, True);
EndProcedure

&AtClient
Procedure UpdateHTMLPictures() Export
	CurrentRow = Items.List.CurrentData;
	If CurrentRow = Undefined Or Not CurrentRow.Property("Ref") Then
		Return;
	EndIf;

	PictureInfo = PictureViewerClient.PicturesInfoForSlider(CurrentRow.Ref, UUID);
	JSON = CommonFunctionsServer.SerializeJSON(PictureInfo);
	HTMLWindowPictures.fillSlider(JSON);
EndProcedure

&AtClient
Procedure UpdateHTMLAddAttributes() Export
	CurrentRow = Items.List.CurrentData;
	If CurrentRow = Undefined Or Not CurrentRow.Property("Ref") Then
		Return;
	EndIf;

	AddAttributeInfo = AddAttributesAndPropertiesClient.AddAttributeInfoForHTML(CurrentRow.Ref, UUID);
	JSON = CommonFunctionsServer.SerializeJSON(AddAttributeInfo);
	HTMLWindowAddAttributes.fillData(JSON);

EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If StrStartsWith(EventName, "UpdateObjectPictures") Then
		UpdateHTMLPictures();
	EndIf;
EndProcedure
#EndRegion