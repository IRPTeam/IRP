#Region FORM

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	ViewServer_V2.OnCreateAtServer(Object, Form, "");
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	LockDataModificationPrivileged.LockFormIfObjectIsLocked(Form, CurrentObject);
EndProcedure

#EndRegion

#Region _TITLE

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");
//	AttributesArray.Add("BeginDate");
//	AttributesArray.Add("EndDate");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Attr In AttributesArray Do
		Form.GroupItems.Add(Attr, ?(ValueIsFilled(Form.Items[Attr].Title), Form.Items[Attr].Title,
			Object.Ref.Metadata().Attributes[Attr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion

#Region LIST_FORM

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region CHOICE_FORM

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

Function GetTimeSheet(Parameters) Export
	ResultTable = New ValueTable();
	ResultTable.Columns.Add("Date");
	ResultTable.Columns.Add("Employee");
	ResultTable.Columns.Add("EmployeeSchedule");
	ResultTable.Columns.Add("Position");
	ResultTable.Columns.Add("ProfitLossCenter");
	ResultTable.Columns.Add("CountDaysHours");
	ResultTable.Columns.Add("ActuallyDaysHours");
	
	ResultTable.Columns.Add("SumColumn");
	
	BeginDate = BegOfDay(Parameters.BeginDate);
	EndDate = BegOfDay(Parameters.EndDate);
	
	While BeginDate <= EndDate Do	
		ArrayOfStaffing = GetStaffing(Parameters.Company, Parameters.Branch, BeginDate);
		
		For Each Row In ArrayOfStaffing Do
			NewRow = ResultTable.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.SumColumn = 0;
		EndDo;
		
		BeginDate = EndOfDay(BeginDate) + 1;
	EndDo;
	
	GroupColumn = "Date, Employee, EmployeeSchedule, Position, ProfitLossCenter, CountDaysHours, ActuallyDaysHours";
	SumColumn = "SumColumn";
	
	ResultTable.Sort("Employee, Date");
	Return New Structure("Table, GroupColumn, SumColumn", ResultTable, GroupColumn, SumColumn);
EndFunction

Function GetStaffing(Company, Branch, _Day)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	StaffingSliceLast.Company AS Company,
	|	StaffingSliceLast.Branch AS Branch,
	|	StaffingSliceLast.Employee AS Employee,
	|	StaffingSliceLast.EmployeeSchedule AS EmployeeSchedule,
	|	StaffingSliceLast.Position AS Position,
	|	StaffingSliceLast.ProfitLossCenter AS ProfitLossCenter,
	|	&_Day AS Date
	|INTO Staffing
	|FROM
	|	InformationRegister.T9510S_Staffing.SliceLast(ENDOFPERIOD(&_Day, DAY), Company = &Company) AS StaffingSliceLast
	|		INNER JOIN InformationRegister.T9510S_Staffing.SliceLast(ENDOFPERIOD(&_Day, DAY),) AS StaffingFiredSliceLast
	|		ON (StaffingSliceLast.Employee = StaffingFiredSliceLast.Employee)
	|WHERE
	|	NOT StaffingFiredSliceLast.Fired
	|	AND StaffingSliceLast.Branch = &Branch
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Staffing.Company AS Company,
	|	Staffing.Branch AS Branch,
	|	Staffing.Employee AS Employee,
	|	Staffing.EmployeeSchedule AS EmployeeSchedule,
	|	Staffing.Position AS Position,
	|	Staffing.ProfitLossCenter AS ProfitLossCenter,
	|	Staffing.Date AS Date,
	|	T9530S_WorkDays.CountDaysHours AS CountDaysHours
	|FROM
	|	Staffing AS Staffing
	|		LEFT JOIN InformationRegister.T9530S_WorkDays AS T9530S_WorkDays
	|		ON Staffing.EmployeeSchedule = T9530S_WorkDays.EmployeeSchedule
	|		AND Staffing.Date = T9530S_WorkDays.Date";
	Query.SetParameter("Company", Company);
	Query.SetParameter("Branch" , Branch);
	Query.SetParameter("_Day"   , _Day);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	ArrayOfResults = New Array();
	While QuerySelection.Next() Do
		NewRow = New Structure();
		NewRow.Insert("Date"              , QuerySelection.Date);
		NewRow.Insert("Employee"          , QuerySelection.Employee);
		NewRow.Insert("EmployeeSchedule"  , QuerySelection.EmployeeSchedule);
		NewRow.Insert("Position"          , QuerySelection.Position);
		NewRow.Insert("ProfitLossCenter"  , QuerySelection.ProfitLossCenter);
		NewRow.Insert("CountDaysHours"    , QuerySelection.CountDaysHours);
		NewRow.Insert("ActuallyDaysHours" , QuerySelection.CountDaysHours);
		
		ArrayOfResults.Add(NewRow);
	EndDo;
	
	Return ArrayOfResults;
EndFunction
	
