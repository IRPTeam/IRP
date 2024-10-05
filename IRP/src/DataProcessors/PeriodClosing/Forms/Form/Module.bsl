
&AtClient
Var StopEventHandling;


&AtServer
Function GetReglamentDocument_CustomersAdvancesClosing(Company, StartDate, EndDate)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Doc.Ref,
	|	Doc.BeginOfPeriod AS StartDate,
	|	Doc.EndOfPeriod AS EndDate
	|FROM
	|	Document.CustomersAdvancesClosing AS Doc
	|WHERE
	|	NOT Doc.DeletionMark
	|	AND Doc.Company = &Company
	|	AND Doc.BeginOfPeriod >= &StartDate
	|	AND Doc.EndOfPeriod <= &EndDate
	|
	|ORDER BY
	|	StartDate";
	
	Query.SetParameter("Company"   , Company);
	Query.SetParameter("StartDate" , StartDate);
	Query.SetParameter("EndDate"   , EndDate);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	QueryTable.Columns.Add("Period_ErrorCode");
	QueryTable.Columns.Add("Period_ErrorDescription");
	
	If QueryTable.Count() > 0 And QueryTable[0].StartDate <> StartDate Then
		QueryTable[0].Period_ErrorCode = 1; // critical error
		QueryTable[0].Period_ErrorDescription = """Start date"" of first document not equal ""Start date"" of closing period";
	EndIf;
	
	Doc_EndDate = Undefined;
	
	For Each Row In QueryTable Do		
		If Doc_EndDate = Undefined Then
			Doc_EndDate = Row.EndDate;
			Continue;
		EndIf;
		
		If Row.StartDate - (60 * 60 * 24) <> Doc_EndDate Then
			Row.Period_ErrorCode = 2; // not critical, document will be deleted
			Row.Period_ErrorDescription = """Start date"" not equal ""End date"" of previous document";
			Doc_EndDate = Row.EndDate;
		EndIf;
	EndDo;
EndFunction

&AtServer
Function GetReglamentDocument_VendorsAdvancesClosing(Company, StartDate, EndDate)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Doc.Ref,
	|	Doc.BeginOfPeriod AS StartDate,
	|	Doc.EndOfPeriod AS EndDate
	|FROM
	|	Document.VendorsAdvancesClosing AS Doc
	|WHERE
	|	NOT Doc.DeletionMark
	|	AND Doc.Company = &Company
	|	AND Doc.BeginOfPeriod >= &StartDate
	|	AND Doc.EndOfPeriod <= &EndDate
	|
	|ORDER BY
	|	StartDate";
	
	Query.SetParameter("Company"   , Company);
	Query.SetParameter("StartDate" , StartDate);
	Query.SetParameter("EndDate"   , EndDate);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	QueryTable.Columns.Add("Period_ErrorCode");
	QueryTable.Columns.Add("Period_ErrorDescription");
	
	If QueryTable.Count() > 0 And QueryTable[0].StartDate <> StartDate Then
		QueryTable[0].Period_ErrorCode = 1; // critical error
		QueryTable[0].Period_ErrorDescription = """Start date"" of first document not equal ""Start date"" of closing period";
	EndIf;
	
	Doc_EndDate = Undefined;
	
	For Each Row In QueryTable Do		
		If Doc_EndDate = Undefined Then
			Doc_EndDate = Row.EndDate;
			Continue;
		EndIf;
		
		If Row.StartDate - (60 * 60 * 24) <> Doc_EndDate Then
			Row.Period_ErrorCode = 2; // not critical, document will be deleted
			Row.Period_ErrorDescription = """Start date"" not equal ""End date"" of previous document";
			Doc_EndDate = Row.EndDate;
		EndIf;
	EndDo;
EndFunction

