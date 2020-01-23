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
		|	Files.Volume.UsePreview1 AS UsePreview1,
		|	Files.Volume.Preview1GETIntegrationSettings AS Preview1GETIntegrationSettings,
		|	Files.Volume.GETIntegrationSettings.IntegrationType = VALUE(Enum.IntegrationType.LocalFileStorage) AS
		|		isLocalPictureURL,
		|	Files.Volume.Preview1GETIntegrationSettings.IntegrationType = VALUE(Enum.IntegrationType.LocalFileStorage) AS
		|		isLocalPreview1URL,
		|	Files.URI,
		|	Files.Preview1URI
		|FROM
		|	Catalog.Files AS Files
		|WHERE
		|	NOT Files.DeletionMark";
	ArrayOfResult = New Array();
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	While QuerySelection.Next() Do
		Map = New Structure("ID, Src, Name, Preview");
		PicInfo = PictureViewerServer.GetPictureURL(QuerySelection);
		Map.Src = PicInfo.PictureURL;
		If PicInfo.isLocalPictureURL Then
//			Map.SrcBD = New BinaryData(Map.Src);
		EndIf;
		Map.Preview = PicInfo.Preview1URL;
		If PicInfo.isLocalPreview1URL Then
//			Map.PreviewBD = New BinaryData(Map.Preview);
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
	GetPictures = GetPicturesRefs();
	JSON = CommonFunctionsServer.SerializeJSON(GetPictures);
	HTMLWindow.fillImageGallery(JSON);
EndProcedure

&AtClient
Procedure HTMLGalleryOnClick(Item, EventData, StandardProcessing)
	StandardProcessing = True;
	If EventData.event = Undefined Then
		Return;
	EndIf;
	
	If EventData.Event.propertyName = "call1C" Then
//		EventData.Event.Data
	A = 1;
	s=A;
	EndIf;
EndProcedure



