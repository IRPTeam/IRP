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
	If not ValueIsFilled(MockData) Then
		ShowMessageBox(, "Select mock data element");
		Return;
	EndIf;
	RunTestMockDataAtServer();
EndProcedure

&AtClient
Procedure RunTestMockService(Command)
	ClearPreviousData();
	If IsBlankString(ServiceURL) Then
		ShowMessageBox(, "Enter the path to the mock service");
		Return;
	EndIf;
	RunTestMockServiceAtServer();
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
Procedure SaveBody(Command)
	
	BodyRowValue = GetBodyAtServer(); // BinaryData
	
	If TypeOf(BodyRowValue) <> Type("BinaryData") Then
		ShowMessageBox(,"Empty file!");
		Return;
	EndIf;
	
	BodyRowValue.BeginWrite();
	
EndProcedure

#EndRegion


#Region Private

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
	
	BodyType = Upper(AnswerBodyType);
	BodyGroup = Items.BodyAnswerPresentation;
	
	AnswerBodyString = "";
	AnswerBodyPicture = "";
	
	BodyRowValue = GetBodyAtServer(); // BinaryData
	
	If AnswerBodyIsText Then
		AnswerBodyString = GetStringFromBinaryData(BodyRowValue);
		BodyGroup.CurrentPage = Items.BodyAnswerAsStr;
		Return;
	EndIf;
	
	If Left(BodyType, 5) = "IMAGE" Then
		//@skip-check empty-except-statement
		Try
			AnswerBodyPicture = PutToTempStorage(BodyRowValue);
			BodyGroup.CurrentPage = Items.BodyAnswerAsPic;
			Return;
		Except EndTry;				
	EndIf;
	
	BodyGroup.CurrentPage = Items.BodyAnswerAsFile;
	
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
		OptionsSegments = ArrayOfSegments[1];
		ArrayOfSegments = StrSplit(OptionsSegments, "&");
		For Each OptionsSegment In ArrayOfSegments Do
			EqualPosition = StrFind(OptionsSegment, "=");
			If EqualPosition > 1 Then
				RequestOptions.Insert(OptionsSegment, "");
			Else
				RequestOptions.Insert(TrimAll(Mid(OptionsSegment,1,EqualPosition-1)), TrimAll(Mid(OptionsSegment,EqualPosition+1)));
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
	
	RequestStructure.Body = Request.Body.Get();
	
	Answer = Unit_MockService.ComposeAnswerToRequestStructure(RequestStructure, MockData);
	LoadAnswer(Answer);
		
EndProcedure

&AtServer
Procedure RunTestMockServiceAtServer()
	
	RequestStructure = Unit_MockService.GetStructureRequest();
	
	RequestStructure.Type = Request.RequestType; 
	RequestStructure.Address = Request.ResourceAddress;
	
	RequestOptions = New Map;
	ArrayOfSegments = StrSplit(RequestStructure.Address, "?");
	If ArrayOfSegments.Count() > 1 Then
		OptionsSegments = ArrayOfSegments[1];
		ArrayOfSegments = StrSplit(OptionsSegments, "&");
		For Each OptionsSegment In ArrayOfSegments Do
			EqualPosition = StrFind(OptionsSegment, "=");
			If EqualPosition > 1 Then
				RequestOptions.Insert(OptionsSegment, "");
			Else
				RequestOptions.Insert(TrimAll(Mid(OptionsSegment,1,EqualPosition-1)), TrimAll(Mid(OptionsSegment,EqualPosition+1)));
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
	
	RequestStructure.Body = Request.Body.Get();
	
	Answer = Unit_MockService.ComposeAnswerToRequestStructure(RequestStructure, MockData);
	LoadAnswer(Answer);
		
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
	If ArrayOfSegments.Count() >= 1 And Upper(TrimAll(ArrayOfSegments[0])) = "IMAGE" Then
		AnswerBodyIsText = False;
	EndIf;

	AnswerBodySizePresentation = Unit_CommonFunctionsClientServer.GetSizePresentation(AnswerBodySize);
	
EndProcedure

#EndRegion