&AtServer
Function GetReglamentDocument_ForeignCurrencyRevaluation(Company, StartDate, EndDate)
//	Query = New Query();
//	Query.Text = 
//	"SELECT
//	|	Doc.Ref,
//	|	Doc.BeginOfPeriod AS StartDate,
//	|	Doc.EndOfPeriod AS EndDate
//	|FROM
//	|	Document.VendorsAdvancesClosing AS Doc
//	|WHERE
//	|	NOT Doc.DeletionMark
//	|	AND Doc.Company = &Company
//	|	AND Doc.BeginOfPeriod >= &StartDate
//	|	AND Doc.EndOfPeriod <= &EndDate
//	|
//	|ORDER BY
//	|	StartDate";
//	
//	Query.SetParameter("Company"   , Company);
//	Query.SetParameter("StartDate" , StartDate);
//	Query.SetParameter("EndDate"   , EndDate);
//	
//	QueryResult = Query.Execute();
//	QueryTable = QueryResult.Unload();
//	
//	QueryTable.Columns.Add("Period_ErrorCode");
//	QueryTable.Columns.Add("Period_ErrorDescription");
//	
//	If QueryTable.Count() > 0 And QueryTable[0].StartDate <> StartDate Then
//		QueryTable[0].Period_ErrorCode = 1; // critical error
//		QueryTable[0].Period_ErrorDescription = """Start date"" of first document not equal ""Start date"" of closing period";
//	EndIf;
//	
//	Doc_EndDate = Undefined;
//	
//	For Each Row In QueryTable Do		
//		If Doc_EndDate = Undefined Then
//			Doc_EndDate = Row.EndDate;
//			Continue;
//		EndIf;
//		
//		If Row.StartDate - (60 * 60 * 24) <> Doc_EndDate Then
//			Row.Period_ErrorCode = 2; // not critical, document will be deleted
//			Row.Period_ErrorDescription = """Start date"" not equal ""End date"" of previous document";
//			Doc_EndDate = Row.EndDate;
//		EndIf;
//	EndDo;
EndFunction


&AtServer
Function GetDocumentIcon(Posted)
	Return ?(Posted, 0, 2);
EndFunction


#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)	
	CreateStep("Select Company and Period", 0, "Error", True);
	CreateStep("Reposting documents", 1);
	CreateStep("Calculation movement costs", 2);
	CreateStep("Vendors advances closing", 3);
	CreateStep("Customers advances closing", 4);
	CreateStep("Foreign currency revaluation", 5);
	CreateStep("Accounting translation", 6);

	ThisObject.UpdatePause = 5;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	UpdateLabels();
	CheckJobStatus();
	SetVisibilityAvailability(Object, ThisObject);	
EndProcedure

&AtClient
Procedure PeriodOnChange(Item)
	SetStepStatus_NotValid(Object, ThisObject);
	SetVisibilityAvailability(Object, ThisObject);	
EndProcedure

&AtClient
Procedure CompanyOnChange(Item)
	SetStepStatus_NotValid(Object, ThisObject);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure ClosePeriod(Command)
	If Not ThisObject.CheckFilling() Then
		Return;
	EndIf;
EndProcedure

&AtClient
Procedure RunStep(Command)
	SetStepStatus_InProgress(Object, ThisObject);
	SetVisibilityAvailability(Object, ThisObject);
	Execute("RunStep_" + String(ThisObject.CurrentStep) + "()");
	CheckJobStatus();
EndProcedure

&AtClient
Procedure SkipStep(Command)
	SetStepStatus_Skip(Object, ThisObject);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure PrevStep(Command)
	ThisObject.CurrentStep = ThisObject.CurrentStep - 1;
	SetVisibilityAvailability(Object, ThisObject);
	StopEventHandling = True;
	Items.StepsInfo.CurrentRow = ThisObject.StepsInfo[ThisObject.CurrentStep].GetID();
EndProcedure

