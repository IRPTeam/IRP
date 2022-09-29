// @strict-types

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	If Object.Ref.IsEmpty() Then
		If Parameters.Property("Basis") And TypeOf(Parameters.Basis) = Type("CatalogRef.Unit_ServiceExchangeHistory") Then
			InputRequest = Parameters.Basis; // CatalogRef.Unit_ServiceExchangeHistory
			InputAnswer = Parameters.Basis; // CatalogRef.Unit_ServiceExchangeHistory
			If InputAnswer.Parent.IsEmpty() Then
				InputAnswer = IntegrationServer.Unit_GetLastAnswerByRequest(InputAnswer);
			Else
				InputRequest = InputAnswer.Parent;
			EndIf;
			LoadBodyBinaryData(True, InputRequest.Body.Get());
			LoadBodyBinaryData(False, InputAnswer.Body.Get());
		EndIf;
	EndIf; 
	
	ThisObject.RequestBodySizePresentation = CommonFunctionsClientServer.GetSizePresentation(Object.Request_BodySize);
	If Object.Request_BodySize < Pow(2, 20) And Object.Request_BodyIsText Then
		 TryLoadBodyAtServer(True);
	EndIf;
	
	ThisObject.AnswerBodySizePresentation = CommonFunctionsClientServer.GetSizePresentation(Object.Answer_BodySize);
	If Object.Answer_BodySize < Pow(2, 20) And Object.Answer_BodyIsText Then
		 TryLoadBodyAtServer(False);
	EndIf;

EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	LoadBodyBinaryData(True, CurrentObject.Request_Body.Get());
	LoadBodyBinaryData(False, CurrentObject.Answer_Body.Get());
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	
	If isEditRequestBody Then
		ReloadTextBodyAtServer(True);
	EndIf;
	CurrentObject.Request_Body = New ValueStorage(GetBodyBinaryData(True));
	
	If isEditAnswerBody Then
		ReloadTextBodyAtServer(False);
	EndIf;
	CurrentObject.Answer_Body = New ValueStorage(GetBodyBinaryData(False));
	
EndProcedure

#EndRegion

#Region FormHeaderItemsEventHandlers

&AtClient
Procedure RequestBodyStringOnChange(Item)
	ThisObject.isEditRequestBody = True;
	ThisObject.Modified = True;
EndProcedure

&AtClient
Procedure AnswerBodyStringOnChange(Item)
	ThisObject.isEditAnswerBody = True;
	ThisObject.Modified = True;
EndProcedure

#EndRegion

#Region FormTableItemsEventHandlers

&AtClient
Procedure Request_BodyVariablesPathToValueOpening(Item, StandardProcessing)
	
	StandardProcessing = False;
	
	CurrentRecord = Items.Request_BodyVariables.CurrentData;
	PathToValue = CurrentRecord.PathToValue;
	If IsBlankString(PathToValue) Then
		PathToValue = ?(Object.Request_BodyIsText, "[text]", "[file]");
	EndIf;
	
	OpenForm(
		"Catalog.Unit_MockServiceData.Form.AccessConstructor", 
		New Structure("PathToValue, AddressBody", PathToValue, Request_Body), 
		Item
	);

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
	
	isEditBody = ?(isRequest, ThisObject.isEditRequestBody, ThisObject.isEditAnswerBody);
	If isEditBody Then
		ReloadTextBodyAtServer(isRequest);
		Return;
	EndIf;
	
	BodyRowValue = GetBodyBinaryData(isRequest);
	If Not TypeOf(BodyRowValue) = Type("BinaryData") Then
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

&AtClient
Procedure AnalyzeBody(Command)
	
	isRequest = StrStartsWith(Command.Name, "Request");
	
	AddressBody = ?(isRequest, Request_Body, Answer_Body);
	BodyIsText = ?(isRequest, Object.Request_BodyIsText, Object.Answer_BodyIsText);
	
	OpenForm(
		"Catalog.Unit_MockServiceData.Form.AccessConstructor", 
		New Structure("PathToValue, AddressBody", ?(BodyIsText, "[text]", "[file]"), AddressBody)
	);
	
EndProcedure

#EndRegion

#Region Private

