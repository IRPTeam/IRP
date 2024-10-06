
&AtClient
Var StopEventHandling;

#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)	
	CreateStep(R().PeriodClosing_Step1 , 0, , True);
	CreateStep(R().PeriodClosing_Step2 , 1);
	CreateStep(R().PeriodClosing_Step3 , 2);
	CreateStep(R().PeriodClosing_Step4 , 3);
	CreateStep(R().PeriodClosing_Step5 , 4);
	CreateStep(R().PeriodClosing_Step6 , 5);
	
	If FOServer.IsUseAccounting() Then
		CreateStep(R().PeriodClosing_Step7 , 6);
	EndIf;
	
	ThisObject.UpdatePause = 5;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	UpdateLabels();
	CheckJobStatus();
	SetVisibilityAvailability(Object, ThisObject);	
EndProcedure

&AtClient
Procedure RunAllSteps(Command)
	For Each Step In ThisObject.StepsInfo Do
		If Step.Status = "Skip" Or Step.StepNumber = 0 Then
			Continue;
		EndIf;
		Step.Scheduled = True;
	EndDo;
	CheckJobStatus();
EndProcedure

&AtClient
Procedure RunStep(Command)
	SetStepStatus_InProgress(Object, ThisObject);
	SetVisibilityAvailability(Object, ThisObject);
	Execute("RunStep_" + String(ThisObject.CurrentStep) + "()");
	CheckJobStatus();
EndProcedure

&AtClient
Procedure UnskipAllStepsBefore(Command)
	CurrentData = Items.StepsInfo.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	First = CurrentData.StepNumber - 1;
	Last  = 1;
	
	While First >= Last Do
		SetStepStatus_NotValid(Object, ThisObject, First);
		First = First - 1;
	EndDo;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure SkipAllStepsBefore(Command)
	CurrentData = Items.StepsInfo.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	First = CurrentData.StepNumber - 1;
	Last  = 1;
	
	While First >= Last Do
		SetStepStatus_Skip(Object, ThisObject, First);
		First = First - 1;
	EndDo;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure SkipAllStepsAfter(Command)
	CurrentData = Items.StepsInfo.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	First = CurrentData.StepNumber + 1;
	Last  = ThisObject.StepsInfo.Count() - 1;
	
	While First <= Last Do
		SetStepStatus_Skip(Object, ThisObject, First);
		First = First + 1;
	EndDo;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure UnskipAllStepsAfter(Command)
	CurrentData = Items.StepsInfo.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	First = CurrentData.StepNumber + 1;
	Last  = ThisObject.StepsInfo.Count() - 1;
	
	While First <= Last Do
		SetStepStatus_NotValid(Object, ThisObject, First);
		First = First + 1;
	EndDo;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure SkipStep(Command)
	SetStepStatus_Skip(Object, ThisObject);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure UnskipStep(Command)
	SetStepStatus_NotValid(Object, ThisObject);
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

