
#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocTimeSheetServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	FillWorkersAtServer();
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocTimeSheetServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	ThisObject.ListMode = "Calendar";
	
	ThisObject.Period.StartDate = Object.BeginDate;
	ThisObject.Period.EndDate = Object.EndDate;
	
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocTimeSheetServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocTimeSheetClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	DocTimeSheetClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
	SetVisibleRowsTimeSheetList();
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	Form.Items.FillAll.Enabled = Not Form.ReadOnly;
	Form.Items.RefillByCurrentEmployee.Enabled = Not Form.ReadOnly;
	
	If Form.ListMode = "Calendar" Then
		Form.Items.GroupTimeSheetPages.CurrentPage = Form.Items.GroupTimeSheetPageCalendar;
	Else
		Form.Items.GroupTimeSheetPages.CurrentPage = Form.Items.GroupTimeSheetPageTable;
	EndIf;
	
	Form.Items.Calendar.BeginOfRepresentationPeriod = Object.BeginDate;
	Form.Items.Calendar.EndOfRepresentationPeriod   = Object.EndDate;
	
#IF Client THEN
	Form.Items.Calendar.Refresh();

	Form.TotalDays = 0;
	Form.TotalWeekend = 0;
	Form.TotalWorkingDays = 0;
	Form.TotalNotWorkingDays = 0;
	Form.TotalVacation = 0;
	Form.TotalSickLeave = 0;
	
	For Each Row In Object.TimeSheetList Do
		If Not Row.Visible Then
			Continue;
		EndIf;
		
		Form.TotalDays = Form.TotalDays + 1;
		
		If Not ValueIsFilled(Row.CountDaysHours)
			And Not ValueIsFilled(Row.ActuallyDaysHours) Then
				Form.TotalWeekend = Form.TotalWeekend + 1;
				
		ElsIf ValueIsFilled(Row.ActuallyDaysHours)
				And Not Row.IsVacation 
				And Not Row.IsSickLeave Then
				Form.TotalWorkingDays = Form.TotalWorkingDays + 1;
					
		ElsIf ValueIsFilled(Row.CountDaysHours) 
				And Not ValueIsFilled(Row.ActuallyDaysHours) Then
				Form.TotalNotWorkingDays = Form.TotalNotWorkingDays + 1;
			
		ElsIf ValueIsFilled(Row.CountDaysHours) 
				And ValueIsFilled(Row.ActuallyDaysHours)
				And Row.IsVacation Then
				Form.TotalVacation = Form.TotalVacation + 1;
			
		ElsIf ValueIsFilled(Row.CountDaysHours) 
				And ValueIsFilled(Row.ActuallyDaysHours)
				And Row.IsSickLeave Then
				Form.TotalSickLeave = Form.TotalSickLeave + 1;

		EndIf;
	EndDo;
#ENDIF

EndProcedure

&AtClient
Procedure ListModeOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure CalendarOnPeriodOutput(Item, PeriodAppearance)
	CalendarDates = GetCalendarDates();
	For Each Appearance In PeriodAppearance.Dates Do
		If CalendarDates.Weekend.Find(Appearance.Date) <> Undefined Then
			Appearance.BackColor = WebColors.LightPink;
		
		ElsIf CalendarDates.FullWorkedDays.Find(Appearance.Date) <> Undefined Then
			Appearance.BackColor = WebColors.LightGreen;
			
		Elsif CalendarDates.NotWorkedDays.Find(Appearance.Date) <> Undefined Then
			Appearance.BackColor = WebColors.LightGray;
		
		Elsif CalendarDates.VacationDays.Find(Appearance.Date) <> Undefined Then
			Appearance.BackColor = WebColors.LightBlue;
		
		Elsif CalendarDates.SickLeaveDays.Find(Appearance.Date) <> Undefined Then
			Appearance.BackColor = WebColors.PeachPuff;
		
		EndIf;
	EndDo;
EndProcedure

