&AtClient
Procedure OnOpen(Cancel)
	HTMLGallery = PictureViewerServer.HTMLGallery();
EndProcedure

&AtServerNoContext
Function GetPicturesRefs()
	Query = New Query();
	Query.Text =
	"SELECT
	|	Files.Ref,
	|	Files.FileID,
	|	Files.Description,
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
		If QuerySelection.isPreviewSet Then
			URL = GetURL(QuerySelection.Ref, "Preview");
			Map.Src = URL;
			Map.isPreviewSet = True;
			Map.Preview = URL;
		EndIf;
		Map.ID = QuerySelection.FileID;
		Map.Name = QuerySelection.Description;
		ArrayOfResult.Add(Map);
	EndDo;

	Map = New Structure();
	Map.Insert("Pictures", ArrayOfResult);

	JSON = CommonFunctionsServer.SerializeJSON(Map);
	Return JSON;
EndFunction

&AtClient
Procedure HTMLGalleryDocumentComplete(Item)
	HTMLWindow = PictureViewerClient.InfoDocumentComplete(Item);
	JSON = GetPicturesRefs();
	HTMLWindow.fillImageGallery(JSON);
EndProcedure

&AtClient
Procedure HTMLGalleryOnClick(Item, EventData, StandardProcessing)
	If Not EventData.Href = Undefined Then
		StandardProcessing = False;
	EndIf;

	If EventData.Button = Undefined Or Not EventData.Button.Id = "call1CEvent" Then
		Return;
	EndIf;

	Array = New Array();
	Data = CommonFunctionsServer.DeserializeJSON(Item.Document.defaultView.call1C);
	If Data.value = "selected_images" Then
		ArrayPictureIDs = StrSplit(Data.ids, ",");
		Array = PictureViewerServer.GetFileRefsByFileIDs(ArrayPictureIDs);
	EndIf;
	Close(Array);
EndProcedure