
&AtClient
Var StopEventHandling;

#Region FORM_EVENT_HANDLERS

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ArrayOfUpdateInfo = UpdateManagerServer.GetUpdateInfo();
	For Each Row In ArrayOfUpdateInfo Do
		NewRow = ThisObject.UpdateInfoList.Add();
		NewRow.Method          = Row.Method;
		NewRow.Description     = Row.Description;
		NewRow.FullDescription = Row.FullDescription;
		NewRow.Status          = "Waiting";
		NewRow.Icon            = GetUpdateIcon(NewRow);
	EndDo;
	
	UpdateAppliedUpdates();
	ThisObject.LastReleaseNumber = Constants.LastReleaseNumber.Get();
	ThisObject.CurrentReleaseNumber = Metadata.Version;
	ThisObject.UpdatePause = 5;
EndProcedure

&AtServer
Procedure UpdateAppliedUpdates(UpdateMethod = Undefined)
	UnappliedUpdates = UpdateManagerServer.GetUnappliedUpdates(UpdateMethod);
	For Each Row In ThisObject.UpdateInfoList Do
		If UpdateMethod <> Undefined And Row.Method <> UpdateMethod Then
			Continue;
		EndIf;
		
		For Each Row2 In UnappliedUpdates Do
			If Row.Method = Row2.Method Then
				If Row2.Applied = True Then
					SetUpdateStatus_Complete(Object, ThisObject, Row.Method);
				Else
					SetUpdateStatus_Waiting(Object, ThisObject, Row.Method);
				EndIf;
				Row.AppliedDate   = Row2.AppliedDate;
				Row.ReleaseNumber = Row2.ReleaseNumber;
			EndIf;
		EndDo;
	EndDo;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	UpdateLabels();
	CheckJobStatus();
	SetVisibilityAvailability(Object, ThisObject);	
EndProcedure

&AtClient
Procedure OnClose(Exit)
	OnCloseAtServer();
EndProcedure

&AtServerNoContext
Procedure OnCloseAtServer()
	Constants.LastReleaseNumber.Set(Metadata.Version);	
EndProcedure

&AtClient
Procedure RunAll(Command)
	For Each Row In ThisObject.UpdateInfoList Do
		If Row.Status = "Complete" Then
			Continue;
		EndIf;
		Row.Scheduled = True;
	EndDo;
	CheckJobStatus();	
EndProcedure

&AtClient
Procedure RunCurrent(Command)
	CurrentData = Items.UpdateInfoList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If CurrentData.Status = "Complete" Then
		Return;
	EndIf;
	
	SetUpdateStatus_InProgress(Object, ThisObject, CurrentData.Method);
	SetVisibilityAvailability(Object, ThisObject);
	RunUpdate(CurrentData.Method, CurrentData.Description);
	CheckJobStatus();
EndProcedure

&AtClient
Procedure ClearJobs(Command)
	ArrayForDelete = New Array();
	For Each Row In ThisObject.JobList Do
		If Not ValueIsFilled(Row.UUID) Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	
	For Each Row In ArrayForDelete Do
		ThisObject.JobList.Delete(Row);
	EndDo;
	UpdateLabels();
EndProcedure

&AtClient
Procedure UpdateStatuses(Command)
	CheckJobStatus();
EndProcedure

&AtClient
Procedure UpdateInfoListBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure UpdateInfoListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure UpdateInfoListOnActivateRow(Item)
	If StopEventHandling Then
		StopEventHandling = False;
		Return;
	EndIf;
	
	CurrentData = Items.UpdateInfoList.CurrentData;
	
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	ThisObject.CurrentUpdateMethod = CurrentData.Method;
	SetVisibilityAvailability(Object, ThisObject);	
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	
	CurrentUpdateInfo = Undefined;
	
	UpdateInfoRows = Form.UpdateInfoList.FindRows(New Structure("Method", Form.CurrentUpdateMethod));
	
	If UpdateInfoRows.Count() = 1 Then
		CurrentUpdateInfo = UpdateInfoRows[0];
	EndIf;
	
	If CurrentUpdateInfo = Undefined Then
		Return;
	EndIf;
	
	//CurrentUpdate_InProgress  = (CurrentUpdateInfo.Status = "InProgress");
	//CurrentUpdate_Complete    = (CurrentUpdateInfo.Status = "Complete");
	//CurrentUpdate_IsScheduled = (CurrentUpdateInfo.Status = "IsScheduled");
		
	Form.Items.DecorationHead.Title = CurrentUpdateInfo.Description;
	Form.Items.GroupHead.BackColor = GetUpdateColor(CurrentUpdateInfo);	
EndProcedure

#EndRegion

#Region STATUS

&AtClientAtServerNoContext
Function GetUpdateIcon(UpdateInfo)
	If UpdateInfo.Status = "Error" Then
		Return 0;
	ElsIf UpdateInfo.Status = "Waiting" Then
		Return 1;		
	ElsIf UpdateInfo.Status = "Complete" Then
		Return 2;
	ElsIf UpdateInfo.Status = "InProgress" Then
		Return 3;
	Else
		Raise StrTemplate("<Get icon> Unsupported update status [%1]", UpdateInfo.Status);
	EndIf;
EndFunction

&AtClientAtServerNoContext
Function GetUpdateColor(UpdateInfo)
	If UpdateInfo.Status = "Error" Then
		Return WebColors.Pink;
	ElsIf UpdateInfo.Status = "Waiting" Then
		Return WebColors.PaleGoldenrod;
	ElsIf UpdateInfo.Status = "Complete" Then
		Return WebColors.PaleGreen;
	ElsIf UpdateInfo.Status = "InProgress" Then
		Return WebColors.LightSkyBlue;
	Else
		Raise StrTemplate("<Get color> Unsupported update status [%1]", UpdateInfo.Status);
	EndIf;
EndFunction

&AtClientAtServerNoContext
Procedure SetUpdateStatus_Error(Object, Form, UpdateMethod)
	SetUpdateStatus(Object, Form, UpdateMethod, "Error");
EndProcedure

&AtClientAtServerNoContext
Procedure SetUpdateStatus_Waiting(Object, Form, UpdateMethod)
	SetUpdateStatus(Object, Form, UpdateMethod, "Waiting");
EndProcedure

&AtClientAtServerNoContext
Procedure SetUpdateStatus_Complete(Object, Form, UpdateMethod)
	SetUpdateStatus(Object, Form, UpdateMethod, "Complete");
EndProcedure

&AtClientAtServerNoContext
Procedure SetUpdateStatus_InProgress(Object, Form, UpdateMethod)
	SetUpdateStatus(Object, Form, UpdateMethod, "InProgress");
EndProcedure

&AtClientAtServerNoContext
Procedure SetUpdateStatus(Object, Form, UpdateMethod, Status)
	UpdateInfoRows = Form.UpdateInfoList.FindRows(New Structure("Method", UpdateMethod));
	For Each Row In UpdateInfoRows Do
		Row.Status = Status;
		Row.Icon = GetUpdateIcon(Row);
	EndDo;
EndProcedure

#EndRegion

&AtServer
Function JobIsComplete(StepNumber)
	JobListFiltered = CopyJobList(StepNumber);
	BackgroundJobAPIServer.CheckJobs(JobListFiltered);
	BackgroundJobAPIServer.RunJobs(JobListFiltered, MaxJobStream);
	UpdateJobList(JobListFiltered);
	For Each Row In JobListFiltered Do
		If Row.Status = Enums.JobStatus.Active OR Row.Status = Enums.JobStatus.Wait Then
			Return False;
		EndIf;
	EndDo;
	Return True;
EndFunction

#Region JOB_LIST

&AtServer
Function CopyJobList(UpdateMethod)
	JobListFiltered = JobList.Unload().Copy(New Structure("UpdateMethod", UpdateMethod));
	ArrayForDelete = New Array();
	For Each Row In JobListFiltered Do
		If Not ValueIsFilled(Row.UUID) Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	
	For Each Row In ArrayForDelete Do
		JobListFiltered.Delete(Row);
	EndDo;
	
	Return JobListFiltered;
EndFunction

&AtServer
Procedure UpdateJobList(JobListFiltered)
	For Each RowFiltered In JobListFiltered Do
		For Each Row In ThisObject.JobList Do
			If RowFiltered.UUID <> Row.UUID Then
				Continue;
			EndIf;
			FillPropertyValues(Row, RowFiltered);
		EndDo;
	EndDo;
EndProcedure

&AtServer
Procedure ClearJobList(UpdateMethod)
	For Each Row In ThisObject.JobList Do
		If Row.UpdateMethod <> UpdateMethod Then
			Continue;
		EndIf;
		Row.UUID = Undefined;
	EndDo;
EndProcedure

&AtServer
Procedure RefreshStatus(UpdateMethod, JobListRows)
	AllComplete = True;
	For Each Row In JobListRows Do
		If Row.Status <> Enums.JobStatus.Completed Then
			AllComplete = False;
			Break;
		EndIf;
	EndDo;

	If AllComplete Then	
		SetUpdateStatus_Complete(Object, ThisObject, UpdateMethod);
	Else
		SetUpdateStatus_Error(Object, ThisObject, UpdateMethod);
	EndIf;
	UpdateAppliedUpdates(UpdateMethod);
EndProcedure

&AtClient
Function ConvertJobListRows(JobListRows)
	Array = New Array();
	For Each Row In JobListRows Do
		NewRow = New Structure("Status");
		FillPropertyValues(NewRow, Row);
		Array.Add(NewRow);
	EndDo;
	Return Array;
EndFunction

&AtClient
Procedure UpdateLabels()
	ThisObject.ActiveJob    = String(JobList.FindRows(New Structure("Status", PredefinedValue("Enum.JobStatus.Active"))).Count());
	ThisObject.FailedJob    = String(JobList.FindRows(New Structure("Status", PredefinedValue("Enum.JobStatus.Failed"))).Count());
	ThisObject.ComplitedJob = String(JobList.FindRows(New Structure("Status", PredefinedValue("Enum.JobStatus.Completed"))).Count());
	ThisObject.WaitJob      = String(JobList.FindRows(New Structure("Status", PredefinedValue("Enum.JobStatus.Wait"))).Count());
EndProcedure

&AtServer
Procedure RunUpdate(UpdateMethod, Title)
	ClearJobList(UpdateMethod);	
	JobRow = JobList.Add();
	JobRow.UpdateMethod = UpdateMethod;
	JobRow.Title = Title;
	JobRow.Icon = PictureLib.AppearanceCircleYellow;
	JobRow.Status = Enums.JobStatus.Wait;
	JobRow.ProcedurePath = UpdateMethod;
	JobRow.UUID = String(New UUID());
EndProcedure

&AtClient
Procedure CheckJobStatus() Export
	Items.FormUpdateStatuses.Enabled = False;
	
	AllJobIsComplete = True;
		
	For Each UpdateInfo In ThisObject.UpdateInfoList Do
		JobIsComplete = JobIsComplete(UpdateInfo.Method);
		If Not JobIsComplete Then
			AllJobIsComplete = False;
			Continue;
		EndIf;
		
		JobListRows = New Array();
		For Each Row In ThisObject.JobList Do
			If ValueIsFilled(Row.UUID) And Row.UpdateMethod = UpdateInfo.Method Then
				Row.UUID = Undefined;
				JobListRows.Add(Row);
			EndIf;
		EndDo;
		
		If JobListRows.Count() > 0 Then	
			Converted_JobListRows = ConvertJobListRows(JobListRows);
			RefreshStatus(UpdateInfo.Method, Converted_JobListRows);
		EndIf;
	EndDo;		
	
	If AllJobIsComplete Then
		ScheduledUpdateIsRun = False;
		
		For Each UpdateInfo In ThisObject.UpdateInfoList Do
			If Not UpdateInfo.Scheduled Then
				Continue;
			EndIf;
			
			ScheduledUpdateIsRun = True;
			UpdateInfo.Scheduled = False;
			SetUpdateStatus_InProgress(Object, ThisObject, UpdateInfo.Method);
			RunUpdate(UpdateInfo.Method, UpdateInfo.Description);
		EndDo;
		
		If ScheduledUpdateIsRun Then
			AttachIdleHandler("CheckJobStatus", ThisObject.UpdatePause, True);
		Else
			DetachIdleHandler("CheckJobStatus");
		EndIf;
		
	Else
		AttachIdleHandler("CheckJobStatus", ThisObject.UpdatePause, True);
	EndIf;
	
	Items.FormUpdateStatuses.Enabled = True;
	UpdateLabels();
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

#EndRegion

StopEventHandling = False;