&AtClient
Procedure NextStep(Command)
	ThisObject.CurrentStep = ThisObject.CurrentStep + 1;
	SetVisibilityAvailability(Object, ThisObject);
	StopEventHandling = True;
	Items.StepsInfo.CurrentRow = ThisObject.StepsInfo[ThisObject.CurrentStep].GetID();
EndProcedure

&AtClient
Procedure StepsInfoOnActivateRow(Item)
	If StopEventHandling Then
		StopEventHandling = False;
		Return;
	EndIf;
	
	CurrentData = Items.StepsInfo.CurrentData;
	
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	ThisObject.CurrentStep = CurrentData.StepNumber;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	CurrentStepInProgress = (Form.StepsInfo[Form.CurrentStep].Status = "InProgress");
	CurrentStepValid      = (Form.StepsInfo[Form.CurrentStep].Status = "Valid");
	
	AnyStepInProgress = (Form.StepsInfo.FindRows(New Structure("Status", "InProgress")).Count() > 0);
	
	Form.Items.FormPrevStep.Enabled = Not (Form.CurrentStep - 1 < 0);
	Form.Items.FormNextStep.Enabled = Not (Form.CurrentStep + 1 > (Form.StepsInfo.Count() - 1));
	
	Form.Items.DecorationHead.Title = Form.StepsInfo[Form.CurrentStep].Text;
	Form.Items.GroupHead.BackColor = GetStepColor(Form.StepsInfo[Form.CurrentStep]);
	
	Form.Items.Company.ReadOnly = AnyStepInProgress Or Form.CurrentStep <> 0;
	Form.Items.Period.ReadOnly = AnyStepInProgress Or Form.CurrentStep <> 0;
			
	ArrayOfWaitingSteps = Eval("GetWaitingSteps_" + String(Form.CurrentStep) + "(Object, Form)");
	VisibleFilter = New Structure("Visible", True);
	Form.Items.StepsInfoWaiting.RowFilter = New FixedStructure(VisibleFilter);
		
	Form.Items.GroupSteps.CurrentPage = Form.Items["GroupStep" + String(Form.CurrentStep)];
	
	StepNumberFilter = New Structure("StepNumber", Form.CurrentStep);
	Form.Items.ValidationErrors.RowFilter = New FixedStructure(StepNumberFilter);
	Form.ValidationErrors.Clear();
	
	For Each Step In Form.StepsInfo Do
		Step.Status = Eval("ValidateStep_"+ String(Step.StepNumber) +"(Object, Form, Step)");
		
		GroupStep = Form.Items["GroupStep" + String(Step.StepNumber)];
		GroupStep.Visible = (GroupStep = Form.Items.GroupSteps.CurrentPage);
		GroupStep.ReadOnly = CurrentStepInProgress;
		
		Step.Visible = (ArrayOfWaitingSteps.Find(Step.StepNumber) <> Undefined);
		Step.Current = False;
		Step.Icon = GetStepIcon(Step);
	EndDo;
	
	Form.StepsInfo[Form.CurrentStep].Current = True;
		
	If Form.CurrentStep = 0 Then
		Form.Items.RunStep.Visible = False;
		Form.Items.SkipStep.Visible = False;
	Else
		Form.Items.RunStep.Visible = True;
		Form.Items.SkipStep.Visible = True;
		
		AllWaitingStepsIsValidOrSkipped = True;
		For Each WaitingStep In ArrayOfWaitingSteps Do
			If Not (Form.StepsInfo[WaitingStep].Status = "Valid" Or Form.StepsInfo[WaitingStep].Status = "Skip") Then
				AllWaitingStepsIsValidOrSkipped = False;
				Break;
			EndIf;
		EndDo;
		
		Form.Items.RunStep.Enabled = AllWaitingStepsIsValidOrSkipped And Not CurrentStepInProgress;
		Form.Items.SkipStep.Enabled = Not CurrentStepValid And Not CurrentStepInProgress;
	EndIf;
	
	HaveValidationErrors = False;
	For Each Row In Form.ValidationErrors Do
		If Row.StepNumber = Form.CurrentStep Then
			HaveValidationErrors = True;
			Break;
		EndIf;
	EndDo;
	
	Form.Items.GroupValidationErrors.Visible = HaveValidationErrors;
