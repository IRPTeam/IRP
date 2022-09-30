// @strict-types

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	RealObject = FormDataToValue(Object, Type("CatalogObject.Unit_ServiceExchangeHistory")); // CatalogObject.Unit_ServiceExchangeHistory 
	
	HeadersValue = RealObject.Headers.Get();
	If TypeOf(HeadersValue) = Type("Map") Then
		For Each KeyValue In HeadersValue Do
			HeaderRow = ThisObject.HeadersTable.Add();
			HeaderRow.Key = String(KeyValue.Key);
			HeaderRow.Value = String(KeyValue.Value);
		EndDo;
	EndIf;
	
	Items.GroupAnswer.Visible = Not Object.Parent.IsEmpty();
	Items.GroupRequest.Visible = Object.Parent.IsEmpty();
	
	ThisObject.BodySizePresentation = CommonFunctionsClientServer.GetSizePresentation(Object.BodySize);
	
	Megabyte = Pow(2, 20);
	If Object.BodyIsText And Object.BodySize < Megabyte Then
		 TryLoadBodyAtServer();
	EndIf;
	
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Async Procedure SaveBody(Command)
	
	BodyRowValue = GetBodyAtServer();
	
	If Not TypeOf(BodyRowValue) = Type("BinaryData") Then
		ShowMessageBox(, R().Mock_Info_EmptyFile);
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
	
	PathArray = Await FileDialog.ChooseAsync(); // Array of String
	If PathArray = Undefined Or PathArray.Count() = 0 Then
		Return;
	EndIf;
	FullFileName = PathArray[0];
	
	File = New File(FullFileName); 
	SizeNewFile = File.Size();
	
	ContentFile = New BinaryData(FullFileName);
	 
	ReloadBodyAtServer(ContentFile, SizeNewFile);
	
	Modified = OldModified;
		 
EndProcedure

&AtClient
Procedure AnalyzeBody(Command)
	
	AddressBody = PutToTempStorage(GetBodyAtServer(), ThisObject.UUID);
	
	OpenForm("CommonForm.Unit_DataContentAnalyzer", 
		New Structure("PathToValue, AddressBody", ?(Object.BodyIsText, "[text]", "[file]"), AddressBody)
	);
	
EndProcedure

#EndRegion

#Region Private

// Get body at server.
// 
// Returns:
//  BinaryData - Get body at server
&AtServer
function GetBodyAtServer()
	RealObject = FormDataToValue(Object, Type("CatalogObject.Unit_ServiceExchangeHistory")); // CatalogObject.Unit_ServiceExchangeHistory
	BodyRowValue = RealObject.Body.Get();
	If TypeOf(BodyRowValue) = Type("BinaryData") Then
		Return BodyRowValue;
	Else
		Return GetBinaryDataFromString("");
	EndIf;
EndFunction

&AtServer
Procedure TryLoadBodyAtServer()
	
	ThisObject.BodyString = "";
	ThisObject.BodyPicture = "";
	
	BodyRowValue = GetBodyAtServer();
	
	If Object.BodyIsText Then
		ThisObject.BodyString = GetStringFromBinaryData(BodyRowValue);
		Items.BodyPresentation.CurrentPage = Items.BodyAsStr;
	ElsIf StrStartsWith(Upper(Object.BodyType), "IMAGE") Then
		ThisObject.BodyPicture = PutToTempStorage(BodyRowValue);
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
	
	RealObject = FormDataToValue(Object, Type("CatalogObject.Unit_ServiceExchangeHistory")); // CatalogObject.Unit_ServiceExchangeHistory
	
	RealObject.Body = New ValueStorage(NewContent);
	RealObject.BodyMD5 = CommonFunctionsServer.GetMD5(NewContent);
	RealObject.BodySize = Newsize;
	
	RealObject.Write();
	
	ValueToFormData(RealObject, Object);
	
	ThisObject.BodySizePresentation = CommonFunctionsClientServer.GetSizePresentation(Object.BodySize);
	
	TryLoadBodyAtServer();
	
EndProcedure

#EndRegion