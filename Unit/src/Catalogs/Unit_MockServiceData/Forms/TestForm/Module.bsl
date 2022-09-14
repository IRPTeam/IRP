// @strict-types


#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	MockData = Parameters.MockData;
	Query = Parameters.Query;

EndProcedure

#EndRegion


#Region FormCommandsEventHandlers

&AtClient
Procedure RunTestMockData(Command)
	ClearPreviousData();
EndProcedure

&AtClient
Procedure RunTestMockService(Command)
	ClearPreviousData();
EndProcedure

&AtClient
Procedure TryLoadBody(Command)
	TryLoadBodyAtServer();
EndProcedure

&AtClient
Async Procedure SaveBody(Command)
	
	BodyRowValue = GetBodyAtServer();
	
	If TypeOf(BodyRowValue) = Type("Undefined") or (TypeOf(BodyRowValue) = Type("String") and IsBlankString(BodyRowValue)) Then
		ShowMessageBox(,"Empty file!");
		Return;
	EndIf;
	
	If TypeOf(BodyRowValue) = Type("BinaryData") Then
		BodyRowValue.BeginWrite();
		Return;		
	EndIf;
	
	FileDialog = New FileDialog(FileDialogMode.Save);

	PathArray = Await FileDialog.ChooseAsync(); // Array
	If PathArray = Undefined or PathArray.Count()=0 Then
		Return;
	EndIf;
	FullFileName = PathArray[0]; // String
	
	TextFile = New TextDocument();
	TextFile.SetText(String(BodyRowValue));
	TextFile.Write(FullFileName);
	
EndProcedure

#EndRegion


#Region Private

&AtServer
Function GetBodyAtServer()
	CurrentBody = Answer_Body; // ValueStorage
	If TypeOf(CurrentBody) = Type("ValueStorage") Then
		Return CurrentBody.Get();
	EndIf;
	Return "";
EndFunction

&AtServer
Procedure TryLoadBodyAtServer()
	
	BodyType = Upper(AnswerBodyType);
	BodyGroup = Items.BodyAnswerPresentation;
	
	AnswerBodyString = "";
	AnswerBodyPicture = "";
	
	If BodyType = "" or BodyType = "BINARY" Then
		BodyGroup.CurrentPage = Items.BodyAnswerAsFile;
		Return; 
	EndIf;
	
	BodyRowValue = GetBodyAtServer(); // BinaryData
	
	If Left(BodyType, 5) = "IMAGE" Then
		//@skip-check empty-except-statement
		Try
			AnswerBodyPicture = PutToTempStorage(BodyRowValue);
			BodyGroup.CurrentPage = Items.BodyAnswerAsPic;
			Return;
		Except EndTry;				
	EndIf;
	
	AnswerBodyString = String(BodyRowValue);
	BodyGroup.CurrentPage = Items.BodyAnswerAsStr;
	
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

#EndRegion