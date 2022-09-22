// @strict-types
// @skip-check module-self-reference


#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	If Object.Ref.IsEmpty() Then
		If Parameters.Property("Basis") And TypeOf(Parameters.Basis) = Type("CatalogRef.Unit_ServiceExchangeHistory") Then
			InputRequest = Parameters.Basis;  // CatalogRef.Unit_ServiceExchangeHistory
			InputAnswer = Parameters.Basis; // CatalogRef.Unit_ServiceExchangeHistory
			If InputAnswer.Parent.IsEmpty() Then
				InputAnswer = IntegrationServer.Unit_GetLastAnswerByRequest(InputAnswer);
			Else
				InputRequest = InputAnswer.Parent;
			EndIf;
			LoadValueStorageInBody(True, InputRequest.Body);
			LoadValueStorageInBody(False, InputAnswer.Body);
		EndIf;
	EndIf; 
	
	ThisObject.RequestBodySizePresentation = CommonFunctionsClientServer.GetSizePresentation(Object.Request_BodySize);
	ThisObject.AnswerBodySizePresentation = CommonFunctionsClientServer.GetSizePresentation(Object.Answer_BodySize);

EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	LoadValueStorageInBody(True, CurrentObject.Request_Body);
	LoadValueStorageInBody(False, CurrentObject.Answer_Body);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	CurrentObject.Request_Body  = GetBodyValueStorage(True);
	CurrentObject.Answer_Body = GetBodyValueStorage(False);
EndProcedure

#EndRegion


#Region FormCommandsEventHandlers

&AtClient
Procedure TryLoadBody(Command)
	isRequest = StrStartsWith(Command.Name, "Request");
	TryLoadBodyAtServer(isRequest);
EndProcedure

&AtClient
Async Procedure SaveBody(Command)
	
	isRequest = StrStartsWith(Command.Name, "Request");
	BodyRowValue = GetBodyAtServer(isRequest);
	If TypeOf(BodyRowValue) <> Type("BinaryData") Then
		ShowMessageBox(, R().Mock_Info_EmptyFile);
		Return;
	EndIf;
	
	FileDialog = New FileDialog(FileDialogMode.Save);
	If ?(isRequest, Object.Request_BodyIsText, Object.Answer_BodyIsText) Then
		FileDialog.DefaultExt = "txt";
	EndIf;
	
	PathArray = Await FileDialog.ChooseAsync();
	If PathArray = Undefined Or PathArray.Count() = 0 Then
		Return;
	EndIf;
	FullFileName = PathArray[0];	
	BodyRowValue.Write(FullFileName);
	
EndProcedure

&AtClient
Async Procedure ReloadBody(Command)
	
	FileDialog = New FileDialog(FileDialogMode.Open);
	FileDialog.CheckFileExistence = True;
	PathArray = Await FileDialog.ChooseAsync();
	If PathArray = Undefined Or PathArray.Count() = 0 Then
		Return;
	EndIf;
	FullFileName = PathArray[0];
	
	File = New File(FullFileName); 
	SizeNewFile = File.Size();
	ContentFile = New BinaryData(FullFileName);
	 
	isRequest = StrStartsWith(Command.Name, "Request");
	ReloadBodyAtServer(isRequest, ContentFile, SizeNewFile);
	
EndProcedure

#EndRegion



#Region Private

// Get body at server.
// 
// Parameters:
//  isRequest - Boolean - Is request
// 
// Returns:
//  BinaryData - Get body at server
&AtServer
Function GetBodyAtServer(isRequest)
	Return GetBodyValueStorage(isRequest).Get();
EndFunction

// Get body as ValueStorage.
// 
// Parameters:
//  isRequest - Boolean - Is request
// 
// Returns:
//  ValueStorage - Get body as ValueStorage
&AtServer
Function GetBodyValueStorage(isRequest)
	Return ?(isRequest, Request_Body, Answer_Body);
EndFunction

// Get body as ValueStorage.
//  
// Parameters:
//  isRequest - Boolean - Is request
//  Body - ValueStorage
&AtServer
Procedure LoadValueStorageInBody(isRequest, Body)
	If isRequest Then
		ThisObject["Request_Body"] = Body;
	Else
		ThisObject["Answer_Body"] = Body;
	EndIf;
EndProcedure

&AtServer
Procedure TryLoadBodyAtServer(isRequest)
	
	If isRequest Then
		Prefix = "Request";
		BodyType = Object.Request_BodyType;
		BodyIsText = Object.Request_BodyIsText;
		BodyGroup = Items.BodyRequestPresentation;
	Else
		Prefix = "Answer";
		BodyType = Object.Answer_BodyType;
		BodyIsText = Object.Answer_BodyIsText;
		BodyGroup = Items.BodyAnswerPresentation;
	EndIf;
	
	ThisObject[Prefix+"BodyString"] = "";
	ThisObject[Prefix+"BodyPicture"] = "";
	BodyRowValue = GetBodyAtServer(isRequest);
	
	If BodyIsText Then
		ThisObject[Prefix+"BodyString"] = GetStringFromBinaryData(BodyRowValue);
		BodyGroup.CurrentPage = Items["Body"+Prefix+"AsStr"];
	ElsIf StrCompare(Left(BodyType, 5), "IMAGE") = 0 Then
		ThisObject[Prefix+"BodyPicture"] = PutToTempStorage(BodyRowValue);
		BodyGroup.CurrentPage = Items["Body"+Prefix+"AsPic"];
	Else
		BodyGroup.CurrentPage = Items["Body"+Prefix+"AsFile"];
	EndIf;
	
EndProcedure

&AtServer
Procedure ReloadBodyAtServer(isRequest, NewContent, Newsize)
	
	If isRequest Then
		Prefix = "Request";
		Request_Body = New ValueStorage(NewContent);
		Object.Request_BodyMD5 = CommonFunctionsServer.GetMD5(NewContent);
		Object.Request_BodySize = Newsize;
	Else
		Prefix = "Answer";
		Answer_Body = New ValueStorage(NewContent);
		Object.Answer_BodySize = Newsize;
	EndIf;
	
	ThisObject[Prefix+"BodySizePresentation"] = CommonFunctionsClientServer.GetSizePresentation(Newsize);
	
	TryLoadBodyAtServer(isRequest);
	
EndProcedure

#EndRegion
