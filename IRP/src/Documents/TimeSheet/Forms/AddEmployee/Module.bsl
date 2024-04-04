
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	BeginDate = BegOfDay(Parameters.BeginDate);
	EndDate = BegOfDay(Parameters.EndDate);
	
	ResultTable = New ValueTable();
	ResultTable.Columns.Add("Employee", New TypeDescription("CatalogRef.Partners"));
	
	While BeginDate <= EndDate Do	
		ArrayOfStaffing = GetStaffing(Parameters.Company, Parameters.Branch, BeginDate);	
		For Each Row In ArrayOfStaffing Do
			If Parameters.Employees.Find(Row.Employee) <> Undefined Then
				Continue;
			EndIf;
			NewRow = ResultTable.Add();
			FillPropertyValues(NewRow, Row);
		EndDo;
		BeginDate = EndOfDay(BeginDate) + 1;
	EndDo;
	
	ResultTable.GroupBy("Employee");
	ThisObject.EmployeeTable.Load(ResultTable);
EndProcedure

&AtServer
Function GetStaffing(Company, Branch, _Day)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	StaffingSliceLast.Employee AS Employee
	|FROM
	|	InformationRegister.T9510S_Staffing.SliceLast(ENDOFPERIOD(&_Day, DAY), Company = &Company) AS StaffingSliceLast
	|		INNER JOIN InformationRegister.T9510S_Staffing.SliceLast(ENDOFPERIOD(&_Day, DAY),) AS StaffingFiredSliceLast
	|		ON (StaffingSliceLast.Employee = StaffingFiredSliceLast.Employee)
	|WHERE
	|	NOT StaffingFiredSliceLast.Fired
	|	AND StaffingSliceLast.Branch = &Branch";
	Query.SetParameter("Company", Company);
	Query.SetParameter("Branch" , Branch);
	Query.SetParameter("_Day"   , _Day);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	ArrayOfResults = New Array();
	While QuerySelection.Next() Do
		ArrayOfResults.Add(New Structure("Employee", QuerySelection.Employee));
	EndDo;
	
	Return ArrayOfResults;
EndFunction

&AtClient
Procedure EmployeeTableBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure EmployeeTableBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure CheckAll(Command)
	ChangeSelection(True);
EndProcedure

&AtClient
Procedure UncheckAll(Command)
	ChangeSelection(False);
EndProcedure
	
&AtClient
Procedure ChangeSelection(Value)
	For Each Row In ThisObject.EmployeeTable Do
		Row.Selected = Value;
	EndDo;
EndProcedure

&AtClient
Procedure Select(Command)
	CloseWithResult();
EndProcedure

&AtClient
Procedure CloseWithResult()
	ArrayOfEmployee = New Array();
	For Each Row In ThisObject.EmployeeTable Do
		If Row.Selected Then
			ArrayOfEmployee.Add(Row.Employee);
		EndIf;
	EndDo;
	Close(New Structure("ArrayOfEmployee", ArrayOfEmployee));
EndProcedure