&AtServer
Function GetCalendarDates()
	Result = New Structure();
	Result.Insert("Weekend"        , New Array()); // red
	Result.Insert("FullWorkedDays" , New Array()); // green
	Result.Insert("NotWorkedDays"  , New Array()); // gray
	Result.Insert("VacationDays"   , New Array());  // blue
	Result.Insert("SickLeaveDays"  , New Array());  // yellow
	
	For Each Row In Object.TimeSheetList Do
		If Not Row.Visible Then
			Continue;
		EndIf;
		
		If Not ValueIsFilled(Row.CountDaysHours) 
			And Not ValueIsFilled(Row.ActuallyDaysHours) Then
			Result.Weekend.Add(Row.Date);
		
		ElsIf ValueIsFilled(Row.ActuallyDaysHours)
			And Not Row.IsVacation And Not Row.IsSickLeave Then	
			Result.FullWorkedDays.Add(Row.Date);
				
		ElsIf ValueIsFilled(Row.CountDaysHours) 
			And Not ValueIsFilled(Row.ActuallyDaysHours) Then
			Result.NotWorkedDays.Add(Row.Date);
			
		ElsIf ValueIsFilled(Row.CountDaysHours) 
			And ValueIsFilled(Row.ActuallyDaysHours)
			And Row.IsVacation Then
			Result.VacationDays.Add(Row.Date);
			
		ElsIf ValueIsFilled(Row.CountDaysHours) 
			And ValueIsFilled(Row.ActuallyDaysHours)
			And Row.IsSickLeave Then
			Result.SickLeaveDays.Add(Row.Date);
			
		EndIf;
	EndDo;	
	
	Return Result;
EndFunction

&AtClient
Procedure CalendarSelection(Item, SelectedDate)
	CurrentData = ThisObject.Items.Workers.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	Filter = New Structure();
	Filter.Insert("Employee"         , CurrentData.Employee);
	Filter.Insert("EmployeeSchedule" , CurrentData.EmployeeSchedule);
	Filter.Insert("Position"         , CurrentData.Position);
	Filter.Insert("ProfitLossCenter" , CurrentData.ProfitLossCenter);
	Filter.Insert("Date"             , SelectedDate);
	
	TimeSheetRows = Object.TimeSheetList.FindRows(Filter);
	If TimeSheetRows.Count() <> 1 Then
		Return;
	EndIf;
	
	OpeningParameters = New Structure();
	OpeningParameters.Insert("RowKey"         , TimeSheetRows[0].Key);
	OpeningParameters.Insert("Date"           , TimeSheetRows[0].Date);
	OpeningParameters.Insert("CountDaysHours" , TimeSheetRows[0].CountDaysHours);
	OpeningParameters.Insert("ActuallyDaysHours" , TimeSheetRows[0].ActuallyDaysHours);
	OpeningParameters.Insert("IsVacation"        , TimeSheetRows[0].IsVacation);
	OpeningParameters.Insert("IsSickLeave"       , TimeSheetRows[0].IsSickLeave);
	
	OpenForm("Document.TimeSheet.Form.EditCalendarDay", 
		OpeningParameters, ThisObject, , , , 
		New NotifyDescription("EditCalendarDayEnd", ThisObject), 
		FormWindowOpeningMode.LockOwnerWindow);
	
EndProcedure

&AtClient
Procedure EditCalendarDayEnd(Result, NotifyParams) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	TimeSheetRows = Object.TimeSheetList.FindRows(New Structure("Key", Result.RowKey));
	TimeSheetRows[0].ActuallyDaysHours = Result.ActuallyDaysHours;
	ThisObject.Modified = True;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure PeriodOnChange(Item)
	Object.BeginDate = ThisObject.Period.StartDate;
	Object.EndDate = ThisObject.Period.EndDate;	
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure _IdeHandler()
	ViewClient_V2.ViewIdleHandler(ThisObject, Object);
EndProcedure

&AtClient
Procedure _AttachIdleHandler() Export
	AttachIdleHandler("_IdeHandler", 1);
EndProcedure

&AtClient 
Procedure _DetachIdleHandler() Export
	DetachIdleHandler("_IdeHandler");
EndProcedure

#EndRegion

#Region _DATE

&AtClient
Procedure DateOnChange(Item)
	DocTimeSheetClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocTimeSheetClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocTimeSheetClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocTimeSheetClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region TIME_SHEET_LIST

&AtClient
Procedure TimeSheetListSelection(Item, RowSelected, Field, StandardProcessing)
	DocTimeSheetClient.TimeSheetListSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure TimeSheetListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure TimeSheetListBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure TimeSheetListAfterDeleteRow(Item)
	DocTimeSheetClient.TimeSheetListAfterDeleteRow(Object, ThisObject, Item);
	FillWorkersAtClient();
EndProcedure

#Region TIME_SHEET_LIST_COLUMNS

#EndRegion

#EndRegion

#Region WORKERS

