&AtClient
Var HTMLWindowPictures, HTMLWindowAddAttributes Export;

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
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
	AddAttributesAndPropertiesClient.UpdateObjectAddAttributeHTML(ThisObject, PredefinedValue("Catalog.ItemKeys.EmptyRef"));
EndProcedure

&AtClient
Procedure ListOnActivateRow(Item)
	If NOT HTMLWindowPictures = Undefined Then
		HTMLWindowPictures.clearAll();
		AttachIdleHandler("UpdateHTMLPictures", 0.1, True);
	EndIf;

	If NOT HTMLWindowAddAttributes = Undefined Then
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
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	PictureInfo = PictureViewerClient.PicturesInfoForSlider(CurrentRow.Ref, UUID);
	JSON = CommonFunctionsServer.SerializeJSON(PictureInfo);
	HTMLWindowPictures.fillSlider(JSON);
EndProcedure

&AtClient
Procedure UpdateHTMLAddAttributes() Export
	CurrentRow = Items.List.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	AddAttributeInfo = AddAttributesAndPropertiesClient.AddAttributeInfoForHTML(CurrentRow.Ref, UUID);
	JSON = CommonFunctionsServer.SerializeJSON(AddAttributeInfo);
	HTMLWindowAddAttributes.fillData(JSON);
	
EndProcedure
#EndRegion