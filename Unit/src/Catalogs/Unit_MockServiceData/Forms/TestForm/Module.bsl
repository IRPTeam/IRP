// @strict-types

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.MockData = Parameters.MockData;
	ThisObject.Request = Parameters.Request;
	ThisObject.ReferenceAnswer = Parameters.Answer;
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure RunTestMockData(Command)
	
	ClearPreviousData();
	
	If Not ValueIsFilled(MockData) Then
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_010, Items.MockData.Title), "MockData", ThisObject);
		Return;
	EndIf;
	
	RunTestMockDataAtServer();
	
EndProcedure

&AtClient
Procedure CompareAnswers(Command)
	
	AnswerStructure = GetAnswerStructure(ReferenceAnswer);
	
	If Not AnswerStructure.StatusCode = StatusCode Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Mock_Info_StatusCodeNotMatch, "StatusCode", ThisObject);
	EndIf;
	
	isHeaderMatch = True;
	If Not TypeOf(AnswerStructure.Headers) = Type("Map") Or Not AnswerHeaders.Count() = AnswerStructure.Headers.Count() Then
		isHeaderMatch = False;
	Else
		For Each HeaderItem In AnswerHeaders Do
			ReferenceValue = AnswerStructure.Headers.Get(HeaderItem.Key);
			If Not ReferenceValue = HeaderItem.Value Then
				isHeaderMatch = False;
				Break;
			EndIf;
		EndDo;
	EndIf;
	If Not isHeaderMatch Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Mock_Info_HeaderNotMatch, "GroupAnswer_Headers", ThisObject);
	EndIf;
	
	If Not AnswerStructure.BodyMD5 = AnswerBodyMD5 Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Mock_Info_BodyNotMatch, "GroupAnswer_Body", ThisObject);
	EndIf;
	
EndProcedure

&AtClient
Procedure FindMock(Command)
	FindMockAtServer();
EndProcedure

&AtClient
Procedure TryLoadBody(Command)
	TryLoadBodyAtServer();
EndProcedure

&AtClient
Async Procedure SaveBody(Command)
	
	BodyRowValue = GetBodyAtServer();
	
	If Not TypeOf(BodyRowValue) = Type("BinaryData") Then
		ShowMessageBox(, R().Mock_Info_EmptyFile);
		Return;
	EndIf;
	
	FileDialog = New FileDialog(FileDialogMode.Save);
	If ThisObject.AnswerBodyIsText Then
		FileDialog.DefaultExt = "txt";
	EndIf;
	
	PathArray = Await FileDialog.ChooseAsync();
	If PathArray = Undefined Or PathArray.Count() = 0 Then
		Return;
	EndIf;
	FullFileName = PathArray[0];	
		
	BodyRowValue.Write(FullFileName);
	
EndProcedure

#EndRegion

#Region Private

// Get body at server.
// 
// Returns:
//  BinaryData - Get body at server
&AtServer
Function GetBodyAtServer()
	If IsBlankString(Answer_Body) Then
		Return GetBinaryDataFromString("");
	Else
		Return GetFromTempStorage(Answer_Body);
	EndIf;
EndFunction

&AtServer
Procedure TryLoadBodyAtServer()
	
	BodyGroup = Items.BodyAnswerPresentation;
	
	ThisObject.AnswerBodyString = "";
	ThisObject.AnswerBodyPicture = "";
	BodyRowValue = GetBodyAtServer();
	
	If ThisObject.AnswerBodyIsText Then
		ThisObject.AnswerBodyString = GetStringFromBinaryData(BodyRowValue);
		BodyGroup.CurrentPage = Items.BodyAnswerAsStr;
	ElsIf StrStartsWith(Upper(ThisObject.AnswerBodyType), "IMAGE") Then
		ThisObject.AnswerBodyPicture = PutToTempStorage(BodyRowValue);
		BodyGroup.CurrentPage = Items.BodyAnswerAsPic;
	Else
		BodyGroup.CurrentPage = Items.BodyAnswerAsFile;
	EndIf;
	