&AtClient
Procedure SetVisibleRowsTimeSheetList()
	CurrentData = Items.Workers.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	For Each Row In Object.TimeSheetList Do
		Row.Visible = 
			(Row.Employee = CurrentData.Employee)
			And (Row.Position = CurrentData.Position)
			And (Row.EmployeeSchedule = CurrentData.EmployeeSchedule);
	EndDo;
	
	For Each Row In Object.TimeSheetList Do
		If Row.Visible Then
			Items.TimeSheetList.CurrentRow = Row.GetID();
			Break;
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure WorkersOnActivateRow(Item)
	SetVisibleRowsTimeSheetList();
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure WorkersBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
	
	If Not CheckFilling() Then
		Return;
	EndIf;
	
	Employees = New Array();
	For Each Row In Object.TimeSheetList Do
		Employees.Add(Row.Employee);
	EndDo;
	
	OpeningParameters = New Structure();
	OpeningParameters.Insert("Company"   , Object.Company);
	OpeningParameters.Insert("Branch"    , Object.Branch);
	OpeningParameters.Insert("EndDate"   , Object.EndDate);
	OpeningParameters.Insert("BeginDate" , Object.BeginDate);
	OpeningParameters.Insert("Employees" , Employees);
	
	NotifyParameters = New Structure();
	Notify = New NotifyDescription("AddEmployeeEnd", ThisObject, NotifyParameters);
	
	OpenForm("Document.TimeSheet.Form.AddEmployee", OpeningParameters, 
	ThisObject, , , , 
	Notify , 
	FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure AddEmployeeEnd(Result, NotifyParams) Export
	If Result = Undefined Then 
		Return;
	EndIf;
	
	If Result.ArrayOfEmployee.Count() = 0 Then
		Return;
	EndIf;
	
	FillingResult = FillTimeSheetAtServer(Result.ArrayOfEmployee);
	
	ViewClient_V2.TimeSheetListLoad(Object, ThisObject, 
		FillingResult.Address, FillingResult.GroupColumn, FillingResult.SumColumn);
	ThisObject.Modified = True;
	
	FillWorkersAtServer();
	
	For Each Row In ThisObject.Workers Do
		If Row.Employee = Result.ArrayOfEmployee[0] Then
			Items.Workers.CurrentRow = Row.GetID();
			Break;
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure WorkersBeforeDeleteRow(Item, Cancel)
	CurrentData = Items.Workers.CurrentData;
	If CurrentData = Undefined Then
		Cancel = True;
		Return;
	EndIf;
	RemoveWorkerRow(CurrentData);
EndProcedure

&AtClient
Procedure WorkersAfterDeleteRow(Item)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure TimeSheetListActuallyDaysHoursOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure RemoveWorkerRow(CurrentData)
	Filter = New Structure();
	Filter.Insert("Employee"         , CurrentData.Employee);
	Filter.Insert("EmployeeSchedule" , CurrentData.EmployeeSchedule);
	Filter.Insert("Position"         , CurrentData.Position);
	Filter.Insert("ProfitLossCenter" , CurrentData.ProfitLossCenter);
	
	Rows = Object.TimeSheetList.FindRows(Filter);
	For Each Row In Rows Do
		Object.TimeSheetList.Delete(Row);
	EndDo;
EndProcedure

#EndRegion

#Region SERVICE

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocTimeSheetClient);
	Str.Insert("Server", DocTimeSheetServer);
	Return Str;
EndFunction

