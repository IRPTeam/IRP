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
	AttributesArray.Add("BeginDate");
	AttributesArray.Add("EndDate");
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
	ResultTable.Columns.Add("Position");
	ResultTable.Columns.Add("AccrualAndDeductionType");
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
	
	ResultTable.Sort("Employee, Date");
	
	Return ResultTable;
EndFunction

Function GetStaffing(Company, Branch, _Day)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	StaffingSliceLast.Employee AS Employee,
	|	StaffingSliceLast.Position AS Position,
	|	StaffingSliceLast.Period AS Date
	|FROM
	|	InformationRegister.Staffing.SliceLast(ENDOFPERIOD(&_Day, DAY), Company = &Company
	|	AND Branch = &Branch) AS StaffingSliceLast
	|		INNER JOIN InformationRegister.Staffing.SliceLast(ENDOFPERIOD(&_Day, DAY),) AS StaffingFiredSliceLast
	|		ON (StaffingSliceLast.Employee = StaffingFiredSliceLast.Employee)
	|WHERE
	|	NOT StaffingFiredSliceLast.Fired";
	Query.SetParameter("Company", Company);
	Query.SetParameter("Branch" , Branch);
	Query.SetParameter("_Day"   , _Day);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	ArrayOfResults = New Array();
	While QuerySelection.Next() Do
		ArrayOfResults.Add(New Structure("Employee, Position, Date", 
			QuerySelection.Employee,
			QuerySelection.Position,
			_Day));
	EndDo;
	
	Return ArrayOfResults;
EndFunction
	