EndProcedure

#EndRegion

#Region Steps

&AtServer
Procedure CreateStep(Text, StepNumber, Status = "NotValid", Current = False)
	NewStep = ThisObject.StepsInfo.Add();
	NewStep.Text    = Text;
	NewStep.StepNumber = StepNumber;
	NewStep.Current = Current;
	NewStep.Status  = Status;
	NewStep.Icon    = GetStepIcon(NewStep);
EndProcedure

&AtServer
Procedure RunStepAsBagroundJob(StepNumber, Title, ProcedurePath, JobParameters)
	ClearJobList(StepNumber);
	JobRow = JobList.Add();
	JobRow.StepNumber = StepNumber;
	JobRow.Title = Title;
	JobRow.JobParameters = CommonFunctionsServer.PutToCache(JobParameters);
	JobRow.Icon = PictureLib.AppearanceCircleYellow;
	JobRow.Status = Enums.JobStatus.Wait;
	JobRow.ProcedurePath = ProcedurePath;
	JobRow.UUID = String(New UUID());
EndProcedure

&AtClientAtServerNoContext
Procedure SetStepStatus_Valid(Object, Form, StepNumber = Undefined)
	_StepNumber = ?(StepNumber = Undefined, Form.CurrentStep, StepNumber);
	Step = Form.StepsInfo[_StepNumber];	
	Step.Status = "Valid";
	Step.Icon   = GetStepIcon(Step);
	SetNotValidForDependedSteps(Object, Form, _StepNumber);
EndProcedure

&AtClientAtServerNoContext
Procedure SetStepStatus_NotValid(Object, Form, StepNumber = Undefined)
	_StepNumber = ?(StepNumber = Undefined, Form.CurrentStep, StepNumber);
	Step = Form.StepsInfo[_StepNumber];
	Step.Status = "NotValid";
	Step.Icon   = GetStepIcon(Step);
	SetNotValidForDependedSteps(Object, Form, _StepNumber);
EndProcedure

&AtClientAtServerNoContext
Procedure SetStepStatus_Skip(Object, Form, StepNumber = Undefined)
	_StepNumber = ?(StepNumber = Undefined, Form.CurrentStep, StepNumber);
	Step = Form.StepsInfo[_StepNumber];
	Step.Status = "Skip";
	Step.Icon   = GetStepIcon(Step);
	SetNotValidForDependedSteps(Object, Form, _StepNumber);
EndProcedure

&AtClientAtServerNoContext
Procedure SetStepStatus_InProgress(Object, Form, StepNumber = Undefined)
	_StepNumber = ?(StepNumber = Undefined, Form.CurrentStep, StepNumber);
	Step = Form.StepsInfo[_StepNumber];
	Step.Status = "InProgress";
	Step.Icon   = GetStepIcon(Step);
	SetNotValidForDependedSteps(Object, Form, _StepNumber);
EndProcedure

&AtClientAtServerNoContext
Procedure SetStepStatus_Error(Object, Form, StepNumber = Undefined)
	_StepNumber = ?(StepNumber = Undefined, Form.CurrentStep, StepNumber);
	Step = Form.StepsInfo[_StepNumber];
	Step.Status = "Error";
	Step.Icon   = GetStepIcon(Step);
	SetNotValidForDependedSteps(Object, Form, _StepNumber);
EndProcedure

&AtClientAtServerNoContext
Procedure SetNotValidForDependedSteps(Object, Form, StepNumber)
	For Each Step In Form.StepsInfo Do
		If Eval("GetWaitingSteps_" + String(Step.StepNumber) + "(Object, Form)").Find(StepNumber) <> Undefined Then
			Step.Status = "NotValid";
			Step.Icon   = GetStepIcon(Step);
		EndIf;
	EndDo;
