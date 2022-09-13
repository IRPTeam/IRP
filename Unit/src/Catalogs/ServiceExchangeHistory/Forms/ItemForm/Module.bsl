// @strict-types

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	RealObject = FormDataToValue(Object, Type("CatalogObject.ServiceExchangeHistory")); //CatalogObject.ServiceExchangeHistory 
	
	HeadersValue = RealObject.Headers.Get();
	If TypeOf(HeadersValue) = Type("Map") Then
		For Each KeyValue In HeadersValue Do
			HeaderRow = HeadersTable.Add();
			HeaderRow.Key = String(KeyValue.Key);
			HeaderRow.Value = String(KeyValue.Value);
		EndDo;
	EndIf;
	
	If Object.Parent.IsEmpty() Then			// Query
		Items.GroupAnswer.Visible = False;
	Else									// Answer
		Items.GroupQuery.Visible = False;
	EndIf;
	
	BodySizePresentation = Unit_CommonFunctionsClientServer.GetSizePresentation(Object.BodySize);
	
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

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

&AtClient
Procedure TryLoadBody(Command)
	TryLoadBodyAtServer();
EndProcedure

&AtClient
Async Procedure ReloadBody(Command)
	
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
	
	If StrFind(Upper(Object.BodyType), "TEXT") > 0
			or StrFind(Upper(Object.BodyType), "HTML") > 0
			or StrFind(Upper(Object.BodyType), "XML") > 0
			or StrFind(Upper(Object.BodyType), "JSON") > 0  Then
		TextFile = New TextDocument();
		TextFile.Read(FullFileName);
		ContentFile = TextFile.GetText(); 
	Else
		ContentFile = New BinaryData(FullFileName);
	EndIf;
	 
	ReloadBodyAtServer(ContentFile, SizeNewFile);
	
	Modified = False;
		 
EndProcedure

#EndRegion

#Region Private

&AtServer
function GetBodyAtServer()
	RealObject = FormDataToValue(Object, Type("CatalogObject.ServiceExchangeHistory")); //CatalogObject.ServiceExchangeHistory
	Return RealObject.Body.Get();
EndFunction

&AtServer
Procedure TryLoadBodyAtServer()
	
	BodyString = "";
	BodyPicture = "";
	
	If Object.BodyType = "" or Upper(Object.BodyType) = "BINARY" Then
		Items.BodyPresentation.CurrentPage = Items.BodyAsFile;
		Return; 
	EndIf;
	
	RealObject = FormDataToValue(Object, Type("CatalogObject.ServiceExchangeHistory")); //CatalogObject.ServiceExchangeHistory
	BodyRowValue = RealObject.Body.Get();
	
	If Upper(Left(Object.BodyType, 5)) = "IMAGE" Then
		//@skip-check empty-except-statement
		Try
			BodyPicture = PutToTempStorage(BodyRowValue);
			Items.BodyPresentation.CurrentPage = Items.BodyAsPic;
			Return;
		Except EndTry;				
	EndIf;
	
	BodyString = String(BodyRowValue);
	Items.BodyPresentation.CurrentPage = Items.BodyAsStr;
	
EndProcedure

// Reload body at server.
// 
// Parameters:
//  NewContent - String, BinaryData - New content
//  Newsize - Number
&AtServer
Procedure ReloadBodyAtServer(NewContent, Newsize)
	
	RealObject = FormDataToValue(Object, Type("CatalogObject.ServiceExchangeHistory")); //CatalogObject.ServiceExchangeHistory
	
	RealObject.Body = New ValueStorage(NewContent);
	RealObject.BodyMD5 = CommonFunctionsServer.GetMD5(NewContent);
	RealObject.BodySize = Newsize;
	
	RealObject.Write();
	
	ValueToFormData(RealObject, Object);
	
	BodySizePresentation = Unit_CommonFunctionsClientServer.GetSizePresentation(Object.BodySize);
	
	TryLoadBodyAtServer();
	
EndProcedure

#EndRegion