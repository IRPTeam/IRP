
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.FromSchedule = Parameters.EmployeeSchedule;
	ThisObject.Period.StartDate = Parameters.StartDate;
	ThisObject.Period.EndDate = Parameters.EndDate;
EndProcedure

&AtServer
Procedure FillCheckProcessingAtServer(Cancel, CheckedAttributes)
	If Not ValueIsFilled(ThisObject.Period.StartDate) 
		Or Not ValueIsFilled(ThisObject.Period.EndDate)
		Or ThisObject.Period.StartDate > ThisObject.Period.EndDate Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Salary_Err_001, "Period");
		Cancel = True;
	EndIf; 
EndProcedure

&AtClient
Procedure Ok(Command)
	If ThisObject.CheckFilling() Then
		CopyCalendarAtServer();
		ThisObject.Close(True);
	EndIf;
EndProcedure

&AtServer
Procedure CopyCalendarAtServer()
	Query = New Query();
	Query.Text = 
	"SELECT
	|	T9530S_WorkDays.Date,
	|	T9530S_WorkDays.CountDaysHours
	|FROM
	|	InformationRegister.T9530S_WorkDays AS T9530S_WorkDays
	|WHERE
	|	T9530S_WorkDays.EmployeeSchedule = &EmployeeSchedule
	|	AND T9530S_WorkDays.Date BETWEEN BEGINOFPERIOD(&StartDate, DAY) AND ENDOFPERIOD(&EndDate, DAY)";
	Query.SetParameter("EmployeeSchedule", ThisObject.FromSchedule);
	Query.SetParameter("StartDate", ThisObject.Period.StartDate);
	Query.SetParameter("EndDate", ThisObject.Period.EndDate);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	_CurrentDate = BegOfDay(ThisObject.Period.StartDate);
	While _CurrentDate <= BegOfDay(ThisObject.Period.EndDate) Do
		RecordSet = InformationRegisters.T9530S_WorkDays.CreateRecordSet();
		RecordSet.Filter.EmployeeSchedule.Set(ThisObject.ToSchedule);
		RecordSet.Filter.Date.Set(_CurrentDate);
		RecordSet.Clear();
		RecordSet.Write();
		_CurrentDate = BegOfDay(EndOfDay(_CurrentDate) + 1);
	EndDo;
	
	While QuerySelection.Next() Do
		RecordSet = InformationRegisters.T9530S_WorkDays.CreateRecordSet();
		RecordSet.Filter.EmployeeSchedule.Set(ThisObject.ToSchedule);
		RecordSet.Filter.Date.Set(QuerySelection.Date);
		
		NewRecord = RecordSet.Add();
		NewRecord.EmployeeSchedule = ThisObject.ToSchedule;
		FillPropertyValues(NewRecord, QuerySelection);
		RecordSet.Write();
	EndDo;
	
EndProcedure

&AtClient
Procedure Cancel(Command)
	ThisObject.Close(Undefined);
EndProcedure