EndProcedure

&AtClientAtServerNoContext
Procedure AddValidationError(Object, Form, Step, ErrorDescription)
	NewRow = Form.ValidationErrors.Add();
	NewRow.ErrorDescription = ErrorDescription;
	NewRow.StepNumber = Step.StepNumber;
EndProcedure

#Region IconsAndColors

&AtClientAtServerNoContext
Function GetStepIcon(Step)
	If Step.Status = "Valid" Then
		Return 2;
	ElsIf Step.Status = "NotValid" Then
		Return 1;
	ElsIf Step.Status = "InProgress" Then
		Return 3;
	ElsIf Step.Status = "Skip" Then
		Return 4;
	Else
		Return 0;
	EndIf;
EndFunction

&AtClientAtServerNoContext
Function GetStepColor(Step)
	If Step.Status = "Valid" Then
		Return WebColors.PaleGreen;
	ElsIf Step.Status = "NotValid" Then
		Return WebColors.PaleGoldenrod;
	ElsIf Step.Status = "InProgress" Then
		Return WebColors.LightSkyBlue;
	ElsIf Step.Status = "Skip" Then
		Return WebColors.LightGray;
	Else
		Return WebColors.Pink;
	EndIf;
EndFunction

#EndRegion

#Region Step_0_InputData

&AtClientAtServerNoContext
Function ValidateStep_0(Object, Form, Step)
	Result = "Valid";
	If Not ValueIsFilled(Form.Company) Then
		AddValidationError(Object, Form, Step, "Company is required field");
		Result = "Error";
	EndIf;
		
	If Not ValueIsFilled(Form.Period.StartDate) Or Not ValueIsFilled(Form.Period.EndDate) Then
		AddValidationError(Object, Form, Step, "Perid is required field");
		Result = "Error";
	EndIf;
	
	If ValueIsFilled(Form.Period.StartDate) And ValueIsFilled(Form.Period.EndDate) 
		And Form.Period.StartDate > Form.Period.EndDate Then
		AddValidationError(Object, Form, Step, "Start date more than End date");
		Result = "Error";
	EndIf;
	
	Return Result;
EndFunction

&AtClientAtServerNoContext
Function GetWaitingSteps_0(Object, Form)
	Return New Array(); // no waiting steps
EndFunction

#EndRegion

#Region Step_1_RepostingDocuments

&AtClientAtServerNoContext
Function ValidateStep_1(Object, Form, Step)
	Return Step.Status;
EndFunction

&AtClientAtServerNoContext
Function GetWaitingSteps_1(Object, Form)
	Array = New Array();
	Array.Add(0);
	Return Array;
EndFunction

&AtServer
Procedure RunStep_1()
	JobParameters = New Array();
	JobParameters.Add(ThisObject.Company);
	JobParameters.Add(ThisObject.Period.StartDate);
	JobParameters.Add(ThisObject.Period.EndDate);
	JobParameters.Add(ThisObject.Step1_UpdateCurrenciesTable);
	
	RunStepAsBagroundJob(1, ThisObject.StepsInfo[1].Text, "PeriodClosingServer.RepostingDocuments", JobParameters)
EndProcedure

&AtServer
Procedure CompleteStep_1(Result, JobListRow)
	If JobListRow.Status = Enums.JobStatus.Completed Then
		SetStepStatus_Valid(Object, ThisObject, 1);
	ElsIf JobListRow.Status = Enums.JobStatus.Failed Then
		SetStepStatus_Error(Object, ThisObject, 1);
	EndIf;
EndProcedure

#EndRegion

#Region Step_2_CalculationMovementCosts