EndProcedure

&AtClient
Procedure ClearPreviousData()
	ThisObject.Logs = "";
	ThisObject.Variables.Clear();
	ThisObject.StatusCode = 0;
	ThisObject.Message = "";
	ThisObject.AnswerHeaders.Clear();
	ThisObject.AnswerBodySizePresentation = "";
	ThisObject.AnswerBodyType = "";
	ThisObject.AnswerBodyString = "";
	ThisObject.AnswerBodyPicture = "";
	ThisObject.AnswerBodyMD5 = "";
EndProcedure

&AtServer
Procedure RunTestMockDataAtServer()
	
	RequestStructure = GetRequestStructure(); 
	
	MockStructure = GetMockStructure();
	
	RequestVariables = New Structure;
	
	CheckingResult = Unit_MockService.CheckRequestToMockData(RequestStructure, MockStructure, RequestVariables);
	ThisObject.Logs = CheckingResult.Logs;
	
	If CheckingResult.Successfully Then
		LoadRequestVariables(RequestVariables);
		Answer = Unit_MockService.ComposeAnswerToRequestStructure(RequestStructure, ThisObject.MockData, RequestVariables);
		LoadAnswer(Answer);
	EndIf;
		
EndProcedure

// Get mock structure.
// 
// Returns:
//  See Unit_MockService.GetSelectionMockStructure
&AtServer
Function GetMockStructure()
	
	MockStructure = Unit_MockService.GetSelectionMockStructure();
	
	MockStructure.Ref = ThisObject.MockData;
	MockStructure.BodyMD5 = ThisObject.MockData.Request_BodyMD5;
	MockStructure.BodyAsFilter = ThisObject.MockData.Request_BodyAsFilter;

	MockStructure.Address = ThisObject.MockData.Request_ResourceAddress;
	ArrayOfSegments = StrSplit(MockStructure.Address, "?");
	If ArrayOfSegments.Count() > 1 Then
		MockStructure.Address = ArrayOfSegments[0];
	EndIf; 
	
	For Each Element In ThisObject.MockData.Request_Headers Do
		If Element.ValueAsFilter Then
			MockStructure.isHeaderFilter = True;
			Break;
		EndIf;
	EndDo;
	For Each Element In ThisObject.MockData.Request_Variables Do
		If Element.ValueAsFilter Then
			MockStructure.isVariablesFilter = True;
			Break;
		EndIf;
	EndDo;
	For Each Element In ThisObject.MockData.Request_BodyVariables Do
		If Element.ValueAsFilter Then
			MockStructure.isVariablesBodyFilter = True;
			Break;
		EndIf;
	EndDo;
	
	Return MockStructure;
	
EndFunction

// Get request structure.
// 
// Returns:
//  See Unit_MockService.GetStructureRequest
&AtServer
Function GetRequestStructure()
	
	RequestStructure = Unit_MockService.GetStructureRequest();
	
	RequestStructure.Type = ThisObject.Request.RequestType; 
	RequestStructure.Address = ThisObject.Request.ResourceAddress;
	
	RequestOptions = New Map;
	ArrayOfSegments = StrSplit(RequestStructure.Address, "?");
	If ArrayOfSegments.Count() > 1 Then
		RequestStructure.Address = ArrayOfSegments[0];
		OptionsSegments = ArrayOfSegments[1];
		ArrayOfSegments = StrSplit(OptionsSegments, "&");
		For Each OptionsSegment In ArrayOfSegments Do
			KeyValueString = DecodeString(OptionsSegment, StringEncodingMethod.URLInURLEncoding);
			EqualPosition = StrFind(KeyValueString, "=");
			If EqualPosition = 0 Then
				RequestOptions.Insert(KeyValueString, "");
			Else
				RequestOptions.Insert(
					TrimAll(Mid(KeyValueString, 1, EqualPosition - 1)), 
					TrimAll(Mid(KeyValueString, EqualPosition + 1)));
			EndIf;
		EndDo;
	EndIf;
	RequestStructure.Options = New FixedMap(RequestOptions);
	
	HeadersMap = ThisObject.Request.Headers.Get();
	If TypeOf(HeadersMap) = Type("Map") Then	
		RequestStructure.Headers = New FixedMap(HeadersMap);
	Else
		RequestStructure.Headers = New FixedMap(New Map);
	EndIf;
	
	BodyData = ThisObject.Request.Body.Get(); // BinaryData
	RequestStructure.BodyBinary = BodyData;
	Try
		RequestStructure.BodyString = GetStringFromBinaryData(BodyData);
	Except
		RequestStructure.BodyString = "";
	EndTry;
	
	Return RequestStructure;
	