&AtClient
Procedure StepParameterOnChange(Item)
	SetStepStatus_NotValid(Object, ThisObject);
	SetVisibilityAvailability(Object, ThisObject);	
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
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	CurrentStepInProgress  = (Form.StepsInfo[Form.CurrentStep].Status = "InProgress");
	CurrentStepValid       = (Form.StepsInfo[Form.CurrentStep].Status = "Valid");
	CurrentStepSkipped     = (Form.StepsInfo[Form.CurrentStep].Status = "Skip");
	CurrentStepIsScheduled = Form.StepsInfo[Form.CurrentStep].Scheduled;
	
	AnyStepInProgress = (Form.StepsInfo.FindRows(New Structure("Status", "InProgress")).Count() > 0);
	
	Form.Items.FormPrevStep.Enabled = Not (Form.CurrentStep - 1 < 0);
	Form.Items.FormNextStep.Enabled = Not (Form.CurrentStep + 1 > (Form.StepsInfo.Count() - 1));
	
	Form.Items.DecorationHead.Title = Form.StepsInfo[Form.CurrentStep].Text;
	Form.Items.GroupHead.BackColor = GetStepColor(Form.StepsInfo[Form.CurrentStep]);
	
	Form.Items.Company.ReadOnly = AnyStepInProgress Or Form.CurrentStep <> 0;
	Form.Items.Period.ReadOnly = AnyStepInProgress Or Form.CurrentStep <> 0;
			
	ArrayOfWaitingSteps = GetWaitingSteps(Object, Form, Form.CurrentStep);
	
	VisibleFilter = New Structure("Visible", True);
	Form.Items.StepsInfoWaiting.RowFilter = New FixedStructure(VisibleFilter);
		
	Form.Items.GroupSteps.CurrentPage = Form.Items["GroupStep" + String(Form.CurrentStep)];
	
	StepNumberFilter = New Structure("StepNumber", Form.CurrentStep);
	Form.Items.ValidationErrors.RowFilter = New FixedStructure(StepNumberFilter);
	Form.ValidationErrors.Clear();
	For Each Row In Form.PermanentValidationErrors Do
		FillPropertyValues(Form.ValidationErrors.Add(), Row);
	EndDo;
	
	For Each Step In Form.StepsInfo Do
		Step.ValidationError = False;
		Step.Status = Eval("ValidateStep_"+ String(Step.StepNumber) +"(Object, Form, Step)");
		
		GroupStep = Form.Items["GroupStep" + String(Step.StepNumber)];
		GroupStep.Visible = (GroupStep = Form.Items.GroupSteps.CurrentPage);
		GroupStep.ReadOnly = CurrentStepInProgress Or CurrentStepIsScheduled;
		
		Step.Visible = (ArrayOfWaitingSteps.Find(Step.StepNumber) <> Undefined);
		Step.Current = False;
		Step.Icon = GetStepIcon(Step);
	EndDo;
	
	Form.StepsInfo[Form.CurrentStep].Current = True;
		
	If Form.CurrentStep = 0 Then
		Form.Items.RunStep.Visible = False;
		Form.Items.SkipStep.Visible = False;
		Form.Items.RunAllSteps.Visible = True;
		
		AllStepsCanRun = True;
		ContainWaitingSteps = False; // not skipped
		ContainInProgressSteps = False;
		ContainValidationErrorSteps = False;
		
		For Each Step In Form.StepsInfo Do
			If Step.Status = "Skip" Then
				Continue;
			EndIf;
			
			If Step.Status = "InProgress" Then
				ContainInProgressSteps = True;
			EndIf;
			
			If Step.ValidationError Then
				ContainValidationErrorSteps = True;
			EndIf;
			
			If Step.StepNumber <> 0 Then
				ContainWaitingSteps = True;
			EndIf;
			
			ArrayOfWaitingSteps = GetWaitingSteps(Object, Form, Step.StepNumber);
			For Each WaitingStep In ArrayOfWaitingSteps Do
				If Form.StepsInfo[WaitingStep].Status = "Error" Then 
					AllStepsCanRun = False;
					Break;
				EndIf;
			EndDo;
		EndDo;
			
		Form.Items.RunAllSteps.Enabled = AllStepsCanRun And ContainWaitingSteps 
			And Not ContainInProgressSteps And Not ContainValidationErrorSteps;
				
	Else
		Form.Items.RunStep.Visible = True;
		Form.Items.SkipStep.Visible = True;
		Form.Items.RunAllSteps.Visible = False;

		AllWaitingStepsIsValidOrSkipped = GetAllWaitingStepsIsValidOrSkipped(Object, Form, ArrayOfWaitingSteps);		
		
		Form.Items.RunStep.Enabled = AllWaitingStepsIsValidOrSkipped 
			And Not CurrentStepInProgress And Not CurrentStepIsScheduled
			And Not Form.StepsInfo[Form.CurrentStep].ValidationError;
			
		Form.Items.SkipStep.Enabled = Not CurrentStepValid 
			And Not CurrentStepInProgress And Not CurrentStepIsScheduled;
			
		Form.Items.UnskipStep.Enabled = CurrentStepSkipped And Not CurrentStepValid 
			And Not CurrentStepInProgress And Not CurrentStepIsScheduled
	EndIf;
	
	ContainValidationErrors = False;
	For Each Row In Form.ValidationErrors Do
		If Row.StepNumber = Form.CurrentStep Then
			ContainValidationErrors = True;
			Break;
		EndIf;
	EndDo;
	
	Form.Items.GroupValidationErrors.Visible = ContainValidationErrors;
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
	RemovePermanentValidationError(Object, Form, Form.StepsInfo[_StepNumber]);
	Step = Form.StepsInfo[_StepNumber];	
	Step.Status = "Valid";
	Step.Icon   = GetStepIcon(Step);
	SetNotValidForDependedSteps(Object, Form, _StepNumber);