&AtClientAtServerNoContext
Function ValidateStep_2(Object, Form, Step)
	If Not ValueIsFilled(Form.Step_2_CalculationMode) Then
		AddValidationError(Object, Form, Step, "Calculation mode is required field");
		Return "Error";
	EndIf;
	
	ArrayOfErrors = PeriodClosingServer.Validate_CalculationMovementCost(Form.Company, 
		Form.Period.StartDate, Form.Period.EndDate, Form.Step_2_ForAllCompanies);
	
	If ArrayOfErrors.Count() > 0 Then
		For Each Error In ArrayOfErrors Do
			AddValidationError(Object, Form, Step, Error);
		EndDo;
		Return "Error";
	EndIf;
	
	Return "Valid";
EndFunction

&AtClientAtServerNoContext
Function GetWaitingSteps_2(Object, Form)
	Array = New Array();
	Array.Add(0);
	Array.Add(1);
	Return Array;
EndFunction

&AtServer
Procedure RunStep_2()
	JobParameters = New Array();
	JobParameters.Add(ThisObject.Company);
	JobParameters.Add(ThisObject.Period.StartDate);
	JobParameters.Add(ThisObject.Period.EndDate);
	JobParameters.Add(ThisObject.Step_2_CalculationMode);
	JobParameters.Add(ThisObject.Step_2_ForAllCompanies);
	
	RunStepAsBagroundJob(2, ThisObject.StepsInfo[2].Text, "PeriodClosingServer.CalculationMovementCosts", JobParameters)
EndProcedure

&AtServer
Procedure CompleteStep_2(Result, JobListRow)
	If JobListRow.Status = Enums.JobStatus.Completed Then
		SetStepStatus_Valid(Object, ThisObject, 2);
	ElsIf JobListRow.Status = Enums.JobStatus.Failed Then
		SetStepStatus_Error(Object, ThisObject, 2);
	EndIf;
EndProcedure

#EndRegion

#Region Step_3_VendorsAdvancesClosing

&AtClientAtServerNoContext
Function ValidateStep_3(Object, Form, Step)
	ArrayOfErrors = PeriodClosingServer.Validate_VendorsAdvancesClosing(Form.Company, 
		Form.Period.StartDate, Form.Period.EndDate);
	
	If ArrayOfErrors.Count() > 0 Then
		For Each Error In ArrayOfErrors Do
			AddValidationError(Object, Form, Step, Error);
		EndDo;
		Return "Error";
	EndIf;
	
	Return "Valid";
EndFunction

&AtClientAtServerNoContext
Function GetWaitingSteps_3(Object, Form)
	Array = New Array();
	Array.Add(0);
	Array.Add(1);
	Return Array;
EndFunction

&AtServer
Procedure RunStep_3()
	JobParameters = New Array();
	JobParameters.Add(ThisObject.Company);
	JobParameters.Add(ThisObject.Period.StartDate);
	JobParameters.Add(ThisObject.Period.EndDate);
	JobParameters.Add(ThisObject.Step_3_DontOffsetEmptyProjects);
	
	RunStepAsBagroundJob(3, ThisObject.StepsInfo[3].Text, "PeriodClosingServer.VendorsAdvancesClosing", JobParameters)
EndProcedure

&AtServer
Procedure CompleteStep_3(Result, JobListRow)
	If JobListRow.Status = Enums.JobStatus.Completed Then
		SetStepStatus_Valid(Object, ThisObject, 3);
	ElsIf JobListRow.Status = Enums.JobStatus.Failed Then
		SetStepStatus_Error(Object, ThisObject, 3);
	EndIf;
EndProcedure

#EndRegion

#Region Step_4_CustomersAdvancesClosing

&AtClientAtServerNoContext
Function ValidateStep_4(Object, Form, Step)
	ArrayOfErrors = PeriodClosingServer.Validate_CustomersAdvancesClosing(Form.Company, 
		Form.Period.StartDate, Form.Period.EndDate);
	
	If ArrayOfErrors.Count() > 0 Then
		For Each Error In ArrayOfErrors Do
			AddValidationError(Object, Form, Step, Error);
		EndDo;
		Return "Error";
	EndIf;
	
	Return "Valid";
