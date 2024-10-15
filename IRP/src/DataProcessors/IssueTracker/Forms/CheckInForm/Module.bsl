
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Issue = Parameters.Issue;
	WorkOrder = Parameters.WorkOrder;
	AttachedFiles.Parameters.SetParameterValue("Issue", Issue);
	FillWorkSheetInfo();
	SetVisible();
EndProcedure

&AtServer
Procedure SetVisible()
	JobIsStarted = Not WorkSheet.IsEmpty();
	Items.GroupJobStarted.Visible = JobIsStarted;
	Items.GroupJobNotStarted.Visible = Not JobIsStarted;
	
	JobIsFinished = ValueIsFilled(JobFinished);
	Items.JobDescription.ReadOnly = JobIsFinished;
	Items.FinishJob.Visible = Not JobIsFinished; 
	
	AttachedFilesWorkSheet.Parameters.SetParameterValue("WorkSheet", WorkSheet);
	
	Items.PagesAttachWorkSheet.Visible = JobIsFinished;
	Items.GroupButtonAttachment.Visible = Not JobIsFinished;
	Items.PagesAttachmentList.Visible = Not JobIsFinished;
EndProcedure

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

&AtClient
Procedure StartJob(Command)  
	If GetCoordinates() Then
		StartJobAtServer();
		NotifyChanged(Type("DocumentRef.Issue"));
	EndIf;
EndProcedure

&AtClient
Procedure FinishJob(Command)
	If GetCoordinates() Then 
		Items.FinishJob.Enabled = False;
		AttachIdleHandler("UploadFilesHandler", 0.1, True);
	EndIf;
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

&AtClient
Procedure AttachedFilesSelection(Item, SelectedRow, Field, StandardProcessing)
	StandardProcessing = False;
	Try
		BD = GetFileBinaryData(SelectedRow);
		Image = New Picture(BD);
		OpenValueAsync(Image);
	Except                                                         
		Log.Write("Error on open file", ErrorProcessing.DetailErrorDescription(ErrorInfo()));
		CommonFunctionsClientServer.ShowUsersMessage(R().Mobile_6);
	EndTry;
EndProcedure

#EndRegion

#Region Private

&AtClient
Procedure UploadFilesHandler()
	
	IsError = False;
	Str = PictureViewerClient.RefInfo();
	Str.Ref = WorkSheet;
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
			AttachIdleHandler("UploadFilesHandler", 0.1, True);
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
		FinishJobAtServer();
		NotifyChanged(Type("DocumentRef.Issue"));
	EndIf;
	
	Items.FinishJob.Enabled = True;
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
Function GetCoordinates()
	
	#IF NOT MobileClient THEN
		Return True;
	#ENDIF
	
	
	MaxDistance = 1; // km
	
	Coordinates = MobileSubsystem.GetCoordinates();
	LockForm = False;
	Items.DecorationErrorUpdateGPS.Visible = False;
	If Coordinates = Undefined Then
		LockForm = True;
		Items.DecorationErrorUpdateGPS.Visible = True;
	Else
		Latitude = Coordinates.Latitude;
		Longitude = Coordinates.Longitude;
	EndIf;
		
	Items.GroupErrorCoordinates.Visible = LockForm;
	Items.FinishJob.Enabled = Not LockForm;
	Items.StartJob.Enabled = Not LockForm;
	
	Return Not LockForm;
EndFunction

&AtServer
Function GetFileBinaryData(Val SelectedRow)
	
	Return FilesServer.GetFileBinaryData(SelectedRow);

EndFunction

&AtServer
Procedure StartJobAtServer() 
	FillingStructure = New Structure("Company, Branch, Partner, LegalName, Currency");
	FillPropertyValues(FillingStructure, WorkOrder); 
	FillingStructure.Insert("BasedOn", WorkOrder);
	FillingStructure.Insert("ItemList", New Array);
	Wrapper = BuilderAPI.Initialize(Metadata.Documents.WorkSheet.Name, , FillingStructure);
	
	For Each Row In WorkOrder.Workers.FindRows(New Structure("Employee", SessionParameters.CurrentUser.Partner)) Do
		FillPropertyValues(Wrapper.Object.Workers.Add(), Row);
	EndDo;
	
	If Wrapper.Object.Workers.Count() = 0 Then
		Wrapper.Object.Workers.Add().Employee = SessionParameters.CurrentUser.Partner;
	EndIf;
	
	IssueRow = Wrapper.Object.IssueList.Add();
	IssueRow.Issue = Issue;
	IssueRow.StartJob = CommonFunctionsServer.GetCurrentSessionDate();
	IssueRow.StartJobLatitude = Latitude;
	IssueRow.StartJobLongitude = Longitude;
	
	RefInfo = BuilderAPI.Write(Wrapper, DocumentWriteMode.Posting);
	FillWorkSheetInfo();
	SetVisible();
EndProcedure

&AtServer
Procedure FinishJobAtServer()
	WorkSheetObject = WorkSheet.GetObject();
	
	IssueRow = WorkSheetObject.IssueList.FindRows(New Structure("Issue", Issue))[0];
	IssueRow.EndJob = CommonFunctionsServer.GetCurrentSessionDate(); 
	IssueRow.EndJobLatitude = Latitude;
	IssueRow.EndJobLongitude = Longitude; 
	IssueRow.Comment = JobDescription;	
	WorkSheetObject.Write();
	
	FillWorkSheetInfo();
	SetVisible();
EndProcedure

&AtServer
Procedure FillWorkSheetInfo()
	WorkSheetInfo = DocWorkSheetServer.GetWorkSheetByIssue(Issue);
	
	WorkSheet = WorkSheetInfo.Ref;
	JobStarted = WorkSheetInfo.StartJob;
	JobFinished = WorkSheetInfo.EndJob;
	JobDescription = WorkSheetInfo.Comment;
EndProcedure

#EndRegion