EndFunction

// Load request variables.
// 
// Parameters:
//  RequestVariables - Array of KeyAndValue:
//	  * Key - String
//	  * Value - String
&AtServer
Procedure LoadRequestVariables(RequestVariables)
	
	For Each KeyValue In RequestVariables Do
		RecordVariables = ThisObject.Variables.Add();
		RecordVariables.Key = KeyValue.Key;
		RecordVariables.Value = KeyValue.Value; 
	EndDo;

EndProcedure

// Load answer.
// 
// Parameters:
//  Answer - HTTPServiceResponse
&AtServer
Procedure LoadAnswer(Answer)
	
	ThisObject.StatusCode = Answer.StatusCode;
	ThisObject.Message = Answer.Reason;
	
	For Each HeaderItem In Answer.Headers Do
		NewRecord = ThisObject.AnswerHeaders.Add();
		NewRecord.Key = String(HeaderItem.Key);
		NewRecord.Value = String(HeaderItem.Value);
	EndDo;
	
	BodyRowValue = Answer.GetBodyAsBinaryData();
	Answer_Body = PutToTempStorage(BodyRowValue, ThisObject.UUID);
	
	BodyInfo = IntegrationServer.Unit_GetBodyInfo(BodyRowValue, Answer.Headers);
	ThisObject.AnswerBodySize = BodyInfo.Size;
	ThisObject.AnswerBodyMD5 = BodyInfo.MD5;  
	
	ThisObject.AnswerBodyIsText = True;
	ThisObject.AnswerBodyType = String(Answer.Headers.Get("Content-Type"));
	ArrayOfSegments = StrSplit(ThisObject.AnswerBodyType, "/");
	If ArrayOfSegments.Count() >= 1 And Upper(ArrayOfSegments[0]) = "IMAGE" Then
		ThisObject.AnswerBodyIsText = False;
	EndIf;
	 
	ThisObject.AnswerBodySizePresentation = CommonFunctionsClientServer.GetSizePresentation(ThisObject.AnswerBodySize);
	
	Megabyte = Pow(2, 20);
	If ThisObject.AnswerBodyIsText And ThisObject.AnswerBodySize < Megabyte Then
		 TryLoadBodyAtServer();
	EndIf;
	
EndProcedure

// Get answer structure.
// 
// Parameters:
//  ReferenceAnswer - CatalogRef.Unit_ServiceExchangeHistory - Reference answer
// 
// Returns:
//  Structure - Get answer structure:
// * StatusCode - Number
// * BodyMD5 - String
// * Headers - Map
&AtServerNoContext
Function GetAnswerStructure(ReferenceAnswer)
	
	AnswerStructure = 
		CommonFunctionsServer.GetAttributesFromRef(
			ReferenceAnswer, "StatusCode, Headers, BodyMD5");
	
	Result = New Structure;
	Result.Insert("StatusCode", AnswerStructure.StatusCode);
	Result.Insert("BodyMD5", AnswerStructure.BodyMD5);
	Result.Insert("Headers", AnswerStructure.Headers.Get());
	Return Result;
	
EndFunction

&AtServer
Procedure FindMockAtServer()
	
	MockDataInfo = Unit_MockService.getMockDataByRequest(GetRequestStructure());
	MockData = MockDataInfo.MockData;	
	
EndProcedure


#EndRegion