EndProcedure

&AtClientAtServerNoContext
Procedure SetStepStatus_NotValid(Object, Form, StepNumber = Undefined)
	_StepNumber = ?(StepNumber = Undefined, Form.CurrentStep, StepNumber);
	RemovePermanentValidationError(Object, Form, Form.StepsInfo[_StepNumber]);
	Step = Form.StepsInfo[_StepNumber];
	Step.Status = "NotValid";
	Step.Icon   = GetStepIcon(Step);
	SetNotValidForDependedSteps(Object, Form, _StepNumber);
EndProcedure

&AtClientAtServerNoContext
Procedure SetStepStatus_Skip(Object, Form, StepNumber = Undefined)
	_StepNumber = ?(StepNumber = Undefined, Form.CurrentStep, StepNumber);
	RemovePermanentValidationError(Object, Form, Form.StepsInfo[_StepNumber]);
	Step = Form.StepsInfo[_StepNumber];
	Step.Status = "Skip";
	Step.Icon   = GetStepIcon(Step);
	SetNotValidForDependedSteps(Object, Form, _StepNumber);
EndProcedure

&AtClientAtServerNoContext
Procedure SetStepStatus_InProgress(Object, Form, StepNumber = Undefined)
	_StepNumber = ?(StepNumber = Undefined, Form.CurrentStep, StepNumber);
	RemovePermanentValidationError(Object, Form, Form.StepsInfo[_StepNumber]);
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
		If Step.Status = "Skip" Then
			Continue;
		EndIf;
		
		If Eval("GetWaitingSteps_" + String(Step.StepNumber) + "(Object, Form)").Find(StepNumber) <> Undefined Then
			SetStepStatus_NotValid(Object, Form, Step.StepNumber);
		EndIf;
	EndDo;
EndProcedure

&AtServer
Procedure SetStepComplete(StepNumber, JobResult, JobListRows)
	AllComplete = True;
	For Each Row In JobListRows Do
		If Row.Status <> Enums.JobStatus.Completed Then
			AllComplete = False;
			Break;
		EndIf;
	EndDo;

	If AllComplete Then	
		SetStepStatus_Valid(Object, ThisObject, StepNumber);
	Else
		SetStepStatus_Error(Object, ThisObject, StepNumber);
	EndIf;
EndProcedure

&AtClientAtServerNoContext
Procedure AddValidationError(Object, Form, Step, Msg, Ref=Undefined, Permanent=False)
	If Permanent Then
		NewRow = Form.PermanentValidationErrors.Add();
	Else
		NewRow = Form.ValidationErrors.Add();
	EndIf;
	NewRow.ErrorDescription = Msg;
	NewRow.Ref = Ref;
	NewRow.StepNumber = Step.StepNumber;
EndProcedure

&AtClientAtServerNoContext
Procedure RemovePermanentValidationError(Object, Form, Step)
	ArrayForDelete = New Array();
	For Each Row In Form.PermanentValidationErrors Do
		If Row.StepNumber = Step.StepNumber Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	
	For Each Row In ArrayForDelete Do
		Form.PermanentValidationErrors.Delete(Row);
	EndDo;
EndProcedure

&AtClientAtServerNoContext
Function GetWaitingSteps(Object, Form, StepNumber)
	Return Eval("GetWaitingSteps_" + String(StepNumber) + "(Object, Form)");
EndFunction

&AtClientAtServerNoContext
Function GetAllWaitingStepsIsValidOrSkipped(Object, Form, ArrayOfWaitingSteps)
	AllWaitingStepsIsValidOrSkipped = True;
	For Each WaitingStep In ArrayOfWaitingSteps Do
		If Not (Form.StepsInfo[WaitingStep].Status = "Valid" 
			Or Form.StepsInfo[WaitingStep].Status = "Skip") Then
			AllWaitingStepsIsValidOrSkipped = False;
			Break;
		EndIf;
	EndDo;
	Return AllWaitingStepsIsValidOrSkipped;
