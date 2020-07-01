&AtClient
Procedure OnOpen(Cancel)
	HTMLGallery = PictureViewerServer.HTMLGallery();
EndProcedure


&AtServerNoContext
Function GetPicturesRefs()
	Query = New Query();
	Query.Text =
		"SELECT TOP 1000
		|	Files.Ref,
		|	Files.Description,
		|	Files.FileID,
		|	NOT Files.Volume = VALUE(Catalog.IntegrationSettings.EmptyRef) AS isFilledVolume,
		|	Files.Volume.GETIntegrationSettings AS GETIntegrationSettings,
		|	Files.Volume.GETIntegrationSettings.IntegrationType = VALUE(Enum.IntegrationType.LocalFileStorage) AS
		|		isLocalPictureURL,
		|	Files.URI,
		|	Files.isPreviewSet
		|FROM
		|	Catalog.Files AS Files
		|WHERE
		|	NOT Files.DeletionMark";
	ArrayOfResult = New Array();
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	While QuerySelection.Next() Do
		Map = New Structure("ID, Src, Name, Preview, isPreviewSet");
		PicInfo = PictureViewerServer.GetPictureURL(QuerySelection);
		Map.Src = PicInfo.PictureURL;
		Map.isPreviewSet = QuerySelection.isPreviewSet;
		If QuerySelection.isPreviewSet Then
			Map.Preview = QuerySelection.Ref.Preview.Get();
		EndIf;
		Map.ID = QuerySelection.FileID;
		Map.Name = QuerySelection.Description;
		ArrayOfResult.Add(Map);
	EndDo;
	
	Map = New Structure;
	Map.Insert("Pictures", ArrayOfResult);
	
	Return Map;
EndFunction

&AtClient
Procedure HTMLGalleryDocumentComplete(Item)
	HTMLWindow = PictureViewerClient.InfoDocumentComplete(Item);
	PicturesArray = GetPicturesRefs();
	
	For Each Pic In PicturesArray.Pictures Do
		If Pic.isPreviewSet Then
			Pic.Preview = PutToTempStorage(Pic.Preview, UUID);
		EndIf;
	EndDo;
	
	JSON = CommonFunctionsServer.SerializeJSON(PicturesArray);
	HTMLWindow.fillImageGallery(JSON);
EndProcedure

&AtClient
Procedure HTMLGalleryOnClick(Item, EventData, StandardProcessing)
	StandardProcessing = True;
	If EventData.event = Undefined Then
		Return;
	EndIf;
	
	
	If EventData.Event.propertyName = "call1C" Then
		Array = New Array;
		Data = CommonFunctionsServer.DeserializeJSON(EventData.Event.Data);
		If Data.value = "selected_images" Then
			ArrayPictureIDs = StrSplit(Data.ids, ",");
			Array = PictureViewerServer.GetFileRefsByFileIDs(ArrayPictureIDs);
		EndIf;
		Close(Array);
	EndIf;
		
	
EndProcedure