#Region DESCRIPTION

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	CommonFormActions.EditMultilineText(ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region TITLE_DECORATIONS

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

#EndRegion

#Region ADD_ATTRIBUTES

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion

#Region EXTERNAL_COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

#EndRegion

#Region COMMANDS

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Async Procedure FillAllTimeSheet(Command)	
	
	If Not CheckFilling() Then
		Return;
	EndIf;
	
	TableIsFilled = Object.TimeSheetList.Count() > 0;
	
	If TableIsFilled Then
		Answer = Await DoQueryBoxAsync(R().QuestionToUser_015, QuestionDialogMode.OKCancel);
	EndIf;
	
	If Not TableIsFilled Or Answer = DialogReturnCode.OK Then
		Result = FillTimeSheetAtServer();
		Object.TimeSheetList.Clear();	
		ViewClient_V2.TimeSheetListLoad(Object, ThisObject, Result.Address, Result.GroupColumn, Result.SumColumn);
		ThisObject.Modified = True;
		FillWorkersAtClient();
	EndIf;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Async Procedure RefillByCurrentEmployee(Command)
	If Not CheckFilling() Then
		Return;
	EndIf;
	
	CurrentData = Items.Workers.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	CurrentData_Employee         = CurrentData.Employee;
		
	If ValueIsFilled(CurrentData_Employee) Then
		Answer = Await DoQueryBoxAsync(StrTemplate(R().QuestionToUser_027, CurrentData_Employee), QuestionDialogMode.OKCancel);
	Else
		Return;
	EndIf;
	
	If Answer = DialogReturnCode.OK Then
		Result = FillTimeSheetAtServer(CurrentData_Employee);
		Rows = Object.TimeSheetList.FindRows(New Structure("Employee", CurrentData_Employee));
		For Each Row In Rows Do
			Object.TimeSheetList.Delete(Row);
		EndDo;
		ViewClient_V2.TimeSheetListLoad(Object, ThisObject, Result.Address, Result.GroupColumn, Result.SumColumn);
		ThisObject.Modified = True;
		FillWorkersAtClient();
	EndIf;
	
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Function FillTimeSheetAtServer(Filter_Employee = Undefined)
	FillingParameters = New Structure();
	FillingParameters.Insert("Company"   , Object.Company);
	FillingParameters.Insert("Branch"    , Object.Branch);
	FillingParameters.Insert("BeginDate" , Object.BeginDate);
	FillingParameters.Insert("EndDate"   , Object.EndDate);
	FillingParameters.Insert("Employee"  , Filter_Employee);
	
	Result = DocTimeSheetServer.GetTimeSheet(FillingParameters);
	
	Address = PutToTempStorage(Result.Table, ThisObject.UUID);
	Return New Structure("Address, GroupColumn, SumColumn", Address, Result.GroupColumn, Result.SumColumn);
EndFunction

&AtClient
Procedure FillWorkersAtClient()
	CurrentData = Items.Workers.CurrentData;
	
	CurrentData_Employee         = Undefined;
	CurrentData_EmployeeSchedule = Undefined;
	CurrentData_Position         = Undefined;
	CurrentData_ProfitLisCenter  = Undefined;
	
	If CurrentData <> Undefined Then
		CurrentData_Employee         = CurrentData.Employee;
		CurrentData_EmployeeSchedule = CurrentData.EmployeeSchedule;
		CurrentData_Position         = CurrentData.Position;
		CurrentData_ProfitLisCenter  = CurrentData.ProfitLossCenter;
	EndIf;
	
	FillWorkersAtServer(CurrentData_Employee, CurrentData_EmployeeSchedule, CurrentData_Position, CurrentData_ProfitLisCenter);
EndProcedure

&AtServer
Procedure FillWorkersAtServer(CurrentData_Employee = Undefined, 
							  CurrentData_EmployeeSchedule = Undefined,
							  CurrentData_Position = Undefined, 
							  CurrentData_ProfitLossCenter = Undefined)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	TimeSheetList.Employee,
	|	TimeSheetList.EmployeeSchedule,
	|	TimeSheetList.Position,
	|	TimeSheetList.ProfitLossCenter,
	|	TimeSheetList.Date
	|into TimeSheetList
	|From
	|	&TimeSheetList AS TimeSheetList
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TimeSheetList.Employee,
	|	TimeSheetList.EmployeeSchedule,
	|	TimeSheetList.Position,
	|	TimeSheetList.ProfitLossCenter,
	|	MIN(TimeSheetList.Date) AS BeginDate,
	|	MAX(TimeSheetList.Date) AS EndDate
	|FROM
	|	TimeSheetList AS TimeSheetList
	|GROUP BY
	|	TimeSheetList.Employee,
	|	TimeSheetList.EmployeeSchedule,
	|	TimeSheetList.Position,
	|	TimeSheetList.ProfitLossCenter
	|
	|ORDER BY
	|	Employee";
	Query.SetParameter("TimeSheetList", Object.TimeSheetList.Unload());
	QueryResult = Query.Execute();
	
	ThisObject.Workers.Load(QueryResult.Unload());
	
	CurrentRowIsSet = False;
	If CurrentData_Employee <> Undefined 
		And CurrentData_Position <> Undefined 
		And CurrentData_ProfitLossCenter <> Undefined
		And CurrentData_EmployeeSchedule <> Undefined Then
		
		For Each Row In ThisObject.Workers Do
			If Row.Employee = CurrentData_Employee
				And Row.Position = CurrentData_Position
				And Row.ProfitLossCenter = CurrentData_ProfitLossCenter
				And Row.EmployeeSchedule = CurrentData_EmployeeSchedule Then
				Items.Workers.CurrentRow = Row.GetID();
				CurrentRowIsSet = True;
				Break;
			EndIf;
		EndDo;
	EndIf;
	
	If ThisObject.Workers.Count() And Not CurrentRowIsSet Then
		Items.Workers.CurrentRow = ThisObject.Workers[0].GetID();
	EndIf;
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

#EndRegion

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

#EndRegion