EndFunction

&AtClientAtServerNoContext
Function GetWaitingSteps_4(Object, Form)
	Array = New Array();
	Array.Add(0);
	Array.Add(1);
	Return Array;
EndFunction

&AtServer
Procedure RunStep_4()
	JobParameters = New Array();
	JobParameters.Add(ThisObject.Company);
	JobParameters.Add(ThisObject.Period.StartDate);
	JobParameters.Add(ThisObject.Period.EndDate);
	JobParameters.Add(ThisObject.Step_4_DontOffsetEmptyProjects);
	
	RunStepAsBagroundJob(4, ThisObject.StepsInfo[4].Text, "PeriodClosingServer.CustomersAdvancesClosing", JobParameters)
EndProcedure

&AtServer
Procedure CompleteStep_4(Result, JobListRow)
	If JobListRow.Status = Enums.JobStatus.Completed Then
		SetStepStatus_Valid(Object, ThisObject, 4);
	ElsIf JobListRow.Status = Enums.JobStatus.Failed Then
		SetStepStatus_Error(Object, ThisObject, 4);
	EndIf;
EndProcedure

#EndRegion

#Region Step_5_ForeignCurrencyRevaluation

&AtClientAtServerNoContext
Function ValidateStep_5(Object, Form, Step)
	Return Step.Status;
EndFunction

&AtClientAtServerNoContext
Function GetWaitingSteps_5(Object, Form)
	Array = New Array();
	Array.Add(0);
	Array.Add(1);
	Array.Add(2);
	Array.Add(3);
	Array.Add(4);
	Return Array;
EndFunction

&AtServer
Procedure RunStep_5()
	JobParameters = New Array();
	JobParameters.Add(ThisObject.Company);
	JobParameters.Add(ThisObject.Period.StartDate);
	JobParameters.Add(ThisObject.Period.EndDate);
	
	RunStepAsBagroundJob(5, ThisObject.StepsInfo[5].Text, "PeriodClosingServer.ForeignCurrencyRevaluation", JobParameters)
EndProcedure

&AtServer
Procedure CompleteStep_5(Result, JobListRow)
	If JobListRow.Status = Enums.JobStatus.Completed Then
		SetStepStatus_Valid(Object, ThisObject, 5);
	ElsIf JobListRow.Status = Enums.JobStatus.Failed Then
		SetStepStatus_Error(Object, ThisObject, 5);
	EndIf;
EndProcedure

#EndRegion

#Region Step_6_AccountingTranslations

&AtClientAtServerNoContext
Function ValidateStep_6(Object, Form, Step)
	Return Step.Status;
EndFunction

&AtClientAtServerNoContext
Function GetWaitingSteps_6(Object, Form)
	Array = New Array();
	Array.Add(0);
	Array.Add(1);
	Array.Add(2);
	Array.Add(3);
	Array.Add(4);
	Array.Add(5);
	Return Array;
EndFunction

&AtServer
Procedure RunStep_6()
	JobParameters = New Array();
	JobParameters.Add(ThisObject.Company);
	JobParameters.Add(ThisObject.Period.StartDate);
	JobParameters.Add(ThisObject.Period.EndDate);
	
	RunStepAsBagroundJob(6, ThisObject.StepsInfo[6].Text, "PeriodClosingServer.AccountingTranslatons", JobParameters)
EndProcedure

&AtServer
Procedure CompleteStep_6(Result, JobListRow)
	If JobListRow.Status = Enums.JobStatus.Completed Then
		SetStepStatus_Valid(Object, ThisObject, 6);
	ElsIf JobListRow.Status = Enums.JobStatus.Failed Then
		SetStepStatus_Error(Object, ThisObject, 6);
	EndIf;
EndProcedure

#EndRegion

#EndRegion

#Region BackgroundMultiJob

