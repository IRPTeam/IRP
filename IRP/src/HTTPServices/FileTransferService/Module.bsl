Function SuccessResponse()
	SuccessResponse = New Structure();
	SuccessResponse.Insert("Success", True);
	SuccessResponse.Insert("Data", New Structure());
	Return SuccessResponse;
EndFunction

Function ErrorResponse()
	ErrorResponse = New Structure();
	ErrorResponse.Insert("Success", False);
	ErrorResponse.Insert("Message", "");
	Return ErrorResponse;
EndFunction

Function GetFileStorageInfo(URLAlias)
	Query = New Query();
	Query.Text =
		"SELECT
		|	FileStoragesInfo.Description AS PathForSave,
		|	FileStoragesInfo.URLAlias AS URLAlias
		|FROM
		|	Catalog.FileStoragesInfo AS FileStoragesInfo
		|WHERE
		|	FileStoragesInfo.URLAlias = &URLAlias";
	
	Query.SetParameter("URLAlias", URLAlias);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Structure("PathForSave, URLAlias");
	If QuerySelection.Next() Then
		FillPropertyValues(Result, QuerySelection);
	EndIf;
	Return Result;
EndFunction

Function GetFileFromFileStorage(PathForSave, FileName)
	Return New BinaryData(PathForSave + ?(StrEndsWith(PathForSave, "\"), "", "\") + FileName);
EndFunction



Function CreateErrorResponse(HttpResponse, Message)
	ErrorResponse = ErrorResponse();
	ErrorResponse.Success = False;
	ErrorResponse.Message = Message;
	HttpResponse.SetBodyFromString(CommonFunctionsServer.SerializeJSON(ErrorResponse));
	Return HttpResponse;
EndFunction

Function CreateSuccessResponse(HttpResponse, Data = Undefined)
	SuccessResponse = SuccessResponse();
	SuccessResponse.Success = True;
	If Data <> Undefined Then
		For Each KeyValue In Data Do
			SuccessResponse.Data.Insert(KeyValue.Key, KeyValue.Value);
		EndDo;
	EndIf;
	HttpResponse.SetBodyFromString(CommonFunctionsServer.SerializeJSON(SuccessResponse));
	Return HttpResponse;
EndFunction

// POST
Function FileTransferPOST(Request)
	HttpResponse = New HTTPServiceResponse(200);
	
	FileName = "";
	Storage = "";
	URLParameters = New Map(Request.URLParameters);
	If TypeOf(URLParameters) = Type("Map") Then
		FileName = URLParameters.Get("filename");
		Storage = URLParameters.Get("storage");
	EndIf;
	If Not ValueIsFilled(FileName) Or Not ValueIsFilled(Storage) Then
		Return CreateErrorResponse(HttpResponse, R().S_014);
	EndIf;
	
	FileStorageInfo = GetFileStorageInfo(Storage);
	If Not ValueIsFilled(FileStorageInfo.PathForSave) Then
		Return CreateErrorResponse(HttpResponse, R().S_015);
	EndIf;
	
	GetUnusedFiles = Request.QueryOptions.Get("get_unused_files");
	If GetUnusedFiles <> Undefined Then
		Try
			Return CreateSuccessResponse(HttpResponse,
				New Structure("ArrayOfUnusedFiles", IntegrationServer.GetArrayOfUnusedFiles(FileStorageInfo.PathForSave)));
		Except
			Return CreateErrorResponse(HttpResponse, String(ErrorDescription()));
		EndTry;
	EndIf;
	
	DeleteUnusedFiles = Request.QueryOptions.Get("delete_unused_files");
	If DeleteUnusedFiles <> Undefined Then
		Try
			IntegrationServer.DeleteUnusedFiles(FileStorageInfo.PathForSave
				, CommonFunctionsServer.DeserializeJSON(Request.GetBodyAsString()).ArrayOfFilesID);
			Return CreateSuccessResponse(HttpResponse);
		Except
			Return CreateErrorResponse(HttpResponse, String(ErrorDescription()));
		EndTry;
	EndIf;
	
	// Preview
	SizePx = Request.QueryOptions.Get("sizepx");
	SizePxNumber = 0;
	If SizePx <> Undefined Then
		Try
			SizePxNumber = Number(SizePx);
		Except
			Return CreateErrorResponse(HttpResponse, String(ErrorDescription()));
		EndTry;
	EndIf;
	
	Result = New Structure();
	Try
		IntegrationServer.SaveFileToFileStorage(FileStorageInfo.PathForSave, FileName
			, PictureViewerServer.ScalePicture(Request.GetBodyAsBinaryData(), SizePxNumber));
		Result.Insert("URI", FileName);
	Except
		Return CreateErrorResponse(HttpResponse, String(ErrorDescription()));
	EndTry;
	
	Return CreateSuccessResponse(HttpResponse, Result);
EndFunction

// GET
Function FileTransferGET(Request)
	HttpResponse = New HTTPServiceResponse(200);
	
	FileName = "";
	Storage = "";
	URLParameters = New Map(Request.URLParameters);
	If TypeOf(URLParameters) = Type("Map") Then
		FileName = URLParameters.Get("filename");
		Storage = URLParameters.Get("storage");
	EndIf;
	If Not ValueIsFilled(Storage) Then
		Return CreateErrorResponse(HttpResponse, R().S_014);
	EndIf;
	
	FileStorageInfo = GetFileStorageInfo(Storage);
	If Not ValueIsFilled(FileStorageInfo.PathForSave) Then
		Return CreateErrorResponse(HttpResponse, R().S_015);
	EndIf;
	
	If StrEndsWith(Upper(TrimAll(Request.RelativeURL)), "JPEG") 
		Or StrEndsWith(Upper(TrimAll(Request.RelativeURL)), "JPG") Then
		HttpResponse.Headers.Insert("Content-type", "image/jpg");
	ElsIf StrEndsWith(Upper(TrimAll(Request.RelativeURL)), "PNG") Then
		HttpResponse.Headers.Insert("Content-type", "image/PNG");
	ElsIf StrEndsWith(Upper(TrimAll(Request.RelativeURL)), "HTML") Then
		HttpResponse.Headers.Insert("Content-type", "text/html");
	ElsIf StrEndsWith(Upper(TrimAll(Request.RelativeURL)), "JS") Then
		HttpResponse.Headers.Insert("Content-type", "application/javascript");
	ElsIf StrEndsWith(Upper(TrimAll(Request.RelativeURL)), "CSS") Then
		HttpResponse.Headers.Insert("Content-type", "text/css");
	Else
		HttpResponse.Headers.Insert("Content-type", "text/plain");
	EndIf;
	
	Try
		BinaryData = GetFileFromFileStorage(FileStorageInfo.PathForSave, FileName + StrReplace(URLParameters.Get("*"), "/", "\"));
	Except
		Return CreateErrorResponse(HttpResponse, String(ErrorDescription()));
	EndTry;
	
	HttpResponse.SetBodyFromBinaryData(BinaryData);
	Return HttpResponse;
EndFunction

