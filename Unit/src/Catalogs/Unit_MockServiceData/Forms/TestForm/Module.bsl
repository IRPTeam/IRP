// @strict-types


#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	MockData = Parameters.MockData;
	Request = Parameters.Request;
	ReferenceAnswer = Parameters.Answer;

EndProcedure

#EndRegion


#Region FormCommandsEventHandlers

&AtClient
Procedure RunTestMockData(Command)
	ClearPreviousData();
	If Not ValueIsFilled(MockData) Then
		CommonFunctionsClientServer.ShowUsersMessage(
				StrTemplate(R().Error_010, Items.MockData.Title), "MockData", ThisObject);
		Return;
	EndIf;
	RunTestMockDataAtServer();
EndProcedure

&AtClient
Procedure CompareAnswers(Command)
	//TODO: Insert the handler content
EndProcedure

&AtClient
Procedure TryLoadBody(Command)
	TryLoadBodyAtServer();
EndProcedure

&AtClient
Async Procedure SaveBody(Command)
	
	BodyRowValue = GetBodyAtServer();
	
	If TypeOf(BodyRowValue) <> Type("BinaryData") Then
		ShowMessageBox(, R().Mock_001);
		Return;
	EndIf;
	
	FileDialog = New FileDialog(FileDialogMode.Save);
	If AnswerBodyIsText Then
		FileDialog.DefaultExt = "txt";
	EndIf;
	
	PathArray = Await FileDialog.ChooseAsync(); // Array
	If PathArray = Undefined Or PathArray.Count() = 0 Then
		Return;
	EndIf;
	FullFileName = PathArray[0]; // String	
		
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
	CurrentBody = Answer_Body; // ValueStorage
	If TypeOf(CurrentBody) = Type("ValueStorage") Then
		Return CurrentBody.Get();
	EndIf;
	Return Undefined;
EndFunction

&AtServer
Procedure TryLoadBodyAtServer()
	
	BodyGroup = Items.BodyAnswerPresentation;
	
	AnswerBodyString = "";
	AnswerBodyPicture = "";
	
	BodyRowValue = GetBodyAtServer();
	
	If AnswerBodyIsText Then
		AnswerBodyString = GetStringFromBinaryData(BodyRowValue);
		BodyGroup.CurrentPage = Items.BodyAnswerAsStr;
	ElsIf StrCompare(Left(AnswerBodyType, 5), "IMAGE") = 0 Then
		AnswerBodyPicture = PutToTempStorage(BodyRowValue);
		BodyGroup.CurrentPage = Items.BodyAnswerAsPic;
	Else
		BodyGroup.CurrentPage = Items.BodyAnswerAsFile;
	EndIf;
	
EndProcedure

&AtClient
Procedure ClearPreviousData()
	Logs = "";
	Variables.Clear();
	StatusCode = 0;
	Message = "";
	AnswerHeaders.Clear();
	AnswerBodySizePresentation = "";
	AnswerBodyType = "";
	Answer_Body = Undefined;
	AnswerBodyString = "";
	AnswerBodyPicture = "";
EndProcedure

