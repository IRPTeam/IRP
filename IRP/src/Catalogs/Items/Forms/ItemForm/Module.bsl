#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)

	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	If Parameters.Property("Item") And Not ValueIsFilled(Object.Ref) Then
		Object.Item = Parameters.Item;
		Items.Item.ReadOnly = True;
	EndIf;
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	If Parameters.Property("SelectedFilters") Then
		For Each Row In Parameters.SelectedFilters Do
			ThisObject[Row.Name] = Row.Value;
			Items[Row.Name].ReadOnly = True;
		EndDo;
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	PictureViewerClient.UpdateObjectPictures(ThisObject, Object.Ref);
	AddAttributesAndPropertiesClient.UpdateObjectAddAttributeHTML(ThisObject, Object.Ref);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControll();
		UpdateAddAttributesHTMLDocument();
	EndIf;
	PictureViewerClient.HTMLEventAction(EventName, Parameter, Source, ThisForm);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	UpdateAddAttributesHTMLDocument();
	AddAttributesCreateFormControll();
EndProcedure

&AtClient
Procedure ItemTypeOnChange(Item)
	AddAttributesCreateFormControll();
EndProcedure

#EndRegion

#Region AddAttributeViewer

&AtClient
Procedure AddAttributesHTMLDocumentComplete(Item)
	UpdateAddAttributesHTMLDocument();
EndProcedure

&AtClient
Procedure UpdateAddAttributesHTMLDocument()
	HTMLWindow = PictureViewerClient.InfoDocumentComplete(Items.AddAttributeViewHTML);
	AddAttributeInfo = AddAttributesAndPropertiesClient.AddAttributeInfoForHTML(Object.Ref, UUID);
	JSON = CommonFunctionsServer.SerializeJSON(AddAttributeInfo);
	HTMLWindow.clearAll();
	HTMLWindow.fillData(JSON);
EndProcedure

#EndRegion

#Region PictureViewer

&AtClient
Procedure PictureViewHTMLOnClick(Item, EventData, StandardProcessing)
	StandardProcessing = EventData.Href = Undefined;
	If EventData.event = Undefined Then
		Return;
	EndIf;
	
	If EventData.Event.propertyName = "call1C" Then
		If Object.Ref.isEmpty() Then
			ShowMessageBox(Undefined, R()["InfoMessage_004"]);
		Else
			PictureViewerClient.HTMLEvent(ThisForm, Object, EventData.Event.Data);
		EndIf;
	EndIf;
	
EndProcedure

&AtClient
Procedure PictureViewerHTMLDocumentComplete(Item)
	PictureViewerClient.UpdateHTMLPicture(Item, ThisForm);
EndProcedure

#EndRegion

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControll()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure






