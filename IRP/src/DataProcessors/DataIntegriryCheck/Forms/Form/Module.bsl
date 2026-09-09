
&AtClient
Procedure CheckResultBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure CheckResultBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	Return;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	AddCheckToList("DuplicateActiveFACommissioningRecords", "DataIntegrityCheck_01");
	AddCheckToList("NegativeActualDepreciationAmount", "DataIntegrityCheck_02");
	AddCheckToList("ExpiredUsefulLifeWithUnwrittenOffBalance", "DataIntegrityCheck_03");
	AddCheckToList("MissingDepreciationPeriodForActiveFixedAsset", "DataIntegrityCheck_04");
	AddCheckToList("CostCenterMismatchWithCurrentAssetLocation", "DataIntegrityCheck_05");
	AddCheckToList("FATransactionOrDisposalDatePredatesLastTransfer", "DataIntegrityCheck_06");
EndProcedure

&AtServer
Procedure AddCheckToList(CheckID, PresentationKey)
	NewCheck = ThisObject.CheckList.Add();
	NewCheck.Status = 1;
	NewCheck.CheckID = CheckID;
	NewCheck.Presentation = R()[PresentationKey];	
EndProcedure

&AtClient
Procedure CheckListSetStatus(CheckID, Failed)
	For Each Row In ThisObject.CheckList Do
		If CheckID = Row.CheckID Then
			Row.Status = ?(Failed, 0, 2);
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure CheckListOnActivateRow(Item)
	CurrentData = Items.CheckList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	Items.GroupPages.CurrentPage = Items["Group" + CurrentData.CheckID];	
EndProcedure

&AtClient
Procedure CheckListBeforeDeleteRow(Item, Cancel)
	Cancel = False;
EndProcedure

&AtClient
Procedure CheckListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = False;
EndProcedure

&AtClient
Procedure Run(Command)
	If Not ThisObject.CheckFilling() Then
		Return;
	EndIf;
	
	SplashFormParameters = New Structure();
	SplashFormParameters.Insert("BackgroundJobTitle", ThisObject.Title);
	Splash = OpenForm("CommonForm.BackgroundJobSplash", SplashFormParameters, ThisObject, New UUID(),,,, FormWindowOpeningMode.LockOwnerWindow);
	
	JobParameters = New Structure();
	JobParameters.Insert("FormUUID", ThisObject.UUID);
	
	RunResult = RunBackgroundJob(JobParameters);
	ThisObject.BackgroundJobUUID = RunResult.BackgroundJobUUID; 
	ThisObject.BackgroundJobStorageAddress = RunResult.BackgroundJobStorageAddress;
	ThisObject.BackgroundJobSplash = Splash.UUID;
	
	Splash.JobUUID = RunResult.BackgroundJobUUID;
	AttachIdleHandler("BackgroundIdleHandler", 5, False);
EndProcedure

&AtServer
Function RunBackgroundJob(JobParameters) Export
	JobKey = String(New UUID());	
	StorageAddress = PutToTempStorage(Undefined, JobParameters.FormUUID);
			
	BackgroundParameters = New Array();
	BackgroundParameters.Add(StorageAddress);	
	BackgroundParameters.Add(ThisObject.Period.StartDate);	
	BackgroundParameters.Add(ThisObject.Period.EndDate);
	BackgroundParameters.Add(ThisObject.Company);
	BackgroundParameters.Add(ThisObject.Branch);
	
	ArrayOfChecks = New Array();
	For Each Row In ThisObject.CheckList Do
		If Row.Use Then
			ArrayOfChecks.Add(Row.CheckID);
		EndIf;
	EndDo;
			
	BackgroundParameters.Add(ArrayOfChecks);
	
	Job = BackgroundJobs.Execute("DataIntegrityCheckServer.BackgroundJob", BackgroundParameters, JobKey);
	Return New Structure("BackgroundJobUUID, BackgroundJobStorageAddress", Job.UUID, StorageAddress);
EndFunction

&AtClient
Procedure BackgroundIdleHandler() Export
	JobStatus = ModelServer_V2.GetJobStatus(ThisObject.BackgroundJobUUID, ThisObject.BackgroundJobStorageAddress);
	If JobStatus.Status = PredefinedValue("Enum.JobStatus.EmptyRef") Then
		CancelIdleHandler();
		Return;
	EndIf;
	
	OpenedSplashForm = GetSplashByUUID();
	
	If JobStatus.Status = PredefinedValue("Enum.JobStatus.Canceled") 
		Or JobStatus.Status = PredefinedValue("Enum.JobStatus.Failed") Then
			
			For Each Msg In JobStatus.SystemMessages Do
				NewMsg = OpenedSplashForm.SystemMessages.Add();
				NewMsg.Message = Msg;
			EndDo;
			
			CancelIdleHandler();
			Return;
	EndIf;
	
	If JobStatus.Status = PredefinedValue("Enum.JobStatus.Active") Then
		// wait
		If JobStatus.CompletePercent = Undefined And JobStatus.SystemMessages.Count() = 0 Then
			Return;
		EndIf;

		If ThisObject.BackgroundJobSplash = Undefined Then
			Return;
		EndIf;
		
		If OpenedSplashForm <> Undefined And OpenedSplashForm.IsOpen() Then
			If Not JobStatus.CompletePercent = Undefined Then
				OpenedSplashForm.Items.Percent.MaxValue = JobStatus.CompletePercent.Total;
				OpenedSplashForm.Percent = JobStatus.CompletePercent.Complete;
			EndIf;
			For Each Msg In JobStatus.SystemMessages Do
				NewMsg = OpenedSplashForm.SystemMessages.Add();
				NewMsg.Message = Msg;
			EndDo;

			If OpenedSplashForm.SystemMessages.Count() And Not OpenedSplashForm.Items.GroupMessages.Visible Then
				OpenedSplashForm.Items.GroupMessages.Visible = True;
				OpenedSplashForm.DoNotCloseOnFinish = True;
			EndIf;

			DiffDate = CommonFunctionsServer.GetCurrentSessionDate() - OpenedSplashForm.StartDate;
			TimeToEnd = OpenedSplashForm.Items.Percent.MaxValue * DiffDate / OpenedSplashForm.Percent - DiffDate;
			OpenedSplashForm.EndIn = CommonFunctionsServer.GetCurrentSessionDate() + TimeToEnd;
		EndIf;
	Else
		// complete..
		JobResult = JobStatus.Result;
		
		If JobResult.DuplicateActiveFACommissioningRecords.Failed Then
			CheckListSetStatus("DuplicateActiveFACommissioningRecords", True);
			ThisObject.CheckResult1.Clear();			
			For Each Doc In JobResult.DuplicateActiveFACommissioningRecords.Documents Do
				ThisObject.CheckResult1.Add().Document = Doc;
			EndDo;
		Else
			CheckListSetStatus("DuplicateActiveFACommissioningRecords", False);
			ThisObject.CheckResult1.Clear();
		EndIf;
			
			
		CancelIdleHandler();
	EndIf;
EndProcedure	

&AtClient
Procedure CancelIdleHandler()
	DetachIdleHandler("BackgroundIdleHandler");
	ThisObject.BackgroundJobUUID = "";
	If ThisObject.BackgroundJobSplash <> Undefined Then
		OpenedSplashForm = GetSplashByUUID();
		If OpenedSplashForm <> Undefined And OpenedSplashForm.IsOpen() Then
			OpenedSplashForm.EndDate = CommonFunctionsServer.GetCurrentSessionDate();
			OpenedSplashForm.Percent = OpenedSplashForm.Items.Percent.MaxValue;
			OpenedSplashForm.FormCanBeClose = True;
			OpenedSplashForm.CommandBar.ChildItems.FormOK.Visible = True;
			OpenedSplashForm.Items.Decoration.Visible = False;
			
			If OpenedSplashForm.SystemMessages.Count() And Not OpenedSplashForm.Items.GroupMessages.Visible Then
				OpenedSplashForm.Items.GroupMessages.Visible = True;
				OpenedSplashForm.DoNotCloseOnFinish = True;
			EndIf;
			
			If Not OpenedSplashForm.DoNotCloseOnFinish Then
				OpenedSplashForm.Close();
			EndIf;
		EndIf;
		ThisObject.BackgroundJobSplash = Undefined;
	EndIf;
EndProcedure

&AtClient
Function GetSplashByUUID()
	OpenedSplashForm = Undefined;
	Windows = GetWindows();
	For Each _Window In Windows Do
		If OpenedSplashForm <> Undefined Then
			Break;
		EndIf;
		If Not _Window.IsMain Then
			For Each Splash In _Window.Content Do
				If Splash.UUID = ThisObject.BackgroundJobSplash Then
					OpenedSplashForm = Splash;
					Break;
				EndIf;
			EndDo;
		EndIf;
	EndDo;
	Return OpenedSplashForm;
EndFunction

