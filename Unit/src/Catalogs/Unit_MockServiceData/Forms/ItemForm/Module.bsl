// @strict-types


#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	If Object.Ref.IsEmpty() Then
		If Parameters.Property("Basis") and TypeOf(Parameters.Basis) = Type("CatalogRef.Unit_ServiceExchangeHistory") Then
			InputQuery = Parameters.Basis;  // CatalogRef.Unit_ServiceExchangeHistory
			InputAnswer = Parameters.Basis; // CatalogRef.Unit_ServiceExchangeHistory
			If InputAnswer.Parent.IsEmpty() Then
				Selection = Catalogs.Unit_ServiceExchangeHistory.Select(InputQuery,,, "Time desc");
				If Selection.Next() Then
					InputAnswer = Selection.Ref;
				EndIf;
			Else
				InputQuery = InputAnswer.Parent;
			EndIf;
			Query_Body  = InputQuery.Body;
			Answer_Body = InputAnswer.Body;
		EndIf;
	Else
		Query_Body = Object.Ref.Query_Body;
		Answer_Body = Object.Ref.Answer_Body; 
	EndIf; 
	
	QueryBodySizePresentation = Unit_CommonFunctionsClientServer.GetSizePresentation(Object.Query_BodySize);
	AnswerBodySizePresentation = Unit_CommonFunctionsClientServer.GetSizePresentation(Object.Answer_BodySize);

EndProcedure


&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	
	ValueStorage = Query_Body; // ValueStorage
	CurrentObject.Query_Body  = ValueStorage;
	
	ValueStorage = Answer_Body; // ValueStorage
	CurrentObject.Answer_Body = ValueStorage;
	
EndProcedure

#EndRegion


#Region FormCommandsEventHandlers

&AtClient
Procedure TryLoadBody(Command)
	
	isQuery = Left(Command.Name, 5) = "Query";
	TryLoadBodyAtServer(isQuery);
	
EndProcedure

&AtClient
Async Procedure SaveBody(Command)
	
	isQuery = Left(Command.Name, 5) = "Query";
	
	BodyRowValue = GetBodyAtServer(isQuery);
	
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
	
	isQuery = Left(Command.Name, 5) = "Query";
	
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
	
	BodyType = ?(isQuery, Object.Query_BodyType, Object.Answer_BodyType);
	BodyType = Upper(BodyType);
	
	If StrFind(BodyType, "TEXT") > 0
			or StrFind(BodyType, "HTML") > 0
			or StrFind(BodyType, "XML") > 0
			or StrFind(BodyType, "JSON") > 0  Then
		TextFile = New TextDocument();
		TextFile.Read(FullFileName);
		ContentFile = TextFile.GetText(); 
	Else
		ContentFile = New BinaryData(FullFileName);
	EndIf;
	 
	ReloadBodyAtServer(isQuery, ContentFile, SizeNewFile);
	
	Modified = OldModified;
		 
EndProcedure

#EndRegion



#Region Private

&AtServer
Function GetBodyAtServer(isQuery)
	CurrentBody = ?(isQuery, Query_Body, Answer_Body); // ValueStorage
	Return CurrentBody.Get();
EndFunction

&AtServer
Procedure TryLoadBodyAtServer(isQuery)
	
	If isQuery Then
		Prefix = "Query";
		BodyType = Upper(Object.Query_BodyType);
		BodyGroup = Items.BodyQueryPresentation;
	Else
		Prefix = "Answer";
		BodyType = Upper(Object.Answer_BodyType);
		BodyGroup = Items.BodyAnswerPresentation;
	EndIf;
	
	ThisObject[Prefix+"BodyString"] = "";
	ThisObject[Prefix+"BodyPicture"] = "";
	
	If BodyType = "" or BodyType = "BINARY" Then
		BodyGroup.CurrentPage = Items["Body"+Prefix+"AsFile"];
		Return; 
	EndIf;
	
	BodyRowValue = GetBodyAtServer(isQuery); // BinaryData
	
	If Left(BodyType, 5) = "IMAGE" Then
		//@skip-check empty-except-statement
		Try
			ThisObject[Prefix+"BodyPicture"] = PutToTempStorage(BodyRowValue);
			BodyGroup.CurrentPage = Items["Body"+Prefix+"AsPic"];
			Return;
		Except EndTry;				
	EndIf;
	
	ThisObject[Prefix+"BodyString"]  = String(BodyRowValue);
	BodyGroup.CurrentPage = Items["Body"+Prefix+"AsStr"];
	
EndProcedure

&AtServer
Procedure ReloadBodyAtServer(isQuery, NewContent, Newsize)
	
	If isQuery Then
		Prefix = "Query";
		Query_Body = New ValueStorage(NewContent);
		Object.Query_BodyMD5 = CommonFunctionsServer.GetMD5(NewContent);
		Object.Query_BodySize = Newsize;
	Else
		Prefix = "Answer";
		Answer_Body = New ValueStorage(NewContent);
		Object.Answer_BodySize = Newsize;
	EndIf;
	
	ThisObject[Prefix+"BodySizePresentation"] = Unit_CommonFunctionsClientServer.GetSizePresentation(Newsize);
	
	TryLoadBodyAtServer(isQuery);
	
EndProcedure


#EndRegion

