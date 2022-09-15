// @strict-types


#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	If Object.Ref.IsEmpty() Then
		If Parameters.Property("Basis") and TypeOf(Parameters.Basis) = Type("CatalogRef.Unit_ServiceExchangeHistory") Then
			InputRequest = Parameters.Basis;  // CatalogRef.Unit_ServiceExchangeHistory
			InputAnswer = Parameters.Basis; // CatalogRef.Unit_ServiceExchangeHistory
			If InputAnswer.Parent.IsEmpty() Then
				Selection = Catalogs.Unit_ServiceExchangeHistory.Select(InputRequest,,, "Time desc");
				If Selection.Next() Then
					InputAnswer = Selection.Ref;
				EndIf;
			Else
				InputRequest = InputAnswer.Parent;
			EndIf;
			Request_Body  = InputRequest.Body;
			Answer_Body = InputAnswer.Body;
		EndIf;
	Else
		Request_Body = Object.Ref.Request_Body;
		Answer_Body = Object.Ref.Answer_Body; 
	EndIf; 
	
	RequestBodySizePresentation = Unit_CommonFunctionsClientServer.GetSizePresentation(Object.Request_BodySize);
	AnswerBodySizePresentation = Unit_CommonFunctionsClientServer.GetSizePresentation(Object.Answer_BodySize);

EndProcedure


&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	
	ValueStorage = Request_Body; // ValueStorage
	CurrentObject.Request_Body  = ValueStorage;
	
	ValueStorage = Answer_Body; // ValueStorage
	CurrentObject.Answer_Body = ValueStorage;
	
EndProcedure

#EndRegion


#Region FormCommandsEventHandlers

&AtClient
Procedure TryLoadBody(Command)
	
	isRequest = Left(Command.Name, 7) = "Request";
	TryLoadBodyAtServer(isRequest);
	
EndProcedure

&AtClient
Async Procedure SaveBody(Command)
	
	isRequest = Left(Command.Name, 7) = "Request";
	
	BodyRowValue = GetBodyAtServer(isRequest);
	
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

&AtClient
Async Procedure ReloadBody(Command)
	
	If Object.Ref.IsEmpty() Then
		ShowMessageBox(, "First you need to write the element!");
		Return;
	EndIf; 
	
	isRequest = Left(Command.Name, 7) = "Request";
	
	OldModified = Modified;
	
	SizeNewFile = 0;
	ContentFile = Undefined;
	
	FileDialog = New FileDialog(FileDialogMode.Open);
	FileDialog.CheckFileExistence = True;
	
	PathArray = Await FileDialog.ChooseAsync(); // Array
	If PathArray = Undefined or PathArray.Count()=0 Then
		Return;
	EndIf;
	FullFileName = PathArray[0]; // String
	
	File = New File(FullFileName); 
	SizeNewFile = File.Size();
	
	isText = ?(isRequest, Object.Request_BodyIsText, Object.Answer_BodyIsText);
	If isText Then
		TextFile = New TextDocument();
		TextFile.Read(FullFileName);
		ContentFile = TextFile.GetText(); 
	Else
		ContentFile = New BinaryData(FullFileName);
	EndIf;
	 
	ReloadBodyAtServer(isRequest, ContentFile, SizeNewFile);
	
	Modified = OldModified;
		 
EndProcedure

#EndRegion



#Region Private

&AtServer
Function GetBodyAtServer(isRequest)
	CurrentBody = ?(isRequest, Request_Body, Answer_Body); // ValueStorage
	Return CurrentBody.Get();
EndFunction

&AtServer
Procedure TryLoadBodyAtServer(isRequest)
	
	If isRequest Then
		Prefix = "Request";
		BodyType = Upper(Object.Request_BodyType);
		BodyIsText = Object.Request_BodyIsText;
		BodyGroup = Items.BodyRequestPresentation;
	Else
		Prefix = "Answer";
		BodyType = Upper(Object.Answer_BodyType);
		BodyIsText = Object.Answer_BodyIsText;
		BodyGroup = Items.BodyAnswerPresentation;
	EndIf;
	
	ThisObject[Prefix+"BodyString"] = "";
	ThisObject[Prefix+"BodyPicture"] = "";
	
	BodyRowValue = GetBodyAtServer(isRequest); // BinaryData
	
	If BodyIsText Then
		ThisObject[Prefix+"BodyString"]  = String(BodyRowValue);
		BodyGroup.CurrentPage = Items["Body"+Prefix+"AsStr"];
		Return;
	EndIf;
	
	If Left(BodyType, 5) = "IMAGE" Then
		//@skip-check empty-except-statement
		Try
			ThisObject[Prefix+"BodyPicture"] = PutToTempStorage(BodyRowValue);
			BodyGroup.CurrentPage = Items["Body"+Prefix+"AsPic"];
			Return;
		Except EndTry;				
	EndIf;
	
	BodyGroup.CurrentPage = Items["Body"+Prefix+"AsFile"];
	
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
	
	ThisObject[Prefix+"BodySizePresentation"] = Unit_CommonFunctionsClientServer.GetSizePresentation(Newsize);
	
	TryLoadBodyAtServer(isRequest);
	
EndProcedure


#EndRegion

