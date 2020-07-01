
#Region Public

#Region Get

Function GetUsersAndUserGroupsByReportOption(Val ReportOption) Export
	ReturnValue = New Array;
	Query = New Query;
	Query.Text = "SELECT ALLOWED
	|	SharedReportOptions.UserOrGroup As Ref
	|FROM
	|	InformationRegister.SharedReportOptions AS SharedReportOptions
	|WHERE
	|	SharedReportOptions.ReportOption = &ReportOption";
	Query.SetParameter("ReportOption", ReportOption);
	QueryExecution = Query.Execute();
	If Not QueryExecution.IsEmpty() Then
		QueryUnload = QueryExecution.Unload();
		ReturnValue = QueryUnload.UnloadColumn("Ref");
	EndIf;
	Return ReturnValue;
EndFunction

Function GetUsersByReportOption(Val ReportOption) Export
	ReturnValue = New Array;
	Query = New Query;
	Query.Text = "SELECT ALLOWED
	|	SharedReportOptions.UserOrGroup As Ref
	|FROM
	|	InformationRegister.SharedReportOptions AS SharedReportOptions
	|WHERE
	|	SharedReportOptions.UserOrGroup REFS Catalog.Users
	|	AND SharedReportOptions.ReportOption = &ReportOption";
	Query.SetParameter("ReportOption", ReportOption);
	QueryExecution = Query.Execute();
	If Not QueryExecution.IsEmpty() Then
		QueryUnload = QueryExecution.Unload();
		ReturnValue = QueryUnload.UnloadColumn("Ref");
	EndIf;
	Return ReturnValue;
EndFunction

Function GetUserGroupsByReportOption(Val ReportOption) Export
	ReturnValue = New Array;
	Query = New Query;
	Query.Text = "SELECT ALLOWED
	|	SharedReportOptions.UserOrGroup As Ref
	|FROM
	|	InformationRegister.SharedReportOptions AS SharedReportOptions
	|WHERE
	|	SharedReportOptions.UserOrGroup REFS Catalog.UserGroups
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
	CurrentSharedUsers = GetUsersByReportOption(ReportOption);
	
	TempValueTable.Clear();
	For Each Item In CurrentSharedUsers Do
		TempValueTableRow = TempValueTable.Add();
		TempValueTableRow.Ref = Item;
	EndDo;
	TempValueTable.Sort("Ref");
	CurrentSharedUsersSorted = TempValueTable.UnloadColumn("Ref");
	CurrentSharedUsersSortedVal = ValueToStringInternal(CurrentSharedUsersSorted);
	
	TempValueTable.Clear();
	For Each Item In UsersArray Do
		TempValueTableRow = TempValueTable.Add();
		TempValueTableRow.Ref = Item;
	EndDo;
	TempValueTable.Sort("Ref");
	UsersSorted = TempValueTable.UnloadColumn("Ref");
	UsersSortedVal = ValueToStringInternal(UsersSorted);
	
	If CurrentSharedUsersSortedVal = UsersSortedVal Then
		Return;
	EndIf;
	
	Query = New Query;
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
			SharedReportOptionsSetRecord.UserOrGroup = Item;
		EndDo
	EndIf;
	SharedReportOptionsSet.Write();
	
EndProcedure

#EndRegion

#EndRegion