EndFunction
	
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
		AddValidationError(Object, Form, Step, R().PeriodClosing_Error1);
		Result = "Error";
		Step.ValidationError = True;
	EndIf;
		
	If Not ValueIsFilled(Form.Period.StartDate) Or Not ValueIsFilled(Form.Period.EndDate) Then
		AddValidationError(Object, Form, Step, R().PeriodClosing_Error2);
		Result = "Error";
		Step.ValidationError = True;
	EndIf;
	
	If ValueIsFilled(Form.Period.StartDate) And ValueIsFilled(Form.Period.EndDate) 
		And Form.Period.StartDate > Form.Period.EndDate Then
		AddValidationError(Object, Form, Step, R().PeriodClosing_Error3);
		Result = "Error";
		Step.ValidationError = True;
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
	If Step.Status = "Skip" Then
		Return Step.Status;
	EndIf;
	
	ArrayOfWaitingSteps = GetWaitingSteps(Object, Form, Step.StepNumber);
	If Not GetAllWaitingStepsIsValidOrSkipped(Object, Form, ArrayOfWaitingSteps) Then
		Return "NotValid";
	EndIf;
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
	ClearJobList(1);
	JobParameters = New Array();
	JobParameters.Add(ThisObject.Company);
	JobParameters.Add(ThisObject.Period.StartDate);
	JobParameters.Add(ThisObject.Period.EndDate);
	JobParameters.Add(ThisObject.Step1_UpdateCurrenciesTable);
	
	RunStepAsBagroundJob(1, ThisObject.StepsInfo[1].Text, "PeriodClosingServer.RepostingDocuments", JobParameters)
EndProcedure

&AtServer
Procedure CompleteStep_1(JobResult, JobListRows)
	SetStepComplete(1, JobResult, JobListRows);
EndProcedure

#EndRegion

#Region Step_2_CalculationMovementCosts

&AtClientAtServerNoContext
Function ValidateStep_2(Object, Form, Step)
	If Step.Status = "Skip" Then
		Return Step.Status;
	EndIf;
	
	HaveErrors = False;
	
	If Not ValueIsFilled(Form.Step_2_CalculationMode) Then
		AddValidationError(Object, Form, Step, R().PeriodClosing_Error4);
		HaveErrors = True;
	EndIf;
	
	If Not ValueIsFilled(Form.Step_2_Periodicity) Then
		AddValidationError(Object, Form, Step, R().PeriodClosing_Error5);
		HaveErrors = True;		
	EndIf;
	
	If HaveErrors Then
		Step.ValidationError = True;
		Return "Error";
	EndIf;
	
	ArrayOfErrors = PeriodClosingServer.Validate_CalculationMovementCost(Form.Company, 
		Form.Period.StartDate, Form.Period.EndDate, Form.Step_2_ForAllCompanies);
	
	If ArrayOfErrors.Count() > 0 Then
		For Each Error In ArrayOfErrors Do
			AddValidationError(Object, Form, Step, Error.Msg, Error.Ref);
		EndDo;
		Step.ValidationError = True;
		Return "Error";
	EndIf;
	
	ArrayOfWaitingSteps = GetWaitingSteps(Object, Form, Step.StepNumber);
	If Not GetAllWaitingStepsIsValidOrSkipped(Object, Form, ArrayOfWaitingSteps) Then
		Return "NotValid";
	EndIf;
	
	Return Step.Status;
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
	ClearJobList(2);
	JobParameters = New Array();
	JobParameters.Add(ThisObject.Company);
	JobParameters.Add(BegOfDay(ThisObject.Period.StartDate));
	JobParameters.Add(BegOfDay(ThisObject.Period.EndDate));
	JobParameters.Add(ThisObject.Step_2_CalculationMode);
	JobParameters.Add(ThisObject.Step_2_ForAllCompanies);
	JobParameters.Add(ThisObject.Step_2_Periodicity);
	
	RunStepAsBagroundJob(2, ThisObject.StepsInfo[2].Text, "PeriodClosingServer.CalculationMovementCosts", JobParameters)
EndProcedure

&AtServer
Procedure CompleteStep_2(JobResult, JobListRows)
	SetStepComplete(2, JobResult, JobListRows);
EndProcedure

#EndRegion

#Region Step_3_VendorsAdvancesClosing

