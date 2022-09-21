// @strict-types

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	RealObject = FormDataToValue(Object, Type("CatalogObject.Unit_ServiceExchangeHistory")); //CatalogObject.Unit_ServiceExchangeHistory 
	
	HeadersValue = RealObject.Headers.Get();
	If TypeOf(HeadersValue) = Type("Map") Then
		For Each KeyValue In HeadersValue Do
			HeaderRow = HeadersTable.Add();
			HeaderRow.Key = String(KeyValue.Key);
			HeaderRow.Value = String(KeyValue.Value);
		EndDo;
	EndIf;
	
	If Object.Parent.IsEmpty() Then	// Request
		Items.GroupAnswer.Visible = False;
	Else							// Answer
		Items.GroupRequest.Visible = False;
	EndIf;
	
	BodySizePresentation = CommonFunctionsClientServer.GetSizePresentation(Object.BodySize);
	
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Async Procedure SaveBody(Command)
	
	BodyRowValue = GetBodyAtServer();
	
	If TypeOf(BodyRowValue) <> Type("BinaryData") Then
		ShowMessageBox(, R().Mock_001);
		Return;
	EndIf;
	
	FileDialog = New FileDialog(FileDialogMode.Save);
	If Object.BodyIsText Then
		FileDialog.DefaultExt = "txt";
	EndIf;
	
	PathArray = Await FileDialog.ChooseAsync(); // Array
	If PathArray = Undefined Or PathArray.Count() = 0 Then
		Return;
	EndIf;
	FullFileName = PathArray[0]; // String	
	
	BodyRowValue.Write(FullFileName);
	
EndProcedure

&AtClient
Procedure TryLoadBody(Command)
	TryLoadBodyAtServer();
EndProcedure

&AtClient
Async Procedure ReloadBody(Command)
	
	OldModified = Modified;
	
	SizeNewFile = 0;
	ContentFile = Undefined;
	
	FileDialog = New FileDialog(FileDialogMode.Open);
	FileDialog.CheckFileExistence = True;
	
	PathArray = Await FileDialog.ChooseAsync(); // Array
	If PathArray = Undefined Or PathArray.Count() = 0 Then
		Return;
	EndIf;
	FullFileName = PathArray[0]; // String
	
	File = New File(FullFileName); 
	SizeNewFile = File.Size();
	
	ContentFile = New BinaryData(FullFileName);
	 
	ReloadBodyAtServer(ContentFile, SizeNewFile);
	
	Modified = OldModified;
		 
EndProcedure

#EndRegion

#Region Private

// Get body at server.
// 
// Returns:
//  BinaryData - Get body at server
&AtServer
function GetBodyAtServer()
	RealObject = FormDataToValue(Object, Type("CatalogObject.Unit_ServiceExchangeHistory")); //CatalogObject.Unit_ServiceExchangeHistory
	Return RealObject.Body.Get();
EndFunction

&AtServer
Procedure TryLoadBodyAtServer()
	
	BodyString = "";
	BodyPicture = "";
	
	RealObject = FormDataToValue(Object, Type("CatalogObject.Unit_ServiceExchangeHistory")); //CatalogObject.Unit_ServiceExchangeHistory
	BodyRowValue = RealObject.Body.Get(); //BinaryData
	
	If TypeOf(BodyRowValue) <> Type("BinaryData") Then
		Items.BodyPresentation.CurrentPage = Items.BodyAsFile;
	ElsIf Object.BodyIsText Then
		BodyString = GetStringFromBinaryData(BodyRowValue);
		Items.BodyPresentation.CurrentPage = Items.BodyAsStr;
	ElsIf StrCompare(Left(Object.BodyType, 5), "IMAGE") = 0 Then
		BodyPicture = PutToTempStorage(BodyRowValue);
		Items.BodyPresentation.CurrentPage = Items.BodyAsPic;
	Else
		Items.BodyPresentation.CurrentPage = Items.BodyAsFile;
	EndIf;
	
EndProcedure

// Reload body at server.
// 
// Parameters:
//  NewContent - String, BinaryData - New content
//  Newsize - Number
&AtServer
Procedure ReloadBodyAtServer(NewContent, Newsize)
	
	RealObject = FormDataToValue(Object, Type("CatalogObject.Unit_ServiceExchangeHistory")); //CatalogObject.Unit_ServiceExchangeHistory
	
	RealObject.Body = New ValueStorage(NewContent);
	RealObject.BodyMD5 = CommonFunctionsServer.GetMD5(NewContent);
	RealObject.BodySize = Newsize;
	
	RealObject.Write();
	
	ValueToFormData(RealObject, Object);
	
	BodySizePresentation = CommonFunctionsClientServer.GetSizePresentation(Object.BodySize);
	
	TryLoadBodyAtServer();
	
EndProcedure

#EndRegion