// Get body as ValueStorage.
// 
// Parameters:
//  isRequest - Boolean - Is request
// 
// Returns:
//  BinaryData - Get body as BinaryData
&AtServer
Function GetBodyBinaryData(isRequest)
	AddressBinaryData = ?(isRequest, Request_Body, Answer_Body);
	If IsBlankString(AddressBinaryData) Then
		Return GetBinaryDataFromString("");
	Else
		Return GetFromTempStorage(AddressBinaryData);
	EndIf;
EndFunction

// Load body binary data.
// 
// Parameters:
//  isRequest - Boolean - Is request
//  BodyBinaryData - BinaryData, Undefined - Body binary data
&AtServer
Procedure LoadBodyBinaryData(isRequest, BodyBinaryData)
	AddressBinaryData = PutToTempStorage(BodyBinaryData, ThisObject.UUID);
	If isRequest Then
		Request_Body = AddressBinaryData;
	Else
		Answer_Body = AddressBinaryData;
	EndIf;
EndProcedure

&AtServer
Procedure TryLoadBodyAtServer(isRequest)
	
	If isRequest Then
		Prefix = "Request";
		BodyType = Object.Request_BodyType;
		BodyIsText = Object.Request_BodyIsText;
		BodyGroup = Items.BodyRequestPresentation;
		ThisObject.isEditRequestBody = False;
	Else
		Prefix = "Answer";
		BodyType = Object.Answer_BodyType;
		BodyIsText = Object.Answer_BodyIsText;
		BodyGroup = Items.BodyAnswerPresentation;
		ThisObject.isEditAnswerBody = False;
	EndIf;
	
	ThisObject[Prefix+"BodyString"] = "";
	ThisObject[Prefix+"BodyPicture"] = "";
	BodyRowValue = GetBodyBinaryData(isRequest);
	
	If BodyIsText Then
		ThisObject[Prefix+"BodyString"] = GetStringFromBinaryData(BodyRowValue);
		BodyGroup.CurrentPage = Items["Body"+Prefix+"AsStr"];
	ElsIf StrStartsWith(Upper(BodyType), "IMAGE") Then
		ThisObject[Prefix+"BodyPicture"] = PutToTempStorage(BodyRowValue);
		BodyGroup.CurrentPage = Items["Body"+Prefix+"AsPic"];
	Else
		BodyGroup.CurrentPage = Items["Body"+Prefix+"AsFile"];
	EndIf;
	
EndProcedure

&AtServer
Procedure ReloadBodyAtServer(isRequest, NewContent, Newsize)
	
	If isRequest Then
		LoadBodyBinaryData(True, New ValueStorage(NewContent));
		Object.Request_BodyMD5 = CommonFunctionsServer.GetMD5(NewContent);
		Object.Request_BodySize = Newsize;
		ThisObject.RequestBodySizePresentation = CommonFunctionsClientServer.GetSizePresentation(Newsize);
		ThisObject.isEditRequestBody = False;
		
	Else
		LoadBodyBinaryData(False, New ValueStorage(NewContent));
		Object.Answer_BodySize = Newsize;
		ThisObject.AnswerBodySizePresentation = CommonFunctionsClientServer.GetSizePresentation(Newsize);
		ThisObject.isEditAnswerBody = False;
		
	EndIf;
	
	TryLoadBodyAtServer(isRequest);
	
EndProcedure

&AtServer
Procedure ReloadTextBodyAtServer(isRequest)
	
	If isRequest Then
		NewContent = GetBinaryDataFromString(ThisObject.RequestBodyString);
		LoadBodyBinaryData(True, New ValueStorage(NewContent));
		Object.Request_BodyMD5 = CommonFunctionsServer.GetMD5(NewContent);
		Object.Request_BodySize = StrLen(ThisObject.RequestBodyString);
		ThisObject.RequestBodySizePresentation = CommonFunctionsClientServer.GetSizePresentation(Object.Request_BodySize);
		ThisObject.isEditRequestBody = False;
		
	Else
		NewContent = GetBinaryDataFromString(ThisObject.AnswerBodyString);
		LoadBodyBinaryData(False, New ValueStorage(NewContent));
		Object.Answer_BodySize = StrLen(ThisObject.AnswerBodyString);
		ThisObject.AnswerBodySizePresentation = CommonFunctionsClientServer.GetSizePresentation(Object.Answer_BodySize);
		ThisObject.isEditAnswerBody = False;
		
	EndIf;
	
	ThisObject.Modified = True;
	
EndProcedure

#EndRegion
