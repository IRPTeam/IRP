#Region Public

#Region Get

Function GetUsersByReportOption(Val ReportOption) Export
	ReturnValue = New Array();
	Query = New Query();
	Query.Text = "SELECT ALLOWED
				 |	SharedReportOptions.User As Ref
				 |FROM
				 |	InformationRegister.SharedReportOptions AS SharedReportOptions
				 |WHERE
				 |	SharedReportOptions.User REFS Catalog.Users
				 |	AND SharedReportOptions.ReportOption = &ReportOption";
	Query.SetParameter("ReportOption", ReportOption);
	QueryExecution = Query.Execute();
	If Not QueryExecution.IsEmpty() Then
		QueryUnload = QueryExecution.Unload();
		ReturnValue = QueryUnload.UnloadColumn("Ref");
	EndIf;
	Return ReturnValue;
EndFunction

#EndRegion

#Region Set

Procedure SetUsersToReportOption(Val ReportOption, Val UsersArray) Export

	If Not UsersArray.Count() Then
		SharedReportOptionsSet = InformationRegisters.SharedReportOptions.CreateRecordSet();
		SharedReportOptionsSet.Filter.ReportOption.Set(ReportOption);
		SharedReportOptionsSet.Write();
	EndIf;

	TempValueTable = New ValueTable();
	TempValueTable.Columns.Add("Ref", New TypeDescription("CatalogRef.Users"));
	CurrentShaReducers = GetUsersByReportOption(ReportOption);

	TempValueTable.Clear();
	For Each Item In CurrentShaReducers Do
		TempValueTableRow = TempValueTable.Add();
		TempValueTableRow.Ref = Item;
	EndDo;
	TempValueTable.Sort("Ref");
	CurrentShaReducersSorted = TempValueTable.UnloadColumn("Ref");
	CurrentShaReducersSortedVal = ValueToStringInternal(CurrentShaReducersSorted);

	TempValueTable.Clear();
	For Each Item In UsersArray Do
		TempValueTableRow = TempValueTable.Add();
		TempValueTableRow.Ref = Item;
	EndDo;
	TempValueTable.Sort("Ref");
	UsersSorted = TempValueTable.UnloadColumn("Ref");
	UsersSortedVal = ValueToStringInternal(UsersSorted);

	If CurrentShaReducersSortedVal = UsersSortedVal Then
		Return;
	EndIf;

	Query = New Query();
	Query.Text = "SELECT ALLOWED
				 |	Users.Ref
				 |FROM
				 |	Catalog.Users AS Users";
	BaseUsers = Query.Execute().Unload();
	BaseUsers.Sort("Ref");
	BaseUsersSorted = BaseUsers.UnloadColumn("Ref");
	BaseUsersSortedVal = ValueToStringInternal(BaseUsersSorted);

	SharedReportOptionsSet = InformationRegisters.SharedReportOptions.CreateRecordSet();
	SharedReportOptionsSet.Filter.ReportOption.Set(ReportOption);
	SharedReportOptionsSet.Write();
	If BaseUsersSortedVal = UsersSortedVal Then
		SharedReportOptionsSetRecord = SharedReportOptionsSet.Add();
		SharedReportOptionsSetRecord.ReportOption = ReportOption;
	Else
		For Each Item In UsersArray Do
			SharedReportOptionsSetRecord = SharedReportOptionsSet.Add();
			SharedReportOptionsSetRecord.ReportOption = ReportOption;
			SharedReportOptionsSetRecord.User = Item;
		EndDo;
	EndIf;
	SharedReportOptionsSet.Write();

EndProcedure

#EndRegion

#EndRegion