&AtClientAtServerNoContext
Function ValidateStep_3(Object, Form, Step)
	If Step.Status = "Skip" Then
		Return Step.Status;
	EndIf;
	
	If Not ValueIsFilled(Form.Step_3_Periodicity) Then
		AddValidationError(Object, Form, Step, R().PeriodClosing_Error5);
		Step.ValidationError = True;
		Return "Error";		
	EndIf;
	
	ArrayOfErrors = PeriodClosingServer.Validate_VendorsAdvancesClosing(Form.Company, 
		Form.Period.StartDate, Form.Period.EndDate);
	
	If ArrayOfErrors.Count() > 0 Then
		For Each Error In ArrayOfErrors Do
			AddValidationError(Object, Form, Step, Error.Msg, Error.Ref);
		EndDo;
		Step.ValidationError = True;
		Return "Error";
	EndIf;
	
	ArrayOfWaitingSteps = GetWaitingSteps(Object, Form, Step.StepNumber);
	If Not GetAllWaitingStepsIsValidOrSkipped(Object, Form, ArrayOfWaitingSteps) Then
		Return "NotValid";
	EndIf;
	
	Return Step.Status;
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
	ClearJobList(3);
	JobParameters = New Array();
	JobParameters.Add(ThisObject.Company);
	JobParameters.Add(BegOfDay(ThisObject.Period.StartDate));
	JobParameters.Add(BegOfDay(ThisObject.Period.EndDate));
	JobParameters.Add(ThisObject.Step_3_DontOffsetEmptyProjects);
	JobParameters.Add(ThisObject.Step_3_Periodicity);
	
	RunStepAsBagroundJob(3, ThisObject.StepsInfo[3].Text, "PeriodClosingServer.VendorsAdvancesClosing", JobParameters)
EndProcedure

&AtServer
Procedure CompleteStep_3(JobResult, JobListRows)
	SetStepComplete(3, JobResult, JobListRows);
EndProcedure

#EndRegion

#Region Step_4_CustomersAdvancesClosing

&AtClientAtServerNoContext
Function ValidateStep_4(Object, Form, Step)
	If Step.Status = "Skip" Then
		Return Step.Status;
	EndIf;
	
	If Not ValueIsFilled(Form.Step_4_Periodicity) Then
		AddValidationError(Object, Form, Step, R().PeriodClosing_Error5);
		Step.ValidationError = True;
		Return "Error";		
	EndIf;

	ArrayOfErrors = PeriodClosingServer.Validate_CustomersAdvancesClosing(Form.Company, 
		Form.Period.StartDate, Form.Period.EndDate);
	
	If ArrayOfErrors.Count() > 0 Then
		For Each Error In ArrayOfErrors Do
			AddValidationError(Object, Form, Step, Error.Msg, Error.Ref);
		EndDo;
		Step.ValidationError = True;
		Return "Error";
	EndIf;
	
	ArrayOfWaitingSteps = GetWaitingSteps(Object, Form, Step.StepNumber);
	If Not GetAllWaitingStepsIsValidOrSkipped(Object, Form, ArrayOfWaitingSteps) Then
		Return "NotValid";
	EndIf;

	Return Step.Status;
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
	ClearJobList(4);
	JobParameters = New Array();
	JobParameters.Add(ThisObject.Company);
	JobParameters.Add(BegOfDay(ThisObject.Period.StartDate));
	JobParameters.Add(BegOfDay(ThisObject.Period.EndDate));
	JobParameters.Add(ThisObject.Step_4_DontOffsetEmptyProjects);
	JobParameters.Add(ThisObject.Step_4_Periodicity);
	
	RunStepAsBagroundJob(4, ThisObject.StepsInfo[4].Text, "PeriodClosingServer.CustomersAdvancesClosing", JobParameters)
EndProcedure

&AtServer
Procedure CompleteStep_4(JobResult, JobListRows)
	SetStepComplete(4, JobResult, JobListRows);
EndProcedure

#EndRegion

#Region Step_5_ForeignCurrencyRevaluation

