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
	AttributesArray.Add("PaymentPeriod");
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

Function GetCashAdvanceDeduction(Parameters) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R3027B.Partner AS Employee,
	|	R3027B.AmountBalance AS Amount
	|FROM
	|	AccumulationRegister.R3027B_EmployeeCashAdvance.Balance(&Boundary, Company = &Company
	|	AND Branch = &Branch
	|	AND Currency = &Currency
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS R3027B";
	
	Query.SetParameter("Company", Parameters.Company);
	Query.SetParameter("Branch", Parameters.Branch);
	Query.SetParameter("Currency", Parameters.Currency);
	If ValueIsFilled(Parameters.Ref) Then
		Query.SetParameter("Boundary", New Boundary(New PointInTime(Parameters.EndDate, Parameters.Ref), BoundaryType.Excluding));
	Else
		Query.SetParameter("Boundary", Parameters.EndDate);
	EndIf;
	
	ResultTable = Query.Execute().Unload();
	
	GroupColumn = "Employee";
	SumColumn = "Amount";
	
	ResultTable.GroupBy(GroupColumn, SumColumn);
	ResultTable.Sort("Employee");
	
	Return New Structure("Table, GroupColumn, SumColumn", ResultTable, GroupColumn, SumColumn);
EndFunction

Function GetPayrolls(Parameters) Export
	ResultTable = New ValueTable();
	ResultTable.Columns.Add("Employee");
	ResultTable.Columns.Add("Position");
	ResultTable.Columns.Add("ProfitLossCenter");
	ResultTable.Columns.Add(Parameters.TypeColumnName);
	ResultTable.Columns.Add("Amount");
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	T9520S_TimeSheetInfo.Date,
	|	T9520S_TimeSheetInfo.Employee,
	|	T9520S_TimeSheetInfo.Position,
	|	T9520S_TimeSheetInfo.ProfitLossCenter,
	|	T9520S_TimeSheetInfo.AccrualAndDeductionType
	|FROM
	|	InformationRegister.T9520S_TimeSheetInfo AS T9520S_TimeSheetInfo
	|WHERE
	|	T9520S_TimeSheetInfo.Date BETWEEN BEGINOFPERIOD(&BeginDate, DAY) AND ENDOFPERIOD(&EndDate, DAY)
	|	AND T9520S_TimeSheetInfo.Company = &Company
	|	AND T9520S_TimeSheetInfo.Branch = &Branch
	|	AND T9520S_TimeSheetInfo.AccrualAndDeductionType.Type = &_Type";
	
	Query.SetParameter("BeginDate", Parameters.BeginDate);
	Query.SetParameter("EndDate"  , Parameters.EndDate);
	Query.SetParameter("Company"  , Parameters.Company);
	Query.SetParameter("Branch"   , Parameters.Branch);
	Query.SetParameter("_Type"     , Parameters._Type);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	While QuerySelection.Next() Do
		NewRow = ResultTable.Add();
		FillPropertyValues(NewRow, QuerySelection);
		NewRow[Parameters.TypeColumnName] = QuerySelection.AccrualAndDeductionType;
		
		If Upper(QuerySelection.AccrualAndDeductionType.AlgorithmID) = Upper("_MonthlySalary") Then
			NewRow.Amount = _MonthlySalary(Parameters, QuerySelection);
		EndIf;
		
		If Not ValueIsFilled(NewRow.Amount) Then
			NewRow.Amount = 0;
		EndIf;
	EndDo;
	
	GroupColumn = "Employee, Position, ProfitLossCenter, " + Parameters.TypeColumnName;
	SumColumn = "Amount";
	
	ResultTable.GroupBy(GroupColumn, SumColumn);
	ResultTable.Sort("Employee, Position, " + Parameters.TypeColumnName);
	
	Return New Structure("Table, GroupColumn, SumColumn", ResultTable, GroupColumn, SumColumn);
EndFunction

Function _MonthlySalary(Parameters, QuerySelection)
	Value = SalaryServer.GetAccualAndDeductionValue(QuerySelection.Date, 
			QuerySelection.Employee,
			QuerySelection.Position,
			QuerySelection.AccrualAndDeductionType);
		
	TotalDays = SalaryServer.GetWorkDays(Parameters.BeginDate,
			Parameters.EndDate,
			QuerySelection.AccrualAndDeductionType);
		
	CountDays = SalaryServer.GetCountDays(QuerySelection.Date,
			Parameters.Company,
			Parameters.Branch,
			QuerySelection.Employee,
			QuerySelection.Position,
			QuerySelection.AccrualAndDeductionType);
	
	If Not ValueIsFilled(Value) Then
		Return 0;
	EndIf;
	
	If Not ValueIsFilled(TotalDays) Then
		Return 0;
	EndIf;
	
	If Not ValueIsFilled(CountDays) Then
		Return 0;
	EndIf;
	
	Return (Value / TotalDays) * CountDays;
EndFunction

Function PutChoiceDataToServerStorage(ChoiceData, FormUUID) Export
	ValueTable = New ValueTable();
	ValueTable.Columns.Add("Employee");
	ValueTable.Columns.Add("PaymentPeriod");
	ValueTable.Columns.Add("NetAmount");
	ValueTable.Columns.Add("TotalAmount");
	
	For Each Row In ChoiceData Do
		NewRow = ValueTable.Add();
		FillPropertyValues(NewRow, Row);
		NewRow.NetAmount  = Row.Amount;
		NewRow.TotalAmount = Row.Amount;
	EndDo;
	GroupColumn = "Employee, PaymentPeriod";
	SumColumn = "NetAmount, TotalAmount";
	ValueTable.GroupBy(GroupColumn, SumColumn);
	Address = PutToTempStorage(ValueTable, FormUUID);
	Return New Structure("Address, GroupColumn, SumColumn", Address, GroupColumn, SumColumn);
EndFunction
