
&AtClient
Procedure CreateIssue(Command)
	
	If Not CheckFilling() Then
		Return;
	EndIf;
	
	Issue = CreateIssueAtServer();
	
	If Issue.IsEmpty() Then
		Return;
	EndIf;
	
	Str = PictureViewerClient.RefInfo();
	Str.Ref = Issue;
	Str.UUID = UUID;
	For Each File In AttachedList Do
		FileStr = New Structure("Address, FileRef", File.Address, New Structure("Extension, Name", File.Extension, File.Name));
		PictureViewerClient.AddFile(FileStr, , Str);
	EndDo;
	
	AttachedList.Clear();
	Object.Comment = "";
	
	CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Mobile_3, Issue));
	
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

&AtClient
Procedure SpeechToText(Command)
	Object.Comment = Object.Comment + MobileSubsystem.RECOGNIZE_SPEECH()
EndProcedure

&AtClient
Procedure AttachedListURLClick(Item, StandardProcessing)
	
	CurrentRow = Items.AttachedList.CurrentData;
	If CurrentRow = Undefined Then
		StandardProcessing = False;
		Return;
	EndIf;
	If Not CurrentRow.IsImage Then
		StandardProcessing = False;
	EndIf;
EndProcedure

&AtClient
Async Procedure AddAttachments(Command)
	AttachmentList = Await MobileSubsystem.AddAttachment(UUID);
	
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

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Object.Author = SessionParameters.CurrentUser;
EndProcedure

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
	Row.Address = Data.Address;
	Row.Name = Data.Name;
	If PictureViewerServer.isImage(Data.Extension) Then
		Row.URL = Data.Address;
		Row.IsImage = True;
	EndIf;
EndProcedure

&AtClient
Procedure LocationOnChange(Item)
	GetCoordinates();
EndProcedure

&AtClient
Procedure UpdateCoordinates(Command)
	GetCoordinates();
EndProcedure

&AtClient
Procedure GetCoordinates()
	
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
				LockForm = True;
				Items.DecorationErrorMaxDistance.Visible = True;
			EndIf;
		EndIf;
	EndIf;
	
	Items.GroupErrorCoordinates.Visible = LockForm;
	Items.FormCreateIssue.Enabled = Not LockForm;
	
EndProcedure