&AtServer
Procedure RunTestMockDataAtServer()
	
	RequestStructure = Unit_MockService.GetStructureRequest();
	
	RequestStructure.Type = Request.RequestType; 
	RequestStructure.Address = Request.ResourceAddress;
	
	RequestOptions = New Map;
	ArrayOfSegments = StrSplit(RequestStructure.Address, "?");
	If ArrayOfSegments.Count() > 1 Then
		RequestStructure.Address = ArrayOfSegments[0];
		OptionsSegments = ArrayOfSegments[1];
		ArrayOfSegments = StrSplit(OptionsSegments, "&");
		For Each OptionsSegment In ArrayOfSegments Do
			EqualPosition = StrFind(OptionsSegment, "=");
			If EqualPosition > 1 Then
				RequestOptions.Insert(OptionsSegment, "");
			Else
				RequestOptions.Insert(
					TrimAll(Mid(OptionsSegment, 1, EqualPosition-1)), 
					TrimAll(Mid(OptionsSegment, EqualPosition+1)));
			EndIf;
		EndDo;
	EndIf;
	RequestStructure.Options = New FixedMap(RequestOptions);
	
	HeadersMap = Request.Headers.Get();
	If TypeOf(HeadersMap) = Type("Map") Then	
		RequestStructure.Headers = New FixedMap(HeadersMap);
	Else
		RequestStructure.Headers = New FixedMap(New Map);
	EndIf;
	
	BodyData = Request.Body.Get(); // BinaryData
	RequestStructure.BodyBinary = BodyData;
	Try
		RequestStructure.BodyString = GetStringFromBinaryData(BodyData);
	Except
		RequestStructure.BodyString = "";
	EndTry; 
	
	MockStructure = Unit_MockService.GetSelectionMockStructure();
	MockStructure.Ref = MockData;
	MockStructure.BodyMD5 = MockData.Request_BodyMD5;
	MockStructure.BodyAsFilter = MockData.Request_BodyAsFilter;

	MockStructure.Address = MockData.Request_ResourceAddress;
	ArrayOfSegments = StrSplit(MockStructure.Address, "?");
	If ArrayOfSegments.Count() > 1 Then
		MockStructure.Address = ArrayOfSegments[0];
	EndIf; 
	
	For Each Element In MockData.Request_Headers Do
		If Element.ValueAsFilter Then
			MockStructure.isHeaderFilter = True;
			Break;
		EndIf;
	EndDo;
	For Each Element In MockData.Request_Variables Do
		If Element.ValueAsFilter Then
			MockStructure.isVariablesFilter = True;
			Break;
		EndIf;
	EndDo;
	For Each Element In MockData.Request_BodyVariables Do
		If Element.ValueAsFilter Then
			MockStructure.isVariablesBodyFilter = True;
			Break;
		EndIf;
	EndDo;
	
	RequestVariables = New Structure;
	
	CheckingResult = Unit_MockService.CheckRequestToMockData(RequestStructure, MockStructure, RequestVariables);
	Logs = CheckingResult.Logs;
	If Not CheckingResult.Successfully Then
		Return;
	EndIf;
	
	LoadRequestVariables(RequestVariables);
	
	Answer = Unit_MockService.ComposeAnswerToRequestStructure(RequestStructure, MockData, RequestVariables);
	LoadAnswer(Answer);
		
EndProcedure

// Load request variables.
// 
// Parameters:
//  RequestVariables - Arbitrary, Structure - Request variables
&AtServer
Procedure LoadRequestVariables(RequestVariables)
	
	If TypeOf(RequestVariables) <> Type("Structure") Then
		Return;
	EndIf;
	
	For Each KeyValue In RequestVariables Do
		RecordVariables = Variables.Add();
		RecordVariables.Key = String(KeyValue.Key);
		RecordVariables.Value = String(KeyValue.Value); 
	EndDo;

EndProcedure

&AtServer
Procedure LoadAnswer(Answer)
	
	StatusCode = Answer.StatusCode;
	Message = Answer.Reason;
	
	For Each HeaderItem In Answer.Headers Do
		NewRecord = AnswerHeaders.Add();
		NewRecord.Key = String(HeaderItem.Key);
		NewRecord.Value = String(HeaderItem.Value);
	EndDo;
	
	BodyRowValue = Answer.GetBodyAsBinaryData();
	Answer_Body = New ValueStorage(BodyRowValue);
	
	BodyInfo = IntegrationServer.Unit_GetBodyInfo(BodyRowValue, Answer.Headers);
	AnswerBodySize = BodyInfo.Size;  
	
	AnswerBodyIsText = True;
	AnswerBodyType = String(Answer.Headers.Get("Content-Type"));
	ArrayOfSegments = StrSplit(AnswerBodyType, "/");
	If ArrayOfSegments.Count() >= 1 And StrCompare(ArrayOfSegments[0], "IMAGE") = 0 Then
		AnswerBodyIsText = False;
	EndIf;

	AnswerBodySizePresentation = CommonFunctionsClientServer.GetSizePresentation(AnswerBodySize);
	
EndProcedure

#EndRegion