&AtClient
Procedure UpdateStatuses(Command)
	CheckJobStatus();
EndProcedure

&AtClient
Procedure CheckJobStatus() Export
	Items.FormUpdateStatuses.Enabled = False;
	
	AllJobDone = True;
	ArrayForDelete = New Array();
	
	For Each Step In ThisObject.StepsInfo Do
		StepJobDone = CheckJobStatusAtServer(Step.StepNumber);
		If Not StepJobDone Then
			AllJobDone = False;
		EndIf;
		
		JobsResult = GetJobsResult(Step.StepNumber);
		
		If JobsResult.Count() = 0 Then
			Continue;
		EndIf;
			
		If ThisObject.ClearCompletedJobs Then
			ArrayForDelete.Add(Step.StepNumber);
		EndIf;
		
		JobListRow = Undefined;
		For Each Row In ThisObject.JobList Do
			If ValueIsFilled(Row.UUID) And Row.StepNumber = Step.StepNumber Then
				JobListRow = Row;
				Break;
			EndIf;
		EndDo;
		
		If JobListRow <> Undefined Then	
			Execute ("CompleteStep_" + String(Step.StepNumber) + "(JobsResult, JobListRowToStructure(JobListRow))");
		EndIf;
	EndDo;		
	
	UpdateLabels();
	
	If AllJobDone Then
		DetachIdleHandler("CheckJobStatus");
	Else
		AttachIdleHandler("CheckJobStatus", ThisObject.UpdatePause, True);
	EndIf;
	
	For Each StepNumber In ArrayForDelete Do
		CompletedJobs = ThisObject.JobList.FindRows(New Structure("StepNumber", StepNumber));
		For Each CompleteJob In CompletedJobs Do
			ThisObject.JobList.Delete(CompleteJob);
		EndDo;
	EndDo;
	
	Items.FormUpdateStatuses.Enabled = True;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Function JobListRowToStructure(JobListRow)
	Result = New Structure("Status");
	FillPropertyValues(Result, JobListRow);
	Return Result;
EndFunction

&AtClient
Procedure UpdateLabels()
	ThisObject.ActiveJob = String(JobList.FindRows(New Structure("Status", PredefinedValue("Enum.JobStatus.Active"))).Count());
	ThisObject.FailedJob = String(JobList.FindRows(New Structure("Status", PredefinedValue("Enum.JobStatus.Failed"))).Count());
	ThisObject.ComplitedJob = String(JobList.FindRows(New Structure("Status", PredefinedValue("Enum.JobStatus.Completed"))).Count());
	ThisObject.WaitJob = String(JobList.FindRows(New Structure("Status", PredefinedValue("Enum.JobStatus.Wait"))).Count());
EndProcedure

&AtServer
Function GetJobsResult(StepNumber)
	JobListFiltered = JobList.Unload().Copy(New Structure("StepNumber", StepNumber));
	Result = BackgroundJobAPIServer.GetJobsResult(JobListFiltered);
	UpdateJobList(JobListFiltered);
	Return Result;
EndFunction

&AtServer
Function CheckJobStatusAtServer(StepNumber)
	JobListFiltered = JobList.Unload().Copy(New Structure("StepNumber", StepNumber));
	
	BackgroundJobAPIServer.CheckJobs(JobListFiltered);
	BackgroundJobAPIServer.RunJobs(JobListFiltered, MaxJobStream);
	UpdateJobList(JobListFiltered);
	For Each Row In JobList Do
		If Row.Status = Enums.JobStatus.Active OR Row.Status = Enums.JobStatus.Wait Then
			Return False;
		EndIf;
	EndDo;
	Return True;
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
Procedure ClearJobList(StepNumber)
	For Each Row In ThisObject.JobList Do
		If Row.StepNumber <> StepNumber Then
			Continue;
		EndIf;
		Row.UUID = Undefined;
	EndDo;
EndProcedure

#EndRegion

StopEventHandling = False;