&AtClientAtServerNoContext
Function ValidateStep_5(Object, Form, Step)
	If Step.Status = "Skip" Then
		Return Step.Status;
	EndIf;
	
	If Not ValueIsFilled(Form.Step_5_Periodicity) Then
		AddValidationError(Object, Form, Step, R().PeriodClosing_Error5);
		Step.ValidationError = True;
		Return "Error";		
	EndIf;

	ArrayOfWaitingSteps = GetWaitingSteps(Object, Form, Step.StepNumber);
	If Not GetAllWaitingStepsIsValidOrSkipped(Object, Form, ArrayOfWaitingSteps) Then
		Return "NotValid";
	EndIf;
	
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
	ClearJobList(5);
	Analytics = New Structure();
	Analytics.Insert("RevenueType"               , ThisObject.Step_5_RevenueType);
	Analytics.Insert("RevenueProfitLossCenter"   , ThisObject.Step_5_RevenueProfitLossCenter);
	Analytics.Insert("RevenueAdditionalAnalytic" , ThisObject.Step_5_RevenueAdditionalAnalytic);
	Analytics.Insert("ExpenseType"               , ThisObject.Step_5_ExpenseType);
	Analytics.Insert("ExpenseProfitLossCenter"   , ThisObject.Step_5_ExpenseProfitLossCenter);
	Analytics.Insert("ExpenseAdditionalAnalytic" , ThisObject.Step_5_ExpenseAdditionalAnalytic);
	
	JobParameters = New Array();
	JobParameters.Add(ThisObject.Company);
	JobParameters.Add(BegOfDay(ThisObject.Period.StartDate));
	JobParameters.Add(BegOfDay(ThisObject.Period.EndDate));
	JobParameters.Add(Analytics);
	JobParameters.Add(ThisObject.Step_5_Periodicity);
	
	RunStepAsBagroundJob(5, ThisObject.StepsInfo[5].Text, "PeriodClosingServer.ForeignCurrencyRevaluation", JobParameters)
EndProcedure

&AtServer
Procedure CompleteStep_5(JobResult, JobListRows)
	SetStepComplete(5, JobResult, JobListRows);
EndProcedure

#EndRegion

#Region Step_6_AccountingTranslation

&AtClientAtServerNoContext
Function ValidateStep_6(Object, Form, Step)
	If Step.Status = "Skip" Then
		Return Step.Status;
	EndIf;
	
	ArrayOfWaitingSteps = GetWaitingSteps(Object, Form, Step.StepNumber);
	If Not GetAllWaitingStepsIsValidOrSkipped(Object, Form, ArrayOfWaitingSteps) Then
		Return "NotValid";
	EndIf;
	
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
	ClearJobList(6);
	
	CompanyList = New Array();
	CompanyList.Add(ThisObject.Company);
	DocumentsTable = AccountingServer.GetDocumentList(New Structure("CompanyList, StartDate, EndDate", 
		CompanyList, ThisObject.Period.StartDate, ThisObject.Period.EndDate));
	
	DocsInPack = 8;
	StreamArray = New Array();		
	For Each Row In DocumentsTable Do
				
		Pack = 1;
		StreamArray.Add(Row.Ref);
		
		If StreamArray.Count() = DocsInPack Then
			JobParameters = New Array();
			JobParameters.Add(StreamArray);
			
			RunStepAsBagroundJob(6, ThisObject.StepsInfo[6].Text + " " + Pack + " * (" + DocsInPack + ")", 
				"PeriodClosingServer.AccountingTranslation", JobParameters);
						
			StreamArray = New Array;
			Pack = Pack + 1;
		EndIf;
	EndDo;
	
	If StreamArray.Count() > 0 Then
		JobParameters = New Array();
		JobParameters.Add(StreamArray);
		
		RunStepAsBagroundJob(6, ThisObject.StepsInfo[6].Text + " " + Pack + " * (" + StreamArray.Count() + ")", 
			"PeriodClosingServer.AccountingTranslation", JobParameters);
	EndIf;
EndProcedure

&AtServer
Procedure CompleteStep_6(JobResult, JobListRows)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	JournalEntryErrors.Ref AS Ref,
	|	JournalEntryErrors.Error AS Error
	|FROM
	|	InformationRegister.T9052S_AccountingRelevance AS T9052S_AccountingRelevance
	|		INNER JOIN Document.JournalEntry.Errors AS JournalEntryErrors
	|		ON T9052S_AccountingRelevance.Document = JournalEntryErrors.Ref.Basis
	|		AND (JournalEntryErrors.Ref.Company = &Company)
	|		AND (NOT JournalEntryErrors.Ref.DeletionMark)
	|		AND (JournalEntryErrors.Ref.Date BETWEEN &StartDate AND &EndDate)";
	
	Query.SetParameter("Company"   , ThisObject.Company);
	Query.SetParameter("StartDate" , ThisObject.Period.StartDate);
	Query.SetParameter("EndDate"   , ThisObject.Period.EndDate);
	
	QueryResult = Query.Execute();
	
	RemovePermanentValidationError(Object, ThisObject, ThisObject.StepsInfo[6]);
	
	If QueryResult.IsEmpty() Then
		SetStepComplete(6, JobResult, JobListRows);
	Else
		QuerySelection = QueryResult.Select();
		While QuerySelection.Next() Do
			AddValidationError(Object, ThisObject, ThisObject.StepsInfo[6], QuerySelection.Error, QuerySelection.Ref, True);
		EndDo;
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
		
	For Each Step In ThisObject.StepsInfo Do
		StepJobDone = CheckJobStatusAtServer(Step.StepNumber);
		If Not StepJobDone Then
			AllJobDone = False;
		EndIf;
		
		JobsResult = Undefined;//GetJobsResult(Step.StepNumber);
		
