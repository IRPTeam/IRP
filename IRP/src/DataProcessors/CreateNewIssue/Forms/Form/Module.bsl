		  
#Region FORM

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Object.Author = SessionParameters.CurrentUser;
EndProcedure

#EndRegion

#Region FormButtons

&AtClient
Procedure CreateIssue(Command)
	
	If Not CheckFilling() Then
		Return;
	EndIf;
	Items.FormCreateIssue.Enabled = False;
	AttachIdleHandler("CreateIssueHandler", 0.1, True);
EndProcedure

&AtClient
Async Procedure AddAttachments(Command)
	AttachmentList = Await MobileSubsystem.AddAttachment();
	
	For Each File In AttachmentList Do
		AddToTable(File);
	EndDo;
EndProcedure

&AtClient
Procedure AddVideo(Command)
	Video = MobileSubsystem.CreateVideo();
	If Video = Undefined Then
		Return;
	EndIf;
	AddToTable(Video);
EndProcedure

&AtClient
Procedure AddPhoto(Command) 
	Photo = MobileSubsystem.CreatePhoto();
	If Photo = Undefined Then
		Return;
	EndIf;                 
	AddToTable(Photo);     
EndProcedure

&AtClient
Procedure UpdateCoordinates(Command)
	GetCoordinates();
EndProcedure

#EndRegion

#Region FormElement

&AtClient
Procedure LocationOnChange(Item)
	GetCoordinates();
EndProcedure

&AtClient
Procedure AttachedListSelection(Item, SelectedRow, Field, StandardProcessing)
	StandardProcessing = False;
	
	CurrentRow = Items.AttachedList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	If CurrentRow.IsImage Then
		OpenValueAsync(CurrentRow.Image);
	EndIf;
EndProcedure

#EndRegion

#Region Private

&AtClient
Procedure CreateIssueHandler()
	
	If IssueRef.IsEmpty() Then
		Issue = CreateIssueAtServer();
		
		If Issue.IsEmpty() Then
			Return;
		EndIf;
		
		IssueRef = Issue;
	EndIf;          
	
	
	IsError = False;
	Str = PictureViewerClient.RefInfo();
	Str.Ref = IssueRef;
	Str.UUID = UUID; 
	
	For Each File In AttachedList Do  
		If File.Uploaded Then
			Continue;
		EndIf;
		File.UploadStatus = PictureLib.Waiting;
	EndDo;
	
	For Each File In AttachedList Do  
		If File.Uploaded Then
			Continue;
		EndIf;
		FileStr = New Structure("Address, FileRef", File.BD, New Structure("Extension, Name", File.Extension, File.Name));
		Try
			PictureViewerClient.AddFile(FileStr, , Str); 
			File.UploadStatus = PictureLib.AppearanceCheckBox; 
			File.Uploaded = True;
			AttachIdleHandler("CreateIssueHandler", 0.1, True);
			Return;
		Except    
			IsError = True;
			ErrorInfo = ErrorInfo();
			Log.Write("Attach file", ErrorProcessing.DetailErrorDescription(ErrorInfo));
			CommonFunctionsClientServer.ShowUsersMessage(ErrorProcessing.BriefErrorDescription(ErrorInfo));
			File.UploadStatus = PictureLib.AppearanceCross;
		EndTry;
	EndDo;
	
	If Not IsError Then
		AttachedList.Clear();
		Object.Comment = "";
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Mobile_3, IssueRef));
		IssueRef = Undefined;
	EndIf;
	
	Items.FormCreateIssue.Enabled = True;
EndProcedure

&AtServer
Function CreateIssueAtServer()
	Issue = Documents.Issue.CreateDocument();
	Issue.Date = CommonFunctionsServer.GetCurrentSessionDate();
	Issue.Country = Object.Country;
	Issue.City = Object.City;
	Issue.Location = Object.Location;
	Issue.IssueType = Object.IssueType;
	Issue.IssueDetails = Object.Comment;
	Issue.Latitude = Object.Latitude;
	Issue.Longitude = Object.Longitude;
	
	Try
		Issue.Write(DocumentWriteMode.Posting);
	Except
		ErrorInfo = ErrorInfo();
		Log.Write("Write new Issue", ErrorProcessing.DetailErrorDescription(ErrorInfo));
		CommonFunctionsClientServer.ShowUsersMessage(ErrorProcessing.BriefErrorDescription(ErrorInfo));
		Return Documents.Issue.EmptyRef();
	EndTry;
	Return Issue.Ref;
EndFunction

// Add to table.
// 
// Parameters:
//  Data - Structure:
//  * Extension - String - 
//  * Address - String -
&AtClient
Procedure AddToTable(Data)
	Row = AttachedList.Add();
	Row.Extension = Data.Extension;
	Row.BD = Data.BD;
	Row.Name = Data.Name;
	If PictureViewerServer.isImage(Data.Extension) Then
		Row.IsImage = True;
		Row.Image = New Picture(Row.BD);
	EndIf;
EndProcedure

&AtClient
Procedure GetCoordinates()
	
	#IF NOT MobileClient THEN
		Return;
	#ENDIF
	
	
	MaxDistance = 1; // km
	
	Coordinates = MobileSubsystem.GetCoordinates();
	LockForm = False;
	Items.DecorationErrorUpdateGPS.Visible = False;
	If Coordinates = Undefined Then
		LockForm = True;
		Items.DecorationErrorUpdateGPS.Visible = True;
	Else
		Object.Latitude = Coordinates.Latitude;
		Object.Longitude = Coordinates.Longitude;
	EndIf;
	
	Items.DecorationErrorMaxDistance.Visible = False;
	If Not LockForm Then
		LocationCoordinates = CommonFunctionsServer.GetAttributesFromRef(Object.Location, "Latitude, Longitude");
		
		If LocationCoordinates.Latitude <> 0 AND LocationCoordinates.Longitude <> 0 Then
			CurrentDestination = CommonFunctionsClientServer.CalculateDistance(LocationCoordinates.Latitude, LocationCoordinates.Longitude, Coordinates.Latitude, Coordinates.Longitude);
			
			If CurrentDestination > MaxDistance Then
				//LockForm = True;
				//Items.DecorationErrorMaxDistance.Visible = True;
			EndIf;
		EndIf;
	EndIf;
	
	Items.GroupErrorCoordinates.Visible = LockForm;
	Items.FormCreateIssue.Enabled = Not LockForm;
	
EndProcedure

#EndRegion