//		If JobsResult.Count() = 0 Or Not StepJobDone Then
//			Continue;
//		EndIf;
		
		If Not StepJobDone Then
			Continue;
		EndIf;
		
		JobListRows = New Array();
		For Each Row In ThisObject.JobList Do
			If ValueIsFilled(Row.UUID) And Row.StepNumber = Step.StepNumber Then
				Row.UUID = Undefined;
				JobListRows.Add(Row);
			EndIf;
		EndDo;
		
		If JobListRows.Count() > 0 Then	
			Execute ("CompleteStep_" + String(Step.StepNumber) + "(JobsResult, ConvertJobListRows(JobListRows))");
		EndIf;
	EndDo;		
	
	UpdateLabels();
	
	If AllJobDone Then
		ScheduledStepIsRun = False;
		
		For Each Step In ThisObject.StepsInfo Do
			If Not Step.Scheduled Or Step.StepNumber = 0 Then
				Continue;
			EndIf;
			
			ArrayOfWaitingSteps = GetWaitingSteps(Object, ThisObject, Step.StepNumber);
			
			Waiting_IsScheduled = False;
			Waiting_IsError = False;
			For Each WaitingStepNumber In ArrayOfWaitingSteps Do
				If ThisObject.StepsInfo[WaitingStepNumber].Scheduled Then
					Waiting_IsScheduled = True;
				EndIf;
				If ThisObject.StepsInfo[WaitingStepNumber].Status = "Error" Then
					Waiting_IsError = True;
				EndIf;
			EndDo;
			
			If Waiting_IsError Then
				Step.Scheduled = False;
				SetStepStatus_NotValid(Object, ThisObject, Step.StepNumber);
				Continue;
			EndIf;
			
			If Waiting_IsScheduled Then
				Continue;
			EndIf;
			
			AllWaitingStepsIsValidOrSkipped = GetAllWaitingStepsIsValidOrSkipped(Object, ThisObject, ArrayOfWaitingSteps);
			If AllWaitingStepsIsValidOrSkipped Then
				ScheduledStepIsRun = True;
				Step.Scheduled = False;
				SetStepStatus_InProgress(Object, ThisObject, Step.StepNumber);
				Execute("RunStep_" + String(Step.StepNumber) + "()");	
			EndIf;
		EndDo;
		
		If ScheduledStepIsRun Then
			AttachIdleHandler("CheckJobStatus", ThisObject.UpdatePause, True);
		Else
			DetachIdleHandler("CheckJobStatus");
		EndIf;
		
	Else
		AttachIdleHandler("CheckJobStatus", ThisObject.UpdatePause, True);
	EndIf;
		
	Items.FormUpdateStatuses.Enabled = True;
	SetVisibilityAvailability(Object, ThisObject);
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
	ThisObject.ActiveJob = String(JobList.FindRows(New Structure("Status", PredefinedValue("Enum.JobStatus.Active"))).Count());
	ThisObject.FailedJob = String(JobList.FindRows(New Structure("Status", PredefinedValue("Enum.JobStatus.Failed"))).Count());
	ThisObject.ComplitedJob = String(JobList.FindRows(New Structure("Status", PredefinedValue("Enum.JobStatus.Completed"))).Count());
	ThisObject.WaitJob = String(JobList.FindRows(New Structure("Status", PredefinedValue("Enum.JobStatus.Wait"))).Count());
EndProcedure

//&AtServer
//Function GetJobsResult(StepNumber)
//	JobListFiltered = CopyJobList(StepNumber);
//	Result = BackgroundJobAPIServer.GetJobsResult(JobListFiltered);
//	UpdateJobList(JobListFiltered);
//	Return Result;
//EndFunction

&AtServer
Function CheckJobStatusAtServer(StepNumber)
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

&AtServer
Function CopyJobList(StepNumber)
	JobListFiltered = JobList.Unload().Copy(New Structure("StepNumber", StepNumber));
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




